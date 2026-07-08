Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECEB5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA70B6B0095; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3E66B0099; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6E56B009B; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 839306B0096
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA50F1A0621
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:02 +0000 (UTC)
X-FDA: 84963885804.05.160E581
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 665A640007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heclTDqe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kBkRo862BPXwBpQ3hpxe1i0H8YwLqc3ssoJnqfIV6Y0=;
	b=FIX5WW+UDn88JgATNWOX9fD9T4nsIA5wVBoJ/Ni5tKTFqefIc1+6Z9esa57KFCQmp8EAsR
	9UIKoEjND4onqinkC4PKXqZEyW0iV1WxHPWsfeWGb1HzCDlaInhSn1idh/DEJR2BKMGenv
	cLeBMAstmdQGcDIWoGxzuMp0lgNR6hs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=heclTDqe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474381;
	b=KPfeioNkC4N8aovvV+3TpKxf0Pv3Z+TF2pM9eydhnTNQXnMPL8WJ/WMcrLWlJE1qJRQpfW
	pZ+KztWF1hngjgJ75jAJ0p2HJYJZD60XB0n04sF0MMxjCBxr+xTtluGlI/Xg6DYsmq5Oek
	zqB/m3XytrIpFPGzeldpZo8CFgPwzrI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0632D6111A;
	Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB21F00A3F;
	Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474380;
	bh=kBkRo862BPXwBpQ3hpxe1i0H8YwLqc3ssoJnqfIV6Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heclTDqelzIekG/623CyypPelqAkSlRKqmiD9kNgKNjZlvl7P3OjN7wp2jZQmXQeN
	 MN8UTOd6OIgoV1Iwoh5f44qXiY+LT4DduN63cmlhLSYRrRhMJti61K+amLF15XtzwN
	 XKgcLDpXvJfeMcsEKqW2TvtUVMFljAooGW1pyLM7JNFVJliBleXVawnwvvIuxEJ+Ul
	 09kVtdjB/GG1B5u7lOVsH8MAFJQIWlyVKyFKeD0m2G2953uPEurQQAYY1HC/iKLROt
	 d4turGu5ecfBAmkZbw0Y4syBRZBlEmqK5uTqexksn2oT/dLUjrHioPl8u8D2jMkFGO
	 1F+aCf179RBtQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 6/7] mm/damon/core: update probe hits for new parameter commit
