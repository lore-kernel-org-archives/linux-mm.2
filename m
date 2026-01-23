Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB35BD74EC9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048846B04C8; Fri, 23 Jan 2026 08:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0160B6B04CA; Fri, 23 Jan 2026 08:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B356B04CB; Fri, 23 Jan 2026 08:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D189A6B04C8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:26:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9119589086
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:26:58 +0000 (UTC)
X-FDA: 84363304116.18.6CF864D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C297A0003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:26:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z1layvxp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769174816; a=rsa-sha256;
	cv=none;
	b=XtEuQiiBw9vhFCwm3NRacFbyuPN9OW4CCoqN1fbpFH/aGQD07Eijfeq8cJIYqKjthI4bKQ
	jD30XM1QypoPsLB8/e3OXw5W1gG8GTsJFtvMYBlxQG888ljCb4o2Bn+pxKTJB7TxQXlGNN
	wvmZ1m9BbC03BUxGsTfB8lgHdxtXCTs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z1layvxp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769174816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoRBTfV4VyA/DV78xxIgYB6gXw6o5kSGqGJb4RS28XE=;
	b=vdDv0pHS0IjXnZsk4DFDYpFmW9B6xeDG4fj/fWQeh+JU7Zd8CSn03lEGPndOdxnZoZkP2h
	AmlHiqSpjZgeY+dFmkZdttcwyIh2IN5ZO+gr8xUjC4EKROQUq0aecd9ZRw2d5CTsicKEyD
	07/ujLMT5RWvdXWqBQm6TiPZrJmSXJE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769174815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoRBTfV4VyA/DV78xxIgYB6gXw6o5kSGqGJb4RS28XE=;
	b=Z1layvxpEHAkoet6afO9axO3oiB4Kc1Mr8PmO1EhijDfWeew80GQNT6Ixm1W/qN0J1RB0a
	S8n979GyyorZK47V1Td+A43OiYj0hbwJtx2l2y0m8XfZg4cN7vy0CyyCBq1TeViVX222jP
	RJGIKnQitkHGrzYXCVtdGPjF6voCFGE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-36-IhTs_L3LP-aqA_2xWCvr_w-1; Fri,
 23 Jan 2026 08:26:52 -0500
X-MC-Unique: IhTs_L3LP-aqA_2xWCvr_w-1
X-Mimecast-MFC-AGG-ID: IhTs_L3LP-aqA_2xWCvr_w_1769174809
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94C2F1955D80;
	Fri, 23 Jan 2026 13:26:48 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.128])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59D1F1958DC1;
	Fri, 23 Jan 2026 13:26:44 +0000 (UTC)
Date: Fri, 23 Jan 2026 08:26:42 -0500
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
Message-ID: <aXN3EtxKFXX8DEbl@bfoster>
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
 <20260116100818.7576-1-kundan.kumar@samsung.com>
 <aXEvAD5Rf5QLp4Ma@bfoster>
 <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca048ecf-5aec-4a0d-8faf-ad9fcd310e21@samsung.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C297A0003
