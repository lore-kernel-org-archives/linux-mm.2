Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E8A606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=jEwmwUuL
Received: by kanga.kvack.org (Postfix)
	id 8E5156B05B5; Wed,  4 Nov 2026 23:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8964B6B05B6; Wed,  4 Nov 2026 23:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9B16B05BD; Wed,  4 Nov 2026 23:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51B756B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF7291208EA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:05 +0000 (UTC)
X-FDA: 85399833330.09.361FACE
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id E82D7160002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jEwmwUuL;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RktNgHUwlwtWmAgMABeK3FK5t5bFNo0JMMWVYG0t8s=;
	b=3ExpD2fOaP9UgCC3OXeRZxYkLrFaZilkDIc0078NJUylQTvukKUq+kSAoNJ1PLdM3RXaHx
	ftD9TDlgb1ZoCF4BBETZaQ0ITeirdqUWNlsHpHy9gVQzi2/qP159E+7oT6GVqjrEletgZK
	BZXqnQ1ZrK7mQOmQX6p65MWe9ks0s6M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854084;
	b=o6XWCm2LonafyBqro1kF8pSjanCxuhDtuO9Jw4lukdctwEvHQ4N20v37BInOJKPOXmUyFV
	n8K/FmRY7+WSxGjiCEdbxD9dnxWpWBRK1UwXatpKFIxx1q9xLxBkTWHMx6Hac0QMx56qey
	JqSlbjKnfBGzdo66vGZqqc5xwPLwNoE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jEwmwUuL;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1a2af4c8d00so3267668c88.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854083; x=1794458883; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RktNgHUwlwtWmAgMABeK3FK5t5bFNo0JMMWVYG0t8s=;
        b=jEwmwUuLEDXiVNygW9kI4AB7moI5b5gvuoFZFV+kEP+Du8lechPEe/MXEOVUfwIhkk
         Bc8JypPis1d747XScu6ta7xjMsYmAoBg7V+vlEwErpZ2z8+y6RdTVZpdEAA0k/8teQfy
         e/M8F4PoZUrhidTAaJh+0pQUtcBvOdlsF6cXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854083; x=1794458883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7RktNgHUwlwtWmAgMABeK3FK5t5bFNo0JMMWVYG0t8s=;
        b=r1fzccN5ktzqnsJvgSE7CLLHPusQFpux4GWZIRs+LxY33is9Ou8WxNndG+LN+Q5aH4
         YsiPe0zxmcrrqvhRcF+cKPMmfJID62AhY+EP42Zj8053XuGvtveb68ZcyR/xDjp6/o6p
         ExbgmQPyw7oZ7QWFIXFHW4MERzooh4Rr5Rfzcfnf6MZeDxVK9Fxs9EUvUPxK+s3hWx1Q
         aHtTsRFD/ulnj2IZcR/F31FUz9ZcfWPCP/xie+um/+izVNUCKEV7Tb4N9KWAAwq5S0DO
         e0hU4TsJjt0tEae6iONzQnrauqRlZ5iF60bSprh/Y54vUgwnsiiIX0k9NpVWb7AG8VVY
         J37A==
X-Forwarded-Encrypted: i=1; AKwUvByAgvQo/c/dP1ekj/qsVIa3SFsnYYvxOVuL7DenB4VGbVPXwe6IstZD5aXS86NgyYiZFXEpPEgQlA==@kvack.org
X-Gm-Message-State: APuU4Z9xFHbtsETq260Tmbi+ZcHKlZmTVed6YJC2j1Ju7uZWYwE7fsuJ
	qTIXtl31XlXy0u9pepcPhtjSSkG+IepFVtxBwXaoSSm+q79WaNRBDj5UpT4s25GQEA==
X-Gm-Gg: AYBFou23+mbThvi9mKtHOgena9sdyUEvqaq48phEyNc8yXu9CNl3hN193+8ZkJLeLSP
	d/2A8mc7wvLJMjfTqTIq6LmsirpZ27Y+M7btkGPVnNPmeerpR7wQYEkJvnEnyepKV7/v7XO0453
	XVWzZLcby2kvWI3XJLSitqyVkwG1eFkq1EgcsdJMZF86fSzwFyVe6zcu3wDJq+ap41mRnHsZcyZ
	P8OJ+gJFw7DOPFkPtNI2EpsgqNP4WQnKMq1wzcoFGpG4m0H5lI/Q+bAOiCmcawTOT/MlAwJVbf0
	eghCLrHb8U5UzD373POuMKTCeAPk+g4zXHbfa0x8/N7K3PpaduqkK1iSxW3B1aMpLmzwyMVv4lF
	KlZ6AuvLgyNEcnsyhy/lKXo0AueQ+fCnYe1+SBG+TgQSfusUQrP4310ZPlnlaH1n+wkfg99rmOn
	m0/NZQSbbWhBS8ReQb8+VEnfru37sR2KOQI7lxCHns/k/3yTDw5TMWzelpAl85Z3pxkEeynmi6Q
	mRFzIPgzwn12sitNlIb5seUgLo1dFMKS6An+RQjPhxARCYy0rYXEJyBtXkuvdXbC/ILbkjq/kEd
	lJ9Xfg3JXrnNrqoBpOhAJkqkGtgXJbo6rxDfIfoSRyL1V5WXyqmDEHqL7ycsLlHurd42LvBFovj
	Stv2Tbsq6LH6RlZ05PWA=
