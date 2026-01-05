Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14722C2A07A
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABF56B0110; Mon,  5 Jan 2026 04:35:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5580C6B0111; Mon,  5 Jan 2026 04:35:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439B56B0112; Mon,  5 Jan 2026 04:35:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34D9D6B0110
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:35:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF8BF9F2B6
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:35:03 +0000 (UTC)
X-FDA: 84297401286.29.28508D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1DF1C18000D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:35:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVtYl43N;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767605702; a=rsa-sha256;
	cv=none;
	b=ansTsasqLicLr52+9UDC1bgSK2Pp86thjdIPCIAXRS4euYhhbUN7tbrPbaUUZDen5eaA6n
	l4O8jPD3GvwDtAzKWwf6jIl1hB1g8O+eMPPEYjYQFcKC3oR43UXhQpRMdqDUu3otsMQ7FW
	PTgCDTLiuoAlamtmZdO+bAYpvZjVLjw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVtYl43N;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767605702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xN/knMZf4MAFBx6ZWKRu/Poc/1c/pqv4Ar+pXBUK73I=;
	b=tvGinCvDya2JR0+1QnyXw0zMvJE5isTrz3kds61vuyv4m/81ncJ9cjWGIaFtpE46GEXNqb
	9eEoRmxh4v9ewPbqJISo+loVCWIgsR4qoE2cyGgy4K7F8a7qjZ5XeWezyqfbb6vOTWH4M8
	3S5+RnL9jICXOgMJzQ+OOo4BJx/uSFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6469C6011E;
	Mon,  5 Jan 2026 09:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D20C116D0;
	Mon,  5 Jan 2026 09:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767605701;
	bh=bn7mM9cOL8od9/KRNKPTS1zEKSNile2RiMjyI0hZBf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVtYl43NMWF7kgcJE4xufMXZZpjTsLLjkQnuZPgsgz9d/YZYL0qm77oYxQKBKmAJK
	 F8zv+f6PCteGmpflvD6m59enuxDzGihjhl7qfdkJty+HSTNDrAMD5mr9pjliYmINBC
	 hsaS6U1Q0UYvf5BbhyfOkEeQsLKzO+drcJwSM5StyTQ9Ot2oK47ZG35crN3OZAMpYQ
	 VD22esVWApTUvNTCqoz/sXRfjKkQWF/9mkhWBP71WZnQ8wooORUd3GzY8zuRLHYMi6
	 SJw8oilCe9pXK5NNnDv37f5mv303+5J8tb3Kom1K57gWRSu1NgmyPkSHQO8EMmGhVV
	 eh3tSWdZ3H7iw==
Date: Mon, 5 Jan 2026 11:34:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	wangyinfeng@phytium.com.cn, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Message-ID: <aVuFv7P6og6pY2lj@kernel.org>
References: <20251230092750.856060-1-cuichao1753@phytium.com.cn>
 <aVPtSNKRnnI88Euk@kernel.org>
 <dac83ef4-6e4d-421b-bd54-7090d2f963d9@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dac83ef4-6e4d-421b-bd54-7090d2f963d9@phytium.com.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DF1C18000D
