Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC63FB5164
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 21:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD886B0088; Mon,  6 Apr 2026 17:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E951F6B0089; Mon,  6 Apr 2026 17:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA356B008A; Mon,  6 Apr 2026 17:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9A7A6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:37:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 510AD594E1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:37:53 +0000 (UTC)
X-FDA: 84629443626.03.8BDF039
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id DC7D81C0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:37:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=phIqbwpV;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775511471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tg4IglZkL6FTu+jdUwhTxtA0loFZT6Zl00qSd/nFL+U=;
	b=cwYBiyuq+mygjLLbu7+Wdff3HcaDVqDNqql2eK+JfvLsCOKcg6tkfCxig2bX6vI+yG5Akf
	7nB3pak0/5KMr0OYfb9A59q3q1zZyvvFeOEvzZE8d3e6j48QkavUgDeJFf5cgtXbVczghv
	cqds9jqqATEfbtYS7kR2zDJZq7uFWrI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=phIqbwpV;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775511471; a=rsa-sha256;
	cv=none;
	b=NU8/y+0h8UBog+dKTNPmxj9/1P3gXD+X5uhyeCbxqMhbfBxeCNPpkPzmFKP/pGLDM5KSus
	VL6z8K1Sg7U2MjHOERj4wq16s6jIp2u579cr0NOwspNkhfxhnqJZGJXlHwBabnatqnMbY1
	FR1Af/+nGtnzCiowUH4Apo7vUXup6NE=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d75bfb259so19703381cf.1
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 14:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775511470; x=1776116270; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tg4IglZkL6FTu+jdUwhTxtA0loFZT6Zl00qSd/nFL+U=;
        b=phIqbwpVWqLgBmQnXh84QZLYO1bi84oBk9aMXIR2H65/NrPihnj3lpm2jrqXW23Zw1
         6M6Hoe1uiUiAy4+0IypYFNz1vUHXOouN1BlDMIVxRI1qhSK+48rin8fLegO/1VVKwJ6x
         9E0OO7mg/3m3dkOFfxviBcXk51koSUYKMscgOjh9kVyLYHV1hwj9gEgbu23VrcAAcZ/q
         SH7dZENuwYzPq28QDZkgKOvoOjkRauqOb3lQeQQgMzAHy2vuTS0LbcaoC3h+eOryqDl7
         PEf9LFY68AHEKNsZEpfghjTsdbICOqXrp12lKVJGVi/h2IzBw/QCm809cu7kvm/NCUmj
         7uRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775511470; x=1776116270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tg4IglZkL6FTu+jdUwhTxtA0loFZT6Zl00qSd/nFL+U=;
        b=PkpC3hymItqtsRyK3pQ8EhHbntQrNZwDDwV2aKSfPVzi9giyXvQxllSZrFBooSpjx9
         U2iNPVMDjWw/03Q2FzyK5efLuqhuMOsmfLHu0yWTT6UQAQTpL2lRfR/xLN9XJF4PqPaM
         RKdMl/mXg7NpN9YHoP9KOHGy1BnzyWIREZz93VA8zCMlGpWs74JlqCRiHF7KkfX2g0ML
         JZns0Upa6pWPb+taR8FUY/eXS0SxdcaMj6Os8iBB3WDaPYSfalfxUhSY03vJP9eVLcHk
         vYS+NtYtKbq4AQe4avua+IVOco5TZ5uahQoCKGhb3YwL7Rmt4lgJN7WhupsXbKUST4ii
         nGMg==
X-Forwarded-Encrypted: i=1; AJvYcCWrLpcfF2bqrsS745YZBuhS04oCKWuopTyehoz5PD/SSkYIQBAqV8HB7fvMbMD+Ysrtfn8vYMHc+A==@kvack.org
X-Gm-Message-State: AOJu0YwaQ0AewADle/uZ5v+B8H7WtExnyrZ2aKHc4YwmpltuJs7D2aXu
	TQe7gNvmha3tQtA5HT+teaWHnPkdmqgwDPOPtJ7Wc51kWt9vCxQSYvLSZKpKIwKUd5M=
