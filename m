Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3453B606A331
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=H8ANUx/c
Received: by kanga.kvack.org (Postfix)
	id 355216B075F; Tue, 27 Oct 2026 11:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304B76B0761; Tue, 27 Oct 2026 11:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDB16B0762; Tue, 27 Oct 2026 11:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEB8A6B075F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:03:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 652421A0A0B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:50 +0000 (UTC)
X-FDA: 85368725820.24.63DA5E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 48607100016
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H8ANUx/c";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR40ttEIKp4zo1NRFrTQUQd4nm+iPR8XncYeTPu2rEg=;
	b=zKfMvjkZZrt9bj8kEZl79Qajfe/Il8yDjbdPaPf1VcJLNQEw0Qv0Vi/KJ+ygODonZgHF1Z
	FHy6o8YKiWAsLFM7S8MTesAgGG7HoO5nFoBIpviAhMAhlzSoUDmy3heNEchrL6UsM43ga1
	4GwbMmV8nKZt5ZhVTw/wbOqw2RGA+OQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="H8ANUx/c";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113428;
	b=TfjRfwVJU6HR/1xOMdKtnI396dnFbxSyR5+sr7Nre9U/PrRhELwKSa93cRlLkaJFbr6swC
	30G7U4Y55g5hNGhMBAy8I40/yhhyeXxXVDJrPMXL1LMqZ9SN+mYioxMe23liYjDnYjd3oR
	oJ5SXE54gcUN0zH+bhpoZy1cYi3DBR8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zR40ttEIKp4zo1NRFrTQUQd4nm+iPR8XncYeTPu2rEg=;
	b=H8ANUx/cJE96yv5n5QM5CPHPvzLic38BxHMADqz0LVLBG3Le+1FKabvVpl8R4BGqg2MJV9
	gcSe/cGu4g9Sms2iIwGdozux72tNFutWvT3/GS32Z80euPeEuCXAswht/aJ0iegzd5nSRZ
	QYMAlDfPX5xNu0AhXydkh7Vg0UkaeDg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-h1-z9jaENXeH7aJKQfDz1A-1; Tue,
 27 Oct 2026 11:03:42 -0400
X-MC-Unique: h1-z9jaENXeH7aJKQfDz1A-1
X-Mimecast-MFC-AGG-ID: h1-z9jaENXeH7aJKQfDz1A_1793113417
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39DF81954B27;
	Tue, 27 Oct 2026 15:03:36 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E660A18005B0;
	Tue, 27 Oct 2026 15:03:27 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:46 +0100
