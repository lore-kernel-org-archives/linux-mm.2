Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D992C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 20:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D6F6B008C; Thu, 27 Aug 2026 16:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076156B0092; Thu, 27 Aug 2026 16:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FAE6B0095; Thu, 27 Aug 2026 16:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0A006B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35E6C1A0198
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:24:50 +0000 (UTC)
X-FDA: 85148177940.27.2FC335F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC7DB40003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:24:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jF/HEH9N";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787862288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0uC+ldNwdhl74g7pqblpc7FibgDbfOXdqUd8xd9nks=;
	b=3SxAbYt3oN26Urqht7QnqXepldTbVRBjZTJdWk+Z+7R3jIiBGJFc4CJbvyL5m8ifdf+Pkb
	gJyNRSqjwctGuMTUoOxnPpk6jfremkVOwO5BrCyhGFkdzveGgTo29AbQ/XAnZDsWpF0MKv
	lY9KnFlhZE2lf2Q73tt8RVnjK899afM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787862288;
	b=aiyzOyLIOtGAIWFGtQfqvubc7c7fwYfzZYVfApaoRXjriik3o//iJLe7gNbTECFeF4rm2V
	Gae6U3dLhB7CiAMsmVt8Q5vIHJSj9Pu1MigKntIveadf8cmC7d3BtA97G0jbH38HJhce35
	olszyeTi4XROFkuybsLfTNsd5hBuJKY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jF/HEH9N";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787862287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0uC+ldNwdhl74g7pqblpc7FibgDbfOXdqUd8xd9nks=;
	b=jF/HEH9NFJB80z62G6lrof4QZEBCFUyrKXLa2kiWGaxH7jRGX1xviVv/Q+kIzpnY//zgQm
	XhnQqlD8O2aQMbvTohIKltOhDOM6QFDEhjhFcB5q0gVCvZS5+9fXshwj2qg85eBt+WY0o6
	ABg4DiT8ITOoMYfCVfYzqANCZWjIy4U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-OD6-xl80MriySbuSw3wJ-g-1; Thu, 27 Aug 2026 16:24:45 -0400
X-MC-Unique: OD6-xl80MriySbuSw3wJ-g-1
X-Mimecast-MFC-AGG-ID: OD6-xl80MriySbuSw3wJ-g_1787862285
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52de05de414so992161cf.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787862285; x=1788467085;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e0uC+ldNwdhl74g7pqblpc7FibgDbfOXdqUd8xd9nks=;
        b=Zpl9mVaUR7BzJQC/EoRUAmfBfStunJIxkxrrO5+B8l9JAr8bDbgkxtmguzfJEjS/Ab
         419QVR4SwYESh7KrSXzI1+mjBgnEvBp7zJhi6nJ29u8MWS4DF63f27o+nTVQnhFs0AvY
         t6vbLCk0niHV8vzGA4yQvE/U7nL/VALapRQWP/MEFBgzOp2/Ym7lZODLHvbBDK6XdT9w
         8g3eatzqaZsNIRBHFH6BFwsjMswlxiBnFx0JPDA6A28tAqJBPhC8Lx2GycLWpQywY9gH
         90yY4pDnEuurzAFiL6koAXYRHGJZ5mCeBWJWMFDTrZ48XktGAWNUzT0IVz21CZQS17Pe
         4BbQ==
X-Forwarded-Encrypted: i=1; AHgh+RoFssSj67Phfd4SC2BXIvRHys817lNqCUwBeHl00IALgbCoLhxWdrHh6Wn1KmhxAugf4YHBtB27hg==@kvack.org
X-Gm-Message-State: AFuF++ntGOq6r0wS3me0RrIo9gOFWNtS6TYY4R1/qnnCgwlyO0t5JOY5
	4HMAFTP8EXtXhRBdyw8FRK+oA7HzpsR7p0kgmBBX3yh0xKmOzzbJ+KPKR/l0uyr/g1ZdsV7KPYL
	qy1CBCStBd+m4N9RX1IuD3itBCExfcE4XUzYxPwuz983+Q/yteu8/
X-Gm-Gg: AR+sD11mwNe5KRVW77chichNHB4vj0p/asVihZ6G33rxuxIFEOjZgROi/QXRYbfQSsj
	oiUDFRorQf3hNUfHXl2Y3enRaDzRUtmgW+LQr3qcWjOF1c37ZVw0FADDUmcdkBOpuOXN/N0Uh15
	a5KHOY4/0nMqJzfwsNla4N2OTdNZbfXdyWN0K4zg3fvhBxhqE4/SjGsL3wKGg4oYMQWFf6QFTR6
	pb18Jibg6mVMXfgWQ9UdpDYr8cmnx6a7UB+vnn8iOYgGra/fh2TMR22pU8AcYQMZhVvUgL4ZWlB
	e3a+ubHvAhfnPQKuH1n+g+eAJXiuGqMRMGRAgfszks9LI8n3EG6t0QVyGHQZEpOuuEzUaCqR52k
	qIQ==
