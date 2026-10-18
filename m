Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE40ECCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02546B0095; Sat, 17 Oct 2026 23:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C026B0096; Sat, 17 Oct 2026 23:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9386B0098; Sat, 17 Oct 2026 23:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 133426B0095
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:51:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 420F9C037C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:52 +0000 (UTC)
X-FDA: 85334373264.08.8E4B8A7
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E26F140003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AKWx4WuC;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
	b=8AJw1Pu3a8E7oTTaNnvE+xkm95wMziauDMlNs8ZbVZKfv8gAbuPSfnlA4JQEruErDT3Lbx
	HXrJE4gP/CQg5H8eTNGAx5UvfA0XWZ/1msjefP3Owel2fk/iUohZFn/W7iVZiDeQUJckU4
	cljCO9Z7MPnMZjmavSogwZqNIhsKRRw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295510;
	b=OSAgcyQJCK/8ZjwWsBmnEM6GXlAeZsmQ44lfmB54Y8RLGuRK6U/lfdzHvVzHwEGHWSZsLT
	iEpjI8ke2y2b1o7f7E9u6G4/n8JfVik5+CRyXCJ4W9dmAtKDOo6K9ZJIoKSbNQvlIyBi5G
	bzNUxB4UmDDnMIybtlhKjYE9FXS7A8s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=AKWx4WuC;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ace9e6e1a5so763210a91.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295509; x=1792900309; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
        b=AKWx4WuCiP2gigqFMSpJXWfbejqURSGEX21YpjyQjxq/jaePkp0JlVY/gemqaihpBA
         Wy0JQGUaXl6B6Ai2B9BWMtA2T8gsgynxvj9v8gaQAdIJvrje/iY+ZOrXBqJG/smwcYA+
         vtPDuw1oJ6pQ21O18tOCirvo/5pQNKvxJjzsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295509; x=1792900309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XtS1/0M01UFrLXwpgPFi8UFASC0cpcznpCMgk29ij1I=;
        b=Yp74j6cWsr1oOPijxBswvPjovWdsh8BuFKejwBVhrN9A/E2ZVGkKgc2n3D9ZT5nG68
         L0VFZ/2fbGgrzIcp9gyHb7N611VrrpVAUASrgJtsrjRmlIfx8pAKmqUFQ5AvwxxlN4mj
         ZgcUj2L98Suj8PQj3ufI957xp1Cay5D5B2v1E7wV5b6D3Uf1RTmmXWg0WC9+hfPdPHw7
         dFH7PNg7yugM6VyVRgWryrXKCzkm+8SyMp4VcrXvIcvFTi5Myy0kN+kB3seDCQRLGfvB
         7MuUA8lLlLol2R2lnGgYOJ+MYS3U9mrxanT2B+zJSSQjqa5G//iUDNtde3of86ORZ60P
         PwwA==
X-Forwarded-Encrypted: i=1; AKwUvBxWcJYZ+Mw8at0p5FoIn82NH85FJetzkNz+JNxiIuAauVby+rlyqgyFrya6TecYDWylCSX6/XcaZA==@kvack.org
X-Gm-Message-State: AFq9FYLWT8rua59+1dkK3Q0A/vtoMVLySO/N7jPcgADBXL9CNxv+Tvoj
	ZrMKmrsVv7G/HHYrOO1i1L8IniC2aXvRh8KvnJfARj+kksPaceb39nNjrJF4oN6oWA==
X-Gm-Gg: AYBFou08moONQcMgkCrMQJ4K8B87/3U5wtOwF+eljDQnSg2ncjgTiOn0cSOy6io/Uya
	Y1sTbI5Fi4vS9/aUkVbtNuetvtlTAqRiIl3kzrooIDp68QhdMjj43+wn0MBEY76zjocysPSPqDk
	NmIZDYuO5yPjOgSdd+EjXzgBYmzG980PV7iuk0LXntm8/NjSRzS58CFqJv7Oue4X9ThtaxkqC24
	w/8Q8KRRiIvQp2ap3W5pKqTgqk2kMKm04XCIIvtkif6zD3VtWOMJf9qpd4pyG+U3+3weRdjqmGx
	2tNtD/bJf9JM/qzntSHxzoZPH1LQ5ufe1r+oHrwoVSBkIQFCOfAws0bxhTcTJ5Y4VuvENQjING0
	DaD7vnRcgUhjxEhSyM8ixCYwcGTIfaqmP3FAl+YncpVL0itntJeaqRp2O3YvFK3ujCvoqQcKbxC
	gHYDoafaHWWMPDbuhv4698fE50Cst21odVeClW/LdcopC2giF30ulms0F+QX7OQMa6TnZhikH13
	NJLdjFj2x36u7E5dbSTu7P8u9/8c+UEGY8yYQ4GV98yUgORatDpMz9SprIvmcw=
X-Received: by 2002:a17:90b:4406:b0:3a0:295e:6e61 with SMTP id 98e67ed59e1d1-3aceefbf3c8mr2482928a91.12.1792295509334;
        Sat, 17 Oct 2026 20:51:49 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:47 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v5 04/13] zram: lz4hc: pre-initialize dictionary stream in setup_params