X-Gm-Gg: AeBDietXCPYrqZRujZz+UBZrIMw+gtEpFr6cyFLdvH0iPmuJ2G+XG4g87E8iPGJ519+
	4zsFObOs/u6DyGbtY+Id2/ORwqyWsk5Iv/PeguMRUiz9yXPabmr2dG6J0V1BQL419BQnOwJqBhf
	Xnp6Lk6F0sUoPH1TuwC7f0HDIUCeFSXk8u0acVmyfP+3cD/A4qD0y1BcAdY6ISiTFMIm3pjmNaG
	rcQXePPTzjCl9HyxGMKiRhyHroG4ChMZZfOBsfp8VmEb9xhkODkiCZqdra8dvi5zOcxWxVoI4w6
	k5kcWjw0lQuB7UsZ5FIZwtaknsY7++0kohvNSNVNiliZEON0lA/O1Z2PxqRL0ZJMsJIg+Ff8hgB
	QW30jVVxn5gaNSymr724AtWcNbqnpxZI9SsnRiqcRqB3buKdXf6hjZRJtcddi0HT6AM74oTRZys
	1c226DO9wgZZ9OFLJptMBejw==
X-Received: by 2002:ac8:75d6:0:b0:50b:3e4d:7feb with SMTP id d75a77b69052e-50d62b4facfmr151136841cf.53.1775511469616;
        Mon, 06 Apr 2026 14:37:49 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b746314sm136057621cf.16.2026.04.06.14.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 14:37:47 -0700 (PDT)
Date: Mon, 6 Apr 2026 17:37:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <adQnp7d8UJQipDSj@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-8-hannes@cmpxchg.org>
 <0cf8a859-b142-4e53-9113-94872dd68f40@lucifer.local>
 <acqndkLvpRI9bgRK@cmpxchg.org>
 <a87fdbf4-8e30-465f-b3bd-9ed3ba97c684@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87fdbf4-8e30-465f-b3bd-9ed3ba97c684@lucifer.local>
X-Rspamd-Queue-Id: DC7D81C0003
X-Stat-Signature: woughgj19pba4o3ye94syrt7f6g7ungf
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775511470-349792
X-HE-Meta: U2FsdGVkX1/bphkpY1ztbQEACcbDKIzNn0CmEqKbAUTuQ2h/G+FQYwJUuOctDxJ4H3gnSoawbStRd676q1zIByH6LdiQph/aUwOuGQALChPGvmC04UDgJtJ6ZYfu54IbT3p0xIV0UNW/1S8vGhIVeu7qrYI2Z6dqsfkx0J2EA/qvSzkYxYZ0tYraw+TT/IroxRa+eOYTjUFQTLLLhWnmrw14HDb7axiJloquwhxMQLCDm2BhuBmhe+F7D28Z8lFZavnEsQD6CI0l80H/YyhfcXDdxxA2T6LttlVwEibxRHYtaKXG6LYt7OGXHy1afo6MeGAwAZCmx1zNx4GKojxTMvissL/QrQLETscj4E95VGL9b6bTuxAbMfPJ4qEZ6pUGzuVCidvuPDRb62n1d9CJ1BgpPwaGMP78Zi8rhXGz/+1pUL6YuD5OPgZnycuGiTyf9EE8ei6X6Ju31VJuWxKqveocgfBb02oe/p/nhIO28TfwftanYEBnBwv403rozpx2ea6E7AmTqL/lOCemrzvL34nfKzRqX6UQRs8zKOf4ZUk7f9AxzBLWWDsMWB85NdZAKT/dCcIl4JZ49Yxq8obiOIxzI+MsQtDYJxYN38ShLO5GAUw2mli1gJWGgUZ0BffD1gYNhxKV25GVeQEs5AM1zUjXCyDYKtQSzItLUsk6hD0SOTLLc3FhyRf2P1CDzzUa85YioYwOGaBqL5kbsfGxww6evKs4EelyhexaDlRB6hmb2jcBhETsMmYUTnWektwbItsxsQYNTHe+PQouQtlEhqf9MKVrJmO4Vo6zDuhnymlirMHoGDY8EN61M8PUTr/lFrdEEPaxVBORKTRUroFrsoI+0AWRryN0pMV7o2TKO90i5bsyZe8QebaLljLOHNGKqyw9QsLiIo5sWkyXRtWqAIXpBffB5byR0U9LsK4xPm7eTuDM0fg6RTZM2ACbFzSbFbAC/V+SAnLHRZgmu9N
 aea44I+R
 8edB9hudDPLtNHdDElBTgf4bWVhRFY/D6X7toIRrXrGgDq9fTdyj48ow9YarpMjEEqpVBgftU2JZu985a9t/Rp23K3RjBl2qOXaDz3npe5oOhTotZoLr4NAM1WJEESf7cotGL/2Px/RWkmk76RdYuSYyddAATZOERotWIz3T8QGb57hSIztgDzD4wMaNchvBbhFzeAUNNU/MmP8h6v8Dtea+7lAMWb5DwchdWhL1IgnCMgpOj8GQjKK1LT8VvuCUoh8uBCfw7SlVkyypn7qYPJGndue/Pafaw0m1q0jl6VM2tIHW3YR0jIz9GDccZ4A8b7htITEjALZG0LQBVOo1+pyBhW5Cze+SBQp5QpfwnHMa5mzClts346S81ZHqzJ9nfHMeBzm4Xdgsd/VlaesWPO/3vS42l0+LZmS60DKqnV07uqyU0QHZI7gq7NnVtqquNchz/me6aH8mZKco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 06:33:04PM +0100, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 30, 2026 at 12:40:22PM -0400, Johannes Weiner wrote:
> > > > @@ -414,10 +414,9 @@ static inline int split_huge_page(struct page *page)
> > > >  {
> > > >  	return split_huge_page_to_list_to_order(page, NULL, 0);
> > > >  }
> > > > +
> > > > +extern struct list_lru deferred_split_lru;
> > >
> > > It might be nice for the sake of avoiding a global to instead expose this
> > > as a getter?
> > >
> > > Or actually better, since every caller outside of huge_memory.c that
> > > references this uses folio_memcg_list_lru_alloc(), do something like:
> > >
> > > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp);
> > >
> > > in mm/huge_memory.c:
> > >
> > > /**
> > >  * blah blah blah put on error blah
> > >  */
> > > int folio_memcg_alloc_deferred(struct folio *folio, gfp_t gfp)
> > > {
> > > 	int err;
> > >
> > > 	err = folio_memcg_list_lru_alloc(folio, &deferred_split_lru, gfP);
> > > 	if (err) {
> > > 		folio_put(folio);
> > > 		return err;
> > > 	}
> > >
> > > 	return 0;
> > > }
> > >
> > > And then the callers can just invoke this, and you can make
> > > deferred_split_lru static in mm/huge_memory.c?
> >
> > That sounds reasonable. Let me make this change.
> 
> Thanks!

Done. This looks much nicer. Though I kept the folio_put() in the
caller because that's who owns the reference. It would be quite
unexpected for this one to consume a ref on error.

> > > > @@ -939,6 +949,7 @@ static int __init thp_shrinker_init(void)
> > > >
> > > >  	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> > > >  	if (!huge_zero_folio_shrinker) {
> > > > +		list_lru_destroy(&deferred_split_lru);
> > > >  		shrinker_free(deferred_split_shrinker);
> > >
> > > Presumably no probably-impossible-in-reality race on somebody entering the
> > > shrinker and referencing the deferred_split_lru before the shrinker is freed?
> >
> > Ah right, I think for clarity it would indeed be better to destroy the
> > shrinker, then the queue. Let me re-order this one.
> >
> > But yes, in practice, none of the above fails. If we have trouble
> > doing a couple of small kmallocs during a subsys_initcall(), that
> > machine is unlikely to finish booting, let alone allocate enough
> > memory to enter the THP shrinker.
> 
> Yeah I thought that might be the case, but seems more logical killing shrinker
> first, thanks!

Done.

> > > > @@ -3854,34 +3761,34 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> > > >  	struct folio *end_folio = folio_next(folio);
> > > >  	struct folio *new_folio, *next;
> > > >  	int old_order = folio_order(folio);
> > > > +	struct list_lru_one *l;
> > >
> > > Nit, and maybe this is a convention, but hate single letter variable names,
> > > 'lru' or something might be nicer?
> >
> > Yeah I stuck with the list_lru internal naming, which uses `lru` for
> > the struct list_lru, and `l` for struct list_lru_one. I suppose that
> > was fine for the very domain-specific code and short functions in
> > there, but it's grating in large, general MM functions like these.
> >
> > Since `lru` is taken, any preferences? llo?
> 
> ljs? ;)
> 
> Could be list?

list is taken in some of these contexts already. I may have
overthought this. lru works fine in those callsites, and is in line
with what other sites are using (git grep list_lru_one).

