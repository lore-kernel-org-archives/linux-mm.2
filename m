Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32382CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604706B0095; Thu,  8 Oct 2026 14:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB156B0096; Thu,  8 Oct 2026 14:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518E56B0098; Thu,  8 Oct 2026 14:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 362EF6B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4724A7B6F
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:35 +0000 (UTC)
X-FDA: 85300294590.01.9A96F27
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 140891C0003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EfGaMZAO;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdzJ7KNgE65fhQiH1f6TncoaY0MtDlTTwzl5EfVwG1k=;
	b=rk9ob1OFReEB/uerwh2EsUin5+rfikO3mxttwbmC8aWwYh8vjdkTRCUOrPV92WOviETrgb
	bJ6o4MZZD6RFLFaCjOs+dq4URilaxa8guhPNX+MYi0jCQdhNOm6BAlYMLWpEz1jP5fcxN5
	hc7HwP7NVgqgLSytmGHP8nuiK3bhJec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484114;
	b=dgEx5QYYl9Snwt0RG2ZQwl6oJEsivGG7b9TwF0B4BX5mIIFB36ZvCDCRkQNivSQfGMnVE6
	6izRR8GaJo1MRQ8rsc7lgYbsQnzsr/nGu12Dqyv5Cnn8EpnwTYkOlIKVO4P2/IzqIaGhmB
	X36Y2b4/yipY/+qxaJUOyyJO150hazE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EfGaMZAO;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-150f88d22aeso3438298c88.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484113; x=1792088913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdzJ7KNgE65fhQiH1f6TncoaY0MtDlTTwzl5EfVwG1k=;
        b=EfGaMZAOZR1AEoxL8hwJ6BawZ4UcCNJolVJDh/AXd7FiElHG8hvEltrwja3+ZscQak
         Qm4inBezaGeQNJE+Tj2cvGyw3SpKoO1wU46frt1xlaiyzMEYasWuKg0ho7bn/bv9g/Is
         MeUIW9dt7OnT/xgvG2MJVCw8c+z8eHv7YYg0B4LStGK+pKWMdVbzplacHNjsl/r2XpGM
         SPF559gElaUnntd+bOx+MNEV/4jMY6I3jVLRLb2HhvhjG6i9rxD/H03OYpkAmGqdGuor
         TFcMmDJJKcvsFXAijNzbTpcb8Bk+y8Nwq3DYvVbBXHk/9TQvMGCG1OOUN4R69pPnblmz
         EjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484113; x=1792088913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kdzJ7KNgE65fhQiH1f6TncoaY0MtDlTTwzl5EfVwG1k=;
        b=eVtUVbm7OtQKuJS/HDgxjR11Khbj4Uo8xP2lMVHNFJGzPhR3/r7MCmRhTqwyOT4vvf
         k1CIQelLYszCfzTebdUIXeEkbr1ddX7aeD/VRoRtxD0SjvSCZLiMPzIB7JlUok6mfjMk
         DcFys7/4TXBlqvYSKBq38zZD0xu1DkENYXwhR7iNuR2aZZDYpwOr2bhpe6ZoJoJ45YVz
         zhRZpB+JRA7rEgoAKim4bCDokTt8F41pM5MgMQxw7pbs1nEEfY3cPgoGdaiu4uS8W94S
         fbHPMq0ued3z+hLKWb1Ufx/Qdsy7ai1O0oeqyLW2ric/CbefIAWI/Ak2+vfWHqk/bwx0
         IP5w==
X-Forwarded-Encrypted: i=1; AKwUvBwYaY46lnpP+39qETlX3Rv/7xRCH2OCV/ZgIPv2RbIreihWirSCh0RYygI16ZjDGhMM9wmXVMUyzg==@kvack.org
X-Gm-Message-State: AFuF++mQBBkYAGMF2TUTwCVdRg9EK6Vf4AJNR/NJ6DmrRPZWUk4uHy25
	T3jA0arf1PmCqv7HxuwZvyx3ysyKPvkperVoL74AcHLCM9cEAabTfyp6
