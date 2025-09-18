Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995D5CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D373B8E00C4; Thu, 18 Sep 2025 03:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1378E0093; Thu, 18 Sep 2025 03:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88DD8E00C4; Thu, 18 Sep 2025 03:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3A0A8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:06:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AA3D1A07E1
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:44 +0000 (UTC)
X-FDA: 83901488328.24.8963094
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id E02272000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kA27hBwA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kB62A6wq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kA27hBwA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kB62A6wq;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758179202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZoEadOth9tqAYHaBTKYwWwdApoK/1xkW2bLM7y3+n4=;
	b=UPkAAa/dtWSsD2BpOB7XZDEgBv0U0C4fMN54wQn9a9xLH6REFqpRA4Zj6L0Z8T0DTT0hhF
	5zVQiUBS4i9TYFKEOcISExJZnADDI/AaNAmF1Nvktj0Qga22HJ9iKhQv3yWqnUeX07nk/w
	Dq7vF2b5HHQQalXBKf/Z1yCy6jGJIUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758179202; a=rsa-sha256;
	cv=none;
	b=BQXfTo+nkTQv5znDGqDWCy0H5DT5+yx68oB6DxnHwdmy2ifdMFNQVhVE51MiEImiCdFdkr
	gLHrP1OJzhVfaeA7LHXaMub1y2tzgc8PbFPNiylatCHIri+T5KLh7KTkbZnT5cBkJnMk8I
	d4HDm5TIeVgqvV27BBc9pzyLts/G24k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kA27hBwA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kB62A6wq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kA27hBwA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kB62A6wq;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2482D1F793;
	Thu, 18 Sep 2025 07:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758179200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JZoEadOth9tqAYHaBTKYwWwdApoK/1xkW2bLM7y3+n4=;
	b=kA27hBwAKxwQojcfSbGlNTkTEId/3dxcw/HgkuiwYyAYF3N7fmly7nkyIQEkIgzjrw14uK
	RwO7Lvz/6VYrxJdPve3NHek/LqeFLTHGn7hNaVs9duFmUkS1x7jioSQsrxVUl5uy/v0mgA
	OiPJjb7jx9j1h1CrissOfNfUB1+wZzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758179200;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JZoEadOth9tqAYHaBTKYwWwdApoK/1xkW2bLM7y3+n4=;
	b=kB62A6wqAZn9HfImRxiW+yTaAnmqG5VXYyCaNcKO6xjJkyR96rvkf2yS9MwAhXpTVgc24Z
	3No5t8kyTjdWCUBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758179200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JZoEadOth9tqAYHaBTKYwWwdApoK/1xkW2bLM7y3+n4=;
	b=kA27hBwAKxwQojcfSbGlNTkTEId/3dxcw/HgkuiwYyAYF3N7fmly7nkyIQEkIgzjrw14uK
	RwO7Lvz/6VYrxJdPve3NHek/LqeFLTHGn7hNaVs9duFmUkS1x7jioSQsrxVUl5uy/v0mgA
	OiPJjb7jx9j1h1CrissOfNfUB1+wZzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758179200;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JZoEadOth9tqAYHaBTKYwWwdApoK/1xkW2bLM7y3+n4=;
	b=kB62A6wqAZn9HfImRxiW+yTaAnmqG5VXYyCaNcKO6xjJkyR96rvkf2yS9MwAhXpTVgc24Z
	3No5t8kyTjdWCUBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0743413A39;
	Thu, 18 Sep 2025 07:06:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NWI5AICvy2hLKAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 18 Sep 2025 07:06:40 +0000
Message-ID: <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz>
Date: Thu, 18 Sep 2025 09:06:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [slab] db93cdd664:
 BUG:kernel_NULL_pointer_dereference,address
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, oe-lkp@lists.linux.dev,
 kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <202509171214.912d5ac-lkp@intel.com>
 <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz>
 <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E02272000A
X-Stat-Signature: 55kqs3qf4yuysmibgdeiy5g7ga598hsk
X-Rspam-User: 
X-HE-Tag: 1758179201-753944
X-HE-Meta: U2FsdGVkX1+PSvDO2Eo5vwEIXIXQquNOAf2hnp1YYujIKGnZ7vRub3qiCOzfO219NTi7uj5dyeogmJDPf4laAMCXtpIneK6svaGoOWskdSyavgb1UqW6z9bWTiMUxlscTqfBMymmyC8tWf0ijMzDy3voOrb6ZCltWuui8As1PJNPMB3uY+TdovZlDPnT+fwsdMrsJ31D6Aga7u0fyXMN5PmhZF29GGH8GJkfLq4g5wmP4GpzPMT/i2Bp3s7ZtR0El5S2V8expAYAmidUnJWaarLgfTUrgilfTW9Gvin+otwUVfv+QE4E3JlVUZWJ2x7I2kt1bApGco0bsb/JhPFS2eK0k2WBhaFBpvwdUpyhhhcMGwsWhqlr3B85NQIR9J5iG92gLyiMPcSBjk7sxzRLj47mcXTPMiRlpQwNAFvWKZc/nSiS9TVc8qbjB0Ln4eJCBMLSRrtS8lbyODQewZeqPGJelnlKafDMvMNFXR7fsRqd2vF++zbSx4TER/w1xflu9BDdzs2s37rQzE9PfBRzthKtBwFxIgNoJT9zIuSjistvFZib8FllazdOnAMNRIZ8KoR79hjkSecCh3M+Mq5M2c20/DEetsRnXm0oCfOnw90F114gJ0ck8M+XKjyrXfhAFcNGgLFxGj6LbNodZ1dNdiQl3YXAIOcROtaHLTlEUP7olnT1TwqR0SZ6Z6V1Kl9MxPDNCPp0BfQf7ajDEye0Az0YL+5TQ6P3twux5Br9LFgyss7cRu/kBGXysYi/dLN9BMSECPCqdpr3qBUnD9lTXG0CoFaOON6kJnHZs8Qab1x3iYoyafv/LGn/6LR6yr8kgjSJhO+T4qGSqwOF0DkpqrBIUs7nxlGWt30wT1Rl/uU2sTO35mjZY9rj6Mle1nnfIj/6FViBUKvw8BXRkjDs4PA4aJPyhpXw7x5Dbf199WN6JmzpIhhNruj79e02FwS8Yo7AqFbncnwjBeMDdsh
 UXeRDjbv
 qEwvWHpUjjoGtWEF32TD28BC/0WOgpIDb/0RRW2IbVFSXfvIfgpBYL08n/lP9GbX5U1TUGZkEGYLTqffIDODeFsOtqIwRD6Zvg79JplcfZSqSDa5yxzpIoRmgXq5Q5ADlIXvIoeQJozgc17zc2zNONDn8F9NmC0ZhrhRf1UgwahcTe/vBEvH8vNhWOZ2GDIhrRFniQtC/Xz4kQY/RPYeqdd9t36MJdoIaOc2nKXrqL/tVmCIPuVatY+sUyAA3Cp1PmX3ZTbaUu4ADuef5ZJjhLn8NESH+LTBw8gsW864j98eHn02yiHJY0fuxv/GL6wecCAkxvEUH+K/x+OyHjU9oasF9zp6YOaruahXFkf7i1SKas7iT8f4o9EeGJbHJIXKgySeGr7q4SSOY/tU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 20:38, Alexei Starovoitov wrote:
> On Wed, Sep 17, 2025 at 2:18 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> Also I was curious to find out which path is triggered so I've put a
>> dump_stack() before the kmalloc_nolock call:
>>
>> [    0.731812][    T0] Call Trace:
>> [    0.732406][    T0]  __dump_stack+0x18/0x30
>> [    0.733200][    T0]  dump_stack_lvl+0x32/0x90
>> [    0.734037][    T0]  dump_stack+0xd/0x20
>> [    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
>> [    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
>> [    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
>> [    0.737858][    T0]  ? __set_page_owner+0x167/0x280
>> [    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
>> [    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
>> [    0.740687][    T0]  ? __set_page_owner+0x167/0x280
>> [    0.741604][    T0]  __set_page_owner+0x167/0x280
>> [    0.742503][    T0]  post_alloc_hook+0x17a/0x200
>> [    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
>> [    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
>> [    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
>> [    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
>> [    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
>> [    0.748358][    T0]  ? lock_acquire+0x8b/0x180
>> [    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
>> [    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
>> [    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
>> [    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
>> [    0.753023][    T0]  alloc_slab_page+0xda/0x150
>> [    0.753879][    T0]  new_slab+0xe1/0x500
>> [    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
>> [    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
>> [    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
>> [    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
>> [    0.758446][    T0]  __slab_alloc+0x4e/0x70
>> [    0.759237][    T0]  ? mm_alloc+0x38/0x80
>> [    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
>> [    0.760993][    T0]  ? mm_alloc+0x38/0x80
>> [    0.761745][    T0]  ? mm_alloc+0x38/0x80
>> [    0.762506][    T0]  mm_alloc+0x38/0x80
>> [    0.763260][    T0]  poking_init+0xe/0x80
>> [    0.764032][    T0]  start_kernel+0x16b/0x470
>> [    0.764858][    T0]  i386_start_kernel+0xce/0xf0
>> [    0.765723][    T0]  startup_32_smp+0x151/0x160
>>
>> And the reason is we still have restricted gfp_allowed_mask at this point:
>> /* The GFP flags allowed during early boot */
>> #define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))
>>
>> It's only lifted to a full allowed mask later in the boot.
> 
> Ohh. That's interesting.
> 
>> That means due to "kmalloc_nolock() is not supported on architectures that
>> don't implement cmpxchg16b" such architectures will no longer get objexts
>> allocated in early boot. I guess that's not a big deal.
>>
>> Also any later allocation having its flags screwed for some reason to not
>> have __GFP_RECLAIM will also lose its objexts. Hope that's also acceptable.
>> I don't know if we can distinguish a real kmalloc_nolock() scope in
>> alloc_slab_obj_exts() without inventing new gfp flags or passing an extra
>> argument through several layers of functions.
> 
> I think it's ok-ish.
> Can we add a check to alloc_slab_obj_exts() that sets allow_spin=true
> if we're in the boot phase? Like:
> if (gfp_allowed_mask != __GFP_BITS_MASK)
>    allow_spin = true;
> or some cleaner way to detect boot time by checking slab_state ?
> bpf is not active during the boot and nothing should be
> calling kmalloc_nolock.

Checking the gfp_allowed_mask should work. Slab state is already UP so won't
help, and this is not really about slab state anyway.
But whether worth it... Suren what do you think?

