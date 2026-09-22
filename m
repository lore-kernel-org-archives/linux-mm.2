Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80205C982ED
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8DF6B00A4; Mon, 21 Sep 2026 20:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9E06B00A5; Mon, 21 Sep 2026 20:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0946B00A6; Mon, 21 Sep 2026 20:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6D556B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:17:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 412AD1202DE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:17:32 +0000 (UTC)
X-FDA: 85239484344.09.A9AA3C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7478B80002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:17:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KMC4xYnt;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790036250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/UYKcugE8spIFiKcC7kZ6CdbaDdEeSfmV8Pu82NJ678=;
	b=vXvS86RY3Yl/nM3WnjpCaBENnql1Kvipk86gH/8kyaJgQtxegGeAPRNEDAi5uS2PpGr8qk
	z+BK28N6teUzL1Rq3164nxf26OfEOqPvNR1scHA1BcigkKeqJYiUXbTp9+1vPThG4CoRhl
	hfhNb0rLmYntApMt6MNSqx0xmOV663k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790036250;
	b=lsttkokQkz8c3GUaf7BVzXollqww3tJ6L7SBF9pHU//03zFHtG5VgMb3Yz43sbCWVJzBw2
	g/7s0Jz0JOJmJ076cU2qfUYqxVfCnOtXzXCTtmVXReHeFxxaQKNYbHwjLmS4ReKjDAUYG6
	3kDKmoGFtGzoDxo/AvEv25sfUHzHDfU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KMC4xYnt;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77A4241AA9;
	Tue, 22 Sep 2026 00:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335BC1F00893;
	Tue, 22 Sep 2026 00:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790036249;
	bh=/UYKcugE8spIFiKcC7kZ6CdbaDdEeSfmV8Pu82NJ678=;
	h=Date:From:To:Cc:Subject;
	b=KMC4xYntSdElwCNoU+C6yj6ZdOuMg5Xw+qn2WUzeF7K82QLDz1TeTgImvHpsmCXDD
	 UTkqhSpd3k+RUVCT8x4CT2QvxCkU0A7GgakYoyI+i7vTDw9929YwYr9ORNH/KMI7J1
	 h5PameJq5T5vIrYhQuh+6d4vhUAfpPYYeCQ84j7w=
Date: Mon, 21 Sep 2026 17:17:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM hotfixes for 7.3-rc5
Message-Id: <20260921171728.57318b258faaa20e78c81b73@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7478B80002
X-Stat-Signature: nwyahm8mr46re5ocboqbk4k76qhpzh3c
X-Rspam-User: 
X-HE-Tag: 1790036250-511254
X-HE-Meta: U2FsdGVkX1/CrdhGwufbnC9qNE8jbvmGxXgSEgZfH6ITU4QFV9E3HRxQJxhFehkKiSYO3rSWXG4E3WbKijSKIJGGfnQcoBN3kVCtbI/hvwGwqzXNuyfIpSHpqyJ2y8SVswyLrFx/tnznSvnw5DUzNdsPAsAWtFCs1rABEfFELqXund+Ph8XtwuBLMPNoHDNeodeEnsPH5rYlJwNIlpdZV9OVCDlLFMay+SMFbcBcffqe5oidq8enCTmxD9NMdxoRMmmAcxg6tesuP33ftTpzYJqCVbWeB/JWxHssRwnNps46/IEATSOuwC8Dy4cjwvX6mDveAhnTuli36d5ZELNu2fqBzxbT+yfYGRoj3/8L+YUfhyotHg+eBAC0S7/eVN2e9qsQ4ghRU3HzcqEZd2XoeRm8lo8Ojb5OAb5WSu3k5EPgzByZHkJHUzhpkVOncO4YLFj6LKMV4XivQj3H4PxsXeeHRxvsToSpH2i3yuJNNA+ebVRYlQsjVqqiEZri8R375R97PUq8GOLFx/XYyVvv8cIO+lL0ksp5gRvY+U1owXx/Z6zy1WbtwkvxK4D2PnF3GkcylWMIf8MsIh4eQmvUFSTY7nUSGsh7xdiTSHiabPzwpiyJ+kbAbYUkqzt1b5TsRL16ASfY5OHzKtku2dAZ1dA7xwafFEs5Yt123nZ94iqt0jt2PaSY5TYKBT1Jbg9G9M18YzPWPkmf7hEcdiykaOIlNd0X2ZyBuN+zCmIcag9y1mMRxi73jr8AeHRcsX5Llp7BmA4rz3ooIZfzjIogMXNZQEQETMPZ6+wd6OLipBM9qCYOGewyswXqOt3tS2xJzDRwE/oagtjZ9IetIB+9mghmZIxXbUqJiRqF2U/V+uKcY8yKfh7Cvj8bl/lsgJ512PwS0n7flRx6OupoD+VV+U0M/1zVQ2+yQ/ztF+PPoezY8/L/lP4H+vc5UtRuPFqG9CvE2KMbKeDLc+cO6Mp
 rMsFyeYl
 ndyKtCFgRHxLyohfXhfWMp6Gwyqs6oBea3kWHFNvblkt/BhiR5k4Rb7iueMF7gbc/fUFYBTlOuIarr5Lli6y0oQnstuXXxeFV1Lp19geZbauJCx9FL2humVMubzZF2Sei3J9EjrJTB2mtRP9rJ6qXsMHM7L7dZCftGRxc2iofsc1XMClGsmSv+GVCAPHPA/LT/GfPbMLzfe3FG+9cHrcM15I+NW3MFtcxknXSVnNhXPwzJzyDpCfKGB3zCI3p//yOH7qnGj33qwxbQoHKOyxSMhII/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of MM hotfixes, thanks.


