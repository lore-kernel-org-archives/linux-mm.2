Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558D9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70F06B00AE; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62406B00A8; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4156B00AF; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 343976B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F02A12034D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
X-FDA: 84935247054.09.D039ED3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C83B940009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5UY8Zvj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792505;
	b=nYWAl40BjJ56uNoGxoLKjvFGR0lUURZYaeT52dyTRHzCswKdtuy3k63J2Tl8TbBtzwNkOL
	NGiXtcTmTUlp587RCLuEYp5dgszAyV3V5q4KnPZf++oVQrlds4gtiifHZY7uMClYiIFJHH
	I7gnuD2oZF8W9ROREzPXjvB/rxLwnsU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOD+Ikul9zy0nEugQ9tO1hoHol2HP4tGP4xuSVVUhbk=;
	b=cYcDUbytElit0U0MUm+Hg3jFyEqlbCTK5hLA1aTEffqpFhkDyJDdaLN/kc98REx/5kkcdv
	SKjJ3GAmDME3HTuJNrItYsYSx3/0rlyqd9RjoyT0+gbfx1j5tKr/m7YHNaEbE6vDU/M7XB
	s1aXJxub2J2mOcw9N2mVskDqtUN2ERs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5UY8Zvj;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01735434BA;
	Tue, 30 Jun 2026 04:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30B01F00A3E;
	Tue, 30 Jun 2026 04:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792504;
	bh=lOD+Ikul9zy0nEugQ9tO1hoHol2HP4tGP4xuSVVUhbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5UY8Zvjp1eYY5r/rPrTFiHV8It0TmxUheywYjqhe7/5YTVYIAd1C95cYaKpBQk9G
	 umZoZAk/ggenMZu5icE1KDY7FwZANvYhweISxsVS/BxQSzVOL75Ue9lV7vM9TyZtXp
	 ESOCq7MeM/ZNpWRb6cxlSUlz6CeHYbU33ptg++H4WuxvyTZKsJLU1lNxeYikIZqJCM
	 1DBkPiV/0tVpCBelywdGNgrxQpIX3JohQDUsw6F6cwjf0YfgA3jlzRrksOj1UAYH6L
	 NH2vvvQT2xPD6BWXkPKKtDJLlqLqN4XNlzlVtblE/Mu5Uhm2i+4h+HV24N269+vpy8
	 jJEFIHeikK8IA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/18] mm/damon/core: always update ->last_nr_accesses for intervals change
Date: Mon, 29 Jun 2026 21:07:56 -0700
Message-ID: <20260630040812.149729-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: frw49f44b5ks5cya8twdt8egdhkz7438
X-Rspamd-Queue-Id: C83B940009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782792505-926581
X-HE-Meta: U2FsdGVkX19MRKtD3zmmhDO7WkwgovcZCbtE71p7GzHG+LTjQh1sVn1YK0NVipkP4+6u4nhmou/zD4KU5x1E2WigPUKri4I1np8t8u4o5N8+083Z1KIjtlb5E2zrxQQNli4uQtghm1Ty6n4HE0tavAXTUkk6/Hyod2+ECxv3BOJ/Q8H+OyCn0SfIISwrF9la+bHjYPy8pa5e/oTzibZo5ET9TlF3a50DPbGNtbEaRyy+XfZ6rgtR7z2+ofz0ro4OQ/6Q8XZ5e2V0vrBCgwbpBcKG9nPma70feEdh4IUAVZGu5KfwLXWC+tEC6585Lz5OSYwMfsB+6nuWsqvEZJLT1mp3/WEd/GEACFcuL2y5Lq4ueAon2+D801ay2I8Nch4uY713XOSjvVdPbUfkkXVsrxsooU4yPkujMe6CflT2jwyVBb/w4W0M7pWDmurWVPpSOLwruN4p7ymzMXvCFMfUQ0lB0h3a6bE/1241B9NE2id6Z/hR2sltl3hsbjU76z+h6aOq9k9RR7p2moIUeZNSTW37sCj6CAdPcxobf//GwpWXyCsZs3qlXOsu9+xth3lazKj7rVdl+3HJUcuzzPEkUJXo54BZyEpe2VOUoVX4QtsJuzxJAqxIejGknVl/YRyp3uxAhXfHp2KDPlNMISefDtl+Zfxln5bTsFYpJv0Rexp7V5HR1P2njpdLCVHqQjOR+SPsXXo5gTRmrqawvUwdjjjmNVmWQOsB9NlgKZ0R/xV+VW8ZOrt+GSsBkTN4l9ahzy5CFqorMM89+G/yajRK60Qp0lF00YFnDLFRTP/G66xTsdcWUbYg6VFyhoklYnOPqDYZ1WKWJ4uBdCrgnNuKP24PHwB2KHuyxFOm5OxiicyJWWdGrs7CQgfUa8+udGY/ntWX15WUD1zCDg3rgPQobVhC94LNfsxxjCCaqSh3vfRYWn/tBz5CUVLmn7UkIPFQF4zjPapoIaFKAM7N0n8
 +nxmIYed
 g3ZoI8e0AuBrtWr7Iv/CIRYJK630Mosc6VS7qOg2d9vLKG+1d4jW97ijeeKb5PoCRVWqVaruabbVgPemyRviEQsrKIB/eApz6K1iUtzoIKnEWvR24P2tsmSkjJqj4Js27ZKnN6bo3qTSNtKAndSxxg1xzSIeIfp7PHqWtfQXR/bv921H/qPqTJq9DSm0ukrds1rD3vztpH7zoczEczG23JfNUzpC/sgvNBGrZo9ha43LQWHL8Xqpz5/aBaawmoZW/2gTtLG+juQmWVDcCo5swHK0rnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each iteration of kdamond_fn() main loop caches and use the next
aggregation time (next_aggregation_sis) because it can be updated in the
middle, inside kdamond_call().  If that happens,
damon_update_monitoring_result() is called for scaling the access
frequency information of each region according to the changed intervals.
The function does not update damon_region->last_nr_accesses when it is
at the end of the aggregation, because it will anyway be reset after the
function is executed, in kdamond_reset_aggregated().

Let's suppose damon_nr_accesses_mvsum() is called with the not yet
updated last_nr_accesses.  It will use the fresh next_aggregation_sis in
the context instead of the cached one, unlike kdamond_fn().  As a
result, use of not updated last_nr_acceses with the updated
next_aggregation_sis result in returning wrong value.

There is no such damon_nr_accesses_nvsum() call at the moment, so this
is no problem.  It is planned to add such calls, though.  Prevent the
issue by updating last_nr_accesses always.  This adds overhead, but
that's fine because the overhead is not big, and it is anyway not a fast
path.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c588f943080f9..669b701e50a7d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -877,6 +877,8 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
+	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
@@ -888,8 +890,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		 * interval.  In other words, make the status like
 		 * kdamond_reset_aggregated() is called.
 		 */
-		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
-				r->last_nr_accesses, old_attrs, new_attrs);
 		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
 	}
-- 
2.47.3

