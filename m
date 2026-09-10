Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D508FC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CAE6B008A; Thu, 10 Sep 2026 02:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEBA6B0092; Thu, 10 Sep 2026 02:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB4F6B0093; Thu, 10 Sep 2026 02:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0E46B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:27:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EEED1C2364
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:27:44 +0000 (UTC)
X-FDA: 85196871648.01.D1E9500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01EAD40003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:27:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vFF4klIX;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789021662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2959D7GXiIunB5jpQGCJoRIyTLlLNAvoQ+NgVxUVNXI=;
	b=XxJurMiUofp6oQuWKKFv2PKZAB2o7IDUOS6mhtMyytACYlsV5uhtaiFiIHc85IUsXkcXKb
	lH2uzoPulzrMBWzhQl3PT5MPu7s/0ErJeARiXbeOzxjLBCCgO9o94YAXybdPNyZI6M16u5
	jIm/VRVzr5hCQWz+CU/8UWcYw8By4m4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vFF4klIX;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789021662;
	b=QWdvYgXnPWtS7lb8KisLDC3vdxAqofEQ7DvjNXfUchgBhGaxl0XO5BRSQ96pnyHjPC5JxS
	UXMriTV+Y+II9OzP6Omj/6Vy8A8D6fLTwtixVPMCttWY5QNkRmfPaS5043Z3ULw92/RNRS
	Z7029on3zNNf/0Cq2nqTpXofmzI2ltM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789021652; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2959D7GXiIunB5jpQGCJoRIyTLlLNAvoQ+NgVxUVNXI=;
	b=vFF4klIXXawMiNbdGy6nT5Se33byz2LVVnU60+eHcZInofPHiaKL1Fmfo/NzmupUK+LOu71H/lwXSNZlC/JpcHPapvODZncvlDZbaPsYVhMtNZhLUk/xcjt+PVSN3Jc5Ru4+z59/sY2zETKxs2g6tu9B4wZXgjErSGKqqZSBRME=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XAgmcIa_1789021649;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAgmcIa_1789021649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 14:27:30 +0800
Message-ID: <ba2d7885-f017-4d4c-bb59-e45f8b9f1b63@linux.alibaba.com>
Date: Thu, 10 Sep 2026 14:27:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-7-kirill@shutemov.name>
 <4e064b9d-aea9-485a-8547-3830999cff01@linux.alibaba.com>
 <aqE3Vq8Go01c1icS@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqE3Vq8Go01c1icS@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01EAD40003
X-Stat-Signature: o4truh6icma3trqubebmpy4ccx4of44j
X-Rspam-User: 
X-HE-Tag: 1789021656-769527
X-HE-Meta: U2FsdGVkX1+zjg0TITVQ4zZrGdwpaSjiXogji3w5TrISp2Yqg0QOyEyymjOyRj+fh/DIRP0Kc+5P6KXFPE12mlgD/lTOEAgDI/LRSJMcjfC0D8Ro16K1sAzNPLxZB5E9XvbzEytT4LOsTHPwCsGzMjRiU4ThBujELeOKYoLWV7P1ai7D8YUqbp6qXbe0+eAy6q/DiNewHEz8jtSxaSANc6Jmoa30Le3UHLF/SYyDafOorQwM8IP0BBpZNIJYZJ54sNG34A3Wr55k3YdJZllBeWEKgBf7rLUEA6TKBqJup50JIeHS4cwW2wAKfXk4JgeW+gOhdo1HBIuULbnTclfSKLdtP2f8lLBr6iFiBF2waGj+/MpMNSWU9sXndH2jA2APqSlK6NvqM4cCSde3xQov8Bu2j8LAwQjkFAwkvLkmyNP0HCH+rtim7ob7119mOyQML1AzLAWwB7MhJiwWVZay1IzZj4DnjH43SycEh8lKV6Pz0/CS63w62qW7NM196bE4vF6R0VhlXv6sIqRzFR7m7OkQoj0Dgpp9isjCYHT5gmH+wJKvxrxejwj85QLJdgH2nnhfm5uWk7KHFaRCbfXU85zSO2ULBgqWZMgRUhwz+2l1wiIbL0T56qtm4DVGCNAr4Jw4VuKBPezijL8snz8CpSobVxVPSgF3BLQpyyxuBgYNAAkJ0Mve8unu3tNNESYCxTI5ErUbqKl+Oe51YHQR8MyNJNMSdeAN1/qDyu5kj+D4ajLFQWOX0ibcJQpHcnl/0x8OgxrMcRWZOC8CimxHsD2fwgYsYJm7sqgc1OZ0yKgQmI+lwD9hD1YhAM6Qmcn4oyTYPQbzOeTO/tv3//jx508MN/XS5NYmIf9nwfqB88TxwEr5mygIIGZLnb4pSS2Hed5DemPscWIGjo9l0a9ji1Ko/hSpGLsG5TFs3q+XcxMjeEIBlIFI03MQFLC8YufSSMFE49VeFescM/MHaWH
 IG7Xt4x4
 DwBk3X+/6CTxIKSyPkpIB17DW7OCqY8ReaQ+xfxt/K9vgbzuiYAZKOwy1/7tLHnhH9MOUPWKXtEMPX7UW5ERjqzU6EwTYSVT2pFnkEW7a3ImF1KdlwcO7O85kUeRTzcxYQhGazFhr7Z+Y5wZRMQo1P7hXkCkDHAao4a8FhOEhHxLZ5XyRXMUzELE9TqsrKJfx+axj/E5caT7b6uRxCMN1dsxspR59feDc/Es+jc74K9Lmbca5Iwj7pss3G7Rtz/GRl7/0ci3tcfJoAcSRcqwlMaVJh9IsntZfT3878BsEhU817v6Mwg3mpeoAv34lovvQ0j0Rf4p4ng3SJH9OnUrxJXJHZImhlibAGsu76DxOHL/l3Q+pFKAyRZgMLIJ0ZW0bvjY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/26 6:41 PM, Kiryl Shutsemau wrote:
> On Wed, Sep 09, 2026 at 05:55:01PM +0800, Baolin Wang wrote:
>>
>>
>> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
>>> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
>>> It clears the global controls only, which is no longer enough.  A per-order
>>> control overrides them, and -s, which makes the cases fault in folios of
>>> one order, leaves that order's control at "always".  khugepaged then
>>> collapses the very range the case is working on, and the case fails on a
>>> collapse that was interfered with rather than refused.
>>
>> Right. So I think the correct fix tag is b7f16963efe7 ("mm/khugepaged: run
>> khugepaged for all orders"), because before this commit, khugepaged would
>> not try to collapse this range since it only checked whether the PMD order
>> was suitable for collapse.
> 
> Agreed.  The series is in mm-new already; if a respin is needed I will use
> that tag.
> 
>>> @@ -547,9 +547,16 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>>>    	/*
>>>    	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>>>    	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
>>> +	 *
>>> +	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
>>> +	 * finds an order to build.
>>>    	 */
>>>    	settings.thp_enabled = THP_NEVER;
>>>    	settings.shmem_enabled = SHMEM_NEVER;
>>> +	for (i = 0; i < NR_ORDERS; i++) {
>>> +		settings.hugepages[i].enabled = THP_INHERIT;
>>> +		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
>>> +	}
>>
>> This looks like a workaround to me. Shouldn't we fix this in shmem instead?
> 
> Good point.
> 
> It can be a follow-up patch.  Do you want to make a proper shmem.c fix
> and update the selftest along with it?

Either way works for me.