(yes, "MM".  nonmm material now has separate hotfixes branches so I'll
ask for nonmm changes to be pulled separately)

(ok, there's an ocfs2 patch here - that's transitional)


The following changes since commit 7891fbb9512f127826e1d5dbf380ee212bd15eb0:

  mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio) (2026-09-08 23:28:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-21-17-08

for you to fetch changes up to 692dd08e03f4a5523650e055f033f846bee43a0c:

  MAINTAINERS: update Xu Xin's email (2026-09-18 08:20:15 -0700)

----------------------------------------------------------------
14 hotfixes.  10 are cc:stable.  11 are for MM.

Five are DAMON fixes.  One fixes an arm64 contpte bug where DAMON can
write past the end of a page-table page, resulting in memory corruption
and possible crashes.

Two are hugetlb fixes.  One fixes an mremap() address calculation bug
which can panic x86-64.

There's also a missing anon_vma publication barrier which can result in
hung tasks, and a writeback fix to keep long cgroup writeback drains from
delaying Tasks-RCU grace periods.

The remainder are smaller fixes and maintenance changes.

----------------------------------------------------------------
Baolin Wang (1):
      MAINTAINERS: add Baoquan and Baolin as MGLRU reviewers

Haowen Bai (1):
      mailmap: update Haowen Bai's email address

Jaewook You (1):
      mm/hugetlb: preserve mremap address delta when skipping page tables

Jinjiang Tu (1):
      mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish

Josef Bacik (1):
      writeback: report a Tasks-RCU quiescent state per cgwb drain pass

Joseph Qi (1):
      ocfs2: make ocfs2_calc_xattr_init() return void

Joshua Hahn (1):
      selftests/cgroup: account for zswap shrinker writeback

Liew Rui Yan (2):
      mm/damon/core: allow esz to be set to zero
      mm/damon/core: fix unconditionally skip last region

Longlong Xia (1):
      mm/hugetlb: do not dissolve gigantic pages without runtime support

Nathan Gao (1):
      mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()

SJ Park (2):
      mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
      mm/damon/core: reset invalid quota->charge_target_from

Xu Xin (1):
      MAINTAINERS: update Xu Xin's email

 .mailmap                                    |  4 +++
 MAINTAINERS                                 |  4 ++-
 fs/ocfs2/namei.c                            |  9 ++-----
 fs/ocfs2/xattr.c                            | 13 ++++------
 fs/ocfs2/xattr.h                            |  8 +++---
 mm/backing-dev.c                            |  5 ++--
 mm/damon/core.c                             | 39 ++++++++++++++++++-----------
 mm/damon/ops-common.c                       |  7 +++++-
 mm/damon/vaddr.c                            | 21 ++++++++++------
 mm/hugetlb.c                                | 20 ++++++++++++---
 mm/rmap.c                                   |  6 ++++-
 mm/vma.c                                    |  8 ++++++
 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 13 files changed, 121 insertions(+), 51 deletions(-)