X-Rspamd-Server: rspam04
X-Stat-Signature: yroysx1ngkoo8agoqsr8qfrik8kktbp3
X-HE-Tag: 1767605701-251255
X-HE-Meta: U2FsdGVkX1/lxWFRZM92zzVPd8+kpyB0gI9R0aKhhur/73BYRQLw22bNJf5Df0VwsZKpFM0PfzgeoQNtmUV8sz8TZGEmgJQuc5799tRswQD21RjwLxhWt4K+7cOmVOBD/1LZv9zofRxhqVjBRi4qsd25IrXch/8KHBg6jUA4ExHnnEyti03o4vCvWevBwgNrM2N3nkzuYgJ1mPwhqb5ujWKRtUFetzAXiAEPFn0Ep/9Pn3M7Glhfl2E+Ex3yUFIlQyL2+SmtVbpSThmvrqBXmWSolFQu3uYZtfqUbr1cEHb9TuBKu5Dn2wh8GeekrP42xwOirMT/cdhD4M2xTFSH2V4HX4rk+pZ2GKRKlP7XkLA1oOuGI9D/jdBUUJAfcKXtGYfRh9HJpfpIHYnPT0QjDjV3aSeQuCf8YaxLnccG7VNORIkOBlPpzO/56HDlxT+OEcreqBE0iOa2xkTSr3/nTarEQNLO9O84cBchcgMPGHMSF0J6Axqnfh0Q2bYBVO5PDf/rDCZpXHpi98ZRlvG5a46NV3/d+qZmcx54HHe8LopjKj9dyIy84lAn1r6fI2Xbsp9gepfKI71Hmmt22LVd6A65EG0WtHSxYuSAEncgiP26hbH+FcbrcKULXwXtxKCMhNYxRNVhEORLtFEEN1m/tBu8rVdLaeKlqe0YCpm2km+3o3M4bpVKTwQOLa2Av/ziFiIDpnGmKjXme5qfqwSYHOmSIuDeHiHduf+U4/LEAEkl34Og4FZ9hToNpvO3MpOmJ/tFH6a5xxIwqyUF3Fb8pBDhRIa7PXp9QUc/paB20RPYFJ3UABSZbZOyWqwRsXkeagwGVv/HsvMsAaQjYoWVVa90ds87v3tZ/v3exHcBWjanJVuKYv5XiConAeeB7yy6oBovu04ZbC73l8zpihGDxNvuCXAZatiuIXOP1c5T5OH9HPFwhGrvVuCZUtZMM7SdItkfHXc3QcW5B5anA2B
 IQdIW4bH
 YcDfkJK5Jfphu1WQCj74Fo5hhAgTeeGQS0BG+EXlrxcQSLSmq4rToFkBRDBtYFNjkZgw0KBI1M9fZb82ow8Rh5iGHEjGZKHFqJkuxe3p4U8Bo9738o0Y+laDWRohZ86q1ZMiLXI4s9fhu3Wl4fGDavO3ahezduH2YKEB2Bmhb0cHfd+IBuykZHEX3PdDJP+JqsJxi2AreNHRsxoqKASBYzzSMkqAG8465GAj/AGGPLv21YLdTNQ7qpFjr1iGWzF4LntndGoAXG/RlHO5aJACRFD7nOQ7d1/T4/jLFfrCIWD7YNTPoa3emj7IThE+lkjLb3pjpK0vPTUIpOONGCwI1mZSVxKXCGF+TnbGDOxPys9AHwuXKD6wQvS32tr1Y1Gw6dm4r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:38:30AM +0800, Cui Chao wrote:
> Hi,
> 
> Thank you for your review.
> 
> On 12/30/2025 11:18 PM, Mike Rapoport wrote:
> > Hi,
> > 
> > On Tue, Dec 30, 2025 at 05:27:50PM +0800, Cui Chao wrote:
> > > In some physical memory layout designs, the address space of CFMW
> > > resides between multiple segments of system memory belonging to
> > > the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> > > of system memory are merged into a larger numa_memblk. When
> > > identifying which NUMA node the CFMW belongs to, it may be incorrectly
> > > assigned to the NUMA node of the merged system memory. To address this
> > Can you please provide an example of such memory layout?
> 
> Example memory layout:
> 
> Physical address space:
>     0x00000000 - 0x1FFFFFFF  System RAM (node0)
>     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>     0x40000000 - 0x5FFFFFFF  System RAM (node0)
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>     0x00000000 - 0x5FFFFFFF  System RAM (node0)  // CFMW is inside this
> range
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
> 
> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

Can you please add this example to the changelog? 
 
> > > scenario, accurately identifying the correct NUMA node can be achieved
> > > by checking whether the region belongs to both numa_meminfo and
> > > numa_reserved_meminfo.
> > > 
> > > Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>

-- 
Sincerely yours,
Mike.

