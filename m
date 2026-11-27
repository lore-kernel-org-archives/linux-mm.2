Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B941606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEU0kyU8
Received: by kanga.kvack.org (Postfix)
	id 965D56B05B5; Fri, 27 Nov 2026 14:46:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9376E6B05B6; Fri, 27 Nov 2026 14:46:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852A06B05B7; Fri, 27 Nov 2026 14:46:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63A536B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:46:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D83601C3C76
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:11 +0000 (UTC)
X-FDA: 85481930142.14.DD0820F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05343140004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEU0kyU8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808770;
	b=vjdrA+YEo+TQOQ3jzD9w4/zr9mHk6UqkU8Ljq0DMi706hiFGc8hEXbLR71roFBzXuYjxGA
	GXFb6A7+hfdDjohbDk5MpHZUFpjntCcqUYyCVcb2Imnap/PmI/7mEcE+UEhUcQEXxLkFxw
	1l8GoaFdfz3bQ3kdYXPYi71onWQX0p4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Hwpku+LaQUx6JE9I+VbAYIc8Bnjhvc4+sIsQUi+qxE=;
	b=rt54mDSosjf4Wh+bnp16fsiFoHb0J04IOQql2Nb6YLxwuv8JJQ+nJsrehDvXxku6ESl7NF
	Q0IilOq/F5LjYfxOr61TlaCQ5rUQ8h6wTXfgJP1IfMQ+NOy5LeBq2eCfAE8imesOqBpfrS
	PeFHt3/EUWmvxqTFsowfWXOV9k4HQDk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEU0kyU8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF77743ADA;
	Fri, 27 Nov 2026 19:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAEB1F0092B;
	Fri, 27 Nov 2026 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795808768;
	bh=3Hwpku+LaQUx6JE9I+VbAYIc8Bnjhvc4+sIsQUi+qxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NEU0kyU8trWrBW/upvnTB8ftnM4V+QLSmk44qqfny0x+HmBIQycOEoHCCScJkm9o8
	 0dYU9BRIKPet10jCO8AlBcRws0tNdzEO+ZtXzzFR3XJYyD0VSd5DCrraS/Twsk9+bI
	 7J2BZmBI19JHNQHLLYA7sd9+MgdGD7qziZC+sc1UICkB+X8zYI2U0IAB61BSGXJ8o9
	 gHzHcykr5voC5QkziAx3FZGYvNVROZgmT53h8I6gOfYi1xgIKEkz44DOdGJG52jUso
	 h91n7RrWkLTU/5Vdd7vS/3qDuu4aCgLLR38qfeSQz3QQZBNLND7E+Ecbl8nMkvmyZ1
	 zvD9eTHcGeMFA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 27 Nov 2026 19:45:41 +0000
Subject: [PATCH 2/4] mm/madvise: don't declare OOM for MADV_WILLNEED swapin
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mlock-madvise-mprotect-ai-fixes-v1-2-e46b2b1eb435@kernel.org>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Hugh Dickins <hughd@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
 Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
 Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2951; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zISF9slmgFgn0hlNBHComrSnoxHsfcZ4I7sJ6aGObbk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5777MnK0etsLl5Pe7T4syZTuvvZJeuKpK6rn/RffPP
 z9lrf6xqqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATyeBh+GeVyDXl2PWz0/kn
 fxErfXJWcLvIzgDFK8leCk+anjJufujL8D8/UEn2a1l9r+vhz8peBTtZO7OVdK8wh9z/9/Vdae2
 LfUwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 1bwoida3uwwpgk7rf6qkydaugddq3eup
