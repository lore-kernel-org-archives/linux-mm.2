Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C38A606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=x+mYUlra;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=x+mYUlra
Received: by kanga.kvack.org (Postfix)
	id 3BF0F6B05B1; Tue, 10 Nov 2026 13:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3973F6B05B2; Tue, 10 Nov 2026 13:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 289C16B05B3; Tue, 10 Nov 2026 13:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E270C6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:53:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D62E1A0AA2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:53:18 +0000 (UTC)
X-FDA: 85420107276.20.83C991D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AD07C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:53:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x+mYUlra;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x+mYUlra;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336796;
	b=dQfBD23DYP5ni6UDf+/DP66e2cUFmYzUxSRMFMW+6RLIFBb/va1e5qrnAEatoOjjb4oDCI
	0Nu/HxiEAPS5BGQTmcWxog+fgGx2bS9wyg3E7rVFT0IjJaquywuiFqOrzMuQWfE8ipSxvD
	gVoRSRIOnFQ4FTD5KMIoH+TxqStS7Sw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x+mYUlra;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D0P1ZIWF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x+mYUlra;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHCR47XUeKkniWauoQ6Bc3PeinbKUbIuVZ8cHVkQ2nk=;
	b=B48yu5j2wcFlL08S50dv2r2RCUWbcThdzUvhyB8bS12Zh2dnHMJ0s1rKS96EjaHrKCcXOm
	TVR6JipXIAHUTfqPxy2cnCR47jYDoLqqIZna8hJBQ4BPveDrp+P2IfnuQfgkXCOQj42Vyz
	HhjomC94rK+/L82makgpddDTD5XZWMA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 80E9521F2C;
	Tue, 10 Nov 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794336794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHCR47XUeKkniWauoQ6Bc3PeinbKUbIuVZ8cHVkQ2nk=;
	b=D0P1ZIWF11oNFc0TcZo234MMj3sDf3E1HQFE7rNgMu1oXrncOVWDchtM6tqBFewZCd+gad
	e6N6iSPqNDmhbU6D48LJa5J6yK5sfyR29ZqlPu0Hxa20TQxSXy+CyJzodeJO8j5XdI49yK
	0hm9o+DclwpV4ZMfz7PUm9C5Mfcp6CA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794336794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHCR47XUeKkniWauoQ6Bc3PeinbKUbIuVZ8cHVkQ2nk=;
	b=x+mYUlrayFpyce2W0hv6L0fyLhRi74sN5fUzCMY8eFMCBoVWvLx6SqlXqDNkZ78S+C/PX8
	nzRDFRtFvaCcdTCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794336794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHCR47XUeKkniWauoQ6Bc3PeinbKUbIuVZ8cHVkQ2nk=;
	b=D0P1ZIWF11oNFc0TcZo234MMj3sDf3E1HQFE7rNgMu1oXrncOVWDchtM6tqBFewZCd+gad
	e6N6iSPqNDmhbU6D48LJa5J6yK5sfyR29ZqlPu0Hxa20TQxSXy+CyJzodeJO8j5XdI49yK
	0hm9o+DclwpV4ZMfz7PUm9C5Mfcp6CA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794336794;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NHCR47XUeKkniWauoQ6Bc3PeinbKUbIuVZ8cHVkQ2nk=;
	b=x+mYUlrayFpyce2W0hv6L0fyLhRi74sN5fUzCMY8eFMCBoVWvLx6SqlXqDNkZ78S+C/PX8
	nzRDFRtFvaCcdTCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 40D7B1339F;
	Tue, 10 Nov 2026 18:53:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vd8nAxlo82riMwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 10 Nov 2026 18:53:13 +0000
