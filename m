Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B7DC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 04:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47A0D6B00B5; Sat,  4 Jul 2026 00:56:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430DC6B00B6; Sat,  4 Jul 2026 00:56:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F28F6B00B7; Sat,  4 Jul 2026 00:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F10FD6B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:56:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 543D31C7C36
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:56:42 +0000 (UTC)
X-FDA: 84949883844.04.FF9C0C6
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D2EAC0003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 04:56:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7sypAEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783141000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YFwGSAkhDwqUDzFEg23WMafmVyoQV+WTTBxYcFcn7YY=;
	b=gooQWz7/vEU147ifvXJlGaRZITUD6SscDHVxbmVg67+7sHAb5zUmx1KoigvKBOPpX+2qXK
	6rnOKvFfrmfZN+ICATTH9yXsxY+5VMZi7QMuYeikAlyqUapIfgM8LSt+DKyyC6dNIgG401
	bw11q4BXRG/JNYv28/ZRgWRVCc853Hw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b7sypAEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783141000;
	b=7DQHjoSFFLh+U2TJy7Q3e0dQnw4hllWZCwy5nS1+WPZ2JLxb0SpvxYIweVmtoOTYtCctjj
	NnCAzN+cGhLZbA1WtR4iSEsN2K9BBgbF9jPN4h7nJDwC6IJ1gm6FS5iu4TyjKA9SRau9Kh
	Hrsto0C0OhBdMYvuhQ3LJQFalKQVwk0=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2cace91f112so9247625ad.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 21:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783140999; x=1783745799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YFwGSAkhDwqUDzFEg23WMafmVyoQV+WTTBxYcFcn7YY=;
        b=b7sypAEVEx36AaLYHCLT1xfIJSXCrL0+P6N1JXQMKse8fvISJUDOwL+SB/QvoI+CnA
         QNVGgnK7+WGIdl+oe4GmIe5t/edQOvKh2ztOrX52q+BmD2+AAjNqyNRgMNkAK07H8w6D
         +GzwCPcJYAEMMTQW1LrsnIW3ueOzrRJQyVJ0Yx9II7vKNWm7xn55vUS31sE9EEEZu+hh
         Z/3J2vMy3tSEA60E0FUkzsKHeQhhA8WxlhnEh/omJdK1Wnef9/0V0cEZYuCJIBo+x58m
         g0YqBGDYAFguRJxgUWXObmAIOXjklN7IktFaiL7eJa4z/OaoWWQze6KEQuNnT6H3769W
         RMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783140999; x=1783745799;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFwGSAkhDwqUDzFEg23WMafmVyoQV+WTTBxYcFcn7YY=;
        b=HlZTLPXCSayPuGCcxhf6Hj0bBg7v4s2OetUqMjE8crsPGblZmiWyfo6BRMjBx45JPx
         gpGk9UncNDpX4xmUxwRWaNzVKvbeCv5UuvVCgPIofY92eCRtoY68hWGxuUdRb9IWaEqi
         64OvqsHvt0xkIUPGL9kYKZhsAf1TkbLSmPNlvdLrG/BtJQOvlM/R/Ksh5oTXx1Mvi7ny
         OY94W40eC/Yq4HnRWPSCCcRDx9l/zMpOG0G40gieLccps5WV1sBz+/kHT4SAe/mWZ1O4
         XQQ9vXz2jeehFlkyIXvuhpuDqJSx9Bv0P9DrZoFlXlT7U7lFyJsSLjCwhKsVA9p4aU5M
         H/TA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5A/iyRyFgCQS+PUWNT9avsv2sV6qEAQltnrHfhHUOtaoSByFGimm8J/2lnSncQfOVQNYnGMLHwg==@kvack.org
X-Gm-Message-State: AOJu0YzIo0GFdFfWmY4qDtqLh4KmHqXWpfPn6hgicihIB/FUZVqO/jbB
	ip3ZfU7eL2eRN1xAaY8RX7UoeCRCVM0BKarci5GdGAUp4ALZQS3a1ysX
X-Gm-Gg: AfdE7ckZW5M8bVjLj9ehRSl0Ib9cFEagGDEY35LN+Klwe9dRrsbqp12yd90vP8WxCqe
	hG2ttAKNiWFlCRRffovZ12gZEWtuqyIEZ1Hag6cbIC9V8LnQDFN8ZfDRUOL0VgR5sF61JnbZvhA
	NbOvJkSVNPyEtwaNxL4tSUw0vsGf41CiFna6OhPn51KL+r7Jr0VTFCqWqLrJguksaVHkEcboNXR
	K9Q8Vwkv7+keWhsLdsox3jKXDlG2xzRdQIj3UfqJ3NKNb0WtWMaH0aG1IWl/q+H/oE/Ze0sWWsn
	IRvVtf1c4/ofgHWm/m0sLQM7jzTuVAwBvVaPOF7uPImEtBdXh/csvmboxbUKYqDDJLM2BizV32L
	3ExAXcUpCLHIOkrwWPGxwTG7FIzRAw+4aWQtstkxUTIur3MxTMNMfEp+wQNOAnO/OOKnK
