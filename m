Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCC0E6688A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBCF36B00A0; Fri, 19 Dec 2025 15:26:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AD06B00A2; Fri, 19 Dec 2025 15:26:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D944D6B00A4; Fri, 19 Dec 2025 15:26:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74796B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:26:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38DF8B6910
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:26:22 +0000 (UTC)
X-FDA: 84237353004.18.D12B5DB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2B95180010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:26:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nzQiadJm;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766175980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Emc2vbC3qID9SHvuPS4TRJl94rbUBBjY6SgXZbxDzrg=;
	b=eUYAO2nrUrD7m9n8zfL7++xr6rdw9y1W2tZuM6RyAARn0ur+NkA4f2kaZDvN7kL7RAsajP
	uH4fHc6lmUMYhEkbNtdy9Gl8h6c14g4N0QMq4K1nRcQmvOcnw3Aq2SFB3+584k6jQ4+jdu
	nm6oI8q6cl0COqZEvUrmzTytw2MH6lA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nzQiadJm;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766175980; a=rsa-sha256;
	cv=none;
	b=OvoNTGiyFriCF8+cNBD6q/2q09CN5eE6zPQWevSXFFuuJeLPTda3y9NBL5kNWdHTixYO6u
	UCvxvBsDBRR8vo2VwTlsXTiiS1zVqBlQJjWzi996uuzan7Y6hz12cMmHkaVBb1ZYz+v7eh
	nEk/ZnrUxtV2rtdBiXui1eXdlFdocLU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Emc2vbC3qID9SHvuPS4TRJl94rbUBBjY6SgXZbxDzrg=; b=nzQiadJmwnoIXWr50jaaz0BETh
	eseBcZG2LzIFeLu+KZFFSq/sC8APmKarn/LWWwWVkJfzkYcHKKMxYuVoxZBpwmHvgSkp4o6nFm2Si
	7Ppe1NY8c6UX5364m94uVhIwzZs6dfF7T1E0IUfXSax3aj12vCwVmgQDFV3J2Lu9iVVfOTDy0Itoi
	9BzgWv5sbP8cErMCNGCnZEzpSN/o5Da1Y6fibaxbCaNjuY4eG1Ui0aY7Y3giuzj8xuBJcZ5U9AhtO
	ll6DAioRUYEtZhnvMiYyghKS6kjWSU6XbZCQwJZpFqwg1U+2nFeew0Y9ayt2Kq4+rNjxBAXoyYGdZ
	7Zpxv5OA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWh3G-000000084bL-2llR;
	Fri, 19 Dec 2025 20:26:14 +0000