Date: Sun, 18 Oct 2026 12:51:06 +0900
Message-ID: <20261018035125.3120704-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xpdrh54huu3kq955iwe398hy6mcodnx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E26F140003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792295510-164957
X-HE-Meta: U2FsdGVkX1/WUWOc0/1e49HuPDSM4rW33sxzghbte2yFO+F1l3vK3wxVd2HMqxj6kvduwXyt12v8j/rwF8mmYVkvn8/BXCiJ8oFAb8Ny7kkmX2/8bJ386whJ5MJuWfNwF14cXxRFVXo0JbGyRogXV05gpqgYyXvgR2BY/xQkH5Kod1Po54MXfQ3OY35Ig6U9eC5wvwsKCCtqTEcA2n7fQRlxOB7r/NJ7NSCHKaaIOEy+NSJhx+hbC/9lx2sRNgPtx70N3VwNa0AVEFfJY1fUbKnBKsZKiuRRRNrnfWXRUp6sfK4gjtDIgB0pYmXr4/nD+95i5CIlv7nxvvjLoKvlWLz3fDsUyNJSO1TTHT+1iFW4GZ9C5riqrfe+whLryQp9fbtyhj2cQY/uCwVCY/B6/F3wg82uw/LwRMuEEIbSocoqiXvHlyHTFr5AxXEN7e6JXSKw7EgGQMTAAZL47yZumomZrYCX7ZbzajfjUwUhS4YPVRaqu6Y9idPlpPp8PJQXXguFfYx8S0INGkYuIsMTpIGFvSf7kIOJ0Ka5rjYZ9qJhUUew+VHmZXb1xcCVUHMIc4WGaAB3UI9OrH9jufeY71JxOpTLDskDcbmXQvjKOjbE2rkahUn+Q3XeIOgNa5kV9kpQKXz84oDi+HxZoMnJAGOmU0uX19rq/X9F2+lNEtCxLDEzznEqemAjPHNjXnYux+qdOxIqxD8cWm3UkoivE2Ii6y8XVUR/oRfjuaGVu1BmQX/4zdHLz1jPRcnIcCmRkNK5CWwEMI1pnNEK+CAg9ycL21nTCjgyzujlU1It+Y0YViL/A3ffuD4t2K0yJn2OsUY2MpgJwhIObIudE3rFSmJAmUH7jTdqV0bc30ZIg9MPyiRtQug61WWuenESIQTI2cPeZNCgEJSQGKYR2dN574Y87yNnLW0IQpJ66dBbl5Yv3Hb0k+92OW+T3sD3lZue0cOeode2LowA48Xicwe
 fZggJBP/
 shY291hcXiqC951NS3zjL9LOfEQ05f7OiqwnFrzniKv1PLOfnTwipTfC75fFTREdGjhWb0DS7WOT1KRgJ4iL6usj0y52xhae+0S8A3bNmzzoiqr26VnEgXnGdGiV12x3cftBksIqbqnQqOFGEQEeZGOyhJ8O1bJosHNJq4xD4fSop/7Td5FNT6w1zlMWCxi50zNJjVOlWDILu+Pp8tJSG0kY4VYc98hcwGFJ8D4Ve3GQJx35PNj0QHkNrNnh5E92KyYuBDbK98aisIn12GrD0NBeCvO1ttMZIOxmy49YDR3nQ0Fy7jjqNBI2lgwWLTXEz1J8fevwjoAxxnxZTFWxvdicdGtvdjlZ3Ypf+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pre-initialize the dictionary stream once in lz4hc_setup_params(), store
it in params->drv_data, and memcpy() it into the per-CPU stream before
LZ4_compress_HC_continue(), matching backend_lz4.  This avoids resetting
and hashing the dictionary on every page compression.

This also rejects dictionaries larger than 64 KB at device init time
(matching backend_lz4), instead of failing every page compression with
-EINVAL.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_lz4hc.c | 31 +++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/backend_lz4hc.c b/drivers/block/zram/backend_lz4hc.c
index 5c009835a684..f3656c27af21 100644
--- a/drivers/block/zram/backend_lz4hc.c
+++ b/drivers/block/zram/backend_lz4hc.c
@@ -18,10 +18,20 @@ struct lz4hc_ctx {
 
 static void lz4hc_release_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream = params->drv_data;
+
+	params->drv_data = NULL;
+	if (!dict_stream)
+		return;
+
+	vfree(dict_stream);
 }
 
 static int lz4hc_setup_params(struct zcomp_params *params)
 {
+	LZ4_streamHC_t *dict_stream;
+	int ret;
+
 	if (params->level == ZCOMP_PARAM_NOT_SET) {
 		params->level = LZ4HC_DEFAULT_CLEVEL;
 	} else if (params->level < 1 || params->level > LZ4HC_MAX_CLEVEL) {
@@ -35,6 +45,21 @@ static int lz4hc_setup_params(struct zcomp_params *params)
 		return -EINVAL;
 	}
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
+	dict_stream = vzalloc(sizeof(*dict_stream));
+	if (!dict_stream)
+		return -ENOMEM;
+
+	LZ4_resetStreamHC(dict_stream, params->level);
+	ret = LZ4_loadDictHC(dict_stream, params->dict, params->dict_sz);
+	if (ret != params->dict_sz) {
+		vfree(dict_stream);
+		return -EINVAL;
+	}
+	params->drv_data = dict_stream;
+
 	return 0;
 }
 
@@ -93,11 +118,7 @@ static int lz4hc_compress(struct zcomp_params *params, struct zcomp_ctx *ctx,
 				      zctx->mem);
 	} else {
 		/* Cstrm needs to be reset */
-		LZ4_resetStreamHC(zctx->cstrm, params->level);
-		ret = LZ4_loadDictHC(zctx->cstrm, params->dict,
-				     params->dict_sz);
-		if (ret != params->dict_sz)
-			return -EINVAL;
+		memcpy(zctx->cstrm, params->drv_data, sizeof(*zctx->cstrm));
 		ret = LZ4_compress_HC_continue(zctx->cstrm, req->src, req->dst,
 					       req->src_len, req->dst_len);
 	}
-- 
2.56.0.176.g3575e65682-goog


