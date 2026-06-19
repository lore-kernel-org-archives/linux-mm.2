Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C303CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4747C6B0088; Fri, 19 Jun 2026 04:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDE96B008A; Fri, 19 Jun 2026 04:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0EA6B008C; Fri, 19 Jun 2026 04:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDCEA6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:17:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EEDC1C4762
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:17:07 +0000 (UTC)
X-FDA: 84895956894.22.37902A4
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92438C0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:17:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SobqRUNg;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781857025;
	b=Em8tq0MbxVR82uPflYR1zBy66biSIGe2CObz8xIGaAeIFGYim38DWavifPPCp4IEUJjqH0
	mmBhKmj47di51WjAKf4e+pMbaewEQ0mPbduK9OmV4vTdPnOqoSYmTqFkkXpjrXuzSfhBco
	Qw+8rS3wwV+5LIanCkyW8jB4vW8MLsc=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SobqRUNg;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781857025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Up+XrPQNLPb5sD2pRt6yFkeckwFFZAw2wSW2pQjWH24=;
	b=Ub3mxOhhJEJGuGXwHP9eiJMXYO5v+uZHKXCwKcFljHlf7srhXfiiFY6jS1Eluq4k6mAulZ
	9qLaRJE8t1CESwrJ3J8TenOS/Pp429WirDu2733CrrOt701fCkOUcVSEcu27K0D0e5eeHF
	0UwhgThW29KhMWaO9bH8S+Xq/X7SlC0=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765531803so196071cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781857025; cv=none;
        d=google.com; s=arc-20260327;
        b=E4EZe0lwYXYEqX0SPaMmacJOji1uN51fpAw2NccLqZGv3IBn3HelpXZAINTBYmAmDg
         lOJCMZGFsxFJCs32skdxFTfVkqUkcFxpxNwbmGW0lQdGxgW7w65qifIpbx0FGC9lbQKH
         zk4cXMRTFJx2BE8xVzdZF1ddmMxhiE5+5/sdr7349fmRGBCwoW9k1cKl1LIToeGIhNbo
         StgVsGzjgK55mFQpRP6GBs6z4taj2bG7ng4Z4pYlIY6U8E6MavLXxVYqkwHzuBWDUGwC
         oHDE5V8wEb7QouYQ98ZFmMP/ILBXl5GY7z4DGA2FZi3ZWmaGwXQJU5dMuH/l3Mhbd+jl
         f1Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Up+XrPQNLPb5sD2pRt6yFkeckwFFZAw2wSW2pQjWH24=;
        fh=AhTGHfPAYzurCqiuHnrkj/INRNWV/JG8Hbq9d/6pMwE=;
        b=J/vbtCdwMdAbd0y4GUeFgb5obEbgvOnrrVGwOrHfJY2bbpTXzzVabDqX3NOXKjdkxr
         9IkJOergtdB8hqEptbHhgsn6XIwhHpTA+0RooQSaTzTuYM2XvgnBhiphN9uLFUhbMSo9
         PHg8WFbjm3MDLvFuQtLVh01I2VjPo5n3NZx4Gg+ZE838tBbPMqwZveI7syszsUmDVuhn
         wOzJmzyg9YwQVyLFH0dHYkMc9IzBASh//WldtzINFLBmYjsJwmcqbMG33+eLscRMntgn
         Eo6JFwYMlQxFQTDdn5W/6rm6du/sm7BoOeEoHrKiI1UidziVRWRpHeDO5Q2rakzi7WfY
         xMhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781857025; x=1782461825; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Up+XrPQNLPb5sD2pRt6yFkeckwFFZAw2wSW2pQjWH24=;
        b=SobqRUNgN4rVrIWHYMAQJ4bPOaicUaWN+uTxt4gKnhqFKYt5mJnygSqpJpp51c5Hq4
         8n0MxyKNaeO628M7wMJtfmygaLBMWh1kQubjU5Q8htvxuKs0b34HSyN8AQCGDHY0Izoy
         TWC6OHpm0vJJ6FHfQnEXQO9TEkdfnZwqt+55yJZrun9dHutrljADcn5L13vjEf8TPjQc
         IBLAn4rmqZ2byTyxiZi8mtormtI8TwuAh2UaQf+NMjCo9u+EEd7qIEa5eXnSvIGbbonm
         4ZtTNqrvhGhw212PhjgeGznlf+C4TgYi0NX92m8BBQtpKhiWcOcUWI45SHDFsNaGpOAG
         W9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781857025; x=1782461825;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Up+XrPQNLPb5sD2pRt6yFkeckwFFZAw2wSW2pQjWH24=;
        b=F5bDXwf3yoBqU669+OADjFvBym4EK7KHha77hlgfUOEpv+ne75vEdlm+ax0UMS+Z0B
         qdmuDOiEm9ewrUX0Cjt+si7Yuz/0WEmAqUKzg5321ufKw2EbfvH+/8+UNcerr4PXeChM
         zLuCb3jduPHY3W/eE/DkjjdVqlfFu6GP7ixc9Okjvrd+Zj2nbD46/ZXdqqLIRSDbP/d6
         lnAt68VWcT8iw20/esdI81V58Pum8GKQQpiwcrxKXKpj9CGmS4M1mrZc0/VEKLCrfCzf
         E8XIKe7Y5K9VgxAvkREKQ3GtWPlL0AceaO2hR3WVWWi1JUe0t/j4DwzzVkqUhiRJgWtM
         iQ5g==
