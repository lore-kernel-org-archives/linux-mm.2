Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DD2C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F876B008C; Tue, 15 Sep 2026 08:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0106B0092; Tue, 15 Sep 2026 08:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE426B0093; Tue, 15 Sep 2026 08:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B36C16B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:30:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43E8A1403FB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:12 +0000 (UTC)
X-FDA: 85215929064.26.2AD384A
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6FA5C000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UkX0doXq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789475410;
	b=iS4xKn7955dsjn+7Rt7xMu7beuKR6GnV86hqknvHDoIEswqiHlTuqtJd9NJ6oqYIXONWN8
	Q4+M+eEedfaUWdHUSKJYapE36k1FCEn4yOuMFXnwD4m7yfidM5DSxCUgBvv5YIXlQyiIjd
	7ha0pFAReBVCAh2C+2JU40vU+eUG8g0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UkX0doXq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789475410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U3Bl0wTNOFUnLlIlJC/nxgjcUQgVhW41sff5i3Mg7kg=;
	b=gduoyk+hU03JB4Q+TW2YXZ1B6L6YyUPsHOLXqbOtmExbMU8VdKK+TJDlT6Suwye7GWpJj2
	qsMD9nS/DpxacXPr4wH8/mKYGgtsazs3jPBIVaIhxqbVR0NwSD4PpPhj4ZSBuXN/8bCRyu
	zzqwww/HAKQ6GeQQfP8X6gfhtB1Wydo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nJ8Tf3/omubO5lmb4Qg6Pf8rR5Fq4Yd4BwGCvB4CKvo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475407; v=1; x=1790080207;
 b=UkX0doXq00/eVcQ7S7gJCMJ64BNdbiXzzf91ROlbt9xDkV73Fh+hwLr57D5tTkwbXuvDOyQt
 EhiWMhDX/TQzM4H2l84ezOOqt07XOfVvf2bjh5e9Rif7RmN6dHUhOXBiOebzRtdk/yfyTlj4JRh
 ctuYx5UGqKncU7MhGVzUTxsw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4aa4d6d5ceb44ce6;
	Tue, 15 Sep 2026 12:29:57 +0000
X-Mizu-Trace-ID: 4aa4d6d5ceb44ce6
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v11 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Tue, 15 Sep 2026 20:29:34 +0800
Message-ID: <cover.1789475073.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6FA5C000D
X-Stat-Signature: s9k4j9owfgwx9jmq9dp6g9n6d46757g9
X-HE-Tag: 1789475408-171007
X-HE-Meta: U2FsdGVkX1/laLYKnxxbLvsiWTVHeQr9xI5/kpomNMXVTq/h/xJQzWtWwccRKIfL0D8YTuYC4JEgXGhpMOV6xzP7GLdjIeHV3YsruHx3bpoLHQCK0MVr05QZkl00lNmLQms2DHUIQ8cqO3yS9tyugOh7a/a3BqrSqgbSzAhDgQhXiPLnJ75WYLfeM5cumuRWStZMbkAszBKI9AqB2ASnj8ztmbcgbBjWtWVrrmkZ1dfoc3gom0Xdu0bmDem79Lu364lb6PY+smaSdJCl66YhpCZ1WHVDS/R54any0iC9fWHCJh5NY0qY0J9WRwl69bVzv4x1P6pL4PWVx3gapYwxmUr7XV6I/gANBV2MdnkqoPm52G70St5G9X9Tl9/B7/H8uFZGGj42EVCb/ZLYA6v/qDsIk4OpG+sF5+ioaPN4ZrdecC1ISXFz+DEeDHgPZ4YIi2AMz3KQgAjYF0p7vWSw1e1cJZh4iUkiWeI1BeZ94Qibj3cLopWE1xMaEea95vAfOKNWoBh4qe9LG5cKrxKL3HPU5/YCX2snORRAv7qUrHi6nov9HRKfamJ6ZDvTrn8nu9pbXLX4AOffbHmWB/AcDE9NTBEwgnvRSi9xjhdFfuyuhq9lhePyDhYkh7AnjiIHDpD19pON/LBCfvYPpEUrPmIe/RCqwwZHg9PaAJ2hZhxZsP1R0hH2hXXhVapEr0383cHHGwDZVZur3kKsTHtCWbFunUvucsjD5/sU1BE/CQFM1T3zlGVpjz4GPZQNDdDWdkLK/3aKuanSpg2NfY7vBhM491WDUjFItwwOEhuC/DCljT430e0J54FBVtUW16UbqUe0lzjL+MEzKTkodevsDZRu5gt3XZpl+g+QyWpGX+vPa90cU2ejI+p1TChxEZLQLPS0zkqDOdlhKsXabHpfz4DigDIR0XuFMQFD5eqLumJySChyFfwx2Uw53NubX3IWXiZMFHG4dnLuz6EyjSE
 jsXb+uCn
 EA9YncTb0d8abI3BOlZt5Df/PbeEHNdEx/1ayxJcEcWis/tl3y5GknaESY7x+YZRjs3BdfDBk158rbxsOL5N6eAvey7hDxXcq1mINgR7EOvMpJwwz3AKWAIOrn6TdNib/7hmnOtpaJQUQcnfBRsedO0U6vS0KMpur/+VOul6REtsHmKUnesjFCt3lNxOpzINTbZME
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup (e.g. refault
stats via bpf_mem_cgroup_page_state()), but cannot act on it:
triggering reclaim on a chosen cgroup requires writing to
memory.reclaim, which BPF cannot do. This series adds
bpf_proactive_reclaim(), a sleepable kfunc performing one proactive
reclaim pass on a target memcg, so when and how hard to reclaim is
BPF policy rather than hard-coded thresholds.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context: generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. The
bpf_wq and task_work callbacks of a SYSCALL program keep its program
type and run in process context, so reclaim work can still be queued
asynchronously through them, as the selftest does with bpf_wq.

