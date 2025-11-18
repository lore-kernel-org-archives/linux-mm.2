Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B7CCEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26EAC8E0010; Tue, 18 Nov 2025 02:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245D38E0005; Tue, 18 Nov 2025 02:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135A58E0010; Tue, 18 Nov 2025 02:32:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F33C38E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:32:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C86551A03F7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:32:55 +0000 (UTC)
X-FDA: 84122911110.20.38459A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1878810000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:32:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Drs95Ujz;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blwnirAnAkmv78t7cABzmJXh/5QAR1H1jXL02axC/hY=;
	b=N7hIwhkmgEGCR3wXjkvByIj4fh+MiBOSpB73a9YbONHQji6k29A7aixXMs1SFreYfMnwFo
	5i+0BUsdotd3xtCB9JfbW6u0F2RjG5TlYjKLIDDBkM1Iow1nVp8zvs0XkGlntQiD0AFC5R
	cYi3ccjkFCMDUg8MZb+kQj+Bx6odg90=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Drs95Ujz;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451174; a=rsa-sha256;
	cv=none;
	b=tQNbopKJHyiAnEiPsxkrtlKoolxb2DReb4BMWKGGCYYvyZYzpsheA7jLsLCgmRhYDl2B+i
	2mhP7QDIer03yaRUXRjgeuQYzr69za2kQrmgGtJhcUM5Eu01nDF0QUB+44KPbjEnMEeS7Q
	RtWdzX51MaYJ/ZwjEjsHpiGvsktzaaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58F456015F;
	Tue, 18 Nov 2025 07:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F94C4CEF5;
	Tue, 18 Nov 2025 07:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763451173;
	bh=ApGJpvP5hKECH4jNdONY7ygRf50YGNmepwxYmKGJWWE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Drs95UjzV2nXp7/IzZfJ7oZb7Ii6iiEezfgE/hs+hBod40DDo5IVA8bnXKf8Ffl86
	 Z2Fy76KFc/LOZJtzBClVZ64sT6raCThm4ZXBfh/hT8gvV/oLZYyQ7PtkfzbLGM1bKx
	 pQiKA++tpGr0REG34qybC3mXOr6GKmTH8iFdRPngJaTOBLQhSJKrAmDkCjbVDKcWDL
	 1Q8aaN9il7z5cUOH7iCCeQ+jsOYMaXR6J+2X4XmjZMrYRkzAoMqjaLmoYMtQ7GfSXg
	 Pp2eFVC+iswWsGQf4vjJM2uqhWwswVpoICMKPS+1bWnaEYfK2vH3iBb4qKH0dFqQX0
	 8brthYY2aRZ0w==
Message-ID: <c96ff5f1-bc4b-462d-96ab-3aaa73ea334a@kernel.org>
Date: Tue, 18 Nov 2025 08:32:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/7] treewide: provide a generic clear_user_page()
 variant
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-2-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251027202109.678022-2-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1878810000E
X-Stat-Signature: s3raomiby383opsma4qjpayhekrf17pe
X-Rspam-User: 
X-HE-Tag: 1763451173-942558
X-HE-Meta: U2FsdGVkX1/LuEOSJ2eJTz5Z4/n0xtZ1rcWD3ExvQIUerRYyOo55JC+Vwr9aML66OCR8q1BPj1IEb6i+1vFVCtVd9pWjD4cFNCDdi01YMUsl+o7QBRxclln3xfwkjXfdjYjwYDpOj4HXTNh9r3lVGioNoRZa1u9pzHj2hsX1dvrWKDHEd3iXOD7/dEfgCjIiYChXnvf2IGltHphcWlOR1Cq7RuWYI0WWb8xIoVUQTYgwbHfdw7zlzJUHhaU1GcxbfDQsdxg2jhUmz6qnnLJDCMn3hmhT4alZIy9o0aoQo5+BvKVV85muT2J9mz7U1wJVJAonCsUnODbYY81pAZFifF0/di9287Me5BQ5xx8x595qHrD4sf1fYzox36ektfF8mX6+vPlo8gYF/tTUPQ3Cwb7vlE69yhhgWMyVK3pHvWsPUC2vqteA+dQLoVjCrrktDI7AcVI8E3DqLmfw7opnthT9mWzzHjOo2h64a/K2ZWCTpTU3eGR60lmZmIZ4Tw8nOYjFvpyI3srmPPhbhswIFBf0iAzwsyZEkDXEhd8LVb51zzLFIV6BhmP4f9PZ6Vi+mOani3fHmOJLaxSeEAq3C0d0hoIBjT/qwd8m9wdfW4m6p0hQknO2w1a2i6c4+sWXx+p93nveLv8vKnSaf/z99zbEjcRB8vHGxwuW1GIYf1g+J8iRmNCkWMa9WXVUPNuxouCthXPbwknOTnhAVBa0PTdeMl+MhuwzSqoggwbjvWbE03ydWobb1TD454ZgruRRzX5lHM0gRah6aWOb7tScJMozT9PNog1QEJJVd8+5H5fyd/zR46qF2UmhVkKnKhTfPfoWlK6rxUYtNIYiUKxYVvf2tiPVz2VykgU4mAk6imXDb1mrMcKm/FJ0zRFm4UaB1VUy3x1p5zl812PKwOIxQWzzFXs9/O08uWzKgZTthqOAbch8M1fZ+pVQFis8NBjG7mVXl71UpDHcB8neGfF
 z5zYNCkQ
 frx6b6XgoVgMTewXOXMVzo/YA2iSYi5oMXKK5D4lYj/nwTML8TnUUao8JZHXw9SWgQIxIFd98qQsD+VLC3gXWH8Pp/+uKWr/5aTd6VoISjHZhKOaxQjPCGQqx7EcaYHrKJ9sVzn5VUXUPg7ujxZLTKVt15cDyRvnubwSehmAnt7nQ2ASBL1nKR04WqJ6P9CODPJBUol3cIP8DCcJGFNvXFpQayNE5JQ8BP1E0hTXJy5lkiDap5qiR+LwKnuoi87r+DZ8Ds3x2ds++iVwEtk3loNk1qfPOiorhblozAKQUy3bbTEjDCO+V9M/lCZbGNuR/PHj5YX+uR+aPeEg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 21:21, Ankur Arora wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> Let's drop all variants that effectively map to clear_page() and
