Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D14E63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B0E6B008C; Sat, 24 Jan 2026 22:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806106B0092; Sat, 24 Jan 2026 22:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3116B0095; Sat, 24 Jan 2026 22:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCB96B008C
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:35:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9AC4B977F
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:47 +0000 (UTC)
X-FDA: 84369071934.01.5CEB177
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf29.hostedemail.com (Postfix) with ESMTP id 35901120006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:35:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QWFAbf61;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UNQgEWiXrS9CZkOQGKvePMDa1YP3T+67ZGAzTjgZ9Kc=;
	b=ZLs4qe+g/wOEQi3+s3jEhLWr/wmvnSvlY74XR18vNlmHcv5NZMzfdHEEuBnGIkYciGAz3Z
	XqujmLG+hoBEjMVnMEAEtBIv1arZN0C5qOyLAwbRFJeJNZrIZLoKyUuHHu253rKZbwFaWF
	X+gVwHy4Y4LLRh+k4qipnu46Vdes8NQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QWFAbf61;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312146; a=rsa-sha256;
	cv=none;
	b=sTjqcElMD7AHV0nHkJnyqeDD2UM45uppuwdka20wjmp7dyNQua8MLaN/1YNO1wJIptzYUI
	i/pttWJ2wfzFpUkftm/jOQWE+0EGQhIXOkQFFKScfYPKG37687UjBQxmoCVhvANgy+CPxL
	i8i6aFbTAJ5X67G66n5pCfUMG2Z5p5I=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a76b39587aso53635ad.0
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 19:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769312145; x=1769916945; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UNQgEWiXrS9CZkOQGKvePMDa1YP3T+67ZGAzTjgZ9Kc=;
        b=QWFAbf61YB/FWohKOXDdlsvaW8BGqpNdj3ekV+uExdOswlbFgucBDTq3itFq0qXkbZ
         zXlRWg44QiaSA31qj56IS1JPegx1Horzag8YiItJqXnCJy/AqeRwsxuvz0KhpNhXSjHO
         lTorbnSwRjglLSpuQekQ7NK9R2w+bVdx6wDc1t6FYQRi1UAYgCfNCBJYObMeJxU3hU+U
         GM1v/uVhp4l2ZmfGT7CYe9LEtRRy4Cp2x/7LJ1cnOX+fm2/gGEr5AKIP6lD6hP4w6pwT
         Y4o/YcOvUWOYwlkRrYJOTFuXzhSD/NYJFSJjzGi5OChwgqON5a5S/u+1GAk770p48xDy
         sA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769312145; x=1769916945;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNQgEWiXrS9CZkOQGKvePMDa1YP3T+67ZGAzTjgZ9Kc=;
        b=tPOrcmOlABdQ/N9/trpsO9NDobSf3T8hAu35OXhio6XSuzLiCcc5xWHsfoQ561JMnn
         jguslE8EpSUsUd4YK6d3c9b9vC4m1FTti08fUN024kCpQZaX7ScgC+dpMTQw1a9rhPWY
         LXtrFX2LC22A19Q2l7UifLnevKgxoNr9BGL4P2Bq4Shm/B65lBcv06+bYhfp2RJ2IFOz
         vympyvflkJz+A8rQVPiD35ktD2DsNkauE8aGJgoq+8g5mbfyg5Lo8TZ5/F91fwW51Dy0
         Ud+kEIfluj5vkMD1OOmQasphdy/7m8KfEnUQYTcfKm06LsISh1PqlMFo92H6+mtZ7B85
         ioUw==
X-Gm-Message-State: AOJu0Ywnqdg7ALcLafI9bgFVBVHJPGsv/v4vJTAkiT1QKciHw4T/rz7w
	ZqwUguzBTVw3ePJs24iAe7ex6kwnujOuIMOmQPCS6iCPYGzOwp+s89mOpXcOhzONAQ==
X-Gm-Gg: AZuq6aIH97bJNBbNNthnKpiniQlZ0WFWEB+jBokN0Dt2RB/BcsCcoFW4PQEb3QGUaK4
	XASTEeAVkK+PJ1FlHUJT7ATt4cvmeEDB/od37tmv2bol3Q4zeh5bFV2tcRDNPbBzW+ox13gifZN
	nISYv2wk8lyyT7fuAi4nqcBkGe86bv4pdYx742DQ/43713eHRyBnogxVZAOWO2+78be+k69J8YT
	6IsR5vJn+cVHhhPsZ7c65LADhVo6doJfYbXpUONY+/EtDfuG0QoV9c9jhBPlfp1qR2wjh06JmA1
	/r1LVDgqxBOK6Gs4tl7XxmbC6v2ASRDix07KlFx5XbUFlnsPLIdd/bedrQ3Qyjc9iGBsaIm/v/D
	yFPE/Pqvhpv5/+15iOcvBZMW6fT30J/AfkIrc7q3kePT2a/4i6ghHFm9UZHab23ZV+lxi0WUQQK
	RLx5UveDWEsgWNuQV7XXRe8kSbInGbCrEXGStRZ07LnBqEn4x6oGZSDPZWstI6NxYZBXIGmgFuJ
	fjfHP0LCcFPKqgBIvze23qnV2vNnsx2iUyVowAQjA==
