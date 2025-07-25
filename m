Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BB9C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC726B0088; Fri, 25 Jul 2025 10:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C460F6B0089; Fri, 25 Jul 2025 10:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE65E6B008A; Fri, 25 Jul 2025 10:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A47B6B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:43:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70862BB5CE
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:43:31 +0000 (UTC)
X-FDA: 83703055422.19.EF9B3B0
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4E5E020015
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:43:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=QqmmkhH+;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf03.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753454609; a=rsa-sha256;
	cv=none;
	b=dhMYQnI0YvLGl+fW9Tudq17W10vZko10rjg5L5du4F3tkZqyL4V5X21FgckWae5UcnETaq
	27NYzHc8Be5mmxPaz/lHRa1VMhNahzwXJVHXK6Hbeh13Ob0E2bkEpBLgYrhRGDhayMEwKE
	8dxpddo4t0RFXg9suf+/M0W4fuROE+Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b=QqmmkhH+;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf03.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753454609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0k2OjtFlklZYYSusmSIAAvwXtZV4jXB/0YYQlrt+7FM=;
	b=kHa3ruJCt5Clvq3mzRGzt7Ealpy8VzSrhSfX5KR+G46F9xTBKygmoBzulLTYMs1bKc0Enz
	N4O0zkuRxnCiSHQB3oAGvXIjkBuABR9/r5zFXvCMyQEO82a6emRbBhHIAgLZWes+hnq2ZX
	MuoImNQ4qrUpR3pIKGiVymyoFIj1xog=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 657AD3F73B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753454604;
	bh=0k2OjtFlklZYYSusmSIAAvwXtZV4jXB/0YYQlrt+7FM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=QqmmkhH+oeELz8SrXkqfveadWYD6f+xVH8sjn1VhlFAIFGN9jd9SfzZ4isziFZ78s
	 dB7LDJAuuc+11oFlJQAdJNCuEbygP8Q9209uinnVNzt3HNgfubaRW2qQ8nJD0qNBnN
	 1w8ze0+3jfL+r1n6Crwzst3r7i5eioJ54AH70pS7jkNBLcXVLE3Owtt8oPKJRKj+zf
	 etpbzFIJxvKm3Ud2vjvllm/Nt6m70SUJajYZf9ECDci+3uYtyOaEaNQL6Ep/xXchrx
	 iVTYOo6pKgbXGmFq+0Yxm0I1NkLwpoWeNVshj0Znpk/2PIzwLyz1uG8a5XWxiPekaj
	 7PO6641c4vGUQ==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6149374a4c8so3196976a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753454603; x=1754059403;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0k2OjtFlklZYYSusmSIAAvwXtZV4jXB/0YYQlrt+7FM=;
        b=OSxixFXLrdSVwJWF9RV5bHS6bCMaJWK03QzORg0RjZWXHFo/qydeT0kmFK0HA+/HqI
         SCPf5ak1CVkPnuBE12eFpnu2vupA8gjQ57u9kRpezLYgWOihHUSAjASko0Rvk9QSaGmu
         If1dH6IIhxpM0wrDXBpLKrDSUDfU2AhvxJok9GQYuipg/NPNGL1XV7QiL2Bzf1ACnNQC
         yGx63JdFYVv+78tjvsLmKQWbNQbZ2GMDE/7S5IIeaCoBg+dY/WVM/2pzr+WbroV+A8BZ
         04nZVq1g35BCxCME8Cyy3kplRDAgHopNr1h9yEs1HFGGloPiJA3SH6w454SG4b7ItN8Y
         y+vA==
X-Forwarded-Encrypted: i=1; AJvYcCXXqYfbTtLtH2get8Rs/DUug6q17mVj0Xg6hievrr4S8kk55kybdPlvWxApg724S23vHqV1E7e1tQ==@kvack.org
X-Gm-Message-State: AOJu0YwL0PZjgkscDmVewLjrBRdoQhNnw1kW4nBkTDUSaWAwn4PsESYS
	uHlocyz+koEN4aVQPhhkFhHHNlZ9iIrXi3OBZ1cvF2iOhZxJWL9WBFzFATpsKTGmneHLuABHUwv
	L1XYZF2SfIpVntDD1v6t+S0wf7spGbmDzN2i9esZNRdPMQ4KgyIgrMgdIezKMCFRZqFoT
