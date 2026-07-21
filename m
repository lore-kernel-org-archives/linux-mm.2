Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EF9C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6330A6B008A; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB6E6B009E; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA866B007B; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0F896B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23FBE40397
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
X-FDA: 85011262224.17.C9E0E45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EA3440005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKJMT4Hu;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6mfpbYSApFYzflQ5j42dYxK9ehbsFEnq3x5wzUCFOY=;
	b=d2/tQtn45mTR6wvZ5EUdb/vJF4LHm4cxXaBmDW4RkHE0Yr1ltPbp+x5gaUMN0/SIz/x8q7
	jfuLTl6S8ackP0iprLPQIraEppxGzzjBbXcfkASAcMNaNZ/iMrL2QB2znw0WzPgXDfnuYY
	fkd25NGPQL3xzHmxU7CFl/CIhumISlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602390;
	b=mrYU9n5d529Iv4aaOcnqerav9TJHtSWIEvf5GCKCGT8PR1SR5xpo//Jn7lulbYyJ5eUsGj
	e2RFNOOeZO5PY+es/931XNK2qxd7+6jL81zRQJ5Pf8n5Nj3Ynr6BowneM6LPWaFzLB0GDq
	nQb0QDbRVeHfgJ25t+MK6YZ/+A/UhMc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKJMT4Hu;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38D1243EF7;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 110A4C2BCFB;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=Us68nlmiczQXSuV6e/jQLLsnNhiOlkPZQjCHR8+MEVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gKJMT4HuK026T3JHk7a9omtQ18OWp7GnSYZ76oYiGMUHyN/YdDGNNMYhGuVVLq99T
	 qwlx0+DbEt+sMM7NZbLbAt9/O3iqNz4Ww/SdV+yYeA5n1sgHapjwFPQRWzD5hIz8gt
	 k83Rew8CVsBVlBKrkMEYTm1H3mb5sU2Cc8CvsFGV+d9RlXFpOEwFlGLUnheMPenPZ8
	 GXqkLWZSqbMTO7eXkIWGNAfzJxFsb1rzAEpVi4iywlm3zXttdHTptmhK2dS8uUQHWM
	 oh17kGa0Pnr1DXUiiZKfE5+QXpQpC8nsihL8pMAN6bYUFTDt0p3m8t0VHabtieI0l1
	 5cmNKkWJOJ8Ww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29B3C44532;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:07 -0700
