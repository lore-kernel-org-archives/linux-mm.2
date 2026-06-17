Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8390BCD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A50B6B0093; Wed, 17 Jun 2026 02:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27C1E6B0095; Wed, 17 Jun 2026 02:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192946B0096; Wed, 17 Jun 2026 02:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E09B96B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:19:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58A35C19FA
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:19:27 +0000 (UTC)
X-FDA: 84888402774.10.15AE800
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53CB64000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:19:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cxdI40M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781677165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSGZG54ikYcCBnOOOwGaMjkA2blH4G7EOyMKvhpeRz0=;
	b=6G8VbzL8KCFU2SPFoSdep+EG48z+dZnS9SM6E7kg/MMWcEcUnLlVuCsQMVVB5EfJgBYNON
	Bh2y4IB2yGsHQ3YIKZiQAkw2m6aueWe2ujSSdKjCQbStEM1lWdX1w18XSL7SNAUQLNRr89
	u1MFieDdVRlEkNIdfl0uZMTOOcpk3AM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cxdI40M6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781677165;
	b=AVXuGxc8qcVX4KiBCpreOM1bnJ05glUQ0Sz38uF4fAQxe0zdLXk+T9yGGjQPV3MsLSWTCq
	EtZbuP/MpPijGTvjv0wMLL/12D/ld1SXWh6z7tSw79qVUV2+aLVEjLFseZBYfkJfDV6p3B
	Pk8BJYcbvKglq0+ztTuHAPq/NIpi1pQ=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5175d339e8bso165091cf.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:19:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781677164; cv=none;
        d=google.com; s=arc-20240605;
        b=QIs4kUA8ZX+6nnexSQyoP07b6HBB/qMtYyWNLRIEwpv/M9t1dzmUtqolczfg8TdK7A
         wKfPTkZ9yHSncLfN7qnQ4V8qqwPrJE7HlEKb2j1hd+9zq580D8xCfgxokZqXOglRGlvf
         A8JWRW4GYk90D+DHm+HZnA7VbjRb65FRceJLXFstHwH5LaHd51v2GcT8F7Q/Y2R8M3+y
         4E82Z1cTCszm28V5szN2n4vmFKqhOZgo36E4sfYd/ilzg3tWLcoLNlJPRfF7eUoJrloI
         dREXpOFFxUp96SG5n2pN7cc03MhfTGoSsZ8Z919onOTBymsPR8psre5XExBqWWv6n//h
         v1/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WSGZG54ikYcCBnOOOwGaMjkA2blH4G7EOyMKvhpeRz0=;
        fh=tdvIgFhMfOtEt9Xo78nJoRZ59qz1MjUJRTJFdERmF6Y=;
        b=RUzg/6WKfpU/riaTm8CSM+4qGRw7eZI4blE2qMf7+wxzR4bHnXB34i9fwcc1mWOHrA
         9Q+uFtMdMvBiWeIVyXCZRWupJsvidAvAYCdlqL2JfJcDVk2WQjiwMKmkOCrcmcr71CNH
         7/34Q9zcgH7WOVs/D0izXqRFp8T+VFGVnZZXy+m65DT1hZWK4Vt7p+zDXgxVxDNucPk0
         onLtCeb3c/3rB3qoEBwtEeOjoWA68CNrz3hSr2UmdWv8MbHgbaAJO+pGxzEWwTXLDpnx
         IzOky1r5Rzd6o0pUVFcgKe1AnjA5EvvVKMKjaM7gPGGIOlsCKzLet30x1mGzHOPRp07W
         Uf2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781677164; x=1782281964; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSGZG54ikYcCBnOOOwGaMjkA2blH4G7EOyMKvhpeRz0=;
        b=cxdI40M6Vz7wyuV28W95ckqMOzANPytr2snW2HizcGKbMUugVxGlMLd415IZkIxRDf
         7Wei47WlDDoWDimPVrBtHQX2YYKZ+0Ki1PRy9FsCyjNBqN4z3FbT3kpPgS0Rqx3eRP7h
         JKK9Dv4ytr80AvnhHorxe1JlsfuXMjBze1AvICwe29UkZ9aT52VzZtRtgrSq7tfNfg5d
         LdD4OM5DyNOPZFOCHMTTl+rcQQGnGZIk6jJpMi8APdfnq0tHcagvS4pJ4u3XKfAsi8+p
         zdJM5C13jb4bdEtUrW4B+uY9JVYBDQHjlhUQ0TKhij3/2pafiIeieNbpO1o6airKprVd
         VPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781677164; x=1782281964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WSGZG54ikYcCBnOOOwGaMjkA2blH4G7EOyMKvhpeRz0=;
        b=o+u9Gh6Rj++0bWLmj4BMJuMQsxPu9THmAWALtODzAKkVQOp0wLjeh8iEI0FndfofKS
         mwNFvr/ogUF7zTg8iOm8dhwRIo7fP6gnoppwgrp1FrvzBnX/AzIFyLsAEzq2Kbb9/FLz
         mYC+DZflJ/X4mogTYe4ujYgTMRlS4P08dCd0ql3MYEkYP4dK8zfQq9xPVo69EPupOau5
         AquXfqpQxHpw2ibDpl1+nltALmYZcGmsCrPJJHS/Pg4AJed88qzujdO+VltnlptGKeTz
         IYklXL9EbO0SOv8Ukb4cPe+H7AfIN3RJUp9WmmrvNfciYPT0UUCN28yfTx5DokKpE8QF
         Ne+w==
