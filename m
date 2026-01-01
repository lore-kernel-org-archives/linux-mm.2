Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7000EEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 02:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0460E6B0005; Wed, 31 Dec 2025 21:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35DF6B0089; Wed, 31 Dec 2025 21:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38EE6B008A; Wed, 31 Dec 2025 21:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D005D6B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 21:07:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7588C13C7FE
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:07:20 +0000 (UTC)
X-FDA: 84281757840.06.FEFFCD2
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 71B6C40004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 02:07:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bC4Eef1F;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767233238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQBF0g7LGMkaWXJONFj1Zzubf3JQP1KLJgb8Ha1McV4=;
	b=ujmsD73pcjlQc0VjGFM0eZJS2r8kR8zByGDL2FRxh9QrzgM/pQl4MqL5xFTLDmyWeWEbC1
	IjwvFAJrRoE9+gY5wdR44NUapJ7lXpdGNCxDjQ4fS8ABh+0qc/DesjjXkXot5YhCgcBOtv
	cAIkpk+hfsIQWrPRcACLwIQik/asL48=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bC4Eef1F;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767233238; a=rsa-sha256;
	cv=none;
	b=lniqqYCJip8On9pbJz8nlxUMRzZTBoZuySBrBTj4j2oEdEnFNQ7CEbSxIXT45eljoFxIYM
	j8visDxu89/hRW4LAmhCUtD+zmn+Jc1sk05fRl41J1VEonuCFMEa31mDGB+Uq39SE2/kKz
	D6y5U6y+kR1FRMHT4pgLLasepvpXcWs=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b736d883ac4so1883810566b.2
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 18:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767233237; x=1767838037; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQBF0g7LGMkaWXJONFj1Zzubf3JQP1KLJgb8Ha1McV4=;
        b=bC4Eef1FuySt5nh3pYNeedDQd+MsGOqcKlZ3i3fe1fL+FbTK1xsNUKJWoIS45ci+A9
         AyTmFkrfly4EdeUNG1Nz4QjtS0jhGYwg/9LhWjYOQSQMzMvSIOoon06urusZ2H069oZM
         SMDniKhQ+Tznd4OMwC7CcElJAllQkxEiPqGYpxksYIBJUQkXhU0rYdihmkQSz86AD5yj
         xukF+7AOS6j+Mi1ZtbITSNBtQ/FmLwM0gCoXAQnLR1P5Cl1cmCt1+0bXm1hE2oshVeI+
         IHjiy0YZsxgea6wd/8DwyPCfSsAn8JMNCnV2x5xwSHIq9fohZXdRKfZKzWLwY2X2IIcV
         CzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767233237; x=1767838037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UQBF0g7LGMkaWXJONFj1Zzubf3JQP1KLJgb8Ha1McV4=;
        b=qK+ZACi/XYaIvucYBfZnb+v1MEl8dTM9csxyDpHxapwqIIlzXufGDM5UlHxIoisokD
         4MpqXy4O+Xy2Gbk5toro8zSPYlfYODMTGrFXKQOcVlZDCesbIOxrtR5wxd5/0aW0AH5f
         xVIM/3iULiY/UrMld4AX/G57lLBoIoPamZlHigql2XKT7Hl+VP+rh1513wdcKKm5UVF3
         vIjugW6xavBGY9pX4qxsU1mb7tYKhzLE2H57VuquhNBAMwChRTywV2PQu4JquZ75oMgX
         s1HH0QEpldMVIyHi6uN0OnBkUvmONedFprxRbu3c5algCVYp8mS7Mr3L2l6yqi9258Ya
         FDtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWufw1DHRtFWLSV8THuU1/RzH3FIj+0T0kh4KNps1bQdXNVrkDeHgdMS0JZ31odiZOnKp2tErsnOA==@kvack.org
X-Gm-Message-State: AOJu0Yyxqd4D8wh39k/z88UueefGdN6UDEMnA9H7VwvCl8ht+KeUT/au
	s4XPzPiUoX5TvyrqG/j/tJl9qBVpKRRy7lW1v37NTxpMNDxmK+qtla20
