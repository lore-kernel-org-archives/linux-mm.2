Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A75606A8AE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EhHlrraZ
Received: by kanga.kvack.org (Postfix)
	id 292F36B05DB; Tue, 10 Nov 2026 15:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271BC6B05DC; Tue, 10 Nov 2026 15:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1590F6B05DD; Tue, 10 Nov 2026 15:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB8266B05DB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:24:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 684E940A55
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:09 +0000 (UTC)
X-FDA: 85420336218.28.5DE29FC
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7A1FD40005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=EhHlrraZ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.175 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtvZ3Gl7HiauN/U6RPjLeG8VrmAZzpATIBrE7cPT6wA=;
	b=iW1xq9p0Hn4vaSZSiHbEQ2VRtbhLrU0/2XcHbmWf/25by3+PAwvebdNOy41ppgw/CLwaG4
	X5DPAPJkIo/FLe/9jqj3MdAOIf8tlpZJy1xqb7eL7FU89wI3HcvtvHBw9n0z+MApszpRs+
	WdXjnkObgzVV5T+Eby7CV7dPveoR/cU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=EhHlrraZ;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.175 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342247;
	b=p7Fma3YbclHzc744lkW9S9BHlWh6HyXdSQICW7HZzGv/PhovAkLiobLGl46x2Fr/uTkzMp
	AfRxRRXh/a9L6bn9RXbIFOYNkjYq9cPwt+Rz1r+RGmu8kkNruu22Oj8Ry52e/V0Z7gAyHv
	O+RlqPOdPjKSVA1DMMTDdSZRZdE2KqQ=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36dbde64409so5076096eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1794342246; x=1794947046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LtvZ3Gl7HiauN/U6RPjLeG8VrmAZzpATIBrE7cPT6wA=;
        b=EhHlrraZ8r3EgSOVKTGpJ7RrVeXi3oA+G84yM02QjF6JxoJp3J5HpScxk/qdNJAEz0
         PUYhoRCo7lnyYz+cxYF209XeOVkVSGiqvXN0P7jovJAhQRevHdElLHIUuuB+hmCP2pN5
         mShkI1V3J1niioPZg9GmhifbkLt1C1PN6JlIKWNMfSORVJBGFZiJPzTNKxprzOt6/hbB
         AUA7A1w0YgT9PewTLDbvZnowRl/m4FhFADQ92vJXoOWga1+QF60KHPrBrKkv4h+LV9BU
         XJoJG2w7r3Wr0dgo3jIul/QPbZxnHP9G0ztC5CbIXt3Mk4eFr372TvxfT48oOqyNDUvy
         fsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794342246; x=1794947046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LtvZ3Gl7HiauN/U6RPjLeG8VrmAZzpATIBrE7cPT6wA=;
        b=HZ0ThrHHkUnmr7gGAMkcE7QZliY7BMFU0wpsVmArY68qfKK65NB1I5Z4iPRhQeBEw2
         8Of5AUDC17XupjpOztlrzI6ZrxKG9c4rsP+Lspg21g8RrVL03QO0ny70wrIwqxSSklGt
         7oEafz+6U13bkbcK/kFuJliorwxYTvzitpBK62lOPUVOK0K/njgXCXT1uPE+jbNhGiQ9
         y9zzlqkoUw+ylaJaJvZCWNER7nBsQMAu0+rQd8EYPc5gKNx02iBLNlnOuqzPOVLU5XYX
         y6cznA+k7zugZZDgLXIqTotHEgf1nSNG54fuNkU8zGi9+XYcHkfLdHGxLiF7pt9l6ElR
         lfuA==
X-Forwarded-Encrypted: i=1; AL+hErHOnLt5yVAeYJZPLA8e4es9lVaUhAFbof1I9j/PLiKTAXXYDDEt1RJKmJWB9DKURdeUFVg9CQYjrQ==@kvack.org
X-Gm-Message-State: APuU4Z/g1dOCmEzQmOP3RZ9moE8ZtlTIRohu0o6Sw82PE3NBcBFYuCyM
	p1wgPtY/qSk0tqn4BODUbJXh0yDD09fdfXOAusGehczpgC/JBiSc/dzc5YnLsb7/ycS0
