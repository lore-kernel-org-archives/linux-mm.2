Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E41D606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=bsz452Cq
Received: by kanga.kvack.org (Postfix)
	id 338E56B05B8; Fri,  6 Nov 2026 21:29:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9A06B05B9; Fri,  6 Nov 2026 21:29:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8C26B05BA; Fri,  6 Nov 2026 21:29:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D37876B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64EC8402B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:43 +0000 (UTC)
X-FDA: 85406742246.13.711403B
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 28A7B160003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsz452Cq;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018581;
	b=XgKHKCQd3h/Uo77m/FGClrKdKyj2mQxoDjlJ9fl9ziu6GRms6zIhR2gQCWMLOT202tZqeQ
	za/tRk4pA7qUT47SK9NNX8pSREztNcZH73FjPekXbf1zASKWMrSbdvi8ScHQ6Z/XsyVFE+
	Vmkc2iDRMml3NYF6f3Kw2hCFEIqFP0s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=bsz452Cq;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP0Njj2Pc4sOvWsLncKRQe3PWXnRhxBlesqmoRjD4ZI=;
	b=uIUlP5qvYTvslRgKOQ0CJV7LQ2PHBnc0AIvXHHq2sSkDMkmCNbkdTo7NIUpEyukrYy5XPx
	uQz6oTVq9TjX8aZ3kNwbZYCTGz4KPKa8X6UNHiXBDUQA1ePBS2pXpHz0M/9dyfmxCji6lm
	puvRSCAu3TzqXr/d8tEnRpin8uz96QI=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36eb1cb7aabso1898935eec.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018580; x=1794623380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZP0Njj2Pc4sOvWsLncKRQe3PWXnRhxBlesqmoRjD4ZI=;
        b=bsz452Cqqn/3aZjPJ1irZFqYtLY4gUif0BElAF1eKJP+Qe/a6hzcw0y4lrhpwJ7Tg/
         MjDj27ycaoo8F9WDcyNgbL5UGn2slPu4lXHf37JpeEtohs+hPFtKTZ/IR9ehRhbghAsD
         BlZPFdCYuz9+DENzfcZ0ZqqUqmvt00FiUblDHmVBC9yNioOCLTsVRfdLsFX8xtnI8YM8
         L1fheoFWzb+dNOihQq6QuQAEb5uar8AWJ+aYqXAYxJIt20pZj5aP+CCeRtifDZehwxHM
         dv1zkEkClvKFvC5je6sGJI9zN3zPardHS8RC24OAYUS0vN7HbGQ1zuLOfTv7BySdzHmZ
         j/BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018580; x=1794623380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZP0Njj2Pc4sOvWsLncKRQe3PWXnRhxBlesqmoRjD4ZI=;
        b=uAkGvxZ86HSNj3W0H3fDjVPE6OrmEj++wOFyIW4A5+Ri2bFyU/QIRSD6jH0Ln1agTO
         lh7M7CNjkUgUZ0HnaOOVfeaa320YqsFqUJsSu70y2fYnPMKZgOiP9T+p19mJXl2vByfh
         MGm8Nm4ffovPwYEVVfml51zM9hh5u4M0YSM7oedEvJFSvdUgqk985oS166k+Zmp6nC3O
         0JE0CWJz/uclshDgFKYIRIr6BbzCr+Ti2qcZ/Nf77VV7EY8F/VHhE4MQDujSp+O6vf0V
         AyanBTQXUFZiFDJQLj+Vkr6tjJKe/F5oOtzmmmmVZ0ZfzIOIRI1OXRGhD4axe1PkOF6O
         mjBg==
X-Forwarded-Encrypted: i=1; AKwUvBw8bkYuBD74cBIwrObd3UpAWCUYVTciEbhvGgvDr+qs+iJ5dAZYbhn0/NL0L5oG/e6ipDLkeOWFxQ==@kvack.org
X-Gm-Message-State: APuU4Z+E7hhKHX2sdZCECFEgG4Oo2IpO4j+JkSuvh3PhErKSSiGg5OZI
	Iph1OPNs0BVahLLfsOMphvWLWQ7TURBYHE4nujNERoKxY2OsLT2TsZcQS7tNfm/fWKw=
