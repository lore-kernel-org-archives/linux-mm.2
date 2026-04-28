Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E635FF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667BE6B00A9; Mon, 27 Apr 2026 21:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618AF6B00AA; Mon, 27 Apr 2026 21:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555116B00AB; Mon, 27 Apr 2026 21:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44A3A6B00A9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:35:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E480403C7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:35:28 +0000 (UTC)
X-FDA: 84706247136.28.85B5718
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D280140004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:35:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apaXZdz7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSO/dAsfRgYO5GG3tNqdYXtT24wa/cdQvMrivIrkHtE=;
	b=xz0kHo87dFnVaGMIUvA70D76dOAmgyPGSZ6T7aiNaiAP8ViPJwp5YxYFZruahRn06KwW67
	dWGcMVrV7YhMQDVygds3wSb3xUoK/aDKFWXCOxpaWR2zVOLosC0hg7U/q8qpzheGA2U5d5
	nR4d3oK44PZnyCW/N/UkdN0zwvT9xbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340126; a=rsa-sha256;
	cv=none;
	b=KxvM7sX2F6K3/TYW/g2SEskb9EA7ETWVR3YojK0bgF4AjqN5C/U75ri8B18AffrU21CtDp
	H0/+fE4yagAwM4trEKJxTgYl2JGaohXuETBBg05jsPH/6ZRltk62zx2V+cuIEYTKrEFUG9
	6Pa8u1c/n3ILF1wZqNLcoIp0GwG/h30=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apaXZdz7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE5886012B;
	Tue, 28 Apr 2026 01:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8582C2BCB7;
	Tue, 28 Apr 2026 01:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340125;
	bh=gvVpoMVTCKgQNZqCzuDTpGYLUAXAmkhJCAZl9bSLC2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apaXZdz7Lo2XfVzFBh2pOJN8MiF7jLtWmbtx4vwLQFO/5F6/GXT02Vm91BDuKu3kH
	 iKVeVfnaEYTS99C5Rvsls/ltcbLCkuwqqvV/H3v6HEoJjrXMcJiL7wIpiI/3a8HKAA
	 8f72G27nB9hMUqGj4nPSOMh4v5e3BvXNWtqMqp21Odd7W+7Xa9mvWLTcRzooOJt3Fm
	 L9nAdOV04pJ5/V4y8oDEPE6z4gvhB7u1Rs0GlT+AYy5yyDCLnY2ax7B356uGdX4Tl2
	 xCLWgnzyjnZMpGwjig0XD/DBDKyi6Z9VSgVrPY7OlLIm64MxwTi6/SCU+eNOzceH0g
	 gohVvaIH3fI1w==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: axelrasmussen@google.com
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liulei.rjpt@vivo.com,
	pfalcato@suse.de,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	will@kernel.org,
	willy@infradead.org,
	xueyuan.chen21@gmail.com,
	yuanchu@google.com
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace folio_set_active in PF
Date: Tue, 28 Apr 2026 09:35:20 +0800
Message-Id: <20260428013520.47417-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAJHvVcjH+BS306KKOsFcVKkbmkj0aKXtfpuFy+SVYKE4PQmVQw@mail.gmail.com>
References: <CAJHvVcjH+BS306KKOsFcVKkbmkj0aKXtfpuFy+SVYKE4PQmVQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D280140004
X-Rspamd-Server: rspam04
X-Stat-Signature: tc1egju3hx41amuybck8khgoe5ndkcwk
X-HE-Tag: 1777340126-296829
X-HE-Meta: U2FsdGVkX1/L7/yj5z92SL/OSKXftL73evbOpJcjRrufPs3JAq2a+8NC5VAndvvNuQNUFfXFHzQ+oUG/0dR/p2GMph+RWOWVdHUiMyLWbgs/5UjbP2lKOOkZVFNo5YrjFcRjRO/L1PajNaLTICtCHLaN8uz/5Aw/4R+LgVKYd7Xow79KCiHgjIalMuk2XJHosNB5TB10UG4Ufd28dPopw9uPjkJCrjYWxexCn+TxCyCZ9nmbGcGxClO0P5n2p9hOdlQu9en6tABYNWu2IRWqwZSRE7natyzd+1Sn1LwWb2vlVUxwK6Pb8QtL4EZ9G53M60EZwPsozMu83Ku9oD5RW0gjMFH4kpnuVb2hkNeMhhxzUIXBFoIUcoUWVc9uCocuSZ/vftGPGAPWrF5h5buHkc+Yg4aI9eiY/xrKOKHrS128Dc52/lCBTK/9+IZgkh6asen9WRES68TA2n2biOakVYMy5+OkpPgzF4Rl5BKn9qLxcDFldxufJTZSCUkUK3lNyO5LuufB5wg/GXc48Iu9NB+dTaWkk1BVvydQBEhEMA/RBjnpFzIlNau3iZX7ubcXk0TRKdH/Tf67/Ihel8EAwqZRHpn3O/PfjYvOE2LxUK3K9yKB6CLen3cJTLMMg2cZSh5H/+NbslxGgx8UOBPLwp3oiTQ8HdRtxMppFJG1pu6LFsFNgMWA2cW7A48dCUR3rjUpjCkC1dAyEGNZdOyOYZSzFoeq+cWGRfSldV9Xs2H/YBqqU8/Mnr9RhG9gdEwPKmw6lkFcoKS24Hz7pm7ALvhZs+aorF73k9ruA8QAkGKqgVTOZOry26Xts/IAyA1ZuqFtg0uPamV0NXrOpKQC/OvZkS9bWpkL8ya9p05UDfu0qhUaqOMfDqq3eCnzehBlk5kIeHQOursyBy+B7Go0TLLHzYUikHKCiIhhHVksg0pS2VQxo51AngUsIrZHd4Ahy1S6mkAwyAurbWK/nT/
 mnMNc1E0
 wKCCD7vQj7u2lAEmlbKCqpRCVAVg/jkYncIrcRJb+fNRtYeEf6AVU3m68OK4pveTepfr86f5R7mz9esA5lBOHT9huU9yWuCrSoa8zg5c1NN1pVDSq0JdHlQIz/SZFqb/jB7idkP+Ql7KkJLYpZJUQ3PLbtDiJU9GHcZ2XC7FX2W62vtT/7AGGGIRZRQgsF8vzL3Lh02kntnyv9E62BmDOaYwuUhdmNzfAFNKSM4VqJ7dSkjNzMMpeVxjMlkKIoN6CnmViI3aACvNXNw+atgxz4hirb+D6WJlOPHwf2iayA9i+Yfq0wn3HCqgpIEV7Uu7cUXNa4y/xXlEcgWBcJCFw96Ka8blEiNj576ALw5ML/puGAm9Pyc9EUc1WXCQ64OdPZrR6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 2:23 AM Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> For what it's worth, I agree with this change in principle.
