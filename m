Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88984CAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 20:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44636B000C; Sat, 13 Sep 2025 16:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4EC6B000D; Sat, 13 Sep 2025 16:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE35F6B000E; Sat, 13 Sep 2025 16:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD716B000C
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 16:46:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23431C01CE
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:46:51 +0000 (UTC)
X-FDA: 83885411022.28.005015D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id C199F80004
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:46:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vl1wE06q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnytsj7B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vl1wE06q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnytsj7B;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757796409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38MKvmoG9sJlDP35qP5Jp0TIm1uAH+pH6cn4t8ko1Cc=;
	b=GkY40wCjt2o+xIzD4fIPJ+ld0DSxomc4JTqLU6Y/8cUEMj02UfGm1QSRkFTcqAEmMrrScL
	17B5rgMaBwnnJe8nTPgJLETUf8o2wOgyt3p59pJTVHJE9yRLArO3Fl59X4dHKOW0py5zjW
	yFzTVDWByfdf83OB9FfV9IZpt+WoMwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757796409; a=rsa-sha256;
	cv=none;
	b=qI/0x81R16o0SxISk/veoQdR+THf8S4RJ2s+ntXIZdDWQj8NzpGdPhFIbYIc64/4AVYEpj
	kv/SwzeI7a5tRZ7BP0FHUjiC5kMPI+IiOGZqXfw86rAiBRuJMSn9x2uho8VXz2uhu/OSld
	KvqjQEsNJDrzN9gObeFtDNvo8/FKEAM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vl1wE06q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnytsj7B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vl1wE06q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Mnytsj7B;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AD4703EB95;
	Sat, 13 Sep 2025 20:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757796406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38MKvmoG9sJlDP35qP5Jp0TIm1uAH+pH6cn4t8ko1Cc=;
	b=Vl1wE06qrNqMW0HqlqZ/M+jT5XnJfPIujr/Qb0Xs9xEj/Tk9x1GBSOMOl86kc7Er4faLmC
	sapigQUSDzhXgI4x4khq9IcYklyzWxaWRWGvibBTPmGiTJw5mWTSqKdXF5234efuVYWuh4
	hcUPmVa0SL4cIpXLA6FfomQWaAx4OgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757796406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38MKvmoG9sJlDP35qP5Jp0TIm1uAH+pH6cn4t8ko1Cc=;
	b=Mnytsj7BFrJRllabJ3CaQTCHsRj6GG4ORvjb6d7DlXVcBjTz9D2Ymrewba1pGD39R3iiQI
	I2KPaYW3SufbnNAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757796406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38MKvmoG9sJlDP35qP5Jp0TIm1uAH+pH6cn4t8ko1Cc=;
	b=Vl1wE06qrNqMW0HqlqZ/M+jT5XnJfPIujr/Qb0Xs9xEj/Tk9x1GBSOMOl86kc7Er4faLmC
	sapigQUSDzhXgI4x4khq9IcYklyzWxaWRWGvibBTPmGiTJw5mWTSqKdXF5234efuVYWuh4
	hcUPmVa0SL4cIpXLA6FfomQWaAx4OgU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757796406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=38MKvmoG9sJlDP35qP5Jp0TIm1uAH+pH6cn4t8ko1Cc=;
	b=Mnytsj7BFrJRllabJ3CaQTCHsRj6GG4ORvjb6d7DlXVcBjTz9D2Ymrewba1pGD39R3iiQI
	I2KPaYW3SufbnNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93ECA1372E;
	Sat, 13 Sep 2025 20:46:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KfLDIjbYxWjcZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Sat, 13 Sep 2025 20:46:46 +0000
Message-ID: <b1628e73-92d6-4b2a-b0a0-0f7e26f8c3a1@suse.cz>
Date: Sat, 13 Sep 2025 22:46:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka-slab:slab/for-6.18/kmalloc_nolock 14/14]
 mm/slub.c:3866:2: warning: variable 'flags' is used uninitialized whenever
 '&&' condition is false
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Alexei Starovoitov <ast@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, clang-built-linux <llvm@lists.linux.dev>,
 oe-kbuild-all@lists.linux.dev, linux-mm <linux-mm@kvack.org>
References: <202509121822.aOV6H1ts-lkp@intel.com>
 <8fe99133-3322-4e39-9b58-80df547b8d1f@suse.cz>
 <CAADnVQJWXk+Zzsf_oVTaJkpm4nO3iq34bGcUDQRarOVSX+tLbA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJWXk+Zzsf_oVTaJkpm4nO3iq34bGcUDQRarOVSX+tLbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C199F80004
X-Stat-Signature: f8pjtzx7fnbharcmb993i5o4d633pgta
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757796408-944661
X-HE-Meta: U2FsdGVkX18E/qEjmY21/1NCLRnhA6W3auG9ewtbSgVoiuXZ6+edHclnU/vQFO7qOCbG0EXiVoyNfl2bRefg0RAvdG8xEyKifRODayW64UppnDhgXKUVrlRFo2gKRvwgtmOfQpcufyTD+bSvLpGVhkiNYmrdpHhI9X9S7DW95KG90llWiyW4DMhhk0zbYbMZopKnNYkWQmtrO+frteulwHGR6RiPrvzYhMQN56XytcIh2A03p+20J2QyRNdkTx0Yo+ZpyYjbhPh6scJEJv5q7Tfw8H+991+CNlN1AVD2yuQMwaJimVM3pYcf+8ayuoEpLNveVSeCybUq5Ov1BQdGLgP8FGB6t37MxgK9uQcUAyHR+AJEHsLLdIMjk41+u3Mq3AajiDOY1cGsrfI23TgYc4vbm1AzI85EpZ1EQtS4szLRkgM2g0c9bc0gqlNqUlEwmIw9lpdq1vvaY9pjJ3LUu1OXmjLpO+wLZVqLFjT4i3SkZB8WRaquBo484V7m03K8S0k4Sg0BnV1lAOD84giFyYtto2d5hpodn5PrGAv59AVnxv/Fl+WSOXRILTpqZ7yQmJO39nxs3oSm4cFAnPVOFAu8Pr4GNWE/x+sUQAX5r9SUQkSErpemD2ruNdDQo5zFdvjr2lV1IGnIcvvASK+Fay6aHPZQThEEQizXTUGXl78LAhX4HUuP9R52tiX3umZ/nT1pA9sEyqWtxlOKqzJKMriRpfvpO8cE4L8dYyI9CzXSRnsvvpc2ZWt7dL0SkS0zxUdOQ9F3UnNff3MRn9d9z5yK5XLdOusan0hOmyUFtaGsX1fxGfZYa/2XmMArxtvUNbt/T3NO4mENlY+l4VRrU88GgJcsvA1zboYgRP7htYa7OWAfYd0GvhUtFT5TA730AjDag4WhHCad574vgu258qyP+w6i1udqNgjFY2mvGsmvNFe7THRbzWbcg0jBwem2HG/8RxXKzpmiwHuiuij
 GDIVw4Uo
 G4zWXziMnn1d3qpuM2NhuwAZPiqA5+vcO+UOEV0RnWhrShAZpiO0xVfOHpxFsD7r+V+7x33f1vyodNGbhmw/1IgxW5xlhVlBCfOpFRSpY392FNNyNkVIt94BIRWuLaXDT3wImNbT4vdSVgeosiHIil1OJux4ZhNAJ+voRmh4RjPXTlxFNFwT95twEfHga1DSJI8o1YJVT4XIPyBBB2AL9d7OC2/zCyTTrO4+QVM+hmkhXeSIfISiq77gq25LoVT22xiSu9clWmEktlqu6rpslHSW6c7Se4Mc2IWRGPi3VVWb2x6ayf1AvBJvzMMohCUR7rau8J8ztlfGY7prfOWrhqwNGpmcTWnqzzoi0fOl/7Q0HMPh4DIkPpjoQ4G3bF/QcxiPoHSqvIQ48zT4b6QestiHZOpBQ8ZfXkaOLvOcjmJhnKhZyyB6URm/aQDO6Ksy/MW+JFF+sv9DR2MQQLiq+17iWog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 18:39, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 6:23 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3772,8 +3772,11 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
>>  #define local_lock_cpu_slab(s, flags)  \
>>         local_lock_irqsave(&(s)->cpu_slab->lock, flags)
>>  #else
>> -#define local_lock_cpu_slab(s, flags)  \
>> -       lockdep_assert(local_trylock_irqsave(&(s)->cpu_slab->lock, flags))
>> +#define gg(s, flags)                                         \
>> +       do {                                                                   \
>> +               bool __l = local_trylock_irqsave(&(s)->cpu_slab->lock, flags); \
>> +               lockdep_assert(__l);
> 
> That works, but would raise questions for anyone looking at
> these two lines as-is, since it's an implementation
> detail of lockdep_assert() and combination of .config flags.

TBH when I see some code with a side-effect wrapped in a WARN or assert that
can be configured off, it already raises a question if that gets executed
when configured off. There are examples where it does, and where it doesn't.

> what clang warning suggested is imo cleaner:

That silences the warning about flags, however it means that when lockdep
gets disabled on runtime, the locks stop locking (but not unlocking). While
debug_locks_off() only seems to get called in a serious situations
currently, we should not make things even worse then.

> diff --git a/mm/slub.c b/mm/slub.c
> index 4079abb5d0e1..a6b50cd1d95f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3865,7 +3865,7 @@ static void put_cpu_partial(struct kmem_cache
> *s, struct slab *slab, int drain)
>  {
>         struct slab *oldslab;
>         struct slab *slab_to_put = NULL;
> -       unsigned long flags;
> +       unsigned long flags = 0;
>         int slabs = 0;
> 
> Could you fold one of them in?

And so I've folded in mine.

