Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144D6C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3F38E0002; Tue, 29 Jul 2025 05:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A408E0001; Tue, 29 Jul 2025 05:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A00B8E0002; Tue, 29 Jul 2025 05:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39E698E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:18:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B16E2133F91
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:25 +0000 (UTC)
X-FDA: 83716751370.08.7ECCBEA
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id D1A321C0009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4bp+w7S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VUZOWenIjy5GkEEwkSpdq0uykANnDNd/BlY3skqN8K4=;
	b=y4MTRTvkvZIPjpZTpQh/ILm6TKDLOgm8yq1NfH8WEOb0HaYM/fS9LTMz2/DAgJy7ECXAJG
	AAgcX2ehs0PCUOiUJBBMRdObcp52wqDqGJbEG+1ft/qq4NTfrr0KIzOfzm5hd7Mi/OA2qd
	pGD37N0gAcGdCIfo+7c8CvPMQhZhhnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780703; a=rsa-sha256;
	cv=none;
	b=CcRkJitYsZgvb1ZnK+GFaX7DcDDSDdXv6y9M0mmzw3YldB5eiNf5QVcFgYpBIZZwVlBE55
	c6Ej0MpGsqcuP50YpcGP9lpknDNJPOrbcAY/SmSunew3Lo4WAhPcdWEQGhQoR11cRj3L0x
	xzIqcBDUM+Xjh4DOBNmPPMksnkdCPqU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4bp+w7S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-af51596da56so3792728a12.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780702; x=1754385502; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VUZOWenIjy5GkEEwkSpdq0uykANnDNd/BlY3skqN8K4=;
        b=H4bp+w7STWGui9oVHsZikVA9VDezLABiUVShpzvQ/0O7Cyj7Qeo4gJ/s4EJH5HKntZ
         QSvxTIljzRV5iSPIojuXaxlDDEnCrO2204wIcYy8+8JBDt8l9RWbrpw9k4YXnvqqzdC6
         n9Nhr39/f0kRn3aZ1ypE5+mmHNw+GhPWwX1ySkiboLwbFC8wxy1B+ApMyE3kXrfS2Ahk
         VfTK5VOeaMqZs0OL1tX01L9FlZLoca6J57brF4lvpc/cURWu/tNvI3nkwWHQjmdIrISr
         N6FGYZkYM4YhkckROVOXIoKL0LzngJHRkWN7ze13+7NCLNBv+EM8rzVhuFC66aUTg35k
         bS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780702; x=1754385502;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUZOWenIjy5GkEEwkSpdq0uykANnDNd/BlY3skqN8K4=;
        b=qdrAR8NezGVMF1nnGx+amBfNOBCLUC4PxwlIDaiMMXeaaYLkSNJzZPzLxPmSpRkqQ5
         VpURhWY2n0TBu/ObcUsr3F7MBu4JwsLgEjJt5EkYWt/PlknC72Darem8FOSmigbUcMF4
         2b2sTqBh+7AlzgWsvk7EmeZCUTcB6quu3p+BZweM3lsx4hQj7lYoIk6P8ByhhEae5xbQ
         tcfZ8VO5zSq8E76RN8qcw65w+fP04Di9LHGo40wybqJHEp0AHZPRpRTYWQDoEDKG6CiU
         262f0SgKFe+iOgqRgf3UJbvFWqTMhd1iapqYDjan7rFGUYwqzGUK/gQfrL6zTCHKAlna
         Jtiw==
X-Forwarded-Encrypted: i=1; AJvYcCWje8IAzeNGgM/mnOhRyYGLGvBlvpGCbpXEbsPx/Pio7w3pCgB9kS5sHZTpEAIw+pbEP7Vpf5bFLw==@kvack.org
X-Gm-Message-State: AOJu0Yx5HV4QnhKlARM1/z373dX/g3N7wAkelJAyScsVPqwl4OWOK7fx
	UqqvcaofWUSjXjrQDkzomF1V2nfBtWmI/2Is58j14SGKUohi+sK/tP5j
X-Gm-Gg: ASbGnctDjnWcI8BFU8wJNqfoNavXADq2jn6gjEf4SqSvwQN8LBeYkBWmk84i0KQ4nvk
	TnCoKFBCuaBrnvx9sz9bCAiQTVyv/cqBPsqdC5r3FbwwaJ9injIQfGAxVkTe59qXUyi4waM65pY
	baR9VeqBiCSkU2Bxg9gSXyugYAfa6LpX8iMRXdUtwMByNmbktH4e65iNPfx3sJIhwcwjQHJteQa
	CcleMeISD9INi27XGlBgsdcjYzSsw9Ktfvd2kKpybHQAbPPsFwz7xvgOAlxw9O2rGzyMd0sA9Ku
	UWbapza3j2FNLZ/tegJgPCF4mTD93TeszhqxEpZVT3tM+OLBUeZ5mXbDuvlDsbo6f0K/RkrsV2Y
	0Rc4Z6JyzHjNKsGbB+qLsnpOzXekcx1WYkxFnLnemQiE/cBk/
X-Google-Smtp-Source: AGHT+IHJP0Qz12f6zlitK4mLom0lbwKGaBLhvAfihe5cCg9wPlHM/Mw8pPhsa6MVIoqAAMdRnepRMA==
X-Received: by 2002:a17:903:1a8c:b0:234:8e78:ce8a with SMTP id d9443c01a7336-23fb31c104bmr224767505ad.48.1753780702498;
        Tue, 29 Jul 2025 02:18:22 -0700 (PDT)
