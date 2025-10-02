Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9298CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9F38E0002; Thu,  2 Oct 2025 16:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73288E0001; Thu,  2 Oct 2025 16:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961768E0002; Thu,  2 Oct 2025 16:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFCE8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:46:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18FD613B912
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:41 +0000 (UTC)
X-FDA: 83954357802.19.F7E995F
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40C9FA000D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PqxbTT/u";
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759437999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ay/9vezBY6puwDg2MjgpOWz9DbnBpP+YhoVm026fczg=;
	b=5546o58/GVTBHCaSk7ophWMrKJlnN6qLsFJRGkyEEXGQg1yYVunEXewFZKKzRSsUrInPyU
	FiKez0OnYzGK1F1wQRK9J9M930+5TlajyWtuP6VRq4qRkbJy4rJFrj916AdIxtf7dULati
	nIfMiLxLaFfxtYlh7yVOjAfV+TExOXk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="PqxbTT/u";
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759437999; a=rsa-sha256;
	cv=none;
	b=lQklmQFoPe+xJuTQI94MNG9lHv7Eb6T1ORyvuSKj6mfus4Qcm8EXGCsLeocFvWTb5Fjujf
	Hj0tjNUvml/JvdGXNx6/nM59boJXvCxBZHETyAveCw7Y1oKu2fxGU73m+V6XnPznx3NzNU
	Nkk2wMnbLwVVsAA3eslCZkxo/pUCb5Y=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-635355713d9so1596996d50.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 13:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759437998; x=1760042798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ay/9vezBY6puwDg2MjgpOWz9DbnBpP+YhoVm026fczg=;
        b=PqxbTT/uHDZghyPbQ6x8fs5d/olZ1SAaB5QsvhlZdQSla1qhpbg4Nf4puHwnnXVeq7
         nRqb3PpHl6TTdSEgVAXyz0xjFbFet1K0zxi9EKq0KtGlQkphhEthvT3mqs21VPLJPeaX
         JWrobUkly8kXNjjaf84n3BNmDaCGLUnwK2WzwznCZertz8KKVZvGrecI6hbBGh9/qAQn
         +X49Ayz1w1MuG6131uIj2iiJUdEhmzSvEIGO5Qab1OGqVke4+to8LsOUq7WSRiF4faLn
         I0tS14ahpvf5afM97bLTm49YF2wQP/mojHaJE5Ire0q5DKjFRRrVdqT7KxjmugO6cq6B
         Orog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759437998; x=1760042798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ay/9vezBY6puwDg2MjgpOWz9DbnBpP+YhoVm026fczg=;
        b=b9C++Tp3p/BLr5JlimKs84rvsQGzhP/Daoe/vcVHKWsGk90dssZjFUwHD4Lc41bUCG
         w33o68N5grhkpm5AqtKwNsAg+A/xHPGozupkdQVhtuY/s3g35XAa4pAhMfZAAvf53NFt
         JXoFwaJ9wSdh1z6Lp5EAhWpXH4GtUQiUYG7IuAI5T17Sj/ZmNzvKbV0I1kDeH0n2Idek
         /9hqCSNHuyssVyODhjfNUL/Ik4mZDqmstHmxwAeDyAaTRjEf2TdWegbok2EF8xRZXRsa
         j4gXctacGvGbLryxS0prZ4LlId80NMYZhq+FqqbvwuJK8JIxma+qtXQUzur5LoRageCZ
         K6MQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8BwWe6op3MPPZGGSJ4iXXOarC1liA42sPhwXI9BQyvx573gypUooe116dPexNDT0XgwzGC9D5Cg==@kvack.org
X-Gm-Message-State: AOJu0YzGy33e4CslMlJSgoRGYBP2vtR/vlYvnzs9PXcydUhVHvEs9qob
	8VV6wpwFkzuKhjH38z7zG6LpqkI/2t5/LjiwRQadcbxtcK0paEyCoUj4
X-Gm-Gg: ASbGncvlit4V2j+UXI2EOf/piGlqUojwGM7++CRbDqPDbs1o7TIRSoyin57NxCP/vrv
	ZW3VS9Qtyy0iRzuS9rnGHW5p7IawhTGo1AKz51Piy90/6xd7T0T4rdrS/CnJS2UW3kJVXqJWaAZ
	8mjF7v1uuCHPItNeh7wsURC9xfxtjXKxemkXh2aqb72Swbriidr3cM4sQNbryT+MylrnaFEuai9
	cCbq6sHnumC9DQ47qNTSujkxQ7pWFyESOnE8FqE5JzXNxM4bDyGct8F3Djdm3Zc+w/8k71zBc80
	yyLhXfxgX8QhHw+It6k20WOoOBvvhgSWd30R/Uprsl33j0zKRWkaysv2/MM7P/7WGXnbwv7XlsL
	9hwrqpF+aBxiPtaH3mWFUOKF8AaTejNKVp4xxcAdUQEFKxYHmjW5Qt9wxwytltKlusfMPqJaCiJ
	rpGA==