X-Gm-Gg: AYBFou0b7HzTDI6Q8IR+dhiwiqVsdue7dPKuNMZv0gdcnFLTxEDzmv9yKxj+X2TVtE0
	JokdcXujDUpSV6Tko6/V58howeHYFOTavBycR1MmRa0DnkgxpHcz9rAFQZOe15Ao1esnjJ2PvB9
	+3YH0wppcO/XHRbg1t5J6qXUA9aJP9nBn6LbPm9Vg5ZcWJM0OO8N9miPEGyRo7pOH+4fMOxOU+R
	wUbxhHOZUW8PL4tRDciRULVEk3g6058UHUDpeqJ/oA6J5VTjffT2zT+nOjZcBuAVDC5jNK9HYn7
	2WNytvDF5BqVQODAIJgDW+zLGi66+tl1aDzqMsZjjOJkFjP6PLdrkZveTUrWP7JmtU5OX1LtpU7
	i/3iewuNVStDuYqDFGIBw0on5GrDCsnDXGG+Ha7OBRS/Yd0Z+1vXVK4C/Xm1XYm55pdFmT6S5Ku
	kJ3i90bvg3awjCggZmhO4mO/fRfJesKGbYj8rx1a31UXHa1eQ1b1iAtxZSDGzMl3YZ3uCQg86qP
	qSe/tR6KWw=
X-Received: by 2002:a05:701a:c90a:b0:15c:20b8:7964 with SMTP id a92af1059eb24-16206c264c8mr6939657c88.27.1791484112799;
        Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:32 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v1 3/8] crypto: acomp - Add trivial segmentation wrapper.
Date: Thu,  8 Oct 2026 11:28:09 -0700
Message-Id: <20261008182814.27450-4-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 140891C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4apuwmkwwyj4a6y64ebhynkiobsdg9ns
X-HE-Tag: 1791484113-91281
X-HE-Meta: U2FsdGVkX1/uxr9V4ALyikLArGpyP76etuaqULdvYMKB89Ibm/9+S0S50xah/fxaAYLgsAyV2RNNYOap5S8V+YQZGjoob95aoYMFBYJJtgCgGe9bh48DxcMkLcPTTpBBAJWfot4fxNS2IsW2YbUliUfOAdwkqWYm4PCurnaFA8Dvf7glw4zmI4WkvDMVgDZzWXYoLQP364UAlkHmi3IwnmS3MIFcXm6jslkcWJ0drt2aqW7mkaeHn7lGv2s2DRLTJz+A8Gn9oPwKNtUFk3JjkVu1KOdWCdYG/UAYwtT3FVV7qVIiX4xcNrYvfbkJCBkX87ADuh43tJvAhVLX/R2OY3gLHHQboBlE2Tas6ezcyw9LNiueK58INM3tKbYACFijzcQDccJ0779kiqVquHVAwqPpSBuRg4Es3HxCce+Oc797lc7F3q+b1upWs5EN5EqsWm9LDDqk4YeZ4XQErEEj5jRH3SvnjLtgynFz0gdfsffqHDEPsGc8N8Ke47HL5kgnY45EtMgrjIEJ65C9nMao2lNUlGDDa2r3XC1Kj+HVFWVUfHPbY+GMb9HAFC7d+NZKjh+VySnLzYAseHhhfciI1PNrC20T9aPv6r/1nGAmdTsXxy3xZAVHZq8NrdSyqG7PPDcSSNbrZNCQ6yU1QwItOc3vnCC+ZEWR07tp9SigFlKycXkw/dMyypr0Gqh3oBd/Hy9Kv77RI4RuB023LUPHn4Fe23OLBynK2GRvA/vJ2xb/gzaO8NuvmmDpQghLJlMX5NDxq6p6M2AStPob8lpA+SLTwgfGuRxEKuu6BB3fw0/xtgcQoVRiLabVpBAZtdTBhUC8Fjv3AhlDO/6D8m0cYAwZwPhb4s5rowOjg1Rl3+6eHAOFEUxP3rbb9qrRrgYYorfPxSrHPmU9Py7VLMRVr03wmvooLxdUmjtD6V4aqcsZab4SmT4UogipwHCMT39smG+Ylb9gCRa2bjLi0pP
 Fvbd/h3C
 pcY6cgYBp621VKE7Z/QxAXRPKktAWNWeI7CzXikzWv5eZVnvVBCoEZFOmORJXIfQTC+aZB78R5B7p71kbsZTcJRzj4zRuMvBpeqpB5nC1CGtvKQ5AjIVaioXKqfs8o+mfcX+1bfia2CuWYTHAG0Id2c5aj0sLTaa200HVy6/TMic/aBSSxhfGUebuThSKNKbuO4Dyf3b3zD4ygptzUe2vzeJVvgZyylWNfP5gJ7zxtRDEu0QuVI02TKhLG3/Bj74PwF/oCVhr0IX1Dn7Jweq9h+GeuS89+SPC+Q+TDdUvDFuMrrLhu8x8hVItD04/s4TsKAlntJT5UP2rlbIfto1RhpA+72YetSKBsz+KVMY6PU4OQgD3fxEjZYPgNPGi1wd4P1ZAGaq7Y1DHk4+bzhwmcsytZGgENVnEYxFWwGu9hDKb8EDnds2E9s1FklDrrE8mM//C1QBH5XC+oYFzRdsF/KFpuGgy/i2GO05nebNO9mpP8Gw=
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

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c         | 33 ++++++++++++++++++++++++++-------
 include/crypto/acompress.h |  1 +
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f..8c9a76073159 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -166,14 +166,20 @@ static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
 
 	state->compl = req->base.complete;
 	state->data = req->base.data;
