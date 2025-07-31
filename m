Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFA9C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4706B008C; Thu, 31 Jul 2025 18:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65246B0092; Thu, 31 Jul 2025 18:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3256B0093; Thu, 31 Jul 2025 18:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 896F76B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:00:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FB4D114D2C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:37 +0000 (UTC)
X-FDA: 83725929714.20.5F4E5C1
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B56318000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=buDh7+8Q;
	spf=pass (imf06.hostedemail.com: domain of 3geeLaAYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3geeLaAYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999235; a=rsa-sha256;
	cv=none;
	b=lezxAAnr16frhOGom04yCsrmTUaqsfnOTMflFxsBZMVVkfRpKWwErc8PVzfqKEU26m/kxw
	2gTpeRJIwCg3f14GAucoh3hs2qxPFNH1bhenlTrc7mjRajJPKA05D5AKJ2rWKBkHNCp7B8
	uAKRg3JKESe0uSxQpzzjJoASLT1sUI0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=buDh7+8Q;
	spf=pass (imf06.hostedemail.com: domain of 3geeLaAYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3geeLaAYKCMo8A7u3rw44w1u.s421y3AD-220Bqs0.47w@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSpqmXgbYV8j5bsB4IVuVf0tack8DQaHL/QU05OaXgY=;
	b=RKG1EV50qlJFNOs+D4VoZvfrJ70rXsVR2Ds2NPlBjXwzAZWj0E/4iCzRMRpLck3WmDzONF
	ZJgCcTLAEz0n+WTaBKjT/k764dVY7Tg7ZRzWPvPF6RJrnysiO6x53SA6nEP45fIKIcO/XW
	4LTgkxwzufFIEaCtEbkq6p4210lViqA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2407248a180so6700295ad.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753999234; x=1754604034; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vSpqmXgbYV8j5bsB4IVuVf0tack8DQaHL/QU05OaXgY=;
        b=buDh7+8QSXnF4amqkLqdQtpZH76z2/iJq6kt3TOi5RVPMnyxkMfyZcwaIrEFIWsfgN
         BZgAdh8T8jx05B8r93qTIQWUzaB0PWGdhqXqMcWGiiwYc/4Umphb0cgkv6Uw3bwJ7VsR
         tE7IbipMFz8fbtK4Bv5mt9QA4Vq5IyF2uttyHHc2AuhTonLB5kLWpru+YrOE1+9YEba6
         aTegWTx2iRzx0+R8thLup+wLTor3PJuFePCmjCSbQRYYeMLuzJJO86e659zDyA1EbGfk
         Kcwjv2gQyn7/g3HLFUrDBakFqw6YehfRY1KEBd2wEqA08tVKb/7T0vJsqDu3zPanqw1j
         CPgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999234; x=1754604034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSpqmXgbYV8j5bsB4IVuVf0tack8DQaHL/QU05OaXgY=;
        b=wxFGsnBU6hEYDkaDbjuJS3pPLf7+Vf+L2UW8hRZ0At1ps53NoCEqSYzoZZg8CT83xq
         58FU8/JbSg7VXoFfCsGTbOjxdLJ4n2Q6R66D1Ejo0bCipGuYoBwWeLofwkaLA/6+SQF0
         1BuMgSjDF0+qfDd/7LPBUaKQOa7zw+fe+mqF6vVTa6UAKIb/5Un8ls3qniKox78pHdpa
         Ec79UQcDorCRgBDuNAfqelGe2ffIlgiGPHhHqSI0+6GISbJnx8qVlqcB9uWW+KWs2WRS
         HDmYokGWVqOed3wf2YJ4Sv8Vwt4QGUnqAWKbD7xTh3XzoPv1gT6McE4clBC7k3afO9vm
         UsAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBG5fE5Z7VGH5FiE4Xtjl7EfhB+Pl1CbAYdzzUlRgt88dcV28J00gYPyatBPVTVhfQzFBQJjxfMQ==@kvack.org
X-Gm-Message-State: AOJu0YzO72mrNAKxN1EYEg4TAmhhnhlaMmCeSK/G7PUq7U971OV1JIRm
	SNHM0nYLy8nI8UuUalRvkSBZ4mEu0Z+BysRVaTeDyqg0t7qDD9COf1PXNhWLCA9CQ/gnevdme5X
	n8lnHcA==
X-Google-Smtp-Source: AGHT+IG9WPhm5XE/ZfgGaQtzh+SWoXfTwZ/PnXrEVOaIZ7eiVoVCEnZsOmLu+uDuAMPetyxG7jZDFNEKyv8=
X-Received: from plai12.prod.google.com ([2002:a17:902:c94c:b0:240:2b97:90f6])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:234d:b0:23f:adc0:8cc2
 with SMTP id d9443c01a7336-2422a699c3amr3040655ad.27.1753999233810; Thu, 31
 Jul 2025 15:00:33 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:00:24 -0700
In-Reply-To: <20250731220024.702621-1-surenb@google.com>
Mime-Version: 1.0
References: <20250731220024.702621-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731220024.702621-4-surenb@google.com>
Subject: [PATCH 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under
 per-vma locks
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B56318000B
X-Stat-Signature: kssk856n8booku15yazooeem9w5qhpyt
X-HE-Tag: 1753999234-885074
X-HE-Meta: U2FsdGVkX18ckNeTHLt6ljrNIvoPkWP6SL6JgrNpqTnFmVmvi/uypOhFskJQlyeK6r94smpkJI1naOL8zhOS2iZzANzCDvdMZneHo+E5AhV0c/i/NUImD9DLtpE6LbC1PRP9fGrmYh516m3TJxKAAUF7KMmFS4mVX6H4JCxrG9ml7opSkriisqf3iLSVX6TfqvKU3phdWTm1d35J2Wwq54xlySYw13vIniWYd3rEQ9m4eH3KOG3lL7t2aI60e/6Aloe7tSBmwUlcZJ584SVdjcc4ztvcrkCI57zioa51MR6e8+H7jfTlZ5ZGfe/H6BQ7/0vWoUV8Z0YBOYlT5MkRCeoS9GRrYjBSBln+0rLfflTwFeLvSPc4hS0Klv0iziiWVZ70kGHr7E3P/IiAiziGYaR4fUvU03cKtqPGw8mWnC5bTfaTNNBLjJ5npVArvpkXXIHRCY4ihXrVHGDfa7tIHetMY93zokms0FJobR2QbUShuNT9Kp+vdPN03K0P5uI1isoOwYoh1G4gj+uAceLj3swAxZk8vTHcv/cjdqfUEuCGzMtNKmhB6EKlMTb3O1bzxSc10+nBTe++Ufgs1YFyP+JrC4TQOILlHzWVAb7gZINfgpxVfFtkRnKzFFQq85kJ9jR6nqqmdtwS/qa7ZbBaqIOYP0ovJD4JGn+bdpln4B8avnkJvwUPJ2mTJi77fiMhH/7NpeZfrYVnCC4ZfQg5YtvkjGT8yYiUf8FqZiaS+t3g0fAgft2kLN09iTCXopQMnwANl5ep5rC3TgxluxGKzwvPe9mESdzCxTn8/EXW97ua2Esg1DnM3DjcwnHEYm9keEY/ifUiRLUWs8km5FJtV9rLDgmwRi0DsKE18APc9OZTlfnbtEaqfXCy8533gK+jMkW8xX8neLHifhKU0aiMznH2yQUAP6Flgz6MTL+VMh9AjjrioS2kFMKYNUzSlwVgy7kzUqYt9pl7/aWjlDZ
 s5q2LHUR
 fEXOgbwtnZuxIvmoBozTuJpMB1ZEa+2xbZxm88LcFMcve1OqcbBCS2wYR9gyIo9kn+I8owUsbX9fkod5gRdZs9Df4MkZBqJiARtzSoOFOntzVV4Q+4NGEVo88cSaqaw2M5WXbShuQZhO+SqV2BhsNrHvySTMsQx/fMl6xddFxJJLhaoqCIzDIEIOmOJ8mEHvSsYluhDLv0uNX/SAme1bAkO7UA3JoD1F+r2nyOYZwacNZGTHXRWnV3YYA//QnHkmmGBxZj6PlVFuF8fjR0CYU3bWSZOpwIEsZVsXFpmq43IZqm2W5CQ7y9lpCPQP50GqX/8uWRBWRUaX/sIXB/97HJSV2x5/yeStvORoDB358u6uViEaUFpgIXzAkCmttJjcapgdYzrePLIAAcW1T6Gkock8QiU0jWr4Os8iuETnLEcR7xYYSXCvOCzMA/JHXJfEaQMswaZSOrskP74eaLVU8Ws2aOnYG9UU+z3icXoUs468nG7CXIpc2gSHdKK6C5HBc+76wA0HNN3aT3Li44DbrNZBWGrQZ0SQ3/i/MKHrNGwVYcHwh7wAE+8qAdGIt6Ha/yj5/DpT3/J4qCQvSD045zRMoYAUaQ7T7ea9WJUe/L9g2Ezr0APgRdgFM8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Utilize per-vma locks to stabilize vma after lookup without taking
mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
contended, we fall back to mmap_lock but take it only momentarily
to lock the vma and release the mmap_lock. In a very unlikely case
of vm_refcnt overflow, this fall back path will fail and ioctl is
done under mmap_lock protection.

This change is designed to reduce mmap_lock contention and prevent
PROCMAP_QUERY ioctl calls from blocking address space updates.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 81 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 509fa162760a..b504b798e8fe 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -517,28 +517,78 @@ static int pid_maps_open(struct inode *inode, struct file *file)
 		PROCMAP_QUERY_VMA_FLAGS				\
 )
 
-static int query_vma_setup(struct mm_struct *mm)
+#ifdef CONFIG_PER_VMA_LOCK
+
+static int query_vma_setup(struct proc_maps_query_data *query)
 {
-	return mmap_read_lock_killable(mm);
+	query->locked_vma = NULL;
+	query->mmap_locked = false;
+
+	return 0;
 }
 
-static void query_vma_teardown(struct mm_struct *mm, struct vm_area_struct *vma)
+static void query_vma_teardown(struct proc_maps_query_data *query)
 {
-	mmap_read_unlock(mm);
+	if (query->mmap_locked)
+		mmap_read_unlock(query->mm);
+	else
+		unlock_vma(query);
 }
 
-static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct *mm, unsigned long addr)
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_query_data *query,
+						     unsigned long addr)
 {
-	return find_vma(mm, addr);
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+
+	unlock_vma(query);
+	rcu_read_lock();
+	vma_iter_init(&vmi, query->mm, addr);
+	vma = lock_next_vma(query->mm, &vmi, addr);
+	rcu_read_unlock();
+
+	if (!IS_ERR_OR_NULL(vma)) {
+		query->locked_vma = vma;
+	} else if (PTR_ERR(vma) == -EAGAIN) {
+		/* Fallback to mmap_lock on vma->vm_refcnt overflow */
+		mmap_read_lock(query->mm);
+		vma = find_vma(query->mm, addr);
+		query->mmap_locked = true;
+	}
+
+	return vma;
 }
 
