Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1AA5E7E0D0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1086A6B0089; Mon,  9 Feb 2026 14:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5B06B008A; Mon,  9 Feb 2026 14:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7246B008C; Mon,  9 Feb 2026 14:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDE9D6B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:03:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CF02578C5
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:03:29 +0000 (UTC)
X-FDA: 84425841738.08.F39FAAD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 197DA40013
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:03:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h9jdi9c+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3SKWIJ4Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h9jdi9c+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3SKWIJ4Z;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xK0puEGN5CRYnbu6E9/dBnWPkeOm/WK3mwAREKitcdo=;
	b=RqSHXflD48KTOUlyzm3tLrJEu3SoztYOfLfJU21lQp2RMumBJomHf2RlrwklRmMKHp3Yr6
	LSzIoQgMxasin4w3fRy+6jYTHBGd46aAJnDgyn12rdZ8pzA6xcAYcjYPaEC8WS6R05vohB
	qx2vYaSVT7Q4GoPlv0CTlsRAZXxiW9k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h9jdi9c+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3SKWIJ4Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=h9jdi9c+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3SKWIJ4Z;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663807; a=rsa-sha256;
	cv=none;
	b=kRtdY5K8YyEw1zOH9qhQKfmyiIaSwv/RPU+Zcp49rM3CA+7eEfLz40UTJh/cTYiv+I5Z3V
	EsQgWe9cN1r6dLK2OKAyvZQkdNenre7wGxFzI1KpZP0FFqZ0auvw0NYqRtOtJXQx0cByjx
	B7MagGHoU3tN4oL7Un9/UOkUjt9zHLI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 816B15BD12;
	Mon,  9 Feb 2026 19:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770663805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xK0puEGN5CRYnbu6E9/dBnWPkeOm/WK3mwAREKitcdo=;
	b=h9jdi9c+N23fVWpR2APyCg8uR4N79LD+wcL0d7+NdCFiX3ICTje5Xw8gyryV480/Gq9K3q
	hdnN5pweaMNE6VVpmIDGgkbyTt37wFkBKa8CvpcVRi+cJLv60yyK0R7I+aOTaoMXV0eGm3
	GbsswrYuQKRP5vQPQJXPPuLXFKsO00s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770663805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xK0puEGN5CRYnbu6E9/dBnWPkeOm/WK3mwAREKitcdo=;
	b=3SKWIJ4Z5F9/GuR+cSy15++RNxymOjCE2RS7j6zd4Kemmc4Fap+fB1RJPyOdPFfJP4NPbU
	UytmpD8dKVy2zdBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770663805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xK0puEGN5CRYnbu6E9/dBnWPkeOm/WK3mwAREKitcdo=;
	b=h9jdi9c+N23fVWpR2APyCg8uR4N79LD+wcL0d7+NdCFiX3ICTje5Xw8gyryV480/Gq9K3q
	hdnN5pweaMNE6VVpmIDGgkbyTt37wFkBKa8CvpcVRi+cJLv60yyK0R7I+aOTaoMXV0eGm3
	GbsswrYuQKRP5vQPQJXPPuLXFKsO00s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770663805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xK0puEGN5CRYnbu6E9/dBnWPkeOm/WK3mwAREKitcdo=;
	b=3SKWIJ4Z5F9/GuR+cSy15++RNxymOjCE2RS7j6zd4Kemmc4Fap+fB1RJPyOdPFfJP4NPbU
	UytmpD8dKVy2zdBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 501C13EA63;
	Mon,  9 Feb 2026 19:03:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aQo6E30vimnRUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 09 Feb 2026 19:03:25 +0000
Message-ID: <a972a203-d4c5-4161-b9e6-42fbf733d75a@suse.cz>
Date: Mon, 9 Feb 2026 20:03:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: skip get_from_any_partial() if !allow_spin
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 linux-mm <linux-mm@kvack.org>, stable <stable@vger.kernel.org>
References: <20260206171348.35886-1-harry.yoo@oracle.com>
 <20260206171348.35886-2-harry.yoo@oracle.com>
 <2ce1eac3-98fd-448f-8a73-01bb3cb5a7d5@suse.cz>
 <CAADnVQ+1RBXBWNQtshEfFNZEp0tDZOFKf_vedyjgdz=wqWdG8A@mail.gmail.com>
 <aYlR_KW8xj4LJaYt@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYlR_KW8xj4LJaYt@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 197DA40013
