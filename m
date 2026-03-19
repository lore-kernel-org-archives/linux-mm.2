Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC15107528C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF436B0456; Thu, 19 Mar 2026 05:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A64D6B0458; Thu, 19 Mar 2026 05:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3536B0459; Thu, 19 Mar 2026 05:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08D0E6B0456
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:56:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A81C81B7F05
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:56:16 +0000 (UTC)
X-FDA: 84562357152.30.DAAD508
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D760510000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:56:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o/Bn67ZO";
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773914175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmlQs8wI6aosmdVxVegh7wB+LUuXXQQl8Feb/eB1eDQ=;
	b=nt9Q4ajrPSHGIbOjOZ5Gfq24wglHLKoAJxqmU6vfzQAT7vfmsDXlZWZjoZA1jinpUl/lVv
	Ccy5R2ptm+7k0JSw+rY1uqHALUL/yBJ20ekPjUCWYMOYVpBx9+WmO9vuO/Ny4UU0Ix1F/G
	HhdJlXPoj5O3HxRlup8vE2pZpYDYWx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773914175; a=rsa-sha256;
	cv=none;
	b=XsDUR2R9w3Eut3vhbEbuW2s1KjOKVfowY7/jrCnVYSy5ZtMsjdr36ZBFdcbSD79icY2wPs
	jmWQl5SRFoU2umugzmAn8o72/KEO63tFNTFNQ95xCpc1iJV/Hb0eanM4f3G1MUTq/5Ffuw
	5/DD/+4BfjTc82P0nIjm5FGxCPGGPNc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="o/Bn67ZO";
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 819AB42E10;
	Thu, 19 Mar 2026 09:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC9FC2BCB0;
	Thu, 19 Mar 2026 09:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773914173;
	bh=5G/vGGrJFlyZkBw6i4ZO0sI4EvAAeLzyR8YvwdxaSNg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o/Bn67ZOtNPoDkqX6lXGQV7UCaIGeeMQAculkBxI+kdSlXxAyu0q0lWr4If1pdAuD
	 gEcN/pwqJuWKevDN7sD45/H0KGtIge0ep9qKjpKLyMjaVNjyp6EmdFin0yOebDnuFn
	 x0E5nUrLIWXXnrbK5xNbkm4m9gdVLvvIgeSLF71uhzPyjSEQ5HgKm54eQMqrKJOJcH
	 suPFVsq1c0N0P1K4emQHbgVBYeJxvpnGiZJGe2bjdk1xTotNFZtbqwYTsbbb6kV7yk
	 s9ZQkcQOfqXA63emzhWsZM6q2+lcVuzTeOKRu1BPiNC2BqPohj5/6J7LrvxQfzCzt/
	 X4rcCYAxXZ3cA==
Message-ID: <5d10a43f-15d0-4af5-bacb-9924629066a0@kernel.org>
Date: Thu, 19 Mar 2026 10:56:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] slab: create barns for online memoryless nodes
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
 <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
 <4xvvslwdcqafc2yfthpgv7panejdgmbdoueqiqkaeikohjutgx@3imnb6zlk6ew>
 <4659c675-6949-4295-b385-1ab26921a975@kernel.org>
 <jwlqiygxlch5gq6g3vkwynrpndjwcoxwice2hmvim3tvdfubp4@je5ldr7pa5f6>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <jwlqiygxlch5gq6g3vkwynrpndjwcoxwice2hmvim3tvdfubp4@je5ldr7pa5f6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: paqhrdrbemq8f7zp3tqnbqnxp388scd4
X-Rspamd-Queue-Id: D760510000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773914174-701684
X-HE-Meta: U2FsdGVkX18Rq0r5UkQNWY5M/013yNpGGfiUfg/o0TVMOnMngVJRewZDhOLtLYQbr8UU/h4U0hQCi5DeDADQLqBRsoZ2NF+XXITdiSMV/h1ly5g0xSF9rLRP1VxusAp16D71dasDnH/cCzJE1YbVv7379/5NDCeyqM0ZB4rJex1N2kcgV6slz8xDLBVo5XRVJ/uJnH/5kwBcreS6LdED2WauzqqLsN2MA66Qv1vhu6Zxj1brAL3xubf38RuiIyhxenvuyMb0GmnI1sBHsfIvqFUueJNGfa0xNxu7DuYTDLFg7lGmWJo5VrJwA7EC3qyem68ExnG/rMUWOJYjafJqvoM77rDd846Diq7JtORujzIW9tnr1UEMaijwT+N7wA4kU8qqbUsfkZcWztrZTSbf+kTyBO2xEufuuUpBjbpSjiheF8GV31NKxImLqfZJBgMCu77YO3GhbGXIjqvPiJ1MvjCs/ylBcodMqgxhitpKMhvwbRGpzvflFjS3XHAbkFpMTti9dcgEjfPXbRsAUHqRylMI6/0RHvOF1n+hLwH8Pzfpixnz2CUpcSsJ/92bTNdkVmhrhgA26W9VWOu+AwTIPs4Guvsl+aHc6qk6mH+O53N0qOWrETjihBY29l/kclsx8D9JDnc1qSRt+Q2DdRhTOnTzkjJM8a8qY9dDzqstQoBMdT5dGgROvjGsPlP1AKEcJjYx252WoOC9DzF6a0/c8VRZwd4wI23+yHOWu+jIVMVRM1dQSEOG+FFgL/GaIA+At4aLCL9NJpf2/Z1JKVKgUXxIv+DeOULSS+84UTCvD+br285qt1gr65brkZXbMl2AR59VdW2TQNfeJThvx9D0VW0KbqP20RlIfRbh/qDDEQuklKEmeQlmhQ7PHSWDjb71Nfic/r8vDd4zEKBADuqWTr9t2p3eV7x0qKFyaaN4+vZKOYyly/5lGR4sVrgYoSikS1kMecmBvKa4YPeybr9
 p083mALJ
 pkmfeCFFkzUrWsfNfbhwfqT4ZT8neRWElNHL/l9jjNF9ILM7wtk4cmoZHkvPDEFAHLjNgiAeTUbMsK7EoGIrJOOv29L7gCCV/nSM+bXkP59DLF0Brmk7iAImD1DLJ5erwW+TWMRfyvh9ePLK3gNpfxpNOBg0UegMgIe36wQkllCs8xnAbriEKHvJG+xQuE06KI0vs5LHBZuhUWwhiLyOlpRP2g2UlCTtwZwh3sl7po7W565LsZP4djGZOcQ8T0lwpGwCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 08:01, Hao Li wrote:
> On Wed, Mar 18, 2026 at 01:11:58PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/18/26 10:27, Hao Li wrote:
>> > On Wed, Mar 11, 2026 at 09:25:56AM +0100, Vlastimil Babka (SUSE) wrote:
>> > 
>> > I had a somewhat related question here.
>> > 
>> > During memory hotplug, we call node_set() on slab_nodes when memory is brought
>> > online, but we do not seem to call node_clear() when memory is taken offline. I
>> > was wondering what the reasoning behind this is.
>> 
>> Probably nobody took the task the implement the necessary teardown.
>> 
>> > That also made me wonder about a related case. If I am understanding this
>> > correctly, even if all memory of a node has been offlined, slab_nodes would
>> > still make it appear that the node has memory, even though in reality it no
>> > longer does. If so, then in patch 3, the condition
>> > "if (unlikely(!node_isset(numa_node, slab_nodes)))" in can_free_to_pcs() seems
>> > would cause the object free path to skip sheaves.
>> 
>> Maybe the condition should be looking at N_MEMORY then?
> 
> Yes, that's what I was thinking too.
> I feel that, at least for the current patchset, this is probably a reasonable
> approach.

Ack.

>> 
>> Also ideally we should be using N_NORMAL_MEMORY everywhere for slab_nodes.
>> Oh we actually did, but give that up in commit 1bf47d4195e45.
> 
> Thanks, I hadn't realized that node_clear had actually existed before.
> 
>> 
>> Note in practice full memory offline of a node can only be achieved if it
>> was all ZONE_MOVABLE and thus no slab allocations ever happened on it. But
>> if it has only movable memory, it's practically memoryless for slab
>> purposes.
> 
> That's a good point! I just realized that too.
> 
>> Maybe the condition should be looking at N_NORMAL_MEMORY then.
>> That would cover the case when it became offline and also the case when it's
>> online but with only movable memory?
> 
> Exactly, conceptually, N_NORMAL_MEMORY seems more precise than N_MEMORY. I took
> a quick look through the code, though, and it seems that N_NORMAL_MEMORY hasn't
> been fully handled in the hotplug code.

Huh you're right, the hotplug code doesn't seem to set it. How much code
that we have is broken by that?
It seems hotplug doesn't handle it since 2007 in commit 37b07e4163f7
("memoryless nodes: fixup uses of node_online_map in generic code"),
although the initial support in 7ea1530ab3fd ("Memoryless nodes: introduce
mask of nodes with memory") did set it from hotplug.

> Given that, I think it makes sense to use N_MEMORY for now, and then switch to
> N_NORMAL_MEMORY later once the handling there is improved.

So I'll do this:

diff --git a/mm/slub.c b/mm/slub.c
index 01ab90bb4622..fb2c5c57bc4e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6029,7 +6029,7 @@ static __always_inline bool can_free_to_pcs(struct
slab *slab)
         * point to the closest node as we would on a proper memoryless node
         * setup.
         */
-       if (unlikely(!node_isset(numa_node, slab_nodes)))
+       if (unlikely(!node_state(numa_node, N_MEMORY)))
                goto check_pfmemalloc;
 #endif


>> 
>> I don't know if with CONFIG_HAVE_MEMORYLESS_NODES it's possible that
>> numa_mem_id() (the closest node with memory) would be ZONE_MOVABLE only.
>> Maybe let's hope not, and not adjust that part?
>> 
> 
> I think that, in the CONFIG_HAVE_MEMORYLESS_NODES=y case, numa_mem_id() ends up
> calling local_memory_node(), and the NUMA node it returns should be one that
> can allocate slab memory. So the slab_node == numa_node check seems reasonable
> to me.
> 
> So it seems that the issue being discussed here may only be specific to the
> CONFIG_HAVE_MEMORYLESS_NODES=n case.

Great. Thanks!


