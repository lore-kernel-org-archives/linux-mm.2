Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7B6606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=CpjugCLs;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q5ma1ImV;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=CpjugCLs;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q5ma1ImV
Received: by kanga.kvack.org (Postfix)
	id CB3756B05C2; Wed, 28 Oct 2026 11:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B616B05C3; Wed, 28 Oct 2026 11:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79BC6B05C4; Wed, 28 Oct 2026 11:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F626B05C2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:06:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 305BFA5AE4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:06:34 +0000 (UTC)
X-FDA: 85372361508.13.249EDE6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DA5E4000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:06:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CpjugCLs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q5ma1ImV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CpjugCLs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q5ma1ImV;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwnluHM6ETxEARZScVwfOpepqeIhMTU8NTSVHG7kDLc=;
	b=J+KTs6MqZTYXKQdYTB41aTeypeXZfgI5thiJatwPjcEye89fV0ivnbUcqQTA/AMi2lR6i2
	5b0QUsAZ439HkuROhadIl165jmThoKbn0PIh50XayYhfH7yCiZ/WQGaRoUvyl9mfJ9Cl8G
	HDKqM70PRiJV2lbk2q26jDuLnEYkCLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199992;
	b=GCn/jqzepOVRH2VTcT1CIErTG1ho8vR/RygEfPVNNjytw/JexB4ZafEkUsSmVu9FUhzI46
	cHxg8xMYeKBlMGzBb9raXnN5NELPa0A7BmYXnKR7oEch4rd6b7pjFXFTeqPj5Vl1TNDoY1
	2JN89jFLQ5Eh0A4ZjOEQ/ZEzwFBaZWE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CpjugCLs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q5ma1ImV;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CpjugCLs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Q5ma1ImV;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 835601F7A9;
	Wed, 28 Oct 2026 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793199990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwnluHM6ETxEARZScVwfOpepqeIhMTU8NTSVHG7kDLc=;
	b=CpjugCLsTZ68lwVx6Htr7fnQJKI1Fmaxt1YGRhANsciGCxPegHOqfa8oTrBEauaJ6fxlhy
	5Syd9KVtxzdviPmQuAcE3uNDTxlofnV+g5PPua7B+h8RGmXvIKguH2NubEN2X7OEkJ91OK
	4t3gli11pNVMstzroT9F5x8cIOwd2JU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793199990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwnluHM6ETxEARZScVwfOpepqeIhMTU8NTSVHG7kDLc=;
	b=Q5ma1ImVEJZWkViJKSoGQDIWGkhhNK+7kWoFxmyLlSgO0Elgnaxg5H/PEI7wEv55K5QlQK
	qC8i99MKndUqqtAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793199990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwnluHM6ETxEARZScVwfOpepqeIhMTU8NTSVHG7kDLc=;
	b=CpjugCLsTZ68lwVx6Htr7fnQJKI1Fmaxt1YGRhANsciGCxPegHOqfa8oTrBEauaJ6fxlhy
	5Syd9KVtxzdviPmQuAcE3uNDTxlofnV+g5PPua7B+h8RGmXvIKguH2NubEN2X7OEkJ91OK
	4t3gli11pNVMstzroT9F5x8cIOwd2JU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793199990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwnluHM6ETxEARZScVwfOpepqeIhMTU8NTSVHG7kDLc=;
	b=Q5ma1ImVEJZWkViJKSoGQDIWGkhhNK+7kWoFxmyLlSgO0Elgnaxg5H/PEI7wEv55K5QlQK
	qC8i99MKndUqqtAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 356BC13419;
	Wed, 28 Oct 2026 15:06:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XW0wAXUP4moXIQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 15:06:29 +0000
Date: Wed, 28 Oct 2026 15:06:27 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <auIPRjj2t0BcYlOa@pedro-suse.tail5790ac.ts.net>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
 <atYJA7nIu_RwpoCC@gremlin>
 <auIIxSorX0bhZNZc@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auIIxSorX0bhZNZc@gremlin>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0DA5E4000A
