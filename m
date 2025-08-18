Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480B0CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96D38E004F; Mon, 18 Aug 2025 13:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D463F8E0013; Mon, 18 Aug 2025 13:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF9B8E004F; Mon, 18 Aug 2025 13:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 997328E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F4451609B4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:01 +0000 (UTC)
X-FDA: 83790495642.15.1B9638B
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78151140019
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:01:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z2Iw0gpu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4x/oF580ZECIilVQBke49Y0d4JocMOGaoYxAcI7yCk=;
	b=R47Oj2Q8cmWXB+RIXWWrE6KJMk6rCnaLYH0Gc8PCqsbPxmQX0xf1lzCDSfdoPZ6836dBdW
	eoPo9+nsNEA4263x0XQHwMzb6NivGbSv0uCc0KLZEHWDxbNBihF4BH6Fu+OwPd714yLlzO
	P4tNAottzytP1QiZkL5ReqdPrYbFjWg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z2Iw0gpu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536519; a=rsa-sha256;
	cv=none;
	b=e7xOgTSPdXaWejvn6Da9/0kZUPXOHEiv2eIqlk8od+hQJrdtovEGC1nlazX3zN1BLO5pK2
	HdvyObbAvxjlUGXAkDcQhV158lctXa5wTE57dq1WnuKeV1eXwjapD6lDCbH2FeLCyv2nWj
	498ZxlRknn7IB5E6GamO+8Td+5CixJA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L4x/oF580ZECIilVQBke49Y0d4JocMOGaoYxAcI7yCk=;
	b=Z2Iw0gput+/1fflbYf2ysFeYgnLOuo3q4kzRyb0+67lL+EX7r6p97LEJYkWsfd7bCEAx5J
	1hWjzQB4MXsokOE7orCwLZNINuFfdXPIqQdMjjNWV5dDpCNH8gDSOxB4hx49h8ecYAevuZ
	gmlq3d8JVscbFimgiJC+HXmEhEVEYp8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 03/14] mm: introduce bpf_oom_kill_process() bpf kfunc
Date: Mon, 18 Aug 2025 10:01:25 -0700
Message-ID: <20250818170136.209169-4-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78151140019
X-Stat-Signature: bh5c6ywcne41xufb7cz8ocbgaxpbq968
X-Rspam-User: 
X-HE-Tag: 1755536519-663944
X-HE-Meta: U2FsdGVkX19MxaX6T/FBeYEhEnKWoBxDW3Di88Su6HsH8kxbD+kEXFTl+z5PYi61hCeijIdJfbaklD+UfeSG99uOa1TyS+nFvpvWGHSET2XF24AWsZCyt4DIEjXwybDtHmPAqQ6V4lteymQeguY4mJGGc4ft1giD/SGnCwOXOlZYhsDBt8HQH+I+Kjc8KmDvffoVFYQ/z/ehiitrkAk7tB7ZJwRULb3CDu9pjd8gWa6+L0B5A5XiFkjEeDz6/injcuMgcT7fx1qkk8CMay3re8ZY3TE+CNOIB+dZz3DPMG++TC6gY3xWH9RIfRjxJ3LtBFouI4RzbD/LxMrn/fdbs/ZSjgY4ALF6bZMCSq/ZzIUA+mIL8g+hidshbg+AD5AcZfnG3Hk7KgFysoItjMuUk6J2PHdlPSlEG6DptBCCBnD127izOuMX+q0/1aUx42jcm+0pH+dQULwsShqWE8+tj/ndWV0W7Tvgo1gHQpcfsDZQifLknyLwxR70duIODj99BqYptUC743UOJhQGhNWF6C/1Gm/DVZjx8KF/mn4SAe0W+W7oZ8deo5rEya44BdrR5Yd81mYI4s2oH0qcX1v8YP+J0u3B8U6tNr3B89zPkxA50gVtLV0BkUSH9abkCxHHDJvv3wXFRkM1tHT6HSaEw1jKgLa5bz365QbA4Hhs0ks5KCykZEIy198YaeU0PlKMycaOgrOraY9775Vk4mY2Im/kYVfpNSJlBLmm19eCARvNT9ouPqH/cS1gBSM/mZ0ROvUFsNfyZN2lixheFyfRJS1Ghj3TQzWuW56hl/+QBwkloYeRR4tHjRs7yRMZfAfvjgE+QdoYEjLZ3yByPkmrUW4RLEjyhD32COnhQPK5ENVTkTjpxogn+UdV+lKcVLiVRh+9u0DGjEwqTU5ggt88U2qIWse5sEqX4o7etYGgHkkVDwR7Fdk1feKWGi3hYmKipiYNWmxwkLbbxtGI+If
 WGDpsr8l
 ndsuB8uyMd0pEpYE+iv1FYQf1TCoUZT+E32mI6jZ3xTTmATxPibehCB7IE2fmRCkGU262vNRuanyLA2iNCdEXrb4NT3cgCJXXTT2ebs9XOXh7DBDDGW3cw8MocAbWeF8pUhBxlqlAbn445QxjxwoAVEUyFcFpOPDF+dFwnCQx/vHCtNv3Np53C7Xn9WG+gkDzbcGuQ9q/Mq1lv6vphtWMYcSyQ1hX3hJzJCJv3bawWwUqbV/LpTAuqF2uug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
to be used by bpf OOM programs. It allows to kill a process
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
index ad7bd65061d6..25fc5e744e27 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1282,3 +1282,70 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
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
2.50.1


