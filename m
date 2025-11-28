Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC9DDD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50556B0027; Fri, 28 Nov 2025 02:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28456B0029; Fri, 28 Nov 2025 02:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64B96B002A; Fri, 28 Nov 2025 02:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5FFB6B0027
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:39:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76B8B13AB57
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:39:54 +0000 (UTC)
X-FDA: 84159216708.23.D93EAD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EF431C0009
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:39:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UP0ipruO;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764315592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMhz0tO6gK8SEa9yVLLNq8ATyxhbO6B/DAim97HTDPs=;
	b=Sua/DhBdvqmMU4lQXXZXEVyR6ui6B0yjKj2Zms/uPs4YCgWBsrJP4z2PHq0Qet/2KwLEXx
	vcdC2HjuQQxhwQGAWjHZCfuE1KkKBx1JdXlxsZUyN/BC04wX5/JX4G/2F3z6jGxggEatL7
	QirOse8PS5BveMMxWbm5GtGoUwid0Gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764315592; a=rsa-sha256;
	cv=none;
	b=xkjYn37YjhUXaEJSrz4XLRreJTpDx+783Fi89vJtXc9qk/KlR6KWv9kkMbiODm/xSxNqkq
	Pq1muBVK/5YzTzTD9++sOEwkaDzrPQW1Zlg6SV5DAmjIlxKgfYUxDvw/uC+or6UKvwGvw6
	83rZOP27BeAAYYeicEqQUuALYDsebJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UP0ipruO;
	spf=pass (imf21.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B75AF41A30;
	Fri, 28 Nov 2025 07:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08BDC116B1;
	Fri, 28 Nov 2025 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764315591;
	bh=L3fUvx3/4h6sB/neiDyj0+7nKMrKXGD2gImaI/RwOMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UP0ipruOgOTR/Dg6FIwQ4nodKu+6zNOYwMdVq0WDRzVsRbhBXGIf5AkCZrqZIfM2N
	 KaqzYIk1Zgbhqro9VPRn4M6Ez94pATD4lidhtfX0sFDJxf/Av5Jttb4cN1ZKqmYUoX
	 zlBJsdX+X1PPFL77TctY5FK0/4irX6c/Zs/I/2h4IJuu896+DqRsa6mfWGHDvFN/SR
	 w1PKXsHOMsaASBG0ub9ldcJ3JnoWrSCMtQ6I1bQauSsY3nt9pJFGovMUacwMfFjPJN
	 8EtPjFRO+WgeujcFWzvUasot96xbLtqzu6lDV0hMlBFY2jLCBsNkU98PPLMmBvFSoK
	 Lcai1/OO4Gbpg==
Message-ID: <6d2605e8-409d-4b4a-9729-599dd2526b74@kernel.org>
Date: Fri, 28 Nov 2025 08:39:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/7] treewide: provide a generic clear_user_page()
 variant
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-2-ankur.a.arora@oracle.com>
 <189bc218-8f19-4686-b2ee-5ddc6a0b4684@kernel.org>
 <d3d68f78-bd76-4cf2-b20f-a0f7c838124a@kernel.org> <87bjkq8s7a.fsf@oracle.com>
 <87tsyf58ro.fsf@oracle.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <87tsyf58ro.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EF431C0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: xtzrknihdt9zu4hses9c59wuzq4hr8bf
