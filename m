Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C9D5CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D0C6B0088; Tue, 23 Jun 2026 08:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E816B008A; Tue, 23 Jun 2026 08:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD5C6B008C; Tue, 23 Jun 2026 08:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 881996B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:07:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05958A047F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:07:09 +0000 (UTC)
X-FDA: 84911051778.01.1671BD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BB2D4000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:07:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbwZAtiK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782216427;
	b=i+/wWgY80y+MeQ1UF5EaYDooqwv0u2NarK71EBOB1DwJlQVnIsWZu5hFdEyqMNvkvUq0K7
	ss8qprJ8SW2DiwMgvpVEPb5MyekIe+1VOk8qT6QGdSaRahSh3dVt4hWCXcUCR5en2T6Qsr
	Tru0nsSasGnjH6FON/OPM6S2IsCegNU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782216427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvovPyg8ZSCUX7iJQAPw2UOA7YGXY8BWMaRT34BQcm0=;
	b=Sl41nOLy4SgvKppVx2GOLLbT4nwmwbCe/bLSgXwgUWnlylHftEI4G9NHNubF0JCJykMhpm
	BceeumvsSwimHin5IQBMCnbkDTkQxxLgGL4dYUwIlb2Jy2D5X27m6OMYsRp6ixBJ4hlRkL
	Nc06WS6N4L/iCc0D3BLsFPblqbEKDN4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EbwZAtiK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 204AE40325;
	Tue, 23 Jun 2026 12:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AD71F000E9;
	Tue, 23 Jun 2026 12:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216426;
	bh=cvovPyg8ZSCUX7iJQAPw2UOA7YGXY8BWMaRT34BQcm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EbwZAtiKaYfnO//6uMTCthoBr3Z8E394Xk5iInLQV8c8CTaSMkIWmLXRxvbj/x9Cl
	 O8dnNGqTH7jYdSLjSFM1aBJUyGkgI26x4+Y9oxXdO5tb+/OKx8/Ecnf1/3+t5V09G1
	 LD8Hp7/xpZjOBgyJR1pvlwe8e3R+FI/mSzTMbohoHG9zzlMwq73lDCP7fukcM4g6It
	 u85+JcRCpULU2l+BCjpy+nDFJocln3s/y2DRd+s3UaxeuFRtLkm0PRXE58l9gV3mCx
	 IdmV8ceoit79kq5j0JdiIhGQ+Qg6dd7hFYX68EtfGRm9mfM5iOQ5j9vDUgZ9Zg8lTm
	 NAI7a1k/Pv6bg==
Date: Tue, 23 Jun 2026 13:07:00 +0100
From: Will Deacon <will@kernel.org>
To: Yu Peng <pengyu@kylinos.cn>
Cc: lpieralisi@kernel.org, akpm@linux-foundation.org,
	catalin.marinas@arm.com, guohanjun@huawei.com, lenb@kernel.org,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rafael@kernel.org,
	sudeep.holla@kernel.org
Subject: Re: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
Message-ID: <ajp25MIQJWWE1ziY@willie-the-truck>
References: <ajkFE6TmwW6B/huP@lpieralisi>
 <20260623024712.3480399-1-pengyu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623024712.3480399-1-pengyu@kylinos.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0BB2D4000C
X-Rspam-User: 
X-Stat-Signature: ny19zke9x8dtnjeiqp7pak99zmdog6ah
X-HE-Tag: 1782216426-471777
X-HE-Meta: U2FsdGVkX1+rWvB2So4JUua/frGStJZIEYNAJ8hTI4WbQtQZINQnu5znBVRn3pHaU+XKXbPDpEJ6ngn80rUDDuCewwjQNl2emCggyqKXkbEbI96W9OuvreJRFyfykrtEaFJj72jNvCqagppbLYxu3Eb6DYVMZcm4FQOOPJNyvCriqp8Hbzo70BY3cnJYncVjaN2WTuMaX2+HUudmg9tHGJV9CoybepM1mPXUWUSCLvUQ4Y4EvXFTgG5eqnLnoOH6I2l2mAM3suI/U+iRe05BdiF8W9vcsGis5wyitZ+9PytN93XAIgHFdAUrFKj69+9ZYsSbJhoru2aZhqYsgMgxRiMbHUBpGwmv7SnLIgcTyKtXYAzOjXwSeEfAnxp85XPNnI9ZAdGWc98uLeu9xUBQeHj/jTOVpeSXMLqVZja8NRhNtLVG2ek6Z8P778IJfEcxqs5NL7/wOIvV8CcGEq2jiZzpHwrjEKIwHWTdZIrdo5ZmRqkK70zifoK2w+8PkFgBfHvQR8jlUUQBsMrHUCR0Gi4xRL+b7Gi+MKQK9XfnaqpcXRWQrxfKdTSwLZY2L9PLxlES1xR4/IuJgotow75CaX3CZ1WqiP1mS0LcS05oauQa36hPgxFdFJpU98ZP009rFGNv3rOAtCjuMhtyc5DHaBipPseglF5dO4qkyOPBVmyIsICN5kcMC9y6l1WRsTM6Z0eBgmxBCrU7GK8wg3U+6V6/eCTfpS87CP/CuCyDdLf7mtw+FzP7ATbRRhbGVL4C98D3XIEHYl/IzZIEb2GnsNeMJ9sZyjaPc4FnW4UWmVB9PfgpPpYttG1MW7ECfxOtbo3EoG8fqDvX0GSJcQ+p1HqrrcOK/UxZsvunCaoJvymL/WbRJWx2JOf8XRwErRYFzcDr4jVQUG22KRLf/YZGGzpWPsRC/oI7GPxLILtD00/tPviRMuEU5K/e1jxS8PSXNPmzfvX6IbHhp9LPp69
 J/eHB3wX
 sxZCchWOGHpGNqn5ZLzTZJh0uSXzzxvQ0L15G3L5XLCI8paRt4ake01x8QtQvwbGOYIDXra8+X1iy65nQbgGlylpYDirgiUiJ7JLgOdW/GpODnwDuIBlARH+AuBD9FcEiBe9pywdpcuH8tKBocz5yfb3KpZrCGFUsinJVZio4wQsIJJ5CT2bYn4VYLUmvHF8mDk2n7+XQovf22r8ToTrLRRYc0USVpHF9Fm7fah0I6Xm2/dJEo76X35ny7XMi2KSEPd2cCeWaLWRdkTW6Z5Hmg3rMWhKA61pPO/xwFpBxi5sGquM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 10:47:12AM +0800, Yu Peng wrote:
> Hi Lorenzo, Hanjun, Will,
> 
> Thanks for confirming.
> 
> I will send a proper patch for this. The change I plan to post is along
> these lines:
> 
> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
> index ... .. ...
> --- a/arch/arm64/include/asm/fixmap.h
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -79,7 +79,11 @@ enum fixed_addresses {
>  	 * Temporary boot-time mappings, used by early_ioremap(),
>  	 * before ioremap() is functional.
>  	 */
> +#ifdef CONFIG_ARM64_64K_PAGES
> +#define NR_FIX_BTMAPS		(SZ_512K / PAGE_SIZE)
> +#else
>  #define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
> +#endif
>  #define FIX_BTMAPS_SLOTS	7
>  #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)

I still don't understand why this issue is specific to 64k pages, though.

In the example you gave, the thing wasn't even 4k aligned.

Will

