Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6320ECD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 11:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CC86B0088; Mon, 22 Jun 2026 07:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3243B6B008A; Mon, 22 Jun 2026 07:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2614B6B008C; Mon, 22 Jun 2026 07:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E31FC6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:45:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62C5C40105
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:45:45 +0000 (UTC)
X-FDA: 84907369050.11.0C24DC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 88BF4160003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:45:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yy+7bd7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782128743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JBsCDSqStclSYNDRHkOppan6Uc/0g5zBLrT/zyXuAc=;
	b=QNjpFaHeszGk7T/ln+MZxQUS0ruUUd7QOSk4OxH8Zsmz5nqpCdcpQcG2P8E7c8PCsI0jol
	z9pN34t+Na9p1wtg1hvEIUlI8yce6FAEFs0CokYPve9Ez/wfnOpkgoqBt9Vd3eUDONaMn5
	/kEzct7jlXvLXoQk+JaOhrsfwtoUtr8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yy+7bd7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782128743;
	b=YayDccWcSBWJaP2IxdjDFMCxwb3jcE25pcEOHE8NOeUC2bujVg51JsdalWEMmCrPZcP7JW
	bVGKN6heBAVtGe9K0ejSq8ILgN2vvGQmN5ruQ3vQKFDBaBrhWg2OpwyELYjHuRmKxFXiZo
	W5fT6iThsRRhQYMuHQSldTGdUuvfZ9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B17EB40959;
	Mon, 22 Jun 2026 11:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C156D1F000E9;
	Mon, 22 Jun 2026 11:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782128742;
	bh=9JBsCDSqStclSYNDRHkOppan6Uc/0g5zBLrT/zyXuAc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Yy+7bd7wWK11Akz64zjyb9ETsTQsEDXkuUsN6tcHwpwvYCMhDbHlrqwp1+bwrkKYq
	 9KSylJf5mnx+Y4V7oJ6C1tWzsOeTt89DV14ERJ7HehMvWf1x9Hng4jYsiYa8Ti9UjY
	 ZIuD5GfqcJBgqy+od90T0l2BwSc530EHDZvnfe5KIUvZHtpWX6tGecSYSTFAY9iszE
	 tIq+nduxxxT2Kq9hdisGg+S0BiSc6rAxsoIEsEj+VXmjcQqaFdKYpdH4tD9dwm1dLP
	 B/C1OAjBp+zksOnIFZBdV15EVBVXr/mqBKhCnemobrsyKy4TW5jNjyqxujKxUdJie9
	 PZCbkX4fvk4ag==
Message-ID: <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
Date: Mon, 22 Jun 2026 13:45:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260622091539.836531-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260622091539.836531-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88BF4160003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 86hrbk7fyj58ymoaniq9tjp9pdc6w4bz
X-HE-Tag: 1782128743-849214
X-HE-Meta: U2FsdGVkX1+eavRze3//Lf1AYeEhTchhmGvWvqOf3gVu5BUj5HjciQtEP6QoQBYWaGk4XmNUgxkVGzTEK9qfEoxNo/F/y3Z/l+LELaWfGf6Uf/6fvJO9ztCJ1KkR8pqIPXDgSSeq+V8wnp5A3EjtnEOJNeXSetbMF9lWCCZ6FfWAKff3eRWDoFAIgh0XF+7mSK1imxoe27EqGSzSg763VBeu2aoXe1vOqb4KH061zLcF5wT+jqsIJ3T50OQFbHVi0JMovNvw0e9GrCwCkKaSnIVAMbBKBUTRsM0L7rJPOMFwAyZ2Z17yOsKbqrIUGTJ53aHE656gRp12YlG3LbQqv+liut79j9Z4VoybF7HiMeUrBS76+oWTX3ZyLPQXAoe0HKnojLqcNUY9gNeA/FdGnp3mTHAceo5rWnub0f7o3xw/9EkYnwnmEELh3cP5zoUbRNJGF1khlXopFSZ5IY/TXUZufci8PTDdqqmVHFVOU2kehXh6BP7j9mcWN5oBisH2IqLy1tsguge4j4z4VDNop15+K1jMy/qdoJXTPgxF5e98awGCMjAXjqCeif+cgjCmvlOCrg9v5jRep1eQjvyfBfdDiUkmS/A+MLQKYAVvrT9dJF87iwrcnkUdbCXGiKnpyrOi/9XRa9KTz7JDKfTinND8EEXGYeSFpjpZgzRKeLPsiPnAZNUBc4cgf/lD7KUbJB8X6YUoY20+DmNN2W6UWcIp+SLOCL6V4B1/YCRfy/yb4WyfP9vmFwRayXQToWj0HOOuJNFbC5MWCCyj/BjfTR4vLQdihNpUprrkHU/vcMCh74PX1+6EI/NH56t9stfU4Wn4GHIWcbexeuRWm9fpta+QUv2eJoy2kpUt1Y0sxtKFbgxvji9LnM+vJD/MgDEUeFuaMHoBtjWgkB4/XgNdZCW7QohhBlr3OV9xYcOurE3xqeQ489VAtZD1Q8yQlUQrW83ZSJrvRcNj1PPQWsD
 AXnTEu6H
 39X2WaPsFSAtICTYTKeW8Dk7ct2dAFNI99+tco+uV2fEUeBewX/7P0D/i19azCSqQsBePxfmx4KtWqvzx/7x3NxvVYYEpZfPE/4vYMP0VlEo3QhnWsF2CZCQ+GNnHGJ813C24iwmx9IU7HMve8S4rYJluIugxnrkMuRwDFSFoiR84beysS0JC3UrMLB0hfXrIolFTHuWDa/6x6MpZP+7RP4/ZoD0lLLO6WomRg1zViH/fHdiJBhbe6VpZj3FhUM9HUPlDvzuy9K+m9FAGOkbLFSz35JnE3vWD2rgar6yKqOjTE24/ZsHwz+ED05k0GmTT5w4RYppfTLaJGUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/22/26 11:15, Jinjiang Tu wrote:
> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
> when KSM is not in use. As a result, tools misclassify all anonymous pages
> as KSM merged.
> 
> In stable_page_flags(), if the page is anonymous, then use (mapping &
> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
> 
> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
> 
> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")

Right,

#define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_ANON_KSM)

Which we later renamed to FOLIO_MAPPING_KSM.


Before switching to manual flag checks, PageKsm() translated to folio_test_ksm()
that checked whether the values actually matched:

((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_KSM;


This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
interface), so it's not really that relevant for real workloads (debugging and
testing).

So not sure whether we should CC:stable. Likely not.

> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  fs/proc/page.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index f9b2c2c906cd..cef8ded97610 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>  		u |= 1 << KPF_MMAP;
>  	if (is_anon) {
>  		u |= 1 << KPF_ANON;
> -		if (mapping & FOLIO_MAPPING_KSM)
> +		if (mapping & FOLIO_MAPPING_ANON_KSM)


Wonder whether we should just do

		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)

To match what we have in folio_test_ksm.

(although I doubt we would reuse this flag for other purposes, likely
it's more future proof to check it like that)

-- 
Cheers,

David

