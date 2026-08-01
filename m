Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB22C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 13:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBF06B007B; Sat,  1 Aug 2026 09:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CAA6B0088; Sat,  1 Aug 2026 09:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2996B008A; Sat,  1 Aug 2026 09:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0B3F6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:20:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 436F21202C2
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:20:50 +0000 (UTC)
X-FDA: 85052760660.15.48C1601
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id B015180008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:20:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ8qK7jP;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785590448;
	b=cwfoo4otMey23WkvfkHX7fqh9h8Rs73U+XHPrwH49BxDg7jlvyGhqvv/c2L6ruWggwBu6A
	UunKh1Y1qdQNUkHrx+M/wiAufC9rVZ+I4lmqayXDTDWmA4HBb4YTAmnV+Mq2+RpketRwwp
	Ckl51NmgOo2EhHsFFfJS1t3tLIoC+k0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nQ8qK7jP;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785590448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t13C+xMvQNSfcgbBPqp8o7L1VMr2wxshCbQ8fbg+xWM=;
	b=oyNHlCNjVOCyPKscRmHFX7lQqt3szo7V29RpZ35uMEAkJ+HGJ+eo5OHWBem9C9hIU69h81
	R87n05cH2e4vnFVxzJ7kezPPuUDlaKDM4TDEVPnL9gf+wG9YcL8Z8gJTwJdrbtt9J0h9OP
	2HM76+xJbD8axgLTNPfC/pRty7GOv48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785590444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t13C+xMvQNSfcgbBPqp8o7L1VMr2wxshCbQ8fbg+xWM=;
	b=nQ8qK7jPPB/d/j9bllq7oXQohbv6EqlhGdVUbElepHCkBR1/wz6UI64F/A9sGIoFuZls89
	GaR9uE90m5KQGBBHVxfTNZ0TjZ6l+9FKgrAD5JXX3iF1ufT/GvBH+PNPjShlrdcA72kX20
	m59R5IME/ugvYQ96DEFgx3azQZs/u+E=
From: Usama Arif <usama.arif@linux.dev>
To: David Rientjes <rientjes@google.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] lib: test_vmstat: add synthetic benchmark for vm stats
Date: Sat,  1 Aug 2026 06:20:37 -0700
Message-ID: <20260801132038.2926647-1-usama.arif@linux.dev>
In-Reply-To: <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 755titm1nj7wqo1c5uaymk3tng4nnaxs
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B015180008
X-Rspam-User: 
X-HE-Tag: 1785590447-120155
X-HE-Meta: U2FsdGVkX18vrpxYmlt1qYYfU3IBHyOFf3p61dltn8tXOqXkpHdxZfoA8S+ivQX/S/kvBGbVima4WhcF4M06OKy7BhYmW5PcbGDJTTC9AMWJyZgVCy/mlBu79fBZMXPoo3ClOhCGmXtgX7NbyltWbLLtE6062KKeSMx5el21uePSVY9UVlI1raTAR12zYYp0oE9bqrMETjgwxER45+3oG36TSNwiTDpSJVX5Djb8lgFAgqIwpvmCMv/D3e9QZVaeZopPgKZ3i8fK/gnOYVl3tlMyus8qvGhZ6pbl2L7t7nYqlz56i1WqH47yWWsAI4uNJyzFdQRyRyLwM2+P+CyeZezH0Sz8cLqx8KwrzpJnjOyGBsznWdhhAvMBe/Fg0T9pp7v+xdbi4ZM3eFgnYzzGHJdNuDnGeRC9/LDlk+N1dQUEXzZUC/41kqibRlmk2W9NLEAcIcwaxdBsuKhO2Cu/RS7lq3zt5fVIfUizm2lsKjAMVEAUufpT9GT9wTzCMk4I2qTrqH7xMg6EgDc/Zilr7JcWE7MPZaIbUCnqzks62Xv/dFfcQFBvVJyYDfXqfnNgcev6bRUscxgNaMLoMjK2xOJalYU7MIi2Geb1uqXH94eEPOTh8IFZ3RHhrTdU55ClHsur1j5UdB4DfWgExrDZgpF7xGkquLsl5tKWZYOGnZf7u+CWGf7AvHYiGXUkCMEYCVqhdA1pCTZiJBCi/YGj3GLHaD7IPv7sHEeO4emBZBhN23qahN9J5fNo7YeFMwMXJDq9rJJylfknx9lA6UuuRgmnesCkj5BHqCepnHvvP8jIMEsxvPInRbc0tYHso87XOU0rERuwhC/V0DM/ptLjUaZCSeMQ2QbfV3jJnxg6drnOXFwbT9gnxOT1eUabf4/fwP5xPqizI9Ot8hSqZ3Uvt8wgr9t110ZaIcwJpRjICBY/cwTGf0NBAyN4hOXHF78lgxtjqgwGICOvTtfo5OW
 2IOMQZ12
 WdlO9FBDQrLcfdMd9jH0ggap2nRfxipSkQgzbEg49QjdhR+/eyPDLb7+m/jNJQ4T6lDym+FRrGPcIjr8iFyJxz0fS047dw51RPn5XQKweAU5YHmJwS+EC+s+mlF/BvELytZgDY/Q0x2POshG6Abucj66YGuwQ9mievHh2HiZz3QDNfueoT4yNBwiKA8/f7hzxUA7CL4SDgEeUjcpAKD2e9AqOEQa6W2lTUovTwDTk2GXKGZ6Zxz66RXhO5nlrdv3aknd0az0qAQ6RyoemsMW4HFM3rlORavd9xm7dcEpw+FJ3ptVsJe6DJNB3WPK+Vm2k1YYpk7V+1BYjzp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 21:26:23 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> From: Christoph Lameter <cl@gentwo.org>
