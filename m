Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE47C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339DA6B0092; Tue, 14 Jul 2026 09:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA376B0096; Tue, 14 Jul 2026 09:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4F86B0099; Tue, 14 Jul 2026 09:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E32896B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:34:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71269140343
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:34:57 +0000 (UTC)
X-FDA: 84987477834.25.BFEB9B2
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8C89FC0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:34:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P1uSVwJ2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784036095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1tfMkiBqW2Fu1p0sa+0Qy+YQWqKnxqq1+cNEQovCl0=;
	b=b0fagvZFnn3uQokARQ84k/Bz1lA/pzumQUg/EXmaxvgH0xq7T4ZpFyLD0UXCncx8PILLjH
	QtPvwmduZpffil4fLsq4xjGMOdqYJcWs85fuech/vFte9ku8XSaGQEarYiHAegYHqTUPXf
	fKNvNX/T0qDe0GKggUn2WrjI6dWdrH8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P1uSVwJ2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784036095;
	b=rcJZBKcVado062QZeJtq6KBcGbrTyDwNedytL2RoUPi3uNvNRyVjoL2OKhiz138JlDbIs9
	40LI7i5NqOEOl8KiDaIx4OR43MOGzX8WOpiBDfUQUEXFNRon3aKzaiKi0OOj8pFBzWjTai
	KNwUCyfki9OZkGfBpmUF9zEuvxl/nSk=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47d70879764so2812192f8f.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784036094; x=1784640894; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1tfMkiBqW2Fu1p0sa+0Qy+YQWqKnxqq1+cNEQovCl0=;
        b=P1uSVwJ2aHQnat5Jmg7GQvKLEQT2cI97gBc0SaCI8eRDmjFnPIbpj4kYdXgZbcPGoC
         IdbBV3M7Z85fkVIgqALF/CDCdpML3jTCqSFuecjk5nE33EhEeJtg09eA5iHSGHLHH2rn
         sxDB2OOvRP6gy4e5YX2ikMaPTj8HWRW0KKoqExCUenMwTMedl7K/0Q2KgemErVFHcmSv
         P1zQQdd7i8CP3cNJ0qg7c8pJV94tIxdnPe/YMIKpbkedilqi26lr6P8nW7feoymklcx8
         5+7XAX6r4cYxskjW9Abnus+c98OlOp/y5zVOCt8VVH9VuIZF2iX9Q4sIJ74nwBtfmGnC
         XWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784036094; x=1784640894;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1tfMkiBqW2Fu1p0sa+0Qy+YQWqKnxqq1+cNEQovCl0=;
        b=ga9SvZMDqcYU3EfjuFr1ouHb6AHNnoYIIsFknXEG19CH+egGAACGpWFHgrCx14/wup
         NvAACnY2YErEzbN6cg6Fx1b/uhoh9O2mskFKAgDnMY3ynjgZ6b0tqrKVoxYw2hMLHfJR
         jj+lu1YG7x5nlnUfpKpUGJ6MwwPQYTvyymHepsrgu/zgsZsL4u9mXe0aO3LvCZvhmrev
         YsI90ea+0EfWruAe8+yj1RwujxQORoyEjMQc83dP8Zr0oaM7XNB3Z1sH5nOSrNcXKpze
         gNGL489EHVgLgk6Fi5gZ9iXeBhhTWequd+17EDcQEDts4W2hCsiYx9XqJAzAKJmtpjTV
         IqoQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/mRuvfHz2u5nMT9g1rU4cvDcZfrXGT7/PgpY3nnBwEy/jygLWztrPOgZxNdGC1a63T87OkYixSQ==@kvack.org
X-Gm-Message-State: AOJu0YwqhP4Um1rPLwACNcL1gvBNgdUo/FJocNTN1XoqXN9woVMl2X4/
	05n9LC7VaReny3v7R79Nrh0C6h9vmipb+mSM5nGNpTzim3q+AmZ6MbLr
