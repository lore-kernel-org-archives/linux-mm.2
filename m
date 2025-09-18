Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60B0CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8CE8E00D1; Thu, 18 Sep 2025 04:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4908E8E0093; Thu, 18 Sep 2025 04:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD3E8E00D1; Thu, 18 Sep 2025 04:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6DC8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:37:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D19DABB873
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:37:27 +0000 (UTC)
X-FDA: 83901716934.19.9EA616C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E02C4000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:37:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lmjJusBy;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xsj3kmJPjclPXZOu7JzZ5IC9avscfOhR6+L7qvtvp9c=;
	b=xGlBOpoKQv8pC6vPGDaC0e4DJZiqZRltnoXaxItP/DvP06lc0DQr0hgPnQMAVkPGdW0RTp
	jXShZhw+Nfka9KWnoMvHaY3a5AbHlIUnRK0tZN81pf9lT+T1t9yECtaFWK1hd/WjYuG0Zw
	sJtFzYbLqE7Sn/hCHSmYYvCmipbAdL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184646; a=rsa-sha256;
	cv=none;
	b=3STFEjaSfYE6gU3L94ofBd0pTN/stt3vL1sg1Qf+JwXDsPFVhglS9NeGK2IZKTPPAi29r+
	M9oTMBH6Z2QBKu0lt4L7EkrRtADu4LrD8VEBt6PcYEP2SDnCn8UQUn1a1AC/ejIl4rWYob
	l8tjraHoAVVqJh2uPYqobAuDuUsOE9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lmjJusBy;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A7543A69;
	Thu, 18 Sep 2025 08:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E7C4CEE7;
	Thu, 18 Sep 2025 08:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758184644;
	bh=n6pcgK6RYDmP6b6B7FywOHg4pFSmSErWazePBn/crPs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=lmjJusBy6wTjGtDEz47xc5fyU1rL0tf2mSlWWmQ6Jo7TLlPyXizHw94sK2fAqmsX0
	 RSyFsHeUH1Tb1BdOFygVT8yI1hKcOkOvtfMMPFPXLF/dRtFAI9ewQpjPicQjB1NBvw
	 /MHhTvdmvf6uxBZ0wBuT2OAkDkNaK/9ajoqJDVShQR4XCRqhmyKfUq4y7jOlK3+rlf
	 tA+HP2zzpcgg88ES2Ngn89s1SFkxrIO9K9vn8udk/ipblhDOtcu1aOPEj0fCgtrQPm
	 6TT2NVYBI0mGjZgaETBGQxLI7m0nBqpHnAMhLBX08I539MqR3A9adWhlt9Xax7QIgQ
	 t1Ayp5bCzKhvA==
