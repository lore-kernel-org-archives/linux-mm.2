Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C03A7CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 09:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176CD6B0005; Fri, 29 May 2026 05:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E3A6B0088; Fri, 29 May 2026 05:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064296B008A; Fri, 29 May 2026 05:38:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC1966B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:38:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B098B4114F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:38:14 +0000 (UTC)
X-FDA: 84819956508.03.1547532
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id ABC6816000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:38:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SqRiIdKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GTfkLfg2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SqRiIdKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GTfkLfg2;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780047492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR2ynzqnXPuNkm5ttkjvxmXaLxh7kzPSZJiyGRjfBNc=;
	b=7DEcdx++OQh+ADn8Q4GRq8oY+j9psHy7lAcES0bmZHPbUY29GDSypjEmthhrSsYtBwlrng
	4tVvcwHxcQpeZJGCPemuqY8D+vKM88NFAQl7HI8OOG2ZYWIiwX891IZs+Be3cAZfcx2z8P
	VE8InwwB22G1SwTuYhp1cM2kMcOgW2c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SqRiIdKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GTfkLfg2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SqRiIdKL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GTfkLfg2;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780047492; a=rsa-sha256;
	cv=none;
	b=sxVEo1aJ4Uuck9E4VynOuRnQ4Gw3lm0SR1/RNv3xBC76hzQ6pbiHqfcP5nggUTMFOIF7lr
	U+SnDr4Pl3b7mqmeCsuM2FYBmZeXAAHAErXi9G1DEXfqiwuvWC4ExTm0hLx9RkrYOEdXT+
	iw/Lfto0hsjLxXEenmGCJUdYtCbyXgw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E27E6A7FF;
	Fri, 29 May 2026 09:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780047491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DR2ynzqnXPuNkm5ttkjvxmXaLxh7kzPSZJiyGRjfBNc=;
	b=SqRiIdKLlonvOcehSrPcapt+ISqXMW6LaiXnXw5i0CySFVOLFNDl9IaeK+N3OHsqv7GIPS
	b9qYEq0/0ytsThqo7sk0w1wXXJRz7dg+b055xOISx+wDe++oJQjp6KnFGcSINklSrWS8fm
	n/ryA9y/jIcSIbslXdCW4zoh26k8rA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780047491;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DR2ynzqnXPuNkm5ttkjvxmXaLxh7kzPSZJiyGRjfBNc=;
	b=GTfkLfg2K1I1WU8rmDta8MyeiLpqUK4UFWlHGg7URsCsi9pyJhpIZ819KZxjpwVGhX8Me6
	8wAoZfnXkXhcmPAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780047491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DR2ynzqnXPuNkm5ttkjvxmXaLxh7kzPSZJiyGRjfBNc=;
	b=SqRiIdKLlonvOcehSrPcapt+ISqXMW6LaiXnXw5i0CySFVOLFNDl9IaeK+N3OHsqv7GIPS
	b9qYEq0/0ytsThqo7sk0w1wXXJRz7dg+b055xOISx+wDe++oJQjp6KnFGcSINklSrWS8fm
	n/ryA9y/jIcSIbslXdCW4zoh26k8rA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780047491;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DR2ynzqnXPuNkm5ttkjvxmXaLxh7kzPSZJiyGRjfBNc=;
	b=GTfkLfg2K1I1WU8rmDta8MyeiLpqUK4UFWlHGg7URsCsi9pyJhpIZ819KZxjpwVGhX8Me6
	8wAoZfnXkXhcmPAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2163779A7;
	Fri, 29 May 2026 09:38:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 43EIJIJeGWqlXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 29 May 2026 09:38:10 +0000
Date: Fri, 29 May 2026 10:38:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, 
	akpm@linux-foundation.org, mhocko@suse.com, vbabka@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