X-Forwarded-Encrypted: i=1; AFNElJ9VygrNHPc2vPtr66Sq2i1ecpievAfqRKp834utNPsp6/2K6ve1Ss7ksSUk0EYVyv5jS76ImFX1+Q==@kvack.org
X-Gm-Message-State: AOJu0YyBvKHTv+7Dq5QJAi1xerkAVykvF9UfUD0rZpaeL/vnwunw8JbA
	ZbxOiCZSp/vo1dN8Oi1tiYv40SJgEup+M+UiMPgyhT1X9MzDQl6I8UjrwoGlZ1+24cWV7PgQUDU
	piOBwG12eTwbbNJbq5rZBMr6BT2nRSQr1Xo6lpCJ+
X-Gm-Gg: AfdE7ckfK+etl1cOO7H/XjGhuPQDYRIENW2xgw48o5LKnE5zcpVkKGkkDYGR7MLIzEm
	rnlIUgq88GEXXv9JP+YN4v7pTyg+p4vgs8M65sRmxrdC9IxsNhcCgMO2pk1cQVUSw3VkMqMo3Lf
	bNGzApQnhnddG7460cWLeCeB3ilphtmB6VykXMGWoyXyYmhKLQwKtfLNkzMeguehvJ3frHDOnnU
	N0JKLetIDcrcktYsdFTEczaCpfQ1tuq7wtA46VB2IoMp0aDH8sUdFMBJ85EqWof82kKNPUSIqT5
	jqTcoCuq
X-Received: by 2002:ac8:5e0d:0:b0:50f:be7b:923a with SMTP id
 d75a77b69052e-519e890f9bfmr4864371cf.9.1781857023534; Fri, 19 Jun 2026
 01:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-7-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:16:26 +0100
