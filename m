Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3902DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2C36B0007; Thu, 28 Aug 2025 04:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3DF6B0008; Thu, 28 Aug 2025 04:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66BAD8E0001; Thu, 28 Aug 2025 04:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51A556B0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:01:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04F855BD95
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:01:46 +0000 (UTC)
X-FDA: 83825422254.01.1102309
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BF3D18000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:01:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XNe5x4ex;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z9iUOAsJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tgbWUcm8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J7PBkZLx;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756368104; a=rsa-sha256;
	cv=none;
	b=Oe0BIBcmcOGUM81eQvtjhuvTyxIvVkdEX/ZR43cNejKoN40OURFWhdCUxeZkjvPdSNKi1D
	PU3gG08vjgC/VqaXEI8+8vFRDPCuwE/cLIl5uwyh3tiidzUda7Hdpmt5zALKmmqdIOWd9w
	axC40p/ntcG4sNaXRSbInMlj4txAeWo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XNe5x4ex;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z9iUOAsJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tgbWUcm8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J7PBkZLx;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756368104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6ItBYEouCLq/APyaYGz19HWEDks/RPcsNJulNZZBW8=;
	b=B2WwhjE5XwQ+Qhjuoc94EWW6XH7BKXQBTjrobdMC71OQif5fEiYYjRxaTRQ1AmiPGJ3Px4
	fQvc8FTSO7x3BFyJGEVAvIzMOcO3ZEf1epdFC0TTporrTHNKdsFmXcjhC8eiO4hlO2YmyE
	4Z+7znq2ECdoDsQ91l330ZHkPQPmmpk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 092E320A99;
	Thu, 28 Aug 2025 08:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756368101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G6ItBYEouCLq/APyaYGz19HWEDks/RPcsNJulNZZBW8=;
	b=XNe5x4ex2WUGvQtkfsbIYtJQ3IH2zM6qHyqHThn0UYC8T8coXxexpjEFSEwY/dISzW64Ux
	F7u7yMzxH844gbXNtShA9cB8MjRoTtlUU6MRZ+py/PE27jY8BaitaAHjD9qTmFvUeWZJBX
	rM6FzKEooofps4ui7WGO1D/lknC4KRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756368101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G6ItBYEouCLq/APyaYGz19HWEDks/RPcsNJulNZZBW8=;
	b=z9iUOAsJdTzWYhANDkwS2QMmzhAijjYCquLMvoCRp2bovKTzEhwNC2/y441NTxNUiGAYGR
	n6CspIhXnZAa4jCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756368100; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G6ItBYEouCLq/APyaYGz19HWEDks/RPcsNJulNZZBW8=;
	b=tgbWUcm8aXE6IbO44BqEo/dyWOa0pZGE6wmTeINWA4fqk+EFvE28gGjRhhv/bh/kB/1JMC
	OCd4WLF2C43AVNWLqX6tUUkAOlgwpvijZJ2cJGs3TaG/wUV3KFB9xqag2Ox+XA6uwmMF/K
	PXtgtXvle+Rdn5pR4Qzd0XzKC42jyic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756368100;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G6ItBYEouCLq/APyaYGz19HWEDks/RPcsNJulNZZBW8=;
	b=J7PBkZLxBRYzfT+UZHT2ZgTZvS5r2T5yVK+B7QrMTVGk7JMHcP/klQWzb5Z3pslTvPB4Qh
	yRRH8JAOr4WEQRCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B803F13326;
	Thu, 28 Aug 2025 08:01:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qiDJK+MMsGg9IgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 28 Aug 2025 08:01:39 +0000
Message-ID: <e58c8482-bd11-4111-b912-daf8b43ebb15@suse.cz>
Date: Thu, 28 Aug 2025 10:01:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] slab: add opt-in caching layer of percpu sheaves
To: Thorsten Leemhuis <linux@leemhuis.info>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
 <20250827-slub-percpu-caches-v6-2-f0f775a3f73f@suse.cz>
 <9f61c814-0d39-46f2-a540-cc9c0e716cf6@leemhuis.info>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <9f61c814-0d39-46f2-a540-cc9c0e716cf6@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7BF3D18000A
