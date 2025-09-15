Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB2DCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985AA8E000B; Mon, 15 Sep 2025 12:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95CFD8E0008; Mon, 15 Sep 2025 12:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899E88E000B; Mon, 15 Sep 2025 12:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 772A58E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:45:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 025BC1406FA
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:45:39 +0000 (UTC)
X-FDA: 83892060840.28.D0BCF43
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3123914000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:45:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y8uJXANR;
	spf=pass (imf23.hostedemail.com: domain of 3sELIaAsKCKMNDOHVKVLQJKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kaleshsingh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sELIaAsKCKMNDOHVKVLQJKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rV+XG5RFGGx0WSlVed1inCLN42/DoGgCGt9RoOWZ17Y=;
	b=3KLYUpWN9EeiUlbQAX84huWRYxiEa9LX+ipae/U2sE9gZbQpC2uFy/GaU4mXBh4rtnqTCD
	yxLLYoyLzIPpEFP9cdzkqEsfMT3Y3Z5lCrWgLf4HJiUsRR1toVa585CP+p+AZwSNdgEQcI
	72ATYaSgTq1ll8FSiK/gI1rgefM76cg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y8uJXANR;
	spf=pass (imf23.hostedemail.com: domain of 3sELIaAsKCKMNDOHVKVLQJKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kaleshsingh.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3sELIaAsKCKMNDOHVKVLQJKJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954738; a=rsa-sha256;
	cv=none;
	b=nV1MeWu7b6cYxsRhttV7MFm6RL9CcUbkbWbzvRwFQqwZwS7jhNPzXxW0rEOUbbKarQS42G
	NG7kgFD/sczt44CxZwtr5IyCAHlp1pNYDCYNw9FzHKnPB0famHTNwPLKDis9Qu3JjgOvSh
	5oz//sBMWh1CFwc7dtSucnwncGoeLL0=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4f8e079bc1so3094181a12.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954737; x=1758559537; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rV+XG5RFGGx0WSlVed1inCLN42/DoGgCGt9RoOWZ17Y=;
        b=y8uJXANR7qwv1hcYoVLVyWxwxoMlBAKkA/YpkE1jVGeeDaFqwiTUD0hAqcFMaTOiWX
         JT9G74glXXBSzHxUk4txM2bSM9xsGIsfrRPPF2HkGSO2SdirC5p85rR0N5Rzjrv2LrMz
         +xlMPVxjDoeU98EDaZpIXdp8QJ/rZ2col01C1ZbOx3Hml9qV4lQSTaijrcySQQWe/4uU
         tYomt/7U+s1oKEtbZlOkndgV7dN8tINMghaq0wGc8bKwk/AOL32XsAp9DDKMfnERzHEX
         0+BSu/KvWZAx5lCmwAlboa1rgp9npr7qhTNBobKufbRpwzfghP5bh4ueY6uciccjNHgG
         nBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954737; x=1758559537;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rV+XG5RFGGx0WSlVed1inCLN42/DoGgCGt9RoOWZ17Y=;
        b=vbcGvYKOdxH8ZnuthyGwulOmfpzBG+3g2XDc3M82yVxdlGV/S7R+IXgBaGV1xWbele
         e0b2GRgiOt8klOF4+DGt5JUbZe6ht5vpwxKPdD92e6k57fdi0tt4BM2ntIhzg+FK9slf
         5tDdsRAzqp4frr0iiskCYaEur86PS6SDEHqwvqsaFjslvrQtrcqR/b/t4epWXwYMyFn/
         /ZB2gwijzNkWm5Z9o31/At7EfIgRcQr8p8Ai1BjjDQ0GbL3pf+k3ltDjH83kLCgPlnV/
         90/D3IY4YkpSUbnGlI8XcqvoUtPQRIk/VkNqF4LLPoPY+J6Grp37zsHxc+Da00TdFSqi
         7ztg==
X-Forwarded-Encrypted: i=1; AJvYcCUhHoanr12RCbJKQ/aNb8MsDb3i55s54ysX09cjxUzpaXyk1bV2HHw0Cz8sDzKarGVHfKDPzfXEWA==@kvack.org
X-Gm-Message-State: AOJu0Ywnbugtrp//xRh4i+Iq9WtwQuPo5W+e14VAVi19laeGBkXA4v8/
	ekAudmxR4KsW0qy/7V1757gIgPt/03miXOwNJOuoROrNnRiK7655oNqrvY+PvsDEzwjRpiNePhf
	gNkVZOrV6g2U7iW8R36PD1U0z6g==
X-Google-Smtp-Source: AGHT+IEAgY6VkXbGhl6l9muDNqmcvsiv9qd7+stbRvW4guJMBZCDnQLACUz038WuYWTWZXakBxrH9BGqLG7UDujvDA==
X-Received: from pjk14.prod.google.com ([2002:a17:90b:558e:b0:32e:27d9:eda1])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:2449:b0:25b:d1a8:5ccf with SMTP id adf61e73a8af0-2602a593791mr17106705637.21.1757954736574;
 Mon, 15 Sep 2025 09:45:36 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-1-kaleshsingh@google.com>
Subject: [PATCH v2 0/7] vma count: fixes, test and improvements
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3123914000B
X-Stat-Signature: ziaj991ksa5brn664a7dqxeyux4ad75b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757954738-17721
X-HE-Meta: U2FsdGVkX18LGt/4XVBM8FafOROzFJ832yuXOTHVsBkn9udjxiq7vZACDMXOi4zLk+aKRFB6+Hv23eeYqTIFqQSP+JCrzr1qVcCAUFX834OAUaFf6Hkt+JbMoIwum6KYypQZ6HbHAUFSPeWxIQ/Y3wOvZGFaZfffvaK5yy0n/E+CmSUBEZkntTKmA5s9ps5g4/YL+B7DEeJYcta5rC3tGJiKgW60TBY0A9R8x9OzuuPbt6w/DSqfWaiIhM9I1dKEa4cBP6xdxjj+1J/jc9wVnpeJXP69KAVBdKxwb0Wr5se2+vtnXkwnbIchpcyDKDvqNYbUfK/i6dUBBzkW7qxikw6Is0ZOwwAdoT6S5BI3X8ML/MDU2hSD+uD+WP1BNOtGzZ3wU7I9TmQzlcn+2xyMFT4dLzasYhYpAP11Gl/mh/wCKC+wFKcxOIxp0E6LJjTylOXF7DFWNaitLbSwUBPAubJ902/nvTorVzUhPOfjJIrztaMFNbgdLaLEsECV1KLGJ6igcmE3pQytrUxok/KtgYT2jXwXjhgms+VN+c52hG3u3EJyGcY+XB51gUNO/7N8NBDhyMt08bjFnVv96PqtoY6QjkzqkEWr0eB4RrEORbMVvCR3pdIwEZqOulbblZEJ4YaoxtPC3VCBiqc/E0PPTsCUCzNkqsjo0o8FdJzqgb5xd61Imr3Rzp99mNZgBsd+23TNxYSZXh5zsp5Dpe+HNIb5C3whx/u4IIWnETK9zruIAvKbonE9pJ61BlYWZTqc3SyhfzQ91M2CM5YXE9MzH08XPiNgC9El8bYjXSUVUM9RVI5aHvA9DzmhugcAyBnoRrWsh6sOji2p+1IVB5fZV44eI6+IF0DhAaK0ymSz1RZMDe5yaB99xYUCD647Bk1wBDE8iFSdmCjq40xIwvjk7Abu7TKp+NkSDnTNteJqV7DjG2KzJveQiZzXO8OOiYV1IeWJxtmucRiTIF+BNED
 GS5JftFn
 1VSCHhoRss1FErt76j6mp0zAfbBvnEgQgeSFHdvVqyU+7tIMm5iVjP/I4DWJxdsbjTVNljAM9IhYoMF+VI9sXwrL+wILipVpxsuviBeciftnYz35d2RCjaXjT4rqxtPzSE7bIdw2l7G06q80VaZL2bSXoOgj/x3J7pkEtQDWm6NgEZoJZhRmHVs+S+N6US/yunEkp0cfWr+UGCTDo8R7KVqE/TjTFf8Qrs/IUtX8ZjOQ8QsKd36QnuaImyUZcu844qKt9pET3FzsFdHILT2sf8O60iJGE2XiX3RHULETQtbKyTyEK1jMqp/LArjzrr85qnBNwM7NH02nBukx2P8pJEtvK4Di4Dd2INihfp70WQdR3m4ss0KhzA17Vtm8L8ljJ2zqolPhWpItwttBuARgnr3BiCPs/o1VTtaJGAFGoMeniaS/qnVIu51nIwkKEIfUHnj3llM2nkX8RRz/VPYV7CMOMgboE4TQYl8T0Vu1sT5SHvpCb9ZAMWSgjP946+wipMoUCgn6ROLCkGOPh1fw50QFRlNeoIqSUs0BGRLzi3aEVnor+pbyl+p60ha2KtYrwlGRHCOnyyJuEgQUBiC2lLRgMVFVwCBexGPKN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This is v2 to the VMA count patch I previously posted at:

https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.com/


I've split it into multiple patches to address the feedback.

The main changes in v2 are:

- Use a capacity-based check for VMA count limit, per Lorenzo.
- Rename map_count to vma_count, per David.
- Add assertions for exceeding the limit, per Pedro.
- Add tests for max_vma_count, per Liam.
- Emit a trace event for failure due to insufficient capacity for
  observability

Tested on x86_64 and arm64:

- Build test:
    - allyesconfig for rename

- Selftests:
      cd tools/testing/selftests/mm && \
          make && \
          ./run_vmtests.sh -t max_vma_count

       (With trace_max_vma_count_exceeded enabled)

- vma tests:
      cd tools/testing/vma && \
          make && \
	  ./vma

Thanks,
Kalesh

Kalesh Singh (7):
  mm: fix off-by-one error in VMA count limit checks
  mm/selftests: add max_vma_count tests
  mm: introduce vma_count_remaining()
  mm: rename mm_struct::map_count to vma_count
  mm: harden vma_count against direct modification
  mm: add assertion for VMA count limit
  mm/tracing: introduce max_vma_count_exceeded trace event

 fs/binfmt_elf.c                               |   2 +-
 fs/coredump.c                                 |   2 +-
 include/linux/mm.h                            |  35 +-
 include/linux/mm_types.h                      |   5 +-
 include/trace/events/vma.h                    |  32 +
 kernel/fork.c                                 |   2 +-
 mm/debug.c                                    |   2 +-
 mm/internal.h                                 |   1 +
 mm/mmap.c                                     |  28 +-
 mm/mremap.c                                   |  13 +-
 mm/nommu.c                                    |   8 +-
 mm/util.c                                     |   1 -
 mm/vma.c                                      |  88 ++-
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/max_vma_count_tests.c        | 709 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/vma/vma.c                       |  32 +-
 tools/testing/vma/vma_internal.h              |  44 +-
 18 files changed, 949 insertions(+), 61 deletions(-)
 create mode 100644 include/trace/events/vma.h
 create mode 100644 tools/testing/selftests/mm/max_vma_count_tests.c


base-commit: f83ec76bf285bea5727f478a68b894f5543ca76e
-- 
2.51.0.384.g4c02a37b29-goog


