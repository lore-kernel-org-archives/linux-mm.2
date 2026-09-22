Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F47C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA726B0098; Tue, 22 Sep 2026 08:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A34E6B009E; Tue, 22 Sep 2026 08:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21306B00A0; Tue, 22 Sep 2026 08:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA35D6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:47:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E53BA65CB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:47:02 +0000 (UTC)
X-FDA: 85241373084.09.8E2166C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1ED6A000C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:47:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h1eg+t/j";
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx1cDLNT/v31qKJcafvn3WkzdrqDUmMJSTVkfFeWiQ4=;
	b=Mm4TM26DtEOezEu4vIOmHfgcCYHiV4cnBI3FhwVODqGAZRFAPpsy5T1W+5dfwZxc9r1sc6
	1fP2OaYuIvKNiprRD1OS6TylQO4zOnkZ3NgQgZg/1R3RnY1bggYwLTPLLiE5itwKx2teev
	GrpS0s3pc1NO8P9yPToKT00q8l6XnFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081220;
	b=EjN/1xx6dF5WMEEOj6U10j3B8Te/jZADOIpwTdDJP2GB6c5RqkR3q+JlPZFg+vaXZTcAn8
	1LfrtyY8g+Mn23LG3k0pEZDl3ABKO7V8JtWQ+1XLuRe3CnrqO7ZKgr/4TN1P0XCLpPM/eE
	amEqHYPor/yb71aZo2lEtUn25ozN0Dg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h1eg+t/j";
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D75D9416C3;
	Tue, 22 Sep 2026 12:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427A51F00893;
	Tue, 22 Sep 2026 12:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790081219;
	bh=Kx1cDLNT/v31qKJcafvn3WkzdrqDUmMJSTVkfFeWiQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h1eg+t/jUhQbuzHrElz3Hf5taYbBwYU0NBlcmQx4+KVtL24Vm0a4MfbxrbPT7+XZu
	 NUzXJB4MtOPLFb0knT7Bkdynn7oV43dCho4gZ9oD7E23+Xf2Owzykm8ZNAO0sGLnnO
	 7FTqSY3HwIBougjUPxzSyzBBIyNjCi1RBcUgzY7XFQU/tkhgM/XoG/sim8vvfAn+++
	 beJtOJj2/ZtvFEVokoQ+cIIPOPIaSQ/dEXfJTrHK+5mmtRhdMb3NTf9jiVrHE/J+HH
	 W76w5Z5owffNApwmpqj/LiwAW/WR30WAic8mUFYf/rMlbOAzYKzu9ocPIcrWi+aSzs
	 y1fyDqDdi/QHQ==
Date: Tue, 22 Sep 2026 13:46:57 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: refill prefilled sheaves from the barn
Message-ID: <arJwnw_kxbj2RFUe@thinkstation>
References: <20260921094521.141665-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921094521.141665-1-hao.li@linux.dev>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1ED6A000C
X-Stat-Signature: irpi3g1t17wpgrn5gtk3tbha4qwzwxo7
X-Rspam-User: 
X-HE-Tag: 1790081220-710528
X-HE-Meta: U2FsdGVkX1/DbiA3QHkaWi6i9gRljsH8pYg36d4vQDYCp4agIy0RBnI7ptSjBSwqXCvojTC3YeD0cTKncnJDHmh+JJPd2er00uzYpT2vScwk0gh5s9SeeDXjxWeTpqln1YWHI0//Pfj14IqEE9m43uPPQUsudKPOQMribj6RTCmOxT3JOq1f8yMPZbXvM9kvrpKwEulVO/KUbYcRO4Wv8Kt1v1OmZ+8IDpeVSCqDyVRcxCwcwG0gD+y0yOpv/afci8XixWz0wnMiBqCoH/HYozSE6ahU6Bb39sdqfqlsv8S35gJwSjzmgENc12XKqpdyVx+/H4Hurat2S7XVUOrk2Gc7fINArOg7Y8UxnQHZiwn2vFGV+VZr5WNnWYfJBL5tXn1B38pcH6kCe2KdCaIxRbP4VTf8QqD7kmsB12foKTapBlCr+pL38cNSOR1LHgWpR00q64K6rRDHxJN3yuU49YvmaQFskz0Ll4LdAJENPyhCzcsnGSFU/n2KMijB7bJbPn+W0bW8vma2MUGMf0DuqEkZcJLfWbHFWYnA2sZFvWv6OpJB8griAV8sLyEOrPMuchCbQG/52Pmez/FX4+PCWhzCrqXDiZ3e2UPXj9dk8pxUJMAfNvQ728QpmY+K4uY+dw9RboEx1Ay7o4Fomfz3tPpwCqx5/Rh9owVoYEeWd0cfxWV8AFfPPPFff102NLftfWo/6j2CMtSWRtnwnQhTZZ1XtLR6kNh06mvnTLkDRHZQADkrO0FMBljlsj2HqVMuA9dx72YZj+OhZAtHPjonsuXuELeJXxiqmUZbCFUImNiP18o4G0/+q3sQ0an+VgzMqx8XfqUmXAkL9gLjEZlVIHr+LpR0xDpKM3WPUTEVBpiT8gxF9ieg7asUwXxwVWWAtxullwRw3cjaXQNMd1f+p7wkLryGFaIg/0O729wNzR0sleDs3GZUr0kM2S90xwGHCZZHwl+fFV7meHCGBx0
 XFUXR835
 JRAFX0+0nhn3rKgc+PLaR9I1GXQ9ooqiySLo1o6vRAemG/Fq0GDMDC5gJBQC7OkPG+oM55Mk6lrzGR25mUv6e2OfEv60eEVmLabU8pWwNlXOVblwaQ1CO+KB7ZpcvPH6CWLJwIEVDHgYJsp02M1qYSzWbgkOUOd/EkzGvYku5ysGSdWbe+7jIOrWvDc6WYBHx7ba3qzdUiI0PqkXSKHvHiJnh4Nqo8G/Q2mrm7RHD6pQQqoEvRwQCOf9co4Uhnuy3JLII0Km9hn9prf0r0fHINovWeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:41:13PM +0800, Hao Li wrote:
> Currently, when the prefill API refills a non-full sheaf, it takes the
> objects from partial slabs and never from the full sheaves in the barn,
> so once the barn's full list becomes saturated, it stays saturated.
> 
> For objects freed via kfree_rcu(), every RCU sheaf then has to be
> flushed to slabs because the barn's full list has no room.
> 
> To fix this, let the sheaf refill from the barn first, and introduce a
> partial sheaf in the barn, which holds the leftover objects [1].
> 
> Only the prefill path needs the partial sheaf. The generic allocation
> path (__pcs_replace_empty_main()) exchanges an empty sheaf for a full
> one from the barn, so nothing is left over. The prefill path refills a
> sheaf that is not necessarily empty, so taking objects from the barn
> usually leaves leftovers, and the partial sheaf is where they are
> kept. refill_sheaf() only takes objects from partial slabs and never
> involves the partial sheaf.
> 
> The sheaf is refilled by copying objects from the partial sheaf, and
> then from a full sheaf taken from the barn if it is still not full. A
> sheaf that objects were copied from stays in the barn as the partial
> sheaf if it still holds objects, or goes on the empty list if it is
> empty. The sheaf being refilled is never replaced.
> 
> The gain comes from two sides: every full sheaf taken out makes room on
> the barn's full list for a future RCU sheaf, and refilling from the
> barn is cheaper than refilling from partial slabs under list_lock.
> 
> Note that putting the sheaf with the leftover objects on the full list
> instead would not work: it would occupy room on the full list, so the
> list would stay saturated and rcu_free_sheaf() would still keep
> flushing.
> 
> An earlier version of this patch swapped sheaves instead, to minimize
> the memcpy overhead. As Harry Yoo pointed out [2], replacing the
> caller's sheaf loses cache affinity, filling it directly is more
> straightforward, and testing showed no measurable difference between
> the two approaches, so the approach he suggested is used.
> 
> Tested with will-it-scale mmap1 (192 processes, one-minute runs) on the
> maple_node cache.
> 
> throughput: 27778727 -> 34500556 (+24.2%)
> 
> metric                       baseline           patched        change
> =====================================================================
> alloc_fastpath                 54,124            56,696        +4.75%
> alloc_slab                  7,100,651           159,739       -97.75%
> barn_get                          849       194,460,392    +22904539.81%
> barn_get_fail                       2               217    +10750.00%
> barn_put                          851       182,306,701    +21422544.07%
> barn_put_fail             260,400,484       145,522,675       -44.12%
> cmpxchg_double_fail         1,029,204           334,228       -67.53%
> free_add_partial          326,694,687       181,935,790       -44.31%
> free_fastpath                  13,297            15,611       +17.40%
> free_rcu_sheaf          8,332,839,104    10,490,535,227       +25.89%
> free_remove_partial         7,099,788           158,297       -97.77%
> free_slab                   7,099,788           158,297       -97.77%
> free_slowpath              10,969,156           782,851       -92.86%
> objects                        15,295            14,849        -2.92%
> objects_partial                15,295            14,849        -2.92%
> partial                         1,604             2,336       +45.64%
> sheaf_alloc               137,757,895       141,208,076        +2.50%
> sheaf_flush             8,332,823,922     4,656,725,764       -44.12%
> sheaf_free                137,757,883       141,208,072        +2.50%
> sheaf_prefill_fast      3,337,502,163     4,196,506,116       +25.74%
> sheaf_prefill_slow                685               400       -41.61%
> sheaf_refill            8,343,794,364     4,657,509,724       -44.18%
> sheaf_return_fast       3,337,502,411     4,196,506,382       +25.74%
> sheaf_return_slow                 437               134       -69.34%
> slabs                           1,604             2,336       +45.64%
> total_objects                 102,656           149,504       +45.64%
> 
> Here is what the important metric changes mean.
> 
> barn_get and barn_put: refills now take full sheaves out of the barn,
> and RCU sheaves are put into the barn again. Before, the barn's full
> list was saturated once and hardly ever consumed.
> 
> barn_put_fail: more than half of the RCU sheaves are now put into the
> barn instead of being flushed. The rest are still flushed because they
> arrive while the barn's full list is at its limit.
> 
> sheaf_refill and free_add_partial: fewer objects are taken from partial
> slabs to refill sheaves, and fewer slabs are added to the partial list,
> by the same percentage.
> 
> alloc_slab and free_slab: the partial list is almost never empty when a
> refill looks at it, so slabs are almost never allocated and freed again
> only to serve refills.
> 
> After the test, the maple_node cache holds 1604 slabs without the patch
> and 2336 with it. After a manual shrink
> (echo 1 > /sys/kernel/slab/maple_node/shrink), it holds 485 without
> the patch and 563 with it. So most of the extra slabs are held only by
> objects sitting in sheaves and are returned by a shrink, and what
> remains is a small difference, because objects handed out from the barn
> come from many more slabs than a refill from partial slabs would use.
> 
> Link: https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/ [1]
> Link: https://lore.kernel.org/linux-mm/aq0ylDidEHa2kg4X@thinkstation/ [2]
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