X-Gm-Gg: AYBFou2t7KFEaQjrwPHnu8VSiZycXR4O054NfsaCLM+AEt4nMBaU1F0wu8DkJCNhR8n
	gMnzQ+BWzLwjktfnCcnwYMaHQSMzWlXTnN487h5ehCJLLUDQOMJRfqDodNlQ4maVR7WHzdYSxS+
	IlMY33dTwLkzwKr7xV6oohSk8wWkMFEA9F0Ouhfsl5Nf0dfeGZnYdTtEWO3Z15kuLRvcd6+BLob
	ol9uZNCDWmD+fmmnutP0smbS/kFYGKCeioHHfH8tP0dDhjwJ9SQVDvuEaIWpgUInCD+DS9bpcIO
	/LlZRHA6rkfjZHNVc4snR/IKP1Y1DiN+J49RW6rE1wJZVQgYK11UJvcE2a/L3nC/UTvSUixjqoD
	x5hk7IEalIq9sYdZbDKK8PC3gXDfEybC56G1gXAfT3gUmkZ01V6V96eNLZEU/LjLgMOFwq1FO3V
	OYOukounhRWpqjj5SuFKUgOTAjtOYeH8Yq7AXcwETu9KhewI4tO7wBijwTok1pmr46vWQlGyGrJ
	w+y7GexkY8mtg1ACqi3GmtwXjJy9Oheq0KX2q8J4eX/G6srKDnBg16LYX1zUeVZcIZaKPOwC5sn
	Z8KSkngE9HyAZkYvLWf2CJx+/gt0ivhCYl4oGtSWGgmBPcQaKQtf7cpHnZ4cQTzJyfjikQrORaF
	o+pFVEyGulwF012gtG70za2DxSTyY305a5t9MOScQRGgPh6lkEtn9NQ==
X-Received: by 2002:a05:7301:1a0d:b0:375:388:a6d5 with SMTP id 5a478bee46e88-376867551e5mr525868eec.32.1794342245674;
        Tue, 10 Nov 2026 12:24:05 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:147:2742:6545:702a:2431:7dca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfe29fsm10076615eec.21.2026.11.10.12.23.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 12:24:05 -0800 (PST)
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
Subject: [RFC PATCH v3 4/6] security: kap: add the securityfs control plane
Date: Wed, 11 Nov 2026 01:52:44 +0530
Message-ID: <20261110202246.274-5-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261110202246.274-1-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A1FD40005
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: r4rgutidjbj31kin39yndothbtuw9upe
X-HE-Tag: 1794342247-557877
X-HE-Meta: U2FsdGVkX1/2UkSO8g7krG3djZ8IPWGWZW25hSCngVDzybcF7oel6DBAHc2AL3eHjAbn1cyVewHgSaGjAso//nbeVO1YsfEFXl9OtSalDWnkUadsDiczlmFBpchrurYD5/Djzpx/y40nWXDKRg0XC026RAlPv1mTohBrPXPpyK5ecw9cI1YDePAlCuETCrTGGcWGvga83UIazbwcFQP9sBbgsy70RACgcWT9v/OwZ10MJ1x7nQqLdGrGIYTVUsY4hjy0Uuv33kBMyguZwwu6Ue3FQqvcqhpskAFgIVdd+x7POvn6Pc5n60IQwbeYV7Gkh89prfp8dpm//+BcoFAP/yBPOr6FJF4txK16Zx5cqewirZUaybkpRqSHnQimk8zDigJasTSFpMCZb02V2jV/0VcoRDbUIBduKF4eh48joozqTru+eHTxUkSXOj2MCyeM9fnFDXh6oqmbugOOr79kJWDAhDCdd/2kqydbkMqtvR6RXNlUvTN3NjgVUD+nh8EzH8nVbB+ahf4yVQ6cdvl8I99mINYmBHxIMpRDQdKt6e0BKWOmXlcxOq/0CwPQyfV4lFbsAKsRZNthSDyapwMGjX2lfAD8mgXbbvN2R/z1ypViPQNngCkoKxQ2Yq+/qSEgAXId7W5NKE4euBsu0lZ7jau8T+oCUj5vKbZqMtrefElI60GCKtnVBw0LKN/ovrORV6iJQPl+QdHOtGMohvV+qfxGPlX5c7WUwO6OqpZtp6GhTPOqepppWSPKIBl3JFvZb9I2S/e8B/xrVqs313Fg0nL1+bkoNgusQ7NVllLvqyYevnQA9Yp815NSF9ZzuKcRvbjHd6PR6groU5Dgbael5U/jUjbR0Bm8rvDFDiOqIpEGS/w1XeP/l5s2M0/x7O0MfVH7VlOxhr7U6KPY+vDlJgyXmbFLVZjCWiEweZTaBzoS33m5tAL/GT3ZxTv8DhiK9QdVMiJV74xX31WXr6e
 gV5tiwpi
 y5QmNUa1srZ+DSdTJoqb5KCAdZPKTTwn4PTGpaasMA6evbu81P+gEnND6RnISpjllWjmb5mNG3Ut/FdAksVHvGX5ktZo056KaSYwBEEVevHKZyX7VGR4Jqe2vZ9LNWLz3mfF6XBQ+ikl8CtdvCnBX34Nz9xd+2nu1FywDwXjVBuHr/5vf2tRGctNSu0jUjzwWVcxKPXEaYDACByRrO6lIPMzxtxUDStTiaqNnAMC5h4eqcvOt/wLg/ch7P+DfD+dr0HB/fE0WwTebbGGheeVu6v+CGQ2TdUZIWvKzqkNl4O6jmaE+5kJDiGz+OHEGwCJCW3/D6uFqOAVFISa0yOonp7s4T4BP8cnefD/ULrBHbwifNWIPVMF2jvgvt4lZkkLrU0MY0CiluSpAcQgAaDwF5HKTZIJOLHqnbbsglYN0I/I3YQGrW6qrscDmeBSCwRJVojDS/KGJBYRlHgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add the KAP control plane under /sys/kernel/security/kap.

