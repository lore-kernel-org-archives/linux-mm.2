Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5603EA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 12:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A4E6B008A; Mon, 23 Feb 2026 07:49:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E366B0092; Mon, 23 Feb 2026 07:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00596B0093; Mon, 23 Feb 2026 07:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9884E6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:49:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F57F561DD
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:49:25 +0000 (UTC)
X-FDA: 84475702290.08.0174FC4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0520318000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:49:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hWCh/fcn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=730yGY6d;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hWCh/fcn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=730yGY6d;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771850963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFN7V026lnmVlaoqZPmxvQqPSRV+rY5RviyiO7CZHLE=;
	b=vTDkoNWrswizASlpbbVQ/5BiJTa5gaoyUthEdQkK/VQkbR0QRGd/0Ih72ek1E5pILXx92Q
	WUnLFtWjirUUSLaEE9trYpMA5E3wrX61M7b4tXg54/w3YsYs2XlHG2kleyCYdAi3p7qf69
	+dyt3LIOxedw9UmOj+7IrjfAApJxLwc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hWCh/fcn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=730yGY6d;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="hWCh/fcn";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=730yGY6d;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771850963; a=rsa-sha256;
	cv=none;
	b=caTTb6cAabIQiMuJm1tNWImdOHj5B/j6WCsEyU++zwQDp/qvifiAgY7IXl9jPU2ioBR4Cd
	wJ+SFtiZdLE9W8bV5EvQIZEC8IFDU34OCllPkwNrG/gQ32H41JTL/YH/3eIbsHMZYn9nPO
	b9n03VbmL7zzOAc8YRUv80foNvKVG6c=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AD655BD1A;
	Mon, 23 Feb 2026 12:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771850961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFN7V026lnmVlaoqZPmxvQqPSRV+rY5RviyiO7CZHLE=;
	b=hWCh/fcnYbWOr0SnKn+8Gvp9MsGvJLNT9fHklv1eZtUszRDIHovvz85EMEjwHNGndCJJFq
	yKsJQRxQEfsfCq1SzEwcovuaP0m47F3E2kwUn+Mqc1rXsI+fKEwVdClkxApqUGmEyT23ht
	wREDMy+J+vw6Jb8dMd7IBYXp9yi4Ltw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771850961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFN7V026lnmVlaoqZPmxvQqPSRV+rY5RviyiO7CZHLE=;
	b=730yGY6dEaj+Z3/XQywCS/aZE3fxtDGf7MGWUwWGhX4N8yLwFrbffzt/Bon2lXIlNw3a/B
	LzAwqbD5sjsSz9AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771850961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFN7V026lnmVlaoqZPmxvQqPSRV+rY5RviyiO7CZHLE=;
	b=hWCh/fcnYbWOr0SnKn+8Gvp9MsGvJLNT9fHklv1eZtUszRDIHovvz85EMEjwHNGndCJJFq
	yKsJQRxQEfsfCq1SzEwcovuaP0m47F3E2kwUn+Mqc1rXsI+fKEwVdClkxApqUGmEyT23ht
	wREDMy+J+vw6Jb8dMd7IBYXp9yi4Ltw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771850961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFN7V026lnmVlaoqZPmxvQqPSRV+rY5RviyiO7CZHLE=;
	b=730yGY6dEaj+Z3/XQywCS/aZE3fxtDGf7MGWUwWGhX4N8yLwFrbffzt/Bon2lXIlNw3a/B
	LzAwqbD5sjsSz9AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACC2A3EA68;
	Mon, 23 Feb 2026 12:49:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c4qlJs9MnGmJfgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 23 Feb 2026 12:49:19 +0000
Date: Mon, 23 Feb 2026 12:49:18 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com, 
	catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org, willy@infradead.org, 
	hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <fqsd4x5oqavouhwawmsmpanaszvr6xsboc2oeqzs3fafrtovpk@gfnqznoqlabk>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
 <a778d249-afea-4488-b045-beff3492a48a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a778d249-afea-4488-b045-beff3492a48a@arm.com>
