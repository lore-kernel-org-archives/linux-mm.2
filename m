Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3EFCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139E5800B8; Mon, 27 Oct 2025 19:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EACA8009B; Mon, 27 Oct 2025 19:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A8D800B8; Mon, 27 Oct 2025 19:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DD0BE8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BDCB87863
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:45 +0000 (UTC)
X-FDA: 84045471090.02.57EF587
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id B5B93100012
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E2R/gY6d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AWwjc0UoLvD3R3stojTytlItHxwa9yZiXLoT7TlRbg=;
	b=uWHK2kOnJ2Fa18U2bZHninikgx9+appjJiV/epToKgYq1KPq5gMeVl7BdrlwKoUd1+LfNw
	3GxpKIWOIH3L+p/G20p4H0gd3gDOGActP0Vt0yrgVSzUxUqctjl5r3IlURblpHwNe06bd1
	x5ODcIdoEWAMbis34buSXCiCoO9j/BU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607364; a=rsa-sha256;
	cv=none;
	b=Q8CjnqFrgAWb124RjufjPJsLptm/4zLrD+zFIj+If4JTTKaI4kL827i3lbDPpo9oMNFKm4
	Wv08J9t5e20JgaLB3zcVSOVCcV64H49Jf+dTYREC9PmtlSJyIDhFMwZh5QinQ77z2td8WH
	jkRsuj6cRyAWpi0Miw48jLcfveZYNB0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="E2R/gY6d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3AWwjc0UoLvD3R3stojTytlItHxwa9yZiXLoT7TlRbg=;
	b=E2R/gY6dpHc7tWdh2+SxrYb70jSrc+m4mTkzm8fiv+R208YyNOi5toAkZJW+XpSTdsRMWG
	CxfajUVb7/hMGhEZW+K68iAgYHlMVmvljO29+sOcgPtnnkNVwvK8Y5EVxdZ2tjl1QNwByj
	5Ilr9Kh1kpumgiJSwtKp99IyxtK+EJI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 16/23] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Mon, 27 Oct 2025 16:21:59 -0700
Message-ID: <20251027232206.473085-6-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B5B93100012
X-Rspamd-Server: rspam02
X-Stat-Signature: fapcgg4wwggbna6636ncs1r37ptosmdo
X-HE-Tag: 1761607363-365325
X-HE-Meta: U2FsdGVkX1+zu81lWJeZF95kPWliwQHky7bf9rTvGMa3KRU31fgb5jhevd82G4Iv4O8iynkzoiJ5obizr0Cx1Opa5moBKFvrwG8vM/G93PJxSsmUGQFAB+m3vma3Hz4u8sEr8Htct+0iHwbIG2BujhWwwa08Et6NhdJilwsGS78zQiznvVzmCkEiAmubx8ZFrRgfF8aI9fbk658zX5/EMV5HyeMAT1TTwpPGqWvxJ/AntzZVp/RRpwrzfNbhEN9ZlTpXE8CuKeIBEIax7ICkrBUJxrTIsqHPkI5wfgdKWl40IpKdM0Rg5JwsS1dRKZpy4qFOiagx0kf/9akZnVQeCRJysQd2o4aGnPPA/nYT6EAtIl/sgjUTOy658gcHNo7r7iri1HO+TBrkxqqADT0fTYySnD40ZVHtLzEUv5cStKu8QcJJX4U1qB0bn25X3GFcCZVroOwKtyBMyjS8iy0Zt+R14BJWqKQnaVST4oN+ORcEDxHayjupW1donlVLj+HWCCgAXXs3zbPXY/DD3HbxEiozCu3e8CNQwXE5FqY6VyUweYqzzmRUhy+g1ShamKbMI1eZ/VUc+P+obZ1YhUehHyGuPPpLcC4GuzGI+vWKLB4mzXGUggL9rAgQWHYC1cUBdDO9TWhC5By9nim+adGndOAJvqSwu78psX7NCYH1aELGrRxvb6CrBJ+RjlH9nhv5u72S4rHhTO8nOt/7cUkHyFEpbqBEbFXRfb63hdzBVti+t8qncuP6J4otjn7Z7ibYTGY+gh3Y05JO3tlglP+HmdWevvB6nsohyEK0nezmm7sICyJUhXD74LxbpIXScIGLAWPn6f0hqzrf+qMnuUg/k12wSVQdcIYnikBEXKf+cCGVSmrB8aPDkOtWl9NRJu0Dv7cVRcomqN3io4Kf/o5p8Yv00STKaEENeXukCF44EerZksFNCL68ED2JntnyXSXhsE3ozHmc64m0CfLHuRE
 IPqQqm7h
 JjD+LkUhXVSF8hNhZ3v6Bpzu6/EAYq+iwScEM0UHOjzmopEbI2nQFLIuo3Erm1EASZsrm+M+7DgfdZJJscXnCf9yPxbQjQvbbZf0+/RGDMZjGJSEJoCpikaPM8llJPz+VcJg4qvjuxprZxyOK7oD+dzbptrjlPsEidcs5oBqhhOIR5B9qT5YHG832va59i5yfoLEvG1jzl9EY/CbRLZUHZ1PJifcqEkE8D/eIq8iuyIYfRECd+/zxAHTcpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 339b19797237..4c8944f8d6ba 100644
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
index b90574f39d1c..be56a5dee505 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13196,12 +13196,19 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
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
@@ -13237,7 +13244,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 		return &link->link;
 	}
 
-	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
+	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
+
+	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
 		free(link);
 		return libbpf_err_ptr(fd);
@@ -13249,6 +13258,11 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
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
index 5118d0a90e24..dc84898715cf 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -922,6 +922,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
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
index 8ed8749907d4..bc00089343ce 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -451,4 +451,5 @@ LIBBPF_1.7.0 {
 	global:
 		bpf_map__set_exclusive_program;
 		bpf_map__exclusive_program;
+		bpf_map__attach_struct_ops_opts;
 } LIBBPF_1.6.0;
-- 
2.51.0


