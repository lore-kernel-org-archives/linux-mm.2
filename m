Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3769CCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 08:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2876B0005; Wed,  6 May 2026 04:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32BB56B0088; Wed,  6 May 2026 04:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F37D6B008A; Wed,  6 May 2026 04:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 086056B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 04:45:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2F298CFAD
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:45:46 +0000 (UTC)
X-FDA: 84736361892.21.BA51E67
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id BCAFB140006
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:45:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLJYvYXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778057145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyBSdoaYXNxV7svjP8Gx2sTmbQnB/STZugwK800JzDE=;
	b=S8HcDs4vn7jvsPTN1PNhZZbyFTCVcFDEr3402CuTkOkozhTN3KUTw1pqJ98RUNSepXFh63
	8IzJr75rGFogOG5blhJQvLj4Hy8Dd4TaIuOKEE/U/BJ5ZzXydtcJc4CrcJFFGj3vyKmByj
	c6fZ0KQ1g6q0rp+cbNcokab7EBcfXX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778057145; a=rsa-sha256;
	cv=none;
	b=oNinXrmrYvvmOGUdUW92XPO5OJabX7V6/q6Dn5MztKUyFHsQ80I0MknMI9quWTBz7euh75
	cc3M4castcz8BTcgGpxu+ydSpNZKaHNzxGE86nTcXKiy1AeQbIJ95c1+n23TXDncSb2Ble
	vMMXzZ7jMmd6bnPgW3v4dT4m8FKaJ5Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLJYvYXz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <9bff01a8-eb97-4d09-81a4-f4dbf9b59b73@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778057142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FyBSdoaYXNxV7svjP8Gx2sTmbQnB/STZugwK800JzDE=;
	b=WLJYvYXzy5QXWDKFOm0KLjcnEIM1zL7bS17d32jOy99sxWhPdqlQur5F5zd2W4dB8tR9Yy
	YrUYlROye7A4tOPFQGXPUnsBUulqp2+GjxS6jBIc5jP/pXFySk0XujN0AFRmO7yxvohXwr
	jin5mAa6iYkZ44q9WIwZd7JXwhkhLcE=
Date: Wed, 6 May 2026 16:44:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1777936301.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCAFB140006
X-Stat-Signature: njyag44oqoyobwbna53xmzfp5xyzhdhu
X-Rspam-User: 
X-HE-Tag: 1778057144-67158
X-HE-Meta: U2FsdGVkX1/ZmrXscq7+/wyEqgPY54x1XX9vBOZLZAlfysZWQqu9eJEMMiEzEPzGPUkEVVAyL8nNgKKhO37xzvatJd6+eVDXzGn5ddRI8D+Fl19bYlODfnEOHYcOVlXvvwRA1cIDuwdOfZ23mCou7/r9CTsRrBxRht7GPoEHaefTJPMSqGGq3SFbIe5Jh+RwqfXFOxNRYTcBvAY0PKmNI9fyip6Q4xKjV0uQl8njBNA0QtufWhBVTqJhzfsgsFCjLMde0AVPUWgLZSiw6pNTF+TXDg+o6KLZ80y8iN+sypLKrhTz7yr1gR5RAHzdaH8kqDbfjblfcYQFOWXhCU+I2hX8wlhGTSqu1sdg2GkbLSLUTm5GN7DdXg45NiQDG4P/tRRCdpnDCsAfSTf+vywZ/6Lexx+jdqG1IWk9/cM16XHr1mXMbWjpd4C7Rv4QeOwdu2IX/xYTpk0f5E3iKDyVvlwraygqWHfx+sY1UN2GsGUm2hTQbUinmV5lKH+/wQaG28cYpz4/eRRCoLynS32P4FkWl/FSqxaOTTCCa220jQCM9ZBZEhI20/icU3Gnyzb5WMwGMoEZ8JCzAgvBNzgT1sMIxXBl3+kbc/pnwASeJC4r2ijKcun8Rl7TqLgbWhvJc599IsBTfXyocEZbo9Qhl5IThaCGZGOuq+EgEnEFy/Jwmm6tgHZpsXIHqe+Qvn+FJJF5hH87VTVxLtaxSqk19tpzmQyObLMImytfGJmzhuK/9rI5NmHvz3Zo8IyctC+jnpV1PEQzLFkx6Od4azqXDzaWqTBAC/UtXy1U6oknmxmy0PYjucEq0dTRPQJofEDgZyxLzdgozJ1pBHwPKO2wSZP7MQMo6+CbUflElm0SI5TnIb1mewEw/2NqSKrs4EjGEXD5F5rxgN9hYUZ+JZ5XG/fmvZM0CjBsggPC7E5FQcVBaivlQyTfcwIFfP82cJJBSkjGIkL3Gm4eHaHUdkB
 xwErHu7K
 NmsZ5qTRAAHWsiJEf/6olxCByQKNBkXxxBCVrPmpvo5O15yQdFy3/63BFPKyMNYWh0ICagkHLQ40n3/JcgD4s74l0jCPRlPnPBjBDPbFFZ8c6JD+8Pb6kcr43bJSAc55yheDlM5yiIxypp9TYcTnpAp9Ho7B58qWflN+CbjfGgC/kwowk4+UEUS86g1w2iywNpBVUHAl/pqUfuDyKsQSqOQZQVFpJN7ffiE45nVWzqcQhNHSszhAGEuOmrb5Hy/f+QrGALn95BTVV0VpscHX69dormw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek and Suren


