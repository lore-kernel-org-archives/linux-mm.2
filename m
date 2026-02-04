Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C769EE83EF7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266726B00A0; Wed,  4 Feb 2026 03:58:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E066B00A2; Wed,  4 Feb 2026 03:58:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D296B00A3; Wed,  4 Feb 2026 03:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 006406B00A0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:58:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4F628C3C5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:11 +0000 (UTC)
X-FDA: 84406172382.16.831E201
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id E12D6160006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mV3XNp/7";
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=OxsZk2OuYoIPfagUZ314oUBHJpVrYypM7jdxZ605oEQErhEDmhm51uWKe4mnxTmo4NYUgW
	AQ0PnOIu7pB1a1bjZ5ZzLpzrdRB0C2Zev46OBnuV+uLueESwNH5l0AcSF/ktSs+I1mh6i6
	UDFBRD5LLquBhWi5a8RfvXinNcn3SpY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mV3XNp/7";
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195490; a=rsa-sha256;
	cv=none;
	b=Pds022iX8G+6EiwIeBoY0PmqJAX6ZyyFobPk2s+XqdAT9wKS46Tr8PPO3AXgml1J3a5lvz
	nreZS31RWXqYpxoOS5vfBStBxMpyIXMU8SheWJhNGZ69rYA0ND9ovMoICXwhscmZFVFvjU
	vLd8W8o5gFZidCeEx6VXBBe+DeOKuuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOthmRQx1S9k8S+lynuRz8PEGmhPgopf4vkxZNGup6E=;
	b=mV3XNp/73bTVDtA9nTQzugSdDlG72262JLw+h4pV2qzdM4DgjA/yBGClRKkVprrgxaQ1Sw
	7JeS7rsWaPNRPzIj8reSrlzFsZ22dzA9SpkP4Lg42lRkGDImXnDj9Y4VrKO9coVXlldD9G
	ZzK8mNhu6T0VeQozaTgcLOVvCMUz8C4=
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
Subject: [RFC PATCH bpf-next v6 05/12] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Wed,  4 Feb 2026 16:56:26 +0800
Message-ID: <8b9d7d9485c627dc05cdeb6863abd5a1c81c95ec.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f3o1qat4tqmhwnha1oz194s1j4qjb44w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E12D6160006
X-HE-Tag: 1770195489-272319
X-HE-Meta: U2FsdGVkX19jY9zYf9VasJauU2eG1veI3/XazNhQYjDa/1PEzssADt1tjkoRPpnhmEZwaWACDNPh4jRVoq7uhL4bu56IocoauBQo9VMhniLb0KMhFZsTfBkbVu188ctbN0zcfVc9mzhp2giOOjoBCJ1SrBOL3yiiY8y8D158SwJX/0j9opf1RqbGKU+LLjz+VQeCZ8UykHqolOL1H/85WDHoFxnfNfIJDdZuPQWOXVII+8OPWgIm+uLYlMJCh0rQSI+2FSbN06QXZSxPEAmuBz3xUX/PoyIlTis0Srhti0fg0907th8zCI3kEu6i9lFkX1VgfMUTtGjHXZ4wj1kCRIr5Hulb9bWti9BvysE4LZq1Rb71AQj6orozhypIXEVhX4Hbi4d3Xonuw8CrzwVsEAD3/1hXDqWPbgGcsPxyGSvcUWid79qbOtka+CsFrwKQlra0dxoZmqLET0bZpaVm/OVH+snMqzdLgpw0tNprKDUlaXrkiK9Y8Um0Fjj7eb5q4He3rACME0ShFB6vD/eb3InyM0BJ63DdqTvwaP8/KSuvG1AoL3B1JUnQFjWYfZIVdFnltyIidvewYxw25rHcTh2oHlkJ6q8az3H0ke/c+iJEmwFD5CMzHh34o3jIBoMOddodOiJgQSVIKnc/3ETlt2P+TOf1WWIVkkRa/jgv1EwibvIclOcvzJNg9A9Me8LY9o2N8jTFS9VnGZeeBhEO4x3bO2h83lP+xy8ukx8kAPkqHrmWSbuEbqIspSF5pqZd89JdjMieOWtPhpeEALyDk6IO2ATaG8dKtCcjfrqYyyjoAeskw27ankGjLJ8XV5zuyzM7WFAb2DwSY2OxPwN8pqefgWTmJ0MNyqVD/rDmK1t4u/IrHVPvWdcbf0OGikCqSQrMOCXBPAEXJDV9G+6vvyLEdIgnJAaGKnylru9QTqfRo9DcfonM3Qh84EaMEgzi2S7fLkQttZmo5dfCCcL
 UIFtY8wX
 jy1OB2tp6o4jDA897p+q693Tl4nvLSMxLFiiOkoDwkwuW+Arnm4wBGIQQ13lCKDFyqEmhQ8xiTYGW9YYcsIR+HPi4DtS/x4OFZL42HmzNt9htpRumoq7OYISL5j9b4Twh5E1ma4I2hbdlJaZ24xnEP6Z/IRy/eZuhC4r0mHjjd+2De0PHyPzuZnnzG7NlONpGHz3gSO1znhfHtA6VpXFMr3zoKkG17Ms0LUx42VswTvAYNFOttR3hWPbDPdV5w6xxftM0gYEFnKz7R2VC0nerV4+Eaw==
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


