Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21888C79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE8E6B0098; Wed,  9 Sep 2026 13:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADCB6B0099; Wed,  9 Sep 2026 13:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C36C6B009B; Wed,  9 Sep 2026 13:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E773A6B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:15:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2217E120296
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:15:00 +0000 (UTC)
X-FDA: 85194873960.01.9248141
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6712410000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:14:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TectydSl;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmOHtlkwAibVRWrf6jBbqPon1+V1g3DbJrK8wybEPH4=;
	b=DDlq4nib7Iv6oHDR/5BHVuPUdLpAE2ZExi3HnS5P8yVTgj9+cjNPGa7Vn1/BYY5IzlFgT/
	4AazW7H8dbggdlXjgOHZnclRPqiQRHI9up99oQyjK8iHne9rgMFYjYZgNq9gKfs+xLY69x
	WKWjqUcUgs2AF4pZ/Wbh2yBOb9ksPmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974098;
	b=MUFZ3/U5oOU21qWavuEiy0uman042Wm/XSYpkvCxziSE4JRQa4BYjz7FYcjNy1CeOu7op4
	KzRNiV64vhJtuXfSxd1aUCEyixJdA8DG5TwsQsGkZR0PQx4Jat5vD01I4B7e+F31hj3fxc
	ADINri+ooomU+saV//EPh+PhHJ6cUx8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TectydSl;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D41340AED;
	Wed,  9 Sep 2026 17:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495661F00893;
	Wed,  9 Sep 2026 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974097;
	bh=DmOHtlkwAibVRWrf6jBbqPon1+V1g3DbJrK8wybEPH4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=TectydSlKEMFQH6KGXygMaQ3DW+SZaJsyqJFazoo0mTTnNYx+TmNnHUPNyqVX4gM4
	 C2YCSjECs604S7NxtZrXnlYKG8CYodJdKRhYMCysYLIpom8cOULCW1vdZc24molrsM
	 rqr/X+bZa4rtB5A8zZr/8ElSNzntXYc4pLP3aX0LE+QK+1Lm88Xt/ebWicHFeCMIU+
	 xV7wG23kR7GWuukN/0pq9mDemnwpvzQPjmfA6eMbYTactNi5CwVJv4WZcN4j45SulA
	 c4RBRdIReCUs8hOqAQG6WaHcaPFh48LdJ8edfmh4A2YescnwILX+cxaHQHo9PwenGg
	 P5q0VbXjAvPWw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 2/2] memblock tests: cover allocations below the low
 address limit
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: rppt@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <178874362959.1415955.5009708808960886376.memblock-v2-2@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc>
 <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
 <178874362959.1415955.5009708808960886376.memblock-v2-2@tychen.cc>
