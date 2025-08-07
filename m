Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C3D3C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6DB88E0005; Thu,  7 Aug 2025 12:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D878E0001; Thu,  7 Aug 2025 12:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE50B8E0005; Thu,  7 Aug 2025 12:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8B4F8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:35:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6167F1164D6
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:35:41 +0000 (UTC)
X-FDA: 83750512482.19.59F0FD0
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 491414000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:35:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWL5IOFz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754584539; a=rsa-sha256;
	cv=none;
	b=LGWD2/O2ZD1CCethGNcxqwG4DwlM5KJmffmBhJy7/vG0N2/6zR3arBIJgmuxVb0YHBX1s1
	Rc93q8Bx9xg42jVopfAXVNodimRyw1/AauRrfi9iKeNRarSp+KlM55X5in1ODuonewr68H
	2C4kh1HjZXvm5Dre5svPO4AHgT1W/ks=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RWL5IOFz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754584539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtJ7SukZttuLpvU2sM4wbLSaHHmB2xRR25bbI/ADQkc=;
	b=WjilFeMyWMOiwWx9+S060azxtaCaZwWWChVA9DZH5W6fhVwTxqkYTSA5G3kM/CU6E9IFCH
	oMQX0cN95ZNAIc16gHBrIl2VH/GsOdsYCIVs00l8Mou8zqrLhvx2QSXt4CctRo/CeJQdxT
	0NqrsQU10V2v82pJt5CigDK8rUt5liM=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b81b1513fso164406e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 09:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754584537; x=1755189337; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HtJ7SukZttuLpvU2sM4wbLSaHHmB2xRR25bbI/ADQkc=;
        b=RWL5IOFzoGjaQ2P7fWSb5FcYF1pxlRtoBf6+E/Vn3plFF3G0t5PmZIXJp3WEYGUhzB
         bmHPWtSaZb5znMh516mSnaNXtsNG77EK84RAVdADohVKBa4/Bmxb3BjrhrBCzBiVnM6e
         Ytjkp1fg4HJflYHzbAcp/Wmh5OksNaATqubaYqoJX9tzLdAQuclIvW6G/uf7STqqaqbT
         JCyi3e3aJfrNs1/s61OvY16ydulfsnlkc2X7Os220mhz7tCrfMgPOi4RZa6OcHxebB+e
         znfAIdeEpgz0fTFWdQ7r9i6vPr07nMTiCG6klCq059y8STLvlNgrpWcH2WYIlQdaldSP
         0y/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754584537; x=1755189337;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HtJ7SukZttuLpvU2sM4wbLSaHHmB2xRR25bbI/ADQkc=;
        b=dtfmYzSJyRsiPzrrT18feaAcu/xcrJ+vIU0timloQ2m/l36XMBqdkjxPn9TnHG0twJ
         uVELJVELO24GVo2Xc2L994dHxY5LGOmD9RMP5MvY1fd8J2OBt7HuLkCxkPYtpxPMHEMA
         kQfKUWE2VDrtW6Gl/pnhLU0FuJHMvtEyC2va7VkL3+GtEA3LoVCuj4UkPzXBCI003EcW
         zTY7sNtQodakLpeKyUTABJzkQ+21lBk5bFyaywcHo2svnD8Ny+yVlZyR7OEvXwJZdAoO
         5t0aFPpQ/hMJ99LOhhm0bx3gEzA11bz0FPnT3HurrCgQ6ZzQGsn8vLPzOSSSExjo8lJP
         tL/w==
X-Forwarded-Encrypted: i=1; AJvYcCWwSzmlsgTcnRZVDHvpFoHYw3V8B9h+cbLwEViow867VwYwXgIUGAAMMVYMlxIq6ogKQ73fd5Yv9w==@kvack.org
X-Gm-Message-State: AOJu0YxV+lJDgFsqBKgR8V2w4cwLRSsmXe3xxb7ZEbYcTxLkt5HLei34
	PAipa7/EdI14FqthdLp/MvGfLDcZxKzNj+I4C4XKOTtYx4w6yrg4WAKl
