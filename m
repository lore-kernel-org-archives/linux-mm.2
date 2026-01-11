Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B19D25031
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AEB6B008C; Sun, 11 Jan 2026 15:59:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638886B0092; Sun, 11 Jan 2026 15:59:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B196B0093; Sun, 11 Jan 2026 15:59:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 422EA6B008C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F14B65E9E5
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:22 +0000 (UTC)
X-FDA: 84320898564.24.32A0B9F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9D32140005
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b7BeWLen;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e49biPR5DL88d1BAIDv+Azu1eJLNzr3U2rtaxVgp/pw=;
	b=wtbMzvVjSs7TC0HiGbBqleso7P/ZfWjekd0o+MZsvd3sy6+TKFcSYYOGQwsc50mkd91M59
	bjy31p5UlUlzbzCgn3w8VwLCnzloWmOR6g6FlDOOAK4OQEbmwr+qcelVDPiNlPzwl7IGRA
	nZtZmk2EolMQIRi3HQguglfDVw/RDKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b7BeWLen;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165161; a=rsa-sha256;
	cv=none;
	b=1sNhz99qIFs9zQkqq9ZfsxGF75ITIKAxsDdIcTVBf49uK4LUzoku3vO85R7N9drKz3vBC/
	pp+Yoa9T071zh0ejif+Y/VmzLhYjBENHMme8WOTPthl1yjq3uqSM6Exja8ChYB2+a+XVL8
	QWUIhWBJPwubSV1dMFwJBNhX7Qsusl8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165161; x=1799701161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x0o46IltvZIziPvuDUlJFM12hoQwAZmCbZJupxvwuok=;
  b=b7BeWLenzY6xP2gNh8Xx2lDkh3NUJyo7z9OfkgUU0eW7297nJwhgwwdx
   RsK+abogvCGJVHzHS7huEMhdnaOgZ/f2t+2GdqDtSBl9jyvT7VBZLMRcX
   9rbniTfnEadFbQRG9jghH6UQ8frgfFMQLs2xKvEUJ6Gh0ZMgHDVmebyL9
   /S+NQawnPS4PLTK6vxjnRxflipk4kliQzIYu56iXuxnTpw5zrP0IiQffC
   3qSRsrwagR3j90U7nwup7I1AtktL9btQ+LL8jy3PVdVglcDp0naHx5X5Y
   o3RBSPcyTFWey1Z3kdMmcQuuGxYWwnzNQDnjcf0subrklsra3Ie2WL2NZ
   w==;
