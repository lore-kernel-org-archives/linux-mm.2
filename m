Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C642CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E626B0005; Mon, 25 May 2026 22:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14966B0095; Mon, 25 May 2026 22:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A2F6B0096; Mon, 25 May 2026 22:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82B756B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:21:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2471D1C1023
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:52 +0000 (UTC)
X-FDA: 84807970464.01.A7FB834
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5DEAC40002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:21:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZjgjlwc;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7Bh9sNsoNgUnqOqmMKX4zg5u4PI6PFUbnydcfDlgqU=;
	b=CGBkD0JJ8POZ60L4a9PJTv13yjOX25wrC+UTGOgRIyvKBFMWZt2WmsCHJKn27dLsliw52K
	U5LMooTMB3knomRprGpTLukpsupKIcOxjEn0GYgbGm60zJRKjSu2Aq4X1ErvRkWLWvpK3Z
	6PK0AfBg1fGl/G6WPe2dwN0Gfe8ULWU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZjgjlwc;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762109; a=rsa-sha256;
	cv=none;
	b=xEf1dhO31T+tWml6PRtF+C6jVEXBnF/NC7ORfAV8prpGRMpBD5qU+2cETvBJEuw+z/ExQ0
	0ttOc2RMlS8RRCCdzh1jfRaXEKkOKZ7NfuuULPUtXcCy+/BBKdEbLnvMe0EwbcWWJmgj3Q
	QvbZ2S/cEJpQiTw35AARBcthq1iA+a8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7Bh9sNsoNgUnqOqmMKX4zg5u4PI6PFUbnydcfDlgqU=;
	b=PZjgjlwcve5jLdLXC3W81a3ws371QG0/VRoWhYadFvjsVk98w+mAqx47aeLN8a6ph9YnUf
	wYAyBEJ/yMLAYymhs/N9jK+9yoIBpF574W/zXiDvjjYETKv45kx5umPmOt44LK4shgxJNN
	OIxwgn8cnfbIglwOOZDZKFLyxXRjcnE=
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
	baohua@kernel.org
Subject: [RFC PATCH bpf-next v7 04/11] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Tue, 26 May 2026 10:20:04 +0800
Message-ID: <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5DEAC40002
X-Stat-Signature: mawkh997qtbgq1h5db5uwdiw8y5gq4pe
X-HE-Tag: 1779762109-126569
X-HE-Meta: U2FsdGVkX1+fduP9TlCXnvGnZXOEc7vIgMiTo3HWeR4/haUGe/Y4ZVfn0WU+wx+r8BxbLvkvG4n1KuoyAKSagpBxiLq9x6qUo28oCCfuZa23H3cdQ5RSYQ6g4qb055dx5UPX1Z57c6HdAFa8NcR/ejQWFV/EVezFpOgVx3r9hzALxP4TNaZLVsuWtrLJIshXytLy1vJW97wfn8IWN1myxtWb4NB020BH5Ui4pxmjUI2pB3F/4/gs59XKGaps9/LnIJ8Z1xl+1IeEepIRLue9cdnRZJawX46WyYeLTsxUD2RSq6ljxc0Fz49lfPSuj9T8KJEPbDLkrDzYbueKRShkUgoXE5Qpe1yKYrFrYkdslrJ9sHlf5KcuIVzc2edZ8kwEBFfpFLO4RIK8w2DW3W9zfqci/YNPoJRdEEg3Q4/UhUz8618b7fSitKUjaj/n48qj5aZc6gFWH9v4vgF/qSHIXTJn27ddbpQR/ujoq1O00HSDSsf1lzAk5RSlcrv3OSaTJKGszCcXt2J77Frgs9eZdJpME6EKxPbrc2j7Z3TlnUPtbKfZ9E0rBqIBdCl9gT+FUhrc2WJ7wMvZVRCmiJa7oxejG5BqY5svYcCI+YPgY69zkQUUkRs5LwAv/OkATW+Y8jj5I4SHQDTkdHrqxMn7iUfXe3pEktrGF3/IZSclDtKShW2nGLEh+hYQSWKljInozZgIh9+b1d7zYDtJqRSpP6SNknQ/36a2RBHSjAW38vnW3DJxOIUHT+YEUN0qifQC4/Y9Zklqi8K75EtLfsUZlEBAEy1Nh0HwG5DBl9mDVKvCi9PfFIrY1lvjv6d41JISjAavktE4b12h9hIVYbc8w7Dwiv9Wy55Pn/1s+LbPvQWV4j2Y1GTFPOxTUuTU8Ivp8CMu1up7F0qlXmmhBLlas2t1ikP0p79y4yuqcRvlaWzKpjkTGZpESPTuk7Rww29TnhD+eqpfCRw8KEB3uiE
 rnxDCvfc
 HarCMT/bIIyCkpb2MhzzH1+AQl/pP5asdcnqGR+rwj4FpimamvUyxDDn4Khc4BWazfO8uo9G1gN1cZzKOC3jWE/ah7D5ASzak9N+TjfKViPQJLgNI3IF87TRLrMcYEwd+BLhmVh/KqPpyqsdjm5oq0VCifdmXcQiwR2SNiw3dvE1vvyMPgTG/Iiu8ZBlBPMkL35wwBXh9L1DoWXs+4075KsNxPw6Y/KEP69Y0mnEshj88Tz1MbS0DXXlKT7Rm28w3pKYwctFxM8y2iKs3dl1vQRxriA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