Subject: [PATCH v3 04/13] mm: hugetlb: Remove unused
 mem_cgroup_charge_hugetlb function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-4-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2906;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YxYG1OGXEwJP8y6Z/IuFu/IygfIhB7TL//GqeViUvNo=;
 b=ODtz7IxzrmEVm8ITYNPhXWX2tkSFDb0Wo55iHcQRNwKOI1rX9vcyL7wqj2XEfXYcaIBA0galC
 iwpBY5zcPvkCL3uWuHWuJCKXlOZCeXKd8EuisExKDwVIE1ZR8hjkV60
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EA3440005
X-Stat-Signature: b7itk3syjwjwkgggkfpb9f5bgr8tyc1m
X-Rspam-User: 
X-HE-Tag: 1784602390-155507
X-HE-Meta: U2FsdGVkX1/H0pxXEe+3AL77UwBSgqD7VsxQvVVd1pkBJo8DlCUT/RjYLpcuOqnVTNq+3ePSysvFdnMi27aGzGvACHEVevP6egYhnt4+Fq2eOX0qpcXYGDEZvhGh6Rg+B3WVC2DW0EXnL3T3NkaXqhRx5xuZc5y3K9wdlEUIdu5+Y420nOtmmBrEiqP6eUftggtZBUQyCYRMjHeyhLc+smWcEpa8AihpwS5JCTld5aU9Hn665fv5WJciyR3nYLheG03NN8U9GYLRef4Ner72sXmFFYvcO+QHQXZFQZKoP4E0Aa61VN/16w8BuztbjGsOmJk0Sgys1i9MfIAmwSDS0aO0Fyb2WwEzb3WKouUctLAsidh9xb6oBbasjy3DqSM3RMk+lTUJCgRKHIZIebMsMHICNGPmS9QJZh/2NSIOnXpkCySJQkR1MQWHJdtBvtzZN0cBvy+fwo+zX61QX0jpioYe9JwziLf6cfMpJkPz/LTC8FmGIaI8sdNV1gIDRT23/T9J4OnsN29jamvzYCqmnNN7H1+9iNtYOnMFYGDX38kRD1zmY/uLQCnqRvn53l3Lkgikb7l4Fw6e1Aotf99nYl+8HuptYfe6vHyPGi+/zIdRCvXbPb2FDbShJ+i49vjKWu215o4/m7D6DEtliAm+m4FFeHPXAG0aW2SC4CmhDB7EfUsHd636+LHGAn+FIoOBwig2MT0QsPzcaPLpJsut6jeOysGxYLefeUiiBb/OC0LOff8HIokfanoW96bcYlqvVftAHpf2RiTNh8ngGFT9yGVTqPiUYm0kphnK6pQDs1ZP45uMzeOy5t4ZZU/JzQ8W1RikZYxRutJ5a9VX2puEyOxA9rsgkCujNvqaAdgwqxoGCpZ9x3D4J2ACu4hO8KUtSX65bWBQCpv/v2LMu+4RbLxMdPnMmPyBf4wUyviHeD/PWjy4xv8e567ZsCzMLZvmFdL3ldAwOaiLf+McZfZ
 z7DqlGUA
 O9Ta2LwyTvCiep+e5zWVkdRzwFlTyZV9y1bGiy6hvtNcxptBe44eubXPkV1w+5zqIR60/EohefURDrn6UDAg9x2Pv8UErDJkFbPBdJp83iYsA7gyUaCgHjW7C9pOBLsvT/PJI9OuG+w0CGesRKMJIi1A08O2PSEeRGiHZQWh42V+eTtNeLjVuRe1deh0M4N2zoj9R1nfcUuoUcJaqDe0Ugn4oFOlqvhHnlzv0fPoM44zVAD1SdPTFs0eglKxnLQn6LzPmHccKqtRtHmq5SUqXFUmuI4Gm+SwDKFZ6h8wKUSAk37ko78x8+qRo1tBqu0Eg3t5grZliQFat2iksp/6W7K87mWawzgALbpH5lmkeJ6JLlgVxteLwdSW7qJtMIfbrUQjZm8ZslIIVZKRo3SXGYPtNv1BM0i6BnLIpU/VsEeOp6fwPhfstRbVMOIUoHqpRPXURCULt8IvVnNgtL0dxjGVxba9jJ3ESv6P/bH5E37NB3y8UQ/pOkh39iwmQ3D2cQB+X+wTR793/aQX6zpMnUTctWKR493BA1EvC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Now that the alloc_hugetlb_folio path has been successfully migrated to
the new try-commit-cancel memcg charging protocol, the old
mem_cgroup_charge_hugetlb function and its associated header and
static inline declarations are completely unused. Remove them to clean
up the memory controller's codebase.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/memcontrol.h |  6 ------
 mm/memcontrol.c            | 34 ----------------------------------
 2 files changed, 40 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c4e63d0e03526..23fbbbc8e11f2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -641,7 +641,6 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp);
 int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
 				  struct mem_cgroup **memcg_p,
 				  struct obj_cgroup **objcg_p);
@@ -1137,11 +1136,6 @@ static inline int mem_cgroup_charge(struct folio *folio,
 	return 0;
 }
 
-static inline int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_hugetlb_try_charge(unsigned int nr_pages, gfp_t gfp,
 						struct mem_cgroup **memcg_p,
 						struct obj_cgroup **objcg_p)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0beee5c0ce93b..6764ff041c196 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5146,40 +5146,6 @@ int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp)
 	return ret;
 }
 
-/**
- * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
- * @folio: folio being charged
- * @gfp: reclaim mode
- *
- * This function is called when allocating a huge page folio, after the page has
- * already been obtained and charged to the appropriate hugetlb cgroup
- * controller (if it is enabled).
- *
- * Returns ENOMEM if the memcg is already full.
- * Returns 0 if either the charge was successful, or if we skip the charging.
- */
-int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
-{
-	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
-	int ret = 0;
-
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
-	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
-		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		goto out;
-
-	if (charge_memcg(folio, memcg, gfp))
-		ret = -ENOMEM;
-
-out:
-	mem_cgroup_put(memcg);
-	return ret;
-}
-
 /**
  * mem_cgroup_hugetlb_try_charge - Try to charge the memcg for a hugetlb folio
  * @nr_pages: number of base pages to charge

-- 
2.55.0.229.g6434b31f56-goog



