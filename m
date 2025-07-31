Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF969C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 22:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B916B008A; Thu, 31 Jul 2025 18:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4238C6B008C; Thu, 31 Jul 2025 18:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339D26B0092; Thu, 31 Jul 2025 18:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E53A6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 18:00:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD647810A9
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:34 +0000 (UTC)
X-FDA: 83725929588.04.58CB23F
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E149C0008
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:00:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Oz6E4unr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3f-eLaAYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3f-eLaAYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753999233; a=rsa-sha256;
	cv=none;
	b=52o2HlIYdMd5tUmIZFcJlpLYB3tX5orUHCRUcCfnUwkeL/Bu34YfnxNpEMIpOqE77Aed+v
	zNwgKCIpkPx0jASfQxpfeQB0pnzPpp8Eg9Ks9nesQn+HJaGkk54kekqSbdru8GDlV7/xZ6
	cWAEuXA0dQjPWBiKSNojJNRWXlAlKms=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Oz6E4unr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3f-eLaAYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3f-eLaAYKCMg685s1pu22uzs.q20zw18B-00y9oqy.25u@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753999233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3nszwvCvPWAmHYDsSOEe6+RDYFjtctgvzjemTCKIEM=;
	b=30tXwK2pqPG1eN0uUP3pr7VjUFxZZRn5o9o0T7KO4HdbU988SMaDYEPjj497YqaTsdMdTr
	uaCQ2BIG+TGkN1meRdH0jw4hSQ4yxLXqvlpuBL5vcGicafa8yA+YoQM4glijZSEqW6B9Mm
	y/AVDH5RkP0Ixy0vOCpnvd4ycsiccYo=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-240607653f4so1756225ad.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753999232; x=1754604032; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3nszwvCvPWAmHYDsSOEe6+RDYFjtctgvzjemTCKIEM=;
        b=Oz6E4unrkN6opjlUDIcJVRbwSzuTH0rD5hDRLEFum6VG03u7LxC5ESzd23GAHD2ZTF
         jQmwASpOmXwpXR2nuUMQAo4Lwe0H3GiX/BiaPBTE62JB8ikIbshzAmsDrtU8iOW72pDu
         5srJP8ExYmRMJcxYxIq07xx184tBgpiTPPvfcd0gbwwRiuBOOQXMdcNtAtzboQASzO8w
         UxvHR6M27svxGrvwwIIEEIcFAxrvuWWosGNJ8rDha31ihh55zbegc5T4vpA6aTFpDTCk
         RwT5gUvYThO94jcC5p68uOYQn+W3CF3q77XMoEpk4ljc/Q0K0K0/vPlNHysPxZOwkT/+
         OiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753999232; x=1754604032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c3nszwvCvPWAmHYDsSOEe6+RDYFjtctgvzjemTCKIEM=;
        b=XLNQHJZ02zyL4ULQ21CE/rWRQarVN7AHrgNUyIJeWc6sKjaf0lk6Ww0IKiLd1dl/ll
         8s4XTfnFUxtFScS9ZFY6iGXb84HFu79pG6lxVwyjei0W6gdwxTEplmqo6qgk1KttvKQV
         U2x8nmyWx+JonsmxvZe+cudNdFPkEHRVuJFhDEz5bidkdNiecwMCv7ttVQs4NXZakAx3
         tJnvdDgIOU9DKEEDE65skWpBL2oYoJff6mefBns4covVHolxHNckt+PFzSl3J22vLKDE
         Pp1hE4+0uUz6jz3J/xOicFo0egKiAdzKRQHd+5ee/oZZ8lLrfi0dLyVPVSMSY7bTdHKd
         M1uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXO5KhquGqBPgPcms2zwQdj91pemiTrGVMWwekB4YnqMh2dgCT8IWH9SoUlJvnN3xIxWtApjPj4tA==@kvack.org
X-Gm-Message-State: AOJu0Yzr0BlhmG10CEI0jQqsoBafhjFIBeJ6P8T8QxvhfcTWKxti0p/S
	Z+tHKpaheAuhbx65Y/vbFdD2keFXT+xd5VLe0iH6IBMIPH5Z9BxnsKWy+iVdch3zKGReR2C7so5
	kSRFNZA==
