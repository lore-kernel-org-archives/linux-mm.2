Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD61EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DD96B0096; Mon,  7 Sep 2026 21:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34796B0098; Mon,  7 Sep 2026 21:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23816B0099; Mon,  7 Sep 2026 21:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3C56B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:23:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E9AA1C1DD6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:23:30 +0000 (UTC)
X-FDA: 85188847380.05.8F372FD
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F6B6C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:23:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LypCcB5i;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=os1bxGgQvoOLa9ryjCYK+ThrfW/L4s5kmkzao71FISs=;
	b=EpfXsDb57qVLG0p6bmuOHJnwsoG4to8+4Lp183XPabcrb9M+rUaSajpCCh8U5zQwfFfZ4d
	d2LhjhvaPJ6nZJG7weif5c+7rHW4j2VY6BNE0zYAPCIM7B3txQsj/BBl7qCMUuV8LK6o3K
	dDby1ywzZ6XQkVY2E1YdU5NBMvoMqho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LypCcB5i;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830608;
	b=khLs2HXRWPs7sxwggO1zkkWzZe3J4VOwqIlBKDXIqP2emiLJ6Y/mC0iRJjrr4CG/lZTucl
	EtvDiA6wRTnz/zHF0JGB87Xxlej46wxQGoh1IOIQnHqwais/a3TCn4LNW7j3zUS5sLb42Y
	Yn0FfeYxhwCjNopNuIpc0PRm57LSJSQ=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-467a6834028so2360410fac.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 18:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788830607; x=1789435407; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=os1bxGgQvoOLa9ryjCYK+ThrfW/L4s5kmkzao71FISs=;
        b=LypCcB5iPcucSKxmdpmHVpmX0D67Wh5BsdoDna53zpD/E4Q8t/5ZncaLFyZKiDRJ6v
         cgEZi/OH0rqaLh/0WYSciT5wSTJx+7UOw2ul0wAiNkIEipHo8esPRaceUc83QDWH6DaN
         oA/7I5k1kDvleyQzoz7ymJpqNh/wGCLR2X9fD/PgU8VKUYMoa+cntyEFFJgib1+SsrAO
         FBm0tGy5MHGaTkMOyBUrD5MizW0s0Ew7GGS4D5vNqPhXLYvfOpV6eiSEjVRVa8ZN7b8m
         LEfdNWN1UbWyqyYwYfW88fPN/N7dm0NDH83r0jaa2r2GjtM+if8cddOMp8nJ48f7uGYv
         quIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830607; x=1789435407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=os1bxGgQvoOLa9ryjCYK+ThrfW/L4s5kmkzao71FISs=;
        b=jZ4wD9S5bU7mdF0Pb7DDDBpUV1XHNn9PKj9v+BQwPr3T40gY+1wx4CDjvXxud+Nn/X
         4RaJ6FPSUV0Pr1+/wH1MvbMpzGcYLwJ/Ht+8tljcSzV3u7oB2EbsOAxjsI/zTrjhVxc7
         2GBpmCgkg1WThayRFr8jFNKMRY/6r5h2G8zhw5HQCe9sdycjxbAvRbk9VbsjZInwiRI1
         Dz/iqqViQgqRcahu1f/YGfh/AXEvg2uuferzbjP9VWKWZ9PUnNSrmBpKXeK4dRWsAnf+
         G2WcgmOT5e9KxKehCam7zPfMyTeON8RogGzt83JTlT6YlEFO8SverA47HseFXlWPEkti
         RiWg==
X-Forwarded-Encrypted: i=1; AKwUvBw2EB1XwcojGjI/qMHHrcI3Q2SzDDeUTgvVF8Wavyue97sVikPie4EBgtDhYe6JAGcDNDb7+WplXg==@kvack.org
X-Gm-Message-State: AFuF++nZLJ0XGsSGtDiJDgl/lPCe3FjdsPP+MxwDO4arkKWAXusTLudo
	bKPWoVAyJLI2CeHI5NclgfEJhXrcCW1zwSuYimqHjKyqns2/VM7tXcLC
X-Gm-Gg: AYBFou3WErBZBcU+f9XEAMu8OV8pKLcQfzA+LmqgUoi3zEdEPnukajiXpF8kf+ViGSo
	gaIuOzI97JeCVCVA7BEM5mqkePpggtLUowIoo5r7b/rzOkcUAoKeRgYplJCya3cKq3FtcVNkm0X
	GdyzgXW7LaqK2tEgS5vgqnnTLeIs0wJ+bUvyKg0Dsgjh+qrMvbD4FcN5L5ywbPkpXPP/H3lRiLk
	ZtUV5Lw+tmtYgQnGkoQhbrkPEYLV3FMwRJOYWamxN9Jh8S5T5hINVv+fcLzSXQH8ToSm7A8kRuv
	gNLcfwkS5P5fkr9rjqwVaDkKYodb35ura+3rMA5OTzlqjE/l0f8TVH0sOAfyidLJPsPI+LnJGW/
	WCO8en3aPSrR/y90ohqCWRjcfd22Udq7ucRUZwEXZScz/XdiLYtvorEu4ftjCT2hU/CNVw5D053
	7syHNvIldM/jcGZGz0h99vdsVFi2QdBRNzlrOlDZSY50cbOPXpG5C1IO7ohc1imvcreAn1pQpwt
	NeFDwYMYqkOP9Lp0PI=
