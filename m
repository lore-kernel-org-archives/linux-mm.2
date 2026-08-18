Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05B2DC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C90B6B0181; Tue, 18 Aug 2026 06:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0866B0182; Tue, 18 Aug 2026 06:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7176B0183; Tue, 18 Aug 2026 06:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC97E6B0181
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:30:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65F5B120BA0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:30:30 +0000 (UTC)
X-FDA: 85114021020.27.3A7E34B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B11A320004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:30:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXOALRLg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787049028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFhmJcPos1AhWRORhzMLbjRopLVZZ4MU49Dk+N+uRMo=;
	b=kg2aSxSKw8JI+FXHdlvsAj+Y4ycd8k0wXmKKpCKiz9UTRSgnh0ZNuwauQobRSgmqJtWFTD
	6w3QkVUKSH8y4ewZ4WGuMKfNj4lwuuUYiBf4NDFe9aGcU6hTMkRufwGtH3WWbt6yseL3Ck
	iftNz3SlFa3L0cUZGZMnAZ0PGFLFvHI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXOALRLg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787049028;
	b=qnTTN2b6yfhzxTdeDu9Dbyv+4fbFO279OSSRtDQxk7aE27cWA8GUxaqBjIs4+5CQ4c0Z/Y
	i6ZqnyEfGReceoDmnWRgzLcwlZNSxrDl5z3GN0Q2Kv7dTRQRh+tt8H1MKrc8WmTf5/teu/
	jMZBRnPBAmRy3zUUYpT7iMZMvrki4BI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F33FA407A3;
	Tue, 18 Aug 2026 10:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9253E1F000E9;
	Tue, 18 Aug 2026 10:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787049027;
	bh=gFhmJcPos1AhWRORhzMLbjRopLVZZ4MU49Dk+N+uRMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nXOALRLgudDLqMVtGF70wtuuATsP+Nharszx6noAKLgW3XYTxcxa0XvnkPU/m+TD8
	 vxGbfu0VLrD3QqjzylKJQoL6l5+Bx0Qhgs81NGBfWJCFPxHpHaFg4ooT6oM/C2H0+5
	 qRTOZSyUx4JSta/8RFiDr0s87NbQ0+0j4JrfV08Zn8gnvqQoRqyasmSpFD9e9jTfoX
	 TJqOYu+TmoxfLLQHzIU4hdTnw2cus6N9Y5UF1Hz5f5EG8K6Pw9h3GbdHkW9H10rAnJ
	 CgixQGAhJnAloRIgZvyvjvx9n9wmJrKmiG2QbzI5SzriixPtalSG2P0girqkO6+wDm
	 UG0jwJd3tEeeA==
Date: Tue, 18 Aug 2026 11:30:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 09/19] selftests/mm: add folio-order detection
 self-check
Message-ID: <aoQzXhP0W0FVsvTp@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-10-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-10-kirill@shutemov.name>
X-Rspam-User: 
X-Stat-Signature: qicbq6t1poezm39qktpnibnp9fk4ys7q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B11A320004
X-HE-Tag: 1787049028-514258
X-HE-Meta: U2FsdGVkX1+o/2b+tqVL9B9ANs+Qk6NmlVKkEFFyl4OoYTfT+luj54IScCzRLFEu1tOgVmFFF524NdxrX7mgIev9JkHVI44vu32i5BZ03ouL9yUVkutVOILwQddRlUlUyBCiQSFiqL7fnR8I3dSM+K90wqgdHmJm8GkOkHc5bRiOWBAzrZvSWKv59Xx3sDqFSk+1jcIz9du3hNXp2nlJQ4QRelnD2pbOv7Gt0jaaETubvDCjWpxoITwDroqSSTB3x27dEC2Frswqvy5B1u87d99HW1jIAqwkZO1SeWIYWmbQ/vkc5KEGUEKY4clZxnn6GbSg9xgLLI6GEAdbrHbIEYFBSViM/aJKHyiZZnQvcr/oUSE8Q061hzUqCCPPYwW09sSY27bpFW2H/6lXKrTlVedPye1aRLv02H4j/TKLPYAGe+dnU6hqGct7c9We7ErOqGDls69xY7Y3NoyH7jGP7T5iyp/S4y45cfUnNLhVJjWHZ5g6+XXRPzm3QxwBL7C7fhqcD7HMs255ljg6N1Y8USsxqEXPtWOqUdM0ADJXmQBqPTxtFBaJELhQfGU8TJqTGm5X/0VASug9iuua8d2n1jzw9sKuTL8s7MLpz6yacJGjYdrobySoaFU02N4nqhgSEcNBiTxZZ0Q0L24H4qSy3fnkkttdYpYR5KXrPyuN/TC3RMW0uW4jXxJTvyvyFShkcp81tnAAEM/2yg0FsNX5P0ti2iw1MUBqCbSBuBhg88/bo9WfosllFySXyRBT2FbksLa/FQg0IhnMq550DXuxAfTIJjWDEoO6WDiDR9wcn4vnE6wXQnphM9xjn64DeRxysT3gvISTP2ygZYfF2Qh+CugZK0/Q5Hi/Ppbl1I0B6Auac9anYBz5ajOPp9XYMVTVHNvPCvFUfMSSnTMR8bg4lpyBA8w8qh7wbstA5SSTnS3tP4G6xXymujWVUMHekweg8SfbClAiIOu366rzrEt
 +qqVynz8
 E03rD1zCYKlOzvx4NFeSN7NpX90fhxZS5awSH02ubnvn63MRTQK9S0QUcYe4F0DFQVtAcFrRMf5AXsMdjAUAyNUsn5MLJIT1mnSI587MEdPJgQEQZSkR6TcWVTJociUfidWmmMTppI6cYF3k2mvaJE1B851QP37MpHKof7QZc07bKMu5oMto0lPxhZ5g3+mQAszHuIR5pMCPVy3jKVEcRFJPlDKGxIYYwL3NI8KnR7RKF4RijrsWeRkS3wkbPmoibe6Kthijg0QEy30QtN3QL2slSTI2piAtQnjI9VHaswdbYnI+Y8gKM0TB/UyVwyN2BUXhvRlkdCtT/SlbL0cbYwTzziw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:51AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> The khugepaged mTHP tests detect collapse results with the vm_util