Date: Thu, 18 Sep 2025 11:37:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMvEu9m7fJLnj862@kernel.org>
References: <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
X-Rspamd-Queue-Id: 1E02C4000E
X-Stat-Signature: xd1shstdf7uws3gpuwhcag7wowz3514h
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758184645-358568
X-HE-Meta: U2FsdGVkX1+B/TvoZDhB1YQ6sorZU7yn1rPA1Nv4kAiAGzoep3FpgyegPSSpgm3qWsd/D6J6OqCFvtbonciL2f/Pps7qxGKzOJ5aloxb7vBJmQRJ8G+F/lY5hJI1Im74aTPUmQ3Yf/zJzATVJBj4xLI9jGudeq6R3PvrfL62jdujYFrmyBndgVFXEzS3Uyeto2Boj8X19qZqtj7Xmp+Bi6eLEIuphefQxRT2lsZfghZNZTP5rR212Vi0kFA6fDL0YcdHLCG22z1R/b374gEPdXJ6grXuogIDtiFFmGFu9g18i9gYe0dAzpAZGIvdyHM78BRX7MCYZ9ruCi8psg1I8a4gfMBvdUPSo/PBGYqBEOwF2I0wlr5UOosVBaVjvdbJlM0vczsfEoC0RfTsN1sVpKLPIidDawcCKvSjL1JF2+FFefbXS9RomyaqzCHmZH3C/aQcCQIu2gej98NvMiDOUkT5zlhHRcuV0Jh5Fk193qZDibp00INXxohiLgHPnTPD6DlMHS4GgopcLa7fh1N0/1I7eVY9nrp1NhnebzAJwJSnk0e/qyZN9stUy9sjfYqN4w0WctacXQDlR4f/uecwvycJS6Wv4FqvkhaYR+aj5lRe9hKmlchOuroPh2GAgLYg61sGqA2g8XN3IuFSZMOPJ+ynPqIa9wgryyXpCkFa5AHWqk0tQ/eivNqetUJ1U5JWpNyIo60QyXQGzuDcUZDR1ixSK/Nvh9mH9ZlQW+8txoVhSJ6lS7K4YsCc34F+3MSVg7BGnx5glFhQSkKKspDC123FyagoYpx344VpdADInxNbgcGISlsU5EnadFGaRokDKLtgMCUlrczRXPdTle/th+ne3TcO2sywwYha6RFc2aOKwGFwOLYuLBbQEzVIbWiwhXhNd22oeLePgIeRfur3TqS7Mh0jsdHfx6C4zmhzCA/FZJLMdywvDXvDCmfK7u3ck5M11HbAF3hFZv0QyHj
 L11QodCi
 BA0aly4aN1u3eaWRk2yL+rn0XdDzFDlkHSRzXxOMTHjtD9Xg84eI3kEsU1OhExVuQk9avDIgIuGYhxlDbmnPUfWxydZNFnqjRffpCCSeqRCESSGSNaYgmRvao0l42U5xJ2RKPC2huoCjZieR4hsw5KaYzTgDKD5Lf7o1IB2XOjcdEYfLQWF0uNqWTUKyJgPLM69oc6Q1jTzeqJGF6Ga8Em2vBKCc2Y+7AKNPJijME7f3IT00GOiLnKNe3WBr/dHl3ERG6XTFOY7JV3Anx8TU5CeZJ09vlqeTEqH9pCVUd8+LtTXa+YU25/4JygR1szyt0SrF9Gas3KeT35LzLxDgabT5TX/7Da0NDTqBXK0KBf1WwU93ZXodSKbmvO40rBeg9TnkrUyvN5VxTmoE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:53:05PM -0400, Liam R. Howlett wrote:
> * Mike Rapoport <rppt@kernel.org> [250917 05:26]:
> > Hi Liam,
> > 
> > On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> > > 
> > > Reading through the patches, I'm not entirely sure what you are
> > > proposing.
> > > 
> > > What I was hoping to see by a generalization of the memory types is a
> > > much simpler shared code base until the code hit memory type specific
> > > areas where a function pointer could be used to keep things from getting
> > > complicated (or, I guess a switch statement..).
> > > 
> > > What we don't want is non-mm code specifying values for the function
> > > pointer and doing what they want, or a function pointer that returns a
> > > core mm resource (in the old example this was a vma, here it is a
> > > folio).
> > > 
> > > From this patch set:
> > > +        * Return: zero if succeeded, negative for errors.
> > > +        */
> > > +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> > > +                             struct folio **folio);
> > > 
> > > This is one of the contention points in the current scenario as the
> > > folio would be returned.
> > 
> > I don't see a problem with it. It's not any different from
> > vma_ops->fault(): a callback for a filesystem to get a folio that will be
> > mapped afterwards by the mm code.
> > 
> 
> I disagree, the filesystem vma_ops->fault() is not a config option like
> this one.  So we are on a path to enable uffd by default, and it really
> needs work beyond this series.  Setting up a list head and passing in
> through every call stack is far from idea.

I don't follow you here. How addition of uffd callbacks guarded by a config
option to vma_ops leads to enabling uffd by by default?
 
> I also think the filesystem model is not one we want to duplicate in mm
> for memory types - think of the test issues we have now and then have a
> look at the xfstests support of filesystems [1].
> 
> So we are on a path of less test coverage, and more code that is
> actually about mm that is outside of mm.  So, is there another way?

There are quite a few vma_ops outside fs/ not covered by xfstest, so the
test coverage argument is moot at best.
And anything in the kernel can grab a folio and do whatever it pleases.

Nevertheless, let's step back for a second and instead focus on the problem
these patches are trying to solve, which is to allow guest_memfd implement
UFFD_CONTINUE (or minor fault in other terminology). 

This means uffd should be able to map a folio that's already in
guest_memfd page cache to the faulted address. Obviously, the page table
update happens in uffd. But it still has to find what to map and we need
some way to let guest_memfd tell that to uffd.

So we need a hook somewhere that will return a folio matching pgoff in
vma->file->inode.

Do you see a way to implement it otherwise?

-- 
Sincerely yours,
Mike.

