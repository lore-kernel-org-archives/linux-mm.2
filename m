Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4B1CEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37D36B000A; Tue, 18 Nov 2025 03:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0F06B000C; Tue, 18 Nov 2025 03:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9621F6B000D; Tue, 18 Nov 2025 03:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0B66B000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:17:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2213F16042E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:17:11 +0000 (UTC)
X-FDA: 84123022662.24.BFCD198
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 452E1140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:17:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPyQmOtc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763453829; a=rsa-sha256;
	cv=none;
	b=ZluhOscd1KOS56I+EnSki5gHd5xLgEQQ0sxwEQeO0KLOPuDv93vB14yBPqWcHSPLUvF7Tn
	+RKDvCJZwuwOi2uctN4HoJHeBkB5jKx91Xskrsh6CNFEg0VOoo1VA9fGYLoEVXZQwf5w8M
	mkKv1Bz6/dureOkV9xwMT0c0GnVR29g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPyQmOtc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhang.lyra@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=zhang.lyra@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763453829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoMiIW3QGWFlhk8MIsWxVubR6fxSt8dbm0U8xNqOKso=;
	b=tYZBKOm4N8PFLg1vYQ4C2j5nvNoU3SlkdI9n1NCuQ5SJH19MAfrB5O2rmja9FDJFB7ZzKU
	azp52UILaeZO26j2gu6wyPEy6rURxTaJv5zw88leh8znu+KeAHxJCCQE8yOjhrc8DNlkGJ
	Z7iPFQnU8O9MZlSY1m51LQ/MOZCwwMk=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3e37ad3d95aso3093581fac.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763453828; x=1764058628; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VoMiIW3QGWFlhk8MIsWxVubR6fxSt8dbm0U8xNqOKso=;
        b=jPyQmOtchjaYYXX2F1shtqJYzBfoI7Zr1tgnYKAKIH4PzEqk8pCKCSmf+Oy+nXGkbP
         qA2D6J9RIUS2/hMmCoI8ym+u495xMp7Qyr//mu3b5/1i9s5ekaqOrUWNqeoNhLebXKw6
         9GUQyGpk6VOENX9EvFqWeuiCb/zZE7E1KDI3ukacslGI8Du83K0zFxg/+csGxWNrIs/A
         9i7n6A0FZM22FRARerzvdcYKihNms6v3hbX+6uB50CAD74DnGRvXqvwWDqsW1wj3E5xv
         0LV/zKU21+y39v1WGOtbf9Sp55IYqaTRuofixdXH2Faf6J1fRhbvLDwLwyNFtCdreTql
         QYhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763453828; x=1764058628;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VoMiIW3QGWFlhk8MIsWxVubR6fxSt8dbm0U8xNqOKso=;
        b=YhsdTZ5vvJRJCTA+dF68ySfGNXAkL02BwLX58GnQhPlO5SMjWs1RXPNTBRfvDdKODF
         syEhWOQflyc3Pp+tegxCcvivDCTo30Dv0WtbX2W/xzPd9dVuENf7g03N9HLuUIDVKhJs
         LskJjOuVKNscVqD5ChmvZJC8Gp5y6jVPesoronnVeVe74pwFKNI8BWW3CcW6G9PsNJNl
         7q8oE4MT8mU4uYi2m7LoDsKEdlAUfQ/gGd2z1yCKxKTVk1r6IXO+drIeGqHLEhpgZMey
         K7Idlm9n/R5qxnlSvSNUFvkNcf+H5uSvKvKGt3CEpD5ERqFUszbzl4eYOcdGep5xBxMh
         5Mcw==
X-Forwarded-Encrypted: i=1; AJvYcCX8QeW936epixJ2ITxl7rbSz6W+UZxUY0RwgU7vV23Azh3kYkwISQSgEKly9z4b49cAz3W0Ii8m+Q==@kvack.org
X-Gm-Message-State: AOJu0YyaRqFBV83rsHaaGsEw8nrPzYEZ+kmZCXjx+c3nNHUAr9qe8Xza
	ngvaCZjFNuUfQ/ajA0bbtCWbjMIPVZYgz2k26Xlc6+uFoHIl/gekmQ5D2Fcz8li/kgNezeU7qbK
	bYY89/fVlFJer1nm2TRcLfCCG/qi+jKM=
