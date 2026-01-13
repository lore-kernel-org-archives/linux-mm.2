Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273D7D2D0E2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E95A6B008C; Tue, 13 Jan 2026 07:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1406B0095; Tue, 13 Jan 2026 07:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF956B0096; Tue, 13 Jan 2026 07:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 698786B008C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:17:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1277BC1339
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:17:52 +0000 (UTC)
X-FDA: 84326841984.29.7828E0A
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 392561C000E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:17:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCbaWUxm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306670; a=rsa-sha256;
	cv=none;
	b=GgWM/2VcvauMfZKTaWaBJR3XBFhLehOPLPaeYRXKiUBDhAiOKVQ//XacOok6W3STn39nsO
	AV7OiXpWAHD8QPjUgbIMlZhJkJrv/eyxQZOQLIyo0YFCcuDUoVUCGRuPj4koEMEoyytS34
	hVNpYKslVFo5pPMrwNVEUTtZI61DmbI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KCbaWUxm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z1BJ19WpqYD1cGrRNJBkGK7rANN3Ll2fyIgG6DV0n9k=;
	b=gkiviMiix9AF58L0EgBLBeLxK+hEMVz/Kv3k3DZDoQnheWdvffDtCcbdBDYO4XUiyOUlXe
	D/b41cFYM4BKAjwjoDII0SprsowOuvk6qtfm2dziIQQXjG2LE5F1kaPNANaBv3oqq5ZeWx
	Ua1Q1shW0olej269X04zomyEOvgZuLc=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c2af7d09533so4805990a12.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306669; x=1768911469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1BJ19WpqYD1cGrRNJBkGK7rANN3Ll2fyIgG6DV0n9k=;
        b=KCbaWUxmu+eElMXkPIDvPMLx7tl0bHO0QKxXnMuiLs53vUPBqD7jff88w1UHUEER9L
         pEOCUJAVApzL4wHhKMHOK67/33hGXV6i3EgDbom8MrcnjFuSEb1JekPJ9LTih8G6VfOn
         WjHEpGJQq3kuFsqpiLO9uTpzRGLfWdhFrBDXQscKYHXhwBPpWCYlQlnfHAoB3Ai0Mg+7
         ZZJ/vdouURGHDRXtsKzR4DwdCyig1cM5g26Ff32H67v7BFsJ3zqr/70Ixj2nK4HsuP5d
         v6fAHGG3nKcuWaRF84/QG2MD2CPwjQ6F0pay/XD8rxlgtoGqoep6XIG2ANa4lNTQK9mO
         XdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306669; x=1768911469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z1BJ19WpqYD1cGrRNJBkGK7rANN3Ll2fyIgG6DV0n9k=;
        b=E2+z7Je+OPevGGX7RFu7cV7+X7wdssBZMIAmWEH2sSj9na3bjqjYFx0koljOBa2dUr
         mvlEK7Xud0SekDuKTiOuSD9wUJcjSHl1/wTwCgxtybtULZ2z8tcl3atcj5rInYryUBDz
         coHV5kXjf/W4pbTr8ISkepTcYzG7nVp7Zlg+PewAnqD14nwtn8EAo7DVwo6mHezn9PRN
         gbid4nXbu5F7flzv8UHDZOhJcLtuX3iI8mas4FGjJM+BR5c80BAfo7qzA3nV9WIRiDOG
         aTmHgjAnYot9SBDuZymQt2yD0coh4cS4AFF3bC8jkgawQz/hqM/1crXzfkln0CAHwe1s
         NB/A==
X-Forwarded-Encrypted: i=1; AJvYcCU0EHvFRR3TfrcwaQg4P8s3SPuq0sJ8cxuCbJt+dEmFddjxsol0DAWz0Z7VkhpgYLi3OaB4C0ELlw==@kvack.org
X-Gm-Message-State: AOJu0YyxfT6DdqtglNdW0DZ4JGb95w2CDL6IRMc/SFaXmTjxZ9qsZJsx
	QME5nE8nVDwB/5Y+7Br6pojeylmbMUlJGqZc3c0bwmgGIBIo324z/xle
X-Gm-Gg: AY/fxX524lhU14muPi18GEGpj5Z7agOjkNLViq24Rq5Wk+hjuGtKJa7J6IlKUUndO0J
	MLILrp57HnkrC2DnIhqdnRwaPoTxihi3QNwwRhbWEv9R+UbhoPGxMgj9E2aYAzOkqRU4Mm4IEPc
	4ZL239mfEVAwLDRA2X6fA5YuP918zMYPN9IFcATNV3u+tGwTVgU79AzrU4zXE2u58oikRuTP54W
	yftefDWooVEvaEaG55iM69emByumxQvIrUoekuIvY3uIqigXBs4h9KitYlFH145bpXTJynTfwWO
	vLj1hXk6qErF4QDJ5JearuVkW2rsU6rGAzEGPGB07D7pj+vXqyOqhMlLhtTLY71qNVdHoaP2aet
	EJjrHv+16Lst1xiSZk/Q0iZChmMLfQf0kHvducKaGueobrm8CUPlpGFpRkJ16yjEFR+bc0gRFgF
	stU7lYJ7T70j7f
