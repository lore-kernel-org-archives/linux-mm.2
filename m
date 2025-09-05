Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E08CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79518E001C; Fri,  5 Sep 2025 15:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50B78E0001; Fri,  5 Sep 2025 15:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D698E001C; Fri,  5 Sep 2025 15:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 855558E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFA0CB7BA8
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:34 +0000 (UTC)
X-FDA: 83856148068.27.99F88C7
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF3E11A0009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hNrLojFj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099673; a=rsa-sha256;
	cv=none;
	b=aPp3/xvie7E+buf/EyrIjyTVGpm3GIUbbuu6H+TX73Ag8Sd4mu2xpOYYCMu6eVvTxP476a
	+vwQJxEXgsCZhbhXNok+rNI1Iq2qmZckejXZ4P4DNHMt3ge9asmYKn5VgzJYnPL19bjqxa
	0NYuW3LMPZviGZ1eelI5pWGDHoGKU9I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hNrLojFj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099672;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hz/rwuCJ+AfNnA/+slxKdJ9Vt8t8OYTTKbWi35Lmcc=;
	b=H2Svh5oy3cJo876rqar3hGnD5FWmXYEefpFJ3tJVtNOvxUvVx5VhVbpbxu1wPTcqc4uwLR
	qgZAKUlSorfDYlELoX2hb0dAd1IEHKSxj0GeAez5d6VZCxFD6epZuaM6UHpSHbGTu1urOp
	EieNMszpN3BN6mTTCavGQjhMOWtW7vI=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772843b6057so2077329b3a.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099671; x=1757704471; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1hz/rwuCJ+AfNnA/+slxKdJ9Vt8t8OYTTKbWi35Lmcc=;
        b=hNrLojFjBLCuc7PR1OGnlPm/apBXxzi9WlLKrJxWjbyw4lZWs3z7FQyaVDiryf9fvk
         tSDBkHw7zzyJO7/ISFkvZ5aqh27TnoVsCdgT5E5e80xiiVf2t9Gsx1rMvPW28UaYDZ6Z
         ONHxbQacCTmHSTmuWbng+UnJRb64HVOp1nesxGBksO6TPZyD/5bi1WeuKEBt7q/ZOd3V
         V4bb1Onnea+pcK7cm6CpjY/H3vQOdefCSlewe6e+139KFY7CYYkXGT8A/mWGU9poDAbg
         hpcT1oBLVvNn4oq1kzHWA4pQI7D5QUvvhdKHBbwg+uW3p8iFoeVeo3HPH6buauBAjLi/
         CTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099671; x=1757704471;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1hz/rwuCJ+AfNnA/+slxKdJ9Vt8t8OYTTKbWi35Lmcc=;
        b=W1vH6DaAPSzebNYxpvomMzVFyJHdBczxir/bktxi7tj2dAAJcZOaJF/sVDrn+ocOS8
         T76HBBsLMaG/0FNmxQFj3ankaHyzXJJo3Zro2raEHR6NUwR6+tFwmtpluYNJ9+FWnttT
         5dfnp8u72Si04pSmyRYHHqtEd37i9dm6m3O6hY4mb+JLKa7qX/udEakSKWWFORZ8l6l7
         JuBmTWk70mb1N0+0n5vydXKBGrOzbcwx0rbdMYnImjFxrt++DRfLs/mKAmuzwkfTEM/U
         DahJ9+e0kkk0ywJjZY6mpk/PuMdWBhnNJKZUOg4kjtrzQYyxHi9/ctIz0MTjRnLntiDQ
         znRQ==
X-Gm-Message-State: AOJu0YyGOLIt7ps4rJmaDPjVk/7yni6fzFffNfjW0iJKrbZTHiiLcxCV
	q25GRcJqJHfdE8eDV9pd/ER3JJFltlr20PK6SSfBCPHdQSIBOKmydPNteSioV8Z6Ppw=
