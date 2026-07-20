Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 988CBC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCBF6B008A; Mon, 20 Jul 2026 14:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5126B0092; Mon, 20 Jul 2026 14:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3FC6B0095; Mon, 20 Jul 2026 14:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFDF6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4CCF140256
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:39:51 +0000 (UTC)
X-FDA: 85010018982.05.03C1848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D863100009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:39:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SLoo8cFp;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784572790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zF+e/1G0vzgBGsv1J53vfYEU04ziss3ABl+i/SzrfQk=;
	b=VXFmBC+LhnO6ZB5LZSBpOHhhCRe2LvYscd0sAK4W2Q9BffATNVKu5EsMQzmkSAEdsWPEM8
	QV8rs98da8KToeYqroDD/XNzjdEfuZah9fcJKZZWaYmI73iT9oNM3Gwn3IXB2yYrHzrgop
	KcNbVTYCxiXMVbN4+UR56nIUYG9hiLY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SLoo8cFp;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784572790;
	b=Tvg55+GhRQRuuhdH617zKc+Mk40SvvzWVae2ASUQPvoL/NEBoYtIMcYpTnPyizm/kBUZ9z
	3b4lIb45PIlNKMH0hymqpigpbvWsrh408vzFuKYidUUz5l5AO/zG4mU2ucH1VA65nNbP5f
	S8pansT+n/I1ZKKmrWXyc+qrfive/VE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBC1C60051;
	Mon, 20 Jul 2026 18:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624A91F000E9;
	Mon, 20 Jul 2026 18:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784572788;
	bh=zF+e/1G0vzgBGsv1J53vfYEU04ziss3ABl+i/SzrfQk=;
	h=Date:From:To:Cc:Subject;
	b=SLoo8cFpJ773Dt7r9HY9ZuvwYzxANVp2rYtJlT5cDRPMAG9lLUsdYRTaL/54Y/W5O
	 kVV4b6eXFbDj3ZYZa5hGXc8Ih8sJW/yZcTsmU3c8Lerzl5rIpZCg5WXC5s9TtRrZVF
	 uRgDJ9jy0ZJBHWiC0SI085XjRxm/bMNZkUY1Sh5k=
Date: Mon, 20 Jul 2026 11:39:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc5
Message-Id: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D863100009
X-Rspamd-Server: rspam01
X-Stat-Signature: gspasohiqh7dqbzseqguy4menmjodyth
X-HE-Tag: 1784572789-974942
X-HE-Meta: U2FsdGVkX1+qSL2Lbe1Cuy9JaY9uT79+T+Yu+v8RJFLYApI3MJEmtqs4x8mzqqf68IzriixG1CtZXIHhPZqC+PHN7D9F6PD6nRdu1IxhPG3PJ3VsX1lFQN1xXLf+DXJsFr0sw5b8/75FW9Jn0PdqiZveZMUviFsrDNfhGGBUA1X6AldSDmbVEwBe7LVOeRn6iZB72hfgrzQydz3axZCmGEODwC0zaVRusDzopMb/eqieLCYZMs9HJ9iy7q3q4nn08ETy5swzTiSc9XqrwQKX5xLyBtHbhBtH5r6Vrrbv0SmU3QyTRVnZuTKVHlN8vY178m64Z4Zh7XHmAMyvOQC9AwdznQQ5TGCgvq75OKjVlV4K1zzcdrk5Pb/wAdQOrRKiJ/qYoQbSD07Ro86/lyReRzzU85D6in07tAMCROOG1MEZOOKa7Qs3lifUzgUPtWU8SOssfDZIUNMAePBbK2GJdseYQ3gRZDWOolIW3nn1TNmHTSSNvuDhPCN2O+7PEir2Tx0dATIgSwvt7lakElD2qTtDy/7GD7GRYB5utJTCdzgrfrGHp1EwO5WV1iAwMhSIgoOHZ1BBtQwd4+Zj6b3e8mEI4MJ3zjHSfb4Lzw+pN8b39s8AyKwIQsdZ6WW/t7ZqQgWzO3Qz/Lb4fwhQwOBtNuwkYeEzm3o+UNoNhVi00mrxj95PluGE8s0hhdfZ8MItw12F3yVSEPGy2RumsfknIBGBQCGlk8oUIxq+owGk8oSojaNR4wM4qJ499U4d6sl0UjXTc8lpjgKoo9y/WWy2g/RZIpt3TYnHP7e1fd3S9/aRUFgxM9c8yKMMY9jk1XoWqydzJPYHnSRssDTNM1wF5PQgQ2Jx3nBRsG42LgpjM07Rrs1fORksRyZb9SJ6rloZXNeurqqdIR5ifPtKySb10pFlniqD77Hz/zcIiN2kFFP0+3HEmudqge3M2PyfesX32O+FtO+p7WmTIKp9VzZ
 hn5l4muA
 YRJNpE0XgVjI6haWpq5lMnRfDRHYrg8RoSrSYuPFlR6WJLRwInI6zobWH67LrH9HiC9iONpVd7kvE30fzl1ym8+wXRJ4PFWkmswFSVuzWnKXmuV4q5wwlFLOHg9/0on/5ig5T5BWoVtzDky+vvWrE9nBeowRTM3hBfePseCUPygGHuEMvxBWipIW1YrHf+Spj6S7hRMj4O1723Osh2fwohK6cyUWlLfgVJSaJqJL47plL7NMOAWo+sldTzmw0SI3ULXiqBRgk57mhZmpaumaKOIW7RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.

