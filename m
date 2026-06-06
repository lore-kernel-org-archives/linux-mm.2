Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B163CD8C88
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 01:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871886B0005; Fri,  5 Jun 2026 21:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8220D6B008A; Fri,  5 Jun 2026 21:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711786B008C; Fri,  5 Jun 2026 21:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D40B6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:57:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07E981C182F
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:57:36 +0000 (UTC)
X-FDA: 84847826112.05.963A7EE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C2EA160007
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:57:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TaQgYn8x;
	spf=pass (imf08.hostedemail.com: domain of 3jH4jagYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jH4jagYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780711054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1d9I+KVhftNxuemtZnTHQgG/X/rMQMH6c1hS3FXahc0=;
	b=D5xFEgfSGqV6PEl9yUKZRLdqVc1bVriLZVdpSB3Q+uJa4t8iZKkZ8yfrwXSrqgwPpiMN8a
	AZRjINOn2J2mDlP5i/zrKeiE0gKFkLlYT1T5B/Y/03tlSzqBl2VP4IZf9cRgmQ8jf3e4sU
	N6gOFLPn4cEi0zI2OhrF4iNpZ+5sOEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780711054;
	b=HaYhJNB5hMrxwwp64/TTV5rjV529exrZwmVSpwgtN568pAP/QPMKtRcNZgMHNQVmESVSSP
	7xZkGYGl30Rk/72r3R56Hfr/Z9RcyhCmJjDP1rBHHEblTpaV/Q5jYyNS5ZF4Nm6Yfb/ULI
	cZ786xsGJPB4U5yi5xvkDOnzVVbLO8c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TaQgYn8x;
	spf=pass (imf08.hostedemail.com: domain of 3jH4jagYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3jH4jagYKCG8fheRaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c0c32faa62so44611645ad.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780711053; x=1781315853; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1d9I+KVhftNxuemtZnTHQgG/X/rMQMH6c1hS3FXahc0=;
        b=TaQgYn8x9QdKyxcssxEx/UvrfRBlt7U9F+hg0uggBawYHUE9XHx2kMv5jQXysMZazq
         MwvvYLQRw3c2HLZ+R1zfJ7qsMXQPSQaemZ8MNNyq9GaU3cF7bo8HI67x8tCl6sm8ruCN
         IBsSQnX6tqEjoGMugXV2qo+y3cwYesLN/t+hUKmCSIenqMmJBvzh3ncD1FRnv5N9Z43Z
         6qvLCM5K4CIvapNowBaCYc5UK+qATfgZ9suiHCW6unvQOuwuoZcZL9w+Te971fiYNtOy
         NK/pWptcqCE7CYeVsOLjVM6A/FE5IYfp9HLw+KBWScAUclmk6MC8ViagW9K0eVvHrKFe
         HwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780711053; x=1781315853;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1d9I+KVhftNxuemtZnTHQgG/X/rMQMH6c1hS3FXahc0=;
        b=BTMNVavm661d/Zz9iVj9n0lwkcp42F+Abr3fc3zfipNs5IpqWgCKcpKpExqNecWuSW
         A3h2V0SUvGKo8uIOpakwBTPvL2LC6Kgez4h7tZGMaEtrvg+VWXQ7M3Vkl9shaHWkteeP
         bT/Z8SvbtZKrPP8hErPYXuonrG/IBYSKKEtdx9F66/QIZvnQ7nSlwBcxFIuu4ou8Ghzm
         97F4jKE1YhevbYuy1i94rPynSyGOk5lfHuitPaXEUzPmC9r2XU9l6FQ5ghoTtU/WU3Wp
         UAk4o/poMiER+wJi+SJ6KXRkStZ9hql7aPrwz4AY3GZ3YJ2Afx/gYYw714y5O5sTR8m2
         e4Qg==
X-Forwarded-Encrypted: i=1; AFNElJ+mPgvF7f2gdjyJYOgqokOIPCV7u+enlp69bneVaqk3pzZ22rgYrZUzU4BYxsPUbxI3C8qZgCjrlA==@kvack.org
X-Gm-Message-State: AOJu0YwuED2lMwh4INEUPuasR7IyMahRh1dUjMWfeNPr5B63CJWX58e4
	WaceeJVvMQwV4wpI7nkIC/3nK5EZo0em+DfHdmgGSISz2uZKMAn++goN6gtVz90tLs/mB+PHeaQ
	9V+uYsw==
X-Received: from plblv12.prod.google.com ([2002:a17:903:2a8c:b0:2bf:235:ff11])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da4b:b0:2c1:f262:495f
 with SMTP id d9443c01a7336-2c1f2624bcemr52181685ad.26.1780711052790; Fri, 05
 Jun 2026 18:57:32 -0700 (PDT)
Date: Fri,  5 Jun 2026 18:57:28 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260606015729.1837935-1-surenb@google.com>
Subject: [PATCH 1/2] fs/proc/task_mmu: change lock_vma_range() to return error code
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4C2EA160007
X-Rspam-User: 
X-Stat-Signature: k1xjxjq7dzqms8yurtrkyx15od7qgkm9
X-Rspamd-Server: rspam08
X-HE-Tag: 1780711054-359976
X-HE-Meta: U2FsdGVkX1/Zg4ugF4e1XbNJa9IY1y1GY+2X95u8kzrbHZ3H5Yu1otJ8Lt7w0LigaM/bO9DvHA7hZM0+zqRXOZ9Gg40ZX8kyVgq3hCbyYOLKzEgWp/Xjt6YD8piKN5vHt5lgItAxSP3VVu0aDkoqjr/RMlM8MW8PqYyeDPNFVO/eNSmCvn/yUHVcgQ+zffpWj5iJvozzOkDco83OfLB08GmMpl97mC7mvgCX2o2ugpwzpb4TLsROxOoBfQzqAfITRcVUbPsqnFEn8NqA9BnbW0Rqhh0OQOVrXgKnAq7tIz2E4SMH9P/fE2lsJHZLUovewQDtxuMH6EBXmg4YrXqgIT275dEeqnaL9+WyDCz759M+tH8FckwGiUllI+KTMbsM1ipTmeu9pKdcrIw2xnoCzOVlUGEta0RDYys6PdYbQ0AatZE0I966WHPPC6I3MBgK8QUkXi2AF1RWFfXXyYqGg8+p9E3yw05iAjCqlCc916qkCr9iq4OpT0EJLtyV4Hw8Ywil713PgKGBSArdaxyj3aMDMU+dKRXrBoUDOCt4zORxpKRNMbgMVPFiLLQe0tyFgwnGdPphC/MnDqF/F3tPym1tmt40vGXouF31f4Y5dbyZXo1WS6tXhrm4vozSfmMsYFxnk/6tQoJK8iE2g8ycqZwgJj0zQtMO4mBPQcFBzYHqNStq0rAJf4q+WwPKpvVwvXYP7wHUCMpmggNbk0TSEf/HdFhCci1gBK6HLWFjPOPBtybgfcw6fxc1TfVw2VggqxHl9oQGnIOVdFBUipYavvLoJGa4iclk4RD9Inx8giDkfNPDA1atMrz5I6mUueQMzoyAg52cqP5oCv6x/DpeNxTv1GIlhpJmQJ5se7xpSes7qhixrxzpZVtaGPBJMUEwLtHtCGOpaFzbzmzLeKRSO6MC+tyKrxoP/Zcg8X6hMTzL3fobcV0m3gBiGPzmuBi5MufKfnH6toCh5Q1rjb9
 aH0hDBCZ
 YctPETx4NYNWBhAHoTMD0lw0r5Jl3ldUoHiYFPFIPHPHeFJxaBqp+S7Bd7BsiIDQvo1n0AeUnSHfRj14VY+VzBUlSEV7T8yKuyWButG/0h64pJCLtNhe2ztXlSPhy5FQngoz+PS9GXBb9znUolU65NlI+FTfUg2+PVI8NsK8qTm0o2y6OH1cpF1ZFObl65w07oMrIY+97PQW580GozjVKAYfXwP+mwJ82FPXb27hSb29vdnpEr3wU7KZGRrx3C8YXHXuYCjNVP7TFpPIQnzc3dDMKXRwAwAHxejJUnucGu9fMp94dpA/wC51fs4i5yGCTb8uYAubX0n0IEAbSV45jlsbBstWoCv+KjbKon/gcfT+qKvd0lpU1MdR/qwfLxJ9EJzGSoCqQwGnP6iVIb8b/6mKc92cXfPF5JNvfe3s5tbZN2CqC6sGm/uuvvu5yNvy+IjNs+V1FrRDFp++0TQxI8TagHmtgkxh2+Av2d9Ev4Dn3ihYpbIaz/6m8XfTEKJC4gQIzuz5nHr6Qf6MWRBdRQYDyi12cqB1+rDKhEKEqcdYGNBZuXm49Bb6MX6Iwrt5PyqyTOD19NLC9hL/BIU56iLTQuCwaCCpGjxY32CnsgMwb3CqgmZkWbV++pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To correctly propagate error code from lock_vma_range(), change it to
return the error code instead of the boolean. This simplifies error
propagation code.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5e..023422fcee12 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -162,13 +162,13 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
 	}
 }
 
