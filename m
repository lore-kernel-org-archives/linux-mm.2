Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E46CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B716B0088; Wed,  7 Oct 2026 11:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13516B008C; Wed,  7 Oct 2026 11:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C021B6B0092; Wed,  7 Oct 2026 11:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 973866B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:31:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 261EC1A02C9
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:31:14 +0000 (UTC)
X-FDA: 85296218868.10.623F6B0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8B78C20007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:31:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0ZxXHC4k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HQFpAvIU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZPoMcQDL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/O5ZdOKZ";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791387072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKPUfCJhlflk0uwX+KBsM4WKm16aQOajsgQ44BW6Qm8=;
	b=rliss9xJ2eOgH9UKJAoiqLEIewnW2tWZBalqfkbsVcKWpq/Jw0Ck+lPmncwLUALycuqZVw
	Y3UjzzO1344G4eugap71ZajKRK/YxYyz9UtRho++UCzi9CCzWPOL0zR+3XMtXuV1aRVmWM
	X+KO9xjjp6CBu8S/GjVwuE5/Lrs+8m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791387072;
	b=aBzgENmW3Qn3Vj2savrWHwYmxuos5yfFmNu0k0sA4rN7cd9BfasOeEs9XEpLc7Kqi7c6jm
	tYD4Mb2WE1mqtoBBo9OIahdm238RnhrnLvgGrTbTf6SwskZmRN46/JIaJ+Ga8XOp1AOIPE
	75/0mzKUBGc0rg1yIyQe+BM6xzyGo4k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0ZxXHC4k;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HQFpAvIU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZPoMcQDL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/O5ZdOKZ";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF4E41F38E;
	Wed,  7 Oct 2026 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791387069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKPUfCJhlflk0uwX+KBsM4WKm16aQOajsgQ44BW6Qm8=;
	b=0ZxXHC4ka1xuQYUrXRi0OminyAcERHub3QqJZ6kybfU/BHYdhBaSPKDkYh3Eel9mp0ufl6
	I5UinFg9T/QuoncK4qHK7YdmtrFmplNx+35PB6C9GXcL5BHpxIgjorhzKNwyQLwy9pE4UM
	Tr1nPAiKmOlGI21wmjrXeS3XptgdEyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791387069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKPUfCJhlflk0uwX+KBsM4WKm16aQOajsgQ44BW6Qm8=;
	b=HQFpAvIUhV+r3v7TjyntctRoJcFSQRcwWtHW5X7aD5HSR90/1E4wFoirjCDBRhFqZc6jOo
	VsKLBQ0ai0Fy3eCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791387068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKPUfCJhlflk0uwX+KBsM4WKm16aQOajsgQ44BW6Qm8=;
	b=ZPoMcQDLwiG2EUx3rlHqPar6RcaGeZPSSX9V5Z9OZpJCP5DcMb6FWLq+EEoPl+FZpNIS5v
	7hSrpfLbHLDnwKvIfpG9ufDd+2Bh4qh5dZEFNxSjucFtBUrya6K/UvztmD19iJdecPE4SN
	yoCQOxFEa9VecTjxgnlha0YYfaHjz78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791387068;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKPUfCJhlflk0uwX+KBsM4WKm16aQOajsgQ44BW6Qm8=;
	b=/O5ZdOKZft35nGNZM+hjzrbwAlwXK7038yjNaxihe87F9ne9VrG+5zJwJBatp8+bhaJSuk
	emUiJqoSKBVBODCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CA9713354;
	Wed,  7 Oct 2026 15:31:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vdkkFbxlxmp7EgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 07 Oct 2026 15:31:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D3F9DA13FE; Wed, 07 Oct 2026 17:30:59 +0200 (CEST)
Date: Wed, 7 Oct 2026 17:30:59 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, willy@infradead.org, mhocko@suse.com, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, vbabka@kernel.org, 
	liam@infradead.org, rppt@kernel.org, surenb@google.com, riel@surriel.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] mm/readahead: avoid per-folio memcg reclaim
Message-ID: <vp2tbdccb3kpxk3xrpcsytqqfq5dk6ugnvccb5hyh7bucgrzfl@wwajglc2ckeb>
References: <20261003001555.3498357-1-joannelkoong@gmail.com>
 <gz7cxhldkfkinbzpx4goa6rhdqpzldpaenzhtfoxcztpzj5avw@hkzo4fbdbck3>
 <CAJnrk1ZaYAy_81OVxZ74wF1EXF8j13giGdu_CD7Q3XLzX-XThQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZaYAy_81OVxZ74wF1EXF8j13giGdu_CD7Q3XLzX-XThQ@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B78C20007
