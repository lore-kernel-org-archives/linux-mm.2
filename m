Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76F78C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30AA66B008C; Tue,  8 Sep 2026 06:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB5C6B0092; Tue,  8 Sep 2026 06:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1216B0093; Tue,  8 Sep 2026 06:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC84D6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:29:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C9B7C04EC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:29:39 +0000 (UTC)
X-FDA: 85190223678.04.AC3FFBE
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D105A0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:29:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xo0G8Ysh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+fgbcLp0bGi9YPxNFxzWkn6nDD8wtPYbAik5t4pCTc=;
	b=KKhFqa+nA20ycn2cYYLUxH3UGK7zlLMCIua56bI1fDXjqAsfJtou5MPyrLGvZ1R3SB6KD3
	+dOhiBNBbf4HALoz3rWl/j5mWT3OhHSWeBlvaGLox/lI0BUBQQESvNf0Fi4QpONQFb67kQ
	wv4pJbsof+sQgHAVRv1qtqQXfM88ask=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xo0G8Ysh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863377;
	b=IhSWIz1FRjWqSVE9+wexQ3JXB26ypRkQ/ukkS/pwuAoCWFpU8fdOLJfROP75dhCx56TMCl
	Oc2VL9wumRq9RywSW32cic4p3Z//rvf0ytEya9zuwMSGsTFewFPWQw/FeKPMUeOYiN/bu0
	/BUQT7Q/TuI398qbRD7B5LICYIM1flw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0huURJH+bq7BGRuA49dbK70WUA8RUUT6E5UMwxs81nc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788863375; v=1; x=1789468175;
 b=Xo0G8YshDHvlyYXPhTHZ0GSxNbZa/80xWtlp3z9OZqEvMuqqHi5n6WjvFuIH9Q/1e5oqn/Ne
 8NPeDBDizmBvdJLPimQY3GC8SfZaW9JnZObVcW6I8kB+lCyELv4R0jsPaRxaqH1UWEYhNGC6Y7g
 DHtsUP2t2vm9bcg6NPMvMvQY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 965e93f6bc2a3c87;
	Tue, 08 Sep 2026 10:29:35 +0000
X-Mizu-Trace-ID: 965e93f6bc2a3c87
X-Migadu-Flow: FLOW_OUT
Date: Tue, 8 Sep 2026 18:29:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
	ljs@kernel.org, ridong.chen@linux.dev, hebaoquan@kylinos.cn,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mglru: clear the reference counter for rejected
 folios
Message-ID: <ap_jiN_ogpeaxlGv@fedora>
References: <8e4db9a298c5ea6ccb192e274caed5b96f0cf022.1788751143.git.baolin.wang@linux.alibaba.com>
 <ap9zPPughaSlfXM2@fedora>
 <CAGsJ_4wn5ArqhG9w7gJY7X4G+Lg6=1teCb70dzPdN0k+5H8MbQ@mail.gmail.com>
 <67d9bbcf-2991-4867-8afb-14bad1cebf8d@linux.alibaba.com>
 <31494361-406e-4874-8a2c-2c6f5cee5321@linux.alibaba.com>
 <ap-yQOH0pni-mfdf@fedora>
 <ccb8e121-bf5b-4bb4-a9de-fb5290998ddd@linux.alibaba.com>
 <ap_GBGDHkEzZ1Osq@fedora>
 <7d2ee486-0f59-43b7-8449-fed82b796a73@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d2ee486-0f59-43b7-8449-fed82b796a73@linux.alibaba.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D105A0005
