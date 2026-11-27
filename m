Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A6C606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gZ80EMhd
Received: by kanga.kvack.org (Postfix)
	id AA3596B05B4; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D266B05B6; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AE56B05B7; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0936B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1DBB14050F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
X-FDA: 85482336618.18.9CEC019
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 72623180011
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZ80EMhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818448;
	b=vIfuECoZNhHj/Qy4o0qXNSR8O8saxXKEwx41ZsSxANc3tS8rZ3EMZU+va0sTPkrdmhPlOS
	5XhmVDAxW9j2qXat96USXhAA5/qFH8vz5oMaFsWRNl7vCh9G0fIqr88iT+BuI82L1ZN4Bz
	KBXlDOf3O+H25xuvoi10JLNBNBOyOT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6lBdhfWXWDM1BJfgF8wRgQ9FWT8DwEuH6a0DOJBJBFA=;
	b=icNXvMplSba5sy/m7ekuap+G4lZJtOPmhiraGn1cwP/eoGy6mjLrEIGDfe6B8pxEbDp/cY
	r8FeVCglZD4mmKSAHqRfL6Lt76w2vkXOE4TUnexdVuMEoc6XljdwaD2S5o3VeoJC5pk0yZ
	En+CSAlYumUYYvuNaD1PBwR8g+KLXo0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gZ80EMhd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AA7860CFB;
	Fri, 27 Nov 2026 22:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223291F000C1;
	Fri, 27 Nov 2026 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818447;
	bh=6lBdhfWXWDM1BJfgF8wRgQ9FWT8DwEuH6a0DOJBJBFA=;
	h=From:To:Cc:Subject:Date;
	b=gZ80EMhdqxW1hW8lBfnxIryIkYqgywZ1EP4YBcNbDCWjeea6eG9LwyjKIu0SH0s1J
	 n8idgbfIiH8aBJTLQNtScDkmSPiO4AYW684Iuq+4vLxrPmjGDCq90hx7nCoM3S3+Q8
	 wb1FnpmoHd3NeoCzyuiKo3f/X7fahMop2kkl4bImRiq2k5AkrJcWZeNRsVJcfJK4xV
	 Ra+aHOdTLxWP6ir6thvCigW42pOSEBRUbn589Rcpe6p4apFaS3yKlr+Mdb9SfBGZn8
	 e4J4BV128rGxc+AQJzL716yobxLrDijbnlgBdl+lExwLdZEBJqgQIZAOrdsZCDyrBN
	 jjXYzAuO9LH5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 0/7] mm/damon: various improvements/cleanups for code, tests and comments
Date: Fri, 27 Nov 2026 14:27:11 -0800
Message-ID: <20261127222719.105510-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ecxc65pa8ne8adtjs81w9ijhfg8fxgtu
X-Rspamd-Queue-Id: 72623180011
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818448-748161
X-HE-Meta: U2FsdGVkX1+0h9FU6rGYQoyu0vKo8TMcvaLbQ3rbhda59tqzuJ7Rb6I6lzf+HeeCRPdrEdQhhDNNjqPsRTgDmvts6tcNMbvg0KLvPOaSHOs8vHUfX37n8+wQ1DB7WkWL9oamID/mEqcpkP3mI/XT9NYMxXUdz6rKZw0GWYp5sfbG4AixcCYmzGBX1+TfdFDWmdSVfUqo+af0cc788hUv932o0C7nxpxoYtwCSQX1lhTtgi0ElyxFUOUZ2NVvTd1Bw7g0n9TwWLyl9ONX78FuAMLyLmG2e6mmbESR+BnQ2R5DYD8J+SBEQGDPvCLHdXOWAWYl9hsoQ9C5fr9RHM+xq+G3I8BkNw6dGrBXfpxDAQjXiFLBmxA08Bzjt69K9DeVidKJbHUukH/wKzS2o6QUFzbKMwmFnqkWEDkQ4am4NrlfWelAqMtrMrwjUUEj1vb6xrgQeRi0CCeKYf0/7g/88IuzLvK6PXlwiQT9QYHA7iyP55PQkECKLUdA3rbNO7DiO0TiII08Td7JBTjGm8rnu/c8VX9za6QyUmELrlQqAnLYOjieogHpzXntqoGjW77r1Fpjy2+LXp4cbogz8m+Lk7JYWXeZ1CCzU1+9MaAIa46vEUm1c93OQ0JAYQF6MLgYcvvOs7PVoQr6Criv3l1Xisx4Y6l86q+W6HJ2ku5Btj/SADhxvv9UqYTQBcHX6t/lyspvOa3biaWbdVi3qiLkr5beZGjKLd+16viVNu8OMy0u8LTGzAx6zeUJUBoiyGeoENO7CfOI/5rJ5dajjjvwFCPW6Km/UXE5v5CeP7c9c8ByjcLK3GJ3UuL9t1GwkrRWBDiUjL4buflqoCjk8F0PSSpZsoJOO5dogd78QhKsA7Sp/lCdOtTMFWUvCVeGvlDOTfzbIz3JATFB0C3nDBBcoO0wP8XXM8dBaQoSJVrZCaVnhaAE79CR5sMg6oQN99xkijC/vQ8IpmOECb6WDz6
 DAV6Ft/m
 anuC9YSAQOypUmnTt4x50vYd1q44lOb3aJhJwQ0liKrhV6O25xVwacaHUoPJm5AoB1cxYBA5/vuwjQYGL+3qvWJbIW8EwK+0K/Tj/tNU+4KHizByFJBrMTOoLBChNqGmQWiyvaLEd/jHm2Ww3/oO9oB2ZLYIaa/gRWxa5+42kP9wmaSXlbJS5WaVXplydibF5r7gUvla0nsYA1peYKOPEe6ymZwCw1XvuVtagYzFC2qRmVDtCygELqWywXnd+L0osU2d6lYLwdu5jJtC1MSTBDWVE378ELpd6j85jkou4RsRYBbMXlIof06KB/piFB8GOAMS2RJIbrewKoydkL0GAZKoZMPm3zX50TahHFJ7BnzjXxXKyjdmwuE2nYzQKX2FfJW5dkO2xGjVEjngPFKYrlIQjOIkQ/Q2OEChiZeGzmpsa/gm7QrNs1SkjiB6e0AwPc1SPzqnF+DGi8yQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Refactor code, optimize code speed, add missing feature supports, and
