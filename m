Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47F9D172C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30CE6B0088; Sun,  1 Feb 2026 23:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3F86B0089; Sun,  1 Feb 2026 23:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B6F6B008A; Sun,  1 Feb 2026 23:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF4AF6B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:49:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4CA3F8CBF6
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:49:08 +0000 (UTC)
X-FDA: 84398287176.19.657F12D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FBD7C000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:49:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770007746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMTLwTiGXiPrzkV2SsL2OnW5kJvjDOPABC51IhmEd1g=;
	b=YAlh1vo7U22PyYSTlRXHb/DaJvruqxS/8xOXzxLrVWtaTmlsEhGJ1+Msrp1F4yFiaaIV6P
	RKCIhX7D8j5owwIxaxtkFFUAgX/9ATLAnuLdKF0k48JlJ8s60+99gck1Mm1okjO/l4nvZX
	AAmw2j2UjagTphbzb8me1jySy7WyWIo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770007746; a=rsa-sha256;
	cv=none;
	b=GtmWCxFRijmqPW527VoveUCkQ3SadcZd7AdlJXPgEA9ZOwmfopwuohji+Wl+LZ7guzviAc
	KxETqtAaiT5rb8K255MmDE00JE9c6YiSZ/xOvXWge4l5T5qDoNzmXW/jOHHgqUNS/hs/86
	X6nbXYNWy4yW/141YVcihiBN8gxr1Qg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0533339;
	Sun,  1 Feb 2026 20:48:58 -0800 (PST)
Received: from [10.164.136.51] (unknown [10.164.136.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 764743F740;
	Sun,  1 Feb 2026 20:49:01 -0800 (PST)
Message-ID: <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
Date: Mon, 2 Feb 2026 10:18:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com> <aYAmGc6lu973jRwu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYAmGc6lu973jRwu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ug4yyespmmhrf9kfrco1h1aw1g3ngmxc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FBD7C000C
X-HE-Tag: 1770007746-438107
X-HE-Meta: U2FsdGVkX1/eWMNNcaRf0PlCyk/QJbV+miru85VB/QFguKlMgFKZsLvPCN01F6wO8Ecozk/3u63DiiHupDGp62mf7T96S8gOXuna4rf3fsLQeeN5G9lzyMAZ0Skw6btZw4ac8+L2mdetPvw4eqJsHqkWGCoFZ2fgTH+xPIEAza5vKLdrmBSfOo66gLHHoQw0mhtaYkGwuHPxgnjix0Z4nFQ+6RgT0l0ZwGTjrEVzWOc1ypNNxJCdL3fZpNqI/0pDTDydcYv1lu4T0E3KvE2gYF+mXiUpsQAmRiX8JGIHUKNt0Uq1rhrx/1nKxEAnFIE2q6XxGoY0gtt+5xA2RANToiJlIoTvfbHtQDxTd58HLmcAwT8mlhVVz5NZ9QiyM2vSoTWvkDx6kAah/fPsHgRlPv6IxDq6fpbJpiDN76hCWvVzL1aNjBPVKUjo/AvopMGzcOuRwy9AxGXoQ5TRzneKPLq9vVDk6OPNX85V9co6hLxI8ZV0d+m1Ng+yz+4SXKho1cnSCADQ8x90UbhO2DnPqlSS6mTRMWFnmYWVJq11JfVLlOLI296yG/fNOkkEOT/kmUsupm/zNu0oazkKHkGhSjr7MQhmLpyoSaMUMnfvOM+/NNTmHzM6Eq/ShZclqGvtiOQA38FWBa2KmrejuNE43QOQViI/4Sks+3Lmsc2wV1x0OzXM77BBwyRAuun4rpLG3AGs3bcLy6za5dxmT73FrJG5s3hewIbiKSuj3rymSpoO5eKYbJe1//50Er+M5dGg/q4MPMxZCNt2+yiLsvrDMkPDEb6erG6LfSA29etnXH89Lf+rrNcmrN3cbZWv9QEemt7p3ynJfuc/ToftQEBNd3qVbyAt93VrBUVO93FqVDh/YJXYKqAMBa06CQM4UR0F5NCRA9gc3wU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 02/02/26 9:56 am, Shakeel Butt wrote:
> On Thu, Jan 29, 2026 at 06:35:21PM +0530, Dev Jain wrote:
>> On 11/11/25 4:50 am, Shakeel Butt wrote:
>>> The memcg stats are safe against irq (and nmi) context and thus does not
>>> require disabling irqs. However some code paths for memcg stats also
>>> update the node level stats and use irq unsafe interface and thus
>>> require the users to disable irqs. However node level stats, on
>>> architectures with HAVE_CMPXCHG_LOCAL (all major ones), has interface
>>> which does not require irq disabling. Let's move memcg stats code to
>>> start using that interface for node level stats.
>>>
>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> ---
>> Hello Shakeel,
>>
>> We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
>> the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
>> to munmap. Please see below if my understanding of this patch is correct.
> Thanks for the report. Are you seeing regression in just the benchmark
> or some real workload as well? Also how much regression are you seeing?
> I have a kernel rebot regression report [1] for this patch as well which
> says 2.6% regression and thus it was on the back-burner for now. I will
> take look at this again soon.

The munmap regression is ~24%. Haven't observed a regression in any other
benchmark yet.

>
> [1] https://lore.kernel.org/all/202512101408.af3876df-lkp@intel.com/
>

