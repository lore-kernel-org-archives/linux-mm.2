Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC1DCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29288E004A; Thu, 21 Aug 2025 07:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8FE8E0048; Thu, 21 Aug 2025 07:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1F18E004A; Thu, 21 Aug 2025 07:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77E268E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:47:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 183E682E82
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:02 +0000 (UTC)
X-FDA: 83800588284.24.18BD939
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id D87A9180003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TdrKzpNJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776820; a=rsa-sha256;
	cv=none;
	b=0+sfe7FcFRr639kv04zzhytxqASDNloSHfxAprNRha9zif4Wvx+4qahSSKD4NyKs9tRx3g
	+7taSkpsV/0+TX5RPyre20r0TuhBc47PjiMS2s0Po2zjUgudHCz79AmfL1d1+tlMpQNz4p
	1VnFzbf57Qp3FNo26poQrkCLF6eFYqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TdrKzpNJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmZF+PGGpQ7BonPjN535BzGIL3gxAEu1Lf4M3+fywrM=;
	b=3rVnNSZ6FJHkL20+CW6x0JvWwRE0Rjb8Kcx5TGO+5pO6ghMk5btwX2SzDlyF3H6QrJekEo
	XEo58xwqOIdFdA0miBIFcPqh3UeyQCoYDGm1rvF4ozHYYeBtyML6V/IL07qaPqCt3ayP0Z
	Q4G8MjxIWvZKuiKn9ch3LsAtY3OZoWE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776820; x=1787312820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iX+aI4EV6aIpB48ENfwpl4TWhZJPqVgs0W+CzzXlU1w=;
  b=TdrKzpNJSigHjDrH1lZk4qnK7JP+PR5V9Mw/vJANCBjhjHwORXYtdDBH
   VAzxRd05YWcevkAt6hHFCkq2Nuot1xloNd0yc6zUrtdsEIfurZ7/uQpm/
   ZHJvLEcJ45UpkBCOYHfYzEMeNL5XDkDHpo8fAveDV/EjJSXfYTBK7nt6F
   jTpWn1AQIWcKOC8WAtit24FFVdBNMTr2nNyerh/dqyxkOdPMmKXKTVzDW
   MFABmZ76xtO/jqlWNf/a/UZgEWRJb65L93197vJh1NYMf3iYC5CFsHAu/
   cTCyg/0sv+Tj46Nb2T/9BcGTR85BCBJ7mwykwMjTWjbY2ZoFPyuUdO8oW
   Q==;
X-CSE-ConnectionGUID: DEcWG6qPQSSUf4lU0VHbJA==
X-CSE-MsgGUID: s6hGJRevTiq/0u8SwQksfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989473"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989473"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:59 -0700
X-CSE-ConnectionGUID: 2aESyLHIQ3yVR5zRt1Vzfw==
X-CSE-MsgGUID: F6OSijqkS1qWmYbSMZkCTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613648"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:56 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drm/xe: Skip waiting on unarmed fences in xe_gt_tlb_invalidation_fence_wait
Date: Thu, 21 Aug 2025 13:46:24 +0200
Message-ID: <20250821114626.89818-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D87A9180003
X-Stat-Signature: yn66k9e67y78ms6rpaa5huqpmbud1sdh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755776819-739497
X-HE-Meta: U2FsdGVkX19Nl2Vh0w88xrLSAWXJIPOdKPn2HuROirdsjX2PBXNEH9WkFYLjcUulBsX4Ugc8+t2wr7xytEVWV0AA6Y9g5/n6gUx0eUlij8/gwvdA4ZxnqDnA1C4gahtZw6ww3UAObe61KnqcNPleg54KgVZyIFmX9vCH+tiXRL/4E2FlT7VEYjNbMXm+jUmlZxLj8TE7OO6vA1UH5Vwy4BPxG6vVpAHFy0mgtYKa2ZDsi2tkQZxa3OM2lU1VmAXVIdBZ5fV1U/5zJ6us3mJBC18PkW23N6i7IE6abniTpU6JW4XbMRoR0W6/ywjOx7NLhUljYYXOQTvg2YACfWkzpqZGAfyIpeBoyWZdCODZkaM9+iO9IsB9/P4JcT5brkcpK4iUqq/bNehbNTjLZEbV2j1DyXnkdKJjb+H+ERTSA1drT+P9nzTuX2X84fPz54a8lLQIRPMDhmHBnoU6jTulHGDsBmBJzAKgL9Gc+5b0GKkRc9AqbJlzOubithMdQI7sKeiqUzOvvy91CoKxo3nCMOGmXzYeIuaMfbag183+Vfw7SZP23e+cF+5ijKUxPldHSD3BPTXEAp7oUC8+iAgCh0IQurQNk6qfT5e772rj8PIE635cgz7/e14aoyuxOjauRBuRZViQ/VkSOjXbamdBrASB+BJBj2WSzUbb93co1KQ3wKuK199FmFv4Kt67UTm9JNbsQufLTqGv+4d4E2IcjBysPWCm+MQmtUhxG2+egZ2dEUHG7GA38DIIiKReol6WgGFd0aqF1l1vOqHqj7ctHcWQIyy+Z4mgiB1m3atKX0EEf+KuGXYlP3Xd37lgZX8efjkaBIs43y86AQLRSOAO5MXXtaRi6kWv418vXmnY3HG1m7vyJYH8tE5ZtS59DxHTsuNb/1PTPQ7k4cbPPaHHtDJ/xIIdekDjEybXLI0kA7HtD6F+IKnqYdn8+2WuGtffHej4bPV7Xu/YjKI5bQ5
 TEgjUU0S
 Au91iCWLuUvUMC4M8uxZChYGlxw6fDwFOJH40ykbx4MZkE5hKHLhJ5RsRfHy20qdGdUFABJMx1G1kfkQKbNU7Ixktyn7aZjE8TxzfTR/13STCV7EYyPs8upxHxDtuT3C1wBBt10KDm9cCIIt9sPC7b0U0QBNBjqHrcHc0JvsdexvFEk5SlmzMWce41WPv1YtIr7ShiNzK+FU1kTHVw7P1eselKFNOYf/49HFyjr8LsGNPGaEhkgVAPuSRcL9AjWbaxvq0HnwQbmKLM2MtImYSNgZAh8q6u0xfLzJLHrlpVDr01q56oc8cdEaO3vEd6sLhNnCWXYXPoZYu6rt8iKIzw7Eq3ltB3aoD71ua58BQ95zzo3e2HJseu/VcVA==
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


