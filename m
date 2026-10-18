Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE175CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860E86B0092; Sun, 18 Oct 2026 02:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA0B6B0093; Sun, 18 Oct 2026 02:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B21B6B0095; Sun, 18 Oct 2026 02:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 340176B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:45:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA0FCA8039
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:45:06 +0000 (UTC)
X-FDA: 85334809812.21.F4872C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 18CFE20002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:45:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqpwYvSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792305905;
	b=wlifHtZtVyhilt0ksRp7eg+TT4CdlLxRkJsO/HEPRovY9KENmY1k0HF5tva5VEak0DIACp
	a4XoVC5loW4Rquv4ufSsA7sAS6+faLdzJvkqh/ggns+vr2yMNlwzvf51mlqoOFgvusOiST
	du7jSklQRL/nj4gOsZXrtuZKg63c/M0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqpwYvSr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792305905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3rJq8YWK90ZLxprytG+qVY9dD6giNcVgjHHyQH+Elk=;
	b=Hjomlm3uEgFclRRi5KsS5sJ8mQ1QKBSMVwr43gvRnAbk3Lo/I6Km45WdrPWMP46sWDgOZo
	9sVHZwjdecWXmA7hA+e5EwWYYl9oNJ8Aw80FhxTNZXClBI70TgTP3C2j/VR1QJHH3TFvrd
	4JKsIj2io6EdPqE1J1g/zMu+TXyTA+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5461960142;
	Sun, 18 Oct 2026 06:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0781F000C4;
	Sun, 18 Oct 2026 06:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792305904;
	bh=P3rJq8YWK90ZLxprytG+qVY9dD6giNcVgjHHyQH+Elk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqpwYvSrrUKg7TXUL7ruE2E3nTbAdCIxSEAGYdKrtZy1zzIyCzk8CaWycfBEkfStP
	 pxy23Rwcyw0iE2N47pnHFL2qzekK90Az9UWl+GAUWZB8lBLik+li+3YrGWjS8LwZkb
	 tWQBlfUNzlhbM9zP2FMp3dWZUzYMl24t59jPUijysOcKnj0ekLsVfHQhTVCFGQEaDe
	 fLGjMisl0OTaeVO8QwaUHKLLM+NQ1RRtNz5R4gcZ6ke3qxlUUIPLO8q8AvkiFhrnQt
	 AVFKxqKNgZVK4RRKQl0qa/u/MnXRBqiZBn7ml0ryF4IqWe991CcJ6cyywdzmNDgc/4
	 xvkzVwGHCGoxA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	ehab.ababneh@intel.com,
	kasong@tencent.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	qi.zheng@linux.dev,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com