X-Forwarded-Encrypted: i=1; AFNElJ+s++kRvoH0UqjLGNwhe9YD9iEwtyxPiqlqqCD/r7bDwDKDMzsbvxfYDqvLig0Ix5SxVfcA+di7dA==@kvack.org
X-Gm-Message-State: AOJu0YxFTydxGYwwsUcT1lV+MHF79uCi/V/J168dTiVq7u9ZygScglc1
	RjvfDfF8v9IG4qSjrDNVBhfrlxa14wG1PPJVvPXl6b/KEh3srzHNJOVjThg4WMzsmwUx4cyEW8q
	Mg0WKKOiUVLxIze97TGVf2xt3VZ/xNBaidgidYXsG
X-Gm-Gg: Acq92OE8mORQWKcJtYHC0GHPVV4daYgN5KUOw1gUmWcKBbjtHqkQwOZ1LW686pOSCut
	tJQu6onGNGomOOdS9pG+nCxLo2jXWhuzoT3t1ZMoF4df8OzZTsFTUL1wmBANxBKSTF2ct92eiyy
	5/vlOnwT62qaViS95Ozpzd7/zaeL7v0rYlsWnwQE9E0+lN4sILb/GCKM4Tcn3cK3HJt4R3U/UCm
	c/QG4UEUuSSPAIzTmJlls380+EXl29Xe8orodixw1rv99ozlApzEwUYVfSruQBGyxYbccU=
X-Received: by 2002:a05:622a:4245:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-519adacad11mr4578591cf.19.1781677163607; Tue, 16 Jun 2026
 23:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260616190300.1509639-1-riel@surriel.com> <20260616190300.1509639-4-riel@surriel.com>