Date: Tue, 10 Nov 2026 18:53:11 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Subject: Re: THP placement BoF at LPC 2026
Message-ID: <avNdx6WgYEYIgwba@pedro-suse.tail5790ac.ts.net>
References: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
 <CAAa6QmRt+4w9U_R8B5s+uOmS3DsFhc5JfucGcgz7D96pNDrwGA@mail.gmail.com>
 <asjDTxAfUSGm0obS@pedro-suse.tail5790ac.ts.net>
 <CAAa6QmSZ1eS3R4+SrKG86mtiJ5zoP7gCH+habP=qHyg-FDP8oQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAa6QmSZ1eS3R4+SrKG86mtiJ5zoP7gCH+habP=qHyg-FDP8oQ@mail.gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Stat-Signature: wabk3d6j3xxyppdwhydbuu7bwcgk38j1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AD07C0005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794336795-441223
X-HE-Meta: U2FsdGVkX1/yVSg5hVTb42gZgd//YKgFBhK8Ty1mlhh1jMvYI+IL2OpArwRjtGgYGSOSiEYogh3+C4fTqTDrmi+3LH9cclVQoj5HqVnMcBryZjvr39gHQF9OEsUAG583V29tqxnsJMRujssc1z6rdxDf2TP9Tvmg7+XTmwcGmaHsH60SluhDeIl74glBkzcHF0ec1qIfxyfBM+hXuM9ZcpqCzHzTDTCPyNkWrdDE2nqdBasX31gHpH2r56/2pq2JqaR/NfapCtziw5RoCcUXlgjlonLo0NlYefeWqEhFIKL/w7yr1HaDwhPhRrPLL6kCraFCj3pIRAkGtwdOmFQrAxJIRWAyjOTRRrJQIkY0VgCdBXEk5iN0xZVSzxmQWQ74J26kLC/WSS1ov23CRqn3YRBqQCZNI8tGcjeva6UhIg4QBmeViT9RZ6eOKzjbwemZDrfKdPr50LnASUiGKD0gBdHWm73X97493tIvrkSIqesrmuDbXuVwvL/+N8diZCznTthb66VaHyycMbdiJ17IYKEZ2BmWr/M1D0IvFec7L4c4zZE5JLrFwgic0CxHFWV+WIJLxBWMxOkJBL1ksi4iWM32qs9a31dBO7MdDyjq0ZA/VBgNrQEUyv2XOClnxTyKzyTOdbaYiSVom6phICiPNtL27nqSzwVhqluERbQWJUH0DqZGGibdTVSCgQyuPBKebjIwxZKZ6H8VMMRJXROTSJtwS80ur2mCnT9CZnul38KmNgMo97YpRgdQAkDKa1+V9/j5fDN7Muoqz/UO/+uNb7j5kTgL2vqjRUPmqZx3XMmES1uEEv9R90FiceC7yIxjj48UcUz5Enu9FUI6c1ZJ40CqVnblPB3ES5eXspkfPUVI3Vx2N1nUjlhgt1CwRGWrn7gCxEAn5dkh73eJes08Tc33YM+2z+GA6Ex7aYXS1eiZXFtvmA0kFTVpeA2+xrIgBDBDWn7A/U01E/9JdZB
 8BDvgSbz
 n9Ypm/lCwhyhhg6Qh1RwbZRPCIpFdemvDhdjEGyO0F+B1v54urYsBYQEc7aVILyDnUROLGlYhSKbEOQ2Zdh9NELuUkxibJXYTgVd76vuoNv6gPSdjeKStDE6teD6o2Tx1y3/VVix57L0Y5Y1gz7HkLtYVN5fazjHzobQjBN7ShrthOOqYAh0cjsuY4wmL118pniHRW8tfDnqw5fkZOqLzxcPX5KF4BS+SSyTkH4n6MSTGJBJAfmCHPK5rdrOEluuofxNDs495I2j5IYcE/mAWI/NXYy9qpiOQfLmG6al1GfdJ1jXtDo5TbVb71tyw/Libwx2EyWQrOOPYLygGK8d1oHz8IuHTVhtIWnaNNF0S9xIeOWxak8CpsmcwaOJuGOnMPGpIvlc8+M0ylszCIL2Jfts38A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I'm, uh, super late, but lets breathe some air into this discussion. Lets
