Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0919CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DE056B00D1; Tue, 26 May 2026 09:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6836B00D3; Tue, 26 May 2026 09:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3A06B00D4; Tue, 26 May 2026 09:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F15B46B00D1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:42:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90E3D8DEA3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:42:01 +0000 (UTC)
X-FDA: 84809684442.28.B560D82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4C62140009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:41:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB9JBhYm;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779802919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whrQ5TAuNm8jjG/nB8vNOlNyW3idicERerbUe4OrMjs=;
	b=DF9pRsAuvr/tpdbKHfql6ypqTvaLTApdW/yn6qOg+lXlY8fvapfjJuMFmOP92nf8IoSFna
	+V+FYps6LvuFdLqA4NJAl6LZe+jdpgH25M7OFvOuG2YUxetPiJYJ7VAah/vvf6ufO8da2O
	ODElchnJh/Ie4nWMsNw7Xg7tHck3d1g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jB9JBhYm;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779802919; a=rsa-sha256;
	cv=none;
	b=HSmf0NyeQU1eULc8EwHJRHqeKm5actePod3+2jdtsfH06YDtxBtTaOpRKvVt4gwlsSjYTL
	NmgmY04NKpFuPYXEnQeIL/YSA3AO19kKK0L9z3G3XJPYCNk3Xa9jZGf+D1xMMt5gV/xnmN
	1zq6lva9qdQxbgR+el7Mmmy446UqXOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E63B142DF8;
	Tue, 26 May 2026 13:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020EF1F000E9;
	Tue, 26 May 2026 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779802918;
	bh=whrQ5TAuNm8jjG/nB8vNOlNyW3idicERerbUe4OrMjs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jB9JBhYmnH3a0lFXTpYA6VJQfdh32Rhf5rZbVuN5o8J7dTSGI9q5ZpmfUy2xERyVE
	 XTAsFXH4vDYtZNlpmJO3dIk1EiNqF0W3Z9zmhx1JEor2OO/B8SwJ+WqfIIfrZwl2Zx
	 ErzWCOB+B52x9BmlV1UO8JmgP4qLDtXJzi3LE7a0aCus+5JaDeKJBf/v2cVTYIT86h
	 arB0UIvdmRsd1xR04Y36tMVDwwYJ01DqnuyYzlvMFvFDg6KGcMiAck9rGrbNAoN55O
	 sSuFCB2lz8aRncVfSYL2hQc8PMmqwUd0R9p0Wg8NQSsc2HmZyrLBPA60wU+KI6OnIT
	 NNSbIyXSNHWTQ==
Message-ID: <3bfbb8cd-6291-43e8-9f0e-b8b0b3c568d1@kernel.org>
Date: Tue, 26 May 2026 15:41:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: batch-detach node partial slabs
To: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260525032233.10847-1-hao.li@linux.dev>
 <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <deb9b3eb-2569-48d0-8ecd-f35d78bd8207@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C4C62140009
