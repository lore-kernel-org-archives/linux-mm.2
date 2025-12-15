Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1259FD5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E936B000A; Mon, 15 Dec 2025 09:26:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706596B0010; Mon, 15 Dec 2025 09:26:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642F76B0011; Mon, 15 Dec 2025 09:26:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 525626B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:26:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19AFBB7634
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:26:35 +0000 (UTC)
X-FDA: 84221931150.15.9C6D1A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6EF0140016
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:26:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9CBxFoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808793; a=rsa-sha256;
	cv=none;
	b=fsUu+jU6qjVY8m7vqkcGhrSIZkunFMZHWWVHo1ptyl9rgwjmJXRGmHshepEDHlZULd4tqi
	h6bjIa4cZzOTqjHMBq2d1R+UdBpW/+rBytIb0N+VsTwzfj9tgj9nAkcc9rfF5gVTU4Ool7
	p6sTnY2qtLT7a97fEwPQBzeN0qMgKic=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9CBxFoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2AehqQR9213pHHieeF1GNopfJ0xN2gI7ajoegW6IhA=;
	b=MjOGgOJ1VDsdY6wjlVJfI7mspSgxi581OesWI7IhJNdc9306ICjHIXhM84Lb1Gwyjpibqh
	HGzO9rPbH5N1pkq/scBkhjM3dAwbexSaEIfc9R8Qff/b0LV/qzyJhSLSdYNmt5T+GbGRiN
	FQGJNwZnkRqsI5BtedU0LIn6/oYnwXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA60A600AC;
	Mon, 15 Dec 2025 14:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7090C4CEFB;
	Mon, 15 Dec 2025 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765808792;
	bh=vfRvfzjxtdoOanlAjTkNDBQHuuTEoetvAyA6tMfwKtg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d9CBxFoF5yUM3zCJXEqAPWgC+jUV6COMMyPJU9KeU1hWsVQceZhkoOiyZTg+6hDXC
	 hcHVnRfo10YzjQECcx5Tu1/turO+zG8GQ6iKeiqvwUPsW6sJCrdzTgOzhr8difjPoe
	 J53dYsWhEV2U9TSb5QOkaKuAVz5ZuP855qv7tOQUFR3vu3OwYrfppG1AQYpVFcvs6q
	 4NF/25TiNogYlhFPYZ9GIAAhlJfM6uOxN+TPoMWXlHG5iPQ+9VvJ1hNNSud3eMY3Yd
	 r1lsojsPUcf9RsUK/jI703+9jkgGzJP19m1AxQsaBJLUZAas8/y0buTSJx8eYO+Woi
	 oAkrG+bwoYGTA==
Message-ID: <5088b710-cfc5-417e-b629-c01d1eccb9b1@kernel.org>
Date: Mon, 15 Dec 2025 15:26:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
To: Matthew Wilcox <willy@infradead.org>,
 Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, corbet@lwn.net,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com,
 sunnanyong@huawei.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251215123407.380813-1-zhangqilong3@huawei.com>
 <aUAUd_XJPVsl_CZL@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aUAUd_XJPVsl_CZL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EF0140016
X-Stat-Signature: n9w68xbbf9os1usuh3exmhyu8as6j1gg
X-Rspam-User: 
X-HE-Tag: 1765808793-57851
X-HE-Meta: U2FsdGVkX1/hb0w3smgSSsrlxPOnV/kYc4wi4r02B+B6ja+O7KXfr9LH0KTjKHVr8NEJgSBQbz1zc4E3WppGpEb6n71Wyg/rIc85nlPWTlJfdiHC9BJre/RXyM6O6mMeU8y/6MLBqFmtbG/yGqEE7rFEVraJviRLt5AYcqCqSlPrHDGYL+aaB+mH/nQG827G8ijMOBE7ufBWNbQWQJI5iGb2qHNOViANoFDhMJfobC1xsiGIqbK8dmQTFXed6QdLTzMXgY7IUtIIady/zAdZmXt58FIIbLI3lM5t5nD0DN983VaWjImnNFFDTy/acZOrEN8tx2NypgJ9kww4OcFfxaAU3fTftFREv449h/LjJ9+ixpPiZ3kqci2XP3F744tRjCz0IuUxCOAlSrcjGCtbj/G1y+Y03Yx4VWuay7T1Ghu3KE8Z5P/w6Xe2On40NxnlSFxrYJp0k9wdvSTyMiy742OrHkdQRAms1rMSOw47J+YkRaXYpt8cUbF7izdLgyRy/stYHP9ZRb0e9mrbVcoog0ggEd6dW8k0bQcuTQO0JowLZnvpY3tHXP2r4bnzahGYhPpo9HpTLvTll4FLaQUt0+7lYdCDk0U9GqF1L2xsFju7JlsWupm/HpJHKQ8XaifBwjDHrotevV/zJ8COghv1TI5cXIGrHpjaVxpPgKOiT4XMaL2OHnv4Z3pI6AAqJds3nn/KubR8bY4Xp0sGbk3ZtiYxIcEGAOrdwcgLooXw+rGQLXvi3jwzMidDiI3n9YQJYPP/uXYXTMpBqXqRia5AymzitZ6qXktuIaxIVRlxqglZCYlE500gYT0bFIW558pBwGTnyrQh5MF6vShPxmOGexQqlXXqijqDceYzcg4UsRnSqmCO/onw89jd9RjIKnaHq+N6rKM0kboGPcWfksUjHtwFjo31njcPyJ5dmvdJjUK5RK7IHQ8eVT4uCw2WAJ4z5euhsjRSKuWUP+SiOxB
 o8Qvn74T
 84Wm7rT5pDqSJffE1wZeWFO4GRwn4HVJJ30l6wWuRqxN7sBTzsaYaXgAyoI5hFrrXK8M4MWvQ5WDwYgo6R3Dzg4/5vqpRVbF8z1/aY6XrJb1u7GJM95YXbve2MC6R/7TK6Eimq5t/rvRwLXoEteCqid+ehS2qV9Y2QJUpjYeZ1uISI9JsnCW/e6Bb9MG01lY78ujbTSLdwtpJtZVuGYbtVzOcMR56BUWhSZFga6oApwZgxwEE8mHnyWzAuJpMTnANd6dh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 15:00, Matthew Wilcox wrote:
> On Mon, Dec 15, 2025 at 08:34:05PM +0800, Zhang Qilong wrote:
>> This patch series implementate THP COW for private executable file
>> mmap. It's major designed to increase the iTLB cache hit rate for
>> hot patching application, and we add a new sysfs knob to disable or
>> enable it.
> 
> You're going to have to provide data to get this patch in.  We've
> deliberately not done this in the past due to memory consumption overhead.
> So you need to prove that's now the wrong decision to make.
> 
> Microbenchmarks would be a bare minimum, but what are really needed are
> numbers from actual workloads.

In addition, the sysfs toggle is rather horrible. It's rather clear that 
this is not a system-wide setting to be made, as you likely only want 
that behavior (if at all ...) for a handful of special processes I assume?

-- 
Cheers

David

