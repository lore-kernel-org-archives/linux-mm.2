Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5277ACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11F06B0088; Tue, 23 Jun 2026 03:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1FE6B008C; Tue, 23 Jun 2026 03:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C586B0096; Tue, 23 Jun 2026 03:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 913186B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:05:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 097AFC1D12
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:05:26 +0000 (UTC)
X-FDA: 84910291452.30.7704397
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 33215160009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:05:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lu01bz+0;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782198324;
	b=l81sToPnCU97m6smcrFJ7j1KRScJaLSvzhiqyyu7YD2r6mpetcizAcXl3uJC5Vkf2YAhuy
	LI0H4+2XTwX7i8JZTWE/pzXl3ol8zb0qcjowIpFCj7HeaV7NoBuq6rFZICIkMBb7I/7bej
	i2FY8PESObT9MGJL5tkHML5Rpjq115Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782198324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2edlHoTARK4XOwJQhEgs4zRuOW2bg9kGCtX6ZMXliKU=;
	b=YIokt7r6NnoHTTElAOFL25DvTdbHgo6zBmgV2f54vMMeN0qW5cPbURnftngqqmYSnxt4eP
	MCoefMPiJfkZD+fMOO4K6KjolYuCU/GmJSF9QyH1qwXg9FTmPHxrBSnYzBdO47jGJOgv49
	5YPve6Z7R8MDTza9vZQ7XY+QIx4qktM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lu01bz+0;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8453bcf7276so2952350b3a.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782198323; x=1782803123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2edlHoTARK4XOwJQhEgs4zRuOW2bg9kGCtX6ZMXliKU=;
        b=lu01bz+097sqKXbwUZ4NGz8I+y0bzIMxMHyIaLIvVevL6kMWafYSkdFWDV2lOZ4YD2
         2tdyYWvpgaXmLqOG5X/Smcf/J8UBZFQUoynXoyBMBW3mmg2xTs6J/wdkPMF5uvNVSeAK
         4AX0vyPqzXfpH2l28LcRUmgqKvWJeR4K7GfmgWcG2n9nemAHCfVLbr9JX92yUT1wheBd
         45fh9C52r1bLFVB2KGVDFk1gOipfJjZ+SIWZrDSLAgCBpKRVG+xH6ovnHtRd7ncR0AzU
         lh/u8V7WWeDpf05mH8h6f+bQq8FiVujbbwu41Zw5zKph+TgVeKPChhOowg6LDvwIWzkO
         k5hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782198323; x=1782803123;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2edlHoTARK4XOwJQhEgs4zRuOW2bg9kGCtX6ZMXliKU=;
        b=ct7mXEnxCtZ1FPljgt8qJQaG5YAshnHyYdegzK03QQTE02ejiuka6svMhS3R9vYijv
         UL8eQgCWxE1FIj/JiTW8la4jW20JPp4hrfXR8ULDYWo8PNqJ4cXKn2vn6vaAFklFUvRy
         isPd3g1+AE1sgNFCeAgsJH0TFY1JKgPGYUNmAVnEY6e/krMAN1q5GSNwjf5Qmu4ceTrw
         BNg4y7G/KF4xjh5Xf3YMp6l+l1fNB5mCvJ/+7m0Bdn29zHK3dsd3tjEpc846WT+lB9ti
         Yeyw7GtpdqsjYYJn30DGQCCO3Cdd0pkKUbd7vFbYTGUWamSIv+0/u3bKchkbnFRqXc5r
         w2Ew==
X-Gm-Message-State: AOJu0YwF4TFZvYBAWy0XwqndN5vCKKsP3Wyc3vq/MsEc8gt3+ejZWXiS
	KM88cyMR37AMOGrXRGtyoHy6KkXLPyxmXzPrIbomabwaa5LAD2k+7N8OeAa4Ug==
X-Gm-Gg: AfdE7ckg5vbZTLXdEl2b2CjNHDEmM/1uPrhTYIkpD2lhPoWWYfhHs+hKuIuAMgB6io0
	K1Tayw/kgvXl6cOzX75JbU6mIEET0uI6I0oJEMK4IAvJjTyZZh/olZgeS9z74Cd6lyi0vdJGzef
	uUQgvBQaDDONcNfsl0BrgJjNFYAZBowFaevPe+SzV+Uue74Ok2eCiYPO39Zan6IqAplH/3G2qAM
	kT8g42lKTYKhN1tNlWty+8kXdGbtFSQerBQzHIej1PCq2I8fUlBJdgsW2SSTot3G4b9MQfGAf9E
	11CDrZbdlGOIgY1h/rKS2vdSWgDiVeKcMnZAk+YBAhF3JFv+xOQBlXwVeLeJxGT5fyaNFt9XH4v
	2+xMaea5x3Rz5pJmzH89XdT5+xuNrFvi6XsiGVm+IhPdtXzpyQAgrYVJL+XZ9dRf5CQVZNPNwSw
	johkEOs6HH6lcuz+yFl/B9OatJEw==
X-Received: by 2002:a05:6a00:3492:b0:82c:d7c4:4c5c with SMTP id d2e1a72fcca58-845507edeb3mr18744789b3a.20.1782198322868;
        Tue, 23 Jun 2026 00:05:22 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d8f1a1sm10912023b3a.18.2026.06.23.00.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:05:22 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS via ARCH_MAX_PMD_ORDER
