Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52931CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8286B00C8; Wed, 13 May 2026 11:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576296B00CD; Wed, 13 May 2026 11:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8D86B00CB; Wed, 13 May 2026 11:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3A16B00CA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:40:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5AE9C0439
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:39:59 +0000 (UTC)
X-FDA: 84762807318.25.B6F7720
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id C8FED140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:39:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=C5kavAJm;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VwvF1KgbgTaLhH80dAvDE3biS5CMTVSVvUy9k323TY=;
	b=XcwcpP7UANylI5ZNzqp9grT9CL98ZCjaO8wJHimDoiJCcC8drnuSVygo0RW3KLgdsQAYJD
	V3IjywbAbhClHgJEpvJFLFfi0PKXz8CaV88TZaMY9bg0Wixliyr8J2CP7ZDS0eHrIcJpDF
	eBR1SIuquiBdMq/1j5E2YX+C9aiA9gY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686798; a=rsa-sha256;
	cv=none;
	b=EWdsWpqGNWTCbuRkjwoe56XJKa0/unISAB+muqJOfryN8f/EvjEWFmKkN/xriyq4EHngMI
	r3pgjJOxEg9KtsQ77uXwCqmDNopqiJLI1brBFmvCIJ+OZE+6AFjRYLaGWwPdQtM8ICpBME
	PzAyqTUySr0FU45bsFVxTrzMUmPO3gA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=C5kavAJm;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=0VwvF1KgbgTaLhH80dAvDE3biS5CMTVSVvUy9k323TY=; b=C5kavAJmTRWLHmHzyxTmOyzeRl
	Mu52fHbNn/G+fEXkrw3hiKPilsD8htg2JoySqpmLBduOs+nocpw2b8LkpalYG2anjI3cGaXaYdwzx
	tQcYX6WrYqFNwAuoMdljS9acv+yYKCTCu27Puir849T2C/oQfodj+LSptbrnZKY1hcPLCXZL7pYsf
	AHU1jap2iBoBmh/oj5zvK89b2UKq5Yhs/H6+9gH0CU5bOzEIcrvtQ+mi73gH4DZizL9pRG7bjQJSR
	8VMIzjrPgevFU6uqK50LI+TNyOHULSr9MLIO6CsoaAAdMNCflUgci5IaC5i+e7B6UH3/8PhTS1ZAO
	2xgZOGOw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNBgd-003GTl-1Y;
	Wed, 13 May 2026 15:39:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 13 May 2026 08:39:32 -0700