X-Gm-Gg: ASbGncs+ikdAhae1fQoLPji0fspLWGAGGrx9WEZ+386/gEVr4xGCEhF97gdWTy/e1I1
	cSAF2poDL+O7g9QOUhRtYXeys16fn0aLpikKzLceM4wyVZcHGXrRsS2xmbzpUmwjcYaoOkdVw+/
	fTRhh4Mzp6yeCwYM3urW37gT3R6dwYvfPGpOF7bJ9uS5/PNC510TzMoCzBJM8hkOltpCn34HqkT
	03ceBFOnjn4qmDQkU+1T6h/+45iDj3wb4iSbimvaS3MqTDxdah1Q0KNxOnJBlG6hgs+EuzhrCLO
	xfKld9sDux/3qZ3OWM/DnYML
X-Google-Smtp-Source: AGHT+IGJVcqmC4kf999U78KR7Z+Carm82VZu3TBqJ/efc58ObEBqzZW6zVk9sdknUB16hhvBH9dnfceG+BbpGDOEGZw=
X-Received: by 2002:a05:6870:8193:b0:3ec:3949:8a20 with SMTP id
 586e51a60fabf-3ec39498c48mr3471777fac.29.1763453828009; Tue, 18 Nov 2025
 00:17:08 -0800 (PST)
MIME-Version: 1.0
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Tue, 18 Nov 2025 16:16:30 +0800
X-Gm-Features: AWmQ_bmir1nIDPRCoXTSJbPR1qsg3o-M-aBGdrWbEh4IhEqrSXiExjOsSzb9Kb8
Message-ID: <CAAfSe-v6+Gc8ujv3m3LdBPk+rGSqmz44RheoNqGJcXjOq3vU9A@mail.gmail.com>
Subject: Re: [PATCH V15 0/6] mm: Add soft-dirty and uffd-wp support for RISC-V
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, Peter Xu <peterx@redhat.com>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-riscv@lists.infradead.org, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, 
	Conor Dooley <conor@kernel.org>, Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue <ved@rivosinc.com>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 452E1140004
X-Stat-Signature: zxakd6ffehzu8afuafpham9cpwp7nhdg
X-Rspam-User: 
X-HE-Tag: 1763453829-477780
X-HE-Meta: U2FsdGVkX1/uRpKzzJh+FNG/RRyK9oKSV9khQsKh/1pe2cFu3gSagfIfmchwVUQQXOQVAMkK0JX+j2ljtaVvXpnDyIbTvqoJrIa4rKnMIzfBKWWATNB9KeZbDcWjZ3wejJk6TWzTuMZxmoHA+bXYO9TGmOgFm8f72cPSLucWIdveMRdLXfF84bj7atp7dWtOK5CG9sDcMzDeBGBN9ol1wAENoZdD0h7gmTnHGYNa8XE8jVqBXultKNTWY+p9CH6BnPMZp1YHYboOhEkqFtcmrKkfB3VwUVeVJHR1x2G2NMSt3pXzPgGbN6+1rAk+jC7oAXRV+CCVFPOj4YFiah2dfJBt3rtSpkftb13i4wQT/5PPuC4+R6j+ML0jZWxHvOyv5vHrp3QmS6RLq9OobSQl+FbyzYSvXzuoCdJOk/jpzquqcOEBo43Kbph3udD53RdTvo2r56h2wFm4nCvr0WwCxUca3TbNhThPXWF6TDNbyeraVQymLm9Q5MRkvdhqInH+0ru9/15ZRzzRKoystRXAxeSkGA7iYDQ+6Owdi2uNuTQr6ftASRAyKI8NvMwk7k78dySbHBlid6QcEgJYyAA+PhNLvp+myJLIqWpEEd5RoBiExwnFShUnG2ll+sbLhC0yzBg5R2W+lN5+aplKiFMul9d8ej9ATIcS0JVROVqG1QT1mGxS+Rt9C2dxxmlcPTj6WNvhzvhRjNvyk4zPjfKzi86fNKhoByVs5Bhr8smRGz5R45IRg+CM8KB4Gw1IeaRZvbS+YzthB/p4wKk2KpTbkDUpU3aOdrJe1+5W0JI7Dkca/CCK2mmV4rJFIQLJcwVjNIglTvHmaJtImDiCUooIjIUDd3Q7i4EbA/mboMZl6EYu0YEWd9N2B0QRZYEFDAnVi/N4hzOvibeC3YnBYvRKW+eFBVq8TfkitpwPF6RWosXV5iuYJOg3b5tpuUhrntiPtGRw2xpqdoM8el/kiow
 MeYiETnP
 Ix15wq5wcR0QCKF3eSVsDMZkytszo0yizpMstpMSFBM0IU2+Bor7XealpyutSk8MmOluwY6YaoP2dIV8IXFU560TeeP+nyBUdb8fZDK09yh+LdewlA1PWgMoff/Mhtf0x/Nnx6iQiLkYYxBT95yiXuZRfKnsn1SZGpTg2mlxvCZPs/NFnzJric0WkhwKTR4aLFh3ZQUy2Jlm31BkrRJkF86LmLeRimJZLfioFAIDu04IrYGSOSS8eMFYnGkZkpii1zqXBq0ogn6hZReIFRx8fXNeTiGFt2CfAo0X7EQ8yvTKuP82pEx3ilz/48yzJVTjm4EJLQCwG8LVIzo6fiAkc/m40DpoI8qCQl8L7xDoFfRFSGX/KgZ4B7OQnJ0kStduEV/6BnaVowV+3asdJI+0FhvL+ORjbfPRFXEW1cCoKA318m786CaaagA6YjWjiQbAVkV/Jky2BJeYDKFS9bPCG/lLJbXcOiRLK4Hc2xLv9UUADmyQp/gIeoBo8NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Thu, 13 Nov 2025 at 15:28, Chunyan Zhang <zhangchunyan@iscas.ac.cn> wrote:
>
> This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
> also add soft dirty and userfaultfd write protect tracking for RISC-V.
>
> The patches 1 and 2 add macros to allow architectures to define their own checks
> if the soft-dirty / uffd_wp PTE bits are available, in other words for RISC-V,
> the Svrsw60t59b extension is supported on which device the kernel is running.
> Also patch1-2 are removing "ifdef CONFIG_MEM_SOFT_DIRTY"
> "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
> "ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of checks which if not overridden by
> the architecture, no change in behavior is expected.
>
> This patchset has been tested with kselftest mm suite in which soft-dirty,
> madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass,
> and no regressions are observed in any of the other tests.
>
> This patchset applies on the mm/mm-new branch commit ea53cb52f919
> ("mm/vmalloc: cleanup gfp flag use in new_vmap_block()")
>
> [1] https://github.com/riscv-non-isa/riscv-iommu/pull/543
>

Can this patchset go through the mm tree if there's no more comments?

Thanks,
Chunyan

> V15:
> - Rebased on to the latest mm-new branch;
> - Removed a redundant space;
> - Added Conor's Acked-by.
>
> V14: https://lore.kernel.org/all/20250918083731.1820327-1-zhangchunyan@iscas.ac.cn/
> - Fix indent inssues in userfaultfd_k.h;
> - Some descriptions and comments minor changes.
>
> V13: https://lore.kernel.org/all/20250917033703.1695933-1-zhangchunyan@iscas.ac.cn/
> - Rebase on mm-new branch;
> - Fixed build errors;
> - Add more exactly descriptions in commit message in patch 1-2;
> - Replace '__always_inline' with 'inline' for uffd_supports_wp_marker();
> - Add Svrsw60t59b description to the extensions dt-binding in patch 6.
>
> V12: https://lore.kernel.org/all/20250915101343.1449546-1-zhangchunyan@iscas.ac.cn/
> - Rename the macro API to pgtable_supports_soft_dirty/uffd_wp();
> - Add changes for setting VM_SOFTDIRTY flags conditionally;
> - Drop changes to show_smap_vma_flags();
> - Drop CONFIG_MEM_SOFT_DIRTY compile condition of clear_soft_dirty() and clear_soft_dirty_pmd();
> - Fix typos;
> - Add uffd_supports_wp_marker() and drop some ifdef CONFIG_PTE_MARKER_UFFD_WP.
>
> V11: https://lore.kernel.org/all/20250911095602.1130290-1-zhangchunyan@iscas.ac.cn/
> - Rename the macro API to pgtable_*_supported() since we also have PMD support;
> - Change the default implementations of two macros, make CONFIG_MEM_SOFT_DIRTY or
>   CONFIG_HAVE_ARCH_USERFAULTFD_WP part of the macros;
> - Correct the order of insertion of RISCV_ISA_EXT_SVRSW60T59B;
> - Rephrase some comments.
>
> V10: https://lore.kernel.org/all/20250909095611.803898-1-zhangchunyan@iscas.ac.cn/
> - Fixed the issue reported by kernel test irobot <lkp@intel.com>.
>
> V9: https://lore.kernel.org/all/20250905103651.489197-1-zhangchunyan@iscas.ac.cn/
> - Add pte_soft_dirty/uffd_wp_available() API to allow dynamically checking
>   if the PTE bit is available for the platform on which the kernel is running.
>
> V8: https://lore.kernel.org/all/20250619065232.1786470-1-zhangchunyan@iscas.ac.cn/)
> - Rebase on v6.16-rc1;
> - Add dependencies to MMU && 64BIT for RISCV_ISA_SVRSW60T59B;
> - Use 'Svrsw60t59b' instead of 'SVRSW60T59B' in Kconfig help paragraph;
> - Add Alex's Reviewed-by tag in patch 1.
>
> V7: https://lore.kernel.org/all/20250409095320.224100-1-zhangchunyan@iscas.ac.cn/
> - Add Svrsw60t59b [1] extension support;
> - Have soft-dirty and uffd-wp depending on the Svrsw60t59b extension to
>   avoid crashes for the hardware which don't have this extension.
>
> V6: https://lore.kernel.org/all/20250408084301.68186-1-zhangchunyan@iscas.ac.cn/
> - Changes to use bits 59-60 which are supported by extension Svrsw60t59b
>   for soft dirty and userfaultfd write protect tracking.
>
> V5: https://lore.kernel.org/all/20241113095833.1805746-1-zhangchunyan@iscas.ac.cn/
> - Fixed typos and corrected some words in Kconfig and commit message;
> - Removed pte_wrprotect() from pte_swp_mkuffd_wp(), this is a copy-paste
>   error;
> - Added Alex's Reviewed-by tag in patch 2.
>
> V4: https://lore.kernel.org/all/20240830011101.3189522-1-zhangchunyan@iscas.ac.cn/
> - Added bit(4) descriptions into "Format of swap PTE".
>
> V3: https://lore.kernel.org/all/20240805095243.44809-1-zhangchunyan@iscas.ac.cn/
> - Fixed the issue reported by kernel test irobot <lkp@intel.com>.
>
> V2: https://lore.kernel.org/all/20240731040444.3384790-1-zhangchunyan@iscas.ac.cn/
> - Add uffd-wp supported;
> - Make soft-dirty uffd-wp and devmap mutually exclusive which all use
>   the same PTE bit;
> - Add test results of CRIU in the cover-letter.
>
> Chunyan Zhang (6):
>   mm: softdirty: Add pgtable_supports_soft_dirty()
>   mm: userfaultfd: Add pgtable_supports_uffd_wp()
>   riscv: Add RISC-V Svrsw60t59b extension support
>   riscv: mm: Add soft-dirty page tracking support
>   riscv: mm: Add userfaultfd write-protect support
>   dt-bindings: riscv: Add Svrsw60t59b extension description
>
>  .../devicetree/bindings/riscv/extensions.yaml |   6 +
>  arch/riscv/Kconfig                            |  16 ++
>  arch/riscv/include/asm/hwcap.h                |   1 +
>  arch/riscv/include/asm/pgtable-bits.h         |  37 +++++
>  arch/riscv/include/asm/pgtable.h              | 143 +++++++++++++++++-
>  arch/riscv/kernel/cpufeature.c                |   1 +
>  fs/proc/task_mmu.c                            |  15 +-
>  fs/userfaultfd.c                              |  22 +--
>  include/asm-generic/pgtable_uffd.h            |  17 +++
>  include/linux/mm.h                            |   3 +
>  include/linux/mm_inline.h                     |   8 +-
>  include/linux/pgtable.h                       |  12 ++
>  include/linux/userfaultfd_k.h                 |  69 +++++----
>  mm/debug_vm_pgtable.c                         |  10 +-
>  mm/huge_memory.c                              |  13 +-
>  mm/internal.h                                 |   2 +-
>  mm/memory.c                                   |   6 +-
>  mm/mmap.c                                     |   6 +-
>  mm/mremap.c                                   |  13 +-
>  mm/userfaultfd.c                              |  10 +-
>  mm/vma.c                                      |   6 +-
>  mm/vma_exec.c                                 |   5 +-
>  22 files changed, 337 insertions(+), 84 deletions(-)
>
> --
> 2.34.1
>

