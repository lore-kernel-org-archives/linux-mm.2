Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7AFC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234386B00A1; Mon, 21 Sep 2026 16:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BCC26B00A2; Mon, 21 Sep 2026 16:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC176B00A4; Mon, 21 Sep 2026 16:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBB476B00A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:00:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7977A402B7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:06 +0000 (UTC)
X-FDA: 85238835612.12.FFA08C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0677A0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:00:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSjBem8+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020804;
	b=4kF4mdWq40wANEgds5PzvMKPRz5CHfOS7XRwTd+cA7XfC1Ic9lIjpQcSwrT9tEeqZYHBBQ
	t9bLmFJIMv9iLAW+i/2PGumVuDsex5Ow7bOISCULSEh/k9+T5mWZdVyj9EhziqDxC59bEQ
	KmGgD+Fp3BgA1VQ8GAh96gRF8Oyccfs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSjBem8+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pji+QYSqpVzdYzmgiKoCCOu4eSAGWJQKP9RUR89ehLg=;
	b=4JA4wRlKySlIXhGpkneuUC86uVG3FGyd/IwK07lwJHyfXcbImga/Q1RaighZ4S5weNiMsz
	VhDOVnrcQBvvPBlTHb6fnVvmeQy9aNYPLbOkQSQA5Sw4vnH+kAckqZj+aTnpne4jQ7CCak
	I100jvRO2truhw/HxGsmoCV0mmJqUxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 733DE601F1;
	Mon, 21 Sep 2026 20:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB861F000FF;
	Mon, 21 Sep 2026 19:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020803;
	bh=Pji+QYSqpVzdYzmgiKoCCOu4eSAGWJQKP9RUR89ehLg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OSjBem8+kNwkxg3Bvo4XRxOymzwX9733IZOf4gdzSAwBDvnhPjONwtPsLSXraRCNR
	 0s7PpCuNdOSpuu87AcmpoVy4Qg4EhLWp2bKMEJ9QfMc6HeSyalwdDiDde/3j3MjeTg
	 a7MNs4pRqI4KcPwlb2nSPiH5E9MYyONCxFqDji24j9e01IDiUdnLuNo0RpNLthmZ16
	 zdnK+h0A0qn09aC/3UZ+HqXs1lUWNhK4cAiumIMY9DtycZzY8kWpCbL9fsWtg6riRm
	 OT1KR9Mey2IKNe797hS1q+l7MxJ8fVSIgmtrnLdkShDkQNQYRo9hGUjL31NOnB45dN
	 Awqg81sHr5UHg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:57 +0200
Subject: [PATCH v2 05/13] mm/sparse: cleanup sparse_init_one_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-5-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; i=david@kernel.org;
 h=from:subject:message-id; bh=4Bu7wqp5LPQ6WPOQiawfPpDIShUPnK46ZronN3GEgM8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rTesbSdd69Fy4mRefHe5Y16LOYVYoUWf8UFVrAoh
 i2efY+po5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgInM1WD4Kzb5q0i+l4H29A9t
 KSKqG4/5OZccfn/yRuPDKbnKpbfFHjP8M77advOK4RTJGoPddqZNl/Py5gUw+8zYVyA4x/P6tI/
 RPAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0677A0006
X-Stat-Signature: y6c4u3gxfbbhhw7tzqdc9zah91ydemdf
X-HE-Tag: 1790020804-572716
X-HE-Meta: U2FsdGVkX19ALb4KzXXGGFPXAOSMbck7qkHUmqQ9JvC4KcNaoJcV6Hgwt0JtoiihCM7TRTQFAitl+CSWTGDd5Lquh4B9BvdZ9zwFoth0Uf1Igp821P5V7mzohjjgAaSKrPV+8DKf1333GCrYwYsfb+CF8go3NfWtKJVWWlrKtC9nD6Conx/41v7QiA3O3pM3TFdmfwhtgf0PKt9yFo8BpqxZP5k8oX3J5fPLbrfWhlb0N4g07Zj3tS4gRBnx2beJzmHoRYBhBuk9zH2q2MQz4kGYUkAtA6KxsaHZg7FUcPmxDODOwKnca/tsT/Z17ZoghN4HapxLCK45aKrAQG6iRMfXiZk5tzpOOlZqx2Fn7VIRUSXHeJvP5kkpJhs/pENh/HeL+saV1krlbhDXK1rjnpvnYVoov0D/c/9BAvR1bhS4fEvMZ81sUb16xdGmM59FSrohHVQwJ/kcvyeZTqqzONzyJg5sk0L5m3WA4mHiOhTioq1vaSzAZDBSWlzVJ/G1sahitconBaE0Q5MYW6TPPS/RdlsccrOn1Ges2O55ek4L8jkgX8vYdIV7Fk44wKsZcsf+370v59NNDcmzi39sxZEDqkJI+0kmLU9IpjICRsXcTrn/gxNt+g5py+YP+uwFkJmdbkMLyJPmw0tLDhmzLUeVl246lPwjIL3gE+c8pSIn4ssWCc606aIvO9CTmGKODwL3gIS/K/raJWJBlbvtbSIlgcXzlQZRp2nx9jaNj47VdJ1W8AfIv3nqH9Ow3G6IKP/8Oa42wu3Hcm8AFzyYaqhEWXuNJ+XoCoCfmY/R++qAxT4YMP5uMJmg5n3Xll0xtJ+KZ8CiyqXI7Ma0rGM7DB0Uzz0IjUlDwxVAhuJyjEfZNqRYE/p3DRggTVrQdhP2zqv/N337vMPwrwFcQ4VKlh/h0i59Y1wkcoRv+3uzwCgr4pO7CRnJ19TToUQXMmPKlefyu5wxbv2Kc5w35LP
 rj0mC4R2
 0BZo1lEHM4Fx8/VswGIVxE12i9CQNTGOQRqeaKGaUp7u5giiUY4+cheK6X5Gk/ymJpvKPWilYZAJ5iGnJASF6IAWaw62sgWyXQIDADMm/feU8SftR31iuG7RvCrbdDJc91XZ+XchY52Lwy5TunDUKr2HVGjJVIyEddPEcZwrhWZsFyCUqcDNuqgHnhj+tgJMMzn/1mDiq8xeRjA8GXJ8PhBgIkP4AlfUfh4Au7Z/bUJlKzpiXC0GQIJl28WABcpZ0qGwSUpnokwdk4X+iJu46zdEvDkQYM1IHL4So
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's avoid the "pnum" terminology.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/sparse.h b/mm/sparse.h
index 530692cdd516f..4ee507c34b98d 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -20,7 +20,7 @@ void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
+		unsigned long section_nr, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
 {
 	unsigned long coded_mem_map;
@@ -32,7 +32,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
 	 * from the page pointer to obtain the PFN.
 	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(section_nr));
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;

-- 
2.43.0