On 2026/5/5 07:36, Abhishek Bapat wrote:
> Currently, memory allocation profiling data is primarily exposed through
> /proc/allocinfo. While useful for manual inspection, this text-based
> interface poses challenges for production monitoring and large-scale
> analysis:
>
> 1. Userspace must parse large amounts of text to extract specific
> fields.
> 2. To find specific tags, userspace must read the entire dataset,
> requiring many context switches and high data copying.
> 3. The kernel currently aggregates per-CPU counters for every allocation
> size, even those the user intends to filter out immediately.
>
> This series introduces a new IOCTL-based binary interface for allocinfo
> that supports kernel-side filtering. By allowing the user to specify a
> filter mask, we significantly reduce the work performed in-kernel and
> the amount of data transferred to userspace.
>
> Performance measurements were conducted on an Intel Xeon Platinum 8481C
> (224 CPUs) with caches dropped before each run.
>
> The IOCTL mechanism shows a ~20x performance improvement for
> filtered queries. The kernel avoids the expensive per-CPU counter
> aggregation (alloc_tag_read) for any tags that fail the initial string
> or location filters.
>
> Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
> 1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
> 2. IOCTL Interface: 1ms (sys)
>
> Scenario 2: Compound Filtering (Filename + Size)
> 1. Traditional: (cat ... | grep | awk): 21ms (sys)
> 2. IOCTL Interface: 1ms (sys)
>
> Scenario 3: Size-Based Filtering (min_size = 1MB)
> 1. Traditional: (cat ... | awk): 21ms (sys)
> 2. IOCTL Interface: 14ms (sys)

What a coincidence! I was just about to send an email to Suren

asking about plans for upstreaming a filtering tool for /proc/allocinfo,

and then I came across this patchset.

I have been following and using memory allocation profiling since

it was first introduced. It has been very helpful for our memory

analysis by providing clear visibility into allocation data. However,

we have always wanted a tool to efficiently filter this data to get

exactly what we need, so I previously developed a userspace tool [1]

to help with that.

[1] https://lore.kernel.org/all/20250106112103.25401-1-hao.ge@linux.dev/

So this patchset provides efficient filtering of allocinfo data via ioctl.

Would the next step be to develop a general-purpose tool under

tools/mm that leverages these ioctls instead of parsing /proc/allocinfo 
text output?

Thanks

Best Regards

Hao

> Abhishek Bapat (5):
>    alloc_tag: add ioctl filters to /proc/allocinfo
>    alloc_tag: add size-based filtering to ioctl
>    alloc_tag: add accuracy based filtering to ioctl
>    kselftest: alloc_tag: add kselftest for ioctl interface
>    kselftest: alloc_tag: extend the allocinfo ioctl kselftest
>
> Suren Baghdasaryan (1):
>    alloc_tag: add ioctl to /proc/allocinfo
>
>   .../userspace-api/ioctl/ioctl-number.rst      |   2 +
>   include/linux/codetag.h                       |   1 +
>   include/uapi/linux/alloc_tag.h                |  87 +++
>   lib/alloc_tag.c                               | 249 ++++++++-
>   lib/codetag.c                                 |  11 +
>   tools/testing/selftests/alloc_tag/Makefile    |   9 +
>   .../alloc_tag/allocinfo_ioctl_test.c          | 508 ++++++++++++++++++
>   7 files changed, 865 insertions(+), 2 deletions(-)
>   create mode 100644 include/uapi/linux/alloc_tag.h
>   create mode 100644 tools/testing/selftests/alloc_tag/Makefile
>   create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
>