X-Received: by 2002:a17:902:ecc8:b0:2ca:c68:c554 with SMTP id d9443c01a7336-2cbb9ecf4b0mr20612325ad.38.1783140999401;
        Fri, 03 Jul 2026 21:56:39 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa566sm24021975c88.4.2026.07.03.21.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 21:56:39 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	bpf@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg stat readers
Date: Fri,  3 Jul 2026 21:56:14 -0700
Message-ID: <20260704045617.487664-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tgj1fpntcz6qepqpucgoscnjarnrr6sr
X-Rspamd-Queue-Id: 9D2EAC0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783141000-931254
X-HE-Meta: U2FsdGVkX1//qkoRbt9xpZYuHzTU5943J/HYlfwdADN/XDWgiXbO4ds8hdOWJkoNAMdzusijISEf0hAtobBqncPKPXjnutqzZNgACnO/bps8+kAfOALLuA03rFY/V30hGi+bUAhJU/WpnVUF5lmn8eSArJr39xyrUxdjufSb/f4GIWyZv0XsHZcVTyden89D7KYtZ8QALuCG1GuBtj8rWV5SFmHukOgM9XAEGlAOh1zBIW5z69XpU/zVj+yEIvYOjtBgCpLMzHlzm0xuRy4AdykagtJWC9y0JrWzI0ZbD6JeWu7mIAQ4SMhfOORihhvsR4aIC6pj+Pt63u72sRsddrsPbvppDCNnQRKgfMblW8zf8ZtoVelugCfZ/yPcujPks6CC95o52qnL2cWR252uLYRs7KvUe0Zm+JVdxUnI2X4EJuN/MPKfD/OTUuluqV04xojBoiKtYspn50AZsSG0c4YDisGjwU5L6OEfrES/76n3wYh1iJIqUQAJkFMu5oO6/GO6Gu8xU9vM91SFP0/WkuE1R3uZe7GhsGsxMIejzptk83EFTr28g1iuFtiNLbAUGOkBMiLpw8eJZ0dXzkAvVfY3MX6yVJXYxVxHLhJ1hZ6rBxhyTE9/hKaCIKRd4JdAard1TMeyvXVAyOL9yACeuKsUPvCdTTbwxajg9tAQFfYdo+Ij71O98EKKCavQQx1JOaK7E5jbXmf0napdacFapZr3+SWeMuTSi0cI4MXDPayppu76t7+E4cK+ZNexAkOMdLfzi8j/9fn8wER+6ToH1fhDwoYsyxSLZ2eQjv9Rbi2XM0LVq0eSkQveDqHsWgrMY4+2vb503AhYjhRVjJf0Oue0F0eTvPEmKzWLHjvin/AHNQq08vJBD1IqOhIw/wOrcu1skbZbmcWvVLRPBKBPvng9N/DA6yW8rXNRft8cwWaZEKzaqmkI8yDx0TBZ3OQGsX50k1Kzd5ovK0yvnBy
 TF7B6lTY
 Hc0CPkZMTjB3j6vOHzD1552Z6aE6KhrMGePsFEm5NsA2adogUFI9fW1DjSQEYH7GZ0u+ZPkIdARpKuh2knmrvALw+OCx304wKs/7/t80rFE8nKva4D8VCNwfUFDexNGtA9KDqhdOhlmLYITkWDc3IUAjSwfbCtOeT4ELI+dKnYweSc4D9hHWE3OQVSBwL+ukUIhOH6F7boW7Ys5WN1mYFToLrBs/MPopr+orsln9kwpwLO/uRxM05UYt9DuWWXxXVbTO3mWA0k9Hw37vCw065+Q1IRJgPzyrzmx3hCkSRpxCtdmeOnmgRLDcvN3drju8YM7KxYfee9tFBOT5PGGFyEAoFr/GLN0YrpdcKNTNKtY3Ix0Zycw51TXenwOuOsSuJXfMf+22uT1uo8zXcE9b8AVz4JrRoimPcStDM49KBZVfiCPR2/sqyp53XDlFdu2jZdg6CKxpDleAgLvQgFuF9zYz+nOGm30BZVXJUktT9pcBgWcoWdOR46qCRRWrXBKnlHPDysG6cLBnoEEzsASHj2VN3Hjai8KLyO23k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear reviewers,

