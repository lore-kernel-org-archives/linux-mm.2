Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF701C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FFAA6B0088; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD576B0095; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EB66B008C; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084F06B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:27:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BC381A0595
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:35 +0000 (UTC)
X-FDA: 85166933670.10.0F239BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9FB4A20002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:27:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQUO+4NY;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788308853;
	b=2eyJiU6I/od5SCZxpaCkXy/cVFFXIxmOVfDltWhxC9xeFb+K+ROsegKp4ScvqrhiZJeiOE
	Z9ifQwNg95+U0UzP59+JRPJQqFSsU/CM4WwI6+C3JVGRotwKbXiLlavTFjOQKfhuPJP9bp
	G46BAoH1XIYVeNmAqDLN3894+IeXi8c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788308853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mbv8WxNYdZDCGISix1qH3K9oOQ8RMlyWgnMJQvHMmG0=;
	b=aQI0klBF7cyaRbi2gMm6IqOcPRQu8vMLeXnN1dbxh0E1Wfe2vFCMhexrak6QWU4dB1pzx1
	gceE/fZw8QKeGSbF1XbXr4Oe3yXub1Q0iTHBo4zq0Ia7Hpxa8ajirysNlkYBMLSRYrnlb9
	/YNF5CeetXi9FatVon5AzMZw5cFe5tE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQUO+4NY;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEEA1600C8;
	Wed,  2 Sep 2026 00:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EA51F000E9;
	Wed,  2 Sep 2026 00:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788308852;
	bh=mbv8WxNYdZDCGISix1qH3K9oOQ8RMlyWgnMJQvHMmG0=;
	h=From:To:Cc:Subject:Date;
	b=RQUO+4NY2VU3f7MNQJs8O/9NYJxF9+lIgXvdVprklDTns8sq8MmOsoSniUPJJztqq
	 4X1/Vc1U9JgKmYoaVlRiTv+PmW3UbUPwwFR14cDhoqecuF4tC6GnL+MSJby5amyds3
	 Ro82wNH3VUssbS6IUR4QLeFk+xBekhw+ggsZbACziDlfrmMGWgd/tHH0SbacZYkMVT
	 MAMYjgj2elCLpXQZDsvpnZArX+8c0FYZrBrJwfpLvLZrahdx+Det0POhB5WtmEQC/I
	 GjC5jVmpWcCO25rvpfs0az9XePaeeMYhcI06XaTkNAa1XkuK/Wtkotj6MMXwZU1Nk4
	 bVuobnP1ICHng==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon: fix misc bugs in kunit, quota goals and sysfs refresh_ms
