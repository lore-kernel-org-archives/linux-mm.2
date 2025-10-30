Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0083CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E4D8E0135; Thu, 30 Oct 2025 13:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4264A8E0089; Thu, 30 Oct 2025 13:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BA28E0135; Thu, 30 Oct 2025 13:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 246088E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:08:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE8C41401EF
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:08:45 +0000 (UTC)
X-FDA: 84055415010.24.94827A8
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id BCAB11C000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:08:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f zqA7Rr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RYxcjzd8;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761844123; a=rsa-sha256;
	cv=none;
	b=Ubg0X9P5Bszs3AKPPz6zPQKYYmED7MhzJ0rUnjDUX9wCKTqwnCyJ0OlXTzSz+wPl3S72VJ
	I17mobVik/Is8jztwMd3PNqSxVpBncGqMCbNR8tQ6bJb8LO/py33o7BxeroTzIPtAFMBMc
	st4PtyVXlNAGaiFrBaxNPnJjyeCi5EQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="f zqA7Rr";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=RYxcjzd8;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761844123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBGM2Vv9TJf/GNvQJ15/TyEfo7R1Zl+KDezv+7vNYys=;
	b=vcSHVi19ttSi336lzvKVaukPZRG/H7/4XvEBKW6FFI+vFxf7mZMx+Eu9TuHyWsxEpXBMyc
	NEEnf1gi+wNVKqKTIZnJVGxM+QUFaghtjwtO1rcWtgsoKbsXowC7ztP0PF5O2QunShFeST
	b/3OSqitJpDqeWmnHub6AxvPRqnLZkk=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id C22D31300170;
	Thu, 30 Oct 2025 13:08:41 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 30 Oct 2025 13:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761844121; x=
	1761851321; bh=EBGM2Vv9TJf/GNvQJ15/TyEfo7R1Zl+KDezv+7vNYys=; b=f
	zqA7RrY3r3DxOB0UNbAuDkRa1wodtQgwolh8fHCXQ+t54/t1hKutu0n3sMDIcucF
	z0HLPogI+7J0enxTAr3MLNhe9w7owC3kZGCGG6Kyg92bAbeWyq0d5qtoiOgChqwv
	csHeI7h9y97DFwez4ZOL+WvwQsoXjJF5+rJAvPo+/LmB1KaiN134qPCPAvBPznld
	NQjdJD444p5YbQGwPhErbymXOb/g9fQEE1BbYhHOxHIFIatS944z0EggI+H1fIyd
	uxTrfMPE2TiGP/s4valktuA7s68T1mRWrUiptSWISCE0P084l5K4D5ITg7Ua83s4
	NCjigWefFS0AAcm9dQe0Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1761844121; x=1761851321; bh=EBGM2Vv9TJf/GNvQJ15/TyEfo7R1Zl+KDez
	v+7vNYys=; b=RYxcjzd8vMhaz5r6rq4XYY/0IBUZEddlwqWJ/DCJplirfZ7Muw1
	xhIapnHgUvDDBbvMsL5R2mzFj5tqEFTNGayzqn1ISyMnZyHfBGUWrLlSRZsX1DFY
	3FUbU0UBNxDrFanzboOIE4Qgy9clWEgBuo4GhP14TwRdXKYKqSItrl8Xt274L/B/
	T8T+QAfABBXgdxPOODNtJ8afJVBhUMFq1JQoQxA71l6UWQCMR5uwsUU9qdqe0zLI
	UJtHOUFdXMwTmMS8PVWwryO3in34izPaD2QGtZmdIp5wsy64onajTYHbQy2yaIR2
	uGNJ/h+YbdAhq/fsPOS/fmadvRCrKQdaAQg==
X-ME-Sender: <xms:l5sDaRfEbRVAUn6j8sDCiRP3iYPu5-wH3nE5_tsw2fLzj9ynM6lEJQ>
    <xme:l5sDaW4-vmcw62Pyf5ciBu2Pjqt_GU8AurbVOyVyFxWORPaPBZqcy0LRjHyC1wk6S
    IhfiZ5CSU2fnKFKKATxcymH7Skrc776_9cjRYRiypCDgdm41vlVX_h5>