Date: Wed, 09 Sep 2026 20:14:50 +0300
Message-Id: <178897409075.1489479.6187209873282102376.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6712410000C
X-Stat-Signature: t7myhckfasqxp6rmbyrzf6py838qmmy6
X-Rspam-User: 
X-HE-Tag: 1788974098-513540
X-HE-Meta: U2FsdGVkX1+quk3dpz0N+KBU/yhjGffQogg3+MESqUxQVIlW2vYy55H7Y3PchwbKEqBKWXiTh0USF9RGu5WoSumwLfxf4jE1ibG2bqMbG8TeMiq2lDEAXkcuuJ4SuGOGVMaUYI3RI6k+y3Q4YfmhydZW8NTLdJ/dxa8Vevt4d1juaTBiihZwmxwiSL9Z0k8IxLxuLZxKl6mWxlHaZA2RHkZcfoBX22HFZ/ahSSPaBafo8lBaIRMyuEmw0xVUYPJDYcerms/a2Z+WpcfBocyi8r/JwfESrSqezEnVIi2GqEKAYuEJXR8tIKi7wxjhmcBq1EdgyGn30qsmeYm7UATcUUMud58eeBDfGyUvwlA3ls1btVfANUsdiNn1y7+QvbTR94/Skjo9BeHoRg7CmU47AWfAqj6XlZPYy1G29x44CqRRm9B3/dtSlIIp2PIFXmPanT3qrl53z6c37xDANFwBMCpPoTazHmI+paimaAHCi2kzfi/eZos0RO6SeECmdNn/apF16BYLFEQ2bYKdDk2cK7oIefC9Ndernjv2R/A8dodoOox9GJBzSqECTeqEmgfYC0ovihZnJX+O7WLPowf7BII9jwL27/d6BYFqr9SczGykGYgV+093OAcVQsl5F/8y4AseMfvKvgfbPmteWOz01rjpAKg2P4FXLFvJkrtdLDr6xi8jt0e88Qxnt0QYVX2aoPswO047BuPDMj/MN+1qFYvY9LocPe1ywV+RT1kBQqnD3MSBYs5gpYeGZqEDmIi1AUJZ8hWCo06SG5vg2U2fEiobAneWOUBtt/69Px9tGXyPXm/bNw7gypQUzE77/u4GS18DLk8XWvtBgP8DAQ8sZD/uoYa08GT305jXON8RVpJmr1Fy7BGstnN04ibfGOsTIBwGYZb72lSAtWsJ2IP252GRBPw/TfjOt+C3I0LTAYwelMHPGdpFQO2yZYYRJup49mK81jM7ZzSNJEgmsUE
 3KWuH0xk
 83+yjm0yDr2XGVGKTTs6buAIDOQQrthwGy/TOqUCWy9IsTL8QYnY6CQhiy26v7SFVSQm8hfrtpJ/N5vyjhhVnb1AnpKPAChvjndD1vYM8V+/M2QExaMIil5C9E9pmzrjNznkNWT1k+Luac5AD6PeEPLJt4bxU6oZs6zR+wqZ4lgZwqyeaspExw2Z0+iu/KiQ0AtYwu+NK2g3n6TkszZEHc8LvrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Add memblock_alloc_low() coverage using the simulator's low address
