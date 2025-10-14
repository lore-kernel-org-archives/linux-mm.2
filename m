Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4ED3CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 11:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128E78E00E8; Tue, 14 Oct 2025 07:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA498E000D; Tue, 14 Oct 2025 07:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F320E8E00E8; Tue, 14 Oct 2025 07:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC1738E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:30:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BD8711B024
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:30:06 +0000 (UTC)
X-FDA: 83996500812.03.B653FEF
Received: from smtp153-168.sina.com.cn (smtp153-168.sina.com.cn [61.135.153.168])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3444C4000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:30:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=kmq1tHTC;
	spf=pass (imf12.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.168 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760441404; a=rsa-sha256;
	cv=none;
	b=AehmaCXuP4LWsHdOKnQ0mw4lqNYfOsVqx2FqPgLizd5+Ee7f6Qh6dMgUnBQ9Gq74PxN4VT
	UuivVYyexk4x+AnIw+W3Mo4rwfCxF85poxjInz+lCAb42c/9c1gNIt8F6cYn3GKW6zjsLt
	EV+J5Mj0yCjRNtllhE8PHzANU5gLUyE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=kmq1tHTC;
	spf=pass (imf12.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.168 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760441404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuiZZX2bdYokcEIW6becPyXT1zpVn2AQfemG2M9o3UI=;
	b=4zk39KsQxmLAmtEibSN95N2AOVA9wnETJIOnmMNswDRAi+UHGi6SqJtTmVahOZ1UtghBSS
	Vhb/49sdvIbeQW8uz2iLiYG1Cp0yIxbuel+lSRtzE7O+iXgONQZJT8YOAo8ET9TlTXzKQQ
	CPTeuqrWj49Wz5VuwluFRZYWexdVbAI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1760441403;
	bh=XuiZZX2bdYokcEIW6becPyXT1zpVn2AQfemG2M9o3UI=;
	h=From:Subject:Date:Message-ID;
	b=kmq1tHTCxf+63ZmvIhcm1IL/pCrf6IhmpA+TBV0LkhOHzXHKIDhokj3qYNZxkS5q8
	 bebLeqQFN4buzxrwXlCTvORhD1gOlbcUZnxNxE0QqTA0SH4PFCYhWaTKFZ3TfFWRcw
	 S4Q4P4WpOc7EDNaJVXJ6FIX2QXJIF1j+brk6I0AU=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.33) with ESMTP
	id 68EE343400007D1B; Tue, 14 Oct 2025 19:29:58 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8044336685184
X-SMAIL-UIID: FAFC45108EE14A7F85C90DE2B7CC568D-20251014-192958-1
From: Hillf Danton <hdanton@sina.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Tue, 14 Oct 2025 19:29:45 +0800
Message-ID: <20251014112946.8581-1-hdanton@sina.com>
In-Reply-To: <20251013190812.787205-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: p5nceufjtirkcc8fwu8xkg18m91bpi4z
X-Rspamd-Queue-Id: 3444C4000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760441402-102576
X-HE-Meta: U2FsdGVkX1/5Ubdi2WTIHphAxEb1dhIgciFJW/jgtMgET2R1ja8DAK7QBQQxX9vTyIeIslr5hHmVkoocvlN9Gs1AjK+wQFvmrysI/o576Yv8PRbgtvnjrOlnSDEyVCtnMzH9LnFt4y7pKPBN5mCkmDS/RsKH/se9XxsjzivOuFnFAAGToLiTw9PgQDeVvgg6b7hhFBG95F9Zqsb8u1NQg/FrBn2UgZs+TIYofh6BrVl71sF7bUZZ2+ZHSgl1dDqqfApnBULSvBdFhnEUFMEGo4K1aGtw69K4wSixuagW7nL4fvWhkQpSZ+0Y7Nc8QuwzNaODpJGVIEvYR5eNC4S/I/e1TmKSYvsRgrj3agjKpRFWUCcAD9gTxKDlV4egftQMgkohEibhoK8C5D5Rab4AHJOcj5sxFmoq+4I4turDRVlcKf9kzcoEdlldGf32rt64it8667ekyc5rcUKMVkoWBK/eq2OFJ+FZ+48oKUDKOnHT6S30MRCdBCDqJP6yDbohBrW4wmdDOTck6qTmaejFKxwL/OIQz+K/TiE3MKr8CGWLd6OCtbBZgLP/F6MZrbpu336WXjN5jgSQyhgMPZPeAwG/hCpJ5Vf6arkPctamnbxLQqhxtvgKTrT021HRoAorYfJlwNPBOWZz6FUIuhZ7ODk36kJrcG+9uklzcqsUal4en+fhuEi/Mr8c2S0cGERfV1MB/Rs3UPowqm4KOZBZdFnee98eHx4JHypg24YUGfGf/vx6XY/PZPGimjO905CPGYlttVofpbSfKXd/vU0IPh2m9ZTKw1gwrQACveT5hyf0cix2OS97SRViG2vy5lZ1egiHZ+r3rL13UmlcU61aqL6YdjNotRnH8r4ynC5kGMpnIIMPNXbxjVV2u5tWg2ttYnwWWDC9yQb2JFaoOfMF9mCZzcIhBvTtmCmkROuKz/oX2ALsyP2V8cHXQHli9TMGLnmnMkTFnXBS1BvYV2q
 W5Rn5n+8
 ICn2BrzToZAoDGMctwRY6URe6cdUbHklLdfR3KJNzBkea7eaUXXzCthNa1xIdUUhey9IkFQl3Chg5pv9kivAtYphIBlOEiqmZhoIE2r74sYVO0l+h1wmH5mPUpcYHBQYXhgRD8UFscR5vA9/2HxorxFfHtX8dTEoQ2B3pyj7D1AaVA24Fe9000liwfijFBbmizVF5FmlVVU3xaaHYoc0QcGf5MW8Z8Wav9BWfXz5f85RGzWrX2YlXmsq+3hLRCAej5uZ5yvRKPUVEV4Mh+GBMmPI6u1mDhhGhdyYtCSASpwyXgVdV6wz3R66+v6Sma/vL6ySb53LTM/1gtBGGtBemn6InaO3nyEQWcQLKm6AY5F/UAM2GOw/ybreCalO0DBjO9Xaj339IfsCPVeSIEnL4Ov6Nmk0LIoE3IpSjQ4ChxlnnafVdEQuvPx9rmgaKwkGrb5ACNPcQtrNPR2xapfODxbZR/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Oct 2025 12:08:08 -0700 Joshua Hahn wrote:
> Motivation & Approach
> =====================
> 
> While testing workloads with high sustained memory pressure on large machines
> in the Meta fleet (1Tb memory, 316 CPUs), we saw an unexpectedly high number
> of softlockups. Further investigation showed that the zone lock in
> free_pcppages_bulk was being held for a long time, and was called to free
> 2k+ pages over 100 times just during boot.
> 
> This causes starvation in other processes for the zone lock, which can lead
> to the system stalling as multiple threads cannot make progress without the
> locks. We can see these issues manifesting as warnings:
> 
> [ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
> [ 4512.604370] rcu:     20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
> [ 4512.626401] rcu:              hardirqs   softirqs   csw/system
> [ 4512.638793] rcu:      number:        0        145            0
> [ 4512.651177] rcu:     cputime:       30      10410          174   ==> 10558(ms)
> [ 4512.666657] rcu:     (t=21077 jiffies g=783665 q=1242213 ncpus=316)
> 
> While these warnings are benign, they do point to the underlying issue of

No fix is needed if it is benign.

> lock contention. To prevent starvation in both locks, batch the freeing of
> pages using pcp->batch.
> 
> Because free_pcppages_bulk is called with the pcp lock and acquires the zone
> lock, relinquishing and reacquiring the locks are only effective when both of
> them are broken together (unless the system was built with queued spinlocks).
> Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
> freeing from its callers instead.
> 
> A similar fix has been implemented in the Meta fleet, and we have seen
> significantly less softlockups.
> 
Fine, softlockup is not cured.

> Testing
> =======
> The following are a few synthetic benchmarks, made on three machines. The
> first is a large machine with 754GiB memory and 316 processors.
> The second is a relatively smaller machine with 251GiB memory and 176
> processors. The third and final is the smallest of the three, which has 62GiB
> memory and 36 processors.
> 
> On all machines, I kick off a kernel build with -j$(nproc).
> Negative delta is better (faster compilation).
> 
> Large machine (754GiB memory, 316 processors)
> make -j$(nproc)
> +------------+---------------+-----------+
> | Metric (s) | Variation (%) | Delta(%)  |
> +------------+---------------+-----------+
> | real       |        0.8070 |  - 1.4865 |
> | user       |        0.2823 |  + 0.4081 |
> | sys        |        5.0267 |  -11.8737 |
> +------------+---------------+-----------+
> 
> Medium machine (251GiB memory, 176 processors)
> make -j$(nproc)
> +------------+---------------+----------+
> | Metric (s) | Variation (%) | Delta(%) |
> +------------+---------------+----------+
> | real       |        0.2806 |  +0.0351 |
> | user       |        0.0994 |  +0.3170 |
> | sys        |        0.6229 |  -0.6277 |
> +------------+---------------+----------+
> 
> Small machine (62GiB memory, 36 processors)
> make -j$(nproc)
> +------------+---------------+----------+
> | Metric (s) | Variation (%) | Delta(%) |
> +------------+---------------+----------+
> | real       |        0.1503 |  -2.6585 |
> | user       |        0.0431 |  -2.2984 |
> | sys        |        0.1870 |  -3.2013 |
> +------------+---------------+----------+
> 
> Here, variation is the coefficient of variation, i.e. standard deviation / mean.
> 
> Based on these results, it seems like there are varying degrees to how much
> lock contention this reduces. For the largest and smallest machines that I ran
> the tests on, it seems like there is quite some significant reduction. There
> is also some performance increases visible from userspace.
> 
> Interestingly, the performance gains don't scale with the size of the machine,
> but rather there seems to be a dip in the gain there is for the medium-sized
> machine.
>
Explaining the dip helps land this work in the next tree.

