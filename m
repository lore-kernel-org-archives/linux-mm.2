Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8037CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1766B00C8; Mon, 18 Aug 2025 01:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852156B00C9; Mon, 18 Aug 2025 01:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A2D6B00CA; Mon, 18 Aug 2025 01:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56D226B00C8
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:55:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D19A11DDD7E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:27 +0000 (UTC)
X-FDA: 83788815894.18.7779A01
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 070A4C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cl0niKCM;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zvxQ1/uTL4P7DfPMu9exFJ5IOK6MPi65nYvIyHfL3OM=;
	b=XG0ijWxNEwT8TcwggQCun8omy2QHbt/0kTAk6GGdQ4ZLSWPqbMu9Tdr2RyPsMJNzYYyWgv
	b12mP0GTPeezLqYGZiU21+0IcP7ktlxYO9oxsUmMxueX3N5xcrv3x5DuSiLlMPXpHPWfRD
	28zdpTNzvq69YL8k6ZmL1Sjr6g9hzWo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cl0niKCM;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496526; a=rsa-sha256;
	cv=none;
	b=hRUUJwqg7ttMVFEgIQbjGkrzV0YZNNQQtsV8cilt9hPKy60NH/6IZd8EWrRXKnJQGw6kOB
	TXCm9UQxJdMZIPNaSUOto3YRcONUXik3sgULucQVml8Dq2h5QhwxuXmkNx3HBnK8jCN5yA
	WSCEyZfyInhjahoE3AiebwQyBsxYHn8=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b471738daabso3558603a12.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496525; x=1756101325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zvxQ1/uTL4P7DfPMu9exFJ5IOK6MPi65nYvIyHfL3OM=;
        b=cl0niKCMtU7VKDlnKURYlV5AthcMPK33YBgn7G3QcvA94OjUZJwlG4X+b7/IvdDqps
         A1tQl5TIjoE/tQf9XAIjugQlDj2FzvFXYtW5NM0cZJy6J8vOgVfwEAeT3KXsKgAIta57
         OcM79F57AKrBT0u1RsVh6tboqdqFU2PuMS0M11R8V8Y3u0fvDZple7peKq7KBi911VMq
         zehfmT8VqMvq0dk6tf4jHkYOrf//eta9LN/7PuPzEeCFiz1o0rBc78Azd0coe/5p0pWV
         z26jWYqqNXTrliTHQvxOgtkP4NRAXovanhT7u/d9nouigFKO+LpZVYUpgNd7v+1odsqT
         M55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496525; x=1756101325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvxQ1/uTL4P7DfPMu9exFJ5IOK6MPi65nYvIyHfL3OM=;
        b=E1ZxnR4Lthkr9sZmTkYUG4TW4DjOnHuZfjr1Ksdz9PgEiGD/cjHxX7DOJI1QNEalyA
         q1ZEjJ+LWqgsJI88poipEzIACps2Rcm/9QyH37Ls30kHp5MpiMNENn5X1LjbrKJD3WnD
         RJaVY9FNopZTMrslR5C3/gexOrpRPr6xXWspENPA+KcrdxxNj9Epmt8NIuDzGos2e1pF
         a8GY5DkihEvhJmW3l4M9+0aGbwv3wE32voak7UGK/hXEjrlf2g5IpSEGUD6IILrEMDg8
         YoSR7zvoJOiDz4z/Ue3oj0jE9r2ABJasz/pDeJPh3CKLUfTNqVKnojhpxEjAWopWxSNS
         PSDA==
X-Forwarded-Encrypted: i=1; AJvYcCVgkGQUBrTSmcWD7GG2SdhUH4CA7q2086aC/6AkZp/8ZxNUsMe+bByZr6Qd2H8ACXedJCH+su6g/Q==@kvack.org
X-Gm-Message-State: AOJu0Yw5LmRSU8rFWex3JiOkP8Uev6cKt9W3NqeTkskLi7elLw8Z38La
	AQg90jwOGzzys8o+0GIiCZykxWhgpEQx7gay5HU/uFvrlXBqZyFg+5UC
