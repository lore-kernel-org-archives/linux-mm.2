Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37BB2D25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32356B0099; Mon, 26 Jan 2026 21:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A996B009B; Mon, 26 Jan 2026 21:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF5E6B009D; Mon, 26 Jan 2026 21:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 819056B0099
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47F21140590
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:59 +0000 (UTC)
X-FDA: 84376201518.23.BCFE20A
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 90C3840009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XpnXCFjc;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h1q5g16E2+HxxmA8AEi7c9OVDnvBp79Z3yJmFR5fgE=;
	b=xnCWkD1V6mHv64ndnazFiwsG3bVWe1eEVHe5dMDjxQuCcSsO3Xf2ug3C+duVU5xqx6ETCC
	E42CcW14HBSvGsIM/urXPx+drL4IEC4R4/WCWoq3Rp6wk0P9Avc7nKooIHiIois/Wvs2mG
	bkpP+XAph8q1W/JQ2ub7HT35gnryhQk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XpnXCFjc;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481897; a=rsa-sha256;
	cv=none;
	b=23BRp1o0Y8uorCH/BulbJIahEXFZXZYQFAHPsF+TUD5odYDu0lj1WA6tZGheTOb0OBGLS4
	GU8ZiWXKthahK2zDPeouZsujx6ZG77KTlioxSbtJkZflzZywIwnqbGCReDKU89IQJlSG+f
	LecY5VSC73Q7gcoU7OTmtMBFUj4Gm+o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1h1q5g16E2+HxxmA8AEi7c9OVDnvBp79Z3yJmFR5fgE=;
	b=XpnXCFjcm8y7faBJpFYJww+jR+yGYIHG+kqWgVobyvG10nkq2uyy+a9X01QSIZXtEpruj6
	+K6dysT8+y97FCtJ8wJabeeZaRN0OhmcoXRPIezWmweIuRstHhMBlx8CDBy5DAzYxm9xII
	Oml/IlbtnEFladSFRfFwvh59cNyoa9Y=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 08/17] mm: introduce bpf_oom_kill_process() bpf kfunc
Date: Mon, 26 Jan 2026 18:44:11 -0800
Message-ID: <20260127024421.494929-9-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 90C3840009
X-Stat-Signature: x11qfgo7ck6krazqhwcssb6da7cfyddy
X-Rspam-User: 
X-HE-Tag: 1769481897-372976
X-HE-Meta: U2FsdGVkX1+X0xm8QoTE0KsEBOIuHG58G/vMIAn6PQjAeGp24DBLHoF+SXKSMBdg6SkbRJlxPk4YfDMwr7axTCXUxBJsqbNbynB9Y799lY1CbzGY4gqk7MMvL+RAZMV2UXIrmhKj1ividY3Sv3pBcdJW9dUA7wNabCV+6ZTVyDBxoMB/ulZsmXDiT8Zjwz9cYbWLat5R/dDHBeoDbdgz7CAjsc/XqEX8KxuQh5aZwcThgshhDZrZSr7Hr8sdgXPehQk38+BFz7MCjEbNg6JAu+qPp7swS08oHyj3e+ei7BNpmXP3lwx5F6ykSiDsy3VEI+HzoeuXHth27LcFlB6TsGivdShApQF2hkgD2xaVE4NGSvHrmModoruRe7W7/Cx3C0Rs59ScsUCNBtFjeyI2ubFAXlJ6wHty6SLcLaNYK7ruaSeQaZ+4slkSZPpVwa+/SCWt7JRMH8+2DHC1qXqblMRECskFIwtCwkxRc/l3iZoO25MjOFcBBh59QLa1kHwgQikfvVooHWGyUACljc+YD3H4C5ZNFj9E8muHUZDfFPvtr6RYHBm5Z9EW/ywJM5WYEZyNKPYCUaAnQQ1E41UXHDTO8LWh3iKoj/cWw0XkhC2T7NHZwTHNKg51aFuzbKo7i60yAgKGlw6Vz5u0Jpdpd4SzeFQHrYJ7HJUrcZykImp+xYTNK2twi6qYfHqipqLBYKAygm9nrebHXw1SSy6kK0ilPqavcRZQCKHQk+RpKtcvxy0wl8Bd1X+bzX1ivoVmLBgyzY/wK2eL+lyEFRlEXTkkNkvJCJtPPaNPak3Hg/BUlLTf476ELNvXCikExiHa0lqETkf5EoOFwDPuJO+pk04Z4RV0W21DqJ+CLZb9zPrJUBY54wJWy7VhJ/UfufhjzsiUmobh+WnDzyQaJbQJbqQXH819a21/yPWJssETWyFvQZG4VXtaLZADHZEsEDoOPF1f4A+YnMYc8V+FUTb
 /EyyMPpb
 7aQZypRFbp1vz93sqEvjnc6BCALAIVlEMNgZh7ORYoTpNriAtiG1Z9ExjPNhQ0zBu3buwzBIY6REtl20OfWFDuTnPY51QK41tJ22wtn+UGkvSJ+mr4VJw8TicszmROjvcT1SKdmOWNTw70Xt2SFLCi60EmsALe+e0+LcYqyYI3dR1VhGCQsYk9aBsYlCD5BREli1ammngCkGdf+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
