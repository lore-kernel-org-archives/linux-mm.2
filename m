Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D95FCCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68E9800AF; Mon, 27 Oct 2025 19:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17ED8009B; Mon, 27 Oct 2025 19:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0764800AF; Mon, 27 Oct 2025 19:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2BF8009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:18:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2244F1602A2
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:10 +0000 (UTC)
X-FDA: 84045459540.01.3270499
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 795EF40009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ROkJHcpF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRMoLOPHk0Zw/08DZLynFUa0w3uLlt8Rci/TaWmsNjU=;
	b=sM12eOWDHTz6FK4ZICuGWElCjx/dvJmTvRBvv/M163kkKCKPjx+sHz02mXjLfaeOL5LYnA
	FEDESxF96kjTajdz1SQGPRGW2u8W8C9f92o20LQs2hscZy6mVI5+7SVBKurvPLd8lmHDaJ
	nvf8QP5S7r19cyQQHqEwqPA4FhRZGY8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607088; a=rsa-sha256;
	cv=none;
	b=maivITRZo013mawgkR4VK26uRciSiGFqtZZvTT5njSPQu+6v7LtlyPn/PHxxRn2T+vQhsx
	bPid2+V6bYKFfvcSEHLXiNkqP2YMxlNmjIzdF67sbl8ZugqSgN4CMVxIGXtHdpeD3K6yVY
	lMh6E/Vfmo/nb0OVNoypjOGbqcLF2F4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ROkJHcpF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRMoLOPHk0Zw/08DZLynFUa0w3uLlt8Rci/TaWmsNjU=;
	b=ROkJHcpFJxR287s1ClvLk0n/MitKV8WJh8dlnZNiqyODiF+DR+ny7u/TdxVPmSWMwOxXEA
	aG8phPsu61dTRGejYx6hsc27/+yhxZxEHIVm2FOjrHFgLToswrU8B8vcFnIZSlzRpdj6Yk
	eGBpTppxkOy3tz5kgupq5haQ1I+SjVg=
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
Subject: [PATCH v2 07/23] mm: introduce bpf_oom_kill_process() bpf kfunc
Date: Mon, 27 Oct 2025 16:17:10 -0700
Message-ID: <20251027231727.472628-8-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 795EF40009
X-Rspamd-Server: rspam02
X-Stat-Signature: goisjybdsajcqojnkezdx9swahuj4481
X-HE-Tag: 1761607088-741732
X-HE-Meta: U2FsdGVkX1+HZ3zrqLht9EOpLsqLpDbjxOakzPNDkJ6ryllclQTBFLGALY+eKNoQR0MctjwqWPD9AuD6OaUIr5VvXWingc6OUqt939aT27ymILcquh8cRMZAj2Wv82Q/x1w51KdY0MeAB+8C4Ostqgz17udrdsGNG/wTGbQzVdhfg6t+8piq0FXnAxT8axe+24PN1+pi0XWPliFtp4aHVzLivDUUBpiA7BveIiFk7rm7F6W1zh4FBNmM2ZvbDzoO+myILr0sUQAtZnXlNeFGdlgma4C3pjBmHAj2OLcM45QwKabgqLSzgj1H5bJZbS2nUDeNBa74iuuGE4rWURE2jY5SLkiL89UIYDyfl8l/4Y3mmSvyRAnWuTSpA+m+gZ1Y3A+Y8V0B7WMnUDgD8DaPA7p4BkV1NibpzRxzHzwoU4NxyCda4gXl2yMII1acN4xf+SxwCyu7n4wrqFJ29p3xblacAXk6B2eoSkPnw7bfqI6xx0TluflNfEIMFblZRN6wPfim+OgYn3TT8fzEc3fytb1Vzw8fSPQuHcT+OrM4VK2endCwUvyTuQSxQborDtSHC6EHIJxdGUsJcLBpzFEgxrSSygCKhm253ku9InfEtVmbjsf+uZBHaVt4XkiIB9MosurbjK284LZ66hv1lWleMOZVWkjVP3htfdxJqC+YTAOGQ7YvDX1+7PpGa4Ron5BQPUUxVqm01EthYdKJzmhfDAz12uoDWdjYIQ5KOXz9Ulq2Ezm8ptANZRU/FFWLLbunYZIVy0bbS1WhChHAT/zYNp7w8iYZsrMHkLqmDb0IXsimNsMxrGwiIgkLc1GnPCRM9/53XMSlAsYPLuLSv3PXdWE/70pljJwqI0FZI79mnOtJvqwm8GFGrW6SDn0SDWIzt8WyqAd1eAOm/yn/rZ+QDtBldxFEnrmUqf4Zo/yCg1RkfjV0gWt2i5KsYLBeoXdRkSYrBW4MbYAkpki4UNP
 i547aTJD
 qbcYrPSFQGQS2TMz6JipjgD5r+gavRGflwKbfK8HRbJTRprlbnIMHtwEeum6rumgRWQrc2VRBYJmfbzmAbFL3HQhbq1qyR9kNDXZ+dsQ8UuULmzWv0OKhGX7ZQFhW4HTaVVyAyQeVaC1lZz7yb8DlNpKJWmMOooA3jKw/1ile12rf/wUtqDOvvpi4eGBwdXTSEBC5JlRAvN9rLU5q07gnCPOm8j5iEZMjEKmO7nFxtryy7p5Segb23t49Fg==
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

On success, it sets om_control's bpf_memory_freed field to true,
enabling the bpf program to bypass the kernel OOM killer.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/oom_kill.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index d05ec0f84087..3c86cd755371 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1288,3 +1288,70 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
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
+	/* paired with put_task_struct() in oom_kill_process() */
+	task = tryget_task_struct(task);
+	if (!task)
+		return -EINVAL;
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
+BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
+BTF_KFUNCS_END(bpf_oom_kfuncs)
+
+static const struct btf_kfunc_id_set bpf_oom_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_oom_kfuncs,
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
2.51.0


