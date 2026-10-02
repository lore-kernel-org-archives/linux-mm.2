Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B51CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 07:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2746B008C; Fri,  2 Oct 2026 03:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3556B0092; Fri,  2 Oct 2026 03:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392A06B0093; Fri,  2 Oct 2026 03:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 138B36B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:56:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98388160633
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:56:47 +0000 (UTC)
X-FDA: 85276929654.13.DBFE7BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B7E511C000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:56:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ91VK2+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790927805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEkWEbF0eWef2VJO7bWrlTNl1U8dJ/sz3+7inKUMUkw=;
	b=b9I/O5PboX/83maNdd5IOxCsOivEauaQUWk3g9oBslMMk8WQwi3LyNT3p8RY29GdBpc4Gv
	yI3CG3/hd1X3/zmnhsnpqn+h59quit/vCt3lQV+S7TdTTJvI9QtwkHNOkwuIr5lDumSjQJ
	km64Ld7FBjR+Xrb4MWY3J1bhozEChP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790927805;
	b=14EOtN1xNPHw4TT+qbBuqNjgzFm8IEdxw64fJE3g/PuTOyDIYsTZ9aOVVq3oljnUp4idau
	DDXFhQtwGIB7SHOml/LOdCUK4yMYM/JiuDn26W3uXtaiyWv2HsYpNOlBCfkOf7UqfUtXJp
	jObFVAxSyMIOYLfoI+6FV/vacLF5LhQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ91VK2+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 942EA4393E;
	Fri,  2 Oct 2026 07:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD91F000FF;
	Fri,  2 Oct 2026 07:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790927804;
	bh=CEkWEbF0eWef2VJO7bWrlTNl1U8dJ/sz3+7inKUMUkw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EQ91VK2+BapVfmlNmGOB3cBrGS0uYiybL6rZ+zR2N7XSMIyvRWsYaK1X6j1d0ksJJ
	 WzFtg42cKFOm6Iz0X5D44fWVtsaCvVaBxDfnKwKRcNHhx9mhcA6UWOsEsQOeKqUpOp
	 xiQm/EshPiBxqnjjYipQ31j+o0YJjTdAoJAc0ic+SsTk5LRCBmrqsLgJ+TM2bMgixC
	 37Wx9BliiaJhDNUYuLoAStPxjVINOzmLHXTi0vNoPpZEC7J8Ch6W5Yf5oNaVXeWXQm
	 aryC884o39Ko8E6iAhQBiKJZKgvPaqvf5uDewF0RqF4lA1LLcE5VMaXZlv+rI1cEeG
	 smlxu332w9sMA==
Message-ID: <44d15437-6aae-4d7c-bfd4-296276583826@kernel.org>
Date: Fri, 2 Oct 2026 09:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, Li Zhe <lizhe.67@bytedance.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
 <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
 <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
 <ar5eC22VfSFlMw3W@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ar5eC22VfSFlMw3W@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7E511C000A
