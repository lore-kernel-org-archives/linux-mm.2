Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC93AD2D8D8
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9FA6B00A2; Tue, 27 Jan 2026 04:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB2A6B00A3; Tue, 27 Jan 2026 04:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D4566B00A4; Tue, 27 Jan 2026 04:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1606B00A2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:48:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5963140B29
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:48:25 +0000 (UTC)
X-FDA: 84377268570.04.D53D1C0
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2553C80005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:48:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6bFglpo;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38FTcR+0kk8dvZzN/w/J+BLbrBHVmHWXDv78hCgH2EM=;
	b=SnFQqFxpJt56ekZALQfKRzn6tgA1LwRWHGjnnHcvw7wJ8O1YVSd5f6AC+uwrc3cpsBYBrl
	AUS0eMTjRc2f1kn+1Wt1puCf5KsjK1QneomcOwxT9N6i3Eggaa0mm5UfDLoUx1ldf0Pyfn
	D9vgXrURWQgphq85AMsqrR1ENOQvscU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6bFglpo;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507304; a=rsa-sha256;
	cv=none;
	b=Dw0ZAwAAioeKV3JwKAYDWVploaiqk29aKarWFI25kDEJHtZnGmhPxa+7vT/pNBGU5p748w
	bdLTWuOnQfPhtnHF+pkwn+5CuasGAPmTSKRfkt7vP7iEkO4J14+44tcb/UWRu2r/mg9Bwf
	gD7leSosKz31h2i9rdIX5rmwOr2aIT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38FTcR+0kk8dvZzN/w/J+BLbrBHVmHWXDv78hCgH2EM=;
	b=O6bFglpozchYmTk8MyWF7zSH8QHQ/5EZph8UjcURHY/I6G6u9aXp2ss64fZKkFnKeTpNvs
	tqZkyPA0egpf98Jjir8s3OFqJBVHPe/YdMWqAaDUaIlv3XWSiPw7BNJnNlyC8/LXNOvDMD
	WP6OVk0NbAaZUqMMsVcEI9DpEPS0RyQ=
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
Subject: [RFC PATCH bpf-next v5 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
Date: Tue, 27 Jan 2026 17:47:36 +0800
Message-ID: <0b2c894a6544aa44db25d01def2c6c3e23a8bcb4.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2553C80005
X-Stat-Signature: f1b7kqu3rfjahegjr4tz4p836c6j59ac
X-Rspam-User: 
X-HE-Tag: 1769507303-264492
X-HE-Meta: U2FsdGVkX198m2rk3WIXdcGzglk1HZ30E3PjU1W3Mw0PSajMc1knf2GDC22T5VbBwHmDWSKTLXwECxTzrJuEnAjp/RFWp97AcowZA87EnMunKTaC6ddg8WK87yOygStGorbRZH5L39rEitBA5M/dRVDG3FTKlcydIjsROnj5xrY7R6iOQbzz2Gxfb0XwLCoSFKnrUrbBFS5El4NO5sWHZV6I/XIez3YKqrac6zGAYCc/w19rymOAh/K+Sf1psLPS9gi+auBffW9GPxpfgzZGkH4D/bMWncjOMW77s5bLxFmmvB7DrXfsEBsiZ2SbWVFYY4RCoGO5M0CWB0Db2LhoyBBssOo4U5y9HOwESfOl10UQ2VqNkgcUemkefPY5mDSQClwNCg7fkZ/9dae7QlOREIb+pa/KMv962FJulA6baT84etv+I6tpd+lgu67rqfqv6HH2UtCI7N7mAMNtVOKJ/1nlfdM0H3AN4GSeabnbqyuRsze/QGTUbwyPEh2qkog3TxH6DxX7T6d2Yejbcgj0/8vgND9FQphXO0oJ37b7ix0m2HyKgvOst26m1w5r3AyjYkLNUhVAsf4uTDzuSdUSxda+7zo6SKcZIqKgYJYCl2LW+/u2PhcoQFHScpATa8ruvjYn4WSE2RU1wsbmrhhmXsiHk3G8tCc0QGXMhJkXAoIFlh14AK/4qse60vDjyCs5qq+xuaiweitpqoGK7dv4ueLO90LpVjgE0XHFnMUcYriboR/1ppjy2yJCrHGUG42JEzXJDxNBEvEZorA4UrkpK/F2rF+28NBNRfYddbHtlVzTFVF+UC574gU5ooyX9oPy5kE1wX2w3sUD95iPVnZSdWWGWhBeyFXiXmJrHUz78DpQLd5MimXYyu4ow7kOVds80wB4tZZXd0Crw0zUCjSaJGU0QVOAKbTZ2YqqVOk+eB/aTvGtzUnmu6Lfkzl9dJC+zoSvIY5NPgl8ymgShCY
 F0wvYRgN
 11bthDFnyKEOSCfFX4tkwAhrsGC+jwU/KMeWPaI9Oh/yYs+rc88RVUON4Ch2S8udkVpWcHPi+I3cagcuVE9XpEskFcw/uMT8ralPR9ouRl08/aHXdzqeVTo5DnvVXFGkjpDt25e64N6OmegCGHCcfgcwG1Anm8tevTJLTWqQRb8TRUdYjculI8xKANpZ5ETOHjXafCsRE9HIAglDQHWfEMK3vfqHXcUWRlfxoUXeaQ50km/6qyyf5QLiMi8+cy8lIkxLsGEmNwhFN7UHpx2EXeIMFtOivcTuVFi24fkq6yqBdHCc=
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
 .../selftests/bpf/prog_tests/memcg_ops.c      | 71 +++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
index a596926ea233..91084e8acc32 100644
--- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -533,3 +533,74 @@ void test_memcg_ops_below_min_over_high(void)
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
+	link3 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_ERR_PTR(link3, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link3);
+	memcg_ops__detach(skel);
+	memcg_ops__destroy(skel);
+	close(first);
+	close(second);
+	close(third);
+	cleanup_cgroup_environment();
+}
-- 
2.43.0


