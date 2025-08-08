Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E54C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 17:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6AE8E0003; Fri,  8 Aug 2025 13:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877A58E0001; Fri,  8 Aug 2025 13:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73F1D8E0003; Fri,  8 Aug 2025 13:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 572708E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:04:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7D1111551E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:04:00 +0000 (UTC)
X-FDA: 83754212640.09.3800D41
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 815EE1C0008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 17:03:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754672638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bro5Z1PL2eLig5Q2ncFtimJM/b9sdMd4TeRUxnnShL0=;
	b=dzx6O+thZJDmhLuGwSHXitjqv1uW3g9DWsIKM7qgcshFCUbwldCwcuy8YAB5ps5QbfFSB+
	lYCRaWAK1fxHQFY96w2lC/mOYXH6IwpDKmR1iotnBHBN74AYWqgNbOD+dSBwaJR42Nu7bJ
	2sesz5NgvxM8dmZHpVVvyhah02uvn/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754672638; a=rsa-sha256;
	cv=none;
	b=ea//ua3R5mJotgEbUlJIW6D5gR5+2Gkw6UTjtU5Y3drqzoe1C6+QBWGYn0DtGghKzr0auI
	5MpIBFOi15JfAfNnKXN5P9VXGxk2cucRQ7p5JlV2c73c0dk4WxTQxp7t+tKDVcgEonFPt2
	5JwdhY9iqIj/V8F/HF3SjOrZzVOf2T0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf20.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4bz9NX4Hmyz9sSb;
	Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4LtEzBBocysS; Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4bz9NX36z3z9sSZ;
	Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 55AF68B770;
	Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id Z2c0fwWGRIPg; Fri,  8 Aug 2025 19:03:56 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 20F878B763;
	Fri,  8 Aug 2025 19:03:55 +0200 (CEST)
Message-ID: <af677847-e625-43d7-8750-b2ce4ba9626c@csgroup.eu>
Date: Fri, 8 Aug 2025 19:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: ryabinin.a.a@gmail.com, bhe@redhat.com, hca@linux.ibm.com,
 andreyknvl@gmail.com, akpm@linux-foundation.org, zhangqing@loongson.cn,
 chenhuacai@loongson.cn, davidgow@google.co, glider@google.com,
 dvyukov@google.com, alex@ghiti.fr, agordeev@linux.ibm.com,
 vincenzo.frascino@arm.com, elver@google.com, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250807194012.631367-1-snovitoll@gmail.com>
 <20250807194012.631367-2-snovitoll@gmail.com>
 <22872a3f-85dc-4740-b605-ba80b5a3b1bc@csgroup.eu>
 <CACzwLxjnofD0EsxrtgbG3svXHL+TpYcio4B67SCY9Mi3C-jdsQ@mail.gmail.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <CACzwLxjnofD0EsxrtgbG3svXHL+TpYcio4B67SCY9Mi3C-jdsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 815EE1C0008
