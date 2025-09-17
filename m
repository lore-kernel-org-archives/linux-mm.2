Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AABCA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5C78E0002; Wed, 17 Sep 2025 05:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CBE28E0001; Wed, 17 Sep 2025 05:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA748E0002; Wed, 17 Sep 2025 05:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03CBA8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:18:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 607B41A0496
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:18:19 +0000 (UTC)
X-FDA: 83898191118.30.07051FB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1A09B180004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:18:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TBSD/CJ7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p+dXr11a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TBSD/CJ7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p+dXr11a;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758100697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HdoRh34zKgekx7h76Ak8Vo2WP4hVIe9wi/o5NYVnBo=;
	b=nhkzFixODKVgcoa6EY141zD/GlIw1pyXGx7bUBTjb+4p2vTHYYku6ZDjPmUzmoyAmmz5M+
	aFt71PjAu0EhUME07R0uVXigHjc564UTvznKoEew/VNvblKVi5D5IOA9j0u4hG83hwlvqr
	9n+zpWA9aVWiwCKL7bloZ9YwzN+vC54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758100697; a=rsa-sha256;
	cv=none;
	b=2Eop7vNVXGHg607edre8mRA6kuphTQArFiTijSSmr2s+27VnA8annS3MSzPrPu3at+LXQC
	g6J3ncMJmB8fpBIikUFvckFuq9aNQWlLp1rmHkuzBLakRH9kpM/jY9SRyMtw0U4j2E2fFr
	5VpVrnWC6798crBB5+7hA5hcPdpVyFI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TBSD/CJ7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p+dXr11a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="TBSD/CJ7";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=p+dXr11a;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95AEB21DA6;
	Wed, 17 Sep 2025 09:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758100695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HdoRh34zKgekx7h76Ak8Vo2WP4hVIe9wi/o5NYVnBo=;
	b=TBSD/CJ7aEAdZOulQqwYzv9ky15Gudyaio1J6JHoIca6qxFC3rHhtZmGW8ivvyANCzo0Rx
	/uIJRJ0Ee2ztSA+X7Q5XBL034hndjGei79CNFwkZXuOdf1Tch986d1v2GxifMxG1fmR5BY
	ZUdWzIFk0odFAK/B3bChMKHKvcMJ+/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758100695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HdoRh34zKgekx7h76Ak8Vo2WP4hVIe9wi/o5NYVnBo=;
	b=p+dXr11aPLofkChHMIFbeHMXb4klD4OvXTq3o2B3Vuah+Bi+9jmnyIa8zmE5/cDauMo5Z3
	MDNmjUacUjKjJ8Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758100695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HdoRh34zKgekx7h76Ak8Vo2WP4hVIe9wi/o5NYVnBo=;
	b=TBSD/CJ7aEAdZOulQqwYzv9ky15Gudyaio1J6JHoIca6qxFC3rHhtZmGW8ivvyANCzo0Rx
	/uIJRJ0Ee2ztSA+X7Q5XBL034hndjGei79CNFwkZXuOdf1Tch986d1v2GxifMxG1fmR5BY
	ZUdWzIFk0odFAK/B3bChMKHKvcMJ+/k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758100695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HdoRh34zKgekx7h76Ak8Vo2WP4hVIe9wi/o5NYVnBo=;
	b=p+dXr11aPLofkChHMIFbeHMXb4klD4OvXTq3o2B3Vuah+Bi+9jmnyIa8zmE5/cDauMo5Z3
	MDNmjUacUjKjJ8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73F26137C3;
	Wed, 17 Sep 2025 09:18:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D3umG9d8ymhqHAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 09:18:15 +0000
Message-ID: <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz>
Date: Wed, 17 Sep 2025 11:18:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [slab] db93cdd664:
 BUG:kernel_NULL_pointer_dereference,address
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
To: kernel test robot <oliver.sang@intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, kasan-dev@googlegroups.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <202509171214.912d5ac-lkp@intel.com>
 <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A09B180004
