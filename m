Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A93CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04CA06B0088; Fri, 19 Jun 2026 07:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023E56B008A; Fri, 19 Jun 2026 07:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EAE6B008C; Fri, 19 Jun 2026 07:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC0CA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:10:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 379B71203EC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:10:35 +0000 (UTC)
X-FDA: 84896394030.28.9D27613
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5187440004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:10:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t4yBPcRN;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781867433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoD6HBjRT9eDykv3AXG3feHx1dss625bK8G+vITqymE=;
	b=pjpA0yXV0iEP8Q8aY9h0UgL/EjU8eS1c6/qdwM7VKqTekRZJ0A5PuXnZU1fsxQImtWMxQO
	q1GI83Sy0SNE6TVwM9GXfhuVxyjyznlLfX3Ng7QZxAYEKGfcFI5hrgZkmJ/B4xyDDRZ8oE
	BrbxUrYZ2KWK+b+Om4sh/sLclVZXOEA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781867433;
	b=FU55Ntn4axPeuAMiSNdiOWsIBVEM1ahcADUNsoA4Mr1l98jp/wPAoGkKUBq7X+bvSC9DzD
	XVhw3q0rm/csB2q2VpJzwldAd6OTKGR3CixRKPQcLRZfMTEfqXjyv3qKUqL6rwCN3FGXPl
	1qNvdoFswFcvWXUkpu1Y8Zkd5lpq6Oo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t4yBPcRN;
	spf=pass (imf01.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so237911cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:10:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781867432; cv=none;
        d=google.com; s=arc-20260327;
        b=WrnJ2FzKTG3UiqnZWjnZX1p4bHwiBCWa2I0e94fVpzT49k9ZG6SDcNmp7COFx12ARZ
         0ZnqBuwEHgVgMyyD0+288B9a9ii0N2cL0tyHIhFqu8/w9ETRCz7bRuJ6nYmBsuy3d1x8
         y8ii290kheKpy3fSVund7qz5+YXTGFCqiAbTlJwbV7hB9RQ54VQBUl1ul11GAz8goh65
         wriGdCW0Caq4PjIOP77MkbEcpk6mPT4NmXa+SUTwVet4llWad6Lnbgfn+G/tgNaU23mS
         6YMjxVXihAFlf+WV5qEpd2jYEhL+25DTOSDWKX3kuhs4gEsjSKCrn1bga+uuZULc6qT9
         Flxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WoD6HBjRT9eDykv3AXG3feHx1dss625bK8G+vITqymE=;
        fh=ZVkZbbwDJMvYXuspQCfSOjri+N/ukcG9eha6qmv6aKY=;
        b=A1Pyi3fD4gBrrgNzRWlFT5t2Y3PJ5q/WT1g3PntPXt1zqPbJFTjOeTNTRT7NYbk9/a
         QYIoEiBA5T26TqIg1/JqhYBydogPztWuk0ODO9f3xOCcxWmR5m415Qpfl8sJrkTHvuI3
         x27f20af+j7bkg4n6TKU3mSl4Ud9ZgFJJTUrdYkAqcuQbS1Bnv7Etf1PZN/8gc6Sefuw
         1o81s3UxfytcRJYSHW5bHphdgR2hJ70htcq5OGg1E/82HzaGpMI3OLIaCfwF4geCMjIb
         JYgVPoA15O4odQYt/aNE9IEAAuZQJg0fQFlflkYsiTZbPus5sQqhVsgjm7dKp6P8KYOF
         SIYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781867432; x=1782472232; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WoD6HBjRT9eDykv3AXG3feHx1dss625bK8G+vITqymE=;
        b=t4yBPcRNn39lU3/2HztdFDv3L5S4pXEgjYYkdiICMXirB+mkX6eZKTBsAQ71fPIsC1
         ep195yg+oIIZ0jrYayexzyoNgrLi8OjpV7X9qLCK0I1yBDHXt+6pGZ359ZEQi9slLLZI
         g2Y3nDRKopixuAtV/LLHVSfbdxqFyLBoK/RN6sSPL9kdlMyHC8wDWlgWbtjxuqgbHJ6u
         OLguweG23ZFenGIXa9Ze1F/hX75rZP2tl5ePDg3nd8OW+AXqyHB0ArIciQe0ABBz3/QJ
         VTGWsVa/jcD1DWBr4ggxiCdp0+8u1chfAWyVxDKl7493ddi47smFc6pG1XmWn3nDWrdu
         6DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781867432; x=1782472232;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WoD6HBjRT9eDykv3AXG3feHx1dss625bK8G+vITqymE=;
        b=tAyRP15t62oRxZbZXFeo09BWuoul7QIDrWjiL13eG1UwqIzJGZJ2hkikg/nv4VfHkO
         FVeHt5tDbbAEgWJl4RHr0zohvZ7xkNCUnUIgpvYz1O6d45LwVJ0Y8zDkIEQBMReG6OjW
         udqQckxuPD74eqeyn42B3ItijLsSXTivyPAe6wQ/rSG0btmj3rJ4gcY6cOWbbrovZ9jL
         xjjBmyWXjXcydqpd4z8Y9bBmNh3oXJu+wSQvSe9DUGvwmTwhDWhSAm2SgujIuf2U4hk+
         TGpxCYTxTeAkG2PeZS4hZbO/gV5GGhRrrHqZwkl2aFK+A4jnqO8W8wUR3Nu2hW3gpn5V
         RQEg==
X-Forwarded-Encrypted: i=1; AFNElJ+N1baD3pFYmqh1AmfQ2RHzdvg6jcdShvIXDGtIB1WmhgWs+Sz7DNw8to+erJZmKKARt7j52YYExQ==@kvack.org
X-Gm-Message-State: AOJu0YxvOWY+BU0a/skwbAX3YOLlzZynr0vbxHRJGwaPoPoYpIUmdWLf
	wHGym2LHqB8dYxzrl6lZtx0XLiOV1PSqtS26vy74AseFBx9YaaB5O34793igIaIXBoEQ+eVBRtb
	eTqF+ETrpybIYbJcytyMiC+lQSzB5HSQbgc/or5YT
X-Gm-Gg: AfdE7clBR4F16EcKuNCucVNHEH/ZGXFLr0Olf2ELF8Kov/Dqg3JJixdwI8yys8CGsPs
	DqdtzRy0D4I8QKnn/DouELbboJlDL4STtiELL/IHF1cdnMnZU1fhojiAXtRfdbA5YQQ0FRSd1q5
	VlKz6SQMGio8nvhfUFwo+xw4kYg9qWbH2pEb9UAfO3/hp1CQTDLcRQ9u5jWuLHODBA9yMHFdr9W
	vNkl777fe0i4UiGfxrNFBd83IOSrvHyTp+t1FL5yNpjCxKgt5Sy30EGwUqq8hVL7hDGDZd+PQ==
X-Received: by 2002:a05:622a:2b08:b0:517:99ea:ab7a with SMTP id
 d75a77b69052e-519e4ab67d5mr7722981cf.26.1781867431624; Fri, 19 Jun 2026
 04:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-23-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 12:09:54 +0100
X-Gm-Features: AVVi8CeUT44zBCOt4kdWsDDIMV1MwoUKi9VlfHD19GzvGrkCGzRWMwEiO6g5I68
Message-ID: <CA+EHjTyj-JdW8H0ii2j3dayqnT2s3VV+brSG++p335=FGd2GXg@mail.gmail.com>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5187440004
X-Rspam-User: 
X-Stat-Signature: po3zhdmwqd5mdjt9zu1rqibekpadj7ac
X-HE-Tag: 1781867433-992248
X-HE-Meta: U2FsdGVkX18q6hS6HdWucWWsGB+G1+nyXeTvNEo/mHXIJGUihYdbvDXiVAjs3raLINw60mMP6n3p6napPASShvRv65XcQK4mb4+jcHS/2zwwRCCzqQR3TgtzTRsuzDso6T/23oA/xHYT0/usvQWP6k9qol0csZRJ48zpyGpD+wFf39WsjyvfpZ/lWra+aeagPfSa0XPkbIX0VX3XY2kojAxcJ2b4gtR7X7HzV1Ysc5UfmWML7apgHbnzPIyg+FMpL0Xq5rpjCR8kBoesGMERMU6ulNyqEjZR7190aiFrIkwX9xDgwMYd0wCPik1KV2mR0USGBgzrCXCB/+5/VgTKrf+OKoJoFao+QMUUwuMAOVx/3a6kZwqVEII5FQVpJB0DlCry/EOgrG6KL2OHxzYwbHBFIf8lj2I1yULHE1GR84lfzRFF/EvIJ974oSshdLRSH1mqjfZFkx/a4LcZCy5W1kVCl3SvIbT6gYkKsI5cJWjJeuMwdhlm5P5szMq5WrlJXERRT09ZnS6CBtlMzB1FjWrt8wva6WG0vIsh8G1G971EJj8tZH8gRvkZ9pUwECOQ2zWTeIuq77XeKPs7x6se8R1Su6XrI4zTAh9erN29Fx5Rhum7ecvP8/9YOAUTAhLGI66ZGNoluI8+ETs9QvvzeDTM34QOKP2Fnpt2eKZAt9uf25tLtS7/gIG5tK3DEjbcFqF+9BjjivnIdQVCczt8Z+UnZev1DvT1zWvbyydMQuFBU/ME4qK5bf7wFpBjPG/xLqJMyFajLm1+xwfdyiQVeeQSLbehhcmFEHwh4OzeltVG6ragyfSAJt+RIH0zZrM/fKBlYTK9USu1pWhkoVHA2mhoYgb/r+IWpj39Na4cfqLWjYXNpAFKGk97KlvofH9VEFvzQrng7yHRKbT2x4gJC+d0Dsahf8By7GLb7+2pLTZiP9WPqV8r7yjimeFklj5bklBSE0FFNjEOTGgP8iT
 IbNwVqJ9
 /nsLEKgF5/pj2jaRaIXkc0OPVNYVAdUaRmnxTEhbw3c7ucjcJxVLs0QmNXCd2mrcImjPe3cxadEon3vGyWafZIWLwJ3/PBq+HwZCbgzQn9deyDCTm8Hlvfx1s+/BPqdVjQXQc3JAULmUMqsd3x6sVlMWOHIEPaMMRhNOFYftu2GqsLG5sXqYGkqfUp0ykl9vN1fsWIlIji8kURwurEH89mD4VGFTG084HSKYlQkPuKSvgibYxwuP3bieDmWzsckMo4U0tSi40fl8tEGvbkmd51wXginz7cc/pBGVU3olbQY5jykGaF83jwrBe+YLdcUPhLj1nQNf1wME6vR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Update tdx_gmem_post_populate() to handle cases where a source page is
> not explicitly provided. Instead of returning -EOPNOTSUPP when src_page
> is NULL, default to using the page associated with the destination PFN.
>
> This change allows for in-place memory conversion where the data is
> already present in the target PFN, ensuring the TDX module has a valid
> source page reference for the TDH.MEM.PAGE.ADD operation.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Sashiko flagged that when src_page = pfn_to_page(pfn),
tdh_mem_page_add gets identical physical addresses for r8
(destination) and r9 (source), reading with host KeyID and writing
with TD KeyID on the same address. I don't know enough about the TDX
module's operand constraints to confirm whether it allows overlapping
source and destination, but the concern looks legitimate.

nit: why does it have Sean's SoB?

Cheers,
/fuad


>  Documentation/virt/kvm/x86/intel-tdx.rst |  4 ++++
>  arch/x86/kvm/vmx/tdx.c                   | 11 ++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> index 6a222e9d09541..74357fe87f9ec 100644
> --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
>  Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
>  provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
>
> +If guest_memfd in-place conversion is enabled, pass NULL for @source_addr to
> +initialize the memory region using memory contents already populated in
> +guest_memfd memory.
> +
>  Note, before calling this sub command, memory attribute of the range
>  [gpa, gpa + nr_pages] needs to be private.  Userspace can use
>  KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index ffe9d0db58c59..56d10333c61a7 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3198,8 +3198,12 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>         if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
>                 return -EIO;
>
> -       if (!src_page)
> -               return -EOPNOTSUPP;
> +       if (!src_page) {
> +               if (!gmem_in_place_conversion)
> +                       return -EOPNOTSUPP;
> +
> +               src_page = pfn_to_page(pfn);
> +       }
>
>         kvm_tdx->page_add_src = src_page;
>         ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> @@ -3278,7 +3282,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
>                         break;
>                 }
>
> -               region.source_addr += PAGE_SIZE;
> +               if (region.source_addr)
> +                       region.source_addr += PAGE_SIZE;
>                 region.gpa += PAGE_SIZE;
>                 region.nr_pages--;
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