X-Gm-Gg: AYBFou1MEE4ayxqQ+H0lmV9qpvBEQ0YyqVovMJoepWrnJ9x/Jpy6rfuUpnGfE9namYp
	RAsLm5F2KPwJil4yYG+j3w7srT3/98XyllYgGnzerGPVLHoH4ooXuSju4a/eyVG95kg4qnDGx6N
	JsuGZFqP9LGuoshj/t/A1+K0PzfxLb3kZOO0BRdEqyYDYtuORS13i6e50UPhM69lxh9FMRr6xk5
	J0iWeBMLTwo6YJjcQvrzUgo5eJff740sja6BK6J5AEMRvUV6FuJXlGoI7PiwMDe0w+g6n2AbPUN
	SwRn7ulTXqim7cIfDowXcRKEEI6e6hmuU9gdKm5Xl8FY8ucLexEi4Qy3md7Qj3l9K4NZlliSt2R
	SzTm4dM6otr4z7PIQGfdJ1PL8PhwbK7rIgMz4g18SPYZ1CMaTCyuYrUTkQThFuQxmpngigp3n++
	jsyOxzpYSK9Bo0FOYLRLuDF3zdGTqgangswxxNeQDO4NfFAggTymTeDbP2FUCPRMkvxcXWraluR
	Duo1/Hq9ZNSj+FUs3kvBMFhi18nlFOhfdP0X4ATehF46dadwclCKFg3obps6u42Ro/OT1zE182k
	HXaSXd5FxKGeN4Jyu3kz7a30xCWaGmCEcSnDOUcB7C69m0DWsjNnIIgAASz+
X-Received: by 2002:a05:7301:420a:b0:368:6f29:f26c with SMTP id 5a478bee46e88-36f729cfbf4mr5474304eec.4.1794018579654;
        Fri, 06 Nov 2026 18:29:39 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:38 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 05/13] mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Sat,  7 Nov 2026 10:27:48 +0800
Message-ID: <20261107022756.77731-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28A7B160003
X-Stat-Signature: m7wrccna17muztiqy1j6ytbajnyxsp8u
X-Rspam-User: 
X-HE-Tag: 1794018581-260842
X-HE-Meta: U2FsdGVkX19hcgzgQTNpofPuGvSM5RSjjaF7ud6sPRLoUHTJu9WKD4VlldLZkxh7hXoGbw8uTCApx4P8SuJYVvysU4mFram6aBu3unk9S61Q2SN66/ywEZHKFtkYVzbcjQn0e0flZr1Mw5zQmvGZgfiEe48SPMPXvOP79eXJJM367gQlfBK2DTtMAa2AJrdaNA4P6RS1ISqknLFzfzDvcOjm7Io5mGwYt8VCLdNPxLCS7xMkFeENPGGh5TF6HnSP4AOh+cXt/BZzupgo7/Q6mCtwlvVPtI0bqVxOL9W1+1fDUdLf6nUEZaMICZux98qE0L3RBtnT5sFfW6RvSvrY2lezTFUuST/IFIU0z8zDYzBs6oe/x53Eipz43ho0k0YUtHqiHqTwAHjV4hntPUX4lAlGnkzei3ZrbDFSoeNwBVlj9K5uH2Tf4m1xA8TnIlz/Ek0+fH9N1lr1UvDPUgub3OteY4/NuS3f8kTVfqrzcXxC4+/6bL5XHqePeiYTaqU7scAtvketwB/v1h5qps1YPIf33HcLH1D0kS+GeEu6Qj5UiA1UNlY+4vLixxXTQpKSPPefORdp6SsyrXecHdqlfI+NFkFbtm3P1RiWbSdMYhruN/okd4YnkUzoccnfZspmKBiako1D7W7gsUv1b6liS63whbKxDT5m04tFGoojEhimFBe5okM/racZKta1a6vkDprgR7phBuYDQRKDaObBHCQr+qyWeOiaDFaEkpJ68TAAcwKhi8Q2qc/XajMIHds67xtH3vyZiFjaTaYSbxXXx3N6AclQeePnNJH4gm9YFadE4wPOHJsaNkp/vuyZVnDKgp3rQ4Fj3fI5kapqZ4eWHW2FPqPIB9mnHt9si3ae/U4sr7n98xUtGXKcs+3PGxgp5Xbg8cLwPMCg0SHKjyXFSbH+AVo7wII1zg/GLhN6UYeKXD3aS+D7GvyydBb0NQEH9bhxTS7+TXX23UZJViz
 1wNrlyao
 6Pv9lRCR3+uSoY9yFcC9MU8263+KbHMvcgCdyvkGeFbXAya1tUcfc+jMmWtgRSK2Uaco77Bo74r4CkG/HtOI08qDmf6wbvPJ3qdm5GAWasqh8u9uhfn5t2WgKQQo6eIGgYIgffb9v02+lQ2/kgbZO3iGj0V5sq/VqEh8GtO0ETMNfpJEk4LRo2EgTTEf1QoeHpCdNPgGapA8audb2HtKhfaupSKQ3K5q2jJcyiNmdRuegTTe626oRqPUv50cC2A+ntpmKDKYznjhJM67K3NQl6IseYFjcDiJRZb78OG7xpYsnMMnSh+3Q9SdKPCXbMAFAvabHie6TyN0qlQru24bagBpsGQzKgnBg09Dcx1OSxeoE/+Y1UlES2tUPRGWXE/wy82Cw6sr8G36WWYwtN8Rc5pV/OSHuVaus3Nv8tKfDstgiDOAE9T5WYsoCwjlJ/UBA9Hxr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap page allocation is currently tied to restoring a virtual range
