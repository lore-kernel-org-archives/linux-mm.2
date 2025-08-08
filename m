Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D6EC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 680FA8E0005; Fri,  8 Aug 2025 10:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6593D8E0001; Fri,  8 Aug 2025 10:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5477E8E0005; Fri,  8 Aug 2025 10:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41B3F8E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:44:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB9FE140174
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:44:36 +0000 (UTC)
X-FDA: 83753861352.14.DC213C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 557FC40007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:44:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJoEZC3q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JlVDAA6z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJoEZC3q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JlVDAA6z;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754664274; a=rsa-sha256;
	cv=none;
	b=rt6DMAamhANO41k8+yXFpIiH6YSS9F2fqBsYcCAPMuAnmc2pctswe/5ogSNlot8LtmeUwc
	M4yHbhK0AB1Ja6v8IXqcKC5MGsijlouWHEWVSeuWEyo7v0gLnBMGbturQhEWrGksrhWfwg
	UOa+6hYgqht1eVbU3NGzR/e+xDtyHHE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJoEZC3q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JlVDAA6z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CJoEZC3q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JlVDAA6z;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754664274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZLIYAAzOqJrX0ZQHrg1ntpn3pRJDufkTOr2rwbrlqU=;
	b=mVQgtxxaS/ymr9PfLuqOgWXyQjOEQcM52DV2+hemvgzDRqZNKj05I+7o24giqac9h8QXsY
	XjSNNhzIq6uMyn8pSti+z/btIr+297kgS23/gpi3mey12mPYpCmgxFI9Joz/uRB+Phae8R
	yjRXk9+mi+OI7YtKIYVdnYXWh3SfEBE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C9CEE33EAF;
	Fri,  8 Aug 2025 14:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754664272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FZLIYAAzOqJrX0ZQHrg1ntpn3pRJDufkTOr2rwbrlqU=;
	b=CJoEZC3qM4RuZsGgyHwaUQJtzxnW5RRCEZq5OHZLqtBaoBGXsr6yUMSJ6oMbpqhrC5/AcE
	5cW5vCmjSKhVjBuXTS/Q3ZEDu1olscN+QJc6t3pZDpwGyFWu8y6J88U49Mq/p+QgWfdkQ5
	hmgiRjvAU6XaZ7ZWyurfggS0FUuqiQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754664272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FZLIYAAzOqJrX0ZQHrg1ntpn3pRJDufkTOr2rwbrlqU=;
	b=JlVDAA6zzDmmC/vsVWsA2wtJ55XLTK0TEvocVucbGotZX/z6gmz/uM/kqfKtHsMR+vcUd8
	DQ4wBPnhH2YtgQDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754664272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FZLIYAAzOqJrX0ZQHrg1ntpn3pRJDufkTOr2rwbrlqU=;
	b=CJoEZC3qM4RuZsGgyHwaUQJtzxnW5RRCEZq5OHZLqtBaoBGXsr6yUMSJ6oMbpqhrC5/AcE
	5cW5vCmjSKhVjBuXTS/Q3ZEDu1olscN+QJc6t3pZDpwGyFWu8y6J88U49Mq/p+QgWfdkQ5
	hmgiRjvAU6XaZ7ZWyurfggS0FUuqiQ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754664272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FZLIYAAzOqJrX0ZQHrg1ntpn3pRJDufkTOr2rwbrlqU=;
	b=JlVDAA6zzDmmC/vsVWsA2wtJ55XLTK0TEvocVucbGotZX/z6gmz/uM/kqfKtHsMR+vcUd8
	DQ4wBPnhH2YtgQDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9E98513A7E;
	Fri,  8 Aug 2025 14:44:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0gtbJlANlmiTOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 08 Aug 2025 14:44:32 +0000
Message-ID: <c05d3ff6-d668-4317-a5ac-c8943f1bb016@suse.cz>
Date: Fri, 8 Aug 2025 16:44:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/slab: save memory by allocating slabobj_ext array
 from leftover
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, linux-mm@kvack.org
References: <20250613063336.5833-1-harry.yoo@oracle.com>
 <00e91300-c6e6-5330-f514-4628ae2ba696@gentwo.org> <aExkJhM_P8mnLC12@hyeyoo>
 <bdf0af50-2e1d-4627-9775-ae62e2dee509@suse.cz> <aJHxsvU-77D3pfhJ@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aJHxsvU-77D3pfhJ@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 557FC40007
