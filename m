Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808C4C98307
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796F56B008C; Wed, 23 Sep 2026 05:05:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E146B0092; Wed, 23 Sep 2026 05:05:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684F76B0093; Wed, 23 Sep 2026 05:05:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBBD6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:05:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AD181C243B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:05:23 +0000 (UTC)
X-FDA: 85244443326.03.34C7A1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 190BD40004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:05:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDCmOLtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790154322;
	b=lczzUHR5XgLKg09NNSd/3olkasm39JffBmN7KyUekA3xUxGejQ/bhEZl1h0hqPfRQROtaL
	w+M0145vOP1FGq4mjkfQbprx54aqp+1zXtC30zRm9SShwj/BwOd7Afa3Cz459m54K3SDbB
	qXfCYg3ZyPlLpcMnps74qubICun51fw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDCmOLtH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790154322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2o4rQDYiHbtVqFkAN2kWkZun12rmMLs4YnN5p0vVmiw=;
	b=OsUv0WJil0a+9vKRunK9ZyvZxqIwFSnQZiUftOlF2y3dmwMABP1hQQWXDY7+4kMOYntHbZ
	AjAc4e9SI7VFlJ7wsrm+RR09VVNTn0C5zVvo2k4lxrT99ZkL7Yw5LZA56HEg5U7QqYCPIt
	aRY9pC7JFTbn6gPsMLwPylJk+7IuZHY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A523C600AA;
	Wed, 23 Sep 2026 09:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E23B1F000FF;
	Wed, 23 Sep 2026 09:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790154321;
	bh=2o4rQDYiHbtVqFkAN2kWkZun12rmMLs4YnN5p0vVmiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZDCmOLtH6oBzineU5ofDYtw3CW3mtwyk5V3xT/lkkCtxB1Q+OwDra0xNToTtg8iIm
	 u7rGJ/xDe6BKL7MrOMEn8bDOMYTCV4aEzKQKJIt00q1BsH3wSVTQo2Ook3KjVOJMIR
	 AB4sDPrnTg2fF+LMD5pG93PhRaZQ302+w7tBmfT4/Q4oKOmPfIeb2DOtAbjc8G/HBr
	 9DhsZ+uSqRYGiIaloX4OWTC1NUs9xiLQ6o7nt/X/EFVExrVXn1dH9PmU3LwdrRgVG5
	 Odt7Cl6nzQ4qviO/2kqxNclnZdLZjOTUWiY2xDH0cr58TUDFGwa6IBWPTdeie3ekC9
	 ipydVMPWKNSiA==
Date: Wed, 23 Sep 2026 10:04:58 +0100
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
	Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
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
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/12] mm: make userland page table freeing RCU-safe
Message-ID: <arOVbT5B1FOMe1wb@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
 <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dcde7e4-dadb-4644-9dff-7fd8a26e29a6@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: jyhy84csafce8bhasgiwpwwpz1erxr1r
X-Rspam-User: 
X-Rspamd-Queue-Id: 190BD40004
X-HE-Tag: 1790154321-429724
X-HE-Meta: U2FsdGVkX19SvpFkekxRDTItj2poXeaT2r/uIX/hU1xi6AEfKKRB0sm2KQ5smH8rSvAohURywbLWw4ZjClVO9ijSMVXgV+ahyOagSCTw2Pzmf24g2zTnACqEc+k0wpr7Zf0FcQx49HMuOodOEU3rbuLhfXb6GWOf8yUHl7rSAJZrmeMmyKZ0x5Yq1gTmzhtdK+CL25tQR3J3ryzKre/SNURxzLRikOEi2p5dW7W686QGiravYfZ1fpy7Ix3nqLEGFX/6kMGcTu3C0e6j1sRe0s2JxK5vtL59qcOqGHrZ4QcMVYHqoAzKyjchSWUgn/7VF4EIzmjbpFw+ke8sMTl5AZA59EmlV//BKCtDjHVM6Y9VfBMeGSXeXDki1JJpJrocYB7/sfHOXphsF4MIuVoBUPuoTYO7/YnIXWZCfrrpVvShNYxVEzjo2HrESc1cmvs6YT/q9p3DQ+wjh14K5cANNEJYKmu2BIeuiFlzRy3GdpYXC169bzIglDMZtTDGvt3sSVewv047aTTy59mmGaus/MTRTHZyUeVz7xkmjLA+Cl1CLpy7rVIFEmcC3SwzMh380i19INOzLgqB2oIOXHLj+O6L6FCtRzTSpEghhZfhzYx+KSIG/NGg9EHp3GyC2i5JuQ57Hg8XKFNpRi8hcUcRIKBwIrtKEueyDY7YN5a8JYf1acEGQEpnqXSfxpwscVCiYVDuHifk7PzQ/Fr203iAVgSkQv6GrzyM0E2/TTWBKl8rr/9yMGfQ+291PDQIKWz6tjiIJ21alc9c8ngCORAH/LVLgSnb+SokfXipWP8T1g6AbnDjKbgdtnXISlvIn3OX9uVuOyiVnmbTgPm08SDDzz7HodzrQQjGL+ChQd2RryZVWl5Vt84XthyDHHAqkSSeczguI29k8QDCbWqlHrnV4p/n8BxlQLy5+Pm1Yz42tUIbb6X/UKsG4ZzAEyCUsxSXxChsnMDR9dAFFJrND0e
 j9jqdPzv
 MXf1o/IAw3uMOen09t0xBluaGculMX0pNfjBBKrMq0BuYuge/FLhkVgOMEiiQXrkSxGJy3M+j/U2EVDWia5o/jdcR4qVLHR17kyiC6N72W5ZEGWK6ZaymmQMqO9twwhLL6ubL6v0VdkZ/grQgjSk8z4ObdtDAmNGqmvoN+7WQaMTbdseat9DR143jlBXLekheK4ferasKIHMR2iqlX67bt7QEi3JtZDiuqPoMIapHnpwBC8Q3T8igzDY4Qqn2hIN4LUWjbuu5ZbeJLmp4T1m8Ur/4kejal2PkQhC0nEzMgNTi4rDe3OM2ftJOtJHAC/MDyH9IhKR4j8L0mYPvsKu7vw3+4qsFFwr4xYP9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:45:33AM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 01:00, Andrew Morton wrote:
> > On Tue, 22 Sep 2026 16:35:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> >> The majority of architectures in the kernel defer page table freeing until
> >> an RCU grace period has elapsed, this series converts all remaining
> >> architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> >> altogether.
> >>
> >> This is important because it enables safe lockless page table walking under
> >> RCU alone.
> >
> > Do we have reason to believe that anyone is seeing any effects from
> > their arch's failure to rcu-free the page tables?
> >
> > This sounds like a rather long-standing wart, yes?
> >
> > The patchset is thinly reviewed and mm.git is bursting at the seams
> > again.  I'll play wait-and-see on this series.
> Do we want to nudge arch maintainers to review?

(Just to note that I replied separately, 'thinly reviewed' is incorrect, it's
been in -next for weeks and the whole thing was reviewed by Kiryl.)

The only places where that would be useful is m68k motorola, sparc32.

But in any case it has been heavily tested including on every single arch
listed with stress testing performed (I think I cover that in the cover
letter).

The changes are not controversial so I don't think that's a blocker, but
it'd be nice?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

