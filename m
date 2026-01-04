Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C644C2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 22:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492F26B00AA; Sun,  4 Jan 2026 17:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F0F6B00AC; Sun,  4 Jan 2026 17:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B3B6B00AD; Sun,  4 Jan 2026 17:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2002E6B00AA
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 17:07:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6678141610
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:07:47 +0000 (UTC)
X-FDA: 84295669374.06.13CDEF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E97A4100004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:07:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gScty2Ff;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767564466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wo1Kl74psMzgyQ0k984/Z8XxStihf6Ag9RZU9qJUQBI=;
	b=ONtXaaK9tzBNTfLvIM+C0ZhRW4l8iR5e+88DXDB7ESxoH8BpBvcYT2JWxYNbwmj1qefCQt
	Ji4H3L2g9rZqa2AYnNXf+VA1YnnzgFslIAaK0GqNuTpdmoEInJWIZo3QDKsr2oAqc1MAMN
	FSWuKJvktfSPEemNrCBM74dexC07spU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gScty2Ff;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767564466; a=rsa-sha256;
	cv=none;
	b=bFdEFxEIHcDM3FADOivbLmeXGUFR7SQ8viFdobfRRIGS9mVbUUUDrJLxlIROdSdMFG/i3s
	d55zOHh6O7w14Kf5zrGVuZz6RnCisRoBFiziYM3V8w9RmpRvRG/npBxNQ4O/QgdO5TtPjB
	BP8UDrm6EafNC1qLwPu7Pddfsp+jpTk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C47C434F3;
	Sun,  4 Jan 2026 22:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E756CC4CEF7;
	Sun,  4 Jan 2026 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767564464;
	bh=Ee42W97PW2cmqfwn1Sv3QlRj9Q5zCvDbUSuBQxv/Op0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gScty2FfULdESXHMa7hr8G8loXGEUlcQN5S80gDD5UqJ9suJ3KSg5EBnAfBmPbN4t
	 9i+loVAvbh0AVx5Yk4Koh1k8IXcYongXSPkBU/coQveXqy9HIob5+WjT9N8n85Gjtm
	 QC1qHBE6xVD7AdKk4C44SLTYTxRO2wXx2AsAtG8JDeEhyiIAC6f2WQDRBjpGsCOR0w
	 FS8iQ8IYIJkUJd7l21ONO+cGDEowjKvrtTSsbbdAQreKdAJdoXpAyGIgxSjm5iGWsN
	 P4fDUybYnndFC6q8lAflfYkDiUy/1o2TDN1ho6i4H4kKv0NoHgcQix3vta1Wo/qJz4
	 ESWpk4nesfdDw==
Date: Mon, 5 Jan 2026 00:07:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Klara Modin <klarasmodin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH 3.5] arm: make initialization of zero page independent of
 the memory map (was Re: [PATCH v2 22/28] arch, mm: consolidate
 initialization of nodes, zones and memory map)
Message-ID: <aVrkmnzgwM5i1VqX@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
 <aVhN2NgQEKe0yzva@soda.int.kasm.eu>
 <aVll339wim7dCIaQ@kernel.org>
 <aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
 <aVpWpLV4Dut5Muo2@kernel.org>
 <aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E97A4100004
