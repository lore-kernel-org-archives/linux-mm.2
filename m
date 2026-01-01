Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399DBEEB577
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96F4B6B0005; Wed, 31 Dec 2025 20:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D3A6B0089; Wed, 31 Dec 2025 20:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF2E6B008A; Wed, 31 Dec 2025 20:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9676B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:27:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFB0C5EBFB
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:27:19 +0000 (UTC)
X-FDA: 84281656998.15.F37706C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 343E440002
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:27:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=go9XllSI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767230838; a=rsa-sha256;
	cv=none;
	b=OzTc3bMeqi28AZrDzllu6uCmRRzT94fbTncOvbsqbQDbjaS33DsJo0+HE7uBoBK/1MJWyP
	2sx9MpzbCwL1PUVfwnsF3p2dMFs0HedzGSVzt9Tw6GdQVwbQVz90qZem0v9uLOyrNFaKb/
	Um3DjvAdF4AGrUq/haxwKy+d8nXIpcE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=go9XllSI;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767230838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIZ2+TTs0EEoEyjGKcpoyL5C5f8RhmuxTK2sG/mfXjE=;
	b=ZbFRRlI2YOtJ6WNcuwbqzzxjeeUc90DymeyxXEhnIDbK84swYALNaoZ/t8gn336REPu2PC
	ThUGMVCpAg6wxJ+CAWh7DQjHwYE23qj/1OWiXGSFrbzVds7cPykVfVzNkkc3ia7kJhIUBp
	TV/I7hf8sQKAnSyQD1+W89eDXbgBRds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3163160008;
	Thu,  1 Jan 2026 01:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7ACC113D0;
	Thu,  1 Jan 2026 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767230836;
	bh=kfzq7OmA115iWgJ760zWgcONuzBXEf0EdKCppmYMA+4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=go9XllSISBYzAOyojV4kRDLc0Hnz1rcUEPO57TcB9+qJSNx41b/AgCw3COmwnxqiT
	 j7mZyPb6MMMoWfBvYMRKbnSkqA9aNlPjK8qN3O6fQrDlWlCfoS7A/tERDwbL0qwoSr
	 LfQqAcLLX+Rrl87zP58OiVxJMBgmW31R6wiBayKc=
Date: Wed, 31 Dec 2025 17:27:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Alex Shi <alexs@kernel.org>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, Dinh
 Nguyen <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge
 Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
 <corbet@lwn.net>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Magnus Lindholm <linmag7@gmail.com>,
 Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Michal Simek <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, Pratyush
 Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, Russell
 King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, Suren
 Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily
 Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
Subject: Re: [PATCH 00/28] arch, mm: consolidate hugetlb early reservation
Message-Id: <20251231172714.a7fe44e856c14fdc8fe1cb43@linux-foundation.org>
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 343E440002
X-Rspamd-Server: rspam10
X-Stat-Signature: d6hdg8kqw759qxc3gibgoxf4ue6dpxqn
X-HE-Tag: 1767230838-900056
X-HE-Meta: U2FsdGVkX1/HqsFPIOV4TTD2sHKZrO3+qv8SPpi8Cn7D4ufTQHYIWv+sJp4ScTbUMH2zi2/iH+h4uLs0KKFiaMfNOpZqVTpa+Fb+/r37CJyMjeNkdbEYgNO7QYD+EtmLJ08xqG5SsBTi0sG8lFZF+DKnx0su1+EbTe0NvWe4VZ6oKHTN/SAefuiFBTma+PgguvloUIqfNp+xPlvND9fstSmTPkgjleK4bw8EWnTb80PJVYaKreMPIPMtL0P2n6oAMWJ2tObYvjcMRDRDxdU4BRhUsgQ9RU9eMfxWFwpVZZLU0hr5Zh0zsoYIscklLlJpDc1acT3bePAoUaEf4n+B43r9gAnsf6/x2u5Zcc+Er+YAWTkfm7DVM2hA5SSnzoKU01rTZ/qvPDGQUcIk39LyIIzsKo49mYWV7x0JMc2M3NI7mevIZrlPSJxZd+CglZCGY1AJ9pesdsck/j156sTGBOxAUVSnMgWmWEx1U8k/6+1rOTvhroncZwqEL+vtTHXSAULzdD2j449oaEOt3OVvEmcNpY7pzNWz+Dn7TuoOJOSjquw1IPnk8VKwj7yxtMAKklmIjOFdK3n/Bjgp7yTYQllYPpRMtc+QpJPVXIQNYmYtfqWzQWZTYwsoFBqFE+Qiy6rbTnuVLiXdihMKsq0ojI0Lg4bt2cdGyKYeUiWzSzIQ1jOvtaGagXpj5F1SZ1689gzYMpQ9qkhxiXXiOgZYAHoJmg8027SLu5SuvTreVijBGCiurd73F5d7mwUprBQfTSGpB5zKIkx0RACnwBmgj4WUtOyTJMFZvzAPPKWWm+1MPZDcJjcBPmAAfioI7b7Nqo1nAri004V1v+DInnf2nXNH9KNrf/iMmr5h43ZMBVDkoCqRqAJMZnfAYVw6gew+u8azz5VjZ0yjyftQRGouK5wcDkapW7pLvUcX8KcE5BI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Dec 2025 14:39:30 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> Order in which early memory reservation for hugetlb happens depends on
> architecture, on configuration options and on command line parameters.
> 
> Some architectures rely on the core MM to call hugetlb_bootmem_alloc()
> while others call it very early to allow pre-allocation of HVO-style
> vmemmap.
> 
> When hugetlb_cma is supported by an architecture it is initialized during
> setup_arch() and then later hugetlb_init code needs to understand did it
> happen or not.
> 
> To make everything consistent and unified, both reservation of hugetlb
> memory from bootmem and creation of CMA areas for hugetlb must be called
> from core MM initialization and it would have been a simple change.
> However, HVO-style pre-initialization ordering requirements slightly
> complicate things and for HVO pre-init to work sparse and memory map should
> be initialized after hugetlb reservations.
> 
> This required pulling out the call to free_area_init() out of setup_arch()
> path and moving it MM initialization and this is what the first 23 patches
> do.
> 
> These changes are deliberately split into per-arch patches that change how
> the zone limits are calculated for each architecture and the patches 22 and
> 23 just remove the calls to free_area_init() and sprase_init() from arch/*.
> 
> Patch 24 is a simple cleanup for MIPS.
> 
> Patches 25 and 26 actually consolidate hugetlb reservations and patches 27
> and 28 perform some aftermath cleanups.

Thanks for the diligence - this can't have been the most exciting thing
to work on!

> I tried to trim the distribution list and although it's still quite long
> if you feel that someone was wrongly excluded please add them back.

I'll add these to mm.git's mm-new branch for some testing.  I'll
suppress the usual email storm because 41 * 28 is a lot of emails ;)

