Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFDDE6B271
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E87E6B008C; Mon, 22 Dec 2025 23:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8346B0092; Mon, 22 Dec 2025 23:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B5D6B0093; Mon, 22 Dec 2025 23:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 603626B008C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0421C1404A6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:16 +0000 (UTC)
X-FDA: 84249489072.13.D0DB406
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 563F8180005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b0M+Jlw5;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1GnAwrKnomf1xfbS9Wxii7iuVLuWoO/88OS8fu1I/I=;
	b=TqbZvMEVprcnkrPOzqdX00WgU/AKJ/s7RLVFgkDEM6v2NtNsPUo1Ct0ZDgJbAnr/AX/ojx
	q5DwuOllV/LRx7XYKxrBVlQSh7/NWW799q7Gae5QRco54bT4cLQ566mDwBP6172jvllRle
	NtqK86WVC0ioqucWtDFEt4MAi2kh49c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464934; a=rsa-sha256;
	cv=none;
	b=7ywDEhdt1fezNLkpDfe4PFQlKzeuoTfaxfFCEEfNdVficYV7rn/29Uuh0X/7JORumOS7Fq
	Trg0sBxQJ01x0fmc4qNbz8/lVGTTdpW9Gtm1jV/1TJMx3CfntY0FUNOCXe7kf745lYvcoz
	GGzZ/sUf+ozirihkZSNFnNygf/prJkc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b0M+Jlw5;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1GnAwrKnomf1xfbS9Wxii7iuVLuWoO/88OS8fu1I/I=;
	b=b0M+Jlw5AXuY6utYcm/etnGH2dLvH3B+1ZEptzn/VL0ztH69oHIeWmds7BWtx4A/Bu5f0K
	cQp/58uyq4QYzVQf4OM2kcT0lIXVvnMPFHKF+YfHp/V5Qb1zgRiXUNLGMmWdAjx2e4/mvw
	48P20+NEVs4ixFli4oComEhp86K4ryk=
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
Subject: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup() BPF kfunc
Date: Mon, 22 Dec 2025 20:41:53 -0800
Message-ID: <20251223044156.208250-4-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 86yrgdgh33nnp19kgs1m13mx4e1bjska
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 563F8180005
X-Rspam-User: 
X-HE-Tag: 1766464934-302877
X-HE-Meta: U2FsdGVkX1+YtQ8mw2luXpdWWunYdq3vlwNqnlrGPAX+O6aLlWPjD+S5uLfLLPT9rP7Yx5G2QV9U0q6egD/CiwC1/MTQZ236kglceb3k8r8WvRrtsjD7jOQrn1oZy1tj+50ZBkgxO2ILyPgOlQrsGgvsGa+W4VCDTuRi/LYXAnnCKeTWitmSKiL8u2Ccmrb/a/qw3TWZd5J8vU0OCEYffpFW+cCJOjGqUCBvzAz8DBBgxE2iLQO4Gq7QvrEQ8JUS6/gnVxfoJtNvFYhkQWuz0RtMVm3axHRe3ePKyaY9D+twQ5h+J5AAMOAmm9TuW56cQb9dLEBiUyZrKMCv0WpDXHPMC9u3klszL9FJWP7VCLGekOVHkgbC4bYLSKnTP78I21qULoe9mEC2Np3uGFKlE3MwAAZ1lN6PvJu7URYifWHUkDqv2P21YmOG6+N2y05Iz2qIW8sq7T/VD0izhehQaoumbzT2fD5GqGAEDaq+WQtJ7BsAmM7JCK/R2f6+eVH6kjd337GROD75aWop8CCDQlpK/0bchNe5I+bNcgxyJ/K+wac79YKJdD4tpADqaIvjhDydfkWOhGYoXdKup1KuDmsmXzgwA2SnkXexp53jKLG53jxFLH1HgoHQEayjWVduCW4KnwfUn7nYlyf3FzgYRv8qky5OVV1fqoGUmws1cntt3NY7svrYdfR/KrsEYeGp7MJU+ZsN7+EvFjTLP2PrA1lIf3Z34jzms9Ug5ohwBJu3PcraXK02S/VVx5sRmWKzDWQHT8oGPwFt7d+eK8Q372Plf51E+2UplLr0t+AwnBf+ddx2R5rYSdHxou5duirTiKmtPngRZLTHytuQGz1Wm28xPhubDkz6mBc5xzFLA6VuOyjDDcoj9z82mDysfNtacjexEOzRwZvjbtWN3jMNfhb6gler6HAyZFWwCNvnYrCNqbQIPDQXRX9z4UQ60EGEFcjQyJ6TSmg01n6VLqZ
 OXAy7C0X
 KzpiAhkWEvfmuY2o3dPMNHhMHihLkCwHZlPbJ6jeY+ivSYMGTcYs3HLVrYAISKchzwKOWOml4rcqRAC+eToixT6FrpI/KzqpmLcboTODAw44IgKBoSYI+vErVntk+aBZ+sNcppG3YLYy7TjwzgFn1cwKYVKUJGn0DRHC3ayJrJlgUhCSm1qvrOfcDV3z+AJJTK0jlkbL/FJZGtZl09XZassnNum3gfxeXdXDHRbj958gspqzvUermv+Ib+g==
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
however in reality it's not necessary to bump the corresponding
reference counter - root memory cgroup is immortal, reference counting
is skipped, see css_get(). Once set, root_mem_cgroup is always a valid
memcg pointer. It's safe to call bpf_put_mem_cgroup() for the pointer
obtained with bpf_get_root_mem_cgroup(), it's effectively a no-op.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/bpf_memcontrol.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 82eb95de77b7..187919eb2fe2 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -10,6 +10,25 @@
 
 __bpf_kfunc_start_defs();
 
+/**
+ * bpf_get_root_mem_cgroup - Returns a pointer to the root memory cgroup
+ *
+ * The function has KF_ACQUIRE semantics, even though the root memory
+ * cgroup is never destroyed after being created and doesn't require
+ * reference counting. And it's perfectly safe to pass it to
+ * bpf_put_mem_cgroup()
+ *
+ * Return: A pointer to the root memory cgroup.
+ */
+__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
+{
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	/* css_get() is not needed */
+	return root_mem_cgroup;
+}
+
 /**
  * bpf_get_mem_cgroup - Get a reference to a memory cgroup
  * @css: pointer to the css structure
@@ -64,6 +83,7 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
-- 
2.52.0