This is my first attempt at contributing to the Linux kernel. I am doing
an internship at Meta on the Linux team, and have recently been learning
the basics of the memory controller (cgroup v2) and BPF. I find these
topics really interesting; to help other beginners like me understand
how BPF is used, and to make a small contribution to this great
community, I wrote a few self-tests that compare two ways of reading
memory-cgroup statistics for a whole cgroup subtree:

  (A) the traditional path: open, read and parse memory.stat (plus
      memory.current / memory.max) for every cgroup from user space; and

  (B) a BPF path: a single SEC("iter.s/cgroup") program walked over the
      subtree that calls the memcg kfuncs (bpf_get_mem_cgroup,
      bpf_mem_cgroup_flush_stats, bpf_mem_cgroup_page_state,
      bpf_mem_cgroup_vm_events, bpf_put_mem_cgroup) for each cgroup and
      stores the results in a hash map, drained once afterwards.

The series builds on the memcg BPF kfuncs (mm/bpf_memcontrol.c). When those
kfuncs are unavailable (for example CONFIG_MEMCG=n) the tests skip cleanly
rather than failing to load.

These tests may also be useful as a small, self-contained comparison of the
BPF cgroup iterator against the file-based interface across cgroup trees of
different sizes and under different load. The pass/fail result of every test
depends only on the correctness / structural checks; the timing tables are
informational and are printed only under -v (or when a test fails), never on
a normal PASS.

The patches are:

  1/3 memcg_stat_reader - reads a quiescent (charged once) subtree both
      ways, asserts that the BPF snapshot agrees with memory.stat for the
      anon counter (which is rstat-flushed and deterministic), and reports
      the wall-clock cost of each path. It also adds a small
      read_cgroup_file() helper to cgroup_helpers (the read counterpart of
      write_cgroup_file) and selects CONFIG_MEMCG=y in the base selftest
      config.

  2/3 memcg_stat_churn - runs the same comparison while the tree is under
      continuous allocation churn (one busy mmap()/memset()/munmap() process
      per selected leaf), so each read pays a realistic rstat flush. It
      reuses the BPF program and map from patch 1 verbatim; only the
      user-space load model and sampling loop are new. Pass/fail is
      structural only. This is a closer simulation of real-world
      workloads than the first test.

  3/3 memcg_stat_churn_percpu - extends the churn test to make the
      per-cgroup cross-CPU rstat flush fan-out an explicit knob: each
      churner migrates across K CPUs, so a cgroup's statistics become dirty
      on K CPUs and a reader's flush must visit K per-cpu trees for it. This
      shows how the cost of the two readers changes as that fan-out grows.

In my testing (a 60-CPU VM) the BPF path is roughly an order of magnitude
faster than the per-cgroup memory.stat parse for a whole-tree scan, mainly
because it avoids the per-cgroup open/read and string parsing. The gap
narrows as the rstat flush that both paths share grows larger, for example
when a cgroup's statistics are dirty on many CPUs at once. The exact numbers
are included in each patch's changelog.

I used AI tools in part to help me understand these subsystems and to help
write the code. I have reviewed all of the code myself.

I would be very grateful for any feedback, and I apologise in advance for
anything I have gotten wrong. Thank you for taking the time to look at this.

Have a good day!

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>

Ziyang Men (3):
  selftests/bpf: add memcg_stat_reader BPF-vs-memory.stat benchmark
  selftests/bpf: add memcg_stat_churn BPF-vs-memory.stat benchmark under
    churn
  selftests/bpf: add memcg_stat_churn_percpu BPF-vs-memory.stat
    benchmark under cross-CPU churn

 tools/testing/selftests/bpf/cgroup_helpers.c  |  46 +
 tools/testing/selftests/bpf/cgroup_helpers.h  |   2 +
 tools/testing/selftests/bpf/config            |   1 +
 .../testing/selftests/bpf/memcg_stat_reader.h |  35 +
 .../bpf/prog_tests/memcg_stat_churn.c         | 716 ++++++++++++++
 .../bpf/prog_tests/memcg_stat_churn_percpu.c  | 902 ++++++++++++++++++
 .../bpf/prog_tests/memcg_stat_reader.c        | 617 ++++++++++++
 .../selftests/bpf/progs/memcg_stat_reader.c   | 181 ++++
 8 files changed, 2500 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/memcg_stat_reader.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_stat_reader.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_stat_reader.c

-- 
2.53.0-Meta


