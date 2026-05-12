Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85BD1CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA566B0099; Tue, 12 May 2026 05:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AA46B009B; Tue, 12 May 2026 05:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0656B009D; Tue, 12 May 2026 05:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEC4B6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:12:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E1011C0D0D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:02 +0000 (UTC)
X-FDA: 84758200884.26.5AB4347
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B43D40002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Db/hDLdW";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577120; a=rsa-sha256;
	cv=none;
	b=dwhtPVjVGYT88tCZbhEfm7CbcTDGV0NaVa4DJ3BosJDweVTXcxtujdhR8VoRYwfKC/V/za
	ZdlAFWxh836J42jv/7KQxJraA3hLdkAA1p3lp9nzlXjBuQgntDbtzDOu3yUzw/lO1pJJdJ
	3HNy7hht+MfalaTk9w4HaCBfaB1Yyw0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Db/hDLdW";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8s97gg0KoIjyQjky3n/0eDgAUHfrfiLBh9jEOqvVQQM=;
	b=gcSb64WC1Z2QmWV0bzCJeybqowMqM4AHyQt/tS0aTC7IF+tQMkFrFf2jP74GA2/pQYtuUl
	UXQOe+NOcVVhJYIW+lSVBwZabC+sGJuLZ+NlkFIZT9AnnDxHW5jjbrPKXgLOmqx4PbAt3Y
	lwL9Mm9lLAeCALjkmhBF1fEEMwdZgGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778577119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8s97gg0KoIjyQjky3n/0eDgAUHfrfiLBh9jEOqvVQQM=;
	b=Db/hDLdW6sViEtEgyHIcqtXWwM2l+ABUfh8j/5P7/jr5slXp9uj5ML0wXEEhY4pqku4833
	gSFqv9yA3/R9c/zvYKf1Aqulf2M5ez0Res2uwHvxMWmIqHmsQkghNO7fBf8KrugcPNDLUM
	AIXlIIdxnq83SBOJRt18Zo2wZBM/+XA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-WtDMzp2iMUq5SL-zKZ9ffw-1; Tue,
 12 May 2026 05:11:56 -0400
X-MC-Unique: WtDMzp2iMUq5SL-zKZ9ffw-1
X-Mimecast-MFC-AGG-ID: WtDMzp2iMUq5SL-zKZ9ffw_1778577113
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C1D51800283;
	Tue, 12 May 2026 09:11:52 +0000 (UTC)
Received: from [192.168.1.153] (headnet01.pony-001.prod.iad2.dc.redhat.com [10.2.32.101])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD95330001BB;
	Tue, 12 May 2026 09:11:44 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 12 May 2026 11:10:45 +0200
Subject: [PATCH RFC 3/5] security: dma-heap: Add dma_heap_alloc LSM hook
MIME-Version: 1.0
Message-Id: <20260512-v2_20230123_tjmercier_google_com-v1-3-6326701c3691@redhat.com>
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
In-Reply-To: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
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
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778577077; l=5081;
 i=aesteve@redhat.com; s=20260303; h=from:subject:message-id;
 bh=dcNJV4lWmLSoMBN8niB4WIZmayqAaNgAMtglbZ4TQOM=;
 b=fpOoquy0dwzfC7CEdNg5OVIQDBr8hGp0UelCRqsMuNme9Fe3xsZMLOjlm3w9G+6wEyl+SvFVo
 UZ2m/SG8t4ICmEzyhKMvwnHt+6gBKEk4vLcSbpEz3Ovn68s3VAyPQmI
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=YSFz6sOHd2L45+Fr8DIvHTi6lSIjhLZ5T+rkxspJt1s=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: hByU0BURRtsUnelfakEOR8lg5VSqX9RkRAYThI4oMeQ_1778577113
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pjxwbseu7wn3rs3ewndi5zxa6k4h5ko9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B43D40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778577120-918344
X-HE-Meta: U2FsdGVkX1/TeanJ6HW0t247M50qfLkZmOOXj49p4txCdqzMux1JvdYZGYUENXeLm8oA7SZPPNkc7g+v9myTOKVlSqf7fP1fByuWMWY9QlTaTne20ZNbTXBQ7NgSugilT4r7aS6+gnAu/XAsqtiGpc/uJlDCC6/op2KjoopIXtEGGrA2jwHzZQDtvgoCnc/eIL3D86dKk/z5QV6K1H2OqB47JMKDGI4Pb+obInGeBeVLpqFx20UVemA1cmPcmJuVy1rNscbOgCbtIJHkx5RvWrD4vc0ilwF9/gDlcSO9hbxhYzIivTaClaZbwvCQx2r9GHVGsnBG+q/9sf+ob26Cw/DRRDyGL2R/YK0ISkGSNy7N4UtnuA7fBZMjqCLFz22ifmvAJ5Un0pgcHNlXw2kb0xD1fzX8bGgaePEqOJSP/c+BUghqtJe/xMcja/IykETWQgiM+cLbD/LWeS28aGus8X6Lefk5XXvBgIq4lWYGwENgRTxsAgCdne/gew8+mPYKmaKDBWVwjHPT1Tr5m9nmCSIBT2vMLBKrsolNPgbwGh8qOy5X1lXPfDvmjQZpX3QxWDIoRcMMJR7l2mjNKMIoFfNNl6eUZvD+QlSOHgZnP/Zyiu8EpggSjVejHy98B/NBr02CgxjTb0sMk4XAr/7rdqdf4RsEnQ8FCSS7zw+hyywXA7xmn/NtbKYAgesISqaHWYABldOCa/HEOLFE4NkNYnvbQBsPd3vKhqgpyWjYMMIdFfMh10OkOzo9cYcqVXF+5PA5/bkKyeRzsl29KNIVfjDao/Y19/BUlA+vFZ40tKyScucWIhfOonphFZWBTsh0UC1B5DXn6IWFB+JvwGPGuAOYDyTMLTA8CLZcrK/r+2vokA+1RnH5jyeWnIrP8TmDu44Xh1IDZuTO2OAnQnUrZTB0wmtnfXDgQegY5MSqzOfliGOY9THuwdOVjNOha+MRQxcF15J7IxzYPSPAfLO
 encG0Pcq
 g+4vM68hw4GF+NZPaltnc+oRDuZRyu+72fZ1pNVEXCKeACR4rq2XFkjpmTulDLm9JAsDIgNhVPt3qGwfCp8XumKIhIOb2vNgOKNMe4rQ2gfiipk0c2Du18C95l7FunL3IZYX21ZsHOeSceV3QggpvXJ41XtUSujvv41ZJ6OxvMP58cHKillOz/cLMikx0QiZMVhUsacTyYC5lQ+1QHiZLUHaDKgUptKIx/i+D6A6YZ4TWyBfBpBIryJWyjZO8VMZmV2U1sVr3yH0xul/PLj/dMzUdVwmzL0fYSTDtsz1KViXr04ZZu1EZab8vlU4vVuMbnEECXqGITydjWeln9/nQr/3LZPbgLSoJ5NMpYO/XSc8eIvAuzkJC9J62Unr/P3vsqYxZa2RjY/Mb69djeRtpzpHmKL52ldW6g1EqCzSbe0iyhXYujCTISNQwo6dkbjOGSQj8DjO/9KktorA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA_HEAP_IOCTL_ALLOC accepts a charge_pid_fd field that,