X-Received: by 2002:a05:6871:c301:b0:457:494b:1548 with SMTP id 586e51a60fabf-475516ed3a3mr34561336fac.5.1788830607148;
        Mon, 07 Sep 2026 18:23:27 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-475543f5ac5sm12322726fac.8.2026.09.07.18.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:23:26 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 4/7] mm/page_counter: use stock in page_counter_try_charge
Date: Mon,  7 Sep 2026 18:23:24 -0700
Message-ID: <20260908012325.1770706-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ap86vDv143VHvrzh@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: inaxkui9fm7qyoaoxuzc8tofsn6d59wc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F6B6C0003
X-Rspam-User: 
X-HE-Tag: 1788830608-182751
X-HE-Meta: U2FsdGVkX1/eVaebl2FjPGuTOt5F8RUqZi2uUp/UpZvKSdcywF9BAPvqN0dhClKJu/R6B1jqRBGcFAqr3odOqihnGnRYYaDvq3PdfDzRGUNyDVQiOSHEqBRRjAT8coYknaqmY2ZceVzC8hw2gS07qNQliwogNy1oyg4SQQbp8MJa0yDGN3nIyT/kLmj0EnuNhjNhDtB/w52ActFsCUio1bVGoBC+2y9vB+AlIFyS5WP/aXvOBQqnvD54ncab6aXOrJaeVs+VELSRe50El3rSd8Kbmll7uUjkuD5WTtzL0WmvNXd19ld6FbPjEYhz8fsuD3tdlsZyQPd4ctGARqm8uoII1fgSV6g4VAO8J1AcucP986Gh9e/mmoYL+x0/RTLB4aT6UIdID2ukEOIXNpKJc1cN0eXjNk1Qq/hh2zXuO5E4fRnvgN7dLNmTkTevVnxDQbz5oR8yEqhFja2+IbxKpd/zbTwHSzEpPG2OQlbzWJ1mIQv0RLuVFq793ULiAOaB/DmjWQZ/L/8v2jkY9XZy8Xy8IvDOCoQnQhYBinUzC/Ks5oF3JtINljinlfwxW1O0GpzZPdBlUjMlol2I7M/IgFAO998/Xtm0EKV9VWaucWwWMUXl4tUDoJCd2odH8CUuqqZuRHRQlxsRcsh+n0ocFeP2mfQjmzjSEwnIDIILxj/dtynA58dpKXrrYhnbtoqs/969qyicT+i/uhr2tnCafOD+7BLHzonQ0tRV0PbfQ1sIK7oCCZBZ4cDtA12sI65qs+SNAUaV30AhiLHGOBs4ScRjxtd/xA1pu1igflhf3wxY6ZlebZvBfyVTwy9GVOrxErEsciuecvKjHf+Ph9hgEyt8JW9DXRge7ZFWtxPilLku7DHVkiEiwcoW49bYSVjDOjeDq7/QCRBipeyecuOQVEf3Q9NfwDwdBLZgvW+bQs+RcTJaScgZCio3VWLCG5bGD3fwrm/JN5hiUuvCf/L
 TfbKgocn
 P+rdumr6SQ+sqERPSDrlbLRABmrIn21sMmELMl7TvywoUUM+5WRsaDrT5+ZNgbQ8Wiy8/Da8/joRPBrpVB1RtSij3JbVqB3znJj3dyYsBx9KV64Q3PjeJDqvJ1ZOj9XMK07qZxbQ/3wHg0+0zPOZxbcZOZ66IJ+msht1lSLXh3/A4YLEnBrJWnSquKkYXy9WGP2MAGO6/oc2t2m9ZYCakZRiKOVLhikPH3nnvFgqA/bMf9icV5JqVSC/ix0ZP+5xDgbBqiEDKb3oTCuS7G0Lp7fruQQuZ63LX4g2Nyj90MRNoKyMV76o2BFpRjiUYFYobbmA7WI/nF1wPtmBInUFoL/C7+QM4NHu9wbQPPS2KO4tDaa5/CSw5dysa3AtWYQ0/AjB6NUxfLU0EJF4rZMvGUcVwUmdsqQcwOC8Qp5hU7EAnV1a2LzlFRxn9NaFN2YSKEcR3hBpfpYwNW8JQqyg9/nbBKXwtaN2eDK4qlAKXD9yDuVu4d5Y4jsSdafcpJwagmi9ojmKda8KVqd162L9Q/VaH4y+Lh30Vd5UCv+PEfhRWcKiuF3STg5aqhXC47yM6Q6yDBcNUcmMLoX0ZTkS6Da+8/APXqAeRBZrUJ8fVLOEdhJ4OX/DWjmsHt6D0w3Ey03zmrokvIL9J+wtAr604XZIF+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 7 Sep 2026 16:21:33 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Mon, Aug 31, 2026 at 09:37:48AM -0700, Joshua Hahn wrote:
