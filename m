Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B8DFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 09:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D588A6B0088; Wed, 29 Apr 2026 05:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D093B6B008A; Wed, 29 Apr 2026 05:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7DA6B008C; Wed, 29 Apr 2026 05:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFADD6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:57:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5633A3FB0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:30:10 +0000 (UTC)
X-FDA: 84711072180.28.FA15931
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2603A80002
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:30:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=f4Jz3rp4;
	spf=pass (imf02.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777455008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2sErW9ifuxlN4x+Sne0CeYYbEJKHpiCBGf6vhcU2Jk=;
	b=C1GjEQ6+jvwP3crgPH2D18mpPWWl2LUPfJjTA+57xG9aZddiEUqP8Ey6zFVVVhAr1wNX/Q
	xLfC2AYxjW7FygUeWaDu9XsHumau/HT2QX2GlnnsEbQdA79hEnJ4PU1jbKiJAMJUAM2Lqk
	f5T5AzQ21QvJQFXx5n4sPO7NEjl9VL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777455008; a=rsa-sha256;
	cv=none;
	b=1rKHmm2aV2VzeXkN/HXIc1rtKbERXG9A/yVUf8ZkSB8seoF3IVGeopYea2YGdADURACJPy
	0m+yFGkBenhBWhEsU2UCWs9mH1jlZlymUeuq0ojW1IdQuViLNJ3Z5IkpRWY0zQL9ltr60Z
	bMiuiYWk7lVzr3XBxUWui4DrFOUCynM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=f4Jz3rp4;
	spf=pass (imf02.hostedemail.com: domain of arun.george@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=arun.george@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260429093002epoutp0459abb6078236d1b7922c976b1042db95~qyehotRtY1912719127epoutp04T;
	Wed, 29 Apr 2026 09:30:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260429093002epoutp0459abb6078236d1b7922c976b1042db95~qyehotRtY1912719127epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1777455003;
	bh=l2sErW9ifuxlN4x+Sne0CeYYbEJKHpiCBGf6vhcU2Jk=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=f4Jz3rp4k+M6bC+6TqlXloRnoElu8gbjEIiUIua1QviqkO+4RxEinkUKYJCggf8Hd
	 FVrvtEGPb/OllLUxDO4vDE05M+R+UKBx6SqInb9CWkL+WMtxaQmXCaDix7f3d++h7o
	 yAcy3bhNxsmOBqM5dvxXy58dF4C26cPcMyLnfNPE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260429093002epcas5p409aa78c4d55a86cef067895205a1b2d5~qyehWqKUG3126931269epcas5p4T;
	Wed, 29 Apr 2026 09:30:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4g5Bpy4N4Rz3hhT9; Wed, 29 Apr
	2026 09:30:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260429061641epcas5p3c2d6063ba101e347c36ccfa050174482~qv1tDSpkV0853808538epcas5p3d;
	Wed, 29 Apr 2026 06:16:41 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260429061628epsmtip20cd5b871612ade998c9aaa11fb84dd9a~qv1gikvBb1891418914epsmtip2w;
	Wed, 29 Apr 2026 06:16:28 +0000 (GMT)
Message-ID: <1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
Date: Wed, 29 Apr 2026 11:45:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Arun George/Arun George <arun.george@samsung.com>
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
	riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
	roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	zhengqi.arch@bytedance.com, terry.bowman@amd.com, gost.dev@samsung.com,
	arungeorge05@gmail.com, cpgs@samsung.com
Content-Language: en-US
In-Reply-To: <ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260429061641epcas5p3c2d6063ba101e347c36ccfa050174482
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0
References: <20260222084842.1824063-1-gourry@gourry.net>
	<CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
	<1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
	<ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2603A80002
X-Stat-Signature: zeqwfkscgymemabbo9k5ebguu8qt747a
X-Rspam-User: 
X-HE-Tag: 1777455006-638171
X-HE-Meta: U2FsdGVkX1+CchRmxWvLomRTYDH3Z2HU9DrLBPItGxBC9X46OgRhtOeLPSv2ygHn6pIcHHmdPtRuUdhcNI5reuCk+mLI3gVsUnGY5aBH2RZgP50MqXZIEkim1Xvm000cq6nuuWhrzRU5aJ2LQEC5riNTiznQtpDLHlCm7lRTPd3GWGpYXusbU78vU1DLHItC60cCASgJhUjXUW61UCd3IrVRlEh+6odSod78sCIViGPogaKkKeNur/fmjc2IvtjB8PKQPK4YRo/1HoTSMlF52uOlyIHJrya974WYpND/buIjCvB577XLk2xEnLqMbFnQW8TQqX7iBUwzSx1N/dh9KyxfbkvVNuvVc9dnFMI3efQnlJgDhsy11isY99nGySblUkJdrIQew0UTuOYN685ca+o3LF1muhjXFj/g+OIVUKmdHuIhYh19W8ygp7M9q7tNBud6ZPYfqLVzbHmWGxG+ik6E0Oqd7T0lYbIO0VUo9xYSX3RUjHcHqhQNlDB8C2/T0ry1fX0SCvmi37IBW7m0qZ+liVXVJ71QRt5U+eDYyVNjUU6iY7GwENVHrVabsKtd5CQ+imzB5rjwaDwyqXZhi7Uy1i0RbjVI722NrvNkzNBrtyGo+ZIfvBsA5OiVvrgwRlbDwoKwYs0XO/oycoyLgPLUJavSf6khKBZtxcGj69SgTdmuUdGbiO8wbrz1WI62egHlmCeyhPVU/16C55r1Vy1s9eNbwZoV8XoiwMZ+X0G9cIPJll94DCXhdr2wx19WVftK2ZnPaHb82D6B/V+LuN5rxUTiWIPGUGGMK3khdpdneMr0H52QpwuRtam+9zqolKKnpnXYCAjdX5cqoLiokN5NfOXW09SPzlTnLKhaJZSMlzlHfXPJ24/fAsifWi495FOHFer8fKDcGR+FVemXNYZXSlBxeZQYLA70ENE+MmPdzuOa9aWDxYFTf1CVrcymuSuUoM+gPjn05ejnLot
 5jx/4f5C
 mtvjNZhaRV3plMq8jpGPTbvhlGP3/3SLTmfMX/+AcNsDuYO56xB5ixp/jWbMq1xVGS/DsXasMJ92Rjn5VniV+gx8UN5CVijPiNgzOQrvyQtUcxpJ3Le04W81ajbTAl4l1Kvi85Z1Y8+ln2Hwuwr9z1djWc1B1GF9fr5f2Z7KfzKXdZKsEkGq2WFgH32VTt3o1WY/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28-04-2026 03:58 am, Gregory Price wrote:
> On Mon, Apr 27, 2026 at 06:02:57PM +0530, Arun George wrote:
>>
>> Any particular workload you are targeting with
>> this (which can tolerate this latency)?
>>
>> Any deployments you think of where the goal is a capacity expansion
>> with a compromise in performance?
>>
> Primary use cases for us are any workload that benefits from zswap -
> which is many, many (many, many [many, many]) workloads.
> 
A curious question please. If the primary use case is swap, can't we 
handle this problem statement by re-using the zsmalloc allocation classes?

A separate size class can be reserved for non-compressed pages in 
zsmalloc. And this interface could be used by zswap, zram etc. (We have 
been using this implementation for testing btw.). This does not require 
additional book-keeping or buddy allocator.

But that approach will not give a generic solution and not available for 
user-land anyway!
>> And I believe the bear-proof cage might work in the normal scenarios,
>> but may not work for all.
> 
> If it can't work for all workloads, then it's likely not general purpose
> enough to find core kernel support and should seek to use the existing
> interfaces (DAX and friends).
> 
I agree. That is a good point.

> 
> You need two controls over compressed RAM for it to be reliable:
> 
>    - Allocation control (acquiring new struct page to write to)
>    - Write-control (preventing new writes to compressed pages)
> 
> Private nodes provide the allocation control.
> 
> A read-only mapping, and guarantee that only memory that can reach
> the device is userland memory - is the only way to control the cpu
> writes from the OS perspective.
> 
So write-control part need to handled in the specific back end driver of 
private pages while the allocation control is a generic front-end sort 
of, right? (Ex: zswap cram back end for compressed devices case.)>
> In the next version of the RFC i'll demonstrate cram.c as a new swap
> backend that allows for read-only mappings to be soft-faulted in,
> migration on write, isolation to ANON memory, and some optional
> settings that allow a device or administrator a "writable budget"
> which allows some number of pages to be made writable without migration.

Great! I believe "writable budget" could be an interesting idea which 
can solve the 'bus error' sort of scenarios due to device not capable of 
taking any more writes. The write budget could be replenished using the 
control path and writes will not go ahead without the budget available, 
right?>
> ~Gregory
> 
~Arun George


