Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14F1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CBF6B0118; Tue, 30 Jun 2026 08:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E85C6B011C; Tue, 30 Jun 2026 08:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A056B0119; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1A0F6B0115
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D46416812F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:52 +0000 (UTC)
X-FDA: 84936553464.06.77E382C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6116F140011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Az1wZIaL;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823610;
	b=epHb0Qm1RLlLqys0HbvVi1FaAyIkE5FLxAt9XjnDqhaV1oD1e7/6LNV8hHG9B/Ox7N4UhD
	vpZP8aWLqaliuTTOBDNhe6FyV+boKDFBq+uaMYwqQ5lztx0i5Tzv37TM90tc2UOfwH9dCT
	IDceU8QZSed5fmk8Se+/vuXH3rqXQWQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKuJcjdWzQFo0sQFTE+S5Gh5L1HH8cwYpvBwkdQvObQ=;
	b=yE6EjnHOM3EdG056ztjF3+Hz0jOlQgwIdNUOmIGLQxtt6y3G6ZBHxictIk5A5E9a3rdkz7
	I/4qLvwAF7tiUoz3eY9C7fYyZlgylg8PMQfuLumap5XCdX1R+wsWfjU7tcgqCbYpWdvSFz
	4o0FYDYGDFjah2iZSCzQC2ItRNv5aCk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Az1wZIaL;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=yKuJcjdWzQFo0sQFTE+S5Gh5L1HH8cwYpvBwkdQvObQ=; b=Az1wZIaLfhQxIr6kDONe+Mv+y0
	jG+tTsnSVoKsfMgy/YsXiYHtfAkNzLt0aJY3EEZapDPqBgcmXwsz6HWe3dZeNjpQUiBrlpQuWJJ3j
	xyzYY+WsGFX6wh0ABTxSssKPtBDcX414Nq8Q+CRAjhm6GLt4oom7Dg5V4Ae1xCp/ypD3NQ5/OEF7j
	0n1gXVwDNnSVp9SaAaw6O6CarPcTHOtaTljcCGwoYuRhHGrElTH/VlL3B3zL5/PiBRi8i+DbqeoMX
	LDb91n4jbD3KLAfVkiEcytACIgYmfiRZwsP3cTWb1hpDpNUadWmZfSMPw8MJAQR6xspHcQUnH/aBp
	/H6m0DEQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrG-0074bK-19;
	Tue, 30 Jun 2026 12:46:34 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:04 -0700
