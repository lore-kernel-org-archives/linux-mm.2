Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31347606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qrMAig+v
Received: by kanga.kvack.org (Postfix)
	id 5ADA46B05BA; Mon, 23 Nov 2026 06:44:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584BA6B05BB; Mon, 23 Nov 2026 06:44:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4996A6B05BC; Mon, 23 Nov 2026 06:44:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4A36B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDBD180828
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:24 +0000 (UTC)
X-FDA: 85466200848.20.30CE98B
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id D74A4A0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=qrMAig+v;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.177 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434263;
	b=nv2LRGYzDnhtlB59Hfkjulj/YqYFu7VygBLzr7ykc6jLlmboZRivBbggMnGkVpuM5UaIC+
	kIG2ZPEKficqAs6Aj2HHEHEN32Zv7DLNfFWJ9f8KTxvUeAY0GDc/Top6pzZUHWGpYzck0h
	yRY21YXoy9YZG0P5rlBcPt2AznI7XV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnvDig0dM1QComfuK2OvYInYk5xj0Tm4ODFeUP2YM9Y=;
	b=liKAK2RoVlw9BSjkL3w/OXBqie/RgLc1y0RdpWwUTb0+jg2Kv7raUYwbPILVXpTcTKmH/U
	f1O7/DMrzNEbn359z29uUhklMxU7FVXPiPwuOWmmtVmfE5T3jEaYglth8pBwDEJzEl/+Zp
	AWE9f3LiTwDvi0dkwwG/n6O707yK8mI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=qrMAig+v;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.177 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3866a784546so3981050eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434262; x=1796039062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnvDig0dM1QComfuK2OvYInYk5xj0Tm4ODFeUP2YM9Y=;
        b=qrMAig+vQOECa66ZQ1d+pXs29VErJ5WpHDGUUCxLdRXHtq/HZ/G4q4xNz7jMlk91T5
         74zZqzkDkymoni0X8uHrIrtlKnc1Mg4swWXYOYdrR8XqMAumgtz/kTud/zL84ezx50aN
         fQnDlslafQn0MSVrk05C5L4yXaLSvuNEI128pfuLokF9GHUbwEscyPqVlO+h5AqtEg7J
         AVicIlgyFFFOEMEHrF6fG85Y+sRpRH8VuibSLXwXa0zmnoNycUpEtjVMN70dmz7UKdA4
         N/wX1BWNXihi2mywHs1zZFGIL3S13hlj680l9r26s/HIHmgspWRCTnxJonwLF0zZoPcZ
         KslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434262; x=1796039062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnvDig0dM1QComfuK2OvYInYk5xj0Tm4ODFeUP2YM9Y=;
        b=ACEkoSVfae4+V2TFm7Mz7Cv5uu0K577ApyIkTbz6v5+A7jydXh1V3s0P/wNuWZeAtG
         PkXrX3KE4MAy1F6JsP1csVV73SfnCO52tJn1aFtn75eyRHvso34fF+W2BCmUeD7TkudN
         3NoKvPKTGIP+opFWjx63yUKM0l6VL5e210L4NBGgAS6wzv0H+DCL15ls2EiGt5pb+5Ug
         GtfiCF1z3lp6D55cw3GolBm7eIcHFdPETmTBM0YCByu8mrt8UEF5tmQKjXEfbmLS7Wvp
         amx7jJbZfDtmyUfVZpgtraeHo5Gn1/r61KDgWHZKZ/DtJcXW7udy2fYwQy5JhAAVw89B
         7kbA==
X-Forwarded-Encrypted: i=1; AL+hErGVBp0aRnd2czrXdKYaOyHX3EhXGQmfB8tSlpk7gLV6/D+5wC9tQBSkmbjp/K3bYRm0dMBg7W9meA==@kvack.org
X-Gm-Message-State: APuU4Z8/6+UM7m22JYgBTjZI1NGNDBDELJEIPoUKofYNw8EYC9YhQ052
	54+XyzGLt37xOAFlB/UZddsJX6Z11+eQ4eBYgbEXThDY/UxW7sM/ooXdlZwmWZJYO9sM
X-Gm-Gg: AZFdTZdOPmbi347dMiHKVDeBHNrQ7Jl50jCkvDHARIeD3jFX7zEKvWQan9TLkI5MrAN
	lkCvqypFBBpqk9ss2644KXtDrDfEPyW3XUDIB/1qyd6uHLCR9J3YSK282lKl17zrj7m+fMCS1LT
	7w/e6oICCKebXbAi2t/VDDrth4aKdIKeZ5nUUOVjCM+V9Xds2z3hFva0VoZpmk2awK47M/1CSZO
	W0uuyVxg/PLd3s0I33m3rDb3ZZ6brRGK+YitTdCmAhFCl5EOMaiX71agSyaifijbG52NoUk1ULY
	qEPkk2lbof2OJz+lfWSPi89gLbmPw23Onz4wgqFLpIBdaH8rdezYxUSKjXtmWDBWvdhMqcPOnVm
	Q0qMiUybCg1orCzh3PrQ0+KMOV0vVTI/klwOGVYDest+BlLIuYCgwfwEHOboxNaRCUKDYmbmFXv
	XmrAup5FwXvyYXSZGHHsgLntVj2/am4OkyqoRkeAvsujX+TyphCihzE7IREMlvilde8isJsjXiu
	qw3bpOJIwjOeJVK8+74sK2z9VlerhmvG1fKcea2ffFJH2vXOYMYid/EoCfQrgz3L2++V1nMVtNr
	YjGGkb6QfGsucb4atEDCJZ83puVT9erAiQmG6WiSiz9+bv74YntDsxr2PIcSmLjIPptKKP2ybCL
	Jbnsm0K9KHGSJ1K6k7YfP8/iYcKB77sAwQj6OnFizYe+k8HBMjxvUKw==
