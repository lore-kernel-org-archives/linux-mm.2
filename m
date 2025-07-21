Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1717CC83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA62A6B00A0; Mon, 21 Jul 2025 19:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57426B00A1; Mon, 21 Jul 2025 19:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D0B6B00A2; Mon, 21 Jul 2025 19:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 873AB6B00A0
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:00:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49930801ED
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:21 +0000 (UTC)
X-FDA: 83689792242.06.DCFD38F
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33D7C20014
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:00:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFSbKRBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753138819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qL9A0aUIl8Uddr//bj642F7utZi72l2outni4topsME=;
	b=bBS7UZ7MOpWqf7L59XQMu3iC6pjMneiv7NxwNfs/23f16JvVthPVRC0PXCyhQ948OicWhA
	3V5e4TGe3f4xD9uRpYkoWccnItqXXFHUxaLn9RVIlaSClfcR72SWMBhcCUH5K0M1sKxH90
	FH1hMOXLt6jH11z3QcvLLkL1pNjf7aQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753138819; a=rsa-sha256;
	cv=none;
	b=gVyFHGSeAx2xAO+ooUXL1GbNratwU14KEOFk1g75Zt8VdPjqDddyylm3SnPrCgIGRrNiWW
	SeaSz68ouEUUfwe/Sz6rCqjYFzuY3NePqORa6CtdhR2p7IcF32Jj0Ho2g9/QABsRkgYoKV
	EJ6XTwafy5URE9wf/ydD0xIK/eFFaEQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iFSbKRBD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6075ca6d617so943984a12.0
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753138818; x=1753743618; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qL9A0aUIl8Uddr//bj642F7utZi72l2outni4topsME=;
        b=iFSbKRBDprE/KU5j2AcHfKce6J/GXJIkOCt7ZkvJ3gMt7OMeNuyhwVshlCCJWHGye1
         61mgbqbWSObYYfTvR8nP+FYyT3iEUB/GPEERmV+MklwLjynOY7nl+5FjXSVNULUgIKqB
         zQuaiFLmUWnOGiQiqthqx3Z6QtV/SeBirhy6/8OzU1W1D+SYwd2tktIgH3vwBy2isFCM
         OOzHInBLGF+5nR4arvN1rYD2I5MIDnuJSSgIGe9+OaAE34nodI0bVxcMVdE4YLdPZJPV
         Q42SIBuZEem5MWcjNGHpzse1iQZi64955fusmA/qvBcpXj3ltG0BuBrZeEHbJ1FrM/kj
         KMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753138818; x=1753743618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qL9A0aUIl8Uddr//bj642F7utZi72l2outni4topsME=;
        b=jVhXzkfEwnh79ONMPHOkLkPzOSV3YGeF2CTB+NAs1+LE2su0bh2a1xo3bdeLIXZ/7d
         jYdfzNvjyBqjefS5lGnI2QVIH2RgKEmBafnYK12bJucYg7H0t47gAidMdUM2ag5oUbwL
         17oexxS/CJSwy67KmuZrS+paM/29TmUNyzjFy+h8ACXM3xN/vxgJlJZ2mHARSd3z7D9x
         hutBdB+Sg/AJx5+tmJF7+RGlOA/D3+U0bKOJBRXTh3Ct3pK/W4EPeApOZqnEjkM7OsOh
         3I1tBfrnzQuTxUDeHRfrQdJ8wIO1Lie6wTo7h63pZS1+0zTsZl7zILYJbfT93js4A56+
         Y0SA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ7z7blb2A/9156yBkCZt5fPwWIgB7zIA7LPHQTriPqRJMR45AsrUwFcwKEhCpZiBB1pdIpnTdsw==@kvack.org
X-Gm-Message-State: AOJu0Yxy0KfjU1R07nxqIxN5vkIrbZbn4uoYRUGSpaznoujnpGOITchC
	CBYwueTULVD0M0+Ye3ssyjrT/OZiA80C6OXL01G+/LnrCVArRm6cTAZY