In-Reply-To: <20260616190300.1509639-4-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Jun 2026 23:19:12 -0700
X-Gm-Features: AVVi8CdzQriKoERYHrAxnMkam92_lKmzrBINADC1B_0B1ieMxg-pOvYFTfg2RWc
Message-ID: <CAJuCfpHHkQyj7MMoH++RGraZgQ1Hr+4=T4PfbBn-minUCZyuOQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where possible
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53CB64000D
X-Stat-Signature: f1ydw9m1fqiqdeq3ipy7muenbitsaqm7
X-Rspam-User: 
X-HE-Tag: 1781677165-654322
X-HE-Meta: U2FsdGVkX19LGC7RfQjFPBZNoXRXn8Dcq8uRMF5OLZ108xTXZeWR4E6BO6ob4hJWsRusiJD4eS3eEplAaSMDmQ2G8z5mZKF/RQWh2hy9UXfj4oAlc0fqzjCVDxVW7smj/49I45ca/mR+tIHLeWd5shv5wnQoRBnF0SfkVh9YJ3/r4HrR0RQycmWkOXBuytgo53C944KSqRFE+0naah9DFek//lszaQ9xr+r7jwmtxnylkuBmz56deoaaEQZL27ou6kFxM2dEbGTrXnY8AM3i19oPNl4YzYUgFtQIyyOR6ZHaB6im20imkonc3NDn7Ji17RX4zPqZMilDrC5x0hke4akNoioeMVNEudpH6i16hzC4rwuhjhVhBuq2R8yfG73gv87n5CtQ40lqkArlRfmaNyhIUcKjqd1KsbpAe/yyYeTeO88wKkzOb+boF4GFj/P3e+8cMbg3hCI5FDifgJF4Qf4tN3MoT/CCyFhg7lgv3fBj5gywf6RZ6aei/SY/snQVcGUiNmxU768DDFg62OsOn3K58XELQl6wwicKtS9HanpYBYeIoLZ+SiDmWggPnoE12elYFBGuU0BBkSXTxvPeQyZcpVfepTC5ESaL9k011q6q9IyxliVyMZAMulztdJI+GsAHiOeaWwkem0oSe63EEssip3V0S+ZrR52lJ+LpUPHgK52z/BkagIWafe1OnjXB8FKD3Rx8YFLRSXwkBxXIi6kNWgWagCbqXYYTt2DUITS3a6fcsvxR/lHp2DtxsqyveMKvDUThKVGt9pk8v0l+l7fysbSNV8O66upiBc8vJrbAd7vXQkwbiTBq8mrM4585RfamjvxsCQgdeVO8855aiMb6CnnJLyAPPNh1AwQa+OiEaGek/OJC/+7RY0N4dowzI6eNDQGMUTMK6xFm9V7c0wWY3Htq0PqPw46qyN5S91jotHXsRiWEQiptJPypZ3qWSuSGmTumjAFCtgp4+hN
 1QlQE7v3
 2LErcgayu5jRpDngrZhh6GPP4nXEJKIk1wKPsJmKHJljiB7S3Oo1wxt2DEvpEZcZaJ0eRqOXG7Q13eesaRRLGcjfYBkbDofV1Db2E0IQfwW30LLRgGm6dbzVl4eQX1zqarvqHvfyFpXW9nHPtlOrJC+pNM62PmGSeCY8YoUIvLNBYyFAnhCgBvXOE7tfPGM6mcH2VTsA20qGes2MiIkCLkWhfC4WDFvud9MV2Nr1vY14qaryAuOJlSQn+0zk08XuF2jNAfzmUCWghm5pvPcIBqcSYhHTv4Taasj+k8BDBjAV5+Rt6ICroe4nWkd48tt0wGdQXwHTOam6qIq/LhlNCZmVxEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 12:04=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> __access_remote_vm() takes mmap_read_lock() for the entire transfer and
> uses get_user_pages_remote(), which faults pages in.  For the common
> case of reading memory that is already resident -- /proc/PID/cmdline,
> /proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
> unnecessary and is badly contended on large machines.
>
> Add an opportunistic, read-only fast path that transfers what it can
> without the mmap lock.  For each address it takes the per-VMA lock with
> lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
> folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
> a present page before copying it out.  Anything non-trivial -- a not-
> present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
> a race with a VMA writer -- falls back to the existing mmap_lock path
> for the remainder.

I don't think we should be using per-VMA locks if the read spans
multiple VMAs. Doing that would risk a possibility of reading
inconsistent data since we are locking one VMA at a time. While we
load and read VMA, its neighboring VMA can be unmapped and another one
can be mapped in its place. So, our read spanning both VMAs will
return inconsistent data. access_remote_vm_fast() can check if the
entire read is contained within one VMA and if not, fall back to
mmap_lock.

>
> untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
> for the fast path; the untag mask is a stable per-mm value.
>
> Only reads are handled here; writes keep using the slow path.
>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  arch/x86/include/asm/uaccess_64.h |  12 +++
>  include/linux/uaccess.h           |  11 ++
>  mm/memory.c                       | 166 +++++++++++++++++++++++++++++-
>  3 files changed, 188 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uac=
cess_64.h
> index 4a52497ba6a1..c6fac900a747 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -51,6 +51,18 @@ static inline unsigned long __untagged_addr_remote(str=
uct mm_struct *mm,
>         (__force __typeof__(addr))__untagged_addr_remote(mm, __addr);   \
>  })
>
> +/* Same as __untagged_addr_remote(), but usable without the mmap lock he=
ld. */
> +static inline unsigned long __untagged_addr_remote_unlocked(struct mm_st=
ruct *mm,
> +                                                           unsigned long=
 addr)
> +{
> +       return addr & READ_ONCE((mm)->context.untag_mask);
> +}
> +
> +#define untagged_addr_remote_unlocked(mm, addr)        ({               =
       \
