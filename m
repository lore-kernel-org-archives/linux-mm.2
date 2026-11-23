Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2314606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=n1uGueMN
Received: by kanga.kvack.org (Postfix)
	id 257D06B05BC; Mon, 23 Nov 2026 06:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229056B05BD; Mon, 23 Nov 2026 06:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9C86B05BE; Mon, 23 Nov 2026 06:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D44146B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7361A80835
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:36 +0000 (UTC)
X-FDA: 85466201352.20.0B8B049
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75F61180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=n1uGueMN;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434274;
	b=aYGQ+xGYI0eg/VziZfn7s+K7bsQQuW7oIMKI8wim3BWu1tE8k0mda2qrGXLiCm44gaO51A
	/q9PiGFSCNVOJWUv8IO/ULP9V2Q28uOq//R8rb/58tm1YNYUFe1oNICQGmWMz64pc/tk7H
	OymkvQ0NqVKCjfAb+RYW1NTH2rgapFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M74AQzTfaxXaCG7PWhaSh4cZMmKDRZXORKuWWCSB9rE=;
	b=SjpScYdbu4dYQNgmK4hpoSW4wTFa/10glxKxZ94Bs6BTM62aCkVjFEfv8VxaS7xVF9xHkb
	S4MP71JuqdTZ4H41Gd4y7VQS9u3JzzdPweVq2PgBw3Owi09+COKEPum0e1EDKuuFpyFFax
	aDra9+KASDMqkfT62tV+dBjcIYJKX3M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=n1uGueMN;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.181 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-3869b68caecso4068486eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434273; x=1796039073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M74AQzTfaxXaCG7PWhaSh4cZMmKDRZXORKuWWCSB9rE=;
        b=n1uGueMNE0PaqqNPmo8Akh48Aj7B/YoAhd73YfLplhlnb3sojpfpQlH2Es6776CxhI
         iki1MNX8UYi9HGeRnEHWch3TWC+iKqAQzZ3MFBAXLXWdy6xGSP9dN58z7oaazaqSnL+0
         1D6JKUMtB5CH1TZCYfqgzrr36TZhLFLM/4f1u/Gsa3yrCeVARdiLyp07yAuCnD3SpYhO
         wGTPQ6iILlvP7cCCZPrJH/XDYjmXOrG+7g8NwlWnQJD/zTM3Qm+5VejDtrkptJRnLgGv
         er0tUd/Py2QbrYHZc7O7t8GtmdfK1XzSxXSXkJxVCTPgMjvc2tnK/eXyuuHjD8tnAoCc
         k6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434273; x=1796039073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M74AQzTfaxXaCG7PWhaSh4cZMmKDRZXORKuWWCSB9rE=;
        b=BS1E2PintWom7iXBQH2Qkc1SO3CzIW4pq4HspLsmbGIcftO/cB7lmuzOYp4K90XQq9
         pCmV9ZcbkFCnTOxY3lo6kShapWJrPzipTmOfbClr+Mn1mkbocuzN2lJ4RzlWHVDR58Ko
         rRHHuYIpOyZVs2hrhf3yW8HD5ODRn7HU9qtpJPbw0IeBoALrX0ei2KIof1V6yF9DxkHW
         WVJrKuaz03SnpLfdv2TweXIn5hZPP9luA7BM4CTjKzTvbWWsQ1vsQQeg92w8G6ZIWtfM
         6RuiT5vfH9SfEOhlKMTUaFhoPac7O/5RfkFHjSWqyzfJTWaAU1o8mdNEQ/eW2MpbF11z
         +JIg==
X-Forwarded-Encrypted: i=1; AL+hErFTYM8uoOZAm17uITChfj+oJI0Py+XfBCXz1b0HdN7Iuw0uwUKJs2QOVPW6AaU5z68H20ANESN5PA==@kvack.org
X-Gm-Message-State: APuU4Z+lvYvvAhzV6ylu9p3Yi6g9Hxj0O+793VhanuG5e+9arWPDGuAf
	tBhLxamW8WQf9zD/HyHxznZQmF1ZOfVLGGZ3bzl2hb/igrkGqK7NwCMwBWF2++LPKAJF
X-Gm-Gg: AZFdTZeTjD91V8v8T+zthFBFzjTapXoAGj1DuY7/bkPzVTmJiARCoCRXH44ZRjwUn/H
	wtxw7qlVEFAEoRitlN5R5AwUc1BycKGx0Tk9uprxFflwPXRZX9l2gkEKQEzpxctjN+mlBdWmqb5
	n1b6xyJt8UXyXBEcRDgK0cTW1GyikIIWCvux6m0BlzCVXDQbBBz4XcnruYHNmICcwXu2SYSNCOO
	NYwLDFTSDhayx6NtnCKMXOEFEqNFGaacbWfX8cROPFn2uNlIosUvBTVVGb42t76L/T/eut460PN
	y8tjQRz+4l1ekd9CJe3uW2okTnKNtWh62V2uAkMc2KHJN+LzWKCD4uML3trc+bEJBKYb4BqIM+S
	EAax/LpAFE4gnb3AeBKAjUJnsZrbLFlV/oXUiVaDMN4dWZ2/MUa2oGDujYzl8d2vh4Mf/gwcNTw
	As1N1G8fsQIcgLSXCEVi2eU/yXhaVkfVbIOjdouRPTSg0/J1jt2CkZDtRFAjN7Oy9GPKgT/OSrc
	crRGTgBMkGQaFWoNXC2AJ6UhBPjjtorHXMoAgLFxNZIKY7ZxPPU29u8MmCbtMXNknO8x3EY2lD3
	Wqon3eslVMpv0AV7ZGiLlvfvYtuXRaT9nncknua0G79uh5umnry3SLuwKI2G4DVZOIL4XZBwrNZ
	Fx0C2oNjaRgRcFyk0sNO612Lw4dd88wYsnJ8w7FQky7JGqLkCdBXWbg==
X-Received: by 2002:a05:693c:8102:b0:386:b621:d8e1 with SMTP id 5a478bee46e88-386b621db3fmr1655879eec.24.1795434272566;
        Mon, 23 Nov 2026 03:44:32 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.44.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:44:32 -0800 (PST)
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
Subject: [RFC PATCH v4 3/6] security: add the Kernel Assurance Plane LSM
Date: Mon, 23 Nov 2026 17:13:05 +0530
Message-ID: <20261123114308.8103-4-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 75F61180005
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rkzjujqm3jtufhy6zh3gfjizun7wo81f
X-HE-Tag: 1795434274-389655
X-HE-Meta: U2FsdGVkX18ZLRYGV0KdV/AWMYNleklPwdhzy/dXySvdPSCUFCvUz7gl3xEEXcP3JpDVySSy7y6RJMZaZBeQHKH5W/i8QcK0rDM1gpfUd31Pt52UPqs8C2ofYMvnIHw9U3zusUNzRaVTrReIksucja7QzNrtHyVGj193V3qA5AS4V7iXDYaKsJoMk/IIwPqO/fvCMKKjabrk/YCT0OIPBPrh0br8X1JJwcW8SoyWfZ0/X+HXdJ/2ThqzoizyIvkKyI2QoH8zY+aC+PEI2zJiTmMJVQmLpQF1V62eYuTIne8Oa6v0rGUr0P9qOM+2E5SC2ddNgm5Elr3gLnhsvSdEH17+0VzS82eyw1+yNJIpXWEzxnj7GzfH6T/zcR9V9XLj3u9VDn7cDXRp/w5URUqeRE90ZLWZ4MnR0K4y1HDvpgsI9EFYtkNfRkwuxyB99C3Hh+Xxbr+Epr1A2oakxwwjI/bMlUmkyI48kwcGKEUAPeeUsGpZ5IeFTHpqFzahUdNUNj8G7GS02BKHhFw6H/caQUpIRLwRZlpvL0JttamDU87O8M964aJyNnaSi/yREiFGgvc27Q4dpu1dToUcwXVFn2GuNuHKH37Rnh5NL/D92hL7hm1gxNKWReSoACMf4W96qwdddsU5iOYIyzcFoAujC1LKoAs0Vt5Ox6tghm6OZLTMZPIAer+hjAcmpJ6AYxVka8CAkQgUG2h0cLpqXTWhZ2CMS39PJ8GI95lPEcjczSCwo9IiAU+eAOXyFQrSHWvp16n1rRbjqZbReW0sSt6nMV6sIUuYVNXtGJI+xfg1d+5+fWG5HzfjZaXOw+Ygm4kWB0ey6jaKbPLr75v+/A6OdlMC46azEmPRa96XMpeenomhk8YnjSIGmipdIe7B/sCAEi99lkBYppKmvHZk43VM9cGsXtgtzUzL0NZGvVa9HcJQgMBZVQqOpN+J4XD6a3ziHIro+q65UQt3ayRINVx
 YU9iJTk/
 mD2DcmrTHnf3t2uLrx7Gzhz9/D8KjFDGLIjYj0pkvfeBZS1RmXHt9fD9kUz4IUuehW3JFZ2cMjJdziTEjtg9ftP2La3Mg1uVd4/QTnQAI48EtKSVPER2Kz5vzFJ6iEvVyt/tBhjS5o6sGudJny+KnQK78ywPTJ1yza37tjvDj3qVEFGU1xLQCO9Cd2sTC+NzO8D9tHRKp5jpSXeS7kO4kj0JK7Or4ReFw0cAZXj2I2k1kV21bGD+mcLtIXj1wwj4OTC6A9iS8yL8f9oVVqRx57AdcsKEe/aH39K8QPJbGupQYbnPsAhyemBfWSA7+SaFPyPR01nIGF/3+TT8hz9zuiuGXlOqnBqKhKxEwl+WgcpFY4wBmjFnmZ3c/TkMBIaPQ67rqXmXgJ7KATufxGpL9Oo6HLFqyt68Ny9JWRQ5cL7tzWCjs7gWHybIl0CyO4AO0m6cyJrEXwWVzNJjsZhrdiD4/76Dr9tGi3O5z36htuIMs/ptoCfGfN5IxR0vN4aKyxw87PjbP6pLCbx3IZ8LYHxWBPoGSQ02GHn8lO+mEpnvApiOSgKASwUK1X3Ft8V6XyLfNUzfdxmnl3cfRfJh2Y/RKi0Ibi/2tn/eec5O7+vlzffQK8iUGjHvfIMlc0kB8mKPdakAqpHS6Kk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the KAP LSM: Intent Lineage Groups (igroups), the authority
