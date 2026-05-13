Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04249CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 21:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440EB6B0005; Wed, 13 May 2026 17:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1D46B0088; Wed, 13 May 2026 17:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0A76B008A; Wed, 13 May 2026 17:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC6B6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:19:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D04F81C03AC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:19:57 +0000 (UTC)
X-FDA: 84763664034.12.5220B2F
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2335A12000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:19:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZE4kbJR;
	spf=pass (imf29.hostedemail.com: domain of contact.kartikn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=contact.kartikn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778707196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=79r3Xvm3zHl33g8qNEsQlwXC0J0bAYA0YdKvzx0CR7w=;
	b=yO5E1M36TJNA8/G3KFpxL7Tix1p7TK0me0g9vsuxguwnA/OLmk7keM1bT32lhF7rINRLO/
	6A/joT+m+B9V2LlQPh6RtWjbEhteO9IP3LolpG8yXaGNawc3Bfs7vY74kb714hZDEnnaqV
	p9a4e3u2fb/v2eNmGmEwC467OX/n7GA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aZE4kbJR;
	spf=pass (imf29.hostedemail.com: domain of contact.kartikn@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=contact.kartikn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778707196; a=rsa-sha256;
	cv=none;
	b=ENuQ6YO1fjBnxm+IiuF2HVsc/ENc5fM/lSN+S8NWa2fqemylLe7/8b/eewMhCrvcKYfC6k
	0vJUmlqbkOeOTVImttPwBX0QPqHCOU/WwZjvnbVtG87aMNb5c7QKMf/Hiq5jwbUnBFoP+a
	kwWFVo4JEIabiORiJfW9UccYh/tP72k=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-367c2a39fcfso2821807a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 14:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778707195; x=1779311995; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=79r3Xvm3zHl33g8qNEsQlwXC0J0bAYA0YdKvzx0CR7w=;
        b=aZE4kbJRjLMRtfloBOM0je82LFXxevq/HawRHdFeS72Bt25So12Lo/3SoPLbYRdVQ8
         J4wnHOUCEBIkTNJcVfLu7sdet7cyky9q3RtjfdL8AYSEU42SWRxAVUCc1Jy2K6AQnYNT
         +krhT1G2FIgKEg7t2CMwXoZ90U2Ja1ZacO6gT6WXgV4JmN+TYbWFlEGdqJc2QxaCh0YN
         OA5akK21uuPmXuVe9rqfWlIGVnHC6LrD7OGSuVw8hycF8mK/Pz23oHKlpbh0OY4E+KDX
         m5dPm+an2NSc8JC4ukVF+gbL011Ov6nn0clL6cs0l5mqY+TPC2Xcss3lQXo+z6titdXW
         r3hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778707195; x=1779311995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79r3Xvm3zHl33g8qNEsQlwXC0J0bAYA0YdKvzx0CR7w=;
        b=GWqOHMNXwLP5Fbu4U0d79AUHPqzeuBng4ClBOwDV98KE/H30oUpfcpiXEqA1Jrq9Dw
         /+MOYLHkCZDThX7jAoOVm6w6Gt+reS45mG/B8HLQolzsefnYmC8f2YKekLQVMW1OfMdS
         CmwmU5A3msfXOP/c75uCff6GIcQCCNDUBuerpqormtjneHP1NehIiJcXZG1GnwpbxOMi
         +tO3W51lsKE+cXIJGeWes9vr9RTxd/+jZPNBwcbRIIWMqSwna4CAKPDyhYklKgnjJpUv
         zWy+rIzN9oJ4WIUDLfF1btQI7jK5pHd5C6pSST28ct06sWb4+D0IzYjcyFtpCHhTDz15
         ohEg==
X-Forwarded-Encrypted: i=1; AFNElJ+9E2Eev4pxVw0va0398LSNFHxcNmdguB4H8/BKsXEB7/m7eCTh4gwIdrEVOrsEtRxOEtoZU1efXw==@kvack.org
X-Gm-Message-State: AOJu0YxOuODwa9L/uF2x9r4d3OK0COIkkuMfRL/IISGaBnMBWHKPSk4T
	o70xKoPcOvJixzuk0kbLr93Q2SSwVY5e5d1EvuKa+79xC1pLkPnCE0C+
X-Gm-Gg: Acq92OHXQ4VnbrwhgV9Kx/RCmG8kZrmviei3VPKttp4zFCCFNar44syZiDnaWeHR+qR
	0PI3KSrSM16bdXg6gj/UaEiDcOzmD/7OoInmt6N4brzyquCcTPC+jieaJw5piod2AQIiY3ZHdlB
	HPnWdOwc+RNa7NK8g7w/FjX1N+eljNL6le8xJ3xo4r7pXDF9THDVvMEFPnNaZ0WfOT3lgRowTb1
	IxZCtbNi5y8Lm9j3cS88gBvhMDCIILj8zAACZqCpYKAmaQceFSN4KDmO6RgsIwJUvTcZ/NyaSI7
	RvVQjRdFMfKWZInn+ieju9uj2+koSBFDC0sZokelAm/8NKYcMJy++gJA8ICEUCQElvdUYVJezDE
	MngyOpfFZUa5wqocBo4ehModqqIBk8DhGbgjoLvR8EBaFRT5OCzlOicwlPF37G/A7eEZRMt7E6S
	rNx95YH5z+iS3O6ZroODf52KfX30e2uCKHc+mwK21nco6JL+7SObzziM8M2A==
X-Received: by 2002:a17:90a:fc47:b0:367:cb53:7436 with SMTP id 98e67ed59e1d1-368f79f8744mr4805466a91.27.1778707194819;
        Wed, 13 May 2026 14:19:54 -0700 (PDT)
Received: from localhost.localdomain ([171.76.86.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-369224d0130sm354725a91.0.2026.05.13.14.19.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 14:19:54 -0700 (PDT)
From: Kartik Nair <contact.kartikn@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de
Cc: david@kernel.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com,
	Kartik Nair <contact.kartikn@gmail.com>
Subject: [PATCH] mm/hugetlb: fix deadlock in __hugetlb_zap_begin() by using trylock
Date: Thu, 14 May 2026 02:49:27 +0530
Message-Id: <20260513211927.4206-1-contact.kartikn@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2335A12000B
X-Stat-Signature: ndrj5xmczctt94x7pa43isi3c8c4gh1k
X-HE-Tag: 1778707195-953622
X-HE-Meta: U2FsdGVkX19dd7Mg6OQTXQXM23lH+3rRam8rBgFfqYTLfspHqfXW1Z6CCI5+vofFmE15toZBEdU7xkNJmezRa6bIckDiz+6E4ufB/RbPB5ybW8HhwYT16QWP2P5PU02Ko107i0u1mL3s0M8ppCC1igLXW8fYKw2WPei3JEzw8j2LJXR4T6hJegwCQqabFy8qDdOjbIBrmSqbBTIx6AfUeB0mpEnE7SGm8ZRuXLUIT1vCs1yZxr6pfdMTviIJpZPGKiTUjs+E0QWWExTE/4g+xm/j10sgwj85vLaQVFjKlu/uUYBud7mezBZtC7G+6CFj/XCrMlA/L3BRQYs4+tLl8Uf7yCO7egYCH7lbTmIg01MeRL8GstX4BYJLy5MZ9qmlSZPcyNrfBhE2cDBOQ/sD3EsztjXi3YrGobynKEPJ0JCitwBFoECWb1ffkj1Aa1VwZ7gsmVxiBgJYCmn8kfX6fdznAgcWZ1ZHBc1ybP26kWxzVq05As888Kd76u+V03AnA40wp3TsX0qcG4ar4wmt15huYoNNAoPRFk2OSMNQRgwMxy8WhY8gM4iecpcU0xSSw2LTjs9y4lciR6yC7MWfvbcfr8plO1n07tR5X36L1hN+lgjb2tRPyWrC/lQfQIc4MOMQtYNYBbjL2NyMDNIEpaCwHUlEhWyiUyL/CM+1J2dz01rVEDTADQUGzMlIilQVgluY2BivpfRJOHUvxbm2nLBkvEm4h7NMgHk+4nrVojPO9IiOD9L+ADx3QJ2xbHCpOgUrafkoRFh5pnHOBgQ8S9q8IU3HOp8zTUnXc3Q7vv+U9JerognqSQaEi97+bRjOYxsTe62DvWtSd0jTdkDv4Gi7lZq1efHFnEF61AEjqDD8mgA3ql/a2ClHFS3VkcqUiKoTQpwrWyhlDhWmyFD7ZW1ipkN8oFN4MOq+afZpNMWUOe+uCmn4rHIPbvsP0//cqB/k9xg3ksUi0t+gmt4
 7usBBhaX
 k1nZyKOIPC1oKjUcU+CDx3afjLYZG3BoVtTG9njNISOxH+mdipQlU3zSwCpI9GyKXffugfbYq4+ICsonNMPXcullqSw9Of/rgMofPcFYK0dTsPBeWYQxT7VeSHJoipDhnJhrN2j5xgCZOD2VOakFsYAbd/jrvfmVGxbjEyn0yU+q6Uojpv81KdDyR+uqi1K3m2UFA46ESn1E73TBgr+YM5ZS3kdD4tV/BwX23cdmkLB2124WfuEaiYjO2hutOD4/HfQM9No1URLZyz378xziVyEvx7mtO7gHCE0CSUCJiNV43KAWR7UTh7nJmZZDEVeV6+w4AKPzN2hMAOQlxd+wSsJaCn0QcKvPrMn2xWMLr+y70rak/KeW3NkKilL3CtkOGdPX1MT2K7UKE+zgdoV02SKNlCSsOwHh3++Um5p13oaOPBQQL3IkAgaFaJu7sQJkJ68GqneUXBUz7nfyCFCAVDaszvtdYf7bTgzCE6e8DOA0y/8e1DRah3XhUenzDEoxofb2xiXHz//TD6mLgaQ+oYfWVIH4G6kR+sQmYzWBx7ySo1rjFMSm40HQd/dPzfBN2jUBUrNOvtPE6a8RkiOmmkMBQgsyKosP6UwPyUhWrD/wc1yW4fTo8G4u/dZsvx2ZL9Itxq1S1UzFFMaJ0+HMy9MDxFDuxVmjmOvNj3LsNmlkYISl5rTbYjV4Yt5goe/6/Z5GrqXwMxLUxYYZDvG86Cx6uh+aV77FkK+NP5JZhZA7tfOQR2PPKhBkTFtGCpqkr0J0MBs2C2AicURYc/N/nWI7Eyz4TQGBdUAIMegwFyjVY9Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a circular locking dependency involving
resv_map->rw_sema and mmap_lock:

  CPU0                          CPU1
  lock(&mm->mmap_lock)
                                lock(sk_lock-AF_INET6)
                                lock(&mm->mmap_lock)
  lock(&resv_map->rw_sema)

__hugetlb_zap_begin() calls hugetlb_vma_lock_write() which does a
blocking down_write() on either vma_lock->rw_sema or
resv_map->rw_sema while mmap_lock is already held for write by the
caller chain (vm_mmap_pgoff -> mmap_region -> __mmap_region ->
unmap_region -> unmap_vmas -> hugetlb_zap_begin).

Fix this by converting __hugetlb_zap_begin() to use
hugetlb_vma_trylock_write() instead of hugetlb_vma_lock_write().
If the trylock fails, return false to the callers so they can skip
the zap operation safely. Update hugetlb_zap_begin() and its callers
in unmap_vmas() and zap_vma_range_batched() accordingly.

Reported-by: syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd6aaf99e8443d8a9034
Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
---
 include/linux/hugetlb.h | 10 ++++++----
 mm/hugetlb.c            |  8 +++++---
 mm/memory.c             | 10 ++++++----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..1972464bd92f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -244,16 +244,17 @@ void huge_pmd_unshare_flush(struct mmu_gather *tlb, struct vm_area_struct *vma);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 
-extern void __hugetlb_zap_begin(struct vm_area_struct *vma,
+extern bool __hugetlb_zap_begin(struct vm_area_struct *vma,
 				unsigned long *begin, unsigned long *end);
 extern void __hugetlb_zap_end(struct vm_area_struct *vma,
 			      struct zap_details *details);
 
-static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
+static inline bool hugetlb_zap_begin(struct vm_area_struct *vma,
 				     unsigned long *start, unsigned long *end)
 {
 	if (is_vm_hugetlb_page(vma))
-		__hugetlb_zap_begin(vma, start, end);
+		return __hugetlb_zap_begin(vma, start, end);
+	return true;
 }
 
 static inline void hugetlb_zap_end(struct vm_area_struct *vma,
@@ -318,10 +319,11 @@ static inline void adjust_range_if_pmd_sharing_possible(
 {
 }
 
-static inline void hugetlb_zap_begin(
+static inline bool hugetlb_zap_begin(
 				struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
+	return true;
 }
 
 static inline void hugetlb_zap_end(
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be047..dd55ec2ef007 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5309,16 +5309,18 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	huge_pmd_unshare_flush(tlb, vma);
 }
 
-void __hugetlb_zap_begin(struct vm_area_struct *vma,
+bool __hugetlb_zap_begin(struct vm_area_struct *vma,
 			 unsigned long *start, unsigned long *end)
 {
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
-		return;
+		return false;
 
 	adjust_range_if_pmd_sharing_possible(vma, start, end);
-	hugetlb_vma_lock_write(vma);
+	if (!hugetlb_vma_trylock_write(vma))
+		return false;
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+	return true;
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index ea6568571131..c1451e5b6ee7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2158,9 +2158,10 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 		unsigned long start = max(vma->vm_start, unmap->vma_start);
 		unsigned long end = min(vma->vm_end, unmap->vma_end);
 
-		hugetlb_zap_begin(vma, &start, &end);
-		__zap_vma_range(tlb, vma, start, end, &details);
-		hugetlb_zap_end(vma, &details);
+		if (hugetlb_zap_begin(vma, &start, &end)) {
+			__zap_vma_range(tlb, vma, start, end, &details);
+			hugetlb_zap_end(vma, &details);
+		}
 		vma = mas_find(unmap->mas, unmap->tree_end - 1);
 	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
@@ -2194,7 +2195,8 @@ void zap_vma_range_batched(struct mmu_gather *tlb,
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
-	hugetlb_zap_begin(vma, &range.start, &range.end);
+	if (!hugetlb_zap_begin(vma, &range.start, &range.end))
+		return;
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
 	/*
-- 
2.39.5 (Apple Git-154)