X-Stat-Signature: yh9nimdbagojz6hc8poim8m6rshgwk63
X-HE-Tag: 1769174816-544028
X-HE-Meta: U2FsdGVkX19gILZH8D9gJ6oUrmU7Wb4wRQOEjmjr1XcjzSNwGClY29q5zXJE12tkgwBPNYWdkB14bvsYOqGJ2glJMFfFz0YP8TWcrcuxT1+FstlpQN2cVfz0Y9ryrujQPlpMT8oiYvcxxRdb8oR3omFowlp/pZI47kIx2hTFGk/NI9M7453oTvbUGThrGtrGY7ucbRQnpzImiKBPmkdH9kmaAnNMdAMDZhYXcw5GJ0ZV2PfTwRmxHBdalyP7zuhm4XtN3LOq5Ch+cFolDv21xHZRe+Zpw5WcVKA8hAEiVy5lwukwron+MnIx36I36fMWLotOZa+w9FhbsfRlZwPEZ/yUM6dSvRv0o7MKsY/OLEMtz+ytK1ETgVeewdPLS7a1XfSM52RDC2ChmrCCOF6b3dTrLhbzVTjwfhueeLBvorSgf/Hx3n/ozNxmdAiJtIF7BG2de03d/BcFbbGCHME3Vm/1rAAn4TDDBF9tlh0xjrrjjNA/m+xRfnboUasS26BYE9uD9VLF5S4kr/2YRf+Y1D6P6lx89nkj0rZ3vx6IvMZIHu0imGUiM6pKyAiVtvYp8iNzPeYe5CqdO/eJktv2y4wFfUOLMT4/rwmH5tWKDIFZDj3hjCdXI1aEPZyUrLcog0G8LvBQ1QToh/2AdMBF6zUzufM8kMvhPzRijEso209ldZHkocIGqjB1wwDXnJMYG6nWz7CMJ6wMuO2NU4ghTwYWtPsBk3WX0/QpFvtlkVpseYMOdbtmOStGfIIKZAip4oHc7hLQki6VUKcCtg0HHWR6oPXpM68mQD910fuipMHisPQmQmwj4Dclv42eSvDsNWE6a+1o5d9BKXlJ0BQYL+AH9L8gTarlPabJUZZdDsBiy0gXxqJ+cK9xXpO6FQcXDKtoKiOb2o2mHXH9IW7Zgbl1jaRFLtx6fZRrg5ThQoHFbrPUAvbcgN7vfRcojia5Qo+WktfBq7l6wnLXaSV
 r1adp2Ui
 9lW+bjveK+nHWFwyXTfYqyzX+B5oMdWmuqKPH8UzD44DIMwo/qUxsAoQ10yf0gg3LlnNnJt8+Xx51kl395ZCS36ioBh8UFXY13SD0vVn0NVbeUpuQCfwTKkx4hYFDLxRr4jH7xs6Xjaf9bcyAjLH2QnU8VcnSNST2HY+1T2gfFPixpToeDHu0uaS/KuZBcWSRIej4lmb7vofNPW2hE3Ullk6dvVEMbvG2l/z2/b9e7dAkK0pHTA/ZdeOpH91MQrXvsOh6xLNm388Qed+XeumlIgBAEHJ0nKnpcREX3DyNudcnOxXdbeVn8jk1+RruwQIeaCnxvSVGyFFMl80QwPQZI1QSzvUFzLqyl0P0tq0ghLrdmVUPcYrKTrwKmoIAbkCgfY4aTvM4SST4sx2R7fjh7OrIV0vPmOhg1JPwox4rLOB7qtyt152EpD1VrKhOnC42cAdIf6yEeOP2B8zcIRQ4GOfObmXld7gSWGqSSCCBGsoMED1nfyOkN+dWeje0EKXAkmsr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 09:45:05PM +0530, Kundan Kumar wrote:
> > 
> > Could you provide more detail on how you're testing here? I threw this
> > at some beefier storage I have around out of curiosity and I'm not
> > seeing much of a difference. It could be I'm missing some details or
> > maybe the storage outweighs the processing benefit. But for example, is
> > this a fio test command being used? Is there preallocation? What type of
> > storage? Is a particular fs geometry being targeted for this
> > optimization (i.e. smaller AGs), etc.?
> 
> Thanks Brian for the detailed review and for taking the time to
> look through the code.
> 
> The numbers quoted were from fio buffered write workloads on NVMe
> (Optane devices), using multiple files placed in different
> directories mapping to different AGs. Jobs were buffered
> randwrite with multiple jobs. This can be tested with both
> fallocate=none or otherwise.
> 
> Sample script for 12 jobs to 12 directories(AGs) :
> 
> mkfs.xfs -f -d agcount=12 /dev/nvme0n1
> mount /dev/nvme0n1 /mnt
> sync
> echo 3 > /proc/sys/vm/drop_caches
> 
> for i in {1..12}; do
>    mkdir -p /mnt/dir$i
> done
> 
> fio job.fio
> 
> umount /mnt
> echo 3 > /proc/sys/vm/drop_caches
> 
> The job file :
> 
> [global]
> bs=4k
> iodepth=32
> rw=randwrite
> ioengine=io_uring
> fallocate=none
> nrfiles=12
> numjobs=1
> size=6G
> direct=0
> group_reporting=1
> create_on_open=1
> name=test
> 
> [job1]
> directory=/mnt/dir1
> 
> [job2]
> directory=/mnt/dir2
> ...
> ...
> [job12]
> directory=/mnt/dir12
> 

Thanks..

