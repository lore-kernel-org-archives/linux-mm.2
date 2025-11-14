Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B950BCE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:36:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225158E0036; Fri, 14 Nov 2025 14:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCFA8E0021; Fri, 14 Nov 2025 14:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140EA8E0036; Fri, 14 Nov 2025 14:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0520B8E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:36:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C223559000
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:36:29 +0000 (UTC)
X-FDA: 84110219298.26.63FB996
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2F0910001C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:36:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mU8IFYUW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763148988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aRMdvr4zHm8/bIJ0yalnON53KrH/D1M+CjK6xSsk42Q=;
	b=vSU/aW5D1B0ToUbWbmpmV22WftVIp/gPh/rcZyxLIExSTgNS86jQKBroML4mTvHYUsVH4S
	cEewtboDtlDf+HfP8gsuKk1LLZO/xkfJfv8SwmXeEm5YACk9ISua8s2ZLFbBKJejm9b372
	TCt/9eXR9Qat1NgwkZg7e9JVpKa/z4E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763148988; a=rsa-sha256;
	cv=none;
	b=pTEI11q9lEui6wHvEkyvicKr4DnSAXGz6lW7+m4u5j5wW4qYagZVgjYk2rDGGBHSw+PQHj
	zbFI8yGvGq5mHIuQlZxGThn6AsqT+At6qSWCUc3bdHS6UC7L5wbrOQVkyWk7QuvqHZINgB
	xuU8vM/FL+bc4VUJDr+fT13D1MBJGgg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mU8IFYUW;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F0A8406ED;
	Fri, 14 Nov 2025 19:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21F1C4CEF1;
	Fri, 14 Nov 2025 19:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148986;
	bh=rui8hDHDCQYjQDpuio04Hq62leR8+4upRjLduKpcWos=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mU8IFYUWw07F/uQC28N2CLFMhcPB/IHxYQB3lR0HI9pQer2Cwc+f7NX1a3H26Bkd4
	 B2X34MFP5qGNEVNrfiyqx3mItOigr5bco2B+rTSX2FyBQY+PpgWvPKoFI2/KYmsXdt
	 baJv7SMcwbqk8aLYEI/aPV4DZTTaBV23ihLqDQ1WeZSvBwm37s/cmOr6Rk1Sn4kkDr
	 c7BDszuGwvFwIPQ5/jQN3bD1z9yEfVimW1HWkduU7oBqKuSrbWOcjOe5qj2Iu1m4vD
	 CKKUq5ITwnkKYD1eDznzMH65TVBDKZUm0xL5rbYZ/ryhmySjCmAYlv+NAavRYQ5xAp
	 7hEBYloe69PHg==