X-Google-Smtp-Source: AGHT+IHpcCTVRqgenU3vW+3sLcFVGrhQQKAHnHEh2WSWX6kMoKdNV+yXAl0xqxgPOXUh0ujYau5cmw==
X-Received: by 2002:a53:d6c9:0:b0:635:4ecd:759f with SMTP id 956f58d0204a3-63b9a0fcb2fmr503983d50.45.1759437998068;
        Thu, 02 Oct 2025 13:46:38 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4d::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63b845a65e4sm1038716d50.10.2025.10.02.13.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 13:46:37 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Hillf Danton <hdanton@sina.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Thu,  2 Oct 2025 13:46:30 -0700
Message-ID: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40C9FA000D
X-Stat-Signature: q3im3r11ffubnp5zpzc4wfnf7scab95h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759437999-64429
X-HE-Meta: U2FsdGVkX1+PSREdrdBA/JxVX/c5r0mNnOm6KqNxdIGtu1xl7JbZvwG3g+5Z6kbCRwDOljRy7Q6jFPxNVsnRcnBd6+DW/5d+ySHnNmaTekO8RdYRmDAk9b7F8xDJ0RijoJ6ncVXbprxBjf9UZXxSPkei1fHEIM2sX24M1GWUvnkA2sqbIKipp/jVsVz03rW5fHLLPZZznS+ikx2gN8B5PYexq2oWRuw9fdrz85M8sUKf/4/9CRsLyLQXnu8hW7ECpVJVE8YeUnySqCzaupN1WEYJmjbEPYOXrrJezcrbpxEhjBapoSP8eq81et6drBnbhyvyPmi7MdUUqdMRLxaYVwSYDKg0hT2YcILjQ9VwkxzFjQvmJQWLEelz2+GCpxdcfz3TCaR9f8459g/fj9e93NXfZXp3gt6GlbOBfe/GfX+qtdJHac8bMJofiZgGFUZvUV1L7kzg8yg1mRuKRGazTRcyNA3ixFXcUn51D3ERBsWwnuAcQIrqsKq4Ubd/7DmArAt/WuP7v7l9nkF4TENbEPSx9LlZ+ashV41Im3Jth7L8WxScQ0ABrsGC/Xrf4ZQiJBF1g6jUESeg+U94axQ85Zy9MEvK1qzdI82Xr/d1r9HI1dW+auPVEIGZ/1hieWO+wq6qx8N8NU9CNniCzY4fY+AXZTB/1yHdFDWWjxkBzO2hyZID8uA/tIsBGBo5U/XdMu95ZKffORl3ixOMxOGxoueGrsyKfOnPiV25bpfOGyyhvF6MABYV6Q687tePb+PJgrQndlOEU5ZNs8GlFbPLRktQ9BcNJEmPm1W7C2TnOWnejT6oAajJ7vgjUfkamoCVkbFvcqCK5bUuCQP/gnECr+1mLf0mLOPBlDXrWunLHRoiYvNtOzHdcfrCn/RCbAnpe1urzcLvKCr42jTsECboVUA8mG1HxzbMz7oepZExR04zigw7XT3QI46RpJStX13RSy5iCNQMQnZySRxeCyW
 xNwMNZyb
 JIfc7zMc1r1YQFBB56rmbrAMpWNfU0J3uja7iTwvMaJ09WgyiIb5vg6IkgPRO8UNJflua803nR1ZEkUhGrVZNo7Gog631ef3tsKc3JtqyDTLGgqxLTzTuU28pFkoQvD22kfgMZvmulnWnLbirTGgSlerxHbY5C+qpq8MliXT7mLIUOa/A6yIkSQXPkbzEH3atqVSI2fYYOx7urB/4FEDgpvTqCTt3ETfo97HRRME5rTGF3bfkKPmWZFNhhm5uf2+sYNzo2gplVY+8QcNkRZRx2UXvHnXRmBDOeWQ0PRZO5CqbhNWon32RYaHfO5qz+KAiHCKAiIUdkV7zPdeD0EqqLIKVx5shFV90Y+5VSE5jugd5fYRQmAMpkQT78YUNMZarXuWU90zHMPZAHSsNBwo/KWaHo1QMeF0ma3NSbBfeu2zqOpjszx5RLJvqSZw7FHkU+5TozOMouKmkG6R6kGZ8yg1E860IgvlLcoRAwFzHy6WGuZUkQdpWIgl2NyqXSnrC6UqyeAqd7apMYw+N2JH79Z/YBvdK2MTfg+TvWnzuytP948ObdkBw81xi9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Motivation & Approach
