Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CE7CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAD26B0095; Tue,  6 Oct 2026 05:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44B66B0096; Tue,  6 Oct 2026 05:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82086B0098; Tue,  6 Oct 2026 05:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8369C6B0095
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:18:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09C581205E2
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:18:55 +0000 (UTC)
X-FDA: 85291651830.30.19BBBB4
Received: from mta0.migadu.com (out-35.mta0.migadu.com [91.218.175.35])
	by imf17.hostedemail.com (Postfix) with ESMTP id CAF5340009
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:18:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LtEE3rJO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IkaPU5MUoMQbttL4vMSpjLE1aXwTNqvX/+5NmOiS3U=;
	b=5h69GBjtmPgGdFCX5C7kYIeMBO8KoksBT5I844lz5C8weB4RvsS8r1I9nia1SmMmZ80V7H
	/7PSUJBLOh2Zn50HikxbVWvgmw2TCdHwTA939l+wBt4yNWf3y/Sjjs0eMh8MsnHr7aHZYQ
	cn1K7UPBkM64/YbZTOqzwlE+NUFY93c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LtEE3rJO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.35 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278333;
	b=YSchf64Jv5YnL+C98ev+A9xU6vaMbjos9yTAf06ewxE6FLt68gsq5qHBmi8SJcPkpy3Pc+
	5r2ygqrpRO2sSHOCRP657uUxiv4PcClypFyYEsVoqRniFO7fy1lHWYmSRujOjcHyL0FTZt
	wpM6PdbSX44iuBb1YJ+eIUmqqIs8Ll4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NDxmeOdnEZLt33HxSjhMazQD45+/Tc0cXQPCXn7yG38=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791278331; v=1; x=1791883131;
 b=LtEE3rJO92u+ZKx6mK24AxUU7Ba4Acwti/ARpRKJCs+qke7r+IV034pxf4q8ys9WtyQTV4Ry
 VDMh3cv0cB7CBhX9NfJFoKs7GTKK0xvKQ6sKXmNmQks25iyDNlSMCjzbhjK0/EQGKSbd8+6Shzt
 RXi4NqrlZJaj1lei3FcF+uf4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f269d7c266675868;
	Tue, 06 Oct 2026 09:18:51 +0000
X-Mizu-Trace-ID: f269d7c266675868
X-Migadu-Flow: FLOW_OUT
Message-ID: <13c2ca0d-9bdb-4a23-8317-ed48129cbe16@linux.dev>
Date: Tue, 6 Oct 2026 11:18:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: zswap: reduce request contention on loads
To: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
 dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com, yosry@kernel.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
 senozhatsky@chromium.org, kernel-team@meta.com
