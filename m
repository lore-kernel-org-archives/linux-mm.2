Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7919CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258FA6B0005; Wed, 27 May 2026 05:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2307E6B008A; Wed, 27 May 2026 05:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1466D6B0092; Wed, 27 May 2026 05:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060A56B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:42:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EE5E8DC51
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:42:32 +0000 (UTC)
X-FDA: 84812709744.29.009B10D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 795F110000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:42:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QuOM12sE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PloHyGwy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QuOM12sE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PloHyGwy;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txQW/NutESarVL2WCPWrxQmoc9DCV4mIFABmq/5UFX4=;
	b=vIZVZ1ABgCfUOw1T5neNDFJr7ZCKWtoUzeVZ3FCIqo6xse0+kYJq+WEHpG1w9M9/Sh8xhG
	krCSKK5qqOmVTjU+X7rsB4iXJSW03G0SnUBUh7CglYJqwBxs+ZMFo1mxL8vk+4a3/OuwjB
	Oz7vh1fXzYrzXowkOuwVXuXWYXYcjxI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QuOM12sE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PloHyGwy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QuOM12sE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PloHyGwy;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874950; a=rsa-sha256;
	cv=none;
	b=8R3oh8whYYyzfcqLMimiTX8FZmqcOs0a7EJohZ/Yj0rpKkbzVNmtDDZrKI+Qxn5yvPB03o
	HAE2zmnwq8Om3JpU4mjz8va2MlsXcVCARwChsBjiLM59PDYI6uMaosbrMIkUeYU/j355J5
	cjJUZKkSWHbfzexJT5LV2j6lox0mKvg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B13EB66E60;
	Wed, 27 May 2026 09:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779874948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txQW/NutESarVL2WCPWrxQmoc9DCV4mIFABmq/5UFX4=;
	b=QuOM12sE4wJS3LYUZHx2eWGaKa87TTl/jUawVLsmsUSXlvC/wyrKArexyno7LZ4iuYy8T5
	4TwAzXD9cDImq+TwoO8KCDvAH4/NXMXB4qEET/gRxsyagsgXS8x2t+5/5KYFOou4gVTU6E
	wQmQJvhNC0p4VWjcSe8Bj32qV60w9nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779874948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txQW/NutESarVL2WCPWrxQmoc9DCV4mIFABmq/5UFX4=;
	b=PloHyGwy7bm90Y12jURU00qxDfQs0HlwMT/y8L8A+UKZakw4ndJKJSQNd9o8cFDFaJoRol
	ZF97yZK/ebR9r1DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779874948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txQW/NutESarVL2WCPWrxQmoc9DCV4mIFABmq/5UFX4=;
	b=QuOM12sE4wJS3LYUZHx2eWGaKa87TTl/jUawVLsmsUSXlvC/wyrKArexyno7LZ4iuYy8T5
	4TwAzXD9cDImq+TwoO8KCDvAH4/NXMXB4qEET/gRxsyagsgXS8x2t+5/5KYFOou4gVTU6E
	wQmQJvhNC0p4VWjcSe8Bj32qV60w9nM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779874948;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=txQW/NutESarVL2WCPWrxQmoc9DCV4mIFABmq/5UFX4=;
	b=PloHyGwy7bm90Y12jURU00qxDfQs0HlwMT/y8L8A+UKZakw4ndJKJSQNd9o8cFDFaJoRol
	ZF97yZK/ebR9r1DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A44AE5A779;
	Wed, 27 May 2026 09:42:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EpYZKIS8FmpiPQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 27 May 2026 09:42:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 375A7A0EB5; Wed, 27 May 2026 11:42:28 +0200 (CEST)
Date: Wed, 27 May 2026 11:42:28 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 1/4] block: add task-context bio completion
 infrastructure
Message-ID: <rkb5oei6cx2erbyininczz6ukbnquqheexhu7tznn5rslkkdn7@b4kpdyhdwdb6>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-1-782e2fa7477b@columbia.edu>
 <agq2KRd8RkP1TAf5@infradead.org>
 <ea1fa305-3ba2-4cfd-b7cb-86875032a300@columbia.edu>
 <ahPbaSEoNA755Nt3@infradead.org>
 <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1b8eeb6-2397-4f48-a21a-a023eb0c80ab@columbia.edu>