X-Gm-Gg: AfdE7cnXFny/F/YZyugGSeA4hi4F5PaeKmUOa6QzRiPKTQoRFnm0jrXhwyRciXpF4Xy
	RTJ07oPNzMCLrr9/PQ7gaLSFlo/a6wG4h8nvcojGy8tHtGsUYFBU3BsoG6bN0DQL+3kARLp0ve9
	lJ2v/IdE48USzyx1CBC+acou3+8EhmpBJO/TRucRkp0GJtDSUXJTKdF3BT6Zkm6USTp7ACo3T6t
	FWzoud1jx1h3P2ooLQZcTHx1qU0c2BYBYmUTtlRozMvXw10iXsmcQElGYCBJYnUC0nmArUdw4yY
	PAq41n26nllOQvlogpigcxZLBN0K6zGyUhO0lWkTxQu6fEUCRfBYS1I9+WAd9GaDA2IQp35b406
	/xODXCwoFmn966YDJCQm/yz0IRsTDcfHEr5MUp86eb4qHrTSvBApvHQKGwCTfjqYzw5x5xp9fZa
	dNfK7isxLWa6zLwzyoGPoMD0BaxfhI0UNGOqZkbVE0sRj9XgKga7h1qpIAH4Hm
X-Received: by 2002:a05:6000:26c7:b0:47d:f441:5f93 with SMTP id ffacd0b85a97d-47f2dcc02eemr15207624f8f.25.1784036093714;
        Tue, 14 Jul 2026 06:34:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a63esm8687695f8f.9.2026.07.14.06.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 06:34:52 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:34:50 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Pedro Falcato" <pfalcato@suse.de>, "Yeoreum Yun" <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, Linux-Arch
 <linux-arch@vger.kernel.org>, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, "linux-csky@vger.kernel.org"
 <linux-csky@vger.kernel.org>, linux-m68k@lists.linux-m68k.org,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>, "David
 Hildenbrand (Red Hat)" <david@kernel.org>, "Russell King"
 <linux@armlinux.org.uk>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Ankur Arora" <ankur.a.arora@oracle.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Magnus Lindholm" <linmag7@gmail.com>, "Christophe
 Leroy" <chleroy@kernel.org>, "Klara Modin" <klarasmodin@gmail.com>, "Huacai
 Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>, "Kirill
 A. Shutemov" <kas@kernel.org>, zhangtianyang@loongson.cn, wangyuli@aosc.io,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Rohan McLure" <rmclure@linux.ibm.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Tejun Heo" <tj@kernel.org>, "Kevin
 Brodsky" <kevin.brodsky@arm.com>, "Anup Patel" <anup@brainfault.org>,
 atish.patra@linux.dev, "Paul Walmsley" <pjw@kernel.org>, "Palmer Dabbelt"
 <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>, "Alexandre
 Ghiti" <alex@ghiti.fr>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>,
 qi.zheng@linux.dev, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui Song"
 <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Anshuman Khandual"
 <anshuman.khandual@arm.com>, "Yang Shi" <yang@os.amperecomputing.com>,
 chaitanyas.prakash@arm.com, "Ard Biesheuvel" <ardb@kernel.org>, guoren
 <guoren@kernel.org>, yang.li85200@gmail.com, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Dinh Nguyen" <dinguyen@kernel.org>,
 "schuster.simon@siemens-energy.com" <schuster.simon@siemens-energy.com>,
 "Vivian Wang" <wangruikang@iscas.ac.cn>, junhui.liu@pigmoral.tech, "Muchun
 Song" <muchun.song@linux.dev>, "Vishal Moola (Oracle)"
 <vishal.moola@gmail.com>, "Nam Cao" <namcao@linutronix.de>, "Pavel Machek"
 <pavel@kernel.org>, djbw@kernel.org, yu-cheng.yu@intel.com, "Baolu Lu"
 <baolu.lu@linux.intel.com>, "Jonathan Cameron"
 <Jonathan.Cameron@huawei.com>, "Coiby Xu" <coxu@redhat.com>, "Andreas
 Larsson" <andreas@gaisler.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Geert Uytterhoeven"
 <geert@linux-m68k.org>, "Stafford Horne" <shorne@gmail.com>, "Jonas Bonn"
 <jonas@southpole.se>, "Stefan Kristiansson"
 <stefan.kristiansson@saunalahti.fi>
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
Message-ID: <20260714143450.61a94085@pumpkin>
In-Reply-To: <b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
	<20260713135614.1618183-3-yeoreum.yun@arm.com>
	<alYL7B0HAvmLVHGU@pedro-suse>
	<b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: upxppceeys99nsq78woycm75y6dt1q5o
