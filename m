Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6F0C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6370E6B0873; Sun, 16 Aug 2026 18:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7DA6B0875; Sun, 16 Aug 2026 18:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFC86B0876; Sun, 16 Aug 2026 18:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED1C6B0873
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B79C805ED
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:59 +0000 (UTC)
X-FDA: 85108619358.26.4E39C29
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1A5140005
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U mp2JR5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=VJUR1o9r;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQu6T+lgU+FFDqaM3vM2kEMbX9/iIUBJ0iT3p7UidZk=;
	b=CxIKGLCqrZP1mJ7Db777RWY5o2q3xOXKhgPTBVOWRrLqCtfi2Jk/5nFeq49rNF+vQCg80O
	CD43ga3sWVeLMX5qRon+kPvt2e+05D6Xl3uUoLORBP61HiJXlhUIzbOuCk4xPQ0YRfMSsE
	lvyqj5gWobH9UjbmXWB2lVARp5ZBACo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U mp2JR5";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=VJUR1o9r;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920417;
	b=KvMtBGWT8jvLoGy6gXhWLoGNal6wDm5sqIY+7KXxlsKxZARDtTw6ytDDNYayMaqPC9bqru
	UeGlfFxotHuEUmCGODkOpwDnBFJgpTvaKGd3HMdACTry6cAFYjve40b3wKL7vKZzbcBIxs
	oP8OI8Ua5beb0xqWD7NKMd/HKtYrdLw=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 44C3E1400100;
	Sun, 16 Aug 2026 18:46:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Sun, 16 Aug 2026 18:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920417; x=
	1787006817; bh=EQu6T+lgU+FFDqaM3vM2kEMbX9/iIUBJ0iT3p7UidZk=; b=U
	mp2JR5Lu9hjjdwu6/ZQWvKVFtdYnlCBZG+uicCmp+SUg/360NTTX1awYM5jaoqq2
	rBY/rWk3tYkopKExR3nFX6CXwEIDu3GqAYgcvF5HSAAr9p0jKEgvP06bLA870RJO
	C/V99/ZpKmrxhDz+JR9cuFEYDKptM6bu5e/aNUTftGd6h4I5v00obUcT6eAs3ZKl
	6KEHWUv7yieowRBiie8GeA+ivB03mFSfnzN7C5Y6ssAW98kuIVppF/t6ZU1ODjbQ
	f//EjGkc2FNOpg4mdb3pZYgkLl7K+EAHmWWb6wdBQXci1w7Z7MF+3aihS3zjHmBj
	vMVxRKxXiMYB69T1wx43Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920417; x=1787006817; bh=E
	Qu6T+lgU+FFDqaM3vM2kEMbX9/iIUBJ0iT3p7UidZk=; b=VJUR1o9rvJbGtzh3V
	VBs2bRwDDvy0aLsr2PnsD192uCbrJwf4UDphyR3f4nds3mKvDMF/Qkn2Dv8qopVU
	sggwudKzLaKJnsjzhDdPBMkEtZUZVPTxEhNQkQVVjHDHvMtHh4kPROHRGHshkJTJ
	PFgAv6Qp82RR6b5GylgrOe8Sf7OJ0eeSMdoFqB7bGAVZJetzgrFciY5o8bjBvRo0
	GfjAJsrkScVza4YoCtb1PA6UR3CvIDX7iT5cKq/1c/V5G7HPY0hvFL7pGPGfWfjp
	EkHJP84c0Q6bQY8V2p7bwKZLv0Wcye+gZ7GoqcBheq5L4c4yIiFqFvJwNTOf4V6S
	PhD1Q==
X-ME-Sender: <xms:4D2Capbl5tx0I6fFocuZYOPGGsKLzFJ0l18GKGCWFEwUByQ6tg6kwQ>
    <xme:4D2Calu6TwVXjzsu13SKbLrC4boSweREleMu-HunV-fp7-8ae74zxgPV8Cum1x4C2
    aSPAiEd0aeRiXD5Qat3MMfZveP8vyLxc42nYxT9oXXuzpogUVh68qU>
