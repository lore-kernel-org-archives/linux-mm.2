Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDDBD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDB56B0026; Wed, 26 Nov 2025 11:34:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5EA6B007B; Wed, 26 Nov 2025 11:34:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02806B0088; Wed, 26 Nov 2025 11:34:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA636B0026
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:34:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37BC113B8F0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:34:38 +0000 (UTC)
X-FDA: 84153306636.18.F087D89
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46858140004
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:34:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ByOkJ+7M;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764174876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EW/xRiF2YSo/HMOBazcBmwYiMNhsTF5W2nWfZvBvA9Y=;
	b=QRSzeLVdzXwurYRSzgFlsm0UqX5FzKzLWpoMKUer6/O9jSxmxP5mcg43JDD5AKm1eq318a
	8u9Elhly7bjjhvjJkBGe0pDMMfvCZ4KXhdmVwgeeR6t3Pbsud4PKE1CAWODNhpUT85/5r5
	wDnrbmudMS8Q0CMZrUaCrj34EkBqytk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764174876; a=rsa-sha256;
	cv=none;
	b=cl6HMRz3jxYCxW1a5Ap5QbhfknbR9dkTRtztnaE3b/5kBdRm0jNqRwyP7FJ63VnBIXg9PW
	Eih6tfYQSn1xGxMguvMQT4OM5nCMLeUuhIhBqujPoMZPtK8rLVVBDgsoX4uc8lkQ8WyGAO
	R/2N3Z9wfCiFwXGlaG0NN2Mpd4FMADs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ByOkJ+7M;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 26 Nov 2025 08:34:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764174873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EW/xRiF2YSo/HMOBazcBmwYiMNhsTF5W2nWfZvBvA9Y=;
	b=ByOkJ+7MNDcPqbv/xifpw0Od8NxzcHsU7Z12zC7zVdzzKnnbcF4qNvZsdSTIl3Y59Vx0ZN
	+tP2SVhJYJbYqv5VulAL8Hnud+Jm47BwfwkRPYHv3yudu7ioxx/+ebm+OUjh+XML1qGqnI
	J8hVYO2PoNErAcwob+RoqdRm4jx+v3E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, 
	zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, lujialin4@huawei.com, chenridong@huawei.com
Subject: Re: [PATCH -next] memcg: Remove inc/dec_lruvec_kmem_state helpers
Message-ID: <rafsjmr5prtreezlzc3373bxsnutasvspmdgbntonhggk7ot4u@xyla47tfae2m>
References: <20251126020435.1511637-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126020435.1511637-1-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46858140004
X-Stat-Signature: 79h9j63k1n4psnub475gmufm1kssmbk5
X-HE-Tag: 1764174875-118540
X-HE-Meta: U2FsdGVkX19y1Z4rrbf7Zo42HL7cnGAbEPzMkoVnO89mGNeGc3TKzkvLfimzHWkrZefy94VaOqdgQY/rjIzU4881vPiJvVxIkPn1McWhxpG2+CGOiUZsu1iickD4Ah6s7NXRyYWDnzv/Agemoc+d5CaO3Aw4oQny3IaBTQH7gGUeq6kVbJJ1EsWJstI5hMK7VwObfILlr6e30R86iw4LOqQhcoa7mlJlwCJWwutCb33vZz6qnptjA7qw4DkAvrKYy/xTkz9kBkhASeZRzAJ724fPL8SUpShhKvVBCCJ53BWKeKErLRQ0mgtssXAOy2whd8zIz3NhRyzGSlS/ipmkStthY1N5ensyktgWjDKYQHfRFOEC0u/KC/Vyzyrwv4PQApKXb+8srsp9LVq27jO9IsJIJPYArONq7r4B9TvBcns+8hf98rxQ8aDqg67jsX7/XQu6nh58xOjufY2MFRirF3f0gQbvlUaHX+waPHO5lP1lIEKqRHgFj0aFcaj1tQ1YoLjo+4PCYb5NigfnICzmQPUQHRJf8QMCjoawg5VazXGoNsGn4lUjqBqYNmymYLA9IJkV5QfflUB32SvE8yGZUEOAUE8mrx7pi5EK+b/tQ8I8SrV45tQnaMijqu5ntC6yBQVsL0KRpOKBdYoB6Bz+hLFI/AjNw4SjZfhr/EQQefLyY0qiEicw7B+v2na5CD1ivu3gZCkwKa/ZkUKrFFu2go97z0GefpWcfn3bghsMkQMcSR6EXVyimeHpQUE4AfxeKjxxWQvcC1IejTOQlCJJzUKDOEmzK3QHEq6SUKPfdPsAVnpdV6oyGX2LChKIoDfKFveeweP8bv8bTP55WOJ7L7uWhxqXNpvtdmFjmjGPe3tYiFvhpzGIC6JC1twBIKZWu7z+K50nuXSIROofLVTwm9iMnEaoSHQNiwxd+y0ltCbqJV4Lpe2uCf+OT7Sc/f10CgaLhJfch2ePmDU7WXR
 KvkELy0U
 D0ZrxhY1pdCY5YlYCP2U4/+VEAEs5fwkOg8JnxpPKLqEJ3XWxIkSkRiT1vZ5EQt7q7Bf94G8dMWQVYXbum/QPmXKn9/dDRb5hJC1r33Hstvv6KpS0rIIsK0lJg5Ox8uUThR5RBX4P0vZcbmcYRcEoAhtpejvIl7zrs5z8cyH7kqf+6KtsIanygQjDbAF7q7sKHYHGhUo4yZHm/mV4dpSQ04KDz5OVqEDPFJY8LEED79uloV2Ucz1JPObxHYIeJyeUjnJNsvUeCx+2x1aoMNEGWJbhYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 02:04:35AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The dec_lruvec_kmem_state helper is unused by any caller and can be safely
> removed. Meanwhile, the inc_lruvec_kmem_state helper is only referenced by
> shadow_lru_isolate, retaining these two helpers is unnecessary. This patch
> removes both helper functions to eliminate redundant code.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

