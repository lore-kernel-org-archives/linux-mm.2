Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBA2EEE209B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2D56B0092; Fri,  6 Feb 2026 08:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173126B0093; Fri,  6 Feb 2026 08:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055666B0096; Fri,  6 Feb 2026 08:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E59C06B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:03:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DF721401A9
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:03:47 +0000 (UTC)
X-FDA: 84414048894.20.967E0E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B65501C0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:03:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bv7EzWDi;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770383025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAXkmc6NXH6dLSIG7Mz8FQHJyErfjJnUgjs4l9LzkcM=;
	b=jKfJFvVyA4U3gHkgJTBK9Tr/eeKIyri6pvMObG8sFKr8SOmsugu0lcPOUk5S/luzhj+dPV
	U3NUS3huSQoq2KWjkDCeSCBRDq9rqXAbSIPaxPx+f1+dIjRFLYeyI26yay56bpu1eD620Z
	+Lnonix+TxAw1/7vBQA9pj9UtwjP20k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bv7EzWDi;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770383025; a=rsa-sha256;
	cv=none;
	b=fgcLtt1f/nz4cG8ZoWUJzMwOQPOnInFgcP9pcn0fKHid2oVHHZv2gTvd0ycgN7pi+QWNzH
	M4AEfeMsGjFgRz+JOhQjR+jKRHAWz20418tF8RZns61Igv7tvbmdtXrB7tNPfQpQrQFGJq
	0xwZxdfwwaOVcfrW6khsACFQ4QG+kgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C300418B5;
	Fri,  6 Feb 2026 13:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA2DC116C6;
	Fri,  6 Feb 2026 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770383024;
	bh=MJuM4duWRQOdgMSoWpQ5n672KHtCLpnyJV0vo6WaoLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bv7EzWDiendze/cP586ru5zBpHpfCly8MOX3VxeiW381Thyq5+xgeBLPmDNR9+jdi
	 JAOrL8xYk19kWk4srpq3Qin0GmbD6FLxg0sC+mQRf0F7UQFseVZPC0Kn0XMrkua7p+
	 jyuqkpfOWUKjHFO3qv4JfoGJvnaWs4NCNGAKZ0hiUqCB3t1DRiRIqviwua3mzILUne
	 6zqF76LQM8geG+0JjCw2KugvN9IszV9WTp3MHfeCZ0BlNIo4dsPQ4jBlrtL77nPg1f
	 IsjOZGxkgXZ9b56jYnxu1sdNaARVf03RaHZ0K7DeEaM07nKsgcRfI00Yes63M9BMnj
	 y2Q0UeF/w8xCQ==
