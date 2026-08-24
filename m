Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D870DC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07216B008C; Mon, 24 Aug 2026 08:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB72F6B0095; Mon, 24 Aug 2026 08:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6456B0096; Mon, 24 Aug 2026 08:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2F86B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:20:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01EADA00FB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:20:30 +0000 (UTC)
X-FDA: 85136071062.18.D9B471D
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf03.hostedemail.com (Postfix) with ESMTP id 017B22000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:20:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GL8u/+fA";
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787574029;
	b=dQPevBEhe+szXV0kAxl9pIvd1SxDiJt3X7LkOcivnVWpPFJ1i+ODfSLffLqa6LbpZ6izcP
	p18HmqIPI7heTtrn4Tso9kEkG76bIj6/TJmqpQLfvlylP9RZI5QOMgYVW4xA9D11D1o5Va
	x5v2x+OT5EXZryf255T78sn+qyBLZrM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GL8u/+fA";
	spf=pass (imf03.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787574029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U8fl0r7E5mruPmQifpgRhkmtqUw07cBJhLPc0wVxoWw=;
	b=mKXKhI8NGfeOsMbjBOkA5mVONgL1cyKmMYHTWga2mvcARIEsdCMbreY8L1vlNwPIhf3C2h
	7/wz3AYQ7zzeUZzHYms8cpKwW3K4qv819fSRxkqLdJ5KCm2Ymw1K44MpmgN+O0JFZqYE3l
	BmuJts9aY4iCjXwFK2Oi28NBapBAZ4o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GT1jLiel5M2UG4rmfoDZ+9MbixFcM3ZroPSpTa3Q+Uk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787574027; v=1; x=1788178827;
 b=GL8u/+fAV4bUEAkYQnYZifh5BVpxSa5ps63Cn9XtNr6sho2ly39wH0J5f10MXM8gyCDl+jjI
 IHD5Abq8+KvuZ7pzi1kVm+q8F4UV5oNOHZzNfxJoLQOCdiTqrWw+bmSZAHNRV9InL7JxNuJ/pW8
 6nGJR7ZFT9aDxaob/aCXWgvA=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id ac3c30d9b503febc;
	Mon, 24 Aug 2026 12:20:27 +0000
X-Mizu-Trace-ID: ac3c30d9b503febc
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [RFC PATCH 0/2] mm/slub: reduce list_lock contention with slab parking
Date: Mon, 24 Aug 2026 20:19:50 +0800
Message-ID: <20260824122004.3652-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 017B22000A
X-Rspam-User: 
X-Stat-Signature: 5ks5imgwq5fde5ukki7tdpsxefshn3n3
X-Rspamd-Server: rspam06
X-HE-Tag: 1787574028-416178
X-HE-Meta: U2FsdGVkX1+e6kbEiBHQ3j3hWnwdzVD3Bm+xVKy2f2y5NdQuFN8ciby828crjVHnlt9DuWz28o04hC7X3ndMdmDRJ4ePqhyL0OLhE5sT3h06b8IHPJkIIm0Tqe5pA/6WH+GOSzFOitMtDXBqfx6gCyGGukEZrJ/XsAhx4q0+d+g6GerRs3mnXfDOlf4VKfxbRFG85eyj8Dv58exz202fcGK9J826S8lDQZQEXlTA8TRm0zEhE66v/WZGs9dt620vQRC3O5KjPhT9glZROKwC6D9iSlJ/3/M5N+r+Vn5ODJ2UAmTdqGMf8ONtIsUlDajPZ/iN716SfgvstJyO15lXMZSXBzOSe+NBYjk4a8XE2qTTZ1e45EgfG5pCy3bLv5iJfTc8QfXBItYxyGrYoiEvsIq2DiIztuHhbri7oYXOpD+vZOPXVjC0mJpENR7uK7okeWk5DAhpzn8j/kj+zmyNMKtvpWyfSqNY5ia1Mx3uKqQGvf7jw0atksSgtg96l2lJuSaCFxwOpACWGRbJa1TCz3gw6xGFOupvynUtlluaz1agE/jO6GQrQF4Q6e+Mi4+Ry/Hqalkw699GfaLjzF0HRILq8XOyGwi3iznDA5bGEdVLqDSAxenYtxZzCubl/C+PkqN8Z2gVSNekVobgTpXXcrlLRiPWQ08YCICu0sF7Thd+Ni3XERHrfrOhjMswyh/u6t7+Cxs7iM8dKKrfnN1TEdrvCL/gbh+cGg+43uiUc+yaWVsrDlkU0Hmi3Z+Jy+0ox4xHKDTC9Ask2KM+4MOyD3ofuz8zVQM3lE+DkwXVVI+odsCoVPrwnpjL24sgVw1NqDkmzghXdtrTK1SEvsQqvG17U7zcf3OOxh5UBaEU/wBMcx+IJDlcromxmPje53MJzE7/PrJK14/pz9CKvaa854ko7NleXQ362dqf1srDv73CLyaUGDPJLMo9Nq+FLUErxpMJfr+IqGH9s0gEyRD
 dGLgpSH3
 p0+ydLF45NgsU9fGbZDFXH6lFyDyLjsGeEJjwJTyTxyVwIMHBSq+qPhB87KmiAE28OAeYV1ubCxiBv8frI1Ywka/Oi3G/xTYr8AL6+5qNdhYXAkgPrex1KUA7813QsWTdhDGFDxmfhvrCp8yB/eROhLW/gt96GW597PgCHwrVyFd8RSx6nJ8j1N3epXTm4mpbG4dYEm2psMdQ9Hwt4WkN5c07nDkPiIassA0IlA2cQPPf3RPCEJOHRE7izTUYpkA303enMDkFmTTxHI5iaguo+K7Kjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series might sound a bit wild, but the initial numbers don't
look too bad so far. I would really appreciate any feedback and
discussion :)

