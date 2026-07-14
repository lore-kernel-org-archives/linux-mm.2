Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3835EC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC976B00DD; Tue, 14 Jul 2026 11:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DAE6B00DE; Tue, 14 Jul 2026 11:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00E376B00E4; Tue, 14 Jul 2026 11:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C63026B00DD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:06:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA0FB1C03EF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:06:49 +0000 (UTC)
X-FDA: 84987709338.23.560D701
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9883018000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:06:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="lC/erCLu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="P 2Is429";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784041607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP6AUuW+BQfE8xE/ZQO072//wuV0eV2xjCAbIlgM31o=;
	b=4BpqAdB6tByl5MrbGdlkbsSFahcbHQrY/GJVA7THG/SUdAyB+BHGl/tGrH/BYGLC7HxCxl
	RdYFtmzQKEU/RHd81/5EL+NMO6QdomxfDvEBHA6DRgA5cOU7ujzXdCJ/xiwwiCSMOIFPT+
	msUi/dnO86FZohcHzyEb3APFnzLuEv0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="lC/erCLu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="P 2Is429";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784041607;
	b=4TxNETuvZqbogbYVX2UlkOqDHRwLKUS0j+6NRw6cIcInmaop/N6XrcZxjE5nRvM+KEn3lR
	K/32wYLZ7M4Q/Tk252BDrjx+EFLTlTIGcJ3A0WnZS7GTNXeSTapxW08QjK78vzHg9vZi+P
	iohaeM5KuMI4hTH6G+KRtR/2Ee9kW9g=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id BA8931300114;
	Tue, 14 Jul 2026 11:06:45 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Tue, 14 Jul 2026 11:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784041605;
	 x=1784048805; bh=ZP6AUuW+BQfE8xE/ZQO072//wuV0eV2xjCAbIlgM31o=; b=
	lC/erCLuPnd+85eOUScCipTGeubo7Y+8Nbyh1+57I+6xXdBoDdSehuLIxsmh2HLO
	Gfcr4H+yYUUF0gWhQcZ39olrjXYIB3EH4aVBfx4VLGDeFqPS72zMb3H9d90uNX8k
	zz8lXgdrCqdf/7AuatUtBNhm0NL79Q1d0iqxm33NkPMCzBYPirlWDhMeJRFXXN5v
	savQ552I+f/GXPtvOSZB+KVyiqYz332iX+8b0PkX4coG07s6fH9t6AWiZ70uapNZ
	E3x6bDNKSYPDwKx2XpxIJlbzgz9jNvejiFvyhC2KGvA+lXfnCC/cpKic+23jAvRQ
	d4KWFAzM0IHEpWv+Z06qxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784041605; x=
	1784048805; bh=ZP6AUuW+BQfE8xE/ZQO072//wuV0eV2xjCAbIlgM31o=; b=P
	2Is4296V2D7bPxP4OfD/5D7Kq9QzzJWaEr2ZS8h9n1FC5h3gc44hIRW168MQ1NKz
	cAX3gEU6FcRAtTLUc6oFd1xVk5w33G4tSYXpOUZaBMr+lY0bW+TJ7C1aN/CojXCl
	uLFpR/BAZQwAS/0a6/zl3MT/zyBZ9iI7TSJcDmJxKoRdFW1TzulzSOk/ll4APQKg
	2/yVj7oKtP4EzYL5Un8JK+7aUS2b1iUDiRihfqd39uf1Dt5umjvjdzGgl5BlSKwt
	Y17YDnkqxpArMKtN5T4agfhMpGGh4/XPeBxsyf2+9SU3pPGAgVLD+9kdXmaWjyQI
	7MegV7M/Xa/xRyYanIHKQ==
X-ME-Sender: <xms:gFBWan6SLvS3G1UsqlWzYK9NZyrILu5dTvIg6j8F9C2Dp6C2apFE_Q>
    <xme:gFBWantnKPt4qi5xW2UcG8HU48rywcib7A0xqqjYBBLCWgpkTK5lQDzkq5UhwuSwc
    ugK3br9U6iXyjJ8yVmn2eF1M9-cdv1RQGKVcIv4Kc6TME5SIArjjPC0>
