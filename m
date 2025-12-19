Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4516D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0369E6B0089; Thu, 18 Dec 2025 20:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002D06B008C; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05D26B0093; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C88136B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E08E13646D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:16 +0000 (UTC)
X-FDA: 84234560592.09.86BA304
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4F9A1C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEoP7ESd;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxZtYJx1dwxpCMcKq8wqCyQtoClSuF/V4BGHii44wWo=;
	b=1hMFdyPMgxq7f+v5HnDe80LFdV/HAQGWz28wsQq79vl1SOYh7YvHUD+TD1HnKDcSbL/001
	gyeSTe0p+fzAWpZM3X3BGlZLbwkQM9XcpCWbbcUU9fhnweGvwx7Go9Lw8ubsmoAcIVYBLQ
	ol1dqh8CQtnO8bF1+2PffzfsOVMQl3s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BEoP7ESd;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109495; a=rsa-sha256;
	cv=none;
	b=FrFWN4AjuaxUfdWZy2tb789O1S6sr4u/95pJESmrmPPw8pcO9kS/w9EZQWzQW3URW7d+h0
	9WoqqorsjPVWBhpxzu48orBYxsEUMNf1Jwb7z0c1fta9ygOnCu7z3DhaYzTOLz7b/OvD4T
	dXZQIfAmX4ZGCdtjJauXHWX1S2YX+2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZxZtYJx1dwxpCMcKq8wqCyQtoClSuF/V4BGHii44wWo=;
	b=BEoP7ESdiETV53sORIkPZJVBHEIwFuS/bpau8YXo1EvZYX6rGF9DuhyiI6GxHGnBDZaeHw
	yRpXvo1Pl/R2nXI/bUT7XylqCrB6zVHds+oXksrWBJkx5djvWm59vH4fZFH7bBeGDAx7Tf
	IDxT5bqFE6e6lVkbruuiWLw359I9kU0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v1 3/6] mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
Date: Thu, 18 Dec 2025 17:57:47 -0800
Message-ID: <20251219015750.23732-4-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: kqxnt6a716ougro1q15uyq51rixfkpeg
X-Rspam-User: 
X-Rspamd-Queue-Id: D4F9A1C0012
X-HE-Tag: 1766109494-8263
X-HE-Meta: U2FsdGVkX1+1XNBb8iPAyRaZT5YnmxCAEobzlFch3lCmALoCNit/qpK/zQyqZEvB2a+AVL+W5Hh2xnP6lfGmafS9+VjmeluLhMSM4fmPZMhkPsicncW3QJsu9Lr1QvWEkKEm3PRgkl9rvHbgG+an3NZkBqr9NJZWYR19vRa+s3AEjDWol4X1ZAX2NzF0xABVHQeQvCXGz3XsGj+Ce45XZ7tkhx5P3c7F/SRzF/HbnFhNhcycXd7/xLLNvm3G+kJKUHEuHBMuxvVncyBcaKyOWnsho3EWwI8uC6B1ZvO3PpDm9fWW3xFWWZh9rUBKy37Ywn6xSVUt12ZH0dML9MAB3TK5xBxnGiOLRmsj3F1nucXq4mGf3spFjP9YCQ2uQ4HjbzI9MBPwMmsIeum3OLuzFtd01hG10vvRvCZfY3jEKeNm/N9yVDpyTGVzRr17a7XZgzNOgR4GrlZcmZEq/QJuSdmPejH5aj0mfuR5mfC/eaqISZp7kD4S4oJ8eUrY+Jjd6hVWzb9GAzX8cRQHBfTnChwSntBmPnXyXTEUlEzuvppot541yJF/8gqoBMNHq7L2PLMbTzoovIUUPObBOhZhvOa1kaUc0aBGMjS7Esh6wrUiBoXJSTKMpOCSRngZR3xcUFLa1PWqlDBi0PCv9F7WLlK1wvjOnvTlAcWAOipGfm5ZxaesiXh8AtBteUeQ74oyGJAe4k56SMHEIpdBP3MWeyNYYkBl+XY+0ux04ONTlXRa8YjJtfQxJj14WGef0W7d3u7tbpQQiJ+sxdhEOWYYS88xzyEmBxR3ZDVg/Duh4T476H/xUKTCdgtfM7BGkc4HvhrpyoE5wu7qi/ZJmv6YOWcSKbrOUIMY9eGyc+/Ri5PAYo56tFNyF80eELfLEuRRvN3BiQaJBmR4CFBrELsmgHE8qn/D2u6VV0b5kVDJSXrar+TnjrkrR8BjhINVsOF/3Nb4dg3uKs30cNAuJVX
 68NyFoR5
 Enb0wgjgDi9CQWHGxMPbo5fCJivs3BknEI52P7XQ59r5+lj0y+FNNi2XOZSa9e4RS8FNFTXMLQdPHCxkgPEEQHo/m/b7mpMCeFW4G79hUWY8/OjPYo5OZpZoXE9RhMz7PfvW7T9xFBA+rm/eIaEkBvowmTm5y6V3vHoO5+LsIg0QdDQvRS0oDhrMmLlF+xAMEn8ZMaJATxHKkdBZuGety5AaheGHZ46orvF56v0eLFo3sTc07msYvguTNHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a BPF kfunc to get a trusted pointer to the root memory
cgroup. It's very handy to traverse the full memcg tree, e.g.
for handling a system-wide OOM.

It's possible to obtain this pointer by traversing the memcg tree
up from any known memcg, but it's sub-optimal and makes BPF programs
more complex and less efficient.

bpf_get_root_mem_cgroup() has a KF_ACQUIRE | KF_RET_NULL semantics,
however in reality it's not necessarily to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 8aa842b56817..6d0d73bf0dd1 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,20 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -64,6 +78,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
 
-- 
2.52.0


