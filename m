Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CEF0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6EB8E0009; Tue, 28 Oct 2025 15:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E2C8E0008; Tue, 28 Oct 2025 15:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4758E0009; Tue, 28 Oct 2025 15:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58B1D8E0008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:54:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD8A88A95
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:40 +0000 (UTC)
X-FDA: 84048575520.03.4EDC1A4
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A578160002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:54:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HS45+suS;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761681279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bb0C3VyuAmSiKsi2qlBRx/pFXIP36IO29vP/bFyjw0g=;
	b=st6LRlcIoWIMes2givN7iO2jicF4MYeIbeU6bkHpkRngSV6d3q00II3oU+Jn8biDbFTYRd
	t+A87yxAqRtQ7t2CIQ0ga2RjUlsujP7aHY7a8Gf0YWsUczbwbgIURsl3cdgKc07vEvowCB
	PjkT+kF+5N5JS5xztE3L/IKMAeYT7s8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HS45+suS;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761681279; a=rsa-sha256;
	cv=none;
	b=du3ZZX8/5+nEsPntXYSCA6m7l+OmYiY6PExUuKlO9ePyPBpyoal/PocNJlY4aAafex8keq
	mHJduc60C0cQZ7nGDfbebCUdis4ab5ft4G9IDhgIJa+2N+++jOmKFrw2vYhrBBPbtTKOL3
	g7N+TuXQcQJaYuvUQzob5HlW+BOYZ6Y=
Date: Tue, 28 Oct 2025 12:54:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761681277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bb0C3VyuAmSiKsi2qlBRx/pFXIP36IO29vP/bFyjw0g=;
	b=HS45+suSm2rzrJQMMkE+ycYcgEd0ql+2mj/3Lex3TN7T7ZQvpXI25hP3pXR3WsB0zcaUNK
	uiEipqPSyA+Q2udnhlpK792HxTJ2Mp/Q/kHXIOwPZubUX60qkv7f5jqoZbW18g6cQajOUP
	D0wHWOIWHS9q0agqXQNk/58Ej7bERuk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: oom-killer not invoked on systems with multiple memory-tiers
Message-ID: <o3gxx5uipm53gccoccjjdvtvv6gkyx4r7qexzdkg3uqtqc7wsv@yd3rqfsy2bpz>
References: <20251022135735.246203-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022135735.246203-1-akinobu.mita@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5A578160002
X-Stat-Signature: n1qo5qc8tmhknuepgbh4ckm9hek56crt
X-Rspam-User: 
X-HE-Tag: 1761681279-514250
X-HE-Meta: U2FsdGVkX19kzo2FI37qZu8ItAi+4C9PaMXx3YhnzTsuAG6y5KIoIN8VSzqd9Cm4LpXOS4pLrmJNjAS6YbAo7ifH1b+QZZPdr8hQjjSK0B89EDu+RHCELU1/dPPHeq0mElKKh/GOf1l4R6vbHJOCqE5rn90xzzr2Y1Lto70CYsQWl6vGWSnBGeyk+VMxnbuO9tFR0Pn3+DtNjQRll+dnslyGZSXPKFBjdA/SZVrh8Q6FKu5GKEKlco4HZoKeJkrVntjY0b2mfszF2xGfwIHwxgY/46E912p2Gofv7vfpeh0O19VeJ/i+c7743RDZ4y1kWX4P23jFJBSGofl9pZmUF/lLo+pV9ivA4eoj2uXr+32le8OjaOgzGfsiOZVfT7+iTy2Lr2zcn6X1QV6plShKCher76okQIbX+ghj8Dd9kQypmfiwBbHvCg0QWgtsScYQDFpef+bP0R7bji+VUZZ8BYGPgjxA4oKcuakuinIzbq+vWBWSaiLoI1+WJjmPiVZf6L6705RjYSYuAEdinpYe+hnOiOn/k84POGplLwQoBtzHoQ/32wMDacYRpA44++hd7M6KCuIFp2V2JW/UUkCknO2p5abG7Ha+C1IjjLEcJ64NxvGxybN9xoh+U3UNLqyvUKEkRddI7KP7cqIUlWAoVPdRCEPFyfUWz1RDGYIwzHyuwHpQmol9Ujnu1L0d1oAgXWDBjHZW10rEpjhkieDPuqw5DvLN7nT8E4s/1W5FgdT4a4Y8kWdEy4tPFSNUxU6MLyj0zGTSMO2hnK2bKK7uXetXfN9hlFlda8/a7f0SGhBQuqKPVoOtz6c5Zn0MHzf5J0ASYMzWcbcJ3m3C3ymNhgp7T/yfwBptxSi4qtRmf99KAkxW1s1wNda0aKongP7AS79dLeYa53Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Akinobu,

On Wed, Oct 22, 2025 at 10:57:35PM +0900, Akinobu Mita wrote:
> On systems with multiple memory-tiers consisting of DRAM and CXL memory,
> the OOM killer is not invoked properly.
> 
> Here's the command to reproduce:
> 
> $ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
>     --memrate-rd-mbs 1 --memrate-wr-mbs 1
> 
> The memory usage is the number of workers specified with the --memrate
> option multiplied by the buffer size specified with the --memrate-bytes
> option, so please adjust it so that it exceeds the total size of the
> installed DRAM and CXL memory.
> 
> If swap is disabled, you can usually expect the OOM killer to terminate
> the stress-ng process when memory usage approaches the installed memory size.
> 
> However, if multiple memory-tiers exist (multiple
> /sys/devices/virtual/memory_tiering/memory_tier<N> directories exist),
> and /sys/kernel/mm/numa/demotion_enabled is true and
> /sys/kernel/mm/lru_gen/min_ttl_ms is 0, the OOM killer will not be invoked
> and the system will become inoperable.
> 
> If /sys/kernel/mm/numa/demotion_enabled is false, or if demotion_enabled
> is true but /sys/kernel/mm/lru_gen/min_ttl_ms is set to a non-zero value
> such as 1000, the OOM killer will be invoked properly.
> 
> This issue can be reproduced using NUMA emulation even on systems with
> only DRAM. However, to configure multiple memory-tiers using fake nodes,
> you must apply the attached patch.
> 
> You can create two-fake memory-tiers by booting a single-node system with
> the following boot options:
> 
> numa=fake=2
> numa_emulation.default_dram=1,0
> numa_emulation.read_latency=100,1000
> numa_emulation.write_latency=100,1000
> numa_emulation.read_bandwidth=100000,10000
> numa_emulation.write_bandwidth=100000,10000
> 

Thanks for the report. Can you try to repro this with traditional LRU
i.e. not MGLRU? I just want to see if this is MGLRU only issue or more
general.