Date: Tue,  7 Jul 2026 18:32:49 -0700
Message-ID: <20260708013252.95888-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 665A640007
X-Stat-Signature: kakbqutg5i18uc4xegpzgmx3mqi3ub4q
X-Rspam-User: 
X-HE-Tag: 1783474381-140360
X-HE-Meta: U2FsdGVkX18pBQYfxJ0+NxjDH3+qc9Epzi76PDJTE3OL414x6RixQQdAkLrWrY23qfRfkVX1BBnGrGr4fAg+XzOi1I67KjdX6DFzGOQ1maS/qEhlAODXD59jNaPxSolqe8Gr0FaRtAZrja3pCBcDnxUFEVNaoziRZpnNyiWd9LV80GUs7efO4xVfTl2oQi+kABvnBc/8Ekh7oS76vKqiExXnCUMCsntLlIr8UD8++f/m5BT/Pq3ZU7kI+5P4AKt0oYcm/AQKySjfmrDnpWVR0VLknhJaqP8Cxiv2aGD25yRPBsn9z/kmhX9iITDklHRvZTecXjiFzpTpPp0gvQLYq4hVnfJv8nxCroBRytfc/Bikwh0S5TktihCmSBbNA9QDAZUxEpOvWVAgfupdTzoZ/wwYE3LFXAhF38XwpenhA3uaJwWmNN2/w5B8KBBys4ZMuupR1Ye5pIRzP7VhidAYNLFfeST28vXk8D7uUNlxnVmqjtdrN6E22ipc8QPAVS6OJnY+Yn1Rqfg0v9WmwzeuOfbyV/HVeMwCdOIOz77Uk5vRXCSYquQcouZ8zS4hKpeBAApEqgCa/FGJTDQrtHUfTngWf60s6atVdWR/rBsps+gmZ+nNvuc0q8H3XdMY+DHMkpuR1I7MaXSUfF0py3g14ScUUbj30IVec554pmmthYyLTlW9aHYkjELrlifT7rvsX5etGwET2TaHwTGUqNWcrdoyRZxv6YbC5ZY0kZwVLhwGPnENdn2p52iN/mIDnROmaZnT7at9mMV8z5YIIDwb7eMI2bqLLcZroQ7TI9evz7lYSQWs/eBTNzbFZxTvk6gkMl+GAbd+/cgEfQ4aeSWigtBqi2vjRoQlV501NK0AQ4Nxwq+E+pGadX9mkRKwDJvXBWkcDEtck6HeZX13xBUqNFWAZk8Il/PZwxXp20aDryBgJlJOBZPoCS8HANKQEbW+8ilRfd9tvxbUyaPAf4a
 xcyYpxTh
 GumtrtD4kNR0q8VnY1ruVj46wCg0NTMZfEUlgoO/z/Z7uD/pDRnCiHNnCZaOIF2oN2nqYhL0AM7/TPpT3rjBmaxaFbEPH10vLeZfwY4OkvT4xrE4cRMPTfh2+j14T3/DsmunYEabKiBsnGEu+Gk8Ct4iy6JeeKifdq9BEjfLptG5YbEnKuAl0+3+Br5/bqn6FmOeEojg/ARZnMddneZdTXyI7nfyiBHO/T2mtwVnsis3yogE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can update DAMON parameters at runtime.  If the samples and/or
aggregation intervals are updated in this way, monitoring results
depending on the intervals should also be updated for a more accurate
snapshot.  The age and nr_accesses are properly updated, while
probe_hits are not updated in the way.  Do the update.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 28 +++++++++++++++++++++++++---
 mm/damon/tests/core-kunit.h | 13 ++++++++++---
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 800ff6b6d2473..15d31285515d6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -897,10 +897,32 @@ static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
 }
 
+static void damon_update_probe_hits(struct damon_region *r,
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
+		bool aggregating, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		r->last_probe_hits[i] = damon_nr_samples_for_new_attrs(
+				r->last_probe_hits[i], old_attrs, new_attrs);
+		if (!aggregating)
+			r->probe_hits[i] = damon_nr_samples_for_new_attrs(
+					r->probe_hits[i], old_attrs,
+					new_attrs);
+		else
+			r->probe_hits[i] = 0;
+		i++;
+	}
+}
+
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
-		bool aggregating)
+		bool aggregating, struct damon_ctx *ctx)
 {
+	damon_update_probe_hits(r, old_attrs, new_attrs, aggregating, ctx);
+
 	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
@@ -940,8 +962,8 @@ static void damon_update_monitoring_results(struct damon_ctx *ctx,
 
 	damon_for_each_target(t, ctx)
 		damon_for_each_region(r, t)
-			damon_update_monitoring_result(
-					r, old_attrs, new_attrs, aggregating);
+			damon_update_monitoring_result(r, old_attrs, new_attrs,
+					aggregating, ctx);
 }
 
 /*
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index b2a280556b841..219d02c98624a 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -597,32 +597,39 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 		.sample_interval = 10, .aggr_interval = 1000,};
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
+	struct damon_ctx *ctx;
 
 	if (!r)
 		kunit_skip(test, "region alloc fail");
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_free_region(r);
+		kunit_skip(test, "ctx alloc fail");
+	}
 
 	r->nr_accesses = 15;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 100, .aggr_interval = 10000,};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 1000};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 100};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 20);
 
 	damon_free_region(r);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_set_attrs(struct kunit *test)
-- 
2.47.3