Message-ID: <ahld5va1b9w8j659@pedro-suse.lan>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahlameE6FBEZj_gt@pedro-suse.lan>
X-Rspamd-Server: rspam12
X-Stat-Signature: d7k9c7q6rbxy4a7shhzet7ioar99sjuz
X-Rspam-User: 
X-Rspamd-Queue-Id: ABC6816000F
X-HE-Tag: 1780047492-901403
X-HE-Meta: U2FsdGVkX1/vItNcEoQHFzSwiM5fRsx8v+3Yb7KC6WFVZyG4FT7bV0w1cyRc6MuO2wiEY3p2wlvxsU4AolF1kh41UsIUBucFBk/ie80nDHAJgFwcIJ2QHdXfaJuHmw6wSEBxOkmexF8Ob57pFF3Bq2+d6oxJY8Nv4poEjJ+DrErsBz+KupQyfT9UIrUtdHSlKyIpSU9sDW84HQsk9gePoxcV70IB6msf10k7wCVzRCyOp3ZW+socKPQWP9e3F5h0EA8NAjBWX+P0D2ehbGTjv8zP4zhep9I3QWufRIR6PswJuEXH9NYZWg4inzcfvqML40QfZRV/E1sr/9vjWN1ZuWtriwOPLqZNYAiPnBPNPz7TJcdej/fI0pDhSRESDziRCtyd3XsK2qOaoasO2Mpn9z/IHGV8MlLoMzIKwKYPE5Ui+fIfMh4hKCw6TfLsUdH7EjuCXCKK9zgERHwD3KvLqIz0ZRvE18Q9W1MvYW/oWGKEnpw1ygZhaibG5nr4lBTDJuHAgrzxO1Y1T4hlLLU0rKqIxaNGiy94Uwk/DlX0MI5HkZNPCSj3J3hGk1ABde5Rt25csJsJKZ+ZyuPEtMP1TSyouS8m7oicg29gxO4Nh9vI1obatWl6Tvqw31Z3+wT3kIIPa1wdNTrEP2RWGPQh1kkUX0o1k3NozlSZhCYruq733BwdxDK/weSg5Lp0cDfcMdrfTbiX7E0sOkK21bkT+ft/a3bi2xDpe8pGMVpFQuvDTG3KMBuarcoGZ8v8vsA7/uKffZM2JWnVNyq3G9j0gl8fwOaXH7MudWgu2dXzMNYKHuE33VsZbt8I60CpJFgjG79T67t3Hj78gz3fcDdV/q7/M+gf+50kI87WyqdMfb+L+OcCeuSfGl42fSMqCwHhznoYcagL1bXVyTKxI15D3FWbVD0xFrR8IY3NwDsk3Eh1tlOMKzsWG1m1hS24JNYax07JB/LbVkbJ+xZ5E9B
 5UchZJcB
 4bkf91c0p33QCB/jXUBkY7+iyvYey/F8qGt90nxFn3+Cjgq48M4bFKMtGm4I1V5as691IcOs6aTzZ+mJT99BuWb6JSvctWiUdkzVXMvkUNSazwQjYunQK79eUmWcwAXjaA5/oECHje0rYpL90d2GjgstRdL0xzHKHTV64dEUBw2gPu7Jrfvzx+FTbY7kKLLuiz4GLX46rHditOYBkKQylW8rXgGToLRiPgftKVvSTfXwAaSDVlvn/yteXyuN2UeMMA8xWyATLsxzdSykLznbhXicIO1NZmTO8jywZPTlB2AdZel4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 10:25:28AM +0100, Pedro Falcato wrote:
> On Thu, May 28, 2026 at 09:29:16PM +0800, Kaitao Cheng wrote:
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
> > passes it to the backing percpu allocators. This preserves GFP_NOFS and
> > GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.
> > 
> > However, the chunk creation and population slow paths also call helpers
> > which do not take a GFP mask and perform internal allocations with
> > GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
> > and population can allocate temporary metadata or page tables while mapping
> > backing pages. As a result, a caller which explicitly uses GFP_NOFS or
> > GFP_NOIO can still enter FS or IO reclaim while creating or populating a
> > percpu chunk.
> > 
> > This is problematic for callers which use GFP_NOFS or GFP_NOIO because
> > they are already holding filesystem or IO-path locks. If free chunks are
> > exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
> > unconstrained reclaim from these internal allocations, defeating the
> > caller's allocation context and potentially recreating reclaim lock
> > dependencies.
> > 
> > Wrap chunk creation and population in a scoped NOIO or NOFS context when
> > pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
> > allocations unchanged so they retain full reclaim capability.
> > 
> > Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> 
> I assume you _did not_ observe this in production? As in no reclaim path should be
> insane^W daring enough to do pcpu allocations?

Oops, I mixed my issues up. This is purely a GFP flags issue. A quick
"git grep alloc_percpu_gfp" shows that the vast majority (all?) callers are
using some combination of GFP_KERNEL or GFP_ATOMIC + other GFP flags, but no
NOFS or NOIO as far as I can see. So you probably did not observe this?

> 
> > Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> > ---
> >  mm/percpu.c | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 71a85d7245c7..1bb38467390b 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
> >  }
> >  #endif
> >  
> > +static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
> > +{
> > +	if (!(gfp & __GFP_IO))
> > +		return memalloc_noio_save();
> > +	if (!(gfp & __GFP_FS))
> > +		return memalloc_nofs_save();
> > +	return 0;
> > +}
> > +
> > +static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
> > +{
> > +	if (!(gfp & __GFP_IO))
> > +		memalloc_noio_restore(flags);
> > +	else if (!(gfp & __GFP_FS))
> > +		memalloc_nofs_restore(flags);
> > +}
> 
> I disagree with this. We already have gfp flags, they're already passed to pcpu_create_chunk()
> and pcpu_populate_chunk(). It's their job to respect the gfp flags and
> Do The Right Thing(tm). Can you fix the problematic places? It seems like it's
> mostly the vmalloc backend that's problematic.
> 
> > +
> >  /**
> >   * pcpu_alloc - the percpu allocator
> >   * @size: size of area to allocate in bytes
> > @@ -1901,7 +1918,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
> >  
> >  	/* No space left.  Create a new chunk. */
> >  	if (list_empty(&pcpu_chunk_lists[pcpu_free_slot])) {
> > +		unsigned int pcpu_scope;
> > +
> > +		pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
> >  		chunk = pcpu_create_chunk(pcpu_gfp);
> > +		pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
> > +
> >  		if (!chunk) {
> >  			err = "failed to allocate new chunk";
> >  			goto fail;
> > @@ -1931,9 +1953,13 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
> >  		page_end = PFN_UP(off + size);
> >  
> >  		for_each_clear_bitrange_from(rs, re, chunk->populated, page_end) {
> > +			unsigned int pcpu_scope;
> > +
> >  			WARN_ON(chunk->immutable);
> >  
> > +			pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
> >  			ret = pcpu_populate_chunk(chunk, rs, re, pcpu_gfp);
> > +			pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
> >  
> >  			spin_lock_irqsave(&pcpu_lock, flags);
> >  			if (ret) {
> > -- 
> > 2.50.1 (Apple Git-155)
> > 
> 
> -- 
> Pedro

-- 
Pedro

