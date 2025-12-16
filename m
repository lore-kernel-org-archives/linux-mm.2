Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A125D5C0C0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 03:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBCA6B0005; Mon, 15 Dec 2025 22:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C096B0089; Mon, 15 Dec 2025 22:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8646B008A; Mon, 15 Dec 2025 22:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A337A6B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:16:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FC9E135C10
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:16:59 +0000 (UTC)
X-FDA: 84223872558.01.E1B9EB1
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91A6B1C0012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:16:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ARbq8qqQ;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765855017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ca7PkbgKDCo99o9sSDTSFk6+AACGhMSrOCn0rGl+w30=;
	b=QM/ZBRQh+ZPLS2MEMfyqlw4iechZCN+4anEaFp3WLZWcjNIa8vWgCXXsb9CHEsB1keyQuF
	vKsiBj1IpFTgMqAC69nHZsN0QApkKVIVJ3BqhK+I++nZuuBlNGNy3lRUx8ws4dKDB2Pmea
	1cDsJX+qmDW3xIGB7JNo7r5PZU9cbeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765855017; a=rsa-sha256;
	cv=none;
	b=zTlK03AX5K9loIMSzL3QYblq3MZHP7amnPB9Xvl1jUdK4SQv616G5h9UWWgxmkdcPYoF1O
	czjWblW0uHxJYZ83aaq15dpU4XGocw4R0Jebg2k0bLFELGGSeHrzptZZ7xLTGy/fF0q5Qf
	iuOrF8y1pkJIS+dPPZejSjnj1w4qOFg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ARbq8qqQ;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0d06cfa93so36145ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765855016; x=1766459816; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ca7PkbgKDCo99o9sSDTSFk6+AACGhMSrOCn0rGl+w30=;
        b=ARbq8qqQZcgno8l0MO6JU88PtAleOR/9Sgb+aezn+lCDGLB98hxrGMfMSZfsnX6ZA0
         F7WGHz5+8oLfDBGt//BMBQUAPeiW+ngwJjRZlcO5WT1rQzepHyosvgQVPsAZ6DoQs0S7
         pCgvPI3AzRU1wK/TVEKKTnHPDh1wLGxCkivdK71UymV4oAfUjY+afe3zOQ1HDh7+7G9F
         JBFmKejjBT8CcKSaThhMkrMZ7qeBHro8h8ZpAAxteG8KkWyvbxMXeSml1877BzwCuJJv
         JkAtkpz7arudEtwwKy/xW7rhNc4rnekk3UEl2jazpzhUkcDwEbBhd5/cPQHUY9vhJEjp
         bZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765855016; x=1766459816;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ca7PkbgKDCo99o9sSDTSFk6+AACGhMSrOCn0rGl+w30=;
        b=PFms8Zney6GGfcUtS9hZFkz921SDw7bCNTyNTT6EcL8iLlAkLDgLkPHmkqC0NnYvJ7
         hduaKvp3Fs66RrnoxftDWvwHH3jMl+DsF9DKPF4ifTQhQ1yINpS0xaU5zVwpPHKPCu2b
         BiST0SPto5xMEp1/wjDPBYaQ0Pr3CDmKTroYHu8DsFQ1IkEagGwqlyOaykw8qczzNeA0
         AXyWXLhvxOY6st1XagWZhvb3B3gG5ZQgQC4cJeecLuTS/D17JA7G1wOB8PJ+x9Hw84m/
         OpOdLw3LLsdQrxlSAODcZbpo2t6s/Ehu2MM/pj2b0vK25xZ8OwuqpEbweQ/1nKWy6dwJ
         gZGQ==
X-Gm-Message-State: AOJu0YyBLa4R67To9ZkKjZ44eQygVqyUcTa3z9eHGMerLGwOk99QTbRU
	5QHdHvcxT+HM0oS1RELK3YMssLh7oDYcXdsYJ+vVQycYINA5MZI1L/jUlzJUDw7POA==
