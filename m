Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8129E606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ie1STN6V
Received: by kanga.kvack.org (Postfix)
	id 9EB286B05B0; Mon, 23 Nov 2026 10:13:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA506B05B3; Mon, 23 Nov 2026 10:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9003B6B05B5; Mon, 23 Nov 2026 10:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3486B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F238D40930
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:19 +0000 (UTC)
X-FDA: 85466727318.23.155A847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5C59D180011
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ie1STN6V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446798;
	b=l2oJ2Q8m9yzpKmsA51oGnBpX8vne2xGYZfNvJcW52XzDnTYgXAVxL84Ip5+cufW3fppHXx
	nmhoRL+7rcoCC2H9TffYOy5DuzYhSDZ7njIK1++Cz5O5h/Brw+4n9NaooQAxmN8oGAvvoZ
	s/iYdA8OMpwERs1GVpkxuzL5zkk3tds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rgusygp+RlAE67y/ngtutPu5kD5yNG5Fz8DTmip9El4=;
	b=8hRr+CTtC8GayNEaUyTVjlF0iIE5LpIFAMo8JYMAg6Av9KF08tmlv7bU+Yhu5HvQwPUt/2
	DXDXHNq+Mc+cT4idBJeay0sk7Ept+4Ud7KXpkorZsh4Kq2bV5Buz54AQa4sncU695wn8Za
	GTniLi6KN5RP7CR9Z4cnUcW2KGCZiAE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ie1STN6V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75D37409CF;
	Mon, 23 Nov 2026 15:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3601F000CA;
	Mon, 23 Nov 2026 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446796;
	bh=Rgusygp+RlAE67y/ngtutPu5kD5yNG5Fz8DTmip9El4=;
	h=From:To:Cc:Subject:Date;
	b=ie1STN6VSXka1O5wuIlHmb2D+6VN2EcNXv6egd3sZtpNduYhKEt/3sI8rK2YwKQ9V
	 FjjIiDBGekIsRy7TiF9wgpxj8EZuar+wU6vXs4hCw9dNwIFEm2WApWuZ728w6Xoz0q
	 0cqvdn2Ox02VUSJZaJG5Yjv4Vq61qxeX49R8vFzRGTJyxkxrrFswoeC94M/ufSy/M3
	 f/bIrYcFlRTJbVoKXRi9NgEcnN8q8PwybX2QkSD2/ZFd8BZTctau+LmZZ7aUjIJASR
	 0UoX81gFt4ylmLkQd2OEaOZ+m41nB6t69/Vh2hDlqC9MSn3GDzeKDaHhUJopqTg3VE
	 eiTls4YAeRpyA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
Date: Mon, 23 Nov 2026 07:13:01 -0800
Message-ID: <20261123151309.82675-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C59D180011
X-Stat-Signature: mayry9cyz788qrooska3ryhm5uej6gtq
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795446798-339402
X-HE-Meta: U2FsdGVkX19iEi8qTDH3zHf5r7O2V3Xj6UNerbsAbg0i9+EPgFsaO1XW3zIDIXT4uqlcMP7gXCy3vInTqx/hdZkdCmP9LQKBEfvyc9Agu0svCAz2RAZexMtWNNvHf3BGXfcwkb+RCR6gZQlsQrxvDBEt73JfTmXNnSs0PneBrDg9YMAmVP8I9h4Dv81wBjHVyoh8YXslginkGGXZCPdZPoQZWu6NqfBJ5bt0GcfZsuSxTF2JW3n2lsy+QGp1h/AFCYGcJPMZ654bvKJikvCc5ep8TQoH7/cfK0JBqjfCPzRckv+pFmXnYWynOyTXNM/isCp7iNh2DatWIv2JY6Lms0uWPE2cei/etrgsjiauab8bbf1SPGhOrTmGdUkXVa/oxCza9r//l27MoWASXaqEfeWEnt+WlbkLi3+oW3868W3lujLTdIK67JzfXXPWFXZsCHxj6ndo+Yl1kcIl/9LB69fYUnWiBNrjQzC5VpUmF2Ms+4jaBtt8GNLMTru4R7EJt205kBHVN5ZQusW73ZffyldA4wa51/bpfKsm4W/TWrCY5/kjWX9OHrpoXpdVV+l/hhh/bZjYX0+PCD6NGBtNJR3Py3o5T5jHgFlwR8Rf/uuJpyd6EfGBHhNafgufueBaCs5wq1e1dBiZG57P+YtsZZKN5MOYecq++ryxGNb5hoYbrHsshfxddJ1iTE6c0eQYUr4U1wmXVK4nwpU1n584niEcbb+B4sTH/RJg6F4b4udZcbqHR2gzsRE2vaOrp5OS8uWLUx81t84sztzW+8o7K9Y9oHxu1ocWW6NrE26vUHee6il0Gx8h0WCYWu+fU+OhfdaOp4ASSQOcMoDRiN/kKTGCbqjWcExIXFiwNu/QpW/IyvNvjO5gDfuFEJsJ8RX+gXw/MZhwmfKXgGo94iEwF9gEErz1Dkj4Msp5I0dOWU03w8wGRjVOX0uYMTZuFn4z9iK4rSFp0684lKrfxbG
 SQfTBEhf
 96jF57AjA2o0AmhhPDVxe2XnTIoApiogbO1oOb72FDKWY1PtICxqkADugA7O593CndFS18sUfwhchi1FlPpal+7R9pvKA91E7NIkP8zQSNpwxYSXa4eqvdEJ88urrmz6deeBTJsAJNyCZLBjdlGVlC4jXi6jetcBQo5749SjsmAZtkkCDFP4ydvIXgdlTY+UrvBn8ouPb2peH3AZIBPR5wF6FLzy+Vq9d5/toBkzDga9Nu9pncgbK0YFpKO78pT3pai+Z+Fg8NgBam/KC0gegDjDclmO8ZiQi/aivd5bl6Q1ayIyd6ogC4FRwpJ0OB5h2TU/w611I9/k+R4DgZXu0gzq+Vc5dzj3LHdx5I6Ix0fQcD7gc6liCzS25IXd1IxMkgsm8S5CpYzb4BShwwjKkt+O70zgYD4yI5rmLM1rnP+RFvpYLFVTh/Mm2TFUFhB9ctdsWcjA1ZEKX9rfyyYMBYJL0RgKfHCkirLlCKWJY8XTb0YYI2NGmtKkH0u5Sp3pJBJeyMuQ1dYwlsNjEX2DX3puyVoSqGJGcj0TpE2IchgiOfUe0Tgptzr5m51z+OJMh4nX16clXcC/r9GKQcB6/wjgUYW3aG+Dzc96WJ8R1ymTQNtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning
of the scheme's execution.  Users who want the amount for only the
latest apply interval, e.g., the size of a workload's anonymous memory
that is cold as of now, have to keep the previous value in user space
and compute the difference.  To know how many apply intervals a
difference covers, they have to rely on nr_snapshots.  But nr_snapshots
is increased once per target per apply interval, so the computation is
complicated for contexts having multiple targets.

This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
shows the amount of sz_ops_filter_passed increase in the last apply
interval of the scheme.  It is updated at the end of each apply
interval, and kept unchanged until the next apply interval is
completed.  Like the other DAMOS stats, it is exposed under the stats/
directory of the scheme in the DAMON sysfs interface, and refreshed
together with the other stats when refresh_ms expires or
update_schemes_stats is written.

Patches sequence
================

Patch 1 introduces the stat to the DAMON core.  Patch 2 exposes it via
the DAMON sysfs interface.  Patch 3 adds a kunit test.  Patches 4-6
update the design, usage, and ABI documents, respectively.

Tests
=====

I ran the DAMON kunit tests (all 50 pass, including the new one), built
mm/damon/ with W=1 (no warnings), built htmldocs (no new warnings
compared to mm-new), and ran checkpatch.pl --strict on the patches (it
reports a warning and an error on each patch because it does not
recognize the Assisted-by tag, and four alignment checks on patches 2
and 3 for the continuation line alignment that the existing DAMON code
uses).

I also ran the DAMON selftests in a QEMU VM without KVM, on mm-new and
on mm-new with this series.  On mm-new, 12 tests pass, 2 fail
(sysfs_update_schemes_tried_regions_wss_estimation.py and
damos_tried_regions.py), and 1 is skipped (sysfs_memcg_path_leak.sh,
because kmemleak is not available).  With this series, 13 pass, 1 fails
(the wss_estimation one), and the same one is skipped, so I saw no
failure that mm-new does not also have.

None of the selftests read the new stat, so I also checked it on a
live kernel.  In the same kind of VM running this series, I started two
Docker containers, each running a Python process that allocates 512 MiB
and 2 GiB of anonymous memory and then holds it.  Each process was
monitored by its own kdamond, using the vaddr operations set and a
stat scheme with an anon operations layer filter, with refresh_ms set
to 1000.  Output from sz_ops_filter_passed_last was correct:

    # cd /sys/kernel/mm/damon/admin/kdamonds
    # cat 0/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    546385920
    # cat 1/contexts/0/schemes/0/stats/sz_ops_filter_passed_last
    2157043712

Tool use
========

Claude (Anthropic) assisted with the code, kunit test, documents, and
changelogs of this series, as noted by the Assisted-by: tags.  I
reviewed all of it and ran the tests listed above.

Changes from v2
- v2: https://lore.kernel.org/20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com
- Collect R-b: from SJ.
Changes in v2:
- Patch 2: join the attribute declaration onto one line
- Patch 3: call damos_set_filters_default_reject() before adding the
  scheme
- Patch 4: keep only the stats list bullet, dropping the explanation
  that the stat is not accumulated
- Patch 5: wrap the stats line in the usage document
- Link to v1: https://patch.msgid.link/20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com

Mattathias Pinchover (6):
  mm/damon/core: introduce sz_ops_filter_passed_last stat
  mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
  mm/damon/tests/core-kunit: test sz_ops_filter_passed_last
  Docs/mm/damon/design: update for sz_ops_filter_passed_last
  Docs/admin-guide/mm/damon/usage: update for sz_ops_filter_passed_last
  Docs/ABI/damon: update for sz_ops_filter_passed_last

 .../ABI/testing/sysfs-kernel-mm-damon         |  7 ++
 Documentation/admin-guide/mm/damon/usage.rst  |  9 +-
 Documentation/mm/damon/design.rst             |  2 +
 include/linux/damon.h                         |  6 ++
 mm/damon/core.c                               |  5 +
 mm/damon/sysfs-schemes.c                      | 16 ++++
 mm/damon/tests/core-kunit.h                   | 93 +++++++++++++++++++
 7 files changed, 135 insertions(+), 3 deletions(-)


base-commit: 60a393b8ae5d63691c0ea9b21571441911afd81a
-- 
2.47.3

