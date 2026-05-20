Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F8FCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DF96B0092; Wed, 20 May 2026 17:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F036B0095; Wed, 20 May 2026 17:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D936B0096; Wed, 20 May 2026 17:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 550986B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:49:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0637A8D1FE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:18 +0000 (UTC)
X-FDA: 84789139596.26.ECBE9FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4580F14000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:49:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWOdtwhE;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779313756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrJdT5/Hkn1JInBKx8um+ZwIQJoC7T3gsIrsOIlTpJQ=;
	b=stOwmVFFMx5puv8NVPsG25S61uE6eZBIpgThFm1eirsyUiR9YqFnbBv2jJbdSnoUaex/6Y
	QliRfMssBLR53XrQo2XBQsSaogS1b9iQT5TfgEFseEZwWuflaAGBJ9EyUX3ctpdktf/LEL
	BtLNbmdJ6rtWkKmYu8O7MiaGWuXAnbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779313756; a=rsa-sha256;
	cv=none;
	b=uqsj3QZDvJWGa3/qdXrTI6LjdtapJxtaBpQ+TgxQkPZDNpc4Wfe2lbVjuw7CAXahetwta2
	UuFluWE/627g8LYsKdF4ZoryRSTIvrrBhrWdl1HoPLPiP0PBDLXmB+qvAWdq0JaIsyeqjl
	JHBGcVIOwuqaAEUAe1lTetCkTgHbjFg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWOdtwhE;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C41D2600FF;
	Wed, 20 May 2026 21:49:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140881F000E9;
	Wed, 20 May 2026 21:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779313755;
	bh=lrJdT5/Hkn1JInBKx8um+ZwIQJoC7T3gsIrsOIlTpJQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GWOdtwhEiy+Ywq1F0bATocbsaAD71rz+YlBhQrPH97jU5m9LKaUUygKqqT0FVRWgO
	 lv3UPcQJ18geFm0APZ+kbmdcP+ICinicjB3v5Rf14a8x4gUnNOaIMXeylsFzf3Vr7E
	 Yrrn0GQvz43CtBvfjG1Hs17AhSWKEUp26N8zFsi91B/LZEi39jMf3wlXtEoFq1FxCe
	 J22w3rc3gprAibaH9a3LWc3bPqLuAqZXDwcTLlL+02DAWjyDNqtyNsx97+2Q/xT0RW
	 KR7m7iZ9Dqf6cm/GdAeLx+9XzFCLouS+JGoXtFt4VtYgJKlBeK8lZfmH55Wtcozt96
	 g+JklGDnUFXJw==
From: "Christian Brauner (Amutable)" <brauner@kernel.org>
Date: Wed, 20 May 2026 23:48:54 +0200
Subject: [PATCH RFC v3 3/4] ptrace: add ptracer_access_allowed()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v3-3-69f895bc1385@kernel.org>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2298; i=brauner@kernel.org;
 h=from:subject:message-id; bh=W8K5dO9D9mrOIuLfw9lrPq4XuIDQC4pNK8UxrFpZggQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTx6Xhrnu2TWPSEee+xYnmD2GXVEj1SbYklfX6e3rPzb
 ndc2Liko5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLPxRgZHvCWduTWJWybLVL8
 W/9Jwe8L7AKHmDyXC7k6GamcO/x3AyND3wQzlZDdwn/rZ4ScPuOmdFlU5NK1YL7Vx03FXrcHiNx
 jBAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 4580F14000A
