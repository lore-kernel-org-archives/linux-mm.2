Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC801CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:15:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E066B0093; Mon, 25 May 2026 03:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025976B0095; Mon, 25 May 2026 03:15:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E036B0096; Mon, 25 May 2026 03:15:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D67D76B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:15:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F88D14019B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:15:56 +0000 (UTC)
X-FDA: 84805082712.02.C9EF79E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB76540006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:15:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU3SbVn9;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779693354; a=rsa-sha256;
	cv=none;
	b=i57GrikU/bp0TKuS3pSKMMOgI4y97Jny5bkVT6MhUxRoQFRwxARgbBcYb6X0OnunpdfLfl
	tbH+fhXN1C2UOp1rqkc9RWEycRT2Eiydmp50Ijo4ZpmXymLcnROuD/pL6YYPMPXDJ1EwcW
	cjCyEZrFmgOZTbSLNq8sZjnY1B0uJ+k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bU3SbVn9;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779693354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T63Bqc31lmcxY2myxBMwsjJ8z6BwCskmI51/Qnu07gQ=;
	b=zX/auvXgyq7242gFuRP8QxKsPz8fL3lUuefaJPjoAe7np4vgggv9RFGxCiJH1klwDx2IQC
	TLyuH+VoyLC5gb5dS1QpYBxSaiedY+9Qz3wg5u4up4agd96be5Cw7APBQQx8H0pLUW9y+F
	tp8S0tzrku8lcHuzbPRBFbX4OfBoRqQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48EE6601FD;
	Mon, 25 May 2026 07:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1511F000E9;
	Mon, 25 May 2026 07:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779693354;
	bh=T63Bqc31lmcxY2myxBMwsjJ8z6BwCskmI51/Qnu07gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bU3SbVn9pOYKZcc+xFPSPV57BDiCS3p/GHIYS9W5yMafJwWvtVle0M2xY4vP5XJFj
	 A2OXN/OQ4Q4KQtoTcXmOLZHXn8C1QFbt61m4fFVTrJMo5s03Zf1w6IEeJxnoH/itS9
	 NinNn5xwWV9SVG2VXvY+3EQF7PN8R81FRtjwoy/UzPU4ELxHlXT3I+FO0fkI4O/bAU
	 fzL3trNISBI6VAHRz0IR3SfqrReHJcfxhIHlF9WSQChwlEgKLLzxGjsGcX1P6FG8Hz
	 FZ6PnDA/WyfyIuhUSQYFO/Gj/Kkf0+tB2b9KZOfgOK9f3IYBLciX3ZcnkJhIHqQIao
	 Vag4TuEMN09bQ==
Message-ID: <80d69c1c-a779-4402-af89-3be67b7f0e47@kernel.org>
Date: Mon, 25 May 2026 09:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] mm, slab: simplify returning slab in
 __refill_objects_node()
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
 <ahPucZOXNmJc04nZ@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <ahPucZOXNmJc04nZ@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DB76540006
