Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6694D3940D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 10:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD336B0088; Thu,  2 Apr 2026 06:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A756B0089; Thu,  2 Apr 2026 06:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2196B008A; Thu,  2 Apr 2026 06:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1E5A6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:23:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F8A813B4E8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:23:48 +0000 (UTC)
X-FDA: 84613229736.15.8F19BC7
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6582C000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:23:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DGzIUMpL;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775125426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=grFJ78WqgRZrgeWWNHnn4Jx3/rkbuOWgiFKj5zXSxpU=;
	b=aRKnKGie41uqJE2G4K64DNy431OfSp1NyPg2/wPStYvmMYcxFwNceu+vsOxNtv01OHR59X
	OCY3vYDRAFc5bfiN0Gf4l5ULWCXSB4UQu/CvXhzn7kFy2SkHjSwWqz7ssNNQov3zOEvatT
	NuT3I5MEqK+6/IhvaqgIHN5rpR10YyI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DGzIUMpL;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775125426; a=rsa-sha256;
	cv=none;
	b=Qju1eE3Dn6b31u1Lg5y+QE2Gpe59UD1E+0pS+K9yWkY2iz3LgEKZcZivDg1TvLk6QXNfsb
	9AM0/fMqZ4epxg4yDai+vbz2tZWefn8Ddi+B+GveIUfABHESkcdrEh6S6twICLjn3c62pG
	Jo7r8kqahqayg63+zCHmDs0deoQNxd4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad9a9be502so4570775ad.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 03:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775125424; x=1775730224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=grFJ78WqgRZrgeWWNHnn4Jx3/rkbuOWgiFKj5zXSxpU=;
        b=DGzIUMpL45A6sLRQ4JT7T3i4iYTbIRFKp4NGaQ+iO9DXBsqGr4jvPLKOqJHB5rO8J3
         ExOZTndOsiyku1R8iy+g5HZnyKWVxbHzXF532onFuEhcvtEbH62XZVY7/Flx1YzN0aSi
         1z6kJ2VtsbP7tAfHiyk87Wmhkzd0vLD1Tx+e02jL5HkVQQ/6nI76g31w9+razoYU0Sqt
         omQPX4EYXEjX3L8HetdAa55glyjyeelkkho249uqO64cFaVSOQ9PwDAKVp7g5UDUp2mw
         KV8lRMXCn3MEGM9pcByaTvNASFoWwHtbUd63FqgFSLxYj37bjD7dl5EoO6Q/mtiV5+Yh
         M/VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775125424; x=1775730224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grFJ78WqgRZrgeWWNHnn4Jx3/rkbuOWgiFKj5zXSxpU=;
        b=VmF4Qxw86Uzn4RwKnTjC8selWMHf7+OVTC3IhqOUFRhUexqXTSghYytzGWqCO0tzxU
         yKrzvsayZ1+E/HTHGzhHLOvwaer1Hc/2NwlDtU0gLucWDVTZ54SHoOXIuRJPj+ri8bZB
         ASMef3g82goYWaNIyLRNk5kU9TcmltPG2nI9wbPiPXsiDVXtjgAK5crMynw4A9XcSwDp
         7mUcukcLsQb7HePCebCENk035J9JkR4zfEBw6NddAlYLvJ7frOFAKbRSlNRCEYUxSQ7r
         vqX/Dt8v7jBVA6GHzGUGEIYef1taDqqYWLI2/bll4Sy35tjFMxRbVHTX9lkiPGETkUoN
         8lrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0D5a6Nc6NyUcchkR5tiKk+ArNqcS582GO0HRLjAC/ae51gVaa0LmbSaT8X0aA9FuHDY/Jmh+uxA==@kvack.org
X-Gm-Message-State: AOJu0Yw+qRA8DFY4TH5BJdajNQ2bIF87qYpXb8sKWxHR2TqfxQ8YmnKz
	T4oLKfWwdgP/yJXErv+AlZH9uyg60PkctPmH/BT/Q0q9032rQwGfwqfiyhS00i6adOI=
X-Gm-Gg: AeBDietkZ7shaqrx32Ja+0MXPNMAw9/waGdYgRV/DBsBFPzyDMlMrBzpy4H/BgBLeqk
	r+IrPyciqU8VHeCvxx3/tQF1gpc4ggZfAJjzKuC30OlyLcVNfTtLXI38hTdU5breme1YttoF9YH
	ad45V+FItppZ5OhernY/ho24NwPqe8pkpi1bEDswbPTCl5ZVrneKEvELvGz4E3XQw745YueXLYD
	ZfH8BFcLV7gctBGkYh/P6eNCJVcefVd+7zREYAI5i8EOZEESzY8m+0gzngFPzwtwijqIBrWZFJI
	rc3fvECV2KdDa+OTzbv7027t4uZJj0d5XMSIN4BphEJTVnn4XMKUc/Y+ufsys9WTsl0Bf3NgPj9
	TKq9q98RkOYQ0uJFqJorZ61Hhbc3MjelibDIKOWx2OoasgB0ER4BXQvy+fClfsvjAfNFrPtpE4Q
	r3f/gAOTCcE5svYYnWkw==
X-Received: by 2002:a17:902:ce05:b0:2b2:5428:ead8 with SMTP id d9443c01a7336-2b2699880a8mr71112325ad.0.1775125424197;
        Thu, 02 Apr 2026 03:23:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::348])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a475fsm23018775ad.61.2026.04.02.03.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 03:23:43 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Petr Tesarik <ptesarik@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] mm/sparse: fix comment for section map alignment
