Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30800C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16D56B00C0; Tue,  1 Sep 2026 11:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6216B026C; Tue,  1 Sep 2026 11:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67D66B026D; Tue,  1 Sep 2026 11:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8746B00C0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:29:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 142641A044B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:29:17 +0000 (UTC)
X-FDA: 85165577154.16.819F080
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13AF6A000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:29:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfcivOSb;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788276555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76k3ebeTiGHZdNKuTSQi/NWwAeUMZ+iwU02Jwt/dttM=;
	b=lyg7AX5AT4NgnIW5Ng9yMIowTCMQeqndLurjXMzzfau7s3qkDAbE5pa1T/0Hhu+oLDT6YR
	tFD0jAN8C/dLHLXaMtQJsgZHundQ6QjN87TbqaDOslNXLnLGhI0gFewgRYujx9WBQrd6Bo
	rwS6Lwt40Dv8VVRBpIet+McrMOlSyIU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788276555;
	b=8PSdokKGRhRjY076i7i9/U+jh8P8eIF2ebH/cvf0+eCJX9TPOpU7XQyRbmmdQxSkp0GfDa
	/4IZ1Gt+oL4Qw0voEMfgRjrIA0GiAhDD+/iCmktO6RHnVmdmhB4sQ9TRXB1t020mvJCGf0
	LSPtgKFtgqlA6wE0Bpl3BM/4tw4tL7w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfcivOSb;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7821060A56;
	Tue,  1 Sep 2026 15:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDC81F00A3E;
	Tue,  1 Sep 2026 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788276554;
	bh=76k3ebeTiGHZdNKuTSQi/NWwAeUMZ+iwU02Jwt/dttM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LfcivOSbSNA9RWVTIQCS5VwJvAly6t4EmMGccL6I3BGCEmGObVhvyZieZT4g4qACu
	 aF51VLZtUbROnSOzeEvxDMjG+n+AzoLaZbPVdTLdwrIBkE+OWwB9HDvjwc8z31Wqks
	 QMM+8lXtjv5Zy4+t01MHdoR+BxHu/MXx89XoVrRr23n77vHGxSgtOyoYOCSJwtq0Ik
	 eiH/kjr7kQ5u1gsg4hTaYnTmyBJSsG/LqsXooivMk5Apd9mKIEO/Jb/6DBBs9c7EiB
	 exzbv2gAB9y1+8NDMAJrFR/UPThN3lS5azkUwjKYYsp4zBdbvM0ujbS66XryEQ/87l
	 Pv43kYheGE4aw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 058231980054;
	Tue,  1 Sep 2026 11:28:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 01 Sep 2026 11:29:07 -0400
X-ME-Sender: <xms:M--WahvHse2oIRrD_rseDl9C-ZJhTbKIfPSqnIvcGI1zubf22JkOzw>
    <xme:M--WasiaY12qk5MSNUOf1e6k2HlbkF91BHJu0rQVcKOQcth37N5HHPdAMUpwNeHj5
    RFgfe07zms3GHjHXwPHq95R6ZX6lQOjTyHkoaEz1hReoqe__yYrBW4>
X-ME-Received: <xmr:M--WavVRNHIwIUdDv5l9z4829oEwbHrjXMXF0xipj6MwWtuOW7rkFsCR_uU>
X-ME-Proxy-Cause: dmFkZTFktg/hTQ+O6MbEiEwc2myH07+rMXf0DZqVtTUmRXg4RwvnbNppg3BbYl6I9K2dJp
    zj2kvOaUXcu2ztpPSJQZ8Ogheq7n6crddipwfoV80/nKOVQCCUOZnwgAEYU3Av2yZmZYHP
    7I24oVqb6S67vLQnUUVvqgo9Ogx60q3Zj3bOCLUAsSUEIPZoTe4V2V2wqRJqBwtgC7FsoJ
    6rYeXjf2LD4UuiBTZ1hgiB6DybGuursalkVC5p+rE3Z61vyySwM3+mUWXx3KxMVsF55pfW
    Y63Mg9mEwLnf5UI83C+MMBITxZq8Ug1aRj6MAutPXRzdrg4OYxGJGhFXVYpjOziQBAb9RI
    1M1hA5OH+Ae4cWmjEpmcov0cbF7J1JTYooBZB1U/4PkwrHTcu5roVcjACm7Wf3tkWztBte
    OY+5bwnhGsoj0FTHeT0/cau4njSfVbXlJZ1jSVb2nMKJnYqlsW3moVE3n8V2D8es2M3EPy
    5xaMi7C2kz6Mg9KuRoNC4hwC7/Re1QxT08Hsh9sEILCxwqWQNx2QWNFYFS3vApiRt/qeEh
    QZMs8OhwcUjv+4Gjxqp6zUOfl3bCas78PtJvCW7P93kuisSD3Qf06s4bxmIr/Ytjmx/fZ1
    Qv+oLYQOOBA+Bv+X1KZMEAcNK1ia85teinZBzPxGV9H8TQ/W36HCzjE2uc7g
