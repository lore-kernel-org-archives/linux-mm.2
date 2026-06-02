Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E92CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3726B00C1; Tue,  2 Jun 2026 06:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6931F6B00C2; Tue,  2 Jun 2026 06:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BA36B00C3; Tue,  2 Jun 2026 06:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403DD6B00C1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06EE5162A32
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:25 +0000 (UTC)
X-FDA: 84834555330.15.4F52F82
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2E7AE20009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fvw10P2y;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395083;
	b=XU1B2rHI5KfFeLL66WOjNWDVZMY5DLjaal8tO+y3D3KQGd6OPYY5rzb12krYqoO4nOYs43
	ExeteJsbOCaA/r7VdldWxNNbraHjiCc8OUQ/zMRHrPICmBBUAtjQEdHtXxuEdJlA0Ut5L0
	tM70+tEeG/ESEIhsp80ADEnxFgpGYto=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fvw10P2y;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1Kna2jMMM5bJ6rAGniT5H8QaKGxjLzFWpw04bCbO68=;
	b=GV6eQLU9ffbLppJQlACSVGkX30YsWfU3zLWJCUNmx0YHYKISHwmf1/Mc4kq6QDLflrxnUr
	PmmHzOpt8lS2OICb085vSAMA3W3ijvmuGhiy+K05d2w7daVeBPAnyTzV6m5fNbd6HWzWCx
	6fF0R/889zpfx9a5KlJBh0l3hYYZvM4=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84231305a80so1479152b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395082; x=1780999882; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1Kna2jMMM5bJ6rAGniT5H8QaKGxjLzFWpw04bCbO68=;
        b=Fvw10P2yDGp5LrDePUw3zgVAIZBd+F6IfHWTwIalYBfR8J/AQqHEzC4xpOO3dICsPC
         lw4wESxG14rqAfGpFSfFkxKXnxml8qulb7kS27imWtHBP2F+3bn8jCIZpvFP9DD4sYZM
         HytL2gauJmHeJ0xXRud2QkJv7d0AbVTTnPnJjDW79H6zSPsBkeGwBxOGAQ/K4CinjA7B
         a1JOIcKXIwA0MkE92Ggp57qzieNSxOSccfNifO8iNalCdAsby3YINurpbGtAOCPwd56P
         BClJ5cnCuhZJEDOSA1xoLFYVbIHyOVej4W31vjqmHnV1HziwRMEro4PsLw3OBPu3enuR
         9Ifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395082; x=1780999882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m1Kna2jMMM5bJ6rAGniT5H8QaKGxjLzFWpw04bCbO68=;
        b=Ss8bSm8EuNyKyMUf7evILNVXYudKwdAkTp5m3NRy2Ij5k6pay6s3U73kLM1BA8GRBr
         z06frrKhcuNDG8VRrs6rdnL0OAyHwPY95/CKlgeQKaupEz89bcu19M78cWorHNrsu11o
         1mBXQsDZ7vrwjdSPUkSedAhiqCy9F3a3aLOlVI9gQnZTs/SgknsRTfOBdEYQ+4czlw3q
         GfJLLjm9KpSZJogA4op/5vsnbaH49HoL+k1f9VZUYgb9x71WoUv/pwfOaB2ErE0ILrBb
         1HjrponavxJfQbEHvt0NDzOywS4NwS8L+EpUh45zwrKN0DBbV6mvTQlNDeil1mD/4TSQ
         JTwQ==
X-Forwarded-Encrypted: i=1; AFNElJ+imW58SzM0UhfdpVYEygflMG26xDxRNcZkPW6lUJ1WGh0hkUfZyGtnvhj9brVJbMXSZfCThJjD0A==@kvack.org
X-Gm-Message-State: AOJu0Yy0nqvMCCMVfgpw9NoWcWgyAO62u0kL5VroI7aZ3wp+RB+byYqW
	Wb+TV9481AFL6N6PMDEDOV6c4ku8SIxYHMq333yIxRED3S/KeGlqJmzHfPGcUhvIaNI=
X-Gm-Gg: Acq92OFnoBFtmKchdXAo5p/sxFaQlKmXWOVQ9MPkApQwAsYGTHn1xGd1qRzCpBfP2j1
	6eT/sN5Aui2f6bcgGImTudGVoBR59HH6KyHNOjE6OC9FIqVR0e/n79U3IAuN/jVLnW1V935Cps5
	+S6RHJOKpII4kFXzUq5CeoPPKwDRXnAUwM6xhlNzgYAgLqgpZvYTTDsmoj0raF01JeXSY2/TATM
	nRnazRpqCxxrvlqkI/BPzlCsuOgvX1KIW5iA7PDp6XFfNEK+PZH5kM2X5g+6Acip+MHfNyaqoYN
	bcd9QBdF6/hci+iX2rTSnhZZcX2sEh6o+c7huUmszxvU/GuTBUCYASjHPGhuS14jMpef5zep8vb
	Nxenx5GXkQLR5gVe7xZNQlqot0S6eF+NaLE7ZGJlnKvF4w1e3Z9n1PfH3U6wjkErE/1Y3JhyHuY
	jsBIT4cH39Mzds45+15GJDUo+qtUPSIDn0PjsR0vkynwU953dVtnCaQic=
