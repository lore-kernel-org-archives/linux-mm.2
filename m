Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7078C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB23B6B00AD; Tue,  1 Sep 2026 13:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E620D6B00AE; Tue,  1 Sep 2026 13:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D522C6B00AF; Tue,  1 Sep 2026 13:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3DFB6B00AD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:14:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C0361404AB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:14:43 +0000 (UTC)
X-FDA: 85165842846.16.CBC3200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AA63BC000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:14:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyGc8XSV;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788282881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PNkp7ez9jErakiPQKOI7B9sFRUtxTNZU0kcpf3jJWc=;
	b=FmlMZXVpeQMes3DfiboaZn78a5YnqsAU5aHFU5duRNSN/0UP1l8zT/fIJ6qPuams4JrCDF
	mqqVejfrIU7quO8QL+rwkk9KqPAC5LpA3caXYnD3qUAI1LCvvJAvyj8uPVTZVZXVYE+x8D
	Ur5zjBIynpCwPCd5iBjTElxWRBq4w0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788282881;
	b=E0cCekIdb/DFOxS+58uYWb00279ooulRTivXcsiy1U0IWZfD6y75y7SDMtjSsGupevrNJ3
	hVp/UG0oC/zvvrwN9IHlxGKS4wzd35rvrJ45KRx79bdc77A3dWvtiOWndHwtp3uqeG8sPP
	0pKguJG1nBNBvzX7tnPnx3PjJBDrkns=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WyGc8XSV;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 481356013A;
	Tue,  1 Sep 2026 17:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563FE1F000E9;
	Tue,  1 Sep 2026 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788282881;
	bh=1PNkp7ez9jErakiPQKOI7B9sFRUtxTNZU0kcpf3jJWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WyGc8XSV+h5QaC5hrytW/vJLWXzYZQZJxWveh4LcjaDsd1IWOINhAcGPiYhISOsLo
	 OSSdCjOizMPKQZXR2T+u5d8YeyJ0w0XUMVwautKGnwupK6xSsdLd57wV979q/6rA8i
	 2+TkAPP7HmGk/XtHJ3EpB24En1Ix+6oYBfTNUJrEQf5D3oyrMxBXMXCYFfIwSlgEHM
	 pSTP37qXlVGUJw0e/z1Tii9u2hm4ByGXX+kZTv428piYykVP1aDkLZkvtkl8B4vVrZ
	 r+SRmOn2ziSMauikcMFr/wbjsF/EUiHXzzHcyMBvmKBcKGquGY/wktocgGQ6amFEia
	 w36rT04Ny6Ffg==
Date: Tue, 1 Sep 2026 18:14:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, 
	Vineet Gupta <vgupta@kernel.org>, Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
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
	Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
Message-ID: <apcH2jMKVfKtnppD@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
 <apbOlyF77yDCV4cF@thinkstation>
 <apbcoMTVlL42G5tg@gremlin>
 <20260901142408.GA56830@ziepe.ca>
 <apbiB51hjm-9pRzf@gremlin>
 <apbuO_QveZNAz3ns@thinkstation>
 <apbvoN6ttgHfI_xg@gremlin>
 <apcFUthh0XSFg3JQ@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apcFUthh0XSFg3JQ@thinkstation>
X-Stat-Signature: gwjqc1n6jqo51eto5ghxuyu8dd3nf51p
X-Rspamd-Queue-Id: AA63BC000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788282881-492153
X-HE-Meta: U2FsdGVkX19nDFkgxtd8QMpioLoqoCSEQGAGx/Li/Ai+cTqVrjG0koOWHfZz5ep9naIsCWfEdhiNAVj9c0dUR/GK+TsKO2/mNyOWVvY1EsP9orEfU3YuDkGL3jg2DID09VjbzWOi8fqEMNORsh3AG7H7BD130EieU7RYBDYUiaj0vXtiYSYS0HrDwYFXQJW7WiNOq7ZrEDvBkBlLSYuyrNb2S56YXOAc8BUKIUlmKeu7RHvJXhfyk/o5Oxc4xYd2OK3ZVcbQ5MpVKTxmzsWt5Ge9vogU9N6RPVoEWCOtm4PLO2i6Tdki5QbWqfZz+TFPTyCRj36ALpC6Xe7vlqARhguX+caWKdzwLtNEoRyYk5YtGDUFrbyv0M/qm7m+CvgVP48IyaWXWdJHXB01K9D+xItLXNK2LiZuJprwAn7Z/5E2nJciQ7Z2PuwTtkj0HTnKAkp+knRUdxTKfU2orFVplf/ZvT7oLvfJ8Upw/x6ZjdCH6sQlSCT85kEmZ9IAjaHdhYL3/8OoT1dG3KcAF3HvFBswsVw0UD8BxZhuFZZNLyxouDXDbYhDhHM6Gh1avu/8o9xdbK9zsfeYc+jjBJ/FgH3a+erBXWO6FW7XXCrlW10J+iwUsqOyZkjv8jRKXMS+dx50s6DPFeaAC78loeab48R9TCa+7x4DSb9nTUjrFFoLofkyHDa05JILUXL8aKNE0xVRoWVI6Cz1SZ13MlRbxZE0sQ5oA/7VQ0sbYYVPu+3560FEstnlUglUFvu0nBoGtcfhjaZUAppwvmRZFhtlFxMNxN2nZjr00WrnVL5RN85ad0ziMTIod0N6TiEpReMTlPGZ5UiLXcoPqRjAYUGpPK0vIxadMZZGtM5ejhDExsFh/AnldWh+hqr0UYOog4WDZvlnLJVt47C7YwUH9umWpTySST2SsM7n+2rLhCHHnR0NH0fJOXGPKQBDsTndPkOKj3ifhQele85wHS6xJCW
 HIO76UGH
 qnBlbySgDKhqgJXLqnYNJE5skGsjPvrGDhOf2aFcA4Yo0nIT02Cr6W6FbIfOznS1OwWTTXdE1FCPxnyeRTXeiVxCekHBj19dhpg9Cw71OXmhBO4gwOn9U5X+iJrSVZGKi0fj4DMMtdvk28esRTelI1qS5cIEW3wqn2swTbC3OlZNzJzhvttctZblj/33vLiCP5hZ9tuiA5cEefGzUxu0AV6yOxp3R0kMePEDFQ58ejkc3fbxfBWGoGlsQxIH65OOOl/HHX0ycFxn+VP0MsVkyOLw6doBCDEX2sr1wG8TirXsdtNq6Q4DmNtxpODgv1kL5w5sp4k3OmGS0JmeErzoJtyNyPvOUEhhSpxgagtpPZw2f8BtU+UOYNA8D5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 06:11:57PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 04:45:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > munmap() of 64G worth of THP should be enough to demonstrate the
> > > problem.
> >
> > I mean you're going to hit that from RCU freeing page tables already, which
> > most architectures already do right?
>
> Not at the same rate -- tlb_remove_table() batches into struct
> mmu_table_batch. One call_rcu() per MAX_TABLE_BATCH.
>
> > So if RCU saturation is a problem, that problem already exists, but I've
> > not heard of that being a problem at all?
>
> I did quick test and I don't see a measurable difference in munmap()
> wall time of 40G of THPs. I see ~17x more softirqs, but this is
> expected.
>
> The objection is retracted.
>
> We can return to this later if it is going to be visible anywhere.

Great thanks! :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