X-Received: by 2002:a17:903:230a:b0:2a3:ccfa:c41f with SMTP id d9443c01a7336-2a8449014a6mr228525ad.1.1769312144471;
        Sat, 24 Jan 2026 19:35:44 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:d429:8c65:e94d:134e] ([2a00:79e0:2eb0:8:d429:8c65:e94d:134e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802dcd585sm56012215ad.29.2026.01.24.19.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 19:35:43 -0800 (PST)
Date: Sat, 24 Jan 2026 19:35:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from January 15, 2026
Message-ID: <684fb18e-6367-a043-3ee5-dd435da30b91@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 8ukwugxjf13cw5h6ti7k6ndw4yj9c78y
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35901120006
X-HE-Tag: 1769312146-702852
X-HE-Meta: U2FsdGVkX19LMwfqhGeTytjjubqrtTr6Ju2fIqZI/i7/41wrr9UvuvwZfwsOSAo/p2iXWCEnIcP5mc92UlGqIaNnj2kh1+3MuaWB3QWi4Ny2I17prV423rc/toLAcOnkP6O6zh7BUBkjIXvfnISJHqFlOxBpDHaN9WKs+b4bx7t+kDXtm60a4FtDHuWQnjV8WlvgNLUWLTYrF5QfdTBYO60kjU/GfVV+gobt8wWcmzEQQ8RjQZ4wCItO0CDR4BnzJQzulBta1OeyqZWsFBUMX5VVoEQNXmxnaNWkBTTQy2xVg0iEorf7B85v2rBqk7zlODS5YTw2YzXpUfIuNOTljHCdALc5cL8DamRxR3TSLj/J9E3aG2sJgQSX8CbHE62qC5rvZJCY75XQUe40Yp9P8VfsV8rUoYymCTKra/4rYrflqY8MXz6SmRvJOFp2rLwCyuZecpoAVeCMaDiwIDBycsi6uLLfBRxCPoOTHEWkqvXlSpTI4aMnhyK53WK39vu1B+epVUC/n83DqeMmzSsA6l8xji/W0dnruvwxql0dZE2erPUlPYWq2k1nReniqjMGrx0TPOlEV8oK1twXSjqUjT4Ukm6ijcIwWWIXDhgOnS9UsA3X+i2fxhhtFeynzf05InZPAIdEaAnOOjWSZsx2eJMoisd/OwI6whh2GIk3DJlTFNz2ixHthkf6V0rP/8g+e5hjydBHzBqk13rddGHfZdIoBh8a1fxyfgsSv/nOiPjXDMLC4dpOuljw68UQ3Nsp7OSSf0QCQgFfKoNZO2TsNK7MaUd14FL16k5AocP83iUuRvc23Z1J/8IQS0kKpMA1IoV893KS783ffuBYZcMcQf3oLhqFA+QINOYFd+QkPgkEUTCCIM5h5Pqa83fkhwVvpRgzKOYdenLGve8OWjL0DRc75tWdoM0aX6ADxxWaqKfTNrJewqG5RrTMZM239EiAJRofWFkl9rcj663PQlZ
 tHIH96tP
 i0wq/uvxPf1CiD9MtNfIq4ygLy2w+69sDq0Fw3MHzc19mF60ohE0S8bW6O6Ulgl0A0yoHHECddKUM9cAOQhSuykXthXekDaWzMvaEvsWyQ+t8MlI0ytQEE1n15Teh8uVnU270YhYTqfUhD0bDfVXickTtppbyVe/IsobtbDXGO/q4zDWamHh03f9eP5nWu0XtfNMzuMwxILR0y9h9knfdcC3eYYt/0GQnqWZiiLlHcNawStZfpSP0kufnsdtxtFjzJ7dtkj5/MOMKEiFRPl8/2y8MztNa++eHX69a8wX1LBJK4C0aV/2fLRiaaphdLacF2RPnqttwIxycVxD84Yd2uv7NwGEVqoo09ZIZtenEcem6cg8wxZKTVD0uRYakuRBAHvVZX2E+uu31EAQs7/dePiQJKwLwCdOzgIwPhS0TmqdR9L1Fk/k1ON9COY1nn7VeBGvjOAhvEitZDelwTaKC6Bjvh9nuAC4t1Gfmh5taDA7srmwxNORDKXy6PKB2d65U2S/v1036xsYJ7eE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, January 15.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
We started by chatting about benchmarks and workloads that are useful for 
evaluating different approaches to native memory tiering support in the 
kernel.  Wei Xu noted that there has been heavy reliance on memcached and 
specjbb which have been useful to evaluate policy decisions.  I brought up 
the previous discussion in this series of meetings back in November where 
Jonathan noted that memcached was not ideal because it's too predictable.

Yiannis reiterated that they've used a mixture of workloads that were 
oversubscribed, it's never a single workload.  He questioned how much this 
represents real production-like scenarios, however.  He wanted the 
community to provide the direction on how to evaluate this.  Jonathan said 
oversubscribed, multi-tenant containers would give temporal variation -- 
he gave the example of webservers that may sometimes be busy and sometimes 
they aren't.  This may give the dynamics that are necessary with the 
variability needed to evaluate different approaches.

Gregory compared this to using microbenchmarks that originally get 
scheduled on CXL memory nodes and then finding the hot memory to promote 
to top tier, but we can just randomize what pages are actually located on 
the CXL device.  He suggested that this was more functional testing than 
production representative workloads.  His plan is to run workloads with 
synthetic data and then share that with the group for something that more 
closely resembles real-world workloads.

Gregory noted that preventing churn, however, is the hard thing to 
actually measure in situations where there is more warm/hot memory than 
top tier memory.  He suggested monitoring bandwidth stats: you back off if 
bandwidth is high across all the devices.

I further suggested that performance consistency is likely more important 
than small slices of time with optimal performance that may turn out to be 
inconsistent.  We want to avoid always optimizing memory locality only to 
take it away later when another workload schedules or spikes in memory 
usage.  Gregory connected that with general QoS with two forms: limiting 
the variance and minimizing the variance.  Minimizing the variance can go 
very degenerate very quickly; limiting the variance is likely the goal.

Jonathan said that, today, the guard rails for limiting the variance is 
page faulting which is pretty slow.  Gregory said we lack this on 
multi-tenant systems because we don't have a sense of reclaim fairness, so 
we can't limit the downside of any given workload.  We'll need this to 
provide a consistent quality of service.

Wei said that when we do promotion that the allocation function does not 
trigger direct reclaim so if there is no space on top tier memory then we 
just fail the promotion.  Promotion itself will not cause this thrashing; 
the question is whether we want to aggressively demote to make room for 
promotion.  He preferred to focus on getting a promotion story upstream 
beyond just today's NUMA Balancing support.

Gregory said that the promotion rate is a function of the demotion rate 
when capacity is fully used; thus, promotion will not occur if top tier 
capacity is fully utilized.  Demotion will only occur if new allocation 
pressure happens.  So there is a guard rail, but the demotion policy has 
to be put on the user.  If there is some amount of proactive demotion, 
then that is the possible rate of churn.  Capturing this as part of the 
story is imperative; we won't be able to sell this without a comprehensive 
story.

----->o-----
I suggested that performance consistency is imperative; we don't want to 
go free a lot of top tier memory and then suddenly promote everything from 
the bottom tier only to find when we land another workload that the 
performance of the first workload ends up tanking.  Wei said that we need 
to ensure that we only demote memory that matches the coldness definition 
that the user asserts.  Gregory noted that, in this example, the original 
workload is optimized for having some level of consistent upward motion 
performance and the second workload necessarily ends up in the opposite 
situation.

There was discussion about per-node memory limits that has always been met 
with resistance upstream.  To get performance consistency across hosts 
regardless of other tenants on the system for a single workload, it 
required a static allocation for each memory tier.  I suggested that we 
could proactively demote or avoid promotion of warm memory to ensure that 
there isn't transient performance improvement for a customer VM based on 
other VMs that were running on the same host.  This could be handled with 
userspace policy through a memory.reclaim-like interface for demotion.

----->o-----
Next meeting will be on Thursday, January 29 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - updates on Bharata's patch series with new benchmarks and consolidation
   of tunables
 - avoiding noisy neighbor situations especially for cloud workloads based
   on the amount of hot memory that may saturate the top tier
 - later: Gregory's analysis of more production-like workloads
 - discuss generalized subsystem for providing bandwidth information
   independent of the underlying platform, ideally through resctrl,
   otherwise utilizing bandwidth information will be challenging
   + preferably this bandwidth monitoring is not per NUMA node but rather
     slow and fast
 - similarly, discuss generalized subsystem for providing memory hotness
   information
 - determine minimal viable upstream opportunity to optimize for tiering
   that is extensible for future use cases and optimizations
   + extensible for multiple tiers
   + suggestion: limited to 8 bits per page to start, add a precision mode
     later
   + limited to 64 bits per page as a ceiling, may be less
   + must be possible to disable with no memory or performance overhead
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!