X-Stat-Signature: ma1r9wh8bcyefzxt6qikz54h8wbnwe3d
X-Rspam-User: 
X-HE-Tag: 1788863376-72159
X-HE-Meta: U2FsdGVkX18ZM3hUvyASjS07ccki7RaA/pAdXDz7yLgzLz4M68ixt4PKj1qVJxTzhhruWH28Cpuy/GZqtuYmSEg7pwTUXGobqXneFh5vwGJCyOso/n4jpLl0JQXlpzYXdSWsgso9u85rO7RQoVXQuRwRplSUVBNYfmSg/HQrKcw0GNz5quSVv2pVKQtakRaW7aFXGYJHZd3LrW205b+RKnPIl9xDNbbZf+9mz6gHGsvItRD7fOSp9cHkrlPTRf1NQ6mbncpNQt+098g65xvpPlQwAakDqo/LgJsbmI7EtUaBbJfFPkUAnTwdxd02s1n6+EcEFm8aXf1bG1K/+ULdOIgQFJXPG6NEiHxYAMKBuXKIoO2ZqVllIm8dSTvYKsUuYg3B7ulcWoEa//hNEScAwxWfs40JCvHMzqbAONwzn37JkjheJHtCYT63cDB5KMMfvzUNv0OhF/vXYFrrwmZkg7AQVFQRYQ4s+WLmZ7IQhMIzVr2XXhKQ21haXOTvyiSNaXIvpqw6dYhxsYqIU9Wkb97Iyd/qNEvuhLttWmN9yUzwUNMzovH3CrxCrXIcM4Wt2KFmcrLPlsyjjbrn9fdVZpLQFoKO+/y2uuBUKCT9hsHAkK8XTxr4P1Qr9CVSgXUTQB/kvF0wtbLnU8tji7WYjDX9tZiwcJeQBYHKNJ7GKMdyEDsU1bgDE3HoE8P5FA/Ln5/4cq1cxSLO9/tIPKIQrLlanfM1E1rP2niXRGwZWw5KBQ+O9Ti5nsS0/X1kkgMYTiExs+8+6ZyD/lWppk2RrFc2zevnCYggTGeG8rm+kYW+Y1bp1F2OBsupGPIgw/8N0NPaKTUhVGbcjfW50ECUKLb+VcUI9e6A6gWVysGe8pZGwjfoRYvA7et5HXoKjYpF0TJy3uIS5VEZDvIQNsbFmKsVYVwqV5TNJlDEAiRPtfEbdiY9qNjJDQP+uTgCgbtW2zdJjwIakeky5Z/wIU5
 6+r2V6hE
 X93bxqSeRPkGRHipkPRy6NNVRvrRujegwq+snIBNTeW4OT2sZ9+44ivx7FXsv4OPUtIDqVHcD84422GaeKD3UTOw1wMNzjxUM4R2EyhinNMipJNtZfuA5IucI/tfv1QPhJYH8KS4R9UZT9iQACO01RDHcfTemUJJZPvBsmYbjxfyKuHUBmIfIJPdsfoITWPAdwWYC1eBut0hilH4YkiyWKH+pbzVH1fffAaiyRTqWgec41g3JPm7PvrGTTcf9y/PdUBDrhMZmqa4sburAFN6WqaHIvoHocPrvJdKTPFbDe7BChHjvnDfdFJxWszKx2kA/AvCTaqlTPTw+BVn+VwI2x2sVRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/26 at 05:39pm, Baolin Wang wrote:
> 
> 
> On 9/8/26 4:23 PM, Baoquan He wrote:
> > On 09/08/26 at 03:53pm, Baolin Wang wrote:
> > > 
> > > 
> > > On 9/8/26 2:59 PM, Baoquan He wrote:
> > > > On 09/08/26 at 12:01pm, Baolin Wang wrote:
> > > > > 
> > > > > 
> > > > > On 9/8/26 11:03 AM, Baolin Wang wrote:
> > > > > > 
> > > > > > 
> > > > > > On 9/8/26 10:34 AM, Barry Song wrote:
> > > > > > > On Tue, Sep 8, 2026 at 10:30 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > > > > > 
> > > > > > > > Hi Baolin,
> > > > > > > > 
> > > > > > > > On 09/07/26 at 11:25am, Baolin Wang wrote:
> > > > > > > > ......snip...
> > > > > > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > > > > > index 40d3f1b48a74..42c0a09938ab 100644
> > > > > > > > > --- a/mm/vmscan.c
> > > > > > > > > +++ b/mm/vmscan.c
> > > > > > > > 
> > > > > > > > Well, this seems to be based on Andrew's mm-new branch. I usually track
> > > > > > > > mm-unstable branch. Maybe the subject should be marked as below?
> > > > > > > > [PATCH mm-new] mm: mglru: clear the reference counter for rejected
> > > > > > 
> > > > > > ACK.
> > > > > > 
> > > > > > > > 
> > > > > > > > > @@ -5021,10 +5021,11 @@ static int evict_folios(unsigned
> > > > > > > > > long nr_to_scan, struct lruvec *lruvec,
> > > > > > > > >                  }
> > > > > > > > > 
> > > > > > > > >                  /* don't add rejected folios to the oldest generation */
> > > > > > > > > -             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > > > > > min_seq[type]) {
> > > > > > > > > -                     folio_set_lru_refs(folio, 0);
> > > > > > > > > +             if (lru_gen_folio_seq(lruvec, folio, false) ==
> > > > > > > > > min_seq[type])
> > > > > > > > >                          folio_set_active(folio);
> > > > > > > > > -             }
> > > > > > > > > +
> > > > > > > > > +             /* See the comments on LRU_REFS_FLAGS */
> > > > > > > > > +             folio_set_lru_refs(folio, 0);
> > > > > > > > 
> > > > > > > > This looks like a great catch, while the code change could bring issue.
> > > > > > > > 
> > > > > > > > Because move_folios_to_lru() relies on folios' flags to decide their new
> > > > > > > > generation. You just cleared it before move_folios_to_lru(). This is no
> > > > > > > > problem for rejected folios that are determined to be put into the
> > > > > > > > oldest generation. But for those rejected folios that are determined to
> > > > > > > > be promoted, this could be wrong. E.g currently gen window is 4, and a
> > > > > > > > folio is referenced, lru_gen_folio_seq() decides its new gen as 1, which
> > > > > > > > is the 2nd oldest generation. While folio_set_lru_refs(folio, 0) clear
> > > > > > > > referenced bit, this causes it being put into the oldest generation in
> > > > > > > > move_folios_to_lru(), this is not expected.
> > > > > > 
> > > > > > Yes. As I discussed with Barry earlier, lru_gen_folio_seq() also needs
> > > > > > to be reconsidered regarding whether it should rely on PG_referenced
> > > > > > [1].
> > > > > > 
> > > > > > For commit 6cbdd9726fb5, we didn't discuss the impact on rejected folios
> > > > > > either. Before commit 6cbdd9726fb5, if rejected folios did not have
> > > > > > PG_active set by shrink_folio_list(), evict_folios() would set PG_active
> > > > > > on these rejected folios.
> > > > > > 
> > > > > > [1] https://lore.kernel.org/linux-mm/20260901220430.79810-1-
> > > > > > baohua@kernel.org/
> > > > > > 
> > > > > > > The original code looks quite weird. It even prioritizes folios
> > > > > > > that won't be promoted by `PG_active`. Do we need to change all
> > > > > > > the cases just to call `PG_active`?
> > > > 
> > > > I would agree if we can. While I have one concern. A rejected folio that
> > > > should have gone into the oldest generation is now being promoted to the
> > > > 2nd newest generation. In the original code, referenced folio is only
> > > > being promoted to the next gen. I even think this is not a bug, but Yu
> > > 
> > > That's not quite true. Before commit 6cbdd9726fb5, a rejected referenced
> > > folio was also put back to the 2nd youngest gen.
> > 
> > OK, I didn't follow your earlier discussion, I need take some time to
> > fully understand that commit and the patch thread from Ehab.
> > 
> > > 
> > > > Zhao intentionally did it: the coldest folio is moved to 2nd newest gen,
> > > > referenced folio (hot folio) is moved to new gen but carries the referenced
> > > > bit. Both of them seems to be treated somewhat equally.
> > > > 
> > > > To me, I would rather move both of them to the next gen, while keep their
> > > > refs untouched.
> > > 
> > > IMHO, I strongly recommend not doing this, and that's exactly the motivation
> > > behind my patch. Because this is also being treated as a promotion, it
> > > should behave like folio_inc_gen() or folio_update_gen() and clear the refs
> > > after promotion. I think this is a fundamental principle of promotion.
> > > Otherwise, ref-based promotion is already completely broken.
> > 
> > OK, it makes sense to me to make principle of promotion strictly applied
> > no efficiency degradation involved.
> > 
> > > 
> > > Next, I also plan to clean up refs in lru_gen_set_refs() as discussed with
> > > Barry.
> > 
> > Looks forward to seeing that. By the way, your discussion with Baryr is
> > private or in public list, do you have pointer if public? Thanks.
> 
> I raised this issue before[1], and recently there has been another
> discussion[2] about it (we had some private discussions, but I'll post a new
> patch for discussion).
> 
> [1] https://lore.kernel.org/all/eb395442-0aad-428a-a5ac-9072d2d89060@linux.alibaba.com/
> [2]
> https://lore.kernel.org/linux-mm/20260901220430.79810-1-baohua@kernel.org/

Got it, thanks.

> 
> > > > > > Yes. Regarding this concern, I plan to change back to the original
> > > > > > behavior:
> > > > > > 
> > > > > >        /* See the comments on LRU_REFS_FLAGS */
> > > > > >        folio_set_lru_refs(folio, 0);
> > > > > > 
> > > > > >        /* don't add rejected folios to the oldest generation */
> > > > > >        if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
> > > > > >            folio_set_active(folio);
> > > > > > 
> > > > > > What do you think?
> > > > > 
> > > > > Just FYI, after above changes, the performance improvement on zram is no
> > > > > longer obvious either. I think this also answers Kairui's earlier question
> > > > > about why I saw a performance improvement (which seems related to commit
> > > > > 6cbdd9726fb5). Also, there is no obvious performance regression either.
> > > > 
> > > > Hi Baolin,
> > > > 
> > > > Not sure if it's convenient to do a little more testing in your side.
> > > > E.g rejected folios are moved to next gen, but not clearing their flags.
> > > 
> > > I'm not sure what you mean by "next gen" here. If you mean the 2nd oldest
> > > gen, I actually tested that too, that is, clearing refs after
> > > move_folios_to_lru(), and there wasn't any noticeable performance impact
> > > either (but the code was a bit hacky, so I didn't go with this approach).
> > 
> > Yeah, I meant the 2nd oldest gen, while what I am curious about is moving
> > them into 2nd oldest gen but not clearing refs. Clearly it's conflicting
> > with your plan. Anyway, it's just a brain store idea, please forget it.
> > Thanks for the sharing and detailed explanation.
> 
> Thanks for reviewing.
> 

