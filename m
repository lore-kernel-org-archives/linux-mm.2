Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843CACD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58916B0005; Thu, 11 Jun 2026 14:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09986B0088; Thu, 11 Jun 2026 14:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8166B008C; Thu, 11 Jun 2026 14:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7506B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:00:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D175912D7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:00:19 +0000 (UTC)
X-FDA: 84868396158.29.2A19090
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F7D020010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:00:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KO4eWSiu;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781200816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlMn0YdvVMwOdwBeG++E82Goz46z1U7ucNvmWuYeWtc=;
	b=3KOqb5MtW5FlWzI/5X7/3BM/EB2C2cTxJi/EMwchBW3Es9I2oJnGQ5XzkkVdLasEMNEynG
	de+w9TSew3bxLaicQ0S+cctdwjPxrkSKIwwbgnj1Po3h7FfUx9a5RSiL4LveSQj/gwdW+A
	uSFQuFID8GARJz87feUyOp2ZrtUBVt4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KO4eWSiu;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781200816;
	b=6XL0MPX6fGAarwzJFdBpRgZEVhsK9b6yUJL2SmQkODRyTeFRXKrXwu6uit2muzZ35npuHr
	9ComsLabglk51+QRZzNC1O+1/dnWVVmAHpJm8vRB99icC61UYslmBqhgVVUM+Tajl/GlGF
	MnxtcAJEpa2xhBzKPU6nx16cffbkIrg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781200815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GlMn0YdvVMwOdwBeG++E82Goz46z1U7ucNvmWuYeWtc=;
	b=KO4eWSiuUmVZZEGDkhpJsjtcJwpi/bhSBeUNyxFI/yZXsY6OkEn9SxkLORrHf182TH/tXK
	th+jeKyB5jVN+ECVnCmDZq2ktnKaCYo0GRpunvKSFImeDYi+z4yka9TjnjHpqBI7kY5Kkd
	CtWFOrz6ROP1iNdYd01yP3WjoiOXx6o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-C-JDUzBKO_6gqq4PA5BiGw-1; Thu, 11 Jun 2026 14:00:14 -0400
X-MC-Unique: C-JDUzBKO_6gqq4PA5BiGw-1
X-Mimecast-MFC-AGG-ID: C-JDUzBKO_6gqq4PA5BiGw_1781200814
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51768072950so689821cf.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781200814; x=1781805614;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlMn0YdvVMwOdwBeG++E82Goz46z1U7ucNvmWuYeWtc=;
        b=qF/2WEuegSBzp+0hd02ob4+2mblVFHicDXBnXDMDJgEE3MoqXSRkwH0VAhCl2OuXJp
         LP1W9RaJ9D1V9DzjvSPyn6s43aCKGQwC+iq51JRzjKAUn8dFQyGekAsrI8+8rH+PGyEQ
         TQrFeYzdtezErBAqrO8D9V8kGnJ2NOjQ6eX9trrzM182AIFV1ZrzlR6fVp2jpDHC000A
         8dIxzC3gvA6cLCIEJGKm4605X3UvE51CBqUj8Vk495bcK1CL+rbadcI0rvde9dmCgfVX
         NIhBZ4R2No8xzzHWO/rHfZ/0RuRKuWeagEBOIKdvymUiMRubZRDqMZiOcMRfSWtbeUGF
         NhDg==
X-Forwarded-Encrypted: i=1; AFNElJ+hD+wGrSOzzw+/XEpKF/S82+YZwzy1c8xDX1X6aejM7HCAZ94mxY81v9lAm4tMGGfmxPfPWXh29A==@kvack.org
X-Gm-Message-State: AOJu0YzuIKxy5RZa1mZkuh3ML4YxMHuqebpbM7I9j8S3jGUNL/6yb0zG
	4HKuPQtJVO0TyFRRt+sQihfiwNBLqvVIhiw04iPytQwaU0HR/weDaBNhxZT4WdCMhFq6x1pLhkI
	KowBagrCXc2dJyFuBthxfZTGyLSbwbnlhVCGRSVA37Mmd1ZoEnQ1L
X-Gm-Gg: Acq92OHgbkZ35Plf+cDQAvdpvbAjKNwFKYiSo0B5MDa81cQ253QmrdqvnrCZQnbwa7j
	HZkzUJa0OES+bm+WsuLdblUHpp2N0dj6kHKVKjiSkwzVtWDQFeiMup6vZg8h8DzC2kaWm2l0Yd+
	t1wTPrN2YH6BDkhSofV/UKcCfSSnvjZhgiWTfSpPv/QfUauVPyyTDcRkxb2zeZcysT2DQSxfPD+
	ZKwQrg5O7qU3RLEvCOTb1xHhw2yWNX6UjVnRWJf3i1g3wnyZatWEKaH8ZXlU61j+vc5G7k+H3D9
	bgZABC3cb9c5m2amblR1xDaZa1OmnzenL0i69dBZBlxItwVuPXDwLxVUU/3sKZohGYJiK30tAVX
	mki7EXO6Vae8EXMV229SWGlTiw2CEFhLU7PjmotGdY84Bm0uQEwv8mEQXC3S4Y3++qVuWUvpyRd
	6ZaJzVa92aK99D