X-Rspam-User: 
X-Stat-Signature: cwj999yfxztqnzo3g1w61wjnapndwyhi
X-HE-Tag: 1791387071-993951
X-HE-Meta: U2FsdGVkX1+KuAvAPgatuKTA9rLql0h8Np3EOlVdE5n6ntmRcNNsJ7bKSxF7ZmybgTjQz4Qyiz2VlHwbgxGS9VPBDqhUNal52+GvGH2FheOwviw7H6X39OOoHzYxYkVy8/doK/Uk5p8G5sA+HlfQpl8TLVziJ4wg2yuuoZnX/LHzz3+3GVpcCrgilJD2Mpoq0a3ZTzQqvrqvvmeULmexnoKbaAVSNTffOq/H+ihyZqZA2AkOsjhjRAetNt3y61l8/KTma99NZpPmITZyWDSLp5ani9vfrZ0v9pLJcnlxc9LkOSQRukeNTY90bgWfuhenhXRgkNb1UJWFVNn7nA1j983Yf7s2t5mAXQWGESPjeDNXqQxlin9k78x+CAEICxbIG0J5Ww+H8P1j4HX1WtYii/aBs1Waks7hcAu+0wYmtQpApMvydZ5yf7whXoStTZS/KTO84yIiirdnbzyjCkCUYDRwjzC8SmqJiZkgGnSCT0JG4FgtOmwopwudpHTyJfv+hP0KizS5/a1GjOsXc1OfqQSl7jsubDkZJ9uSeFhxMuiUL4wba1hCPhHNwBRTVLz86ByydMU8F1RMWHsxcsbYF8I02K4CVjJ7s9poHufvKSNmQqQa7gonaf21hqi7HBVyfobAIY7s2x1Sv5U/amE7GzfCDrYv6LrHjgLkAGCiIVTQFpmutV/KQ7FrWcxvoh3XtU0NBQpLVeVTrMXZYeUXIZHDlzMKlGm0i831APl48j8T7nqMjXasZPir/8KZfj14xnP2wGMsNaAgkofHLa5G4dr8PIQ8QcvQ74upGVNa3BYsU7LX8xkL8y8iInkqG4OpzKliVhk58YGT19OmREWhqA2KKya6kaooCEWCA61H00FLJFwlFCbDDm6ApzGGIjQ6eruO2HMrvFWKl6tsFQGD89z5vvSh+bBH/aZ8MyMNLmCBspx3TaLE1vVh59Cvt5zRXPNWZjidNi/PGFNHrQc
 6u0FAZqU
 oG4iWGCHW3pHX2MtlgpD+m4/1R/KF60AE4OQKXezXwk+HM6+qjqcRDc6m0/JcOpeDXlL280N1LbLIvwswMLJ802NtiCpOud0JSR1swmUMOfSOAGibLs+vI2pDHPfBahM00TH5hx9T4FWHFXPf06fndRE0FVUOgyyaWL90iCjaUIO1mjccWfC+F/N86BGZzB+Ftd5qUfHPR2HwfH9+/XMzZodQYX6Z00aZIw0smWSVJERKxFGs9AYSNEmYt2WKYXaIqnJd2ugop+bzyWuDLhUIu3Uwa28z8SPeHKLu9DBrYaYsf/UM4qu4US4Dc6gujdr5MOl/E7zy57PTUZC4re+v778lDaQOyVU3aFl86DwKnsid8p+mjRRp8HfqN2ZwikLQGFmD68tCf2a9DFdmtFLJl0ZI+TPItZU4BsBV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joanne!

