Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B152BCF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956F36B0096; Mon, 12 Jan 2026 14:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE2C6B0098; Mon, 12 Jan 2026 14:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706086B0099; Mon, 12 Jan 2026 14:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62A096B0096
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1128BD1A5D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:53 +0000 (UTC)
X-FDA: 84324299346.05.B4AF2F5
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1FCF840009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7SUdzuD;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQS0SzXkMyBsX0r/DMnRoitwZR/NjZ11xjjJpvDZxFQ=;
	b=BT/S6s6sSuhAPpm1WMeSifRTLQHxNu8hplfJTeqDtAcuNUQpqmdBS9Ud4QdKUeGkqhMkNX
	x/f+FaNpJnslo/MWhAJx9KTia/bBidGZxAplZIeqk8sW5nX4tpqQmvTcp1MfW/2M8PbMam
	90K5gtefEIgxS3w0LOJ5fDBf+8mExXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E7SUdzuD;
	spf=pass (imf04.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246131; a=rsa-sha256;
	cv=none;
	b=8dxdKzt0JEevekXYPZ0OPtptO3WhIEpkDkFmUlY1RMI5bF0YApf/3ygVAnY7d9q8KtiBHR
	joLFgTaPZyF76o4yDbsBVhRcfdgt85eeGeuh8uS8KFoOEgsd6i2pGy7w68mbfE7Omq/dJr
	VypHAI7w9XMJuYjP59LwqLIzQMOrFUM=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6503b561daeso10804082a12.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246130; x=1768850930; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQS0SzXkMyBsX0r/DMnRoitwZR/NjZ11xjjJpvDZxFQ=;
        b=E7SUdzuDMTYesg5JObG4GrtRm5L9X/rgRWePmtBCnyAQpTtB+gVTz8fyMuTJPEwAtZ
         Nbz68gfUQErcWy82kAWnjue4XfB5WwwD/VZ6tV0Lo/JFJlFVDzqyWzgvSH0UcaI/3X4q
         Tbuvdgna5Epdo/4ssMjKW2GWAqDn6ekwLe7YP4yMB7+mRFr/8Poy8vACF4vJVVzmEugL
         BfvvWiGteu+y6tfUBZEy1jLA6Zvka9qGShVJHc8I8DgvVar5woXVPGikD4/bStoOcBWr
         cb00CgBTVxHaEvi4gtZW+JkMwqTeddiFxzhVc3ma2ypCsiTwd8iZ+WBq7YYFoSoHULiJ
         Mmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246130; x=1768850930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sQS0SzXkMyBsX0r/DMnRoitwZR/NjZ11xjjJpvDZxFQ=;
        b=klDp2P3ukGxd/8nAeZlpuVZal2J5uqajxmNvUNqv0IBjx2Gy0E/dWxu+qnuPpPzajH
         9Vo5zsPlqCV/TVpS6g3o78pnF/Pr/98GSHKFMLVwvI+Ka0MhXR1sVRQoG75Oh2MDOPL6
         u9Yi0+RTQ4YEYTeH17YNqWOYgbPOhX4xO2FiQNzZL+MIMkEopmieS2icrwxP8MvE5c+I
         e84LT4Pxdh55gRZyJhNgqIs0qVEG0OPBIWFvAzVbgXdL+WxtN+MEHmid/lry/ygnJLQr
         6tNSeU7Rnw2PVWI9Ja1MUO2fp7Q1tHTKN72jIk2kvE+YoWRBDJ0yhdbSmB2GEgLd86qT
         AvAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtJ8Ptba6w/tquDVKbEGfFotKArF3bQJxIkONbFi5JGmPqT1sIke1nlQgRYrUqsAWDYpIy1iiWkg==@kvack.org
X-Gm-Message-State: AOJu0YzOsDf6ScC0aUC/xM/Cgi9Sj6Ixg4aD8S1sOs5WynMAj2mkLyWs
	b5Zd1L2IpTphfNfGGv9BNzys/VAV0F5YNNe8GGWEFIkD0pWnsA21WegM
X-Gm-Gg: AY/fxX5uYDPeXoE/OV3uFmw/SG8F65LWEqGTPwessl6ieXqNfgvhAi2iEdCcn4DhLmB
	E3l29tLDmTcX3BwXRZo/EsrC1+0wPINfBgqBjoVpP7038thXeKKYA9wzT/PcCDn1lyILzBAQN/8
	lILJVt+UmBqpHfi2gZgSvb3Q0NJpmZCTxpT9ONfJG+K2kAjmvNb9j9K0+3G2qy2FnG8gDtRNtHy
	qHiFN98SosotgP97tB30T9epWiqQLWYBfthjQUxKIOlkfVTBXCDtVpvTFI8n+IIJERUQCrNKWK0
	IcQrqu5C8aAN7lyYi46vR/jBNENZntI2IiInfTCeJ1hw62XQAkDsveGR3/0f7nFqeoEpNq7KCss
	3iRJ13wyt6I6HnePrLPbKy13ofE9PjWXp0bpBmAh0qISwO3U7GFeDJAU+cI+bssykt5XU/yr/tN
	/wRxrtBnIvilwKkgoG4j2a2NctLXJk+seWzKGbwNSJWCUVrhx+bg==
X-Google-Smtp-Source: AGHT+IFk8wLMtvnspL5X08nCOFuh4w793sCkSNYw871Bcc2rMNI5daxewGVPY4N9IKJlOxERKRgH1g==
X-Received: by 2002:a05:6402:280f:b0:64b:3e03:63b with SMTP id 4fb4d7f45d1cf-65097e8c00fmr14927123a12.31.1768246129525;
        Mon, 12 Jan 2026 11:28:49 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:49 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 6/6] MAINTAINERS: add maintainer information for KFuzzTest