X-Received: by 2002:a05:622a:5805:b0:516:e74e:cc51 with SMTP id d75a77b69052e-517ee263bfcmr64542501cf.51.1781200813510;
        Thu, 11 Jun 2026 11:00:13 -0700 (PDT)
X-Received: by 2002:a05:622a:5805:b0:516:e74e:cc51 with SMTP id d75a77b69052e-517ee263bfcmr64540711cf.51.1781200812602;
        Thu, 11 Jun 2026 11:00:12 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517ef5d9031sm23333681cf.16.2026.06.11.11.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 11:00:12 -0700 (PDT)
Message-ID: <47f9202b-71b1-41e7-8185-426beb9d4a2c@redhat.com>
Date: Thu, 11 Jun 2026 14:00:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/14] mm: thp: always enable mTHP support
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, yintirui@huawei.com, ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qOQYjDidMVhBxYg3vj8cw9JBF8iTkuN3lQqgw4tdrJA_1781200814
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F7D020010
X-Stat-Signature: zbbskyhmmc9uknucfnn35y8sknqtxyhi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781200816-184216
X-HE-Meta: U2FsdGVkX1+SPqQ8cKaov1A0DXW7UtF2mv4O3C6JpLIy2nokEe/uzYst8zgLfiBoqW+etoh+hri3mWLrNO/VjAh6UpZeyU9+UJlclg3782Iuu4hxOR/pyHzQEGjRqFSirV2uhTqlhrFAeLmGlqPGBPddf8XForm6XJ7IyxzzPC4YQthvYCKAmIQZcoyoLj8SNUgrCy3vJ/PzWKUsuNQldfvVCRYXqbRRdaype2z3NGi24kUIu7IiL8cuHMxWNrzh/44tn9oxL7WOrmiAVvLuur8/kPiZqB+OXXP28yV2IHe5p0c3U0ufhitftWGopsrSL+/PpCrDU3VSJ5EQAP6NsFwhdXOAk8M25e6SMgjdA2SVTvr02TxXD0CiWGmJh4tisJzGFiuakgcbu1CvQKW1lMRdT19Cenz0+nVAcLRta9POD6ee+3mGiOAcJVagmKG+HqKGNhBCggeI/XJq+4/ISOpKINOiu1podvv82veWtpcMhDMh5iWRq5BAKsfPZDARrcossHiiCgBYDCN/8/lBTSW5+0K4NdEJxZR5FjrNVGA3k1mMNG9kGO3bV1wdC7aWodw7R74KhaRP3JZbfI8URQMbSygtkdrITS3kPGUGY9yyQbZym/0968Mr+qV5Mbr6H68y+VKzBnrmQ5vDzcIRNG/4+hy+BeVnED71xngnXosjLfyhZuMNKemoFHpVARPDjMYVzgrTcxkfwWw+3ebr7007Axs2huC/bRf6Xr4rQClOSX9irBaJOybps4kn1YmsIx5Uc+eE5FWJNZDTKtFMdVm/C2zpxZGl8JcBf90m3aIfGYhNrJ1SHVyq4PFTbwPWDVFtO4qBHmLaMW/XJEZ6tVGBMbFi2Jr5YaBwXS0CBMj1LDmhWwStdyLKBnzzbVvh6M452NpJHkR1xtbPPzEvKOar/Kk9NENUhwGPz7MRNhTy7yujlQ9y+H4jOiwjCdw/c4r1pZEVzwTxh/CQ+6b
 tHjakvWi
 VWpcAIvLiwOy4jzLus+zT+iYgWHXApRSH4WKgY9Fh+Vl3mJJ+F+Yhuq3SzIXqUyj4LgDI51SvoVlbiJht1GcbGLcnjlsQQAHyhUlkGTRj70HebH2kKq4RTay4s7q5AmZhidn6Pkk3JcI+IdU9q+VlUAPTvHWd8Z1z21D5yR1Uas2nmQUUcbxWMWl/oNLDX30tGyBpA9UA5IVDGiKnuup2JIMx4MpqMld4kf4EB1idzB8qhMY4uNkj8+Qa83Kut6jBk7HGN7VtZPdPSRpVCP2+fS9bRNPvTpKiL/jk6C03hGUnxBafQ+/d3im/TeeYo6tSwFAvbSikcM3z1sEx/C/8UC4K9njk6bRz0pKMAM3aWP1+AAfaiAkNW9kobExPDXdUa52VDfXOCvq2kARgHlyuZyiS5DpsZVIrchV+tVk/dxOu/Hm3xTJHouOP6Vx56LUSQFbuSVVGmx3oC69DE10Wcye/m2nVdkE7GiCP5re2aDf413Q0lKTEEDBjPq5ANtotH/yJ5WvM/1wYpG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Top posting ]