> But, and I _know_ it's nitty sorry, but maybe worth expanding that comment to
> explain that e.g. 'we must take the folio look prior to the list_lru lock to
> avoid racing with deferred_split_scan() in accessing the folio reference count'
> or similar?

Good idea! Done.

> > > > +	int nid = folio_nid(folio);
> > > >  	unsigned long flags;
> > > >  	bool unqueued = false;
> > > >
> > > >  	WARN_ON_ONCE(folio_ref_count(folio));
> > > >  	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
> > > >
> > > > -	ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
> > > > -	if (!list_empty(&folio->_deferred_list)) {
> > > > -		ds_queue->split_queue_len--;
> > > > +	rcu_read_lock();
> > > > +	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
> > > > +	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
> > >
> > > Maybe worth factoring __list_lru_del() into something that explicitly
> > > references &folio->_deferred_list rather than open codingin both places?
> >
> > Hm, I wouldn't want to encode this into list_lru API, but we could do
> > a huge_memory.c-local helper?
> >
> > folio_deferred_split_del(folio, l, nid)
> 
> Well, I kind of hate how we're using the global deferred_split_lru all over the
> place, so a helper woudl be preferable but one that also could be used for
> khugepaged.c and memory.c also?

This function is used only in huge_memory.c. I managed to make the
deferred_list_lru static as well without making any changes to this ^
particular function/callsite.

Let me know, after looking at the delta diff below, if you'd still
like to see changes here.

> > > > @@ -4534,64 +4438,32 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> > > >  		}
> > > >  		folio_unlock(folio);
> > > >  next:
> > > > -		if (did_split || !folio_test_partially_mapped(folio))
> > > > -			continue;
> > > >  		/*
> > > >  		 * Only add back to the queue if folio is partially mapped.
> > > >  		 * If thp_underused returns false, or if split_folio fails
> > > >  		 * in the case it was underused, then consider it used and
> > > >  		 * don't add it back to split_queue.
> > > >  		 */
> > > > -		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
> > > > -		if (list_empty(&folio->_deferred_list)) {
> > > > -			list_add_tail(&folio->_deferred_list, &fqueue->split_queue);
> > > > -			fqueue->split_queue_len++;
> > > > +		if (!did_split && folio_test_partially_mapped(folio)) {
> > > > +			rcu_read_lock();
> > > > +			l = list_lru_lock_irqsave(&deferred_split_lru,
> > > > +						  folio_nid(folio),
> > > > +						  folio_memcg(folio),
> > > > +						  &flags);
> > > > +			__list_lru_add(&deferred_split_lru, l,
> > > > +				       &folio->_deferred_list,
> > > > +				       folio_nid(folio), folio_memcg(folio));
> > > > +			list_lru_unlock_irqrestore(l, &flags);
> > >
> > > Hmm this does make me think it'd be nice to have a list_lru_add() variant
> > > for irqsave/restore then, since it's a repeating pattern!
> >
> > Yeah, this site calls for it the most :( I tried to balance callsite
> > prettiness with the need to extend the list_lru api; it's just one
> > caller. And the possible mutations and variants with these locks is
> > seemingly endless once you open that can of worms...
> 
> True...
> 
> >
> > Case in point: this is process context and we could use
> > spin_lock_irq() here. I'm just using list_lru_lock_irqsave() because
> > that's the common variant used by the add and del paths already.
> >
> > If I went with a helper, I could do list_lru_add_irq().
> >
> > I think it would actually nicely mirror the list_lru_shrink_walk_irq()
> > a few lines up.
> 
> Yeah, I mean I'm pretty sure this repeats quite a few times so is worthy of a
> helper.

It's only one callsite, actually. But I added the helper. It's churny
on the list_lru side, but that callsite does look much better.

Anyway, I hope I got everything. Can you take a look? Will obviously
fold this into the respective patches, but just double checking
whether these things are what you had in mind.

---

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8d801ed378db..b473605b4d7d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -415,7 +415,8 @@ static inline int split_huge_page(struct page *page)
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 
-extern struct list_lru deferred_split_lru;
+int folio_memcg_alloc_deferred(struct folio *folio);
+
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index 4bd29b61c59a..733a262b91e5 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -83,6 +83,21 @@ int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 
 #ifdef CONFIG_MEMCG
+/**
+ * folio_memcg_list_lru_alloc - allocate list_lru heads for shrinkable folio
+ * @folio: the newly allocated & charged folio
+ * @lru: the list_lru this might be queued on
+ * @gfp: gfp mask
+ *
+ * Allocate list_lru heads (per-memcg, per-node) needed to queue this
+ * particular folio down the line.
+ *
+ * This does memcg_list_lru_alloc(), but on the memcg that @folio is
+ * associated with. Handles folio_memcg() access rules in the fast
+ * path (list_lru heads allocated) and the allocation slowpath.
+ *
+ * Returns 0 on success, a negative error value otherwise.
+ */
 int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
 			       gfp_t gfp);
 #else
@@ -118,6 +133,10 @@ struct list_lru_one *list_lru_lock(struct list_lru *lru, int nid,
  */
 void list_lru_unlock(struct list_lru_one *l);
 
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+		struct mem_cgroup *memcg);
+void list_lru_unlock_irq(struct list_lru_one *l);
+
 struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 		struct mem_cgroup *memcg, unsigned long *irq_flags);
 void list_lru_unlock_irqrestore(struct list_lru_one *l,
@@ -161,6 +180,9 @@ bool __list_lru_del(struct list_lru *lru, struct list_lru_one *l,
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg);
 
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item, int nid,
+		      struct mem_cgroup *memcg);
+
 /**
  * list_lru_add_obj: add an element to the lru list's tail
  * @lru: the lru pointer
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c8c6c4602cc7..a0cce6a56620 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -69,7 +69,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
 	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 
 static struct lock_class_key deferred_split_key;
-struct list_lru deferred_split_lru;
+static struct list_lru deferred_split_lru;
 static struct shrinker *deferred_split_shrinker;
 static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
@@ -913,6 +913,11 @@ static inline void hugepage_exit_sysfs(struct kobject *hugepage_kobj)
 }
 #endif /* CONFIG_SYSFS */
 
+int folio_memcg_alloc_deferred(struct folio *folio)
+{
+	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
+}
+
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
@@ -949,8 +954,8 @@ static int __init thp_shrinker_init(void)
 
 	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
 	if (!huge_zero_folio_shrinker) {
-		list_lru_destroy(&deferred_split_lru);
 		shrinker_free(deferred_split_shrinker);
+		list_lru_destroy(&deferred_split_lru);
 		return -ENOMEM;
 	}
 
@@ -964,8 +969,8 @@ static int __init thp_shrinker_init(void)
 static void __init thp_shrinker_exit(void)
 {
 	shrinker_free(huge_zero_folio_shrinker);
-	list_lru_destroy(&deferred_split_lru);
 	shrinker_free(deferred_split_shrinker);
+	list_lru_destroy(&deferred_split_lru);
 }
 
 static int __init hugepage_init(void)
@@ -1246,7 +1251,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		return NULL;
 	}
 
