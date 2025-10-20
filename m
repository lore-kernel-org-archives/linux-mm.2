Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6B2CCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 22:46:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F40D8E0006; Mon, 20 Oct 2025 18:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB5E8E0005; Mon, 20 Oct 2025 18:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0E98E0006; Mon, 20 Oct 2025 18:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A56E8E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:46:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF08BC0308
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:46:37 +0000 (UTC)
X-FDA: 84019978434.02.80FD7F8
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3A0F8000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 22:46:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=cl4CW6iS;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761000395; a=rsa-sha256;
	cv=none;
	b=YahgcYaZO6znkym0FANwruoaT8p6NoXVaWgy7Pnv3U1Rr0H9Eql8QJvS3HWYIUlPbDVsT8
	hRElfpzv3q4HngWrsAkRZrhVMKF8BZGQCPVKa+NY5fGI5chkaiJ1qO80E8YvEubSc6zAWL
	SIKRkzVF6f6f63fBr+BNW1OZ9dogqPQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=cl4CW6iS;
	spf=pass (imf02.hostedemail.com: domain of david@fromorbit.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761000395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUtWq6BwnjWVaI8PPEZSZXu56vepaxMGdapsduu3y9o=;
	b=2k2HQ4EC0sxBYm+dcKdD/bPGtU34dsSW4qWOO8AbMxJl9sEqKZ/BA+UVLidSFOHd7YO87z
	hHrh+sLML7FdEB/6aHV8KXXlG4fIk8SvHgyTIWdGOC7pKZwZTHfh5YxX3jGI1PcooiUDcg
	q+qjxA6PuMJYuhGP26Q1HS5oCyYQzA4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27ee41e074dso57777605ad.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761000394; x=1761605194; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bUtWq6BwnjWVaI8PPEZSZXu56vepaxMGdapsduu3y9o=;
        b=cl4CW6iS6wwWs+LIQVvaWx+XJW77jqw/lP3gznyp7mGjN5MkfnQHIvPCEqz7CMxO0g
         X4Dc/+deW7TJKZYmIhEl8ecV5iJ6yYDLe2/RLI8cOsRLM0SehnuzY/v3ov8nxZhDZpPV
         D1UUhqXnH2rFe0OUufTF9ga0QNekAmP3d+dCowWok1HjTMOt8m56ddwSVq985Zok2dML
         Xg73iquOm67B9y4cOD9lgIwe91oDtoEcM99mw5GI7adNVYH7RA7IXwyvsSaIpH9mBn3e
         ruxrDn4rg2TWef6APF/qK+fSJitNwZdb7qHeHkSOdZjMbCiPdraTgfAb0ST6xZCmleHE
         FcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761000394; x=1761605194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUtWq6BwnjWVaI8PPEZSZXu56vepaxMGdapsduu3y9o=;
        b=CMp0lXfcKS20OmL0qCwqqDY7PbpMsqJ4yQroTrA0XmVUKIVZ6/sp418TF17UJpmZmH
         GsCuGXXd2lyLo+fSvNmiqmJSZqq8/8p0O1k5kxEtGq47i3SRYwNfWxeQ7XucwQGGaRJa
         OdYKW+dSsRI2VEoINVajc9e3nTdeFeIzqvsvKIbTcS+zaL2GD0DHG34JMoLFLWFPdUEc
         W5C4UCOuuuEPrTmVdnB3L2x/2doNFfiavSogRTgOWZ7Q0X4MmgGNBn1A45xjkBnvcyOD
         z/2a8jQEcXlGFNqpojhRA0pEYDBYsSY19qeXgQ6EEXp0dxE33A9eoEzP37thzk5udfpg
         8qPg==
X-Forwarded-Encrypted: i=1; AJvYcCWj8keX8zaWz+MQZv+4ygby3FyJY5JWaveMI4NxY+hW/SDMYk0XD1/TXq1YjOuqsNa4lvlEVJRqSg==@kvack.org
X-Gm-Message-State: AOJu0Yy81mFA4Th4mZ6wE2pk5HxeQOZPiPELmpbFHyFNs5EmLb1j7Ntd
	2T0e+zep3wDs82LCEMR0Z/bZXsOQP0lg+932H+5dO6hNzS1eRiMst3grVJkoqPe+flI=
X-Gm-Gg: ASbGnct+w1xgjwZqmWscnDiHXXL8VEZ8+31NqCAlav6XqWzKJKR76AlRW5LjbpTq2+0
	rWot2mte0Du+2uutBS+3nQ6wGonDMZTQ8V8I0L4ST1G9T+xS46VtbaCn28rJ8wL0lUu+Is92W3r
	qpxY4ZEBysQl8nmrzGElam3p2CmFqSTWvkRRQTPOCmITXeZL4tcAWSR2DQ6FhoF09d+CwpHW4GZ
	OGluS8ovKFHGRY3DF00jFKX7iAif+Dn3DjhPmnVNlzNVStAudZuBhYm/54u5f551U30lzq+qleB
	mueH2qdYshOKfogBf9FaMFdCYPZAB7E5xDQIH7DtbAhGP47RWM9ZXp46fvatouTcvKNtXU2NTIk
	DKWHWxNuyg249hY29IxJDhmR/50o5bj6IAHlC+a8iKeSUZdEhmiVGDvsGre8hG8DuaiNTXN5pRH
	O7qwBRpf5UG/A5AKX+q9+qMTXQd0W7YF6Kc04S4ewIWRYiwA/WZ8M=
X-Google-Smtp-Source: AGHT+IFUIIz9u3gROHoyBrX9GrfKv6A6QBpIppZbYxVF4pPYqH4Q7yX35XtiJX79fRgqZ/TJvN1KGA==
X-Received: by 2002:a17:902:d4c4:b0:25b:f1f3:815f with SMTP id d9443c01a7336-290cb65f80emr187540085ad.58.1761000394302;
        Mon, 20 Oct 2025 15:46:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d594esm90846765ad.72.2025.10.20.15.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 15:46:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vAye6-0000000HVzd-2eTg;
	Tue, 21 Oct 2025 09:46:30 +1100
Date: Tue, 21 Oct 2025 09:46:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <aPa7xozr7YbZX0W4@dread.disaster.area>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
 <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
X-Rspam-User: 
X-Stat-Signature: imry3ghequp6m457jyasd9dnm44g8574
X-Rspamd-Queue-Id: B3A0F8000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761000395-789919
X-HE-Meta: U2FsdGVkX18sGwgWB1FN1TMrKjBmamKqw1mDFlW5UxQBGU9dMmuajL27RBRLu8yvGMOdX/nRWFDbXSrex3igBRPzNL5cyX87I5Kg/w3r8HVAQUE25jtmDPxnu31Q2u5iNHlLu4jrNlqyYAinbddterIyKKvz4qFxqEhSrYUgfgFmEbVw22iOYX4x30jpgrghB2I4cbLDuwaUly+x7LBgAvuOxXCbt8rV81c9p7ycaC9o3NEm36xhF8ubUKhv6vN/5D1Zk4xIcRkmlrQ3YCRFhJQZqBkpgZjrcjpHaByU4c0L241qMRAj2S7BGtypKZWqKKaM+4aAL3pELLF5S2/1Xo66CWwydHM7pCKuq0DxqPFMU351SvpXysq2cmCiYvNPOoPDfFC523JINj5weNSwJi/PFv6ayFWRQsEU1s2+a9ZVDcSndrbUtkue6KMcfX1pZfcGk0h/SErOTGfXCn7AHu+eRFjTu8Fhx0KOMpd55ahT0m06Y+63hhRiggi4GyPF4I6dDx62BQrLSOHUR4ZtYGQTXzrUnuG/keDrMINEuV33f6faFsmWyai+m3znL8fzCnZE2ra9hA4CHy4owz7CL+MvmLx21RdYK6APpK0KgPcV3UYrmle15WVqIm4htNej0w+/EcTiXDkxHPjSptC47nXUvHI3HnGgbC92YQnNxojECSmihRQe7DOZwyOuw1qdr2aNpKyRqVCQL/yUFpK/8lHoD7nB6VzAuBWZdVu0oM+LBwVzQcvsdZ9DOd9mXx2LGDsfGTI5Hp/oJ1SIrlqvmafZoekTWIzf3J0Nz4z+WlVBhmNVYIXpr0t8fZq5MquebNmkuLqZl+URHFSjCLWy5DAKf8iorhRu6WRxxK7+twqmEqd5TPK8IXpp3jOsKR4nPuo6BLtdQ3a7Q/3LvDHQ4saJ6Bf8TAeqysiqpQwbt3fYdZ1+jiEJPoeNoAKS9qz8nlDNdEeDFqxhqcxk/TP
 oJGNC0AO
 y8Lg8VV1H+r6eDyR2aGZXgnxUK+UjFscBkDdM2Lm8vI65Y5X6k32ycjo863Twk5Dd7Mki57wkZIbovETAjpmUnkS7l8rk2nAdvV8yjdeE2rfZSbYcoYJ7F9qOZV4njBKU3z+DrBg01UkEaJuOJNdA1w+jNfgRcQ/hVcJDDdc8nPK2CB4420/2jx+QJbv6xlj5sNDrf79eJ7j0fC8sS9IMUGi7jEg25j0re2Cpnj1fZ5k4NyqcpAkKWh9Nx7N9QGZj4NhQYSTQu1l5h7BOugrOjifOzZrO9LqxjMh+35A195EP3AImLXCpw/JpEqrTTOMc+wnEIJ3G/VW23aeekUG988yHw6DbtP/TAh4Dr3O7lCEiNhywU2G6Nq/dEgy3WLZ2wMKc5uVUrLYVeUi8eeAnbJsplffLt0QkrLbI825lE8Tf0ouasql/i9G8xZOsh7XYef7Vw6S0pa3BUsQVFf4iHD+quAsgZO6kDBuQIyavGVdERCm3xJ+sS9F4TEWBvWia6d13RkGKumIGHkoTzs80PZtQbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:38:29PM +0530, Kundan Kumar wrote:
> Number of writeback contexts
> ============================
> We've implemented two interfaces to manage the number of writeback
> contexts:
> 1) Sysfs Interface: As suggested by Christoph, we've added a sysfs
>    interface to allow users to adjust the number of writeback contexts
>    dynamically.
> 2) Filesystem Superblock Interface: We've also introduced a filesystem
>    superblock interface to retrieve the filesystem-specific number of
>    writeback contexts. For XFS, this count is set equal to the
>    allocation group count. When mounting a filesystem, we automatically
>    increase the number of writeback threads to match this count.

