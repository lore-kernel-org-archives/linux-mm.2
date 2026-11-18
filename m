Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B50606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ckMIPrMU
Received: by kanga.kvack.org (Postfix)
	id 09AAD6B00EF; Tue, 17 Nov 2026 21:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024536B05B3; Tue, 17 Nov 2026 21:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7BA56B05B4; Tue, 17 Nov 2026 21:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C18296B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:31:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41CCA1C3F99
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:31:39 +0000 (UTC)
X-FDA: 85446663918.26.4F7C44D
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3AA46180005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:31:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ckMIPrMU;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794969094;
	b=nKmGSc/b+CzQPqafelcPT+NSa1Uz0sFN9yjNiu1c/dpzA6K0To+SlgPhwH7yadFY49FML9
	EpgV5G4OZ/qZNPHG4eNHM2eHBAwMhcmhrCiGtwoIUi0ud9n25+DRDPi0bBBDgy71gzub72
	H0rElUkXgtEIrYTtR4aHOFoqJHtpr74=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ckMIPrMU;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794969094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9deMS9SHp1v8TdPFiTn32COaQpqdBL7sf3125pu2O8=;
	b=2CI45W4cIM+Mug8HYbmPD0BtPslVNPHOO4MbIWXf7JvI/uTOsRHGHormS7y3p6Q88RCtXW
	cOohhocEa8oxe0xVQbuAVse4283Vc9DARjyn3QgxxZSuPeKi73spYyCM0ByPOkBTDukDc/
	ALKkYHONfQ1ivnBEPmXQ79Me3kK+Tyg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794969089; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=u9deMS9SHp1v8TdPFiTn32COaQpqdBL7sf3125pu2O8=;
	b=ckMIPrMUB5GcpcrX/MMUrtK2+158QiEz7josRtb4Bjq5EKZHvkHJk3NqO2hxAHiuD8IjGgMs97v03DknKV95fNHFuWYp3ni8AAcOR6DGR3sFqxIX96VDAYP8HVs6Tha5k5sR0y2L2QY3WFmldLA87apbu7EKShLfhwGUFdgBNFY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XF.332t_1794969087;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XF.332t_1794969087 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 10:31:28 +0800
Message-ID: <7a692c99-e023-420b-832d-0727fb2f2d74@linux.alibaba.com>
Date: Wed, 18 Nov 2026 10:31:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: limit forced anonymous shmem huge orders to
 MAX_PAGECACHE_ORDER
To: Jingyi Sun <1045704958@qq.com>, Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>
References: <tencent_1B8BBAF215484255F04168752D9BA778EE08@qq.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <tencent_1B8BBAF215484255F04168752D9BA778EE08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eex3ezbf44yhmjo3fgft4cf119tdhs7j
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3AA46180005
X-HE-Tag: 1794969092-193258
X-HE-Meta: U2FsdGVkX1/mdCE72xof57cFkjkdjPoJOfdBHvRLduqmu7eDOT0scWS2fOv/yGhD3A4Oz4IgJQfbJ6n6Om0Lv9GvkY1bM4ygEC8jrvkbXaca+yCsKnBzE5CI4r/T4Hgjv9uf/TXHcAS5UdD2JO3THGeL+N1EB0jzxKrMcpEUmPCoMahl+cSk/8jW04IxYFgxq7LiZqJFH8VPjSR/Nqsoa+H354YFxazBJqyygF4+jIxFtHWAIOUbRiHl2F3Nd4jqa6j0NI+LY+6L1I7zwIFCtTu1wbxzp3HKVk3gRWH/yw3UfLhtkALYjWag+HOa4ab5vCyR7NWucpb2Q7JM2p2HGWcNsQQ8ldy0BT02z7mRnBHPX937GME9l98sXgNl1Xd7cXy/aa1WV3v/27oLezfSV47C1n1rrAhmr8xd7VCSjei2Yv5e0RvXEsJ7tu7D2gIPz90dFpddNBo3XUX16+CCVpFVDqP6w7id/vQgKaITd2MDZBbhj4mvMdVspmFQgLrldLFQ9yH2fxd9Z3BmxQ2HIzzscAq/iGxR/jJOIXQupKEqQxFGsPJT3JGiXyCj45RKYk8BGIBlTBM9NU1UcpnF+bD0Ku8Pk+hBBhPWQPmW0toxX7DV45t50ycmccFF+DalSP1rVQFNV3R/iUm0I+v8w/kKqFQw1KY++wp6f9l9A9Yws2me2H+QNvJmJFrHrqcI/7oq37vKctXsaT1XcTIZePLH3OPxj5LTjpKQsE2oI9ArNergFlTtD0RTbAUSllxgANMQ9vmH8Kku1hcC8mGWoIDfXs25zk6Ig1UwIIo1eVzGf4LE2g+miyyUAXz2DLiu6EDLcG5N58vzsrIX5ICx0Ui3FCj3VlNjqoDq4KVi2XxcCrfO0OUgGNXwGM8pR5Vpj1RXT86FZo4XSCd7nt4QK043NWPIxyYUYPEf+mRFpsC/H4xP2X4NaugoK52wb7lMJflsKEkzqFl7w6hR/mb
 jGnJWMSm
 IMPNqBVJrqCrm/7FOALw/S3OI618rxcaGbovwy7pUGPXehTHxs4xgsUOuPpnDedI3CZl6QsDOlFmVh+gMjpX/lSxOmFLdehv4KpJRHL1+HwPEmzNYtk3SQB+ooe2eqdCrfMtmDfQxZTVQ1hLLQFBHI6VsTX21RPdbfbtPU/A/zIzU2eikxCL1qKX+YyAHV+Gps53dDlfhpyzfUdykQ0+vGlemcL9XnaROgPWMypv+ZWTHmRpbWjAytMgLunOVVjHnonQ0Cw9Wf2xEf6Rp6aP0SzTj4TkSgNPJs7htF32I6YpdVeidNV26iXHTq0UgxeOM3vo9wkkzibULxcDjZLTvFL1HOzUfMnnJ0xudvBOK22dRBAKocfD1asiWSZHuWbQlCwe0wq7j9pPry3+IrShz3sMfHtIgeLJ+JsW4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/17/26 8:16 PM, Jingyi Sun wrote:
> When the top-level shmem_enabled knob is set to "force",
> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
> unlike the other return path at the end of the same function.
> 
> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
> is 11 because of the xarray split limit. With shmem_enabled=force, an
> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
> in the page cache. Splitting it later, e.g. on swap-out from
> shmem_writeout(), triggers
> 
>    WARNING: lib/xarray.c:1051 at xas_split_alloc
> 
> and the split fails, so the folio can never be swapped out.
> 
> This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
> PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
> avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
> fixed for the other paths; the force branch was left out. Mask it with
> THP_ORDERS_ALL_FILE_DEFAULT as well.
> 
> Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
> 4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
> MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
> PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
> triggered the warning above in 3/3 runs. With this change: 0/3.
> shmem_enabled=always and 4K pages did not show the warning. The code is
> unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
> re-run on those trees.
> 
> The issue was found with a research static analyzer for
> cross-architecture dependency bugs and confirmed with the QEMU
> reproducer described above.
> 
> Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
> Cc: stable@vger.kernel.org
> Cc: Luiz Capitulino <luizcap@redhat.com>
> Assisted-by: LLM

Please drop this tag.

> Signed-off-by: Jingyi Sun <1045704958@qq.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

