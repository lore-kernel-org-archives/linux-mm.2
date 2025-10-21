Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C689CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB398E0013; Tue, 21 Oct 2025 06:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82FC8E0002; Tue, 21 Oct 2025 06:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98CB8E0013; Tue, 21 Oct 2025 06:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C33EB8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:36:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F855B9844
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:36:38 +0000 (UTC)
X-FDA: 84021767676.16.36556AD
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf19.hostedemail.com (Postfix) with ESMTP id 155021A0010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:36:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=lqVTJzji;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf19.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761042996; a=rsa-sha256;
	cv=none;
	b=kcyRTl39ndFfjAhN+uTD9EI9PgntfIqjrd/2MP//7YNhfE7ZpQgOL0GoMbQnPuILROm9Pw
	X/8IyAXOlbxQlNSudVqTpKbiS04LwkLHQlHoX7rdFtqd46a5QaFu37c9dwn1tL5t1A5ZVQ
	OhrGsWIXhGHlAMsPBUBcft8YiX+qFOk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=lqVTJzji;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf19.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761042996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsQCI8iew+pHyZGlqcgByv/CbFDTHT7k4bxRlb4DRbo=;
	b=L3hl4n9xSqjCsV7wEof8rQMKdM+4QpP//A1ZpC6QJvhESWjMzRWGdOMVQKV+44/BXpIZ6H
	V4HORRK4bIbylWKN544I4/Z/iFyrlB55wEquI6WhrVmbjlks/6xAP1XCSx3EkI8cw6Orj8
	wxZ+7X2hHDVJeQxK6IbDJ+gRMNGeDE8=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251021103631epoutp018a956e3f0fc47806af59c838e19a9470~we0UtD8Mw1210612106epoutp01G
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:36:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251021103631epoutp018a956e3f0fc47806af59c838e19a9470~we0UtD8Mw1210612106epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1761042991;
	bh=HsQCI8iew+pHyZGlqcgByv/CbFDTHT7k4bxRlb4DRbo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=lqVTJzjiViwLvtPEinPu/Xjuq/K9X0k8qNsAWIo0X0IBiUFYLsSClONg3/gM5D7eB
	 UvdqM5ywKtjfZfUzKdqaaOkEXaKVNl85+7TelDN5CE+TOP+mioideD3b04/1hfy+mg
	 KW7BTGGy19cfbK0DtBSrmoropHMgbDFIea4xhdDU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251021103630epcas5p435dae0ee9578598211e7066cedc621c2~we0TrEpWD0288102881epcas5p47;
	Tue, 21 Oct 2025 10:36:30 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4crTHK1zMHz6B9m7; Tue, 21 Oct
	2025 10:36:29 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251021103628epcas5p1b7baecd88baf9cf66127e17613f268e4~we0RnAWVC2779827798epcas5p1e;
	Tue, 21 Oct 2025 10:36:28 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251021103622epsmtip11f8ba67056c7c576fea39dc357410495~we0M5IZcp2042120421epsmtip1P;
	Tue, 21 Oct 2025 10:36:22 +0000 (GMT)
Message-ID: <6fe26b74-beb9-4a6a-93af-86edcbde7b68@samsung.com>
Date: Tue, 21 Oct 2025 16:06:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, amir73il@gmail.com,
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com,
	joshi.k@samsung.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <aPa7xozr7YbZX0W4@dread.disaster.area>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20251021103628epcas5p1b7baecd88baf9cf66127e17613f268e4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
	<20251014120845.2361-1-kundan.kumar@samsung.com>
	<aPa7xozr7YbZX0W4@dread.disaster.area>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 155021A0010