>
> In production we set fault_around_bytes to 4096. That setting is
> surprisingly load-bearing (i.e. if I change it, even at a small
> experimental scale, I expect workloads to notice and complain). So I
> don't think I have an easy way to test this change under production
> workloads.
>
> Like Andrew said the workload in the commit message doesn't seem
> unreasonable, and the benefit is large.
>
> I guess the workload that would see a downside from this is one that
> heavily uses readahead pages but also generates many "one-time-use"
> pages instead of maintaining a "fixed" working set. Without activating
> the readahead pages, does it lose some of the readahead benefit
> because they are pushed out?
>
> About the Sashiko comments, the tier bits being cleared doesn't seem
> that problematic to me. However, the WORKINGSET_ACTIVATE counter issue
> seems worth fixing.
>

I am considering something more reasonable than simply
"fixing" the counter. Right now, MGLRU unconditionally
treats PF folios as WORKINGSET_ACTIVATE_BASE and neglects
other folios entirely. I am thinking of a better approach
that detects true recency. In the active/inactive case,
this is refault_distance < workingset_size.

In MGLRU, we might detect whether reclamation occurred
within the most recent one or two generations. I am
queuing the following for testing:

diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..8b552b3d7e37 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -271,10 +271,11 @@ static void *lru_gen_eviction(struct folio *folio)
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset, bool file)
+				unsigned long *token, bool *workingset, bool file,
+				unsigned long *gen_distance)
 {
 	int memcg_id;
-	unsigned long max_seq;
+	unsigned long max_seq, distance;
 	struct mem_cgroup *memcg;
 	struct pglist_data *pgdat;
 
@@ -286,7 +287,10 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
 	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
-	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
+	distance = abs_diff(max_seq, *token >> LRU_REFS_WIDTH);
+	if (gen_distance)
+		*gen_distance = distance;
+	return distance < MAX_NR_GENS;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
@@ -294,7 +298,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 	bool recent;
 	int hist, tier, refs;
 	bool workingset;
-	unsigned long token;
+	unsigned long token, distance;
 	struct lruvec *lruvec;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
@@ -302,7 +306,8 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type,
+				     &distance);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -319,9 +324,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
-	/* see folio_add_lru() where folio_set_active() will be called */
-	if (lru_gen_in_fault())
+	/* If the folio was reclaimed very recently. */
+	if (distance <= MIN_LRU_GENS) {
+		folio_set_active(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+	}
 
 	if (workingset) {
 		folio_set_workingset(folio);
@@ -442,7 +449,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 
 		rcu_read_lock();
 		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
-					     workingset, file);
+					     workingset, file, NULL);
 		rcu_read_unlock();
 		return recent;
 	}

