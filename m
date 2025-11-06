Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C0DCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 07:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74A78E0005; Thu,  6 Nov 2025 02:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BD88E0002; Thu,  6 Nov 2025 02:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61818E0005; Thu,  6 Nov 2025 02:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DEF8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:23:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 316341605DC
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:23:50 +0000 (UTC)
X-FDA: 84079342620.11.E89D1C5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id D58FAA000D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:23:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1ru3bnl6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BsryQK1I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hkkosBGu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B0kfOKCP;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762413828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KuTnD+Lrz4fdyLGJ4uF39ab38gWiaLaVToVQMrbw5E=;
	b=wnBozegMzoP39VnNiiOx1cJMGRzKPVnqRK4rmX608hTstMeGYTj61CMtsr/rq8cT4Jwi+Z
	sUJzVB9ZGji35xpkr1vCudWst+FwkGwCeCO1OYkXa6TzZQ1NcVt/B7BYW/4M6VLuQUBFQO
	GmUIVGOpfSwItiJAMWoweP/LxHoAKHs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1ru3bnl6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BsryQK1I;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hkkosBGu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=B0kfOKCP;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762413828; a=rsa-sha256;
	cv=none;
	b=fdSlq6X8E8E4Ensj/iqWzFNxN+05pd0vdtzujd9tXfFUxhRc8I7usMzXQ+APU+m7qxAssa
	buiJ4ju7gEgAJAMy13zTudGozxpajaWKXFaUbRBvRlGfQNB/62wvE1efwKH7xBdXyG3VGv
	qh4Ifg6DdA76QmTiu/wPH34cMOrdv0c=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D7F59211C4;
	Thu,  6 Nov 2025 07:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762413826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7KuTnD+Lrz4fdyLGJ4uF39ab38gWiaLaVToVQMrbw5E=;
	b=1ru3bnl6zTaJQ22XU2gMsGWTpkp+gmHjZZ2t57pZnLSE0QjP0E4B1zcCm8TnUwYyfhG/ep
	OpbTc6WwNFKkMjtP4c8sXl6Ym+xAaFBERP40zXBQU74CT247gS/19DU9MnjP+otQHreMVI
	vs/S4A7gDgq3TAGLaO4pVQsRsSPNGmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762413826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7KuTnD+Lrz4fdyLGJ4uF39ab38gWiaLaVToVQMrbw5E=;
	b=BsryQK1I2wVpamBuHrtZ31BKHFAtMHf9K/Tl5yuw8v+MxsMLHcCbufG/28Lw2pHrIHXDzD
	PfSNFhbLG5sCPrAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762413825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7KuTnD+Lrz4fdyLGJ4uF39ab38gWiaLaVToVQMrbw5E=;
	b=hkkosBGuczAqLSXJr+/wi6QitrxxQFm0+AGDbamyv1Hy6AxZBklElEY7Ezgt4Bnt4z7fyQ
	qfBeJRVDWzYhbvr4amFFMTne3KNKcgx/e35xjXNT7ApSqUpDfqFPGM7/uSklQc27gFJD6Y
	yfvk/tclGtIKrrMi5bXpX6Z0o90D4hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762413825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7KuTnD+Lrz4fdyLGJ4uF39ab38gWiaLaVToVQMrbw5E=;
	b=B0kfOKCPU7tEewGxnfh3t5a/1LSwMFkJ2xB7BBlodeWGgw+J1Dj5HeNkwMa/qS9L6oRqlV
	QFQkN5b/C9x5+NDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B68C9139A9;
	Thu,  6 Nov 2025 07:23:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AZ9yKwFNDGk8GAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 06 Nov 2025 07:23:45 +0000
Message-ID: <2d4356a4-a0c1-423a-bd40-af1f8a28fd84@suse.cz>
Date: Thu, 6 Nov 2025 08:23:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] slab: move kfence_alloc() out of internal bulk alloc
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
 <20251105-sheaves-cleanups-v1-2-b8218e1ac7ef@suse.cz>
 <CAADnVQJY_iZ5a1_GbZ7HUot7tMwpxFyABEdrRU3tcMWPnVyGjg@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJY_iZ5a1_GbZ7HUot7tMwpxFyABEdrRU3tcMWPnVyGjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D58FAA000D