and assumes an empty destination list.  These constraints prevent it from
being reused when pages are requested independently of a vmemmap range or
appended to an existing list.

Generalize the allocator and give it an all-or-nothing list contract so
the restore and optimization paths can share the same helper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Split the OOM-avoidance mask change into a prerequisite fix and pass
  allocation policy through the generalized helper
- Propagate alloc_vmemmap_page_list() errors (suggested by Oscar
  Salvador)
- Update the commit message after splitting the OOM fix
- Collect Reviewed-by from Oscar Salvador and Mike Rapoport
- Collect Tested-by from Andrew Morton

v3:
- Use two tabs for continued function parameters (suggested by Mike
  Rapoport)
- Rename the local allocation list to new_pages (suggested by Mike
  Rapoport)
- Use a goto cleanup path for allocation failures (suggested by Mike
  Rapoport)
- Free failed allocations directly and retain batched accounting (suggested
  by Mike Rapoport)

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index beb420c57ddc..290dd8f31738 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -334,26 +334,24 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid, gfp_t gfp_mask)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
-	int i;
+	LIST_HEAD(new_pages);
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
 		if (!page)
-			goto out;
-		list_add(&page->lru, list);
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
 	}
+	list_splice(&new_pages, head);
 	memmap_pages_add(nr_pages);
 
 	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
 		__free_page(page);
 	return -ENOMEM;
 }
@@ -373,6 +371,7 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			       unsigned long flags)
 {
+	int ret, nid = page_to_nid((struct page *)start);
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
@@ -380,8 +379,10 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
-		return -ENOMEM;
+	ret = alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE,
+				      nid, GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -501,7 +502,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 {
 	unsigned long vmemmap_start, vmemmap_end;
 	struct page *vmemmap_head, *vmemmap_tail;
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -528,15 +529,13 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, gfp_mask, 0);
-	if (!vmemmap_head) {
-		ret = -ENOMEM;
+	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
+				      nid, gfp_mask);
+	if (ret)
 		goto out;
-	}
 
+	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
 	copy_page(page_to_virt(vmemmap_head), folio);
-	list_add(&vmemmap_head->lru, vmemmap_pages);
-	memmap_pages_add(1);
 
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-- 
2.54.0


