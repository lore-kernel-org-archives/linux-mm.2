Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68347CA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545FA6B0088; Wed,  7 Oct 2026 06:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF636B008C; Wed,  7 Oct 2026 06:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5766B0092; Wed,  7 Oct 2026 06:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA236B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:56:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4042C14019C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:56:19 +0000 (UTC)
X-FDA: 85295526078.03.777F9FC
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf21.hostedemail.com (Postfix) with ESMTP id C4E861C000A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:56:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flhXYIJJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791370577;
	b=u7iOE4X2p7wwryAogl6kNMBEGc2V9U5M0j+xHJMANvRvJYnp1kGTgdfY9BLgTKU3hbOLZd
	4jGqFXiIs+vfcwJI0xI1OS8N2S82PLFsx0vbccNMbhYsjv7YVTJRbCQY5WrdMES9e+GQjJ
	879r/iBvQ7VerDmC5wbvOBDXsplJvPI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=flhXYIJJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791370577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/qBQt83kIhvqov9hrYq+lELOnrm57eT179QxEounn8=;
	b=tC3KhVDF9KT6wJnxe5y6Ey4qJ+TzU6iGwcwE9g768DsG07GKRpQyADtA9BLeUYBoCEx2mC
	od/s87AkyCu+CI3hUaprKVVOC5Qe25tnrtbhiW6OtaMg1LZfNtyy0oDpDF5lbHBDAt5xkm
	YwrJfm0h5xWNlc/vNcfaEUNPbVvhj6A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GxCPlE57Cq/icBi/tQSzj1Ld7BdDAW/pW97e/uehP3s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791370575; v=1; x=1791975375;
 b=flhXYIJJkXhCfJmFDZobYSAR8JMjoqIeTErzUj59Z8BB1rYHeLIJfpnVvhxbSSDm25XYippy
 +11zYotNAnNt7Yu5VNJoQx5Z+rFxpGZTjWyVU5D3lWVgw6v332Ohf2qwRLXmDTXsGVczAPNZEGo
 +71rpL4/UBSb0uRjGDLlrox8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 23a8dc82b3a969ab;
	Wed, 07 Oct 2026 10:56:14 +0000
X-Mizu-Trace-ID: 23a8dc82b3a969ab
X-Migadu-Flow: FLOW_OUT
Message-ID: <209aaa32-7763-42d8-83e0-470066c880dd@linux.dev>
Date: Wed, 7 Oct 2026 12:56:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: zswap: reduce request contention on loads
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, terrelln@fb.com, yosry@kernel.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, senozhatsky@chromium.org,
 kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <CAKEwX=N3ks2O-dCYPRif3NnHQckdVqLiPGRn03GkCuEE+FVgtQ@mail.gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <CAKEwX=N3ks2O-dCYPRif3NnHQckdVqLiPGRn03GkCuEE+FVgtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wxotyaj4gfs9didqn7bzuz7iaq5fa74e
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4E861C000A
X-HE-Tag: 1791370576-598440
X-HE-Meta: U2FsdGVkX18oqftCd2h6DlCbMJbM5T8+agg8kw9qv6mHNHb8hN6d4H9A1TggNVwCcULJy76AdqKPaVkqBlY4wnAX5MbCUl0DigBdKxu5ydFsX6pAluTfRkLEeyIKWlapwdVqkRtXp74Th5RhI3aG7MNu/TBxzLtSwYFBDP/CzvOXbJ2QnG4cev7mSIp9Cu+bUVBII/NxAJwUMI4mgQQtyElvKSLL2GxfDGxXLdx0+7mS0OcfBbP2RyZKjM7RDpw3JYrgUOV8zuZu3tOw7mxBkXT7Me1+wZmZKiJcHiM0rlzh5jNOXUYgepxto8CnXiFza5V7TJS97jF1OKqLgEhnX7X6nQw24VdRQO5vyC5poxWU58nxdrP5uHg0r4Lmx4X+rbZNqrSJIXKItxCblXzN0Jr98+4UtsGR4bC9pYWFVkHw2K2rqDqhCysRsiqHNegRiJB8LnuAvU5loeQOyQx1rsr5m8D7AzYGt4LaRz69PYPw4CKMsL6mVdcLngXiTEA5eEOVNVIAP8UyK4NczLak+YdTK0OJf75BMyyB0aefUa2iGNyBtDG9vXLsO+uR89vSqwdggSic7gOvXHnsClRnXbclezFEnB/T0opwOW5+had8tzXgqkRYqVG8aHuoI/zT0DFCppBDOGsqZ+diu354PsF5lyf91w7LrGs5BISDEqfuiJrooNtrTs8HEIYhJoVOluqGW9N0Hi23VUY9h+UyUZ0ocK11ZZH0EHzTOblqsjDG34JGtWHb2Fj341SlTvfVy2FtNVGVvPnvh4yz2DjReiyYTGXjdB9xyoMN+0APKxNPFWWzQ6F6EyAL8yuErvbmV6o2d01an+gH3cV7ETr7L+oRrSVqBfOQcQEshlLqujzCi8fInhfBUdEbNS3UmfIKx1gKa3Cr2qIc9DG9Yfd8TzVXd32NodWnsfReU03XeYFpahMYmo6IaCS5R7szUsCtKTSXUYr9wplQRF9CIxP
 KjeXc+Dw
 iWIhRtLiF9v/1ppXBFgUq+rXwH3Uozmy6T7v28dGAb4/Wz6qlyYqH3Iy01Sz6mHHV+wW301uLMqQbxWt4lCl1Fcn87cI6Yje8xxkUtdY6Oxnpb0pdaItjxI+yYidN+FNH/gFinkeGlZumuQ9yfNf0aLj8wL/adUtinuv4wzTeyKBWdaManI+ZVbJ6wkQqBHzsc2ayfRGOI/Cmru+XrTEoRJXnVXtuko9BwICOS2EHGaVzWh8Ev+9KKrIu4FjCOIHVKTy9P28XFEaXvRjVEX775fNj2ltsx9OmoWZDl8gzrIL8+mJw+nqOphuHlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/10/2026 11:35, Nhat Pham wrote:
> On Tue, Oct 6, 2026 at 2:23 AM Usama Arif <usama.arif@linux.dev> wrote:
>>
>> Stores and loads share a per-CPU acomp request and mutex. A low-priority
>> store can be preempted right after the compressor drops its stream
>> lock, while it still holds the zswap mutex, and a higher-priority load
>> on that CPU then waits for the store to run again. This follows the work
>> from Sergey Senozhatsky's zram series which splits it for the same
>> reason [1].
>>
>> Patch 1 gives compression and decompression separate requests, waits
>> and mutexes, so loads no longer wait for stores, though they can still
>> wait for each other. Patch 2 decompresses with an on-stack request when
>> the algorithm is synchronous and needs no request context, which covers
>> all in-tree software compressors, so those loads take no zswap lock.
>> Asynchronous algorithms keep the per-CPU request and mutex. For software
>> compressors the series allocates the same number of requests as before;
>> each per-CPU context grows by 72 bytes, and the load path is about 270
>> bytes deeper on x86-64.
>>
>> The series does not fix two related cases:
>> - Stores still serialize on the compression mutex, so a high-priority
>>   task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
>>   a preempted store.
> 
> Any reasons why we cannot tackle this too? Or just one at a time?

Stores need more than a request. The compression mutex also protects
the per-CPU PAGE_SIZE output buffer, which has to stay ours until
zs_obj_write() copies it out, since zs_malloc() needs the compressed
length first. Loads stopped using that buffer in e2c3b6b21c77f, so an
on-stack request was enough for them, but the buffer is too big for
the stack.

> 
>> - On PREEMPT_RT the codec stream locks are preemptible, so a load can
>>   still wait for a preempted store inside the codec.
> 
> Acked.
> 
>>
>> The numbers below are the slowest read per run, as a median (min-max)
>> of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
>> vm.page-cluster=0 and swap on /dev/ram0. With 1 vCPU, four nice +10
>> workers page memory out and read it back while a nice 0 task spins. A
>> nice -19 reader pages out its own buffer and measures how long each
>> read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
>> and 8 readers.
>>
>>               Before series (ms)      With series (ms)
>>   1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
>>   8 vCPUs     314 (97-2542)           7.0 (5.0-98)
>>
>> Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
>> 3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
>> were written with the help of an LLM.
> 
> Great find, Usama!

Thanks for the reviews!




