Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 521ECFD006E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5331B6B00A2; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B8D6B00A1; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DD86B00A3; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22C2C6B009F
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D46681A0723
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.27.3A1979F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27FE5180002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nd9OgLsT;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlhLG6107iW13b6rm94JYsvnIA17UoldCwGkO70pgG4=;
	b=VIE15uTNM8gL0qgEKqFSs9rZM3aBqnyYBgKcwM+OdR145jk0YenoVjGRQIdmtQffB0q9fL
	vTHJAUlVKNeIODylGm1IKKhCF33jbvyVPmnE9PnxKAfL6uUVqA6hf+8qNoVo/IPRzhydHq
	RanWjEkjXWE+7uANyKg+X6Tfjgz4wJM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nd9OgLsT;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387013; a=rsa-sha256;
	cv=none;
	b=W8dpJt2UMlCN2HIKynoKkm4Xvb663kzNW64pHAVvANhhJO2egc1vwqGB/3sNHkgVXbumkj
	1ZWCRDtDpqYBiI4JjtNfkgRVrVb8Gs6rsm+jjUS0xLRtsPr5LD+IYkV4s0vySbAf3aV5sX
	pSX1p2g9krOeVyWahb5c/B2JnZQKi6c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE7B44563;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A768C2BCB4;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387012;
	bh=zFDrPDtcwfulSyFJOaJh2lietZw1gfebL6litU0OglA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd9OgLsTu3ecaX5TcXHYptFLk841w3Y6SNtOGO/WiO3U5igWi7VKyhQGO+0xY/IZN
	 CB1lRMIvdtpVfffuXIwuEoEAOEJrnomYD6d/Y9qNcWbdwcZtBUkqVxccMqOAdUdkYD
	 DAe7rt6WxIetT6oStd5OPJRULSsWArXOSzyoHwDWXHeHiOJMTp+66u5FfatpQamtVy
	 jFGNA7UirHT7L9w2YY07scAmlguyKpWM1yXN7kwb0LFhSs0rnztQlQsTRxhK/wYU76
	 s3HNbVT9S6htzjOSyrA2Exvb6Jg44UZMlxWlXzaesVddxPIqenY4heH0E/jPhNBMyD
	 Wq+6dZgV8XiRA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/10] mm/damon/core: add damon_nr_regions() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:19 -0800
Message-ID: <20260301174327.76849-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27FE5180002
X-Stat-Signature: batzmtxw5kn8yfb9ditqq9nfx8npsmuy
X-Rspam-User: 
X-HE-Tag: 1772387012-97427
X-HE-Meta: U2FsdGVkX1/0VZQ+6O5mykkEjVBNsxsZRfeTc57cYugbJuzoLKWWb/qr3Xr1n6jxSc3Q6IXEJQqhTx9NNspHTdGfCqkrmBfNRfQ8XWcRv09uYqN9tMrQIyQgbfCfaNk7ysLv+d1n3NniJw98ZUsOQ1YdsVLExnF1Qp7x7M0Qhw3VWsVX5Qi7Q2Ckt3+uN14yvTu9qycQGJphRALkaKCzPyYAbBkNdn8N+M3B55LkFM1+nerb1dYu8HzTsDWKVyhcLhZydUdNQoetEMcxV0pPI+Bv5uQ5eR6ZClavycVzmC9cvJXJlaCMqXsaRK1x4G6iU7hCS1Si3yOdOl15Z7k25MuNgzbl49EdpkrcLHw+KekUjfu0oTK05ca5yp5HshifGjnZZndYjUbVKiA6zKApvtRT8D8x/myAmxw+Rk3o63gtWh5Zk78wNPVk7GqMiF53AMczZY46doE/viZCKtFhFWmXqMmXuiojMDM3I2Fw2tnHqf9esEJEQBvvIEs+Ha/vvXRorviUL5pVxjDG5CpC7usQpvLkXf0txK/u1gCu1v8v/XglT0EUe7k+zVbc5Tmjz7p0XamZG0exsGY77K2C79i6zM+Anr9gu9GRy0+R3LhQsB88z81IgL+Q/I+uKEgg9GmLDZN3ixGU5uzOxLFwjRD/suDox6f0SKUwSzgclkj3xdhAaXXQbP1QprRSad/7NSmi6MZYBk2wCJv9vSqJ8GTHcojk5INb3c4IkoLCt0rV7C2fFgdUz8Hdduk7P83vgiJ5GdLGIPrOBp7G9CAymIT/Q58CJBhnL/wIwagQzuVdD8g226Qe3ouk9SKo9awQ+lUv2aLDatI9vGKAiR06jIiUS4EFyIxfa8jrhZymmTnybFgGsGkvHlPgjGCPlF+m9m/HitJWQru1LaGzZEyqLsAxTRG2XFxGt2a/dGoJGdPbo56wiSBVq+Iy8dLIHBmmGwf81yf7ev7nPnztfOY
 lsBigvb7
 d/rAPKiVF8gpZ//BawLDP5w+SStqY5BEPvkVLd/oWy/fWKaYyAjJmYzhDXhECZhCILRD2uyfg/gMIx5ulczMnadJuqQsGJYuUPgmb74kMyQJ5z7t+CQ7yiaUR6ZqmGx3raM8P8nJ0y7T5AaNZ6ljWPe57MJCqTtcbAJKgPg60caI8IKTFfFyFqtt2oQ+9iSsdJ9uc5sFIbAC86XTnVCyxZNOI0xsFGyGurN9Zbl/IBmqV7bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_target->nr_regions is introduced to get the number quickly without
having to iterate regions always.  Add a sanity check for that under
CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 92eac5eb96026..2b5aed89d449d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -545,8 +545,27 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+	struct damon_region *r;
+	unsigned int count = 0;
+
+	damon_for_each_region(r, t)
+		count++;
+	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
+			t->nr_regions, count);
+}
+#else
+static void damon_verify_nr_regions(struct damon_target *t)
+{
+}
+#endif
+
 unsigned int damon_nr_regions(struct damon_target *t)
 {
+	damon_verify_nr_regions(t);
+
 	return t->nr_regions;
 }
 
-- 
2.47.3

