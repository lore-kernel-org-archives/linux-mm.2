Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB7AD2D8C9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA8D6B0089; Tue, 27 Jan 2026 04:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294896B0096; Tue, 27 Jan 2026 04:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D946B0098; Tue, 27 Jan 2026 04:44:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D14A6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:44:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9740140B29
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:44:19 +0000 (UTC)
X-FDA: 84377258238.06.CC78543
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BE5DC0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:44:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=czTeJJpy;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=i5JNL4tEpP7sAZQM3bV/P3b0bdE5JFNm2sEGWdsrxTeG2gfOqWpWhPjoVUOipNkswQQ3uX
	PE7toDr7vzHtZkGdzvvdY5xXUSoS564L8X7/kBGD4/w9n0ozK6vqK1U/lhtni24futXx38
	nEmELn2MoEWd5ATcGaiM5rSvz4kAVmg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=czTeJJpy;
	spf=pass (imf22.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507058; a=rsa-sha256;
	cv=none;
	b=v49fmSF9UitNlOsBKwCQtJJLByVxKv4hmWFgI2HW4rMqhWIrInNW6c9+ttU5HxzAkUUxsC
	jyrMkUOFQ56CMWOKx6g7M6n/ZiDx7EUW9gogGLX85CNvghtq8IEny40p81k6xUkKZXEOel
	1sne5Avc3B9WI98AT0me5VRG6vO6vWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=czTeJJpyv2okdcCiyzy152EVyslqIqInTXlSCpdBL+Ji64e4WZostd/vUnqvbh34LRNCGw
	yQwVnul1ze0+FrDsiegO0TmgTEDAMS8+i05KcRILZlHoRpR7NbsTo+61aPQwJ0OMIQbKZk
	Efh/gHG+N5wYHpYLmwdCCpSA3ukuqA0=
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
Subject: [RFC PATCH bpf-next v5 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Tue, 27 Jan 2026 17:42:42 +0800
Message-ID: <635923ceadf1899672e4f7727ddc52554c11a3ac.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BE5DC0005
X-Stat-Signature: bnzcsbr5mw3chph6kqe4o13795tgg1od
X-Rspam-User: 
X-HE-Tag: 1769507057-140371
X-HE-Meta: U2FsdGVkX198Zt1kCbYipZe0DnGKgPPCXXndpfHgiHnqCsLpgvbLFxH0ASUs9oy7yoTbH514nF3zfmx3Wp9EaZc/8/dVMilr+i1h44VIGcJFNyyWju0byq1N9ui5Ht5VoP4OkglFtdqdRQjUT/AqmGSzP6fDMA3NSPHiCpGBVYkgexxhKOAxIySMtE7B4xtlxiKL12X/46IKLg7qj2twMLxJXs86EJW3MShXU7hiHsbaaKCQusssn/Cg+Bt2MTz3P4OmnTAXFg+54sID42hnXr4ZZHcRJ3cJsX557HODETh6G7DwipDzNajCS/q3VN2J9rRNPAfwZ2XcLpw0Fl0Y4PF/Z/J1RTm+3sSlc+nZQdKcv3CsOPcfh+PE57guq0kw4CbpNnKEUKLvnOZYcXsyfXukGAwqcB/VB8KxoqiFqPbhsjBhnMuiKisKg5Yq7hcFpPac6F84XnMONpP1gpy0RuqEpmPHtni5X+uzAgr9BPuuXlIrMDjNuPIDFNKX0p3c5BQKSTS3t9ToCNsRs3KU8Psxz04pVpdv5M4NtJy0s//RYDd7AsFjDAWShct1CCOI11OmKPtGbsOjhyQxmYq45xL82RRnD15YJN87xDwD8t6nlmrRubC7viUdX3MEkKi+mALY+Vyxq91l0bX5R0BZYkB2ORDYnYeROfm+JumjWmZ8IbYXHQORLkqQwUvJe7W3xa1CnocNEUAkFER02Y3BJdRwCemSB6hR6Yv2DBFQ6OeFnvbijZcVaNTGLVyqiG8zWtqvC602JA5zE1vRTMGwuwzRiqDRopnWwne0fSlvhpVutUnwm9OM+buSFYqUDsa/oZJ/+CutUFP0iFhMwILgCu0CC0ULDsP7alfnhfgAFUnUKBjEVlWb9Kinw9OEUFgamgyZV6SuWKR+q8MBYXzN0qOUnaVC7GIFCNlH9E8zaRsdNW+2/h2LSrP6NoZAmBznUfoz7zawbssL+DzIMVl
 S9ssKuYo
 VGxP85m4ytErzOLU9VqVQjLFtUVWOHmFhzGaorL2/D55oH36CQwt5Jj0r1FOufc2S1Se29w7s50E+L63fKbHFquDqjOO6HiOWWvs8bHBh7Rg2KtWerEMIFw5DE6Wj/s8W4S9kNn8jFIMnZhmh2MFMXwevZE7oQi4z7swB0CqxpCoE2HdyBnNWTCv/nwaFhh217MohO7fdOU8ORrm7AjIMNhBcDHKxNgbRB36Q2ETyrOMwRIoOQPBBPQvuHddjVjhYjMZ3hARGoeC4wqg/6uULVQ2h4Q==
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