Subject: [PATCH v10 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ecc_panic-v10-1-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201; i=leitao@debian.org;
 h=from:subject:message-id; bh=QiA0KGoCN46shnI5qT5X0mAB2aGO1DAFqEcShnOA/HE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdrz16EpE9ncXgjPQGVbtAOucfGhxcex96C
 9typ4DQV7WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 bSZeEACAQcBUlw7QGrJCZkO/0ZmETp3GR2br05j4IgU5SIXqykYpfraNOW/39Xofc8THBIbXP1O
 Oem0yYxD2KlIAmLL7YtQlfzYIMqg5PMXxmLMN1GP/QpvM1D6tt6gGGka8Zp7slGQFjL8mOB7HCi
 gKSpSnLu0HtSiUsANF8NwfVrlOxIMkGJ7V1XjAZfGKP1kRdNdcxdtAzglJcrKI+H76FqHaSzWk0
 Le4U4ORkLcylhFWG5JD5N+Ciu0CO+DsgE5EbZq+pnNpOPZWUvh22e+wnHYTRqZm8I7Y56jb+5ml
 /VSZw6EvijnGxVwaLYCyAvbStfNKXpXebskCAUqVDoAcv/yl56tOOJCX7YAkOUXsHRsanoSOtNq
 fnRuheKVbZ/xNKXuisyPkwe+4SX0+/iefY+lACTw1/GjM1GzpShroazKAPZSZSsjBs0uawtiRkm
 p0NKDF6QADz9Qd+2Q6bsy4TXE84fNR3yPbKf7Zd5Hjt9xv6uaYWmZTkfs5OWg9+ACf8WO7PxYua
 3c01clnwZEV3KvXfwGLqFpqNiiVRf9AMzcA2VzN3uMGDf+yBqoZRnuahLxSHmH2aHrdQjG/D8sa
 N84ZAbK45UGhnprya6LmpkO0Y5UGJNurb3/sxZ5XUBLA1ZcqTqR9awvQK+/SI5tt5NVoU57KiS8
 T+H+WBL1XYxtLgA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6116F140011
X-Stat-Signature: xzs1qdhbqsxkseqa6zjzfn6gaaszsbhm
X-HE-Tag: 1782823610-889553
X-HE-Meta: U2FsdGVkX1+7qecbedbcaaRro72ziZahTIOvJzE1Mv3cMCp3xad3jXvr/Z/XKqM5X6YwtycNpPsXUUpXYNXO4Nr/hup8s0Y+2SNUB1RsfFScS2Ll/9TIifpVzquWiTLJE3h9KtxfvnTC9istEhemk3fQXLvwol7Gk5OkgcQIH8zkMOQDZFZ/aoXMxJZSvklHUgMw35y64LgqeWLYRoaI+MGfCfD59l7QwgtCkpzJOyxx0f2CVvy7TjIn/Z4m9WNPegUoFHoI4MgBOf4ajlq0rp3S3UjFW+rZCL/F7cYLG/XAvbIXmqkmdOSPAVVn7UT1VpGu3WNrUdq6ifQ8wcHZwEbEBLW6fK+yzJhUsriWlPf/+GZQI2bylr5Xg5Xt+LnrBcEmzIwtvMiWoahiS4otvbB6IPqIHMZSVsPqcMcm1EgZd+oh3z+pwVggFVN6IZC0BFK3bofTndj6BNT0m0MWUNwxtVrxk05H+r4l4dXkjqx7SRkhAZXX3MltJ/mDVMTi9BZoylSf/q2XI7l77ih359YxGkizfVwk0abIY2UwpIaW49fw9dy0J+W5ttKPJsQ96TwvtEP5ImZYy4xj1Z7dEO5bziYzXYC9fZ9SGvwfP0IovnFnpHRfprKSqtoqdwunBkWcym/Rn82/b7ATMOypju31Mvh2AJkfUvGn9zsvqISlE2EXK5ADQYTKMziPTpjMKau20OvsL+sloVi3bTJOc4D+V5eUTR4I1I13u8Mf+XO7iqYqt910tgHkAwSER70nVtKNWDT3uzWAlUnghozRie3iTeZXqm4nygHBAeZ9NLsIueSl8n3KIas00k316EicrFIjqATvspHK947EcVxnwV2pyv3jyKHNLiHu+3wiY6Qw3t9xG9/8/TDblgtDquvpitYVrEf9GJcXrfy2HhCuzJY6tGeOMvXeafKTtaQdTx5DhEnwxb8+yAeuB5WnLhyxN8xodRdAK8IenNBn73u
 26+eLI9H
 RXM5elf574DNGBkciVQLYjLULcNWrUgETy65VwzAjA2LXYJBWtxTPWXfvcPVWdklm5QMZ0WE2cMisam+AgohyGMaE3wJ6ZwQTFyQmWkND6yZxwxh4yN9H9rnJDj2A91tAPsPsZ7xLtJiFhPiBBnpn/+UzusvYdGT4x+vR/pj4Wk4/kTI6uqc8tzq+nN7uZOjZl7FuaL9MSFJOK4QDNH97L8ROkNDd/xKQBuCnuTMVgkko28DwpXoYe1gLtLUGQYsxVNWZSpQMihA9gIbY6drrMsymA8k8Jeh8EJp2ysk3fQwHQLrNNnhquVeLXrqRuv5/fSq6lcjAJEDlsZBQZhYnSRF7uDhCUtTow+7g06h46zgp9fR63yBKOMTR0t5pRAUcQyfwch1rw8tcV+aRtWg8a6PBMSQ3jmEU8j9htO+mBXMvCzkIw8PpVAryIdIQy2OLneh5Q7h6IDtvSJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first entry of error_states[],

	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },

is unreachable.  identify_page_state() has two callers, and neither
one can dispatch a PG_reserved page to me_kernel():

  * memory_failure() reaches identify_page_state() only after
    get_hwpoison_page() returned 1.  get_any_page() reaches that
    return only via __get_hwpoison_page(), which only takes a
    refcount when the page is HWPoisonHandlable().
    HWPoisonHandlable() is an allowlist for LRU, free-buddy, and
    (for soft-offline) movable_ops pages -- PG_reserved pages do
    not satisfy any of these, so they fail with -EBUSY/-EIO long
    before identify_page_state() runs.

  * try_memory_failure_hugetlb() reaches identify_page_state() only
    via the MF_HUGETLB_IN_USED branch, where the page is necessarily
    a hugetlb folio.  hugetlb folios don't carry PG_reserved at that
    point: hugetlb_folio_init_vmemmap() calls __folio_clear_reserved()
    during init, so the reserved entry would not match even if it
    were still present.

me_kernel() never executes and the entry exists only to be matched
against by code that cannot see it.

Drop the entry, the me_kernel() helper, and the now-unused
"reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
remains part of the tracepoint and pr_err() string tables, and
follow-on work to classify unrecoverable kernel pages can reuse it
without churning the user-visible enum.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c4055..f4d3e6e20e13f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -980,17 +980,6 @@ static bool has_extra_refcount(struct page_state *ps, struct page *p,
 	return false;
 }
 
-/*
- * Error hit kernel page.
- * Do nothing, try to be lucky and not touch this instead. For a few cases we
- * could be more sophisticated.
- */
-static int me_kernel(struct page_state *ps, struct page *p)
-{
-	unlock_page(p);
-	return MF_IGNORED;
-}
-
 /*
  * Page in unknown state. Do nothing.
  * This is a catch-all in case we fail to make sense of the page state.
@@ -1199,10 +1188,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
-	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -1234,7 +1221,6 @@ static struct page_state error_states[] = {
 #undef mlock
 #undef lru
 #undef head
-#undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
 				     enum mf_result result)

-- 
2.53.0-Meta


