Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B6CEA4E10
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9231D6B0093; Mon,  2 Mar 2026 09:58:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9044B6B0095; Mon,  2 Mar 2026 09:58:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6796B0096; Mon,  2 Mar 2026 09:58:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A58E6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:58:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BD6B1C0DD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:58:02 +0000 (UTC)
X-FDA: 84501428004.28.33AEE9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2ACBF10000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p7WNU1np;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1PmxJlQwUNAvIVeS05FYp1jJGa3HeSrnusaLeCn1T4=;
	b=qGa8lXaqj2ZkNCLrnEdWs8bUTgZGBIMCOuAFnXuGdvDgivbXrFReX5s9r1AwXSmZXKyAUP
	qek9PhLEh7HHXEDwIrZEQCOMTCqW4+6iQa7UraEhZF2iWNtv67HrqVgZ/ZeELd3dX6z8wF
	dv1nEltIzW1F7KhdXLXpqZMDyWrqwc4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p7WNU1np;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463480; a=rsa-sha256;
	cv=none;
	b=QAKoPsm2iSQnJMJXjMJigl7wLwSeyL+l7s9sXYpBShY6fhtOwHZRHgAJGRvy46dQ2UCZis
	1e/3PwXNyiwHQ0z0AU3B+MLe/cpV+tmxjx9LR+FFLdILkQ2AB/+RuELpam9m8phPk3bUmJ
	qdEMeUpexjDcT/LUp755kBJDph74fkM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF16441877;
	Mon,  2 Mar 2026 14:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3E7C19423;
	Mon,  2 Mar 2026 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772463478;
	bh=fMcLgGLiLWawIvWbTImn1HNe87tRaYVtXMVhESlM6Yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p7WNU1npmxOzphIuGNHxdBRRvj8/rjl3c9gx0K4g6Iw4nSkQutJBId2bzAE2HiSbw
	 A0/uzxzoOUQZu8UM79Fz35b80D+f92ZIZcbq8dzhBnVVsmm9U2I4UHBb1ixV86Ejcc
	 I9QBbUgdFO0qH6u32wvjQhJZaXhXqTdJsNz64h+oMl2m0cboX26uqYHkmMTifb9k9i
	 zid01OlV3McsGj7ijbn9o+md3rEF4hd0Tu+hM0dAr69r34AL8gL1PfzBCSudN4O2UP
	 uGQQu1REIGu2zGPoOMErUU9+xf3KyLGODFEy7fKqW9Au+GIiKI/352Ogx/M2OKcDEx
	 XPqShrSPGX9lQ==
Message-ID: <2f14572e-e02b-4bc5-abd2-7814c24f7905@kernel.org>
Date: Mon, 2 Mar 2026 15:57:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm/page_reporting: add
 PAGE_REPORTING_ORDER_UNSPECIFIED
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>,
 akpm@linux-foundation.org, mst@redhat.com, jasowang@redhat.com,
 kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <20260302111757.2191056-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260302111757.2191056-2-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260302111757.2191056-2-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qo6wncxnpyw7u3sfxtro67tdbaem513s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2ACBF10000B
