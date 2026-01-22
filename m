Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6654C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F0D6B0107; Thu, 22 Jan 2026 03:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546AB6B0109; Thu, 22 Jan 2026 03:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ECC6B010A; Thu, 22 Jan 2026 03:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30A216B0107
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:02:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0BB3139079
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:15 +0000 (UTC)
X-FDA: 84358857030.17.1CBAC8E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D871180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WY6CuQqZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dt25Voui;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GOIk/QeC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xARCrcPr;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769068933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMCr0iZ9/F3mbXgNWYLpd1cRazBq6RbfB0STRSxkwwI=;
	b=jrlMnKOLgu7NZuTQCrfCQUAY8ci68gflNlK1Y5j+EoqYoCSFOljv2gN6HQNvIlvmaZOQzm
	9syG9DTDk5t7ldgWIMdTMBEriJV/CkTZ2xaF7W6lcoZf/0L0UPzXvo0f0CpN+Bq3HBFjdO
	CFGCMUERDYVRec1qsF/gCbeOscxUoX4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WY6CuQqZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dt25Voui;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GOIk/QeC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xARCrcPr;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769068933; a=rsa-sha256;
	cv=none;
	b=Uv4Q+cgH3C1wCVskRQdx+TA8Jj4E5CCRDUVM4D3ZwVgUFdSi14XNMrzGvwxK08TJ6SzQH5
	DCE3F50sSfjXaOe2x1iFh4NefYBzuO4kIn5OSvri5c//BPXzYIi18ujv/KUAyp1jOFpK/N
	H+ZtCIrqR88EAWXCWB6zlO5NAEKp3aA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 99CA45BCC2;
	Thu, 22 Jan 2026 08:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769068931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BMCr0iZ9/F3mbXgNWYLpd1cRazBq6RbfB0STRSxkwwI=;
	b=WY6CuQqZ5tA0cejnAXKMLHzYHPZOVQWXc98woGl9RkMWMVSQ+fjFeFt8mYrBrhdmK0q92G
	y80uBbTuWP7D3hf+Cey/fedrvHt2WRC8+yjhONrvFG7QG7qIXMoX96r6mMM4d2NhwOrvpT
	DDes6Ccn5XmTEA2mmn8u99BAhSz1Mq8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769068931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BMCr0iZ9/F3mbXgNWYLpd1cRazBq6RbfB0STRSxkwwI=;
	b=dt25VouiAL5Uo3mlTwcLwxX76wb/VevgRzYU0PCnczsVi2Ff5XEf3auw7MH5AME422rsvc
	OfYbGLc8NwxjqiAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769068930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BMCr0iZ9/F3mbXgNWYLpd1cRazBq6RbfB0STRSxkwwI=;
	b=GOIk/QeCW54ajuj57g/uvfIbip7/Ti5UKaZ5kznY6hpuPnYXbAO4fCTpdIWvJ7nres4yJJ
	NEo2Zc3AVLptnzvCHOQ7QJp3xLVGjOR+BMDDrKg5kdYYM5r9N+Mu6n4OXuqTRCbTDseRYA
	NnbPq1DCo+cePiYKBXcWRr4A3qoj8cY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769068930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BMCr0iZ9/F3mbXgNWYLpd1cRazBq6RbfB0STRSxkwwI=;
	b=xARCrcPr72qH8NKGDMK0rr8WxgM6WxFzx+SdBIWMI1TvNxQnmqVJbYVS75PEmvT6Ljnjnn
	Rwx3FItxbs1CvhAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41FA83EA65;
	Thu, 22 Jan 2026 08:02:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j+18DoLZcWncTAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:02:10 +0000
Message-ID: <a68d2e39-3041-4487-97a6-19ed7c3d332a@suse.cz>
Date: Thu, 22 Jan 2026 09:02:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, Matthew Brost <matthew.brost@intel.com>,
 Zi Yan <ziy@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
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
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Balbir Singh <balbirs@nvidia.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org
References: <20260116111325.1736137-1-francois.dugast@intel.com>
 <20260116111325.1736137-2-francois.dugast@intel.com>
 <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <ed6ca250-67ee-4f7a-bc3b-66169494549a@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D871180002
