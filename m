Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FED5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 21:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BEEC6B008C; Tue, 14 Jul 2026 17:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66F176B0092; Tue, 14 Jul 2026 17:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536F46B0093; Tue, 14 Jul 2026 17:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1DA6B008C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:46:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AF09A052D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:45:59 +0000 (UTC)
X-FDA: 84988715238.08.F4998A5
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id C605440008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:45:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AkJRG022;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784065557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsgDUhCPZi1cUpPkNQ/I7/JmqQLLDAJpIhlyKeHE0tE=;
	b=Mp6yp906nPpJFQnSRNJfKGLEgI10w9KD7bLQiQOQIrqjiJAW58UJIvEeH2nVGRFmR5+PG4
	U8YlaFRHwJpE6Sd8kmU9bC3eaaVFrpsjhMtBpAoeyqe4/Pxc8Mxl4HNtByEf4Th7o+k9+l
	XQCKJaeSYRjHJr1+FLKfDye13NTZbgM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AkJRG022;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784065557;
	b=LcYfEKgAR0D5fQW0rdnAS8UIcMgQhoTtWKSmWRpytMOnQYLMCOKOiR9n8G2RhsXE3sJw5T
	BpEg90J/wDKr2VaneUPZqa8NdFlOPv5KggY1G+pcD/V2CW3+uBYm07ad2ShKJ2rzYNsUlz
	+VmJrnTCo5imYeZyuAr9/PXIGaZwEPU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so34409835e9.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784065556; x=1784670356; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lsgDUhCPZi1cUpPkNQ/I7/JmqQLLDAJpIhlyKeHE0tE=;
        b=AkJRG022f61ub+JrYSCoNEEqo7jYoAGKK0PyxEmLxiJOcs2xgIb3QRI3KY0haQaA6N
         dpuL8dPUzETF0FsoR7WIo7lKzN6Ibk0lMfGhROQnSg839GqdZ98JEkyxPSWXThRNwbiQ
         GF0JCd9P+dSlgJYaV4HE/juSwX1txVyaVHNuJ/8Pt7F7inWXaZECsAWIIOTXy9g4nO/d
         A8BlqFAmVJ2UmQUbG/FhFZOpTMiuHmKWm3YpiUv8Xu010GS8Pj99d7EY4PEdT7k8N3uO
         X39P37cS9xj37ngLmqH4nzlye5TpL2HPIlMHYIe7TAio+S2mwD3Yz1sTMkkV4FyJ4mHs
         V5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784065556; x=1784670356;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lsgDUhCPZi1cUpPkNQ/I7/JmqQLLDAJpIhlyKeHE0tE=;
        b=ZjqMIUi4TyYT71XGN3x7ZaUSv/FP7iKPUDYfees9qNNnvy/PXevdXvtOINYRKlPyHU
         qpZpcBVgIsN+REkM941e9+guUM+u0GT0sp0Z0ceVJf58R/1b+K2r/8samuSappez/U/t
         nL8Sgo2rC26PAqJgrkSoNA92uye5ywrmB3e2JyBL+CSQ30lVN7TvrFiALeyGorKe0noi
         hJdKmSJj1c3Iu52l1uKlGLDmTAe7fBVmm9vbEeZvfgDvcSYiNUbcq9mY0REDcj8V8CF+
         Dc3Uv6dM6yaBJZpW4y55CAZKDTsG+uwm2Ebn6XecLKALxV7ory7hoc0gWGEJntu178ex
         DbvA==
X-Forwarded-Encrypted: i=1; AHgh+RpNEJ9Gt5uL+5IHemuYjNFk8ygTUNxq0HApn4vAI9MYcf0OSlXDx0sv0ihk3CgGBHqEnTk20jcCkQ==@kvack.org
X-Gm-Message-State: AOJu0Yxkknrb2XaGQkXnpgV2YtXBHn7mokGxcZcCOmHdrzwYV63O+C2P
	Rqq6zONd1N1sH8lXajXEbVO+9LulClWursufng7wWqiU5Nv+1wdo9+n/
