Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF40D72355
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB736B0470; Fri, 23 Jan 2026 03:58:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CA66B0472; Fri, 23 Jan 2026 03:58:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BD46B0473; Fri, 23 Jan 2026 03:58:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19DC76B0470
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:58:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2C171403E1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:57 +0000 (UTC)
X-FDA: 84362628714.12.BE0EBFE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29334140002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:58:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6LwxY5N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF3N7wfqonOz2JeVOK2D6Fq8XUWqRSBOclHYLh6Qqp8=;
	b=niC96jkxwAKKKsCnXczEziQVxImJv5dR5PQVfiQoeNavxLZwtN3Z95Dzo5mzhwzKg6+3f9
	yDZxd/MN4Z/m1Tsg8apTEK46HdDp8GD+s1yVftZYqfAgfbZV6CSCZbqX9WWvuTlDV2X230
	GuEU59TruMrkmjubkDFbLphlWs3/wgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158736; a=rsa-sha256;
	cv=none;
	b=RrXUm6HpIn25v8vCOk2bKfgEc09J1No7k+rLFoKo1HriEu1N85jqm/vH7aICcIZNkbQ5aJ
	eb+ZWquXGHzGDF+Tl39EDuHmJ8nOgX4gfnfrUe/PYfZ+t9sST0fO3U60ZnyStQ5YgVwJpQ
	ctfXdec6RWx6m4eYIoi9bQ2YydcQMVs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6LwxY5N;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dF3N7wfqonOz2JeVOK2D6Fq8XUWqRSBOclHYLh6Qqp8=;
	b=e6LwxY5NkLu/Ogam+UhCiUBdJX+tXDML3QQGaCMjx/GTLIvuPNCLqgkIQBpsnEysmISM28
	GtPQ7AaT/cv06QB9YrunhGFVJPXzZVEYL+0R86DafDY/b032z6nS+0vw0ZYygcIqz1B8rk
	BxgDFTkJVddmfDtf64LslrldN1LMxx0=
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
Subject: [RFC PATCH bpf-next v3 06/12] bpf: Pass flags in bpf_link_create for struct_ops
Date: Fri, 23 Jan 2026 16:58:00 +0800
Message-ID: <04f5673e4b9c992a6e42ef3ea36db1df1418815f.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 29334140002
X-Stat-Signature: 5qegr6h17636xxfhe1bume4zh3cutos7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769158735-847590
X-HE-Meta: U2FsdGVkX1/2OHw02ifb67VIx2d/AuZ6Jn6iHruW4EW08/S+14U5m3PvdgZNMvOSmwq+FhBLBGKiSMT4LSXgh1f3LnhZ8uvQ+oFAGIIGBgRVKIlvOYXr3MADlHARd6w9ACHeAz4DHViMuJiGIE9EwoVPHaVmOJ5AKj5BpGJFjgaJHeVwhGyc3u1WQJtIM9W6crmhNfDBxwC7ObfE1hD3yclEgKInD4SB4AtZ+qZb+nb5q8VRA7frBEEOLBtrbsogGNa25Uh/XsMWRx2lwwZW8gzC0k11NAC6iTYgYuAkM44Joej/U6NKGkRW0tKHMRa4f2BKpjyWZz0Nt3EQ+Zn9lmatsRoetkmxsU3ZNa8q24Eev8rVq6YH/T9bNuePLXxCDCO5I7zWRdSywq/JOK245Ex4wH8N2UZw7cviKt6J0l4qt7C7yIQEc1Gl+MWspePsQSW2HjZ0f00lNRfhMGag/evRdb/ZxUuMAcnoSVDgy5gp9dcGz6WgdQcZtmO0JPD8RNcXXE8+ITR3Od3f8Sbt8wwGESAzJbxZPgWatYq8x69axJ+p8qWXrXsk+miclC+7V8qxY3EAVZURI+tUOZNi6pt2PWQJq8SGyJUCOEu8Qk9H1t5MzkH3U/HQuOVpZ2i/wY4sDUX89hrZzciAT/sdszpRgTlNmggTj4m4mcES7d6RW2jc29d+M6kjQB3oJTFpuRacHfrdMnfKDHcUGspwe4kuzIIuTO/waIu7hLk64DaU+4mnn+RG+jjHz4kvcE/HU1iIe8JJsyphIycvsVFWsSIHDBtJ2CpLQDl1AIeKcM6aOnihBUvh8Fqvxz/M/OuBwWiRaSavlekEuMw7Eu2+iCngmXZ5rEoQb6CS1BVyUG38NDy0wn+eIsGfY3k65/xZmSswSu6uwSTGffTm/wVqHqwrfsUpYI84EPQijNgfpErVA6fc4sW9t0WBGWJa4EyWTyPwYhOvE4FkpSkrRu/
 aygjMwwR
 ZW5afpXZ3oHMoPiLcGY/Qy5SG/W4inuNb0ATvM6tHvOzYwipjqE4ZMVRt4VEdPU3sfxEcxflE7a7puGZUovqqnAzFPqWW8aLwIUa5tu6sVSl8lpnWClmqnvbSFOGRDRo7brLUnwkmBkewvt2ZKO5xg05BKxtwul5XrZCiSEy5AobJWqu/C6QAMgsQMAo1yNnQpD6pGuikZMyCC/HV/ZvYLaHUl9TM8o9IlwRrnW7lZ8Vinqubnfx9B3zNt0U6HQP+zOsXITohI7COgqw/nuPlxClbAMjVjoSt51+88PGe9peHTO+ji9/f5dQz9DqftCEvbS/XJcTwEc4SGC4=
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
index 7c15bac782fc..b8fde3bf4b91 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1886,6 +1886,7 @@ struct bpf_struct_ops_link {
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
 	u64 cgroup_id;
+	u32 flags;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index f575c5cd0dc8..18042751f1eb 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1390,6 +1390,7 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 		cgroup_put(cgrp);
 	}
 #endif /* CONFIG_CGROUPS */
+	link->flags = attr->link_create.flags;
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b816bc53d2e1..a58fdb4484a4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1184,7 +1184,7 @@ enum bpf_perf_event_type {
 	BPF_PERF_EVENT_EVENT = 6,
 };
 
-/* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
+/* cgroup-bpf attach flags used in BPF_PROG_ATTACH and BPF_LINK_CREATE command
  *
  * NONE(default): No further bpf programs allowed in the subtree.
  *
-- 
2.43.0


