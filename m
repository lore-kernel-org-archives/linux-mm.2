Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C583ACD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C416B0088; Tue, 26 May 2026 05:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D2C6B0096; Tue, 26 May 2026 05:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95636B0098; Tue, 26 May 2026 05:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD00A6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:09:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 859021A018D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:09:25 +0000 (UTC)
X-FDA: 84808997490.19.A9BF334
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id AACA11C000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:09:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p9IWdmdq;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Av4VS/wv4E9mLXQbLY6JNstbYHwbHdBV3kDnr83jr8=;
	b=d70qKT4o0ToASsMN8Edj8wivVEZkiK10jEdSw7MHr8u5skMYCsXUGnMBOUGzskXQyR3lPR
	6cU85Tbz84KoQKN49SIQpu97qjsWl4E6wf6GZ8UmgVRfksObj7yBfhGIoPJ3E/i6yeoNrl
	yIWyi4Y2Saw/nUKTxok9TY6Di8KdTs0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786564; a=rsa-sha256;
	cv=none;
	b=BVzTbXUajhIGCJKC+WKLX6KjYCDUcuVbrJJaDds209oViuy+RKYUdg+v7CU9p3je3YLZno
	goUY0Qq04fU8p00U8iEnDE3LCM+8ZWAK9YV/5BQyqmaTDpI2pZr9ku6oyk5XX5b3BNcCPf
	7GQfFpCJDRrB6d2zyS3x1PjHHl2kJnQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p9IWdmdq;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 26 May 2026 17:08:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779786561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Av4VS/wv4E9mLXQbLY6JNstbYHwbHdBV3kDnr83jr8=;
	b=p9IWdmdqX6SNOxH1IJtOP7k2EBJNTZILa1m9fOH9nDQ64YliorTOHexSpztjQCZMPfyLQr
	Q8Gbu9JDjOHg2Clc1m2RYOZBvxm69U2+18cmRmuxodqF0fyXnkGgRf/G615I1sohrib4EA
	FvmjF1UeOvwvM6cvYQwc6Gohg0Sem9c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: batch-detach node partial slabs
Message-ID: <ahVgLoGhiAQ6WTbK@fedora>
References: <20260525032233.10847-1-hao.li@linux.dev>
 <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AACA11C000C
X-Stat-Signature: 4qgc8ptswqdmnjir3djs6u8eq7ow5qyn
X-Rspamd-Server: rspam06
X-HE-Tag: 1779786563-115203
X-HE-Meta: U2FsdGVkX19EXdZYat2rRmPXpu3X8lFcAg0mOvROzZ2/cBDNot4OKF0jOuhYStBeY1XGbPePHvBDN60LGcTDCuwulk0LKdqhrfLnKpPhFpMx5J1FjAK6Jsrfjw9wpTDVsa0JOjPCpcRiy9rpVE+RePpUpfA1SaOERYJVoD4u7jlt1xuOWDgI2GsqQ5oSvIcaro4cY8yM+DkeKiNsPtGxMIbOCMWD9Mem45woPY7ePn7Bf34dYeKd0UwRLxdFp8cTuTepxTNjRunnuunZcJGqTy9f87Z/xNdJQGwaZ8ygkqk+EA4Sr/k2mkURJb1E+qg5zp7Wt7tU/WcavFoRGmgtjZWEiNWmj33tE8AI5acHUuHMz0JxvHpFJvHSN+IIkFp/TAmAQE/Y1cEgawdB90hJUl9kbAXNR9ZZaVIXvckhSOg0CQd2JnY35JNwT+C4D3hozn7riCRvZejeVsowI2pYdDe6Q+X+qba6fVNn1tU9NC8VjtnCWeUUO8/RLjogzwD+sKf9+TLdyAzrNrzKV7s8oRz/S/yAmGMSTJ2E/dmhVbVbiU6Kf08eq9SDqAy6kKIorQKaY+eN5Dbd4JEUqPMG58wkg+XygmH5eLcZ8/f7E9VtPdz/SBlJj8JwWOgohMQveP5V+d9fOiR9F8ljoUSH+8L2L/hkhuFnzRp3fKv0B+GcfTPgAykxKTCH6OZxfg/GU+RDYYHJABWyGApwKszNoA2NZDurRwUOi0X2K4C82Lu57C3Uru+kB6AcL6tGE57xt31RWhx9xSqsnrjkWyj3O0QXL1Q6CuBgcuJ0KsqvVGsbLitCQmYo71XDnOvJiHJn8+FKs8LcR7lcg+QZPSI3LoKQ0BKKl45VOpyUSMNaFckazCpvWX/2wS3N/+bHLWKGIN9GlRhYqroTouExW0fVeNohuZ3YpuNdhPvOGBiv3SXQUdtZ27UFckK3IAd4nkBADHc9aCg9mOX/i7ctKkA
 GMOfJfL6
 0Ez7w77LlUDLGklGua6z9cTIMK3nlmKVWaue/j5e+WF68uaGWu87qKPgPlbX5VWlqtKNhJt+VJCr8h3cVAoBvIYvuk0oAxYn2xnQJTizdmXVFgh+FkWRmk2ezEpIAFutSOsBiRVWhpsZ96M+erdh6f5Txvt/mjFzBFiq5FRM1K1gvaOgYvWlmj9uRcAMxi136Evvai6jShjY7aP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 04:37:46PM +0900, Harry Yoo wrote:
> 
> 
> On 5/25/26 12:22 PM, Hao Li wrote:
> > get_partial_node_bulk() used to move each selected slab from the node
> > partial list to the local pc->slabs list using a remove_partial() and
> > list_add() pair. In practice, the loop often detaches several adjacent
> > slabs, so this repeatedly manipulates list pointers while holding
> > n->list_lock, which causes unnecessary churn.
> > 
> > Instead, track contiguous runs of matching slabs and move each run with
> > list_bulk_move_tail() in one operation.
> 
> TIL list_bulk_move_tail() :D

I had to dig through list.h for ages just to find it :P

> 
> > This reduces list pointer churn> inside the lock critical section.
> 
> Similar to this, can we return all slabs in pc->slabs at once when returning
> those slabs to the list? ... I see Vlastimil removed 'nr of empty slabs'
> check in the other series already.
> 
> Now that it inserts slabs to the tail with Vlastimil's patchset, let's do a
> list_splice_tail() instead?

Great idea! then both get and put operations will be highly efficient.

> 
> > The mmap2 testcase shows a 5% improvement after applying this patch.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >   mm/slub.c | 22 ++++++++++++++++++----
> >   1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 04692a6f9128..180973a4a3d2 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3775,15 +3783,21 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
> >   		    && total_free + slab_free > pc->max_objects)
> >   			break;
> > -		remove_partial(n, slab);
> > -
> > -		list_add(&slab->slab_list, &pc->slabs);
> > +		if (!first)
> > +			first = slab;
> > +		last = slab;
> 
> > +		slab_clear_node_partial(slab);
> > +		n->nr_partial--;
> 
> Perhaps factor out those two statements into to a common function and call
> it in get_partial_node_bulk() and remove_partial()?

Agreed, this is very reasonable.

> >   		total_free += slab_free;
> >   		if (total_free >= pc->max_objects)
> >   			break;
> >   	}
> > +	if (first)
> > +		list_bulk_move_tail(&pc->slabs, &first->slab_list,
> > +				    &last->slab_list);
> > +
> >   	spin_unlock_irqrestore(&n->list_lock, flags);
> >   	return total_free > 0;
> >   }
> 

Thanks for the review!

-- 
Thanks,
Hao