In-Reply-To: <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com>
Date: Tue, 23 Jun 2026 12:07:01 +0530
Message-ID: <33ydyd82.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com> <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m1hrxbyudxwtp86uhztcey7opo4q3k1n
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33215160009
X-HE-Tag: 1782198323-594232
X-HE-Meta: U2FsdGVkX19gyKaXG2XRhRoN487AEmstu7On0GX+fI29NcyZZu79bRl9PrG9O4H1wwO9Do8y0oTextbuRqEbn+uu6xLgrI49zZoAGq8wex7VND+qgTuiLPXgZOiPewO6vv+ulZSNQQlY/Qojmez13dSaTsRCBLHdaov7cbp/ZhU+JEeShCw0aIHbGc5btiEEQcY73ydQ3L5gKmWJNskL/eaMPZzB30A4vM5MHet8WDqtPHa/N8kXKbDemHynQ1aq7NJEpdDTK3nrMV5RDDU62TsTJ9YLjZqT4Iys6o4vGRSKXa9wYbfiVebgGjr/WQjtKKY2tCUAajKz/jK3rOshrZeFoEuBFCvbAMoUzN1KVaypeEXGUNQc7pYV7AVhNrdvt3SWDr1oEvN2YbWqOjLe0OiHbZ7WFsg5kix7c3GPKPOc9W9AAcrbA9xnvtb5Jh6kOCxFjx1drWSfR7H+SbpHFOiC59rgifGxEFNm09bRlfX42E7yaoYubTrQ1hI8Kw1S23q4kZEPOCq+SiaIjHPnbc1DpiXtkbvga+E2FnZODtvYwkbuIVoH7vjzhexdWYxyKlv4AROS++SZPcWtg8whjSu5i8PqhhB4sZ+ff6St0B1uctbNCqQxnauBzWkJ3OX908VT06LkS8aoqDnrxm0PJo5mbl50IKg+4mu4s2FMpCkZTSwgut7n3vtDhggGhRXALU4zDqNRMz0XdxtC8eE9qbXP0vc4aF/BGPcfwiC7yw3uHCdcLy+dsUu7dCrB4AMUFHPlA4nPx1P2FIAi95em5QZWtju0v4ND3M0GuCAS/iKA7UVKBOtqV/NDw2e6zUArFEAtagWyElxYp5yNG7RzODotYjA7uTIlbgMx6q830X1zF50JK8oBqJQ8+5+s+c5iw7Q0UNg097RBQcNtZmeEo57uEgxP8sYfJzb5ypNPSGda2PdDNNtsuM3woaQaGYwTcB/QNFjeWOunEWB+7G7
 0HDmVAXq
 SKPG+VDqNqE8rj0XAphGzm/P5QXUrL9uDxIfCkn0Q3k8vy35cxjiuY4R2p2SvkrSGSf1a1IWfSNnzzDTfK2R6R7BbUewngxqdblGLK/d9a0uT+t2HsiF4Xta82ITQr79L6onDRCI716JuCis6HazgKnI3ya0vYQpaX3XrVSVc2KSjYBYbEhHQVB+k1iP98ED5V+fA/SG/BqLAa0eKUyR8ovsz6i9d8m8x7f3e17OHeO3YmybTCp87+lwLDiWuVLi/SIvIF0UQG0V4XJrEM0Jeuq9QgYcQS637e4IEI/ixNNRXq1BsBL6YV/TRAsr6StoENDQIWuBMY/mEj/jyrAwtO6YUS83+n7fIs1f45RHX7ngYFxEAEkzCl3Ch1zGmi9/9talywr1dI551XhZpxTEDlbIuJe+ak4Tx7M/+SWEGrKvIbgz2iGKN4BX+Y3q+vbyJQdXZ7bKVBY9ynY8iBNMa0OcquwasXd4ZeeuoUHns0gelIGZ0b3EgnlxXneAqi+4wJDls6PS/j0bB91IJ3Ipe9Yc1R7hhDe5Cs3ruOfvRoKYMDFqUgbYX8LcSwOTBU8I+17EtZIZ2vQnYD3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Fri, Jun 19, 2026 at 12:41 PM Ritesh Harjani (IBM)
> <ritesh.list@gmail.com> wrote:
>>
>> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
>> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
>> si/offset arrays, next array for rotational device). This currently
>> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
>> time constant.
>>
>> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
>> variable which depends upon which MMU is selected (Radix / Hash), so in
>> that case, PMD_ORDER cannot be used to size the static arrays.
>>
>> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
>> override for such architectures. The memory overhead on enabling this
>> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
>> default slab padding could cause some memory waste. Also we lose the
>> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
>> cost an extra cacheline indirection overhead in swap_alloc_fast() for
>> fetching si[order]/offset[order]. Note that a fully runtime
>> SWAP_NR_ORDERS was considered in previous version but was dropped for
>> this reason [1]
>
> Do we know the maximum PMD size?

ARCH_MAX_PMD_ORDER will be 8 on PowerPC book3s64 with 64K pagesize.
PowerPC Hash MMU with 64K default pagesize supports PMD size of 16MB.

> On arm64 with a 64 KB base page,
> a PMD can be as large as 512 MB:
> https://docs.kernel.org/arch/arm64/hugetlbpage.html
>
> One concern we have is that performing I/O on such a large folio could
> incur significant latency before reclaiming any memory. For this
> reason, on arm64 we initially enabled THP_SWAPOUT only for 4 KB base
> pages:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d0637c505f
>

That's not the case on PowerPC. Max PMD size for Hash will be 16MB.
Also we still need this patch since we can at runtime choose Hash or
Radix MMU. So, the main problem this patch is trying to solve on PowerPC
Book3s64 is enabling this feature w/o impacting any other architecture.
W/O this patch series, we can't enable it, since it gives build errors.

>>
>> [1]: https://lore.kernel.org/linuxppc-dev/pl1zdksc.ritesh.list@gmail.com/
>>
>
> Best Regards
> Barry

Thanks for the review!

-ritesh

