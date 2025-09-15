Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE33CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB478E0003; Mon, 15 Sep 2025 05:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D34E8E0001; Mon, 15 Sep 2025 05:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810038E0003; Mon, 15 Sep 2025 05:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC778E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:45:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F37C140556
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:45:27 +0000 (UTC)
X-FDA: 83891001894.25.5DBB33A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A03420003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:45:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JnUD8h7E;
	spf=pass (imf03.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757929525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2KivUwqxNVjWwlGTtOjnYYqPON7TiCZszuGWCFs+ow=;
	b=0EZG7errH468c2PnjXGvXvw0m5lEO5h8mH8X8ZL1dB7e9f8tySeOUppnneX9NUE3fjeUQ2
	z8vFUFtBUclU6I1EXBL3VyFcOGexM3rQRViiKnasil2ej3k3qrEHHMsl2RgDQXs8UVzEAI
	ziPmIwW8QV9g4o9SqgvYXD0InxnpR28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757929525; a=rsa-sha256;
	cv=none;
	b=HkwlSiFHJQwt1QG17SmjMBBfNHgx5AyeItvjyMteuIzhaviaVGA0Ywn10Ui66c21nD+E9K
	XVBINOhrIg4t9pBCAvkAvNSoruGFd5fvkL5AR7Kg460ITOMZX6hf9UY9+JgaJ5MK8n2zfD
	W6lkte2kBo/6CRuRBnfaaC/7PJKVqxY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JnUD8h7E;
	spf=pass (imf03.hostedemail.com: domain of hawk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACCEA4172F;
	Mon, 15 Sep 2025 09:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FEAC4CEF1;
	Mon, 15 Sep 2025 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757929523;
	bh=FxTcG47CnVGLCGMJQAXF7ap+snCY7dUNIJDeMcfqojU=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=JnUD8h7EtnWheoOcSft/vvVjHXFI99tBBrlmjQJTuSMovalfXLFRrqdWODlPlf4Xy
	 eQwF9pdc9ZOv2rm320i8iKQq5ZXQTkOuYdpS9DC4duo+U3ctKgV21EBKsknIKP5Tji
	 BvHX2xnLvTrYY2YT4XhDohOHwEH3iCZhZuyKYtZ4a8CdRkM56AnB8QOuqpFOBeeVOf
	 mjn86eNCl7owVSAYKtu+PLjeAqMfg6Tvev7LBZJla62W6cbzBeC07nzpcOtuvaoixq
	 QdeyJb9dQnBKKWOgZfdnq8IEWhZV2UyZ66q8ASnDmjF9Gh/or5j+5nMoVZJyzR1iMX
	 PVK1A/9MWaNJw==
Message-ID: <7e48c00a-5273-4de1-a2b6-8c122127160b@kernel.org>
Date: Mon, 15 Sep 2025 11:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
To: Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 "David S. Miller" <davem@davemloft.net>,
 Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org,
 Linux parisc List <linux-parisc@vger.kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <aMSni79s6vCCVCFO@p100>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>, Jakub Kicinski <kuba@kernel.org>,
 =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
In-Reply-To: <aMSni79s6vCCVCFO@p100>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7cjq4ny3iwnhmrmhant34ftbsyg3z4sh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A03420003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757929524-595788
X-HE-Meta: U2FsdGVkX18iGvye/qZG/t/6N1AuyY1/DVcDc6BVDwQiHLiEaA5VwRuYk1pyOTxafIqq4mFD79wFrsoYEVgRjfFsu4gYR2zbll2oL70yGGxSNDdzPJFkFLJAAjMr0mSnNUESZ1EXxjKDbJugLGQsWgDCW3HRFqYBcOMSLPxyj24ljWOYwCUnnL9VPxRzBvRKgj9yWiynT8SrxmTRg6aUEsMIyxo4PGia4aXqfxCKGRPO02sW/6iHATqBgLucW1yQysI4iaCvrbrHN/IHgnPEfUAs75RXsvRXIAcgnIsgNxDOdYXH2AI/d4o/0AP5hp/T7uNLnVYOxuv8QwzeGQ3cmt/HJoG26qfzpmufFM6DuWPfddxHkXpl9vYTWDnJaF2PpSA+oKdLRO8oXDvFE95lsCdA3bgVUJaA2hPrWvlA76R8pmYNpaaT3y+l+97uN9eU7lj0oqlQn96EtTKxU2upMPcOGbjKmihl8tpBnfAF47iYEFqTFSkNf3cynqo2TkHXxHvq8bwHPqL9ikyPRr4ysmC0qA5PA54umxRQrolXqEpsm4nFH931LnIGnf0ZAbo1mWS2G7GacmZ7x74qiD5ctkHERxmY0nkvqQJl+Sy+NICospTl6N54PyUFQ/jNex93Hz5sjld5QUiE1vFROG62MPjbM7/a0vwuRfLdtpmgEmDj25jri/LktSWnfR14ma8RA+BXxH0UFW6RkK84fpc5tyJ1iUgxodQcv9UpfwoNedDRW8SkEUzMfgI1r9h1lzP0lESl8S1AqUZL1CJLIwMRm/lmgbsMXs7x5FJkfGmnJ06JMSOA22GFIjkFmpic66E+h8Bvwnt38ly5DY0TPBOUhzQzHHMSA/Hx2CKB406rghIIPukfyKSTqMiuo5PIlK2heZ5nQcA9g575uXjJIwEeNZ1NlQc41Zj4ThAv+hl4CSKQoBS80aktjb+phujMSZUar7LVzB8PVO4TgMFCLXm
 HxaRbzV+
 AJHNLn9qQRaZKDUQlwwZDbT3kPFiTL+gh8EW9aBQ3Ra0k+anv+oNV00RJ+OIDNrUenh/B4Fb6bh9XSqoO1HPH0HpfwNMC2TuogF3Gto0p5Vc4w1VkoltF1DDeTpu6bAvLNsdwXY/yZfqweUw+j7JStNrvjv1bUWOzG15KNfuyU8MKLoFNdRbj8s6mbRXqVVhBf6fG6jyBoDSylU2Qet+lkAWx5/ly/PCZQXowuGvZQvUDuTaFF3HVvvU4VTh4apCl6Q5a893Z53wYYMvC/y3qt7I/4tN42Dg3oLmeC7dl5y/LNXtCgBTkbaHMTpv9LUkQ4MlGn1ty1FcBOLxPpKY7hYK5wm9bb5eT0FGZfCeR7Ocxd+SXbtnenqhEm03peiDZcSDTy0AvK9nJPUe2v3SVegmM5pwacNIUwZ6htVgFvUmbUP4ctHB4YJVNA1SClSs2eF5QM4haQxDJbqHQG18PKfamxjySPfcXfoGJyk86o1/smBG7ZbiMpeIz9cxKiUCvTWMF6gVFSKAqt2x/VgL/bUMVpYal0mg7+Z2kQRh17p8F4ukgy5zpbQ28EBflcOQU16+SvOtfG0TfwiLP1W6RCKdH2irNDbN+BpieDDymAK06ja9GcXR9PLAUzc4XcgAZ/LTm9vgHyhvq3MV2qBLvzQpXFX/LsncwHW5LzA1/WJ0UgTNFXsM4mHeoPyABpqLF4KvK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/09/2025 01.06, Helge Deller wrote:
> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
> 32-bit platforms.
> 
> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
> pages, but the remaining bits are not sufficient to unambiguously identify
> such pages any longer.
> 

Function netmem_is_pp[1] uses same kind of check against PP_MAGIC_MASK.
The call-site skb_pp_recycle[2] is protected by skb->pp_recycle check.

BUT napi_pp_put_page[3] callers have been expanded, and I'm uncertain if
they will be affected by this. (Cc Mina)

  [1] 
https://elixir.bootlin.com/linux/v6.16.7/source/net/core/netmem_priv.h#L23-L26
  [2] 
https://elixir.bootlin.com/linux/v6.16.7/source/net/core/skbuff.c#L1009
  [3] 
https://elixir.bootlin.com/linux/v6.16.7/source/net/core/skbuff.c#L991-L995

> So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
> pages and as such triggers a kernel BUG as it believes it found a page pool
> leak.
> 

This sounds scary to me, as netstack (see above code examples) also uses
checks against PP_MAGIC_MASK (+ PP_SIGNATURE).  I hope these checks
isn't also subject to this issue(!?)

(To Toke:) Did we steal too many bits for PP_DMA_INDEX_MASK?


> There are patches upcoming where page_pool_page_is_pp() will not depend on
> PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
> those patches are merged, the easiest temporary fix is to disable the check
> on 32-bit platforms.
> 
> Cc: Jesper Dangaard Brouer <hawk@kernel.org>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Linux Memory Management List <linux-mm@kvack.org>
> Cc: netdev@vger.kernel.org
> Cc: Linux parisc List <linux-parisc@vger.kernel.org>
> Cc: <stable@vger.kernel.org> # v6.15+
> Signed-off-by: Helge Deller <deller@gmx.de>
> Link: https://www.spinics.net/lists/kernel/msg5849623.html
> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..f3822ae70a81 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4190,7 +4190,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
>    */
>   #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
>   
> -#ifdef CONFIG_PAGE_POOL
> +#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_64BIT)
>   static inline bool page_pool_page_is_pp(const struct page *page)
>   {
>   	treturn (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> 
> ----- End forwarded message -----

Looks like your email got truncated.
--Jesper

