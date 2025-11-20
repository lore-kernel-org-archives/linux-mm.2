Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABF1CF8855
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F3A6B000A; Thu, 20 Nov 2025 07:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF676B002F; Thu, 20 Nov 2025 07:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE966B0030; Thu, 20 Nov 2025 07:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36CB46B000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:55:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10C9DBBAF3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:55:13 +0000 (UTC)
X-FDA: 84130980906.29.ED20F2B
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 045641C0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:55:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SKQnzKpU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763643311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GL5G0+c5xZz8aJnyzIUKwf30/NDXSihWrQzUxGxYjIs=;
	b=Z2zyhwx85orj3Abxj7rQhX2ZXlGoIPylUsLQzkXRGgrwn16i893oKq2IqWKNmLKMMKBtCt
	grxhEk8leklFZsIzcBOnfYZQ31LJZRvKwdFXjdsV1tNznWIDJ1w6+eqfvyubu5RY822H5V
	ANr+2eTrQqnXMeR13ZDGVNQqxRYRFpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763643311; a=rsa-sha256;
	cv=none;
	b=IeqPAZ3d7GSlR6gD0D4fiS7lFtjn4XrjNlb3T3xN4YjXozRuZQIlyJTDDnHazqk+3OvveJ
	ym1pYkg1Kpkg0fAQrh7xuxJdPv5LI8L1BxzX1B4cpWMCwD/0dYMwRlrj4prO9deUIXvFHw
	auAGQ8n/sXusiuJcNNoBYVE4PYP4OoM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SKQnzKpU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42b566859ecso760366f8f.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763643309; x=1764248109; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GL5G0+c5xZz8aJnyzIUKwf30/NDXSihWrQzUxGxYjIs=;
        b=SKQnzKpUmh/G9uzc9pkbjjLc8Oc3qSbnHmbnr8u/LcLC4yls7oBASdxQbPJ2A/VUHD
         GhiO6fAJaJYoGtXeNfJbdhtHX/ENYI8ja1Y9ksnhhWRHbOf6/K+8QPtdvMaYqtqzuQuU
         v8w4e+5linv0rQTb8pGnI+rxuuy7LX0Xn3+oTmQho4N4nid+DdghDLg8ZckvxkkjG8ng
         w9HvGa6sSxH2U2rJx1pxlIS/x7GH8qTLzvb40g1/bMaNGHEOwrXHu4hCmxsd3LjGOSdB
         QadwbZe8YMvOe3funi4Kym9Pw0Ii4o7Wr6weH00OqVT4FSdIJyqC1E35NEAi09W92AyG
         Bz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763643309; x=1764248109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GL5G0+c5xZz8aJnyzIUKwf30/NDXSihWrQzUxGxYjIs=;
        b=DT8hGUoKnvon4i8eA4h8FlXuUVUz7b5YdasUl9TkvbE7Ds9hN6ToYN8vMSXNtgpOBg
         Y1+W+aPyxgFyLs4ZEJ3w0AclDs5z3yf3u3l1rtdcwpb+Mtcwy1xLV7DcgxT1JG4Yd56s
         NxBbSM6HyEtag8gMo9PdbYMYwFdycYCuSK2HRweCuW4vl6vIWI2N9S6AFTcUFSMs+MHu
         w6qJbw7Zk/vy8DKyqS260ZdtkyWwiwjX36AVJEUwQcwO9Q8tgXwvBhqbriNP/zBVO6+H
         jb5EQD5x77LkvnBV4F1RtC42rXpR8cPgTfNfNpSL+4WBeuGHm0CerBFWaCS1mV3eCDwQ
         c/5w==
X-Forwarded-Encrypted: i=1; AJvYcCXW8l1IXA1qVjUjCTEIYMe9YHj2EFEnp4yHcrJGGjEPndXLYB5jIIbMpVOYvxW1JCMdLRL8V8NtNQ==@kvack.org
X-Gm-Message-State: AOJu0YxhB1lV0OFGlfMvCya1AXMKYm5ctO9WrSO6arGR+Yj/2fYhDipN
	l+9qKG/WeGihPT/5HoJN19tdrgk71TT71CYMUr/ts4aaSzopLl5DE2vn
