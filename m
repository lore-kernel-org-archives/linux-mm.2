Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD8CD2D0E4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847F56B008A; Tue, 13 Jan 2026 07:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F1B6B008C; Tue, 13 Jan 2026 07:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2C56B0092; Tue, 13 Jan 2026 07:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 595046B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:13:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26661C164C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:07 +0000 (UTC)
X-FDA: 84326830014.07.95FF7D7
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3F01D40007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WTD+Yaxg;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn6xpjrnCqbqcpG1ijdeHcwn4K62gY18RMymEm3vNG0=;
	b=HUN8ybJjjqMAkfryJ2jxVPovySY2Jo6FEiaNMEPMgyi2MwwU/drRRpB7c5BJgPPYYq/1fi
	UuztnTlR/3QG3nPmCXP1Yz6bMVPTNKx6lTVWmU7QsP0jcEQ23uuKGFup67N1H9H8sF2V72
	hZLaBx2Bp1q7vvscWJb4MKhpPG+vVhM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WTD+Yaxg;
	spf=pass (imf17.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306385; a=rsa-sha256;
	cv=none;
	b=WITsDqMY9EH+PjZOFUfPF6g1JlCDGY0kTDyRGlCqZf6QJdsNfVBsEdtjRoeSRDeRwPp4TX
	ykJdiy7NsAIgFxz+vdg6OvSvAWl7bXrqt7fnMh87vMM7XrW3eNB+n8PbQ2Tcqmk0er+waY
	MsMDx2egIxMXmv2jFyU/mBzECMxkI7U=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81e98a1f55eso1911339b3a.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306384; x=1768911184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yn6xpjrnCqbqcpG1ijdeHcwn4K62gY18RMymEm3vNG0=;
        b=WTD+YaxgkjtbCj8gV3PNoUy2bRIPa7RrI81mblLw9zaAPDUKI/6dCPKjWebvoYof7O
         WeoEa/5KONe39pHh4T5Dqcn1nQazQYtYNFUSD6pJZnma+KGYTJ5wX5fdAU0BLWk5H48r
         BJ2I2GUs9YqTso5OM7A6iVNln96O5Dl/JRsSE4KB0r4TxRJIdhuJYU3sH4JWLxUCx8if
         kb2wXUkKlGmJev36l1Sg8H34Uj2zbI9mdRNkYtsJ5LHIIxW5HjnTJgxX9dfTlml3COyM
         PQZH9wf88/ul+NKq0Hh0xvJs4xZlZg/yZI/Q86ARRaEKqELLHeIp+0Xk6aPc3dkhjWuH
         Y4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306384; x=1768911184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yn6xpjrnCqbqcpG1ijdeHcwn4K62gY18RMymEm3vNG0=;
        b=E5CmV5m5I1tUdRrZ2r+bUbxuI9wyKiD9dE2ddE5o9RuwPSRrh6/NEsY3tYZ+MLSTyJ
         Cp+NSYtzvoKMvVFRTiqSad52d8T8qJy3/0fuK+x+3fMvT5Kb+BYKCIY0JCrxDUJ1wD6R
         wXIDdfMPMW51mHDjJnScmrD4O4gS9fveZm912oXmy6JujDUzUB91qQUIax/1J9PA/+fD
         RApEiHvl+T9MPRkddBgmtegwfi8RKwuNIzQMlfSSEloN3dtPASPGRqHQQDkBL8mhAAL/
         xGbRQeAFoXynhJR2eyxwlgrbOBdTY1/5QHrnfgbNH5FN+ggti4l7yWCU1jbkJm5PPLCo
         SdFA==
X-Forwarded-Encrypted: i=1; AJvYcCW0/KModrffXbzPL1pdnYqag/payqPYjpI02+nLCj1lVL757+Wdj/idxftKT8DMQtK2sQmLg7POpA==@kvack.org
X-Gm-Message-State: AOJu0YznOWmrJrvMvfvUxqpFrRQdFS2K7MkJZSaR+X2g/WDXYFcjGpne
	PaZ1XKB8rpMTc78q7I22e//Mf30009wFg9a14SzuB6EjZhTxBQmVySJs
X-Gm-Gg: AY/fxX7bkrgEq5gUXeL6F654/xKxFgGYYpCUd5h6x45iEForCBh9E0Mo/gRAWFn11Ra
	/m2gwur2lXJ3q2pFuH+BvWN4v2rF5m4UihUlI1U4NTb8jARRR+TNBAbOw3zkYN/xc1LQdATGpF/
	9Z+Gs0ngrieuSds3looJLT0srV4AUyarAet7IUayTGoe6jOiPs7iJ2pj+cazCiluiAuNf7epTwy
	2UycIMAa3pndtPbQj12cufnevLfybX2r7IEo+6m6XspHdu+pYVVAXzjkgDnkaUmlfl5iUtAh6rj
	+3rDVqW9ADmc+obeVMJPN4Uh+O0eUDbAIYx2c8z+ZBEmnWbhHhnacAOGbZjfbf9GBPaJFncbowz
	UcfFN7Q6fmW8VF1DoevoDcpBAfkiMNi+V4O/PCr4OwC/YIBMV3clz9mtDWnGnc6gBOTVKImAtV9
	477FNiC7g2pLj7HiWkAGPeXoil9q9LZYDzwvpxQ2Ngj6cXCoSnGTY42JQ=
X-Google-Smtp-Source: AGHT+IGmz5X7RmHTN7Om3Y73fhpr1DCMUZXlhaYVrlBKhzxTpjZRQOCkR/MHPw9SZol8kY+ggzWVcg==
X-Received: by 2002:a05:6a00:6c91:b0:81f:3d13:e070 with SMTP id d2e1a72fcca58-81f3d13e574mr9704595b3a.12.1768306384014;
        Tue, 13 Jan 2026 04:13:04 -0800 (PST)
Received: from localhost.localdomain ([2409:891f:1d24:c3f5:8074:4004:163:94af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e7fd708fdsm11596703b3a.65.2026.01.13.04.12.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 04:13:03 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	mkoutny@suse.com,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa balancing
Date: Tue, 13 Jan 2026 20:12:37 +0800
Message-ID: <20260113121238.11300-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113121238.11300-1-laoar.shao@gmail.com>
References: <20260113121238.11300-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c4149wesm3mpaiuqgboqg1gnamure3i1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F01D40007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768306385-521383
X-HE-Meta: U2FsdGVkX1/Yv5Il0gJyjwcTLWVfe/0aqyUKEWPjXczWVlRU7yI3K0rjNcKRBaI/pUXdtSHXifwVQd/Ag3mqpwQjMP8LvB29VMd88oZ1WEJzBD64mIIrv2XrNnpdLJmeNW/nV5UjVkt63K6//GWPIFYq2GfynYgP0E8w1sjbdASs2k0qUKFhQ6U8SePJRbGBMX4qslr0Qor5gjE6m++pzoZr/nkfqwXFlKR5n2yqw1aiDeUZiuEZFXCVAu+ci2Ejhz2KMNutTh6sdKvyNrJMHNT3O7L2ike+aZA6u/UXzo3uzzttqLTn5PidOdM/kxPZWGozU1IYjWkEjiEeebujy7y2V0YZlCuIGPmT07jdIUoqWzyXZDhLMGJ6WpIGRahzIZaHNr7A4kXxgS1IOpP8ilkxh1B6EsuVoVlLOYAP+VY9vPsEEpBoGHx4gRmeKx79EV+PuDLRpC/hBeyhThsODdyzvbwAQhm/4+v1ET/Q2HS07oQiM2ZZ/Qtzdvm/yeiqNKgqDhH6AZCF9hQURxkf1njXpWC2G+pebIItPIo1G478BYeJA/W7mSrqMZwDZGIEdGq3GqHiai8ahlfRF98NBBUO+5j/Yf4uF0KYc/+71BCsHjCgb/qEB9/KeL7buB/8W4iR8Rc1GYxWjBcVAItalSDPdPEtzyoWHYjRFi/0U+MtTgy+1+3ArAvR0Pl3YJ0fHctI1D7t7/l3kG1pNakXrZRmcdKR81eutG4AZkpNW/IL4avI5tA/5fY7vqQczg+ZflEBn8Hwx3yU78KkvraGzsUyrZe5q+Xx/D+o5nThnHa78FJ+LNtm0NwY77KJfQ7jHhcmVEJo/DPrTcACGK/ooKAE9GVoVGWJqFMPi8VxKTXD/INK1xETFis1voZfNS1lX24fi2OL4Q1L7xUuY0CI6GONoyD7c45QPadRZxvTa+plNuNlQNqhAk2K2/nhRyPw4tvqMzPKHSAHGlt2gPK
 v7oFwtQJ
 wQXrNDZChcD0a6jweK9Um+csa8foEnF0M3iwjtWpiJxPoS1NXuJ2R8Yb7ps2ctJ0g1GziRYWXRhY0fk+mydqbLKui2zov4TqmWZvPmX6eDVI1O59qfCNejJnPKzvTl2C1U6DUyo/4kW0yINcsQ98eVJONZPk1Aj0qmr+5ewYJ5SeFcbLWx6SzGhTcFXVQNoyz8oRdtbniyMQJJ3SrQ8bbZF5ZspBr1NsVHRe2rsvk5eK+ZF9lpjMZaUX0Fc/Vf8AaHX+6lB80HclrMOeFaz9ax1j7SBN0XWqiHq/AshJw+1UjM8ixmV7LD9d2ABZ9IxpWzbvsBr4tBcI6/ROTqL9t7ZPqJFjbFMbYEZBnpPY51+ENbRZ0HrVu9hd9VtY8vtIYxewB8QjtHq3+lTfPWGYnawOVY7Op02RWw7+hK8eDS8Okf+hHroiYY/FxRlRoM5BOFSzwhmrCxYGVNcHfUeI/jasbkd3SHhdIkQ3Bxn1bBrPidZA7FrXqS8l7U6wE72ZuKPBOzECKlLhQF0GpQErgY087/bgpTt7k4pKonPeanYWb6xnim2iTzNN2l8BS2g579tMxz3c2OzyHXfOY3V1NaJIcfZK70p1hHr6w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bpf_numab_ops enables NUMA balancing for tasks within a specific memcg,
even when global NUMA balancing is disabled. This allows selective NUMA
optimization for workloads that benefit from it, while avoiding potential
latency spikes for other workloads.

The policy must be attached to a leaf memory cgroup. To reduce lookup
overhead, we can cache memcg::bpf_numab in the mm_struct of tasks within
the memcg when it becomes a performance bottleneck.

The cgroup ID is embedded in bpf_numab_ops as a compile-time constant,
which restricts each instance to a single cgroup and prevents attachment
to multiple cgroups. Roman is working on a solution to remove this
limitation, after which we can migrate to the new approach.

Currently only the normal mode is supported.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS                          |   1 +
 include/linux/memcontrol.h           |   6 +
 include/linux/sched/numa_balancing.h |  10 +-
 mm/Makefile                          |   5 +
 mm/bpf_numa_balancing.c              | 224 +++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 1 deletion(-)
 create mode 100644 mm/bpf_numa_balancing.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 70c2b73b3941..0d2c083557e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4807,6 +4807,7 @@ L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/bpf_memcontrol.c
+F:	mm/bpf_numa_balancing.c
 
 BPF [MISC]
 L:	bpf@vger.kernel.org
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 229ac9835adb..b02e8f380275 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -29,6 +29,7 @@ struct obj_cgroup;
 struct page;
 struct mm_struct;
 struct kmem_cache;
+struct bpf_numab_ops;
 
 /* Cgroup-specific page state, on top of universal node page state */
 enum memcg_stat_item {
@@ -284,6 +285,11 @@ struct mem_cgroup {
 	struct lru_gen_mm_list mm_list;
 #endif
 
+#ifdef CONFIG_BPF
+	/* per cgroup NUMA balancing control */
+	struct bpf_numab_ops __rcu *bpf_numab;
+#endif
+
 #ifdef CONFIG_MEMCG_V1
 	/* Legacy consumer-oriented counters */
 	struct page_counter kmem;		/* v1 only */
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 792b6665f476..c58d32ab39a7 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -35,17 +35,25 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu);
 
 extern struct static_key_false sched_numa_balancing;
+extern struct static_key_false bpf_numab_enabled_key;
+int bpf_numab_hook(struct task_struct *p);
 static inline bool task_numab_enabled(struct task_struct *p)
 {
 	if (static_branch_unlikely(&sched_numa_balancing))
 		return true;
-	return false;
+	if (!static_branch_unlikely(&bpf_numab_enabled_key))
+		return false;
+
+	/* A BPF prog is attached. */
+	return bpf_numab_hook(p);
 }
 
 static inline bool task_numab_mode_normal(void)
 {
 	if (sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL)
 		return true;
+	if (static_branch_unlikely(&bpf_numab_enabled_key))
+		return true;
 	return false;
 }
 
diff --git a/mm/Makefile b/mm/Makefile
index bf46fe31dc14..c2b887491f09 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -107,8 +107,13 @@ ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
 ifdef CONFIG_BPF_SYSCALL
+ifdef CONFIG_NUMA_BALANCING
 obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
 endif
+endif
+ifdef CONFIG_BPF_SYSCALL
+obj-$(CONFIG_MEMCG) += bpf_numa_balancing.o
+endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
diff --git a/mm/bpf_numa_balancing.c b/mm/bpf_numa_balancing.c
new file mode 100644
index 000000000000..aac4eec7c6ba
--- /dev/null
+++ b/mm/bpf_numa_balancing.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/numa_balancing.h>
+
+typedef int numab_fn_t(struct task_struct *p);
+
+struct bpf_numab_ops {
+	numab_fn_t *numab_hook;
+
+	/* TODO:
+	 * The cgroup_id embedded in this struct is set at compile time
+	 * and cannot be modified during BPF program attach time.
+	 * Modifying it at attach time requires libbpf support,
+	 * which is currently under development by Roman.
+	 */
+	int cgroup_id;
+};
+
+static DEFINE_SPINLOCK(numab_ops_lock);
+DEFINE_STATIC_KEY_FALSE(bpf_numab_enabled_key);
+
+int bpf_numab_hook(struct task_struct *p)
+{
+	struct bpf_numab_ops *bpf_numab;
+	struct mem_cgroup *task_memcg;
+	int ret = 0;
+
+	if (!p->mm)
+		return 0;
+
+	/* We can cache memcg::bpf_numab to mm::bpf_numab if it becomes a bettleneck */
+	rcu_read_lock();
+	task_memcg = mem_cgroup_from_task(rcu_dereference(p->mm->owner));
+	if (!task_memcg)
+		goto out;
+
+	/* Users can install BPF NUMA policies on leaf memory cgroups.
+	 * This eliminates the need to traverse the cgroup hierarchy or
+	 * propagate policies during registration, simplifying the kernel design.
+	 */
+	bpf_numab = rcu_dereference(task_memcg->bpf_numab);
+	if (!bpf_numab || !bpf_numab->numab_hook)
+		goto out;
+
+	ret = bpf_numab->numab_hook(p);
+
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
+static const struct bpf_func_proto *
+bpf_numab_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static bool bpf_numab_ops_is_valid_access(int off, int size,
+					  enum bpf_access_type type,
+					  const struct bpf_prog *prog,
+					  struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_verifier_ops bpf_numab_verifier_ops = {
+	.get_func_proto = bpf_numab_get_func_proto,
+	.is_valid_access = bpf_numab_ops_is_valid_access,
+};
+
+static int bpf_numab_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_numab_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	/* The call site operates under RCU protection. */
+	if (prog->sleepable)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_numab_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	const struct bpf_numab_ops *ubpf_numab;
+	struct bpf_numab_ops *kbpf_numab;
+	u32 moff;
+
+	ubpf_numab = (const struct bpf_numab_ops *)udata;
+	kbpf_numab = (struct bpf_numab_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+	switch (moff) {
+	case offsetof(struct bpf_numab_ops, cgroup_id):
+		/* bpf_struct_ops only handles func ptrs and zero-ed members.
+		 * Return 1 to bypass the default handler.
+		 */
+		kbpf_numab->cgroup_id = ubpf_numab->cgroup_id;
+		return 1;
+	}
+	return 0;
+}
+
+static int bpf_numab_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_numab_ops *ops = kdata;
+	struct mem_cgroup *memcg;
+	int err = 0;
+
+	/* Only the link mode is supported. */
+	if (!link)
+		return -EOPNOTSUPP;
+
+	/* Depends on CONFIG_SHRINKER_DEBUG */
+	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
+	if (!memcg || IS_ERR(memcg))
+		return -ENOENT;
+
+	spin_lock(&numab_ops_lock);
+	/* Each memory cgroup can have at most one attached BPF program to ensure
+	 * exclusive control and avoid interference between different BPF policies.
+	 */
+	if (rcu_access_pointer(memcg->bpf_numab)) {
+		err = -EBUSY;
+		goto out;
+	}
+	rcu_assign_pointer(memcg->bpf_numab, ops);
+	spin_unlock(&numab_ops_lock);
+	static_branch_inc(&bpf_numab_enabled_key);
+
+out:
+	mem_cgroup_put(memcg);
+	return err;
+}
+
+static void bpf_numab_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_numab_ops *ops = kdata;
+	struct mem_cgroup *memcg;
+
+	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
+	if (!memcg)
+		return;
+
+	spin_lock(&numab_ops_lock);
+	if (!rcu_access_pointer(memcg->bpf_numab)) {
+		spin_unlock(&numab_ops_lock);
+		return;
+	}
+	rcu_replace_pointer(memcg->bpf_numab, NULL, lockdep_is_held(&numab_ops_lock));
+	spin_unlock(&numab_ops_lock);
+	static_branch_dec(&bpf_numab_enabled_key);
+	synchronize_rcu();
+}
+
+static int bpf_numab_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_numab_ops *ops = kdata;
+	struct mem_cgroup *memcg;
+
+	memcg = mem_cgroup_get_from_ino(ops->cgroup_id);
+	if (!memcg)
+		return -EINVAL;
+
+	spin_lock(&numab_ops_lock);
+	/* The update can proceed regardless of whether memcg->bpf_numab has been previously set. */
+	rcu_replace_pointer(memcg->bpf_numab, ops, lockdep_is_held(&numab_ops_lock));
+	spin_unlock(&numab_ops_lock);
+	synchronize_rcu();
+	return 0;
+}
+
+static int bpf_numab_validate(void *kdata)
+{
+	struct bpf_numab_ops *ops = kdata;
+
+	if (!ops->numab_hook) {
+		pr_err("bpf_numab: required ops isn't implemented\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int bpf_numa_balancing(struct task_struct *p)
+{
+	return 1;
+}
+
+static struct bpf_numab_ops __bpf_numab_ops = {
+	.numab_hook = (numab_fn_t *)bpf_numa_balancing,
+};
+
+static struct bpf_struct_ops bpf_bpf_numab_ops = {
+	.verifier_ops = &bpf_numab_verifier_ops,
+	.init = bpf_numab_init,
+	.check_member = bpf_numab_check_member,
+	.init_member = bpf_numab_init_member,
+	.reg = bpf_numab_reg,
+	.unreg = bpf_numab_unreg,
+	.update = bpf_numab_update,
+	.validate = bpf_numab_validate,
+	.cfi_stubs = &__bpf_numab_ops,
+	.owner = THIS_MODULE,
+	.name = "bpf_numab_ops",
+};
+
+static int __init bpf_numab_ops_init(void)
+{
+	int err;
+
+	err = register_bpf_struct_ops(&bpf_bpf_numab_ops, bpf_numab_ops);
+	if (err)
+		pr_err("bpf_numab: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_numab_ops_init);
-- 
2.43.5