X-Received: by 2002:a05:7300:50fa:b0:384:6487:b155 with SMTP id 5a478bee46e88-38570c359d3mr13394840eec.29.1795434261498;
        Mon, 23 Nov 2026 03:44:21 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.44.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:44:21 -0800 (PST)
From: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>
To: bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Cc: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Ketan Bhardwaj <ketan@armoriq.io>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH v4 2/6] security: kap: add the LSM ID and internal headers
Date: Mon, 23 Nov 2026 17:13:04 +0530
Message-ID: <20261123114308.8103-3-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D74A4A0003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ey5wmmkznhsh5brpsdzw4rwf69rwts9o
X-HE-Tag: 1795434262-731800
X-HE-Meta: U2FsdGVkX1+pt+C2ok6e98JYAY9/wELfoTrYQjb4GrYPP9nXaCr4UT4WI3I+HWtWMxBpcGKNlr6sWj2ijZMWT1DlwPhPJTMH4eXs0pw7DAXNgrxoNoB2xeMWSdwZMfA6qYhJi+d1G7d7dS+zuFgp98bAkg9OOYp/D2ktUoy0IBZ/G7Cs2az6YthejUQFF7JYmmHwm4UADAr20kkTwaPAFECQggNhdoQ/zwF6B9iuPcM51rf7GOEhzofDmahZDvPoAr4In5Wc5BJuwJgJWqSAkNwA4+m1gPOdWylmkX4y6lhA+fH1hoDVXXHQ9LIlBmVsBDt+AJSQ2ZyWQKbiwu9zATDB8982CNiPGt/4GBOjMiIQvlaP6VQQjCMDy55jL4aiozA1jP/SdZvX5V2oPDKylaBHQ7RcL3Wf/lwP+EEaBZ73af1M8mUxMH/047UIfkivHZYanJjNSZvM2SnxTb26YP5PSPgr5CE9OrQy78vGTjeT2y22fX6Uq7cXeKH8QGt8BZi0LwljUtvmvGY/s4TgvVywaLpPEWMi5nn3IkS8bMHLDAtQwMQcH52xwbJXv0FEv/6SLNmUk3y78M8XC9QeprZXJHAIlHNkjPkDHnt5HEnG4uagu37ufjlJr6Qk6QgyZ2Hy30p7kqVXzkEP6obI7AOtLvE/OTQ04F35K7Wgg13CnisXIG8xN/d36g+lPTO5LVnC3dTtC7579HCalqxT5VzOJikBKTf1rRe6XrhDlRDa/8G3F3ZODN2WZzBwaOi+BWyAMpYfrV055S82jCpRIWeKksS4SjYN7CBMF6BWb0PWUF7TVC17nB4xCaRi36kC/1eLwD9xav9YtHajhaEMgJbXM5bQZWWZdIdUc3klw6FGYqiP5xMfnmqTYbXgACzCpBjt3yd6PYCmelxTKnEjEmMlu5+ntFJ3MY67w2GluHbTz98/rNwTuOaofRfBWPVhhysFN45JJEh+h4bboJL
 rW5p+bZ0
 Ti2uJyCyf5yyLn/DWSxRmrz+ORfWWBgpp7a9LYtYWysjM3jaxYAEKP48N3hYRvKBmD8qOCaqVf4fQJQgpg4vN1qZg1nKPJPVVpYfqPH3HVTTWRpWMb49YpE+84XA2xhbuylNUho4HY1Wske/6rUENx9c7trmZReV1ZTy64fJGYhhxPP6h2YIG26X05RaB86MFa4EKLX9qmTY2lXmCE8+SMY8wElqDUdh/CxeFf2oPAQbguSmrCZnfWmfXydKAiTdXnTvZo3jWA+mi2pNYDyW76+7Zae94A5Fo33FSFObEVglhs3clofub8cshlFD4oS7sAnnoo7ew9PMONy22xWbjpc3LGj7Jh+WtrAqTQ+qCxdWwtLzGjWQ45zw1HNFAs7tHzlvy+e1Ljdn9gbaPmIH0N69K3w7p3fRh1jJKVnBtEZUu9g0aKvcvj398nuiSI6HxcCSHamtoz7Wh5T4Kc2dFzSFMFwu+on8AB2RVWjj3SUvhY3LSTjf1DL3s5XIdxlnFDnJFbgHspdoXxiGSF/FJWvru+eLSA0Rdc+J9wWyD9jyKJSYj6llGM56hX1rA65PrLSC/i1DHGfKYKe/zTMZaGFOgjg==
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
 security/kap/kap.h       | 160 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 177 insertions(+)
 create mode 100644 include/linux/kap.h
 create mode 100644 security/kap/kap.h

diff --git a/include/linux/kap.h b/include/linux/kap.h
new file mode 100644
index 000000000..8d11d20d8
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
index 938593dfd..7cb3d64e5 100644
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
index 000000000..bb71b1061
--- /dev/null
+++ b/security/kap/kap.h
@@ -0,0 +1,160 @@
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
+bool kap_valid_lineage_root(const char *value);
+int kap_securityfs_init(void);
+
+#endif /* _SECURITY_KAP_H */
-- 
2.43.0


