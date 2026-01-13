Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98826D2D103
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 13:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C346B0089; Tue, 13 Jan 2026 08:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06AA26B008A; Tue, 13 Jan 2026 08:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBD16B008C; Tue, 13 Jan 2026 08:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC40D6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:42:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 971ED16013C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:42:20 +0000 (UTC)
X-FDA: 84327054840.14.8C137F2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B0DC4000A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:42:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nGoKTJWe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E2Mp9Ca3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nGoKTJWe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E2Mp9Ca3;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768311738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TzvRGR1KE9XUBBxJVkEgxb8mxuBXEejZtD+0orpA3o=;
	b=QibY/8tZg0EuTrCoB1s0q5gLv8ePm8+aM2bwqFXc5wVuPsyW+UNpvdvUfw2x6aU3a4MMxC
	/ie8Fa3/eNlj5RpMp0rdL8GF8Qx1jGw1FWOd9Q5NerJTQ3Ks9pMbo9CN2OFjpYUkZ7EwlQ
	KQCTfrdLGkM6qPFmF7FDKVd0s7stD+A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nGoKTJWe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E2Mp9Ca3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nGoKTJWe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E2Mp9Ca3;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768311738; a=rsa-sha256;
	cv=none;
	b=dNMNHFF5N4kpnVZy0GDADtg/2VMs6j+jwelK37i5bHhjLs/Y+kLcc0h+tTKhVDRZwJn3ud
	gL+XFbOy6Q3eLQHEmAXNpP5B5niFx/OA34/iO72GbbrhRlwWcyaZwPNKqvzOLFAaYMHfdJ
	u5azluvgRJBM6ihh1vNc4GeFrf/Te6M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD85A33684;
	Tue, 13 Jan 2026 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768311736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TzvRGR1KE9XUBBxJVkEgxb8mxuBXEejZtD+0orpA3o=;
	b=nGoKTJWeEC3lBzosfNcmG5WjK2mWcV/6C0RsBD8KtQF7130YkGviQ9Bxhy2wwkn9qGEeYL
	1F7C8LV6t0hj2OxqRZAOpvVy1mxP+RgV3EQD7raUwTk1wo4ESiwcHlmaNL0gDmhSlqrDUv
	dM9kpE8HhuAgnj2gqmWeR/NSK0yFQBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768311736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TzvRGR1KE9XUBBxJVkEgxb8mxuBXEejZtD+0orpA3o=;
	b=E2Mp9Ca3a+CLu011DZYGuRHUPra97yCY2tLLxJZjgCZA6NiJajt58DKE83fdGYfizA1kAB
	qXpIZO0Nq7MIWLBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768311736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TzvRGR1KE9XUBBxJVkEgxb8mxuBXEejZtD+0orpA3o=;
	b=nGoKTJWeEC3lBzosfNcmG5WjK2mWcV/6C0RsBD8KtQF7130YkGviQ9Bxhy2wwkn9qGEeYL
	1F7C8LV6t0hj2OxqRZAOpvVy1mxP+RgV3EQD7raUwTk1wo4ESiwcHlmaNL0gDmhSlqrDUv
	dM9kpE8HhuAgnj2gqmWeR/NSK0yFQBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768311736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/TzvRGR1KE9XUBBxJVkEgxb8mxuBXEejZtD+0orpA3o=;
	b=E2Mp9Ca3a+CLu011DZYGuRHUPra97yCY2tLLxJZjgCZA6NiJajt58DKE83fdGYfizA1kAB
	qXpIZO0Nq7MIWLBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93F993EA63;
	Tue, 13 Jan 2026 13:42:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yXfsI7hLZmmXHwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 13 Jan 2026 13:42:16 +0000
Message-ID: <7475bece-04e0-43a1-8e0b-4af191c004f0@suse.cz>
Date: Tue, 13 Jan 2026 14:42:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 9/9] mm/slab: place slabobj_ext metadata in unused
 space within s->size
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, cl@gentwo.org,
 dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com,
 yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, hao.li@linux.dev
References: <20260113061845.159790-1-harry.yoo@oracle.com>
 <20260113061845.159790-10-harry.yoo@oracle.com>
 <fecd4166-618d-4d69-be02-d9b3e8f0f271@suse.cz> <aWZCHIYsFSaGzRYu@hyeyoo>
 <aWZJWkbosy9A_XBD@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aWZJWkbosy9A_XBD@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B0DC4000A