X-Gm-Gg: ASbGnctAKHoprj6PI+9ON28ReGUlE1AbKdUamiwWyBWm56mpdMeoBilLLkclz9IC9CV
	eJOdXe3KYqYN5ukvGXzYDllUxeDKqUBrkHe+FQxy1703Ut5+K7cbGsrrjDb6gnRXSAt+hYYafIf
	+3eIgbZYss0iUz+k9FMOVbaLeEQXrrNPtHNQ8f7/6VlT/EcwVjdtea8yC4rWwWz4IB6rd/YRsEz
	0216jmgPcGRkmMN09PiOAkBDgcAONE9mQaVYufYt6w7AT2r/OysMnPUGerAAsDCL93/QrFdBJ5X
	0gjoiYld/asanjeYWNwuHHSrjxULMdx+Wa6ql2gwo1tXEH32F/DIH7fYQXUOO82qlXbinnqaiF2
	cAwlRS8mviveUWgW2HpAlOUsX7YGEfsm3031z0USo5MiJcRmQDRVXkFKq
X-Google-Smtp-Source: AGHT+IHVmXW7GtPHCjFuQWBWihlY8bin+N9ybbXeSckobNgHCosgk1OBnu814SdZ2A2iY/x+v84Qxg==
X-Received: by 2002:a17:902:da2d:b0:240:bc10:804a with SMTP id d9443c01a7336-2446d8e1abfmr125857385ad.43.1755496524712;
        Sun, 17 Aug 2025 22:55:24 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:24 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 0/5] mm, bpf: BPF based THP order selection
Date: Mon, 18 Aug 2025 13:55:05 +0800
Message-Id: <20250818055510.968-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9y3aofrzcfwujhqppxz1rphg4tk7de1n
X-Rspam-User: 
X-Rspamd-Queue-Id: 070A4C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755496525-905987
X-HE-Meta: U2FsdGVkX18z9mv9t9QljoyHtZemnl6isS4VSLyb8Ve2EzMRHpK04SiSr4D/B5Y4qnVe0nKoYRPA9y6v5KVSfCjTe4zlGR6pcB1AwNWpqOgJirW233Drxf4ZxrXXODFwYbC5YgRm5PB3VjGmwPF3L7m8rYU1Qgp007tzLvadXm82/XM0UpdsPazcwQ6hl+F3bDY2iu0AiORIGmfBgi8HuyLEXIcaL7fnK9Bl1BOCf/rDtfrgeTcVVQ/Mt/T88A5pgrGQPFFNHkDfG1xHAVKWeUsd1RPiZlU3bAOPv9zk11dt7/YsCiVk5uh7TQvVGe+aLzK2noLh14IbEvLHeC8uXuUyzVYHJcZLAgTlMd0U6VoEDMXgFQayXyxqWECrtvA+Ls1t5hcynlFlP8jHAu8FJC0LxvtAfxNW1Mod868ZjMomxxEP5mW4TcAmrG82MsU52B2s09l3TptkeeSQ7qXLPeqxyh/AVaaHaK56Ty1/ivb5YIBnyqJ0DwmwjBuSx4ruBlrnmVlk9U/87Qa4JNUnnuTEb9vfKUI3JHLHNG2KifJPwreEa6wtK2ftm1TFu35YLXJ1aDElc6EYbgdfO3izYKguPuuYsIMBxbXQRYvhVmdjqPZZljQDJYHdbKzxaOm8eVoSAILOGEVKYhstVnKflWr9wf7+n2IbZULy2uEuHO/msr/rXBYHzgc6dWsaGPZRXHNyyLxnz6RH5jwYqKLS8V2R3AuGk6Wx+/0qYmTSdx3FJpu8FTxkOo1QcJBleTGS53ogzs3eE6CsimNERVqeFqN0I7NRzsn0Uz1lcb29lGTWyIFC5lVNcL6rZb2G9wDRQaTsEMEQY2XWac8o2JYyl9AFpaPNXxdRKVUkJnsKqmaBBVGMh+WFFqJPAzdff9GzfHfR8vXDfh/sjLDAdyxY9wJwrZ8ICYaYN2kEUqa1s+Ey7L1odNYeUyCn/bLI+Us/YwoydxIveWeSsZ0oc4s
 WsUOujG6
 +/7zH7utEOkYI/W6bNyD/M6o+9gkEEvstVrvGxeMhfBmy+kwBAVy8luhmsoexMsbfDLleZ00YeQPwhyqA4CDZmZ/PU17YbRAf49CTB2rVUIMG8UovmDvtsaC4X5pwS1uvsH0X9ilyU7re8Rv7sRHhsQMcVL/zeIptfVYHSJbQyaHgkd4TL/tm3GjRHww4pnXf6HvQCpE45bzVtwZYlpCj//3pSL7nLLU+4bUDWXRatOB5raXD+K40MH1kqhGh/MIC3idFepEMrhD3fOSWhXTWvE8mLtNKLryg5f7UKadj6y80m4i6Y6/GGSrqjkcXWWYlaAPn+up3IHlzezZDtmS/u7heCQ2j5xzOe+QwvFM6VRXJaiOOvejxjMwbb04cOV2gpscgWjWJMnwM4xe8loBXLAvP/8x59kJOsCBRPpd62oX6+/wThjHcuxODjAToMacHij+WLfvX+xmZErsr848aqjJ0j2rvUikzQCL6iAbLBz4zgkMZ5HV1ZPno8RmJJNzsp0uDUumi4ys1oyrl2UUf0WCozC0OKDewSwaoBgqjoU1E66kgksY6faUFu3SZvmt7ed1MROLFYO9woVK2WvowhUtYqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