X-Stat-Signature: ohpqtp8wp836urk8imwnr5dnw7afa4ao
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762413827-609156
X-HE-Meta: U2FsdGVkX1/p2MCKs95/CESsxtEfTXFPy08InAYVMyIS2MgennDNn9L8V0vJEh+oQ69uMUSUDjSJQtiopV8x5Mt4EbfKm2l7AINVbsBXoyKbWBkCbr3XykWXmx5DFF5CjI5D8BHdq1O7xrjCTkd+vtc9FYbOBPrrczK3wLjoB7pcV/trothL3QB17QsgOujppt0cNKJcdshmHkHdDGLhk8YoFSt13O+0iy3sobi6eXOMl8SJOV7Y6SzptGqr/jZbBBQ8e2nkaoSQWLbLzPUVB0R2vIQqqJTKNysYIkL0ci+eOzrPE2qvr3obfcxrJY9jf6C3YqfDGMlyQbRvzXPl8Ie0rt2/uJECg0HVtei5Do+i9SZSX278ciRoV/zjVA/B1KZk8gsfVqJZRQbrjOTpjMsT4zjejG3oWNFtGICXse4HnVXRyV+nD6byJBKO0krqcPsWC1W8jJDcITh9jdsopemPQUN/o+0LdMFFJ69jplNcFLqr1JEfI2HTIxcQjibsZNojuMVeJgoPZEcxa2K0HpCmUUoU7lg0wtO4Nhd0lqg3mm5VtYMnJx2I0C0LZCICfOSlgU5gWFbqdlqFF+bpv4QWgZnhqTz1M1KXNxGY6QY7va1U7xoOZCTdY63WtUFEcSM9wlNsyeIAo9TeST3SQJFwPocG8k8r9hz+cGtuOJ50j6/NBHqCCVKpcquvu8SFkcNkwWDR55DSD53q8wBwplGF71GdEl/+NyRg6/GD+IUpEa1nrbwc1K8v0OdSDzvcisiDhG4jXIBYAf1612stT50dgZQAlSe3kz2Sr2VqAfByB25/JFTUagyzUfHiATUAPitqxmtr5SOmocJOrpEtlFTGMkS1pzGctk6/0NRbDJ8w1HVkW4O1hDgxq5oMoTBh6KPkqnhBCpkdVYbd9CyT3l43Bt+4KeDKtw1Z7dIW9tZM3S8gduyNZvipb37fIzNKO2CrxUcOmseTdCEgEpI
 QualRDzR
 y7y9fGHz4IS7XdLLpP5q7azYLxs7TtToZmKIIdUInGDukNdyuWtxIdde1Fmd3oFvJVAPXQ4y4kA1PD3XfVhCYYoCM5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/6/25 03:39, Alexei Starovoitov wrote:
> On Wed, Nov 5, 2025 at 1:05 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
>> allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
>> but it's conceptually the wrong layer, as KFENCE allocations should only
>> happen when objects are actually handed out from slab to its users.
>>
>> Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
>> object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
>> was refilled with KFENCE objects. Continuing like this would also
>> complicate the upcoming sheaf refill changes.
>>
>> Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
>> to the places that return slab objects to users. slab_alloc_node() is
>> already covered (see above). Add kfence_alloc() to
>> kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
>> prefilled sheafs, with a comment that the caller should not expect the
>> sheaf size to decrease after every allocation because of this
>> possibility.
>>
>> For kmem_cache_alloc_bulk() implement a different strategy to handle
>> KFENCE upfront and rely on internal batched operations afterwards.
>> Assume there will be at most once KFENCE allocation per bulk allocation
>> and then assign its index in the array of objects randomly.
>>
>> Cc: Alexander Potapenko <glider@google.com>
>> Cc: Marco Elver <elver@google.com>
>> Cc: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/slub.c | 44 ++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 36 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 074abe8e79f8..0237a329d4e5 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -5540,6 +5540,9 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>>   *
>>   * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
>>   * memcg charging is forced over limit if necessary, to avoid failure.
>> + *
>> + * It is possible that the allocation comes from kfence and then the sheaf
>> + * size is not decreased.
>>   */
>>  void *
>>  kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
>> @@ -5551,7 +5554,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
>>         if (sheaf->size == 0)
>>                 goto out;
>>
>> -       ret = sheaf->objects[--sheaf->size];
>> +       ret = kfence_alloc(s, s->object_size, gfp);
>> +
>> +       if (likely(!ret))
>> +               ret = sheaf->objects[--sheaf->size];
> 
> Judging by this direction you plan to add it to kmalloc/alloc_from_pcs too?

No, kmem_cache_alloc_from_sheaf() is a new API for use cases like maple
tree, it's different from the internal alloc_from_pcs() caching.

> If so it will break sheaves+kmalloc_nolock approach in
> your prior patch set, since kfence_alloc() is not trylock-ed.
> Or this will stay kmem_cache specific?

I rechecked the result of the full RFC and kfence_alloc() didn't appear in
kmalloc_nolock() path. I would say this patch moved it rather in the
opposite direction, away from internal layers that could end up in
kmalloc_nolock() path when kmalloc caches have sheaves.

