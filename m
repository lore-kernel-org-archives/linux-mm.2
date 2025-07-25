Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5032EC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 06:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3D96B0088; Fri, 25 Jul 2025 02:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94AE6B008C; Fri, 25 Jul 2025 02:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82AB6B0092; Fri, 25 Jul 2025 02:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8D706B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:33:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F7F859FA0
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:33:56 +0000 (UTC)
X-FDA: 83701821672.13.4703D05
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf18.hostedemail.com (Postfix) with ESMTP id A12001C000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:33:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=BNHB4G1p;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753425234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcnKBfE2a+S1VW5IMnseKsBzXFCCOskdFvDUc4TUQMs=;
	b=jsiAJFeVu3GSpqio2BW4SUnZ+tv+C+x03EOxeysA5Ud4mDVQESq/Gt+JQgFUeP/VK/UWre
	dGcl4ZnMLFeCZz8xQzGrTOA7C/5jHLwF7u3cptlo9XPA66ewW2TOEOUqupVwW3bvf34M5S
	91VLHub76RLxBCv0qNcYmq8wwCAReaY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753425234; a=rsa-sha256;
	cv=none;
	b=BCa/lJMw+yeYQLWTlPPW3Ah9uK/Nwp0hJtZJc33ptB1qaSDaAGZ02PGUrQA7WAFTCU1Pzr
	4oF8h9QS4BkR/Al/9tZhb8yeJyJCj+eFykVOs7R2gb4UX+zidD6lFIjeSLHin2h1yTAkuH
	ijpYPS4tHavyF/GW/0g8YyuoXEvLeLM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=BNHB4G1p;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0F9163F75A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753425231;
	bh=AcnKBfE2a+S1VW5IMnseKsBzXFCCOskdFvDUc4TUQMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=BNHB4G1p6AwvuX8eQB5UkxJQBT0dBt1rnZHoImQ/fW555vDDFtnCog9LE0qGLXn4A
	 un+4Rx6f1YQgKJle2wzM3Bum2cGpqK1Wh+eWR9BTPao0UHDRPT0x8DtC5OLKheX1If
	 TYHsNPVe18TL3M7zMIRwoM8FO4p+J0gUfyWdvUZ4zTZYcoDaG+rK579Mnna1KS6yRQ
	 XDzdL2Ee4ePlJrYGLdPjgX+Yb+gMPheH4OY0sM6HvP1+UBco9CNcNEE7N5L5ldtH8l
	 zvNA6yAv9BN/vuQYOUzQrw36SpjjlawVgJGsKorqww65N6kIFxsO1jz5OHcWtEFykf
	 SL/l+OSTPNtSQ==
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a503f28b09so958923f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:33:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753425230; x=1754030030;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AcnKBfE2a+S1VW5IMnseKsBzXFCCOskdFvDUc4TUQMs=;
        b=a2utXXZfOGjKXEShLM5YuH94s6eQPXMHERxibjOL4MTP8gxBZ5r7E6FnWaVu1VpWci
         dGEqpSkw7P2UaQXSme/Q9nJ6h1CM9K6eUKC//dc0vC4Zb7yO0P933uka6p+QuMST6XLV
         6s6EniFDFHNH6KrNDIWKu4UdxYup04+lHF6+04OYg4se1ktte3kn4rca4yP81HJR6ELu
         8jIlzvy8tEu9b8K5/SbABBpc1lczOHKndaB63uSf5R+x30Nk3G9SHfv5u5H7hs+OP7Iw
         jigPHTW8WEg+l8NbSJsqcY8krKV0bI1e5/2Dz6oV15XeQr2G9p6T0mSzXqfUPPY7Qfhm
         fHDA==
X-Forwarded-Encrypted: i=1; AJvYcCVdc03mTFsWbEu4au9jRD9RnXuEzvHbMrJtLetBBuXlQ/XURy59ODahzVYJiO2v4LRruZIo9PCMDw==@kvack.org
X-Gm-Message-State: AOJu0YxbXN2aWgO187h8LcTq89zTTREDwPvljPEEqR2vOEiEk8PfBE85
	1CgST5otNJWhXfU1sMhhcvfM0viB+nWl+CtvRF/Pd5o/QdWzLmD3tpNqlLke12cHDXMbpnqitie
	sgv9kuNQGi+lrA5EBVd3HYfSg5XsxaUcZqq3ZXwGiWp5ZhqGV1evR00617qESEOnqNOlg
