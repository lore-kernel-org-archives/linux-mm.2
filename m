Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E51CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28E16B0093; Sat, 17 Oct 2026 23:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA126B0095; Sat, 17 Oct 2026 23:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFFE6B0096; Sat, 17 Oct 2026 23:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 416286B0093
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:51:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AD62C037C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:47 +0000 (UTC)
X-FDA: 85334373054.29.F183657
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id B336320003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:51:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UcisSji1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295505;
	b=AQpLOgW/WBLR2aJ33G6rDcQKg9Oc6fZT5dhXGXU7k9+xqwVOwJin8BRnUMZPqF7oxuAtIi
	QgqLzFsISuP4eKeYJ1t82dfQN4LEco/dLVBUr5fY8wqBZUi2VwBSlCrLFp4DtanxKad9nr
	B9U9A7iCKyAwEdE+44BTRyGT1bwLELQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UcisSji1;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf31.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
	b=ZjN26ItYYfM7jW1GlqqRVejTPlt3CCs+4uSvzEHIRP5dq2uP5FO1u6BJYHmsrRJ8dHJNsc
	GkyF47Pqc2mgVdF5LcJuajIkRYiBwChrrDw35ixEEYLyLkFKGA9bsBw7TwyilqUT78I1R+
	NWG54WdsLsIUWDCXD5mFUr1asJldSUM=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso656702a91.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295504; x=1792900304; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
        b=UcisSji1zmXRU4cOz1crY9SWUEcrqrHQORffqEpJKswcdKRWffTlOIIkyRIhuEvKXo
         Mhj+DchxBCiIJcfvVN6ywvms1xTlfFt8CWVlyQKPdYxBDJOFxxFQFkM7xXMZpj5xUKh1
         nksTzL1gxHGGkBNKlGcNSLMHBlEorTqlD2r0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295504; x=1792900304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ekUzfSCWNq1Ng7vt6OtO+4tAJn/2muvIGZQLxicYOuQ=;
        b=ZzjqomfgqNzzITvJ7Y/9uPlDmnwu4bNM241JnMr0UEy1pX/bfjz6jqJaVs62vU8YHp
         S4fUYFU4wremoFAl4wkQ4+469PXYET2iqCSio1a7noOnBw8+0pjR6Rz5xWDhC+tXEMDY
         sm2+wPNnTMvumWASUtnWB2o6Fcmo1s9/bcaKwTiF0/sDZCBQ69QPKfJronkqYpMMmH5C
         +AZn14DOLhRmRAhgMgEzpa8syrHGJliihV7PiTGZg2tJIu1nkvz64B2A8w0nq2PO3lE+
         z4zqE3xMrAFII8ggqaei4XQJzPkFHIlGikwSp/TM8yyzESP4FFVPTHSi5qKz6GM3nWo/
         PweQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTjx9fDad8obf5WqRw1BsLFhsvEqi8jchf5lSeMH+/eCCnFAnIOBk/6Td3CQb+8k12v0IsGmpyjQ==@kvack.org
X-Gm-Message-State: AFq9FYJqWiGOO6vt8asTUiLBolwRcOkoUdZzhetP+pEvYVyEIwk4m2nY
	EWNHm6ynQU7ByMHOM1JHU9eCEz5DKQ3PoLSobOOQrAG3vtQbStObE99dh3O/9Qd7tg==
X-Gm-Gg: AYBFou1dpsRa22FuxRKbt5E4pwdKrHpgQfEFlbK636sDSB90/sga7IvbHOHBcTSPHpR
	9PdCvwGLKZW/3kdp9QBxbdc75Ahq1NVo/4+yzd2JN0shYoxxuVFvbB0aMt9XxxmLfRedodfZs+m
	/GG0SoCJvyaMW6FcYTNGJTb/XTrRnI5jiOF5Z8WBFT1d99F2xE9bb5qA0upW1RL/j9wz+0UnUte
	iG7KerZ7NIfPy0BSu3JpVvuhSE340hTNzVdPB5S5m5RZTk/OGv8nn/O1DKvauUhKCrg3+IANLGT
	OZVk/dEYjzyvzrEmv6A2id1fTn+U4g3p5i3tfUkNAgJx1p4oryiy75H9f4oLcdwH2uGsVi2MUDh
	pJ4dwl2vpOu9kubxHFUzMgeuQRgNo6Y7/+HNWusj++62PZ03zXAarJKpE+lr1BuxrlfelpHyLv8
	1X77qgc2ZWbQrx8WWegdwGwdtLVZum4qvDCxAGZugNWUG9ZQ6OI1IQNWSuxTmvznbq4WV7N2cLL
	vjaHDXW/+dJbHyqQiRulH0lE2boRhoZtJ7U/EYbY2t1yETZv9fLwd91zxpP54U/CRbdKNE2eks=
