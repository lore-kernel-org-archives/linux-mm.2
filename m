Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACA6CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6768E0009; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9477F6B0005; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772CC8E0009; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 574D56B0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F328F13B1FC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:40 +0000 (UTC)
X-FDA: 83847411480.07.32A54A6
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id B60F2100007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=cQw7X1Jq;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/uDUbzgtgsxWzj8Cop4+zLnEzwH2RYL27BPHIa6ZCs=;
	b=cZ996TuP4YDQMa1sgtzTzquflNTFXPOSyhnBKLYuvFo70t1h+dryT799uMV8QFlIYamAPk
	/Qh4bO2r8EVJ3H86VCuLn/JaAArubky+0VHQ+EsAfaUbCAMfGD9gyksAw6EGcL2od6NYFR
	pYJ4SjGwYbYSnltyujEed99UQpF1f5w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=cQw7X1Jq;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891659; a=rsa-sha256;
	cv=none;
	b=g5bS9HlAl+SckJm3O9BPXH+tVX1GhjbRgS44ZjJsm1bq+m4cfPiD5cEUQXMgKRPScI9DlV
	zg2QEc06/K2GoxBsXTNCxagofvHmgQdaGTKCCaHJiEnW9cJeAAa4tloDVPdzYXCe5p1vZb
	JLeyvDuz+x4CoX6f8XcBfqozJpTrfQ4=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=r/uDUbzgtgsxWzj8Cop4+zLnEzwH2RYL27BPHIa6ZCs=;
	b=cQw7X1Jq2Xu+J4D6Zyt/8T0P6nCWF3oej7qVCUJgXulRFneyvMt5DR7J9q1t7nYhpz2Wm9EBP
	6gG0WS87WbWdNEYsQyIc42Zg052Z5ZThHtm32MGNDnQxj1RmzoeYVNKu1otjb8W4WmimcZcD/7+
	Cq7kReGDau7TK7hFwkUtTM8=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cGy1g4kKqzYnw7d;
	Wed,  3 Sep 2025 17:27:19 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:34 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:33 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Wed, 3 Sep 2025 17:27:29 +0800
Message-ID: <20250903092729.10611-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250903092729.10611-1-zhongjinji@honor.com>
References: <20250903092729.10611-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B60F2100007
X-Stat-Signature: ifbdcfhqrs5bd31djkua1a76mjb7ky41
X-Rspam-User: 
X-HE-Tag: 1756891658-339862
X-HE-Meta: U2FsdGVkX1+1NAOwFMyOBoKS1ZB5QclQbxhNaXDDz6DJVsHvi+jFiTbpxdO5g7GDQyCpzVmmDsb3/+My9U52FYkGBNlR1ZYyRkeaFWnYguWZxlHAYaZwjdgLqqxbXFGuhQzrzDadPcycMl43SZlQYy94HD+mBTRQjCzSNQIWLRiA255W+w6ajKB1QgdXUOpD77M+qePVxFZjlNLQWuMvtajST8GxNrf4SK7hDFDot/amQARN5BHm66pQzGZDevvcKEpIlS64NGvGH06QVzU+w27AiLxaM3sQDQUluV2IJ7r+d4bSG9U/uxS6RwHh522vrSoFNLeLkVTHHYqxrhRzBWKfUdToRWLhvnOfXnXCKRbzsd5U+cFkmGWCT64jfJC0lN0WZ4yt2kztOagbV2jitpt0tXRbZFM/+5GvO97akZ2B+ILswTLc9sUndqNR2GfLcnn//vUwm7+J/e4GfRPttfxYQp/TUK1Ab59/H0VBjlGdOMALi/ba0bnKMJioqLacG+O+0xfJCEG8qM6JnPNxWl4Csh6FYRfdmjq3lEKeoJR88l89u0DcLs/DFjpW8CydQAAAwX9lWWMeHTLHcNWUtlurvT1DFnUie80DNxn/7VRucpaAM/DadddpR+UtNNRTFTM4/htxRo6bDtgE8NQiGKkX0QF171x3Rz7fNNkVnhyZ6KOWYbRGUBgk8Anul49SJ6op65Qb+HvrPlFevBSqqq9G7IS3gkFttxorqAW2Sm6priH8MxmEwfLrkriOuJiQTmEbeWdFrzOX1H0ceNtO62kiIO0Kakeq0rmUY3+hPpcuPhazFbc/HCZ5/LPHvRpWLkiyQ3/XftTk8523STx6tkrMkY3s/TQqHomhDXH8h5o5QpkpAG9QJGdE/544WRXvLArnYWZ8hIm7ivz6YpUoIKXmqZGaHK7ng1eXubVqtB7TlU7/KZW2hBoEXJdu356AcrhhFjVTmBs=
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

Without the patch:
|--99.74%-- oom_reaper
|  |--76.67%-- unmap_page_range
|  |  |--33.70%-- __pte_offset_map_lock
|  |  |  |--98.46%-- _raw_spin_lock
|  |  |--27.61%-- free_swap_and_cache_nr
|  |  |--16.40%-- folio_remove_rmap_ptes
|  |  |--12.25%-- tlb_flush_mmu
|  |--12.61%-- tlb_finish_mmu

With the patch:
|--98.84%-- oom_reaper
|  |--53.45%-- unmap_page_range
|  |  |--24.29%-- [hit in function]
|  |  |--48.06%-- folio_remove_rmap_ptes
|  |  |--17.99%-- tlb_flush_mmu
|  |  |--1.72%-- __pte_offset_map_lock
|  |--30.43%-- tlb_finish_mmu

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3caaafc896d4..540b1e5e0e46 100644
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