X-Stat-Signature: f1wx1ukpfxzzk3sf9fw9brr8scbkokd4
X-HE-Tag: 1768311737-173461
X-HE-Meta: U2FsdGVkX19SHbaQIN88jtPMyVne1A1XZaUc2lelpXO6utzFH/heBimTB1Oj2Jls1tXQp/rF22ehBsw/i2YiltWSkHzUUf/+XL6XOFtuE2cJOyGgTlJKUglwqUEAru6qlBhX4fwlz1WVTFdr4CioxFnrFzoUiKTs7n/rFGJT58vOeuDJVWhOyLkLLW2XfmsNZcnEchzBaXOv7Dfk8FBIuz8l8aatWV0hhgA9iG1lSfJMXH7li1xAX8tYFpTIVB7iXd882iCzi9pKy42iyj2zJYr4RpK22Ck2qt0KEwbwuXu6HiqsEZd6BnDC4cOfSQnEgOqV6+MU53C/Bux9b2YNdCko/Gdc4qaCqDLFkezH+6lgrmrq+WZd8jhbMZxfh9zG/MGNq6UymV16wY/h+wr/PCVYSO1r5fvkeb1BAhkEzq6yUKQ7TrP55UC3tAIl2bh6RczDhbI14gNQS/Soj1pc+OTT7OaubJDNmZ+WwqcqxprDSTV/ajmJf/a/p/4WX+UUsz5aoyyBkPNs8MsgaxcvW7Sc0Yxpr5SfEws0/hFs1ysQz1yqe/4PcAbl4En4mgHuXPtcVB7LcLfASfHZGoiS0wk4r85LxUZeE+w0BZYVl+SCqrW/deNhissUXcZzPqpEPUgJcD6e/ElDwqNd13xv7JrVzQkr1ij1Ivm7873nhgfyFC0N6ibM6OqD0cQsWg8s8t6PGFyAgqyQrei/aWEirGoRqP77RYdRUl37P0mlwXLXtKBRG+GQKrlBaoNMbjJyME1NOzfrdQV3z5kNFQ2W579vS8W5421eb6GasL/sfRCE6P6RPIgrLgP5bRrwEzvj9z80hexuLXW7HVXEzEWYHeYsDat+NgOfdKeIqezUm6tBFxR5BM7GM/WOx3bOJvcLIfC7gO8MdxNcWiaumyq7jYZX87/hr0BOtNDYPlqRJu0qi2jmib03vwxJvxbfj4z6ZBDdoKZvtyRbDoLgy7B
 8iSDmSp7
 SEbb2u2hpWMCI4rBhcMhu1wxVox60WXGU0wOGBdnj8bSLAP1fLmsl4iVmKFiCmVpqa0avtBcMntk/ZXQk4zOEnYlzUwDIOX8qwaKCXH5ijkC57J6gwX27WztW+3XoHuSpgN5ouEGvGOScqU0oZKJWg9gLKuhjeKCwUajDHP5BxOuJigmgQJLkx8oNNP7fME3Kv/LjqTA+HpHvBllFqwG58njyXrCcQzwqxmpd2k1i6YI0tiWDlLzqum0sVOBFqLRMpwpUQgwkxFDIdBsWAuIx3QCPyS5P6YGqipM0ckOdILZxyCWkf7qzzRpmqgCVs2DkNI4p/iKYzUW0pJk+EYuPrmqYQgM6gB5RhpcykHUYuz0R7phaCfpolLkgxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 2:32 PM, Harry Yoo wrote:
> On Tue, Jan 13, 2026 at 10:01:16PM +0900, Harry Yoo wrote:
>> On Tue, Jan 13, 2026 at 01:50:31PM +0100, Vlastimil Babka wrote:
>>> On 1/13/26 7:18 AM, Harry Yoo wrote:
>>>
>>> Does this look OK to you or was there a reason you didn't do it? :)
>>>
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index ba15df4ca417..deb69bd9646a 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -981,8 +981,7 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
>>>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>>>  static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
>>>  {
>>> -       return obj_exts_in_slab(s, slab) &&
>>> -              (slab_get_stride(slab) == s->size);
>>> +       return obj_exts_in_slab(s, slab) && (s->flags & SLAB_OBJ_EXT_IN_OBJ);
>>
>> There was a reason why I didn't do it :)
>>
>> In alloc_slab_obj_exts_early(), when both
>> obj_exts_fit_within_slab_leftover() and (s->flags & SLAB_OBJ_EXT_IN_OBJ)
>> returns true, it allocates the metadata from the slab's leftover space.
>>
>> I noticed it as I saw a slab error in slab_pad_check() complaining that
>> the padding area was overwritten, but turned out the problem was
>> because obj_exts_in_object() returning true when it shouldn't.
> 
> Perhaps a comment like this?
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index ba15df4ca417..c40c3559039e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -981,6 +981,15 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>  static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
>  {
> +	/*
> +	 * When SLAB_OBJ_EXT_IN_OBJ is set, slabobj_ext metadata can be stored
> +	 * in one of two ways:
> +	 * 1. As an array in the slab's leftover space (after the last object)
> +	 * 2. Inline with each object (within s->size)
> +	 *
> +	 * The actual placement is determined by the stride size rather than
> +	 * the SLAB_OBJ_EXT_IN_OBJ flag itself.
> +	 */
>  	return obj_exts_in_slab(s, slab) &&
>  	       (slab_get_stride(slab) == s->size);
>  }

I meanwhile wrote this one. I think the part about depending on slab's size
is important so one doesn't wonder why we don't simply clear SLAB_OBJ_EXT_IN_OBJ
if it fits within_slab_leftover. As discussed off-list, will use it. Thanks!

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -981,6 +981,12 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
 {
+       /*
+        * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and need to
+        * check the stride. A cache can have SLAB_OBJ_EXT_IN_OBJ set, but
+        * allocations within_slab_leftover are preferred. And those may be
+        * possible or not depending on the particular slab's size.
+        */
        return obj_exts_in_slab(s, slab) &&
               (slab_get_stride(slab) == s->size);
 }


