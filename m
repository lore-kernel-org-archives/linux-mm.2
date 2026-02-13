Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF00EF48DC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28336B008C; Fri, 13 Feb 2026 02:24:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFB16B0092; Fri, 13 Feb 2026 02:24:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB996B0093; Fri, 13 Feb 2026 02:24:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9BE36B008C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:24:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A87E1C1C9
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:15 +0000 (UTC)
X-FDA: 84438594870.02.4087C46
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FB0A80005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bwmg6GyB;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAgB8oFd5RIbhmI0zJ6vnRRfguX9/AUjdmRvUVXFkXc=;
	b=kmaOcJH5NMQSsCBzw2KFPgQOALExUw9zd1GqL3enivpMX51Y1yyRHqtTxUQWHVj9wkRjaC
	u/CA2bCHSPd/jf7rWk5AKNVdQTcSSyyfUTr2+ibfKz7LlPve83qcslHpDOJeRecm97EwwM
	TNPZ7OevoWqFAVz7A59urCY6UaB8bLY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bwmg6GyB;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967453; a=rsa-sha256;
	cv=none;
	b=iFV4NGNG0Ha+UQGHeS7Y/Mc8P41Z4ZtjkYnauSmIrQI8p+qnG+4dxZof5QUi86+EJmkhtD
	dNwzMojZ8L54jxwvsvCq8S7B9kzjvqO7C2GPQj3gdZxBHd+mWkwez4mUm91fk0niWKsMqf
	HTUNx/SJJrF4RLTPEv7f22OukoefUXA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAgB8oFd5RIbhmI0zJ6vnRRfguX9/AUjdmRvUVXFkXc=;
	b=Bwmg6GyBinlCH54henK1zV60MzTL0l3tu5CSTyFpVvZxpMIPuMmzpLyguS+1lZAgtfxThx
	ZRYE8Z7/rCz3jQGeSoknWuAxJ+v/PGn0dILItTfznzId6qwBPYUZX05uQ5YyBcDaRfQ8Ss
	HMBzLtIOGY20FvjryGC6Mjg6pUishBw=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Hui Zhu <zhuhui@kylinos.cn>,
	JP Kobryn <inwardvessel@gmail.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 1/3] bpf: Use bpf_core_enum_value for stats in cgroup_iter_memcg
Date: Fri, 13 Feb 2026 15:23:39 +0800
Message-ID: <24ac7bab25d8d2a24a35ab87a5283263eb6a4575.1770965805.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770965805.git.zhuhui@kylinos.cn>
References: <cover.1770965805.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qkjwznbtxhqoxwkoqfbaf6kscgsatic6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FB0A80005
X-HE-Tag: 1770967453-313068
X-HE-Meta: U2FsdGVkX19905mlF3KArn8HbnrTtVnREIg1hi+cFd3mrTPEr4cgJmfU4Bm25aQpy/hUjp+4AyU2UvP/jfZTgSUZcpZNxVisiOqLprPGfWMrrQoQohc2JfpoXZxS0OZJmBM2V/0kVUH4wOKJsHyWKSIHvY6Xqf6TZHFNJVj8r9QKgf4mkBdDwMrYmF2U1BliJc1KTXYQGpW6Nyb5gJeK4KYzTxGc69qtwlsXP5r1J16qKJx4wzHcbNtFJICCmag229hLr3eK0enXnqjoI+aqHtMW5BNuJufYzsfzCez1NxB/0bl+yQjcMR2ohqDgOGDgyClBVWgZSkMQTKUW/6AeesdqFhG1yvA3wG5El5RT/taSfeGUaZ2KRg5r5SpfrcfsbcSzQP3Fc1VtdQX0a0Xvck6YqJ0sY/Jh0g/qv0tecuTcpXOqBpQX0YqngoeW55vnr6tfFot8zXlfOseA9/a5QyvrkvrD4Cd8pu8HjWPlFapqvqNuoiSsPtBetc95CmdukmXkOdJObZipfI8yukT2Zc78QoZn0W7IhqwGYneA1FLZUsHkckRpb0/KJCvilXeWEIUnZGKx0LUjkJOmZHDqnBfpP5JnsAgDUfx9Z1WQWRqS3N+srl73ZZ96riZL8yMZCSUD+52W/POMcEWewxFvCiKmB91XDYddCN2wZaOe55qf6IPnkZlKzzRnIjpXTZw5VrGqAVOD1OzEc+V/YFCMMn5DBPANE0F1UCcnN9ErpsDZ5nAY0RFFgTj0UcAipxb+uXWr9jhEfcSMyxSCVswiP2kaeE/YqQRgqEP2ZDmy2bV5KsLtL6lySiaSH2O/YSyZkB/jU+qrj7Alde/KG3YvLJgBSxoPIvb1rnJfeM3l5xHUsb59wmUiJIUq7KciylUGaGLXK9rgIamuo2wzxyXrZ3v8GLJ+wA7pncAtLnomdK8AUbJjiwv55r2QfjyF6u0dJWaWrP3VeNZwz6AB5Uf
 X65qJZoV
 myOxQv7xMNS5QNkhJ0xbFzrrBY/xPzpR7S1UG7fRCwNaynRcsQ1IhfKBvihGXh8RAFWmRlx4Y689qDdggWJgi328jZPfCW94TNK/8N+MRq+jZcLNJe9HEc4NeoikfxPuNmPUgEcbB1S0o0DgbVhL7p2aXNZCv6HYnLlBmAB7ZLEq25yi+KUU6N6JLA5CWOWgJGa8gtUxWxtLh5ufySQhsfCnKY2fxH5/Vw2195v64kL2aMpHgPEBd8TXs/sXaEAHkHYUeZeTwnghd/APU1mxOT/i6nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Replace hardcoded enum values with bpf_core_enum_value() calls in
cgroup_iter_memcg test to improve portability across different
kernel versions.

The change adds runtime enum value resolution for:
- node_stat_item: NR_ANON_MAPPED, NR_SHMEM, NR_FILE_PAGES,
  NR_FILE_MAPPED
- memcg_stat_item: MEMCG_KMEM
- vm_event_item: PGFAULT

This ensures the BPF program can adapt to enum value changes
between kernel versions, returning early if any enum value is
unavailable (returns 0).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/progs/cgroup_iter_memcg.c   | 41 +++++++++++++++----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
index 59fb70a3cc50..b020951dd7e6 100644
--- a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
@@ -15,6 +15,8 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
 	struct cgroup *cgrp = ctx->cgroup;
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
+	int ret = 1;
+	int idx;
 
 	if (!cgrp)
 		return 1;
@@ -26,14 +28,39 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
 
 	bpf_mem_cgroup_flush_stats(memcg);
 
-	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED);
-	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
-	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
-	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, NR_FILE_MAPPED);
-	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, MEMCG_KMEM);
-	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);
+	idx = bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, idx);
 
+	idx = bpf_core_enum_value(enum node_stat_item, NR_SHMEM);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_PAGES);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_MAPPED);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum memcg_stat_item, MEMCG_KMEM);
+	if (idx == 0)
+		goto out;
+	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum vm_event_item, PGFAULT);
+	if (idx == 0)
+		goto out;
+	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, idx);
+
+	ret = 0;
+out:
 	bpf_put_mem_cgroup(memcg);
 
-	return 0;
+	return ret;
 }
-- 
2.43.0


