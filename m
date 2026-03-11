Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C77DFD065D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FBE6B0095; Wed, 11 Mar 2026 04:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999626B0096; Wed, 11 Mar 2026 04:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850976B0098; Wed, 11 Mar 2026 04:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61DDC6B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:43:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2FC9140637
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:42 +0000 (UTC)
X-FDA: 84533143884.07.2EEFE6D
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D2B320007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:43:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=St2tcqrg;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773218621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gbLLG6edQ0IM8f9elrHyPvt9TZ4LSyReKqdPmz9Fwc=;
	b=6DGeTLELjuH6jnHnA1Bz86D7KIy4H7ygrKfeP83OZhcqzGVaPURxaOINf95bPmK4MHjRho
	JHhGtzpBpofzqfPihKVGx7Hvle0ayMlJ07G3FkwTeZujo0OXVVUXapmOOMpHv9Mvofuxvi
	M3zRdagqjQNajK+Wn8IL7Sg6h06TMwI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=St2tcqrg;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773218621; a=rsa-sha256;
	cv=none;
	b=FUefmesYOfwIWWi2STRRtuRtDETu6udO1BI5T9Ab4bSowNCLoOZMJqH+3uIq9o/x70EFw6
	KV5IFdDnh/tue9Aq5Q7veL2c1cf3rKW5cl5uNYR1t/Bp2bvlM8Z8b6CJuSUjWPIACf8tZq
	7IOhsSo7yCBbaMucfr7OVCT7uKaSkPc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2adff872068so66311345ad.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773218620; x=1773823420; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gbLLG6edQ0IM8f9elrHyPvt9TZ4LSyReKqdPmz9Fwc=;
        b=St2tcqrg3+8vX1rAjaua1Xub5baJLfyXDukgfRzeOqyMCHPA/pyNy17s9qwHfWpBSA
         /+peRVX/I2HAOBWRKV+rSQ+5uLrFSKAL8/DC0fgBmjTYeERW3H3kBmIzRfbsQHLFTQMW
         El9As3Ai4bXBHMBSZ2SGtZQiKe3zyx61mKfmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773218620; x=1773823420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/gbLLG6edQ0IM8f9elrHyPvt9TZ4LSyReKqdPmz9Fwc=;
        b=RMrrG5qTAXbI4d6sUbqqkHMU1zF8Xmifaf+V+VboRZxmk8fALAW4yH1bFHs4jw197A
         3ewyO3NhdxoI8aWxyqjuKsr3RloJBKv4wQ8HZUJUlS6B8JKrb1VCbzg+3aJ+yyNAwyBd
         TbBizFZqKslXxb8/wvl3SuSy4esmE8YHX69E3ez9Tsz5aGKpAP8+y6TQmOgmBIqtjXpc
         Z2b7ojT/1o0m1cSxHU4kiUIxScTryos6+436scIcsXVTf95ZBQA8LLHQBhXAP5+4cRvE
         b3IFw9AkhNpzzg7ZFvpKW4hDe3bIQP2Az4tWMlbPfDFpEpEYp6nHh3XDkCwRa8JTEBcM
         4vGg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ9mcHNovGrYQrQbTPx+fwyqwiAHHx/gF6o+gEX3HUGVHJkSta16juvD9J3PIp72tJxol7tRXqBQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1dtlLA7dEYbcLMmIOZR59h8smFhhG6T6IWtRhDVYAZ5T2E1aT
	iWtqJ4ks4PX+4jwIfsbf9B+qtu7NgEDIAJjgVbheBG5BV7k8N4KIrXTGr2z9z9fKFg==
X-Gm-Gg: ATEYQzyWW+6o4xlDgiCn3QZXqnCTiwUV/RLG63HxxKyUVKzPZrJwDtvsLwdx/LNW+PV
	TA7Hl7nyzZGe5WfXnQkRnnq36+XZy7ZEUzFll8xWL3kq7jbvVL1nrAWPF7Irjqw/cOZApznlEng
	oP6Sal/UL/Mbkvi3h4Unvzbnnc3RapO+AhYz1Bfl0RrYjVtfqStXQ/UPYQCe+X5HdCd14/udpmL
	AQvNcccsnTiYSwanAHcownnXZtaJy0LpZSZklkI5vrprK8pYCNwuB8nCubzeJBRBm6GM1y9+RF6
	4HTmCjVPd8X4BP67a2zGQMeLqGJUtuzB8gsWw0L51h4gCuddZpJFgPyIypRHbY1Lb/jTJ2tpgjQ
	GsmZuH1+9BIATg7IR+886Q5BjkE9EAGvUAtunQa1w9A3eRoReFxBZ9gQCLD8rhHm4iIpvgi29fL
	UAcbtJmcxIyJ03rKoR/dlSM7hGv2fHypSX8yZCvqKFcofrsoiyhgDUbp9dS9kLUIkoWH7AllTJ8
	UzP5iaCkATiWQ==
