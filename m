Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B3C1CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7F06B0088; Wed, 13 May 2026 22:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598396B008A; Wed, 13 May 2026 22:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE256B008C; Wed, 13 May 2026 22:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39F756B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:01:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC8AE1A0502
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:01:09 +0000 (UTC)
X-FDA: 84764372658.26.B1F3690
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E9211C0008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:01:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUTMkvAk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778724068; a=rsa-sha256;
	cv=none;
	b=5WVLn+XnDdRDnep/t+L1pYBsNW8hhnNRKL78STTBf8IsWF4LvawsChT8Nj+aj35NNyLa44
	hc2rHZmlhXSJqc+n4F+pHaotFgVu+CAjJEKA7M4I86yieGBfab0AppGobIRp7GMq6ituUU
	3K1x/7BHbyudr1F2cBymoyfK9zMdXdA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FUTMkvAk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778724068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHgXUn5rlqohDCyyKsKIcqwhgboHDM8aoMnTCoa4Ab4=;
	b=M/JfjqXq0YFXeFRRa8a6ZBb/NiQvT8CZG8b0VcTmOw7+PqNrLukbIgpDQTcnpdTmumRlFd
	K60EQKOCWEEoJMDhPw2GvMDAsM/6Dgs4PDj+KIpKrXd114aJzVFaZGITobez57xG+shnzI
	LguW2dHU/+JuQMFQXpkrDdNbtly61X8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA8AA60126;
	Thu, 14 May 2026 02:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4CBC19425;
	Thu, 14 May 2026 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778724067;
	bh=PVPkU3ne7pVBIY+H4ldRtFU0h2eXvyRq9QB2pPm3898=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUTMkvAkpNWwVjP1QFFbLfKc2TIJxLZJTkFQ4CsNt8ZPIzoQIsvzERPUuIfHudzKc
	 JLk+T8i9wQGmSBCNhHM6GSWZihh6JU/g7OeBlHm9dJJ9YBVaI/nvZA1oKqFAXIR1Fq
	 Xmb0h0hrxlyzJQP+LmvFzu1nMUVKxVys1qo+QR03joB68UU1ICbAohRy+cC+jXwMWV
	 UlyWh5XMjgWf3d9XPv+2bljVkf1g/vAE2q4EPsVJabNH0/ZTX26+b8GPGwoYCCNYBJ
	 cy3Lwt++lbCFiMq3nOaSaDGrUQuHIYrLmSZkBcN2V5O/ZLlNCsxz0VAwC9LVr2TI3U
	 xOSXwe7ntqerw==
From: SeongJae Park <sj@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sunnanyong@huawei.com
Subject: Re: [PATCH v2] mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Wed, 13 May 2026 19:00:58 -0700
Message-ID: <20260514020059.149541-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512151523.2092638-1-wangkefeng.wang@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zf8asc6azk41hkwcoe81bygxcpe7xrmm
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E9211C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778724068-908162
X-HE-Meta: U2FsdGVkX199K7CYsJDdOfWDC/H9THult2Sj1+PnHSQ4y5p5d7t6zUd0pJkjlEnYk+t7u0CbfRCSI2QDjOCKUVptnvyVTe2nyEk0+FRjPofWCzLWIfBjyfcm7FV3ZCz9u2ZlJbKNf84DXv2Lg/ave8D4eH5umVffhAooIuKsB67xtB8ydqkjIRqi6HF4qLwBnLukTS7Wwh7zseIJA20h6tLH+B6lZFZqYSvNGYAdBr7/BKsoi5LyLpuDH+GtOAf8tWHjS0tumPthwZMSPFtBxUS8rQSk4LRjuqy2p2lVjZqFFUDpRATmzPz7K1IyA+iLn4F1b8+x3xlT9EwMB7qFpODFT8HnWAaFYTMHWHujpfq6kmEnUqYtZWsagPfHYSTK/jPLixNaLJGhh8LNhWe2Y2FFLunV/jANDKaYEX7Lb0/EO7yn9cndgffXXv78i55ZEF2gK9vNyRx1FxYF0WXXtxsKZY+LFZDEEtRrRYEN5PjlvnBaLvjkOA5FKNsYqFiPumBj3bI8p07/t0qW+o6Nu/xgOvWQLlDcl+ozy4EIpH2EI0c3ouCwD6NQTyuYVXrSDbHVQBt5CvW+yfv3mkIXP6jETJB7jajYrPjw/CSuXhbFGS7axc+BrPnF3PrvPsAx/E/6qcaicwJArNBZrk78vPNB+9DOaD/X3R11a0eI/ZNDYtdw18fPs0WS9wRuIM57YJyTvB0QkPF3zse8cddOl9geXl2AW3skFzQCOgUB4qunfHeJHTrmoLIjIcklXqLPxeUeEZP35gP12X0VJYJQwUD7COw3yUY2dLkl5VoExQYPrskQ9cVAgSyaQDadEI3OTY4Gkrb6MowsXJvRx7FcqRe0fP/wI3ttVeYlmocUaNLvsMfI01k+3xHcBT1vXUVzHEL0s3L0w9aX3OFca4niQRVZCvzspcAY0kCohWXrKdVQ9EOV28gummQ1a6VubhRHAo9nEPdKNnrvnsJZTOU
 4o6Vhvci
 Ht04pLk8Rrpk6HGeu1bjI93LLnBlaMHFnaqS/mm3/tcO4jkNRRf55UiibzF8GatR2PmRNf9NB8E/hF7DyUJfqNk4tDw+SMBFTKtiZ2Gpqw4Yrh+PAt8Qh7Vngg0vHD7u03q+rJ3in5P63qoKGi/tsadmv4StzZD04mM+ICn7X6ynd+YrZo8GzFk7DqAH+WeNAkyPD0zYQwcDE7tq3m6xA6N/BS/Bm4vEI6uXA2Zn5YCF4wkH4y2RsjAGMhkDuIJGKKDxX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 23:15:23 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Currently, DAMON virtual address operations use mmap_read_lock
> during page table walks, which can cause unnecessary contention
> under high concurrency.
> 
> Introduce damon_va_walk_page_range() to first attempt acquiring a
> per-vma lock. If the VMA is found and the range is fully contained
> within it, the page table walk proceeds with the per-vma lock
> instead of mmap_read_lock.
> 
> This optimization is particularly effective for damon_va_young()
> and damon_va_mkold(), which are frequently called and typically
> operate within a single VMA.

Maybe this is not only making DAMON faster, but avoid DAMON blocking others.

And because we don't have performance measurements, how about making this
sentence less assertive?  E.g., "This optimization is particularly expected to
be effective for ..."

I guess Andrew could make the adjustment when he picks this into mm.git.  If
not I will repost this with the trivial change if you don't mind.

> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> v2: avoid handling VMAs with the VM_PFNMAP for per-vma path, found by
>     Sashiko review.

This patch helped Sashiko finding [1] yet another DAMON bug (impact is minor
imho).  The bug is orthogonal to this patch so there is no blocker for this
patch.

> v1: https://lore.kernel.org/linux-mm/20260511132546.1973270-1-wangkefeng.wang@huawei.com/

[1] https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org


Thanks,
SJ

[...]

