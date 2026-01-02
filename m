Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6209FFA3754
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 18:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBC16B0088; Fri,  2 Jan 2026 13:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69B56B0089; Fri,  2 Jan 2026 13:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943226B008A; Fri,  2 Jan 2026 13:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 813106B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 13:04:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 228C8C2B87
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:04:05 +0000 (UTC)
X-FDA: 84287797650.23.44EF12C
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4468518000A
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 18:04:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KsII55rW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of fvdl@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767377043; a=rsa-sha256;
	cv=pass;
	b=8aB1b3+lQNPV+knAmv0ho95iI86pKPRzJsEcfW5djvgJCWgTMMauY+dvluX4Qs8wWWlDO6
	IzBQ35mox5Mp21RFfRW+Hb3/gsJXDuFVOpdT5KXYXq2gzxwkmB0KpSJtXifJONjkTAy35u
	8cThuBij7fm/TmdWPGQej5Y/km0XCoc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KsII55rW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of fvdl@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=fvdl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767377043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VF7Ncw4qUW1QvZXNeYN2PHKmriSnoyG5jmMgiKLYwBI=;
	b=R7Pplq08kV0DB4UKJ/R5yKFBjDb40cGM3A5tt1iq0BIDhV90ao1apuiMnIPiY6vjfTGNr6
	uwt1sIs9BvifdVD7HZGBHcPuf5Btq61lwgXUM8qSS9WzIxGiiDwmJ6xTBsJx9CGbabh6tI
	PLzgiqAXqc4D32FzmCGSfFvUhCNU3jI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee147baf7bso10901cf.1
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 10:04:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767377042; cv=none;
        d=google.com; s=arc-20240605;
        b=hZpzqANgge6tY0BI1/eMh2F8OFrHKFmfiflXc7bUK5r6kvZqkmHSb4CeIU5IGwgmO3
         9P0tDfNzHlcohBMV2SUPCOEW8ebXSDMY/LmEFCj/kfquTJhKXisQCAilnopQWGPEydRt
         LXI8jQM0ueDSk5T437v2gwHQ5bsiofzpE1+vqdG8q26oV6tLCW0dTJrL5agcec76DCCf
         HchcLnZYkAuDR4UuDZ6zQ08GcofeGcMGOdCOnO29oS+fqWjtlftDbV4MqcStUOyhmwN7
         ufj7N/CVuTTkqHaiHR83S7lfk1w3WqLrzDHw7mgYhlWTIRkzBMNEXT3OS8el1mc490Pl
         qYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VF7Ncw4qUW1QvZXNeYN2PHKmriSnoyG5jmMgiKLYwBI=;
        fh=rBSAY97vn5XjVGmRPTeTQQE2PGjtD8P7y5YLbu4y43A=;
        b=klcwLinmmoP1RurTC30/EByNzi+6b5QUTI+MoCrjfzPQaOIJMynyVW9YSbVUibS9NR
         2/ur5WOvH+M0dIFL7wAvMZQ6iOgm1rGo0di2RjNDxqCHNxCBEWIrT9LPgrGiXsrQOUZh
         5CK30Spn/VyGb8+++i2pnIjyp8P6TuNzrYugyHGb4vPr9rLU15jMAMebrYLKTdPO/8Pj
         6zYnRmGTtEzdOs/CT7uBit0toGVbFPD9+SccDlPmwcELVA8uL/Iv/cbbZlEhfx/2cIAa
         vW5at+P+LYOxfJoKxaa003wfcRoU8csnQ/OatWRVfdQNNl3rRG1vXmWOsyAmhEl0keTG
         WHsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767377042; x=1767981842; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VF7Ncw4qUW1QvZXNeYN2PHKmriSnoyG5jmMgiKLYwBI=;
        b=KsII55rWZkdWOnUcXt+9Pfl96YtwQeqYhYjR5gdYjMuRA7O7ljJp0qUimJHf0PW5RZ
         OXFeFLH7Xi2GnWtiZ9Z4LbFSubLrJSUqFG8+G9McT6d2yoWuKvud1sl0XZjaq1NTLjAD
         XkiirSjPBMG5xqb7vBYhaTTx2bWN6fVtYWddHtkdE/DTDMdSRKnF7YXA1vTCZAP3z0ym
         ovHbFp2C+qNXD1UpXwiZWLKihLzTsCSlSX3nMjqp+vjZtIuI6Ptlex9S/0k90Cb8eD3O
         ACILyVxvBNeoKNm0/NVOpYiUqL1MIuDXRJXjBpGRqUWfnzSz1kzQzLcHnRwRPG3sJXcm
         xDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767377042; x=1767981842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VF7Ncw4qUW1QvZXNeYN2PHKmriSnoyG5jmMgiKLYwBI=;
        b=oml+btMP7WnJmngidXG/7Ij1FgyU8wAoFP4bNQyB1XNCQqP+sJQcfd0Dc50pSn3TnS
         UU171FWxcnmwnXMfE/oexcIzC9j7tboG0wj4uY10WTeXxMGMMEPHqmFis01SevXHTYQA
         jnOVioBjRItO08gyOUXbOjNrSEUt2Ctar33Bt9tLGEnBAJlZECAw/p0eS4M3pPtcsdiX
         wuEODXBYrZ0qhvgG2aFgsB0ErJ/W/XIrafcBSBvRpUqOcj7+zpmI7BO7RRUGxqWQAJ57
         z6mqSWy7umSOFNlggY0KzcPIF3W3xx7Z2BaJxedniGvVWp7AyDP6wqSz09I+yrMMjsET
         1QkQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8JAC+RvqBps4yecmgz9pieYbvzYTrCB60amIgljkm+MpBy7My4aMNvsPcVJykZIXtgJD2QaQDsQ==@kvack.org
