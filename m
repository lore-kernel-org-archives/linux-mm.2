Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03248C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA9D6B00A1; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98B6C6B00A2; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBF46B00A2; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347B46B009D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A763B4038A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:14 +0000 (UTC)
X-FDA: 85011262308.06.E33DD9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A3A7E120005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MlNg/RAp";
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24y2t38tDGvrXfaGBCtBYswEDNZd2yV6dsSVqaEbcqQ=;
	b=shKCGHfCfH3SPEwdrqvwQO9HZImPCtR+Nx1kV4CUuxcTeZNkII1kJwMgg2Y8ezaJhzCWbX
	yGSV8K0Jp28EKMfghdSFBBnv47T1A1SF9MFcsIi7uKMozWbqVPjNCS1vF/6l1E29ayESYi
	y+LiFaN3MVEfBrnSWDHcMGNH0WEUFcE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MlNg/RAp";
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602392;
	b=u03uTailAa1EylKprrivtoGlDCP0NvxB/zSIGS8UZV9ffh4yfCzDBSp/FwJosCaQOZXjjK
	wKl/dHl5MlviHAbmTzPwb8wlBfk6T3aytW8VB//dMjA+DakglQcKD7xQ8UwG8HoxSCI3az
	uZrEGylrq+1IdBrxHqjh4r+oA5XxaTk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7305744082;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54D73C2BCFD;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=g68oSCwzT15OMQimNW45wJYcvcPo4quFGfzqB+zzwcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MlNg/RAplDNaPb6B7XrjBfgB8eW3yOcgJlJvX7BL0G09YFKuqHNP/4nPewX0AQgO7
	 eDhNTLNuTDB0PCaO96TUEM8vZ+B6eQ+sXxmU92O6OEUIqQrcJj6SaSNOIrcVCvorcL
	 0L40/v2oj/mqmSRuWL0DaTU8/gnsPCgbTN0+tzliOew4yBI1R2Fj3igEpDNmmC+Lzb
	 oGzXMQR5/WEj4U/WtW2QwFft9saQpoMoY7/evIv6zAaN41Pt5b1tcsBSamTEQStM1h
	 H2BU4Rvi3fnbRcCuOiB0zYIq6BsVZw+egex94yTJ8HH7qhG/MghtPOiyRSPZPnJZ4z
	 UVIkCYVK1EwBw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43133C44531;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:11 -0700
Subject: [PATCH v3 08/13] WIP: mm: hugetlb: Make struct hugepage_subpool
 private to hugetlb_subpool.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-8-7d2a169aa9ee@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=2362;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=M6CZbHlay9O7mPyDIiOB40w5xsbkP4SdrC/EYdyZfC0=;
 b=EKSNPcPFErEcErK9ZdAcLB9AUma7YsDD5mhlF9ptqMRDEPyM8LE51vREzhRtzj/WSlU3plrqD
 WQwh+ogZMhrC8TVS/THJDOBsQh9QXXvOAFq7sC5ey7BszOhs0v7FFYF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3A7E120005
