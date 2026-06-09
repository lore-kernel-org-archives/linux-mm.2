Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3394CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EA16B0005; Tue,  9 Jun 2026 15:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2061F6B0099; Tue,  9 Jun 2026 15:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1432E6B009D; Tue,  9 Jun 2026 15:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0131C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:45:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 940D41C27F4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:45:54 +0000 (UTC)
X-FDA: 84861404628.06.D9B108F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 66BE610000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:45:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WAftlABo;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781034352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDnT/R8r7fr0S+byBNjg5mZPhI3/Z2+xQc0Imi0qg1U=;
	b=bOgezN8JTW7w6NA2ATyFJQ/kU6Z0TLc8F9LN6zcPaGE8WBvRFTLiUZOPbZYZ2zfLJjY8Ol
	pbAo1I3nuXWbYi/hdbP/IQAR+RA7DgGEYxRwCKvUZ/KCpl73LKXeu7S8VtthWRokdPjbAE
	4ZHztDXK0OX76OVqEv20cwTi1axL2XM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WAftlABo;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781034352;
	b=o+UM3dYDZCaf+oiCw2csPGmSU9RmEb6veJwJXguYxmj0RKKTBAhkMhJOF93RBoi7/FFOgL
	v/wx/TejB92qFuqoM0XgDe9vs3Ti98xw3n0HV/QJry1iibwKcCi01kwMCzbixXmdXU0gtM
	o1pvxT80toODWNPmF+02hbDdjLHvh7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4141D4399E;
	Tue,  9 Jun 2026 19:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D041F00893;
	Tue,  9 Jun 2026 19:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781034351;
	bh=sDnT/R8r7fr0S+byBNjg5mZPhI3/Z2+xQc0Imi0qg1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WAftlABopgVwyK7vGdX/rtSLAO9xtr0zc+DLl4US/9eBTEMgAwekI2vvfzqxbkLvT
	 Wd4X5e2nqodqCSdGijAYC7Pm0so6Nq5F0UhcYuMuxk2QEPxd8donUTVOuSSVYE3uBv
	 Zw7XdRWDnVlqpb2ACbHDkFj65maHJqMxriyS8hL0=
Date: Tue, 9 Jun 2026 12:45:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, hpa@zytor.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 yang@os.amperecomputing.com, jannh@google.com, Dave Hansen
 <dave.hansen@intel.com>
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
Message-Id: <20260609124549.aff7e774603c4af188009408@linux-foundation.org>
In-Reply-To: <20260609143801.7917-2-xueyuan.chen21@gmail.com>
References: <20260609143801.7917-1-xueyuan.chen21@gmail.com>
	<20260609143801.7917-2-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6eis76by5ddqoy3chyuonftsoths53mo
