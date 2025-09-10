Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53788CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8158E001E; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A684E8E0015; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910098E001E; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF418E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 214E1C0984
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:40 +0000 (UTC)
X-FDA: 83873594280.06.BABEDE8
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id D91EBA000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Z+wOMYIu;
	spf=pass (imf15.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Il1AFPpv1ZameRi/y5X+2Ag4jsiAKIDDx/iyk289iXk=;
	b=mo1FJTk0nl1nuNdsUTRINGwCMtlWeijtnW+lpDO74pxWyAzz4gvT1Tz0Zy0M7dX8xl7Btq
	OrQd1Bxp8Zq5XvhtMjuGfByYu1iWGwe502xt1onWMy/5FQfVR8xvxGU58ag/QZLF+xKS6N
	/5PP7/6FCTRaTB+Ng9BAn55/UqZnIfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515058; a=rsa-sha256;
	cv=none;
	b=SILxqADIeJv+Xn7J7dhAVRlCBmlm5MJIIc89gmQhCJybTn9mO0Nv7ljZVC45k8SaxZLg8d
	oTRtkRq1QdUtgchGQpqF565gnE8nZBAPdsHJFRMtxB4USQ7I4pq4jChhQg0jXwuhR01S3r
	ByJkrKIJ42S3IKIkIFXH2WugD4AZntU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=Z+wOMYIu;
	spf=pass (imf15.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=Il1AFPpv1ZameRi/y5X+2Ag4jsiAKIDDx/iyk289iXk=;
	b=Z+wOMYIuwHFyT7srvY1qDquEaLfd2ILQX2wLWRt7gYF4UG6PUeTWb6UcxVjQRkWkFhU2xH/mZ
	vcBL1SZ7ZG91omU0NZn0l5OZxCcTd7F3oq8iYYQ47pjNryGTNyBEPDUbsG5ogb8rLS8LKbKRePR
	96r558NQ7HxaqOq7K0VSlak=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cMNZ2522PzYlFL0;
	Wed, 10 Sep 2025 22:37:14 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v9 2/2] mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse order
Date: Wed, 10 Sep 2025 22:37:26 +0800
Message-ID: <20250910143726.19905-3-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250910143726.19905-1-zhongjinji@honor.com>
References: <20250910143726.19905-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D91EBA000E
X-Stat-Signature: 3rwqhb1y9pq491eg9k58aei1di1imxms
X-Rspam-User: 
X-HE-Tag: 1757515056-255566
X-HE-Meta: U2FsdGVkX1+zt7nXtJNunpA4BNmUOc2sqbau3V8oPnELIIjJoIzF1WCSHlPbHcSYIZbJMzlFftKw82LEjIBw7QLbs/c64uCgdPEAZ5h8quIIgJHrMpV7BF6hBopWCC3V9CaXsFxw8J0ZeIX+YBx7wwFWvkWHwXGYAbC4L8pMOnHy5wtFXnS/MNwjXBfqI0+b3pGj0Xo5Q7pHNqxE23pKec2fsFVrcYZkF8Fh3hxYJkEBtgavM3OaTlRjX7R6y406J6V6L2ffgIiKmBz78bJ0z0Gw7aV2MUK2oLw1pH+Eg6YASfD9rM4dyWy6Xe+nIbHrPxNnEUzFoiJyjJUw+4PaKenud1AZ8uqRul7K7chSHhURlcjkQAi91LvPLT8ROax/FL6khenGc90BszKfKo0Dj47H/pakf1i4iQ0ZmQpeQroEUHvsDBiLfOFnW8JKT0dnTL+DB6GJlBkMG65/ViUqUQnozg6gC7ik/Gknwi/4M/On5lXdoA+u5TXOeBBMdwz7vJfN+kn8VJ6D7trDFo4k8V9ynoaxpTRZf5CQOVWC0b3oxJmd4okxwFVKzckXYts07EvC6PoyU1JKjPcv5NT48go1ON+iIwpNN+yJMGVwmyN7gVA7VLdM40oPHAF/Fq1vHTJGfJHD21qtott+YPhRJ998OkUYMIrYqOH0/cJO36sNZiQzTsa8UywE5H0ZndTKtpDBKajQszg1BE43jm+t7dZk5O39Lz7V4FXyfhEQR1cV2nuyp9Vsmttb89+tiv3RK9Q/n8lk3leQZ8BAKeFr98MduXZTuDlrzAZObbdbOGynE24IOyCNx40DwyOT1wbdfxa3o1XmC/R9Cxr2EOYc4XxH3BCJrCmtZU7wOF69F6OBqHwbpb8z7gbNBUbUWgmzsJyhWOXwzHr1b7i2i2+kTawqzN+MCUq8W0nlms5lpKQW/0EKS+UdD5Pt8x3RK4lKxIJv+XtGr6B7ijJL7Ug
 KX6ICy/D
 L61GiDSQ7wCx6RkpscDjSWQ0CnP4hvqpaUOL3h84HzQ0Yi0tRddl8LZ0AsAd7YQftnigbYwtH9rxZpKm9fXusTDZ/FyYmTVJ7WiuLFL9vNNBG4qDji3GujYMmZk3MYCpZobc8S0Za+ckYOqzddfE3piuWmdKN8dgdruOtdYue2UE4SWSVTjJz50DnsK7C2lsl9YRw6ZlM94hSIufMas6/Rz1ksmhRX8VZHqlmCZwnhUDDysjTtpI8M3kjXe7tgiLcMsFLzr2nqz4+aHPf2ngL6jhjNhjGYhUWfzQwJhXIbx8Yr6SoL7nm4knUB8Oo3Hh+9JldDEsXBPyaHa0loq9GEbHh6Ko7qOjgCeNUI6+aysuYst4GQ0UFqPxrLiwuV5b6Cne+g3JJVNZPuk6MJJJVve0ctknOrwAkEcWJ66csCbRXF4o=
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