X-Stat-Signature: cyyi48hj8bqkc51yckagziuckn8nmfr8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754664274-156525
X-HE-Meta: U2FsdGVkX18TPU7Qx7FP7ObV/dYSskZc2F2vDhyHHt3Fhlnxv3+3r+DRVqA6TAaV4BDzag0b9pdOFbD3IABxRCDU0FkbUkR+fDJwXob+Ht0ClTlQPJsU7IJjBUnjgaCXikDP6oj5a2+ez6TU3dx73yU6Tk/fZVVzepcxDG83Lq59GeL2Jx8Bv+yfv9caFCLoU8FmLU2/uliu23A4B4MTKSfv1ap15ND8zOOHAK60mKuNSCYjfSb8inAHyDyIj11JY/8W5raGBhMzY7pvi0GylXhP2hAmEZxvaK1P+AJdK5mTIK+WMdW91qfxEEUqM520MacRTXu3H1L+nixTiuqsyxD8tiZHh8R5SHiBHMhhbo9+tUb/blncYZ7TPwBx/80xI7Seu9OSeQnvqyiPHu/i4T9BuCEu7R296m4Go0q33hyqJMyuRP/VHvnxovJ86Vc1A30Xq+mTogkxAbOCCa/Z1k1ghMSgunjpsZXfUxiO4ZTPSEtR+8u1scssez5tXT+yiAfgGgpDuo0Geo8K2KMHIUE4KbMlrP5DH/MMoYnagPqqO+jg6Q23JdpGKo58CTri6NOSGyWbdfd9DIzJ/XgH8DDJ2TOPxgqwzPzKAlLVFeoFMjx83+Ea4jBftsUd2UdEoUmy82nEu9tX/bHJK2P8H9Orm3iXUCqu2D/zAIes1izycHwH0tks4s5wOQrk1izdCSqLgVhdAPhkB0Vamh6SCZ4EKAL7zAHfIfijgGcae73PHC+1c3wObNr/1l5WfrXgtZdLvAxIJRSZPRYeF7cZqasBNEY7hnvOqjtDc/eTJmSGd0WBc1ugU6otW8ceLIBusJgv/cK1GatGkUyN48klVsyD5KnlWN/7Od1z8654UZ8zTg8VbY+n6tmYHvoXz3zTZzMRf9tzj8z0YzgNT2ZV8iM2uvPcbjvhRGkRS+A5x8K5MllU/9yzJbI8X0JbZLa4wtQ3BRbBAzNN7neE/wP
 gI+gp/Xj
 BJIxaDgVErhDMlZATpjoxAVl49fCl1AENOtxJXgGuktfuXDSdeKA/uENf6DbH8BhvWo3Kj/JMvkUXy3U4/5oT5WsigpX6yw5sQBBbkdIEUhnXJIhQ/M1yk888pglvqnKBj//3ItvYUUjUJTcRdmMRtXXopJT3UZ1O08UFRMM+vK8WegWcp58343dpeEJoxYZiS/PkdZz/gIFI2a2e4+C3Txv4X8qi6+lz0O18zLSFdbhucIbrgB3zfMWy1BgRnA3o5xEE3g3gUNaLaIkw1sAZSgpUi9QY1mXS0Itf1Gb7cCinw7szjM63cqHDcjpmAtRvrj+HasQB2APPIIamhtyfYHKeBWe5/c9hHjbiWMUStpIuXBHPNaTuaBiR0T7wPJ/yw9LKZYtJ29SKvE/2XkS/WsILGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 13:57, Harry Yoo wrote:
> On Thu, Jun 19, 2025 at 09:56:59AM +0200, Vlastimil Babka wrote:
>> On 6/13/25 19:47, Harry Yoo wrote:
>> > On Fri, Jun 13, 2025 at 09:04:34AM -0700, Christoph Lameter (Ampere) wrote:
>> >> On Fri, 13 Jun 2025, Harry Yoo wrote:
>> >> 
>> >> > Allocate slabobj_exts array from this unused space instead of using
>> >> > kcalloc(), when it is large enough.
>> >> 
>> >> How does slab debug work in this case? The object layout gets a bit
>> >> complicated with other metadata there as well.
>> > 
>> > Oh, the 'leftover' space I mentioned the cover letter refers to the
>> > wasted space after the last object in a slab, not unused bytes within
>> > objects.
>> > 
>> > There is no per-object metadata stored there and SLUB simply poisons the area.
>> > I taught slab_pad_check() to skip checking the slabobj_exts array.
> 
> Apologies for the late reply. I was sidetracked with multiple things :(
> 
> This is definitely worth optimizing, so let me make some progress
> even if it's a bit slow.
> 
>> I can imagine going further with this in case where leftover space in slab
>> isn't enough.
> 
> Right.
> 
>> - indeed use per-object padding to store only single object's slabobj_ext,
> 
> I think the most conservative approach is to not increase object_size
> but use wasted area when ALIGN(size, align) is bigger than object_size.
> 
> A good candidate for that is xfs inode cache.

Yeah that's what I meant.

>> if it doesn't lead to memory waste
> 
> You mean increasing object size but without decreasing the number of
> objects per slab?

Just the ALIGN thing. It we can increase size without decreasing objects it
means we can also just use leftover space for the array, IIUC?

> ...or (maybe) reducing the number of objects but without increasing
> the size of the remainder (same as calculated in calc_slab_order())?
> 
>> - if not possible, but object size is small enough so there are many per
>> slab, maybe have one less object per slab to store the array?
> 
> If object size is small the array likely does not fit in one object...

Hmm perhaps.

>> - once we have struct slab decoupled from struct page, it could be part of
>> struct slab directly (but it would mean struct slab isn't fixed size)
> 
> It can be tried, but variable struct slab size may or may not work.
> That'll depend on the implementation details of how we allocate struct slab
> in the future.
> 
>> Of course having multiple variants would risk slower code, so fast paths
>> should not be affected 
> 
> I agree that affecting fastpath is not great.

So we'll have to measure it.

>> we could have pointer to the 0th slabobj_ext (we
>> already have) and now also stride (to support the "per-object padding case"
> 
>> - there's still space in struct slab right?)
> 
> which space are you referring to, maybe lower 16 bits of page_type?

Ugh I thought counters used only 32bit of 64... so the space exists only for
64bit kernels? It would be fine to limit the optimization to those only.

>> and then the object alloc/free
>> case could be oblivious to the storage method, with just a bit more
>> arithmetic (stride). Slab folio alloc/free would be more complicated but are
>> not fath path.
> 
> So it would be something like (please correct if I misunderstood):
> 
> index = obj_to_index(s, slab, object)
> (the struct slabobj_ext pointer for the object at given index)
>   == slab->obj_exts + stride * index

Yeah.

> 
> slab->obj_exts, stride are determined depending on the case:
> 
> - In the normal case (the array is allocated from kmalloc caches),
>   stride = sizeof(struct slabobj_ext)
>   slab->obj_exts = (the address of the buffer allocated from kmalloc)
> 
> - In "the obj_exts array is stored in the leftover space" case,
>   stride = sizeof(struct slabobj_ext)
>   slab->obj_exts = (the start address of the leftover space)
> 
> - In "per-object padding" case,
>   stride = s->size
>   slab->obj_exts = slab_address(slab) + s->red_left_pad +
>                        (offset of slabobj_ext);
> 
> Ok, I think it will work. Great idea!

Yeah.

> 
>> Also some variants would be wasteful if they need to be decided upfront (the
>> 2nd and 3rd above) and then the array is unused
> 
> Right.
> 
>> so would be only applicable
>> with SLAB_ACCOUNT caches (if kmemcg is active) or when memalloc profiling is
>> active.
> 
> Right.
> 
>> Shouldn't be a big issue as ad-hoc __GFP_ACCOUNT is handled by
>> different cache selection for kmalloc() and I don't know if anyone is
>> actually doing ad-hoc __GFP_ACCOUNT on named caches.
> 
> A while ago I was thinking of getting rid of ad-hoc __GFP_ACCOUNT usage
> for slab allocations, but at least xarray cache appears to use it in
> an ad-hoc manner. (See xas_nomem()).
> 
> In that case, not all allocations to the same cache has
> __GFP_ACCOUNT flag set.

Hmm bummer.


