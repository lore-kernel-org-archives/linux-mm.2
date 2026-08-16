Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2467AC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 14:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9876B0355; Sun, 16 Aug 2026 10:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59F06B0356; Sun, 16 Aug 2026 10:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C704B6B0357; Sun, 16 Aug 2026 10:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 945EB6B0355
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:22:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21114A2E72
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:22:41 +0000 (UTC)
X-FDA: 85107348522.29.963BB3E
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5BC2040004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:22:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuHB3FHf;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786890159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XsGCXFozT69ITA4eF1crVo3PlInrHxlGF6a27uOAn/o=;
	b=ppKrpXfeP5s2tPrvGC9t4atwX5wYwoACS9Nm+yL67MTELBowdbBiz37eoMsQzVRq01jrZR
	D/rSTOg+gV1vFLbxvY24oNiS4cCnC/0WPRcLbnPYb53HVMEqg7/VRjx5UjYLo5S5bwel0Y
	V5coRdU2gGSalKUkzvqVPkNI/nBjgqY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KuHB3FHf;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786890159;
	b=syM7VTy3TInEk2Yqh5IxTiEhWmDcfqKaRd+jkmKWY8BAWNbcBKf2QZv/myFtcravd2jUKp
	GW2eNiDBF+mzXR7S3uqtnJ2MMRZpz5vcobepbDM51w+xFFVT7gKnF8hRu2uWZSXcPmuzYW
	QBUR57dAui7vxNhTJm7s/60V8qmPW6w=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d049069377so26027065ad.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890158; x=1787494958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XsGCXFozT69ITA4eF1crVo3PlInrHxlGF6a27uOAn/o=;
        b=KuHB3FHfc/NoMUHnHgolGZXh+ZHfDY6Q8aaOdisHRRIKSw/UFzEHMfQJQjtYue6s3O
         6OONbLTqcLM606gfDj8AI2gmw+vwNGUKiDX8CR4JJYNfTfE4nbw1EG6oJEt3iqD4N70u
         D1NFGRUklZggjhMPZB6ru/vSASVarVHkKZhngVbCOx8f7K0hnaNOK18J70/Dc+0cxpVG
         PgxBkQplQhKzM8f7xyfQxRlynhkw9KefpoXQQfZod/OTo3QpbakmZAWUmCAacRgeGSkl
         CgRtDrnWzyGrJn30QACAxdoS9UB8suHHzjzxFS7M8E/VSIcLI22YBs9UBaw2je5Wpr3F
         DasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890158; x=1787494958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XsGCXFozT69ITA4eF1crVo3PlInrHxlGF6a27uOAn/o=;
        b=gNnr083lNDOVN/NoMEU+41g4CTlh+beGNnUvcNPI+Cefdjag9+y2qM7hliGeAdljkB
         0pb++vIsG8wnKiY3am9dj0hu4jH21xpqZvYyOKA1JoBbapM3xV28qDjs383bmwE9ARBy
         Lg5ptsm6X7OY7ERFRSMHPmXFXoRy9EkaPl44+jfE9MVi7ZitCpSm49eFt2TztRIgR34W
         SRKfZXjooLie1pTfl4bXHIiKTDsZq4wF2yd/U24B3lvXg3dSZfNj0h8p5Nm7qB9e4EQi
         KnaUXvGMqzd79lQ4Ad4pzT8L1Zuv4PHYWdjWg5c3egBk0L2mVioUUc6J85uXLlwkX+yX
         5QPw==
X-Forwarded-Encrypted: i=1; AHgh+RrWwtqylQac9WbiVySl+pNStE0T5D+7aXHNKocTAsZG0vznhL0+0HMOZjSGNqb8gtnGs9gFUjYb4w==@kvack.org
X-Gm-Message-State: AOJu0Yw3i2oWeIdz7g9QMAhqem406XHpKu3MZz/qcrrNlATO9eF2S7WH
	Ev/V8XDznNYe0LjtNdnvlszYt/+BXRObYkmxHqLqV+G3d/z/gNAeNGan