X-Gm-Gg: AY/fxX766/ixUft/2OU2Gt7wF5/9coM7kzWxnl0uBXbpvkOKOM+Z0/eRojZhFn9nMbY
	QPUCJpQ/L9iSGTqj+B5GsDyi19W25oi+9bzQMt0v4tbWuIg5MB2NsLAgYr5bNpEvPFfJXSWfHMN
	IJRRjdVBet9Tg4AoF3nDPASp+6vqmkR/P2FcRPKXyOz1klZGsJBwWtNuB0ki70eSWJTJmuKl0I4
	teDwolpb627hTvBTOswLzrLq6Ha+IX4yP+61J4Cje235CEyPXVYiRMimcgvw41Ht2FrhsdSzkYM
	xvcnUQ+n2gEwhZVHgmEWyPvZBp+/kMf4wkjHe889B8InKiRm4EoITFvIKaLPUsGEULVv1riOHxb
	8kpXsAD2yT2YpxFCuJnzDCvSvQ5G7rlZWPCI9/My9twlkE4El0+YUuEM/JOv49JmyVNklFDg8C6
	4vrsf9Kge28LR7RqF1Jata1pJPBe7WVWW3prsJhAjcwgO948+ow4Hl38Spt46vEfzNR852fBN3i
	02jn17DNhDRNhPETMspR269FHF9fygZ76slkw8=
X-Google-Smtp-Source: AGHT+IEBMdRQjyENlZeBvdE/4sIPReBAvutjlw5SkrJlVpP595t9zcGyxdbVkTWjloAVjdHnlSi8yw==
X-Received: by 2002:a17:903:985:b0:291:6858:ee60 with SMTP id d9443c01a7336-2a13e0de850mr171525ad.4.1765855015939;
        Mon, 15 Dec 2025 19:16:55 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:5be1:2ef0:f859:598] ([2a00:79e0:2eb0:8:5be1:2ef0:f859:598])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d50f9fsm145589085ad.44.2025.12.15.19.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 19:16:55 -0800 (PST)
Date: Mon, 15 Dec 2025 19:16:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from December 4, 2025
Message-ID: <ccabd163-dac2-ea2f-257b-05011fe00c09@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: cdotfpwxs4sg43qjnggrp15cijuqcq4s
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91A6B1C0012
X-Rspam-User: 
X-HE-Tag: 1765855017-245564
X-HE-Meta: U2FsdGVkX19NQ6uU48TneM4VAFzcSUhB2YLiLEihai5NHDXDPGvsZnGjWGI5iJ+cntgTOUukrBttUNGap+grFRe4s2dyLQQNEJsg5AEwLRc7oBqfAGAje/qlh2dmVHjWNKEh3jwAR6DNHjxBbPJ3kLAtA50oTuCQJsZyrNU0qB6hB1OU70GppyLEDhGe8ooCvlUe3zRcDSoXUozecVwN90SOjOTnfd6wHWfFdaF2X43f+uNs7D1KLTUdWQGwJEESsugx+Gp78PQwlK5UJVKRKO0JAvoXYjqwDaWWPddaib5y/1t5fHZk1b09YTEsku+GusQHj9O9YlAGZBMqXAbjDgXzGMUcmHBDNxykPJS7HafURa+swXvWpmOQ4+f5GqaQLKh86SvP+oJIwJxz2cRrQH9d0U+Dx81lLOvn1DmoTfyHW85eJkjkoLDwEmHgBD9TMDTa86Sxu8ofwUru0Pw60sedvKI62mvgMdP/4usHn8ADDT7hkEu71XdQJ7bO1RRvL7xP+Bb1bpSV/r1RbsBVIcxLJt2mTgdLcHi5G+xHecZV8cyyDEt9ItL6KTIbT48nlxJUXVs7OVjACIet6kBx8BxBdRFRsFDfnvR+06fRBgVSfl89ZUaJm/OXS1vTZ1esOxYOGKfIn0Os0/o38ISr3OtsCpL3J1I9Qy512Gwcuc5agLUaa37i0A0jNrJx1JhuvvJ4fDmRGOsoCzuZXAT07OAOCZzZ55li3hU1oG+VGVegnslCQS5aYXNd2W3SNApaLXntWv3RzomO0RQ+s4w/z2589dadLypXnSIfVYMZc0A8W2ZNI16l8200WtBFIbc9nlaihfiYIewgtIK0YarPBtrhx+aqIKpZP1bvBxTlKpKKxqjNHWO1Jf1qdbc7xvkMa2MT1ZxlmYUX9EnT5mgSFroZ0Hwl0/XC9QoXXrrBrNHm/KsZqOibFol8gbY+uLwaLOks95QNexCkHKtKjY+
 8VL49WRo
 saO24T+6vI5bjR5vUStZ4ItgaZ6kHT+Gl6EWDkYEYDwP0yWQxhtWBuGIynPy86KfyBgEucer4SFWVqB2PYe46aucE5Sc5xvcZPuH4kZpNQHCkIj3juooJ8bDZ3Fh8Szj+rHJiOpkJ2dAKa+PBSpUGwgLdW3GsF6L7a7GOn5diX7VD5q3OGBdmSNxKfeBL+B6V9BuAYniI2aCEYYOH7FJh18ekIUz0ssXK1AUUh3pb6tSNiyuQvpU6w67defziSTKHjh8EwJytsIgE0qc2JaRVyACCFi18meFDuEgr8DYunqEQEnSvZ9HXnYsde4U18TvLtVOP1zi4Q7UZaOtiz5NBkre3SIF4syUXAnZMUj07aMfzIZgVmXmfhz+Y+A2D2hn3jQecBk5Gsc2FDQSJCm3Dp6JuXpvqvJmDcTNwu0hovmWMjgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, December 4.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