This is dangerous. What happens when we mount a filesystem with
millions of AGs?


> Resolving the Issue with Multiple Writebacks
> ============================================
> For XFS, affining inodes to writeback threads resulted in a decline
> in IOPS for certain devices. The issue was caused by AG lock contention
> in xfs_end_io, where multiple writeback threads competed for the same
> AG lock.
> To address this, we now affine writeback threads to the allocation
> group, resolving the contention issue. In best case allocation happens
> from the same AG where inode metadata resides, avoiding lock contention.

Not necessarily. The allocator can (and will) select different AGs
for an inode as the file grows and the AGs run low on space. Once
they select a different AG for an inode, they don't tend to return
to the original AG because allocation targets are based on
contiguous allocation w.r.t. existing adjacent extents, not the AG
the inode is located in.

Indeed, if a user selects the inode32 mount option, there is
absolutely no relationship between the AG the inode is located in
and the AG it's data extents are allocated in. In these cases,
using the inode resident AG is guaranteed to end up with a random
mix of target AGs for the inodes queued in that AG.  Worse yet,
there may only be one AG that can have inodes allocated in it, so
all the writeback contexts for the other hundreds of AGs in the
filesystem go completely unused...

> Similar IOPS decline was observed with other filesystems under different
> workloads. To avoid similar issues, we have decided to limit
> parallelism to XFS only. Other filesystems can introduce parallelism
> and distribute inodes as per their geometry.

