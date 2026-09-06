Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D1CAC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 20:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59ADA6B0088; Sun,  6 Sep 2026 16:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BE66B0092; Sun,  6 Sep 2026 16:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4614D6B0095; Sun,  6 Sep 2026 16:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245166B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 16:29:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFF4E140574
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:29:33 +0000 (UTC)
X-FDA: 85184477826.11.F06BAEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id F04F61C0004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:29:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9PMSd6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788726572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4BtRC8J+WIShp69Zz3T7sR3CET6fWcdoXngCSQaqmg=;
	b=YDE58ATFCRV1szdnKw7IPk2ascd9fHGXq+y3CBZ/SxkVWBEt+yG07yn/NBa1XE/38HgaGL
	4GBD6IEu7mcqhAJOADkUIGHxRcg30vYKZZm6Vj9Hb90qInqBnzbWawMFD6Qm5RH4lZCT2r
	Ps7xtC7X7lk6PTpJ9T3lTSOy/a4sluM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W9PMSd6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788726572;
	b=sqnnoPNUR6ZEIKbzwuozE7NNA1DWj1fWIuM0sUkM9PzNGs5kdpSuuO6pWTl/NPjrlD2WTB
	hASTs737rJUAgqfszrrVeg6tdHmxH1+8Xu2Tx4hcc3tX/McnV3Kmjt8OHF0JLnU/qXcNuA
	R8JDhAC6tERfX3U/yg9x9WmZnmRarQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17F6843805;
	Sun,  6 Sep 2026 20:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797FC1F00A3A;
	Sun,  6 Sep 2026 20:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788726571;
	bh=v4BtRC8J+WIShp69Zz3T7sR3CET6fWcdoXngCSQaqmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W9PMSd6FozkYJbqrx+ELLq7VPoWhe1NDQt82R0WJif7ALPFlVLTyjn1otTakXa2R+
	 8yQLv18dflsu4CxBi/H5UYDYhGpcY/tuZDcFS1TkSLuFF6pmeC2+SdSC5GAa0ugta1
	 KoyMqcMPUIjPKxHuTt1l25t7DnrgaaST9xqa0T0UiUnInHXIgJFh4S8lubMORdDedK
	 I2+1EXkPMSuVjfC6acjkFcdALbReUfm40i+pWJLvy+9D2AcpI/kTZBKchx65gK4fxu
	 4zKUrLLMM6ZYZrLzNYPfUMX5TcyzhClOk/lCD3W8HuFf7E5LFnjF0/9V2p1aA6yL6n
	 7kSlDPcX5+jJA==
Date: Sun, 6 Sep 2026 23:29:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memblock tests: cover allocations below the low
 address limit
Message-ID: <ap3NJsaG10rLDVpd@kernel.org>
References: <20260906144011.848898-1-hi@tychen.cc>
 <20260906144011.848898-2-hi@tychen.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906144011.848898-2-hi@tychen.cc>
X-Stat-Signature: jksh7ddsmy3eq6fa8ci1j6m9e3kerae5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F04F61C0004
X-Rspam-User: 
X-HE-Tag: 1788726571-56921
X-HE-Meta: U2FsdGVkX1+1Ig68gOrZlMOH4vaIwAbmyl+m/J2uSjuD0PkVyk3EePb6pqPGUhagpzPZYjSWNJ+9hRlDpNSb3Bua4BtOIZYevnQnDt77kXVWeaCUh7Kuwo8T0mFBNaWoCSLLF0e4RguY+MurkNIKof0Ad7+dWY6C2fg6cdBjTeDze0IIVFMQToPyrVu2HqsqN/aWGI+GlKkRaI4eNUmGkCd7EWgdDI9hdutprdAQ+Qq9wfc8/0Q3Ugp3ughNST1ENzOGyhUTxD+YmZRpUBaHwNc4mOxi52QImjTeZrLl7v0Y4i0hzcHtzojw5qH7njqQ+Pi1Qn8frB+U/0h365mu2zcLRlaAqGyc81Q4wH5ksc+PeSze4+da0YEogc2S/iuSIRvRA/O8tOEaU5WUgFUTGxfYFjRcV+8lAjCN1epXfJTKQZ2mNLbC/1m0p2S9xr5H+IZ8fHCqicxsPNSxCH5lLvSA22tK7EjZiEhgFvOG0cCIjVLzOMCOk7ELuMBglUsnYOva0uu4Vyix23Qg5ocQJix+4bYCt162WI9RPJdkvRn5PnDOS53hr7Z1yyFr+Xl1bqBvV+Q7mtV7FCQjYK0psskZxFfk+M5aDusxJ84BACLwVyeGTDzmjjsRSaBrjb/Z3hA0QcoABtYavdZc51cQ2nBv5RNZkwmIp0x0cCou6CLEeg3BDJqWq4nQE//trXA8ovAMhXofoiFRWDih+hiXSFoowgh6L5sVzIo+fKowHNkGTNDNPczjuXm3p5GSwewX8PZO1GYVxZGj9HiPNYXERKsW2FUJEup3LS+pUMn37ugbUtZnJTN48t1ZZG+AfV5wRtjTFwxZjNmcYmc3zb33WHmzKMkAmdSwb5i/RSOIABm1W+kf9+zDMBwZsdsmjnjEA4CaosW8GWBGeREk0gLDvgD4K6Pzb3CThJX5LKJERzPbBCtR/neBKyOyXR2AdOw0qgFxxHHGHAULDTw/X5v
 c3TjInNz
 WGQxq8d7DKA7lPMp4yIAoUDBHXmG26Lrznbncs+8lyugZ2YqeAqvOUYA9dSCY/sqNKHo7kg1Z40zKcRYp/iPW9HsGBqCTpAAHb4Fz46fw9z+jyswU/UOCDayIZ4DK13yWhE/cpJmBxsCnVbjEpAximeB5yiRwq2JeHj4i+plzksy54XZr9FycU8fpCoQDYljfo7orSehS7lTEfsppGaz5D31eH5sfrXpcbaLb4Ypl9AlW+ROxDLJL/h2C/EOLORCkopjT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 10:40:11PM +0800, Tianyi Chen wrote:
> Add memblock_alloc_low() coverage using the simulator's low address
> limit. Exercise aligned allocation, an allocation ending exactly at
> the limit, an alignment constraint that prevents fitting below it,
> and fully reserved low memory with high memory still available.
> 
> Run each case with bottom-up and top-down allocation. Check zeroing
> and reserved-region accounting as well as returned addresses. Verify
> that an unrestricted allocation can use the free high memory after
> the low allocation fails.
> 
> Document the simulated limit and remove the completed TODO. The full
> suite passes with ASan and UBSan in default, NUMA, 32-bit physical
> address and debug configurations, with movable-node mode both enabled
> and disabled.
> 
> Assisted-by: LLM
> Signed-off-by: Tianyi Chen <hi@tychen.cc>
> ---
>  tools/testing/memblock/Makefile              |   3 +-
>  tools/testing/memblock/README                |  13 +-
>  tools/testing/memblock/TODO                  |   5 -
>  tools/testing/memblock/main.c                |   2 +
>  tools/testing/memblock/tests/alloc_low_api.c | 147 +++++++++++++++++++
>  tools/testing/memblock/tests/alloc_low_api.h |   9 ++
>  6 files changed, 166 insertions(+), 13 deletions(-)
>  delete mode 100644 tools/testing/memblock/TODO
>  create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
>  create mode 100644 tools/testing/memblock/tests/alloc_low_api.h
> 
> diff --git a/tools/testing/memblock/Makefile b/tools/testing/memblock/Makefile
> index d80982ccdc2..20524fcbe3c 100644
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
> index b435f48d8a7..e4fb5f23fb2 100644
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
> @@ -101,12 +101,11 @@ There's no need to explicitly free the dummy memory from memblock via
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
> +of the MEM_SIZE range beginning at the dummy physical memory base. This keeps
> +the low-address limit within the allocated buffer even when malloc() returns
> +an address above the kernel's default limit. The limit is an exclusive upper
> +bound, as in the memblock allocation API.
>  
>  References
>  ==========
> diff --git a/tools/testing/memblock/TODO b/tools/testing/memblock/TODO
> deleted file mode 100644
> index c13ad0dae77..00000000000
> --- a/tools/testing/memblock/TODO
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -TODO
> -=====
> -
> -1. Add tests for memblock_alloc_low() once the simulator can model
> -   ARCH_LOW_ADDRESS_LIMIT against the low memory in memory_block
> diff --git a/tools/testing/memblock/main.c b/tools/testing/memblock/main.c
> index 278f9dec500..9a96e178551 100644
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
> index 00000000000..a0fae975a26
> --- /dev/null
> +++ b/tools/testing/memblock/tests/alloc_low_api.c
> @@ -0,0 +1,147 @@
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
> +	if (memblock_bottom_up())
> +		expected = ALIGN(memblock_start_of_DRAM(), SMP_CACHE_BYTES);

Can we ever have memblock_start_of_DRAM() not aligned to SMP_CACHE_BYTES?

> +	else
> +		expected = ALIGN_DOWN(ARCH_LOW_ADDRESS_LIMIT - size,
> +				      SMP_CACHE_BYTES);
> +
> +	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
> +
> +	ASSERT_NE(allocated_ptr, NULL);
> +	ASSERT_EQ((phys_addr_t)(uintptr_t)allocated_ptr, expected);
> +	ASSERT_MEM_EQ(allocated_ptr, 0, size);
> +	ASSERT_EQ(rgn->base, expected);
> +	ASSERT_EQ(rgn->size, size);
> +	ASSERT_LE(region_end(rgn), ARCH_LOW_ADDRESS_LIMIT);
> +	ASSERT_EQ(memblock.reserved.cnt, 1);
> +	ASSERT_EQ(memblock.reserved.total_size, size);
> +
> +	test_pass_pop();
> +	return 0;
> +}
> +
> +/* The only low memory available ends exactly at the exclusive limit. */

What do you mean by "exclusive limit"?

