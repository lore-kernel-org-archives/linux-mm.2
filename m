Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C58CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C88A6B000E; Thu, 28 Aug 2025 06:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678D86B0010; Thu, 28 Aug 2025 06:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5C26B0022; Thu, 28 Aug 2025 06:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA2D6B000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:07:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 062D1BCE0F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:07:51 +0000 (UTC)
X-FDA: 83825739942.07.2F268F1
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38F97140011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:07:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rFjKbtDn;
	spf=pass (imf09.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756375669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9E9CQIEDOr2UcYitZQ4gvIXZ41Noi3g2Rn0AmT7jQqk=;
	b=ISYH//f0sgZIFzL1vi/g5JhhAac6f9aWHJovgzQMN894sliS7UeqLepB9iLcTUVLbzluUv
	bprvNHTxVXN5aIQx57xKdlHcfVeVVVAVjW4Yv/a4dPxt5Zbg8gEldunRD2knM+mBnFlwU+
	pPe63Lkf/gcPfWEVKEkQ8NtG0g2VcRE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rFjKbtDn;
	spf=pass (imf09.hostedemail.com: domain of tabba@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756375669; a=rsa-sha256;
	cv=none;
	b=1e8ecHUUIjVVzSzLzeSBICAfGNCaBXwTABrWTzuEB6w/IKxd8iiUMBBLIw4jL3ZHFcCj1m
	xQmiwObOcSjEKhIRfzQY5TI+isCmp43nye1IQR0ceGqtGds3PeEgphAJ6mk3/g/gk7RpZB
	8qi5s1+52eafCuHx8nN2ea07CcAEUTU=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b12b123e48so322001cf.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756375668; x=1756980468; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9E9CQIEDOr2UcYitZQ4gvIXZ41Noi3g2Rn0AmT7jQqk=;
        b=rFjKbtDnCR/s4CSe1m6QWVseD6lURz28PDBh4klXdX5ynaIgSTw+EVcVe8CG3kfPIT
         44aTJZNC2RBQnLuXZ+rXfdOEPuFZoTk2Mhj424DGXINe+VBQDdBrx082S1iU0nsGP0Nc
         Td32dDvo5JPOrLciHyMtxLsjFz6rcRHsMuTO0KjQKdqOyt5jEcsAcXVRJsUY9nzIT7Ui
         t5r/V/Agyo1OES4XuaERPNqJqYsZDwyemlliVyD7GBL2B5l6Ly7XjmmfoKqhjTj3ZoX3
         N0OiqFo6+fjbAwD+YNFLFoJZdYHodf+BHKk5/CxN+qSEvrGpWPKkLdG8/lXXMoOrOTNa
         o+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756375668; x=1756980468;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9E9CQIEDOr2UcYitZQ4gvIXZ41Noi3g2Rn0AmT7jQqk=;
        b=ncnTVN0qtLWk/IImqbcTr6V4LDI/6Ee8mUHrrpfweBIN+RvsiYlS8AoxFRf57Vm2gI
         2J0cYePmnUgsUuFTsZX4uapdBD8MKSAqnWjc4QrEIQN4o/9UVZYhvdieFscD7DkJgzuN
         GEeiduuR+RmTx9bx0PK+LDf4ADfev1Y14DO9Z9apTtkGGUYudKiQSLVIDA9xQmCMowrz
         vlhpoqBPcAP6RNVNIbxlxcfVdA5/jMc+cS5oMUldN+7nYvgbcRJJVuI8YQM8RU0cLKhT
         VzjaopnfN2nOiDg/p/QDQk8w9tuoB4hZBUQuW+/OKf0VqNR9UDt30t4Qp1VKo5FtzTpN
         zZmw==
X-Forwarded-Encrypted: i=1; AJvYcCWCtIlbjpUH0OCOiZ3vqLqtfYi6BYxgUwqxV6ZOEvEtr+9hmIaKQd3ALvp6RS6ryU+8Uf+RXBdBfA==@kvack.org
X-Gm-Message-State: AOJu0YwM2bMjNrf1+LteK3UQW09R5DQQBfvC8whzqgxVz0GFF5PfGKcK
	RzlFOvr8cfSazQnntst42lQxy/adSAtUqheVPLQ2yHkIi/tVynVOOcumiW1SyCp5KSrpBSdUUvQ
	eji4terk+KBjuKOuw7gvO7inuJxbyJeQAjxwQIQYZ
X-Gm-Gg: ASbGnctNBOQriLvezW1KcBybh2r7PpjUiX744Oox26BW3wvcbOmIygUbRgD1pBsQ3//
	JO8tm+yRzGhrN/XQCfwp6sQ39QFkbMe6RN+BhMDpd7FHT+DD9THBeA8jVeSgtsbl1hCZy4+V0yZ
	YwOZBdpELlOigd1HNFVqF7v1o4BYs0p6zeucYZNAdpYYHEDnvL7LH1erDSag/8ThYA1JKyYlp9T
	U0m3PL5yqhCiJQ=
X-Google-Smtp-Source: AGHT+IFRjTT6s+Lga012dxByxsEc3lbr9K1CdoyVsw5ZK+adWd1hKzUTB9FTJRCdYTn8BAJBAZ04Flo9bNZpApNjkqk=
X-Received: by 2002:a05:622a:1816:b0:4a9:e17a:6288 with SMTP id
 d75a77b69052e-4b2e2c55f8amr18542401cf.13.1756375667872; Thu, 28 Aug 2025
 03:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250828093902.2719-1-roypat@amazon.co.uk> <20250828093902.2719-3-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-3-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 28 Aug 2025 11:07:11 +0100
X-Gm-Features: Ac12FXyRDhAk_TvQ6RybLCFXLNR5ZeiLskg-xMwpbNc02N3Vn5Fv4ySMEuemdfk
Message-ID: <CA+EHjTwDZ-FRV2KfC5ZG9SJYeeMRVUHQ8rVtb9dx2AQwCriPQw@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM module
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "david@redhat.com" <david@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38F97140011
X-Stat-Signature: yri9iu96tmtcui879eazfwxb51fqjhfe
X-Rspam-User: 
X-HE-Tag: 1756375669-463125
X-HE-Meta: U2FsdGVkX18pXJStZbm+aX3x1AYwVEVXieE8TfHNQ1Nr3BnBhmffnjj7gwkwtB/4JQAr4oDxYcFZJ1kjnKcO5Khm3lQm7eTXm7zbHvCJq3qT9cA77qarDqVbWqMH3+g0ddDAvP7qnCYYGHlCgxqE9mD9GD5app4iG9RJWX79NSeW6vqJpF03xIyNNP1t+CHSQvPScLSHA04dOXUVzby7ikbr93KrVP/Fatvttjp0SKoGMzhGrfJlouwLFOKz7pWqac4j9jQ1INL6YJFWjQV7N4Ek8rLLXtJ0TcKbs+BpRwn8lLxu4d+SvAkAsQ9MU/2w5RqoCU+yhVwITrpoUo1Kjbb3E9tjXFkS3DHiGxtaY3LYJa/LTRFRiPSiegqWTGfiAU+deQnCteE9wLzyrjkfwdVtL650zt54bIjxY4tgOTvxtZ1zEnkGWjYBqct/Ii0HqNRIooXMDU0cO6Lfb0AzGAVqPXN9Bfjslf2GCKikvxtAzPnwGXatWSm7LNM3W2xTCtSbF2ya4hAHFqr9XgOVRBy5zIeUwdHZL8nPyY33kq/ehloFu26NWpxGo3447/0bWYUUho8Y+Zmgx561KO/9sIXEnYDI4OIPZrpJd5eJLkXDmsfdheL1QwMbZCFYuOKBJ2+saywKbcoY/zQjrvQkBLA5J2F1ZiErIkBliyHO66oHLxBTceZtOH+xhHQONCb91Uu45L5cjDb92oaJVnhs/yzc8ADous+eyGMThWP8nmc3weCOBw00hf7YYqQeOtj9LjIIHGlexijY1re5Z3i8zXptSZuUH8GrumU+B+yQpu1Ek4mh6o7Iet1bAVoyZdqU+TAuNiIzly7oyoZeF9p28aJAvLY+LF+7F4tyaMGrZdts4LO4eXoBL1BrIvP/pXTcgmSVDfuGfbrOcPIyngPi3mJCa0zcm1ibmNyJgjhpnUYa2bgpYGl85j2i2DIbvWHj3N5+9wi6VHxg3WZIVE1
 03+axggy
 FsYlTTJKCnvDTaR2RnxABUXSr30DXC4tTTP/Ml3na5PaXOKkND3ZcMghH7PKDxcUafqc3opY3XxX5ooKyylwSjEGAvp1vowvynNRgBBpt2E82kIUW9qa207zOGDOmRxq8Jhu2LlXzni4LJu3jqXOfmSI2uVqGP6iGgJvmqaBA3tO8CnlqngORXDYe4VgfMPmaFbn1tKBTKgm+YO7D7w6oZhcouHdrsi7uOujrLYb/+XO5TybpYgyN0ialws4LVDZo/GNSXhbxSFJKcYtdPmnDSQ+2VYOAq2HxasuQGudqzTpxW6rVs2D03QAid6dsRYw4QJrmVO2EiDuqJJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Patrick,

On Thu, 28 Aug 2025 at 10:39, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> Use the new per-module export functionality to allow KVM (and only KVM)
> access to set_direct_map_valid_noflush(). This allows guest_memfd to
> remove its memory from the direct map, even if KVM is built as a module.
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret enjoys, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  arch/arm64/mm/pageattr.c     | 1 +
>  arch/loongarch/mm/pageattr.c | 1 +
>  arch/riscv/mm/pageattr.c     | 1 +
>  arch/s390/mm/pageattr.c      | 1 +
>  arch/x86/mm/pat/set_memory.c | 1 +
>  5 files changed, 5 insertions(+)
>
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 04d4a8f676db..4f3cddfab9b0 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return set_memory_valid(addr, nr, valid);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  /*
> diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
> index f5e910b68229..d076bfd3fcbf 100644
> --- a/arch/loongarch/mm/pageattr.c
> +++ b/arch/loongarch/mm/pageattr.c
> @@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page)
>
>         return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");

This should be after 'set_direct_map_valid_noflush', not 'invalid'.

With that fixed:

Reviewed-by: Fuad Tabba <tabba@google.com>

>  int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  {
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> index 3f76db3d2769..6db31040cd66 100644
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_memory((unsigned long)page_address(page), nr, set, clear);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
> index 348e759840e7..8ffd9ef09bc6 100644
> --- a/arch/s390/mm/pageattr.c
> +++ b/arch/s390/mm/pageattr.c
> @@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_memory((unsigned long)page_to_virt(page), nr, flags);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  bool kernel_page_present(struct page *page)
>  {
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 8834c76f91c9..87e9c7d2dcdc 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>
>         return __set_pages_np(page, nr);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");
>
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  void __kernel_map_pages(struct page *page, int numpages, int enable)
> --
> 2.50.1
>