Subject: [PATCH v3 3/8] security: dma-buf: Add dma_buf_charge_task LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-3-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
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
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=4963;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=14RD1eYgYO5d0BZnk7UEWuuETFwAOMa+QGqJBJMtWs4=;
 b=FPe0F3OWNV7A6Ow01DzvESMOuHmQfsuqfq+cNHgQHbXrkoXHC7wzT/X1hoXsPeJ3rvS64p0Aj
 p+go1TwVWfMCVhA1GBdaxIsaVXHDJvbB8MT1EIi+PKT+8V40So0+vor
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 31OVvZeVPTw0ywQwtvNiHW0p9UmOtYngTVpgT_atcR8_1793113417
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48607100016
X-Stat-Signature: 6rhj6bctneh7wqqbpuqawfc6iuj88j9q
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113428-245616
X-HE-Meta: U2FsdGVkX1/IwqoffZ/nS41+VE/4u1X/KN6lUvAFikcyvGYq0heRm7zgnvFTNx5iptIb7CjxJhnoAwa/ZjV70NKXu/3ycHlNjPN953CX1it1opn4j7/4nAVToS9l8TJWYnTUA1zavjzZ5TieDwwHvl2USkXjRuP+iluaFzhbYfiQSfQV4H32omUtIUqYy1y99FY1+Bysndy/p+/OLpIlbnEKX+gTLFFZinKwXHBKOqiGVzjoSJCAsfMz6uMAy/GRjW1hi2NNqedRqK/iTJC0zCwkWhU2pEPbi5s9LeUtau0844/ogJxJeux369H8FztgBSGKgcXrGm3iWa9aigopZWc4taw0FNcEN8RKYVfsFM1y9ljrF4OcK1NGWnhfWRWzL9b+5eVXgOPi35DzkSENyS7U4QaY4a0bA2lww3OrBMCrh/Y1BTGRRk+ckpxoggCWN1bEsf0TQILGeDCRPgAxcaYiB1+dVVSSl1TgZ+IId96rmJCnod0b4eJewK9Z+XOWez7pGJxwR14f0GFXgCngtQlMNVK6Zav8fz7dyFxCoucPL1s8wmHEAxVVmaKRJsM/i5y3v4ZFWxdCqTUPT/jnf8PB+FlcziLqR2PyrYMjBATQeEcolQRDhT67EnpE6uRRRfKjrvdflJEm/fUxCp4jk7bDgmZori4wt3FO6N8BqsldfL1NR7KeqSQUH8hJifFRU65DO4uhZtgN+BctGeVMEq6x5OaHENgM0GXUzCvTGhbyVY0efJIqg6o7Bb6H5+YRmk1M8FykrI1rj3iIpNANu6gP84sRHYMq4aXo7zeTgS6BLXjAlX/OV3b/nM6UqT0oNmTS0GfdNrKDi16JlEMoaOjWexczXzh0LjIgZCOBjOBEW0VVuM0otu0f1e1STxUr9lxL9UAOfETLTr1GHvj4R2g/P7A2DCB1psVlujIf1Qsck3V2RTdGJn/mRF7424KWUyuzZ09IfKLiCEqPZjv
 qJyktxBr
 L8VGYJNUuKsuMgZ13HsJatNmJbh7xP8EW2yJBNXGSUWeUgCfccYRjvl0/451migo9FbVVBiZsh6PRlzzYywuUs2uMpglhS1+BJ06XlDHP4cc1qV8LxBuilH8ERTRHFy7m0c9zsm7tgoZ8YuTq3NEFw9wRnfuvAnuGzhpzRmEMtZf9vYSJ7kQDxNj4R9IiX0rChssiFDSRjeMdFXBtl2N2AQeKswpLmzvz/fQj0GgIlBIIxaZVlurN4n6pE5QPGde0s0k2y0CiR9bPhbWlGjArIAG5zBtsz3Kq0chB8Q2x0we2rrC5Gr/kA5AA/MA3ZC8+/h0BaGyOPR34ibP0VOz4/pyiUIoxZZIM1VGnKJwZCXrb+3/tro97EeJe0jr5fO+7/8ssJfGkPqHl38mI+dqaA9uy5/lxw/9ZI2PjPF80fgqqARh+ZrI88IbLH83Hnb+QInKcParUrZDDr6RJB82rP+BFNlrCkOtTpyYrn7tdwvWB2yThkwq6dybJqA==
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

Add security_dma_buf_charge_task(), called in mem_cgroup_get_from_fd()
when charge_fd refers to another process. The hook receives
the credentials of the allocating process (from) and the credentials
of the process whose cgroup will be charged (to), giving security
modules a controlled enforcement point for cross-cgroup dma-buf
attribution policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 mm/memcontrol.c               | 11 +++++++++++
 security/security.c           | 16 ++++++++++++++++
 4 files changed, 35 insertions(+)

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
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f66254f52b99..ad195cfd1b5f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -59,6 +59,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
+#include <linux/security.h>
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
@@ -5672,11 +5673,13 @@ void mem_cgroup_flush_workqueue(void)
 struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
 {
 	struct cgroup_subsys_state *css;
+	const struct cred *tcred;
 	struct mem_cgroup *memcg;
 	struct cgroup *cgrp;
 	struct task_struct *task;
 	struct mm_struct *mm;
 	unsigned int pidfd_flags;
+	int ret;
 
 	cgrp = cgroup_get_from_fd(fd);
 	if (!IS_ERR(cgrp)) {
@@ -5698,6 +5701,14 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
 	if (IS_ERR(task))
 		return ERR_CAST(task);
 
+	tcred = get_task_cred(task);
+	ret = security_dma_buf_charge_task(current_cred(), tcred);
+	put_cred(tcred);
+	if (ret) {
+		put_task_struct(task);
+		return ERR_PTR(ret);
+	}
+
 	mm = get_task_mm(task);
 	put_task_struct(task);
 	if (!mm)
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


