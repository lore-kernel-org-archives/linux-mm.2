Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EF9C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:18:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2B36B009D; Fri, 18 Sep 2026 05:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683376B00A4; Fri, 18 Sep 2026 05:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599536B00A7; Fri, 18 Sep 2026 05:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8A66B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:18:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71C58405B9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:12 +0000 (UTC)
X-FDA: 85226331624.15.4D62FA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D24D71A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hp78yatW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hp78yatW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723090;
	b=VolnrdXhR488G0VqQ8MRTrI3mVOzfeP/9jXEite5W7II3i/m1yeJCwosGOoQMt4aBsCkgi
	iAFmC44IgyMNDnviGjx+mmXQrd7Rcqneh1TZQPFEKLwqhe4mVvMa9m9OXpnNRRvv12MCd8
	4QXnPyA3qP8GM2Vq0zpZvCZ0bGg6BDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5oefEc5Fyvm8A9WuNGwURuxRIXHGDSjj8rGrU+vrUA=;
	b=XgG3jJILYLGhztKEZ6qOnlE8QlsoDxzJXgpGaS73sy7Se47A72JiNP7Oxv2/ZNnMK96AmE
	H5c8b7/oO47zOwBPYWPbxIyQxMwjWtzLnMZ1tsep3ugtpfUOryCcoZU4g2WuehZt4HrLe4
	rW4YEcY+X+s50P1uGaMUZeRHtS/vUkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED23C60A59;
	Fri, 18 Sep 2026 09:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C1E1F000FF;
	Fri, 18 Sep 2026 09:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723089;
	bh=o5oefEc5Fyvm8A9WuNGwURuxRIXHGDSjj8rGrU+vrUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hp78yatWIjcbKp8NE3mqr8C8ITGShaALagMql9HAQYlj5aoz04s2WpE3Fyqk/ySYb
	 9YvBd/a5XSjn1YkwOdRTR5bjTpZW9YTUPkzKU5HsgfJV1dvfQW6gTAf7r6zaXwexJY
	 0zGVyeoa/3bGAI4F9cF629tfx/oE0cw8cMj/CGHFwRoMRXhjpb+rU7zybnVYpPk2wp
	 GSywhdmLFE1sW6PrqbmNQuOm9exwT+kt6a54FrPilluc/LHqHs0EG8h0g0OU/6Fyau
	 izmCKjLXgxbZLqlXSS5NsNP2SWnsSJkH7Uui3Dz5zc72rslJowxf0cydtWH0Ce+7g8
	 M7F7/fiikopoQ==