X-Stat-Signature: z6cs5ji53fyuutqgmeo3r9gyznckpsau
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754672638-779746
X-HE-Meta: U2FsdGVkX1+XoEhqfNS1a30hOym54XPeQc1ZwvE9P6Rf/agjqI54vJ0CVzCx8X1U560F+3dWswtXYt88rs/kBo4z4MRYd/52yhVNqE92Nu884B8PAtgi9YUskrvth+wKamfhfVOHwgvd7sva44SdbfA5cz1xWju3Dm73nnynR4Qd6Tjy2b5K62c9tCowa8y1eLiE9yjf8vO3kNAtal5UwqzGJ26krUxRwNHHQXBO5IZrnT0z7zp3FgYTXdF8OpQaV1FR9356tlNcShhhoV+3knuW2k/XZ8sUmCCJZsDK8jl8SOsKEZx8DKW/312tvfc9OcSGMQjQaOA+M5B0LGg/sxSMY3ymGW84pjMBSVEZdTF4q00drKQt+IF4Kbta58rfnHCy/dz86OMc1A6iQ/hyrbY4wNxyGdhLMW6i3pxjpILqVEyCxwJzxRRjXZg0GhlxzVh61uo5C1oXml+PsYVFdTMjUncI9UDcfTAgkgQG9x0Ju3BrRyc+wASP1/WyWXs3dwaCTbdQzqaEqRj3JZr0o1+0tlSPD8xj03pdSnZJ+YuWef+llGcXQErK+A4wecXxNaHIkKJm6ZQioNe4CVG6i2kkG0jv+JcOJCZi+SHWf6fxB6uTGrkEe4zy88ffRWFIk4soMnS+p18kI7b//N2Z7Onj4pus1PVCY577zXIcSXgkdP1JoVz84fkiwJmCiCjkBq1hxVyu8w+hmm1QKs/H29e8nsYnANixeMtWLIZCjDz38me5uRHjuNfyDJIzBo+4S7FTyDlAu5Jq3U9AmJiHHbOKnx+XNkewb/zjQdjs5nCOkQWZhBoHFsUlZgYASRcYudNFMGpk0d5AXsg3U68oZRHRDNVGsrKMo7EqpZkBe//xLDTxSUrET6BXU3T4cHWDvL8m+ZC2sT9iGLzbNVD6ZoxdaLapSjyLYFqrh0dXrBDwcNsI3pweJ0CJvsuXSslGueEIy8rZH15072kBN4t
 gigdudsc
 os4heEpQO380hh3uRve0m4PUYWYmrmNM4jBhSvMZGcD5SOdEWMf2z2CHMPuDZWdeOkPAytNjVFKO2T47Oaa9BKQB8JY9Q28wL+A/5OVjME/VEWYo1MW5COR/nO1bjSPQsRZVBdxG4RULGDmoRcXh3roAQU0kJnjTOhA/nvGk1YkYwjnZ+fyLZBz4PW9fCVo18RlBXTNr9rTiKB3Ue103pyLhBO/xHiu63CbVUq3IPnzzd50DVos+2VoOg1BM8F3r3hMRX9NI1LNO8QyF6ZJvoWIIQMlpNR+jcfwjvD4MuSveczORz6YtzTxMDgOoyQQGZA9Gq3XEt7f4iX5+GuSTAM6PjCinMdxUjDoKkk5U4W1Os02kvIrtJHoULVCZ5pAp9lnKtqU9eU0aNotGWjwElEQRQOSbw+Fpp2KsRGkyRoLPFoLgA35TrzT6z6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/08/2025 à 17:33, Sabyrzhan Tasbolatov a écrit :
