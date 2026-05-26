Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D90ACD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7303A6B0096; Mon, 25 May 2026 22:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707306B0098; Mon, 25 May 2026 22:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DC46B0099; Mon, 25 May 2026 22:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50BDD6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:22:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBFAAA0214
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:22:04 +0000 (UTC)
X-FDA: 84807970968.16.7FF50C9
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2415E160007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:22:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c2O+nEAy;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykiWx+jJ41AIlhwvxbQbM9j1opOnC375H9pPJ40SXbc=;
	b=8N1u3R+3cY0CfzXCF1r6F7B6hUyemmrH/nL8wZjHXbcxjwNka6Xso1HjG6tZg+rwTCUyAS
	FoLE6pFO+TIoC6mCstrdPw8vMUajcGbAJ+pHHwdoxtruj3bbMHTxbNE0NZy76xfY7usGHX
	dMpP7u1YJOfmmY+8G0cSLwCh/vPECRw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c2O+nEAy;
	spf=pass (imf08.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762123; a=rsa-sha256;
	cv=none;
	b=cIBP7xALCsMAYBzxd7638oJMA0hsCDg3bTWFVYd+LbNVe5JaS/LkNxmxAVfmAX5gO+ZLwu
	i0g+wj+rM0snafRsuYcmR15rYCj1ZJyz+Ip7EBjH2cEZ7P68mI2Gm+Tbm8lUU6SDe42Q8X
	IOV/CdUhQDlFkfgE/pMkzEzaD6C5NFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ykiWx+jJ41AIlhwvxbQbM9j1opOnC375H9pPJ40SXbc=;
	b=c2O+nEAyiCLBgt1zDhG69wQnZW5jG1GOvhIAkS/3ahbNDoa2JXUWTtBHLIpIPmmTsrcTHw
	E7ET8yOilbOSmQScbO1THS6NERx1Jr5ftkIeTh+p7iVuI0PQRMbIxkf3lCS1NAjYDcGI31
	mgH24x8RVaZxRBEWf4/wk7MRvCI/96E=
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
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
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,
	baohua@kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH bpf-next v7 05/11] bpf: Pass flags in bpf_link_create for struct_ops
Date: Tue, 26 May 2026 10:20:05 +0800
Message-ID: <8dfc661158419f7331cc645368b051a424229fdc.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: o6snkpd36jitgi9f9wmb4fn765fe7wrx
X-Rspamd-Queue-Id: 2415E160007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779762122-904114
X-HE-Meta: U2FsdGVkX18FROQQQ8osbzy6pAtg+snFoqDtyupJcOKoX8G6jgMrmzD6RZ9MoS6V08OKLoxCsVtCXqZqhVwUqMq6l/h/t7yh+HSbTF6AB/CFOG+yS9VgNdLbumFshD9lff8U4z5Xu+EdiVwiYlntjG5fFhUBi46bIVUGwosuKp0Bcrkx9JmJmZpU0MdJwKXCvKHOddpJa5GlYIWrJ6Ne1ODxfI33t6Cahvbo7vkcBEgPw2TrAJrmo1uIG66tbNumRoVuxU6jxmx9s+uUvX7/D9KT8uDAf0AXnYvKFStVEoUahi4H5+LAGfYtuZ7cXla5lebKuLvN5UHKRDZKTMeVEwxdBJL49OR8M+a04wbwATpJMv07+u++k0bYEsZxHbCFIoEULqvdYdYKr8krJBaFB1L9FjE7yvCsLwInQnWHs0Du+fSFxLPCJDBxpwNXeETeGSKl0EmN/0470iemSJmurXIEI/9IxLJB1aegUM5oiEHxAYu2AqrYFua3mXdtVi6osRb7OJjdy+RUPwdWMTsfpNkfTLik2BrE1Kty5uFp6LFIi4BHFL/LwxjALD1ss7tlcrkKbAv6emubsP517xO3eVuPFEnbyJ5LTF6SmyFOmkK4I8mSPxEL7CXWT2icISP5HRDbLG1HUt0H05KJHKdgwl5zXy4mjTJ4XcdQfhIhXqT1KFl/9mEHkyy4ChKOuxUUlxW79fjzlGVK6vtijQneHQAvUEs7Q6cpwbcyV007qOcyDt/9NAK3FCQUzt9NIvLK2JD2NuU2TFgfYJMBe0XcLMIrLpSgb/0zEQCZQy53IgEfInbgYm6RruhFwM8ATXPIOkJ2p6Lf81lgQ5SpZgb5M2BdjuylZMHWpN8bMxsNs8z0sc2rg16KRzKD6VXxJGBgKJNycUQnzn5ciOb2HpVCTOL+iZ9aIlupBxwd2iw6Q+WLkE7EQvDYGNWUgEhCYpmzLKhEIEmIB9C/rTz8aUj
 pk2s1hCg
 sZ7JcWMRfAJ2e9xloSGqWLFgTC/I7pT4ubjFbIZB1ppQe5CcpRx6FAPeLiJ7KvUGnrXIvQq7UkdzH7iCghZ80uti/xQLpFbpZY50QxrqQb0K1SP8wZpHhC8LlykRN5UV4flZoRVz0quP6o4YH5WenaI+EHrDkAZfMH1GwTIQeMo5V7A8QyvJr2+EhQ9BJ4sG8gMMzynYwU+sH8EDJIdFErOrPpJQbgq5KFEBSfi6F8QRFGYQDJnRkeSaQ0CN3zSh7GlY1PrZSRqnzHXCGXup+KmaeyBG3YOWuwuN61RuP4qXq5GYVzoyvOX1kcTrYt5dIu+nQ6UeSh6Ae16v8ZFlPmJZ5HvAdClwMT7vav4K25KWG0VHySDLxVAyTcQ==
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

