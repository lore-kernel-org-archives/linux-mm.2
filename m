Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DEACD6E55
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FD68E000A; Thu, 13 Nov 2025 08:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16978E0002; Thu, 13 Nov 2025 08:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFC58E000A; Thu, 13 Nov 2025 08:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADB08E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:48:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27ED41A0954
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:48:11 +0000 (UTC)
X-FDA: 84105712782.06.A589B7E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 938CC160006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:48:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EZzu4l+U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=roeUSB9w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EZzu4l+U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=roeUSB9w;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763041689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFAGU4XxhhELslwlDz67aEXHbA7WKGtlGK0QybdrGNE=;
	b=q7qa21O0G1D/JJjHDMVyhluiPqHGs6rGqU1Ne6gBp5/7zVfXjVZunW5H58WgdrhLnmBH41
	JypsXvwUN1z+ivN58fc1lDKkEgMaEcMQknr+OVF8LHRFeSzUXfEIhp34gdr1qMbzbXWz7D
	pbs++D02JxMErfrwrhT5vqBW8CGHVwA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EZzu4l+U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=roeUSB9w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EZzu4l+U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=roeUSB9w;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763041689; a=rsa-sha256;
	cv=none;
	b=t65HechybmyD/v4uzRuQ2UoB6u5uxTFF8/ZWzUqCD+in7s5zPGzJHu37xvaI3FKX/BTfQ0
	Di0qIIA4v38/FCXk8618kzEef7oiAo4cE8hZc2rT3DOZoJQxvJlzhdttPCp7ICSTj96XpY
	VSbU2GMgwxGbiFOD4en57qyalClz1NE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 82E54216EE;
	Thu, 13 Nov 2025 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763041686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mFAGU4XxhhELslwlDz67aEXHbA7WKGtlGK0QybdrGNE=;
	b=EZzu4l+UCK+XZUrSKIG+VtcI9P+R2W8BPUvGlGGho/8pUbD8WyfImBEM0nMebZFzxYDHbe
	uRYHhZ3zTvowBmgVorucv9275w2NGIJgJ/71PKWfWIa8p0GmPEEB/4g5V95xsuu0oga8GI
	u3ig7gT5/FvENJQ6WMsqn5H0hyft2Uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763041686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mFAGU4XxhhELslwlDz67aEXHbA7WKGtlGK0QybdrGNE=;
	b=roeUSB9wdsPt9YbUAWGEuUvyhnnja24H3lIUYW+LUn95KayXevOtek2Xe40O/LI9dGUD3C
	z1NJC2Fx5EqCUuBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763041686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mFAGU4XxhhELslwlDz67aEXHbA7WKGtlGK0QybdrGNE=;
	b=EZzu4l+UCK+XZUrSKIG+VtcI9P+R2W8BPUvGlGGho/8pUbD8WyfImBEM0nMebZFzxYDHbe
	uRYHhZ3zTvowBmgVorucv9275w2NGIJgJ/71PKWfWIa8p0GmPEEB/4g5V95xsuu0oga8GI
	u3ig7gT5/FvENJQ6WMsqn5H0hyft2Uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763041686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mFAGU4XxhhELslwlDz67aEXHbA7WKGtlGK0QybdrGNE=;
	b=roeUSB9wdsPt9YbUAWGEuUvyhnnja24H3lIUYW+LUn95KayXevOtek2Xe40O/LI9dGUD3C
	z1NJC2Fx5EqCUuBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63E2C3EA61;
	Thu, 13 Nov 2025 13:48:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XDgMGJbhFWlyeQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 13:48:06 +0000
Message-ID: <e88f9909-cb5e-4205-b4cb-461fdd71120a@suse.cz>
Date: Thu, 13 Nov 2025 14:48:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: poison_element vs highmem, was Re: [linux-next:master] [block]
 ec7f31b2a2: BUG:unable_to_handle_page_fault_for_address
