Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178B0C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0781F6B008C; Thu, 27 Aug 2026 06:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029216B0092; Thu, 27 Aug 2026 06:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81316B0095; Thu, 27 Aug 2026 06:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDE856B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:37:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C743A039E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:37:01 +0000 (UTC)
X-FDA: 85146696642.24.33559E1
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43A0A180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:36:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yhx70kXZ;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787827019;
	b=xj2YtFE/O2VwR/o5ox74VQdlJfGfQeQZYnjrhgLXMxjpwZ82MJRr6ctTa5+Q/mChircVz8
	hyVAHvcQVjQaEgHASm4HF0kcTLtaIDFQ3gOJ4qvqfr4aMW5F7V1viUOk5/3GUuTsgQGMNa
	FGWzCtmZw1ybT4uvPm/eC1sJFBygzMQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yhx70kXZ;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787827019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jHGVD6qiChS6X6PURZaX6Pf/jaFbsxWD4ova1jwVOf8=;
	b=rgTCD12eLollZH5Q8LQ2sucfzhOeGsWhb8C71elvuqHqEj1X6rZ3akt0G96lPVuLxs8TfZ
	P64Pt/HvJk1Ft9wRbRGOADb08ZKgT2RrmMB9drKWTKVIhidGF28+vI9WaQIeJK/QqMtrFp
	aHvOwrTA+UzREAi/1fWjRXNytEqZdOE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eBC1hmrN/najiAXcokA+qH1/b3vDj9vs9vwMDANb+no=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787827017; v=1; x=1788431817;
 b=Yhx70kXZKYKAQ5vO0KaAwPPEUUGrf3DtASy7UyRuwX50dLrkafn0tHR0sSOeBm7O2KsvfY3p
 vV6mjy61F+drdbWMfNOxln7QZp6hhFRY4t56gPcc+moB31HVJMNql0NQQfyGha0NMD9LJWS6nJA
 ggcEpT2iWzXgmnl6jTTQISJw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1d9f78061294dc88;
	Thu, 27 Aug 2026 10:36:57 +0000
X-Mizu-Trace-ID: 1d9f78061294dc88
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH bpf-next v5 0/2] bpf: BPF-driven proactive memcg reclaim
Date: Thu, 27 Aug 2026 18:36:28 +0800
Message-ID: <cover.1787826402.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jxnbjcw4a3ufj6p9c1u6yh6w76xy5z4c
X-Rspamd-Queue-Id: 43A0A180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1787827019-78126
X-HE-Meta: U2FsdGVkX1/kcNteDLvqpfaaTI1oiALlH4mRUbRY6vrPCIIDBYv3Qt8p/Hy0GjJSGpE4oSTmLn3ieE8Uq7oPUOV1+S/lEijxtyjMeZP3Uyk9BHhQlXCDD3dazR9FsVMi13bD0XKk/pQTvkJInRR/mgGI0wmJAbbj5sr5QrDxX57CGZmoBSsYEVr1m9WTBXa5by3SXdqSQE5P7Vk2OG2IM2Rmiy53LxXF9fyqH1eoEqp+b19MlWAxwYkVPZnBIk/qk/ricl8boiZOy6uvNdTssQUYXoaxPfzeWwdXeTQ8zJ5vMtCjtdTYLQBj00zRMN6RPTrfIB+wkReMTwTtqHK/GPi/s+lhYCMQKAT+dsHwKGr+bmLqloSrunZn+jE1VwrPWd1kHeaduQtpbQFHBJgV067Pa/R4PkJXjU14UlSJcjMsQxAeRij2+8eU7XE/8X//hwVioHYOwPCY5ItaWXXnky1sEl0EkyV7Bt2nc2lHkC/uS+k9WviTd7e4dtKO876zjZo+6RdiQJDuaeZEBvSlnDaGfRcg49kcCawvjNOOP0y/VL40Zu7X9B15nad38CkIA6bmON1o1ghL6luSlyvQyk0Mu3M54toGgCrcTq4USqjG0kn2qEXkdmRJSthxcQjFDS8FrPKalI9upRDcBIt/6LUHBZrBTQAVZnsxSo43d1ipwKj0eom2SzgUQ+VJ7wB+wJMa2BKUHn8zbl8MjLw3t9rafTivSjWtyL3tmqiQG/dhyiQ6oqJF/WQD85RrSQt4EiL/EwxcKl31JJYUxXD40Qzf0rWJqb5L1nikblVHwlZwnAFkVi5+m0CvFCWaThaMnkOSbVppCaP+xV2lWpf0IYGR0II23KIVIp6tvp7xHHoHXv2dDxhGnO2qrinaxH+OnQm87lyZkq0abQf3UmQWWX5kNkOrbU9Irm8AuUMjA55TjNwZNTQ22fkZ/grpVj9Pj2MyxsQD3JaJF6NFnf/
 CK+1l7HY
 C+rHFYWchSaeZGZ21PRzVjZ9LfyvJLtLPQ1/2Krfs9HCHQ4jNEPeaLDu/Qdd8A03zddXvcpB96GM78D2LWYHdbKbkhBetEpF2VANRUNUjQx+FMxejvaUKQBmh+21tlofR++giBxFRTcBj+yhL+TUxrA3gEER4HYXymII1U1qIXwNGuLikR0lcNOuw6W0qUMJ+pqnK
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

Hui Zhu (2):
  mm/bpf: Add bpf_proactive_reclaim kfunc
  selftests/bpf: Add memcg async reclaim test

 mm/bpf_memcontrol.c                           |  46 ++
 .../bpf/prog_tests/memcg_async_reclaim.c      | 480 ++++++++++++++++++
 .../selftests/bpf/progs/memcg_async_reclaim.c | 181 +++++++
 3 files changed, 707 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_async_reclaim.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_async_reclaim.c

-- 
2.53.0


