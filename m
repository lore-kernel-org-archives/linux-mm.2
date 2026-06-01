Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3225BCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFD16B031F; Mon,  1 Jun 2026 07:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B13B6B0321; Mon,  1 Jun 2026 07:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F396B0322; Mon,  1 Jun 2026 07:04:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE076B031F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:04:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCCF3C231D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:04:45 +0000 (UTC)
X-FDA: 84831060930.05.3B348F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 91597140002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:04:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LXEOxaSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KRYnmXEa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LXEOxaSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KRYnmXEa;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780311883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n4fpvnBSWWnsnWWCDEjQv7Yr/I/XwUqGPjAJT9jyMo=;
	b=53qPzPRi9Q3zWhStcQDOr5711Ck0FEdQjdII+hZVNUXllCCA0rbZqlJs9Tn2JSbElyJDQh
	K4qqutW4HqZqFgo2JwbmNZW0TqmXwCyW+5Jco10apQiAydbBW4vcHIKgpQiHaDZt12OigS
	gWpKEmbGJtyleCp7J41RZNp0BwaKggs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LXEOxaSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KRYnmXEa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LXEOxaSb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KRYnmXEa;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780311883; a=rsa-sha256;
	cv=none;
	b=SVV17cB0QAzzG+kY4LTcsniU0/w6daRyi/+RCyq90cdTLfzYca94Z090/uiryeh2Aitb9T
	UaN1/gK/16jXfTbpl+O40utl7jl/cyCffHiK9SP+qQc5Cz5b3tFYCKKvFHdvasLPs8i2YA
	Ii0Nfiit9itPG0v5OchLURac3TuYZp0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1FB1681A6;
	Mon,  1 Jun 2026 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780311882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/n4fpvnBSWWnsnWWCDEjQv7Yr/I/XwUqGPjAJT9jyMo=;
	b=LXEOxaSbI+NBmFKfZguWmTxXfz5E7pjVwYiI+nHBrJuNPFrbh/gZhTOFHgErALoTsbxfan
	/JtKhJo3EkisnubQL2wEqKva41gkDMNZecSMWetU//grgSTtrfG67NhAz1giOhYMD8Ty0x
	nadhjNnu/U7ZynUFxmHtIphmjZ6WClA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780311882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/n4fpvnBSWWnsnWWCDEjQv7Yr/I/XwUqGPjAJT9jyMo=;
	b=KRYnmXEaOwqCV9fB4sAMZPqyevBEhi4n6AXZ2Evc70QirbXEh4gMiJdHdu4HBJedov/uyT
	jKNXT6uKjSONM7AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780311882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/n4fpvnBSWWnsnWWCDEjQv7Yr/I/XwUqGPjAJT9jyMo=;
	b=LXEOxaSbI+NBmFKfZguWmTxXfz5E7pjVwYiI+nHBrJuNPFrbh/gZhTOFHgErALoTsbxfan
	/JtKhJo3EkisnubQL2wEqKva41gkDMNZecSMWetU//grgSTtrfG67NhAz1giOhYMD8Ty0x
	nadhjNnu/U7ZynUFxmHtIphmjZ6WClA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780311882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/n4fpvnBSWWnsnWWCDEjQv7Yr/I/XwUqGPjAJT9jyMo=;
	b=KRYnmXEaOwqCV9fB4sAMZPqyevBEhi4n6AXZ2Evc70QirbXEh4gMiJdHdu4HBJedov/uyT
	jKNXT6uKjSONM7AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E42E6779A7;
	Mon,  1 Jun 2026 11:04:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7L+zN0lnHWojMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 11:04:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8C7ACA0EBE; Mon, 01 Jun 2026 13:04:41 +0200 (CEST)
Date: Mon, 1 Jun 2026 13:04:41 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <cuyklvhnt37xwk3jlr2iyyxxkzvt4bsf5iqv2gag4ixdicnbk2@rfqgjlclwesz>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
 <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
 <ahbq0RdUyLIPiItB@infradead.org>
 <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80cb53f3-e7e5-4f96-bacc-f9fb7661d976@columbia.edu>
