Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 088AAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310006B00BB; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C02A6B00BD; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FA786B00BB; Wed,  1 Jul 2026 10:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E62F36B00BB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C7AB1C723A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
X-FDA: 84940488696.27.43EE91B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D48D918000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEFCPSeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917306;
	b=ahMLQGAMu9YJH/ZD/iWJ7AvjfuHfA+dTSSUE+5rOgd9OXAafed5w2GukcIDOqdQGdESUxy
	5oXQgbyVUFKbca1JreKWvWFjLqfRITM23Y0eBZD1IM1Ay6iYFN7IKtRZfAG17rzcuPENzj
	fZ6fgN61trFP3xg10mCSuX42mjaRt2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	b=nPqxA/MTLlaCaXEfUfDNFT2uISauhl99UQgFIsHVJzCt5kR8XpqHTH4vhZ2ikh5ADksAEB
	9L6cwlFm08tIM5MKeClqfL3j8GrElyUNKozx504ytnnDZBYmLcQ9KHJ5HhxhvUnC8OARix
	+kMC/Fz4wUHhTw892LzVmOQj48Mnh7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GEFCPSeL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 780BA601EA;
	Wed,  1 Jul 2026 14:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF03B1F00A3F;
	Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917306;
	bh=z4feI/qU1SbwMydOJY76MHjKjfYHnoO820guZYu+4uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEFCPSeLYMw1PQCmlpe9SPIj0AO5UrrMtNr1mhwwq+tIRgEPxBIfwU5aNCkorbFeA
	 JuLDYfKDA4DL0OdXoj4pcwl/hBnMZM0B/dOplIrc9Ei7t7g2CL2uUpx7brhIVijwk+
	 4szMC2LEcrKAjixcKHiIvFwF5ncWDeWcwE50sxE5774S+Xu8BlNq+XbPa5x8N35a4L
	 LQ6NOUWX6nqdYsaZgpvrEmKtk/kw5DD03rdS/ba67Ng6Wgtdpx4bbU8mN0KNxNWhBm
	 I6CA1Eh1MGdoZ0tJNJBQzDac97oQHWruQvEUcOsqSI3z/BA2sM9S57zCwewS9bogbc
	 Ug/Eb/2Yje0Dw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/8] mm/damon/reclaim: remove duplicated min_region_sz power of 2 check
Date: Wed,  1 Jul 2026 07:48:06 -0700
Message-ID: <20260701144815.113325-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D48D918000F
X-Rspam-User: 
X-Stat-Signature: fgaa9qnn9fu6d8dc91zr4otcknyzswmk
X-HE-Tag: 1782917306-846834
X-HE-Meta: U2FsdGVkX1+HBoI7kDbo7ov++DIlE498yJO8ewma7K+cyVuS+xCgZzT+8PqvrZbw67QKwN8+D7BAfuADmjjxH1Kt2qo3J3h9or4teuBsdyiM2enKJUSJQozxcTy+Ju77ZV/6F6+BIB7zIQyphg1q3Pxp8JliRm/eOA5HbvoCeVbpUvKCTSEh87dBOw+phYezgAoNrRcpXQy934NlzJbQwKQqQOpDQT2g4zcs0zCOBS5hErcds7DaZ4PbdZaFV6VnG0OYadZeR+xJGUxrPouKJ28w1NOw21W7107m+EDEuu03kq/A1giqEW7sSg0ley91DWQo9jYKrIF0uHteAB5SZYUUsN1dqQcosRAqeRsI+h4L6xFKsBfwLXFJt+NNmrML3pUPmSM6ZSM3jt0x8/Kf+eBa5SvN0UD8XEWIP1xDh9UncA/baKL8K9B4MAkC2y20PrwoH5NJ2NXab+BSrqgmR+ca44mTy/o/K2hjqdcdcN0eW8pF0PPLYEs3HxR3gy3rqoGkoITu7Moe/aLl/xvjKBKf4xG7IY0yZ4nccT7GazCR97Hn9JZRAXbZ3BJp7nUgR8q4WbBuEdiephrQABf3oT194KpKzQ/2JTYrL+Od+YAcYcyKgskVUEM2qwsUE+VJWCfW7O54Lsq4xUvfLNBO/DLsBrc8i5soSlh8yDhf0SbNuwgcKVaRk4A6PCttYiFKzmChe4fWSltsmjG2blcLDLTu202k93t806GkSLP6+t+BmCXisrn7ycxTY3GRyB1qYJSaNrKBIgHEBujoeB+nDzn8VzgmmRJovMoGPYbjbKbHfy96izMynTWY5uJCONhgI63a3LHHJdGurQ/fnu+2OH0LG/pH7GVKJ0BfCX58TKMsEoTjd0bSfjNz6Mz57cxr0J5WifSFDTAS6ypwemFSqfJmFAYQN96nb+TOVrqy3uw2x1JjQ08EmLEp3bO+bRVD0AAU0Og9E/FKSKtR2bH
 oqHcACWu
 veFJ44NP9OeTxKlYWRVmb/LMN3UyPjMT1GZsWx7KuHUmkKEn4VNP6novxQVvCSURGaeWc/4Nxb4GjIBeSNGrjhAEV7qpL0f2AoKsqt0I3Fn4OhoVy9KUG2AnJaVIVZF/2Gc4bwEinAASQFJP0aB/cLjhuSOFXvoV9LMatqYHUojXxZQDL7YITigRFk13Li/1kRJD4/C2N6TFiIWAI5KxI2nHHn9nepd1RUNzRKAsDmknWtKn8HmytBbfg+9svyUsraPF7ZThzdWv3mpYTTHqP3YBozA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM validates the user input for min_region_sz.  The same
validation is done inside damon_start() and damon_commit_ctx().  Remove
the duplicate.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 11b70d0a9a6f0..6469b25cc34f9 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -208,11 +208,6 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
-	if (!is_power_of_2(param_ctx->min_region_sz)) {
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.47.3