X-Gm-Gg: AR+sD130Un2hRtHaIkEiuHRXfvzvD1hcB445x2wuK9a96SBzbyqur1x8Wt3T4944lAR
	jDcahcsl9iEyy+c1fo88gTXaPVBqY4tt8JE2OwjWKRiLjCeEqVyK8UJtNyWKnIYcSnxlja3keb+
	m68TSl4vA58XacgFZgeX01Y1lkUftafGJTEeLK87/TUDDD2snytl2qnCs9XrR0K+jdxwuLhIpno
	x0Nx4L6O00XsYWJBthJ7MHrI2XanN7SDG6oYAwGSD1anYaWEtBnUAN7Bkhy+LRgeO0cvgMO5d/W
	cM9H1GvJB0gW3pCmQ407q1HK9YmzJYQJxkXExTzns+rD8q+RJ22IyKxBsR3KMAPQPN6bk80x9ar
	wBkJB1hdF30Cg63r8sMGHMzEMR1IBWKev/tPk2/k6pV4LZ38qeaBYEdDxPeZm9Bmw5xQ0SV0Ktf
	DD3Fb6VraVW/IxiaqoceY8QfVZY96rLz1tWMLp5hhnb+hbZ/KezyVc5lF6bJVhwGuHS0gQMzncz
	GQdTFlygL2g+wS/omA=
X-Received: by 2002:a17:902:da82:b0:2cc:777f:d67c with SMTP id d9443c01a7336-2d3b0d5ed01mr190367395ad.13.1786890157697;
        Sun, 16 Aug 2026 07:22:37 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebc8199sm26102365ad.74.2026.08.16.07.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:22:36 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: will@kernel.org,
	mark.rutland@arm.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 0/4] mm/damon/perf: add ARM SPE AUX backend
Date: Sun, 16 Aug 2026 22:22:17 +0800
Message-ID: <20260816142222.689624-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BC2040004
X-Stat-Signature: ibxayssx4tyyobmb5mp8w6oxcnsh35bd
X-Rspam-User: 
X-HE-Tag: 1786890159-68559
X-HE-Meta: U2FsdGVkX18qf7jlPB1e/RumKQ2b+5Hxred1Gu+1fPwTzolwtn8HPphcDWAGcxAh85UI2z3siEIAGrw+sgjjaPOHBVnV6yu8ako8dV3hlQ78BMX5GKE3e5PsClZ4+hP5uckbWLAzSsrdjAEwHrtx2+NfWISPg/+GfGH1qlbOVyqhnWXDSzkKgIvX1HSvxJexFqRc2aqdgxZ5g+fB5Jnf04T6dTEg2rrcmJDLCqWNPGMYw0Vke7gKA9c8rFbQMBFqLD79VY7Mpnj9pNB7WCY4fYg2kHNUQudOrDNbm7WIdbSgvD2ytu111o/Wzqh5m9zOUE2K4ujP1jWwis60NQeZ/OPjhMjCSYjYWtFx3tGyyD1Rpx5ushRsG3fCkQNcVkSlBrc5FPbyrdg4KK2Sk0IoFTwqJf6jZ2uOfZy1EWkzxvdTn4WUVA8X6GffhiU8gs2FitAtIWiNKesZVF0mMqRnRnRzUOSRQh1b36op8j0MNQHOpeI2iKp96GiWpN/fooVcw4XgtpDELhChnrX+L7Hd/LkpgcnAdkKkox/wZuFkau+XvK/m7Dxsri89gbATQpH/kA4NX97zUYPWfZVJ8ksISRc+dOzAo8oZvyyBloMaPfVmDp8IEbt/YRQPMWg+nXQfTw3iYkgin4nYccDFMh38k1F2FboBabl3n1f+2TYyWTNK6iHsZNElNqe5qX9ImMxj6JsedbUj3f1RCke0oXhRmr4+wrvBESe3xaMs2OpOQcsREQLn+QBmM7Sn9YxMoXGtPF/x8s2jimFLskAThXQaB24za77U2opZL4R8rEho/yoErtuWg8qQHIl5TWARouhdk3PhfaeQeIt0XVtjUZX3+wQeTri8v2UsMJpBO0gTGTjuMCD2KiQfNtDgMvjv/bGOCMAYO6P2xxye6dnwQuZDRsvdcMm9I4cYHGarULrtHjCR0n+4DLwfEYeo7Z9MHXdQcSBoXuQS+5dlF0uDoIl
 YON0bhQ+
 5lo13k3CMNx9Cbc+WbKLlX7QG6xNuJwXTtonzsENL2w5NISKTfoVMIJoVyAI+H3fGUjxXpCN7fWrJ9kln9r8Id4Q8jG0WxHydEgx2BnwA6Mm1sM/HhLTFrZ0gZmZd/+SLJ3L/7qxMLCfOUOVAWIv2TnDFDAIZytpFX69SAy19eJkSuxAo5UMImzxmNT8Kupfer8QFrWE+aywmthB1i690Uwa4i/tIBJbhqknff1l/DSSqRalMxTrYyTtq64JSTu7Ptjm+38GRZVH/sX7vY/yc5P2YNYMpwPefM8CARmS0DMrIHvHiVZWdTKOhwT3Vm3rM5KPLg9ob1xU9AphMWK4171B/GdxYXnZe26r4YHWsjZj72WdUbAwAhROYZT7cSPA4FJijfZgM1GOdJHYWuzzMvnNWWVs5Sv/+v0/1UCO25ckzzEb2LOw5zSPbxm0Sop6/OcwX4Aqn9FACyAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

