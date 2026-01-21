Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B833C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9256B009B; Wed, 21 Jan 2026 14:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D676B009D; Wed, 21 Jan 2026 14:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B5C6B009E; Wed, 21 Jan 2026 14:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92B416B009B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:54:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 385778D162
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:54:59 +0000 (UTC)
X-FDA: 84357024318.06.6EE5E94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 337AB4000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:54:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHZU8u0q;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769025297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfynPqgAvAkpjBmuuO2JFrn162BWPXesCBnZDuNhRyE=;
	b=DBJmmIxKL1K+ecJWLxgyDv6Js98SYoPwsiNTRZyg2eC/GKSut5NbpPxdGnKAjH+XcuVg3E
	MtOOGnHqw9wOvBViayAd2dQlGZaMpPIlc6X/oYUTJgRYQYpQpr+2EO2rTwjEFtMuOAzyZw
	jgKa3yrzdsTX5/svnjDVZLjwO5pCZDE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHZU8u0q;
	spf=pass (imf17.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769025297; a=rsa-sha256;
	cv=none;
	b=7YiYE1N8DAiznCw7TwqKWdwy2AuxCABL6M4K8g6Mny6TIpdQfxl0Va6le9pyZM4WN/ZOWu
	FpOZGblc2ZuUl/sUy3RLHe+iaZFH0XPbIvsuUcPnKAZQtJrpO8kEveHRttmmZViQ8IFAdv
	kOmi5KVhzp1J7UFKCWVusfq/zrBehcg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769025296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zfynPqgAvAkpjBmuuO2JFrn162BWPXesCBnZDuNhRyE=;
	b=hHZU8u0qBtUBcSMzbEQYk9D95HSmR5DiVofxBqsCvhJ+7HAK5liTzamOeXIajSNaI1Tjn6
	3yRnoXfigKREAXxtOtL/j+HccxSId+wUEoX1s8GR+IlWG/5Q28pu8K1cki1TtzU3RTjaxD
	D8q3MYOe1CrYT9S+Jquf4ZMaIwh0kuA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-lFkgxWuyM0i-XSDNQC4aXQ-1; Wed,
 21 Jan 2026 14:54:51 -0500
X-MC-Unique: lFkgxWuyM0i-XSDNQC4aXQ-1
X-Mimecast-MFC-AGG-ID: lFkgxWuyM0i-XSDNQC4aXQ_1769025289
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4895719560B2;
	Wed, 21 Jan 2026 19:54:47 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.128])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A97018001D5;
	Wed, 21 Jan 2026 19:54:42 +0000 (UTC)
