Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B476D2D0E3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC946B0092; Tue, 13 Jan 2026 07:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3ED6B0093; Tue, 13 Jan 2026 07:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD046B0095; Tue, 13 Jan 2026 07:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 534246B0092
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:13:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 032DF1AD58B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:11 +0000 (UTC)
X-FDA: 84326830224.13.E9DB212
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C06740009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:13:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZgwgRa8l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306390; a=rsa-sha256;
	cv=none;
	b=BD/9b7Rn0X9k/sG+jMTreqWP+Lbf5D12dRWZxb6+YLr/k7gm9TtZrciCaHQj0e0jYugP7N
	0Rxz92bjCWlxq0hn47LtzyAM1MmaIW68SB+kj2V5j+DUBq9RYa6GKf0gKOmptil6ayxN6Y
	yQT8YpppxzGrbJMv4vOST5fQzW5g5cA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZgwgRa8l;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuDeTOp5vFTHpGOU7ymp4ZCToBarwKwYG+gbn6QIhuo=;
	b=c3AT7XL4MhTCciq53AqNLIAItlIkk62+QpVuUmjXi8wn4R9wpgVpXLLm/lChsSOt0Ctt/l
	cyZoGYzu5c5fZK0IOQbckRqzw5O4Pz9vI/RnGnJNFC89s6lE73eNikfeDeBEH3D13CYoMZ
	r8rVg43C2+prqHbAdylzvniHgGhpFF0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a0833b5aeeso74106855ad.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306389; x=1768911189; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kuDeTOp5vFTHpGOU7ymp4ZCToBarwKwYG+gbn6QIhuo=;
        b=ZgwgRa8l1o4E9QU9RPyGN/J04ROGcJ7XWUpwbPMAKDD4dE9nPVVIMGZSh+BYEmqT7R
         N76aUEptMar2E9bva8QBo2i4Y46Jkqxr402+QIIKjZLLTG8IAixQZiZY+l86JF4+39lk
         lG1nSFaU1283kwtmXxOLGiAHMuiAfthAtg3Di2tC+7fJhHcJkdOcJWJMHK3aLW2Ap4KD
         rwh8G2Z+luBMYCunhVCX1UgCDGh8zkdhXTE+6EBHO3PKaD3qEMWG4u85GCNgXJltpzIu
         iayrEinQ8toA665fBLGcDfF1s8MJjZ7+095GJPU66jmBst8vWBBYOT8ldiun5jaFtD4L
         ECww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306389; x=1768911189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kuDeTOp5vFTHpGOU7ymp4ZCToBarwKwYG+gbn6QIhuo=;
        b=gHhz9Bi1MPM61w0d6t1xjOtLlmgGY8fXLJ9bmAKbSnipKUq7XMkJeonX1yPNfJAPsY
         qLnfApG0DcmpQU8Gv/vHRnN3cDUSmz7AJlVMQs/BHhYVUsHqjB9abWM+LYDO2DT9vCMk
         HI60FtzkCfZ+7KVJ5wlH0W1jMZkhDPo6KngZz8kPP6AoHIcrZRJgdTwMJFd8bC94nYwF
         mZkdpxrFdwBrLJWiAzJ5+xla3wIuwo0VTv4JiAN6QUXvb66Xlgl2xhTBYjM0XkRZwOIA
         Xz7LfrLZoUgq4v7C191S9400TnScz/4rIHEjettn0EiOkulRkqNYZCK4cBxDXGRXryUp
         d9IA==
X-Forwarded-Encrypted: i=1; AJvYcCVWavB9/dAGLlHHV9jZhtIaREArchDcpA8Bv927cF2I+lVOmHJkY+/3NIl1qOsLSqpcj3VUt2wzKQ==@kvack.org
X-Gm-Message-State: AOJu0YwWz/Vt3HaiFKL/2Y1GkdgYxIkb148VqLbK7ndBBkAvoM6LePgU
	ldZQbsOvymDBnQ7tDx2wKYR2JWs7aASHav2w8xpsEriiAMd1OEmSo5wL+YTgfw8h8w8=
X-Gm-Gg: AY/fxX6XZsUa3oTOQHZXG6NWz2FUsrIVuahm5bmcsrmLXmM9HdKh6p+JsycZbTWF+f9
	ItH1Fc6ZSw1gGcWV+wPBm6EHPBMSN7ly9JUis/3l3Wv7MrvVX6bLHZUwliTSyWr+FsyHR1XjWaa
	wfQxa3ybZyITWYiQxYCag6S7FTfctqtAohU341C/GeGPEKDfw84t1WmiU5w46l8Kwq+ED1sBKw8
	pX4CBvLPE1PcPIor7SY+R84CAd8G8s8oSydOvwxBIviNJ7EBl1yHNUjq5zx1dyHn9yxxFFUFh3A
	6pK8KinWSSD1YaC3ZpHBzcxWJEqrsl8F1x8MCNUoUnN0njsEUS8kSFyzsx4VUoiUjB29CZWpvWr
	HL3DpzrQ/sHTyFDerQganQXpTXKCUXTzkwVQHfBWxNy7DEMjzgBu9CSJ3AJsEZO0MTyMsWtrs7P
	eiHqH4T26NlYzaePa1HCdkVdjJygzJaDYEkvyRZsv0OPsl