The use case we are looking at is protecting high-priority workloads:
a BPF program monitors the state of a high-priority cgroup and, when
it degrades (e.g. PSI rises or refaults increase, as in the
selftest), asynchronously reclaims memory from low-priority cgroups
via bpf_wq and bpf_proactive_reclaim(), giving the pressured cgroup
more free pages.

Another use case: several vendor-maintained kernels carry private
implementations that trigger asynchronous reclaim when a memcg enters
a certain state. These exist for historical and partly psychological
reasons, but the underlying demand is real. We expect BPF-driven
proactive reclaim, combined with the BPF hooks for the memory
controller currently under discussion and development, to serve these
needs in mainline, reducing kernel fragmentation and improving kernel
maintainability.

Benchmark numbers from the selftest (TEST_MEMCG_ASYNC_RECLAIM_BENCH=1
runs the workload once without the BPF program and once with it; QEMU
VM with 8 GiB RAM and 10 vCPUs, 10 runs): the pressured workload
finishes in a median of 2.1s with BPF-driven async reclaim versus
12.0s without, a 51%-90% improvement per run. The harvested workload
shares the parent's memory.max with it and finishes in a median of
5.1s versus 9.7s, as it has the limit to itself once the pressured
workload finishes early.

Raw benchmark output of the 10 runs (one line per run, all passed):
memcg_async_reclaim: baseline high=4.081880 low=8.951780, reclaim high=2.000056 low=10.872397, high speedup=51.0%
memcg_async_reclaim: baseline high=15.803050 low=14.594268, reclaim high=1.567874 low=4.848877, high speedup=90.1%
memcg_async_reclaim: baseline high=5.222607 low=4.076494, reclaim high=2.188346 low=3.922446, high speedup=58.1%
memcg_async_reclaim: baseline high=11.556587 low=3.222517, reclaim high=2.325903 low=5.303031, high speedup=79.9%
memcg_async_reclaim: baseline high=14.481044 low=10.517298, reclaim high=2.309609 low=7.884620, high speedup=84.1%
memcg_async_reclaim: baseline high=9.737340 low=2.876915, reclaim high=1.815853 low=9.379357, high speedup=81.4%
memcg_async_reclaim: baseline high=16.290141 low=17.152739, reclaim high=1.649337 low=4.978743, high speedup=89.9%
memcg_async_reclaim: baseline high=5.176590 low=4.858071, reclaim high=2.356344 low=5.971522, high speedup=54.5%
memcg_async_reclaim: baseline high=12.444925 low=13.305078, reclaim high=1.973012 low=4.261413, high speedup=84.1%
memcg_async_reclaim: baseline high=16.213717 low=12.608334, reclaim high=2.207762 low=4.317123, high speedup=86.4%

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  61 +-
 mm/internal.h                                 |  10 +-
 .../bpf/prog_tests/memcg_async_reclaim.c      | 779 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 289 +++++++
 4 files changed, 1134 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.43.0


