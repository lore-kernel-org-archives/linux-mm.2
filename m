Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEBC606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bEeDOlBf
Received: by kanga.kvack.org (Postfix)
	id EC5606B0819; Wed, 21 Oct 2026 21:57:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46C16B081A; Wed, 21 Oct 2026 21:57:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35186B081B; Wed, 21 Oct 2026 21:57:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADBA76B0819
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EE7D40753
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:18 +0000 (UTC)
X-FDA: 85348599756.13.09F17A9
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6309F180008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bEeDOlBf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jDvqirGSK7roV0OwhESQvxR+V4XuKQKeS3pYEmaAuqs=;
	b=RW0rgEonXV0Sq5yWY070/MATYVdyDAcRa2NNZgZSiLteKv/PfDECmtc4s1OlyUb8j7cnkI
	jobKr8T/ktiDFJgi7E1fmdUBlNraSr0L8blyLGt3N1nQ7VQRs2aeovJiEDEdqxH2XhH8O0
	u02eIKhthhfpjSy/dijPjUj5hXviMnw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bEeDOlBf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634236;
	b=ySOY0uj+wAW8H+RZYe8mK3D03G06Gs86KMaLAZ5u3P4EO8bXD77cvYl9fIfWHBFcATv8qh
	sSPC6vfjn/6TXyVBUkfLPSgtAMR15a2zSzHbUiA6F6wbeUP0oOOui+EufsGJjcAomQkUgk
	RgAJxGr0sNYK06b9SwGChnbP6WCKTW8=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a06c60065fso871866b3a.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634235; x=1793239035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jDvqirGSK7roV0OwhESQvxR+V4XuKQKeS3pYEmaAuqs=;
        b=bEeDOlBfU7jIC/5HnAJmbkyd8Qz/dO20lYSFIa4LZjXc8gN1FmS6kS8Ipw8uT7k09a
         XbD7KAUitsuG80WSZcopB0R9pNc7I112GRoI03VMlwTnjfHlfPaorFEiKlzNvOlLc4jO
         kPypAYTFAirQmb71g3RxfbxeoBBu71Lkn0N5L3IJbksYYcvxt94ksAsrm0y+AvUhTnXt
         3dEafh3tGZdllATlY7mbTtSSi8tw2rReYZFChNWsleVNEUpjMIDUSzC9+XgSyrRRM04L
         7DTo7QldTnwf1xgG4wuBgakKfPoXxd8cmQAB3QbeS0+YJzifZRkWaYYgwuK7FSKaYgth
         7YUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634235; x=1793239035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jDvqirGSK7roV0OwhESQvxR+V4XuKQKeS3pYEmaAuqs=;
        b=LBdguruRwu6WMDVMG7ZvXRkg1xjL3kWFfRQGeBggWuxMN1mcGfoyNhBhJnJoFJFg9B
         vT4WWBMPvdaR+aAoyuwyBtMho+OFfTmuqt9lwo2V7v8DsVV9BjAmHBWjeZhb0UPE2TCH
         0R8ufcJHh7FtxsA5MnIIDMrwD3GcFSCMlbtNEVwDA72G9JSopQN+mcEzIYL7BwxHIv82
         l5kjIsmMUIc/C546shI3JDs17MJoNfLI/Igl0BGDS/8AihbMmJDYNqNNZZ/NM6fYsvgr
         yFVTM0msc4h33Ae1gqkGXiNoqCvrLETcehl9rkyfKoiPRngXse1UCdDnwAfx6gn/I3N/
         6WoA==
X-Forwarded-Encrypted: i=1; AKwUvBxLwFXw7GplCKnhbwvyzglgF9p3DuFg/aHPymlw+oZdBl7gxZMmN1iJzhjDTuSP+lmbZesM6p2VKQ==@kvack.org
X-Gm-Message-State: AFq9FYImOkWuw4PVc8ZUoBoRkb/rogi6rhSWErVh5OKoEODaFt3JGGDm
	WIhhhcsadUXOTf+3AkzEmOcD2Bc6YLzhxJkBOFnwDuqsLvamnMOVhkHX