X-Gm-Gg: AY/fxX7bvRIB82BhofTcFx7ptsOJ8vLWItOhlQaL+Xb8A+A7T/XIBzr4mvACBqYgzUr
	c2003d13/AMmeBYOaYMcYKP/1juDXX9isEeZ7jlPtArMUjbXMu5AntUZVpUhmgALctI/sy1fwds
	7rwgs3hXN45gKgBL8nLRyZl+N62UF8U71U023mezs179abjUTkRuYSS65KKaNdJSbakVIEezOyj
	0ktsnPXyZClXcT5nKvVIilJ1g+9xIj/RCuGEtgMIQNbUyDJBXOtmMAF4FNVSqO4QDaTzcLDX3Xm
	TPY/S+oLMXT/gmJ9GddcJgyf4BtAoCXUn8fbBEnNvt4PvJ3C70/2kTJ8vt43S+gT54xBZea0ER3
	bv07OVK5Txu3JApzMBEkSouKQDY3f9EmguNemGoHmBDXgG0QmBA7QwsesgzgbPJ3namyannnsCE
	TO8gkFCy3pHw==
X-Google-Smtp-Source: AGHT+IGkCnh9dqfLUptvpy4PZGXmScqGnHYP3DGjjwJuJ8br2u0RfwesNHaEMQG1tTnLLwW9sFl6GQ==
X-Received: by 2002:a17:907:7f05:b0:b72:9961:dc04 with SMTP id a640c23a62f3a-b8036f86950mr4237184166b.28.1767233236739;
        Wed, 31 Dec 2025 18:07:16 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b910601c7sm39251595a12.14.2025.12.31.18.07.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Dec 2025 18:07:16 -0800 (PST)
Date: Thu, 1 Jan 2026 02:07:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, will@kernel.org,
	aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
	dev.jain@arm.com, akpm@linux-foundation.org, david@kernel.org,
	ioworker0@gmail.com, linmag7@gmail.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20260101020715.45wqnjgcklvjcth3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <20251231094243.zmjs7kgflm7q6k73@master>
 <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Stat-Signature: eumae6fyri9ya4uzuqr56qhff4zq15hj
X-Rspam-User: 
X-Rspamd-Queue-Id: 71B6C40004
X-HE-Tag: 1767233238-532775
X-HE-Meta: U2FsdGVkX18mwYwSde1HomzlriVV4AbeeTjxh69BhyHNUU3jsQ6R4K4BILE7rJcPpeiPXwwq9uh4dPHbL76C9a0WqL6gsSRKCviTmMDKCZ1nqI6M3C+ttsBytQMxZ+I6o1mEqPzX0sEDbkjunmpwsCD0Jlir0KkS/RysMWGwkTIMk/kkNThR1Ov9EBUvboBaMNjTVGHAn8ywKkGcgq8EkyCobDby++v7m8YMvHPb/5jee+4/4HpoKHU+SkKvBnmOp0d60gf0L8ncwhqlKVixSw0pEWVVTexXhGvr5w8sYryE49n0959aBGJwbh0iv5t/nFSD+zvd+IyPewEhD9PBwGOBRB80lne4EoHy9J9WcVVq+EpAAuaJpwojx5kn2LDKX6ULHnR0dlT7MJ8dBvP0HU/i9rS6KArncfdYidiwhqwWeGLSqgwq3KUdUTsXsN0Hgn33VFehbkIErx+4jEszy432yAZ1iMHVcJGl9Jq8X0HSiG5k30rCmj9wa8gtR9LMkf+27Xa4/GOiSshKHlUmUR9agv7jC4d8QJiwazO5HZ4+9Xyl09qOPoSJHYrfXxO4+lGfihd5VVKdv83of+WneDM90eQuKr8XcfY4ZKQg0wxxmDHzlNiztSc0NFYUe5wZNJo9Y5EtPcqfUMvqxk5/wULheJlN4XUVHdsAKYXsB9B6HjBOvfvQ5ffKZ26h/jziysTLIqKgw13dn145bvkDutRLsr4uPPLUxIFiAXFGkGRjOKvd/sjadlI7SF4CCgwSLF5Dp/Eu5N7IxKBrHAD67w0WB5Xc3LbfZ0hTG5LE7ShfmLojoC2H8qvmqY8JcquZxDmPokFAJ77KHt/ZVkq2xRegG6TPDE+ijmGtBHZfYC2HyLIUyQYQmbV07xBjXAKPUmw8ywfj+ax9Rv5IPojONmXBqpDN5hqb8VBh6r9/Wd9LodY9ZyHQ5PoaSIswJ0sfOBcsLzHt6X9cbF/MTVV
 awxJ0/mB
 0R0hyNTAjZh4Yb2+HhrxdJhxKkTlRcga0lHY+fR4QG0TGt9pJ6ezFp6++kOOA/BYJilyCOHuINIegGd38T25mmieoOos+EwmNbIJzuzTL4F5pGiW0Q6QtUag4aY+2wSKlcF1b+QDuLqbUthtZYszLr7f/NaSdTfOGH2sUahKHXCp6Si5mnWd7xvy/iLiZuGiirj8tsHMyhr8NSmmVVImp1FAgGaWfaCS+/z27FO1oud1Kf3Xi3BxnO4vK4pEldo3PBvoppUFDPoRfXeUi0tpIqo7CaD7k2EXUyesIeLvvRFhbg4f26Lc/ZvzHhHXTQAjOS69bWvyFll1l8CuBtAB5DyLnqwdts8tbT/tiTs/kZS4CGZq3wXWeeCzNuD6imid/22UYnlZV4uKfMMpcPZObf+X2TvZ5wFOzoJcDVcCS8/bPmljfmlSuBZkR4CGgFNw7cnh1bVGoQj2+u6OBT1vdjfMnsVSSSPvk1pLjGCjV4hr70+t1RpY7X/heG1Q/cv6rEeU4ONtoLPW6rEgIQ0ltQEXK/PvQDHfCoyIT3mdItjw2KDbgE7M61XI8py8EK/pOHUsLBhvkKXpTPPTzQzaplIsZRSrtqQLvoVWwL+eeozgnzCuoAxp17rxGLVakPqHecna+ezxNHkPw5a9m2R0zEXKqmOQwjYZ42dF4nC++Inn1yrQlfj+41UMmiakaWpqMw7g+KctEmlNRSTpniull0i2gK2hzYES+dkIQahNPq1fWcejmA1Nb3c0sB/UZowiO83Btk2GBtJLjQaTyFq+KgDFaxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 05:52:57PM +0800, Qi Zheng wrote:
>
>
>On 12/31/25 5:42 PM, Wei Yang wrote:
>> On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>> > From: Qi Zheng <zhengqi.arch@bytedance.com>
>> > 
>> > The PT_RECLAIM can work on all architectures that support
>> > MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> > MMU_GATHER_RCU_TABLE_FREE.
>> > 
>> > BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> > to turn it off.
>> > 
>> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> > ---
>> > arch/x86/Kconfig | 1 -
>> > mm/Kconfig       | 9 ++-------
>> > 2 files changed, 2 insertions(+), 8 deletions(-)
>> > 
>> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > index 80527299f859a..0d22da56a71b0 100644
>> > --- a/arch/x86/Kconfig
>> > +++ b/arch/x86/Kconfig
>> > @@ -331,7 +331,6 @@ config X86
>> > 	select FUNCTION_ALIGNMENT_4B
>> > 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>> > 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> > -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>> > 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>> > 	select SCHED_SMT			if SMP
>> > 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>> > diff --git a/mm/Kconfig b/mm/Kconfig
>> > index bd0ea5454af82..fc00b429b7129 100644
>> > --- a/mm/Kconfig
>> > +++ b/mm/Kconfig
>> > @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>> > 	  The architecture has hardware support for userspace shadow call
>> >            stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> > 
>> > -config ARCH_SUPPORTS_PT_RECLAIM
>> > -	def_bool n
>> > -
>> > config PT_RECLAIM
>> > -	bool "reclaim empty user page table pages"
>> > -	default y
>> > -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> > -	select MMU_GATHER_RCU_TABLE_FREE
>> > +	def_bool y
>> > +	depends on MMU_GATHER_RCU_TABLE_FREE
>> > 	help
>> > 	  Try to reclaim empty user page table pages in paths other than munmap
>> > 	  and exit_mmap path.
>> 
>> Hi, Qi
>> 
>> I am new to PT_RECLAIM, when reading related code I got one question.
>> 
>> Before this patch,  we could have this config combination:
>> 
>>      CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
>> 
>> This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
>> is semi rcu version.
>> 
>> I am curious could we use rcu version tlb_remove_table_one() for this case?
>> Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
>> there some limitation here?
>
>I think there's no problem. The rcu version can also ensure that the
>fast GUP works well.
>

Thanks for your quick response :-)

And Happy New Year

So my little suggestion is move the definition of __tlb_remove_table_one()
under CONFIG_MMU_GATHER_RCU_TABLE_FREE. Do you thinks this would be more
clear?

>> 
>> Thanks in advance for your explanation.
>> 
>> 

-- 
Wei Yang
Help you, Help me

