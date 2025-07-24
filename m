Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39254C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8509E6B028F; Thu, 24 Jul 2025 06:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9D16B0292; Thu, 24 Jul 2025 06:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BC46B0293; Thu, 24 Jul 2025 06:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7676B028F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:14:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDEB21D46DA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:14:38 +0000 (UTC)
X-FDA: 83698749036.04.4F956B8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id B441140014
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:14:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nLYGEiFm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3pZ1FqzC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXb2Y2nA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qCLsHA3A;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753352077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Cb3/++MEwl7Z6VekxEpy01dqQjPmNLRWlpN/hgrJ/0=;
	b=Ek859Y0lXp+Y3bNE5/pBAir24OySLivzonmkHZi70MQMp5/Lf8A9RxHvM8HPcwwloU/Qaz
	MpGfuKzl86XXjoPRy0u5+RBtERmspqmM+UmbgsFz2lQNzDkQKrTR/PKw02LzXshE77SeKZ
	5WykazuuAjX5BHcffWAlFzqKhhe5sks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753352077; a=rsa-sha256;
	cv=none;
	b=UOJ6e6un36461Abevd4RVRA1KQK20poVVbn0VolGRDAgGC5PSZYOPvYZB9d7URwaFmdL5L
	mPEX8e+IFy5EZ5Cmi3yBhn4de9kIRp5shZT/N8k/1V/91y2yPZL93aByyT+aYI33Uiu+AY
	siR+akvcv8KN0wP/LfZj9UXeJob/hsU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nLYGEiFm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3pZ1FqzC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pXb2Y2nA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qCLsHA3A;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E71B81F394;
	Thu, 24 Jul 2025 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753352075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Cb3/++MEwl7Z6VekxEpy01dqQjPmNLRWlpN/hgrJ/0=;
	b=nLYGEiFmJWcNZBbspiqCJwcNcMunIUHTB60lvcPgvxIcIE/XJAuWTDWEwMHfeObvM8/mrz
	CxpabEYPF/Ft8tdIIEY+rqSPXk5UU5LTkwGkZRE4t6PzSJ9UlPchBvzKtrYK2yfvsQiWLo
	I7QB+3qrQrIGg8eqTctUNhNKka376as=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753352075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Cb3/++MEwl7Z6VekxEpy01dqQjPmNLRWlpN/hgrJ/0=;
	b=3pZ1FqzCngimCdeVftWke/jvyzKpGeawiUtGe4sxuDTnxwqDMXrfsihFbOUbjW7setThRN
	08zR/bAzYNi9ssAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753352074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Cb3/++MEwl7Z6VekxEpy01dqQjPmNLRWlpN/hgrJ/0=;
	b=pXb2Y2nA7gnPs0wQRFBGmFLFOMHVdrjoha8c1iaEen+cFPiUR8H9tJ6Lf2YzFE3YckcWoj
	5YkGPL6PC62tEby/+360OS/lCPBRci94BEBRaBTlvJErhUVUuTmvRwZcA868vtFit4GRJv
	RTDyrkIXfqhIgahq57ErRCdsGmRptFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753352074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Cb3/++MEwl7Z6VekxEpy01dqQjPmNLRWlpN/hgrJ/0=;
	b=qCLsHA3A5D7w1CNsjxh7caLdz7/xGHhI4RxMjyx5KTK87zG2ksYKYOYL6Sg0Cp8DXjz8xF
	690yjisK+nkGXyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D15D4136DC;
	Thu, 24 Jul 2025 10:14:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hii9MooHgmiUYgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 24 Jul 2025 10:14:34 +0000
