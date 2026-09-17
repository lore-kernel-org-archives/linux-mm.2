Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91FFAC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 22:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B32B6B0092; Thu, 17 Sep 2026 18:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A926B0093; Thu, 17 Sep 2026 18:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479B46B0095; Thu, 17 Sep 2026 18:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14CE16B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:53:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 888CA1604FE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:53:34 +0000 (UTC)
X-FDA: 85224757548.02.9D31955
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0492680004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:53:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWDH0coQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CWDH0coQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789685613;
	b=QajYFjF4qHFjAsEe73mNXC8Tj+EJcCAYeycPJ4utHSIq1T5Ofzmu98Faby5HB3OdF/gVh+
	7X6tYVddPQ7LACYU61RA6jyOOAp0oOZbiYOMlorrD8c9fnAS0bKevs+v3bqEGSSA+rBt/+
	Ohv6deFUk7gOdp9/ztMcYZFWSKa7VW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789685613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXOjluZcFhH/flCEevB3M2TpvgfJxkLhPY+HcD+KzfE=;
	b=L77Rg+eSf0JpUgKlS//ukcTxY8HZkyNjjhQwKSvnn7JTCSdMt2cXVkoCZrbT4xl4HhW1Kl
	vcDNo/gyafu78kB6ok/L7uSz0l4BW/OKlZb58KcRGkxTo/rFoSJUH1Zf6tDVMQdM+a7MaJ
	KvYsHHWgxuQh7fa2fTF9yWh2N2VGyxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF3DC601EF;
	Thu, 17 Sep 2026 22:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1AC1F000FF;
	Thu, 17 Sep 2026 22:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789685611;
	bh=IXOjluZcFhH/flCEevB3M2TpvgfJxkLhPY+HcD+KzfE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CWDH0coQlEF0AK9ifcMlkpSjaSisLZfGRekijJzsGseP8S+XXRhiiios8D2k0rtzp
	 8/F2Bs5PXVT3Wm6PKbjY/N/xKFxDn+G2SJQYyFztHY2uSQssWBTWg2H1D2f3JkUvBG
	 uBLJVuF2bF8/cLdT+UqQWjo4GhxvECq2Rw1+/GDaCG7mazusN32fcbR2i8pW0M1NTw
	 lGoVq2TGGab8GVy2iaN81U1qpD5SGZutBlq8Ahx5AaJJrVcFie30Cl0ULk2P+VqvdH
	 BcKFgdjLsHj0EKzKGY0l3hdaAVKhUxO1f+aF2+MND+job3dbmW3MtoNId3U8Fltliw
	 SQDq8cROLWhYA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: George Guo <dongtai.guo@linux.dev>,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,  graf@amazon.com,
  changyuanl@google.com,  akpm@linux-foundation.org,
  chenhuacai@kernel.org,  liukexin@kylinos.cn,  guodongtai@kylinos.cn,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  loongarch@lists.linux.dev,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes
 before allocation