decision, and the hooks that consult it.

A task bound to an igroup carries the igroup and the authority epoch it
was bound under in its task blob, and fork copies both, so a binding
follows the whole process tree. Each hooked operation is resolved to a
target (a path, an address, a credential change) and checked against the
igroup's compiled allow and deny predicates. The decision fails closed
when the authority is absent, revoked or expired, when the target cannot
be resolved, or when the task's epoch is older than the igroup's, which
is how authority is revoked from tasks that are already running.

Predicates are compiled once at install, so a decision walks an array
and allocates nothing. Each decision is appended to the igroup's event
log, and denials also go to the kernel log.

Unbound tasks are not checked, with one exception: when kap.default is
closed, a task outside the initial PID namespace that is bound to no
igroup cannot start a program, so a failed bind cannot leave a workload
running without authority.

Hooks that run under other locks only take a spinlock and do not
allocate, and an unbound task returns before taking any lock.

Nothing can be bound until the control plane is added in the next
patch.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 include/linux/lsm_count.h |   9 +-
 security/Kconfig          |   1 +
 security/Makefile         |   1 +
 security/kap/Kconfig      |  14 +
 security/kap/Makefile     |   2 +
 security/kap/igroup.c     | 976 ++++++++++++++++++++++++++++++++++++++
 security/kap/kap_lsm.c    | 902 +++++++++++++++++++++++++++++++++++
 7 files changed, 1904 insertions(+), 1 deletion(-)
 create mode 100644 security/kap/Kconfig
 create mode 100644 security/kap/Makefile
 create mode 100644 security/kap/igroup.c
 create mode 100644 security/kap/kap_lsm.c

diff --git a/include/linux/lsm_count.h b/include/linux/lsm_count.h
index 16eb49761..720bdd685 100644
--- a/include/linux/lsm_count.h
+++ b/include/linux/lsm_count.h
@@ -102,6 +102,12 @@
 #define IPE_ENABLED
 #endif
 