X-ME-Proxy-Cause: dmFkZTGcioZwMwHlgAe1l0bPf8gvE+LKXir3CyHGrFeNW0WDZMIbkar/MIvcDBI3bdb4tn
    TLcOIvj6s5d0LpuhCDRNM9/43oNLyRhEeFYvBVQIhT0xLYynAB1xtO2cewFtb0t6CtzMjX
    xv1R0eBlDof4dBuQ5arMoRTqIZurltnigWrb9ac9eD2HPc/CttnLB9ggEMsrZEqWcCtq83
    6xwm7tIMawSMI0+OL6ui9SlZUBVzg8A1tzzj1Eqbu9g0mrqHl8ho3B9MTaQrnrFpmlPySP
    ctR1qy06L92hBLrpFsYUroefkz63x5l2nxv5qD0VrEvqmjLSOdjN4ImPYaXL/oGoYDNFBs
    3UNDkt74/5VfVa1u/SRQoGn04/4YUxYH/2UmQve3eTutRLopyxE6b8vSHZpEdNYm7mnD7B
    QhnZdEbvTJwC09NdFzQNBKzSxXuA83892lZ7HcL5jlQbYL+PCaxgrFtpOX1Z45KxrBxdz7
    NZiMxfOQQCOlRCa4qxgVD75cBKQI6J6n/qgr0757bn5MDLpvJWetIhWjcAuRHWI9FtpI0X
    1if7Q0uLuUrlWj+WFZvcExqXcYRs1Kz740TGA0BdEZF7hqs1rjgdtu8xuvgNXvL+SwQPz5
    OU+Kp9UGoHJCfh7v41OFx8T3SbkSgGNxkoPcfJimECrLvSmlSsaAWXUENfpA
X-ME-Proxy: <xmx:gFBWahIKrd90bCy2BcNxHfqZqnLnwC9oY2PrX2tkHAkaw3GmI0tD4w>
    <xmx:gFBWah1d4AZS7FaSWpZ_5751gscO9pSn7kUXTTB3b8vX3oa2TeVofA>
    <xmx:gFBWahmWXLnLFgDv9FiNWPkQT70pF1EJmESlHFwlKW4Gk6qxm51d1g>
    <xmx:gFBWamKLBVtdBxN7sP76KlPB3WPpuMmDrdTYCQ4M2cEO5OrFLUC3hg>
    <xmx:hVBWat80Gj-HkinrJhk1p2kSHhh3n5oiP0ZcN5OwvSFz3WbEorTmtDKp>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A3DA81820082; Tue, 14 Jul 2026 11:06:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ASU80-mPZ9gg
Date: Tue, 14 Jul 2026 17:06:00 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Laight" <david.laight.linux@gmail.com>
Cc: "Pedro Falcato" <pfalcato@suse.de>, "Yeoreum Yun" <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com,
 "linux-csky@vger.kernel.org" <linux-csky@vger.kernel.org>,
 linux-m68k@lists.linux-m68k.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Russell King" <linux@armlinux.org.uk>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Ankur Arora" <ankur.a.arora@oracle.com>,
 "Mike Rapoport" <rppt@kernel.org>, "Magnus Lindholm" <linmag7@gmail.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Klara Modin" <klarasmodin@gmail.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 "Kirill A. Shutemov" <kas@kernel.org>, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Rohan McLure" <rmclure@linux.ibm.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Tejun Heo" <tj@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Anup Patel" <anup@brainfault.org>, atish.patra@linux.dev,
 "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Andy Lutomirski" <luto@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, qi.zheng@linux.dev,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Dmitry Vyukov" <dvyukov@google.com>,
 "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Yang Shi" <yang@os.amperecomputing.com>, chaitanyas.prakash@arm.com,
 "Ard Biesheuvel" <ardb@kernel.org>, guoren <guoren@kernel.org>,
 yang.li85200@gmail.com, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Dinh Nguyen" <dinguyen@kernel.org>,
 "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 "Vivian Wang" <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech,
 "Muchun Song" <muchun.song@linux.dev>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 "Nam Cao" <namcao@linutronix.de>, "Pavel Machek" <pavel@kernel.org>,
 djbw@kernel.org, yu-cheng.yu@intel.com,
 "Baolu Lu" <baolu.lu@linux.intel.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Coiby Xu" <coxu@redhat.com>, "Andreas Larsson" <andreas@gaisler.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Stafford Horne" <shorne@gmail.com>, "Jonas Bonn" <jonas@southpole.se>,
 "Stefan Kristiansson" <stefan.kristiansson@saunalahti.fi>
