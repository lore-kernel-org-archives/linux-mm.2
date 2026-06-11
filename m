Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D60CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF11A6B0092; Thu, 11 Jun 2026 09:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9B36B0093; Thu, 11 Jun 2026 09:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06496B0095; Thu, 11 Jun 2026 09:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFC346B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:54:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 628958FF9C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:54:30 +0000 (UTC)
X-FDA: 84867776700.16.6CD151A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 31DE140004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:54:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A3e/grzA";
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sI4JQyYAzVqiBIia2rY6sk/3gfVLhjVcCP3+jTSxNY=;
	b=i9b/pL3JJAAHRziWeTjcVxa/TKf9SXKOyNDMMBoQWPl8Yqbtvi/CRqZD6KEdqNwQGPoft0
	5EQMmJ+WbiZCKAk8QwJx8l9L0DSXI+2xeoZ74CAsKIdDaH9yGSHle1zSFcVqgWbmHQe/j8
	RwbU9frVixNoEl5bynUMf3mJ1V60ioU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186068;
	b=bAMFuJjXxQw3TnPeSPtSIcTWAu8r1rGS7MeTp3yl0J6Uxz5reZdVh4NFZ1GYp77rp/mB+O
	TIN7faDGZCkvMsYY0e5kvDMM31E4PKQYTyqOxp6tqKQBHG9cKx/Ha/FV8UO8GZSFmcTgBg
	4+ILV6DSTqWev7BKmuvEyvZiOIVc6O4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="A3e/grzA";
	spf=pass (imf12.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781186056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8sI4JQyYAzVqiBIia2rY6sk/3gfVLhjVcCP3+jTSxNY=;
	b=A3e/grzAHb/uzD8WFwwuASnBnW79ffERfX4DyUk1lpKuO+kjGP/3Ks9ZTEDEa1yBP0yWno
	btblvrCoLDnqsx/dNHjTkfDUIKd+3oaEY47+d8YJ6lrjYn7zgTbdvlbYHpCaExm5AJ8+Ho
	83oDlw2fYDR5jNr+dTQUUsfsxf/EAKI=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2026 13:54:13 +0000
Message-Id: <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
To: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 <linux-arm-kernel@lists.infradead.org>
Cc: <linux-mm@kvack.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Christoph Lameter"
 <cl@gentwo.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Brendan
 Jackman" <jackmanb@google.com>, <owner-linux-mm@kvack.org>
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
In-Reply-To: <20260611130144.1385343-4-abarnas@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 31DE140004
X-Rspam-User: 
X-Stat-Signature: duhuhiym5i747mrpfoduonbawkyyj4pw
X-Rspamd-Server: rspam08
X-HE-Tag: 1781186068-641161
X-HE-Meta: U2FsdGVkX1/E7GZXZhkoH+FqqnPHoHtfxrme01WoDqUJBGhk5/r+umdwjq2U0lhgnW5Ux+FaPHH6vrLAYEMH967rKRdKPbU7xuPSJWMvd9mRV0RjzXkCCiWG+JGFFTEyK2GR3Tk1Hi9C0FEzWtgLfTNmptsc4xYRU1gchC33FHjZkf4h9ueUT0gAN31Wju+cYKpdBEX938Xlx8lQHsAL5uddQFMVQaKNTk2FYXxWJJvBTnWcUw3A06ngKNxxoV+l9dnf5tZBS5oSNwz/KhfszLoOzlNdXBaMuI/qmLrqZnUE679sU2hasFllw8GQZo3D2chxjFbx50jumpTg14Mj3EvtNbaETgAjyGnBfcXTO321G4JUTfIbvYXkqg4Ykz1nG8sC1jUZ/lVVPnKEqSI4jUkNmM0Z0faqmezzyLex5jvWlNWxldqrdwuHjEmTDLNzIP+oDwfd+DqO/MnQnI3TzGpMIawnSVNYLULLBzE68AdCphyR1x6dHl7T2Ccb4pJAJ4K0Ojf49jVd6QuyXvelLvWQacfbKDTG2shwVnZ1xHBVZxPPxnNafNv1K+Wj8U3RomQxt10JlBl5QNDdHIwcr4UCt7d25bbEqgOpmFOIcoz4bD7gGV+bLJPkgCpFA7v/g8yLvBYWs3+pz3J3nb0TKtil2/sMo7mDilN/ReWxdfDKReZmd2p+4XsO7sA7W9wdRL/k2VZ5AB+j0nR9/hZKfwpLnYlITWQD5BIi1MCQlRyvZQui7hp1KujQRi6jU9vDNneVeofTjug5oMoGgsI05muz/Wr7D2bdERgTCUC6SN25iitoBGPjKA/vopGzZbzdsP79cp1TPKenv3cOb4g+Nf416DqcSxXQqaR6n5XUcpZLXxr1s/e18gwqTy59V60aNTtYT1XKvfGcSdKkvYz04753zyPxR3j60YRZBoV2KVG3vCGruNVtl3WdfUwUhySOdzVhWEVwo+lkCwwfwpn
 Gy2KVF9p
 z+mF9vClUXu2dyjdJ9qjN1u0mTr97/uLE5NG9ElFxvJGj4FMgOiMqBg4jTBwRKoCi6MzxaQf0P8h0ynj6cFdzHdfuY2EkZDCX1rniXTdnbDiQC7p2GplqhTZXhsgB0qRDlGYoReosqdLPRWXULXhebhtiiDJLdCSv77ovPSP44A2lLf0zkBm6+YIvGTIl7B9ts3NU9Lqkjnq1txUPX2ZbdGYDw5pcKwDDzcEOwTvFtJXrWBnTtqYLOmCOK7yyOlOl5kFT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 11, 2026 at 1:01 PM UTC, =3D?UTF-8?q?Adrian=3D20Barna=3DC5=3D9B?=
=3D wrote:
> Strip the read-only attribute from the selected memory range when
> restoring the linear map after an execmem cache clean.
>
> An execmem cache clean is performed when a cache block becomes empty
> after unloading a module. When making the memory valid again, the linear
> memory alias must also have its read-only attribute cleared.
>
> Without this change, the linear memory alias remains read-only even
> after the execmem cache block itself is freed, which prevents subsequent
> allocations from writing to that memory.
>
> Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
> ---
>  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 88720bbba892..eaefdf90b0d5 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
>  					__pgprot(PTE_PXN));
>  }
> =20
> +static int set_memory_default(unsigned long addr, int numpages)
> +{
> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
> +				      __pgprot(PTE_VALID),
> +				      __pgprot(PTE_RDONLY));
> +}
> +
>  int set_memory_valid(unsigned long addr, int numpages, int enable)
>  {
>  	if (enable)
> @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, =
unsigned nr, bool valid)
>  	if (!can_set_direct_map())
>  		return 0;
> =20
> -	return set_memory_valid(addr, nr, valid);
> +	/*
> +	 * Execmem cache uses this function to reset permissions on linear mapp=
ing
> +	 * when freeing unused cache block. On x86 it makes memory RW which is
> +	 * desirable.=20

Hm, maybe desirable for execmem but that doesn't really mean the x86
behaviour is correct. Maybe it makes more sense to change the x86
to align with the arm64 behaviour here?

BTW we should probably document this API a little bit, I never thought
abut what "valid" actually means until now. I had thought of it as "I
can access this memory" but that's an unclear concept and now I realise
"valid" is a technical concept in Arm that's confusing. And it's extra
confusing if the kernel API uses "valid" to mean a _different_ thing.

Also, shouldn't execmem be using set_memory_default_noflush() before
freeing anyway? I guess that shoudl even be documented as "if you change
anything you need to call this before you free the page".

> On ARM64 set_memory_valid() just change valid bit which
> +	 * leave direct mapping read-only so use set_memory_default instead.
> +	 */
> +
> +	return valid ? set_memory_default(addr, nr) :
> +		       set_memory_valid(addr, nr, false);
>  }
> =20
>  #ifdef CONFIG_DEBUG_PAGEALLOC


