Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0181CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D9A8E0043; Mon, 18 Aug 2025 09:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E598E000B; Mon, 18 Aug 2025 09:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D858E0043; Mon, 18 Aug 2025 09:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1B768E000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:03:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D32F1608DD
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:03:04 +0000 (UTC)
X-FDA: 83789893488.19.E6B671B
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFE3216000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:03:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSEASizQ;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755522182; a=rsa-sha256;
	cv=none;
	b=0Q6buio6Ucot0Wp9NoTEbkkiiuD1BlWN/fM1DH61jA2UqoCiWW6FsQugLOgtsrikWIilq/
	fsVNOogtHqptLpBuAQJZEeftBcjh7APFbaOnCnTyo8QClN+lsQ2MgTHGVyZC/Bw9ZWXsaO
	uBWXbKdcCRwFd7vocWtdjL2I67JANKM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cSEASizQ;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755522182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3320BK4UjE6OyHLCSJqllLZxnZ3YLJ0DY3DQ48ebuA=;
	b=qkheiugYmpcXWFBBUCnwXujSsML0Pq15rcpuNC/5CFR4nbIDDFnfeiiBJmK/Kt8Al/BOKU
	dyYGnHUolr0T5rYJpf3fhE02BiDgAc0d80yFZsJwug2WK3SCdU1N9mGFY1oVUHFM5h3XmT
	yXEryTwwTRumfoQuGoPd8oVVqqVDK28=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55ce5268cb8so3911531e87.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755522181; x=1756126981; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P3320BK4UjE6OyHLCSJqllLZxnZ3YLJ0DY3DQ48ebuA=;
        b=cSEASizQvevDieyr/h3qRL/XVrLeecc6Bz4bb9NOcFXVhReYX8Avo0pvB3uezO6bA3
         /e58Pr7HQ5epZd/HlTK3ck3ri4bXkLhgoglUTjHuK7e07Oczh4GHgHcv6vW7U25m6uPu
         ojSVbCcFSDIA0fvGeiBYUo/ac05XGlNe3x0JkzI0YGM4O9Y6OJEu3jY7NRl/iFp8q5LR
         t9vbcR/2PzLS6ex1uVPvg9JAgafmQ+ld5b1UT2PBiCAr+nnbAUZGQMDzqBrGYlYXwCgl
         oEUuqvJuP3kwkUeT5TnBeVF4yz9fJM/8Pmgp5AwLl2FdCvVnhmxPaM5P4/5N+46tI9TV
         8GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755522181; x=1756126981;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3320BK4UjE6OyHLCSJqllLZxnZ3YLJ0DY3DQ48ebuA=;
        b=Pa4dL09xEw+wrGwaaNBXlTTQNQLj8Uo2svGA+8E8yUZFWbCMJFaLEWPrj/8sNEJAfU
         FoettNMUmEPKID2C6BgIg+ST+exby1xL9UmBzBqAsfVUld73iFoxDBD1zS3nrlrhVZE2
         Yw+BtNg4EcT7G+WGbPokt0/W5dx3eP52FjOr7S+AD2ChY9TGkqKvCg+iHj9wTwHMHoLw
         T12eWvdu/6NjZBZ7kOPDzT/8Qc+h2WkqlqIiPcQLzapYocRTvt35bOjrLtt4kONQdkpN
         HlOecsAQp22FAHc2zjPtitBTka3llRDPSRMYlgqKqRqvXjYdPrs8nFraWpfmmy/9o1ZW
         KtDw==
X-Forwarded-Encrypted: i=1; AJvYcCWycpNY/s0wFIAkxtydJWFgcEak2G/M90FUfNYBsZBVNH4LmQPHI055+ZFG73o0//X1F5bJLWN1pg==@kvack.org
X-Gm-Message-State: AOJu0YxdyY66dyO03D38ORjshoPYw6YlsdCZ4Tr0DKBaQGgoYRdiHwQX
	WhIKCPbeVrZ7Liv3Vkb5S6NzkdeFgkifvX5S6KMwPxDF5CIW94JML3iC