X-Received: by 2002:a05:6a00:4087:b0:842:708f:39a0 with SMTP id d2e1a72fcca58-842708f49cemr2632750b3a.8.1780395081825;
        Tue, 02 Jun 2026 03:11:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:21 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 06/19] mm/sparse: Panic on memmap and usemap allocation failure
Date: Tue,  2 Jun 2026 18:10:26 +0800
Message-ID: <20260602101039.1867613-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E7AE20009
X-Rspam-User: 
X-Stat-Signature: i98p5ba6fr8iekdhaobah8s3yck1ujw3
X-HE-Tag: 1780395082-475548
X-HE-Meta: U2FsdGVkX19LHbqErEyWRdPegRZZJiIMyeQ25vqc276bCbS6JNd6NTeCauu0r6BqPYVhqALhnkkBQelEwPyNPtVTCnbmr2MBOVScIMywqiE/5OfIWvbhbXiQqGdAGw4QaUzE5LWZQASC0YsuGm1cu9ljqh+FI0XoQdeDjfQGXZ+oDwBTeS+TCuUDiLqrRum51D6fGlpd+a8LZHalWqToTtZUfJHAgCvR2zGY5ORoKAPs553eW5bLDu67ucwCZ0+m3XwVnyo/UpVd9jIg5r3zwIZfHLOENsjVXLVyJbD9IUwqM7nEscfkZiJieECjIiebrvAqhz8SKHA8+aOWTvqB44bvSJ3NBmg/2ZsufmTMbv/QnWJW2m8R26eY0QXPhKe1Kkq3TPRJsXRLgPfvK9EKJO2LHMPsdWe9PtAKTCFBSVmd7PvHhg9tJIYQz6wJ8xdSBNe9OPLO4IiOuAHA+fwOs/KR5OO+Vkc9uSMsc41ksF6JGHnOF6/gFrxP8ynIhMn8F9NyI47L2Y7M2vED1mUYV5C6TsL40G5xZGd25ofwBdoaaUwVt2EJSU/HHxGzFNqXinUlZr/qfg+qmf367Ut2Tw1WzZp/1MrtsV3qMoqrfL3uQfgaax69zWr7S1DcLulyNvnOLhS+8ZEJnST2Vu0wbkHhVnmp9wUYgw4CQfQAa48PRgg8PpVMQk5v+P7ZzPX6Y44yp/iUd91S/+uWALsNJJ2ySjzArq8DvltthNFu/LQCF6HyWd5DHxJgDBa0mxoUvel1EN7x24kT6qD+aRN3n6ie6Gd/kU6OwSS0cBlGY4TXh+3vdGBc6YShtM6nHiCzOIy+nWcTU4cgkBPfLesh5YMIjbk9dfh+LhpNkWElK6D3qOBw6bEW3uE0PpZs5lW2IhxbFkLEbCI4C+5JimSDmFD7r2Wij0vyUA0mFN7eHyTUaod4l+n7eFmy0dqj7szBlgsgSGqWV3aKbYxx3q0
 pY8ZI5os
 EnW//FbOUm5XGDCM1I3zLJ2v/gloBmvvu0BbXp2r1eWWAJ53usZZN3LDr4vwUgpaHZFtTcdzEeTomN5iOV2I7LGesFggc2Lz5WxovLkbtsuAwlw8rs3Sf9UF3dFKyc9IMfFj2h/poflMpGuYup3ON177s8oTMVttgnE1p7Chu9BxZN5q+/zf+irtx9CZGVm8DfL16lOJaGNfIln16egBzeFv1yG6sc5EK013gBJZ6WLPcDcXrGIPINQ/vf4GXnYE4Ve6mB5zPwC4xYxg4BhlXFwSMpnbGQQhdr2nPQiPwA0/3VdG2JRvVK4Gc4FnaLwRWV17nYEHhg7T8o1Bn+bcatZhBCPKRowPBONj3zMzKXhfMP5+h0j33a9QoDrfcdWGt667gMYVg6MVO+74kNIujbW7cDnSTIRw1qF4eYl4iosAUTJS5dOXnMCIt1/72vS3xqFy3lEnxkeNxzDif4GTaCM4j03O/r8MaEvttphFooRfm0e9yYQgb5jbzgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap or usemap allocation fails, sparse_init_nid() currently
marks the section non-present and continues. Later boot-time code can
still walk PFNs in that section without checking for this partial setup,
which leads to invalid accesses. subsection_map_init() can also touch an
unallocated usemap.

Auditing and fixing all early PFN walkers for this case is not worth the
complexity. These allocation failures are expected to be fatal anyway,
and other memory models already treat them that way.

Make memmap and usemap allocation failures panic immediately instead of
trying to recover and crashing later in less obvious ways. This is also
consistent with how other memory model configurations handle memmap
allocation failures.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- collect Acked-by from Oscar Salvador
---
 mm/sparse.c | 44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 16ac6df3c89f..c92bbc3f3aa3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -239,15 +239,8 @@ struct page __init *__populate_section_memmap(unsigned long pfn,
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map;
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	map = memmap_alloc(size, size, addr, nid, false);
-	if (!map)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
-		      __func__, size, PAGE_SIZE, nid, &addr);
-
-	return map;
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
@@ -300,17 +293,14 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
 
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
+	if (sparse_usage_init(nid, map_count))
+		panic("Failed to allocate usemap for node %d\n", nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -318,34 +308,18 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Failed to allocate memmap for section %lu\n", pnum);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
 	sparse_usage_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
-- 
2.54.0


