Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0AFC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73776B00A6; Sat,  9 Aug 2025 09:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF796B00A7; Sat,  9 Aug 2025 09:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DC46B00A8; Sat,  9 Aug 2025 09:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 910C16B00A6
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62DC8B738D
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:24 +0000 (UTC)
X-FDA: 83757358608.22.55C3F39
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F36340005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ml1Yd8Cs;
	spf=none (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmZF+PGGpQ7BonPjN535BzGIL3gxAEu1Lf4M3+fywrM=;
	b=6TDkcM0HM+SY8x6T7K8xrjHIl+ApSRy1C4EnrfRm7rO8a/6rSbxzrz2Z91kmroNxtpV82L
	h+Yc1Ilj6z16Dq9umMk9zNvEeQVvvHVOhaY1gye6+rJftexMlSpYyGAxYqPYQau+4e0Y3U
	+gEnV2qR0+W+sR1E0nvaWISlPvTOvhE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ml1Yd8Cs;
	spf=none (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747542; a=rsa-sha256;
	cv=none;
	b=R0vhu5eIC9Y1gMoDkHlvmvHfcoWvPXl8BqnGZaTu+gXXd+2eHCAl9wGXLRhADi/mCNPfMT
	lew8ZDjm9YPILb1cYhCGj9WvfpXV5BH+LYi+vs5nrR75dOtkS1cC9T5a9bEuMHqswFQ5Na
	0YGfVmE32Q6snybRB0ClrQ9cxJQ8m0w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747542; x=1786283542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iX+aI4EV6aIpB48ENfwpl4TWhZJPqVgs0W+CzzXlU1w=;
  b=ml1Yd8CsoL6ddhQKdUm1kRrqIix+RdZaSN3hR8KOFUVDTTOwwizYYSsg
   Hyi6qWsIW4Id1xB6BEI2qI3Bu5g1D5CwlC85iyhEIeeLoDHZvqFOMK9t0
   aR7N5rjX4r5LRJ0tb+UEuw35cZ0FHdHsK8mnJOAT0+wCKMrgG0s6bkdkx
   E+UxpQR18KZ6jtddkvUvv2jiR3ju0tenhfZ52+FpYTtcPG/Uf3PciV39G
   pPh6jxEIBt9UGCsXB5HuM7QBEKI9N1EQ6ukoInLZWm9M5ls0co2cWzedW
   s8He+S7hR+M8XEC6UpLVWB6MW1mSiXRakywc4neqi9EFwGyrM4ZO0pxG2
   g==;
X-CSE-ConnectionGUID: BOOkqwJ9QhaKZvcErAy1jQ==
X-CSE-MsgGUID: jvZLYHp4TGOwbMVqbcIfzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153568"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153568"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:21 -0700
X-CSE-ConnectionGUID: gVHvHxq3SzW2byWIN5LLcw==
X-CSE-MsgGUID: 7NQBfY0hQGygQt3TnI1X/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903763"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:19 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/6] drm/xe: Skip waiting on unarmed fences in xe_gt_tlb_invalidation_fence_wait
Date: Sat,  9 Aug 2025 15:51:35 +0200
Message-ID: <20250809135137.259427-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F36340005
X-Rspamd-Server: rspam06
X-Stat-Signature: j9xxkof3k4f7iytn9ruc4qioft3g6uf7
X-HE-Tag: 1754747542-951018
X-HE-Meta: U2FsdGVkX1/TZ4YTEk7FTorS7UvXi/LopWfn/6IegzZyfky0lqBUu2cKaECpg+BcY8q99hOTFJ0HMt6gwugVT/b+8p+hm4C1pgIYSTTW/4U6FUUlb8vgqFiQhtloJWe4qYfuoA/by/ZCySY76q6xpYLIyLGSrEraUAFVRbgZCj/Ckc+o5MZjTEBh1Ve5DJoQxCOeCBgJhVgHBDojzzHoVexeU0Ag5x83ujYnbt9nszlMkKQ09f+HSZ3rX3x5nHj66t6agGKdQn8uJO9679MpA6+vktzyIOl2X6F7wPiSHqez8AKYVBR2pp2h39ExjehRO22yHKMnmuPiyeIip0RZUbWohoW4eOWl08Kst92wuY1GKudxIylUo2170RYcpTUIaKk5/7+2ZjrLY8GK9XtNK7sbHX/nejZ8Ct/5HybThhfMQ9B+/76XG8WuAJYfTCcLWUREwzDgoBBfE4ApBI6S1gIILogy3tjcRQ+MEJO/kPmYZJYwotQIfSn8FSucPZf0Ibyl5JvgjCVckRikeRnx5m8GU+Z597R7VXtdBS+kqHi5j72uLI1K+Ar8jsINf4z7xpbJf+Uj2muLNA3wuv+jAcS3R+/Jhb7LAzsMklnL2HtfXDKbqA73VDCVrR2dRHj0eYFBMzlbHmo/STvjOKSEiQaMETquimKu0lWHpvbDMZkv4KYh2ba6ZGmKIR/nzM2xlhETwS3O2l2M+UsTt55zdWpb6Igfv4VFi6AL7GF+nRG5xHpE7p9TQ/78jWK9PD/LNcSiT1typ2TDyM/IV7XZswA9fM3WspcFlXO+TF4rWAB9qNQkzBf3UUipiZkRkEyL46qN7XSPOz/RkX5rI6jg7qtW7PUye0p4zek5A1rVOGkmckX94soFSnxPrklLfPOx8DtuQUWX4SeqCKyzUEgwigkiHnyAbsxAV/EDN/OtcViXHKyEhzMmdi5+GpopvlVThEw9tKRKzdcea7j4+SL
 LJ9LGP16
 bO0frNrQVuINXFSKX9evZD0i1gXwSFH4iqs6OfTlAx8jzp8eIWXn4tU/HrIucahIXNgccI+dmifXurfQsRganCQjZgxZVvp0chWwETuGQ8MwJd7YWvKSJdwVrtTdm3M1ln12AxDTzDUML9JSXw4PPgD/ss5gkIItYFGjTc4zvR+KJqshldOkbua3s1GFRcZO0MbSFq2nxHeSdlsu6OEksjlmbnTQeAd1LdXBqU5DuzslzXca6C4dnwxrOr+aMrErNjdLL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Avoids unnecessary waits when the TLB invalidation fence has not been
armed, simplifying caller logic in cases where the fence status is
uncertain.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index f7f0f2eaf4b5..c6d4398d3429 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -34,7 +34,8 @@ void xe_gt_tlb_invalidation_fence_signal(struct xe_gt_tlb_invalidation_fence *fe
 static inline void
 xe_gt_tlb_invalidation_fence_wait(struct xe_gt_tlb_invalidation_fence *fence)
 {
-	dma_fence_wait(&fence->base, false);
+	if (fence->seqno)
+		dma_fence_wait(&fence->base, false);
 }
 
 #endif	/* _XE_GT_TLB_INVALIDATION_ */
-- 
2.50.1