X-Rspamd-Queue-Id: 8C89FC0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784036095-637134
X-HE-Meta: U2FsdGVkX1/3kB0T90RpBBOfhq2vPr34eshPZS846TiogbyxlhV2SxnEg7nJxRreD8j+WfvzbhG+uUlUGtaCeU7xakFDXhc5UACbGepGskXVNV+CUG7NSDoExFesplDUBQd1RaO8yZ5yEV6vzLUPflql0ErI4saPFO9xrbk89DUjZEcXx49ktjgimxFKX+P8XTwZOk6h8QKaM2W/tjRxUSdQVhcBQBzOj7q9KQJrxV7eO5gik1p9Ka2moKjkJzsT24ZrFFIibS5J6xwVFMrpdF/KqsmTxG24Af3UqoMsaoFUjbDWeuYNRknRgQ9rMQKBADVdLndW+utTkXIFEW76DytyB/gL7uWAI6PTn88ZWHwWQQ5WDSIxksXXfaWVNl5YUGWD6sBVlCj0/9oGdFPKgUTuCOyV/1/Y9ULVfVd8I07d5vrUJiWW2V7XLQBCIYfAumce4CnlhlZnwVzAm66s/qfZedLMhhC61tBwFPt0DVTj0ozJTVUn/DnxRFonsEqb5qrhf3vRUBz3SRSOKOTn0A6KIDlI2atJGw5qFRUHI+KaDENvBGaI5TOfcCwoZ3bIKOQMUxcAc6MbUAunuXvnFzxtOxF+p+xQ9VGVjXWswHW/TD8zI/nbmjwvhciG16JCNiOx2wTiq0Q3ZBcx011gP7RFQUvSqJ2Wp12v9jSMNbbJOaEdHzt58X+aUyiLDGfEDVIFv3JpRqVuMpQHyG35CUcbBbz80Qf3V966B4u8J6qxkIY5deSc+PuuFbM214CsZsKBBvubNCckGEeJj2XiACJlCfUFSUDZr2DqF5yfx8Eo82wAI/yUPD3gPNDOxUBhrOZbFv8SCkaRY4YGSzW5kOOR8cEWfMoLWbWuAqTo3K0FvOw1YsUU2rJW5gJvTlSBAkYO35A25vmQ8G12K7k7dAeC/5xtjP8WwStodU5SEzWzXtpPvoUeX6JrEX8IPiqY4tS87+QOmRGK8a3pqDN
 LCE5iewI
 wRHACdbyNk20Ss+++90Qlj9ztzjxfsUG2TSn1zr263lVFM7bn1NBc0K8qEqU+v8L8giLwEp7SzlvTdCwBrJJB7YsC5J47bTzylcaWfdqyKqfZVPe4sBzfnj5JFJhJfBA4mNXOmkABEZla0k8F9vESKsWnvPv17fl7fuRpFe9hQHwDORMgf2Qgt/jmSbbPQWzvEvg2yXB4NE9kKp0ERNZcL8odQPSVgwdPHgaKqEdu2aOtpDMtTarWW8lho4h8jn8o6YtzUxajeUsPV6whXXVTDWQbCRx254NCsNpDzMViE9RLRRtmH+a732+oCEhY9cBfSUbFMZgRUiPHEmeEZSr80Ar/ESpemY7cE4ExnPCB3Y3DWV9/QGn7rTWHJIz32MHATGVYIdZ05OIEkHRjnACsv+GonsoIJJWEJ5TX+IOLDj5bKLPzG4Qe71Xe36/q3/9OiO566EcvQxfMUsi5QuPS/mnnBg+g0aoj/IpmuSXrOPWeHftbkiVrqvjLD5qKBXeVujoGqTfJbWdJu2xLUluKzplS0nZqRIgG19I1M3SCTOS52vW9PGOS5i1mboDcgD7EOqhU0RvUPRC/pbjgZhgu5qisuq1GVn1NddSVmC+JZpgUzrhU0HHtB+K+VjRUz8mBNQaNGyOJ7onth9gDQeDcoJw3WSUoVQDECcltO1g2qtvbWSapZiK0/Iv6wZMj8e0mDdPQsAH/tqEz/zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 13:55:18 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Tue, Jul 14, 2026, at 12:26, Pedro Falcato wrote:
> > On Mon, Jul 13, 2026 at 02:55:41PM +0100, Yeoreum Yun wrote:  
> >> From: "David Hildenbrand (Arm)" <david@kernel.org>
> >> 
> >> We don't want pgd_t to be an array, as it prohibits returning it from a
> >> function, like pgdp_get().
> >> 
> >> So let's just use an u64, and extract the right 32bit value in
> >> pgd_val().
> >> 
> >> Leave the STRICT_MM_TYPECHECKS case alone for now.  
> >
> > I have to ask: is there a good reason for the STRICT_MM_TYPECHECKS ifdef?
> >
> > I see the compiler has an awkward time returning a u64 struct (see
> > https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
> > get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
> > purposefully toggling it on for testing from time to time.  
> 
> As far as I can tell, the #ifdef was originally in i386 and
> got copied to all other architectures at the time, but was
> removed in linux-2.3.23 from the original copy when CONFIG_X86_PAE
> was introduced.

For x86-32 the makefiles request 64bit structures be returned in registers
(at the same place regparm=3 is set - probably added at the same time
between 2.4 and 2.6).

Note that arm32 can will return a 32bit struct in a register and
arm64 will return a 128bit struct in two registers.

The only problem is returning a 64bit struct in 32bit mode.

I'm sure this code is arm64 only.

	David


> 
> For some reason, only sparc32 and arm32 still use the non-strict
> version, with arm having changed from the struct version in 2002:
> 
> https://github.com/tbodt/linux-history/commit/5a8202f0259a
> https://archive.armlinux.org.uk/lurker/message/20020306.213958.cd486eeb.en.html
> 
> > If STRICT_MM_TYPEDEFS's worse codegen doesn't matter then maybe we should
> > permanently toggle it on.  
> 
> This would definitely need good testing. It's possible that it's
> not that bad on modern EABI builds (i.e. everyone these days) as
> well as modern compilers, as OABI definitely had bigger problems
> with 64-bit arguments.
> 
> >> +static inline pmdval_t pgd_val(pgd_t pgd)
> >> +{
> >> +	return (*(pmdval_t (*)[2])&pgd)[0];  
> >
> > Ugh. This isn't correct C code. It only works because the kernel passes
> > -fno-strict-aliasing.  
> 
> I think the bigger problem is the code dereferencing the pgd
> pointer in the first place: Since the pgd pair is written in
> 32-bit units in __pmd_populate(), anything reading it would
> technically have to operate on both entries.
> 
> As the kernel relies on -fno-strict-aliasing, the type mismatch
> is less of a problem than actually doing the potentially wrong
> thing.
> 
> As far as I can tell, we are however saved by pgd_val()
> only ever being used for debug prints, where printing
> the first entry is likely all that is needed to analyse
> the real bug.
> 
> > I would recommend either forcing a struct here, or
> > using a u64 with bitmasks/shifts.  
> 
> That would require extra complexity for the big-endian
> case though.
> 
>     Arnd
> 