X-HE-Tag: 1764315592-890752
X-HE-Meta: U2FsdGVkX18HZRVVXklbMGVIAZ9Ges76u3I3+qKgepHAky75/IzKjOIdYDX39bM1Rj5Yrmy0fZTkbqt/UsyyaZv0dP2+PrRzHy1fiyXgajIyRaxZ0kMUBtbBoBBUkDljIUKyHSQXmmzKyD8S4h6RwyQ5vcaS8MriNdWYY+tNjsA2wcyb1qIx7u+uS5fnK9CH15w/lUnWpwWn0o3hI74vDpq2CDCLkFHxYt5SLZYYEDQDjhOOU/oeg9A+lIPSCMVh5TREAXiJCJc6SbWXYu2vsYzdCw2u81JpRM3BfJj4EcuEVgsL2Z5r0sNpz1QZ8yy74LKKkq6g7KpfUxlyiobVYPqy9zHhZv5QVk0p3JK2YfiiJZ3kkNWeMOwe3hLUFX72DYzH5cETyZGSf0mjdGOEqb33EcI8KmNWGiZQCiuiv1RXWSWntunNTNsAmyeOSNgoG6Epd/c4/9wfq+a1kimgyy2uwRn9Xwol+1RFiZYbmKo9gzFcODjFbsdjgwv1DvCYgs0yv4A7BcBybxz3B7Sm7ZWRUoWYbN2QLmhU73O8HZOaN7DmbOtSe+fIlKYf3mVBeVkaSIgKkbi1mKZI92jSqXmjAenfOTsSYFAPKDpD1P3R1qzSN2BU2/saBbm/VLgf7Hc6Oxtz40Uq6UzmD9KBwb5QInPU5AlyG77K4kZblPhYfi+tkA/IENmZLofPNW6qIVkvDVjqxUjIZfssR0uH0OmY7HeEZWNqXn2bnb9elrlpFhV12Y3AfmjII1D5heXw8BDICwd7Gh0jDbos9AjdXQlDZtzic4pLcpQ/wDL30c3XYmAY/Rnpuc0hev+4SJvqK5J1jZzfcW0sp3Excnoro4GttKtYD68A33AgTjxE9MN6mOS5guUJdST+k3gtsi9aw0sT4Az8WbI8iH4AWB/lcfEclXl5RmigprpW7p5TfIRUpKvT1vnWa3F6S52YbSRgbO3KSXjxsyhe2ZegGay
 Rd8XFeLw
 yMTJvCExDkwlfzWouZN0r3V1ATF4G9ekGVe+A2Tr4qUlKFDqXVO/GhMqe+gPwNt6nDcVpYTQ4yV7PTyQjlsQWlB9K3mDao49FmPLRfIvkj4i+Y863XckgmQ+Q3ErrtHRy9XZ9lPiEJrkBRzFWW0L/T8KUVCKtjTwuuHMiVnZFawbD+t8G41HkCkfHDZjuv+4SytcXePdXijNP169Xxm1uZo0g6fT7bkRl9BfFd9cgBtNtstIlB2NIsD+y4zHWfvgBL4dahBzJ8sirUAB59yzP/0Wsd1rfoce9tCqRUu5f3s14YQYLkWBgu88VzjMrgb5OH6QRqcksKMyfAKFyzKu3JvHf5BJe1fmCRIRQzpCIe96bm6vxkvbONwfMGBXzWwVLaE12SyhwIrlFYx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ankur,

Le 28/11/2025 à 00:57, Ankur Arora a écrit :
> 
> Ankur Arora <ankur.a.arora@oracle.com> writes:
> 
> 
> How about something like this for clear_user_page() (though maybe I
> should be always defining clear_user_page() and not conditioning it on
> the existence of the generic clear_user_highpage()):
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index abc20f9810fd..ca9d28aa29b2 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -197,6 +197,22 @@ static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
>   }
>   #endif
> 
> +#if !defined(clear_user_page) && !defined(clear_user_highpage)
> +/**
> + * clear_user_page() - clear a page to be mapped to user space
> + * @addr: the address of the page
> + * @vaddr: the address of the user mapping
> + * @page: the page
> + *
> + * The sole user of clear_user_page() is clear_user_highpage().
> + * Define it if the arch does not and only if needed.
> + */
> +static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
> +{
> +       clear_page(addr);
> +}
> +#endif

WOuld be more obvious if you enclose that inside the same #ifdef as 
clear_user_highpage(), something like:

#ifndef clear_user_highpage

#ifndef clear_user_page
static inline void clear_user_page(void *addr, unsigned long vaddr, 
struct page *page)
{
	clear_page(addr);
}
#endif

static inline void clear_user_highpage(struct page *page, unsigned long 
vaddr)
{
	void *addr = kmap_local_page(page);
	clear_user_page(addr, vaddr, page);
	kunmap_local(addr);
}
#endif

> +
>   /* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
>   #ifndef clear_user_highpage
>   static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
> 
> And for clear_user_pages():
> 
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index ca9d28aa29b2..b9b3cc76a91a 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -223,6 +223,35 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
>   }
>   #endif
> 
> +/**
> + * clear_user_pages() - clear a page range to be mapped to user space
> + * @addr: start address
> + * @vaddr: start address of the user mapping
> + * @page: start page
> + * @npages: number of pages
> + *
> + * Assumes that the region (@addr, +@npages) has been validated
> + * already so this does no exception handling.
> + */
> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
> +               struct page *page, unsigned int npages)
> +{
> +#ifdef clear_user_page
> +       do {
> +               clear_user_page(addr, vaddr, page);
> +               addr += PAGE_SIZE;
> +               vaddr += PAGE_SIZE;
> +               page++;
> +       } while (--npages);
> +#else
> +       /*
> +        * Prefer clear_pages() to allow for architectural optimizations
> +        * when operations on contiguous page ranges.
> +        */
> +       clear_pages(addr, npages);
> +#endif
> +}

Not sure to understand the logic. You say this is not expected to be 
overriden by architectures in the near future, then why do we need that 
? Can't we do everything inside clear_user_highpages() for clarity ?

At the time being clear_user_page() is used exclusively by 
clear_user_highpage() so I expect clear_user_page() to only exist when 
CONFIG_HIGHMEM is enabled. And in that case clear_user_highpages() 
doesn't call clear_user_pages() so at the end only the else part 
remains, which is a simple call to clear_pages(). Why not just call 
clear_pages() directly from clear_user_highpages() and drop 
clear_user_pages() ?

Christophe


