Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F89CAC5BA
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 03:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD618E001D; Thu, 25 Sep 2025 23:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B68D8E001B; Thu, 25 Sep 2025 23:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7258E001D; Thu, 25 Sep 2025 23:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D68028E001B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:35:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A066160545
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:25 +0000 (UTC)
X-FDA: 83929986210.06.880DB3E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7293AC0004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:35:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e3wsa5JW;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758857723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJ4PgW5PTTBAdi/vB3nZWEul2SCx7fImbg/aa5faLtA=;
	b=IUkk3xiKGSzvzrNGPV/q1FhtMm/lUI/oAseh/5Z7nbvFFDNkYE0Yi1du57nFSibIRfVKtK
	oyxdVy+OQ5wcv7gJv4fJ4LS5IY9KXE78QWi+64jNKLOTVg0EIzAuEnZec5iHyJT92Rn9q+
	+NgCl+EYBBrxBqRhdljJwNKcTsYuYOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758857723; a=rsa-sha256;
	cv=none;
	b=C/TAzigFQQJgJuv44NpMI1Wv60tUCnqWs92RojRskD8sgSj2mXO2E3JiNO2eS7imk6Y3VP
	oGNNs+NnGC9GB/DfRMPbwHhgzt3oY7xuHi1vwWcFr7hO8UbJqY97Wh1PDrjU+FAZji5hiJ
	R8Sg/xvbdujv1mrVFmS8tC00XM6+xPI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e3wsa5JW;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857724; x=1790393724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZGN6xEotmZo6YeZgYvHqSvus949RdI129rpxv5A790=;
  b=e3wsa5JW2JO+WbwZz3TNIH3V8OdlZoIwWRnxrU6nXPE5nGrb7RnZ5Kc+
   9+9K/Qo4Aehb6IL5LMJypbi4zYHtFHQsaATvUFHiRSmVFajEBI/jY1xno
   F7Y/oAbrX50G8Tl8k/jqzSUD/IPO8lbqUfsv6xt5GNhhjhQbi1ZDpcAcC
   BFBOVbUBFZG0mommJNYw6RMvsG8k62su7MrInH5cbMeF4g4MW/09FVpd0
   Qm/lFKj2nBmQvsy3lg53GkifSnKCZ46+1RaoR3yBhJBQKGSiVGz7wBcNP
   412KFxax7SbuE22rg9MalX0JQFwUKT6ljxLJaAG0+/O11FfPHpwfQndCU
   A==;
X-CSE-ConnectionGUID: F64LEwxnTHqZlgyAaY2BAw==
X-CSE-MsgGUID: Xuai8IcqTTOunhjtesSOUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819687"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819687"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:07 -0700
X-CSE-ConnectionGUID: wVuklESySoW+bjcdUaKEpg==
X-CSE-MsgGUID: awoYk1RmRJmb0Cdwz6hcrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636615"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:07 -0700
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v12 21/23] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Thu, 25 Sep 2025 20:35:00 -0700
Message-Id: <20250926033502.7486-22-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7293AC0004
X-Stat-Signature: 6cctpu155zzrfyx7t3rz9wuqrhy9sykq
X-Rspam-User: 
X-HE-Tag: 1758857723-444419
X-HE-Meta: U2FsdGVkX1/4rfR1kaUAbPFSfcffwPlmbXRRjDiWL6Ms0uOLQf9LCrSp0gwrC+MPom5T4oURT9bDvX6tCQBj+lOMF/OgU6ueaf0YdKyEuySv8lrD6Jh/dkHJU1mvXhHJjCyfT+6HGnXWo8L56PDeGHJ1WlDAf/L1NhmvDXIMvrkVKynYAKHka+zaule5MIyhx4worIEysbLldMw2ZkbM+0XsPlUZE7tMXAHaWMnv+ofdbcvDf2oSp1dpFNFbWciYbpxuDqcrWbov9BfC/NUeqlgj7xDxwAPp1lNDgXyKR6QGEN5vn2WvNnzLw+ECjU9bW2ypxgAu1+PIwYbkF5YUz0if2Fg1JcNnFP4YHZoo76zcTCcc1pXOpJ1d4Nm436gtFWjV5ybfKlT2T60MScGZapYyUnqPymnmLqfxbqbWWnotqz9sjh+Ps1D9MhhUTFliEoBo/9xg9cRp0ERDHkuBhLxbLic282Dh/o/kTwU74CShMlYRyNvNE6SyghVIZvF6ANYeb+tmh0sZTeau+pcVt2OMYqafXgm2EwEtcDBu3gQvgBnG4tgkPUux8XLyUZO3G3Lz5EpuPmrtkoejuIY/hEj42U/BOiJhfUe8zHIDQtanC5GQ6zzXfUXydGodR2PdTjPymD6zF9uxW9gkM+laeu68SvfD4NWAK0oGQlpugQ/55IX8UY/v2YE5jJIs+IXWb+afsgynO3SNrJQlpif/DMTy9WQxYKqRJRBDDM+MVopQzp1snoF72wFmcpfcBp3tSEpdrYhm9A6hFlHjJd5HsgI0FHVtSWO/ZCoBecJwXRMV0P6Wtc2zge+92arMxTYhQVueJJd76XPXYfClScK9x7BQsFxdqX2i+DVSFCc0UNyPkIDmhujR6ix1it2I8ldaUWep0VPVCVTFHEle0MPPrxlrg1tTaSg9yi5fC7cRhXUZUmRAbrstWKxbnH50024cIqe1xHH/sYcMPtiAAEG
 rq/BPSNT
 PjveaRqzl1BjFXWIvQgbHXupfA78/V/mrP8l/Jks5RHpD6CuEzuIhM1lmVhTAfFqUMxs42rkS9DuYIQBnHZsFwNDPA3Ehpjk1nFRGcNnY1sCuz1jIQP/rYTxypGLVl3ZcBJvUuQ8dpfYzP9cBq06ZrqIsMxAOhRuVAJ+turM8te+eQ8D9NaGXxqxBEgHYD+WddNKwrAE4Ao8v38CnG4o/wooTmJx4frL0m4tYjCHLwiaORV2In5cXyLVszJGJq9IQB2fc
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
index 27665eaa3f89..3b3716808d7d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -807,7 +807,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -816,7 +816,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0


