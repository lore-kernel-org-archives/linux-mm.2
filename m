Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA371CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31418E003D; Thu,  2 Oct 2025 04:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08988E003C; Thu,  2 Oct 2025 04:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7F88E003D; Thu,  2 Oct 2025 04:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4678E003C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:15:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A7AD1191B7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:15:00 +0000 (UTC)
X-FDA: 83952463560.14.6B42215
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id EC556180009
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:14:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWWzcd77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzrHfhez;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWWzcd77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzrHfhez;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkJWMOW654A2NQw8DnXLLcGrKiRsoRYbhX3pXplYai4=;
	b=Gk7iTdUqI8UD79pMlrGIucCombfKNvM/BG1JG1HEeELz42WScpry+3VrK3nBsIFsca5ynX
	a8ty3lD4rJiOjg4qWR0yNQioK8dC8wtHIQWnEsAKgYvwpHZbB304dp7QTJSaSOWi/lcplK
	bHfvxy4a1n+eCtug3T5Szc8K1w9HU/M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWWzcd77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzrHfhez;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VWWzcd77;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzrHfhez;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392898; a=rsa-sha256;
	cv=none;
	b=cI67D9XgkJbPqbRZnvfrCyR90fXkHbhZbaLNVSQbesZcBbg9Jh3zf9EKa4FB8bae6SNxA5
	NUh+xraA0lOCLwpWd3xfmLgxA9HdKE3KZ8S5745CLZAQqc/yuvfRbe1Ks6IsVawiiyjfj5
	40apAPYcokK9MNw2GIfD+JWbb4D7tzs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E1D633769;
	Thu,  2 Oct 2025 08:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759392896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JkJWMOW654A2NQw8DnXLLcGrKiRsoRYbhX3pXplYai4=;
	b=VWWzcd77OjwQ1CbNz6wrB7HcE5ZvWwfEUkURc3y3JjflQ/svq3PHm/78SGC3znYDVL4A7u
	9EiCaHDxJQi3fnbRjTcc6T4MxJVjAsjMAxoWBaaSUw2MMXgwuwI6iBGtC/dqHGp/QZRS8p
	LtV4RrvMuTYxib2G4//qpbBYE9Sxpio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759392896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JkJWMOW654A2NQw8DnXLLcGrKiRsoRYbhX3pXplYai4=;
	b=UzrHfhezFDoU19SNap9yR9071ng3xTx3wtGzgYa113dsd27cl8xwYoW5RqcKamC44qZuea
	MIBCocsuEVJV0mAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759392896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JkJWMOW654A2NQw8DnXLLcGrKiRsoRYbhX3pXplYai4=;
	b=VWWzcd77OjwQ1CbNz6wrB7HcE5ZvWwfEUkURc3y3JjflQ/svq3PHm/78SGC3znYDVL4A7u
	9EiCaHDxJQi3fnbRjTcc6T4MxJVjAsjMAxoWBaaSUw2MMXgwuwI6iBGtC/dqHGp/QZRS8p
	LtV4RrvMuTYxib2G4//qpbBYE9Sxpio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759392896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JkJWMOW654A2NQw8DnXLLcGrKiRsoRYbhX3pXplYai4=;
	b=UzrHfhezFDoU19SNap9yR9071ng3xTx3wtGzgYa113dsd27cl8xwYoW5RqcKamC44qZuea
	MIBCocsuEVJV0mAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA0C51395B;
	Thu,  2 Oct 2025 08:14:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1MWRNn803mjkUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 02 Oct 2025 08:14:55 +0000
Message-ID: <b9fb0a69-6cfb-4285-8118-ef5301115948@suse.cz>
Date: Thu, 2 Oct 2025 10:14:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: ranxiaokai627@163.com, Andrew Morton <akpm@linux-foundation.org>,
 cl@gentwo.org, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, ran.xiaokai@zte.com.cn
References: <20250930083402.782927-1-ranxiaokai627@163.com>
 <aNu2xJMkEyYSdmW6@hyeyoo>
 <CAADnVQJ-bkd2UVsZmhdb1L5ZrXjZbTnRcaJ-D=ojsoiRHmHwaw@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQJ-bkd2UVsZmhdb1L5ZrXjZbTnRcaJ-D=ojsoiRHmHwaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC556180009
