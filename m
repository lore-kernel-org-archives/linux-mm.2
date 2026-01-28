Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62480D46BE6
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCA76B0005; Wed, 28 Jan 2026 13:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B0A6B0089; Wed, 28 Jan 2026 13:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EC06B008A; Wed, 28 Jan 2026 13:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5936B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:28:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3248F1A076B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:28:41 +0000 (UTC)
X-FDA: 84382208442.04.B0BE559
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB4A2A0008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:28:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=iYX4NjbP;
	spf=pass (imf25.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769624919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv/5Xt5C0T/YMiB+ioPeuN7YCtbrmm2qxsQAlrljD6Y=;
	b=lHU8kcLJyIIlwHtIvYHpgFV1iAMjglXSwxT0i/zagzTJBLls/7X9Uqdoyvr97O62rr8Pdt
	OHjP/7/g6Vrq9rmHHAmNnT+0hLRCvJc46Vqd6F8AsF24KwZ+GXa1wbpGVjGi14GOmVAg17
	vpNuW71jW9E/LQn/DJPInPNhUxBDvJQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=iYX4NjbP;
	spf=pass (imf25.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769624919; a=rsa-sha256;
	cv=none;
	b=5U0upH6G7VH4ZZuqkHH9bpmxmJkCwqDArjR/9CnVTXfnXuFxigsqGG2GlsNCPWmZprqS8z
	21ZwIKMyIl2hlXDlC/gkPjrZhBI9ndReJBjGDMv7P1m2H3ush64c3SRUL4ItuXtY0v32Em
	6R1ifKIx/XRQFEcAi/SDbbtkcv+CkGg=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260128182832epoutp0293e8833f4ba7b78ecae69b9670424d47~O_HtLUcGl2051120511epoutp02d
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:28:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260128182832epoutp0293e8833f4ba7b78ecae69b9670424d47~O_HtLUcGl2051120511epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769624912;
	bh=Gv/5Xt5C0T/YMiB+ioPeuN7YCtbrmm2qxsQAlrljD6Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=iYX4NjbPBd+DYQo+o5WCO8ERNTfIep1jhDC/a5T/0558AL1eOhPx2dTSPP0HYVg59
	 upTXe94Mc68C/IU48OM7JZGr3JExW+BXPhRAJQ0IxhXdywmLryhM6MLE9YgJfmorbv
	 BPuG46Av8oYzBr+LlRbY2s9Rm6yTPF2PsbzCyIck=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260128182831epcas5p3fde99bd45f69e11c6dce8036e6f425c3~O_HsdlJIA0474704747epcas5p3U;
	Wed, 28 Jan 2026 18:28:31 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4f1W4G2GGfz6B9m4; Wed, 28 Jan
	2026 18:28:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260128182829epcas5p4398956f380795d9a862229c6766da668~O_HrDPcjj1514815148epcas5p4E;
	Wed, 28 Jan 2026 18:28:29 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260128182826epsmtip13b5776ddc5ea3f1f65ffa668a59ca21a~O_HoEqOlZ0743607436epsmtip10;
	Wed, 28 Jan 2026 18:28:26 +0000 (GMT)
Message-ID: <e7413e3b-3fae-4aab-90a1-4a6695156b2e@samsung.com>
Date: Wed, 28 Jan 2026 23:58:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Content-Language: en-US
To: Brian Foster <bfoster@redhat.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <aXN3EtxKFXX8DEbl@bfoster>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260128182829epcas5p4398956f380795d9a862229c6766da668
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
	<ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
	<aXN3EtxKFXX8DEbl@bfoster>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB4A2A0008
X-Stat-Signature: zyuphwyzjwg6uboh5zwrtou3su8otyam
X-Rspam-User: 
X-HE-Tag: 1769624917-627521
X-HE-Meta: U2FsdGVkX18XkWgWUUfMkqUjw8BG9NA2rAVCETX8KlSDOF5CKCAgxzqyZghjM0rAlt9m7nFdZ6tEqnjPFOuOShjOGwbpwgSp5HTJmV8YrG4bU0xpM07CodvIML8ZpY5mNM5hgJoRB9se8N2KZkKA9tbz5ag56z5sUyCJ+rT1zzQEajngk77KTuole5II7MkEYApDQEmrS//W9Xse9PMJoHoYmxyrVjyKePf0wSh3aZpamZ6+a7LR4E1y7WR4vOcNGFbQDF9hEsA8ahyQST6B8xx12Ggrzf811jUT/BRrzuKxOK+AGCbKUcx1Tx9iPHJzK13aFGUJFZ871S4aeO5IBkgSGTfFta2zxi09Y3gq8tuR+YaeNNgw+qYu/uWSs6tM4WiXOnkc6Cflrc9k+Vu2Gs2v0BXFaCq3u+STC0lTIlrZpbZjPPkfRIUuOEajUK/jPnLD5WtPVSsjv75CZr5pepCMZGDWRai13IKIpvEnjDgztPJxAX8tQIK9XkgzmDcgLCT2NX/armbldYIQCOCEqM+L/qtywkKt/fk0jSoEGUU/cWeYIIwduddaGMVBa3DKp6j2pu91cXytdk6H1Mi4pWljeMTVm0p8rEejhX0rULLe/z6z8f5YOaTch1D1lek6xqA9T1pAd10NXb0Xlt0BaikE+UxG7aUquhu9pa2O8foDIpgpS6//7LJKiYBJeDvJxDikN8Q7N3DZc8rp6hcfZXK+Qg0sej3CCeJz0QdHER/BNbEI19GsWJFuK47iLS0b3wKznyT/3omQMmrFAN2eDjOja/EwO4tIxOA0xqx+KnRXqiECrMFw36NL99R7K+D9sWS6tXtmJy419/TOkhVnpMtDaqVXrAvNyhgY28kqO7SDpSmknpBA1ZrCXk5OcsQMBilU8AIwVKsq+iqfDdpSlD2UeuHVEJhynyqJJGgkz2gwB9S8EjDEce4mpvO/UhEydV1M36qAmeP6L2G4ssp
 LrQnnFMy
 8SiDF6/mD4F/ZRjKGXzoxAzzVAPqPIoVcJWQDvPkt2R/pqDYjKym9OyiGYR3Qb4t1/GF6VKY8GhgYCM9n8cX9WgeTFHoTmR6R9xVB3j943NkKbaCMXAFegMnYADs5KvV2g2Knn00bNh2ZTc0Oy92ZsoH5Yz9Qf6WieK0kpW+0IjBFV24gV1K1mVSUmCKfAFXYThla5kVOMUlHED0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/2026 6:56 PM, Brian Foster wrote:
> On Thu, Jan 22, 2026 at 09:45:05PM +0530, Kundan Kumar wrote:
>>>
>>> Could you provide more detail on how you're testing here? I threw this
>>> at some beefier storage I have around out of curiosity and I'm not
>>> seeing much of a difference. It could be I'm missing some details or
>>> maybe the storage outweighs the processing benefit. But for example, is
>>> this a fio test command being used? Is there preallocation? What type of
>>> storage? Is a particular fs geometry being targeted for this
>>> optimization (i.e. smaller AGs), etc.?
>>
>> Thanks Brian for the detailed review and for taking the time to
>> look through the code.
>>
>> The numbers quoted were from fio buffered write workloads on NVMe
>> (Optane devices), using multiple files placed in different
>> directories mapping to different AGs. Jobs were buffered
>> randwrite with multiple jobs. This can be tested with both
>> fallocate=none or otherwise.
>>
>> Sample script for 12 jobs to 12 directories(AGs) :
>>
>> mkfs.xfs -f -d agcount=12 /dev/nvme0n1
>> mount /dev/nvme0n1 /mnt
>> sync
>> echo 3 > /proc/sys/vm/drop_caches
>>
>> for i in {1..12}; do
>>     mkdir -p /mnt/dir$i
>> done
>>
>> fio job.fio
>>
>> umount /mnt
>> echo 3 > /proc/sys/vm/drop_caches
>>
>> The job file :
>>
>> [global]
>> bs=4k
>> iodepth=32
>> rw=randwrite
>> ioengine=io_uring
>> fallocate=none
>> nrfiles=12
>> numjobs=1
>> size=6G
>> direct=0
>> group_reporting=1
>> create_on_open=1
>> name=test
>>
>> [job1]
>> directory=/mnt/dir1
>>
>> [job2]
>> directory=/mnt/dir2
>> ...
>> ...
>> [job12]
>> directory=/mnt/dir12
>>
> 
> Thanks..
> 
>>>
>>> FWIW, I skimmed through the code a bit and the main thing that kind of
>>> stands out to me is the write time per-folio hinting. Writeback handling
>>> for the overwrite (i.e. non-delalloc) case is basically a single lookup
>>> per mapping under shared inode lock. The question that comes to mind
>>> there is what is the value of per-ag batching as opposed to just adding
>>> generic concurrency? It seems unnecessary to me to take care to shuffle
>>> overwrites into per-ag based workers when the underlying locking is
>>> already shared.
>>>
>>
>> That’s a fair point. For the overwrite (non-delalloc) case, the
>> per-folio AG hinting is not meant to change allocation behavior, and
>> I agree the underlying inode locking remains shared. The primary value
>> I’m seeing there is the ability to partition writeback iteration and
>> submission when dirty data spans multiple AGs.
>> I will try routing overwrite writeback to workers irrespective of AG
>> (e.g. hash/inode based), to compare between generic concurrency vs AG
>> batching.
>>
>>> WRT delalloc, it looks like we're basically taking the inode AG as the
>>> starting point and guessing based on the on-disk AGF free blocks counter
>>> at the time of the write. The delalloc accounting doesn't count against
>>> the AGF, however, so ISTM that in many cases this would just effectively
>>> land on the inode AG for larger delalloc writes. Is that not the case?
>>>
>>> Once we get to delalloc writeback, we're under exclusive inode lock and
>>> fall into the block allocator. The latter trylock iterates the AGs
>>> looking for a good candidate. So what's the advantage of per-ag
>>> splitting delalloc at writeback time if we're sending the same inode to
>>> per-ag workers that all 1. require exclusive inode lock and 2. call into
>>> an allocator that is designed to be scalable (i.e. if one AG is locked
>>> it will just move to the next)?
>>>
>>
>> The intent of per-AG splitting is not to parallelize allocation
>> within a single inode or override allocator behavior, but to
>> partition writeback scheduling so that inodes associated with
>> different AGs are routed to different workers. This implicitly
>> distributes inodes across AG workers, even though each inode’s
>> delalloc conversion remains serialized.
>>
>>> Yet another consideration is how delalloc conversion works at the
>>> xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
>>> If you take a look at the latter, we look up the entire delalloc extent
>>> backing the folio under writeback and attempt to allocate it all at once
>>> (not just the blocks backing the folio). So in theory if we were to end
>>> up tagging a sequence of contiguous delalloc backed folios at buffered
>>> write time with different AGs, we're still going to try to allocate all
>>> of that in one AG at writeback time. So the per-ag hinting also sort of
>>> competes with this by shuffling writeback of the same potential extent
>>> into different workers, making it a little hard to try and reason about.
>>>
>>
>> Agreed — delalloc conversion happens at extent granularity, so
>> per-folio AG hints are not meant to steer final allocation. In this
>> series the hints are used purely as writeback scheduling tokens;
>> allocation still occurs once per extent under XFS_ILOCK_EXCL using
>> existing allocator logic. The goal is to partition writeback work and
>> avoid funneling multiple inodes through a single writeback path, not
>> to influence extent placement.
>>
> 
> Yeah.. I realize none of this is really intended to drive allocation
> behavior. The observation that all this per-folio tracking ultimately
> boils down to either sharding based on information we have at writeback
> time (i.e. overwrites) or effectively batching based on on-disk AG state
> at the time of the write is kind of what suggests that the folio
> granular hinting is potentially overkill.
> 
>>> So stepping back it kind of feels to me like the write time hinting has
>>> so much potential for inaccuracy and unpredictability of writeback time
>>> behavior (for the delalloc case), that it makes me wonder if we're
>>> effectively just enabling arbitrary concurrency at writeback time and
>>> perhaps seeing benefit from that. If so, that makes me wonder if the
>>> associated value can be gained by somehow simplifying this to not
>>> require write time hinting at all.
>>>
>>> Have you run any experiments that perhaps rotors inodes to the
>>> individual wb workers based on the inode AG (i.e. basically ignoring all
>>> the write time stuff) by chance? Or anything that otherwise helps
>>> quantify the value of per-ag batching over just basic concurrency? I'd
>>> be interested to see if/how behavior changes with something like that.
>>
>> Yes, inode-AG based routing has been explored as part of earlier
>> higher-level writeback work (link below), where inodes are affined to
>> writeback contexts based on inode AG. That effectively provides
>> generic concurrency and serves as a useful baseline.
>> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
>>
> 
> Ah, I recall seeing that. A couple questions..
> 
> That link states the following:
> 
> "For XFS, affining inodes to writeback threads resulted in a decline
> in IOPS for certain devices. The issue was caused by AG lock contention
> in xfs_end_io, where multiple writeback threads competed for the same
> AG lock."
> 
> Can you quantify that? It seems like xfs_end_io() mostly cares about
> things like unwritten conversion, COW remapping, etc., so block
> allocation shouldn't be prominent. Is this producing something where
> frequent unwritten conversion results in a lot of bmapbt splits or
> something?
> 

I captured stacks from the contending completion workers and the hotspot
is in the unwritten conversion path
(xfs_end_io() -> xfs_iomap_write_unwritten()). We were repeatedly
contending on the AGF buffer lock via xfs_alloc_fix_freelist() /
xfs_alloc_read_agf() when writeback threads were affined per-inode.
This contention went away once writeback was distributed across
AG-based workers, pointing to reduced AGF hotspotting during unwritten
conversion (rmap/btree updates and freelist fixes), rather than block
allocation in the write path itself.

> Also, how safe is it is to break off writeback tasks at the XFS layer
> like this? For example, is it safe to spread around the wbc to a bunch
> of tasks like this? What about serialization for things like bandwidth
> accounting and whatnot in the core/calling code?  Should the code that
> splits off wq tasks in XFS be responsible to wait for parallel
> submission completion before returning (I didn't see anything doing that
> on a scan, but could have missed it)..?
> 

You are right that core writeback accounting assumes serialized
updates. The current series copies wbc per worker to avoid concurrent
mutation, but that is not sufficient for strict global accounting
semantics.

For this series we only offload the async path
(wbc->sync_mode != WB_SYNC_ALL), so we do not wait for worker completion
before returning from ->writepages(). Sync writeback continues down the
existing iomap_writepages path.

>> The motivation for this series is the complementary case where a
>> single inode’s dirty data spans multiple AGs on aged/fragmented
>> filesystems, where inode-AG affinity breaks down. The folio-level AG
>> hinting here is intended to explore whether finer-grained partitioning
>> provides additional benefit beyond inode-based routing.
>>
> 
> But also I'm not sure I follow the high level goal here. I have the same
> question as Pankaj in that regard.. is this series intended to replace
> the previous bdi level approach, or go along with it somehow? Doing
> something at the bdi level seems like a more natural approach in
> general, so I'm curious why the change in direction.
> 
> Brian
> 

This series is intended to replace the earlier BDI-level approach for
XFS, not to go alongside it. While BDI-level sharding is the more
natural generic mechanism, we saw XFS regressions on some setups when
inodes were affined to wb threads due to completion-side AG contention.

The goal here is to make concurrency an XFS policy decision by routing
writeback using AG-aware folio tags, so we avoid inode-affinity
hotspots and handle cases where a single inode spans multiple AGs on
aged or fragmented filesystems.

If this approach does not hold up across workloads and devices, we can
fall back to the generic BDI sharding model.

- Kundan


