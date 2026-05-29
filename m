Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFE8CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 04:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264EA6B0005; Fri, 29 May 2026 00:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CED6B0088; Fri, 29 May 2026 00:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179C16B008A; Fri, 29 May 2026 00:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06C1D6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:54:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A63916308E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:54:20 +0000 (UTC)
X-FDA: 84819241080.25.F27259B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C3F334000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:54:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HyJ4vwp5;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780030458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmBYU/C9A8DuyO6OzJPCqgCvC1lOYcpnLM+Wing3FTU=;
	b=mxtTPA8eIfWYh/Pq+gWSYEmvF87zGm1cNOsIeOUKMvdhcCrJXxkp0cy2B3cWljjxAdUtBi
	PSaLs6JuYpps3E05rKPMqDvuWFROP1KaEhuddrSNRay9kcYpdsLe7p04aneORrAEKewSyU
	Rdsha2v8P8eJJCnFS/qAUYj3nvceEY0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HyJ4vwp5;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780030458; a=rsa-sha256;
	cv=none;
	b=goKMxxXtZOQYGTUV8Tqd4ame1G+HbecbXTSy+BhB2JJ1MRjayOlJLcGHzjplocQFqW/ZO2
	0GWboBLGGI9pkdVSxv/cS/P5HABlhBca5J/QmuyfyQNEnfBT3AxiAOuzWuhnBrVKY7gKZX
	LXPVoBTXKhHkaLLZi+/sbmnuO9yHbJA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C728D22EE;
	Thu, 28 May 2026 21:54:12 -0700 (PDT)
Received: from [10.164.19.8] (unknown [10.164.19.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FD753F632;
	Thu, 28 May 2026 21:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780030457; bh=9ZeCdBi+o6rNm0JaiPfWqhFJAJ+0UGMwKBp+YQQgMao=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HyJ4vwp51VA+tyI509PRHllcQY2Yp6pbcF7a9QbRTNIwW8DrrHeR7zZBFwPOr2yiS
	 JqIgVnEOUZsMNvv5VRH5nD5q+5mmY6zX6vzG3uzwe7y9YrOwTqgkT3bFDPQTZiXN+P
	 3zC8Dfzyf0L4mBABE36fGYRXsAUP0N1GqG9j0nT0=
Message-ID: <cb2b4151-e096-4de5-a064-ee3bfa8cdc2c@arm.com>
Date: Fri, 29 May 2026 10:24:12 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vmalloc: Fix NULL pointer dereference in
 is_vm_area_hugepages()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260529014130.671291-1-hui.zhu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260529014130.671291-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m566id5kqmeqt49ie5rzycnm9scppafk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C3F334000B
X-HE-Tag: 1780030458-410735
X-HE-Meta: U2FsdGVkX19BFaCvHeXOCXQU3uRiZN/Id1l12qs1PDq0U0/4V1L2lhA7+Z5Shbhz3EwFPFNdqRlUbgar9f84Gpfir9kl6TWPQ+31M0HrF99/uufl8KlpUZXQqcHMiyTspTfTvIhItkYkQk2EusAaauRF4hfJEhKCW3FhOnsXwPVHz2pjeuG6UeZfs4pGLQtIM/BTJyP79xkp5wK+nqN/2BtWmM1cnSVg0Jdich0VxJ2XQtCpmeXfKhYuKkWBBIRTooqc7L+lUKuBlt42C3m6uR/voMeOUv0ATo9feaO55665QESaWqP0YqtO2krJtGWO4w/PSBYnCSPqlbU9s9YCgDs1xW+B9LozFyj2k7f9YZB76jaGaEIMYKl687zV2Rnk1W4tHwW2IgIXfNm2gTnFUQ4Cg3Z1V/xDSFhdglOq0fRrJPEY4nOynZns5VGD3tfejUWZb+dIJhdM3w8LvEyJ3/WBasf7XfxIyVqr3Az+zb1RnHWSD4ANEWC2zluGGirTJ1xii+PdRQCEIwtN75jTq7Oo0kcx+e64x7tF/e3mXE9ppXCj6tk2aMh2RHXESK/Yb+gJ98mQGautq7ImabnUmuHMHq7tC+jFGjENlSQtJya3Crk2D6R2oABM4x2r3jOR/P5S8RN8J/JU8m18Yn+gmGbh/66XmjICthACG4gcidp5ZVhEqPDuS9qO3aCrh5ddB2Hn+3wFEJvE6UY+uYIdYr7st3BnPazhh85fYKtV2Kt9UCmWA6G96lpzVK4oAGVn8IFOpQrFfBPg7iSNtRUWTzzR8qXLcaGOQ0HKaoktb9wEZIVkhH2V0Tk5JqOh7SPJUUD/05IdY+lFfxvBJO5aGGa5YCzf2qp3WvzGS2/8yV7HzwH0SefuRyhVCZ7MisJXdgIsoFed6pYxsxOwoHcCJnqmd3jR05P4244vbbVAcpI2JRU30ObNpFhCs26pFYzxta/KdzLBsGEHq7nADrA
 heDecuKv
 ZKBpPlQcbx+MRJzh6mCM/SpaHAGDqU9Hsc8op9RUPEwXQv/b2p4LqrTR2dByB/4ySB2y71KN6u/2bmbOaI0v1wuO0XG0NKTiU64h3znA/vyVXPnUg/b4u4LYpg0zPkuOpHkXxuB3TN6IXytQoVrz5RgTkykiNnthEaI6YMQESmhIpSVb1vEps/pZZdVDz7Eigt1DCBtqE35widdP146ejtbzxMyUjV45SS44NAqyEferpjm3x/rU6e+ojs/m6HQRh14iv3sjwo/xAJAxUjgTkU/8PNLEOdQeGQdhqdY0tkFAiW5PXxXhU/xLGpxuPldQdEqPlyF40gn6NdGt5UOBgilyrSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 7:11 am, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> find_vm_area() can return NULL if the given address is not a valid
> vmalloc area. Check the return value before dereferencing it to avoid
> a kernel crash.
> 
> Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

I think this makes sense from API PoV.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  include/linux/vmalloc.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 3b02c0c6b371..d87dc7f77f4e 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -265,7 +265,9 @@ static inline bool is_vm_area_hugepages(const void *addr)
>  	 * allocated in the vmalloc layer.
>  	 */
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
> -	return find_vm_area(addr)->page_order > 0;
> +	struct vm_struct *area = find_vm_area(addr);
> +
> +	return area && area->page_order > 0;
>  #else
>  	return false;
>  #endif


