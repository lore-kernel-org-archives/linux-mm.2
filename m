Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C46DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9706B007B; Fri, 25 Jul 2025 02:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3666B0088; Fri, 25 Jul 2025 02:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8EB6B0089; Fri, 25 Jul 2025 02:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBBBB6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:13:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C03616062E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:13:41 +0000 (UTC)
X-FDA: 83701770642.29.399FE36
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1AD14A0003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:13:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=SGwTVuWP;
	spf=pass (imf25.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753424019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TzyPAUEa1ra9f+Fo595oVFYE4lltInSXTAdJNreFcWM=;
	b=w7CfTidILa6iZpf2nYtdeBQsH4YY+uEBxs7iculNapmFWxhx1E5GnKZMRHIIiFHSpSV2vi
	2sLcZF84fvSm/KQTq8hHcZvWBiRTjb5jf9kQ93ipcpRnl6HG6I+KrrLsUV7CKffpl4G2Lj
	Roy6kXblJBNlxvOFuS9+nzO7uzTUQZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=SGwTVuWP;
	spf=pass (imf25.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753424019; a=rsa-sha256;
	cv=none;
	b=kKB/RWYkcPwqdKsBpErsBcRdPGsq8UeGyisUB86p7SmW4NRIT45/+nQ5IqLP09D8m0ywOA
	nzZsQnnZWFddgQ7yAOpgAqO0Rs7epCbv38MHAqOuv06CWo7f0I80/iL0oUzVJ4d21UVviJ
	ZngFpYGMSJSIv2oaKze2gdRqC+AE5oI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4BF6F3FB4E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753424014;
	bh=TzyPAUEa1ra9f+Fo595oVFYE4lltInSXTAdJNreFcWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=SGwTVuWPpY6c1sBas8ZSrZFlNSdI+cToZfZTpDnBCyoc3IwaGhT3YzzQtVaa1NLut
	 ovTwZ7OmUcw2zORa0q2Nm8VPL3g5soWaNEXJUcAv+oRYyVsUq5vcX57CLMc3WQm3qF
	 MFAjEA4UZj2hEjU9PhoO05Jz0xqpe5Bx2oIM4ymLfTaYRbd1SPJ++EwQkj5aqP/hyB
	 RxKmNF299j8c9A8zUQN1K47CCyokaFNvJFzilFten1OddENebYsaY/riojolSXZojC
	 YxAH3ZbJHLGIiihaPFxJmskXRlSlOys22+qaLRGcKlPUiqocLFKhz45lHYtfRQh5fU
	 LBpl1JJv4XQBw==
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so10621405e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753424013; x=1754028813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzyPAUEa1ra9f+Fo595oVFYE4lltInSXTAdJNreFcWM=;
        b=V4WFwUh+2YX9tomY5Z58rn4hilxIMcmTjhb814E5/4R7l+xRl46DbpAPdJ6gHAmkVJ
         aRol66O9G9EwL3B9eWbXjyF0l0V8baZnfhGgEW9P6v64BDng4PRGjBiIT7JFVt+zu1VR
         GwxmHSgn8yO2vUN4GGcXhC/6M+pQHgB5W3tczoaM03eCkaWfmyern1bxwh61SzC8ee4H
         sXs1AkoPGNormYsj6G4no1gDa079JngrBPnhbXM8K8dIP1oVzrRrOi9n//XNEiWzf9uT
         eNXxqHoslSUaXxp+TrElvk1Biy9JRJoiEkVtdRUHvOwPa9n49ahKIdFk5TUy+aegXNb/
         BnsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWym32eSwkGO66nlrANdONzCH3FLbO8gGl4jct3c/aqZInvL7aDyMPL5DI5Kum43eghJdIXdd/V8Q==@kvack.org
X-Gm-Message-State: AOJu0YzEfO4i3GpKMdpQ4Vz1VYNsk17MSfAKV6rCS82mPglHDC3s5FiK
	E6Rp8vrjyxeL3oXIBAeDp/nngcyH75NrOuTPxTNTdLlNg1Lk+y7xSzrKK6K7A+j8mLDItPEe25K
	TXQhHOZQTlM3CeoHXEhEEGHL/p+jKQdhPrc4Du1/kJ9Pq5daDGaHYI9dyIotEQthibBNy
X-Gm-Gg: ASbGncuLMAfla55iNf2IfwaKxBRzIV1FSewCRmP4Gbod+x0KQ6pK+eYb7b//NnBz7Z4
	yWZq+VA/M4wSkRfgkVo1km7xFmBXVbF3g2sLDuWM6lfOHs2XC9aFbLXN0sYdHbR4UaPr+r2SN3t
	yEzNJBuqaw0H7ogQlPfEu9OvslBtjy0/ZUAbDnsB1GZu7MdOzJqa/N2iKwzyl7ES0PoI7FmRbwC
	BV+ZkWQ5nUyDZf4+BQI1cpgCkooUXsnExwQ6VEgUOIsWb5dZuki1v2dDReR474d6jPRCont0yHt
	y+w/ypVJd4lscX5uL07KjsADFIO7Hhcj82M7w1MFwQZOJMcButaNlePHN13SWmSTDBwR/RGfaN0
	P2RPjTcRAERtVCKWAw1oQNCeMT/pim6Wc+i33
X-Received: by 2002:a05:600c:861a:b0:456:1bae:5470 with SMTP id 5b1f17b1804b1-45876b12ab6mr2570235e9.8.1753424013117;
        Thu, 24 Jul 2025 23:13:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnuDATio1q8lhm2BzVtYuo6oTtxWHR46flKXtmOHWUTwYg4EBDhbjT8wj0HyskkwGEINn1ow==
X-Received: by 2002:a05:600c:861a:b0:456:1bae:5470 with SMTP id 5b1f17b1804b1-45876b12ab6mr2569725e9.8.1753424012699;
        Thu, 24 Jul 2025 23:13:32 -0700 (PDT)
Received: from [192.168.123.154] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705bcb61sm41269355e9.20.2025.07.24.23.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 23:13:31 -0700 (PDT)
Message-ID: <2ba0c09d-2783-4dce-a889-06e16abbde61@canonical.com>
Date: Fri, 25 Jul 2025 08:13:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] riscv: add landing pad for asm routines.
To: Deepak Gupta <debug@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com,
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com,
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com,
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com,
 andrew@sifive.com, ved@rivosinc.com, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>,
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5zsirxr9krqigcs1ddawgj6b4qydp86e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1AD14A0003
X-Rspam-User: 
X-HE-Tag: 1753424018-935135
X-HE-Meta: U2FsdGVkX18L0yGQod3d0/Io8ShUqUDnYt6VgtErIvuFmzJdL3H0d7aWd+JjKuESEl1Is8mFKM3wtr4IdQfKNNwuhCX9lJREOIcga5KqOq0/pAESHuIX/GZrfTTEzqyUnzSOCEf4Ica5VlLFwH9p2fzxH+coJXltt0ag4akfTFfDDhEKtFapChO04pa+/LnUp8KuYoFhefMvFqiBX4tscNNYWrVYGZLJuPLhzqoguueGcKj5QWYreHht3OlvG+9/4aQSxRqlfbKbcnB451PFCMAhJx61aoFVI3Zi6U/K0LPXdC8oW5qK57uzD/yIh2U8PsjzCIFyGzPaixRqzrtEjZzeblC7U7F/uyPoxt0U31YKCX8kcfjTJGe8+wh/jG3JgooEbgUpD/JtIJ5stVIfuEN4N2M7g6ms7iFozM+xX3ROHHkFF+36ipVgOzhcsE/zQ8Sqp6wHnkGeuLmK1v/IH/14YshqdogD1cwe+sdbn8MGPh9Wtay6MojTWYdFenivwYXR32Vi7x5GekO8q4KrfAHbKSLFSECBg6EpGK13jlZMi+0lrOkWmlVFPGMqij0pbz4lcWY9C1GecxEzBAJIhQ9+oBu59eae4bURSt0QA6jbFjbb7++d7I/BX4OfciXCS9p1cEM5ba+LTTG30usOT2sGqIbTimS5p7eJSr47pOstOJUIwTcnX/TRvDU0grRUxi4HrZq9K/PED5TjWSkoEjg3BL7a89kYuxiYsUv+4l4KonJam7OBA2rhOpax7F0N/zAepg9ANKExxL0a9VUF6MBcHOfQkV3sGl1LgBoEBwwjT77aB2ocq2/IeWLYgI4rQuaxWa0nrCmKwcOQzJamFhIR7pBvFEv7+3JFLrDBrG+iAINoyxjRDqHpztOhLBkegW3hASs8kgZxosGu8FGwWIOt28e5cG72hlV1wdToAPR+cUUmesHmLFMCx275p5j9LOWsD9hXFpLSfuJK/Pb
 DLY+EvRD
 8u8TC84Wqvqv26PPa9AuGh2C2O84WjQv06XhafgZqg7FeUtnn49raHX9kyFAmTXdwwpbDcA/Zgtv+t4+bPKvSm7M1+PVZOeCNgtosFPI/Uiqyls0PYr8w28bS/TTbJ9HQoGaO7S4NNh24tJ2ySIf9zvI9Qn6gMBMMVJlyiQvQlwzBQNP2TFBNsrML3G+Cyp+LnNNoOg2KTeALuXgQP5aBfc0tMzGqiL3eKlpbWgY6Lheai+swRUvunAGwD9oy4YPOyBkX86Cev1rxTW/ajnP8eMQA96JsE3YMK7tDcP9Q/eE+omZFUYy5YJEo1z9o4QIArRQQRiSzsq9uw3Jrfd/b2hopwatURT4oaBv8bvdWMal1yhfrn3oShU4pe6snon69lOpxM1ciyj+NkORughEwg8fkq02+TzEeCf6uhNGWIuDMMT+UUt4dT/iEsFofe7HBSpLaNfKsA4UhO4JT989EegoNQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 01:36, Deepak Gupta wrote:
> SYM_* macros are used to define assembly routines. In this patch series,
> re-define those macros in risc-v arch specific include file to include
> a landing pad instruction at the beginning. This is done only when the
> compiler flag for landing pad is enabled (i.e. __riscv_zicfilp).
> 
> TODO: Update `lpad 0` with `lpad %lpad_hash(name)` after toolchain
> support.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>   arch/riscv/include/asm/linkage.h | 42 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 42 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/linkage.h b/arch/riscv/include/asm/linkage.h
> index 9e88ba23cd2b..162774b81158 100644
> --- a/arch/riscv/include/asm/linkage.h
> +++ b/arch/riscv/include/asm/linkage.h
> @@ -6,7 +6,49 @@
>   #ifndef _ASM_RISCV_LINKAGE_H
>   #define _ASM_RISCV_LINKAGE_H
>   
> +#ifdef __ASSEMBLY__
> +#include <asm/assembler.h>
> +#endif
> +
>   #define __ALIGN		.balign 4
>   #define __ALIGN_STR	".balign 4"
>   
> +#ifdef __riscv_zicfilp
> +/*
> + * A landing pad instruction is needed at start of asm routines
> + * re-define macros for asm routines to have a landing pad at
> + * the beginning of function. Currently use label value of 0x1.

Your code below uses label value 0 which disables tag checking. As long 
as we don't have tool support for calculating function hashes that is an 
appropriate approach.

%s/Currently use label value of 0x1./Label value 0x0 disables tag checking./

Best regards

Heinrich

> + * Eventually, label should be calculated as a hash over function
> + * signature.
> + */
> +#define SYM_FUNC_START(name)				\
> +	SYM_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
> +	lpad 0;
> +
> +#define SYM_FUNC_START_NOALIGN(name)			\
> +	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)	\
> +	lpad 0;
> +
> +#define SYM_FUNC_START_LOCAL(name)			\
> +	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)	\
> +	lpad 0;
> +
> +#define SYM_FUNC_START_LOCAL_NOALIGN(name)		\
> +	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)	\
> +	lpad 0;
> +
> +#define SYM_FUNC_START_WEAK(name)			\
> +	SYM_START(name, SYM_L_WEAK, SYM_A_ALIGN)	\
> +	lpad 0;
> +
> +#define SYM_FUNC_START_WEAK_NOALIGN(name)		\
> +	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
> +	lpad 0;
> +
> +#define SYM_TYPED_FUNC_START(name)				\
> +	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
> +	lpad 0;
> +
> +#endif
> +
>   #endif /* _ASM_RISCV_LINKAGE_H */
> 