X-Stat-Signature: hhxdbse76hbr6pap7w7pa19texhb1wy4
X-HE-Tag: 1761042994-549978
X-HE-Meta: U2FsdGVkX19CT+fWnhtFj6rUW7pMvSCGj58Nx+iEBko/LeVXgcQi5j5eXVAOUA5xfaqZ+ctwYul9glD6jcYrWGomo4x5y99JlkHnW9hR+U6P2lpjPMNE/lhfUXxSTv2FlHdxNsV/+JYGK+MjFtnoWzeSUc1obA+McebzuulBxKRXTs2BJUI1wtHhcCIp3GY51gGQh+yl4krD6L0bw86cSxa+HbN+T8Q4cLxz0WcQ3LmIeyhhwPPXOdO4TICII3sHrymH46Fk/QMkCsqpGJEftGLvvteNRMW8wPzFXR77zZ3j0ewXp98K+yL3RWdleDEO4Y4eSu2Kw4TAZmf65dvvpTqQun5Tjk3F0ta1ONIUFhWhrE+vnvoGhsb42UpegFcXhmsmjILIAr2VsgLl6gBSvVmVw1Vcj8h0wLdKz7l0zUprls2iLMieWcdDOkm8TIqfknqkqorS8bVFKpeOdUPDCcYNJjYX04QHKoxeuqWh0GXzdFzUxdS/J8bze3UChxFb1nUydLiNp5bm9pEVlWMLFw10Hae0ghtza7MEnC3lcQ/WayegwrQ64Epp9GBVKP5RRHqBED/+LgyVXMl9qLFcAK3eoP1TsxclcS42UAnXVoQU2LKj1r+GqaDxmBocQFzDFFBkNBAlKoBV0mzM3NgdPXPqz1KEFM8wG0GUehe6g0614yi38bhGbEJSw5TszKDu4/aNHDUYrIZ0oNCa7P20Aq2+kYkiV0Kie7gHZXHARBKIltHlf7T+Q6I4Ixqa9wzeNncApGV/1Q6MvaBKYCEbYAHUbyb4elJqozPWHhJvm4zPbcSdcUPgE6aWG63v1OG5tK3ErlMsVv0DEBBlawuVBISo2AihYMpbSDUZ5PSuu7ILsOQuDnX1ljE1OujOuJteKUA4LIe5Av8wj6J24d1spJkkhUScdsfa7aQtnNOoJZ4kKOBaFAEa//ojSDK8jF3R25FmA0FHMSFRoNWSw29
 MT2mGS6k
 OavrCiO9BoZESwBzgLrPaAv5ammcMoxZKOcWIq6wYy7gSnIUMg3HUI20Iv9dVdE3pau8ZXSrHWeKktsyup8H+txvMHSbfaugIp73DnnFm2P/4KbXdc2kyry7gqfEanLK4SjrZ8JY7ma8bFEWVYIL3DWHb//iMiUJSZJAdgMD9ucC6ZrjplkzrAkz61GobVZe3nBBiM0FT+D/LFbo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/2025 4:16 AM, Dave Chinner wrote:

Thanks Dave for the detailed feedback.

> On Tue, Oct 14, 2025 at 05:38:29PM +0530, Kundan Kumar wrote:
>> Number of writeback contexts
>> ============================
>> We've implemented two interfaces to manage the number of writeback
>> contexts:
>> 1) Sysfs Interface: As suggested by Christoph, we've added a sysfs
>>     interface to allow users to adjust the number of writeback contexts
>>     dynamically.
>> 2) Filesystem Superblock Interface: We've also introduced a filesystem
>>     superblock interface to retrieve the filesystem-specific number of
>>     writeback contexts. For XFS, this count is set equal to the
>>     allocation group count. When mounting a filesystem, we automatically
>>     increase the number of writeback threads to match this count.
> 
> This is dangerous. What happens when we mount a filesystem with
> millions of AGs?
> 

Good point. How about adding an upper bound e.g. limiting the number
of writeback contexts to something like nr_cpus * k and mapping AGs
dynamically to that bounded pool.

> 
>> Resolving the Issue with Multiple Writebacks
>> ============================================
>> For XFS, affining inodes to writeback threads resulted in a decline
>> in IOPS for certain devices. The issue was caused by AG lock contention
>> in xfs_end_io, where multiple writeback threads competed for the same
>> AG lock.
>> To address this, we now affine writeback threads to the allocation
>> group, resolving the contention issue. In best case allocation happens
>> from the same AG where inode metadata resides, avoiding lock contention.
> 
> Not necessarily. The allocator can (and will) select different AGs
> for an inode as the file grows and the AGs run low on space. Once
> they select a different AG for an inode, they don't tend to return
> to the original AG because allocation targets are based on
> contiguous allocation w.r.t. existing adjacent extents, not the AG
> the inode is located in.
> 

