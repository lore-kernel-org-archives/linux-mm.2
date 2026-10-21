Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC587606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JLI/XfEh
Received: by kanga.kvack.org (Postfix)
	id 136EC6B0730; Wed, 21 Oct 2026 11:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DCF6B0732; Wed, 21 Oct 2026 11:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F0D6B0733; Wed, 21 Oct 2026 11:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C712F6B0730
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52B13405FD
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:28 +0000 (UTC)
X-FDA: 85347052896.21.69A72CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 285A340007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JLI/XfEh";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHTYv0VO9aY7PwOBwtSPq4scBz+tl0Yn7UyaQhfeCzE=;
	b=0nbelmwPeVg/ffR8oSAkF8CaVj16w2+Ne/jN+vmTCC7GCQIwLsxdp5o06h+DIyUuT1OLTA
	hhSJKO1tiK5r6YtAD1sGehzDNFfnuZ2gToWRx6x6cWAnqSZF4kQh+Fm2+UYiMzDDPjwqZu
	/xkPFLpKjuaodHQgbXtN/p5etj8nOdc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JLI/XfEh";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597406;
	b=warU0qWCH2XCnBTo8CTyBXkr+Yx7GXrn1qUELLSf4pANeiww9LT3msy4BpmsREFG907xpW
	7Z0wItC9P/6MRvOJ7jCZdEq9iw7ZRMauUrrIYGyB2kGGpXGvHXSa2oo94ftJ+7Qlcci8Df
	lGzQNSWr5Nj09iJxjAtdAmBr0xTMSjM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHTYv0VO9aY7PwOBwtSPq4scBz+tl0Yn7UyaQhfeCzE=;
	b=JLI/XfEhu/6wbbDDtuQ2UavQaEPhAg0Tn6rSCMUXZkS/aasmle+c08ykZ5rKBIjvqIZMGN
	IW57qIwxZbu36eizzYi5wEwMkPLOkyhl6MN+zjPAuyzioJh4QB/9D+9Fhn6wad8NyNyiA3
	9Ai/mqs+QeHpBVkYURohHiZk7/69TDY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-tzdlTOhdMTGjxqvp716Waw-1; Wed,
 21 Oct 2026 15:43:20 +0000
X-MC-Unique: tzdlTOhdMTGjxqvp716Waw-1
X-Mimecast-MFC-AGG-ID: tzdlTOhdMTGjxqvp716Waw_1792597396
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 280DB1956045;
	Wed, 21 Oct 2026 15:43:15 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCFFC18005AD;
	Wed, 21 Oct 2026 15:43:06 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:24 +0200
Subject: [PATCH RFC v2 3/8] security: dma-buf: Add dma_buf_charge_task LSM
 hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-3-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=5166;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=GGVHkdnZK1acWxQXJIiqldFncGDO62BeQH/m67q6EgU=;
 b=bF4QxBP15zmcBwa57Cg3dyNAHs4Ve6OZAB+SemxZmHpgMSelS/8VJoDkSf8hc7XvoK1EgA9tS
 FYnWsHW4jfQAp8bq7qcK2dmn6oyUbq7h050bh1rAcckEdcD1Vz294qC
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: TAE9l7yTBTxlGXsptX7a9d1hJCw1q1MHSIYxlcWkYRA_1792597396
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 285A340007
X-Stat-Signature: 7hky35unydd6fguowdosn87g91mwjekg
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792597406-352687
X-HE-Meta: U2FsdGVkX19kDKAWdJeRkcVMjZLX9NjrcUk6Cs2Lbz4eiuRj3BQeN3/jgohWKrIN3VJT+y7XpQlFXIMYBhNB8GlOHrWuTbDKcQ/hS2FbkSSuI/inMUSi/7EKA0mE8h8ZN/8tpwcM9Y4C34AHUP9WzjV1onHm/UKUQpQEXLxBKuN1FbdSQ+KrhJlKCinEy1khjDPKYPWGe7EZ2aBuq/Mac3T79IRNThvo79kfe26yOPU2u1Aurz1NrSKXqojaloHD6O22G/vnDz+FRgSazfRWIbgc8YZfWZ5BL8vaKO0bix0fyP2HQZRp1w3MhRxco3DEJ5XFcmhD4A+m1FMY2l6fLkMQKE45Wday0bAMovBx3omsyVXoUmdCkG3CHvoGTVL9A6IU21APUmEymWl6132NLo0PFJ7L1SLc2rg65juQdnBjZbitQf413e1HEYBs3Gl3ikZDFxeCMqQJT+pabOpnn+0kQQAM60C1f76mOfyTw3QqS9nGDsUQGsQcg23i0b3zgEIwBBk1BJB+TyuVXN9U4pAbpjV7RhPSKHA1slZacWoKU13PsKhguBLXIRWeTcVcXwqUabMJAzkqJv9xRFBxhaJ8WhDHoFC7VjMwHKL5ENTXkfAvdsyO4ssmD+/92gwMj0onLb6XydrQ5TCiJU+4rJY0TdGRPV1wSg0nmvbCIQS2+xMTlKR1dYMh2wtJzwfdSuPBx7Dgu+nzNJiWpAJou4B1smQjdf3sNLW4zgFkomtA8R8PP2ry8xHCU4NjlU0ORUdizehZwHs5TS3J6VmwPgQBH2mXWf+FPNccgRlVX8JHxaFzTDd/AkVzmnjcv6MWDWmWzGtdMFOkUMBM18IkaJ7EAxJyHjV6XXuuFtbC1fqlQfyrSSMYZ8cNp8bP6z/SH3bmvkLWLtszW2ZSbTGhhl+enSjEt44EXdRZVMUwc+wCnGKgaDiDv2G25eyveGDntiyYgnR4uyOcg9LXH5a
 /6j6neR0
 9mu6GUxz0dPdLp0uvlENICwVw6KhvSZx8ue8tp4JkwP0c5ADZf/hzz1o43f3AMgWwbueINKBPFZIQKmlvkV+iaWMa/RAq3oXwGqgeCHEsDRYL/8ZFQeSJ3yLCqqfvPySCSWurZQUg/ZCmYf2gxjoXXLubvloowDOCrrEta9bBXmi0SkkQfavTb+nDkPJh0E4wyRWVuIMs9kIoIPH5xr0d8/gkQo40br6FSJ7WRlZqgRucQlYT3qYRqRzOzVz0pF/CO1ku8GP3Rx2FOGP6bv1NaTgQNaJg09msIbOk5Dr2yfE/cLL2M03+GwZn3t5C2qngSCTSkeRHC0KSIKRpwCiZIklV1ZNUAfkxCNaA4xwJNGmnz/UTU1hWFM/IsMb11GHbwQPPAp4A8deI5VMp5GG2WEmf0mssw9Np7VtBpygZuwimalPVqdCcua7ebn5R1PO1HQP3Ox/10WClseAU5CreaIITXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DMA_HEAP_IOCTL_ALLOC accepts a charge_fd field that,