-static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
+#else /* CONFIG_PER_VMA_LOCK */
+
+static int query_vma_setup(struct proc_maps_query_data *query)
+{
+	return mmap_read_lock_killable(query->mm);
+}
+
+static void query_vma_teardown(struct proc_maps_query_data *query)
+{
+	mmap_read_unlock(query->mm);
+}
+
+static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_query_data *query,
+						     unsigned long addr)
+{
+	return find_vma(query->mm, addr);
+}
+
+#endif  /* CONFIG_PER_VMA_LOCK */
+
+static struct vm_area_struct *query_matching_vma(struct proc_maps_query_data *query,
 						 unsigned long addr, u32 flags)
 {
 	struct vm_area_struct *vma;
 
 next_vma:
-	vma = query_vma_find_by_addr(mm, addr);
+	vma = query_vma_find_by_addr(query, addr);
+	if (IS_ERR(vma))
+		return vma;
+
 	if (!vma)
 		goto no_vma;
 
@@ -579,11 +629,11 @@ static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
 	return ERR_PTR(-ENOENT);
 }
 
-static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
+static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 {
+	struct proc_maps_query_data query = { .mm = mm };
 	struct procmap_query karg;
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
 	const char *name = NULL;
 	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
@@ -610,17 +660,16 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->query.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
-	err = query_vma_setup(mm);
+	err = query_vma_setup(&query);
 	if (err) {
 		mmput(mm);
 		return err;
 	}
 
-	vma = query_matching_vma(mm, karg.query_addr, karg.query_flags);
+	vma = query_matching_vma(&query, karg.query_addr, karg.query_flags);
 	if (IS_ERR(vma)) {
 		err = PTR_ERR(vma);
 		vma = NULL;
@@ -705,7 +754,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	}
 
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&query);
 	mmput(mm);
 
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
@@ -725,7 +774,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	return 0;
 
 out:
-	query_vma_teardown(mm, vma);
+	query_vma_teardown(&query);
 	mmput(mm);
 	kfree(name_buf);
 	return err;
@@ -738,7 +787,7 @@ static long procfs_procmap_ioctl(struct file *file, unsigned int cmd, unsigned l
 
 	switch (cmd) {
 	case PROCMAP_QUERY:
-		return do_procmap_query(priv, (void __user *)arg);
+		return do_procmap_query(priv->query.mm, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.50.1.565.gc32cd1483b-goog