Date: Mon, 12 Jan 2026 20:28:27 +0100
Message-ID: <20260112192827.25989-7-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fgornxudinei39ddoprzia1c9wn4zck9
X-Rspamd-Queue-Id: 1FCF840009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768246130-796520
X-HE-Meta: U2FsdGVkX1/J9TNyNQTRTZgJ4LdJih2u/jPqo0ASSST75XyOMwnYQcWIOxGaTtmX9GU91LHKyPAHRwpoDXkIdsi9w8nef9JXz6oPyQicWdZVL1ovxm+i2ej2CAcwzd/JPmDlIrzZaImbJus49ToI4DviFjxAl94BDKIosK9y5CJZVrbhIqyWKbvV/6jnkUqOviICbawn5Z5xzKedAg/GkW5jFs3XCWEA2DG+vzZlA8kkOrRhZatRxG9/YJmIkeSv1how0Ekr3OXTWW06KqoCuVy3GVa6QKFE/PLIc5xahgc9fayKWxgmUZbiHDDkab93B6CUEVINPyF3vZc/7b8wpglW7TaHZc6tOBeW2e0ip9xq5WghNccjAF7935p97wQYG6GH70t34gD2OCqr+QPw+ejLxPUnKJSEcu70NLdckYPocySvWmFf2uCZ1zOqUSbjJJ3yMLekVIFrd7gl3wrmoYMM2SiW2oQyHdIXIszcVgja5Nq+fcENeHuJP3CkJ8oDjRmp5H7r1sHVgWc7DJcgu7tcJTMi8/bm697YuLhNjBYIiFJcMpzentwk7du2HVOFGiOwA+NRGR55VrV3o/27XIyH3kMaw3madWbkDP0GUdWo/yCBekCeFxYXMeleDgco+bsCHihGWgynAO3U0pD+ZQ1dEwZiOhUgu2GCFBNW8/a6u41BUVJQU40cX0EMkJuEIPIbtCvFUvyfhjtaSjXmYlu+YNDMBCHCwcwGDm8Ld6a2M0HaAr/IMjTWVlULdIrs7q9IubjmRbabBDjXGHMTaMZj80APg2Xn0aczeAk5l6pfGro4ufB7+rmPLsc7CdiEKdW+2HsiK8hBPllX92ZAZQnN41b3WKDSPTMJixDN+mUyMzSNMTUhEK2EBZuiw/nSmCcjj1vt2cwiagGJeh4gUTnBVNLC2jIpZCNZj8cUbpUWK8ogNUWxV9re68IVSiAtjEX+1ySNVGl6wAASbXk
 vroi1mML
 F4LIGjcnD8lEp2J+vEhgMAqHUXXfG1fNMJxRCjYgtdL49VwZJayvPIvuMVqtax/Mp3XPbvB9NYTV64s6GTH6Vxpa7cAGrvDeg3cD7UHFp0RwRexVUp6ziUA4j/iLC01qVHSLA4fK0W65Zm1WmfpaBG15ghZd9d8duSGxicP1Er15PuNkXLzL8XQFlokx1r+eByNvzIoDgfCRWqF6CjIvZnuXNkg1IsllTPVUpUU6rP6Olg+OQ0EJfDst16xG20+Iws3N9CjjLInCVaz44sCccDmcTgVqtLkfIo2C9wcWNktUbnOOt6xU0Jb5tk6bz4DJqpof6E9eIXH0WOMlWOy6MISPwuH512aZgycxwQ2dehoDCwTFiSOYMnRWnGBEqzia9WDdo9yVLLhXAXBCW9NsCa9NjcCZvYOmn0UqaSSTlk15UTQVenCNLBWu+raLI87uEd6spAR0liNLtMcSpLiykU46MQhZX/snjVzG6JnYWscPcMmX3k2y1ZuLJtGX8C81OSxYBm/kuHuMQ+v4pzHFeIi07CJX11QULCkaflStI+xD375NF5Nwl+yEnSwfUXm8391vLxsDBbfN6oxPeex50DzMc+2s4+vGwGKqw8ij3FVqBjukAAtMy+KvPPdlm2o7uM050/6S622VlM8QoOQIkhxOnzoYxn6nUpj2VWyyhEifWsuqU2zmwW35jS40r6hJtsOZEmCxHB9pDTC4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.

Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Acked-by: Alexander Potapenko <glider@google.com>

---
PR v4:
- Remove reference to the kfuzztest-bridge tool that has been removed
PR v3:
- Update MAINTAINERS to reflect the correct location of kfuzztest-bridge
  under tools/testing as pointed out by SeongJae Park.
---
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..0119816d038d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,13 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0


