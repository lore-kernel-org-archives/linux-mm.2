Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D11CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E38D6B0088; Wed, 14 Oct 2026 11:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595386B0092; Wed, 14 Oct 2026 11:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486596B0095; Wed, 14 Oct 2026 11:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23EB76B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:53:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4AC3805E5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:53:06 +0000 (UTC)
X-FDA: 85321675572.07.418367A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 87DD5100007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:53:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oog3dITA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A8yYzH3w;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oog3dITA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A8yYzH3w;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791993184;
	b=431eKoln89vS8SVqz/YtaqE6YoNbn9NazrmUc4UKs2iTPscgDvLp3QNqLEYwYUYpCG7cep
	nPf069gmyy3ah0w7Z3ZcDvyrvVzNYKw8AIwujrseP+d1KOJglB6960B385ObvtMF1/gcRm
	8wr7aW0gUmXlSj+9M3PV2VLYwARqszc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oog3dITA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A8yYzH3w;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oog3dITA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A8yYzH3w;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791993184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czptinR0+qpHm2+DqArj4j7rjTfE20PU59BUkqAFUyU=;
	b=wFBXLz1/08RQhccnH3g/OskZ8hI9hIRs8rcIiSEq3ph9iGTQqbBws6WKFC2LRk6jjnbpRv
	srvw9xmtYC9ihmvTotNjR3n6du+p/R3vCf/N4tUipx3wygv+ufMv67h2uzHsDuvffQVFiN
	o/VUxu7xA3mi9Txyv80mmwalay3Qms8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 175431F7D5;
	Wed, 14 Oct 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791993183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czptinR0+qpHm2+DqArj4j7rjTfE20PU59BUkqAFUyU=;
	b=oog3dITA1Q+xNqbWg6Licu5XuXBfbEV9jBYYlduikYAlz/3YwpRJm0AdXNmo5TWcR9TtTl
	EBYSSF4wftcr3IvmezzufjRO3+Ws+xFaNdIFXpaptNPDEtw3H6xUYDS7k37Wf+x3Mt0rZI
	eW6s0wifWj1OF0088usYpwmgGrXs5Wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791993183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czptinR0+qpHm2+DqArj4j7rjTfE20PU59BUkqAFUyU=;
	b=A8yYzH3wD2CzI4bOHdW5SVLIaZGK8rO/4jxjjbRA2FBGXn6kCXS95OtKkAC22mrWpPBgbQ
	cFj7EfUk1kehiXCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791993183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czptinR0+qpHm2+DqArj4j7rjTfE20PU59BUkqAFUyU=;
	b=oog3dITA1Q+xNqbWg6Licu5XuXBfbEV9jBYYlduikYAlz/3YwpRJm0AdXNmo5TWcR9TtTl
	EBYSSF4wftcr3IvmezzufjRO3+Ws+xFaNdIFXpaptNPDEtw3H6xUYDS7k37Wf+x3Mt0rZI
	eW6s0wifWj1OF0088usYpwmgGrXs5Wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791993183;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=czptinR0+qpHm2+DqArj4j7rjTfE20PU59BUkqAFUyU=;
	b=A8yYzH3wD2CzI4bOHdW5SVLIaZGK8rO/4jxjjbRA2FBGXn6kCXS95OtKkAC22mrWpPBgbQ
	cFj7EfUk1kehiXCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4371133F1;
	Wed, 14 Oct 2026 15:53:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M/ADJ12lz2pgYQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 14 Oct 2026 15:53:01 +0000
Date: Wed, 14 Oct 2026 16:52:59 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Minchan Kim <minchan@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	stable@vger.kernel.org, Samarth Narang <samarth.colleges@gmail.com>, 
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
Message-ID: <as-iHm9Y4wxRTG5d@pedro-suse.tail5790ac.ts.net>
References: <20261013191719.95502-1-pfalcato@suse.de>
 <as-dr-S6c3FALwQb@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-dr-S6c3FALwQb@gremlin>
