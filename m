Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C336BD711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355676B0095; Thu, 18 Dec 2025 20:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8926B0096; Thu, 18 Dec 2025 20:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4AE6B0098; Thu, 18 Dec 2025 20:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB636B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B679814039B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:37 +0000 (UTC)
X-FDA: 84234561474.09.1AB778F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22011140008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmCTAcXL;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQdgJ5EpKkLsM5Kk9PcaQQ6OLHn5Pe6OjvVecT6Mnh4=;
	b=GaaUjmuSBBwngNnE6EfybO79EBew3jW93nKnx3EB5WD7zpg0Cx32L1qDQ1gZ4XAXE7OQjG
	YLiFQrJBBuCu9kXTLhvDuCUtvVjf6g0FKS+jgFQa2Epk9ChbyjQ2Xq2GMTJeu4LVjd+X4F
	ZXlDIUeg36REpGTJjKABsQZ6lYEVRlc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmCTAcXL;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109516; a=rsa-sha256;
	cv=none;
	b=pS+2RmCWA/yRnhJ7ZaXRqRplHpxPav6PQ7V+2UZ4J+VaGeJAgEG4ZNOs6rnKd/FmJita19
	IGxn8z3iP66Esb5Q3kt2Qlh94DgXVWlFZI2oMhv2qbm2zXquAS7Gb5VFvKl3lKd9YDCFIi
	R3t0+fyFyCkJMJyuWlz8/TgBHZclMPI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQdgJ5EpKkLsM5Kk9PcaQQ6OLHn5Pe6OjvVecT6Mnh4=;
	b=pmCTAcXLYKihBkgCQMNV3HqiC9p2aTLFPd/YlGQ2bQ18mrslVJ2em/TbMnKHHJd5lukfXG
	aiG3o3lmFbCP99qsZzUyINwZJQZscBymtLt4tHMlbxKIL/KAgve4/dpn8Q1SdumJ0ap9Li
	w04mAMYAdHgm7zmM/xmRtRr80LHW29g=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH bpf-next v1 5/6] mm: introduce BPF kfunc to access memory events
Date: Thu, 18 Dec 2025 17:57:49 -0800
Message-ID: <20251219015750.23732-6-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22011140008
X-Stat-Signature: hsit7n3sec4rk14dggmbf8qo13s5d4wa
X-HE-Tag: 1766109515-501646
X-HE-Meta: U2FsdGVkX19+8Uk8tYRQxa68ChHDWcE5oluCe/PWeqFJApcOSdoNGrSITxg/aw0VUm0WClO2r9s8tkYcV5uynRijRnXyByN8a/dgBLx68AXYd7owE1QNYlr4XYMFRKGXTZTOtAa3i24FTmOd7jicU3JH+8D4dF9lt3fHz7UIvsmySLC+QPPFBDdZm5RjHp8/guwMvhNmcD4KQvJ3B/0Ejwf42LhMP6B4XaO1X1WRfUSMkGAOLeT3FbKSrVy0o158E+b5kg8zWgN4pInGwtECe17w3lzpOuNYg1x5dHq+andGyY1vaWy69vLqUEQGCLVtcoFLDrfOwe50YZQfS1hZLAOBH68bRWDQbxem2OW7OTjhpvqNDc3j9yC06B6bn+GhNeQoHSN9X7VWT2moZ/isKbigyufUuW0RSj0vSWDgQUEIxj6xWS1TddnREsLGGD9bmYKfhb2mU1/ftJAeOSvCO4trZWnjnLPBU930jH6DIYEXyw5UobSXyf2QNWjkFNnJswOhD3aVybkG097WtKo1Yiu3G+FPwc6rXR1+vssX4KBlW36P/ct6Cr3cClDimdV9liYcy3eF6y9AVueeRTTa0OI/nIQonskoJpdcI/a0FigqTUpggm9iqc4s3HquNgMGGxaW3Re5IopxTbdl3XHGDPa9Tm6j5LtquIUf9rS/bTMZUI6Y5oamxE/NOWWy2RNP28uMX+OW8CyDIJuXdYVQlcsxfw59zEeszvGUglYh/TqL00wJlk4G5bPCaRyEBTym+60N9zSppujE/p5qMEjyhPT+EVUKag0po5HCc7I4YCj/HlVzvatbHdwCi39/mH9wJ1cWN3tQH12nDHk4SlBUxXtifwgKIMD0/RPVbCA6Qtlv8daR5IMsbpC3L62GxPV5lrf23+toXxk0zy2wZXMt8L6JE/5xG1EBhnxPUJ/OD6Y/qKk9Mz2tG1hHfowFGlABcpM0kGz1rnjp0e773w5
 kWPSdOHd
 4vyXheQunjx+D+VIgifftF25iAMCNL2VGVx5u9yxVEKVCWJYilGkIiTYQ2Q2jkJZ2MM00j/1yDn1qHJ3ubn2+N/oBSMSjwVsieTZW2CAgLln8EgxUAHWz9IrtoKzrYjEfBN5s0Uo2zA70joo56Pn34mPugQ2hGkYkz1/LCb6dNsj+Wt0NEMGX6y2SOZftY4t60Rhz6GPOAEBRXctigQiBH6EKFb02labkK3EG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <inwardvessel@gmail.com>

Introduce BPF kfunc to access memory events, e.g.:
MEMCG_LOW, MEMCG_MAX, MEMCG_OOM, MEMCG_OOM_KILL etc.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 mm/bpf_memcontrol.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 4d9d7d909f6c..75076d682f75 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -99,6 +99,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
 	return page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+/**
+ * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
+ * @memcg: memory cgroup
+ * @event: memory event id
+ *
+ * Returns current memory event count.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
+						enum memcg_memory_event event)
+{
+	if (event >= MEMCG_NR_MEMORY_EVENTS)
+		return (unsigned long)-1;
+
+	return atomic_long_read(&memcg->memory_events[event]);
+}
+
 /**
  * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
  * @memcg: memory cgroup
@@ -133,6 +149,7 @@ BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NUL
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
 
 BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
-- 
2.52.0