X-Gm-Gg: ASbGnctARrfOUhOZTcsB0HO+F3ESObAxrEsZIVYl1GMo5Lx7iJUFov16MiVV2MUvvMY
	czsog/SjoTnoXlKQqJw7BdfftOW8/5X/qU2V41jP6PuTzKSn3QVxlAja87rozkHs4iTmKzVMsUl
	NtilWCquE0H0QeEF95BYD1+y9NEWPXfb65vo76ptxIXCwWC8ju7qOE+OTQPesMHOdozbztZP0el
	Y6fpQwB9745LBvfPNbUx1eUzQdq6g66LFvVKq464fZJlGXozLGuQTPr3vFGWAOJRQLtC4OV4ZE8
	KxltPoTv66iu5ZizLi7UuYhfQRqlVT5CG3g+KobWkzJ72z1yKjf/Q3t7NU4RAVgIeh18qP1Sqjq
	XEvWn+AeoZ3ZIpvNGMahPqYHJcX0zV01tCt0x70M=
X-Google-Smtp-Source: AGHT+IHkT64c9OHy2Nzz9XBeldTkqmQHkNU7gSOvuItx5Jn+CKscilRIlUOnQhfn0UMy94ic/YnGvQ==
X-Received: by 2002:a05:6512:3b28:b0:55b:8e2e:8ce4 with SMTP id 2adb3069b0e04-55caf317e7bmr927137e87.5.1754584537230;
        Thu, 07 Aug 2025 09:35:37 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b8898bd4asm2706906e87.11.2025.08.07.09.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 09:35:36 -0700 (PDT)
Message-ID: <69b4f07d-b83d-4ead-b3f1-1e42b2dca9c2@gmail.com>
Date: Thu, 7 Aug 2025 18:34:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, akpm@linux-foundation.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org
References: <20250805062333.121553-1-bhe@redhat.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250805062333.121553-1-bhe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 491414000A
X-Stat-Signature: ar8xinbzqrx17hx5yeg8bdkyhrzebqcq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754584539-512553
X-HE-Meta: U2FsdGVkX18Z/SD4eJih6vMaI1nkOHPjMsHL7S236LYs+nk0MrCx3mDItFMjsvYVWFmjEgElVrxsX6H7Xiv4r/xxCYbY/0OKoNY26Ln8X6ySCErRKLg5n46jP7HsGOT10UpcwVRLSrOLZh9xEJQ0DpuDVxB7GAQ5GT7aBs4lPrv+zmKgv59U0URY58/kHRTHA9vvFKuZkPvTqdkKws0IazdrsK9oHmSbQLf9o1Yg8CdLuE9EBZeVBaCXFdG6z1ZkLi4aCWqzDFgf4X8VBsaArNWF0SJUGvNz6K9qP52qHowQoGp9nJTUbHvVL7syd0Det85xh3wSD+e9mpRdy2c4ceIHWk1jrnwPwuQJD2LUAn5Fe71S3UVCkd5Xeq9ngp4UV01c2g/VIM2oWqfwDSlOGBjxO6ecz06qLhx/SPvaSX6rMrXJX8xOs2CrvEGLbOZvoA3/udHSlfKXzeRlc0NujOPI68SKiF2UYUhw5tAzxZkqlIUoWzA+nrHaL30uX4U94/3diumi7iAyOKm7XMscPdxpV/bBB1KeZBXUM67f5UeMqCgJ+H66CH4A+geA5CT09eUjrCn6tWsmZO3en9kCZZhZ9z189h6f5FgLJFp8lsJhpsqyQCacIJkwkfUI687TiKOhUomcA96EoRKP2ukHs7XJpiLVQDYUnNgx3/P0UptZk7Ya1l/gX9GExQEE+nNwxloWI/REW9XxW6Jq2c6vdtCnXyjFFlFHmCz/ZTn5ycL/KePHH2b1MSU24/sZgCqfyc697HOjPeT1Xzpx7pNmhlNV+nWiBXrM6oS1K911CpTMyvzT50h0B7ZirpNHWdSi6zhQGwBlvfnAfmvnAVerE5ssmBEarENs3HzEuS2EvLLZUHtiouKzJQL3xFDJkbi7eghWwm13eg0CgBjJqhxA0CDMAzfe+QOfN4oVXU/bPW+i++WMBNNmRQFJrL/n3iOfHTqRTuDBNfxkSsjWTH4
 CAI1tF7Q
 00TFfOtksKuBcv/ZjH16EAWJTXlTsuMtG/ZMNX7BM+C2U8gI6rrrsofxj+666kzbbu6Lumw3jIHbiigjSxnAde4tx1GkQ7xjMNssq0Rev6JxG4Fx7IsZmD2DMGf78qaH+xVFQCDW1QEE2mqfoYNWSCLwNXHO7vCKjLRJtmy22fq6TxcOpRo4I3hNnm48qZAKdiZ+mIMJ3UYInr1Pj++cj/2nVhx+LdRiY76tXIsKtxDCMHMoqV/4UFcTlGG7bZtnlCMx4Yv809N4J44ux/EWRH1uqDcJGYJHSc52cVsRt0I6jEmL/M0zBBwBgCfSGe/wdxvoCU1GK1YH8WpmXqdcN8daMJOwnicTcCywLuG3A9iDd1y/bJiOtnk2AyQHr0Cq2/vbgcJuEI5Q5QOA4Zcjmo1JSqk5EzXgJ4WY2Xn3Jm1pgj7FqzCSCwjhbDORz+6UK4NfzoVb6wViO7TGkJVtyR+zIpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/25 8:23 AM, Baoquan He wrote:
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=on|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built. 
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.
> 

