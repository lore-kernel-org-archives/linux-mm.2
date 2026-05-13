Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88267CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 21:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F2C6B0005; Wed, 13 May 2026 17:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17156B0088; Wed, 13 May 2026 17:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D9B6B008A; Wed, 13 May 2026 17:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1FB56B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:04:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 455FE1401F5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:04:05 +0000 (UTC)
X-FDA: 84763624050.08.679495A
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 418D12000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:04:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H7ZyNZ3N;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778706243; a=rsa-sha256;
	cv=pass;
	b=L9dMUWJkaEVpav2ES5LmV4Ieehnt/inTASCgxxYRPfdzoMrvqf+UbJwSlxsdAJxNqIB8Ey
	qUH3qf3ktgklhQ5dxZOwUyw/4BkY+MT7DAWKFxcLsOhyQJOS4kA5Sbfqn0G2eeysQiYur4
	FsMuxAlmWwdtcIo7yKGfWqPeKrMOIB0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H7ZyNZ3N;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778706243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWiirTpDAOO55PdeiWg+IyFFofYhz8NY9pIJk7tt108=;
	b=FJbLVkcUgyrOi2/mAA0m7wmEx6f9yYTWqdgqWy/qqaasVXlQhFc0bSbtIJlmbWm4j7w+fV
	c19MGDTQFkZsgrbqR7OffiQS3X5oX5sl/w026HbzKE0SYrbWMfgvdjRz7ZZ5zb3mTywATs
	AQil5a40WoMkMHyInKPhdZBO5hbI0Jk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d864c23bdso37721cf.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 14:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778706242; cv=none;
        d=google.com; s=arc-20240605;
        b=YUAHNOh4GAArp9a17K7oSKykU1k5ewtsUHav9nHcWFutDiFjlYYgMmgH1wxCFJ5wf3
         FHk5qSVRwvSwJkmCDu2lHaXugTQFE3hQM4LdBcnc1H9tFB8wUTCdXMJE7mioE9TVfbhx
         bfhocQM3jkWDHtWcCkHw/bcU2gHzuYMjvEFfvjlonpRZJEoh+OXZRLGd4/4cjCV7kVlu
         1qwWkDLpWdQvouVE+CmMIVLpn7Ac4MSVgRSRLZNEaoAvW+8lBpd2mAeaN+20mE8b/OV1
         5W+UEmKa4s3nRb55F+s3FIT/MewbM+2ppOu4zDdADZKOZTorD8jhj9UW8zUnjXxh/2gh
         IpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CWiirTpDAOO55PdeiWg+IyFFofYhz8NY9pIJk7tt108=;
        fh=R8Pd1qKUBHq+4n0jRmKah12wCpmX9n40an252I6YEwQ=;
        b=M8O2yLpv+E3MY5YXOPrEoqqjEdX4PlZcxTpM0jQRJaqWMKgEu8RuPOr0WWPA+4cTcv
         D3VVWF289I78onyqyWs7y0conbZ+l33VU4+79Nb20FGv4f55a3pickdp+U0uTLuTy6fl
         HCmoh4rk0J8eIfo0inykr2oB5zC8fPnMqg8l8gQaGPejfndupidbBRkN9n4zuvUeuOmA
         JUNN5G3iNybHf4KWAUigNFMpg/AUz6u7iC2bJ29OQoE01CBqYofVlROJ/ZzAQGDToXef
         1xRdRY1aIyd0IUFMq6L/mdtP9huLyJ4yCikHZ/8kuLQfvUhtZToFFd50EzRWBkpAO/2D
         8wDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778706242; x=1779311042; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWiirTpDAOO55PdeiWg+IyFFofYhz8NY9pIJk7tt108=;
        b=H7ZyNZ3NyGd6qbkASW3f9JMzUy52RCuj/lHYqXI75AZ06UNV9T8O8v2j5NowY7zs71
         0pxCSpYu2IUYArl98wbMOETCaU8l1+VvUjE+bYHGQGNyUAx1oc9NGoR4sbXD2bTRrgIV
         4ILhhp5SAK5Masj3RVx1t56F3Rov7h/eqhq2QECtVTCl5dAs8a+vDUv19uOp3eUSUMsb
         znRSKe+7yMNWTI+kLQylBUv9P+t0UzLheqvgHpsJ8j9WUe8129Wl9dgXyaFVcnq2K4iN
         upAztw4IyPbwB/9J2rpJwiyrEWB+I7o3eob6JK6xT9XUMgKzRt9vTdN4YJMsKNAoy6+J
         KM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778706242; x=1779311042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CWiirTpDAOO55PdeiWg+IyFFofYhz8NY9pIJk7tt108=;
        b=K91XX5UrasduNc8PTs+O2xxxwLCg4lN4+F1x8gHkA2FPrqt4Y8dzSDvsZCxU1qhlmc
         9yfODni4JC8Q2oFnjDdhQyERYUv1enHl7IOCOQPg/QBus1WQ7ap3Ll3/pfuUbcF7RmQl
         IHL2e1ViC1x8Py+2nZmFiOFvR+BsbG2UnFjhhkPlOkwEUTanxZek7oJyJEHjXvPKZTt2
         RUoK8c9dhoHwOYgFaTqqOCTHlVDWQsjyo54gP68nBj6Fr2+9HBdmfJdbJiiIQOZ63QdG
         yxyZtfKs47RbqcknjDejpRU+8BRhRfHrj1X6tnCzCyqY3Qa/a/Z7P7KnoUaroXeWAsku
         YxdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vgByxhlnoGdbfy09PWk4ahy9Io62EBTSS89P3DIhXKx3G0GIwui/dHbIC3xppmeTgIC4BBuwxHw==@kvack.org