securityfs has no mkdir, so igroups live in a small internal filesystem
mounted with kern_mount() and reached through the igroups link in the
kap directory, as AppArmor publishes its policy namespaces. An igroup is
created with mkdir, as a cgroup is, and gets one file per control:
kap.install writes the lineage root, authority epoch, expiry, transition
and authority in a single write that commits together or not at all,
and kap.procs binds a task. kap.default sits next to igroups/.

Writes need CAP_SYS_ADMIN. The internal filesystem type is never
registered, so it cannot be mounted from userspace.

Assisted-by: Claude
Co-developed-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
---
 security/kap/Makefile  |   2 +-
 security/kap/kap_lsm.c |   1 +
 security/kap/kapfs.c   | 522 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 524 insertions(+), 1 deletion(-)
 create mode 100644 security/kap/kapfs.c

diff --git a/security/kap/Makefile b/security/kap/Makefile
index 40a864c..6ef7c5e 100644
--- a/security/kap/Makefile
+++ b/security/kap/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_SECURITY_KAP) := kap.o
-kap-y := kap_lsm.o igroup.o
+kap-y := kap_lsm.o igroup.o kapfs.o
diff --git a/security/kap/kap_lsm.c b/security/kap/kap_lsm.c
index b148b34..6750114 100644
--- a/security/kap/kap_lsm.c
+++ b/security/kap/kap_lsm.c
@@ -862,4 +862,5 @@ DEFINE_LSM(kap) = {
 	.id = &kap_lsmid,
 	.blobs = &kap_blob_sizes,
 	.init = kap_lsm_init,
+	.initcall_fs = kap_securityfs_init,
 };
