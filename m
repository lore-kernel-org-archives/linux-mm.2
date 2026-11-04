Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BCAE606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 12:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bjt0GwCP
Received: by kanga.kvack.org (Postfix)
	id 23EA26B05B2; Wed,  4 Nov 2026 07:13:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2626B05B3; Wed,  4 Nov 2026 07:13:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A056B05B4; Wed,  4 Nov 2026 07:13:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C73336B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:13:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFDA5A757F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:13:31 +0000 (UTC)
X-FDA: 85397327022.17.51A727D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2815C14000C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:13:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjt0GwCP;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793794410;
	b=C3mPS0y2yRxLiTaL9MhZEBoeVRcLE2XZso8d2vVtDsNe4XaPYpOE/9KEoIyII67rfYqL86
	as166PJgNWhkSKJUxQpb5v9rkw+7YfnlD1/CGmkxbRsZFVRXxDQHIjCId7WFIc6LbqECqv
	0bwTqYlugo2Wetz/o1VNAfPDoDsKIuA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjt0GwCP;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793794410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xI1Euu70YUflyL8kMW3VkLtf2BBOiDl/YP7uIS54om4=;
	b=6uznii+IK+je34QuqETDWJ4lQQTLunrVYxQ7cJqDYMrhxL/U5+BqriFRKUOOh+sUBoAVaa
	I+2Kdw1+LWSr34kGeNi9lV2dEIs6DMnV4J2BIdWpQYH+D+iPyqY5fue3PEc9rJbPjrMJ6J
	aFwVmTZdw1ITMBIkxNSX1Ob5jILKcRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4767143CCD;
	Wed,  4 Nov 2026 12:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4871F000C1;
	Wed,  4 Nov 2026 12:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793794409;
	bh=xI1Euu70YUflyL8kMW3VkLtf2BBOiDl/YP7uIS54om4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bjt0GwCPsVqSBZmBajC5cqnTxurvBTha5TBGNnuGjMcY/0RTazrh5fIHq8bFWGQJZ
	 Sl3ZZM5n6doE/Ftx4asgxVmHQR2R1O/dLRdMTU+uCRc5KobE6A61lhMFJxz2AAXL/n
	 mwLfVnHy8mP8qKSgleVvE0YCsvOODm/0zkLprwAHYenBDBa5Hu96BT20L6ne2x8mqc
	 eaMc0NaaRIaVF4HKwPhtv0exAzuTDF+YQSqiLvhEhZtocQ5lU6tno7VrHd/Ukf5JPF
	 lv8lFVhK9j8reWbzfJSRVa1gx4MjwWy8dUqz65qOkXdM62ndm/VwxfOTM4FL5S4tPK
	 yqE/KXNjxSACw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Andrew
 Morton <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,
  George Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,
  Sourabh Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] kho: fix bootmem sizing
In-Reply-To: <auopkIsiqxzg4anJ@kernel.org> (Mike Rapoport's message of "Tue, 3
	Nov 2026 20:36:00 +0200")
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
	<20261103-kho-bootmem-sizing-v1-2-45aa74098f34@kernel.org>
	<2vxz5wydnbuj.fsf@kernel.org> <auopkIsiqxzg4anJ@kernel.org>
Date: Wed, 04 Nov 2026 13:13:25 +0100
Message-ID: <2vxzse1glrq2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: rhpbdffwfzx993ws6a1r8s48o4xmnhrp
X-Rspamd-Queue-Id: 2815C14000C
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793794409-166669
X-HE-Meta: U2FsdGVkX18qsfepHDX1dHt1NTSukEMpFK5O7ZAVAz4X1rFuYzNGI3HMhrWtUdPQw7YVLmWi3tp+Mu0KvZKLfkJNLdJ4XgVOLu21h9j3HDRjmXSrbXGfvuUyWh8fGJdea/QO62JcpdKSbS7oxU0XxobTRFUW80xuEejUbIQiPWCAdXITVOYMxc/uPLdQ1NkimRIApCxZNmmF6QfuMt6ZXQUjXosPCqQ4Pi2azjc/TWJel+CWK8RJe7M4JTd5NaYSMjpf65m2MDv+f4zPHeKrE+UpI2N8e3bF165k3hPnwzchhJdQNRIF2k7T2qHfEyTYzWc9iwH+hIVsuIxS3PzHBOM/LnkVL7oRb7/mDnI3O4sx/5Ya7ktMmJyDeC3xLuQVlsBmqr3fMlXSG/hfOudyxoGmzF2VewZR7ueBlOQK1dNLHb6UDlWN3wabLyWITvSfvQ1ZMLXTkVGwHy6rizVe5oLMcPxxJGJvPq6tpujh+RmYB771dDxSaWrz7UAo0JOZnRkk6Y0zZ8+58CeFE9CoHFLSPjGB8ZUD96BKynGi3wSVxIH/dv1zPdbwQkVKeqJe/GdEGIbKXmQ6XUSlA3zWjag9cUJDCdAnHEYh1a7JzW/JcW5YiaRDDt4KCjEUdWLBHDueQccR6spFSli2uzuQEoVb+orxelfxXsYN924KM6O9rWKwUSreM2GKkEzfXjO1sN0kh4Ze+tOugBMUHaAtkEFJDV2em6tQ+bh9FKKYpx+W0+PeEEFuOF3jpV3ct/YF70p+vBsJdQhLhL75jOHewLR1OzGqZ9toDPHuMsvx+l9juNcBZ1VUtGH6XsD4kDendW/+JwQ5Iva1T+tXDnYFeA+6fZKroSwXtMmqVKzU8SpmuFI5FX1twiqHjnNfSqsB3M6LbYpEhBAxoivqa4u4AZlflUkW/blQFrtFWFumLTSaoLmrfCs6hh9NFyXMqwV4i8y5+YO4J+0YNSVXDwx
 0xhmmMSt
 qFkOQVeMJUobP35K/m+Vp2nD8SevMUQ3fr/PUBxnLrv5EmDJq3xRFM0v66axeXROt0gDEUnS5QUj1wD/Lyu0SFYW3qWOhtqzSXOXmjNTO9E+udTl+3zCsuazmFlZf/7huJ4ZyXc8kx1Ykig8d/UO+uAHw7CEKj7KCgKKGOdTFMlUsPhrhDyXymVrAHXO+AfN799Pean4OfGrBIil+63Sw1Iezwc10HmDpq53wImqpEVZTMOE7/A9zKc52m3/l0e3FuIU8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03 2026, Mike Rapoport wrote:

> On Tue, Nov 03, 2026 at 05:01:08PM +0100, Pratyush Yadav wrote:
>> Hi Mike,
>> 
>> On Tue, Nov 03 2026, Mike Rapoport (Microsoft) wrote:
>> 
>> > Bootmem areas are sized from overlapping views of the memory reserved in
>> > memblock:
>> >
>> > * the global area is sized from all reserved memory, including memory
>> >   allocated on specific nodes, so on NUMA systems everything allocated
>> >   on a node is accounted in both the global area and the area of that
>> >   node.
>> > * per-node sizes are calculated after the lowmem and the global areas
>> >   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
>> >   so the lowmem and the global areas are accounted in the size of node 0
>> >   area and scaled once again.
>> >
>> > As a result, bootmem is about twice bigger than it should be on NUMA
>> > systems and about four times bigger with CONFIG_NUMA=n. On small systems
>> > reservation of the bootmem may fail and then KHO gets disabled.
>> >
>> > Make the areas cover separate parts of the reserved memory: the lowmem
>> > area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
>> > cover allocations above it on each node and the global area covers
>> > allocations that are not bound to any node. Calculate all sizes before
>> > reserving any of the areas.
>> >
>> > With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
>> >
>> > Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
>> >
>> >                      CONFIG_NUMA=y     CONFIG_NUMA=n
>> >   1G,  1 node         176 ->   92       320 ->   80
>> >   4G,  1 node         508 ->  332      1264 ->  316
>> >   16G, 2 nodes       1268 ->  704      2944 ->  736
>> >   32G, 4 nodes       2296 -> 1224      5196 -> 1300
>> >   64G, 4 nodes       4344 -> 2248      9664 -> 2420
>> >
>> > Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> > Reported-by: Kexin Liu <liukexin@kylinos.cn>
>> > Reported-by: George Guo <guodongtai@kylinos.cn>
>> > Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
>> > Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
>> > Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
>> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> 
>> Thanks for the patch! My LLM caught an interesting problems that is
>> worth considering.
>> 
>> On arm64, ARCH_LOW_ADDRESS_LIMIT is arm64_dma_phys_limit - 1, and
>> dma_limits_init() sets the default value to PHYS_MASK + 1, and it can
>> also be memblock_end_of_dram() in some cases. So on arm64, it is
>> possible for lowmem to span the entire RAM.
>> 
>> Currently, that results in over-allocation of bootmem, and it ends up
>> being 4x what it should be. While obviously problematic, it should still
>> work. With this patch, all memory is in lowmem, and nothing ever goes to
>> per-node bootmem (except for the node that hosts the lowmem area).
>> 
>> All this is from reading the code, I haven't tried anything out yet.
>> 
>> Not sure how to fix this though. Should we perhaps use
>> min(ARCH_LOW_ADDRESS_LIMIT, U32_MAX) for the lowmem limit?
>
> Argh :)
>
> Maybe we reset lowmem to zero if memblock_end_of_DRAM() <
> ARCH_LOW_ADDRESS_LIMIT?

Sounds good.

>  
>> Also, a couple nitpicks below.
>> 
>> > ---
>> >  kernel/liveupdate/kexec_handover.c | 83 ++++++++++++++++++++------------------
>> >  1 file changed, 44 insertions(+), 39 deletions(-)
>> >
>> > +
>> > +		lowmem = reserved_mem_size(ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE);
>> > +		global = reserved_mem_size(MEMBLOCK_ALLOC_ANYWHERE, NUMA_NO_NODE);
>> > +		global -= lowmem;
>> 
>> Nit: Please add a short comment above this to explain why you remove
>> lowmem from global.
>
> I prefer to extend the comment above the function to say that calculations
> for global and node that includes lowmem remove that.

Sure, that works too.

-- 
Regards,
Pratyush Yadav

