Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E719CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 19:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6788C6B0088; Sun,  7 Jun 2026 15:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602516B008A; Sun,  7 Jun 2026 15:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9D06B008C; Sun,  7 Jun 2026 15:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37F9F6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:08:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8C3D91968
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:08:40 +0000 (UTC)
X-FDA: 84854053200.20.FB9F39D
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6338C40011
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:08:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hIB2Juxo;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780859319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okDVFSTv4fCBjivazCm7I0myKhLAMvL8UQn0109STco=;
	b=OBV9MpRYBoSe/siZm/b6hGUUP8EG+I2bUovhfEJsLLMQmfK0Thj8nzpC+9OOXfu4lvD44i
	T/xLM5cutiz5yqhf7+ZrfcKK1uHCAXeE0sH0wS113k3rb2qx4MaNcE0cV40AyhAO5JPeeC
	p019SldWIVIRR5c1Geyrxa1kb3LqlhA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hIB2Juxo;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780859319;
	b=BVGWrMJ2BbeC2rkx/V7xMJVzrJqri4b+hE7382950KGOV+NwLbyg3zaLv9eFCQ1ePblki/
	Fm3+M61d/adiuoZsprJgyuiakBnrGuoyWcc6V2ii+dZsKd4LNdeAd/CMBaxNXy/H9xhMuf
	PzwuECEFmtvF86mkJHLQC4g24LYO3tg=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C062540E015D;
	Sun,  7 Jun 2026 19:08:34 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QAl3fNcanhlf; Sun,  7 Jun 2026 19:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1780859304; bh=okDVFSTv4fCBjivazCm7I0myKhLAMvL8UQn0109STco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hIB2Juxoi41C2nak1bGnPQhU7XE0vXEQwAAdlVdQl6oQC2nQpTxiq41pc/H3MEudq
	 QYYtfBSnXLtHzb/dHDTUOKEg7iGTimpxsLk1xXo+kwOg32DpNY/FT061/sNBoPBVBL
	 cjKZBA7wT1A1Tml9E7znkNjiw77/0TN3nDQORozxFEZtU485QGNTJXSGp4MfSPCahi
	 fg86YTgH44T3eMOPorP/J/ozHp2iU0lPrVqxWGldTSu3iIUyur7ygGd3twJrSf0ji5
	 LDNWYI0LLHyHdi0aXerenDTEIlWbIaFImylW4HpA4dZdpPHmHP0ij1NSIbkQxA1Pdr
	 xjcfWpTc/mMuZ/wbYs8KtHM5FiT7s5bgK5vqyl6ST5orNLZi4ayT5gahAMViGlEQ//
	 7r3iiYFMKGQNOhbgfzYwFp1qbsRrVrQeiW6wYbJvB3iCSZM4tzrJOBcVjsoPP0LPrH
	 Nawz8/Aj3W2Z36cIfYNasDgBLnq5b2T7cBPPev3Lmd6U7/whVUMoKdwzTJjUIz1vvp
	 b1rJQw21Q1syJVlgPuEdFRQYaGoxYlM7pvWtL94i8JWxHHzRGhXmwrnN1bh1RPRBsh
	 v5trxIa/WyUaoUuAHOsoZmHIXpAUe0+MFryTvGDyRq5/kS96++KAsilyB4y1eYze2e
	 vhRusUz3/6YDNd6PjNAxM2Ns=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5307B40E0031;
	Sun,  7 Jun 2026 19:08:08 +0000 (UTC)
Date: Sun, 7 Jun 2026 12:08:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
	dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
	mingo@redhat.com, rppt@kernel.org, tglx@kernel.org,
	linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v4 6/8] string: introduce memcpy_streaming() helpers
Message-ID: <20260607190804.GAaiXBlGO2eRcfs1oB@fat_crate.local>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
 <20260603080152.64728-7-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603080152.64728-7-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6338C40011
