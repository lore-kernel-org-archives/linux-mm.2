Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB860C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EAB6B0093; Mon, 26 Jan 2026 04:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600046B0095; Mon, 26 Jan 2026 04:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5269D6B0096; Mon, 26 Jan 2026 04:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401366B0093
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:05:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E00C61A076F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:37 +0000 (UTC)
X-FDA: 84373531914.20.5E58036
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F8C38000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:05:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uy/RXibV";
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=eO398RxfiHZUO6ZA6QwmzXXVZyj44IjONW/eBWxZp7xdrJQZg9vIDFAfudkvzjHpfpNiqA
	VlMcx0ZIaWYDBaFhmSA5tyZJ6hKSAYAUUStTYHt+Wp0tOtPTKBxGi94vaUGghQRzwvDVFW
	QmLAXk9b/5ZQosfzYXZYXE01gFIr89Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uy/RXibV";
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418336; a=rsa-sha256;
	cv=none;
	b=qe/REQloXnSbHCeWV4zd6X7I1SaGD9KwEfQnKutkhah+7CstLmDnDQdT626iqIZI/gYUZx
	JOCSnR1Io9HkGbjwtD+xaPQ3HQ51d+rWXuTk23mYd9z3QnkvASBhe08l5zLym8VmfPNbjQ
	6gwi/v75GTB4EU4B2XZGkvm96WnfZGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=uy/RXibVJ3oVqmHcuUREIO42g9J6ZAIDsRa75aGhZMOzYi44E9zdwYLQ+penjI2tSnOZ+w
	LYhshtEuxxm3yPmlrUhEurCZH+tgHpic1Git0dNeJokwkgNF4kbjIyW7g7HRcL6RogvQ/w
	Xf01C8a/HuO2jBXWYYLKTeQ+JOUbD78=
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
Subject: [RFC PATCH bpf-next v4 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Mon, 26 Jan 2026 17:04:48 +0800
Message-ID: <635923ceadf1899672e4f7727ddc52554c11a3ac.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r85ejkt3ngg7brne3ubgiowiumxkm9hy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F8C38000D
X-HE-Tag: 1769418335-722214
X-HE-Meta: U2FsdGVkX1/gX+DTTAPjmfYXu69HV5nAssaiqAtBV73RJWrDBeWu/JSaENXNALD1I4H7SWcTyaGS0ref47CqYUz3eB1BVKayPeSfMHH6vTUsng4lIe1A7W6/JwCvocEFZAg5/0g7Q4Qsq8hRl7vztzAb3WrHQXnll2GZVEUdpoCXLhhBeCUY2PpYNtfvZWA6dIyh6u9zi+rd8eLbAnYW8rN+/XrlprQoxVN2kMRwyB+3oXLl74jVCJ2FQKEAUgHBaUhLBRuhcQZMZXiG1TcN+VvspLbUOqcpQQWdDuLX0ieuF231jn6OnPO0rzqMv0zMtZOhsiArabwz3dU0ViphcuG1j0jwgawWT3xbh1WnAjtXGbLEepCzCHNtZsbOiDtzBx4D28xDCMog0ZLjPb1xdBkROPT5cj5GjxAWAfZrVo3lUeuIj/slYa6/Ky5hc2XZPvSXtXdlPodbD7Xj6f5kwB29egxa5TTO/7W6+QtsTYjvbINS6HpzCX09QfuEur7Z2voLfxsAPzuF9249IJ4PpBqS4gKehEE6MtBmNXG/CW0QwxkQC72Q7tuTK622Q4yDTzJcRleED906pP4XgEBWrjwmP/4yD8cZBcvbWwHD8opHBbyAPOrBqQ7iySOCazwYbvaChz+3vF2tvwZlNJWZOl0AFjmaW8QubhNKqAW1DdNVBONX1NG3dUiNW2bLZ6OSSp5jvvoro7hMK5bBUSBKTHHalcMy9Z9RjcNE7hPNbxm5itE3UVeYfTeyG3fNcPis16/BlBQaCV5FZlehgernSh1YRc38XBOpELULevd0lSE1dCIA0Nf6kxKwoMo3Ai1zZrb/c4cTjc6h8FSdBpPn0dKF+e/yIhIN/1w9/HNkPp7dyzIBSSeUNc7rl8+v/Ydo5UKAJvzn6o/iqqzfv833YAJQOPxHKma032x5kKmImlZKL9TNUXQyRiQXwtmRLOTk+vOY2xm393AtecN5CEv
 kHYtE5T1
 UsjlpYvXOY6NvVm4C8eMhqmlv8uDUKL02ASfIuBcksShNrVScF2BhJx0Lv56rKwXvQzzLzETdb+k9BsPU0H5oZbuSmtymqAdt9LwbSQFY/4jny1Evkc8cjgoL2tNPbsqROUErAEfneBBfNkXxK/d9X2FW0qmbt2vESq2KoK4i4uc40dppMQLMfendJcjPIOkdSAnUAFuTqp3f3v5WLAU1ZtOSui6R/gvqn2uYaq7BP8ClUxLACGjfIL8bAPm0tlRnu3XquGXaMtgnKrKGnVz4QSuioA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

struct bpf_struct_ops_opts has the relative_fd member, which allows
to pass an additional file descriptor argument. It can be used to
attach struct ops maps to cgroups.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/lib/bpf/bpf.c      |  8 ++++++++
 tools/lib/bpf/libbpf.c   | 18 ++++++++++++++++--
 tools/lib/bpf/libbpf.h   | 14 ++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5846de364209..84a53c594f48 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -884,6 +884,14 @@ int bpf_link_create(int prog_fd, int target_fd,
 		if (!OPTS_ZEROED(opts, cgroup))
 			return libbpf_err(-EINVAL);
 		break;
+	case BPF_STRUCT_OPS:
+		relative_fd = OPTS_GET(opts, cgroup.relative_fd, 0);
+		attr.link_create.cgroup.relative_fd = relative_fd;
+		attr.link_create.cgroup.expected_revision =
+			OPTS_GET(opts, cgroup.expected_revision, 0);
+		if (!OPTS_ZEROED(opts, cgroup))
+			return libbpf_err(-EINVAL);
+		break;
 	default:
 		if (!OPTS_ZEROED(opts, flags))
 			return libbpf_err(-EINVAL);
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0c8bf0b5cce4..70a00da54ff5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13462,12 +13462,19 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
 	return close(link->fd);
 }
 
-struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
+struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
+						 const struct bpf_struct_ops_opts *opts)
 {
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
 	struct bpf_link_struct_ops *link;
 	__u32 zero = 0;
 	int err, fd;
 
+	if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
+		pr_warn("map '%s': invalid opts\n", map->name);
+		return libbpf_err_ptr(-EINVAL);
+	}
+
 	if (!bpf_map__is_struct_ops(map)) {
 		pr_warn("map '%s': can't attach non-struct_ops map\n", map->name);
 		return libbpf_err_ptr(-EINVAL);
@@ -13503,7 +13510,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 		return &link->link;
 	}
 
-	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
+	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
+
+	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
 		free(link);
 		return libbpf_err_ptr(fd);
@@ -13515,6 +13524,11 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
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
index dfc37a615578..5aef44bcfcc2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -920,6 +920,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
 struct bpf_map;
 
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
+
+struct bpf_struct_ops_opts {
+	/* size of this struct, for forward/backward compatibility */
+	size_t sz;
+	__u32 flags;
+	__u32 relative_fd;
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
index d18fbcea7578..4779190c97b6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -454,4 +454,5 @@ LIBBPF_1.7.0 {
 		bpf_prog_assoc_struct_ops;
 		bpf_program__assoc_struct_ops;
 		btf__permute;
+		bpf_map__attach_struct_ops_opts;
 } LIBBPF_1.6.0;
-- 
2.43.0


