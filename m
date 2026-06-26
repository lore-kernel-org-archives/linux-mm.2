Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618DCC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC456B00C3; Fri, 26 Jun 2026 11:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C786B00C4; Fri, 26 Jun 2026 11:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA136B00C5; Fri, 26 Jun 2026 11:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9EE66B00C3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:12:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D8891C0338
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:12:20 +0000 (UTC)
X-FDA: 84922404840.24.2C2582E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17CB8120002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:12:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W4OK0Qj/";
	spf=pass (imf29.hostedemail.com: domain of leo.yan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=leo.yan@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486738;
	b=ouaFzJCWoBR+M7owgfQz2KNakpuOk9MBzJMH5WKxKm5RPaF6ABn+sp1ednVnoSUI5ZhN/t
	C5iI56pRoY5tUbyf003JLyrBn2A9DhZn0KPVMR3E99uh5aQazH7mcr6zV9fU7qe6xM9e/a
	D4HVPm14NV0Jt/YrgwwW5VtRDqmeViI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IjQQV0x4v7pxOJTTVBCFNy8jphgOpJOuxHypSpBUQU=;
	b=p0z/854r/o8cxe6IvyvxIeINRK18Oyc/WwYMpSy7s84eIH1Arttbiz86Ci59WXBYRuhW/x
	fvjGgCtDVFuu9O3F7cm66fS8plkUIo/DJvqDV/O0dyfRJ3ruHIItaZ38NoQ8YJ7R5C3n0L
	/reQoyapfpyubWuCsJpCk91XzMxHxMw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="W4OK0Qj/";
	spf=pass (imf29.hostedemail.com: domain of leo.yan@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=leo.yan@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 596401E7D;
	Fri, 26 Jun 2026 08:12:12 -0700 (PDT)
Received: from localhost (unknown [10.2.196.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68D2D3F632;
	Fri, 26 Jun 2026 08:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782486736; bh=YN7HFeAn5PfLzBdHTnw12iJICI72jFBKITQg8GRt9JI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W4OK0Qj/gfEiAScIK4WRs1+dVyd7SXFPAI+0BUFrcXuVHPnbTliWZzqYxLs3rNdQI
	 4s5PWJrgQ8F5NTwPDsn9Shr56QFSSGvxFWGKWd/D7lYrWZOS+D08a5l6+jG5+suUU4
	 ONIuI3yT9d+BIeSeJ2JJHdwLAJoWoEbNTVCuuzEg=
Date: Fri, 26 Jun 2026 16:12:14 +0100
From: Leo Yan <leo.yan@arm.com>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	James Clark <james.clark@linaro.org>, Tamas.Petz@arm.com,
	Michiel.VanTol@arm.com
Subject: Re: [PATCH v4 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-ID: <20260626151214.GA1794676@e132581.arm.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
X-Stat-Signature: 9ngopag6mpq3kebg886jiexpgsp3h95k
X-Rspamd-Queue-Id: 17CB8120002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782486737-304268
X-HE-Meta: U2FsdGVkX19/JWj4PlYKvam0QR886M6VE6z2s8wXLqwByYL4S/cWxvSIuZINGZbDsUlLt5WbmzZptjCfyt/j+NkpBQ+Zagkxf1kx81wl8wJGylq3JLVmKh1Mb/xPQ23W9xp31PPhL8w9r8qlvHGMkN/am0bXcR950+nJ7HXw3OEMXI7Zd6JK5DUQJhnKIghwreYYb0cwWdAgrwzw+3jrtqiIpFThXKfSQnvUHqMk00+l0oc90tkOq4l9Wlk8kMSu9UGwOHfS3FFqP7qKxd8JreEdb1HwcKXeJxej04w1VVecFP8nEKYIvOcfr/7fJYdkuRy3u02qCnBy6b6f8EGoVhMADDjXbVhiAC4eXB7MLjPy0p7iVJ3raxcJ043g5I5bEp10ymPM1MjzEHO2OR8h4o0dxA+RvUvGqREj7+kQZ4OYC71mPNkqtuBgwtvnHBwCmBXtSbD7OKXN6AAxPv9ObBaRNBJlhtn+pNxYxiJK9YTnCClt/CF9OBrTBJk5LOE4X6u+6ibdzHu84Fe0grhi5jZAwxkXEh6pgAH3yR845sZqe3T30oa9T5KFOdd//jam0Znp31s8fntxtOv+voVy6WtTrWDsNirjaFBimYH2LdsIrKEJUC8zb245ndGGTicRoZtmSGmhnOFDRJyJ95XFA5HkAHF66ZX2J9QBLEkleril/6vuafMsU/8SHOO0v0n4PITKr/9Bjz3Rda2CldteuohVsPY8Ul9U+CquyaqKkBLDyDgM+2D/sJareiz7KmYKd4aN1BWL7eOWxNqYJiZeToRMIbSzOCrazgO65FUpsGrSxfL56hRoJnJMYRA1VyT8S1whG/NNd1gx/1IIdauE7fvc4a87aEkqeLSnVJfPP0J9S/NdIMNp4hFwEG4x76IRtEO2jOfE0tiEGR9k+nQ3G2nFJVQ8365QF9NOfSqDWMUcNSbAU+17Fgtw1dkkT4CzICgo8q68QCYVbETGw3Z
 TPWUrV1z
 RIKWYBUdk0G+n2oUFZAB5RGrtThpqUFkzfNs/1PpqJbmkpCz7sqilX3ysJZgq6OUere4xsA6Yj1gKjCtwD6tbK2anD84uWzX2GepV0GE8y/lyMCKLgliVi6rYoRtN5bj6+UZe/CJVLPVTl7oioil9uU/gB70bwXE/RcpXxefRseXZ89HJyfQQpeHH9InyHfA/fBEHQ/ZIquIXTBo4CJEgVgNEo6NWRvpKPWIoIyYAj6G1ki0S17GwZliRgOt/e8SK1ZBHGzGWhOz3EClDyZ3IBzWynK8eEz/fdsgB1YsFOcWMhkn1fq6YCwrzskKYVcyxTQ9nRRI++kBTt0Mw67nfdxhQ9KT0s+s+E6VpG7kgJVoCdubxSgffovrU9N1JOaqyODh4RabHhIZcPdsbZYXbEl2Tnmafof79+tUL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:47:20PM +0800, Wen Jiang wrote:

> Besides accelerating the mapping path, this also enables large
> mappings (PMD and cont-PTE) for vmap, which are currently not
> supported.

I verified this series with large vmap() mappings for Arm trace buffer
units (TRBE and SPE), and the results are positive.

Arm trace buffer units use the CPU's page tables for address translation
when writing trace data to DRAM. The larger vmap() mapping granules
reduce TLB pressure, resulting in significantly fewer L2D TLB refills
and reduced L1D TLB refills. The decrease in dtlb_walk indicates that
fewer page table walks are required and that address translations are
more often satisfied by cached TLB entries.

The detailed results are included below for reference.

Thanks for working on this, and here is my test tag:

Tested-by: Leo Yan <leo.yan@arm.com>

P.s. I applied a local change to set PERF_PMU_CAP_AUX_PREFER_LARGE in
the CoreSight and SPE drivers to allocate large memory chunks. This
change will be sent out once the MM changes are agreed.


## Results with TRBE

Test command:

  taskset -c 2 perf stat -C 10 -e cycles:u,instructions:u,dtlb_walk:u,l1d_tlb:u,l1d_tlb_refill:u,l2d_tlb_refill:u \
    -- taskset -c 2 perf record -C 10 -m ,1G -e cs_etm// \
    -- taskset -c 10 ./sparse_branch_delay.elf

The benchmark was run 5 times. CPU10 was isolated and dedicated to
running the workload while collecting the TLB statistics.

Before this series:

 +----------------+--------+--------+--------+--------+--------+----------+
 |TLB Metrics     |   Run1 |   Run2 |   Run3 |   Run4 |   Run5 |     Avg. |
 +----------------+--------+--------+--------+--------+--------+----------+
 | dtlb_walk      |     63 |     75 |     62 |     73 |     69 |     68.4 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l1d_tlb        |   2093 |   2189 |   2237 |   2036 |   2086 |   2128.2 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l1d_tlb_refill |    154 |    153 |    150 |    165 |    157 |    155.8 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l2d_tlb_refill | 161325 | 161403 | 161432 | 161580 | 161439 | 161435.8 |
 +----------------+--------+--------+--------+--------+--------+----------+

After this series:

 +----------------+--------+--------+--------+--------+--------+----------+----------+
 |TLB Metrics     |   Run1 |   Run2 |   Run3 |   Run4 |   Run5 |     Avg. |    Diff. |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | dtlb_walk      |     67 |     59 |     60 |     58 |     53 |     59.4 |  -13.16% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l1d_tlb        |   6710 |   7120 |   6662 |   6626 |   6542 |   6732.0 | +216.32% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l1d_tlb_refill |    126 |    117 |    119 |    117 |    119 |    119.6 |  -23.23% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l2d_tlb_refill |    506 |    489 |    485 |    506 |    489 |   495.0  |  -99.69% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+

## Results with SPE

Test command:

  taskset -c 2 perf stat -C 10 -e cycles:u,instructions:u,dtlb_walk:u,l1d_tlb:u,l1d_tlb_refill:u,l2d_tlb_refill:u \
    -- taskset -c 2 perf record -C 10 -m ,512M -e arm_spe_0/ts_enable=1,pa_enable=1,period=64,min_latency=0/ \
    -- taskset -c 10 dd if=/dev/zero of=/dev/shm/dd_mem_test bs=1M count=1024 status=progress

The benchmark was run five times. CPU10 was isolated and dedicated to
running the workload while collecting the TLB statistics.

Before this series:

 +----------------+--------+--------+--------+--------+--------+----------+
 |TLB Metrics     |   Run1 |   Run2 |   Run3 |   Run4 |   Run5 |     Avg. |
 +----------------+--------+--------+--------+--------+--------+----------+
 | dtlb_walk      |   2090 |   1709 |   1679 |   1519 |   1555 |   1710.4 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l1d_tlb        | 254450 | 257227 | 252517 | 252535 | 254752 | 254296.2 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l1d_tlb_refill |  16023 |  16088 |  15944 |  15989 |  15956 |  16000.0 |
 +----------------+--------+--------+--------+--------+--------+----------+
 | l2d_tlb_refill |   5887 |   4204 |   3713 |   4556 |   5620 |   4796.0 |
 +----------------+--------+--------+--------+--------+--------+----------+

After this series:

 +----------------+--------+--------+--------+--------+--------+----------+----------+
 |TLB Metrics     |   Run1 |   Run2 |   Run3 |   Run4 |   Run5 |     Avg. |    Diff. |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | dtlb_walk      |   1111 |   1301 |   1229 |   1166 |   1771 |   1315.6 |  -23.08% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l1d_tlb        | 257462 | 257420 | 257241 | 259968 | 261324 | 258683.0 |   +1.73% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l1d_tlb_refill |  15954 |  15919 |  15948 |  15962 |  15968 |  15950.2 |   -0.31% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+
 | l2d_tlb_refill |   2672 |   2558 |   2801 |   2478 |   4147 |   2931.2 |  -38.88% |
 +----------------+--------+--------+--------+--------+--------+----------+----------+

