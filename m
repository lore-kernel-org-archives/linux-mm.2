Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4621BCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D39D280008; Thu, 30 Oct 2025 11:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB1A280003; Thu, 30 Oct 2025 11:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A0D280008; Thu, 30 Oct 2025 11:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69537280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:35:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00F4C1A01B6
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:35:56 +0000 (UTC)
X-FDA: 84055181154.10.B0EF62C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id 82CD020010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:35:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rOatV9nf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=obGKZULd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rOatV9nf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=obGKZULd;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761838554; a=rsa-sha256;
	cv=none;
	b=zvPy3LHeLhum0q9/9zQ30kCkkKTQgccsXBAybVbYyk66Wu5KoxvddagpqBry2jMKfpEzhO
	3pleT0rwE0nkRTFAntxDGBOQ6reRFLFjTDL2xh1whvse2wBAhEUscUQ67i+wtqlUY+Qugd
	YFsJS4zPu4uSct1WgopmTrFDjFWfi4A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rOatV9nf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=obGKZULd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rOatV9nf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=obGKZULd;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761838554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZC7sKtccy7Dxtp0h0EbRBUPlnYDttAcegCDflOn07Q=;
	b=slaG80qMFIb5+BNaDwvAduskn0uQRM3ij80QmnQZaaxF05xfp/k0q1s/EA2iQ73rjfMfXP
	yu+mMrMRXvX/TeRR0biQYtyML8IwJAM+JA+CewrzjEByLxRjfHTudVMBbzdQZacM+fndXt
	znFNS6Nh5hyPGGnib5j65fDlqJMfi7w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1F371FB3E;
	Thu, 30 Oct 2025 15:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761838552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ZC7sKtccy7Dxtp0h0EbRBUPlnYDttAcegCDflOn07Q=;
	b=rOatV9nfOZQSA5IRCufIJN1wpSAvq2vgza5Cm+5hfuEbo4Be4MEOYpbRoemqqL8ezSThUX
	Y9Ocl0IO5Dq9S/OEGRJzZhtKB0TEA/5xo4A5Ex17TP9a/Ss4VmnBY909cQQfzgOrkeFaN8
	ZD4KDzvkMPF5V4bOdJ+KmDW+dycNKds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761838552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ZC7sKtccy7Dxtp0h0EbRBUPlnYDttAcegCDflOn07Q=;
	b=obGKZULdFaEWL5nV2PhgzMCw8NuMFbTPrAZ5d4OlErKEObyjj8b19pe169SOCKWX4R/MF+
	22hAZCSCk7om11CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761838552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ZC7sKtccy7Dxtp0h0EbRBUPlnYDttAcegCDflOn07Q=;
	b=rOatV9nfOZQSA5IRCufIJN1wpSAvq2vgza5Cm+5hfuEbo4Be4MEOYpbRoemqqL8ezSThUX
	Y9Ocl0IO5Dq9S/OEGRJzZhtKB0TEA/5xo4A5Ex17TP9a/Ss4VmnBY909cQQfzgOrkeFaN8
	ZD4KDzvkMPF5V4bOdJ+KmDW+dycNKds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761838552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ZC7sKtccy7Dxtp0h0EbRBUPlnYDttAcegCDflOn07Q=;
	b=obGKZULdFaEWL5nV2PhgzMCw8NuMFbTPrAZ5d4OlErKEObyjj8b19pe169SOCKWX4R/MF+
	22hAZCSCk7om11CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 73D221396A;
	Thu, 30 Oct 2025 15:35:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +AqSG9iFA2n+YwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 15:35:52 +0000
Message-ID: <5e8e6e92-ba8f-4fee-bd01-39aacdd30dbe@suse.cz>
Date: Thu, 30 Oct 2025 16:35:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev,
 bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-10-6ffa2c9941c0@suse.cz>
 <aQLqZjjq1SPD3Fml@hyeyoo> <06241684-e056-40bd-88cc-0eb2d9d062bd@suse.cz>
 <CAADnVQ+K-gWm6KKzKZ0vVwfT2H1UXSoaD=eA1aRUHpA5MCLAvA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQ+K-gWm6KKzKZ0vVwfT2H1UXSoaD=eA1aRUHpA5MCLAvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yz6kgs5utx3du6arfj7sp7pgkooetegs
