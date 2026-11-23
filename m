Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D7D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=armoriq-io.20260707.gappssmtp.com header.i=@armoriq-io.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OC7S2n1W
Received: by kanga.kvack.org (Postfix)
	id 585EB6B05BE; Mon, 23 Nov 2026 06:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D046B05BF; Mon, 23 Nov 2026 06:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BC96B05C0; Mon, 23 Nov 2026 06:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9426B05BE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:44:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DAE4408A5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:46 +0000 (UTC)
X-FDA: 85466201772.24.D279117
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0AB2140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:44:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=OC7S2n1W;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434284;
	b=avkbluTmGUcgOHE6ennYFDYSFgl3B67C0Fc5/ve2beRzw3XjJWorWXnWApT36zljsIbfBP
	Psszdjx9sJt8YdUSh48h8tTZ0iILVgoaK9GieLYNur2shIGOEr4ZtR3TZuOWSV1jtFincp
	EjkzZF5jXak2KemMEmPK9GOKAt+dURI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGDoAio23mOS3oHpdPEQ8rMjdY99CraXVFFytYBe7DI=;
	b=k3+ZREnhOzZrGbpYzMsqn8s9k3lPBpHxF3dROz0Ucvy+qXcG/t5sAllI4QACeybtyf3QZs
	QwasJwi3HG1yz6DqCcRd4MnqNOTsqvKUrEmho7A8lW/xeQGDu/WcTbHNVPa1tF4iFooKOP
	jqPZPq8NNHIzsnOUXO5SckSI5ANR0ZU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=armoriq-io.20260707.gappssmtp.com header.s=20260707 header.b=OC7S2n1W;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of harisudhan@armoriq.io designates 74.125.82.169 as permitted sender) smtp.mailfrom=harisudhan@armoriq.io
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-3869f03af6aso2269415eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=armoriq-io.20260707.gappssmtp.com; s=20260707; t=1795434283; x=1796039083; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UGDoAio23mOS3oHpdPEQ8rMjdY99CraXVFFytYBe7DI=;
        b=OC7S2n1WTv8TqJsETsc1jiHaP4Fc8MvORGnK4zuLChFJlJjdtQvXJ2GQkW48IQMWTE
         2x8d3jx7PAFAcTa1jYFe44V91JaEDEVFc5Eim9Ks628TN/9O8eu1VNU5OYrhCdZd/BFq
         ANUMWS31E6nJyRjJpHVWD7csuCTRsZxP+xteEZfx8kpKdN9OmCN8DijVTHFeChQuHwqM
         REUN4bVbSQKaBxKYjB6qJTw/SvTJKwPXGBXZKmEwqJoxI68ungw1jx4xMJXD4dEZjSUx
         tD0tf3Pg+uAusI0ddrUKZ+6QZknhIRnTBxqnmfN8m9PKW/yaxI6l5GoikneN4Zw3p0MS
         XTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434283; x=1796039083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UGDoAio23mOS3oHpdPEQ8rMjdY99CraXVFFytYBe7DI=;
        b=KIw9/3TBaXlhFv2ccA+8WN34qRcQfx8tVgUXjiZrMRo73OMpifZiH6Ape2QMb7SgsN
         ho5u6qvj3JpmCyg86HuOEO/ElJLxrsdRHqGAhfHGlNrtuBqdT6aCFZR2hmdOQwRIad2c
         IGKuPmy7WFbncZSYMB8+oqcc23n2627ncFFX3K51qv2uyDt9u960snhPquTgvV1Y0hUP
         0kEnF+6JAb7lOu4Fufs/m0h4o0WXbxtXHuLF4srqsO5kq+Dm2sHtKRxsdk7qPyBBKHl9
         glgrz0usdYHj/G4DAEMH7kIGviqb0XwGPEGGiUvumQFTmbn83rE+sstDRWsVYicA/DMO
         ZDlg==
X-Forwarded-Encrypted: i=1; AL+hErGy98ZNM98yDXuqorNq0gWLxFevW1LadPse+sVqdf+wCODZKKaZYVJjkd2xPRd6s2bgMqy/BNc5Ww==@kvack.org
X-Gm-Message-State: APuU4Z9LSHyT8NIq7U98/fIjrYYYNaiIS9GMy2xECpYr0V3XTXlHPcsC
	esyx5gew7Soaz20cd767HzMILd2WWSAHEF+ZcuIZUmCTenMUeTp7bI7mOcRHz7XcSc1z