X-Stat-Signature: wi9nq6txhu9xucjckp9t5o67wzy39zxe
X-HE-Tag: 1779802919-333586
X-HE-Meta: U2FsdGVkX1/Y3rqQLO091dFjgYUtxEa3cTMa4Aw+JrnTMj5iWQ+5nYdWNx/wGHGFL3JkDsIibbbV9SkES1sVpiCd+XQsHFUcFStDGUMqKlpdnSK8gKvSdPvWaUXH3S7dkYyTq01SutFtoVBj84PoJAQgGpisizArSQCnZxe/5A8rOQnvSUb6VPEktDwGLSHCBMdki3/IBLXlmrYpA+/FUJKenKIDd6kdZ038fYtjqn5Zt+7UziO5lvgHPqEagvYIQy8FI6FT5iYXm4sekNTDpUXL0gl/tZtzecAvfeoffm8eafO3Is8ytPj8w2sms98FHbtfiHJEuYg8gB3mDLDRHvRc4aJ0L0UHsf6wVsuM/GNLwBs5j3mcTkwgDbwf77M/w4ejqyTVvbeuwslsYrCRNRvnPkJebTm5u7dIC+qqcAqE9WZPGSpoQ+BO2y8lfMLMJDhd38SWdcW2+D1lSN45UfKJFgNFRg7klQAWWTrwoIaiXhoN+RGgoKvudTi1R5E5axdubPwZEwiCUYIweJiwYrCThS8HAe+h2FcYbJ/KViZ7KqCzA3izuoZoegS/FYfNl2NSdSLxJYLnKkbolvGMuhyaoZzIBt5Tsa4TVgVM87ixTXpIMW4gPZo5+3uq5nYE4U2Yzx2b3TeZ/mr4EccoU/piPd07arykAfFimBAH0PixnZnzsrSoTo5J+sSJt4WOvmotyY8tix1rXH13Q6yQrGbXEFUaVCpCY7wuO8UAs1RfZXlw3E6fs8Yp/QGrhU/00u0Y1s5WRuvoTPvmez8JJDRHOJjJxiSL6UIzyeAhd6s43x0vbTM0N4so66Juzv3Jbvzww8P7OHwspDJKLp64i66sQKiG8AolOa18UfYTxkwRBAi81uPyNzT+PU5rLO2KvHSAazlxdhS4YsOmBaFMFOBxBY7q6ZNNo2/d1b/5vyCy3HhdnQcbF9aTkiwI+Df0yrZjdgRybSRLbwSIIE7
 6UmPhI47
 D6CdVJxTiNTY5Ndf2G9EIXnB8vdvQZzhG8tUO2SUXIBALGdTKDiyn758JVhyEU/UPiOIFlvu0Sd+iWe+Hy38hNuUclqROVjCUmYUtcPs6xTNYiUZn6Ii5ummAPifxCDNv/JbaePrZUBQ9dnn3DtawcUsvmHImr0zz1WqWtOoJhaaBwXk6/RKmwztStVHdkwVOUWgo5SlTEyvoo0vkw5JQA+DDijp6IzgwJgNSV4LQOra3Nk8hsEcTd2VQqi1Le2Ztk0M3gaHWxtC8NI8cUs8YGbi6fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 9:37 AM, Harry Yoo wrote:
> 
> 
> On 5/25/26 12:22 PM, Hao Li wrote:
>> get_partial_node_bulk() used to move each selected slab from the node
>> partial list to the local pc->slabs list using a remove_partial() and
>> list_add() pair. In practice, the loop often detaches several adjacent
>> slabs, so this repeatedly manipulates list pointers while holding
>> n->list_lock, which causes unnecessary churn.
>>
>> Instead, track contiguous runs of matching slabs and move each run with
>> list_bulk_move_tail() in one operation.
> 
> TIL list_bulk_move_tail() :D
> 
>> This reduces list pointer churn> inside the lock critical section.

Nice!

> Similar to this, can we return all slabs in pc->slabs at once when
> returning those slabs to the list? ... I see Vlastimil removed 'nr of
> empty slabs' check in the other series already.
> 
> Now that it inserts slabs to the tail with Vlastimil's patchset, let's
> do a list_splice_tail() instead?

Why not, although it should be rare to return more than one slab in that
path. So in case this change gets tricky for some reason, we can leave it.

BTW, if you also get the same idea as I had and try to replace the
current "remove from pc.slabs initially, reinsert to pc.slabs if it was
a partial refill" with a "keep in pc.slabs and only remove if the refill
was full" to reduce pointer churn, don't try that, it crashes rather
quickly :D

>> The mmap2 testcase shows a 5% improvement after applying this patch.
>>
>> Signed-off-by: Hao Li <hao.li@linux.dev>
>> ---
>>   mm/slub.c | 22 ++++++++++++++++++----
>>   1 file changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 04692a6f9128..180973a4a3d2 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3775,15 +3783,21 @@ static bool get_partial_node_bulk(struct
>> kmem_cache *s,
>>               && total_free + slab_free > pc->max_objects)
>>               break;
>>   -        remove_partial(n, slab);
>> -
>> -        list_add(&slab->slab_list, &pc->slabs);
>> +        if (!first)
>> +            first = slab;
>> +        last = slab;
> 
>> +        slab_clear_node_partial(slab);
>> +        n->nr_partial--;
> 
> Perhaps factor out those two statements into to a common function and
> call it in get_partial_node_bulk() and remove_partial()?
>>           total_free += slab_free;
>>           if (total_free >= pc->max_objects)
>>               break;
>>       }
>>   +    if (first)
>> +        list_bulk_move_tail(&pc->slabs, &first->slab_list,
>> +                    &last->slab_list);
>> +
>>       spin_unlock_irqrestore(&n->list_lock, flags);
>>       return total_free > 0;
>>   }
> 


