Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32506606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 15:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=hZERButb
Received: by kanga.kvack.org (Postfix)
	id 234FC6B05B2; Sun,  8 Nov 2026 10:24:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9B86B05B3; Sun,  8 Nov 2026 10:24:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33876B05B4; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4B2E6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 10:24:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADAFDA04A1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:23 +0000 (UTC)
X-FDA: 85412323206.14.8CA1D9B
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA65040003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:24:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hZERButb;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794151461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DK+wvhFB9cC/ykY+2Qftzi8KfweL9NRM9vjrgu6Yo70=;
	b=VpRKEbQtid0VcVzsTu7wM7EzF70HbDq2jF/hUV2Xu/i5QYfv/P00tNYCOO4/4999NtaJ5z
	+lss+7QxUK7OLEB7GrGlIlpKXejSFj88js3wBHFd6im5e3Ow1ZWpO6JBU8NQl+RcrZdByJ
	0S4yk7nii75968T6dU8HdbculOOYhKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794151461;
	b=roh1Ljrdl3WjQjpaWc1xjDkuUkMnJ2ZsH9fh/0KzVTm8FnAXHDYcAB8RXfDu7P8V7Wbh81
	Hdg759WK2Smc9vDp0BzUlyNjojtP8qq7xucCj1aqccZqD70ZmLFLJwgv2XLsWBvTTERtuA
	VIkpsO//paQ4TsyjN9gzDne6epUiZ7c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hZERButb;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-98c7798ce74so16963241.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 07:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794151461; x=1794756261; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DK+wvhFB9cC/ykY+2Qftzi8KfweL9NRM9vjrgu6Yo70=;
        b=hZERButboM969Y8hhaQy6PhgqTn5/5hjIUhIe114nkm3YziIAKH2+M/NTSglatkZ3p
         ayCtaO2M95tkXxd3mKiTgDr0ISyM3y5QWCOGD8g+Dz0mxKKx2sC5Jwo5AE/ycRUBm4vs
         OOgXPEWd4NCynDJKqOALvfMseOJZ4wcEmR/RnhYx0xkCO3EAp/45b2PSqFKW4fa5UXVA
         wdT/bRK0Ci6glZne9pZAXHa0WvKvab4IVRxMeEEkPEDhYmYpLH7YD9+al5c/L2Us53n9
         owBA2+Y3jRn6THRwKZBjpBIilmqvTy3vmc+Mw+sQKhDFeDVzhb9R95x5bHF+M6ipAvOM
         BxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794151461; x=1794756261;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DK+wvhFB9cC/ykY+2Qftzi8KfweL9NRM9vjrgu6Yo70=;
        b=qwsvugGJT/3LOreynWalDvxnj7pl3gX9kG7nC9n/iv2xpQo6jLukgBo0JkCgrJ5Rzp
         O9miwAYYcFd94hPxtIpuoIilZ95jqrUSLMcScTy+My1XWhrWg4fxrp4BlUIWpVJoYCrq
         Af2WZn/nRUsti6o2P80oz+H677Xo94WM/1Qolu/DWcLa2CIIVa8PvzMvY/nhr1ni3g7U
         QetH/+KHSzXPfdB+9n+fxZJ1DWzTVpjpEPHBjuP4D5cI3ro00Zja3zNtkOB/B3wEkwHO
         UxbakKPPSRzMUSeM1C+hJc3gEcCDw40cD3pnJk6mRFzPuqjKF+7shdGWYO0W/XJSjvke
         3+1Q==
X-Forwarded-Encrypted: i=1; AL+hErGQukjwLNa7USEYtKB7KoYjJOrktx6Zuxoc7vlxfJ7dvUomBGqJ5GgkeBiez/ZALVe8aUv5wHbMaA==@kvack.org
X-Gm-Message-State: APuU4Z/rEu6ZQHol9hdY+lAn8u4t7c116pYNg1YcK/5AuOWjXbmhigcP
	F6hm3YkYfnvE2znek2cBNbZ+CUb7utkqME+fRNo14+J9q7eFhvOLvN4nmVR+bmUjG9g=