X-Stat-Signature: 5yh8e7i1zh4dk9ea7gbhom74t3wopk7z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 795F110000B
X-HE-Tag: 1779874950-259110
X-HE-Meta: U2FsdGVkX18x86Rg28zyKMxHN6YBfpeOuw+kS/3mOchnZg1/oJ9uuubMYJKoW+HV8hOJGRzuD9LxayFlGUSRQOAf3Zh9gtXolXlr3e3f9X/C5r3e/9+6v7xdzwH0pu0HeA7wSU4lmW+0PiniLIGPJaInApk0g4fhmJVMc5aBeAYcHwXk7l+RbYmnC5NeiDZ5mbJ1Q9cocXNJiG2M1i8XcylD1FDUYOUnKJz2oU0t1Q++cI8+KKDqmgtUHYLDf0ee/a+vnPpzfLyDkgteCG7DB4dZVVh3eZ7B36rYf4Y/m2RmXsA/AUmoFNCm7sM0qu5fdr5aXKshsQ51zssLMysElNxEoxkdemYAWwSodr44TyP0U8vSfe++zr9C5GNIcQEOzfDodiMX6AhrDMJYBDkCAfE0v+YcOqhZBGyuXM0WDJ/hnF1NoeuQ5Jr8RXSyzGttCkQcGCF/9zQ6pCrN5Qw9YLlyHKOoF5+GHEYEGv9HdZrnJABFob37CFv8Lzd+o778VqxhuA16I4CeiqhD0LTLPOVXcKMUKEShydNwXt2ncg/ElQtND+1PMI9Pf/iMvO6Xuff0G6LHTdi4rdCxjE1ix3imWMnWaNXPgyW0G6ArqbJ81PeCFW7K7P9gPWob+iTSkGF+NPC5/sHyNtqzfYAbD3oCrGpDf8uzd12FRLaJMcN+2WauGueNq2mhoBTaepOdgif0Klo7qfec1yvRYiXYpSkiTcG+lswVvmfmO9b3XxuidRaS32YwSOFWz6M5rVK0JqApacxHEA6BLxY8j0G/Q+raU+GKgNSDJXgeVI4EomB/atZDRNpSN8dUfLCf8TxEy1PW1pVKXV/6TUaMfX+s7jJWILb21+LEv+1lrDEO9Z26tAlYlysHLJSpoSBSXT28LnVU0H5hY7+q2kg8vwCOJlfYSek27JNPYL2BoUVdNxYTd5m2Lbq33EGmPTSH0S/uPEwol0f8UvcrLCC8rV4
 OMVCOqZ2
 lY3fJU6oNAA5quoo/KSEzNk9U5cXLZSHg2lGYPdmaXekjzv5HX7ZzfcdjyKQFk9XHGhi5ZpONwnESi2sxs7gggaWO7NKS6BgZUq+g2HwB5JzWvUk9uLOao0vPFMgzNUOPk2WO5XuL40ms4owfHghhXbp1ObGhYztMGkRtiNbhIwwaIigBLyhbZdpKrcfNLGJkrij8Fv7taclIY59dxvHVWTaixI34NFR6I40GRGd/bbporZYL5cf7TvZ8TvtDokQkXgzJFRCzMxrwfVE7S4rpJZi9LnK6MS4dD6xzBnHat4rUBOVU2Rky+YW+RhZ8i9KR1fualQi8SwJsygUkGvCAgs/O2qxMAcGr+8zdRgNSgc/JEuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 26-05-26 15:29:28, Tal Zussman wrote:
> On 5/25/26 1:17 AM, Christoph Hellwig wrote:
> > On Fri, May 22, 2026 at 06:47:43PM -0400, Tal Zussman wrote:
> >> > But this 1-jiffie delay also means we unconditionally increase
> >> > completion latency, which feels like a bad idea.  Do you have any
> >> > measurements that show where it does benefit?  Note that queing work
> >> > already often has very measurable latency on it's own.  This also
> >> > directly contradics the erofs experience that even went to a RT
> >> > thread to reduce the latency.
> >> 
> >> I added this per Dave's feedback on v4, where he noted that XFS inodegc
> >> uses a delayed work item to avoid context switch storms. There's only a
> >> delay for the first bio in a batch to complete, as we only delay when the
> >> list is empty. I'll run some experiments and measure context switches,
> >> completion latency, etc. to see if this is necessary.
> > 
> > The difference is that XFS inodegc is not latency bound.  Most of the
> > time no one cares if it is delayed a bit, in the cases where someone
> > cares we explicitly flush the queues.  I/O completion on the other hand
> > is something where users very much care about latency.
> > 
> 
> I ran some experiments with fio on both XFS and a raw block device. Five
> iterations each for 60s. Results below.
> 
> TLDR: Removing the delay doesn't significantly decrease user-visible
> latency or otherwise improve performance, but does significantly reduce
> throughput and increase context switches in some workloads (e.g. C).
> I think it makes sense to leave the delay as-is. Thoughts?

Thanks for the test! One question below:

> Results:
> 
> Workloads (all `uncached=1`):
>   A: rw=write     bs=128k iodepth=1   ioengine=pvsync2     # XFS
>   B: rw=write     bs=128k iodepth=128 ioengine=io_uring    # XFS
>   C: rw=randwrite bs=4k   iodepth=32  ioengine=io_uring    # XFS
>   D: rw=rw 50/50  bs=64k  iodepth=32  ioengine=io_uring    # XFS
>   E: rw=write     bs=128k iodepth=128 ioengine=io_uring    # raw /dev/nvmeXn1
>   F: rw=write     bs=128k iodepth=128 numjobs=4
>      + vm.dirty_bytes=64MB, vm.dirty_background_bytes=32MB # XFS
> 
> Mean ± stddev across 5 iterations:
> 
>     metric                     delay=1           delay=0     delta
>     --------------------------------------------------------------
> 
>   A seq 128k qd1
>     BW (MB/s)                4333 ± 27         4374 ± 34     +0.9%
>     p99   (us)              36.2 ± 0.8        35.8 ± 0.4     -1.1%
>     p999  (us)               3260 ± 75         3228 ± 29     -1.0%
>     ctx-switches          184 k ± 59 k     3.68 M ± 65 k    +1903%
>     cs / io                0.09 ± 0.03       1.86 ± 0.03    +1888%
>     avg bios/run            80.4 ± 0.6         1.1 ± 0.0    -98.7%

So 1 jiffie delay is (with default HZ=1000) 1ms. That means for this load
the completion latency should be at least 1000us but your results show p99
latency of 36. What am I missing?

>   B seq 128k qd128
>     BW (MB/s)               4393 ± 3.3        4311 ± 5.3     -1.9%
>     p99   (us)               8461 ± 73        8638 ± 105     +2.1%
>     p999  (us)             12465 ± 213       12386 ± 299     -0.6%
>     ctx-switches        6.90 M ± 186 k    9.72 M ± 184 k    +40.7%
>     cs / io                3.43 ± 0.10       4.92 ± 0.10    +43.4%
>     avg bios/run            51.9 ± 2.2         1.3 ± 0.0    -97.4%
> 
>   C rand 4k qd32
>     BW (MB/s)               66.2 ± 0.8        44.6 ± 7.4    -32.7%
>     p99   (us)              8002 ± 174      17990 ± 6800   +124.8%
>     p999  (us)             11390 ± 554     31890 ± 11076   +180.0%
>     ctx-switches         3.67 M ± 45 k    3.59 M ± 106 k     -2.2%
>     cs / io                3.78 ± 0.04       5.62 ± 0.83    +48.7%
>     avg bios/run            32.3 ± 1.0         3.1 ± 0.3    -90.5%

I'm somewhat surprised how larger is the completion latency is here without
the delay. Is that due to a contention on local lock between the IO completion
interrupt and the worker? Or why is the completion latency so big here when
the case B with more IOs in flight, less bios per run, still had significantly
lower latency in the delay=0 case?

								Honza

>   D mixed 50/50 r/w 64k qd32
>     write BW (MB/s)       892.4 ± 20.9      925.3 ± 18.3     +3.7%
>     write p99 (us)          3562 ± 107         3601 ± 82     +1.1%
>     write p999 (us)         4673 ± 217        4647 ± 107     -0.6%
>     read BW (MB/s)        893.6 ± 20.8      926.6 ± 18.4     +3.7%
>     read p99 (us)            1003 ± 48         1035 ± 39     +3.2%
>     read p999 (us)           1545 ± 63         1476 ± 50     -4.5%
>     ctx-switches         5.15 M ± 75 k    5.79 M ± 230 k    +12.6%
>     cs / io                6.32 ± 0.15       6.85 ± 0.20     +8.5%
>     avg bios/run            23.9 ± 0.3         2.5 ± 0.0    -89.4%
> 
>   E raw 128k qd128
>     BW (MB/s)               1043 ± 1.0        1045 ± 0.5     +0.1%
>     p99   (us)             26922 ± 105       27027 ± 128     +0.4%
>     p999  (us)            37906 ± 4527      37408 ± 2464     -1.3%
>     ctx-switches          3.20 M ± 6 k     3.33 M ± 10 k     +3.8%
>     cs / io                6.71 ± 0.01       6.95 ± 0.02     +3.7%
>     avg bios/run            38.0 ± 0.1        32.0 ± 0.0    -15.6%
> 
>   F mem-pressure (dirty_bytes=64MB, 4 writers)
>     BW (MB/s)                4361 ± 24         4444 ± 40     +1.9%
>     p99   (us)             29439 ± 419       30173 ± 788     +2.5%
>     p999  (us)            35704 ± 1773       36648 ± 535     +2.6%
>     ctx-switches        20.8 M ± 1.6 M    27.1 M ± 1.4 M    +30.1%
>     cs / io                6.94 ± 0.49       8.87 ± 0.46    +27.8%
>     avg bios/run            23.6 ± 0.3         1.2 ± 0.0    -94.9%
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

