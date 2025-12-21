Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE724E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EFE66B0092; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321226B0095; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2288E6B0088; Sun, 21 Dec 2025 18:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C26246B0089
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65D5E137E44
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
X-FDA: 84245072856.23.1A58EEE
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id E80B02000F
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BDynJwA1;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359787; a=rsa-sha256;
	cv=none;
	b=OT2L1TZit5kZrVyPxESY0ivtvQSD9G2KMVbCBxR/XJHSkqvatPGNTJ4p9yrvM4iMyR2giW
	z9xtStaQJWXqayxl1s2FeSoHeajMxGuZiWNy+PMU/XgT95BLhid9dLwEGrZBJlWSplG3JB
	YbvaC0drXN1KxDMvxyYP9+zfc/MiEt0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=BDynJwA1;
	spf=pass (imf13.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwRzldu+F4s2f+1UG2tsdvjihgMmQTawixFjZ+I2lJY=;
	b=s0H1sU9JepqyrbliGkQd6/LrJ2pSFP4ZzNMsD+wgY8fCW5Py92tK5WArGwoF7NnKUdQAJE
	O7zVY1dRTAUuB3WTpnnXFNLK2OMid0PXc+kFvoXAlo/jYvXjPKB8fhgpC9B6dMKCHJ/q+S
	CsYjDpuBz30sD9X/40b71TBA+ebUH1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=BwRzldu+F4s2f+1UG2tsdvjihgMmQTawixFjZ+I2lJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDynJwA1o3ZkMUeveOgh/2mXgYNsnF7uNZY8CLwxVzfhteYUMZoapgvSgZ0Kh42Vg
	 mgTr5QfA/KJ8+E6xtp387SpJ+iazYrgmw89GHzNJ8w6vjRahtEJNI3HHzMYKgVkglE
	 gJOxN1R2zDSTgte0OaARVZCfKcdAwQYMAF3gkaY7gjiBZHdSE/VAcg1xjztTSuuzen
	 tIE/eOp9HEujiaosjuoYtZc6a9b1S4chzDKhNHwmWNXWNPwVKKuahiIL/NXW476z1W
	 0580dy9d++YNzEfeJtwMzM4zVjh3GvKWLiKuK1kd0ncVpBHiKhYl7YzGqL2Gv4RjzH
	 JDYiy0VryddCg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYQ2Lrjzd8P;
	Sun, 21 Dec 2025 18:29:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org
Subject: [PATCH v1 3/5] mm: Take into account mm_cid size for mm_struct static definitions
Date: Sun, 21 Dec 2025 18:29:24 -0500
Message-Id: <20251221232926.450602-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E80B02000F
X-Rspamd-Server: rspam04
X-Stat-Signature: ktour1rk9nid4y1zqxe6q6wyduuq6ry3
X-HE-Tag: 1766359786-269091
X-HE-Meta: U2FsdGVkX1+LxH3L0yTJUIY6a2HeBzimqFybN2VfAfGS2kihHlstZzyHqatPuo/ehUgn8q//XO601TYmfHOrKnugvIKsKQ5yoVnKrD519IRxdGCH5Yw299qsegM4eVEqwANcXiTDLKyqn4DSj8Mn7VEhwJPhu1agvCOU3iIjxsMnTutPfGgGGiOHROXYKcg8piuWyfy6KlqKoUaHcD3WShm63L8UHxnWpWdzwkLkzQ/PeF5GVaNs5zNG/l8dlbaR5xRS62fU+x+yDnCePKe+6XAINb7q7O/kzZ42/0/qmIrUtt+Lc6QsV2jEhP/O7dafYGKD5yM5QAIH8JKpR6U4in5ez5Vv5EVL1NSZ1PS4fGGCThjnGbkfP0VVYhQ3ckLbWGwg0ahFhPhaYZYvB0cKQQ9UGpCI5fXoe/h1KN5Oy5qChCNzpIlALU56Rz3eL2ReEgxa2+jGHbnF12AO6u2FuDf1dDOJ2TA9ZW1RPe3gOas+VtvFKFPCf/7MAXMgGNNmW+7ajjtHo0dBmHovu55Qrj6FCP+OvAjNWvbDyQOn3zIvHC2CpVAHTRMG9fPdRA3zZ/syQxBQxZysmLhU0+UfdAl0nxz8l87iGmhdzMDPbX87SuXKNKA/yhAWRjMKfwPXs6TfqPA29OetNTDzuwRfQbABeTp7ZQ9wmSKVA7YBcJanIeg7kmNX3t1waIh4cNgAvFFichr1Z7L2uR8RxmhC6aXNK9PBi4txFYC6TMus5UsnLNM+W+/tOdUIhae9I+l6cDh6yBWPHbFeXJU35YrMSO0UR9RSllV0tmL5GZySOeTr50BlPQbWtNtsGJpsC7oHKIqZYwU9jRJSQVJouRamS3l0zn4NsUEClNLYHQhWJdd6C4hYzwtPS2uEwgAmsZ6+4UDsqzxOrO5MDE+whWcOrEoaS2nK+a1TvjdUFNqrZJIUJOTe2jt6xFGHdKlKnKNLsl+xvp9zXwvF3cadDkN
 QDb1uSLK
 RhzaKzgNnrmlqIhGrVSm0kZO6tK1HwymBvWYg7Bu/rNbnHG9psMjGJACHJ7Bnk+EQ3vfaIpkYZEcIAh5RdHXlCjpVoJrlPvzroc+G9zebKeM28xXsPrFxg/Z5WoCIPQExKCONDFS4HEpEyX/uInBflCENo28fGN6xRvT1tSzAJ1BsSjfFthqRhAN6LyWn6p5eXZllGtVDJbA/uWtB9ObZ4APxpCwVSQgP8kQazQsWU+9LXxgmrcfFrcGqNbl4zdP7nofPo0knP7Ezwp0kH3NsItCK7qZyEp87QYa39qjmdxezGVIR+I1UFy23OBVp5QmqfWACwWA8s/xgibUaXDeDqYKf2zMVFyyuVh7Wy4kNkuc34GWm6PKa+LtXpQeMDtWPWltP+UcjqkvXSIZilDiWL8MJ9UvmWTqR0MjXAuwZ+XqfI2cLSR9KYNp/b1FCQ8xNDKwFw/H1oCvs2T29jawlllRAmh/lO6qo0MJbmFl5bwCY9h5dzjfgR/zYONdXAtSCWOs9eSsSdaULI80fz4STdEpUv3Fnvu+UoJMxeEngIH7J29g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both init_mm and efi_mm static definitions need to make room for the
2 mm_cid cpumasks.

This fixes possible out-of-bounds accesses to init_mm and efi_mm.

Fixes: af7f588d8f73 ("sched: Introduce per-memory-map concurrency ID")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/mm_types.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1531df8cda52..aefa64db3499 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1368,7 +1368,7 @@ extern struct mm_struct init_mm;
 
 #define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
 {								\
-	[0 ... sizeof(cpumask_t)-1] = 0				\
+	[0 ... sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0	\
 }
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
@@ -1500,7 +1500,7 @@ static inline int mm_alloc_cid_noprof(struct mm_struct *mm, struct task_struct *
 	mm_init_cid(mm, p);
 	return 0;
 }
-#define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
+# define mm_alloc_cid(...)	alloc_hooks(mm_alloc_cid_noprof(__VA_ARGS__))
 
 static inline void mm_destroy_cid(struct mm_struct *mm)
 {
@@ -1514,6 +1514,8 @@ static inline unsigned int mm_cid_size(void)
 	return cpumask_size() + bitmap_size(num_possible_cpus());
 }
 
+/* Use NR_CPUS as worse case for static allocation. */
+# define MM_CID_STATIC_SIZE	(2 * sizeof(cpumask_t))
 #else /* CONFIG_SCHED_MM_CID */
 static inline void mm_init_cid(struct mm_struct *mm, struct task_struct *p) { }
 static inline int mm_alloc_cid(struct mm_struct *mm, struct task_struct *p) { return 0; }
@@ -1522,6 +1524,7 @@ static inline unsigned int mm_cid_size(void)
 {
 	return 0;
 }
+# define MM_CID_STATIC_SIZE	0
 #endif /* CONFIG_SCHED_MM_CID */
 
 struct mmu_gather;
-- 
2.39.5


