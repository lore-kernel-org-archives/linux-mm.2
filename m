Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D29CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 03:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E9B8E000C; Tue, 11 Nov 2025 22:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355838E0002; Tue, 11 Nov 2025 22:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292F98E000C; Tue, 11 Nov 2025 22:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 18E768E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:58:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5FDF1602F4
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:58:43 +0000 (UTC)
X-FDA: 84100598526.12.4A4B2EF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 083CB180004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:58:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762919922; a=rsa-sha256;
	cv=none;
	b=C4yPY8x+7aiBInvoe7WXCluI72qkzK1AgEoka5oaIz2aaXK+XtvBvBj67YV01btuYzwoOP
	b9eMlTBxkW/Lw/lg4xozjYCySXo6nihcNVXOhK3JAQJIF6NRIjqVT4/GHKhpgWoc7lxqLJ
	Mqs7uA8ZDlikVMjraJAgY+svegzr20g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762919922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QN5OS2KvdscboVyOnBEkHw4P/EaV6sHWrdSW/m7H7Cg=;
	b=1TWyz9ci+OVwShW7rOBgMhoU6/tDKa23S46mPhW3682qmUlxHKmbUXFuIRjotvStd1KlK9
	2v+vghxLgWKQaX1MhRm9V5VMd6x9/Q50wPFZfKUejI3lq7oxOZEQBKUV9bjLOxzGDCrdE1
	tCVnJNrpSt1M5/rvpAN/SEcKOWo3gfY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02C961515;
	Tue, 11 Nov 2025 19:58:33 -0800 (PST)
Received: from [10.164.136.35] (unknown [10.164.136.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DD7B3F5A1;
	Tue, 11 Nov 2025 19:58:36 -0800 (PST)
Message-ID: <811bea18-30d0-446f-8840-d99698a6a9ba@arm.com>
Date: Wed, 12 Nov 2025 09:28:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
 baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
 <06096f8b-4da0-4b5c-af3c-fd8871437c16@linux.dev>
 <20251112034008.ojwghkko74psu65v@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251112034008.ojwghkko74psu65v@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 083CB180004
X-Rspamd-Server: rspam07
X-Stat-Signature: qp7q3w5byxdfepnsxh5uwfi5urdwin4b
X-Rspam-User: 
X-HE-Tag: 1762919921-288217
X-HE-Meta: U2FsdGVkX1/X/XTr3pAU7X6ou3UXKrleareBAXybiJ72NRspsEZWqjFg0M3ZupsWBWetYjAVFzmSLcXUIcSVG8+omACEGyME4d4oLvoDleb/iRpRfqQl/PhgeTRDknd8ZYSX0e9Cc6BjFVs8EItMOsx6ARhhksJOVY+WGgGG/RoDWD76iUKq3dy+ItIV/tFGcKVuS9+O7UTAcr7JeFGSu02m3UFZzhYo/h0Qikm11MglwxZ+rlbUx9UArdqYztA4uR0VtEUaKIFLQKCk4yc1vdnWyomwsvjyn4zuqNOxqLZnVR4D8uOSQ6Dj91LNheBnZXaK5pzRFyLaEBYf7n7725We80WwOCsWf5hcUYhMPP9C0XskCxvStmShsk9dzAi+j5xhwfEPvlShqdebBxKsbuCfYSXSnEM4k+1RqywDuzucPUcQyN1qTCIGWCECDsVu8PVDXqRjk3DkQp28HladzLWvOlJiZCLMch+flIOUgiyo+d/ngQbGleAZ+3xgPVo9GznHqjbEHooaODpy/pjn7Uq4eQm97aaeR3lPDoiDWlPdPdcu5YdEus7O/IO01sJh78O6WQVsahhDhzhySTaHIDr/kJkAtLP0EaEpeg/Sy+lCXPBLef00KIt7lZ40kfeplXr2tW25UbtaQLxwJG6R7iT+D4WSwmUSUnGi1u0kpunocPjwM4WQf+LFEQIVVyNsa+JsJictHFhtCRVfhkyI/taRBf3rhxfPVO1KYrgtSX65TfDqzGpJi/Kz0NYpLrZiYvBRfQ5IvsuLvYa9C+QBSFVsg50rhlAU7oLDmC1BUtu2S8LYo7I9zTyjUtZQ0vwwqEqMNInKcAWPHkf5XBFmSd39PYgYNoDKxXsx2mCMjS45eyzfPj4TVX5NPNvfVbfDQuQ03Hu/EFy5iYwa5iJXXk0i8dLO4Fc8KRGgVRpNv9ttCb85FQMKH2Tcwa8x31X/+41YHbuAUEunWt8CEOq
 moq+9oU2
 YdLiCECmJIvpL5gJFgDyM+p6D162WwdIELKCdy1g9LoI+U0f9vSzsKxk+fvRIqyVZVk754hp3DcReYjEGDa3CmUaAdb4LN6bnnt3youpokxpyrZe7/DkFNVMhgmvjyVh/xXtVrRrd4XuRK0jJtj+4Nm4oLkg9Q7DHIHTO+DTCPKcgvfObgzv621c1UBqNaKEYVIGc8uxLGvKLFVorNV8Cx2JKBFkFZF+di1YQL66lNKhepgtvbcf3v3iaeGdaEN8kqxRvVLdD/VyYLMftbEyndwtUtWSk6h+zRhPOKw9cdpZv0HKGkACVojBObg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/11/25 9:10 am, Wei Yang wrote:
> On Wed, Nov 12, 2025 at 10:37:06AM +0800, Lance Yang wrote:
>>
>> On 2025/11/12 10:00, Wei Yang wrote:
>>> SCAN_PMD_NONE means current pmd is empty, but we can still continue
>>> collapse next pmd range.
>> Right, bailing out of the whole MADV_COLLAPSE request just because
>> we encounter one empty PMD is too strict ...
>>
>> It makes sense to treat SCAN_PMD_NONE like the other whitelisted cases
>> (e.g., SCAN_PMD_NULL).
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> ---
>> LGTM.
>>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>
> Thanks for the review.
>
> I'm currently evaluating the use of SCAN_NULL versus SCAN_NONE. It seems their
> usage in the current code is intermixed, and I'm questioning if there's a
> strong, practical reason to maintain a distinction between these two states.
> Should they be unified?

There was some discussion about that in this thread:

https://lore.kernel.org/all/v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh/

There are some cleanups mentioned in the thread which you can try if you want :)




