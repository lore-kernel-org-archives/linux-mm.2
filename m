Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37263CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1CD6B0005; Wed, 27 May 2026 02:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752FD6B008A; Wed, 27 May 2026 02:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668766B008C; Wed, 27 May 2026 02:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B716B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:09:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 025331A0536
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:09:09 +0000 (UTC)
X-FDA: 84812172060.16.42CD851
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 260AA100006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:09:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjoTrTst;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779862148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9ewrIz+SyMPsubDHWfrfvKm49lh08EEH8A/DxxOjuQ=;
	b=jg01KBct9wxNcXzVcc/4da1RrVExc4lExBeU2I6nk4UP7op4ktT4BCymIZOZ+NwQ5oDHkw
	KAOYuVVWNR4Ck0+oItIGNtAjRAqwGigtwnEyFfA9VQ5fRA+jqIscBcTuiDpCIWIWaw6SDz
	Clt8FR3N9p36cKzaKWF4Cz3aTB02Dgw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bjoTrTst;
	spf=pass (imf05.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779862148; a=rsa-sha256;
	cv=none;
	b=Y+Z6jGFYo5KF/x8JpVYPNuxtnnOpSwGWLvCedD6sr/oZb6P9punEmLqHM3GLQgkPzjEaHX
	TaO5PK5gL1d9vaHY3fW9pWtmqI/2IuBPL8kxXN6ucRbnltxVH2Tp8/zRGiVfVDiEioeJG7
	VugJo2u5NT54ZHkGmiTJPbSUX1fHOso=
Date: Wed, 27 May 2026 14:08:34 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779862146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R9ewrIz+SyMPsubDHWfrfvKm49lh08EEH8A/DxxOjuQ=;
	b=bjoTrTstgSAFpYNDYakxqudYv7fkxNsj20YqYlt/l3g8PG8mMzS3vmdnqGi9Oa2JhH2vrz
	fUSI9lkShp7h114JwjbSgyqdT98eoAW63R7A8no0pjzrWn7zGuJc7z/X4A+aH0+9zmFvLG
	EuW7v1pN+USZOWm3EmmyiBcanykQ6xc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: batch-detach node partial slabs
Message-ID: <ahaGwwbPyfFu-CM_@fedora>
References: <20260525032233.10847-1-hao.li@linux.dev>
 <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
 <3bfbb8cd-6291-43e8-9f0e-b8b0b3c568d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3bfbb8cd-6291-43e8-9f0e-b8b0b3c568d1@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 260AA100006
X-Stat-Signature: nm5fn3oe7rtwm738znf1upfyqbfkqrwq
X-HE-Tag: 1779862147-613252
X-HE-Meta: U2FsdGVkX19kqUbUyv0SJ0IzuwuunhdckP4tyAB4ug8I3sxEojvvR+QrNO5YY7c6W+EPeEa3L9MVWMcafNf4+Epm2ji5tA78oDUAqJZj5LH3kAOFSe73dekc6G+uZv8oraL/h3baevrCsmDivzljlm7/CpIkrB1uHqInAn0KM3Qx3BQYnIre32U7ZYbhSfZwiP39iRLodOrirx5muFqPJvIbjov/SujJ+8LgKw/o3Z6+m6oNxhmkiC3e4W9UvBctVwuPOd0Tl3W9y8dhZQhdtBIJzc2xHFb6vP0RAr+pFJRA8XKrSiqLGsOn+L3L3wvjES91h9xsrMuHpa4FIlCiZNcHcNE2HqOAY3leA+uaXtonNZvgHvDoCp3w6pfPx0unQCTB8VUFlaAiPLEWpOzZztnPGGjnbqsDxZk07FIo6vgATCbr2cgfBgiI9xsnr/6ZqeldxCMN+4gsWeyWQrdMz4LpRqvFAJm3mjdJn9neHYpcUknPefhov+zUxjFNLCL4r+FtzsbRvf6UNtyIuyv1SjjnhIJdLeKc/pzh7C/34adhvXCYaG5nakTtKa4lldGVVlG0TEPDM0gnhB5IsrrBpBc08XlUN7WJH4TePt7EPvmZ3/6vGcpzWrwEVVTaZmCcIH8hFPRe3ICum+SyNRmZYN84BURoRlIHnu5zfHSBDv8V1GrcQvrgP42OZRJ4Th7VkFXuW7MvU0HS92kq67n2vTsO7B9Fvbx7NbutCBSMIbp6FuwqSGq6qU3lbTnbJrT6KloHn+/lrZ2mcE/jjL7CsmvFcCLu13xxvyz6oWmlKyOlZ+Chgydi6rKHCmeIGrzDuNa9qFejhEcQiuex1WOyuvWdzwalcpWPqwqely3cgcbPl3/14Ss/XJ8znlctWgi0mhEdzOrKGnRk+ZWSXbgqqpPSezSXF/TLpXtR+b5WbwlzIbDWGWENcjM2HWbAM6mduzmBlvxPWZkr/phd8hE
 mGdh2AG0
 +ekF1UW2iIYQaeUvQ337tD8S2Iit4VpksNkt/Bt2AOqcuyPUrUjVYPn5NvMHqElXfp0MGGIYpBqpstcgZnOv+QUCbUb17Fg1roZ7RFL4pyZ0fYnV2tMoHFCATP0+A07k3G69Qid1ZlXh+Rwv4g/ufHr+P8R5MhHEPctCUuXdAGq49pi90JExICk9Y9TSeo78zKVQv0hu+VMgERuOM/jHAig+LmFMfASmle3VN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:41:55PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/26/26 9:37 AM, Harry Yoo wrote:
> > 
> > 
> > On 5/25/26 12:22 PM, Hao Li wrote:
> >> get_partial_node_bulk() used to move each selected slab from the node
> >> partial list to the local pc->slabs list using a remove_partial() and
> >> list_add() pair. In practice, the loop often detaches several adjacent
> >> slabs, so this repeatedly manipulates list pointers while holding
> >> n->list_lock, which causes unnecessary churn.
> >>
> >> Instead, track contiguous runs of matching slabs and move each run with
> >> list_bulk_move_tail() in one operation.
> > 
> > TIL list_bulk_move_tail() :D
> > 
> >> This reduces list pointer churn> inside the lock critical section.
> 
> Nice!
> 
> > Similar to this, can we return all slabs in pc->slabs at once when
> > returning those slabs to the list? ... I see Vlastimil removed 'nr of
> > empty slabs' check in the other series already.
> > 
> > Now that it inserts slabs to the tail with Vlastimil's patchset, let's
> > do a list_splice_tail() instead?
> 
> Why not, although it should be rare to return more than one slab in that
> path.

Yeah, it's definitely still worth doing.

> So in case this change gets tricky for some reason, we can leave it.

sure, I will try and test.

> 
> BTW, if you also get the same idea as I had and try to replace the
> current "remove from pc.slabs initially, reinsert to pc.slabs if it was
> a partial refill" with a "keep in pc.slabs and only remove if the refill
> was full" to reduce pointer churn, don't try that, it crashes rather
> quickly :D

Ah, fair enough. But honestly, it did seem like a good idea initially.

> 
> >> The mmap2 testcase shows a 5% improvement after applying this patch.
> >>
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> ---
> >>   mm/slub.c | 22 ++++++++++++++++++----
> >>   1 file changed, 18 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 04692a6f9128..180973a4a3d2 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -3775,15 +3783,21 @@ static bool get_partial_node_bulk(struct
> >> kmem_cache *s,
> >>               && total_free + slab_free > pc->max_objects)
> >>               break;
> >>   -        remove_partial(n, slab);
> >> -
> >> -        list_add(&slab->slab_list, &pc->slabs);
> >> +        if (!first)
> >> +            first = slab;
> >> +        last = slab;
> > 
> >> +        slab_clear_node_partial(slab);
> >> +        n->nr_partial--;
> > 
> > Perhaps factor out those two statements into to a common function and
> > call it in get_partial_node_bulk() and remove_partial()?
> >>           total_free += slab_free;
> >>           if (total_free >= pc->max_objects)
> >>               break;
> >>       }
> >>   +    if (first)
> >> +        list_bulk_move_tail(&pc->slabs, &first->slab_list,
> >> +                    &last->slab_list);
> >> +
> >>       spin_unlock_irqrestore(&n->list_lock, flags);
> >>       return total_free > 0;
> >>   }
> > 
> 

-- 
Thanks,
Hao

