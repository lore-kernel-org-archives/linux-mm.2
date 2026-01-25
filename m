Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C60E63C81
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89106B00B9; Sat, 24 Jan 2026 22:36:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B621E6B00BA; Sat, 24 Jan 2026 22:36:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928986B00BB; Sat, 24 Jan 2026 22:36:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA946B00B9
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D8888B645
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:16 +0000 (UTC)
X-FDA: 84369073152.02.1DF2AB9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A6EC140007
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MRjaqdIk;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMFiyVWXMbLUuHRaUvPqestNlQdyliKOVIoiLlpiwgw=;
	b=bPuUAU5VudMNH9U/VInnf1Mo/RGXHq+7vK+ZOsGdAqadanHGn/BLvFPBwXxAC0FQeKWzjk
	2Av87myB4M4lHNr1BL7oDljbIwOHVyHr0ijxfaVwLn6Ay6axH9d9ZBUzVGDfV2PWfryGuC
	ZOd/TuI8FOLP+yzEYK6JOio9Dgu3mI0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MRjaqdIk;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312174; a=rsa-sha256;
	cv=none;
	b=JiPSr11b8fMH6H4YZ7Mab/mGxWsqFC6M/r2bIq1wo2UYx2aVqHpq6z8l9fAm+v2CU/ZofF
	TGj0YTX+Q4fX1xj7GgSUBZAZKBSDMFl4D8JtC+Tq8ckms8V+em+w+rjj7MHgmpC/FT3Y/K
	wUWuFCpHq/Tw7A7fOP9smoYfAbUUZpw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312174; x=1800848174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vi7CJVPg5ib5wpU/YN0OFZ5h4huVEalzAff2p9W8l+Q=;
  b=MRjaqdIkJtsRBTiVVZHcvC2LrCF38Jpe5l9OXByr778QI5B5LrUME5bR
   SJtl4ce3UfbltLGdOuDGTWJRtblQ3z25ELWM4Dkj/KMJ0A/b3PAE2nhCU
   lDHxysNIps+oeP+zC4MAj8AQZ6KtMhmewpZ8Wh2RJSoU+IULzNXiXyE1j
   qHMuy+ma7bhcsXmvRWr8dCxfQ9xtTUwVwmZMcmLotnbsdFOw/LsEZJc8Y
   IFcuGDa7eGHxCh5s3JzUYOrRodt6OdUoQew5IYLXffDZESj0TAlozWJwp
   MkCiKNu1WNXdXo/wO2BNCrh9Xzd2BtfNQbPU3UYUCNJXUEOAMHGfEo0B7
   g==;
X-CSE-ConnectionGUID: BnD+GsfESA+7UWQtAHb8Nw==
X-CSE-MsgGUID: F/VqyG+SRjupUIK9e0CuDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887667"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887667"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:13 -0800
X-CSE-ConnectionGUID: 8Rp86VFiTkeopzt3pAIreg==
X-CSE-MsgGUID: aj7MA65OQcOUK2WmnkvQ4A==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:12 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Sat, 24 Jan 2026 19:35:35 -0800
Message-Id: <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A6EC140007
X-Stat-Signature: eg7txw5d5fjn6z1y3atdqadpii1axje6
X-Rspam-User: 
X-HE-Tag: 1769312174-991309
X-HE-Meta: U2FsdGVkX1800d0k+gN7k7aC8p6d6XOH+UEoKtiqmcWp0zAtiTNhOxHwurJf7yW1jTg4wd1SpmBICL0LpjJSIzIELBAfW++NrpasJn7KgBYArJMEf+/Wi9CVcjV8fVFIantjP5akFtw/ie0asjCfgugH/szdlY2R0LZD5yvENEb0+Ee8fzxFkF4VnS4TyMYXwlkZnn66eu/Ubeba/9JsE3iHF41YXVyXki+8PfGGuvP9nYlvBmdQ9M6lpVv0enkoGNTBmtKKjms24VoOHoLL3im2p4QrZfgH59TPaIQdqoowdi9vbrKWBjEG0x1ZktWW1c3sLnV3N/9tjg2nHgB0eQQ0iGrSJGWcLU6sywcku8Rm1Z/4zHtSNfTNJGzQYfJ7/SdTZHbtLC+vlfDtXDlFaW3waDSMJE8jc/F6aHaUSOraUt10JmeRwX0Yw3FkQWYQf1X1l42tzwx3isp9XdmmIbtZHk4FxX45qFavORVsHobC0z7ME1MZ8lsrEr4/XgTilfVMGSvVoMUiNf98URISX7AHqyX6ZCTNDm/dSmPymDMa8rZWYqUw90EWkausJFhyAUf5Z9T17qjFX+041e+6DvBcOfltMkLqdlGc/t1/eR4WxyEBlcEMXCdNhTotYimeZ/+kmZPkoXI0whHJXg7E2XaB+b8sF6ZTXZ7JFhfN9rSc9+Fcd2w6RXBfuaXvjthwwU+sNUrT+Ds4bVAxpQTk8hp/bqI+lYvs+8deh6PnKCnPz7aEXsfGsZGLwNNrql/WoTs220/Pj4fqIuR2lEMjbWu6C7wnUsLYyIrKUhcqBQVxlfJbbUJdY+QZcfk769wfcyrJ4FDKxHtzewVYYUMLy6c7GP+mg7RHIONbPz8YbpNQlTC/6z9x70nAmz9Q5TYqs0ff3cwPUOP/X646gXPIZLwduIQHIyJScqsLdy2Ny0w10z4VSY3L6a2Hey8SRtnFXkf3ae8eipOnjf6krjp
 slWN0/lS
 WWmPlwN/ZYfU7S1PiaWs9hdIJMr+MLXmH9594X1K2s2p0o0xyRbzKayH7aSClMLXR6y+x007qdK6TezIlEm3YUflr+xXCHYD5IAekbYFpRoSp7wXQDxQwLFGHXN0sL9rUu3+3137BNQruDIIl6xvorTl2q5elY4qGQZ2mhtfeXxqoGqbtZLF5ONdCD8woUiLxE2zzfdJzhZohW/wmY4PMU46L8Y7pKaXqcCSu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 9480d54264e4..0d56390342b7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -783,7 +783,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -791,7 +791,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0


