Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12642C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A276B0095; Fri,  4 Sep 2026 18:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1BA06B0096; Fri,  4 Sep 2026 18:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09396B0098; Fri,  4 Sep 2026 18:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD2E6B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:51:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D625D160224
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:10 +0000 (UTC)
X-FDA: 85177577100.14.28B10B7
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45022100003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dNqJjctD;
	spf=pass (imf05.hostedemail.com: domain of 3W0ubagcKCLo1kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3W0ubagcKCLo1kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788562269;
	b=hLKraU6q10lnex8p7rLk/IAN/OFVDRvE7h4nXgRC7aoOxKp1p7ifprHErPnoiUGrysPFKm
	qj8JK2RGPiJ/zCQbln5OJs4g4pozbwCHqdGXziXrDzsmtrkiD16wc6/zk0mwQ+vsafifwL
	E3pkxfUydg4m5S1wV6WOAaB0ShotUh4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dNqJjctD;
	spf=pass (imf05.hostedemail.com: domain of 3W0ubagcKCLo1kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3W0ubagcKCLo1kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788562269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MNz/CRZcdY5dw1JlngX3+udQebj6/NYG9KvEnFaFzZg=;
	b=EbF8Gz0YZuqQSdDOvJ0TK3gplwhznII2sn+zK4L9yuTaAW0v8oCkzI+SJ+rHhbcv3a5uh+
	86OVhQORWpBroTxEgB8wD3NlwxgSOQQOEfYbKuXp5D93ewTYUNrg9lPHZ5QATQ/+1vgtU2
	XkjVrAMPSNNRelWBoxpL1jRVU7XezSU=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc73f47bdcso19823535ad.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562268; x=1789167068; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MNz/CRZcdY5dw1JlngX3+udQebj6/NYG9KvEnFaFzZg=;
        b=dNqJjctDa2ZiJrmPbYkX1px4yYnunw+jy0G3JFnnL7Fe4MSdYL1nFx37uzmFq4Dipd
         qXdv3sE2b5iRqeW7uGMC7frVBqyrwC+oISc4KMyu35d+FpaGaRDJYLUv7pegResRzDHN
         VNdhLh04ksCGvtve2mRfbhCPRkrxmQ8t/T5bliPeBZVOXbwFz7o1qfeFvFXHxrWUde0Q
         7lIa+esMbV6bbQOAvL8gt1xcuoDlQX0+nIXQKd6XK4MqcUdy/4FRjIARm2o1QMltDCI9
         EH7XOmPeEzHcV6xg8DFvDottqYJAOGJUvXWb/E54wEvW00SZ+HqYgJ4uF3sFG7RU8V3C
         RNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562268; x=1789167068;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MNz/CRZcdY5dw1JlngX3+udQebj6/NYG9KvEnFaFzZg=;
        b=n5vciCMQzHieUKkMQOZXIT6QQWfot6qr018q9Gu6ZcJcsyZ21zo73bCbux23otNngl
         OxsW+sJw+3gpGZ4wJTjQwvE192q7Ex+PfTdKVRwboxWIO32LQbCq7D0rvrcbAAXBa2Mq
         C0M1WIcLlDBEtSWuF9Z16s7WQEnxN8mFP+o5lT03tOnM/1fhC5xiAAFxEVqWG924Iz8W
         SWep49Xe/bkHPlUuXWg+hWoh2barcjjA6UZb1PziPexv6pT3BlQtU1QfSvVEwCUtkdSa
         vfBOUundImTRZcuXR3XUwE5u0b765xpGbYXBGLlS/pyTJsvbXocF7eviL5ai5qrP5sRz
         Pjnw==
X-Gm-Message-State: AFuF++l5NzjSQF2DEKOClWIFjuhGHublje5a1LQ9KOAamcCS9ybNkBZg
	Rq6tern5wqQNSX9BLvtgvcBKp+aP+cuQOmhx8W1b/4Jp97S3XKjFPy8cYvS7IYidld16Dd+vTGG
	Om2Y6MEtw+w==
X-Received: from plcu18.prod.google.com ([2002:a17:903:3092:b0:2d6:ee0b:5a28])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3905:b0:2d5:2f49:b3f4
 with SMTP id d9443c01a7336-2db1231fb56mr160244895ad.2.1788562267735; Fri, 04
 Sep 2026 15:51:07 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-1-wfelipe@google.com>
Subject: [PATCH v6 0/3] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 74n4uaijy4i8bafpeujqexo9x38ye8we
X-Rspamd-Queue-Id: 45022100003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788562269-731289
X-HE-Meta: U2FsdGVkX199q4jMeKF8ZZyHFzw1Go5u0b5yIXCrl3VxsnyQeCpe/F1lhj78OmBF8MpPZgZQH4XvYPdmN5DT8m6ScfZK/Tda+dHuJtJiYgWQIYirph1tKygX/HpfBRrXX/fwnYTXpiGb7o27xFhgqBy9LgPAQaMfkjAkNuXYrT3967+ylBuujrMrfumnERPw6JwNpgEFHPHQ0Id/NWY4zRwHrcexMKV/eMJmSDq/LCPhZmc3mR9FCeX/qahyeCY0UhAre+l3ZpCawiXjjgj/FLYM3ck4cFIRrsjdB2DWB8quqCTQ88AND9igNuWKYDBwcMYRiAdeLh29BRWkoaDwcGWZ/71aGwFPH3kv/RJuW6ZRkxJQ7k87sG9s51m3deq+ZsqVaZPiQkmr75AvRsOsIxITgLl3VeT56PPmFIzikx6+vHfOS9dH70NaFHwTwQdh4cvPOfcVwvWzQH8tSIIACph+YZvpxissVeHGdABo0OhM+ZWy1YViJAkqeDgshlK1RBvJzohzjywcCDi5ZQ+CqrnereVdtBTN4mDMeRFjjZvfw/N2qK+2tWHpJm5ISzyJbeq8p/pKrkP39k2NMYTVD4f+rcz3RvCJtZX+ykAfxNVACXHrBHM9Kzh1UL69XtmvW7B9fmqsgbblIAz03nFBXe5JKeaH5WtQh1mtidj/XNE9ESyDd8s5oHfmYJYWylGClvm0XBkNmimDWgcsVYcqwHmYedIG3GFZwbCX2DE0aE72Unfhy9xs3O6n+5tNn7gORJsWY5EIAR6kqVpJtlwI6LzR4mpRzEUlxRrl7le/XgySXmfHvAExP7fVwTuMmbDlxB2pHX2ULNHSpWKPARzEhg4nEjbtG3HUCF1Q0WyYY/lmcraWiN9OtaELhPFu/JaiADNzKKMYl1hJj9kXDxjaI6taXf4Efaq9lwn/jQEoTuWaMbBZEtu+XuI9L9cI4KJD1MMPIOOxslJW1iqrVqZ
 eKYxgO8L
 7zLndUZz9iE3zkBd//aeEMHnIcN7MplXz+wl25yfu889qFdKZ5HNi8NtwEJ4J+XJ5dtbMYuHPnYXkDJ88WHFMWRxXWsTaf6k4rpcvMWhvA3kJjlxtTJOCVac2pjECSUFFiIpvJ0L4gAkeQYDNGruPf7UvcmZfEa+wlFH4s6vhJ3N8jYxPikd0cNqtDR5Yp7vM4sPsN0UzdvZnDlT1yJlBzAtvarjhtZtC8Cpga39bcBlXnytcJMe7UwVMELBqBD2SRxTHkLDNu5Ds17kk7s3F+xL89M3AK8oSgoXx3WOwIQ/6KqzRoa1ObfiTHHTi9hs9p8nU/X95Hl6k0miWbVPJ6eblIzHCkACPilC7BtcNksLTt/o+l98fDUIq52n+qHUo9QuK3Fy7PFBGyJTmFuwpZ7CFgXTMyiGStW1q0fQrTeFn+InqnXcMHWcZU5a0cYXyyUIso/IVBpxq9wvMn32f5SszHkIToZEXvzrrG3XI8IMZaUrE76QJg51kOtj3Cg0awAi0B8Fs0nNhPDJxDo5zh4qQbxHjwDC4gt4nUHvQ0XZyooSst9T1D7Vk62JXq5+CsfU6C0MKwW2CqnKso5ettLWNaLtktV6Wl2iv1a/hT5HKQ9fXswGtyUrm6nUCCp1v8wEDmBAd25mTWi6EQ7Q7OrNKKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 standardizes cgroup key-value stat and event parsers on 64-bit
types by replacing cg_read_key_long() with cg_read_key_s64() across the
entire cgroup selftest suite, avoiding 32-bit integer overflows on systems
with large memory or high counter values.

Patch 3 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v5 -> v6:
- Now it is a 3-patch series.
- Patch 1: wait for cgroup to unpopulate in test_zswap_writeback
  (unchanged, retains Michal's Acked-by).
- Patch 2: convert cg_read_key_*() helpers to s64, define s64 as
  signed long long in cgroup_util.h, update poll/reporting helpers
  (values_close, values_close_report with llabs), helper functions,
  and all callers across cgroup selftests to avoid 32-bit
  overflow/truncation (suggested by Michal Koutn=C3=BD).
  - signed long long for s64 was based on powerpc/include/utils.h
- Patch 3: test_zswap: fix implicit unsigned promotion bug in
  test_no_kmem_bypass, updated to use s64 for delta and max_delta.
- Verify warning-free builds on both 64-bit and 32-bit (gcc -m32).

v4 -> v5:
- Patch 2: Introduce cg_read_key_long_long() to return a long long
  value, and have cg_read_key_long use it and convert to long.
- Patch 2: Make zswapped a long long. This prevents an overflow on
  32-bit platforms (Andrew Morton, Sashiko).

v3 -> v4:
- Patch 2: Use long long for delta and max_delta and explicitly cast
  stored_pages to avoid integer overflow and implicit unsigned promotion
  warnings on 32-bit platforms (Andrew Morton, Sashiko).

v2 -> v3:
- Patch 1: Collect Acked-by from Michal Koutn=C3=BD.
- Patch 2: Explicitly cast stored_pages to (long) in delta calculation and
  inline the return comparison (Michal Koutn=C3=BD).

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v5: https://lore.kernel.org/all/20260901052250.154532-1-wfelipe@google.com/
v4: https://lore.kernel.org/all/20260828033741.2184560-1-wfelipe@google.com=
/
v3: https://lore.kernel.org/all/20260827034807.2822234-1-wfelipe@google.com=
/
v2: https://lore.kernel.org/all/20260824033533.2147900-1-wfelipe@google.com=
/
v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (3):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: convert cg_read_key_*() helpers to s64
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 .../selftests/cgroup/lib/cgroup_util.c        | 14 ++--
 .../cgroup/lib/include/cgroup_util.h          | 22 +++---
 tools/testing/selftests/cgroup/test_cpu.c     | 47 ++++++-------
 tools/testing/selftests/cgroup/test_freezer.c | 16 ++---
 tools/testing/selftests/cgroup/test_kmem.c    | 56 ++++++++-------
 .../selftests/cgroup/test_memcontrol.c        | 69 ++++++++++---------
 tools/testing/selftests/cgroup/test_pids.c    |  5 +-
 tools/testing/selftests/cgroup/test_zswap.c   | 63 +++++++++--------
 8 files changed, 154 insertions(+), 138 deletions(-)

--
2.55.0.979.g7e5102b832-goog