Date: Wed, 21 Jan 2026 14:54:40 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 0/6] AG aware parallel writeback for XFS
Message-ID: <aXEvAD5Rf5QLp4Ma@bfoster>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 337AB4000B
X-Rspamd-Server: rspam07
X-Stat-Signature: kstzuwm1ahnzhhehw9az3g77gx999x3k
X-HE-Tag: 1769025296-591840
X-HE-Meta: U2FsdGVkX1+xSc+Dyxz2/UJEFj+74LoNpCeE99f6I4Mjn8woRbUT51hbSd7gYOSAyO9//MiChYAofWpPoEgUC4NyO6YsA6BhUJIn5NdGqXnvtq0D5nntpaUcqnQMuQWb5fNc3U3sxdQNEZGo/KZk/X0HyDiggeTRBu5PQSdBkklYVM5f+h92lMFAoDIgUVu23SP6O8c1x2KrAv5CIZnyCCrgEfYThHy+L8O565coTxHu3/ZAKteeOu79Mgu3zfHGTg6MxyK044+fjlSEXT8c0islUWSeMxnl+dsHCMXce3v/OzPyphDfZRmbaQtCRCJI3YTr6IBVn41n0rII7iqeh8YAwyDqkuYti5CT5aQ55EJavH8Pso61GHihh9Nfxsf0O0Ghqy+frzExj9t0nF0Kk+a+UMzwqhskNOmPtJK/HmqVcm601tnxzZVmi2LSYNhezorJ5D7VVtAatCGnO+dqgK7RizggtAhxqxxU+K8XvjVwKkzrTAjpb8nrAEf4keDItxX64LCX/c8PKqJnLeC9JvREiAcyH+EDHt/+z5R+Vg9dtybXCXLt8ZED7e6dfaZlo41eMkZJ9gnXSHCGkvuMX0XgjByGpe0v/u6JYIcRzS9xMUw1jN5/EOAroF7CcMFXnrDsjIJOFFoJHI71j8usm1x34ilth8gB6XoBB93aP61EYBXzw8RZ261KgPDqpAiiUnJGIyvmNEfWeGs0BGQ75eea4HLFKlHf2DgWrYaXgChkdrgznVjlAkCJZQ9SjUJQi2Zh2DBqwb7P9wY2c6Z3jhrqgRSUZyYxrFl7CUdPfJiZCaHckDzTS1epwpOUvFSV8y7K9cETv6kZy7r/fOkyPXPsfpmbeSyRqB6b15nKx9mueqEChGzebk5yjG2WBx05iiXfq52uHIFz7TIbImWhiMf0pmA4j1HH7RzZU+la4kKYYrxGLLDYO0IV1Lp61Gu5xXrCLLvFSpR2dfXYmPk
 FtTwvb+q
 vG5ZtAoQDCwSOpEwz5NWLcdXrVs8v+Qlzm43jm6gjmCQFsSkZ57OEmZf2f3qhONMH869EPHo0ANSA7qDW7J2WtUIQkgSzswfKRhnN7+OBtYur7TcGdeTF3FQ2XmOb21yehqkEGYfGhgeQmbIMeLumicxIWuiJQ6xZG9qs9mPONoEfvA1ZTYXabE6HE0AUdwvJj35QE8nPfmixyZZSk6/mflTQLRefmI+9syRDxnD2mHwL9ZPsFDOrlkfe4yTiOlsWauwYTUIVX5eNjF+GoI7Wq+xPFfzL02wJBkRhJv84AfOOdo1om/IMJXKt4H0t+mhQyY5JgcgETxB8ontZowT7o5D/wPcFPkAxcswgPOUVbBDWjTbhDG0DVAkdgKc/ryXfa5B7osnbMtocMTRFqRSKM0M/mPvPe/WrLgIqMnaxEV516i5aAB7pW9zL52du2btICawlnhTYGsl9VgBBGJkXjzuqnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:38:12PM +0530, Kundan Kumar wrote:
> This series explores AG aware parallel writeback for XFS. The goal is
> to reduce writeback contention and improve scalability by allowing
> writeback to be distributed across allocation groups (AGs).
> 
> Problem statement
> =================
> Today, XFS writeback walks the page cache serially per inode and funnels
> all writeback through a single writeback context. For aging filesystems,
> especially with high parallel buffered IO this leads to limited
> concurrency across independent AGs.
> 
> The filesystem already has strong AG level parallelism for allocation and
> metadata operations, but writeback remains largely AG agnostic.
> 
> High-level approach
> ===================
> This series introduces an AG aware writeback with following model:
> 1) Predict the target AG for buffered writes (mapped or delalloc) at write
>    time.
> 2) Tag AG hints per folio (via lightweight metadata / xarray).
> 3) Track dirty AGs per inode using bitmap.
> 4) Offload writeback to per AG worker threads, each performing a onepass
>    scan.
> 5) Workers filter folios and submit folios which are tagged for its AG.
> 
> Unlike our earlier approach that parallelized writeback by introducing
> multiple writeback contexts per BDI, this series keeps all changes within
> XFS and is orthogonal to that work. The AG aware mechanism uses per folio
> AG hints to route writeback to AG specific workers, and therefore applies
> even when a single inode’s data spans multiple AGs. This avoids the
> earlier limitation of relying on inode-based AG locality, which can break
> down on aged/fragmented filesystems.
> 
> IOPS and throughput
> ===================
> We see significant improvemnt in IOPS if files span across multiple AG
> 
> Workload 12 files each of 500M in 12 directories(AGs) - numjobs = 12
>     - NVMe device Intel Optane
>         Base XFS                : 308 MiB/s
>         Parallel Writeback XFS  : 1534 MiB/s  (+398%)
> 
> Workload 6 files each of 6G in 6 directories(AGs) - numjobs = 12
>     - NVMe device Intel Optane
>         Base XFS                : 409 MiB/s
>         Parallel Writeback XFS  : 1245 MiB/s  (+204%)
> 