X-Stat-Signature: orhyp8xrbzn8qay8g3ts55dm3ibr4uyt
X-HE-Tag: 1790927805-835680
X-HE-Meta: U2FsdGVkX1/dejU2vfffVKzQjFB1ckNrg40VOa+oDwcZK5rb57bF5eWbM3mL5XNjW7dKIWo+GkWHF77Bq9LxgApcx/oJitVQQA8Yhm0UNQOAyMoZ95wjVjAtJuLC82RkSVklMS8oF7NywKw9wCJmFU0kFFbkku1egnMRSSyAMD+o9rODAoqaCrVUDyKztfHa8iWrmeP87ZbhkkO6xf84bTLNOiJEDGLeU4u3rQYz8hQQgajsFASK95KcXxWkwZulK9jhr4mU8U6YtXL1tcyb/RrkyvIZtJXzH7T/T97RLoQerqGBZfxAGP3svEWE406s5i+RAE6jnnjRWQOZ+GrHP3thjwtaT877d8swfZjNcNf16RZlRjJnGfDaUUXRdVlwspePR3LTWML8ZEo8BV3ajlC2TzGT/53Z8AXxyiso0Y1ytBV/qD9yKwctjYsgEX7wJqVT/tpqm1Wlt4DMGwvCu/hpu8enRjk58ZWcDE3RvBXw81ctx5UGjOLHIc9Qa4pyegc96AG7ukJf68qRjC05KJDjET9p8f3PXC/xgqo/Mt8CbgCvy4AHgWBVf3Abr9TuXYf/OwGuoKhGmxm7AfR1i7sDUGYRI7uijTtDL53+Fma3FBxJc1++ooNhJDUxWFGrFiV0LsCDnrZw6pBYJ4WX/oBoTAh9AziSKqvIskcN/vaT3zXocX4cCyOSQ5oPbFUHeSDZJ01F18TwSSz6VclCBFUIQhReOlGTR9O4Rifq+QAf3w8DCUomhvP/Vz5MOS4UbkPtbFk/9hWxvhNanjnFRcedwOTsQGoJoV2snkLssPwOVBB0NIinXpaQsdQVjAjtZwmsTms6IBemMy8K4E4Zx76DjRxkEendHS+4EaizZ1MgpGYoEhFRMJ0ly2jK32vKYSedIsdVLcNandDyvEOJUqfMdp8sRn0NUvHmgn9k8XC2jko0iMLsHykpUpvCCpidzT/1In5NXNpKjr3jKB7
 1LC5lboW
 Jt+/LnuOdA9KoJw8LMl2p2eG/Y0fKI4ZLipDRAzznj7bmpGppX1nGfDzc/MKiOvjurFgptuGK3ifzy88dB3EuZoD6qD2EfAdJmb/Tn80tSbP0V/hApO8BqcOJfzG/iDEkjE6GAC3QWJWNzPE3imjb/Or6jDDiX9HR6OidjvdVIkiI6HP9w9xCnc6mp6SO3pB0XTA/6j6aE/vUcamjdyuGnxiBhdifllcKKMhQ5nHYxN/J2a8G/DLUAq3agq22RANCcgU0VJgErleQmz1TYpHyOafojpbbnpNRwCNh++SGjtAJAMSBlpoTsKgW+MfNlOqZMt/BUstUuJgus71Pi8dzOxBlx4waTxAaBWbGSTE+uILVbsBzX148f15gCm3vIxJMHDpX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 15:26, Gregory Price wrote:
> On Thu, Oct 01, 2026 at 12:54:22PM +0200, David Hildenbrand (Arm) wrote:
>>> If this is a initial-fill problem, can userspace set weighted interleave
>>> initially? The program or harness can observe memory usage of the program
>>> or related NUMA nodes and switch the policy to numa balancing via
>>> set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
>>> is met?
>>
>> You mean: use the weighted policy initially and then switch to a NUMA-balancing
>> one which doesn't involve the weights anymore?
>>
>> That makes more sense to me. Although I struggle to see why an effectively
>> "let's put random memory on slow and others at hot" is a good starting point to
>> later let if be fixed up by actual balancing/tiering.
>>
>> It all sounds a bit hackish. :)
>>
> 
> It is a bit of a non-combo (Nonbo).  You're using weighted interleave
> with the intent of spreading out the bandwidth utilization (and maybe to
> offset some reclaim behavior? *shrug*) but then undo all the placement
> with tiering.

I can understand the "random initial placement will help if you cross your
fingers" argument from Zi.

But then the question really is whether the app should then change the policy
after the initial placement was done and the weighted stuff no longer makes a
lot of sense.

> 
> But, in defense of the hackery - I have seen strategies like this work
> to optimize startup times and then let tiering optimize runtime.  Phased
> execution gets funky like that.

No doubt about that.

-- 
Cheers,

David

