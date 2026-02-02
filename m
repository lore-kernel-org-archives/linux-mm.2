Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FC5E73147
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 08:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67556B0089; Mon,  2 Feb 2026 03:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB396B008A; Mon,  2 Feb 2026 03:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED896B008C; Mon,  2 Feb 2026 03:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2E76B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:54:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9E2A5BE4E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:54:04 +0000 (UTC)
X-FDA: 84398904408.18.0D7BA3D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD3CF180005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:54:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770022443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wCCypIaXKpWMb58+1hCS9Ov91QjKibSl1ta3D1UexA=;
	b=DsqNlQUjO+mWY7/n1Lbfcvnt3ZsEmViAOF8YURAH+113C7JRubsoAB8SDF2k4PEkT96JXP
	MkACLD044ivDhYyb5MiOZ2szOPDOKmT5itszsay/rTY2iGh4ysRrQ9NOWUU6j7e3pfrtwa
	zBF4z/gDlwHuOfRRf3W+QncPqx6NYZw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770022443; a=rsa-sha256;
	cv=none;
	b=H14QdjJnKJytq++KrJ417WXuErxfhWnCRr+o02zhZV4WO5oL7QOfEicd+NUKLGbWMt4ZNv
	4iZBy4ULdJP/M6X5o7G56WOchk2ltWIOKsZDU9eQU7mt5B5D5fkuMKeifPpZe+jxkaWRII
	P6MVsxsApzRNZsNnZ3mrBruTHW7K69o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44738339;
	Mon,  2 Feb 2026 00:53:55 -0800 (PST)
Received: from [10.164.18.75] (unknown [10.164.18.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC54E3F740;
	Mon,  2 Feb 2026 00:53:57 -0800 (PST)
Message-ID: <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
Date: Mon, 2 Feb 2026 14:23:54 +0530
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
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD3CF180005
X-Rspamd-Server: rspam07
X-Stat-Signature: u6ksaber6zu9eyuu7ugxtjxwof99pgo5
X-HE-Tag: 1770022442-393983
X-HE-Meta: U2FsdGVkX1+vqSx9/SDS62m46bi3KeWQjK/731wnbEDe3OZaseqxbqwZq7fW0aomQ5RpMTy5eQrulkjp4LNnUqezLFCPVSLQGP6wDuinlh4H3Ipn3zgAliI8fHKEpD9R4ki+E3t8ukTJDAICetmgwsmbe4U1Fzk/GmcmztJz1nPKs3/vx7p9E6Aaav618F1uE7NG2+1A+GZEvSjaZrypyMoCkExidEIi01bbUYkXM269h39NZObk9qmNQ02O/OuJey8TLSiriy3uP4uSEnyNMQ8/vwu/ZTsFK7uuxIkMV9EykqsMNlp+LKYvwlpZO2wefVr6tEzb7LweGwPn6yuJ9Iv0sH5MWt3LFHvATDrd9WvkVnc0jRhpc8/LABGc68VMMl88L0vNJatFvIVYIR2Mcv78nzjE21Bl5h+Q/7Xf7W8qBZXFtSFGrMbMUTLDJWAOtvNXij0kc4kwPC5ypoGiu0q2zxIXwmF6Kr2sqYGJP1Eol2AbgyqBva73ki5Rl90DcbMnxB8d7teE+WDKwAx1FPs/Saf6vvDlJF1kgekukdsWobkmeCSJVzoo0m+qS4V5KG+LBpij9sJMSoE0lbcesMWx2+9grMYlm9Yi/0Rg2edqyMlG++a0+NTuti3ly+AMpJ2rJ/G2L+5/5JaDXsin1sjDH7Rb/gzn5M+cufuZDnHRgDqSAympCr8kxqLNXqQHsVTfQKtyrGS7Ja+UMyyx5tkwRk77t/19QKduoEZ7mAIGSLTtnKExx0/OzCQz+tYIcIWZufZtDY/4fW2AaEVfyhFnMpRHWnqcQ1GEKO+05+7DfCkYCWPTmIz+dFfXiIaTSOosnt2IyqKJBE69HbM63dHPjfMlxfN7+GRpiyROyWJLx3QJq2a4xLN8Asj7g9yFmEtn5+uzSuN/C6wgTZmdfnbZrUPB11rGFbyzRmDtO/brU8tgszDSI33JC3ERr0bl3KrJHOHCShi9CZlzEo1
 95OEwW0G
 3qvFRqdZaNbFuA6rRv1JNp8jmHbl1Txp9IRml3guNF/OfZU7HzTLwjG30y3U1iJt4qEh+idhv+jfKruTU4HiYxtryFoqqGdaHwLi6683UBclJ7qi/WHNbJX2ekC+yoyvjP2UWieII8aedzFF3dqYWOJcqcGjGtdCots1XM7A4sDGmBJ+SBsNaFse82nbM+6Y2kA7kiYhU0RVAi6g6nId4cRPQLfCNhWSNENNawD476NgUa56myRgR7kZZSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 02/02/26 10:24 am, Shakeel Butt wrote:
>>>> Hello Shakeel,
>>>>
>>>>  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
>>>>  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
>>>>  to munmap. Please see below if my understanding of this patch is correct.
>>>>
>>>  Thanks for the report. Are you seeing regression in just the benchmark
>>>  or some real workload as well? Also how much regression are you seeing?
>>>  I have a kernel rebot regression report [1] for this patch as well which
>>>  says 2.6% regression and thus it was on the back-burner for now. I will
>>>  take look at this again soon.
>>>
>> The munmap regression is ~24%. Haven't observed a regression in any other
>> benchmark yet.
> Please share the code/benchmark which shows such regression, also if you can
> share the perf profile, that would be awesome.

https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
You can run this with
./micromm 0 munmap 10

Don't have a perf profile, I measured the time taken by above command, with and
without the patch.


