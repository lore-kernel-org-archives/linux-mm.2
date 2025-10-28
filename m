Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60B6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCE18E000F; Tue, 28 Oct 2025 17:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D578E0005; Tue, 28 Oct 2025 17:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC088E000F; Tue, 28 Oct 2025 17:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDCD78E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:25:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90FC84991C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:25:40 +0000 (UTC)
X-FDA: 84048804840.25.9A39B75
Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id E2C501C0007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:25:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJGmTnRO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 30TQBaQsKCI42s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=30TQBaQsKCI42s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U4p6kxOlNOG31wIDXmwy414BSQw9sWas+789Bv9fSts=;
	b=4Rz8rhsY5nhrr7eHRUCA5wPnUYyzbwewktR61rlgX5+6+WI5rELlhH7+M4tLPY1BSHBPUV
	dxUBKkHegfpvuWNhkqUEiJdtLiZpqyw/w06KHTS2BpclHM03b1LmsH6gNlX8bhD1aISrjk
	wdQ/A6OWrN9MwpJ7GpzMMSPBkIfaxa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686738; a=rsa-sha256;
	cv=none;
	b=yiUTAi4Qqi8D9t7ZjY9PTUTeqHcyt6MoLSH+AD9PBaModVxLmcdgW84kDk3intK1JxLsdb
	6f8rqCQ7TzEc9Lt2O/+Fp5kUboY6a2PQ/nSV9nyv7NmgB8FuPhR7IhqWjpZetCDidiHHTl
	68DEDlfjrmYC4wCznSNJEoPhdp3h9fI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJGmTnRO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 30TQBaQsKCI42s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com designates 74.125.224.73 as permitted sender) smtp.mailfrom=30TQBaQsKCI42s3wAzA05yzy66y3w.u64305CF-442Dsu2.69y@flex--kaleshsingh.bounces.google.com
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-60fb0c64421so7869577d50.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686738; x=1762291538; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U4p6kxOlNOG31wIDXmwy414BSQw9sWas+789Bv9fSts=;
        b=LJGmTnROj6VwPXxittXWLs3sHKQuf8o10tl1FSEsr5DOPihYLzS7vX5JVPNgTz5Wt3
         CcL3sv0VU1p51mzfpS+2hJgIjtS/7tnNBD4hAogaqDCypLQ7wqk+TYvsgBLn/UMwqUzb
         9NiBwo7mEW/ygYekhWFwTkPDFcPxe8xcE0awAezcvRzdKrcrqEjl5UnrHGSsdAmVjayP
         yx94xAC3DvU00aSmOrhHt5JyeCWVjwp0Qw1C/SUvfPYYy/cDudAcBaRhxRPzem+Z62HZ
         U8unGOrOWcDR1sym7JnO87qAB3ajXjyedkeju01VMy5kUHj0iGyFAQZ95m+ZU6QNIXcz
         eGpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686738; x=1762291538;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U4p6kxOlNOG31wIDXmwy414BSQw9sWas+789Bv9fSts=;
        b=RiubH5XnT3hsONczmXbiqslPo2CTlIInWTpPw98JjoWtczlod0RFf8yOUMfxH7OVDc
         UDmEQCGdCEHk9ao5kb4uvSocQszt/nPU97kSpZ2iy2q3JUHdS09N3abSmtXF/q5eTk96
         c09hcQF18JhLpB/7oX0gAfKRTbQ4/LDgPlSng54qSaPu+FZIbbK6HJg7skOgbyK7WGIE
         Z8jnpnJCJ7R5fM/SkFD4iK3oxwci3zFT6euztegxl6wpiF2miwwNdM0UCIZDvS25QJxo
         T08lBvKh8rCF5ylc5rGoZsVTGh95PVMghDpgZBQ1ex7mUjOUy78xAVV66PyB2IV9YsV/
         Rgfw==
