Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88FAC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D866B0093; Tue, 11 Aug 2026 07:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E846B0095; Tue, 11 Aug 2026 07:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D9C6B0096; Tue, 11 Aug 2026 07:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85ED36B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:19:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F10E1A03E3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:19:48 +0000 (UTC)
X-FDA: 85088743656.27.8B66803
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4A3C420002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:19:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJ6NUWhJ;
	spf=pass (imf31.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpHpX3dMx1OmUziffO2NidzvFmW3rlX7MNbm6J/WhK0=;
	b=O0Mkj5bJBdWebv+QGyIGx+E0agbrLs9klARGXwDkZ251EwTZiWvLToJhDLWHNp7oz9/cXg
	fr7DF+/yNnTqKsDvK1iJaWWFu97HOY3ZU0JMSAuB8oxw42Y350T6M3LuFaI3FOWR30OV6w
	/riw3pl05/IVN1ObC7BftNQpZL4Sk/0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJ6NUWhJ;
	spf=pass (imf31.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447186;
	b=sHyxoxnCr+fWuGxLjaXsVPauAnBbl1vBeFoBKd0+HCvKvGCXdV10dOfolVI0vUhCNpPp7G
	XRm51bm6m62ZgJkDtzpc178+K9oy5rjQ7sCcF0Q5lw5NhFWX8DmPmc1+gxypfKnpl0HknF
	arFuNdM9LsJ6X6gOoGTzwoqZvBRuK+U=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1480899f8f.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447185; x=1787051985; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WpHpX3dMx1OmUziffO2NidzvFmW3rlX7MNbm6J/WhK0=;
        b=OJ6NUWhJPONcLZzrvGw4G8tc9GcThfhkyBJopBAdb2rZQkRbDDq46oK/3sF24T3GnH
         /QbMwpv5SvQUGuKkRKqH5UjS5yEQwcdSNKgxUkaaYeUEof0fh994pgdKy2UmTEpF2IJk
         6/tvQNgViLh5WHkK3ns9tNK8ANEn+OyOJGxu1WXjhjAbP8B4Wcasl6EWs2Plw7wT5L5a
         NcS6+bYOe+f0a4V0SkZTIM8vNb/gaRydoVnvHM1xwxhpFAD+w/Pka88HWTDPOwbOrfiq
         TygeKrygc8CUC18xI6z7COdSP5ZBEZs5vVg7cYa1AeuqgKmTfDcbU3xT6/xjNNutS8SL
         q5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447185; x=1787051985;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WpHpX3dMx1OmUziffO2NidzvFmW3rlX7MNbm6J/WhK0=;
        b=mkEeyfE+HkIWX1z7d+4BEc5C6af3zuC4Uu0EVze87KkpMvvRhuZM7nDC10EG/7srtV
         DHS3HDlFYp4yBf//QBS8zU9Y8JyiVaieeaBQjU1LZaiMTjSDEPDfJcSk74fwOGZKTkVh
         trxVAyjy4RRysDo1jLQw8kn2lF/hCrBHPh3gsVotkjBa7wwzOdQufOuA7VSVvmJcICZm
         MRFmXvr5JmHtg246NXEVH1t8xGFwwL34ysTckffHhPbIrYGIubGdl6H5iCcpAzcfSGHg
         BcCMBOO43sg2c9UQmByKnaQ7cCcFWrSmvgs+jtRr9EkrDfMLS1wbhWTROBG10o4WRCoJ
         a0Ig==
X-Forwarded-Encrypted: i=1; AHgh+RouNpmC1SDCT/Ysg9RvgKXigwt2r+Z55+QNIJXyK2Ugqv1M+n3OF7w42oO3hbG5NMQfV8vLu3Ep4g==@kvack.org
X-Gm-Message-State: AOJu0YywbXOXLpxetDWIfoeYRpQGFNWBUAcIW8AThOkQjge0aBibbc0I
	DleZUM8LxZaSii7A3+BFbmYKs8yPm4e54dkg9b7jtFXzRqyCNUfsOfA6
X-Gm-Gg: AR+sD10cvra03vrPZA96DeQc9Fddn+9LkQlwtsRF3gDwdshLOfVLuv9Lnp0S4PssV2u
	/n8hzZ2WNq60Cp+j2uUgdoy5VFav8En8wwu8ilvArzXk0YFaDa97S1TlNA7MC9LrnU83CVCz/7Y
	JhSf96AwEWoutGo35l1J8KW0CZLX1m0ixqCZRlxRD5ULiEoGw/FpADZVS1hyTWqR/4jvBasDsfY
	jwS/gWqGalcVyWobY6M3OOCoo72igCa6d4UTfBTf815lU3ECfvkJkKJZCm66SR2x1DWwmZpl6IP
	QlO1mHCnykVCyRhKbzgPKSzF0C47q24S9SnIRTFi1UvBTMvwptUgC9mJQHmsAQ3BapG8cU+p6rH
	AD6i3usuSmZdzPwYKSY9BY3w90utpj9Fi37Z5v7YkGltTCB1TeVuMZ9G7w16Qj75nCULovKwayb
	v9u9Tx9nbfZb9O1rDqujE6Ka8Cv60BA6adKap/mEz46H0hPHNyruQwpSyE1UBXH2BRnY6zUSyPs
	Qskx6E6w8I361XlHaSSC+wZ5Q==
X-Received: by 2002:a5d:5e8f:0:b0:47f:6f6a:6a7f with SMTP id ffacd0b85a97d-4814ad890fbmr4370323f8f.8.1786447184497;
        Tue, 11 Aug 2026 04:19:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4814a5ac75dsm3318120f8f.7.2026.08.11.04.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:19:44 -0700 (PDT)
Date: Tue, 11 Aug 2026 12:19:41 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Christophe Leroy (CS
 GROUP)" <chleroy@kernel.org>, linux-mm@kvack.org, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Ryan Roberts
 <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, Huacai Chen
 <chenhuacai@kernel.org>, loongarch@lists.linux.dev, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul
 Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
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
Message-ID: <20260811121941.4ca20b88@pumpkin>
In-Reply-To: <643a624d-0106-44ed-a7f5-aaf9316f94fd@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
	<20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
	<01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
	<33fc9d31-2866-4315-9510-0004deb93994@kernel.org>
	<20260811091016.5ca67143@pumpkin>
	<643a624d-0106-44ed-a7f5-aaf9316f94fd@arm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d7xq7om9zpkt715zt8p3hz7877cr7c93
X-Rspamd-Queue-Id: 4A3C420002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786447186-747123
X-HE-Meta: U2FsdGVkX1+DeRXSY8XVkN/NUHgwMRKqao3b7Q4fYc+/9XOygYCD7aMAXddEGtdAYNi8yuv6y/SQkQo+ZnBoaKR/S95Yzs1E11ASEWg8MAlXG0v9Z3GOeSpKvRuZe4ZUWx/NVQZpvzHTaL64Hx3npO588ImkFVzjsHz16mrVOqunG2cIfgJZnjaf1Nzfqgc2aQW9X1tL9vCwQck4mNhgoOndBdmQK6wFZUAxJZsir01G0pL8WdAwIPxIIf6yPdIN/9VRky4g9ItCqLnSBrqzLmoojWoy1t1KG7fk3qLYzjLzZZlaEgAieoOa2VE1W9uS+SOYZ++wk2HDCsbtEvuq93i0jlwbff6JDzCFrrgh3oTIIHPsaQx0m5HJzfgW26W9kPDpAPnCcbnhD64qxlOwgLcZr7J3hdh9b+lFle3t9DWtRXFvEAWmAB8Ri9mGcje0cFnt+6MozVZihw1mnccKh7KBQ0D8azQJjz2E/vmISBI2aAwBeRbQ4TcldjG7oZv3G91o61Fio0EGAjteAsRuFLB4TOCZynfXqE/lGwTywR/YUYFnwytI/2fRdTQGyMO3A+DC5KNjrhbo1suaTd2N82d/64BeenUCWcdZPTPF7fs1YpwhCyH8NZKaR643aFDylp3p0Sun8K2aix63c7zg9NVE0FfsKyax8PI3+/nEZQUucA9DEFqvu7O5p0p+6opoJAblfVT+JBLWJqWYm7yDI/npokH6NmRCzC7VbGue7qg0EfjYpsA7PaxNizPjWd2Q+LbFBWY+jlo6ogQ8lUeAb4fPzFCSaN40h8F358Cw1Auo5TZWJ2G7onRkSJ0+0aQEtElRUnAd9Uq1o0LswZoR2baOyTaryxsIWw3a6SDKXEFJATNCoh+gXeqZZ92r7WXvem+5FID7Tqo0YqhSCavtOimjPuKApxsMJP1VGo61qtENVvVXLLTOxazjbfn9tO3rrkFkQnPUmhd5PP5RYPq
 y9T3h3KH
 IHJKxGuiPluQfHTWFYqvvTLxsU2nJEE+RXzrizckPw0Ys8VEMViGZ5ZYPOjju8pXJ7ple9yLnOQno/cNTY7xUmWJMyko955HybxPdGfBiZy2/i+TQy+x7nie5/vwPkzrrBtoi3XkLRqjn2xi15REHil7b8GW1vV9wWxN7AAKAKr+JiQYNzGGe3viexse6rgd5c+mdm3Cs8Cn0wcoBAu3NXAt5/H3yfCX66oS9JZlFP+DuPjKgkDoUN/8DjzqB6RAMnypFsoOO+0YVmz9szPUjS6o+y1nEQbrxDv4mErAkj4G1pZOwgrZv55+Hw13IeUPyO4k2nmYLzbTORoVdOD90gClwjil+BCJlMjvulz3wRheXFWsGnustNYben0wAGz1T6SYRKhHjgse8J/8G7UcqFr2iKndFnbEER1iVGH7y1VzoPdXTRdzVDewHvWkPT86rn/Q35yMxTT6LZRQ4QvIrn8zwW0CprOe/09HI+RrgArxmfUl3m1oG27Eqci/xh1r38xogQXJd2nX82tJodOq4MZzC4jbEcz3sP/+NnxWAst6BO3N8SAvRQqZGaJHZ9eNVtJ86N0pPGXtYvjpFj6I7kFNz9qzcuIsiP70q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 11:00:09 +0200
Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> On 11/08/2026 10:10, David Laight wrote:
> > On Wed, 5 Aug 2026 14:07:01 +0200
> > "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> > =20
> >> On 8/3/26 15:59, Christophe Leroy (CS GROUP) wrote: =20
> >>>
> >>> Le 14/07/2026 =C3=A0 16:03, Kevin Brodsky a =C3=A9crit=C2=A0:   =20
> >>>> mm code often needs to know whether some mm represents a kernel or
> >>>> user address space. This is currently done by comparing the mm
> >>>> pointer with &init_mm; besides not being particularly elegant, this
> >>>> ignores the fact that other mm's (e.g. efi_mm) may also represent
> >>>> parts of the kernel address space.
> >>>>
> >>>> Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> >>>> Subsequent patches will use this flag to replace comparisons with
> >>>> &init_mm. No functional change is introduced for now.   =20
> >>> Did you consider performance impact ? This test is usually done in qu=
ite
> >>> critical memory handling functions.
> >>>
> >>> init_mm is known at link time. Before your patch 08/22 there is just a
> >>> comparison of mm (r3) with a constant (loaded in r10):
> >>>
> >>> c0014048 <assert_pte_locked>:
> >>> c0014048:=C2=A0=C2=A0=C2=A0 3d 40 c1 09=C2=A0=C2=A0=C2=A0=C2=A0 lis=
=C2=A0=C2=A0=C2=A0=C2=A0 r10,-16119
> >>> c001404c:=C2=A0=C2=A0=C2=A0 39 4a 03 98=C2=A0=C2=A0=C2=A0=C2=A0 addi=
=C2=A0=C2=A0=C2=A0 r10,r10,920
> >>> c0014050:=C2=A0=C2=A0=C2=A0 7c 03 50 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpw=
=C2=A0=C2=A0=C2=A0 r3,r10
> >>> c0014054:=C2=A0=C2=A0=C2=A0 4d 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 beqlr
> >>> ...
> >>>
> >>> After patch 08/22 we have, it first checks that mm is not 0, then it =
loads the
> >>> word located at mm+528 then AND it with 0x1. This load might be costl=
y.
> >>>
> >>> c0014048 <assert_pte_locked>:
> >>> c0014048:=C2=A0=C2=A0=C2=A0 2c 03 00 00=C2=A0=C2=A0=C2=A0=C2=A0 cmpwi=
=C2=A0=C2=A0 r3,0
> >>> c001404c:=C2=A0=C2=A0=C2=A0 7c 85 23 78=C2=A0=C2=A0=C2=A0=C2=A0 mr=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 r5,r4
> >>> c0014050:=C2=A0=C2=A0=C2=A0 41 82 00 10=C2=A0=C2=A0=C2=A0=C2=A0 beq=
=C2=A0=C2=A0=C2=A0=C2=A0 c0014060 <assert_pte_locked+0x18>
> >>> c0014054:=C2=A0=C2=A0=C2=A0 81 23 02 10=C2=A0=C2=A0=C2=A0=C2=A0 lwz=
=C2=A0=C2=A0=C2=A0=C2=A0 r9,528(r3)
> >>> c0014058:=C2=A0=C2=A0=C2=A0 71 29 00 01=C2=A0=C2=A0=C2=A0=C2=A0 andi.=
=C2=A0=C2=A0 r9,r9,1
> >>> c001405c:=C2=A0=C2=A0=C2=A0 4c 82 00 20=C2=A0=C2=A0=C2=A0=C2=A0 bnelr=
   =20
> >> Is that a real problem, though? =20
> > The cost of the read is likely to matter most if the branch gets mispre=
dicted.
> > I'd also guess the mm isn't usually NULL - so that branch needs to stat=
ically
> > predicted correctly as well.
> > I'd also not assume that the mm is in the cache (unless the surrounding=
 code
> > has already accessed it), the L1 data caches are small. =20
>=20
> You're right, I didn't think about this the right way round - in general
> it may not be easy to predict that mm points to init_mm, and an
> arbitrary user mm isn't guaranteed to be cached. Repeated calls to
> mm_is_kernel(mm) in the same function shouldn't cost much though.

Depends.
If it is real function call the code will be in the I-cache and is likely
to get predicted correctly by the third call.
OTOH if inlined you've all the I-cache loads and that static branch
prediction might get them all wrong.

Oh, and saving the result in a local might cause a register spill.

	David

>=20
> Would some (micro)benchmark be particularly relevant to measure the
> overhead, if any?
>=20
> - Kevin


