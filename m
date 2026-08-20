Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45360C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C456B00A0; Thu, 20 Aug 2026 04:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263F46B00A1; Thu, 20 Aug 2026 04:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A02F6B00A2; Thu, 20 Aug 2026 04:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E01B96B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73A6E80498
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:15 +0000 (UTC)
X-FDA: 85121003310.13.C889D17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0AD71C0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZ478M4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BI9ucAfGXnKuM+UnmA1L4/e1ETxV6nNHn0mE6kbCQA4=;
	b=h+RYndnda8McAGpy+c8LBZ3wBm+n3uRlfWy2TeKf6Y7rd3ao/PA5F3ZCgq/0kTfNTN4WRM
	Tf3Q7hkJ2NFB+vNXLgG5SOKfTeE/04Ix/nBTf0HrKaMwaXuQ1iXY+zYh0o3s/IEqC9Kjmk
	j0kSS32JxxS6n8mT/7WZfAT0zOBf2Rk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KZ478M4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215273;
	b=ZL4MOjjizKPxxQmx1HCv91YGSycumH0BV3C80U3p6BPjp2bJCHl5vcQm44lRCd+LFDiYIe
	cbhW13J+CG9m2OaaN7U/4BnZSKxwx6nFMQYm86bpcN9QMXLSPvK+ejaBPZJoUGhh1wWAEC
	lpivYyCaMYI+800aCUMDSMxGRr2l1uU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AD55618A8;
	Thu, 20 Aug 2026 08:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEFF1F000E9;
	Thu, 20 Aug 2026 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215273;
	bh=BI9ucAfGXnKuM+UnmA1L4/e1ETxV6nNHn0mE6kbCQA4=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=KZ478M4c5BdbmRXnxnOqYRXax2nVXgWzuVgjYSV7qivyJ4s9HziX57p5mToNutlyl
	 UHMh08FORsSMPbNaxQKC/lQIh+wb94SnVpSe5p/VhjRY1FiGj3ZlLF+pAFGdHlK66p
	 NF9ZYtXXp9/+tpS1hlEJulkFpGrfqIx/c90nw1/5h3Raso7QvViQosacvaV+K+zesy
	 e3oNEpmFf9igYlXCMlOjaaKvVHe7xh53UHek4iMVeVq9l1BAThl4uXy8JXV10Q+PNz
	 GUaBgiGuxSbpBrC5/nr8t+iqwFZee6CX8mFyeENocM0mwoumpHE6DYNSylNTq9cHWu
	 HX8Tx7hTLAN7A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 09/19] selftests/mm: add folio-order detection
 self-check
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-10-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-10-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.2678582848682782159.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: uyrbxq4x1pxkbmkm4mn9fr6u5ma5ggzp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0AD71C0003
X-HE-Tag: 1787215273-869575
X-HE-Meta: U2FsdGVkX1+Smb6RPoLc6mqbqK7Qu0PgwaBzzwcD0D1qKPlRpmkzHTCluvqB84+8uW0BE2xoT4T6wKo7mGaJeePMTcPK6473WZDjquTxD1G76L5DGqWypSZ/0GW9GXsROEVWT+4NyilWayDLY5nWCGs/wco7OECQcuwDWhTwl9DNqBnCtBpZQRFrWpMlTMUmFVwHRv3VfV0yV9fLZTUepdUpQF2R5+eyzuFdwQpwlOG2Ue6V6bqGpXtlxYrpNOnhAx3S04VLoAVYdA98L1qTL7Yy/P3BF0LNGbq+mEPaC7ulkN6IhfEL8kAaaQZMMrJt8niX+vgQrqzXjIQ0LNaXSKCPy5RIyffUmV8bZHHtfxVICPhbn9SGYkZZfKnmaa2e0Z4l7BX9+X/cNooxqjVJStZo0JRIqL/8CCbNWX2rt1vncVB+3AT3dZJ0zZdk6gegOrsOLEPnKBQ2FAWeGgUbpDcw8HhbSoWXD/WLf0Re6Ls1CbrR7dWkF4nKMwwp43qHpHhdMUS2g91F56EUHqt1ctzNlccB8gNgFJr7DsMbAe5FwHdS6XT16uCsmPZwHXzhewHesHvYyMJBppSudb0yTTL7w9vMg1r8hO7kO75TsqmCUCUuKhMZE6Y+RyVyp5vPtER2/Bfm9FwVxCp8xbtsFh+rBU/2BrMQkytqLP0oxuEFXQu0Arl+znPv0M2le6mN0cw6XXMnt+QkHOg1D3GInH5XOodWMQZNGkCvGSFPux3880IcPI2XzUgImrQMO99LV429xG4m9Omdz6JdN7ZwFGGrOhTF6z3FINkXClIKiIQrIFAJfLCNGRRB+soq/Um7c4djFrWnoA5o+d5wgD10U3BJg5meUvtYLp6eAXQo+wru8BWknB4WWskDpP6sIqdQjm9KZRQjdxrUowc2MhnuqL1dby9ymPuk3caakP8PFkhMLW6H+fCzbFaSmIxs/cJkP1pWWUIKj5gvcehbjqa
 kKxcPf9x
 +HWKPxKeaL5k40iwQ8UIQJt7UxTxSDzTHtk2+BIIV8LA6PHQ+PFmrzJqi2QJ2x6e//OFjFW7wtSkpNkCAMroWspovgfYWzUswCHGtAkz5GgdwNnB1cW3mzvb2sLKlkmzORrG6DX9GCxWY7fxuyC9Fn7L3KMPf981vuuFHyUViiF1R6+qLnrUrtueEEO+O6inQz5a7Qx4Z8alaprHy/lfj+uHTIpdx3OZTvbxBBLDe97niLRMNrgRoLlZHDTVu2ms7TqjidCZ6lp46cUoVtqAMAwDaVnPR0aihxY26MUhf1MGNI4v0Y04b+/JAgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
> 
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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

wouldn't void * result in fewer castings?

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

... check that is_range_backed_by_folio_orders() sees ...

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

No need to quote the file name I think.

-- 
Sincerely yours,
Mike.