X-Rspamd-Queue-Id: 82CD020010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761838554-267094
X-HE-Meta: U2FsdGVkX18okFiT2FFbFqllJUbR1BKJuAyfJhIseoJFGDlakTDP2t3TxsHk/7hmQony1YOASlsOVYU6+D4dm867TKqaVDJIuxZ+yh7NJcx8F2Mau03BoNyAKl5tCQb8e4ygWXr4S1/ZMwirbRwU51zkY4k6nQHxyQU7G3xofgmH3menmgvepkm3Fznn+rqHnH5ErphWGsxLf/Eo1TB85PMK6G6WPoieezZth397Ux2j3WNiw3KCCX9kvZDlGYvLZaoMgIieYJiQk/Wc8aPepPSST0+FtOFCj8jgfDl6M1jsjfW2B5qyYxmc+D5y/+BeXJqT6Rc0TPmzbx3XP4hMwoDeAd0VaqA7WYFlyLpKnkxbxGO0W71BWjOQdNzdtl4MVsImfmreaZIBThJGtpRzqKOIFwANlPQXOwGfwET0lxixUp4jMLhgRqjXYONVaCF+VgG+lpdygNyj26LnQujhvGwPH30JF7e4NRCJKpFdXZgFceF0Zfc0s44/G17qKtXkv/1F4HKpuBy7u4qsou/XT5GExxIX2d09UeKf31/ehn1jrPJtl9+/w33HX1vcT3ukCqZeLvR7GENJdsDRxCGQ/K++IYVCJ+Yd/NOwLGDMCcdKAnLGGAR3JImDtqYkvIoGKf2S1FYCGtIwld4w3bYir/WChmj4qV+aIwmkfMkCtAA6blsBND56KBTX/vFVotL+nJMOh01k0o8EcHU1MX60v6Xbhlc1lTB0Ep8XD9obhlns2Ur0TeKeTenm9IjtBrP/yyp0R0+QfezlLnbXNzThUMGqCmjoC8h2F5EYSMFezVlu/ko+t/sQcK7pg3IXic+mYZINFHorunUcwDbAtTO2lWrpQNB8Z3xZXO8DVWLK4jHYLQwWNIsqsWrEW7flWyAInVjMlwTIZjBIeWfr8bRbfWCDBr++uBnNXrXV4K75qwYS2xVs62AsyBX9/DeSz0dUJ08OLbwu3mUFulvU2PQ
 nVc/Tne7
 KQdAW3tlTVEqWfMoNxJbLKsCykbevPc51Cnel+wkrkvQuJXzpdrjTVaAIVuCE8tIAsYSP9JiMarDIAEtA9cpculxW1sd/TEkuejJqpTB7/Ic7U2TW4q1zBAjB076zR4BoIXEShQ5YJK1ybQC4TTHC6lCoHyKF7OEK5e6llOudZaCf6xNutjHURCRFOKvitWD+bGlZ9SHGPN8TYxz8V7S1U4zpasYo+eKxBQNX3G7/LOm6ElTkyqJjDrjiFLUIegB1OkBeFwo0Lqg2Hxcx3Y1eHdQWRweewV8QwY1IPiu5kxZ46NlbufmORa30s847aSo4XXEUYCW4Xn+YGF+BNmn2YDvD85/rw6g+aNj3KE4r0fgJQ+6y1Z3Wf14MxPzDQCmWGu5r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 16:27, Alexei Starovoitov wrote:
> On Thu, Oct 30, 2025 at 6:09 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 10/30/25 05:32, Harry Yoo wrote:
>> > On Thu, Oct 23, 2025 at 03:52:32PM +0200, Vlastimil Babka wrote:
>> >> diff --git a/mm/slub.c b/mm/slub.c
>> >> index e2b052657d11..bd67336e7c1f 100644
>> >> --- a/mm/slub.c
>> >> +++ b/mm/slub.c
>> >> @@ -4790,66 +4509,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
>> >>
>> >>      stat(s, ALLOC_SLAB);
>> >>
>> >> -    if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
>> >> -            freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>> >> -
>> >> -            if (unlikely(!freelist))
>> >> -                    goto new_objects;
>> >> -
>> >> -            if (s->flags & SLAB_STORE_USER)
>> >> -                    set_track(s, freelist, TRACK_ALLOC, addr,
>> >> -                              gfpflags & ~(__GFP_DIRECT_RECLAIM));
>> >> -
>> >> -            return freelist;
>> >> -    }
>> >> -
>> >> -    /*
>> >> -     * No other reference to the slab yet so we can
>> >> -     * muck around with it freely without cmpxchg
>> >> -     */
>> >> -    freelist = slab->freelist;
>> >> -    slab->freelist = NULL;
>> >> -    slab->inuse = slab->objects;
>> >> -    slab->frozen = 1;
>> >> -
>> >> -    inc_slabs_node(s, slab_nid(slab), slab->objects);
>> >> +    freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
>> >>
>> >> -    if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
>> >> -            /*
>> >> -             * For !pfmemalloc_match() case we don't load freelist so that
>> >> -             * we don't make further mismatched allocations easier.
>> >> -             */
>> >> -            deactivate_slab(s, slab, get_freepointer(s, freelist));
>> >> -            return freelist;
>> >> -    }
>> >> +    if (unlikely(!freelist))
>> >> +            goto new_objects;
>> >
>> > We may end up in an endless loop in !allow_spin case?
>> > (e.g., kmalloc_nolock() is called in NMI context and n->list_lock is
>> > held in the process context on the same CPU)
>> >
>> > Allocate a new slab, but somebody is holding n->list_lock, so trylock fails,
>> > free the slab, goto new_objects, and repeat.
>>
>> Ugh, yeah. However, AFAICS this possibility already exists prior to this
>> patch, only it's limited to SLUB_TINY/kmem_cache_debug(s). But we should fix
>> it in 6.18 then.
>> How? Grab the single object and defer deactivation of the slab minus one
>> object? Would work except for kmem_cache_debug(s) we open again a race for
>> inconsistency check failure, and we have to undo the simple slab freeing fix
>>  and handle the accounting issue differently again.
>> Fail the allocation for the debug case to avoid the consistency check
>> issues? Would it be acceptable for kmalloc_nolock() users?
> 
> You mean something like:
> diff --git a/mm/slub.c b/mm/slub.c
> index a8fcc7e6f25a..e9a8b75f31d7 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4658,8 +4658,11 @@ static void *___slab_alloc(struct kmem_cache
> *s, gfp_t gfpflags, int node,
>         if (kmem_cache_debug(s)) {
>                 freelist = alloc_single_from_new_slab(s, slab,
> orig_size, gfpflags);
> 
> -               if (unlikely(!freelist))
> +               if (unlikely(!freelist)) {
> +                       if (!allow_spin)
> +                               return NULL;
>                         goto new_objects;
> +               }
> 
> or I misunderstood the issue?

Yeah that would be the easiest solution, if you can accept the occasional
allocation failures.

