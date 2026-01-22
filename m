Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F134C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F696B0105; Thu, 22 Jan 2026 03:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC426B0107; Thu, 22 Jan 2026 03:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD1C6B0108; Thu, 22 Jan 2026 03:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AABD6B0105
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:00:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3756F1AF239
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:00:56 +0000 (UTC)
X-FDA: 84358853712.08.5B03C7F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id A72EB40003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:00:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0+HG3qpa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x597raJU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0+HG3qpa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x597raJU;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769068854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4zAQ80PqnRS6Q1GrwimdsrNjkQH2WZaJ1/YF1AonT4=;
	b=cdwzOiZvl4qhUM50U295KRZJ3iXjJ0wdq93/oefUbQ8ANb61JLf72zDVAEaaXYFyrsBsvr
	yGNvmRiaAPgdhrQQFLkWX7nTMUoNbJoc9qDT4FO3x6KXIBPnNIrjidHULmgIf7BrdF/dDj
	7BHiaTIiUf8SBMmoK+RjYKyfb70sZDE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0+HG3qpa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x597raJU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0+HG3qpa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x597raJU;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769068854; a=rsa-sha256;
	cv=none;
	b=LIkgWsP5X25KHIiCpXOz2mHQWnS/LbKbwkC9zoQTFR8V4eT/SV9FA+6FL8t0a1/umGL3U1
	TT1UBcJUszsDlr+E08CLyye+vihNxDOGGPfY9/AHmOzfDjb7b3bbZJhgeEGVamA5FRiedm
	6CP6/tEgJDzOX/BlKjCPxj/aOtB2I2Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B1ACC5BCC3;
	Thu, 22 Jan 2026 08:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769068851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4zAQ80PqnRS6Q1GrwimdsrNjkQH2WZaJ1/YF1AonT4=;
	b=0+HG3qpa922ZmFTWiChvzCOHFaFbN+BSAoyy8kWnVwaxRZpTavBsrl7B8cou8DDDocqNDf
	LhFdwQbss0NIn0vQxrcCY0ShhGp0uW9ePFcooKVk/lKlyuVJud++sMRSYXH3hP3a3Meg3m
	Z9Jy/zkPvxmt0WWvbD5wFoFT1/EHVdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769068851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4zAQ80PqnRS6Q1GrwimdsrNjkQH2WZaJ1/YF1AonT4=;
	b=x597raJUv0heYD/X2hwj4Q3SukHDJZ9okwTOr/PAfj/AdF1RQdOlSAH71dz298Tg9HsuaB
	b/YNzkQVvHXxjwDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769068851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4zAQ80PqnRS6Q1GrwimdsrNjkQH2WZaJ1/YF1AonT4=;
	b=0+HG3qpa922ZmFTWiChvzCOHFaFbN+BSAoyy8kWnVwaxRZpTavBsrl7B8cou8DDDocqNDf
	LhFdwQbss0NIn0vQxrcCY0ShhGp0uW9ePFcooKVk/lKlyuVJud++sMRSYXH3hP3a3Meg3m
	Z9Jy/zkPvxmt0WWvbD5wFoFT1/EHVdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769068851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C4zAQ80PqnRS6Q1GrwimdsrNjkQH2WZaJ1/YF1AonT4=;
	b=x597raJUv0heYD/X2hwj4Q3SukHDJZ9okwTOr/PAfj/AdF1RQdOlSAH71dz298Tg9HsuaB
	b/YNzkQVvHXxjwDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 652B03EA63;
	Thu, 22 Jan 2026 08:00:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NQrwFzLZcWkDTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:00:50 +0000