Subject: Re: [PATCH] mm/mglru: fix using folio_mark_accessed to replace folio_set_active
Date: Sun, 18 Oct 2026 14:44:58 +0800
Message-Id: <20261018064458.86435-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <sashiko-outbox-175822@kernel.org>
References: <sashiko-outbox-175822@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18CFE20002
X-Stat-Signature: t9awfnqkygzm4geaq6ebg873btjr6han
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792305904-641836
X-HE-Meta: U2FsdGVkX18A47Wx7fp3excQcJK8VkmGYJD0vG7Ug7PN16Xl3NySP0OQIS0p+A6TVfL5uXMBLXJhWoI5+3Y3v9DN1p+0JKf0w5DLoG5HyZAAghYH27obPDsETVfdr8EqvyfYPNLcSSa7pziVV5tFCRAHOabteHpCJd4NVp2R26lQGCeoG0x0bsTT9OjHneOzy0+E0Jpu2OYX9Xx/7Q+5y2fwsXxz9GmWsbaQV4LBNTTI/iYwbl8fG6TZpKCBoS2+8vZbmrU8m78jFfIjTml86xXvuEdQIBYfrJhNDRTJxz45NNMo8P/ByR5KrunSozAySMahxkdZsmuT3jM6D9JEJeoEtMctYdf4tP2r3EsveFaz6CWunu+MOwaJbnlsbFEWZPoe8XsjizmHnpx5Z86Ly9sEZNg7ly/LVc1qSBVaoq2ZW+iyljv8cpfAua9+e5y8e933SdlTq3JMujZnlbIr+jqw8DwYPsvmYDPvu3VLqdWK/tkNv/5ZGABn85H43/ekjK3MandIkCOSTqWipoxZKMPyJLSbv+89t7u2WBLsDTZkhsugARABDMgTkOgBRheiVXMIhLORbQKqd6uh8a6ROd248TdVYIHcgHvyr/zbq+qxIE0VJEY3wFZqoT9XpZd8/3glanMWzcvUa84TCvEz2B2JdkOG2yMXSlgQWgqgereotX4x2n/+2StYKpGl2jJ+mtla9mVviIl5SJ9w7CK+yAZRi+UuAMXQ9QOGffXEeqwJjm+KL5m2DBqR8lX7lhw03x43NQiCzXSCPi7fsTcnihfIFLhffnF0FBnazDuop8jeQaYCt8fqoC5+FP70O8pV5LK1hHEnCq7y8+OCW+at9Oa/r+XMirSoZqon+Sxv6uXCV1s0ksFCzySGyu1DwxuVSKIlWGtuuQHITRLTEtcVL3Fn2xeJb/hEPE8gwetjbf1foqgQx7SYTLpfkU2910m+s4kqbljCYJyzcO0X6D6
 CoreWzK8
 pXMj+ijR6tURUR9pHRoPsV5NjcXr0qR6V49d23Gh/JK6JuuleWb2A2HbU9hAYMqPz/Y6O3UPfmvKIJzOSCQJVLftS8bKvitEr7C2ZylG0O0+mY78/MJuT5KchLNefthYLEkpk570OifVzo/R8OYa55uSTJ0pT2ej5Fc0Ab3bE+TUqWT80ryZw269ZINUBtz/p8s5lhoWJ91JIzlXUho0Oc9/UtMomDNAmecsCKlOHWuIlX798DF9vgpZkwgej8uVYhT9Lbdh+hBE8ktMYNq/dQ3+QiCsiLE0eXYCFcfem4HpVknYv4Lo/etMgquDZmVPdC1zdObcFESrRNS6fr7LHvdHQ2Qs0losNXVhL7aZTAwEg+GY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 5:31 AM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] mm/mglru: lru_gen_folio_seq() demotes non-workingset active file folios
