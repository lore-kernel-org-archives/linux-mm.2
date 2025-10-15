Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F3ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41C88E0015; Wed, 15 Oct 2025 10:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19DB8E000A; Wed, 15 Oct 2025 10:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FCB8E0015; Wed, 15 Oct 2025 10:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFBC68E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:17:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7476F14017A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:34 +0000 (UTC)
X-FDA: 84000551628.05.3E9CE89
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 897C980018
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jluG1qeX;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Oj+ydMXRn5MLbgkqPocjemDIu7tpHUxcEZr4FaQqDcI=;
	b=YaH5CWDpHmxaf/XAwo1PQ2OPtyQtinYwZzt70mBBZiDtWGW3ae7WC2TmTSmk73ESfkVx6Q
	5yzVbGB3tPi6cla9CctwGuddIJ9v+mA38+6b39yoMinpkpk74MEVVGwuAg3wev5PhRdi5H
	XdvUmylr9XwpAkK9koWX1pi00t+DhZw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jluG1qeX;
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537852; a=rsa-sha256;
	cv=none;
	b=hpugEzOxnXR/OlSi+YHU/JL6ZqyFfjkvEgGhfRrIaOS+0RakWoCPYTC6y0ReRm1QCPWg81
	yFUOx0ed2WWj4XCc/2lp3QBUzsuxkZmbxftgeMHpbpWwxDJd0BezsJQUj28lKAtOjHMA8X
	WVFPgWomVPjiKVXETMWPKZ822/EQhus=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b5515eaefceso5731654a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537851; x=1761142651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oj+ydMXRn5MLbgkqPocjemDIu7tpHUxcEZr4FaQqDcI=;
        b=jluG1qeXD0YFWt1gePjXrqLKHHstmJUvScN4RGKvscQ2x+dsLwTALcsVuhmBhyzLCo
         TFJVI5x6kAATCvTBgTgxtJzwR4Fs7ENsULnz3YTwiG4U0a3C0eihnn5yK9qFrqepVDNj
         K1bHYDtS+BcflgCmyxqNuUwmBSBe3/W7tfOin2mlzAFA3qv+qwRglltTHn4D6j7lRX97
         B83IEALJRWrHYn+GkWegH6VWAXzxF7ZYWkSxdW/NzthwOi96fhUsCbOKVXnQj1Ss2Fu8
         n+SVKONzyldBrLoaz0HgFOBkGlV2tqO3qzycDl8zRhrya4hcT/eoisWjj1JJTOu/7vbC
         XzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537851; x=1761142651;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oj+ydMXRn5MLbgkqPocjemDIu7tpHUxcEZr4FaQqDcI=;
        b=uJQo8aIlPLKh/AEC/Vk6ldpn7Tn1fXRI/vht0y7euwCtROLlzi9KshQEkafysPFgmX
         193EBL9orib0BPzAzNkENMK7R6lmOAheWx2Txp/m0ldrDEo08rZljR1hH2g8W8/QPkFW
         LGHAx6QZAA+r2xp07yZGn8Q2uxC984vklUl+apiGXAbi04JePH7uZqaxbkaONsfvpwvT
         DCtEgId/uqaWoDB5wFOsiA0aqVfFHttXqT2GsSTGLL0NiJJHHZ7jhO0VR7vhu12cJgHX
         L6khsSgsPQawGj1mkeWY0JnL5xh2jghFJEuYOxsRuDKXz8EjhjgPNaHQj6AxqhzBwH+9
         OGdA==
X-Forwarded-Encrypted: i=1; AJvYcCXTvkR+FprwS6QoCzg0i5DGbWtUfFujfYGsV3JmOraXCMc43H5bo6q4/3peu1OEZkClB+tTN7I1iw==@kvack.org
X-Gm-Message-State: AOJu0YyA3NePQ8BjhieT3Fg9mC1QXrRTvuAZP1blixivaVJbmWDKCoWe
	lZrmulBN/IIpstPhxU/AYM626hBjpPNNUVIqx/HiO9gWgZSud2gvnYzj
X-Gm-Gg: ASbGncu89Pn0OHWbs81P+NNzhrSYPThD/Q14MMUI30DBmWSVmb7zE0g9lAL5JeuW/Os
	/ZWoB0Se5QOg0GD1c/dUeRmN6zKk+ZrliL5QINVV7quISjPhgnRUR/gS+tC4T5sRz2/QGv6pxJ8
	/sPP1G8B81+K/Wy0xPR9Mwo1XdKcbjMp4HHzdkGswM5O32XKIGuUEgOOIgoLZzC3B+QjhteTTTQ
	kxUhMpkO2M83xjk9Gt2Sb73DFystjMIuMtWJgFS+HoK4J3veoGeDKzehAi2nP7mli1hOBWOrL+6
	/pM9FVuZ/K/BQx2bTCsIFqzaBQtPwGog1DUxfoJSpaUbco1xn1OZJEIBdqv7W94Fb/VMYz5Bp3Q
	TvB1xXu7VA9falVm4H7tW8jWLLtZx8dobKWRe1QkDXw/qMUzte/U51jwCtPsaxawoyxyZL3jm2T
	kGMdQdi08ye+bbjjld
