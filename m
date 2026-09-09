Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55BBBC79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A9F6B0092; Tue,  8 Sep 2026 22:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345896B0093; Tue,  8 Sep 2026 22:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281A76B0095; Tue,  8 Sep 2026 22:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06BF06B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:35:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91AFC1C2AA0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:35:46 +0000 (UTC)
X-FDA: 85192658292.11.F329929
Received: from mail-m2466.xmail.ntesmail.com (mail-m2466.xmail.ntesmail.com [45.195.24.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id 223A31A0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:35:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.66 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788921344;
	b=q1jhGmfYgvWcK4wbyl/Q0FmIwcO0cRIWxjZ6EL/HgrEzWsCWCjFi2h42iT1q8eG7K3sy/I
	2QVYw3KmeYskpaC20U3D+9y2JRhGCR3/n9guk9Zh+o9eAoevk8T2j0H2u+Pl/rtxHXOtMv
	rT5Fi2pbFJwYBWeFYoNTGujz3I9Wooo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf19.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.66 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788921344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyaLmCJnwEJh2i97b8cNw9UzjINXD70ZFMKzP7p42dw=;
	b=b1+/nSvja5AUBkEfBzqGY933IjLA5jOWJJGk3iaQlnFDkdDoMtrIr4UFu3O3jEWHNddbtv
	OSq3Mh1awNvrJcEQXT/E8BDpVRmzx7i7e7KHg/Nl+9tZbUHEdSB6j/SYJsn4MOLrVT0bCB
	vgcj/qZQJiMGG8uFEFKQ4fc8Y2hEC/4=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1eda0dd33;
	Wed, 9 Sep 2026 10:35:35 +0800 (GMT+08:00)
Message-ID: <6e8bfb0d-d595-4e6b-9536-0323ada57e25@easystack.cn>
Date: Wed, 9 Sep 2026 10:35:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <79548641-25f3-4ec3-a549-782fad168962@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa084054d8e0229kunm29073d571f33c1
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGk5CVh0eTUNKGElMTExKHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 223A31A0003
X-Stat-Signature: o8x8mrci14bghtubhwkbw7rwscuk9x6m
X-HE-Tag: 1788921342-28371
X-HE-Meta: U2FsdGVkX19dCqxdm3jn71RQYae6dSYbKAHwY0G3nByogT92v0xlzfN/F5KLwf2mJ1+awzvXcGpDlBVrdbUX9xbT7h1MhjWvgdZRWxX4Oz830pY+sooQjjWX5BmbFOlOxfrkjK0e/X2SbFGXmBTlzR14KjahxYtX6fNZkcvG+MzZc4+e4eTBhPTRg0cMQwaBBWFCK1LmCAh141YkzgfenLA6OjTFgbmVG4Tt/YyjWAxzZJtG6NYyEfkZVlrYFRkrt9kkzGF0YlXjX/r24PQtd607F6XPXtZn5THlfEn4hx1fLTfY0aFB/M0KTNUUT7WaXwx0m8bHRIwN0nIPH3/BccCqXpebpGL81y8A9B5QTY5yZ+L1XM530o4VfFHGz4ZAww4vg5ZvDkxSMM1KXPd335CdOes9/ZZgc2DL79+cDAPMa1/Y1xlMxJacSVNsJsorXujRTXB/eLx15TyymZzMSG8Cf6ayd915t0RQmubIiQX2goofvpBPYgWq8ImPA6zCwXkvHNbmdh73M3a0NRxyC0KPnL8ORrQZlWh9D3E1dwtlUAvprSsmOymBVhugsubbxMn2jCE9k5SNyXOPFy6TmvoUZ6ID9MmIWaafv+MnQYkGP4lcScaH9qmTiRr2CxZZJ3ypv4qT9V/WvXMkx1J/O8P47+WhbEbtRwIpLzIpEhsycPN4jSUxAXbbWD7euhExL6PfdTx05/tkz7SAJm99gG7/ZsjmbQDhsxMc8YRpImS9EP7BdULjn5fqZrVYaMeOQMDthJDrMdHF7xJU6KgjWV4ucPap0H0Kju0x3reAUUspFRNWxHuQrj8u5AGX4i8Zf/Nmd98A2Vc/VgSiKj4NOk8qCe2IpQGXDPxRTgCjQeXxGEOV/Pif9LN6DDNHudjXwX0OghlMtEaxS3dADY+BIjBXUPWQ1kd2ZIploMagRfHiDn6QF4Vr8ajRd+1tNzz1eqQAfmYhOTUY9oyvBqq
 puNchhmY
 fbbK14pyUxzNEonoiJYyfr3Rzbfrcm86yfG/Y/4IqTSmSBoZSB+CDWvc/nJ5/QB320p8bqPMDeqzGbj7PkkbJcFRThgKqNGo+Kz3HH3KDUJpj4dpeFS4gsL3d9wdZCzhTmTIowspOARvxwUgc9OFZ1l+X4u2HON5AjFOnjQhyUxvn/+cV/qjDPa2zB7t9g+g5CWoRb16+w+qhOeFor/p4gmp6OYCj/8BIt++RJRxIVTtGdrZZX+f0Nv1FVH9ZGRzAO6uLxT0OxQwE+aQXH8oVvTrCd9OxmxQFFwwouECTQ3XsETE4LpAOJzeEDAAHmLFzf9Aq/Z9qOa5UQWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/8 22:30, David Hildenbrand (Arm) 写道:
> On 9/7/26 10:26, Zhen Ni wrote:
>> This patch series adds process and memory cgroup filtering support to
>> page_owner. Following the previous series that introduced print_mode and
>> NUMA node filters:
>>    https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/
>>
>> This series adds filtering capabilities to page_owner, allowing users to
>> filter output by specific processes and memory cgroups. Users can now
>> filter page_owner output by PID, TGID, COMM (with wildcard support), and
>> memory cgroup path. This makes page_owner debugging more focused and
>> efficient for tracking memory allocations in specific contexts.
>>
>> Targeted filtering provides significant performance benefits on large memory
>> servers by reducing both execution time and output size. By filtering at the
>> kernel level before reading, only relevant page allocations are processed,
>> dramatically reducing the amount of data that needs to be handled in userspace.
> 
> page_owner is used for debugging. Why do we have to add kernel code to make it
> faster?
> 
> How much faster are we talking about?

On my VM with just 2GB of RAM, the raw page_owner output takes real
0m6.178s. Filter it down to PID 1, and it drops to real 0m0.286s. Handle
mode takes real 0m0.938s — roughly an 85% speedup. I've also tried this
on a 1TB server, and it's very slow. The numbers would look even more
extreme.

You're right that execution time isn't the main concern for a debug
tool. But that's kind of the point — I'm trying to optimize the current
execution flow of page_owner, reduce unnecessary overhead, and make the
tool more user-friendly (especially for servers with 1TB+ of memory).If
the user only cares about a specific slice of memory, why dump
everything from the kernel side and then filter it all over again in
userspace? Might as well filter at the source.

> 
> Or are there other limits to actually implementing it without kernel pre-filtering?
> 


