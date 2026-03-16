Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CAAF53D77
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2102F6B0321; Mon, 16 Mar 2026 12:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4746B0322; Mon, 16 Mar 2026 12:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C77F6B0323; Mon, 16 Mar 2026 12:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9E5A6B0321
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:54:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91130C195B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:54:20 +0000 (UTC)
X-FDA: 84552524280.10.E4CB799
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4E7710001A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:54:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMrD8o9P;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773680058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUFh44+LdW+iRWSH/NOEPC/Mj468xIQL/M+3MUW4fao=;
	b=0Buu+gNjg8ruejwqlHAVk6wJEEDbK4DLq8n848w26XYVDG9P/PDe7j1ViSmdSkSYjA5Shu
	UU0LRulf/JHVGqer1SFB0aZDEsgqy4OlNXoOVo0xhQWxB54edjN9QXFEwwTvS3hJLIO8/C
	ozHw77GRnQviBJV/J3DOXoet5NIWGQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773680058; a=rsa-sha256;
	cv=none;
	b=RHsZiPIepjuUURmEEpBS3s0/G+W/5R7zAGuaVddP+9MXvMWiAauAJ5BGSpHUClXvsNx5HD
	sf6xwYKlQe++be28Jp+mrBVSFaCzF5WlPNcAKFf2qiKWa7cfexbRwu6O7Xyg4wObpoH/CJ
	wxfIrtExWE3isdRcTqyEObVnjc5zTMM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMrD8o9P;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A13960018;
	Mon, 16 Mar 2026 16:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1608C19421;
	Mon, 16 Mar 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773680057;
	bh=zIZU4rznj3GxPgHukE1YbuSrTakM9B750YZ4WSHMPTY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EMrD8o9P0Bmg6vDwJp7H/T1I/y8HG18Ox5umJp1FoDPm1GS+E+QP3tnBxO+mNVDxk
	 cE+hZ5RqNR/WRshaSrfcAvSG2IpX+oOqZwKECBNImpivH/SsgWqNT8wpHsO5cKXXy4
	 I0x+ylBGJ4rhlc6aw3LhzM80DLzrJLWIwIf4jpbBBnNZXJ8bbms2PG2/e4Dm245e3u
	 uGZYo5SQI/xUg5U3BJg3IjaZtP4wqH6KuiHlw8lDyD3ujgkX0zbtpqngtdOOL9Qgs7
	 kFHAqshKQa9wITxLPliuuPuvZfY9D4rERz9PNlNDh4YKF7EBGh+TMPyjk3kdOhgRqA
	 4TkJtGdRgdzNg==
Message-ID: <d2598f65-8666-43f4-a9c1-73bee678f8d7@kernel.org>
Date: Mon, 16 Mar 2026 17:54:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] iomap: add allocation cache for iomap_dio
Content-Language: en-US
To: changfengnan <changfengnan@bytedance.com>,
 Dave Chinner <david@fromorbit.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>
Cc: guzebing <guzebing1612@gmail.com>, brauner@kernel.org, djwong@kernel.org,
 hch@infradead.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, guzebing@bytedance.com,
 syzbot@syzkaller.appspotmail.com, linux-mm@kvack.org
References: <20260115021108.1913695-1-guzebing1612@gmail.com>
 <aWh06YoiJrR3-J-X@dread.disaster.area>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.e7ce3c98.9b89.4c0d.96b4.bddcc787e1ed@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fnudztxj4pit8bgsyh1f98kqiaf747uj