X-Gm-Gg: ASbGncuXARiBknwWi3lrEzkDmBygknqhqechhFZWTfg3hlUxbnC/vyyL8SzlNfeKMOW
	EcubwcVNM0UEY1nxQ8DEOE7xXwGZGb46bTwtx2liGC95QTGJRM31CQmQQpSpJak2RImcLJ6mp7c
	8AqB0f8IFHELa7IkHOfMReacRNtQ4V0ICgzMyubKbtXbhQr248Wt27Avtm3WIdiTjus47WU1Cao
	ofvlqXaxL3wn9d6PPz6+P26+dZh1rtZmJKRgiZHy0qQpptjZ1I+h3o1UzwR3FS/6AWoU/KcrpNa
	AnEMiqviYdFRBOKQa/HEECh6e3tHA9zZIfD5iNlqp6bPtqlnDEkN0zDnKsXE+3Kbs1IRK9WNZ8L
	bdDc+pbh5U9A8In2eSJYCnbFIUr3eXpoKMcHdBxzYlecrotl4vA==
X-Google-Smtp-Source: AGHT+IHPt8BW77Sasv2GQ2o82GG6OIRFMes+gxViL8svV3Q8tU1FS/eEHwj1S0vl3tUszMV3QbJImw==
X-Received: by 2002:a05:6512:31d4:b0:55c:ad2a:aa7c with SMTP id 2adb3069b0e04-55ceeadaa9dmr3146938e87.22.1755522180344;
        Mon, 18 Aug 2025 06:03:00 -0700 (PDT)
Received: from pc636 (host-95-203-21-145.mobileonline.telia.com. [95.203.21.145])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef459facsm1671958e87.157.2025.08.18.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:02:59 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 18 Aug 2025 15:02:57 +0200
To: Baoquan He <bhe@redhat.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aKMkgbZqOqyGVF1C@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
 <aKKqOzepmIkOJi3i@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKKqOzepmIkOJi3i@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AFE3216000F
X-Stat-Signature: wtku9ewspxbqhpjcbtkq5xd6ta3wmfhe
X-Rspam-User: 
X-HE-Tag: 1755522182-750581
X-HE-Meta: U2FsdGVkX19T+JajKI5c2gkKQS+JVf35YMdyLV4qWWcWjECzbhbeY6zlcIG85dpXwHYB5Ux/5Dm2qpJ4XfMceQf+Z2wGvf+7wWacNy8Hfs4O7MA2kLMvoS5Z1qtb7eb3zKThKqyBG44ft+UvpfW+OhIxTkFb7eFIfhWFClOhQ3Cdp2NwFmQR0xhtyP2VuDIee8VWVBrif1sfhh9tjQ/jKleNZNdRkKl6SGp/ZQDuqvfCeVRnq35KitndmwuifiKkFdH3JWdLrSoM5Usf7ehpWcb3fuK/ExDjCAytbGeI0VizpuAt/TzaEB9+h1JZAXYpQQmweXDcvNvS8z01zmpNdT38uq6NaF5mXG1xwrbjww+YYrhJYzPu0Ti1nq65vmoYIcCbZp2NKrJDoqfgF0yB70ksNUYSgnzFhoJq+SPvn8clFyFpAbopF1/rv00oTBOzuhVBiu7nGQbf4Ag7DkWB2Q0MP/Smad71v2QN/oZW04JYAWvYmLpg3f26RJ3R1IC54Ej5zo8F0AYP0fpTg+/e4IT0VCbxxE/ZV8NWe5gbzMFHLXEvwNtUS2MCIoRf0hFagsWmsLMSdT7NtvuZLuDzuIAEg8bkf0B15EcIHJCMWTCcaNbhhEnrRVuacMVZ4zdivuZyTdQCs35v/odAJLHvQc1MtGre040nQFHrI1wnlGx/FRtbYtlzL4WIdYimeywkgjLhmh0ZdSwmjImzZBFNgB8VJTLt1FFfM7Ckfsb1KjBYRV39VMkGQnHGdkkx+fAuJsWfwyqLYYmSExXOE6vXXt6L7aF9unGCHbFWr5lzRPXmst/OA6FqcD/euhg9NfopLlBlj3MffklzL8AidzZKZkF8v6TfEceoAx+OhKIVF97jH4CbaM054angX80roz0q/RXGB00gY91wF+zbvx0ZAqWKSKp5nLiX/zUJYSyUkDzKWPQlHrYQcZHKZygaxDUskjZp8Q9xkxpIvEtJPfs
 qpBfALQe
 unafJW7flWTfXNmFccNcnoJcs1HjC8P4ILqWYADuLbUVsPmhlJGCDinGAGP6hDJ/pjQ7UAoGML0y7ZOoDoDZ0zKX7FE+77/ATolaoXvMJqK73PPitsUrMXA/E7sn0pJhh0vI+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 12:21:15PM +0800, Baoquan He wrote:
