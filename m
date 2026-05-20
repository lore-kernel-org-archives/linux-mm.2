Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBFBCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5BF6B009E; Wed, 20 May 2026 11:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD856B009F; Wed, 20 May 2026 11:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA556B00A0; Wed, 20 May 2026 11:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7696B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DD411C020D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
X-FDA: 84788110092.10.69C4FF8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4BC8D18000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YTqwMpxe;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SJ/E0h+Jcau1sfPZwCYkdaMr3K0ldTX3IQaBiW/wOI8=;
	b=lHqMrKfXK4kwcJOHl0rL2jG1euGL7DQRx7iahZYcOve+K5448XYwRK9nT3UGDTTNANJ6m5
	lNqipsHy9rxwOXF7YyuSJ26adzObZqr27Te1YEYqM7ZgC58cGRbco7CiTv/8P6gNrY8CEj
	IBlRLAgPgQ+17TYpDuS3Q36oyN1tESk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YTqwMpxe;
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289244; a=rsa-sha256;
	cv=none;
	b=DfRgAu4qTrCPNu0ZVMdzi5W/Xr+JNzOh1qubKnajmzcxPCWjCGvverj30AOHrteWVcfxHp
	9lKEL9z3KLo6QJC7LCgtQ9uW+XDih/OXfR3bBlJM0lGyEYYP2rFH3YeuckxCjjdIxG5xwu
	5oQUb0rjXPUpaZNQJqoInvOyQqOjq+c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SJ/E0h+Jcau1sfPZwCYkdaMr3K0ldTX3IQaBiW/wOI8=; b=YTqwMpxeHkLxwIa72X/SVb1fw1
	NwjjyLqp7bh32LeqsIPUeJfpnD3G9kNFS2kL/2d1tM+YG16BhnxrGIxD9FYlFwqxThgEB++Lj38+G
	uvD8KuChHiOjCjNG0nu2QeiuSjTluA683c9bc2BCMUtdnOwswCZ1JwQeONjo0G/IxJhV/2fvIfaYV
	N1NXqOYV7q7WyG+y0nKyiZP0JvV8PJ+lYEfhuJxESHPRUdxu8wG1nAQ1m6cYNzpCzWUEzXmPyMWkS
	Lk51DpVVsw0FySXleWLplnr0SD+TJ7WlitRGxwUoBkWnaygESRLUgSfIW+Jul2Ua/FrmYydqZ5jS8
	IfHPYvfA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-011W;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com
Subject: [RFC PATCH 00/40] mm: reliable 1GB page allocation
Date: Wed, 20 May 2026 10:59:06 -0400
Message-ID: <20260520150018.2491267-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BC8D18000C
X-Stat-Signature: nj3rcmnufemfbbc7k45c4swobcd9m3z7
X-HE-Tag: 1779289243-528554
X-HE-Meta: U2FsdGVkX198J774iJfcaZUE3mpiwblmc1O52b/rxfWLO8zPE5ObVPdSGCySao8082f+SD4RyuKN0TJbXLtvdgvl6PsK8paSoXkkMcr4oiLhS2e6ZLSz7pohTyKTPcymPChdsaT9/nnHjelEeFBBSDaNa8+XY2r42RIMlzjq85XY9l4IcRhPF6HosKPBoDSiNvZpQdsHIyzm5JO0U4RNUCfWsG3Xpl1WxOtwbAzUkejvVLiHWboYC0+v+fnMQqrRLn8d+kFcVbwFaHxVSdChO1eegL+WJdXT+bXGfF9A3vE8mFAtvCo1Bj7fSHF494zPEBkUd1ESC+QcWD9sHc0Jxr8gUHudk8XRSTrTd9raEJJgZAnacxSt8YiSVo7Gd4By3H+HvsGBI1DcQMnb5t5t/7LGEm9Ihf7BVsUxrPXt7RScc9ntVPBFDaRM41nM5EtZWhpDSVXsvT9J1z2cG2Gid6S43YHiFoORfokYWlno2dbh33x6E6gSNgUgK2ZOjGwQS+svUYbiV/GvTETlL4mxAfKpXXPS6NxOfwYyGoCLTG8xObLvlk+IUEqybIottaXcqfGCfgXGZI0+uytKIaqJYMBr8lZuIsMst1008Usqof1QTu5ULWqbYuf6ud+WNafksQR5Z7Wa7FSaL2HtPCPBwBqm/MAvF6G3UjTtc1NidL0bJmHxz4F52tABSOoz3/s95UMm7npEMe9ALOnZfExo4fvcVdC5nXytPOdVvEOxGsoYLuwg7NptG4fd01h0XwCKH6DuL7jS4ZgX7TZiVALFgDI+xWajfoapgvt1eRBXV93OJaSD+BnX3ByM5UejKveTibh8pWP0yrUOQH7gtr2a4NaJ/kZoaT2iWor7D6WwBqfc76OTQvQnbbKujDznTQmIX+CyeLCXuADL+z2q9a/2UDKnbd10tJaMzW6uWlRRZv0/4mGYkVMtzBaxA0ogsUxfJ3ddfHqWL3D62bCVdzd
 8w/mQIg9
 adpU0/sQAtjatlKVm/9bVnFlBRtAj7+xpMA4iy5CzIUZMUUeYvc3GksHoLgAcmF+a8F9gNXUTE1GwmN+XHoNHjoysnl1ce588izWS6yDuuNsYce7D/Fy0Tj5oM2rM5PN9VL4QhEcGnJS2w4GBn5pyK1A992DW5Vq8qpA2PNLmJeeseySKvQz3+oyj9ETuzyPTAWirW7rYQdQLyMnI1DfpCkqqvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Some workloads see real performance benefits from using 1GB pages,
