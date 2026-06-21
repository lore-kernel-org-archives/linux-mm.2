Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA52CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978B16B0092; Sun, 21 Jun 2026 11:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9507E6B0093; Sun, 21 Jun 2026 11:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83EAA6B0095; Sun, 21 Jun 2026 11:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 508CE6B0092
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB2CA140303
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:31 +0000 (UTC)
X-FDA: 84904374702.20.64D6602
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3D1B840004
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/BcZIal";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQradOyUplHOgC8HnoJqDwUCjl6LH6os+/rkUZXzJJQ=;
	b=NFljppo+W6Tf9x6238ZMe9yG3CRY2YPl9yER8u8aFhk8XcjhRIczfqKkQAMTQsHPx96MsT
	bNn63wwerq8jKf4hMxUqAgr+4Tx13JyezFM/Szz2M74IhMk9ScSqCX9Ono5WJwzCR9f8+4
	OcZ3b2fIEYeno648zc5A2D0ASjTzkKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057450;
	b=Nw9B7b2XJyxMfauQHZfw4SUv+9aNsJJ2l0kbFuzZAmawG83h6dMLZqt+5iSxfdm5BlNm3Z
	9alaH9YhB5pMyNJJzVLXE0T+NZm/Zt1j1Nzypp/vd7Sltiz6CiBvj/X9zJ9t11DlyGA3uN
	Qb++AyIrwmoSQyQ1EwqRhG5NxKRBVz4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/BcZIal";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D46BA601F5;
	Sun, 21 Jun 2026 15:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1817C1F000E9;
	Sun, 21 Jun 2026 15:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057449;
	bh=PQradOyUplHOgC8HnoJqDwUCjl6LH6os+/rkUZXzJJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/BcZIal7VCs6OrNLVML9FeuV4fPD/CViya5pPb9gSAVC34rDofSmdEvMp6B8pGEI
	 w31+oZMzGTEVRPj/B7ZyBD6SQTXCmdcan0W7buSS7rYyTX35A9KWmSOlSUZ5k26OoR
	 4uFPZ8KlyQaHXvy7gfTy1W9pVFOiGWdSdbtmRWTGMI1eht5O2QhMQ6EzOUHVRQ1y74
	 8K0EtKqL7u8bdv729s40cO+GPuRarAalPnr8WDP3jJ8zBnCXAQewFc99Gu2qDAeGZQ
	 OWnhE0eBU2OYVlJgz3FIfCVihrD9CETF5wQqcusQG8c5Ct4qH9wgT2cv6VA9ZBEjzn
	 uk1hIQoSEtUOw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/17] mm/damon/core: always update ->last_nr_accesses for intervals change
Date: Sun, 21 Jun 2026 08:56:59 -0700
Message-ID: <20260621155715.87932-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: agdk6rx6dcienu6bi5kbotppbaryz9qe
X-Rspamd-Queue-Id: 3D1B840004
X-Rspam-User: 
X-HE-Tag: 1782057450-358213
X-HE-Meta: U2FsdGVkX19GYmSTVRkjs7+PkXIrAc7V5F4TAayymvAo9YBiyHTaGcj8nGsInNNCD7ZZ3pED9Cr90SkYSQ89ROR6c1apzZWoecIAb70xB0+kV32fAZWyKy2GjZYPVvXphbtKxg/ChplAmdh7kuQxWidK8elKDj2wLvsBwZ2wUuKJO8ulFezwhbMABr1KZ5Lrbv+7J+4LofSYVoPjW42Mk5oTatKTSu7+CqAeMICkK1GLmpqN/Otbqziilev87FvGoMhHvj/OnbI9ZHaWrpyXcjPu3l21RLLPQwiWCtAtWCxaEPwO0TGYd2U2x3/piqbhYMKxKbTza7x+eCFrDmcOjSc20um9XCbY4LvOshftfTwFBWbE4dbuMNx21UZiZmvlKL0Sjb6TBqYNL0PRYDinnh91YrEoRUJ/5fjMwkRzpEeYNgZPDcVMxVSWozcboGS1X34OYtBkZqoRs5MXOQp2RQNFOYGe3r3rxbIYKBzvfeGkTqTdjXYDNT/xjXWZDN5gvJkw6ODVB7SW8ScaUXxWZ6kW7f4LzQanxREwpbpPysFwHXDk226RgoEG8taJVMRDGn/Kvr9LFidv67ioXvzkxidKl3LNn2b6jp4hyIUmYNejERB/4DJKCkMI/GrlVAdkr+q8UXokDEEF/cFSnIRyMjomSFCr/LexpjqcRdUWLtaVFkynUbclyOY6rDT4V+TeKdjf1ZmlwUPdZ4EUWTFQvov+qegMy/79Z31ohEbVcrSTuE5DyUUmb5yxusnRZUYb3/trEVqjShUi891uU+Msgp49IWeEQMrboacp8OJSWRpMA4pJ+IKdeCgglkBhegJe0NDFTMc+HiPco0zO2KJ5TjZW/SoIM6n+rmrvbcxdceWpafiRdAZeUFrBlX/s6NUri5Fp4b3hQsOZrWxBMItCP77RSNaYFuMlbkeT8WlwCF7XYphEnh/yo2VsuaiAG5kbIbu6a/i0PSl+bsDIeUi
 LIGQ6NBP
 sH9HZ7KPD3+OB9yQFFcvWuakgXwpACrYl8qCNf7fe816Cdn33Z1+qGZXkuQJ82//blJB6ns1rqF4suREOduNdgGgLqKov/xy49ULbOk9OdED+W+fkv7n7s7rezm7c64rdELGKKfoialxihP+zOHXXwga0AYHV2gj1vGVdDJBNsLnCBjLiy0HvO5KFjmgqaSTan2OSodmMLFqIfrYx4ugbHsD1T/Ptoqdk0rWlgcchEPLA4sMcbfVlI2JME0A22FG04tQiwZb9/dvlNGqHjDshUDOGCQ==
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

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2cc911fa221aa..191533685cf2f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -873,6 +873,8 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
+	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
@@ -884,8 +886,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
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

