Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1F0E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDF66B00A4; Wed,  4 Feb 2026 04:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A756B00A6; Wed,  4 Feb 2026 04:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CDD6B00A7; Wed,  4 Feb 2026 04:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25CC76B00A4
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:00:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA2F45A1E0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:00:46 +0000 (UTC)
X-FDA: 84406178892.24.1EEF201
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1BE0A12000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:00:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rsU4nWb7;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=AYJpf2QDnhaOCW7ofdNxQdyvwncEH5VHUnl80j8kV/Z1OHsId7P3bA/JgS7910hXquxvfH
	X5tMXFYFXSJLH8akGYblAW8okHYFc4D7RXYsCFYtP3uRgQHS1MkNbXadfwwtoRs+chQMHy
	wdPXNDZ1tBMVVtpCx9Mj/mTwKbi3UpA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rsU4nWb7;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195645; a=rsa-sha256;
	cv=none;
	b=56mDWxBNpP7TGWS1/s6h+NWLvHKe35XF1Kyhs5LxNJjFyHFgs2CTkZ/XG6f5ZnjDdwgzl4
	zEg8xJdxP/AuH7JjM1gy1laOjPmZJPi0E42/m+X/N+7Iqqou/IhCmd0OC7u6klDttBIQKW
	AclaXQw0cqE16Q/zZLVav6erSZqbuu0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=rsU4nWb7WJ8rYospxU0vNqr3LLdJyM/YNdPohzbJxDWOBLrJ/szm5aeVmgcq2S3C4ITKXL
	Ax2iSO3sWa/rRry4nXzQQ/VHmoSq2v/BGNPDG0gwX4i2hzWflMUCGYw+W4z8EhpGOp+8Kx
	6aTRyHlevDOSD1t4CgRo5ymJU2OHQrM=
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
Subject: [RFC PATCH bpf-next v6 07/12] libbpf: Support passing user-defined flags for struct_ops
Date: Wed,  4 Feb 2026 17:00:03 +0800
Message-ID: <ba2cd1640447097cece1560dd7183bc3db39c57a.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: cjp5bd4ge7cp7eis4uzw1nt5swn3bfxc
X-Rspamd-Queue-Id: 1BE0A12000A
X-Rspam-User: 
X-HE-Tag: 1770195644-357974
X-HE-Meta: U2FsdGVkX1+qTSPKCBCZMKxcLZ/JgyrhwD3CstWq0NIBGp02r0s2rTVMuYKTQXirwHytEY1N7EfOH3upxkUlOlJNBgYZmJNxEJ/qiPfpvn3wKHzapm0h6DmV8XULcIT5xSncsQk8b1abr/cpUgZZw8vOWncoHGzk9TZCvO445mFy104l6LNMFe6XWeasyRLQ/TXifWmRvagtilH3FPOWnQsBg0uEx+YVaW9gI7Q7b67VJsoHeXdOtHSua+hOSHNUZBcEd2ND9fu7fkrNVs6U6bGpa0La9VJL8TAuz4vdbneqBJNLBEBrIf0Ee7uM4MfQfaKq0Un6gOOzsnEiT1OpwE3L1GR3Vo5qTj9MO1t8aX8bqf6lxUOUISmKPDKCvhSoxpElV3FpDgJ4nG2gMIOHCPfdITmVQJDaqT5wy/Zkg2/JQ7wRABB7ZIejW0/cUKhaEnbK7J2+i9IPcPRsVzY3nO3vWx+Zrh5IV5djPiOCtkZnGxWBTikbF3bpZ6YZ7JAlJJXVXNiXVts+DGaJFtrOnZM8QpME8i1EV/Zl8JtBCinrsAKvkXVChzfFRGbEJsugpgs5/KuV46HB6KS33MiDUnhq6qmrsQ+79YRDx+zdZoJG7ws10q/E3x4MIbak6+g4DVyYUZLTfyVPWIFqY29cKfjW8GEEr2h4/MlckGgWRNw1LYsS/pD1e6HSvrbkEQ9SyJpch9zCMtuamwalDINwUcsQLA8evRkb6315doLYGmcL5iEAsWaxH+2TUOLtP1bPlfxTNjsYXAmasqqQnJiPTGjkbvibarqFeb/ncIfuxNn70+JTUhQE61oOqyjBiMZvHGtNjpSRzJhRz0P4BCnwPNhpNl2Tj2x6BE3pKgeVYRGhuq2sKUHLwJXUwSXMxg5AIr8fWnvmAhm/ZeCTxy3Ch/fyuxkn8JoYmcWAQX1MCgtu9vgj7uszsYV9DmwE4liRP8OVMmDKVMAG4pO1heC
 8spZ19UJ
 aZcB/xw8b3NAKjhevgg9FFAj10pHrqz34ac+ohlXfrn7VV/edd/QMEXKjUpw1LiR2YUiaWFs5eJ4GVbqfZFiV61Ie0a0E48rdaUl61ATQunI/+A5nb7hz+Y2tAAOtMaFL682D9v3fdWB/6R5AwQyqSxR15Q8qeaAS4/f9RICDL5i61ROHAMAVflGpZZklNgzi8vSPBlbjjiWEyliJviB/UVkK5K4rAu+6lAHlNK27Enpfp2x0+bo3aWHTf7uh4GOCO5+bG7PLm3OyaNL6iJ4m8UDeynRThO13IaAP+M3ZGCYBR5Y=
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