X-Stat-Signature: ukh867q5prdty9mjk57fuxtbyk995mj8
X-HE-Tag: 1759392897-315927
X-HE-Meta: U2FsdGVkX1+AbGM+OLHZNMRohWllV+W26GzG0BSF92k9JIkXExH9+Cm5+K+pyctW7XE8ByOMVg6ZWsJfSYvHrKCalm+PPRiOg4oqWYQPecrM32XSczrsRRLytnlf7QlK3FewJhWZ48bybyuCmmHRE8YQEJpjhqfwOrYeaMiHFVBfBGHx9yanRGGTfPRjP08gqaWyC1fXsymqqqlwnomUvNP90Vya/TiAiIS9kJbhSaUY9kVhQYmyDRNjyG8zUb07g8J9nhGrEt80CQSybIW3ffPDA1VpEU02NGUrV7CAtA51EqlOcq4zWfjQriLPF9SubicdLNGXBFi0kz1hn+CAomediMO63NTKHv09cfDluCvdd3zZO3w2UstKNfBXUdH2ps+sdeGIBYm5hXrzVcqa6/JXb+04U5TmeD9Ew1HhyTukd6TDV/0TCxVeLkoNUmMOwqcUhq/53f88agOYVWOcULV4DAZo3yRX1ekgYfTNuYZbDDKW/ENqnB0j4NYflMZHcPHzf/sis3qwty+cYOiOryWNL5MsS+rN+BOieW6whj+Mc3KJSuSvoMnjpM3P6amop8EWl6sC1dG93Atv/bYuFSN07hqyO86cfblUy9dwNSx62qnDkmG5LG+mc/ins3HqHpGyEruK+nW1FRpswt6DiST4f0UexEosQGHZY/y3yDeaiHDNxjsXhLF0r79q9/gzei38/piG5Uj+NgaxecliDFQA0vYq1+mt+mXA1YwjEk4VMZy5YVggx8Wp7j3JbFsAIX64qW7xFceHPFysqHFNJD1gwxwHl7jYHknmKZANwwWIQqgZixmY2Z78emnXRntPVf7tcM2f3lhQV8uBL+d07LE8vej39TTgWuC1Po8cKllpOT7WRr7c/te+Emvt/vU7DxLVzzOyKnrOHMG6xOe+1Eiz8iGW3N3/3xm3vfENMHOm9vD1lN7LBYc6uO3wo440g52jAsvuKmi6XJASUbW
 r4gMc82b
 LcBdvTNUiFPMsVuy3SXIE4Xga/Gq/SlfRkfCtlhpfoJq9I1+ZUIvi9z8SFs1Ni8Mk5+qD6K/OxarA2uXanOhLibae5d98EkqISUUU1W9P7B2MCTshPFCRmprsGn7ZX9Eo5Fuaol4Vm4Z9XiEJm7OZsxbLR01iqFyg8G7bOhOv4O4SGMvYLpyw77azA3yzc2N+JkpJNTRlEBGxShhHludq7BBpDuk2fdJ0YkQPJw5JFNYLiSNlDoBEVidLrRzv6TZ5kFi3JVoyJPNINKWmRxEHqZr++rYKvPJZ/DVnS9/+7enUcrlSK2TtmkvZbURV7AXvKkoyRSKQaivc5RsOZrrRyFyW6ktlFho0yhvEsvPzsB+bT3habc7Q0o5Ck8BFb9LihLewkQLXm5AtvF6Fg5lWFGHSKsRapGHxtINuXuFV1TsUOs5ATRqpylnANnD7fHyM94AUsyVL2c30uBz5K8c52vO3rLQu8StJ/kJRcgEfm0PsrzhclioB8T6RbaeqGX4SJeBAd17A2V1k5KR+aOpJ2Km+ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 13:19, Alexei Starovoitov wrote:
> On Tue, Sep 30, 2025 at 12:54 PM Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>> On Tue, Sep 30, 2025 at 08:34:02AM +0000, ranxiaokai627@163.com wrote:
>> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> >
>> > defer_free() maybe called in preemptible context, this will
>> > trigger the below warning message:
>> >
>> > BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
>> > caller is defer_free+0x1b/0x60
>> > Call Trace:
>> >  <TASK>
>> >  dump_stack_lvl+0xac/0xc0
>> >  check_preemption_disabled+0xbe/0xe0
>> >  defer_free+0x1b/0x60
>> >  kfree_nolock+0x1eb/0x2b0
>> >  alloc_slab_obj_exts+0x356/0x390
> 
> Please share config and repro details, since the stack trace
> looks theoretical, but you somehow got it?
> This is not CONFIG_SLUB_TINY, but kfree_nolock()
> sees locked per-cpu slab?

