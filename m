Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462FCCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3534C8E00B7; Tue, 26 Aug 2025 03:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3034B8E00A8; Tue, 26 Aug 2025 03:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A44B8E00B7; Tue, 26 Aug 2025 03:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEFBA8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:37:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97BDA139923
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:37:01 +0000 (UTC)
X-FDA: 83818102242.20.27130A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4995B10000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:36:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwxPwsCu;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756193819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/DqKcew5Rz/o9MXbzchAR4oz9Jo4JF0aUKr1yU928n0=;
	b=HSth43cIlsdKUITyvyVYqfTDOa7kb21gx1PLN3h8ejZpTBiHSNyGACR0vfOE+W51Cx0lbN
	PV3TcrFZ7iLfT5O64YAP0BYleacyLWpHJsrJd0IFPeiKka4qIW6pXfPnoMKyLsxsuo3Q/c
	DIvWory9S+csXfpqwgLbCb1xvkhyOnM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwxPwsCu;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756193819; a=rsa-sha256;
	cv=none;
	b=Uqxz/VEkXVCf6z2+6Uz7eywS+mkggQy0uBgLb1eWaIK0eQzWzUomQqdFgN7YSP1CAWuHfq
	IfIuOL7wgE8eJQ/DaeTUdQuj0QiJDk2wflOuep9YzYsMqhctLLyMwingM03GUtqhZujA4b
	w7Qe0NFOEKLfeDuokw6cNvxn5wndVsE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756193818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/DqKcew5Rz/o9MXbzchAR4oz9Jo4JF0aUKr1yU928n0=;
	b=BwxPwsCuJqf6ROoCRjlkrHW9dnAsgXXzdlY7vIGS5khyhgpwVyFo8TD7v4uYeaJuuu9TjY
	fmymruqbWD64mbPcZmBt7pnfV6q9Yh3bfxhNCfnYPbArfjRJG1MiCGbxpMDgb65wjIZnci
	L2vmYupIWH3BZhpM0LB2xupYFXRIZ9E=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-HgkA4F4eMAqi5ME-1b2S9w-1; Tue, 26 Aug 2025 03:36:55 -0400
X-MC-Unique: HgkA4F4eMAqi5ME-1b2S9w-1
X-Mimecast-MFC-AGG-ID: HgkA4F4eMAqi5ME-1b2S9w_1756193815
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cbd6cd78efso56348f8f.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756193815; x=1756798615;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DqKcew5Rz/o9MXbzchAR4oz9Jo4JF0aUKr1yU928n0=;
        b=GzXaMhSlNMRevxe5UtkIDfMYA796WX3e/5KVvLAXMbWwP8laW8G2S/wR4yJdWJQzjT
         xOE4We3BQ5yWO2838Q3FovPNjk+WD+iYYOo1W2Ta/XxHqnXx1aQOU4AhqvBqEqzOYq8/
         4cGTDKPKnsQzX6QkwVj7RamzeQQ2/xTvv4Nn6fbgtDRxuMMR2ojN6Yk1Xh/LnLllbD+S
         78X3waYCi63vIyd7E1XpnykREy5k6rZcyI2ELNA4FCM5I7CwgrE0DK3wPZBK1WLc1V03
         pvArnN7tgoyVsp4xCqb3jZCQTjcrcQAQXzBkU3txHUcYCCzHenlBmBsXxs3lebMNEMKO
         vnwA==
X-Forwarded-Encrypted: i=1; AJvYcCVvq/0g2NR9Xbo62qqc741Oad8BSwtD1MIkDpi3F0v14M6jQVZfA18xnbhAddh+QUPuc9qqAAbXag==@kvack.org
X-Gm-Message-State: AOJu0YwWZnqRQ5kSFAOj1GgXTznb41vJFudkSUIoBfLhG0H2r20RKrkQ
	6+hHoxgXAwvh76G0FvKknLOwHK5NUvirJmcjg9R9PDG+9H73UQcAn3snlw5DUEznbflAiW8a2pM
	FlcpdoAP/FJqzJzdJlPcs8Ub10FTXed4mE1Ay2rK56q4oVtki+KRY