Date: Fri, 19 Dec 2025 20:26:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Vishal Moola <vishal.moola@gmail.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Mel Gorman <mgorman@techsingularity.net>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aUW05pyc9nZkvY-1@casper.infradead.org>
References: <202512101320.e2f2dd6f-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202512101320.e2f2dd6f-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D2B95180010
X-Stat-Signature: u1tpgma19c44qctykdc38xxd9ssphjcf
X-HE-Tag: 1766175979-683419
X-HE-Meta: U2FsdGVkX1+A2G73tIA/FmDkg8Nv2jPpCkD08CpSVjpUN9NqewBaIZuv4ulVVykxGJZXHJXd1l8Ur5OO8CqWM6LLO8QDNcATQ1/lmP+7xULPCeIJn++QMS3yvK/SzcuageVb5Zl9xgxzE8HylkaVqTZKayC/zp7qGNrfau/0xg00JxqU4drMpSeo7xAT0sTUqK62xzGfT5eiBmmQRGVaVHybI7F24vl08dO87PgqpgNbGYQ11G7wF7rjkJh5JYIC6RZGomk+AgC6PC9t2vLDnIvQNtPRowze7nNrBzEEE8ewiOLfH9f++j95L3CUrWRtatgRNSSJcNIcWe8MBjnfIz/A2cghqTWauI8btlNhr808iRCJMMbnMBoqUa8BxiKyVoWSX/2hGKX32pIweWgZ9PJ7thuzmrlOE4546ZYxdZdCACWXVyUKJh/XozlGnFZME/LvluOyqWMHdUqCvmuPlX4f0WJAnm3zL9R8LlgfddVHaABw2uf8qYLJ4Q7lnSvgPIzrpXI7ybcD7+SWRjzCfLK/q9Tz7B4RtMWEpZelZDwZDqYB5oaCvUCxvHVyxbZiKZUDUr3/z8sm+JciTPoXTQ1NZT0aXLXiG2qvsGsXSf9T12K3Xf08Ud39vSteIbJNrANgapmWe7mU0DWun4DvAMQ38g7jasaIzSoIOFV+i1zAz6oqViGyXlTdkRIM37Qt8qoEiloi1nypPidcFBruoP/ZuKaJVf6rV4WnNHF4KXeX29NUiJ+0iFfhksJHONF0gDN8tNdty0ewYGxgTOP6HcfTITa0NERlqvwmgo+i7KE/YYLSvT0/05sGN2j36ssNhIP9CpzJKJ69pzCn2PKEibaOWkgpAiU3vURb4XSZetBVQ8fpJBswuOwfB0RGnW3UtXdwyDJwSefEQndofaPNOYIDtTsRqYo8fuvkbTGR3XwnMvPxo03Tfdg8oeDq4wHqssOX44wNLrNBLf8PxYv
 /dBiY1iO
 HVmylcKaHf+2VmFSsB95eGBSmMRwbbVJmr3j0ggNNOxHd7CKRNVt3eYMg5KQEIp95IA+23Wp8xK/jLu5JiSiwkFM9C1tt9XEtd0WcS6t1exDtaSG6nbGD59HjisQBxv44zvqWZ1LyCu2WAc/tLXlesnfYVOz34tXFqDO1623JMPMIqF5mpYY2hxNkp0isa1CDgomtIm00+G3ymGelrTnjIPKCX2w424FEpMJ+tq+qglkcVb3e7EBYzeUmlLcvXCUiDb0t/mg2tKVSnihsa7auxItHlD9+zrqw0yF83VG3SUM2/G7G7bmemlD2TslZ/Gd+RQZOOwpaElMT9msa5ZwOB+3hfLRh2O7EA7B3Q7lueRRRM+9rkQDSNoQtHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 02:10:28PM +0800, kernel test robot wrote:
> kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:
> 
> commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")

I agree with Andrew; this commit is only exposing, not causing the bug.

> [ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28

The first thing to note is that this will only show up on CONFIG_SMP=n
builds, on account of it being behind a #ifndef.  So almost nobody will
ever see it.  It's also a failure of a trylock, so the worst consequence
is going to be performance.

> [ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
> [ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)

This comes from SPIN_BUG_ON(!ret, lock, "trylock failure on UP");

> [ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
> [ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)

        pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);

> [ 1046.651984][    C0]  <TASK>
> [ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
> [ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
> [ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
> All code
> ========
>    0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
>    4:	c1 ee 09             	shr    $0x9,%esi
>    7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
>    e:	31 d2                	xor    %edx,%edx
>   10:	31 c9                	xor    %ecx,%ecx
>   12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
>   17:	4d 85 f6             	test   %r14,%r14
>   1a:	74 05                	je     0x21
>   1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
>   21:	0f ba e3 09          	bt     $0x9,%ebx
>   25:	73 01                	jae    0x28
>   27:	fb                   	sti
>   28:	31 f6                	xor    %esi,%esi
>   2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
>   30:	0f 95 c3             	setne  %bl
>   33:	40 0f 94 c6          	sete   %sil
>   37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
>   3e:	31 d2                	xor    %edx,%edx
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
>    6:	0f 95 c3             	setne  %bl
>    9:	40 0f 94 c6          	sete   %sil
>    d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
>   14:	31 d2                	xor    %edx,%edx
> [ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
> [ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> [ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
> [ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
> [ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)

Line 1494 is a } so I presume this is really 1493:
        spin_unlock_irqrestore(&zone->lock, flags);
... which makes sense; if an interrupt comes in during the IRQ-disabled
section, it's going to be serviced when we re-enable interrupts.

> [ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)

And this is where we do:

        struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
                spin_lock(&pcp->lock);
                        free_pcppages_bulk(zone, to_drain, pcp, 0);

Now, as I recall, we are very much doing this on purpose.  We decided
not to disable interrupts at this point for improved interrupt
latency, accepting the possibility that we'd occasionally fail
the trylock.  Except on UP that's now an assertion failure.

How to fix?

