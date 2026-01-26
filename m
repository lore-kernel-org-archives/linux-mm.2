Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AED5C88E78
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31696B0095; Mon, 26 Jan 2026 04:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB7C6B0096; Mon, 26 Jan 2026 04:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3986B0098; Mon, 26 Jan 2026 04:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3626B0095
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:06:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 407F013B883
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:06:02 +0000 (UTC)
X-FDA: 84373532964.28.2CA7356
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 930FCA0008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:06:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhoZcECC;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=SeSxFaPPMCg1M9lz2Sy1XQbttcX8bSw2CRTXUsI4QWWpIGVX7JI1ySD8YQblZe06PeN3w5
	S65sSlGwq0pTxtqvL+saMD7X+aGA7wVr9z7iLZBWmo3uxWNxyZvdF2p8YNPSEO9eP/Xjq4
	dfifjYdYiDnPOyGtfysaok9rGQT+/GE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nhoZcECC;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418360; a=rsa-sha256;
	cv=none;
	b=fLchuNzzUTqD1NAf1ptMEjQYu30wX6CM1TCliorknm4JEBlTUnesxWTI2MIZfuCpjT3za2
	uiCD+9ioGDnc2BIKKUezASS1F3OG6FTPW8A9vm+Mk2RCEz0A5LSjbJIRCydkHoGzRzROUW
	AN5rH0r7NXsoFrvmzq95X89Z09TbwSo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li2p2tnFJJjJ5INNx6uZKzhFQ5sqAQSEauna4Y+cr5o=;
	b=nhoZcECCwGjpkvlB0XDUMiiT/3p24XMdQu72shwwcl/4SxBv63js7lYNeTcl601Ge8RwH6
	JQbnu8HSmWdzuFcWDoKaOiTHAMoyMCrqaPcJ7TPCm3+Tj++MB2Iap6lHrgC+Wg7N4bsrqf
	cmeLrz3N1x4sSM6ZS41Sfyc7IpNbUhk=
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
Subject: [RFC PATCH bpf-next v4 07/12] libbpf: Support passing user-defined flags for struct_ops
Date: Mon, 26 Jan 2026 17:04:50 +0800
Message-ID: <63d543aec9ade803afcd95461e3089e3d44caca6.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 7ad579pj6pekoz1m5engz9gk1i3mm9f7
X-Rspamd-Queue-Id: 930FCA0008
X-Rspam-User: 
X-HE-Tag: 1769418360-677874
X-HE-Meta: U2FsdGVkX18waERU8vpKo8tXvXTe27V7zKfng2juCHs0LbXph+bBs9f1YzME4zmWvQ51FzTYt4TqCIarImtvKbhWtG41kcS/6RPUx5Keq7xOH3vjW3SCMdw8/BV7C/sc4c1ZMNopxb2YBsO0ObYH+CfF16GaQX3QW2w2tbQKxF4Obgq+JA2fiibQPxJIfhEIv73mqyZXccNhPlHj5ENL68o7zGhA9HwklbqTw2OcPT1dbOZhizz1TR7StzZ9Z2rwtY5+AF3F/cG4J4taW7g2bmFFEuNgcfuRZAUULdRXGa3al3y1iRokIt69d5Vh0pOPxfsRQ2b1cnoMovHt7thtZGlyTESVCCtMBMnwmtO5fPatIOTHqslCgCCxRES5sCOimK+jylDapAGpApQVI1Usrnfo2a+GABMZmTChUeFatCykDWOYkGYbBcP0GshejFaILQzG3mqKuqtWFXQhpjci5nKc/bipW0XnECN882EfQFrVMUmYVX1xTklFr+JC8KN5o3EbARIfAREC/nlpmR3iySK/grdA6EReb2sdYYSJUmvClU5yBTNHrUCFmmJRfC2KpPKDzNdLBcEL1RX3OPsQXgnkvtT6uqEKt84GaAUFFVH1iMuwTesVIKvr2PTwownP4fCWMzzUPgoYH+uPjLxri7EJwuvbWk1NYP8Y5RlMPHxqytWVbuNDY7ryTgW6K2AIeLn3D4zEZ1l8l3JgSfoKfOfMSx1+d77mDnPUgjCCvjP45UWSodmLH9q4pzciOwCtMyW92fYmyJPMAjWEH1LfSvwqO/NdN8o6L2aeveKHPE6IrP6Np0dZy7PZf/RC+ON6xFR1ZmL7i9nafkuXbnRYKz1xNEQdIUR2RF8Ao3102AN2vh8bhouQm+6r1ZM1kzQYUfII6J5NB7t/i/HQQE32P+X/GR77z+k+HxExru8CRqSkYTIGlk3FVGvrkXabLZUrI7pRKAbAID04hacNI1o
 rNCSQB9S
 wRiZIL4PwhuEuGADeDN5uWt36wPSpK8zO0tBhz5z6sdadqfTQl0a/mPIYXAlbX9vGqFmhuN9DBvn7Xqsdh8nVSFy17acxTR4XLiV65nLPLBzVRSfLb1sdwKf20Oz/0UTKNAtus53VfOm2LgbRJmyYdcSwPtUfayYXrR/EE5Uo7k505eh63x7cDNI5S+LP917t2t1zgAJa5UeIXzdDQwDzZ2l1X5oVzCGS5MRaBjOCFbtmAh8/I0K/hOTpbxtJGf9gqxFcNGkznsCQ66SuiciS2Nds6HlVEPPNeuLLNkKPf9oeNrg=
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