X-Gm-Gg: ASbGncs/+3/4TBA4RcxeiBEsLdlcVScBp4HqdC5TnBdH+XqORzdCWvWFPYKtjdEz4yr
	qTt1AeHJtSaBd45vv5UslN/AF0J+BG8JQd3ZB9M06QwEkMgLz3T9CtUsBexYDa4Sg+ruubjFlNR
	ctFEthT+zDPQ1pROf9TyPB2szaHt58Xl0BfyH0NFRwFxydKqVlruvI/WX5iv9DWO+QMZemmFsmj
	FTAZuzc9Uu7s+GN/LfAevxe8h3fmWJbbJwojxtRpAdJOytWbWtsOGcoAxZt7bjIEq1/GASfaJS/
	nmBzpeOIUBc0IkVqQDLcsabUzej615BbokNKxjVQj1bHv9HQscXz08pTzqY6sPVGEcNFH2KT48Q
	ixlv4/wywhIf9rLV+e36UpHpIB53lFRCrV9uWoQkQt3//7TnDNuSovjfU3Zmdj7teKQxUSP/g97
	CBm8vIEp/gLVDJHixxR9Wo5YtrWFhiMtH/MX16nV5QAMZuMpdPFpUk
X-Google-Smtp-Source: AGHT+IFU7kfWfvCTzsg6mmHTeWF/Bfj6Cwbkq5zHUE7KNXvkB7ee4cOXGRDIAiPbZDCgY5IenhM3aw==
X-Received: by 2002:a5d:584d:0:b0:429:ba48:4d6 with SMTP id ffacd0b85a97d-42cb9a19612mr2600256f8f.10.1763643308985;
        Thu, 20 Nov 2025 04:55:08 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e432sm5241066f8f.9.2025.11.20.04.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 04:55:08 -0800 (PST)
Date: Thu, 20 Nov 2025 12:55:05 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Hildenbrand <david@redhat.com>, Dennis Zhou <dennis@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>, Tejun Heo
 <tj@kernel.org>, Yuanchu Xie <yuanchu@google.com>
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
Message-ID: <20251120125505.7ec8dfc6@pumpkin>
In-Reply-To: <0c264126-b7ff-4509-93a6-582d928769ea@lucifer.local>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-40-david.laight.linux@gmail.com>
	<0c264126-b7ff-4509-93a6-582d928769ea@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ay9wf67cbus51cxqtnqdmq3ddc9b3kt9
X-Rspam-User: 
X-Rspamd-Queue-Id: 045641C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763643310-630945
X-HE-Meta: U2FsdGVkX19V9YmiMazrBNQufonTi5GsouAYhbNLZbYQnA7jTMX8XulGVP26dg5ksf4k2Yba0rVfl7dGUhIkyRngKNXYWgwkwUJcpUgLA3yuFQUodBtVlvlMr0mozdtxWACWJwhEUSUF9jlXn9akcw1deIY/lj6boJURMMrc+TFTD5jvSt7naXqsJ4xcp+nrQ5+wg8c7HbFtQIaXvrDurbJkBsioGaSt6Qf1oQ2p2Am3ME05K1+atia7RbYOMC2BibM7IJ4Ys2A3N7e7QwEbgR0Ls5VwsimdHN171OP0TOKyxiP4yWnU4WyI2d+8706Ow6quuVE6N26dZLrSMck+DuBqaXqc7nMb+5ZUKlMtJR22rOVj5oSA0p8G5QwJiLf442XDcIgR2i2jnpNM06rAomRBuoXgcTAq7/ngDgqP+MeZLQwue0mwywJP7iRsYPI78NB3mdxHAVtPLENwYQpInRE5ZGvyV9qJV7g8XRlOP/3QnGlpIbYhRLzZUXgYKWCJp4GXP37hWnoC0cm6RC2WBBsJtwRctPP/l1rJhauGGHFjidRVjd2/IuOhnNO2v68oYe+VdAUqx8OFgRbFGgX5A3G7jJDQYXX8vQRscJmiCtJIs9hQFN4W6DWNZO95bimAduLrrtwYmVy8OZVsHtHAP2HJfywEKMTR1y0gLiXJmmVR/6UMwZfbE0G2KQAmzBE9v40xKcgWVSytsF869Q6MkH53G6jHNDfT71NdrfepTZs6T/b1ORLhOZ35JRIEG7hR4XsZqh8Ougd/5qnKkDri4w+KB9uQ5nvDuu04MZRKPthdK7Ccf/hXAM3NycZnsNVIGgTkahQ5ZVKgqxTk8RO1YdEC8rPf5HhHTD/QKcYFpmPARss/N9PBdRPvTrokpXd8F9bjqBjaPfK3VFNTvCVuhVnUd3W1RVfd1/pZjE9nHpDCUIhERu1LPael/WI51LWbNF7lVhMklhtmcfRZdmh
 FpA0MsCq
 WLiTQYrBnLOwFW0yi0E3KbgOxB2oZ/P0D5Ee80KnXnazFPvIv5XDYDaFVrYHL0Etbq6hlTapsLsmSc+S9elu10luiPcLlwY4sE1Z4T960R1NoH+26faCff17XDLb7H95lDtL4V580Tznbk5gPzP0Vw4SbaNmzvepXZ6V1G+REfJaUOAcuEWShDzw2X+q2KhnFarh1Ed3X1JHXr8fNfa6l8oenLn2Nhz+2ohgJ4LwfKBhXog8cifB92ZfqQFwcu+LFdgxNj1vu85WT+3zCPu6o9pv3R+mr8FVMP8lV9KUv5TS8+2FA2lOx4pZclDVM1n2nduUF/tQ4NNzqM5mIaCV9t8FW5ZnluKG3XFEvbR5fi1opzDi120v8O4F9D2pbDszGluJZ7pU565Jg84KI3g9VA/ctYjFmmqVWwosMZXj6kR6sXQzfyHM1ZCgyuhCEaIUODQ4bi8qi1LDErgWw1g+MxuAul2t2ur5IKpi6odTwp42rcvfp1pzoCwc7Xv+npq1pC0VtSiQaJB3KKO/Lb07RqlN9dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 10:36:16 +0000
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> I guess you decided to drop all reviewers for the series...?
> 
> I do wonder what the aversion to sending to more people is, email for review is
> flawed but I don't think it's problematic to ensure that people signed up to
> review everything for maintained files are cc'd...

