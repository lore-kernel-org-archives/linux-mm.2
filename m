Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E0ACDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036176B008A; Wed, 24 Jun 2026 15:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F287E6B008C; Wed, 24 Jun 2026 15:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEFCE6B0092; Wed, 24 Jun 2026 15:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B47E66B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:25:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42C491C5DB4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:25:15 +0000 (UTC)
X-FDA: 84915784590.25.781D91F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0315F8000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:25:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r4QcG6mh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eI4FJn9x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09mNOUvu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+86KRCmp;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782329113;
	b=t7XOkayotEsWLl0ZC5x/oTtFl2OXJ6N9C2cxIgfJvW/fsI/for40Uff4aOU5hDRtsiJFa2
	DjKuFe66VGI7q1+6RiSE7RdSBDiw00lhNIu6bDpThSDVvH3uMz/tYUrUbmbHW0WuhJeMx7
	sROMQi0Xgzqe5E5K4OA4zWu4PaeN90Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782329113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZIGhBG/8Lw0a5tTbCrM4WR8Uy8BiutNW2JHz4dPgbo=;
	b=up5gVl8a5sBeWJ1o04bdJ1hdj/+BO6euF7zhYug3pWYTIfqNQHelFigtP/OK1C6xdoX90N
	Wgh/6frTPWgIUaj1O8myozhivFoxX8ppiLM023uN8B9bRqiTdoJJm41w63J56waWaKuU+B
	Qza0qO+HMqIY+X34QxmGu6MIZMvmVYQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r4QcG6mh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eI4FJn9x;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=09mNOUvu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+86KRCmp;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6EBF56DCFB;
	Wed, 24 Jun 2026 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782329111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZIGhBG/8Lw0a5tTbCrM4WR8Uy8BiutNW2JHz4dPgbo=;
	b=r4QcG6mhdA8RArfyr4RzLWsdZ62VMaOWod0jhxVp9yJa0FkBdGbZ7182pbjEKU1vLvNOfN
	TuEV8c15lQ2a3ntIDq1xo2PVMGzpPE/uQhBPUUr22yhG396lFk1gtEDG/Z90+RazgtM65f
	SPoSMq3abg3N+IzeKD3OQLY0S8BQ1WE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782329111;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZIGhBG/8Lw0a5tTbCrM4WR8Uy8BiutNW2JHz4dPgbo=;
	b=eI4FJn9xIGiHGPE2bT0os6X6lTIxKgs42HDiqUq4Q1bpsA8PSNg8dQMIvQEeosXc03CXUg
	Jp/N53lPqM1kLxAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782329110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZIGhBG/8Lw0a5tTbCrM4WR8Uy8BiutNW2JHz4dPgbo=;
	b=09mNOUvueboSyfPMk1LHBeagcrzoNimbuBgvMPdkbkArCJCh2V8waJjdsa0Iqajatb7DMB
	sbUJqxWI3QBvCH1g7vyjwV5tC7mPL2LdzCzFYvLjLSRSEbSEBrSHmt6F4AfBgge8ir5/g9
	KknEBm5nsRArZOmomeiUnl4xB6C9QqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782329110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZIGhBG/8Lw0a5tTbCrM4WR8Uy8BiutNW2JHz4dPgbo=;
	b=+86KRCmpXaXmybCmX7a4NNPEFUzGMdP/BaPoVfzJfUnyt/wNa9en2f7WoEodOpSt7wu9kK
	dSQ83Z715QD4BpBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 78D19779A8;
	Wed, 24 Jun 2026 19:25:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z4J7GRUvPGrIXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 24 Jun 2026 19:25:09 +0000