On a will-it-scale mmap1 run with 192 processes, list_lock is the top
contention point: __slab_free() and __refill_objects_node() together
spend 44% of cycles in native_queued_spin_lock_slowpath. The free
slowpath takes the lock mainly to add slabs that became non-full to the
partial list.

By adding extra instrumentation to __slab_free(), I collect the following
data for the maple_node cache (in counts):

  partial->partial    843017414
  full->partial       550719384
  partial->empty      17459564
  full->empty         2

We can see that full -> partial transitions account for a significant
proportion, and optimizing them can help reduce lock contention to some
extent.

This series introduces the parking mechanism to address this issue.
When the trylock fails during a full -> partial/empty transition,
__slab_free() parks the slab on a per-node llist instead of waiting. The
paths that consume the partial list (sheaf refill, alloc slowpath,
shrink, cache destruction) unpark the slabs after taking the lock, and a
delayed work covers the case where none of them runs.

Patch 1 cleans up the case handling in __slab_free(), no functional
change. Patch 2 introduces the parking mechanism.

Tested with will-it-scale mmap1 (192 processes).

Summary data
------------

throughput             29237910 -> 35585663  (+21.7%)
alloc_slab,free_slab   -52%
cmpxchg_double_fail    -85%

perf data without this patchset:
- 44.22% [kernel] [k] native_queued_spin_lock_slowpath
   43.48% native_queued_spin_lock_slowpath
    - _raw_spin_lock_irqsave
       - 23.80% __refill_objects_node
       - 19.12% __slab_free

perf data with this patchset:
- 30.39% [kernel] [k] native_queued_spin_lock_slowpath
   29.82% native_queued_spin_lock_slowpath
    - _raw_spin_lock_irqsave
       - 29.06% __refill_objects_node

Additionally, the number of partial slabs and the number of objects show
no noticeable change before and after applying this patchset, indicating
that this change has a negligible impact on slab fragmentation.

Detailed data
-------------