when set, causes the allocation to be charged to an arbitrary
process's cgroup rather than the caller's.

Without an access-control point, any process that holds a handle
to a dma-heap device node can charge unlimited memory to any other
process's cgroup, potentially exhausting that cgroup's limit and
triggering OOM kills independent of the victim's own activity or
privileges.

Add security_dma_buf_charge_task(), called in dma_heap_ioctl_allocate()
when charge_fd refers to another process. The hook receives
the credentials of the allocating process (from) and the credentials
of the process whose cgroup will be charged (to), giving security
modules a controlled enforcement point for cross-cgroup dma-buf
attribution policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/dma-buf/dma-heap.c    | 12 +++++++++++-
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 security/security.c           | 16 ++++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index be77a4c168ab..c31573917886 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -19,6 +19,7 @@
 #include <linux/minmax.h>
 #include <linux/nospec.h>
 #include <linux/pidfd.h>
+#include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
@@ -81,13 +82,14 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
+	const struct cred *tcred;
 	struct dma_heap_allocation_data *heap_allocation = data;
 	struct dma_heap *heap = file->private_data;
 	struct dma_buf *dmabuf;
 	struct mem_cgroup *memcg = NULL;
 	struct task_struct *task;
 	unsigned int pidfd_flags;
-	int fd;
+	int fd, ret;
 	size_t len;
 
 	if (heap_allocation->fd)
@@ -120,6 +122,14 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 			if (IS_ERR(task))
 				return ERR_CAST(task);
 
+			tcred = get_task_cred(task);
+			ret = security_dma_buf_charge_task(current_cred(), tcred);
+			put_cred(tcred);
+			if (ret) {
+				put_task_struct(task);
+				return ERR_PTR(ret);
+			}
+
 			memcg = get_mem_cgroup_from_mm(task->mm);
 			put_task_struct(task);
 		}
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..0f1138e16dbe 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -43,6 +43,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 	 const kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
+LSM_HOOK(int, 0, dma_buf_charge_task, const struct cred *from, const struct cred *to)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..89a35eb07b8c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -350,6 +350,7 @@ int security_capable(const struct cred *cred,
 		       struct user_namespace *ns,
 		       int cap,
 		       unsigned int opts);
+int security_dma_buf_charge_task(const struct cred *from, const struct cred *to);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -701,6 +702,12 @@ static inline int security_capable(const struct cred *cred,
 	return cap_capable(cred, ns, cap, opts);
 }
 
+static inline int security_dma_buf_charge_task(const struct cred *from,
+					       const struct cred *to)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/security/security.c b/security/security.c
index 2ee276ab15c5..4a16e4076aab 100644
--- a/security/security.c
+++ b/security/security.c
@@ -660,6 +660,22 @@ int security_capable(const struct cred *cred,
 	return call_int_hook(capable, cred, ns, cap, opts);
 }
 
+/**
+ * security_dma_buf_charge_task() - Check if cross-cgroup dma-heap charging is allowed
+ * @from: credentials of the allocating process
+ * @to: credentials of the process to charge
+ *
+ * Check whether the process with credentials @from is allowed to allocate
+ * dma-heap memory and charge it to the cgroup of the process with credentials
+ * @to.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_dma_buf_charge_task(const struct cred *from, const struct cred *to)
+{
+	return call_int_hook(dma_buf_charge_task, from, to);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