Message-ID: <9077ab5b-f2c8-4c8d-8441-631e7c2cf384@suse.cz>
Date: Thu, 22 Jan 2026 09:00:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Content-Language: en-US
To: Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>, Alistair Popple <apopple@nvidia.com>,
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, adhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
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
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org
References: <eb94d115-18a6-455b-b020-f18f372e283a@nvidia.com>
 <aWsdv6dX2RgqajFQ@lstrano-desk.jf.intel.com>
 <4k72r4n5poss2glrof5fsapczkpcrnpokposeikw5wjvtodbto@wpqsxoxzpvy6>
 <20260119142019.GG1134360@nvidia.com>
 <96926697-070C-45DE-AD26-559652625859@nvidia.com>
 <20260119203551.GQ1134360@nvidia.com>
 <ef6ef1e2-25f1-4f1b-a8d4-98c0d7b4ad0c@nvidia.com>
 <EE2956E3-CCEA-4EF9-A1A4-A483245091FC@nvidia.com>
 <20260120135340.GA1134360@nvidia.com>
 <F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com>
 <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXHPkQfwhMHU/oP6@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A72EB40003
X-Stat-Signature: 3ixfcuedmbfnxmoujqscw7weyh6sy3a1
X-Rspam-User: 
X-HE-Tag: 1769068853-127804
X-HE-Meta: U2FsdGVkX1/wp+3Rg1PX/niitARhaaUCqubntmZUBjxACY8NgaJDExPd5OQpnz1dlm5VJ0vIJRblGg5XDK1xWws6QcHitKwlgkVH8NiYoJne+6SuCUStT3szZU0w5FfnYjwOBS70pas+iJAOz2GoXwSBJi2GTPphz1EXnH7fprDBdPWUaFabfqHpFKYUhQZjhUGoBcaw1oRhpdz2FYGCI5h7b6ftUr0J6F76gXGQADBlqUnaFKYhnCpxx0XcaC5OF9585Fjk8sVcSookQBAVMPborC15rDQTIxlkS1dNlhCw1pSObdS2lz1rw9oK6ZSegoBu/A1nMBgc33oQu2F9+ij0JnzcmYYyFEN/LwkJAYRZbltHn26lZVy0rh88Y5LmmEDR/nP9sqlOKq89UiZOMFOd9TpHuPeUWV/Pok69wP31H3TTvdxi8ixRYSLeqAj+Y5TGxyboX9QouI02PSOEPH8/UiZ2TbqRFQZWHJ4a9VC/Xet3botjbUCgpcxfkGAl39oj5+K2WLjUnWugARs7FUs4Awf4L5rqbFcrZ/Mu4oTYp+aT8YPUshRkv03TK+gq4Y/hvf4llmZiFLQ3/v3MDtqyqVhrb95xfJbox+9BaIvBuMY/u6HZOxkcMGZfbkKifnnaDiUMiJ9JRdTJRCEf+sA9UKwYJDoqgRdgLpql2GNOSWPny1+iWTkJidNqRXk7j2g9u6UJFzBLmZ9L6KXOR6lUvsTtYvoCyJzXhl3FdzpPHYZ4rkZvAUfNhvU8XlD3Ho+TrI9qBMHcFNCcJMQKdrPFQjPqT2L+TO0QSjKeRoBjemLwWDLndAvBBRJc8zH2sfhrngX1SPbv7pUQO1vgolsbtbX3c8U4KawWSwKDTnxVc3vyqQwJBWTEKC3vtYyQA6/8GclvAkNzNh0r1lp96oUaRErjX9DMMrYRcfJUXRmqFpHf/rBQkAi+gFcrj95kcBOtnTKLWeUjnY4xlZQ
 ha9+si79
 Lx5xupgGA+vBA7bss+d7ZJgiDf+DyRZJUs0m7KYBa0myPcKBLcS6Z5Mcat6vF4rmDzsqLgtjmreMRquD36OM0OY2yoEPHWuVhzoat5J1z4DzXgMCZSrV7LArz/x45tG7mHZLOsQcgMVI3U8iXClINS04ByjUJka+x3k5QGJwrhALtR7TrnMA+j3m51anuwE+/W2WUJysBJ+LgcLs8oZVvwV0Ak+Obwq0miBudOUa020jh7B9yOISQ+xoUikwK3NNXRZ72NWL/uX7I8vmrQxFaPbueI4nMuy/BXI0m64NXjcnyFZOp/B5cmpBdHEK/rUYQA8vHWn41zPOmE/vTMkbSNr8D+LdB80CR8esrE46cXi2L1FA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 08:19, Matthew Brost wrote:
> On Tue, Jan 20, 2026 at 10:01:18PM -0500, Zi Yan wrote:
>> On 20 Jan 2026, at 8:53, Jason Gunthorpe wrote:
>> 
> 
> This whole thread makes my head hurt, as does core MM.
> 
> IMO the TL;DR is:
> 
> - Why is Intel the only one proving this stuff works? We can debate all
>   day about what should or should not work — but someone else needs to
>   actually prove it.i, rather than type hypotheticals.
> 
> - Intel has demonstrated that this works and is still getting blocked.
> 
> - This entire thread is about a fixes patch for large device pages.
>   Changing prep_compound_page is completely out of scope for a fixes
>   patch, and honestly so is most of the rest of what’s being proposed.

FWIW I'm ok if this lands as a fix patch, and perceived the discussion to be
about how refactor things more properly afterwards, going forward.

> - At a minimum, you must clear every page’s flags in the loop. So why not
>   conservatively clear anything else a folio might have set before calling
>   an existing core-MM function, ensuring the pages are in a known state?
>   This is a fixes patch.
> 
> - Given the current state of the discussion, I don’t think large device
>   pages should be in 6.19. And if so, why didn’t the entire device pages
>   series receive this level of scrutiny earlier? It’s my mistake for not
>   saying “no” until the reallocation at different sizes issue was resolved.
> 
> @Andrew. - I'd revert large device pages in 6.19 as it doesn't work and
> we seemly cannot close on this.
> 
> Matt
> 
>> > On Mon, Jan 19, 2026 at 09:50:16PM -0500, Zi Yan wrote:
>> >>>> I suppose we want some prep_single_page(page) and some reorg to share
>> >>>> code with the other prep function.
>> >>
>> >> This is just an unnecessary need due to lack of knowledge of/do not want
>> >> to investigate core MM page and folio initialization code.
>> >
>> > It will be better to keep this related code together, not spread all
>> > around.
>> 
>> Or clarify what code is for preparing pages, which would go away at memdesc
>> time, and what code is for preparing folios, which would stay.
>> 
>> >
>> >>>> I don't think so. It should do the above job efficiently and iterate
>> >>>> over the page list exactly once.
>> >>
>> >> folio initialization should not iterate over any page list, since folio is
>> >> supposed to be treated as a whole instead of individual pages.
>> >
>> > The tail pages need to have the right data in them or compound_head
>> > won't work.
>> 
>> That is done by set_compound_head() in prep_compound_tail().
>> prep_compound_page() take cares of it. As long as it is called, even if
>> the pages in that compound page have random states before, the compound
>> page should function correctly afterwards.
>> 
>> >
>> >> folio->mapping = NULL;
>> >> folio->memcg_data = 0;
>> >> folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>> >>
>> >> should be enough.
>> >
>> > This seems believable to me for setting up an order 0 page.
>> 
>> It works for any folio, regardless of its order. fields used in second
>> or third subpages are all taken care of by prep_compound_page().
>> 
>> >
>> >> if (order)
>> >> 	folio_set_large_rmappable(folio);
>> >
>> > That one is in zone_device_folio_init()
>> 
>> Yes. And the code location looks right to me.
>> 
>> >
>> > And maybe the naming has got really confused if we have both functions
>> > now :\
>> 
>> Yes. One of the issues is that device private code used to only handles
>> order-0 pages and was converted to use high order folio directly without
>> using high order page (namely compound page) as an intermediate step.
>> This two-step-in-one caused confusion. But the key thing to avoid the
>> confusion is that to form a high order folio, a list of contiguous pages
>> would become a compound page by calling prep_compound_page(), then
>> the compound page becomes a folio by calling folio_set_large_rmappable().
>> 
>> BTW, the code in prep_compound_head() after folio_set_order(folio, order)
>> should belong to folio_set_large_rmappable() and they are causing confusion,
>> since they are only applicable to rmappable large folios. I am going to
>> send a patch to fix it.
>> 
>> 
>> Best Regards,
>> Yan, Zi


