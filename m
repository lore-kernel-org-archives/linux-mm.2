Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AB7CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3A08E0065; Fri, 24 Oct 2025 04:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E849B8E0042; Fri, 24 Oct 2025 04:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D739C8E0065; Fri, 24 Oct 2025 04:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C31F28E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:55:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9388F49540
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:55:33 +0000 (UTC)
X-FDA: 84032399346.05.B36FE2A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id EB479180003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:55:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SP+d1Wjm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L4aMDqGN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ViM7REKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V11R2PpN;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761296131; a=rsa-sha256;
	cv=none;
	b=PjZfdhq1+92et3CkmsroA5/QMdK24W5wAOK+cKvY+IN4gnL+Pb7WXMnOWw6e/JOQi28MAw
	8J16aVeSTp22W5+p6e2munaATg++lSCdJcR/7lrqrT2U46Ntxk256eooF5O8FP56qdFXzF
	FCYwor5XENt2Up1iBw5WaSLFlEu6fu4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SP+d1Wjm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L4aMDqGN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ViM7REKv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V11R2PpN;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7xd5FsXH3CxwwVdNyz0MMVBz/F/RGH8n7yRI0uNzew=;
	b=uZSNXd5rTP1i1wdn2AVXQtUBNs3tnwQRskdFmDjyDXg+IM7fhHieQ6yL+XyXIq8WcHM9wI
	rVZOBnowzyMMalEq3O+TdByNPW/rAC9iF4zpXQVu2TMMUyDLXsN6EbRGcF2VVXbEVqHwdB
	V2O17v8TVa5HrFofe4D22385fKez6ZE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2A9BC211C9;
	Fri, 24 Oct 2025 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761296125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q7xd5FsXH3CxwwVdNyz0MMVBz/F/RGH8n7yRI0uNzew=;
	b=SP+d1WjmDdgsHnEGw2G1CerEczGiFzvsFK7VQlL/Nl2+l8CC6T47fNkY7PfWwKSFO0G+6L
	hLgGB8hc0J5InC2iwRQvk3/i3f2iBGOcaXFjKXOLuWe9gOjLOSLcDHgOMz+p6WjBUdpptO
	E64I307Mx/nOnC6d18l9lCtFZpgS1og=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761296125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q7xd5FsXH3CxwwVdNyz0MMVBz/F/RGH8n7yRI0uNzew=;
	b=L4aMDqGN98kAtp3BOuvMXx2zuMNuPZXtyhZQFZXItFMUcSor6RMA0Jt382Mcgkw5hq4a5i
	LaVLtMuqwvItElAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761296121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q7xd5FsXH3CxwwVdNyz0MMVBz/F/RGH8n7yRI0uNzew=;
	b=ViM7REKvXLlIvhHC+qMEpn/HiXEaQT4PBEQ2v7R2RDSNkNqzDbB3KlcfEGNRnY7gHXS6P6
	lF2jiGtT0a9qQz9PJ53ra0EOD96QVJ5hIZvFGLg99oDR9oTqYjOhn4nEESiClZbay2/tzQ
	aUT9BinftuJMnWbm0p9eQ01vJ8JfzDI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761296121;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q7xd5FsXH3CxwwVdNyz0MMVBz/F/RGH8n7yRI0uNzew=;
	b=V11R2PpNm7cRMG7GypNAgLV8eiI7xjbRMU3DvKuo+YEkOqf/LZvQ3CwtsexBiaazELkkiP
	SVXOaSrqe3gQu3Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15D90132C2;
	Fri, 24 Oct 2025 08:55:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t/f8BPk++2iJcAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 24 Oct 2025 08:55:21 +0000
Message-ID: <cee707e7-b7f7-4c21-8887-2cb69d73df93@suse.cz>
Date: Fri, 24 Oct 2025 10:55:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to
 defer_deactivate_slab()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
 <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
 <aPrBp_vG_D-8qG_E@hyeyoo>
 <CAADnVQK+3GLbq4GjOYO0Q6vhURPyNyy70bZKUUwRpLuK-R8NAA@mail.gmail.com>
 <aPrecUasNUbEkLlS@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aPrecUasNUbEkLlS@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB479180003