> folio-order helpers rather than smaps AnonHugePages, which only sees PMD
> mappings.  If those helpers are wrong, every case built on them is wrong
> the same way, and nothing says so.
>
> Check them directly.  For every anon THP order the kernel supports, fault
> memory in with only that order enabled.  Require the helpers to classify
> the backing as exactly that order: not a neighbouring order, and 4K-backed
> memory as order 0.
>
> Run it in the thp category, ahead of ./khugepaged, so a broken helper is
> reported as itself rather than as a collapse failure.  Verified on x86-64
> 4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).
>
> The test needs ALIGN(), which hmm-tests.c and migration.c each defined
> privately.  Move it to vm_util.h and drop both copies.

Also:

uffd-unit-tests defines ALIGN_UP()...

And really you probably want to match the kernel convention of ALIGN()
defaulting to align-up (for some reason) and name this ALIGN_DOWN() to be
consistent and avoid confusion BUT...

Since the tests already do this mistake I guess it's not so bad to share the
define and propagate it for now I suppose.


>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/Makefile           |   1 +
>  .../testing/selftests/mm/folio_order_check.c  | 137 ++++++++++++++++++
>  tools/testing/selftests/mm/hmm-tests.c        |   1 -
>  tools/testing/selftests/mm/migration.c        |   1 -
>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>  tools/testing/selftests/mm/vm_util.h          |   2 +
>  6 files changed, 142 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/folio_order_check.c
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 2d5366196e30..2093fcf6e915 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
>  TEST_GEN_FILES += merge
>  TEST_GEN_FILES += rmap
>  TEST_GEN_FILES += folio_split_race_test
> +TEST_GEN_FILES += folio_order_check
>
>  ifneq ($(ARCH),arm64)
>  TEST_GEN_FILES += soft-dirty
> diff --git a/tools/testing/selftests/mm/folio_order_check.c b/tools/testing/selftests/mm/folio_order_check.c
> new file mode 100644
> index 000000000000..93030a42c3cc
> --- /dev/null
> +++ b/tools/testing/selftests/mm/folio_order_check.c
> @@ -0,0 +1,137 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Self-check for the vm_util folio-order detection helpers,
> + * is_backed_by_folio() and is_range_backed_by_folio_orders().
> + *
> + * For every anon THP order the kernel supports, fault memory in with only
> + * that order enabled and verify the helpers report exactly that order:
> + * not a neighbouring order, and plain 4K memory as order 0. The helpers
> + * are what the khugepaged mTHP tests use to detect collapse results, so
> + * they must agree with the kernel's own idea of the backing before any
> + * collapse test relies on them.
> + */
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/mman.h>
> +#include <unistd.h>
> +
> +#include "kselftest.h"
> +#include "vm_util.h"
> +#include "hugepage_settings.h"
> +
> +static int pagemap_fd;
> +static int kpageflags_fd;
> +
> +/* mmap an anon VMA of exactly @size bytes at a @size-aligned address. */
> +static char *alloc_aligned(size_t size)
> +{
> +	size_t len = size * 2;
> +	uintptr_t aligned;
> +	char *p;
> +
> +	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
> +		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +	if (p == MAP_FAILED)
> +		ksft_exit_fail_perror("mmap()");
> +
> +	aligned = ALIGN((uintptr_t)p, size);
> +	if (aligned != (uintptr_t)p)
> +		munmap(p, aligned - (uintptr_t)p);
> +	if (aligned + size != (uintptr_t)p + len)
> +		munmap((char *)aligned + size,
> +		       (uintptr_t)p + len - aligned - size);
> +
> +	return (char *)aligned;
> +}
> +
> +/*
> + * Enable only @order (order 0: nothing), fault one aligned window in and
> + * check the helpers see exactly @order.
> + */
> +static void check_order(int order)
> +{
> +	struct thp_settings settings = *thp_current_settings();
> +	size_t size = psize() << order;
> +	bool ok = true;
> +	char *p;
> +	int i;
> +
> +	for (i = 0; i < NR_ORDERS; i++)
> +		settings.hugepages[i].enabled = THP_NEVER;
> +	if (order)
> +		settings.hugepages[order].enabled = THP_ALWAYS;
> +	thp_push_settings(&settings);
> +
> +	p = alloc_aligned(size);
> +	*p = 1;
> +
> +	if (!is_range_backed_by_folio_orders(p, size, order,
> +					     pagemap_fd, kpageflags_fd)) {
> +		ksft_print_msg("order %d not detected after fault\n", order);
> +		ok = false;
> +	}
> +
> +	/* A lower order must be rejected: the folio is larger. */
> +	if (order && is_range_backed_by_folio_orders(p, size, order - 1,
> +						     pagemap_fd,
> +						     kpageflags_fd)) {
> +		ksft_print_msg("order %d also reported as order %d\n",
> +			       order, order - 1);
> +		ok = false;
> +	}
> +
> +	/* Order 0 pages must not look like any large folio, and vice versa. */
> +	if (order && is_range_backed_by_folio_orders(p, size, 0,
> +						     pagemap_fd,
> +						     kpageflags_fd)) {
> +		ksft_print_msg("order %d also reported as order 0\n", order);
> +		ok = false;
> +	}
> +
> +	munmap(p, size);
> +	thp_pop_settings();
> +
> +	ksft_test_result(ok, "order %d classified\n", order);
> +}
> +
> +int main(void)
> +{
> +	struct thp_settings settings;
> +	unsigned long orders;
> +	int order;
> +
> +	ksft_print_header();
> +
> +	if (!thp_available())
> +		ksft_exit_skip("Transparent Hugepages not available\n");
> +
> +	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (pagemap_fd < 0)
> +		ksft_exit_fail_perror("open(/proc/self/pagemap)");
> +	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
> +	if (kpageflags_fd < 0)
> +		ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
> +
> +	orders = thp_supported_orders();
> +	if (!orders)
> +		ksft_exit_skip("No supported THP orders\n");
> +
> +	ksft_set_plan(__builtin_popcountl(orders) + 1);
> +
> +	thp_save_settings();
> +	thp_read_settings(&settings);
> +	/* Base of the settings stack; the bottom entry is never popped. */
> +	thp_push_settings(&settings);
> +
> +	check_order(0);
> +	for (order = 1; order < NR_ORDERS; order++) {
> +		if (!(orders & (1UL << order)))
> +			continue;
> +		check_order(order);
> +	}
> +
> +
> +	ksft_finished();
> +}
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e2642eca0d02..df426f9218e7 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -65,7 +65,6 @@ enum {
>  #define HMM_PATH_MAX    64
>  #define NTIMES		10
>
> -#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
>  /* Just the flags we need, copied from mm.h: */
>
>  #ifndef FOLL_WRITE
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index f19d53c69576..fd35f8a7b5b8 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -20,7 +20,6 @@
>
>  #define TWOMEG		(2<<20)
>  #define RUNTIME		(20)
> -#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>
>  HUGETLB_SETUP_DEFAULT_PAGES(1)
>
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384e..2652a7920b80 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -402,6 +402,8 @@ CATEGORY="pfnmap" run_test ./pfnmap
>  # COW tests
>  CATEGORY="cow" run_test ./cow
>
> +CATEGORY="thp" run_test ./folio_order_check
> +
>  CATEGORY="thp" run_test ./khugepaged
>
>  CATEGORY="thp" run_test ./khugepaged -s 2
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 39dfb18dc10c..ce05bce4670d 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -10,6 +10,8 @@
>  #include <linux/fs.h>
>
>  #define BIT_ULL(nr)                   (1ULL << (nr))
> +#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))
> +
>  #define PM_SOFT_DIRTY                 BIT_ULL(55)
>  #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
>  #define PM_UFFD_WP                    BIT_ULL(57)
> --
> 2.54.0
>

--
Cheers, Lorenzo