This series adds an AUX trace-buffer backend to the DAMON perf
observability framework, enabling ARM SPE (Statistical Profiling
Extension) to deliver hardware-sampled access reports into DAMON's
existing SPSC report ring.

Patch 2 touches drivers/perf/arm_spe_pmu.c to expose the PMU matcher.
This change is tightly coupled with the DAMON AUX backend.  ARM SPE
PMU driver maintainers only need to review patch 2.

This series is based on the Ravi's hardware-sampled access reports 
branch [1], and depends on the perf AUX kernel-consumer RFC series [2].
The dependencies is not upstream yet, so this series remains RFC.

Why a dedicated AUX backend
---------------------------
ARM SPE and similar PMUs do not deliver samples through the standard
perf overflow callback.  Instead, they write trace data into an AUX
buffer managed by the perf core.  The AUX buffer is consumed from
process context (kdamond) rather than from NMI, so the existing
overflow-callback path in DAMON cannot be reused.

The backend model adds three operations to the damon_perf_event
lifecycle: init (allocate the AUX buffer), arm (position the consumer
cursor), and drain (parse the SPE packet stream and publish reports).
The backend is selected at event creation time by matching the PMU
object via its event_init callback.

What the series adds
--------------------
Patch 1 introduces the backend operations table, the backend state
fields in damon_perf_event, and the Kconfig options.  ARM SPE must be
built into the kernel; the KUnit test option is separate.

Patch 2 is the ARM SPE backend.  It owns a per-CPU AUX buffer,
decodes the SPE packet stream (the same encoding that perf's
userspace arm-spe-decoder handles), resolves sampled
CONTEXTIDR_EL1 values to tgids under RCU, and publishes synthesized
access reports.  The drain runs before the SPSC ring consumer on
each monitoring interval, and a final drain after event disable
ensures no records are lost.  The backend also modifies the ARM SPE
PMU driver to expose arm_spe_pmu_match() for PMU object matching.

Patch 3 adds byte-exact KUnit tests for the SPE record parser.  The
tests cover load and store records, timestamp terminators, multiple
records in one window, PAD and ALIGNMENT packets at both odd and
aligned positions, extended addresses, bad-packet resynchronization,
truncated records, and records without a virtual address.  A split-
record test verifies that a record spanning two AUX snapshots leaves
the tail unchanged until the terminating packet arrives.

Patch 4 adds a DAMON selftest for the AUX backend.  It checks the
backend integration, the required AUX-before-ring lifecycle ordering,
runs the parser KUnit suite through debugfs, and on an ARM SPE system
creates a live DAMON session with a controlled userspace target,
verifying positive end-to-end pipeline counters and final
enqueue/dequeue closure.

