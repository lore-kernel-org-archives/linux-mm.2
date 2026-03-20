Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111A31093190
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7100A6B0363; Fri, 20 Mar 2026 04:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0D26B0369; Fri, 20 Mar 2026 04:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D72C6B036C; Fri, 20 Mar 2026 04:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFD76B0363
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:56:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15F0613BB87
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:56:41 +0000 (UTC)
X-FDA: 84565835802.07.7AE055A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6417FA0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:56:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwWduJK3;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773996999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgcAZNZhW6hoKemEt1fgC5r6U169uUhLD+jpaJXLEoM=;
	b=VcVDzY4PqsKzI73SksW946pZuUONBJzFUUQlJPZfzEJl9g5qTJHrYS7qKIEOQkb3aetD9h
	sCiZyYgPsvh9HWyDiYM0hvgVUhZNv6C9j9bniglQy3TIcfbhIUMFdfmBNOionrtlQah/rO
	30YgBsv/cxCICQfj074O8OzKg2Cq2Rw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwWduJK3;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773996999; a=rsa-sha256;
	cv=none;
	b=qbQA4nmiGk4E0NtVFSgLt89dMO/Yqfxz3yZGi9/bUz2xAM1z2tVKhPPe36pb1VA0zq75+T
	sHO1K7+faB7nC97WfNsDfyvTzqc9sQkH0e+YMzMQj9c9dAyBtC7CpCFMMotHCj3b+1m86B
	Q6QQsgK8uX32dqo9jtbzBnif80CpPrM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C384560127;
	Fri, 20 Mar 2026 08:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6F9C4CEF7;
	Fri, 20 Mar 2026 08:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773996998;
	bh=ZJNfT3lPJxzaGdT6bGFu3WgbabeykkSDcAaOFE+CTEA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IwWduJK3Q0ps7Q3T+6/cPljz9bzlzMD7YqehSZQMUvmFFsKNNaEaT95LdBmvO9GZ+
	 lfFcqCjV8DbrRsRL9Ejn3CjOPulO8Hz7jBmzM6QLuIdqFibLx3wFc/nlIqvK8ftg5i
	 m/tEnf74BYEjDiRWWfvBLfYs2Qa/MhZdCaz++kKi75vnjLKGmYep338ZfTx5cAa3dk
	 VHR21V/T9FAgHlP3jIcO9L7mmeBt9rTSotZmIfD7CN+FQH0+tEG8pVuIivy2p6BrB/
	 EmW9cbnzzY4hTZCmlQhlrmLpYqdTu6BZ9aEzMIyAl0fxpaL6QV1Wd2lyyDxPBmUQVG
	 jVPTvbJrZeGBA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kasan-dev@googlegroups.com
Subject: Re: [PATCH v2] kho: use checked arithmetic in deserialize_bitmap()
In-Reply-To: <20260319210528.1694513-2-elver@google.com> (Marco Elver's
	message of "Thu, 19 Mar 2026 22:03:53 +0100")
References: <20260319210528.1694513-2-elver@google.com>
Date: Fri, 20 Mar 2026 08:56:34 +0000
Message-ID: <2vxzzf42c20t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mm5j9shp5jg361k3a6baqzsotb817rgu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6417FA0005
X-HE-Tag: 1773996999-470429
X-HE-Meta: U2FsdGVkX1+Riql0szzjZlX+UqncBC3sdwuuo+8q3btt/nBVzcHs0/7gWnaGB1EjcLADDveiwlw0nFax62duiV+I51FnZglw/dgdc/naDfgU254C8bV/d+oKSJACpJe12aggr0G3AKWZYQPPmHatd/c6Ne48AATHNy6UVGvCl7eDeCVbnXCNBzdxnxH4ThWMSAjCR3oaLTC95YllbdU6KEvaccUIxV39eFJKTAQCLgz2RnlUoGshvlJzsUfh54+QCTdrCyq9Whuu28UJoR/Zxx8gzBGkUKXbcoU2784uj8bp8u4nvt+kCc8n44LAZwuT6PX6BfqptOM+mgcf+1A1blh2ygX/7zZNqJSrnNBF7q3vZe1T0AcR1Jv7R/RsGvovat/aNebFh9u9cqJeyRy5jJYu/jXe6OLn3lvkXUnC7TWTFDhDKNKnEefF7mJVnQxnACUfh3cl4123yW59Kte4frbly+GgiZeX2DCxTd6xxEel20auDNZckCqOSn4Ozft3paEuXsBydpTSbj3rpIu4Ff/4ZEuI3nJSKIifzhdvBOWksdAufAwB8qGP28iF2RfDLYUDDM2avdgr3djVL5ZXfp/s3QwVnf9wuxSpGyotXyN/8T33Z623q4oG8jkSbwYbD6na9VpqNvgXC8ST4ycprhkp7DZOHx9zxt3boNIFQNWIUoQW04lIFJbx5HqXx2MHKmYf3wya5BAYjkqxgRh8gSF2k0XgExDUq5teq/k3HXTW0pHF5f3MFL36JawADO1dFb/DYk5FeLYiOm2ZdeQ++MxZbXnerdIOm3f3RN5zAbaACVDjz4zoiaNY0hXnH6OPvxc4uSCXHAL7ciGNW5uIeIGVGK2YEz471ZsrHeNNrKgmdQIpXE4RxAyDtV4KusPkkHB/EUYRXwMb/9hm7YMoNN7UV/JpNUWQx1DK1/KsCIXZajUpqETFYLIbiKsAAeOH0KDMvKGTVL/xLdVlz0J
 SoY5RM2B
 A/REu2KJCKnK/pDm7vRdv5n/xH2KvjyJ+lZ5gW39VHM8zLcT9WzBF0lQBaiQea/9xbw/zrkvBdE50ZP+Az36RNS7wNTeYlx7Ob0Fban5nAmADr6h1ALNDadQMPRTeS09n+EUvgVBog6KBrQl8MnbuOmw6axeVAjvQpevRuokeZr6PhY+RMsEPkXwmOR/frmjS1954iUhcoDl2iHG+9g7N25PYGZJ3pfgOfWV9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Marco,

