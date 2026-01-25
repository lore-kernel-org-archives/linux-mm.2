Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF58E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9176B00A9; Sat, 24 Jan 2026 22:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDF96B00AA; Sat, 24 Jan 2026 22:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7F76B00AB; Sat, 24 Jan 2026 22:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D145B6B00A9
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 972DDC1C5E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:03 +0000 (UTC)
X-FDA: 84369072606.28.933DA6F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77B49180005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btnvQQY7;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QArQ3xN9eXYKWwtVc+UOJRp59yTSpRG3YSn0g0oTh5Q=;
	b=AYq3QisLSRDFUtNkYWFXcsKH1gh3WIHzWdRopT4qWn37XWtstyQ6nB+uo0AgoAXTAYNunR
	7KZpOt+4xoQ1dyA0+enGkWgF7/Qhl9KPc08IwjQ6d8vpKGHIURqT8YroIvhzVg78Ws2tpP
	DULyNK9mrlw3MP487UnvEpauApMF7P4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=btnvQQY7;
	spf=pass (imf06.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312161; a=rsa-sha256;
	cv=none;
	b=DLv+HAzGH9LaoQXMnpykXmOijTBMai47KOk7jwyFx5s4W6TzpyrrG0dt5FpxRV3jlAjJx0
	xOMO2TmEE77UGOfZ439Ogj0+JgpqMY/+2mJ3NLxJs80mfHUB2BuHTU85xatwpN8A//ZOEi
	8H1QkAG1wwzBvvw2F0w45d1BIRCTDI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312161; x=1800848161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HC8fdqJFaBib45Q8EUreD6PT2wkYvwrws+aVSwrcud0=;
  b=btnvQQY7TcjpOjlMPikvLe7U3ZEHTh7rkkBQcGk4fQFhLtDc0DgUYJk4
   0GgxpwqctyYARla/dB0GuF++JpcmbXozYkLqG2npbni6PRgl2J1ry5wVs
   RBbBnJt9SGajCyhNzwq00TqdabthGJQOk+mfBZqXmAFSwG8to1Ck8THy1
   LcnzdIdveMGUwpkW9s3jjBEqUSb6jIb6/xpLtg8anb+3ku5jioQDE7ZTZ
   AzbGn0OGqBpLRiCt5o6JL+T54dHLYCS1Fli4PTEcuvrsTrdePt+lryiYT
   Hqg9d3GqFN4X5kZPiM53GGMFyrdNbu+8l2KiLuFCxysSoMD40gkB5DiV9
   w==;
X-CSE-ConnectionGUID: HAD1XI5hR4qqEuoA31w3Dw==
X-CSE-MsgGUID: WHexp1jSQoGq+P0yY7oumg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887528"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887528"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:01 -0800
X-CSE-ConnectionGUID: qnIXTLqWTZ23va22SQ/BYA==
X-CSE-MsgGUID: zalW4RTiQNa1H401+BbH6w==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:35:59 -0800
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
Subject: [PATCH v14 15/26] crypto: acomp - Add trivial segmentation wrapper
Date: Sat, 24 Jan 2026 19:35:26 -0800
Message-Id: <20260125033537.334628-16-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 77B49180005
X-Rspamd-Server: rspam07
X-Stat-Signature: 4ycab7un6ff68bb37e1q8ef1861jtwkg
X-HE-Tag: 1769312161-652906
X-HE-Meta: U2FsdGVkX18o7fF95tjCaIW0Q+5zKF//5Gx1IedpQz1CGO6+GR1Q+U94tj/b0xl7xRD3i7IYvBPzotkiVe/9T9VaKPSlhhD7M+6o5sIZLDk5TzqG/taMhU0mTsDBL/WSK26oWVjTLsqPtm6rgroJK09B+am/THTIfiGGu2iib/cr2PEVWampSzTNp5MD/qCIAWzjA3ClYSWyZpMR4CEo6z1FgIquSI9f+gt5MIjjovdxKmZogYPD5ocfp1oXL+NIt59LYzoaH09MEr87hg2UVZ/HvB9zvuM24pocKaETrA/X6Frafvw3aloOU6AqhTSZGjHleOODo6FV/KsPsQhI7qRx5An8UIrFtfBWXzURFvRQBsUOZvetoPwHRa8ZZhB+6vuK92UwzJ8F4D967hpc2CnWEEqfNbd2CAR0PMiuWIM/GnJQkn2mJOiU1txEQhrSD1yiO2L8dPoi+IjWgymCFNrpcbv4A798zb5dUzeoNl8lp2NYhHtGArQ/YRiPes/ihDhs/jXo7S8VRY42weYDJWHW29eBIMWDfdwBeLl7MkBGIc/Fc6PwDCM39PDPReSIWT+vtzAOfaiIVAHeAanULEJjlQfMuiDx7mx6I3SFjir2TauyAeRX3oZJmUj3UxttcygIOwl31rpN/hIWNay7//qI3wp4iMBnLKFUldWOU7yHKoFoLjEGebLXN3HjlbkEnxOw57/2InJrSejCV10h/YLQZzDanjLDfafVSNC/YLNf4+4cscJYWbxiad0V5D7JyCGPWshRJcZpC+uCj/WilPOjUJXdONTFow2WX95qtdaSOCMMKFA1cJLW/yt6y7nT98NNoPg//VcJTMZI65GaQBIvJGnYVVfHu28AgXwgU8NqI/HRrKo4cxmH9ZJX6/64SivH5mUDVyxm5JAyCE4uN+oKQ3CjvB6jgmoqIRbVFFxxaniohFwG512VtYC7RaDqEZWi5aX3vxXfSAc85Hv
 dobJIF2k
 voNmKFf6tT5vrwj6q3jvVN8OpG5//em/INJbxE4EtB8a70a+m6CnmwH2NyJ1xyk8IGldhAlzhSRY9QMrBQ/ObkvppUGpdN907E5a8frLV6mJt6KbdR3Yd/5HSurg9cO8mptGBpNu0cIHIj3edLDMxziOGnM9EvaAGGoOloNzFAOh+daiBFQbdgqYkjTbbe082yhFGsVmcrDpaBmcdgtzortu1LVG51Ec1/U02U1QCBhUrHVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch provides a wrapper for existing algorithms so that they can
accept a single segment while returning the compressed length or error
through the dst SG list length.

This trivial segmentation wrapper only supports compression with a
segment count of exactly one.

The reason is that the first user zswap will only allocate the
extra memory if the underlying algorithm supports segmentation,
and otherwise only one segment will be given at a time.

Having this wrapper means that the same calling convention can
be used for all algorithms, regardless of segmentation support.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c         | 33 ++++++++++++++++++++++++++-------
 include/crypto/acompress.h |  1 +
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..cfb8ede02cf4 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -170,8 +170,13 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
+
 	req->base.complete = cplt;
 	req->base.data = state;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
@@ -180,6 +185,7 @@ static void acomp_restore_req(struct acomp_req *req)
 
 	req->base.complete = state->compl;
 	req->base.data = state->data;
+	req->unit_size = state->unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -198,9 +204,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -248,6 +251,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -268,14 +275,17 @@ static void acomp_reqchain_done(void *data, int err)
 	compl(data, err);
 }
 