X-Gm-Features: AVVi8CcXSm3jW4-FHN7kYYGC1TN5KZ4bglqmRK39sQa6uZ2xmU2eoLlZ45Vf7AY
Message-ID: <CA+EHjTw0yrHqAPFUc6bK=u3D19mRyh-eeQgDmGioN+LLk2DXDQ@mail.gmail.com>
Subject: Re: [PATCH v8 07/46] KVM: Rename memory attribute APIs to prepare for
 in-place gmem conversion
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92438C0002
X-Stat-Signature: uj1ioj76ab91jxg6dphmbuz81bj5wh6i
X-HE-Tag: 1781857025-133988
X-HE-Meta: U2FsdGVkX18Qoy4eSH1C2+NR0FgKXx6LF7Res5CA32RmwlaU2Hr0iasP9bE55BqAisChNYgcN33l5hupRgmgaCG/i30/Qh7CNzIIrrtSdkq8SGvCmDKVIQDtZUoVC3X+66C+8Qo9DTk8qtuqzKIrO67vDwNVZKfXK/aNIxFSkkSDW4BYeZGUNNw65FoIeiy76iavbyugyf8r4c78uEone3Cc6nMkE4Q7eYR8nt5I+MiMPjKM0SRWEwqBvY7irAudJg9uWR5KJQTlUJkshySlO0TT0nHMCWt16PlawtZVWIK3e1BiOCBkUbM10CQTvYGnbGGgevt8CUCX9UleUjE6qmfUXOz6mYWsLkH/0dtGBYQiUBsJqJJtHtRBuXUViCpguzFEQwrzpCWMIVsK3SCemfe1Y/I+58qR8E8SXIVmiMF+0FLPMjzAunNJunIvmMKOFisc18Oxh7X/d7v+tl3EOBGDmz+vBgWWK6HEWAYdX3LloKHDYmRRnHb8R/uB8sOig/E9/g2SG10ENSvpgvEpFU9Mcu6fuAs08EaMWyJjacbh0mfEe7WNh4Ys8pNj3O2sOYHOpF71PbFB1eKMsbShJd2JiFpzz6qb+8pSzrfDwXVqMm9fJ2hOJUAeZQBGnRRzzY1I/KoO0q13OcoonQ7cYNVvxT0FEBuihfen/8EZ1lcb3vrLldPVM5sSCwNLiLVd/sYHjUczI3CIPuMgr5bNr++OMLCO3pN6NRz+ntpPxpsL7hGPVOyE1ElRkF+dGX6pQ7CcI4d/2VcPEdh4ys2MzOBuBVSgfSG2TSpvpqQ1P8nrQ2vp8g/tVspTyURpCHG882mHYqC357vKfG9GHMRUc2DbQRWn2cco00Y9vVUIqAh8di2k2Qe2r/a7nxcne7RQYqXWiOuanPS3iQSip8u0GYjy2+eW88aV4gO4Q2xXbU+ccNlORKJAyl7H7EDoxTJIoXax9MjS2Tr5oMtxtui
 huHHkilT
 de2U1D6ENj5DxSnAuTlV+rIl7vQi2xfx5lDXwF5igTTdAReXVFFAsTTWLAh3jSTfLDeBywDDOOnCG7T//b74W6kVyqaRpkiYLscySHwD6atTTOdeHfFGuqmMHU2ACYBmWDRECkoRsj9xq4QyUu+x5zmjRFcV1Df2KDar/OEZu16D2hIgiccYSBuiGufZJVRsMPGUfiA6Vh3qDTMAQYPzUVPmYJboHnMkpIJf6CSCqXzi2GY0zmZTsBpdEGL5nMQVxe29crLEQXiXWNFcufc25IbImF0nd8J2X021l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Rename memory attribute APIs to add a "vm_" in the name in anticipation of