X-Google-Smtp-Source: AGHT+IGuJx98l40hIZg5dUMNPdMQulw8HXVOdNxJ7NPVkMrPiNcWb89bHsacFna+VcftnBNkDQpvBw==
X-Received: by 2002:a17:903:4b08:b0:27e:f005:7d0f with SMTP id d9443c01a7336-290273ffc50mr333828565ad.44.1760537850713;
        Wed, 15 Oct 2025 07:17:30 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.17.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:17:29 -0700 (PDT)
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
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 0/9] mm, bpf: BPF-MM, BPF-THP 
Date: Wed, 15 Oct 2025 22:17:07 +0800
Message-Id: <20251015141716.887-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ad4rd6h9ockdnw1nc5uwxwryjbjwahhs
X-Rspamd-Queue-Id: 897C980018
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760537852-841805
X-HE-Meta: U2FsdGVkX1+x09dQ8zQH0IRbMGgFCBT4+Riw8A5zsoLz5XdC/UkIl3Bt0GEUQlHZ5MrKs3cxQA9SlqiQXOQ92Tocr42Giq2itYYQo2riRqmrZafzcG6N5+aU2R7BHD2DoY9EqdCf7P/rH75AiY+sVlyxueZR/kRDKA8Oj/w725SGYDi1LB7JYjwszv8q3aJ1m+ZOmZY7yWQRBW5Cr0PAJZ/BP5BjP55g44pD47nzSEVw8OOqke+TGunrUFKGigSl/v/drD60dOJjZYF2hvuRj0Lua+WEb7X/puU24xQAkkQJAec8gIsS5JNfxS/VO9ogq//LdiXHdsxQRyVGeZmFhGbqs9HxE51+9VaiBjrIcK0EI/VeD4jIYOCjZ7mhlCg6wCCNJup2NAp9H5B3k7YzGmbF8pQGTq1pLbU/XhewHkYT3vpuomPgNYEYuth5QLtYyYcPhdCqVqse3fjXeylyb/1bS6kKDtVNq7fSo/mfS41LsCVPGEX6KeA9+z+ZvkueUu1fSkOYLIfmZwSkT9Tjzl/MUdCKg47vFpzkQBGmcZY7Zy0AF2i0ohgIRweUYztlQlUKw0XNdpqB0p/Zx3UTBPVbaOXuioCkFW5Monl9b4cCGHow7Ck7TqVDKoHfStB6mgkzSBcCSs9DcFQ/0S21+/13owFHHZudEbVGI2980g4NCRzHHDT0+SmX2Pc2seE+Ncxlm2d0e1qAHcAG34yjXtk7QSqONNLPjaLZ8z7nxBpqRBtF4r+Qj53yPJYznfDaXrUDThXR8jTqKqaDUPAT72YEBlwHWpjBdJYmkO2tSfAzMyk0xZGbhL1YuEMBzSSPUDi3DoH41PJRnksu0dRL1SXab90orPSaRwT8ofSYIdIsenQnW6JG/TMf/mr4PM7M4a2M798c4CwjC8JS60OSPxDoigJjEsIA3EuNV70ZuqJNlyDymXrkdtGghqT4sibfB6XxGDq6OA5kZ7sFsno
 Y3trbCdK
 rkgyECQjN3YFEVW1uThrXmKuTKRp9GzXpgHlJBH9I/N4ymgK6SICGxVB0yDF+7cEB08baAcZ++m1MD3gXGXVa+n2Hkd+MwrrJSRdtmUlhIIz+yuXJA3+X4umdr8stQ5aOFqqCqgTzsD1DahpUsayGpIFsSZ5tQ2iT7TjtmRh5VDBXF5deNfxUXAfE9+eFkH4qJ4w90ScTfR1IBSIrV+QOFErmQ7kJfh9eQOaZh2Ok7684E7HqZRdOdclsY6qatCNxh6hLTQyL6gXH/w+D5Vn+gZ7P4RnJMwHNKc9saHD/k238XzTXqPTEMMhjohv8ChhwumciiecGLQ9Fbo2dieZftMnzmEuCORUu9zaSdFMFdqqtHDZTY2vILQAtlewH7SHda39l6es94jQ2B1Fzx2j9/nkxcQLDTEbXFmIKj3TlDqIy+K5c7tP83k+rgkPtJvINCJV82M4iuk5tGeGZrYwYelGGQaBI8bhMm7CGhKDVNLbDXdjRAmdETGYopsH2ZXlbjG3O3FllpL2pQ9vnktuLtnF5FUsO735QXTrqmf6E71VHOZV8u/Jq33x1Z8J40emUPpDuWYBKNzhi53WFvYQRf+oVNtMenHi2vBdDp0Z9IoGuDPKO+Ja68kzJKYOH06RFQa2K9ssN7ZAUGg4ZZWN5EAqc1jExI/CUQlYrEjNfhrHfA6z7ieflN6TQlVB+I2RhACD4ENlFki7VTlbwjIW8LD90L4KZtd7iFWES4K4L7FAT8u7g/ebDIy4Ig5UmpTuQ2rifsce2ljENWZ6kzrgPyDz72ghbi6FhNkk1Wfwq8dg9Sx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

