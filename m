Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9910ED72355
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18F96B0472; Fri, 23 Jan 2026 03:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAC16B0474; Fri, 23 Jan 2026 03:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19E06B0475; Fri, 23 Jan 2026 03:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE44B6B0472
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:59:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48BDBB904D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:59:12 +0000 (UTC)
X-FDA: 84362629344.16.C7BAD91
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5AFA7C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:59:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a7IIP/Es";
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLmLgIc/WysrcWe9//I7t11dZt4RG+riPvAd1pdlrBg=;
	b=xEZBS3p7B+L3MKtXOTOLYjFDfhOv9sJwWLpNQm5E6akRbZF+8EntatWyQ6WMrrmAEsaXe+
	ztaxOnovpjI8R7ywe9uBEUid7G0LygEbkix1okQPXnOO+cb+QFmNWvsUbPJprmbN4uH0cN
	WZhoG1TqlOZ9L3Gqyn4uWBsIMW6giP4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a7IIP/Es";
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158750; a=rsa-sha256;
	cv=none;
	b=MIMLzcZO52db2tmcuHN329AIBpAe/bPYQk8xEZb2gTSxZuv1E6PRtnqfXJRh02k9zvN3Z6
	zDGehkOp6rvvpNUmp7Pef7O0mwZbHVcVa39VIf/49814bORazD76l8ac2uSyiMfc0M5z0g
	AUzgDd0we5YpK+bA/rT/Ahu42K3iZHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uLmLgIc/WysrcWe9//I7t11dZt4RG+riPvAd1pdlrBg=;
	b=a7IIP/EsFUJnD3r7OnHIdd2/eiTbPkC3e6yHe7BggslKBJxB4oQ47RRY0b98uf/B/WTkxM
	OQmGL1/JCv/S9EGgOwUTCr3OVVhK/BTpgiHN8sZ8WSgXM0gPOvPGTUX26n9gi3LG9mgpSZ
	nAR6Ug/78D3j1Ymvcl56/aRR5+vBNjw=
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
Subject: [RFC PATCH bpf-next v3 07/12] libbpf: Support passing user-defined flags for struct_ops
Date: Fri, 23 Jan 2026 16:58:01 +0800
Message-ID: <006635a13eeae0fe8da56447bc5131f6a80a48bf.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5AFA7C0002
X-Stat-Signature: wfzgdsem8yqqbgmwkb6u68nyuh8a6s4w
X-Rspam-User: 
X-HE-Tag: 1769158750-49443
X-HE-Meta: U2FsdGVkX19TFmSsw2PIwdc0qWIzc+N1pSP78/hxj/eaHiOsigpi/aIGg5YRtkD3v7tuOvAljZWZTuRP5UNlrCPl8Grtxo5fPZB7ZOOy3DB965C3IkEZ7ea2OIvQjfxJj0vkoymhhRk4rd3qDoGtn4oaZr6Ai0/LziPqiju9biroLeBw+l+zaQ7BlDjj/ZIvscql6Kwp7QLBWbM+PbSiEA1AS0eyCBpR1ndiQl64Hoth52OCEuJw/LrYIsjiROqCyhkJskors+L/o38EJXbLMeAfUXA+6pM5HGL3/6eDLWR3BHeQFTxvEqsqErKD7byjra1m8O12NTCgZp0WAxNDZG3143OeHZhmRyT7CnzMRTu2gop/BCrL02MwmUcneL/YX3AmZhMgL7S7mRmnINaAoEph07QLRZuXb8yOuzT15N1yNfhmHCgsv/J3L38vF02xSxVKjkf9fMwTlM0BuXJt2T2vYYCmVJdWR66P6xtJI28dnNGYcA1pGbHkYjWOTh+/Pvi+v7XbbMYJk4GOsUfsH8Uk3dG9kTXRmHpTWhHHfbZpKfxzVz3YznW8VVG4gZbKofv7DxLo7HFloxMeJtshfhMcNK7yDhuXehoUThx0gI7ItXTrSa2WaNWfGZdGBN2eJofLowzRmGk8ErufNgm0a5Ze/ftwWMG0iJLMTGTYpdOJJl5R8IcjwAFB+gypUw2QHLMrxSarJ0sKZKTO21nA71JyNDSeGJP1m54i70UMJOY4joBY7w2aY8HryyKoQoV+Pi5LNmzWpWE+ZNfdxHYy1o+Y4nNr4tM7lWgWeAgXtDkc0YfFDjCJIxCAfOFkqRk0NlUitBZjYK9txTMSmFxECQznCHtK9N1r5jW32U+zKmYIcdk7/s31+ghZghQoux6+AbaF3PxuIMBweg/oxvwtu7A0LkqVlZ/gwEfBVW2X++T1io9e8akQG6fh0/z6iW5AZtSHioF0vEGFVq9i1iX
 8+mzxn9c
 JQFcsPju6GY5d4hdlMoInAqQIxUKSGB7AgMUU8UORfupCM1i03C+6TbH+T3gY+k0Dej9RfF6TUEp3OxTAnePK1Acst5B7+4GONSFdz1r5m9DW0FPit0A8aIQPLEIl1zFE0ao255HY/ZOEnxHa4hJRFczMuTuWW2NGTUsE0EtcVVpdrEV0GePkVT3A71B/P0txwdJ6mDRQwDX2l3gdcrASAHy06Bp7ezcDXklUUVI6hdvZF44wawiY/1bgnnXkUTh6lN5BMmfJvZqWquMlupIzGOkqdswz2nRGmWvGOkCMa0uEUh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Building on the previous change that added flags to the kernel's link
creation path, this patch exposes this functionality through libbpf.

The `bpf_struct_ops_opts` struct is extended with a `flags` member,
which is then passed to the `bpf_link_create` syscall within
`bpf_map__attach_struct_ops_opts`.

This enables userspace applications to pass flags, such as
`BPF_F_ALLOW_OVERRIDE`, when attaching struct_ops to cgroups,
providing more control over the attachment behavior in nested
hierarchies.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 tools/lib/bpf/libbpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 37eb4f96b28e..089bd1325468 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13508,6 +13508,7 @@ struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
 	}
 
 	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
+	link_opts.flags = OPTS_GET(opts, flags, 0);
 
 	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
-- 
2.43.0


