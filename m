Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52C49C982F2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 19:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA4B6B0005; Fri, 16 Jan 2026 14:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067C76B0088; Fri, 16 Jan 2026 14:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81EE6B0089; Fri, 16 Jan 2026 14:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D501B6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:17:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79509577E1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:17:29 +0000 (UTC)
X-FDA: 84338785818.26.40F925C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEBAA140007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:17:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mo+68MVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Oj286jig;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rTK0cGo1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fZ6A3sjl;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768591047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bisbCLm02jmO7kyrUXkvEcJg6kYp00MTdd1BdKawzFo=;
	b=5ZJXLj6ii7I5bMjIluiDNM8Oa95SUXOPKY1puWKjIhwNpJ7qp6BRonpzMQe2Ggmzs/kN3x
	BYVp6S4kQ91jXQCuJ1V/ojy5FsuLu0whTQTsLevigz1XVasYqacotK01CrL260ueYGZyrv
	gnyKSkEys8trcCfIcMRHhm0jHxfWLDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768591047; a=rsa-sha256;
	cv=none;
	b=bdli4PlzE5qKS3CCWzER3wriVIxP2xoOd9+wmf0Gcfog5cbTAKfJe8OXQy/xfG24rnNLJq
	uvCc5K109eWcbg39RXtlHlvizqnE0GycO3KAczxAp956h2PaGojX+ZHtMv4Ic+Ep7HMQn4
	SBojCjBlkz843sUDERcRsHLnGzrxlE0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mo+68MVr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Oj286jig;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rTK0cGo1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fZ6A3sjl;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8084C33699;
	Fri, 16 Jan 2026 19:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768591044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bisbCLm02jmO7kyrUXkvEcJg6kYp00MTdd1BdKawzFo=;
	b=Mo+68MVrcphyHUMmUlW76Ea+IsmX87ibhv7WIG7yqlPQbMBV6bacUF1uDNdefDYPXE5LtZ
	NWFrlDlvXLchecXoIBohgRX0CtpRYvHwENNvD/NQ5JLxx+H89GoDT9MJHrJHbp75Kwv7yV
	s8DTUjmNPC47SAG3Go3HG11sGVtN+p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768591044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bisbCLm02jmO7kyrUXkvEcJg6kYp00MTdd1BdKawzFo=;
	b=Oj286jigOR0MEqC+M/Sg6/yRSSNYgmTKItEDIVykS1qj8qDWAvzuxdd2jgg22+SAUnUt+F
	xVlgq40gtnt/FgAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768591043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bisbCLm02jmO7kyrUXkvEcJg6kYp00MTdd1BdKawzFo=;
	b=rTK0cGo13Lnb3UHlVksaG/Tvwtp5cVmYRGk3/NxeEipVJk2HKo4DGENgtF6P4ohfHFgl24
	nYqzuIJ3uepxhLKDkkgtMRvMC0YHa9qtv+6mlENtQODsN5FnNoA91JEZNKv33hagRw9MwM
	8hIdlBl7xl4h98om58DpHaZA/tSZsAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768591043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bisbCLm02jmO7kyrUXkvEcJg6kYp00MTdd1BdKawzFo=;
	b=fZ6A3sjlOuoCcXiAId99hN+SdJvIBtJ9iF/7w7p/MGNiuyOUn2LXgyzUpzyrH/OhgGVRSa
	Y4+YVjsFVyGZfZAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 334C03EA63;
	Fri, 16 Jan 2026 19:17:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cWpiCsOOamnQBgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 19:17:23 +0000
Message-ID: <8006ea5f-8845-436a-a2d7-125399428762@suse.cz>
Date: Fri, 16 Jan 2026 20:17:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>,
 Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>,
 adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin
 <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Felix Kuehling <Felix.Kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Leon Romanovsky
 <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Balbir Singh <balbirs@nvidia.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <20260116174947.GA1134434@nvidia.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260116174947.GA1134434@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEBAA140007