-	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
+	if (folio_memcg_alloc_deferred(folio)) {
 		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
@@ -3761,31 +3766,37 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
-	struct list_lru_one *l;
+	struct list_lru_one *lru;
 	bool dequeue_deferred;
 	int ret = 0;
 
 	VM_WARN_ON_ONCE(!mapping && end);
-	/* Prevent deferred_split_scan() touching ->_refcount */
+	/*
+	 * If this folio can be on the deferred split queue, lock out
+	 * the shrinker before freezing the ref. If the shrinker sees
+	 * a 0-ref folio, it assumes it beat folio_put() to the list
+	 * lock and must clean up the LRU state - the same dequeue we
+	 * will do below as part of the split.
+	 */
 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
 	if (dequeue_deferred) {
 		rcu_read_lock();
-		l = list_lru_lock(&deferred_split_lru,
-				  folio_nid(folio), folio_memcg(folio));
+		lru = list_lru_lock(&deferred_split_lru,
+				    folio_nid(folio), folio_memcg(folio));
 	}
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 
 		if (dequeue_deferred) {
-			__list_lru_del(&deferred_split_lru, l,
+			__list_lru_del(&deferred_split_lru, lru,
 				       &folio->_deferred_list, folio_nid(folio));
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(old_order,
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
-			list_lru_unlock(l);
+			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
 
@@ -3890,7 +3901,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			swap_cluster_unlock(ci);
 	} else {
 		if (dequeue_deferred) {
-			list_lru_unlock(l);
+			list_lru_unlock(lru);
 			rcu_read_unlock();
 		}
 		return -EAGAIN;
@@ -4268,7 +4279,7 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
  */
 bool __folio_unqueue_deferred_split(struct folio *folio)
 {
-	struct list_lru_one *l;
+	struct list_lru_one *lru;
 	int nid = folio_nid(folio);
 	unsigned long flags;
 	bool unqueued = false;
@@ -4277,8 +4288,8 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	rcu_read_lock();
-	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
-	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
+	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
+	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
 			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
@@ -4286,7 +4297,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		}
 		unqueued = true;
 	}
-	list_lru_unlock_irqrestore(l, &flags);
+	list_lru_unlock_irqrestore(lru, &flags);
 	rcu_read_unlock();
 
 	return unqueued;	/* useful for debug warnings */
@@ -4295,7 +4306,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
-	struct list_lru_one *l;
+	struct list_lru_one *lru;
 	int nid;
 	struct mem_cgroup *memcg;
 	unsigned long flags;
@@ -4324,7 +4335,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
+	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
 			folio_set_partially_mapped(folio);
@@ -4337,8 +4348,8 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		/* partially mapped folios cannot become non-partially mapped */
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
-	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
-	list_lru_unlock_irqrestore(l, &flags);
+	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
+	list_lru_unlock_irqrestore(lru, &flags);
 	rcu_read_unlock();
 }
 
@@ -4411,8 +4422,6 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
 		bool did_split = false;
 		bool underused = false;
-		struct list_lru_one *l;
-		unsigned long flags;
 
 		list_del_init(&folio->_deferred_list);
 
@@ -4446,14 +4455,10 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		 */
 		if (!did_split && folio_test_partially_mapped(folio)) {
 			rcu_read_lock();
-			l = list_lru_lock_irqsave(&deferred_split_lru,
-						  folio_nid(folio),
-						  folio_memcg(folio),
-						  &flags);
-			__list_lru_add(&deferred_split_lru, l,
-				       &folio->_deferred_list,
-				       folio_nid(folio), folio_memcg(folio));
-			list_lru_unlock_irqrestore(l, &flags);
+			list_lru_add_irq(&deferred_split_lru,
+					 &folio->_deferred_list,
+					 folio_nid(folio),
+					 folio_memcg(folio));
 			rcu_read_unlock();
 		}
 		folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a81470f529e3..44a9b1350dbd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1121,7 +1121,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
-	if (folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL))
+	if (folio_memcg_alloc_deferred(folio))
 		goto out_nolock;
 
 	mmap_read_lock(mm);
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1ccdd45b1d14..23bf7c243083 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -160,6 +160,18 @@ void list_lru_unlock(struct list_lru_one *l)
 	unlock_list_lru(l, /*irq_off=*/false, /*irq_flags=*/NULL);
 }
 