Content-Language: en-US
To: Oliver Sang <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, oe-lkp@lists.linux.dev, lkp@intel.com,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Johannes Thumshirn
 <johannes.thumshirn@wdc.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <202511111411.9ebfa1ba-lkp@intel.com>
 <20251111074828.GA6596@lst.de> <a90b1707-b97a-454c-bced-a25068b28325@suse.cz>
 <aRWMT6DTNhAdudn+@xsang-OptiPlex-9020>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aRWMT6DTNhAdudn+@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 938CC160006
X-Stat-Signature: 8ncfkidfg8d39mx54ugywxqm8aub4epx
X-Rspam-User: 
X-HE-Tag: 1763041688-64173
X-HE-Meta: U2FsdGVkX1/sHs7s9SY1/FizxCGYREjPLNru2Oxq4EQ7ICaf/TDW3Fq3I0zRma9ca6gaYmKMo/u6901zkpOn41WpC0L+Qt9UDI/wDfzvagJ263kACbrnx7c4XtY3joyNkhVpxt1N3coe7aUqzBd+p3q14k5nNAUtnp2Wc7Vhqubi5Dqeb5hrzbKFoOb19P9kI7TsRGEG1Aor8Y8A2W6KOYGMMVopiAo2AiAIISinVeoNX5O6/jwpw6s2WJucgtcZC+lBk2/tdN0CYIJRWU9M+R8mTg9ygrqEX6fQCzbIvdulxPgoUj4c4PsBIedGHb/PYVUy54UHcKryZjcmZSeeY6yRuT7QGqD+AXxyN3dJdkemtBwFaqVaCDO3y+F95YZoDF0qs1/UJkvI34xDPE/kUVW7Orm0LGMgM/xhpT6wZGf2zRYYL9pCmrMdgsJutGG4mM3kmb7xf90hSGCSazdXNxDlzAcSrqAe5mHJFCA/KQz43HwDExpGCFH5yr9A+h+RBsm8XH3mmjCnloxNc4nPA77ND3jvDPjiSoHVTJR4riJEoWIRx28fNvA46XvY/PvDNgDGvgY9tXnFzWCwZ/OC6HTt22C6Y+qzEnymP+xmLCAH9CburlGfE3hy57J+/o6ipmUGWv5dLQ0/tmIXJUnRRBkck568/9T5WvwbTp9nbuleLKcLDCTOADqbcOyckD2j8Cmu3lBwhBc7zAA1HqgyPeGF0JtINuoBtdAqlenwplho0GFdA0s7k8wejSkHqPD70SGYHs1Qmt0sMkQSK78gu4++iuvx+51Ubq3osQkVuDYV4ZEiC52UGPWEFI2uDBITCrBFZ40wbjJJL6rYseUnnO8FUFbn528nxOadLhiCN+EiGSBMX1GUkWBh14P1BGTa6Ndmf4ewBzb5fqHaGtzGQmOP5y4s93xFJz9I8JkjN5cX+Bwf+xReZl2W5GXY0Wfy8gPqT4hi/hXBuB1/mWX
 WLh7wDYU
 Wx/4EdyVtbZ5a+PJfXbRX8oUmbgjxoRHg7AVFX3oQFOiTRw992RmYwcihsWngw4cmtfTBzxM1qPmw34dZSK15q2Qsh0ryltfyLjjbufECoNOuFCZXYw0Vr5kcYakG1a9/oeh9lpWi9cDZkH71nfIx9Q0J5bpQgngODlWRrqJNut07DPKtFhCAo0E7JON1hZBKm0JOgf+kx8NFNgFUlI+mjq0/lkDwmbToeFLmYaLCqQ2aFM3PzJz/0gnntVXjBOaRHHUYRcw2LJOy9gT0h8ZiEy5iv3ds209XJHW1BxwmVYGpcDlYNoqVjYVzVvVoZ6PZGeKmTw+5O6a0L+t/tYqJ9JNQR+fL0CPtxbaYYUNA07FmjydywhGFsk4HfPaQ7nMNfKTB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 08:44, Oliver Sang wrote:
> hi, Vlastimil Babka,
> 
> On Wed, Nov 12, 2025 at 10:33:32AM +0100, Vlastimil Babka wrote:
>> On 11/11/25 08:48, Christoph Hellwig wrote:
>> > Looks like this is due to the code in poison_element, which tries
>> > to memset more than PAGE_SIZE for a single page.  This probably
>> > implies we are the first users of the mempool page helpers for order > 0,
>> > or at least the first one tested by anyone on 32-bit with highmem :)
>> > 
>> > That code seems to come from
>> > 
>> > commit bdfedb76f4f5aa5e37380e3b71adee4a39f30fc6
>> > Author: David Rientjes <rientjes@google.com>
>> > Date:   Wed Apr 15 16:14:17 2015 -0700
>> > 
>> >     mm, mempool: poison elements backed by slab allocator
>> > 
>> > originally.  The easiest fix would be to just skip poisoning for this
>> > case, although that would reduce the usefulness of the poisoning.
>> 
>> #syz test
> 
> we applied below patch upon ec7f31b2a2 directly, and confirmed the issue we
> reported gone now with the patch.
> 
> Tested-by: kernel test robot <oliver.sang@intel.com>

Thanks!

> BTW, we are kernel test robot, not the syzbot :) thanks

Yeah I realized only after sending...

I'll make this a full patch then. How urgent is it, Christoph? I suppose
this is related to the bulk mempool changes, and we discussed the users will
target 6.20 (7.0?) merge window? So landing this fix in 6.19 is enough?

>> ----8<----
>> From 4d97b55c208c611cb01062e0fbf9dbda9f5617d5 Mon Sep 17 00:00:00 2001
>> From: Vlastimil Babka <vbabka@suse.cz>
>> Date: Wed, 12 Nov 2025 10:29:52 +0100
>> Subject: [PATCH] mm/mempool: fix poisoning order>0 pages with HIGHMEM
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/mempool.c | 28 ++++++++++++++++++++++------
>>  1 file changed, 22 insertions(+), 6 deletions(-)
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index 1c38e873e546..75fea9441b93 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -68,10 +68,18 @@ static void check_element(mempool_t *pool, void *element)
>>  	} else if (pool->free == mempool_free_pages) {
>>  		/* Mempools backed by page allocator */
>>  		int order = (int)(long)pool->pool_data;
>> -		void *addr = kmap_local_page((struct page *)element);
>> +#ifdef CONFIG_HIGHMEM
>> +		for (int i = 0; i < (1 << order); i++) {
>> +			struct page *page = (struct page *)element;
>> +			void *addr = kmap_local_page(page + i);
>> 
>> -		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
>> -		kunmap_local(addr);
>> +			__check_element(pool, addr, PAGE_SIZE);
>> +			kunmap_local(addr);
>> +		}
>> +#else
>> +		void *addr = page_address((struct page *)element);
>> +		__check_element(pool, addr, PAGE_SIZE << order);
>> +#endif
>>  	}
>>  }
>> 
>> @@ -97,10 +105,18 @@ static void poison_element(mempool_t *pool, void *element)
>>  	} else if (pool->alloc == mempool_alloc_pages) {
>>  		/* Mempools backed by page allocator */
>>  		int order = (int)(long)pool->pool_data;
>> -		void *addr = kmap_local_page((struct page *)element);
>> +#ifdef CONFIG_HIGHMEM
>> +		for (int i = 0; i < (1 << order); i++) {
>> +			struct page *page = (struct page *)element;
>> +			void *addr = kmap_local_page(page + i);
>> 
>> -		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
>> -		kunmap_local(addr);
>> +			__poison_element(addr, PAGE_SIZE);
>> +			kunmap_local(addr);
>> +		}
>> +#else
>> +		void *addr = page_address((struct page *)element);
>> +		__poison_element(addr, PAGE_SIZE << order);
>> +#endif
>>  	}
>>  }
>>  #else /* CONFIG_SLUB_DEBUG_ON */
>> -- 
>> 2.51.1
>> 
>> 