X-Received: by 2002:a05:7022:170c:b0:1b0:166c:6a94 with SMTP id a92af1059eb24-1b0166c6be4mr17748555c88.28.1793854082667;
        Wed, 04 Nov 2026 20:48:02 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:02 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/7] zram: drop stale comment in write_incompressible_page()
Date: Thu,  5 Nov 2026 13:47:31 +0900
Message-ID: <20261105044752.1997895-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: biz9a5ianxc1crcsodpw9s8mrbdyatxp
X-Rspamd-Queue-Id: E82D7160002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854083-174756
X-HE-Meta: U2FsdGVkX1/veSJEnaJZ2laPXLqb1fG7xCwyXEWnnPVsIRmQ21IEByzSx9ET4G28voHG9x1mah0AB6MrKL9ko4xER9sPwbPGhGPH5hh4l0Dw2KISg9DsSXYgNGHcqJRaTYSn4BcH2CPN13YmtEFp0Z2EboLI9SSySAPYVlOFzEVxarpWtYWFemyAOyoj6Q+qZoEnuNZuj71iqr9Rd/BON+OekHva8Y5lMESlkDcEUDcv2T7S5gueQeVjvoiYR55dh0nrQg//fY6n6v2IdQDTlY1vOyY8d8XVUW38ALyeJ3zBPMLWisYvMAelarObmVdzpUR6hi1eLDnJDissNGGX2QTyJOxxfbtC1hvm7mrw7jx0kqAVUgXDApCScFpIKJ+ACEO4Lzjb8vWkwiyXIzXkESOmc8AjksgwqCobWB/RW7FT8Iq3SdfitLVEgt3G+Mmg66bi2+1Wn6gLvYbYr3mGMjbsDxFzoILGInvSx6b/azdHOr75QF5U5WLxywqELpHo/dOSAJS4CLhkc4bWWT638ZJ+Vd9oDZMCaaUz2NC67Wc1r3ou48JF6jtM9Ye2ipTFHX83IYI8IrJHSw+RL4P6xs5U0xql8sf+dEijArxvy1jcXycWHpnlXwXD26OV5HtnwH1VGlj9Oh/f+zrkMZu64vsaBPvljYFEtJNguncT/iP5Wcf/9ocNZO0xGbVFYAoe7DcOqmOTPLo9AeChnQABKIQbm8GiIHH4cnTo4IgIviIIkoEr+XdIbb7JoOnCXOB0OUD4BNYO9PHI6X9nMWTGj0AtVs7R8Z5F3uW6395UBzL1rhCxQdYtHjWoEwN+gNEgZ/ivoai2nxG0ot3OqPxCQdsNIYx36NUFpvdAwpxeGgKcq7gPbLC2/dLN/rDFgcF0YyBaxhxrDokbqowMKRk2FEOLuG/i0T1TXCuoa5Eni+ix+vJTggt2eY54DrJ4oO1/fzPpDhcjWJgOt2/8j8x
 wLl4cYcb
 jp9o7aD/jZkXZ7iPQBQ/hzWgyXtVtKBwO+xBwU3flBH6ZzcHJ4LlttPddmAm7hvdMMwqb1AXMEjm5AGMMsX7Nna/roBZeyIdNLlJnLdleacOt2SGhx7ec0Rw4y0hJe7yM2407C9E54AXgfUEcL8o08rk9fOcYUvaX3xwA331kcRcSeZbwjz+nI/e3Gn4hAXUBdxPd3J/1tGtJ11zSXTdkRDpaqWI9RO9pjxA3ZHqz6D5+5M7fAP1NRjuNaGoPhZC6egbyHUkKwfRlL8iFNQSU7Gs45SBJeZ6YdCq+0dFV5oFjPzGLPFIJgt/Cn+GG8cluuaopxhqpZuhoS/YPjbWyvnSe36z/BX+9+Qqy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram doesn't do fast/slow-path handle allocation anymore, so
the comment in write_incompressible_page() is stale.  Drop it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 632045b65bdb..380615b73446 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2271,11 +2271,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src;
 
-	/*
-	 * This function is called from preemptible context so we don't need
-	 * to do optimistic and fallback to pessimistic handle allocation,
-	 * like we do for compressible pages.
-	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-- 
2.56.0.398.g882cbad275-goog


