Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CD7CA5FF5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 00:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B3B6B0088; Mon,  5 Oct 2026 20:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695366B008C; Mon,  5 Oct 2026 20:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535366B0092; Mon,  5 Oct 2026 20:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2176B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:23:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07583A74D4
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:17 +0000 (UTC)
X-FDA: 85290302034.04.1BC9273
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6716CA0006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcYERI7s;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791246195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S4hplLMvmNN2U7TJnXkkLTIgdq/C0b5rsJEz0ThszYU=;
	b=XoZYB6tdv8LRAgTLCrEes5R9A7M+FYgOr8C0cnT7824HtE6CzeE/dPTmkELqrmCz0VHUUC
	N9PlgTuxwvkv48AlLFDgUjvI2wstcfJ+8tnoSLuUdWtdb/sSmDcDDcdjZvhN5PdJfQVlSK
	bgoJnTemykBk12Y1d8BuWu3sNv75dt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791246195;
	b=VtvJpAFO8Bzgrb2GDKt8OtHRU4RWZWfoxhRigCht4hlWu/Ts8qyXOE5nTu7DPFiy9rIgXH
	SMXg80YAP25qD1rPNmh4/HwYV2jAIIo92VWjlpVfPSUFk+D+KxyrNtjD8whIB99HxV1kpb
	pH/83ZMTTB3itXw4Pa3tMNzMQ1tV/lc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcYERI7s;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qYGtmyOzc8QJF698ZKmKjTA6i8gvqtU2gG9Cr/NqVls=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791246191; v=1; x=1791850991;
 b=VcYERI7s+zQszVu2cM1le84SH8QTg3xnoMpKvPe5SngAv6uMclMoYdPuc1U5pdzFVFOlSNWL
 OcAYjp+l12zDRut4dSWiO/g8aUn0Fk0G2j9qbGtgmxXYoDuQ/BS4Ceoxb8uC8iTWGmmIk0F/9JK
 XJ6nYsjkanAE8kPh7o/PPA2I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4818ba5c18e1714d;
	Tue, 06 Oct 2026 00:23:11 +0000
X-Mizu-Trace-ID: 4818ba5c18e1714d
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/2] mm: zswap: reduce request contention on loads
Date: Mon,  5 Oct 2026 17:22:49 -0700
Message-ID: <20261006002307.2669023-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6716CA0006
X-Stat-Signature: gryzx15cim5gpootaapsnacqas3g34qx
X-HE-Tag: 1791246193-898885
X-HE-Meta: U2FsdGVkX1/ZmzTwjThmgs2vAk8HmSVW4r28yWnMsjQQyBrHkyEyIczG/277G5SM99df+NHGZOsLk+eGHOIM5ea4JFuWwNYMb7sTPyHityLJr0FESMrKA5M8kXbHNeLRszmTuEg3AIr7PbsoiSR++HgZNV6tr6O19s7wLkrl58EfuF2ylWWXb1xerJE/ksLYN7HPmaNhiNBysMhdCjSJR317GFPJleMsvaMYfzUYeAB0AaJ7kARJqsqEsFpsfaYP0fNV58YXDn3JYHnMLHhEIjygCPbtMOTkaukm7gMqtoOqkWN/R7POg5C+AZwWKVlzZCyrWwqVa6Mu8uVpojYXB+oeFRe7fIjo7Tq/s63GklOp7yUMQcUVKNNX3AGi4Ga+1oVt29VLRGcYIJYURadgaE/fWBsX6+SrSBBtzD4dW6NzsFUqWjqVExD5lvNxxWbPCvuOmqnDV3PyJaadL9XKHQ+bIz7PBz5nggOEoKsSvjek52VA09KVt+rirqSPa2UJYSDMvmzV0IDPJYiQPh4cBFsAuJfcK3wNNUTbWV9tqKLydDfiaPe0sSUuJ3X8gftyrIgHhNBwbcWj4b4AkbBS+dwm4IBKILPGQ7G3ziXtFGgw2D52zacN5YTv0BdzZmC162CWcZcoyPNzdTt4eAUHXbHAI1ceL3upCeNhKiOu+zWJRCqknzLuY+Gn2+g7HXVuglkqlrwtL3fvsOeIUIuVEkIMNW3ZRy8OApMh5chqemQnNgk7WY4xPSta5j7fINUihnEeNOWlUCqntPB2QRbMNeJ4fCPy2C0UIKXWCpTFBD6gG7LBLUGp67X8FynEPa8k8xChcdnWe9mGKZl2Jncq+bNLEZEtVRWhXpuvcnHxqLPdTF0cKtnkLiULwKWtAoyTh//0P0xqyqO413dV4kiKksCbMNyzwngJLvUqIuOZH9MwYUUeqILWw+Ef1W/fN0RFsQSwRGUvcW5vf27J7o4
 vf9r21+7
 tsN+WuVuXpKydZ0nLcLYoqLe6Qfm/HBT5hAoK+jZCL/GtYZ1iuwGATthlT7I/R7bOtAbBbBPN/zvsezbFXb0kpcvXWoqco0aGRwX0zKA2C+3BBA00y6D4F3qwPMa8Ux3Fchdn5+gB67DQqL3T4xvtl54jaLWvRa8dgk3z2Im2KguDFAz7wkD0QuW8fmkLfrgmvfRRVzCfg+QnyjYS5f8iHxWDR4y4QHtBs7YSV+d0w+0cgPB6ROCQWQgOuNJ+8+RIvDuL/H3o2+KvhEn/K3Syg+NNGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stores and loads share a per-CPU acomp request and mutex. A low-priority
store can be preempted right after the compressor drops its stream
lock, while it still holds the zswap mutex, and a higher-priority load
on that CPU then waits for the store to run again. This follows the work
from Sergey Senozhatsky's zram series which splits it for the same
reason [1].

Patch 1 gives compression and decompression separate requests, waits
and mutexes, so loads no longer wait for stores, though they can still
wait for each other. Patch 2 decompresses with an on-stack request when
the algorithm is synchronous and needs no request context, which covers
all in-tree software compressors, so those loads take no zswap lock.
Asynchronous algorithms keep the per-CPU request and mutex. For software
compressors the series allocates the same number of requests as before;
each per-CPU context grows by 72 bytes, and the load path is about 270
bytes deeper on x86-64.

The series does not fix two related cases:
- Stores still serialize on the compression mutex, so a high-priority
  task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
  a preempted store.
- On PREEMPT_RT the codec stream locks are preemptible, so a load can
  still wait for a preempted store inside the codec.

The numbers below are the slowest read per run, as a median (min-max)
of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
vm.page-cluster=0 and swap on /dev/ram0. With 1 vCPU, four nice +10
workers page memory out and read it back while a nice 0 task spins. A
nice -19 reader pages out its own buffer and measures how long each
read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
and 8 readers.

              Before series (ms)      With series (ms)
  1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
  8 vCPUs     314 (97-2542)           7.0 (5.0-98)

Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
were written with the help of an LLM.

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
 
Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 mm/zswap.c | 136 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 88 insertions(+), 48 deletions(-)

-- 
2.53.0-Meta


