Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5654CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F70E80131; Tue, 28 Oct 2025 08:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE538E0016; Tue, 28 Oct 2025 08:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895AB80131; Tue, 28 Oct 2025 08:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744BA8E0016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 08:30:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B38A885BA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:30:51 +0000 (UTC)
X-FDA: 84047457102.11.B2E07A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61E8F100014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:30:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PM2aBzdo;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761654648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caqFFVQ8CNc5/R1/dbClJ7vCcMhRSm3xqXDsXqZLJ3g=;
	b=M7njfFSrE7F0l7qYU+sOshWtpRhKvZv5NIXqxKY3QytnX1WluWIPJWWok/S3FDHDAx6s8L
	cAV1+6aOTXkOltVhdPQUH0ZtiKFxeCZiEPF0zNb/LQ07UBVZho9Y/t4jFsmyo9ZafQ/wUc
	rZtQNsYOMTwdozsh/TuKqVuStXGFu9U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761654648; a=rsa-sha256;
	cv=none;
	b=dEVmxXhQ6kdr2ECGTYh85QA8deNBZjL5W3jlUG8TEpZ7kt0nK3t4T7YPilOLK7DtEziVvX
	9k4XKkEUCAinIz59spHsyzX9KU05TrPgfAaSwE72RZxvnwpcidytWrDGsNJ635hrkPMViU
	LTvhevGD14zpzz89ovtv34+Z8l5ijm4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PM2aBzdo;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761654647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=caqFFVQ8CNc5/R1/dbClJ7vCcMhRSm3xqXDsXqZLJ3g=;
	b=PM2aBzdowR8IuoMzT7Xc81FITfQ6FKsSdePFD7Q9nBEzWU56ixQTZtVRVb/cWeJndP+90n
	/eGGpmr9W4M9C8Bt/8RbdCWKLOdZ5GV7K45SDoVp3nf+NEvftqbrh9JJJZBtm9ChRct048
	pj+WWm9xWYKftTKQ8O3o8DIxDFiHEY8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-7NZ5hGtAO0Sk5BoXQ6xdOA-1; Tue, 28 Oct 2025 08:30:46 -0400
X-MC-Unique: 7NZ5hGtAO0Sk5BoXQ6xdOA-1
X-Mimecast-MFC-AGG-ID: 7NZ5hGtAO0Sk5BoXQ6xdOA_1761654645
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso2812599f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761654645; x=1762259445;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caqFFVQ8CNc5/R1/dbClJ7vCcMhRSm3xqXDsXqZLJ3g=;
        b=mrlO9N03S4dfswqNJYw+izlo3yGPXik386JeXrIi01j/LcZFrFkGm/ra9qkSX1EVbf
         DCaHPdMxI629S4kOWaXzNaavEC7TMH2xURZB0NaBuluznue7fWMuU6n2dyVxGx/c9bFg
         8hJWymbsY/HmfCysP2hArXUnxMSHeswhWEHpReJgnve1yHSZ/xcJ2IuKz4N0b/FJgq3i
         Qrttxi2EIh31YDTX5taekI8nWWbRz65RJv061HUqdQeMQNE3ZcKHXj4cB8i1zHAZDqlQ
         ieT249Myr0dizX1GKIOWlaNKvgliY+KKvSnBd8g2Ay6Mgcr7mnTHw3XL59lv84B1V+tc
         xKxA==
X-Forwarded-Encrypted: i=1; AJvYcCUCSkhbA7380FNPRAPMNlpj2mviG4KH1eiAijZjg6Vqa2p+vB+a1jCdDugoZ8SADe1V3HZ2LRqOdQ==@kvack.org
X-Gm-Message-State: AOJu0YxjedMuA0fLrFYMhUHpArceyE+c/Aby19pht8QnABFH+HlVQNCI
	e1tGcYMxg1sIYTtQ1wEpmria22I8S1IHx61+TAcoISq2n8M5awdnJiPvYDROmOM5e+pQSoj6xEu
	OXFBLFSYUPUZlePR8JrgMF1ETZQ7TcAM3OOatl4C0OozG+p4SWiK+