> - [Medium] mm/mglru: lru_gen_refault() miscounts WORKINGSET_ACTIVATE_FILE
> --
>
> commit fa50b3cc1b1d64cb457afbbf37dc545c6d4e06f1
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: fix using folio_mark_accessed to replace folio_set_active
>
> This commit reverts the use of PG_referenced on in-fault readahead file
> folios from commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> replace folio_set_active"), and instead adjusts lru_gen_folio_seq() to place
> file folios with PG_active set and PG_workingset clear into the
> third-youngest generation.
>
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ab69b9930893f..97f157aafd581 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -319,7 +319,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
> >        * |<---------------------------- MAX_NR_GENS ---------------------------->|
> >        */
> >       if (folio_test_active(folio))
> > -             gen = MIN_NR_GENS - folio_test_workingset(folio);
> > +             gen = MIN_NR_GENS - folio_test_workingset(folio) +
> > +                   (type ? !folio_test_workingset(folio) : 0);
>
> [Severity: High]
> Does assigning gen = 3 (lrugen->max_seq - 2) for all file folios (type == 1)
> that have PG_active set and PG_workingset clear break other MGLRU paths that
> set PG_active expecting the folio to land in an active generation?
>
> First, in mm/vmscan.c, evict_folios() promotes folios rejected by
> shrink_folio_list() out of min_seq[type] by clearing LRU_REFS_FLAGS and
> setting PG_active:
>
> mm/vmscan.c:evict_folios() {
>         ...
>                 folio_set_lru_refs(folio, 0);
>                 if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>                         folio_set_active(folio);
>         }
>
>         move_folios_to_lru(&list, false);
> }
>
> When 3 generations exist (lrugen->max_seq - lrugen->min_seq[1] == 2),
> max(lrugen->max_seq - 2, lrugen->min_seq[1]) equals min_seq[1]. A rejected
> !PG_workingset file folio (for example, a mapped file folio spared via
> FOLIOREF_KEEP on its first rmap scan in lru_gen_set_refs(), a DMA-pinned
> folio, or a folio failing try_to_unmap()) has its PTE accessed bit and
> PG_referenced cleared, and move_folios_to_lru() -> lru_gen_add_folio() puts
> it right back into min_seq[1] instead of promoting it. Even when 4
> generations exist, evict_folios() clears PG_referenced and puts the folio in
> lrugen->max_seq - 2, so the next rmap scan in lru_gen_set_refs() sees
> !folio_test_referenced(folio) && !folio_test_workingset(folio) again and can
> never promote it to PG_workingset.
>
> Second, in mm/vmscan.c, shrink_folio_list() sets PG_reclaim on dirty or
> writeback file folios and jumps to activate_locked, which sets PG_active:
>
> mm/vmscan.c:shrink_folio_list() {
>         ...
>                 if (folio_test_dirty(folio)) {
>                         if (folio_is_file_lru(folio)) {
>                                 node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
>                                                 nr_pages);
>                                 if (!folio_test_reclaim(folio))
>                                         folio_set_reclaim(folio);
>
>                                 goto activate_locked;
>                         }
>         ...
> activate_locked:
>         ...
>                 folio_set_active(folio);
> }
>
> Because lru_gen_folio_seq() checks folio_test_active(folio) before the
> PG_reclaim && (folio_test_dirty(folio) || folio_test_writeback(folio))
> branch (which assigns gen = MIN_NR_GENS = 2), won't setting PG_active on a
> !PG_workingset dirty or writeback file folio downgrade it from gen = 2
> (active) to gen = 3 (inactive, or min_seq[1] when 3 generations exist)?
>
> Third, when a !PG_workingset file folio is explicitly activated via
> folio_activate() -> lru_activate(), or when it is isolated from the active
> generation lrugen->max_seq - 1 for migration/compaction via
> lru_gen_del_folio() (which sets BIT(PG_active) when !reclaiming &&
> lru_gen_is_active(lruvec, gen)), re-adding it via lru_gen_add_folio() now
> places it into lrugen->max_seq - 2 (LRU_INACTIVE_FILE). Doesn't this demote
> activated and migrated active file folios into an inactive generation?

Thanks. I guess the real problem is that we have no reliable way to
identify whether a folio comes from in-fault readahead. I've tried
various combinations of PG_ flags, but none of them works. So the
only solution seems to be separate LRU-add callbacks for readahead
file folios and other folios.

I've drafted a version below, but it's pretty ugly and feels like
using a sledgehammer to crack a nut for a quick fix — simply not
worth it. Maybe the best approach is to revert 6cbdd9726fb5 and
leave the proper fix to Kairui's MGLRU-FG.

Unless there are objections, I'll send a v2 that simply reverts
6cbdd9726fb5.

