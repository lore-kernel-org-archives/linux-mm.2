Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469D1606A882
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=RFKGw6fR
Received: by kanga.kvack.org (Postfix)
	id 63C966B05D7; Tue, 10 Nov 2026 15:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613716B05D8; Tue, 10 Nov 2026 15:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528BC6B05D9; Tue, 10 Nov 2026 15:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 242576B05D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:23:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B633B40A4E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:45 +0000 (UTC)
X-FDA: 85420335210.22.7C8A1EB
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id DC08120003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:23:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=RFKGw6fR;
	spf=pass (imf13.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiQmrpC/DvbapskOgQfgIZOB3UAlz4kp9CKCXyKiGBY=;
	b=8F3lILmSImkBbb0IcG2vuVx/aIXsVXLmXALh+TRNWNlPW7s2+q9JGrtYF/zl05WPuORoGT
	/Qf7kdzB1/Wlhcx/K/MDH4f7IWoQH1YYasNHjnLjDhVXTc0xEk4G2CWG+8rNsCcdMaWPQz
	KIwdjjVqSryRT//RIVJhw8pRcLl4nHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342224;
	b=C2bf2S8tTbe54GqQp5jSCQgnXtGwKOaeCTPBFzWZVRGChs4k9oVppjr7nEvJTRiNINQyID
	xswgU8miw+j1ZCPS/GjH/g+Q4fyS5h4pFYw2fO+MZCY3wQOtyPPbPEi+Ks3rfhWOITEj4t
	YXX8ovCAGFQrAyOrjumhvRqYFx7+VaE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=RFKGw6fR;
	spf=pass (imf13.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io;
	dmarc=none
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-37071c0f42aso4317373eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342223; x=1794947023; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iiQmrpC/DvbapskOgQfgIZOB3UAlz4kp9CKCXyKiGBY=;
        b=RFKGw6fR1qEMBjQ5q6+q07OC1i2Jv3h9bTEFD6CALOdv6QE0LQefXYEli8/6+6OkkS
         qbq4XrH+NuI8Dl9tWw4ezCi1GkDHq0ZuSwmetsVToXucVC5tTv6c7wQToaLp2tGvEze7
         FHQCu1X/Ir02ql5jpbdmhAj0+65oaq4bXti+EE5Vq9+wmp0k6h7ozC0UWNTe0Ay0RxA3
         znybrnhKjkDONObkrCGE082ycz6TIPc3Rx0czdku90S239hDHJ9SinM2BHkDjn32dGM6
         x/1CY363HvbF/H82sY033XRNlsk1Lg1FJqwgg/zwDvv9rMgd4f0A9M4BqEcUeWsbxJOs
         fX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342223; x=1794947023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iiQmrpC/DvbapskOgQfgIZOB3UAlz4kp9CKCXyKiGBY=;
        b=COhShJUc6OeMkguRRc9SA2U/l72oc//xKTIr6J160WldM7wuUJWhbwH4YVoSIOGmQa
         zwexVdQhhlnRYa4FZI1fR/fBSFiVh341Iks8vC88STYdGG4nkf4hLm7bGzfaEKSkx0Bo
         ZaYitH2KEHBjUX74JjfIoZAj5C8FoeVxtZbmHlPY0lNnq6z5JXqeQtwsmfv4LQkdFEWW
         2iuZmwOsEoF/dkhy8sWkoFvAZvfJQTz2yT4NbTv9zdKTgcFomfXu8cbpcUaijNuWuvqf
         5e3DHXncwycqCFUEAbFUkDxgiuo+TtEaIWNN6Z1x9EeIxnuPqk9sVwp5udu60qysNZeB
         E5Tw==
X-Forwarded-Encrypted: i=1; AL+hErF7BzG5T4npSUs+YtM49ttMwcHXnA8Wc5GA3+j4goABIqn70Lp41Y5wBzK5rM/ok8OeJQ5PjWUoUA==@kvack.org
X-Gm-Message-State: APuU4Z9VvEfWvXWmjzZi7auTsC3G0rnCGticYb1RY1egtGvAA2CSypcl
	KH/5opr701njobIqsqrF/l3DLo2YI4SmpBFiv/Pg7lW+BfDGXRaG2X+DW3Ccm0uZUajk
X-Gm-Gg: AYBFou1ofG6bBFLv1J7mhtFsLxxH+Vi8rT3eBxkqb0n5paGRHCOLf6lh0U2ZjhOtlFO
	po2iwtlNEyUbrmYRrvgLEJq0upIzxUhHkaiI/ohtSRxVFD88IxkpzV42Hv0BLzvJrcpNPAI2Ms9
	yRBo8pyn4BVHaHxModBeGjoYpI2WgPHA9Evwfs8IxYMJGFRB/lXApyxdF39DdMrXbUlmFHN/2DS
	bxdVnsCVn5JVw5DdNBXkrCCPVLKiTUlo3XgHBLQfYEGKMbhDqpYYsRkUGPVcidnTaarz7tis6Ap
	A0LqbDdJO4kcc2Cq7m/rFvQesByOlL4TGd6DTTmoXQpxapzMidhFjULG5P3MNOwzgaNJAM0P6yL
	+bnaWQ9LX25dSfS7qt3LmxYBwy77Bb9nBWcaA+wN31h1klo+nkHP6diFnzQ0JG0frLlwyKkvvZs
	YcT+LMH4490GDYnXS9YlWHwOa5gT4lRIFXjuoYgwL47s1QhEUMw6tjboLkDrr4TvTvbjoB7VXsR
	EjeylFmz8zH8/bMGb8w5C5EDJQ85sBYZw0sfjm4humufri2Ja4HpcqmoKHMBvjdJrGBrvPX5hNl
	rupxv+QWN6uWIyDRjTzZWg6FgPqExZveJzyDD/Ecu6KCEIF7lEWqRK5pAX/GOU5EeOxp0OxOxWT
	pt3Zr4Zcuv1YKnydIZV2L2T9/nBqqfulP3CeTImOWzqrvEZhE2kE5Xw==
X-Received: by 2002:a05:7301:d186:b0:369:38e3:5363 with SMTP id 5a478bee46e88-3768579fb1emr528736eec.7.1794342222184;
        Tue, 10 Nov 2026 12:23:42 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.23.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:23:41 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>,
	Kees Cook <kees@kernel.org>,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mel Gorman <mgorman@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: [RFC PATCH v3 2/6] security: kap: add the LSM ID and internal headers
Date: Wed, 11 Nov 2026 01:52:42 +0530
Message-ID: <20261110202246.274-3-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xq95tpy6qw7gdgnz8kegb1x7w4bcctj7
X-Rspamd-Queue-Id: DC08120003
X-Rspam-User: 
X-HE-Tag: 1794342223-537288
X-HE-Meta: U2FsdGVkX19FCsFHL9y0Yy7+hPYdXtiOUuOZba7ngCUB+f9GzPsdygnUZEhlfVjYpq1uQqX1F+72du8WwOwRE3gpbwRkigbD7hC8tcHyM7rg3+U1TyUkoj5EDdxkv5m6Uq7uFVza/OCexO+c8X4WQ+SNW60CzofXvUf1PxxSbCB57W9+9ArAowbX+Cs6s2lR/dqrtE72Zi5APyNn/NlF0AJAfrQLaNh9Wtka5w5qUE8YiiDJedUob4qC8NTnTV4fL01K6+8yA5uYwNDET0WYvFTDFo4e6gy2FCC3ZLiRhFQ9JxnXJaBVjOk5v+/0zGNj81uM/p7G/ekiTX1uWOJPAVv8rhO8Xuo5YYguig1r7OvukM3y4MVEVFV826WXjcuFpCGCC2WxowIK1LPnJauBHBQMoixe8f+aFoYz5zqhr+b9/rpVbHse5T2zilv43zv7pn2OJCoA5YN6cpPPxlxTYETT4t3NKoz0ZKcJQmQ4+JWKn5Tyvy2sgEw2tpY+D1cLEveU7SKZ/eKxLc3RGpiat+f/zYx2D6KFVH/fqDJj8nRXQz+xmvMINfp88f2O6an0Wk69K3+UXBg0lHmf7PyohPmaFxbKL0FUxK2E/H8+18vZg7BeYO3C0B12jRmJRTMSCeg+o85IraoqM9d97xEynMD0vsmCj7Lg7FkzQC7m4LOrzuJ2YuVBba2Jl5HP3ZYsPzO4TZh18ZdMxsS5+Qo5DdcOO3RK7vq46jRUoy1Qqhj+Tl0DASqbD6mW66zBi+uRsSCWJpkbS8N0BNKRAUNNi4ZwiDvKgYkgw4LyS0s7l46/jxGvJSRIjij0D7RPY1w1b2OWy7Wrhd4itJ39XCQHfBXAJFMAGmWsbW6ejt7bG8pExRb/UPN5Bz3RFkDvs0/6twMaLrVEZohOWOVe62I4rkutdEpY1ZXxQ/TtZaHMQNQSmMYLGZSQ7IEDvmJS2IjMeAIZpK9m0rOIANqctO/
 fKoF/fqO
 fBQAkLh91GLCM5UXwQrjCzVfROoPh2g19EzxBUYZxQ2Z6kMlLUnd4qkb9NfFskubwKLR+4/nCWF9Ei4d14RO7V5fFrnhQNa5DdqUoo5BBO8PseeD3CQRrAKd1npb2dVWI//ygX4X8RCIfS6EuC12OVBnArfCzMMMDJgDAMWCcBXm5vzMi9lF/4oN9qOQay3iURmD+fniMe37BfbGJF/MWKUUf2nKtChGGTsTMdlmXc5KdqWPJX7DQG6shVdvX814KuNZb1Z4G3xNVPv+Zav+C3kYfW1Wjah4MbnhcUR0M7gzL/RbaK7vEwPfqAvgq6/il6+65urJF2I3a9yn249wdr1qrStPOe5frZHgdBZupQdRm9XygNWlTjUlAkedkDpKlDNc26cO+D9LmGkiszVHM4WRUJVZTuWvpY3raSlfyryCYW2g7o3UjXsCY2LEekSS18BLkXXmEI3ukAfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reserve an LSM ID for KAP and add the declarations its files share.

The ID is the next free value in the target tree. It is provisional
and is for the LSM maintainers to confirm.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 include/linux/kap.h      |  16 ++++
 include/uapi/linux/lsm.h |   1 +
 security/kap/kap.h       | 159 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 include/linux/kap.h
 create mode 100644 security/kap/kap.h

diff --git a/include/linux/kap.h b/include/linux/kap.h
new file mode 100644
index 0000000..8d11d20
--- /dev/null
+++ b/include/linux/kap.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KAP_H
+#define _LINUX_KAP_H
+
+#include <linux/types.h>
+
+#ifdef CONFIG_SECURITY_KAP
+int kap_check_namespace_flags(unsigned long flags, const char *operation);
+#else
+static inline int kap_check_namespace_flags(unsigned long flags, const char *operation)
+{
+	return 0;
+}
+#endif
+
+#endif /* _LINUX_KAP_H */
diff --git a/include/uapi/linux/lsm.h b/include/uapi/linux/lsm.h
index 938593d..7cb3d64 100644
--- a/include/uapi/linux/lsm.h
+++ b/include/uapi/linux/lsm.h
@@ -65,6 +65,7 @@ struct lsm_ctx {
 #define LSM_ID_IMA		111
 #define LSM_ID_EVM		112
 #define LSM_ID_IPE		113
+#define LSM_ID_KAP		114
 
 /*
  * LSM_ATTR_XXX definitions identify different LSM attributes
diff --git a/security/kap/kap.h b/security/kap/kap.h
new file mode 100644
index 0000000..14cfe4d
--- /dev/null
+++ b/security/kap/kap.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SECURITY_KAP_H
+#define _SECURITY_KAP_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#define KAP_TASK_IGROUP_NAME_LEN 64
+
+struct dentry;
+struct task_struct;
+
+enum kap_hook_kind {
+	KAP_HOOK_EXEC,
+	KAP_HOOK_FILE,
+	KAP_HOOK_SOCKET_CONNECT,
+	KAP_HOOK_CRED,
+	KAP_HOOK_IPC,
+	KAP_HOOK_NAMESPACE,
+	KAP_HOOK_DESCRIPTOR,
+	KAP_HOOK_BPF,
+	KAP_HOOK_PTRACE,
+	KAP_HOOK_PROCFS,
+	KAP_HOOK_EXECMEM,
+	KAP_HOOK_IO_URING,
+	KAP_HOOK_LAST = KAP_HOOK_IO_URING,
+};
+
+struct kap_task_state {
+	bool active;
+	u64 epoch;
+	char igroup_name[KAP_TASK_IGROUP_NAME_LEN];
+};
+
+struct kap_task_state *kap_task_state(struct task_struct *task);
+bool kap_fail_closed_kind(enum kap_hook_kind kind);
+int kap_check_current_target_why(enum kap_hook_kind kind, const char *target,
+				 const char **why);
+int kap_check_current_emit(enum kap_hook_kind kind, const void *object,
+			   const char *deny_reason, const char *allow_reason);
+int kap_check_current_target_emit(enum kap_hook_kind kind, const char *target,
+				  const char *deny_reason, const char *allow_reason);
+void kap_emit_current_event_target(enum kap_hook_kind kind, int decision,
+				   const char *reason, const char *target);
+
+/* Shared between the policy engine (igroup.c) and the control plane (kapfs.c). */
+#define KAP_MAX_NAME_LEN 63
+#define KAP_MAX_ROOT_LEN 64
+#define KAP_MAX_PREDICATE_BYTES 65536
+#define KAP_MAX_EVENTS_BYTES 65536
+/* The install document is the authority plus a few short header lines. */
+#define KAP_MAX_INSTALL_BYTES (KAP_MAX_PREDICATE_BYTES + 1024)
+
+enum kap_file_kind {
+	KAP_FILE_PROCS,
+	KAP_FILE_IGFD,
+	KAP_FILE_LINEAGE_ROOT,
+	KAP_FILE_AUTHORITY_EPOCH,
+	KAP_FILE_AUTHORITY,
+	KAP_FILE_TRANSITION,
+	KAP_FILE_MODE,
+	KAP_FILE_EVENTS,
+	KAP_FILE_EXPIRES_AT,
+	KAP_FILE_INSTALL,
+	KAP_FILE_COUNT,
+	/* Filesystem-wide, not created per igroup, so it sits past the count. */
+	KAP_FILE_DEFAULT = KAP_FILE_COUNT,
+};
+
+struct kap_igroup;
+
+struct kap_file_ctx {
+	enum kap_file_kind kind;
+	struct kap_igroup *igroup;
+};
+
+struct kap_bound_pid {
+	pid_t pid;
+	struct list_head node;
+};
+
+/*
+ * Predicates are compiled once at install, so a decision only walks an array.
+ * Patterns are interned into one pool and referenced by offset, so the whole
+ * thing is a flat allocation and a decision allocates nothing.
+ *
+ * The pool is sized to the authority document itself, so any document that is
+ * accepted can be compiled: a pattern costs strlen + 1 here and at least
+ * strlen + 2 in the document because of its surrounding quotes. Each set's
+ * patterns are laid out contiguously and walked by length, so there is no
+ * per-set entry limit either.
+ */
+struct kap_pattern_set {
+	u32 offset;
+	u32 count;
+};
+
+struct kap_compiled_authority {
+	char pool[KAP_MAX_PREDICATE_BYTES];
+	u32 pool_used;
+	struct kap_pattern_set allow[KAP_HOOK_LAST + 1];
+	struct kap_pattern_set deny[KAP_HOOK_LAST + 1];
+};
+
+struct kap_igroup {
+	char name[KAP_MAX_NAME_LEN + 1];
+	u64 epoch;
+	bool revoked;
+	bool has_sequence;
+	u64 last_sequence;
+	char lineage_root[KAP_MAX_ROOT_LEN + 1];
+	char authority[KAP_MAX_PREDICATE_BYTES];
+	size_t authority_len;
+	/* Expiry in Unix seconds, 0 for none. */
+	u64 expires_at;
+	/* Swapped wholesale on a successful install; NULL until the first one. */
+	struct kap_compiled_authority *compiled;
+	char events[KAP_MAX_EVENTS_BYTES];
+	size_t events_len;
+	struct kap_file_ctx files[KAP_FILE_COUNT];
+	struct list_head pids;
+	struct list_head node;
+	struct dentry *dentry;
+};
+
+struct kap_install_request {
+	char lineage_root[KAP_MAX_ROOT_LEN + 1];
+	u64 epoch;
+	u64 expires_at;
+	u64 sequence;
+	/* Points into the caller's buffer, which outlives this request. */
+	const char *authority;
+	bool have_root;
+	bool have_epoch;
+	bool have_expires_at;
+	bool have_transition;
+	bool have_authority;
+};
+
+extern struct list_head kap_igroups;
+extern spinlock_t kap_lock;
+extern bool kap_lsm_active;
+extern bool kap_ready;
+extern bool kap_default_closed;
+
+struct kap_igroup *kap_find_igroup_locked(const char *name);
+int kap_bind_pid_locked(struct kap_igroup *igroup, pid_t pid,
+			struct kap_bound_pid **entry);
+int kap_parse_transition_sequence(const char *payload, u64 *sequence);
+int kap_install_parse(char *payload, struct kap_install_request *req);
+int kap_authority_prepare(const char *doc, struct kap_compiled_authority **out);
+int kap_install_locked(struct kap_igroup *igroup,
+		       const struct kap_install_request *req,
+		       struct kap_compiled_authority **compiled);
+void kap_trim_newline(char *value);
+int kap_securityfs_init(void);
+
+#endif /* _SECURITY_KAP_H */
-- 
2.53.0