> On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> > __vmalloc_area_node() may call free_vmap_area() or vfree() on
> > error paths, both of which can sleep. This becomes problematic
> > if the function is invoked from an atomic context, such as when
> > GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> > 
> > To fix this, unify error paths and defer the cleanup of partly
> > initialized vm_struct objects to a workqueue. This ensures that
> > freeing happens in a process context and avoids invalid sleeps
> > in atomic regions.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  include/linux/vmalloc.h |  6 +++++-
> >  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
> >  2 files changed, 36 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > index fdc9aeb74a44..b1425fae8cbf 100644
> > --- a/include/linux/vmalloc.h
> > +++ b/include/linux/vmalloc.h
> > @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
> >  #endif
> >  
> >  struct vm_struct {
> > -	struct vm_struct	*next;
> > +	union {
> > +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> > +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> > +	};
> > +
> >  	void			*addr;
> >  	unsigned long		size;
> >  	unsigned long		flags;
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 7f48a54ec108..2424f80d524a 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	return nr_allocated;
> >  }
> >  
> > +static LLIST_HEAD(pending_vm_area_cleanup);
> > +static void cleanup_vm_area_work(struct work_struct *work)
> > +{
> > +	struct vm_struct *area, *tmp;
> > +	struct llist_node *head;
> > +
> > +	head = llist_del_all(&pending_vm_area_cleanup);
> > +	if (!head)
> > +		return;
> > +
> > +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> > +		if (!area->pages)
> > +			free_vm_area(area);
> > +		else
> > +			vfree(area->addr);
> > +	}
> > +}
> > +
> > +/*
> > + * Helper for __vmalloc_area_node() to defer cleanup
> > + * of partially initialized vm_struct in error paths.
> > + */
> > +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> > +static void defer_vm_area_cleanup(struct vm_struct *area)
> > +{
> > +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> > +		schedule_work(&cleanup_vm_area);
> > +}
> 
> Wondering why here we need call schudule_work() when
> pending_vm_area_cleanup was empty before adding new entry. Shouldn't
> it be as below to schedule the job? Not sure if I miss anything.
> 
> 	if (!llist_add(&area->llnode, &pending_vm_area_cleanup))
> 		schedule_work(&cleanup_vm_area);
> 
> =====
> /**
>  * llist_add - add a new entry
>  * @new:        new entry to be added
>  * @head:       the head for your lock-less list
>  *
>  * Returns true if the list was empty prior to adding this entry.
>  */
> static inline bool llist_add(struct llist_node *new, struct llist_head *head)
> {
>         return llist_add_batch(new, new, head);
> }
> =====
> 
But then you will not schedule. If the list is empty, we add one element
llist_add() returns 1, but your condition expects 0.

How it works:

If someone keeps adding to the llist and it is not empty we should not
trigger a new work, because a current work is in flight(it will cover new comers),
i.e. it has been scheduled but it has not yet completed llist_del_all() on
the head.

Once it is done, a new comer will trigger a work again only if it sees NULL,
i.e. when the list is empty.

--
Uladzislau Rezki

