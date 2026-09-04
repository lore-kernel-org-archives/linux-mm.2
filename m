Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD64FC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848776B008C; Fri,  4 Sep 2026 05:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8D86B0092; Fri,  4 Sep 2026 05:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711166B0095; Fri,  4 Sep 2026 05:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0B16B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:01:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4082A0F2F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:01:13 +0000 (UTC)
X-FDA: 85175485626.13.4626B1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25E6E14000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:01:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH8R3oTh;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788512472;
	b=H8AvuGSJlfWrvffn49KoEAxyhrhMQYI7TC9U37X9FIUgo3QuuPFjone5QmuzUa4YUf7sAd
	6xuowLse5bMuCnKSM/DrhT1+tMJLKt1+Ga311k0+Zs4e5tyQUrcVNO3q/2745YLpiaJsvH
	sjf5M+yk0KSOvKzwOSxSBikPRUYZ8So=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JH8R3oTh;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788512472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NS43r1NlPHoz3Menx8qLeACzHNPCiAWFDDBQZ2Ncqlo=;
	b=YJSB3kIIkMKL9aYVC5cUysJIo0yeDA3Znx28XvOZxOG2mT/0OtleuCkM7p47oiUCnlwlxb
	bhjkP6PesIpONp9C06nh0bs+f1bATGEqQETzC1mCk7/jvNlDefuvJNio/CksG9k26wxCXT
	HA84Q05rk2z77NyRVcwSeUNKXaVAnOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 905D560211;
	Fri,  4 Sep 2026 09:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03841F00A3D;
	Fri,  4 Sep 2026 09:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788512471;
	bh=NS43r1NlPHoz3Menx8qLeACzHNPCiAWFDDBQZ2Ncqlo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JH8R3oThTjf7VbgyDYAPuSERILexkhuy68q6S1R/j3k/xU/SQ6pKR3M2STiVCtoHB
	 N4HPsS8DQBcHTVMRDKMixaJfZj6KsdUi6flqlVHchSUh+EefEVewz6t6s7WtAMBOeJ
	 Ne/DDRDYmPRQsrF1gzDzU68tIP+YLcuaGzUbmyY3aIASIqIJ4ih/2x0Z8NuR9CSIMx
	 DbsFfSOtbOWzQP6VioFxiuQ4PjtSlyVmMco+ejyW09TzSDfxc5DIUggo2qelo+xcr6
	 EPF7LjD5kV6at2CbWtfaDYmAXt1icNVl+5k3xYCyClty41Zpigub4q/rajGOS10E/r
	 a2YCLFTlvAlIw==
Message-ID: <497a85d3-e062-4930-bcb8-c86a8205e7b2@kernel.org>
Date: Fri, 4 Sep 2026 11:01:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] slab: handle ERR_PTR values in kfree and hardened
 usercopy
Content-Language: en-US
To: Karl Mehltretter <kmehltretter@gmail.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <kees@kernel.org>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
References: <20260903203720.63689-1-kmehltretter@gmail.com>
 <20260903203720.63689-4-kmehltretter@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260903203720.63689-4-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25E6E14000A