> +       unsigned long __addr =3D (__force unsigned long)(addr);          =
 \
> +       (__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __a=
ddr); \
> +})
> +
>  #endif
>
>  #define valid_user_address(x) \
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 8a264662b242..c8c83372c9d8 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -34,6 +34,17 @@
>  })
>  #endif
>
> +/*
> + * Like untagged_addr_remote(), but for callers that stabilize @mm by ot=
her
> + * means (e.g. a per-VMA lock) and must not assert the mmap lock.
> + */
> +#ifndef untagged_addr_remote_unlocked
> +#define untagged_addr_remote_unlocked(mm, addr)        ({      \
> +       (void)(mm);                                     \
> +       untagged_addr(addr);                            \
> +})
> +#endif
> +
>  #ifdef masked_user_access_begin
>   #define can_do_masked_user_access() 1
>  # ifndef masked_user_write_access_begin
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..0b23b82eaa18 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -42,6 +42,8 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/secretmem.h>
> +#include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sched/numa_balancing.h>
>  #include <linux/sched/task.h>
> @@ -7062,6 +7064,153 @@ int generic_access_phys(struct vm_area_struct *vm=
a, unsigned long addr,
>  EXPORT_SYMBOL_GPL(generic_access_phys);
>  #endif
>
> +/*
> + * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the p=
er-VMA
> + * lock and RCU-freed page tables to walk page tables without the mmap l=
ock.
> + */
> +#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_=
FREE)

Just FYI, Dave Hansen is working on a patchset [1] that removes
CONFIG_PER_VMA_LOCK and makes per-VMA locks always available. This
would simplify this patchset too.

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/