X-Received: by 2002:a05:622a:1a82:b0:517:8d24:64d8 with SMTP id d75a77b69052e-52fb9429b1cmr19374751cf.13.1787862284551;
        Thu, 27 Aug 2026 13:24:44 -0700 (PDT)
X-Received: by 2002:a05:622a:1a82:b0:517:8d24:64d8 with SMTP id d75a77b69052e-52fb9429b1cmr19373781cf.13.1787862283727;
        Thu, 27 Aug 2026 13:24:43 -0700 (PDT)
Received: from [192.168.2.110] ([76.65.104.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fb9eaf2ebsm3868831cf.15.2026.08.27.13.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 13:24:43 -0700 (PDT)
Message-ID: <5c39f3bb-6639-46df-a25a-77b77522daf9@redhat.com>
Date: Thu, 27 Aug 2026 16:24:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/12] selftests/mm: add PMD swap entry tests
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-13-usama.arif@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260818131202.494754-13-usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4-p99KYiX-Jxgj6YV-FD0mT_APavk-Dx0BQtTOP2x0s_1787862285
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC7DB40003
X-Stat-Signature: dgomc51oc1b53spdgyxisinq7nskm3r4
X-Rspam-User: 
X-HE-Tag: 1787862287-78592
X-HE-Meta: U2FsdGVkX1/mhBqmvpJMvAzysj04j/sK4wFgrnQepzoPgYgQ9erm0zm2buB8BGwV5z4phvz7MSzHEOvar5CeQViTfXepjddvO7ikyXFweAolGNqzUExTqCv2OYPxscngTeJ8+fWBKQSfo+fEJK2QysHMFqzK0mLCQGL1X+ECsWxhVjCSI/SbKrUgdcqelGuzjB56Yj72bkweiRX+uZkietV8b6+PIWmqmroiE1fJPR4H/NsO6fEl+kUE4XItQuGnvzWsdvbHkVA3lVAQ0UCgbILtc+zHNIEUzede4phUqK5XnUZXDZ+DjWjq4HLszNgKyAZmOs7udcBO9YFuwdVubFECdiQiuC0grNfg/4zyZQs0XIvlV8wW/MpCOOqi9kayBj7Zom+CLOoQNF79LFAa7Gj/wlrFKBd4nmvt1vV3TfrJoghAtgGory5hse1hWpjrSw5CMg/d6/0UdBmbgX9Lsw+y5wLtM+c1YMC/puwn5kjIe3/CF6NuHj3wiXmyjbaj9gDV8K+F9CyJ41oMq60CC3FVsvH3U0j/etunqxHHCUuRukAWYeIErQvEdm+0Qm+XFTDBiFUpai5dhveBX5tIBU1lyVNENpYTHy9P9XrySZfnNHDmP3xJZHZ6z3MLfQcz7pBlOu61/34RKnz6UMPy8vEx166CxI/ppQBnELfWGcwxAw+GfKENAaOgk1+QX/8pzkry5f4OIRxq7cJTD/mwVacOLbYxQ0ftd124yckz8k4h/JE5gqYRQO63NWSIY+LtPnOpnNHOGZreyMKvswNnhRd61H2Yw/WGyZdYnTG36+FeI6+c3u23JJ/4oeaFLuDEVS9LwZk/0lSeS5N9aSQXLAIFpdfTpkvZqfQGpKWvHuWFnMyM8prqDFoRhoyUVzNormozaF7oUJK7Jw/gUS780NpAhxKqUYrkFFNvK3ye1PKx0v9xg8CFFPDiAqyxDX6w/jR17Kn2JAFZM/YoqJh
 AK0bVcVq
 Rp2vuzi4vUZZ4Ndg5jY3rWObB9qzmFPMMEkzsSnE86I4gqVW4F8abr4Fjds7xhfgZyVj+ckfjl2lUiyARuMyjXc4DEfnaTw4NAFRJqEVf2MQCh1LqIeqZqcPwl8Cx8zmpJPmmX2JvQOeuCAFOYcqbVLadxEZgGux2kkw5wc9OXiogYTY2xhOnRSLOXfHc64CRJqLXsdc4tiRna5EctIcvfWFCZn+aqHLKNAR6njBv7ccWIp4Y0AiqqTAvLgzguRN8PGBSwpmy7jkjJGXv4C8UTtjRU+vuAkzyNliXh/1Sn8hCstvknqIf9FS86VJBKOHJIxBYZNoAbfARwqTKjmgt0YFIjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-18 09:09, Usama Arif wrote:
> Exercise the PMD swap entry paths.  Each test gets a fresh PMD-mapped
> THP from fixture setup, fills it with a page-distinct pattern, swaps it
> out with MADV_PAGEOUT, and verifies that thp_swpout_pmd increased.
> 
> The tests are:
> 
>    - basic: fault in a swapped PMD and verify its contents.
>    - fork: verify parent and child can fault in the shared swap entry.
>    - fork_cow: verify parent and child writes remain isolated.
>    - write: fault in by writing one byte and preserve the rest of the THP.
>    - rwp_swapin: verify userfaultfd RWP survives PMD-order swap-in.
>    - munmap: unmap the full entry and check that VmSwap drops.
>    - mprotect: change full-range protections without faulting the entry in.
>    - split_mprotect: change half-range protections and verify the data.
>    - split_munmap: unmap half, drop its accounting, and preserve the rest.
>    - uffdio_move: move the entry and RWP state, then fault it in at dst.
>    - mremap: force the entry to a new aligned address and verify the data.
>    - pagemap: verify swapped bits and consecutive swap-slot offsets.
>    - mincore: walk the entry without faulting it in.
>    - madvise_free: release the slots, clear the entry, and verify zeroes.
>    - madvise_willneed: prefetch the entry and verify subsequent swap-in.
>    - swapoff: unuse the entry and preserve data and PMD/RWP state.
> 
> Fixture teardown owns the mappings and file descriptors and restores
> swap after assertion failures.  PMD_SWAP_DEVICE remains optional for
> swapoff.
> 
> Distinguish an environment that cannot allocate a PMD THP from a failure
> to install a PMD swap entry, so the former skips while the latter fails.
> Also check VmSwap accounting, pagemap slot offsets, swapped state after
> non-faulting operations, and PMD restoration when zswap does not require
> PTE fallback.
> 
> Register the test with run_vmtests.sh and the default kselftest runner.

Thanks for addressing the comments against v5, here's two general
comments:

1. On looking a bit closer at this, I realized that during swap-in
do_huge_pmd_swap_page() is retrieving the folio from the swap cache
and not exercising the swapin_sync() code path (at least this is the case
on a KVM a guest). I was able to workaround this on a test app by running
it from a cgroup and triggering reclaim manually after swap-out but before
swap-in. I'm not sure how complex it would be for you to implement this though

2. Did you use AI to generate this code? If yes, please add the
Assisted-by tag. I'm saying this because the code is weirdly uniform
and there's a bit of uneeded complexity

Small nits below, but the parts that I reviewed look good to me.

> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   tools/testing/selftests/mm/Makefile         |   2 +
>   tools/testing/selftests/mm/ksft_pmd_swap.sh |   4 +
>   tools/testing/selftests/mm/pmd_swap.c       | 742 ++++++++++++++++++++
>   tools/testing/selftests/mm/run_vmtests.sh   |   4 +
>   4 files changed, 752 insertions(+)
>   create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
>   create mode 100644 tools/testing/selftests/mm/pmd_swap.c
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index 2d5366196e309..dafa3a482451d 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
>   TEST_GEN_FILES += merge
>   TEST_GEN_FILES += rmap
>   TEST_GEN_FILES += folio_split_race_test
> +TEST_GEN_FILES += pmd_swap
>   
>   ifneq ($(ARCH),arm64)
>   TEST_GEN_FILES += soft-dirty
> @@ -165,6 +166,7 @@ TEST_PROGS += ksft_mremap.sh
>   TEST_PROGS += ksft_pagemap.sh
>   TEST_PROGS += ksft_pfnmap.sh
>   TEST_PROGS += ksft_pkey.sh
> +TEST_PROGS += ksft_pmd_swap.sh
>   TEST_PROGS += ksft_process_madv.sh
>   TEST_PROGS += ksft_process_mrelease.sh
>   TEST_PROGS += ksft_rmap.sh
> diff --git a/tools/testing/selftests/mm/ksft_pmd_swap.sh b/tools/testing/selftests/mm/ksft_pmd_swap.sh
> new file mode 100755
> index 0000000000000..0f070b4729a89
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pmd_swap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pmd_swap
> diff --git a/tools/testing/selftests/mm/pmd_swap.c b/tools/testing/selftests/mm/pmd_swap.c
> new file mode 100644
> index 0000000000000..30911ef6480f3
> --- /dev/null
> +++ b/tools/testing/selftests/mm/pmd_swap.c
> @@ -0,0 +1,742 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Test PMD-level swap entries and their users. */
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/wait.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <stdint.h>
> +#include <sys/random.h>
> +#include <sys/swap.h>
> +#include <sys/syscall.h>
> +#include <sys/ioctl.h>
> +#include <poll.h>
> +#include <pthread.h>
> +#include <linux/userfaultfd.h>
> +#include <time.h>
> +
> +#include "kselftest_harness.h"
> +#include "vm_util.h"
> +
> +#define ZSWAP_ENABLED_PATH "/sys/module/zswap/parameters/enabled"
> +
> +/* pagemap: bits 0-54 hold the PFN, or type|offset for a swap entry. */
> +#define PM_PFRAME_MASK		((1ULL << 55) - 1)
> +/* Must match MAX_SWAPFILES_SHIFT in include/linux/swap.h. */
> +#define MAX_SWAPFILES_SHIFT	5
> +
> +static bool check_swapped(int pagemap_fd, char *addr, unsigned long size)
> +{
> +	unsigned long off;
> +
> +	for (off = 0; off < size; off += getpagesize())
> +		if (!pagemap_is_swapped(pagemap_fd, addr + off))
> +			return false;
> +	return true;
> +}
> +
> +static bool zswap_enabled(void)
> +{
> +	char enabled = 0;
> +	FILE *f;
> +
> +	f = fopen(ZSWAP_ENABLED_PATH, "r");
> +	if (!f)
> +		return false;
> +
> +	if (fscanf(f, " %c", &enabled) != 1)
> +		enabled = 0;
> +	fclose(f);
> +
> +	return enabled == 'Y' || enabled == 'y' || enabled == '1';
> +}
> +
> +static bool swap_available(unsigned long required_bytes)
> +{
> +	unsigned long required_kb = (required_bytes + 1023) / 1024;
> +	unsigned long size_kb, used_kb;
> +	char line[256];
> +	bool ret = false;
> +	FILE *f;
> +
> +	f = fopen("/proc/swaps", "r");
> +	if (!f)
> +		return false;
> +
> +	/* Skip the header. */
> +	if (!fgets(line, sizeof(line), f))
> +		goto out;
> +
> +	while (fgets(line, sizeof(line), f)) {
> +		if (sscanf(line, "%*s %*s %lu %lu", &size_kb, &used_kb) == 2 &&
> +		    size_kb >= used_kb && size_kb - used_kb >= required_kb) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +
> +out:
> +	fclose(f);
> +	return ret;
> +}
> +
> +static unsigned long read_vm_event(const char *name)
> +{
> +	char line[256];
> +	size_t name_len = strlen(name);
> +	unsigned long val = 0;
> +	FILE *f;
> +
> +	f = fopen("/proc/vmstat", "r");
> +	if (!f)
> +		return 0;
> +	while (fgets(line, sizeof(line), f)) {
> +		if (!strncmp(line, name, name_len) && line[name_len] == ' ') {
> +			val = strtoul(line + name_len + 1, NULL, 10);
> +			break;
> +		}
> +	}
> +	fclose(f);
> +	return val;
> +}

Maybe put this in vm_util.c as you made it generic?

> +
> +static unsigned int random_seed(void)
> +{
> +	unsigned int seed;
> +
> +	if (getrandom(&seed, sizeof(seed), 0) != sizeof(seed))
> +		seed = (unsigned int)time(NULL);
> +	return seed;
> +}
> +
> +static unsigned char pattern_byte(unsigned int seed, unsigned long off)
> +{
> +	return (unsigned char)(seed + off + (off >> 8) + (off >> 16));
> +}

The shifting is not wrong, but I'm not sure it's necessary.

> +
> +static void fill_pattern(char *buf, unsigned long size, unsigned int seed)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < size; i++)
> +		buf[i] = (char)pattern_byte(seed, i);
> +}
> +
> +static bool verify_pattern_range(char *buf, unsigned long size,
> +				 unsigned int seed, unsigned long offset)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < size; i++)
> +		if ((unsigned char)buf[i] != pattern_byte(seed, offset + i))
> +			return false;
> +	return true;
> +}
> +
> +static bool verify_pattern(char *buf, unsigned long size, unsigned int seed)
> +{
> +	return verify_pattern_range(buf, size, seed, 0);
> +}
> +
> +static bool verify_zero(char *buf, unsigned long size)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < size; i++)
> +		if (buf[i])
> +			return false;
> +	return true;
> +}
> +
> +/*
> + * mmap an anonymous PMD-aligned region of pmd_size bytes. Over-allocates
> + * by one PMD and trims the unaligned head/tail so the returned address is
> + * PMD-aligned (required for whole-PMD UFFDIO_MOVE).
> + */
> +static char *mmap_pmd_aligned(unsigned long pmd_size)
> +{
> +	unsigned long pad = pmd_size;
> +	char *raw, *aligned;
> +
> +	raw = mmap(NULL, pmd_size + pad, PROT_READ | PROT_WRITE,
> +		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (raw == MAP_FAILED)
> +		return MAP_FAILED;
> +
> +	aligned = (char *)(((uintptr_t)raw + pmd_size - 1) & ~(pmd_size - 1));
> +	if (aligned != raw)
> +		munmap(raw, aligned - raw);
> +	if (aligned + pmd_size != raw + pmd_size + pad)
> +		munmap(aligned + pmd_size,
> +		       (raw + pmd_size + pad) - (aligned + pmd_size));
> +	return aligned;
> +}
> +
> +enum swap_thp_result {
> +	SWAP_THP_OK,
> +	SWAP_THP_UNAVAILABLE,
> +	SWAP_THP_FAILED,
> +};
> +
> +/* Per-process swapped size in bytes, from /proc/self/status VmSwap. */
> +static unsigned long read_vmswap(void)
> +{
> +	char line[256];
> +	unsigned long kb = 0;
> +	FILE *f;
> +
> +	f = fopen("/proc/self/status", "r");
> +	if (!f)
> +		return 0;
> +	while (fgets(line, sizeof(line), f)) {
> +		if (!strncmp(line, "VmSwap:", 7)) {
> +			kb = strtoul(line + 7, NULL, 10);
> +			break;
> +		}
> +	}
> +	fclose(f);
> +	return kb * 1024;
> +}
> +
> +static bool swap_out_pmd(char *mem, unsigned long pmd_size, int pagemap_fd)
> +{
> +	unsigned long before = read_vm_event("thp_swpout_pmd");
> +	unsigned long after;
> +
> +	if (madvise(mem, pmd_size, MADV_PAGEOUT)) {
> +		ksft_print_msg("MADV_PAGEOUT failed: %s\n", strerror(errno));
> +		return false;
> +	}
> +	if (!check_swapped(pagemap_fd, mem, pmd_size)) {
> +		ksft_print_msg("MADV_PAGEOUT did not swap the whole PMD range\n");
> +		return false;
> +	}
> +
> +	after = read_vm_event("thp_swpout_pmd");
> +	ksft_print_msg("thp_swpout_pmd: %lu -> %lu\n", before, after);
> +	return after > before;
> +}
> +
> +static char *alloc_fill_swap_thp(unsigned long pmd_size, int pagemap_fd,
> +				 unsigned int seed, enum swap_thp_result *res)
> +{
> +	char *mem;
> +
> +	*res = SWAP_THP_UNAVAILABLE;
> +
> +	mem = mmap_pmd_aligned(pmd_size);
> +	if (mem == MAP_FAILED)
> +		return MAP_FAILED;
> +
> +	if (madvise(mem, pmd_size, MADV_HUGEPAGE)) {
> +		ksft_print_msg("MADV_HUGEPAGE failed: %s\n", strerror(errno));
> +		munmap(mem, pmd_size);
> +		return MAP_FAILED;
> +	}
> +	fill_pattern(mem, pmd_size, seed);
> +
> +	if (!check_huge_anon(mem, pmd_size, 1, pmd_size)) {
> +		munmap(mem, pmd_size);
> +		return MAP_FAILED;
> +	}
> +	*res = SWAP_THP_FAILED;
> +
> +	if (!swap_out_pmd(mem, pmd_size, pagemap_fd)) {
> +		munmap(mem, pmd_size);
> +		return MAP_FAILED;
> +	}
> +
> +	*res = SWAP_THP_OK;
> +	return mem;
> +}

Is the enum really needed? Maybe just have a bool *swap_failed instead?

> +
> +struct rwp_access_args {
> +	unsigned char *addr;
> +	unsigned char expected;
> +	bool write;
> +	bool ok;
> +};
> +
> +static void *rwp_access_thread(void *data)
> +{
> +	struct rwp_access_args *args = data;
> +
> +	if (args->write)
> +		*args->addr = args->expected;
> +	args->ok = *args->addr == args->expected;
> +	return NULL;
> +}
> +
> +static int register_rwp(char *addr, unsigned long size, bool protect)
> +{
> +	struct uffdio_register reg = {};
> +	struct uffdio_rwprotect rwp = {};
> +	struct uffdio_api api = {};
> +	int uffd;
> +
> +	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> +	if (uffd < 0)
> +		return -1;
> +
> +	api.api = UFFD_API;
> +	api.features = UFFD_FEATURE_RWP;
> +	if (ioctl(uffd, UFFDIO_API, &api) ||
> +	    !(api.features & UFFD_FEATURE_RWP))
> +		goto error;
> +
> +	reg.range.start = (unsigned long)addr;
> +	reg.range.len = size;
> +	reg.mode = UFFDIO_REGISTER_MODE_RWP;
> +	if (ioctl(uffd, UFFDIO_REGISTER, &reg))
> +		goto error;
> +
> +	if (!protect)
> +		return uffd;
> +
> +	rwp.range.start = (unsigned long)addr;
> +	rwp.range.len = size;
> +	rwp.mode = UFFDIO_RWPROTECT_MODE_RWP;
> +	if (!ioctl(uffd, UFFDIO_RWPROTECT, &rwp))
> +		return uffd;
> +
> +error:
> +	close(uffd);
> +	return -1;
> +}
> +
> +static bool expect_rwp_fault(int uffd, char *addr, unsigned long size,
> +			     unsigned char expected, bool write)
> +{
> +	struct rwp_access_args args = {
> +		.addr = (unsigned char *)addr,
> +		.expected = expected,
> +		.write = write,
> +	};
> +	struct uffdio_rwprotect rwp = {
> +		.range = {
> +			.start = (unsigned long)addr,
> +			.len = size,
> +		},
> +	};
> +	struct pollfd pollfd = {
> +		.fd = uffd,
> +		.events = POLLIN,
> +	};
> +	struct uffd_msg msg = {};
> +	pthread_t thread;
> +	bool saw_rwp = false;
> +	int ret;
> +
> +	if (pthread_create(&thread, NULL, rwp_access_thread, &args))
> +		return false;
> +
> +	ret = poll(&pollfd, 1, 5000);
> +	if (ret == 1 && (pollfd.revents & POLLIN) &&
> +	    read(uffd, &msg, sizeof(msg)) == (ssize_t)sizeof(msg)) {
> +		saw_rwp = msg.event == UFFD_EVENT_PAGEFAULT &&
> +			  (msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_RWP);
> +	}
> +
> +	/* Resolve the access even on failure so the worker cannot remain blocked. */
> +	ioctl(uffd, UFFDIO_RWPROTECT, &rwp);
> +	if (pthread_join(thread, NULL))
> +		return false;
> +	return saw_rwp && args.ok;
> +}
> +
> +FIXTURE(pmd_swap)
> +{
> +	unsigned long pmd_size;
> +	unsigned long mem_len;
> +	int pagemap_fd;
> +	int uffd;
> +	unsigned int seed;
> +	bool zswap_enabled;
> +	bool swap_disabled;
> +	const char *swap_dev;
> +	char *mem;
> +	char *aux;
> +};
> +
> +FIXTURE_SETUP(pmd_swap)
> +{
> +	enum swap_thp_result res;
> +
> +	self->pagemap_fd = -1;
> +	self->uffd = -1;
> +	self->mem = MAP_FAILED;
> +	self->aux = MAP_FAILED;
> +	self->mem_len = 0;
> +	self->swap_disabled = false;
> +	self->swap_dev = getenv("PMD_SWAP_DEVICE");
> +	if (!strcmp(_metadata->name, "swapoff") && !self->swap_dev)
> +		SKIP(return, "PMD_SWAP_DEVICE env var not set\n");

This seeems to be specific to the swapoff test? If yes, it would be
better to have it contained in the test itself not the fixture.

> +
> +	self->pmd_size = read_pmd_pagesize();
> +	if (!self->pmd_size)
> +		SKIP(return, "Cannot determine PMD size\n");
> +
> +	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (self->pagemap_fd < 0)
> +		SKIP(return, "Cannot open /proc/self/pagemap\n");
> +
> +	if (!swap_available(self->pmd_size))
> +		SKIP(return, "No active swap device has enough free space\n");
> +
> +	self->seed = random_seed();
> +	self->zswap_enabled = zswap_enabled();
> +	self->mem = alloc_fill_swap_thp(self->pmd_size, self->pagemap_fd,
> +					self->seed, &res);
> +	if (self->mem == MAP_FAILED) {
> +		ASSERT_NE(res, SWAP_THP_FAILED);
> +		SKIP(return, "Could not create swapped THP\n");
> +	}
> +	self->mem_len = self->pmd_size;
> +}
> +
> +FIXTURE_TEARDOWN(pmd_swap)
> +{
> +	int swap_err = 0;
> +	int swap_ret = 0;
> +
> +	if (self->swap_disabled) {
> +		swap_ret = swapon(self->swap_dev, 0);
> +		swap_err = errno;
> +	}
> +	if (self->uffd >= 0)
> +		close(self->uffd);
> +	if (self->aux != MAP_FAILED)
> +		munmap(self->aux, self->pmd_size);
> +	if (self->mem != MAP_FAILED)
> +		munmap(self->mem, self->mem_len);
> +	if (self->pagemap_fd >= 0)
> +		close(self->pagemap_fd);
> +
> +	EXPECT_EQ(swap_ret, 0) {
> +		TH_LOG("swapon(%s) failed: %s", self->swap_dev,
> +		       strerror(swap_err));
> +	}
> +}
> +
> +TEST_F(pmd_swap, basic)
> +{
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +}
> +
> +TEST_F(pmd_swap, fork)
> +{
> +	pid_t pid;
> +	int status;
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +
> +	if (pid == 0)
> +		_exit(verify_pattern(self->mem, self->pmd_size,
> +				     self->seed) ? 0 : 1);
> +
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +
> +	ASSERT_EQ(waitpid(pid, &status, 0), pid);
> +	ASSERT_TRUE(WIFEXITED(status));
> +	ASSERT_EQ(WEXITSTATUS(status), 0);
> +}
> +
> +TEST_F(pmd_swap, fork_cow)
> +{
> +	unsigned int parent_seed = self->seed;
> +	unsigned int child_seed = ~self->seed;
> +	unsigned int new_seed = self->seed ^ 0xa5a5a5a5;
> +	int release_child[2];
> +	bool parent_ok;
> +	char c = 0;
> +	pid_t pid;
> +	int status, ret;
> +
> +	ASSERT_EQ(pipe(release_child), 0);
> +
> +	pid = fork();
> +	ASSERT_GE(pid, 0);
> +
> +	if (pid == 0) {
> +		close(release_child[1]);
> +		if (read(release_child[0], &c, 1) != 1)
> +			_exit(1);
> +		if (!verify_pattern(self->mem, self->pmd_size, parent_seed))
> +			_exit(2);
> +		fill_pattern(self->mem, self->pmd_size, child_seed);
> +		if (!verify_pattern(self->mem, self->pmd_size, child_seed))
> +			_exit(3);
> +		_exit(0);
> +	}
> +
> +	close(release_child[0]);
> +	fill_pattern(self->mem, self->pmd_size, new_seed);
> +	parent_ok = verify_pattern(self->mem, self->pmd_size, new_seed);
> +	ret = write(release_child[1], &c, 1);
> +	close(release_child[1]);
> +	ASSERT_EQ(waitpid(pid, &status, 0), pid);
> +	ASSERT_EQ(ret, 1);
> +	ASSERT_TRUE(parent_ok);
> +	ASSERT_TRUE(WIFEXITED(status));
> +	ASSERT_EQ(WEXITSTATUS(status), 0);
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, new_seed));
> +}
> +
> +TEST_F(pmd_swap, write)
> +{
> +	self->mem[0] = 0xbb;
> +	ASSERT_EQ(self->mem[0], (char)0xbb);
> +	ASSERT_TRUE(verify_pattern_range(self->mem + 1, self->pmd_size - 1,
> +					 self->seed, 1));
> +	if (!self->zswap_enabled)
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, rwp_swapin)
> +{
> +	self->uffd = register_rwp(self->mem, self->pmd_size, true);
> +	if (self->uffd < 0)
> +		SKIP(return, "Userfaultfd RWP unsupported\n");
> +
> +	ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem, self->pmd_size,
> +				     pattern_byte(self->seed, 0), false));
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +}
> +
> +TEST_F(pmd_swap, munmap)
> +{
> +	unsigned long swap_before, swap_after;
> +	int ret;
> +
> +	swap_before = read_vmswap();
> +	ASSERT_GE(swap_before, self->pmd_size);
> +
> +	ret = munmap(self->mem, self->pmd_size);
> +	if (!ret) {
> +		self->mem = MAP_FAILED;
> +		self->mem_len = 0;
> +	}
> +	ASSERT_EQ(ret, 0);
> +
> +	swap_after = read_vmswap();
> +	ASSERT_LE(swap_after, swap_before - self->pmd_size);
> +}
> +
> +TEST_F(pmd_swap, mprotect)
> +{
> +	ASSERT_EQ(mprotect(self->mem, self->pmd_size, PROT_READ), 0);
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +	ASSERT_EQ(mprotect(self->mem, self->pmd_size,
> +			   PROT_READ | PROT_WRITE), 0);
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +}
> +
> +TEST_F(pmd_swap, split_mprotect)
> +{
> +	unsigned long half = self->pmd_size / 2;
> +
> +	ASSERT_EQ(mprotect(self->mem, half, PROT_READ), 0);
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +	ASSERT_EQ(mprotect(self->mem, half, PROT_READ | PROT_WRITE), 0);
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +}
> +
> +TEST_F(pmd_swap, split_munmap)
> +{
> +	unsigned long half = self->pmd_size / 2;
> +	unsigned long swap_before = read_vmswap();
> +	unsigned long i;
> +	char *base = self->mem;
> +	int ret;
> +
> +	ASSERT_GE(swap_before, half);
> +	ret = munmap(base, half);
> +	if (!ret) {
> +		self->mem = base + half;
> +		self->mem_len = half;
> +	}
> +	ASSERT_EQ(ret, 0);
> +	ASSERT_LE(read_vmswap(), swap_before - half);
> +
> +	for (i = 0; i < half; i += getpagesize())
> +		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd,
> +					       self->mem + i));
> +	ASSERT_TRUE(verify_pattern_range(self->mem, half, self->seed, half));
> +}
> +
> +TEST_F(pmd_swap, uffdio_move)
> +{
> +	struct uffdio_register reg = {};
> +	struct uffdio_move move = {};
> +	struct uffdio_api api = {};
> +	bool rwp;
> +
> +	self->aux = mmap_pmd_aligned(self->pmd_size);
> +	if (self->aux == MAP_FAILED)
> +		SKIP(return, "Could not mmap aligned dst\n");
> +	ASSERT_EQ(madvise(self->aux, self->pmd_size, MADV_HUGEPAGE), 0);
> +
> +	self->uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
> +	if (self->uffd < 0)
> +		SKIP(return, "userfaultfd unavailable\n");
> +
> +	api.api = UFFD_API;
> +	api.features = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP;
> +	if (ioctl(self->uffd, UFFDIO_API, &api) ||
> +	    !(api.features & UFFD_FEATURE_MOVE))
> +		SKIP(return, "UFFD_FEATURE_MOVE unsupported\n");
> +	rwp = api.features & UFFD_FEATURE_RWP;
> +
> +	reg.range.start = (unsigned long)self->aux;
> +	reg.range.len = self->pmd_size;
> +	reg.mode = UFFDIO_REGISTER_MODE_MISSING |
> +		   (rwp ? UFFDIO_REGISTER_MODE_RWP : 0);
> +	ASSERT_EQ(ioctl(self->uffd, UFFDIO_REGISTER, &reg), 0);
> +
> +	move.dst = (unsigned long)self->aux;
> +	move.src = (unsigned long)self->mem;
> +	move.len = self->pmd_size;
> +	ASSERT_EQ(ioctl(self->uffd, UFFDIO_MOVE, &move), 0);
> +	ASSERT_EQ(move.move, self->pmd_size);
> +
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->aux,
> +				  self->pmd_size));
> +	if (rwp)
> +		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->aux,
> +					     self->pmd_size,
> +					     pattern_byte(self->seed, 0), false));
> +	ASSERT_TRUE(verify_pattern(self->aux, self->pmd_size, self->seed));
> +	if (!self->zswap_enabled)
> +		ASSERT_TRUE(check_huge_anon(self->aux, self->pmd_size, 1,
> +					    self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, mremap)
> +{
> +	char *new_mem, *dst;
> +
> +	self->aux = mmap_pmd_aligned(self->pmd_size);
> +	if (self->aux == MAP_FAILED)
> +		SKIP(return, "Could not mmap aligned dst\n");
> +	dst = self->aux;
> +
> +	new_mem = mremap(self->mem, self->pmd_size, self->pmd_size,
> +			 MREMAP_MAYMOVE | MREMAP_FIXED, dst);
> +	if (new_mem != MAP_FAILED) {
> +		self->mem = new_mem;
> +		self->aux = MAP_FAILED;
> +	}
> +	ASSERT_NE(new_mem, MAP_FAILED);
> +	ASSERT_EQ(new_mem, dst);
> +
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, new_mem, self->pmd_size));
> +	ASSERT_TRUE(verify_pattern(new_mem, self->pmd_size, self->seed));
> +}
> +
> +TEST_F(pmd_swap, pagemap)
> +{
> +	uint64_t entry, first = 0;
> +	unsigned long off;
> +
> +	for (off = 0; off < self->pmd_size; off += getpagesize()) {
> +		entry = pagemap_get_entry(self->pagemap_fd, self->mem + off);
> +		ASSERT_TRUE(entry & (1ULL << 62));
> +		ASSERT_FALSE(entry & (1ULL << 63));
> +
> +		if (entry & PM_PFRAME_MASK) {
> +			uint64_t idx = off / getpagesize();
> +
> +			if (!off)
> +				first = entry & PM_PFRAME_MASK;
> +			ASSERT_EQ(entry & PM_PFRAME_MASK,
> +				  first + (idx << MAX_SWAPFILES_SHIFT));
> +		}
> +	}
> +}
> +
> +TEST_F(pmd_swap, mincore)
> +{
> +	unsigned long pages = self->pmd_size / getpagesize();
> +	unsigned char vec[pages];
> +
> +	ASSERT_EQ(mincore(self->mem, self->pmd_size, vec), 0);
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, madvise_free)
> +{
> +	unsigned long swap_before = read_vmswap();
> +	unsigned long i;
> +
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +	ASSERT_GE(swap_before, self->pmd_size);
> +	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_FREE), 0);
> +	for (i = 0; i < self->pmd_size; i += getpagesize())
> +		ASSERT_FALSE(pagemap_is_swapped(self->pagemap_fd,
> +						self->mem + i));
> +	ASSERT_LE(read_vmswap(), swap_before - self->pmd_size);
> +	ASSERT_TRUE(verify_zero(self->mem, self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, madvise_willneed)
> +{
> +	ASSERT_EQ(madvise(self->mem, self->pmd_size, MADV_WILLNEED), 0);
> +	ASSERT_TRUE(check_swapped(self->pagemap_fd, self->mem,
> +				  self->pmd_size));
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +	if (!self->zswap_enabled)
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, swapoff)
> +{
> +	int ret, err;
> +
> +	self->uffd = register_rwp(self->mem, self->pmd_size, true);
> +
> +	ret = swapoff(self->swap_dev);
> +	err = errno;
> +	if (!ret)
> +		self->swap_disabled = true;
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("swapoff(%s) failed: %s", self->swap_dev, strerror(err));
> +	}
> +
> +	/*
> +	 * Check residency before touching the memory. If we read
> +	 * first, a bug that left a PMD swap entry in place after swapoff
> +	 * would silently trigger do_huge_pmd_swap_page() and reinstall a
> +	 * PMD mapping, masking the regression.
> +	 */
> +	if (!self->zswap_enabled)
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
> +	if (self->uffd >= 0)
> +		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem,
> +					     self->pmd_size,
> +					     pattern_byte(self->seed, 0), false));
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +
> +	ret = swapon(self->swap_dev, 0);
> +	err = errno;
> +	if (!ret)
> +		self->swap_disabled = false;
> +	ASSERT_EQ(ret, 0) {
> +		TH_LOG("swapon(%s) failed: %s", self->swap_dev, strerror(err));
> +	}
> +}
> +
> +TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d09f9f6a384ee..ff53ff28c0042 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -69,6 +69,8 @@ separated by spaces:
>   	test pagemap_scan IOCTL
>   - pfnmap
>   	tests for VM_PFNMAP handling
> +- pmd_swap
> +	tests for PMD-level swap entries
>   - process_madv
>   	test for process_madv
>   - cow
> @@ -399,6 +401,8 @@ CATEGORY="pagemap" run_test ./pagemap_ioctl
>   
>   CATEGORY="pfnmap" run_test ./pfnmap
>   
> +CATEGORY="pmd_swap" run_test ./pmd_swap
> +
>   # COW tests
>   CATEGORY="cow" run_test ./cow
>   


