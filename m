Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD8BD25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06A16B0092; Mon, 26 Jan 2026 21:44:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07CF6B0093; Mon, 26 Jan 2026 21:44:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10A56B0095; Mon, 26 Jan 2026 21:44:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29D06B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44C9FC23CE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:45 +0000 (UTC)
X-FDA: 84376200930.02.3E1C079
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 902F118000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BLsJjuWS;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7imLFfuAi3d5czpJBeftkB1+iXAr0ET28s+m3ASpKc=;
	b=wr/vUWd9WT/treI3GVP/x6YuvSK6I0QiW9r4D0z4cv/RtjAzJC5/thRk02UxQjjNp5j+2Z
	AoV8BuRO4x76clcG3kxFbhmgmycJVGTAIUAg9PXPb6bKDYZ1NL3v1pjU7nrDLX121EVEig
	a4uQFZEC98b/SAiw4hVjRtlPS6uH7ms=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BLsJjuWS;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481883; a=rsa-sha256;
	cv=none;
	b=aqcGeNr5ISXwrVqOsFhgV6EIQnoGgDgb9o7QJvGzbYv6BPZFN1sNfEII96iLcUPpUotnxT
	FuztUZOHViCPnkJ0NBRECruTwLwcb3ooT+88T8ea4pRDXZGxB2G3WBi8IS0of/usXydGWw
	Tah88WJkM0r2vsHM/G9PwgFtgzJhuSY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7imLFfuAi3d5czpJBeftkB1+iXAr0ET28s+m3ASpKc=;
	b=BLsJjuWSrZAeA6+hu7z9J776nYczyrnKh2sStU6XHulLXlX/4mCr3tPkIWnz4Bev2dSY7q
	MVdPnLFFN0qRD6fUNXdBBg51UgzC1fwhtd87EVu2w1eDN9FLHPeOjbnPkocJmyTBxbQEhV
	0g5pJ6sFZpF2weoyt2JxQtxOc/XQM68=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 04/17] libbpf: introduce bpf_map__attach_struct_ops_opts()
Date: Mon, 26 Jan 2026 18:44:07 -0800
Message-ID: <20260127024421.494929-5-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 902F118000D
X-Rspamd-Server: rspam07
X-Stat-Signature: nbrpstci1jrqirhca7af3awewcd45o9n
X-HE-Tag: 1769481883-833741
X-HE-Meta: U2FsdGVkX18/RL/XWS1K9VpLp3OxU728MtJ/NPwPv4FKsdc8C1eIM53qwbuAmvV1aFZ1NVLeQFjPHSijkMVOe9WCPhHcesWabzvIWx7VepXFzdXQF0uMdBxTsJ1NOav9vDkV6wA9q5heqVQ/YYJMuCfmQmTqYQpiEWNGAzIbL/YYJ0clewIrsTmBf4sV4ij9JO8esACd8seNgpRSaeBOKwgeDEyvGw0A2vW+mIL6jkF4E/DvcdnwTY47kqfFqnwjT+Bo85d/LDEBxqzMOrA5hzMKV8gFJUoK33pQjw5+9VrzpfXPPM3GF1wEGbor11Vtv5pptZNkL5y3YlY3fzpbH5Zb9viiPOHBAtPtFoDpqDCHh5cx7OuJDyZZxy8Awxh4p4T90QOS3qvlTqdZ0jT8sdKXw0lPH/9dsEAm2VxZzfj3LbdxBLS+Dt442cTFUOZlDLtc+r91cFaN3OzUQkCJnUfsbOE0FX24vZdrT9i6qAx6/ZMcSUTd8K1TJ0zDneomdpjdVNXGZ62cmQrM5nLfvdY1+bU891SMdGLrv2NhpPDabkwfPr/Pn6ppj25SjZBE9vaHdVynROY9aCjCzGnkC7WOP4c2syi1Psqxe38UvhLt1/0l7oB81GlXuIlYitjVWKBzD3cXIjen0soR1tX7P8L4IqYgf8TFV9FGr05+xgGA5IyG9uzJYTaMd0bHr3cslDBKUrGtYfHSnF6lfVq1xfgm+1OXTGKW+s4+dlJ/Mn6HLY7EGVSaKDlplyQImIJ/wkEyzWtfCrXZrzxbVi6PTWITElWuP0yPxnGfx+/UNtV+9jOZG+31h8/hlKF8/ov5CSVYw8qcpQaU30ObA5nu9WmNk6vY5lN0xuLzrEG27FgKvDtjb15h050aFVGEabpcYAaXX2aoDwgxA5FRA20iw5YuFgwg8x3jcwnzClL4k/5tT/KQN3LVenJVSf43Kj8sdDn0dvFOjdjWTQKPL5o
 nulVTuMv
 cyAwhS932pGu87n0PcRBNQBARoCyhR3Ei5Z1G3jczWo0x+UbFlakzS942LhrIi6A1O4mOa44fGd/5gPCFo6EvL5Mc/bEjx6GDZoU0KwUOXx77QSsHj8v0db7ieavYAU7AbtaLWlz+O9ZlI34d0GoLeDzitDRmji6qSvQ4YR4xAuQjDJ08bq3o9wUNDBt+AGGTEz+ZcVb9p5UrondKeBJ7xgixqd59RewitF5lMJXs4Q+wJmVVRDvnZPktIQ==
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

This allows to pass a target_fd argument and the BPF_F_CGROUP_FD flag
and attach the struct ops to a cgroup as a result.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/lib/bpf/libbpf.c   | 20 +++++++++++++++++---
 tools/lib/bpf/libbpf.h   | 14 ++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 46d2762f5993..9ba67089bf9d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13462,11 +13462,18 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
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
@@ -13503,7 +13510,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 		return &link->link;
 	}
 
-	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
+	link_opts.flags = OPTS_GET(opts, flags, 0);
+	target_fd = OPTS_GET(opts, target_fd, 0);
+	fd = bpf_link_create(map->fd, target_fd, BPF_STRUCT_OPS, &link_opts);
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
index dfc37a615578..2c28cf80e7fe 100644
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
2.52.0