X-Forwarded-Encrypted: i=1; AJvYcCXap4raZUnZnIT94VuifB7yHct8TFYSifedGxVPzC4U/xaTlJyBRk4b7excoLX6dAuz40ucfZKIAg==@kvack.org
X-Gm-Message-State: AOJu0YyIjsVKF23dgh3WfgDHghNi2d9nedVxYkhofrrkVlupBrDndVTY
	3hUmzZbzINd4W0bbY0JC8LSEB+mHpLgZp41q9zrmeUosH4/rlS/gHpblx/A+ybgO/M9s4ZZf3N5
	Tj6RL2ACnm9N8YvpqGzT5glivJQ==
X-Google-Smtp-Source: AGHT+IGJWNdmzr+80PlpfT/LLo3Pibom+vpVqtRUcL1zZ6uSsgkD1esTGCr9/87u9nvyfQFqt6WKW0iDTdv7HmQAjw==
X-Received: from yxli18.prod.google.com ([2002:a53:c0d2:0:b0:63f:2d9a:6543])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690e:38c:b0:63e:1de4:7fc0 with SMTP id 956f58d0204a3-63f76df7854mr600821d50.66.1761686737742;
 Tue, 28 Oct 2025 14:25:37 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:24:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212528.681081-1-kaleshsingh@google.com>
Subject: [PATCH v4 0/5] mm: Refactor and improve VMA count limit code
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com, 
	android-mm@google.com, Kalesh Singh <kaleshsingh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: y49ma7w5rq1wdqpehdmzjnrfehmtx51w
X-Rspam-User: 
X-Rspamd-Queue-Id: E2C501C0007
X-HE-Tag: 1761686738-181850
X-HE-Meta: U2FsdGVkX191e1iCo/gyDLAMsPK9gYzE4c+Ys7pKbtCSAxHiJlRlDEDCY5K2Aofldd4cOhVQDVa1df5gZI+rrZh8GzzUvQQeQhP9ykTMUIbG9nD7X5tw4l45bzS9sb8af5I1t0/eQgqW3o9zJMrhSwyecJahxUCdupZfNxcYu/bEX5C6v99s5UJNnQS58f4f+iRiC3fuxo7I9+OhyXKFH6WePFp1qTCGlgYzIsmW0XTD7MN0NayFGx13OPLqQ8dsqN5AY2D1MZ73YUw3wX4Yb6zP9d7qlF72ogfO8xZLqe1XEVu/vHDd6aOwIftarQZLUUDtjODD4Vt+uyd4PSCau76NQAH+YIJ7HJ80UkbUBjkA8q4yFgTEmAp/rQ5ubXD6wVtPNcU8RwGbcjXkuY9omSDxEDntuBIaCTgWllyTDAo4+vKCHTX1IYD0nbsY0D7ZV1P2ZBKKHiKNmEP0XUDnIGuPeEch0R5/IZblcVSIuFPO3HvX3m1oMLtZm+AMoRgUEZ26R8LW+cLUfBparTHoJZ+8b8BOiabNlxhRywxbdShEH2+MHLBoRhSntXJhZXv5rqWTYmoQy26Ha/fo4jk6qppX2dGY+6LOu1QjUaOjdf5o1nAoR9hRCL3K0VxwAylZwHztsc1Qtc4XvlogVSgJBRz41O5JZ4L50Y/vIp1zPr2fdkL4c86A+R6ziIfUUZhxfsZp7wNhoSXKvcxV7koofPRh3fu2XIaqxga5tjIPV4F7CjiB5PWSjh2bGMxQZu6yAwrD8wGpaskynwSWNnvJV3ysijzsD+Tx+wBcacjdJDRPV/141OrhKhZ94g/VzUXC1kDOgX7LPKjYarKym8N2bBWFz3av0vQ3FwTwLtl5g42DcU5S2ATnwqN4zSekKWRLOW0t2CRn6fWPd4+4bTfSq6XR3cl+SPofbFBDcyNt/TrxRC4YegiRE9EPN/nsdOdNXzpz1vvuOue2txNpfZr
 efZd5lYb
 SJ5sUL4mbK29rJXJmxuyX5AdmGnGU/fiv+FoKSBrgegHSZ0TJ3qjG1fkOkQP9Uj5Lz3Qc+bIaFxrkA2l2jW4UYMZeCWMJQDUVkoQ6digCSoKq0b5mmkMPWev/HnIVtNWzVlK0zoOdn8lcnZOHDVHG4hIBBritUkZpTyhm9QcmpJXAyMPJPMRQIvjopmMbyrlERAVphs99CkXnp+S/BqjT99oOCoB++eGb6tOs8o6G9o29tbCrj6ivN1TiH2vIvu/sr/awOypxHQTkidca1jnKcq14nbFRAeG3TSYP3M193uKpsJAMHev8S21pXLixp09ONmqCdboQ9eMX9C08qEAc2mvqFgCoEr7+3aCsq1MwIWhBc3luuMNPtjVs1LW0gwT1Wpte3dwzvGQT34x8nDRy/foY0+Jt5oRVjTP6H0gj9tUIKCNK3t+NluSW+Rpzxma1y3GIKP26kJXe7d4nyDeE7CTH4vIeojREapQ5jib5qCiu1NjDThndlZOFGhN5BG1iJ1bTb4s/ABpLS/m4ENOK1LlP9zmUbcwoJ4BLid3XQEnerjeQ+GyNJyY14g+UK53HFpYeUquMgfG4oAqE2pSsDL2JSw5yy0IfKo2njZZ9wZ+uOieiuESu83De9rhltFOodogWYMvC02D+liT7+Mwj+GqzZ63zPDuEcjGiiN1OsudHpAJSidXHpa0/4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series refactors the VMA count limit code to improve clarity,