X-Gm-Gg: ASbGncsOuht6bnD3dd0qsgsDGYEpJMyntViDnywwL2sk8Kxmewx2niM2QFx2R0MnA+z
	q/jJwLJFTizPmgr9k8zNDMAqMEk0f5MkETsHNuAqWMba9gSOgK5qB1Y3eakCU0oJ7i/ATgMf/C1
	JpKO+a5K4Aih0VOkRa8AqLOtxgyXEhYNOa1BSgp+Cx/yS0hcKOwboBgU/rwmu35MK7nSe2ZdIh+
	PlsX0uAZ0j33vf+yM2iPj2WBPkHzvYz4Brpuflwi0XGmQXuQIWlP4DyIfeneRBXKjcKe9uO9tTE
	WfkaXlFRw5la1ablWNCBBu7A0vduVvMJ0dezb/EpqJSqJtcExurLLdf8evmYBQA4axlkxdFJoZw
	qIXD6KF4jiESaxjtRarKwUnUZ+8dBnabaAUP7
X-Received: by 2002:a05:6000:2c0d:b0:3a5:7895:7f6b with SMTP id ffacd0b85a97d-3b7765ecfd6mr508106f8f.7.1753425230206;
        Thu, 24 Jul 2025 23:33:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF33NxRWxXDTDDBoqgqdvHkBJufwM8gnuJUTxJTRNJxH7wzbKZ2u1yPOgBX88LofGXQiRQPhA==
X-Received: by 2002:a05:6000:2c0d:b0:3a5:7895:7f6b with SMTP id ffacd0b85a97d-3b7765ecfd6mr508059f8f.7.1753425229758;
        Thu, 24 Jul 2025 23:33:49 -0700 (PDT)
Received: from [192.168.123.154] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcc3429sm4041277f8f.75.2025.07.24.23.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 23:33:48 -0700 (PDT)
Message-ID: <1149732f-bc8d-4339-90c3-e34aeac9f1be@canonical.com>
Date: Fri, 25 Jul 2025 08:33:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] riscv: enable landing pad enforcement
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
 <20250724-riscv_kcfi-v1-5-04b8fa44c98c@rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250724-riscv_kcfi-v1-5-04b8fa44c98c@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A12001C000B
