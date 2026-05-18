Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4F0CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73646B0005; Mon, 18 May 2026 16:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23B96B0088; Mon, 18 May 2026 16:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38AF6B008C; Mon, 18 May 2026 16:03:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACEDC6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:03:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BB911C097F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:03:43 +0000 (UTC)
X-FDA: 84781615926.14.E34E45B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id 31B8940003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:03:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oaj+O5+K;
	spf=pass (imf11.hostedemail.com: domain of zlatistiv@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=zlatistiv@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779134621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MzDAdCRIBfI7BMaNrZk8E4Be9btob7hVTrMIXPtgrU=;
	b=am9pSxPlf3VTRDMo7OAha8pqMXcIWe4b8LKi3riQK3OBe/Rp4MTw/5pjxyRkCpRLJskwJR
	uuPfd7N0+SXSTaZs2wSbCDQZR5wLqFr+2yeGZnD3dBybcVy/iaH9niIJIhCiXFd/NSJqQU
	7E95Iq6WsMlrugXK9gx6lYVHG0bUK7M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oaj+O5+K;
	spf=pass (imf11.hostedemail.com: domain of zlatistiv@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=zlatistiv@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779134621; a=rsa-sha256;
	cv=none;
	b=rsTBj5OUtCDmJ2EPMFbWz3vEB6UM/Yj3E2RuOcD+lYU5Ql1SMtVd4XzUsR5bXPOxnPnwKj
	o2EKKbmagAx+ddx6DO3/zUJzn1FkTBtXLoDaIT2BrHarvt6owubm74uDO8ePojGdIMDejw
	5xcDIznB4litTzzbHD6SxUQDcmaFaKk=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso15369815e9.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779134620; x=1779739420; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1MzDAdCRIBfI7BMaNrZk8E4Be9btob7hVTrMIXPtgrU=;
        b=oaj+O5+KkJBR01rRetM5kKxiuughiK+7/q6rUxhea+oS7hfrUiQN21JJbGhJwADbZP
         a0xmSCsnGlXco0JVR3HvpLcCamkluUx2qW+/R2/7l5SPefAChcMSxoSvk5qUdUavpO/r
         3u6rsa5VZ6cfLiQ52eMRqJQbPN98sGSkUaKyFd5ECNRPoIuO9yyZqcLB0SNgUZqQxMRm
         tQ3hNg+gaO5p6/Z63M06E+xVDNcxunDCedG2d/8JvxkYv10bZZASSjCGtotao9zyZoxf
         G86tg3Rb7wM5nHs5u/pb96kJpVHZEQ8XSo9zB6fcjV3zvL2SX/0Wv0bzkF0RucpBNNv5
         UPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779134620; x=1779739420;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1MzDAdCRIBfI7BMaNrZk8E4Be9btob7hVTrMIXPtgrU=;
        b=O9WpVhXCVODdA6ZMmWrtEiyVGrokvsU41WO9fZ3Doy02HsFB/PPOnbq2Clpp5+ku0P
         Hcpszn4J2PuLkCYfQo3xHVg+LXVwwQtDItRYr6WBCDtfwJEyB0QTtjt74RCiLumb4t2r
         WV44zQBNdXrN2mDGsbGr+C9woAHM13QqAzmVUqoc5CwPwDa3mNkJynCw5g7DRDfOV6nE
         nGiQs1XiC2vppm/l1NWT1S+8ZqhUPYiMEz0LtUEtdCueWkjJqCrWet76KHE8/9818GOy
         zMP9JeYQBZ8/2jjYWwMGMbwmUN3DXf3LYj7OKFmmVtU8Sb2ekAfyXhQARo6dv5YXzBtb
         CdBQ==
X-Gm-Message-State: AOJu0YwT/53gP7jPLrmOu65KsSB/52+EH+Y8FuEFo5fnxQZ5l/6I6H+E
	a61l9g9AlecBhNIfAzLAR46Fw/uGyD/IyCRZQXtPoHLTiMN7JCaABrrc
X-Gm-Gg: Acq92OF9KwwtOQY48Bsd0U82tB0DJ0TI+D+AdftkWg5ScCAL5aeHBDBpnvcT8bng+LS
	FUoKVbooN/yvK7lACclpg0wMSXpbqVL8a4ykmp+fOwHe78Xe6/Z+vtPp21JxqAmSxCkw26hTarc
	j2BOuU+QFW9rrVIexcZPbTWxY4wNKNOZpDr25fQICzfFh+rL76rjbPGXiYIuouz20Lx9RNNWzAp
	itK1wr2SrOPsPo0pM2LSaxc+JKHtDgSFL/BjJ6CyNbRgJcgydQhMQQmRBOR3RouLVMDiDwhotyI
	C1LERagRHcgAVFYSK7crd9XhMWW0QjVKFAr74NVYUdylLAcaI4O8NsenvMais6mjtJJNIGTAERo
	Mf0nr8I/cu3neRBNxvPr9P4TQdUiFfe9JTEgmyQqMO9aHtZiucPIOeDuJPAArZHkTO1hqH0xiIB
	HMqIQJ54NNDexJrexlOki63MZoaA==
X-Received: by 2002:a05:600c:8592:b0:48a:5970:1fe1 with SMTP id 5b1f17b1804b1-48fe60e51f8mr195876115e9.4.1779134619467;
        Mon, 18 May 2026 13:03:39 -0700 (PDT)
Received: from [192.168.1.169] ([46.10.223.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768bcesm41893491f8f.4.2026.05.18.13.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 13:03:39 -0700 (PDT)
Message-ID: <1aaef0a4-bcf5-4bce-87c3-f1061b4c11f8@gmail.com>
Date: Mon, 18 May 2026 23:03:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING: Found insecure W+X mapping in v6.16-rc6 (Bisected)
To: Mike Rapoport <rppt@kernel.org>, Dan Moulding <dan@danm.net>
Cc: linux-mm@kvack.org, Peter Zijlstra <peterz@infradead.org>
References: <20250715174325.8277-1-dan@danm.net> <aHasvAUPPG0D0Na_@kernel.org>
Content-Language: en-US
From: "Nikola Z. Ivanov" <zlatistiv@gmail.com>
In-Reply-To: <aHasvAUPPG0D0Na_@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31B8940003
X-Stat-Signature: 8hqcuuu8oee7ht8a7h9o53njuxm614kz
X-HE-Tag: 1779134620-669055
X-HE-Meta: U2FsdGVkX1/fOAea4Mg7oj0RScgOevWa3LudmUzmuXRZT0Cyw58D2U1/XoUUYhd+sSom843IYSEabJRkuDkouSZLRLlND8kcC5P/TTHja4kWvoYlo2mFwkWcfNwaEB+l/Ib3lZCervZ+XIrXy+n4Xq/sGR/QKe17iR1tE5qIEUF6mgfv565tY/8O7attvT/XLzA8u2tndUeb8hgJGXZxnXEI6ksOBi/BvGScxwCgPrV61AISDIB9AcHEo/Zn2Ah+kUSaooiprjJVNR4kjWqUYMRB+kuzf5P49MSDc2LxrPQO93ixDdZ0IHwWJ11AJdganvWqszIacAxWdEHTzKhsQc8dOe9mdfM6weE+NXk/JKAvUau9LMfLC0lnu7JlboavHMeirV723rlwj86FRtQuKmy/P1nwPfgDOY9IwYoZkw/P20GIIgIu8OVFRAT3wDR5tC64H86OV15VJLDd7qP0KyePzPL2ooVB13fY4NeyWDSefgaUdB6bL32irlV8AX7S2ePhEqP+RTgdFw+LncwwST2XTA/x5tYLTZ0744akUI5F+dYZikwvP2voHxPAJJimoXH1PT4PQg4lB4df0j5kUxwhn8gpa5SvbttPle7iMZKCnRs6quqyb3BNpOefq5aursHdQp/7fqjc+TvJo+VNXo6nqeDkhzyF6lS2F4ICA0dI4x0OY8vYu4MX76Wn3O8Y7OyocwwCW6udhn3ZlTVxawtLCK+0+IjH8PyIIsxYvuGU4e+F7sTbLHl+bHwiGu5kw7T+hEFlbKQM3nm62i42WP8SxyPcZ0UuduP2IfuKjFmpT/dGuGpEqliG3z88m5Se1t8oD9kX4D1INGEnCFZkGMy0cm7+oZjnRGO6Hb7Rn9Lond6AWpyoaGnkBTfXLguEMhBApwxV/7xPRR8pef6YaNJaygMJ9xVLo7ZcX77cA4rEN8j7NjUTU/1fnTD1Jyyiy0u387+05ozTDohG4x3
 RM+j1Uri
 wqmikA8gvuJ3q8aXhSt0vljsGmHKCGWVyF9PnfZ0VrZZgTj1Uo2hKXFkBEE+pc3eJPEPweG5bvNagcjk16e/SC9bfm8N0jnUIX+Ulr2cXR/1aszG89gVXb8zcB6kTk25LTdFnbsT2aJ5I49Pcw400BgEzjSsz5nPzh50rAmTshmeDX1BqBbVg7fKFx9fD3pGhDz8UkyicEuXLJtqh1bfJaY8dy1H9+YIqveKUncvQxBQ6nxup6Z+r0WB0F5RYsaycngjHOBZXUM2x51UZaEU4PRr+KnWMvdkyk/3I8bT01L3wpnlWuKDDRK32V38yHGWnourO61J9e+ty2yQLQaVbK1yqTzvWDjD+7pHnvoHuj/3A+0CvgihMlfM0FiXiBeKTcMZSQb8jhPHz4LL9IGK47LnranfTqlKuduVmNooLzPZ8xxsXx0lIjNNgoWF9gZNAgFhbBSttIZBBz3g1KkqmATMNPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/25 10:32 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Jul 15, 2025 at 11:43:25AM -0600, Dan Moulding wrote:
>> Hello memory management folks,
>>
>> I just recently started testing the v6.16-rc6 kernel, and started
>> getting a new warning about insecure W+X mappings:
>>
>> [    6.022847] ------------[ cut here ]------------
>> [    6.023020] x86/mm: Found insecure W+X mapping at address 0xffffffffc0247000
>> [    6.023200] WARNING: CPU: 5 PID: 1 at arch/x86/mm/dump_pagetables.c:246 note_page+0x6ec/0x790
> ...
>> [    6.031153] x86/mm: Checked W+X mappings: FAILED, 10 W+X pages found.
>>
>> I bisected it and git-bisect identified one of three possible commits
>> (I couldn't test these individually because builds at those points
>> fail to boot on my machine):
>>
>>     There are only 'skip'ped commits left to test.
>>     The first bad commit could be any of:
>>     0b0cae7119a0ec9449d7261b5e672a5fed765068
>>     47410d839fcda6890cb82828f874f97710982f24
>>     a82b26451de126a5ae130361081986bc459afe9b
> I'd say this one is the culprit: a82b26451de1 ("x86/its: explicitly manage
> permissions for ITS pages")
>
>>     We cannot bisect more!
>>
>> I then tried individually reverting each of these and found that if I
>> revert 47410d839fcd ("x86/Kconfig: only enable ROX cache in execmem
>> when STRICT_MODULE_RWX is set") on top of v6.16-rc6 then the warning
>> goes away. I looked at the change a little to understand why it might
>> be causing a problem, and I think it might be because my kernel
>> configuration does not enable loadable module support at all, so in my
>> configuration STRICT_MODULE_RWX isn't enabled and is probably
>> irrelevant given I don't build loadable modules.
>>
>> Please let me know if there are any additional details I can provide
>> or if I should run additional tests with debugging options enabled, etc.
> Can you please try this patch:
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 71019b3b54ea..f97e0a50e60a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -89,7 +89,7 @@ config X86
>  	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
>  	select ARCH_HAS_EARLY_DEBUG		if KGDB
>  	select ARCH_HAS_ELF_RANDOMIZE
> -	select ARCH_HAS_EXECMEM_ROX		if X86_64 && STRICT_MODULE_RWX
> +	select ARCH_HAS_EXECMEM_ROX		if X86_64 && (STRICT_KERNEL_RWX || STRICT_MODULE_RWX)
>  	select ARCH_HAS_FAST_MULTIPLIER
>  	select ARCH_HAS_FORTIFY_SOURCE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  
>> Cheers,
>>
>> -- Dan
Hello,

I've hit this too when building the kernel with CONFIG_MODULES=n
(not because I need them disabled, just while doing random tests)

I suppose "(STRICT_KERNEL_RWX || STRICT_MODULE_RWX)" is redundant
as x86 always selects STRICT_KERNEL_RWX.

Since I see that STRICT_MODULE_RWX check was added some time ago to correct
an issue with module mapping permissions:
47410d839fcd ("x86/Kconfig: only enable ROX cache in execmem when
STRICT_MODULE_RWX is set")
then perhaps something like this would make sense:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f3f7cb01d69d..25eeb9b395ba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -84,7 +84,7 @@ config X86
        select ARCH_HAS_DMA_OPS                 if GART_IOMMU || XEN
        select ARCH_HAS_EARLY_DEBUG             if KGDB
        select ARCH_HAS_ELF_RANDOMIZE
-       select ARCH_HAS_EXECMEM_ROX             if X86_64 &&
STRICT_MODULE_RWX
+       select ARCH_HAS_EXECMEM_ROX             if X86_64 &&
(STRICT_MODULE_RWX || !MODULES)
        select ARCH_HAS_FAST_MULTIPLIER
        select ARCH_HAS_FORTIFY_SOURCE
        select ARCH_HAS_GCOV_PROFILE_ALL