X-CSE-ConnectionGUID: IXlAp6utSg2Tc+iJt+A5ZA==
X-CSE-MsgGUID: AMxqxo7QQDytw2cmUezmjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904704"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904704"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:21 -0800
X-CSE-ConnectionGUID: UlIOxdrHSwKszggz7EuscQ==
X-CSE-MsgGUID: /wOnx8gTQ2iwNjeNht87pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208419980"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:15 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v4 3/7] fs/dax: Use free_zone_device_folio_prepare() helper
Date: Sun, 11 Jan 2026 21:55:42 +0100
Message-ID: <20260111205820.830410-4-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260111205820.830410-1-francois.dugast@intel.com>
References: <20260111205820.830410-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3suskgc1moy7oto5x1bsa338crcyp6a
X-Rspamd-Queue-Id: C9D32140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165160-192076
X-HE-Meta: U2FsdGVkX18wFeOfY2ly97jb7I2u0TA52y6po/e+lUHxUqCoVii8ek1LGneOM4G1JbBxLKrb8kl4SwjFnqqAdwNWIgGbj/hhPRr5nk3fRKj+gIbL7a+J4Saqpu7AQ6ycdx7MALzXYAkpKpwlKQOwgNGwGOw4DV787MQhIeQS9H169npVdZXSUWo4/VPVEsomr9kBpZ+cQgFOx5Dr2R9/iTa+xvXGu5UfEjLX96Zm6F5mNN54NreqfOzDF3SzBB///6XHU2zjh10U6h4hAjkypY9jYLY6Jxk0uDp85Y9ZzpmIDUu6vSjty+wHaHeYTznz7bBxRvGwbky+TJWMW/ynPF8ekQM+OfOm57HkXaBizppnAVh0CnqHD6Kaw0iKKOqPRis6az3hX10FIL4zTOpBoskTuQwutcWuA0ee/joYmlXa2CTP+SSOujIf7HQstbVbEsErS8Kl3KBPQAKyqdmX9ir4cwbDKsqM943+IdA+4CcB3rdS2NIdqh2l5vcYs9K5bSs5OEssSv9IpmtuR34Y+3C2E232XkVtm0NKqgeiwVnUkRIGKppZ+y0Tgy6tCLoQMa8RKft8QZzoHhyH1F/Qmcd68DJaiW/DBb/cYr4jyjz5IIZF5oLDXZWlIEN78LCENmQ/6dc/NG4BGCiZ9l7PAfzTVDKA1dDK30rPo/hrj/w/MWRyXnYUJrocgg5FoBcYXUyKPfYcbNR2CmbX9xC1qXgi8VOecH8GFHYnEfMZUm8BzmgMWVfhTcwNWR4nKvmEXpZpx1blurWVZn9MuJ9QMyIZSzDXFi3pOKT8dkYtT6i5bYnm6l2DsqkyIzHh2X4B8pmRCgzrM9OyB6rGtECAOcTst3/SMHpuA8QmoNEZzv/KWUH+30Uf9tr+bguJ3yHXH/fjouliS0aEiAGGiixhFj/lX4mr/xAQsNY863J4YHX17fNhBSTaxCWO+QwdYx9K3GPsepjzRp9lopfMZSI
 noBPfjpw
 DzI3Aao2CwT8v7qlDPPn7A0D4i7jlyn0ofDdU/xKY2NNU87h5KOwsaDIcSkPGjfod5hcFbZv6T9MIMLxZx+j5yuyc4dLVm36HuHD2q3Hi+6HMuBR1Kfq7wtcXVOs7VWpNIbvNmQgj6JOEy2KWRlab297FvcOwXRSUOUgg5DE+Jt7RgFvB9wB7dBSdWP4P2umCFInXljlUGPJsl6Ih8VCct6EurpzxRBS8G8l+r+uvbOb4w62FHEQTi8V032ZgRvC9oZYBvBjLC+1mAtARw/QWsuli9tyS/564q3AQXPfJka23S+Y42Lm6i/Cb+VLnPC1HhlD9MCgeZQdDh2ELSusdPdpnls4zKnqVSt7L48FS7Sb2r9unEAs9sNK7ltXzsNIhmiP35Oe8BkDOLZBLCXbriy/B1HR5yIBGdTU4Hr2EAj8WJcpTN7yiR6fq6cxnhGT+3Txc680turMGUR2NVlfcJY9i62U5kOqlMLO7y5V6PlrwGXvvb4AjiAiL69m5yGq9n66YzbLMtTt9kionY7Xz628p0W/lcrAGpUY+Ij72Hh+9mqLBvcSaYWNFfhZ4LGc/ifpmELFM38kcO4RE7sRT4pgeOlk8NE6Fpj9v4+GH760c3Ys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Use free_zone_device_folio_prepare() to restore fsdax ZONE_DEVICE folios
to a sane initial state upon the final put.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 fs/dax.c | 24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 289e6254aa30..d998f7615abb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -391,29 +391,7 @@ static inline unsigned long dax_folio_put(struct folio *folio)
 	if (ref)
 		return ref;
 
-	folio->mapping = NULL;
-	order = folio_order(folio);
-	if (!order)
-		return 0;
-	folio_reset_order(folio);
-
-	for (i = 0; i < (1UL << order); i++) {
-		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
-		struct page *page = folio_page(folio, i);
-		struct folio *new_folio = (struct folio *)page;
-
-		ClearPageHead(page);
-		clear_compound_head(page);
-
-		new_folio->mapping = NULL;
-		/*
-		 * Reset pgmap which was over-written by
-		 * prep_compound_page().
-		 */
-		new_folio->pgmap = pgmap;
-		new_folio->share = 0;
-		WARN_ON_ONCE(folio_ref_count(new_folio));
-	}
+	free_zone_device_folio_prepare(folio);
 
 	return ref;
 }
-- 
2.43.0


