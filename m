Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A132CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 07:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11196B0088; Wed,  3 Jun 2026 03:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2506B008A; Wed,  3 Jun 2026 03:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8806B008C; Wed,  3 Jun 2026 03:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACF486B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:40:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CDD1120267
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:40:42 +0000 (UTC)
X-FDA: 84837804324.01.571A5C7
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2874A1C0006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:40:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mVA51zBR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780472440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llrvkQYvg/c/PyQA2OAu5UFeLx+nMQneljCzO+vWWr0=;
	b=Dk6DVdIyXGRs1lZDoaWblLbJcZVy3wxSNKy/qPiUOuODEa+vX3RzIF1qJ5jnofXVk8lok9
	HB71Mbf2iK+Ed2LatG/eZL6yH8XL0AbKr5tgMaYg4WQ+5ZtJPii6OGnPPTcSqlrJpYAyTv
	i5iSa1vEDby9uQ4xXsZMhwfgSIA+b7c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mVA51zBR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780472440;
	b=VWtQwWIj+8z3t/cZ7Gb5fvrIWnZxxB45IiO74zfKVi7xpctrOS815yR+qIPJNkhXqnzzEc
	uxG47wbbdPgPhaC88jKb2f77Ud7/gCNz2F+DzC2RET+U2iEpjQp8Hb+32fggdhBi9b63GP
	C8KFWF9ujJ/aBM4Mjyk5/bjI+uCHD+s=
Message-ID: <3022f1ee-36c0-4714-be70-558617d6b59b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780472437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=llrvkQYvg/c/PyQA2OAu5UFeLx+nMQneljCzO+vWWr0=;
	b=mVA51zBR/5dynA8pMjdR1IaOEEmkns3y5bv7f1pcCNY0JoBl661k7kCkMqQQqrYhdDuS+F
	22RAe5CDBpBcTdHW/LKynf9CUlyPgDBfGZW9R2Jstdc+p6StKeK9R/OYzzs5hYzEimlkp7
	hGrOWlom+eeUBGzFN8hJ6uW+upgNJ1U=
Date: Wed, 3 Jun 2026 15:40:24 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
Content-Language: en-US
To: Baolin Wang <baolin.wang@linux.alibaba.com>, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, corbet@lwn.net, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, agordeev@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
 x86@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 ira.weiny@intel.com, hughd@google.com, dave.hansen@linux.intel.com,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, yintirui@huawei.com, ljs@kernel.org
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
 <20260603064718.81699-1-lance.yang@linux.dev>
 <2132b0a3-1085-47cb-95ca-3aaa7f8ed44b@linux.alibaba.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <2132b0a3-1085-47cb-95ca-3aaa7f8ed44b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: aj6c9tggy9s6ci4xta16mgqe8j3oj587