X-Gm-Gg: ASbGncuEoRWqpNZ61gZTMhmLPkUcwyJP8AWRc1FlNM8M2D7XefmLxmqxBgSQx6lb8Q4
	ClRO5JVoQllp9F3IfL5viwSKOcZKcnynQzTnbHo3Jc4M18PmxxqIAfkfbUQd9x1wjnH1IqwGodm
	GlO/GAtzDL+6PPCK/aNsvEWLQDlrPAMLvREVKnzdz5QdA/k7dNFU6YME6n5u/zZuQEUdmrnYnDj
	XMcUARjz3Lm3yKxzGi/rG7l3CT2YV4wvaOofKKK9g9DVp6AQUh8OI7atycRvsxPv8torPmc/WiK
	Cl0uuEXnfsWVjwU1y97XEFqx8/hGA81IaGHTDWg4rAt+FEY4nW/T71Sad3qTqzMCvpxWwu16l9L
	hF2E/LsEE3YdI2anF/xJQTrYwapGkq7C3TJTp
X-Received: by 2002:a17:907:2d8f:b0:ae9:cd0a:5827 with SMTP id a640c23a62f3a-af61e533d42mr227199966b.20.1753454603613;
        Fri, 25 Jul 2025 07:43:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLGJ6zB3+OfdWnXfUelODaXvg8HjyVSfwaUZrmP6gSKNspnUl1zTG7y8LUoP5t34erFR1Evg==
X-Received: by 2002:a17:907:2d8f:b0:ae9:cd0a:5827 with SMTP id a640c23a62f3a-af61e533d42mr227194666b.20.1753454603155;
        Fri, 25 Jul 2025 07:43:23 -0700 (PDT)
Received: from [192.168.103.102] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635af9967sm1931166b.131.2025.07.25.07.43.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 07:43:22 -0700 (PDT)
Message-ID: <d6643810-094b-46d8-b223-b987783d23db@canonical.com>
Date: Fri, 25 Jul 2025 16:43:20 +0200
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
 <1149732f-bc8d-4339-90c3-e34aeac9f1be@canonical.com>
 <aIOSqskb_hBAqjIt@debug.ba.rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <aIOSqskb_hBAqjIt@debug.ba.rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E5E020015
X-Stat-Signature: szjsg7pumt9ei8zkc3warofg1na8e93g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753454609-419207
X-HE-Meta: U2FsdGVkX196ybbgibdOoveE9qlrs2UuooNvoN509PctkLtueJB/OFAuR5lPIqKmB3Wpz2W1RrdbkO7yq1ykCLB68KjMBDV0J9gEn021CTxa8DYVHbQWrE8XLgvPxfUK5GaKDokycQobgGZj8a+GrygvqjC57uTDmHTlx1kBe6cjxtp+rmK7EBZyFjHAPufsdu8J6QYbs27eq2Ck9OheMsjQLUh3jy1igpnIoJHeOcWFNgMiocfrf9JQKJrYnJcDlSFTUKBUVYVj4mRmVr5volTMUfbFPu5HWcE7/zH7Re1chW/sfe2w0CvVPAhTmbGdsVphqWfYfg3ABp2ylm7aSxjTvsGoxKgna5Cq6ZSUvwXIqESh1KL+3UxCdDG9GlbhVqK/WfOKwuPMjax6wReF8dNICrbO2MHb0nF7IIl5V5Vj2GSwL1QNs7KHyYVdmojXXXsdDXWbG3EM+lBaYbzNxc9VvGn7PicNn1EnGB9KjwIxVFkGTEBDg3q6LpNVyn2jL5/tVUofImQkhfJ0Nbq4wK1uYwJODL5E8/cLhkw0cGa7LMpPzpSZD2X5cZqFe4vXEn9EbROkWzipFwmzfZKZICx2qv14PgcnFuFUHf1NuOD/A5hlaf+3cM56ycMR2UC6yjxRQ3TOFoaJzfOK1a3h6Pc4hRGxd7PICT/7wgIHAdoX06S6RmtPlk1+gvDbLUelYPqkqwUzeUP2pCfZbdbYN1T8MBY+JJ3IzP6uw8PKdUg/9BzsPDm2UpQGgM13RGI744WXymteOPGP8jJ9jiIr35GOaVlgQY9TIGDKlWy1X9EVKpvYQxPIRY7eDkiASL9IIS4MFSzUGP1kxgHR/PiYSy2np6XmIGgNL3XVw/PvJCvwVKU1lY9b6OKl7cUCUrbAw8lSqS/NJ3MjY//VGq+aG5QAaK//131aGebwloBoPSCpXBFzHUsXQUI2K3wmC3hpDV1rSdMQ82fOdVC0iJH
 LXn078sY
 jlRrrenz+u0ygnixbxzlJz4Q7z77ahPWgNmAlJ5taqFBseQSUCiQu7uyeJJRQ3hA26LO9j39seOWz+pbd9mafNOI1igYQdCj1eoQ3/v7l56jz2X0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 16:20, Deepak Gupta wrote:
> On Fri, Jul 25, 2025 at 08:33:46AM +0200, Heinrich Schuchardt wrote:
>> On 25.07.25 01:36, Deepak Gupta wrote:
>>> Enables landing pad enforcement by invoking a SBI FWFT call.
>>>
>>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>>> ---
>>>  arch/riscv/kernel/asm-offsets.c |  1 +
>>>  arch/riscv/kernel/head.S        | 19 +++++++++++++++++++
>>>  2 files changed, 20 insertions(+)
>>>
>>> diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm- 
>>> offsets.c
>>> index e4d55126dc3e..e6a9fad86fae 100644
>>> --- a/arch/riscv/kernel/asm-offsets.c
>>> +++ b/arch/riscv/kernel/asm-offsets.c
>>> @@ -536,6 +536,7 @@ void asm_offsets(void)
>>>      DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
>>>      DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
>>>      DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
>>> +    DEFINE(SBI_FWFT_LANDING_PAD, SBI_FWFT_LANDING_PAD);
>>>      DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
>>>  #endif
>>>  }
>>> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
>>> index 9c99c5ad6fe8..59af044bf85c 100644
>>> --- a/arch/riscv/kernel/head.S
>>> +++ b/arch/riscv/kernel/head.S
>>> @@ -185,6 +185,16 @@ secondary_start_sbi:
>>>  1:
>>>  #endif
>>>      scs_load_current
>>> +
>>> +#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
>>> +    li a7, SBI_EXT_FWFT
>>> +    li a6, SBI_EXT_FWFT_SET
>>> +    li a0, SBI_FWFT_LANDING_PAD
>>> +    li a1, 1 /* enable landing pad for supervisor */
>>> +    li a2, SBI_FWFT_SET_FLAG_LOCK
>>> +    ecall    /* check for error condition and take appropriate 
>>> action */
>>> +#endif
>>> +
>>>      call smp_callin
>>>  #endif /* CONFIG_SMP */
>>> @@ -359,6 +369,15 @@ SYM_CODE_START(_start_kernel)
>>>  #endif
>>>      scs_load_current
>>> +#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
>>> +    li a7, SBI_EXT_FWFT
>>> +    li a6, SBI_EXT_FWFT_SET
>>> +    li a0, SBI_FWFT_LANDING_PAD
>>> +    li a1, 1 /* enable landing pad for supervisor */
>>
>> The SBI specification calls BIT(0) "LOCK".
>> Shouldn't we define a constant for the lock bit instead of using a 
>> magic value?
> 
> See below `li a2, SBI_FWFT_SET_FLAG_LOCK`.
> 
> "li a1, 1 /* enable landing pad for supervisor */>" --> this is enabling.
> Had we done "li a1, 0 /* enable landing pad for supervisor */" --> this is
> asking firmware to disable the feature (turn off the bit in menvcfg CSR)

So we lack constants for

"Enable landing pad for supervisor-mode"
"Disable landing pad for supervisor-mode"

Best regards

Heinrich

>>
>>> +    li a2, SBI_FWFT_SET_FLAG_LOCK
>>> +    ecall    /* check for error condition and take appropriate 
>>> action */
>>> +#endif
>>> +
>>>  #ifdef CONFIG_KASAN
>>>      call kasan_early_init
>>>  #endif
>>>
>>


