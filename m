Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A448D72350
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08ACA6B046E; Fri, 23 Jan 2026 03:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0487D6B0470; Fri, 23 Jan 2026 03:58:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62D16B0471; Fri, 23 Jan 2026 03:58:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D14D76B046E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:58:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CD6E58B92
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:45 +0000 (UTC)
X-FDA: 84362628210.28.6CFAC16
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93F01140007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fTSVavEG;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMDUAyLhkyqoXu0AnX5yMDVCDjfmzYBfHTdL76REPRM=;
	b=MD7UO86pX8LXYp/bu5YuiiIoRVHp975BtjFwpH1x8NTeiLiSpvvFNJjcMlnjsMb2QSAOOW
	vv2PoeJuXMSAB3S2jk3AEe5FJgzzjHhKcctMFvRU/G4hl1OnQ0kV2miBpGxQ0aJ2+c+RVq
	jr/jyOBSpskz5rKYNxslydftf3tFg6Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fTSVavEG;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158723; a=rsa-sha256;
	cv=none;
	b=y1bM3GNSIaotq8W6I3o5Jf2Yb91l7IyQ5Z+ns0Cyaoire7ZRb88HxVllovB/wDteM4MTZy
	5Jih7AVADYDodSpWPuW88Qs4WO/VIIhtStgcb4e/uPYKn562t24ix/H9HzxZ7CK60q8jsH
	mCPUX13Ls/0coDqz/zj8cen6dzrL8OU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMDUAyLhkyqoXu0AnX5yMDVCDjfmzYBfHTdL76REPRM=;
	b=fTSVavEGC9/BVpguN5QVYm6QgZJEp24s+u5liPxQawZxkjy2xNt2bcSuWIp+ppId6ZUqs0
	JRlAOIGdjfyU2rNCDJGZVi2xCMUGSQ/OE35BXqXa+evHCC4pJld5lS+KTcbVbGzQ0QUo1n
	FPxiGBbhQtm8eBP+7QW/eolDZuX+f1g=
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
Subject: [RFC PATCH bpf-next v3 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Fri, 23 Jan 2026 16:57:59 +0800
Message-ID: <03bf6aafe30def690c63e454d76e733f27dff4b3.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93F01140007
X-Stat-Signature: t8gmjbfd73b15azzjdyij6z1up49dezq
X-Rspam-User: 
X-HE-Tag: 1769158723-825907
X-HE-Meta: U2FsdGVkX18rk5PP6kFZP8qrigD7r00EXP4SQ0pA8w1i5uo/n/LeDh5GmkPXZeN2jjnxGiTfJUn1y0ZByc2gyDmoEXXGUpS6+7nri1VlcwOWJxgrH1CvxMrm3YEuvJJbOIKarwNnRGWgGuRs7Fc+2A13kNOZOocZ+Rj2l0vpLUxdE0KJ3LMfrWYhdqLYC7Jt/KqT7jKi66so2NmRngyyLw2I4oFgdzM4Qtyp2iJdpBewdWgWvpch2GhTZw4tl304nW/H9veQ8ikn4R9XdXYVzhaynu+4HTYvL3U7l9LBqHvG1RHropjzxaUvdJGeeOAZqr3eoMDr9JU1MpsUeaPSwEzkBR2M2zycvaFxXsmsz2gZimZdTanpySXRAkNWwYSWrFjWSc7vNK1LDau+zeKOlCicnCICy0vwcswU2Bx805XOYWcYQ3DpOx8fvLLGFHk6lZ09zHDFAM1tT9Shei5zqUHS2qJ67F0Er0RP3oDxVwpFiBo+m6zQsIT/m2yBtkXljKU6DXhTtrQLZ5fhIz2w/a5xNkISyjek59bSlWG9OgzT8iBpLzS9O4+NQQuHgpQMO9xmtjAycCndi5Kipr28Qv992yMRqIPwm5OmmsEEzOjvLAJVPAdQ7Go9w47Sih0QduWcCaVEqREA1CN5PdiQEExP/j5HZkzkbPgnVxwyMFGqaAXhSeXVfTva8kNm5pLKboN0VRSe/giE8rYPGX1b3H5YcCCrtrIRd09nvH/DglLX8XlJjrKQ+NvxwDFwxq04a6gYKDup2z4V9W8pevyEOVvgN/bvbO07rMLKmQAI64/WI/Ue1/HdPneynPTpawKmGdH4pwTPAiZxDRuIaGg3zH9YJBIXv8d1k2qFly8/tvbuO1uUEGjaOrK9tWFXCWufYxnHFVCWCaGlfj0JPvasbYkuZRY5O+aKb4NUklx3xDAWQVzigAhbVqkY4Aqe5VcHlEtQnrk1lunBxfUhY2H
 E6qciCB3
 SMKt/vAKGNEbBvQslZCJF2XNgS1KSMQH8vy74y2ELE4SUrHI3BjN3V0PERvfZWIzoc/9Ryrfe8eCH9l7DppKKK2EGo9VFH0cKht8aNpbHyMVzoIpPC6LFNlKM5diMnhgivI0V9O3IrOGd8r1wFrU/7royxkotD0trn4XrxYlYrOcvFVSala8mJdhaB2u1M73ge7REZnj8h2Rc2dYn8q7l85sibU8T7/EgnHYktrK4tUXp1qZR30U4jDkU/XpQA7zPLwQ9SKkaUczFVAxk1Ai7pc58DQ==
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
 tools/lib/bpf/libbpf.map |  2 +-
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 21b57a629916..a2833a50a509 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -883,6 +883,14 @@ int bpf_link_create(int prog_fd, int target_fd,
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
index bbcfd72b07d5..37eb4f96b28e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13459,12 +13459,19 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
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
@@ -13500,7 +13507,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 		return &link->link;
 	}
 
-	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
+	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
+
+	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
 		free(link);
 		return libbpf_err_ptr(fd);
@@ -13512,6 +13521,11 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
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
index d18fbcea7578..2bf514462045 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -453,5 +453,5 @@ LIBBPF_1.7.0 {
 		bpf_map__exclusive_program;
 		bpf_prog_assoc_struct_ops;
 		bpf_program__assoc_struct_ops;
-		btf__permute;
+		bpf_map__attach_struct_ops_opts;
 } LIBBPF_1.6.0;
-- 
2.43.0