X-Rspamd-Queue-Id: 66BE610000A
X-HE-Tag: 1781034352-148795
X-HE-Meta: U2FsdGVkX18May9lX4AQd0HCKgjGbtdT4xxbtw43p9oMr3OkziuAWxpemIm+fpXR05uPdIdzNnj4gWg0nnlgpcSMS0P9ACjMN4+fxQAJcfBaE+JTdGXvHdhXsFQ/d3POezUIyVlXEQ6YJ6Xyz7h95gGMbai/7Y/w6lpYG7r9quZ7PreXefHX0S1aq1BxIB62IT9/fzfZRS7LQEDOUnZySU+4yLqszIT6/U0Lyk0fmOdCu3Ovv6Q0UePa3jQVsgNTU/giFl9NGwezvB4IxOpsV8MEm/fhjHtJiaLcurU7kJ+nK8WjxIsYIzOVjNG33iGBZX7IfqDDJfnkcFgWeGIeXdOLNVuXi/1kehNTuNIUE7NRUzjqHWGaCpryVsmohtpW/WXhdUrTHtd1Bazmq8aw2/xei5Tq5N7yD255Kmof3vpPzN9kC9DfSp9oBqjBe1VnSnRbNUFOveN46KVjnOTk05o9rA7RFJ5RF8HMGs2nDANzciDZJw0su6mCiHD3VfCeX8TFiHHXrDCxjMg6JrVQkbWRV+FKo0ilvfhMFnnSxvXzLtaBaxOgnOqpClDiLLTCdfG4cnNfmj2JljOQfudClp4IvnqWK04GOby+UXse+H9b5/cNEsw00zTFx1S+Q6cMwgc7Y8xOI8Ut/gjYMytnYqzHKEMPtYxYoJZZGty6hqfooYqE1COYjkFUvhZYd+0XAnSzCASCYV4QRHAdj1aa4e1c9C71HddiYEMaaPx03SW5btKd8iw1xpJ88sTaL+TrlDXfwvEjewYi15GYVbEIlIL6g8We1CulRvQBfKfPDzsXTmPeTgVY8uJIrWWPPLYi0meihFRLsqt3+uuRUJ55aMo+m3IuEY9zYdfFQlGK1Be6PelmaMbURAlxWVdyOo+l0c4P24sKOVPFVA1lQ/K2lsSse6rZAU2xgGcHzXpN30aOE+KkCYSUDy4PQqYdEOruQ0s+xjNpfKsVEpQj44+
 QyuHG9hP
 5mo9tnbl/10qYDFaQ8u1bfwIbLZnhn5QcysFRkTu8VP56trJhRkpiGl/l86tmINgzPuLeZHtokPRXf78AZtZmhMJecG0vrqBby9A8D4Xaqkb0RSdLLiMbr/QH1QxpD/DbQRQeOivHwIBrnk9S7RmvItt+BbHqv/GvKh4zcBmI41CbtViLgXrECzRaA9u4WhoU/INKamILa+/cS+fy9G2lYu2wi/RgIqCrUQ/dCg7Oy84e4+m0nAaXu6gLDsE0C/Rbql5vmYHX3kaVouGIXA+VjV6pdq8/9ylMDLcINb89AyZbcMmGIxoo9KuJeFXIDXedB3a+PhEHrhhYF55y+z/MP43m5w4xGs6Aoj7beLBW4QVWBCbkGBgbQOG2hbjc9z8VBcRl27N0fG6ek/Xfajd0cArQv0so3B3U9ltXwy50aIiuoTVKxQmdwxADKwnncnNDqST5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Jun 2026 22:37:59 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> The huge zero folio is shared globally, and its contents should never
> change after initialization. As Jann Horn pointed out[1], the kernel has
> had bugs, including security bugs, where read-only pages were later written
> to. If the persistent huge zero folio is read-only in the direct map, such
> writes fault instead of silently corrupting the shared zero contents.
> 
> Add arch_make_pages_readonly() so mm code can request read-only direct-map
> protection for a page range. Direct-map protection is
> architecture-specific, so the generic weak implementation does nothing.
> 
> This was inspired by Jann Horn's read-only zero page work[1] and follow-up
> discussion[2] with Yang Shi.
> 
> [1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
> [2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/
> 
> ...
>
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -308,6 +308,11 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  	return 0;
>  }
>  
> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
> +{
> +	return false;
> +}
> +
>  static struct shrinker *huge_zero_folio_shrinker;
>  
>  #ifdef CONFIG_SYSFS
> @@ -982,8 +987,14 @@ static int __init thp_shrinker_init(void)
>  		 * that get_huge_zero_folio() will most likely not fail as
>  		 * thp_shrinker_init() is invoked early on during boot.
>  		 */
> -		if (!get_huge_zero_folio())
> +		if (!get_huge_zero_folio()) {
>  			pr_warn("Allocating persistent huge zero folio failed\n");
> +			return 0;
> +		}
> +
> +		arch_make_pages_readonly(folio_page(huge_zero_folio, 0),
> +					HPAGE_PMD_NR);

Can it simply pass the folio?