to be used by BPF OOM programs. It allows to kill a process
in exactly the same way the OOM killer does: using the OOM reaper,
bumping corresponding memcg and global statistics, respecting
memory.oom.group etc.

On success, it sets the oom_control's bpf_memory_freed field to true,
enabling the bpf program to bypass the kernel OOM killer.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 44bbcf033804..09897597907f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -46,6 +46,7 @@
 #include <linux/cred.h>
 #include <linux/nmi.h>
 #include <linux/bpf_oom.h>
+#include <linux/btf.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -1290,3 +1291,82 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
 	return -ENOSYS;
 #endif /* CONFIG_MMU */
 }
+
+#ifdef CONFIG_BPF_SYSCALL
+
+__bpf_kfunc_start_defs();
+/**
+ * bpf_oom_kill_process - Kill a process as OOM killer
+ * @oc: pointer to oom_control structure, describes OOM context
+ * @task: task to be killed
+ * @message__str: message to print in dmesg
+ *
+ * Kill a process in a way similar to the kernel OOM killer.
+ * This means dump the necessary information to dmesg, adjust memcg
+ * statistics, leverage the oom reaper, respect memory.oom.group etc.
+ *
+ * bpf_oom_kill_process() marks the forward progress by setting
+ * oc->bpf_memory_freed. If the progress was made, the bpf program
+ * is free to decide if the kernel oom killer should be invoked.
+ * Otherwise it's enforced, so that a bad bpf program can't
+ * deadlock the machine on memory.
+ */
+__bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
+				     struct task_struct *task,
+				     const char *message__str)
+{
+	if (oom_unkillable_task(task))
+		return -EPERM;
+
+	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+		return -EINVAL;
+
+	/* paired with put_task_struct() in oom_kill_process() */
+	get_task_struct(task);
+
+	oc->chosen = task;
+
+	oom_kill_process(oc, message__str);
+
+	oc->chosen = NULL;
+	oc->bpf_memory_freed = true;
+
+	return 0;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_oom_kfuncs)
+BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_oom_kfuncs)
+
+BTF_ID_LIST_SINGLE(bpf_oom_ops_ids, struct, bpf_oom_ops)
+
+static int bpf_oom_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (prog->type != BPF_PROG_TYPE_STRUCT_OPS ||
+	    prog->aux->attach_btf_id != bpf_oom_ops_ids[0])
+		return -EACCES;
+	return 0;
+}
+
+static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_oom_kfuncs,
+	.filter         = bpf_oom_kfunc_filter,
+};
+
+static int __init bpf_oom_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_oom_kfunc_set);
+	if (err)
+		pr_warn("error while registering bpf oom kfuncs: %d", err);
+
+	return err;
+}
+late_initcall(bpf_oom_init);
+
+#endif
-- 
2.52.0


