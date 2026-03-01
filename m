Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16F6FD0070
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B0F6B00A3; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA536B00A4; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFA86B00A5; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A79C6B00A4
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37E93140712
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:35 +0000 (UTC)
X-FDA: 84498216390.04.929B4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7D72DA000A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueWT0qzR;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cohzFR+Fkqk4yeVHVwYb1qMVYLZSsO17JhrlF6ZSKWU=;
	b=WYKSXL2uJgsNgBWv/Fqmy8YtswMMA1VpTp2PVT4124CnBHeC6gAKdo+7+IcsWgSep9Zn+U
	9v5zDeLBCJPjNwsSNoxFtdTntXWLkHdzaP/GEZXGHtCZTEaWXMHlwI250eDGvhelw9nH2M
	rIpwkWWPfKjR+EFU1km3gtk+IInKlKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387013; a=rsa-sha256;
	cv=none;
	b=J3ZhqJsa9swUGL9lHzjRaIs8kQ6EdT5DlV/j9FVDnYj7MpuURFv1zlDHmPP+DRJwbjzoCQ
	nJ0VWY4c2tznG/mFBMyIDzR0xLcAe7BD8F75lqWdLCGpWNE4WtpYc4Ww+ivprdNi5YeHdc
	D5mu3Pu+/dA7xvFPG/ctprOgna1VycA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ueWT0qzR;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEE804455F;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A51CC2BC87;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387012;
	bh=lNQhvpFnr2Kehya342ovbJrx9ImZU409SPVoAQ9GUWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueWT0qzREt2g1pwPwkGPIZTz9xG0/SvYZc6z93JT6hmlqnNe6AYJ88hvJ0Osz/ALy
	 E+cT8yCe8UfCarWeZrYCVlEnuy3A19e6v/OvcnyE+UXporJywZr9NfE9RrF4eLTJwc
	 etNMcHNx6RjLsli/LHgiwjSsggUKUZYC8mJbm9sH1AXrL+Xdrc6VP6/3eYKN/J/DbQ
	 Q/oYNIDgbSLdlPdq1fllruUohQUJwpI4brKe/a2JUQwOVpWdVWiwzw3Vs+gqkiptw/
	 9+Yu+VaVnQkXvfJLRP48fFbmGZQDd0+bDYAwQdcIQ5af96N0L22jpZ+SQRCgRvs9CV
	 jmYUV4H9kK0Iw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/10] mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:21 -0800
Message-ID: <20260301174327.76849-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D72DA000A
X-Stat-Signature: w8erdf3n8ss84ctukuhstb7md4qp81sc
X-HE-Tag: 1772387013-369134
X-HE-Meta: U2FsdGVkX19Wf497R/a/RTVwUJSoDTKKbOlvI341MwIH8uIvY18v8QaxE4GU66yHp1cYX97T+ec94+O7DVz5dRBCMSkoy9ZAHLRBO4cLITY97zoGEdcwnGW1/UvKH0eW00NYDguBIv46hRgYSTcv5EuBtGEuLjVFYPG+Msj3MnEsQp69oGY7CxVvMkAjcZJr+fvaDhCR41sYHdqYR1WWr5tSqA21RSNijfoeZkeFM5iSH2rECZTIKuhxla1aIywLDE1YByZvtlYZdbTq2wCEplZWg+j7gGyVqtl90PCw/2/VXFiYpEKdWasjnQqqJSgtJyj+SRHW1ms1LOp9hpRw1pOoPt5zL6PRIU/l2OSQzwIrrsf1ubE0lg8oHfAQxhjq7gMuqJ5xRGfGq/vIz9SvpS3GvPHoemjKfv7imgeI+qo38q5FcBbKLyo2l4VpOIl/RCMCG6abKOGBDQGqy6yoZv5ybRCFhF9sq2KHrVNKx1c5fDeLYIQlByoRKAxeBamFNfvgsQaXUxgORQIJq+lofgrwtgrth2baXDWRiu9WNy5JQIj9my5vwR7LvCQ2/Ec/I8Rj1/Qvc0XKYoC6AssykHaEw99Ck243SAcey66fno0WrZRvFN6oj2DMXgUkFfyuyOmheDXmTU7BpRJSBG+i3IP5pO2G2BT6bMv0Z1aGErS9Au51m+po3qrzGVdOWCVEue6s3GIs0oG50+Ezp9Z0S5j51OcnTP0SD+iAUQ7UtarTke8TIm7W5X+d3xRMdnsd+jNgkJbhu5o1Pol3Gh5EOxDn2BcC1yVZY3JMK2L/Qrpch6YJrDfZMqhY/XSeKe8SE8EjBt/NKehkvu5AjlOtiva7LZK87eZqOnGAJ9EOfA9PapjgoBxuvAB1fg+d9loQoXnxsMGGOB+6Ev1QTeD50JPCkASilThL0c9JD8v7GKTDdVZdAyrV0Hs/yepqCBS94pVuZf4escCDkXhyW01
 M5FGUxC7
 akIgZNp1h9E9hFvf7rp8SWmDoqJqbrXYJck05qIuWvNWZFQEqfkUXT/ryxdsEy4R66cb7iETrJEaq0H0WjfJeKCZ1RUphu9DkG+w9rbj7oPAPXQYzZlT7ce8gVIi/6Qp4zSa3zExTxdVNuKfaCNJl7VB40cAeUU9NRJ3Ve+w1ML2ODDMzkmhZwTTlMxw2vC6J9JfmzzYezWYyAuA1OEWyE9jKJ/0CFZUBJqXqrdLLA7fhv1udsm8SS3NCWeaKM7TIdIAMDYWo9UVUPe2GiWr4cvKzGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_merge_regions_of() should be called only after aggregation is
finished and therefore each region's nr_accesses and nr_accesses_bp
match.  There were bugs that broke the assumption, during development of
online DAMON parameter updates and monitoring results handling changes.
Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8a3738a17cdd9..93d1577b1ae07 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2505,6 +2505,20 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
+			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
+			r->nr_accesses, r->nr_accesses_bp);
+}
+#else
+static void damon_verify_merge_regions_of(struct damon_region *r)
+{
+}
+#endif
+
+
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -2518,6 +2532,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
+		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