hope the CVE armageddon doesn't derail this further :)

On Fri, Oct 09, 2026 at 10:42:24AM -0700, Zach O'Keefe wrote:
> On Fri, Oct 9, 2026 at 3:46 AM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > On Tue, Oct 06, 2026 at 08:23:44AM -0700, Zach O'Keefe wrote:
> > > On Fri, Sep 25, 2026 at 6:57 AM Pedro Falcato <pfalcato@suse.de> wrote:
> > > >
> > > > Hi folks,
> > > >
> > > > we will be holding a BoF about all things THP (but more focused on fixing
> > > > placement/not-automagic-THP issues) at Plumbers 2026.
> > > >
> > > > Session link: https://lpc.events/event/20/contributions/2452/
> > > >
> > > > The point of the session is to build upon the latest THP discussion at LSFMM,
> > > > and build upon the latest problems that have been raised over the last few
> > > > month, to get somewhere meaningful.
> > > >
> > > > I added a bunch of probably relevant people - it would be great to see you
> > > > there! and anyone else that may want to join of course :)
> > >
> > > Thanks Pedro.
> > >
> > > It seems there were some AV issues, so remote attendees couldn't see
> > > or hear the talk.
> > >
> > > Perhaps someone who attended in-person would be so kind as to
> > > summarize the discussion here, so we can continue the conversation?
> >
> > Hi Zach, Zi!
> >
> > Just got home yesterday, here are my (editorial) notes:
> 
> Thanks Pedro, appreciate it! Was disappointed to miss the discussion.
> 
> > 1) mapping 2MB THPs in ptes initially
> >  - tough ask for lots of folks
> >  - problems:
> >   - might take too long to get a THP
> >   - problematic for short workloads
> >    - my counterpoint: i've done some testing with kernel builds (lots of short-running processes)
> > and THP is mostly noise in measurements.
> >   - non-obvious how to store the 2MB folio
> >     - maybe hang it off the ptdesc?
> >     - can also just PTE-map the whole thing and do deferred collapse on that
> >      - but that's basically khugepaged's whole shtick
> >  - could be possible to carefully map THPs until you have some confidence
> >    the task is using them effectively (some sort of THP slow start)
> 
> Right. PTE mapping seems like a baseline necessity if we want to do
> intra-THP coldness detection -- something that we increasingly want to
> do given the current cost of memory, and to ensure THPs play nicely
> with reclaim and demotion.
> 
> However, as you've pointed out, initially mapping by PTEs may
> overly-penalize short-lived workloads.
> 
> One thought (credit: Yu Zhao), is to add a mechanism to temporarily
> shatter a THP's PMD at runtime so we can do the per-PTE A-bit
> harvesting. We're mostly thinking about this for anon THPs only, where
> the deposited page table already exists (this does, however, conflict
> w/ Usama's "mm: thp: lazy PTE page table allocation at PMD split
> time"). We can then bound the number of THPs under evaluation,
> providing a bound on how long any given THP might be shattered, before
> (possibly) re-collapsing the PMD in-place.

How would you pick the THPs under evaluation? Since the issue is that you
can't really derive hotness. Do you go about it statistically?

> 
> > 2) there's only one accessed bit, one dirty bit in the folio
> >  - this leads to hard reclaim, and write amplification for anon memory
> >  - could perhaps use more memory on large folios for this stuff
> >    - 64-bit field could be enough?
> > 3) can we use hardware metrics for it?
> >  - maybe, but sometimes they have overhead.
> >  - unfortunate that hardware vendors do not supply us with more A bits
> >   - could the 128-bit arm64 ptes work for this?
> >  - AMD IBS could work but does it have a performance penalty?
> >   - Intel PEBS definitely does.
> > 4) splitting off a VMA for MADV_HUGEPAGE VM_HUGEPAGE is silly
> >  - could perhaps have a parallel maple tree with these hints
> >  - my thoughts: wondering if it can be made extensible for other
> > hints/metadata. or if the performance penalty of needing an extra maple
> > tree lookup is measurable.
> > 5) THP shrinker is a bit silly
> >  - in no way does "scanning for zeroes" actually indicate if the data is cold
> >    or not, if you ever wrote to that page
> >  - Per Usama & Kiryl, Meta used to have quite a lot of issues with this until
> > they fixed the userspace malloc
> >    - i think that's a tough ask with a lot of setup
> >  - some mallocs actually write malloc headers all over the memory chunks, so
> >    the zero page shrinker fails then and there
> >   - and on free() you'd need to zero memory, or at least issue a madvise()
> >     to the kernel
> 
> Likewise, integrating with the userspace allocator has been our
> biggest challenge, but that isn't necessarily specific to zero
> subpages; for us, it's pointed to a stronger need to improve kernel
> <-> userspace communication to avoid one side messing up the
> heuristics of the other.

