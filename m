Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FAC5C55162
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 02:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414656B0088; Thu, 30 Jul 2026 22:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C55E6B008A; Thu, 30 Jul 2026 22:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCA76B008C; Thu, 30 Jul 2026 22:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF2B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:33:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 888B112031C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:33:52 +0000 (UTC)
X-FDA: 85047501504.29.67DA2E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49F54160008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:33:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vXn2Q/hq";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785465231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MXTkaWVkLpWzsxbU5LuJ4tJlgacPdbaDXNtji94Vx64=;
	b=ofsW8SyEsmeDRUwRl/MUgyW+Nlbz+lHHvNi4OMhVoNLysuQsa89qQvp9KgsPjLOQ+KPnZK
	Ml56UDD42qrxSU5OS72BfR34JV/ePkmUCz02qREACehaA2G8BXVC421pudcP0Jz8Uv5NFP
	vwY1poBhDeCNxGQP46Nuh9uE3Sx66+0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785465231;
	b=gYAzO/A43/pBkgqIHNgi1l3tNQf5MxuzZEsgQkgvFAtcsz40s59Kx+ycxrzysItGC2Xlk3
	H26bHAypX+DoKLoQGHXhxCYSRHXcuq71Mb3MBe2EThemYA/URkTZrfzBJYw/j4WRGY7u63
	5qp+15LwoDbhFLhLgWUUgYOsTrKhg9U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vXn2Q/hq";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 887CD40549;
	Fri, 31 Jul 2026 02:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445BB1F000E9;
	Fri, 31 Jul 2026 02:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465228;
	bh=MXTkaWVkLpWzsxbU5LuJ4tJlgacPdbaDXNtji94Vx64=;
	h=Date:From:To:Cc:Subject;
	b=vXn2Q/hqbJUiXIklsRKCJC0R5I6i2JOcoD/WyH1vSqUrH7JRjbOgSypPyH9BosFlx
	 O/0KEDGcR/22hthqV3zXMLVS40+NUamWMYRibVJgfoLZYD2IPjTsAqHI08wwEV0qrQ
	 bIDbx0crfdBkDNX+OaYBLcsJZj9jmKvj0lUnBcBc=
Date: Thu, 30 Jul 2026 19:33:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional hotfixes for 7.2-rc6
Message-Id: <20260730193347.67069b3a7254649fb89c0956@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o4g7y9dsjiabdrrzih8i1e68ckf86pxn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49F54160008
X-HE-Tag: 1785465230-562512
X-HE-Meta: U2FsdGVkX18RYSZII1u3YzHkxc2s1q8qYcemfaPRNf9mtUwGvnUTYGVQBtE6emoZmGdDy9eukQXk1Gwn7s+PYQg228xrgNLItMGmOuqban8bXmbe5g/H4xJwIbXbsZMRoqi0QRdBaiKYBJKCAbyU/Q/pMsAmxKPF+FY4wAFMLgi5vRCqlg2y8XpCTlD/y+TrlBjCgZJ3ZnJ+9uy8/ATzhHyMqkDMX+ndMwLpInubUBL8dspyKnjh/AHac3xKHmmmQ41h0oneNMZNybHko7+D+X0GcF+Znmpyoy4oVj/Qw9o0tEEtFotX2CyiHQlEZ7lGcd8GDZ5lj2JGDDIVgm+yzZ1BmbBN/d0CBGr1B2FfR8HpyHkN/6OZoFofy+u39BbCxpeuPrUWZJMcdKl2c91PRG+YOHey6fI5hz57fOyKoiKI6Qp30CVJ7JmeFRt1AtUkgvGDGv5xOvmxsiiadkH+9UlJcvtiuEgz3/T+6Hwoo5SgFesDy/CFBxriFxK4PthI+1QWZk/nRvAXRLN+csbVVitL6Ehp3dQT+ayOCNuyEGG68HS2SG6g4OAnDuxYFsnqIb/F8+aBE86vhIvSjZt8svFaloUa6V1QRT9u8i9HBO8cYV1MrDt9Wa7lUnVZSN8SKvyJjF5rmWZLKhozg/2OydTa9oqeGe51VYVcOt4Uz968RloSkgo+Govpr9EZDh5j1rtr/MG4ICORH+5bLr6Ao31wUzB49dJ/KbpXjd1Kgy/47rEswVOFRPr5Rrci3t2CimKiqJemY/yiEb+QKcD5n9JbE9wp7za8qXSV8lMXVw0WAqnri32eMpgsa42ZQqDc7bJhOIpzphK78DEeJYtTlTmBYdJAX58cjmEgzigydTYxZCFlROa4VgQbWf1Hu0GAd9PIGM5zvQgUAwtKiU/RYIfpbCC71tMOyC7CFSrPP73dekZobcszPf6WMdGtzGRGWmverujZ5Hx0yqoXZ9O
 fcaKwc0Y
 fPXfwjXLGTitf5YqpuCMffx7rc2twwdnd14pr4BEVapS9TozZ+1EFp5IuEJXh7eoQruoxvUf8TxbnpU9bdYuR4zQPdlXDpewTxBN3dE0cPlvp4s0siej07qmnPje0TsqQuWn3b4enMKGActrbN44atbV5SXxS+XuwVd1MZXIE4m0DCjkKjjN4leiMf7ui1JLB3belzSi5hZd1TfzznxqD2kj/5P4F4SUggIH7WxlktpIcEpv8SszztAoIDJMSJoTmlFCnmHENN875Vqn/BFNPru4MCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this second batch of hotfixes for the upcoming