X-Rspamd-Action: no action
X-Stat-Signature: bkjft7tykr5nr6pmghaj6kqqawbekn51
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0520318000D
X-HE-Tag: 1771850962-303604
X-HE-Meta: U2FsdGVkX19HuBbzT02y9oFE5gDu2xJ0qWp7gBQAjUjyY0xsc/AdUC4eofxDpsfOPDBTwtrQ8FMsjeDUu5CUBHCRu/wqmW+6GWf56d59F04pKRcEHkAyCYCoJ/mJrDEFzaa2DaLgSJl2uyRNd9PPsIqL3OX3Mk0lQgRIkvEETJJj1otI8XcNJsC9mvcd2+IjwuLzPlYthCq4i1WhNzolR43nNeC62kLr/cRkPrrLij62SdQjnc22nZXQkMVTk5W8zprsmVYL1qVjhcVISuP5FpoKcJrz7NGc6eyfgBtXul6Swc1g8e5FsYEpKPAdVA7YOmRll4eXJDewKyS2D5qHNtejxo3+Ca3nDhYLm0su5HPffGN7wY33OXTaoUPU+W1lrbvdr3YrgdmS/M5WKt+K8MWvebd1fGD517xPnZfe4c6jHLRMEmp9WlaPfseglEB7GZzge5p55X/233gKv8ipeusb/Tlj2NkCJJCxGDThAuMPcmPTkgKbCc9OT/lEOBtFIs0YCg6bKcYakvSKkvm/5Z25wFTo2XmOyPBlvxiM+EwCrdIvX2mmFGpD6Q+KDJI3fTKpB0mQ7MygkUqA+4cEwq+kQksCaucbFIPW2WEaoRtnC170+YyZhHGwdCO/KpGiNYx0ZO3FzkLd/9Os6UgVQpyGXFnfJ5ubNOjjSDXI1R5DuR6jahnEbnRIyYxRGjF+nhXGngNStP2rrNLjdSIOKJhQCjBdzfXDEO98wywIbIXZaPywOLI97yNym96Yi8hsd6UmIGUtmGKkb+y2srDceObfiyv87eUUK8O/CF1FqN83YNaWVA3vm+n0tyGmvayu4TJ4atWX2muf1g0JoEiD9F36v2RXyU3oopiabga07LIzduRfbjOFuPXzJLncdmNplB1MNqgcluWpbqJPcFtm/XtHd8nsRP5c+fIYGQ36Cib15Q2UlFC0JTQ8GlmrzXD2P7AGeaAvwx2Cf+53IOX
 KLdds7lr
 hNkWmf9d2qQ4J+VAIMa9/p3fnJVv/GtcrvOwzngF4aEgpHlsNBkUhSuoDwZ0VQxk//neigcpzWOoltHb8vGgz9SrWn2Rmpt7zRXsS1eEeV6z3MpnNJwRJHLI+ZqcntXuL2cjbHsLsuhnPPYJZDvrmfa0uhnAC9a/9nRKX6qq+TP99LPozipws8xMpWCgC9uA42qGCIuxQVZ1zbEAxiB2+sZEPUInoaPIpaCI04MwJT1gEV+gpnnM980zrjbqEBJ4pcT00HruG0IPlU6a05OkpRkbxbaXInZSacoM4Xi5k7xpnLRM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:37:55AM +0530, Dev Jain wrote:
> >>
> >> 3. Translation from Linux pagetable to native pagetable
> >> -------------------------------------------------------
> >> Assume the case of a kernel pagesize of 4K and app pagesize of 64K.
> >> Now that enlightenment is done, it is guaranteed that every single mapping
> >> in the 4K pagetable (which we call the Linux pagetable) is of granularity
> >> at least 64K. In the arm64 MM code, we maintain a "native" pagetable per
> >> mm_struct, which is based off a 64K geometry. Because of the guarantee
> >> aforementioned, any pagetable operation on the Linux pagetable
> >> (set_ptes, clear_flush_ptes, modify_prot_start_ptes, etc) is going to happen
> >> at a granularity of at least 16 PTEs - therefore we can translate this
> >> operation to modify a single PTE entry in the native pagetable.
> >> Given that enlightenment may miss corner cases, we insert a warning in the
> >> architecture code - on being presented with an operation not translatable
> >> into a native operation, we fallback to the Linux pagetable, thus losing
> >> the benefits borne out of the pagetable geometry but keeping
> >> the emulation intact.
> > I don't understand. What exactly are you trying to do here? Maintain 2
> > different paging structures, one for core mm and the other for the arch? As
> > done in architectures with no radix tree paging structures?
> 
> The mm->pgd will be the software pagetable. So suppose that do_anonymous_page is
> doing set_ptes on the PTE table belonging to the software pagetable. We will
> hook a "native_set_ptes" into set_ptes, which will set the ptes on a different
> pagetable maintained by arm64 code (probably mm_context_t->native_pgd).

Traditionally, you do this kind of funky manipulation in update_mmu_cache.

But this is still an extremely complex and invasive change (that I assume most
people would not like to see) with dubious benefit.

> 
> >
> > If so, that's wildly inefficient, unless you're willing to go into reclaimable
> > page tables on the arm64 side. And that brings extra problems and extra fun :)
> 
> I didn't understand the reclaimable reference, but yes we need to make this efficient.

I'm not talking about CPU runtime efficiency, but memory efficiency. Doing
this makes you essentially duplicate page tables - not exactly ideal. This is
a Known Problem in classic UNIX systems which do something similar
(but not the same): anonymous memory pointers are stored in some intermediary
structure (SunOS and UVM call it "amap"), and paging structures are entirely
redundant there. They can freely tear down a page table because they can freely
put it together from the amap and file mappings (what they call vm_object and
we call address_space).

Anyway, I'm boring you with these funny historical details so you can understand
the similarities: the Linux page table format generally matches hardware, and
we store anonymous memory "state" there, so you can't ever tear-down a pgtable
without losing state of whatever was mapped there before. However, if you go
down the "arm64 now has a separate pgtable structure", the roles switch:
arm64's internal page table format makes for the real page tables, and linux's
pgtable structure is nothing more than an "amap". So you could (and perhaps
should) freely reclaim arm64 MMU page tables once memory pressure hits, because
they are freely discardable.

Does this make sense?

-- 
Pedro