Could it be just the "slab != c->slab" condition in do_slab_free()? That's
more likely. However...

> Is this PREEMPT_RT ?
> 
>> >  __alloc_tagging_slab_alloc_hook+0xa0/0x300
>> >  __kmalloc_cache_noprof+0x1c4/0x5c0
>> >  __set_page_owner+0x10d/0x1c0

This is the part that puzzles me, where do we call kmalloc from
__set_page_owner()? And in a way that it loses the GFP_KERNEL passed all the
way? I don't even see a lib/stackdepot function here.

>> >  post_alloc_hook+0x84/0xf0
>> >  get_page_from_freelist+0x73b/0x1380
>> >  __alloc_frozen_pages_noprof+0x110/0x2c0
>> >  alloc_pages_mpol+0x44/0x140
>> >  alloc_slab_page+0xac/0x150
>> >  allocate_slab+0x78/0x3a0
>> >  ___slab_alloc+0x76b/0xed0
>> >  __slab_alloc.constprop.0+0x5a/0xb0
>> >  __kmalloc_noprof+0x3dc/0x6d0
>> >  __list_lru_init+0x6c/0x210

This has a kcalloc(GFP_KERNEL).

>> >  alloc_super+0x3b6/0x470
>> >  sget_fc+0x5f/0x3a0
>> >  get_tree_nodev+0x27/0x90
>> >  vfs_get_tree+0x26/0xc0
>> >  vfs_kern_mount.part.0+0xb6/0x140
>> >  kern_mount+0x24/0x40
>> >  init_pipe_fs+0x4f/0x70
>> >  do_one_initcall+0x62/0x2e0
>> >  kernel_init_freeable+0x25b/0x4b0

Here we've set the full gfp_allowed_mask already so it's not masking our
GFP_KERNEL.

>> >  kernel_init+0x1a/0x1c0
>> >  ret_from_fork+0x290/0x2e0
>> >  ret_from_fork_asm+0x11/0x20
>> > </TASK>
>> >
>> > Replace this_cpu_ptr with raw_cpu_ptr to eliminate
>> > the above warning message.
>> >
>> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
>>
>> There's no mainline commit hash yet, should be adjusted later.
>>
>> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> > ---
>> >  mm/slub.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/mm/slub.c b/mm/slub.c
>> > index 1433f5b988f7..67c57f1b5a86 100644
>> > --- a/mm/slub.c
>> > +++ b/mm/slub.c
>> > @@ -6432,7 +6432,7 @@ static void free_deferred_objects(struct irq_work *work)
>> >
>> >  static void defer_free(struct kmem_cache *s, void *head)
>> >  {
>> > -     struct defer_free *df = this_cpu_ptr(&defer_free_objects);
>> > +     struct defer_free *df = raw_cpu_ptr(&defer_free_objects);
>>
>> This suppresses warning, but let's answer the question;
>> Is it actually safe to not disable preemption here?
>>
>> >       if (llist_add(head + s->offset, &df->objects))
>>
>> Let's say a task was running on CPU X and migrated to a different CPU
>> (say, Y) after returning from llist_add() or before calling llist_add(),
>> then we're queueing the irq_work of CPU X on CPU Y.
>>
>> I think technically this should be safe because, although we're using
>> per-cpu irq_work here, the irq_work framework itself is designed to handle
>> concurrent access from multiple CPUs (otherwise it won't be safe to use
>> a global irq_work like in other places) by using lockless list, which
>> uses try_cmpxchg() and xchg() for atomic update.
>>
>> So if I'm not missing something it should be safe, but it was very
>> confusing to confirm that it's safe as we're using per-cpu irq_work...
>>
>> I don't think these paths are very performance critical, so why not disable
>> preemption instead of replacing it with raw_cpu_ptr()?
> 
> +1.
> Though irq_work_queue() works for any irq_work it should
> be used for current cpu, since it IPIs itself.
> So pls use guard(preempt)(); instead.

Agreed. But we should fix it like this. But the report is strange.

