Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36DEC87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895A76B0089; Fri, 25 Jul 2025 10:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D616B008C; Fri, 25 Jul 2025 10:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783B66B0095; Fri, 25 Jul 2025 10:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1EF6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:39:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 206F81A07B3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:39:16 +0000 (UTC)
X-FDA: 83703044712.18.CF97AEF
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf19.hostedemail.com (Postfix) with ESMTP id AC77B1A0004
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:39:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=HRQDx07I;
	spf=pass (imf19.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753454354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mUY+1XR4b/e27uHYcOnJJ9KFj0pqpjkndNzpVgnRDU=;
	b=XTZTS01A7BYzQiu0GPzvhGEZPlpNr86+C7WXSYeHoXhE2Pgy+ylbXki87+RONFo17hHaYM
	Y7xk6SkkKzXwu9sYd0aiRTvftZJ47jFGbQOAl1DD0B6wRbPOfxzmaJ4Z/D6jViKskDcxOJ
	RMteqFUtkYjQib6NeQHrsnfVrr+0jmk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753454354; a=rsa-sha256;
	cv=none;
	b=zSRDVGsNKJonwIk8UYh0kQx3T/NpuJBK7dcaU9SEH2BNPIoVXczN+0jTepYzun2DWYXmEw
	afIx7IQcyV4uQk7sV+IR3Pvt2BtD7jbR63BtfU4zkpNQCXB2BSaadl2QGhZiEpOLCwmbYJ
	oQnZvehd8rACpMkKu8KAFdK5QswKzdg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=HRQDx07I;
	spf=pass (imf19.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com;
	dmarc=pass (policy=none) header.from=canonical.com
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AEF553F858
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753454349;
	bh=4mUY+1XR4b/e27uHYcOnJJ9KFj0pqpjkndNzpVgnRDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=HRQDx07IGbj/iBTv9HWQxJGa+CG0YnLerNR/911WBzjHF4YtSj+3h1bx2jmErkJp4
	 Qj7Rpz4JkFL9aME+vbmsdtFWsbc5BvfftVaaO+MdfUF+bx53MjhEUx+/R0c8oYCfTx
	 NLx+Z3kZecffsCzUrm7XF4nsuIuNetsGbMjsqz4aVnjY3KiBlELtviL/fgEi+QOQ2W
	 vlKcBj2DcjDiW20eGzUSlbzM0uHxUvwc5sRBMGICoyLYL6cbNd2wWp+wT1ov06uSX6
	 KU+8ocSm6Fz60IuulxPZ1qo1A7hYTm/XJutMBPyLfFTMZ65PjZZ4XGKqHnDqCE3hRW
	 dWrxaoL7GySDg==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-612b23a8064so2229023a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753454348; x=1754059148;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mUY+1XR4b/e27uHYcOnJJ9KFj0pqpjkndNzpVgnRDU=;
        b=tVTZ7JizlHx0PLCQz4cph9BWn0EYry4qxq/oGPExq5tQmA+d0T0NV/0D/UgG7JAEuW
         xxLlU0rjUrFq49WjJXLyD+X+yKGWnXMFP2N1YRXbI5y1a2JIeXoKGDbUMsf3vT9XmMeP
         RT4mkBgsh+zXJ3lffhRZ3BReuJuIYItZoq0n9HKc5j4EKKDo+CsrEZOpqMuJUqugiX0V
         79M0aZuyGn5FITG0P00Cpg1zCPt+gu8EEp8LZWNevMmSYoaXIGWM8jfhedPNwvigy0ry
         TYAMOHmQ7Tmzyu3b+IIjkPKasMHLvjEd/iTm+o7NkaUQvRambEUk9vri4VlVg+uQ4JXi
         HcJg==
X-Forwarded-Encrypted: i=1; AJvYcCUZy+nsoGLW89Z7qnkxA8fiMzKObR2n55Cf6BQv99NhLatBEFGQyz5lThwh2cgud8wnNlr0+aLpYg==@kvack.org
X-Gm-Message-State: AOJu0YwAIN4XsR3zk8ACe+r/xlT+ETvb3PkVgqEeWDf3SMylVSo8LQaX
	8nN+UpnkgWmDN1LhouDC4L0h1GBbtWO63tKJQy63phWeayCSx7gctC5E7xn6/HKnP3jmwua9SwD
	QSOQHG77fNjAflCI53llw33bkkZzy8F5HJ1sSkJudlRPWKUjgkMYHpBB/UrXCC5LKmQEt
X-Gm-Gg: ASbGncs4iUsh/etnpVROANree9t3I/w/N0LNuJYtxNqZvAryoXZr2QJis0kxPGQeM+R
	mdZfhOEmZQR6je8ud7yRkANFqwDcmtr51Od3CEmgwE7SNwLETTM+GL2vQP8ORS8YePQiR/ukMTR
	4P/8NvVI8UAMeqF5tqpaxCJoOw2EEUuP2HYrpRiwMURqiiVaDGlbUlNdi5K6hZKZUKUwh21ekt+
	t36HdrJxVz76TsP0kmxNtk34Xk1ASvGJ2AAkVA3nCFjFAQzPQktvzduQZRPFc4CGi1b1woeq90V
	O4C/EtASqXgRztFTBrxdzFXs9YfEiHISuJmF+SL8OJGOPFkaHQM/nR7OHkYYsbHczNOm09R1k/O
	VJ3o56YKPM904i57BmwMAxj3r5g0e5WsmYevOuBm3F6CQBEw=
X-Received: by 2002:a05:6402:84f:b0:612:a507:5b23 with SMTP id 4fb4d7f45d1cf-614f1bbef74mr2314227a12.11.1753454347277;
        Fri, 25 Jul 2025 07:39:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF14h0UnqVMVE8DmU1HkI4HkVFGaC2n5jgqzt8HvQEsuyPWhXxWakRNoUb1Vt7GxR2EJttOLg==
X-Received: by 2002:a05:6402:84f:b0:612:a507:5b23 with SMTP id 4fb4d7f45d1cf-614f1bbef74mr2314178a12.11.1753454346728;
        Fri, 25 Jul 2025 07:39:06 -0700 (PDT)
Received: from [192.168.103.102] (dynamic-046-114-110-103.46.114.pool.telefonica.de. [46.114.110.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-614cd2fd3b1sm2185550a12.40.2025.07.25.07.39.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 07:39:05 -0700 (PDT)
Message-ID: <06955781-118d-4208-af28-cfbabd7d57c2@canonical.com>
Date: Fri, 25 Jul 2025 16:39:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] riscv: Kconfig & Makefile for riscv kernel control
 flow integrity
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
 <20250724-riscv_kcfi-v1-11-04b8fa44c98c@rivosinc.com>
 <b50da4ef-53ca-4edf-bd74-f5e037a14f99@canonical.com>
 <aIOTauktSYmw2LUV@debug.ba.rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <aIOTauktSYmw2LUV@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AC77B1A0004
X-Stat-Signature: msrfojm9b9ndbzjh7ru965i437kebgkz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753454353-200575
X-HE-Meta: U2FsdGVkX1/ugPtRiTT+fs3HsEr83ZfqQ+EioENpAk+HWkHIitA9d/Md4W0jcMrFiZXnIvjlQ9cBq7vUIewJQo0Lv6a8aUEB6jg0BamJpk6ZzLZm22hfog+0pKFuVrIht90vVHURUBCsQBfOZlJEK8F1gGif9Kegc2Xv6j5n0gQWaiEgeaYJZuxNALF9MssmoTkm+W+ky0lPHYgUHcaOn0iqdiPcW5uG7ko9ncM9Gb7SKb4LuOSqBpuSt4rDheVa+IED3Mf/F30N3EcFofQ0jQmKdwh7FCPUbI5lMxEoy/JfvO6RmmJ2jvj7PkYRiWMqQMThBOraOqK3ntr4vW6/O/gjDYCis0BcTq+XpZ4mCf4JgIrqtP0SO08nft/QJiD1oJnxEHLJJrM6MsLC8bkfFFzAeesXVoaVetNc6IdGEXpTfLZx3ZLeRTC2m+rpgk5wFO53xJnYFX4HVYi2BwhLrBBJkZnqk6I0egAu4RK4pTGcFQSeiMTSOs5fSYwk6EmlKsyk82UYMIOqQjjB782lKJTl4WhJ5SVl2Z6Vz5YYGEfmq4ZpXEoZz8VnhVgoo0p+bFiKvvklG5Gmtrra7yqpyj5+N4ObaoXihmvJDyXFNDe7URzgYqApDMOB53GLtR8+2bfneWYeTO0a3IMdpnqJUVeLtTvweCpxy5dj7nkU2G1skhuh0X5oKrthiHgUYRWAKqn36cEAE3XsWs3lO170a8+hy4ojj/h/SwrctPDKbW0Jp/ET0ss1mHJEV9fGhz+kg6Pt85FcNB9FVAJ00QGDB/QvSNEI+fY2OUfO3v1GvtyfFWnRvo3w6OprhvgmA+MFEoqVgVkLsJvqbnxBTimqsNhVrTrkqTmUF/y44FCWiJYEVuw7bTutbokkIcIL77Hocv0OVNbQkgFZ5Jo4+xoTfr0GXwtlrWIoA6Xkln+ZtktEJ0M9ldk7WjGMo8psL8yh/fRhuaeShsPrrn6LK0L
 l9NlUKFX
 bKDsS6uOskSvLwGF89WfgMrjr9nyzs2CgkAfTvQJmiz5mwuIgox1VfHuLr7GV013031zMCkRbNqud80F6HdyDsIL/CUnBbhrPuio6SugEBtKYHzhARo1En6useQGf8MfRfymkpdhEWwKjNoM9UEUVbfoG2jVDkuOxJ9gJCUGmxDjCcLHnxOAoOnPM5vOiS5JpyvcNHpmrkLBYgEMk1vLrYitG9N5lMPkuAX0OwyeCqeTZusfECEND2fWh6uqhwx5Sq8k0SAU4FsjIMhRyqRdYqvjy5uCRQdC9SKl55Rg7zLA+pocY8utoUSh1iEZlmQWVeUhEBnvnQkbndOUEz14sWSXmbZyt4fCCpujzrcj1VFDooBuvXd+mWNwR/UMpweDSsrEWoa+MKOTOVnxrqeJ9hkLao5E8pqg3DoyhU2Yjt9cGW9uxSNDEYfVLLFZzSjky37s7BrrJDZb06ctUmy3ezZgeB9qbmeIDHy+/P5oA5TZvCuB3GQ09ILyiSiZ7fmvt5BydzI7oKzeB5OGsVpmN4vXANNOEwyXMcaEQgYAEBRX7Mjp3na8PAxgrt1xrsUGMrfwdmdS91YecAt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 16:23, Deepak Gupta wrote:
> On Fri, Jul 25, 2025 at 01:26:44PM +0200, Heinrich Schuchardt wrote:
>> On 25.07.25 01:37, Deepak Gupta wrote:
>>> Defines `CONFIG_RISCV_KERNEL_CFI` and selects SHADOW_CALL_STACK
>>> and ARCH_HAS_KERNEL_SHADOW_STACK both so that zicfiss can be wired up.
>>>
>>> Makefile checks if CONFIG_RISCV_KERNEL_CFI is enabled, then light
>>> up zicfiss and zicfilp compiler flags. CONFIG_RISCV_KERNEL_CFI is
>>> dependent on CONFIG_RISCV_USER_CFI. There is no reason for user to
>>> not select support for user cfi while enabling for kernel.
>>>
>>> compat vdso don't need fcf-protection (toolchain lacks support).
>>>
>>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>> ---
>>>  arch/riscv/Kconfig                     | 37 ++++++++++++++++++++++++ 
>>> +++++++++-
>>>  arch/riscv/Makefile                    |  8 ++++++++
>>>  arch/riscv/kernel/compat_vdso/Makefile |  2 +-
>>>  arch/riscv/kernel/vdso/Makefile        |  2 +-
>>>  4 files changed, 46 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>>> index 385c3d93e378..305ba5787f74 100644
>>> --- a/arch/riscv/Kconfig
>>> +++ b/arch/riscv/Kconfig
>>> @@ -245,7 +245,7 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE
>>>      depends on CC_HAS_MIN_FUNCTION_ALIGNMENT || !RISCV_ISA_C
>>>  config HAVE_SHADOW_CALL_STACK
>>> -    def_bool $(cc-option,-fsanitize=shadow-call-stack)
>>> +    def_bool $(cc-option,-fsanitize=shadow-call-stack) || $(cc- 
>>> option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
>>>      # https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/ 
>>> a484e843e6eeb51f0cb7b8819e50da6d2444d769
>>>      depends on $(ld-option,--no-relax-gp)
>>> @@ -864,6 +864,16 @@ config RISCV_ISA_ZICBOP
>>>        If you don't know what to do here, say Y.
>>> +config TOOLCHAIN_HAS_ZICFILP
>>> +    bool
>>> +    default y
>>> +    depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp)
>>> +
>>> +config TOOLCHAIN_HAS_ZICFISS
>>> +    bool
>>> +    default y
>>> +    depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
>>> +
>>>  config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
>>>      def_bool y
>>>      # https://sourceware.org/git/?p=binutils- 
>>> gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
>>> @@ -1182,6 +1192,31 @@ config RISCV_USER_CFI
>>>        space does not get protection "for free".
>>>        default n.
>>> +config RISCV_KERNEL_CFI
>>> +    def_bool n
>>> +    bool "hw assisted riscv kernel control flow integrity (kcfi)"
>>> +    depends on 64BIT && $(cc-option,-mabi=lp64 - 
>>> march=rv64ima_zicfilp_zicfiss)
>>> +    depends on RISCV_USER_CFI
>>> +    select ARCH_SUPPORTS_SHADOW_CALL_STACK
>>> +    select SHADOW_CALL_STACK
>>> +    select ARCH_HAS_KERNEL_SHADOW_STACK
>>> +    help
>>> +      Provides CPU assisted control flow integrity to for riscv kernel.
>>> +      Control flow integrity is provided by implementing shadow 
>>> stack for
>>> +      backward edge and indirect branch tracking for forward edge. 
>>> Shadow
>>> +      stack protection is a hardware feature that detects function 
>>> return
>>> +      address corruption. This helps mitigate ROP attacks. 
>>> RISCV_KERNEL_CFI
>>> +      selects CONFIG_SHADOW_CALL_STACK which uses software based shadow
>>> +      stack but is unprotected against stray writes. Selecting 
>>> RISCV_KERNEL_CFI
>>> +      will select CONFIG_DYNAMIC_SCS and will enable hardware 
>>> assisted shadow
>>> +      stack protection against stray writes.
>>
>> Please, consider adding a blank line for better readability.
> 
> Noted. Will do.
> 
>>
>>> +      Indirect branch tracking enforces that all indirect branches 
>>> must land
>>> +      on a landing pad instruction else CPU will fault. This enables 
>>> forward
>>> +      control flow (call/jmp) protection in kernel and restricts all 
>>> indirect
>>> +      call or jump in kernel to a landing pad instruction which 
>>> mostly likely
>>> +      will be start of the function.
>>> +      default n
>>
>> For Linux distributions it is important that the same kernel can run 
>> both on hardware both with and without CFI support. The description 
>> provided does not help to understand if RISCV_KERNEL_CFI=y will result 
>> in such a kernel. Please, enumerate the minimum set of extensions 
>> needed for supporting a kernel built with RISCV_KERNEL_CFI=y. I guess 
>> this will at least include Zimop.
> 
> Yes, it is expected anyone selecting this config is going to take this 
> kernel to
> a RVA23 hardware. RVA23 mandates zimop and thus shouldn't be an issue on 
> such a
> hardware. Anyone selecting this config and trying to run this kernel on 
> hardware
> prior to RVA23 will run into issues. I can add a comment here to 
> highlight that.
> 
> I assume you wanted that awareness and goal is not maintain compat of same
> kernel between RVA20 and RVA23 hardware, right?

I am aware that this option is not RVA20 compatible. Could we either 
mention RVA23 or Zimop here so users will understand the implications.

Best regards

Heinrich

> 
>>
>> Best regards
>>
>> Heinrich
>>
>>> +
>>>  endmenu # "Kernel features"
>>>  menu "Boot options"
>>> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>>> index 7128df832b28..6ef30a3d2bc4 100644
>>> --- a/arch/riscv/Makefile
>>> +++ b/arch/riscv/Makefile
>>> @@ -61,8 +61,10 @@ else ifeq ($(CONFIG_LTO_CLANG),y)
>>>  endif
>>>  ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
>>> +ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>>      KBUILD_LDFLAGS += --no-relax-gp
>>>  endif
>>> +endif
>>>  # ISA string setting
>>>  riscv-march-$(CONFIG_ARCH_RV32I)    := rv32ima
>>> @@ -91,6 +93,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := 
>>> $(riscv-march-y)_zabha
>>>  KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/ 
>>> (rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
>>>  export KBUILD_BASE_ISA
>>> +ifeq ($(CONFIG_RISCV_KERNEL_CFI),y)
>>> +riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFILP) := $(riscv-march-y)_zicfilp
>>> +riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFISS) := $(riscv-march-y)_zicfiss
>>> +KBUILD_CFLAGS += -fcf-protection=full
>>> +KBUILD_AFLAGS += -fcf-protection=full
>>> +endif
>>>  # Remove F,D,V from isa string for all. Keep extensions between "fd" 
>>> and "v" by
>>>  # matching non-v and non-multi-letter extensions out with the filter 
>>> ([^v_]*)
>>>  KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
>>> diff --git a/arch/riscv/kernel/compat_vdso/Makefile b/arch/riscv/ 
>>> kernel/compat_vdso/Makefile
>>> index 24e37d1ef7ec..552131bc34d7 100644
>>> --- a/arch/riscv/kernel/compat_vdso/Makefile
>>> +++ b/arch/riscv/kernel/compat_vdso/Makefile
>>> @@ -69,4 +69,4 @@ quiet_cmd_compat_vdsold = VDSOLD  $@
>>>  # actual build commands
>>>  quiet_cmd_compat_vdsoas = VDSOAS  $@
>>> -      cmd_compat_vdsoas = $(COMPAT_CC) $(a_flags) $(COMPAT_CC_FLAGS) 
>>> -c -o $@ $<
>>> +      cmd_compat_vdsoas = $(COMPAT_CC) $(filter-out -fcf- 
>>> protection=full, $(a_flags)) $(COMPAT_CC_FLAGS) -c -o $@ $<
>>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/ 
>>> vdso/Makefile
>>> index 2b528d82fa7d..7b1446b63ebc 100644
>>> --- a/arch/riscv/kernel/vdso/Makefile
>>> +++ b/arch/riscv/kernel/vdso/Makefile
>>> @@ -17,7 +17,7 @@ ifdef CONFIG_VDSO_GETRANDOM
>>>  vdso-syms += getrandom
>>>  endif
>>> -ifdef CONFIG_RISCV_USER_CFI
>>> +ifneq ($(CONFIG_RISCV_USER_CFI), $(CONFIG_RISCV_KERNEL_CFI))
>>>  CFI_MARCH = _zicfilp_zicfiss
>>>  CFI_FULL = -fcf-protection=full
>>>  endif
>>>
>>


