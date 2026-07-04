Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E554C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 05:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766956B00B5; Sat,  4 Jul 2026 01:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716F96B00B6; Sat,  4 Jul 2026 01:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630266B00B7; Sat,  4 Jul 2026 01:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 268616B00B5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 01:39:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3D3BA0420
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:39:03 +0000 (UTC)
X-FDA: 84949990566.28.B1B3535
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1105B40003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:39:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5zChWYG;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783143542;
	b=JQOyObPWBp4rb7dTgpnXgmpCxSBzkFnM89YZyP/DLv+Vmt18pC/vE9JWH4P+e+y//RE8gJ
	jk4bqaDFpBWP+JfA50OLWFMVbMa9oFyne1wMThCPe79RykvG6ddTtCATUe90BfpHUpMvTk
	rwD4AOtH5Dh5vADpnJf89dobbji1yBs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5zChWYG;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783143542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Omav1PnVWAaMZoG6fUApE0dlp68yQBo+33N50QCsh9c=;
	b=icJiRcMcxTkDBc6DV9QMBcYFw5HgKNAAIudQpLzyljN62Gn9mYXN6DZVC/TwIu24E8/CCe
	vsRayWO06vevd9uP8GY2KBDPNQq9nRzq/Fg0LG3duNkTuwtFm/YdQewvKuvZyEZEoA3duu
	OjgCG8ut84rV93gipFzgPvVqINzy8dU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD103437A1;
	Sat,  4 Jul 2026 05:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673E01F000E9;
	Sat,  4 Jul 2026 05:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783143540;
	bh=Omav1PnVWAaMZoG6fUApE0dlp68yQBo+33N50QCsh9c=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Z5zChWYGLr0SHmTjjiqBGh0M7SlqKkNtKKOqVR/nPEaLT9OlNTAKFffZ1Ozyos581
	 ckbpJTAddK521RhDoYRpoHgCkrGEcpRK1P+h84zhGcDz/5sV2gRgFiI/hDzt5K1E7Z
	 2WyjJTpZKXoETEh/Y2NGhFK+vCDR7SECYQg0B7oLuLTVI8Pvt2AeO1Btf/l5A9hDBC
	 d6myTRAu7x1tu02MUEgvkfz8Gg91pFau2lx6smMw/8FtVw43BRDYHfzBt7Z4UER0SU
	 ldl0mwaGWX+SDxH924GS3hlG6e0Aqzqv8h3gHwfhVb6H2S03qDg0HgTIP4kipKjEel
	 qtlAcbvCR494w==