> > 
> > FWIW, I skimmed through the code a bit and the main thing that kind of
> > stands out to me is the write time per-folio hinting. Writeback handling
> > for the overwrite (i.e. non-delalloc) case is basically a single lookup
> > per mapping under shared inode lock. The question that comes to mind
> > there is what is the value of per-ag batching as opposed to just adding
> > generic concurrency? It seems unnecessary to me to take care to shuffle
> > overwrites into per-ag based workers when the underlying locking is
> > already shared.
> > 
> 
> That’s a fair point. For the overwrite (non-delalloc) case, the
> per-folio AG hinting is not meant to change allocation behavior, and
> I agree the underlying inode locking remains shared. The primary value
> I’m seeing there is the ability to partition writeback iteration and
> submission when dirty data spans multiple AGs.
> I will try routing overwrite writeback to workers irrespective of AG
> (e.g. hash/inode based), to compare between generic concurrency vs AG
> batching.
> 
> > WRT delalloc, it looks like we're basically taking the inode AG as the
> > starting point and guessing based on the on-disk AGF free blocks counter
> > at the time of the write. The delalloc accounting doesn't count against
> > the AGF, however, so ISTM that in many cases this would just effectively
> > land on the inode AG for larger delalloc writes. Is that not the case?
> > 
> > Once we get to delalloc writeback, we're under exclusive inode lock and
> > fall into the block allocator. The latter trylock iterates the AGs
> > looking for a good candidate. So what's the advantage of per-ag
> > splitting delalloc at writeback time if we're sending the same inode to
> > per-ag workers that all 1. require exclusive inode lock and 2. call into
> > an allocator that is designed to be scalable (i.e. if one AG is locked
> > it will just move to the next)?
> > 
> 
> The intent of per-AG splitting is not to parallelize allocation
> within a single inode or override allocator behavior, but to
> partition writeback scheduling so that inodes associated with
> different AGs are routed to different workers. This implicitly
> distributes inodes across AG workers, even though each inode’s
> delalloc conversion remains serialized.
> 
> > Yet another consideration is how delalloc conversion works at the
> > xfs_bmapi_convert_delalloc() -> xfs_bmapi_convert_one_delalloc() level.
> > If you take a look at the latter, we look up the entire delalloc extent
> > backing the folio under writeback and attempt to allocate it all at once
> > (not just the blocks backing the folio). So in theory if we were to end
> > up tagging a sequence of contiguous delalloc backed folios at buffered
> > write time with different AGs, we're still going to try to allocate all
> > of that in one AG at writeback time. So the per-ag hinting also sort of
> > competes with this by shuffling writeback of the same potential extent
> > into different workers, making it a little hard to try and reason about.
> > 
> 
> Agreed — delalloc conversion happens at extent granularity, so
> per-folio AG hints are not meant to steer final allocation. In this
> series the hints are used purely as writeback scheduling tokens;
> allocation still occurs once per extent under XFS_ILOCK_EXCL using
> existing allocator logic. The goal is to partition writeback work and
> avoid funneling multiple inodes through a single writeback path, not
> to influence extent placement.
> 

Yeah.. I realize none of this is really intended to drive allocation
behavior. The observation that all this per-folio tracking ultimately
boils down to either sharding based on information we have at writeback
time (i.e. overwrites) or effectively batching based on on-disk AG state
at the time of the write is kind of what suggests that the folio
granular hinting is potentially overkill.

> > So stepping back it kind of feels to me like the write time hinting has
> > so much potential for inaccuracy and unpredictability of writeback time
> > behavior (for the delalloc case), that it makes me wonder if we're
> > effectively just enabling arbitrary concurrency at writeback time and
> > perhaps seeing benefit from that. If so, that makes me wonder if the
> > associated value can be gained by somehow simplifying this to not
> > require write time hinting at all.
> > 
> > Have you run any experiments that perhaps rotors inodes to the
> > individual wb workers based on the inode AG (i.e. basically ignoring all
> > the write time stuff) by chance? Or anything that otherwise helps
> > quantify the value of per-ag batching over just basic concurrency? I'd
> > be interested to see if/how behavior changes with something like that.
> 
> Yes, inode-AG based routing has been explored as part of earlier
> higher-level writeback work (link below), where inodes are affined to
> writeback contexts based on inode AG. That effectively provides
> generic concurrency and serves as a useful baseline.
> https://lore.kernel.org/all/20251014120845.2361-1-kundan.kumar@samsung.com/
> 

Ah, I recall seeing that. A couple questions..

That link states the following:

"For XFS, affining inodes to writeback threads resulted in a decline
in IOPS for certain devices. The issue was caused by AG lock contention
in xfs_end_io, where multiple writeback threads competed for the same
AG lock."

Can you quantify that? It seems like xfs_end_io() mostly cares about
things like unwritten conversion, COW remapping, etc., so block
allocation shouldn't be prominent. Is this producing something where
frequent unwritten conversion results in a lot of bmapbt splits or
something?

Also, how safe is it is to break off writeback tasks at the XFS layer
like this? For example, is it safe to spread around the wbc to a bunch
of tasks like this? What about serialization for things like bandwidth
accounting and whatnot in the core/calling code?  Should the code that
splits off wq tasks in XFS be responsible to wait for parallel
submission completion before returning (I didn't see anything doing that
on a scan, but could have missed it)..?

> The motivation for this series is the complementary case where a
> single inode’s dirty data spans multiple AGs on aged/fragmented
> filesystems, where inode-AG affinity breaks down. The folio-level AG
> hinting here is intended to explore whether finer-grained partitioning
> provides additional benefit beyond inode-based routing.
> 

But also I'm not sure I follow the high level goal here. I have the same
question as Pankaj in that regard.. is this series intended to replace
the previous bdi level approach, or go along with it somehow? Doing
something at the bdi level seems like a more natural approach in
general, so I'm curious why the change in direction.

Brian