X-Gm-Gg: AYBFou3ALsOh99MA2e7GI5ms/6wApKKlRn74Lk9G9k2J0mY3qyvC9xxHBkAiFXJhAmF
	dXK7FBgrQuSH4cBnbCS5y4pa3a7vSWr++isiv6gNe4UbhgM1qq+WdTkVF8Ca3HFxNAktUOfRdPF
	JFMwsCTPWFfo6OKKDG5Z5EndICLyRR6H2yBccAnuyc+Dr4xucwaaTn95xDShVXpzVHwWF9yYRHZ
	ZsP/Ttox/rKyabrOBU2fL19oJE0aXrR9jem/HV0YQlr5f2bRxt7VFiRqD5X0mOWAe2loQbtXiZ3
	mlS2U/TfM7W0FW7oyfc4B75nLdkrGKbLorUC064pEj1TTg3UomcgXlMfzwPa90B/dngXC3uaIQF
	YA0gdTdGSY0sIR4A9sOdIqxTQND+z8e/pNDOn79dHvGH7/drG6F4WvZEQWoLU9R60Hp83ERezb7
	DT9nZ1YiaxqWhnUw+2UXMffFXCSArq2gTuPadJY0q2rdGssrR8h8Uc8nkVBws9Gre4Nxp59yAnI
	0ceUumPURQKOQWa1Vr8Pb2lo9/NlCZGgjdocD+bnP6Kj6qlBOjHUYHY4a626SMai3HBDkb2cX7j
	FgGlEhoi43gyvFawsycXMc5ufCQVDVeHvQSM8pkdHr6foO6c8tnJ7WA5jcZEgPnzN5s4B/WoTFP
	wIZaV4Mh4eDWU6YLsVchuWoRj
X-Received: by 2002:a05:6a00:1493:b0:880:5fe5:a818 with SMTP id d2e1a72fcca58-8a089d7c431mr2804454b3a.59.1792634235101;
        Wed, 21 Oct 2026 18:57:15 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a089614ce0sm1426295b3a.55.2026.10.21.18.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:14 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/9] uprobes: Don't stall fork() when mmap_lock is busy
Date: Thu, 22 Oct 2026 01:57:03 +0000
Message-ID: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6309F180008
X-Stat-Signature: 679ycqaibi6an4fbzzd6znhhaj99ok3j
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792634236-790163
X-HE-Meta: U2FsdGVkX1/xkTxNc1CedIEUgQwSu/BPKCXFbaRlhpZfZGz4RCtHj1+Yf0f8M4uYX8JGsAcetp3bK8eIsUkqR3dlbd0gTyCswjEnHHWAtxTUtMug801PATakK7aAXlODLpqJAy88cLkYQVj3q8xq3va4WCKYHMJKAvQJN1edsJYZbbdcbiQ6GtXVvb38roYV88WCTOsuz5iW3Uh+wWzzv9J9HhuRslT+KIRuTcun8EsFKO+TXtI78IIg8pUUi/j2PB38AOByfnOOuaXrOjLVlAfCeZgninywn2FL6MJ9HfaM2Q56DcW8vSq7zLiTw0Hv3B45DBn7s49fAX8TH5/sNwKF3qCPh+WL0TP3hBmMEJy+SRg+IRJvNC9L92wxmVFOF52C/ufODqQUh/arL6L5qXIQoyPhYQIjxS/QptTIa+0i1HhZNop/fPjblBNVb6H33Hl8wO1J6va3zFbwgwzjGaMJdTCIJhkPqBMwBg7aQ4bheSBcx7CMB9bl2f2aZgS+oA7e91YSPb2BjeMKKAIqB1XkS9e79T9yf6HaBw44VhlEFcrjOErLfCKe4MgLUgAI/XNzIt7DUCRhcVe6QXruSgE3selfLRhp4jGF3Zfk8WE3VTw2I6EW8dUBf3A++9xY8cVDm8dVa6qN4F0whYZ2D2/u0dXOPjSjpv2cCo7rKubTJarmwPsA2wbnqyAq4V3YY79d+C1CZwgvr+DtZnj8V+yLvrTVKqi/kYL3A/8mH0FM1kPFsYf3UFbhqQBMnsoIU33MBUxnbEZd6PwSEMOYPiWunZy8mPuJkfqMKtXhKaSM0Ibjuwn4mCi/DiY4+xlBpVRYu0xlO38otF1pPr2pHhvOKv1fqppJS4JfI2iC1LKAHdyHju/nL6WP0zlHf1MaD9SmR6wGyXQ2UYlfTltWCNCdCdaaPC9d9jgV/XeNJzlpPISpEbaMHshAev6A9cUXz8AOLfMQWap8xPPmJaN
 SOXWLSub
 VHGjr8cZeC/5nFMRCs1fSBwGk4wRRR8C2TGk8UIIwslO4rkaS866A84ir0b8SbbEPVwzENbSwVSTFm/gbXj22ReZ52PGJRCynNQ3bYkD5hGQjpD4c43VgTuQ+DV/jb7AO0fwmL0GG6yoXnBtUDjqX1b0qchdlnWzJivNGv+LOkiF0ZOaXRCJBmy11j21fiKsto8sQbnLbWhuQSKysQULv5Wfk+51foKVNYaQn/KijVcfDpAmx5KvA94sJh9RXAk60sjohDYywHn1Et47f5TXPBSo4+yhg39xCxG6CTzn/1zawcCI3jrCsNKLdyRD72Tyb7LGAT73mtZ6gdaj3OtTejzBYy0lxBCvbGqOscuA+uEaU0eEOCCSxXxs2P7+A3TKFPhOeZiuZilch7ah4sR1KU6x9M9GilwXosw+5Wm32UkszcO1a9eoCQwNRxpKr7P4oz2Ux2xqbpwqzONEwWD90qa1u1qwjPTz0wectMc2yUXMJdqvBnTyyQ0f+OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

