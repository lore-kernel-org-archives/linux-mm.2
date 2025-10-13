Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BE8CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 19:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3B58E003D; Mon, 13 Oct 2025 15:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783D98E0009; Mon, 13 Oct 2025 15:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C788E003D; Mon, 13 Oct 2025 15:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0898E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:08:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13B01BA511
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:16 +0000 (UTC)
X-FDA: 83994026592.06.D42799A
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 79D0340009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l4BRYaqy;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760382494; a=rsa-sha256;
	cv=none;
	b=YJSdUlLYArIVzKZfboABOoNey/4IlrI3nNdaHmCMBEv1TgirlWZNvUBNbR3ihOQZ/R9qdn
	xl2R2JZB1zf9eEV7paXssjLl9tGcRHmglOAPvwsW5g3M+/E6TNH2sAxXm1RTjBJhqFyNv0
	pAjOAI1FvFGJQRamVS+mI5i0SR64vmA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l4BRYaqy;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760382494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ujdfIo/LIiujs0fZMnOKsR1U8QJjd2WFtcnuvuesTGA=;
	b=paPEdmJz8XwMUJfYgragXlSyJ7KkyPqY3YZFVPDIKFnX0Kq6NXUWiipjKYki4eamPV5VBR
	sXkDI/9qK32Nif8gc4v5WK/gNDUd1qnC7OHvheCVmHQJquym7SxPk6Lu+U/ueyiN/s1Rtt
	IzeInHkG5LKoTILSQUHc4owlA9cmGug=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-743ba48eb71so69660417b3.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760382493; x=1760987293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ujdfIo/LIiujs0fZMnOKsR1U8QJjd2WFtcnuvuesTGA=;
        b=l4BRYaqyzoE33VFepB9POlf5WIEE63Ofm6RnhmCNs7naDBv2vm/9L91e5LNHSZM5Bl
         bh7iI3tgOWN/v1MHchgvVvoph0+rV5yf5yJ/x+PW58JEdl5qROSVCu/rhim1Nyo++Zkj
         hCTwK82KOjO5umYD1V8KtnoWvgTMsY2Uj2HKxGv1j2NPaPc6tXBsJfF9EEXcYarpatTa
         q8bz8/+JBOtLENirygkHBs45FNtZkUhyAOzkBQskt0J+nu3yitWUgf9SpD9RZtZ+F5+f
         OIp0OgQvNuz32pzONdCxUnn1NjMJSJH1gsfjlPhSCyUE+/bR2Jk9l0R6YqbOvsoG3q63
         CCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382493; x=1760987293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujdfIo/LIiujs0fZMnOKsR1U8QJjd2WFtcnuvuesTGA=;
        b=Sh05BH3Y3mzvlRg5ucjJrxQfSZUz2ggxiogXL8SFqq0a/sCLDQBftRvuSVaWjkp+nc
         9c2fpZWxObx8z/29pDk3UZic/4Dxf68/+gNMh4iuiHMF/M4JXYaGJbqiPwveT6bLhBMx
         56IJuT5TUoRhY+mg1AsZk3bJjDJndPeZ0SjT7VYCNLpDJHq7xiSNGnAFkYP/c62aMBQE
         F4IUupdTSaFeUppoUcTqXiZwpGlMk/Zrf1elCGrIVRvBkXYCL4E6n/A7FdMfGug7z8j6
         HhFvDrla3quXlUnS3G7/oUvA2GShEeEZJgUpi7WliVowANqTm/W8uaABG2AWcsklBhug
         UArQ==
X-Forwarded-Encrypted: i=1; AJvYcCXY1Fvc3pwhT+f4GqfEnGL953YPDw8LbTapryD5j2T0GLsaAK/JZLQX3DwHdGlSdrxTeDYA9nv5mg==@kvack.org
X-Gm-Message-State: AOJu0YwFQlmDaqqpCqrdBP6QlFvmedNt04/GMEL42X+E4pjVMBJc+Tow
	z19lMQOCKMcuF4n4zOScV0SukwW+lQWa7k/dGfvqilijxJYBxgY3gMGo
