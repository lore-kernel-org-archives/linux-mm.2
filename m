Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B64D3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A46A6B029F; Thu, 22 Jan 2026 11:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864E36B02A0; Thu, 22 Jan 2026 11:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7502E6B02A1; Thu, 22 Jan 2026 11:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4016B029F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:15:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FD411A0408
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:15:22 +0000 (UTC)
X-FDA: 84360099684.04.FC13FF8
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0EF9E8000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:15:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=q1HlIrWN;
	spf=pass (imf30.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ut0PvNTFkBDARJX4qSO9056XGy5KdZ5rJS/cjW/7pRk=;
	b=lIJEdbsOE6EyVmGjnaJ4J+PNhrmYnnZ9F4znMewGY4T8OuQzKk5yAcgkWI3QFo52Saost3
	S6Q9K6bwsXQJUB7b2HhVo1E858P2d+607nGwuThXAKHr3Rpy160Qr1iyy3+6yRALOCX3Dn
	4cKqn9oia8b0Ule2Ob9KAsyZ9vVM9VQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=q1HlIrWN;
	spf=pass (imf30.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098519; a=rsa-sha256;
	cv=none;
	b=ZRKVSjxi8MfRv1evM4MwAjuvFCB9S/770Wn8UrAMsbfiN1zlPG3wlI2XJqfKDK5Fdt+ZXz
	ycWlIh6nlURqI4DUf5Mq0qeZwE7iifmBCnf9ohWONOkYtCmPiU+s5BFdGa8bi5iMl2hxTy
	NKZssp671aG0FH/85HK5APY8UjUjpO4=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260122161515epoutp016eee2dd9a43a50342e4e02f56d9ef8d1~NGboF5wDq1036510365epoutp01W
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:15:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260122161515epoutp016eee2dd9a43a50342e4e02f56d9ef8d1~NGboF5wDq1036510365epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769098515;
	bh=Ut0PvNTFkBDARJX4qSO9056XGy5KdZ5rJS/cjW/7pRk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=q1HlIrWNyqXlXJ8s7fdr+6FILnBgREtqtbL6tKRVnDJQDqNFP2+0kWYEsWdCFbTpY
	 +Q/VOdgW4Pmp1Z0/7nsG/3bIUEvgFb8cmslFKPWLb5SKPakzqL1B2ApoYpixV7P4E1
	 1lh6S8ZF86UVTN01KMmAKMW8lo42qiOHn4lGHGTE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260122161514epcas5p2ece65e143be4209661a3f0354ecff169~NGbnfPXfZ2058720587epcas5p2o;
	Thu, 22 Jan 2026 16:15:14 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dxmPF5YJ7z2SSKY; Thu, 22 Jan
	2026 16:15:13 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260122161513epcas5p2f245aaca490aadd994074f3fd52031e2~NGbmJDHS62060020600epcas5p2d;
	Thu, 22 Jan 2026 16:15:13 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260122161506epsmtip1e1a44b279ac7ac7ad390e8ab6dcb5c97~NGbgAiEqi0033200332epsmtip1T;
	Thu, 22 Jan 2026 16:15:06 +0000 (GMT)
Message-ID: <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
Date: Thu, 22 Jan 2026 21:45:05 +0530
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
In-Reply-To: <aXEvAD5Rf5QLp4Ma@bfoster>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260122161513epcas5p2f245aaca490aadd994074f3fd52031e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
	<20260116100818.7576-1-kundan.kumar@samsung.com> <aXEvAD5Rf5QLp4Ma@bfoster>
X-Stat-Signature: c9iskcwtma3j97take7ztcg4dituuqxj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0EF9E8000E
X-HE-Tag: 1769098518-505323
X-HE-Meta: U2FsdGVkX1/TkVhEZOyyJOWX3df631wCCdrLslmf2KGZR4dh1SWfgDnaK5uap04WMHg0i0UyVu627kd01R18PYSJvv8pkeNBx/9ZYgqP4h9KCu1lCq9ikBYFvlD7859lg9hqVvnExQS56D4E5f9MEiUMNDCzq1LFrtNeVhg1tWqJohe38qYDin+lNFKfunagXqlIaaB5rE6cqqWfcANETG8//7xRzOvI7xLsI0h4kEZUJoQ6SrwfHOryBfNmC5OSyfHCt2qoTLi1Xydir9DCPG5miGh3g1oLtOl7tQnkcIfFGDqtKTBqPWyVjc5Rr2yoDlObzKfKVXH0zDUYz6hcgz6KQXi32r0gfGfU1xmZRhPUG0S7kLthgINjVDWwCHsZHdIWuexegv968P2Q/UABi5rpshMPab/XBMxQu8cQLkipI3TnUaPyz1VinG8rVR9dIjHl4x48tO8Qk94TGw/fImNPFMVLBZC08e60rPH6xzTERSDYwKxIjLfIINWHNYZ+crIS9f9bQU5TM2mJNa2Si0lo5jJNlq1LItnLb6mfsP7ZBczACqBGqdOM8Hsuz6XPkWOkor/efaUr6iGwjYdaR2BW1GxLMn4CU7jgXI6dsD/c0Vj6v21u0+hJsafW25xSd2t/fSFZeGt7W2LGegcb1hqmxekmVxR/oOf/BYnTh8s2M+qEUPh1O4ebxGf4AEngu9QaoHYc3+PE6tftKxtXRHwADsHX0fRKQi+w8Kgh4gaK8gS/ryxt4vVcA0DATJe9AXDLqtXJFqLhz9Ob1mciN3UQEpJ5zhoA/U2oXqM7UrhjIKkn4cFOwyKt930nAX+JfipJHDx3MDq9Qk/WKJlJB/H4OS5fzux+MFf6gsewGaPWNYO6Ald2bor7M6hxKMrLkK82K++6UVN4q4glgLxn7E/ZH5fTvOv6L+HbJZm+0qh8+FshY+4Dub4qBmpnlVlpIKdQAj193XzhekmAR1/
 U4p6lAsT
 QeRjnyyab6MH9xj1NjZlUMJPCQ8nT4J1WpXTFFTcv7KS9qaHyNPFv7Lwsbvn47ReSZ79ZRctGPr3f0IoNFwhT8ldVOxLE6rkuswLyMDaBIyrA/hmxbqhHWnbQj63RIsjvKCAnx6yhRaGC3vPBMJrRZ3YvReythTbT5G+GfDLEoybKlIhYZCk/h56NH8i27SCXc8vR563aGRIerhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Could you provide more detail on how you're testing here? I threw this
> at some beefier storage I have around out of curiosity and I'm not
> seeing much of a difference. It could be I'm missing some details or
> maybe the storage outweighs the processing benefit. But for example, is
> this a fio test command being used? Is there preallocation? What type of
> storage? Is a particular fs geometry being targeted for this
> optimization (i.e. smaller AGs), etc.?

Thanks Brian for the detailed review and for taking the time to
look through the code.

The numbers quoted were from fio buffered write workloads on NVMe
(Optane devices), using multiple files placed in different
directories mapping to different AGs. Jobs were buffered
randwrite with multiple jobs. This can be tested with both
fallocate=none or otherwise.

Sample script for 12 jobs to 12 directories(AGs) :

mkfs.xfs -f -d agcount=12 /dev/nvme0n1
mount /dev/nvme0n1 /mnt
sync
echo 3 > /proc/sys/vm/drop_caches

for i in {1..12}; do
   mkdir -p /mnt/dir$i
done

fio job.fio

umount /mnt
echo 3 > /proc/sys/vm/drop_caches

The job file :

[global]
bs=4k
iodepth=32
rw=randwrite
ioengine=io_uring
fallocate=none
nrfiles=12
numjobs=1
size=6G
direct=0
group_reporting=1
create_on_open=1
name=test

[job1]
directory=/mnt/dir1

[job2]
directory=/mnt/dir2
...
...
[job12]
directory=/mnt/dir12

> 
> FWIW, I skimmed through the code a bit and the main thing that kind of
> stands out to me is the write time per-folio hinting. Writeback handling
> for the overwrite (i.e. non-delalloc) case is basically a single lookup
> per mapping under shared inode lock. The question that comes to mind
> there is what is the value of per-ag batching as opposed to just adding
> generic concurrency? It seems unnecessary to me to take care to shuffle
> overwrites into per-ag based workers when the underlying locking is
> already shared.
> 

That’s a fair point. For the overwrite (non-delalloc) case, the
per-folio AG hinting is not meant to change allocation behavior, and
I agree the underlying inode locking remains shared. The primary value
I’m seeing there is the ability to partition writeback iteration and
submission when dirty data spans multiple AGs.
I will try routing overwrite writeback to workers irrespective of AG
(e.g. hash/inode based), to compare between generic concurrency vs AG
batching.

> WRT delalloc, it looks like we're basically taking the inode AG as the
> starting point and guessing based on the on-disk AGF free blocks counter
> at the time of the write. The delalloc accounting doesn't count against
> the AGF, however, so ISTM that in many cases this would just effectively
> land on the inode AG for larger delalloc writes. Is that not the case?
> 
> Once we get to delalloc writeback, we're under exclusive inode lock and
> fall into the block allocator. The latter trylock iterates the AGs
> looking for a good candidate. So what's the advantage of per-ag
> splitting delalloc at writeback time if we're sending the same inode to
> per-ag workers that all 1. require exclusive inode lock and 2. call into
> an allocator that is designed to be scalable (i.e. if one AG is locked
> it will just move to the next)?
> 

The intent of per-AG splitting is not to parallelize allocation
within a single inode or override allocator behavior, but to
partition writeback scheduling so that inodes associated with
different AGs are routed to different workers. This implicitly
distributes inodes across AG workers, even though each inode’s
delalloc conversion remains serialized.

> Yet another consideration is how delalloc conversion works at the
> xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
> If you take a look at the latter, we look up the entire delalloc extent
> backing the folio under writeback and attempt to allocate it all at once
> (not just the blocks backing the folio). So in theory if we were to end
> up tagging a sequence of contiguous delalloc backed folios at buffered
> write time with different AGs, we're still going to try to allocate all
> of that in one AG at writeback time. So the per-ag hinting also sort of
> competes with this by shuffling writeback of the same potential extent
> into different workers, making it a little hard to try and reason about.
> 

Agreed — delalloc conversion happens at extent granularity, so
per-folio AG hints are not meant to steer final allocation. In this
series the hints are used purely as writeback scheduling tokens;
allocation still occurs once per extent under XFS_ILOCK_EXCL using
existing allocator logic. The goal is to partition writeback work and
avoid funneling multiple inodes through a single writeback path, not
to influence extent placement.

> So stepping back it kind of feels to me like the write time hinting has
> so much potential for inaccuracy and unpredictability of writeback time
> behavior (for the delalloc case), that it makes me wonder if we're
> effectively just enabling arbitrary concurrency at writeback time and
> perhaps seeing benefit from that. If so, that makes me wonder if the
> associated value can be gained by somehow simplifying this to not
> require write time hinting at all.
> 
> Have you run any experiments that perhaps rotors inodes to the
> individual wb workers based on the inode AG (i.e. basically ignoring all
> the write time stuff) by chance? Or anything that otherwise helps
> quantify the value of per-ag batching over just basic concurrency? I'd
> be interested to see if/how behavior changes with something like that.

Yes, inode-AG based routing has been explored as part of earlier
higher-level writeback work (link below), where inodes are affined to
writeback contexts based on inode AG. That effectively provides
generic concurrency and serves as a useful baseline.
https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/

The motivation for this series is the complementary case where a
single inode’s dirty data spans multiple AGs on aged/fragmented
filesystems, where inode-AG affinity breaks down. The folio-level AG
hinting here is intended to explore whether finer-grained partitioning
provides additional benefit beyond inode-based routing.