X-ME-Received: <xmr:4D2CaoASEvcZ0xitd4j7cMkJdAsIe1b03N_IM9CT6c8VC3kYmYJ1Tx520AM>
X-ME-Proxy-Cause: dmFkZTGj1BuhETEStCjbN/L6JrGmiaqzRpeX6rRNWhHsAzwzRlY9AKzqCvfWqke6XA7GOE
    A6FFYRRSvteD9S264L5lew1YUpPhGI3TlhRe1mYLYRUsBMnidhJP2r2PMm5Lpq2ztO8wmr
    yF1ddTX1W5NBA6qs0+EDXUaWwTs6UQPsEiicZ6SmY6z0vOVnZaAe+3gsuR1dg3g0gP4peZ
    U6KBKKlAxat5APGrEFg0r1ubDi9svGZRyISInygLcwTo8cXqakBbn35auVMrKeg7PKmswS
    qkEQEJGI+h4SGQWw8a8xHcXO10CUTBpRtdxlbIKv4nbtwWiZJ1jrVLIQttQS09NS+fWjUx
    bbU18ME9VB5GU2gZOkOiPzSzfvLBB2gKm3VPT4Jvs4WJlASKQCrcJfkt1KsUDLDw5GtOlj
    5h1b8gVcH+y8R4+XAP4fykvX9OA01NzIsYP1flpH2DxLcDCL/Z74+wcUZ3/rUdosCzCYPa
    4QOUrJOowaj8VVpAyzhIuwB6AzFzUdB5E0IHAQgBsmOZddb9BEIKS+sLlBCjYjgErEhYF+
    UTKZzgA+PYxdRSZgiTUWwWkTaCL28GJwHzQ3SUyJ0fGZmD2knP1midXv4+VODV1YSbH3HT
    dK/V64rcrhNHP3t/5YY3nBM7Po8YEWEv2Ay2k37+bp3BgltPHNNAT6tlhQuQ
X-ME-Proxy: <xmx:4D2CakPD3VqdPbSc1Xx1grOGXoWxSuVWVWRmXhVi1SK3PM5ldSRJZg>
    <xmx:4D2Caq6W_wioMh4q_Edx-LlutNy-fs6CubbcrGYhGCpJycppIvc0VA>
    <xmx:4D2Cam2anFIBWp_5R8DmO6rl7mmZKFbIQdXjFUUUCbTDOfDf6hrbWQ>
    <xmx:4D2CahoDsB7RDmWPt3QXK3LBOIbB0cxKQx4b17rML7cKs2UBjxltwA>
    <xmx:4T2Cap4_bWX8jDVTQqnsG5DhJdIVn6uLkJnOgQIVQOlNwsRyydgrf6RV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:56 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 20/57] mm/collapse: put the sources back
Date: Sun, 16 Aug 2026 23:45:32 +0100
Message-ID: <20260816224609.308019-21-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1A5140005
X-Stat-Signature: jsgrjeimccbndi83fmcaztfhwbwirt3e
X-Rspam-User: 
X-HE-Tag: 1786920417-823843
X-HE-Meta: U2FsdGVkX18oOhuc9HhoVj749zsoGMmnxRGY9rYdVkG/7O6SKNHYuMGuVZCqkqcE7LwGD7VGfhmy1gSX4Az33kI+sdjd/xCDyXrFV/C5/c4F8it05RsdwBD3XonHnaFid2oIW46mEf+esG3OnRV+s2m5cItpQkpZZmO3KdgUC81WY0usqeyiJ8OL1Ib3xN8odS6RB8SQ1rgGylrN+c/VPKK6hd4Ibvw246LEWZt1J6GhLlICMvgf9+MJGyqxjZkIt+FF2pVK6WKWh7sBYvM+un6mciHElrmWcXg5gZVSaKmKYzfFJIp3axQifkyN93gYZ85unjG4NZ7a2KuXGeF1t9wnRUZHs5JUrZT3gYNoPLQGw3d3ipb0X4e5CuP+NOziHYBBJ0e1rDsjJ39INtbb2QJcLm4+s58ou4AGUyI1U8PN7W7uTTnHqV/dyzE1dOH71xxHd7ha21YVtDnZ/yDE5uU0SriyyrzZyxNC2d+HRFyQkqu4jYl/E6qBaNYerZXFwGe+7ZhfBbqFFK8/Vy/jTgP12ZrghYWjhqP6ydasAeaZrLa8CFZ9oFlrulk2uuDQAXJbAMtphTNYRGLrjYb2CdRpevHfUUtMunz5eNbb4o3TAjvcHS6hETEQJynYazyEAhaFEeZ2N6GQHFAIgSL20azegqhtYQOZwakPtcnZAyJ0VRA5Jh1oHekSS75uvqHeupCoooHNQDyAA6rZK2uJFoBJzCKbaJstvZk/OwftFE/K2rwcZRtJNGEOSc9iwDtDitW2l5krx7Qr8LsdXAc8Y5Bt5qx7Mpb9pDc3ZK45cxeym3QOP0dohPcZFEOIuhNhUfQepOiAomb4iAmdRcYyUWrVWoXY37rDVuASSt9pgURjdW0tu3xHjcRa2FKR5lhLtC9T+2C/D4cikB9TaQSj8oyTfmFHRTxCkQDlDN0sppjgMOghMaQvN5qRE1+5F16NCGR9Iomuzw93hzP5HK7
 Tquo5K9h
 U7oamvVzp2qZGq3i8v3DAcX0nM8eTfi7knc0+bmvoyCrvD3NH4QsHIlzHLovdZNuD3hUt2vPolI8/xgbNBdhekyTnOY3TfKuGczjo6+ILM+LLdpu2ve8z5sFPDzy6wbBGfU5/ADvmy9vcixJchdkzhhfnihCz2zSl+ggL7xGDXrQbe1hHcwXM0IVeqsM5fmuhiruszOC+w7kLSTdsvSJFxsJ0XNHncOdlNfwB+Eltz2JVlNnrb2hJeJWZ2Syp/xbLZFSeRwBbVdH3CdTa5BMr8ETOWVDR0S6mdDoR5bvGg+g/kTbIHP04s7Muevwz531M25TTFrDxD3vPkLQpu1/BHB1UhQ3c9t/gaHHex8n0LB4KpDNOZNxYOClbBDkoEl4dOGAsY2DtW+jUtvdl2QWg4UVgKo99a8FFOrNAyiMHvLP4qyMH5DyNgMfko4IsGQDc7xFV7sUIed+ybRJ5SK0NjcNy/08pGh4K+bXwJgZpzS9FZEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the putback: for every installed candidate, lower the barriers