test coverage, and observability.

The VMA count limit, controlled by sysctl_max_map_count, is a safeguard
that prevents a single process from consuming excessive kernel memory
by creating too many memory mappings.

A major change since v3 is the first patch in the series which instead of 
attempting to fix overshooting the limit now documents that this is the
intended behavior. As Hugh pointed out, the lenient check (>) in do_mmap()
and do_brk_flags() is intentional to allow for potential VMA merges or
expansions when the process is at the sysctl_max_map_count limit. 
The consensus is that this historical behavior is correct but non-obvious.

This series now focuses on making that behavior clear and the surrounding
code more robust. Based on feedback from Lorenzo and David, this series
retains the helper function and the rename of map_count.

The refined v4 series is now structured as follows:

1.  Documents the lenient VMA count checks with comments to clarify
    their purpose.

2.  Adds a comprehensive selftest to codify the expected behavior at the
    limit, including the lenient mmap case.

3.  Introduces max_vma_count() to abstract the max map count sysctl,
    making the sysctl static and converting all callers to use the new
    helper.

4.  Renames mm_struct->map_count to the more explicit vma_count for
    better code clarity.

5.  Adds a tracepoint for observability when a process fails to
    allocate a VMA due to the count limit.

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

Link to v3:
https://lore.kernel.org/r/20251013235259.589015-1-kaleshsingh@google.com/

Thanks to everyone for the valuable discussion on previous revisions.

-- Kalesh

Kalesh Singh (5):
  mm: Document lenient map_count checks
  mm/selftests: add max_vma_count tests
  mm: Introduce max_vma_count() to abstract the max map count sysctl
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
 mm/mmap.c                                     |  25 +-
 mm/mremap.c                                   |  13 +-
 mm/nommu.c                                    |   8 +-
 mm/util.c                                     |   1 -
 mm/vma.c                                      |  42 +-
 mm/vma_internal.h                             |   2 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/max_vma_count_tests.c        | 716 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/vma/vma.c                       |  32 +-
 tools/testing/vma/vma_internal.h              |  13 +-
 21 files changed, 856 insertions(+), 52 deletions(-)
 create mode 100644 include/trace/events/vma.h
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c


base-commit: b227c04932039bccc21a0a89cd6df50fa57e4716
-- 
2.51.1.851.g4ebd6896fd-goog