Subject: [Don'tMerge] mm/mglru: fix using folio_mark_accessed to replace
 folio_set_active

Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
replace folio_set_active") attempted to avoid over-protecting
in-fault read-ahead file folios by placing them in the
second-oldest generation rather than the young generations.

However, it repurposes `PG_referenced` on in-fault read-ahead
file folios for this purpose, potentially coupling their
handling with that of regular file accesses through syscalls,
which also use `PG_referenced`.

This could regress some workloads, as reported by Kairui Song[1]
and Ehab Ababneh[2]. Many thanks to both for reporting these
issues!

The long-term fix is Kairui's MGLRU-FG, but in the meantime,
we also need a quick fix that can be backported to stable.

This patch reverts the original commit's abuse of `PG_referenced`
while preserving its goal of avoiding over-protection of
in-fault read-ahead file folios.

This also restores the `folio_set_workingset()` behavior to
what it was before commit 6cbdd9726fb5. We don't need
`folio_lru_refs(folio) > 1` to call `folio_set_workingset()`,
since `folio_add_lru()` no longer sets `PG_referenced`.

We can't reliably identify fault-readahead files using a
`PG_` flag. v1 tried `PG_active && !PG_workingset`, but
this doesn't work either, as some non-fault-readahead folios
can have the same flags.

An alternative approach used by this patch is to give
fault-readahead folios a separate code path (callback) for
adding them to the LRU.

Specifically, in-fault read-ahead file folios are placed in
the second-oldest generation (the third-youngest generation)
through dedicated functions.

Activated file folios and refaulted file folios remain in the
younger generations. Unlike the code before commit
6cbdd9726fb5, `folio_set_active()` is no longer always called
in `folio_add_lru()` for the `lru_gen_in_fault()` case.
Instead, it is called explicitly in the activation and refault
paths.

[1] https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com/
[2] https://lore.kernel.org/linux-mm/20260901180704.168106-1-ehab.ababneh@intel.com/
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mm_inline.h | 24 ++++++++++++-------
 mm/folio.c                | 50 ++++++++++++++++++++++++++++-----------
 mm/vmscan.c               | 14 ++++-------
 mm/workingset.c           | 11 ++++-----
 4 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..73acba1c0bc9 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -298,13 +298,17 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
 }
 
+#define LRU_GEN_ADD_RECLAIM	BIT(0)
+#define LRU_GEN_ADD_RA_FILE	BIT(1)
 static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
-					      bool reclaiming)
+					      int types)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	bool reclaiming = !!(types & LRU_GEN_ADD_RECLAIM);
+	bool ra_file = !!(types & LRU_GEN_ADD_RA_FILE);
 
 	/*
 	 * +-----------------------------------+-----------------------------------+
@@ -318,7 +322,9 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------- MIN_NR_GENS ---------->|                                   |
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
-	if (folio_test_active(folio))
+	if (ra_file)
+		gen = MIN_NR_GENS + 1;
+	else if (folio_test_active(folio))
 		gen = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
 		gen = MAX_NR_GENS;
@@ -327,12 +333,12 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		gen = MAX_NR_GENS - folio_test_workingset(folio);
 
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, int types)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -346,7 +352,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	if (folio_test_unevictable(folio) || !lrugen->enabled)
 		return false;
 
-	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
+	seq = lru_gen_folio_seq(lruvec, folio, types);
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -354,7 +360,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 
 	lru_gen_update_size(lruvec, folio, -1, gen);
 	/* for folio_rotate_reclaimable() */
-	if (reclaiming)
+	if (types & LRU_GEN_ADD_RECLAIM)
 		list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 	else
 		list_add(&folio->lru, &lrugen->folios[gen][type][zone]);
@@ -415,7 +421,7 @@ static inline bool lru_gen_in_fault(void)
 	return false;
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, int types)
 {
 	return false;
 }