when set, causes the allocation to be charged to an arbitrary
process's cgroup rather than the caller's.

Without an access-control point, any process that holds a handle
to a dma-heap device node can charge unlimited memory to any other
process's cgroup, potentially exhausting that cgroup's limit and
triggering OOM kills independent of the victim's own activity or
privileges.

Add security_dma_heap_alloc(), called in dma_heap_ioctl_allocate()
when charge_pid_fd refers to another process. The hook receives
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
index ff6e259afcdc0..e8ffb1031955e 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -18,6 +18,7 @@
 #include <linux/list.h>
 #include <linux/nospec.h>
 #include <linux/pidfd.h>
+#include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/xarray.h>
@@ -122,12 +123,13 @@ static int dma_heap_open(struct inode *inode, struct file *file)
 
 static long dma_heap_ioctl_allocate(struct file *file, void *data)
 {
+	const struct cred *tcred;
 	struct dma_heap_allocation_data *heap_allocation = data;
 	struct dma_heap *heap = file->private_data;
 	struct mem_cgroup *memcg = NULL;
 	struct task_struct *task;
 	unsigned int pidfd_flags;
-	int fd;
+	int fd, ret;
 
 	if (heap_allocation->fd)
 		return -EINVAL;
@@ -143,6 +145,14 @@ static long dma_heap_ioctl_allocate(struct file *file, void *data)
 		if (IS_ERR(task))
 			return PTR_ERR(task);
 
+		tcred = get_task_cred(task);
+		ret = security_dma_heap_alloc(current_cred(), tcred);
+		put_cred(tcred);
+		if (ret) {
+			put_task_struct(task);
+			return ret;
+		}
+
 		memcg = get_mem_cgroup_from_mm(task->mm);
 		put_task_struct(task);
 	}
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2b8dfb35caed3..6a91656f97e1e 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -43,6 +43,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 	 const kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
+LSM_HOOK(int, 0, dma_heap_alloc, const struct cred *from, const struct cred *to)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 41d7367cf4036..f1dad1eabe754 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -350,6 +350,7 @@ int security_capable(const struct cred *cred,
 		       struct user_namespace *ns,
 		       int cap,
 		       unsigned int opts);
+int security_dma_heap_alloc(const struct cred *from, const struct cred *to);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -701,6 +702,12 @@ static inline int security_capable(const struct cred *cred,
 	return cap_capable(cred, ns, cap, opts);
 }
 
+static inline int security_dma_heap_alloc(const struct cred *from,
+					  const struct cred *to)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/security/security.c b/security/security.c
index 4e999f0236516..4adacef73c507 100644
--- a/security/security.c
+++ b/security/security.c
@@ -660,6 +660,22 @@ int security_capable(const struct cred *cred,
 	return call_int_hook(capable, cred, ns, cap, opts);
 }
 
+/**
+ * security_dma_heap_alloc() - Check if cross-cgroup dma-heap charging is allowed
+ * @from: credentials of the allocating process
+ * @to: credentials of the process to charge
+ *
+ * Check whether the process with credentials @from is allowed to allocate
+ * dma-heap memory and charge it to the cgroup of the process with credentials
+ * @to.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_dma_heap_alloc(const struct cred *from, const struct cred *to)
+{
+	return call_int_hook(dma_heap_alloc, from, to);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.53.0