X-Stat-Signature: f19ym8hkfrizos9k5bsjxmrnbjxdfwh7
X-HE-Tag: 1784602392-536672
X-HE-Meta: U2FsdGVkX197MPobbmIKpMLKEuPn6GI+HTS/cn8l9u09L1nbl9/qLbjq8mi0nlmuZp50qpwAJQK6FWlhwDzPQPrfvI1PjirzVxIzKcFGWQt1Bo+fAtseeye7F6Dd99rX0CFSsmOwpIEVdc0o1Crqn1Dy9w4/BuRjcA1iYOdcK2WOrZ5nEHMsRd8qe2sweyeQgpgbAY2PXSun4SGGsl2JLo/3NGrkGk9eta/TE49v29tnxs0jEyT+8HMdwwy5S5HoEWnFfN3fpHTAa6L+9WoULuu3mgs9azh7L0rrjjxYtC4yATGd59ov7fq2Yo/CE5s1KkdU4R7NcNJzCZbIUO3iSeIVtigHYXJDi97hNCtjzNdmgipTrdmI8jm7AQLzFkBtLjjNSNG4mww+BK+z57XOWUALu7jNycpz1H7zYmeUlPOmJnMWlkoU/mGD0j3wx7EMoedekSzCYB3HUGEjBw4pN3T9QfIr8PC0epdN7mVM7XC0OvD1Uu/LoIVoA5iP2Mydeq7TSBMLiQPfpFIsmMo1QGhs895UgnVqwmq5rqaVE3Qw5/W4Wsb+2pzUem73Wi9fh+WvtQsKRdvLVLEPeSUD+oKQ0CNdJm2CHLWvZAG4GHme3PD/Ms9aSoqXHYIwzxn9e5OmtF1d94giB8hDvdrgLIPaL15+OCBkh8Y5qelSVe4/j3peGrcNrG7geFhKOKuqBEkkIoSPh1jCbnraPj4yKsgLs6p9313yitXmxyoy3X2Q9zvNVwIleQAG8RRYrjc/8Yhdr0uZJ/+zmTAI+aufQh+d9Kval1557EDwPtfR38+nvGlSSQPlwChFLML5LcaAEn14qIhUS4qjJlXPALwsSQO5f+NzvSHoCKAiSsGxZaTpi/Wj+V3wrulk/Q1FFk/HJYEmeu24PV75xWhJJlo2Lg7QCm0kYIAsDMj1hBkU4nrwjnuUzarxOyzd41xy7lsfy85m8QM69f33METWyqQ
 1t2VUW85
 cHVQ1g+B5/CYjLPg4MVvfldL9QfYbl6MlLrF17NfdnQriZxpyQ1XE0cmzHyLq+zMNXfCDGVmnCuQTm8e9dxGRV//XiH2Y4E4EzYiHMDGOxPzjtuSq3oTcJXy8Bhv8xjQnFi1LcacIxFa/pQiEDnV3vbGPi/XzttmHYB8bH6Duv0w2cu7qfJRcfDyT4B1Rvkajq27fXTq6gUhW99Fs3Bj0aQkupIZxdWqEBZssoEZhNnosCsmsl8hqxVjlvrwl4cgDr+wGdAS0UXq3H9b/m0+luo1chrLhfASaEQVeNACI6vBqqg5YtR9qy6sG3NX4lB/D8QaYI7H/tyLChc98Oh8ragghoGRsZrmm3UjKPJhTHeKdzCZoVNsFJFswYsYdnHIyynhEN/sbTYoUOnuKL4s/C9c27jPhTgrGqWBY3Z2yyHgLopuqNBr4meYbBE1XoA9ey5q3f08uVQO/ySw3dSX7RcK++kg2SO/K9EvDEBF945O6s/ZsqbsuGTC1ttmFwgGN7nVV/fvhRZM8ooYfToaI9iMtgmF1V6brO73J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Now that all filesystem and memory management subpool layout inspections across
`fs/hugetlbfs/inode.c` and `mm/` leverage the exported, harmonized APIs, transition
`struct hugepage_subpool` out of the public header `include/linux/hugetlb.h` and
encapsulate it privately inside `mm/hugetlb_subpool.c`.

Replace the header definition with a forward declaration, completely protecting the
underlying subpool allocation counters, reservations, and spinlock boundaries.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h | 13 ++-----------
 mm/hugetlb_subpool.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f36be371c6e88..074a45903973e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -18,6 +18,7 @@
 
 struct mmu_gather;
 struct node;
+struct hstate;
 
 void free_huge_folio(struct folio *folio);
 
@@ -34,17 +35,7 @@ void free_huge_folio(struct folio *folio);
  */
 #define __NR_USED_SUBPAGE 3
 
-struct hugepage_subpool {
-	spinlock_t lock;
-	long count;
-	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used page count, includes both */
-				/* allocated and reserved pages. */
-	struct hstate *hstate;
-	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
-	long rsv_hpages;	/* Pages reserved against global pool to */
-				/* satisfy minimum size. */
-};
+struct hugepage_subpool;
 
 struct resv_map {
 	struct kref refs;
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
index 99e7975911079..eb5472bdf2192 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -14,6 +14,18 @@
 #include <linux/bug.h>
 #include "hugetlb_subpool.h"
 
+struct hugepage_subpool {
+	spinlock_t lock;
+	long count;
+	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
+	long used_hpages;	/* Used page count, includes both */
+				/* allocated and reserved pages. */
+	struct hstate *hstate;
+	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
+	long rsv_hpages;	/* Pages reserved against global pool to */
+				/* satisfy minimum size. */
+};
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)

-- 
2.55.0.229.g6434b31f56-goog