X-Rspamd-Queue-Id: 2874A1C0006
X-HE-Tag: 1780472439-970827
X-HE-Meta: U2FsdGVkX1/asJiCUvrYDod3eYYp+g9ziqChjnWJMwwQgTw2J3vFFgU6h94g2q+BcKgOXntXk78GVwvyKXOomQwMTe0YDQe7bx5t7MNFT4ivBInLaezUR/bXuJRh8LjLAjQxSurn83yO4OtA0QOSSIp02UI+E5R82l9b2f/hW73cCNPyuQnAxnNxJbnncHjagDETQ0CGXXBRX0m4Jwb7HEDL2R0UTOByEcBXHrS1qXW31cysQPWsN6OrchdfPqiLSe5xssKF8U5wfbjVQRDqE4ZniRlHCi1W5gzB6J2KpyUzLxUUpyM0+bbMjX9VIPPwMqGmV48HbvU+8bVu1UKMphTWszKJGP0IblrJln3wZ9XMJBSetSelPPQ0WfB4bnxupyjLhdCztXDDDIMHLiVWed1mUFANpDpnZRM5mK50LRhttnqqAjLkDd8Y4wZsPC2eT9Byo25Uo1joAmXcnh/Y0Mu1XvVmkFXXKn+s5+Cq1BR0PDuD0mDgAW/pIRdi1UVFeNtKY+mf7VVXMa712vpdZRoJBADYJCUw1vGCLktwPXzZ/hsFsqrv/QHPvc8KS+9LuHOKoVNT4VrUIfQfOS4H3dakx2GrHK2TrsyoNvTbdgLnYcv1uxqMnOzsX+pWJDnaRj0xeLCzYTBhqr40ZW0AsnY3YJAAbnfYLNyqMKCWkljkqq144x7vPbgJwov0UgViCyF7TR7mnlEcL8Iv4pwSNjInGJNxJLkVZMk5Q2taxvljxf8NXroJFW3aM4U8UmHlGpph5oMSbnR8tEPSWmC8UhnPuB4J9Q8xGaGJ1UMveGuvGgk906jY6rIZkDUbtE265nhgRZPZOBP8OTHOLWDlxccfojGJID1XKd8MSYUEiQqbgXQnhaIXCZtBBMoymT9R26NxBDY6kCKAvgeD/7un6Y9YlHNYOyyZS1/1Gd/btBs7hrX7XFLFxJkbhuWUyUlW/dDE+6CNwONyO5Q4g13
 m9krHQN0
 ilZUtbImhRFVjobAL3rGXlSeGf3lmqC7CrHKbc8q64xH/sy7blG6ARzzKnfAfE14NCy6li9iNSu6kWUiM4qz8EGQyr+dCVMsfyFQ1jSRlwZ/D0d8aaEdPq/4qgihdpJ/v5O2jtbxzpdERHD+Bd+fqLn0QvwO4ge94DeTOgktnrhd9+wsvOVoIisZ5n9uA2nRFEL22tPzihPxOZYsZGTVTKTJfbCcyK32l+2sjbz1574D/fBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/3 15:23, Baolin Wang wrote:
> 
> 
> On 6/3/26 2:47 PM, Lance Yang wrote:
>> Hi Luiz,
>>
>> SHMEM_HUGE_FORCE still assumes PMD order in a few places.
>>
>> Is that expected?
>>
>> shmem_init() only sets the default inherit mask when PMD leaves are
>> available.
>>
>>     if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>>         huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>
>> But shmem_parse_huge() rejects "force" unless the mask is exactly PMD
>> order.
>>
>>     if (huge == SHMEM_HUGE_FORCE &&
>>         huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
>>         return -EINVAL;
>>
>> Even if "force" is selected, shmem_huge_global_enabled() still return
>> only PMD order.
>>
>>     if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
>>         return maybe_pmd_order;
>>
>> and shmem_allowable_huge_orders() mask it out.
>>
>>     if (!pgtable_has_pmd_leaves())
>>         disabled_orders = BIT(PMD_ORDER);
>>
>>     if (!vma || !vma_is_anon_shmem(vma))
>>         return global_orders & ~disabled_orders;
>>
>> For anon shmem, it can also return 0 for same reason.
>>
>>     if (shmem_huge == SHMEM_HUGE_FORCE)
>>         return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>>
>> Should SHMEM_HUGE_FORCE use the available mTHP orders below PMD when
>> pgtable_has_pmd_leaves() is false?
> 
> No. That's exactly the strategy we agreed on after lots of discussion:
> 1. The options 'force' and 'deny' are dropped for mTHP interfaces, which 
> are rather testing artifacts from the old ages.
> 
> 2. If top level value is 'force', then only PMD-sized hugepages have 
> enabled="inherit", otherwise configuration will be failed and vice versa.
> 
> You can check commit 4b98995530b7 ("mm: shmem: add multi-size THP sysfs 
> interface for anonymous shmem") for more information.

Ah, thanks Baolin, good to know that :D

Cheers, Lance


