Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5069ECA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 02:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD466B000E; Wed, 27 Aug 2025 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4586B0022; Wed, 27 Aug 2025 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9F66B0024; Wed, 27 Aug 2025 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363836B000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:53:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 934C5BC377
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:53:12 +0000 (UTC)
X-FDA: 83824644624.13.DC03F80
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id D731F8000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:53:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P8zvFPC9;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756349590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0Qono3m1/UBJQCBl9rW8ABIa3YMrE2/xeKFUpDB0joU=;
	b=vb0zNxb7ooR31p6tla6PXcteK5kMRfvp0KT6hr3jAAI7hUMHkpZDR2a30dkA/I7dojn2zX
	IblNf0JuSUyWUsMw0DonguJzP5M3kRpjykF2N6fe2smFsftTZ6lsIH9kVZ6f4gg2oKAbva
	oIWaVo3d8IpK7M4JKTJrkcwuOIUfA90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756349590; a=rsa-sha256;
	cv=none;
	b=NpO5f/P+InxPkSAMEFMxjEtRcp+TCJk0l3qt0y3kk2eNu7XPzhASvTQgZkfP2EXTfInl7U
	u+XxwnUMfWkoXDprHbi4zz9tOCSrfaXMJoLlzQK4DeQ6zXErkWcjW1o+qk8uUIaotBNS/f
	uCkWZ70KrosUiKsbSJXkJZ/tJJKhUsY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P8zvFPC9;
	spf=pass (imf30.hostedemail.com: domain of rientjes@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-248e07d2a0eso6745ad.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756349589; x=1756954389; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0Qono3m1/UBJQCBl9rW8ABIa3YMrE2/xeKFUpDB0joU=;
        b=P8zvFPC9JLmaq0phU8Hbl4HGZyBqFIx0gtnTVvZvmR2kUerLRbS1k3AipS+nJMSSxi
         67aEWbqhLB8A0PxTgZOp+ygfrRwSjD40iI/69F6lEhdb3ZItRdAQqjeCX1NUGTKhugQF
         42j0OctOXOqWAdznHEHu6ddwFWCdTPIsbm/A6cX17ugJoBq3rIVwMZYdLMackAC5twiT
         brKX3gOIrpQAjWSQbaJ+VtN1tM/PJT8m+4Tc5u2UEveFDqWumHWzGcK3ZeRJCYc2NJdg
         HftxAkuNr0RAA3ajjlbSae0CNR1MUpF8//hk8pA7KpjBMCJXPuyINy2JeZf+2ySNYB31
         jllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756349589; x=1756954389;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Qono3m1/UBJQCBl9rW8ABIa3YMrE2/xeKFUpDB0joU=;
        b=a4z+1dxCLPKZoaTatw0SCV4xmpTc4/y4K3xijrOquYo6s76Ef9xCHNj7vS4b54CVSh
         naYLP8ADDS0Je9iG3LoMPSXhlYF3+rxFW3RHqyb8kZUl7e4F4aOBiiVJaQXSm5gO3KWG
         2+MAMtQtn1txAxEMA7Lv7boCQVQLI8dVesV4D9m9Lf7fz1qiJEzjUISk0AP9b0OgIFPB
         x/rjFop1r8RRBn3AU0V1F63id8fyQCZVZCSq+Wk5eXOAhi9y0JNzej1ws0DngR0JTez+
         3FOTcuqFPzqV+wYMlftQ9vLFEvw5dqspD5XPfACikEFjmXvxC2p3bCgEPhT+7S8riOl/
         UQZw==
X-Gm-Message-State: AOJu0YyxeswGLZYvWPpszRbZ78tRKwmejIBU2Whtq75e1wzfT/lKmnnH
	UI0hzFUmkLaaUsUBA6ZPmXr409UBrC4i8jkIN6jNdDYTtHDM9cJQqRUZ9uuX05vA3Q==
X-Gm-Gg: ASbGnct4q/g86zHkHB4x7uRuEF9jB2PlntkRKmYQ98ILClzP1lpwRsDeMIzdD3uifS9
	HIbCA65kinD66qrzWAIDn86P/p1ENOpTGMIrojjSddQswTH3ep4ng9eFIpdWzB5rDJlzyKty6OS
	5ohYeUgJoHjaB7E1LiUWOIW+y8ezyiUkkIs7eyJSJeknswIPetZNPf2k8hpX4iGyG1ZZglITGo2
	59Ejr4kNPCbhXLHYgGC2wG2BauHMTTgPgFxg+fTUO2hIkRNFzg6lS++uQyuxo7ySBTQ1324ioVm
	ErtLi8J65a6r1L3gVdQ12FfgHZgLHXpaIu4fW9iW9LaI9j8/tcA5pg/cAtLtaDAvyhsLNq/Bztj
	sngCeRwRPoNrxBdTWwzKzAw80ZUDckZtBZQ7S7BGouXePL6aDhxZBwE1DdTA9+APRRenPC2BE7H
	XsctsVS3FGn4fAQ/R+mndOcG1HON4AypTeQ3RLO8xbjbyHBFmRIuQRxtKeBLcrzXdSVA==
X-Google-Smtp-Source: AGHT+IEPLOVpSo1wCdrR+6nPDBS6/1weh6x049j3TlxbtamIjO+pnM0VMM8/z91Qqesh9yYyeJLYRA==
X-Received: by 2002:a17:903:41cb:b0:240:6076:20cd with SMTP id d9443c01a7336-2486399e426mr11754575ad.15.1756349589280;
        Wed, 27 Aug 2025 19:53:09 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:cf42:adc9:e68a:a01e] ([2a00:79e0:2eb0:8:cf42:adc9:e68a:a01e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77054bb0c46sm11592031b3a.41.2025.08.27.19.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 19:53:08 -0700 (PDT)
Date: Wed, 27 Aug 2025 19:53:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
    Gregory Price <gourry@gourry.net>, 
    Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>, 
    "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
    Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
    Yiannis Nikolakopoulos <yiannis@zptcorp.com>, Zi Yan <ziy@nvidia.com>
cc: linux-mm@kvack.org
Subject: [Linux Memory Hotness and Promotion] Notes from August 14, 2025
Message-ID: <fc0143a1-568f-f90c-9422-e642b3c0b515@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D731F8000E
X-Stat-Signature: upjqwe1bqskhjyuknck1hwka17y8tnf1
X-Rspam-User: 
X-HE-Tag: 1756349590-398807
X-HE-Meta: U2FsdGVkX1+vhKnTcCdkjiwB5fuXuQcqmDVwESt2dOLhd4w0aQcGZ6f2z6T9bLAC4u0Hnjqor92j6jnM8WaqKhioE9CG37z2KhNC29V2RTHNfWTDRyHK4Rz6FrY73tmXKjtV8zB0KCF/x1GldulptguShshmHfYrchkTg4e0C8Bk01g8isbGRvxPZy/F6IY6Zjk4tehWhpVeXK7wJWjVoE3YIVOHMQZhmxY0QBR6JUysm9HnJa5GKean3/OFKv1CzkF3K+fAYZ0JrSMaSifBCTKn0FAxig+wHA7gmyqF5zu1fCCiVSUPVzNXVk14CsM32F3UlmLWL/iJJYuG/LbAi4Q3WI/tOX66HBXPH7JAvojE9KKobCQGdaO0DF0QPgABDpd+O8UL/ey4b2+IA4DNMWaJUCqzWrRfORfdfTw1/vBJ6Z7r2QdciUF/v3a2bpKHzNDt9+KdJkiG9UrVIV6suYMk95/dfgPW0YtuK+IezdRysavyR8i2a9+z9VSkAO6uz7vwI5ixtRLDnZ7kiqe7ClAh0omVJmhjuC99GP0M7qMrCfyNCdAFFcbznvxYiE8zYvkyGVm/wWd+vZhWjcK/sLnqWa5Yp+fb+ttYci9ZSmm9at3rb6Lf5H+ft6wKvBt889u28zE/KOXvPC4khwyYsdXDK5kP9016g5VRDIA+a7aYgsIc+RSm6ZtqHYYrbzSeTtmumwFN4x+m+ehhkBScBrgt+DtN/MsoQJXZK9KJipT6BPQqTVEussLU3XmiD6vWufrtKJ2CQZjXxBFySXGv9Z75LNzeDtpas2wnCKChmbiMVhuy4LwUBfVgrFbhw/dhxIwTc8XF3moQM/hGcquRQIcoAQrYX1w+uQdabNNo7N5de8WkS3wrvq4Ri9mprqfOQ3mjv1ZAY1VerQCCp1z48rNPX/gika8tetau2B3SUPAW5M8R6jsnfsrP2ArKPPe05UG5jsCSqpQxMQFjngF
 5JywP/zC
 QO6QKz59E+lVRj603DXuut9aEaAsn3E9sCczU/1RcwFExVaRz0lUOQ0KuvVumEC7j5toA0It3PFSPJ4EYiiwSop/DQCFdzo37J0G3jjuZKnlGFIJAVFTXx6OcjaNJf7Vvyj22dhSv5Ik+X0TZLn3HXcQYdWrD11+ZK/ICLPGlbgKDIIR79YQJpBq5VLcMKO+8VO9J5GI6elOxecXVUa0Pxh01C3GUGv3Gc3j9h8E1LqadaKoiVi4oP70T8pX0ZtGUwwdX7KczPhU8q7xB0EDRZVMw72zRtCvnQFff7uDPyhL+aGjzcwydPqJ88sHsXzD2w6y1ULelOWkvxLzcBLPG+gzdVYd99etZ4eELwAQFMoBu8V/DYrFzOb1rfK1yV9yGsJc3PmNQ0sKpJc6MgsyfVcpQpqWbp95swkJ/FGVbuA90ihhbXHPRXO4JG5HTAO8Ol8/+uZhY6Db8N2COz1NtLd3xJAiotFJ0OSWC8m0jjiJbBtYrJjtoGqYfzYopIoXHP7A8AwQ0d6RYwTTXxsssPyhkbQk9Nxw+ppaciyHFPUqajCLF1K+cnTUhNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everybody,

Here are the notes from the last Linux Memory Hotness and Promotion call
that happened on Thursday, August 14.  Thanks to everybody who was 
involved!

These notes are intended to bring people up to speed who could not attend 
the call as well as keep the conversation going in between meetings.

----->o-----
I asked about the current status of the single source of truth for page
hotness and then kmigrated.  Bharata noted that he had recently sent the
latest revision of the series[1], which includes a lot of cleanups and
integrates both IBS driver and klruscand as sources of hotness
information.

The single source of truth for page hotness information was also renamed,
but kmigrated was then renamed to kpromoted (it was only responsible for
promotion of memory from lower tiers).

Raghu also that he posted the latest revision of kscand[2] and was
interested in discussing after another round of code reviews.  We
discussed integration of the slowtier page promotion based on PTE A bit
series and its integration into the single source of hotness information.
It's been experimented with, but the integration hasn't been done yet
until later alignment.

Raghu clarified that his series could be standalone and integrated later
when needed.  The scanning and migration part are completely decoupled;
consuming the hotness information was still a work in progress and could
change over time.

----->o-----
Kinsey Ho updated on the status of klruscand.  As this was a proof of
concept, the next step was to clean up the code and then try it internally
before proposing it for integration upstream.  Wei Xu noted that this was
a proof of concept to show that MGLRU could be used for PTE scanning for
promotion purposes.

Kinsey updated that he planned on sharing the latest series upstream by
mid September.  AMD, as using this as a reference implementation, could
continue to integrate this for an RFC patch series as an additional proof
of concept.

----->o-----
Bharata noted that during scanning of memory with Raghu's series, a good
estimate of the target node id could be derived which was very valuable.
All of the ratelimiting support should likely be part of Bharata's series
as the one controlling promotion.

Raghu agreed that the migration part should be combined betwee the two
patch series.  Raghu noted his series included per-mm throttling that
could be integrated.  To summarize, Bharata noted that the scanning part
and optimizations for target node id detection from Raghu's patches would
drive the common infrastructure that Bharata was developing for
migration (to include things like ratelimiting).

Bharata asked Kinsey how the target node id would be derived from
klruscand.  Kinsey noted that this was still an open question.

Jonathan Cameron asked why don't we just use a page fault hint for the
super hot pages that we want to promote.  For example, once we've decided
that we want to promote pages, just invalidate the ptes and wait for a
page fault (since they are hot, this will happen very soon).  Wei noted
there would be pros and cons to this and one of the cons would be that we
need to take a page fault.

----->o-----
SeongJae Park noted similarities in the DAMON design which supports
multiple sources of page hotness information (the low level access
collection and a middle layer that would control over the overhead).  He
is currently working on hint faults: the access bit does not include the
cpu information that the memory is being accessed from.  He's using NUMA
hint faults for this and discovered that it is very effective.  He is
trying to abstract this better in the Linux kernel where it can be used
for multiple use cases including DAMON, NUMA Balancing, and kpromoted.

SJ asked about the timelines for leveraging NUMA hint faults as part of
kpromoted.  Bharata referred to his kmigrated patch series where there
was a proof of concept for separating out the migration part in batched
and async modes for NUMA Balancing.  He experimented with this for
kpromoted but it's not yet posted.  His goal is to leverage NUMAB=2 to
feed into kmigrated.

----->o-----
Next meeting will be on Thursday, August 28 at 8:30am PDT (UTC-7),
everybody is welcome: https://meet.google.com/jak-ytdx-hnm

Topics for the next meeting:

 - update on Bharata's subsystem for hot page detection and promotion
   after latest series of changes were posted, including promotion
   ratelimiting
 - discuss Raghu's slowtier page promotion based on PTE A bit approach
   and any timelines for integration into the above to hand-off the
   promotion work
 - update from Bharata on integration of NUMA Balancing memory tiering
   support into kmigrated
 - update on status of sharing the cleanup of klruscand in mid September
 - new topic: discuss leveraging non-temporal stores to migrate memory to
   save on memory bandwidth
 - enlightening migrate_pages() for hardware assists and how this work
   will be charged to userspace
 - update on sharing Google approach for both to overlap the shared goals
   and converge where possible
 - discuss proactive demotion interface as an extension to memory.reclaim
 - discuss overall testing and benchmarking methodology for various
   approaches as we go along
   + minimal viable infrastructure, testing workloads, and metrics of
     interest to collect

Please let me know if you'd like to propose additional topics for
discussion, thank you!

[1] https://marc.info/?l=linux-kernel&m=175517926006575&w=2
[2]
https://lore.kernel.org/linux-mm/20250814153307.1553061-1-raghavendra.kt@amd.com/T/#t

