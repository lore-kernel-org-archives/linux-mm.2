Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DDFCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9AB8E0081; Wed, 29 Oct 2025 11:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B25F8E0045; Wed, 29 Oct 2025 11:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1038E0081; Wed, 29 Oct 2025 11:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28B958E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:00:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2BC6140833
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:00:41 +0000 (UTC)
X-FDA: 84051463482.30.CC80257
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A31CC001A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:00:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yBeuD/9Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x3QG3XOo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yBeuD/9Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x3QG3XOo;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761750039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UPS7wTW//mEiHwtYoijDeEHmtxYAPJacr3wZrmWnhE=;
	b=PnMDxWOM7I5ppq+xPw1+Az5fw2rrO2XBCVXALEbV5oatjqib2f3FgHLQvy5PH9jzk2QfBq
	7D5JIOnvrfCqnWfDnxnxjLfOUrxP0IADYgYi0zTtJYzf9+XcOGe9mAE1ic7o5PxWvs4LJ9
	Wt+6MihtBwb5ZG7O7Yz4TCnJzzy71pc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yBeuD/9Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x3QG3XOo;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="yBeuD/9Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x3QG3XOo;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761750039; a=rsa-sha256;
	cv=none;
	b=Yv0jEfDA83l4QYOP+sgncb8wvZbbL9SduDAoxQy2d0iRj3i2e4qoRF+BD0LCi4gqKuBog7
	Bna2XknmQdMBKLi7DNJeTnR9MqrIIrMwMC/NGBYoVAvJdxqBbRxTgPRZZJdEuPtHPGAAmE
	UpXwTf2MgY75qhp0dzdAk7E+jO1f1Rc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A0E920DA0;
	Wed, 29 Oct 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761750037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/UPS7wTW//mEiHwtYoijDeEHmtxYAPJacr3wZrmWnhE=;
	b=yBeuD/9Y9l/So3fKT8oTz63oGc18sCCd8qij/eb2gtuUzLNSRR3OoEK7PrzRQHIiiE2Z0c
	AjBDoSzn20PJJErU9Qs1J3winwSC0D2qHywrvOZ1cqVrlJ/syDxMkCnuA1lArWMvZmQ7dy
	CkmRSZSmTP+gQV++Q3ZdOHiAxBs21Bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761750037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/UPS7wTW//mEiHwtYoijDeEHmtxYAPJacr3wZrmWnhE=;
	b=x3QG3XOojeOesUaemgW/C2It7laYG47dKYEPwKKc5IEosp9Z2OQYtW3ULooG0WXB5Y5Fcg
	tzl+gVh/Te1tCFDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761750037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/UPS7wTW//mEiHwtYoijDeEHmtxYAPJacr3wZrmWnhE=;
	b=yBeuD/9Y9l/So3fKT8oTz63oGc18sCCd8qij/eb2gtuUzLNSRR3OoEK7PrzRQHIiiE2Z0c
	AjBDoSzn20PJJErU9Qs1J3winwSC0D2qHywrvOZ1cqVrlJ/syDxMkCnuA1lArWMvZmQ7dy
	CkmRSZSmTP+gQV++Q3ZdOHiAxBs21Bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761750037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/UPS7wTW//mEiHwtYoijDeEHmtxYAPJacr3wZrmWnhE=;
	b=x3QG3XOojeOesUaemgW/C2It7laYG47dKYEPwKKc5IEosp9Z2OQYtW3ULooG0WXB5Y5Fcg
	tzl+gVh/Te1tCFDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BAAC1349D;
	Wed, 29 Oct 2025 15:00:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JPhEChUsAmlgVAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 29 Oct 2025 15:00:37 +0000
Message-ID: <51cfb267-f4f4-42b2-b0ea-d29d62bb1151@suse.cz>
Date: Wed, 29 Oct 2025 16:00:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/19] slab: handle pfmemalloc slabs properly with
 sheaves
