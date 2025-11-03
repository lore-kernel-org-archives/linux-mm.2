Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AECCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7878E0024; Mon,  3 Nov 2025 02:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F1A8E0015; Mon,  3 Nov 2025 02:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBD68E0024; Mon,  3 Nov 2025 02:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BBC3F8E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:03:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DCAD13BF96
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:03:41 +0000 (UTC)
X-FDA: 84068405442.19.0B01197
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 76899140003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:03:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dY8bnnEA;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762153419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5P3j3pQdM3AH1u51YzJ0Fa/KQtK+2/TBxkltuxNOgs=;
	b=JU5q60zouiK1Je+vuJtee5QKq6aP2PStL5TsJIK2J3wivPdJn98/8mBVFsLlPpxXlLYYQs
	ub3epmEoGG3dKiVo8FuAzJK5JfcyBpmLhWHpgCyvNF4y7+FbP8MwbyWXlhvLPNGe8i1TGU
	Er+Vp+fr2llinNlt1cLbuNrppG84zhE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dY8bnnEA;
	spf=pass (imf09.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762153419; a=rsa-sha256;
	cv=none;
	b=NrAnv3HBJYycHjBhCpluiQKtD6TYsmc66YhL4pnDYKjMUl3wFUSU0bXf5zn1vDnLh6A4er
	ZBCwaoYl5qRC/s1tePpSS5/rC9wgPrj8L5awur88DiEpdogyg1O+zqtxUy0bf0zQ1LdKfM
	WVOxEMG4qr2Xk6+ne6YHMNro1jEkkqU=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso3981842b3a.0
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762153417; x=1762758217; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5P3j3pQdM3AH1u51YzJ0Fa/KQtK+2/TBxkltuxNOgs=;
        b=dY8bnnEAHPOm+saSbiK+QEmnXwUqzLz1gxTHaV8oHGHTLFzArgeQ5e68Yuivgk1q1W
         bezGdc22nlBicStboePongDeJsvG4wVb92o7C0nEi+ZJe5qBqe55Sf8/7Rp2ok/p5t81
         4YEDDisf6P/hGZTS9eWz6UXewUwQWNWOT1pj4KMuSYyIvCFl+Vx2Rwpz6t8G+DrB8QQ0
         QhEPrrvDWYzUaEVY4hL8nr22WuUCR59iqUlL5Rh/0QjhhkDY6KBDU8ac8LxFNW95k9n3
         1Y3DxzlD1BGTvyhMsPUy/0HCnvy5+ev+j9jrLrz0E/3ClRZpUhRJKjEcoYyuFihGoECt
         82xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762153417; x=1762758217;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w5P3j3pQdM3AH1u51YzJ0Fa/KQtK+2/TBxkltuxNOgs=;
        b=J/ixhOq8TPLZsTR83wFVVBtJtTEaDZKb1l0KDtNDQfE33o4LhwNOmBqb6W6dU8K8t5
         9hLXrV0IFPNvHA1T5d/Ru+96BiC5rY/+a80CviaJ+zOYJ0jkFZeIpklNuMZriJv2Uotd
         amqUS9UDcpeabUvAOmws57FG6X7wtegkWjX3LsFiTliYOSlHKXqZQBGqRCCJdYMG3Jla
         VWJPz2XQOggWUr13/hnq8yZRQ0eGgJTeJ//PS8odnZmzuhUjdnTpj90tf/7fxg+h2uC3
         yGYeMs6yeWdby6ot/RlEn7qt8W8qJ5ivJ5LvQbweHyRNg4oM6+qCITf2MpxNyvFsYBW4
         1Fhw==
X-Forwarded-Encrypted: i=1; AJvYcCU4CJ60rDaOtu40fcaFbv5A6Qn3EYTiaBlXFcVURI3V+9DA0qMURVJf7xtGxBjwrTyjmkvQ9/gXWg==@kvack.org
X-Gm-Message-State: AOJu0YwnJTJNX7zt9735ZHXFp7mqPILw3Sv1gtsVyrNcfNOANNbA4aj9
	cGYywEvq5G8wkKkCs5Mmc4WFhfknqJCBBic28kzLAtsZrMlZa5BgKcZjDrCm7f+aX7SB6UcDN+7
	rfgqz
X-Gm-Gg: ASbGncsehxF6vXLOLpfEKHCPsxmXAYp471FB0ZR6vi7BF6ASKwIuSXGG1Lc/P0kn5e8
	WL2HNcwYcqtslhll7XHNbMns4oXHkADhAweIva6G2NxEXHmaij1QPgH+roo9brB9XCy/7N8y7//
	6ujVSi+qkhw0N1XSCBRsSGbg8pLlky589amozFbxXbn+C0dspbmqp+uxFr5fZhOdupmynYQPpCz
	2jtKdQDT18GAbdwFKj91BP8D7LY2CSO93iwvZAF5CuOeLkI3FNP5jjN8hDAfepacvyCtCuRZwUi
	XGhfYcE3/vTOhrTozuceVQ34p1HNkDTiAe/U/VoWdeuqBcBQfMkeLEppu/duuherb6fM+fX5saZ
	jxSAETxsi2obfIRp8wWLtidJq7rDx46HOWNY11iVnT0djnBB1/fienkODQU78PQy7AtEApjHdTb
	h+Wa5UOqaCj9d9sKZvTljHjgvSe9o3rSQJglsUqw==
X-Google-Smtp-Source: AGHT+IGTNhaBgPV94HpLwq3wxD5moGyXJBQ3HMvWngLRZxDRivXq6LV1O8EW9Wa5ai847X2dvYueZA==
X-Received: by 2002:a05:6a21:3283:b0:344:c254:d9ee with SMTP id adf61e73a8af0-348cd21bc02mr16031690637.45.1762153417086;
        Sun, 02 Nov 2025 23:03:37 -0800 (PST)
Received: from [100.82.90.5] ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b95c44f7363sm7270941a12.6.2025.11.02.23.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Nov 2025 23:03:36 -0800 (PST)
Message-ID: <044e3f9a-3de2-4939-afff-3bb527eb024b@bytedance.com>
Date: Mon, 3 Nov 2025 15:03:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: Enable CONFIG_PT_RECLAIM on all architectures
To: Dev Jain <dev.jain@arm.com>, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, hannes@cmpxchg.org
Cc: ryan.roberts@arm.com, hpa@zytor.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shakeel.butt@linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251103063718.90743-1-dev.jain@arm.com>
From: Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <20251103063718.90743-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 76899140003
X-Stat-Signature: ixbe578yfnai9d9wznt5ura67mwnhnxj
X-Rspam-User: 
X-HE-Tag: 1762153418-110577
X-HE-Meta: U2FsdGVkX1+m+KPC4RTe3fikuD5ZtgRZ9FQkSbn7RPrI3fLpmvamyegWQCf3BdGZM6Wch6ZB1nhBjI0zld//8b5UWMh4LnjKjCpQ900L1xxGXKhnH2CAzMuxNYEEt2yrKgjO3cBAzPVUrmlfm74lji/gnmjt5kxwerDnms86CAmArJWR5rsrn34zeZt403veaNPlJTSyrV2owBltXlJaq1ldsROUQvXUPx99ML4tM1RVRaC86P2VOJ3xxitpQB6eonLO42nuXAa6XHlFJOyfHZtZcjy60BfrQYliGpXCoBRDeU+CjqCZfk0l+l7iyUrOUgG7pAxtlP+1dI2dZeUb/UP2xXMEiVxDHRV5E+L3Hxx0l43icVNPLZrvsw8l8ohl2Ke22PjsZsVv87eNgDT5OSlNeStv+WWgCr3bYgMMKOTGumT7UQXnLxV2V0snpgmt0O1jTstGtfAoK4dB82ROLjEhmv8XgsEFsvBqlM4F2Aa2l9QdTDg+VAvefU/IB4kDk8erHBJRBUdFJC33UWs//ag/jCPBeGKENokFtkMs2yzq/8Vk6a7FT56PRJvv/hecGKfLOoF9RZRmSton2sx2My0vMgP1QEFo1ZFKooOQp9jIUfR084LgonEKvIAuh//qAVABoZxiMN2qerrS7zesefq+7vRC5J2y2uZPCsOIqPyp9UfWptZkQUkQCxSAeh0/LuvqrwVft5TsnfGbsRvbGE24wiYPO9iIDhQQsvOWpT13277eiMdvZGrahngP/vB+lTVq6yJzqsoVguX902mNLX+2D4zQ2/QMUzNU50BuC07xZJ3ggm5hcvSHJHAu/t7aMmCbjubuvhalFsL+TNYOfRt8VLRCBrmAemvZ5y6P4KTJZes8IbZHIsgH4kovot9Mv28cKI51e1/JQ9umoM763h252Bc16LV3weghXP6Aa6/pFXRqiGWWFXZBMNNnN48qvMVnPwNnLNfJrTg89qK
 Oa0E4mru
 8cCamkxA2wQ2LbReHrqbAE9R01gHVnBjnVxjV2qAglqmWJisKRaxkozNcHdYxX05W8PlLbMQXA0o05H9Xl17yKIS1DpmFiMh+K8W7iZFUXP4Dwwv2MDA3QPZ2UHvYAYVpgOdSnkSH088er3lH4gHTD7uuP4bp0WfC+EAkSofdSzuVWVTl2mG/8Fcb33MH83UL/kDn3znDxtezl7SqRfZ4mLYcrsQYFbQuHsRntzAFoV1haDxid4Sq3VwUzNGZtm9vVWFd563dEsg0Wv53KRg0UkuSk8mYVtHC+LKvpQ7G073IYMTShzIGSPVI3leB9ABeS83qBU7kCXJVVJtsvXTHIWS3Hhlsg/MBMA/xC5IapUvJKqvboOCJydR0y/idIrkA9k6oKJDpgYEBsqUwi6IXSkLKZ+uojUPMPey3vSG/2ZNo1uAUPQ1SLNvZTC/tdweoGtjlG5FzucGPH1b22UTZsBGpFo7sY2fepBlU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

On 11/3/25 2:37 PM, Dev Jain wrote:
> The implementation of CONFIG_PT_RECLAIM is completely contained in generic
> mm code. It depends on the RCU callback which will reclaim the pagetables -
> there is nothing arch-specific about that. So, enable this config for
> all architectures.

Thanks for doing this!

But unfortunately, not all architectures call tlb_remove_ptdesc() in
__pte_free_tlb(). Some architectures directly call pte_free() to
free PTE pages (without RCU).

We need to modify these architectures first, otherwise it will
lead to UAF. This approach is feasible because Hugh provides similar
support in pte_free_defer().

Enabling PT_RECLAIM on all architecture has always been on my
TODO list, but it's been blocked by other things. :(

Thanks,
Qi

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>   arch/x86/Kconfig | 1 -
>   mm/Kconfig       | 5 +----
>   mm/pt_reclaim.c  | 2 +-
>   3 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fa3b616af03a..5681308a5650 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -327,7 +327,6 @@ config X86
>   	select FUNCTION_ALIGNMENT_4B
>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>   	select SCHED_SMT			if SMP
>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..903c37d02555 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1355,13 +1355,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>   config PT_RECLAIM
>   	bool "reclaim empty user page table pages"
>   	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> +	depends on MMU && SMP
>   	select MMU_GATHER_RCU_TABLE_FREE
>   	help
>   	  Try to reclaim empty user page table pages in paths other than munmap
> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> index 7e9455a18aae..049e17f08c6a 100644
> --- a/mm/pt_reclaim.c
> +++ b/mm/pt_reclaim.c
> @@ -1,6 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <linux/hugetlb.h>
> -#include <asm-generic/tlb.h>
> +#include <asm/tlb.h>
>   #include <asm/pgalloc.h>
>   
>   #include "internal.h"


