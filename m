Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3B7E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817626B00A9; Wed,  4 Feb 2026 04:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF7E6B00AA; Wed,  4 Feb 2026 04:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7027D6B00AB; Wed,  4 Feb 2026 04:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBFD6B00A9
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:01:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 248BAC286A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:01:40 +0000 (UTC)
X-FDA: 84406181160.26.C9A6EF6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 51761160007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:01:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qb4JFLb4;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUgIlqpjjjKsmTkW8jalrAzVxUqTtIlI0a7hWgOUGus=;
	b=HOWf0b2zgx1RHd76qaXkEmeejWUech7fdwbHC06uNVgJLSwtFAomJgzuwLeYEdCQFJfj+o
	W4UCYtV9/S3TukeDzOfrlY4f94cPb827URDfUzler8d5ZzSScUOaFN754QW1prpWN9zvGl
	o9WrPO1J7rA8GKJVaxQpu8CbsShu12I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qb4JFLb4;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195698; a=rsa-sha256;
	cv=none;
	b=fR/kRzZ+CXSeDUPal52BWQCg/FWt92T+wpm6AoyK4BaSp4dKvIv01wy6/L2B2zkNkGXo5c
	WsbYgLj87I4gWBf5vcEfUbgE2deYk4K6uLnezWKRQk9gH07ESyu9XQG8lF169x3afaHI3N
	I+ttUShETBty3QXDXI6GJBZc34zZtL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JUgIlqpjjjKsmTkW8jalrAzVxUqTtIlI0a7hWgOUGus=;
	b=qb4JFLb4WR4PhEKpDXKKSeOEg3T9iUuMYWzao8DhB0Maow2Ot7VfRx1u1uCpQ2IoKxxSmE
	8ok6gQSIbSaEcFpHYlhI/wKY4afiTMY0HP+IUpQ+Jg/IqvGVwTTLb+0q5mU/1z5KN7k4Sv
	ogKq87qv1LveACxZHC/zgqhyceeXIDU=
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
Subject: [RFC PATCH bpf-next v6 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
Date: Wed,  4 Feb 2026 17:00:07 +0800
Message-ID: <031afcd7c16e97f1f3c0d4a8a526a9eee2ad23fd.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51761160007
X-Stat-Signature: wjemx838t4urk6rjuckhw14m5cp38ymr
X-Rspam-User: 
X-HE-Tag: 1770195698-772706
X-HE-Meta: U2FsdGVkX19aS/9Npiy4o1YDS23+B/zHlftWPLpR095bFIzW8wO32cqEliRSpzyrGd+ChPBp9tjq4myhsq32bacIRW60PveeWQPRcQ4UNVD0YeqEiWgbLiAV2Odzj85eIyhrYnH7fD0UxLQy4VDSFpgNyjLiWqjNicB3aBdasZemt27EJjJko5NGybnVA7OMlPMz5lduITn7SCLFUx2PFhHuvsboSaf8GZDc1VqYKUCNokjusR0zj4VAG1jzD22a4qWEGNSCMJMESfvegSkALww9z69EVLCms2yDup2OEqACc5+nKgj5Qi3MorhX09Y3EsEHvPiPWaK5Zz90Phe2HB2RagPhNXTTbgFfjCrUkX1tPlkrFqjd9gCt8gB/unMmoSJmypHJ7aiSjKda78JH0JlK2/AfXFhtjvTysdNbps9iGLa6R6IRJJxdEi3Xop+KyB80qfYQebSCjBmsqVIdhdy3leLoowpm26vVo1cWd8YVa/H2NVUfSAZUWOutKfuWA/yY1HcA/L0wrjADRmHzGlBNLzwjKJgcDcfpZdZDVyd6P7cX2l7j0fJLRDEh0fDD4mRJf86WiYxibkdkl7o5bD4jmTVKTneX+NIHZRX2D1GaFd7YfLjQpO8GzVZqP72+x5zhFfAB4ap+2+22jI5C8gSMpbp0XnEYUIFKWm4nIGrmzwxsD/wjH4RYBIxPM/DKEKiL/o9ezYP88s20rrdmwIi+3jMNSg/Xqs8+eXdzeQyrptN8qQqiQPO/O4iqAaANyCz6+aUft/522XSGlO5+j7yOUFky6qjKM+yzyDydMBP5UMKyBOwTgErlCG+hkv8F7cq56VO83LS/qMCPCugaHRKkfgJOkRKCwLQCxOvtRh569wSYkpzUUU6fQtAMRMk7LrpOgEYh3N8+HX+s44tCcziTrrr6IjetoHWLNAobYI/ipjRJSYnfD4LGziWAad0ihM69//mrtLX0noQzJ/j
 Kho4jF1p
 +yEh3eWahYBG/JL7rQhfaN0tAv7gTunxfJ927XISvcuDcl918CcuCJo6Sp7abxkSrxDJPyTFEb6+OafRnrGh4R3GOz6iEqt4C19wyLNMf18YmhBWMHo3ufFgSFpg6vw/q6LK7+R40ug5zLNP2SasLc/5etLGm9Z3adYrhTPj452mxxspJ9E+Va9gsO206kzsjenyaf30X1dCrVydIWDbc2huoP81rdqvomaPwgaX3b32UtalPwYNlHO7moy9K6eQ/xK6vCEWV5oWjuZuv5dwdjiDtDl8eb1lfLYhWuD1q4qZLLRU=
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
index 8c787439f83c..378ee3b3bc01 100644
--- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -553,3 +553,74 @@ void test_memcg_ops_below_min_over_high(void)
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


