Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CC910F9961
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CC36B009B; Wed,  8 Apr 2026 13:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6BC6B009D; Wed,  8 Apr 2026 13:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295686B009E; Wed,  8 Apr 2026 13:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 14B516B009B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:35:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEC7FE07A2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:35:58 +0000 (UTC)
X-FDA: 84636091596.03.F5F3AD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1F6718000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:35:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="x7rPL/KD";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yGdECIzL3y85+5pNc6NsPO29oRq7CBh1qhwux5JZbes=;
	b=xYr07ttuCfDaWQ98Z1P0ffvDivfONi/+iEc00SHqOXvRununC26dRo0+Tdn4nrApobkmRX
	ip7bEiwGOO5s/6fRHQV5nvtuBaDsMOELMl1a0k2G6U8Z+F9ko7hLE/Bf3NQgNEuBwP3mdE
	KvaWPU2c2kc9PP5UZup3uUXyIbekG5E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669757; a=rsa-sha256;
	cv=none;
	b=s1NF6CLwpx2FeiizTs7Ok25ynawbK26Qo0LIKZlmZvSlq/IB1NCeHBlN+ecg/1azkbxWVB
	WmI8L1btiCXONVO+IZK9LthJx15oFdxIlj/AZl/ScELr4yIVrhDAlcF+e6ivMNqycFz6FF
	kV87VcZW58EUBnLHE2ww5aRhVaz0zbU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="x7rPL/KD";
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE42D41533;
	Wed,  8 Apr 2026 17:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF03C19421;
	Wed,  8 Apr 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775669755;
	bh=ka9aRT/veR2yJRZIYqQMZME1gG1hY1QiQBw2E52bdic=;
	h=Date:From:To:Cc:Subject:From;
	b=x7rPL/KD8tG22heS7t+m9wAVz4IiOc8wbVCKgrUGvuSx/0cqPamhuP06IpWwBsG+0
	 5rrciw1s1MYXlQxmtJY1w3ru3b9gkO0uu7EhnjceNQC7oQ7oVRNZIACzA3SdSYsBdJ
	 xVQ7UOs1DOpb55zhQ/WJsUOvTlSJMoTPlVdKeXSg=
Date: Wed, 8 Apr 2026 10:35:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Cc: mm-commits@vger.kernel.org
Subject: mm.git review status at 7.0-rc7
Message-Id: <20260408103554.6221935c7c13c2daf197ecd0@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 91sono8pcyoadb5xokwhrt9gckxbzot3
X-Rspamd-Queue-Id: D1F6718000C
X-Rspam-User: 
X-HE-Tag: 1775669756-732271
X-HE-Meta: U2FsdGVkX1+p6ljo+OMU3t0x7ZFqt9V6/g/YSHMPZZPLbGsH42L+kPm9QFYNkcsVJOAOVlre+bxW1vTTzxM1S1D3TDbS4Gnv96oHqnjPeLKbHPByIsb+IY2XugxTg/eusa/NKYnSz6f/mPWCE/hIIYWvh/RjPRSMxHy3ODER8kzRkBjDPnJsIMb7WuZBwf5gXPI73Zz5rlasKNfOEztaJ92aRSyay9knwuIYXlv8CAJtYT511ZxV1rQscX8VFZOvGQDCG2TopVsZzBDSjKc8ZSRgiNkYIkNMmXUmFXc++Zx4Xin7nHeH6MA7IMhL8XJehmGR98WXj8WBnO0ooBu3l6SDQYBom9lMoyOujZD7IWmiIrnqCiwOwzVUSWxLcWHy1QIBqisJtEHkilA/Zxk1tw0eJu9g6nlpxLEzxJlijeHN3LbkMIyk8eNbJ1UJ5L1cy+FZWRcG+LPW8o4JVBN9xlYTPg+zXvtPNGryMLc6DlKcaWdeGLEc3QZQ3nju1t4/7vAFLKxM1L5F2NY2Ac7FloOlTfJ7PcUmVMrZFKndscz9kQ1vGw4A5wtc1uaojNOdtpXOW2nUH4d8o09hho1mJ6Bxxs0YzeKCYSfOC4zH11PNAKdylRWuGXinWIbfgrJWH0NzVBf98wDZ3Db5SLjzzTYUJYaaOZUtWSLmdYcjNaSTfAgjJsg2vRN0N2dGACm39JUPpDKtKP5RrisyMw5vKRjOAPHBZfxyc8ssAdWqMXn5NiM/xjJ09D6AVhZRomeYq8RgpsAkFAFdcWZC1kIwciFPykTQSP0evh/ZVAng4LOJtummpTT+3Vher3peFwEkmeiW2au2Cc2rYARjFa9xcq10DetvIYe9JQFC5xOtXqCP3M9ugP3/1ThdkEHGKU9nreqRUpAEHC5oqubcYVG+UGaSTXMjYpw/5rB93TScom1MZMQIwxzgvBZfL0xhpYVT69SVPucT/FLqb+j9FMF
 dDQYve+o
 RIRHDxk+ULQ5NwSAYq6bHNC8Dcu0tOTni6K2dz/F3tQDAaT46A6i6qJy/SXyD1ckI53jBvsrLp52yjD94o/sAkLC9pV/KSZD/zfwu5drU4/rqMwBoiumX3XcAxIF7nTvsRLdqazJqfn4N9vohu/y/HLALjXU2PhCddgo+RdHRN9ST19LrTX+903vaesVcnKk6hnJfM6mMUslAiBPBfapnO/huAF/2QqQyfcceXgXd4P0cZrdaBcukmcK8LVSnTbWL3nsrA9azH9FU1nMhlC4LOqqWCytqV61WH9gSJJZtBxMQeFYluFEBCNlzr1mwb2VqomzQiyBWYJmP85/zoW/hUUfOMF+w2YalZgy+weM5ierLdOoO8hKMOO7yMfFoROWAKOCvBoMeTqhYDoxz91fnNQlYFsUBTzFlRreJR5/35mfPMkc5Im+mkkuyUHJdssyc0La4yK+XnRho6TU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Thanks everyone for the diligent review - we're doing well.  Apologies for