the freeze raised, span by span.

This is also what wakes the faulters the collapse held up.  They sleep on
a source folio's lock; once it is dropped they refault and find present
PTEs pointing at the new folio.

The order within a span is important:

 - Unfreeze first.  Rmap removal munlocks under VM_LOCKED, and
   munlock_folio() takes a reference a frozen folio forbids.

 - Then drop the rmap.  Until it is gone the expected count still holds
   the span's mapping references; afterwards they belong to the round, so
   every folio_remove_rmap_ptes() is paired with a folio_put_refs() for
   the same slots.

 - Then unlock, which is the wake.  Holding the lock until here keeps
   lock-taking rmap walkers out, and the window it leaves -- a live folio
   with no PTEs -- is one any teardown of a mapped folio passes through.

 - Drop the references strictly last, the round's included.  Waiters wait
   without a reference of their own, so the round's has to outlive the
   unlock.

The stale swapcache entry goes too: the copy has replaced what it
described.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/mm/collapse.c b/mm/collapse.c
index ab7476471b8d..f65f413339bf 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1439,6 +1439,56 @@ static void collapse_install(struct vm_area_struct *vma,
 static void collapse_putback(struct vm_area_struct *vma,
 			     struct collapse_control *cc)
 {
+	unsigned int i;
+
+	for (i = 0; i < cc->nr_candidates; i++) {
+		struct collapse_candidate *cand = &cc->candidates[i];
+		const unsigned int nr_pages = candidate_nr_pages(cand);
+		unsigned int k = 0;
+
+		if (cand->state != CAND_INSTALLED)
+			continue;
+
+		while (k < nr_pages) {
+			struct folio *folio;
+			unsigned int nr;
+
+			/* A slot with no source has nothing to put back */
+			if (pte_none_or_zero(cand->saved_ptes[k])) {
+				k++;
+				continue;
+			}
+
+			folio = pte_folio(cand->saved_ptes[k]);
+			nr = collapse_saved_span_len(cand, k, nr_pages);
+
+			/*
+			 * Unfreeze before the rmap drop: rmap removal munlocks
+			 * under VM_LOCKED, and munlock_folio() takes a reference
+			 * a frozen folio forbids.  The expected count still
+			 * holds the span's mapping references; once the rmap is
+			 * gone they are ours to drop, so every
+			 * folio_remove_rmap_ptes() is paired with a
+			 * folio_put_refs() for the same slots.  The folio lock
+			 * is held until the wake below, so lock-taking rmap
+			 * walkers stay excluded, and the stale-rmap window this
+			 * leaves -- live folio, no PTEs -- is one any teardown of
+			 * a mapped folio passes through.
+			 */
+			folio_ref_unfreeze(folio,
+					   folio_expected_ref_count(folio) + 1);
+			folio_remove_rmap_ptes(folio,
+					       pte_page(cand->saved_ptes[k]),
+					       nr, vma);
+			folio_unlock(folio);
+
+			/* The copy replaced it; drop the stale swap entry */
+			free_swap_cache(folio);
+			folio_put_refs(folio, nr + 1);
+
+			k += nr;
+		}
+	}
 }
 
 /*
-- 
2.54.0


