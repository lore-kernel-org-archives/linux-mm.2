Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF631CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3786B008C; Thu, 15 Oct 2026 01:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75CB6B0092; Thu, 15 Oct 2026 01:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963CF6B0095; Thu, 15 Oct 2026 01:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 653756B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:21:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3C0CA854F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:21:32 +0000 (UTC)
X-FDA: 85323712824.10.DC43A4C
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB88480009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:21:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=xCFK7NVg;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=XV0h6kJy;
	spf=pass (imf02.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.147 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792041690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=plxy+DrT8Ze0nim79TR1yOEuPaMxj6VH3O713CTbSuw=;
	b=o8RoHZi3O2cnC235GmanepcdJw6xAgHNBxlEEGW7nSFBstXq2gC4CWpr1p71Mh+eCeMtYT
	2xrx7hrg/ijK9I6ckebUmkGXAQ2iRa+jF2fd4vYzPQnKh83DhNuKUWR+VQnwgkEn0CzpgZ
	lRM33zLYxXauygwPN/ZFTdmrXYPQkGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792041690;
	b=S3yCqnFeRm9Y+Q6fDORrQuWoOpYeqTma7uoLv8zElanWL6yjQhWRbj5qAnyx0DVwYh6GOn
	ItzD6DQ4SK+DqPA8gnKKamnWZqUk7tWoT4GFMJU1yuzbL82sEz1mkgKvYRoPJ1mig2GODI
	tAZNG4KVaIUF36k2cGOiL4b2R/OK9hw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=s-joshi.in header.s=fm1 header.b=xCFK7NVg;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=XV0h6kJy;
	spf=pass (imf02.hostedemail.com: domain of suhaas@s-joshi.in designates 103.168.172.147 as permitted sender) smtp.mailfrom=suhaas@s-joshi.in;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 74235EC02A9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:20:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 08 Oct 2026 11:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s-joshi.in; h=cc
	:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1791472805; x=1792336805; bh=plxy+DrT8Ze0nim79TR1y
	OEuPaMxj6VH3O713CTbSuw=; b=xCFK7NVgs12YR5Os+1qjKUQTdSiWxqgeaTR7+
	HdLBT2ynFVEJm65+tI5UpZUl6J0JMt6zSveTLT3+beQyDHidKSONCVRIB6X66D6e
	nBisnKjkG+93qLtbVqS5f4PGuG50zhsBZx0wpewxgNYRa9A49UOwu4ZTgChOjBWt
	eQwzyfjuRJUtAdbtFPWSwvOVwR+q8nkxiZLtmTwbmTLMlsNo8oK1JczusEyfiOvC
	Nu94JXVh1cMHyT/Lfnq6geg9XdG9CAvtE1Cg6i8e0WDhc5x/5htdB4L3d6C9ewKp
	xP7zCM+x743Aci9qlludrOMWnnYlkf1D8peD3C6PSkKoZvOnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791472805; x=1792336805; bh=plxy+DrT8Ze0nim79TR1yOEuPaMxj6VH3O7
	13CTbSuw=; b=XV0h6kJyywuq4uTCPPT+vlRvFV2CWZJfS5hUIci9ETpt/Inwfoh
	JdyoUH+orjCvLwrd9cOr+roDiYqw6AYuexLOJ47Enyc8OFbnMI4xbJubSQQ12YYC
	8EQgHYj/Q1tyY88DGZOawPirgcOfCcuQLyUnz30qooL+d0/PVXJF9nCGKnf2sbnc
	6fU6aAA4DTuLDKg6Y2d5T3eBsWqVUA4P9mE2YrkA5zoifdFaLGM3wAap8mvvn6JY
	NIiZM6hGl/J0UspWfU/f+25+I7EqT7b6HUqmiriGIX81h/kP9WPJxBmuhyJp4bQv
	qXZ7sWRZ4gz2+C6PrZX/0V3nr0hxZzqh0uQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=s-joshi.in a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791472805; d=s-joshi.in;
	mf=PHN1aGFhc0BzLWpvc2hpLmluPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:PRQIdlCvZ92HXYuQ05Pe+mjUvAwRppfELo8o54j+3V5whLv
	jSvlfd2ItjXA0FEY6EiVlkBNfE/u1+YpMknqOkP5bP5Oo8aCazv9jToQEQDpDhV8
	ZerkBs6iR8hMxYWdDjGOHRTXSCzC30kS7F/NrPRzfS+3AZF8sYOAepLk704I7ldE
	SGcXjUmQp4yvl3K6eQ3ugHwEZzDvMqCfR1XhlC/HxM3m0aDnENEvimQOBQIGeo67
	+2Jt6Xd7e1kCBCg47kmGXpFufkkgaBZRGZk3OLKEe/tikC8pAZBQGQ3o7WI5VKLq
	l3GOXHSEmkANahtJwwxG8H1tbBYq0rqn7mCn26A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:rf6ufOzkNZa7QhG4kTdpPLLyHMZLstPqQjFG7FSWTOc=:5syrNj/JLgLqlg7IRGXpYcJyk/HNi/mWCL7GsaEOynw=;
X-ME-Sender: <xms:pLTHakvaYYI-n9-yyKB9pcZ3LPqDNpK-FwMA3RjbVNyLmkWVnnIQ5w>
    <xme:pLTHaiLCnEOZoJ84DPrAJGjAF_N6eQn-KTPOCozUCoe8rakKYLMJVMcLmZOj6eijV
    KCWrq4_XSB_JRMSXc828gbEbd5D_9H2RftZPkLWVKCkMNVH_H3iFRs_>
X-ME-Received: <xmr:pLTHat8INlt6X0w19517Mx6gm20tn60O6Cbfw8JSQFy14iighyFvBdvl0g>
X-ME-Proxy-Cause: dmFkZTGqxKJltKcxARJadtVktDBjtkTJW7gorgTB8Ld7pXgguWgs5hqg6/YGAbmf+3ndY6
    LjqKDAI3EvH46oJqR0tWDuKjWnqcBAK55NEqWzEvzSxNjp+D3hNoffq1DonGlE89pCLzx7
    fXzqKf8HtHttmd8QNutoRFIK6OEt2nz179BXmfB08wXw5RFnw+OX7Fuxqses2X8N7pM0MR
    uix+e515sIDeirVi9i5sd9lgyNmtEz7/zoYfcBs4tM+ZskmEUvRGl4U1QHO9XkLYCMamWm
    3NYpzIgBUJjx0iK2KXMvacFbQo+WueYCOphdPLzMH6GbuCPBxPTTQWkkPdp7XlpaUmN+Kg
    fZmb6MQvaBT2/j3ANqZQpG7bX3bzTAz+HR674FVqrCnNETt7/fTIYJa6R2bmOeMn3xK86J
    sNYywAhEtrC+AikraNY+CpaxZ7swDj4/y6WXHCfvw0IeAGAazvJ/krqsF/UlegqMvxZkCI
    KB+WnPfo5WGXtdz/x/M80prHyqfZNxEuAy8aSCJlavWKyLvFqO5KU4Q7aYxSDmpzFaLF/m
    qIuSNaP5vgZ+lygJWy5PY6YYKVreeTw8rQJv9fJvMDENRDnemN8OWF5jyduYZV4jf+SrN3
    /24ZqrMN7P0km3ZBvU7n/ml8VJ5yRUd4TOwE5BChMTU4ral69GdY/sTnijEA
X-ME-Proxy: <xmx:pLTHaryA20PcyxVoVyL1vFpbYtAlPaHyVAkXsfAhV0AIjiVWDGjIyw>
    <xmx:pLTHaq4TSUMvs15Vy7RS-tkpV0k6gyPpshHqwnSQcNPruuw2gC9IrQ>
    <xmx:pLTHai-wnORkuU6EUKfcDIWUbkOXXM7cI4rxXrHBSJQpkkpxgz1GUQ>
    <xmx:pLTHavr74d05gvSYM-VsZ1efHAM_ybRZ2_lrBScrHQ-PMhOZF1Oe1Q>
    <xmx:pbTHahihQO3qK4uVQ4gX6QAwMwfKoLQe4WrIpPZ9vOU_EzIwmY1xOOpA>
Feedback-ID: ia9504abf:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Oct 2026 11:20:03 -0400 (EDT)
From: Suhaas Joshi <suhaas@s-joshi.in>
To: sj@kernel.org,
	akpm@linux-foundation.org,
	aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/damon/core: Iterate over installed probes instead of DAMON_MAX_PROBES
Date: Thu,  8 Oct 2026 20:49:24 +0530
Message-ID: <20261008151944.113714-1-suhaas@s-joshi.in>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB88480009
X-Rspam-User: 
X-Stat-Signature: uebhq5jymoym75di4zaqo7r5xq3uiro7
X-HE-Tag: 1792041690-234526
X-HE-Meta: U2FsdGVkX19Zct6FqOMJZ8qtl6WAncSQ7X3m58KRvix2PJJJIVxI4EmXzrNABicVJnQ5q6sYcn105e3g0DX5gBK3N6rTSZ83uZ8TbpbCNpUaUqGIZ4juSEDYNyPfCazPLcXi+MVty7vxSMVn91czMvoTG+BR/ojHqe0M2ZJrlwxU+i9+MIvXQSpXrZjkp/cm+bROuBsT0qCdApEWjfKrT9/JKAw/pxkeLhcFeIWY2YrT2jaT8eyYdFQUDDIrs41f7hBslqrV062cftek7oIxwh2X+RD7J8Yk7Ul6haSZ9eQziiiG28+VjwkV6Jkk6K2I+DdVwCAmVRpk04LDHYC+7wpyugUlilSqly1k5GbE+FfM4cciP5UDijlAFs6JZkFARJT9DU5o9+/2IAl1ZKB5yey6OBbouN2hZJ3ys0GpjOSFa1wpufS8Ik1RUdTrO3Pad5P8PEGhdGkswiiY81yin3daUDh28sEffomyl30yh2dYtd0kD8ldlgRQUc4MVCcKI8VqIf5bWklvos4jadcZkXBBXTFHC8eohq8XDcHCIKol/JIaeesYrpL/eKJsZ2/aqSS1Jz8AfX8suk8TtEHU63CtuklCVxZP+XgbPtD0FOZFuPB8P/Nv6f9xdgR4jlOUhKCCIIQFHb1QHTOwfhQuK7TbMaH0mZe9wZg/A7xP4uGNh8M/JmAjaw7ANkiA9Tr8Jxg0RQa297A6UsRYphXDsHn/CQQByru/FTUTs2I3ds6/6sLQ6ocg7JVl0Za9iSE8MsKOVfn5xGIWQBLEVOaZjFxUNH2i2TXIct/SQFsP/ia7c9JDoImGui5u08/nJQ4vHI8R417K8Rdd6X2SNNYsUqhWPEbdzB/2GODkXXe0+4zv+zE3FHxtCzuYhb3OIQSnhoB3gQb6rUqtLeP66Y0n18qtMQaVvHKVB6B2MLnwihzoufu8ODW559ht2/DY9jdwwLh/orVCc/4y437pNKV
 7IHhCeRN
 bO84RD8dPaNUuK6mORIxYN5yUqOH3oA/ecoOQCerZlbmNksESHfpeyHvwh7Kqc88rpN6meAPXqe7ip7ljK7t1c8+xWCxgMBCv3Ieb6xHSVR4HwrrQtk/xQRJredp+DzHfUfN1tX0Be3Ob/yrjl3XeO2G+ig15Jd1DeHt9l1LktX1Mvk4dsrgqc//dUv1nW4CxvUfjxnyekhwSV1wmp5qN5TcedusbvQljkBQf/BQhVT2aK349q3/uHFK0u6FUdsPI2lcgWIc0MU3UOP6QdEtwJbgfi3FmBwWMJ0Jc+A69rHAMZjlZsFonAasnU/vGjoZ82nDaRPSdVwJLHVz1IH9TLsOtmSqGYW5/qFYJ9KefqWyXIeIXzkHcctU9VpiED6aeKYqIDNnt6Q+awERgAqB87IBiKVZ8YkDL510dV7+yL7t2QToZU03cLdvFYucFehO947ki/LqqWq2aE/pQQfe4jGF5qk+ipO6A9ljrAPQJsAU3ODw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This is v2 of a series [0] I sent earlier. Please find changelog below.

There were two "todo: " items of the same nature in mm/damon/core.c. Both
of these suggested that we should iterate over only installed probes while
updating (last_)probe_hits[] during merging/splitting regions, instead of
iterating over the entire array, which may have empty/unused indices.

So this patch series does exactly that. It replaces the for-loop over
[0, DAMON_MAX_PROBES) with a damon_for_each_probe() over the probe list of
the context.

These patches are based off mm-new. They pass all KUnit tests related to
damon. I have boot tested (but nothing beyond) on qemu-x86_64. Please do
let me know if I should do any specific tests and link the logs here.

Changes v1 -> v2:
1. simplified commit message of patch 1 (on Liew's suggestion)
2. wrapped all lines at 80 characters (on SJ's suggestion)
3. added comments for new argument in function (on SJ's suggestion)
4. added damon_ctx_destroy() in r2 failure case in damon_test_merge_two()
   (on SJ/Sashiko/Liew suggestion)
[0] https://lore.kernel.org/damon/20261007154851.45368-1-suhaas@s-joshi.in/

Regards
Suhaas Joshi

Suhaas Joshi (2):
  mm/damon/core: Use only installed probe in damon_merge_two_regions()
  mm/damon/core: Copy only installed probe in damon_split_region_at()

 mm/damon/core.c             | 61 ++++++++++++++++++++-------------
 mm/damon/tests/core-kunit.h | 68 +++++++++++++++++++++++++++++++------
 2 files changed, 95 insertions(+), 34 deletions(-)


base-commit: de3c5f0e6ebc5e0885d99043e071320cbb6ffbde
-- 
2.55.0


