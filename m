Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE42EE57F7
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 09:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C82A6B0088; Wed, 31 Dec 2025 04:42:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9759E6B0089; Wed, 31 Dec 2025 04:42:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881756B008A; Wed, 31 Dec 2025 04:42:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 740066B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:42:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01E8E1407E3
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:42:47 +0000 (UTC)
X-FDA: 84279276816.24.2DBD133
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7BBD140007
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:42:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nTcl3tEl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767174165; a=rsa-sha256;
	cv=none;
	b=7h2qxTAN299jXyx4mbbIlqupS1wwxfrLy08DRCH1lguSLCh3f08K0/GfRRx+ByGN1opk+c
	IuovgFqe09JqN/gp5ya5fItkBi7obdqWg8nVam0cTaYMlTcbsSg5oQM6YgJuHAsRGofIfZ
	W7kck9hM3M7jaeu0YUg0pVVW2RtgUYw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nTcl3tEl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767174165;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhQC3hnAx6vo8ybVJwyWTzkkYGMOha8q8BXdXCtNSM8=;
	b=OkP4DDhHbfzPyzOJ/0NKSu5cofX6sSK/VBIU5CPQAgjmqXgbgPqUSI8Ropp9K60BWZLI9l
	k94FNRuwrrQ2wHyCrZt7VEdRHp8eIu2iAPhNkorFBqmFyVO2Sv/6+O2RCtjmC9Qt249V6N
	Q+sqOfvIPf+fH7XXoreCePtK5Y+BQg0=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b4f730a02so17765816a12.0
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767174164; x=1767778964; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RhQC3hnAx6vo8ybVJwyWTzkkYGMOha8q8BXdXCtNSM8=;
        b=nTcl3tEl4jVLiYE9MNCg7fy4vYBPxE8t8sLBui3bBFvf8fL6NWo1Al00FKThekWI9S
         L1dO9c1p6pRWCbGfEAovUKkUWNfuomnRldO+WQgOvJvz9IfYZj0sa+gTBp2djRuCY78O
         nwxx1XB+UBvNu7uhn3fYJM38zKz19mtK5mAaaywRNaiB8tAzj2am+F/BVzhiTNiELgTF
         bamYJdzwCY3JrkDnhUU3h1LYGLBZM1jCxnul+ibhD//nFkPxfOWdweiSWi/iJsmlCl7S
         iYHEsPCfXSfABuTtMZxyughMC9JnMSLqNRTnSsAUtMrs6BmRCYL4Cp9LADeRopLeq5aG
         IG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767174164; x=1767778964;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RhQC3hnAx6vo8ybVJwyWTzkkYGMOha8q8BXdXCtNSM8=;
        b=piZVZIhkptSJGO3ucolWHgvtCM0OX5o1kX37i5d498TzaD48nAWT1gciu5lIt/mLT8
         tI+lYW9FYH8WXfvXaPm0BbVnPWrhWWKx2/U0mVcmsya2iVDUqRUiTCwe7Txsrqci9j4D
         NnT8o6gfvk4rz46o1YrDDTvnb/LgCrcnLhNkLLExXImDI3V7D2mZlpgndf9e8EkJreLk
         xFJph/hY9H4eDVFxh7CLXGK/ywTmtxOMB5Dd7NbajqbQzgceW99Xp8G5YQ2f2w/lwIXy
         /yftsFYDDD1/ZGgjwVeXLLq5nhyp1DfWG98sJ6d+8q0YOU8uJSOQrfvYu1E1Tpkkf/Wv
         TwEw==
X-Forwarded-Encrypted: i=1; AJvYcCX2oHv5+rGQX6KBpn6Dzng4xraQkHMJ6h/OLKK11PeFh0Zxllx16UYGidq+Mu3dbqsKgqRTogd9ew==@kvack.org
X-Gm-Message-State: AOJu0YybJSLkXdJArM/nCJtM33+ucl1UaQLYiLCmTbd2vrERoFzAhNjt
	G/G5KeNLA6yI9rtOAKer1sfpBXQMBhRvSvpUQ70WE+T7grviibWUbmjv