> > Transparently make page_counter_try_charge attempt to service the charge
> > from its stock. We preserve the same semantics as the existing stock
> > management in try_charge_memcg:
> > 
> > 1. Limit-check against the stock. If there is enough, then skip the
> >    hierarchy walk and charge to the stock.
> > 2. Greedily attempt to fulfill the charge request and refill the stock
> >    simultaneously to the hierarchy.
> > 3. If this fails, retry the stock and charge without trying to refill
> >    the stock, i.e. with the number of pages requested.
> > 4. If the greedy attempt succeeds, return excess pages to the stock.
> > 
> > page_counter_refill_stock() falls back to a hierarchical uncharge when
> > there is no stock, in NMI contexts, on lock contention, or for a refill
> > larger than the batch.
> > 
> > The greedy charge is also skipped in NMI where both stock helpers bail
> > out since the batch charge would be undone again.
> > 
> > No functional change intended, since no page_counter enables stock yet
> > and counter->batch is left at 0.
> > 
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  include/linux/page_counter.h |   2 +
> >  mm/page_counter.c            | 135 +++++++++++++++++++++++++++++++----
> >  2 files changed, 125 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> > index c1fe331f34e7e..428ca8e7b2da5 100644
> > --- a/include/linux/page_counter.h
> > +++ b/include/linux/page_counter.h
> > @@ -82,6 +82,8 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
> >  
> >  void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
> >  void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
> > +unsigned long page_counter_refill_stock(struct page_counter *counter,
> > +					unsigned long overage);
> >  bool page_counter_try_charge(struct page_counter *counter,
> >  			     unsigned long nr_pages, struct page_counter **fail,
> >  			     unsigned long *nr_charged);
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index 3f61eba695518..a76949abf04e7 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -113,25 +113,126 @@ void page_counter_charge(struct page_counter *counter, unsigned long nr_pages)
> >  	}
> >  }
> >  
> > +static bool page_counter_consume_stock(struct page_counter *counter,
> > +				       unsigned long nr_pages)
> > +{
> > +	struct page_counter_stock __percpu *stock = READ_ONCE(counter->stock);
> > +	struct page_counter_stock *pcp_stock;
> > +	unsigned long flags;
> > +	bool charged = false;
> > +
> > +	if (!stock || nr_pages > counter->batch)
> > +		return false;
> > +
> > +	/* raw_spin_trylock isn't enough to protect against nested NMI in UP */
> 
> I don't understand what this comment is trying to say. The nested NMI is
> confusing.

Hi Shakeel, thanks for your review on the series!

Yes, I'm sorry about that. There were a few layers of protection that
I wanted to make against nested NMI, ordering, publishing for stock, 
etc. I think I didn't make it clear what was happening, so I'll
address that in the next version.

> > +	if (in_nmi())
> > +		return false;
> 
> You are completely disabling stocks for memcg charges in nmi context. Why? I
> assume that is what the comment above trying to explain but it is failing.
> 
> IIUC you want to use spin_lock instead of local_trylock because you want to
> support draining from remote cpus and spin_lock on UP are simply disable irq and
> does not protect from NMI. Maybe you need spin_trylock similar to local_trylock.
> Not saying you to implement that but please explain stuff clearly.

Yes, that's exactly what it is. I think there was a lot of thinking
on my end on things to look out for that in the end it just kind of
became a jumbled mess, I'll definitely do a re-spin of what's happening
in the next version.

> > +
> > +	/* It's OK to migrate here, since stock is fungible within a counter. */
> > +	pcp_stock = raw_cpu_ptr(stock);
> 
> migrate between cpus? Why? What are you gaining by allowing that?

All I was trying to say here is that we don't need to drain an exact
CPU, all we need to do is to try and get any CPU. So if we migrate
and get a different CPU's ptr than we initially started with, it's no
big deal (that's what I tried to explain with saying that stock is
fungible). But I agree it's a little lacking in explanation here,
I'll rework it in the next version.

> > +	if (!raw_spin_trylock_irqsave(&pcp_stock->lock, flags))
> 
> Why do you need to disable irqs?
> 
> Anyways, you are changing the fast path of the charge drastically. Previously
> there was no atomic ops and not irq toggling but this patch is adding atomic op
> and irq toggle (not sure about why irq toggle is needed) on the fast path.
> 
> I understand that remote draining is the only reason you need to use spin locks
> here otherwise you will need to allocate work_struct in page_counter_stock. You
> are making these design decisions very silently and implicitly.

I agree, sorry for that : -(

> How about we decouple the decision of remote drain / spin lock from moving stock
> inside page counter? First move the stock to page counter without any spin lock
> or remote drain and later in the series you convert to spin lock plus remote
> draining with performance numbers.

That sounds like a good plan to me. I'll do exactly that and send a
new version.

Thank you for your time Shakeel, I hope you have a great rest of your
day! : -)
Joshua