X-Gm-Gg: ASbGncvN+xTg5SOk9U7X+eAdG3QjpuI7DPdWCzXsAxE1Zha9i9cqzPrbTjOG+E+NYeI
	k8cPZDjv5UKh36tq1z0rcmlGgWfq61N5uB6Js29SXntBJN7FmMdyHulfMCVCs0RNmHJoR1S+zpr
	N5Ouxlmm3orLOfx5FOMhgQ5eKxfbCu/E7hIE9qcuxGiP+08yZzOkfJw3Haywse5UldJy/EcptyU
	fzbG5awN2xZnK38BnF8tKsm00oouu51TR6hCHige3y8PiNM0tUutKH9TFQgnbhOm1x2PEfEl4J8
	7ra3ml9myhaz4pRzhK6i1EZbZ3GVwkc0v5wvRBpUSYcvmgmewCYtBjnyN837hkhuETgbdA3PvA=
	=
X-Received: by 2002:a05:6000:4211:b0:3c7:95cb:baae with SMTP id ffacd0b85a97d-3c795cbc786mr7756336f8f.36.1756193814697;
        Tue, 26 Aug 2025 00:36:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsBN52r2cwxKT8YU6u0g1yU35TW6zYizCEwIpjz1zfPH23ZIMqoMpz6jBaY5R0HVd+02BGDQ==
X-Received: by 2002:a05:6000:4211:b0:3c7:95cb:baae with SMTP id ffacd0b85a97d-3c795cbc786mr7756316f8f.36.1756193814278;
        Tue, 26 Aug 2025 00:36:54 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba41bsm15565515f8f.10.2025.08.26.00.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 00:36:53 -0700 (PDT)
Message-ID: <2ff628c7-dc0b-4af9-98e2-8abf6d0708bb@redhat.com>
Date: Tue, 26 Aug 2025 09:36:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memblock: fix kernel-doc for MEMBLOCK_RSRV_NOINIT
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250826071947.1949725-1-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826071947.1949725-1-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3g2Zxr-LIIHKdgOpIPHLMJ7Pxtv0qQZ03eVNRUJyU54_1756193815
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nut3npcuucx1we48erscm4es8bz96ssj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4995B10000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1756193819-833958
X-HE-Meta: U2FsdGVkX19ioXe0awnRVpYNHPh9SYRiELhKY7qq/9ZjVZ7tor/txRiw+id072E66D18qLIVNo/Tvm8GHyLoweW9miZoj2YksJYoYFbnJcTTFPbrVIUXBx0zTxqJWDvTCxyHyNryQKVTIErkRNbx8C+BQw/2eu+ZJbP+RT83EDEX/EK8kSdMFfnODU1LEUajpYNLbA/YG/FPZh8F4ASCaHuLwexiTXo+TuTCzsEmRFAUHmnlDGJksx6gkf+FmliPz2G/RD0vpjZdhr77L/y6oZS64de5dE9v48AgTZfRHUY+gdLP43NPjvO2USGelT/hK76tf80VsdJScqyjcSZZztrErIWsn2fyGmc7yrKTaqW2UId6F8C9aaLDmYRKwnOGVU4Jlghy5V2DYsfBZpenCytTGYjJ+K06MH7gkdgVijv6835BQ+4j8HVG7iDcngxni8oAtt3TqqV6w0ySVVzjWHf1xWDyS/d5P/bvVmh8f2ojEbpHmymoJBMzqqtM1vXFNKL3NWBBeY9Ub1QGDxseX5JVIgmuogcnejwF8+xEGEp3f0h3gmSbdkIdvhJRJuK5lRvo5d2gCd0UqbIA4EMV3hy4r6c4nmrs1k9hhPjmT23BtHgF2MUgnAtfzJM+8PP65BzX1stHaJQUmn/gOnEoNgzQMXx4HjbVnrDsOND0HETr5dlGuErk4lCv2EiDNhiD2MlfgqTst6gI5SGUfDqpDvKMnWY/tes/uVmoPb+oZUnX9+RiE5/ijM8r0XhOpY2MCKspaZoPlpKA2QU1j9Il1FW9fKpDWWk9FX/swrgMgPQBwNEVLOstzLPFghpnRJTO7t3wn/SgyZZKcPIP2MkGnJA5uIU11JYo2EStz9I4y3qA9vKEXzCErFUQF4vy1HDWp8BRnVqPbINjqR9ZNgWCPBi2R5owMEN8VIBw2AIwat/89+r/CxuXYodclzaER8d5cv97fjfTn7FLq1jUHkx
 8azPIcsA
 H7HwwjGaK3DFVC/KI9tLtB4XXMw/nDFTJu81fOS2aQRMB+681IXGpa5Erp9Ka+hJQxXgZJnRBQWf8lPPQLiaf0LirRIKMANm+YaGUvPUwryZAGPc7sfIveV1xKMwP4eSONphlPrsuhos+ZZy9jffr//MJoPLKY5CJpngGrJ1pzTZZJFlg3BjrAI9Zc1FyrvAfwHgNsIp89NPvsi4GN3KBrbiNZpdpyAvUzm07Jqs0uOgTaNMJ2fQfz55fXm5zVEP0t/sOH5MuN7D4t3+1hn69z5ON0vwmwdtqRhkmtjaXaNqsUxsXd8tinhPJ2f+c0kWhetkU+RuG8Qd/5AAi7FtEncRvTUSxcCIZMu+IkqLqWYpIJCKidvJlAfX/649TNF3ZrMD00rNA70I9Nv6bTs5VXi4FLjCoP8HhLgYBJng9qX/rICBcFzSsmPoXlrm8OuiZAxDr7oonD4Ez9nxT/kKy+wAZUeKDzF61kD1KFNMBEE3j5LQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 09:19, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> The kernel-doc description of MEMBLOCK_RSRV_NOINIT and
