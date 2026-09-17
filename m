Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122A3C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008D66B008C; Thu, 17 Sep 2026 10:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9C46B0093; Thu, 17 Sep 2026 10:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F756B0095; Thu, 17 Sep 2026 10:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7A1C6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B680A03BA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
X-FDA: 85223469282.02.B897951
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CA3B6A0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gb8759cU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gb8759cU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654939;
	b=G6WGyWGpJRtGQuWneROGJclJY1XZOhS3MNsfPJUL1gl3ES+hT0VjCYzUVp6Pi0rLBi3e9g
	SiPwYC2JkeHBdGTpeX6z2bsYL+FNRXoA7ehB0x3cvwFO5u0WYqGPLA+8vCvjIo9o6PJBvV
	RC/S/dVE817W4ZZfpltgiTlKdgOUt6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tjofGGPSHVfcqzboPWJ6IAtm4wQQNel3C2UWwfDef+A=;
	b=DIZTrN9R0TOjP6x+sirvD7tnNldn3vR0rpS2kbHlJRQtdDNyfIE7q+MD7+Qup+/EykRQfh
	pMotNX6tyBW3f99cS3i1L+ct2V4ljEomCXPj5JUW9ISqxpn4mkFptzB931OunklgfxmVdb
	J+STgtyG5hkJSLV2OApWyVLTy2Kv7YE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E31D260052;
	Thu, 17 Sep 2026 14:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5FF1F000FF;
	Thu, 17 Sep 2026 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654938;
	bh=tjofGGPSHVfcqzboPWJ6IAtm4wQQNel3C2UWwfDef+A=;
	h=From:To:Cc:Subject:Date;
	b=Gb8759cUP4F7z65rAz0mmY+nlIY5k81T3VIPeUin1rbrmVvM+ZXx62gTB7IFUlPVt
	 Znub8YBvftvVjKpiRv/Na/rttLudHP4zP3b5qv5/6Cb08R3CMx/ieJA/PHNqJiyb0e
	 q+xwyomlbMEpEbPz44JLrIlBc60dY49oaQajc+RJhHynUja3RL78LslqWtO+fZ8s9a
	 UQNA3D/GkIuYY41/1Hi/x6veTaZm1zuE3Ef6iQiV0P++pYoKj83T+oU+3AhJp6FMJf
	 dk6acrZuagzDiLn58yIB62qgsy4eAbprozdbTgJIylfUestjXzCTphymOIHUroWuJN
	 5jqJ3swApSXPQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/10] mm/damon: improve readability, clarity and test coverage
Date: Thu, 17 Sep 2026 07:21:58 -0700
Message-ID: <20260917142210.90829-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CA3B6A0004
X-Stat-Signature: 9zto1srajkntne4mqqdcdpfnnyee8jyt
X-Rspamd-Server: rspam01
X-HE-Tag: 1789654939-235059
X-HE-Meta: U2FsdGVkX194yYdo67ax4EIwRHTP2X/GQuCrbuqozuL/g68n5NH1p1GTvZ7QPTtMDjKEFtpMeVhSF7COw0XFnIKalUR6dby7tPyVSge/9AaLQECZB0oeLH0odOuGakZLY2wgMRZ8HgLsckW5A8M87Xw8IxWIAak3Mdnrs5/k9tfmpxgJufXNdYg5I/9KkBussn+n+dqffZVVIGsBAmyrWLK14D+1iEwxxKOUoxmz2effnI1GboXS8YlgPF7FNsjoxtpHq40RWnaqjAdlAKYbaIB91x32k6NtSG8qACsYRjX72ub3+txQIBOc1WzylusuXF35EOPPogwxUo1jp+D/TMtP8wW5U+b8DgQze9I2QxmQxRrppznm68+fm6tSCsdp/aelpZU/k6OfX2ug9QPzivEdDguMNO/Za005pV4/QHL37y4M27iXGQeuNvpRXb0ulXl1JjEyiHqWDEw1CHOXgO165R7D2tB8shYxVahcizdQ1Gnj8hYXRTOQhKM3kSyDyexcXA8Q264/U0V7ooVuvW753sZqeyVXJvC+Gd1h2q6kZNDzQSpFPZQrsiWrOSKyqf6338ihED/Ov0MBRob73yXc2bqWjp8oCcOE0Ul96Qz4kU+KSaQEPyxTDJPaKTMHNj9AXsjKNkAuLThxLVFUWicLu7SQYp4zipnaTh2E+nFO2Fz/QBLzvKgXCBx62luXp3R3NhPxr7zBlBrYaTOvXl6tIWKOT1aZTS5E+nmmTS95tlUP9Li75kMck7TGWTZ3DyHpi+wgQLT3hfX+/SW/G3Ysoz1v9LeH2hQIiJMf56QGqhT0qODoFAYwiz9P8U0AgOwBna35ulruzwy6Sf2N9+qdCRiGpKKGkGFCjqRwKcD6XiZHAzCHijjiFUICPP/iRpmdc/bC9t3BIyLV/hC+n6zPaW04gxN4Dc6LtjoS2cNiUDmtqS13FUpDDTdovaMszg0F/HEwRZUN2hJmWYD
 fK1gCirw
 jR7xYDks4pIvwoC5ZF2qRY1hVRChefZCCbWnWsR9S0J26Nn4CYLwgWFZIsdA9oQfKIQ79FtDfWamMQIDiwtCo2QvKS2BdclFTDXL1qOBAaDl32AiK0JF1iUsuoTLu8MlRccnkPFrWZZkcp4AjaGfyA3VXc7sCR6RrA1LeOSXQy7qrkGW+FZTqU+P4r+bfMadQAr1U6/HZGQe3IxaXHIZvZenAdQIO/K0r4Ylb4UBvLUwEvBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yet another batch of miscellaneous DAMON minor improvements.  Mostly
focused on readability and clarity of code and document, and unit/self
test coverage.  No user-visible behavioral change is intended.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260917040537.107341-1-sj@kernel.org
- Drop RFC tag.
- Rebase to the latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260912200814.145612-1-sj@kernel.org
- Fix a typo in the selftest warning message.
- Collect A-b: from Randy.
- Split out damos_adjust_quota() fix to an individual hotfix patch.
- Add a patch for initializing walk_control_obsolete in damon_new_ctx().
- Add a patch for probe_hits_wsum damos filter commit kunit test.
- Trivial patch sequence update.
- Rebase to the latest mm-new.

SJ Park (10):
  mm/damon/api: remove NR_DAMOS_FILTER_TYPES
  mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
  mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
  mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
  mm/damon/core: document damon_call()/damon_start() race hang issue
  mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
  mm/damon/tests/core-kunit: test eligible_mem_bp commitment
  mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit
    test
  selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
  Docs/mm/damon/design: clarify bp is basis point

 Documentation/mm/damon/design.rst             |  5 ++--
 include/linux/damon.h                         |  2 --
 mm/damon/core.c                               | 19 ++++--------
 mm/damon/paddr.c                              |  5 ++--
 mm/damon/tests/core-kunit.h                   | 30 +++++++++++++++++++
 .../selftests/damon/sysfs_memcg_path_leak.sh  |  7 +++++
 6 files changed, 48 insertions(+), 20 deletions(-)


base-commit: 942682790e570c9422a389bf34097e74c4777fe9
-- 
2.47.3

