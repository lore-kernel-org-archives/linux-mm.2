Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAB2CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 21:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E917B8E0092; Wed, 15 Oct 2025 17:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E690C8E0057; Wed, 15 Oct 2025 17:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E958E0092; Wed, 15 Oct 2025 17:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1A058E0057
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:02:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FB0B86885
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:02:06 +0000 (UTC)
X-FDA: 84001571052.13.6956421
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27F23A0019
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:02:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="VD7/mDZ4";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760562124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtJ7DaV1gwJQgtXjwIR5eEbDMXGgeP8Qy25oJGnYRdI=;
	b=7erMKTfcUqFLzDo0M1EroVasUbCpYoLSmreCjArmWd/6WTZFhaUcNoeo0UgcpBLKJ9zYXd
	Okk8nesJVvWUqHD/H5E41JbrwKLml5x8a6ynDZSsqed9b8KW3JJ99t12dQXSVjOUA4hW7L
	qcKd6Vg6CEx2AhuEMNBZC2NT/4WMGZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="VD7/mDZ4";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760562124; a=rsa-sha256;
	cv=none;
	b=2eS/iR5hSfLWOIa4HT8soOV1e5MUA+duAVWurH0EbfweRDT1htbWy2iA/rXqLPvMvU79xh
	R6u3tGGapxbNPR/4cKSf0yeY1rcIJenw1ppdDye572Zrraf1YxKYUxWEh3zWt4+duDv+/C
	34EOi2OsxeFTyazBV68qhL7WAYdqlgU=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-78af743c232so63450b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760561823; x=1761166623; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JtJ7DaV1gwJQgtXjwIR5eEbDMXGgeP8Qy25oJGnYRdI=;
        b=VD7/mDZ40AYa3BCjqC/OODeWekn4Tais0gMQvU7Gx2vdUZmR3bht5pJkg5fuTiLIMN
         x5OwUctP4L26//kQHZW7GvUj4LCEMUSL+EMFxfjnLF/U2wOPFdZLpbhunMU7T2E1174U
         YOvwk7vkVcEL6z424VhG6P1ru30oh8N2aNRLHXW0tVnslNZqZ2nbc0UuWfHr4bf/U3Kb
         9h8CxP4/wrzyndABuMpZtnAZboWklxHPvww+u7y7TYd/9nwP33Ehi82bo+lf5OJUIU+A
         4sBbHXsiVfO94vC0hlcf/M9JSI92MYTKTSBzRwF4o0owI8QGYWN5m6mhPvMnhzgvh8V6
         RvPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760561823; x=1761166623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtJ7DaV1gwJQgtXjwIR5eEbDMXGgeP8Qy25oJGnYRdI=;
        b=W5kZ/sHbvFF0irJYmspvhYk0u5m4dCpYqfR2JdQoC0tc6m1dYxDokvmBNNnUlV8LMs
         2VXPTaFtQxX2CCAn+7W2Uz33RSXKQ38KYwsHrHInEqELsnpZJchYVZl1ObVGCITZqOhU
         BwRmxNK8AiIkRF8FIexJ0pFs0cXnuhIEEsFn4cGXHaLzuAzD7pid5WNc8yt3XemwCef2
         6Zbp81tPOztakeKVMg8F/RYrUd+UInxJjgNHjLaSvnX/ZV0Hc5EUQdZqbbtEykxnugxU
         cGHTjQu65q/9HTCuKFALVIVP8PFhK6y3y+NbKeI40cNFGrLIQBqfIYK10w7YgJt08yKX
         2qVg==
X-Forwarded-Encrypted: i=1; AJvYcCWsRxyIT9h/kKETtQtA5b2chVYcAwd/oWl5JGpuQAknrL6mIklr6Z9pssWd7Z/w2znzRnVGZkMpYg==@kvack.org
X-Gm-Message-State: AOJu0YwDCJRJs29LMdi2cdP469gw699+8VbzhT/hiIfECH0Z7Mt2StY7
	PvjCChIrug8IPZSOn2wcfNNGa/r2WEgxPRSLwpC+lVNH6Dv0qMDIZG4e+KsGPtCO940=