X-Rspamd-Action: no action
X-Stat-Signature: mz1k4fufzzin3bfz6rht5udfj37euf1a
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87DD5100007
X-HE-Tag: 1791993184-717570
X-HE-Meta: U2FsdGVkX18XdiifnMVmkqJ/nKHOxxE6ZGbPVxgTPFTE0JZPWSEpXEerVUJixpQCqF5BHL5Iy+CUsuUmQ5jQpOYx7TOSZvWYGx3uCidFvoM7ux5mrPJ0AfGvBx+LT2yFR7hA5TNne8vr8owSOG/lboxSbyWywnfyvL4c6yEuJdN9AEH+WqyKSLzN2PgcQtAJx6EgHLlvSjGx8OhFv3PLufO3BN+fkomXsLHpxXgoCk5XEp+ilbnEYyDvs2eUGOWG8MuEwdci3MJ0I6NJVQb7W8M1sKXdlhYC6idHPoYxbVoOPtx4W8ba5fvEsrVbAOcDQg9rHINKRO03OhAlnkl6bGFVYfl0erQnV8VJDq6Np6Wu0j0/NjashW8nI8N/ZRey4qUnRDybu0fHwzMBH6vaebCKh13+lnSMj75Lb0O7rCXYCemj4eykA5VUL/HdWP7zB/0Qt5wTm/lKjMKegsA8w0fxD85Ulr8Z1wadzeC7RP08nDw0gh+z4XPsO+8emkQqLbpz7XHEG8MMoSZVawTKcfY+7NHoS5mvgKglLYSXJI5HkXenrXcW51/speXy4wsMRL/b2V3kOZt5KkeCmCs5zwinPkJczk1/pOb3YYWcTHIj7nWBPm4DUQAPOcQs3c+G/4M50nAtVn2suSdEUdxA5qhhemh6mK13fwaeA2MVs3G943Zd7fIWghsvAoUi+hdXUXxG09XEQdJDcuLnouthmHUfdYiLXlyQw+QvX6hu/5c1ORTysfxmZkbH+EZr086KZzCLF/AhsLxW/Ge9aaiWA9De3CWSvIz5vdTCw/tz7Oo6KqxAk2950r+TVi6URK/1gIyFtuLLzvnzsN4UYchvOjKr9LTxSEawvEu74T12WlpAx1WdIxC7txMzsAVKH6Ba06lGjGfRj/gMnQZV4yD+9eC7nH9uqD9ne8aCXPSwICTkHpJ3KjumD+X7PGSkaSmsc94NzXHErQz2vvBCOiM
 fqd0gUjH
 +bi9tI1M6a4Gytf+gcIJw1go+Zu6DoZY6x1Ohit+eju/d9lIYWHjafndmzdHkQmwKcUINJ/X5OuIFNXzonkO3sFSzslpOCtPacx2eubR/2bYW2KTJ3QoX7lzNKAg04pTARcsW0XUgkLJ/ZjdMfpZLIUuX6qWEcOj45wp5zTvmwYWSurKqzMSe1QuQ91fLDztyQ3jku6NVUee5GDV25Ta2miPxZezlZN2y2ECYuNjj+COwZlainwDnhihtKC6CFA7zS8te3k0DXh3ouNXGek/xs6w3V4UesjbUy8LAIXuCHLPwAYC2B8z9NDhike5xutp+uhajv9xxE1BQnGBp1BdEJ7iCHKb9pWdodL1+UK+4/oU4Lwc0fhadbaaLYJZFptGPqyKk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 04:37:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> +cc Gregory
> 
> On Tue, Oct 13, 2026 at 08:17:19PM +0100, Pedro Falcato wrote:
> > As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> 
> The function from hell... Gregory - PLEASE FIX THIS SOON :))

:))

> 
> > bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> > to the pmd again. However, it does so in a racy manner, looking at a
> > possibly-stale snapshot. It's entirely possible that a write elsewhere
> > set the hardware D bit, which this logic now loses.
> >
> > Fix it by using pmdp_test_and_clear_young(). This is an atomic
> > modification of the PMD entry, and thus safe against any possible racing
> > writes. As a (nice) side-effect, this elides one non-required TLB flush
> > in pmdp_invalidate().
> 
> Nice, I'm guessing the tlb_remove_pmd_tlb_entry() does what we need already? (as
> discussed off-list :)

Right, so the whole gist of it is that indeed for 99% of cases you don't
need to flush TLBs when clearing young. Out of all the ptep_clear_flush_young()
implementations out there:
 - arm64 does a light tlbi to help make sure the A bit will be cleared whenever.
(I remember reading about this, and it was due to some really weird hardware
that kinda wanted this)
 - ppc64 just clears it
 - parisc does a non-atomic get+clear with a tlb flush in #if CONFIG_FLUSH_PAGE_ACCESSED.
CONFIG_FLUSH_PAGE_ACCESSED is hardcoded 0.
 - riscv is just a clear
 - s390 is just a clear
 - x86 is just a clear
 - pgtable-generic does a TLB flush. Unclear if most/all users using it actually
require it, or if it's just nonsense.

For now, the tlb_remove_pmd_tlb_entry() (and corresponding tlb flush in the PTE code)
does the job.

Anyway, the point being that I kinda want to avoid these flushes, but it's
not particularly trivial ATM, with the tlb_gather API. I'll try to remember
and send some (hopefully tasteful) patches next cycle, on top of Gregory's
make-madvise-cold-not-hurt-my-eyes patches that will have surely landed
by then.

> 
> >
> > This bug can interact with the swapping system in complicated ways, leading
> > to data loss. For instance, if a folio is marked lazyfree, but was later
> > read from, and then MADV_COLD'd while racing a write to that same THP,
> > dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
> > the "clean" anon folio:
> >
> > T0                                T1
> > ================================================================
> > MADV_FREE(thp)                  |
> >   folio marked lazyfree         |
> > read(thp)                       |
> >   PMD marked young by hardware  |
> >                                 | MADV_COLD(thp)
> > write(thp)                      |   if (pmd_young(pmd)) {
> >   PMD marked dirty by hardware  |     set(pmdp, pmd_mkold(pmd));
> > MADV_PAGEOUT/reclaim            |
> >   dirty bit may or may not be   |
> >   set                           |
> >     reclaim/pageout may drop    |
> >     the folio                   |
> >
> 
> Thanks, nice explanation (even if the >quoting ruins the indentation on my editor
> :P) [untabbed for my benefit]

Thanks for the review :) indeed the tabbing looks ugly when quoted.

-- 
Pedro