Subject: [PATCH v7 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
In-Reply-To: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2996; i=leitao@debian.org;
 h=from:subject:message-id; bh=YmqAu0MKBmjqTPY6Xp2AGwlYrj86HgU7CFNy45dVm1c=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqBJs6ke4HsS3R5O/j/KZISqMDE5tmdj17JHj2r
 gYZdMUqt5WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCagSbOgAKCRA1o5Of/Hh3
 bTghD/90CfcSo04fggOfDUaE1JFJXqEA/MFDTRoBPWRGgXosrYL07rW5qF0YPnv7+VS6Lw8SL3W
 eDc6QdNVpIThXaZ7mkA90LioCvk3FpsSg4mSv29bAockiYO4UnvicP499yMUKbvwD8MuXoqnCBo
 UA7E04FJKDmbVxhjI9sEwpXKRSlGiasqyFEODsK3aHf9a37apm1kpVO0cihxy9AKbeVHMbFDjhl
 kk04DtPsPGQ+yxNQFLGskcYdrsAiSFyWMCautYu6QVWGeVxpSnz/I0Zj/a2n7tEAQuGMW3iNKKo
 XXiaqDfiOQCnlRK9JFzIFmlGMbHNsrBjX42q1MCtdKMzWhAsFow7LpA9U69iMDmGjSTvAhUswHK
 1H4gCFCrXmEt+nJYLYLdx5dtzXGbiI9eTyO0iL08veDqgwg7mY5u8XBEdeQS4bgRmI4+y2+DCpi
 06m0BYrhJJZu9cC0fPJXeWdyMRIZat9lXQYpc1x0o6NzJMHN1QeDDErQaoYgVw3N4qT4Q1d4512
 KqFTdWrUhunznnlJy3E8l7+jP1RoI6YIZweDcmOc7QSSl03QeLohU4wJQVirWnUCTwgx+YTgsLJ
 UG8McwNHWspfdKqqaCBdoaKorLST1bFrvc96W1YQhqtmD52sRVbi1ZpyeMDH0bByuyTvLgpQgdL
 YwRIMi2HHPGHISQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C8FED140002
X-Stat-Signature: a11jr4ntdbm6sgw4zxujesqkyo5w6ix3
X-Rspam-User: 
X-HE-Tag: 1778686797-198672
X-HE-Meta: U2FsdGVkX1+u7AnbvbMK6ugH+oK8WB0hanTNSET4/0B1Sd1KtPOGbSg8HGuBFMEBFg/Zvt3YaPX+0VjoSKcrh+yyuFaNz9MOa42cxOPfdImkUuaSA0Vm80uy8ZW5lz1pp++c8+kedwnsp7wH90lRZ5dCf++LlEDg0isk+EXGy9JMvpdrRAVbUJLsIYU8jj4fGhf0+L37/4Stdt8snkzB6uc3w5mVVnT9syfEH4bfoSq2R1VGIbEmPio1Fl+nu1lTMitPRFDjF8QNsVuAH0GZZR+EfTrWdLJICaYO0XSIS+YX19NI9YVt94RWHwZVybfBE0VYqbMq3yIG851F0XWfCIH5lQyug6PI28jkWkJ1Ow9OoigxbB/Adn5Ma4HZC5Wgo/u5/zS1cXpxvpo8rd50jj3I5ISFtGKIHfs0lZtcDBS1mPtx5EQhgBE47S0cgy+grg7wCmAMwRwUEfIvevlELRFHWWnoC29tS6Nt20LRbPDEumT8hYXwP4Qhswm59DN1B0tJbpNqRb4OGruKd1PjeUgILF0RZauxiL7cS8b6eqEWUSk4hTilpiRYMY1GsnS6UCj0dS2Ic9+kzvO9YX7W3uhhVxIGredjSx47RCZf5I39nj/e/UeSODBNO2eAwH7AbaTd7Zsdue9GfyWAR328cPPHkohOORlZs+xvvJan8HcOcLWfgWOC01WD40ulLZutsm+K0C/ySAsIxgeKLFkRY6My03IDuRKj44VI35F+UxW0EN59CyRaAwbzvf9PJvAcjwiR6FZ7M40cpY4VpeXLXkIvWMdheu3DRJtNHlWG4MAHYjZCRbKtrWvxMtRZ3FP/bWVS1vW3zklAtVswRofVzqWm6xM+PhhAA4WAMzVCU0krMKblKRx86KF4wrXmZh/Oc1Cyn0bIJyjtBAf48ic39DQZtXWB2oDHr4UCzk21DphR7/dR54FozuzqSU5TJLjcCKvqZMy1lmdCyVPiOiw
 bDTQnyCb
 2ORCLGWSCa60VEN0Z8LnOyq2a1UPDfInHJF1QYs0HPWybN/Rf8ijY0zinmfWddsQ9jKGQKzcY3r8HNmFmpGV5362prsIPrsHZjCaech0OjKaPbRA1MZ96PP+gHHdFeNJ1adAMd9wWQIzvsyp1x9BwFQsr8myVk+9A0VLEGeuoDfOF+7Uomq+4Ma3BOLB+YM9p+8zggxJFX+8zVKUK4vO6DeTmyhKdBy79fvL7ji0+PhLLcYOE/cuYfIF10AM0FK882vk+gNqoHxFV+3hfjA0ABoliR0zxjrI3D5arn6v7/flAIAL4mQeFTluFS6Z/Ktts1umZ7xTU/9ALYnJVRnlMXy4tTxthxXz0mrgOTK+0/3xURX3xDtnrh1OCDbJ83z+uw0r0
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
    return only via __get_hwpoison_page(), which gates the refcount
    on HWPoisonHandlable().  HWPoisonHandlable() rejects PG_reserved
    pages, so they fail with -EBUSY/-EIO long before
    identify_page_state() runs.

  * try_memory_failure_hugetlb() reaches identify_page_state() on
    the MF_HUGETLB_IN_USED branch, but the page is necessarily a
    hugetlb folio there.  The first table entry that matches a
    hugetlb folio is { head, head, MF_MSG_HUGE, me_huge_page }, so
    they dispatch to me_huge_page() before the (now-removed)
    reserved entry would have matched, regardless of whether
    PG_reserved happens to be set on the head page.

me_kernel() never executes and the entry exists only to be matched
against by code that cannot see it.

Drop the entry, the me_kernel() helper, and the now-unused
"reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
remains part of the tracepoint and pr_err() string tables, and
follow-on work to classify unrecoverable kernel pages can reuse it
without churning the user-visible enum.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7ef..49bcfbd04d213 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -992,17 +992,6 @@ static bool has_extra_refcount(struct page_state *ps, struct page *p,
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
@@ -1211,10 +1200,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 #define mlock		(1UL << PG_mlocked)
 #define lru		(1UL << PG_lru)
 #define head		(1UL << PG_head)
-#define reserved	(1UL << PG_reserved)
 
 static struct page_state error_states[] = {
-	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
 	/*
 	 * free pages are specially detected outside this table:
 	 * PG_buddy pages only make a small fraction of all free pages.
@@ -1246,7 +1233,6 @@ static struct page_state error_states[] = {
 #undef mlock
 #undef lru
 #undef head
-#undef reserved
 
 static void update_per_node_mf_stats(unsigned long pfn,
 				     enum mf_result result)

-- 
2.53.0-Meta


