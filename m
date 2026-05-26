Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D13CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286256B0099; Mon, 25 May 2026 22:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F2A6B009B; Mon, 25 May 2026 22:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7086B009D; Mon, 25 May 2026 22:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F33916B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:28:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A45B31C1023
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:33 +0000 (UTC)
X-FDA: 84807987306.03.8BA40F4
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id D8D1B40009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:28:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u+OBhwgH;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762512; a=rsa-sha256;
	cv=none;
	b=H8E8VvGlWkyBDVGgDgy2ZxGfGEOoFAf9SoFLb3JCBaeyh9bRZ1ZGvRyHwJtS/ObncBaK5r
	nOJ/F8otetfBkCGCDG7OiraYoILp1MOktGz2xgus9xLW934jH43vV2r6Zig9+R5NF4F6fh
	952g1Wf4abChJXQ+0yjg8mdhNG1RwDw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u+OBhwgH;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IvkZWXPTCl+S70lg431XAc/NqFXphJXLE3UltUPGFag=;
	b=8ctu+qWu3TaB0ah0uV+JST0zO1hFSXKKU5JqyLjQcee5OyuRlw0zlbfVGy6/NXXIPEeBjq
	pCNZO7UvZYB4H8X/VovFdLZDTZj652qS+EhPr/C8IrnEaDCZ9Fv7+iqowravlaDKqa5JS2
	GbrjG7CzkqcNtXSMR/cnRQPwjN5lvMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvkZWXPTCl+S70lg431XAc/NqFXphJXLE3UltUPGFag=;
	b=u+OBhwgHyQzfoVd9lAzv0TIz8bmU0/usJ47HXAhTYO7GY84MUfYO57hSO7U40EGgyGQGfH
	1BVXw8FwkxIO9cHiYVFTSRyoxyIreuB2LHK+hQBvhJfhDigbmUhuUroRxSu7kP/MzB2590
	mI/XNhQ4g7XrJLtdtiSyIut7hdrKAZ0=
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
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
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,
	baohua@kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH bpf-next v7 09/11] selftests/bpf: Add test for memcg_bpf_ops hierarchies
Date: Tue, 26 May 2026 10:27:54 +0800
Message-ID: <f2740b58570c06c275946f31f60858e875d7bdfe.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D8D1B40009
X-Rspamd-Server: rspam03
X-Stat-Signature: g4xgsbycfoii14oxah5d3id491a8n45r
X-HE-Tag: 1779762511-440448
X-HE-Meta: U2FsdGVkX18U9dSHY5vDH8QGjwcnzEBlNe3HGrwtgmo6szm5BJSLVDn70SwlFipaUK1k3UiL/LXzRsWkWkiEIuyS4TOEacYQkTNbJI0XyaFZLCdKfXlYzkS83rpun95s8pV2W8CceiTMvz+NsRsZ2A2mUmR4H61+DL/Cj0JDLNEP8CDptXSH76qwykSlbgxn6W0kKSjN0m71yq7XIp+0jO0Ti2D2OSkqBnAqFgnXhx5yC614UknVIBfjvUqPDzRbWe1+MlhjRfYM3Sm/Jv+kCyIPPXQyhNYS5EAp4hCjACHHRu1NMbUgF2DVTr4aGitjUv/dwmRngg3UIiTyYH58pHDmS+ClXY9384eFL1oGhmXuAriGuxnMS+dbdLEM/q9e8lVFnAYOzlGFyckXx32sRI/Kt9nkiNXQcOtQ2RGga1UfZznjzA2RlHZVIYsu7zl0T+68qdjlHk3Z81ymo4gDgmHMQHgjBkrIDLCEGnMI9tBt5DFjZ5HB2+E8j1nCQrpM26AZBPZPJ603oBBZga+gJJHG+N3+0bGyb0SXm/HexiHNENv/MwkE76kyJq0apKN08IL8krBCwhJ7+Z7cDsByak3tkqKJWvGfx2qlIbG0aYHz+uXwa2p0ULubYHr00cx/4oc/Hr6T4qRlqWhNaHyORQIk7kUhHnM+wbOEXt/pazhnhmQACdizLE44akONskryIm0lSKwlU2FnUTVr3xOibLpmbDeaH8V6c9Dr3oB8l0Ap7BG2kVTF9f1W1wfRL1NOu1FReLAS4KMJ4QWr0kmfl0zcK6N1ET+joy+aYlJH9KxudysyuFMkGtlNp8CpMhR3AZ18hL0WyW/UJ8+P+QLruTwPCXXcMu9erRQnpB3n8FoRR6M11H2Q4+y7+pfaAdPwM/B2fZ2gROXndw9zEq8YvXrDcpygUcvIP+086SU/6TLf8cGCL7gZ47I2zVIWg4FuoQerX1oz4LHl6uJ4Q/i
 6DLUqbNm
 Dmpporw4aqjS171zsF5bSbR8A0ExPWB3GhrP4hO+kFJ16uxN7D4D43IjW+JwV+YfTqVaPxZyjAeeeU1O2mZ0BTIvipwTqrFQmQCNiFw7BRGD0GJF3KtVOzCQGGvfhRHRkCUt7bGxhSTq1t5mg/o6aYSTXSe6ZWtc15++X0qQAuML5YM7xQVfHupzGAl+GBGL1aI01+N084zAnJcHF4nS98uMPbAMmysiMKGO69e5At+BnpTmczxQgXPWwyIBxtID945lSv4cQ8Qm0HNzZV3Jw9q9PB5h4TTW7TGD2fZGVKZsJY/ouRPRzeALt4LrUbon+dsevb6X18USMfCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a new selftest, `test_memcg_ops_hierarchies`, to validate the
