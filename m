Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D5DCE7B12
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1748E0014; Fri, 14 Nov 2025 09:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199138E0002; Fri, 14 Nov 2025 09:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D65E8E0014; Fri, 14 Nov 2025 09:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0AAF8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:18:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 993291A03B1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:18:12 +0000 (UTC)
X-FDA: 84109417224.13.B2CFE46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8FFF04000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:18:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6kGJMPG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763129890; a=rsa-sha256;
	cv=none;
	b=T/pMB+g+BP4skAwIDwDw3d2bVgDbIrSNCLQv78HRUFao/Y6/2YcvHteVfIpkkbyZ2xd9wH
	Smx+AQ0DSb0kK8hbM89vrvRy0GHWBCXVhJFdLVZeOzNoy/WaBsOK6vAEgyD208faEQRMtN
	0vjXa205kjWNkNaz+e0uucSe3blzIeQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p6kGJMPG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763129890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5k7JH94TxtMFEloEdFAxJN0t9UEXRCPKt9CyNpRt0Q=;
	b=7bpKScBui2HscFRYUDgpqm2wgdsly7v0hgylclP46Ua1Og/o1RBdPssksIcZISNCBdMKyL
	DMuChPJhoBCKCk1ya5P2sC3dfSJqT79oGEElUE0aoO+vKj8CJXB4oTuxf4kgbMDaGZpnM5
	jxqFlzcUNuEXBSuoy6s8a6vva1UOy5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 400F6440CF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20ECBC2BCB1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763129889;
	bh=FAWHKTbojrVdbFJ8884Lh9DTaMatsBJR+ahGaIp46Mc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p6kGJMPGPO4zhpMUmlK1tkVdWLKi0QGIypBU+p95zDqcd+pZowWKhEf6ejWqW4yoZ
	 ppDZobHsg4oFBstR9nfLvP7LotZhd03W0gLFcgXkdbIl9gzSd8NzEtcmAKiX8JNkEq
	 AkfuN0V/0mNO/ac65VkYiv5phg2ILI8Y4QOjMVL4KPqgSEuDas+wGNlmtQk/xTdxZB
	 LAhoMr1qcbKLx+FqvqyKVAQfLmhOZ+LqeNleJvo7L9SmaaqrZwafDKouEuEOKyWY8A
	 bjynM/Z2VdSW/VCRw9yYO3zav1+Un7AYJtdn5oQHqA28L5S0Dgb0JOQortqUBXJCOk
	 6QZCfGCd7yKPQ==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so3172483a12.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:18:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWSZex0yGIhA7uTQlO90+lH+4IyUyUmWOrKOXZ1GlSeixQgYX8W2305+0EyBOMy05JQ7xVV45ytgg==@kvack.org
X-Gm-Message-State: AOJu0YyKjeMuPihhn0jJbDWK2huDx/nCs+EnkkpYCJCpME5Xk31Qux1C
	X20znzgTSXI0cQsrFkoN2psDPQaNOScKIpJQ6Q4GF7cLX/UJFQYqqF2gbnGribg5ms5k2BDgCNJ
	qk94LJKqKlv8NK54C3sXDmbEqnYY1BQA=
X-Google-Smtp-Source: AGHT+IH2APpWlx01lvRmsEjk25T/BroXvRMmdJoqcqdhkk/l43ih7kDnYxsJFdqG1+mvDKp0yNH6Z0TrYw4LGkrxjmI=
X-Received: by 2002:a17:907:748:b0:b70:b661:cfcb with SMTP id
 a640c23a62f3a-b73678ee3a8mr261903966b.31.1763129887364; Fri, 14 Nov 2025
 06:18:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1763117269.git.zhengqi.arch@bytedance.com> <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
In-Reply-To: <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 14 Nov 2025 22:17:55 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
X-Gm-Features: AWmQ_bnB_yOPM8We43AKxCyF0R_mmEJVAbU9qloFW-YqOpGJ4QJ0yARhVtFDLLs
Message-ID: <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
Subject: Re: [PATCH 3/7] loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com, 
	peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org, 
	david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>, 
	WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8FFF04000C