X-ME-Proxy: <xmx:M--WagDwDsuRhYlPUS5009TVT-JmUmFPfk8tT8Ihad9WNGVEBkDr3Q>
    <xmx:M--Waq1tg3CGJkpofqoMI1nmHu6fHckkcCOQ_n8FOk7vlXqALJ9S0g>
    <xmx:M--WauyQGD8lNfq5dgpLZmF9YWh9ZUAptqBHc7qNY6yBQsLVM78reQ>
    <xmx:M--Wat2_ypH88ppv7bgKgsvW6JDW0CuFRqEWiyfrcq-B01oqGstDHQ>
    <xmx:M--Walyk2Wbie6GYaeRz0DZsXByeR-pm3LLszgFYWs2sIkT9ZW_LEq7e>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Sep 2026 11:28:49 -0400 (EDT)
Date: Tue, 1 Sep 2026 16:28:48 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
 	Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, 	Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, 	Usama Arif <usama.arif@linux.dev>,
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
 	Geert Uytterhoeven <geert@linux-m68k.org>,
 Dinh Nguyen <dinguyen@kernel.org>,
 	Simon Schuster <schuster.simon@siemens-energy.com>,
 Jonas Bonn <jonas@southpole.se>,
 	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>,
 	Yoshinori Sato <ysato@users.sourceforge.jp>,
 Rich Felker <dalias@libc.org>,
 	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Paul Walmsley <pjw@kernel.org>, 	Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, 	Alexandre Ghiti <alex@ghiti.fr>,
 Russell King <linux@armlinux.org.uk>, 	Vineet Gupta <vgupta@kernel.org>,
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>,
 	Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>,
 	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, 	Peter Zijlstra <peterz@infradead.org>,
 "David S. Miller" <davem@davemloft.net>,
 	Andreas Larsson <andreas@gaisler.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 	Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>,
 	Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 	Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 	Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 	Sven Schnelle <svens@linux.ibm.com>,
 Richard Weinberger <richard@nod.at>,
 	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, 	Arnd Bergmann <arnd@arndb.de>,
 Vlastimil Babka <vbabka@kernel.org>, 	Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, 	Michal Hocko <mhocko@suse.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, 	linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 	linux-arm-kernel@lists.infradead.org,
 linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org,
 	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org,
 loongarch@lists.linux.dev, 	linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 	linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 Hugh Dickins <hughd@google.com>, 	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apbuO_QveZNAz3ns@thinkstation>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbiB51hjm-9pRzf@gremlin>