X-Stat-Signature: dazna9bjsbbrbfh3koi4wj1o13tcn15i
X-HE-Tag: 1767564465-89314
X-HE-Meta: U2FsdGVkX1/96+HxAm6Scpo+AQOg0DoUx19qiCA6zsNUBA0by56QHJVSZaqr0poP/NAlyj/oeEm9Mrjkr4sUHid+YKxm1dEHCP/UEIDS0BZ60+XK4fEp8fz/jAITUJW96hXGkEIPAHHaJSghE3V0eMFzeS+cmHJpA6PXMBsgmxs+7LmN54khNE5BULRzOFV4wCNJsHghSkiUfAef4Hzwd6JKmIJBMzHqBVhsylx856tCJl0ft1hwrPAYM2jw13LjWcCEISvT/KT6YpMHyyOq8jN+gbTUTBbZvD7f/zwhoU5iMwZFFHOnFTzuiCueHpOCxtZz7vOpOHXCjcZuBVU19cA5P2HiDniQB1vndiV2n5qgcU0BNPcS2pLNX9JNOzo0+HTh5f/zuJDefR4afDVZDl3Y6EBEqmI8Z7rkKTjdcZlblVow/NpVFmigs5Fx8qgMXdbJsT/PTDT9LhXvIEFVECJicOc91WeXy1XyQtcCEUSR+FEtcA05tyCAp/djUqUSwHGOX+7vpcNHO+iyyggmeRgnm0DBfMRJY6IEdN+IIK7I1qemUv5V5wVzF7PjakfiTeo3YC2Rsdj8APQjkxCRnzj5q5Cyqs2seqILL+Gn/2M6KwRy9axkz+9u91kAk8ajys1MTC7Y/xgVEBcz/lm+TS4IhaOfQlXjGKr3ow7PW92Mby8KaoI5Xr/Xo/FsdUGc8Ldt/B25Ws54Lothim3AcddogyhDQMbXUNXVH+0V4r+W0trSIE0Ngr07rG3Usr8lscRtaaa31iQAAwfc9mREegPvAHxptVNbGhWNm9oiaWSX9GljqqNdWtYQza7mp6Of6nr+ij29Be2z30Dind2hX3jClz3mB9o5dhgR249UYJMYWKgIiDhD5hqFVEr0GcecIxIPsge4Ek1w9vSzb3cwOQ+AqMM2v0uN3emq00zYAEcfkrj+v4Xg/Ij5+4fNQMlmI+x8Iolpdd72fqF21qL
 sZVEMW8V
 6Uo5LSQs6/G7jk9B38ec9iAYfLxEeNFPM+k8UhP/k1YcRfYjmJ1oKblmLOn/Abi5t5lr5+aZ+m6BPhttWCtuOck+eeJqI6FCiVZSqaaEgyCNurHu/K3AgAoHyHFnFxKoTiWPdXlRGMxAIKyKxMh4vbYW7vFqQ4Cb/lEhKCjWd70ZEto49CR7BJBQ6uAwqlHWpQrgctz22hehxoWuFsI5u1ciwtN4uAnQPpTbpjFXSNFwv+hDuHTPlLFI56CH7BvmKYMel2A1o/Jb3NsT6IYrG9I7vhTdFig3cmvpj3pDKD9bO2MNguSr1fnztNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 08:56:45PM +0000, Russell King (Oracle) wrote:
> On Sun, Jan 04, 2026 at 02:01:40PM +0200, Mike Rapoport wrote:
> > From 35d016bbf5da7c08cc5c5547c85558fc50cb63aa Mon Sep 17 00:00:00 2001
> > From: Klara Modin <klarasmodin@gmail.com>
> > Date: Sat, 3 Jan 2026 20:40:09 +0200
> > Subject: [PATCH] arm: make initialization of zero page independent of the
> >  memory map
> > 
> > Unlike most architectures, arm keeps a struct page pointer to the
> > empty_zero_page and to initialize it requires conversion of a virtual
> > address to page which makes it necessary to have memory map initialized
> > before creating the empty_zero_page.
> > 
> > Make empty_zero_page a stataic array in BSS to decouple it's
> > initialization from the initialization of the memory map.
> 
> I see you haven't considered _why_ ARM does this.
> 
> You are getting rid of the flush_dcache_page() call, which ensures
> that the zeroed contents of the page are pushed out of the cache
> into memory. This is necessary.
> 
> BSS is very similar. It's memset() during the kernel boot _after_
> the caches are enabled. Without an explicit flush, nothing
> guarantees that those writes will be visible to userspace.

There's a call to flush_cache_all() paging_init()->devicemaps_init() that
will guarantee that those writes are flushed long before userspace starts.
 
> To me, this seems like a bad idea, which will cause userspace to
> break.
> 
> We need to call flush_dcache_page(), and _that_ requires a struct
> page.

Right now there's __flush_dcache_folio() that will break anyway when folio
divorces from struct page.   

-- 
Sincerely yours,
Mike.