update comments on various areas of DAMON.

Optimize the efficiency of vaddr damos_migrate action under filter
failures with patch 1.  Use damos->last_applied on damos_migrate action
in vaddr and support sz_filter_passed for damos_migrate action in vaddr,
respectively with patch 2 and 3.  Drop a redundant and racy quota goal
target value validation in sysfs, in favor of that in the core layer,
with patch 4.  Drop unused variables and imports from selftests with
patch 5 and 6.  Update source file intro comments to call DAMON just
DAMON, via patch 7.

Issues for patches 1 and 3 were found by Sashiko.  Those are
mild inefficiency and unsupported features, though.  Hence not Cc-ing
stable.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20261101171630.81477-1-sj@kernel.org
- Set last_applied regardless of damos-filtering.
- Advance entire folio for invalid folio.
- update subject for unused imports removal.
- Add source file intro comments update patch.
- Rebase to the latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20261031202614.96036-1-sj@kernel.org
- Drop charge_target_from fixup consolidation.
- Add a patch for using last_applied on vaddr migrate action.
- Add missed damos_va_migrate_private->sz_filter_passed setup.
- Fix wrong commit message for unused imports removal.

SJ Park (7):
  mm/damon/vaddr: advance migration attempt in folio level for filter
    out
  mm/damon/vaddr: use damos->last_applied for migrate action
  mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold}
    action
  mm/damon/sysfs-schemes: drop redundant and racy zero target_value
    check
  selftests/damon/damos_apply_interval: remove unused variables
  selftests/damon: remove unused imports of sys and time modules
  mm/damon: update file intro comments to call DAMON just DAMON

 mm/damon/core.c                               |  2 +-
 mm/damon/ops-common.c                         |  2 +-
 mm/damon/ops-common.h                         |  2 +-
 mm/damon/sysfs-schemes.c                      |  3 ---
 mm/damon/tests/core-kunit.h                   |  2 +-
 mm/damon/tests/paddr-kunit.h                  |  2 +-
 mm/damon/tests/sysfs-kunit.h                  |  2 +-
 mm/damon/tests/vaddr-kunit.h                  |  2 +-
 mm/damon/vaddr.c                              | 27 ++++++++++++-------
 .../selftests/damon/damos_apply_interval.py   |  2 --
 .../damon/sysfs_no_op_commit_break.py         |  1 -
 ...sysfs_update_schemes_tried_regions_hang.py |  1 -
 12 files changed, 24 insertions(+), 24 deletions(-)


base-commit: f3e166bac17470d6c215e1b4c2af36f5ac5ee75c
-- 
2.47.3

