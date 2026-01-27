Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD34D2D8DA
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816826B009B; Tue, 27 Jan 2026 04:46:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3216B009D; Tue, 27 Jan 2026 04:46:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5686B009E; Tue, 27 Jan 2026 04:46:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC5096B009B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:46:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A69A3D4059
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:46:22 +0000 (UTC)
X-FDA: 84377263404.23.FC9F013
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDC7A1A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:46:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P7Htg7Dy;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769507181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJzfS1JLGvEK+FxWqw8ITpq79hNz1KKD0GGXddU0FBc=;
	b=Kv+OGBZv1wHW+zwCBPImfeaU/fE3eSTMoyajHpvXJlxwflv6AzqKEc/B4LHsnkFG4uOvIp
	P7iSEYHbezP601bGP0ahokGLb86hyIWc96uqrnwpJuJ2sd1iGAefPI6BIAwO5kKm0mIcIH
	afQ3tSsLs9HqsGCClkdvQu3Ivmgqn6c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P7Htg7Dy;
	spf=pass (imf19.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769507181; a=rsa-sha256;
	cv=none;
	b=kPWonpnmRiDxSzTNIvTgNutyVCa8/yoVF45aowjDZ8vuFv36vVnUrWYFjRO2cqULGUMw2T
	RkEE9/aQpJ3J1oaZWAYCCICbVB8yS/uWCg8ccWoQCxXN809PMQCvzb2Xg7A2mi1cSDJ584
	pInITOHEZNXSzwMOVRcMQQx4XTj5nVE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769507179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJzfS1JLGvEK+FxWqw8ITpq79hNz1KKD0GGXddU0FBc=;
	b=P7Htg7Dy6LcFd8R8VdXfIlRFf756CP3aQQqE0Z/k6TdgZY0LGPPqD7tubppy+ucyIppTJs
	XszAcPfj7QDhMZd//Q4CaJNlXtS7x69b7nbUy3/UywCdzCv5CntwBtC4qKsYL3g4YWzCCM
	7Ul2OpmeuFE7OHLo8g03BDqHNO0XCr4=
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
Subject: [RFC PATCH bpf-next v5 06/12] bpf: Pass flags in bpf_link_create for struct_ops
Date: Tue, 27 Jan 2026 17:45:50 +0800
Message-ID: <6b2d4fa8e5209d363f553d7851d5a1156137d9fb.1769506741.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769506741.git.zhuhui@kylinos.cn>
References: <cover.1769506741.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: dy3zrbg8dc5bxwm36ereapkbdbrmib8r
X-Rspam-User: 
X-Rspamd-Queue-Id: EDC7A1A0003
X-HE-Tag: 1769507180-86299
X-HE-Meta: U2FsdGVkX1+I+uWwMex6tiNmFzVmFMX4qvNlAJcvo+5t9BwmQNNitT/usJJ93td49Oh4s8eG3P8LwF23tW3ZFAsidgMBi8CF5UYYOarD/W42a7rLwIebzfVic16JFuVGq2lPna4GmuH8WAicVxTwLjlDQWfHZ6DmAhViNqsnJI9j60rx0KbQmHiV4n6tJfxKKAq250HDszzI2jT8w+l8cY4SKhqR+RIo9iz3PJKk/McUx1wNYv3rOCm080jKMdb8WAUWePJDfsaM1KnfZaDZ8PxygkAaBAnCktTfmm1otKp+ebsds5kRT3cIORD1krz+jNrmGrQn8A9lOa2+oLDYUUrsZeadZE1w8OuVfzxu7NzBBuQ0tdwRaI8sRFs+mVBI6W/BrKp/MFAmu1VfBEXEL00jPTGllUm73mkln6aeM2Qm/YK4xDXK3eNNyqNcnTEdKZC7+TNlB/glFz5ytpYcxyrY5Q2QNUGoHHqRZyBwQ3RFC4j76K8dl7vSgMHCGAWu/eFg0VYeUMLZ4k1tEwhxATXnLVZIT9PO2qcJuZo/SuSb6ScL7SP+s72TBukYhCtbK8qnQuJ4De4A4RBQyNd/J90DKz3copE2fMqil3icwlvAeCPfsa1t7YRhniF4z/LowgmBK145x9MQl0Ic84nAFJL/SU9rbRE1nS5T5tONNEuKLDXVgxjl8kjDDtMHPxdbEYxBopqMgF+l6ttV1tZKOOaOl2TZLqvZ6xD57QhvvTwwbIfL9ZO3bFG5ovpLDwCQtIHPE25atCYy/y8rWSJzmG50b5+MKQI30AChIN4/gDKIkj2+PVGYX8TgivNWbIkXoDx3GbYcbOnaT91GgIRSvt3st3kuHXEFjN5ZBpp4rqCTsOnJIXbaQFi0ftviD/4rQpv5nvLzPbrQ87j26JTDr8tEBvCF0TgBJWu0ZHL5qSJcWDvNJViWGlGGMcmGA7fqWOTFkgwN2X1ohYdmsDR
 yUWHmwtj
 GCkiP+uWu1kMBblMCK9j41QzJoTRMyE8n6cmmL/of9qMnsCCFCA3/Mcgf9mz2VgTAGSi0AEFFzumWOeyDV/KTfYhcNkR5vhP2Sx+bilMjSYmPCNtb6QjR2ByLXFmItHJsm+/0cQf/qQuY47LtV8tpPoOeOqb62KfAAwZSmZUeeN4uS1ZQZKvgY8HbkBiZYzBr4UH5fakISrUIoI3zYzSwvJJg0wnjx4N6JbAkoz6R5+fnv7d5O4KuU0KbgXTAvUzmgsCPWz470Z7sA4kGjFuTy0pe8iQIpfDd8FNw2jxGcT0P2SGjQjGbphDerr0AU9PGXH+rJ+nHvGYGvjU=
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


