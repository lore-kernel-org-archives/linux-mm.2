Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97659CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 05:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0254D6B0088; Mon, 12 Oct 2026 01:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17AC6B008A; Mon, 12 Oct 2026 01:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FF26B008C; Mon, 12 Oct 2026 01:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBAB56B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 01:38:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A765E8098C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:38:41 +0000 (UTC)
X-FDA: 85312869642.24.04AFE75
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9EA3540003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:38:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n3O4ceg4;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791783520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecbamoxcZLAwf1+klfQsdeSf4wl/5H2ZQebHZBs4bOA=;
	b=PIG1G9vrYHYQVdC/jRwBSSqNuBJ5BrUNHEvbrNISKDnw9sBlYhLResp+MdxRrHRvuWEKNq
	THiDV5EI56lUV54WUtKfz/GYktijsAd+6avKwn5s2yBrQ0p8PIXlIL2vKtVyxSIsXHgz1k
	67Xx+HMbohgLr/J2SONm81ed8FsUJNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791783520;
	b=IgFHZe93dIdPIX4lnq9UZuaYGgNJClGz+1GGd6TJeTvbiZT6FwJItqE7Rvek18z0kstk1c
	I2UeLA+aCZdXjqJEW6WK3fc2lj9aOsBs51GgejmosOCChzUqCpdcppekMu7jkjC6/K1VEf
	mm862Z+4z7EHmqUPHtsQ8AiASUk/NQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n3O4ceg4;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BCFA1A00;
	Sun, 11 Oct 2026 22:38:35 -0700 (PDT)
Received: from [10.164.148.108] (MacBook-Pro-3.blr.arm.com [10.164.148.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF6CA3F882;
	Sun, 11 Oct 2026 22:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791783518; bh=mh+QSAWOuJxqcV+GJ8VBkG+hUNx/Je04E3SQ7sUHC1o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n3O4ceg4v+A7OtL1DptykjrlXOQDcjts0lE8QZcl23PRddctLRdrjIBw1i76GaUcX
	 teXegmHnKi+2MQMG5XDhos0jfRvUvmZ4yD48o5TOrOBCaTv2Mik9Yy2LJp98XyJKx1
	 XwhfALwVNrddAbz5OLKDUEWaknQL8668PmzN0W1o=
Message-ID: <e2152674-e0af-4b07-9115-4668917171b1@arm.com>
Date: Mon, 12 Oct 2026 11:08:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PROTOTYPE] mm: reliable 1GB page allocation
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>
References: <20261004013657.03a63c4c@fangorn>
 <55adcc67-e545-4bf5-93ba-7e4180f1b523@arm.com>
 <003fdeb213ca0460c8681d4ae7baa562b337ed1a.camel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <003fdeb213ca0460c8681d4ae7baa562b337ed1a.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9EA3540003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rjitztqygepxqp183wc7wnz9kotofabf
X-HE-Tag: 1791783519-341032
X-HE-Meta: U2FsdGVkX1/ymwH+6F8ABB1TiiL2Q0pvhpA3+2OX805OTVdQ2N2pECgcYrvI6OiP+4jaPfEDf/rGZiacoAdKmZ9t6ZknX2gkNv2Wrf3ZKKIkCwEKq0TbZmmCfxLRTsxMswaNmnMtwlpbIqyv416Uu13i0AFcpI8NBw3U1gHEDEdCU+snLjGr8e8gblHOKGg6Y+e78W+Kvqrp7PeUwu6HDA4i/XIqZROZAMIPsW+f7s+dvBmXJfetgY0fs1Kaxb9keRijhaHtV0QZWiXejxRKcG4iRfPb80ApGWwiTWLWJvKBSsCUh6AugqiPl0XK7Qy/ZEquT78LZ+vZROEcHbPTu6yYQ25YwN4jPBkNzhDCa3aAw1w9xoKUXNn7wetzKHYDzaKdmiF6qql5LoIhTYMOOHXb4ArMtZvbIg3iBmGJEm537F/3zB2/yM8Fj8NLQygt/vq58HB/GXoyGrwZ7yzPcSPOAIkb7SvKq96FanIFu/ezw8SBD7s1ULqiO7DEvNh5zPVKPPxaI1Wuc4+kst3VH3FQYeL8QE+OduOFXJgeiuT9y9wTTJ64H+yXWqJrXFtW7eDobQdjXbkchFD9JP1Euw9dlDWN4rC/AmMxnu+SDfpu/8QSt4atL9b8O3mqGlq7dwAsG2Cj27NmrbSV+d9FcA+LharQJc7wMWfWZtCSLXzWeIMu21hF5Qrwb7Gs26mbQL5yWmBxLOG0AKxEdXJzMBtOPUscX2Jc4b1Xwx9K5+siQdwG7HwqJ3vCMYoysqaPYmrurOGHGHo5QaoRH9hjBo/NrVoOPOt5Mb8592E1RIgV4+ZGYm1L3N6bZNO7fxNuh1wkOmIzQBsp06IETTVv7nrm/iSqgUgC6sPJkfR/ChDGE1QBVNcMxR8Ib9MJ96I4x0K1J6as9LYa8yP6/RGiFTg26oxPtuMqSQmG7z3G+KvqZXl0i3UpKs82bn9xPZzFYTOJKBe/mSDI1jul0Eu
 O7xjYoNJ
 FYiwpcH3MRmvnHlUMDYVF/pNLUbD6AxH/NEN4OysXe7Hv9AzvN5r+zdze1e5kofoPXuP9PTnwT4pkVF/6B8qZFN6diQVmnjHDzTmBJE8+Z7xAUs6C0P4J6yO7EUhntiAttS7iaDEm6gus1tXp5/qd2DlwGkjFTV6YmeM0C19/rukGx27RM5SwSTZTs7U3vD3VUUArVNz9x4y+d2Smb4yl3xR7XsSDUZl9Fg4NXzdP3LlsppY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/10/26 3:14 am, Rik van Riel wrote:
> On Sun, 2026-10-11 at 22:58 +0530, Dev Jain wrote:
>>
>>
>> On 04/10/26 11:06 am, Rik van Riel wrote:
>>>
>>> When the kernel free lists run low, the slow path moves pages and
>>> page
>>> blocks from inside mixed gigablocks onto the kernel free lists.
>>
>> Did you consider a design to introduce MIGRATE_POLLUTED: simply
>> have another migratetype which stores polluted pageblocks.
>> This idea can work in general, not sure how relevant it is
>> for gigablock concept.
>>
> Don't the first half a dozen or so changes from this
> prototype do that already?
> 
> What differences do you have in mind?

Sorry, it was just a drive-by comment. I will eventually try to
review your design document.


> 
> 


