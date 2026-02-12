Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672A5EDF055
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F1F6B008A; Thu, 12 Feb 2026 03:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70566B008C; Thu, 12 Feb 2026 03:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89C96B0092; Thu, 12 Feb 2026 03:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A81E16B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:24:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47609140731
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:24:00 +0000 (UTC)
X-FDA: 84435116640.24.5F018FD
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id A64F3A0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:23:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJ0OIcoA;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770884638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6JEGc5je/wM02pWehmFOl3sKJ7z0YxNGSRtnUE/RPCI=;
	b=jaG0JBPTLTX72lceV3Rao8FgQunos/SpS2eo6PPA2Bna6Zr6WbhdesfKhWlSR8/Crj+ELW
	Zi0BELXvatYNuxMrimIAb3bJuk3dkqYE5xRl0VdA6bOLBOYZwm1e9o7S8i32/EXLwmzyTv
	3H+We18a8M4YLzN9yYUmEYfisX1WNPM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HJ0OIcoA;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770884638; a=rsa-sha256;
	cv=none;
	b=vzKfJcGQnM00xhLgX2bvoyNCfuR/YvqYgTM9LTYhmmsvLg618FqOuPCp5mgGTe/c6A5ySF
	Xpt8HqtDIhoXArSeahcMh5N5MfnoMwldu64XNGHcWfrshIMAZeFhRolZG5oM9xAQSvA8cA
	qng3XVC/Bdx1AGaTMGYclx+q/BC5pfE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6JEGc5je/wM02pWehmFOl3sKJ7z0YxNGSRtnUE/RPCI=;
	b=HJ0OIcoA3oOP4U35yiAgKDYaQEY7TuX0qZLIDHgEFaDpBmCxjWW09jCTIjMQzH8JMX5S9F
	xrjh3BlaT9jvCMCDi44I3clcJ/Li+Q3ml5I/JJo7Viwh8gqwadztOu8XjVc6gL933c7r54
	OCbBi0K4vo3sxio7V14h6YbB0bfqkCg=
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
Subject: [PATCH bpf-next 2/3] mm/memcontrol: Return error when accessing kmem with nokmem
Date: Thu, 12 Feb 2026 16:23:15 +0800
Message-ID: <733422f72ccbac94126ae67b9e49f4a3d460b76a.1770883926.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770883926.git.zhuhui@kylinos.cn>
References: <cover.1770883926.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A64F3A0002
X-Rspamd-Server: rspam07
X-Stat-Signature: ycryx4jzjitppbbpyn35sne1uxeqwn14
X-HE-Tag: 1770884638-216284
X-HE-Meta: U2FsdGVkX1/KXFgRnVM5HKFVDK0MUkaXd+B+wypvk0n/naRyUyL7XMU7ClbSG+nN4YiiBxjFvrqm054kaJJsGAQq28pTTH5cXzZq/VBehe6pFGOLoLGucbZKlum1zQfCm07Ibdgg5TKFnlgbkIRrtduJIAoLXddR95Fr9WuibDjoat0IXcbPb8NHpAz1L2AurSJIkpJuShkDp+Nr174PAWoOw/+xzUcZ8GHANMPmxnDiP5tJuipvMOZS33zP5S8K3FstkTGe8oRfp3A9bw59fAeVrq5KUFNNTJ4PO+rzO3aravgSqtotoOJRAQbsk0RH2lLRFDDzb16ZuPOz+3bqdD3SxrZyXMmHCEz5mPF4ymbna20yrJ+0qhiQE4bavs/negeLM0Z8SO0btxN+tydYaD8hJAdl5IbL3Nz08ONoaQva0JPoSNF2XKyddhefc+PR4rQ3Un4cOfH9Yuz5z8rTJELWKy3O+ZkvmE/Hp0b9BjqtufnZo8P02iUbpqa3CLnfoweKbCRQtiV8kt542wZVe7UR5FcvcgFtcO03gjONjbUrCxZlZoAa64JvmiFupPeDGI/HVA0/Vl9XNDIaHno3EXfj79GWZ8kuM7NRhv4p8em4fW17jQF17BVTZ4SLEQJKaG8PKLfYUQa5NRPKP2usBy2UAxCUqcux89QninWsihZGyBikZDDETRdvXCKvcnsGNImHgZlqa+f47LmAAqPqs9OxdTFKSOqZuDllNrp0HLg4d5Jk7FhfsrdxAtxL4nzDYOkhoP+PqCb41B937hhtb7ZMizAGMetQeEm/XLcpd1p3oUHJ/wgHBv7hC4WygKPZFbS42WopE8i0BfX0Qwf9S9usq86t/TrLdSf/1RbWwAEHUFIK7ztvI/IF+Cr56UK+4bs7HH/ThdX58cLLf5mu+adLOhWTf6pW38n7hqPmEBmTYhIoANoBw0y7r8AEMMzAS2UoIbSUCafuAaxKs89
 xVVMrlr8
 yHMCs3cF+VvAhv0QmkZ9T3Tr3SfFP3bln5irFK7VMoFh1yqoVc8oZDHR/TrqsZkvcsa4y2d4WU47KMnOIjEbL6L2hkuOHJhpk4F6QXQntG3TTkcKob/CuKEkZ5WGMEIWeFcerK8dKajF8S2fafOI/joEHKME+CweXjGWzpy5+Z8HGh4oyt7En/cjfYyjkqQMGWN3YGlSVzAoKL+zDlfJmtHkuk3mVUJqlansPIIuSIfuaLsS378Nk/F6ehqISoE+RvbNqouK+yP6tfkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When running tests on hosts with cgroup.memory=nokmem enabled for
performance reasons, test_kmem always gets a value of 0 for kmem
statistics.

Since BPF programs cannot easily determine whether kmem is enabled,
add a check in memcg_stat_item_valid() to return an error when
attempting to access MEMCG_KMEM statistics while kmem accounting
is disabled via cgroup_memory_nokmem.

This prevents BPF programs from silently receiving zero values and
allows them to properly handle the case where kmem accounting is
unavailable.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 129eed3ff5bb..4d8419623d1c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -667,7 +667,8 @@ unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 
 bool memcg_stat_item_valid(int idx)
 {
-	if ((u32)idx >= MEMCG_NR_STAT)
+	if ((u32)idx >= MEMCG_NR_STAT ||
+	    (cgroup_memory_nokmem && (u32)idx == MEMCG_KMEM))
 		return false;
 
 	return !BAD_STAT_IDX(memcg_stats_index(idx));
-- 
2.43.0