-rc release, thanks.


The following changes since commit 62cc90241548d5570ee68e01aaba6506964e9811:

  Merge tag 'mm-hotfixes-stable-2026-07-27-14-18' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2026-07-27 14:36:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-30-19-30

for you to fetch changes up to 9f1d75a4ce04095afdb63d8e540092ff8151dacf:

  selftests/mm: fix potential wild pointer access of getline due to missing init (2026-07-28 17:37:34 -0700)

----------------------------------------------------------------
12 hotfixes.  6 are cc:stable.  9 are for MM.

There's a two-patch series from Nico which fixes a couple of PMD level
mTHP accounting bugs and a two-patch series from Chris Gellermann which
addresses mishandling of getline() in selftests.  All the remainder are
singletons - please see the changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm: memcg: initialize *locked in memcg1_oom_prepare() stub

Burak Emir (1):
      MAINTAINERS: update address for Burak Emir

Chris Gellermann (2):
      selftests/clone3: fix wild pointer access of getline due to missing init
      selftests/mm: fix potential wild pointer access of getline due to missing init

Jiakai Xu (1):
      riscv/mm: use physical alignment for vmemmap_start_pfn

Kiryl Shutsemau (Meta) (1):
      mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios

Link Lin (1):
      mm/page_reporting: use system_freezable_wq to fix UAF during suspend

Nico Pache (2):
      mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
      mm/migrate: exclude hugetlb folios from MTHP_STAT_NR_ANON accounting

Nico Pache (Red Hat) (1):
      MAINTAINERS: update Nico Pache's email address

Peter Collingbourne (1):
      arm64, mailmap: update email address for Peter Collingbourne

Richard Chang (1):
      mm: vmscan: abort proactive reclaim early when freezing for suspend

 .mailmap                                        |  3 +++
 MAINTAINERS                                     |  4 ++--
 arch/arm64/kernel/pi/relocate.c                 |  2 +-
 arch/riscv/mm/init.c                            |  3 ++-
 mm/huge_memory.c                                | 12 ++++++++++++
 mm/memcontrol-v1.h                              |  6 +++++-
 mm/memremap.c                                   |  1 +
 mm/migrate.c                                    |  3 ++-
 mm/page_reporting.c                             |  6 ++++--
 mm/vmscan.c                                     | 12 +++++++++++-
 tools/testing/selftests/clone3/clone3_set_tid.c |  2 +-
 tools/testing/selftests/mm/mlock-random-test.c  |  2 +-
 12 files changed, 45 insertions(+), 11 deletions(-)