X-Rspam-User: 
X-Stat-Signature: k84xftytosbi3jruddeqtcdogefgp5zn
X-HE-Tag: 1768591046-166116
X-HE-Meta: U2FsdGVkX1+tSTeExIgJIa6I9vBCG3lvdXIKzCKJEJze+JUWAl/H0B0WNofKrxHIIZhznTyZ3+ix7fhshKT2EkUbRB+B4XR0wox3aTte5BHl9BQxtAFN2ouAN8jjdFG/Xbj7HuLGYnzdFDCiyv2REqAY/MkrUJp65v1NcSKG6yhM61PeTauYbzPxoc4JOkLT3+jYmzVPW/Awi85r7UybJz0O85ZcC7QNBfLFtAm/XmOhCJekRxNif+BpjiRbzQimqewYiHcSIff//o06WxdADpD4zsb35BlFYmpkkoNTIM4V7rjByvLDWnFXeotDICRLn2OMqHioKER6rzmJwgFWibDuotaur5tLGM93sghzIzOp8o2eqfATvL7Y09VMIfE64EPBT2Ma53R83NhYkggJAWmR6rU7h2pKPHSKD6+l0731nHXfXlZXmL342qjtLqZlC3cdnXRolsYVGo2VXwLF5IxsJykL/TdpT/TE1D+nCvqR5jLXdqljbRpQOa6fwbvkOXYPZDITIgF1KP/Q45czsBCSS99o0RtIDzvlHIcKdrWZ0h9NkP5/CB4qXcnKprx9uaw/Rz1sgytGZ7Uy15ode+h/J7dr/Qgv5OlX5Co45bXkYC64g0rIoZnvmA0zDjSvdMgNJpjZG2WxH3svEOrWmSTYXu9SON7FzaeAJuQc995pmrChsah+uQUJXUPZJkLIFJk09rZM5KZ/Zmre7nXI/ZDOzl7VPfWcP8RAE6sE9xeJY6uUM4Kr1UyiYrETd+1XISUsPbrG+r6OM7K5nzcKQnX8RZBEFfEHigKToatHZj1s3NBi/P9rkRqzDxcl7F0dPe/9csE/mdPy4s39L5HjTb3haGNQF6tIF//N9152U0NvXHQMGS85N1DAxKgYfseQ7yw+5ESJ65QLVzxPzF2na+0hptO/8T7pbYx2iOm1q5yLVoFS7uo2IJS1LucKyIuUa4eTGOZtvfOqz4m2hP/
 yE9vFt6v
 iVAZmytmty2d6/AnQfY3hnAvqwHS3J0HFkoAsxMiUYv7XBn+guil7e9gQzKd8jqDhpYRnf7P9pZjHH09KqX6tYELpdYi0sd84HCvqswKrG3dwpoGfiPJRaXZxt0sLiSbdbmtAP4fqpxuDgvKvxj3DdwEUI5CpwURObVfpAbJdZyr3vAXTHIHNzPFeQCN9s4dTHMWXEZpiMmNSONCE4H3fz0vHH53+Xy0h23F61qlY8ZeosmFVxHPuz9Hs3zrS3/8THB/xsq+xVZRLKy66UzT1Efx1Vkykt7dzZuOXBEAzgMzOxAXwRmzmNm2ZGXpytDDMogV8guVR9rCraiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 18:49, Jason Gunthorpe wrote:
> On Fri, Jan 16, 2026 at 12:10:16PM +0100, Francois Dugast wrote:
>> -void zone_device_page_init(struct page *page, unsigned int order)
>> +void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
>> +			   unsigned int order)
>>  {
>> +	struct page *new_page = page;
>> +	unsigned int i;
>> +
>>  	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>  
>> +	for (i = 0; i < (1UL << order); ++i, ++new_page) {
>> +		struct folio *new_folio = (struct folio *)new_page;
>> +
>> +		/*
>> +		 * new_page could have been part of previous higher order folio
>> +		 * which encodes the order, in page + 1, in the flags bits. We
>> +		 * blindly clear bits which could have set my order field here,
>> +		 * including page head.
>> +		 */
>> +		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
>> +
>> +#ifdef NR_PAGES_IN_LARGE_FOLIO
>> +		/*
>> +		 * This pointer math looks odd, but new_page could have been
>> +		 * part of a previous higher order folio, which sets _nr_pages
>> +		 * in page + 1 (new_page). Therefore, we use pointer casting to
>> +		 * correctly locate the _nr_pages bits within new_page which
>> +		 * could have modified by previous higher order folio.
>> +		 */
>> +		((struct folio *)(new_page - 1))->_nr_pages = 0;
>> +#endif
> 
> This seems too weird, why is it in the loop?  There is only one
> _nr_pages per folio.

I suppose we could be getting say an order-9 folio that was previously used
as two order-8 folios? And each of them had their _nr_pages in their head
and we can't know that at this point so we have to reset everything?

AFAIU this would not be a problem if the clearing of the previous state was
done upon freeing, as e.g. v4 did, but I think you also argued it meant
processing the pages when freeing and then again at reallocation, so it's
now like this instead?

Or maybe you mean that stray _nr_pages in some tail page from previous
lifetimes can't affect the current lifetime in a wrong way for something
looking at said page? I don't know immediately.

> This is mostly zeroing some memory in the tail pages? Why?
> 
> Why can't this use the normal helpers, like memmap_init_compound()?
> 
>  struct folio *new_folio = page
> 
>  /* First 4 tail pages are part of struct folio */
>  for (i = 4; i < (1UL << order); i++) {
>      prep_compound_tail(..)
>  }
> 
>  prep_comound_head(page, order)
>  new_folio->_nr_pages = 0
> 
> ??
> 
> Jason