X-Stat-Signature: 8114zogjm5sw79ay8s54q3r8ej3qxkjm
X-Rspamd-Queue-Id: 13AF6A000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788276554-606250
X-HE-Meta: U2FsdGVkX19yVdJVBLq3QaVBHI6cEq2GXlFfE3nIrAkunLg0Grq5DgM58QDLEHhpSYoZ56Re0ohlaJ2X44W521nvnV/6QpcxL/rUT+nsCrzv62rkx6piAA1gWSvi3mobeGmubLb/GU9ZoDplr289diPBZ/hgNk3DD/eQJRX0olI614MMRM1cnJQWKSHNB2hV+7gPaRSD4/ZqOZuHAz1Wl5t6sqDqtWvr9OZflvz1QDZXABR6mcWdHJMybdjZN9wTncJfSDT3kq2r6+WuZSkLgSCERpJxo+bD/wMRICtlf6g/OL/tQbvB02Vy/dsYrixo7T6DkYUYGpnutwH1PqCTZm3sHdot6mG+Nqokje9kH8D64wsrNB9mUS8UWMsBz0l6XYfExgziaEZGNUEb2shl4RUm8EvJjpp6DjjRlRqJq88b783rUzpWgkqVttK8c/v7hiLVBsRvEJxe/MCnccTWZzvzZ6IaSB68g7s1o5BxRBlHswjTCMv5sjmYq3zgdcbJbffmNAwPv46XPaSttZ0k3hJwrJ3sGFst6dyOUn/403z0VX70I4oLNzm63rfhGTBO+9I1mOlg6nH3ixhNGzWs7vxvR4eZDEJ5ZVJNCCI58bw7KdDqoMy2007i+aEWelZH4XGvdW2Mv17q5lDXBv7SHQmy8lYoPcs+QU3A4IEkXUgR0LpLo76kVCqIlwu0BVV3P/dm2VKVUppdCBQ9bOm/bkgVmr5vnSm7zhLM1Tsisy93ZhGj5flQCErusEOc5+IB5broi3IQ4ZSykUddl7VhFKlVH7lmEUSxnnXZphuPuX1HcKV7mbwrD9NcZtsvaiD1TOxb/W3+KS1visMfp4x9unvADsbyvUQo6z+wzGIGSFpCp8MumKWMzxRGpWiNs+WH8wUwNq+sjMUn1vWUoZV6/EIJDXTmOtrzw+DBbR0xm6D19I2S6vK9skRsDkpEmOZfjOqTrom4rPQS7GEzTjT
 mDIa83N1
 HqMgFQwvMxpdphxcxfNjetUagVbL4nfNfAfXpfD9WulWpVGAqkxlu8XNQ3ilfYoVwcVYkps7+28Pi8PkVl1DQc987o8Fc6unqT/N7yvCMtU/xOf4pnbB1j6gZtW6TvgrBxAX7ZshgrmCXOsdtwmvBQQ8mmERSCL/V2xXluZHDfpLYueFASHy79YksSTdi0tSkHhAiINbqIG6MbCI4Ssc1QcHYGqOhP/E3O2ZEpr56bCqQGr4zWNB3HURNdAyDovab1Dz2HTRCep+2pCzXqdxFXTXZfabv7WfH1w1Y92D7kwwOIeTcIkVuc1+B52Taqh8XZ6GGsDk598dlTTbHgCVyb4feC/MGjptl5A889aeIDLM19K4lBfel5dsAjoURVYpuuMghf9CIaWqyo/acj4qSWIvgLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:41:17PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 01, 2026 at 11:24:08AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 01, 2026 at 03:12:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > > It won't be costly at the time of the calls obviously as its deferred. Maybe
> > > increase some time spent in softirq but again is 512x that big of a deal?
> > >
> > > I'm not sure how you'd both defer the free and somehow utilise mmu_gather here
> > > either really, certainly not without it becoming extremely messy.
> >
> > The less costly version is to thread the page to be freed onto the
> > mmu_gather through a linked list in the struct page memory. This is
> > super cheap since it is just a singly linked list operation.
> >
> > Then when the mmu_gather is flushed it does a single call_rcu using
> > the rcu head of the struct page of the head of the list. The callback
> > clears the entire linked list of pages.
> >
> > Since you have to tlb flush anyhow, it makes sense to always use the
> > mmu_gather. For example the design I ended up with for iommupt
> > accumulates all the invalidations and all the free-able memory into a
> > gather then invalidates and frees.
> >
> > This allows maximizing the tlbi efficiency too. You can't do call_srcu
> > until you flush the tlb and if you call once per table then you are
> > also tlb flushing once per table too.
> >
> > So if the kernel really does want to clear out 512 leaf tables the
> > optimal implementation is one range tlbi for 512 entries followed by
> > one call_rcu to free the memory. Hence the gather..
> 
> I think there's some confusion here.
> 
> This isn't the path in which a page table is being freed, the _deposited_
> table is zapped, in zap_deposited_table().
> 
> That is, the page table kept in reserve for THP split, that is not
> currently mapped.
> 
> It amounts to a __free_pages() call.
> 
> The TLB operations are in e.g. zap_huge_pmd() etc. and nobody has
> complained about inefficiencies there.
> 
> So, unless I'm missing something here, TLB flushes play no role in this
> whatsoever.
> 
> The issue Kiryl raised was that instead of immediately freeing page tables,
> they are now batched up individually by call_rcu().
> 
> I personally find it difficult to imagine the numbers here would be
> problematic or certainly cause anything observable beyond what is
> observable now.
> 
> So I'm going to have to say, unless it can be clearly demonstrated this is
> problematic, I don't think there's any reason to add additional complexity
> here.

It would be nice to measure munmap() overhead here.

I am worried about hitting DEFAULT_MAX_RCU_BLIMIT and trigger
rcu_force_quiescent_state() which can be disruptive to the system.

DEFAULT_MAX_RCU_BLIMIT is 10K, so it is ~20G of THP unmapped on x86.

munmap() of 64G worth of THP should be enough to demonstrate the
problem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

