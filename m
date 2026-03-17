Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D8DFED9EF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C6D6B00A3; Tue, 17 Mar 2026 13:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4252A6B00A5; Tue, 17 Mar 2026 13:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B206B00A6; Tue, 17 Mar 2026 13:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE766B00A3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:55:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A0AE140331
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:55:41 +0000 (UTC)
X-FDA: 84556307682.23.5E11398
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id A73C91C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:55:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjaAZX31;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773770140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qTYVKV5nb5ayCDEY32vWKZpQOz0lpO2L66vO5Fes22w=;
	b=ud5LXmthJ0Mo1WU5KHIU6bSS78rG/QIpFEDffT+WfI1nqOl7hcpzvhmqgjnvaoUojVivC3
	BouO6nhE/jwfzYcEiQjbVfReVyK8DCMVc69fkHn5XD8lmQ2IDTMvXlnXIohXVnnaS2fw5U
	wm3PDXyRsm28pk1w6qdg4k1dBb8qRBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773770140; a=rsa-sha256;
	cv=none;
	b=7vh6QPcrr97gn5fehRm7oM9nsgtmtLLKMKMCC97CsSSbhc6bAUyFHXEOnwwewOZyJaSMcR
	UE1V9VBjYhdm6UK1/nSImmmGYhC41JReMtgf67S1AkuxDC0h5WMY/HjF7d0IRErHazCS0G
	uA9cp69H+sV6nIgEAH+OhdFgQ8LBPhc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjaAZX31;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
Message-ID: <ae4ea01d-a30e-4085-ab4a-578dcfcba82c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773770136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qTYVKV5nb5ayCDEY32vWKZpQOz0lpO2L66vO5Fes22w=;
	b=pjaAZX31HfPv0EqxBir1wrcOT4ZRPxKDxntVvAAZnr7TtTsyDgri1szGW/0d/+Frj9Xeuk
	t7xO1e8UeWMQMiTSIl9JwrugHVnaKhHQL+RxC/k1YCPYhdeKUYjy/J7ZJURqccLLxMt+mv
	oj2tZq7fy2Z2lQJEQ91Eaz9CEFmhq2c=
Date: Tue, 17 Mar 2026 10:55:26 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 akpm@linux-foundation.org, mhocko@suse.com, apopple@nvidia.com,
 axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
 david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
 jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
 rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
 rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 surenb@google.com, virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
 <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
 <87sea0o55p.fsf@DESKTOP-5N7EMDA>
 <0d66401f-9874-4047-971b-632723b0b7ee@linux.dev>
 <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87a4w7x8d0.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A73C91C0002
X-Stat-Signature: r5dngbtfy7z5otz5ejfjih3pnp3czzam
X-Rspam-User: 
X-HE-Tag: 1773770139-586169
X-HE-Meta: U2FsdGVkX1+eOxWQ9iMZMY7FNoUnT9yTTSjOiJxs3KHgKg3TeqL7HXNbc24EkSkQZs/tYJ+Y9hQbzx1378IMRqSj96xMgQiVfUdbOisktBxQcqA/nwkFLQmkzVdtspKHFZa8oGiUJF0OYipBKUfuxn9i+7k4Aw0Spa+Bgbe7q5DYbEw5hJXyWDU8tYmw6HCSomz4GyhJ1ZjlruZsllp1/Q3VQKatM+W/KOiXB/Z2fXDjDPLz0Nf0JLAtU3Ltoz14K5K6kP45rr5hZgeHHLy9G9DdUP7LxhZ76lBA+iT3d2QVrX2++j7u8Dq0t1l7mkoEwtvXDg+px19pi110REXkQyHH8cG4SwKU2XmwRee9xHyswME/paUBR0aOuOochJWZAM9NcxYzTmiGA9kMYPkYZC5O7hipeuX54WNS6smeOktWaXkdBH0CZJq4/8pVDFY9xiWOcNLntr71dGJGeNM6WUFOCOK/f4FbtGv9NB8QQoyycLXobSQaGHcGcZPzcItC/dolguGmcAkTNQWqHsiXWyX756nCed9dxwPHsqVS5bl/UgiPtN/BvIk3VugVFMMR0+U+LJFHE25U0SNcp5koffojamLX6rub9CG8ik2oic37z5wVIZEG8RGhkSTVflWhdvgLu6Yd9HCKAULjYG1Giyh4Sn4qhuRLbDsf62LLPUI58I0TbO0GB0eNQ/bkP0R0Chjl/LhTX+MGz7OlgFDpZsT+YBrmUYS6cnsXz7SD6fIPnd5BQ2yYaPLt6doj3uzpTzNqx5LTIqs6juMbvojTHbtSwF6S7+0JdK1zBIK4KBJ00B95mh2Ih69VD3ijK3JMc1PRrgLtEmBWqDrmpv8xlVZHnwWC/yLo0xuY2GRw0OziuwAsIfjRF82wrVeuB0QUoaKOZ/pRzSYIMBrOSKm+hDl1r3/IfZJCuL15A9R/RbXyVDkLrMjfcFoviKNPG6bdnuCMqqzb0A64XIRMMqQ
 hitDd/y7
 +4vD9yThHFZlWeWRFmotKatk8G0p48TvmYdEwLBb5GsVmR/cYNTIuY8CJw9VlSDSWv47ocxwE3R39SbgVp047Y4QXLmgiSKadm4dLL4XsYsx1rZTOokOEbqPktf1ZdGlkEepqzhckBFA0gDbrP12VRhnEbEuhf3VameSU/d6M2GudiNZPjVXj21z/y4G/qginyYkGl7kxytuHEGEpjYSDHpjx5h0zFjGZUbtrHl6nV03LKTkZ5b2Ni6JKdpFU+94l9qBIlZyF7L1JJlIGwJ4pkIStxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 11:44 PM, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>> On 3/15/26 7:54 PM, Huang, Ying wrote:
>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>
>>>> On 3/13/26 12:34 AM, Vlastimil Babka (SUSE) wrote:
>>>>> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>>>>>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>>>>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>>>>>
>>>>>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>>>>>
>>>>>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>>>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>>>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>>>>>> already proposed (visible in quoted text above). This would still
>>>>>>>> provide the otherwise missing signal of whether policy-driven
>>>>>>>> allocations to a node are intentional or fallback.
>>>>>>>>
>>>>>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>>>>>> 3 new counters will be global per-node in response to similar feedback.
>>>>>>>
>>>>>>> Emm, what's the difference between these newly added counters and the
>>>>>>> existing numa_hit/miss/foreign counters?
>>>>>>
>>>>>> The existing counters don't account for node masks in the policies that
>>>>>> make use of them. An allocation can land on a node in the mask and still
>>>>>> be considered a miss because it wasn't the preferred node.
>>>>> That sounds like we could just a new counter e.g. numa_hit_preferred
>>>>> and
>>>>> adjust definitions accordingly? Or some other variant that fills the gap?
>>>>
>>>> It's an interesting thought. Looking into these existing counters more,
>>>> the in-kernel direct node allocations, which don't fall under any
>>>> mempolicy, are also included in these stats. One good example might be
>>>> include/linux/skbuff.h, where __dev_alloc_pages() calls
>>>> alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
>>>> zone_statistics() and increments the stats.
>>> IIUC, the default memory policy is used here, that is, MPOL_LOCAL.
>>
>> I'm not seeing that. zone_statistics() is eventually reached.
>> alloc_pages_mpol() is not.
> 
> Yes.  The page isn't allocated through alloc_pages_mpol().  For example,
> if we want to allocate pages for the kernel instead of user space
> applications.  However, IMHO, the equivalent memory policy is
> MPOL_LOCAL, that is, allocate from local node firstly, then fallback to
> other nodes.  I don't think that alloc_pages_mpol() is so special.

Sure. My response was based on how you said, "the default memory policy
is used here". I took that literally. I agree on the behavioral
equivalence, but the important point is that no mempolicy is set. In the
v3 patch which was recently sent out, I'm using that aspect to
distinguish between allocations with a user-defined mempolicy and
allocations without one.

