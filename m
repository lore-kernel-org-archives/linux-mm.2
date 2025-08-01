Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2ACC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9BF6B00AD; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558C16B00AE; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8786B00AF; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD4B6B00AD
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECE091A0CAB
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:03 +0000 (UTC)
X-FDA: 83726928726.28.2C0BE1A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id BE5E740003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aafr77vP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023022; a=rsa-sha256;
	cv=none;
	b=vyueZ39sbaI686QuIic8ifHvzx/gf46dNlaR35uMuzdGddbf+UNl+gUviAGJM2qBVouXr7
	gfSPnGx7QEqL6ipU4PHZ2N4++ESxNwNeOobYsMHHsKVeJUDkhwtob8lmxFrX4ZkqG+8vMU
	u72cxjIn/TjdKPp0HgbNZWT/yhM3KB8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aafr77vP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCYiLJ0nufAMaXWgkBoNyFEwtbA87F8UXOfJHnnDSZ4=;
	b=a8onKlxwG9fTe+u68u+LkVXRyXXICS1w41OALolv4za9ibPspz5km7pr8OtVuMKYGrg/e6
	6sWR8GqAMxhmm48eMB/5c2TB7LB/Psg7v5nnunckNF6PwWYsG0DXEPtemkTRssxnG6Z3w6
	RZMsugk6EKl7OrcxJr2nqhHHd+SuSpY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023022; x=1785559022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OnMvGoXOVZ1gus5tJpdLE5smcdMcmumbflpDULaNDSc=;
  b=aafr77vP4nw6Nb0UJf4CdRlkTnhwfpNMKDB60GUDCHZ/Np58KeAff/bp
   S747H3rRz6rt2yuyBJM0tvosChM4VqZzB+Jz5bCfg/CZvYcYNRZ5gOVFg
   a22Mh+Og7+AD6ha3pMUgUkxzk81ZNnA+4kKj36Xelm3pYjuXykK+X/Lcy
   zFIopxkrz0eUVg1e1ekCsY19YYpl8QkqNKyoaNiGUTs/T3CuJrirfBzOi
   hRVkC4AYH8WKEImOFoHxPu3+YisKgD78qt6FItDkLMCmJH13ppbezamHs
   wkqS02w5P7m4dKSorsA03NmeZ/ILc4ycYDNdj29k4KET3T3dUmqdclAfB
   Q==;
X-CSE-ConnectionGUID: gYNYuw75TrqqrF3atbXUpg==
X-CSE-MsgGUID: kt4w+DBuSFGqlsRvEzhjRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820419"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820419"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: N1y6iMoLSoyLCpUvn21H5Q==
X-CSE-MsgGUID: y/snxBuOTD665WFu5z1tiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796309"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 21/24] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Thu, 31 Jul 2025 21:36:39 -0700
Message-Id: <20250801043642.8103-22-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BE5E740003
X-Stat-Signature: 5gb73wmimypfndj3madjk8you44b5xpo
X-HE-Tag: 1754023021-359793
X-HE-Meta: U2FsdGVkX1+saeVQAqq3Iw6FdZibC1X1+0zlPINswr0xk2c4ujXlJigILTAFvQ8Xvas2TWRhqe8as192Vj3gAd53QqejuQpKZo6Co7AisxvLZ+ONa2oA+bbtIRb/bcnym+s1c62I1kl+ZOx1Jao8ScoukmGTNtSRpZrwCUbfINW5GX9hZqH5qEpCNiz90Ag7N2TYT5yf3ocGa949JHElwiQ3/4M8CcagrWViualq33GvEJI53RorHjZLlwIVS+QiSIMm9kBzWO7eiR1hVyuMb+Kyg6dOFaQ0OQrAiWXhQZKrxkgXn4oGcXSoXdBg2GxSkGs1wGezC6lASjA9gQlyiGs609sEOfa+yY5tgJQZSgMAjIEyl4UN1XCKwmqr4RebmyEuN9q25fBjilCnQSHyeoQBYARvrzoNtuixYcSzxW/FCiIWOsDgPl7ShPFTnFn7cEk73HFK8WCyOnXtxKW2CMEdk11NyJ3nG9uAo/CIuSjdbl5UOgam190CGDRxIAWdma35GwC/HA8OH4Od0qIyZwcR8fomZS9ym4XOXgn/d40dqzO0PuXhJ5GiV0+T2jn8UKrrSWvcc4ZJehgCpS6vgEbec0srbUdzDCiLPieX/VrfpZv+VjvPOADGQSKOl4aKjUWQf0l3qo+rH9VUUoddYh+r2fz+Yj4QJ2uFWWWbdmFHO7PGUje1++7NRs6DcrRIV1cIZBpYuXfhvjiqBNPES6SZieXFPoN5hLsxKsvWA1vSjnlfTHAZcINDbUSwG97dlI7WeiZ89LaPe5+IVFMP4jtQiCIwfZ5yNOd4LPdp2Pmf4mfMcwDitfjU7PMG41iYs3xz7Fcrr6BmJjxtSHDdeTxsZeHqKT5k2Id7s/FoGy2K7RrDkbjpoxLEX0PpIU9FCcB2Gz8tsy4fV2+6hBvVcrNOo+HbHjssG33tk0VP8IoS4ggF9/LbeIF3XiQJ3aB7b6m0pDA++HjW4qi429P
 reyteXsO
 EkEdVlPHEgyCPLPMPAf7VcSCEOhypkWK5s/yjMpQD8Uvgz9IYDpUHpome/1D0pGNqh5Ip7w4CsZDeRlyxp1nl9P61/LrhfnaRBoLxV0i5BoUh6OqK8zlAzqdNWBANo+m+ZPwR9AMemX1nfFR1Rn4yoqV9cO5Yk9Klzn5B6p8PphIeZV/U85gOR/jlCb2rM7FTZOLC2P32yD0OugxzinMSYv4hupofArmwZ2mEmZbEzXC02fF589zFRYQHAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
for valid acomp/req, thereby making it consistent with
acomp_ctx_dealloc().

This is based on this earlier comment [1] from Yosry, when reviewing v8.

[1] https://patchwork.kernel.org/comment/26282128/

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 7970bd67f0109..efd501a7fe294 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -893,7 +893,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -902,7 +902,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0