X-ME-Received: <xmr:l5sDact4LWwQ_sm4Xuu2ry_oAjKJRVqPr9Dx5WRqdCWiBdyz1TWy37wBoKCn5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduieejudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeg
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhhughhhugesghhoohhglhgvrd
    gtohhmpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    rghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvhhirhhoseiivghnihhv
    rdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:l5sDaZpVsBfopTvTTD9UER8SFeUaymDekQq7UaJWg-ItdQfg2EfFEQ>
    <xmx:l5sDaRQ4lCV0A9erSNCB7PERxmnzo8OfY-Fh7wqtEsu7uiFxRurP5w>
    <xmx:l5sDaeSNxWoGzZMNG0DlR3jg7KmJ_ai6TDQBdyGiqVYEoIFeRlVD5Q>
    <xmx:l5sDadkcGMgQIAxZCc1L9jnIKS4ADIZPvyx34kxOWGhvyposUBVorQ>
    <xmx:mZsDaQ599w40kuT9dAJqaPG74YgYY--Dmi2H6_K3InCV7vR_Uccwgc7P>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Oct 2025 13:08:39 -0400 (EDT)
Date: Thu, 30 Oct 2025 17:08:37 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-ID: <nwkpojnictbg6jicccpxyfi63ol4tmfajrlx24u5xxoxx7lv5f@jkw3o7j6tlfs>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <96102837-402d-c671-1b29-527f2b5361bf@google.com>
 <8fc01e1d-11b4-4f92-be43-ea21a06fcef1@redhat.com>
 <9646894c-01ef-90b9-0c55-4bdfe3aabffd@google.com>
 <xtsartutnbe7uiyloqrus3b6ja7ik2xbop7sulrnbdyzxweyaj@4ow5jd2eq6z2>
 <24aa941e-64b2-14cd-6209-536c1304cf9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24aa941e-64b2-14cd-6209-536c1304cf9d@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BCAB11C000F
X-Stat-Signature: 5argjnheqcb3eam9gofbcta34q34zr5y
X-HE-Tag: 1761844123-568183
X-HE-Meta: U2FsdGVkX18RgtyClxJC060eQoiepM/PcB2AOl3trZS6PD3QFFbXBb0XyEE+OpnvtrMzB1yvMbJgPGDJapJ2XEAiq3jDed+nb40CI8XIy2eEaeKe66olbiWPc/Ge3J4/gYdscNfRo46GeIgM0W85tciIFHHhq2uHza9c80xmk/EcQPO5eNx6mWUFPIBKMn04gJc3n54A4o9KNCwz3HE1qHyeQqYH2Rqcc9DHLkPDgQyOQceYR+jF7FhVgGWiZXKZ14arWvMWCeuwSbzudXGV9CjgusB56cs2QX/iJ1ZiPqnaTF0wAqhm+UKcG4Fv7KVYLxEmAzGpON4Hc+48W8n9QU31vztFjvPasEnurLWoK56tQhJlAN9bpN8vnZ24kPZRRYekGoItndy67cOJ5pFweLQMqTYKHvA/rdSoDgRrOAYPtIAZmthMmyCFPSerwvxsiOH09DaaG9OJRFDXVZvkvJj4C1Bnt7vNuKMWsMjmV30GlujV39FreZBDyxjIqbbnYmXEwLF1YJ43bhVPtlii6+2rIY49eJD5qurUOIuCrV9kjTeBnPuI3/DprL6CZQb46heJP+lPVmiGqYTJ4BUadj0vFgxGxQbp+wVoSDIeF+s2FxTk92VAvlaAMGdIo4a0vKG0JmISg2nIAV/DAyFBAS5atyvWgRDHgtEiq9OURQnn+PmEQzjR2iNyIFgu1GhqMT2bjKBxBAXU4OfEuv8fKbjNFis7zoKILwTn8VbhQkyRnU3digFBt6CyaGmATg47NEfwbnyeza2E1kqnhNawmnz4KbYfU174Ioo5oxXRPbVqLHi2Ow8QPrOASI8DhNslLyIaVP4uDczmvNTLjBzVVhjZP1wvkQcfPt1TQX9C3M65kddLCoebI5/Ie5/MEpb2M2IrNxOr3Le44VUk7XMKGRBEc72Yf5n7fGUsspULgs1VgMhnpwsMuZXwoKrnn7Mw+0zTgNJl8JLTQH3aWQc
 mL3SKITB
 6yBrxEOpBX8UKo0/D5kRC9Qyrhgjbebl5mI8WC4bughi3yJEFt+23JkqFZAU5i8gZRgfCYruVF7CJIWc7Y5l5kMqC/un8JjjYcRZJ5+vaIiKHqB/2SdzotyfhKQfKPBbT5r08QEDCpDsCxVes3L6nFoJp8WwaqxAssPajOF5lxkMjwy6WcAJHeKmFw98EJ6wHEVgQb/rNjbc+Pz8X4WU7ojv6OLQiHQJEiZqcXTWezdVRBqusZDGRlRzL29QD0AO5eP1dOvt37aD8DBJ4uWK3fk2uG8zPsXA2SnGaGNxEVK3kQxZ8Xt2SOHFgiGi8Ix9WHbpjCv/B+NXUwXTAqJVgHVLPG2JAyqThKbb5rX6I1t9/Jtgyb3hGTQ2v/QCmBOh8tWRfAZ7CLkg8L6jYhHODPa8YqBZwbdV6d7gjwJ2aUTBoVB7TBNOrynnUGSSQ1LGKjuFfCS2dYVxx9PiUGJg9WDvga3quCjkqcJC/Ybl3Wyc0MNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 10:59:24PM -0700, Hugh Dickins wrote:
> On Wed, 29 Oct 2025, Kiryl Shutsemau wrote:
> > On Wed, Oct 29, 2025 at 01:31:45AM -0700, Hugh Dickins wrote:
> > > On Mon, 27 Oct 2025, David Hildenbrand wrote:
> > > ...
> > > > 
> > > > Just so we are on the same page: this is not about which folio sizes we
> > > > allocate (like what Baolin fixed) but what/how much to map.
> > > > 
> > > > I guess this patch here would imply the following changes
> > > > 
> > > > 1) A file with a size that is not PMD aligned will have the last (unaligned
> > > > part) not mapped by PMDs.
> > > > 
> > > > 2) Once growing a file, the previously-last-part would not be mapped by PMDs.
> > > 
> > > Yes, the v2 patch was so, and the v3 patch fixes it.
> > > 
> > > khugepaged might have fixed it up later on, I suppose.
> > > 
> > > Hmm, does hpage_collapse_scan_file() or collapse_pte_mapped_thp()
> > > want a modification, to prevent reinserting a PMD after a failed
> > > non-shmem truncation folio_split?  And collapse_file() after a
> > > successful non-shmem truncation folio_split?
> > 
> > I operated from an assumption that file collapse is still lazy as I
> > wrote it back it the days and doesn't install PMDs. It *seems* to be
> > true for khugepaged, but not MADV_COLLAPSE.
> > 
> > Hm...
> > 
> > > Conversely, shouldn't MADV_COLLAPSE be happy to give you a PMD
> > > if the map size permits, even when spanning EOF?
> > 
> > Filesystem folks say allowing the folio to be mapped beyond
> > round_up(i_size, PAGE_SIZE) is a correctness issue, not only POSIX
> > violation.
> > 
> > I consider dropping 'install_pmd' from collapse_pte_mapped_thp() so the
> > fault path is source of truth of whether PMD can be installed or not.
> 
> (Didn't you yourself just recently enhance that?)

I failed to adjust my mental model :P

> > 
> > Objections?
> 
> Yes, I would probably object (or perhaps want to allow until EOF);
> but now it looks to me like we can agree no change is needed there.
> 
> I was mistaken in raising those khugepaged/MADV_COLLAPSE doubts,
> because file_thp_enabled(vma) is checked in the !shmem !anonymous
> !dax case, and file_thp_enabled(vma) still limits to
> CONFIG_READ_ONLY_THP_FOR_FS=y, refusing to allow collapse if anyone
> has the file open for writing (and you cannot truncate or hole-punch
> without write permission); and pagecache is invalidated afterwards
> if there are any THPs when reopened for writing (presumably for
> page_mkwrite()-ish consistency reasons, which you interestingly
> pointed to in another mail where I had worried about ENOSPC after
> split failure).
> 
> But shmem is simple, does not use page_mkwrite(), and is fine to
> continue with install_pmd here, just as it's fine to continue
> with huge page spanning EOF as you're now allowing in v3.
> 
> But please double check my conclusion there, it's so easy to
> get lost in the maze of hugepage permissions and prohibitions.

Your analysis looks correct to me.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

