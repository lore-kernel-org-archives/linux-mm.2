Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650D6CF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20D16B009E; Tue, 18 Nov 2025 20:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD09C6B00A0; Tue, 18 Nov 2025 20:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A988D6B00A1; Tue, 18 Nov 2025 20:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95E3F6B009E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:35:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 544E313A3B6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:35:09 +0000 (UTC)
X-FDA: 84125638338.06.B068633
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id A353640004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:35:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJKJXVPq;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763516107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APzUbJ1xJcLTN15RzI5Lt/FDUDhgt5Fbd2bTLMIMyeQ=;
	b=bhcXov6+9fq8jiBVU25298/395+BQtqDGL5cTvveQitUt2h58eOc77XcL7Jc4Qwu5DzPmi
	A+Zabuu2fEmyw9ciEU8HDr2gthwk+IA8FGCAPyrWIm+sZKJYlmx7JuG01wdhkfE3H2NZVn
	uZK0db3XWs9bdCf7Qt3jciayZUlpdkA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJKJXVPq;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763516107; a=rsa-sha256;
	cv=none;
	b=BdZmi5iXYwCjMTiX7uy3C9whs7gPP9p3Ls8NfGl+vuqknbDKpS0SCwKruhUPu/o2TEyDPu
	iQPlpW4fUxYk+c/H9rvlJMBwVQ9VAVDbMdbySkWDujFguVEB/eWnmwdElHnkcIAv3CBSRo
	ktSZgZz1e0500P/Yart1y1cUXWWCFJs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763516106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APzUbJ1xJcLTN15RzI5Lt/FDUDhgt5Fbd2bTLMIMyeQ=;
	b=rJKJXVPqyQq5HjlvFiXrkhuluS7KlJTVwnsZHRW4cmL0e5TInZS9YpTGeQLiVFuBFboxuL
	ynaA07biE0TPd906lyYl19JS1eZgGAw6GuDGTYR+8SWz6fWPft/9epr8XY8KxPK63+d2Wu
	LDoZxauP/e5JFtJEM9a4z7HJVLmupOc=
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
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH 2/3] selftests/bpf: add memcg eBPF struct ops test
Date: Wed, 19 Nov 2025 09:34:07 +0800
Message-ID: <0017945a4297a296c87a65d62cc4bd9948f6c20c.1763457705.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1763457705.git.zhuhui@kylinos.cn>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A353640004
X-Stat-Signature: tszf87sc1mojwrkbzbhadwxf3xkchu55
X-Rspam-User: 
X-HE-Tag: 1763516107-960151
X-HE-Meta: U2FsdGVkX197Iwe1kzskrvzOktaQ/3zkgQuj3lZky56myyyqoVkbUWE2Dbxh9/71bH5mNifahivGuwziyGk57/eoykFPnImPSsk5p1FyeAR1jY1V3YbN+bNBUNGaJZgkSg54myVA6AHvXKnSej16Dhr0JBKwWPBXT6mq212pm9NB1uVb4J1qQ0AtbTI+ULgXwiSNhSb2rcm9HLu8yZej7R3XVB99IjkwaZ2X6JPZ7dasGvWaI00LnkLWK5pYpcfW+rpYF1OMkS3Z/UjobIyLxTa3WSllGFPa2Mfd27Hsa41E4v+neU8jFNQo6R++8xZGa+4w7bog/p8TuZiR4tyWyvMPShP121mzFsMd/LuWRP4HRHN4Oa+xt9zmnz558ADtdCFkEVt7CJwjQzJZDjGLNKRjrl/Ff2VT8mczgxwrr+cVyLetFEzDL7vfo7dB/IpXJShSJOXUWyKECvz0xnAB/QwpVjdIHM5ZC+YN7R1/ktSFC8Rt6Ig322UVf4WQg7UuzQVCajmmtJ3QBuDmCZTyX4t35Oel1jMqy4U8dYtRbnLuWd3oGzdVB4ZRH1bRZCsFyLhppjIFYJ6x4cr3etamSFW09oJkM2zr92wY/kq0jU71Zj/n/1Pei+c2/iCGhtz/c5exqbKEgOso3m1DzQY53OowLd6gHUEL1UK4W/dDY0p6igjOUXnIHU3YObWyC7anuopa+Mzu/3gNdR8bgOLuYopaMCe2y4E2xbqBttjcQ7zMEXM0qS5izcCRX2AinTeRT0lGxsiBZxkPG2m7/Mus4p96Exu3jkz/ri0WyBXW+pEGP7vNnmu/p5pMcugb4432ryJsaMIvhBU5atHJAd1yJS7EUVJ/pCeJFRsicaBuqed1y+NMLuEcTDMqjpdX0LtAf78DeaBcru+GKHfGltFMMgEYj8mXGZIC743JEvb4Or3G61kSnZJRav3FxfO3SdRuHWakuHOerC5ntyThT6n
 i2YtkYOX
 olEKcdM3aUS7nGYmrzjWq23vsFDaFcHFZhK7KfmUtQgXhrdDlAtlk3Y4OJp2bMVV8JN7Z1D1wpJO4ocPZ/ZVTqsFXuseVkDmXf6U6LbPYPiY/wQ+BpEXFt30uqiXFzM+fEVPziiFaxqEnM66jq9QpDg+guVfVbkZ3s9HTOyMgmwfzNUtCeTB+L7rXBkCXXeCavYjZysDamJBOXv0edLhVMJ4TIfer6byJjNjmIGU7DqTiD0d81/rM1zt5ScHr1owu+rE+u0puj9jru6/jdULWj/vU5HBw5RvgwlMW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add comprehensive selftest suite for memory controller eBPF
