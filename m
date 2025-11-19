Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A98CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5736B0099; Tue, 18 Nov 2025 20:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086A36B009D; Tue, 18 Nov 2025 20:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE296B009E; Tue, 18 Nov 2025 20:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7A356B0099
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:34:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D41AC0256
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:34:54 +0000 (UTC)
X-FDA: 84125637708.02.D495452
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7415120005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:34:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wcb6zxRs;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763516093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e2EGDBgBbdB4DgQO2TbLGho5UNAFXwK5TbGKkRJZcyU=;
	b=zjX0SSGYruuCMDENXaz4DsfbEg0iUi2CIoyoabsx7W3xxKkdiP9K7J/u2FCNc0f2a6dz3k
	BlOJUDPh63bzHwBQ0RF/uuhjn01LCZbrJPaKhInxeyggdG0He/Thhifw672fdJUPfZebJT
	GY7fSKodL7nMvJdFPG4g9tNhnZtHaLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763516093; a=rsa-sha256;
	cv=none;
	b=YVjnaEAJKCLUKpo6wzc00O2SMd1pYAMWt6JQ9YKYJCDfWQIHfqw86a75ou4g67szaf4Mmt
	FGoYIPTGY8KNfK0nJtQt/w13L480IZn63vydO97c5HSYdtqNeg+ZYBVUy685u6oc3ndM7l
	xOdSTQK9JGkf4cGucatl8Tjdl2eXJHQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wcb6zxRs;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763516090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e2EGDBgBbdB4DgQO2TbLGho5UNAFXwK5TbGKkRJZcyU=;
	b=wcb6zxRs7rat5F88XagPhY4x0Gw6BsMRBqudFzDvtr+kZdAQ0HdzJZFIb28U+8FqJ1g6fk
	PCpOQ+BrIEmrHEjQWL0JuK73P4sDppwutql3YXl4jyMJ4V/mBADmnshAVBNvNgRBojSew9
	Tt1POrat12cH3TSDmK+a4CnxIQdAPgU=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH 0/3] Memory Controller eBPF support
Date: Wed, 19 Nov 2025 09:34:05 +0800
Message-ID: <cover.1763457705.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wb1z9wf49jwax5479kkr131d9k6fsy7u
X-Rspam-User: 
X-Rspamd-Queue-Id: C7415120005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763516092-355079
X-HE-Meta: U2FsdGVkX18NU/FUVrK7nN2ov4ahEN5fn4e/oJAo6gHc1S5Je6+YfBPsm527nVqI/CYXNf+QvKBbmZchf8VfQtTBX1Q70uyO5zw/T54SiishDsMpM8J3xSA4QtblyN5e5y2G5tNqo+VKEBZaDS/PAmUo50KP3Tm4ccdV77FS1s+gj35yp5SikN5+63wSAQvj3Rr9+RRgr1FPepR+Nm0H7E1Q8lDFWvvsFMC/Mo4aRBO+/vQOIUXvl1WGTp489p375JKhf3GK4jSrk16z2LdSOgo1if3Ga5+1Y3Zt+sqO6r8jrsgegqc7pjXBPJm+GqNo8cMDsVi0JRQnVRBHmZQH9JAcIniFFUzhKPavTChZTMIOP4daTuOVgIQKYJ23YMkWm3kfPsbzrTafGafmNY8ehg6kS2z+otWr2Wjlt7914CAPk19mgvLO+BtlWRG5RlECCTx1uiceP4upI+pIeVud31l5774A7DlA7h5wL/cAmHlmPjd3tEh839oQ0OwP5LyOPu7ujnnN2EHpz3DZg/MjVCzCYRgkSnqgxt/lTYfOgpMh6wZdvT8PrdYXqK46+zIkA/glDj+qD0/yUB77MhNVxMLL9RWOX16FRygnPf9WE/YMbcm80iDCd/V/TdCkJv2arGI/jprdTBDr3p719xLnJkMSjMTHCrrwVkVfCrauTKI/FiSIaAagB8VtFymwBH+MjGbLp3vgLyndyjn0ZMqsaT7Zyj66Y4JWU0gCwM2Gw3p64Y6VeO4O3uTaL50oE99Bs/Ioovl2MR6aPIpoyNORwOWS7q7Usl1Ro9FWCeQO8QfHJuUbw/eThGMH4KLX9RcgDOOMfjgfMPk3TjCywIXJCa63JXnv1OEDE6zV9Bg1jvz2KTb53UTdBNQy3GTgy56MuuZlzW7MS83JfvSGbSS/AhFWGmwJgAOPMY4DHE6RGEXTup6nVqfhSim4cnTTomutx7fIJRq/haioVKtXh9H
 a5oNAdgN
 jlQAF6cVmo49Wkmbc68jd/Nuz0jVkS8hRo5VXN01udnKZyq/wyy2IlZS9PTi24ME5fs5Jpzu4alIIzA6BydPJ3R3/3CiPIpC3FlvGSA0DEKQgPHEdJjWh2FpiiSUl85L0qDxaUENqWms0PdfILzdTc+vBMSKJ9sojPK76FDXBUuPKm7alUSzw2zuMzDUfJwVpHbs+r5ampLCPgKcuGbCK73XzLG9rtGNroKRg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series proposes adding eBPF support to the Linux memory