Andrew,

I wonder if it's time to add this series to mm-unstable so that it gets
more testing?

I (quickly) went through Sashiko's review and most are minor things (OK,
there's one review comment that I want to better check, but still some
testing in mm-unstable has more value).

- Luiz

On 2026-05-29 10:55, Luiz Capitulino wrote:
> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP. In addition, the kernel lacks a well defined API to check for
> PMD-sized page support. It currently relies on has_transparent_hugepage()
> and thp_disabled_by_hw(), but they are not well defined and are tied to
> THP support.
> 
> This series addresses both issues by introducing a new well defined API
> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
> new helper, we ensure that mTHP remains enabled even when the
> architecture or CPU doesn't support PMD-sized pages.
> 
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing guidance (all bugs and misconceptions are mine).
> 
> This applies to Linus tree eb3f4b7426cf ("Merge tag 'nfsd-7.1-2'
> of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux")
> 
> NOTE: I used Claude Code Opus 4.6 to review the series before
> posting. No issues found.
> 
> v5
> --
> - Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
> - Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
> - Added new patch changing shmem_getattr() to set blksize according to
>    highest supported THP order (Baolin)
> - Added new patches to move has_transparent_hugepage() out of
>    CONFIG_TRANSPARENT_HUGEPAGE guards (Sashiko)
> - shmem_allowable_huge_orders(): rename variable and only disable
>    PMD_ORDER (David)
> - Added <linux/jmp_label.h> to include/linux/pgtable.h (Sashiko)
> - Added new tags and removed Reviewed-by from changed patches
> 
> v4
> --
> - Used static key for pgtable_has_pmd_leaves() API (Lance)
> - Moved shmem pgtable_has_pmd_leaves() check to
>    shmem_allowable_huge_orders() (Baolin)
> - Default pgtable_has_pmd_leaves() implementation to
>    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
> 
> v3
> --
> - Rebased on top of latest Linus tree
> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>    with early_param handlers clearing CPU feature flags
> - Fixed build error with CONFIG_MMU=n (kernel test robot)
> - Fixed huge_anon_orders_inherit default setting when !pgtable_pmd_leaves() (Baolin)
> - Small commit changelog improvements
> 
> v2
> --
> - Added support for always enabling mTHPs for shmem (Baolin)
> - Improved commits changelog & added reviewed-by
> 
> v1
> --
> - Call init_arch_has_pmd_leaves() from start_kernel()
> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
> - Clear PUD_ORDER when clearing PMD_ORDER (David)
> - Small changelog improvements (David)
> - Rebased on top of latest mm-new
> 
> Luiz Capitulino (14):
>    docs: tmpfs: remove implementation detail reference
>    mm: shmem: shmem_getattr(): set blksize to highest supported THP order
>    mm: introduce pgtable_has_pmd_leaves()
>    drivers: dax: use pgtable_has_pmd_leaves()
>    drivers: nvdimm: use pgtable_has_pmd_leaves()
>    mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>    mm: shmem: allow THP support determination at folio allocation time
>    s390: move has_transparent_hugepage() out of THP guard
>    powerpc: move has_transparent_hugepage() out of THP guard
>    mips: move has_transparent_hugepage() out of THP guard
>    x86: move has_transparent_hugepage() out of THP guard
>    treewide: introduce arch_has_pmd_leaves()
>    mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>    mm: thp: always enable mTHP support
> 
>   Documentation/filesystems/tmpfs.rst           |  5 ++--
>   arch/mips/include/asm/pgtable.h               |  6 ++--
>   arch/mips/mm/tlb-r4k.c                        |  8 ++---
>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
>   arch/s390/include/asm/pgtable.h               |  6 ++--
>   arch/x86/include/asm/pgtable.h                | 12 ++++----
>   drivers/dax/dax-private.h                     |  2 +-
>   drivers/nvdimm/pfn_devs.c                     |  6 ++--
>   include/linux/huge_mm.h                       |  7 -----
>   include/linux/pgtable.h                       | 20 +++++++++++--
>   mm/debug_vm_pgtable.c                         | 20 ++++++-------
>   mm/huge_memory.c                              | 27 ++++++++++++-----
>   mm/memory.c                                   | 11 ++++++-
>   mm/mm_init.c                                  |  1 +
>   mm/shmem.c                                    | 29 ++++++++++++-------
>   19 files changed, 120 insertions(+), 84 deletions(-)
> 