I suspect that the issues with XFS lock contention are related to
the fragmentation behaviour observed (see below) massively
increasing the frequency of allocation work for a given amount of
data being written rather than increasing writeback concurrency...

> 
> IOPS and throughput
> ===================
> With the affinity to allocation group we see significant improvement in
> XFS when we write to multiple files in different directories(AGs).
> 
> Performance gains:
>   A) Workload 12 files each of 1G in 12 directories(AGs) - numjobs = 12
>     - NVMe device BM1743 SSD

So, 80-100k random 4kB write IOPS, ~2GB/s write bandwidth.

>         Base XFS                : 243 MiB/s
>         Parallel Writeback XFS  : 759 MiB/s  (+212%)

As such, the baseline result doesn't feel right - it doesn't match
my experience with concurrent sequential buffered write workloads on
SSDs. My expectation is that they'd get close to device bandwidth or
run out of copy-in CPU at somewhere over 3GB/s.

So what are you actually doing to get these numbers? What is the
benchmark (CLI and conf files details, please!), what is the
mkfs.xfs output, and how many CPUs/RAM do you have on the machines
you are testing?  i.e. please document them sufficiently so that
other people can verify your results.

Also, what is the raw device performance and how close to that are
we getting through the filesystem?

>     - NVMe device PM9A3 SSD

