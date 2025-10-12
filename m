Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941FECCD184
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 01:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1A78E000E; Sat, 11 Oct 2025 21:49:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9838E0002; Sat, 11 Oct 2025 21:49:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF568E000E; Sat, 11 Oct 2025 21:49:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B04A8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 21:49:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32044883A3
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:49:05 +0000 (UTC)
X-FDA: 83987779050.28.9D3B44F
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 723AC10000A
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 01:49:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kCLiK3dP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760233743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AfOUmP0sY7zxUHDb7QxJgXx0pgjcy/Vv54iFKX6wzt8=;
	b=bd2ceN/E6s5/2seodxasfXR9sPoxRj6/tQCHIXSfPA9xoWQWGE4OPHFiNZN+Z2PR8xFxVd
	Vo1AzF5X9aWWjLUUcTO+xhR4XyZyEydC83Pcxir5tBCVq59g0L5cEYdCBvn+rTQ5ABY7tb
	WON7iz2B0/FvS1ruMqKsKIaVX/7e3tQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760233743; a=rsa-sha256;
	cv=none;
	b=8KwcE9f7qt5kOOQI+Hqhtim5eztdPp5435uViM0o1jwOvNJPYxDuoJjDD5B6Frn6oiMvxd
	3qmcWJm09aD3bUj+WUXpZlr0osx/MV92G92se7/age1p1am59o8UghK8MqTOo7vBQhBg4H
	/qO6D5jBIi4MQ1ESkE4k7Kl3SDpIsa0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kCLiK3dP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2731ff54949so155845ad.1
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760233742; x=1760838542; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AfOUmP0sY7zxUHDb7QxJgXx0pgjcy/Vv54iFKX6wzt8=;
        b=kCLiK3dPCVIVfmR/b1Uo8OHcueyBxEL8ixaQhVHjoJtOWPeU1992d7mH3Wrs+WkyA7
         TCvmqJ60bqK9xq2YSjpjxlywzD3XS4wDRzQEzQ1DaDTlGhCYN1JAeaBVMbm8zP9aNvJC
         6cyNDAqrcKBsjshFReVKYAkqWD1rTMUYDxCk27s3gGJurZ6vQVPkAgn4bhxP2oSD4DIH
         Ike0IW3KtcfL62N7sD7DBQzWkt+Q5Vpq50wJ6/0aM58nDOvTWmWyDWxYA1dHN78nxkCv
         74Y8iaW6kfv6dp5H8Es6izA9CePD1F/0sDBFzi1AJ4ITYO6b1QP8nD+OjYwflJwQKsIK
         imzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760233742; x=1760838542;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AfOUmP0sY7zxUHDb7QxJgXx0pgjcy/Vv54iFKX6wzt8=;
        b=cglzWK4Smhen9sFzxyQaQl0LyMkJVFi9umQg3LKyl1LMziyNi/EyoFO57gCq3B1QHJ
         6/ZCJJdk41AEsDjO3GTmAfWwk5n5usY237L+PCcGFvl4OdeIV1z/jc/eEyQj3E1Uq0D8
         5ZVINAIySKMI5hXMmZPB4bM6HGVfkZbb9E3AYmXBC5+2CbAZ81hYbuiOMrUu7Mfdlabq
         CeFbUXI4mIIgk576ueWzgX1ffN3V6YHSMY3PAm4YIGa6T5FlrG/yXgMCe6eeMSYTXO2p
         d3j44fgjoubBLKud/9YqYe68bDH8R55GXhawHlEng4x+xqwlMpxPL+BpQ3drQgcTxt/T
         8lCQ==
X-Gm-Message-State: AOJu0Yxn2lrzQG1w497sVSwj65aPz/FW6R6FvG+tk0QCORg28dtcXiOk
	+3367NG4NLqkPnOe/+bohI0VMPXlOFe96rDEJEf55rQv+KVHn7elE7gqJXG8A74sxg==