Message-ID: <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
Date: Fri, 14 Nov 2025 20:36:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: willy@infradead.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <20251114150310.eua55tcgxl4mgdnp@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114150310.eua55tcgxl4mgdnp@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F2F0910001C
X-Stat-Signature: 3kgn3ey68c4fc5ior3wnops11bahahtw
X-HE-Tag: 1763148987-50909
X-HE-Meta: U2FsdGVkX1/VHjh/IpkRFwCZb3b1aWeqr8gxCmGmmoJ6dFS05FeHzFJVTCTewRtrrrwsZI7yLSraWate0zYcXgrbbIj7Yw4z7PlbNaO1gilgOzDIDljXJSG8/JbS67/1GeorysgTtv7FBTQf3JpeVLKefHARVGQuvK7MgHB5x9AfWp+0CXaLD+ozpUtMNb6F8YlKZvYVRagqCsHiH65l9O6usXkn1wHLL3QQSXU4zVYHy65fboXo4U7fNrg3Gxv1aVfGAwQGLeImrbHJep+/SFwNTs1Gi0tcPdNrl0s+tMs+NjAlp6uhS5jmLJ/tQj88QUNNh68q7ai1Qb657rtQYv+1ccNhgMPFFifTNwuIHRwJtJ3r3nauNVYNHM71ffftlXYxQLUJAXYO/na61jJYmsmsKCD357DWbGDrEzMlQM34sn5+VMxMvfuWn9KVdrjq0hjZ2Ei+g9Ok+Hco3OuYvbp6oe41ikvkgXa8JzZCA3FBxdGxLqpq48wRfM22tMZqyAlHPM8pCXAC19DDcD+TMWczoh0naz0G3jTIjYUGTrtfF8Njx6n8b8z24qxWq376QRbn4sMIC/yjca2RzlB6T4YHGJhEzQOUxcTyVXjUqtcONKc57vAvzEBoCxMPieEYYOSpoAayHp2mApX94BEwg+1Yw8bPnQ+M4dRCrSZ612OFd6gmOp2FuTIN64XEMSwIt7nOapxsHPsKVQJErYNt9Caw9eSpkzQ5QrLQt6ujDGVOfgR0twvQg9mbyxlaYKnQSgDPq6LqNcyCUNpOnv5BQEDEq24+U3tAlMWwgfDKvoJNPMkRAwDT2qcQgIDUIhp3CTj73sVaeQsClSfC7DL89jNytWVpxCKF2B2VOcZ+gVSunLiNfQXjBFjxF/V/1xNOFdjF3GOpu25dBykXHMYD9vLfjfar0kxXBJh8zUX9bCoTuv25bSwWDgEJvIcJxKg1AJO+7WNPd26ZRnaFb7d
 nh44zV8X
 1Mp6r2nHzetk3SZZ+s/QFmlE1IjUHz4pvP92x81tinjvi6b2KXzzXtDzNh9wPFcXLMsnF2vykwL+ndtsfNJOQ3mYUP5tsCZn0W9E1/c+XcR9L2187ChOV1PduNVh1pY50J680TyRIjSgx6isrl4JC5Q4ZZNqF8tBi6brZj6eYgOI0Q+UHDPtZf/S+iI1ClU3pdtpHnMGPgArx2JXe7h/VLxs0F+FfowkIDlvoV+AgrwPWC5DicxP/Tp4R+VfOoomhKLvEVWkrmR4sWP0/GomTNBEHXiF7BsCBhS1U7Wt04mq9JbN7hkMgMQkBTusycR+H3BWexvikNKZ8rDn5NBWBjvuzMsUlF3qWBy9rglzuB+tdJKzkwr0vZfi8EiKVYDg5nwNg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 16:03, Wei Yang wrote:
> On Fri, Nov 14, 2025 at 09:49:34AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 14.11.25 08:57, Wei Yang wrote:
>>> The primary goal of the folio_split_supported() function is to validate
>>> whether a folio is suitable for splitting and to bail out early if it is
>>> not.
>>>
>>> Currently, some order-related checks are scattered throughout the
>>> calling code rather than being centralized in folio_split_supported().
>>>
>>> This commit moves all remaining order-related validation logic into
>>> folio_split_supported(). This consolidation ensures that the function
>>> serves its intended purpose as a single point of failure and improves
>>> the clarity and maintainability of the surrounding code.
>>
>> Combining the EINVAL handling sounds reasonable.
>>
> 
> You mean:
> 
> This commit combines the EINVAL handling logic into folio_split_supported().
> This consolidation ... ?

It was not a suggestion to change, it was rather only a comment from my 
side :)

[...]

>>
>> The mapping_max_folio_order() check is new now. What is the default value of that? Is it always initialized properly?
>>
> 
> Not sure "is new now" means what?
> 
> Original check use mapping_large_folio_support() which calls
> mapping_max_folio_order(). It looks not new to me.

Right, but we did not actually care about the exact value.

IOW, we didn't check for order <= mapping_max_folio_order() before.

SO I'm just curious if that is universally fine.

-- 
Cheers

David