Message-ID: <00d07c59-e573-40b6-a096-266ef14545b9@kernel.org>
Date: Fri, 6 Feb 2026 14:03:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug: Fix zone->contiguous always false when
 hotplug
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260130160938.2671462-1-tianyou.li@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260130160938.2671462-1-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: c68jfnxj8bknt79mim74fmbz5m6eaw3h
X-Rspamd-Queue-Id: B65501C0005
X-Rspam-User: 
X-HE-Tag: 1770383025-492879
X-HE-Meta: U2FsdGVkX19p4v90jlV0/OQ/xAllvQUPXfxtHBUmsPfHTZnhHwXnJ+eBHIjTe760W8Iwayibj/YxFn2cj9Y1gy7EhOlWPE37YX0W9oyEoZIcPjxKSQpgtwpwRUILcHB3J5C29A7NWnG7mBxUFciW6pxIFKiiX6ADSbifG9wzpZ8HEGnSmczqsW1AA7eNR6rDIhnmOGqralkZlK32vybyH/N+6RD9VejImNON97esDn7XCYKSWUHeV1y6p7yjmO6MRm9ifY9TtFoyooLbAtqtXWQmZvW4jjNcR6h6UMBJp9xO59VRyF2WhdC0s0hz+KJIuJuujT5JNrbALcnEb5lJceDlCgDJPyY0Rg7N/KrsKyKjWW4TETm7tfiKNxzh4/+MhTcRWD4B8y9919gKhSsF4PLg7Ev8rw5ZwVTTU0oqIVHCU27IXrR5JaG8fKaI9qkL347as3SaDuPdcv8Z7wi6pyjIbV0e+pPvUnSJvNzOz9R0NlhT/FFd63j8MOPot+FXHOdRcp4FVcRw2gRKPmLAd+LFDzrl4KkPh2vzC6rujpHwg2PNQarnEfUTjmOHfYM9GADOwyR+Dd/vV0z8GeiGitwyYCUclnBFoz46ACKu1/lRbe5TKNM7ydRYpb+kWu1rfrSwoAi+WFrsaOujpYr5uEMhddBmt0GO+ImJtle8Q8lYY4NEcOGLN7KSzohIr39SP5m5bFRJmdOOrEKrVkq/ElPCI1Q3z7cDcN03xxkFRq1nTb+qtBLB9WQnlz3VrD6aC2FaRMaOUDWQlf3BAPaLZn0HWh2XD8X7g33TAxaqFUExkAH0Bacant6hGWGjU7Sctt8ggWb39owzZkqpOHDdWbznHXMGEaR8SnV5YUoEMlhNbidER0GTyQWi4jO0fapDN5yMiG6fctgOOwTFTkhvhQSA8knbnjd89J6fjXGFULHRfm843E7eie0UmYcN9VHz488b5Q5hexd5+u3RhHr
 zOFgRcvQ
 VlMYmjeTHIJlKWKAFsMGcxxjYXkmpEcyHYEA4Liei9PGfO9z669igzAX+7BPeOlN1xD5GZYow0y1XfQ6rVCokNeuLXBaNu/sbcKviP4x4s4FDK73NpWWMFHQJ860qkr0yZ32rMBriobB6mLZv0Iur6FPt/O6k/Boaq5pUrxPq2KgL1xOGlJjAmba5eoHsYOrFYBOFPul0ez0nt8MYR8NxVn0oPHunX0eX3mFqT1Y+xVWTTc9dCQcZJjtqxeKKyMWz8/VxsdCjNrZnvkRmIl/zAZjitMlFRZisq8xb4ZvgiRHtiod26R5bhnt3FiDOfoifu+WYEbQPQXvTsdCz60duIZSyY/4fLoAELtq5LSY/6cFswbRDr+kwmWXgFevKHnSZL9AcZSqC9Dpp61CE4W7i907Xc1qScAR3hof6DmPBCZUKzwqxwlE6mhrxyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/30/26 17:09, Tianyou Li wrote:
> From: Yuan Liu <yuan1.liu@intel.com>

Nit: subject should start with "mm/memory_hotplug:"

> 
> set_zone_contiguous() uses __pageblock_pfn_to_page() to detect
> pageblocks that either do not exist (hole) or that do not belong
> to the same zone.
> 
> __pageblock_pfn_to_page(), however, relies on pfn_to_online_page(),
> effectively always returning NULL for memory ranges that were not
> onlined yet. So when called on a range-to-be-onlined, it indicates
> a memory hole to set_zone_contiguous().
> 
> Consequently, the set_zone_contiguous() call in move_pfn_range_to_zone(),
> which happens early during memory onlining, will never detect a
> zone as being contiguous. Bad: the fast path relies on the zone
> contiguous state may skipped.
> 
> To fix the issue, move the set_zone_contiguous() call to a later
> stage in memory onlining, where pfn_to_online_page() will succeed:
> after we mark the memory sections to be online.
> 
> Fixes: 2d070eab2e82 ("mm: consider zone which is not fully populated to have holes")
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>

How was Yuan Liu involved? If he is a co-author there is a

	Co-developed-by: Yuan Liu <yuan1.liu@intel.com>

missing.


Likely there is no resend required if you tell Andrew what to do, so he 
can just fixup when applying.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