Content-Type: multipart/mixed; boundary="===============0892255960102653600=="
MIME-Version: 1.0
Message-Id: <020c0e385f57d0b2dcdad92ae1ba2f411ec854dd9fb0f0eb4b4a618538b1c983@mail.kernel.org>
In-Reply-To: <20260704045617.487664-3-ziyang.meme@gmail.com>
References: <20260704045617.487664-3-ziyang.meme@gmail.com>
Subject: Re: [PATCH 2/3] selftests/bpf: add memcg_stat_churn BPF-vs-memory.stat benchmark under churn
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,kernel-team@meta.com,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat,  4 Jul 2026 05:39:00 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1105B40003
X-Stat-Signature: r5gduczfbr3qfzgqk6jyno9ekteeg61h
X-HE-Tag: 1783143541-623445
X-HE-Meta: U2FsdGVkX18DEFgxcPzxC5XtjSWYFlaXLcV5hdMkq2xxjxpKKMujZ4zvd6VilXnPDw0LeQ3tJosTDtUQKbuTow2uiLGjnUaI5J+EiZGgnLoS7iwMVv3vRXHX/ayiPyW/LeWYGMLEAd/NeU40Ykw0utPRQypu6dopb4+e7TQPV4TYbD9ilZhOTtKrk6DKlBOSK23fY6Cz3e2dFQiGSNZSDxn5CcI1qU1JSbmiUTXCH6UMAayw7YMI5Rz3AgS0E3CkbLmnl2uWKrdBXEidkHarMiQRz9F69j5s5QGUPK3tNhLVyMruUsjuV7Poc8vjt0o1Vma+vo9zIOlh0ZWhPAmXvXis2XCjgaXVKNPA3rfA2TOvhCrq/B4M2MNkgB6UO5IWpwT1UB6YhD49KeAtob6SXxLY1D+nCAhPeJi8HA3O4IUb1VZ+CZPowgql41g+vaS+Xndcflx9Jss4yESocjRHRX2l3ztXAf49PhUcrbqhAXrD1D1pXehUyDmdDvjXVhtoJ8VhT+ScEdks4QZ6C0w+1aljnWktyx/8KlmCe4i6raNeCV6JBrV6TEtEe+97LOoDE9v09UL67UNZDm+VZzwJbzDklhDIUV2MUBylLYIG/1+A8vU6C71l5Oy63R2rB/WR49qrBwJVCrgdzR3VUaQreGbAsMqrCVlgnAt82uYRedH4xf0EGKRKQvRtM1vkmLZO7Z5wdnIReQd3YG/Ix5ZD8hndUlmjxMbcMj7VzjjK4D2uA/a0cutyRZfegvP8S3hSB4g65Hk3hEEVxQk2fjjSuO+NkACD1FYZGsLvQl80rbh6teaRdNDUCwwGamC45PfaNGEzTGhG7bE2KhJ/cbeJqYCz1GvB9WN6YIh0ta8vgGfMiL0hL6za48rgo9EYhqNFP2l2CRHaD5fg191d6G59adOh9dAd0k3mLIVzHhC5Vclb32GgKqpFaVeobSjtRgn7psoe4G5xzyDPW+w8XOm
 nZXgzGAg
 EbAMRYpr1Amp1DFfRSAIfQW72nU2n473qvn1t5Dja+/6KLKQ8Cib25SOJTaK7ywK615Vjw7IRUqjicR/LQ62hMpzaXsdiI0I47j2btwBXGm9GUypkIml4pJRyoeIPVFXxUe71bd+b11EzTQqYNxmwSix/2bikoQjqbEdN7WXrQRPNyvCzQbNWpdnGNorVfSrR1LYgMaIC9pnpEdFNS0cZa9MPVVtlaPJat7NYJyteo0xfAP0I4LrRoDOg6D48c5X8g7eSJJ9XXSUtD2Y7PdOebLRda+Ne/iCb14gk3omNswKReJCF5nYAkFz7veRmyBjB8td/ejOJYtW3goVLwFVS23xwTGWuJvhUeDpEh9M6pFLc9mumzUjQNfYR8zrNNw7CNthaIy0OpJlXod+d9hf9K3af6D9MJ0iD8VvENwXQnPRymSiMOEBlZxC9Hp/kDr/mPCshNapavLOFl2hvx+WJbcbxCSBLo2S5xAPdZxhb8HM1UWR3bkobPVu9pXP8mdelCefxvjpUmM6BZGdOhw4DIQwOKWLRyLKXt49h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0892255960102653600==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c
> new file mode 100644
> index 000000000000..3e386d0b4c03
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn.c

[ ... ]

> +static long long now_ns(void)
> +{
> +	struct timespec t;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &t);
> +	return (long long)t.tv_sec * 1000000000LL + t.tv_nsec;
> +}
> +
> +/* ---- tree construction (same shape as memcg_stat_reader) --------------- */
> +
> +static struct cg_node *nodes;
> +static int n_nodes;
> +static int n_leaves;
> +
> +static int add_node(const char *rel, bool is_leaf, int *keep_fd)
> +{
> +	int fd;
> +
> +	fd = create_and_get_cgroup(rel);
> +	if (fd < 0)
> +		return -1;
> +	if (keep_fd)
> +		*keep_fd = fd;
> +	else
> +		close(fd);
> +
> +	strncpy(nodes[n_nodes].rel, rel, sizeof(nodes[n_nodes].rel) - 1);
> +	nodes[n_nodes].rel[sizeof(nodes[n_nodes].rel) - 1] = '\0';
> +	nodes[n_nodes].id = get_cgroup_id(rel);
> +	nodes[n_nodes].is_leaf = is_leaf;
> +	if (is_leaf)
> +		n_leaves++;
> +	n_nodes++;
> +	return 0;
> +}
> +
> +/* Recursively create children of @rel. @rel must already exist and be recorded. */
> +static int build_children(const char *rel, int fanout, int depth)
> +{
> +	char child[128];
> +	int i;
> +
> +	if (depth == 0)
> +		return 0;
> +
> +	/* Enable memory on this interior node so its children get a memcg. */
> +	if (enable_controllers(rel, "memory"))
> +		return -1;
> +
> +	for (i = 0; i < fanout; i++) {
> +		snprintf(child, sizeof(child), "%s/c%d", rel, i);
> +		if (add_node(child, depth == 1, NULL))
> +			return -1;
> +		if (build_children(child, fanout, depth - 1))
> +			return -1;
> +	}
> +	return 0;
> +}
> +
> +static size_t tree_capacity(int fanout, int depth)
> +{
> +	size_t total = 1, level = 1;
> +	int d;
> +
> +	for (d = 0; d < depth; d++) {
> +		level *= fanout;
> +		total += level;
> +	}
> +	return total;
> +}
> +
> +static int build_tree(int fanout, int depth, int *root_fd)
> +{
> +	n_nodes = 0;
> +	n_leaves = 0;
> +	nodes = calloc(tree_capacity(fanout, depth), sizeof(*nodes));
> +	if (!nodes)
> +		return -1;
> +
> +	if (add_node(SUBTREE_ROOT, depth == 0, root_fd))
> +		return -1;
> +	return build_children(SUBTREE_ROOT, fanout, depth);
> +}

