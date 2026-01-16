Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A896C982E3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BD746B0005; Fri, 16 Jan 2026 12:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A306B0088; Fri, 16 Jan 2026 12:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4761A6B0089; Fri, 16 Jan 2026 12:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3305F6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:48:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9F10D192E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:48:19 +0000 (UTC)
X-FDA: 84338561118.01.8B63F3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C45B28000A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:48:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WwJRE5bQ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768585698; a=rsa-sha256;
	cv=none;
	b=ofpWKAfcVa1FyLuwQlBitWOg/O67yxxnc1GBxVPCbsNY5g9yUoL9nJCjh0zxxAZjm5DwZn
	uJU2wueNhtJ5hMhwHPz+zUtBpa4a7RP5dwLa0r5Bze7cG94klXjlthR4hFtmaDRX1TKfzM
	UMvQE1A99JF2zJGFmbeprjRPPQDKZe4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WwJRE5bQ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768585698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8LNA5Wo3WVqq2x1gx/N4VUP1j5Oif+eRoSfhWwfBag=;
	b=iNoI0i/0pEitqcyvH0vLvx8Ol9WnSaH4ZAQ3GrgAK3oJWcEaBOTPzxNa9Z/6na7pLCrLlh
	VDH4k2/Dss7gZqVp3xLwgJobU9Dnf8V3Rwo/A3sswNOI+P8fERnadlC1Cy9lkI5/+6Nfpz
	yuA/hhKTo2IdeC5qrvXLx3QPeho1BQ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E80A40933;
	Fri, 16 Jan 2026 17:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAF5C116C6;
	Fri, 16 Jan 2026 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768585696;
	bh=9IoF5q3KKyMfVT7MFi03ZTQqilgKQY3sTSgULwfRKsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WwJRE5bQbvho7uLMix6DCgxSr5U7QZ9Bb3fVfxTJBdA1iaAaP2WAOoY/j9lv/Ds0v
	 p1/mFyTJBFaeMWvZHn25kiEP09tUW93RYFVWiTqbNb3HAUIBtCCCHVGnDNBUGGwPG0
	 yokZM9ly68yhzVt3XbC+LtQzw4wdTpUhrDiq2EW8=
Date: Fri, 16 Jan 2026 09:48:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: William Tambe <williamt@cadence.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] mm/highmem: fix __kmap_to_page() build error
Message-Id: <20260116094815.ca8ef0ad407a4b8612845d8e@linux-foundation.org>
In-Reply-To: <SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com>
References: <SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C45B28000A
X-Stat-Signature: rpjek7jubofe3fk6pgz5onbru4fa17ze
X-Rspam-User: 
X-HE-Tag: 1768585697-779773
X-HE-Meta: U2FsdGVkX19HC937sW9FdB9O2oLTHx451SyDZmfH6oR3gI7uU/7+AxHrwFL2EUMqEQqURxEcKkDgMlCedCaqeaqx34UD0+ePvRIwRf16XuOYbkFXzqLVo5K2oGHThv2CFmgFivHNSUU+3RXgumlDpw7bdTx9fD0X2BJZJ4hb9lChoxFtRdbDFGPGtLUhTJMh4z0Abx2Av6idy/wsA5P8S2PUcUnSp0lfg1B/76oruNVnzwTN1kwhwScGNY5FEcU652pESiHoibKLjRy5kX5yY9obVadTtCaakUiIZvc8XPdAXl8JH6+7/O0fErgF54PVpk5Za0oDglgiIINzkEJwHztIIFVew6RQqzZcSOczFOBwvxPdH9kTfZFkNtkXebEGT3kE3G53aPFYOuEKzsO41pgPok+jDYiBN6t1zd8mY1vXdeFuzeYknbvS9omCBM4P95jTq94N5ocape+YWwIZ6FGcGkFec/Jf3NA7vjQIQTydTCMy7mTa5pxPSN3jUYw0XNOhEfEDZAVzEx48jVfW37scv7ihTjfHfpBk1em4EsFCeMprIvXqMysLsIRUUKszEJbk+ijaAGek66MbmTgnPZx599JHF+iWuERE6ui4d3GgUgNO24/RIw0UliUBbB/GzSc2orjSB+e7ZvgDH87/pDrEt7SDCu7xYlfDq4Eqlly7QRoDFysVdlauFUOJN592IfDNPuzKHrlqgqXBMop4B3LbCQBBkob7PJU2UoD2MfamsInXUTC7oRXrudUtCCTNqk32bvUrShJzU7t4RdP24QjbbWmJ4U7zMH7PcJAz8wbIbr+0KbNCM0sgQy1FDHvuJRW3fX5zRbVrQMXfIi0JtXB8sk2h43sHHphIuYcbj/y/m6MTbm4v+cUEHCyjHYauePETxZhu41efDtK1hzGlCDw33RckfVDIZj0uP+Z3Z5LgdqEDT7eN8jYh7Hfaugwp/ol4wi4LyBeJyKMleYq
 CGItlTn+
 BWbgxKpiJaMTsv70u4O8CUQJ9L8wuYw2MVMWggYvFwubM+y6SpRFFONWi4rssPguSKW/xD+LBCgrnSihtgzBWyjkhQCKUk13koZErbWau9EKZygIEZlQHRG4wq5AtWMpKZy8ZsmVrq4WpCh/HptBh2tkYHf8PpjgzSEh78IxOrmYUPJS0dtUJccGLriBbfQPzdBIo6KKfXMbYSDKsUsUNDDDcClEB/hYC7I0Yode0Ci9lSjEXPA0oceq6Sk1uTmxtCUC2BsMpE9CbtQwfYcgw8H/u4S49LbBkKoaB+oqScCxzStJCytwJOpBpfGQsC1qLl+tI6dbr0BWJJ1IJGoOeCxrkD/+pBAETnJxh+Ug1CoxLyHK2IUhlBKgTYDVZaKH0HW+vDWVLH5em4gM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 17:18:21 +0000 William Tambe <williamt@cadence.com> wrote:

> >From 706fa431358390713c47667f6bcaecce56d071cc Mon Sep 17 00:00:00 2001
> From: William Tambe <williamt@cadence.com>
> Date: Thu, 11 Dec 2025 12:38:19 -0800
> Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error
> 
> This changes fixes following build error which is probably a miss from:
> ef6e06b2ef87 highmem: fix kmap_to_page() for kmap_local_page() addresses
> 
> mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
> function); did you mean 'pte_val'?
> 184 | idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
> 
> In __kmap_to_page(), pteval is used but does not exist in the function.
> 
> ...
>
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
>  		for (i = 0; i < kctrl->idx; i++) {
>  			unsigned long base_addr;
>  			int idx;
> +			pte_t pteval = kctrl->pteval[i];
>  
>  			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
>  			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>  
>  			if (base_addr == base)
> -				return pte_page(kctrl->pteval[i]);
> +				return pte_page(pteval);
>  		}
>  	}

lgtm, thanks.  Seems to affect only xtensa?

I wonder why it took three years to find this.

