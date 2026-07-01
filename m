Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F86C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4FB6B00BE; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8B16B00BF; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0F56B00C0; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 994E06B00BE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23A1F1203E6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:30 +0000 (UTC)
X-FDA: 84940488780.05.EB232B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FB5A4000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ef1kytGx;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917308;
	b=wTBfgIuExN6n7OaRyLulCy1DmIH3H72voL4WpNoayBIyPrh9ZtFSDiXucpKtJt82bOJEoS
	A4FRJrq8wW4hem/1pXswViuKifJK0npoHBbgqiKVPXd+2+IlngVh2Bh1Fb1NO/pXiUd5X/
	m3hPq8C/8gzlv99Yg3i0Gw10Qic+MrE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cBYap3I/+j4x4ct/1Qkcg1MmF7CxIgWC1JLwxymeuc=;
	b=yN0CsSbmPPKDTD0Tgv7a0rxFURrFwbMJwJ/GRvaybeyK41iRpJUoZKE2tdr7KSZIi40qod
	oTknfkaezp3S12r9djs7m8Al2cqhkJA4Y0grzdYwOmVSqF7LP4ohwFq8uocvBi3NhWOPu+
	gXgo+eqLgeRV+dVgvPG8NlU+oXYKqhs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ef1kytGx;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31F9B601DF;
	Wed,  1 Jul 2026 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991B21F00A3D;
	Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917307;
	bh=5cBYap3I/+j4x4ct/1Qkcg1MmF7CxIgWC1JLwxymeuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef1kytGxIlm9+IeZ3gf6w0dQ6AIqWkP5gaPwK+NBTWchJf9jk80+9vPq2C8lxdtLO
	 SC/NZ/iuMhPJieCxVpZnTGcSgbuBPIRZZ5r7sUcnrK5jeC5dhtpUZn3lPR6GfQJMQI
	 /Rj9OJ0cIW8oEQ0KB164m40hrCmKWgksmERooV3l58FtacpjrG02qHsdjBj4qMlAiy
	 6jLgahisGpdMtsxE4yzxoElgB/5Qz8MFOg82CN9hST/szLnbxCTRZ1TP8upM7G26ee
	 vHXvA03bBRT0B7wG/OXjWDah6xTDBG0nc7WLiTlUGwmATujBpOdfQ3yoVbzcgCHlDQ
	 EFkpz6GhYLK0Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/8] mm/damon/core: remove start, end check in damon_set_region_system_rams()
Date: Wed,  1 Jul 2026 07:48:09 -0700
Message-ID: <20260701144815.113325-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x8ccij8fss8ihufxhejapnnp9mrik8y3
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FB5A4000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782917308-860671
X-HE-Meta: U2FsdGVkX1+NuptRDwIYKqZU3Mw7PNi0SpG1YWvAZrkBVYmOzknlz53dn3UbBR/AR/erzQVZsQkcqz+qJCRGCJTIzu4CNfCjHwxSVWYnDIMWfP4G7Pi8+kSOQiQn2NhBgXVhBe1IW3H+Ue1qfqKFs8bq99C8ZjPkcedfHlDkYE74YGtG41Q91pXIsk+QHXTP+d1cjldQ30OlBt1qQUeglNf/5G+4/F+22+PDb9WFA1tCNQSPLsR5vscvk/uKKRgzDcg9VrvRbCov3iiJUZiLEQQ+WdiCiqVkoeFfEvtTwTy5tiWDtHMsk38l66lifi6aDuTtdEnsuCM6HNCaWdSomEN2UqqkrOMrjd602+iwqQK+OaVVWjIkGN0oTHl0QeFtvvhxhCE3Avja6HXo4I6gq8lPd30QlPnuUdO6ZFH1ysA/zF0prQ6go5D9nnzS8jVAfSC1cL9uLKAPjTn0ID+5TKDM8Hwxg9W1wx4HhUPeq/B6rWK0ibDwmlF4z5lSjZhAcFG+kwtts/SKQMP4ONxhI3m4xpcA02Dk1ISOKI22afj0BE5PehHtxnecOtgJWxRBbRXYn2oFJ0/1LWhSEkYCGaTlpYhK0wCtGzgw9PKj3J09WpVm2H8/Cqw6mq5GN/O8j394398ILZaWx0aD64u8c2HUIQGAwPUKPKZ2YZUQ8rv+wkwHkJMYLsHPd3DHUv/Lz5s/qrksmFy9Zr5T11dPiWXf4XjUa1EO4RWpY0Di1Alx2/zM7nzQr08FtFeDagSYVGs1V6Mf6SzYIhz0CPU9TGh//2jXwR3kObNGy8422yXjACiv2pK+NlsFv/MKrWazy6lQLhzGYSh9ztOlvbRs2XrExsMU7502IWJqgaq9Wtbe18+gDKcPkgbUgXZF+XPacx21KDrclUWQPlrCOPT5OtDb82v+QiZF63j//2iPtBCwAylCsCrVS2xIwJNRoAqUWSfKLhKaPOLkuf0yijo
 ST2IMAap
 NkYwH4/F8tdMtcdbJ1butc2M44GX1r7UsXYPX5cy+MpCFlhmwwDmERAMsUzU9K9HuymFBKfi/wERhZ3gAfc03F5bb/CTiM9+nP5uCaQ1W8D+U259z5tg9P9GqHfijhC2hJs9j2g0yrFGOznbzV1TC1GRvUNCT6c+FWlSvnBOq+Mj7GDHBp/6Ysm/lonJ55B0hur17kYClCfgVtbd7nO15M+gM7KJ2vxkYRD3sZOwkAO+Pr5KwumrwRuOrZdaWSFf8mRgg0QSN2GDyqfZzTCaurdPzlc+MYgPgB1XjsdprNJ7Mzl4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_region_system_rams() validates user inputs to avoid creating a
negative size region.  But DAMON core avoids zero size, too.  The check
is incomplete.  The complete check is done inside damon_set_regions(),
which is eventually called from damon_set_region_system_rams_default().
Drop the incomplete and unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6b30cb6007e54..3caf1b67a7f98 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3847,9 +3847,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 {
 	struct damon_addr_range addr_range;
 
-	if (*start > *end)
-		return -EINVAL;
-
 	if (!*start && !*end &&
 		!damon_find_system_rams_range(start, end, addr_unit))
 		return -EINVAL;
-- 
2.47.3