X-Gm-Gg: ASbGncu5QTpWAD9POARIjYhxpAdIghtrWWtefZIVXIlw8bqSB8rvRBgRUJTOvM8qwQ3
	nH4ANqEeW9vvzNg5hNr8S60zRcS9TMZgz1UDUt7lfmQ/0+ic7sjdzhh/Thg2zZLlNBDF9J/Ybf6
	rTlhI5Ze2ARXTO33zp4KMA8lj6ZQvXLTyq2G+qOqTj+/9B0Xv5VPvdxkWHXaPlrS8rE8N+iF3AQ
	JntPdUP47iZtzMx1Hpc6zMvbgS/3JQX4Ee+5nWU0QkYosdikfnlUlvtI5+T9fhdtxcnFu0GhZw4
	a6TCXW3lmeD7v/2UFR0JFiAfvnKHICZNOsJiq6ict9dW3W63pMLJM1fzAgk9B40hgODz85wONNJ
	ELClSkYjs1BjKDaGs0RI5bOyhtYqf5oMX3QUUmkLzs7SODolAz12Pc/miuHt+rAbLLxFI
X-Google-Smtp-Source: AGHT+IHckuXEWvfAMpSzjjL6pEsgi7MWI7yYCMOiqpAqEO5gMn0ATvaVtw0/vmnoItEaOlX4DlEKBQ==
X-Received: by 2002:a17:907:7fa1:b0:ae6:c555:8dbb with SMTP id a640c23a62f3a-ae9c9af98e3mr887526166b.11.1753138817353;
        Mon, 21 Jul 2025 16:00:17 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6c7d8357sm753164466b.52.2025.07.21.16.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 16:00:16 -0700 (PDT)
Message-ID: <c8b0be89-6c89-46ed-87c3-8905b6ccbbeb@gmail.com>
Date: Tue, 22 Jul 2025 00:59:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/12] kasan/loongarch: select ARCH_DEFER_KASAN and
 call kasan_init_generic
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-8-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717142732.292822-8-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33D7C20014
X-Stat-Signature: ikh8qfbdmfoig5kktiiwj4z7cht35shj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753138818-286643
X-HE-Meta: U2FsdGVkX1+rcNp+PW06rpIT7HgxEbLkc93un9Rm4CkFpGrLAzk2SBbeYXWySQ8xBDkByZyY8yVLvf4kA+lA9JLL0JcUqlgteaC5AQqQXB8EIMpcjLAXE3oOufFkM62Shbe07i5f1d+blSe5iXLm9P7u9HFNnm38mthHGOoCKICmWUXgSuc9Wk5m//ohSAdkgJIowCqkTcfO5maVMpxUJy7PxeQHoo0ux7GDlBYmwBmqNPn36fw9gFx69h0vdpdhkYUDI9kibr5a/rBLofrZkSGFRXKRoHWpqzIU0GG2DgPilmhbsRUBwG5dPHAMysJ6lWnLQBYzVJEFvVTJL/xJ600TKDNtmMuvFgE0x5dk6sRc88sSDbc4TCzr6k6mcvt7a+h7q/Ot7u5hhmy+X4E/bs6w0YHo7nEd4Tdpu1QvGIycSX6yw8ckOuJpyupmZTPe4jORJY4ERA90bBJSexR36GyIaf5NydlFJQv9ZQfaiWw9gL5VzQzagN+vMuBVEPXPb9rdRit7YrN96WxvWvsnUw+lUYUlDpQsuA+vHLC5RR1s+c+IWQ1Q5/Qi4bGsBLkaS9CEEddDBG2uqzQ1VxlgHwuOWEh9yMneF+J0pS5bCQvpPBZeiD9yHqkuX0oRZoJSigl6C156nGzQswtIIpspqqcjGtBQUJhx5zkyIIO+3UZG96qAT394YMLTCuXhG8liUAtzT8karjRYFnmGhqTSqfHdQSZL5bQ7s4PvcRFZtM/CQe9kYeSzS9p2ffnwlAYhK4LCYfrN8wRKH5xPUU14jTVbM90fLeCkEpN/t+WE1sMw58sbCbVK7SVLOLU4LKceD0pea5M5lcCSVji7A9Mc/pPOKm3Tv+GL3eUlk9wcsYHdF32zJA6jV6XN7rVTFZDBItoGWyKE4B6KHhWPgV8EE4d6agA8FivDpO+Na2pupTrlMiSg9eNTwjvuv01XBgDmujwhlFVhh3irhbKBvZA
 Iq606LWE
 moM7Ht38NauAOIL1cWGPJ7zSQJIl2huGRLrQBlStZAkWW+P803n1xbWIsSWUDcbdo6cVpQGhm1cj0MGSY3tdwH2g4qGf6NGh6HRHC8Gp+hH/FwpB7quCBbGTX+i9pZlDZmQm9V2yGvQemJ3nopg9PGujyfmcEww9iGUBPfmXCCpcTauzSuIAIPCh78iqRYA8p5edL12SKAgpBEVvLZcRcZ60sXfqQOaSaqWTFKdqNnaUG0yhkfQWV539btl1xN26muOjvtsNxlW28o6GVfIxtQpGSrXBlIFwjddPJtmtGXQHhVe0eGMPZE0trF0CaVXFnTOZPcQ5Kza5ubmFi+jXRidenbz995YVvshfRgQtgLEh8neYhOTEYK5nngNKcjdK3ZX7EFq+wT57lFBowb81rDBRAT0l9ioLfn67maSd4RnbDJX6KIuV0dZeYBjSqEVUtxuLRntRtkRzLP8Yt3O5xTwAAx4AYjdXmRsqV0CYWFLOjX7pVfM8QkPYFe7N2PTzB/Q+fNhRvX0v/YNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:

> diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/include/asm/kasan.h
> index 62f139a9c87..0e50e5b5e05 100644
> --- a/arch/loongarch/include/asm/kasan.h
> +++ b/arch/loongarch/include/asm/kasan.h
> @@ -66,7 +66,6 @@
>  #define XKPRANGE_WC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKPRANGE_WC_KASAN_OFFSET)
>  #define XKVRANGE_VC_SHADOW_OFFSET	(KASAN_SHADOW_START + XKVRANGE_VC_KASAN_OFFSET)
>  
> -extern bool kasan_early_stage;
>  extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
>  
>  #define kasan_mem_to_shadow kasan_mem_to_shadow
> @@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *addr);
>  #define kasan_shadow_to_mem kasan_shadow_to_mem
>  const void *kasan_shadow_to_mem(const void *shadow_addr);
>  
> -#define kasan_arch_is_ready kasan_arch_is_ready
> -static __always_inline bool kasan_arch_is_ready(void)
> -{
> -	return !kasan_early_stage;
> -}
> -
>  #define addr_has_metadata addr_has_metadata
>  static __always_inline bool addr_has_metadata(const void *addr)
>  {
> diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
> index d2681272d8f..cf8315f9119 100644
> --- a/arch/loongarch/mm/kasan_init.c
> +++ b/arch/loongarch/mm/kasan_init.c
> @@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
>  #define __pte_none(early, pte) (early ? pte_none(pte) : \
>  ((pte_val(pte) & _PFN_MASK) == (unsigned long)__pa(kasan_early_shadow_page)))
>  
> -bool kasan_early_stage = true;
> -
>  void *kasan_mem_to_shadow(const void *addr)
>  {
> -	if (!kasan_arch_is_ready()) {
> +	if (!kasan_enabled()) {

This doesn't make sense, !kasan_enabled() is compile-time check which is always false here.

>  		return (void *)(kasan_early_shadow_page);
>  	} else {
>  		unsigned long maddr = (unsigned long)addr;