Received: from localhost.localdomain ([101.82.174.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30be01sm74337015ad.39.2025.07.29.02.18.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 02:18:21 -0700 (PDT)
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
	ameryhung@gmail.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v4 0/4] mm, bpf: BPF based THP order selection 
Date: Tue, 29 Jul 2025 17:18:03 +0800
Message-Id: <20250729091807.84310-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1A321C0009
X-Stat-Signature: wbynzhcjgi1cesujkuo1wdbk8j4dznk9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753780703-500066
X-HE-Meta: U2FsdGVkX1+6L/E6PwLRfGiMkapsGFk6zaHE7JrXolmXQo5QBzejd9hEgrIPGcx2RJK2Cp80pS2TK+tQOofb0+P3hEH0CjGh7OH6Nko8TI+9IeQ1bBu6HBGGjID11pEFickZXAl+tsG94i+9mdl8Ic149gXOYzKJGfZESl1PAwCK2us1kC1cCL3TMSSMV/e7gzHQH19yOcoaic4q0BNC7vM+AVBC8r4ja7sj6FmXypBzyx7fiYS56EcJXwJaot1D+OXbvYDb/vm4P4hDRpCTyzfReUJC9MOZ23kTCKGYS0d7aIFShQw0PAKnGx85BRsc1Woi7ir8H4tyohBhzU+iGIjir9iRK3TCTRv3dTUmTbjfwsEO+aVnUQb8i4hBga97k/DNXZCq02XqcBH0RY2M0tunWppHWfGoIrLf+sJvERj3gEcdLEpnB/jRQe42ceblSUkiGVE6hjrt4DOXnzsmgL6DOhMO3MLrQj4tNfU3m0pBNMNLqSaNqBxaxUR+WQqWPI369l0rVUR2krXE4606i6xNgyf/UQwSPsSwMpSgwvmS19u9NQXts0Uwi4QVyZHNO7diuYgiFqvuxI6rbyVO/YfQaVmFmMPilbuvAKCoF9Ua01exLCHaRlWxY83JmArhLCpE8/z47vrxLuY1u6xQMnLRRFl9oofRFTjDuxxpP/6q/VVZVO6dF5VOeTGy6OhsPPbrB6aqJYfSHIMSc+oMrBjlHyQFiqAHiu18GagEyI8IKXCbDlcGqBRZO3uPwN6DVDDcVsX3CpAssV8LsEk9JdYTZuuIpx7vrPBRqsNknOjK+LjK39gqD8Lr5C9QGtjoKUNtT9/7Mborm1v7HwSWwNwOJWr3yXEIOcKqqx/Bvo0mtoSFPMp3M6grB80YBhJRLKOxBsj0Y5xNz8FSUqZP5bWIT3vUkG+G7f630jMu5Q4UMBdiTJ+jg5CRlzHPeYbEW05pGfO0F31tQBt+NJS
 nHm2wdFi
 07Wr+CCK2PSaQGHGre7i8yZUsBrJie3sWUTcbKvmTtRvLmaUrqy8ukPjW+vOXUCU89pW2oNBMmhMCLDBb2j+Xhr3uWx/h+kaOLMVeQgY7+F7OMk5kaYr616wR7ASjitmn2yT8Sx/8Sbw5eyeP1csAyX9w871aPOh4EDh4I0innYmvRe8MLdhlAxIINlMZXEFgfwj9o2jf16A0j6vE/Q/j6r0SUgh/idZwDZiV3JF5SUDvfITm69MODsZKrlWYH5M14dvBx/8qPA72B92f2H1BeYO2vU6B76QYDTS+Z7u0kypSD3+cZJ/Tc02/Ux6jbC4u8oW14RpNKiDwNLO61HPIrToGihAu3uCJeNrBOdw9tqwXHLqdZg6MwRdXyfobFKDKSBIgVi89S0qrJzwQ3IfDRhPqNSCVRRbvXGEn5EvR+9rcJ4sE/lZSIhuWOsL8qE/9bCDvepDQTDntm524IkiWIphwPzJ1FobSV6HXguajPF5D1wI1lOP/krEdhb3Q1muC+638R+oMb7wyiS53SM3dMrSRHSRLciWMK4XJzL1EHCN88cGJCmhNjy0di68GNOxGlC4eaZo5yob9vrjhYLj6YYLuOQ==
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
 * @get_suggested_order: Get the suggested highest THP order for allocation
 * @mm: mm_struct associated with the THP allocation
 * @tva_flags: TVA flags for current context
 *             %TVA_IN_PF: Set when in page fault context
 *             Other flags: Reserved for future use
 * @order: The highest order being considered for this THP allocation.
 *         %PUD_ORDER for PUD-mapped allocations
 *         %PMD_ORDER for PMD-mapped allocations
 *         %PMD_ORDER - 1 for mTHP allocations
 *
 * Rerurn: Suggested highest THP order to use for allocation. The returned
 * order will never exceed the input @order value.
 */
int (*get_suggested_order)(struct mm_struct *mm, unsigned long tva_flags, int order);

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

Changes:
RFC v3->v4:
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

Yafang Shao (4):
  mm: thp: add support for BPF based THP order selection
  mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
  mm: thp: add a new kfunc bpf_mm_get_task()
  selftest/bpf: add selftest for BPF based THP order seletection

 include/linux/huge_mm.h                       |  13 +
 include/linux/khugepaged.h                    |  12 +-
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   1 +
 mm/bpf_thp.c                                  | 255 ++++++++++++++++++
 mm/huge_memory.c                              |   9 +
 mm/khugepaged.c                               |  18 +-
 mm/memory.c                                   |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 183 +++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  69 +++++
 .../bpf/progs/test_thp_adjust_failure.c       |  24 ++
 12 files changed, 605 insertions(+), 7 deletions(-)
 create mode 100644 mm/bpf_thp.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_failure.c

-- 
2.43.5