X-Gm-Message-State: AOJu0YwwNZYkcCJUhyLA3OvcCFi/YeSF6yPKRPwUKi9kBQ/olRGZjT+X
	jwj4qAkzkxlhd8sRYk+KbyZv9qkhZzt8FHijdHMGlkgBTShlSr3MhRa4yxH2GzlP7IMapdCVAHg
	ySCptIpLoERVPncXOnKNqAUzoU/t0HehMJIo/GtaV
X-Gm-Gg: Acq92OFHXLpJJDsyt7NrBjRFk8xL9JCm/SWCyHZ68iUNQpa8WCto6v2Yjxf0fL/MOlC
	aZp1dRtSqnSoNJ4zJHEdFIIryHYLHq7KefcrmBMG6SiAVff8c5C4wui85ypgu9cONRdWqGJpPjM
	25+YPs/JLJXpiXO+546ophJwiDnCEgKLSrw47Eexw1P4bmnCsCU2I/+OoBaeMHS/BtnYrEinA2s
	Rtr+AYzc5BMwEanA5/IRIpvJzfNEUTFyQj1maPeFs6D0nf0RaKOjG7zgQXH+5RuxRcZb25GKZ9Q
	rAU95zY7Oh8E5VaBRMXgSFbmN6Y5EhrNaMkMUEwXVLX+rRFi
X-Received: by 2002:a05:622a:a917:b0:516:3b3c:1df2 with SMTP id
 d75a77b69052e-516423965d5mr3249641cf.14.1778706241512; Wed, 13 May 2026
 14:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com> <20260429181955.0C443845@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181955.0C443845@davehans-spike.ostc.intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 14:03:50 -0700
