Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3348CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA716B009B; Tue, 11 Aug 2026 09:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281FE6B009E; Tue, 11 Aug 2026 09:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198BD6B009F; Tue, 11 Aug 2026 09:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E535F6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:25:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78AA2160413
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:25:13 +0000 (UTC)
X-FDA: 85089059706.30.BE2E0F1
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96E7914000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:25:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n6B1xJph;
	spf=pass (imf23.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfUDfNxB65XZqovwWVBLkrKpJgUq3OtZ1XoJNMhjK1c=;
	b=oxry3bHwg/S/+lvH1llFq4NdlpJ84PU7bxu3FRl0qrelcPsb25VdZtDbzH6Vk2e+AHa8HN
	53GX09YU3fo42dtDgg9Ri1a38dvrDcKRYEogeumrluj0e/LMrqj/LnA/MmzxL7YVBtfL92
	MmIXz4+8vViDg8HhdrUrSEFMaoRFJjY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454711;
	b=Sct8+kLKwpQt4xgos6hg6BSGo8Ji+k24u9HNmYlUYPQ6isrXE6aCoNfoZ3oXUUb4QQPNCR
	rS8Cw9MTL3aFNzWVWkKxz31eyCcm+G2Kru44w8EIWJ6zDcNGp86rRGP74jf9dxVn/W3NfL
	adfb5wcO84GHj0X5lA33gECLMi2geAg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n6B1xJph;
	spf=pass (imf23.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4997581cdc1so6526465e9.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786454710; x=1787059510; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HfUDfNxB65XZqovwWVBLkrKpJgUq3OtZ1XoJNMhjK1c=;
        b=n6B1xJphQpILHB/HXqgzISEXo1nkG9rVzEpXg4TtTRO2ncBIagO+T0FG8NelbJPDBn
         +K6F42gEsQVRaJNnONMKkzxzUrFlSc1OcPupX2TlDvltKypNm6w20o0/v9QPjcXUTFX7
         DMc1oHLIPVVEISzHLKHtyosZJ6kjWIp89F9tlAVW3jzYm3a8vQ8x/v+vfsZx0yOjoFn1
         zdj7DU0+xnZon123ukmqrfSVZWEB61PHUBP6Q+aXtnWcappfy5QRgUjDSTGImCrWYc2f
         635MmQVXw/BnGFudLMlnDxxyYE1VEFfkFzZpqxPs1XwNGDZk0Ghw3ezucRxhEFY2BIFh
         eDgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454710; x=1787059510;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HfUDfNxB65XZqovwWVBLkrKpJgUq3OtZ1XoJNMhjK1c=;
        b=O0tvhCihGTeyJEbatsN2FCHFV6xOX6TLJyKu9y2GFV5XGQl7zmikWrprVDs+/turbv
         vyIQtNP2uhKLQ84CJqXmYT7Lh15kn2NrBmzcnXgM5iEk2TooIYMg4p0b9v8BwvTp3KjP
         lpswHZK7prTBFK1jteLjR/NORElodFMC+aBX4ltBojL6e4QfG5ffoAhcugnmefRrYmot
         1bHlxV0ONi3tMRZNbqvnGDFQ6R06f/FW+JEv47HgPXdoWUymgwr3vp/e3CZCo6HL91qi
         EX8HwZ40c56hoOCEB5QG3OYzMvECdWdKsUWI2GQqZ8uSk0JTFu6OzG7Li3vc0zz0FJpX
         C7fA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9XOKvqbjZmLFtw0ba6BCky99DWlaNf8Hu65r1JhChkN9Cdv5/4NH7nD7JEERfGh0b01DAL8dTHA==@kvack.org
X-Gm-Message-State: AOJu0YxjUgCWT3H7SDGG4aSuCwGkWQJ6y2EGkKmJ1z8htDmqyWiWj2OQ
	rydx1LKN1u7GGbYpgM3NABDZbffxDXyiuH3m3hPzsKYaneJ/5/MheCQZ
X-Gm-Gg: AR+sD10YZmJVq8vgHsrsm/i3w0Z7Pmab0/tmlfsepm3YdxyiDJpuVsnI3zP1BypBMsv
	Zc4Ea8sJ/ODdkH4BTKmUMAmvtRgnvnOXbuZ4gK2ybZB7aOMz6dXGWxPv5UBjPe/w3m95mVNtRdX
	ar5C+XUqy9IByVdv0Bb9UJ2PGUM0bfkQ9W/dS8TMvg62j6011jqPcsxH9v6B1ZE6dsmSEverl83
	+41CuL9I5VOmNYQwhtfN3tRgC58SMCg050YL9kolwWcb29JLt0WB8XJjMBbWPQ9RUT+4xZ4Pevw
	dlmYAszt+GuOKRuILqxnCaDkkM7uSuNHxMten05GtxG+pv7+jM4bxkDz8ZmSUbf5veMMu+dXIY9
	LjtTMFDOQ0J2lvO21cZTyxwANa3hbcQd9u0EmZ9iOQDxxpr8upY9n03XRhmWqOQS2LDZiby1s1w
	bG/RqvJwLxFRhXxODXC9RUS8NBAbfJ2gSsl11WuhQ6xEM3eQkYUxoeiUYAarcbPlzoiwnHaZdEp
	2HBaFmKsFM2y4R3sLcXgJ8nbA/njQMxZhGH
X-Received: by 2002:a05:600c:4513:b0:495:3e08:ad19 with SMTP id 5b1f17b1804b1-49978468c2bmr48261215e9.9.1786454709883;
        Tue, 11 Aug 2026 06:25:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49977df9489sm83541285e9.1.2026.08.11.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:25:09 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:25:07 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, Richard
 Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, linux-um@lists.infradead.org, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, x86@kernel.org,
 tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, Vishal
 Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
Message-ID: <20260811142507.4c6c760f@pumpkin>
In-Reply-To: <01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
	<20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
	<01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96E7914000F
X-Rspam-User: 
X-Stat-Signature: oyuqxbx6f6otet4amkiqfrai1k4weii1
X-HE-Tag: 1786454711-688041
X-HE-Meta: U2FsdGVkX1/2k6XQ4F8MbPH98DMWUpPtFQFH/udL3OtWPZshwhbsyelj9zS5S4jaB7UI60i3k+i4KbCllHdcac60kJXjr5AwzgHIzeX6N9U4LB3SmKAyoHM4OPHOq8VVLlQRgpuiLmbvALnJ1XhWizQ6iSUf+8bCuPcKo9cV9GhahuIjTUdag8TeLgDPJzPJBZtzoADWbhz96ag6+KX4005U6gKEYSyVMiLvS8VEk+H2EkCInz7lTcrw48s9sZLrteH5P12MFNzrrTw0oTGi+qXtcOiSNnCeziGO4SYnwgNsI2PiCYH7oH9OTssx+HFgY5V9js6HDjUNskxhc+Qx9jVRlH2beK4ViZa4jODf8pYNtYjuHh4w/fd1su5H8M3j6x5qckpcw4wOZZOciyqTyrY0Zo5jNZnYJJlQwOGQSSrosdqIvRW7ddqtihDyDmIFv6noe4eQCIFbCgKLtfGPT0yuQO6Pa3kJTQiomU5QU97CLFlsFbqZYgl4o0Uxzhj8KsNrhu0hXJhfhXqXbL/9hgc7zsutFWQ1OS190b3K/HPc/3B2zV5tOV/8MDKaTQ8Fv4Jxnm9a6iyT2IaoYqBGn6aJYLFVBoMRMZMc6Z5he/qQiXc3Xe+DLnnLX47Ugon9moeq2rdckiqfN304joyxVySkg4twxWZQQMIpIsb4tQWIU5Y+6pwDUi9wCBcC5m7NWWBBqzL5rqEunRdHd87PPmtt9xH3QK+eLFio4EV6JBabHh9rpNFDCCSPIhLF6INuPgmwHQ0Y4Q42cglPGBnhEbPzUfmnPb4NdfBV1hqWfTCZcPLB3Dam6EtqQvJXxpZ013AFWBvrc+JEa2OwFSxU3RkQLsjqHkYa8CKFkRa+4lEksskOJa51XHbrboQmCzYLZZnyakMm3VVP0KSm9xt0u5dDg5JBjPNRv4GpqyorDf4gSSO2LmC/DPQ/7tZaRH9d3iGz17KQ0z62z9EgW98
 MfXrBw9R
 F/3KA/fumAOCFqipmPCujJY5z9L97fKkQUAQfohENTP6l7JDtsUx/wg9FUwHprzkFa74TsnziDgirlLP9ptXiOnkbXcWQF0SWRG4cDhehtDRumeg2pixtuD4CAg/JftyS/+2jZgdtOc23fgIB0df5ZQEPe4/cVtdJyGUzqLDxOkATeDtV8ao/2LQRTxERYT6njFRNL279QNJW4xMLEu6bs2/eJB8H6F0kiDkIQ0EKxxwRlmLfiDtu/gh3ykbNAqR0b90pvEDx/td9V8A32smhEqe4wM27Dpty8e7aMxZvRV3h54U2CXsntCYl8qHL+dhiHQoHXboBOA2K0/3UefI4i+yeDwbWJYwdk5pqd2uEiCEkoRaEK/S8+itpMrn/XOAeE9BWkZW0dvIG5FnMQGYwOGLIzkiF6PNNLemc4VZnhHkRmmpz/B10XJpB1NlEQcPtork6KlUKV9LMOvLxfA17o8ShMexN6ch/tZw5kFckin2mk9nZl/zHCr7LZnNHIyBKzDGevgbbEAQD5WbkZB8Zr4beHC4vIqMDtnPx2ETnt/zRt4vzfT2k0uJFmdiEIF3vxps6ZdLsYXGHq1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Aug 2026 15:59:35 +0200
"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:

> Le 14/07/2026 =C3=A0 16:03, Kevin Brodsky a =C3=A9crit=C2=A0:
> > mm code often needs to know whether some mm represents a kernel or
> > user address space. This is currently done by comparing the mm
> > pointer with &init_mm; besides not being particularly elegant, this
> > ignores the fact that other mm's (e.g. efi_mm) may also represent
> > parts of the kernel address space.
> >=20
> > Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> > Subsequent patches will use this flag to replace comparisons with
> > &init_mm. No functional change is introduced for now. =20
>=20
> Did you consider performance impact ? This test is usually done in quite=
=20
> critical memory handling functions.
>=20
> init_mm is known at link time. Before your patch 08/22 there is just a=20
> comparison of mm (r3) with a constant (loaded in r10):
>=20
> c0014048 <assert_pte_locked>:
> c0014048:	3d 40 c1 09 	lis     r10,-16119
> c001404c:	39 4a 03 98 	addi    r10,r10,920
> c0014050:	7c 03 50 00 	cmpw    r3,r10
> c0014054:	4d 82 00 20 	beqlr
> ...
>=20
> After patch 08/22 we have, it first checks that mm is not 0, then it=20
> loads the word located at mm+528 then AND it with 0x1. This load might=20
> be costly.
>=20
> c0014048 <assert_pte_locked>:
> c0014048:	2c 03 00 00 	cmpwi   r3,0
> c001404c:	7c 85 23 78 	mr      r5,r4
> c0014050:	41 82 00 10 	beq     c0014060 <assert_pte_locked+0x18>
> c0014054:	81 23 02 10 	lwz     r9,528(r3)
> c0014058:	71 29 00 01 	andi.   r9,r9,1
> c001405c:	4c 82 00 20 	bnelr
> ...

Thought...
Could the check be replaced by one that checks for kernel static data?
That would require that other mm that represent part of the kernel
address space be static (and probably not in modules).
ISTR there is an address range check that can be used - and might be
cheaper than the explicit test for init_mm on many 64bit archs.

	David