X-HE-Tag: 1772463479-276200
X-HE-Meta: U2FsdGVkX19COWXj0NvQZmuzf1n6zULL8TqH79mS2kfaUMKq0V95pfSE2lHTWbShz140m23F0g090SrIoEct7SBdQVlTEN1iAKz1wJdSYvs6J1gHB1DSYjwZ1JCxmBAJBtzyZNAiR2WaDziazTAz/QZVVlOJGB+r6VquDqAtx12mZK6M3hh31G+Nf+rbbru/4cOxgqhwn3DS3jaPqtBYQAYlRPt6YjNiEg51v2FozddBVjlpR9F4kvW5oB9KUjzM7gKSfsDs62Yxx2/uS3ikodkjE3v0q3WfNQFzNSrJRO5dauu+MuBgcYEzht/7yFRo5xqZu/Q1vsXJ3SoVG2Unh1lLJHJDsWtdyrRUmVAhsOsSW0FlPxRTu2ryFX8M0klnjtqceIcA9rXbzv4RSCcHGy48sPc9is6D8nIWt7qAlr8RiwffY2qUo2DzX6i9dwmM/O+v5la1g4emW+KWQqpLvroUTjn0tFjIYhFr0UfGZ60eqjEi6rGe1pUMALWfOOe//hf+nanO7P7XCMg7O/0a9U+U8Q8szYCi199jPhYzcSSLQd3OHID7f98WsIExgJwqj4JuF5W8hD5eIwyeoVHu/+6Mz8CqbvDWasnDQuvLz2CF+p7PzA3OFvO4fgP0FuH9jBGIV1b9W6LMomlhD08kjEzwUKh05JAZGJWlR+/FjeNUqy4fyDeiOAar8MFVSGz40bzrHWH/x7EMgJWdmlGfyOWlLCudw3+QuiBg3PoW6PdczuqtwMncNhXaDk013Rkw5Qg6SUQcp4d1Gdj2jxZz48zDC27FDASSLIndigro3DPpbJeHg0raJn3kW1AJ/69pArZOBLxZbpoxVXAuqDytHA6eDKced8kdbY/r5jNmPbug6MhfJy1hrI0JoGEN9wXr6CW1AJOTAppLz6Jc9Xj4UkCRAcoV/RqDbXWHAPgGDkVyFE5cOVWaL57krj3+q7YE7I7RyK/EukQ0mqS90GC
 AXIoV1df
 yKIXIdE432u8106R+HiawAF/lNH6xIqzvs6prCZEFk5TT0gDqwrXY2vg6z+7JaWizRbIl3L7em9UmH4ssWwpw6fIWRQDYhbeXm321Y0N2RVopddFnF0iXlNFQ7G2J2oFarP4HlWobq5V0/rr7g1GcN1Ge3v+eDqILWk415JKYMFSkQvBfHZTvOO2/07FhrstOagaLP0aBDac4zEdtu6XL7tejrcbZv/Xd5WvhUxH7LAcr0umx3VZ1w5lGgRM+BMxpWfpzdwMQE/k44nLLKg74GtsG6Y7s8Aco7JWjFx8hYzDnzRKgHStvGcDUFY//G6QcP+/Qh80Yf9kkIEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 12:17, Yuvraj Sakshith wrote:
> Drivers can pass order of pages to be reported while
> registering itself. Today, this is a magic number, 0.
> 
> Label this with PAGE_REPORTING_ORDER_UNSPECIFIED and
> check for it when the driver is being registered.
> 
> This macro will be used in relevant drivers next.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  include/linux/page_reporting.h |  1 +
>  mm/page_reporting.c            | 14 +++++---------
>  2 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index fe648dfa3..d1886c657 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -7,6 +7,7 @@
>  
>  /* This value should always be a power of 2, see page_reporting_cycle() */
>  #define PAGE_REPORTING_CAPACITY		32
> +#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
>  
>  struct page_reporting_dev_info {
>  	/* function that alters pages to make them "reported" */
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index e4c428e61..51cd88faf 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -12,7 +12,7 @@
>  #include "internal.h"
>  
>  /* Initialize to an unsupported value */
> -unsigned int page_reporting_order = -1;
> +unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
>  
>  static int page_order_update_notify(const char *val, const struct kernel_param *kp)
>  {
> @@ -25,12 +25,7 @@ static int page_order_update_notify(const char *val, const struct kernel_param *
>  
>  static const struct kernel_param_ops page_reporting_param_ops = {
>  	.set = &page_order_update_notify,
> -	/*
> -	 * For the get op, use param_get_int instead of param_get_uint.
> -	 * This is to make sure that when unset the initialized value of
> -	 * -1 is shown correctly
> -	 */
> -	.get = &param_get_int,
> +	.get = &param_get_uint,
>  };
>  
>  module_param_cb(page_reporting_order, &page_reporting_param_ops,
> @@ -369,8 +364,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
>  	 * pageblock_order.
>  	 */
>  
> -	if (page_reporting_order == -1) {
> -		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
> +	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {
> +		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
> +			prdev->order <= MAX_PAGE_ORDER)
>  			page_reporting_order = prdev->order;
>  		else
>  			page_reporting_order = pageblock_order;

I think the change to page_reporting_order (and param_get_int) should
come after patch #4.

Otherwise, you temporarily change the semantics of
page_reporting_param_ops() etc.

So you should perform the page_reporting_order changes either in patch
#4 or in a new patch #5.

Apart from that LGTM.

-- 
Cheers,

David