Testing
=======
Tested on Kunpeng 920 (256 CPUs, ARM SPE, kernel 7.1.0-rc5-mm-new-damon+):

  ARM SPE KUnit (spe_parse_one_record):
    16 passed, 0 failed, 0 skipped
    (store record, load record with timestamp, two records, pad-wrapped,
     alignment at odd/aligned positions, bad packet resync, record without
     address, events/source/counter, truncated record retained, truncated
     packet retained, extended address, invalid extended header, pad-only,
     empty window, split record across two snapshots)

  AUX selftest (damon_perf_aux_test.sh arm_spe_0):
    SUMMARY: 52 passed, 0 failed, 0 skipped (Overall PASS)
    callback=58318, valid=58318, enqueue=43390, dequeue=43390,
    match=34049, update=564
    final ring closure: enqueue=43390 dequeue=43390

Known limitations
=================
- AUX_BACKEND_MAX=4: the AUX backend registration table holds at most 4
  backend types.  This is a framework limit, not a per-PMU-instance cap.

- ARM SPE must be built into the kernel (ARM_SPE_PMU=y), not as a
  module, because the backend calls arm_spe_pmu_match() at initcall
  time.

- The AUX buffer is 2 pages (8 KiB).  The SPE hardware pauses when the
  non-overwrite ring is full; the drain frees space and re-enables
  the event.

- CONTEXTIDR_EL1 carries the sampled task's pid, resolved to tgid
  under RCU.  Records without a valid tgid are dropped.

- This series requires the perf AUX kernel API patches [2] to be applied
  first.  These patches are not yet upstream and must be reviewed by the
  perf subsystem maintainers.

References
==========
Link [1]: https://github.com/damonitor/linux.git
          branch: ravi_hw_sampled_access_reports_rfc_v1
          commit: fd968106e5bf

Link [2]: https://lore.kernel.org/all/20260814144927.489172-1-kunwu.chan@linux.dev/
          perf AUX kernel API PATCH Series:
          - perf/core: add AUX buffer ownership for kernel events
          - perf/core: add AUX ring accessors for kernel consumers
          - perf/core: add KUnit tests for AUX kernel-consumer API
          - selftests/perf_events: add userspace AUX regression test
          - selftests/perf_events: add AUX kernel API selftest script


Kunwu Chan (2):
  mm/damon/perf: introduce AUX backend interface and Kconfig
  mm/damon/perf: add AUX trace-buffer PMU backend for ARM SPE

Lian Wang (ProcessMission) (2):
  mm/damon/perf: add KUnit tests for the SPE record parser
  selftests/damon: add DAMON perf AUX backend test

 drivers/perf/arm_spe_pmu.c                    |   8 +
 include/linux/damon.h                         |   5 +
 include/linux/perf/arm_spe_pmu.h              |  11 +
 mm/damon/Kconfig                              |  28 +
 mm/damon/core.c                               |  22 +-
 mm/damon/ops-common.h                         |   6 +-
 mm/damon/perf/Makefile                        |   5 +
 mm/damon/perf/aux_backend.c                   | 121 +++++
 mm/damon/perf/aux_backend.h                   |  72 +++
 mm/damon/perf/spe_backend.c                   | 479 ++++++++++++++++++
 mm/damon/perf/spe_parser.h                    | 109 ++++
 mm/damon/perf/spe_parser_test.c               | 365 +++++++++++++
 mm/damon/vaddr.c                              |  68 ++-
 tools/testing/selftests/damon/Makefile        |   1 +
 .../selftests/damon/damon_perf_aux_test.sh    | 414 +++++++++++++++
 15 files changed, 1704 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/perf/arm_spe_pmu.h
 create mode 100644 mm/damon/perf/aux_backend.c
 create mode 100644 mm/damon/perf/aux_backend.h
 create mode 100644 mm/damon/perf/spe_backend.c
 create mode 100644 mm/damon/perf/spe_parser.h
 create mode 100644 mm/damon/perf/spe_parser_test.c
 create mode 100755 tools/testing/selftests/damon/damon_perf_aux_test.sh

-- 
2.43.0


