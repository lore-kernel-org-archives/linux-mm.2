Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59ABCCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4468E00F5; Tue, 12 Aug 2025 04:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86468E00E5; Tue, 12 Aug 2025 04:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B8D8E00F5; Tue, 12 Aug 2025 04:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A729A8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:35:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5308A115CE5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:35:26 +0000 (UTC)
X-FDA: 83767446252.22.CAF998C
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3ED1CC0005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:35:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F6OJybHf;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5UCujp6LpemgWNTAHmJG6DMzWeh3JLe/fdx68Wjim8=;
	b=z237KToMMnOh9UxgKV42UuEpuMeaAO+wA4evhNoto8bTjyFVfQieZ0pCRg3PjDGn1aDMpO
	0FzC9bHGkFp1EAwtwfP9ieZX4DJAV6/s9TtJ87xDryh2lx8Vz/nqOVIARMKbqI8/yPQY+m
	Cj1TeYj79TELrzIPEsBsRh0P3Ao3iww=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F6OJybHf;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987724; a=rsa-sha256;
	cv=none;
	b=CemUkEEoLLv1x39rGQbHi1vTTATZl9qsiKkNIdZbSh+388NGsv2uRQDclEqOAIXAoDgIUJ
	OvtuuiMedOn2bX+5KDEUb9dPSxQlVTaabOkNBfJWvTa5ebzeJjwVLzyCrIqpaPFtZz6io8
	Q/cM9hVdSJGGr+zvNK66HuN5nYcKDoo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754987720; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=E5UCujp6LpemgWNTAHmJG6DMzWeh3JLe/fdx68Wjim8=;
	b=F6OJybHfXA0QWIjrArVGPDcecWotkaKMKkvCaue5XzBv+CVJXcFTXYmoddx5CDOs4vMO5O2Mv/VTGQAf6ksy04V0ut03CCC2yXQiznkVsDSuJjQFqjpT9C5cCzZdbjQREDEcgUg2byw/ck9L96reXcIzVU0kIM/dmPk6v/JdbtA=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WlaOJEW_1754987715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 Aug 2025 16:35:15 +0800