On Thu, Mar 19 2026, Marco Elver wrote:

> The function deserialize_bitmap() calculates the reservation size using:
>
>     int sz = 1 << (order + PAGE_SHIFT);
>
> If a corrupted KHO image provides an order >= 20 (on systems with 4KB
> pages), the shift amount becomes >= 32, which overflows the 32-bit
> integer. This results in a zero-size memory reservation.
>
> Furthermore, the physical address calculation:
>
>     phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));
>
> can also overflow and wrap around if the order is large. This allows a
> corrupt KHO image to cause out-of-bounds updates to page->private of
> arbitrary physical pages during early boot.
>
> Fix this by changing 'sz' to 'unsigned long' and using checked add and
> shift to safely calculate the shift amount, size, and physical address,
> skipping malformed chunks. This allows preserving memory with an order
> larger than MAX_PAGE_ORDER.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Marco Elver <elver@google.com>

deserialize_bitmap() is replaced with the radix tree with this series
[0]. Can you please redo these changes on top of that?

Also, a couple comments below.

[0] https://lore.kernel.org/linux-mm/20260206021428.3386442-1-jasonmiu@google.com/

> ---
> v2:
> * Switch to unsigned long and use checked shift and add (Mike).
>
> v1: https://lore.kernel.org/all/20260214010013.3027519-1-elver@google.com/
> ---
>  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index cc68a3692905..0d8417dcd3ff 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -19,6 +19,7 @@
>  #include <linux/libfdt.h>
>  #include <linux/list.h>
>  #include <linux/memblock.h>
> +#include <linux/overflow.h>
>  #include <linux/page-isolation.h>
>  #include <linux/unaligned.h>
>  #include <linux/vmalloc.h>
> @@ -461,15 +462,29 @@ static void __init deserialize_bitmap(unsigned int order,
>  				      struct khoser_mem_bitmap_ptr *elm)
>  {
>  	struct kho_mem_phys_bits *bitmap = KHOSER_LOAD_PTR(elm->bitmap);
> +	unsigned int shift;
>  	unsigned long bit;
> +	unsigned long sz;
> +
> +	if (check_add_overflow(order, PAGE_SHIFT, &shift) ||
> +	    check_shl_overflow(1UL, shift, &sz)) {
> +		pr_warn("invalid order %u for preserved bitmap\n", order);
> +		return;
> +	}

Isn't it simpler to just check if (order + PAGE_SHIFT) > 63? KHO is only
designed to work on 64-bit platforms so we know the max possible shift
already. Is there any reason to call the proper overflow functions? The
only reason I ask is because I find the open-coded check easier to read.

>  
>  	for_each_set_bit(bit, bitmap->preserve, PRESERVE_BITS) {
> -		int sz = 1 << (order + PAGE_SHIFT);
> -		phys_addr_t phys =
> -			elm->phys_start + (bit << (order + PAGE_SHIFT));
> -		struct page *page = phys_to_page(phys);
> +		phys_addr_t offset, phys;
> +		struct page *page;
>  		union kho_page_info info;
>  
> +		if (check_shl_overflow((phys_addr_t)bit, shift, &offset) ||
> +		    check_add_overflow(elm->phys_start, offset, &phys)) {
> +			pr_warn("invalid phys layout for preserved bitmap\n");
> +			return;
> +		}
> +
> +		page = phys_to_page(phys);
> +
>  		memblock_reserve(phys, sz);
>  		memblock_reserved_mark_noinit(phys, sz);
>  		info.magic = KHO_PAGE_MAGIC;

-- 
Regards,
Pratyush Yadav