On Tue 06-10-26 16:01:28, Joanne Koong wrote:
> On Mon, Oct 5, 2026 at 2:27 PM Jan Kara <jack@suse.cz> wrote:
> > On Fri 02-10-26 17:15:52, Joanne Koong wrote:
> > > Readahead adds the folios in its window to the page cache one at a time. Each
> > > folio is charged separately. When the memcg is at its limit, each one of those
> > > charges triggers reclaim. With many tasks faulting in the same cgroup, the
> > > margin one reclaim pass frees gets consumed by the others, so the faulting
> > > tasks keep reclaiming, all to make room for speculative folios, and in the
> > > worst case, reclaim livelocks.
> > >
> > > On Meta's fleet, this per-folio reclaim is a large cost. From fleet-wide CPU
> > > profiles at Meta:
> > >
> > >  - Page cache insertion (filemap_add_folio()) triggers about half of all
> > >    memcg limit reclaim CPU, more than anonymous faults, swap-in and
> > >    memory.high combined.
> > >
> > >  - 93% of that comes from mmap fault readahead: filemap_fault() ->
> > >    do_sync_mmap_readahead() -> page_cache_ra_unbounded() ->
> > >    filemap_add_folio() -> mem_cgroup_charge() -> try_charge_memcg() ->
> > >    try_to_free_mem_cgroup_pages().
> > >
> > >  - In filemap_add_folio(), 83% of the CPU is memcg reclaim while the page
> > >    cache insertion itself is 6%.
> > >
> > > Most of it comes from services whose worker cgroups run at their limit while
> > > many threads fault in mmapped files, mostly on btrfs, which our hosts mount
> > > with compress-force=zstd:3.
> > >
> > > This series adds readahead folios to the page cache without direct
> > > reclaim. When the memcg is at its limit, readahead reclaims for the rest of
> > > its window all at once instead of once per folio, and tries a second time if
> > > the window runs out of room again. Please note that this only applies to
> > > speculative readahead folios. For the folio a fault or read actually needs to
> > > read in, it is still charged with the mapping's normal gfp mask (with the
> > > reclaim flag set), like before.
> >
> > I cannot really comment on how much sense this makes from memcg POV (I'll
> > defer to people understanding that area better). When I'm reading your
> > problem description I'm wondering about one thing: Are the folios we are
> > faulting around really used in your workloads before they get reclaimed?
> 
> I ran some traces on two production hosts and am roughly seeing:
> * of the readahead folios that reclaim dropped during runs, ~66-78%
> had never been mapped
> * running a 60 second sample: mmap read-around accounts for ~86% of
> readahead on both hosts. 77% of the folios it adds are never mapped.
> Around 10-15% are faulted on directly and the rest are mapped by
> fault-around. mmap_miss skipped read-around for only ~2-4% of major
> faults. For faults that triggered read-around, mmap_miss was below 10
> for 74%-96% of them.
> 
> This looks specific to mmap-readaround though. On these same hosts,
> I'm seeing much better utilization by buffered read readaheads (only
> ~30% never accessed).
> 
> I think a big part of what's causing this is that btrfs by default
> sets ra_pages to at least 4M (in open_ctree() in fs/btrfs/disk-io.c).
> In do_sync_mmap_readahead(), I see "ra->size = ra->ra_pages;". So it
> looks like mmap uses this same value directly for how many pages to
> read-around (with 4M ra_pages, this is 1024 pages), even if the faults
> are random accesses. I think this also accounts for why mmap_miss is
> so low too, since with the readaround windows that large, most faults
> land on pages that are already in the page cache, and each of those
> minor faults count as up to 16 hits, while each major fault only adds
> one miss and happens a lot less frequently. With many processes
> mapping the same file, I think it makes the problem worse (eg each
> process has minor faults to map it to its page tables, but there was
> only 1 major fault to load it into the cache).
> (Adding the btrfs list to cc. Apologies for not doing this from the
> beginning. The full thread is at
> https://lore.kernel.org/linux-fsdevel/20261003001555.3498357-1-joannelkoong@gmail.com/).

Thanks for looking into this quickly! So basically your tracing seems to
confirm my suspicion our read-around logic for mmap is quite bad.

> Instead of having the mmap readaround size coupled 1:1 with ra_pages,
> do you think it makes sense to compute it differently? Like either
> having some sort of fixed cap (readaround never bigger than
> VM_READAHEAD_PAGES) or dynamically adapting the window where it starts
> small and grows if/when readaround folios get used and shrinking when
> they don't? I don't think this would degrade sequential mmap access
> (eg async readahead would ramp the window back up to ra_pages in a few
> steps once the fault hits the PG_readahead marker) and I think it
> could be beneficial in general too, as less pages need to get read in
> speculatively that wouldn't be used, which would also lead to less
> reclaim.

So I think we definitely need to fix the detection whether the fault-around
pages are getting used or not because since we've added filemap_map_pages()
the mmap_miss accounting was broken. And once that signal is fixed, we can
come up with some logic to size the readaround sensibly.

> > Because what I'd expect to happen in cases under heavy memory pressure is
> > that ra->mmap_miss would quickly grow over the limit (100) and we'd just
> > stop doing mmap readahead for the files. If the read-around pages aren't
> > getting used before being evicted, then the first natural thing would be to
> > actually stop reading them in the first place :) The mmap_miss logic is
> > actually rather dumb so I wouldn't be surprised if it doesn't work in your
> > case...
> 
> Do you think it'd be better to have mmap_miss count pages read vs
> pages used instead of counting misses and hits seen at fault time? I
> think the problem we're running into here at Meta which mmap_miss is
> not detecting is that there's lots of wasted pages that never reach a
> fault. It also seems to overcount hits, eg a single fault can subtract
> mmap_miss by up to 16 if there are nearby cached pages (which might
> have been cached by buffered reads, not mmap), even if those cached
> pages never actually get touched. And the same cached page can be
> counted as a hit several times, once for each process that minor
> faults it in.

Yes, these are mostly the problems I was hinting at above :).

> Or maybe there's some simple way to get the info from
> reclaim instead? Where if reclaim is evicting a readahead page that
> was never accessed, that's counted as a miss? imo that seems a lot
> more accurate as a signal though that also seems a lot more invasive,
> like needing a new page flag.

Yes, something like that would be a good indication our readahead isn't
working as it should. But the problem he is how to track this information
with the folio... Maybe as an xarray tag? Liam was mentioning to me a few
days ago that with maple tree we have more xarray tags available ;).

> As I understand it, both these improvements (detangling mmap
> readaround size from ra_pages and improving mmap_miss heuristics)
> would be complementary to this series rather than a replacement for
> the per-folio reclaim fix. Does this match your view?

Yes, they are related but mostly independent from the issue you're
addressing in this series.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