X-Gm-Gg: AYBFou1ffG9AO1KiWzO/ljBKKAtKG1o0dKdd8kY55sonnT45+sdutFG+0bl3AuBtIUj
	8SbVt6CT56vPCxyU6zyU0ePisxQY851f7pR/OtFdhrt8RV0g3U3o/oGsdHC4Q7DE0RenXj8CFil
	Suiuv9AR3Bb8AtlJn4E0iP42rG9Rn801lRZS4n1CfU5w2AABKS15d90OI4CvUGVcYeVAKimRYVa
	DJ3SUoV8bqeKdX6j5BZKViG0uyeWqFYIcsUlP/W2/5yOBcCay8jcw5Nh3dYOYqLxziHNihXO4Z7
	aniFM1fZkAPde1Zv3lFhugku7wAhq3i8yVGl3nyoWGYXLtoaBB7PkY3uzamvP7fw/QglpXvGKPE
	O06+tSOCimoxYwGd5WhYV0gN/G1PHAM8D9H20VJLEpGhVx4OOfv/1ZX9nrJeLyWcLd9V/YrAvL6
	4SoxgotquRJrOfwETfuH0FzTSg0aUlaeHkwRmSedcr3fy4Ii4VM1miRJqgODUSwvUGUO8rNagBP
	Oh4XoAM7D6W2LxoXbl8xomok+eJEqXYwTx/Ra0al2ufhCyA59MM0JujhOLEvxZECko0TjsLbREQ
	WUpjGOKRiVUzb3a/EbOjBGNPQyGkPH5iOSDiVsK8fC6vlyODxGD89NegXMCbjQlYA+hjgsjojMz
	gY4sUQ0CNkCwKsa+4jOHqwGHWJgNYFh0P3mu6Iv3y1qs2GDmj
X-Received: by 2002:a05:6102:508d:b0:7d2:840b:b064 with SMTP id ada2fe7eead31-7d2daa8ec5fmr326255137.3.1794151460771;
        Sun, 08 Nov 2026 07:24:20 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ece60c1adfsm2166205e0c.8.2026.11.08.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 07:24:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
 shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20261106071459.2003-3-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-3-cp0613@linux.alibaba.com>
Date: Sun, 08 Nov 2026 10:24:13 -0500
Message-Id: <179415145358.358073.165272378597657083.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1378;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=ohwRzPbI/pF5KX5v3Lzs009TPAWX3IxDBN4XddXH9Jk=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8JQhhVigFV4eOxTx4e3e80HlzS/OtAzSEvy/o
 QEXLdFCC06JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavCUIQAKCRC7dyhM23N6
 3jcdD/4utq4C5K121vM+fg4odzwfN+cDjx2VRvt37vUTCJl2NKJyDEA/6O74csfV+flN3PepeIe
 Z9mn1ZjNry4hdEYrftWGGTccrmdMzbJnCBtpRCnMLoFjA8FpZY2ACeQIv+IcAkhMOa6wphuDtI1
 N5OfQGqjO0rGApz2R/3xqFSutMTKfiiAY1qtbSiSSWRpdN5YUGxyFL3rebfa/JcPZNB+3Dvc66h
 MtJEyUv0CUrr28lnHvtDe5jWmWnab1yHiiWNGZgBcgaZRMV6UsEGGALfV79zwuIqAqWd/aLq/jW
 VyhN38LrLXymGAb3N6edWgXBKb5Vw/QPsU4N38+QNx1C94ZluCI/raSClLXa64MjPgyj7Vi+yEg
 qQSbI1WFUVWejGUhZBssz9xgwkjx1/WRwaIMWs/jz4yK1Lg1k0fx8oG7nLhTux0NrlFIkMhuWfA
 kMEHUoBr+OtHc4mbRL6OhmThZxeMXfDd2UU7B7l0p6ulbzfREE7ZoA3uYPuju4iVcAQ9b+0hj9K
 34WZZ/zn4tj2f2btFZ0ruN8PS7KCaYmn3249Ay6LlsI0n1mbqyytmeXLPExkib6jwIEp0JSLPqC
 3//pyo5DhG88hIZrnh55hwcBJg8Px1HqmxDUqoVsH1MtHMJtKRyHcHy7231ekVpw6Rs6i7We2fG
 FUugHQuc8USPaZQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA65040003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: w3nqfozqidwcwqhzwgmcasfyueok9ddm