Content-Language: en-US
To: Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20251024142137.739555-1-clm@meta.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024142137.739555-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A31CC001A
X-Stat-Signature: f9fmao36qquwwsoxezpxg1t3djtgj7zb
X-Rspam-User: 
X-HE-Tag: 1761750038-920745
X-HE-Meta: U2FsdGVkX1/QlCkwIJfCePGNePR8MvJCFA0+Mtu6xjPETNqXQZdxlPdWtpKtBgUJqLuBusP7NL0bSlfyd/rao0BGjDtTRxUTHaPmyvD3UoMkAKhbRCafdC3/2cWeH692HqeY32SIzVxLgSjmiH/dPkNVbfIdhQOodmC68ABYrf5ps5cQEQG1ew6joMP4TY9hu2MeKEWlpmmUewnMN4MeMXfaMaG0O1W6/zZ/bRxxvm1aEdgPWRpS7e3N0lOPmRu/qN38UaFB2eiA8qOaypiscPN3MLAS3kbbadOjHVx5U+fmYxczun25r0S7Iqo1j92sxuHFaC6sq0/zAMTTAXmUr0M2rZt2B2LorEB+va5TxwdzfmpCoobpTktaNfl+ngWo5ZpvR8vmfehQ7WBKdL73z5pkIH74FuZVZ1O+BD8dfuYkFfzBAqhA5qh6KTwDu98Uxb2x4K+ztFNvAw6jEew/1dcffIoxE0EiO0+pGaCDHKB6xURFQ4AZWOXq6AT/kYiwRJGmccwhvIG9gMJM8wtq8geQDxo51jBNiqNZz7KRIi+n9GXkhkAQlpxhThr6ZgGnKiEWHd1D6iL4YbZxSWksrt87wnPTUCdsVUg59AmaCPb1XCH2Mk1tlhAYYKZM49tkvViFEJ5kOgbfSBR4WswHvBB8izAabCWjc8EO3Onjrctpih3xuGbW0oHTu/+v3E1glthIWrRQE06DrpNZtxYkyG1cT8/nySyqSpx9ItRMHBXqb4bsPp45PirgU1VC5I8km+i0MUC+i5ptvsA8qbqUK3u0kbX/BXRnGDVgetwjwQVZr3RSKoUD1dhRbMUbv8X6PBB6DOTBHbONZHjKB9NTvqf3PHFSMEU1fJ4Jq90gHppCmUBl/QZQqhbOUi4BDNNAbQqV4M38TtYoz9S+8m7ZQLMI3iNuNdb9IkOj5In/z2xLqFhfApUMx4Em8IuTMgiZa2BzChnRg6DbTYCcJ2N
 wy0DigSd
 xIS8OcXQ1hqwZtzPmetciqO3tm301yDKfEJON+WMBXX2OQdjcCmPfc6JJ4/dcWGmu4JRw444JL5Q6Nf3gaq9nAA74VkBBPKDJVYiMVZowRzKiZF9SnSoQdnmnUGEDwSQfKwVQOF2g4oXXe2b9SrcEvjZd1+yJ63cTNrUSP3M/7aZHwMni9jm88zFVTVyX2EeJJt0LSc2Y5OduvlwHynArb26aRh3QSv1W9pl7woAe1Fer9qkyZMxbd0q809KEyVCda8qD3lb+XUocmWlG7oRxIK4rfjIWXUCwxhDh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 16:21, Chris Mason wrote:
> On Thu, 23 Oct 2025 15:52:24 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>> @@ -5497,7 +5528,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>>
>>  	if (likely(sheaf->capacity >= size)) {
>>  		if (likely(sheaf->capacity == s->sheaf_capacity))
>> -			return refill_sheaf(s, sheaf, gfp);
>> +			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
>>
>>  		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
>>  					     &sheaf->objects[sheaf->size])) {
>                                              ^^^
> 
> In kmem_cache_refill_sheaf(), does the oversize sheaf path (when
> sheaf->capacity != s->sheaf_capacity) need __GFP_NOMEMALLOC too?
> 
> The commit message says "When refilling sheaves, use __GFP_NOMEMALLOC
> to override any pfmemalloc context", and the normal capacity path now
> calls __prefill_sheaf_pfmemalloc() which adds __GFP_NOMEMALLOC.
> 
> But this oversize path still calls __kmem_cache_alloc_bulk() with the
> raw gfp flags. If the calling context is pfmemalloc-enabled (e.g.,
> during swap or network operations), could pfmemalloc objects be
> allocated into the sheaf? Those objects would then be returned via

Yes.

> kmem_cache_alloc_from_sheaf() to potentially non-pfmemalloc callers.

The assumption is the caller will use the prefilled sheaf for its purposes
and not pass it to other callers. The reason for caring about pfmemalloc and
setting sheaf->pfmemalloc is only to recognize them when the prefilled sheaf
is returned - so that it's flushed+freed and not attached as pcs->spare -
that would then be available to other non-pfmemalloc callers.

But we always flush oversize sheaves when those are returned, so it's not
necessary to also track pfmemalloc for them. I'll add a comment about it.

Thanks,
Vlastimil

> Similar issue exists in kmem_cache_prefill_sheaf() for the oversize
> path at the function's start, though that code wasn't modified by this
> patch.
> 
>>  			return -ENOMEM;
>>  		}
>>  		sheaf->size = sheaf->capacity;
> 
> [ ... ]
> 
> 