X-Google-Smtp-Source: AGHT+IEe6D0EDOa4VLSLQnNt443QGZdBsTsucswGzk0sXMtaRnOh2OfcwLIsh8g7TBhjLjlnLUKia1iuw4c=
X-Received: from plbka16.prod.google.com ([2002:a17:903:3350:b0:240:9ca:fc49])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc50:b0:234:ef42:5d65
 with SMTP id d9443c01a7336-24096c0dcf7mr124221755ad.52.1753999231880; Thu, 31
 Jul 2025 15:00:31 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:00:23 -0700
In-Reply-To: <20250731220024.702621-1-surenb@google.com>
Mime-Version: 1.0
References: <20250731220024.702621-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731220024.702621-3-surenb@google.com>
Subject: [PATCH 2/3] fs/proc/task_mmu: factor out proc_maps_private fields
 used by PROCMAP_QUERY
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E149C0008
X-Stat-Signature: roewcdygbudecuwh49b9gri6grpiqa1b
X-HE-Tag: 1753999232-193743
X-HE-Meta: U2FsdGVkX1/wuoCCwImrATTY802C3nEow0+fQo5/jKUxUEGwBdumhwRrm1B1XoN7eyfwqse/P1/Psz7UMoI9WVJZ/TF3ga9Mt9eKL8XR1avI/ZBQ+pW2Nmdb3x56ML6f6qdHgcXvW8lcjW3TrDYRsgS31VnpwfweJ1+K9jCYjpcCSbLDHwCbn/FzYyEziArxdNKh0D2LqFxqktiyjefoTIdTj3f5ZILuRhpwygPiUo5PcwBgocJHUuz/49QHfMIuabQQxZSceg/0Wh4T5W8CHEDuI155hAnUovQ69k8q2NpORgYeWZOCBVP1JqpSs7cKJuOwaVYqDn9dQjc39L79RLW6Uodx0UdjpNmHS/+6liTg8f6S1TokCZR3s3cISv8xZaZgBAdlrFT4iwr6Bb4XDxSIpDzLjjldczKXS5Q/wucoly+yefHQzt3lTXsVPPV+xAeukJdYj+KEX80rjF/wff0uaYYEZNlh3CSwgtvTCCnDS756vTIUSfA6IKdAUD/qM3IL83Pm5IAIoR+uq9GXz+1B5+wBJjt6Ud8Bsx5zQU93VGLaBdMn3VWFq/MbtD+D6iVHoVZUw2IbRPfmeVLU3rYkN4bRStg98H8KQgfGazk2w1MorXjIhOsPHXTgOLzZ/C7eCLcT0yOG+vaVUaAvjAqRdfFzbtag/C7xDYzZH3H7885GVca4yFWAWB8VXO0X219Refj1aEo90zDgWURB4aINBREIBOesoi/2XNvd9NBgu7wzb4nTngzqlQ9mjXae2FW8Wnsmk/7U1+tJRsaDENb5dg+mWTbSi9M4tIkqEGqP+r2yFFNVyiVBG62d9t0fvKV7GEDbgphDkFqcooVht6IvSo1z+mV6Zre1v8rhXdUkYiYcT0w+AQr5l70LeNFZ18UxG3ENzLyrrE53Y/HaMKs4doYpgRDl7izwExGtnKp3B3wWqmUKyvjAmTHgpJqvmZam/VcXyOZwJJ02lhh
 m2oi+c4R
 x03EQq8XGTOjAq+AGok8ZzFaddBR0N42CXUQ9hmFMP8iY1qV2vwGR9AGS+d2XZsn1s0Rnd/DsMdIBNKmq7hIC78/D8007AYIStNrFODSX80Wx0MxKDiLfK1ztKC0470BVr4M301xnCogrtAsKwBsnaeBh8VJf64kSIwVVooAxu3WdUEy6brpcXIdhTHsfemEkuG4lBQbN/17J7EFjqBVNK+i9P+yAXuDuAd9i00rWaMLpRozVBrTE5+Fx0XpILihENdQQdNPM2H4dyE6pvuv4KlyclZ3vG5qSMzR4LYUFmhXIIsmejpH/YglX4RIsI4L+K/Vy/OLRiCnmks+ZiL8v7NR2Qx9ouaFFeU5CaWlY7TKYeFADjWwW2R6su5N2H0cg3NT+zggsuxwpvmLCPPrnufRo126bq7W3FUpDmVVYPUamERPFu87oE2ms+/qA35IQMujRFB+2tGXRmQd7keucearmiS+tct53JfXpzZxFVsbwMXR7k9Abqhp+wXTir+LJggpUTQ/w0tBOfbkjoTYoA0+QRUCFcLd3FzgjxxVv/UOuzxY/esai0AKAdy6D+dEboDb5w2GOWwwGkiVNY/2nhiJOMA2JPk9snz+gufoFKB6Kp8hPXSlFoRSy6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
