Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C75D6AAE6
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961BE6B0089; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9399B6B008A; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F9E6B008C; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75FD56B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:57:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2580714076D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:48 +0000 (UTC)
X-FDA: 84614071416.30.0D6FA5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8D9B41C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pc4H8f/X";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P+Z6LsxhiXs5Lqvje0OcflwO6w89vcTrYdim7WTySEQ=;
	b=PU09e04ymYjiUWQKYzBRykFnH3ffoO3LFsy2OcZOA6DXDvgXBfgMViUn41OCGFZa7OtmqC
	QEdnCjnrmexP21/9ymQ3665fedpi5SMtXIhpGzQnP6ibma8Ja75qDwPWV5sU+gVXmNRKyh
	Dpxn0+hQbGfsFp4bKyZoHYtMOybC9m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145466; a=rsa-sha256;
	cv=none;
	b=N+HjfPv8Ct5TXC6NDeDDY078bUkIf35CtfOgZBJU0n/orMH0zQubzbFgray+z0sgz2DACV
	ZEJ5mDJcBxnaOlQK3V5pzMJxN3RK14rNuJ/fVKkNUnwaIjcunxqpiX+Q0906FH5lLm+hUE
	sC2+Wz4GME542T7FsYZ9xFYIu9GyaYE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pc4H8f/X";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E39840D93;
	Thu,  2 Apr 2026 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62BC116C6;
	Thu,  2 Apr 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775145465;
	bh=mwE+127Wtx47haHMcKL32qgQUWoqYHGLXcy7Op4nYG4=;
	h=From:To:Cc:Subject:Date:From;
	b=pc4H8f/XTzomCfYZ59jP3MuLzWi2yBWgSaIqmouyIFvuL2sGNeJF+/2gQuReQs/e3
	 iTNA6s4/ZcA2Ltrxd0luVTkktrxBGYi3ZjH2FwVGz9PYz9xyzWrppXcmUc+dzfE2Uk
	 jgfg/UkK4yCANQoszttBaIjrFWbcfWJTHuDV6ZCzOn3iQYdrcjGBql7HWwRsdqNyxw
	 RCWs+5Eajl0psUVPKMMfiTson2FI69xlEWnFt5V6TRgmpSElwieZ65kBVtNoWkHRtS
	 kMQ/QO+YmxGyJ3Le/uom4NK0HyxPV75x3F7JIbPMMcJGXgLBviGJUkPegsKKXS9wpF
	 PpTIlBUANSOMA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon: non-hotfix reviewed patches in damon/next tree
Date: Thu,  2 Apr 2026 08:57:27 -0700
Message-ID: <20260402155733.77050-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bkea13zocf7pi4jx9y4ewbmuibbr69iy
X-Rspamd-Queue-Id: 8D9B41C0005
X-Rspam-User: 
X-HE-Tag: 1775145466-142362
X-HE-Meta: U2FsdGVkX1/5NNXiiWHspPv7g574SmcRIMvhCCPwMQcG/z/dOS0PI/jB8EAq63W2C2QBZSREzAwwgfq+1F6nA4K1uTa4ymYOP06HeQedLLeK8wwq9gxCJ6BWepFQzHi5rJDZZomDqKN/MEO8m86Q/ZDgN6OT10721G9YfJ7hfYQRNoW7NT3SLQ1XmnglDu86JkNj3eIRBAl3llxIJvoy7vfur1kvx978vUVVs4tjSLmqhcuNlXLWwy4zQC4cWDZR0XJcCxFZOInb8GNCLIEdPCLeLUecNpRG14iH9zr0Jrb1wcte9hlwSqDszpIixtG6AB28BOgSI/hD2z+gbultj5TxHgEBavzdzKS6paFUJQZMLthexxy6HCzBYnyrh1KoODqm0KDLMBnOAAC+4AxYsxCpKdvyaR+aJSK+TeWjoji5gMcFFQaCZFvnz9zc3g3HXoVY0kIaqJ/VdkaEvbhdDKDkGL8sK2GpKfpWgndifmMbQ9AEFbRYgLghUPh6JNs37yyiB0h3SBIS0XrUyQG/KHOK1TBU67k9GKngIv5/p0alNIjfkVxa0Mlr1mAxVlw6Yty/Vs9sYkGDS8h3YOormtB96KZOKdxiGxyyzkM+WTwoJ0Affo4/C+rPMAXOLAHbB37+K2iqbyRZSrfwdeVA9vrod26CfB5sKV2mCOnYbbv5ip/UwY1U9ld5yloTrjbV7KYfLq8kryUh54kfJMsa2NgOJYTE8ewqxGX/plkKglDrSMw5X/xU8PR+OYQQ2ZWQQPQVVCqjLPcoVWuA2mrka+7I0UhgGgO5Np9SKiasnXvs/0iK+Dwh9OGIDov2tWv4iMDlOncFnfu/8mq/tZQy4q7ly31K0Us0MSSexvqgQK2TUhWlLOp6nMKKLtrgeXIzg4jKjKF2gOZYxRICZNej9ftv0PvsI7NPnW33jnOUcaLUUswTFhK1Jv9LfxM4J1SgB656wwxSbtqIKFhySfA
 NsrLMEr/
 yrq3vamJvl2nrrMMdFcbM6tx8LDajYDYUp33+Zn1G0l2wwbL2r2GmPr4DxBtTd06PP8Zb8eNqKtj4Bg2Y6nApzjg6aq7URFG5XHx2uuYV954bIVvatTq1+b0DAaRrRKxDFWFNaxT9qk8gaQqfJtfsA+/tomiYf+LJuNPsfI3bbmNEa4vbjl7Hd1gcJEqf1ho9Mp+gCPJ7uGdVzMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Re-posting non-hotfix DAMON patches that reviewed by DAMON maintainer
but not yet merged into mm.git.  Those are not urgent, so it should be
ok to be merged after the next rc1.  This is just a headsup.  I will
post these again after next rc1, if these are not merged into mm.git by
then.

The first patch from Liew Rui Yan add a minor performance optimization
using ilog2() instead of inefficient manual implementation of the
functionality.

The second patch from Cheng-Han Wu fixes a minor typo:
s/parametrs/parameters/.

The third patch from Liew Rui Yan make commit_inputs operation of
DAMON_RECLAIM and DAMON_LRU_SORT synchronous to improve the user
experience.

Cheng-Han Wu (1):
  Docs/admin-guide/mm/damon: fix 'parametrs' typo

Liew Rui Yan (2):
  mm/damon/ops-common: optimize damon_hot_score() using ilog2()
  mm/damon: add synchronous commit for commit_inputs

 .../admin-guide/mm/damon/lru_sort.rst         |  2 +-
 .../admin-guide/mm/damon/reclaim.rst          |  2 +-
 mm/damon/lru_sort.c                           | 46 ++++++++++++++++---
 mm/damon/ops-common.c                         |  9 ++--
 mm/damon/reclaim.c                            | 46 ++++++++++++++++---
 5 files changed, 86 insertions(+), 19 deletions(-)


base-commit: 2c5f83f56c4a5ec75db054510007baaa1fbe4ad5
-- 
2.47.3