X-Stat-Signature: bzz1fcby6tetbcbmwsghjgxqg94m8nyo
X-Rspamd-Server: rspam06
X-HE-Tag: 1779313756-11446
X-HE-Meta: U2FsdGVkX1/cFASoS705ucpAhM7TGLEGO/x6lChA4mmthFdvoSyrVAOgEO0cKkEsCHDK5Vude7AC8hhwwO4stGoG/4BcRbwp8cGVju27ka0xg+jPDWJtGzR3Ikp+fPiMHyQ53OXLv2zMzkcnhOC/P19XnpzU47/c35BltvMuPtbv4atyAWiBQSLfmMJKpVXW3GsRATRuiWG8aAUf54YtQ8Sp5RNtgRYgx98aOGlcYUJotvw2B13AoqamNTnAHrdnQh8YSwgm1IfVSEk1pAxNLSIYoz3Q7b2HPImCmziMNl5vVkRBfA8fAyz4SQsrAMYm1RM7VrCCrhkQjco+zz0gXOzHmEVIkq8nm5VcEMQTODt3jpo7JDKe4EhxA8ODVkCd2tISrbT1Ulv4vsk2x3UyrEnfD/2DshOjwQVL9lZdyU01XUAdPNyb5I7CKAwBJzJhu2MrisGgvOLbRfyXtgpImfBD6WUaH0WLGdBwYzylkObvSM+eaBihfDDaOFB+42ZG9X6FOfXc/dGFdOytCE/NbQMqajj8KKI/8+MPYCV25nVJLWzZr0P6aHEasCH+CGWQKs23FlZPHvCvKGOPcykkPse+cwZevyaszuIl43r56RQGKtk72uzd4ZBY2mMAdpAdS4/Tob2UHzD5UarYgF9zQlpkYJX5Toyf7cLwTEhV7/4sjYL3/VFNysf7yz+3PLo2toJbH8r97pj1Nql3ivy6jZjvKG5+7NKiWLl90rnQbedsI3JJUMQaVnzWm3Th5MR8BWopD6+0couTq+gS9eEuc67DD8cYBNxUC3jZNipS954tBCwfg5dy4FjfBjc0ua4NR/lccCxnyhO80Ntm4v6TrgHNmCSY2KhSdK4Pr290sXT5wCZZpRC973xZnHfZ0qJ0A1R3cD7Eooy+GtkuwgjJLncLfiXhS8WmJmVcsD6yCT5GSDFQVpaKpLI7hsNOaQh4yBJzZpuWCptgcdtx5Uv
 /sM6CoRD
 dlAiRSUF8TrBNvu8zWO6yDc8oUBDEeMoLL0+Z6O4CEn9jeKjFjtiKEcdF86ZmtuYkFqywM9Prd2uoLB1qsD42qcEFitbbgYTQnF2FG0VhFG46QfeMb4u0ymdrDmKd+XIRjpi3I6ePh83s1nPgNXxg8PbPVVKFxdCH8+++C+y+s3f4orMinVcPABmf8tskvv0ClsTfujFYt9Z2Ldd3SKGJob93ubwuuirVvjYC8UPEwbiBomVBhq7Y4VyCVx5ZuLzJifggS6mNILHFwb6mfsI8KuUdz8yPA3u54Ne2wDC31/LrNKVeYyeeizu5ranZb0+37tWFQoxIsRKvmomwuRPF9WmeqhIE9duEHBHH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper that encapsulates all of the logic for checking ptrace
access and remove open-coded versions in follow-up patches.

Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/ptrace.h |  1 +
 kernel/ptrace.c        | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 90507d4afcd6..ef314f7a9ecc 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -17,6 +17,7 @@ struct syscall_info {
 	struct seccomp_data	data;
 };
 
+bool ptracer_access_allowed(struct task_struct *tsk);
 extern int ptrace_access_vm(struct task_struct *tsk, unsigned long addr,
 			    void *buf, int len, unsigned int gup_flags);
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 07398c9c8fe3..0e1f80f73a7f 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
 #include <linux/sched/task.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
@@ -36,6 +37,32 @@
 
 #include <asm/syscall.h>	/* for syscall_get_* */
 
+/**
+ * ptracer_access_allowed - may current peek/poke @tsk's address space?
+ * @tsk: tracee
+ *
+ * Per-access check used by ptrace_access_vm() and architecture-specific
+ * tag/register accessors.  Returns true iff current is the registered
+ * ptracer of @tsk and either @tsk is owner-dumpable or current holds
+ * CAP_SYS_PTRACE in @tsk's exec namespace.  Lighter than
+ * __ptrace_may_access(): it re-validates only dumpability and
+ * capability on every access, without re-running LSM hooks or
+ * cred_cap_issubset() checks performed at attach time.
+ */
+bool ptracer_access_allowed(struct task_struct *tsk)
+{
+	const struct task_exec_state *es;
+
+	if (!tsk->ptrace)
+		return false;
+	if (current != tsk->parent)
+		return false;
+	guard(rcu)();
+	es = task_exec_state_rcu(tsk);
+	return READ_ONCE(es->dumpable) == TASK_DUMPABLE_OWNER ||
+	       ptracer_capable(tsk, es->user_ns);
+}
+
 /*
  * Access another process' address space via ptrace.
  * Source/target buffer must be kernel space,

-- 
2.47.3