X-Stat-Signature: r4d1tif74mdj1fe3t9cndx5et1u85wu3
X-HE-Tag: 1761296130-909222
X-HE-Meta: U2FsdGVkX1/mH0whbpTANehIdvFAN03wxlnAj3/v+M+URQQ8v+g+cJt8A+crGqdlQXMfvoAGS8MW967O9y/nqfkw61Y2diDZ3AFau3osPM1MhEzmAdfHKcgzd4+dMIZQxL3l0J9FnOswnZDxlY9xGKMSNGak3Ge0YtcBfHhKBXB4IEXn/ZFbx7cGwMyn9cfY3KfCHfiXHOYp+hVm6qQSUpNExXyFTW92Yh7/1ZILJlqnlgQq3XW6AzGOiktV5awUvmQL8NeDQf4ugUeoGexCbA+EU0eqa5BOQt4KjCYHBN6SHVnqN77ZFc9mLjExttcRgbg7RnlHcl7EDdXcO/Oc6dERKXUdnZd6Vqbm65hd3tSaIyDQnWMql8O7KNuvsKGCK6A7n/chtWpGBa5wRws9uS+fwWXe6e1KkPrr0Ky7dHifoKFB3E0Qe80UeQQmlYw0z8MOsc9eVNosUWfcUZvaoMfaK+KpO92TWAVtrRw9D/K6bDIidmzTmbCLxjHD1/UX039JJHBJha6vDOBBriuYZH7T+0jVGfrpGihL5I8mTmz2FG3DdCXhxntQE6wp9SNUyk41knhylmLAVXDU1gi/tWoK0bVCeWaoGjHpRC7Tn18kbHjx2304otbGHSQVPy4AYmWtDoapmyZ57cH746dUhV5vsdH8Ar/vfIsf9C+Srq4gYKUGMpVS2ODJra/OslcgQ0/CczionQMUQcqjPt4zvLz9aX++pvIBjAf5wPwDO2gEX36YAIsJLT1muTnmo7TvXMtp2s2RxLX5WSJJAWFkZLXvc6JtIa+xdZv+5XT+y14wC5aEjG3g4ezkKItJ95uD6VM/JmkFolG1+XCDXVeGHTxPUJInmShLv45V2UauWJZ7Ec5vE/PiVgXlM0vTVkIbLwOAH1jNAh8DfscxhPY8C/N6TcJrQNSaPvlW0AwqVV8hN74T8kYC3rRI8oLAODMCZWrAMzm1gUBCgy9n+y6
 CjXygAQ3
 4uL/lnNX1EfN1wSl67Q8rCYTzINAI+axiRjRlQrR0HEAj2v8qUoJO4Ib5aevkJZzKtUZBSV6MD+inRsEB8ib2wenFH4NJVom6X24Ds1Hg7C7yGtNxPJ97UeSURIvH5XhxgIqUtWrf+KEZNRhoBYz9eYu4S2Sfx3I7EPCfjWsCC1NCcmsAcbt1btAhkMc5VVQdo2GD5rh3cWzrMZ+L0bfjxsvgvT/gXeiUkSAmgQTMzm6e45Bcltw1m0WRWd40rxwWPKpkyIs09NAKt3E1iBRBqHZ2t8e9ZvlnbbaS0Kf+nx04iUGdOnocD27iyJqm0skocyweZvriXlBknnjmitFiU9oY6v9ff1cEc13y/fM64orRMSHfkq+neRn2xo2whl4rQurvD92DM9d7ar+MAnE4tXUASEwf8K6QZlndBoh/LVHROhgxg/l2pUrQvTbCQjfY/zzc39xfkM6HNtDHF4ko4AsckvPpc2QkGvcZJP/IbOw+XSijHT+TrGmbpyfNSD5pHaXQdQDtrRjRbqoKmHkldDtSj8LykL7zCPQ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 04:03, Harry Yoo wrote:
> On Thu, Oct 23, 2025 at 06:17:19PM -0700, Alexei Starovoitov wrote:
>> On Thu, Oct 23, 2025 at 5:00 PM Harry Yoo <harry.yoo@oracle.com> wrote:
>> >
>> > On Thu, Oct 23, 2025 at 04:13:37PM -0700, Alexei Starovoitov wrote:
>> > > On Thu, Oct 23, 2025 at 5:01 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>> > > >
>> > > > Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
>> > > > kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
>> > > > that we discard the newly allocated slab if we can't spin and we fail to
>> > > > trylock. As a result we don't perform inc_slabs_node() later in the
>> > > > function. Instead we perform a deferred deactivate_slab() which can
>> > > > either put the unacounted slab on partial list, or discard it
>> > > > immediately while performing dec_slabs_node(). Either way will cause an
>> > > > accounting imbalance.
>> > > >
>> > > > Fix this by not marking the slab as frozen, and using free_slab()
>> > > > instead of deactivate_slab() for non-frozen slabs in
>> > > > free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possible
>> > > > case. By not using discard_slab() we avoid dec_slabs_node().
>> > > >
>> > > > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
>> > > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> > > > ---
>> > > > Changes in v2:
>> > > > - Fix the problem differently. Harry pointed out that we can't move
>> > > >   inc_slabs_node() outside of list_lock protected regions as that would
>> > > >   reintroduce issues fixed by commit c7323a5ad078
>> > > > - Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz
>> > > > ---
>> > > >  mm/slub.c | 8 +++++---
>> > > >  1 file changed, 5 insertions(+), 3 deletions(-)
>> > > >
>> > > > diff --git a/mm/slub.c b/mm/slub.c
>> > > > index 23d8f54e9486..87a1d2f9de0d 100644
>> > > > --- a/mm/slub.c
>> > > > +++ b/mm/slub.c
>> > > > @@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
>> > > >
>> > > >         if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
>> > > >                 /* Unlucky, discard newly allocated slab */
>> > > > -               slab->frozen = 1;
>> > > >                 defer_deactivate_slab(slab, NULL);
>> > > >                 return NULL;
>> > > >         }
>> > > > @@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_work *work)
>> > > >                 struct slab *slab = container_of(pos, struct slab, llnode);
>> > > >
>> > > >  #ifdef CONFIG_SLUB_TINY
>> > > > -               discard_slab(slab->slab_cache, slab);
>> > > > +               free_slab(slab->slab_cache, slab);
>> > > >  #else
>> > > > -               deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
>> > > > +               if (slab->frozen)
>> > > > +                       deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
>> > > > +               else
>> > > > +                       free_slab(slab->slab_cache, slab);
>> > >
>> > > A bit odd to use 'frozen' flag as such a signal.
>> > > I guess I'm worried that truly !frozen slab can come here
>> > > via ___slab_alloc() -> retry_load_slab: -> defer_deactivate_slab().
>> > > And things will be much worse than just accounting.
>> >
>> > But the cpu slab must have been frozen before it's attached to
>> > c->slab?

Note that deactivate_slab() contains VM_BUG_ON(!old.frozen);
we would have seen this triggered if we were passing unfrozen slabs to
(defer_)deactivate_slab(). I assume it's also why the "unlucky, discard"
code marks it frozen before calling defer_deactivate_slab() (and this patch
removes that).

>> Is it?
>> the path is
>> c = slub_get_cpu_ptr(s->cpu_slab);
>> if (unlikely(c->slab)) {
>>    struct slab *flush_slab = c->slab;
>>    defer_deactivate_slab(flush_slab, ...);
>> 
>> I don't see why it would be frozen.

c->slab is always frozen, that's an invariant

> 
> Oh god. I was going to say the cpu slab is always frozen. It has been
> true for very long time, but it seems it's not true after commit 90b1e56641
> ("mm/slub: directly load freelist from cpu partial slab in the likely case").

It's still true. That commit only removes VM_BUG_ON(!new.frozen); where
"new" is in fact the old state - when slab is on cpu partial list it's not
yet frozen. get_freelist() then sets new.frozen = freelist != NULL;
and we know that freelist cant't be NULL for a slab on the cpu partial list.
The commit even added VM_BUG_ON(!freelist); on the get_freelist() result for
this case.

So I think we're fine?

> So I think you're right that a non-frozen slab can go through
> free_slab() in free_deferred_objects()...
> 
> But fixing this should be simple. Add something like
> freeze_and_get_freelist() and call it when SLUB take a slab from
> per-cpu partial slab list?
> 
>> > > Maybe add
>> > >   inc_slabs_node(s, nid, slab->objects);
>> > > right before
>> > >   defer_deactivate_slab(slab, NULL);
>> > >   return NULL;
>> > >
>> > > I don't quite get why c7323a5ad078 is doing everything under n->list_lock.
>> > > It's been 3 years since.
>> >
>> > When n->nr_slabs is inconsistent, validate_slab_node() might report an
>> > error (false positive) when someone wrote '1' to
>> > /sys/kernel/slab/<cache name>/validate
>> 
>> Ok. I see it now. It's the actual number of elements in n->full
>> list needs to match n->nr_slabs.
>> 
>> But then how it's not broken already?
>> I see that
>> alloc_single_from_new_slab()
>> unconditionally does inc_slabs_node(), but
> 
> It increments n->nr_slabs. It doesn't matter which list it's going to be
> added to, because it's total number of slabs in that node.
> 
>> slab itself is added either to n->full or n->partial lists.
> 
> and then n->nr_partial is also incremented if it's added to n->partial.
> 
>> And validate_slab_node() should be complaining already.
> 
> The debug routine checks if:
> - the number of slabs in n->partial == n->nr_partial
> - the number of slabs in n->full + n->partial == n->nr_slabs
> 
> under n->list_lock. So it's not broken?
> 
>> Anyway, I'm not arguing. Just trying to understand.
>> If you think the fix is fine, then go ahead.
> 