Message-ID: <45cd4505-39a0-404d-9840-a0a75fcc707f@suse.cz>
Date: Thu, 24 Jul 2025 12:14:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kasan: skip quarantine if object is still accessible
 under RCU
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B441140014
X-Stat-Signature: iwy4qiinygoyee9kxfgyh9n36m4hdhq1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753352076-981857
X-HE-Meta: U2FsdGVkX19F8Ua9hjTQnjikIXjOedZclTlWp+HLR7Jica/6D4FIE/bs/40Q6Gp+gvaLAMfEhs9bVfh9ZcT4RKube5su9Cdjszhq8QBdTYmUxH6qJtxD8nZDHgmST1imq4uZvi3XtrSJP59ydhP3jmYIURE0oomwwi7u7BThmpIYUeoZC2fDT8t7lnlgP6EdsKPc+iDc7PDZheArZ7Z5pYw5MmgFfCQw8GPP/HkP8pAgxZCuUD3yPJCuDnPAWbqm6suPwl6BylaN0Qik9U+acYBlp3rNakvnE32G7epawkexNH6XzU5aV2kBwbzbZHWA6bxVM4XsqUOKxfoHvwKHg1OSB7jxaX34jrx45NEa+HC0XtCNx4l8NthkyoLNb0pQi7YOPkoPZnsgvURcL8h49E01Fy9vkA55Fgq74sI1DTCSCv3vLgE1N2DXxp6wJ4b7eRQ7QuFZMmNFy4naDPzU3hpdTnhu/DPSdBHYJJEQuGXrV6jtBuYVz/BJKzLYTXWNpix4RXhRPxLt8SUPmxo1N7CgnxijDlZjVU4ekzdAYjTsEkO5iaRNT/PPBsxtHUDqRJcJc2ZO3BHb8xaOd9Q1iPhnXvSLweTcVFDsuaHJS7hv5ebK5gPD2OicJo9ko1gv/GbLZgrRX2aGMyu6II4Bo5M2jQ9poeXwZVbGAUehYCxH6ZFI351f/Hd+9KZ0/8LTQhGiyclaaPjOqY1s6q7dcOY3lZRz+aoDpww6cZ4hjboRGBHUfIE2p/X2WsXuyF1RA+sntHDlD9mbrxqzg+wIt1fo3b9dIGMIwa1M9FuCYQCygEaz5E9MoMOK09LIGMBEM3/OC9AmGD+/ZjdqtXnRKovbplRtLb7Zpczd8vtjMTXcOjXBHIqc6C33pYoDGU4DwwRu+B4aRGIRFA7WCegyHbdhp4UAGWTDaQNfS8yI08EyF73fRKRLwoTEnEzteFFyHfA6WyaaYA9FDGWaxJL
 zNCO3vaP
 Usxt+mzwr5HfoKH7W15ZmvtAMk4EGgxZxFRz+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/25 16:59, Jann Horn wrote:
> Currently, enabling KASAN masks bugs where a lockless lookup path gets a
> pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
> recycled and is insufficiently careful about handling recycled objects:
> KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarantine
> queues, even when it can't actually detect UAF in these objects, and the
> quarantine prevents fast recycling.
> 
> When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
> CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
> after an RCU grace period and put them on the quarantine, while disabling
> CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediately;
> but that hasn't actually been working.

Was the "allow reuse immediately" not working also before you introduced
CONFIG_SLUB_RCU_DEBUG, or is it a side-effect of that? IOW should we add a
Fixes: here?

> I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
> could only trigger this bug in a KASAN build by disabling
> CONFIG_SLUB_RCU_DEBUG and applying this patch.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/kasan/common.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed4873e18c75..9142964ab9c9 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -230,16 +230,12 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
>  }
>  
>  static inline void poison_slab_object(struct kmem_cache *cache, void *object,
> -				      bool init, bool still_accessible)
> +				      bool init)
>  {
>  	void *tagged_object = object;
>  
>  	object = kasan_reset_tag(object);
>  
> -	/* RCU slabs could be legally used after free within the RCU period. */
> -	if (unlikely(still_accessible))
> -		return;
> -
>  	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
>  			KASAN_SLAB_FREE, init);
>  
> @@ -261,7 +257,22 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
>  	if (!kasan_arch_is_ready() || is_kfence_address(object))
>  		return false;
>  
> -	poison_slab_object(cache, object, init, still_accessible);
> +	/*
> +	 * If this point is reached with an object that must still be
> +	 * accessible under RCU, we can't poison it; in that case, also skip the
> +	 * quarantine. This should mostly only happen when CONFIG_SLUB_RCU_DEBUG
> +	 * has been disabled manually.
> +	 *
> +	 * Putting the object on the quarantine wouldn't help catch UAFs (since
> +	 * we can't poison it here), and it would mask bugs caused by
> +	 * SLAB_TYPESAFE_BY_RCU users not being careful enough about object
> +	 * reuse; so overall, putting the object into the quarantine here would
> +	 * be counterproductive.
> +	 */
> +	if (still_accessible)
> +		return false;
> +
> +	poison_slab_object(cache, object, init);
>  
>  	/*
>  	 * If the object is put into quarantine, do not let slab put the object
> @@ -519,7 +530,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
>  	if (check_slab_allocation(slab->slab_cache, ptr, ip))
>  		return false;
>  
> -	poison_slab_object(slab->slab_cache, ptr, false, false);
> +	poison_slab_object(slab->slab_cache, ptr, false);
>  	return true;
>  }
>  
> 
> ---
> base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
> change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24
> 