130-180k random 4kB write IOPS, ~4GB/s write bandwidth. So roughly
double the physical throughput of the BM1743, and ....

>         Base XFS                : 368 MiB/s
>         Parallel Writeback XFS  : 1634 MiB/s  (+344%)

.... it gets roughly double the physical throughput of the BM1743.

This doesn't feel like a writeback concurrency limited workload -
this feels more like a device IOPS and IO depth limited workload.

>   B) Workload 6 files each of 20G in 6 directories(AGs)  - numjobs = 6
>     - NVMe device BM1743 SSD
>         Base XFS                : 305 MiB/s
>         Parallel Writeback XFS  : 706 MiB/s  (+131%)
> 
>     - NVMe device PM9A3 SSD
>         Base XFS                : 315 MiB/s
>         Parallel Writeback XFS  : 990 MiB/s  (+214%)
> 
> Filesystem fragmentation
> ========================
> We also see that there is no increase in filesystem fragmentation
> Number of extents per file:

Are these from running the workload on a freshly made (i.e. just run
mkfs.xfs, mount and run benchmark) filesystem, or do you reuse the
same fs for all tests?

>   A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
>         Base XFS                : 17
>         Parallel Writeback XFS  : 17

Yup, this implies a sequential write workload....

>   B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
>         Base XFS                : 166593
>         Parallel Writeback XFS  : 161554

which implies 144 files, and so over 1000 extents per file. Which
means about 1MB per extent and is way, way worse than it should be
for sequential write workloads.

> 
>   C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
>         Base XFS                : 3173716
>         Parallel Writeback XFS  : 3364984

36 files, 720GB and 3.3m extents, which is about 100k extents per
file for an average extent size of 200kB. That would explain why it
performed roughly the same on both devices - they both have similar
random 128kB write IO performance...

But that fragmentation pattern is bad and shouldn't be occurring fro
sequential writes. Speculative EOF preallocation should be almost
entirely preventing this sort of fragmentation for concurrent
sequential write IO and so we should be seeing extent sizes of at
least hundreds of MBs for these file sizes.

i.e. this feels to me like you test is triggering some underlying
delayed allocation defeat mechanism that is causing physical
writeback IO sizes to collapse. This turns what should be a
bandwitdh limited workload running at full device bandwidth into an
IOPS and IO depth limited workload.

In adding writeback concurrency to this situation, it enables
writeback to drive deeper IO queues and so extract more small IO
performance from the device, thereby showing better performance for
the wrokload. The issue is that baseline writeback performance is
way below where I think it should be for the given IO workload (IIUC
the workload being run, hence questions about benchmarks, filesystem
configs and test hardware).

Hence while I certainly agree that writeback concurrency is
definitely needed, I think that the results you are getting here are
a result of some other issue that writeback concurrency is
mitigating. The underlying fragmentation issue needs to be
understood (and probably solved) before we can draw any conclusions
about the performance gains that concurrent writeback actually
provides on these workloads and devices...

-Dave.
-- 
Dave Chinner
david@fromorbit.com