History
=======

RFC v1: fmod_ret based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250429024139.34365-1-laoar.shao@gmail.com/

RFC v2: struct_ops based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250520060504.20251-1-laoar.shao@gmail.com/

RFC v4: Get THP order with interface get_suggested_order()
        https://lore.kernel.org/linux-mm/20250729091807.84310-1-laoar.shao@gmail.com/

v4->v9: Simplify the interface to:

        unsigned long
        bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
                                unsigned long orders);

        https://lore.kernel.org/linux-mm/20250930055826.9810-1-laoar.shao@gmail.com/

v9->RFC v10: Scope BPF-THP to individual processes


The Design
==========

Scoping BPF-THP to cgroup is rejected
-------------------------------------

As explained by Gutierrez:

1. It breaks the cgroup hierarchy when 2 siblings have different THP policies
2. Cgroup was designed for resource management not for grouping processes and
   tune those processes
3. We set a precedent for other people adding new flags to cgroup and
   potentially polluting cgroups. We may end up with cgroups having tens of
   different flags, making sysadmin's job more complex

The related links are:

  https://lore.kernel.org/linux-mm/1940d681-94a6-48fb-b889-cd8f0b91b330@huawei-partners.com/
  https://lore.kernel.org/linux-mm/20241030150851.GB706616@cmpxchg.org/

So we has to scope it to process.

Scoping BPF-THP to process
--------------------------

To eliminate potential conflicts among competing BPF-THP instances, we
enforce that each process is exclusively managed by a single BPF-THP. This
approach has received agreement from David. For context, see:

  https://lore.kernel.org/linux-mm/3577f7fd-429a-49c5-973b-38174a67be15@redhat.com/

When registering a BPF-THP, we specify the PID of a target task. The
BPF-THP is then installed in the task's `mm_struct`

  struct mm_struct {
      struct bpf_thp_ops __rcu *thp_thp;
  };

Inheritance Behavior:

- Existing child processes are unaffected
- Newly forked children inherit the BPF-THP from their parent
- The BPF-THP persists across execve() calls

A new linked list tracks all tasks managed by each BPF-THP instance:

- Newly managed tasks are added to the list
- Exiting tasks are automatically removed from the list
- During BPF-THP unregistration (e.g., when the BPF link is removed), all
  managed tasks have their bpf_thp pointer set to NULL
- BPF-THP instances can be dynamically updated, with all tracked tasks
  automatically migrating to the new version.

This design simplifies BPF-THP management in production environments by
providing clear lifecycle management and preventing conflicts between
multiple BPF-THP instances.

Any feedback is welcomed.

Future Work
===========

Introduce a global fallback mechanism to address shared resource management
limitations in process and cgroup-based methods:

  https://lore.kernel.org/linux-mm/YwNold0GMOappUxc@slm.duckdns.org/

Yafang Shao (9):
  mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
  mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
  mm: thp: add support for BPF based THP order selection
  mm: thp: decouple THP allocation between swap and page fault paths
  mm: thp: enable THP allocation exclusively through khugepaged
  bpf: mark mm->owner as __safe_rcu_or_null
  bpf: mark vma->vm_mm as __safe_trusted_or_null
  selftests/bpf: add a simple BPF based THP policy
  Documentation: add BPF-based THP policy management

 Documentation/admin-guide/mm/transhuge.rst    |  39 +++
 MAINTAINERS                                   |   3 +
 fs/exec.c                                     |   1 +
 fs/proc/task_mmu.c                            |   3 +-
 include/linux/huge_mm.h                       |  59 +++-
 include/linux/khugepaged.h                    |  10 +-
 include/linux/mm_types.h                      |  18 ++
 kernel/bpf/verifier.c                         |   8 +
 kernel/fork.c                                 |   1 +
 mm/Kconfig                                    |  22 ++
 mm/Makefile                                   |   1 +
 mm/huge_memory.c                              |   7 +-
 mm/huge_memory_bpf.c                          | 306 ++++++++++++++++++
 mm/khugepaged.c                               |  35 +-
 mm/madvise.c                                  |   7 +
 mm/memory.c                                   |  22 +-
 mm/mmap.c                                     |   1 +
 mm/shmem.c                                    |   2 +-
 mm/vma.c                                      |   6 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 245 ++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   8 +-
 .../selftests/bpf/progs/test_thp_adjust.c     |  23 ++
 23 files changed, 777 insertions(+), 53 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

-- 
2.47.3