X-Gm-Gg: ASbGncsUmnEPRvSEjKT9seQUQHjZtX1JzMs3a0+Do989VR6AwCXnAM6dNrhlTDsqIrs
	71sKxymaVBncD/bbi8S3R3HebHALdZeQ6DocQY3XbHQHTgkaOPuQCyGFzWwExs+qMiCSpFqrfBX
	yOCR67v6niVHAL6Y1X41+A9GsKsA6lkbjbF7Ieej1ORKSCn8mp2KOXruUBXjnALqo/KoCfI5Fma
	hOEdUPU63+3RsaB2mTawfXNotU0yEOhOYzTWCEGNHthETYqZ3Vut4DXN9L4mKIWGAQkG1uNfND1
	YsDz/oBjUCk7PWtzfgSiZTOawdgK5lAs8l64diOIzQCUwySK3JdLFHdxiuGJZUhMHdelCkDwLvy
	2gRN7/GrOYPLpe2CXs+pe+ji8+vQqpvqEFx6QqvVxJ+XyZz0iXeFnjnD6fw==
X-Google-Smtp-Source: AGHT+IGfH9fV1AgSl0wv8tqYCRcHQb5tSEyNj8zQqgrgjfFl5SnhdLgFSlUza4Y9ihJjnD8NLMJuyQ==
X-Received: by 2002:a05:6a00:984:b0:772:5a3f:7cbb with SMTP id d2e1a72fcca58-7725a3f84f0mr27740818b3a.6.1757099671272;
        Fri, 05 Sep 2025 12:14:31 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:30 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v2 04/15] mm, swap: check page poison flag after locking it
Date: Sat,  6 Sep 2025 03:13:46 +0800
Message-ID: <20250905191357.78298-5-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DF3E11A0009
X-Stat-Signature: zcmss8tptm3gx36ury5nu1bwfequ5q78
X-HE-Tag: 1757099672-75415
X-HE-Meta: U2FsdGVkX19a/FyjKVumJD/BBnt+8bYegyAW+Lrujby/nIt9+ejBMWNgLBPoLBPskItBnD4nLhX0UXX87x00xadbIQy11EthVyOChfkrJERrRz1XLGG9TOoKoABf4JPyCHKHmniJb/I8Qo25zw9feGfKHtw5qct2/QXS4m8xqSf1JC13XYBFTfVnf5WAbJuklOnNM7NW6q91D+JTTKTAb4PfWH03Wov0RjbE9A3fN9dpTKqczXi8YodcFAmFstm0iJ2OegXwlKTOz3xbt2Uv9m3pfn3p3M53eOQkSCpVEjnjQH2fgBzyPoNHA64pNJWwrZQPJ7qB3cESPrNSUS9CF6lquim4lu7VCTb+lt9Npqq2PfZaIokJ5QU3La7lKFWVkvW1lo5yu5SwSUFQgREsoR3o+XrsMW0QzrRPlZg6xFlqrrzxBlTnhWoefjphUWmChuXAcMu2qWLveCJ4WOya2xnWGkswnR5MeLA0e19TvKX03iizkhdxR3pbLACP2C8yn1bQk2OOF8EocqwcebfYZcHQQ4LjKpWLUhZgoupLeF9wjjeqZ77Vck1vqkL1PGpBJ/QE4uHd7be1CrL+32npGos3j3Omt9Qg3sq9I1zBbA7pBm5dAx/zSQN3nbdbD/xu11cg8lVjz0aK+zgB09GgG4mD6nIGuZrN/ehzFOo4EfjeUqwMizmuY0Mn267BhUhyOevq44xufknYvHajEuWQQ29wDqav2x9vgV2l6VoxdVLbm3WNICvffyuQdlB8WOG/b6fmjO8/rHtS2LHRC/1MGvqjE3eAFjnjUAsIbwCzif+cwU5TRPT+E8Z/0MOfSZnKAdnCZhmhpEDXmFPInP0twvYBX61Rxolvq9bHGMq/pzU94kP+WdEZIac7NHps3NouwoCvibAnjsaGP0dAzgsSwCbwZMyGL5VH45Ph0Cyz5y37ARxVRecI43JlnsM7dGX6bSs9zC1BHUFvU/fxIja
 Gy+2aDA4
 1+DDUDldepA3k99Ywg6bN8J0+2ygvh3EWh+bEQjdU98ymLwQKtT/JKVPAG7IVjVv7IQKrIay99PFh3lMh6JVjPwk7lca1/iP44qfboEga/zltNU1YCxgKUxSWxAIpIfcYcq8X5eznTpUw26mKobyL2CptOV3y4wQIVc3iIhkFye33aYLEVn4AyThCyigTC4kAM/gIrvZ2sL3ZQnmjShikgkeTQZcotN9Y2UBeYZPy92ZBkkZc9uklbB5z7rMlzOODz23lZVQ2O/Ficbk00avGfao9I5lvdTQAIcPhwb8A66Y5XfCCn7n9GvPaJ8JWaYWBV2XPvXFD65vhFUrLYkeAtLuXhLeKHkKZtg5woZ+3R+8jnXZ2BIXzFMAKBBE2OyW/FSuISSyKqNSMPpNxxBUBCMvnfkHrSPN8OYAK4GMMLuRTZJNxKcGndOAMAxf/MfQewBNqI/NbLQVGKKPqeUOkeOyL9Q1UitjPecCSYRlg+clpVcIXe8nT1kMEAmkcdyEckRJYOT9ZAYy91hJN+VPSS/l7EOCR/sTwryluN2jF+MzdsPus4WT/HjXo4KZLS0RpVnRB/EggJW1/VSlOdumyIHDuKStTd2/O3M6+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of checking the poison flag only in the fast swap cache lookup
