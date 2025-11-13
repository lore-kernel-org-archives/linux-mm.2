Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB52ECD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8688E0008; Thu, 13 Nov 2025 14:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FED8E0002; Thu, 13 Nov 2025 14:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCDDB8E0008; Thu, 13 Nov 2025 14:07:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC38B8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:07:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88A8412E72D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:07:35 +0000 (UTC)
X-FDA: 84106517670.02.E442BBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B864B14000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:07:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FP8Qapek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763060853; a=rsa-sha256;
	cv=none;
	b=KrM4OhI8M9iAQrv8nF82zd4kiTBMHpV11ylWtfoxcOBw8vDoY2iLZDobvenA0nzbMN/fEQ
	aF1jW9eqo9nFkxAY5AjG3PEaF0zVbEPjRzox87nmPvg4guOLTjGusoxfLCbdwsTC54I9zQ
	9j5WhE4PzR0PBMF5egwN+2J86xUNL78=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FP8Qapek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763060853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=It279Lg1L5jnAf5Tou3OhyA0Bikk9hZzrOaWw/I28VQ=;
	b=3a26JlFUophm2NOCkB19mrjoagblSRi8Y6Qgl9/UbSYFBojNPrinLNP0/QpEKZiN28mmj1
	AaDxT8kVMCIteklfAtb0GxrI3qhLIqiOOw3LuwQgFBeR1FHrL0DaXuT9MVWSf8tLEp3xis
	7N6QBCGZ+Suh9i/rAxXjsdj5LGnLACo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87D51445E5;
	Thu, 13 Nov 2025 19:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB7AC4CEF8;
	Thu, 13 Nov 2025 19:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763060852;
	bh=Pl20MoOorbHpmnhcuREwk6NlJ3n1QYtDiM7bqFcyN4g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FP8QapeksEoDY29Z9X3Ik52OE7/7p/1qL57UQpNU4d24lahTRqcfuVqoIjmsWt7Ba
	 IRfGKYdS8pIA2Mi2ppXxC+R4LEu6vzhPGwmKGuCCJjLq9G3A8EKCMgX48/f7IwkEv4
	 bsKVeR7qQgx8KOv3JNNRNqxbOC8r+HpKzwQcl+14Bhd1B8hV5fKhQ1BKtKWHp9b71A
	 bk3v5ziNmRLCuRHLIdYZH9bqGxfeilZw4aJBcuNy6HHSFOD8Xif9Jv2UBm7GtWi6V+
	 zdYK2aNupbePP1GYauWi3fno0QKOKk47tDL12kSAVETC0fjPO9lbyxIEXj4SjIMhAv
	 y3zPTSTvhf5GQ==
Message-ID: <75d2254e-51ea-4e59-b706-86664e6c4bab@kernel.org>
Date: Thu, 13 Nov 2025 20:07:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
To: Zi Yan <ziy@nvidia.com>, Francois Dugast <francois.dugast@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <aRX62SR8NLps2NWH@fdugast-desk>
 <8ffcbd7a-511e-499b-919d-0c56ccc3c63b@lucifer.local>
 <389A23ED-106B-413C-B13F-BB0F1E90B6C8@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <389A23ED-106B-413C-B13F-BB0F1E90B6C8@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B864B14000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 134c8u9f84ojf1e5o96bwsc8hub5bfai