diff --git a/security/kap/kapfs.c b/security/kap/kapfs.c
new file mode 100644
index 0000000..b182ff2
--- /dev/null
+++ b/security/kap/kapfs.c
@@ -0,0 +1,522 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Kernel Assurance Plane control plane in securityfs.
+ *
+ *   /sys/kernel/security/kap/
+ *     kap.default
+ *     igroups/                 link to the root of the internal kapfs mount
+ *       <igroup>/              created with mkdir, as a cgroup is
+ *         kap.install
+ *         kap.procs
+ *         kap.igfd
+ *         kap.lineage_root
+ *         kap.authority_epoch
+ *         kap.authority
+ *         kap.expires_at
+ *         kap.transition
+ *         kap.mode
+ *         kap.events
+ *
+ * securityfs has no mkdir, so igroups live in a small internal filesystem that
+ * is mounted with kern_mount() and reached through a link under securityfs.
+ * AppArmor publishes its policy namespaces the same way.
+ */
+
+#define pr_fmt(fmt) "KAP: " fmt
+
+#include <linux/capability.h>
+#include <linux/ctype.h>
+#include <linux/dcache.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/mount.h>
+#include <linux/spinlock.h>
+#include <linux/namei.h>
+#include <linux/security.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/timekeeping.h>
+#include <linux/uaccess.h>
+
+#include "kap.h"
+
+#define KAPFS_MAGIC 0x4b415046
+
+static struct vfsmount *kapfs_mnt;
+static struct dentry *kap_sfs_dir;
+static struct dentry *kap_sfs_default;
+static struct kap_file_ctx kap_default_ctx = { .kind = KAP_FILE_DEFAULT };
+
+static const char * const kap_file_names[KAP_FILE_COUNT] = {
+	[KAP_FILE_PROCS] = "kap.procs",
+	[KAP_FILE_IGFD] = "kap.igfd",
+	[KAP_FILE_LINEAGE_ROOT] = "kap.lineage_root",
+	[KAP_FILE_AUTHORITY_EPOCH] = "kap.authority_epoch",
+	[KAP_FILE_AUTHORITY] = "kap.authority",
+	[KAP_FILE_TRANSITION] = "kap.transition",
+	[KAP_FILE_MODE] = "kap.mode",
+	[KAP_FILE_EVENTS] = "kap.events",
+	[KAP_FILE_EXPIRES_AT] = "kap.expires_at",
+	[KAP_FILE_INSTALL] = "kap.install",
+};
+
+static const umode_t kap_file_modes[KAP_FILE_COUNT] = {
+	[KAP_FILE_PROCS] = 0600,
+	[KAP_FILE_IGFD] = 0400,
+	[KAP_FILE_LINEAGE_ROOT] = 0600,
+	[KAP_FILE_AUTHORITY_EPOCH] = 0600,
+	[KAP_FILE_AUTHORITY] = 0600,
+	[KAP_FILE_TRANSITION] = 0600,
+	[KAP_FILE_MODE] = 0600,
+	[KAP_FILE_EXPIRES_AT] = 0600,
+	[KAP_FILE_INSTALL] = 0200,
+	[KAP_FILE_EVENTS] = 0400,
+};
+
+static int kapfs_show(struct seq_file *m, void *v)
+{
+	struct kap_file_ctx *ctx = m->private;
+	struct kap_igroup *igroup = ctx->igroup;
+	struct kap_bound_pid *entry;
+
+	spin_lock(&kap_lock);
+	switch (ctx->kind) {
+	case KAP_FILE_PROCS:
+		list_for_each_entry(entry, &igroup->pids, node)
+			seq_printf(m, "%d\n", entry->pid);
+		break;
+	case KAP_FILE_IGFD:
+		seq_printf(m, "igroup=%s epoch=%llu root=%s\n",
+			   igroup->name, igroup->epoch, igroup->lineage_root);
+		break;
+	case KAP_FILE_LINEAGE_ROOT:
+		seq_printf(m, "%s\n", igroup->lineage_root);
+		break;
+	case KAP_FILE_AUTHORITY_EPOCH:
+		seq_printf(m, "%llu\n", igroup->epoch);
+		break;
+	case KAP_FILE_AUTHORITY:
+		seq_write(m, igroup->authority, igroup->authority_len);
+		if (igroup->authority_len && igroup->authority[igroup->authority_len - 1] != '\n')
+			seq_putc(m, '\n');
+		break;
+	case KAP_FILE_TRANSITION:
+		if (igroup->has_sequence)
+			seq_printf(m, "last_sequence=%llu\n", igroup->last_sequence);
+		break;
+	case KAP_FILE_MODE:
+		seq_printf(m, "%s\n", igroup->revoked ? "revoked" : "enforce");
+		break;
+	case KAP_FILE_EVENTS:
+		seq_write(m, igroup->events, igroup->events_len);
+		break;
+	case KAP_FILE_EXPIRES_AT:
+		seq_printf(m, "%llu\n", igroup->expires_at);
+		break;
+	case KAP_FILE_DEFAULT:
+		seq_printf(m, "%s\n", kap_default_closed ? "closed" : "open");
+		break;
+	default:
+		break;
+	}
+	spin_unlock(&kap_lock);
+	return 0;
+}
+
+static int kapfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, kapfs_show, inode->i_private);
+}
+
+static ssize_t kapfs_write(struct file *file, const char __user *buf, size_t len, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct kap_file_ctx *ctx = seq->private;
+	struct kap_igroup *igroup = ctx->igroup;
+	struct kap_compiled_authority *compiled = NULL;
+	struct kap_bound_pid *entry = NULL;
+	struct kap_install_request req;
+	u64 value = 0;
+	pid_t pid = 0;
+	char *tmp;
+	int rc = 0;
+
+	/* The opener's credentials, so a handed-over descriptor gains nothing. */
+	if (!file_ns_capable(file, &init_user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (len == 0)
+		return 0;
+	if (len > (ctx->kind == KAP_FILE_INSTALL ? KAP_MAX_INSTALL_BYTES
+						 : KAP_MAX_PREDICATE_BYTES))
+		return -EINVAL;
+	if (ctx->kind == KAP_FILE_EVENTS || ctx->kind == KAP_FILE_IGFD)
+		return -EINVAL;
+
+	tmp = memdup_user_nul(buf, len);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+	kap_trim_newline(tmp);
+	if (!tmp[0]) {
+		kfree(tmp);
+		return len;
+	}
+
+	/* Parse, allocate and compile first: kap_lock is a spinlock. */
+	switch (ctx->kind) {
+	case KAP_FILE_PROCS:
+		rc = kstrtoint(tmp, 10, &pid);
+		if (!rc) {
+			entry = kzalloc_obj(*entry, GFP_KERNEL);
+			if (!entry)
+				rc = -ENOMEM;
+		}
+		break;
+	case KAP_FILE_LINEAGE_ROOT:
+		if (strlen(tmp) > KAP_MAX_ROOT_LEN)
+			rc = -EINVAL;
+		break;
+	case KAP_FILE_INSTALL:
+		rc = kap_install_parse(tmp, &req);
+		if (!rc)
+			rc = kap_authority_prepare(req.authority, &compiled);
+		break;
+	case KAP_FILE_AUTHORITY:
+		rc = kap_authority_prepare(tmp, &compiled);
+		break;
+	case KAP_FILE_AUTHORITY_EPOCH:
+	case KAP_FILE_EXPIRES_AT:
+		rc = kstrtou64(tmp, 10, &value);
+		break;
+	case KAP_FILE_TRANSITION:
+		rc = kap_parse_transition_sequence(tmp, &value);
+		break;
+	case KAP_FILE_MODE:
+		if (!sysfs_streq(tmp, "revoked") && !sysfs_streq(tmp, "enforce"))
+			rc = -EINVAL;
+		break;
+	case KAP_FILE_DEFAULT:
+		if (!sysfs_streq(tmp, "closed") && !sysfs_streq(tmp, "open"))
+			rc = -EINVAL;
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	if (rc)
+		goto out;
+
+	spin_lock(&kap_lock);
+	switch (ctx->kind) {
+	case KAP_FILE_PROCS:
+		rc = kap_bind_pid_locked(igroup, pid, &entry);
+		break;
+	case KAP_FILE_LINEAGE_ROOT:
+		strscpy(igroup->lineage_root, tmp, sizeof(igroup->lineage_root));
+		break;
+	case KAP_FILE_INSTALL:
+		rc = kap_install_locked(igroup, &req, &compiled);
+		break;
+	case KAP_FILE_AUTHORITY_EPOCH:
+		/* Writing an epoch also clears revoked mode. */
+		if (value < igroup->epoch) {
+			rc = -ESTALE;
+		} else {
+			igroup->epoch = value;
+			igroup->revoked = false;
+		}
+		break;
+	case KAP_FILE_AUTHORITY: {
+		struct kap_compiled_authority *old = igroup->compiled;
+
+		strscpy(igroup->authority, tmp, sizeof(igroup->authority));
+		igroup->authority_len = strlen(igroup->authority);
+		igroup->compiled = compiled;
+		compiled = old;
+		break;
+	}
+	case KAP_FILE_TRANSITION:
+		if (igroup->has_sequence && value <= igroup->last_sequence) {
+			rc = -EALREADY;
+		} else {
+			igroup->last_sequence = value;
+			igroup->has_sequence = true;
+		}
+		break;
+	case KAP_FILE_EXPIRES_AT:
+		/* An expiry already in the past is refused rather than installed. */
+		if (value && (u64)ktime_get_real_seconds() >= value)
+			rc = -ESTALE;
+		else
+			igroup->expires_at = value;
+		break;
+	case KAP_FILE_MODE:
+		igroup->revoked = sysfs_streq(tmp, "revoked");
+		break;
+	case KAP_FILE_DEFAULT:
+		WRITE_ONCE(kap_default_closed, sysfs_streq(tmp, "closed"));
+		break;
+	default:
+		break;
+	}
+	spin_unlock(&kap_lock);
+out:
+	/* Whatever was not consumed: a refused document, or the replaced one. */
+	kvfree(compiled);
+	kfree(entry);
+	kfree(tmp);
+	return rc ? rc : len;
+}
+
+static const struct file_operations kapfs_fops = {
+	.owner = THIS_MODULE,
+	.open = kapfs_open,
+	.read = seq_read,
+	.write = kapfs_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct inode *kapfs_make_inode(struct super_block *sb, umode_t mode)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (!inode)
+		return NULL;
+	inode->i_ino = get_next_ino();
+	inode->i_mode = mode;
+	simple_inode_init_ts(inode);
+	return inode;
+}
+
+static void kapfs_instantiate(struct dentry *dentry, struct inode *inode)
+{
+	d_make_persistent(dentry, inode);
+}
+
+/* Names end up in kap.events and the kernel log, so keep them plain. */
+static bool kapfs_valid_name(const struct qstr *name)
+{
+	unsigned int i;
+
+	if (name->len == 0 || name->len > KAP_MAX_NAME_LEN || name->name[0] == '.')
+		return false;
+	for (i = 0; i < name->len; i++) {
+		unsigned char c = name->name[i];
+
+		if (!isalnum(c) && c != '-' && c != '_' && c != '.')
+			return false;
+	}
+	return true;
+}
+
+/* Returns NULL on success: the passed dentry is the one instantiated. */
+static struct dentry *kapfs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+				  struct dentry *dentry, umode_t mode)
+{
+	struct dentry *files[KAP_FILE_COUNT] = {};
+	struct inode *inodes[KAP_FILE_COUNT] = {};
+	struct kap_igroup *igroup;
+	struct inode *inode;
+	int rc = 0;
+	int i;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+	if (!kapfs_valid_name(&dentry->d_name))
+		return ERR_PTR(-EINVAL);
+
+	/* Allocate everything first, so a failure leaves nothing behind. */
+	igroup = kvzalloc_obj(*igroup, GFP_KERNEL);
+	inode = kapfs_make_inode(dir->i_sb, S_IFDIR | 0700);
+	if (!igroup || !inode) {
+		rc = -ENOMEM;
+		goto err;
+	}
+	memcpy(igroup->name, dentry->d_name.name, dentry->d_name.len);
+	INIT_LIST_HEAD(&igroup->pids);
+	INIT_LIST_HEAD(&igroup->node);
+	for (i = 0; i < KAP_FILE_COUNT; i++) {
+		files[i] = d_alloc_name(dentry, kap_file_names[i]);
+		inodes[i] = kapfs_make_inode(dir->i_sb, S_IFREG | kap_file_modes[i]);
+		if (!files[i] || !inodes[i]) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		igroup->files[i].kind = i;
+		igroup->files[i].igroup = igroup;
+		inodes[i]->i_fop = &kapfs_fops;
+		inodes[i]->i_private = &igroup->files[i];
+	}
+
+	spin_lock(&kap_lock);
+	if (kap_find_igroup_locked(igroup->name))
+		rc = -EEXIST;
+	else
+		list_add_tail(&igroup->node, &kap_igroups);
+	spin_unlock(&kap_lock);
+	if (rc)
+		goto err;
+
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	inc_nlink(inode);
+	inc_nlink(dir);
+	/* Lookups in the new directory wait until its files are all there. */
+	inode_lock(inode);
+	kapfs_instantiate(dentry, inode);
+	igroup->dentry = dentry;
+	for (i = 0; i < KAP_FILE_COUNT; i++)
+		kapfs_instantiate(files[i], inodes[i]);
+	inode_unlock(inode);
+	return NULL;
+
+err:
+	for (i = 0; i < KAP_FILE_COUNT; i++) {
+		if (inodes[i])
+			iput(inodes[i]);
+		if (files[i])
+			dput(files[i]);
+	}
+	if (inode)
+		iput(inode);
+	kvfree(igroup);
+	return ERR_PTR(rc);
+}
+
+static const struct inode_operations kapfs_root_inode_ops = {
+	.lookup = simple_lookup,
+	.mkdir = kapfs_mkdir,
+};
+
+static int kapfs_fill_super(struct super_block *sb, struct fs_context *fc)
+{
+	struct inode *inode;
+
+	sb->s_magic = KAPFS_MAGIC;
+	inode = kapfs_make_inode(sb, S_IFDIR | 0700);
+	if (!inode)
+		return -ENOMEM;
+	inode->i_op = &kapfs_root_inode_ops;
+	inode->i_fop = &simple_dir_operations;
+	inc_nlink(inode);
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root)
+		return -ENOMEM;
+	return 0;
+}
+
+static int kapfs_get_tree(struct fs_context *fc)
+{
+	return get_tree_single(fc, kapfs_fill_super);
+}
+
+static const struct fs_context_operations kapfs_context_ops = {
+	.get_tree = kapfs_get_tree,
+};
+
+static int kapfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &kapfs_context_ops;
+	return 0;
+}
+
+/* Never registered, so it cannot be mounted from userspace. */
+static struct file_system_type kapfs_type = {
+	.owner = THIS_MODULE,
+	.name = "kapfs",
+	.init_fs_context = kapfs_init_fs_context,
+	.kill_sb = kill_anon_super,
+};
+
+static const char *kap_igroups_get_link(struct dentry *dentry,
+					struct inode *inode,
+					struct delayed_call *done)
+{
+	struct path path;
+	int rc;
+
+	if (!dentry)
+		return ERR_PTR(-ECHILD);
+	path.mnt = mntget(kapfs_mnt);
+	path.dentry = dget(kapfs_mnt->mnt_root);
+	rc = nd_jump_link(&path);
+	return ERR_PTR(rc);
+}
+
+static int kap_igroups_readlink(struct dentry *dentry, char __user *buffer,
+				int buflen)
+{
+	char name[32];
+	int rc;
+
+	rc = snprintf(name, sizeof(name), "kapfs:[%llu]",
+		      (unsigned long long)d_inode(kapfs_mnt->mnt_root)->i_ino);
+	if (rc <= 0 || rc >= sizeof(name))
+		return -ENOENT;
+	return readlink_copy(buffer, buflen, name, rc);
+}
+
+static const struct inode_operations kap_igroups_link_iops = {
+	.readlink = kap_igroups_readlink,
+	.get_link = kap_igroups_get_link,
+};
+
+int __init kap_securityfs_init(void)
+{
+	struct dentry *dent;
+	int rc;
+
+	if (!READ_ONCE(kap_lsm_active))
+		return 0;
+
+	kapfs_mnt = kern_mount(&kapfs_type);
+	if (IS_ERR(kapfs_mnt)) {
+		rc = PTR_ERR(kapfs_mnt);
+		kapfs_mnt = NULL;
+		goto err;
+	}
+	kapfs_mnt->mnt_sb->s_flags &= ~SB_NOUSER;
+
+	dent = securityfs_create_dir("kap", NULL);
+	if (IS_ERR(dent)) {
+		rc = PTR_ERR(dent);
+		goto err_unmount;
+	}
+	kap_sfs_dir = dent;
+
+	dent = securityfs_create_file("kap.default", 0600, kap_sfs_dir,
+				      &kap_default_ctx, &kapfs_fops);
+	if (IS_ERR(dent)) {
+		rc = PTR_ERR(dent);
+		goto err_remove;
+	}
+	kap_sfs_default = dent;
+
+	dent = securityfs_create_symlink("igroups", kap_sfs_dir, NULL,
+					 &kap_igroups_link_iops);
+	if (IS_ERR(dent)) {
+		rc = PTR_ERR(dent);
+		goto err_remove;
+	}
+
+	WRITE_ONCE(kap_ready, true);
+	pr_info("control plane at /sys/kernel/security/kap\n");
+	return 0;
+
+err_remove:
+	securityfs_remove(kap_sfs_default);
+	securityfs_remove(kap_sfs_dir);
+	kap_sfs_default = NULL;
+	kap_sfs_dir = NULL;
+err_unmount:
+	kern_unmount(kapfs_mnt);
+	kapfs_mnt = NULL;
+err:
+	pr_err("could not create the securityfs control plane: %d\n", rc);
+	return rc;
+}
-- 
2.53.0


