Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2723FC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5822D6B0088; Mon, 28 Jul 2025 12:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A3E6B0089; Mon, 28 Jul 2025 12:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4703E6B008A; Mon, 28 Jul 2025 12:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 361816B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:37:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF4F3133A92
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:37:41 +0000 (UTC)
X-FDA: 83714229522.18.9E4EB6A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E05381C0009
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:37:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=RjF85WPh;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753720660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5q5M+CpT+5kwmRPJ46tyAoXGVagM73LO6ZWHv96bYmU=;
	b=nabhdrlGieswHhj6OgldJtVUl6fQxsGK71IBSwTqDd00rxnsDf/vchdtvLyZwvW4xMkoSe
	dL6UVgar3G5TfZPRGBIrZ38LX80xK8WFE8HTKOutlZ4NPUNK0UW1f78DytkNFhF8lYm0Jf
	e7z3mbaBIr0S7VwZ3somy4aBCdwh6k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753720660; a=rsa-sha256;
	cv=none;
	b=ZAvC79gdXtMEmETvFAbNsBDUAuGOv5juNSlR01bhCLk3a6tSH4ZzvGp8WPCFRc9IK9fxMZ
	8tLZgrI4v7AZpcX2vDnJPRn30LPINquq4un06S4/7ci8jzumKWEPXogYuNlIdjvtZ9jisU
	CBVOZ/e7I6ncm4o0HaDwBclO2Ya5BmY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=RjF85WPh;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23fc5aedaf0so16047715ad.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753720658; x=1754325458; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5q5M+CpT+5kwmRPJ46tyAoXGVagM73LO6ZWHv96bYmU=;
        b=RjF85WPhFl+X4gA0qYjgQsio52SA7v9fxbTFbRnkI4Qqq26x7psZvjCxJPN/EFBVkP
         U9o5pkvOVXvklCdBBugiKRnYZs2oLrt9zxcqqZJX2j+pfFqbzSQwFiXgunq10crrmfCD
         TG4RCkergLDq3z1mEqla07Cx6EDmgelvmN8R8hPAs3NaFhVeQRH3N0NobyLbmzUZhx2G
         TKnIdHbJ7NKBPDtGwMNXEXumhe8A9Er7Y5SgiUW5Q130Uch6bF36jLjbG7JFlKRHJXcp
         pdr7vWIdXN2Z2WyF5l/otYcsBO1X6iRnVmi8woqjWc4PP2BtasEVnE9SsYJbBpoTQxbj
         77Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753720659; x=1754325459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5q5M+CpT+5kwmRPJ46tyAoXGVagM73LO6ZWHv96bYmU=;
        b=VjUzV8VjspbUqf6ZzpUx1OiF9Tryx723g0dV6ThfAhtHZcaf/wqARB9bcRjRwiobCs
         wDhlxJ93wBmKLI9oJXVPgTd+euABN7wHFpatwyBODt6vzVfJVoNdHRB41Ak8ZocIDg1x
         8MCFoNUlwbuybBW0GLreE2pw6U3tBDcd+ARaPHU62RF6c6WO2dDX4gSZmpQXIlxo8ZHT
         rK0MomjkzxStrPUVLMKkQgdeJoC6hdDy3B+2VAZrIabt92TEaY+mB8L0G+tj9OYy4+GB
         g4R/w25H4kaWLJ9cDPyuHUv4Wr+i6ZCUdkWeAw4dSrBp/vRFiNPw+LkEXzFgFt+cWhS0
         xFXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXC4IJqCKRpE4yqAafXFO3JwOI7+01YzIuTIBoYZl1t8OlwEGj7HVYI2FVbIzDyP4dpgAjfJInvhw==@kvack.org
X-Gm-Message-State: AOJu0YxniM3WnnsjbIpMaH9tWHGhj7uTmp1t492xd5ZKncSxYDMoqoeS
	6ff58p5P27JHvhDJP9weSDSmdYm3vk16iWPMVzbGgygN9ceRBqZ0afSXRfqos1eQxvc=
X-Gm-Gg: ASbGnct8kf2uAQ+MrEYj0S26mX9H+o0CtGFoHVNLZIICu3VbYVXPStLHLdKvp/YNE80
	WBdO8cadOrMACOGSr7VNbtO8u/19U26wynqj8EOO7u45XzlsguZxCDtUsCf0xLfnvx2V46Y2oNB
	UqzoKSJhfZAWuYwbBJjKIXsaTL1CexjberX6O56Ew24Q/zgJtfiCoMhfxN69YHnxbKPITiES/a1
	xioTy96z5QXmx8GrcraLmhWP3P+M6GM9TZrh6qj4cnvVsHD1soHkNkTRODPWHd/Jl2Eh1yDWOIg
	U5PAVTrK9Qwv3qRrMximfr1aRk7wt6nECfFSDTix5UoK4Z7ncr9X2GInGJhV9x/6XFkoqh6uXZ0
	X5AesC5vwVnJFr0Lj/QlTSEmerJvUAydY
X-Google-Smtp-Source: AGHT+IG8PkXREALt2B41+CkCZk4vD0+tX/pzcMfIzczJ6dwSMXqtKdHnRzA6w8eQHSP6Yq5Aix/U2Q==
X-Received: by 2002:a17:903:1111:b0:23d:dd04:28e2 with SMTP id d9443c01a7336-23fb30cd1f9mr182480625ad.35.1753720658505;
        Mon, 28 Jul 2025 09:37:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23ff3ea7547sm40412335ad.149.2025.07.28.09.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 09:37:37 -0700 (PDT)