What do you have in mind?

> 
> Note that we shouldn't conflate the zero-subpage case with
> cold-subpage case. Though there might be considerable overlap, they
> provide different, potentially valuable signals.
> 
> > 6) MADV_HUGEPAGE has no size hint
> >  - what do users expect? unclear, they ask for "huge"
> >  - problem exists for ARM64 16k and 64k page sizes
> >  - I floated around the idea of defaulting to 2/4MB-ish sizes instead of
> > giving out PMD-sized chunks
> >   - ARM64 can do 2MB huge pages with mTHP on 16k and 64k page
> >     size configurations
> >   - or have userspace give hints through madvise?
> >    - I don't like it, neither did anyone else
> >  - overall I didn't understand if there was a positive reaction to this or not
> > 7) BPF was floated around as some sort of funny-piñata
> >  - it could certainly make things more flexible, but definitely less transparent
> 
> I think we've long-since done-away with "transparent" -- at least in
> the datacenter space. We can always degeneratively fall back to
> "transparent" to speed up run-of-the-mill / unsuspecting users, but
> for even slightly optimized workloads, THP management matters
> significantly. Note: Non-transpent != gauranteed.
> 
> THPs provide large swings in both performance, and memory cost.
> Increasingly, we are under pressure to use them more intelligently,
> across many domains: prioritizing the hottest memory (or at least
> avoiding cold memory), prioritizing regions that can't be zeropage
> mapped, differential priority based on userpsace-directed priority (at
> container, job, vma levels), etc. There's a rich set of policies we
> want to apply / experiment with, but we lack the substrate to build
> upon. There's only so many things we can bolt-onto MADV_HUGEPAGE.

Agree.

> 
> I don't know if BPF is the right way to go or not. One attractive
> aspect, is the ease with which we can integrate into userspace, for
> things like deep system allocator coordination, or for daemons that
> enact system-wide THP management. If we're ever able to establish a
> set of policy hooks, personally, I rather see something like LSM hooks
> -- we can always put a BPF behind that. However, we might require
> something more bespoke than a simple set of hooks -- I don't know.
> 
> I think what is clear, is we need _something_ extensible. In addition
> to providing a binary "yes" / "no", based on various inputs, one
> central idea (I think) is prioritization: who gets the THP if we can't
> allocate more? What container? What task? What specific 2MiB region?
> We need a mechanism to allow us to move away from first-come
> first-served.

I agree. However, I don't share the idea that this can be some sort of
configuration that can be static (or not). Data hotness comes and goes.
There's a lovely paper that's pretty new, OBASE (https://arxiv.org/abs/2603.00378).
They found that data hotness really isn't something you can predict
over time; they address it by moving objects between heaps; yes it's very
invasive and somewhat experimental, I don't advocate for that as a solution
for anyone. (another interesting observation is that page utilization is pretty
abismal within real production workloads; it becomes quite a bit worse with huge
pages).

So you could try and say "favor THPs for this process, or for that cgroup",
but I'm not entirely sure that would give you better performance & memory
efficiency.

-- 
Pedro

