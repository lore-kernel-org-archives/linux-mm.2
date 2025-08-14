Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122D2CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F003E900174; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4382900023; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE3B900176; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABCF3900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72BFAC06AA
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:10 +0000 (UTC)
X-FDA: 83775512100.13.D59AA5C
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 48E1C40012
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755179768; a=rsa-sha256;
	cv=none;
	b=oLZkkC9PwZLQO21vsRRFe/4xkBP90V9DCiy7+2ecZ68STwFVcMvOLJeqb21grmQKAQWeB8
	sYgGElSzSPYuGmKzEvPc5i7/sOvDvWPCKJisd/hTWh7t2JOSOBS1KKGJmP7RIYgsVeu6B6
	hQRwIa7L+B3Ky4WE/l5GZgEUZeseOxM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf12.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0BwMB+AmLKwIbUYBwNjLScFrw78HSIYGe8FyWtEufSg=;
	b=HulH5Lu9u/IZF5ceahzPryFKUAq22nyEC8bkfRfaI+EzgKjckPdY4Inp4Id1aX3X7egjDj
	pnFkJ7L9gqakTCojDOk5pcgUv4Y7MfALLtheDKTLriiv6kL0ebUQiNF3CQ11yhhgMglHs0
	UtiL7mOzP6WyROsGqjkZcuzl3cnl9ug=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c2mwm4GfqzYl3br;
	Thu, 14 Aug 2025 21:55:52 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:56:00 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:56:00 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liam.howlett@oracle.com>, <liulu.liu@honor.com>,
	<feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
Date: Thu, 14 Aug 2025 21:55:55 +0800
Message-ID: <20250814135555.17493-4-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250814135555.17493-1-zhongjinji@honor.com>
References: <20250814135555.17493-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 48E1C40012
X-Stat-Signature: upftsqc1npkxnmmhsxt4fydmbxidzgge
X-HE-Tag: 1755179766-923153
X-HE-Meta: U2FsdGVkX19PRF7pLKl5RkqhYHsx+IuR0SFFArdxc9W21S7h1pFknNr1ReDscto/y/B+WUcYpRBYJj3SfMPVyG5B7nhwdGXCBbDx027GrZPyBl9YKso3kC73djjL8IIV5QlkWQ6igNy3jUV6CahHF4wGEgcxmVSFIA5jKlmNMoUjbewSBo5S13X8IJMy9QeJKsIKDChLdz81OwmEpMM2gnB/ToufO2NLOf+MMJWk6pUMfv3XAc7/mJDjVatbv9HUjrr7mEKRAdaKxni6U9yUgDgkwE6UQAvERQwYcSMFr+5GzpqSk6fTOV6wKCh/KzMPtQ3OZiG3svbbLPrdPeF69IVry2ytFz6cShv0bhlOlLRo8xSOpIxRvqKxN5z+KOmlXal7SeQOf25EumIuM8+J6iGoZq2g2WsauRoWyDpIJXYaAcwy43P0IE/bvk2OOVfFWeHRJtf9hYfqqeDoZYfFoHxRON+4AB6veFl/hamUVI/Vt/dGdWbkMbSVDBGSLhZ45/mBhMJm8rdz9Dtl5QrdldPmyXYDSSDCIwbe4+x6IwkKdeuQpBwVuovo9kfVbOcvVNYPQwP14tRnQqnXP6Dc08cp1/OQL4YBsSspm6N0I14YHC8Q8k0g/ox4gUEAKIlIZ3RIJ3U/UkOeCbZ+fzkFaJxDXFDcgPz5/L9bhB6SO2luEV+r5LsGKGEtaIVHkjbh0uZK51/gEIQpBIkkyrm1L9N3Cb8syZqLjTPpDW8ecxuuIPYd6hdF7nHUoXfyKnfK7Qj1LovamHzwW+L/CTKaHJl3Xz0oJ23qy5gqMWwl7v1Xh9tYWwG0HbdrwAdIZScFS8FQyRedQGlRE39JftTJ5SXg/2/DDmHMR9Sjw2XvxGaBaLOP57xBw9afRLXP690ve8HmKw8ezy0zWVNEqoSfi32QMOVQgbsRckvz4P/v7S3si6DIGGXEJbxp0AtxAhWuEzRdl+7Q+iaw5bgs6dm
 bgp6nqkU
 lLs8hqPDzT4pegUDrqA8mOTaLb8JzdERscvFyJyipNjBkueATYLLrxrlRTy0ZSSl3UIvGbh3fQgPxR/tcJjrkvOD5dT37+ZWmb7kDXZ347fmWbe5cKlxd7YmvNDzJOIiLTRuJywRVBIb6ItL6+4ZBiR+P4/7Jgn8Fu2huPTDobpa3FcYEDxHe3PyqOA4zaWrbTUb26MxZcxLwrpO93Y+gq1OYpiXBxi6FLWcY+GNADjK6ug1F3umCzS2LHC1UcLXQKIOJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

When a process is OOM killed, if the OOM reaper and the thread running
exit_mmap() execute at the same time, both will traverse the vma's maple
tree along the same path. They may easily unmap the same vma, causing them
to compete for the pte spinlock. This increases unnecessary load, causing
the execution time of the OOM reaper and the thread running exit_mmap() to
increase.

When a process exits, exit_mmap() traverses the vma's maple tree from low to high
address. To reduce the chance of unmapping the same vma simultaneously,
the OOM reaper should traverse vma's tree from high to low address. This reduces
lock contention when unmapping the same vma.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 include/linux/mm.h | 3 +++
 mm/oom_kill.c      | 9 +++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c44bb8ce544..b665ea3c30eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -923,6 +923,9 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
 #define for_each_vma_range(__vmi, __vma, __end)				\
 	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
 
+#define for_each_vma_reverse(__vmi, __vma)					\
+	while (((__vma) = vma_prev(&(__vmi))) != NULL)
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7ae4001e47c1..602d6836098a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -517,7 +517,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	VMA_ITERATOR(vmi, mm, ULONG_MAX);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -527,7 +527,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * When two tasks unmap the same vma at the same time, they may contend for the
+	 * pte spinlock. To avoid traversing the same vma as exit_mmap unmap, traverse
+	 * the vma maple tree in reverse order.
+	 */
+	for_each_vma_reverse(vmi, vma) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
-- 
2.17.1