Introduce bpf_map__attach_struct_ops_opts(), an extended version of
bpf_map__attach_struct_ops(), which takes additional struct
bpf_struct_ops_opts argument.

This allows to pass a target_fd argument and the BPF_F_CGROUP_FD flag
and attach the struct ops to a cgroup as a result.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
 tools/lib/bpf/libbpf.h   | 14 ++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e8688975d16..a1b54da1ded2 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13683,11 +13683,18 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
 	return close(link->fd);
 }
 
-struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
+struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
+						 const struct bpf_struct_ops_opts *opts)
 {
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
 	struct bpf_link_struct_ops *link;
+	int err, fd, target_fd;
 	__u32 zero = 0;
-	int err, fd;
+
+	if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
+		pr_warn("map '%s': invalid opts\n", map->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
 
 	if (!bpf_map__is_struct_ops(map)) {
 		pr_warn("map '%s': can't attach non-struct_ops map\n", map->name);
@@ -13724,7 +13731,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 		return &link->link;
 	}
 
-	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
+	link_opts.flags = OPTS_GET(opts, flags, 0);
+	target_fd = OPTS_GET(opts, target_fd, 0);
+	fd = bpf_link_create(map->fd, target_fd, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
 		free(link);
 		return libbpf_err_ptr(fd);
@@ -13736,6 +13745,11 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 	return &link->link;
 }
 
+struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
+{
+	return bpf_map__attach_struct_ops_opts(map, NULL);
+}
+
 /*
  * Swap the back struct_ops of a link with a new struct_ops map.
  */
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bba4e8464396..18af178547ad 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -945,6 +945,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
 struct bpf_map;
 
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
+
+struct bpf_struct_ops_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	__u32 flags;
+	__u32 target_fd;
+	__u64 expected_revision;
+	size_t :0;
+};
+#define bpf_struct_ops_opts__last_field expected_revision
+
+LIBBPF_API struct bpf_link *
+bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
+				const struct bpf_struct_ops_opts *opts);
 LIBBPF_API int bpf_link__update_map(struct bpf_link *link, const struct bpf_map *map);
 
 struct bpf_iter_attach_opts {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index dfed8d60af05..6105619b5ecf 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -454,6 +454,7 @@ LIBBPF_1.7.0 {
 		bpf_prog_assoc_struct_ops;
 		bpf_program__assoc_struct_ops;
 		btf__permute;
+		bpf_map__attach_struct_ops_opts;
 } LIBBPF_1.6.0;
 
 LIBBPF_1.8.0 {
-- 
2.43.0