> provide it in a generic variant instead.
> 
> We'll use __HAVE_ARCH_CLEAR_USER_PAGE, similar to
> __HAVE_ARCH_COPY_USER_HIGHPAGE, to indicate whether an architecture
> provides it's own variant.
> 
> We have to be a bit careful if an architecture provides a custom
> clear_user_highpage(), because then it's very likely that some special
> flushing magic is happening behind the scenes.
> 
> Maybe at some point these should be CONFIG_ options.
> 
> Note that for parisc, clear_page() and clear_user_page() map to
> clear_page_asm(), so we can just get rid of the custom clear_user_page()
> implementation. There is a clear_user_page_asm() function on parisc,
> that seems to be unused. Not sure what's up with that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   arch/alpha/include/asm/page.h      |  1 -
>   arch/arc/include/asm/page.h        |  2 ++
>   arch/arm/include/asm/page-nommu.h  |  1 -
>   arch/arm64/include/asm/page.h      |  1 -
>   arch/csky/abiv1/inc/abi/page.h     |  1 +
>   arch/csky/abiv2/inc/abi/page.h     |  7 -------
>   arch/hexagon/include/asm/page.h    |  1 -
>   arch/loongarch/include/asm/page.h  |  1 -
>   arch/m68k/include/asm/page_mm.h    |  1 +
>   arch/m68k/include/asm/page_no.h    |  1 -
>   arch/microblaze/include/asm/page.h |  1 -
>   arch/mips/include/asm/page.h       |  1 +
>   arch/nios2/include/asm/page.h      |  1 +
>   arch/openrisc/include/asm/page.h   |  1 -
>   arch/parisc/include/asm/page.h     |  1 -
>   arch/powerpc/include/asm/page.h    |  1 +
>   arch/riscv/include/asm/page.h      |  1 -
>   arch/s390/include/asm/page.h       |  1 -
>   arch/sparc/include/asm/page_32.h   |  2 ++
>   arch/sparc/include/asm/page_64.h   |  1 +
>   arch/um/include/asm/page.h         |  1 -
>   arch/x86/include/asm/page.h        |  6 ------
>   arch/xtensa/include/asm/page.h     |  1 -
>   include/linux/mm.h                 | 22 ++++++++++++++++++++++
>   24 files changed, 32 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
> index 5ec4c77e432e..d71ef845deca 100644
> --- a/arch/alpha/include/asm/page.h
> +++ b/arch/alpha/include/asm/page.h
> @@ -11,7 +11,6 @@
>   #define STRICT_MM_TYPECHECKS
>   
>   extern void clear_page(void *page);
> -#define clear_user_page(page, vaddr, pg)	clear_page(page)
>   
>   #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
>   	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
> index 9720fe6b2c24..cb4d69b473e6 100644
> --- a/arch/arc/include/asm/page.h
> +++ b/arch/arc/include/asm/page.h
> @@ -32,6 +32,8 @@ struct page;
>   
>   void copy_user_highpage(struct page *to, struct page *from,
>   			unsigned long u_vaddr, struct vm_area_struct *vma);
> +
> +#define __HAVE_ARCH_CLEAR_USER_PAGE

After talking to Linus, the preferred way here is using

#define clear_user_page clear_user_page

Can you adjust the patch (+description) to avoid 
__HAVE_ARCH_CLEAR_USER_PAGE? If you want me to do it, just let me know.

-- 
Cheers

David

