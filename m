Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD3EC2A076
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 20:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBA06B009F; Sun,  4 Jan 2026 15:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A7F6B00A3; Sun,  4 Jan 2026 15:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD4E6B00A4; Sun,  4 Jan 2026 15:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7C936B00A2
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 15:58:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AB821414BC
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 20:58:18 +0000 (UTC)
X-FDA: 84295494276.13.5CFCD02
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf17.hostedemail.com (Postfix) with ESMTP id 074BC40004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 20:58:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=PQx51yTY;
	spf=none (imf17.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767560296;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1gCbeyIrlCt5J2/Bjwg6Lr/ehCAIvx4DrMKPGr0mIk=;
	b=pJjPSXXFoyMNXLvBaaqfNJH1yOCqpEdxMRMTrMg2+Z+z95/lu8FigpzluiUNZoymNywKLO
	9N9DbBXX46ylJlMuTznn22eI9RaNEn+sndh7R8byl30X7JOWJdaRK/sVOlgcJWhAnXXnei
	FcExQ5zuMCtMQeDSniQq3OoMPlnvj5Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=PQx51yTY;
	spf=none (imf17.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767560296; a=rsa-sha256;
	cv=none;
	b=cZ6L+kTQ45bbX/0K/2tMSbdYLBHKNbbjlqhI7LB+iXQGyKWW9WEE8yywa64bOPIzbXB8oX
	Wh2kCjRO8KatDCzXwU6Lpwvi76czUpA9yPGrlx2C9T9IWJDLsh3EYBIgjfFyw1do+8YdyA
	Ga99oRr1dPLM1IvoTMEwons6wRmbEkw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=I1gCbeyIrlCt5J2/Bjwg6Lr/ehCAIvx4DrMKPGr0mIk=; b=PQx51yTYkgAaIUXq0xW7qPDXV/
	l2XTuAum3C4YTdjh59Zd9jjet7ae799URg+ZV8rmTkWl+kVHfkxUYw1s/dRjs9aTXD7D6Ho4syQaF
	UUWur1xKtbiRo01UTGcAE17bVwa7Q1raKrI86aomWrm1nziVTW376kzGUJt7sSCvBg/iJuo8+kzDd
	nyMzCE7bdEmvI/HMHy4otFSPHCGqcEajEQ2/jkcO2mu5bn1Ymv/9fmd0dXa7MO9wYyaIe2D76FfaF
	n5lZTtrjJRF5D9eduOTkj4eWKLscCmoWno8MdEQ6ghyWUX2t1zONW89YiFsB5z/4C0opIIXPgMGiC
	0kKrZFQA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60852)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vcV9l-000000007Jz-1ZeD;
	Sun, 04 Jan 2026 20:56:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vcV9Z-000000007Df-1tyX;
	Sun, 04 Jan 2026 20:56:45 +0000
Date: Sun, 4 Jan 2026 20:56:45 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Mike Rapoport <rppt@kernel.org>
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
Message-ID: <aVrUDeSkqqY9ZCtS@shell.armlinux.org.uk>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-23-rppt@kernel.org>
 <aVhN2NgQEKe0yzva@soda.int.kasm.eu>
 <aVll339wim7dCIaQ@kernel.org>
 <aVlwOyicOLPB9SOa@parmesan.int.kasm.eu>
 <aVpWpLV4Dut5Muo2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVpWpLV4Dut5Muo2@kernel.org>
X-Stat-Signature: csk3peu3dyj6wa91ndrc9epbxiysy7sw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 074BC40004
X-HE-Tag: 1767560295-926599
X-HE-Meta: U2FsdGVkX1/u++585upY7E5kjs+trvCcQt9JOFmRf1zvisgXAe26OsrF5JZbe6/sYWgYM8eRhZdAN5Y0SQyIlY4GHlTTU70AV49Uq6dXm2qKoFH+BZNORFWxYA2y9q0iG9SBmI5wn8onWzqHarchvz2aBsLLNQY3cUypp9xqbpmtikydZAVFBzrMSJ18yVkzGFqgB4exYapXztlQoCoAyD/ekZRTXiPpWLh1+blHFdEYHOOX19UlFNT4okCtDRTc4J4kvaZEkn8/bTpw6Z22wiQ2lIRu6FoywsooEwgHdC3JvlceBPW4uMwToyMpnb3CmGI+umOZfk9E/V7E5KiuwonvmUtn58l6aqViad2MtS7EvRzAgyQsJHQk+Wps4CujiRXqmVBd9Wk+dfV8oJA0aRNwcOzRTWkerBztlkEqPGns294kOCxOLr3SQQlOhKywyTS6MZmmU1MMnGSh0r1moYC35t6WkT04H+GTCEwbtkamuEZZoBwUG9SE78cns+DWP0afixwqKq8RBG+9lWjE7rFo5G9QpPvTIx4VBuxbNxBEaTwsxk7jEiJETmyyX1/dB7hH1lpzygqrg3gNsLAWVB9ORzZHtQ2fFR1RQjb6QesMO687zJjxKlyW1BTFnTzpRQmoQVRJklCn7cQYKgcdRRJUxnbVyw0TvCSSjA+6TZfXVAY4vrOc+HC66f9ubfwXSS0PmXi//+ud7EQFUL6NI6V2LBqk1XSR8B+jHyZ9fss6UB7ZiKzISQ0jmoTVhL8+yuJeYYXoZmVbncmwB+9Jyyh4vP+UFjeXzwxX6UYZM3g1xy0EztBLxrrHApDAMR5Of6MfNS7pbgFIjJCfbnh9Xr80sDuemXE+rZMxM6mO/JtHB9ySZA0CZLF2oFj3veaYV9pc781dNQqgfJzy6xptW76xp0gRkjxJX+z45dJiHUtx99WElCwP2hakjk8stU9teWlg3lF3GIO35A4xVwm
 +yp6KYSo
 VEJPe25Bvh3eTvWIM8tdd0rqGfDRgITG/n3JT+YYBbsLWlx8TvC6HGURG//Cstm6TGwfQJO4x7lrdhqHibsPW3SWEyRl3hlFG25Sj0NBI2c1GrC0nC2unz+ClkK18LIrSfysSpFBa3P3uJkRRMxMmmE6YDXaDNrCARP4LQ7VGen+hCk1Mvsk5NwCdZxQkdWynXMQ0FP6RwiwK971Xn3CpyRDxsUwPM3aWAXF4x6Et2q+zP0YNwuh+t9vLiXwa3qIiCnNrN+bIxfefO/0HbAk5IZfst6tHzQFOS6OYhZOCb2UijVt8/dfPW64/Gw6trOgjfeij/AUHq9AK2h4Fi4Sn3dIuq1UThe8wHH2ozNjZ7N9Pc+WW5+maxBNwYjL3xDXpf355hoQLcg7vBW5AZ5GFqRqLzzCc4xCdKTBaIjr5/bwyR4Bqb8MN7A8NZsT4GCGB687JVDxBngmm5IenCTQUtd7Qicgb0Wt8PBQD95iJe+5SAIfY1Jw4EvEKp2eq1jZCDC8tMOQ2oMJolSRKeb2HG/m+Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 02:01:40PM +0200, Mike Rapoport wrote:
> From 35d016bbf5da7c08cc5c5547c85558fc50cb63aa Mon Sep 17 00:00:00 2001
> From: Klara Modin <klarasmodin@gmail.com>
> Date: Sat, 3 Jan 2026 20:40:09 +0200
> Subject: [PATCH] arm: make initialization of zero page independent of the
>  memory map
> 
> Unlike most architectures, arm keeps a struct page pointer to the
> empty_zero_page and to initialize it requires conversion of a virtual
> address to page which makes it necessary to have memory map initialized
> before creating the empty_zero_page.
> 
> Make empty_zero_page a stataic array in BSS to decouple it's
> initialization from the initialization of the memory map.

I see you haven't considered _why_ ARM does this.

You are getting rid of the flush_dcache_page() call, which ensures
that the zeroed contents of the page are pushed out of the cache
into memory. This is necessary.

BSS is very similar. It's memset() during the kernel boot _after_
the caches are enabled. Without an explicit flush, nothing
guarantees that those writes will be visible to userspace.

To me, this seems like a bad idea, which will cause userspace to
break.

We need to call flush_dcache_page(), and _that_ requires a struct
page.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

