Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362BACCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FEDF8E011A; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789CE8E0118; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514888E011B; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3DB8E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D46E44A921
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:53 +0000 (UTC)
X-FDA: 84072359826.12.A86121F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1B47C0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iIrOnXZ+;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDJgm814buMyOm4KP2tD1Tgsh4if0Eg7s+ICWf6se3M=;
	b=BVLUmEP7kpA42kD7MR2G8tlK0St9yUgatS9Y/WqRLWEz+LtdoGw10sIyhzaUMbUh8pakUz
	B/GoylEyNhvt+KPKBe0EnMOQQ/6YbL0zL0NWt83ytrtJeHMw9c9iVEqkm8Y8s10jSt7S+l
	H8dXLyHnu7ikSQSTTPNg2/Uv+SXyIYA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iIrOnXZ+;
	spf=pass (imf28.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247572; a=rsa-sha256;
	cv=none;
	b=OsuuSk+IIBtJ72YBr1jU+8llmwCui9dfhKabkk3BwbO9G2qDYqJgZjN2DMtbm805Xyvm5B
	QsrZ2zZU4qY0JlMG/lQ9ya/mQWuFRLUlu8MLOhEeGAgUcLc+cadFypxKIJD66Zl1wngKJz
	DyipzM0FTzhO1ZRQexFZGzQfXOVHXJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247572; x=1793783572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBdbm5XI7No3D0jVnr6eOfnAzOyIcsZxr/u78wYlkzg=;
  b=iIrOnXZ+UNVChgbW3O7mMGf4ySu8uV+7/C2904/uBDtuWcudWeKlePew
   5+B6qt0PtIq0l0K+nwf89ZRB4tV9XoS4DIHo/8EP4lSsSuK8yLDBed0Br
   IpbEm8xwV3/AguIdV+jxUO30EjuD0T18khKLY8JfbdDApU8/eEr+EnGi6
   yGljCIQ3FxrSL2hPjXciw6w++PVXv2kHNAY15g18sxdMQPPyL55FzPerU
   AuyiwPZMQs3RSq8jaXGGLs+atKdLTbSlTX/MWasdfakhpaODbHsmShvra
   99snMSkNwS1btgNOdfhvrPayWBvUtxgB21yErMwvmKX+GSVFX8tO3rbjO
   A==;
X-CSE-ConnectionGUID: h/ozmjGOSzeaJ+PuPe602A==
X-CSE-MsgGUID: u762baDXQcqo7KyR3TltRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265204"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265204"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: bR4lgby4RGKtYGquYVIuuw==
X-CSE-MsgGUID: WJfBIx7yQ2CJ+0ora8KM6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795836"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
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
Subject: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx resources.
Date: Tue,  4 Nov 2025 01:12:33 -0800
Message-Id: <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1B47C0003
X-Stat-Signature: q8u96z5burtuu1xe6qm8u5b1yp3mi43g
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762247571-457154
X-HE-Meta: U2FsdGVkX1+b6Khv/y/W9m3hpwKLCxKVnJm2HmfM8MGXN+Gzad0WcDFe6J6wmHpeyY0EjR6hhI8G0ANB0m0SdXvWWSf0ZV8j9R0ov5/k3EzPmkYNhm8YYY5wiMrzhA6qvjPlN2Xbtc40nA79j+Q+hcQBgXxO78wvdcePhluvj+ylLA25EG9VVsTy+CfT5klpGBraY5vWmUDVcv8Xy2OYaePEtElcJZknLuRKYNB1m6+hX55Zl48aRfBOUZSgRZ8x9SshGAv9htE9vr1BZzeNwt4rnbgKEbOTb+MbPG9wYoXqsqZQswXHLouvmGu9X4/xetogKoTqtcJUQRHVqh5sTeIaSstRs6b+f4HZSBOqNs3ZOlmOqV4wz/IC8vWuXwF5VWtqikAepAFHgqCvZDq7y0tLVg1AFuElnVGKYDvQWHG1oBQU+9UvfOThGPb5mh7RmDU4i/u55TIW31iC0koy0L8Y/cYIShgP4vpb51UJnT/6VVIslg6hm2rqGsNyrds4DWR7Q8xfmjn4wVYgnGHFWfd5nyENi6Xm0JBAQLhyWww/4ajhwr4iuEsqYtw1/F5bI8Va7JUmdSNL3YRjhRuEwknJbgGh8R9eTHEi3oVmUbw5H4KWqX5zZqOcRfVYqfwknHAd8ChlTqs0DIZBY/bqItKFn9S7jf06uICsIhXRFfuxj9cpORTESRI0oSwjEBkPchjvUC79dBPIV93oSAIcPaBiOrBsxYz2qbjvQYIACzJiz9W+SICe1O9W7nvP1mDF8Zmp0Lv6m6upKpVbiUzW4gENCKktGNbZxj17dg3NJ7l7mLM6GAZdu1kxlF9075s5TnUFs7s8Tvm4SZauGibzXddPqHK2U59H5MtMZtlqxezAVSqi13NRqZOrDcFdtxC6fYlGGdJMdxKkxCiQewqmC3RRllbBYcLG7VkbXkJhngU=
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
index 87d50786f61f..cb384eb7c815 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return ret;
 
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
-	if (IS_ERR(acomp_ctx->acomp)) {
+	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
 		ret = PTR_ERR(acomp_ctx->acomp);
@@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
-- 
2.27.0