X-Stat-Signature: o1eiqi4oww91zkc9w636ijug47c35u8y
X-Rspamd-Queue-Id: 91597140002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780311883-658568
X-HE-Meta: U2FsdGVkX1+50sXbbvfI/6lIBqmHjMhvp9AwjFzdI8yXY8KcSfA3X0uQxNrE1l3ax0sZzrZGYWSVG5esdb2mPgIH4CLf8mHvc9F/UtRpVFBWebXD1BBlsXErBcEJF81fMcQaio7LhdwEDzEJtmP7odyt2o3psRnM3RMyRX6JlnFlpRDpp6AGsQlDyoEsUyXXKe1FyZH4RPr5luCurMsyjLnhiiqjH3NTW5oN2K2ZnjdfkS9qDkcs6FL7zUqRnhGaEHJSMW71hJt7ERP9vKWJ5Wjz7AemLZMHLU/wAOe8G8H+LTj5Sc2lA/EfWAEzno83/rFso05vBAhog032OKqNuAzAGK0a+wDSY9IYezRTdXzNQpNFdeneiWEDeCaw+BfLQ9WExwRMFnvDHfG62PkKIcUHoeEeV+6K5j/iATBCWe1FckaNKvEBDiprly7OWiQGFHM8TE+wSJ0tsLgs68/J1rxB7OKLF+JZxaG4FeYaC5ZmPbbtk+qFRdNG8SWfrSBbVftLpqT//uniYxrmO9NPCPQ2fWAnnbs0sEtpOD76Cm5hkIURAw01WIz374l99XKbUYA7whfCgzejORgAxQQlo1Mc99DyYRcCjDb57jJOzaRmEB7XCvWtuuQU5o1kMH3cmkAacaYHZnpMXwKMFuKCMF6O3thuzgQP4G7xKp8hK5pj2Xm56JYEFexG5qrORIgWwq7uxq8U/B7SRwNdx6bBf11WBc+rohI9IQuxA/72ZWf6bf5t8DCdlorFVaFhtz90EgDnbtqFx7M3KPI5a+TsJ6YfuU4ZIOkXGrLqFU2Rtu6775jrj6h9WNRVgFQqZ9Q3kO0Yo71rp495nDqmReowLeEUQAXozfbcKVtWRJt8+WB4pf0dY2uHuBaKVRzGMZ2yGMh2VXCs4VOE9MlfSu3+uzLtdoLwML7K6zED1GrRdTjQ01ZzcI6dAEMzcSFKM3K/z1rnqjoMMMbJ87lDLyD
 9/bB/+Qh
 aOVyc6xrg52I1+ZLZd99WAd+hKnM71jawLFaUPvWOEHBQOQo9D3lE7F2/4RuFTurbgBBi2HF22mnygT7L9iWZVVUcgx++HDBXwIYQEu9rh3ediIfhhqnxcotCQXDGaAWb/3uuquev/Maqck1KpBpAQ3m3u8G44qFxSfO7IhtSUnYRLoIr18VVZoTqFATI2TsMjnCuTJnKf9oIxqr2j2sa32gku2Np2AQi9qAMYMN+ersUNE1+iWaAk3YSSJ34AwJ3InUDyyEZUXhLRwG/aAFaazpoMNKYHshjdLFx3SblCd4wVkJnuelmv26i8GBwcHkbKikdszbzs9OHl6L8JLi1xqiLYQHIfXiBBe3lCBS/NoAJkgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 29-05-26 16:46:15, Tal Zussman wrote:
> On 5/27/26 9:00 AM, Christoph Hellwig wrote:
> > On Wed, May 27, 2026 at 11:42:28AM +0200, Jan Kara wrote:
> >> > I ran some experiments with fio on both XFS and a raw block device. Five
> >> > iterations each for 60s. Results below.
> >> > 
> >> > TLDR: Removing the delay doesn't significantly decrease user-visible
> >> > latency or otherwise improve performance, but does significantly reduce
> >> > throughput and increase context switches in some workloads (e.g. C).
> >> > I think it makes sense to leave the delay as-is. Thoughts?
> >> 
> >> Thanks for the test! One question below:
> > 
> > Thanks from me as well!
> > 
> >> 
> >> > Results:
> >> > 
> >> > Workloads (all `uncached=1`):
> >> >   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
> >> >   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
> >> >   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
> >> >   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
> >> >   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
> >> >   F: rw=write     bs=128k iodepth=128 numjobs=4
> >> >      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
> >> > 
> >> > Mean ± stddev across 5 iterations:
> >> > 
> >> >     metric                     delay=1           delay=0     delta
> >> >     --------------------------------------------------------------
> >> > 
> >> >   A seq 128k qd1
> >> >     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
> >> >     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
> >> >     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
> >> >     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
> >> >     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
> >> >     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%
> >> 
> >> So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
> >> the completion latency should be at least 1000us but your results show p99
> >> latency of 36. What am I missing?
> > 
> > Yes, this looks a bit odd.  Unless there's multiple threads submitting
> > and somehow the completions get batched this should complete one
> > bio at a time and be the worst case for the delay scheme.
> 
> Sorry, I should've clarified - the latency here is the userspace-visible
> I/O completion latency (i.e. fio's clat value).
> 
> I ran again and traced to get the actual time from __bio_complete_in_task()
> to calling ->bi_end_io(). The results match the 1 jiffie delay now:
> 
>   metric                  delay=1  delay=0
> 
>   A seq 128k qd1
>     fio clat p99             38us     36us
>     bio cb p50             1.23ms    2.5us
>     bio cb p99             4.13ms   1.44ms
>     bio cb p999            5.01ms   2.63ms

So I'm clearly missing something fundamental as I don't see how can fio
reported IO completion time be lower than the end_io callback latency...
Ahh, it is the strange meaning of clat in fio in combination with sync
engine where clat means: "how long after the syscall has returned the data
is ready". Which for sync engine is immediately so the clat number is
meaningless. I think reporting 'lat' numbers from fio would make more
sense but whatever.

The bio cb latency indeed looks like what I'd roughly expect now. And
notice how the median latency of IO completion is 1.23ms in delay=1 case
and your throughput isn't abbysmal only because writes end up accumulating
in the page cache and writeback infrastructure ends up submitting a lot of
writeback IOs in parallel (you have ~80 bios to complete per run which
amortizes the latency to decent level).

However if you'd have IO that were to use BIO_COMPLETE_IN_TASK
infrastructure which doesn't have so many IOs in flight (like direct IO
with lower queue depth which has to do extent conversion on completion),
you would very much see the latency hit on your throughput as well. In the
extreme case of qd=1 direct IO you'd reduce the throughput to ~4MB/s.