X-Stat-Signature: cgpu99isumymsjpho4nnr6wdr9k1scj3
X-Rspam-User: 
X-HE-Tag: 1769068933-130546
X-HE-Meta: U2FsdGVkX1+b4efShTQuB0GF1NVdtWxA2y1zsTv7onZvBZHGJLwLDMkuyo0B4fpmet3RXLIyNWhw8GrzXAkss2kvT2OFEy/dpRfel93J8MyxXfEUlqvh32Dm4W7UzpXWpwAtr7Rw9dFJ1tkgQpmtno8/kN5iAHgAb976rzlGMVq+U+8tlxddLfddYMQTfVpBl8JyizMVX9nZPklf1LyQL6SoG0Ob+2eTQaJougw0U6/yd3rw5gXJnPgKrx0ApdaV9xWx9SDlRKPOzGJTJ3xVYsQmAwhO832H9sfXkZusu8J8RdXGFP1e2QIvOsReV9M+iD42FYcvMSGZd4M/CbYKuOrpXb/BAqYge2cdX1JmnSK5doKhSFED7+tcFI8jB79j//EZdgcQ+Xh5zyLwAYeiJxzfWnqSbMAgZXzBP8D+trSr7s24wVp3xxyFlUJWF2eb9u2GDMbdMZgqvqaHS5XLZ9LPAGUwIoItd7YFM+NdHvDumcRKOhYcQzKQtyHZ4hg7xvChpPiUtKGbFFSzVKnFIzlyjGte1m7A2tzoEsgjvuuQSWPvI2hxHNy4gU1wD6K4balYXVbjC1hL/SYQEzjFV2SgyMSBhWL8kIqEUqmMkEPfUeNzQhOSWIjzITOTIG2ssA0gMlSgxSDAfdu8i/EnyGcGBmfl7Qst/l5gF9aoNHm3gToNoIpmm4s9PV/s7oTF6YpfDU4djcFJwFfsPSZ1da40ZCUa5j6eqsUA+EXtY7VgmyNGBF0LPDFvbxfqbYs/LKjIe5TJG2JKa3p36tpyNThK9fCxzcK723mPfgE+r7+KvMjHxaQQunFxbhI/v7OlH0XNPzClCv7ZTT3nmHvoi3bXzKUjssQuiZwx5aSFWFW+XOrZo9lIhv5vqOj7DOnvLP3xFxkpNIl2TDXC1AxN54YJONTfRfcbzjTeqHxfIAmzsL8AF4TOU2CEGBUxNMkLrTQAo2dzmz/9xCBfxQG
 frC7lECY
 JMLjRiDyi67ZR6f6YJy+W54pWoe8fXublyudMwMLVhyEbiThHZ5+weAzVMneW7U4798KZyLvZPpRHxTZsD93UQLxUQY9I0cvn1X37NSz3Njzg9POLEIwncbEaKZfmlhV4vAfu6Vm0zBUNoTVMEfPicSmC2H7w/uKA6SkihBcO0SSkQutZ2RJjRuveAaht+tSQ5O3TuLzms7zWjgqvtKkvgLa8R9NrifmI8IeY9h14qdzNXyZN5M3rxZXB0fPhLnThtRRCZ+FqTYdbfIvJXuLYfzRfmTtDvGx+gbOY73aOGTUlTKYgHXclT7wC261A4Aur1WafetBFe6VzU0DZ8SXP7ZkEHuXZtQnYuCZ5pIPuGynYwsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 17:07, Vlastimil Babka wrote:
> On 1/16/26 12:10, Francois Dugast wrote:
>> From: Matthew Brost <matthew.brost@intel.com>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index 63c6ab4fdf08..ac7be07e3361 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio *folio)
>>  	}
>>  }
>>  
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
>> +
>> +		new_folio->mapping = NULL;
>> +		new_folio->pgmap = pgmap;	/* Also clear compound head */
>> +		new_folio->share = 0;   /* fsdax only, unused for device private */
>> +		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
>> +		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
>> +	}
>> +
>>  	/*
>>  	 * Drivers shouldn't be allocating pages after calling
>>  	 * memunmap_pages().
> 
> Can't say I'm a fan of this. It probably works now (so I'm not nacking) but
> seems rather fragile. It seems likely to me somebody will try to change some
> implementation detail in the page allocator and not notice it breaks this,
> for example. I hope we can eventually get to something more robust.

For doing this as a hotfix for 6.19, assuming we'll refactor later:

Acked-by: Vlastimil Babka <vbabka@suse.cz>