X-Gm-Gg: ASbGnctkkorQO6Ijga2wh3M9+ww6A23uf8iKTPOpYOGQ1xCWcyT8slHAoWNea5hVwtM
	bw44I8JZ4zxJo5C9fQYb5JB48U5N4l2zriJznImAL+tQ1nTne2rh8v8AZiCh4Hs4vUWrGnxXUGn
	ufURKR5n4BGCUc56MHOpxdttV18ZvHk5VpMeV4qTE+k97F/MjM/e1kwZJsRLYWd0xlWNPGR7bfs
	RNpFQKjHGUs2AY0TLk6i4GRSn2sGrrwgVThePCc/Dm0SiQbX6ZH4SW5nxgJ9Apc0cPre0gh/9iT
	d4Y3uxsDgIR0M7pEu/mqd3RirWRGmcHcc726lEk6ffpXuuxC+g5GMPSHJ+06XIl31vlteH2QeJS
	NWMt8ITxJINMyGrds02+OuWa9LoRXVnxpWlyzkurtWIJneQ9W00PgzLiYw/9ctgJ9LLtsIsd+EF
	UnScH6tGP5rM5oNobD4w==
X-Google-Smtp-Source: AGHT+IFNLr4wMsQCGrgyslhpHaWPtiAF3PRyiV2k7WpU2zBPgMgdftZMwasj706Op9vL79MYJUvfrw==
X-Received: by 2002:a05:690e:110:b0:636:2079:186e with SMTP id 956f58d0204a3-63ccc3e19bemr15520473d50.5.1760382493448;
        Mon, 13 Oct 2025 12:08:13 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:7::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-781465e0309sm2746337b3.37.2025.10.13.12.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 12:08:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v4 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Mon, 13 Oct 2025 12:08:08 -0700
Message-ID: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nkh5qpuxga1ntyznid3robo7rizi3k4q
X-Rspamd-Queue-Id: 79D0340009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760382494-265488
X-HE-Meta: U2FsdGVkX19FVgiCtW2m5qvgG2mhybmVfQtDg0gqaYIj8IrJ+pbo9TtHgTfdtTCFnFZG2hzgfUNJBtQpMS4o29QWTlFfqBLj/VNEKtYx6Vc6DpYT7q4+rpp2Gc8XY7k6JGl5OB5d9iZs6Q+qONAFIIpuGGN/YAp/pahK3TIEkCHygdjlpR0iZxCC/s38al7LsU9OPBnHp79G80cC7nFmPphMmEHuM5JLQDyPWkczfI46eTkO5y7L4aA8RvdGonW7OF/DQ/WTCU3I2sgSilIwYm83VrGqh5X5akKq5s/OA0dtrZ0habPRgl0xomOyQOXbelyQYHfT/nu/wsxwHruOLP+b4e/odxyV5frJ0TKCKIz8KDq/7k0AOtvAknMcgA37C2mgzhFZOw+yYnCB1O3ON7adtB6GcuJxdy6nBUVMEQIlyOShNakaIwyP0ajSH+DX5lsI1szYKHHxJvSJnzqhX1KaT6uB5wuyM9fKn14a53VzxftoY+vzat8Zn4gbfZ93d0YSMl/pw9qc9lp9Odg0RH3dmBwMSEaKccilVTC3wFqou//a30fUBGOh2bAAYKkWlMZHn6O+CgeFj9ipH82CoLTX3p2tjENl1pOVVG/8HFu4kkDLZ7SiIIx6t8dtsnMDbCChw+LEXLr30bO+NNcT1DcgkgU4TWJgvPZn9mB5Ucg9ynOhG5LMuq/wnfGGgQ94J1wR5aYUcvk0l+BmznDq8CbX0bKLaP9OS4NbQg9MRf0ev3HYEfhuaPU3IORUThY+dt9xzt12yP78E+XeWEX2PWKW6w30S6ny0Bzp8IW1EY/TV7oUSgc9JW8Pwd5h//NlIZV3jBJm+/5RJE/LpQr6I3yvqD1drq81LPyttnYRDtDX6iHtk9gWiH09MuNzFMYbEpQ6GKc1gSCQw3XzdplARDv1B7FhSCl/S+XJQAv2L7yEaRPBVXsdhOt2imafDaPnNJjSZhe0CzgZSrYnnXL
 2/G89o21
 TqI2tVqXIhWaVfuS6kg4UHr+0eZwSeIera8kZjB/XGGx0geAmq2nNS610rcFXLU9JCG5vjmGacEBYrXLbpiSXpg71zhUJGUKWYlyt7ZzKJ2Vm0Wl0JzD46WEADyA3qnihtalDCGHXMA649YvF0AYkU+aaK0HsgSxtWD1V7ITHzgDimNMXsrxz2TrtpQ==
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

