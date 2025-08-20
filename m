Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92935CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 14:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0CA58E000C; Wed, 20 Aug 2025 10:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4118E0003; Wed, 20 Aug 2025 10:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9C18E000C; Wed, 20 Aug 2025 10:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAA998E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:29:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F2F183896
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:29:25 +0000 (UTC)
X-FDA: 83797368690.13.E55318A
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id ADA4620005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 14:29:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kiDI7Vli;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=GX6oukrz;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755700163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0R9AQPmRbYMvwJGQyRIbyAyWRhXxzoL6fzlgh2yodPw=;
	b=mRC0eNoOcHhL2Gtdftsiz/4Xk849I6wHMkADS0MSj68wmQK3f70AOby5QTfI1Yz4H1HFAB
	/JvNtK6l9TwXIzKbd4duu6Bd6mFINUM7jxRDo7Ui7HaTOagL9iWRDjkgPTHKq7bqO3+BSm
	w7lUnkTPBFn2PDS/n8/x9pyJQZizO1o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=kiDI7Vli;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=GX6oukrz;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755700163; a=rsa-sha256;
	cv=none;
	b=V1jEyFEsLgQi53b9Mo9d3zJM0ZxCb1EAyNOYMGr8BIM+sdq3ZX5Hxkcdx/8wrYi5DmDy27
	KuVQD36+iTJxchcNl4RyXc1mZtrZetS6MmgajzOhqo7CtPLN0H2FbuCodBgGCYpXW5WAyC
	qdPhWeDVErGw1PuHMrukWTqwkNUGbeQ=
Date: Wed, 20 Aug 2025 16:29:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755700161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0R9AQPmRbYMvwJGQyRIbyAyWRhXxzoL6fzlgh2yodPw=;
	b=kiDI7VlipbXXRaLgH6llw4hWvYZTSC0MYIHjxPF9zn0IvqSu0nrVhUpfqPpwuB+arQ9H8T
	qu97srbNgSLoa9NmKR3Hng7Z1iyNUdZRQjAFAkCqr4KNhGAhOOflvm4lFInNcRSrHy8caY
	iGeLUCQK+/BAzAguAn1UdUqaKzp3sttj5t+fFTeN0Xu4r5cLwhWGgjGRAxmklWAAFWfrLG
	A/ShHeEf/ZyKeMSi0kH538TnLjzhHcEBjMSSXnB+WESut09CXlpFb4R4YcXLvnqj+Po2gR
	voJYYYgovR6U9WXYNta4fqVhkRXG4GR4kAhsx4GG3vgVT9gLvsyJQlp11Bov2A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755700161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0R9AQPmRbYMvwJGQyRIbyAyWRhXxzoL6fzlgh2yodPw=;
	b=GX6oukrz3GoLun30KHSeZSUOQ5ufHTWdFAU1fEFVzDePZtuPJyFIz7+lwJrcYXwUUBkRP0
	wP/QPnUwsAlMVgCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Krabler <Alexander.Krabler@kuka.com>,
	Hugh Dickins <hughd@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Mike Galbraith <efault@gmx.de>,
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Dennis Schimmel <Dennis.Schimmel@kuka.com>,
	Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Subject: Re: Realtime threads delayed due to kcompactd0
Message-ID: <20250820142919.HTybedrl@linutronix.de>
References: <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
 <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <33275585-f2db-4779-89f0-3ae24b455a67@suse.cz>
 <771a8fc0-8195-44cc-55ed-c3573d497d2d@google.com>
 <DU0PR01MB10385C55AEAFEBCA2575EAA77822CA@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c5bd00d6-e6ca-48fd-a11e-c90fa9c50e05@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c5bd00d6-e6ca-48fd-a11e-c90fa9c50e05@suse.cz>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ADA4620005