X-Gm-Gg: AZFdTZf8O8Tb34UljCi2Ggo1uZlR3k4Kg9GMpKBaTTsbGN8E9Jq9g3txXya+PSseRhr
	l8SGtSL92u2txmEhALHHHX6zY62fJ3qGiiFaVNTdiokoPMo0YGbL5txNzwomZqSXYBOjNAnm2FV
	B4JjyL4GM5jq6t/KXHhurQK1d7wcm8v0pYg0M7wBJ9UOegMp9u4ZI+VH4SmNuIi/XSkLRe+sdDJ
	+x8Mas2sXlU+966Q+cqbYBcHiDFJlX4vQsQawdp/DTymsabozlNl9Vnp2HQjBVXT8Bl4Vg9wYxx
	Zyfpmxk5GLli70bNiThAWXlx5I1+dfg1yzv5wkeSmTpY4jAK4wMqmcohORUmwSbO5Zi7Vm7+Mze
	0AJrGYXV2/ZE0YDdtY4CI9xlqZietWBhoG21WmyRmpK3Ga3p9F05yudh62qB56yo0sP6aBFEbUx
	AYAa1yWTwvFV89uYP83WX0RI5ohH/PGtd1Bw+w32kdGnrwob09nCrrtG2sxQDgX0Lu7Fl65WvQh
	LzAhN/rO57KZtZejpjGRUXd4v6lUAYxjGGDVpPw8xKxRNfsnrUDprILiYEObAl79/XKcWfE47eT
	Ie2k5om24O5qF5dsVgm1mb6cLFPWQ2Bp+4l57f9oT2xspoodxnaaZ4BPbMyDqWkRbUxTEI1xxqL
	hQDJzHuPHeqYsHny4K0OUj8P7F2pMXiZ0VAmmcY27JpuGOUCufK9R1awAFlZ3k61bpye+RDvkfd
	I=
X-Received: by 2002:a05:7301:6782:b0:385:2ea8:aac7 with SMTP id 5a478bee46e88-3852ea8d7d4mr16786949eec.23.1795434283352;
        Mon, 23 Nov 2026 03:44:43 -0800 (PST)