X-Rspam-User: 
X-HE-Tag: 1794151461-15728
X-HE-Meta: U2FsdGVkX1+NjYKA8eQY9XtoHnqGa446fpzCiBF/uuiJXKUdE3nal1IysPAKkq16movzjHZGSQz3wgA+orqet3j6mBs8c4cV7cjWaJ9Pc8vIvn4oBb2hHJ8nY8Jp37KTuzeuLtG9O2n38IjdMlF7KOcoVvGE/3AHk/y9ecNazvVxIl8FoUujLJjMlww1e3DJR8OGmotA0htLsJL98X/E845Tsnbd0ox9knH1huvnKYOyBgYE4cWJDuGY9VqxO5sqzQDU4PPXbKslqsnk+J3eT4j/GdVNYqGE4OIGtgn5oK1HqzbI3jwiwpgqyJQ55TLh7zT8m1w0LyODahiERGEtziL9yBFfh1thMETtX2pe+7+thTqmHyaPitKcqj2IV98S/n+56Pgzl9WWOzAYLBh+NYUe9pXlBnVRxKNccFbx/HzDwVswmMOzRRs82KA+V0jAMwRi8pACySNuVc92rDjh8ghmuT2282PgcRjk8u6uwviYyXzNEuDY3GI1wurX/1y2aE8DpkiZqqrbYDE8w22NYV5wm4GOcbL3dAbiVDvN70gtxPIO9fvD6jpw8MckhvSvQYNDS2C4lGxjGVixBQTV4wsSmETenbtXn1pHsr5mGiyw1QzpyZGnJJ7hj3sp4SW3/q++QuUKJNQYuGFSRayi04vQsAK0iPi8rCD9jIo9HN7AYTR0WYBsLbWloF3R0+aDYhJr0dThk7eeoHIJ82qHLaUsdOUQSJXlttGkvd/AzrLk76t5Rltu0ZwJV3tN68s0tU9wqu/Sf8Q8DNBOw9A+YaO9+AZgLR4+kVJ3Keu9HUQlK90sFgtsUV38NvWgGLuIqWckN4mQHEljL6DI8ePWXjsx6Wd+lldaBICgduB/OuftBNE0MoC2zs/Ugq5OgxMsaGJl1mPzaP87RL6CeIS4qxRbiQCLgB/b9Sy32QXzpeDCZGrPa0TVPFswO8pT8JXVPYyoowFOWHd5x86hmN8
 yee3ufwf
 68lqc65eSuGrOatdrQDcjp06pl9tsmVVXcjI3f7yjB9LSFA1h/b9+IYhIMUn12vPxaV4Cz8d+DXBwzgiE8O8JjlTwPMHJvroOV6xUO93C6fxdDGNORoLnyua4bacVxfFxbKBpDoXS9szntVDTsHBIvvbXVoeuR/hIbK8Ov9RFOKQ7wZP2yFrjZ2qVAsegAiBfWXqRjW2csSFqW5gR3GVj6Tpy4uatSOzFvWU86o4ubMeLj6JVaevRnZj17B7ZDEhPuso/AeH5VNpsz0Ht/VWH0eyNfxuaQDRgTaPtChQrdkOMKNug1T7gW2Le5GD7xcmwL1MGDcWTAAZLFBepF0kDir8mCx1tlmk8f2a15wihOM1SE5SwYo6DqeB4vHxNFXn9l3jVCqyryLtekhk5KUsZ01rWgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nit: please change subject either to:
Add support for Kexec HandOver

or 

Add support for KHO

No need to spell out right in the subject.

> The generic handover paths are already in place on RISC-V: the outgoing
> kernel publishes the handover FDT and the bootmem list in /chosen of the
> DTB built by of_kexec_alloc_and_setup_fdt(), and the incoming kernel
> picks both up while scanning that node. Only the architecture symbol is
> missing.
> 
> Set it to 64BIT && MMU: ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only,
> and KEXEC_HANDOVER selects CMA, which depends on MMU.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index e7891a2a89da..a5c56252ff44 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
>  config ARCH_SUPPORTS_KEXEC_PURGATORY
>  	def_bool ARCH_SUPPORTS_KEXEC_FILE
>  
> +config ARCH_SUPPORTS_KEXEC_HANDOVER
> +	def_bool 64BIT && MMU
> +
>  config ARCH_SUPPORTS_CRASH_DUMP
>  	def_bool y

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

But pre-reqs. should be applied prior taking this series:

1. https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com
2. https://lore.kernel.org/all/20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org

-- 
Pasha


