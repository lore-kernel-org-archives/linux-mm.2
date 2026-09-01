Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F38C624D7
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3D5D6B00CA; Tue,  1 Sep 2026 10:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF506B00D0; Tue,  1 Sep 2026 10:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDE46B00D5; Tue,  1 Sep 2026 10:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A189F6B00CA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:04:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10B301C1F3C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:04:01 +0000 (UTC)
X-FDA: 85165362282.27.3F4DC0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 636AE140014
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:03:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkHIyhIL;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utZgOAk3glT+w9jGyIL1e4+wDW3VgIywx5aDJ+IClBI=;
	b=cAk/mXiCCrXyQKXxIinXHIS23BR+Upllmk4HOcJbZ0v3kihabKxtE2kxF90fzrLzVc2bat
	NeZKNlHqh/PsvdgyUwJcuAFeFPTTgOM65+d9Jo0R6Dtx9UrRzSXkGMA4a53sfQB/Ch5GU0
	vVT/H8HPnqXDxlKwawBicZ2PGqTz4+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271439;
	b=fEly9ITW9fne8ObfU2KRIbt04p1PsIJyeJLbCBVDQMLldIR7/l1phV+3sXP8qNr2qKSEOG
	8qTAEYralhMgGCH+m33mBpiiLi44oRESAQASccfnwg9e92lFbZ7JpCKnPMvqQsX6OgJ3fV
	IZzTZDDRBOb122h9aAeoyk65N/lqeJ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkHIyhIL;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9425B60214;
	Tue,  1 Sep 2026 14:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9601A1F00A3E;
	Tue,  1 Sep 2026 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271438;
	bh=utZgOAk3glT+w9jGyIL1e4+wDW3VgIywx5aDJ+IClBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VkHIyhIL5RYsevDjObNKXZqn+SdY5WQb69y59u2HEPU8+koXsjF39lkchtgGfID2/
	 RRta8sEiyqrYHeGZADgvcepo/d6BCIy1rew63LXlaVY0Xupe7DXsdoMNSJ2LwTdz2t
	 9L5dRACEK20PlxkRCThhZUhUvCQOFVCbvgosbtCrmvTH2mK9HkGA5IIhEFa7R3t6KR
	 sYprPzYjwJdozsniM15JaMhNn3suHrmHgExLHHHmoISXD5OQ3cY25wcuADGpitpChH
	 /n/kgOyZ1a5axdohia++5dysGbeDD/F5NBdm+JhIfjt3j2SloNQlLySaTEevH9y1p5
	 qVSTayD4zeHWQ==
Date: Tue, 1 Sep 2026 15:03:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
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
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 11/12] mm: make userland page table freeing RCU-safe
Message-ID: <apbZwZHOkExAqOPA@gremlin>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-11-5456a81c8212@kernel.org>
 <apbSaL0YaQqtO9XB@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apbSaL0YaQqtO9XB@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 636AE140014
X-Stat-Signature: 6qaxxwo4nhch31fsetz44snx1cpy1jao
X-HE-Tag: 1788271439-668889
X-HE-Meta: U2FsdGVkX19jOV2EG4hIhMD2jB14CbI9+tZedjcX5g5zLRkpx6kB/3X0cUY+YxG3ywyi78YvU+0Nkqk+gbpee4KsDwms7BdHxwmPcdfT3MOw4b/FjaqJRzThIlWPYRWGXFbGM9lbH80Qv9GlrqGBv+b+zqFCrGNFBOgPTwDJfAQAWoAE96FhL5jfzXV6SFMpiJ6UQ9WzacrBhSjjqxwJROjrx2XrDJbrJM1mKwVZrDEdNMVATrZoG6Kpou4pONVZK/S+c5dbo+cwOLGj50ZMpPQ0KcZjjR6tNKFdFeDZ/saP3sjNgmAHvkypjlaC2ma4Brd1vVSfuga9ky1IWRQO5PpCMuuHzFc0t5YZM0lBVyyTGDe7Z1xwdhJgwwSwP9z6kbX1zmFKujgsGhGq0+SU3lMwshAAYffeNEVdNlCA2WvSQtQcbcMRLM4EeMfNgDAA4FBFeWhK5RD+BtgtytHfTChFXFybl1hSFwyJk1pzYye35ClKUHUIhqWWsgkOt/z/DxJo367zvGohCuKGCF7xvlrpW/Qk01CoWY9EZGmxi2G9ek1AlXVigP00Iy7lKMXppX2+KczL/JTByTC7DyDxclQxqyU0dfkutVGcjiJvtjU5sEuK4iNAHssqY5fWSTFZp2uo/nXJE6+jzh8U5ewI8q77Z/ESoyTBNTbAKeBmMsJKyyK/ElIO3iHk37+2yCeVV32Vx32cTRnQVwnjZhLpM6dA9j1bCDJEdD1rKIRGQMNaAsQwnyd7bsGetFhyMOo6zgw/B62K94qMydQhRLSzsfWJMJ38elGBHOhb3Zs8zPguvQSO4ny/F6oJKDTqMUJzHlbDrT84Hg6QqmXcRm0ZXyFWwjlIJq5YoRnmmxCi7wcJSb46o4McZx7R3A5Y8oAKGuthxMkbVl4oRxu3ZA0wiKstU24ccy182w8Cga3vnSa0NOUi4S26Kt44U8UCGmzw3HKfrHQeOWem67QqJbE
 WRbY5bZf
 BUTeXe+KfKIzKs1KIqjJxqnQavsvZ+Snd4O4tnWl2wt8lxmX2W0xeYLyneEUq+o2X0vcROrP8JJjLbOTzeA5N2q+tmIMP4cPSPmdDAUEtucqnNDfiWCDqqF62zCwxiFI1fW5QK6mAGinLQa9i95vWwXqU3vqMoxuhvAC31vrE0OqhuOZ5IqhWr+T/qD3Z3x/IUb5zyddVYwTXqea5Uf/FTjs6MnoNloMvkE9rQ+LVluBEJcCkkxEmrroyDhBPj3XZoDj+KszrHYBzbXMcL3txAjaKQtYAjFenY01V1lvlDjzfc6DOElfMeWIfadV7teG0O6tk0Kdggzd3N2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 02:33:14PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 12:01:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> > With this change in place the kernel policy is now that all page tables are
>
> s/all/userspace/ as subject implies?

Right yeah :) I hoped that the summary line would clarify that but can edit that
also.

>
> BTW, what is your take on kernel page tables? Do we want the same policy
> there. pagetable_free_kernel() is not RCU-safe as it is.

Yeah I think so too. I may follow up with a series to that effect also!

>
> > freed after an RCU grace period, and thus it is now safe to unconditionally
> > perform page table walks under RCU, safe in the knowledge that page tables
> > will not be freed underneath the walker.
>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

