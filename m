Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC18CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDE06B0092; Mon,  5 Oct 2026 06:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB60D6B0093; Mon,  5 Oct 2026 06:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC1B6B0095; Mon,  5 Oct 2026 06:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0CB6B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:25:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C71A1C01E4
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:25:02 +0000 (UTC)
X-FDA: 85288189644.06.16B94B1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9A5A440008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:25:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikDzCcEp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=imk4MGAA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Aki+slgp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PzR80h+l;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791195900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFZLgiG+4IlxeGD7HzroLABOVng6ksFHCgPf63OPIsQ=;
	b=rkCbqXJ02BcRyaYY6w3heu4ljtXgn8ZG+JvmNh+USAUvlafLFz/zi63ADU3xGOX3C+/AUq
	QF7ufNYnX0iwXtYgF+epV/dTxgmFFIhtJPSroAYBFQigB7Aby98iDJ0nnlCZ3AA1ZPaDAD
	OI6F1QX87lQeuEPIKoHRnockB1gqoA0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ikDzCcEp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=imk4MGAA;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Aki+slgp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=PzR80h+l;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791195900;
	b=t+UOD992nFZvYD3XJo6zZVbODu42tqLYfiz4O/He1xt8iuxE0UHzRJuKL508wqFzEogH+h
	Oczg4stPEdPeKCYwiKZLwjuQNETJWpQxeNjcD7FcDr95qLPvLR30agKkhs0HO5AcOWAzks
	K2Je9GC8K3ieMbLBmy4r/b1qW+MBsf0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1177721C05;
	Mon,  5 Oct 2026 10:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791195895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFZLgiG+4IlxeGD7HzroLABOVng6ksFHCgPf63OPIsQ=;
	b=ikDzCcEpGmruSsQFidAwp9wkCVax1gJ0Pv2ATGDvLWy03YdpR6dCYK2gB8XyOYeTVcUeeq
	f5SHU+sPvKCd9adBJn8PZ8yYrP59v7aZHRC53ZR9MscOs64jCNeO7Cyh8jBT3Q7JiaXG4Z
	e0WW02FyNpBpXroTiDYKc4JPGHoKAPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791195895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFZLgiG+4IlxeGD7HzroLABOVng6ksFHCgPf63OPIsQ=;
	b=imk4MGAA27siQ7Wm3brQLl/xx6WXMa95OMHIlhcvzjR7gINYEK5qo/eTF3K5VTDqSCeNxB
	q2eH36l5FgbsMyDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791195891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFZLgiG+4IlxeGD7HzroLABOVng6ksFHCgPf63OPIsQ=;
	b=Aki+slgpTsmNNEwyAniczbuR1ttLN3oToyA2eo3vd9afv2kR8oLde1VoYLDH4JRcWyXv4C
	OOcf5d15kRYXS8KYok+fFklkabzDFcudjYtsc3txnNn2v24ZqxFf3puDeuERonyf4RFXep
	euC+wEF0YcP/jgOd/97BWOXRDFYL6uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791195891;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kFZLgiG+4IlxeGD7HzroLABOVng6ksFHCgPf63OPIsQ=;
	b=PzR80h+l23n/FtRrjUo1OMeYZiUz9OAVyLs//nM87tk51pUm3lBc4cW9t/aW1mpex2kvD8
	V7NfQgyq5ps/b3Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0BD8132D3;
	Mon,  5 Oct 2026 10:24:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HqCSGfJ6w2rFIgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 05 Oct 2026 10:24:50 +0000