X-Stat-Signature: iawn3be65yrqnucxhu11qu4y6h5ojhzw
X-HE-Tag: 1788512472-701484
X-HE-Meta: U2FsdGVkX18nKX1IGjYEvmBUbrS3p5//HNIAByzlENVTfHplXcb/1WHBowEB4lUp2uv70g5S0+g+PEJ5UZDE7wzShC50U1miP2Lgi6O818CxnYmAsI+oE0zEOiVx1nJWE7WrVC8/rgjx7EUklYEvA7R5sWK7BC4G/dhOceVz1TLUpl/w84t7/Pi9u4Tf38CKZyUbJP0wo4rUMAB5/+Jv6lbD1yIToVJIJNWq4lTY4fAT+FeCmRkAk6J6rSy02dW7mEcvzOn5/Z7mlAIFMYRHCORw/FoSzqDPzi0i9RsDugOBYZE2YxzqmQciq5sPWygWdNTxtvlU6zDELdqW7ZrsnZLTNkYAwgw0qo2FXKgQuGcWubc1vhpGH6fXe/MZ177ZnBx34ECUWcMLJVxORhy2RlZZFrYhrm4kq8sHr+CCjDnN2Ru53B8GoaX975TcK2KPNjRE2lMmvW3d/l3ZVIepzBmGw/cNq+og3T0iiOxI/jFqbPuAYZHbBG7YWJsRqQONhTkhwfHsjmvyl7obPrD7+HBxkPTTj4u0oYUPIJ75/Boklt6CXWfQgXmijbyEYa5QrbwBnyHlrrY7w3AOzotXhQRShkwo6HpfLlNn5BG41IqtuIHoTz3Es+4xCz0yaGqPeGe8X2ojSnYr5TcUG5kiJnlkYgFbWdQ1UtbCAMmdn9TArMcM+VEobHDOzSR6H4iiOSFbvOv1QaQSyp2wy7hqRF3J7kp4cVqWw7OX1gxHLNbvbLtELBuoXNKExvZi2oJP/QqBgji9irnzgZjAHEkC9yTIpl/g2PErZp5OZjW1Y7IEIiuhuZiZSjiFWhlbLTrQiotOQm07XidGquVfEcSHo+FRiGnSupNQratEBUvcICqB8Q1rmQdwWbVvL1pToy2E9Yvy7MUVbV/Coe+d29ubBoAMEhC0u++WRHtCea1qauHV8LH9iwK9MdZt0tfaDVffdYJFjA+cfnTQrBu3H8p
 dVDR7lRj
 6ekbPtI9IX00gKgpvsS7OLvR0BcT0UsFQfYuclViwdEWch9XT7RwBBbP6NC8tP4Rebjtzp1gROyDCSfbppgvGobVyu9Zi3fOMNY2BJ3UPckIB48TaJUP6aIGMkx1DBSIbl0CU6V8FgkcQOPgI1u5Tpoj+bIwmCD03HYV7SRv1rezYy2JetBcIWMrjUUSFwTBpeg5gzoZyqCooKziq3ezdvsikDAvFlQpTZPP4elRd4cy/2tchp2MqkwiZZANXy14Lm2mJNQK6Gx+XtzAOHhMh4tqeIu2XGHdDalzzQikx6/rX7ytNv/y5c9kWa6Tzo8ACLdUT/FhwB5NAc0R0kokhW7lZpKbVR0MAyGt/+82uCELjIER+A3fUEj4gjRlHXc4+qA0m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 22:37, Karl Mehltretter wrote:
> Passing an ERR_PTR to kfree() currently reaches virt_to_page() and may
> fault. Warn and return instead, leaving the bad caller visible without
> using the pointer as allocator metadata.
> 
> Also reject ERR_PTR values in hardened usercopy. Keep both checks
> separate from ZERO_OR_NULL_PTR(), whose exact matching is required by
> krealloc().
> 
> Link: https://lore.kernel.org/r/CAG48ez05QVn6_gQ2TBrRa1a_DWQoaSSYubUsu5YMWxx-gqMijQ@mail.gmail.com
> Link: https://lore.kernel.org/r/202608111716.0FA9DB17@keescook
> Link: https://github.com/KSPP/linux/issues/93
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/slub.c     | 3 +++
>  mm/usercopy.c | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e7..027b44dd7f07 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6780,6 +6780,9 @@ void kfree(const void *object)
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
>  
> +	if (WARN_ON(IS_ERR(object)))

Wonder if WARN_ON_ONCE() would be better.
Also wonder about the benefits for hardening (as opposed to debugging).
Without this check it would fault. Now it warns, but hardened setups often
use panic_on_warn anyway, so the result is the same?

> +		return;
> +
>  	page = virt_to_page(object);
>  	slab = page_slab(page);
>  	if (!slab) {
> diff --git a/mm/usercopy.c b/mm/usercopy.c
> index 5de7a518b1b1..c8d8703544c6 100644
> --- a/mm/usercopy.c
> +++ b/mm/usercopy.c
> @@ -157,6 +157,9 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
>  	/* Reject if NULL or ZERO-allocation. */
>  	if (ZERO_OR_NULL_PTR(ptr))
>  		usercopy_abort("null address", NULL, to_user, ptr, n);
> +
> +	if (IS_ERR_VALUE(ptr))
> +		usercopy_abort("ERR_PTR", NULL, to_user, ptr, n);
>  }
>  
>  static inline void check_heap_object(const void *ptr, unsigned long n,


