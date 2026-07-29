Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B0E0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52E06B0092; Tue, 28 Jul 2026 23:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD216B0093; Tue, 28 Jul 2026 23:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB8C6B0095; Tue, 28 Jul 2026 23:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82A9B6B0092
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:58:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3C3EC053C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:32 +0000 (UTC)
X-FDA: 85040457264.10.EC72B80
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0BFB1C0003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D91aboCG;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785297511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
	b=4TFpZTT9b7wOiQ3X8oNmaCCYStEHqyz525Up0Ln9uyHTB9mA1z/nMXeAuNRb1GvTxU8XsQ
	alBV8bu3vk4daXnY43tEINPSpplLH3FFUoT14oS1hRRBU7gytNtc3ZaWemN+jo4NhMtf+j
	BpOkcp9n+w8e8BvjfPpaPAgFQojy7+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785297511;
	b=zOSd5OtSQKRjAWlmmljDgR+NyjFR3e0RaNgYwSyn01a81zdO29BWA5/AEn8mxeVuCYK4Fl
	mfXkAFJmfZHLFPNRFk3CSpAzURe2WKgvJwJlEqvZxAtfQmJPrqv/A+joiFfGZhXDQEs1Oc
	s+4TlkWlwyMdJjM/IdlIw9Qt3t83WiQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D91aboCG;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3811f512167so485602a91.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785297510; x=1785902310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
        b=D91aboCGqkDJqBGKUuw7CJawx7Q5YR30jYM/sAhykO/SrAXr1kzw8iRVeABqN+f3Mp
         BZr1IP7sBanOGRpWsJhgMULDN1+0slF7Mp7PES3rLNRLjhKjSbCwUnNTqIl8WaXIjyDs
         oOyVup5bPTIwYUuR2noWB6hRZy+foYvl7xsjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785297510; x=1785902310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QwE/Kwnr9BPCU8EkGjoplXuRnm52TdDRkTVQHOPaAmg=;
        b=oW4mza98/wsP0kQr9f+n3YiFYR8EaAsTKf7vwIk5L+HbDLnWhOfCyY8AuaqVujkxsg
         OBgwpWS8L5Ehr9zRwat0SMsYRfXsKwKITAEX/LLWSJI4ObyPUumBjPJ5tTYMZ3s5Whvv
         glPW9QBWUBAhwGVnXvh4WTNyvDS4TDmsKhlDVe88fCV+V3uvTN4XJ3XRXhIB+rfyi51f
         NBT/mhaYrnAO2O96unn4L25CvJYxfRZyguvaUY8twQXEpXESRMB++WXVWF22BQfLiToB
         pF8VfvSlsKFx6WcnAyvm/HzpUFKdHpjfuuMQkSK5l2UH42CH3kAuIX+SGtDS7SMQW9oE
         0WoA==
X-Forwarded-Encrypted: i=1; AHgh+RpQ1PILZLljw+/InNw2XyrVmYqZPWxxdU8l7sMWt0aeg1bkKOhB0JuwMRYbPP5N/mW979cHVaFwjg==@kvack.org
X-Gm-Message-State: AOJu0YxDUS6wGX1IpcMihYzWtU03OGcoG5ebby1V1iXlj/Nyr7YmgP24
	FCtbdxqbz5bZSD1Kd0ko4Lqso+QJcKvziB6/YnUTMPhx/pTqD94MSw+uoTnbX7UU1w==
X-Gm-Gg: AR+sD13mRJO3svV8QLE4EPY0l3KMZ45afYwQ1PfeNX1OFOBTTcNDRwj/CRQlvD8TroW
	zy58T3oOwykwQyVkDK91LF1I6RL1MmDu49JqgeBdbBk8K1/PELCP4ey6A4pOz8ci1we5RGWj4yK
	LFHLgHc8M/S9H9iZY4FEApsFmLHrR+CnpNB+tgzfFVnDvzrvXJH1n9XO0qx+pTF2U2H98mHNyaV
	Tzk0H3OTbKv/WRhrh5p5aD+ylR90UVOuMoR6OM3JJkfek6aKN7xMfwa+zdJq8fcM4WIuKxjU11O
	PmU4KTUDhP2P6ae13s65b/HQ4vrsYTsUSNMvziWW8Z6NsUlXEx059Bb54Xy3GOwKOUcYxGy/Fu4
	pGRZbEVbnsr3/0XArbhzpqfg4OLfjut7KgDHqww4YHIFVXcJ0+2MQbNiLieAbaen8rcTlynxPy1
	LWP6XbRB7QgSVfDhUIx3izRArwcp90y1rIauNVCdY/acOG0Vreb7PxqvMaiXsXpmhTYs7fJcRs6
	awy2AT/B1DOaUDgGvMUEq28b03oKZZxVKDvm/RL/+4kSLj9xeI=
