Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF7DACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0DC18E0034; Mon, 13 Oct 2025 19:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE57D8E0024; Mon, 13 Oct 2025 19:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C227E8E0034; Mon, 13 Oct 2025 19:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFDD38E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:55:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CEB95A129
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:55:39 +0000 (UTC)
X-FDA: 83994750798.02.9664816
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8CFE2C0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:55:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="jTtU/fOe";
	spf=pass (imf22.hostedemail.com: domain of 3d5HtaAsKCJ4I8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3d5HtaAsKCJ4I8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gOLw9DyCbQUK9US9qj81M7l3NRwOmAnngyQTgfMrJas=;
	b=2OqfytF3umem8+USJM8pheMUpv0YYLsz52B+/ke0AYkkPn9FTe5fLKrNU58panPVN49DHs
	HiAIozU3617+5QMMsf91ikYdlo3MeG0W/mb5jH8TZ+5D2ShkIDolkDRD/Eku1X8InzrvS1
	e6N2n02raYDrQzx/vvu75SzdR7e43cI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399737; a=rsa-sha256;
	cv=none;
	b=7drYY+E7lrgKJhEAi1fAzJ8J/Gu8PX5pJaNiHYO+4kH84DUNx0RpFvPDt2+OVps0lY9sJc
	bFd+ySktYiG0/iZR6JTGFyE6Kb9zJxPwsOhHwZOlbnhMOLe4qYn7EwG7PZ6fJblYZ7DbPK
	1U3oHatDb9KrSXNHFSmJJC7gArrSU/A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="jTtU/fOe";
	spf=pass (imf22.hostedemail.com: domain of 3d5HtaAsKCJ4I8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3d5HtaAsKCJ4I8JCQFQGLEFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee157b9c9so8293706a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399736; x=1761004536; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gOLw9DyCbQUK9US9qj81M7l3NRwOmAnngyQTgfMrJas=;
        b=jTtU/fOeWUzS4DkE2jCBVBPVBSKKBK2O+qCxu3KsOxaAyczwueIFlYuH4flH6r4vq+
         Fek9xRFRiWMk1TKN7+Bh2LgYcCMHQ6KtdosSVdyqMnf68KJw0ITn7ynNvvU4/yAbY4QS
         fsZuS8wBPrmASrTyi7YF4VYNF+JKaAe1UK2hUBLN4d4gAhNr6xgbwtthHSNH8ERXg1Df
         W8uW6xHbye+ey/jeYjt4tjewP6KMzTamRiMYktOtrfVkSKDXyl7Y+xNNGsyxtEiMTYbs
         5G0Gdeep2bwQffRJwpMhzv2vh5omc6cDyxrXFofOpaYOM9ls50ig0GsxiyRhv921v72Y
         3bvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399736; x=1761004536;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gOLw9DyCbQUK9US9qj81M7l3NRwOmAnngyQTgfMrJas=;
        b=n8EMRc0kIAtvTneVW8iECBTCt5OR4FJX1txNH5hyY67siH0PpxsgXAUiugGUe1Mo0B
         OmvKhLT0IcjojVkrzZVYtL3Kv8S3hdEC4+GR5xz9TozjkIX9+7W31rXBrkxMCQaqAVZ5
         MFL+I0cGxGuVBdARsA4rZfrJcsRVUBy9X9wyjmo0nqz6psCnJsy2LuiKLvmKUVQyTaem
         Ogf9fIyKDX7Nj+UJykWN+75qamHmLY/IOY9qqU6SJHQ8TbPJ0JDMUOPt/cLsI5ueFvyc
         gdxT9280GZwTPRQkcRApc5QgRaMMRsY81HIj3B1dJOXqP43k77TuKMngjGobi8aH6jzv
         zLPg==
X-Forwarded-Encrypted: i=1; AJvYcCWvzogM2Q2v2ynDvIVtSIDT3D3U6FLzBv6ajYBtCErKgkybteOWjh77mv05qX42Rp3GJL/PBh9t0A==@kvack.org
X-Gm-Message-State: AOJu0YyuBm27NpPk3tUuN5gP5O8B+r4iCsMU51NvC1hl0bO5hOiSMJ9K
	pg0oSlD0CG4+6WvSDb4LtBjN38B0MpksautDTxy3jLHsYZw1rwLBtaJrdUgJVUJ5pWd2XqpRi3t
	UYKDtN1BhL0BwKxcN8NMUCF/ENw==
X-Google-Smtp-Source: AGHT+IGFM4fnaJaclf+UwA57x8vAdATG64ugSFxav97RrXYX3bY+Pcic5KOI6oF2kEGVymj334kNdpoiwgiFgae0+Q==
X-Received: from pjrv9.prod.google.com ([2002:a17:90a:bb89:b0:32d:e4c6:7410])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b04:b0:32b:6145:fa63 with SMTP id 98e67ed59e1d1-33b5114d48fmr29169068a91.4.1760399735929;
 Mon, 13 Oct 2025 16:55:35 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-1-kaleshsingh@google.com>
Subject: [PATCH v3 0/5] mm: VMA count limit fixes and improvements
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: oz6jxhorgmcbuhzzawm4zk5p3d86ua7m
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CFE2C0007
X-HE-Tag: 1760399737-583360
X-HE-Meta: U2FsdGVkX18/DBIU4Ywvkw85tAvC7Dp/8gGzvvZQl4bkoPFCaxEYP5eN5qhafQaXTRGdyv4c/yg6MDF1d5XJJ+KUcPLLG479n2CNDbzURHaQaDtIo6uqdtbKVPJ8gjoWZcn4OrkwI6YtkBGTILvSKGm97TDldklpChJCRGBn6K9zVKHImWGoXAye4q3bv/YUQAdCNPj7mmChOetlSoC8jACy9Wi/6J1GGCLiYcIeJ0/JGM7nOEcouYClypWEWQ9e4meSL+eGvxIanyxF9hlG/GfLP858/NiQiQdhzecPeABNWMYCIDEQgJmzjiHPviK6Eh20hxIYSh8AWwAprUDZNsraPM/pCt7C0pi/0zFluqm0fvnFawZPqnHd/ESi8oqkJt9JKoqnOGNuMRWlnV1jRmUPhaHK0fD1lfETb2dsHvYwLGqgpxO5InXp1X4TPtv1wRiT7tyzw5AvwvaSfktvoypRgq/Tn6kCYCxIIv5ng7PVTh1p2xiL+lJlqxGQoaKg8JAKahixjgjb0LoiVXiTN0VH9F2t3A36c4bpcn0IK/rXFpqiv7TRJEEOCh/hQUzCsMQn+NI/5QSGR5+7IAjD9Un5uLqmpL4K/5cYlIVVizWAqvhX5SOGzcANU9E1ZQ7w7xK0stZmQaP4swjy7Puqa3RUT3ZZJ1FlJE5ya3sEOfcWKabIQY+NS4p2mBOC3kBf1vDXOwP4l5u5F8EcpxsKxnxrGrk9hjs3ofyWVydBMXVcwl9CSNuNGYHieba0FosdgXGe0DZ4fwUGaA4ewMzxrcpt/Gn0yh1yCZqvvt53mI8osqv1DUSHv3EKR5ieajVpp11dxcIBvSskQP8EBwLNB8Kk81NI5rHtbv/ezcN/T+6T+pFzOp/mm+nhtz/6L3HwPyw7Cf6pI04Hv34Y6SnU5879iLhumAd5rKOmfwpX7JqnOqSuDMqNSN8rkj96Te6Tohysr0bnvhIY5ig7Os5
 JApBbZKc
 54wfv1DzekSDUFMMVeRxsJFfeBcx6xF7QWw1VBAndcRqOykjMgej4mE2k+NJ+fI2zwzgyyy5T4wFsoGvGft6GT9oQku8gIQC0IzzbZgfYAHnlaIC25/2fr2Wji48YDUet95jj+SxXWaAjyaEK6LgT63EV8+IOvVV3KPut3vH9NjYlb4ph7dcMUvrkL9uG1cK+VT/RVQFWsrG6LBI1NTiTQoIX/51R2jnP30LtlJYk9k5gD2jSkcOQQ7WTc8+m4nnji4cnwA3sLmlafdCChvVODNHBSieJQa4Bqn6N8ZKIRialDUpcJ+of4PaS/PTTNeWOqq4J2MtaB5jBx1SUsEurTQTA4wpM2heeU29yDY8hkHaXDe0u/UwklH/AkvSCLqHM8+lnDabvE8Xv6mpdI+7bwuW3/k6B+4h/ccYZ3zD4e0ngjZ+UUckSQorM7PeD6a9vKhER/3xBk/Nm8sKTs4UwaRp8FTA7K/du7zjCMbV5sDGdpDyl8NJv3jflCue88ktuKE5aWpiavlGA9i82QSi0lE7pifQryzkNoa890fYmy9fdBSM24ELOnTzDL775PpaPnsCpGj548q5uVMgAHZMCiibm+IHJEMlvnzYf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series addresses an off-by-one bug in the VMA count limit check
and introduces several improvements for clarity, test coverage, and
observability around the VMA limit mechanism.

The VMA count limit, controlled by sysctl_max_map_count, is a critical
safeguard that prevents a single process from consuming excessive kernel
memory by creating too many memory mappings. However, the checks in
do_mmap() and do_brk_flags() used a strict inequality, allowing a
process to exceed this limit by one VMA.

This series begins by fixing this long-standing bug. The subsequent
patches build on this by improving the surrounding code. A comprehensive
selftest is added to validate VMA operations near the limit, preventing
future regressions. The open-coded limit checks are replaced with a
centralized helper, vma_count_remaining(), to improve readability.
For better code clarity, mm_struct->map_count is renamed to the more
apt vma_count.

Finally, a trace event is added to provide observability for processes
that fail allocations due to VMA exhaustion, which is valuable for
debugging and profiling on production systems.

The major changes in this version are:
 1. Rebased on mm-new to resolve prior conflicts.

 2. The patches to harden and add assertions for the VMA count
    have been dropped. David pointed out that these could be
    racy if sysctl_max_map_count is changed from userspace at
    just the wrong time.

 3. The selftest has been completely rewritten per Lorenzo's
    feedback to make use of the kselftest harness and vm_util.h
    helpers.

 4. The trace event has also been updated to contain more useful
    information and has been given a more fitting name, per
    feedback from Steve and Lorenzo.

Tested on x86_64 and arm64:

 1. Build test:
      allyesconfig for rename

 2. Selftests:
      cd tools/testing/selftests/mm && \
          make && \
          ./run_vmtests.sh -t max_vma_count

 3. vma tests:
      cd tools/testing/vma && \
          make && \
          ./vma

Link to v2:
https://lore.kernel.org/r/20250915163838.631445-1-kaleshsingh@google.com/

Thanks to everyone for their comments and feedback on the previous
versions.

--Kalesh

Kalesh Singh (5):
  mm: fix off-by-one error in VMA count limit checks
  mm/selftests: add max_vma_count tests
  mm: introduce vma_count_remaining()
  mm: rename mm_struct::map_count to vma_count
  mm/tracing: introduce trace_mm_insufficient_vma_slots event

 MAINTAINERS                                   |   2 +
 fs/binfmt_elf.c                               |   2 +-
 fs/coredump.c                                 |   2 +-
 include/linux/mm.h                            |   2 -
 include/linux/mm_types.h                      |   2 +-
 include/trace/events/vma.h                    |  32 +
 kernel/fork.c                                 |   2 +-
 mm/debug.c                                    |   2 +-
 mm/internal.h                                 |   3 +
 mm/mmap.c                                     |  31 +-
 mm/mremap.c                                   |  13 +-
 mm/nommu.c                                    |   8 +-
 mm/util.c                                     |   1 -
 mm/vma.c                                      |  39 +-
 mm/vma_internal.h                             |   2 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/max_vma_count_tests.c        | 672 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/vma/vma.c                       |  32 +-
 tools/testing/vma/vma_internal.h              |  16 +-
 21 files changed, 818 insertions(+), 52 deletions(-)
 create mode 100644 include/trace/events/vma.h
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c


base-commit: 4c4142c93fc19cd75a024e5c81b0532578a9e187
-- 
2.51.0.760.g7b8bcc2412-goog


