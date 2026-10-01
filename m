Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4CECA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 13:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77106B0088; Thu,  1 Oct 2026 09:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28576B008A; Thu,  1 Oct 2026 09:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E0C6B008C; Thu,  1 Oct 2026 09:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72A476B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:16:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 612F11403E2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:16:29 +0000 (UTC)
X-FDA: 85274106498.06.B0EA91A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16FCBC0013
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 13:16:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="O7o6r/UH";
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790860587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCt6o8VOgrKkGhAY2Is0Nms9O98XUObF8CH3SAC4B6s=;
	b=0Bs07wc0fMT2rMs19trcgFDsQNhzzLUlgVlak0fy3E//vbtJPJDFcBFFxpTPgNHgwtBfKo
	75JeDm8EqN63pQQJfcgubxF/ianTq+vt7IiZOUO9ySsB+T1ForxxhD14h77Xo4/nsY6Lqw
	etCdW3yP5iHieQHnNoBXVM35TyhqIoM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790860587;
	b=GuuDDAf4/obJHqPxW2S9S5yhUtgI/b97/AgOpIgyWuSIgjuSUWo+VcWEIvp6xeW9+jcm8A
	H1aCCToziwF+IU7MFSsoiDnFuZ/9nyOQy3xW++RzFOPkv3nxiMHhbBomM63oUJoPl4G2ji
	t8KIddZb3tbMkBYM1b7mwdbyqterpWw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="O7o6r/UH";
	spf=pass (imf10.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BC11497;
	Thu,  1 Oct 2026 06:16:21 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D280E3F86F;
	Thu,  1 Oct 2026 06:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790860584; bh=LVs5YT6LT4gg7RTPzyx3qM7GfiwK0MeknB481u6FJ9E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O7o6r/UHppDvRwr0D1xETP/vef/fSpqy/5tmXsF8MkHAT300YbeO1lhrpj6lgzzOa
	 LUlhZizf7Ie53COu1hQAA7QLTVqrQB78/0dyuutZ9rIpyVMgFqu53NyrK4CSwiJYMa
	 qtnpVB7nzRK0133zlRd2Td27itIeaQgZc3h+6UXE=
Message-ID: <54f1d9b8-948a-482d-8fa5-694fd937c9e8@arm.com>
Date: Thu, 1 Oct 2026 18:46:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 6/9] selftests/mm: mremap_test: replace random data
 with deterministic pattern
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-7-sarthak.sharma@arm.com>
 <b45813af-df08-4270-93ac-d99ee42830ec@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <b45813af-df08-4270-93ac-d99ee42830ec@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a4jnuefknnq3pdfu71pow3q4mbqs5ndy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16FCBC0013
X-HE-Tag: 1790860586-161959
X-HE-Meta: U2FsdGVkX1/Q2LBLXy3zl6ZHV7vkTCTnrpdy0C+aDukXdh9efu5MPbBJypc3VxtBAdjnEzUYFYGKbBM7aaX+rWWl2aMXpsBsPlo/2Vpu7I8JSma4ufd3+Oj5gQOBRoldO7/Jq++mO+/SYj9sMCJjjn/IOJs4tw+6xar1Te9gpFE729iA486BkQhLHTxmeNm4pY4IxJeUyw/iPLnawF5NTALZL4u93fDzsyIGR0zV4AJ0vxsR70ZG1O8FWAZfgpCNFsrsZ73GYlJb6K4d3WesHRiBtBnWlNmrc6YJbbcc/iraGmIYAIFYf9Wih/k7ezlCoPX5KRYOWqBW1hw3ea0AjaPZyimZXVhCVgEfgT13cU+JTnceaRalQbXa13eHpweA0AnYq38KjFEytA3khvocPPsytZckaM8j8GRMVEMwQintn/jGp57ThrNb42NrI0euf4XZ6F7X1aXbgIwwlY5sXrYWZ8PaNa81569iTAVjnI9Tmfg7Z/i22k/YIvVbZMxl0wSAdba1QENGvHAjYDrGFG6xNAXvtJxyhDvc05XsrvI0pSVfsW95MgHmjMA0nWa1YdRcas2m+XQ4I0m71BBOYdXOkwRK2shymHkwRdcsrx5hpSj/Tw4at09rYcK9GYTDs+45KG1wYNBYR6oDJnvVW3j1lR7bN+4QkQceWsSJNKpp12jj93SJINP/+/22nukf/v9xMD6lFlIugJmDJtxeJk7lzq9UIGRuB2WO0R3ghVvqNiqWSciujQL6BuQPhVyJhcjibzfIUa2xgsVYUiBNhhH+NoWoSF1TNH2vLJd06JGpIt8r53pJ/i3YLCVhb98Jpr9vSkRTjQnIbAkJurPlSzqEA6+IK+w86zStK0F/k7yyFcLK4Pikv6YfoAPOPOmUU0h+5ddPsFRdB/8c4ZZLzzTgLmbqqvkegat+hPrVGGkTU0+CXQeX4bF9dD7KaZiPNeBihQN5w+LxDZAzfRO
 wRIUAIJv
 DU6EMj+vMTeaNyxNN2lkp9exeJFIKdt3cDgWfn4ySlo9bCjSP7TaOpJ7BMRtmaXwc1weoBDQHkIpMXOZcwvuz91fsklHYHAjKUs6T8x/q55hVEJhtCEddnqkwpEzywa22GmuJCJiLMGPaiytsTP9fvjtA0xGkjTK0+n2guuaCA7IQdFLN6+58RtA82xpzY5xLwuKw7gqIPiJWJ0RY+RresM40W3oJ6pAZ6wt/ZYbHZZwvJQLe77dFE9FUm5C2tj/B6fQzZis8vZKa0rInfaqLNAAuZzSD/6mY5T2D+sSuHFtgEdvrACkbiJpWqK3u76z7Zfz7zz/tvhpXeuDvedadODnx4EztZYkdzkfAXlHzl9zY11k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/1/26 5:30 PM, David Hildenbrand (Arm) wrote:
> On 9/24/26 07:00, Sarthak Sharma wrote:
>> mremap_test uses a random data stream to detect corruption after remap
>> operations. This requires seed handling and byte by byte validation,
>> which is inefficient.
>>
>> Replace it with a deterministic pattern where every word in a page
>> contains its one-based page index. Use memcpy() and memcmp() to
>> initialize and validate the mappings. Remove the pattern seed and
>> its command line option. Also update the comment diagrams to
>> reflect the new deterministic pattern.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
> 
> How will this patch change with the change in threshold handling? Does it make
> sense to reshuffle the patches?

From an intermediate patch POV, both ways of doing should be identical:

a) Remove threshold first, then remove randomization:
	i) Adjust random buffer size according to what the test requires
	   and implement the start, mid end pages checking
	ii) Replace rand approach with fixed pattern

b) Remove randomization first, then remove threshold:
	i) Adjust fixed pattern size according to threshold
	ii) Implement the new logic of start, mid and end pages checking
	    and adjust pattern size

But if we plan to remove perf and timing infrastructure before (which I
plan to do in v2), yes removing threshold first would be neater, since
it will keep both the removal patches together. Please let me know if I
am missing something.