Date: Tue,  1 Sep 2026 17:27:19 -0700
Message-ID: <20260902002725.108635-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9FB4A20002
X-Stat-Signature: oc5z4oppegppa35ozogbqxuj4d1qscyt
X-HE-Tag: 1788308853-794388
X-HE-Meta: U2FsdGVkX1/VPMQZUj6M9SY8MatrSSTtfsqIctq+XfsueBcow2BIkmtn8cZDTWva9PVeKV7sj/IZ5pOwJlessNiV+xbJDVy6pBtxIWgX39oGSmo7PXldN+MSEzutzCGGLPWvUHy/evFX/eqXLblu6dy40tE/+D1fexz5AmHuhoOfz2Ok/pCr8kkrLD24oAUMQ/7Cc6wrx+dympQkJqsWwZWwunsuQbMIy/8CZfhYyR4lIjjfw/2YAseFWiUe+ZWG+r2qgA/9S5LojDzY7RBA8xMgTIbvo7Q74+EvWCbtEpNgIG6Gcn2Q07rAdZyvxOhCzEqAsqrelqzKCMTPMnUAjVItCpXPTfc6nop3/Kfv6d7ZDAMnGl0kDfDFlMpfwN/dCQQPztkKR+RF4RwtdDiQiYxQj8PIEh+q11umBACWMTZoyCOu0B6rr+Zw91JiNzJ3CA8dcqM3R1ssmYO+EQ69INsbrFR76ayMupaZd4hlgIH4zIBkhv+nFHYu1zGPudLGzZxFrWUG/pH4jb7ECAg6S3PiHcIvNF00ZLH5WBP+SPV/KDliJmnUDXNqHKt+Xd3P+8j6UC9k0U054YHLvQoh+LWZ+co/Q4JS2HhwlJtpAd9+tFAysuPiF93IyhPCXuFQi5FHNq/tdP61pr3KxuFrrzIrGKIEmDYPOYX5QdsQeS0T7EPH5hR9mXo/qQE0CXSy3/Hl+N/hGi1ufDix07g7FdxKrshz67fPrPoXj1YRCs1OQ2yp4w0eZrPH6ogmACwb39aw8Pv5RX5VT0/pPklg2SaE2Rm/wIznjORI0XmOfiqFLdAkiVHevvPqNdgLurVNmkkLdBiGsbmeZJVySOs8fbJgBFViFhd76irjIn5VflCHbsF9lMqpgFbMm3/nYciCIfNtTdxi37nSGohzKbwsmf+gXMXJ09UttNA1zOUPBSN+vp+qUT6SxsnGKCAs7GnJ8Y29QAzIoAJjXOYPsbI
 hjkfIZaU
 VPIvXdT5IDjoW7HvfKvZFLbBTY+0QAXVgfyGc7gJVZNqTWP56dYB+un3cKRsllvuxpm+0q1L52WzRZiSRWUs/mIVLValjgEpM0f3+W5yKwJGUKDVWoHlXA5J0q0qGXNDz/ADePSsxApLEs92hCIhjVz3SHg2WzVvEFiLegfppeNAoXg79Ikd5UiW9GEfXuB+UqXOqQtX9tMQsJzmjhFpXaXricYhyADNhiXEbUnvNHml02eVekiZV1NHwudUqRooucRjtHFFaSQa2QixFhN8Slker9fYy7X30kt+ZmhXsYz2oc1E8R+aGzEQ/XXzKHtJmdW6B3B8d39EFy3pjvN3P4EnPzEtlMOog76bqoB/rCXSWU5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota goals commit unit test is mistakenly not testing a test case
that was designed to test.  DAMOS quota goals and DAMON sysfs refresh_ms
file have bugs that can produce non critical but still unexpected
behaviors.  Fix the bugs.

Patch 1 fixes the DAMOS quota goals commit unit test to cover a
mistakenly uncovered case.  Patches 2 and 3 fix the bugs in DAMOS PSI
goal initialization and eligible_mem_bp online commit, respectively.
Patch 4 fixes the bug in DAMON sysfs refresh_ms file handling.

Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260828183649.71192-1-sj@kernel.org
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260828014659.121058-1-sj@kernel.org
- Fix last_psi_total underflow.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260827134429.123023-1-sj@kernel.org
- Fix quota goals commit unit test that was mistakenly missing a test case.
- Initialize last_psi_total as uninitialized at the beginning.
- Correct kunit test for changed last_psi_total initialization behavior.
Changes from RFC
- RFC: https://lore.kernel.org/20260827042920.93580-1-sj@kernel.org
  (Mistakenly missed RFC tag)
- Fix build error.
- Add eligible_mem_bp nid commit fix.

SJ Park (4):
  mm/damon/tests/core-kunit: test committing psi goal to psi goal
  mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
  mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
  mm/damon/sysfs: set next refresh jiffies per sysfs context

 mm/damon/core.c             | 16 ++++++++++++++--
 mm/damon/sysfs.c            | 11 +++++------
 mm/damon/tests/core-kunit.h | 16 ++++++++++------
 3 files changed, 29 insertions(+), 14 deletions(-)


base-commit: ee125db0b1f24a2f6b04e3143ffe1a14324176fe
-- 
2.47.3