Message-ID: <e6898dca-d6c6-465c-a373-8298858839ab@linux.alibaba.com>
Date: Tue, 12 Aug 2025 16:35:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
To: akpm@linux-foundation.org, hughd@google.com
Cc: willy@infradead.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ED1CC0005
X-Rspamd-Server: rspam06
X-Stat-Signature: of7sp7tt4qnoaomafq7wu7xiefgmt645
X-HE-Tag: 1754987722-612377
X-HE-Meta: U2FsdGVkX19YiPTQeyLdrQAkCdnS8/pxDTa8scdcEXdH+ULub/TmUmqWkSZAAD9wR2kufgL3HP4cOfyXBJgfa4L8Ff/LZECBTXPevjysl2+xkkIA4TUR7ueMyX1nx9lFGiVzODsyk9plqL69q7+Yz5auxmERIDn4XH7ptTZvQXOTUHNrH0qfhqzuMXrQuLpaxugmNsv1GBT3uj4bkk3XWJSwNTy9q6PZMJhJp8vq1SfI4LVDcoJWkmw2uen6aobDThdRFB7a6RcRXESCLTjl5wpP8d0R/bP7koLpEmCWPJKh/7goSf+O5HiC3IAURGdftTbQNGSv6Re7WXlclcCJ0ZLUHsXQgno2bmpMU/dhZk/rmXJVvidJH0Xh8fYcZWUOf+m38dq2i+UCpxrieoPkgGO0KcnWoaz1ujU9aHTY2QNlUT3yOoYEC2fVumo8l+ImYimNVlfAdLCNjlTFjP80MOKEFejC2c22y63mvrpxU41pIeiuBaiNk4X4PAhjHvGvaXq75iDx6fRPKh/kBowuUUMy875THgfuL4F7gCEVfsOG7RPetvl/vpCycx6NY+HZvqlLgwC9WuP6E+slyZHbuEhW7OF6Z9cP61l8CEi6e1xqivlkgY4MapEB7cSA91DKrizDiTyo1hYJ6y5v68vFL/jGL6ATBDb7C2LeVgY7VE+KkKzwez6YNiOv2yZLV7PNl53+ytrpp3ZGN/dgkbrKDCFXHfmtYCbrrl/eJJOgwpV/lUJhEmgiO1iRwWu3k9qwFPOosbfMI9UQc/A/igk63sMQ6GkhlTjD7dh0ivuM5dluCpkmAaWlqyU8lfq1d84oNdPtlGGrlDmVSAzXP0b6/dUxPlaQN68e1kRlso/t4q+jMbh8YFBTg5zUnNAXOU4dcdCqPISmd+RY7lQs5ZWts4YjfgJ2HC8A7p++QJd00zxgvs/63by+9Uzw0rhCRSBMiU3OnV8Uzxsa8pYUEdJ
 AvzblJ+j
 DQJOQDcq+qZlBpZcYCBHivMR5m1pHpLBrbxRvPzekHmeXmgpLj70OeBFNQ6kOZdv4v58FNVkBDHpbT9c1jziIL0nUR4iUlrIRH5s7U9BqW1A84JXxpTs3KLKGn8cGTOttTWxvytToZrdTUiN+enWiSChbDmAYsvR50XwBe3IVGuWOZ56tjKgXjFlfuPtRSTjE2oM/j4Al1z5QuGIFHTHw+nmjdr6eUEekuU/qZKps6dXkjs7KR6hvfx6UjFRohz0RKP3miwvZiSEaQBu2R9+dKICHu39pXEV/3pMOwXBUGWg72W/utnAuA1c1WsdtJJ79E0pc/uLt3NEz6bI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/30 16:14, Baolin Wang wrote:
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"),
> we have extended tmpfs to allow any sized large folios, rather than just
> PMD-sized large folios.
> 
> The strategy discussed previously was:
> 
> "
> Considering that tmpfs already has the 'huge=' option to control the
> PMD-sized large folios allocation, we can extend the 'huge=' option to
> allow any sized large folios.  The semantics of the 'huge=' mount option
> are:
> 
>      huge=never: no any sized large folios
>      huge=always: any sized large folios
>      huge=within_size: like 'always' but respect the i_size
>      huge=advise: like 'always' if requested with madvise()
> 
> Note: for tmpfs mmap() faults, due to the lack of a write size hint, still
> allocate the PMD-sized huge folios if huge=always/within_size/advise is
> set.
> 
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled', still retain the same
> semantics.  The 'deny' can disable any sized large folios for tmpfs, while
> the 'force' can enable PMD sized large folios for tmpfs.
> "
> 
> This means that when tmpfs is mounted with 'huge=always' or 'huge=within_size',
> tmpfs will allow getting a highest order hint based on the size of write() and
> fallocate() paths. It will then try each allowable large order, rather than
> continually attempting to allocate PMD-sized large folios as before.
> 
> However, this might break some user scenarios for those who want to use
> PMD-sized large folios, such as the i915 driver which did not supply a write
> size hint when allocating shmem [1].
> 
> Moreover, Hugh also complained that this will cause a regression in userspace
> with 'huge=always' or 'huge=within_size'.
> 
> So, let's revisit the strategy for tmpfs large page allocation. A simple fix
> would be to always try PMD-sized large folios first, and if that fails, fall
> back to smaller large folios. However, this approach differs from the strategy
> for large folio allocation used by other file systems. Is this acceptable?
> 
> [1] https://lore.kernel.org/lkml/0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com/
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Note: this is just an RFC patch. I would like to hear others' opinions or
> see if there is a better way to address Hugh's concern.
> ---

Hi Hugh,

If we use this approach to fix the PMD large folio regression, should we 
also change tmpfs mmap() to allow allocating any sized large folios, but 
always try to allocate PMD-sized large folios first? What do you think? 
Thanks.