Date: Mon, 5 Oct 2026 12:24:49 +0200
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	riel@surriel.com, linux-kernel@vger.kernel.org, qi.zheng@linux.dev, 
	nadav.amit@gmail.com, thomas.lendacky@amd.com, kernel-team@meta.com, 
	linux-mm@kvack.org, akpm@linux-foundation.org, brendan.jackman@linux.dev, 
	jannh@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com, 
	Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org, toshi.kani@hpe.com, 
	david@kernel.org, mikhail.v.gavrilov@gmail.com
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Message-ID: <asN4wjUbDAIcrfA-@pedro-suse.tail5790ac.ts.net>
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A5A440008
X-Stat-Signature: r84c9jhfkuqmd1jw85obrebnoq4wd63d
X-HE-Tag: 1791195900-214814
X-HE-Meta: U2FsdGVkX19q7NUv6h0yS9ikDoaeKRJc1WxU84ml67/Hep++lO2skporbP8VX5xybMCS8OvFmwPLLPCCFMhJnjqh+pGsAQKVdiDo9JqAwf4wTeRPETyiFWRM3QqloEyCUx9Q+3zBiFdkhiUQNtawyCi5/l0C2MnK422u2gku07ETPK3fWkVt5Qivlq1MdHG8Gt7+yQxjqqVaLk8lIciUZUryXxFgD5enmWxb/hVc6ohaQp0zPp5mspGcwEOXaiI6tQfGCOsLZn+zPs33bOQWBy6BXKMdB+B7LvCh2SJ28FXfc+gn9aYrv9KCoV52dNhuaJYgHd6x0XrPqm3YRfWNuNcl0hw0pexlvvMmLXQtyLYMBkNCXDznNBxxA4TMWrWMmoRAjGEUS+4tweLRb/RUMGMDH9Qls4LQEiI84dvcPj/sezMAmKER9iw6rJ3+TbkWcwxhtQqvZ4lNCmz/BZYbla7bLesVf6KeBjjACirw88Om2PYs2gPA9+mgZlaQ9Ol7LxAjeVJ1oaWSEbxCbLdnndZTuHipasCg5YH22AvLKQZTNFZq4Cd5mLsyTU+L6Ftt4ncGpIEfkdp45KpNm55z5Fj7+s+Q9BE6UCJ7i3qM4+/6MGuUZw7QHwcPMxRnyt4/7fhkTdX4BNVg0NuD+Iflra5rRMeRbyRItVDZdEMg+bHjwJqS2+AxAVErLatYTW06I8b8U4xTV3ldTL5CaNsh6w0zn+ifMpHP3IF1DdW+M82key/gPeEWdQLnD7AqYR+hcrZ1s0r8XwnkRg31Y3BjqfPBfoITrp+5W+lD7ZI3YMuKs8dG+OL844CROshPBkzC494TtcVoUeMdUz4ZcqPZee2dWnuJldnwN2jqrJHkJ1UbOWyhUa6FHhIgWw8DzlWOespFzYWh2PO/TmC74fmp0Uv6HyisgyYDku+2OU/SPTOonxIrfCj5nLc94k9BQlpQ0SpwwuW6QYPNvXMg5+b
 EOr2DV/9
 bpmgkoR80aE/ay18TqA9ZI3b3bMgTa7tDZvXYPqrso7HlAaNtDjOBIiDLnVTcl9JZShzhU2mE+pfdLfQCws+OYbxG27FjWykn8h9/1exc89INlbLKvQOMS9ItQDAsCYh9WfJW11tQ+LUMIhXMPznsiTfzH9INNTALFzC1dL9tLpVPfE2KsYHdQ3Unf+0jOyeg2OjBp+qjIRCxvvSz32iQ/ycJH+Lu7Sxdh/6n6yVBjeGP2lQtQ7w/iJIGiNWIY9VDERJpjgqeFSJJbiVdiPz2YXFcZ7hAgqMs1wSod19Rcc8/eJkAm2Fr6l5TLqZWfvxNGuCaiyBavTOzRitutuYfknb++u8hEgEqL+eVprp0R9zP5bA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 03:29:22PM +0800, Lance Yang wrote:
> 
> 
> On 2026/10/5 14:09, Pedro Falcato wrote:
> > On Mon, Oct 05, 2026 at 01:23:02PM +0800, Lance Yang wrote:
> > > pud_free_pmd_page() uses a single-address invalidation to flush the
> > > paging-structure caches before freeing the page tables. With AMD TCE
> > > enabled, this only invalidates upper-level entries associated with the
> > > target address. Cached PMD entries for other addresses in the PUD range can
> > > still reference the PTE pages being freed.
> > > 
> > > The AMD manual quoted in the commit enabling TCE says these instructions
> > > remove
> > > 
> > >    "only those upper-level entries that lead to the target PTE in the page
> > >    table hierarchy, leaving unrelated upper-level entries intact."
> > > 
> > > Even with all PTEs cleared, speculative page walks can cache present PMD
> > > entries after the earlier TLB purge.
> > > 
> > > Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
> > > the single-address invalidation otherwise.
> > > 
> > > Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > 
> > I'm not sure this is correct. The PUD is clear. We invalidate the TLB, which
> > invalidates the translation caches for that walk. invlpg will notice the PUD
> > isn't present. I don't see a case where it can ever not clear the rest
> > of the translation caches for all leaves. And, in fact, by that point the CPU
> > can (does?) probably formally treat the PUD as the leaf.
> 
> IIUC, clearing the PUD in memory doesn't invalidate cached PMD entries by
> itself. With TCE enabled, flushing one address only invalidates the entries
> associated with that address ...
> 
> (That's how I read the manual, but AMD folks, please correct me if I'm
> missing something.)
> 
> So couldn't other cached PMDs under the same PUD survive?

I don't read it as that. I read it as "flushing one address only invalidates
the entries on that path". So, if you flush one address, you'll flush the
whole translation cache for that range. And page table zapping agrees; if you
follow the code from zap_pte_range() -> pte_free_tlb(), it will do a single flush
for each PTE table (if the whole table is empty/non-present).
 
-- 
Pedro