X-Stat-Signature: 53s1o4163dqr175cfyoaed6g1f1pdqge
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793199991-266827
X-HE-Meta: U2FsdGVkX1+lsJ4gwRR1AvovGTMQyDYeG+gMSe394JoF8SR6i4MaCIMFebtCSdkpXYUmePde6D8UrKqbGyLd3KCav8b0E7yKXBIKxuBv4aDs32ZeOwHz0hYo+Z36NukphhOcbep4scJR/jJ0UUXaQe7agm9DG7nWBrr4tWJYMFoV9g3+TjSAnRhu3MYXYl09VXFL533gNqOvdop+fnWzipJWmBICWGJuj3Lp6/0HB10WevwppVSb3tdYcnSFJFzzMW0ZuTrNU8/qChFQ33ciW8L+V3kGHmHA38eyfgeqlLIEXcKfV5O7jxH21zl+CcV75C7MvMTNiAv8xchpFmbcgf9VavfnRwhjhaKIVgVKrkIiYU1PSi7fnTryBZhJAai3pRh+YydcB1qgIxJ1Q0oDF+y4eeSyI9EvYMkLrF3EkFBUFC+U8F9rKBW+UFcUw6z6PjteM3lJAviJs0SSb+LEHPXt7ngKGaHfXdA/OE+4vY7s1kFU4n7nu2r2lYeWcNlytN8Kjm8BQcEeoJsXnIJ+vZlDp/tY3nMKVbHyAGPA1DVxP5+UxU+Z41890E6WjkD3FFa+UJ5mhApUu57ZRT08RcIurCeBU8wMrQuLliZI9DDGp3D0YM5ir6xy7pivBKZ8Mc3dfSYsp1NyRNT4HH+8ytcLB94JyEOru1oAVIyYM82peiIrOth6oxndTTAnUPww7ODIUagEUn0mDX/ozTqSHFLsRULqNHZY/EIUaT3ixoKClGan89EOA9tFTj5d8IZUHAG7fGFCUso+DOaa9m9wTJpINFOpqW568zsHJHQqQvx+IkHjnKE67CS9+ndlIaROR912Q29rr1hwPBiEWgei0+7nWHxKiUrjw/xhuxyV+pP5cCmUb+OQKmoPSnuFNXRI7eFwMlxnb5/UGiW/o5iW6WvUOgEQFeXrp3R2VXESQWEYeq9tL2DMyVO3M+0y7FqFcmyMv/fHxUKIvgvEY02
 Z/VIjd7d
 07AqUf7OQv0riHfpsNOdVBtsB48OIf574Vfk6a87NRjkRGPfz8c2rJ4L91j7e7aYhTAmDTJMVzBQAIh8del8i4oeF+AHafvvIttTJEHb5PaLzwQ/h8Z08dlTCXUZWgDB9f0qUIme1kGRum+tz8Zv7Urx5pIzkZ8t88NLYXGjLnvMeVfREyLmCa3DYVEYhzEQI8EWnMhFda7+nlAoz2Z+zEVCzyW6BPg4XMXrIIxvfGjY5/wJa4p1SVrwWaEcltE/KUo5ZIvcA5a6JsyE2VA6ftFhULgPyZmETZVQVU2V9WszWINu66Z/nE2K0yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 03:04:07PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 19, 2026 at 01:19:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> > > On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > I'm concerned by the possible latency when doing this to many VMAs. Do you
> > > have any numbers?
> >
> > No, somebody schloppened a patch for a real issue and I haven't the time to do
> > even the things I need to do let alone 'here's a new task' stuff :)
> >
> > However, this is a simple write to every VMA, done at the point the mmap write
> > lock is held with all VMA write locks dropped.
> >
> > It was implemented such that:
> >
> > * No VMA write lock is taken on the VMAs.
> > * VMA read locks can proceed.
> >
> > I.e. it amounts to a loop over VMAs and a write to a field.
> >
> > I don't think you could possibly do more to reduce latency here, and you
> > absolutely have to update this field across the board.
> >
> > Under any realistic workloads this will occur at worst ~days intervals, often
> > far longer, and likely you will see quite some gaps between separate processes
> > experiencing it.
> >
> > There's also an upper bound of vm.max_map_count per-process, so it can't explode
> > into something truly insane.
> >
> > Most processes don't have that many VMAs, other than certain steam games :) so
> > it's hard to imagine there really would be that much latency here.
> >
> > And the latency is occurring on one thread, which is performing an mmap unlock,
> > so nobody sane will put that on a hot path.
> 
> Sorry, I forgot about this and didn't get numbers to back this.
> 
> I had an LLM go get numbers on this, all in ms on my threadripper (but numbers
> should scale similarly) with fork() + munmap() all VMAs for comparison:
> 
> (all ms)
> 
>       VMAs      reset    reset     fork()     munmap()
>                 (warm)   (cold)    (cold)     all VMAs
>   --------    -------  -------    -------    ---------
>      1,000      0.006    0.041       0.33         0.43
>     10,000      0.072    0.36        2.1          4.2
>     65,500      0.61     2.4        14.1         33.5	(default)
>    262,144      5.3      9.6        60          168
>  1,048,000     34.7     39.2       237          691
>  4,194,304    162      163         954         2810
> 
> It happens on a random VMA write lock release, so there could be tail
> latency, but it'd be tail latency on the scale of ~weeks for normal
> workloads, and (assuming max map count reached at default limit) a ~2ms
> latency for an operation such as mprotect(), madvise(), mmap() or munmap()
> which shouldn't be placed in any situation where the latency of that call
> matters.
> 
> One call in 2^31 is the
> 99.99999995th percentile, far beyond any latency target anyone measures.
> 
> The amortised time per write-lock cycle is ~18 picoseconds (0.018 ns).

Thanks, this addresses my concerns :)

> 
> Interestingly, the runner observed khugepaged-induced mmap lock stalls of
> ~100ms, far far more regularly, which seriously exceeds any of these
> numbers, about which I assume we haven't had too much complaint.

Wow, that's horrible.

-- 
Pedro