X-Gm-Gg: ASbGncusbiHuNGHouFqyqWq9dHsXMH6TzbTcIUpuSwNtHiFPSinRgVBA5mViApNVLzm
	gwJNVTTp/KYfgpzm6Bmuqvhj1D/j+gt8yY36nJLSa7+gVMsdO8ha4pV3lXf8/D4GewxxOt2g8Bu
	lIX7Bpbaj6xvxBDPGSZSZ0815jhWfPueURbecUEVCGfFoANCfR20Y8xIKOW4BSOsjjLwlZtKaZZ
	oiLM5MJe3RGWzIkde+3AvbVQZbOoHAM8X6ZC4mWCAHXs3Tc898XkhznmawrOCTDF6bqn4zWxH10
	f/y6x6YDT6Udo2mWZow+sesEuuyzbc9D/e6kXUFIXrUjy1W9WXaBcX7+iCIj792dDhUTnfUUfCY
	i4G+MNDk21sjodMXO590KANp250v6cxcaSzsOPmfH8qCcpsNd8UT22cDzO1Z6nBM8dvfbTCrbVc
	9Bty1lpOvr+8ooKXg7Cqg8aaNFr8uZdhPJuckweSMgZ+qRatUN4S3u1nKhqm9meQzbHYYN3HrvT
	C+PDrauAQ==