X-Stat-Signature: f6pmcdf79gcpxnyp48t47wh4jx3wuggn
X-Rspam-User: 
X-HE-Tag: 1763129890-204546
X-HE-Meta: U2FsdGVkX1/BC4E5bHCAfWewVAskmbTOd/Jt8ybDOVqv66MPxBEMpSuZIlMZKOAhLkVvkO9Oroaa1tdCL7itK1s1ykedew/+TtbxaVYKp/ciZtogevoT84KQ7TNk4trg9xeHZE2ehcFIhvCnFWjrgx9MG4L3yipJ29chXfPTGC5rp/HPNxzE2ewsTEnfnVGrqVzVYQiAnQrel2aoJLZep2g7vAVhIoS38H+VY+rcK8mcINe5GbA/FT6RijG0zy/bAoldpAEc8lYhRkcyW8Ad8XGhIlxcEXqYzlRXJcM95THswVvAlIFaF09GzewreTurc8R5iZa1Ub8kmTFXZpeDUMm7IzH5tmzq0uilBixJD7gW1xV7pPpMSpks2nGqAOxhoxED7jMQHmCRi/Cj6JjherQdhcVyDMb5OJ2T6vS2VgWRhSKnfd3b1zFhiBHai0XeC0hEN02Q3vs5rSbQQgt06Og1nhtYN2zaWGCMZir9N7+llXvwXJxlideugLEDjyWWQvny/Yv5yrjEoCmIimfjEbVbUbEDDStzSXqMsrt/UDTcsDLZZsfW1pUI5Rcbsiy5Zt+jXQaYG60Kx81OoPxa4fvKDsyElfApKI5bD7R3zKR1KJOmzNCTV9p5NWog/+Uk0R1xxZEhY4tZaEiIr9Z0vtN0NnNliyLuemIDjxRth3wbwb2yBFpmHAEpKezMq68gZXxrLngwyMz7WDVq1ULwLjNh71jpnB8Ksad1Lwtce53/ZZSOluSK3c53Ivqm6X/uDcvQwlygHIv+hq6CDoXC0oLkLPuZJ4NsezeUzky1vqtZjbPIUnzYO2kbN8qYNd6NHO9jOK/xM0+E1/pgJZTwRKnVDGMkbnh6fjBMAME22dCJwVRtZGUrlDbAR1J46aJ33eNtImy7N4M8viQCTwkHLjRda3fytCbj2oHPQpsaqilR+PrzrpdJQFP4dcOPKg8tmf4r6jsobc/T7u+d+n5
 hPNy1KcJ
 r2PSgITZosgwJrsgCFeheapDOro7mmt7J/DiQaAoOI8LiLESWyzFMVv0Z0Cbg4shzy5zUYucEITgbUGvnIUafA1oh/J8bvX6rs7XW2JmI6LVvKL1jDg+nsHGvEYufbxHoIeORX/nSYyBIxcDPAzd8YChLMfCIbImNn0Xy5JUOJ3oA/AQT6/ddsbc62lPhvmC7A8yqvCIIq5ZcQKcCdDkqOFT6FCVYZcDfff8x6sZpt6SKf+PAmRcX/Hreb7FCCF7lZLJ2lVS3S5VY2Uvmt/5F1rmiFNWBDtiDvfAtFulNzDd0rN8xm1ZQOE7BxTkYBJ1UTUY5X4src20CXDP8l+ckenHqT9+5dSl3p7KYK0/5VJV3962ZzfdCJcp8AQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Qi Zheng,

We usually use LoongArch rather than loongarch, but if you want to
keep consistency for all patches, just do it.

On Fri, Nov 14, 2025 at 7:13=E2=80=AFPM Qi Zheng <qi.zheng@linux.dev> wrote=
:
>
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
> empty PTE page table pages (such as 100GB+). To resolve this problem,
> first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
> PT_RECLAIM feature, which resolves this problem.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> ---
>  arch/loongarch/Kconfig               | 1 +
>  arch/loongarch/include/asm/pgalloc.h | 6 ++++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 5b1116733d881..3bf2f2a9cd647 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -210,6 +210,7 @@ config LOONGARCH
>         select USER_STACKTRACE_SUPPORT
>         select VDSO_GETRANDOM
>         select ZONE_DMA32
> +       select MMU_GATHER_RCU_TABLE_FREE
Please use alpha-betical order.

>
>  config 32BIT
>         bool
> diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/includ=
e/asm/pgalloc.h
> index 1c63a9d9a6d35..0539d04bf1525 100644
> --- a/arch/loongarch/include/asm/pgalloc.h
> +++ b/arch/loongarch/include/asm/pgalloc.h
> @@ -79,7 +79,8 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm=
, unsigned long address)
>         return pmd;
>  }
>
> -#define __pmd_free_tlb(tlb, x, addr)   pmd_free((tlb)->mm, x)
> +#define __pmd_free_tlb(tlb, x, addr)   \
> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
I think we can define it in one line.

>
>  #endif
>
> @@ -99,7 +100,8 @@ static inline pud_t *pud_alloc_one(struct mm_struct *m=
m, unsigned long address)
>         return pud;
>  }
>
> -#define __pud_free_tlb(tlb, x, addr)   pud_free((tlb)->mm, x)
> +#define __pud_free_tlb(tlb, x, addr)   \
> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
The same.

Other patches have the same problem.

Huacai

>
>  #endif /* __PAGETABLE_PUD_FOLDED */
>
> --
> 2.20.1
>