X-Google-Smtp-Source: AGHT+IFDGHuU1rsktMeitRsEmdv6U9Stp+W9ykpOAe+ucIUMOfFbW5X58S530CoeThhNa7Kz/23a7A==
X-Received: by 2002:a17:902:f652:b0:2a0:7fa0:7b5c with SMTP id d9443c01a7336-2a3ee4b8e3amr213100705ad.55.1768306668961;
        Tue, 13 Jan 2026 04:17:48 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a3e3c48be5sm202341695ad.30.2026.01.13.04.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:17:48 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@nate.com
Subject: [PATCH 2/2] mm/damon/core: tunning nr_subregions at the kdamond_split_regions()
Date: Tue, 13 Jan 2026 21:17:30 +0900
Message-ID: <20260113121731.31468-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 392561C000E
X-Stat-Signature: a558kwbpo9t6s9k1pf3gyhko44mnx7a1
X-Rspam-User: 
X-HE-Tag: 1768306669-904436
X-HE-Meta: U2FsdGVkX1/Fy4ad4xmeNvnwxCi4yKF3h5LCkEINmYhD4gvSCNRqVNxYIkhxvQGnikbdpAEa4PecxgConnJmSpGRrXCExEnMJZF6SeNvowNdnUzHJKjBwDeF0zcsXXlqVw/kv4Wz86hWbFhJzL5wR9gojkU91QCPxMKHR9q0GiiAaa86JKsXzlg19D+fjYO1Y4QZKR6Si6pdZ7iAgbu011oOiq/MEiwO7Aqw8tj0f/TMNxY46AI6itXJpb0JSS4paOZripbsAqx8RnWB+kRF4YVlku+L4Xx/uhMZqW8+36TimKYn+pFT4L575onqs8kTiUKyh/sjuviTLr7dDif+dQZbwfKwEfVr0vVuiHjakptJoRA7ZEDHInmARML6GL16Wt48crfXU/6erhKKei1XyYeOOSfMJWGFTlfpt0iptw9RhnYLvLHcq7IAIpg9nY9ongJ12f8qi20QrSUPDz77ECAj4p8LGO53J2oGhMFaO5tRpTEm+u9Au4H5cfo0pcZLELvpJ5k+69RQK6bw6067Vam++4GzlTqFQhjuSHiv3QfaQP4z6r8ti+VT6lhXU2P1Gc8l2xWdHD7atcaDditTSX6nNHct98ooz6rmBxyLOloxoUxE6O8ILGIaRFDK6/zyBS1XxUaXSgRfOE6yD1SCO+t9VjRpmpJLsZabeDqFL5gXhZApi8Cs6CIgMsqZM3j9UVBqPWvaB2A031a5ueH9XCw85UmvCGVxQbv4gda5jSznTdqMfF8TDVPD4S07+VG6OIHYNV7/IrQhPJMdpc7NFKWwHL4bIDiv//BQEhJrjuAc33hNRB0uwzAxOiho4KaqZ8tOzlNwEMPh+5jhUOXAs4gTnOckvmkEicHauo/1pfm757MEuTCx8T3CoZL1iIwQn7m6YvnZO4wHuA0eHf2Y5Sf4XUha7yzfX/fKxzKF4BsVtl0SONmJ3Qc5SB5Uv+nY34I0xY2Et2ilJVf93sg
 XPrkGKr9
 cDTsTCiY2XzJDHMrge1dhFqbfLHATRVAC7xbIqYqqyWZ88wEpl42GneB6KlIDr0JlyDbFD1QA81TFOkSyZWFwlguYaAq5Oew2wMLu55xMxJs3hrIGcXrrL9mVdzCmAGft+Y0dAtQpWtfh7Ax2lzS8EuF2PH4yDn/NIbFy+lmk/YENSm9Lzb09S1NeIvV7VpPLaoYtXaJiZ/OUTOXUEmYrrPlSexnrLl0AgSvVtu+esVeGTIGr4rZy+Q2nZkUn45NGbJaFbsNae6XdEtehvyyGq8P9FYtJhRPwt52hmS48peWjIpUtAPG9rxtBeBDg1QGJ1SKbtdMNgXWUkn3LLNfbOr0y1SGCCAcz84HiGRHg8jrajb5MYzNx5q03IHha6RPgeYiUpsYeQJPJawc6580KfH0U55s0kWhqvbBMA3QaOwx8cjtITuhOWsrqx0vxfr1Meo45MpgxpZ0VgpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.003816, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON is designed to allow the number of nr_subregions to be
set from minimum of 10 to maximum of 1000.  kdamond_split_regions() splits
the region by setting nr_subregions to 2 or 3.  This splits the region too
narrowly, resulting in an overly wide address sampling range and increased
access determination failures.

Below are the test results for a case where address access determination
succeeded only in the first half of the address region, while failure
occurred in the latter half, when the address region was set to the
[1G, 4G] range.