X-Gm-Features: AVHnY4LEklJNAayQfG9qzTBEVA1JVfwI7mzcfLiF1hkGLsAdq-Y3bqKl7LhtrXw
Message-ID: <CAJuCfpFjPCTiwXFrdj+HftJLcHs9=bVzau10HqjSHDXfmzz2ig@mail.gmail.com>
Subject: Re: [PATCH 1/6] mm: Make per-VMA locks available universally
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pie8aejg9ifoecjhbfxfozrarbb8cjwb
X-Rspam-User: 
X-Rspamd-Queue-Id: 418D12000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778706243-884887
X-HE-Meta: U2FsdGVkX1/JGvdXinGtmj1kKUY+EV20gvggXKeKLJfiQoPbxEV/OzPrqyHtkEKFYFyaIvr94weDn+mVb8f5jiGqyjdka5biPowcsntcOv5ocIgFI/7Sk0IM/2DswQfiGFbepq3ZZHaobpoysiaMKLv3s03ByG1inHegn2HtDpJ4q3Z8k9NQsj4Vxhl/tdW5aHTj1SX0DnNvx7plyfltiMWlqGzUwbVx7vn6elcmT5Fv646Cj3R3fxNeTKZGGtnNXTea+aG8MozIWjmanmvpc9TRnf+1R/2ELGAauwH9Z8CPsnM69J1+BKCxAe/qprFQDxioeALhe1u9UDUXXC9ze0zmIufYsWK7BzRpyOgTNxJSQmmoW/0+EnRvw6RWDtdDt193cu95buCXfB88htDFFbt3qSGGwQ1oIV9Bf+/NRXwOkQL0iDAdYAn3CUBoccOxic5ddZPMJccl3yYsIB4rSaoe4c2K2cVuOiBmQ1mSw3NZDADObX7igSwlzw9sHNXt/PZ9LWSMbANq+M8Uy4cMQ1ERXNVIQXH97Q7PCaszU5Ge7FXxmfBhoBog+aIRml+YCts3neEiEK2HZgMiEyhmiSanG+1tUUto64WNcJ/4pzSSSwFjrPz31xW4WctZygm35LBulnYqMrnDsdd8HPdL22lUCHyTUTj6Y4WHUoFOriLAbhv6mgnFawoVHNxsxm0cTNnq0BUXAdzYauPWIeczawUIhwScnos0Sc3gBsa1y/u1Qp3oE5pABQBkDiTonnuTpbsUxqPxIP6EHdag3dXFP0629/dzcg4rujg5db7Y06itghrFapiJ6W1yRzRrvnnMMeqjexzdBIgcjakTUye2TCCMnOkGh8PM8KCccIE2N0vkFsOGdUcmXWkNSV9JgCEDbqOtXS/JWcJXVzbt6Kn4eqn8hbgL1IcNAOjWeY9RMVXvymybB4w1GseL5rZqh3xKKWUrpGzwXi4GUktjkvq
 gkmD5BV0
 GDS82P74j54+nBQxvAu8HQCurHar9Z2327SGj+D8oB3FYqTLz/GxDtt082KSpyzIPZvE2sh+jd6U2TdRfstQVqwA2qPMuIlTRl5nde5xgZEHIv9DxAlDdrs85tqc7x6PmDjSySM3CiXWUvRFmjiisyDJbfzgAABZJYDMa7o5x8naWmOXGiJu/kZSTDDPy31kbTFrFMN6gr6Syovcf6YLyrQCIzbwSh+MDNfDLg/D7US0Ek3ObqZOqSg63KA4mC/oHNF8kRjsuzhchottjdX3JKSvrmoYSl538gboD2K0MtiCtBN7/N7NjmLdLncSX5eilpnAuxjN0O6LYUrTp66sDgLHwjsZP7nDLORBbv7HEoPW4Lw23m+BEfI3SRhEECUD3VmI2ClkUMHkKtRtR7mN4VrXCC+RLSOYRHINnmRMNoU3U8mrX6OUyyKMRpU+4CSDLykv5+wADmrw5T4u3kBstXH8iloQ+pRjOpwayWLPGqlW0MkLa60yHBlcJnRID88zqqd3edMhNd8YKVjaOH7Bhfn7eUH1+QMYWVe620ol6a+xcAGbEqFvr8tNb7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:19=E2=80=AFAM Dave Hansen