all the nagging.

I believe it has been useful - several patch series have been updated in
response to the review.  Also 2-3 patches were dropped or deferred -
patches which I expect I would have upstreamed in the ordinary course of
things.

Merge plans: no significant change since last week
(https://lkml.kernel.org/r/20260331213956.2f3925ff0dd12eabf55b7c37@linux-foundation.org).
107 patches are lined up for the second week of the merge window.  Search
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
for "2nd week of merge window".




mm.git review status for mm-stable-plus-hotfixes..mm-new

Everything:

Total patches:       115
Reviews/patch:       1.93
Reviewed rate:       87%

Excluding DAMON:

Total patches:       107
Reviews/patch:       2.07
Reviewed rate:       93%



Unreviewed patches by author:


Anthony Yznaga <anthony.yznaga@oracle.com> (1 total)
    "selftests/mm: verify droppable mappings cannot be locked"
        Link: https://lkml.kernel.org/r/20260402235933.10588-3-anthony.yznaga@oracle.com

David Carlier <devnexen@gmail.com> (1 total)
    "mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path"
        Link: https://lkml.kernel.org/r/20260322052120.14021-1-devnexen@gmail.com

Breno Leitao <leitao@debian.org> (1 total)
    "kho: fix kho_in_debugfs_init() to handle non-FDT blobs"
        Link: https://lkml.kernel.org/r/20260316-kho-v9-4-ed6dcd951988@debian.org

Lorenzo Stoakes (Oracle) <ljs@kernel.org> (1 total)
    "tools/testing/selftests: add merge test for partial msealed range"
        Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
        Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org

Mike Rapoport <rppt@kernel.org> (3 total)
    "tools-testing-selftests-add-merge-test-for-partial-msealed-range-fix"
        Link: https://lkml.kernel.org/r/ac_mCIUQWRAbuH8F@kernel.org

SeongJae Park <sj@kernel.org> (7 total)
    "mm/damon/core: fix damon_call() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260327233319.3528-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: fix damos_walk() vs kdamond_fn() exit race"
        Link: https://lkml.kernel.org/r/20260327233319.3528-3-sj@kernel.org
        Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
    "mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-2-sj@kernel.org
        Link: https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org [2]
    "mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp"
        Link: https://lkml.kernel.org/r/20260329043902.46163-3-sj@kernel.org
    "mm/damon/core: use time_in_range_open() for damos quota window start"
        Link: https://lkml.kernel.org/r/20260329152306.45796-1-sj@kernel.org
        Link: https://lore.kernel.org/20260324040722.57944-1-sj@kernel.org [1]
    "Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-2-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org [1]
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [3]
    "Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race"
        Link: https://lkml.kernel.org/r/20260329153052.46657-3-sj@kernel.org
        Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]




