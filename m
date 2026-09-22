Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A576C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE86F6B009F; Tue, 22 Sep 2026 08:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99296B00A0; Tue, 22 Sep 2026 08:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88EF6B00A2; Tue, 22 Sep 2026 08:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3786B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:15:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 416E01C299C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:15:19 +0000 (UTC)
X-FDA: 85241293158.04.167BB79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E7088000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:15:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3gqLkdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790079317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gItcWC83jyqQewAzlLEIrIdpVAhf+FBobtBOU1cWYdE=;
	b=OhSJg+Vd+3W51acas56ZPIeUt8NW7Sa5YUI5X1RqIkqPn+FD+lIa8Q2mFe0taKxtMvJ0+M
	38E0Mj++z3hJiuLdNocyddLrV50Zrvor0vk3xKRz/ilDYueT9fprr5+PIGGZaSNbQH0jED
	KRklF+zCTn37m1uTTauJffp0PHjCx70=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h3gqLkdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790079317;
	b=O7rdDIyYSiUjpmmW94jAe/4qQJ/6OI44jbevpESuD0aAYuWDeHo5ysRpAnPXJLMbl5HmU+
	JOYNTMkQLYiZBE5mRr5DN2P9XOT/6lFT0AnIIbFTOpsvyjxqAcayh+mrNNRKYlE9lQRrkc
	XX+1efJSRkC9GgDwlwvwq7MEbS9cMPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95A18419CD;
	Tue, 22 Sep 2026 12:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D71F000FF;
	Tue, 22 Sep 2026 12:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790079316;
	bh=gItcWC83jyqQewAzlLEIrIdpVAhf+FBobtBOU1cWYdE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h3gqLkdxuBoehEGT/VKAAx5lOOZyw0R9ECju20pTUpkGq3CY4/SfkP5Oo8Atj/17P
	 LheKowjELtZHtWEwX8eBKfgrKHJcRi0+O+d1XJm5SNFJeLnSFaLisjCbEBlxeLxjOn
	 7b+NpgO+ZPXTsbOJUosoddrg+40PBvbsgsGmbY2VSvCJX0WLnI37yVWEjSxgbtaT89
	 F/0sTPdrQN1xs1nAXdWed32VZcInT1tJCp8N+5WqvK/lF5EAI6+8MCsas5iRPln/rt
	 CkKwC8hH7tDlCqpUlqLBsfISPWksuIen1RI49kVL18Y30A/o4HPBKzvey0Im1JOlMy
	 V88LVj2NYFEMg==
Date: Tue, 22 Sep 2026 13:14:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Guo Ren <guoren@kernel.org>, 
	Brian Cain <bcain@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	Jonas Bonn <jonas@southpole.se>, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
	Stafford Horne <shorne@gmail.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
	Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v3 01/12] mm/huge_memory: zap deposited page tables after
 an RCU grace period
Message-ID: <arJrv6FdUUgAbVp1@gremlin>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
 <20260911-rcu-pagetable-freeing-v3-1-7b8c86103821@kernel.org>
 <467b6599-b73a-4f58-a29a-b6c6d1ffc3a5@kernel.org>
 <aqrAflIQbwcNKlQL@gremlin>
 <bc2805a7-361e-4082-bf71-efc125b93c84@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc2805a7-361e-4082-bf71-efc125b93c84@kernel.org>
X-Stat-Signature: a66fi88di1q17ftbcarc5bwnm7mqxuqw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E7088000A
X-HE-Tag: 1790079317-714265
X-HE-Meta: U2FsdGVkX18mn11kqwKMw+LbWCyBoGZ/ndgFi4tDfGAyc47XqVqNkbjcJ0kJcH6iqcGAudBQMsro5tVeL1CFcWNydy4q2AqkBVBXM9dPDhM5uY3x9zOV7NQpjGgO4DNIcNL01Om0gLYs/07P1wY+hW/EaNVcP/X1Xqiertb9CJz2BWtVKBMVwZ1iDSCn48d9W1nrU5QdyAzsTG+J+pupeOMbZcbVSJmlJNsmMbnJfayms8xMaaoAw/RbWIvOJSLgqgT00NYlFV50cUU11FpHjELO5CYOwNcCcf0HHBQk3W8KQwxyvPHn/AlwlFBrmksi/0rBoePEQpzAkvP2hINnyLXHK2DZtl11dUYKITAcOurnO2OZCkdL1GT8TzCtV+GSHaualTV/soJeYKiGzJgTxpRP05JEU6VOpj6bv4lWDGG3xoLYFxyIui38vq529cn5xV4J9FD3K9s7bt/clIE4zqdgsP18IdWXDWlnrnYj5tiXVkBjimO/ZMsksKt9IjOHp8MzVZeF/dr3r1jFidqPUodElIn5e8YruNJ/H9Gy8sad6VZgEIG1uSw85yX8FpZ6azAgo/Wv9fEH7MRJpxS9hAJbxWes5WEwqT/7pKhuYs1gt4XYQrypfjGlVFxN6klPVf4a7fnJDBD+1is1uvmSiU3b3w5Qwak4evQhUMrkN7bi0pGIuhmZj3yiTz/ZW+uZUrlFknbtNwgNMMLFJeKkZjYGqu1Vm8ru8gbnHCO1DCGkzlMDdHh7GUGozFaHwtVOn8BgmG5b3AbS9Yl/ypx1fAFCCnPfKT40pbkPvljh7LYuOLeLqu5w39Vqx8wh3nQZWuYLNFciVVx+98vCFoZTA/QO+RhEwCje2pWaL4yajB+YiQMqCV+pGqFVwNa8idMkW+5kVWof6fZLbop6NPIXws/7jqauMncdqV6uf7DIPWWwEbgSmjH+aypDENGRc27WVVVlgsCFllANY1YPjsl
 lFI7yGwQ
 sjGTlV/8If4+fZox0IkaALKZPotg0C3A69sAotPwhLLyYVq16waM5k8cyIl3ggkc/MGRCNCsamGEoMzuNaRkoG1/lKwspzt+RhEhkQ8XFZBBMH332ZemscCKdYU6AD4FnY84H6BJTecoaAZnqJVm0+lRkbvd+D8CVKXGW+hEHHFObKCvbIpW4BKwmxHE1TSrqDrIKSijxkpmbXSeZFsI6hIGpAAAbDbGYXt+10WTGjK+fDe9rBAFrX+esYR780nBnKeOVqDbfEQ9s8WnUsyGcKS2u6Sc3Vu4jCDT3ChfmsOg9qed80Mgyyh4mWJM9lOHEGrl1BWotLI/fwGKkNN+n0Q7QNnstXdLmNKJ4FDwqy1OZ3tvInwIUw+euRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 07:13:16PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 18:59, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 16, 2026 at 04:42:04PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/11/26 21:36, Lorenzo Stoakes (ARM) wrote:
> >>> When an anonymous mapping is collapsed for THP, a PTE page table is
> >>> 'deposited' with the installed PMD entry.
> >>
> >> Right. Or when we allocate an anon THP.
> >
> > That case doesn't interact with page walking though, as they're
> > just-allocated right?
>
> I was surprised to read that page tables deposited during collapse should behave
> differently than page tables deposited during allocation :)

You'll be super surprised by how VMAs behave when detached vs. attached then ;)

>
> That's the semantic change you are adding (and that I didn't quite understand
> from reading your description): a deposited page table could now get reused and
> modified for another page table due to a PMD split, while there might still be
> an RCU page table walker walking it. And PMD comparisons (+ proper memory
> ordering) have to make sure that we didn't just walk  something that doesn't
> belong to us.
>
> [...]
>
> >>
> >> Wait, but wouldn't it be really problematic to punch a page table that is still
> >
> > Punch? You mean deposit?
>
> Yes!

Ack.

>
> >
> >> being walked into the deposited list where it can just be allocated from another
> >> PMD->PTE split?
> >
> > In general, RCU-only page table walkers are _only_ guaranteed that the page
> > tables are not freed from underneath them, as per the cover letter:
> >
> > 	"As a result, page table walks can now be performed safely under RCU without
> > 	 any risk of page tables being freed underneath a walker.
> >
> > 	However, this is the only guarantee that this work provides - page table
> > 	walkers must still ensure that page table entries are as expected
> > 	throughout."
>
> So far page table walkers never walk deposited page tables. Just like they never
> walk freed page tables.
>
> For *current* lockless page table walkers (IRQs disabled),
> tlb_remove_table_sync_one() takes care of that. So there is no such thing as
> "walking a page table that was reused in different context (as a page table) in
> the meantime".

Yup I know. That describes what happens for RCU page table walkers _after_ the
changes of course.

>
> >
> > So this series doesn't actually have to answer that :)
> >
> > But a PTE PTL -> pmd_same() check will flag anything like that,
> > a.k.a. pte_offset_map_lock().
> >
> > The RCU lock replaces stablisation on stuff other than VMA/mmap or rmap
> > lock.
> >
> > If the walker needs to be sure the PTE is actually valid and belongs to the
> > expected walk then further is required.
> >
> > Alternatively (like GUP-fast) if you wanted to avoid locking at all, IRQs
> > off would be required paired with the tlb_remove_table_sync_one() in
> > collapse_huge_page().
>
> Doing an RCU sync in tlb_remove_table_sync_one() would be the big hammer (I
> thought that was discussed with Lance recently). There is also this option: just
> allocate a new page table and deposit it, and free the existing page table
> through RCU.

Hmm yeah big old lump hammer :) I mean I don't see how that could really
possibly fly as an option, we have tlb_remove_table_sync_rcu() for
!CONFIG_PT_RECLAIM arches (i.e. err... the more 'specialist' ones :) but for
those in actual use that sounds a wee bit nuclear.

>
> Long story short: allowing empty page tables to be freed by RCU is simple.
> Allowing empty page tables to be reused while they are still getting walked is
> obviously more complicated conceptually. Likely it can be made working, but I'd
> hope that we can keep it simpler.

I'm not sure it can really safely be guaranteed or it'd involve more lock
dependencies or something horrible anyway.

But... we don't need to care about any of that....

>
> >
> > Another strategy could be used I guess with looped checks but it gets a bit
> > sketchy with timing etc.
> >
> > But actually maybe we can avoid all that...
> >
> >>
> >> Note that pgtable_trans_huge_withdraw() just dequeues *some* PTE page table in
> >> the list attached to the PMD table.
> >>
> >> Something is odd here.
> >
> > ...Since this code path already allocates (the huge folio), so allocation
> > here isn't an issue (as long as done outside of lcosk), why not have it
> > also allocate a new PTE to deposit and RCU-free the existing PTE instead?
> >
> > That eliminates the one place in the kernel (afaik) where a
> > page-table-walker-visible table can just get yoinked over somewhere else.
> >
> > Then a lockless PMD check works.
> >
> > E.g. something like the below?
>
> Hah! Great minds think alike.

...Because great minds indeed <3

Will respin with that then, thanks! :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