-static inline bool lock_vma_range(struct seq_file *m,
-				  struct proc_maps_locking_ctx *lock_ctx)
+static inline int lock_vma_range(struct seq_file *m,
+				 struct proc_maps_locking_ctx *lock_ctx)
 {
 	rcu_read_lock();
 	reset_lock_ctx(lock_ctx);
 
-	return true;
+	return 0;
 }
 
 static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
@@ -245,10 +245,10 @@ static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
 	mmap_read_unlock(lock_ctx->mm);
 }
 
-static inline bool lock_vma_range(struct seq_file *m,
+static inline int lock_vma_range(struct seq_file *m,
 				  struct proc_maps_locking_ctx *lock_ctx)
 {
-	return lock_ctx_mm(lock_ctx) == 0;
+	return lock_ctx_mm(lock_ctx);
 }
 
 static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
@@ -311,6 +311,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 	struct proc_maps_locking_ctx *lock_ctx;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
+	int err;
 
 	/* See m_next(). Zero at the start or after lseek. */
 	if (last_addr == SENTINEL_VMA_END)
@@ -328,11 +329,12 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 		return NULL;
 	}
 
-	if (!lock_vma_range(m, lock_ctx)) {
+	err = lock_vma_range(m, lock_ctx);
+	if (err) {
 		mmput(mm);
 		put_task_struct(priv->task);
 		priv->task = NULL;
-		return ERR_PTR(-EINTR);
+		return ERR_PTR(err);
 	}
 
 	/*

base-commit: e178a530a81621a29efbca49b3b78202a18236e4
-- 
2.54.0.1032.g2f8565e1d1-goog