Now I'm not saying the delay is bad - it is a tradeoff with clear wins in
CPU overhead your benchmarks are showing. I just wanted to point out
there's also the cost side which your benchmarks don't show very clearly.
So we might need to keep some stats showing how many IO completions we are
offloading per second on each CPU and switch to delaying the work only once
it crosses a threshold like 1000000/HZ per second or so (so we at most
double the IO latency by delaying the end_io callback).

								Honza

>   B seq 128k qd128
>     fio clat p99           8.74ms   8.85ms
>     bio cb p50             1.27ms    3.1us
>     bio cb p99             4.05ms   2.27ms
>     bio cb p999            4.91ms   2.77ms
> 
>   C rand 4k qd32
>     fio clat p99           8.16ms   8.11ms
>     bio cb p50             1.09ms   97.7us
>     bio cb p99             3.73ms   2.06ms
>     bio cb p999           11.87ms   3.79ms
> 
>   D mixed 64k qd32
>     fio clat p99            981us   1.03ms
>     bio cb p50             1.14ms   39.5us
>     bio cb p99             2.83ms    275us
>     bio cb p999            3.06ms    595us
> 
>   E raw 128k qd128
>     fio clat p99          26.97ms  27.34ms
>     bio cb p50             1.58ms   41.5us
>     bio cb p99             2.98ms    325us
>     bio cb p999            3.02ms    575us
> 
>   F mem-pressure
>     fio clat p99          29.75ms  30.43ms
>     bio cb p50             1.32ms    2.5us
>     bio cb p99             3.73ms   2.48ms
>     bio cb p999            4.62ms   2.83ms
> 
> Note that in the above, the C degradation didn't reproduce as much. The
> bandwidth does go down from 64.5 MB/s with delay=1 to 54.9 MB/s with delay=0,
> but it's a much smaller drop. I ran it several more times and ran into the
> degradation ~20% of the time. The lack of batching means the completion
> kworker fires for nearly every bio, leading to heavier preemption when a
> writer is placed on a CPU that receives many completion IRQs. The degradation
> seems to occur when the writers are migrated less often, leading to more
> preemption. But I haven't dug into why the scheduler chooses to migrate more
> in some runs vs. others. However, when pinning to 16 cores, the difference
> between delay=0 and delay=1 goes away.
> 
> C specifically also seems to get worse because we're doing random writes to a
> sparse file, so each bio goes through the IOMAP_IOEND_UNWRITTEN path and the
> completion path is heavier, leading to more CPU stealing from the writing
> threads compared to the other workloads.
> 
> >> >   C rand 4k qd32
> >> >     BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
> >> >     p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
> >> >     p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
> >> >     ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
> >> >     cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
> >> >     avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%
> >> 
> >> I'm somewhat surprised how larger is the completion latency is here without
> >> the delay. Is that due to a contention on local lock between the IO completion
> >> interrupt and the worker? Or why is the completion latency so big here when
> >> the case B with more IOs in flight, less bios per run, still had significantly
> >> lower latency in the delay=0 case?
> > 
> > Note that in the past we had major problems with workqueue scheduling
> > latency.  At some point these got mitigated a lot, but if they are back
> > for this workload that might be one reason.
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