> On Fri, Aug 8, 2025 at 10:03 AM Christophe Leroy
> <christophe.leroy@csgroup.eu> wrote:
>>
>>
>>
>> Le 07/08/2025 à 21:40, Sabyrzhan Tasbolatov a écrit :
>>> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures [1] that need
>>> to defer KASAN initialization until shadow memory is properly set up,
>>> and unify the static key infrastructure across all KASAN modes.
>>
>> That probably desserves more details, maybe copy in informations from
>> the top of cover letter.
>>
>> I think there should also be some exeplanations about
>> kasan_arch_is_ready() becoming kasan_enabled(), and also why
>> kasan_arch_is_ready() completely disappear from mm/kasan/common.c
>> without being replaced by kasan_enabled().
>>
>>>
>>> [1] PowerPC, UML, LoongArch selects ARCH_DEFER_KASAN.
>>>
>>> Closes: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D217049&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7Cfe4f5a759ad6452b047408ddd691024a%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638902640503259176%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=UM4uvQihJdeWwcC6DIiJXbn4wGsrijjRcHc55uCMErI%3D&reserved=0
>>> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
>>> ---
>>> Changes in v5:
>>> - Unified patches where arch (powerpc, UML, loongarch) selects
>>>     ARCH_DEFER_KASAN in the first patch not to break
>>>     bisectability
>>> - Removed kasan_arch_is_ready completely as there is no user
>>> - Removed __wrappers in v4, left only those where it's necessary
>>>     due to different implementations
>>>
>>> Changes in v4:
>>> - Fixed HW_TAGS static key functionality (was broken in v3)
>>> - Merged configuration and implementation for atomicity
>>> ---
>>>    arch/loongarch/Kconfig                 |  1 +
>>>    arch/loongarch/include/asm/kasan.h     |  7 ------
>>>    arch/loongarch/mm/kasan_init.c         |  8 +++----
>>>    arch/powerpc/Kconfig                   |  1 +
>>>    arch/powerpc/include/asm/kasan.h       | 12 ----------
>>>    arch/powerpc/mm/kasan/init_32.c        |  2 +-
>>>    arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
>>>    arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
>>>    arch/um/Kconfig                        |  1 +
>>>    arch/um/include/asm/kasan.h            |  5 ++--
>>>    arch/um/kernel/mem.c                   | 10 ++++++--
>>>    include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
>>>    include/linux/kasan.h                  |  6 +++++
>>>    lib/Kconfig.kasan                      |  8 +++++++
>>>    mm/kasan/common.c                      | 17 ++++++++++----
>>>    mm/kasan/generic.c                     | 19 +++++++++++----
>>>    mm/kasan/hw_tags.c                     |  9 +-------
>>>    mm/kasan/kasan.h                       |  8 ++++++-
>>>    mm/kasan/shadow.c                      | 12 +++++-----
>>>    mm/kasan/sw_tags.c                     |  1 +
>>>    mm/kasan/tags.c                        |  2 +-
>>>    21 files changed, 100 insertions(+), 69 deletions(-)
>>>
>>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>>> index f0abc38c40a..cd64b2bc12d 100644
>>> --- a/arch/loongarch/Kconfig
>>> +++ b/arch/loongarch/Kconfig
>>> @@ -9,6 +9,7 @@ config LOONGARCH
>>>        select ACPI_PPTT if ACPI
>>>        select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
>>>        select ARCH_BINFMT_ELF_STATE
>>> +     select ARCH_DEFER_KASAN if KASAN
>>
>> Instead of adding 'if KASAN' in all users, you could do in two steps:
>>
>> Add a symbol ARCH_NEEDS_DEFER_KASAN.
>>
>> +config ARCH_NEEDS_DEFER_KASAN
>> +       bool
>>
>> And then:
>>
>> +config ARCH_DEFER_KASAN
>> +       def_bool
>> +       depends on KASAN
>> +       depends on ARCH_DEFER_KASAN
>> +       help
>> +         Architectures should select this if they need to defer KASAN
>> +         initialization until shadow memory is properly set up. This
>> +         enables runtime control via static keys. Otherwise, KASAN uses
>> +         compile-time constants for better performance.
>>
> 
> Actually, I don't see the benefits from this option. Sorry, have just
> revisited this again.
> With the new symbol, arch (PowerPC, UML, LoongArch) still needs select
> 2 options:
> 
> select ARCH_NEEDS_DEFER_KASAN
> select ARCH_DEFER_KASAN

Sorry, my mistake, ARCH_DEFER_KASAN has to be 'def_bool y'. Missing the 
'y'. That way it is automatically set to 'y' as long as KASAN and 
ARCH_NEEDS_DEFER_KASAN are selected. Should be:

config ARCH_DEFER_KASAN
	def_bool y
	depends on KASAN
	depends on ARCH_NEEDS_DEFER_KASAN


> 
> and the oneline with `if` condition is cleaner.
> select ARCH_DEFER_KASAN if KASAN
> 

I don't think so because it requires all architectures to add 'if KASAN' 
which is not convenient.

Christophe