X-Gm-Gg: AfdE7clBHX4aE8JagiCO5Ey+gJQMDj8SgHFmg6aSOB8qJVJ4pxNPfp23V7xVuaCQDVu
	uZ6Ozs9zH+TxgPwnRXnjoYTk3ItKkMW8v5Q3HJqbvR90eZpCC2tV/fHS8pMlN76DhjZzRgqCYjc
	p0YwNY4TZ/DiEbUE2xa7j3G1OD/352lOr2zLSbanU2UOilPm9juRutwo/AkSbR73EpVDDpJYDij
	fIBwm1CuhE62GvbpYQUALYquw6yTvlqgjlN2P2YZ0rZeugD6SwP6B8ZoviDRIbKMyAOxCHxXP/r
	2EUHNIaxzO+xoF+WvcT6wH4I4Y5R9eWSLoJXe+I23bJS28Y79RVEzYucjv+6aeRKFhrqxjAo9V9
	dBw3za6lD0QcsN/0okATStMpaLvYnAZYjFdG/33/ZDOuly0tbEoUJSBBtsx6cN6JS5CNe0Ow0n+
	/VAgJ1aQLHM/8JD+THR29eYBeqAJI/TcQAeVoqXy0pHKIVlROzmg==
X-Received: by 2002:a05:600c:4e8f:b0:493:b307:6777 with SMTP id 5b1f17b1804b1-4953c273de7mr4061435e9.22.1784065556082;
        Tue, 14 Jul 2026 14:45:56 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a32b9f3sm118533945e9.13.2026.07.14.14.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 14:45:55 -0700 (PDT)
Date: Tue, 14 Jul 2026 22:45:53 +0100
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
Message-ID: <20260714224553.583c8445@pumpkin>
In-Reply-To: <aceb8582-bafa-41b3-8f56-77fec89a4d90@app.fastmail.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
	<20260713135614.1618183-3-yeoreum.yun@arm.com>
	<alYL7B0HAvmLVHGU@pedro-suse>
	<b7dbc476-1477-4004-93b3-c5e667e24df8@app.fastmail.com>
	<20260714143450.61a94085@pumpkin>
	<aceb8582-bafa-41b3-8f56-77fec89a4d90@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C605440008
X-Stat-Signature: xgzh8ufarny13fiog4k6bfwnhhgthou9
X-HE-Tag: 1784065557-127811
X-HE-Meta: U2FsdGVkX1+SJz4OXw0T/e0RtQTcGzsWXuyshIawN268115LRGHBctY6naJwjU8LF8bh+lnvvuqJiH7ghyDLRajX0/VkBcJ+9V1gMV0Gc55a1jAd60qR5wKeoo/K8c3gd/KiO5L3Iw11WSYsn5wg8AYtAaXa8wu18QF7Lkc0FOS8eRtCDOHBwDX4H6NQEIU2a+ye0mVDHqdprpTn3sbsIvObGJWVlDZe1EhffCSnMEA6X74pr31Os33vHMmlv4m5AwWFfIykikg8ISfWwNXjSVXOqAtSjUowLieAcc+GyOjWXE0KrBq1s37KW4qIsYxTbu97krBAZEOpZUxXLKl0kJu105uU9U0cVhI04V+SKT4BOc0260xWGw1OFBAwOYtkaBxl5PCHkpX58Jn3RBukrXP7qIwBZ/tQHvvzznEfSSP5MyCmbB2HIs6egVJuo0uVCL0AHlBngrBd5VtIZbzmboYcHVNGP83kqc/X/0igr2pjr1cnd5LnEpB2qTQ4VTavHqR/Wm8JkA1SGckt02zOFrHaoHWHFvVHUddEyIWHFLNJ2Utts1xsElLD2zmVnpDK7xFab2zw4dkFo/ZxCvgP3MGW+ChdSj21WmiUe+cQi5LgNIX9aBUdXXwSuUG/6nRgtWywk1iq2wSGyoLPV1LzPwufKgP7G0MB70l4e19IuMxtrfjnRF7waYdZ/PopKqIWcVS016iMAAD8+Xxm0e8QFq9G9MUteayP6bNNbiqOl4PN63+l3L4LaDZtN8g/GYgkIwxnXP8fYChliPO+VvD+O4m/ocxIibTyL9q8/k7NbsH/J8MlgoVYxBI7vzFjurbOhfhxC5ZeglCfjkt2e0WK+duSRel1CZZRUfkrmw4KEQbDmU4dK0cWhNrbJKz1j3VsQQtwWoKBi0Vm8d4bREHVFldzGyQcld44AHngAIx24ByOU3eG4yEQn6T6zpGShBG9DcyMg5Jyz3ilEKXziWf
 ZwxyrQDQ
 TcvNErr/v5xYg4AScUpS4vJfYTeLiLNqhd/Kz2rbY9ohrjZgwImKMJkJRZrM9rJWRrXef5NjD3SThC5fRK+5QixB5UYi0VwXcjVyCJeNAgPohMOCYj+XgHmB5jEwkJeYE6OELO+GPXN/A11Zejp3nMPi61n9JLEaaKUTCXlRSY02TwYel05W3VUU9hJdN8GGn6DVBtta3fQ9JHXFdzdBC0tJTz8PETFgLUfWmrNEhjujLY4raDi+AX39mvxYYDQmXf83+M21MG8tdivA0tLmf/XeR/KKth+tFY3wnaChDiIMgFuOCPsSyv/DZm2QsAG520uLf55Xow61hESIVbwWMAb7R/IFi8GOzciesxMzS4A/M0gHPdP4ygD713NIredggNZ1s/F0eoDzm1mooY8DzQJLIGLel82im7a4OrKPX6hgLjFxz5Av1cPyQFe8MAiUEVW4fSvmbGLIUH65Zfj1I3VhYEsUB0Tm7NSNMWMiElSRD2Qflip5hXHLVaUgWJ14hEToZgLBS9oBD7uR+w2kOyihxbQ0+ZCRN1bA8FJOIrLcATdVuM3uN4ytfdKMgSyi09fBd8x9o/h9kENrPAHQZjcmnFNGUS4jBuYx3puRHFIxP/5Vsiqf/493pJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 17:06:00 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Tue, Jul 14, 2026, at 15:34, David Laight wrote:
> > On Tue, 14 Jul 2026 13:55:18 +0200
> > "Arnd Bergmann" <arnd@arndb.de> wrote:  
> >> > I see the compiler has an awkward time returning a u64 struct (see
> >> > https://godbolt.org/z/qejbv6j9a), but if this doesn't work maybe we should
> >> > get rid of the STRICT_MM_TYPECHECKS stuff? I seriously doubt anyone is
> >> > purposefully toggling it on for testing from time to time.    
> >> 
> >> As far as I can tell, the #ifdef was originally in i386 and
> >> got copied to all other architectures at the time, but was
> >> removed in linux-2.3.23 from the original copy when CONFIG_X86_PAE
> >> was introduced.  
> >
> > For x86-32 the makefiles request 64bit structures be returned in registers
> > (at the same place regparm=3 is set - probably added at the same time
> > between 2.4 and 2.6).
> >
> > Note that arm32 can will return a 32bit struct in a register and
> > arm64 will return a 128bit struct in two registers.
> >
> > The only problem is returning a 64bit struct in 32bit mode.
> >
> > I'm sure this code is arm64 only.  
> 
> The file we are talking about is arch/arm/include/asm/pgtable-2level-types.h,
> which is definitely 32-bit only and force a 64-bit struct return
> on the stack.

I've clearly failed to detect the environment :-(
The 'struct return by reference' is part of the ABI.

> I checked some trivial tests that show that arm-linux-gnueabihf-gcc-16
> also still produces badly optimized object code with structures
> passed by value, and will spill those to the stack for no apparent
> reason. clang handles those just fine as a pair of registers.

I'd have thought it would be ok if the structure had two 32bit values
and they were directly accessed.
The silly test I did earlier didn't spill.
Taking the address could easily force a spill in the function itself.
So that ((int (*)[2])&var)[0] (which is just ((int *)&var)[0]) is likely
to be problematic - or certainly heading in that direction.

> For the 2-level page table, this only concerns pgd_t, which is
> rarely passed around or returned by value. The 3-level page
> table has a 64-bit pte_t, which means we probably won't
> want STRICT_MM_TYPECHECKS there.

I did do some mmu setup for a strongarm a long time ago.
I do remember in being odd.
But I was only moving the software frame buffer away from the physical
frame buffer to steal a load of screen rows for a keyboard.

Is the 64bit pte_t needed to get the extra modified and accessed
flags there aren't free bits for in the hardware pte?
Would it have been possible to use bits that are fixed in the hardware
pte for the extra bits and write the value to pte[0] and pte[256] fixing
up the value written to pte[0] (that the hardware reads).

The arm docs seem hard to read...
(the left-right scroll doesn't help!)

	David

> 
>       Arnd