When there are few nr_regions: (8)

    |--------|--------|---------|-------|-------|-------|-------|
    0        1        2         3       4       5       6       7

   target, nr_regions, addr region [1G, (sample_addr), 4G] nr  age
 --------------------- ----------------------------------- --- ---
TRACE [ 1] t=0, nr=8, [1073741824,(1073742349),1075138560] 20   0
TRACE [ 2] t=0, nr=8, [1075138560,(1075142341),1233899520]  0   0
TRACE [ 3] t=0, nr=8, [1233899520,(1360224040),1515687936]  0   0
TRACE [ 4] t=0, nr=8, [1515687936,(1872615549),2246262784]  0   0
TRACE [ 5] t=0, nr=8, [2246262784,(2294436960),2536173568]  0   0
TRACE [ 6] t=0, nr=8, [2536173568,(2577497080),2748776448]  0   0
TRACE [ 7] t=0, nr=8, [2748776448,(2818332252),3328598016]  0   0
TRACE [ 8] t=0, nr=8, [3328598016,(3553053181),4294967296]  0   0

When determining nr_subregions in kdamond_split_regions(), the number of
nr_subregions is not fixed at 2 or 3, but can be adjusted based on the
number of nr_regions and the sample_interval.

If the number of nr_regions is small, the number of nr_subregions is
increased, and conversely, if the number of nr_regions is large, the
number of nr_subregions is decreased. (Reducing access failures)

As the sample_interval increases, the number of nr_subregions is
increased.  As the sample_interval decreases, the number of
nr_subregions is also reduced. (Reducing system load)

Below is a test result showing that increasing nr_subregions increases
the access determination success rate when the address range is set to
[1G, 4G].

When there are many nr_regions: (16)

    |----|---|----|---|----|----|---|---|---|---|---|---|---|---|
    0    1   2    3   4    5    6   7   8   9                   15

   target, nr_regions, addr region [1G, (sample_addr), 4G] nr  age
 --------------------- ----------------------------------- --- ---
TRACE [ 1] t=0, nr=16, [1073741824,(1073742496),1074819072] 20   4
TRACE [ 2] t=0, nr=16, [1074819072,(1086087568),1396940800]  0   2
TRACE [ 3] t=0, nr=16, [1396940800,(1408406119),1709060096]  0   0
TRACE [ 4] t=0, nr=16, [1709060096,(1718634828),2029752320]  0   0
TRACE [ 5] t=0, nr=16, [2029752320,(2033076942),2147844096]  0   0
TRACE [ 6] t=0, nr=16, [2147844096,(2147870592),2148532224] 20   5
TRACE [ 7] t=0, nr=16, [2148532224,(2163851851),2466242560]  0   0
TRACE [ 8] t=0, nr=16, [2466242560,(2466983182),2786467840]  0   1
TRACE [ 9] t=0, nr=16, [2786467840,(2794755756),3105136640]  0   0
TRACE [10] t=0, nr=16, [3105136640,(3108065434),3221405696]  0   0
TRACE [11] t=0, nr=16, [3221405696,(3221424712),3222261760] 20   4
TRACE [12] t=0, nr=16, [3222261760,(3222269016),3222290432] 13   0
TRACE [13] t=0, nr=16, [3222290432,(3234589365),3542605824]  0   0
TRACE [14] t=0, nr=16, [3542605824,(3551138058),3859030016]  0   0
TRACE [15] t=0, nr=16, [3859030016,(3866123754),4178018304]  0   1
TRACE [16] t=0, nr=16, [4178018304,(4179564176),4294967296]  0   0

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/damon/core.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ff9af9d6a788..4bc44c6545a2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2423,24 +2423,30 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned int nr_regions = 0;
-	static unsigned int last_nr_regions;
-	int nr_subregions = 2;
+	const unsigned int nr_min = ctx->attrs.min_nr_regions;	/*   10 */
+	const unsigned int nr_max = ctx->attrs.max_nr_regions;	/* 1000 */
+	const unsigned long si_min = ctx->attrs.intervals_goal.min_sample_us;
+	unsigned long si = ctx->attrs.sample_interval;
+	int nr_subregions;

 	damon_for_each_target(t, ctx)
 		nr_regions += damon_nr_regions(t);

-	if (nr_regions > ctx->attrs.max_nr_regions / 2)
-		return;
-
-	/* Maybe the middle of the region has different access frequency */
-	if (last_nr_regions == nr_regions &&
-			nr_regions < ctx->attrs.max_nr_regions / 3)
-		nr_subregions = 3;
+	nr_subregions = (nr_regions > nr_min) ?
+			((si > si_min * 100) ? nr_max / 10 : nr_max / 20)
+			: nr_max;
+	/*
+	 * nr_subregions is maximized within the range not exceeding nr_max.
+	 * Increasing nr_subregions minimizes missed address detection.
+	 */
+	while (nr_subregions * nr_regions > nr_max) {
+		nr_subregions -= 4;
+		if (nr_subregions < 2)
+			return;
+	}

 	damon_for_each_target(t, ctx)
 		damon_split_regions_of(t, nr_subregions, ctx->min_sz_region);
-
-	last_nr_regions = nr_regions;
 }

 /*
--
2.43.0