X-Rspamd-Queue-Id: C4E7710001A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773680058-436664
X-HE-Meta: U2FsdGVkX19f2JVhmHdEOGtetkhJ7wWABBL/QANk6d2z7jIKD+zK2plX6Se/18NPBL9pU3xVnB/fa0TU5uQM95GGhmWn2B/oTIW+XuwLwvQanfOOX1xx5smOtUMQx2QbU+VRllzXdizt2p9xmIIlX7GTuJL0QuCsFuK5CejOzgFT2+2LHbreCuvIFIZUy9tMz1Puqb2KEro/aCbcq7FRSRMYjh/VkgeUzOYI2qmw2hbUtH9KWJ5MBnLKKTGhm2yyrJ0q6ocD18QGjG/CjkW8ffenr4066QyzwBH/ZAO0AhDwcN4x2LDTLQTfyxGoYhgy6PpHML62TlW2GBBhbMz59j+g1I2T+ra+Y0K4DgGl6JZDr/yPvnyypx6jh4FZFzMMERg05hyWS67kdtGNseB9cU/6pFtObdVOrMy65C0DM6SWAx4Xa/114GWCKkoCRS0MQnSLTgLXRlmgws6QCMx8+l+9rMAlUR50Dz7/rvCwsX+eMM3ktbYfPN/i1X1SwEPewjeNOHpm4It9os2l0WBxSSCEFv0qzWv5aqLmutAob6vkrM5KvHkYUR5je7KNwcZ+xZ1JnonlD2jnShNntvUXaUE5YwkI/xrqhhWI3tdz8nodVgiz8YwMlRcXukVjBw2i+R0OIG5PAmBAjyN7q6+TuS8eQbInzfCEXsYXSxg/6QwDAFjEJ1dMdZUnIk0FxO4uGM4/JoGXjvkwzvcwEiy4gXKVhkN+K5NuOzkatIvH3KD8/7YRixITLMEHTdjb6Dv18DFZtOPIod1uyiHYp04+fQCze7XUzLghfvKSGlGDGPhV1jZTkJrhVwZ5+Pb9hg3rkhmr0PQRxw5tJCzlV4ZsQ98/lnM5JB17YLfsqYzVOp+W3Z+9h1OhtLlDXLkD/SIpDnh353wOaMy38u1J/5lUmF1YqI011M7rVaHXXG4+gGJN2cliEbDp/eFLa8tMpSU0ebgNn+vib5UJyZhru0N
 Ij5zwjW5
 d93tsFmi7l0RPPKH7pwOyeO1rO18ubAFeJOzfEX+U49EZbyqbCX9JYSNTCuPOL9i0AMK9uZ6Zk6rcJd5pzU9BZazJ09/5PPfLZEY8t9DaZzLoN+z90KRWayckEqMBi6J3JGOHbBDXJ9NMt2tpN5TIp9BHuMSqzAaSY+6fkg/6TuFCIZsj2aGGy/kHn6yfiPrG23dgpjUa+23l9VtuKwvz6SKQidcGE5Qp7b8/oCWJM0TrEH19HW3iBaYyMoUfA1bmAAQEF8xNh4Mth4ZnlRcHfF1fzkV3SqNBNC6eHfXTgyTgbrKoGtMtlgZchoGu+H/dknfP0OGzx48FGDEi4CS8RH1JM9Y776sqKCsebV3QgXGS3fyD/q7vl/wbMDD4E5+VhHuqockbYbG4w4pzEqyD54CWJT0cnndtMWUCOIqaKwKtG8tn4WRxGmOxpVBcRKHcyPb9J1181WlHeGRG3duG4Gar207sBNFsW4nGMcDr2/12KyjtK3fKx5e79ewY1P+1QFheAhbCxfd8S2aDEFi7ZiVSdIHoLbLmqzoGWsTq9tUjQOlqa29ZpYOU8NkSKYwbxCsOCHmMSbzKMrOSz34hVq2pksJaSyuN5IvOtiKyRuaoD7GXDFKKG1z+qk3qsB5Ggw1rRGEwck3Dn4tlPki/xsvOIF8thjC1jF70h/P6zeX7l5GfoYwEDK++WgzOFJVbhRi6Jim2JMhTRV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+CC Harry and Hao

