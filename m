Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44156C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 11:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199746B0088; Wed, 23 Sep 2026 07:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149D96B008A; Wed, 23 Sep 2026 07:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039496B0092; Wed, 23 Sep 2026 07:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11B76B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:49:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E79C51C349E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:49:13 +0000 (UTC)
X-FDA: 85244856186.19.CC6ED05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C3EA100003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:49:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0HspulT;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790164152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z18U4qa6LbbRW6yI1ebVsuAYdmDir8PYv46mTQmvxDM=;
	b=0x/lm/uwez6shMopFaN3hMsjchdsIrfDBGKYx6JyMfzLlwnDFiHNHsVQScEsHb5OvamK3D
	YCGzzeupW/S+4bMTfoEgDxe+q4r0exHXCGE9aK/jAzGuIdg4APe0stQDhLOQHSGctEdU0q
	ZvuSCNt+tL8U/EtYoMLKfVGX0aohP2g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0HspulT;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790164152;
	b=ghlJsdY0MBmzXr0nOqE7kiriyC/aypP1GoZn2FTdl2BMZzqP/chz5afwlSATr8viftg4im
	Ar7DZXpOVU5Tam8xwupCo2q8/oabGXiggs78ZfiUwg4TiN62cBqBAq3PJMOFIYYhcoWi7b
	c4WQZA7qPwTTubOYMBJefgAiIedYqJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15EAD40A5F;
	Wed, 23 Sep 2026 11:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B941F000FF;
	Wed, 23 Sep 2026 11:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790164151;
	bh=Z18U4qa6LbbRW6yI1ebVsuAYdmDir8PYv46mTQmvxDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D0HspulTyBdCQX+9DDqdK27FApcPCCvh0cfa5A2rbZhHewxbqqnqFfAC7nocs+kP2
	 0mvVh8QH9qXFX6+3roRxbIQueQ3TPhzi292qpq9D3xRZZ5wrxeyaLz+2QvciRn8RF2
	 FVQ8S8jycXpuDyJ9rlAicpdmH0A4zO0K41QTIIgv5uUQwQu8Cyh3/fZ149W1dOnWWV
	 yYYskNeHf77UMMMQLOJF6vyT4QfBuWnpw9G3F145FYd/VJTxiJBTwTSUUZpHmcLZ58
	 JQgdeq38PegQ/KA2Ovq2zM3pjhtITbOaI5GbiIAo2djGnpsU4gEkvZ674V/u+BfhWb
	 OSemwb5O1SYug==
Date: Wed, 23 Sep 2026 12:48:53 +0100
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
Subject: Re: [PATCH v4 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <arO7lSy71meks_sW@gremlin>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
 <20260922-rcu-pagetable-freeing-v4-11-fe1ad1f1e303@kernel.org>
 <72d1548a-a4ee-4832-b2ab-4bc82f1933f8@kernel.org>
 <arOWZCeV8FrkAvhK@gremlin>
 <802d3999-95fe-4a09-89b4-d01b60f8e963@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <802d3999-95fe-4a09-89b4-d01b60f8e963@kernel.org>
X-Stat-Signature: mri61f9f71b3hprc4wst66s6fs8kgngh
X-Rspamd-Queue-Id: 4C3EA100003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790164152-59064
X-HE-Meta: U2FsdGVkX1+I2qOdCYpwkFb5ub6FKqMaaR432XcARRHev7UunyDoy2+HHRJYTy8QQ+5kZmH2lcr/DFLr7+p27K8eMF/Ymd0AezIxnZoCh3Zgg/y1+2tPeByiBGhK3G3nfLX2dZ8pct73AOJfo3NpNmfQ7+xAGexUF6iZIz1sf5CvwC9TB2VSlL8zuKxSyrSl36tqnT+OM80aeBmTp/oZ2yxu8JZtkvS64bivg4Wo9dyLShhKaeEzmP8Mxl6l63wCL/Pme5NgAzf6BuSSDjqIWoUoTdP5AlnGi5zStW84ihbRNMIDWX60MMk26z3qLCzN23fnInhL3dTzZzmEfB22pYR+th0rdIT8+D2ZUCYYWJZM4fBq1U4f/+5dAc6Hddo7QY4ZSW/W71i1XcCbovpWJNeI4cq5dOV898AnZj4DyGtjPwnyZLuf3KDZKWtglLSkZtFCZq0klTUb8uxKxae+JMPh0PVd35h8+sEtsDCgExF9i4RJFUl08ih4Hc8ceIGx0MrLAbUQWzkUfna/4nWIDUZB+6jyjiDzfkTxYil6qpN8+kgD/49XnYvMsfVNPuvHHd0A0VGEoYOoMb1h+aPOuRZiZDqBJWiPDyhg2GzCwH+Z7I80TaUAd7lPYw5s96UX7xVabNK/1dbHcoJCufY4+4A1XKQKasBqofPXtztAqMl33GCmgPDMgtILCiqYNhKARI1/ICXpgn6FttIdQMiFUIYbTtZFDbovixFEZsbKSOTWdyrJmO4pegxkeCUkVDDQvXO2/7wYEGnE4WjdH0/03deNHpBwnxTSjsX6s8UKYKkA3C6seHbt+Y6p72EOlGo289XcgkHfGRlzdM8DGg/sqa7WEG8yKsqLdExa6ISGae3mPGoF/BpkykkvkhDy2PSH2HilIAFfCN6rcOT8zacd5a5VOeE9/gjzF9RzsRvksEWnZLCJOS0aZY54ohmF883bCqB8v96ZQ8AkEeaOxOS
 8iNM5iSM
 NK1+4JKa0/J3gO+p3bcafAR0HlwxZov8vkkAlO4NLqHNTy4Hm5LqfgMeBDANlP3TRSSJxczpAV1KNj0JOLsZUYZct+7kJh/E2FjD/vtPRvyyoDsJuzUu0M9t9oRfXQz9qG3ewV3KY3DQr3cOd1CYWl8X75X4jP/wSSdeRnbqaDLbLic8TofNXQwbAwFh1ijryK/1d2j1CZz9nFaBQazCV0/oNGTecG/aV9LiVFk5ZYoh7R+a0QEB+8AeOdSEUx6qZXODhlHlbgxkaCL2gtv5/jqno7pYrxrJOd40OmvsKDwKZhCloHz2ex11xXaZANxFWumf5b//4e2Uo8l0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:13:36AM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 11:06, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 23, 2026 at 11:04:17AM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/22/26 17:35, Lorenzo Stoakes (ARM) wrote:
> >>
> >> The patch subject confused me at first: that's not what the patch is doing, no?
> >> Previous patches did that, and now you're just removing the leftovers?
> >>
> >> Maybe I'm missing something that this patch does along the lines of teaching the
> >> code to be RCU-safe.
> >
> > It is the final piece that makes that the case, so I think it's OK to allow
> > oneself a nice subject line? No? :)
>
> Just took me longer to figure out if I am missing something important.
>
> E.g.,
>
> 	"mm: remove unused RCU-unsafe user page table freeing"
>
> would have been clearer to me. Anyhow, just stumbled over it, I don't care too much.

Compromise on:

mm: now userland pgtable freeing is safe, remove unused bits

?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