> +static int alloc_low_exact_limit_check(void)
> +{
> +	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
> +	phys_addr_t base = ALIGN_DOWN(limit - SZ_64, SMP_CACHE_BYTES);
> +	phys_addr_t size = limit - base;
> +	void *allocated_ptr;
> +
> +	PREFIX_PUSH();
> +	setup_memblock();
> +	ASSERT_EQ(memblock_remove(memblock_start_of_DRAM(),
> +				  base - memblock_start_of_DRAM()), 0);
> +
> +	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
> +
> +	ASSERT_NE(allocated_ptr, NULL);
> +	ASSERT_EQ((phys_addr_t)(uintptr_t)allocated_ptr, base);
> +	ASSERT_MEM_EQ(allocated_ptr, 0, size);
> +	ASSERT_EQ(memblock.reserved.regions[0].base, base);
> +	ASSERT_EQ(region_end(&memblock.reserved.regions[0]), limit);
> +	ASSERT_EQ(memblock.reserved.cnt, 1);
> +	ASSERT_EQ(memblock.reserved.total_size, size);
> +
> +	test_pass_pop();
> +	return 0;
> +}
> +
> +/*
> + * There are size bytes below the limit, but aligning the start makes the
> + * allocation cross it. Memory above the limit must not satisfy the request.
> + */
> +static int alloc_low_alignment_crosses_limit_check(void)
> +{
> +	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
> +	phys_addr_t base = ALIGN_DOWN(limit, SMP_CACHE_BYTES) - 1;
> +	phys_addr_t size = limit - base;
> +	void *allocated_ptr;
> +
> +	PREFIX_PUSH();
> +	setup_memblock();
> +	ASSERT_EQ(memblock_remove(memblock_start_of_DRAM(),
> +				  base - memblock_start_of_DRAM()), 0);
> +
> +	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
> +
> +	ASSERT_EQ(allocated_ptr, NULL);
> +	ASSERT_EQ(memblock.reserved.cnt, 0);
> +	ASSERT_EQ(memblock.reserved.total_size, 0);
> +	ASSERT_MEM_EQ((void *)(uintptr_t)base, 1, memblock_end_of_DRAM() - base);
> +
> +	test_pass_pop();
> +	return 0;
> +}
> +
> +/* Reserving all low memory must fail even though high memory remains free. */

Is this what the test checks?

> +static int alloc_low_reserved_check(void)
> +{
> +	phys_addr_t limit = ARCH_LOW_ADDRESS_LIMIT;
> +	phys_addr_t base = dummy_physical_memory_base();
> +	phys_addr_t size = SZ_64;
> +	void *allocated_ptr;
> +
> +	PREFIX_PUSH();
> +	setup_memblock();
> +	ASSERT_EQ(memblock_reserve(base, limit - base), 0);
> +
> +	allocated_ptr = memblock_alloc_low(size, SMP_CACHE_BYTES);
> +
> +	ASSERT_EQ(allocated_ptr, NULL);
> +	ASSERT_EQ(memblock.reserved.cnt, 1);
> +	ASSERT_EQ(memblock.reserved.regions[0].base, base);
> +	ASSERT_EQ(memblock.reserved.regions[0].size, limit - base);
> +	ASSERT_EQ(memblock.reserved.total_size, limit - base);
> +	ASSERT_MEM_EQ((void *)(uintptr_t)base, 1, MEM_SIZE);
> +
> +	allocated_ptr = memblock_alloc(size, SMP_CACHE_BYTES);
> +	ASSERT_NE(allocated_ptr, NULL);
> +	ASSERT_LE(limit, (phys_addr_t)(uintptr_t)allocated_ptr);
> +	ASSERT_MEM_EQ(allocated_ptr, 0, size);
> +
> +	test_pass_pop();
> +	return 0;
> +}
> +
> +static int alloc_low_checks(void)
> +{
> +	alloc_low_simple_check();
> +	alloc_low_exact_limit_check();
> +	alloc_low_alignment_crosses_limit_check();
> +	alloc_low_reserved_check();
> +
> +	return 0;
> +}
> +
> +int memblock_alloc_low_checks(void)
> +{
> +	prefix_reset();
> +	prefix_push("memblock_alloc_low");
> +	test_print("Running memblock_alloc_low tests...\n");
> +
> +	reset_memblock_attributes();
> +	dummy_physical_memory_init();
> +
> +	run_top_down(alloc_low_checks);
> +	run_bottom_up(alloc_low_checks);
> +
> +	dummy_physical_memory_cleanup();
> +	prefix_pop();
> +
> +	return 0;
> +}
> diff --git a/tools/testing/memblock/tests/alloc_low_api.h b/tools/testing/memblock/tests/alloc_low_api.h
> new file mode 100644
> index 00000000000..2e3cbe336f5
> --- /dev/null
> +++ b/tools/testing/memblock/tests/alloc_low_api.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _MEMBLOCK_ALLOC_LOW_H
> +#define _MEMBLOCK_ALLOC_LOW_H
> +
> +#include "common.h"
> +
> +int memblock_alloc_low_checks(void);
> +
> +#endif
> -- 
> 2.55.0
> 
> 

-- 
Sincerely yours,
Mike.