X-Stat-Signature: 3tuzkouatap1mu6inpymq1ftexr5ezmr
X-Rspam-User: 
X-HE-Tag: 1755700163-609257
X-HE-Meta: U2FsdGVkX18UOIXoHf0CI3orAvG8BznbTZNeZHfhmVBcN1+12k0V4vVpFQSj9qkkcPVL49Swy3ZPkFmoDTjePIAuvoWnku8SW4wgE0coD7rAoZxC0EJxDrmaTqVLkYTJCiPTOYxJqvwo8vFKRDLUqmokFrjHA3V74fUWbP3Ip4OPjZDvEU4jCw37+giU24SJLMInT1dcYY7uUcFtFyQtMQqu3eTLXDpVmVTGR3dWw7JfsIgbZHr8U4N5TJ0hzQmkvhG2JTAa9En+s9aIE0e63bbRfdZdC43RXMCAyAQUbXWSi91dzxuJiz+qKs9o91UpdYEWxrrBtEG//TEFpLKYYW/UQ4NvtcJDX3DvOqppklVYRhMbz9QlS+gr4K0MkJTVQ7mcctiDxJk/QAZl/KnF/WJBpHSIQH31gXExPbwFnKjCciQ+nOprxjnXCm+mp4f9A+qfnt73f2G/oNq161TCu4akTf3oowc8CSfm3gYVQXgVwrBq/P/D3q8y1cgXM3jcACr8iRIOH8My1TgzJpsEVBSSugvhx6qhH1JtRd6cTJWeHnjQqv5YI3U10NdsfZh2sy2ca3zsXd4u41MTEKPTQzZq77z7uG0t4JGYEL9fcN152BOOfIp+QwgfYAuZG2IzABQYmAteAfdyOto3Tmv8aozdZlxmDKyRr/8COo36B3w3yiN/zGEdRLFb3sk6VtBndtqZ1ir3HuNwm7iMKFFLo+Ys7oN2zQjjpxkpfKLRJqScbUruyrLw+57r8mXTlJ5JOosZZM9AuZBOQlnuFkixdEAv1NLCdcWs8GUG38Y+/v3cjaxTf28nPtYmZsStPfPOVfL6F/8OFAWKUqrhSBWWfyOthEzTdul/lj5jaM4NYa9hD13X5u8MndfWktvqbev6K/Pcdz+LED96BdSyYVKDKFslERXmFJgBnugKVmVZC1tL6lEw7SDWiWO47/PKlQ3re5ytPz7CVnRu47LezA8
 /8EcLQa5
 Cf/RvoTmibPZB7/ZEY5CQf+l21J2lD79sPeZMDmwRwUWqUKeHii0WgNzS041cI7wdBQNAknbbsqMCsTUdhD4IZSOWyeypdnLJHWf1jKqvmtjQ//JdJBKLvfN4AD5NP4HQBooancfDjIt41ofGqFHelcU1FAuUVanNeGSWjNxbey698mOUzejRXCFRptZVTAZV5bRzUy1C6STbb4o+Q43gOkRth8tdmYkODyQsVsYe4pYk3Vw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-08 09:37:26 [+0200], Vlastimil Babka wrote:
> > Given the information I got from here, the comment on the code [1]
> > and an older commit message [2], I suspect CMA somehow influences our problem.
> 
> However, kcompactd doesn't perform CMA allocations, only compaction, in a
> mode that does not include ISOLATE_UNEVICTABLE. So this is weird.

As per smaps, the RT task should have all VMAs listed as "lo". If use
mlock() then something like an accidental fork() would remove it.
Otherwise it should be there.

At the time of the fault you could add something like

| diff --git a/mm/memory.c b/mm/memory.c
| --- a/mm/memory.c
| +++ b/mm/memory.c
| @@ -4476,6 +4476,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
|         entry = pte_to_swp_entry(vmf->orig_pte);
|         if (unlikely(non_swap_entry(entry))) {
|                 if (is_migration_entry(entry)) {
| +
| +                       if (!strcmp("tRealtime", current->comm)) {
| +                               trace_printk("Migrated: 0x%lx VMA flags: %lx\n",
| +                                            vmf->address, vma->vm_flags);
| +                       }
| +
|                         migration_entry_wait(vma->vm_mm, vmf->pmd,
|                                              vmf->address);
|                 } else if (is_device_exclusive_entry(entry)) {

to see address is gone. Not sure if the PTE flags are of any help here.
Is it easily possible on the other side (isolate_migratepages(), right?)
to figure out which task a certain address space/ page belongs to? So
would if a "bad" page is considered for migration.

Sebastian