X-Gm-Gg: ASbGncum07xGg2ZCpeTXA77Nw8nsV/7fq50IZbVKrhOML6y8pE17BgIlCXrBn+82J21
	z44utwvFtKZiZEQ3bZIlO7ZIh1GNo9oY2l3tFBJt4rke2ih8+O7RSyumamVpTLjSlmMZFYQTkPc
	B1+pFlDPm8HvSImy4KQzpQvP440B/gesTl/HTqjt7hW1AeTgRB4yZ3aGXXf7kLGTY8cn8fAoKZT
	XvrDDggCyJLaaoln+A7V1Ma/wa2JDhttTxwuDyVqsdjilTk5DGCwW0wwmYjElJoNJFgb2A8K1C3
	yoTG7JUKUNnsqPU501n8JtXEXm05cAld4V4yynp1On86wCcdc3k4uz1nYnEF/ZrZJy7c/OWAnMg
	zeU1yObw6LVl+kdx0HPt9jQi2Eak9GsQr
X-Received: by 2002:a05:6000:40ca:b0:429:927e:f2d with SMTP id ffacd0b85a97d-429a7e7c749mr2889988f8f.38.1761654645139;
        Tue, 28 Oct 2025 05:30:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7VWu1SeQzGMTvsGngxg3n6PbbCnycHv6IKEDtKtHjHqjgMWOZby3dOBVswiYkPRmc1I0l4Q==
X-Received: by 2002:a05:6000:40ca:b0:429:927e:f2d with SMTP id ffacd0b85a97d-429a7e7c749mr2889962f8f.38.1761654644712;
        Tue, 28 Oct 2025 05:30:44 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7badsm19778750f8f.7.2025.10.28.05.30.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 05:30:44 -0700 (PDT)
Message-ID: <bcfd4b80-df1b-4b6c-8ae2-1b3dbd8de23a@redhat.com>
Date: Tue, 28 Oct 2025 13:30:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: Honour writable bit in mremap pte batching
To: Pedro Falcato <pfalcato@suse.de>, Dev Jain <dev.jain@arm.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Barry Song <baohua@kernel.org>, "open list:MEMORY MAPPING"
 <linux-mm@kvack.org>
References: <20251028063952.90313-1-dev.jain@arm.com>
 <jmxnalmkkc5ztfhokqtzqihsdji2gprnv5z4tzruxi6iqgfkni@aerronulpyem>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <jmxnalmkkc5ztfhokqtzqihsdji2gprnv5z4tzruxi6iqgfkni@aerronulpyem>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: x9DLPcOVC3dB9vioz4UAW9QWSNYrGTe_JoqkCJ1q2Ik_1761654645
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 7kfnx78wiyn8cpzxmf463iosiwjqhq6n
X-Rspam-User: 
X-Rspamd-Queue-Id: 61E8F100014
X-HE-Tag: 1761654648-201471
X-HE-Meta: U2FsdGVkX19osEZt1z60iKmAI0a0EHpYacwwLgDGM4GIQMUXubdhJ3sIJvZ9mQNRuFYFdoU7GQR+GqYsvJ3NlfGjE34FfIlRt7XX36qR3NBMRsBBv67nP5GwwMq01Hv6c5VEYYA1yRXk9cw/zTanBFiZv5X2tNW97qEuiOy6K3RU8R0VaKDlSerL2Ki2U9Vm3jS8MyhRxG6+C2KDoAntBnHxBQgrSOmHw7gWH+BBAbIfvNK+hnrpA/QRZcLWRw2sscSKWHyj8APxhK109/eY08IN6TNplV/S5Dc2rg7pTo1j7EdugOOMFlcl/lkrSzRyzKeSBAnXwDa5vB1zb7EFjPJx9FyCedclZkhpTFqfYaRDL5Aq/ZlAAA0zWBmFcGPp1tMVG2IIQ+dXDQ8YZiPnxKNns+hTOmAxjX9/26/b2b6YRV7208uqJbk75Q4XubJFfu8UtZIxkzgBvLddVJ/kNFeWHzpmtAqy7/Vax8VsTM+JomnyoEZQ4YBdGX+nCPI3RTao5kqDajjjDz6L3bdp+qL2Y5IN+qJcWgTyIuXJ2J4+10wbRXrIUOJ9zGW/4VGdqXyKVERB5psSeqxXFRjU1dOKR9vy0EdiBDCyFYbZo1ThK9Ck7b0r3rd+RJzD0lEcy1ikpxpugcA8BB97ZF8t0O/s0NY7cbjeX9LV4OVSXOF5vD9A0qkaHaWTWRpQG2tkXw6bDh3DisdJSm3ydLpwutnCBz3wTiUmuY18Pm1HZSZZ16cxzW8Y5zSuemahGUj09+NBcfvyuw83wzk1faaAfeJPpVpM0BPa2A+GBSO73iQVXMbsQouFeqPefO4Q30zdlM2mQuGW8GCTXZFvdAYjEZVgVmN5zeOhOm29V+U17nCsGLPr0pxsqsD/TGFVO0haRL6eFKxAzp7KMeu9+dRfCfwRqVNGNuum9j1TKUFVbraOXj55G8RNq9AwUbIx7BRiKAulLzZBTpIJR/keNQs
 ++C0SCyL
 O+8Ga2se5OmC23q0xSdejpEH6XWaNRTM/amXkG52fpTya2EdusiNkhFtnw3+am/LpMJIA5O+Pg92ApoAEZTy2L8tDQ5g5c+I6ZXCkCrmCTr1UfuKki0l+sIKc089baoJ8H2iooPrPcBM6E5p3AusfgVL9CC2bZ7ZzOQ+5D5nKUji7u/qLtXgZ8YxkUDadA0CZDyGm1N2EiwyMdDbAiuQj/DRJDkVC9UvEZ3/TwGuGL4Ap21sOPfxSkwjz0wWlfSoczXP+zAejKPlnhm/kqwqttVLMANyuOX7B0afjAnQS7vcimyaKn4HLiULcSnpZReYNFmrSZUjBEJ7llY+exadRw1TCaDE1Sl1uB5MdqZfGspI6msvimYyaqKwrq/7bHh5HPwd5ZYXiHOg2rz7kBI1DJ1nGnJHL/6N4GHSzDHzCwpr4FXxLeHqfGaya33qmlCqpJt6FOsmgmhPYRf/Zjm7ZUFlkSJ21Oa7o962yB9fb+sS+6gf2/txK5gQMUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 12:48, Pedro Falcato wrote:
> On Tue, Oct 28, 2025 at 12:09:52PM +0530, Dev Jain wrote:
>> Currently mremap folio pte batch ignores the writable bit during figuring
>> out a set of similar ptes mapping the same folio. Suppose that the first
>> pte of the batch is writable while the others are not - set_ptes will
>> end up setting the writable bit on the other ptes, which is a violation
>> of mremap semantics. Therefore, use FPB_RESPECT_WRITE to check the writable
>> bit while determining the pte batch.
>>
> 
> Hmm, it seems to be like we're doing the wrong thing by default here?
> I must admit I haven't followed the contpte work as much as I would've
> liked, but it doesn't make much sense to me why FPB_RESPECT_WRITE would
> be an option you have to explicitly pass, and where folio_pte_batch (the
> "simple" interface) doesn't Just Do The Right Thing for naive callers.

We use the "simple" version to apply to as many callers as possible: the 
common case, not some "let's be super careful" scenarios.

> 
> Auditing all callers:
>   - khugepaged clears a variable number of ptes
>   - memory.c clears a variable number of ptes
>   - mempolicy.c grabs folios for migrations
>   - mlock.c steps over nr_ptes - 1 ptes, speeding up traversal
>   - mremap is borked since we're remapping nr_ptes ptes
>   - rmap.c TTU unmaps nr_ptes ptes for a given folio
> 
>   so while the vast majority of callers don't seem to care, it would make
>   sense that folio_pte_batch() works conservatively by default, and
>   folio_pte_batch_flags() would allow for further batching (or maybe
>   we would add a separate folio_pte_batch_clear() or
>   folio_pte_batch_greedy() or whatnot).

I think really the tricky part is when we'e not only scanning or 
clearing, but actually want to "set" ptes again based on the result, 
like we do here.

For that we could consider having a second variant. But if it ends up 
having only a single caller, it's also not that great.

> 
>> Cc: stable@vger.kernel.org #6.17
>> Fixes: f822a9a81a31 ("mm: optimize mremap() by PTE batching")
>> Reported-by: David Hildenbrand <david@redhat.com>
>> Debugged-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> But the solution itself looks okay to me. so, fwiw:
> 
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> 

Backport might end up being a bit tricky I suspect.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