The tests were conducted under ideal conditions, where the Allocation
Groups (AGs) had sufficient space. The design for affining writeback
threads to AGs is based on the assumption that allocations typically
occur within the same AG, unless it's low on space. To predict the AG
from which the allocation will happen, additional logic would be
required. This enhancement can be considered for a future phase, with
the get_inode_wb_ctx() function being the suitable location for
implementation.

> Indeed, if a user selects the inode32 mount option, there is
> absolutely no relationship between the AG the inode is located in
> and the AG it's data extents are allocated in. In these cases,
> using the inode resident AG is guaranteed to end up with a random
> mix of target AGs for the inodes queued in that AG.  Worse yet,
> there may only be one AG that can have inodes allocated in it, so
> all the writeback contexts for the other hundreds of AGs in the
> filesystem go completely unused...
> 
For inode32 mounts, does it make sense to restricting to single-threaded
writeback, or you have other thoughts for same ?

>> Similar IOPS decline was observed with other filesystems under different
>> workloads. To avoid similar issues, we have decided to limit
>> parallelism to XFS only. Other filesystems can introduce parallelism
>> and distribute inodes as per their geometry.
> 
> I suspect that the issues with XFS lock contention are related to
> the fragmentation behaviour observed (see below) massively
> increasing the frequency of allocation work for a given amount of
> data being written rather than increasing writeback concurrency...
> 
>>
>> IOPS and throughput
>> ===================
>> With the affinity to allocation group we see significant improvement in
>> XFS when we write to multiple files in different directories(AGs).
>>
>> Performance gains:
>>    A) Workload 12 files each of 1G in 12 directories(AGs) - numjobs = 12
>>      - NVMe device BM1743 SSD
> 
> So, 80-100k random 4kB write IOPS, ~2GB/s write bandwidth.
> 
>>          Base XFS                : 243 MiB/s
>>          Parallel Writeback XFS  : 759 MiB/s  (+212%)
> 
> As such, the baseline result doesn't feel right - it doesn't match
> my experience with concurrent sequential buffered write workloads on
> SSDs. My expectation is that they'd get close to device bandwidth or
> run out of copy-in CPU at somewhere over 3GB/s.
> 
> So what are you actually doing to get these numbers? What is the
> benchmark (CLI and conf files details, please!), what is the
> mkfs.xfs output, and how many CPUs/RAM do you have on the machines
> you are testing?  i.e. please document them sufficiently so that
> other people can verify your results.
> 

All tests were done with random writes. I am sharing complete test
script and config details.

mkfs output
===========
meta-data=/dev/nvme2n1           isize=512    agcount=128, 
agsize=117188604 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=1 inobtcount=1 
nrext64=1
          =                       exchange=0   metadir=0
data     =                       bsize=4096   blocks=15000141312, imaxpct=1
          =                       sunit=4      swidth=32 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
          =                       rgcount=0    rgsize=0 extents
          =                       zoned=0      start=0 reserved=0

Script to issue the IO
======================
mkfs.xfs -f /dev/nvme2n1
mount /dev/nvme2n1 /mnt

sync
echo 3 > /proc/sys/vm/drop_caches

for i in {1..12}; do
         mkdir -p /mnt/dir$i
done

fio job_nvme.fio

umount /mnt
echo 3 > /proc/sys/vm/drop_caches
sync

File job_nvme.fio
=================
[global]
bs=4k
iodepth=32
rw=randwrite
ioengine=io_uring
nrfiles=12
numjobs=1                # Each job writes to a different file
size=12g
direct=0                 # Buffered I/O to trigger writeback
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

Number of CPUs = 128
System RAM = 128G

> Also, what is the raw device performance and how close to that are
> we getting through the filesystem?
>

Raw IO performance BM1743 SSD
fio -iodepth=32 --rw=randwrite -direct=1 -ioengine=io_uring -bs=4K 
-numjobs=1 -size=100G -group_reporting -filename=/dev/nvme2n1 
-name=direct_test
write: IOPS=117k, BW=457MiB/s (479MB/s)(100GiB/224303msec)

Raw IO performance PM9A3 SSD
write: IOPS=546k, BW=2132MiB/s (2235MB/s)(100GiB/48036msec)

