Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FE9C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099586B0095; Wed,  9 Sep 2026 06:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070A86B0096; Wed,  9 Sep 2026 06:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA17B6B0098; Wed,  9 Sep 2026 06:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3EA76B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:28:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F25C016017F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:28:45 +0000 (UTC)
X-FDA: 85193850210.16.420B437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4FF8E140003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:28:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kleZA+60;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60Fn9vMhQz6j6ntR/n7XOI7vJwXbXBwP3B0Uhh6u4UA=;
	b=vTFhPDSB2nJ7O+olpd3GQu5n0MLy8AaRy+WAKgDfhHYeT5nxnmN0RWJsgH/jwSzB5rrQyp
	QObGaJOIQCcBR3LOJ3s9uk84Ld9GejuxC7c4JPHKRmqMcqpe2AYaUls3tVOktq3qQ+qvSf
	DZdzePhb0VL8nbLJ6v4Iln/I+Pb76NI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kleZA+60;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949724;
	b=aluEZS3eBDGiyrFKMiUmSfeh4AIa48hIQEduboS2dXHHT78kRTS6jctxxEuMJ0/LGL+8Bl
	2snuRnYql6TtQjgnnp/T6+2exNDWp3iYhI321IaeY44NhsD1YsgJ70WPLpx1sQlKEKp1kd
	Ry4hTEhLCRzFKrHwd7dpt0NcZ+xGBpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5906601FE;
	Wed,  9 Sep 2026 10:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB001F00A3A;
	Wed,  9 Sep 2026 10:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788949723;
	bh=60Fn9vMhQz6j6ntR/n7XOI7vJwXbXBwP3B0Uhh6u4UA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kleZA+60Lv1tfMbYFJryHNYaxLvlrFE2+5CgNbMl9BGqJAtpLWeJK14WrfabM7HgB
	 jKR3YR2lUmigxbTGGVo+xzupsc0LiNpO/q7mJuTEfPnt290ils3CF9HVcMeoXTYNdx
	 XnjfsTVL4mxfeUk9lFPmSVOzUeOMbaFWdj4Q7Dco5LVTWtutGUKyYWuSKUX5IcSHXk
	 1ziRbbjHSpqnDANaIwOf3/jrb8hP42S+t0OCol2OoLhW9VdnwLTYliwoInXkCavkJU
	 9XndRQymonbcrswFomGGDHqDGULXj/10mx5rDVkKq4WvbRk9cDqmNb1xe7VGxJb68n
	 xrVrMzli4FCcg==
Message-ID: <b8e23456-00af-4097-a769-210a087d2b90@kernel.org>
Date: Wed, 9 Sep 2026 12:28:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "zhen.ni" <zhen.ni@easystack.cn>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907082620.2083838-1-zhen.ni@easystack.cn>
 <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
 <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4FF8E140003