X-Rspamd-Server: rspam03
X-Stat-Signature: gk9ey5b8kohhumiuob3ggpt7y6q3izg3
X-HE-Tag: 1779693354-769756
X-HE-Meta: U2FsdGVkX19HrJfULfXdpFxT3YHxUo5mtWxkzIdA8zAPWBwc0lfH75GGTzTpjL/Ovv50tL1g3YJFxQl5lGpnuzQhtZFSRcvv/f5sjgOR7DN2qdiXCK9pdfbFr/e2JK1gX7AgRt46h+S5djDs2XM70K5keGZABemxUt1uVY3twLIIgRnxekHpTXNt8pT+eB0LqJq7lSI774RxJ0YWNStDu70GHmIWTQSDSpvHoLZBEgus8u5tQnFqHxhmZHoZe7hWYS4Rrr3waEy7vS33D+FlHWWDgSrIT7OSKVPEqnwLvGQIj4MeOlLRbLEI0j0UzQKJic4x56UugTnS7KTEPyRXEVwYxrm1lNEX7k7MCWpEDgeMYDLlj/wH3yGjHLmH7swVCwlXugUJe2tZKw6N6qgcQXwcznmej6rKGwP1qcV+auPOg5D5y8xVLr4EYewGJCQ87yj+H4he6aLCkRDm8p59jgZh6ir/CHa0ST+n1QusYZ+PZLjolO+ZEOfdi0epZeO/Wo0MJp0HDC12RUCiP6tLAWyObW+QuXze28/9FhrdnTMjht7WM5X6ABnRWAiwKx4Z7i5XMEskfc3EyU/V+a32k/FeM9B44hYiqtIC8O74XpEqDh4VifIYd9MWbZAjuqmhMgSAlVLPFPlQN6cnToeVJhkt0a1GYAYWUAcwRg5QmHTrBb3QVUq7tWEtcZVhUcHgoIo9bvGHsOxudojzLQD29rJUpbuY10znSXWx2PRfmEVrMV5Z94HKt6+sGQW7qoMgw2bShTBCCoQbtpeJ8jPEwLDbXcMWgOPg7BhKdcXVzIMJDozl8tgdaPlNJtXGdTRMvB1SosgknJ/XpWDuUfmmXB1wLlB/E7bGqzG5M+0f1C2x6v54RoXOEK5PU8kNuC8pnuq3+fGnQ6F1GJNCsQUlrzxODvsHjuu93Z0zpbqe4HtJbJoIm+09AHAnjVxoa/TzaTa1OFRoOqLRBUXc2Vk
 v5noOHW1
 gBSda1TblJ4FfQ2p5ezEo6Nq4Y5LP2USuY+Dtnpzyt02cQb4ynBH2J+3d6iFUnK9G1VpFB842IF5dB1axYYjnXNo0nGEbUnIKZqenpzqaekXSyGwC4gzNNnigf5tSI6LoXlsS6NloYdoGvRFZ7gXIZ1hiUieFO0TyW71LtEGpgPJk2cQI5bB4ZoO4JjxhhYDUoCqWihXdNaYhuXweLJWJa56lTlG2N1fL8dc3Rx4qWThagF29Iy8lRLqpJU8ZnVu3hDGG1a+ePpBqab1Y1nHB6H1ho0MlH5ruvh5XRVM8Bi/SuUXCyV4VhoyCuuGFw6LK0jiZCZ+Mv/r0HSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 08:47, Hao Li wrote:
> On Fri, May 22, 2026 at 04:23:21PM +0200, Vlastimil Babka (SUSE) wrote:
>> When we return slabs to the partial list because we didn't fully refill
>> from them, we observe the min_partial limit when the returned slab is
>> empty, and discard it when over the limit. But it's unlikely for the
>> limit to be reached while we were refilling, and the worst outcome is to
>> have temporarily more free slabs on the list than necessary.
> 
> Just wondering if the empty slabs temporarily exceed the limit and then some
> objects get allocated from them, would this lead to more fragmented slabs in
> the node partial list?

I think since we're adding the slabs to tail and refill from head, it
shouldn't happen that easily. Fragmenting is possible in general due to bad
luck, I doubt this change could make it noticeably worse.

>> So just
>> drop that code and simplify the function.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slub.c | 10 ----------
>>  1 file changed, 10 deletions(-)
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 5816fcfc7a90..074d57c0390b 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -7196,21 +7196,11 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>>  
>>  		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>>  
>> -			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
>> -				continue;
>> -
>>  			list_del(&slab->slab_list);
>>  			add_partial(n, slab, ADD_TO_TAIL);
>>  		}
>>  
>>  		spin_unlock_irqrestore(&n->list_lock, flags);
>> -
>> -		/* any slabs left are completely free and for discard */
>> -		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>> -
>> -			list_del(&slab->slab_list);
>> -			discard_slab(s, slab);
>> -		}
>>  	}
>>  
>>  	return refilled;
>> 
>> -- 
>> 2.54.0
>> 
> 