uprobe_register() and uprobe_unregister() stall every fork() in the system
when some process keeps its mmap_lock busy:
- register_for_each_vma() sleeps on that mmap_lock with dup_mmap_sem held
  for writing.
- fork() of that process sleeps on that mmap_lock with dup_mmap_sem held
  for reading. The next register_for_each_vma() waits for it, and other
  forks wait for the writer. The process doesn't have to map the file.

We found it the hard way by using uprobes in production. uprobes were
attached to libraries and binaries that many processes map, on a large
number of hosts. On some of them every fork() was stuck for minutes while
uprobe was being registered.

Patch 5 fixes the first one. Patch 6 fixes the second one. Patch 1 is
a helper for them and patch 9 is the selftest.

The rest fix old bugs that patches 5 and 6 make easier to hit:
- Patch 2: exit_mmap() runs under dup_mmap_sem.
- Patches 3, 4: x86. The removal of optimized uprobe that failed half-way
  is never finished, and SIGKILL triggers WARN_ON_ONCE().
- Patch 7: the child loses the breakpoint of an inherited perf event.
- Patch 8: the tracer that is killed leaves its breakpoints behind.

A process loops over mmap(4G, MAP_POPULATE) and munmap(). Another process
calls fork() in a loop. The longest fork() while uprobes are being attached
and the time to attach, in msec. 32 cpu VM, HZ=1000, no debug options,
median of 15-45 runs:

                                       fork()          attach
                                    before  after   before  after
the busy process maps the file
  uprobe_multi, 1 uprobe               201   0.25      217    232
  uprobe_multi, 4 uprobes              422   0.34     1483   1558
  perf_event, 4 uprobes                421   0.47     3150   3322
it forks and doesn't map the file
  uprobe_multi, 1 uprobe               198   0.07      212    9.6
  uprobe_multi, 4 uprobes              203   0.08      213   13.4
  perf_event, 4 uprobes                419   0.08      630   12.3
nobody keeps mmap_lock busy
  uprobe_multi, 1000 processes        1.93   1.83     4.24   4.49
  uprobe_multi, 5000 processes        8.88   8.60     8.33   9.23

I don't care which tree it goes through. It targets bpf-next only because
BPF CI will run the patches, including the new selftest.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Alexei Starovoitov (9):
  mm: Bring back mmap_write_trylock()
  uprobes: Don't run exit_mmap() under dup_mmap_sem
  uprobes/x86: Finish an unoptimization which failed half-way
  uprobes/x86: Don't WARN if an optimized probe can't be written
  uprobes: Don't sleep on mmap_lock under dup_mmap_sem
  uprobes: Don't sleep on mmap_lock with dup_mmap_sem held in dup_mmap()
  fork: Let the new task point to its mm before uprobes can find it
  uprobes: Don't leak the breakpoints if the unregistering task is
    killed
  selftests/bpf: Test uprobes and fork() with busy mmap_lock

 arch/x86/kernel/uprobes.c                     |  23 +-
 include/linux/mmap_lock.h                     |  12 +
 include/linux/uprobes.h                       |   5 +
 kernel/events/uprobes.c                       | 260 ++++++++--
 kernel/fork.c                                 |  13 +-
 mm/internal.h                                 |   3 +-
 mm/mmap.c                                     |  33 +-
 mm/nommu.c                                    |   3 +-
 .../selftests/bpf/prog_tests/uprobe_busy_mm.c | 447 ++++++++++++++++++
 .../selftests/bpf/progs/uprobe_busy_mm.c      |  22 +
 10 files changed, 766 insertions(+), 55 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_busy_mm.c
 create mode 100644 tools/testing/selftests/bpf/progs/uprobe_busy_mm.c

-- 
2.55.0


