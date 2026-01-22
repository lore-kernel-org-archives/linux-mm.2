Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E90ED3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6314F6B02B7; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4FE6B02B9; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F13D6B02BB; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2B26B02B7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E56718BB53
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:37 +0000 (UTC)
X-FDA: 84360218754.17.8383484
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id D120A4000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LR4F2R6PAnPX4z40dGn1Nazzul8J1/CW/226hDSbidE=;
	b=hu3Cscpsu25NI1xUrs1Xbitg7/a3Gd7TdFIZA21Pij3EjDnO3ixLAHXftKf5hQM9Rg/7ur
	FPWRqbwVCQKEIC+IhS0Dbl+OQcryXpuxYvC0oH1l0Zw62NKuWfTn0StCzP20U7aju/B/oq
	h1JbH3YGG3dAju+6YabnDjmO5EuaZKI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101356; a=rsa-sha256;
	cv=none;
	b=orY+gNSyQPkw3hJAHYwenXuUx2tbhve9lHLg0LkZa3BSH3asY0UKPxjFuaIXB7T0KE/LRr
	s0Cvm43PhsdNAjDObEUf1XsGJlPbTs2rGqctBzsHhkrGGLjjwKrHVgXolg686jsp80RywG
	fTSElhRnCd2qP2+x+1uq2+TX5nUKXr4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAD981476;
	Thu, 22 Jan 2026 09:02:27 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B71A3F632;
	Thu, 22 Jan 2026 09:02:33 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 0/9] Various mm kselftests improvements/fixes
Date: Thu, 22 Jan 2026 17:02:15 +0000
Message-ID: <20260122170224.4056513-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D120A4000C
X-Stat-Signature: u9y88kky8rcawp9yrjqfo1o8kprx1hie
X-Rspam-User: 
X-HE-Tag: 1769101355-883341
X-HE-Meta: U2FsdGVkX19YfJgvvZdJg9W2h4khU/mbzxS9VOIsZLwbvj1DfWTVX3Y7aGWwXVkXU8N4258w8QWsoSkCzg93LkwgC1Q0hF1TWr7J5WsC54/8gceogGimPGwhWJx1tj4pZIGJIc8v2AFgUUK31tzrViXK4S1KIoUVUfXZH2WlY3nFGUs3YgdtHkeOzfXojqwTjb/k+Z82GTJZc85R3RMGvtZGHfx9vhYLaDGH/sXcSA/PMc3WLTmvkpKqNbjn/nKzW2ieee03lJUClL77a4qKDt0R5nni1BiSOrRQRqJnL1Qmm4FUjkFWuEs8attOmvyoeEP2KNVnKc65CTFJj1+2th5Q3c/GzEmmKqaQUK5q/1AGIGMdZaaQT7wCHUDigytBPzp+lfEwa2Mny+bGxgPqt8oM0UZji9dSEtk9ycpi/1PFFn51gg0kAF8RNqlaZ41ouw0R9adHgneBk8KiRPXstRH3b+Skyxcf/pTKPk3WSxkjdWsHRzreJpfKocokH63R5vxX2dQEXZuoJmS/vShCSh1KIlvuJD54uFCRCymNR+MLqo/mc2fkQBvJLlnP2qImOYcPjnVsIf5Bo+JwlT7XanJ/q+w75hCBVaSUaZVCD92XBaCxZP+BMWSnT3tK/ZzfJgwmce+C5izicdIx/UTkvBjmLppwi8Q6s0vnJO3S8XQNfX3hTUCexgv0fyVh3zad3uYriBWi8ZRqgsr2QFx5H8TdQTYjS277Lh/g2VRhJRrNYnUEvvu7rcj/NBqw8jhEIVlBIYmnZnbviqR/TzqjXQaFH7TD0KR/uP/8CPIbu7ztfZf5C3AI1d4C8WsUgcUgZt+shOY7ASGw4I93txXIrW3GkdodFxwI0wzkhkywJ9Fi292PB8iAyUDzUh6y8Kq0spnhSAEDR/FfMxxdhUEWpw01KkzjBX2AMOC6sgKYTFfBtLCEU8MqGoZ16Eejj8gyH+fx8DiklFBtr4I5OIC
 M6E2osFT
 VLMEbqT+qzrU28p2IoIS5882UckHvKiWlLCCYKtKlTHhnVmELQTFruZQFs7phIWHvmNaiEbEC0LOvB9/cmu56ssJIfNviuSZhfn/cT/zjsOPI+IoKaDTmcW/lJ/vgveJ1dZBg2cCGQ44IU8TTusKd0yDaseKbafoIzJDDBT7qK0BFS5OLZDtee3+h/0E0rKJdzBDvt3OdjeUTmpRm4zMocOh/V410g8D/PzucpKo8/5jAV3OJPL0HHvHhnZZvx8BuBLoK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various improvements/fixes for the mm kselftests:

- Patch 1-3 extend support for more build configurations: out-of-tree
  $KDIR, cross-compilation, etc.

- Patch 4-7 fix issues related to faulting in pages, introducing a new
  helper for that purpose.

- Patch 8 fixes the value returned by pagemap_ioctl (PASS was always
  returned, which explains why the issue fixed in patch 6 went
  unnoticed).

- Patch 9 improves the exit code of pfnmap.

Net results:
- 1 test no longer fails (patch 7)
- 3 tests are no longer skipped (patch 4)
- More accurate return values for whole suites (patch 8, 9)
- Extra tests are more likely to be built (patch 1-3)

---
v2..v3:
- Patch 5: new patch [David Hildenbrand]
- Patch 6: make the helper take a number of pages + pagesize, rename to
  force_read_pages() [David]
- Patch 7: improved page count calculation (avoiding floating-point
  helper)
- Patch 7: added Fixes tag [David]
- Patch 9: open the file only once and save the fd [David]
- Collected R-b/A-b

v2: https://lore.kernel.org/all/20260107164842.3289559-1-kevin.brodsky@arm.com/

v1..v2:
- New patches: 1, 4, 5, 8

v1: https://lore.kernel.org/all/20251216142633.2401447-1-kevin.brodsky@arm.com/
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
---
Kevin Brodsky (9):
  selftests/mm: default KDIR to build directory
  selftests/mm: remove flaky header check
  selftests/mm: pass down full CC and CFLAGS to check_config.sh
  selftests/mm: fix usage of FORCE_READ() in cow tests
  selftests/mm: check that FORCE_READ() succeeded
  selftests/mm: introduce helper to read every page
  selftests/mm: fix faulting-in code in pagemap_ioctl test
  selftests/mm: fix exit code in pagemap_ioctl
  selftests/mm: report SKIP in pfnmap if a check fails

 tools/testing/selftests/mm/Makefile           |  8 +-
 tools/testing/selftests/mm/check_config.sh    |  3 +-
 tools/testing/selftests/mm/cow.c              | 43 +++++++--
 tools/testing/selftests/mm/hugetlb-madvise.c  |  9 +-
 tools/testing/selftests/mm/page_frag/Makefile |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    | 15 ++-
 tools/testing/selftests/mm/pfnmap.c           | 93 +++++++++++--------
 .../selftests/mm/split_huge_page_test.c       |  6 +-
 tools/testing/selftests/mm/vm_util.h          |  7 ++
 9 files changed, 109 insertions(+), 77 deletions(-)


base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
-- 
2.51.2