Received: from localhost.localdomain ([2409:40f4:14e:94e0:654e:d7ff:13d2:447d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm41943583eec.10.2026.11.23.03.44.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:44:43 -0800 (PST)
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
Subject: [RFC PATCH v4 4/6] security: kap: add the securityfs control plane
Date: Mon, 23 Nov 2026 17:13:06 +0530
Message-ID: <20261123114308.8103-5-harisudhan@armoriq.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261123114308.8103-1-harisudhan@armoriq.io>
References: <20261123114308.8103-1-harisudhan@armoriq.io>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C0AB2140003
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 44nee7mijf5owptoe594f4mzoxgoba7m
X-Rspam-User:
X-HE-Tag: 1795434284-852703
X-HE-Meta: U2FsdGVkX18LmA1rUj5GeS+IuHKT7i508QEtXP7hFJZ++SJwoLypZVaLr49dDVc/DkT/tfzqpl4CvdcuURv6me7xbyDQttIDISYNpY32rLpAhrbETz8nFtMf9JCnEjX1EcQXhi9aXBExDC+xhOk1C/TUvdZ0CVq1VMO5BGPuPSBAH4tliaArnORYXBqGmeukm4f2nxO1zF+QP6ZvlGRS6xkhg7dQO+3jl0sMvUbActNOJFNtw8tqmWIW85VFe5Hm4zHigJ7nCGUTe9MjzUmifG424asEx67uYcFUjGcTyXiEbnKFANwiN4EhTIHyvKHa8p4fjvF8+CO5yPX9L091UrGXL9htu5LLoqeQsJY/Hw5OxmeAvKkqCHeekW4KOtreMmaE4TNZfZLdViZ1RrFWk9qe/ibgJ48lZJs7b6vCna/g8D7Sv1dUiX/UJmPoGCZf55RyhvPMMc6lKlc+hGhSw+t4baINBbPASWMzAp6kVti8pa9hStmMq0EpPTUc/rBQqTAD8zfDcAcahcZZT+sVVtM2v1qrC7uzgRLTN2iMUOSXgytXBjQ/74FpRUVPIlD0od37pID1EUFV/UJY0J7dwg9VR8IqKtUaDnwnSELgOzF5IUPJdpRpnpheP8c9GoPOG68L+CU77tfrUuyIIXfCj1iX5MDN20nQBwSEAK4e0iRPpH5GGTf/ineWhVuVB9JjEvWQp9Bu99Zl3MMX6HTUgF/YZ8g9OzjY35J3d3+FoAnY3OO+7kz+oR9sQMHIbICjwrFBaumCZquk3hQX0kpnZ7WBTdVrJ7HKUNCIB6AGVYO6bxqWV5OVjzv2465WKVAAOy1CK15MAPzBhDbAPD4xUGdr/ep9IaE/eqT6Irj9+Dzar0+lQWFdM+lwRVlOryX8pjwH7r2azh/T2Nc/PDKoOKMGFItnkyQ4pduepn4nCq9LSRx3VTfjguQ1wSd3Xl3rO9xouCY1UUrQfS3elGy
 uglJeGQS
 RovUb4vgOl0nBxkdrISzD6zXe5B19vXjCLRhc1wQ3j4qnr8rvKt3PAgB1GTowSoOimte/vEn/zVWylIJUtxELCpMEtGf4jBiIouUn35B20cpUr5Fe9nHHVNzxLTKr2M/CUDqBKb/dCHXwuegnUdPdoT2eUqyz4CmyyC0yVuMjf3FNH7MD+OTdHI+n1nOINn9olFeomqdwDRw3rpgZ2E0OTbQljoDmrSq+kX8ErRGThJHqrEJj+UWmB+1N8Bi3uQmo2WOvieKqZ+yjVfu0R7o41DjMVzylhG6AY9PR9iB0vVDDIV8Dd5JaZ49l3oGoGRUqG37o3wSMs8C+An60OiadnM05EHNa8cRkihUt9vBeGPpDav0jO9xvh45Rdtgl2fsH2ZUXj2iYSmxp/HE8MisyPF8YwcPcZ9yEcJJIk97fI2JZUKJvR2aN9aq0yFjk/uUzud4CFQPIsOhGKdwLJ4x6v3fQatXwsGuxPvTGgwmUlzF33TIYBdwRS9f+OWZxqe70q1lsAT/B8Np3YA+gIaQ1VPdYE4EDYr1mb/FSnS2oCD3eQc9asqi8Cz8BSHxKA0G/PD70FeFZVtU+K+qPM3ujJAYKCDg5W+YNPq5bTS+m38XiNnb5jZ9ETY0n1irvcn9jAXfxzTvIH1hpvbg=
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
 security/kap/kapfs.c   | 530 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 532 insertions(+), 1 deletion(-)
 create mode 100644 security/kap/kapfs.c

diff --git a/security/kap/Makefile b/security/kap/Makefile
index 40a864c8c..6ef7c5efd 100644
--- a/security/kap/Makefile
+++ b/security/kap/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_SECURITY_KAP) := kap.o
-kap-y := kap_lsm.o igroup.o
+kap-y := kap_lsm.o igroup.o kapfs.o
diff --git a/security/kap/kap_lsm.c b/security/kap/kap_lsm.c
index 48d048086..c5dff9c71 100644
--- a/security/kap/kap_lsm.c
+++ b/security/kap/kap_lsm.c
@@ -899,4 +899,5 @@ DEFINE_LSM(kap) = {
 	.id = &kap_lsmid,
 	.blobs = &kap_blob_sizes,
 	.init = kap_lsm_init,
+	.initcall_fs = kap_securityfs_init,
 };
diff --git a/security/kap/kapfs.c b/security/kap/kapfs.c
new file mode 100644
index 000000000..c9f03c2d8
--- /dev/null
+++ b/security/kap/kapfs.c
@@ -0,0 +1,530 @@
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
+		if (strlen(tmp) > KAP_MAX_ROOT_LEN || !kap_valid_lineage_root(tmp))
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
+static const struct super_operations kapfs_super_ops = {
+	.statfs = simple_statfs,
+};
+
+static int kapfs_fill_super(struct super_block *sb, struct fs_context *fc)
+{
+	struct inode *inode;
+
+	sb->s_magic = KAPFS_MAGIC;
+	sb->s_blocksize = PAGE_SIZE;
+	sb->s_blocksize_bits = PAGE_SHIFT;
+	sb->s_op = &kapfs_super_ops;
+	sb->s_time_gran = 1;
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
2.43.0


