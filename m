Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B70107BCD5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 18:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8242A6B0088; Fri, 13 Mar 2026 14:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1256B0089; Fri, 13 Mar 2026 14:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A98E6B008A; Fri, 13 Mar 2026 14:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5900C6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:10:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E33D01402D2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:10:17 +0000 (UTC)
X-FDA: 84541829274.15.C0E73BB
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F9F41C000C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:10:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YEvWVGE/";
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773425416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUL9iRVLMyXGemsBV+GDYxg+OBxgQpSH1wtXeqP+d0s=;
	b=U/AqBtYVcGQGLpRs1r1Y9cmbpv6Zt3d2OoQnRtWLJun9EwYPtLmR8CYrAjjSlTL3BQtD2X
	NfMmYU+Fvf9N6cTVnjVjVivQ1vnqamwxcMueiIFEnUk4U7IDuCs5/wtLx2rNdwyJWdD5bM
	gis+/Zg0spog6J6A7QfbFgk27Jv5sxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773425416; a=rsa-sha256;
	cv=none;
	b=QumZXG0V22S+fh70+cearVMtmAY6PqcX/o2UG/uS3tvtKJNLOC4M8KPn7TW36jM+koR7qd
	2Jix48k/EwDNLuCmezaRNTuRmcEbileYfCiimkMuYKgX5yi6SIx4S4gN8uhvC3v78ZPiqf
	9Y3WrXriQSonD46OvKweR9rQqU1Ps+8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YEvWVGE/";
	spf=pass (imf18.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c4e5cc3c-5daa-404e-8c55-cface8aa969d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773425412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUL9iRVLMyXGemsBV+GDYxg+OBxgQpSH1wtXeqP+d0s=;
	b=YEvWVGE/vbF7fkuKv1vaaemG2cWn8qs3WvDY8NQ1y92/L5WaA4y8MG5AlMSRpQflNu55rL
	JiqeO3Gw3ND+eHIqodiU/8IaTA9IT4Ruj0jRn7q0b3QRLggJP8MAfKSlRAyVQSzvJgf6Pg
	vT3r6XXfYhTLynppaDvP8cT1KQr7IdU=
Date: Fri, 13 Mar 2026 11:09:58 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
 <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F9F41C000C
X-Stat-Signature: g57e9qrqx7xnifcp1869fgneab186jp4
X-Rspam-User: 
X-HE-Tag: 1773425414-838055
X-HE-Meta: U2FsdGVkX18PgX7hbwP9e0IDwgCb7PTDYhFLSysmCy2kwp+3A0wQlvT3guTiGoDGdq1aEluI4l2lgc/JM7zQEqsdWaz04lky56ghZigtGM5hJbRf++gpAJVizLprrd//ChwtVIIkApIvA2tXFBoLytfSe8HKzw3ZYAoBqcyX2CWUswfroenKEDlwDeKJpES6wwnD92rm90DkzYoqBLIMGWD3py7AemHXF7ro2ej+2YD5WwbS0m4E6Fmnxzk35+jcyaQH/IpjCwNiVnfpuqzFPTU+v4q3BtazwC6VZAedLti75VcfZJ1cJyIpLDVx2/GZaOtZwkTFeEH1ceB7T8l80ZBN52Mfqcbw/ouTTD4dpIKpNmkQFXx/AV2nj5l7YwketP4LGjDA3xnaYWRA5xyCl8oDb9xm/g/ToLEFci9GO7Kaykly0B6PbW+l+um7GnMRfFaVeO8K3VfR6odtdw25mwclD/NA4ZTTYjxRb4u4S8OcqGxjGIp9Yud05UlKEsHcFtGMXWH/qx9Pk+n40ZRuoNNyClpzyMrq5pDowxrBbgj+X9zk9Xbttwh935HHPwDyVxsoj1p2+22Pqhg/66oPgVeERRxEfhgJdqQ5IDWrpnxT7zl9eyMI4hC8I8gshjJvAmuOF0wXFW/4dNVk13VRynIXZq96b4Og+Cv0LCHcIQsWHhgSvHKbbr+yG6rU3mZ5Q0M5zaIkpXay4P8wK+jKA0sZKF/QmEB8Zh93DfaIjIhmr+jBuUz43TTlWw+marriDX0AjbPhMmWnlpVKoHvjCDvkEPPZPskVwRap6WiH/LzOqxCnsgWp9Pf6OWj6bex6ZCUMIkqZrJu+FD+u8KZrx8/qx+8xlXvGC2kc8QuvIgW3sq9bFH7M3F+wBIBdjXhn6TpK9VzNq/rMjkjPmA9lkbuaKFyM088+xiW8X130itJdsqyqVZDlJCWyG3ugvaLg638NGlduwu+a+wF7DHf
 L4goPfMP
 oE6LMYj7iKDnzx917zAGYhGIARsBhfgRieXtmWllw4qTpFV5/pYfXpVT6zmxVPUhJcqc2/MCRMtk7hKGlfP5FhMGbKked11X3egd28aZVfYW2ocalqra2HghaYdyur4iSq12D8RcIageNmKZFsco4fhIfIH4h3+WmqanEarnjgIf6DFOZcWgMYebQ8tlynm2l3Uginx/XrNM0KPre/xgL/A3j/yegIZWnNixH0ddQosiF3HqRQSPtAEo+gVX1zQiRpMFrShNY4WJ6+TU1Ydrvu454TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 12:34 AM, Vlastimil Babka (SUSE) wrote:
> On 3/13/26 07:14, JP Kobryn (Meta) wrote:
>> On 3/12/26 10:07 PM, Huang, Ying wrote:
>>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>>>
>>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>>
>>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>>> all policies)? They would follow the same hit/miss/foreign semantics
>>>> already proposed (visible in quoted text above). This would still
>>>> provide the otherwise missing signal of whether policy-driven
>>>> allocations to a node are intentional or fallback.
>>>>
>>>> Note that I am also planning on moving the stats off of the memcg so the
>>>> 3 new counters will be global per-node in response to similar feedback.
>>>
>>> Emm, what's the difference between these newly added counters and the
>>> existing numa_hit/miss/foreign counters?
>>
>> The existing counters don't account for node masks in the policies that
>> make use of them. An allocation can land on a node in the mask and still
>> be considered a miss because it wasn't the preferred node.
> 
> That sounds like we could just a new counter e.g. numa_hit_preferred and
> adjust definitions accordingly? Or some other variant that fills the gap?

It's an interesting thought. Looking into these existing counters more,
the in-kernel direct node allocations, which don't fall under any
mempolicy, are also included in these stats. One good example might be
include/linux/skbuff.h, where __dev_alloc_pages() calls
alloc_pages_node_noprof(NUMA_NO_NODE, ...) which eventually reaches
zone_statistics() and increments the stats. So if we applied the
hit/miss/foreign semantics in this patch to the existing counters we
would be mixing allocations that are in and out of policy, losing the
accuracy.

The new 3 counters I last proposed (in an effort to reduce the amount of
new counters as much as possible) would isolate mempolicy allocs and be
named to reflect that: numa_mpol_{hit,miss,foreign}.

