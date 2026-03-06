Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A55FDFCB618
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2C366B0092; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC16E6B0099; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F9E6B0092; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEB06B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 242ECBA310
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:26 +0000 (UTC)
X-FDA: 84516022332.01.9807084
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 810121C0006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:29:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jV8uMcTN;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772810964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cohzFR+Fkqk4yeVHVwYb1qMVYLZSsO17JhrlF6ZSKWU=;
	b=7I2V0X2xj1LXg4BKsnZSmQ+gZnax+4BpwNj2c6+8jlbn0PKX4cynMJekTgez+9pa46cJwT
	d+90H3Ya3nCHwpGkXaz04ppoI7f/MeH6cj3Nk/+Aw/btUCF7yq4+qNCE36NMqtABrDfKHh
	ftWf8JUHkgml+JFeI7usHOl36kEvM2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772810964; a=rsa-sha256;
	cv=none;
	b=oc9IYXdmeV675F8jvEs/SzIZ6l49ZcuneZX204p/HRfTsSxEcJK1BeVB/7XSFSBtGTRZWB
	csi6XKEwgpdAAym2q1iHGCGXEZDmK26qds37CWus4BJzz9VwGuCnJzzWlXibMz1/mpkoGm
	L+80Lv+vEsm+PQtq1LBghMKCOmBh1Io=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jV8uMcTN;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 747BA4457C;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42347C2BD00;
	Fri,  6 Mar 2026 15:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772810963;
	bh=lNQhvpFnr2Kehya342ovbJrx9ImZU409SPVoAQ9GUWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV8uMcTNRpQluGW6AZdtbiWhDl0ty9J1UACsJDbieFyAB/TuOa6BFeYza062Ckht/
	 yAX0Fff3ExGhQdexGdIhS8o3KmHnhudqZraQ2bgFlfj8ChnNp9T6lHRIowTahiHCtF
	 wdtW5Y0zzcW5s7U1+saWdzNe6rOmmKRWDW1VaYXadzF6GpT43ZfmSr6KAqocnpsqmx
	 gjwG1yDnm2Q68hk6i2aGz6Lt+xz5FM8U7+zhsm85mFmInuaACW5ljvr1HxdxzzWMZo
	 sj+QnyOWBRTsvnPFNUk4w6CQKfl++7+5jyJFq7RR4QtJpimQxfRJYel6B852BuiXu0
	 vTX06q27i7eNQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/damon/core: add damon_merge_regions_of() debug_sanity check
Date: Fri,  6 Mar 2026 07:29:09 -0800
Message-ID: <20260306152914.86303-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306152914.86303-1-sj@kernel.org>
References: <20260306152914.86303-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 810121C0006
X-Stat-Signature: 558khxxxzscjaszgmgemnz35kgr51ntp
X-HE-Tag: 1772810964-994340
X-HE-Meta: U2FsdGVkX19eSBa6yHm+xvLlxNG20ldq3LrT4B+HK/FSVdR8nEGX0XNLKxCaNMSIu4O4YFXOFgCn/446hJ9VnNEjBTW5pfjF5kZNUWzvkKeGeSfPyqtdPqeyj0ncnL9jXj5cbp5zza8vn0L9m1UDEilS+bKm30jqonQJxjaSAU5xzge3wa158wgm2CikUAux2FFF5LLzbW/jmYaB20+7RobEN5+O1NOKfUAh4V0Ve0ihLYkx8tm7+s7xxlXAXwgd1mygkrxEhwPO+FGKGvee2n2sigVqms0loP3+JoXORnPCy2NDCs4py3jV0BXmoWw9aVRxbbWBfRvq6gCSJH9c7IqBXjNqj/dAQWHWaAMmNatwrFwnJYobKO7hfzANC+OdI9jDE91nd3kQez/XpLTFLkKrGymYB0Qkg59FThHge1Yn9P0j6bizTCzVqXSsMCc0CTK4i/52E8Jmym19dcdQRt0FfrHxqg1/goaddvd8w9fnK+faCoDac4AVK7eiooVABGl9iwB/vvS/hknTvAg5sgKH4r8O6IPf/j+gwiNZa0fwden4cwfiwvpLtX5S5RG1cWCSfNIhKpc06ReNE1vR4BnvmxGTw4PGzS1G35OlDNahFDHJzYKYl67W3eG3J4c2HcgJ9ub9mnEDxMC9o0WaSMECQcmnmJHDcZzjOJOdIuduuppWfTR/BRxFISieXHgzOqTL8k9T2gBXD6zh2u1KxkW0HF4+jEOIOHF29aeq6zPtzr8QAVZi/w2KRjvHGm6Rh06i///QTUIO5yWrYOnZ6/MgHpr836xmo+68sF3NW9wJ8/nhL3HCIQj/0crz9vb9FvFwEoWh56IvvZ1BVRaBpHnH/UAVShJdbE89QDKem4fqr6UbAAIaUVR32NS3w8qbcgBmBaJoM/OwcmfmG62lEKaViuhBR01LnShBlaLufmgoINPyvhGKEXJxgvXj4dnyq0fxaxuWpOLEAgqnGdI
 uf+IT+6O
 7PnUg4qWBKIfy5G+dqkD3eEt5usG1rLWK75emtGtFaOhY1H/dSJGjCbt42yM0TKq8kowW/LJVk+hKt2+4FfXEHNmOsN6dAzkVy1fUnXAon8BYFw3+Zt+0A2LWzn3gl2cGhhnKayp7fbZkYxG9SWCn2N8KXizGEea1p6IwvEMAQt9lobLLQg0ZcOjiJ1P++4MRWCpxPWywBKT4Xa62lse3hXj5HvnH9szle1Hx94WBMTnslSrLSfzUZaO4piL9ACRr4TwrM1gzfquG14Xl6brr18LTkA==
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