----------

Our production servers consistently configure THP to "never" due to
historical incidents caused by its behavior. Key issues include:
- Increased Memory Consumption
  THP significantly raises overall memory usage, reducing available memory
  for workloads.

- Latency Spikes
  Random latency spikes occur due to frequent memory compaction triggered
  by THP.

- Lack of Fine-Grained Control
  THP tuning is globally configured, making it unsuitable for containerized
  environments. When multiple workloads share a host, enabling THP without
  per-workload control leads to unpredictable behavior.

Due to these issues, administrators avoid switching to madvise or always
modes—unless per-workload THP control is implemented.

To address this, we propose BPF-based THP policy for flexible adjustment.
Additionally, as David mentioned [0], this mechanism can also serve as a
policy prototyping tool (test policies via BPF before upstreaming them).

Proposed Solution
-----------------

As suggested by David [0], we introduce a new BPF interface:

/**
 * @get_suggested_order: Get the suggested THP orders for allocation
 * @mm: mm_struct associated with the THP allocation
 * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
 *                 When NULL, the decision should be based on @mm (i.e., when
 *                 triggered from an mm-scope hook rather than a VMA-specific
 *                 context).
 *                 Must belong to @mm (guaranteed by the caller).
 * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
 * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
 * @orders: Bitmask of requested THP orders for this allocation
 *          - PMD-mapped allocation if PMD_ORDER is set
 *          - mTHP allocation otherwise
 *
 * Rerurn: Bitmask of suggested THP orders for allocation. The highest
 *         suggested order will not exceed the highest requested order
 *         in @orders.
 */
 int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
			    u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;

This interface:
- Supports both use cases (per-workload tuning + policy prototyping).
- Can be extended with BPF helpers (e.g., for memory pressure awareness).

This is an experimental feature. To use it, you must enable
CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION.

Warning:
- The interface may change
- Behavior may differ in future kernel versions
- We might remove it in the future

A simple test case is included in Patch #4.

Future work:
- Extend it to File THP

Changes:
RFC v4->v5:
- Add support for vma (David)
- Add mTHP support in khugepaged (Zi)
- Use bitmask of all allowed orders instead (Zi)
- Retrieve the page size and PMD order rather than hardcoding them (Zi)

RFC v3->v4: https://lwn.net/Articles/1031829/
- Use a new interface get_suggested_order() (David)
- Mark it as experimental (David, Lorenzo)
- Code improvement in THP (Usama)
- Code improvement in BPF struct ops (Amery)

RFC v2->v3: https://lwn.net/Articles/1024545/
- Finer-graind tuning based on madvise or always mode (David, Lorenzo)
- Use BPF to write more advanced policies logic (David, Lorenzo)

RFC v1->v2: https://lwn.net/Articles/1021783/
The main changes are as follows,
- Use struct_ops instead of fmod_ret (Alexei)
- Introduce a new THP mode (Johannes)
- Introduce new helpers for BPF hook (Zi)
- Refine the commit log

RFC v1: https://lwn.net/Articles/1019290/
Yafang Shao (5):
  mm: thp: add support for BPF based THP order selection
  mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
  mm: thp: add a new kfunc bpf_mm_get_task()
  bpf: mark vma->vm_mm as trusted
  selftest/bpf: add selftest for BPF based THP order seletection

 include/linux/huge_mm.h                       |  15 +
 include/linux/khugepaged.h                    |  12 +-
 kernel/bpf/verifier.c                         |   5 +
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   1 +
 mm/bpf_thp.c                                  | 269 ++++++++++++++++++
 mm/huge_memory.c                              |  10 +
 mm/khugepaged.c                               |  26 +-
 mm/memory.c                                   |  18 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 224 +++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  76 +++++
 .../bpf/progs/test_thp_adjust_failure.c       |  25 ++
 13 files changed, 689 insertions(+), 7 deletions(-)
 create mode 100644 mm/bpf_thp.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c

-- 
2.47.3