In-Reply-To: <0969ede4-f617-4e24-b32e-c5e30a96880e@linux.ibm.com> (Sourabh
	Jain's message of "Thu, 17 Sep 2026 16:00:00 +0530")
References: <20260904025101.9959-1-dongtai.guo@linux.dev>
	<616daf17-4598-4a30-8574-16480dfc23cb@linux.ibm.com>
	<0969ede4-f617-4e24-b32e-c5e30a96880e@linux.ibm.com>
Date: Fri, 18 Sep 2026 00:53:27 +0200
Message-ID: <2vxz1par7amw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 0492680004
X-Stat-Signature: s1eumz1bwmmq5smdrqbqcijwdg5fk5ms
X-Rspamd-Server: rspam01
X-HE-Tag: 1789685612-452818
X-HE-Meta: U2FsdGVkX1+fjlaEYxw5L8No2GJsAXddSX10/Lye6iCFK65+LRPZZnuwrEkTXWxEvC0A/duB6JNEeAbksXIXADDjA24QFkfxncuuX5FqK6DqL6LM1V/Le3+y2ek9PN2LkErGpacysqPUkn78GJae9kukeC0pbg9FO7Yqee1VGZ7LbjGuqf5eUOq6P/nhKibVfJHqtXvQvuPtX9N0VkGSXSzlJEssEimMZI69ttYU+IuOe667RUG76hr9O+5+pR6VvYBbSl0oJQ9nGCkGNJ72KJBwH+W3xELpj7WT3RNO5nM3yBHdRo0maLQOZKEuZyR9XRG0Gz5IMAISrlXORmabGgpUThgN+98ddkTNS60nh2r1VNrvMwu9X3j4Gzp7QbUy6AJNvynCQNuVW53d+twPhtjggnjn4NkICQwnO8JkyuB/RpUDFyG5HzmVa4WOJA6hOO3lOf1tQ8VqjnSTSptbDKVWPaD0Gp6kxEhEj+6kNeIZjQ2L1SwL9YDeA700+Yjg0MscSMjJtvTjApmES/X0kNqRqA/6X9SefuVeC2hTOXxuBPCTZAmSwFH98QGMSp35fH5eovIK1Ri3JHrnwt8cEEN2P50SdFofhAYeCze02msplz14AWS6x6WT3UmPILiAlLA9GyfbOEuZjd58HKlDSLfWDN6Rky1F5LWEleR+qY0pYXx7J/paoyIc290+Eqfv6U1v6mhrQshb2hfp7Wl8bpg0VaEp//RQR8HX48C1wIoC84Rgr6joDh9ux2Hvc70I/pA+GAMY7u5lpA9Bd04cMc3yzzokHVANiTmybqnGOfRB4XeOOg/Vcq+ejgj5fsnPCiElcfbcWXtIZpl1Y0t+NtbZb3jugrw+Mnlh679CrYaH3s9rSaO+oj/bzfweUNvkf1tCsIDlyTmtqjM3FuwaZ+xMqnwOKaShlIXPNJ7i4VqSbB/QYNSTXVUngI80nGmcv+XX0ypbe/ZtEpsAKsq
 0o2wrWqp
 bRZvRnHIGh6kBRk0WAKhSUsBCYCzOnKA7C53vNZhwPwPrzF1Ulj/Ms/FI00Xi0oSyuWknJZbXr/cyhEuW+Bu+U3OJKPj5CvLUd/Qy8QJ3kh5p1yTElS1itM5AiUC4tHLLUXqhf/W0+lJ8wajal85oR5EfNzBdw2s0myOBqyRZB1aVHZlm4ePu8is6oPtb/Zu/z7/vt2piFwppGthe6Pv5bNY86Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17 2026, Sourabh Jain wrote:

> Hello George,
>
> On 12/09/26 12:03, Sourabh Jain wrote:
>> Hello George,
>>
>> On 04/09/26 08:21, George Guo wrote:
>>> From: George Guo <guodongtai@kylinos.cn>
>>>
>>> The default percentage-based policy sizes scratch areas from the current
>>> kernel's MEMBLOCK_RSRV_KERN footprint. This is a reasonable heuristic for
>>> predicting the early memory demand of the next kernel.
>>>
>>> scratch_size_update() calculates the lowmem and global sizes before either
>>> area is allocated. However, kho_reserve_scratch() calculates each per-node
>>> size only after allocating the lowmem and global areas. Since memblock
>>> allocations are marked MEMBLOCK_RSRV_KERN, the per-node calculation
>>> includes those newly allocated scratch areas and scales them again.
>>
>> I may be missing something here, but doesn't memblock_reserved_kern_size()
>> check the node ID of the region before checking the region flag
>> (MEMBLOCK_RSRV_KERN)?
>>
>> Code snippet from memblock_reserved_kern_size()
>> ```
>> if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
>>     if (r->flags & MEMBLOCK_RSRV_KERN)
>>         total += size;
>> ```
>>
>> For a valid nid, my understanding is that the global and lowmem scratch
>> areas should not be counted because they are allocated with NUMA_NO_NODE
>> (-1). So, ideally, these regions should be excluded when calculating the
>> reserved memory for a specific node ID.
>>
>> Based on this, I am not sure that marking the lowmem and global areas as
>> MEMBLOCK_RSRV_KERN is what causes the per-node size calculation to be
>> inflated. I am looking into the code further to better understand the
>> actual cause of the issue that this patch is trying to address.
>
> I added some prints in kho_reserve_scratch() and found that the per-node size
> calculation is not impacted by the lowmem and global scratch memory allocations.
>
> KHO: Before low and global scratch allocations
> KHO: low size = 899 KB
> KHO: global size = 137 MB
> KHO: Per node 2 = 80 MB
>
> KHO: After low and global scratch allocations
> KHO: low size = 312195 KB
> KHO: global size = 441 MB
> KHO: Per node 2 = 80 MB
>
> KHO: After per node allocation
> KHO: low size = 394115 KB
> KHO: global size = 521 MB
> KHO: Per node 2 = 240 MB
>
> I only had one NUMA node (nid=2), and the per-NUMA
> allocation before and after the lowmem and global scratch
> memory allocations remained the same at 80 MB.
>
> The experiment was done on the PowerPC architecture.
>
> I am wondering how the per-NUMA allocation in your setup is
> getting inflated due to the lowmem and global scratch memory
> reservations.

I had the same question, so I asked AI. Here's what it says:

--- 8< ---

The bug was reported and tested using the KHO self-test runner
(tools/testing/selftests/kho/vmtest.sh), which builds a test kernel
using make olddefconfig with only a minimal set of CONFIG_* options.
Crucially, CONFIG_NUMA is not enabled.

When CONFIG_NUMA is disabled:

    #ifndef CONFIG_NUMA
    static inline void memblock_set_region_node(struct memblock_region *r, int nid)
    {
    }
    
    static inline int memblock_get_region_node(const struct memblock_region *r)
    {
        return 0;
    }
    #endif


struct memblock_region does not even contain an nid member.

memblock_set_region_node() is a no-op (the NUMA_NO_NODE argument is
simply discarded), and memblock_get_region_node() is hardcoded to always
return 0.

There is only one node (nid = 0), so for_each_node_state(nid, N_MEMORY)
loops once for nid = 0.

Both memblock_phys_alloc_range() and memblock_phys_alloc() mark their
allocations with MEMBLOCK_RSRV_KERN. Therefore, when
scratch_size_node(0) runs after allocating the lowmem scratch buffer,
memblock_get_region_node(r) returns 0 for that lowmem scratch buffer,
and r->flags & MEMBLOCK_RSRV_KERN is true. As a result,
scratch_size_node(0) counts the lowmem scratch area as part of Node 0's
kernel footprint and scales it by scratch_scale (200%) again.

--- >8 ---

I didn't look closer, but it does seem to make sense.

But in practice, this problem is only on CONFIG_NUMA=n and I don't think
in practice KHO or LUO is being used in non-NUMA systems. So while I
think it is worth fixing, I think we should also have a test where we
enable CONFIG_NUMA.

Your system probably has CONFIG_NUMA=y and that's why you aren't able to
reproduce this bug.

I think on NUMA systems the problem is the other way round. The
calculation for the global scratch also counts per-node allocations.

So I think the proper fix for scratch sizing is what this patch does and
then a fixup for the global scratch calculation as well.

[...]

-- 
Regards,
Pratyush Yadav

