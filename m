Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF34D232FA
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD286B0089; Fri,  9 Jan 2026 03:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BD66B008A; Fri,  9 Jan 2026 03:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D3A6B008C; Fri,  9 Jan 2026 03:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08C3B6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:56:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 853BA160401
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:56:42 +0000 (UTC)
X-FDA: 84311819844.27.ED43228
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6096414000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:56:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m1rFp5i2;
	spf=pass (imf23.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767949000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQSfkkT3zFxA9Ln+sH4efezHgdt3LLDG68nqdH91hYs=;
	b=YcC5sHnO4IbpQn3mbWVnA3AJ8le8wRwFaEeT7a4sR+WKZtICoA1rQrl5nqRTkK6YVhaBFc
	ty9grSeFi4q8kQ2ttmoaLfB/GNqDAOz37y65MQQtKCdryZ11rTjvw44z+HCzbMuju/0vfl
	5cLoX+f0bteN5s/afOWqD6i0MbwwR7M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m1rFp5i2;
	spf=pass (imf23.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767949000; a=rsa-sha256;
	cv=none;
	b=fgEF2OHo3S5BiweQ/i9NEparnoxUEZkAlOuu/dNMs450rfZTEgT/iGqFPM+qTrD/pMG/pj
	zcAc2pM89RIN5wqYqrZN3kxZYOWG0xODuA3KcJsEHbB0hgoK1wWHemrbCr2SDMcKTeKHlC
	FhocSYW4Lx8EymxlfAQpWa93xOUQg98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767949000; x=1799485000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+bY4ZztaByWJWs4ekFGdX8CVHginuxJnHVOLvFyJ01s=;
  b=m1rFp5i2XAwddA1gy4CPFuGoS8+nyL0L/3WlkMAjxgt2EAZL+WO0QsyH
   ZOLJsow3zn0Hp0wm1LjTaoJoYMflr9H7D99hH5ySBR0rcyt8pPFu6xFHU
   sAyQJGSc7l2c8FwhLWbia2OyVRSQ5mhcbQAhmnrIDczsi3nk7BDOQi2zM
   uORkQoanzvzfuvqeFk3TMnZkvMLd6xPu9STEoGEahLUq/NU8ao1WquN//
   TOLcHgrp0U4tmLeCOKWC5TQOJSa1V9tNTtWfnu1NPOnUoCKq/L38GSOG+
   lyr1/10SVhz4N+JY4phA+9NnzV3gxwf67SMS78qraUhOb2CExxHO7WIlX
   A==;
X-CSE-ConnectionGUID: tNz5Hko7QlieEuVO13GD+w==
X-CSE-MsgGUID: lq1MPAW1RMy3ycB96glWqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="79625996"
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="79625996"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:40 -0800
X-CSE-ConnectionGUID: TtOuG+osTcigg4WByXtJdg==
X-CSE-MsgGUID: TjMjEjtYQduqVaWBqtq6vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,212,1763452800"; 
   d="scan'208";a="202538619"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.83])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 00:56:38 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v3 3/7] mm: Split device-private and coherent folios before freeing
Date: Fri,  9 Jan 2026 09:54:23 +0100
Message-ID: <20260109085605.443316-4-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260109085605.443316-1-francois.dugast@intel.com>
References: <20260109085605.443316-1-francois.dugast@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6096414000B
X-Stat-Signature: o9senbzbya3cxa1zzrhbo9t7x9qz5ch4
X-HE-Tag: 1767949000-844868
X-HE-Meta: U2FsdGVkX1/5DjLa0vyHkL3nFKtafhGItnTxn75D3F9/kITMWHwImL2fLX+1044E1vkBBO6PM67DZwLNFyYbnLCV1evCaPMgGa9JNkMje2KHw7k5w5kMYB1JZcoPTyQXJtyJdDZHIhnaVYM5UZb49GgC4W3AjKi++5v05J/PzKUwOmzPTjbJBBs7yQOphDH35FVAsLTcTNjck/UGqMOmsV+bZe5Q3gawUVdTlF8sI4Mg0UC3CITiSS3XIQJinQVz6D2qzkx6R1rYzv2DMGqoPkpGDSymhH5bD7yHRgM4KV0cmPIzmfqSwwBoNR1HY2y9NQGq7im9OzeMlisp7/M/fzsU4m7NKeLx1FG0B8iAugUCIieRVrahII00N3rhqoq4KDVOSlA9Z3lCcOHJ7qsOcLFBKm70NpEiFMa0UIDtmvdgD7VGrUsy1xwW7JEpsyKTLlquCwCTvYBoTSJwYHh+fobVtbollLtFdc2QGPCkoaBhEGS2ivn7IjDq2e/aTomQx8WNu829dIczxIlq3CoQnO5TJaw0/WDUIC+qPsgWrrs/uNNLesOF6rah9IyEVlb5ifqsKTc4iwdv5vsvRUMYHJeCJIbF9fBth93mBXieJrxOOozCA1ZhaB0uvK3OoCDyE5Ex41vVLxU0F0HL2butqFEHD5daUsbTWUhd41s86mvXH4nC2gSvXmcivoWFcy05Ma4/OEby3jpyRApwRJwM5D5zkJ7J1pcIn3YBhidhjIumQhBcY741lOuzspGM1JXxzyDSzYOJjGiUxymyHA2SIfKJLj3teOuROL26BT80viFtUzPpEzd6pN5OZIbY71l6rmQgT63rxgupo3cER4Ll00fvrAigJIWS3O7NNfoM+dho6tLx+4XyxlPJzMveooukTpcNzTO7YH6zwCwHKb+WZx2DkJsCcCsySWeuCU1vqpCGox6i2+km0/dLDf0jsmap4dLQPzl0jzdxs9Xq2Lg
 370nhx+T
 vzmuA/MSpivIfFjHHIOGVpAubR/uE7fYZ8EvOSmm0OtR9d1pmK8ZUqexA8/3ZcyVeTFKNZqp7eW0j5D8RrbIo4alw9nlWRej1JchfbWTxwVpH7o2j5oO4K+P43uSnsnODojPvRew4S/au6icZtsOmbUPkNkXhu9QJkx5FpgPOfkI2pAoBTyS+FZjewPUvW0afOYgXzTxKMmEUxFN969bVwkN7Y6+aM+UVPkChpFcnHQ+jXfg2VTI8aEejOXG3sxuH3+zzGL9haSGl+oX2D0o78Qm83NCAjWgo/N/+xJH5ACrS1sqQAHWxoXFIXltJQd8t40zkuVrZiV2/2HPnOEMXMYJNaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Split device-private and coherent folios into individual pages before
freeing so that any order folio can be formed upon the next use of the
pages.

Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 mm/memremap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index 63c6ab4fdf08..7289cdd6862f 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -453,6 +453,8 @@ void free_zone_device_folio(struct folio *folio)
 	case MEMORY_DEVICE_COHERENT:
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
+
+		folio_split_unref(folio);
 		pgmap->ops->folio_free(folio);
 		percpu_ref_put_many(&folio->pgmap->ref, nr);
 		break;
-- 
2.43.0