References: <20261006002307.2669023-1-usama.arif@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261006002307.2669023-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9t47x5tcjf6haa1q3bizg9koch77i8ui
X-Rspam-User: 
X-Rspamd-Queue-Id: CAF5340009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791278332-939175
X-HE-Meta: U2FsdGVkX194phTem6KZNZFWFXdr+vIxKtkW0BjeuZsVphqXz9C0oXx2iwdMOnA5QtlUH39l5JuvB+I3L92jzdb8TsfWfdMuODCZa+zoE1lg8Aw7/+AawRuEGxd7It3ppC8GKwPpFb40285cX5ZKsyoBK1q4rMjdko2BoZKttENM7F5lh6N77B3JQr1+LdXF3Om5ue0w3bH5iNAG0ajyhPag3NjOEWaZOpvZyDALTXT/JW3xB8wpK3Nkho7rYFz/7CHHstDf84yjzXMwyZmmpeJwZJ1lUINBIZy04izjIzA3pnhJaiOwHb0qXcD7IfujeP6mcwwFZ98cl0eFRJTXvAbTrZyKTbOw06M9EhLGrtFsMlR0IhJu5ai1hArfDVvzKyvhm9THHRNz1N8Zht4Bl9np71pBGnPeUNmHxClm8tjMfsYblVMI2saxZfFizqBHR5a0O6bSTyrSe8Hhd/aa26SiUf1LozC3JlUeBBy9bGZPqxWC57pBg5rsps8qSKNV0Rul9VZo3jeVwukGV8k3iQxgDCildYrhWkKshSUQUw8MrJDalZMpey9eiDkLfJagANpAmYe+YP3FTUDAn9YNBInVlvcGzWsnRXqXjvXefhIVR+NewMgxmGzU6Usn+y4+nkzuRuVj9scq8oh3zcvTcJUv8wCDFOvC8NOw7ZSgm3G/eWzzPax6+w/wn1b9+t+DSYFZGkwM2QtQ9zQCvcjECQqAhJSGpjpP51pDQjjDX6H+VZNHwFkJEb/k/m38FHS5c21GfJ+IT6ECwxpBWDtLvVfBdczMOk4r2oD+vELtk4v7+x+Jb/59cXlFtPI2P/N07tAENrA2GVYrhoaN/Wb3/nSz6ViZoSeydio0sf0gv1CCxSC/0U48+FvSiBVdlHjAYnOEZ7+/Gz17rhhpgrtv/bUjkHJVykTJtB8h+4PAAfFJlsJ9zDXBgm3z2pSJ3duwxKxmkRYOn5ZWVx/8Oww
 jHR6wsf6
 NtPEnbHUlcIoIRzIH/NMKnSK9M/EEfMVK3+VnVMo04VEuonc0kkOqWWTpkCH+Gd1QJBpI7VOug2/r+Ou/oCnoH7gxEoFR/A/yp2wRZTHUvuOeWyb+PCA5PB3i8ODJNLFLEU4hno04VFy26dPe5b1+AhHLgKPIrmlEQtxCN+4LKv9frt4+Aq2nGgQUJvGSRLMEtFQqNwdx8kSIv3ZkbeXNhBsAYwE1b6UC4d3IYmqu2u3BlKG7ACn9Sss8kshcQR91pue/jT349GexPZLH/g7Bv0bLwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/10/2026 01:22, Usama Arif wrote:
> Stores and loads share a per-CPU acomp request and mutex. A low-priority
> store can be preempted right after the compressor drops its stream
> lock, while it still holds the zswap mutex, and a higher-priority load
> on that CPU then waits for the store to run again. This follows the work
> from Sergey Senozhatsky's zram series which splits it for the same
> reason [1].
> 
> Patch 1 gives compression and decompression separate requests, waits
> and mutexes, so loads no longer wait for stores, though they can still
> wait for each other. Patch 2 decompresses with an on-stack request when
> the algorithm is synchronous and needs no request context, which covers
> all in-tree software compressors, so those loads take no zswap lock.
> Asynchronous algorithms keep the per-CPU request and mutex. For software
> compressors the series allocates the same number of requests as before;
> each per-CPU context grows by 72 bytes, and the load path is about 270
> bytes deeper on x86-64.
> 
> The series does not fix two related cases:
> - Stores still serialize on the compression mutex, so a high-priority
>   task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
>   a preempted store.
> - On PREEMPT_RT the codec stream locks are preemptible, so a load can
>   still wait for a preempted store inside the codec.
> 
> The numbers below are the slowest read per run, as a median (min-max)
> of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
> vm.page-cluster=0 and swap on /dev/ram0. With 1 vCPU, four nice +10
> workers page memory out and read it back while a nice 0 task spins. A
> nice -19 reader pages out its own buffer and measures how long each
> read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
> and 8 readers.
> 
>               Before series (ms)      With series (ms)
>   1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
>   8 vCPUs     314 (97-2542)           7.0 (5.0-98)
> 
> Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
> 3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
> were written with the help of an LLM.
> 
In Meta fleet, looking at lock profiler in the last day, the longest observed
mutex hold was 137.6 ms, including 137.5 ms during which the holder was runnable
but off-CPU.