controller, enabling dynamic and extensible memory management
policies at runtime.

Background

The memory controller (memcg) currently provides fixed memory
accounting and reclamation policies through static kernel code.
This limits flexibility for specialized workloads and use cases
that require custom memory management strategies.

By enabling eBPF programs to hook into key memory control
operations, administrators can implement custom policies without
recompiling the kernel, while maintaining the safety guarantees
provided by the BPF verifier.

Use Cases

1. Custom memory reclamation strategies for specialized workloads
2. Dynamic memory pressure monitoring and telemetry
3. Memory accounting adjustments based on runtime conditions
4. Integration with container orchestration systems for
   intelligent resource management
5. Research and experimentation with novel memory management
   algorithms

Design Overview

This series introduces:

1. A new BPF struct ops type (`memcg_ops`) that allows eBPF
   programs to implement custom behavior for memory charging
   operations.

2. A hook point in the `try_charge_memcg()` fast path that
   invokes registered eBPF programs to determine if custom
   memory management should be applied.

3. The eBPF handler can inspect memory cgroup context and
   optionally modify certain parameters (e.g., `nr_pages` for
   reclamation size).

4. A reference counting mechanism using `percpu_ref` to safely
   manage the lifecycle of registered eBPF struct ops instances.

5. Configuration via `CONFIG_MEMCG_BPF` to allow disabling this
   feature at build time.

Implementation Details

- Uses BPF struct ops for a cleaner integration model
- Leverages static branch keys for minimal overhead when feature
  is unused
- RCU synchronization ensures safe replacement of handlers
- Sample eBPF program demonstrates monitoring capabilities
- Comprehensive selftest suite validates core functionality

Performance Considerations

- Zero overhead when feature is disabled or no eBPF program is
  loaded (static branch is disabled)
- Minimal overhead when enabled: one indirect function call per
  charge attempt
- eBPF programs run under the restrictions of the BPF verifier

Patch Overview

PATCH 1/3: Core kernel implementation
  - Adds eBPF struct ops support to memcg
  - Introduces CONFIG_MEMCG_BPF option
  - Implements safe registration/unregistration mechanism

PATCH 2/3: Selftest suite
  - prog_tests/memcg_ops.c: Test entry points
  - progs/memcg_ops.bpf.c: Test eBPF program
  - Validates load, attach, and single-handler constraints

PATCH 3/3: Sample userspace program
  - samples/bpf/memcg_printk.bpf.c: Monitoring eBPF program
  - samples/bpf/memcg_printk.c: Userspace loader
  - Demonstrates real-world usage and debugging capabilities

Open Questions & Discussion Points

1. Should the eBPF handler have access to additional memory
   cgroup state? Current design exposes minimal context to
   reduce attack surface.

2. Are there other memory control operations that would benefit
   from eBPF extensibility (e.g., uncharge, reclaim)?

3. Should there be permission checks or restrictions on who can
   load memcg eBPF programs? Currently inherits BPF's
   CAP_PERFMON/CAP_SYS_ADMIN requirements.

4. How should we handle multiple eBPF programs trying to
   register? Current implementation allows only one active
   handler.

5. Is the current exposed context in `try_charge_memcg` struct
   sufficient, or should additional fields be added?

Testing

The selftests provide comprehensive coverage of the core
functionality. The sample program can be used for manual
testing and as a reference for implementing additional
monitoring tools.

Hui Zhu (3):
  memcg: add eBPF struct ops support for memory charging
  selftests/bpf: add memcg eBPF struct ops test
  samples/bpf: add example memcg eBPF program

 MAINTAINERS                                   |   5 +
 init/Kconfig                                  |  38 ++++
 mm/Makefile                                   |   1 +
 mm/memcontrol.c                               |  26 ++-
 mm/memcontrol_bpf.c                           | 200 ++++++++++++++++++
 mm/memcontrol_bpf.h                           | 103 +++++++++
 samples/bpf/Makefile                          |   2 +
 samples/bpf/memcg_printk.bpf.c                |  30 +++
 samples/bpf/memcg_printk.c                    |  82 +++++++
 .../selftests/bpf/prog_tests/memcg_ops.c      | 117 ++++++++++
 tools/testing/selftests/bpf/progs/memcg_ops.c |  20 ++
 11 files changed, 617 insertions(+), 7 deletions(-)
 create mode 100644 mm/memcontrol_bpf.c
 create mode 100644 mm/memcontrol_bpf.h
 create mode 100644 samples/bpf/memcg_printk.bpf.c
 create mode 100644 samples/bpf/memcg_printk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops.c

-- 
2.43.0