<dave.hansen@linux.intel.com> wrote:
>
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
>
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
>
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
>
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* can bring additional
> simplifications.
>
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. I suspect there are some very simple ways to implement the
> per-VMA locks that don't require any additional fields, especially if
> such an approach was limited to SMP=3Dn configs*. For now, do the
> simplest thing: use the same implementation everywhere.
>
>  * For example, since SMP=3Dn configs don't care much about scalability o=
r
>    false sharing, there could be a single, global VMA seqcount that is
>    bumped when any VMA is modified instead of having space in each VMA
>    for a seqcount.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>
>  b/arch/arm/Kconfig                       |    1
>  b/arch/arm64/Kconfig                     |    1
>  b/arch/loongarch/Kconfig                 |    1
>  b/arch/powerpc/platforms/powernv/Kconfig |    1
>  b/arch/powerpc/platforms/pseries/Kconfig |    1
>  b/arch/riscv/Kconfig                     |    1
>  b/arch/s390/Kconfig                      |    1
>  b/arch/x86/Kconfig                       |    2 -
>  b/fs/proc/internal.h                     |    2 -
>  b/fs/proc/task_mmu.c                     |   51 ------------------------=
-------
>  b/include/linux/mm.h                     |   12 -------
>  b/include/linux/mm_types.h               |    7 ----
>  b/include/linux/mmap_lock.h              |   48 ------------------------=
-----
>  b/kernel/fork.c                          |    2 -
>  b/mm/Kconfig                             |   13 -------
>  b/mm/mmap_lock.c                         |    2 -
>  16 files changed, 1 insertion(+), 145 deletions(-)
>
> diff -puN arch/arm64/Kconfig~unconditional-vma-locks arch/arm64/Kconfig
> --- a/arch/arm64/Kconfig~unconditional-vma-locks        2026-04-29 11:18:=
47.795519653 -0700
> +++ b/arch/arm64/Kconfig        2026-04-29 11:18:49.088569421 -0700
> @@ -80,7 +80,6 @@ config ARM64
>         select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT
> diff -puN arch/arm/Kconfig~unconditional-vma-locks arch/arm/Kconfig
> --- a/arch/arm/Kconfig~unconditional-vma-locks  2026-04-29 11:18:47.91552=
4272 -0700
> +++ b/arch/arm/Kconfig  2026-04-29 11:18:49.088569421 -0700
> @@ -41,7 +41,6 @@ config ARM
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select ARCH_SUPPORTS_CFI
>         select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
> diff -puN arch/loongarch/Kconfig~unconditional-vma-locks arch/loongarch/K=
config
> --- a/arch/loongarch/Kconfig~unconditional-vma-locks    2026-04-29 11:18:=
47.956525850 -0700
> +++ b/arch/loongarch/Kconfig    2026-04-29 11:18:49.088569421 -0700
> @@ -68,7 +68,6 @@ config LOONGARCH
>         select ARCH_SUPPORTS_LTO_CLANG_THIN
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT if SMP
>         select ARCH_SUPPORTS_SCHED_MC  if SMP
> diff -puN arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks =
arch/powerpc/platforms/powernv/Kconfig
> --- a/arch/powerpc/platforms/powernv/Kconfig~unconditional-vma-locks    2=
026-04-29 11:18:47.969526350 -0700
> +++ b/arch/powerpc/platforms/powernv/Kconfig    2026-04-29 11:18:49.08956=
9460 -0700
> @@ -17,7 +17,6 @@ config PPC_POWERNV
>         select PPC_DOORBELL
>         select MMU_NOTIFIER
>         select FORCE_SMP
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff -puN arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks =
arch/powerpc/platforms/pseries/Kconfig
> --- a/arch/powerpc/platforms/pseries/Kconfig~unconditional-vma-locks    2=
026-04-29 11:18:47.972526466 -0700
> +++ b/arch/powerpc/platforms/pseries/Kconfig    2026-04-29 11:18:49.08956=
9460 -0700
> @@ -23,7 +23,6 @@ config PPC_PSERIES
>         select HOTPLUG_CPU
>         select FORCE_SMP
>         select SWIOTLB
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff -puN arch/riscv/Kconfig~unconditional-vma-locks arch/riscv/Kconfig
> --- a/arch/riscv/Kconfig~unconditional-vma-locks        2026-04-29 11:18:=
48.060529854 -0700
> +++ b/arch/riscv/Kconfig        2026-04-29 11:18:49.089569460 -0700
> @@ -70,7 +70,6 @@ config RISCV
>         select ARCH_SUPPORTS_LTO_CLANG_THIN
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> -       select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
>         select ARCH_SUPPORTS_SCHED_MC if SMP
> diff -puN arch/s390/Kconfig~unconditional-vma-locks arch/s390/Kconfig
> --- a/arch/s390/Kconfig~unconditional-vma-locks 2026-04-29 11:18:48.12553=
2357 -0700
> +++ b/arch/s390/Kconfig 2026-04-29 11:18:49.089569460 -0700
> @@ -153,7 +153,6 @@ config S390
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
>         select ARCH_USE_SYM_ANNOTATIONS
> diff -puN arch/x86/Kconfig~unconditional-vma-locks arch/x86/Kconfig
> --- a/arch/x86/Kconfig~unconditional-vma-locks  2026-04-29 11:18:48.12853=
2472 -0700
> +++ b/arch/x86/Kconfig  2026-04-29 11:18:49.090569499 -0700
> @@ -27,7 +27,6 @@ config X86_64
>         select ARCH_HAS_GIGANTIC_PAGE
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select HAVE_ARCH_SOFT_DIRTY
>         select MODULES_USE_ELF_RELA
> @@ -1885,7 +1884,6 @@ config X86_USER_SHADOW_STACK
>         bool "X86 userspace shadow stack"
>         depends on AS_WRUSS
>         depends on X86_64
> -       depends on PER_VMA_LOCK
>         select ARCH_USES_HIGH_VMA_FLAGS
>         select ARCH_HAS_USER_SHADOW_STACK
>         select X86_CET
> diff -puN fs/proc/internal.h~unconditional-vma-locks fs/proc/internal.h
> --- a/fs/proc/internal.h~unconditional-vma-locks        2026-04-29 11:18:=
48.305539283 -0700
> +++ b/fs/proc/internal.h        2026-04-29 11:18:49.090569499 -0700
> @@ -382,10 +382,8 @@ struct mem_size_stats;
>
>  struct proc_maps_locking_ctx {
>         struct mm_struct *mm;
> -#ifdef CONFIG_PER_VMA_LOCK
>         bool mmap_locked;
>         struct vm_area_struct *locked_vma;
> -#endif
>  };
>
>  struct proc_maps_private {
> diff -puN fs/proc/task_mmu.c~unconditional-vma-locks fs/proc/task_mmu.c
> --- a/fs/proc/task_mmu.c~unconditional-vma-locks        2026-04-29 11:18:=
48.346540861 -0700
> +++ b/fs/proc/task_mmu.c        2026-04-29 11:18:49.090569499 -0700
> @@ -130,8 +130,6 @@ static void release_task_mempolicy(struc
>  }
>  #endif
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         lock_ctx->locked_vma =3D NULL;
> @@ -213,33 +211,6 @@ static inline bool fallback_to_mmap_lock
>         return true;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline bool lock_vma_range(struct seq_file *m,
> -                                 struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm) =3D=3D 0;
> -}
> -
> -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_c=
tx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *get_next_vma(struct proc_maps_private *pri=
v,
> -                                          loff_t last_pos)
> -{
> -       return vma_next(&priv->iter);
> -}
> -
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> -                                        loff_t pos)
> -{
> -       return false;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -

After this change I'll need to review the resulting code and see if we
can simplify the code even more because many of these helper functions
were split because of the CONFIG_PER_VMA_LOCK. But that's a discussion
for another day/patchset.

>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *p=
pos)
>  {
>         struct proc_maps_private *priv =3D m->private;
> @@ -527,8 +498,6 @@ static int pid_maps_open(struct inode *i
>                 PROCMAP_QUERY_VMA_FLAGS                         \
>  )
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         reset_lock_ctx(lock_ctx);
> @@ -581,26 +550,6 @@ static struct vm_area_struct *query_vma_
>         return vma;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_lo=
cking_ctx *lock_ctx,
> -                                                    unsigned long addr)
> -{
> -       return find_vma(lock_ctx->mm, addr);
> -}
> -
> -#endif  /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *query_matching_vma(struct proc_maps_lockin=
g_ctx *lock_ctx,
>                                                  unsigned long addr, u32 =
flags)
>  {
> diff -puN include/linux/mmap_lock.h~unconditional-vma-locks include/linux=
/mmap_lock.h
> --- a/include/linux/mmap_lock.h~unconditional-vma-locks 2026-04-29 11:18:=
48.700554487 -0700
> +++ b/include/linux/mmap_lock.h 2026-04-29 11:18:49.091569537 -0700
> @@ -76,8 +76,6 @@ static inline void mmap_assert_write_loc
>         rwsem_assert_held_write(&mm->mmap_lock);
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  #ifdef CONFIG_LOCKDEP
>  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
>  #else
> @@ -484,52 +482,6 @@ struct vm_area_struct *lock_next_vma(str
>                                      struct vma_iterator *iter,
>                                      unsigned long address);
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> -
> -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, u=
nsigned int *seq)
> -{
> -       return false;
> -}
> -
> -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsig=
ned int seq)
> -{
> -       return true;
> -}
> -static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_=
refcnt) {}
> -static inline void vma_end_read(struct vm_area_struct *vma) {}
> -static inline void vma_start_write(struct vm_area_struct *vma) {}
> -static inline __must_check
> -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> -               { mmap_assert_write_locked(vma->vm_mm); }
> -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> -
> -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct=
 *mm,