X-Received: by 2002:a17:903:2288:b0:2a0:fe9f:1884 with SMTP id d9443c01a7336-2aeae95b193mr19030295ad.55.1773218620088;
        Wed, 11 Mar 2026 01:43:40 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:93a4:8281:fe98:426a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae261077sm16062035ad.40.2026.03.11.01.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 01:43:39 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 6/6] zram: unify and harden algo/priority params handling
Date: Wed, 11 Mar 2026 17:42:49 +0900
Message-ID: <20260311084312.1766036-7-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
In-Reply-To: <20260311084312.1766036-1-senozhatsky@chromium.org>
References: <20260311084312.1766036-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D2B320007
X-Stat-Signature: xwjfgigimyibayr8te6uk7rd8y3oqeub
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773218621-998567
X-HE-Meta: U2FsdGVkX18mGVNJyvI1PNYcAzKS8UsL5ZHIShyeIDw/h2DlpdmgfN8h89CmjkFCTJsozNk2/2RBEPKeS2Hj3T+4zlr7ZAgBZhxE/KETYo6VKEn7Bu+TUvTpwA29Cv1qQ2pLYfFo6EKEkrw/D+3pnGDjfx6CNH5qFKSBt4mHHCcW49S5WcZg3W7DTLzipRVWBmJuYT8ssV+9qcgIMS7DptVgwMzH9E3M9o1DCI2XCgIg9KuuiEZAd4ZYQuE0RDYmcM2eZF7/FHZhDZhfD4OJqiPoqF97U8R4ig2I1bWVFEpfV0YC6AzBVr1YZ5w6pdQnvVcwW4xP6T0g5x22WQn6zaFGfSIWhSh4SsBDCJo+neZPnkGpklBoucMcqb5JayxngIzw2kmks+TgXG7jTJSCwURM4CvNFeHo5dmPUMLd2SB79CTArLHNRhV+9cE50Sgvzrr+6328nburEvaIeruEKSHnaXimc2CrK/dUwjgv5RdKKtyebJtEWGfR+7dX1JL7iJZK0DhAS92QcXWY92Pat2kYKPb2L/mGPnmOU7xwHXCQMKOnQ12ur2q0kiuwPfz7Wb6ij4lW/hAU2XuxsxDEvG31tC0vQwxnuV5IMhB6Kxhcrw6aU15GHUeTn8lYzvFkKZDCvfn6Ihvn80iH5HW1fJQdsJr+RV1A4OIVXubKaRZ3MFGfS7NJZeOyr587qprhPSHOS3eEuTbGNagebFXUyU66JXBtggbO+P+eeM/I82DiKpeHiQFqb8lJ71vcCWfFw5yqIPYvZGRh0lWG0Q7UUBgluisLWGDnDzRdFw1A5QNKqhaYOdYQpzMHoao9d13ZJTCOLHnGTyZfW/WxkEGA/qBNFyTfNLIPfpCvJtz9Afs93An3Lo26vTfE/u5mBXmrc34Shv4DNa3PgA1tuZ+4vVsIy9JdD75YAKekurJ4ccHwTZeTeZRA9GAL5A+pHGnCdvLXb1Ex7fnclnGdo3l
 KDUowBUr
 tLYGUV8qzdEYuzinPIM+BoVy/yiMGk8zBY0CsrQtwPJv6HtkiQQR9b2hdVK+iQEBMt75VdsCGrfMxI2K8Vu7HxUjQt7N1wnAqcEUaBOUm6zlGJ5PWigxmZRzq4ik94rOYsvdjIfd+Vm/Z+py7fW0jQupHjtxnv+TYvj715PkJPKaofR2dhaO1MzP61WZq44GF69WB1GVaykFS1ZUK6vrQPGFWR0uvQvcEkxcqa5wQrC3RV+BYhroVDI24YUFTpZJi6xcW05BBSRZnsnunRicaAdXSU5AzlkfSak1bLA396KF/59wMPK/okm4E5uzqT6rJJK7P6dKYToOT6Ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have two functions that accept algo= and priority=
params - algorithm_params_store() and recompress_store().
This patch unifies and hardens handling of those
parameters.

There are 4 possible cases:

- only priority= provided [recommended]
  We need to verify that provided priority value is
  within permitted range for each particular function.

- both algo= and priority= provided
  We cannot prioritize one over another.  All we should
  do is to verify that zram is configured in the way
  that user-space expects it to be.  Namely that zram
  indeed has compressor algo= setup at given priority=.

- only algo= provided [not recommended]
  We should lookup priority in compressors list.

- none provided [not recommended]
  Just use function's defaults.

Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 106 +++++++++++++++++++++-------------
 1 file changed, 66 insertions(+), 40 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 02fb70f35ae8..676b1602d817 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1635,6 +1635,37 @@ static void zram_debugfs_register(struct zram *zram) {};
 static void zram_debugfs_unregister(struct zram *zram) {};
 #endif
 