X-Rspamd-Queue-Id: 05343140004
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795808769-210083
X-HE-Meta: U2FsdGVkX1/eSXkEllM5/m6kfqxPo4zTTfPu5hhZg0SPSOS8/P8j4HjE2Oai+5zqpWYJaYMpGViEqJWNSMwyVup1iMrwuZoQNAkhWn8GZSLBG0VAPzKHQH4+wjgF8wsxE3W25himKalXgwRVP2ZsnNVqbXP2y7KC1UUcQjmEY82Ott+I48JwuyTus3vWZnmxN6zFF3HACeZAMdBtxGF6MUU1PvZD7NuLV8/24zg9NmpzLj0/2MdyGJ2z+E01tEO7Q1R6eL+exA1awKBFwnNKOSQEsNTgEFEXPbz1PcwH807CKFIfulKm9vZXUDoSISIpVeP2mE8GVhVCxj93NJukOmFtYRwbmiefNRo1asORS2Wkl9bn5rjU+oKQv+XmbJOuInFtQGOandj+mznKxV/mXzcdTBw3fKqCcgOmsQmzR53V8QTukIcQSgIaS1twP55AoPg6QCdZJjUMfEJYeqNflecfEeIRf/4Dayfb2Bb2v7x0rhEk1jb25103Z2JFGZgKgExFSxP2e8dek0tDfJw29vE1W5fBA/b4z+AwHK9+KKBFA1hpWiqhSPi56arSh8XQpcNII2XariJuJIlE+GdFi5VWtvsIc4wAI949bxM+0ihtoeEJV7obH07jc4PvW5yjs1OW3MkBWXcZuYo3ZygY1MQqPIXcGjbItVgq0X5RGVrLV3DPtoWoi3Yh2iN7pZtYtOhup/YE+ibkbp7i6EdIYHq5pOP39u2gcCQ6ZONwFB6HYyuV481fjnEmIe1Eew730sD2/cqf8Gd82tlwuS0fNrC6cTd5FptcZeSVbnU5ox8qhCIhbWMZspRxGyyltBHEHes+IgcDVdeGeK3clWJ9FbSCrENcZw1zw019HQIKxQpA1vOfFi9Ms37sx+JNYJsecUDkXP9NrHg45M9UGgci2NDCl1GetOHC3Aiv+tljE3DwKVHdVdPhk8t1YYEM3FoYZSDAIl/BYck5Euaz9IU
 U+PsNbmo
 5BGliVkgXmL5RyyQpv6F8q6AT/g3QKuIWCMz9kHz+fcFsIOM3xWDlYYHad3R73+7aKA+pGsWob8mIiuNPJfPh11GajDPCTxz9FA0i4VoqRVpF8oF+aM867cGg612gOfrGHGVifJ5FDICIDzKEaxOUNOKoyaIsb803LqtCqmRwVpsk7Q3vGOBuBG1o/l6tgN/8Tu2RZrI7AE43A0KyDkEFx800pDRwivl9mTeGTm1+AQt6ueUwUaHzR9TyKoYbb6vH0YzjHyfHZeTqP4vBQhUdmbNeMgP4bELmzCZy9W18x/VYP+kGDmJXdJAgoU/kqV0MjOAQ43ab1Oqiv7arvbWrVM/nbSGnh7bRAhMtpvpqf2H7krnUdpgC9HJiJCMw6r6VNpY013TtMJMv1Yaa3wWWS8ZNIgBwEJwyo/tDsjMTJr0FJUhbg2SapHx2Wy15lKLg/0VNVOcAyOMKl66qRlKdvV/vKn7/SLx7xsfAdYIygT+DOQXNQUiU5hNw4PDXi14KatQgmTRsrfj8MGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

MADV_WILLNEED on memory in swap can OOM kill a task when the memcg that
the swap entries are charged to is at its limit.

The hint is only a prefetch, so it has to give up on a page when memory
is short. But swapin_walk_pmd_entry() and shmem_swapin_range() call
read_swap_cache_async() with GFP_HIGHUSER_MOVABLE and with the gfp mask
of the mapping, so the allocation and the memcg charge can both go as
far as the OOM killer.

The charge goes to the memcg of the swap entry, which need not be the
caller's.

The fix used here is to allocate with the gfp mask of readahead, and to
flush the block plug when a page fails. madvise_do_behavior() plugs the
whole walk, so the swap writes of reclaim can sit in that plug. Their
folios stay under writeback, and with no retries the rest of the range
can fail as well.

The hint can now skip pages when memory is short, whether in a memcg at
its limit or on the system as a whole, since neither the allocation nor
the memcg charge is retried any longer.

This applies in particular where reclaim has to write to swap to make
room. Skipped pages stay in swap until a fault reads them.

Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: commit message tweak ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index ebb4ce7daf6c..8b56f7aea935 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -196,6 +196,8 @@ static int madvise_update_vma(vm_flags_t new_flags,
 static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		unsigned long end, struct mm_walk *walk)
 {
+	/* Only a prefetch, as in readahead_gfp_mask() */
+	const gfp_t gfp = GFP_HIGHUSER_MOVABLE | __GFP_NORETRY | __GFP_NOWARN;
 	struct vm_area_struct *vma = walk->private;
 	struct swap_io_ctx ctx = {};
 	pte_t *ptep = NULL;
@@ -221,10 +223,13 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned long start,
 		pte_unmap_unlock(ptep, ptl);
 		ptep = NULL;
 
-		folio = read_swap_cache_async(&ctx, entry, GFP_HIGHUSER_MOVABLE,
-					vma, addr);
-		if (folio)
+		folio = read_swap_cache_async(&ctx, entry, gfp, vma, addr);
+		if (folio) {
 			folio_put(folio);
+		} else {
+			/* Reclaim queues its swap writes in our plug */
+			blk_flush_plug(current->plug, false);
+		}
 	}
 
 	if (ptep)
@@ -267,9 +272,13 @@ static void shmem_swapin_range(struct vm_area_struct *vma,
 		rcu_read_unlock();
 
 		folio = read_swap_cache_async(&ctx, entry,
-				mapping_gfp_mask(mapping), vma, addr);
-		if (folio)
+				readahead_gfp_mask(mapping), vma, addr);
+		if (folio) {
 			folio_put(folio);
+		} else {
+			/* Reclaim queues its swap writes in our plug */
+			blk_flush_plug(current->plug, false);
+		}
 
 		rcu_read_lock();
 	}

-- 
2.56.1


