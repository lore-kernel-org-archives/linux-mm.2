Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF966E83EE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6348B6B00A2; Wed,  4 Feb 2026 03:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB676B00A4; Wed,  4 Feb 2026 03:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDD06B00A5; Wed,  4 Feb 2026 03:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEE26B00A2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:58:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D94461A0711
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:24 +0000 (UTC)
X-FDA: 84406172928.08.C4A12EA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2BD93C000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUAMtQtt;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeDzn3ZIpPl8RtxQ8UBkT2sOS4jMnERoC4vLjBOwnog=;
	b=YkKH+JuCPPDxvH4z8CYGR60FqlPOlcWhWlfEUCbVNGp2xRrFPnB3scgaOFn8/W2oaiJU9O
	piC18uMz1NJ3vVPgeRTOkhfZHT+f/s7p6VgmABYbOqwVwD4ndHn8+R1nGcE32+ayfrXh3j
	5WTytKtGoJKUvb66fUWYcici9JzzBH4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BUAMtQtt;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195503; a=rsa-sha256;
	cv=none;
	b=1IBwP6LKlHd6BYOfDwWhctgzN/2Gff/LHGqE71zJj+mgFJX2Nhg8mdy4+P/KKgFNyJi6+K
	ft1PHfIexPFPU6yC/LnR8ev6I5no+KCl1ikMWa5L4x5A2/ac6sQ9UAPQT1b7OSBQRNImKD
	VlMYAWmtzi9jVJuY77+7GNifI5y7sX8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeDzn3ZIpPl8RtxQ8UBkT2sOS4jMnERoC4vLjBOwnog=;
	b=BUAMtQtt/ptCud5saYVIgTmDduA4o+i70Q2mjpckwXNPLtvcR9U/RDQT4TDmvqA/iuFMlk
	dCvI6XN9z3S2O7OhvNQE2tx6yJ4L80u0P6ACxUFJW3ev+0pZl1NmQLkz45PWlum/9afOHt
	8J+SKEK45lPhWSzMVbkN1Rus1GF3dLw=
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
Subject: [RFC PATCH bpf-next v6 06/12] bpf: Pass flags in bpf_link_create for struct_ops
Date: Wed,  4 Feb 2026 16:56:27 +0800
Message-ID: <3879deea2efdbc75740e985e6cdbd67a57aa5651.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7rdckfq9gpi7hh8qfo8dn1wjnnitpt9f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BD93C000A
X-HE-Tag: 1770195502-283534
X-HE-Meta: U2FsdGVkX1+EbS8LpEwzGm4siHGPXkEtC3Eu4OCW0yP2sM55yEb0xSbrCXBIup6f0geoCF5Lgl7sEB65liYQ4izvFlXGJfixbQKWKlYaiS/BASpXjKe2esczC8PTRYihp02V4/Sg7zDAnO4uvWIprx3gMsJcr0mawuYqwavIzeJex0LBR4nMzXg6/wvEypNKZqEeUP6sKMOSgIHf9vs7IZGcCoAqQ0GU5FibksOd0qmoalTNfvLTZwQ7XDI7xNxeB+H6aw0P8wTN9rWNNoj1QKNMC9ttyFtI20y1kunXgj639Cy7THloWKJYcuSMeVYQA6kjE+8uwayBp4RmfXRnWdoGAwVGMhE3x8QpEGjE3v89KGJjLWXmqL34eE+8JKYNKfPyvAK+oB8wh2i/5EONHtXqt+frXUKP1EY00h/Xatrr7T9lGCb10vVDd0IjYLrP5sJpsQphUT2qbA8tjCE69VaYWpUJcfTd5qnJq6b5013huzNNkXWHCzkq4Oxu3esTX+xooWo1zEiHx8O5UMDGoaCZLPNnvCjxh4FJEKQGiHcwTBlFMrY/9LFYBWNydxv2JLuPN1a+xIrbqvOL9qa6J1aRa482uGfvL4ElOI9YmBaHqOHNMHLHeOmHMdZ0ZX41Sc/l05fvW8m8KklD41YoLa/iL1xUr1mFqPBUlH5m0wlSFvUr57Qh098OfjiAcMb9KiXMK17Bg/T8rIYptD1rZgZFsWm0vEUS1POK7L+7b8wzemFB/98eMlAKPXlcQ7lpSHUBG5MSa3y/pH7hE73NyyizD7fME4PhhHV0WYLXNwKu4YTvaO2f6O5aMfongWwO28FmNjYiGTLu3irrrZoK6LUnc7w9kAO0iv6ASbWeSgMXRQInRqKDsGPAwixA337j19BdCWQDV2AwEYVRLBpkdj5TyavdgytF3t817j/PPky65aYaW10BW0S1INMLkKUGjDU8GtGAwUWDRjmiALC
 hjweoouG
 HmkLZAAt/+zMwyGKl4y9cmyml/kAAzDBI/zUrF7GKVKRU4H4y07eRTkQmuhKy2jL3r4ie0FbwyUFcRYE6CHAah6EKIN6nQEM8YuXBPj+HOsu8I4yUkJajiEtkcBn3JlsjUd+dSVJtNBufd4hpPrX4wQTQMY9HAH7+5Sk+nQZiEwmqJkTbaOJCtM3KALZ2eddcNrvw8FVhkUZIIvfRCEunOO9SW0IrsSXjh6cpYeLFb/OsU0awxIONiU6hGnXjNMvyqYFnAB2pysJmhXPk6AJzjVQZkw97W+YE3iGTbE/6ZQbVc6idAzHtnaDUf+6MjlNwzgCRxlJGjavHczR2SVQw+Bz9Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

To support features like allowing overrides in cgroup hierarchies,
we need a way to pass flags from userspace to the kernel when
attaching a struct_ops.

Extend `bpf_struct_ops_link` to include a `flags` field. This field
is populated from `attr->link_create.flags` during link creation. This
will allow struct_ops implementations, such as the upcoming memory
controller ops, to interpret these flags and modify their attachment
behavior accordingly.

UAPI Change:
This patch updates the comment in include/uapi/linux/bpf.h to reflect
that the cgroup-bpf attach flags (such as BPF_F_ALLOW_OVERRIDE) are
now applicable to both BPF_PROG_ATTACH and BPF_LINK_CREATE commands.
Previously, these flags were only documented for BPF_PROG_ATTACH.

The actual flag definitions remain unchanged, so this is a compatible
extension of the existing API. Older userspace will continue to work
(by not passing flags), and newer userspace can opt-in to the new
functionality by setting appropriate flags.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/bpf.h            | 1 +
 kernel/bpf/bpf_struct_ops.c    | 1 +
 tools/include/uapi/linux/bpf.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 720055d1dbce..13c933cfc614 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1896,6 +1896,7 @@ struct bpf_struct_ops_link {
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
 	u64 cgroup_id;
+	u32 flags;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index c807793e7633..0df608c88403 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1392,6 +1392,7 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 		cgroup_put(cgrp);
 	}
 #endif /* CONFIG_CGROUPS */
+	link->flags = attr->link_create.flags;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3ca7d76e05f0..4e1c5d6d91ae 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1185,7 +1185,7 @@ enum bpf_perf_event_type {
 	BPF_PERF_EVENT_EVENT = 6,
 };
 
-/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
  *
-- 
2.43.0