Date: Thu,  2 Apr 2026 18:23:20 +0800
Message-Id: <20260402102320.3617578-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6582C000F
X-Stat-Signature: c3m4xxa51m1cmb16tyy1a3uakmq4tu1c
X-Rspam-User: 
X-HE-Tag: 1775125425-611170
X-HE-Meta: U2FsdGVkX19Gm9mKJSvlymIOdIjsKP5rJ399yLDzR8TKCo2nLtvOCnm3xWKBQb1okcTF1xHAP0SHGvzWX3ZNIg72RThQhxtI1vXQ2He4mMXW9aC10EKHJPdjOr2UihfufgRrkhV5wD0z3vaXEXNu5EQWHHbng+U69qWAG54r+iy5lrMCiqGRbekjkMGv3F2on9hQ4S16ahLynJYvnsvF0CDUA6M3xCODeoe4qzWlnu/r0cO2vYL5H1sWRb2qkifVTU4hL/LRRwXvRMocoASJl/MXB/54RC7PrFEjKAOVcgmzg42+ZNs9sdIDnkmCopZngl1+RRZ4P7s7vuuSop5LOCsvTZQsrd7bUFnCUH66SGLGHKWvx1MohDOXszTGT7KohNOgNnvBphmXVj6yk1Rqmcu97enlnG8IjhDTPTerO/9RmUerHOBaPsWQGbfTnbeCRsQ9uLp9DIbMpEc2cLH6o/dou6LJ24oWGUz4tcJE7FJVyokznb4vRVFdGPmOI/IQikSPmygID9j8E52dqJP0woqf/EvZ1moDxgyM9fuNbhaqQ8TqDEx7y5uiINkAg7A1wQcf05NRHXd0hYnTB1tfkb/wxb1jLwuPd6roaystHQv2e0K1nStbUFDD8uT93QO/B1ZigFsPnoJI0p9yZS3GQbwAraOLPq/SEt1ZABNQQzK/C2C2/e68FzJq4L06Tzp4TwH9f5IZY7wBqid/pylwcmWOsYc5/KJfcFUaXFNQumJm9IflQ9riTymnlohxl/fanB4Ebzzr4WInoYF2PNm+qV1p8geno0yOCjZobQsEx6f4ogfvOM9aYgUKGnmSsblKpMTYqEd+9DIR8CJ2LDfS2S1MFumH8OMFyke8RjYgKnhHZH7iXyhuNWQLNBzrekYkx5ZfzNeTqFGmNkgqO4LJL8V1g3L8i6OBuN4S+0K18ft0RhAvE9ZhTLRo87du+fcBSPNIVLXld5Rao/bx/v2
 woKvyzr1
 4vIkjDIsXYllZvvACGOeEJQ8RmKKsoDGt3FZqPnjDvZOgwJHMY5zj3X23fhEFeZjfp26Qv5JKUoRBKIgegjx7WgLSrgBFrCdVrowYaPpdbwU8yu+PR9Vu25L8eavMcpvQvajPTJBkvciczaQDrhw1PpH85ojQNBpXdfg8noynZKJmQ9qY/SmaXnD2vDAAH3HdoXnNUXfJVulYarzK90JOHkyQZHyHLRYMN1ExVjKl3YxeuaPgIia4yTcJrhRZQxja/RayAtzYzcMWFsbNIDe2aoMYMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in mmzone.h currently details exhaustive per-architecture
bit-width lists and explains alignment using min(PAGE_SHIFT,
PFN_SECTION_SHIFT). Such details risk falling out of date over time
and may inadvertently be left un-updated.

We always expect a single section to cover full pages. Therefore,
we can safely assume that PFN_SECTION_SHIFT is large enough to
accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.

Update the comment to accurately reflect this consensus, making it
clear that we rely on a single section covering full pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v1 -> v2:
 - Drop the actual BUILD_BUG_ON logic modification (keeping the simple
   comparison) and only simplify/clarify the mmzone.h comment.
 - Add explanation explicitly noting that a single section is always
   expected to cover full pages, per discussions with David Hildenbrand
   and Andrew Morton.
---
 include/linux/mmzone.h | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7de42be81d4b..a071f1a0e242 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2056,21 +2056,16 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 extern size_t mem_section_usage_size(void);
 
 /*
- * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  The pointer is calculated
- * as mem_map - section_nr_to_pfn(pnum).  The result is
- * aligned to the minimum alignment of the two values:
- *   1. All mem_map arrays are page-aligned.
- *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
- *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
- *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
- *      worst combination is powerpc with 256k pages,
- *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available on all architectures.
- * However, we can exceed 6 bits on some other architectures except
- * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
- * with the worst case of 64K pages on arm64) if we make sure the
- * exceeded bit is not applicable to powerpc.
+ * We use the lower bits of the mem_map pointer to store a little bit of
+ * information. The pointer is calculated as mem_map - section_nr_to_pfn().
+ * The result is aligned to the minimum alignment of the two values:
+ *
+ * 1. All mem_map arrays are page-aligned.
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits.
+ *
+ * We always expect a single section to cover full pages. Therefore,
+ * we can safely assume that PFN_SECTION_SHIFT is large enough to
+ * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
-- 
2.20.1