> 
> Add a synthetic benchmark that can be used to measure performance of VM
> statistics.  This is used to analyze any improvements or regressions in
> functions that are frequently used in hot code paths.
> 
> The test is run by inserting the module: modprobe test_vmstat
> The module insertion will always fail so that it is automatically
> unloaded; the results are in the kernel log.
> 
> Signed-off-by: Christoph Lameter <cl@gentwo.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  lib/Kconfig.debug | 10 +++++
>  lib/Makefile      |  1 +
>  lib/test_vmstat.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 106 insertions(+)
>  create mode 100644 lib/test_vmstat.c
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 1244dcac2294..6d743c8e27fa 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -3427,6 +3427,16 @@ config TEST_KEXEC_HANDOVER
>  
>  	  If unsure, say N.
>  
> +config TEST_VMSTAT
> +	tristate "VM Statistics Benchmark"
> +	default n
> +	help
> +	  A synthetic benchmark measuring the performance of VM statistics,
> +	  useful to analyze any improvements or regressions in functions that
> +	  are frequently used in hot code paths.
> +
> +	  If unsure, say N.
> +
>  config RATELIMIT_KUNIT_TEST
>  	tristate "KUnit Test for correctness and stress of ratelimit" if !KUNIT_ALL_TESTS
>  	depends on KUNIT
> diff --git a/lib/Makefile b/lib/Makefile
> index 7f75cc6edf94..5f3ebabd0224 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -105,6 +105,7 @@ obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
>  obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
>  obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
>  obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
> +obj-$(CONFIG_TEST_VMSTAT) += test_vmstat.o
>  
>  obj-$(CONFIG_TEST_FPU) += test_fpu.o
>  test_fpu-y := test_fpu_glue.o test_fpu_impl.o
> diff --git a/lib/test_vmstat.c b/lib/test_vmstat.c
> new file mode 100644
> index 000000000000..f63f439ab9d2
> --- /dev/null
> +++ b/lib/test_vmstat.c
> @@ -0,0 +1,95 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test module for in-kernel synthetic vm statistics performance.
> + *
> + * execute
> + *
> + *	modprobe test_vmstat
> + *
> + * to run this test
> + *
> + * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
> + */
> +
> +#include <linux/jiffies.h>
> +#include <linux/compiler.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <asm/timex.h>
> +
> +#define TEST_COUNT 10000
> +
> +static int vmstat_test_init(void)
> +{
> +	unsigned int i;
> +	cycles_t time1, time2, time;
> +	int rem;
> +	struct page *page = alloc_page(GFP_KERNEL);
> +

Good to check page != NULL before using it below.

> +	pr_alert("VMstat testing\n");
> +	pr_alert("=====================\n");
> +	pr_alert("1. inc_zone_page_state() then dec_zone_page_state()\n");
> +	time1 = get_cycles();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
> +
> +	time2 = get_cycles();
> +	time = time2 - time1;
> +
> +	pr_alert("%i times inc_zone_page_state() ", i);
> +	time = div_u64_rem(time, TEST_COUNT, &rem);
> +	pr_cont("-> %llu cycles ", (unsigned long long) time);
> +
> +	time1 = get_cycles();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		__dec_zone_page_state(page, NR_FREE_CMA_PAGES);

Why use inc_zone_page_state() but the __ variant for decrement?

Checking the 2 functions, __dec_zone_page_state() might cause
problems if preemption is enabled?

> +
> +	time2 = get_cycles();
> +	time = time2 - time1;
> +
> +	pr_cont("__dec_z_p_s() ");
> +	time = div_u64_rem(time, TEST_COUNT, &rem);
> +	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
> +
> +	pr_alert("2. inc_zone_page_state()/dec_zone_page_state()\n");
> +	time1 = get_cycles();
> +	for (i = 0; i < TEST_COUNT; i++) {
> +		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
> +		dec_zone_page_state(page, NR_FREE_CMA_PAGES);
> +	}
> +
> +	time2 = get_cycles();
> +	time = time2 - time1;
> +
> +	pr_alert("%i times inc/dec ", i);
> +	time = div_u64_rem(time, TEST_COUNT, &rem);
> +	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
> +
> +	pr_alert("3. count_vm_event()\n");
> +	time1 = get_cycles();
> +	for (i = 0; i < TEST_COUNT; i++)
> +		count_vm_event(SLABS_SCANNED);
> +
> +	time2 = get_cycles();
> +	time = time2 - time1;
> +
> +	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
> +	pr_alert("%i count_vm_events ", i);
> +	time = div_u64_rem(time, TEST_COUNT, &rem);
> +	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
> +	__free_page(page);
> +	return -EAGAIN; /* Fail will directly unload the module */
> +}
> +
> +static void vmstat_test_exit(void)
> +{
> +	pr_alert("test exit\n");
> +}
> +
> +module_init(vmstat_test_init)
> +module_exit(vmstat_test_exit)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Christoph Lameter");
> +MODULE_DESCRIPTION("VM statistics test");
> 
> 

