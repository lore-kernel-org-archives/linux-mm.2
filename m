Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D04E606E6D8
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UhCwhlHW
Received: by kanga.kvack.org (Postfix)
	id 072986B07DB; Tue, 27 Oct 2026 11:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17306B07DD; Tue, 27 Oct 2026 11:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE866B07DE; Tue, 27 Oct 2026 11:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA5876B07DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0422AA0947
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:01 +0000 (UTC)
X-FDA: 85368834684.05.3A6E34E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55110180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UhCwhlHW;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seQJ0RkpYsv0DnDnr/texKmVDxEFVMoOUeLo6OCf//M=;
	b=dvStJpGc7ujdFRwr0Qw0iye6KAL2cXdwWiz1xiLa1HX6JE3NE53xiZmRRn9+TPQxhyHPfX
	Ad/mOR65ppyH8w5tBRZorn1bP7t5jtWxmUBFjWCIH3+jGlZMZc/QgCb55zw0QAEaWI8+Mo
	f1UMVwre2AxlEwhxKuMkJP6uqnJPnMM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UhCwhlHW;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116020;
	b=U/R21NnIdHfS49kdxgAccM7pZdxvbxGw0nho6dIa4oyQw8IN66vcxqkw9U6XXXpoXVofGV
	vIZsqRuo8RJgf9Znx658PSjBKbagZEObDc6sZkBcn0UXRvH4LXm1AaSewFAzUlpPRy+ACj
	6Ue1vcC9Lkj64ZdU7bU2AaTDla6Ty1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3CA743E65;
	Tue, 27 Oct 2026 15:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E6D1F01300;
	Tue, 27 Oct 2026 15:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116019;
	bh=seQJ0RkpYsv0DnDnr/texKmVDxEFVMoOUeLo6OCf//M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UhCwhlHWqRSNVp4V+PNk+6LOLtxBDSg4RhoIkr0OuVQoKO77yc1WMcPQ/qci8QG1+
	 n55kHT7Ssw87wyF8y4YnNchXx2zle0vmSX41KWVTtuqkzl/SzeFaF1U/RPrmXspkKt
	 hk/DDiICVG1ziAdCCYKnrz6UAgUeqtZAd0w30XWfQxYTXTeXxFWEedK537/wSL7AMl
	 19zZr/IgEn3PEzEgbbbgJqtFp+LA7Px2HDTnkazCYYWye2Qnm94zoo2gbmDK+451sS
	 WqdWnzHPIKR9biYySf+1pl5K+iB+NW/6RXNmoSOLmWQB4Ow7P9HDBSdVBsyLRGb1b7
	 1JeOZ/VEVaViw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:33 +0100
Subject: [PATCH 7/9] mm: page_isolation: do not take slab pages for free
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-7-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55110180003
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pgiz9xy6dxjkazo36mpb5yaqc7t1oepr
X-HE-Tag: 1793116020-681131
X-HE-Meta: U2FsdGVkX1+0hpJetU27ZPvHx5uvumVNecpIKiEQc7M0COFDBplaW5KuRTzqCSUllyAeqTT6JBHL28JCFkKFKWgzCwIC+pglSZlyXEdyq1koc33Ux687kCXEgLR+PAjIKLpEu6q91j9Ar3tbYe2p88MeM6wUfWmEAmgCQjnYLy3BqCI4jGsFhbqla2rWFSivm0LHYUnPEeEvfE48dxau+ZePeG+ELwRiS95UqSwL3auCRAeqthMriP/7uNBZpo/TyAbT+4zlI6RFdxLyWZ+RgFCp+ZV8MKSdEh6uJCaoPR3ipdRAGpgKMReXU+tO+dYVfYUa+S66xd0zSBmilLsDF6WIFBk5BFeWvinpBl3aMo37LIWvFo/g7hb0dzrlNvgBdINkhoXdMCcGY2A7rA06vDlIcxZTtDRymmMHS7NXbAdL9gy0NL+4TVhAqUdfzWcbPiaxFMp/y3xC4UT7IpRu6wx8BzrA8Sig60YvTGhe4nFt7RXMkxNBxQMr7b+mqHXX3xoDQ0Y4jR8DkiGcHd5Knf71WT69KHD2cdzoyJHA8xiyiHWeDRd1z5iACbVj6hYfvLygZ0w5Pk232huB+npZMXehkHRecb5P3hmfn+6Pe2VuIm2wsyNleLVvsQNW4VJaAdMVOK3mpzCHGdaUdw0yXKuxmtoJXth08FyIPPqp1qxACOMRBX6/y3MokkGKb/Z2337c8QBA95b58ZIQlN4kk9KmAd945BUc3OUy62O/33lUc1IObjtz1EuG0pRZXbRHJcXIbX+gLr2Mgr24QcUS6XgEjIYOxf7gdtF2rxt2jO4Ea23YoBBuLvJrNzu/FZaRJ5MxJfN/U6fmX5aLxwJ23Jh6j7alzz891EGVIje+W7Zw0yG9nzFZQdHuzu4KYn+dD+9AFCI40V7t1kKUGmAGPWo3GrDAUv+8Ci91i+xhWD1okdvjVteD53VulUSq6cVZAT1uCpZqyMwXHHsJESt
 J1I9IDLN
 NKTrp7VF2n6qfwUc9zku6bGQweDQboNV63y4uSr9U4HDvjNkYXyq/3ZSZncGL1JRF+CaYfxNnJSmG9yqsPf1B4Xgz1hiriOj2TONhSOSNQjvnFJFJe6+3HlmNb9DCXuM9D72lKivSjzTngwC3/ySM3K4Di4lzSt2VmTJURwurYVzCXKwNKEA3rPZM1MosHWUcWTdRsgCyBecepotB57GXoAoXxYRI1eporXkJaV3VELKTi+dZs5zCea9Ra7fpHwkEaayW2rv17J7Hnhzh61zBqBVrDy2D2rWqea3/mLNhOTQqzXdx1p15jAb2CpeTAn0JVLXFJ+KxhWQ5iqUpExPqBa9/W8OLsy//lysc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

page_is_unmovable() regards a page with a reference count of zero as free
or about to be freed. Since slab allocates frozen pages, they will
be wrongly considered to be freed if order 0 (higher-order compound
pages are caught earlier).

If such slabs are the only unmovable pages of a memory block, memory
offlining now isolates the block, this can lead to offline_pages()
looping without progress.

Thus detect the slab pages as removable to return -EBUSY, as would
happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").

Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memory_hotplug.c | 7 +++++++
 mm/page_isolation.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee2..e773a7d54165 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1847,6 +1847,13 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
+		/*
+		 * A page that was allocated, but was not a slab page yet, when
+		 * its pageblock was isolated.
+		 */
+		if (PageSlab(page))
+			return -EBUSY;
+
 		folio = page_folio(page);
 		if (!folio_test_hugetlb(folio))
 			continue;
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..f4f0571607ab 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -74,6 +74,13 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 		return false;
 	}
 
+	/*
+	 * Slab pages are frozen: do not take their reference count of zero
+	 * for that of a free page.
+	 */
+	if (PageSlab(page))
+		return true;
+
 	/*
 	 * We can't use page_count without pin a page
 	 * because another CPU can free compound page.

-- 
2.56.0