On 3/16/26 12:22, changfengnan wrote:
> 
>> From: "Dave Chinner"<david@fromorbit.com>
>> Date:  Thu, Jan 15, 2026, 13:02
>> Subject:  Re: [PATCH v3] iomap: add allocation cache for iomap_dio
>> To: "guzebing"<guzebing1612@gmail.com>
>> Cc: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, <linux-xfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <guzebing@bytedance.com>, <syzbot@syzkaller.appspotmail.com>, "Fengnan Chang"<changfengnan@bytedance.com>, <linux-mm@kvack.org>, "Vlastimil Babka"<vbabka@suse.cz>
>> [cc linux-mm]
>> 
>> On Thu, Jan 15, 2026 at 10:11:08AM +0800, guzebing wrote:
>> > As implemented by the bio structure, we do the same thing on the
>> > iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
>> > enabling us to quickly recycle them instead of going through the slab
>> > allocator.
>> > 
>> > By making such changes, we can reduce memory allocation on the direct
>> > IO path, so that direct IO will not block due to insufficient system
>> > memory. In addition, for direct IO, the read performance of io_uring
>> > is improved by about 2.6%.
>> 
>> Honestly, this just feels wrong.
>> 
>> If heap memory allocation has performance issues, then the right
>> solution is to fix the memory allocator.
>> 
>> Oh, wait, you're copy-pasting the hacky per-cpu bio allocator cache
>> lists into the iomap DIO code.
>> 
>> IMO, this really should be part of the generic memory allocation
>> APIs, not repeatedly tacked on the outside of specific individual
>> object allocations.
>> 
>> <thinks a bit>
>> 
>> Huh. per-cpu free lists is the traditional SLAB allocator
>> architecture. That was removed a while back because SLUB performs
>> better in most cases....
>> 
>> <thinks a bit more>
>> 
>> ISTR somebody was already working to optimise the SLUB allocator to
>> address these corner case shortcomings w.r.t. traditional SLABs.
>> 
>> Yup:
>> 
>> 
>> commit 2d517aa09bbc4203f10cdee7e1d42f3bbdc1b1cd
>> Author: Vlastimil Babka <vbabka@suse.cz>
>> Date:   Wed Sep 3 14:59:45 2025 +0200
>> 
>>     slab: add opt-in caching layer of percpu sheaves
>> 
>>     Specifying a non-zero value for a new struct kmem_cache_args field
>>     sheaf_capacity will setup a caching layer of percpu arrays called
>>     sheaves of given capacity for the created cache.
>> 
>>     Allocations from the cache will allocate via the percpu sheaves (main or
>>     spare) as long as they have no NUMA node preference. Frees will also
>>     put the object back into one of the sheaves.
>> 
>>     When both percpu sheaves are found empty during an allocation, an empty
>>     sheaf may be replaced with a full one from the per-node barn. If none
>>     are available and the allocation is allowed to block, an empty sheaf is
>>     refilled from slab(s) by an internal bulk alloc operation. When both
>>     percpu sheaves are full during freeing, the barn can replace a full one
>>     with an empty one, unless over a full sheaves limit. In that case a
>>     sheaf is flushed to slab(s) by an internal bulk free operation. Flushing
>>     sheaves and barns is also wired to the existing cpu flushing and cache
>>     shrinking operations.
>> 
>>     The sheaves do not distinguish NUMA locality of the cached objects. If
>>     an allocation is requested with kmem_cache_alloc_node() (or a mempolicy
>>     with strict_numa mode enabled) with a specific node (not NUMA_NO_NODE),
>>     the sheaves are bypassed.
>> 
>>     The bulk operations exposed to slab users also try to utilize the
>>     sheaves as long as the necessary (full or empty) sheaves are available
>>     on the cpu or in the barn. Once depleted, they will fallback to bulk
>>     alloc/free to slabs directly to avoid double copying.
>> 
>>     The sheaf_capacity value is exported in sysfs for observability.
>> 
>>     Sysfs CONFIG_SLUB_STATS counters alloc_cpu_sheaf and free_cpu_sheaf
>>     count objects allocated or freed using the sheaves (and thus not
>>     counting towards the other alloc/free path counters). Counters
>>     sheaf_refill and sheaf_flush count objects filled or flushed from or to
>>     slab pages, and can be used to assess how effective the caching is. The
>>     refill and flush operations will also count towards the usual
>>     alloc_fastpath/slowpath, free_fastpath/slowpath and other counters for
>>     the backing slabs.  For barn operations, barn_get and barn_put count how
>>     many full sheaves were get from or put to the barn, the _fail variants
>>     count how many such requests could not be satisfied mainly  because the
>>     barn was either empty or full. While the barn also holds empty sheaves
>>     to make some operations easier, these are not as critical to mandate own
>>     counters.  Finally, there are sheaf_alloc/sheaf_free counters.
>> 
>>     Access to the percpu sheaves is protected by local_trylock() when
>>     potential callers include irq context, and local_lock() otherwise (such
>>     as when we already know the gfp flags allow blocking). The trylock
>>     failures should be rare and we can easily fallback. Each per-NUMA-node
>>     barn has a spin_lock.
>> 
>>     When slub_debug is enabled for a cache with sheaf_capacity also
>>     specified, the latter is ignored so that allocations and frees reach the
>>     slow path where debugging hooks are processed. Similarly, we ignore it
>>     with CONFIG_SLUB_TINY which prefers low memory usage to performance.
>> 
>>     [boot failure: https://lore.kernel.org/all/583eacf5-c971-451a-9f76-fed0e341b815@linux.ibm.com/ ]
>> 
>>     Reported-and-tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>     Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>>     Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>     Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> 
>> Yeah, recent code, functionality is not enabled by default yet. So,
>> kmem_cache_alloc() with:
>> 
>> struct kmem_cache_args {
>> .....
>>         /**
>>          * @sheaf_capacity: Enable sheaves of given capacity for the cache.
>>          *
>>          * With a non-zero value, allocations from the cache go through caching
>>          * arrays called sheaves. Each cpu has a main sheaf that's always
>>          * present, and a spare sheaf that may be not present. When both become
>>          * empty, there's an attempt to replace an empty sheaf with a full sheaf
>>          * from the per-node barn.
>>          *
>>          * When no full sheaf is available, and gfp flags allow blocking, a
>>          * sheaf is allocated and filled from slab(s) using bulk allocation.
>>          * Otherwise the allocation falls back to the normal operation
>>          * allocating a single object from a slab.
>>          *
>>          * Analogically when freeing and both percpu sheaves are full, the barn
>>          * may replace it with an empty sheaf, unless it's over capacity. In
>>          * that case a sheaf is bulk freed to slab pages.
>>          *
>>          * The sheaves do not enforce NUMA placement of objects, so allocations
>>          * via kmem_cache_alloc_node() with a node specified other than
>>          * NUMA_NO_NODE will bypass them.
>>          *
>>          * Bulk allocation and free operations also try to use the cpu sheaves
>>          * and barn, but fallback to using slab pages directly.
>>          *
>>          * When slub_debug is enabled for the cache, the sheaf_capacity argument
>>          * is ignored.
>>          *
>>          * %0 means no sheaves will be created.
>>          */
>>         unsigned int sheaf_capacity;
>> }
>> 
>> set to the value required is all we need. i.e. something like this
>> in iomap_dio_init():
>> 
>> 
>>         struct kmem_cache_args kmem_args = {
>>                 .sheaf_capacity = 256,
>>         };
>> 
>>         dio_kmem_cache = kmem_cache_create("iomap_dio", sizeof(struct iomap_dio),
>>                         &kmem_args, SLAB_PANIC | SLAB_ACCOUNT
>> 
>> And changing the allocation to kmem_cache_alloc(dio_kmem_cache,
>> GFP_KERNEL) should provide the same sort of performance improvement
>> as this patch does.
>> 
>> Can you test this, please?
> 
> Hi Dave:
> Sorry it took so long to respond. Guzebing was busy with something else, I did
> this test.
> I test sheaf_capacity on 7.0-rc3, it doesn't show any performance improvment.

7.0-rc3 already has sheaves in every cache and the old caching scheme
removed. An explicit sheaf_capacity can now be used to increase the
automatically calculated one, where the value you can observe in
/sys/kernel/slab/$cache/sheaf_capacity

> Besides, I wrote a simple kernel modules to test the performance difference by
> creating a normal memcache and one with sheaf_capacity and testing the time
> consuming to request 32 objects and then free 32 objects. which resulted in a
> roughly 10% improvement in time spent.

That suggests in that test you used larger capacity than the automatically
calculated.
 
> I'm thinking that maybe these improvements may not be significant enough to
> see the effect in the io flow.
> Using a simple list seems to be the most efficient approach.

I think the question is, what improvement do you now see with your added
pcpu cache vs kmalloc() when 7.0-rc4 is used as the baseline?

Thanks,
Vlastimil

> Thanks.
> Fengnan.
> 
>> 
>> If it doesn't provide any performance improvment, then I suspect
>> that Vlastimil will be interested to find out why....
>> 
>> Also, if it does work, it is likely the bioset mempools (which are
>> slab based) can be initialised similarly, removing the need for
>> custom per-cpu free lists in the block layer, too.
>> 
>> -Dave.
>> 
>> > 
>> > v3:
>> > kmalloc now is called outside the get_cpu/put_cpu code section.
>> > 
>> > v2:
>> > Factor percpu cache into common code and the iomap module uses it.
>> > 
>> > v1:
>> > https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gmail.com/
>> > 
>> > Tested-by: syzbot@syzkaller.appspotmail.com
>> > 
>> > Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
>> > Signed-off-by: guzebing <guzebing1612@gmail.com>
>> > ---
>> >  fs/iomap/direct-io.c | 133 ++++++++++++++++++++++++++++++++++++++++++-
>> >  1 file changed, 130 insertions(+), 3 deletions(-)
>> > 
>> > diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> > index 5d5d63efbd57..4421e4ad3a8f 100644
>> > --- a/fs/iomap/direct-io.c
>> > +++ b/fs/iomap/direct-io.c
>> > @@ -56,6 +56,130 @@ struct iomap_dio {
>> >          };
>> >  };
>> >  
>> > +#define PCPU_CACHE_IRQ_THRESHOLD        16
>> > +#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
>> > +        (sizeof(struct pcpu_cache_element) + pcpu_cache_list->element_size)
>> > +#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
>> > +        ((struct pcpu_cache_element *)((unsigned long)(payload) - \
>> > +                                       sizeof(struct pcpu_cache_element)))
>> > +#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
>> > +        ((void *)((unsigned long)(head) + sizeof(struct pcpu_cache_element)))
>> > +
>> > +struct pcpu_cache_element {
>> > +        struct pcpu_cache_element        *next;
>> > +        char        payload[];
>> > +};
>> > +struct pcpu_cache {
>> > +        struct pcpu_cache_element        *free_list;
>> > +        struct pcpu_cache_element        *free_list_irq;
>> > +        int                nr;
>> > +        int                nr_irq;
>> > +};
>> > +struct pcpu_cache_list {
>> > +        struct pcpu_cache __percpu *cache;
>> > +        size_t element_size;
>> > +        int max_nr;
>> > +};
>> > +
>> > +static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, size_t size)
>> > +{
>> > +        struct pcpu_cache_list *pcpu_cache_list;
>> > +
>> > +        pcpu_cache_list = kmalloc(sizeof(struct pcpu_cache_list), GFP_KERNEL);
>> > +        if (!pcpu_cache_list)
>> > +                return NULL;
>> > +
>> > +        pcpu_cache_list->element_size = size;
>> > +        pcpu_cache_list->max_nr = max_nr;
>> > +        pcpu_cache_list->cache = alloc_percpu(struct pcpu_cache);
>> > +        if (!pcpu_cache_list->cache) {
>> > +                kfree(pcpu_cache_list);
>> > +                return NULL;
>> > +        }
>> > +        return pcpu_cache_list;
>> > +}
>> > +
>> > +static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        free_percpu(pcpu_cache_list->cache);
>> > +        kfree(pcpu_cache_list);
>> > +}
>> > +
>> > +static void irq_cache_splice(struct pcpu_cache *cache)
>> > +{
>> > +        unsigned long flags;
>> > +
>> > +        /* cache->free_list must be empty */
>> > +        if (WARN_ON_ONCE(cache->free_list))
>> > +                return;
>> > +
>> > +        local_irq_save(flags);
>> > +        cache->free_list = cache->free_list_irq;
>> > +        cache->free_list_irq = NULL;
>> > +        cache->nr += cache->nr_irq;
>> > +        cache->nr_irq = 0;
>> > +        local_irq_restore(flags);
>> > +}
>> > +
>> > +static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        struct pcpu_cache *cache;
>> > +        struct pcpu_cache_element *cache_element;
>> > +
>> > +        cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
>> > +        if (!cache->free_list) {
>> > +                if (READ_ONCE(cache->nr_irq) >= PCPU_CACHE_IRQ_THRESHOLD)
>> > +                        irq_cache_splice(cache);
>> > +                if (!cache->free_list) {
>> > +                        put_cpu();
>> > +                        cache_element = kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list),
>> > +                                                                        GFP_KERNEL);
>> > +                        if (!cache_element)
>> > +                                return NULL;
>> > +                        return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
>> > +                }
>> > +        }
>> > +
>> > +        cache_element = cache->free_list;
>> > +        cache->free_list = cache_element->next;
>> > +        cache->nr--;
>> > +        put_cpu();
>> > +        return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
>> > +}
>> > +
>> > +static void pcpu_cache_list_free(void *payload, struct pcpu_cache_list *pcpu_cache_list)
>> > +{
>> > +        struct pcpu_cache *cache;
>> > +        struct pcpu_cache_element *cache_element;
>> > +
>> > +        cache_element = PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload);
>> > +
>> > +        cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
>> > +        if (READ_ONCE(cache->nr_irq) + cache->nr >= pcpu_cache_list->max_nr)
>> > +                goto out_free;
>> > +
>> > +        if (in_task()) {
>> > +                cache_element->next = cache->free_list;
>> > +                cache->free_list = cache_element;
>> > +                cache->nr++;
>> > +        } else if (in_hardirq()) {
>> > +                lockdep_assert_irqs_disabled();
>> > +                cache_element->next = cache->free_list_irq;
>> > +                cache->free_list_irq = cache_element;
>> > +                cache->nr_irq++;
>> > +        } else {
>> > +                goto out_free;
>> > +        }
>> > +        put_cpu();
>> > +        return;
>> > +out_free:
>> > +        put_cpu();
>> > +        kfree(cache_element);
>> > +}
>> > +
>> > +#define DIO_ALLOC_CACHE_MAX                256
>> > +static struct pcpu_cache_list *dio_pcpu_cache_list;
>> > +
>> >  static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
>> >                  struct iomap_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
>> >  {
>> > @@ -135,7 +259,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
>> >                          ret += dio->done_before;
>> >          }
>> >          trace_iomap_dio_complete(iocb, dio->error, ret);
>> > -        kfree(dio);
>> > +        pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>> >          return ret;
>> >  }
>> >  EXPORT_SYMBOL_GPL(iomap_dio_complete);
>> > @@ -620,7 +744,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>> >          if (!iomi.len)
>> >                  return NULL;
>> >  
>> > -        dio = kmalloc(sizeof(*dio), GFP_KERNEL);
>> > +        dio = pcpu_cache_list_alloc(dio_pcpu_cache_list);
>> >          if (!dio)
>> >                  return ERR_PTR(-ENOMEM);
>> >  
>> > @@ -804,7 +928,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>> >          return dio;
>> >  
>> >  out_free_dio:
>> > -        kfree(dio);
>> > +        pcpu_cache_list_free(dio, dio_pcpu_cache_list);
>> >          if (ret)
>> >                  return ERR_PTR(ret);
>> >          return NULL;
>> > @@ -834,6 +958,9 @@ static int __init iomap_dio_init(void)
>> >          if (!zero_page)
>> >                  return -ENOMEM;
>> >  
>> > +        dio_pcpu_cache_list = pcpu_cache_list_create(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
>> > +        if (!dio_pcpu_cache_list)
>> > +                return -ENOMEM;
>> >          return 0;
>> >  }
>> >  fs_initcall(iomap_dio_init);
>> > -- 
>> > 2.20.1
>> > 
>> > 
>> > 
>> 
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> 