+struct list_lru_one *list_lru_lock_irq(struct list_lru *lru, int nid,
+				       struct mem_cgroup *memcg)
+{
+	return lock_list_lru_of_memcg(lru, nid, memcg, /*irq=*/true,
+				      /*irq_flags=*/NULL, /*skip_empty=*/false);
+}
+
+void list_lru_unlock_irq(struct list_lru_one *l)
+{
+	unlock_list_lru(l, /*irq_off=*/true, /*irq_flags=*/NULL);
+}
+
 struct list_lru_one *list_lru_lock_irqsave(struct list_lru *lru, int nid,
 					   struct mem_cgroup *memcg,
 					   unsigned long *flags)
@@ -213,6 +225,18 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	return ret;
 }
 
+bool list_lru_add_irq(struct list_lru *lru, struct list_head *item,
+		      int nid, struct mem_cgroup *memcg)
+{
+	struct list_lru_one *l;
+	bool ret;
+
+	l = list_lru_lock_irq(lru, nid, memcg);
+	ret = __list_lru_add(lru, l, item, nid, memcg);
+	list_lru_unlock_irq(l);
+	return ret;
+}
+
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
 	bool ret;
diff --git a/mm/memory.c b/mm/memory.c
index 24dd531125b4..23da4720576d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4658,8 +4658,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 			folio_put(folio);
 			goto next;
 		}
-		if (order > 1 &&
-		    folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
+		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
 			folio_put(folio);
 			goto fallback;
 		}
@@ -5183,8 +5182,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			folio_put(folio);
 			goto next;
 		}
-		if (order > 1 &&
-		    folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL)) {
+		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
 			folio_put(folio);
 			goto fallback;
 		}

