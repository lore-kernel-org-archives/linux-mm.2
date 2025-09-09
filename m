Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7620CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BD8940008; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A14940007; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7759F940008; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 689B6940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:07:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27A4EB9815
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:11 +0000 (UTC)
X-FDA: 83869132662.27.303777A
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83405180008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="RVzD15/d";
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFwPNIhzx5/vlFX4tifco6Ucy1u1xTtsZP1BKdZxa8A=;
	b=ULE1s2zKuidliwJxdbF1hKeKgc3DhsTVbAtRuoA7YDdVSJ0GZ2KdSprovE20Cb6iq8I046
	bLGOpJVPe0CU0o9IaBXNOytYAFa6t1tl26TwDVPsgr33ckrFAsOXo3D/8K37n5BfX5f6mb
	qEPTjN5jutUAQlDRpRbDhMp1bcYbbUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408829; a=rsa-sha256;
	cv=none;
	b=LpSu+ARa1aKuXMvN591RKqKOwfph2VOAvGMNSNFqgbpoEkvUphD95uc68HrjbIOC0CO6pF
	1WIqvZ47wNEPZjdW0tui3m92hoGjlx35ALI8xBLX3oSoTGz5YhJyPWtkdn2WqX2PICB+V7
	BEmvXDGjwBmxxags7ZUfacSW9YOJBw8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="RVzD15/d";
	spf=pass (imf16.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=QFwPNIhzx5/vlFX4tifco6Ucy1u1xTtsZP1BKdZxa8A=;
	b=RVzD15/dqePYVNtMOHbfcWz9+AGkmjUfqnuo2/JMGvOoXcYqCMiMgofugKojvVQAc9YvHcyv8
	3j2xI5Ud1d3KkZJPS7yQsWX/oiX5UHgNCYkf8BlBGeahAmQ38SsjiuN3nJeDN5L7ACWEwoRs2Kb
	NxsDLg4a1BNwDvblvdKpy/Y=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cLdHC1hpWzYlsST;
	Tue,  9 Sep 2025 17:06:47 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:04 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v8 3/3] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Tue, 9 Sep 2025 17:06:59 +0800
Message-ID: <20250909090659.26400-4-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250909090659.26400-1-zhongjinji@honor.com>
References: <20250909090659.26400-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 83405180008
X-Stat-Signature: ucyzdsp9uhi8rwh95b53hoepq7jg8kkm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757408828-142223
X-HE-Meta: U2FsdGVkX18KcLBM5Zfb8rE8TGNApS42Unj4xavIiU5D+HGx7JTNKkUdiTLUYyX3bVxyYhsSEY2L0oNJJYXzSsN+Dc14LRooW0Gm//eO11nHDOFMvGx+KuxYhbuyMAMExZvQtMkgmAybXeigOaXAwZmC6Ms6ahpnHEBN8RU3X1zi8M4foxgJfPjGySXxKhKZf1k1aRq1CrYnVvlo8b7qEkwgU/5t6AFfK6SuidGYXs7Lu5Pu254Vbe+6iSRepXYw+glj6B1K/DrZQZm0jEziMgrO+p9+buVQhQ9BRM7I9cc4ku/5zkdfP+j9/o2SgXviKHoV/l0DhQuSFiBIr5k8s11W2gAX2TgAPCQlBlwWoVYd4F5mcN+0h+oIlLsegtUHoz83fll+QjQMMnDvjeo9gwseaodYBPNNQFSI7j6G46sJaA8CHIsCigNtDgWUfiZ/N2iMcXg0RZxB4DDhLaBUHLMfEZh3/9suaxjelgTySVrqtmYEQA70MaKedJMEYyna/zSwGSAB5vTXs7IPpFb3NkuIR9m6vUQCl3pBsArlkWOrscP5dSLILxosxOYDXbJ2QfoY6JOvX1bpAvcVGtKjWi5fWcV47bSQdoA4OIRLUVFu1E7GW90V/u9e9muTBjYgvph61ulXqJJH08RXS6PEL5IFGuocHJ7CkCa2mJpGBFj/ntNVRkksNEUNEtG0dHiCe/prV435/u3SqTCbnnZHPRqE84zipIhHRIisMPtTF3OHFiThsrJ0T0Cy8HQZI76VjnOeJ9GWVswq2nNTNd1Mqtl7xntnvY1zbHP6+6V8nnFtIioizd6eo5HwZ+SpZu3CmrOpx9Qk6HeXlthQDY1PzRP4L+quz7u7CuryX+uBHVOa4R5HmMxSq6k3zpA3Mj9LU937ggc28RI9NlF4y7PyDhh1ESmKWBLjpWOgDnFLZ3qdl010s7uQKbEA0/XDxkmBG8k4gcWVWWcGmi2IL9d
 i+3EU5lT
 mHnIUzfUAYbTsN7A5SyNxZiuRkA2olxxG+DooD/qFHTLuIMIE820k5qYFiCoC3IeGTdhYrBgc2HIsT5RBPZqUfmcP5UzUYxlYZlY1LpPTDw3LgfYSeS62iYSlL3reocGjuRPiw1iu1WFx5Hy8XBxyNEO/J6U7of4r3GMHy9rPr/V6U9Rda9j8HOc54DULwvfdXD9M2mzayAjgFF6arYDQ53XPwLXMtm/ZzfSN6a8Zrachw8OBtU8NkCs4Q4XXHo/tEhcjspbCmUm7bu12AazuZC6+F7FB5fBkyMut73oamFq0U3pkI1RQg6jgvQwjO2PIx9SD14a0LWBxMl+QhOWaNo/7qVp0Sh3GFbrBiT+bH5RIEkcC9KwlfWnDEdlN9+MeFwtVUQQF0EHDsuo/842AgBzYkw==
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

The test is based on arm64.

Without the patch:
|--99.57%-- oom_reaper
|    |--0.28%-- [hit in function]
|    |--73.58%-- unmap_page_range
|    |    |--8.67%-- [hit in function]
|    |    |--41.59%-- __pte_offset_map_lock
|    |    |--29.47%-- folio_remove_rmap_ptes
|    |    |--16.11%-- tlb_flush_mmu
|    |    |--1.66%-- folio_mark_accessed
|    |    |--0.74%-- free_swap_and_cache_nr
|    |    |--0.69%-- __tlb_remove_folio_pages
|    |--19.94%-- tlb_finish_mmu
|    |--3.21%-- folio_remove_rmap_ptes
|    |--1.16%-- __tlb_remove_folio_pages
|    |--1.16%-- folio_mark_accessed
|    |--0.36%-- __pte_offset_map_lock

With the patch:
|--99.53%-- oom_reaper
|    |--55.77%-- unmap_page_range
|    |    |--20.49%-- [hit in function]
|    |    |--58.30%-- folio_remove_rmap_ptes
|    |    |--11.48%-- tlb_flush_mmu
|    |    |--3.33%-- folio_mark_accessed
|    |    |--2.65%-- __tlb_remove_folio_pages
|    |    |--1.37%-- _raw_spin_lock
|    |    |--0.68%-- __mod_lruvec_page_state
|    |    |--0.51%-- __pte_offset_map_lock
|    |--32.21%-- tlb_finish_mmu
|    |--6.93%-- folio_remove_rmap_ptes
|    |--1.90%-- __tlb_remove_folio_pages
|    |--1.55%-- folio_mark_accessed
|    |--0.69%-- __pte_offset_map_lock

Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/oom_kill.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ffa50a1f0132..52d285da5ba4 100644
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