Even sending all 44 patches to all the mailing lists was over 5000 emails.
Sending to all 124 maintainers and lists is some 50000 emails.
And that is just the maintainers, not the reviewers etc.
I don't have access to a mail server that will let me send more than
500 messages/day (the gmail limit is 100).
So each patch was send to the maintainers for the files it contained,
that reduced it to just under 400 emails.

> 
> On Wed, Nov 19, 2025 at 10:41:35PM +0000, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> >
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > and so cannot discard significant bits.  
> 
> you're changing min_t(int, ...) too? This commit message seems incomplete as a
> result.

Ok, I used the same commit message for most of the 44 patches.
The large majority are 'unsigned int' ones.

> 
> None of the changes you make here seem to have any bearing on reality, so I
> think the commit message should reflect that this is an entirely pedantic change
> for the sake of satisfying a check you feel will reveal actual bugs in the
> future or something?
> 
> Commit messages should include actual motivation rather than a theoretical one.
> 
> >
> > In this case the 'unsigned long' values are small enough that the result
> > is ok.
> >
> > (Similarly for clamp_t().)
> >
> > Detected by an extra check added to min_t().  
> 
> In general I really question the value of the check when basically every use
> here is pointless...?
> 
> I guess idea is in future it'll catch some real cases right?
> 
> Is this check implemented in this series at all? Because presumably with the
> cover letter saying you couldn't fix the CFS code etc. you aren't? So it's just
> laying the groundwork for this?

I could fix the CFS code, but not with a trivial patch.
I also wanted to put the 'fixes' in the first few patches, I didn't realise
how bad that code was until I looked again.
(I've also not fixed all the drivers I don't build.)