+	state->unit_size = req->unit_size;
+	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+					  CRYPTO_ACOMP_REQ_DST_VIRT);
+
 	req->base.complete = cplt;
 	req->base.data = req;
+	req->unit_size = 0;
 }
 
 static void acomp_restore_req(struct acomp_req *req)
 {
 	req->base.complete = req->chain.compl;
 	req->base.data = req->chain.data;
+	req->unit_size = req->chain.unit_size;
 }
 
 static void acomp_reqchain_virt(struct acomp_req *req)
@@ -192,9 +198,6 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 {
 	struct acomp_req_chain *state = &req->chain;
 
-	state->flags = req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
-					  CRYPTO_ACOMP_REQ_DST_VIRT);
-
 	if (acomp_request_src_isvirt(req)) {
 		unsigned int slen = req->slen;
 		const u8 *svirt = req->svirt;
@@ -242,6 +245,10 @@ static int acomp_reqchain_finish(struct acomp_req *req, int err)
 {
 	acomp_reqchain_virt(req);
 	acomp_restore_req(req);
+
+	if (req->unit_size)
+		req->dst->length = unlikely(err) ? err : req->dlen;
+
 	return err;
 }
 
@@ -266,10 +273,13 @@ static int acomp_do_req_chain(struct acomp_req *req, bool comp)
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
@@ -279,10 +289,19 @@ int crypto_acomp_compress(struct acomp_req *req)
 {
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
 
-	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
+	if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
 		return -EAGAIN;
+
+	if (likely(req->unit_size && acomp_request_issg(req))) {
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
@@ -294,7 +313,7 @@ int crypto_acomp_decompress(struct acomp_req *req)
 	if (acomp_req_on_stack(req) && acomp_is_async(tfm))
 		return -EAGAIN;
 	if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
-		return crypto_acomp_reqtfm(req)->decompress(req);
+		return tfm->decompress(req);
 	return acomp_do_req_chain(req, false);
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 6462fc46f4ec..fc0665b77a8f 100644
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
2.39.5