The flags validation in bpf_struct_ops_link_create() is updated
to explicitly permit BPF_F_ALLOW_OVERRIDE in addition to the
already-allowed BPF_F_CGROUP_FD. Any other flag combination
will still be rejected with -EINVAL.

UAPI Change:
This patch updates the comment in include/uapi/linux/bpf.h to reflect
that the cgroup-bpf attach flags (such as BPF_F_ALLOW_OVERRIDE) are
now applicable to both BPF_PROG_ATTACH and BPF_LINK_CREATE commands.
Previously, these flags were only documented for BPF_PROG_ATTACH.

The actual flag definitions remain unchanged, so this is a compatible
extension of the existing API. Older userspace will continue to work
(by not passing flags), and newer userspace can opt-in to the new
functionality by setting appropriate flags.

Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 2 +-
 kernel/bpf/bpf_struct_ops.c    | 4 +++-
 tools/include/uapi/linux/bpf.h | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 743b4f0546b5..aae7f9837944 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1915,6 +1915,7 @@ struct bpf_struct_ops_link {
 	bool cgroup_removed;
 	struct list_head list;
 	wait_queue_head_t wait_hup;
+	u32 flags;
 };
 
 struct bpf_link_primer {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f547613986cc..85ab5bdf81ac 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1194,7 +1194,7 @@ enum bpf_perf_event_type {
 	BPF_PERF_EVENT_EVENT = 6,
 };
 
-/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
  *
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 5333290957cb..1d15c667a300 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1389,7 +1389,8 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	struct cgroup *cgrp;
 	int err;
 
-	if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
+	if (attr->link_create.flags & ~(BPF_F_CGROUP_FD |
+					BPF_F_ALLOW_OVERRIDE))
 		return -EINVAL;
 
 	map = bpf_map_get(attr->link_create.map_fd);
@@ -1427,6 +1428,7 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 			goto err_out;
 		}
 	}
+	link->flags = attr->link_create.flags;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index fa075dc3b7eb..8a2b1f865d2b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1194,7 +1194,7 @@ enum bpf_perf_event_type {
 	BPF_PERF_EVENT_EVENT = 6,
 };
 
-/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
  *
-- 
2.43.0