X-Received: by 2002:a17:90b:50c4:b0:3ac:9ed8:f310 with SMTP id 98e67ed59e1d1-3acef5960fbmr4275858a91.49.1792295504422;
        Sat, 17 Oct 2026 20:51:44 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:51:44 -0700 (PDT)
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
Subject: [PATCH v5 03/13] zram: zstd: do not allocate empty C/D-dictionaries
Date: Sun, 18 Oct 2026 12:51:05 +0900
Message-ID: <20261018035125.3120704-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: B336320003
X-Stat-Signature: w3ubsqjhenyga8jxg566z363zpojren5
X-HE-Tag: 1792295505-490669
X-HE-Meta: U2FsdGVkX19XpEU/Rrv3re/n0fdeDpikH2rTbW40TJd9dkVSkvIS42/5pm+o3KTBlPDCW1ZbOimN/tTHl6T8qpsG9JsRAW3AAyOdSgdmak8g8cvA+vbWaCdlnjc1DVnLpBKYaZ4ijBKZn0hoYkkkA3iNmEARENCmPvM8tM7RiZW//syl1h0BYNU6gWXpvH0Zeqdk1A8d0wgNT5sN5jYd5WnmIfeKPR+vXBmYaT37FROWA/IBlhmNuZo1XKWyTITgk6Gc6CBH8kUX8D9Iz1Mo/ufF0oELl3hmXCHl26OGcyEcQoEiqe8Qjp7wD9klo2ueygLkUGPoh6dpjwu4Mkf/CYhAV+uZ8xB+ygoKhoMG8dJl1QdiZjJ5DpBItBkyADT43UibvdcmD+PR6ox0QoZ76XDkS3LoSKN4hyJ1RublHmX7bl0LojtcWE2tN5Z7hrAJzkIhe/OpaNf/f3fQqGfxIOuSjUX803q9KcPM+JRqbeBz37uiGmT2CoAmTV7dKgNbZbuTf9jDcNSuqIeA3Rg/1c9bE8SvdcLxet52UBIU/4g+FcFSX04RIH+BizZl/9Tw8eTrN/XNmvFTxb2kFm9KLbnsG5VXVuPDQ9clVkRtU7mqHd7NJ2zj88BKKp8cLJInfe894zChbWPDIw9VXr15ufSr+mDcsZPorgF+S9XEhUX6FZ6mj27NJfd9vogSNC6yrxde4GalUCs8jWlISiRj28PqeSdFRKrqf1hl/nLRqylG1gOmJehZNmnNzCT4P6fRNFOcKgv4L4IWsuushoWthWErAZHCA7AmCxm119b5DfIMed9HVawsEx9d/ocxG0L1IANsFoaFPQoZnwhbuEnQ8z+WKzRw4f4gy93rJJdgrPoy5ktWlF4o/d4/00aPbodyBhq7AJ4ZOXfBWLx+EXBRQ5OMWtzmHsqqO6pFlGIkbxgcOwmBZ4AlYbTQ999jUeTYZ5YMY9AtrPspChU23Wy
 CsRd5GF5
 wHJBOWg+dyq9mHJMGI0QTZC2Ha2UCCpX1yclLvWm/E5wAvDJ3Mo6AxUIjVws/HLsNVDGj00Wb62W3pe27REf8EMyPDZokXMrGtf2aENhVTDR6j+RV/tTS2tbzN21QYJSoUdeSHb98ZtqIayOPLnRMqL5yORqj/M8BBvNKk0UsHMmr4+kCyNiZ7LzDP4N2FfbNhk03q1TKRcc6JhXazd6HjtLXQcL9ripIwUg/tvPgbklY6QcGZA9izWr85coKCr3efgSVS90G6YwYUoPjkFuzF1ERtqFTZNZGvM3FGlILtjiEX9qh2rUxa4P4ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not zstd_create_cdict_byreference() / zstd_create_ddict_byreference()
C/D dictionaries when no dictionary was provided in the first place,
because zstd still allocates internal memory for such calls (~96 KB at
default level 3, and ~160 KB at levels 9+ on x86_64).

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index 127976b5455b..b367049f131d 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -76,6 +76,9 @@ static int zstd_setup_params(struct zcomp_params *params)
 	prm = zstd_get_cparams(params->level, PAGE_SIZE,
 			       params->dict_sz);
 
+	if (!params->dict || !params->dict_sz)
+		return 0;
+
 	zp->cdict = zstd_create_cdict_byreference(params->dict,
 						  params->dict_sz,
 						  prm,
-- 
2.56.0.176.g3575e65682-goog