metric                              before             after             delta      change
==========================================================================================
alloc_fastpath                     155,417           168,534            13,117      +8.44%
alloc_slab                      55,679,646        26,702,510       -28,977,136     -52.04%
alloc_slowpath                           0                 0                 0      +0.00%
barn_get                             2,715             2,771                56      +2.06%
barn_get_fail                            2                 0                -2    -100.00%
barn_put                             2,715             2,770                55      +2.03%
barn_put_fail                1,370,488,457     1,668,257,974       297,769,517     +21.73%
cmpxchg_double_fail              3,827,935           549,427        -3,278,508     -85.65%
free_add_partial             1,684,340,964     2,161,921,625       477,580,661     +28.35%
free_fastpath                       31,766            32,979             1,213      +3.82%
free_rcu_sheaf              43,855,689,417    53,384,314,553     9,528,625,136     +21.73%
free_rcu_sheaf_fail                      0                 0                 0      +0.00%
free_remove_partial             55,678,459        26,685,274       -28,993,185     -52.07%
free_slab                       55,678,459        26,701,099       -28,977,360     -52.04%
free_slowpath                  107,771,739        63,197,344       -44,574,395     -41.36%
min_partial                              5                 5                 0      +0.00%
object_size                            256               256                 0      +0.00%
objects                             14,504            14,336              -168      -1.16%
objects_partial                     14,504            14,208              -296      -2.04%
objs_per_slab                           64                64                 0      +0.00%
park_slab                                -     2,147,963,530                 -      absent
partial                              1,398             1,367               -31      -2.22%
sheaf_alloc                    743,660,288     1,284,618,991       540,958,703     +72.74%
sheaf_capacity                          32                32                 0      +0.00%
sheaf_flush                 43,855,651,858    53,384,274,983     9,528,623,125     +21.73%
sheaf_free                     743,660,280     1,284,618,967       540,958,687     +72.74%
sheaf_prefill_fast          17,585,335,850    21,378,958,833     3,793,622,983     +21.57%
sheaf_prefill_oversize                   0                 0                 0      +0.00%
sheaf_prefill_slow                   2,060             2,051                -9      -0.44%
sheaf_refill                43,963,424,505    53,447,473,167     9,484,048,662     +21.57%
sheaf_return_fast           17,585,336,335    21,378,959,334     3,793,622,999     +21.57%
sheaf_return_slow                    1,402             1,277              -125      -8.92%
slabs                                1,398             1,369               -29      -2.07%
total_objects                       89,472            87,616            -1,856      -2.07%
unpark_event                             -       315,397,838                 -      absent
unpark_slab                              -     2,147,963,530                 -      absent

derived                                                  before             after      change
=============================================================================================
PARK_SLAB / FREE_ADD_PARTIAL                                  -            99.35%      absent
UNPARK_SLAB / UNPARK_EVENT                                    -              6.81      absent
PARK_SLAB - UNPARK_SLAB                                       -                 0      absent
page allocator churn (alloc_slab + free_slab)       111,358,105        53,403,609     -52.04%

Note that some metrics have very small absolute values (such as
alloc_fastpath, partial, slabs, and total_objects) and are subject to
noise. Across multiple test runs, their rate of change fluctuates
between positive and negative, which supports the hypothesis that this
is measurement noise and demonstrates that this patch has no noticeable
impact on these metrics.

For metrics with large absolute values, their trends are distinct. The
data indicates that the primary benefit of this approach is
significantly relieved pressure on the buddy system, with page allocator
churn reduced by 52%. Additionally, free_slowpath decreases by 41%, and
cmpxchg_double_fail decreases by 85%.

The PARK_SLAB / FREE_ADD_PARTIAL ratio reaches 99.35%, which indicates
that the vast majority of partial slabs are added back to the partial
list via the parking mechanism, reflecting that the lock stayed
saturated and nearly all additions avoided waiting for the lock. The
ratio of UNPARK_SLAB / UNPARK_EVENT shows that each unpark event
processes roughly 6 slabs. PARK_SLAB - UNPARK_SLAB being 0 confirms
that no parked slabs are left stranded.

I also observe increases in both sheaf_alloc and sheaf_free, which
could currently be attributed to faster allocation and free paths
resulting from the overall performance improvement. However, I'm not
sure about this, which is part of why this is posted as an RFC.

Based on slab/for-next.

Hao Li (2):
  mm/slub: make the case handling in __slab_free() easier to follow
  mm/slub: introduce slab parking to reduce list_lock contention

 mm/slub.c | 326 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 274 insertions(+), 52 deletions(-)

base-commit: e7f630142df2afccce90555e4972e60008222311
-- 
2.55.0


