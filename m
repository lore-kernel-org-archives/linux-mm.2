Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C7FCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4461E800B7; Mon, 27 Oct 2025 19:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6408009B; Mon, 27 Oct 2025 19:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5DA800B7; Mon, 27 Oct 2025 19:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 185DE8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:22:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC7AE1602A1
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:39 +0000 (UTC)
X-FDA: 84045470838.30.686498A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C9E918000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:22:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xew2qL4G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdK0aCR8A07YZRsNoWuzLvR86FzrKXgk6tVODaQUgqs=;
	b=aul9JANwcZzAiu/8SKXjysVNKw61Ytyw7KbQBlr4ZWj51hEublEtlT6+AzY3U3qx5u21wM
	e5upX2w4vY2yQiVSG3O2h84sfEWSQVBDa86Tr3wqUpEvUKRhioZ3/wv1a6OojhE3FcyHrQ
	GWVUbgH4O0ZwI4g5Oqf5kbSeRYxYnVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607358; a=rsa-sha256;
	cv=none;
	b=RwD8k3DM4t0RGY31swK9uaLBV5gpFbwueGdXAPkd11+/EgcRINlSurkI/omkiHRay7UEPQ
	ZBXIuSvcqzuqKdRUmAFiNV0vZc6bWUnbnrz77Mj3A9j9PGsVUV1naap0195GLDrjDWCsN3
	0Gyzh10s1bxcCfdOSRAd3PMM64o3osg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xew2qL4G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YdK0aCR8A07YZRsNoWuzLvR86FzrKXgk6tVODaQUgqs=;
	b=Xew2qL4G/tWdDy6CNgxiCYnwBMK9DK6KFVqIAnXSBNQMYcs3G7gG9nbce81eK/BwtmDDHc
	g+tN4YMVvDQt2CbI07LM4/eh0MNyo3y+aC1NPAyKQt/wUHU72S6D4umO0NRYt9Tq1AvzqQ
	1ka9AhsBKnJgbN2AZ7/PFQf5ARhmIrY=
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
Subject: [PATCH v2 15/23] mm: introduce bpf_task_is_oom_victim() kfunc
Date: Mon, 27 Oct 2025 16:21:58 -0700
Message-ID: <20251027232206.473085-5-roman.gushchin@linux.dev>
In-Reply-To: <20251027232206.473085-1-roman.gushchin@linux.dev>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C9E918000A
X-Rspamd-Server: rspam02
X-Stat-Signature: giaeie5egpsd5modxzzpp17h5kptj6op
X-HE-Tag: 1761607357-67984
X-HE-Meta: U2FsdGVkX1+XF5Qcb0BSXkah0UbJ7FJvvXYd8z0Z+YKZ5ewrWlgiDqUBZTsVT6/Y9gTsN4/HNz8NSPsJRfoJ5WptaSnWMzoQa1RKsUv/gxWVEgZpghGBowLvVPoprX5GxvRwaQgF5VbyWZQEb53SmmMqzlZaCoUoVikMHcbiIreTzmrrcY4iLhsai7jU1ZvHv4Bp/4M6UPnM4hZ8Iqx/KlVGl7CjII2MQEuo+piaTOaGL+mk9bzeWzvuZgRCuQyMrQjBS7H1qCzHdS6CIXlWSv6gfQTsl/n0gmADsnjItVu8GVUXlH6LmJyYHgf+HwA/b/Kdnt4zFNQub+cCHl8JxhHyImFlyWiIUedlw7rJ+lXLwg0hQ/XP50Fjh+hnnSSwoQCBFlCZC6gD2qiy+Rn5Cs35YGYBgVzaSlEhnUSIhRrOts7x/kokLAdhQi/pSannPdk+qgIiSek2Caop6Ih3Op5W00nr0ykGf+F8SV8aS4CA/6RBN1d7TT+ECTjnJK9brOFmQhLnlBAh65A+15SeZaW17706RqONpJDwqwRulSjmwvaWgJ3A+o7SdDJ1tu6evx/YEWnr41TLsnxO/KvTUBc01M6Y0LuuRByV4wzL3WA91yrqytHPxZPZhxDfSzz2OUTiv/rNLdjweCMO7Br7zoZuEhafBEL3FBdT8v6fClhSuCEJ7Gzq+AvQNqB2Csk6pybXtDYJZVwYIEIHT+3KAoRJgdo9+ZNBkPe1WfLSgNsfsHm4xktq32oZhh829z5M5hCkFDIPdKLBqd70FxBjEi2WVe2/4THvHJkXwaUJ+eU/oCJiTraXKH2w9iJCOqE9y1OUJkwZ5jUB/+GXXa86mMs/7l0obNEehBRk/zbV6aTD0eSoUNdemt1/PNfFdZ8WBaMEFJbX2M0qvQiE0y77Ij9lmEEz8pU9t+jlSnIgbysrpeGIP7wyXRfrw1ONcPU2S8k7WmhQtgU1PBqWPPK
 sEgOWk5b
 4MovS5z0q+oKV2ez/IXFJbp2IXRBw1rQsBQfEov+Gi70+4rOnvX3wyh0NdqaGdo9Mz9l8+8HS9z8eHI/ssWfVjwctHh4zDkMtoKO6I28jI1kK744D6GtIsp0viAtNW7eL1LBQ8lb8yPOF16VpYKbNYKcIyMudcBEfY3gq9vj2GrYIH5MPR1DPEFKwZrSGlAx1U3cVPhPHePhOfkDemXtvWQa9nM5CEFpQAZh0eFsLzqPmrsei0MZm9DBQvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export tsk_is_oom_victim() helper as a BPF kfunc.
It's very useful to avoid redundant oom kills.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 72a346261c79..90bb86dee3cf 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1397,11 +1397,25 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
 	return ret;
 }
 
+/**
+ * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
+ * @task: task to check
+ *
+ * Returns true if the task has been previously selected by the OOM killer
+ * to be killed. It's expected that the task will be destroyed soon and some
+ * memory will be freed, so maybe no additional actions required.
+ */
+__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
+{
+	return tsk_is_oom_victim(task);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_oom_kfuncs)
 BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE | KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_task_is_oom_victim, KF_TRUSTED_ARGS)
 BTF_KFUNCS_END(bpf_oom_kfuncs)
 
 BTF_SET_START(bpf_oom_declare_oom_kfuncs)
-- 
2.51.0


