Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2E4C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 11:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF946B008C; Wed,  9 Sep 2026 07:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0086B0095; Wed,  9 Sep 2026 07:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BEAD6B0096; Wed,  9 Sep 2026 07:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 349B36B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:25:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 950A840197
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:25:15 +0000 (UTC)
X-FDA: 85193992590.24.119DF60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 197D8180005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:25:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCsVcikz;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788953114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inNJzZhlDskfV4tobMRa6NUvX+KktI2JxAaJsuypEcU=;
	b=iDj45f6PXrtv71Ws+G7+Rd01B6u4URj16LJY+0NipGBSCKSRLFLWqp1yPq3SLRVcJpjP2S
	01zLageLWCwHsW/PpJIQrbF0LpimBqMsA95jhdjyCqEbm1qOJz2k8VLvjtGOAboxROVdTB
	zq9l34f/ctNZRiRhmOe4WxJ7HiJDkSo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YCsVcikz;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788953114;
	b=2NFw7J18lhsxXJDndkcDOomQ02jMEswm1utxDKFWavdFyHaPTwJa+lApiuI02DgU8cPZ+o
	9LJzMFiLExhCPqy8gGADoxPwRCT7eHGJcNHjYh9D8oswOz4dkenVMolOMIeVK2DknUOW78
	x23OitlT7igEgmuiCm/6ZEG7SgkLDbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08BF160211;
	Wed,  9 Sep 2026 11:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8571F00A3D;
	Wed,  9 Sep 2026 11:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788953112;
	bh=inNJzZhlDskfV4tobMRa6NUvX+KktI2JxAaJsuypEcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCsVcikzxNnvBT0Y3c5qUMcZq6CnjiF9LAucMz9KUDz/X8rycnl20TJiMBuTV44C6
	 ciuJ5X0Mary0o+RdhTl8tWHSISMo1lGTn+IXwhIQfs7dZg1NC//UvrgDFVVFH2BXXg
	 wGSvIxQ/NBgeVTkoO77PEhxG5tF/kt0hk770YdbvA7jzYldeFCi6gaAA3Ie47dGZ4o
	 rDioSU8ROD/U0Ex4wV585kl0B6XRkVhfL48+PBTUa/l0vXguhxnOvt9I9np0ualYy6
	 L7k5zESC+bnaJX5hWbMNkzgmSv0XEtgXO0Eiy5hQl/cIt/eJwNjq2z/FZB7YFfjxHL
	 0pO6lgM9ge/7g==
Date: Wed, 9 Sep 2026 12:24:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
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
Subject: Re: [PATCH v2 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <aqFBXNYGa5cktCeJ@gremlin>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
 <20260908141543.8180b60400d38b70d249949b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908141543.8180b60400d38b70d249949b@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 197D8180005
X-Stat-Signature: w78st86win74zmuqa1bx8phgqibjzemj
X-Rspam-User: 
X-HE-Tag: 1788953113-671233
X-HE-Meta: U2FsdGVkX199igxMgnmkRj3JB1SG4oudhzzUMTAlq+EttVFeZUsoIKueOh6P5UdUWglu4/9iALs+sLU6T12oQuE5z2dsjMnbEVzH8CVS1oIm415bEBULmYEtRnkODkndO3QDDtan1MMwRl1+vM3OSywPmDsuedO9ld1hIwC7kJJWj2+breJMxQn+Sb70kR73Zonvt9G46ahltfOLjTkLAfb1cimtL788gZUesSiF7lNh7uYOgIj4dOxu63OfgnibBMT6yz/TvAT+LtXbrpw8Xm9xDuJPznPgmhEydWLkXKSl0Gp3IzPPhmai1Rkc/giGxb/vDN29het/plS5XaitV12fUerkD5e8mXN+6x4QjjZ+8nfaHXUg4HEGB6jiXMOMtush3q547tsLnnQw36fZI7B6gCHY4pAawskMy0nRq1ssJgwVSn6ZilwAxkyZMJ6s4yjdX0kzKcyVL9OOqcsPpLtfiW+U6n8owii01Ql70sTKkhpRPGmVISSC8GxpggUTJR1j4FiSpZ1qPsjtcPmU8+fFd1dwXizdjOIVVw8UKAuIvjgCj4b2NxQAG/Ktr73W/yslcL7EoIo0RGVvJGPj2FwJbnQu8B9zS66Oi9Svzk4hR1sgfZoPyPTmiUhdndAEu2WnYVL/1HBHcn27yhte7NDYYwXy0wazfO8Iu5kavGD2Au6DnUUx0sHjVm8rat9UkNdPb+5Rq5cgBhftf/NpP5e0Zw1xEgtHzHqfdifLa86aVkdFrXdok682dFqTj79pe+ied3WodaL/f8kONMhkSe6O/Jza252zqmLea7oqx/4WbTRgwzKeeTZu4AjLu6Pf6rwDAnguwO7foeVRjvLbdlLwhKGW3qzM4+EixwhwqaW2k6zUiXWuprAETmfq0hhDrmldN3+ZlsBLZNv6jZsY9O0MBg3agGlDgAIhLOYFIPz3gw3FAdmbvWoaU5nJeHmHWMOtvCAaVxjd89xstgk
 TalpFoQb
 iX+ZRzfKRZXAPOZwft5nsHbvfRiu9k/t3rPXEKUma0F+9iKGO/iGUyhJUH3Kr3wOn4kvCjKk92QXG6UseKixIQ0Lif1RjYo1NWJxaBhr38SNvP25pODjKmIGMkyOIEOENErkx6Mhp6PbrWCMMlCqVWN5sXp3BtOxW8QgtG7zRO9C0PM8pwUkTcZLL7bZQet0ZQJ97N9vRAjmwyqnyRrwMLImaLAZrl5RJ9l2uxW80hdCYWLmR0pVc3EuvG+FIlLkC9kSkZtrfKzxKkM3N9CA6weiuxcUT0BzJkZa1g71SLM3CwO1of1sp/TzfE+ZeXcISmGYgb/P0/l05QIhWi6HgWPotoFNOACNFzClG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:15:43PM -0700, Andrew Morton wrote:
> On Tue, 08 Sep 2026 13:32:09 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > The majority of architectures in the kernel defer page table freeing until
> > an RCU grace period has elapsed, this series converts all remaining
> > architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > altogether.
> >
> > This is important because it enables safe lockless page table walking under
> > RCU alone.
> >
> > Doing so allows for reduced lock contention, avoids lock ordering concerns
> > and enables fast, efficient and correct page table walking as a result.
> >
> > Additionally it removes a bunch of code and architecture-specific behaviour
> > which is always a beneficial thing to do.
>
> Thanks.  It's early and unreviewed, but this is mainly an
> if-it-compiles-its-good thing, so I'll add it for exposure to the
> build/checker universe.

Yeah largely, and I have done additional testing for cases which need it.

>
> > However some arches required extra attention - sh-X2, m68k-motorola and
> > sparc32.
>
> OK.  Please lmk later if you think additional reviewer/tester attention
> is desirable in these areas.

Only really the fancier sparc32 setup which can't be emulated [there's a call
out in the cover for that one!] :) though sashiko found an issue with that that
is now fixed.

The other two I boot tested locally under emulation with no issues :)

>

--
Cheers, Lorenzo