Message-Id: <aceb8582-bafa-41b3-8f56-77fec89a4d90@app.fastmail.com>
In-Reply-To: <20260714143450.61a94085@pumpkin>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com> <alYL7B0HAvmLVHGU@pedro-suse>
 <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
 <20260714143450.61a94085@pumpkin>
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6fhezsjn9naoqiy333z8zjcga1p7wehx
X-Rspamd-Queue-Id: 9883018000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784041607-722045
X-HE-Meta: U2FsdGVkX18VpgNFvfv/eS2SNcMLdA/2ZQyqtFnZiZi6BQDcG3WVqUUNoH2nNiwO5l7xzyT81HZKN7TCnPjGEqNT+NUBoaWZrjHcbGNwqhuYH+VoXzlTbjvJdr2hwqNHJVK87KUTTR5Y65U5WIoqNX7YnTWiYIQh9Wl7SDhTmrlBh1ohYgJtsE8Ukk9Hdi+CWxVjn2PeKEuaZnTCS8Er4lwGRKeONgN+IExM/B0IQSskYOwC8KFh1gDitPWHiedQN6e9A97QRuLUDAJZ9FbTXVsRKL/JhkCoQ7T4KCTo9MJpreFV2Z7td4PvM1jB2jM8XvGEF3SfFcTb7Dkn10ABFbhlDrDIi021DSLE2PHpZO3rurI1NTz180IYdP5fAYBF8PqHMMPB8q0L9EVkjC9Pq/oCzZ7gbDJ0II72sxq6JDH6097teJ7gxTth/7rR7IMfi8myYduzOz+A5k2cfHyPjy775mr9s1zjNRbswAzgQi2CODb4LFdLUH6NhFVS1kAOkxhI7CFI2J1rY67Zf2+IwWl4I2P7gvGAlJSsdRBAFnS9vL4laEx5vR8POvHijvvWxXKELWYTLylV04PfCqv03xt1qTwqBX5Iu7CzPqvVoiajb5xU00V1kE4IW2RHfnRqBjNLXvBDc0n/fZaEqa8jYrT/3PeoX/I+8u+kYRBQZ1IR0g8NPHuH0Q6fAsxK69tAGjCK0SkUZBLO1EeTpTAhkfZXGARWSALjOOnWGjaXDFAVSEKdTbF6m3eTSyD3cG/OdtpEMM2PFxyDLq0prW/B9Dm6SQIupLEbJ/LmQav0pdd99PTx4Q2+lJezDXlLagKh3LG2boNJ83zQa6EHa+o5oDYnWKgqzDAu8LoHKGV5Hnj2jpYznWmKxOEx7Hf97vExRJ/UIBuIScxrjRCumSrqnMaTzb+fkzVM4zn1NLU/cKShNLqlkrUzPWxd4mnRA6dPGMfErNhmeGtcHyqxY2s
 +TDRtne3
 HMfd5qjGJGHLui67QFq4TnY9zfY4LJuKT0IIyvH9F6n63I+5peA/EFWiBXQhE/XZIK7WFxmrdCxSdXDbqTFGroiet5TifWX8sMpkI4z1wde5EtwZYKTQz+o8dTlHqVtkmdHrmtW/TyZugUnAc98/FXOUuEBrRMxk58eJh4g9SKFQMZCCrwlNDsap2HhsDzG4jGI8NhQrVna/9eFZjYLoPaG9k/uoJMij3HPwFoNmSSEmeMiBYx6oYNf6245TqZF5NXt8STEn+MPs5eiboL+gomOVgwWtizKchXCPIt5lENYS/i1CGoCmweAOGimWQqB/8siRlsxF2wrgbSkTy+7stVfiuudm+xk7eLji7joUO5fsM7UfAc3ONOy9qJ6xdGBkg8lD8/MGVLLDRNZ12xJQQfv0RjEkEHq9W+uKwgmrnZWXl5abSM953jXkEIhstod7SURWC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026, at 15:34, David Laight wrote:
> On Tue, 14 Jul 2026 13:55:18 +0200
> "Arnd Bergmann" <arnd@arndb.de> wrote:
>> > I see the compiler has an awkward time returning a u64 struct (see
>> > https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
>> > get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
>> > purposefully toggling it on for testing from time to time.  
>> 
>> As far as I can tell, the #ifdef was originally in i386 and
>> got copied to all other architectures at the time, but was
>> removed in linux-2.3.23 from the original copy when CONFIG_X86_PAE
>> was introduced.
>
> For x86-32 the makefiles request 64bit structures be returned in registers
> (at the same place regparm=3 is set - probably added at the same time
> between 2.4 and 2.6).
>
> Note that arm32 can will return a 32bit struct in a register and
> arm64 will return a 128bit struct in two registers.
>
> The only problem is returning a 64bit struct in 32bit mode.
>
> I'm sure this code is arm64 only.

The file we are talking about is arch/arm/include/asm/pgtable-2level-types.h,
which is definitely 32-bit only and force a 64-bit struct return
on the stack.

I checked some trivial tests that show that arm-linux-gnueabihf-gcc-16
also still produces badly optimized object code with structures
passed by value, and will spill those to the stack for no apparent
reason. clang handles those just fine as a pair of registers.

For the 2-level page table, this only concerns pgd_t, which is
rarely passed around or returned by value. The 3-level page
table has a 64-bit pte_t, which means we probably won't
want STRICT_MM_TYPECHECKS there.

      Arnd

