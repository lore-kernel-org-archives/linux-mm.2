Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CACCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FB96B0096; Thu, 18 Jun 2026 13:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20706B0098; Thu, 18 Jun 2026 13:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A367B6B0099; Thu, 18 Jun 2026 13:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4086B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:09:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA149401CA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:09:46 +0000 (UTC)
X-FDA: 84893670372.18.F30A4BC
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79C0040013
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:09:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Jn4lzMSf;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802585;
	b=jyRo19SuOwOndGF0afToq13B2ZyoPioHnVGu+sAdg692tUL4TNo8PKcc5ejd1WU1CbwUtk
	e+JI1/ADpOLF5h/Cy8hcNGeo4j+bZ+SZdy0LAZ9zrX4wHTK9fdulZIXUsfb/nf3gEbUz+C
	RqrP4K3p/bPfnlzcFwC2VPwazI/1Ei8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Jn4lzMSf;
	spf=pass (imf11.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy1iY7sl6/2Sjr/G/dWwXWxqs32V/TwIOK86/jZYZ8Y=;
	b=x8mwXvuhAWwi8lTnKnEvNdZ4YHF+u9bIMqeykNg8zyOAzToH/P+TSggSi01Wu78t1h27ga
	quBsu6rZiGCciksd+SoQCTQEAETOO9zr2OAMw/2Pvrx3YqVVcg6d0Fi3RCqORybRYXk51p
	Trf4TYXCBI94pZJfjM72UTXcg6Ybo+E=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5B82840E0287;
	Thu, 18 Jun 2026 17:09:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 66VyEZMRCJp2; Thu, 18 Jun 2026 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781802575; bh=hy1iY7sl6/2Sjr/G/dWwXWxqs32V/TwIOK86/jZYZ8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jn4lzMSfz9qxGWiDiy7D3IlfchOOE3WN5eiOfV9+VM8vD8YQEB3Z/aJVIhL6/AKC8
	 aegt/8l5KXCzR3ITfuK5fpFE9wrfVG0IIvxyUNfmTnVyxCybWMoAvXoXj+P3wEgfiw
	 274kDPCu3kHPi/sX+l8lcttO+G3Uocl8j4U1fwTsFIweNMm9GaPwW0FOAUzleohuy0
	 7Ok0e07ReuV1+TQ3q7Cp/UpYCH7kHbJY412JuPav+IjbvCpXVgBZp8eMkc2wmY0/YP
	 Ekd6UWQyrEKOtBLsUjtLMXz6fA9WPAvN6iIyFlGplgoy4wKgdqVDh/bBCt8z3YrAPy
	 msFckykQCrayfA1X15uXAAqxz2xXFMOQQ8EV0ydbBCVc49H3PebThmZszAks9smhRe
	 2SgB8I9d5+1YUDy9MEURMB0wKmDzHDWZN/kuxWsvTCeWga3HgkgMg4RSMT6b1sBmGc
	 omdo53zdjfuqJ9XnJgE++0qJXGjaMawYtGzZdRzC2/nXFPgePjX/aXrGxd4XFpFUgf
	 993gGw6PSXEnde0+Q9AQwtCycg7OVxkcm3pssUU3eEXB+4lnztTDjMwLzLNckqmPXQ
	 K8CutW3K6oKHQq9Oui85W/c/3aAxp/jY6VqhABYSek5Fje8MD2DA+KtIkJW09zXuGi
	 wNcG9aEzRIEe/zhxarjR/PgU=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0BCF40E01D8;
	Thu, 18 Jun 2026 17:09:16 +0000 (UTC)
Date: Thu, 18 Jun 2026 10:09:13 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
X-Stat-Signature: gw38qdnos3upafq9caogoq43nprjbn8g
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79C0040013
X-Rspam-User: 
X-HE-Tag: 1781802584-993191
X-HE-Meta: U2FsdGVkX1+MgnuEdWzEPC5SE5DGe5dvRyyZdd3rpy3t9kNxXY4eVt2ltfxS8IH4ueSovWom6y2aNHumu3iH/eYUzpZocDkjjrybh7NJK4tFJviTzaHjmq64BFvd/QSKkTrc28DpJ9gv8NaH8d6iyVOEnuDD/JjRNMF2jpismLJzyjn31OrQ2BjYHyTK78oqcyqmz6UMRb+0HU4CzRejlzovsqmR6eM9cg072howa6fgMV46k/vuB5h/fRkAmpTwLsrXQ6Frlub0mWmgQcm8Zxr35t3WgGmgph8MZiQdKbzdqeIq9PWfhXecKJapktNC1VOG2Zwr7dThi7IEx8aYRMCZVBg/MrspizactiKgalBVD2XsEZiQDSF9q95pOH9910AEugK5xJYhHI55Akcrpihu5VIqPMex3wBblpIukkX7xyQFB5HHgFiLKPnAFCXnMDzCkDVJj/S2Nge/P1onDAT2rYO4DQQFml33CB7C4xwbgw+4LXsHiyChJyWasmxZ8HgrH8R59Hgcicm0tk+Wr30AU9hM7iOrtRyXnvWZYkAtc8HwsQOuIXFxlF2Cu9u8uYDPA4Ojg8yjWkVkOceNsfLXgPqJZrCr70zeuaky/czEGw0NGYR+X6xY+4dXdv3QRwTnuo2LCyZgFYySRpxumlN8OqGp6N+3I8Od1VPZqVKlwnW5rYEFdlREoHlO/yieZRUa7aO3yCqMz/LYByR3Q1riJlrcDpcfsWQ/0WMMsp6Ekuh51dT0vqJ4YhaRPydqi+cxIhV50HxOicUnZQzp065CyXzp/01ciazLo2YkGzLb8CodMWsQs5NReuzyveXj5gmOl1GHPizegc7MeBgU6HVXj8LohVBujrKw2t2zsMgKZI65/f2anVSmzpHga/jRl1b4wE4LgAWrqpb5dhN6nSixEBw8dR+66dBx+oGwPbSd7EH964mMg3TfZIRyrfmdtdFh0hqJeOdNTXc4eiz
 lIg016dW
 yymB89mlmrzva9y0lHB5ym8fgtrwN+w69vjy8MQ/QOZ2n0bs+0kAUcOpJnFAQtjDtgX+c9Lurmli5rEx3qZrM/wCeHVd6+6Ijwdu+Aw+NJRsKKaQVvhmeawF/bLrAxZAf2/fsmc7iVtQozART252exHFNWaMfb2YoOYjOTEQ4GZgdmCHIuthzc0Yph40G9DIxKoy4wu5okQBAamIXe7foygNDnZ6oq1srUGHIp+Lw7SRieSThmRBuFrfD9ig4AviKRGDjpS1bmXW5YepXUZlFwBpI7CXRCd+iVH13XWBFyXTIFj9NCEGLU/f5AQJm8b7T+OB6H51x8o12JtQjjeFKoTSAvN26l2r9PHg1Fjvw7dF+SMI+61bRcyYLhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
> So my question to maintainers is what approach seems best?

The CPUID stuff is being rewritten currently and it should address your issue
too. If not, then we need to rewrite it better.

Can you reproduce with this set applied ontop:

https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de

?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