X-Google-Smtp-Source: AGHT+IH/7KH/XM9HqghYuq4Xp0l6J9YnEAXiv2p8+0oekBhp2itCclCHuYupc1TopwwPFAtakvimuA==
X-Received: by 2002:a17:902:ea11:b0:2a0:9d25:c4ca with SMTP id d9443c01a7336-2a3ee4362fbmr230310625ad.18.1768306388882;
        Tue, 13 Jan 2026 04:13:08 -0800 (PST)
Received: from localhost.localdomain ([2409:891f:1d24:c3f5:8074:4004:163:94af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e7fd708fdsm11596703b3a.65.2026.01.13.04.13.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 04:13:08 -0800 (PST)
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
Subject: [RFC PATCH bpf-next 3/3] mm: set numa balancing hot threshold with bpf
Date: Tue, 13 Jan 2026 20:12:38 +0800
Message-ID: <20260113121238.11300-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113121238.11300-1-laoar.shao@gmail.com>
References: <20260113121238.11300-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C06740009
X-Stat-Signature: 814etfqm8q8hspoopw547361ny41fjch
X-Rspam-User: 
X-HE-Tag: 1768306389-525572
X-HE-Meta: U2FsdGVkX1/tLA1LUe7LTigRtCqbZ0XAhv+MCyICsWE/3IDvUWAR0FUq5GLTPnduwoGuQxYD+yZCqADex+uu1bQuUxaANlkAcjdlKTcaCtxN2i9kxLTMEXGKBJN0tchhU4ac8ejHWlGLAexuXfbruy30be+gndguoua/yavg1sZBUqIH9ZEubcW5XO8VxrchZP9Ck5hWF9IlEClwdDAIJlJf/+Q5575uwMl7CgMmOND6nbpsh3i3rXhMhj/i9Fi6Vu97nhHreM5ztI+f5t5RsLxCbB+Sqwcoho+Kn83zSVqLY0pFjGkkV+sIorbPj/rn6BHYvO7OCrGb7fVuSNW8vlPacq9prjWmxCInxMgJ8BoxCfHjGm3ttK3x+ZqxAYAODScO8lG+Z4ZZLFHbYeV23OKcLMX0VlU5vVBSxAxJLRao5zKEU/U+WklnoqjLFXvp6lQcI5U2j4KsEGujIQICjUEI1FlB6djXYdVnyTr0IK8Q2ns+ibip90ZYn/6Ya65PiXjSaOlse0WEaegurGn7N0NTmiveAxaf2GB+yT4Y4watC9U3zBGdurgFN6Fhgwqnj08WBnoL/tf9AIsEknX3AR/X4nhLayXOUsYQjr/yxhcOxsEAzG9/0xrgSVDxgFPuce0fmEZr/32aIOZAbjuQ7nlYNei3/zwe9HlXpXqy+pNrRpfWG90nZzeF8N0N5yG4vp9epm7GAI4sHpCZ8SWCQOMtQAP0PgKSRINVMp2WRaaui+C9zR9WQjvFyHhLOIdkvHx1MsFg95Ndo12XyxsFjxR9xgp7JpcTXcCHJYA99ulv5MMRwdC0sGIxeV3I82NKDe5w0NlC4vbhoBcAICAGMafnq9b27f81sp7P9HrvxIQayJt6iJWjSHfA1oP0wqODp7IWQgkzq0T8CBZUCxPeNe7F+SpNqkmycHUFR2TQhiiEtI9l0LpkyM08I3lmWHfS8qLFlXQukWvzDi/NECs
 qNx/gdZi
 5mjyKhk8A0Lz9owi9hO7e2LVX208XVi1jer6i6eSBihtVf0tphHK4b8YJI002aehEHAE//jlhCcyq3skqMLGHviD0ZmfA0s6WMp49MSY0BbjkyTtI9VYAnVg0pbF8azGMd0BanjG+CHbr2UDNiRy/2R+TunZK1CNUesib08PcJChU6pvUAeldOMk5YQu/j5cx78SfQ4tTyvyJGK4+cpvM1zKiQ1cbMv7GlQmZO5fLqevUPp2SUkTmmzZXAkopaQr7q5ib+ApICbZb6sD1Ju00/ggNU06KyEpQzGejHg8FojH/PTNcTCu23ZuOj/MSBlaIYTZMR9QFCwr5J2Nf+YGRGV/ShyBCbTy8MQhWdYKPyijh1JTVqUkT4NW7vdIjwYdjMTbTxdS9pTo1/gflXMP5wGZXSo0O189gYfMNvqNzjj74uwQGas9YeIc6txq+r/uQ/dcSgGC4vQbOmTz+fMAuNWBJHeB5UX8MB0rUtMgm7oSmb4egO9fn1Fl2BUzkwwpM98J2lH0AN2liORDk9pAriFT0iuIsOYdyqi65TI/MdFsnNADdQVdK1xAjGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Our experimentation with NUMA balancing across our server fleet
revealed that different workloads require distinct hot thresholds.
This allows migrating the maximum number of cross-NUMA pages
while avoiding significant latency impact on sensitive workloads.

We can also configure other per-workload NUMA balancing parameters via BPF,
such as scan_size_mb in /sys/kernel/debug/sched/numa_balancing/.
This can be implemented later if the core approach proves acceptable.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/sched/numa_balancing.h |  9 +++++++++
 kernel/sched/fair.c                  |  2 +-
 kernel/sched/sched.h                 |  1 -
 mm/bpf_numa_balancing.c              | 28 ++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index c58d32ab39a7..bbf5b884aa47 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -36,7 +36,9 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false bpf_numab_enabled_key;
+extern unsigned int sysctl_numa_balancing_hot_threshold;
 int bpf_numab_hook(struct task_struct *p);
+unsigned int bpf_numab_hot_thresh(struct task_struct *p);
 static inline bool task_numab_enabled(struct task_struct *p)
 {
 	if (static_branch_unlikely(&sched_numa_balancing))
@@ -63,6 +65,13 @@ static inline bool task_numab_mode_tiering(void)
 		return true;
 	return false;
 }
+
+static inline unsigned int task_numab_hot_thresh(struct task_struct *p)
+{
+	if (!static_branch_unlikely(&bpf_numab_enabled_key))
+		return sysctl_numa_balancing_hot_threshold;
+	return bpf_numab_hot_thresh(p);
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4f6583ef83b2..d51ddd46f4be 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1917,7 +1917,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 			return true;
 		}
 
-		def_th = sysctl_numa_balancing_hot_threshold;
+		def_th = task_numab_hot_thresh(p);
 		rate_limit = MB_TO_PAGES(sysctl_numa_balancing_promote_rate_limit);
 		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1247e4b0c2b0..d72eaa472d7d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2961,7 +2961,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_hot_threshold;
 
 #ifdef CONFIG_SCHED_HRTICK
 
diff --git a/mm/bpf_numa_balancing.c b/mm/bpf_numa_balancing.c
index aac4eec7c6ba..26e80434f337 100644
--- a/mm/bpf_numa_balancing.c
+++ b/mm/bpf_numa_balancing.c
@@ -9,6 +9,7 @@ typedef int numab_fn_t(struct task_struct *p);
 
 struct bpf_numab_ops {
 	numab_fn_t *numab_hook;
+	unsigned int hot_thresh;
 
 	/* TODO:
 	 * The cgroup_id embedded in this struct is set at compile time
@@ -52,6 +53,30 @@ int bpf_numab_hook(struct task_struct *p)
 	return ret;
 }
 
+unsigned int bpf_numab_hot_thresh(struct task_struct *p)
+{
+	unsigned int ret = sysctl_numa_balancing_hot_threshold;
+	struct bpf_numab_ops *bpf_numab;
+	struct mem_cgroup *task_memcg;
+
+	if (unlikely(!p->mm))
+		return ret;
+
+	rcu_read_lock();
+	task_memcg = mem_cgroup_from_task(rcu_dereference(p->mm->owner));
+	if (!task_memcg)
+		goto out;
+
+	bpf_numab = rcu_dereference(task_memcg->bpf_numab);
+	if (!bpf_numab || !bpf_numab->hot_thresh)
+		goto out;
+
+	ret = bpf_numab->hot_thresh;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 static const struct bpf_func_proto *
 bpf_numab_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -105,6 +130,9 @@ static int bpf_numab_init_member(const struct btf_type *t,
 		 */
 		kbpf_numab->cgroup_id = ubpf_numab->cgroup_id;
 		return 1;
+	case offsetof(struct bpf_numab_ops, hot_thresh):
+		kbpf_numab->hot_thresh = ubpf_numab->hot_thresh;
+		return 1;
 	}
 	return 0;
 }
-- 
2.43.5


