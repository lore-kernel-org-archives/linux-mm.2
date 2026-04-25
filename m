Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5E9FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 22:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF89A6B008C; Sat, 25 Apr 2026 18:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83016B0092; Sat, 25 Apr 2026 18:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A5C6B0093; Sat, 25 Apr 2026 18:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE0756B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 18:10:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A38E8B847
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:10:51 +0000 (UTC)
X-FDA: 84698473902.17.4837C94
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 83442140004
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 22:10:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vdfvXvFT;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777155049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BWEaw+QFxb0X3blzqEB9JH0kiJIKH2YcFkY571mokAE=;
	b=ZsbrhCaAwSLkniTTBhqfdnWMkv4OFnc86EKJJ8g7nrMOZl97AlHVKDNzT/TwSDR4FkD/IH
	/ohb49nWZSoFIjxtieTRghyTXqkLm040N+I5BUFIO07aLPKU3wJrpEhO8nlQ7h8DQuSQH9
	vWRASNZGokw9aeimoBCfGtJeSqgD+/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777155049; a=rsa-sha256;
	cv=none;
	b=HktxoNCTe2Mseu1s33/56VFEKtJZAFrZo8EQTQ+MeD7UNNuYlPOvV+7p3det4oVKpkqXB4
	Z06Tp5r7z4YOXosES5MyX6dZjHqpDSFLfWA7hmwe8BPNNkTPuLEVW/i0i68y4SQb+MiT72
	zosL5aHRi1aQRmCtMXFq0n5vQ17+EJc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vdfvXvFT;
	spf=pass (imf23.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b2591757fbso307755ad.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 15:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777155048; x=1777759848; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BWEaw+QFxb0X3blzqEB9JH0kiJIKH2YcFkY571mokAE=;
        b=vdfvXvFT4ZxOsbHRrwEgVSxSIzYpwwKjzCNsXOxTF6N2nOsYzKGREAVzenzFZ9QRSv
         FaNDkTZ8FoJ/pMz4hZ9Ng/IUAQH2PQ1G6zbfsYw3FaFcQwFcjwl8pH2o2CMedysb7NCE
         OerFNi25I3NpaTi8pTcjl3iu9z1EBnBvSZOBqtUlxHO+fFeKcmmihGQoFZXnoBlb4q4B
         rgFQOp+lkaYm6naircrlqVLZgzzUFZoVH8q1IwHZmKErvq9rQ0ed6A3HdjZte6fc8hMo
         7UToQtLUUHnpZBtVchGcSXkeVBWvBsHsZ5HIS1zrJMKUkDPrFHA0GPAc6p9ER3gqlA21
         3gJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777155048; x=1777759848;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWEaw+QFxb0X3blzqEB9JH0kiJIKH2YcFkY571mokAE=;
        b=CZZk85uj94hJjMD+ASAukiwPVgKC3IE9TTGFZN87qo2UVHK1XRyQVxsVZhBpbm48BE
         G+TeKmgVg0Fr/XrIOTBb+rzptEvF0d2KocqNfN058niYckuS8YuvGPxOGMvTKUx/IYkZ
         IrzIaQSM1nh0nbGWlDtIHlBjQcufmwguZ+CwvJ94ZQTqGw1haJiSQuh2Nr2+FpCTZIpO
         3AoFce6EaTepRDew3cpMuwFjH8SeEU2Vpu37j50Yxbq3aFI7s5YTDxdV1/rU5IWehS8+
         VbuyXQgRguPBGERH+MWBfiIKb+IhhivqANxni+IeMRaIoT9vHf771E/++61FEGQmtWtG
         UWLQ==
X-Gm-Message-State: AOJu0YwjXbaYFnTCQvZOq/lVdA2n6v+y9hKSPYgp4B0DhSH2sswLOStd
	3RgZzPz2IjhAQBXeGUvKobKLuQjFAGuDUdEnx+adlnyVG00kTZzj4a/CAQ3ZwDL+0g==
X-Gm-Gg: AeBDiesKcXb0Qs7YL3nabZ40X995FS9UdbJ2cZOOchIUovGXdL3p0TzQK2CvYYKm1dR
	wd+LzM5moDvbdCduQiTJWXKx57lhftH2AjnTPbfdr9TRaPNoFjHToeZ2uuilDlk5cPWBVShRbYs
	mUm3yDIhChnQEjnytKRMV4riuBkuAg69P1hvtE1U17OoETejLPen1OeXBlJ+uHOB7FVhGQFtP4E
	JhoHxttX/OiwlKBBL/i/cALl5PtV/ehBqhWcAQgJ95v9ygUg4H/y6dIbIn+U8BS2oKAR3Ad9UXm
	uf8Ehx+HlJPa3TIfzA/+ceWE5m/fPKZDE27VI/w0e46qHCo7shSaYyOrl7+UZdCAwZCgUp+EUXO
	MkC8elc8TeErPD4w3jRGWYonK9yZi8goA9+Nz1yRuUtzooU5zHFO+uSvQuteqtC4/0eMx0ocslF
	P80ccbRO+sJltU+0+edrWUFZU04wvbLofQPhEFNzNVGy7W/hvIf+9uR6mNu+4c+bzcWLScvL58X
	gFiRfLIhrSXRwL91woQVzDeNLu4QyMtAhYWkiXYqaf8pMeRqKnUTkGknbiPFgGJmQzvEQrr1xeT
	Pe9HXceFlA==
X-Received: by 2002:a17:902:ce01:b0:2b4:5fca:62f7 with SMTP id d9443c01a7336-2b602f4075cmr12837585ad.2.1777155047580;
        Sat, 25 Apr 2026 15:10:47 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:a18f:54fc:a476:f72a] ([2a00:79e0:2eb0:8:a18f:54fc:a476:f72a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cf67sm255413005ad.51.2026.04.25.15.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 15:10:46 -0700 (PDT)
Date: Sat, 25 Apr 2026 15:10:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, Jonathan Cameron <jic23@kernel.org>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from April 23, 2026
Message-ID: <8a622c4f-0774-96a5-2d2a-2151e0bc2367@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83442140004
X-Rspam-User: 
X-Stat-Signature: 9kx5wk7ux7pcjithjkskpww38d1csbmy
X-HE-Tag: 1777155049-321890
X-HE-Meta: U2FsdGVkX1+5D6Eee/4dwYdaqHtCZhghZMtmxU6HrwMfqlsXmENxsODQOPHi8G5zy9AN3IGVwDRzt772ZouUlvC1k6QRr7O/4XZFMZTGormuTDkWuPDvYUEXEowsKNkVCBEf0OTGPCQVBTusuE0ttF19xdL4xrHyyvfFX6rB4+IIIBcePEE2534PUAucriiEaZGbyK2AkYzdv3dAODL+pRNEBejRHxS8zhSvQyGduZsaOqrycbIOOdfY+/K8lb1puxgDKKvveU6+M/WwN8+SM3dfiWJnpwGvzWvWh7934qNZ77pRMNnQ5bpLMBetX5C5i1IJLLKy/YHej0XIBPIZGppdWCuMZYbKTWAPexaTdFIyLH4qxXHC+vTf72OYze+5R/z2YkRj2aEL2YPBMp2lcw2JIrC9z3hvAAJGzlHYYO3U/y8B3D/CHi4Kb3F+C7YrKKRbfPmy47zGbSPAk3nNSv2U2uCbij0yiKnAazTxk4ueUJgoNL4maiK4LvNmX/RE/95kOe1ZAFee26Jtp9553mrHKE61NE6vbz2lPmxWyWHoC/R4qUxR9hi7f4fGjnbGj+srstXzd8oxva/jSBt7z2feSqvwoM8JSvBk5LfwwFu4ZHsn6xfoE1FxdGIzzQKcAhe3R1dZc+WkvFEVW6SGCLCy+ssbobRhOhCdxLEM/WGuIsV7ZyfTN1mmAxC6J29STTvyvbG6h5kNVN5inyxoQcd6mArVc/Rncqk8wlVUCZHb59a8a+exguxy6Cx0mXYr+G9pv3brtlNY9LGPzUx1O8T0ZdFuMoXxtA04F6mhRn6E2YCiq9jmt8oxoKb8+8hanCqpynYuSl0637PZTUgwOZqMWXiBhUgGFmP8I0TYf2McyvqXiDx8Ar9e9vencXFJgcfCv7LFy0ZvF7qHhBgW0S+XV+NUmj5xsc2o07kCMolbkkSedjzAHuIAwLs9rwK2FKtoQibd3NiFoIISChn
 xgQ/gx9N
 EdMCEIrjw7mmopsH2qeL2g1df8kWsH5Y4CSHYkZZe+cWRt8azrrWIdDvVjvC7Uk2KPNF8pPVv+dnAlvtu7tb1L0Q1hHB4Z/x2joXj6RRest9srdJPGeohD6fHtA5qM73BKLflAUOHA0+amBfXVUUEFloyNyBB423Pcu3wfm9AY6m6ZE9nOxuvxyPTlFFSI86/Fs2VOwfirnPLJ2Avwdo8DO8pFvPVfmI3Kwl6n5gtQpFjUpQIRj7wB2nZ0QVHqz6xkufS3ihac8sER3dTNHoh9n4B8R6RLscbbc+QFdwSZ/jsf4yaLo6EKdBtk5SpyoPrH2D8aE/8q7Z1HjGZAAxztjwJxCGo4/mBHWOQzcvc8Nbz07mSaXZfHsn9trw6pXQt18AsZzbPYPnRhrW9vB2ses7bJpjdMdxlDa5turdg2r9gXl7tfOMl+5mabHUbdUlEiWRPOGWzZwNqSVKqmq4tTKEdlQjOcZw7wc8u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, April 23.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated offline that he has a working version of IBS memory 
profiler driver which acts as a page hotness source for pghot.  It is 
currently going through review.  He should be able to post v7 of pghot 
with NUMB2 hint faults and IBS memprofiler as sources of hotness 
information by the end of April.

----->o-----
Shivank updated on the status of his patch series for page migration 
hardware assist.  He will be posting v5 of that series on Monday.  
Functionally this is working and he also tested this with memory 
compaction.  His slides are attached to the cover letter of the meeting.  
For an example of a fully fragmented 250GB node that is 50% free (every 
other 4KB page is in use), hugepage allocation is blocked.  He pinned 
compaction and a cpu-hog to the same core that is competing for cpu 
cycles.  Allocating 16384 hugepages triggered ~4.6M page migrations 
through compaction:

		Time	Pages migrated	Hog iters	Sys%	User%
Baseline	33.3s	4.6M		62.3B		49.8%	49.9%
DMA offload	32.5s	4.6M		66.0B		43.0%	56.3%

DMA offload frees cpu time during compaction so that 6% more work was done 
by the application.  This is also discussed in the upstream patch 
series[1].

I asked if this is direct compaction coming from the page allocator 
slowpath and Shivank clarifie that is correct.  This example was using DMA 
offload in Zen3 using a batch size of migration of 32 pages.  Shivank 
noted that the workload is still stalled in the page allocator while this 
migration is happening, so the benefit here is purely the speed-up 
achieved of DMA offload.

Jonathan asked if there were results for more real-world scenarios 
involving memory fragmentation.  Shivank noted this is the extent of the 
deterministic data that he has.  Jonathan opined that it may actually show 
better results with more realistic scenarios.

----->o-----
Joshua discussed his latest update for tier-aware memcg limits.  The 
graphs of data that he presented at the meeting demonstrate throughput 
differences between three noisy neighbor memory hogs and a victim 
workload.  On a 1TB machine (750GB DRAM, 250GB CXL), each workload takes 
up 220GB of memory.  The three hogs are launched first and allocate all of 
their memory, and only once they are done allocating, the victim workload 
gets to start allocating.  Once the victim gets its memory allocated, we 
start accessing the memory and measure how many reads each workload can 
perform.  The three setups presented are (1) random access, (2) 60-40 
hot/cold region accesses, and (3) 90-10 hot/cold region accesses.  He 
tested with both NUMAB2 and NUMAB0.

In all of the experiments, tiered memcg limits provides a tighter band of 
throughput.  Monitoring memory.numa_stat and looking at anonymous memory 
usage, in the non-tiered setup only the victim workload uses CXL memory.  
In a tiered setup, everybody uses the same amount of DRAM and CXL.  Joshua 
noted that the difference between NUMAB2 and NUMAB0 is also interesting, 
it seems NUMAB2 is actively harmful to the system under these scenarios, 
since it fights against the promotion/demotion caused by tiered limits.  
He's planning on sending out a new RFC later today.  His sides are 
attached to the cover letter for the meeting.

Yiannis asked if all the demotions are from the lru in this scenario and 
there were no promotions.  Joshua confirmed this is the case, that we read 
directly from CXL without promotions.

We discussed the design and implementation of NUMAB2 and Joshua made the 
observation that it is unaware of memcg so it is trying to do what is in 
the best interest of the system overall, which may be why it is fighting 
with the memcg tier aware limits.

----->o-----
NOTE!!!  The next meeting will be canceled due to LSF/MM/BPF 2026.

Next meeting will be on Thursday, May 21 at 8:30am PDT (UTC-7), everybody
is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - debrief discussions from LSF/MM/BPF 2026
 - v7 of Bharata's patch series, including new IBS hotness information
   and NUMBA2 hint faults
 - v5 of Shivank's series for enlightening migrate_pages() for hardware
   assists and how this work will be charged to userspace, including for
   memory compaction
 - v2 of tier-aware memcg limits, including new page counters and rework
   to pass folios into the charge path
 - Yiannis's patch series for non-temporal stores support
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - later: testing of tier aware memcg limits with Bharata's changes once
   tier aware memcg limits is stable and further along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] 
https://lore.kernel.org/linux-mm/a69f463c-0ee3-492c-8505-710d757a1f21@amd.com/

