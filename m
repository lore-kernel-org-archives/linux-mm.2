Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A585E83EF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 08:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8026B009F; Wed,  4 Feb 2026 03:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD9C6B00A0; Wed,  4 Feb 2026 03:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9052D6B00A1; Wed,  4 Feb 2026 03:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8D96B009F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 03:58:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FDD0C283E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:01 +0000 (UTC)
X-FDA: 84406171962.26.7274544
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1EA06C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:57:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j+/sNfKq";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=BBU4tWCGzJnjIzXRcxL6tA6/LiISOkDiFW2HMkVwG3z2KyfodXPOuX/vayKa3iAEv3WmUh
	Jq6p4BxynrqgZCYuPE8q7p1ybmzThzkFq8yt4mHd/X6wQwhpcLvnqB5oMKI65mQuAY51FW
	YXp+2jhiFr4qSLT4/Mbrk5985r0ukc8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j+/sNfKq";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195478; a=rsa-sha256;
	cv=none;
	b=h14r7Xj5wn0JhLCtqPBfl+0xUIRyQ9aeN/nTeWTq/9VEFOClccC9atLmLd8D2T2NhLPobv
	TD740kYzKuA5QQk01WAFpWo76kHW1/P/8ggUZ+enAd4cDXp19mKNLZ/tPczr2IVRBLyi3W
	0YO5OX94ZxfJW6HMW4055jaS0T7qoH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770195476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZDHd5qG1jM6uT5/JnPwA06VDLOpkfHtWx6qC88p08g=;
	b=j+/sNfKqPAOt3+5b9qqvboBCLMIRWvQkiEytxqq65LKild8mFPBHco8437hrKDSJ/FO2Ru
	WI9FwySeMP/6bAaqUD+l8BEyUmLMTc4KZc5MndwPuYvFVX541n0N/3HX/qFkPL+TKMuxiA
	SQ2BD5VAs/vfz6ulz0pWeYkHBdJ5u5w=
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
Subject: [RFC PATCH bpf-next v6 04/12] mm: define mem_cgroup_get_from_ino() outside of CONFIG_SHRINKER_DEBUG
Date: Wed,  4 Feb 2026 16:56:25 +0800
Message-ID: <b917a3c79f2670b65db00e0ae5437029bf23c286.1770194182.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770194182.git.zhuhui@kylinos.cn>
References: <cover.1770194182.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kkei4wcmbtxspy4ht5cg8qkb6457zbaz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EA06C0004
X-HE-Tag: 1770195477-901343
X-HE-Meta: U2FsdGVkX18KJYKBjzPDfo5NaxHKSzEnFQWSZiiXEdViaYAGG1X3IBw7XxEHOTuCOYa6RyvlIO6r1ePIpLNj0NXS+csq2+nyyvOfvsK52br9LmTJVj9/ICTHOZYC9BdN5uBjDSnnUJ5t3aJAcudmqAmP0Q2D6jAFCWdogzGbWJakluLeZE4vIEdO4eJsEZXLZFMAb7SE+fEI77orWnCPODq+nRdJyvenYm3i+3eFOEgNdYisiB8MHohF49b/mvpMvApmE3mEKxx+DPxHjMaDmJu8LEyDBhbeZpNb0Cfk7ohD/y6v5R8grn9N0YoFXkjDwUGwYpSbQIv1nGIYMs5uxhsEqTKdcusNJLLSIa1D0f22JVcVfC5NM7MPGz7Ul9EREpgEAE2TZhYeSJ1xhHPZQTuYoL12v5wQfECoBoDU5AgZHq+fSMYzHfIJkbTd5pByJclTSI+LVU7kR+WtqTMWI543wZ72DDRRtSzhz6RLX5GU6LaA2MUhQ+g181YDLKYNB4NQH4ZS1aEMsUGDnlRL5gYWYbj7d+/M0/lfgD2q1QNAT0w2Ndd5jRUnJQkXMbbvJAX/MROUWxniIJtvaydMjephWHHfnEUp8u6WieC37cEqOBFscADUzQC+zq7dO+HIyvP+IMQxZqE3H/xWOwLG9m/QeC8nPcVZvfrkg/ICWvB97mU4tg2PnMXhgPYA2jQ7rLQH5asaD2fds/AEd/IH7hQKMKSBhUGWUfVzDn1o80AjcCW2b4cY/Ixi+iGMAyv4eAZ1y8IdjMwZNC4Na9mX0VKzknNoxoB1HWMeFeN6sstHrq27IyAUEJqO9VAtRDvb8AcYHFhk7lVWaKTzZjNq0YdsWs5DDPx2g6rIYqIhnFEVE9xLIxs2byDsM/g99LtdlgEJC9XCiNLMR23DR/9kahCji4jGIJqlmpXUz6ITmnx1oebht/DOLSSz3LuI/OmzJe9evg6EvrezCy5aELG
 VYeAClvR
 2BE+zzG9jvNTK54zIDwgEzH3XEk5YNnLlHosSIZWJ7k0WdDCIU72Ka9c3CdjGV7slflnLe8/0Q+4bMYF9YRxmWKA2ov3NeLaMPNhVeMTxs1WkK3II+dCJT5wFgvLZdcztZtxq/jpibrJqW6Y1d/supM3KmGzBq64A3A3gVgJWZOYAO3tz9shJb1tXwBxU8ZIsVHnWtjigb9+y3iYLmY5m3NA4wcJRJvPkuiLVP1YZyVcsduFJTqJR13NYgT+6VGN+xkThYFBoRk9EukVy1kMVIGl+Ly80Vcg0Riooo+ZDMfz5ncijjkpb13oC2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Roman Gushchin <roman.gushchin@linux.dev>

mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/memcontrol.h | 4 ++--
 mm/memcontrol.c            | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 229ac9835adb..f3b8c71870d8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -833,9 +833,9 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
 }
+#endif
 
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1298,12 +1298,12 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
 }
+#endif
 
 static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	return NULL;
 }
-#endif
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3808845bc8cc..1f74fce27677 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3658,7 +3658,6 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
 	return xa_load(&mem_cgroup_ids, id);
 }
 
-#ifdef CONFIG_SHRINKER_DEBUG
 struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
@@ -3679,7 +3678,6 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 
 	return memcg;
 }
-#endif
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 {
-- 
2.43.0


