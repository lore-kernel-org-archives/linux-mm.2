Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982E2CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA7F6B008A; Wed,  7 Oct 2026 22:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB066B008C; Wed,  7 Oct 2026 22:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24AE16B0092; Wed,  7 Oct 2026 22:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCADE6B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:47:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CEF5A7891
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:47:34 +0000 (UTC)
X-FDA: 85297923228.24.E7AD0D4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1F27C0009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:47:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gpcJ4U5Y;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791427652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8SkXdJgMmBgekv5uX9hPNtKI7AU82XttzzvaHnS3Pg=;
	b=So39/NUJy7qPc5lgCIOeI6ro7FknOU8vb+RY8dn3+EqVU+wgv67rhfuss24qKLUWGylcp6
	/gjbCaJP/ugP9fgnfWQOUP27M7R+ae+EQ8bFysdZxJmqrcGSyn0nFWvtb6Qfl6pzTL8hHe
	Amh515/GzXPf+oY5Dxam9chAzC7Apo4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gpcJ4U5Y;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791427652;
	b=QV/lzfu+Jg2KvRBbO6gXFevsNgRpv4tL6PVWRIBbniWiFfLPJaBKrLLp6qj+kUzGqF8TsA
	NyQTZHP4PvrBpi4hmkzspSGOKwjCqcw1n7IyGg35eyoXdhB0lxoIZULAdSj1Xvet0qFEfI
	fk09Skfj250A3OomUt15lQUKv9q28lo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791427651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J8SkXdJgMmBgekv5uX9hPNtKI7AU82XttzzvaHnS3Pg=;
	b=gpcJ4U5YnL3q32uZCM0Z9X4+zFwhi0bO3kQcrVhylB3PH2+T1+bLytCUDMSD0jibiTXWcZ
	H2eeJ5ptfIFeou6nW4L3a/woAsIFNbeGYNhnrEjlCF4BihTHYvxnCKq65OExgvhqTH42TV
	5De7Gy3gpey0nqH5uzBZweNBDVsUrYs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-IjGYjCb5NsiBB8M7OvL59A-1; Wed, 07 Oct 2026 22:47:29 -0400
X-MC-Unique: IjGYjCb5NsiBB8M7OvL59A-1
X-Mimecast-MFC-AGG-ID: IjGYjCb5NsiBB8M7OvL59A_1791427648
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-919879b09b7so51253096d6.3
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 19:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791427648; x=1792032448;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J8SkXdJgMmBgekv5uX9hPNtKI7AU82XttzzvaHnS3Pg=;
        b=aymGjoYk+crLrvW3ECg5dXmnRtwmEzK2sB6zqdaShjQCfD1FBe2wCAt94LhSFMeglq
         hRoUPelu6SY8jsD2Xa65TH/gfHSra3Ysb8cIfRTBNFKoDxUUa2WOssez9KAsQ1b399eA
         Yyp/En/sNprwAWuVEMzFw13YOeXLtlL0bSwDCYnyweWB8cSwRAGpI4cmfvixxr0/zhX4
         8H2npL4eHnOgGMtolJiwf+KhJM29t4wjEh7opV1eAlQaI2OuqOAO3ik5wWHaXM9IXB/k
         a0OHg7feD3ax00oJ8fubMw7a9MC7nkSO2IS23WR3vC95RzXpaOXvVizAkZwY+tkq/TPs
         OXWA==
X-Forwarded-Encrypted: i=1; AKwUvByPH6ScJVo99xmWVvwdh+86GvmzoWnTYGnnYKbsOl7Ert9Z8Y0S4210gcrMuMQF2aeeaLlPItGY5g==@kvack.org
X-Gm-Message-State: AFq9FYJiWFrcIjhgc7Izy+CSGwG7rQ88HVm+0YR0RYhwwN/Uvxgv/Tzh
	3LnTvFSMGrTyxvKSVUcm7pAST4GcuTEsVByb7s9akXanor3HiV6heVXZCIm02himlc8hsZjnTNO
	EizSLugMvuo6igyfCUlHpFa857VzA4S3gaQwkXYCt5R0SoltiCMXY