X-Stat-Signature: mpg1szadqk7twjb7tx9kwg3crzjqxpm3
X-Rspam-User: 
X-HE-Tag: 1788949724-242132
X-HE-Meta: U2FsdGVkX187oFdFsuZQIt5X6N7+OF1Q7CWt8Kh9Ekk0r/fFsRkztkBtWULqpFBP1EKXXzBCyAVpvVqt6xR6xFbtIXCB93125oDau56i6VOw6yr6JyHnkvt+A5R2pGQyjrZuWPBuE3tKuBBbY5nPP79vNnE/uYz0DsH7wuoPput8oa6lgqQsOuTDORzZtS2lhXWQvuoUzhrtTFDNLBA0WjLtz0vmigjdoRG+jCByuC6h7WgAGpFbj58ypLRUZrKGTa2AVDpwXXv8aC/xQs7vYkwW8wbHaLVcxzfxCxQ3L/Y4OtEmeaMnshO19zxPmlnMt88udLlqerbSPXRGdDPOx1xTZWta4Mr+MTDPrbW2EQh2DTYvKoHHu84FhEzGGoxvjIr1XTOnYLHN4c5FBFEs/M07zH/X57kftRGtYgNEZL/7Yjbs3nje1XiHZnI2TSWodQs9yWA2zSQ88mgQh18wIgZvzsWGDMtZMFzM5oTTBiQD5EJS8OFUVpO8teMkL68xG+KcN1b3pj8wzGJVdJRazGE/k9+cjyB937zfR8OTkCqvucpd+uRS4kmplPy4YSIwAD0t2S2xxOgN16MTTixOSwyqYORyqaziZkEO91OiCqoYLOsZHJC215qeOxX1Md/TBcQVUEYc8A6nJGhqXclQDqq59GVTrnuSBhDFlY76+SHc0sJNJwVC6++QsC6b2QKmW2RDhRNdMvab8buhdJXoGkrvppWSOdXROGqYMX13NE1WKlP4Al7L1/xF2bt/Ri3nMsA+qFDivKQ4AQpJuoaFkteQy1lUr1y4LACUhnDuK534Vb7nO4S5DI6Q4RDvMEdQA1oeDVv1sO5Kfy/Rj7rgU23V8t4UDbfA7qTaWnGYlnjBSImKc5vnCSx6Bw10vMq7y/Wy1hUv2gNL6tL+IzM3togon0QlM6MQG1sdsz27X8L1UkhpOlx15EPY1Oh3kj9m2J1cfPz7BvjImZ6WOsC
 dLv+IYlj
 AE0ItK+1OHRdj753bZe058FXf+ENZ9zs6amyhR3xar5t1IBbHizw/umctqq9tI9+H9ixHvrU41d17VRN2tK6bdJBiHwi9KLrjrfPVhol3Kk0aF2viYAdneGbc7vqVAJrn+VHU3/TGFrTtRoHxTiw3saVld5xmfl+A3VkUzRehGHMlP7Vaz64xVeHhSVNyvUqkv+M6h9Ze09IGPsFVpnyLSC0FEnivpERRUTi5geR5REs3U4cGptTqvgJoKjNlNtfpsDjfq4QcieGZQu6auwQ/TJ6oYdCfGEhO/YwMKsBb/Yw+VsnVQzyzBwngQcujy5EzV7/PgORAp9Fzyn7y2hjUKHuA6bVfgfjFeXaL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 04:35, zhen.ni wrote:
> 
> 
> 在 2026/9/8 22:30, David Hildenbrand (Arm) 写道:
>> On 9/7/26 10:26, Zhen Ni wrote:
>>> This patch series adds process and memory cgroup filtering support to
>>> page_owner. Following the previous series that introduced print_mode and
>>> NUMA node filters:
>>>    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-
>>> zhen.ni@easystack.cn/
>>>
>>> This series adds filtering capabilities to page_owner, allowing users to
>>> filter output by specific processes and memory cgroups. Users can now
>>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>>> memory cgroup path. This makes page_owner debugging more focused and
>>> efficient for tracking memory allocations in specific contexts.
>>>
>>> Targeted filtering provides significant performance benefits on large memory
>>> servers by reducing both execution time and output size. By filtering at the
>>> kernel level before reading, only relevant page allocations are processed,
>>> dramatically reducing the amount of data that needs to be handled in userspace.
>>
>> page_owner is used for debugging. Why do we have to add kernel code to make it
>> faster?
>>
>> How much faster are we talking about?
> 
> On my VM with just 2GB of RAM, the raw page_owner output takes real
> 0m6.178s. Filter it down to PID 1, and it drops to real 0m0.286s. Handle
> mode takes real 0m0.938s — roughly an 85% speedup. I've also tried this
> on a 1TB server, and it's very slow. The numbers would look even more
> extreme.
> 
> You're right that execution time isn't the main concern for a debug
> tool. But that's kind of the point — I'm trying to optimize the current
> execution flow of page_owner, reduce unnecessary overhead, and make the
> tool more user-friendly (especially for servers with 1TB+ of memory).If
> the user only cares about a specific slice of memory, why dump
> everything from the kernel side and then filter it all over again in
> userspace? Might as well filter at the source.

Because it results in less kernel code  :)

And less kernel code is good. Unless unavoidable.

-- 
Cheers,

David

