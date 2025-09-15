Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE79CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71218E0001; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84D58E000E; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940888E0001; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78C288E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:30:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27CAB160600
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:30:00 +0000 (UTC)
X-FDA: 83892021360.05.AA35679
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5DA3D20011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:29:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="DiMtGw/u";
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+Rz01jnhZrKhL2yDuA2zWsb7SrFCfsHx3X9jrl/ySE=;
	b=Is1uaEbDobcPJaBSddpTpJ8LwkmAXM3SA2j1U5MIVRLPtEFeBcct9S6B3R1aYSvgOH/o6Z
	VzxWpkoQrON/oxoxvTkQhb+p6TutQwCl32SANQe9L/6FrDZtgSenfkGgQvGEurQTqU6wG8
	ZzcDvjEFuum2boyoOQkYXZoyn9+kffA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="DiMtGw/u";
	spf=pass (imf03.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953798; a=rsa-sha256;
	cv=none;
	b=QPw58efEBc8hbEqZ236SOBh5dKiok781CgQVL0JN3AEmUIBrzXQ47NbX5pdvFqJefSU7je
	8jenCtLLsrO0hcPsS9NcCRO1WurM/kJY/nv7daq5HGP2za2RCGY2WjWq3bh9oTUYDPgtCm
	QJZpgeGSCrIULReaKJOUd+G6JWu3W10=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=q+Rz01jnhZrKhL2yDuA2zWsb7SrFCfsHx3X9jrl/ySE=;
	b=DiMtGw/unnVszkGXeB0iAIK0NMPg16E/Fmf/kqDkPOJQPQero0Jvm1OSLsw4Lgg4LlmX+huEg
	vIJWo5vsYzMLXNZ7CN5vsKWBI704t6GN1v+BVwlkxF8BX4+Ruod3DJjVMTuUMnhsq6uea6RM66j
	7nj5OtvzoGYw2Vfpdm025Bw=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cQVqJ0GrCzYlBF4;
	Tue, 16 Sep 2025 00:29:32 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:51 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:51 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v10 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Tue, 16 Sep 2025 00:29:46 +0800
Message-ID: <20250915162946.5515-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250915162946.5515-1-zhongjinji@honor.com>
References: <20250915162946.5515-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: fcx9pjqye67bu13hw4icrg1cudjhanaa
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DA3D20011
X-Rspamd-Server: rspam04
X-HE-Tag: 1757953796-939350
X-HE-Meta: U2FsdGVkX18dH5TalL2WxSHCbC9GknlLbwmww4nyAc0k2Eez7OVf0t/B7ZsBWnyn8nTFTzSB/yVB1Q6Zq4U1forOMWjC8lezda6cObgRlfvPrRY2ekYdiOaKpAE4pLAV67YsFPiXjrfItMFhICccImqJHevHyrLMSKsYPai3ZzZRYl6DIixFgT/tqLTClFbpFLRnl0fgSoK11y2XXF7/hU9zIYiR4FXil7gme3CsfhEE811N9ug6nKZB0KV4mRhrcVne0Kmrmvp2BkzAElWVQglKVY9TJkMWZvwrm/MCSzTonEdoCKcgj2Z8zANcWXbu/zHWEbakYIqGepJbOlopk6TvHOQFGBYuRlamqCX8EoGI0aXPGSWJ1gtdBzawaP9wZzeAOy9yVZi7rw6E9l0jO/pJ+FXmBj9fMAodr1rANzd+ScqC/ngxCUTvo5BLpzeWFk/+x0/WgH4lU8J9v2SDMSFX5Ii2gYHfPwnuNQRDgWN7ZBtbp5kd91aTKJYYv6VMyRCHffbshb4RAM9VhAXmQWOuEZZinzMDZt/dcSuGO3uSBO8Npa1sq7odzczu9K615PrbmSjiaIiuyQjBvFdqwlen4udpflht4odyYpwShCC47UUfalrb/IXJL74h6eeYxsYJ3xNg81mFN6bK06euNDjD4VMMKIhGOGXlF34hrBRsSnx/Suo0Pju03yhUQCg91fKOVX/HtOlKdc3eyqgZm1J7O3aBnR2ddtEfq8cikD7I13o75gsLUEbUdStfmwm1fhl8t0ccr209TsIp2SZij461oPAVKt+2JX+l9DhVBed7iTNWtYgmJs5ApmbHAouPYv2G/M6gh7d9hZPvSznz3Hc1gwiqSk7nLgg8hebVGThD4iq3ZRJo9hQ4y34pxD6//QFc6E1pDJYyyRhe9Vr2AHYAi+GR4ui8tom7dEEPv9FOVEN8RtpwYDbPwOd52vF3SJpbgvQPqTRpl0yeNak
 4rRl+Uug
 X/Sr1uk9487F3FWywZ2njpuRRTGwYQ/nqTYl8KQp8tMRWgGGWomzQScJIPqvgnGXFeF9Qa2w8PbMdvdZO5S3qZKSfK6fKmgknR9gXVxGL/WdPkGiF2PACm/kUcidt+BtBiJVFw/EU9hVtK1dYe0ad1nsTLVsWNxZvhyG9f6pdOoUTNfEIw5RMSDmlKP83EKuTlUe9n6jf+7dVDfl0aM2UtSmxbB6tA8HEiysNjVWILlGaUJ1q0y3Hiqo6dBRiCtOHeskVS84xVnzd1XBRXJLNvCeh9Txhy/tQQbOiyBVSbZAeq8srTWrYCkGTHQjD48yR9FV55UFOtkNl3jqnpGCBmY5wrfxGzn2WrtOXqQ/E5gepc+l7Lmr6ROUleJPJen6QGOtCv6B+ipIPhoLDoRpNUOzjzzK7EOSjD+vYLZz6m+3lA7/RqC6KPGepOASuuehfYFux
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although the oom_reaper is delayed and it gives the oom victim chance to
clean up its address space this might take a while especially for
processes with a large address space footprint. In those cases
oom_reaper might start racing with the dying task and compete for shared
resources - e.g. page table lock contention has been observed.

Reduce those races by reaping the oom victim from the other end of the
address space.

It is also a significant improvement for process_mrelease(). When a process
is killed, process_mrelease is used to reap the killed process and often
runs concurrently with the dying task. The test data shows that after
applying the patch, lock contention is greatly reduced during the procedure
of reaping the killed process.

The test is conducted on arm64. The following basic perf numbers show that
applying this patch significantly reduces pte spin lock contention.

Without the patch:
|--99.57%-- oom_reaper
|    |--73.58%-- unmap_page_range
|    |    |--8.67%-- [hit in function]
|    |    |--41.59%-- __pte_offset_map_lock
|    |    |--29.47%-- folio_remove_rmap_ptes
|    |    |--16.11%-- tlb_flush_mmu
|    |--19.94%-- tlb_finish_mmu
|    |--3.21%-- folio_remove_rmap_ptes

With the patch:
|--99.53%-- oom_reaper
|    |--55.77%-- unmap_page_range
|    |    |--20.49%-- [hit in function]
|    |    |--58.30%-- folio_remove_rmap_ptes
|    |    |--11.48%-- tlb_flush_mmu
|    |    |--3.33%-- folio_mark_accessed
|    |--32.21%-- tlb_finish_mmu
|    |--6.93%-- folio_remove_rmap_ptes
|    |--0.69%-- __pte_offset_map_lock

Detailed breakdowns for both scenarios are provided below. The cumulative time
for oom_reaper plus exit_mmap(victim) in both cases is also summarized, making
the performance improvements clear.
+----------------------------------------------------------------+
| Category                      | Applying patch | Without patch |
+-------------------------------+----------------+---------------+
| Total running time            |    132.6       |    167.1      |
|   (exit_mmap + reaper work)   |  72.4 + 60.2   |  90.7 + 76.4  |
+-------------------------------+----------------+---------------+
| Time waiting for pte spinlock |     1.0        |    33.1       |
|   (exit_mmap + reaper work)   |   0.4 + 0.6    |  10.0 + 23.1  |
+-------------------------------+----------------+---------------+
| folio_remove_rmap_ptes time   |    42.0        |    41.3       |
|   (exit_mmap + reaper work)   |  18.4 + 23.6   |  22.4 + 18.9  |
+----------------------------------------------------------------+

From this report, we can see that:
1. The reduction in total time comes mainly from the decrease in time spent
on pte spinlock and other locks.
2. oom_reaper performs more work in some areas, but at the same time,
exit_mmap also handles certain tasks more efficiently, such as
folio_remove_rmap_ptes.

Here is a more detailed perf report. [1]

link: https://lore.kernel.org/all/20250915162619.5133-1-zhongjinji@honor.com/

Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/oom_kill.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 88356b66cc35..28fb36be332b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *vma;
 	bool ret = true;
-	VMA_ITERATOR(vmi, mm, 0);
+	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
 
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
@@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	 */
 	set_bit(MMF_UNSTABLE, &mm->flags);
 
-	for_each_vma(vmi, vma) {
+	/*
+	 * It might start racing with the dying task and compete for shared
+	 * resources - e.g. page table lock contention has been observed.
+	 * Reduce those races by reaping the oom victim from the other end
+	 * of the address space.
+	 */
+	mas_for_each_rev(&mas, vma, 0) {
 		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
 			continue;
 
-- 
2.17.1