> 
> >
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >  mm/gup.c      | 4 ++--
> >  mm/memblock.c | 2 +-
> >  mm/memory.c   | 2 +-
> >  mm/percpu.c   | 2 +-
> >  mm/truncate.c | 3 +--
> >  mm/vmscan.c   | 2 +-
> >  6 files changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index a8ba5112e4d0..55435b90dcc3 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -237,8 +237,8 @@ static inline struct folio *gup_folio_range_next(struct page *start,
> >  	unsigned int nr = 1;
> >
> >  	if (folio_test_large(folio))
> > -		nr = min_t(unsigned int, npages - i,
> > -			   folio_nr_pages(folio) - folio_page_idx(folio, next));
> > +		nr = min(npages - i,
> > +			 folio_nr_pages(folio) - folio_page_idx(folio, next));  
> 
> There's no cases where any of these would discard significant bits. But we
> ultimately cast to unisnged int anyway (nr) so not sure this achieves anything.

The (implicit) cast to unsigned int is irrelevant - that happens after the min().
The issue is that 'npages' is 'unsigned long' so can (in theory) be larger than 4G.
Ok that would be a 16TB buffer, but someone must have decided that npages might
not fit in 32 bits otherwise they wouldn't have used 'unsigned long'.

> 
> But at the same time I guess no harm.
> 
> >
> >  	*ntails = nr;
> >  	return folio;
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index e23e16618e9b..19b491d39002 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2208,7 +2208,7 @@ static void __init __free_pages_memory(unsigned long start, unsigned long end)
> >  		 * the case.
> >  		 */
> >  		if (start)
> > -			order = min_t(int, MAX_PAGE_ORDER, __ffs(start));
> > +			order = min(MAX_PAGE_ORDER, __ffs(start));  
> 
> I guess this would already be defaulting to int anyway.

Actually that one is also fixed by patch 0001 - which changes the return
type of the x86-64 __ffs() to unsigned int.
Which will be why min_t() was used in the first place.
I probably did this edit first.

> 
> >  		else
> >  			order = MAX_PAGE_ORDER;
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 74b45e258323..72f7bd71d65f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2375,7 +2375,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
> >
> >  	while (pages_to_write_in_pmd) {
> >  		int pte_idx = 0;
> > -		const int batch_size = min_t(int, pages_to_write_in_pmd, 8);
> > +		const int batch_size = min(pages_to_write_in_pmd, 8);  
> 
> Feels like there's just a mistake in pages_to_write_in_pmd being unsigned long?

Changing that would be a different 'fix'.

> Again I guess correct because we're not going to even come close to ulong64
> issues with a count of pages to write.

That fact that the count of pages is small is why the existing code isn't wrong.
The patch can't make things worse.

> 
> >
> >  		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
> >  		if (!start_pte) {
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 81462ce5866e..cad59221d298 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -1228,7 +1228,7 @@ static int pcpu_alloc_area(struct pcpu_chunk *chunk, int alloc_bits,
> >  	/*
> >  	 * Search to find a fit.
> >  	 */
> > -	end = min_t(int, start + alloc_bits + PCPU_BITMAP_BLOCK_BITS,
> > +	end = umin(start + alloc_bits + PCPU_BITMAP_BLOCK_BITS,
> >  		    pcpu_chunk_map_bits(chunk));  
> 
> Is it really that useful to use umin() here? I mean in examples above all the
> values would be positive too. Seems strange to use umin() when everything involves an int?
> 
> >  	bit_off = pcpu_find_zero_area(chunk->alloc_map, end, start, alloc_bits,
> >  				      align_mask, &area_off, &area_bits);
> > diff --git a/mm/truncate.c b/mm/truncate.c
> > index 91eb92a5ce4f..7a56372d39a3 100644
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -849,8 +849,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
> >  		unsigned int offset, end;
> >
> >  		offset = from - folio_pos(folio);
> > -		end = min_t(unsigned int, to - folio_pos(folio),
> > -			    folio_size(folio));
> > +		end = umin(to - folio_pos(folio), folio_size(folio));  
> 
> Again confused about why we choose to use umin() here...
> 
> min(loff_t - loff_t, size_t)
> 
> so min(long long, unsigned long)

Which is a signedness error because both are 64bit.
min(s64, u32) also reports a signedness error even though u32 is promoted
to s64, allowing that would bloat min() somewhat (and it isn't common).

> 
> And I guess based on fact we don't expect delta between from and folio start to
> be larger than a max folio size.

The problem arises if 'to - folio_pos(folio)' doesn't fit in 32 bits
(and its low 32bit are small).
I think that might be possible if truncating a large file.
So this might be a real bug.

> 
> So probably fine.
> 
> >  		folio_zero_segment(folio, offset, end);
> >  	}
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index b2fc8b626d3d..82cd99a5d843 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3489,7 +3489,7 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
> >
> >  static bool suitable_to_scan(int total, int young)
> >  {
> > -	int n = clamp_t(int, cache_line_size() / sizeof(pte_t), 2, 8);
> > +	int n = clamp(cache_line_size() / sizeof(pte_t), 2, 8);  
> 
> int, size_t (but a size_t way < INT_MAX), int, int

Unfortunately even if cache_line_size() is u32, the division makes the result
size_t and gcc doesn't detect the value as being 'smaller that it used to be'.

	David

> 
> So seems fine.
> 
> >
> >  	/* suitable if the average number of young PTEs per cacheline is >=1 */
> >  	return young * n >= total;
> > --
> > 2.39.5
> >  
> 
> Generally the changes look to be correct but pointless.