X-Rspam-User: 
X-HE-Tag: 1763060853-593699
X-HE-Meta: U2FsdGVkX19f8LbzDMFBurJqUpxSZcCIiwTMP4m1oisDEUbeBN+6sQhmhuUJQ3IogwgBkB6wZEpLCXJKdQkBw/GQ9M8cv/Azc7QJkbkvYofdAnAplcPrgv2Cc5yETLXIcZVnIQsN+NuOGYCGeHy9RGWmCjoDC3Ddp0vJhMmhV0myWxOvooAiwMTXeMoa1Hfge29GExkiTuinDZq7CgK4vChBjn1Csu7NuPGL/bFXlV3HpDJuVeBTZqBUcOuwpxqETVhN8Q7R7tGgA1jM5pp7MwQ2jOM6r7D/tgpUOxKtXAI8Z2tAswiocRC7tUVV+NJ9zto0n3y3dcIvrUcg8RwMo+g6IuWgqCKcWEaeHDoFjBmygpU2p/DLhyFh3nLegGOjO0VR2Lj31/bVlPGVXpCxihqEeJCndX/Kihvm1g9G6x8OzxBIqQvYmfSQxWmZ7DvpmVCR9obrlgjzHPb5eVT39ibGqD96XzVX5m/sxb5hdORPUb4K6KXqaw93q1ExK7ERqXde/761/RWpUR5KseeR93fR9wdrV5baUV0yhq83xV3LISbmT1nBIZn1jQdjUAU2FkkPUAk3N6jKOU2Qkgl9ra3hFtcDjX0F7RiKun5/9bwvgMny3GKkC4xuc+S5EIjNQMx8QPbbv7214fQp4Vok9JNHMIHyjfuB1AzJHXleYehOaRELZiEllt+iWJioNOmycUTyujIF/C6NY0/1MzEiuoRQ3yo90pesgebTcae05g+7WJhwX9cH5IPe1b48pELH4FwX31kmS5k9gZE1d/7Ara4JIj1Iw94KmRjkBFTsnxrvzoGJRE1dsPFAhnnBRrM/pJEJkbgk7azguxRUu/kzzW50h4BEls/g0PYgKNemyh7FcCLv0WonBeGxgs7EjBUXJCz1rkjPtkNSHulypdModCXovjMFOzsM+zJY5zhRAiMQ+Ly3hK0U+49e2w/x46Y7g4knNzo4UutW8E4/tXh
 BsgscvZL
 7uDsxDjSyMdinirahwOGsKzmoa+s93PMq7obND4tYB41L7RL5l/uyrcij5gAY5lU/uN200y5SxPwOlGNPuDPITUyMbcRELFc2MaJYN/UkdycSKqpnvEgFX28KmQoY53pdEhHWq0AGvEhdVIrZ0Aw/7W4BgJycoRfMlbqhnq6wPcCRzXdJbW8wkm9w8RGgRw4BASmgbZy5fVdrHfOWsP4DGX3EebhgNATPItl697XS6CX0KpfBPBmST0RKX9+hQkQ6p7Ok7pIfyYk+UB7RWYpwdkdfIn0/YUOYnTrsHmF9271aOozIHrXXEwUL4K1uV3fYBsa6WYSua/DcrWqmH5heyuCa0ND65Wc3l4Iny2cjzdXUcBk/aeogkYPYTU1cfWITAG9l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 17:24, Zi Yan wrote:
> On 13 Nov 2025, at 11:02, Lorenzo Stoakes wrote:
> 
>> On Thu, Nov 13, 2025 at 04:36:01PM +0100, Francois Dugast wrote:
>>> Hi Balbir,
>>>
>>> On Wed, Nov 12, 2025 at 03:46:33PM +1100, Balbir Singh wrote:
>>>> Unmapped was added as a parameter to __folio_split() and related
>>>> call sites to support splitting of folios already in the midst
>>>> of a migration. This special case arose for device private folio
>>>> migration since during migration there could be a disconnect between
>>>> source and destination on the folio size.
>>>>
>>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>>> This in turn removes the special casing introduced by the unmapped
>>>> parameter in __folio_split().
>>>
>>> Such a helper would be needed in drm_pagemap_migrate_to_devmem when
>>> reallocating a device folio to smaller pages.
>>>
>>> Could we export it (EXPORT_SYMBOL)?
> 
> drm_pagemap_migrate_to_devmem() is a function defined in tree, you
> just need to include huge_mm.h to use split_unmapped_folio_to_order().
> Why do you need to export split_unmapped_folio_to_order()?

I guess because DRM_GPUSVM is tristate, so can be built as a module. 
IIUC, that's where drm_pagemap_migrate_to_devmem() ends up.

> 
>>
>> As a rule we don't export things from core mm. And certainly not to non-GPL
>> modules.
>>
>> Unless David feels very differently or there's some enormously compelling
>> reason for it I'd really rather we didn't.

We'd need a pretty good reason to go down that path indeed :)

-- 
Cheers

David