> memblock_reserved_mark_noinit() do not accurately describe their
> functionality.
> 
> Expand their kernel doc to make it clear that the user of
> MEMBLOCK_RSRV_NOINIT is responsible to properly initialize the struct pages
> for such regions and add more details about effects of using this flag.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   include/linux/memblock.h |  5 +++--
>   mm/memblock.c            | 15 +++++++++++----
>   2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index b96746376e17..fcda8481de9a 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -40,8 +40,9 @@ extern unsigned long long max_possible_pfn;
>    * via a driver, and never indicated in the firmware-provided memory map as
>    * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
>    * kernel resource tree.
> - * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
> - * not initialized (only for reserved regions).
> + * @MEMBLOCK_RSRV_NOINIT: reserved memory region for which struct pages are not
> + * fully initialized. Users of this flag are responsible to properly initialize
> + * struct pages of this region
>    * @MEMBLOCK_RSRV_KERN: memory region that is reserved for kernel use,
>    * either explictitly with memblock_reserve_kern() or via memblock
>    * allocation APIs. All memblock allocations set this flag.
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 154f1d73b61f..46b411fb3630 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1091,13 +1091,20 @@ int __init_memblock memblock_clear_nomap(phys_addr_t base, phys_addr_t size)
>   
>   /**
>    * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
> - * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
> - * for this region.
> + * MEMBLOCK_RSRV_NOINIT
> + *
>    * @base: the base phys addr of the region
>    * @size: the size of the region
>    *
> - * struct pages will not be initialized for reserved memory regions marked with
> - * %MEMBLOCK_RSRV_NOINIT.
> + * The struct pages for the reserved regions marked %MEMBLOCK_RSRV_NOINIT will
> + * not be fully initialized to allow the caller optimize their initialization.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, setting this flag
> + * completely bypasses the initialization of struct pages for such region.
> + *
> + * When %CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, struct pages in this
> + * region will be initialized with default values but won't be marked as
> + * reserved.
>    *
>    * Return: 0 on success, -errno on failure.
>    */

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