behavior of attaching `memcg_bpf_ops` in a nested cgroup hierarchy,
specifically testing the `BPF_F_ALLOW_OVERRIDE` flag.

The test case performs the following steps:
1. Creates a three-level deep cgroup hierarchy: `/cg`, `/cg/cg`, and
   `/cg/cg/cg`.
2. Attaches a BPF struct_ops to the top-level cgroup (`/cg`) with the
   `BPF_F_ALLOW_OVERRIDE` flag.
3. Successfully attaches a new struct_ops to the middle cgroup
   (`/cg/cg`) without the flag, overriding the inherited one.
4. Asserts that attaching another struct_ops to the deepest cgroup
   (`/cg/cg/cg`) fails with -EBUSY, because its parent did not specify
   `BPF_F_ALLOW_OVERRIDE`.

This test ensures that the attachment logic correctly enforces the
override rules across a cgroup subtree.

Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/prog_tests/memcg_ops.c      | 73 +++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
index 19fd4fde2266..b4084e9327eb 100644
--- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -559,3 +559,76 @@ void test_memcg_ops_below_min_over_high(void)
 	close(low_cgroup_fd);
 	cleanup_cgroup_environment();
 }
+
+void test_memcg_ops_hierarchies(void)
+{
+	int ret, first = -1, second = -1, third = -1;
+	struct memcg_ops *skel = NULL;
+	struct bpf_map *map;
+	struct bpf_link *link1 = NULL, *link2 = NULL, *link3 = NULL;
+	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
+
+	ret = setup_cgroup_environment();
+	if (!ASSERT_OK(ret, "setup_cgroup_environment"))
+		goto cleanup;
+
+	first = create_and_get_cgroup("/cg");
+	if (!ASSERT_GE(first, 0, "create_and_get_cgroup /cg"))
+		goto cleanup;
+	ret = enable_controllers("/cg", "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	second = create_and_get_cgroup("/cg/cg");
+	if (!ASSERT_GE(second, 0, "create_and_get_cgroup /cg/cg"))
+		goto cleanup;
+	ret = enable_controllers("/cg/cg", "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	third = create_and_get_cgroup("/cg/cg/cg");
+	if (!ASSERT_GE(third, 0, "create_and_get_cgroup /cg/cg/cg"))
+		goto cleanup;
+	ret = enable_controllers("/cg/cg/cg", "memory");
+	if (!ASSERT_OK(ret, "enable_controllers"))
+		goto cleanup;
+
+	skel = memcg_ops__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "memcg_ops__open_and_load"))
+		goto cleanup;
+
+	map = bpf_object__find_map_by_name(skel->obj, "low_mcg_ops");
+	if (!ASSERT_OK_PTR(map, "bpf_object__find_map_by_name low_mcg_ops"))
+		goto cleanup;
+
+	opts.target_fd = first;
+	opts.flags = BPF_F_ALLOW_OVERRIDE | BPF_F_CGROUP_FD;
+	link1 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_OK_PTR(link1, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+	opts.target_fd = second;
+	opts.flags = BPF_F_CGROUP_FD;
+	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_OK_PTR(link2, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+	opts.target_fd = third;
+	opts.flags = BPF_F_CGROUP_FD;
+	link3 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_ERR_PTR(link3, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link3);
+	if (skel) {
+		memcg_ops__detach(skel);
+		memcg_ops__destroy(skel);
+	}
+	close(first);
+	close(second);
+	close(third);
+	cleanup_cgroup_environment();
+}
-- 
2.43.0