X-Gm-Gg: AYBFou36XO4x2KFAAivZzG9Lex+zXoZJGQdHwEi2AMwYLSwOuLU2NDW0u791mx2GyLK
	yRItdNw8poLy/zMVqEpi7vgmOd/jmn3TCFI49p8oBDcmRSxwf85hp7XfSOrv8nWvTfzgLqCqxiK
	q80RB2lx8wEO1oTb0v82oWeVd74JGe137Qq8Fnjt/ZP0c1/0LJQCQmyT9YtXLdS+Kvh8g5smCa0
	E1t78mTZvDLY3VhvNLze6SktjUDMOqLHNcq6WuzRmYh8XOOuic+g4CdleNytY5vpCuiJU+r4SsZ
	7ZNdQsAa95Acx160WqKWUnrP1RO2CeE4fJk/GzwEwDvSj0bjzV/pGSyZM7IDtBABjDFAQtzi37M
	mRE8=
X-Received: by 2002:a05:6214:2684:b0:919:860d:3df9 with SMTP id 6a1803df08f44-919977d2c2dmr81171416d6.16.1791427647820;
        Wed, 07 Oct 2026 19:47:27 -0700 (PDT)
X-Received: by 2002:a05:6214:2684:b0:919:860d:3df9 with SMTP id 6a1803df08f44-919977d2c2dmr81170966d6.16.1791427647043;
        Wed, 07 Oct 2026 19:47:27 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9199814947fsm32689316d6.23.2026.10.07.19.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 19:47:26 -0700 (PDT)
Message-ID: <0dd22f82-058c-40ad-8f52-4d95020851a1@redhat.com>
Date: Wed, 7 Oct 2026 22:47:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/30] selftests/mm: add PMD swap entry tests
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
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 kernel-team@meta.com
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <20261002095503.3585565-31-usama.arif@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20261002095503.3585565-31-usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HaJO7eYochq8H7jcttQedu9lVO3aN79o5-zWqlzypQ0_1791427648
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A1F27C0009
X-Rspam-User: 
X-Stat-Signature: fwy869oxnf1y3bf7fyu5okbmj8ebo1n4
X-HE-Tag: 1791427651-421251
X-HE-Meta: U2FsdGVkX1+yLuMRF5JIk/zPlzRcbPAbnuCihyaCWLLEM/c8Fetif+aLunXa8DWb2RtAe81oIcXjh/xXip8Rez1XXka8mV0PJU48V8xjqdGz2bUj4j5PJ3KZPRd13Mnc2DVE4TBvZDObgFSzPPeiW43Krgtd9Af31rgN9VrBAyhXz3wkGZH1vzxmOtIHij35/7RZtaLYNX6I+nsOmI23/pN3BasrbBXvsct9MkZkSI0rzy2BcFtrrkPmNNpaVNHnYinWrbWFGf13LjUCiyrI1+BZA575cHyHqA/Xx8sDlqsX8fOdBgjyzkp/IdqkDxczaKFWzeFz5xlrEqmEnl3M9WeFelbZftrIMnwgJHQK4qsTagQIxAdBDWqFU0CJMY4R0qwzB19exVSuIZMCk0Gi508hP1Amkk9dMxW8FV/Q2qX+6/YSYAGmIyJvn3AsyvFm/ipxbHzrVjMQ+7iOt5M/3bSUkvmyVb6+jIBp7tgIQergsN7f4Ejws+/7gl15lQw1UWx1DQ5X7SKQFwnaMu/Ulyp/b/Q4fY0sm7YCFzBTonrdvD54xf1SrVSV/l+3CT4oHWLsKNSjXISj922WyBMLQhstyX13LvUvgSyxg0wolLM5SFCWTfVIG6SFLRMmSJWQXt4Zoxv7s/XWj5M6E1LkPkwxleovjqr7oF8SiPxXOKOC8kXnEj0e6A5TN9U4c8mMfurLbPcN83A7mu+r2PvS2nw6OWito+fglrL+0W80Cv+I9ETem5W6tqSZ8HttAiTPvQ9jglft9As8XbvKmCzkbDbnRVxwqKwUge6wRXPtu1tFutVmmI3PQXgCTYdzpmksBuIKvyRHPPm3C7/16OpP5OsMc1m30vnwAFgh5qNbLavSwQSDgRflY4l9T0bGnCuTZix2m+7CJHTfrgGacw5tJiI3xMDx4LjdAqgvSBvw9bKJWp/smuNNe00/dKnS+QmTFhqEIBnlC9HiY/zbBs3
 jXIe+a8B
 p7aRoyAwhhnIXRVA/Gk5JTC/4RQA8b6SxL0cTLtnXuMev0i7e/8leN6/2VkjahK6oo44WC5Ibpx8Y9u4VL1gPG3aswkrynnFdfICnFZTk27oQ4M0EMxU9FXJj10ywJM37gfPrv7Enf1HBWCptBKUMyvgA2XAX6gTIqxjzv/x+oD8DXpOzG9G3UdP6FPKZ+O51HhU1zDF7IvkuPfxqlMkO5Ipe1d/IA/SHDcezfsAFd5OgmUc4COCTc4TQmOEq2wypCoRRtStNrSY1eSl8lJu7Xqhj3lILdHuRvzGcAWa1SdQ8HIRyDkIr0mvsDeMhwKuLmQ8TKJWJoP361L6QAnv3Pce5XgLMaKOR/5xUBApIyBpgjx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 5:52 AM, Usama Arif wrote:
> Each test gets a fresh PMD-mapped THP from fixture setup, fills it with a
> pattern that differs between base pages so a reordered split is detectable,
> swaps it out with MADV_PAGEOUT, and verifies thp_swpout_pmd increased
> before the test body runs.
> 
> The tests are basic, swapin_sync, fork, fork_cow, write, rwp_swapin,
> munmap, mprotect, split_mprotect, split_munmap, uffdio_move, mremap,
> pagemap, mincore, madvise_free, madvise_willneed and swapoff.
> 
> MADV_PAGEOUT leaves the folio in the swap cache on an asynchronous device,
> so a fault would only remap it and never reach swapin_sync(). Fixture setup
> therefore asks the current cgroup to reclaim afterwards, and uses mincore()
> - which reports a PMD swap entry as resident exactly while the cache holds
> it - to tell whether that worked. Tests run either way; swapin_sync skips
> if the cache survived. The swapoff test runs only when PMD_SWAP_DEVICE is
> the sole active swap device, and restores it at its original priority.
> 
> Skip rather than fail where the kernel never promised anything.
> thp_swpout_pmd and thp_swpout_fallback are system-wide, so test the
> fallback counter first: if reclaim split any THP we cannot be sure it was
> not ours. That also covers a kernel without CONFIG_THP_SWAP. A kernel with
> no thp_swpout_pmd counter does not implement the feature at all.
> 
> With zswap enabled the range may legitimately come back through the PTE
> fallback, so those runs skip the PMD-restoration assertions and say so.
> 
> Add a /proc/vmstat field reader to vm_util.c so other tests can use it too,
> and register pmd_swap with run_vmtests.sh and the default runner.
> 
> Assisted-by: LLM
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I confirmed this should be taking the swapin_sync() path on swap-in now
with the addition of the swap cache eviction code. Also, I reviewed most
of this and it looks good to me so:

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/Makefile         |   2 +
>   tools/testing/selftests/mm/ksft_pmd_swap.sh |   4 +
>   tools/testing/selftests/mm/pmd_swap.c       | 989 ++++++++++++++++++++
>   tools/testing/selftests/mm/run_vmtests.sh   |   4 +
>   tools/testing/selftests/mm/vm_util.c        |  24 +
>   tools/testing/selftests/mm/vm_util.h        |   2 +
>   6 files changed, 1025 insertions(+)
>   create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
>   create mode 100644 tools/testing/selftests/mm/pmd_swap.c
> 
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index d3e9bd67904aa..a685988a3d569 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
>   TEST_GEN_FILES += merge
>   TEST_GEN_FILES += rmap
>   TEST_GEN_FILES += folio_split_race_test
> +TEST_GEN_FILES += pmd_swap
>   TEST_GEN_FILES += soft-dirty
>   
>   ifeq ($(ARCH),x86_64)
> @@ -162,6 +163,7 @@ TEST_PROGS += ksft_mremap.sh
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
> index 0000000000000..91bac9ae5560e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/pmd_swap.c
> @@ -0,0 +1,989 @@
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
> +#include <sys/stat.h>
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
> +static bool same_swap_device(const struct stat *a, const struct stat *b)
> +{
> +	if (S_ISBLK(a->st_mode) && S_ISBLK(b->st_mode))
> +		return a->st_rdev == b->st_rdev;
> +	return a->st_dev == b->st_dev && a->st_ino == b->st_ino;
> +}
> +
> +/*
> + * Returns true if @swap_dev is the one and only active swap device, and stores
> + * its /proc/swaps priority in *prio so the caller can put it back the way it
> + * found it.
> + */
> +static bool swap_device_is_only_active(const char *swap_dev, int *prio)
> +{
> +	struct stat expected, active;
> +	char path[256], line[512];
> +	unsigned int nr_active = 0;
> +	bool matches = false;
> +	FILE *f;
> +
> +	*prio = -1;
> +
> +	if (stat(swap_dev, &expected))
> +		return false;
> +
> +	f = fopen("/proc/swaps", "r");
> +	if (!f)
> +		return false;
> +	if (!fgets(line, sizeof(line), f))
> +		goto out;
> +
> +	while (fgets(line, sizeof(line), f)) {
> +		int line_prio;
> +
> +		if (sscanf(line, "%255s %*s %*s %*s %d", path, &line_prio) != 2)
> +			continue;
> +		nr_active++;
> +		if (nr_active > 1)
> +			goto out;
> +		matches = !stat(path, &active) &&
> +			  same_swap_device(&expected, &active);
> +		if (matches)
> +			*prio = line_prio;
> +	}
> +
> +out:
> +	fclose(f);
> +	return nr_active == 1 && matches;
> +}
> +
> +/* Re-enable a device swapoff()ed by this test, at its original priority. */
> +static int swapon_restore(const char *swap_dev, int prio)
> +{
> +	int flags = 0;
> +
> +	if (prio >= 0)
> +		flags = SWAP_FLAG_PREFER |
> +			((prio << SWAP_FLAG_PRIO_SHIFT) & SWAP_FLAG_PRIO_MASK);
> +	return swapon(swap_dev, flags);
> +}
> +
> +/* Locate this task's cgroup-v2 directory. An empty relative path is the root. */
> +static bool cgroup2_self_dir(char *buf, size_t len)
> +{
> +	char mnt[PATH_MAX] = "", type[64], rel[PATH_MAX] = "";
> +	char line[2 * PATH_MAX];
> +	size_t rel_len;
> +	FILE *f;
> +
> +	f = fopen("/proc/self/mounts", "r");
> +	if (!f)
> +		return false;
> +	while (fgets(line, sizeof(line), f)) {
> +		if (sscanf(line, "%*s %4095s %63s", mnt, type) == 2 &&
> +		    !strcmp(type, "cgroup2"))
> +			goto found_mnt;
> +	}
> +	mnt[0] = '\0';
> +found_mnt:
> +	fclose(f);
> +	if (!mnt[0])
> +		return false;
> +
> +	f = fopen("/proc/self/cgroup", "r");
> +	if (!f)
> +		return false;
> +	while (fgets(line, sizeof(line), f)) {
> +		if (strncmp(line, "0::", 3))
> +			continue;
> +		rel_len = strcspn(line + 3, "\n");
> +		if (rel_len && rel_len < sizeof(rel)) {
> +			memcpy(rel, line + 3, rel_len);
> +			rel[rel_len] = '\0';
> +		}
> +		break;
> +	}
> +	fclose(f);
> +	if (!rel[0])
> +		return false;
> +	if (!strcmp(rel, "/"))
> +		rel[0] = '\0';
> +	return snprintf(buf, len, "%s%s/memory.reclaim", mnt, rel) < (int)len;
> +}
> +
> +static bool cgroup_reclaim(unsigned long bytes)
> +{
> +	char path[PATH_MAX], val[32];
> +	ssize_t written;
> +	int fd, len, err;
> +
> +	if (!cgroup2_self_dir(path, sizeof(path)))
> +		return false;
> +
> +	fd = open(path, O_WRONLY);
> +	if (fd < 0)
> +		return false;
> +	len = snprintf(val, sizeof(val), "%lu", bytes);
> +	written = write(fd, val, len);
> +	err = errno;
> +	close(fd);
> +	/* -EAGAIN means it reclaimed something but fell short, which is fine. */
> +	return written == len || err == EAGAIN;
> +}
> +
> +/*
> + * mincore() reports 1 over a PMD swap entry iff the swap cache still holds it.
> + * This samples the first slot only: it is a hint used to decide whether the
> + * swap cache was evicted, not an assertion about the whole range.
> + */
> +static bool swapcache_resident(char *mem)
> +{
> +	unsigned char vec[1];
> +
> +	if (mincore(mem, getpagesize(), vec))
> +		return true;
> +	return vec[0] & 1;
> +}
> +
> +/*
> + * MADV_PAGEOUT leaves the folio in the swap cache on asynchronous swap
> + * devices, so faulting would just remap the cached folio and never reach
> + * swapin_sync(). Push it out so the PMD-order swap-in path is exercised.
> + */
> +static bool drop_swapcache(char *mem, unsigned long pmd_size)
> +{
> +	unsigned long want = pmd_size;
> +	int i;
> +
> +	for (i = 0; i < 3 && swapcache_resident(mem); i++, want *= 4)
> +		if (!cgroup_reclaim(want))
> +			break;
> +	return !swapcache_resident(mem);
> +}
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
> +static unsigned long test_page_size(void)
> +{
> +	static unsigned long page_size;
> +
> +	if (!page_size)
> +		page_size = getpagesize();
> +	return page_size;
> +}
> +
> +/*
> + * Two base pages of the same PMD must never hold identical bytes, or the split
> + * tests cannot tell that the slots came back in the wrong order. A single byte
> + * cannot encode a page index on its own - HPAGE_PMD_NR is 8192 on arm64 with
> + * 64K pages - so spell the index out in the first two bytes of every page.
> + */
> +static unsigned char pattern_byte(unsigned int seed, unsigned long off)
> +{
> +	unsigned long page_size = test_page_size();
> +	unsigned long idx = off & (page_size - 1);
> +
> +	if (idx < 2)
> +		return (unsigned char)(seed + ((off / page_size) >> (idx * 8)));
> +
> +	return (unsigned char)(seed + off + (off >> 8) + (off >> 16));
> +}
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
> +/*
> + * Swap the PMD range out. Returns true if a PMD swap entry was installed.
> + * On failure *swap_failed is set unless this environment simply cannot swap
> + * at PMD granularity, in which case the caller should skip rather than fail.
> + */
> +static bool swap_out_pmd(char *mem, unsigned long pmd_size, int pagemap_fd,
> +			 bool *swap_failed)
> +{
> +	long pmd_before = read_vmstat("thp_swpout_pmd");
> +	long fallback_before = read_vmstat("thp_swpout_fallback");
> +	long pmd_after, fallback_after;
> +	bool swapped;
> +
> +	/*
> +	 * A kernel without PMD swap entry support has no thp_swpout_pmd at
> +	 * all. Skip rather than report a failure the kernel never promised.
> +	 */
> +	if (pmd_before < 0 || fallback_before < 0) {
> +		ksft_print_msg("no thp_swpout_pmd counter; PMD swap entries unsupported\n");
> +		return false;
> +	}
> +
> +	if (madvise(mem, pmd_size, MADV_PAGEOUT)) {
> +		ksft_print_msg("MADV_PAGEOUT failed: %s\n", strerror(errno));
> +		*swap_failed = true;
> +		return false;
> +	}
> +
> +	swapped = check_swapped(pagemap_fd, mem, pmd_size);
> +	pmd_after = read_vmstat("thp_swpout_pmd");
> +	fallback_after = read_vmstat("thp_swpout_fallback");
> +	ksft_print_msg("thp_swpout_pmd: %ld -> %ld, fallback: %ld -> %ld\n",
> +		       pmd_before, pmd_after, fallback_before, fallback_after);
> +
> +	if (!swapped) {
> +		ksft_print_msg("MADV_PAGEOUT did not swap the whole PMD range\n");
> +		*swap_failed = true;
> +		return false;
> +	}
> +	/*
> +	 * Both counters are system-wide, so another task swapping a THP during
> +	 * the window above can move either of them. Test the fallback counter
> +	 * first: if reclaim split *any* THP we cannot be sure ours was not the
> +	 * one, and skipping is the safe direction. That also covers a kernel
> +	 * built without CONFIG_THP_SWAP, where folio_alloc_swap() returns
> +	 * -E2BIG for every PMD-order folio.
> +	 */
> +	if (fallback_after > fallback_before) {
> +		ksft_print_msg("PMD swap unavailable; reclaim used PTE fallback\n");
> +		return false;
> +	}
> +	if (pmd_after > pmd_before)
> +		return true;
> +
> +	*swap_failed = true;
> +	return false;
> +}
> +
> +static char *alloc_fill_swap_thp(unsigned long pmd_size, int pagemap_fd,
> +				 unsigned int seed, bool *swap_failed)
> +{
> +	char *mem;
> +
> +	*swap_failed = false;
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
> +	if (!swap_out_pmd(mem, pmd_size, pagemap_fd, swap_failed)) {
> +		munmap(mem, pmd_size);
> +		return MAP_FAILED;
> +	}
> +
> +	return mem;
> +}
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
> +	int swap_prio;
> +	bool swapcache_dropped;
> +	const char *swap_dev;
> +	char *mem;
> +	char *aux;
> +};
> +
> +FIXTURE_SETUP(pmd_swap)
> +{
> +	bool swap_failed;
> +
> +	self->pagemap_fd = -1;
> +	self->uffd = -1;
> +	self->mem = MAP_FAILED;
> +	self->aux = MAP_FAILED;
> +	self->mem_len = 0;
> +	self->swap_disabled = false;
> +	self->swap_prio = -1;
> +	self->swapcache_dropped = false;
> +	self->swap_dev = NULL;
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
> +					self->seed, &swap_failed);
> +	if (self->mem == MAP_FAILED) {
> +		ASSERT_FALSE(swap_failed);
> +		SKIP(return, "Could not create swapped THP\n");
> +	}
> +	self->mem_len = self->pmd_size;
> +	self->swapcache_dropped = drop_swapcache(self->mem, self->pmd_size);
> +	ksft_print_msg("swap cache %s the swapped-out THP\n",
> +		       self->swapcache_dropped ? "no longer holds"
> +					       : "still holds");
> +}
> +
> +FIXTURE_TEARDOWN(pmd_swap)
> +{
> +	int swap_err = 0;
> +	int swap_ret = 0;
> +
> +	if (self->swap_disabled) {
> +		swap_ret = swapon_restore(self->swap_dev, self->swap_prio);
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
> +/*
> + * With the swap cache evicted, the fault cannot be served by remapping a
> + * cached folio, so this covers the PMD-order swapin_sync() read.
> + */
> +TEST_F(pmd_swap, swapin_sync)
> +{
> +	if (!self->swapcache_dropped)
> +		SKIP(return, "Could not evict the folio from the swap cache\n");
> +
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
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
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
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
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
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
> +	uint64_t entry, first;
> +	unsigned long off;
> +
> +	entry = pagemap_get_entry(self->pagemap_fd, self->mem);
> +	ASSERT_TRUE(entry & (1ULL << 62));
> +	ASSERT_FALSE(entry & (1ULL << 63));
> +	first = entry & PM_PFRAME_MASK;
> +
> +	/*
> +	 * The kernel zeroes the swap type/offset payload for readers without
> +	 * CAP_SYS_ADMIN, so the slot-ordering check below would silently test
> +	 * nothing. Skip instead of passing vacuously.
> +	 */
> +	if (!first)
> +		SKIP(return, "pagemap swap offsets need CAP_SYS_ADMIN\n");
> +
> +	for (off = getpagesize(); off < self->pmd_size; off += getpagesize()) {
> +		uint64_t idx = off / getpagesize();
> +
> +		entry = pagemap_get_entry(self->pagemap_fd, self->mem + off);
> +		ASSERT_TRUE(entry & (1ULL << 62));
> +		ASSERT_FALSE(entry & (1ULL << 63));
> +		ASSERT_EQ(entry & PM_PFRAME_MASK,
> +			  first + (idx << MAX_SWAPFILES_SHIFT));
> +	}
> +}
> +
> +TEST_F(pmd_swap, mincore)
> +{
> +	unsigned long pages = self->pmd_size / getpagesize();
> +	unsigned char vec[pages];
> +	unsigned long i;
> +
> +	ASSERT_EQ(mincore(self->mem, self->pmd_size, vec), 0);
> +	/*
> +	 * Nothing in this test faults the range, and the fixture already
> +	 * evicted the swap cache, so every slot must report not-resident. The
> +	 * other direction is not stable - reclaim can drop the cached folio
> +	 * between fixture setup and here, and a split cache reports per slot -
> +	 * so only check that mincore() answered.
> +	 */
> +	if (self->swapcache_dropped) {
> +		for (i = 0; i < pages; i++)
> +			ASSERT_EQ(vec[i] & 1, 0);
> +	}
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
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
> +}
> +
> +TEST_F(pmd_swap, swapoff)
> +{
> +	int ret, err;
> +
> +	self->swap_dev = getenv("PMD_SWAP_DEVICE");
> +	if (!self->swap_dev)
> +		SKIP(return, "PMD_SWAP_DEVICE env var not set\n");
> +	/*
> +	 * Otherwise a higher-priority device may have taken the PMD swap
> +	 * entry and swapoff() would operate on the wrong backend.
> +	 */
> +	if (!swap_device_is_only_active(self->swap_dev, &self->swap_prio))
> +		SKIP(return, "PMD_SWAP_DEVICE must be the only active swap device\n");
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
> +	if (self->zswap_enabled)
> +		ksft_print_msg("zswap enabled: PMD restoration not checked\n");
> +	else
> +		ASSERT_TRUE(check_huge_anon(self->mem, self->pmd_size, 1,
> +					    self->pmd_size));
> +	if (self->uffd >= 0)
> +		ASSERT_TRUE(expect_rwp_fault(self->uffd, self->mem,
> +					     self->pmd_size,
> +					     pattern_byte(self->seed, 0), false));
> +	ASSERT_TRUE(verify_pattern(self->mem, self->pmd_size, self->seed));
> +
> +	ret = swapon_restore(self->swap_dev, self->swap_prio);
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
> index 19755fb4edb94..720ba5cbacd62 100755
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
> @@ -414,6 +416,8 @@ CATEGORY="pagemap" run_test ./pagemap_ioctl
>   
>   CATEGORY="pfnmap" run_test ./pfnmap
>   
> +CATEGORY="pmd_swap" run_test ./pmd_swap
> +
>   # COW tests
>   CATEGORY="cow" run_test ./cow
>   
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 80bc9f597b521..e6133784abad2 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -180,6 +180,30 @@ uint64_t read_pmd_pagesize(void)
>   	return strtoul(buf, NULL, 10);
>   }
>   
> +long read_vmstat(const char *name)
> +{
> +	char line[MAX_LINE_LENGTH];
> +	size_t name_len = strlen(name);
> +	long val = -1;
> +	FILE *f;
> +
> +	f = fopen("/proc/vmstat", "r");
> +	if (!f)
> +		return -1;
> +	/*
> +	 * Match the whole field name: "thp_swpout" is a prefix of
> +	 * "thp_swpout_fallback" and "thp_swpout_pmd".
> +	 */
> +	while (fgets(line, sizeof(line), f)) {
> +		if (!strncmp(line, name, name_len) && line[name_len] == ' ') {
> +			val = strtol(line + name_len + 1, NULL, 10);
> +			break;
> +		}
> +	}
> +	fclose(f);
> +	return val;
> +}
> +
>   unsigned long rss_anon(void)
>   {
>   	unsigned long rss_anon = 0;
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 9a49af88702e4..6355d830cd4a8 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -89,6 +89,8 @@ unsigned long pagemap_get_pfn(int fd, char *start);
>   void clear_softdirty(void);
>   bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
>   uint64_t read_pmd_pagesize(void);
> +/* Returns the counter value, or -1 if /proc/vmstat has no such field. */
> +long read_vmstat(const char *name);
>   unsigned long rss_anon(void);
>   bool check_huge_anon(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);
>   bool check_huge_file(void *addr, size_t len, int nr_hpages, uint64_t hpage_size);