X-Rspamd-Server: rspam07
X-Stat-Signature: 5ssf77expkbm6rbfh1hghjmfdwtyt9fw
X-HE-Tag: 1770663806-107036
X-HE-Meta: U2FsdGVkX1/d0I1vqZtz7rVEgTJr5gGWOCChNmSCplHveT/u8pF4nhHx2W6Pwv/MUO9nPeXE9poHFGvmR2+jAHjERb9gEqFMEgcW8Up2m4KF1/aBgUWa7hrGKzX7/z0uCrLDTKva4oIYGylazLPWgWpfxsa84oLKKdfNyAzR5xB9e6Y+pCGW2H92bNGyJeViXfK4oDUjGeW2aqYnNFovRzAwxRcDkOZXCpWl33AGCQ1kgdiHo+QEcF26WJCcH2azr5aXxVH6YoecOyDsHoUtWzP/wpTjl7GZEwYt24DUjln1ZrjEZQCxvfCqsqTM1WzspJo+HqyR6VpB6R0GJCRWs1l7V3hJr+Mlr2718/fKIHS4U16NN+TW+q7JBkwVttMFfbGPhoHgYCGusfBePMluAtt3qd4K1RDn/ibz2redj/fSD1hxPWxQc64SrQ+ZVxrX/LrE6OiawHjWNhG5PBjYC5sCA64CeAXIUjpp6ToyXrqN3VVZb1TBaovhv1mXwP/JFyYBkkw39aFKhOZ1gZuLSH60HNIt02XM4vNPDmNbJMS+S/MNivbYMMAdcTHowtzAu7dCvRFfHPC8oCCJ4O5a0Bdou9ubpKlRpNXtxRB4/2QQAHYmhCDT1UGxh6ymTVcUsKLO+bs6BBnQQwHKhIO19CdhCeKY/QOkiVv0LN5ZIDxbFtrV7nVBOt8wxL7NCVEoCF0NjjbGFd7Pg5KllEjZWnaQwTOYpZ1ArWjIjTmfRxpmcqD9m9tazoGZbExABaY+84WeKEbf8lxtUiGaVfQj4PYLKZMBVC2uHoy/RoPuwx5feIeJxOdH8JGEyknpmU2OQgzzWZvVLtvOFhAjU3JoKlnYCyUAZi1W2R2DmhetFEmNLODkwez/6MZjqYjvYm6HCxNfSmAK6gdy+zdIDPW9T6qRV1l87/6mIsQEOfBikkfyf7KpG61riFtFagjVhldobtbTlmTyoHWESOZCdai
 CwFx2bv1
 iDEaj1duCo5tJjt4w2PcqiW0YarqGz+e4ylTTCPfceBlTYKb8yEVsT9QRVeFHAL569NPCu/Q+0lfRJ70BZnz+EmGp17sOakjgicvYdNmKb9dVm2wddBCM+ybWssZyR1wka69Qwb6iUp2gn0k90dF045UjCVR1nItkf96AQRo3nu9tJehZpyEud9JjICbMWSu2xCaKJEkuj/Q1oIW9vcQo2zzMKSHtZEDzF0arK9DgcYEfeR3NPdDcnjAi5TJLmPeCEEEtxEERHQyED/t9rEOKZtaCiNf/xrJeAhCHJ3XG/2zro+OT5vslYGOiTwJJZlOQN8IklrxZ3a9/DR8xIQqFEIp0pn5iC4PsK0AS4TgyTQ1hgh1bYF7R9Cv/mGoLux4ff7UclO6pdgdHGVAA4kAdP55V67J2SgEulahxT1LP3dWgxFKZK7L3z79VEHZ+75bqKfy0c8iw4wT1TB7mg3+L5s9qwCmH/DPP2DOqWKPG2Q9D6QY7b7Xr04FmNP4zWmYoWJN2is81mZs99To=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 04:18, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 11:19:01AM -0800, Alexei Starovoitov wrote:
>> On Fri, Feb 6, 2026 at 10:10 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> >
>> > On 2/6/26 18:13, Harry Yoo wrote:
>> > > Lockdep complains when get_from_any_partial() is called in an NMI
>> > > context, because current->mems_allowed_seq is seqcount_spinlock_t and
>> > > not NMI-safe:
>> > >
>> > >   ================================
>> > >   WARNING: inconsistent lock state
>> > >   6.19.0-rc5-kfree-rcu+ #315 Tainted: G                 N
>> > >   --------------------------------
>> > >   inconsistent {INITIAL USE} -> {IN-NMI} usage.
>> > >   kunit_try_catch/9989 [HC1[1]:SC0[0]:HE0:SE1] takes:
>> > >   ffff889085799820 (&____s->seqcount#3){.-.-}-{0:0}, at: ___slab_alloc+0x58f/0xc00
>> > >   {INITIAL USE} state was registered at:
>> > >     lock_acquire+0x185/0x320
>> > >     kernel_init_freeable+0x391/0x1150
>> > >     kernel_init+0x1f/0x220
>> > >     ret_from_fork+0x736/0x8f0
>> > >     ret_from_fork_asm+0x1a/0x30
>> > >   irq event stamp: 56
>> > >   hardirqs last  enabled at (55): [<ffffffff850a68d7>] _raw_spin_unlock_irq+0x27/0x70
>> > >   hardirqs last disabled at (56): [<ffffffff850858ca>] __schedule+0x2a8a/0x6630
>> > >   softirqs last  enabled at (0): [<ffffffff81536711>] copy_process+0x1dc1/0x6a10
>> > >   softirqs last disabled at (0): [<0000000000000000>] 0x0
>> > >
>> > >   other info that might help us debug this:
>> > >    Possible unsafe locking scenario:
>> > >
>> > >          CPU0
>> > >          ----
>> > >     lock(&____s->seqcount#3);
>> > >     <Interrupt>
>> > >       lock(&____s->seqcount#3);
>> > >
>> > >    *** DEADLOCK ***
>> > >
>> > > According to Documentation/locking/seqlock.rst, seqcount_t is not
>> > > NMI-safe and seqcount_latch_t should be used when read path can interrupt
>> > > the write-side critical section. In this case, return NULL and fall back
>> > > to slab allocation if !allow_spin.
>> > >
>> > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> > > ---
>> > >  mm/slub.c | 8 ++++++++
>> > >  1 file changed, 8 insertions(+)
>> > >
>> > > diff --git a/mm/slub.c b/mm/slub.c
>> > > index 102fb47ae013..d46464654c15 100644
>> > > --- a/mm/slub.c
>> > > +++ b/mm/slub.c
>> > > @@ -3789,6 +3789,14 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>> > >       enum zone_type highest_zoneidx = gfp_zone(pc->flags);
>> > >       unsigned int cpuset_mems_cookie;
>> > >
>> > > +     /*
>> > > +      * read_mems_allow_begin() accesses current->mems_allowed_seq,
>> > > +      * a seqcount_spinlock_t that is not NMI-safe. Skip allocation
>> > > +      * when GFP flags indicate spinning is not allowed.
>> > > +      */
>> > > +     if (!gfpflags_allow_spinning(pc->flags))
>> > > +             return NULL;
>> >
>> > I think it would be less restrictive to just continue,
> 
> Ack.
> 
>> > but skip the
>> > read_mems_allowed_retry() part in the do-while loop, so just make it one
>> > iteration for !allow_spin.
> 
> Makes sense.
> 
>> > If lockdep doesn't like even the
>> > read_mems_allowed_begin() (not clear to me), skip it too?
> 
> Yes, lockdep doesn't like read_mems_allowed_begin(), and thus
> we should skip both.
> 
>> 
>> +1
>> Just unconditional return NULL seems too restrictive.
> 
> Ack.
> 
> I'll do something like this:

Looks good!

> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 102fb47ae013..cc686ab929fe 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3788,6 +3788,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  	struct zone *zone;
>  	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
>  	unsigned int cpuset_mems_cookie;
> +	bool allow_spin = gfpflags_allow_spinning(pc->flags);
> 
>  	/*
>  	 * The defrag ratio allows a configuration of the tradeoffs between
> @@ -3812,7 +3813,15 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  		return NULL;
> 
>  	do {
> -		cpuset_mems_cookie = read_mems_allowed_begin();
> +		/*
> +		 * read_mems_allow_begin() accesses current->mems_allowed_seq,
> +		 * a seqcount_spinlock_t that is not NMI-safe. Do not access
> +		 * current->mems_allowed_seq and avoid retry when GFP flags
> +		 * indicate spinning is not allowed.
> +		 */
> +		if (allow_spin)
> +			cpuset_mems_cookie = read_mems_allowed_begin();
> +
>  		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
>  		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
>  			struct kmem_cache_node *n;
> @@ -3836,7 +3845,7 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
>  				}
>  			}
>  		}
> -	} while (read_mems_allowed_retry(cpuset_mems_cookie));
> +	} while (allow_spin && read_mems_allowed_retry(cpuset_mems_cookie));
>  #endif	/* CONFIG_NUMA */
>  	return NULL;
>  }
> 
> 


