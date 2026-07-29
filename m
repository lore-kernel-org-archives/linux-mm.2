Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1968EC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15316B0088; Wed, 29 Jul 2026 00:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6176B008C; Wed, 29 Jul 2026 00:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FD86B0092; Wed, 29 Jul 2026 00:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A74306B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:57:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25278C0566
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:56 +0000 (UTC)
X-FDA: 85040606952.07.07E2660
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 65FA8100009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Z4HlEHMp;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785301074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GNjJWfcI3IptvEkLDf97kgytRWL4pzzKQPySqOPmIK8=;
	b=cA6O6HpHn4tXxAUqeOjY4jcLr5HQKVEcjcY31f0N5fprFXcHUdfh94S35npLal/EPSYC/C
	K8rDDq2V4KdsrtC4SDiFIaaIgBfiOUjc0eRSmx+uQAUTfNp8TAcz1BLb2e8KlDLcU5aDQT
	b22cn60NKVQGcaka1P7A6t5BtBsli+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785301074;
	b=f+OzYZrvwxTiJ00LyYL4EBID/mQJ9xm7S/mAI5oyf5D/f1w8NXXZK7vmVM9ueF+d87j5kz
	/UioYg09j3mUDN6G2f+wINDwepV9Dpui7wNM2NAnwBAvSF2eLIEjKJfe+SgbtnyNDc3PcS
	Q6scyNR3SpS92GrxP++jwEMqxkIooXk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Z4HlEHMp;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-848743155bcso215588b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785301073; x=1785905873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GNjJWfcI3IptvEkLDf97kgytRWL4pzzKQPySqOPmIK8=;
        b=Z4HlEHMpfIlDFUH6PNr3syh2iZBNsUghVKiWX/ieux1wC+UkqRsSfvvDaNMPp2IS7L
         0b//9aF7HeO+nYQr85gbfHnqsXlhoEKC3uHD/LVjXQweGd4OufOhC1SmYX/yptrlUdbA
         rvINR9ERp8XSTxv/Rb6U7S0rVHB9b40toJ7TM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785301073; x=1785905873;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GNjJWfcI3IptvEkLDf97kgytRWL4pzzKQPySqOPmIK8=;
        b=ZL5LWL60328gHqRTPMy7Hp2lBKlPk0s8ZCNY+vikj4/Z5VHkhOZ2YmPHv2QzOE81WE
         x905PQejw9srmhAa1sPA/AIRcBUyMT/hYUJkYFVJ16z9BSve7IU1J80HY/cwPH2gIrPU
         BbiahKmN9ZLqDadIMMyKRwZbKlTmoaWD87lkEorOjXvAHx3K6gcGcB2ucUAqYIXZDO8O
         tLvn7x/ADLKiGG1nu2oYepUVvXr65I/7nX7eH1LHXzLDzdkpTqL7eh1pV/z0e8c0PrJn
         dNgEVEZiuZeq2gofCGcZ+fIWHbugB6tGAAq8TH0m7fpeAzdr4gseB228FxwUIKIBEY7d
         1lUg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7z2fWxDsDydfMcD+ykzY0uUyN4fPvP+BNrfrHT/1of+Px1rczGDg4aWwxwPpqFCEh75zjboMBgA==@kvack.org
X-Gm-Message-State: AOJu0YxQFmkpCD0mxX5370kGN57f2367+TecnHINMUpb2sJzcCX0eXnn
	fvkv5oC5pDQXsOy/8tovuNxp/OSfcE4hRLpen/SL5of9S3WF0rI8vj64/uoRc7KxSg==
X-Gm-Gg: AR+sD10/nbAhqQ/lmTykQtQlRD/3aUvFMQnvQbal2gOG3Gys+uZ/WxWOgJZlRuLaPkI
	RpfUIEgNfS5l4pUgWQckgcxSip79QLqSE/OOdLIi4mAfqJH3whtH3rr7L1u+NuxXQigFt8rslLB
	H611n9Z5XUlIwsmmgIVQbTlFXKeU/VqJBtxYfsAboL+2ZRnLE4MtBV8U9ex2AFLUDmfjsJdf6AQ
	FeZqatCjMvsdR2lDlsKPmf+LOHBcnWgynxdwO7M5pXwTth51QftawEdHzlib7Q6A2UkmuYc6h7l
	+SvOzFK2DK5JCzzAGJWX2K2iSnl23hcvs5rxW53gTtH2jca0alE/5y7D23+LQYxpQMLD+0PsnCd
	iKNWI+fQjXegFB5Hi/9NWu8bRPG4015jVkb20m8U72URJ6XhFpX5GggOm9C4zZNNvk8Jqk4M+Kk
	AuAPyVHTqsEtqTmIQwoFnCuTuUjjQe9pByALh/i+xc4ZP/MLieAAZhkpR/fpITzZfax0yfMKHXS
	r6y5LUfGqNnIHO1OnknFssGouHYLGg4Th+vuoCByVlGCb41gN8=