X-Stat-Signature: 1axiywk43ci5jxjxtcw7hiop3pw966s9
X-Rspam-User: 
X-HE-Tag: 1758100696-599186
X-HE-Meta: U2FsdGVkX19D3cXmj74SIp5rwjFHnURfVjCOFAbGwdWrDjTSwGZXkIexxIBlNREJHIufmA6g9MoaHxyeaplTQSxCkLpoiLDEnI3pBaY3HzXwdTUUPO9OTH3PqWlDv/mv9itCjDKiZac/LUiz50bZzkUqINqoi3K0OWDfgrdfGNOL2gs0RaDS469TZYHc6pXPTBKG8tew3w+q8KYRvlQu8fJetHsEd7DnhnKHgSBs0FyUe0+thU9PY4cvS2ipokG4zsCWmviqLMrg1aIXVadkKozV1nWN1S8Z4P9sVxwFM5ALdXnPLfl0jZ4+IMu4JF6WQeE7AyfY2gtvA2iP3TE+i+kXbQPboFtISm0XykXSupfxzTwmWykUOEJk1k2i/BfJnU/auvjjrMYo2wMCwx5C7TYLwgM7rkKyus+1iEFvlIVtnU49o0ZLWzn5iAOJEoUPUxzqdrDA9IbSNM9midXtXc0locMG9n6o1XyB5iES9VRMzfyqG99QfknLGQ8pq6eeeEd7WWShup8Mg6WH2g0lU8c441J001U+ztuyN7hmVCF80mYE2Rhbs7QiADC53O0JZkmeUzn7AvcVyW6z4DRGZuKlc23oCjFNZt21YbHrTqx2KX7SnHlEnCdwukP/GvWRpcgrA+2wnYzem/Ed0dW/YHJb1ZqrV4EEhNokDbpxoxW/tvalpzTBHj3yIveM6wlwQMi8Z4xMdqI1HrZdCW4YH2SEQMTxm1sWths8as73WcNMrw+QxhlhbxmJglNd5QrT+PLCvoOXn4MdHrifNFGd+tu8YgOcQHNzwEHuarFrIRjwARYY7Jk4FtmEVSlCnJzEDj6vE2jWFH/3v8qHiCc2GM7s4JOAayUsKuq3gfSo+9RuPY1XRfYA4NwcPaekQajiLIvaza9Fg/6vZfi01YQwPtLLmjNkVePFik8v6Eg8f+Nab0ndM+JJArFndbTZ8YV8XsAK4kQjrxzu+RCvyi5
 eYJzyMc3
 9Es4Nayu+L7tv2gDNP4S5oFXw+vWmn+YG8zMx/NvJLHe0o+f1pZLw7fk/xtijWGdPLHEXMiR8Vp5zM3W8zDpJMM2urBG1EzSOyabEFakv3fL7zlZsBp1ZGAH0T2JnQAw0iF/D7LVgiBm+KMXyQmIkYF4xB/GVJKnfAVUtbbUEktuk3ciHtuviuKST38wyYmpkjO0egmiw5HjoGTDGxEuMkCuG9VcnDovji5kA7ouuDbwnhZ4ejJUjxFQBf9Z0wwx6LhguVWusr3cbSRscQMJ/KZMGScIUU5JjQowhLm6UnTXzQ4SHlg7sy7HiZx2UKnbn3AqLouc39RumLvov0XUP5hEEM/JxtbJfH8LBzXSH/ZPUH8LszcUgaTXQLa5D97JYyJSa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 10:03, Vlastimil Babka wrote:
> On 9/17/25 07:01, kernel test robot wrote:
>> 
>> 
>> Hello,
>> 
>> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:
>> 
>> commit: db93cdd664fa02de9be883dd29343b21d8fc790f ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
>> 
>> in testcase: boot
>> 
>> config: i386-randconfig-062-20250913
>> compiler: clang-20
>> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
>> 
>> (please refer to attached dmesg/kmsg for entire log/backtrace)

Managed to reproduce locally and my suggested fix works so I'm going to fold
it unless there's objections or better suggestions.

Also I was curious to find out which path is triggered so I've put a
dump_stack() before the kmalloc_nolock call:

[    0.731812][    T0] Call Trace:
[    0.732406][    T0]  __dump_stack+0x18/0x30
[    0.733200][    T0]  dump_stack_lvl+0x32/0x90
[    0.734037][    T0]  dump_stack+0xd/0x20
[    0.734780][    T0]  alloc_slab_obj_exts+0x181/0x1f0
[    0.735862][    T0]  __alloc_tagging_slab_alloc_hook+0xd1/0x330
[    0.736988][    T0]  ? __slab_alloc+0x4e/0x70
[    0.737858][    T0]  ? __set_page_owner+0x167/0x280
[    0.738774][    T0]  __kmalloc_cache_noprof+0x379/0x460
[    0.739756][    T0]  ? depot_fetch_stack+0x164/0x180
[    0.740687][    T0]  ? __set_page_owner+0x167/0x280
[    0.741604][    T0]  __set_page_owner+0x167/0x280
[    0.742503][    T0]  post_alloc_hook+0x17a/0x200
[    0.743404][    T0]  get_page_from_freelist+0x13b3/0x16b0
[    0.744427][    T0]  ? kvm_sched_clock_read+0xd/0x20
[    0.745358][    T0]  ? kvm_sched_clock_read+0xd/0x20
[    0.746290][    T0]  ? __next_zones_zonelist+0x26/0x60
[    0.747265][    T0]  __alloc_frozen_pages_noprof+0x143/0x1080
[    0.748358][    T0]  ? lock_acquire+0x8b/0x180
[    0.749209][    T0]  ? pcpu_alloc_noprof+0x181/0x800
[    0.750198][    T0]  ? sched_clock_noinstr+0x8/0x10
[    0.751119][    T0]  ? local_clock_noinstr+0x137/0x140
[    0.752089][    T0]  ? kvm_sched_clock_read+0xd/0x20
[    0.753023][    T0]  alloc_slab_page+0xda/0x150
[    0.753879][    T0]  new_slab+0xe1/0x500
[    0.754615][    T0]  ? kvm_sched_clock_read+0xd/0x20
[    0.755577][    T0]  ___slab_alloc+0xd79/0x1680
[    0.756469][    T0]  ? pcpu_alloc_noprof+0x538/0x800
[    0.757408][    T0]  ? __mutex_unlock_slowpath+0x195/0x3e0
[    0.758446][    T0]  __slab_alloc+0x4e/0x70
[    0.759237][    T0]  ? mm_alloc+0x38/0x80
[    0.759993][    T0]  kmem_cache_alloc_noprof+0x1db/0x470
[    0.760993][    T0]  ? mm_alloc+0x38/0x80
[    0.761745][    T0]  ? mm_alloc+0x38/0x80
[    0.762506][    T0]  mm_alloc+0x38/0x80
[    0.763260][    T0]  poking_init+0xe/0x80
[    0.764032][    T0]  start_kernel+0x16b/0x470
[    0.764858][    T0]  i386_start_kernel+0xce/0xf0
[    0.765723][    T0]  startup_32_smp+0x151/0x160