X-Received: by 2002:a17:90b:3f4c:b0:381:a766:efcb with SMTP id 98e67ed59e1d1-38f6a308675mr5557087a91.4.1785297509963;
        Tue, 28 Jul 2026 20:58:29 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f7eef9c5asm722087a91.0.2026.07.28.20.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 20:58:29 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] zram: set default primary compressor in zram_destroy_comps()
Date: Wed, 29 Jul 2026 12:50:32 +0900
Message-ID: <20260729035820.751990-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729035820.751990-1-senozhatsky@chromium.org>
References: <20260729035820.751990-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BFB1C0003
X-Stat-Signature: u3mk5gaxjkxk73hizqe6x73q1z8gcnxq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785297510-208585
X-HE-Meta: U2FsdGVkX1+j9DMXla+Hdm618QhfEVx+Mpdxc0TAVFxURSFCXgmGTalSmMc8uPbyNTHWrogIG9oudhSE5DELDZYl/QXUEk9z3JPCo1IB+oWLLai8F0ywdkh0EMPqy2RSfI7K6jGM4Rix7DMIBsMS0h/ALvK4UBCYIzpm1mdkdn4rzCLVCVvndbaxywb9YOpzrRYl/DdJK3pTbDmiuV5ThomF1C1zd192uX+0+5IQ0JSAI5fAj3EAw/th7nh9tkLudu2Efg1oO9H4v8gKbpq8Ma/r+ENY9PUaac1ddmeXx5i7tY7HAeGRWJpqBfu8oYVJTM6tDA6EJ3EMtFbeoeiHUzypF8eK7h/y5ghzNltc6Hr09CD8jSNDxFsDdsZo/EGMHNdKsAs3/XqijRkyu6WqNIdSfmtT8lKwaHKfUBaa39wscSA9fPFuwZxgSTlC6X71/Je8u8DYnMs8oLsKvKYj8sDXuCZHFKcDVjb3ImA2Lwiy73IFMw729bki8A6YJnhwMQvIB5daQK8UXqCVx09bEgbrsWPceyEjBOgnAU4wMjyG+xVn3Tnz9Jt3H+Ocp/B1NpOzQGikPqT5bC3kZZoRwGNnuqmvTxnWroZKhCYOpSkl1mPOQN3FMCO2iPCEwhnMw7NHiOLxvuz/XdX/g+NQhT78eh+iyPDfp1guSoezMdTrsaxu+JDSP/I/uRN8FDoya96X5/Zzs2ntL03vm5B9I3KO8eOP7MJ7KogD2zppEoykt734PW4/7jL+OX5JlhM+XgFZNbF25cSxrEiyV69deeMZBzpEHnEBVO0viIxuZz7KRbneODo+rd3bRovgkhlwrJXmCRBT/NE9mM6ykAJrrUhTXm7j/kIs4lqC5eoLntm8QWZuBE39f63Unp8i4p/uK2hLmbW+/soVMZBnyDwEl3q8dgbqZyKbFZVG17eLj7kxt+YDpPPQL3gipftDKxYrHtSDxfMCogZQFfGR/9v
 xAkEnhg4
 SDi16mCZ2ekG6hSi9mjrfBO3IJT3WzPq650KyQZ4EdXPaThsQpVMTMemtMbIKqI3eV0HXzE8OXIssXGjtwPxGtxq/lKC1XHH8z0zAMRDP3QrYBvmUDN15hlFBWeOD6xVDB7vGaPZvMXFgUepnX0VNpMq79G7pRpgAXx6El5e2PiyFNzSvakNMV33rERUtaLJsxyb/8GJvHG/wZX/ZWbfDnZisgEjydr0Iz/PuRvuBWTNZeEmuPn3+IvB0sVAnws38yUOgO3cGwaVPrXPZ5pup5QoMxL9VW1s31tNGl79s89a5XdzzkMo7YI9tdtESQICKfl/HWtR1fDugdFAJwiSvyTE47vv2v7tGJKWGksNg6GruZ25YHqTi31Pf4MXicg8P6OdrRe93+y0gglTA1JFACS3vY4h/L74FVJeJuyxAGfniu7wfpL9zxuGnncEXkHeYZsfbTFPPQmzxdmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram_destroy_comps() resets all compressors and leaves them
set to NULL, including the primary one, which is invalid
device state, as now comp_algorithm_show()->strcmp() can
be called on a NULL compressor.  Set default primary
compressor in zram_destroy_comps().

Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ace65c586072..ebe2da955182 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2836,6 +2836,7 @@ static void zram_destroy_comps(struct zram *zram)
 		zram->comp_algs[prio] = NULL;
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2853,8 +2854,6 @@ static void zram_reset_device(struct zram *zram)
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
-- 
2.55.0.508.g3f0d502094-goog