X-Google-Smtp-Source: AGHT+IHs9m6N29eNpw6ct5zwhyDSvljMSzXkgvrYeyM3+HMFP00Ou6Uh8dtpvKpRV2UD2l3tca0Gqw==
X-Received: by 2002:a17:902:d4d0:b0:265:e66:6c10 with SMTP id d9443c01a7336-290275dda96mr25634685ad.4.1760233741344;
        Sat, 11 Oct 2025 18:49:01 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:d38e:e48:4bd1:f89d] ([2a00:79e0:2eb0:8:d38e:e48:4bd1:f89d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626e8bf5sm7332622a91.23.2025.10.11.18.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 18:49:00 -0700 (PDT)
Date: Sat, 11 Oct 2025 18:48:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from October 9, 2025
Message-ID: <3a1586b1-4107-06dc-f630-8951cc044c5a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Stat-Signature: q4yczz4aoikre9a9p8xxa9exgebfnxr6
X-Rspam-User: 
X-Rspamd-Queue-Id: 723AC10000A
X-HE-Tag: 1760233743-318793
X-HE-Meta: U2FsdGVkX18TrscyRig6P9T5hCyoH8Za4hnJiVEwAwPfHCzD+bJWT/AYjLUXtFvUF3X4h6aSmZFYaOXcNxbyY/H5mJBt22Fd8Cc9WTQJ8LP6zEn3TUvj98s0B8viBBsokjzebqwoGOK2D5h1QsfZ7aQ3n5DJTxEj1RzjnaexhmQsSUtOA9jtkxFz47cttLx+quB1wVfRR8W1Gx3ZLWrkZ0ZF48Lk8wUNHGBWbinpZZzfkYS56DkI/xnYr9k2o6qhfaMknolRpgH1+dHjjkYoEWGnarf6C1Zs41WbIAsDB20r3qiYU2dJOic3qp+HcYq39u8XHzPIG1vyMRBuaBfyFOjCjIKoW+GyHT5fl9DFo1h/wM9gdeGm4jbOw96arI3bc7kIxot7P1xdsI2rxlV8w1ioMJB+Btqam26bpasxbdZaJnJvF5Aw7x3nnWnhttecyYRQcHhUiocCMvsnAO6BDnbObTFaCZvjdeLMWMu1JyplOMcJrsWxUNEbbK74sCdOVha4t9nEG/+JNxvREBTqXxXLVgYYfBrMtSg4aTwuStd3WfogAY0jaWxHdcQZxojEg7/XMdBSjpPAyKzZ445hnmRm5smLIP2RijJN998aLZTjDpRL1vv2/bB+sKimRtm7g/QTK44nDPU2PYFxr3q6AzucNXXasYW/r0SkXk6siv5JHzXzvcjI/XAjo1Mg2webo49qqmAK1D6pNz27bmOQ4fR2jzy/YbtMpoUOYetq5/E0VNZHd+/GlbcFK3+XwyhsYXcr7vaqIfsTrgkFIBB7eAQ33b3X287D9JOSJrax5+B5Slu5InW9M7lg86SQk9G3XRyw5H/n6ghpiU9r9LRMpPr1WLUF0nfRJAuPCu2up6RpD6jutWVdIXZJJyIoMtOhPkOMOmeahzrYdwgsPchAQnE9MJhw+A3Yamjv7MufKkM+ByF7PxWDlfLAbf8qS6Hcq54T6BZfJoaQXdXCKme
 1UNuNJwz
 /h2oZbufKZmjHUDY4Vp9uQj8tVv67OnSpEpXIvULbeRF4xnu4ZDOr8mNzVbvozyd9CTyC3Gb3i+1+0qglUG9I6ShpIn2TnW5IQwN1EZRLCYlDV6AYdIBBGIslHTw2RuKRyiuy5r++2G6YfkLLNRLJ9nM31Ed/5w0dhKO5SBb6SBytzTO+tNMFQr6qCeUv+CTwJg9k3WesO+6qZ9o08vF8+vshJoE0rcRA3V5GxEPMVI2qryZ5v7ZFD6ZMQk+p2GkmKBthoPXvjNs5yazuHU/EwIlhca5vpXZtgMKyU2/kRBFeA3BQSJXwqoLcmkLF8t89Luq7MtTfY0/DQ8uG9VULnbAiB4Sd602S/auEwzZFTdbVg4yVQECkCSTzPrmov5MEs9AQBT83Jg6adDMZIVoJDi/M90boFnFXd4IDW6jPJvp0xgjaYYoUsDzKIaci0jcWPqxEXVUs5tm68A7r8vVGIu3rYpE8Qbp7f/wz60aYNFn+RMg915m+hdgN5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, October 9.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I relayed some updates from Bharata: he had added the pruning logic to 
kpromoted and then addressed Jonathan's review comments.  He spent some 
time reviving the earlier approach[1] and the kmigrated approach uses 
statically allocated space (32-bits for extended page flags to store hot 
page information).  The kmigrated thread would be too slow; Bharata has 
subsequently did improvements to this and integrated all the sources of 
memory hotness information into it -- this is now comparable in 
functionality to the kpromoted approach.  He will be sending the patches 
for the kmigrated approach soon.

Bharata provided a slide[2] to compare both kpromoted and kmigrated.  
Raghu summarized this: with the kmigrated approach the allocation becomes 
very small (reduced memory footprint); the status of the memory is 
available in extended page flags.  This drastically reduces the amount of 
complexity involved.

Wei Xu asked if AMD had considered Xarray for storing this information.  
Raghu mentioned that there are approache for both Xarray and Maple Tree.  
Gregory noted that we'd need to operate on the Xarray which requires a 
locking structure which would not be great.  Davidlohr said with Maple 
Tree we'd at least have lockless searching.  Gregory countered that this 
would likely be a write-often scenario rather than a read-seldom scenario.

Wei noted another approach may be similar to LRU.  Rather than a global 
data structure, if we want to promote memory per job, the hotness 
information might be maintained in a LRU-like data structure (one half is 
hot, one half is cold).  I noted this would support both per-node and 
per-memcg.  Gregory asked what would be the cost of aging off the MRU back 
onto the LRU.

If there are any concerns about pursuing the kmigrated approach based on 
the slide comparing kmigrated and kpromoted, we should continue to discuss 
this on the upstream mailing list before the next meeting.

----->o-----
Kinsey gave a brief update on the resume fix for klruscand.  He had been 
experimenting with it; it currently patches the PMD access bit testing and 
clearing process for up to 64 PMDs.  He had been investigating this and 
will likely be removing optimizations that actually harvest 65-66 PMDs.

He plans to send the next revision out within the next couple of weeks, 
but this continues to be under experimentation.

----->o-----
Raghu plans to integrate this patch series without waiting for the resume 
fix upstream for klruscand.  He was incorporating Jonathan's comments and 
feedback upstream.  He is planning on providing a link to the series; he 
wanted to have some rough patches before the next biweekly meeting.

Raghu shouted out Jonathan for all the feedback that he had been providing 
on the series upstream, this was very useful.

----->o-----
We shifted to a lengthy discussion on optimizing for memory bandwidth as 
opposed to only latency.  The question came up for whether kmigrated 
should optimize for memory bandwidth and interleaving.  Gregory splits 
this into trigger and mechanism components; the scanning is the mechanism 
to do the movement and the trigger is the oversubscription of bandwidth on 
the CXL link.  For example, if the DRAM tier has a 10:1 ratio of 
bandwidth, then you would want to kick off promotions if the DRAM link is 
under-subscribed and the CXL link is over-subscribed in terms of that 
ratio.  This is similar to the weighted interleave work that was done.  We 
don't need perfect hotness information to do this; once we know it's 
over-subscribed, we start promoting what we think is hot.  A handful of 
hot pages can contribute significantly to this over-subscription if they 
are writable.  He was unsure whether this should be userland policy.

My thought was to avoid the kernel being the home for all policy, but 
rather use the memory hotness abstraction in the kernel as the source of 
truth for that information (as well as bandwidth).  Policy should be left 
to userspace and ask the kernel to do the migration itself, including for 
hardware assist.

Gregory noted that both latency and bandwidth were related; once he 
bandwidth is over-subscribed, the latency goes through the room.  The 
kernel wouldn't want to stop paying attention to bandwidth.  We should 
decide if we're just going to allow this kernel agent in the background 
continue to promote memory to optimize for latency.

We discussed how per-job attributes would play into this.  Gregory was 
looking at this from the perpsective of optimizing for the entire system 
rather than per job.  If we care about latency, then we have to care about 
bandwidth.  Gregory suggested two ways of thinking about it:

 - we're over-subscribed in DRAM and need to offload some hot memory to 
CXL
 - minimize the bandwidth to CXL as much as possible because there's 
headroom on DRAM

The latter is fundamentally a latency optimization.  Once DRAM becomes 
over-subscribed, latencies go up so migrating to CXL reduces the average 
latency of a random fetch.

Joshua Hahn talked about this at LSF/MM/BPF: a userspace agent to tune 
weighted interleave so that when we face bandwidth pressure, we start 
allocating more from CXL.  The consensus was that this should be 
userspace, but that we need mechanisms in the kernel for tuning the job 
for when bandwidth pressure on DRAM is too high we want to offload to CXL.

----->o-----
Shivank Garg gave a quick update on testing kpromoted patches with 
migration offload to DMA.  He had been seeing 10-15% performance benefit 
with this.  His slide showed, for abench access pattern:

	mean (in us)	offload disabled	offload enabled (DMA 8 channel)
	random		39114520.00		35313111.00
	random repeat	11089918.20		9045263.60
	sequential	27677787.00		24578768.40

We planned on discussing this is more detail in the next meeting.

----->o-----
Next meeting will be on Thursday, October 23 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - discussion on how to optimize page placement for bandwidth and not
   simply latency based on access based on weighted interleave
   + discussion on the role of userspace to optimize for weighted
     interleave and kernel mechanisms to offload to CXL when DRAM
     bandwidth is saturated
 - update on the latest kmigrated series from Bharata as discussed in the
   last meeting and combining all sources of memory hotness
   + discuss performance optimizations achieved by Shivank with migration
     offload
 - update on the resume fix for klruscand and timelines for sharing
   upstream
 - update on Raghu's series after addressing Jonathan's comments and next
   steps
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - discuss proactive demotion interface as an extension to memory.reclaim
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1]
https://lore.kernel.org/linux-mm/20250616133931.206626-1-bharata@amd.com/
[2]
https://drive.google.com/file/d/1gJ_geNAu0fzv6kjdM4qdramVTfyY4Pla/view?usp=drive_link&resourcekey=0-qh2DPLK1GX3joy0XSM5KrQ