but allocating 1GB pages has often been limited to hugetlb pages
that were set aside at boot time, or using CMA to keep a fixed
amount of system memory off limits to the kernel.

Neither of those are great solutions, given that modern servers
tend to be large, often run multiple workloads simultaneously,
and each workload wants something else.

To address that issue, this patch series divides memory not just
into 2MB page blocks, but into PUD sized superpageblocks, and
aggressively tries to steer unmovable, reclaimable, and highatomic
allocations into those superpageblocks that have already been
"tainted" by such allocations.

The goal is to leave as many 1GB superpageblocks as possible
used by only movable allocations, so they can be easily
defragmented for either regular PMD sized huge pages, or
for PUD sized huge pages.

Various strategies are used to accomplish this goal:
- unmovable and reclaimable allocations are preferentially
  done from 1GB blocks that have already been "tainted" by
  these allocations
- kernel allocations that can be done as one higher order
  allocation, or a number of smaller allocations (eg. kvmalloc)
  will fall back to small pages, rather than taint a new
  1GB block
- movable allocations are preferentially done from clean 1GB
  blocks, which have only free and movable memory inside,
  starting with the fullest of these 1GB blocks
- 2MB allocations follow the same strategy
- 1GB allocations start with the emptiest clean 1GB block
- if a 1GB block is mixed, with some movable pageblocks,
  some free pageblocks, and some unmovable/reclaimable pageblocks,
  the system has a free threshold below which only unmovable and
  reclaimable allocations can be done from that 1GB block
- below that threshold, no new movable allocations are allowed
  in that 1GB block, while new unmovable/reclaimable allocations
  are still allowed
- when a 1GB block is below that threshold, use the migration
  code to evacuate enough movable memory from the 1GB block
  to bring free memory in that 1GB block back to the threshold

These strategies together serve to concentrate unmovable and
reclaimable allocations in as few 1GB blocks as possible,
leaving as many 1GB blocks as possible available for movable
allocations.

That enables both more extensive use of 2MB THPs and mTHPs,
as well as reliable allocation of 1GB pages.

The above strategies also make the core page allocator
more complicated, and slower. In order to avoid that issue,
the series is built on top of Johannes's PCPBuddy series,
which has the goal of reducing how often CPUs need to get
pages from the zone free lists, instead relying on CPUs
giving back pages to each other, based on page block ownership.

TODO:
- compaction "always" succeeds, with a success rate of 99.96% seen
  in traces; this sounds great, but it also results in compaction
  never being throttled, and compaction blowing out everybody's
  PCP through lru_add_drain() calls. This needs some sort of solution.
- replace the superpageblock name with something Matthew and David
  both like
- find more corner cases, and fix them

Based on e1914add2799



