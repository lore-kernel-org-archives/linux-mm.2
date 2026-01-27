Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9C2D2D8D8
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BED66B009D; Tue, 27 Jan 2026 04:46:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A98B6B009F; Tue, 27 Jan 2026 04:46:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC9A6B00A0; Tue, 27 Jan 2026 04:46:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9E86B009D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:46:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1095140B2E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:46:36 +0000 (UTC)
X-FDA: 84377263992.01.F581E51
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2C5B7120003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:46:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GybHeuHi;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=Z4YHFUTeZ3xAjPYBarRKIyEOhRlfva00WlVxrjGlySXB557A42VaRFhxu+tkJWnMmlHCIB
	3ZIKh6PZfRXhRae6Wn2LQpO/Nd1fiECaDktYgDeZePPmo1LLxb5YUeqdD13c/+YRoZ4FXs
	yJAA6Q6RDL56SaJApnCkx4slnzKYKTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507195; a=rsa-sha256;
	cv=none;
	b=z5slnZGRHL4CbseSP3vhAZSOkdzmGdghQopW5zSx6C56idCZNLsE9xLBOzx+t6GlCdETJK
	lcL4HWx0NwGG7vlIdFutTBAAx/0r2lUOSatc5MSjqyzEjnMkRDE9ObGDgle5Lft652eMDP
	2YR+53YBAEkAsUa+jkbMhdDlJap21Bk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GybHeuHi;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=GybHeuHiFgFrkJ7AI5shcktmPnd9xH64DeeRqlQBhSV0NblYrsh06r9lIa9PvDUqRdVvH8
	G3IBrJjSqgSsbon2DrgvqkcEKLa3thyT+3AQ0GiRVk7tXtDpinuyKvLRIKacq4yEPFwPrZ
	d2++W8afsihpFC/CQhgMyILVg9H3cic=
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
Subject: [RFC PATCH bpf-next v5 07/12] libbpf: Support passing user-defined flags for struct_ops
Date: Tue, 27 Jan 2026 17:45:51 +0800
Message-ID: <63d543aec9ade803afcd95461e3089e3d44caca6.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2C5B7120003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kzqgipbexr89ja73xpkdp5cgxwmcjt39
X-HE-Tag: 1769507194-26713
X-HE-Meta: U2FsdGVkX1943ERgZbGECbkzgrwcHlBEoylIgwePP0ctErJNghu3ic/WhNDRnaE11Ud7ct11TFS5G5blwRrLX5DBYdrcaQEhAZxKAfs0phrLLVP4IbS2b/OIMLnPDI9g1omKwmP7Ag8WJQ3Xyi+t9gntgLkvmcbPacivW+Ukhv0B4JfDAueNmdo2WZURjz1ByyRk7zwCp5EgxQRXVi98W5bqjgXYeJlgdZOuly5ZNX647D81xH3nEZjJPr3bIYiF6cflaQp1kpAr3TTy8X1QVcL7HyqtcL2MmuSlkYxmSXCL9D8P2ZrnQz/BiyhP1PEZsYOKxmXDI5ua7SRl3ml9lM320iwv4RzZtznuNijBP0LCN1eo6UBqHWWCa+z7p9cB5YF0l+i2C7yUFs1TZvLJNFG8siS/yHovIxuJuMqLq9IrkSnyGoY7uEzMYXefU3oVX90VAIVQe0jtOqeMpsuJCm/0GgNQX3ejoGRC4fHW0nO5XnEGEOa1KSMcF5mrkZvCoTa0zZON8O/UW/FonMlUUi+aj8/F0MX1w/Mana98YwwkhSGq8GR4axyEXl6j0mZA4Vaj40e3zKz1bq75XbcwiEbYzUgiXkx0R/6VTsPZhpll21tgy3zLIsh8HHIDAxMoqXzQuhtJ4cRy/HXsPHznrJD+jP8Uj5MIuMm8t//hQZG7ZGIltvIq3KP7scEn0sdpnk5h3WJuvgclrlGWieYFvio7fUElj5Vlih6tIy9Y2Lz2B/S0i27LA06lfq6ot0q8GCrMNyULpLxDwB9ATU8jQhrXb1kaxdO3GOKurNInOANLmWiUugBntNAJB9knwwFub8N+oKgToDMGNkC/jtL6PPzh44ZpnuqCLi5aeOMZ+VotXyXxCnp3CFon8MfZVIs3Dulgf7SIh/oo7CveJFxGTlEPJxK1gMPzIoPeSSsy3iyOgNKSRw1t6XhwCoNBgwMFeIT30s2tdGPVZddvtnr
 76kycUSo
 zfbGP+woDwU22meI=
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
index 70a00da54ff5..06c936bad211 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13511,6 +13511,7 @@ struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
 	}
 
 	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
+	link_opts.flags = OPTS_GET(opts, flags, 0);
 
 	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);
 	if (fd < 0) {
-- 
2.43.0


