Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F257EA71A1
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 18:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541EB6B0331; Sun, 19 Apr 2026 14:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2B06B0332; Sun, 19 Apr 2026 14:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4088B6B0333; Sun, 19 Apr 2026 14:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE696B0331
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 14:58:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA7D688C9A
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:58:09 +0000 (UTC)
X-FDA: 84676215498.29.33C3D43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16737A0005
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 18:58:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MeaOdJvr;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776625088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UlcZBMGfFUzKWb2uI23mapL35FR+O1YGeWxPVfru/8U=;
	b=v87iK9Atu0771WkgFmZkM5zfRNHvX/mWymvPWrnMxOrbvp3vSVQcsb+ib0kwauq07n9NMv
	KHXeCrsa+3P9JzakVINoE5s/6gTswDHednupYqMvhVeXJbWn+W4b5e+3q7nmIrK0HyA9Yw
	3r02lAo4WinDQNDTYNl5eTxTgwiz+8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776625088; a=rsa-sha256;
	cv=none;
	b=ZzKB6tr46a6KSlBzxzmgs5f9YZsd3jgbBKxVFLISvMoNEqUGfFK3RpboOPN09aouaFprGF
	KWeCZy8xhMqbUZQp31/smtZs6mQ3WdT0b1vp5kwGsn3WaAFpEGRdzRUe8LGs9Q5u6kBwp2
	9aVLpsCpsSaWmNzSpkZL9prtVlnPY/0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MeaOdJvr;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36E6760055;
	Sun, 19 Apr 2026 18:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6C8C2BCAF;
	Sun, 19 Apr 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776625086;
	bh=CAqM4bvw0YeWw9r12e8drmX/Cr6gR/EV7mWkDbWCPAM=;
	h=Date:From:To:Cc:Subject:From;
	b=MeaOdJvr6yNYSLhouxj3bvt2us4R072sqt/YzQkN/NPtq9eFOHSzvs6CrSJaaxkxL
	 bcfTRffRMeu+y0n3Giw+uHYUbNHpQm82gISjcuxQRdrCnwcoNEHAa0le7syt6ShEkb
	 tuouqFcuONrH4wmeoNymsn+oE3KMXbx3j05M0rU8=
Date: Sun, 19 Apr 2026 11:58:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc1
Message-Id: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 16737A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: n6yxhc86ynabm9rrnhbkgssgtfizcnzf
X-Rspam-User: 
X-HE-Tag: 1776625087-834013
X-HE-Meta: U2FsdGVkX1+axOmNWSVzO3oa1C62aGwISU40gJL/bcsKwOp1o/r/dmrfP/ANIpcYelNTmx8+012DT3Jp8JMtHnfEFAyX3Xouan7yog/m+gvo9IYARYV79p0lTIbUUC3wJ1VvZ89Gv2bGyAMR9p2O4sl1mUlfJFIiv496AB5Hp6x2mun9fAHz2/wREAL4vR43d5vzYs5a26xdb7j5YcEwWBbxAUqssZYfJuleAn6HLJiq58l9mNFgZYTFFD52I3k4BijI2CtaouOCNoZSuRGGElAN/vsCkzTQJE02va2D3hlSWVe9Qpk1ag7gdhfbft+a60GE1XYDbbBSeGjWcRGAMaNUKiAIZMA9O9RqCHG7HXHRabDD8pNshELMDeh1P87AIij1gW2bq2nhpfVdscHLnufk4hwrT/UBHxWYhSg9pagntip7elmkO3xRZla0LPIN6TMO/wqm6M0SDckl7WKKrnTXiQ5ba6l84vLmAgPRzroN419NoeUEUHszXJ9tL4qnz6OVEtGXaxAGInpyrwZtzSFoh+7tnjMi/dTGrW/1gwMCiiicWgljXLNhrKIzy59vBA30BvNSHWNZlWeBpOprUIaW8fOUc1Z8KSAiU3a49Y5skmevZwu3giJyoZ62H4QSzpwnbB63Vqm1PvNQL5ZSt9I5LoLLWYCjMm5GGc+mWagd64QX4bZSqFj2kANH6ITUql+jutS+akPvQYo/HIkOjSmLwyczBK86HDY+25AefwLfaAk350Fn9x1S2xd1NJOR9xjAALbQMpwk968QW7vJX0wVDeiHOCvOEItT2eMZY2Mis3caz0j5rqmDr2TlGgTq4oXg+pvqypT4lAQz95Lwyk8R1TDvs5txa88i0Kt2yX3Q/1NR9Ud8UZcOq+SLf5m9lAmFCc4ZUgCeyV3Gkd+V/KohcMgbRKz09YJ+PtGiHUGPA0pobwcf7/iscP+qxyk4KbR0bBo05wT9MyZIfCz
 myXaoEW5
 +orWNU10jqdS/XaEY3M35Lgyb7Z3jc/RYYhyL8aGyXyXxSw1hzIEaokv4kvfeZm/Sgkp+5swNdMY2jQlRkOYM/XUgpuDPu/s36vk46DJ+RmGRQzh4yqDz45OnWgU+WHVKVb0BUpxUDxq/nkSOEZ9L/gsXKns/pn7fuhEb7Beh1qGQ3nAa1xhcZQ2xs5DIopfUk1XceRvbBbzcccwRYWvPiX68MzQcoKj/j+kq7RRfTAu+HLo28rR+mh3q7lTbV050INDV060MefLe2gQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 7bc5da4842bed3252d26e742213741a4d0ac1b14:

  ocfs2: fix out-of-bounds write in ocfs2_write_end_inline (2026-04-06 11:13:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14

for you to fetch changes up to 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a:

  mm/damon/core: disallow non-power of two min_region_sz on damon_start() (2026-04-18 23:24:27 -0700)

----------------------------------------------------------------
7 hotfixes.  6 are cc:stable and all are for MM.  Please see the
individual changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()

Joshua Hahn (1):
      mm/mempolicy: fix weighted interleave auto sysfs name

Matthew Brost (1):
      mm/zone_device: do not touch device folio after calling ->folio_free()

Matthew Wilcox (Oracle) (1):
      mm: call ->free_folio() directly in folio_unmap_invalidate()

SeongJae Park (2):
      mm/damon/core: disallow time-quota setting zero esz
      mm/damon/core: disallow non-power of two min_region_sz on damon_start()

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: take vmap_purge_lock in shrinker

 mm/backing-dev.c |  5 +++--
 mm/damon/core.c  | 13 ++++++++++---
 mm/filemap.c     |  3 ++-
 mm/internal.h    |  1 -
 mm/mempolicy.c   |  8 +++++---
 mm/memremap.c    |  2 +-
 mm/truncate.c    |  6 +++++-
 mm/vmalloc.c     |  1 +
 8 files changed, 27 insertions(+), 12 deletions(-)


