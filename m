Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A36CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 16:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8AC8E002C; Fri, 10 Oct 2025 12:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0CF8E0023; Fri, 10 Oct 2025 12:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F290C8E002C; Fri, 10 Oct 2025 12:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFF0E8E0023
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:51:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58CB6119DCC
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:51:32 +0000 (UTC)
X-FDA: 83982795624.18.59BF4DF
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 498D8180005
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:51:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Qg+jf3nL;
	spf=pass (imf16.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760115090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEIgQBXV9GwQ/0dS70LI3mvqTg3PMZTKu+jR89lRS3I=;
	b=EvAiRoiSCN5fGO0IoeQxDecbZN/zV6fAWeYT8l97zF2J3bTyXhlH3QHJhScz5Q8WgZH1mQ
	flYN/TT4Gc321oepwbHe0/jZ3q++YBX82u93a6/WjlHcPKoi3DGF3/TjCYbmH6lEFQ2BKv
	Ka8Ct3+iFCvLK63lhe+ag1ng5gZMtVE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Qg+jf3nL;
	spf=pass (imf16.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.166.43 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760115090; a=rsa-sha256;
	cv=none;
	b=CQcwADosBlfUOYihwH+pywjp+30pPXCs9bIKgKaaC/zYIcTjTqUwqwJBn3xOfA173KYLZl
	LS46MhU1JUHwE/cZ1JW53Rf5jwyN9ZdCKu983PVUMLQJ22pieTN+mXqOKtx+wBYRje6Hra
	xDQxGeWBYF1Rc3TxEaBm8HrJJaWtZ3Q=
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-930a6c601b3so222412939f.3
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1760115089; x=1760719889; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEIgQBXV9GwQ/0dS70LI3mvqTg3PMZTKu+jR89lRS3I=;
        b=Qg+jf3nLbyFxsWNoW0+HMuKRDnkM35zuC+V+wz7R/8hVpnjWrzL337/N4Oxu7DcNt/
         8rQcX3tV4p7Ci/r01QdXEHqwOTqvXkDoKck2g0kGKMC9SRc4r1/KVA1EP9aCnh3kgdcn
         YebiDTwg4aP063BqhKr2cCLggA85+HMp1j60i1UCWB0kUiq2E4B4HORUCCgsT6KesvMa
         3Zzat01wKCFjVG68HNtqv86dcCU8nR/MFCaFk7nUlZup9nf8K9RLExO+KLov+Ag7Wbpg
         MOqotzvQcro1Ynfk+weMBpcx9uRa+VlzDK3l+pa6+LrQhdB9MmQkh5zpel+PxQFleVAI
         i4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760115089; x=1760719889;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oEIgQBXV9GwQ/0dS70LI3mvqTg3PMZTKu+jR89lRS3I=;
        b=FnprAtg/Jt6Z2p/YOaXftX372iKq0zE7DV8chi9AeQiP5hWb0CpKGmLhKj08exb7H8
         zIXnQydBebRHqHOrEONxelIWjDy2vOEn4QKZZ/8WCztjYMXvnrjzPWTYPt7FmhvVJyVV
         fgvo5wksfZaa7EB80YqitVdqfKmXDrSO/qNrxN3p6fFngydFBWVGeu7VgQ8HcJ+1kksO
         +UAZ9ijFFSwY7bcDTSGBQPgaWDNhX89GjPTE+zBcDttwcQnnaFoOC545OC4ns4TOt7fy
         YkQm73Hui2NMwfO2RJmPsbgFuRt65x4WALQUX72mxybzbHAlKCs4eZ/q9oiSfv+yZZxz
         xOSw==
X-Forwarded-Encrypted: i=1; AJvYcCXYbB8lGbG4syyj7FC1Dcyum8PtHGgoWtiWaZPTshdCaaHATXSl/pQvEMCwEKqOlHPQf34DkCMbXw==@kvack.org
X-Gm-Message-State: AOJu0Yx5UTl/2lC+aVDWwxIFJ+FWTHr60/MfSpyo6o7eEtj8jtqZzV9D
	5LvRBMgeHcc49S3W2tMFV1yVU+AyzBa8bnI3g5FIP8iUNj1UFR71Nl+KqH7X5+RVtHs=
X-Gm-Gg: ASbGncttJEz5VW4QDosZu13//1r7RCFTzXF7nmwQ0qa2IZ+DcPMPBEUnhGKMk9rtYeS
	otxhRBOD0r1byy1mUtz4EiGFp53OiJFhyJHyfodiHRNUVn/uyiUgNOCW26/8wt9UhP5Q09RfffT
	pOzGZHwOqNLO6ZLt7Js4RvgDaPo+XKUdEI+Ihapzm9NEH3YOINijZpCz/+bT3kowJZ54VVlRCdw
	caOfDVCmRM45C1dNjoO/JCq7/41VOtrDz0VWKz3T4KuoNB18Fc/WBTwz3VS+4IxwSvMMQGsPVCa
	626uNugFWi823/+zzhAasbAXolxIE1+ix+gsq5UYu9Z8v6rDhsMh2DHgYHPbwFEzhlsWjKLHmfC
	4G8sA/GclpAUyhlwN4k2b0icWMekS1CE1+YKPl5Vk6A==
X-Google-Smtp-Source: AGHT+IE3jpt/o7GLJZwpn6pE5MwHXBbBbWmYCLc2vN2apcU0MOIuhKG3h3YETs47jD8aWS8NvxasSQ==
X-Received: by 2002:a05:6602:6013:b0:8ef:d0e4:43d8 with SMTP id ca18e2360f4ac-93bd186600dmr1560312839f.3.1760115089131;
        Fri, 10 Oct 2025 09:51:29 -0700 (PDT)
Received: from [100.64.0.1] ([170.85.6.207])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e25a95cbbsm111538339f.22.2025.10.10.09.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 09:51:28 -0700 (PDT)
Message-ID: <53f717fb-b79e-49e0-9c1d-cf626b9a99b0@sifive.com>
Date: Fri, 10 Oct 2025 11:51:27 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/18] riscv: dts: starfive: jh7100: Use physical
 memory ranges for DMA
To: Emil Renner Berthing <emil.renner.berthing@canonical.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Conor Dooley <conor@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-18-samuel.holland@sifive.com>
 <CAJM55Z_C_ce6wwCpNyGeozxBKW1krSrdzApvGumLn_p7K0hhYw@mail.gmail.com>
From: Samuel Holland <samuel.holland@sifive.com>
Content-Language: en-US
In-Reply-To: <CAJM55Z_C_ce6wwCpNyGeozxBKW1krSrdzApvGumLn_p7K0hhYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 498D8180005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xrzw53y4ysn7o5r6ba41crp9ym7889co
X-HE-Tag: 1760115090-477772
X-HE-Meta: U2FsdGVkX18BEzTpbNgdMEEorrJ1CyixeHuwAX34SiP8+3aRsL0yYdiAebQ/20CLoV37IX/5gNwX2sHw8Y4SJ59PTd4IFFvJhdSeLMtik40o0SQuWTbSo/kjeK69Q6kuFZJ0VzN2dr9WnJn888RQKyvK8Wys/h/5CNbDbni7UtbsiVt49mKLhqFG83JwYGT9HbY+OjqgWe1JmR3Lu9EaFDDMwqtXoMhnjdkXPEydRW+jrmzngpIV0zkYIHSPi8aOtTowbFXXPHS/YnDWoO76cPYNNukyvsJTmnjSAcROn8hEeAkQzE0cC9feeYiLZ+upGSCSxn2byTOXwzT4BZAFHYswezWA2Uitvf8thj8IR2pBD5vKGISFpuKRZEt55/BFBiDonqER3plXrnR39Ou9Mcz2XsTgOEaAjYJusJbRrDEegZ8IvSGoIBkvmTeDCNqZ6ntqI+Oel4IbAnO8RoaLmK8uFV9Sg3JJmeZJCoYD4xiSYpCLuM8hK5l5CESYQfM7ssz35JOHRmwHDvljwghug6yISxzaGDGWmVzXG5dAxouR+0ugor4RKCp8lQjwFGsFBkigNzu/ci8kqtwRYGnHS8krHS+v2BWJuwmVNuVe6V7qXHnjHwI7BzX0L2MdjjHfgNU5g2Y5VBT8hkbzn+Jkoq28i22iDVneWTQwALMow8rilGOVxVx34vj35EuT9hlo3ftsKKUtX6zHCpXHod5SGmtIa5dSy2V45y/kxWUsZLyOFZ1wGreopIzzS5yF5bFcYShCVWju2ZBDgKYbkvrMXWYQpGSGbtaYvt4yGnLEyKFW0gG31H4kHOoB3H1v5ayNzIJzNeOAyyRmq/RVFyK1awO3vY27oO4DDvkFH60nu5buCL595JjxMBLnp2Fvm9JT++XE4ocF0UUtfZrb3Od2a7MEqxAQ4kWDVTMya7thBUzXvcCV5Em1EQFCHv44Rgz4dLhT7fWn5sNRSYhyhIc
 QxUks3Tz
 oZTqA4TdMqiYtST+wY4rWVo9mKdGxuGECoK1JAsFD8+PehQ2stTxHmGYBq429/rHrq7gTV5anhZKDJ8S/N6doFlcEIRVFw8CNyoPmyA58AxCmWFupFFp8qZMw3eNrZwTCaomKvcgeDm81CmY4AVgRLjdm34tkfRn40AmQFufUD9FzyO2y2ApcN/lCoafetSxD8yjkShVOOqkTHNys9o1sIAabc//cTdZ2wTBeHguTHUGYe4pksSoJGM/TrYK9DwQdxDies2sSKb1TrcF5cS+y50IsXmwTRuNkxcXuCmjf1PVgirARi0kBw4oyiQUiaFWN3cKyIP/YRFhf3yYWtvxqw4/xLHBq7J/Yt/4SsWvgR+cr97YW8FkEYqHFl/+MQFGO4KQVmRU4olw3hMUWshnXpvnS+cLgL1mdyMyU1MxzsyCsg6cLCeCw+Jrpk7QBd/cTQtuZUPBBWQoqt2khcI1dW6a0AlAYxj7AbwBt4pUM3cIx6E16fiARuWsIHMoovExxslVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Emil,

On 2025-10-10 9:19 AM, Emil Renner Berthing wrote:
> Samuel Holland wrote:
>> JH7100 provides a physical memory region which is a noncached alias of
>> normal cacheable DRAM. Now that Linux can apply PMAs by selecting
>> between aliases of a physical memory region, any page of DRAM can be
>> marked as noncached for use with DMA, and the preallocated DMA pool is
>> no longer needed. This allows portable kernels to boot on JH7100 boards.
>>
>> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
>> ---
>>
>> Changes in v2:
>>  - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
>>  - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected
>>
>>  arch/riscv/Kconfig.errata                     | 19 ---------------
>>  arch/riscv/Kconfig.socs                       |  2 ++
>>  .../boot/dts/starfive/jh7100-common.dtsi      | 24 -------------------
>>  arch/riscv/boot/dts/starfive/jh7100.dtsi      |  4 ++++
>>  4 files changed, 6 insertions(+), 43 deletions(-)
>>
>> diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
>> index e318119d570de..62700631a5c5d 100644
>> --- a/arch/riscv/Kconfig.errata
>> +++ b/arch/riscv/Kconfig.errata
>> @@ -53,25 +53,6 @@ config ERRATA_SIFIVE_CIP_1200
>>
>>  	  If you don't know what to do here, say "Y".
>>
>> -config ERRATA_STARFIVE_JH7100
>> -	bool "StarFive JH7100 support"
>> -	depends on ARCH_STARFIVE
>> -	depends on !DMA_DIRECT_REMAP
>> -	depends on NONPORTABLE
>> -	select DMA_GLOBAL_POOL
>> -	select RISCV_DMA_NONCOHERENT
>> -	select RISCV_NONSTANDARD_CACHE_OPS
>> -	select SIFIVE_CCACHE
>> -	default n
>> -	help
>> -	  The StarFive JH7100 was a test chip for the JH7110 and has
>> -	  caches that are non-coherent with respect to peripheral DMAs.
>> -	  It was designed before the Zicbom extension so needs non-standard
>> -	  cache operations through the SiFive cache controller.
>> -
>> -	  Say "Y" if you want to support the BeagleV Starlight and/or
>> -	  StarFive VisionFive V1 boards.
>> -
>>  config ERRATA_THEAD
>>  	bool "T-HEAD errata"
>>  	depends on RISCV_ALTERNATIVE
>> diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
>> index 848e7149e4435..a8950206fb750 100644
>> --- a/arch/riscv/Kconfig.socs
>> +++ b/arch/riscv/Kconfig.socs
>> @@ -50,6 +50,8 @@ config SOC_STARFIVE
>>  	bool "StarFive SoCs"
>>  	select PINCTRL
>>  	select RESET_CONTROLLER
>> +	select RISCV_DMA_NONCOHERENT
>> +	select RISCV_NONSTANDARD_CACHE_OPS
> 
> Hi Samuel,
> 
> Thanks for working on this! I think you also need to select DMA_DIRECT_REMAP
> here, otherwise devices complain that they can't allocate coherent memory at
> all.

It looks like the logic for selecting DMA_DIRECT_REMAP is all messed up.
Currently it's selected by RISCV_ISA_ZICBOM and ERRATA_THEAD_CMO, but really it
has nothing to do with CMOs and everything to do with being able to allocate and
map coherent pages. So it should be selected by the three PBMT options instead.
I'll fix this in v3. I didn't notice because I always had RISCV_ISA_ZICBOM enabled.

> But even with that added it still doesn't work for me with 6.17 on the JH7100,
> the sdcard isn't initialized properly, and I haven't figured out why yet. I
> seem to remember your previous version did work though.
> 
> Plain 6.17:          https://esmil.dk/pma/upstream.txt
> 6.17 + this series:  https://esmil.dk/pma/test.txt
> 
> The kernel config I'm using is available here:
> https://esmil.dk/pma/config.txt

There's a bug in this DT patch (see below). If that still doesn't work, please
ping me and I can help debug. I will also have access to a JH7100 board within
the next few days, so I will be able to test this SoC locally before sending v3.

Thanks,
Samuel

>>  	select ARM_AMBA
>>  	help
>>  	  This enables support for StarFive SoC platform hardware.
>> diff --git a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
>> index ae1a6aeb0aeaa..47d0cf55bfc02 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
>> +++ b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
>> @@ -42,30 +42,6 @@ led-ack {
>>  		};
>>  	};
>>
>> -	reserved-memory {
>> -		#address-cells = <2>;
>> -		#size-cells = <2>;
>> -		ranges;
>> -
>> -		dma-reserved@fa000000 {
>> -			reg = <0x0 0xfa000000 0x0 0x1000000>;
>> -			no-map;
>> -		};
>> -
>> -		linux,dma@107a000000 {
>> -			compatible = "shared-dma-pool";
>> -			reg = <0x10 0x7a000000 0x0 0x1000000>;
>> -			no-map;
>> -			linux,dma-default;
>> -		};
>> -	};
>> -
>> -	soc {
>> -		dma-ranges = <0x00 0x80000000 0x00 0x80000000 0x00 0x7a000000>,
>> -			     <0x00 0xfa000000 0x10 0x7a000000 0x00 0x01000000>,
>> -			     <0x00 0xfb000000 0x00 0xfb000000 0x07 0x85000000>;
>> -	};
>> -
>>  	wifi_pwrseq: wifi-pwrseq {
>>  		compatible = "mmc-pwrseq-simple";
>>  		reset-gpios = <&gpio 37 GPIO_ACTIVE_LOW>;
>> diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> index 7de0732b8eabe..34ff65d65ac7e 100644
>> --- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> +++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
>> @@ -7,11 +7,15 @@
>>  /dts-v1/;
>>  #include <dt-bindings/clock/starfive-jh7100.h>
>>  #include <dt-bindings/reset/starfive-jh7100.h>
>> +#include <dt-bindings/riscv/physical-memory.h>
>>
>>  / {
>>  	compatible = "starfive,jh7100";
>>  	#address-cells = <2>;
>>  	#size-cells = <2>;
>> +	riscv,physical-memory-regions =
>> +		<0x00 0x80000000 0x08 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0x0>,
>> +		<0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(1)) 0x0>;

This should be PMR_ALIAS(0), because I removed the special entry from the
beginning of this list.

>>
>>  	cpus: cpus {
>>  		#address-cells = <1>;
>> --
>> 2.47.2
>>