Ideally this problem should be solved by having kdump kernel with different
config. Because if we want only reliably collect crash dumps, than we probably
don't want other debug features, e.g. like VM_BUG_ON() crashing our kdump kernel.



> So this patchset moves the kasan=on|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> kasan.
> 
> Test:
> =====
> I only took test on x86_64 for generic mode, and on arm64 for
> generic, sw_tags and hw_tags mode. All of them works well.
> 
> However when I tested sw_tags on a HPE apollo arm64 machine, it always
> breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug 
> can always be seen too.
> 
> "BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"
> 
> I haven't got root cause of the bug, will report the bug later in
> another thread.
> ====
> 
> Baoquan He (4):
>   mm/kasan: add conditional checks in functions to return directly if
>     kasan is disabled
>   mm/kasan: move kasan= code to common place
>   mm/kasan: don't initialize kasan if it's disabled
>   mm/kasan: make kasan=on|off take effect for all three modes
> 
>  arch/arm/mm/kasan_init.c               |  6 +++++
>  arch/arm64/mm/kasan_init.c             |  7 ++++++
>  arch/loongarch/mm/kasan_init.c         |  5 ++++
>  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
>  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
>  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
>  arch/riscv/mm/kasan_init.c             |  6 +++++
>  arch/um/kernel/mem.c                   |  6 +++++
>  arch/x86/mm/kasan_init_64.c            |  6 +++++
>  arch/xtensa/mm/kasan_init.c            |  6 +++++
>  include/linux/kasan-enabled.h          | 11 ++------
>  mm/kasan/common.c                      | 27 ++++++++++++++++++++
>  mm/kasan/generic.c                     | 20 +++++++++++++--
>  mm/kasan/hw_tags.c                     | 35 ++------------------------
>  mm/kasan/init.c                        |  6 +++++
>  mm/kasan/quarantine.c                  |  3 +++
>  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
>  mm/kasan/sw_tags.c                     |  9 +++++++
>  18 files changed, 150 insertions(+), 46 deletions(-)
> 