=====================

While testing workloads with high sustained memory pressure on large machines
in the Meta fleet (1Tb memory, 316 CPUs), we saw an unexpectedly high number
of softlockups. Further investigation showed that the zone lock in
free_pcppages_bulk was being held for a long time, and was called to free
2k+ pages over 100 times just during boot.

This causes starvation in other processes for the zone lock, which can lead
to the system stalling as multiple threads cannot make progress without the
locks. We can see these issues manifesting as warnings:

[ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
[ 4512.604370] rcu:     20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
[ 4512.626401] rcu:              hardirqs   softirqs   csw/system
[ 4512.638793] rcu:      number:        0        145            0
[ 4512.651177] rcu:     cputime:       30      10410          174   ==> 10558(ms)
[ 4512.666657] rcu:     (t=21077 jiffies g=783665 q=1242213 ncpus=316)

While these warnings are benign, they do point to the underlying issue of
lock contention. To prevent starvation in both locks, batch the freeing of
pages using pcp->batch.

Because free_pcppages_bulk is called with both the pcp and zone lock,
relinquishing and reacquiring the locks are only effective when both of them
are broken together (unless the system was built with queued spinlocks).
Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
freeing from its callers instead.

A similar fix has been implemented in the Meta fleet, and we have seen
significantly less softlockups.

Testing
=======
The following are a few synthetic benchmarks, made on two machines. The
first is a large, single-node machine with 754GiB memory and 316 processors.
The second is a relatively smaller single-node machine with 251GiB memory
and 176 processors.

On both machines, I kick off a kernel build with -j$(nproc).
Lower delta is better (faster compilation).

Large machine (754GiB memory, 316 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.4627 |  -1.2627 |
| user       |        0.2281 |  +0.2680 |
| sys        |        4.6345 |  -7.5425 |
+------------+---------------+----------+

Medium machine (251GiB memory, 176 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.2321 |  +0.0888 |
| user       |        0.1730 |  -0.1182 |
| sys        |        0.7680 |  +1.2067 |
+------------+---------------+----------+

Small machine (62GiB memory, 36 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.1920 |  -0.1270 |
| user       |        0.1730 |  -0.0358 |
| sys        |        0.7680 |  +0.9143 |
+------------+---------------+----------+

Here, variation is the coefficient of variation, i.e. standard deviation / mean.

Based on these results, there is definitely some gain to be had when
lock contention is observed in a larger machine, especially if it is running
on one node. It leads to both a measurable decrease in compilation time for
both the real and system times (i.e. relieving lock contention).

For the medium machine, there is negligible regression in real time
(<< coefficient of variation), although it leads to a measurable increase
in the system time.

For the small machine, there is a negligible performance gain in real time,
but has a similar regression to the medium machine.

Despite the regressions (~1%) of system time in the smaller machines, it
seems to be (1) not observable in realtime and (2) is much smaller than the
gain made in the large machine.

Changelog
=========
v2 --> v3:
- Refactored on top of mm-new
- Wordsmithing the cover letter & commit messages to clarify which lock
  is contended, as suggested by Hillf Danton.
- Ran new tests for the cover letter, instead of running stress-ng, I decided
  to compile the kernel which I think will be more reflective of the "default"
  workload that might be run. Also ran on a smaller machines to show the
  expected behavior of this patchset when there is lock contention vs.
  lower lock contention.
- Removed patch 2/4, which would have batched page freeing for
  drain_pages_zone. It is not a good candidate for this series since it is
  called on each CPU in __drain_all_pages.
- Small change in 1/4 to initialize todo, as suggested by Christoph Lameter
- Small change in 1/4 to avoid bit manipulation, as suggested by SeongJae Park.
- Change in 4/4 to handle the case when the thread gets migrated to a different
  CPU during the window between unlocking & reacquiring the pcp lock, as
  suggested by Vlastimil Babka.
- Small change in 4/4 to handle the case when pcp lock could not be acquired
  within the loop in free_unref_folios.

v1 --> v2:
- Reworded cover letter to be more explicit about what kinds of issues
  running processes might face as a result of the existing lock starvation
- Reworded cover letter to be in sections to make it easier to read
- Fixed patch 4/4 to properly store & restore UP flags.
- Re-ran tests, updated the testing results and interpretation

Joshua Hahn (3):
  mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
  mm/page_alloc: Batch page freeing in decay_pcp_high
  mm/page_alloc: Batch page freeing in free_frozen_page_commit

 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     | 83 ++++++++++++++++++++++++++++++++++++---------
 mm/vmstat.c         | 28 ++++++++-------
 3 files changed, 83 insertions(+), 30 deletions(-)


base-commit: 71fffcaf9c5c5eb17f90a8db478586091cd300c5
-- 
2.47.3

