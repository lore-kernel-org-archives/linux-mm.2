Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3111CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 06:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085D76B008C; Thu, 27 Aug 2026 02:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036D96B0092; Thu, 27 Aug 2026 02:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8EF46B0095; Thu, 27 Aug 2026 02:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8C486B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:14:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2759B16030B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:14:16 +0000 (UTC)
X-FDA: 85146034512.21.6134BB0
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B15B40006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:14:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUocv3Jc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787811254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=71vFXLB7wvCkbfe3xKyXWrCapf/jsLeMlO4WUMknXxk=;
	b=TqU4/NmAeVEyKdr+IXot5Tr9D5HjD7HgTgQNls3mF2ewLiuVyZkGAIsabQ7zciMr0HKAuT
	XwsUoPPG/9L2+AL6TJdTcwk557YEKBEexoyk/AxZ7VZvAheAuTZwUGUu3Ivhoe9gEFcGGp
	6No0GXiUn/DG86s58+gSKpv8g175jjE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUocv3Jc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787811254;
	b=PtHe2WxGRQ57MvA+FgLgGB3qVZ/hSCN9D6TTvLaYJNV2HADjU3PNAeKwxoa1pV+1XshQo/
	w4oLajCywWsstWKwkbcap26L9P/ylovVw2HKkukQWKyb1ixxKO/xNpY7GmZkeWGeFrk1MP
	grnNN3v8uffDOYkZ38Eqn/kf3fJqvt4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=faw8/dnfmpbaj8fTupjGI2ULYE/JNU+cOt0zt+zua4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787811252; v=1; x=1788416052;
 b=VUocv3JcmQ9g+eKpp8OWmPPO4hbNqPaD9f7etoJPNbDeyVxiXQBeIWn7ux+L2eEXTqkrix85
 7FmE/76T6KCXebnsVW1rdOURbQvks5i/EypIopSTtlbw7HrtcvQ2fAsRRmfSwWhAs5CoLAw1oKc
 w0HOkYQu/70suJWH5PYtBfEc=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta10.migadu.com with ESMTPS id 7489c2729e336ee7;
	Thu, 27 Aug 2026 06:14:02 +0000
X-Mizu-Trace-ID: 7489c2729e336ee7
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 14:13:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com,
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com,
	yuanchu@google.com, zhangbo56@xiaomi.com
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
Message-ID: <ao_Vn9GIEROHlhVK@MiWiFi-R3L-srv>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora>
 <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
 <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
 <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
 <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
 <CAMgjq7CgT9yCz9bhfNtrsjNHh8=1F4zV7BKG4FRB5xWaLh+NNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CgT9yCz9bhfNtrsjNHh8=1F4zV7BKG4FRB5xWaLh+NNw@mail.gmail.com>
X-Stat-Signature: e5iunos9yrp7ni1pzir8ffceeoygfkdr
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1B15B40006
X-Rspam-User: 
X-HE-Tag: 1787811253-665752
X-HE-Meta: U2FsdGVkX180lC8P6UaHjXGIoMFQ3m8Ci6GzkjsoBy7ur4DGgxW9n11Eg5rndnWYl4PgWG+aCF+ev+JTwBfxDNi0lMFqJZVfdHn/jBHIXDzQFnEpagQdFqJIto77K9VcUwxvCxjnaZi4rhdwTK3jmgqeo/Du8DdiDoOtFvGwIC1VH8SQQn/+eQBW4hVXH4ETliX1gMi5Lvf9w+ypEzsOM6FaC0joVr9dMSUL7f5i1N998+8sVLjBk03bjZ0awT9C91ID2ao3PgWcO/ZZOuRuJCwlvb51FqiRPTnHWBvQKw6P0KARFFro61HID+SKMOFXqigeBUIT74N5/MdVMEIFPOO/qTqP7vfDIRifcnI0ylEq48M59QTE6Lgu0M/fwSpNqAptU61jx6dq2d3IDPew831jhz0n8CxJvqCZjFlUqfQM7x10PTKqaORB0K9iv24XftWdv7NkevPPtJ4pNNxfgyPLZu0zRgJypRfS2el5y7CNAeWXaDPkk4LFtf6RAmXmrvYGaJvO33yKydvBpzsO3Njb0WjWMGI8Z+k3Pxl0u3c3WAZJxO9Y6CQ6zE2I4WxSSX41ZYnAcqIbe/6vcNhPF2RxIH4XBeWpnhzIubFd3uVkfOTt8WBpxTFMH+LL5W2zirck2TU2U72DDup14HcyI8iW+fQJpmo8HnYAL3dTjvNl0ce7Hpba0cQrFgUgIOvSCkbUWmac/7s2ZIWM43kL0mroOHiU/t6vIlIx8DTHzI7X2BwGMC/Y4efHL144zf1o4mxkciitaJwWPfomgfoPkEh3RX+1FKJ6aop8BAq42ljUFDuvFs83PKuibPidyHinhLNWhnJqVdjHYkA3KUK5zVt66rE0RIEAU7aM7UQwg3JHctMfGWhAs/6+l4szohk0sOzl8Fwv00clbhl7n3bsA6xZocahZLqX9kgLaOVSPougTun/dZtCi4HBhur1T30EO9Qk2q+zvrfZVd3jW11
 WWktGvuL
 2zIvwY+RrOBc50+yPlSZODAwzKncqm7C6+IfMzuSY/3YDAPOUWGgKw9qXNCU1tCQHCRwI3tJ8RXfKEh9og3OaIdRPqUvpA36iLy/T3sT3Wf5c+vOtKuz1FzDNrFvo/HeYRRBd7Ej1Kn5quYhq+EKkCB/CxTdIGQpeDFxiZXJkU+7Rj73f46eiDPsCdG6VWWGNUixHnii6zvWcFIiiaZM4Pf9GJ5KfIfeZ7T4rtoWrGxK0bRZ2TgUSWZLYxxHogh9I+mljBbHaF/2QBoJy9jZTqz2jg3JiY+c8bl1stLUnEmXJAO6VaSdVvBsp9UBKU8acZrermbKKug7juoew6Lp/FmXeHSXLEKvzXHveXnCwpYa6nObUA8+WUtERw+W3R/AymZTXGukBjlEsFU1pPksT2quzOPFR9j2z10erO+GwCj016SMJDKGaKg5+DSsVIV9GDszPQDf4laBntqwbyhVKQbd4u2Nx61NzFB4/AtDWua+YMxPOu1dMONH5yuVVBy4Cr5cj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/26 at 12:30pm, Kairui Song wrote:
> On Thu, Aug 27, 2026 at 10:14 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 08/27/26 at 09:24am, Barry Song wrote:
> > > On Thu, Aug 27, 2026 at 8:46 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > >
> > > > On 08/27/26 at 05:43am, Barry Song wrote:
> > > > > On Wed, Aug 26, 2026 at 4:56 PM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > > >
> > > > > > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > > > > > During aging, a folio's generation may already have been updated by
> > > > > > > folio_update_gen(), even though it has not yet been moved to the
> > > > > > > corresponding generation list. Such folios are hotter than those
> > > > > > > already in that generation.
> > > > > > >
> > > > > > > It makes sense for inc_min_seq() to increment the generation of
> > > > > > > folios that were never promoted during aging and move them to the
> > > > > > > tail of the new oldest generation. However, folios that were already
> > > > > > > promoted should instead be moved to the head of their updated
> > > > > > > generation, just as sort_folio() does in scan_folios().
> > > > > >
> > > > > > While sort_folio() move protected folio to the head of next gen too.
> > > > > > It only moves ineligible folios to the tail of next gen.
> > > > > >
> > > > >
> > > > > Hi Baoquan,
> > > > >
> > > > > Thanks for the review! I’m not quite sure I understand what you mean :-)
> > > > > Could you please clarify what you’re suggesting?
> > > >
> > > > Sorry for the confusion, Barry. I meant this is a good one, and
> > > > sort_folio() has the similar issue in which the protected folios are
> > > > moved to the head, wondering if that need be adjusted too. One consistent
> > > > rule for both is better.
> > >
> > > I think it might be fine for sort_folio() to move protected folios to the
> > > head, since those folios have either been accessed multiple times or have
> > > reached a tier higher than tier_idx. They are sort of hot in theory, right?
> > >
> > > if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1)
> > >
> > > But for inc_min_seq(), it is just catching up to make sure the newest
> > > generation doesn't overlap with the oldest generation. Those non-promoted
> > > folios themselves aren't hot , so I feel these are actually different?
> >
> > I got your point, sort_folio() considers the hottness, inc_min_seq()
> > doesn't. I agree with you now. Thanks for the explanation.
> >
> > BUT no matter what it is, protected folios, lazily promoted folios,
> > and no matter where it is, put in head of next gen or tail of next gen,
> > their refs are cleared by folio_inc_gen(). Then in sort_folio(), they
> > are all tier 0 of the oldest gen and must be reclaimed.
> 
> Hi all,
> 
> I think this part is not true? a folio's PG_workingset will never
> be gone after set, that pinns the folio to tier 3 through folio_inc_gen.

You are right, I missed the PG_workingset part. 

But then folios of refs 0 will get the same treatment as folios of
refs 4, even though later the tier_idx == 1 or 2 in sort_folio(). This
sounds not reasonable.

> 
> In fact, I consider this a pitfall rather than a gain; many workloads
> have seen regression due to the over protection of such folios.
> Especially with that "refs + workingset == BIT(LRU_REFS_WIDTH) + 1"
> 
> Resetting the tier to a lower position is better if the folio is
> promoted by one gen due to protection, to avoid over protection IMO.

Yeah, I got your point and agree. I am thinking of this too, agree we
should respect more on gen than tier for protected folio moving, while
it's not easy to implement.

> .
> Changing that semantic will require many other adjustments; I suggest
> we just ignore that here.

Hmm, my thinking is if we should differentiate folios w/ refs with
folios w/o refs or folios w/ a certain lower refs. Moving them all to
the head of next gen, this at least giving them more time to live and
update refs because eviction pick folios from the tail; or moving them
to tail of next gen, retain limited refs.

> 
> >
> > So here, I think differentiating them and moving them into head or tail
> > doesn't make sense, the thing is whether if we need do something to
> > retain refs of folios when gen_increased. At least, for lazily promoted
> > folios, it should not be put in the tail of next gen and refs cleared.
> > What do you think?
> 
> Actually, retaining refs has a very limited effect on the current
> MGLRU implementation.
> 
> Basically I agree we should keep the refs if the folios are not lazy
> promoted or protected, e.g. in inc_min_seq. But somehow we need a way
> to "soft reset" the refs to a slight lower value so the higher tier in
> lower gen won't looks hotter than lower tiers in higher gen.
> 
> This is not very doable right now, the closest thing we can archive is
> just reset the refs field and not touch the PG_workingset bit, which
> already done right now. (BTW there is a LRU_REFS_WORKIGNSET reset in
> the FG series for this :-)

Yeah. I rechecked your patchset and saw the changing, as I said
privately, the big patch better be split into smaller ones like Barry
has done in this patchset according to logic unit, then reviewing and
discussing will be much easier.


