Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF148C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DA76B0088; Wed, 23 Sep 2026 03:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756A96B0092; Wed, 23 Sep 2026 03:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AF26B0093; Wed, 23 Sep 2026 03:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33D456B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:04:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97F9D12046B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:04:51 +0000 (UTC)
X-FDA: 85244139582.16.0A5AF75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB878100003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:04:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8oyDQGw;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oz5tjSOW6xs6i9tD5UOCcck5s2CW+80N4Q8wcMKT5sM=;
	b=N4ioNsCI1tlamhd1asKdOPscXLeQSogvncr8SiH5dvzXq+Y+Zq5husC955GCAOZaebdIiI
	XBWy9WjSv/KDTJXTlrUQQxHvjIRHWCHc17C/yDs4GQojKuDXU59cbVkCMrBCmzXfjm0bJw
	qe5gTT9szr8C9nrxsZeweka8iaes0Ig=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8oyDQGw;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147090;
	b=18BOuVCYfQfGE4W6Do8G+gGT+HQSfXGSkjWw4mOWaRVfdnqYZYz45v0JQGynY3YmVanRN4
	YuIymS8OddQKAwKIZdjdKilEXBcaaJmG+PfnTbpywNasccyIAdXPj207EbdXKdbyjicVM5
	XDOl1egL68R25/5m99/GjBW0IE9O9DU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B89A8436CF;
	Wed, 23 Sep 2026 07:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0130B1F00893;
	Wed, 23 Sep 2026 07:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147088;
	bh=oz5tjSOW6xs6i9tD5UOCcck5s2CW+80N4Q8wcMKT5sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H8oyDQGwjdSkW3glHIqkT28nkitvMUMujDtTwYtl7NQTMOYKIQgyBXIBx/3pBcxQp
	 OQx1IfM7QGlBJelJ3xjxNUlH8jpNUFnb0na487Y1eI8TwCVG7O+g9eVm696P4c9Lkn
	 aCl/OQhO8JIKOOGyXPjrtfuqIh3bXqO1m3IPe7xySJze9zoxTzoj9eqsqbwfNB2PPf
	 KZLSxApcdSOpZNedomZsma7BVhAHXnP9rgV0Ce68rLQVaFKnh48hNKmYa63LQnOWUm
	 E0o5KeQEcNqrGDR/FBqK5/X0rFNwJJhXI+RvWEPR42lgPqvGO9/t+gXs/3Tt6R2T/G
	 9FzYEi/Z4AjuA==
Date: Wed, 23 Sep 2026 08:04:25 +0100
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
Message-ID: <arN3iaw7VDIA-bWf@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922160021.a2fc65d05d9b867a141e5457@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB878100003
X-Rspam-User: 
X-Stat-Signature: f9wj3dqjekjs71c8kiwrs1ibkd3jczod
X-HE-Tag: 1790147089-163707
X-HE-Meta: U2FsdGVkX1/fbtAsG3ZQupTbJcLjLTeYEruqPH7QgcSbRVlFrneUBdT0c96mOhxQG2AEgsvU0jhs1RTtT+Ywq2qI3shnsPFkC0ZLuzbsD/sy/BOpAGj7q2qvQz25SfxkwqtmRC06XWU7dfvhVGjsBV2CANEZTZax9XMUo76GdMm64/bAFPfoZiqYGmtOv0vCqi2ifJdKWavHoEuHx2c5yN/hrKtiRzHyxKF43qHY9Xg4qVtHi8DImU5hY6yH6kfdcMqyjMU4DGQS6si12+1IaNyPVog4ySPC8AiJ5sFmTB+faVQTsezqiLW5+r0EgrLWbhe2xQDUzfFdoIy4mU2PlJkbGooOIMnORc9Q+CZvveLMzHU3G1v0tYYCTlrob7xG7oMKWmYmNEvkTFBN2+m7vvcllHcY/OCawUvx9DKP8ZQDbuxBs/XnNjoMIqOs8irAWeBT72UuczC2BMKBjdAF/WdVG/ne6MT5vsGNu2GowqSWFHLzS/fXQnNEk71hYkbg/9RPv/c7RbjwAizyd0N3ltVDXe+hwOGZzxkum6hBAo1o7+rJkSDDxZPHjbPS+Dn2/tyLi20iw8YRWRE6k43Jzcc0q/I0foXlKn2u3RDM8VUZ2nNj0CfFlBMXHnGICcwV9T+WEI1Vqls+xy279rvtlGGsutX+DwubWw6wimVr/KqVNCIkCFARRExurcAtl+SuzGiZrvCX12RwQGIZHFRrFPKXlGu5ApyK8K7H78bQ5+t9fATdW1rl2vTGh+qLRZXZT2wy6L18iTePs5RIpF+D/k3qzOANh2z6zRpiTQvF+EcPPoUQyjdo0Xv+POpO+5FJ4lctvKNI3m2f71Hu2t9sBvYSFCyerd1fGQPuNKssPJy6YL8qQh/wcHqc0tvBaIGrxLUebOBPNdudhUrt5+r8u8ykF8hG5KeC/CIlZEDKXtyFtxVF05zl8t9V9eq3Wnnv/zzHQLkStpyzEEi8rPt
 egga78w/
 bRXImHPP1lWsRzrEvw7bFcjD165Z9IvD7FnnpGBf+f+1Hv4Lh4t8ekASyJ26RwJa414T+YcI+FnE/ZzI0tnc2llgx1lrkYET3aH3NGbba0TU9wWBCVa0PNz57ZTqB7XmJl/IiuRxv/+Wy1M7/hBRe+Bt2KkOnyC1G6mtAvr8FVIvPhoere+hyYI7E/zGrzzkULqPkduXrAtv3KVDB9ohZ8md8DtWSukB06wj9WDXG9ey45Rcd+Zw5GwilAOognsiZwWVywThIxFOXs6RBfy1thE0ZoOHsfkLAIAaTaF+IqaKMwBN/W62yqaRgMXtmZO88vUqRl2esVhFjQtrKSNJOF9TI4/KOJE+CYgXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 04:00:21PM -0700, Andrew Morton wrote:
> On Tue, 22 Sep 2026 16:35:31 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > The majority of architectures in the kernel defer page table freeing until
> > an RCU grace period has elapsed, this series converts all remaining
> > architectures to do so too and eliminates CONFIG_MMU_GATHER_RCU_TABLE_FREE
> > altogether.
> >
> > This is important because it enables safe lockless page table walking under
> > RCU alone.
>
> Do we have reason to believe that anyone is seeing any effects from
> their arch's failure to rcu-free the page tables?

We have reason to believe that it completely blocks other work like
scalable CoW :)

>
> This sounds like a rather long-standing wart, yes?

Not really, if you read the cover letter you can see the history of people
working on this, this is the final piece of the puzzle and despite the
rather muted reception this change is a big deal (TM).

>
> The patchset is thinly reviewed and mm.git is bursting at the seams
> again.  I'll play wait-and-see on this series.  Feel free to cluebat me
> if that's a bad call.

Err, Kiryl reviewed the entire series, I sent it in -rc1 of this cycle, and
it's been in -next forever?

Lance is reviewing now, presumably maybe David will review based on the
fact I updated on his feedback to _expand_ some functionality here.

So I'd argue this is contender for one of the top priority series for this
cycle, actually! [and is CRITICAL for my scalable CoW work, easily the most
important this cycle]

--
Cheers, Lorenzo