>>      - NVMe device PM9A3 SSD
> 
> 130-180k random 4kB write IOPS, ~4GB/s write bandwidth. So roughly
> double the physical throughput of the BM1743, and ....
> 
>>          Base XFS                : 368 MiB/s
>>          Parallel Writeback XFS  : 1634 MiB/s  (+344%)
> 
> .... it gets roughly double the physical throughput of the BM1743.
> 

BM1743 is a large IU device with a 16K IU size, which is not optimized
for my 4K IO operations, resulting in lower throughput. In contrast,
PM9A3 is a faster device that handles IO operations more efficiently.

> This doesn't feel like a writeback concurrency limited workload -
> this feels more like a device IOPS and IO depth limited workload.
> 
>>    B) Workload 6 files each of 20G in 6 directories(AGs)  - numjobs = 6
>>      - NVMe device BM1743 SSD
>>          Base XFS                : 305 MiB/s
>>          Parallel Writeback XFS  : 706 MiB/s  (+131%)
>>
>>      - NVMe device PM9A3 SSD
>>          Base XFS                : 315 MiB/s
>>          Parallel Writeback XFS  : 990 MiB/s  (+214%)
>>
>> Filesystem fragmentation
>> ========================
>> We also see that there is no increase in filesystem fragmentation
>> Number of extents per file:
> 
> Are these from running the workload on a freshly made (i.e. just run
> mkfs.xfs, mount and run benchmark) filesystem, or do you reuse the
> same fs for all tests?

I create a new file system for each test run.

> 
>>    A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
>>          Base XFS                : 17
>>          Parallel Writeback XFS  : 17
> 
> Yup, this implies a sequential write workload....
> 

This is random IO. As the workload is small the extents merge more.

>>    B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
>>          Base XFS                : 166593
>>          Parallel Writeback XFS  : 161554
> 
> which implies 144 files, and so over 1000 extents per file. Which
> means about 1MB per extent and is way, way worse than it should be
> for sequential write workloads.
> 

Previous results of fragmentation were taken with randwrite. I took
fresh data for sequential IO and here are the results.
number of extents reduces a lot for seq IO:
   A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
         Base XFS                : 1
         Parallel Writeback XFS  : 1

   B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
         Base XFS                : 4
         Parallel Writeback XFS  : 3

   C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
         Base XFS                : 4
         Parallel Writeback XFS  : 4

>>
>>    C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
>>          Base XFS                : 3173716
>>          Parallel Writeback XFS  : 3364984
> 
> 36 files, 720GB and 3.3m extents, which is about 100k extents per
> file for an average extent size of 200kB. That would explain why it
> performed roughly the same on both devices - they both have similar
> random 128kB write IO performance...
> 
> But that fragmentation pattern is bad and shouldn't be occurring fro
> sequential writes. Speculative EOF preallocation should be almost
> entirely preventing this sort of fragmentation for concurrent
> sequential write IO and so we should be seeing extent sizes of at
> least hundreds of MBs for these file sizes.
> 
> i.e. this feels to me like you test is triggering some underlying
> delayed allocation defeat mechanism that is causing physical
> writeback IO sizes to collapse. This turns what should be a
> bandwitdh limited workload running at full device bandwidth into an
> IOPS and IO depth limited workload.
> 
> In adding writeback concurrency to this situation, it enables
> writeback to drive deeper IO queues and so extract more small IO
> performance from the device, thereby showing better performance for
> the wrokload. The issue is that baseline writeback performance is
> way below where I think it should be for the given IO workload (IIUC
> the workload being run, hence questions about benchmarks, filesystem
> configs and test hardware).
> 

I have tried to share config, benchmarking script and data,
if you feel some details are missing please let me know.

> Hence while I certainly agree that writeback concurrency is
> definitely needed, I think that the results you are getting here are
> a result of some other issue that writeback concurrency is
> mitigating. The underlying fragmentation issue needs to be
> understood (and probably solved) before we can draw any conclusions
> about the performance gains that concurrent writeback actually
> provides on these workloads and devices...
> 

In these tests we've observed that fragmentation remains consistent 
across sequential and random IO workloads. Your feedback on this would 
be valuable.