The following changes since commit 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53:

  Merge tag 'mm-hotfixes-stable-2026-07-06-17-49' of git://git.kernel.org/p=
ub/scm/linux/kernel/git/akpm/mm (2026-07-06 18:51:36 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2026-07-20-11-37

for you to fetch changes up to e57d6e9e20b551e4910d7a6331a81775c3ad6693:

  mm/memory-failure: trace: change memory_failure_event to ras subsystem (2=
026-07-09 15:48:56 -0700)

----------------------------------------------------------------
12 hotfixes.  8 are cc:stable and the remainder address post-7.1 issues or
aren't considered appropriate for backporting.  10 are for MM.

All are singletons - please see the relevant changelogs for details.

----------------------------------------------------------------
Arnd Bergmann (1):
      fat: avoid stack overflow warning

Breno Leitao (1):
      mm/kmemleak: fix checksum computation for per-cpu objects

Lance Yang (1):
      MAINTAINERS: add Usama as a THP reviewer

Michael S. Tsirkin (1):
      mm: page_reporting: allow driver to set batch capacity

Mike Rapoport (Microsoft) (1):
      userfaultfd: prevent registration of special VMAs

Rik van Riel (1):
      mm/huge_memory: set PG_has_hwpoisoned only after new folio head is es=
tablished

SJ Park (3):
      MAINTAINERS: s/SeongJae/SJ/
      mm/damon/core: validate ranges in damon_set_regions()
      mm/damon/core: disallow overlapping input ranges for damon_set_region=
s()

Thomas Wei=DFschuh (1):
      m68k: avoid -Wunused-but-set-parameter in clear_user_page()

Wei Yang (1):
      mm/page_vma_mapped: fix device-private PMD handling

Xie Yuanbin (1):
      mm/memory-failure: trace: change memory_failure_event to ras subsystem

 .mailmap                                        |   1 +
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 174 ++++++++++++--------=
----
 MAINTAINERS                                     |   3 +-
 arch/m68k/include/asm/page_mm.h                 |   2 +
 drivers/virtio/virtio_balloon.c                 |   5 +-
 fs/fat/fat.h                                    |   4 +-
 fs/fat/fat_test.c                               |   4 +-
 include/linux/damon.h                           |   2 -
 include/linux/page_reporting.h                  |   4 +-
 include/trace/events/memory-failure.h           |   6 +-
 mm/damon/core.c                                 |  15 +-
 mm/damon/lru_sort.c                             |   2 -
 mm/damon/modules-common.c                       |   2 -
 mm/damon/modules-common.h                       |   2 -
 mm/damon/ops-common.c                           |   2 -
 mm/damon/ops-common.h                           |   2 -
 mm/damon/paddr.c                                |   2 -
 mm/damon/reclaim.c                              |   2 -
 mm/damon/sysfs-common.c                         |   2 -
 mm/damon/sysfs-common.h                         |   2 -
 mm/damon/sysfs-schemes.c                        |   2 -
 mm/damon/sysfs.c                                |   2 -
 mm/damon/tests/core-kunit.h                     |   4 -
 mm/damon/tests/sysfs-kunit.h                    |   2 -
 mm/damon/tests/vaddr-kunit.h                    |   4 -
 mm/damon/vaddr.c                                |   2 -
 mm/huge_memory.c                                |  12 +-
 mm/kmemleak.c                                   |   7 +-
 mm/page_reporting.c                             |  24 ++--
 mm/page_vma_mapped.c                            |  31 +++--
 mm/userfaultfd.c                                |   5 +-
 31 files changed, 163 insertions(+), 170 deletions(-)