X-Received: by 2002:a05:6a20:2586:b0:39f:2dd0:65d5 with SMTP id adf61e73a8af0-3c8ba5cf40bmr6406449637.39.1785301073266;
        Tue, 28 Jul 2026 21:57:53 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba63c743sm335183a12.26.2026.07.28.21.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 21:57:52 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 0/2] zram: fix zram issues reported by sashiko
Date: Wed, 29 Jul 2026 13:57:34 +0900
Message-ID: <20260729045745.775973-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mze1uyiki1gtw84f9fcds8w4s4sny8we
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65FA8100009
X-HE-Tag: 1785301074-902774
X-HE-Meta: U2FsdGVkX18LImuXiTfpReGh6+TCmGazyua5oCCvEoKvBX9VvsUc0YLXlCXwl4/hh3vpNwUqJ6RmsC33gWQ/MhMyfHQgRl6NNfJ/5+x7BQq/G3I5cvdDbVuvGGacHW9ORzxBi9+26Q0snV2/hBU9jYle/7HJgGswr/SzaSi1/nwsbTYijdmy0SlDDhA9d8I16BJVkoSmecA7ihgYh3XnyUA+kDAseVjma3EsUMiQl3UuPTxib+rIjUikQYGkXT6X/Wm5Cujniilr6/o8ZI1+a45jlGvD69RBYvpa/LDQQeswYm7jf76ZtBBf8CK5y2/j/NC5OLrXHhX/cswoD8D7Bczgua9NdSfmVSCGur7jLgUPWoyRJ0HCe57h0m1FAGl3wuzsTa+ppY8C5EUBoeyN3bNOp7Y7Qx8P/PnIki503AL9/2l3C4SMb2AGXsbbn+d3QzHRX3l5N5XhbfLDgIQpl8Yxud0cp0OZaInC1TX9N8edFARq1R3wjbWcsmYmYAcx1ux0f80ld6hREJFcgTg8LO5FkXyC+hc3JAqi6I1B6R0VgHaN9smYneaqImL6B4NpALKkM5DKKSkYMBeQx5mgk581mbTtl1lLfcXhp4MriaD3TsY9+9GiquHS6wLhv5KW0n7F1DGTebqgbNGIGxCpL5n/FvLskMGYtdcZNv7qcwkUg/t9g7upseDx8GFNAflkedrbx0PJKRcJvJlxa3moF+jExi5lP6ZpdeQC4ZzAC0D4jKl60RfE7H10ay8EdwMagaJworFXgRa7O6fpXc36dZ30Bi2fIdlkN6PbPSN83iNzCfjLPHSB7ISiGenrsUKZDcpeWOrtH34rm3EkteBpcxYUiXh8xrB4NbLDTKC3lktEMiVJd708Wd1H0mfthQOC0o1LIU/Zfm/O+MlLEtgo9UG/U9KGYD0HKfKo+U4Y47IJSSoIpbuhYZ8hyYqhhVyTfRHubRD3coom+GhgSVX
 2FzHy/Si
 cmeOW+aCN8ER75ZXiHQ6Ize7wJ1YkThkdJDIOQt/jZNuqinAREMQSgdgRpOx00YyzOlmNkhkd2NKrH9b5i6sHEgLHfobT1+Q+y0L0VC4S44KarbPi9no/PpN2uH3dSydA6skLKWgRXAjbLqfZ/FHTUaU+pDKx3mQDGDGEDc/BduHIkPMvnv6gfMxLiAn82k/+Bus/c1lXEphPLQpFTka5KB5KBQllcY5bCsump2ptpz+pGrJ/xWhTadWLEElNFu3/GASUAu4ghtJ6h1eZJm/MeOXl2KRpl68NtSnRgFvWET8nwUbLGTvdNRme7NzqI5BsbEHhx7CU8ueewNvWGnCPk/AinK/mMERY4YFd0bDTaDnXz4EAXgRCo0tdWhVDnzasdiTVzWOKmtKiKIyaM/wA9s9QWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.

[1] https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com

v1 - >v2:
-- pr_err() invalid deflate winbits

Sergey Senozhatsky (2):
  zram: set default primary compressor in zram_destroy_comps()
  zram: validate deflate params

 drivers/block/zram/backend_deflate.c | 10 +++++++++-
 drivers/block/zram/zram_drv.c        |  3 +--
 2 files changed, 10 insertions(+), 3 deletions(-)

--
2.55.0.508.g3f0d502094-goog