X-Stat-Signature: hfcuq6w7md4cc87sfwsaik3gyrg6pbzu
X-Rspam-User: 
X-HE-Tag: 1780859318-708099
X-HE-Meta: U2FsdGVkX1+BCZoVAnTf1mfy0RVX1LRgs8/hNmLopd4DeWTgVe4KnOggpn+zCWmdiyL/VV9rGg/KrjUVCJJR6FJf7wfsvEiFdUTkntNZ7FW2xIoM2GBV1AponYdRAYJfGjFIeZKA+8UB/KHvdAylH4K21HHZ2LzcRofoIwQInU+gAfnJGmbo6VeOVDVM/dTaULEI1TscrgACCt1AmApi1YNtks/4yOyQuq9X7KgmenmvAdJbaum1HsqCdzzHvz8LZlIljpBcUq5j9Rh5F3KnPQmYNis+vR//io8efn/xI+tXCgRkCX0UbiwEXta1tNsBE1mYYM8qgAG3Bb9OI443kuj5+Khy9FVBZWui0c0G0nTqqqfGWqrhDobGRMCgqGmwCSVeKL97IchVQosUOaAPCIotApATSxHrcXrTvVUl0TL71CLHsDcFVXO2LZ8sxVAdt9Hif1hxy/p0rnZrkoz++CeGOs6FBUlNAQDrSihkHataA6FY96X3RJt0L1GIuBIOT1BzFh3hN6yELXmdHP4VQAS0D71V4sJuj6afTTau+LKHVnE5ll6AGdAafHNXBdTwx1jiH2vCnn75JSsmVY4q+zst+3Y8eSFPM4T3UURmFNvUQ4KvYFiWRcZHUo/cadov9ijbDGYUgawik0SUc/P3aQwTytSC+Vo8mtl/atEA8e7mp+v7EzojPUeemOrFP4rmETvthsnuUcsbgzzUV08wgJDaIrBG+l5a7UatI0yOhQb6/t9UIn1fIBAHjDJWJLztoViBliZ+dRwfm89EgPYOVfCSlfyUl76qALT4NOZG+46pqxk5tzccihQ5bPAvCkbmifI0V3ecYhZ7GUXMCW0KfarA3JTHjROmoiwZzIu5GzzSuCQVTl0wIP/547aKCxA6v7Hxp6+lkPLxQN3A6VvFedSSHeT2t9h0V/uZ+Pn0icXpIDCH7lky5Lh5yb88IWnZRTfhcvCqF9xfczTytp/
 4wbYtBi1
 7Llz2qQAR77/+9kYCaBN5fvbSeT/EJadIJ3/ixMv3O7aRrHpMcm/3LPVRvAWWne/gaesS252UNyhPYeVG74JPmxfcnWMW3QrdcyBglf8Bww5IMbksgQHqw8BjEkA5IF+3gUXtARaBPy1SmPRZPZyvb5rse4D4SOBkbcQnwUeJRIFH+gHbuzSBo0njcNd05hiZQZSS7A+9naE8Hm78MClWuoRsSkz0WlUnQU7XWl+AixRuUMZBrmMKiO6/WmJmQ+HBMWypWQDmiey2K6kFTjaqMPU06yP+NBHBC3zLPvn3OIWirpUAwKi1Ynp4dJgLYm4KvYLAzXpZOT8P+vPPofZJSWI1PwK/Rc4zKfjJZ3G3hzkktoP5I2Q0QykBLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 04:01:50PM +0800, Li Zhe wrote:
> Introduce a generic memcpy_streaming() interface for write-once copy
> sites that can fall back to memcpy() when no architecture-specific
> optimization is available, or when an architecture-specific backend
> cannot safely handle a given transfer.
> 
> Add memcpy_streaming_drain() alongside it so callers can separate the
> copy primitive from any required ordering point. On x86, use
> memcpy_flushcache() and sfence only for aligned transfers that can stay
> entirely on the non-temporal store path; otherwise fall back to memcpy()

So you throwing "streaming", "non-temporal" and "flush-cache" wildly around
here and this is adding unnecessary confusion where it shouldn't. I'd suggest
you stick to "non-temporal" which you can abbreviate short'n'sweet to "nt" and
that's it. Keep it simple.

> so the generic API does not expose flushcache semantics on cached
> head/tail fragments.
> 
> Callers are responsible for invoking memcpy_streaming_drain() before
> later normal stores that must be ordered after the streaming copy.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  arch/x86/include/asm/string_64.h | 32 ++++++++++++++++++++++++++++++++
>  include/linux/string.h           | 20 ++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> index 4635616863f5..aee63108577f 100644
> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h

There's arch/x86/include/asm/string.h. Why are those here, in the _64 variant?

> @@ -4,6 +4,7 @@
>  
>  #ifdef __KERNEL__
>  #include <linux/jump_label.h>
> +#include <linux/align.h>
>  
>  /* Written 2002 by Andi Kleen */
>  
> @@ -100,6 +101,37 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
>  	}
>  	__memcpy_flushcache(dst, src, cnt);
>  }
> +
> +/*
> + * Only map memcpy_streaming() to memcpy_flushcache() when the destination
> + * is already 8-byte aligned and the size can be handled without cached
> + * head/tail fragments in __memcpy_flushcache().
> + */
> +static __always_inline bool memcpy_flushcache_nt_safe(const void *dst,
> +						      size_t cnt)

This is checking alignment. Then call it that.

> +{
> +	unsigned long d = (unsigned long)dst;

Useless.

> +
> +	return cnt && IS_ALIGNED(d, 8) && IS_ALIGNED(cnt, 4);
> +}

AFAICT, this helper is used only once. Zap it completely.

> +
> +#define __HAVE_ARCH_MEMCPY_STREAMING 1
> +static __always_inline void memcpy_streaming(void *dst, const void *src,

memcpy_nt()

> +					     size_t cnt)
> +{
> +	if (!cnt)
> +		return;
> +
> +	if (memcpy_flushcache_nt_safe(dst, cnt))

That branch can cost. Why is that alignment checking so necessary? Why can't
you simply DTRT by handling the misaligned parts like __memcpy_flushcache().

What does this bring you? None of that is explained in the commit message so
why do I want this patch at all?

The commit message is basically telling me what the patch does but I can kinda
read that from the diff itself. What it is not telling me is *why* it exists.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