> -               unsigned long address)
> -{
> -       return NULL;
> -}
> -
> -static inline void vma_assert_locked(struct vm_area_struct *vma)
> -{
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> -{
> -       /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static inline void mmap_write_lock(struct mm_struct *mm)
>  {
>         __mmap_lock_trace_start_locking(mm, true);
> diff -puN include/linux/mm.h~unconditional-vma-locks include/linux/mm.h
> --- a/include/linux/mm.h~unconditional-vma-locks        2026-04-29 11:18:=
48.714555026 -0700
> +++ b/include/linux/mm.h        2026-04-29 11:18:49.091569537 -0700
> @@ -890,7 +890,6 @@ static inline void vma_numab_state_free(
>   * These must be here rather than mmap_lock.h as dependent on vm_fault t=
ype,
>   * declared in this header.
>   */
> -#ifdef CONFIG_PER_VMA_LOCK
>  static inline void release_fault_lock(struct vm_fault *vmf)
>  {
>         if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> @@ -906,17 +905,6 @@ static inline void assert_fault_locked(c
>         else
>                 mmap_assert_locked(vmf->vma->vm_mm);
>  }
> -#else
> -static inline void release_fault_lock(struct vm_fault *vmf)
> -{
> -       mmap_read_unlock(vmf->vma->vm_mm);
> -}
> -
> -static inline void assert_fault_locked(const struct vm_fault *vmf)
> -{
> -       mmap_assert_locked(vmf->vma->vm_mm);
> -}
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>  {
> diff -puN include/linux/mm_types.h~unconditional-vma-locks include/linux/=
mm_types.h
> --- a/include/linux/mm_types.h~unconditional-vma-locks  2026-04-29 11:18:=
48.761556836 -0700
> +++ b/include/linux/mm_types.h  2026-04-29 11:18:49.092569576 -0700
> @@ -959,7 +959,6 @@ struct vm_area_struct {
>                 vma_flags_t flags;
>         };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> @@ -975,7 +974,7 @@ struct vm_area_struct {
>          * slowpath.
>          */
>         unsigned int vm_lock_seq;
> -#endif
> +
>         /*
>          * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_v=
ma
>          * list, after a COW of one of the file pages.  A MAP_SHARED vma
> @@ -1007,7 +1006,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Used to keep track of firstly, whether the VMA is attached, se=
condly,
>          * if attached, how many read locks are taken, and thirdly, if th=
e
> @@ -1050,7 +1048,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map vmlock_dep_map;
>  #endif
> -#endif
>         /*
>          * For areas with an address space and backing store,
>          * linkage into the address_space->i_mmap interval tree.
> @@ -1249,7 +1246,6 @@ struct mm_struct {
>                                           * init_mm.mmlist, and are prote=
cted
>                                           * by mmlist_lock
>                                           */
> -#ifdef CONFIG_PER_VMA_LOCK
>                 struct rcuwait vma_writer_wait;
>                 /*
>                  * This field has lock-like semantics, meaning it is some=
times
> @@ -1269,7 +1265,6 @@ struct mm_struct {
>                  * mmap_lock.
>                  */
>                 seqcount_t mm_lock_seq;
> -#endif
>  #ifdef CONFIG_FUTEX_PRIVATE_HASH
>                 struct mutex                    futex_hash_lock;
>                 struct futex_private_hash       __rcu *futex_phash;
> diff -puN kernel/fork.c~unconditional-vma-locks kernel/fork.c
> --- a/kernel/fork.c~unconditional-vma-locks     2026-04-29 11:18:48.77455=
7336 -0700
> +++ b/kernel/fork.c     2026-04-29 11:18:49.092569576 -0700
> @@ -1067,9 +1067,7 @@ static void mmap_init_lock(struct mm_str
>  {
>         init_rwsem(&mm->mmap_lock);
>         mm_lock_seqcount_init(mm);
> -#ifdef CONFIG_PER_VMA_LOCK
>         rcuwait_init(&mm->vma_writer_wait);
> -#endif
>  }
>
>  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struc=
t *p,
> diff -puN mm/Kconfig~unconditional-vma-locks mm/Kconfig
> --- a/mm/Kconfig~unconditional-vma-locks        2026-04-29 11:18:48.83855=
9801 -0700
> +++ b/mm/Kconfig        2026-04-29 11:18:49.093569614 -0700
> @@ -1394,19 +1394,6 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>         def_bool y
>         depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> -# }
> -
> -config ARCH_SUPPORTS_PER_VMA_LOCK
> -       def_bool n
> -
> -config PER_VMA_LOCK
> -       def_bool y
> -       depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> -       help
> -         Allow per-vma locking during page fault handling.
> -
> -         This feature allows locking each virtual memory area separately=
 when
> -         handling page faults instead of taking mmap_lock.
>
>  config LOCK_MM_AND_FIND_VMA
>         bool
> diff -puN mm/mmap_lock.c~unconditional-vma-locks mm/mmap_lock.c
> --- a/mm/mmap_lock.c~unconditional-vma-locks    2026-04-29 11:18:49.08456=
9267 -0700
> +++ b/mm/mmap_lock.c    2026-04-29 11:18:49.093569614 -0700
> @@ -44,7 +44,6 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
>  #endif /* CONFIG_TRACING */
>
>  #ifdef CONFIG_MMU
> -#ifdef CONFIG_PER_VMA_LOCK
>
>  /* State shared across __vma_[start, end]_exclude_readers. */
>  struct vma_exclude_readers_state {
> @@ -431,7 +430,6 @@ fallback:
>
>         return vma;
>  }
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
>  #include <linux/extable.h>
> _