ioctl are moved into a separate structure. In the next patch this allows
ioctl to reuse some of the functions used for reading /proc/pid/maps
without using file->private_data. This prevents concurrent modification
of file->private_data members by ioctl and /proc/pid/maps readers.

The change is pure code refactoring and has no functional changes.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/internal.h | 15 ++++++----
 fs/proc/task_mmu.c | 70 +++++++++++++++++++++++-----------------------
 2 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 7c235451c5ea..e2447b22592e 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -379,16 +379,21 @@ extern void proc_self_init(void);
  * task_[no]mmu.c
  */
 struct mem_size_stats;
-struct proc_maps_private {
-	struct inode *inode;
-	struct task_struct *task;
+
+struct proc_maps_query_data {
 	struct mm_struct *mm;
-	struct vma_iterator iter;
-	loff_t last_pos;
 #ifdef CONFIG_PER_VMA_LOCK
 	bool mmap_locked;
 	struct vm_area_struct *locked_vma;
 #endif
+};
+
+struct proc_maps_private {
+	struct inode *inode;
+	struct task_struct *task;
+	struct vma_iterator iter;
+	loff_t last_pos;
+	struct proc_maps_query_data query;
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3d6d8a9f13fc..509fa162760a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -132,11 +132,11 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
 
 #ifdef CONFIG_PER_VMA_LOCK
 
-static void unlock_vma(struct proc_maps_private *priv)
+static void unlock_vma(struct proc_maps_query_data *query)
 {
-	if (priv->locked_vma) {
-		vma_end_read(priv->locked_vma);
-		priv->locked_vma = NULL;
+	if (query->locked_vma) {
+		vma_end_read(query->locked_vma);
+		query->locked_vma = NULL;
 	}
 }
 
@@ -151,14 +151,14 @@ static inline bool lock_vma_range(struct seq_file *m,
 	 * walking the vma tree under rcu read protection.
 	 */
 	if (m->op != &proc_pid_maps_op) {
-		if (mmap_read_lock_killable(priv->mm))
+		if (mmap_read_lock_killable(priv->query.mm))
 			return false;
 
-		priv->mmap_locked = true;
+		priv->query.mmap_locked = true;
 	} else {
 		rcu_read_lock();
-		priv->locked_vma = NULL;
-		priv->mmap_locked = false;
+		priv->query.locked_vma = NULL;
+		priv->query.mmap_locked = false;
 	}
 
 	return true;
@@ -166,10 +166,10 @@ static inline bool lock_vma_range(struct seq_file *m,
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	if (priv->mmap_locked) {
-		mmap_read_unlock(priv->mm);
+	if (priv->query.mmap_locked) {
+		mmap_read_unlock(priv->query.mm);
 	} else {
-		unlock_vma(priv);
+		unlock_vma(&priv->query);
 		rcu_read_unlock();
 	}
 }
@@ -179,13 +179,13 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 {
 	struct vm_area_struct *vma;
 
-	if (priv->mmap_locked)
+	if (priv->query.mmap_locked)
 		return vma_next(&priv->iter);
 
-	unlock_vma(priv);
-	vma = lock_next_vma(priv->mm, &priv->iter, last_pos);
+	unlock_vma(&priv->query);
+	vma = lock_next_vma(priv->query.mm, &priv->iter, last_pos);
 	if (!IS_ERR_OR_NULL(vma))
-		priv->locked_vma = vma;
+		priv->query.locked_vma = vma;
 
 	return vma;
 }
@@ -193,14 +193,14 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
 static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 					 loff_t pos)
 {
-	if (priv->mmap_locked)
+	if (priv->query.mmap_locked)
 		return false;
 
 	rcu_read_unlock();
-	mmap_read_lock(priv->mm);
+	mmap_read_lock(priv->query.mm);
 	/* Reinitialize the iterator after taking mmap_lock */
 	vma_iter_set(&priv->iter, pos);
-	priv->mmap_locked = true;
+	priv->query.mmap_locked = true;
 
 	return true;
 }
@@ -210,12 +210,12 @@ static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
 static inline bool lock_vma_range(struct seq_file *m,
 				  struct proc_maps_private *priv)
 {
-	return mmap_read_lock_killable(priv->mm) == 0;
+	return mmap_read_lock_killable(priv->query.mm) == 0;
 }
 
 static inline void unlock_vma_range(struct proc_maps_private *priv)
 {
-	mmap_read_unlock(priv->mm);
+	mmap_read_unlock(priv->query.mm);
 }
 
 static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
@@ -258,7 +258,7 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		*ppos = vma->vm_end;
 	} else {
 		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->mm);
+		vma = get_gate_vma(priv->query.mm);
 	}
 
 	return vma;
@@ -278,7 +278,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	if (!priv->task)
 		return ERR_PTR(-ESRCH);
 
-	mm = priv->mm;
+	mm = priv->query.mm;
 	if (!mm || !mmget_not_zero(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
@@ -318,7 +318,7 @@ static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->query.mm;
 
 	if (!priv->task)
 		return;
@@ -339,9 +339,9 @@ static int proc_maps_open(struct inode *inode, struct file *file,
 		return -ENOMEM;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->query.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->query.mm)) {
+		int err = priv->query.mm ? PTR_ERR(priv->query.mm) : -ESRCH;
 
 		seq_release_private(inode, file);
 		return err;
@@ -355,8 +355,8 @@ static int proc_map_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->query.mm)
+		mmdrop(priv->query.mm);
 
 	return seq_release_private(inode, file);
 }
@@ -610,7 +610,7 @@ static int do_procmap_query(struct proc_maps_private *priv, void __user *uarg)
 	if (!!karg.build_id_size != !!karg.build_id_addr)
 		return -EINVAL;
 
-	mm = priv->mm;
+	mm = priv->query.mm;
 	if (!mm || !mmget_not_zero(mm))
 		return -ESRCH;
 
@@ -1307,7 +1307,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
 	struct mem_size_stats mss = {};
-	struct mm_struct *mm = priv->mm;
+	struct mm_struct *mm = priv->query.mm;
 	struct vm_area_struct *vma;
 	unsigned long vma_start = 0, last_vma_end = 0;
 	int ret = 0;
@@ -1452,9 +1452,9 @@ static int smaps_rollup_open(struct inode *inode, struct file *file)
 		goto out_free;
 
 	priv->inode = inode;
-	priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
-	if (IS_ERR_OR_NULL(priv->mm)) {
-		ret = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->query.mm = proc_mem_open(inode, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(priv->query.mm)) {
+		ret = priv->query.mm ? PTR_ERR(priv->query.mm) : -ESRCH;
 
 		single_release(inode, file);
 		goto out_free;
@@ -1472,8 +1472,8 @@ static int smaps_rollup_release(struct inode *inode, struct file *file)
 	struct seq_file *seq = file->private_data;
 	struct proc_maps_private *priv = seq->private;
 
-	if (priv->mm)
-		mmdrop(priv->mm);
+	if (priv->query.mm)
+		mmdrop(priv->query.mm);
 
 	kfree(priv);
 	return single_release(inode, file);
-- 
2.50.1.565.gc32cd1483b-goog


