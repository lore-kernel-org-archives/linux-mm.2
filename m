Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48828CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D038E000A; Wed, 10 Sep 2025 23:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDC78E0001; Wed, 10 Sep 2025 23:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC4C8E000A; Wed, 10 Sep 2025 23:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76EDE8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:36:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CEB216020C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:36:03 +0000 (UTC)
X-FDA: 83875555806.03.460CEE1
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8EFB71C0003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:36:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yuQBEyUa;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757561761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yAdLGU9v/Hxy+X7L4BEbzlUwHpIrCfnTmNR+WljIcPE=;
	b=shFFNRXGX65UeyWdj2y5Ca7WSkQAYV8fFAjQ3CxMmeM4E/971R8cBzPuJ7X37Eq6aRurgD
	fe3rk/p6PM0Q4DVKo1YPr8IUVQsHN9hlEo4NFSgPA/LVV6Ul2wx5+BH9nIeR3dA++o6wZr
	1MlkPLJwEemfVc60J4M4HUUCpHRk33Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yuQBEyUa;
	spf=pass (imf21.hostedemail.com: domain of rientjes@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757561761; a=rsa-sha256;
	cv=none;
	b=OH2vN+Yai6ldECix/Erl7tas6j6dZJKqSIjouTFsm2qo8+bNvUYxCJUluocmPXZ9r/CqOh
	Kjcph5+cYu2fNobluieZX6iiMAxcnc6QhZ7QpG25c3ypfULcJ50xzeoCeh90IetUgzNdax
	99Cv1jkzRCycXyVdEyKxdFBWDZsYI0M=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24cf5bcfb60so93135ad.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757561760; x=1758166560; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yAdLGU9v/Hxy+X7L4BEbzlUwHpIrCfnTmNR+WljIcPE=;
        b=yuQBEyUaW+Zkr2JBSMgneNPhqLzHpTe4GDyVgz30jdcyE79/oiB+lPYf1XJbJ6OOU2
         9W6ukTgcm+7U+Kg1dDbMh7ZFG+XVUaOnLXcUnL8j3fv97iE0DOlNxUs/yb3xbJteuG9d
         cgsoxNktkYca+SxivSVOL9xXrLJrZA870aFr6u8p5Jd/28LRrnqrJA4KGYQqediRdqtq
         3LlXPcFIUHyV2rwv241FXnKhaRTcM4/PMd14zu5AGXwkH7XgJ71yhXs4P1gEAbNO2n05
         UMkDpC6K1+lmMun8U/cZOHj2AbU4Kb+syBrIy5a4NDwTEs8HZnCNZi66ZKlmp7vYV5t4
         VkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757561760; x=1758166560;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yAdLGU9v/Hxy+X7L4BEbzlUwHpIrCfnTmNR+WljIcPE=;
        b=R7J/ORjZIcaqlvCSfApByYpaoiUZVHGBhQj1EYXhxF6oCmm8+V/m4P+v0k89vgzNx6
         oaGS7z9d+Aa8s5XKRn9q9smA4H6J8J3DQbaGnnkwcZ3NnhnHVhmkpF7vtYRAq7tN/oNf
         OY63oSabLiSfwOzqCUkF0DYO4IrCf9kHNcwYsY8QdlHu3qv5+m7QIoaOW1XicsTAOVZl
         f5A6fx5pv/0Vth5d03mkCUg4StJ7LjmnEzfhXPxgRWhLwOEAurkMedCvTih6Aui1+Zv2
         xVTENYU5v3QPyRsM4LrX+uFMyYmuWsCmf2epC6nzH9VplQycELfofUp/91rmtYfZ0FJn
         hEBA==
X-Gm-Message-State: AOJu0YwXZyCA8cs9TYePeh/CXh1M7J6WTQZtv5UtNFb3W900zo7ZLy8I
	yEKmMOT5orfke/WaqXO8TcsxsLAMZzfq9RiPEnOiJ7lb459DX9tAZKJInjpz/MuhP6oRttlhey+
	xiiFmzcek
X-Gm-Gg: ASbGncuQ1zF5urleM/eAI4b1oRY3GOQW0dgQnaTyTSsjhEWK+CmSMPbPLhogwUWIL0D
	NkNTCplJTjF5Ud0MjNoClnuzUVtNmNAuVT8s1Na6haVwWY++VIHgldsT01LCpPydLYLbycxQFf6
	1EV0ZQ2A9OOwORr/4zeMKew5fRPLapJOyCXvwtH9xGnOseykg11S+bSuJHbacUEmXHDC2pgvB6g
	uQX5HKsECW9dXFSE6Z7DRYCz3OWDPw9YPuAICbToEYW6OGB4LzjzaEZY0d0xKTBXzabYASQaOz6
	hGalZno2W+BAXSeD+FF/yNUY9bK6lhDZymTHqHrrwuE3I3j0UeKBpzf7oQgUvtVMD/IemMzo7K2
	mbhfan/HUpHnXyxbQ/bf6m9/6mnRkU3oTeaAwYiToELZRtvJPrWRt8elRP5hY605zrcOVnTRBfR
	YkthmaYfXcWMeWQkU88l1HhcYjBhm77o6vWT679p0P0hQ0eo0ZABZlrkc=
X-Google-Smtp-Source: AGHT+IH1mgWibTUpnMdT40nAQfWMM5ldSo/8lgZlHiXUtSHcR+j70ndu9MkCRi5A/H8y9th0zkPy2g==
X-Received: by 2002:a17:903:1a67:b0:249:2f1e:5d0c with SMTP id d9443c01a7336-25a7eafc3d9mr6991685ad.7.1757561759890;
        Wed, 10 Sep 2025 20:35:59 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:307b:e1ac:2ef4:217e] ([2a00:79e0:2eb0:8:307b:e1ac:2ef4:217e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd61eaa89sm834102a91.2.2025.09.10.20.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 20:35:59 -0700 (PDT)
Date: Wed, 10 Sep 2025 20:35:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from August 28, 2025
Message-ID: <46003e8b-e07a-7ccc-6842-9b5786340691@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 8EFB71C0003
X-Stat-Signature: ugwt74byrhcwufsit8ap5oiuod6cnuph
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757561761-965396
X-HE-Meta: U2FsdGVkX1/0y4FQhXcCzPtcMLqAjxhG3Uwpnz3rCDkDkQZCQtDwWUQfdudN2CBwEX0vXieeGesEG9XYhXFRYC7fICSd1mFzZseKgRoBQLLHemkbZywv6+bQ8VK0526Z5GVw37Y+em2/3RRasGqRtnb5p87fEgHm+0aFLk/JH2m1tWpP1q32SwNZtiOMdR7GOGHyAjW26MpCOrA3woEkV+gb4U1KtPSGwQi+i+vLF/612xX0UgU1ZdTwt+zeMjbeM+ajvVHG8RJNABF1bwxbmyxsfLVMM9rtvY6VP3qQQTpS2p+xKP1HM0OpnhtnRx2Ng2s656gEkJaBGZ0gJFrMi7jN0Hq6LSR+pqI6k/motxnoNh0/dS8y7Mc/XY+pIDFBHWxBn5nxV7CHk6yQM5wHolf85sip8LRy157q8VaPVktUEj89xSNUYj+3ejHARMFbIYcE21l98ccW7N7kamEaD/4QEpaJI+9fW9mEWAtwmio9Rj2KBLupLZJpQ3HVVPbIMjs4G+hN/7QjCNBjHIn9YMIAHfkJqsMtVoFPc8ewcfXXs1oztKU0N3rU6fRYvaERxKEwjHTZ7YgT6kX3/Qa3aAKABkoR5B0ry5SJNDN0f1CdPcd7q5ckRY402su3W0AYnpY+Yn0YIZCmD+8Ba2t3Ir/BJqPXuUZ1PkdYFVBK7VwGO6TlWjBlDaBsfe0UB1WuAsP0Z4ASOZ3JB0LNiuANmZpfrwxdKstEn/oCGoKhGyhsLKmiu4WM7aVznNQlghROMB428cKN+mfr6ZgQ2JZbE8M+scyqHPdd0083+ZkitLaIJzS8KbLEr06knz1NAxEBSCYqR34/va3tjoMg9z4oOblIt/VwhU3BdYV9q7jsTz8q+IbwxeHVeYLKjshnlHVychx3KNaCCgqc5XajAN5K3nmtTsXTXr0b7n4FFvWCtvlg3cptZHUGTg07sevMtbpSW1f28HmgyOxVERsUJ+9
 qtyBcL1L
 lqh4kLc3z3zzxjUVRj6zVWVOssL1pDc8ewxbpD0QdUKRtensE36RF7gkina4UeJri4ZMD9zgwP9SQhas0gcLmZuZvIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, August 28.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I provided the updates from Bharata: he moved the ratelimiting and dynamic
threshold logic from the existing NUMAB=2 to kpromoted, although this
needed to be tested.  Hopeful this would be ready to share by next
meeting.  He further modified NUMAB=2 to just do scanning and hint faults
and then feed the access information into the single source of truth.

He also had updated that IBS, NUMAB=2, and klruscand were now the three
sources of page hotness information available.  Bharata was also planning
for some optimizations to share in two weeks time.

----->o-----
We discussed Raghu's slowtier page promotion based on PTE Accessed bit
scanning.  He said it was still an independent patch series.  Next, he
plans on implementing fallback target nodes for migration.  He's also
planning on a rename to something like kcollector.  After that, the idea
is to integrate into Bharata's patch series.  He suggested a possible API
extension to support things like promoting memory on the second access
(NUMAB).  In the next two weeks, he planned this integration work with
Bharata's series.

Raghu asked for feedback on the current series of patches to be provided
upstream.

Jonathan Cameron talked about IBS equivalents for other architectures
such as ARM[1].  This would be another page hotness source that could be
integrated in the future.

----->o-----
We discussed klruscand from Kinsey Ho.  Kinsey had posted another revision
of that patch series upstream[2] but not yet integrating with Bharata's
series given that RFC had not been posted yesterday.  Asked about the
scope of that series, Kinsey was only planning clean-ups at the time.

Now that the latest Bharata series has been posted, it will be possible to
integrate klruscand further into that.  It could be posted either as one
big integrated patch series or standalone, no strong opinions.

Wei Xu asked if Raghu had ever tested with MGLRU enabled, i.e. handling
the PTE A set and clear.  Raghu said that he is dependent on the idle page
flag.  Raghu suggested experimenting with both approaches and then
deciding the right path forward.  He had been enabling MGLRU but not yet
integrating with his approach.

----->o-----
We shifted to discussing non-temporal stores.  Yiannis noted that he had
some RFC patches for this that he sent over to attendees afterwards.
Yiannis described this as internal patches being used over the past couple
months although it is not yet optimal and doesn't have the right
abstraction level.

Wei Xu shared previous experiences with non-temporal stores and bypassing
caches, especially for demotion paths.  One of the challenges is to tell
the page copy code that we are doing demotions and the lack of
migrate_pages() to have a full end-to-end context that this migration is
for things like demotion.

Raghu said there were additional optimizations that would be available
beyond just non-temporal stores here if we had this enlightenment.

----->o-----
Next meeting will be on Thursday, September 11 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - updates on testing for the NUMAB=2 move to kpromoted, including
   ratelimiting and dynamic threshold logic
 - update on integration of PTE Accessed bit scanning with Bharata's
   series
 - update for integration of klruscand going forward and next steps beyond
   cleanups
 - discussion on non-temporal stores and how to enlighten the promotion or
   demotion logic on top of it
   + discuss testing and benchmarking Yiannis's RFC patch
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - discuss proactive demotion interface as an extension to memory.reclaim
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://gitee.com/openeuler/kernel/pulls/16342
[2] https://marc.info/?l=linux-mm&m=175754854525170&w=2