Because free_pcppages_bulk is called with the pcp lock and acquires the zone
lock, relinquishing and reacquiring the locks are only effective when both of
them are broken together (unless the system was built with queued spinlocks).
Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
freeing from its callers instead.

A similar fix has been implemented in the Meta fleet, and we have seen
significantly less softlockups.

Testing
=======
The following are a few synthetic benchmarks, made on three machines. The
first is a large machine with 754GiB memory and 316 processors.
The second is a relatively smaller machine with 251GiB memory and 176
processors. The third and final is the smallest of the three, which has 62GiB
memory and 36 processors.

On all machines, I kick off a kernel build with -j$(nproc).
Negative delta is better (faster compilation).

Large machine (754GiB memory, 316 processors)
make -j$(nproc)
+------------+---------------+-----------+
| Metric (s) | Variation (%) | Delta(%)  |
+------------+---------------+-----------+
| real       |        0.8070 |  - 1.4865 |
| user       |        0.2823 |  + 0.4081 |
| sys        |        5.0267 |  -11.8737 |
+------------+---------------+-----------+

Medium machine (251GiB memory, 176 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.2806 |  +0.0351 |
| user       |        0.0994 |  +0.3170 |
| sys        |        0.6229 |  -0.6277 |
+------------+---------------+----------+

Small machine (62GiB memory, 36 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.1503 |  -2.6585 |
| user       |        0.0431 |  -2.2984 |
| sys        |        0.1870 |  -3.2013 |
+------------+---------------+----------+

Here, variation is the coefficient of variation, i.e. standard deviation / mean.

Based on these results, it seems like there are varying degrees to how much
lock contention this reduces. For the largest and smallest machines that I ran
the tests on, it seems like there is quite some significant reduction. There
is also some performance increases visible from userspace.

Interestingly, the performance gains don't scale with the size of the machine,
but rather there seems to be a dip in the gain there is for the medium-sized
machine.

Changelog
=========
v3 --> v4:
- Patches 1/3 and 2/3 were left untouched, other than adding review tags
  and a small clairification in 2/3 to note impact on the zone lock.
- Patch 3/3 now uses a while loop, instead of a confusing goto statement.
- Patch 3/3 now checks ZONE_BELOW_HIGH once at the end of the function, and
  high is calculated just once as well, before the while loop. Both suggestions
  were made by Vlastimil Babka, to improve readability and to stick more closely
  to the original scope of the function.
- It turns out that omitting the repeated zone flag check and high calculation
  leads to a performance increase for all machine types.
  The cover letter includes the most recent test results.
- I've also included the test results in patch 3/3, so that the numbers are
  there and can be referenced in the commit log in the future as well.

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


base-commit: 53e573001f2b5168f9b65d2b79e9563a3b479c17
-- 
2.47.3