@@ -439,7 +445,7 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, false))
+	if (lru_gen_add_folio(lruvec, folio, 0))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
@@ -455,7 +461,7 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 
-	if (lru_gen_add_folio(lruvec, folio, true))
+	if (lru_gen_add_folio(lruvec, folio, LRU_GEN_ADD_RECLAIM))
 		return;
 
 	update_lru_size(lruvec, lru, folio_zonenum(folio),
diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..1c2f067891e6 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -48,6 +48,7 @@ struct cpu_fbatches {
 	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
+	struct folio_batch lru_add_ra_file;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
@@ -109,7 +110,14 @@ EXPORT_SYMBOL(__folio_put);
 
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
-static void lru_add(struct lruvec *lruvec, struct folio *folio)
+static bool lruvec_add_ra_file_folio(struct lruvec *lruvec, struct folio *folio)
+{
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
+	return lru_gen_add_folio(lruvec, folio, LRU_GEN_ADD_RA_FILE);
+}
+
+static void __lru_add(struct lruvec *lruvec, struct folio *folio, bool ra_file)
 {
 	int was_unevictable = folio_test_clear_unevictable(folio);
 	long nr_pages = folio_nr_pages(folio);
@@ -145,17 +153,31 @@ static void lru_add(struct lruvec *lruvec, struct folio *folio)
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
 
+	if (ra_file && lruvec_add_ra_file_folio(lruvec, folio))
+		goto done;
+
 	lruvec_add_folio(lruvec, folio);
+done:
 	trace_mm_lru_insertion(folio);
 }
 
+static void lru_add(struct lruvec *lruvec, struct folio *folio)
+{
+	__lru_add(lruvec, folio, false);
+}
+
+static void lru_add_ra_file(struct lruvec *lruvec, struct folio *folio)
+{
+	__lru_add(lruvec, folio, true);
+}
+
 static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 {
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	struct folio_batch free_fbatch;
-	bool is_lru_add = (move_fn == lru_add);
+	bool is_lru_add = (move_fn == lru_add || move_fn == lru_add_ra_file);
 
 	/*
 	 * If we're adding to the LRU, preemptively filter dead folios. Use
@@ -474,19 +496,12 @@ void folio_add_lru(struct folio *folio)
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
-	 * For prefaulted file folios, folio_mark_accessed() sets
-	 * PG_referenced so lru_gen_folio_seq() places them into
-	 * the second oldest generation.
-	 */
+	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
-			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
-			folio_mark_accessed(folio);
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC) &&
+	    folio_is_file_lru(folio) && !folio_test_active(folio)) {
+		folio_batch_add_and_move(folio, lru_add_ra_file);
+		return;
 	}
 
 	folio_batch_add_and_move(folio, lru_add);
@@ -631,6 +646,13 @@ void lru_add_drain_cpu(int cpu)
 		trace_mm_lru_add_drain_tp(cpu, nr_folios);
 	}
 
+	fbatch = &fbatches->lru_add_ra_file;
+	nr_folios = folio_batch_count(fbatch);
+	if (nr_folios) {
+		folio_batch_move_lru(fbatch, lru_add_ra_file);
+		trace_mm_lru_add_drain_tp(cpu, nr_folios);
+	}
+
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
 	if (data_race(folio_batch_count(fbatch))) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..22d589275d95 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -952,13 +952,8 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 		return false;
 	}
 
-	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1) {
-		folio_set_workingset(folio);
-		folio_set_lru_refs(folio, 0);
-	} else {
-		folio_mark_accessed(folio);
-	}
+	folio_set_workingset(folio);
+	folio_set_lru_refs(folio, 0);
 	return true;
 }
 #else
@@ -5527,10 +5522,11 @@ static bool fill_evictable(struct lruvec *lruvec)
 
 			lruvec_del_folio(lruvec, folio);
 			/*
-			 * Borrow reclaiming=true to place inactive folios in
+			 * Borrow LRU_GEN_ADD_RECLAIM to place inactive folios in
 			 * the older gens.
 			 */
-			success = lru_gen_add_folio(lruvec, folio, !active);
+			success = lru_gen_add_folio(lruvec, folio,
+						    active ? 0 : LRU_GEN_ADD_RECLAIM);
 			VM_WARN_ON_ONCE(!success);
 
 			if (!--remaining)
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..c9e42322d24c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,13 +319,12 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
+	if (lru_gen_in_fault()) {
+		folio_set_active(folio);
+		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+	}
+
 	if (workingset) {
-		/*
-		 * see folio_add_lru(), where folio_set_active() is
-		 * called for workingset folios
-		 */
-		if (lru_gen_in_fault())
-			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
-- 
2.39.3 (Apple Git-146)