X-Gm-Message-State: AOJu0YxSpJzfUOaBimJiRubm52blZppW/3QdH/7wIY6fPol5bGtVQNBS
	OXTmQLyvq6Vp4Wp1i1dx1CrzOyqDbkFk9L9/aE2Br02Vao8tDAgVNdMxNJ+BVnq/GDN6HSnEEyg
	LTkXUVjrumrGhPheNS49Pol9SvegBiZYrwsmSh/gB
X-Gm-Gg: AY/fxX63MuZGUYxq4e+hCLUtKS3qb9Ndn++klN6+95fxA37nouZzUcWeAHGizo65fax
	msAwZDWwKMgqMvDMRqxKfwU9R3jJI+3VXri0vLhFfTmeAEX91jHTB8ke5GrKmgzcJADx5IVRIba
	BLQXEKO0zM1Oa+RpZD2t9z4d+Sh4iTX8u0G/kJa5ozmClzaV+OmtwjAWMAGBq4kNB8KcbakmDjJ
	vnIvjlpx0pgSkkBanDA8u83gBsW730BcWmxM+lHLrpzPxPu2LTJPhSCQHNqLEWTtKHHkro=
X-Google-Smtp-Source: AGHT+IE626c1niVbXfJuRnnEKb/XVpUT3xgOsgVHvUYmmAhOToE2K50Gpbsa48xtp+jOGlgqExM/NP3EnDee4koBR/0=
X-Received: by 2002:a05:622a:8016:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-4fbe3b0ad54mr14392961cf.1.1767377041692; Fri, 02 Jan 2026
 10:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20260102070005.65328-1-rppt@kernel.org>
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 2 Jan 2026 10:03:49 -0800
X-Gm-Features: AQt7F2qPng5Y0NvX0my5UG4cpefC6iiH19nIvMPHQLdOtt1JmQ_l0Tjv8FxQEzo
Message-ID: <CAPTztWaZZt_ygCDNaDdW9A_TtT1FNZW6hFzyiq2b6_xxMw38gQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] arch, mm: consolidate hugetlb early reservation
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, 
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	"David S. Miller" <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, 
	Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, 
	Michal Simek <monstr@monstr.eu>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, x86@kernel.org, 
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4468518000A
X-Stat-Signature: pcatqkn33tbothhomsdw8cqg1btexe13
X-Rspam-User: 
X-HE-Tag: 1767377043-553403
X-HE-Meta: U2FsdGVkX1+vYRBPhXkiyDfjbeYY/W2UGcQRN7HqxuccLsM1iYCYAKByFt22KOCQbGQi1Cb1Bh4PxqmEY/6cFogGaBIVe0ASF3ZBghwGOcOo8DoRqwmPTdVbeRTd0HBzyt1n9ZbVWaPCM6Go6ygGdkzhSpkwrc9Z2NM/BOaSYdbqUvm3MDQUIHG6kan4TuJciGn91t3IE/EPuviiC75ydChBA6U1CxMUI2EUj2JNQ0a4aBxLH0Nr69UuakRLP7qNMHYVpPyXueM/mHXrfMI1iwtk8BXFzD3KNQB7ZtnAdj0aQLoNFptoSl9RctIFTPtA9JMMi9OM8j2EGQ/cGxQgy+WU7jHl6Dy/M4LywjFWdKTUyWLBD6hukWdcj/MX19XHy3Iov9bXVVJTcqTomnf7rSSVY1j/Rfzl7ZLDbLgOrt8LD6JvgwOR8/T5dTLt80iZvKhWBhTmyTjSHRn9abunCNeU0R7s/FqDP2e4dp8Q7pDc4howDvUHVbSwodYfMuHyzhFNg7yam+Ib+V3XgcWMq+x3XFoNnzapRKouGhOz+oxND6bIRiQC44QVLk7d+p3L75mnkEGtpGokPFCbgavRvZBmlWMrG4RsL17ALiTZ8vpjHxLRXkMxypCrrnbuelbdd2IfGCpS/owfWhBuHTiM0MyfBW7vHAYLqHvmhFsZmaneadHvgKBraXa0VVmUCiQgLbQIea7WXSVsZKUxlr9XnmPhrmYBvLJcLHb3806d4Fg4TLEi2Pvqo4aDxEltJUeRAqcgdUTt7L+PJk3y+LeGXDimUHakg0FiKuEJR0XOOcXHEXKZ5cP1THnFGY5QduWZTja+B+pxEuQLhUIQmgSDuMJwTp9mzAVcQh7soQOGGSbQfk2JJJC9pUv/8dQvW5IBIbKL6+pfdwQ9l4HpmHHzUoR7Klv1ZwrEUfwmhuhb6ZWsIPTjQr+UJk/P6x+PxVjkgjRfMmWMmwQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 1, 2026 at 11:00=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Hi,
>
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
> complicate things and for HVO pre-init to work sparse and memory map shou=
ld
> be initialized after hugetlb reservations.
>
> This required pulling out the call to free_area_init() out of setup_arch(=
)
> path and moving it MM initialization and this is what the first 23 patche=
s
> do.
>
> These changes are deliberately split into per-arch patches that change ho=
w
> the zone limits are calculated for each architecture and the patches 22 a=
nd
> 23 just remove the calls to free_area_init() and sprase_init() from arch/=
*.
>
> Patch 24 is a simple cleanup for MIPS.
>
> Patches 25 and 26 actually consolidate hugetlb reservations and patches 2=
7
> and 28 perform some aftermath cleanups.
>
> I tried to trim the distribution list and although it's still quite long
> if you feel that someone was wrongly excluded please add them back.
>
> The changes also available in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=3Dh=
ugetlb-init/v2
>
> v2 changes:
> * move the hugetlb and memory map initializaion to mm_core_init_early()
> * add Acks
>
> v1: https://lore.kernel.org/all/20251228124001.3624742-1-rppt@kernel.org
>
> Mike Rapoport (Microsoft) (28):
>   alpha: introduce arch_zone_limits_init()
>   arc: introduce arch_zone_limits_init()
>   arm: introduce arch_zone_limits_init()
>   arm64: introduce arch_zone_limits_init()
>   csky: introduce arch_zone_limits_init()
>   hexagon: introduce arch_zone_limits_init()
>   loongarch: introduce arch_zone_limits_init()
>   m68k: introduce arch_zone_limits_init()
>   microblaze: introduce arch_zone_limits_init()
>   mips: introduce arch_zone_limits_init()
>   nios2: introduce arch_zone_limits_init()
>   openrisc: introduce arch_zone_limits_init()
>   parisc: introduce arch_zone_limits_init()
>   powerpc: introduce arch_zone_limits_init()
>   riscv: introduce arch_zone_limits_init()
>   s390: introduce arch_zone_limits_init()
>   sh: introduce arch_zone_limits_init()
>   sparc: introduce arch_zone_limits_init()
>   um: introduce arch_zone_limits_init()
>   x86: introduce arch_zone_limits_init()
>   xtensa: introduce arch_zone_limits_init()
>   arch, mm: consolidate initialization of nodes, zones and memory map
>   arch, mm: consolidate initialization of SPARSE memory model
>   mips: drop paging_init()
>   x86: don't reserve hugetlb memory in setup_arch()
>   mm, arch: consolidate hugetlb CMA reservation
>   mm/hugetlb: drop hugetlb_cma_check()
>   Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
>
>  .../driver-api/cxl/linux/early-boot.rst       |  2 +-
>  Documentation/mm/memory-model.rst             |  3 --
>  .../translations/zh_CN/mm/memory-model.rst    |  2 -
>  arch/alpha/kernel/setup.c                     |  1 -
>  arch/alpha/mm/init.c                          | 16 ++++----
>  arch/arc/mm/init.c                            | 37 +++++++++---------
>  arch/arm/mm/init.c                            | 25 ++----------
>  arch/arm64/include/asm/hugetlb.h              |  2 -
>  arch/arm64/mm/hugetlbpage.c                   | 10 ++---
>  arch/arm64/mm/init.c                          | 39 ++++++++-----------
>  arch/csky/kernel/setup.c                      | 16 ++++----
>  arch/hexagon/mm/init.c                        | 19 +++------
>  arch/loongarch/include/asm/pgtable.h          |  2 -
>  arch/loongarch/kernel/setup.c                 | 10 -----
>  arch/loongarch/mm/init.c                      |  6 +--
>  arch/m68k/mm/init.c                           |  8 ++--
>  arch/m68k/mm/mcfmmu.c                         |  3 --
>  arch/m68k/mm/motorola.c                       |  6 +--
>  arch/m68k/mm/sun3mmu.c                        |  9 -----
>  arch/microblaze/mm/init.c                     | 22 +++++------
>  arch/mips/include/asm/pgalloc.h               |  2 -
>  arch/mips/include/asm/pgtable.h               |  2 +-
>  arch/mips/kernel/setup.c                      | 15 +------
>  arch/mips/loongson64/numa.c                   | 10 ++---
>  arch/mips/mm/init.c                           |  8 +---
>  arch/mips/sgi-ip27/ip27-memory.c              |  8 +---
>  arch/nios2/mm/init.c                          | 12 +++---
>  arch/openrisc/mm/init.c                       | 10 +----
>  arch/parisc/mm/init.c                         | 11 +-----
>  arch/powerpc/include/asm/hugetlb.h            |  5 ---
>  arch/powerpc/include/asm/setup.h              |  4 ++
>  arch/powerpc/kernel/setup-common.c            |  1 -
>  arch/powerpc/mm/hugetlbpage.c                 | 11 ++----
>  arch/powerpc/mm/mem.c                         | 27 +++++--------
>  arch/powerpc/mm/numa.c                        |  2 -
>  arch/riscv/mm/hugetlbpage.c                   |  8 ++++
>  arch/riscv/mm/init.c                          | 10 +----
>  arch/s390/kernel/setup.c                      |  2 -
>  arch/s390/mm/hugetlbpage.c                    |  8 ++++
>  arch/s390/mm/init.c                           | 13 +++----
>  arch/sh/mm/init.c                             | 12 +++---
>  arch/sparc/mm/init_64.c                       | 17 +++-----
>  arch/sparc/mm/srmmu.c                         | 17 ++++----
>  arch/um/kernel/mem.c                          | 10 ++---
>  arch/x86/kernel/setup.c                       |  5 ---
>  arch/x86/mm/hugetlbpage.c                     |  8 ++++
>  arch/x86/mm/init.c                            |  8 +---
>  arch/x86/mm/init_32.c                         |  2 -
>  arch/x86/mm/init_64.c                         |  4 --
>  arch/x86/mm/mm_internal.h                     |  1 -
>  arch/xtensa/mm/init.c                         | 14 +++----
>  include/linux/hugetlb.h                       | 12 ++----
>  include/linux/mm.h                            |  5 ++-
>  include/linux/mmzone.h                        |  2 -
>  init/main.c                                   |  1 +
>  mm/hugetlb.c                                  | 13 -------
>  mm/hugetlb_cma.c                              | 33 ++++++++--------
>  mm/hugetlb_cma.h                              |  5 ---
>  mm/hugetlb_vmemmap.c                          | 11 ------
>  mm/internal.h                                 |  6 +++
>  mm/mm_init.c                                  | 20 ++++++----
>  61 files changed, 219 insertions(+), 394 deletions(-)
>
>
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> --
> 2.51.0
>

Thanks for this series. When I introduced HVO pre-init, I noticed the
inconsistencies in init order, but shied away from attempting any
general cleanup, as I had only tested pre-init on x86.

With this, it should be possible to enable
ARCH_WANT_HUGETLB_VMEMMAP_PREINIT on architectures that support HVO. I
think that's only riscv and loongarch right now. But that's out of
scope here, though.

- Frank