Date: Wed, 24 Jun 2026 20:25:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Samuel Holland <samuel.holland@sifive.com>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <ajwuKpSnElvwIyhC@pedro-suse>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0315F8000A
X-Stat-Signature: 37zhotxuapkgrjz9kxj3w5d6ge57oi8r
X-HE-Tag: 1782329112-852182
X-HE-Meta: U2FsdGVkX18EvwFvFHjlmwlPAw9WWuV4+BXvTw+PTbmj+xhS6gEipdiHsuYo83WMCC+OSHQgqEP1w1uz5fbX+cuCGEDbLuAXuicDn8jiaN79KGOhJtivJvbGnrVh6K/0BenFuDnP0R8qKA1ZvlNTiGvygo498OUVC52JQLIlL/s6854aQGYrj954NRQ5Yd0YyzPUpQ7LkVsZ/CbOq2/HeaKyonZWKA+rNXnYO3lYQ9z0xT5UmH0r45d90CL+rDvdOF+lrvgUa0bfZH1oL7uXqjWDJDgY7wJqidgo60IXpt97zrCGaal2QX6YkkUVj0HvQ7mg2/WJe7cUlSkKPXaGmvxwNDd0PdnsSoPwq3//oSJKe/IpX2e0HFLowa7GsGLniluPZeIwmKpmFdTAgYpWOn+OD5Ctel4cEwd4z/rMWlfOHr8lMd83T5m1ppuuRugvSus9F/bxZT+dPvEzQh6CAQZaEE/gwz+gXopG5mejRD8gxSEJ0D1DTRryrkrpCQfLAyJCXIr10mw90A67afM9It1gDnV62BfCmq6Bfm3YYYN5Yh4YEW7vAyMshhbfFyGoE8NUiMrZ161oBQhbQW2OZ0g3dAfoLk1xDOHj3zq3CqbXGblC84buN9AAzglJ+Mk2D2G999EEZzoJDtgclpx61acbEoFKwMP1EsAEV7Ofhw5m5s7GOkrwRU9yK9zCZQOj90D1rBEl39Eaw1huVfc3l7FqyaKFaRLbSAEIquSII5RdLo766sOyliylTeUOzWNPeene5EqpdHNIM0YzWQXyXD1L6HX2hGs0GZjVGC/G0/ls7BxpGwrAoyE8c4KpbbC9RuvTp9hkcdekGGCe1YkFUDCYOYQ+lY4ys1hirTOzXE1P81qBcpnuZZrJ94R5DQx7NpnD3W55NPdDjQD9i4Bu8FNBLiVv4lQWT88lkjx5hc0u71elBrt6IpVYPkmXZM/YI7OYUs4XfWuUjRzCD8x
 YDHM/Mqh
 MmH1DyT658L1IKDrMA/Ib9nDrr+Zm3pvLbQKenypUTZfWrJTDDi0VtCgWNl/Tt2QoDnT/PDpvWtkLRxr6E5D4SOx5KwZLHIv+aDikxRqXHN7gqnBstBEmRZffiiTBpHAbZeJjssvXYg+dZUIQeCQ7hBV90b0FX2Q74t31Gfazj37oA4n0cs0Ct9MENYmaQlgNXaTO5m+ztE4/WnEHiq+Sqv2jC0Rwc7kQ1fNj97oP/Z28pz4cyNnEmH2gbahgQbQu8za40R7niyPSEhrx7IFf57qd/KnMeA2Ksnpp0MHZjed41VqFS8gaOvztm9AjaCKfr3dqj58rn9DYw/wQ4l2zrYJoXvTPSKeDurOMUf497WxB5cUNVx+w+NEebgOiJ48x6HSo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 03:09:08PM +0100, Usama Anjum wrote:
> Hi all,
> 
> This is a direction-check with the wider community before spending time on the
> development. This picks up the idea that was raised and broadly agreed in the
> earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].
> 
> The problem
> -----------
> Core MM code reaches page-table entries by raw pointer dereference (pte_t *,
> pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
> representation. Sprinkling getters wouldn't solve the problem entirely. The
> problem is one level up: the *pointer type* itself is overloaded. At each level
> there are really three distinct things:
> 
>   1. a page-table entry value (pte_t, pmd_t, ...)
>   2. a pointer to an entry value, e.g. a pXX_t on the stack
>   3. a pointer to a live entry in the hardware page table
> 
> Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Nothing
> distinguishes a pointer into a live table from a pointer to a stack copy.
> 
> A pointer to an on-stack entry value and a pointer to a live hardware entry have
> the same type, so the compiler cannot distinguish them. Passing the stack
> pointer to an arch helper that expects a hardware-entry pointer compiles fine,
> but is wrong - a bug class the type system makes invisible. It also blocks
> evolution: an arch helper may need to read beyond the addressed entry (e.g.
> adjacent or contiguous entries), which only makes sense for a real page-table
> pointer, not a stack copy.
> 
> The idea
> --------
> Give (3) its own opaque type that cannot be dereferenced:
> 
>     /* opaque handle to a HW page-table entry; not dereferenceable */
>     typedef struct {
> 	pte_t *ptr;
>     } hw_ptep;

I don't love typedefs that hide pointers.

> 
> With this:
> 
>   - a stack value can no longer masquerade as a hardware table entry,
>   - a hardware handle can no longer be raw-dereferenced,
>   - cases that genuinely operate on a value can be refactored to pass the value
>     and let the caller, which knows whether it holds a handle or a stack copy,
>     read it once.

Just a small passing comment: how about doing it differently? like

typedef struct {
	pte_t *ptep;
} sw_ptep_t;

or something like that. Were I to guess, referring to a pte_t on the stack
is much rarer than all the pte_t references to actual page tables. But maybe
reality doesn't match up with my guess :)

> 
> The overload becomes a compile-time type error instead of a silent runtime bug,
> and converting the tree forces every such site to be made explicit. This gives
> us a framework where the architecture can completely virtualize the pgtable if
> it likes; and the compiler can enforce that higher level code can't accidentally
> work around it.
> 
> It is opt-in by architectures and incremental. The generic definition is
> just an alias, so arches that do not care build unchanged:
> 
>     typedef pte_t *hw_ptep;
> 
> An arch flips to the strong struct type when it is ready, and only then does
> it get the stronger checking. This lets the conversion land gradually.
> 
> Beyond fixing the latent bug class, this abstraction is an enabler for upcoming
> features that need tighter control over how page tables are accessed and
> manipulated.
> 
> Getter flavours
> ---------------
> While converting, it is useful to have two accessor flavours at each level:
> 
>   - pXXp_get(hw_ptep)        plain C dereference (compiler may optimize)
>   - pXXp_get_once(hw_ptep)   single-copy-atomic, not torn, elided or
>                              duplicated by the compiler
> 
> Keeping them distinct simplifies the conversion and avoids re-introducing the
> class of lockless-read bugs seen on 32-bit.
> 
> Example conversion
> ------------------
> Most of the conversion is mechanical.
> 
>   -static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   -		pte_t *ptep, pte_t pte, unsigned int nr)
>   +static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   +		hw_ptep ptep, pte_t pte, unsigned int nr)
>    {
>    	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>    	for (;;) {
>    		set_pte(ptep, pte);
>    		if (--nr == 0)
>    			break;
>   -		ptep++;
>   +		ptep = hw_pte_next(ptep);
>    		pte = pte_next_pfn(pte);
>    	}
>    }
> 
> The bulk of work is this kind of rote substitution. The genuine work is the
> handful of sites that turn out to be operating on a stack copy rather than a
> live entry - those are exactly the ones the new type forces us to surface and 
> fix.
> 
> Estimated churn:
> ----------------
> Half way through the prototyping converting only PTE and PMD levels:
>   77 files changed, +1801 / -1425
>   ~57 files reference the new types

Right, the churn would be very unfortunate.

> 
> So the line count will grow once PUD/P4D/PGD and the remaining call sites are
> converted; expect meaningfully more churn than the numbers above.
> 
> Introduce the type as an alias, convert one helper family per patch, and flip
> an arch to the strong type last - with non-opted arches building unchanged at
> every step.
> 
> Open questions
> --------------
>   - Is the type-safety + future-feature enablement worth the churn?
>   - Naming: hw_ptep/hw_pmdp vs something else?
>   - Should all five levels be converted before merging anything, or is a staged
>     PTE-and-PMD then landing others acceptable?
>   - Do we want the two getter flavours (pXXp_get / pXXp_get_once) at every
>     level?
> 
> [1] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
> 
> Thanks,
> Usama
> 

-- 
Pedro