X-Gm-Gg: ASbGncuAGEMGBfiVhlbIP87f4+VCS9h4s+xp7agXA14yi+6FI02Vknpb7Z02NzibSmY
	uQ5uwS1cH23rL5y3wbiGpMgqXWjVuY9L9MhFz5lpeAHSyjdwjxH1VdacqwR4i/aUJxEt+zctz+x
	GfQYMMFjlLnUZnB6SyezcUfHmfM+XCH4qV7o5yTzFXoIoRrxx5BnlqML0RQJuiSypjd2HI0WqwH
	J/txfgXTYyGASPdojluKeeBpIAzS5QgRrcQZdjB68RNUER43fQNByCyQC1o8LA8fcJdl6l9aB4s
	b3FQpCy+gAi4bHOM2IOMeD6Yt/yHWKjCOpUmFKpB36YFD+UG7rkBcD1a2VLkFWsYhzvr/BO1WrP
	4SONyOoW567bdSmuopzwBTmLKqol48Oj+peip4MTJdPSeN0OCE6CbsloU/KxNog==
X-Google-Smtp-Source: AGHT+IGB+5aNaGhvYx/i7SuLRZMzUGb9z0qxzWuFI5LtrYeUM1k/B64dlkgzbMPNLYbYv0YwsW+Slg==
X-Received: by 2002:a05:6a21:3396:b0:334:8f45:8e99 with SMTP id adf61e73a8af0-3348f459868mr3796560637.35.1760561822048;
        Wed, 15 Oct 2025 13:57:02 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b06075fsm20255047b3a.17.2025.10.15.13.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 13:57:01 -0700 (PDT)
Date: Wed, 15 Oct 2025 13:56:56 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Charles Mirabile <cmirabil@redhat.com>
Cc: Liam.Howlett@oracle.com, a.hindborg@kernel.org,
	akpm@linux-foundation.org, alex.gaynor@gmail.com,
	alexghiti@rivosinc.com, aliceryhl@google.com,
	alistair.francis@wdc.com, andybnac@gmail.com, aou@eecs.berkeley.edu,
	arnd@arndb.de, atishp@rivosinc.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, bp@alien8.de, brauner@kernel.org,
	broonie@kernel.org, charlie@rivosinc.com, cleger@rivosinc.com,
	conor+dt@kernel.org, conor@kernel.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
	ebiederm@xmission.com, evan@rivosinc.com, gary@garyguo.net,
	hpa@zytor.com, jannh@google.com, jim.shu@sifive.com,
	kees@kernel.org, kito.cheng@sifive.com, krzk+dt@kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, lorenzo.stoakes@oracle.com,
	lossin@kernel.org, mingo@redhat.com, ojeda@kernel.org,
	oleg@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com,
	peterz@infradead.org, richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com, robh@kernel.org,
	rust-for-linux@vger.kernel.org, samitolvanen@google.com,
	shuah@kernel.org, tglx@linutronix.de, tmgross@umich.edu,
	vbabka@suse.cz, x86@kernel.org
Subject: Re: [PATCH v20 24/28] arch/riscv: dual vdso creation logic and
 select vdso based on hw
Message-ID: <aPAKmCwDeXXvU7VD@debug.ba.rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-24-b9de4be9912e@rivosinc.com>
 <20251015203611.2572538-1-cmirabil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251015203611.2572538-1-cmirabil@redhat.com>