> +/*
> + * Opportunistic lockless fast path for __access_remote_vm() reads.
> + *
> + * Memory already resident in @mm can be read without taking the heavily
> + * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_wal=
k_start()
> + * with FW_VMA_LOCKED grabs a short-lived reference to a present page vi=
a an
> + * RCU/PTL protected page table walk (relying on MMU_GATHER_RCU_TABLE_FR=
EE).
> + *
> + * Anything that would require faulting a page in, touching a hugetlb or
> + * VM_IO/VM_PFNMAP mapping, or that races a VMA writer is left to the mm=
ap_lock
> + * path in __access_remote_vm().  Only reads are handled here.
> + *
> + * Returns the number of bytes transferred via the fast path.
> + */
> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long add=
r,
> +                                void *buf, int len, unsigned int gup_fla=
gs)
> +{
> +       void *old_buf =3D buf;
> +
> +       addr =3D untagged_addr_remote_unlocked(mm, addr);
> +
> +       while (len) {
> +               struct vm_area_struct *vma;
> +               vm_flags_t vm_flags;
> +
> +               vma =3D lock_vma_under_rcu(mm, addr);
> +               if (!vma)
> +                       break;
> +
> +               /*
> +                * Mirror the read-side permission checks of check_vma_fl=
ags(),
> +                * and exclude what FW_VMA_LOCKED cannot handle (hugetlb)=
 or what
> +                * needs the ->access() handler (VM_IO/VM_PFNMAP).  Check=
ed once
> +                * per VMA; anything not positively allowed falls back to=
 the
> +                * slow path, which re-validates everything.
> +                */
> +               vm_flags =3D vma->vm_flags;
> +               if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
> +                   is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
> +                   (!(vm_flags & VM_READ) &&
> +                    (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREA=
D)))) {
> +                       vma_end_read(vma);
> +                       break;
> +               }
> +
> +               /*
> +                * Copy as much of this VMA as we can without re-acquirin=
g the
> +                * per-VMA lock; re-lock only when @addr leaves the VMA.
> +                */
> +               while (len && addr < vma->vm_end) {
> +                       struct folio_walk fw;
> +                       struct folio *folio;
> +                       struct page *page;
> +                       unsigned long entry_size, entry_left, folio_left,=
 span;
> +                       unsigned long copied, idx0;
> +                       int offset;
> +
> +                       folio =3D folio_walk_start(&fw, vma, addr, FW_VMA=
_LOCKED);
> +                       if (!folio) {
> +                               vma_end_read(vma);
> +                               goto out;
> +                       }
> +                       page =3D fw.page;
> +                       if (!page) {
> +                               folio_walk_end(&fw, vma);
> +                               vma_end_read(vma);
> +                               goto out;
> +                       }
> +                       /* Pin the folio so it stays valid after the PTL =
is dropped. */
> +                       folio_get(folio);
> +                       folio_walk_end(&fw, vma);
> +
> +                       /*
> +                        * folio_walk_start() validated exactly one mappi=
ng entry,
> +                        * which covers a contiguous, present run of this=
 folio:
> +                        * PAGE_SIZE for a pte, PMD_SIZE for a pmd leaf, =
PUD_SIZE
> +                        * for a pud leaf.  Copy up to the end of that en=
try,
> +                        * bounded by the folio, the VMA and len, so a hu=
ge mapping
> +                        * is handled in one walk instead of per page.
> +                        */
> +                       offset =3D offset_in_page(addr);
> +                       switch (fw.level) {
> +                       case FW_LEVEL_PUD:
> +                               entry_size =3D PUD_SIZE;
> +                               break;
> +                       case FW_LEVEL_PMD:
> +                               entry_size =3D PMD_SIZE;
> +                               break;
> +                       default:
> +                               entry_size =3D PAGE_SIZE;
> +                               break;
> +                       }
> +                       entry_left =3D entry_size - (addr & (entry_size -=
 1));
> +                       idx0 =3D folio_page_idx(folio, page);
> +                       folio_left =3D ((folio_nr_pages(folio) - idx0) <<=
 PAGE_SHIFT) -
> +                                    offset;
> +                       span =3D min3((unsigned long)len, entry_left, fol=
io_left);
> +                       span =3D min(span, vma->vm_end - addr);
> +
> +                       /*
> +                        * Copy the span page-by-page: kmap_local_folio()=
 maps one
> +                        * page on HIGHMEM and copy_from_user_page() flus=
hes per
> +                        * page on aliasing caches, but the page tables a=
re not
> +                        * re-walked.  The span borrows the single folio =
reference
> +                        * taken above, so each mapping is dropped with
> +                        * kunmap_local() (not folio_release_kmap(), whic=
h would
> +                        * also drop a folio reference per page).
> +                        */
> +                       for (copied =3D 0; copied < span; ) {
> +                               unsigned long foff =3D offset + copied;
> +                               unsigned long pidx =3D idx0 + (foff >> PA=
GE_SHIFT);
> +                               int poff =3D foff & ~PAGE_MASK;
> +                               int chunk =3D min_t(unsigned long, span -=
 copied,
> +                                                 PAGE_SIZE - poff);
> +                               void *maddr =3D kmap_local_folio(folio,
> +                                               pidx << PAGE_SHIFT);
> +
> +                               copy_from_user_page(vma, folio_page(folio=
, pidx),
> +                                                   addr + copied, buf + =
copied,
> +                                                   maddr + poff, chunk);
> +                               kunmap_local(maddr);
> +                               copied +=3D chunk;
> +                       }
> +
> +                       folio_put(folio);
> +                       len -=3D span;
> +                       buf +=3D span;
> +                       addr +=3D span;
> +               }
> +               vma_end_read(vma);
> +       }
> +out:
> +       return buf - old_buf;
> +}
> +#else
> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long add=
r,
> +                                void *buf, int len, unsigned int gup_fla=
gs)
> +{
> +       return 0;
> +}
> +#endif /* CONFIG_PER_VMA_LOCK && CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> +
>  /*
>   * Access another process' address space as given in mm.
>   */
> @@ -7071,8 +7220,23 @@ static int __access_remote_vm(struct mm_struct *mm=
, unsigned long addr,
>         void *old_buf =3D buf;
>         int write =3D gup_flags & FOLL_WRITE;
>
> +       /*
> +        * Try the lockless fast path for reads first; it transfers what =
it can
> +        * from resident memory without taking mmap_lock, and leaves the
> +        * remainder (if any) to the slow path below.
> +        */
> +       if (!write) {
> +               int done =3D access_remote_vm_fast(mm, addr, buf, len, gu=
p_flags);
> +
> +               addr +=3D done;
> +               buf +=3D done;
> +               len -=3D done;
> +               if (!len)
> +                       return buf - old_buf;
> +       }
> +
>         if (mmap_read_lock_killable(mm))
> -               return 0;
> +               return buf - old_buf;
>
>         /* Untag the address before looking up the VMA */
>         addr =3D untagged_addr_remote(mm, addr);
> --
> 2.53.0-Meta
>