Date: Mon, 28 Jul 2025 09:37:34 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIenTs_D4l414isp@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <20250725161327.GC1724026@google.com>
 <aIdxUpSc-Co8wLYE@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aIdxUpSc-Co8wLYE@willie-the-truck>
X-Rspamd-Queue-Id: E05381C0009
X-Stat-Signature: p8jkqqbewfdagu3ntaxdu639xcwh6yr1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753720659-405968
X-HE-Meta: U2FsdGVkX19tiK0gdBalKBgqhi0FrzqJnr0JKi8ldaLCUJ+WOelIwUf1K1RRnCAUsWiO5T/oOuDRU2vOk57FpWImTWRlKFNvQCozMEOSbKlo0ykB2BWne73p+AThM6hkMw6cSNEK/VO/IAV7pUwkUcnPplEDDEXqGxCaZjkCLYosuxV9XPwQA5c9iCCAJxMaxAsG02P964tiwidU5U7MDhteeN4tnyKpCVyIidnnsPd0585ylxlkwovmseLCfF6tvh3PvgmxfAYOyAq0kD4MV/P3iLn4cuqLkT3vY+BpL6VrnqEg9A6bNiWS91DVlNYCkO0EgEz7YgxV14pDhFUdZqNzKhE4YteKUYKTa+UsiU0uVcQNqT9srq27HYvw4WEWY9AeY2ckCNvvQ7eK+RVx7C+Sk4UpLCFHpPWCZGkZNqCTjzBZXOul36j864G0Vehua4LWOcUNRTwU2hV/+OlGcRCr61F12U19R7mEpQ1CpxZtLMKXjpLmRmq2IN6FcO/j6ZLlcerftikpe8mUu9D/agIm3MwJWhXgEUYUnaAEOPC1PNSTHeUGu8xVuHzUYcCie9IGE8GteakBP0qtDddy7jMcaMG7X9oEtUvCHARQmWauwHb5vOxjVlBX5wJVOZSFzpAOifB36p3XZPKHb83GreTRXf8kxs8lnIR+AF18XEVVN3TsEuTZHqkiKU9ZNLqvrEU3iUZbt8GMbT1JmKy0ti3Hlthj8ZniKLJBAzNNu/gIFsDzl7x3eb1774Dgibuw5i8ArmmsdZNJuV6j8v/y6r9pTod/SSNrsycGhVtL2sTuoaZPZSg94WY5r9IKEs5SfKRZbT1whS8N8PDGxPGdLhMFBt9uUnEUb9Wb9WdagTJUQ52kwCRAcVU0jnxEH5Ii5a+tXVTrMwp4sIpwixz87AsNhPP9kQqMlXEEjsZ61qlSEnL1I3bOELvSe0CrdIJEcS4V0YsC3v494viw8b4
 xhR+GON+
 LJja8Sz347A6szOWilc0ZtkafojgiiqjS1JIlfZpXs06b6/82cg8/Qqxq7E3o8r1hFz+JI+/0x6wjdFSboxOaTrGsehB3v93rP7kORIRqH9qKOeKGe0svrBWyzjiVfZGC8OzCeT+QW9DZwtwmftzJ9x1umR8KtewxDUHgoiGMI7t8FiojQQKAN7efWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 01:47:14PM +0100, Will Deacon wrote:
>On Fri, Jul 25, 2025 at 04:13:27PM +0000, Sami Tolvanen wrote:
>> On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:
>> > diff --git a/include/linux/scs.h b/include/linux/scs.h
>> > index 4ab5bdc898cf..6ceee07c2d1a 100644
>> > --- a/include/linux/scs.h
>> > +++ b/include/linux/scs.h
>> > @@ -12,6 +12,7 @@
>> >  #include <linux/poison.h>
>> >  #include <linux/sched.h>
>> >  #include <linux/sizes.h>
>> > +#include <asm/scs.h>
>> >
>> >  #ifdef CONFIG_SHADOW_CALL_STACK
>> >
>> > @@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
>> >  	 * Reset the shadow stack to the base address in case the task
>> >  	 * is reused.
>> >  	 */
>> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> > +	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
>> > +#else
>> >  	task_scs_sp(tsk) = task_scs(tsk);
>> > +#endif
>> >  }
>> >
>> >  static inline unsigned long *__scs_magic(void *s)
>> >  {
>> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> > +	return (unsigned long *)(s);
>> > +#else
>> >  	return (unsigned long *)(s + SCS_SIZE) - 1;
>> > +#endif
>> >  }
>> >
>> >  static inline bool task_scs_end_corrupted(struct task_struct *tsk)
>> >  {
>> >  	unsigned long *magic = __scs_magic(task_scs(tsk));
>> > -	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
>> > +	unsigned long sz;
>> > +
>> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> > +	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
>> > +#else
>> > +	sz = task_scs_sp(tsk) - task_scs(tsk);
>> > +#endif
>> >
>> >  	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
>> >  }
>> >
>> > +static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
>> > +{
>> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> > +	arch_scs_store(s, magic_val);
>> > +#else
>> > +	*__scs_magic(s) = magic_val;
>> > +#endif
>> > +}
>> > +
>>
>> I'm not a huge fan of all the ifdefs. We could clean this up by
>> allowing architectures to simply override some these functions, or at
>> least use if (IS_ENABLED(CONFIG...)) instead. Will, any thoughts about
>> this?
>
>Yeah, I agree that allowing architectures to provide overrides makes
>sense, however I also suspect that some of this needs to be a runtime
>decision because not all CPUs will support the hardware-accelerated
>feature and will presumably want to fall back on the software
>implementation.

Hmm runtime fallback is an important point. Thanks. I'll munch on it a
bit.

>
>Will