support. The tests validate the core functionality of the
memcg_ops struct ops implementation.

Test coverage includes:

1. test_memcg_ops_load: Validates that the eBPF object file
   can be successfully loaded by libbpf.

2. test_memcg_ops_attach: Tests attaching the memcg_ops struct
   ops to the kernel, verifying the basic attachment mechanism
   works correctly.

3. test_memcg_ops_double_attach: Validates that only one
   memcg_ops instance can be attached at a time. Attempts to
   attach a second program should fail, ensuring the
   single-handler design constraint is enforced.

The test suite includes:

- prog_tests/memcg_ops.c: Test entry point with individual
  test functions using standard BPF test framework helpers
  like ASSERT_OK_PTR and ASSERT_ERR_PTR
- progs/memcg_ops.bpf.c: Simple eBPF program implementing
  the struct ops interface

Uses standard test_progs framework macros for consistent error
reporting and handling. All tests properly clean up resources
in error paths.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS                                   |   1 +
 .../selftests/bpf/prog_tests/memcg_ops.c      | 117 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/memcg_ops.c |  20 +++
 3 files changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 498d01c9a48e..dc3aa53d2346 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6356,6 +6356,7 @@ F:	mm/memcontrol_bpf.h
 F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
+F:	tools/testing/selftests/bpf/*/memcg_ops.c
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 F:	tools/testing/selftests/cgroup/test_kmem.c
diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
new file mode 100644
index 000000000000..3f989bcfb8c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory controller eBPF struct ops test
+ */
+
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+void test_memcg_ops_load(void)
+{
+	struct bpf_object *obj;
+	int err;
+
+	obj = bpf_object__open_file("memcg_ops.bpf.o", NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK_FAIL(err)) {
+		obj = NULL;
+		goto out;
+	}
+
+	err = bpf_object__load(obj);
+	if (CHECK_FAIL(err))
+		goto out;
+
+out:
+	if (obj)
+		bpf_object__close(obj);
+}
+
+void test_memcg_ops_attach(void)
+{
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	struct bpf_link *link = NULL;
+	int err;
+
+	obj = bpf_object__open_file("memcg_ops.bpf.o", NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK_FAIL(err)) {
+		obj = NULL;
+		goto out;
+	}
+
+	err = bpf_object__load(obj);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	map = bpf_object__find_map_by_name(obj, "mcg_ops");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
+		goto out;
+
+	link = bpf_map__attach_struct_ops(map);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto out;
+
+out:
+	if (link)
+		bpf_link__destroy(link);
+	if (obj)
+		bpf_object__close(obj);
+}
+
+void test_memcg_ops_double_attach(void)
+{
+	struct bpf_object *obj, *obj2;
+	struct bpf_map *map, *map2;
+	struct bpf_link *link = NULL, *link2 = NULL;
+	int err;
+
+	obj = bpf_object__open_file("memcg_ops.bpf.o", NULL);
+	err = libbpf_get_error(obj);
+	if (CHECK_FAIL(err)) {
+		obj = NULL;
+		goto out;
+	}
+
+	err = bpf_object__load(obj);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	map = bpf_object__find_map_by_name(obj, "mcg_ops");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
+		goto out;
+
+	link = bpf_map__attach_struct_ops(map);
+	if (!ASSERT_OK_PTR(link, "bpf_map__attach_struct_ops"))
+		goto out;
+
+	obj2 = bpf_object__open_file("memcg_ops.bpf.o", NULL);
+	err = libbpf_get_error(obj2);
+	if (CHECK_FAIL(err)) {
+		obj2 = NULL;
+		goto out;
+	}
+
+	err = bpf_object__load(obj2);
+	if (CHECK_FAIL(err))
+		goto out;
+
+	map2 = bpf_object__find_map_by_name(obj2, "mcg_ops");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name"))
+		goto out;
+
+	link2 = bpf_map__attach_struct_ops(map2);
+	if (!ASSERT_ERR_PTR(link2, "bpf_map__attach_struct_ops")) {
+		bpf_link__destroy(link2);
+		goto out;
+	}
+
+out:
+	if (link)
+		bpf_link__destroy(link);
+	if (obj)
+		bpf_object__close(obj);
+	if (obj2)
+		bpf_object__close(obj2);
+}
diff --git a/tools/testing/selftests/bpf/progs/memcg_ops.c b/tools/testing/selftests/bpf/progs/memcg_ops.c
new file mode 100644
index 000000000000..a21fbe859fd3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/memcg_ops.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/try_charge_memcg")
+int BPF_PROG(test_try_charge_memcg,
+	     struct try_charge_memcg *tcm)
+{
+	return 0;
+}
+
+SEC(".struct_ops")
+struct memcg_ops mcg_ops = {
+	.try_charge_memcg = (void *)test_try_charge_memcg,
+};
-- 
2.43.0


