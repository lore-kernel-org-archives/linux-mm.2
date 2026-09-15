Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE304C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 04:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09F66B0093; Tue, 15 Sep 2026 00:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAD26B0095; Tue, 15 Sep 2026 00:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83286B0096; Tue, 15 Sep 2026 00:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFB706B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:25:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3ACA81402CE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:25:58 +0000 (UTC)
X-FDA: 85214708796.08.3034A91
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6741D1C0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:25:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wbT5Os0g;
	spf=pass (imf21.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789446356;
	b=nDVrok9PRTI3z0JdHOnDknws6v9Uf1ukLRIaG0kOzmzKUNUEgDfxk2Zyk5PuhNfItmTJp7
	OgUBOCkImEY7HYuzc+cLe/3BfbfcKpd2bBbvy/lmr/N9ehL6ZsJ355CEgCKw8XDEap5Djq
	wfnGtR/O8HtJBGSDdAHQXzex8P7JQeM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wbT5Os0g;
	spf=pass (imf21.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789446356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WL2XPvPa5hKZgyLQVPqOjMB/mkqx2VtcNM7x/yo5l+8=;
	b=TULb/fisNajoohbdkP6T4yC1FSjelW8O5efAObSB5t41e+B8pbBXMfpMywiLspCglSw9nI
	AmWxWeh8O9clVdCeEI7LMRvPwNFMIqHG4ai/vySgcyPMs62ijDxCqIkYqWA3E0MxIH3J9Z
	OQo2+q7k3kkiicUc8XSheRgP2GBwtS4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789446350; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WL2XPvPa5hKZgyLQVPqOjMB/mkqx2VtcNM7x/yo5l+8=;
	b=wbT5Os0gYWOGARBmy5TSX9OwGTeNzozvekbcjPu4ayMPQAc6Lrob5G64/DkqvbPyyGFbVDrv7xelXUXgOk0CW77ZvZIsDGIJV4D7L8c53xX5mxExQeX4maP4qMPkomrgrsBlUH51owH1tTvSgljR4w8gyQnwBrYZG4Ck36CPoaI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XB027Bp_1789446347;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XB027Bp_1789446347 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 15 Sep 2026 12:25:48 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	xlpang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	chris@chrisdown.name,
	kasong@tencent.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v2 0/1] mm: memcg: don't hand out large folios above memory.high
Date: Tue, 15 Sep 2026 12:25:45 +0800
Message-ID: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6741D1C0002
X-Rspam-User: 
X-Stat-Signature: 7t5mt1p39en4abdiouo5r85grkg9n9mj
X-HE-Tag: 1789446353-492469
X-HE-Meta: U2FsdGVkX19WVMDCWDEay/9MXNCZsx9bnd7AZr6p7eT27E81xrUU7WRlExX3+Oi2jWneAYqmoVDzeLSziRXh32S07Bq84WRmDpE0+F3meq+a+vb9h7qEolHA3wOaNpebTlIwgytr4/sEx5yuMDSATj+8/H0KCxXXfAdS1QVrXFiRi/VYUX74flEvRbx+VS7HmAmNSTPiULlBeMSjkF+b2siymWvk8KbaPMSGZqBnEGF3FEXsNrLiInOy/MHtUBUDDQTrE0fii/VSDKeZW8ZaJTEk0Wqj7+TA/Zm3Bs75UWKN6B7labqFDmtbuAHpDDTMVYdtS3Eds0uRTAqfQNu4XrykVDDmMk9PeE1EQWOPSwPvBJlJHZJ+FsKDSfTqRbE/HuFxTJfZB/UNis0aoIF/UZZOSuqEad6942Q/JOl30D+uxT7dQGHdcn6ivOFgAUEmqweF/4MWLs28QzPwVC75frSdNPfHSuB+3ws1pjdasVxhrkZvkoeuU04Sub+pkEt2HTrvqEhL6DRW2Vs7+19Zk3LJJXxrMMwoZJTVYnswGbJhd/YzpMROVoY0RAz82BxQwV1hiGnXLd9CvsFBen10A7Z6r5JyCmS5GOi30Ia6J4AM6/XHzcYklF/3X0Pwss2vwGyoMslaIZODK7Qb1Q5qrr26ZdVR5mzt+IK9GiSDrWBIzbKzxMgTh6ovQpIxliHRrTVO2YpWdv743VlqJYTlG3N/tqm7kq/+Kjp9qVHTa+Ym8gyV+EXIS/tD8KT3JP+gl3Q5LXf6KG/Z4cg+jBs0DMv+UaPsa4sBJXZa6tEl+WhC0Hhdagrl4ZSv3CTyeyKwHT4YK7Ma4Bh99zYGDesnFZBl/zE265h1PFg/yv+6Y9q2oUfAHN7fzRRm1O8nwFFOQGFAOL6GdEBqBOyaw/zGp3pcPY41jAA3YpKsiD/wLdkWGPuX00LQKBJ0kNq6LJCH2h82mbIWOp8zlwj7kQM
 T+7ScPz4
 Dv0i1OqVDep7Y4wJQ9wsPTW9Mz05EHp3iuLrvEPdCASSEUgVhg0zrGoNJez1+j7zX8T46Yyk3WLVDGfwxGW74RMTNPv5c8Gr4NUtJgYwXH1Iy6sLwHlVb+V1DbygAyZa8Njk/X6TMCHcFSLXGwujqFTYOZxUi38VA8hrhM9L+PZ83KyKkUzxPm1uUnyCUj8XhkrIM1HLvDEbKtSGn3Xo3MBtqbfMpKzZMUzQwZGhuC4l07WkEB3/wn5p1ActjFksntSGwMF+z4Xqq1cOb6Ot2Yn5Mg8slFzJwrQJSemkgWdQQGqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.high is enforced at two points after a charge succeeds: on
return to userspace, and synchronously in try_charge_memcg() for
large overcharges, the latter gated on gfpflags_allow_blocking().

The THP fault paths pass the physical allocation gfp from
vma_thp_gfp_mask() to the memcg charge.  With the default
defrag=madvise (and no MADV_HUGEPAGE), as well as with defrag=defer,
that gfp does not allow blocking, so inside a single-syscall populate
loop - mlock(), MADV_POPULATE_*, any GUP-driven population - neither
enforcement point runs: usage grows from memory.high straight up to
memory.max with no reclaim and no penalty sleep, consuming the
reaction window that userspace OOM handlers (oomd, Kubernetes) depend
on.

v1 [1] settled the accrued over-high debt from the fault paths after
each non-blocking large folio charge.  As Zi Yan pointed out in his
review [2], falling back to order-0 above memory.high is the better
answer: above high the cgroup is meant to be under heavy reclaim
pressure, and the order-0 fallback's charge blocks, so it is throttled
synchronously as is.  v2 does that instead, and is a single patch now.

Qinyun Tan (1):
  mm: memcg: don't hand out large folios above memory.high

 include/linux/memcontrol.h | 33 ++++++++++++++++++++++
 mm/huge_memory.c           | 12 ++++++++
 mm/memcontrol.c            | 56 ++++++++++++++++++++++++++++++++++++++
 mm/memory.c                |  7 ++++++
 mm/swap_state.c            | 16 ++++++++++-
 5 files changed, 123 insertions(+), 1 deletion(-)

[1] https://lore.kernel.org/lkml/20260904035407.4098627-1-qinyuntan@linux.alibaba.com/
[2] https://lore.kernel.org/lkml/6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com/

--
2.43.7


