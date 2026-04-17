Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E8EF43680
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 08:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C566B00B0; Fri, 17 Apr 2026 04:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5F16B00B1; Fri, 17 Apr 2026 04:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D7F6B00B2; Fri, 17 Apr 2026 04:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41D976B00B0
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:55:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CC038CD43
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:55:57 +0000 (UTC)
X-FDA: 84667440354.03.70AE741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id C64EA40007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:55:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcHQJo1n;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776416155; a=rsa-sha256;
	cv=none;
	b=gY42roDjsfGKNTSbpZ91fpD45+gRVKa2ZhqHKSQzuMXCFoAgXOaAxKPQqSSRafP/P6dFyp
	snKWJAW2AtWO87IpItCUapUlX7tlZIKJ1fxrcY7o9Mm5zD3CHuK8sq17M3+jsdHbLONClO
	43BGWt/EzOX3CICojpEMuZd1m7DEMgw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcHQJo1n;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776416155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzF1Mac+dRMVtXrSxsMZiTCJWQW+Iig0RfpjmrikiDg=;
	b=DYwKioujC6AoaRM7jEki3V5yvr1BnY6kB0FQ4Y0e65f28JVosl0bkg2O39TyEfDble6fHA
	8Obk6P9wPCDHype7EuAYn3b9pR8MUCBqTScSBvqe00nMcKmrzibvQgMMJMTP/V5CiGNeW0
	wFrVr8PKGvvG19761YoH5aq5Rov+F8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AE5960128;
	Fri, 17 Apr 2026 08:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CBBC19425;
	Fri, 17 Apr 2026 08:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776416154;
	bh=5cd38qOiEIyykacoE8rFcS3eTCpor2N3/arRUrsPyQA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KcHQJo1nes/1+iKDfsibdtEC8iQ6iH+dBg9bfefk/Oz7MftUWgI0uTHi3HV4ziZNg
	 XkiUCA5aWsnN5u1bM9SoH0Ers7DtWNMVMReb3ls7lwMOx9FLH9Obfr4qaw+D4rMSNc
	 hBh/qY0HYoR2wpL5wrD/SByyGTlQ6sw+fHWvQX4fhlhvwQu0GVv/rnQocBed4sHYij
	 DGHnme2qRlxZaOD1/EU13ucnVE+SgALZ/5Ip2UiF2d4/1gVdrtnA8WFMCxDPAi3Q+B
	 snRRqS+FddKQdRZY7dUd+MykIX9OHRdumcnWNtB793wsppvR6dg2klBSDLIULU5BZf
	 itvlbwdC8jcCQ==
Message-ID: <82193ab8-e6f6-4664-8b4f-e30d280d8b1c@kernel.org>
Date: Fri, 17 Apr 2026 10:55:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
To: SeongJae Park <sj@kernel.org>
Cc: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260416235252.58831-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260416235252.58831-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C64EA40007
X-Stat-Signature: sfgwbdguezi8kyczfpbu8orcmqgpdn36
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776416155-271571
X-HE-Meta: U2FsdGVkX19CpDt1U0Xh8wKw8XS+Xuwoo4+ZWmZilb4RSvE4pRfoBQiOv2Zr809Al2zETRVVrExQtId06jqce60DgxzAN5u+SDMfMbMmiHbNYYRtUcfJzYqKIwtq8xYc/Vl4n8thd1MFNFtHcdYSvUBn+Ab9otpR3cV19UeyTa8hMf0nsissC/04nWN5lla+K7m5B3udDS2cFNGTuNLSQVglN7cDiP5ck7lSd+up5TXdHhOmCzm7JzM9xrgdYW6muQA6Del3c+gAfOgwAeFKdc6ucvDr5UVwKBGSsYxa2qzqk/1QJV2VOLim3pLcFII6YVtQutdkjn3Ln4BkHz9Jt+31E1Rff30/U9DCW/QZMGafhDnG0QHuIPWsAdsF2nmbU3h8aEcxAiacOwgvoZ/CLZ78OGV5uPO/b4wTJnIooYP1jnqCmfkduuw7S0pCt7JseXoWv0s0PlpP3TJ6CT9D4fjurn3QHyV+/yLQmq+XrVDUt76VupuSZHOUxOszh79ST1+TWBdfJbS7rhR7pxJJsia+ZVFy/k1jmjXHlxgeGuBVCu0x3FTWWBa2Nh1HYOYZ+MeOkQBncWyZ49AtBPKAsJTnXLuROG9lyLFbXrIkUw1P3ogemkXxRNuHQG7oTQdZ/ylJHS3I+RfD+cLhrD8VigLEQL5Ky5SNFlMv8FiyR7Prl8hoR73j7zan1NlHWy59lnTUibZe878YqBEQCaH9elUUuT+eUikT4lB4j/fCKcH0a4HyBl0EbQDHILJT/e9AIbkU8jyhqFTBZWLXJT1NVZmvMuui58+yiB9wkaEwgpM1QGoxkK7KP7CtoOZGIW5J3csKNYgtawvKj1Y4DfR2CfdsWnLcPwu0vyeeYc7b988j9t1o3w+4JV1YftG1TMfijp33UIuqsAWvtK1W+6+mgrXa5UxbkIVtlFlptalxGRB1lFOPh4fxcgKfG8dCCRgmYFBw83X5X9IXvdrqUFd
 zFrZANB6
 Hjf+2XyaE245Xjme5z3FeV/QXzZWNVHxVLL1azQSC4MNfCA/vtzjq7pwnfocm/5/yJ7S79zXpkSuVkent/Mjx9/5zInIBw/GcsQoRRLKXv9RsOekioh3ps2PCcy4hfoN7VYFSIPehURM9DbpqSUyBd+me1JXx9dLPfnkKnxcFl/B3/nwST08MBbtNEkQAirvL4NolJDhxyYMrkeLBVp/YCMDeuNph0B4xCvmN5iRysySeDrSHv20M8CZlOHTWr0xek4lo1THgmA42mNPSMkDb3byKU7PbPjUXzOJTY62Gu2EA/NsuG9v28wVTyiTyqbBOyzBZA2CpJTdI3lhRTlwooeMp7xP21QyZIU3prshhmr+bQzt293Lv+kFXXoCmji4eFM5dOzAmtDBb+VlgHrzfwl2Zjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 01:52, SeongJae Park wrote:
> On Thu, 16 Apr 2026 21:44:15 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 4/14/26 16:13, Sunny Patel wrote:
> [...]
>>> @@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  	if (userfaultfd_missing(vma))
>>>  		goto unlock_abort;
>>>  
>>> -	if (!pmd_none(*pmdp)) {
>>> +	if (pmd_present(*pmdp)) {
>>>  		if (!is_huge_zero_pmd(*pmdp))
>>>  			goto unlock_abort;
>>>  		flush = true;
>>> -	} else if (!pmd_none(*pmdp))
>>> +	} else if (!pmd_none(*pmdp)) {
>>>  		goto unlock_abort;
>>> +	}
>>>  
>>>  	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>>>  	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
>>
>> is_huge_zero_pmd() checks pmd_present(), so we didn't have a bug before.
>>
>> We could also do:
>>
>> if (is_huge_zero_pmd(*pmdp)) {
>> 	flush = true;
>> } else if (!pmd_none(*pmdp)) {
>> 	goto unlock_abort;
>> }
> 
> Then we could even further remove the braces and reduce one more line, nice!

Indeed :)

-- 
Cheers,

David

