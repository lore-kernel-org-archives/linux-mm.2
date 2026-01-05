Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF76C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881A96B00A1; Mon,  5 Jan 2026 11:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8524A6B00D7; Mon,  5 Jan 2026 11:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9056B00B9; Mon,  5 Jan 2026 11:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68BAE6B0195
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:42:04 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E66A1A8C2F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:42:04 +0000 (UTC)
X-FDA: 84298477368.07.E221AAE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4F6F440012
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:42:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767631322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecwU61vSMDvwVxGvE4lCZ/nGt10YlcCNPWtJAI6XoCw=;
	b=HHCxL/B0v1og5cmjUnshZPmJunMUCgdLztaGCAxZfdIfwHjXdxHi1tFSx9qvXsScZa31yJ
	BnL4uAz8d4rUpq9GYt7cez13LL59tptBhKYtsjvXMb7zuxR+Oph7qu7Cc6Z4TePJJqmStm
	8rhIqZlOLlb7JFQdtkVx+WrwHRdEd9o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767631322; a=rsa-sha256;
	cv=none;
	b=Bd00ODeWcsiRBuqTSSn45ssFxfUrf8zPQ6HDJjflx8L0oyzFmE0o8RGTioNT4MFPVBeRiD
	JMEk23e1gv6NMwcCg1AkRLvUJ0ekVhPStGWHW4b8sNBn3XDFHw7bQIEShYJFF5KiL/retQ
	nxdUsx56JTgBx3HbQInDUbI8Bv4PFLA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6360E339;
	Mon,  5 Jan 2026 08:41:54 -0800 (PST)
Received: from [10.1.38.150] (XHFQ2J9959.cambridge.arm.com [10.1.38.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65D193F6A8;
	Mon,  5 Jan 2026 08:41:59 -0800 (PST)
Message-ID: <acd0b9ab-9b7c-42b9-91a9-7fc85140b6ca@arm.com>
Date: Mon, 5 Jan 2026 16:41:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] Free contiguous order-0 pages efficiently
Content-Language: en-GB
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <D9734C47-0EDA-4154-8889-1B789B49322F@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <D9734C47-0EDA-4154-8889-1B789B49322F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4bthocttmre5fp4s6w3t6r879sjco3ny
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F6F440012
X-HE-Tag: 1767631322-11745
X-HE-Meta: U2FsdGVkX1/9TT5GD71XvUWmgkhVZVSMfhNB3As+73IV08NhNtMvZaPrqLmjqGj7aYHuLs5BGBMQ2vZBD+7ZOcRYlgytz+cQNRh/aUwdezyZWbFwxB1S2xkHPMkHK8h124YTFCpzKzZx1bH3rU9qrmPCW94/RdbityOndcW19nigda9+aDY12goT6vXSuWVIegCL6Jz0+0eM+ceN6fww8hN/qKX59lZ56nxjeO6d0qIMJzvcWmNQLq0gLp8Ik3Ii0gOOYZD5YyU6oZtKJirVCLVsQN2iNaE5zhfQ70RuIKi6NdhdMJSvM/QVyLlBvTSFcxwX43Hufi0eiikLnoh5HBuXmr2apuXUopeFSKQ0aI/zRP2rynDSRMSwHhqcmEVm5GsGIphWeIdwEfyruo/BMk3QJzV0MVWTALdcE3xXpdRb98si/pWSqmhFN0kGdqj+H6cN5jdrsM+1NYV8lLM6oqH4A6utlRKbbnDirva879kMlvr13OXN3lvBIVVyCe/sF1xP2m6kcix3FAd9VhFAqf01oZghV9BbBrX7IFmCm0Cd5nbpelgHwgvMPjHGpEpI1dA4xG2ai8hozbCJXH0DxgQAdpbJ3V7PcRx3Kl8s7aOnavxSpg4bLx2qEW+bBlnASQweIknz4nVrd1yYmoa9mVyfQOdSqILO+dkYmdY4D5oimHFUbAfS0lu7K0aTJtRvTCiGyWyEVN6UU+42QiFTgYB3j1bzxQRfZ5aAzqIEjUYPbAGMA4d68g9EJJMnvBL/KVfbTL7WlGng+8QQklOBtVQyuShgYgc18czxse0SzOn8O6OrVx+rFfLewE0YassmgOUm4sS9vCqRQg51li2jO6rjWDoCb6MeulyWPUZP/V4ZIXYSkjKGrY3mPWNi7WrhAAeWfd4JaUMmQJHZAkYNGz4RtuS7p6dOUSyY7HsTSe9ByZooDktOmNHuQ8bEZltr/PNpeJbla6DTen2VGIB
 nazswmXr
 Um/8Euomyv+LVE+FZ01BEZDIxhlbNplajJpTpYouvqTPTp7xyGyA436vjo4VxrFkh2f9AfAo45nSriCBxTRqMlm9c9JYWi13QZ7ztg0KPEbU1p4ii3BBB1FsTJ82zP8U0IpcoIySA2jDDqQVlh1JarhFYCHBMXnSRsDhCgja0F14D9ZT53+nRbAvgXmGsYvh4lrYUpBoLvj7IU7vcZI4HSj1cbmagxVxyov6BxDNYdduF6D+UaZlj1R7uV1HpQ2IRjHOdQ8DL6FcWnIUVxWIWqop4jR9KxU6WoIU0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/01/2026 16:36, Zi Yan wrote:
> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
> 
>> Hi All,
>>
>> A recent change to vmalloc caused some performance benchmark regressions (see
>> [1]). I'm attempting to fix that (and at the same time signficantly improve
>> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.
>>
>> At the same time I observed that free_contig_range() was essentially doing the
>> same thing as vfree() so I've fixed it there too.
>>
>> I think I've convinced myself that free_pages_prepare() per order-0 page
>> followed by a single free_frozen_page_commit() or free_one_page() for the high
>> order block is safe/correct, but would be good if a page_alloc expert can
>> confirm!
>>
>> Applies against today's mm-unstable (344d3580dacd). All mm selftests run and
>> pass.
> 
> Kefeng has a series on using frozen pages for alloc_contig*() in mm-new
> and touches free_contig_range() as well. You might want to rebase on top
> of that.
> 
> I like your approach of freeing multiple order-0 pages as a batch, since
> they are essentially a non-compound high order page. I also pointed out
> a similar optimization when reviewing Kefeng’s patchset[1] (see my comment
> on __free_contig_frozen_range()).
> 
> In terms of rebase, there should be minor for free_contig_range(). In addition,
> maybe your free_prepared_contig_range() can replace __free_contig_frozen_range()
> in Kefeng’s version to improve performance for both code paths.

OK, great! I'll hold off on the rebase until I get some code review feedback on
this version (I'd like to hear someone agree that what I'm doing is actually
sound!). Assuming feedback is positive, I'll rebase v2 onto mm-new and look at
the extra optimization opportunites as you suggest.

Thanks,
Ryan

> 
> I will take a look at the patches. Thanks.
> 
> [1] https://lore.kernel.org/linux-mm/D90F7769-F3A8-4234-A9CE-F97BC48CCACE@nvidia.com/
> 
>>
>> Thanks,
>> Ryan
>>
>> Ryan Roberts (2):
>>   mm/page_alloc: Optimize free_contig_range()
>>   vmalloc: Optimize vfree
>>
>>  include/linux/gfp.h |   1 +
>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>>  mm/vmalloc.c        |  29 +++++++----
>>  3 files changed, 125 insertions(+), 21 deletions(-)
>>
>> --
>> 2.43.0
> 
> 
> Best Regards,
> Yan, Zi