+/* Only algo parameter given, lookup by algo name */
+static int lookup_algo_priority(struct zram *zram, const char *algo,
+				u32 min_prio)
+{
+	s32 prio;
+
+	for (prio = min_prio; prio < ZRAM_MAX_COMPS; prio++) {
+		if (!zram->comp_algs[prio])
+			continue;
+
+		if (!strcmp(zram->comp_algs[prio], algo))
+			return prio;
+	}
+
+	return -EINVAL;
+}
+
+/* Both algo and priority parameters given, validate them */
+static int validate_algo_priority(struct zram *zram, const char *algo, u32 prio)
+{
+	if (prio >= ZRAM_MAX_COMPS)
+		return -EINVAL;
+	/* No algo at given priority */
+	if (!zram->comp_algs[prio])
+		return -EINVAL;
+	/* A different algo at given priority */
+	if (strcmp(zram->comp_algs[prio], algo))
+		return -EINVAL;
+	return 0;
+}
+
 static void comp_algorithm_set(struct zram *zram, u32 prio, const char *alg)
 {
 	zram->comp_algs[prio] = alg;
@@ -1707,6 +1738,7 @@ static ssize_t algorithm_params_store(struct device *dev,
 	char *args, *param, *val, *algo = NULL, *dict_path = NULL;
 	struct deflate_params deflate_params;
 	struct zram *zram = dev_to_zram(dev);
+	bool prio_param = false;
 	int ret;
 
 	deflate_params.winbits = ZCOMP_PARAM_NOT_SET;
@@ -1719,6 +1751,7 @@ static ssize_t algorithm_params_store(struct device *dev,
 			return -EINVAL;
 
 		if (!strcmp(param, "priority")) {
+			prio_param = true;
 			ret = kstrtoint(val, 10, &prio);
 			if (ret)
 				return ret;
@@ -1754,24 +1787,22 @@ static ssize_t algorithm_params_store(struct device *dev,
 	if (init_done(zram))
 		return -EBUSY;
 
-	/* Lookup priority by algorithm name */
-	if (algo) {
-		s32 p;
-
-		prio = -EINVAL;
-		for (p = ZRAM_PRIMARY_COMP; p < ZRAM_MAX_COMPS; p++) {
-			if (!zram->comp_algs[p])
-				continue;
+	if (prio_param) {
+		if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
+			return -EINVAL;
+	}
 
-			if (!strcmp(zram->comp_algs[p], algo)) {
-				prio = p;
-				break;
-			}
-		}
+	if (algo && prio_param) {
+		ret = validate_algo_priority(zram, algo, prio);
+		if (ret)
+			return ret;
 	}
 
-	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
-		return -EINVAL;
+	if (algo && !prio_param) {
+		prio = lookup_algo_priority(zram, algo, ZRAM_PRIMARY_COMP);
+		if (prio < 0)
+			return -EINVAL;
+	}
 
 	ret = comp_params_store(zram, prio, level, dict_path, &deflate_params);
 	return ret ? ret : len;
@@ -2407,9 +2438,6 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	void *src;
 	int ret = 0;
 
-	if (!zram->comps[prio])
-		return -EINVAL;
-
 	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
@@ -2511,10 +2539,11 @@ static ssize_t recompress_store(struct device *dev,
 	char *args, *param, *val, *algo = NULL;
 	u64 num_recomp_pages = ULLONG_MAX;
 	struct zram_pp_ctl *ctl = NULL;
-	u32 prio = ZRAM_SECONDARY_COMP;
-	struct zram_pp_slot *pps;
+	s32 prio = ZRAM_SECONDARY_COMP;
 	u32 mode = 0, threshold = 0;
+	struct zram_pp_slot *pps;
 	struct page *page = NULL;
+	bool prio_param = false;
 	ssize_t ret;
 
 	args = skip_spaces(buf);
@@ -2562,7 +2591,8 @@ static ssize_t recompress_store(struct device *dev,
 		}
 
 		if (!strcmp(param, "priority")) {
-			ret = kstrtouint(val, 10, &prio);
+			prio_param = true;
+			ret = kstrtoint(val, 10, &prio);
 			if (ret)
 				return ret;
 			continue;
@@ -2576,30 +2606,26 @@ static ssize_t recompress_store(struct device *dev,
 	if (!init_done(zram))
 		return -EINVAL;
 
-	if (algo) {
-		bool found = false;
-
-		for (; prio < ZRAM_MAX_COMPS; prio++) {
-			if (!zram->comp_algs[prio])
-				continue;
-
-			if (!strcmp(zram->comp_algs[prio], algo)) {
-				found = true;
-				break;
-			}
-		}
+	if (prio_param) {
+		if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS)
+			return -EINVAL;
+	}
 
-		if (!found) {
-			ret = -EINVAL;
-			goto out;
-		}
+	if (algo && prio_param) {
+		ret = validate_algo_priority(zram, algo, prio);
+		if (ret)
+			return ret;
 	}
 
-	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
-		ret = -EINVAL;
-		goto out;
+	if (algo && !prio_param) {
+		prio = lookup_algo_priority(zram, algo, ZRAM_SECONDARY_COMP);
+		if (prio < 0)
+			return -EINVAL;
 	}
 
+	if (!zram->comps[prio])
+		return -EINVAL;
+
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		ret = -ENOMEM;
-- 
2.53.0.473.g4a7958ca14-goog