Bharata updated that he is ready to post v4 of his series with two main 
changes: per section indicator for hotness, which reduces the effort 
required for kmigrated, and then folio_mark_accessed() that shows good 
results in initial testing.  Bharata is also working on getting the right 
configuration for redis-memtier to ensure we are moving memory back and 
forth for promotion and demotion.

Discussing the consolidation of tunables, the current plan was to ensure 
that these live under sysfs.  There was discussion about doing this in 
debugfs first, but the API should be solidified enough by the time of 
upstream inclusion that this won't be necessary.

----->o-----
I pivoted the discussion to talk about single threaded vs multi threaded 
promotion.  Wei Xu noted that we likely need more than one thread, 
probably at least one per NUMA node.  He said the memory bandwidth 
contention was so severe that promotion was very reduced.  Hardware assist 
can help, and so can memory bandwidth QoS can help, but another option is 
also multi threaded promotions.  Jonathan Cameron asked if multiple 
threads were being used for QoS; Wei said that by moving the memory off 
the low tier that we are shifting the bandwidth elsewhere.  The ideal 
scenario, Wei said, was to ensure that hardware based memory bandwidth QoS 
would ensure that the promotion threads can make steady progress.

Gregory suggested this may be a transient factor, we've had the discussion 
before about how aggressive tiering should be to improve overall latency.  
Moving things as fast as possible may not always be the desired effect, 
the goal is to converge on stability so you may not maximize bandwidth to 
balance memory but rather eventually reach an ideal steady state.  Wei 
shared that in some cases this was as limited as <100MB/s for promotion as 
a result of bandwidth saturation.  Gregory asked how realistic of a 
scenario this actually is because the fact that we have gotten into this 
situation is already problematic: the only scenario whre this "should" 
happen is if the DRAM tier bandwidth is already capped and the amount of 
hot memory exceeds the DRAM tier capacity in which case we would have 
thrashing.  The goal is to ensure this scenario doesn't happen at all.

Jonathan said boosting the migration threads may not be the ultimate 
solution, but rather reducing the workload that is using all the bandwidth 
from being scheduled.  Wei believed that a single threaded promotion 
thread could still be a bottleneck.  Gregory suggested that 100MB/s 
promotion may not be too slow, the goal is to eventually get there but not 
by promoting memory over a very short window -- if we promote as fast as 
possible, we could find that memory does not remain hot in which case the 
promotion may not have been justified.

----->o-----
We shifted to discussing about workloads that can be used for 
experimentation.  Gregory suggested we reached critical mass on the topic 
such that we would really benefit from production data or actual 
deployments.  He took the AI to do this, although admittedly it may take 
some time.

Wei had been working primarily with memcached although production data was 
not imminent.

----->o-----
Next meeting will be on Thursday, December 18 at 8:30am PST (UTC-8),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:
 - updates on Bharata's RFC v4 with new benchmarks and consolidation of
   tunables
 - continued discussion on memory overheads used to save the memory
   hotness state and the list of promotion targets
 - workloads to use as the industry standard beyond just memcache, such as
   redis
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
 - update on non-temporal stores enlightenment for memory tiering
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace, including for memory compaction

Please let me know if you'd like to propose additional topics for
discussion, thank you!