path, always check the poison flags after locking a swap cache folio.

There are two reasons to do so.

The folio is unstable and could be removed from the swap cache anytime,
so it's totally possible that the folio is no longer the backing folio
of a swap entry, and could be an irrelevant poisoned folio. We might
mistakenly kill a faulting process.

And it's totally possible or even common for the slow swap in path
(swapin_readahead) to bring in a cached folio. The cache folio could be
poisoned, too. Only checking the poison flag in the fast path will miss
such folios.

The race window is tiny, so it's very unlikely to happen, though.
While at it, also add a unlikely prefix.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 10ef528a5f44..94a5928e8ace 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out;
 
 	folio = swap_cache_get_folio(entry);
-	if (folio) {
+	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
-		page = folio_file_page(folio, swp_offset(entry));
-	}
 	swapcache = folio;
 
 	if (!folio) {
@@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		ret = VM_FAULT_MAJOR;
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
-		page = folio_file_page(folio, swp_offset(entry));
-	} else if (PageHWPoison(page)) {
-		/*
-		 * hwpoisoned dirty swapcache pages are kept for killing
-		 * owner processes (which may be unknown at hwpoison time)
-		 */
-		ret = VM_FAULT_HWPOISON;
-		goto out_release;
 	}
 
 	ret |= folio_lock_or_retry(folio, vmf);
 	if (ret & VM_FAULT_RETRY)
 		goto out_release;
 
+	page = folio_file_page(folio, swp_offset(entry));
 	if (swapcache) {
 		/*
 		 * Make sure folio_free_swap() or swapoff did not release the
@@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			     page_swap_entry(page).val != entry.val))
 			goto out_page;
 
+		if (unlikely(PageHWPoison(page))) {
+			/*
+			 * hwpoisoned dirty swapcache pages are kept for killing
+			 * owner processes (which may be unknown at hwpoison time)
+			 */
+			ret = VM_FAULT_HWPOISON;
+			goto out_page;
+		}
+
 		/*
 		 * KSM sometimes has to copy on read faults, for example, if
 		 * folio->index of non-ksm folios would be nonlinear inside the
-- 
2.51.0