Hi Kundan,

Could you provide more detail on how you're testing here? I threw this
at some beefier storage I have around out of curiosity and I'm not
seeing much of a difference. It could be I'm missing some details or
maybe the storage outweighs the processing benefit. But for example, is
this a fio test command being used? Is there preallocation? What type of
storage? Is a particular fs geometry being targeted for this
optimization (i.e. smaller AGs), etc.?

FWIW, I skimmed through the code a bit and the main thing that kind of
stands out to me is the write time per-folio hinting. Writeback handling
for the overwrite (i.e. non-delalloc) case is basically a single lookup
per mapping under shared inode lock. The question that comes to mind
there is what is the value of per-ag batching as opposed to just adding
generic concurrency? It seems unnecessary to me to take care to shuffle
overwrites into per-ag based workers when the underlying locking is
already shared.

WRT delalloc, it looks like we're basically taking the inode AG as the
starting point and guessing based on the on-disk AGF free blocks counter
at the time of the write. The delalloc accounting doesn't count against
the AGF, however, so ISTM that in many cases this would just effectively
land on the inode AG for larger delalloc writes. Is that not the case?

Once we get to delalloc writeback, we're under exclusive inode lock and
fall into the block allocator. The latter trylock iterates the AGs
looking for a good candidate. So what's the advantage of per-ag
splitting delalloc at writeback time if we're sending the same inode to
per-ag workers that all 1. require exclusive inode lock and 2. call into
an allocator that is designed to be scalable (i.e. if one AG is locked
it will just move to the next)?

Yet another consideration is how delalloc conversion works at the
xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
If you take a look at the latter, we look up the entire delalloc extent
backing the folio under writeback and attempt to allocate it all at once
(not just the blocks backing the folio). So in theory if we were to end
up tagging a sequence of contiguous delalloc backed folios at buffered
write time with different AGs, we're still going to try to allocate all
of that in one AG at writeback time. So the per-ag hinting also sort of
competes with this by shuffling writeback of the same potential extent
into different workers, making it a little hard to try and reason about.

So stepping back it kind of feels to me like the write time hinting has
so much potential for inaccuracy and unpredictability of writeback time
behavior (for the delalloc case), that it makes me wonder if we're
effectively just enabling arbitrary concurrency at writeback time and
perhaps seeing benefit from that. If so, that makes me wonder if the
associated value can be gained by somehow simplifying this to not
require write time hinting at all.

Have you run any experiments that perhaps rotors inodes to the
individual wb workers based on the inode AG (i.e. basically ignoring all
the write time stuff) by chance? Or anything that otherwise helps
quantify the value of per-ag batching over just basic concurrency? I'd
be interested to see if/how behavior changes with something like that.

Brian

> These changes are on top of the v6.18 kernel release.
> 
> Future work involves tighten writeback control (wbc) handling to integrate
> with global writeback accounting and range semantics, also evaluate
> interaction with higher level writeback parallelism.
> 
> Kundan Kumar (6):
>   iomap: add write ops hook to attach metadata to folios
>   xfs: add helpers to pack AG prediction info for per-folio tracking
>   xfs: add per-inode AG prediction map and dirty-AG bitmap
>   xfs: tag folios with AG number during buffered write via iomap attach
>     hook
>   xfs: add per-AG writeback workqueue infrastructure
>   xfs: offload writeback by AG using per-inode dirty bitmap and per-AG
>     workers
> 
>  fs/iomap/buffered-io.c |   3 +
>  fs/xfs/xfs_aops.c      | 257 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_aops.h      |   3 +
>  fs/xfs/xfs_icache.c    |  27 +++++
>  fs/xfs/xfs_inode.h     |   5 +
>  fs/xfs/xfs_iomap.c     | 114 ++++++++++++++++++
>  fs/xfs/xfs_iomap.h     |  31 +++++
>  fs/xfs/xfs_mount.c     |   2 +
>  fs/xfs/xfs_mount.h     |  10 ++
>  fs/xfs/xfs_super.c     |   2 +
>  include/linux/iomap.h  |   3 +
>  11 files changed, 457 insertions(+)
> 
> -- 
> 2.25.1
> 
> 