X-Stat-Signature: txixjb5nnfnexdch3zjxomnthqaxujie
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756368103-885683
X-HE-Meta: U2FsdGVkX18mw+pSjxRArmpkFs2+XGh3aPk96WQIMO4/QTcdXzAALg6b5Q/EIXdqeX7RhbrsfazCcYMhkndkuYQrkOR7UgwhswryFl5ALQkbgQT6phT9qgeabr97QrRSE+fL+nPM/AVPYCY3OkJgZpMPF3nvUoLBbw8JfGDGeBu/gkfh0rihQJMunJ1x2MVB7GyWxMf7inf/cZxCSpCC9NHO9pXvKdHTTqFSINvyms+4uDvFNi9cb3lRYh2dRsbtLuG32XzFroVzYvH1R8B7DP8Sw95hpq10Mv4e77jPsVUrjeryHbkqwYIPG66m/WLbWzZVyVy0uKn0VzO+Eqvx77K0uaoMum2H/8yHu02aqcuBEJyPaZiH8ULQdVPMuZ12Cvym/q4tG1KuBvU4xZvSN/FmgQX1kKac4qzrPKNFDNjEGigvqP0gd6YuMFz4a0iApC3qgsvfXbP1wXHPldEVO2sPoxSpBAcUjFotXFVh4lE2dn14cOfTKOIlZOjnxMslr2xJOy5Dy1HWArxmQQYzBYsP6EzeUL41J2tbmfzbs0Rte2re/eS3s29JI6BFHdysFpiH133W3CsziHuVSo+OdyVoTeuxUUghvW3YVj0as8FOhO/iEskRRVJHkK7Eq2wrb7Zs2XVEyClPx6P7NgUdAHGQVSpXBkuzU3ie0hgI7ocCS4yGzGzX8jHJemcWP6Upf3V00I+M6k2BVLkBEnPXy/XQ2vhO3eGbhf/MPnGY550naMjpaio/Z3GpQKccD/shTek4NQl/hpGoPRDkATK2Jpkn8wPLBnR9n4U1q6BSYhqy7+/DXxpCrptNoerQwydL5hlZX2Sy5x4IJxAYb9SaIFNxIbv92sYWnXO3EieXQpCR/S1X3jP16YWXAcxJ/YxGpBiQUh3hXoeRh8Qs4XU3MLsjT4mENpg5zD1s1pgOiO1xBcKfLjfZWLfwA5cPBgXiHSqDD3kCAYyKyy0HrLU
 PLuJtkUF
 w9B9HWg8bEDcZeG7MNJBlViOvgSmBea61wy1quLiGE0bmCFn5f+xT4Fog7BneJpS3OmYJpXofjDKAd7tY3ZsMHRfE5zq8df2fMV85LG0bJi9DfqcXvt9ZcS8iEQatid+Cs37AbB2JF3HdyPyRKT8+XMPoXnfdkj+bBPQhlH2SC/QkFS7AvsUMLXm1mO6QtMKgKVE+/RQUY58THv2HReMohZriY7zD5GKnsF+eJozhjibTMlf4t2F9H/NU0WsOoTRvpabtNGS9HdTMcYSOLDgNaJN5k/cy8BdCsA9NCl4ilC/ygglanKnxW5ICQDWlXqD+SF16GKW7FbqZiWtYNi+5P9kqy/pdI9HgHOK/vjuFjOoTpDTN9EoHjSIIuA5SZPjhWXp+6SdVb/upZa9kQBbtHKaXljl7praqPrINjqVhli1H8LmgaPDyNOE0xfpDRhGZmVH3TB1KMaK9rCDzfRt5lDYJ8aB14SvFvo+u0Xwypfl0cR0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/25 09:43, Thorsten Leemhuis wrote:
> On 27.08.25 10:26, Vlastimil Babka wrote:
>> Specifying a non-zero value for a new struct kmem_cache_args field
>> sheaf_capacity will setup a caching layer of percpu arrays called
>> sheaves of given capacity for the created cache.
>> 
>> Allocations from the cache will allocate via the percpu sheaves (main or
>> spare) as long as they have no NUMA node preference. Frees will also
>> put the object back into one of the sheaves.
>> [...]
> 
> This patch showed up in linux-next today and from a *quick* glance at
> things I suspect it might be the reason why my daily next rpm builds for
> Fedora failed today like this:

Hi, thanks for the report.
> ""
> In file included from ./include/linux/spinlock.h:63,
>                  from ./include/linux/mmzone.h:8,
>                  from ./include/linux/gfp.h:7,
>                  from ./include/linux/mm.h:7,
>                  from mm/slub.c:13:
> mm/slub.c: In function ‘__pcs_replace_empty_main’:
> mm/slub.c:4727:64: error: ‘local_trylock_t’ {aka ‘__seg_gs struct spinlock’} has no member named ‘llock’; did you mean ‘lock’?
>  4727 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
>       |                                                                ^~~~~
> ./include/linux/lockdep.h:392:61: note: in definition of macro ‘lockdep_assert_held’
>   392 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
>       |                                                             ^
> [...]
> mm/slub.c:5653:29: note: in expansion of macro ‘this_cpu_ptr’
>  5653 |         lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock.llock));
>       |                             ^~~~~~~~~~~~
> make[3]: *** [scripts/Makefile.build:287: mm/slub.o] Error 1
> make[2]: *** [scripts/Makefile.build:556: mm] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250828/linux-6.17.0-0.0.next.20250828.432.vanilla.fc44.x86_64/Makefile:2017: .] Error 2
> make: *** [Makefile:256: __sub-make] Error 2
> ""
> 
> Full log: https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-x86_64/09498568-next-next-all/builder-live.log.gz

Oh so I assume the .config here has both LOCKDEP and PREEMPT_RT?
I tried to make lockdep_assert_held() with trylock but forgot about the RT
difference. The solution is Alexei's patch

https://lore.kernel.org/all/20250718021646.73353-2-
alexei.starovoitov@gmail.com/

Wonder if I can just fast-track it to here from that series?