-static int acomp_do_req_chain(struct acomp_req *req, bool comp)
+static __always_inline int acomp_do_req_chain(struct acomp_req *req, bool comp)
 {
 	int err;
 
+	if (unlikely(req->unit_size && req->slen > req->unit_size))
+		return -ENOSYS;
+
 	acomp_save_req(req, acomp_reqchain_done);
 
 	err = acomp_do_one_req(req, comp);
-	if (err == -EBUSY || err == -EINPROGRESS)
+	if (unlikely(err == -EBUSY || err == -EINPROGRESS))
 		return err;
 
 	return acomp_reqchain_finish(req, err);
@@ -287,8 +297,17 @@ int crypto_acomp_compress(struct acomp_req *req)
 
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
+
+	if (req->unit_size && acomp_request_issg(req)) {
+		if (!crypto_acomp_req_seg(tfm))
+			return acomp_do_req_chain(req, true);
+
+		return tfm->compress(req);
+	}
+
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->compress(req);
+		return tfm->compress(req);
+
 	return acomp_do_req_chain(req, true);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_compress);
@@ -300,7 +319,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 23a1a659843c..86e4932cd112 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -67,6 +67,7 @@ struct acomp_req_chain {
 		struct folio *dfolio;
 	};
 	u32 flags;
+	u32 unit_size;
 };
 
 /**
-- 
2.27.0


