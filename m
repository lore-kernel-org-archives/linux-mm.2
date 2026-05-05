Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB5FCD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30B6B6B0093; Tue,  5 May 2026 02:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC0A6B0098; Tue,  5 May 2026 02:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8E66B0099; Tue,  5 May 2026 02:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E40F6B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:23:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFB898C571
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:23:02 +0000 (UTC)
X-FDA: 84732373404.07.6FBE3E0
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id C671140005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:23:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHZ4hTtg;
	spf=pass (imf27.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHh0dwiXu65m+8y90ieqU7weX8HBYalvVIIsyXP1y9Y=;
	b=cDx61iN6nYr7YrrkCd2N+fPDPKmiR1c7DafpUIszdNRTpMogrTyfD/46oBZhSDVb58Kznb
	XRl/6h6/MvT3QeeKZv1n4qr/50sEbW0DGyFHWrlScq3UKpf/9L6Hv8BnilxV+hf8jPcFpL
	QSwe7a3kz8XSjI7fioDvvTEr/8ld1s8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962181; a=rsa-sha256;
	cv=none;
	b=p7sju2EmkWUuXtzEstzpXb/APZHakhwEs9Q20rWcQeC5fFL6tDzYXKFJUGe+dKdIVHKPWc
	JbuQuqNxBx+2MoDB79f4J+pyO94dwgT9Alk+wto5G3wspTZJJnzfQslf5iTwFtvHNAMtKX
	R2+pNJeWNarvEdfXYiHBJ1mLg4AL2co=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gHZ4hTtg;
	spf=pass (imf27.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8b0cf967-9d90-4494-8264-a28bbc498ca7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777962178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BHh0dwiXu65m+8y90ieqU7weX8HBYalvVIIsyXP1y9Y=;
	b=gHZ4hTtg8y6jfG5zo14HNGRjME5frrhxf+J2bjKL6A3di7fGL9eOHZ2jH/owC2D0IdEjUC
	opZqo47CLqZ6EP7dxnfmmsrDaqJ0wtuil3R6HlxHF7hoGxs5I/BJwnhZtxnWn/DzIYCqhj
	LZbJJRN8/wfcJzQbvIuiaY5WZEcYAoU=
Date: Mon, 4 May 2026 23:22:40 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm/mempolicy: track user-defined mempolicy allocations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, vbabka@kernel.org, mhocko@suse.com,
 ying.huang@linux.alibaba.com, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 gourry@gourry.net, kasong@tencent.com, qi.zheng@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260427151520.137341-1-jp.kobryn@linux.dev>
 <20260427141123.734c66450100c0f900e02947@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <20260427141123.734c66450100c0f900e02947@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C671140005
X-Rspam-User: 
X-Stat-Signature: g3u1zm8o8dnzfzgm856ybnr8zfq16wi3
X-HE-Tag: 1777962180-696379
X-HE-Meta: U2FsdGVkX1/DytGAi0qCs3SPXtGt3tLJq27zfFsRfpUvlmpCEQP8BRBTgcJlcgtsVsINZ0NSerrHJKlTQXiGMIXitrHSDJaAlFycbFCH2f5lalUd2MKw4G7WZeSGfKY6OlgGLkXL7avEMwn2n6rPPg7OXFCCU53RArDfz+nmiiOIj8TtzwCnLYjJ17CEP8tF2kDLrBf+BibjrsS3UtKnj78NVH04U5JjHITtKZ0z34ilhiWsJKkmBknFbJ5oUnA5pX6/jv2f2L5YhcH93nBv4A2pIB8j7B5IRO4pc42DVu40dJL0JRvw0yNRWg5fc9paTpMG5xemXhPaQMLcWBWIgl8zDD5lZb318bcI0UJLRT5JWhGmRuWVsVcAZjhRhZsX48f9eVPBkfuXTKvLrymmSOaO9TfN1dBdZpNXWD3A12GlLz1Z9BGvl63pq7koDYSURd8hM631IQTFFHyxfGzaj7RGHXBHCAwhAT0tXOSEh51XblPAaF1dexmkWrIY33LH13yMTPnvpXuFZjyGG0fFZmafkElzhRa0kqiLB9OIksveMetxMKFT27gONBHs7jhUtjITfV3Dz6nl823eUPZzsxdPl7Xp+M4t5GP1+P1JOxW2qbx5bnvJ8mark5rlUkpwJ6W0d8+XtzzGEuUUf+sw+4qpr9S8h4O/mLDN6aOa3zPZQ033jcDBw/Oyb024+iVcHBZ+fRFR0dfbYhvzS/7ckLiDVPHvC3WQvncizt5J0HuQt1vclKT3dbQt88l60Y/WlSt6DuHW+Uxrn409b/TDDIOad/XqsqD/wehSbf3nW3UcrndmgKVdyEhUrTIN18KcrrtPtysaE5zouDfdvpaxnreyFUtJTfW5bKYnEeBz1hpaB1ELmxaXF6yJ08w5CAK/JsIX5B3EdXLR8gY0LaLgyD3EiuVoP5hngjmjwY4nfvgznIVyRpNvp/w6qe6pyUvuJrPIdsQiBQs0B+QXyy5
 ummDfxfX
 +nOGrHbnGVjcIpU0WuPp370fWk+oiSfLjrzet579CRppKy/v++w41aDJSYZKyuNH8Uvtqdv7zjB94riGNy/BTUHM/bw8j1fFmZA4Qy44969IEO9PvC6XfqQtIcBtL1vDLJWV/BICUcrxmCn8BGfONcCMQHtjWMJMDnIgSKokgWLOjjtskQ3ziwpELvP6afZ0Cd8AF0+n1d67a+0Ku/1cUla3pWyQk96GmidMZoZA38/bsuL2sOmkmPqnLUsq/qsEhIq0n7sIY7t/F6c7c7ZWMMhwC4RwZdysQqri/2pLGQXNLqg5F6VjAlXWAGQPUQc0uo3f9ayxnHmclfsObJZrjhLbrvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 2:11 PM, Andrew Morton wrote:
> On Mon, 27 Apr 2026 08:15:20 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:
> 
>> When investigating pressure on a NUMA node, there is no straightforward way
>> to determine which user-defined policies are driving allocations to it.
>>
>> Add NUMA mempolicy allocation counters as new node stat items. These
>> counters track allocations to nodes and also whether the allocations were
>> intentional or fallbacks.
> 
> AI review:
> 	https://sashiko.dev/#/patchset/20260427151520.137341-1-jp.kobryn@linux.dev

This was helpful. I quoted the review points and answered them inline.

: For MPOL_PREFERRED_MANY and MPOL_BIND policies, policy_nodemask() does
: not modify the nid parameter unless home_node is set, so intended_nid
: defaults to the caller's local node.

Yes, this patch is not intended to change that behavior.

: If an allocation falls back outside the preferred nodemask, will the
: FOREIGN stat incorrectly penalize the local node, which was never the
: intended target?

The allocation can land in the mask and count as a hit but if outside
the mask, the intended node is incremented with foreign. Assuming home
node is not set, the local node dictates the search path for the
fallback path. So in that regard foreign can apply. The alternative
would be to increment foreign for all nodes in the mask after a miss but
that would imbalance miss/foreign and skew the data. Foreign may not
make sense for mask-based policies.

: Furthermore, if the fallback allocation lands on the local node, will
: it simultaneously count as both a 'miss' and a 'foreign' on the exact
: same node?

Yes, more support that foreign does not map well to a mask-based policy.
Having data on just hit and miss would be sufficient for the
investigative purpose of this patch.

: mod_node_page_state() unconditionally executes local_irq_save() and
: local_irq_restore().
: Since mpol_count_numa_alloc() is invoked on every
: successful page allocation governed by a user-defined mempolicy, does
: this introduce severe IRQ-disabling overhead into the highly optimized
: page allocation fast path?
: Established NUMA counters (like NUMA_HIT) avoid this lock contention
: by using lockless per-cpu operations via __count_numa_event() and
: raw_cpu_add().

For reasons explained more below, I plan on changing from counters to
tracepoints.

: The patch tracks user-defined mempolicy allocations by instrumenting
: alloc_pages_mpol().
: Bulk memory allocations under a mempolicy are routed through
: alloc_pages_bulk_mempolicy_noprof(), which dispatches to specialized
: bulk allocators and bypasses alloc_pages_mpol() entirely. Will this
: lead to silent undercounting of mempolicy allocations for workloads
: utilizing bulk allocation?
: Similarly, Hugetlbfs allocations resolve their mempolicies
: independently via huge_node() and allocate pages through
: alloc_buddy_hugetlb_folio_with_mpol(), which directly invokes the
: buddy allocator. Will Hugetlbfs allocations also be completely
: excluded from the new NUMA_MPOL_* counters?

It seems the existing NUMA_INTERLEAVE_HIT misses this as well (only
counted in alloc_pages_mpol()). But closing this gap with the new stats
looks like it will become messy since every individual allocation of the
bulk request would have to be accounted for. I think using tracepoints
would be cleaner for not only solving this bulk issue, but the other
concerns as well.

I know some other reviewers favored tracepoints over adding new stats
altogether. Originally I saw this as a convenience trade off because
of the instrumentation needed from a userspace consumer. But given the
challenges with the foreign mapping, irq concern, and bulk counting
complexity, I'll go this direction in v5 and hopefully get more
consensus.