X-Stat-Signature: 4w9fia1yfqtbiqqoa1wfif9d14p98fc8
X-Rspamd-Queue-Id: 27F23A0019
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760562123-679413
X-HE-Meta: U2FsdGVkX1+CImYSimFItmU6WKXKAXj08CiRAjciqXIFqShUSYM5huAjt6Amtw80q8nz4/Qc92ehJK5EzE+bxPoIk6xJly7DXmrHm7EiJu6HMYmkkU3IAR/OTSdFCaoP6Xc7QFY8+78w8S3kwRKfDsXrGgm9hpbnvTzyaQyJE6CswhZuKwJzjhHEQnUgA8D4w3e0w/MvlTCAxxo4mt7+6kTDL5QjapJAFvQCWtbHAvYzwaC4phV6kaSGD14QDTnaEHdANnnV90lUouPGGkPpIuQspMwuZtEL+kXTTqDBG33fbT0j5Z4ftyzSwt3NhLRUpsML8p6m/OY1JRiS47UxvXXr0nfIl4/Hp9xiUPAEFGzX+RrGlDTSu4BXNlmp1fWp/8wu1mnwwBVcBnSlpDsm4NRB0An2hjX79zQo3g9J3Y7YKKjqx7yUoSqAlIvsj0bcZLBrMMVlVn2eCrDF0RfBtN9n3vDHde1+clIBL6j3r6cEtYbnGD4GZLnYDWABTUaGKbisCqJ7CDlF8XHbsvahSqR6le+5SjpHm7dmr203sknrLVyA7Goj+YtN80AZgvvR5batv/fweFP+mUUA8Uw+d7Pg9IraDx6DYqbNvXHkSPUD4/CA/6bv52ZO5QfL7/MGZG2iIdu0wBvLJRC3HyCvg0NtrSfRxDMYDdEN4KgQTji1tv/Jn30LmewVd0remaSgTdVvDB/0RedMmgERcZGEZs1Do3nnzWjlrB6RadM3hdEBw5UyfM7FZO9vEAX637tjqXJdTEZW+vZ33emrCQU8/s0MPlD4bmRmICF5hYLpoYk3XBpVEZayyR/mOO4jCcdeQOM6H1G6ie2v1Ozvra9eqUYlgDqWBDxVTBrxlM6grmPZJRiQMrGoD0WhfWFilXVAxAx8NaEf+GT1MK7jI0Gyjhii83aDYvpyBy/OHxKwa3SAcLSOYdIBHprx2NsAKd3dU+iV7PpJtwK8QRlEPHG
 IG7HfyZX
 sK98UWBaVgZunIYjJwTq0A6HQrp/eo6j5R8zwgB+7MVn4Xf9U7VBw9GVT2Tjn0IN/M1rQceCv2F+0BQ28840Y0z2uY9XyZwJjCiaTUKW+miZ0kcIllAzXSO7397o99r1NsWGMcTk3QuYtG3Q8K99oNC6JiMbPVcaDbLo9wf5apvv8IgyD3h82pa/8doRXIiOnVQwO33OyN1Kc7Qd3bT5/rrQrh9cl+lDubw/K4OCxmNsbeV0fatPgQqLNMRdRs1y9KnqWm2xNdo/5X1lR7nMnoZmM6g9P86LWA1qKYOsRPsMwvcrKfHN0xwoDTOsDDL2O9rEud5WB3XW9Uvnt3grXp+oFd7pc65f5ssKjrUOvJHGbQucvEKPRvbZzKF7ztTkVnBcNFxHxUxCDeJmWo/zn1O6Ixso7/qTEUVGSvgwUcsX7DjXw23AGkxVSmoJkhaMnJtv9OyPVSenuGV7WBV73BTYVQ8IHMhqaW/NuVgTsQ3YNgrCSnhOqoc8/71dPdE89yuM6nn/+BqQLJpebR1Fg7b+turFvbj4F5ZXP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Charles,


