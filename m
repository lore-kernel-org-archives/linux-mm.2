Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43390C88E79
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDB06B008A; Mon, 26 Jan 2026 04:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97566B0099; Mon, 26 Jan 2026 04:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979FB6B009B; Mon, 26 Jan 2026 04:07:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8456B6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:07:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B2F31A0639
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:40 +0000 (UTC)
X-FDA: 84373537080.02.268D2A5
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8730D40005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mFV6/iB9";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3K5a8wCTBgErPuuh83LiBeWSXPRqSOI9kf2LngSju4s=;
	b=o8sW+CyJui/IGfW6n7TIVFY9vGAUQif99zU6wKMTS6y716EvDseCxuyFy8CnjMuFAl35Jt
	DI49gBTTedov8JxVKPmU+G2UvTZKHKBU99ach+6GpOyK5CW+++hG6KPds8HHlNcetGSrEP
	U4v/SG24/44xdLvMrHHmqth4kiGh+fg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mFV6/iB9";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418458; a=rsa-sha256;
	cv=none;
	b=HPE9yOInBPX3r+wzycC3JgTpN917MBF7XcflCty8DoGlzAx0wKNUJdr7d+WQvDefARcsGI
	pfz+C/Rh5ljUppIhWUqFkiRROHEOPVZCEtFgQGG9DSi0xHQLZ2aQdzd1b+tklbQ3TjxEQ1
	SLISMrcFvJwvi+y2J+WAODvqbgqPUcY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3K5a8wCTBgErPuuh83LiBeWSXPRqSOI9kf2LngSju4s=;
	b=mFV6/iB9GZFGAUVD5NXXZ1rRRprzj3ohPE1BvwYPk5ov/lYjaaH+/gOu9fmlLzrA/86Pb/
	dDAZ9Php8zxcHhVoiSnlDFzeS3F1mjKEfKXJO53mcSkb1/J34M0lYogM8AN6EmSa5DiPT5
	t2hx/+v0iiTD4B6NkwmrUtF4Xnx8iJ8=
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
Subject: [RFC PATCH bpf-next v4 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
Date: Mon, 26 Jan 2026 17:06:30 +0800
Message-ID: <d7dfd68ed07fa445d616c3e21217bccafc951ae1.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 97b17q14d63pjsg8cqedpnn9mkd85w71
X-Rspam-User: 
X-Rspamd-Queue-Id: 8730D40005
X-HE-Tag: 1769418458-486553
X-HE-Meta: U2FsdGVkX18sKaQO5jAZPZgDfd2msQj1URjT15zFigyp1Y3xfVtrJB4bZVBwx+IRGNYu/IhrT46+38QUWwvC23xM2TwKdz0sNkSREYGfeYvBkEvnns+z7SBCY8ulfAdj2fAnSS8WwTkxIm+evl5sAlLn8wWuPdhDIe8fpVdvcxfWq/1gvDV3Cdci/X8aiRWBFHME78LESP9AFfQA7UtOhFExZ7clBnnBXSTKCPkdquMjUNSpQPzuVcCKWtOAaC6PFe0NM/XkRvHMk1BdyvQIbaZqxX5SCApffYe0Y13M6qZ80ZU4CD+XIo2JaPIcs0ublcAC0/HJzaVUUWUrO0hziJ6Ft+ueVHZ22MAOGL6Sjnx60T2gPDfuBbJ8CLHXWC2DtfcSpAlN+JH/yD4LNkjwzG9vuFyX8LjqiTyR6j91VJQk18GwodkRSESab0M7iUT1WqSBnxb2a8CbHPSuib84sezKA35aX81RC1I7JIGhu8Lltt2Ef5LQyoT22eWcWZXTYfuvgsy4LMjTFvuVtcAiFBIKjsP3pEJCFg1nDmHHycSLLjkJoV88V2HqKVNNt52ESW5FGydoVfYoTEu+E5/GVD3L/eVsNjX+cuP7t6kEdTL2uZJBG9YsipaBXlSrvWo6jq9gaXjSxFJwVFx4AqV38loHD6mBmkavW3XocyRlUwBYPLZLuC4i6PS0Xj8Dww38yXrQn+on1ZuZ4qA3lK+AZ75D7y04+ckZQg8GcHUvgxALrDx3KLJr5fQQkJ7cxj7Ha6QkbHg+EsAYQXlsndY3/qU8dYXPXzdFipb2Hcg8fTbW0AlhS3kP/WnvyoEvcu2/ctDqCW8iUHZjlZTHIKkcBoNW2XqZTI7SGTyTuznQ6oeO6/d2rZ3F19XDpI69ugvO0Hs5pEw38g5C3xdRCcfH+jyXmEscIx6kDPWxu8AFmG4mGmAhIYB4nRuNxgQg30MZSZAlCRQSrL7yu8pEki0
 9aIYCyl2
 4pS4r/hX2fO6aAj7HYrDMeCwms6vagO2I485+YRfKRArJtbJpxnxckADPEnfl5nf68QqAOpSrdK9Rqm9e0dB5UC9vZCNHcbXINVGzhyxXVxVFora8O8GM45jH2qz/zyJREZggaQIEuBuEZ4XVmGxWE/8iHA9sQFctFuuIaV9fbgCHK7wE0y2YEXBsI+sg2fE546MInL6Xpeqp8cTeBIBqQuU+2JrUAFAeV3NronZH5FzayvUxMqKEcGlyu/6ev0vD20uTvcXv36/iympeZDLR/FlA4PWvQ/Pd4sKC26yw3yBxl0A=
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
 .../selftests/bpf/prog_tests/memcg_ops.c      | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
index a019ba2387bc..08ac97752ac9 100644
--- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
@@ -539,3 +539,73 @@ void test_memcg_ops_below_min_over_high(void)
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
+	link3 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!ASSERT_ERR_PTR(link3, "bpf_map__attach_struct_ops_opts"))
+		goto cleanup;
+
+cleanup:
+	bpf_link__destroy(link1);
+	bpf_link__destroy(link2);
+	bpf_link__destroy(link3);
+	memcg_ops__detach(skel);
+	close(first);
+	close(second);
+	close(third);
+	cleanup_cgroup_environment();
+}
-- 
2.43.0


