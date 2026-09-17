Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AAE7C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2A26B0093; Thu, 17 Sep 2026 14:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8933B6B0095; Thu, 17 Sep 2026 14:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D00C6B0096; Thu, 17 Sep 2026 14:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 648A86B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:12:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B359A048D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:12:20 +0000 (UTC)
X-FDA: 85224048840.17.C72862B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DE1380006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:12:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mCMXQQCu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668738;
	b=EYnGS1tq6VhJGXFclKbk1fPgjh9ThDMPORTVNdJuVV5PL1/586+q1I+s9+DE8hg8P8099L
	SeFWQFtD97N/6ebx6W1DDNua+VP387YOVUZjBQGUnxoYnWq8lLnZjRcVwXmvvqbvFvuk+o
	ScKKkylXnAi4XVXR+xMqS5iuDJIR/Uc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mCMXQQCu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqyQgMFAJVi2Td/IFUmuzFBF1bi1YpyEHAojG3GW2qw=;
	b=KZYdRR3HSGnsn9Ja+9pPhl2360prqrYFFCOrA+sbTHKK64bxwwJYG/1o16VarKgapdgf/d
	yz/EjS9y2P46mTPMJN5RU+DNuhgRRvwrfsoBDozT0yqfZ71n5FAztb72OY17HXYsYN1Dx2
	+nICF93zgG3iKwQfin1orNWeAs8iUSU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6D8D1596;
	Thu, 17 Sep 2026 11:12:13 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB6E23F86F;
	Thu, 17 Sep 2026 11:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789668737; bh=JRotaeYUDA8OKw6fWgN1iioU01GNC1YxBAHOCuSkCcg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mCMXQQCuXWXGh8CqhS0W7cwhE2pXGdXIab/vrQATUL3/XaFJNt8Xf3XcEukOlMYCK
	 ugh3zQSksUsKim10k1OD4vF/PrNn0SbUDLvpZ5GQyazWmyouKJGKG5+oDmjP89b8Rg
	 7/ZY9aaQUsSH+CtdxVNQuZgcibuXfkywZeR0hrNM=
Message-ID: <19b00695-9f99-4d21-9592-13fad31f85e7@arm.com>
Date: Thu, 17 Sep 2026 20:12:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-4-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DE1380006
X-Stat-Signature: uuc9de8toa74b4kpta3fudoqgbk3xsom
X-HE-Tag: 1789668738-137133
X-HE-Meta: U2FsdGVkX199wAXH4qdSymdjIhmIqngxRxZb/yNzGQttrgvxMASjUg/oz0OcNhruiwWTjG9e3igw/V7N77rAfl3fqQgUiH5wdtgtvHXGrmqeEki/+PbeudZ3x/vKGzjwmVjHECAiN7HDka9tU7lsU8Sl+QbQ2SXy8bG2Oas8jZmCzCyy4bkfXJsOqsDD8aLyZ/uIT/7CD7igyd+bBEbzjiMH5ih3RENC1PHSX4kV2R35Wzf7wbV2tYqA9oF1n0ZBdMUxgmmIunGMVbd1Ln7s1OyuIIQplAmsajkoJz9/sI9U2Yk95ykcQU7wSyIxVqBJzERz3Hb7GckKwH6SMdarT7M8AF6FnVFpl4/Tdct68Dr6ykv25/msRslndqJgndt2pto4optWbwQR16FO38Y+bU11+bwkjNXvYY9bynpq6zrJ9H3y0q9Vd6tqvNtBIqUsMyw7Zoc2vEi0F/aTMXmASbMCo/TxOuOgRFhqGXYUUn4Fevkr5b2qgkgKeRYIWNp6Ob3u4+7x/B9ZdUiR38iaVytpZvr6wzBKpg7zk/UPR99R8KKzaGwwopDdaYw6/efQ2ze9JMcJ+X09gTlG3S6XfxyBgnS8XatscL+2otxAMSu7eV9YDr/PDE7woeuo+pvxUzakjRfK8jq1tJvYajKDgErPivTIucqF+vnu56MQvl3FW6U9UHpkhW6T3VaVhGoTrHS+kKERziM+nlFZE0DE4i92IC92/RKKzrBAS1JYPm9ZVrg5J9a+lzhowNjVXW6+0OZytI7lHZezndjdcruOpwRJ/ktXTGXSo24ZVp5VpkoHE0XyU6q2VrLfTa63/GZzI1XGN9+GyP3EzjDCBtTrBvF6NeOv0WKKVi1ODggmzKHEKVY6uPo9UpNn1OzKeBuGKI01R6uVc8d7kG1Re0xLkKcu+LcbXj+xmG/QwL2IttSHCJ9arho5GkIunhbK9GQgnbn1MLbxJX50wMnCB8l
 gJEtD79W
 RdPtlY+GK7SPEOusthXNqYsOVqED2NiFq5iz2H2Xhf9NupiZkwguenZMCPaMC1ygM0vrALYP4QETc6RMC8a65j1ZnZx8FMR5eK4A+Qs9Fx4/FqVYx6H2ZD/NkNUsR41xfX3mELFN6tel/zZKG7v4EM5BJR88Xs1DI+MB6jNXMYExWImsCyxYJzlxb+M3laXy4bMPxO6eqeJQAlmzn1ul/+T9fJptFXyWfZfRhGAPp8gU2BTG+8aldSgcNbRfIYj3h6C59m691JxjYkep2ef1lDayv/mbBQ1eDl/CLA94BALBpYB656wiN4uZElLzpwVcEREfpkTobRw6Gv3/BAEtGwGLNOJftY0aQiL86u0gurmGpaYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> set_area_direct_map() always updates direct map alias permissions in
> single page increments.
>
> For HUGE_VMAP areas it's suboptimal. Not only the loop in
> set_area_direct_map() needlessly has more iterations (e.g times 512 on
> x86), but it also causes fragmentation of the direct map that could be
> avoided for the HUGE_VMAP areas populated with large pages.
>
> All pages in an area are always of the same order: either same-order
> large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> cleared or when huge pages allocation fails and fallback path is taken.
>
> Instead of updating the direct map permissions for every order-0 page in
> an area, use the area's page_order as the loop increment and update the
> large pages in one call to set_direct_map_{invalid,default}_noflush().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  mm/vmalloc.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 5506b180f5c27..6ed6c160abed7 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3367,12 +3367,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
>  				       int (*set_direct_map)(struct page *page,
>  							     unsigned int nr))
>  {
> -	unsigned long i;
> +	unsigned int nr = (1U << vm_area_page_order(area));
> +
> +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
> +		if (page_address(area->pages[i])) {
> +			int err = set_direct_map(area->pages[i], nr);
>  
> -	/* HUGE_VMALLOC passes small pages to set_direct_map */
> -	for (i = 0; i < area->nr_pages; i++)
> -		if (page_address(area->pages[i]))
> -			set_direct_map(area->pages[i], 1);
> +			WARN_ON_ONCE(err);
> +		}
> +	}
>  }
>  
>  /*
>