X-Gm-Gg: AY/fxX48xZ9PZIiqWV+bd02v2En/jscd5KOOUqXm/2xoLXkMAKHuy0phEb/04WWqZOF
	+hllq7x0p0bU/nwy+HIW7vBIHGBlPLTiUyJfRzfgCakNZP7dmfMwVvgwWhp5ktQ4SyKRzVyqt1W
	cm47DutzRXSK8g1KxyyUp/2z9tcOyLstHA9ZZigjONQdXZtKACHt42y4+lK/xCKOBFY4ftN4x04
	4Hy5oa9r0RO1Zy1Tk+Rem4VDtsFzVjnOsa2jTknKWAHI+FTdpTgMm21y9IaijwkjgX5PWsRhKNM
	+2EItD9A7OQPXCttzzqREyBlQefwbNrqBjXoQYZq8BzObZn9vPEe8C62Duim+ov/qTkuaZXNYda
	r/xcClUtWhrZbce1m22Ny241S3ojzzycNbnz360ujpzotZBXLnIbNSXOOCVmdx7s1cIA1MqTsf8
	BFcch4dHDUqQ==
X-Google-Smtp-Source: AGHT+IG6BnZXWofbdukBItAk61uwrC2j9z3+nQpSf68E/xI1yNmjywUHcnARSPenSAEDWkU1hfWn1g==
X-Received: by 2002:a05:6402:2356:b0:64d:4f75:aa28 with SMTP id 4fb4d7f45d1cf-64d4f75adb0mr30963979a12.18.1767174163924;
        Wed, 31 Dec 2025 01:42:43 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b9105655asm37568985a12.9.2025.12.31.01.42.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Dec 2025 01:42:43 -0800 (PST)
Date: Wed, 31 Dec 2025 09:42:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
	david@kernel.org, ioworker0@gmail.com, linmag7@gmail.com,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20251231094243.zmjs7kgflm7q6k73@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: B7BBD140007
