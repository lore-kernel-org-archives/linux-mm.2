Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9D85C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB966B0088; Tue, 15 Sep 2026 10:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6CC96B008C; Tue, 15 Sep 2026 10:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AE26B0095; Tue, 15 Sep 2026 10:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B790D6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:32:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49DF412046C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:32:04 +0000 (UTC)
X-FDA: 85216236168.19.A599C77
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8571D40010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:31:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sAM9jKmn;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kPmD/Etzk0mnYDw9EGIof3Wh1FZd8nczR3alioDfOwI=;
	b=j8vgyFH7MErFoP8q+0Y/TvLTawy2fe8f8vJd9jBqEq7F8Ibs0lbqV27Phg1JxziMiA4dZp
	1GZW37SyjUr9Q0WADLv2HDVXsqesggPiXXr85Bzy2wxM8jOwZybt5J/MkOyVnXG8OtLeIJ
	oaIY2SOkfJMjX5odJB/Y2Z//zH426PQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sAM9jKmn;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482722;
	b=b6YQjnKsJy5fdzNMzGHhp5uEGH0ChcBmYqLUxvdeHY4RLUlN0i9EgjGyXOPXIZJ/RrRuOg
	n1d80tQLZ2ATPNIdSd6N/kdeXxRFQUWbVycZ9Y1wXewDI5B6y+p45s1+BLc1OxNZZhfaI5
	Cg3D3CQce0q5nj2taEjf79Q2n0xCIJ4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kPmD/Etzk0mnYDw9EGIof3Wh1FZd8nczR3alioDfOwI=;
	b=sAM9jKmnY8uS1x4kQk10tvU5YkY5pHxxJ3asBwfNrWDjpR1ak3OyiJa8artGiMHJ2MZnsZG46
	O4wNWTMT82lD0+ITyZivg9/n385N2zQS5emC2+eKzIh7lR1zTBKk3CRVUaELlIxKeOdk9yciUhK
	VOVy7p9kK6C/8pyaR4pbhNU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hkkhW1qtDzRhQs;
	Tue, 15 Sep 2026 22:20:59 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 056EE4057D;
	Tue, 15 Sep 2026 22:31:55 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 22:31:54 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new RESEND] mm: mincore: use per-vma lock during page table walk
Date: Tue, 15 Sep 2026 22:31:38 +0800
Message-ID: <20260915143138.2595767-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8571D40010
X-Stat-Signature: cyr7qedqatogrqxg55ynqph57yf6ji3h
X-Rspam-User: 
X-HE-Tag: 1789482719-760947
X-HE-Meta: U2FsdGVkX19vX4ZTlDgtFC6XhZJ8Ojllyt4wuGWqwIXm0DGsqbZIh5AXZbv2zBj2ZJD57XI+Rpkzl6eMAkrHWxloSrxwOj+2ZRM61dHkpPj2NoirU8v0tJm+2P7XZzJS9V3Ax2/8lcK+LWTj3MO9l1rMSEQm4Qwpvp+YuMDa98Tf27AatKFZnJw3Ym4EGcGuWnhg2cZ/1JzLcpemEHkeTY2sF9Y2jV6V5+DAictGTbWDjLzO4S33kZ3bYbgpP2y9lxzFUTIgzslSeN28EtVE/LLM4dEoWd7gODGHggJ5VtRnSMGwLBWvYkkORHxokNgZ/Dxfd2yosYAys7h+Xg15FKoACL84uHRnlCeqz2ma4PXhngm2cp0vseLimMwXzT194m9UvifVO2iUFSGwkLObRpBsfYqNG5iLw3l8aVEGHLFmynZqtm9+E0AkUcnkvOXrjnWVlGn23Ve8+LVt/zzSDaS8Ojis7dME1ex0bUB0jXi/HKscviESuDR+kYJWoW/UPJVtyty917rD40bQ4mAl0Z+weEUn/xg9CP9JW6b2OryMteSjDGdjzYHuTok5Xnn4X68PYM766VUylJekcaff3y7FEjOtpD7Xd59lueRdxAkqsDgH0oWw41HQmkGLz4PDLNPICfyRL9WjSmRyuWV+oLi7gYmJonBQ6QS5PL7bm6iviwqTxZqP5i1tNIYp0qWvusA5JKxiGnpds2bsJKXeSYFJ8wMu+qhl34DuSw3y5bOqm2NEkNtyWBQhdd5pBudbxTa+1p+fPsSQnFy5S/wEfQr+vr922LGsL2z+PWkO1E8MSY6a5l/TTi0Hriv1SiaRIv/hzbuzulDezOJIb4T14n2rsbbLZe0g7CoKKmLnJJ/CHB0SUJpwLkdAaOF9Oh/85mBa3q+I7ta3tNJQ4uf5uGi8tKSazuHyze7Z4YDScuNwF6dY27Zw38PcyAC+VyjfIJlUU5WKa1cL2uVCz62
 Phlze20f
 66oOS3GB5BlZ7Kzj8cwi/y/H7Y6DHbSOWRucu5TpxRZKgHXO05esQtO/jjro2hgE14FwReGawrS89fRTgilb9keAMpf2p4LRMF1JZ6YjH4v+rHHAft+jJSo1ZTFUcuau77OvKE+gPxkv3/lfis7Nu42SxwH+cQ58afMnaVOnvunD1DDeQBejaEb+3qL5kWs3NVzfEIx0mbOlGS9g20mOZPv8EDvyzk8P1JQ6iWHAPVLt3VqGF9NhyV8QskXSVHt/XW50BN9pM8jZ36hMvsop+iQ7dEQJFdoQcESsW1a13GSZzQCYiwjxIupvy+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_mincore() performs a read-only, per-VMA residency query,
making it a good candidate for per-VMA locking. Convert it
to acquire the per-VMA lock, thereby reducing contention on
the global mmap_lock.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---

RESEND:
- using new vma_start_read_unlocked() API, suggestted by Pedro Falcato

v1: https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/

 mm/mincore.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index c086836bc4bc..f989e6d1ec18 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -235,24 +235,19 @@ static const struct mm_walk_ops mincore_walk_ops = {
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
-	.walk_lock		= PGWALK_RDLOCK,
+	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
 };
 
 /*
  * Do a chunk of "sys_mincore()". We've already checked
- * all the arguments, we hold the mmap semaphore: we should
- * just return the amount of info we're asked for.
+ * all the arguments, just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
+static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pages, unsigned char *vec)
 {
-	struct vm_area_struct *vma;
-	unsigned long end;
+	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	int err;
 
-	vma = vma_lookup(current->mm, addr);
-	if (!vma)
-		return -ENOMEM;
-	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
 	if (!can_do_mincore(vma)) {
 		unsigned long pages = DIV_ROUND_UP(end - addr, PAGE_SIZE);
 		memset(vec, 1, pages);
@@ -319,13 +314,20 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 
 	retval = 0;
 	while (pages) {
+		struct vm_area_struct *vma;
+
+		vma = vma_start_read_unlocked(current->mm, start);
+		if (!vma) {
+			retval = -ENOMEM;
+			break;
+		}
+
 		/*
 		 * Do at most PAGE_SIZE entries per iteration, due to
 		 * the temporary buffer size.
 		 */
-		mmap_read_lock(current->mm);
-		retval = do_mincore(start, min(pages, PAGE_SIZE), tmp);
-		mmap_read_unlock(current->mm);
+		retval = do_mincore(vma, start, min(pages, PAGE_SIZE), tmp);
+		vma_end_read(vma);
 
 		if (retval <= 0)
 			break;
-- 
2.55.0