And the reason is we still have restricted gfp_allowed_mask at this point:
/* The GFP flags allowed during early boot */
#define GFP_BOOT_MASK (__GFP_BITS_MASK & ~(__GFP_RECLAIM|__GFP_IO|__GFP_FS))

It's only lifted to a full allowed mask later in the boot.

That means due to "kmalloc_nolock() is not supported on architectures that
don't implement cmpxchg16b" such architectures will no longer get objexts
allocated in early boot. I guess that's not a big deal.

Also any later allocation having its flags screwed for some reason to not
have __GFP_RECLAIM will also lose its objexts. Hope that's also acceptable.
I don't know if we can distinguish a real kmalloc_nolock() scope in
alloc_slab_obj_exts() without inventing new gfp flags or passing an extra
argument through several layers of functions.

>> 
>> 
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>> | Closes: https://lore.kernel.org/oe-lkp/202509171214.912d5ac-lkp@intel.com
>> 
>> 
>> [    7.101117][    T0] BUG: kernel NULL pointer dereference, address: 00000010
>> [    7.102290][    T0] #PF: supervisor read access in kernel mode
>> [    7.103219][    T0] #PF: error_code(0x0000) - not-present page
>> [    7.104161][    T0] *pde = 00000000
>> [    7.104762][    T0] Thread overran stack, or stack corrupted
> 
> Note this.
> 
>> [    7.105726][    T0] Oops: Oops: 0000 [#1]
>> [    7.106410][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G                T   6.17.0-rc3-00014-gdb93cdd664fa #1 NONE  40eff3b43e4f0000b061f2e660abd0b2911f31b1
>> [    7.108712][    T0] Tainted: [T]=RANDSTRUCT
>> [    7.109368][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>> [ 7.110952][ T0] EIP: kmalloc_nolock_noprof (mm/slub.c:5607) 
> 
> That's here.
> if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
> 
> dmesg already contains line "SLUB: HWalign=64, Order=0-3, MinObjects=0,
> CPUs=1, Nodes=1" so all kmem caches are fully initialized, so doesn't look
> like a bootstrap issue. Probably it's due to the stack overflow and not
> actual bug on this line.
> 
> Because of that it's also unable to print the backtrace. But the only
> kmallock_nolock usage for now is in slub itself, alloc_slab_obj_exts():
> 
>         /* Prevent recursive extension vector allocation */
>         gfp |= __GFP_NO_OBJ_EXT;
>         if (unlikely(!allow_spin)) {
>                 size_t sz = objects * sizeof(struct slabobj_ext);
> 
>                 vec = kmalloc_nolock(sz, __GFP_ZERO, slab_nid(slab));
>         } else {
>                 vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
>                                    slab_nid(slab));
>         }
> 
> Prevent recursive... hm? And we had stack overflow?
> Also .config has CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y
> 
> So, this?
> diff --git a/mm/slub.c b/mm/slub.c
> index 837ee037abb5..c4f17ac6e4b6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2092,7 +2092,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	if (unlikely(!allow_spin)) {
>  		size_t sz = objects * sizeof(struct slabobj_ext);
>  
> -		vec = kmalloc_nolock(sz, __GFP_ZERO, slab_nid(slab));
> +		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> +				     slab_nid(slab));
>  	} else {
>  		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
>  				   slab_nid(slab));
> @@ -5591,7 +5592,8 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	bool can_retry = true;
>  	void *ret = ERR_PTR(-EBUSY);
>  
> -	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO));
> +	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
> +				      __GFP_NO_OBJ_EXT));
>  
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> 