From: Barry Song <baohua@kernel.org>
To: ridong.chen@linux.dev
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [PATCH mm-new v9] mm: vmscan: retry folios written back while isolated for traditional LRU
Date: Fri, 18 Sep 2026 17:18:04 +0800
Message-Id: <20260918091804.69981-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <188835d7-64c1-422a-8a64-6b5e0e960ee1@linux.dev>
References: <188835d7-64c1-422a-8a64-6b5e0e960ee1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D24D71A0002
X-Stat-Signature: 8gc17aw3r69numaa9f6mnhrq3bbzz7kc
X-Rspamd-Server: rspam01
X-HE-Tag: 1789723090-85352
X-HE-Meta: U2FsdGVkX18lUpiEIbnDpMBrkLrOqwJHye5JzoE+aiCLZP+nLhsHmidruLtUCpf4ruSbqvjVCWg7KjfTsUwZeKvnzpq+30u/ohCjdUaSap5VzYj/4uUL0JFrTcJ0tA1zr1S3ge9DxG3vCzAjc4rlX/p4wS87sIJnbbpAawiJa+NyStd4lZlfHpQuMjovFriwBKWcxlk2Sanx/FKWyjoi24MJIEelsfAbe/UTLyWnL9HpPSHL8OrNt/noqHvRymaRHaF/qa/Tuywg6yc/hNPdmFjaJoaJpdupcoRIzqhTva4JFwPAWUz5hUmlzNt6iAoCfVNKJHQPNzmHG6eRhPi32uB6m7s0vFxrk8MIXDyTKEeFKaT3XOxEvggiXRRMXqsKslWSpUCAHZxxbkREFvwR6vi+cR/t/TyWLt5cYpNcX/7FRop3Zg5OCDBiB3ybmQl82NDPctekcaldIqU6JniypEPsbfuUmF49kuOXqxFsmc7r7q0Ut7XsKbaMKuSt5en3Je5Qun4fHRNdyqmBUPtcK6b0VSzXcvmnleMmo0nWVghu38PFdFs6UW9QZU9ZXubydEKHOMOND94ArtHvbcCDZQoUJUDZs0cvqXHT9yxT7vQ3DErjholQ2ZjFIQ8X4yhL1WIe+ea0Pv4QxcCaLfm6M8NbCyw4C0pLWjGA/eYClKTuVJG0evVZv2aaGEUacq9JcmMOaDOd/zPcDyzesQzSWm/80qqKUt7u621+ZvHioICg/SWcdbjG/piLIKBL7AIZPLPUvKhBYHlDi5eBhdJ4WlX3ZKYwRk02Wc0qlLjh4Z+aD9//vEVnHFqrMzRCf7pN2cq0xp2JHJKPFJy2I3ULJaTjmUdHtCG/f5WcfjsX1zbE1D65S6BTZ+15FyX7aPso6hVLQSUkkoyfxNd6VEjxQUw9OUrDQ5LuRKZA4Vtm7IfEq+PK+texXyiL1/R00p/L8IOd8yZX/Pg5s3azOAO
 9LfpqwHg
 AV9FwjujLf3EvLLNOl5b9PtpsCLS1jGYktF83rjPMottGfWyj/8E8G2gehVQ13cTRIjAOHLeXTWM0h7HwzXkBn1l/oGmLMX0YuQFso1y2KT9fHE1L0qWS5Ofs8VteGxGCzZvUdszBQ20hegvV93mSFh/JKPrsW6gIlaK0+3FQlYeRRX6J0qs3E983t/URIchyLqkFc0P5Uf6CZgBYMqJ/gwIEEs+YYHGdF22xmvCfuBkeLSbm6J3TwIBHuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 10:12 AM Ridong Chen <ridong.chen@linux.dev> wrote:
[...]
> >
> > I wouldn't necessarily call it a fix, as keeping the swap cache for
> > those folios can sometimes help with future hits. For example, we may
> > hit those folios again before they are reclaimed. So it's a
> > double-edged sword.
> >
> > That said, the cold/hot inversion is a real problem that we should
> > fix. Ideally, we should find a way to restore the missed
> > `folio_rotate_reclaimable()` behavior, conceptually something like:
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index fde28d0a647d..5ee296474b48 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -891,7 +891,10 @@ long remove_mapping(struct address_space
> > *mapping, struct folio *folio)
> >    */
> >   void folio_putback_lru(struct folio *folio)
> >   {
> > -       folio_add_lru(folio);
> > +       if (folio_has_been_writtenback_due_reclaim(folio))
> > +               folio_add_lru_tail(folio);
> > +       else
> > +               folio_add_lru(folio);
> >          folio_put(folio);               /* drop ref from isolate */
> >   }
> >
>
> That is a good idea. But I am not sure I can find the correct way to do it. I
> will give it a try and get back to you.
>

Maybe something like the below?  I haven't tested it.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fde28d0a647d..906db7d8c043 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1942,7 +1942,7 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list)
+static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -1989,7 +1989,16 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		lruvec_add_folio(lruvec, folio);
+		/*
+		 * Put folios that may have missed folio_rotate_reclaimable() at the tail
+		 * to avoid cold/hot inversion
+		 */
+		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
+		    !folio_test_dirty(folio) && !folio_test_writeback(folio))
+			lruvec_add_folio_tail(lruvec, folio);
+		else
+			lruvec_add_folio(lruvec, folio);
+
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
 		if (folio_test_active(folio))
@@ -2106,7 +2115,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list);
+	move_folios_to_lru(&folio_list, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2217,8 +2226,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active);
-	nr_deactivate = move_folios_to_lru(&l_inactive);
+	nr_activate = move_folios_to_lru(&l_active, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -5083,7 +5092,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list);
+	move_folios_to_lru(&list, true);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {

