Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE10CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49976B0092; Mon, 12 Oct 2026 09:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA816B0095; Mon, 12 Oct 2026 09:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9FA6B0096; Mon, 12 Oct 2026 09:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91E676B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:52:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BB92A8EA2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:52:52 +0000 (UTC)
X-FDA: 85314114984.16.0D7073E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A0251C000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:52:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4D7CJZi;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791813170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9zvoH+Az/uKJAB5P1uYqjIh12NKolhbo6fDlfYMw64=;
	b=WxebuvhaXKIXsTf9AJK3FDzWD6A4DHAp3OY51KAqEPQb9bzKa0dTxDL0i8RXsWz8pK1KA6
	rCMOSSEIGCQtyidlDAwp4pp91dZCTSqLgig15EXAnRTmXALTSuCej4By8IwE3gnn0IfA1g
	f0ieEoSpwF96sx9TwGhpKJzDfHrh60Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h4D7CJZi;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791813170;
	b=DVdkhGC5Nc4CDXae6STdcCoMpUisnNVRlvSetjzzD/ExnPXrLUrXtYNNc4xCxPDaHBElL9
	Kk0V8AcH5uI2eohl/m1Zm7S9GHuLMTfmL9YVSwxpU0+JWUt27tF9XdtctV0DwXacHV1lxG
	MxZGLXXj/XlklOt2gnnnfR2PJ89wdfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1D804034C;
	Mon, 12 Oct 2026 13:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4261F0089B;
	Mon, 12 Oct 2026 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813169;
	bh=F9zvoH+Az/uKJAB5P1uYqjIh12NKolhbo6fDlfYMw64=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h4D7CJZiCRGU+lPZNmqJvvEAhNSYLhq9GPvvpK7JAaEosOCbCqrc/e1vDiTCifuwv
	 GIaKs3DvMIyAGi/IX56wBYQLO8TqaOUHt5GiIKt28T+cezs8pyCeCRM/lKscYihELm
	 7dEcJMPE8V7cmMDkzLUzQV7zjTJYClCewLD1RpnBVm7glxBNyO1E4c7NPWINcLXiZd
	 lKSsnoozEOoy9p6OkGhHgTMNtbCaOnzR2zxcIbHptpod3PyPWB5Q7aFmeS8Cp81Gmk
	 h0BHrs+VLm1tvYXY+jntzjQn5CDroi9CdjHAiZWwYUdRe+HHYeja44ClQWRIaimzM/
	 l+5eIWxHtiXYg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  George Guo <guodongtai@kylinos.cn>,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] kho: fix global scratch size calculation
In-Reply-To: <asC3-4WNiTF3n7l1@kernel.org> (Mike Rapoport's message of "Sat, 3
	Oct 2026 10:08:27 +0200")
References: <20260922131217.698809-1-sourabhjain@linux.ibm.com>
	<asC3-4WNiTF3n7l1@kernel.org>
Date: Mon, 12 Oct 2026 15:52:46 +0200
Message-ID: <2vxzo6czjaa9.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A0251C000C
X-Rspam-User: 
X-Stat-Signature: p585ssds4psf3dyu4bn3i1ziq7kmeziq
X-HE-Tag: 1791813170-569838
X-HE-Meta: U2FsdGVkX1+oalbrhkdcpKnxuoNJ21Z3Dgm0IHRemWqI6iPoe5k5n9nYw9g0l9Lw2QvtZ4byH29rorPGX6AD9iW5ZIPsWiZZCD0X9lLEDVYx+24bNtkLvKd/00A9BVAr7DhHj03+ZLOWmjRTauYyL005vwLnWpYHJP50ZJd2AQR1qGoVs89Wmj2WxaZ49MSp7145YMC4951gySxyoR9FCMvN3aE146h60hdvNyMKI0qujZMXOWKorW8xFLnEUqOa+TmGHb4OBvsF6kkLl3AYn03XUgN2J7djCAO+4NW0fRQhb8tM2PR3+IbdTpVFlNKoBXvaSo6XKM4v3V5pljrnM3yE9C9o06aiCkp0BDoVSvq9OC/xkCYGD9Kaa9EeiFZoX5emlNFIG+IgKXL0gCP7WQkvTQI3TjIJRNRmjDvQzfjqz2T176Su0prRV7lD1TkUWzrycWaxK9YbnazBfVTFCfheedjLMfiRtxbUSol1eqrZGHZsdylYJ8bao9tmKaqP8ddRRBRS88LQrQf73bWCBrlmN0ex3WpglAHhEEatQBIqVjJuGTkqAoCxJ7aHShyGZLBEW4UxdjaJBxWv/g8mJ2Es3fMkr9l1aA0nTT9IFIBePwU17HirqatCL7MAn0/EESA1Bq9WVUx+wXjf88kfgSRgQTxEckTLi17kygCOv9ku7Og31+T2P/0oC4IPucLnk6u9kxGxM/rAoKuWiZkrWUu2Wo0Whgkqzyf58cBwjA9A4QvkyWYuQRWU0+cM2EDjSD0Zaq+NobKc6OExIo4U9TMIlhR5FTIjgEiw+thyvJh4hldVvRMXnfpvsm33g6HBGDfAc3gqsnc0EfYdUwo6/cL3v8GI89MsGI6tjCM/2PcK4VnBOLS6OK3V2mKSwfL6+sYU8gq8jjOqvQhCyfUFO8bLa36MLCeI4FS+m09k9yVUvfyoWI80leAY7OzGou70HQ+rpeIw51dmSM+czMT
 TBJZTaQJ
 PnmlKlUdJBKHDUjhXkoGWsmqbiJKce2kI74xjWu+TIZWFXTNP8n2sbgqbIxLY9tr+gEA6XP0GQhFPdChTC9zvyGUcKxv0UL8q5szOC9aKO6twtxDKvQJShUdA74WdYbYFPvucbYjGtzJCTSN8d6BRCK03KtM6vTVEuuGihijO0JWW6qQzD2gT043CwFAPdgCsIBFJ7QVNrvQZb1mN9qqbHPTPnSauzmZgaAyttRr4Lx+tJC8qS8cECZR7mhSW6VKY1JqZCyV8IbzHudL0Sg54KkSSPxTkp/pN37ZX3KBhn5WQkZwLBZrldOEePkp5bGY9pmlRuxLu31IWICxRqfGC3sbFWBUavgBRMqCIj7vt/7T0/KTvZA/fagLH5iq6R4Dcaq9K+g/yplMkUiuhDeZ2ABb4BKAw3x7HTt3jrunIH/H8/eHFHkB5MLd7L0xOvFEhPjF3e15IrpZQP9wf2BmvWnSsLcrtkknNQHUsUZi242EOnny6JCkac3Br7Nhdopq6VL4Cau3wotYEEPQDxyqb7PWuaNbk1mgKzWGaWZtgEge4ecedFQC6+UObHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03 2026, Mike Rapoport wrote:

> On Tue, Sep 22, 2026 at 06:42:16PM +0530, Sourabh Jain wrote:
>> KHO calculates the global scratch size based on memblock-reserved kernel
>> memory. It passes NUMA_NO_NODE to memblock_reserved_kern_size() for
>> this calculation.
>> 
>> When memblock_reserved_kern_size() is called with NUMA_NO_NODE, it
>> counts both:
>> 
>> - memory reserved for a specific NUMA node
>> - memory reserved with NUMA_NO_NODE
>> 
>> KHO needs to distinguish between these two types of reservations.
>> When calculating the size of global scratch memory, KHO only needs to
>> account for reservations made with NUMA_NO_NODE. Reservations made for
>> a specific NUMA node must not be included in the global scratch size.
>> 
>> Add memblock_reserved_size_nid() to calculate reserved memory for a
>> given reservation type and NUMA node. When NUMA_NO_NODE is passed, it
>> counts only memory reserved with NUMA_NO_NODE.
>> 
>> Use the new API for lowmem, global, and per-node KHO scratch size
>> calculations. For lowmem and global scratch, count only memory
>> reservations that were made with NUMA_NO_NODE. For per-node scratch,
>> count only memory reservations that were made with the corresponding
>> NUMA node ID.
>> 
>> Remove memblock_reserved_hugetlb_size() since it has the same
>> implementation as the new API and differs only in the memblock
>> reservation flag being checked. The new API handles both kernel and
>> HugeTLB reservations through its reservation type argument.
>> 
>> Define the new helper as a static function in the KHO implementation,
>> since it is only used by KHO and has no users outside
>> kernel/liveupdate/kexec_handover.c.
>
> I looked again and this feels like a band-aid to me.
>
> I think we need to step back and rethink the order of the
> scratch/kho-bootmem sizing and consider how NUMA and lowmem are involved
> there.

Could you elaborate? How else would you calculate the sizes?

To me, the idea sounds fine (although I also share your comments on the
code style). This is what the global scratch size should have been doing
from the get-go. Today it over-allocates by counting both global
allocations and _all_ per-node allocations.

There is a separate problem with CONFIG_NUMA=n, but for that I think we
should just have a different allocation path where we only do lowmem and
global scratch.

>  
>> On powerpc, the difference can be seen in the scratch_len values
>> reported by:
>> 
>> cat /sys/kernel/debug/kho/out/scratch_len
>> 
>> Before this change, the global scratch allocation was 0x12000000
>> (288 MB):
>> 
>> 0x1000000   (16 MB)
>> 0x12000000  (288 MB)  <- global allocation
>> 0x5000000   (80 MB)
>> 
>> After this change, the global scratch allocation is 0xd000000
>> (208 MB):
>> 
>> 0x1000000   (16 MB)
>> 0xd000000   (208 MB)  <- global allocation
>> 0x5000000   (80 MB)
>> 
>> The 80 MB difference is the per-node reservation that was previously
>> being included in the global allocation.
>> 
>> The same issue also affects lowmem scratch memory, but its impact is
>> limited because the lowmem scratch memory calculation is restricted to
>> the first 4G of memory. The changes also cover the lowmem scratch
>> memory case.
>> 
>> Cc: Alexander Graf <graf@amazon.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: George Guo <guodongtai@kylinos.cn>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
>> Cc: Pratyush Yadav <pratyush@kernel.org>
>> Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
[...]

-- 
Regards,
Pratyush Yadav