X-Stat-Signature: jnby6o9bctgduiiizseefej613tung6w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753425233-391594
X-HE-Meta: U2FsdGVkX1+WzLQQRVtEUS5NbHjqwTusHzQzYBPbBzaoISgAHZ5OC/LAbGFDkJoTUDH0Oy868GlG046vvT37JKkWovjUQbfjhiyh4+HqitqbCaw1NFmNquoCjY1ZjDT/tGblw5pw5w3DmEoB7TALsM+xqFti54Ie9lUqPhxNNCKFDFetlK5Yd5akmjeYZCeIYsHKZ7WXMcr/1JZuewSx5wTbUNxSuQ3fmvmtXR7Ule2iejU0Tbt/0XDVnlB8bTN1x3TTjCvJQatX90dWfVvHFwI7wIi8NpmdDFor8PGsdlkhlQpIAN0uTFRmYSFgITRospKu6gB6e2Y/2vbZR5cm1tCr2HGGLfI3zF2IkIAyFXTb0KtaQZVe3VVcAsvwhwhi/gALhDVxbO7dGPpOoUKgJIT7aIq4zMsnnVdzCmf3q3sh2vg6AmiH8lgcJHr9Irq5WZZbZPvxzYoKqFV/Pw2UR5/y3KayDjqUGyE2RlDZGtREALdZxHnwIlQR0BI+Iicl46htWZx02IgXCZbUOlLGMMufw8mFuvxWUWH62dWDXG+KhrwPUqo+wm9YYyoA3uIJ79i1l21rQetOfVojTlKVaWYdxj6vG9+Dlm8pZXO3j/jMr7jqNRTEcfON2MjWNwbx5Iz1cI82RuOjSgi8YrLzMG8s4XRdum1n5G/IZDZH95HtQKTeIytW91FMGflrsH4w97lsbTvTaJG84KE8zy/zLrqj2Dh6y5XrOwrmCbEfi1Rh3sQcXB5h8JEasj7m/sKWdBCCt/3NrcAMBY0Od0eKRaSFgKh0x2ORDediEslAmAxWec8VO00YmV2LrQ+kaY5rXNWVe1UNu5l1gD50OJm2ujiVYXMYeeqxKMZniE/yHNAilOjBfq88bPJ/ANS+/dnp+a6DYIJfOg1ltIh8PPT822E/0q1W6GV3fa4LFW+srcCftuSP7vufDtwyOFXapbBvPN2TBXiX8QzrNpMCD8L
 mVD0Rd6J
 6kOkh6x+XklRU85QCnUZNv1xpocjeMpJn2urhNVZsM9S1BazhxrRLX4QvVt1Es1jIcrIeTOmY6V2T413yJy5EulRLkdBPu3euW1K2aqAwogbBR5aFGJk4DQT4oFO3S5LBPY5pew2qSbHdCmIc+QfIiKJ2KVQ86G4N1ksNFfPW7PKfMObOzp6LjC3CUwiWw9hsZGMY9bqr3B+GJ4ui4sklJG801fn8Aj7Oo6fZsxaW84gaPCMK2B3vq8Ygu69ihh+68pirNVHjPSnJj2niaBSu8vMnPREUQv0X9AQ26r8d6qQZvI46OcXF6kVcA+OBzIdK1bchXd7qV1mOe4kfRjO1/UT8Bnp4EtUrh3IyZNLt16p7gf4+D+CPdmS2SE7ZV8JbEY8KKtfoiCSQ0nWBLhGMCKO2IRp5knG8ONlOTXcBSGn8QcfJc4yDBZdI7N5HFymNEsQWpl0+oRhe14MfXAWfhk06XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 01:36, Deepak Gupta wrote:
> Enables landing pad enforcement by invoking a SBI FWFT call.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>   arch/riscv/kernel/asm-offsets.c |  1 +
>   arch/riscv/kernel/head.S        | 19 +++++++++++++++++++
>   2 files changed, 20 insertions(+)
> 
> diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
> index e4d55126dc3e..e6a9fad86fae 100644
> --- a/arch/riscv/kernel/asm-offsets.c
> +++ b/arch/riscv/kernel/asm-offsets.c
> @@ -536,6 +536,7 @@ void asm_offsets(void)
>   	DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
>   	DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
>   	DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
> +	DEFINE(SBI_FWFT_LANDING_PAD, SBI_FWFT_LANDING_PAD);
>   	DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
>   #endif
>   }
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 9c99c5ad6fe8..59af044bf85c 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -185,6 +185,16 @@ secondary_start_sbi:
>   1:
>   #endif
>   	scs_load_current
> +
> +#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
> +	li a7, SBI_EXT_FWFT
> +	li a6, SBI_EXT_FWFT_SET
> +	li a0, SBI_FWFT_LANDING_PAD
> +	li a1, 1 /* enable landing pad for supervisor */
> +	li a2, SBI_FWFT_SET_FLAG_LOCK
> +	ecall	/* check for error condition and take appropriate action */
> +#endif
> +
>   	call smp_callin
>   #endif /* CONFIG_SMP */
>   
> @@ -359,6 +369,15 @@ SYM_CODE_START(_start_kernel)
>   #endif
>   	scs_load_current
>   
> +#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
> +	li a7, SBI_EXT_FWFT
> +	li a6, SBI_EXT_FWFT_SET
> +	li a0, SBI_FWFT_LANDING_PAD
> +	li a1, 1 /* enable landing pad for supervisor */

The SBI specification calls BIT(0) "LOCK".
Shouldn't we define a constant for the lock bit instead of using a magic 
value?

Best regards

Heinrich

> +	li a2, SBI_FWFT_SET_FLAG_LOCK
> +	ecall	/* check for error condition and take appropriate action */
> +#endif
> +
>   #ifdef CONFIG_KASAN
>   	call kasan_early_init
>   #endif
> 


