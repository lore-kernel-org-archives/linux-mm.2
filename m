Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B143CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6C5A8E0022; Mon, 10 Nov 2025 09:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E440E8E000D; Mon, 10 Nov 2025 09:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D594D8E0022; Mon, 10 Nov 2025 09:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C26E48E000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:50:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7179252501
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:50:02 +0000 (UTC)
X-FDA: 84094982244.24.15C31D7
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96ACD1C0009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:50:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="K/mrha0b";
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762786200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuV15cVIkOZ3osUBoMrFPeh8PgM7VFfcDiPWWGwwe8E=;
	b=lOYPCvA6hvtohaOWHV3zBzQsU4DdqVHQmjZBzg0FLmGgMeospOA52cxBmd2aR9+zdJkBnq
	7ithB7ZV5jTLhbMldqBl6ztaoq3seiLpgImW452sowlc0puHpCRY8ule0YYBouhILP88qN
	gyKH27gtnQQwuOsXMuisY7WVbg/3X+g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="K/mrha0b";
	spf=pass (imf21.hostedemail.com: domain of elver@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762786200; a=rsa-sha256;
	cv=none;
	b=RgK2X98S3kvcrGDJ3T5k5QGaPk8LDc3l1LxA4ln44zMAkcUKK5w87RsaZso9rUd+U76tIq
	0lItICVDgnWZQBt1J7rqIGeVlxehdlP/LnyZW/LvsUR+9X9STu4A9V3IKeQoVWte+zPio/
	Nt78OZ2IUKEyXorFyDnpDOcS3/G9Mw4=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so3699460b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762786199; x=1763390999; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yuV15cVIkOZ3osUBoMrFPeh8PgM7VFfcDiPWWGwwe8E=;
        b=K/mrha0bK++07FxAEv0PI4J0L3bvRVUCeNvpaqGiVE0rf1nl3HqHglX+F38TcPOOdV
         y0Ky3hS6itNw3YXsUY4jPeq5hOb1mELy6C9rYG0V04jajBuG+lijUjWfj0/X8BTBN5Nt
         ZOxbACz4sbJtHrpzWiTFkZfcSpz+SIyVTg1vrlBTg7HF1rRuv7N8hh4vrTzLQpY6rFzT
         DvOwuzEFExfdj3OC4oXOmaeCk0ZAyA9N1qeeqHXEM/r2zXSYcXnWNpuHtVmj39H4zKFI
         N3UflGLEA+Im9SSlD4JOg3FxLlNAjnTva7TSUJmCqKTe7pvAaSzrWZi6Q5ahlt2eaRr8
         M3KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762786199; x=1763390999;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuV15cVIkOZ3osUBoMrFPeh8PgM7VFfcDiPWWGwwe8E=;
        b=gNIgFH8FM5QERs5UqFOBdcIuixhdym/xyVOOFAK7DJXtN1bxnN6UWQ2WD+57t/ihFZ
         vaWlnjkOfAFWcKWI8tAiAiHEg9yj85oTw/3/rihzk5tytvX91bsMWmBw/mKrn8WVigIY
         ulVGUmIb7fsr/JvzJvJAuTNynBtHk7/HeQzBcf14niWmGG54otwvSJ77vJCT77oljuTM
         ssrpfDtPQHxsSgt0GBWxbZ2HDZvI8U0+M6TEiIgauLah97dXqEAfSk6GGYTK7ziB01hb
         umoYpb+Y6cn/6JnlDjhvM4btwYx5n7r2cYqYWXt9/Bk70m9hxBo17ydg1vSqgZvarMkD
         fEnw==
X-Forwarded-Encrypted: i=1; AJvYcCVCgEmKFAo1e5Ivm84qsQ9rnEislwk/HSUPwxt6NnzxF3+U229CjJLsd8VCy41/HEJKVzx5wdIBZQ==@kvack.org
X-Gm-Message-State: AOJu0YwK43dbx69sg3NMu9XI5FK1Yf0TBHUzYRZBiDZ2H+oQdtq7eUjb
	jEgqUcWCk3h/uUrdgZZHLVNqP/m0KQ0mv76coITPH6EdwjabcAIJEUzZfCqv4UlY+oSGAoSfgs/
	C1yUTjptxQheP+R3UUhKjNO12TzG1PsVFCvaaYiDR
X-Gm-Gg: ASbGnctHHTXIDENwmljyVagXfm3yy0GWgysPmCdA4iFcnEACh6CJpT8WHrDXUcqRiMa
	vATKtJKzqQbHbDTCTL0Xn+F4JvoMhmWjL143f9VwFC2CeWlhJC8yDAzE5T1bScVnCXXRpFE5DM8
	0QSJqbDiFljaHdz/LeEM/9yK8nshNZqhTz+cSoQ9otH0kKb9iZenPOkQFqV7tQUe6Bwze7i5E5t
	lJ95UHOJnnHfvuZv+jHuE5vXkr0AgV5HmBpbGw4xZFQodu/cdPl6FsEtYw2WjI4Juh194p+epsg
	yWM6eP7Cb6m4hZu8/4vbkXyWr7k=
X-Google-Smtp-Source: AGHT+IFJrWpsYMgqYHxsl7TDahL4sWC/rojvNE8jvjvqAW1DXIbEkhegStBh6RAJqXTedR75u3LJC4XuuR5ASPiDRjI=
X-Received: by 2002:a17:903:2f88:b0:295:24c3:8b49 with SMTP id
 d9443c01a7336-297e56cf5bemr117461485ad.46.1762786198920; Mon, 10 Nov 2025
 06:49:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <81848c9df2dc22e9d9104c8276879e6e849a5087.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <81848c9df2dc22e9d9104c8276879e6e849a5087.1761763681.git.m.wieczorretman@pm.me>
From: Marco Elver <elver@google.com>
Date: Mon, 10 Nov 2025 15:49:22 +0100
X-Gm-Features: AWmQ_bltIHaW2m2Y_rXOjdB0rjwB0avPjx0FCrIDnvZhp3yD5E0mxdw5HHzg9_w
Message-ID: <CANpmjNM+ot5A-pRLhV6Esn=QvCeCStd9fG_pgwrVA=6pxD8aqw@mail.gmail.com>
Subject: Re: [PATCH v6 17/18] x86/kasan: Logical bit shift for kasan_mem_to_shadow
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, pankaj.gupta@amd.com, glider@google.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96ACD1C0009
X-Stat-Signature: psbafc3sj45a6em1wid59zhxzcq98nns
X-Rspam-User: 
X-HE-Tag: 1762786200-78688
X-HE-Meta: U2FsdGVkX1/tVzNixooc6/FHqeVqwbIi0BiWL+3B1/2C6w454ZlHDE2kuUdaccJfILbRT0aBl/8OY2TLaSNqWwJt7uF/Zh7vbINEq5JFEOXhH7xXTRywoLytqd0ynMlAiPza5qXAKVbj4L6bXySOUsYeMjeHBqomX8LDYhAOaAuQyi9h3NL4ryuidh1lAbKM8xD6DODO0BEfyCsp9O0nSpvF9773AW77NvBw/DCjo9Ea8Brol0iXvbrS9B5zFOLbDlFEda6hrytf4pRwFz9+ckH0qG6A1a2UDFD+zQpk5jQzM40kAsjzXd7WqpB3qjxBnAIobVw1jany+bNb1QVMRRy52e05/TQc+TXVWWHGT3wiVh+CFGvpfaWmN5w5cNnc0p1XqdH+bD1QlJDxsi7BSEsyB/qAlq/ZmtwcdVVuFmXdfgk81yXQJU+apTgUp19Cmmul4e/8wVDI9amAD82SGSRJEoDjKdAe9FO5CYVCeta4jNdnDSTGZr2jsuZrN6iINLIFgRSSlBn2327cpVsWsqOcfrbCcDiqjVuQXiGivYS0J2fgj8hpUHw1ZqjNbWHuGgcGiP2BD5Ubhbxlp14602RS3vtOh5aUrzG7pzuQTIaBPoj4McB49nNzn+UhhR2jus431FDZTdFSr7msF7OzADsIw0/KPW7B0I+4VSJFn1c5ezjl1K31PUG/HjtLt3zjpKzawofg6Qd1bip3Idr5UUMyszB7s7hj6CfYs4Dd4MxYAtfKyGTaMLoKVrvFuA5ZwDuHlALvBEFncHgCwh4hnWTndgBpXAh90yLLoeLoOaOOWPcb6Gi4r/s8rrc1SmH3jL0scUbNaQmYAdvWlWHtorkY7bu5Ks6/05EomsMJ3mGdTmz1XN9lUq/NSR/tCRmjbue9lcPiRtcBUZn+xvle5rLB9FUmZRwsIBk5IFEwCUrZmP7rr3Q87haPwOsPIa8XQqOjGyHyN7kErQ/Gqcb
 l+Esyusu
 w+lniyq5rLSt5PD7iFwWC/2VOcLUecfNZxQhxvb2Gxsnuh2wdiUFGWqcm0VM9okjA+Iul9jzOCaeK0CYYMvhfmjUCFPdyWa4OC3YuDhLqJ0VpFU+PrQ3C1SkSYe+uowmwe3uVlqO5dcAVGpeLiVOaAMbF/FCG7ujKLAg2pBzZ2RsZ3CmUV6/od16WWKf0BqLVWbGiacg3f1tzda8Xqqw0ONKEzi1SsF8TjfBQxeD3V7gg9qRip1fHlQWTydsRgVmrLY84hblvgUO8aL3GOgFU+AyknDXOPyyv9Xw6uLitX/Ffgqr8kpIOcOKtPwpEsAzC4i6g8TGfI6FgtshH1R1TWO1VRzIukdKa/IUzGBIN9YTdLOHEp0+C3xyvc9BjHrOvOjtm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 at 21:11, Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> While generally tag-based KASAN adopts an arithemitc bit shift to
> convert a memory address to a shadow memory address, it doesn't work for
> all cases on x86. Testing different shadow memory offsets proved that
> either 4 or 5 level paging didn't work correctly or inline mode ran into
> issues. Thus the best working scheme is the logical bit shift and
> non-canonical shadow offset that x86 uses for generic KASAN, of course
> adjusted for the increased granularity from 8 to 16 bytes.
>
> Add an arch specific implementation of kasan_mem_to_shadow() that uses
> the logical bit shift.
>
> The non-canonical hook tries to calculate whether an address came from
> kasan_mem_to_shadow(). First it checks whether this address fits into
> the legal set of values possible to output from the mem to shadow
> function.
>
> Tie both generic and tag-based x86 KASAN modes to the address range
> check associated with generic KASAN.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Add this patch to the series.
>
>  arch/x86/include/asm/kasan.h | 7 +++++++
>  mm/kasan/report.c            | 5 +++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index 375651d9b114..2372397bc3e5 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -49,6 +49,13 @@
>  #include <linux/bits.h>
>
>  #ifdef CONFIG_KASAN_SW_TAGS
> +static inline void *__kasan_mem_to_shadow(const void *addr)
> +{
> +       return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
> +               + KASAN_SHADOW_OFFSET;
> +}

You're effectively undoing "kasan: sw_tags: Use arithmetic shift for
shadow computation" for x86 - why?
This function needs a comment explaining this.

Also, the commit message just says "it doesn't work for all cases" - why?

