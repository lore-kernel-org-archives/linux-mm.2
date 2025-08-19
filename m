Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE99CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6CC8E0025; Tue, 19 Aug 2025 05:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697DA8E0002; Tue, 19 Aug 2025 05:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD6E8E0025; Tue, 19 Aug 2025 05:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 472818E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:20:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EED4A1A02B0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:20:50 +0000 (UTC)
X-FDA: 83792962260.04.F0A4647
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id E50F11C0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:20:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OLrs9gUc;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755595249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEkCJ0gLjfLsaSogQOFyJQAfkvjUuZ4XqQ+SkU//zU0=;
	b=sRiDSQPLDa+cJ7w+zpAcKMBFq42HfCNc1GRiiHFyTKXtMEs7hTG11SGpUbaQj6F1AW32D1
	ofxyLv3v2RWz1k+AGGXpQw6iWKKhIaTZdKBPord5Bt38lr9qkzBVe2O59mujrezwxyotsX
	dfZsjJFhrbelT+15+sRWrMaQEtIoHSg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OLrs9gUc;
	spf=pass (imf18.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755595249; a=rsa-sha256;
	cv=none;
	b=oGK+Vg4f8yXXQrZ9ga0kYKH8a63ROkhYIaqt5Fs6X4PBV/epEDHsFyPoHbYEve4UaFg2hU
	AmhKMTyfq9cTAeJ6PT32ml5RW/cxtN200xprWAo7z1ezlPK4O85ajSrYbXFG4hv8/G8LLU
	PwQZG0/VcqcxYM2SiampdO1/g1cZKDw=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55ce526627dso5148369e87.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755595247; x=1756200047; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VEkCJ0gLjfLsaSogQOFyJQAfkvjUuZ4XqQ+SkU//zU0=;
        b=OLrs9gUcr1nM43BDJ4LJLtUfbnjh9rGKyBE4pkcy36SF5xELfE/0YGU2J7hB6+rCR6
         keWNS50qhKNIqzSYUIaIiTow3M99ABCCvFYpjDhMHuIHRsmcvBUiFK4X/9pADMezkBq7
         FWgevZeNurBUtRbrMv973shuozweERqkD5+ofokzFkjbeOakegufbpz2WhUss59u+bwO
         SbTFgg7RU97Uavf9B2WwkhRzJT6lrs5FkOL4H4gRBkRKA1mYX+2aaMasv9OpoZ6yvMHk
         pkcYfcA6X6SwWD+wruPofu40vZBeIxQ+dGtbQwoHVkHthFi6qoLPclKJ2BxM5k+jhBew
         0thA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755595247; x=1756200047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEkCJ0gLjfLsaSogQOFyJQAfkvjUuZ4XqQ+SkU//zU0=;
        b=Iq8TCQVHBXX7dYDmeYUd1K6L0nw8Ohi+2jPjkBBERNe2pvK4Rhs9TKwU+0x3b54cEK
         mDoSVVy3bT0tG0688tBx0I1V2xRxpjydEoLIUGrKE9/kFdaFeRIqdcyQ6rVLiSwcSfa8
         ZUWwh9AJIck4NVprQvekcOdfBMHaQxm6zUM1pIE50Cfbw8SmKhgU2Eqr3gEKYRRfgj9t
         6GvfMGDxZQnea5LPmh7kZaVac+oiNZwEwnEPcvBHxSbpevRAolSeWdltb4H+kFM+AGIa
         hxROuP2PyW79+AvDWeA0ySvnlugnoK1P041mAmYWvR9GSZdSLSD2bRCKhR79yfOdrkcS
         TK2g==
X-Forwarded-Encrypted: i=1; AJvYcCXwVx29nNKXFvw+hd9PBhAS7G7acgm1F9pn90dRtdufxtp8URKzH2oB4NtOAGtORMFzYoGwdExivA==@kvack.org
X-Gm-Message-State: AOJu0YyoJqXwC86Lh+tjOpPcdcMzz60xYIJXemBuYrW3WX9inTscND+A
	5n8st6WGA7cpzbQVfi7tMQaaWF708QK5Y7lZjOkODU9347MCq8eYd1bO
X-Gm-Gg: ASbGncvpSaOSmfh8Aig4fDZd4F+DaDmTdx0UVAwB7nofsiWgghl47XQfoOYhmTt+kKX
	Fb4uOz8sZ1D3XXsQbdG35V722trs/f3NmPJXp3UhYPKxY/7jk9enwCoYLA/X15HWj7iKJVzNFJ+
	y0pu4vpyQPvVcQRwY9Uv3Aa6VqF+N6S6jiw/AzGUXG2kSpcBa0nbVbH5pohu8pyBN6OT2HpPF1H
	iLKPJkJJeRZ+qQB/A4mGqtgbq0tbcB0fCOBexhg8NSdKm/c86cz1Elb31Tf9NPpQBwqac88SXT5
	4kSl4gixvt4IfuanrpP03xUv2vQSmkxKzYmiAFGugXQ9mhS2lvBg/lt7HPa1Udnj/uD5VSw44b0
	LSi2vUhnSO+LncLu/UwAoG/gpPPgBb8Chh76xnK23It4ojiwGsQ==
X-Google-Smtp-Source: AGHT+IGDpm17FTp2jgQoAPGgKW0MpOUHKhiVhhQj6NkOKyY/3ejMthbZqvf940McsZft3+q3S9XyMw==
X-Received: by 2002:a05:6512:3b20:b0:553:2311:e1f6 with SMTP id 2adb3069b0e04-55e00864624mr518355e87.49.1755595246570;
        Tue, 19 Aug 2025 02:20:46 -0700 (PDT)
Received: from pc636 (host-95-203-27-238.mobileonline.telia.com. [95.203.27.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef3516dfsm2030389e87.8.2025.08.19.02.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 02:20:45 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 19 Aug 2025 11:20:43 +0200
To: Baoquan He <bhe@redhat.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aKRB6xmFHYp8pnYs@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
 <aKKqOzepmIkOJi3i@MiWiFi-R3L-srv>
 <aKMkgbZqOqyGVF1C@pc636>
 <aKQ8OY04a0ACqZ2O@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKQ8OY04a0ACqZ2O@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E50F11C0003
X-Stat-Signature: po9x9t4dobf5pwai5nch7y3i3jwy7zyd
X-Rspam-User: 
X-HE-Tag: 1755595248-435652
X-HE-Meta: U2FsdGVkX18aQsfEUmvkNgqq6HklRheDd8PNmUkiUaTQoukq8v8vx2dxHSOOp/GhqjCIgetgW3qXpmZzBDmjqBFM41rf/pTXTFwRJ0paI4LnVsajWHW/ywlR7E0a8QCr9MTxbWtS7mpdWB0njRUkwGK2+RKkrRYYjF8614PL7tZfIP9S9J4Z7Sw3hdmrNy1IsSW4BLje8aaXShkIDQKrKPvuHjNLziQPFIAquNDL0LGM4Oy7R9sX7XwMtkq7cSPfN+AdGivCNEnms8/ETVIfJTMpHnGo2Wt752q8v5Gkg6aoO02qroChLJ1zRvlGrlEKEifr33AntFM/aA0jknsKapKm6bMRZhYwEE8JYtelPuhkLN7jGAGQUHZ9k3c83os+MGntCVMNqsluii31yRLLSZe1KCYZ/wGeuefYrBvgmpfO5IxQZ0S4E2j1PpYE7NLWw7RD80HPW/+xobwImAWdh5A9qtNoP0tfcxJiSRcjnHCT7Gc1sbTBt/s8Otd/7Sq6qpMo+qUh6WgXUZuziXAFsA/a+U6d3WHi2g92h47fK3IdwuDzr8zOHCH0Uv607W0SnB6Edyyfxgg3tqmCEUuvZinKH6ACHI9wyd2oCm5pJz9tf+iqw8C5uAfuauxAMRZDwGaDsaNYYB6IgxqgxaOtjbSRoD3AuRX/NJUjmCuijT+SyonfOcI8+3/1fiVvn/XTQUg9RIT1Qnt0HGzZaU/yRi1IFSbLF+d0uO7y4Mjqf0MFItsKLUmX3wkhNLsnyLKk/xNYojgT4LfSsftU1pFPUc1aOxgd/kynMmRCW+Pd40ruItUYovkpJ7h83bkk1bqxHDIhv+etVuDcyUrNP2/lSnSgVW2/zEXOYxD4zC1/Nf/vAXe2AG6MClK66BUCdBzlW4MgZ+NEoWTDgKAjdURTYRC/c7QEf9tV+8BIAarV95/ZjCqo9ms+8ZSLYImFp+48U4f8nRCJzSQ6W85pRMI
 jRaABOpJ
 MQwiexZJGz2FPa47qtLZH6CibNI2WGEOG1F6w3YW6HwnDj1IziQ+C/MFrDOVKdxS+3t46ZFkxabXrgT4qEfJtaLFAqV6xou28ZK7Fw26L4huUCLRSzCbPoIQSRQeiOggHjrMxD17kK9UhWG/gFyUXdyOuC1acIs7YwukaHG6Eb2O2n3+uOzSdJ0Oau3a54eGh+Mtkl18XgzfxFEZHAhollvpn5GbAJMBRNGAV7CeownspuSrv+trx3pOlTa5tB2zaUNTBexImUvzoYUlkF26+HS4tF/n400qi0rNSDolWUBVqUOqId7E1agYbJuyNyj/wr/KnJ+qw0JaSCQgCDny0sud218aTDBzeBsjcpALYwymLg/Ec3ZSqLClbXlFsHyaDKExgFKi16q36HXDGiWc5a4znk3Rs3c58rpTiFEAdt6cncQDTPLee4paCefwhs3JvycSTFhzQTAEC7jCIiwtteWRay7g/5cftm1pT1c8W0YpwubKQHAm0F+ODVG9BcUDb5M8Lo8cAr52oejGbnEES2ymz3TfPidKDU5zi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 04:56:25PM +0800, Baoquan He wrote:
> On 08/18/25 at 03:02pm, Uladzislau Rezki wrote:
> > On Mon, Aug 18, 2025 at 12:21:15PM +0800, Baoquan He wrote:
> > > On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> > > > __vmalloc_area_node() may call free_vmap_area() or vfree() on
> > > > error paths, both of which can sleep. This becomes problematic
> > > > if the function is invoked from an atomic context, such as when
> > > > GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> > > > 
> > > > To fix this, unify error paths and defer the cleanup of partly
> > > > initialized vm_struct objects to a workqueue. This ensures that
> > > > freeing happens in a process context and avoids invalid sleeps
> > > > in atomic regions.
> > > > 
> > > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > > ---
> > > >  include/linux/vmalloc.h |  6 +++++-
> > > >  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
> > > >  2 files changed, 36 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > > > index fdc9aeb74a44..b1425fae8cbf 100644
> > > > --- a/include/linux/vmalloc.h
> > > > +++ b/include/linux/vmalloc.h
> > > > @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
> > > >  #endif
> > > >  
> > > >  struct vm_struct {
> > > > -	struct vm_struct	*next;
> > > > +	union {
> > > > +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> > > > +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> > > > +	};
> > > > +
> > > >  	void			*addr;
> > > >  	unsigned long		size;
> > > >  	unsigned long		flags;
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index 7f48a54ec108..2424f80d524a 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > > >  	return nr_allocated;
> > > >  }
> > > >  
> > > > +static LLIST_HEAD(pending_vm_area_cleanup);
> > > > +static void cleanup_vm_area_work(struct work_struct *work)
> > > > +{
> > > > +	struct vm_struct *area, *tmp;
> > > > +	struct llist_node *head;
> > > > +
> > > > +	head = llist_del_all(&pending_vm_area_cleanup);
> > > > +	if (!head)
> > > > +		return;
> > > > +
> > > > +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> > > > +		if (!area->pages)
> > > > +			free_vm_area(area);
> > > > +		else
> > > > +			vfree(area->addr);
> > > > +	}
> > > > +}
> > > > +
> > > > +/*
> > > > + * Helper for __vmalloc_area_node() to defer cleanup
> > > > + * of partially initialized vm_struct in error paths.
> > > > + */
> > > > +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> > > > +static void defer_vm_area_cleanup(struct vm_struct *area)
> > > > +{
> > > > +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> > > > +		schedule_work(&cleanup_vm_area);
> > > > +}
> > > 
> > > Wondering why here we need call schudule_work() when
> > > pending_vm_area_cleanup was empty before adding new entry. Shouldn't
> > > it be as below to schedule the job? Not sure if I miss anything.
> > > 
> > > 	if (!llist_add(&area->llnode, &pending_vm_area_cleanup))
> > > 		schedule_work(&cleanup_vm_area);
> > > 
> > > =====
> > > /**
> > >  * llist_add - add a new entry
> > >  * @new:        new entry to be added
> > >  * @head:       the head for your lock-less list
> > >  *
> > >  * Returns true if the list was empty prior to adding this entry.
> > >  */
> > > static inline bool llist_add(struct llist_node *new, struct llist_head *head)
> > > {
> > >         return llist_add_batch(new, new, head);
> > > }
> > > =====
> > > 
> > But then you will not schedule. If the list is empty, we add one element
> > llist_add() returns 1, but your condition expects 0.
> > 
> > How it works:
> > 
> > If someone keeps adding to the llist and it is not empty we should not
> > trigger a new work, because a current work is in flight(it will cover new comers),
> > i.e. it has been scheduled but it has not yet completed llist_del_all() on
> > the head.
> > 
> > Once it is done, a new comer will trigger a work again only if it sees NULL,
> > i.e. when the list is empty.
> 
> Fair enough. I thought it's a deferring work, in fact it's aiming to put the
> error handling in a workqueue, but not the current atomic context.
> Thanks for the explanation.
> 
You are welcome!

--
Uladzislau Rezki

