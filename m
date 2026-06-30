Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEDEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201156B00AA; Tue, 30 Jun 2026 00:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161F76B00B0; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E338F6B00AF; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98AD46B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFE16C1B7F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
X-FDA: 84935247054.20.2DC158C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5EE15A0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bn96ilo7;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792506;
	b=WJyG/cv4mmvT4X52Ph3jesu3q78ofwTG9NGFfONwOmCh2XI81q53eEoNXi/c8iJ4UQq0B4
	YKDz09fBY+KAYmYKloB5g5u/OXzuEBOTaIWYTMyNz1krFZvRgn3d6Lonapu453wxodcfE3
	CAd46SimopVOTlcxwyOS0+LF2NQRAig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ke0BSVs6s8s77whU08OQcfHx1Y/NV39ljz5Tc9+fVs=;
	b=ED+dIMSVfQDJ3pwLeV0o0y/M3IC+wxupoZd4b2FSUkGiUETXEkavyT1SS8IXk1G8TisQaL
	MvAt+KCXbP+fikWGT0qj9nt7Vp3XkLc6owM3xdWbLtozLhQwmG6YQgaSylncqEAo+Ox/gH
	66su3cqJ2nqCtws9Bdi7ImfEEtLsAmc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bn96ilo7;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BE0E600C3;
	Tue, 30 Jun 2026 04:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8791F000E9;
	Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792505;
	bh=1Ke0BSVs6s8s77whU08OQcfHx1Y/NV39ljz5Tc9+fVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bn96ilo7xCkVl4QWUbwCr4S+UCNx6NUT5nOwaauTVtWzh2Fg8izzYvLrkSS5Ewf1Y
	 PtqepMWWVoxyt4L1VZChljBgfMwJDzyCG37uwCzZxrZC7kjTsD9JpQYxGsMemFTzy0
	 vIVCXBu1ThspUf0mOfug04432v2/wyXpSNi+o5AqhfINQAGmipbk8OSeSNSTGJYrwE
	 zM7X4n3hAN1Fh71grKWNi0MIwechL8fd5bKDsv+ERzR09JJtHgpH9kDCJ0XppTxmbP
	 vzwEK2mw8Gtg5gsiz7L5NE9XWD/U+DyMqgKhih/gDV6HOMYJiKPi9FyjqEdtG8FGRJ
	 UBUIBhsik7Eqw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/18] mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
Date: Mon, 29 Jun 2026 21:07:58 -0700
Message-ID: <20260630040812.149729-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EE15A0009
X-Stat-Signature: qekxpum3n83wa9gdc91f6pi4x6qq49e7
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782792506-241287
X-HE-Meta: U2FsdGVkX1/B78JHqf9sGDSGrUluyrnXF1G5KVOJ20InSqK8RbBMIzT3jgxSVDmWoAQeAn71CXE/L2+5Ep52IxXHQCH2FzZCWaOCl18b4y/7kUihqLZCKf5m42mJwtglXGPyFlue3X2eiUiSToC6VyRFBNZ2Riee2vAfH/iPf2GCTV6FBQSSyQCQm6ma0DUQo4fF93DV7P91HxhjTOMGhluYnz6WwUKzXkP00ksRFxso4+JJnXdris+bY5MdpGvptAeM/ToU4vJBz1dH7OiPlWWysk8gjqgd7/Cj8mLCvMP/gunHZBV4gZwWn1cnj4FnHCIaXIiQelnvSwFyVSN63x+fjJUPfvyhPVMvtFROHVOsY+ubmKGUt398uCWsHGxk/VMuFZH6utoIgbk2thoZ0mOLcbmH5E8j2OJ/cx+fQ658VpTOEmPCfsEskjdDfJFdEd9MOLnOgOkWbfhDxsS9xobiUCBiFwz97JfIjXDlVmM+tJnJgbS92SWewexCzTuh1o2s9xDGjwYuHHw8zwUD4jChgIPNjbvABL4tqmIN/KNCDfwicWtAmt9Oh0a72FnETh77LMyQ73O37/+BC5SZuBWFFU3SQeQcv7kJi3V9BrRYdv9sJaTRkIDt2BvNEV2z6oejMaRfX1L4PPefasWPh4IuuFud5LFdHZnjNfvYvY58xV8u2jCdivOx5vYhOuReq2NYEa29xNz4Gnuddxgxwgu9Gm+X+47oKdVcu6XkRuCw8hi6j67Lw5g5bKlfLVe5YQPCq4gup/VV4dIZs8qXFn2v0T31ycV9qp0ga6qNSeUf3DpNFk3ljMC3tu+3pSyzDgSef20fuH8gQK/jtOk9+kYw2MDGlDKKRSdjJnyLj9G8jb+55fLSCdSP4jg7sCQTheH4+kDeTd7vH8nHrwJXpCOsbMw1E77Eb575qtriMM3d4G/m07VX2WISWOkEde3lloN6sVXgvm9XKnJkutw
 dDEpgK/h
 fmsddwlB/IaTJ93pMK9lujkRtRqCaYXyVPkFfSl4jlg61Mk+V9kF0dgfcYTtVgcf1SJzpO6+pkpTP2N40nV6hakOVAxCXBqJtGyACRmUkpsRDMHCjoVmob1jayMNcmc8eC6rsit3HEz8m4+9UwcPrCJlN1ObNs8Z+jj30vgSDeEizLCp6yqqCS4uwtecnzqq6WokLPjUTD/P6AlypUhDjEvYjCdlgtutUevotYQOZAE3Q7lnq5e4ke3t9G+HSajpuYUPGoSWRSc1qQAFp7HJrYCfegA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in __damos_valid_target() instead of the
nr_accesses_bp.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 70cbc382bec04..612762490e866 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2132,10 +2132,11 @@ static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static bool __damos_valid_target(struct damon_region *r, struct damos *s)
+static bool __damos_valid_target(struct damon_region *r, struct damos *s,
+		struct damon_ctx *c)
 {
 	unsigned long sz;
-	unsigned int nr_accesses = r->nr_accesses_bp / 10000;
+	unsigned int nr_accesses = damon_nr_accesses_mvsum(r, c);
 
 	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
@@ -2161,7 +2162,7 @@ static bool damos_quota_is_set(struct damos_quota *quota)
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
-	bool ret = __damos_valid_target(r, s);
+	bool ret = __damos_valid_target(r, s, c);
 
 	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
@@ -2747,7 +2748,7 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 		damon_for_each_region(r, t) {
 			phys_addr_t addr, end_addr;
 
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 
 			/* Convert from core address units to physical bytes */
@@ -3036,7 +3037,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 			if (damos_core_filter_out(c, t, r, s))
 				continue;
-- 
2.47.3