[ ... ]

> +static void parse_stat(char *buf, struct file_snap *o)
> +{
> +	char *save, *line;
> +
> +	for (line = strtok_r(buf, "\n", &save); line;
> +	     line = strtok_r(NULL, "\n", &save)) {
> +		unsigned long long val;
> +		char name[64];
> +
> +		if (sscanf(line, "%63s %llu", name, &val) != 2)
> +			continue;
> +		o->full_sum += val;
> +		o->full_fields++;
> +		if (!strcmp(name, "anon"))
> +			o->anon = val;
> +		else if (!strcmp(name, "file"))
> +			o->file = val;
> +		else if (!strcmp(name, "shmem"))
> +			o->shmem = val;
> +		else if (!strcmp(name, "file_mapped"))
> +			o->file_mapped = val;
> +		else if (!strcmp(name, "pgfault"))
> +			o->pgfault = val;
> +	}
> +}
> +
> +static int file_read_node(const char *rel, struct file_snap *o)
> +{
> +	char buf[8192];
> +
> +	memset(o, 0, sizeof(*o));
> +
> +	if (read_cgroup_file(rel, "memory.stat", buf, sizeof(buf)))
> +		return -1;
> +	parse_stat(buf, o);
> +
> +	if (!read_cgroup_file(rel, "memory.current", buf, sizeof(buf)))
> +		o->current = strtoull(buf, NULL, 10);
> +	if (!read_cgroup_file(rel, "memory.max", buf, sizeof(buf))) {
> +		if (!strncmp(buf, "max", 3))
> +			o->max_is_max = true;
> +		else
> +			o->max = strtoull(buf, NULL, 10);
> +	}
> +	return 0;
> +}

[ ... ]

> +static int drain_map(int mfd, struct memcg_stat_snapshot *out, int max)
> +{
> +	__u64 key = 0, next;
> +	int n = 0, err;
> +
> +	err = bpf_map_get_next_key(mfd, NULL, &next);
> +	while (err == 0) {
> +		if (n < max && !bpf_map_lookup_elem(mfd, &next, &out[n])) {
> +			sink += out[n].anon + out[n].full_sum;
> +			n++;
> +		}
> +		key = next;
> +		err = bpf_map_get_next_key(mfd, &key, &next);
> +	}
> +	return n;
> +}

[ ... ]

> +static bool memcg_kfuncs_available(void)
> +{
> +	struct btf *btf;
> +	bool ok;
> +
> +	btf = btf__load_vmlinux_btf();
> +	if (!btf)
> +		return false;
> +	ok = btf__find_by_name_kind(btf, "bpf_get_mem_cgroup", BTF_KIND_FUNC) > 0;
> +	btf__free(btf);
> +	return ok;
> +}

This isn't a bug, but several of these helpers appear nearly identical
to the ones in prog_tests/memcg_stat_reader.c -- tree_capacity(),
build_tree(), add_node(), build_children(), drain_map(), bpf_walk_once(),
file_read_node(), parse_stat(), now_ns(), and memcg_kfuncs_available().

The commit message notes the BPF program, map, and snapshot struct are
reused, but the userspace tree-construction and file-reader helpers are
duplicated rather than shared. Could the common pieces move into a small
shared header so the two tests don't drift apart over time?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28695985027
--===============0892255960102653600==--

