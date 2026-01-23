Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000BFD7235E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7CC6B047C; Fri, 23 Jan 2026 04:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C66A6B047E; Fri, 23 Jan 2026 04:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6996B047F; Fri, 23 Jan 2026 04:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 367A96B047C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:02:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F418B1AF62D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:02:35 +0000 (UTC)
X-FDA: 84362637870.10.528FAF6
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id B23FB2000B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:02:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJHq11Pr;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iLrjiv0gburAFEhS5XqHyT8faYM4NGG2Wz0oK9Qdf4=;
	b=Z36XTiu4rS8FeQJB/w7HCslo4ABQ10Ff3RT/nYCS+U7PtCbd9UiNflo2jb8Kr/PpjW5dWO
	lRVCP5b3LTdmyXO2Ad+c0yzh///YRVz6MyDtgIt4n0S+9aIqp6TWUYs6lWS4USDf2d21PE
	Up9b9ZYlrH7DrB+Ec28ELwqeaYDXgbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158953; a=rsa-sha256;
	cv=none;
	b=kuztNxl8eIfD0C2miyRy0xNZskIho1BOQQ2td2Q6xGCYpcAcp5FRy/G1C5OVUtRnLJH3Fw
	sUYRmHnyyqkzxsbL6M2Mf3w6Cu5qHu4WzcEg7Yxj7h0MXHJz1GuM3IIqHlEgY2SQ13YoJa
	Qkunu7hUK206pmgmBrRUiib/tHbHPrE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wJHq11Pr;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3iLrjiv0gburAFEhS5XqHyT8faYM4NGG2Wz0oK9Qdf4=;
	b=wJHq11Pr0GtVVpulWuS2H7wQCNNdItz0NY2nkgb6vSa3RZXwQxkbhqsUeYiPsYfKmvchNj
	8rb/XPQ/7gZHndK/RYsb4oM88oS1AN7JHx/F/2CE0WDV3dM+lYhsd1TvOWQaVrrDDvXsqB
	KOmnqEtcE6XYQWOHeU9x//WaEErpY50=
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
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH bpf-next v3 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
Date: Fri, 23 Jan 2026 17:01:54 +0800
Message-ID: <db8b80a445a61b437c35c71ec2edb573002656fc.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B23FB2000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: knht4y85u5sh9kodxmqci1qa9nuojjja
X-HE-Tag: 1769158952-859666
X-HE-Meta: U2FsdGVkX1/YjlSUWkOoX9mapSbcH/rvrzhZyziKHN64h8jII2l2psJFi2UdckDCfmh3KZe4nPBFnuXX/NhtrhWb46CxZGHPZx+YqafK9pkIMF7sIBwJfjMIoJrb4vr5RhFzMMz1aBXlQ7PG4AxzQ6rgX4qEgyPvlZJy2ASW+th9Mo08grsontInaLZ6D3LBZE+x3RM2X+r0aleu04autmhPPZTWg4Df808YHQLhqyox9IVJLKkeKWcjsIJmpwKgIbYdiFu69vtk/uKovBFSri5y6mFFJUWLNLmkQUfJr1WGdPGtK2KnDu/735x0SgbDn14yb9xZo4JEJYddl7BynE9WE9gjP+/4Csptzaz6BMeifg34w4f1mO38qiGMvdU+3eVsU5IFfkJlzeA9epM/7rfIU6zVVLYaP0cgxjcAnB9ecRGkBSWri5af+rfbY1HHXbNoeFyDqJUshm/fZ9XBXZ3mTpExOt8s3DEwF3y3q3S2lKoQX7pkrcpKJamnzY9Pm3kNSKHEIQARIGx43X+qYIS8obsemNuB3JrG+BVXl/yEYGBwTSMnE7OtYDYlLFE9pOBtAyrFN5/B9grddqlpMp54kCJuT+JQ+KLwf9j40qlXpOk2QOT40nHgug0TjY8EDt4k+6t9lm2y7YcXFbMnKuiVrfU9mm55jcD+XVuUxDuQxaxN/1mAYgbtkQBNLAgYmJP8wooeaH/PUyiGkESc8rwOG1A/0gViRxRlxQZQYT3Q936ZY/wxJHEU4tQH0r40zr6JDv8VK8NppQN/4cnna2fPywmEHzh3Iwdvwol7zt0q3d6uUESq2qd2q30/CcxbLEhBEW71R1AuTgQhIhKmUJjZrt5MISp1TF7uAxNUa3PuV6NDMOSP+CasZqe6duYE5SGRtW5/tWbIDa+Z04nKsw+PLwyxUA5gmt6UroVcNqekao9r3vnxJM/wSK5Y5qK3lHSr3BxxeGxXbX6kNMu
 aPYRwsJ5
 qBGiXjJK+xe7sYpy+J6lpWo+MrR5nhOsBQE9XPEnso8IUGpnVd51AMwHsEufPeuTBUKwU0hsnQ3vrrZmzU3Y2EgVXoeuL6NEdWWb59cn1jES1jiDCRY6dRGwmhJXv32A1b7LkIcGaZtSqAUUJSEVtHskROwkc/uPFgxnIwBO8lEXIJ8BmetRenFidfqQU7BkrkooBVkdHIIIOSZ2Trie+z9SgDKUkwnjj6ViSCES0GcF7JjyhakR+mim2BBFIn13dkV18cSO9nIzKNl2sepqj68lQ2vk1SFNVCHBKn+6ZO7X6J7w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/prog_tests/memcg_ops.c      | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
index 9a8d16296f2d..bab9f3094f59 100644
--- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -535,3 +535,72 @@ void test_memcg_ops_below_min_over_high(void)
 	close(low_cgroup_fd);
 	cleanup_cgroup_environment();
 }
+
+void test_memcg_ops_hierarchies(void)
+{
+	int ret, first = -1, second = -1, third = -1;
+	struct memcg_ops *skel;
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
+	opts.relative_fd = first;
+	opts.flags = BPF_F_ALLOW_OVERRIDE;
+	link1 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_OK_PTR(link1, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+	opts.relative_fd = second;
+	opts.flags = 0;
+	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_OK_PTR(link2, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+	opts.relative_fd = third;
+	opts.flags = 0;
+	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_ERR_PTR(link3, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	memcg_ops__detach(skel);
+	close(first);
+	close(second);
+	close(third);
+	cleanup_cgroup_environment();
+}
-- 
2.43.0