> moving PRIVATE tracking into guest_memfd, to allow in-place conversion
> between SHARED and PRIVATE.  At that point, there will effectively be two
> (potential) sources of memory attributes: the VM and guest_memfd.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Missing SoB (other patches as well, I won't mention it again). But for
this (and other patches I review with a missing SoB fixed):

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/x86/kvm/mmu/mmu.c   |  6 +++---
>  include/linux/kvm_host.h | 15 +++++++++++----
>  virt/kvm/guest_memfd.c   |  6 +++---
>  virt/kvm/kvm_main.c      | 16 ++++++++--------
>  4 files changed, 25 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e0005a21b6e22..cbc50aef801fb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -8087,11 +8087,11 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
>         const unsigned long end = start + KVM_PAGES_PER_HPAGE(level);
>
>         if (level == PG_LEVEL_2M)
> -               return kvm_range_has_memory_attributes(kvm, start, end, ~0, attrs);
> +               return kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attrs);
>
>         for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
>                 if (hugepage_test_mixed(slot, gfn, level - 1) ||
> -                   attrs != kvm_get_memory_attributes(kvm, gfn))
> +                   attrs != kvm_get_vm_memory_attributes(kvm, gfn))
>                         return false;
>         }
>         return true;
> @@ -8191,7 +8191,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
>                  * be manually checked as the attributes may already be mixed.
>                  */
>                 for (gfn = start; gfn < end; gfn += nr_pages) {
> -                       unsigned long attrs = kvm_get_memory_attributes(kvm, gfn);
> +                       unsigned long attrs = kvm_get_vm_memory_attributes(kvm, gfn);
>
>                         if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>                                 hugepage_clear_mixed(slot, gfn, level);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d370e834d619e..eb26d4ea8945a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2534,13 +2534,13 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>  }
>
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +static inline unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
>         return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
>  }
>
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> -                                    unsigned long mask, unsigned long attrs);
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +                                       unsigned long mask, unsigned long attrs);
>  bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>                                         struct kvm_gfn_range *range);
>  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> @@ -2548,7 +2548,14 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -       return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +       return kvm_get_vm_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +}
> +static inline bool kvm_mem_range_is_private(struct kvm *kvm, gfn_t start,
> +                                           gfn_t end)
> +{
> +       return kvm_range_has_vm_memory_attributes(kvm, start, end,
> +                                                 KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +                                                 KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  }
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b4c24fdf159f6..8101f64e0366f 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -915,9 +915,9 @@ static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>         folio_unlock(folio);
>
> -       if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -                                            KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> +       if (!kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + 1,
> +                                               KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +                                               KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
>                 ret = -EINVAL;
>                 goto out_put_folio;
>         }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7b989b659cf82..6669f1477013c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2419,7 +2419,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> -static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> +static u64 kvm_supported_vm_mem_attributes(struct kvm *kvm)
>  {
>  #ifdef kvm_arch_has_private_mem
>         if (!kvm || kvm_arch_has_private_mem(kvm))
> @@ -2433,19 +2433,19 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>   * Returns true if _all_ gfns in the range [@start, @end) have attributes
>   * such that the bits in @mask match @attrs.
>   */
> -bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> -                                    unsigned long mask, unsigned long attrs)
> +bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> +                                       unsigned long mask, unsigned long attrs)
>  {
>         XA_STATE(xas, &kvm->mem_attr_array, start);
>         unsigned long index;
>         void *entry;
>
> -       mask &= kvm_supported_mem_attributes(kvm);
> +       mask &= kvm_supported_vm_mem_attributes(kvm);
>         if (attrs & ~mask)
>                 return false;
>
>         if (end == start + 1)
> -               return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
> +               return (kvm_get_vm_memory_attributes(kvm, start) & mask) == attrs;
>
>         guard(rcu)();
>         if (!attrs)
> @@ -2567,7 +2567,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>         mutex_lock(&kvm->slots_lock);
>
>         /* Nothing to do if the entire range has the desired attributes. */
> -       if (kvm_range_has_memory_attributes(kvm, start, end, ~0, attributes))
> +       if (kvm_range_has_vm_memory_attributes(kvm, start, end, ~0, attributes))
>                 goto out_unlock;
>
>         /*
> @@ -2606,7 +2606,7 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>         /* flags is currently not used. */
>         if (attrs->flags)
>                 return -EINVAL;
> -       if (attrs->attributes & ~kvm_supported_mem_attributes(kvm))
> +       if (attrs->attributes & ~kvm_supported_vm_mem_attributes(kvm))
>                 return -EINVAL;
>         if (attrs->size == 0 || attrs->address + attrs->size < attrs->address)
>                 return -EINVAL;
> @@ -4926,7 +4926,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>                 return 1;
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>         case KVM_CAP_MEMORY_ATTRIBUTES:
> -               return kvm_supported_mem_attributes(kvm);
> +               return kvm_supported_vm_mem_attributes(kvm);
>  #endif
>  #ifdef CONFIG_KVM_GUEST_MEMFD
>         case KVM_CAP_GUEST_MEMFD:
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