> limit. Exercise aligned allocation, an allocation whose last byte is
> immediately below the limit, an alignment constraint that prevents
> fitting below it, and fully reserved low memory with high memory still
> available.
> 
> Run each case with bottom-up and top-down allocation. Check zeroing
> and reserved-region accounting as well as returned addresses. Verify
> that an unrestricted allocation can use the free high memory after
> the low allocation fails.
> 
> Document the registered memory range and its simulated limit, clarify
> the allocation boundary, and remove the completed TODO.
> 
> Assisted-by: Codex:GPT-6
> Signed-off-by: Tianyi Chen <hi@tychen.cc>
>
> diff --git a/tools/testing/memblock/Makefile b/tools/testing/memblock/Makefile
> index d80982ccdc209..20524fcbe3c72 100644
> --- a/tools/testing/memblock/Makefile
> +++ b/tools/testing/memblock/Makefile
> @@ -7,7 +7,8 @@ CFLAGS += -I. -I../../include -Wall -O2 -fsanitize=address \
>  LDFLAGS += -fsanitize=address -fsanitize=undefined
>  TARGETS = main
>  TEST_OFILES = tests/alloc_nid_api.o tests/alloc_helpers_api.o tests/alloc_api.o \
> -		  tests/basic_api.o tests/common.o tests/alloc_exact_nid_api.o
> +		  tests/basic_api.o tests/common.o tests/alloc_exact_nid_api.o \
> +		  tests/alloc_low_api.o
>  DEP_OFILES = memblock.o lib/slab.o mmzone.o slab.o cmdline.o
>  OFILES = main.o $(DEP_OFILES) $(TEST_OFILES)
>  EXTR_SRC = ../../../mm/memblock.c
> diff --git a/tools/testing/memblock/README b/tools/testing/memblock/README
> index b435f48d8a700..13b7f58b2eed1 100644
> --- a/tools/testing/memblock/README
> +++ b/tools/testing/memblock/README
> @@ -67,13 +67,13 @@ memblock
>  |-- tests
>  |    |-- alloc_api.(c|h)         -- memblock_alloc tests
>  |    |-- alloc_helpers_api.(c|h) -- memblock_alloc_from tests
> +|    |-- alloc_low_api.(c|h)     -- memblock_alloc_low tests
>  |    |-- alloc_nid_api.(c|h)     -- memblock_alloc_try_nid tests
>  |    |-- basic_api.(c|h)         -- memblock_add/memblock_reserve/... tests
>  |    |-- common.(c|h)            -- helper functions for resetting memblock;
>  |-- main.c        --------------.   dummy physical memory definition
>  |-- Makefile                     `- test runner
>  |-- README
> -|-- TODO
>  |-- .gitignore
>  
>  Simulating physical memory
> @@ -101,12 +101,12 @@ There's no need to explicitly free the dummy memory from memblock via
>  memblock_free() call. The entry will be erased by reset_memblock_regions(),
>  called at the beginning of each test.
>  
> -Known issues
> -============
> -
> -1. Tests for memblock_alloc_low() can't be easily implemented. The function uses
> -   ARCH_LOW_ADDRESS_LIMIT marco, which can't be changed to point at the low
> -   memory of the memory_block.
> +The simulator defines ARCH_LOW_ADDRESS_LIMIT in asm/dma.h using the midpoint
> +of the MEM_SIZE range registered by setup_memblock(), rather than the larger
> +PHYS_MEM_SIZE backing buffer. This leaves registered memory both below and

"rather than ..." part is excessive

> +above the limit, even when malloc() returns an address above the kernel's

Why do we care about what malloc() returns here?

> +default limit. The limit is the first address an allocation must not use;
> +an allocation's base plus its size may equal the limit.
>  
>  References
>  ==========
> diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
> deleted file mode 100644
> index c13ad0dae7763..0000000000000
> --- a/tools/testing/memblock/TODO
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -TODO
> -=====
> -
> -1. Add tests for memblock_alloc_low() once the simulator can model
> -   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
> diff --git a/tools/testing/memblock/main.c b/tools/testing/memblock/main.c
> index 278f9dec50087..9a96e178551b8 100644
> --- a/tools/testing/memblock/main.c
> +++ b/tools/testing/memblock/main.c
> @@ -4,6 +4,7 @@
>  #include "tests/alloc_helpers_api.h"
>  #include "tests/alloc_nid_api.h"
>  #include "tests/alloc_exact_nid_api.h"
> +#include "tests/alloc_low_api.h"
>  #include "tests/common.h"
>  
>  int main(int argc, char **argv)
> @@ -12,6 +13,7 @@ int main(int argc, char **argv)
>  	memblock_basic_checks();
>  	memblock_alloc_checks();
>  	memblock_alloc_helpers_checks();
> +	memblock_alloc_low_checks();
>  	memblock_alloc_nid_checks();
>  	memblock_alloc_exact_nid_checks();
>  
> diff --git a/tools/testing/memblock/tests/alloc_low_api.c b/tools/testing/memblock/tests/alloc_low_api.c
> new file mode 100644
> index 0000000000000..1ea5a36fcf0d8
> --- /dev/null
> +++ b/tools/testing/memblock/tests/alloc_low_api.c
> @@ -0,0 +1,148 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +#include "alloc_low_api.h"
> +#include <linux/align.h>
> +
> +/* Allocate at the first or last aligned address below the low limit. */
> +static int alloc_low_simple_check(void)
> +{
> +	struct memblock_region *rgn = &memblock.reserved.regions[0];
> +	phys_addr_t size = SZ_64;
> +	phys_addr_t expected;
> +	void *allocated_ptr;
> +
> +	PREFIX_PUSH();
> +	setup_memblock();
> +
> +	/* malloc() does not guarantee SMP_CACHE_BYTES alignment. */

I'd drop malloc() and say "simulated physical RAM isn't necessarily
SMP_CACHE_BYTES aligned"

> +	if (memblock_bottom_up())
> +		expected = ALIGN(memblock_start_of_DRAM(), SMP_CACHE_BYTES);
> +	else
> +		expected = ALIGN_DOWN(ARCH_LOW_ADDRESS_LIMIT - size,
> +				      SMP_CACHE_BYTES);
> +
> +	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
> +
> +	ASSERT_NE(allocated_ptr, NULL);
> +	ASSERT_EQ((phys_addr_t)(uintptr_t)allocated_ptr, expected);

Isn't (phys_addr_t) cast enough?

-- 
Sincerely yours,
Mike.