+#if IS_ENABLED(CONFIG_SECURITY_KAP)
+#define KAP_ENABLED 1,
+#else
+#define KAP_ENABLED
+#endif
+
 /*
  *  There is a trailing comma that we need to be accounted for. This is done by
  *  using a skipped argument in __COUNT_LSMS
@@ -124,7 +130,8 @@
 		LANDLOCK_ENABLED	\
 		IMA_ENABLED		\
 		EVM_ENABLED		\
-		IPE_ENABLED)
+		IPE_ENABLED		\
+		KAP_ENABLED)
 
 #else
 
diff --git a/security/Kconfig b/security/Kconfig
index f7bf6cdc6..c2e6249fb 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -228,6 +228,7 @@ source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
 source "security/landlock/Kconfig"
 source "security/ipe/Kconfig"
+source "security/kap/Kconfig"
 
 source "security/integrity/Kconfig"
 
diff --git a/security/Makefile b/security/Makefile
index 4601230ba..6fb547e92 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_CGROUPS)			+= device_cgroup.o
 obj-$(CONFIG_BPF_LSM)			+= bpf/
 obj-$(CONFIG_SECURITY_LANDLOCK)		+= landlock/
 obj-$(CONFIG_SECURITY_IPE)		+= ipe/
+obj-$(CONFIG_SECURITY_KAP)		+= kap/
 
 # Object integrity file lists
 obj-$(CONFIG_INTEGRITY)			+= integrity/
diff --git a/security/kap/Kconfig b/security/kap/Kconfig
new file mode 100644
index 000000000..bd6775928
--- /dev/null
+++ b/security/kap/Kconfig
@@ -0,0 +1,14 @@
+config SECURITY_KAP
+	bool "Kernel Assurance Plane security module"
+	depends on SECURITY
+	select SECURITYFS
+	select SECURITY_PATH
+	help
+	  The Kernel Assurance Plane binds tasks to Intent Lineage Groups and
+	  checks their operations at LSM hooks against the authority compiled
+	  for the objective each group serves. Privileged userspace validates
+	  policy and installs it through /sys/kernel/security/kap.
+
+	  See Documentation/security/kap.rst for details.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/kap/Makefile b/security/kap/Makefile
new file mode 100644
index 000000000..40a864c8c
--- /dev/null
+++ b/security/kap/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_SECURITY_KAP) := kap.o
+kap-y := kap_lsm.o igroup.o
diff --git a/security/kap/igroup.c b/security/kap/igroup.c
new file mode 100644
index 000000000..0d6ac989b
--- /dev/null
+++ b/security/kap/igroup.c
@@ -0,0 +1,976 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kernel Assurance Plane: igroups and the authority decision.
+ *
+ * An igroup holds the authority compiled for one objective. Privileged
+ * userspace validates policy before installing it; the kernel stores only the
+ * compiled state and decides each hooked operation against the current task's
+ * igroup, epoch and mode. The control plane that creates igroups and installs
+ * authority is in kapfs.c.
+ */
+
+#define pr_fmt(fmt) "KAP: " fmt
+
+#include <linux/binfmts.h>
+#include <linux/errno.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/kernel.h>
+#include <linux/limits.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/pid.h>
+#include <linux/pid_namespace.h>
+#include <linux/printk.h>
+#include <linux/ratelimit.h>
+#include <linux/sched.h>
+#include <linux/sched/task.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/timekeeping.h>
+
+#include "kap.h"
+
+LIST_HEAD(kap_igroups);
+/*
+ * Guards kap_igroups and the state of every igroup on it. A spinlock, because
+ * some hooks run under other spinlocks; nothing sleeps while it is held.
+ */
+DEFINE_SPINLOCK(kap_lock);
+/* Set once the control plane exists; until then no task can be bound. */
+bool kap_ready;
+/* kap.default: false is "open", the default. */
+bool kap_default_closed;
+
+static bool kap_current_epoch_stale_locked(struct kap_igroup *igroup);
+
+static const char *kap_hook_name(enum kap_hook_kind kind)
+{
+	switch (kind) {
+	case KAP_HOOK_EXEC:
+		return "exec";
+	case KAP_HOOK_FILE:
+		return "file";
+	case KAP_HOOK_SOCKET_CONNECT:
+		return "net";
+	case KAP_HOOK_CRED:
+		return "cred";
+	case KAP_HOOK_IPC:
+		return "ipc";
+	case KAP_HOOK_NAMESPACE:
+		return "namespace";
+	case KAP_HOOK_DESCRIPTOR:
+		return "descriptor";
+	case KAP_HOOK_BPF:
+		return "bpf";
+	case KAP_HOOK_PTRACE:
+		return "ptrace";
+	case KAP_HOOK_PROCFS:
+		return "procfs";
+	case KAP_HOOK_EXECMEM:
+		return "execmem";
+	case KAP_HOOK_IO_URING:
+		return "io_uring";
+	default:
+		return "unknown";
+	}
+}
+
+static int kap_file_target(const struct file *file, char *target,
+			   size_t target_len)
+{
+	char *path_buf;
+	char *path;
+	int rc = 0;
+
+	path_buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!path_buf)
+		return -ENOMEM;
+	path = d_path(&file->f_path, path_buf, PATH_MAX);
+	if (IS_ERR(path))
+		rc = PTR_ERR(path);
+	else
+		strscpy(target, path, target_len);
+	kfree(path_buf);
+	return rc;
+}
+
+static int kap_object_target(enum kap_hook_kind kind, const void *object,
+			     char *target, size_t target_len)
+{
+	if (!object)
+		return -EINVAL;
+
+	switch (kind) {
+	case KAP_HOOK_EXEC: {
+		const struct linux_binprm *bprm = object;
+
+		if (!bprm->file)
+			return -EINVAL;
+		return kap_file_target(bprm->file, target, target_len);
+	}
+	case KAP_HOOK_FILE:
+		return kap_file_target(object, target, target_len);
+	case KAP_HOOK_PROCFS:
+		return kap_file_target(object, target, target_len);
+	case KAP_HOOK_SOCKET_CONNECT: {
+		const struct sockaddr *addr = object;
+
+		if (addr->sa_family == AF_INET) {
+			const struct sockaddr_in *in = object;
+
+			scnprintf(target, target_len, "%pI4:%u",
+				  &in->sin_addr, ntohs(in->sin_port));
+			return 0;
+		}
+		if (addr->sa_family == AF_INET6) {
+			const struct sockaddr_in6 *in6 = object;
+
+			scnprintf(target, target_len, "%pI6c:%u",
+				  &in6->sin6_addr, ntohs(in6->sin6_port));
+			return 0;
+		}
+		/* Other families, vsock among them, are named so a grant can allow them. */
+		scnprintf(target, target_len, "family:%u", addr->sa_family);
+		return 0;
+	}
+	case KAP_HOOK_CRED:
+		strscpy(target, "cred", target_len);
+		return 0;
+	case KAP_HOOK_IPC:
+		strscpy(target, "ipc", target_len);
+		return 0;
+	case KAP_HOOK_NAMESPACE:
+		strscpy(target, "namespace", target_len);
+		return 0;
+	case KAP_HOOK_DESCRIPTOR:
+		return kap_file_target(object, target, target_len);
+	case KAP_HOOK_BPF:
+		strscpy(target, "bpf", target_len);
+		return 0;
+	case KAP_HOOK_PTRACE:
+		strscpy(target, "ptrace", target_len);
+		return 0;
+	case KAP_HOOK_EXECMEM:
+		return kap_file_target(object, target, target_len);
+	default:
+		return -EINVAL;
+	}
+}
+
+static bool kap_file_prefix_match(const char *target, const char *candidate)
+{
+	size_t len = strlen(candidate);
+	size_t target_len = strlen(target);
+	static const char deleted[] = " (deleted)";
+	const size_t dlen = sizeof(deleted) - 1;
+
+	/*
+	 * d_path renders an unlinked file as "<path> (deleted)". Match on the
+	 * path so an exact-path deny is not slipped by unlinking the file first
+	 * while a broader allow on its directory still matches.
+	 */
+	if (target_len >= dlen && !memcmp(target + target_len - dlen, deleted, dlen))
+		target_len -= dlen;
+
+	if (len == target_len && !strncmp(target, candidate, len))
+		return true;
+	if (!len || target_len <= len)
+		return false;
+	if (candidate[len - 1] == '/')
+		return !strncmp(target, candidate, len);
+	return target[len] == '/' && !strncmp(target, candidate, len);
+}
+
+static bool kap_string_match(const char *target, const char *candidate)
+{
+	size_t len = strlen(candidate);
+
+	if (!strcmp(candidate, "*"))
+		return true;
+	if (!strcmp(target, candidate))
+		return true;
+	if (len && candidate[len - 1] == '*')
+		return !strncmp(target, candidate, len - 1);
+	return false;
+}
+
+static bool kap_target_match(enum kap_hook_kind kind, const char *target,
+			     const char *candidate)
+{
+	if (!strcmp(candidate, "*"))
+		return true;
+	if (kind == KAP_HOOK_FILE || kind == KAP_HOOK_DESCRIPTOR ||
+	    kind == KAP_HOOK_PROCFS)
+		return kap_file_prefix_match(target, candidate);
+	return kap_string_match(target, candidate);
+}
+
+static const char *kap_next_predicate(const char *cursor, const char *end,
+				      const char *kind_name)
+{
+	char needle[64];
+	const char *found;
+
+	scnprintf(needle, sizeof(needle), "\"kind\":\"%s\"", kind_name);
+	found = strstr(cursor, needle);
+	if (!found || found >= end)
+		return NULL;
+	return found;
+}
+
+/*
+ * Append one pattern to the pool. The caller compiles a whole set before moving
+ * on, so entries land contiguously and can be walked by length.
+ */
+static int kap_intern_pattern(struct kap_compiled_authority *compiled,
+			      struct kap_pattern_set *set,
+			      const char *value, size_t len)
+{
+	if ((size_t)compiled->pool_used + len + 1 > sizeof(compiled->pool))
+		return -E2BIG;
+	memcpy(compiled->pool + compiled->pool_used, value, len);
+	compiled->pool[compiled->pool_used + len] = '\0';
+	compiled->pool_used += len + 1;
+	set->count++;
+	return 0;
+}
+
+/* Walk one "allow" or "deny" array of a predicate block and intern its entries. */
+static int kap_compile_array(struct kap_compiled_authority *compiled,
+			     struct kap_pattern_set *set,
+			     const char *start, const char *end,
+			     const char *array_name)
+{
+	char needle[32];
+	const char *array;
+	const char *cursor;
+
+	scnprintf(needle, sizeof(needle), "\"%s\":[", array_name);
+	array = strstr(start, needle);
+	if (!array || array >= end)
+		return 0;
+	cursor = array + strlen(needle);
+	while (cursor < end && *cursor && *cursor != ']') {
+		const char *value_start;
+		const char *value_end;
+		int rc;
+
+		while (cursor < end && *cursor && *cursor != '"' && *cursor != ']')
+			cursor++;
+		if (cursor >= end || *cursor == ']')
+			break;
+		value_start = ++cursor;
+		value_end = value_start;
+		while (value_end < end && *value_end && *value_end != '"')
+			value_end++;
+		if (value_end >= end || !*value_end)
+			break;
+		rc = kap_intern_pattern(compiled, set, value_start,
+					value_end - value_start);
+		if (rc)
+			return rc;
+		cursor = value_end + 1;
+	}
+	return 0;
+}
+
+/* Collect one array across every predicate of a kind, keeping the set contiguous. */
+static int kap_compile_kind_array(struct kap_compiled_authority *compiled,
+				  struct kap_pattern_set *set,
+				  const char *auth, const char *end,
+				  const char *kind_name, const char *array_name)
+{
+	const char *predicate = auth;
+
+	set->offset = compiled->pool_used;
+	set->count = 0;
+	while ((predicate = kap_next_predicate(predicate, end, kind_name))) {
+		const char *next = strstr(predicate + 1, "\"kind\":");
+		const char *predicate_start = predicate;
+		const char *predicate_end = next && next < end ? next : end;
+		int rc;
+
+		while (predicate_start > auth && *predicate_start != '{')
+			predicate_start--;
+		rc = kap_compile_array(compiled, set, predicate_start,
+				       predicate_end, array_name);
+		if (rc)
+			return rc;
+		predicate = predicate_end;
+	}
+	return 0;
+}
+
+/*
+ * Compile a document into per-kind pattern sets. Allow and deny are collected in
+ * separate passes per kind, because a document may contain several predicates
+ * of one kind and interleaving them would break the contiguous layout the
+ * matcher relies on.
+ */
+static int kap_compile_authority(struct kap_compiled_authority *compiled,
+				 const char *auth, size_t auth_len)
+{
+	const char *end = auth + auth_len;
+	int kind;
+	int rc;
+
+	memset(compiled, 0, sizeof(*compiled));
+	for (kind = 0; kind <= KAP_HOOK_LAST; kind++) {
+		const char *kind_name = kap_hook_name(kind);
+
+		rc = kap_compile_kind_array(compiled, &compiled->allow[kind],
+					    auth, end, kind_name, "allow");
+		if (rc)
+			return rc;
+		rc = kap_compile_kind_array(compiled, &compiled->deny[kind],
+					    auth, end, kind_name, "deny");
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+static bool kap_authority_match(struct kap_igroup *igroup, enum kap_hook_kind kind,
+				const char *target, bool deny_array)
+{
+	const struct kap_compiled_authority *compiled = igroup->compiled;
+	const struct kap_pattern_set *set;
+	const char *pattern;
+	u32 i;
+
+	if (!compiled || kind > KAP_HOOK_LAST)
+		return false;
+	set = deny_array ? &compiled->deny[kind] : &compiled->allow[kind];
+	pattern = compiled->pool + set->offset;
+	for (i = 0; i < set->count; i++) {
+		if (kap_target_match(kind, target, pattern))
+			return true;
+		pattern += strlen(pattern) + 1;
+	}
+	return false;
+}
+
+static bool kap_is_known_kind_name(const char *value, size_t len)
+{
+	int kind;
+
+	for (kind = KAP_HOOK_EXEC; kind <= KAP_HOOK_LAST; kind++) {
+		const char *known = kap_hook_name(kind);
+
+		if (strlen(known) == len && !strncmp(value, known, len))
+			return true;
+	}
+	return false;
+}
+
+static bool kap_range_contains(const char *start, const char *end, const char *needle)
+{
+	const char *found = strstr(start, needle);
+
+	return found && found < end;
+}
+
+static int kap_validate_authority_payload(const char *payload)
+{
+	const char *cursor = payload;
+	const char *end = payload + strlen(payload);
+	bool saw_kind = false;
+
+	if (payload[0] != '{' || !strstr(payload, "\"predicates\":["))
+		return -EINVAL;
+
+	while ((cursor = strstr(cursor, "\"kind\":\""))) {
+		const char *kind_start = cursor + strlen("\"kind\":\"");
+		const char *kind_end = strchr(kind_start, '"');
+		const char *next_kind = strstr(kind_start, "\"kind\":\"");
+		const char *predicate_start = cursor;
+		const char *predicate_end = next_kind ? next_kind : end;
+
+		if (!kind_end)
+			return -EINVAL;
+		if (!kap_is_known_kind_name(kind_start, kind_end - kind_start))
+			return -EINVAL;
+		while (predicate_start > payload && *predicate_start != '{')
+			predicate_start--;
+		if (!kap_range_contains(predicate_start, predicate_end, "\"allow\":["))
+			return -EINVAL;
+		if (!kap_range_contains(predicate_start, predicate_end, "\"deny\":["))
+			return -EINVAL;
+		saw_kind = true;
+		cursor = kind_end + 1;
+	}
+	return saw_kind ? 0 : -EINVAL;
+}
+
+/*
+ * With kap.default = closed, an unbound task outside the initial PID namespace
+ * cannot start a program, so a workload whose bind failed does not run without
+ * authority.
+ *
+ * Only exec is refused. Setup work that runs in the new PID namespace before
+ * the bind, such as mounts, keeps working. Tasks in the initial PID namespace
+ * are never refused.
+ */
+static bool kap_unbound_refused(enum kap_hook_kind kind)
+{
+	if (!READ_ONCE(kap_default_closed))
+		return false;
+	if (kind != KAP_HOOK_EXEC && kind != KAP_HOOK_EXECMEM)
+		return false;
+	return task_active_pid_ns(current) != &init_pid_ns;
+}
+
+/*
+ * No igroup means nowhere to append an event, so the kernel log is the only
+ * record of an unbound refusal.
+ */
+static int kap_refuse_unbound(enum kap_hook_kind kind, const char *target)
+{
+	pr_warn_ratelimited("deny igroup=<unbound> op=%s target=%s reason=unbound_task pid=%d\n",
+			    kap_hook_name(kind), target ? target : "",
+			    task_pid_nr(current));
+	return -EACCES;
+}
+
+/*
+ * Exported so the LSM layer can tell whether to keep going for a task it would
+ * otherwise skip. Its hooks return early for any unbound task, which is exactly
+ * the task fail-closed exists to stop, so that shortcut has to consult this.
+ */
+bool kap_fail_closed_kind(enum kap_hook_kind kind)
+{
+	return kap_unbound_refused(kind);
+}
+
+/*
+ * Refuse and name the gate that did it. Only the authority-state gates set a
+ * reason: a predicate match leaves *why NULL so the caller's own allow/deny
+ * strings stay in use for the common path.
+ */
+static int kap_refuse(const char **why, const char *reason)
+{
+	if (why)
+		*why = reason;
+	return -EACCES;
+}
+
+static int kap_authority_decision_locked(struct kap_igroup *igroup,
+					 enum kap_hook_kind kind,
+					 const char *target,
+					 const char **why)
+{
+	if (why)
+		*why = NULL;
+	if (kap_current_epoch_stale_locked(igroup))
+		return kap_refuse(why, "authority_epoch_stale");
+	/*
+	 * Checked on every decision, not once at install. It bounds how long a
+	 * running authority lives; it does not protect against a clock that
+	 * has been moved back.
+	 */
+	if (igroup->expires_at &&
+	    (u64)ktime_get_real_seconds() >= igroup->expires_at)
+		return kap_refuse(why, "authority_expired");
+	if (igroup->revoked)
+		return kap_refuse(why, "authority_revoked");
+	if (!igroup->authority_len)
+		return kap_refuse(why, "authority_absent");
+	if (!target || !*target)
+		return kap_refuse(why, "target_unresolved");
+	if (kap_authority_match(igroup, kind, target, true))
+		return -EACCES;
+	if (!kap_authority_match(igroup, kind, target, false))
+		return -EACCES;
+	return 0;
+}
+
+struct kap_igroup *kap_find_igroup_locked(const char *name)
+{
+	struct kap_igroup *igroup;
+
+	list_for_each_entry(igroup, &kap_igroups, node) {
+		if (!strcmp(igroup->name, name))
+			return igroup;
+	}
+	return NULL;
+}
+
+static bool kap_pid_in_igroup_locked(struct kap_igroup *igroup, pid_t pid)
+{
+	struct kap_bound_pid *entry;
+
+	list_for_each_entry(entry, &igroup->pids, node) {
+		if (entry->pid == pid)
+			return true;
+	}
+	return false;
+}
+
+static struct kap_igroup *kap_find_current_igroup_locked(void)
+{
+	struct kap_task_state *state = kap_task_state(current);
+
+	if (!state || !state->active)
+		return NULL;
+	return kap_find_igroup_locked(state->igroup_name);
+}
+
+static bool kap_current_epoch_stale_locked(struct kap_igroup *igroup)
+{
+	struct kap_task_state *state = kap_task_state(current);
+
+	return state && state->active && !strcmp(state->igroup_name, igroup->name) &&
+	       state->epoch != igroup->epoch;
+}
+
+static bool kap_current_task_active(void)
+{
+	struct kap_task_state *state = kap_task_state(current);
+
+	return state && state->active;
+}
+
+void kap_trim_newline(char *value)
+{
+	size_t len = strlen(value);
+
+	while (len && (value[len - 1] == '\n' || value[len - 1] == '\r')) {
+		value[len - 1] = '\0';
+		len--;
+	}
+}
+
+/*
+ * The lineage root is opaque to the kernel but it is written verbatim into the
+ * kap.events JSON, so reject control characters and the two JSON string
+ * metacharacters rather than let them break the record.
+ */
+bool kap_valid_lineage_root(const char *value)
+{
+	const unsigned char *p;
+
+	for (p = (const unsigned char *)value; *p; p++) {
+		if (*p < 0x20 || *p == '"' || *p == '\\')
+			return false;
+	}
+	return true;
+}
+
+static void kap_append_event_locked(struct kap_igroup *igroup,
+				    enum kap_hook_kind kind,
+				    bool allowed,
+				    const char *reason,
+				    const char *target)
+{
+	char line[512];
+	char escaped_target[192];
+	u64 now = ktime_get_real_ns();
+	int len;
+	size_t out = 0;
+	size_t i;
+
+	escaped_target[0] = '\0';
+	if (target) {
+		for (i = 0; target[i] && out + 2 < sizeof(escaped_target); i++) {
+			if (target[i] == '"' || target[i] == '\\') {
+				if (out + 3 >= sizeof(escaped_target))
+					break;
+				escaped_target[out++] = '\\';
+				escaped_target[out++] = target[i];
+			} else if (target[i] == '\n' || target[i] == '\r' || target[i] == '\t') {
+				escaped_target[out++] = ' ';
+			} else if ((unsigned char)target[i] < 0x20) {
+				escaped_target[out++] = '?';
+			} else {
+				escaped_target[out++] = target[i];
+			}
+		}
+		escaped_target[out] = '\0';
+	}
+
+	/*
+	 * kap.events halves itself when full, so allowed traffic can evict a
+	 * denial. Mirror denials to the kernel log, before the ring write so
+	 * the early returns below cannot drop the record.
+	 */
+	if (!allowed)
+		pr_warn_ratelimited("deny igroup=%s op=%s target=%s reason=%s epoch=%llu pid=%d\n",
+				    igroup->name, kap_hook_name(kind),
+				    escaped_target, reason, igroup->epoch,
+				    task_pid_nr(current));
+
+	len = scnprintf(line, sizeof(line),
+			"{\"ts_ns\":%llu,\"igroup\":\"%s\",\"decision\":\"%s\",\"operation\":\"%s\",\"target\":\"%s\",\"reason\":\"%s\",\"epoch\":%llu,\"root\":\"%s\",\"pid\":%d}\n",
+			now, igroup->name, allowed ? "allow" : "deny",
+			kap_hook_name(kind), escaped_target, reason, igroup->epoch,
+			igroup->lineage_root, task_pid_nr(current));
+	if (len <= 0)
+		return;
+	if (len >= KAP_MAX_EVENTS_BYTES) {
+		igroup->events_len = 0;
+		return;
+	}
+	if (igroup->events_len + len >= KAP_MAX_EVENTS_BYTES) {
+		size_t keep = KAP_MAX_EVENTS_BYTES / 2;
+
+		memmove(igroup->events, igroup->events + igroup->events_len - keep, keep);
+		igroup->events_len = keep;
+	}
+	memcpy(igroup->events + igroup->events_len, line, len);
+	igroup->events_len += len;
+}
+
+/* The common case: an unbound task is never checked and takes no lock. */
+static bool kap_skip_current(enum kap_hook_kind kind)
+{
+	if (!READ_ONCE(kap_ready))
+		return true;
+	return !kap_current_task_active() && !kap_unbound_refused(kind);
+}
+
+/*
+ * A program is allowed by the path it resolves to, and refused by a deny on
+ * either that path or the name it was started with. "..", relative names and
+ * symlinks can therefore neither step around a deny nor borrow an allow.
+ */
+static int kap_exec_decision_locked(struct kap_igroup *igroup,
+				    const char *resolved, const char *name,
+				    const char **why)
+{
+	int rc;
+
+	rc = kap_authority_decision_locked(igroup, KAP_HOOK_EXEC, resolved, why);
+	if (*why || !name || !*name || !strcmp(name, resolved))
+		return rc;
+	if (kap_authority_match(igroup, KAP_HOOK_EXEC, resolved, true) ||
+	    kap_authority_match(igroup, KAP_HOOK_EXEC, name, true))
+		return -EACCES;
+	return rc;
+}
+
+static int kap_decide_locked(struct kap_igroup *igroup, enum kap_hook_kind kind,
+			     const void *object, const char *target,
+			     const char **why)
+{
+	if (kind == KAP_HOOK_EXEC) {
+		const struct linux_binprm *bprm = object;
+
+		return kap_exec_decision_locked(igroup, target, bprm->filename, why);
+	}
+	return kap_authority_decision_locked(igroup, kind, target, why);
+}
+
+int kap_check_current_target_why(enum kap_hook_kind kind, const char *target,
+				 const char **why)
+{
+	const char *gate = NULL;
+	struct kap_igroup *igroup;
+	int rc = 0;
+
+	if (why)
+		*why = NULL;
+	if (kap_skip_current(kind))
+		return 0;
+
+	spin_lock(&kap_lock);
+	igroup = kap_find_current_igroup_locked();
+	if (!igroup) {
+		if (kap_unbound_refused(kind))
+			rc = kap_refuse_unbound(kind, target);
+		goto out;
+	}
+	rc = kap_authority_decision_locked(igroup, kind, target, &gate);
+	if (why)
+		*why = gate;
+out:
+	spin_unlock(&kap_lock);
+	return rc;
+}
+
+int kap_check_current_emit(enum kap_hook_kind kind, const void *object,
+			   const char *deny_reason, const char *allow_reason)
+{
+	char *target;
+	struct kap_igroup *igroup;
+	const char *why = NULL;
+	int rc = 0;
+
+	if (kap_skip_current(kind))
+		return 0;
+
+	target = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!target)
+		return -ENOMEM;
+	if (kap_object_target(kind, object, target, PATH_MAX)) {
+		kfree(target);
+		return -EACCES;
+	}
+
+	spin_lock(&kap_lock);
+	igroup = kap_find_current_igroup_locked();
+	if (!igroup) {
+		if (kap_unbound_refused(kind))
+			rc = kap_refuse_unbound(kind, target);
+		goto out;
+	}
+	rc = kap_decide_locked(igroup, kind, object, target, &why);
+	kap_append_event_locked(igroup, kind, rc == 0,
+				rc ? (why ? why : deny_reason) : allow_reason, target);
+out:
+	spin_unlock(&kap_lock);
+	kfree(target);
+	return rc;
+}
+
+int kap_check_current_target_emit(enum kap_hook_kind kind, const char *target,
+				  const char *deny_reason, const char *allow_reason)
+{
+	struct kap_igroup *igroup;
+	const char *why = NULL;
+	int rc = 0;
+
+	if (kap_skip_current(kind))
+		return 0;
+
+	spin_lock(&kap_lock);
+	igroup = kap_find_current_igroup_locked();
+	if (!igroup) {
+		if (kap_unbound_refused(kind))
+			rc = kap_refuse_unbound(kind, target);
+		goto out;
+	}
+	rc = kap_authority_decision_locked(igroup, kind, target, &why);
+	kap_append_event_locked(igroup, kind, rc == 0,
+				rc ? (why ? why : deny_reason) : allow_reason, target);
+out:
+	spin_unlock(&kap_lock);
+	return rc;
+}
+
+void kap_emit_current_event_target(enum kap_hook_kind kind, int decision,
+				   const char *reason, const char *target)
+{
+	struct kap_igroup *igroup;
+
+	if (!READ_ONCE(kap_ready) || !kap_current_task_active())
+		return;
+
+	spin_lock(&kap_lock);
+	igroup = kap_find_current_igroup_locked();
+	if (igroup)
+		kap_append_event_locked(igroup, kind, decision, reason, target);
+	spin_unlock(&kap_lock);
+}
+
+int kap_parse_transition_sequence(const char *payload, u64 *sequence)
+{
+	const char *cursor = strstr(payload, "\"sequence\"");
+	u64 value = 0;
+	bool seen_digit = false;
+
+	if (!cursor)
+		cursor = strstr(payload, "sequence");
+	if (!cursor)
+		return -EINVAL;
+	cursor = strchr(cursor, ':');
+	if (!cursor)
+		return -EINVAL;
+	cursor++;
+	while (*cursor == ' ' || *cursor == '\t')
+		cursor++;
+	while (*cursor >= '0' && *cursor <= '9') {
+		unsigned int digit = *cursor - '0';
+
+		if (value > (U64_MAX - digit) / 10)
+			return -ERANGE;
+		value = value * 10 + digit;
+		seen_digit = true;
+		cursor++;
+	}
+	if (!seen_digit)
+		return -EINVAL;
+	*sequence = value;
+	return 0;
+}
+
+/*
+ * kap.install takes the whole document in one write so the lineage root, epoch,
+ * expiry and predicates commit together or not at all. Writing them one file at
+ * a time cannot be made safe: kap.authority_epoch refuses a lower value with
+ * -ESTALE, deliberately, so once the epoch has advanced there is no way back and
+ * a later refusal leaves every bound task stale against an epoch no authority
+ * was ever installed for.
+ *
+ * Line oriented rather than JSON, because the authority value is itself JSON and
+ * nesting it would mean parsing JSON with strstr twice. Every key may appear at
+ * most once and an unrecognised key is refused rather than ignored, so a typo
+ * fails the install instead of silently dropping a field.
+ *
+ * The whole document has to arrive in one write(). Each write is parsed on its
+ * own, so a caller that splits the document sees the first chunk refused for
+ * missing keys rather than a half-applied install, which is the usual contract
+ * for a command file.
+ */
+int kap_install_parse(char *payload, struct kap_install_request *req)
+{
+	char *cursor = payload;
+	char *line;
+
+	memset(req, 0, sizeof(*req));
+
+	while ((line = strsep(&cursor, "\n"))) {
+		char *value;
+
+		if (!*line)
+			continue;
+		value = strchr(line, '=');
+		if (!value)
+			return -EINVAL;
+		*value++ = '\0';
+
+		if (!strcmp(line, "lineage_root")) {
+			if (req->have_root || strlen(value) > KAP_MAX_ROOT_LEN ||
+			    !kap_valid_lineage_root(value))
+				return -EINVAL;
+			strscpy(req->lineage_root, value,
+				sizeof(req->lineage_root));
+			req->have_root = true;
+		} else if (!strcmp(line, "authority_epoch")) {
+			if (req->have_epoch || kstrtou64(value, 10, &req->epoch))
+				return -EINVAL;
+			req->have_epoch = true;
+		} else if (!strcmp(line, "expires_at")) {
+			if (req->have_expires_at ||
+			    kstrtou64(value, 10, &req->expires_at))
+				return -EINVAL;
+			req->have_expires_at = true;
+		} else if (!strcmp(line, "transition")) {
+			if (req->have_transition ||
+			    kap_parse_transition_sequence(value, &req->sequence))
+				return -EINVAL;
+			req->have_transition = true;
+		} else if (!strcmp(line, "authority")) {
+			if (req->have_authority)
+				return -EINVAL;
+			req->authority = value;
+			req->have_authority = true;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	if (!req->have_root || !req->have_epoch || !req->have_authority)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Validate and compile an authority document. Runs before kap_lock is taken,
+ * because compiling allocates.
+ */
+int kap_authority_prepare(const char *doc, struct kap_compiled_authority **out)
+{
+	struct kap_compiled_authority *next;
+	size_t len;
+	int rc;
+
+	*out = NULL;
+	rc = kap_validate_authority_payload(doc);
+	if (rc)
+		return rc;
+	len = strlen(doc);
+	/* Stored whole in the igroup, so it has to fit with its terminator. */
+	if (len >= KAP_MAX_PREDICATE_BYTES)
+		return -E2BIG;
+
+	next = kvzalloc_obj(*next, GFP_KERNEL);
+	if (!next)
+		return -ENOMEM;
+	rc = kap_compile_authority(next, doc, len);
+	if (rc) {
+		kvfree(next);
+		return rc;
+	}
+	*out = next;
+	return 0;
+}
+
+/*
+ * Commit a prepared install. On success *compiled is swapped with the
+ * igroup's previous authority, which the caller frees after dropping the lock.
+ */
+int kap_install_locked(struct kap_igroup *igroup,
+		       const struct kap_install_request *req,
+		       struct kap_compiled_authority **compiled)
+{
+	struct kap_compiled_authority *old;
+
+	/*
+	 * Everything that can be refused is refused here, before the igroup is
+	 * touched at all. The individual files apply the same rules; keep them
+	 * in step.
+	 */
+	if (req->epoch < igroup->epoch)
+		return -ESTALE;
+	if (req->expires_at &&
+	    (u64)ktime_get_real_seconds() >= req->expires_at)
+		return -ESTALE;
+	if (req->have_transition && igroup->has_sequence &&
+	    req->sequence <= igroup->last_sequence)
+		return -EALREADY;
+
+	/* Nothing below can fail, which is what makes this a transaction. */
+	strscpy(igroup->lineage_root, req->lineage_root,
+		sizeof(igroup->lineage_root));
+	igroup->epoch = req->epoch;
+	igroup->revoked = false;
+	igroup->expires_at = req->expires_at;
+	if (req->have_transition) {
+		igroup->last_sequence = req->sequence;
+		igroup->has_sequence = true;
+	}
+	strscpy(igroup->authority, req->authority, sizeof(igroup->authority));
+	igroup->authority_len = strlen(igroup->authority);
+	old = igroup->compiled;
+	igroup->compiled = *compiled;
+	*compiled = old;
+	return 0;
+}
+
+/*
+ * Bind every thread of the process with this pid. *entry is allocated by the
+ * caller before taking kap_lock and is consumed when the pid is recorded.
+ */
+int kap_bind_pid_locked(struct kap_igroup *igroup, pid_t pid,
+			struct kap_bound_pid **entry)
+{
+	struct task_struct *task, *t;
+
+	if (pid <= 0)
+		return -EINVAL;
+	rcu_read_lock();
+	task = pid_task(find_vpid(pid), PIDTYPE_PID);
+	if (!task) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+	for_each_thread(task, t) {
+		struct kap_task_state *state = kap_task_state(t);
+
+		if (!state)
+			continue;
+		state->active = true;
+		state->epoch = igroup->epoch;
+		strscpy(state->igroup_name, igroup->name, sizeof(state->igroup_name));
+	}
+	rcu_read_unlock();
+
+	if (kap_pid_in_igroup_locked(igroup, pid))
+		return 0;
+	(*entry)->pid = pid;
+	list_add_tail(&(*entry)->node, &igroup->pids);
+	*entry = NULL;
+	return 0;
+}
diff --git a/security/kap/kap_lsm.c b/security/kap/kap_lsm.c
new file mode 100644
index 000000000..48d048086
--- /dev/null
+++ b/security/kap/kap_lsm.c
@@ -0,0 +1,902 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kernel Assurance Plane LSM prototype.
+ *
+ * This file wires KAP into the LSM hooks. igroup state and decisions are in
+ * igroup.c, and the securityfs control plane that installs authority is in
+ * kapfs.c.
+ */
+
+#define pr_fmt(fmt) "KAP: " fmt
+
+#include <linux/binfmts.h>
+#include <linux/cred.h>
+#include <linux/bpf.h>
+#include <linux/dcache.h>
+#include <linux/fs.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/kap.h>
+#include <linux/limits.h>
+#include <linux/lsm_hooks.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/mount.h>
+#include <linux/nsproxy.h>
+#include <linux/sched.h>
+#include <linux/security.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <net/sock.h>
+
+#include "kap.h"
+
+#define KAP_LSM_TARGET_LEN 256
+
+struct lsm_blob_sizes kap_blob_sizes __ro_after_init = {
+	.lbs_task = sizeof(struct kap_task_state),
+};
+
+bool kap_lsm_active;
+struct io_uring_cmd;
+
+static char *kap_lsm_file_path_alloc(struct file *file);
+static int kap_lsm_path_target(const struct path *path, char *target, size_t target_len);
+static bool kap_path_is_memfd(const char *path);
+static bool kap_path_is_anonymous_channel(const char *path);
+static bool kap_lsm_current_active(void);
+
+struct kap_task_state *kap_task_state(struct task_struct *task)
+{
+	if (!READ_ONCE(kap_lsm_active) || !task || !task->security)
+		return NULL;
+	return (struct kap_task_state *)((char *)task->security + kap_blob_sizes.lbs_task);
+}
+
+static int kap_task_alloc(struct task_struct *task, u64 clone_flags)
+{
+	struct kap_task_state *old = kap_task_state(current);
+	struct kap_task_state *new = kap_task_state(task);
+	int rc;
+
+	if (!new)
+		return 0;
+
+	rc = kap_check_namespace_flags(clone_flags, "clone");
+	if (rc)
+		return rc;
+
+	memset(new, 0, sizeof(*new));
+	/* Under kap_lock, so a bind running now is copied whole or not at all. */
+	spin_lock(&kap_lock);
+	if (old && old->active)
+		*new = *old;
+	spin_unlock(&kap_lock);
+	return 0;
+}
+
+static void kap_task_free(struct task_struct *task)
+{
+	struct kap_task_state *state = kap_task_state(task);
+
+	if (state)
+		memset(state, 0, sizeof(*state));
+}
+
+static bool kap_lsm_current_active(void)
+{
+	struct kap_task_state *state = kap_task_state(current);
+
+	return state && state->active;
+}
+
+static int kap_bprm_check_security(struct linux_binprm *bprm)
+{
+	char *target;
+
+	/*
+	 * An unbound task is skipped everywhere else, but under
+	 * kap.default = closed an unbound exec is the one thing that must not
+	 * proceed.
+	 */
+	if (!kap_lsm_current_active() && !kap_fail_closed_kind(KAP_HOOK_EXEC))
+		return 0;
+	if (bprm->file) {
+		target = kap_lsm_file_path_alloc(bprm->file);
+		if (!IS_ERR(target)) {
+			if (kap_path_is_memfd(target)) {
+				int rc = kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
+								       "memfd_exec_predicate_denied",
+								       "memfd_exec_allowed");
+				kfree(target);
+				return rc;
+			}
+			kfree(target);
+		}
+	}
+	return kap_check_current_emit(KAP_HOOK_EXEC, bprm,
+				      "exec_predicate_denied", "exec_allowed");
+}
+
+/*
+ * Resolves a file to a PATH_MAX buffer the caller must kfree, or an ERR_PTR.
+ * The buffer is allocated rather than kept on the stack: these hooks run deep
+ * in syscall paths and a 4K frame does not belong on a 16K kernel stack.
+ */
+static char *kap_lsm_file_path_alloc(struct file *file)
+{
+	char *buf;
+	char *path;
+
+	if (!file)
+		return ERR_PTR(-EINVAL);
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+	path = d_path(&file->f_path, buf, PATH_MAX);
+	if (IS_ERR(path)) {
+		kfree(buf);
+		return ERR_CAST(path);
+	}
+	/* d_path builds backwards from the end, so move the result to the front
+	 * and hand back a single pointer.
+	 */
+	memmove(buf, path, strlen(path) + 1);
+	return buf;
+}
+
+static int kap_lsm_path_target(const struct path *path, char *target, size_t target_len)
+{
+	char *path_buf;
+	char *rendered;
+	int rc = 0;
+
+	if (!path)
+		return -EINVAL;
+	path_buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!path_buf)
+		return -ENOMEM;
+	rendered = d_path(path, path_buf, PATH_MAX);
+	if (IS_ERR(rendered))
+		rc = PTR_ERR(rendered);
+	else
+		strscpy(target, rendered, target_len);
+	kfree(path_buf);
+	return rc;
+}
+
+static bool kap_path_is_procfs(const char *path)
+{
+	return !strcmp(path, "/proc") || !strncmp(path, "/proc/", strlen("/proc/"));
+}
+
+/*
+ * Rewrites /proc/<pid>/... to /proc/self/... in place. target is a PATH_MAX
+ * buffer from kap_lsm_file_path_alloc. Done in place rather than through a
+ * second PATH_MAX buffer, which would not fit on the stack.
+ */
+static void kap_normalize_procfs_self(char *target)
+{
+	static const char self[] = "/proc/self";
+	const size_t self_len = sizeof(self) - 1;
+	char prefix[32];
+	size_t prefix_len;
+	size_t tail_len;
+
+	/*
+	 * /proc/self resolves to the thread-group leader as numbered in the
+	 * procfs instance's PID namespace, so use the tgid in the current PID
+	 * namespace rather than this thread's global PID.
+	 */
+	prefix_len = scnprintf(prefix, sizeof(prefix), "/proc/%d", task_tgid_vnr(current));
+	if (strncmp(target, prefix, prefix_len))
+		return;
+	if (target[prefix_len] != '\0' && target[prefix_len] != '/')
+		return;
+	tail_len = strlen(target + prefix_len);
+	if (self_len + tail_len >= PATH_MAX)
+		return;
+	memmove(target + self_len, target + prefix_len, tail_len + 1);
+	memcpy(target, self, self_len);
+}
+
+static bool kap_path_is_memfd(const char *path)
+{
+	return strstr(path, "/memfd:") || strstr(path, "memfd:");
+}
+
+static bool kap_path_is_anonymous_channel(const char *path)
+{
+	return !strncmp(path, "pipe:", strlen("pipe:")) ||
+	       !strncmp(path, "socket:", strlen("socket:")) ||
+	       !strncmp(path, "anon_inode:", strlen("anon_inode:"));
+}
+
+static int kap_file_open(struct file *file)
+{
+	char *target;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	target = kap_lsm_file_path_alloc(file);
+	if (!IS_ERR(target)) {
+		if (kap_path_is_procfs(target)) {
+			int rc;
+
+			kap_normalize_procfs_self(target);
+			rc = kap_check_current_target_emit(KAP_HOOK_PROCFS, target,
+							   "procfs_predicate_denied",
+							   "procfs_allowed");
+			kfree(target);
+			return rc;
+		}
+		kfree(target);
+	}
+	return kap_check_current_emit(KAP_HOOK_FILE, file,
+				      "file_predicate_denied", "file_allowed");
+}
+
+static int kap_file_permission(struct file *file, int mask)
+{
+	const char *why = NULL;
+	char *target;
+	int rc;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	if (!(mask & (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)))
+		return 0;
+	target = kap_lsm_file_path_alloc(file);
+	if (IS_ERR(target))
+		return kap_check_current_emit(KAP_HOOK_FILE, file,
+					      "file_use_predicate_denied",
+					      "file_use_allowed");
+	if (kap_path_is_anonymous_channel(target)) {
+		kfree(target);
+		return 0;
+	}
+	if (kap_path_is_procfs(target)) {
+		kap_normalize_procfs_self(target);
+		rc = kap_check_current_target_why(KAP_HOOK_PROCFS, target, &why);
+		if (rc)
+			kap_emit_current_event_target(KAP_HOOK_PROCFS, 0,
+						      why ?: "procfs_use_predicate_denied", target);
+	} else {
+		rc = kap_check_current_target_why(KAP_HOOK_FILE, target, &why);
+		if (rc)
+			kap_emit_current_event_target(KAP_HOOK_FILE, 0,
+						      why ?: "file_use_predicate_denied", target);
+	}
+	kfree(target);
+	return rc;
+}
+
+static int kap_mmap_file(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags)
+{
+	char *target;
+	int rc = 0;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	if (!(reqprot & PROT_EXEC) && !(prot & PROT_EXEC))
+		return 0;
+	if (!file)
+		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "anonymous",
+						     "execmem_predicate_denied",
+						     "execmem_allowed");
+	target = kap_lsm_file_path_alloc(file);
+	if (IS_ERR(target))
+		/* Cannot tell what it is, so let a revoked or expired igroup
+		 * still deny rather than allowing the mapping outright.
+		 */
+		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "unresolved",
+						     "execmem_predicate_denied",
+						     "execmem_allowed");
+	if (kap_path_is_memfd(target))
+		rc = kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
+						   "execmem_predicate_denied",
+						   "execmem_allowed");
+	kfree(target);
+	return rc;
+}
+
+static int kap_file_mprotect(struct vm_area_struct *vma,
+			     unsigned long reqprot, unsigned long prot)
+{
+	char *target;
+	struct file *file;
+	int rc = 0;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	if (!(reqprot & PROT_EXEC) && !(prot & PROT_EXEC))
+		return 0;
+	file = vma ? vma->vm_file : NULL;
+	if (!file)
+		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "anonymous",
+						     "execmem_predicate_denied",
+						     "execmem_allowed");
+	target = kap_lsm_file_path_alloc(file);
+	if (IS_ERR(target))
+		/* Cannot tell what it is, so let a revoked or expired igroup
+		 * still deny rather than allowing the mapping outright.
+		 */
+		return kap_check_current_target_emit(KAP_HOOK_EXECMEM, "unresolved",
+						     "execmem_predicate_denied",
+						     "execmem_allowed");
+	if (kap_path_is_memfd(target))
+		rc = kap_check_current_target_emit(KAP_HOOK_EXECMEM, target,
+						   "execmem_predicate_denied",
+						   "execmem_allowed");
+	kfree(target);
+	return rc;
+}
+
+#ifdef CONFIG_SECURITY_NETWORK
+static int kap_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+	/*
+	 * AF_UNSPEC dissolves an association rather than making one; resolvers
+	 * use it between candidate addresses. AF_UNIX is checked as ipc by the
+	 * unix hooks.
+	 */
+	if (addrlen < offsetofend(struct sockaddr, sa_family) ||
+	    address->sa_family == AF_UNSPEC || address->sa_family == AF_UNIX)
+		return 0;
+	/*
+	 * The target render reads the family's address and port. A short
+	 * addrlen would read uninitialised stack into kap.events, so leave a
+	 * malformed address for the protocol layer to reject.
+	 */
+	if (address->sa_family == AF_INET && addrlen < sizeof(struct sockaddr_in))
+		return 0;
+	if (address->sa_family == AF_INET6 && addrlen < sizeof(struct sockaddr_in6))
+		return 0;
+	return kap_check_current_emit(KAP_HOOK_SOCKET_CONNECT, address,
+				      "net_predicate_denied", "net_allowed");
+}
+#endif
+
+static int kap_check_static_target(enum kap_hook_kind kind, const char *target,
+				   const char *deny_reason, const char *allow_reason)
+{
+	return kap_check_current_target_emit(kind, target, deny_reason, allow_reason);
+}
+
+static int kap_check_namespace_target(const char *ns, const char *operation)
+{
+	char target[64];
+
+	scnprintf(target, sizeof(target), "%s:%s", ns, operation);
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
+				       "namespace_predicate_denied", "namespace_allowed");
+}
+
+static const struct {
+	unsigned long flag;
+	const char *name;
+} kap_namespaces[] = {
+	{ CLONE_NEWNS, "mount" },
+	{ CLONE_NEWPID, "pid" },
+	{ CLONE_NEWNET, "net" },
+	{ CLONE_NEWUSER, "user" },
+	{ CLONE_NEWUTS, "uts" },
+	{ CLONE_NEWIPC, "ipc" },
+	{ CLONE_NEWCGROUP, "cgroup" },
+	{ CLONE_NEWTIME, "time" },
+};
+
+int kap_check_namespace_flags(unsigned long flags, const char *operation)
+{
+	int rc;
+	int i;
+
+	if (!operation || !*operation)
+		operation = "transition";
+	for (i = 0; i < ARRAY_SIZE(kap_namespaces); i++) {
+		if (!(flags & kap_namespaces[i].flag))
+			continue;
+		/* Creating a user namespace is checked by userns_create. */
+		if (kap_namespaces[i].flag == CLONE_NEWUSER &&
+		    strcmp(operation, "setns"))
+			continue;
+		rc = kap_check_namespace_target(kap_namespaces[i].name, operation);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+/* A path we cannot render is a path we cannot judge. Emitting it as a normal
+ * target lets a broad allow such as "*" match the placeholder and pass, so
+ * refuse outright and record why.
+ */
+static int kap_lsm_refuse_unresolved(const char *why)
+{
+	kap_emit_current_event_target(KAP_HOOK_FILE, 0, why, NULL);
+	return -EACCES;
+}
+
+/*
+ * The path family (rename, link, unlink, mkdir, mknod, symlink) is checked
+ * like open, so a bound task cannot stage a file where it may write and move
+ * it into a denied directory. Render the entry as its parent directory plus
+ * its name and run it through the same file predicate as open, so one place
+ * decides and one reason string comes out.
+ *
+ * Rendering happens into a PATH_MAX buffer rather than KAP_LSM_TARGET_LEN. A
+ * truncated path stops matching a deny prefix that extends past the cut, which
+ * would turn a long path into a silent allow. Truncation and resolution
+ * failure are both refused instead.
+ */
+static int kap_lsm_check_dir_entry(const struct path *dir, struct dentry *dentry)
+{
+	char *buf;
+	char *rendered;
+	char *target;
+	int rc;
+	int len;
+
+	/* kap_path_link builds old_path by hand, so either field can be NULL.
+	 * d_path would dereference them.
+	 */
+	if (!dir || !dir->mnt || !dir->dentry || !dentry)
+		return kap_lsm_refuse_unresolved("file_path_unresolved");
+	buf = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	target = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!target) {
+		kfree(buf);
+		return -ENOMEM;
+	}
+	rendered = d_path(dir, buf, PATH_MAX);
+	if (IS_ERR(rendered)) {
+		/* No resolvable path means no way to know whether it is denied.
+		 * Refuse rather than let an unresolved target meet a broad
+		 * allow and pass.
+		 */
+		kfree(target);
+		kfree(buf);
+		return kap_lsm_refuse_unresolved("file_path_unresolved");
+	}
+	/* d_path renders the root as "/", so joining blindly gives "//name". */
+	if (!strcmp(rendered, "/"))
+		len = snprintf(target, PATH_MAX, "/%pd", dentry);
+	else
+		len = snprintf(target, PATH_MAX, "%s/%pd", rendered, dentry);
+	if (len < 0 || len >= PATH_MAX) {
+		kfree(target);
+		kfree(buf);
+		return kap_lsm_refuse_unresolved("file_path_truncated");
+	}
+	rc = kap_check_current_target_emit(KAP_HOOK_FILE, target,
+					   "file_predicate_denied",
+					   "file_allowed");
+	kfree(target);
+	kfree(buf);
+	return rc;
+}
+
+static int kap_path_rename(const struct path *old_dir, struct dentry *old_dentry,
+			   const struct path *new_dir, struct dentry *new_dentry,
+			   unsigned int flags)
+{
+	int rc;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	/* Both ends matter. The destination is the bypass being closed, and the
+	 * source stops a bound task moving a file out of a path it was never
+	 * allowed to read.
+	 */
+	rc = kap_lsm_check_dir_entry(old_dir, old_dentry);
+	if (rc)
+		return rc;
+	return kap_lsm_check_dir_entry(new_dir, new_dentry);
+}
+
+static int kap_path_link(struct dentry *old_dentry, const struct path *new_dir,
+			 struct dentry *new_dentry)
+{
+	struct path old_path;
+	struct dentry *old_parent;
+	int rc;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	/* Checking only the destination would let a denied file be linked into
+	 * an allowed directory and then read through the alias, since the later
+	 * open sees the allowed name. A hard link cannot cross a mount, so the
+	 * source shares new_dir's vfsmount.
+	 *
+	 * dget_parent pins the source's parent across the sleeping allocation
+	 * and d_path below: a bare d_parent read could be freed by a concurrent
+	 * rename of old_dentry before it is used.
+	 */
+	old_parent = (old_dentry && new_dir) ? dget_parent(old_dentry) : NULL;
+	old_path.mnt = new_dir ? new_dir->mnt : NULL;
+	old_path.dentry = old_parent;
+	rc = kap_lsm_check_dir_entry(&old_path, old_dentry);
+	dput(old_parent);
+	if (rc)
+		return rc;
+	return kap_lsm_check_dir_entry(new_dir, new_dentry);
+}
+
+static int kap_path_symlink(const struct path *dir, struct dentry *dentry,
+			    const char *old_name)
+{
+	if (!kap_lsm_current_active())
+		return 0;
+	return kap_lsm_check_dir_entry(dir, dentry);
+}
+
+/*
+ * Creating or removing an entry under a denied directory never reaches open or
+ * rename, so without these the deny still leaks for those mutations.
+ */
+static int kap_path_mknod(const struct path *dir, struct dentry *dentry,
+			  umode_t mode, unsigned int dev)
+{
+	if (!kap_lsm_current_active())
+		return 0;
+	return kap_lsm_check_dir_entry(dir, dentry);
+}
+
+static int kap_path_mkdir(const struct path *dir, struct dentry *dentry,
+			  umode_t mode)
+{
+	if (!kap_lsm_current_active())
+		return 0;
+	return kap_lsm_check_dir_entry(dir, dentry);
+}
+
+static int kap_path_unlink(const struct path *dir, struct dentry *dentry)
+{
+	if (!kap_lsm_current_active())
+		return 0;
+	return kap_lsm_check_dir_entry(dir, dentry);
+}
+
+static int kap_path_rmdir(const struct path *dir, struct dentry *dentry)
+{
+	if (!kap_lsm_current_active())
+		return 0;
+	return kap_lsm_check_dir_entry(dir, dentry);
+}
+
+static int kap_sb_mount(const char *dev_name, const struct path *path,
+			const char *type, unsigned long flags, void *data)
+{
+	char path_target[KAP_LSM_TARGET_LEN];
+	char target[KAP_LSM_TARGET_LEN];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	if (kap_lsm_path_target(path, path_target, sizeof(path_target)))
+		strscpy(path_target, "unknown", sizeof(path_target));
+	scnprintf(target, sizeof(target), "mount:mount:%s:%s",
+		  type ?: "unknown", path_target);
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
+				       "mount_predicate_denied", "mount_allowed");
+}
+
+static int kap_sb_umount(struct vfsmount *mnt, int flags)
+{
+	struct path path = { .mnt = mnt, .dentry = mnt ? mnt->mnt_root : NULL };
+	char path_target[KAP_LSM_TARGET_LEN];
+	char target[KAP_LSM_TARGET_LEN];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	if (!mnt || kap_lsm_path_target(&path, path_target, sizeof(path_target)))
+		strscpy(path_target, "unknown", sizeof(path_target));
+	scnprintf(target, sizeof(target), "mount:umount:%s", path_target);
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
+				       "mount_predicate_denied", "mount_allowed");
+}
+
+static int kap_sb_pivotroot(const struct path *old_path, const struct path *new_path)
+{
+	char old_target[KAP_LSM_TARGET_LEN];
+	char new_target[KAP_LSM_TARGET_LEN];
+	char target[KAP_LSM_TARGET_LEN];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	if (kap_lsm_path_target(old_path, old_target, sizeof(old_target)))
+		strscpy(old_target, "unknown", sizeof(old_target));
+	if (kap_lsm_path_target(new_path, new_target, sizeof(new_target)))
+		strscpy(new_target, "unknown", sizeof(new_target));
+	scnprintf(target, sizeof(target), "mount:pivotroot:%s:%s",
+		  old_target, new_target);
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
+				       "mount_predicate_denied", "mount_allowed");
+}
+
+static int kap_move_mount(const struct path *from_path, const struct path *to_path)
+{
+	char from_target[KAP_LSM_TARGET_LEN];
+	char to_target[KAP_LSM_TARGET_LEN];
+	char target[KAP_LSM_TARGET_LEN];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	if (kap_lsm_path_target(from_path, from_target, sizeof(from_target)))
+		strscpy(from_target, "unknown", sizeof(from_target));
+	if (kap_lsm_path_target(to_path, to_target, sizeof(to_target)))
+		strscpy(to_target, "unknown", sizeof(to_target));
+	scnprintf(target, sizeof(target), "mount:move:%s:%s",
+		  from_target, to_target);
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, target,
+				       "mount_predicate_denied", "mount_allowed");
+}
+
+#ifdef CONFIG_SECURITY_NETWORK
+static int kap_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
+{
+	return kap_check_static_target(KAP_HOOK_IPC, "unix:stream_connect",
+				       "ipc_predicate_denied", "ipc_allowed");
+}
+
+static int kap_unix_may_send(struct socket *sock, struct socket *other)
+{
+	return kap_check_static_target(KAP_HOOK_IPC, "unix:may_send",
+				       "ipc_predicate_denied", "ipc_allowed");
+}
+#endif
+
+static int kap_file_receive(struct file *file)
+{
+	return kap_check_current_emit(KAP_HOOK_DESCRIPTOR, file,
+				      "descriptor_predicate_denied", "descriptor_allowed");
+}
+
+static int kap_task_fix_setuid(struct cred *new, const struct cred *old, int flags)
+{
+	char target[128];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	scnprintf(target, sizeof(target), "uid=%u,euid=%u,suid=%u,fsuid=%u",
+		  __kuid_val(new->uid), __kuid_val(new->euid),
+		  __kuid_val(new->suid), __kuid_val(new->fsuid));
+	return kap_check_current_target_emit(KAP_HOOK_CRED, target,
+					     "cred_predicate_denied", "cred_allowed");
+}
+
+static int kap_task_fix_setgid(struct cred *new, const struct cred *old, int flags)
+{
+	char target[128];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	scnprintf(target, sizeof(target), "gid=%u,egid=%u,sgid=%u,fsgid=%u",
+		  __kgid_val(new->gid), __kgid_val(new->egid),
+		  __kgid_val(new->sgid), __kgid_val(new->fsgid));
+	return kap_check_current_target_emit(KAP_HOOK_CRED, target,
+					     "cred_predicate_denied", "cred_allowed");
+}
+
+static int kap_task_fix_setgroups(struct cred *new, const struct cred *old)
+{
+	return kap_check_static_target(KAP_HOOK_CRED, "groups",
+				       "cred_predicate_denied", "cred_allowed");
+}
+
+static int kap_capset(struct cred *new, const struct cred *old,
+		      const kernel_cap_t *effective,
+		      const kernel_cap_t *inheritable,
+		      const kernel_cap_t *permitted)
+{
+	return kap_check_static_target(KAP_HOOK_CRED, "capset",
+				       "cred_predicate_denied", "cred_allowed");
+}
+
+static int kap_userns_create(const struct cred *cred)
+{
+	/* Same "<ns>:<operation>" shape as clone and setns, so a policy can
+	 * allow or deny it with a "user:*" or "user:create" pattern. A bare
+	 * "user" only ever matched a wildcard.
+	 */
+	return kap_check_static_target(KAP_HOOK_NAMESPACE, "user:create",
+				       "namespace_predicate_denied", "namespace_allowed");
+}
+
+static int kap_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
+{
+	char target[64];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	scnprintf(target, sizeof(target), "sysv:flag=%hd", flag);
+	return kap_check_current_target_emit(KAP_HOOK_IPC, target,
+					     "ipc_predicate_denied", "ipc_allowed");
+}
+
+static void kap_ptrace_target(struct task_struct *child, char *target, size_t target_len)
+{
+	struct kap_task_state *current_state = kap_task_state(current);
+	struct kap_task_state *child_state = kap_task_state(child);
+
+	if (current_state && current_state->active &&
+	    child_state && child_state->active &&
+	    !strcmp(current_state->igroup_name, child_state->igroup_name) &&
+	    current_state->epoch == child_state->epoch) {
+		strscpy(target, "same-igroup", target_len);
+		return;
+	}
+	if (child_state && child_state->active) {
+		scnprintf(target, target_len, "igroup=%s", child_state->igroup_name);
+		return;
+	}
+	strscpy(target, "unconfined", target_len);
+}
+
+static int kap_ptrace_access_check(struct task_struct *child, unsigned int mode)
+{
+	char target[128];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	kap_ptrace_target(child, target, sizeof(target));
+	return kap_check_current_target_emit(KAP_HOOK_PTRACE, target,
+					     "ptrace_predicate_denied", "ptrace_allowed");
+}
+
+static int kap_ptrace_traceme(struct task_struct *parent)
+{
+	char target[128];
+
+	if (!kap_lsm_current_active())
+		return 0;
+
+	kap_ptrace_target(parent, target, sizeof(target));
+	return kap_check_current_target_emit(KAP_HOOK_PTRACE, target,
+					     "ptrace_predicate_denied", "ptrace_allowed");
+}
+
+#ifdef CONFIG_BPF_SYSCALL
+static int kap_bpf(int cmd, union bpf_attr *attr, unsigned int size, bool kernel)
+{
+	char target[128];
+
+	switch (cmd) {
+	case BPF_MAP_CREATE:
+		scnprintf(target, sizeof(target), "cmd=%d,map_type=%u",
+			  cmd, attr ? attr->map_type : 0);
+		break;
+	case BPF_PROG_LOAD:
+		scnprintf(target, sizeof(target), "cmd=%d,prog_type=%u",
+			  cmd, attr ? attr->prog_type : 0);
+		break;
+	default:
+		scnprintf(target, sizeof(target), "cmd=%d", cmd);
+		break;
+	}
+	return kap_check_current_target_emit(KAP_HOOK_BPF, target,
+					     "bpf_predicate_denied", "bpf_allowed");
+}
+#endif
+
+#ifdef CONFIG_IO_URING
+static int kap_uring_override_creds(const struct cred *new)
+{
+	return kap_check_static_target(KAP_HOOK_IO_URING, "override_creds",
+				       "io_uring_predicate_denied", "io_uring_allowed");
+}
+
+static int kap_uring_sqpoll(void)
+{
+	return kap_check_static_target(KAP_HOOK_IO_URING, "sqpoll",
+				       "io_uring_predicate_denied", "io_uring_allowed");
+}
+
+static int kap_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	return kap_check_static_target(KAP_HOOK_IO_URING, "uring_cmd",
+				       "io_uring_predicate_denied", "io_uring_allowed");
+}
+#endif
+
+/* truncate(2) changes the contents of an existing file without opening it, so
+ * none of the open or entry hooks see it. Without this a denied file can still
+ * be emptied.
+ */
+static int kap_path_truncate(const struct path *path)
+{
+	char *target;
+	int rc;
+
+	if (!kap_lsm_current_active())
+		return 0;
+	if (!path || !path->mnt || !path->dentry)
+		return kap_lsm_refuse_unresolved("file_path_unresolved");
+	target = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!target)
+		return -ENOMEM;
+	rc = kap_lsm_path_target(path, target, PATH_MAX);
+	if (rc) {
+		kfree(target);
+		return kap_lsm_refuse_unresolved("file_path_unresolved");
+	}
+	rc = kap_check_current_target_emit(KAP_HOOK_FILE, target,
+					   "file_predicate_denied", "file_allowed");
+	kfree(target);
+	return rc;
+}
+
+static struct security_hook_list kap_hooks[] __ro_after_init = {
+	LSM_HOOK_INIT(task_alloc, kap_task_alloc),
+	LSM_HOOK_INIT(task_free, kap_task_free),
+	LSM_HOOK_INIT(bprm_check_security, kap_bprm_check_security),
+	LSM_HOOK_INIT(sb_mount, kap_sb_mount),
+	LSM_HOOK_INIT(sb_umount, kap_sb_umount),
+	LSM_HOOK_INIT(sb_pivotroot, kap_sb_pivotroot),
+	LSM_HOOK_INIT(move_mount, kap_move_mount),
+	LSM_HOOK_INIT(file_open, kap_file_open),
+	LSM_HOOK_INIT(file_permission, kap_file_permission),
+	LSM_HOOK_INIT(mmap_file, kap_mmap_file),
+	LSM_HOOK_INIT(file_mprotect, kap_file_mprotect),
+	LSM_HOOK_INIT(file_receive, kap_file_receive),
+	LSM_HOOK_INIT(path_rename, kap_path_rename),
+	LSM_HOOK_INIT(path_link, kap_path_link),
+	LSM_HOOK_INIT(path_symlink, kap_path_symlink),
+	LSM_HOOK_INIT(path_mknod, kap_path_mknod),
+	LSM_HOOK_INIT(path_mkdir, kap_path_mkdir),
+	LSM_HOOK_INIT(path_unlink, kap_path_unlink),
+	LSM_HOOK_INIT(path_rmdir, kap_path_rmdir),
+	LSM_HOOK_INIT(path_truncate, kap_path_truncate),
+#ifdef CONFIG_SECURITY_NETWORK
+	LSM_HOOK_INIT(socket_connect, kap_socket_connect),
+	LSM_HOOK_INIT(unix_stream_connect, kap_unix_stream_connect),
+	LSM_HOOK_INIT(unix_may_send, kap_unix_may_send),
+#endif
+	LSM_HOOK_INIT(task_fix_setuid, kap_task_fix_setuid),
+	LSM_HOOK_INIT(task_fix_setgid, kap_task_fix_setgid),
+	LSM_HOOK_INIT(task_fix_setgroups, kap_task_fix_setgroups),
+	LSM_HOOK_INIT(capset, kap_capset),
+	LSM_HOOK_INIT(userns_create, kap_userns_create),
+	LSM_HOOK_INIT(ipc_permission, kap_ipc_permission),
+	LSM_HOOK_INIT(ptrace_access_check, kap_ptrace_access_check),
+	LSM_HOOK_INIT(ptrace_traceme, kap_ptrace_traceme),
+#ifdef CONFIG_BPF_SYSCALL
+	LSM_HOOK_INIT(bpf, kap_bpf),
+#endif
+#ifdef CONFIG_IO_URING
+	LSM_HOOK_INIT(uring_override_creds, kap_uring_override_creds),
+	LSM_HOOK_INIT(uring_sqpoll, kap_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, kap_uring_cmd),
+#endif
+};
+
+static const struct lsm_id kap_lsmid = {
+	.name = "kap",
+	.id = LSM_ID_KAP,
+};
+
+static int __init kap_lsm_init(void)
+{
+	WRITE_ONCE(kap_lsm_active, true);
+	security_add_hooks(kap_hooks, ARRAY_SIZE(kap_hooks), &kap_lsmid);
+	pr_info("LSM hooks registered\n");
+	return 0;
+}
+
+DEFINE_LSM(kap) = {
+	.id = &kap_lsmid,
+	.blobs = &kap_blob_sizes,
+	.init = kap_lsm_init,
+};
-- 
2.43.0