X-Stat-Signature: z7cd7kjy8oe1jze6a7x5ac766uan7394
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767174165-178625
X-HE-Meta: U2FsdGVkX1+oLfCNNGxuoGNQLAbMUHW/1AKjDqbkYsgpy7eflGpPE7CMSirn4pOLTJFzZAQ4Gf8Oae23Y10uHtLkPAzaFp5kNKQPNRB3wCwS8xZT64hJ4JcYlqaG/u9zDvA2NnoyPK8UWcYUX3yL87tqjmsndn0q5LEHUlrnJUMdt4iXL/MAZ0tzHmveg2j9M9aXYsQGMZ3Bkj/+L9veNwvRFFfCVcgE91Nkk7n6dYpcj+nbd3dh3T/9c8PHnfXcPgqXRIsB4A8H55DlFiAf+GVRUniJVJjpvxH6cFyzzDruGDW63TtCpT+AIt3CLCoWdYxsy/KDs/eZ7RTn/v83aXFObEMlTNKYN/s80Ln0C6iirBjaTbPutNFjQ5ax8e/gvCGFohjk/geT67OTYAMC20qxdqNv7HzRGgUlXZEwqek8sOoU3TPXf3xJePsN7nsY3Qkq2ybPUxPytDGIj49buPYYUd9SpXMEVCfyAhYi/xz3nuz+WHev/z7PuvdiROY96Qm7exmNMNcIaSv64rh7poaglYtbuAyrT8iKjRIpnH5NmWydIaK6w1TARzSbRgMP//Vmxt+nHbgGctsXFHzMFts191TToXW72GwyRUAfk5KnXoJOUytvZrOQm6jOrXC/Cp/BqjvOqUSyLnYXY+CwIm0X5wVU/ulLkeCWgv26hHX6NSXFlPWrEfncPbPa03jvihN4wK+FGH9UOnjSJ7rmuI9a0z1DS/g212zm4MlIEfSrc39d30AVoXUuDt5s/JJY5K/jEy447glKBSvDlnawg3ETneqE9ilf+sJGtGwNLZIZnq8bvH7FWdkUJqHlfy8uki2BQ0PJE2/lMJdnQgx6F0SkpZ9FsUQZZ5F7vuV1TW7Y+wB2pG18e5orWfzl38YyM5ldr1lP6xiEV8fmWY4LLuDDMdHtLMYd9iWJ787h2wgvG8PyBGQNbAhM+pCNSNhhQAqHklEG1JhmCUUJfWj
 sJwUxi0R
 KzawV9p174d0OG4DRjd5+qoDe4/7FfxPJNokvVJ2rjwgochjjf2ymaDsk7ZP63BOn3RvTx6CqXSqMphwGTzFyH0kOIl2OeFKnrJWKWwL+WqpEpBVNQJQw2mkblC0ZzYceLBHTLxtx8LijnHj3oFNA7/DyZpFOs7yvv0ws5qWheSliS/Bt9B3ScV5RL7jhjh8eG5KGc6Rra3mz4uEFtLBtrciDVYQ8leKG0QRstM8lVeYtA0RrspnsYZd8+M0crxBz0CZoIXVnJt5ido37y/JBKydtKuGJaHFJi+iub1ojwuGoBWKJc73TraUdl76tGWsVeZUGYgJnV4UX2quQzrUl12SI/mQmguc7CWmWbeG3v6z3mj3EMXbUpVXk/qtaQnEnvELK2Dh94ggcG1yfwZzKrj9DRodz8G9JRpapexzCHdNtc6Ua1OxD8OwaeBhe5Qj6UGkmeJkMKWtSr6wWLNYIWHokvtfspabo8/SM83OLQrRRVKgxV9u38c+K0TZSzbZZnfTg9ZkyXMhZj6N2fzFhYM8lM/3U8W/GTKyMvn2R8HOV/gVcSiDfZGMoUTKx0+FkejyZ2QGIxtRYFL/gfVVp5eZJJVgla9J5MQ3MrDR80Bz6i8d9lu46f5T3wZNhSa3EZ6goX03nyNkUrLk06lBP7u1PRsSqlz+iJfKFX0SZRNgBgWXtNeKUC5rSO5bSfUvwO0CTgIOW3qqfWbA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>From: Qi Zheng <zhengqi.arch@bytedance.com>
>
>The PT_RECLAIM can work on all architectures that support
>MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>MMU_GATHER_RCU_TABLE_FREE.
>
>BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>to turn it off.
>
>Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>---
> arch/x86/Kconfig | 1 -
> mm/Kconfig       | 9 ++-------
> 2 files changed, 2 insertions(+), 8 deletions(-)
>
>diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>index 80527299f859a..0d22da56a71b0 100644
>--- a/arch/x86/Kconfig
>+++ b/arch/x86/Kconfig
>@@ -331,7 +331,6 @@ config X86
> 	select FUNCTION_ALIGNMENT_4B
> 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
> 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>-	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
> 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
> 	select SCHED_SMT			if SMP
> 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>diff --git a/mm/Kconfig b/mm/Kconfig
>index bd0ea5454af82..fc00b429b7129 100644
>--- a/mm/Kconfig
>+++ b/mm/Kconfig
>@@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
> 	  The architecture has hardware support for userspace shadow call
>           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
> 
>-config ARCH_SUPPORTS_PT_RECLAIM
>-	def_bool n
>-
> config PT_RECLAIM
>-	bool "reclaim empty user page table pages"
>-	default y
>-	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>-	select MMU_GATHER_RCU_TABLE_FREE
>+	def_bool y
>+	depends on MMU_GATHER_RCU_TABLE_FREE
> 	help
> 	  Try to reclaim empty user page table pages in paths other than munmap
> 	  and exit_mmap path.

Hi, Qi

I am new to PT_RECLAIM, when reading related code I got one question.

Before this patch,  we could have this config combination:

    CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM

This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
is semi rcu version.

I am curious could we use rcu version tlb_remove_table_one() for this case?
Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
there some limitation here?

Thanks in advance for your explanation.


-- 
Wei Yang
Help you, Help me

