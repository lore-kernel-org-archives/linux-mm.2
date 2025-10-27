Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCD8CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07BB800AA; Mon, 27 Oct 2025 19:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF4E8009B; Mon, 27 Oct 2025 19:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C6C800AA; Mon, 27 Oct 2025 19:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAF18009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:17:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FEF7B6F0C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:48 +0000 (UTC)
X-FDA: 84045458616.21.E82B69C
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id 89A00180007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:17:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uHT3XV84;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxeBk//0vfxmCDXu0Ua3XftjTjzPqFj9JEVDoYRQlLo=;
	b=58ztl4cKr8rMvzZb0lRWO0G9RwDtqLOR4SwlhzSy+bz/DNsRB3LnUSKYfdPJwgcnDqvwjt
	8qqNzyVWCJeufpQC1eT5q8qWOP3ZD+gd1YjmT6wNWwbDRWmVQpe/xuccEW5KSBuqpcP+fS
	1Cwj+m/shhTpxk1kvJf4kDay5/dvDlE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uHT3XV84;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607066; a=rsa-sha256;
	cv=none;
	b=6GUzdfjlUMRQQ3cjMfcmUWN21oJSvT3ew0DGQDxWr5AzhxtrwwysNv/i3e3sEJJBrg/ASQ
	i9SoKfb3tCdUVOUMQMYdgpXdo47Xdv+Y7lGLyzPHB/sFtS+QDRHV+k5Ox3ZvT+FIWt5CZh
	hrB/QskP3FdCb1QrgkBcQmG5YRZXhGg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dxeBk//0vfxmCDXu0Ua3XftjTjzPqFj9JEVDoYRQlLo=;
	b=uHT3XV84WSMhGH7cmFl+7kM0vWfbc7wXTQ/mEMDZ4Lb6zZ3mGMbFtS8jEAoLnrqSegg2W5
	v9TldZKy722Q4pqdAHezjhpWzEjt4+sVolqhBSb3fjC25cv6vC8BAeia7NVb4Cnr3x8B4b
	lGUOlrGJjO896IyjcThEmkbCJCeJC2U=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
Date: Mon, 27 Oct 2025 16:17:05 -0700
Message-ID: <20251027231727.472628-3-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 89A00180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: x77a48cbqhbpukdjkzaazyh7yy37eodq
X-HE-Tag: 1761607066-214954
X-HE-Meta: U2FsdGVkX184hTaZRX22YRsx8TdmEMjk0PYNjBlRkBmIHKH7VjSNYMnhd+8KB+ga/E3vVlnYlRpl/K+8Qeg3bQs16x05faWjP3l2ChfcebqkJ/IOpI7LvhAqg1d1olCeQYZt0l3xvjYnYPuSi+6nZR6+cYRGrEiyU6vFqfhFfhowjHXSpCf/6n7xYI/j+JnWp9CZTf4cvxmW8ExL5MvjC94ts5Qj9P0eXsXH3yV0+y1IPeys/BtGMJmwb2JzESqjWwHff15xgJmx0pfAXwFjPvMcmuPzk464bFEkVbtq1+sE6T41JdpkOSwQx6C1P0rO5aVp8FK+xGpkZFi0Jvgh944MtwgN1OMa11HiffJ65YV6yZ3Inwmz0K5wUd/SBxdvUW5GGV10k+wKTiXVpb+ptHk4s2R0ApDUsaTxOt+rtKzJ+YgyU+LQ3NZhRTyb8bkpanrnAFX//wfZV4SFf+2xw6TOoUGCUx6XpA77rvVqxrGUL/unC8VtZWDEjKagji3hm7oDg76bX9ub4HFFF4gSqBxHUYYpaU+SoKQZ4q9jTA6vyz2SkN/l5USKu9qo9zAb5zvKFGcED8NwefTejSXUV5GQ8S8pMyXznBDn/sDRN/iObpcLGiG0pGftyUvR18uyzYotoSdg28+5ZIwgtaRnBv6qcn5HEi/HRe84eA25U5GiY3vG+rv1AetnVvpekvp1h9S/EtN2jnNtfBhZBzsBb+ODaGM0UMmvgR3J+d/ns7zbKPQyG+9fNl2TKT9UejtE4xwDW31pSPmQtSyrAIXXabxoYiTJAwYG+yrOobVBfNX4XlaBObTDEcQ//1yuB1p60zib5g4K4dtbRV0IG79uwbEA2m18J+eM9INlsrbQWEbdwuHDyyQSXPF62clux3A68SSOa/PUcEZFlXK9Y4vxbRfTnu33XgV3zoCJMupq2VzQOsJibP32pfPdZn6812m4YPNbMCW1gus0OefO8N2
 N95NkPLy
 4nnf1N1QK5Bcm6bR6gL49oSDpSv6iJzN6YWIPQ0R5gyBSmTvlHZUV64HgzkfO/q8Wzi41o0CkflGB2gN0wcGzKAGh6G/VWG4agr537V+QakGavdkOIeHV1QbB7SnB1bzqAQk/zyaJwY9bXEkaWmvSbs9YN67juk11f/YuIilFI6iqcAw/Mj4WO9yzqZ7YWTOjkpKEiQ4EuUIoNKPB6nmO5TgLpF015MxUoGro/tjtQURsmco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a struct ops is being attached and a bpf link is created,
allow to pass a cgroup fd using bpf attr, so that struct ops
can be attached to a cgroup instead of globally.

Attached struct ops doesn't hold a reference to the cgroup,
only preserves cgroup id.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf.h         |  1 +
 kernel/bpf/bpf_struct_ops.c | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index eae907218188..7205b813e25f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
 	struct bpf_link link;
 	struct bpf_map __rcu *map;
 	wait_queue_head_t wait_hup;
+	u64 cgroup_id;
 };
 
 struct bpf_link_primer {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 45cc5ee19dc2..58664779a2b6 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -13,6 +13,7 @@
 #include <linux/btf_ids.h>
 #include <linux/rcupdate_wait.h>
 #include <linux/poll.h>
+#include <linux/cgroup.h>
 
 struct bpf_struct_ops_value {
 	struct bpf_struct_ops_common_value common;
@@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
 	}
 	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
 		      attr->link_create.attach_type);
+#ifdef CONFIG_CGROUPS
+	if (attr->link_create.cgroup.relative_fd) {
+		struct cgroup *cgrp;
+
+		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
+		if (IS_ERR(cgrp))
+			return PTR_ERR(cgrp);
+
+		link->cgroup_id = cgroup_id(cgrp);
+		cgroup_put(cgrp);
+	}
+#endif /* CONFIG_CGROUPS */
 
 	err = bpf_link_prime(&link->link, &link_primer);
 	if (err)
-- 
2.51.0