On Wed, Oct 15, 2025 at 04:36:11PM -0400, Charles Mirabile wrote:
>Hi Deepak -
>
>On Mon, Oct 13, 2025 at 02:56:16PM -0700, Deepak Gupta wrote:
>> Shadow stack instructions are taken from zimop (mandated on RVA23).
>> Any hardware prior to RVA23 profile will fault on shado stack instruction.
>> Any userspace with shadow stack instruction in it will fault on such
>> hardware. Thus such userspace can't be brought onto such a hardware.
>>
>> It's not known how userspace will respond to such binary fragmentation.
>> However in order to keep kernel portable across such different hardware,
>> `arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
>> compile `arch/riscv/kernel/vdso` sources with cfi flags and then changes
>> in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
>> on whether underlying hardware(cpu) implements zimop extension. Offset
>> of vdso symbols will change due to having two different vdso binaries,
>> there is added logic to include new generated vdso offset header and
>> dynamically select offset (like for rt_sigreturn).
>
>This looks great. As kernel test robot highlighted, the code doesn't build
>when the config is off, but I was able to fix it with the attached patch.

Yes sorry about that. Locally include/generated had both files and that's how
I missed it.

>
>Assuming that these changes or equivalent are folded in, you have my:
>

Yes v21 changes are equivalent to what you proposed.

>Acked-by: Charles Mirabile <cmirabil@redhat.com>

If I send another version due to some other issue, I'll collect your tag.

Else
Paul,

Can you apply the tag when you take it in.

-Deepak

>
>As merely a user whose previous concerns have been addressed, I am not
>sure what that is worth, but I appreciate your effort on this.

Thanks.

>
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  arch/riscv/Makefile                        |  3 +++
>>  arch/riscv/include/asm/vdso.h              |  7 ++++++-
>>  arch/riscv/kernel/Makefile                 |  1 +
>>  arch/riscv/kernel/vdso.c                   |  7 +++++++
>>  arch/riscv/kernel/vdso/Makefile            | 29 ++++++++++++++++++++---------
>>  arch/riscv/kernel/vdso/gen_vdso_offsets.sh |  4 +++-
>>  arch/riscv/kernel/vdso_cfi/Makefile        | 25 +++++++++++++++++++++++++
>>  arch/riscv/kernel/vdso_cfi/vdso-cfi.S      | 11 +++++++++++
>>  8 files changed, 76 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>> index f60c2de0ca08..b74b63da16a7 100644
>> --- a/arch/riscv/Makefile
>> +++ b/arch/riscv/Makefile
>> @@ -176,6 +176,8 @@ ifeq ($(CONFIG_MMU),y)
>>  prepare: vdso_prepare
>>  vdso_prepare: prepare0
>>  	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
>> +	$(if $(CONFIG_RISCV_USER_CFI),$(Q)$(MAKE) \
>> +		$(build)=arch/riscv/kernel/vdso_cfi include/generated/vdso-cfi-offsets.h)
>>  	$(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
>>  		$(build)=arch/riscv/kernel/compat_vdso include/generated/compat_vdso-offsets.h)
>>
>> @@ -183,6 +185,7 @@ endif
>>  endif
>>
>>  vdso-install-y			+= arch/riscv/kernel/vdso/vdso.so.dbg
>> +vdso-install-$(CONFIG_RISCV_USER_CFI)	+= arch/riscv/kernel/vdso_cfi/vdso-cfi.so.dbg
>>  vdso-install-$(CONFIG_COMPAT)	+= arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
>>
>>  BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader loader.bin xipImage vmlinuz.efi
>> diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
>> index f80357fe24d1..3fc8f72b8bfb 100644
>> --- a/arch/riscv/include/asm/vdso.h
>> +++ b/arch/riscv/include/asm/vdso.h
>> @@ -18,9 +18,13 @@
>>
>>  #ifndef __ASSEMBLER__
>>  #include <generated/vdso-offsets.h>
>> +#include <generated/vdso-cfi-offsets.h>
>>
>>  #define VDSO_SYMBOL(base, name)							\
>> -	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
>> +	((IS_ENABLED(CONFIG_RISCV_USER_CFI) &&					\
>> +	  riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) ?			\
>> +	  (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
>> +	  (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
>>
>>  #ifdef CONFIG_COMPAT
>>  #include <generated/compat_vdso-offsets.h>
>> @@ -33,6 +37,7 @@ extern char compat_vdso_start[], compat_vdso_end[];
>>  #endif /* CONFIG_COMPAT */
>>
>>  extern char vdso_start[], vdso_end[];
>> +extern char vdso_cfi_start[], vdso_cfi_end[];
>>
>>  #endif /* !__ASSEMBLER__ */
>>
>> diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
>> index 2d0e0dcedbd3..9026400cba10 100644
>> --- a/arch/riscv/kernel/Makefile
>> +++ b/arch/riscv/kernel/Makefile
>> @@ -72,6 +72,7 @@ obj-y	+= vendor_extensions/
>>  obj-y	+= probes/
>>  obj-y	+= tests/
>>  obj-$(CONFIG_MMU) += vdso.o vdso/
>> +obj-$(CONFIG_RISCV_USER_CFI) += vdso_cfi/
>>
>>  obj-$(CONFIG_RISCV_MISALIGNED)	+= traps_misaligned.o
>>  obj-$(CONFIG_RISCV_MISALIGNED)	+= unaligned_access_speed.o
>> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
>> index 3a8e038b10a2..bf080e519101 100644
>> --- a/arch/riscv/kernel/vdso.c
>> +++ b/arch/riscv/kernel/vdso.c
>> @@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
>>
>>  static int __init vdso_init(void)
>>  {
>> +	/* Hart implements zimop, expose cfi compiled vdso */
>> +	if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
>> +		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
>> +		vdso_info.vdso_code_start = vdso_cfi_start;
>> +		vdso_info.vdso_code_end = vdso_cfi_end;
>> +	}
>> +
>>  	__vdso_init(&vdso_info);
>>  #ifdef CONFIG_COMPAT
>>  	__vdso_init(&compat_vdso_info);
>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>> index 272f1d837a80..a842dc034571 100644
>> --- a/arch/riscv/kernel/vdso/Makefile
>> +++ b/arch/riscv/kernel/vdso/Makefile
>> @@ -20,6 +20,10 @@ endif
>>  ifdef VDSO_CFI_BUILD
>>  CFI_MARCH = _zicfilp_zicfiss
>>  CFI_FULL = -fcf-protection=full
>> +CFI_SUFFIX = -cfi
>> +OFFSET_SUFFIX = _cfi
>> +ccflags-y += -DVDSO_CFI=1
>> +asflags-y += -DVDSO_CFI=1
>>  endif
>>
>>  # Files to link into the vdso
>> @@ -48,13 +52,20 @@ endif
>>  CFLAGS_hwprobe.o += -fPIC
>>
>>  # Build rules
>> -targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds
>> +vdso_offsets := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),)-offsets.h
>> +vdso_o := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
>> +vdso_so := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so
>> +vdso_so_dbg := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so.dbg
>> +vdso_lds := vdso.lds
>> +
>> +targets := $(obj-vdso) $(vdso_so) $(vdso_so_dbg) $(vdso_lds)
>> +
>>  obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
>>
>> -obj-y += vdso.o
>> -CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
>> +obj-y += vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
>> +CPPFLAGS_$(vdso_lds) += -P -C -U$(ARCH)
>>  ifneq ($(filter vgettimeofday, $(vdso-syms)),)
>> -CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
>> +CPPFLAGS_$(vdso_lds) += -DHAS_VGETTIMEOFDAY
>>  endif
>>
>>  # Disable -pg to prevent insert call site
>> @@ -63,12 +74,12 @@ CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
>>  CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
>>
>>  # Force dependency
>> -$(obj)/vdso.o: $(obj)/vdso.so
>> +$(obj)/$(vdso_o): $(obj)/$(vdso_so)
>>
>>  # link rule for the .so file, .lds has to be first
>> -$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
>> +$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
>>  	$(call if_changed,vdsold_and_check)
>> -LDFLAGS_vdso.so.dbg = -shared -soname=linux-vdso.so.1 \
>> +LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
>>  	--build-id=sha1 --eh-frame-hdr
>>
>>  # strip rule for the .so file
>> @@ -79,9 +90,9 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
>>  # Generate VDSO offsets using helper script
>>  gen-vdsosym := $(src)/gen_vdso_offsets.sh
>>  quiet_cmd_vdsosym = VDSOSYM $@
>> -	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
>> +	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) $(OFFSET_SUFFIX) | LC_ALL=C sort > $@
>>
>> -include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
>> +include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
>>  	$(call if_changed,vdsosym)
>>
>>  # actual build commands
>> diff --git a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> index c2e5613f3495..bd5d5afaaa14 100755
>> --- a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> +++ b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
>> @@ -2,4 +2,6 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>
>>  LC_ALL=C
>> -sed -n -e 's/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2_offset\t0x\1/p'
>> +SUFFIX=${1:-""}
>> +sed -n -e \
>> +'s/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2'$SUFFIX'_offset\t0x\1/p'
>> diff --git a/arch/riscv/kernel/vdso_cfi/Makefile b/arch/riscv/kernel/vdso_cfi/Makefile
>> new file mode 100644
>> index 000000000000..8ebd190782b0
>> --- /dev/null
>> +++ b/arch/riscv/kernel/vdso_cfi/Makefile
>> @@ -0,0 +1,25 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +# RISC-V VDSO CFI Makefile
>> +# This Makefile builds the VDSO with CFI support when CONFIG_RISCV_USER_CFI is enabled
>> +
>> +# setting VDSO_CFI_BUILD triggers build for vdso differently
>> +VDSO_CFI_BUILD := 1
>> +
>> +# Set the source directory to the main vdso directory
>> +src := $(srctree)/arch/riscv/kernel/vdso
>> +
>> +# Copy all .S and .c files from vdso directory to vdso_cfi object build directory
>> +vdso_c_sources := $(wildcard $(src)/*.c)
>> +vdso_S_sources := $(wildcard $(src)/*.S)
>> +vdso_c_objects := $(addprefix $(obj)/, $(notdir $(vdso_c_sources)))
>> +vdso_S_objects := $(addprefix $(obj)/, $(notdir $(vdso_S_sources)))
>> +
>> +$(vdso_S_objects): $(obj)/%.S: $(src)/%.S
>> +	$(Q)cp $< $@
>> +
>> +$(vdso_c_objects): $(obj)/%.c: $(src)/%.c
>> +	$(Q)cp $< $@
>> +
>> +# Include the main VDSO Makefile which contains all the build rules and sources
>> +# The VDSO_CFI_BUILD variable will be passed to it to enable CFI compilation
>> +include $(src)/Makefile
>> diff --git a/arch/riscv/kernel/vdso_cfi/vdso-cfi.S b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
>> new file mode 100644
>> index 000000000000..d426f6accb35
>> --- /dev/null
>> +++ b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright 2025 Rivos, Inc
>> + */
>> +
>> +#define	vdso_start	vdso_cfi_start
>> +#define	vdso_end	vdso_cfi_end
>> +
>> +#define __VDSO_PATH "arch/riscv/kernel/vdso_cfi/vdso-cfi.so"
>> +
>> +#include "../vdso/vdso.S"
>>
>> --
>> 2.43.0
>>
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
>---
>diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
>index 3fc8f72b8bfb..9cfbb390270f 100644
>--- a/arch/riscv/include/asm/vdso.h
>+++ b/arch/riscv/include/asm/vdso.h
>@@ -18,13 +18,21 @@
>
> #ifndef __ASSEMBLER__
> #include <generated/vdso-offsets.h>
>+#if IS_ENABLED(CONFIG_RISCV_USER_CFI)
>+
> #include <generated/vdso-cfi-offsets.h>
>
> #define VDSO_SYMBOL(base, name)							\
>-	((IS_ENABLED(CONFIG_RISCV_USER_CFI) &&					\
>-	  riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) ?			\
>-	  (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
>-	  (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
>+	(riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) ?			\
>+	 (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
>+	 (void __user *)((unsigned long)(base) + __vdso_##name##_offset)
>+
>+#else /* !CONFIG_RISCV_USER_CFI */
>+
>+#define VDSO_SYMBOL(base, name)							\
>+	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
>+
>+#endif /* CONFIG_RISCV_USER_CFI */
>
> #ifdef CONFIG_COMPAT
> #include <generated/compat_vdso-offsets.h>
>

