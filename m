Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521D7606A886
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Es3Aipw6
Received: by kanga.kvack.org (Postfix)
	id 772FD6B05B8; Tue, 17 Nov 2026 03:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A8B6B05B9; Tue, 17 Nov 2026 03:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660766B05BB; Tue, 17 Nov 2026 03:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ED9B6B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4AE816038E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:17 +0000 (UTC)
X-FDA: 85443964074.16.244773F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2CE320007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Es3Aipw6;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904816;
	b=uTrnFFLWi2GprlkyqIbUMFzsjuk/eX8mP+zQOLf4yqjZuVcYWSGdGFLH6+mBowXU0wJene
	IR2k2n6lgFiatGSBTmkkppaiD7QfXedw4dho8K6WlZcLnFDcgM0mI6vEvctwdMl1F3QKTi
	1NkgguEYQxKWdx+tR9b3WdXTcdM3GnM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Es3Aipw6;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YR53SzLMSogIajp7ibSOv5fPIWUDgfl2vHRdlTDKtPM=;
	b=eV6ZeJDvQlCN+JPM4RhnQULxIVi4RpnWrRc4KZhvyhIhlXxwZYQIxxSfNcMiDjH+W5qDfq
	wFzBdMAYa/1U/IwF4w0N+QnEhU6JkFqQ2Nfe/13mRETgPOlrWLzjflvmhRJERF6OLdtlZP
	ipCd2jrrdzhZbpLgs+/+5MlHaL769qQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YR53SzLMSogIajp7ibSOv5fPIWUDgfl2vHRdlTDKtPM=;
	b=Es3Aipw6Mumhr/ddJI+ajMABLY+leO667UER1RO1OF3OhxnSJezVLgHDtnr+wGhXK0mn32
	ZpWkeUGhOWAHXojboxpM2eDf2KGE8N8UrB8oZrKtFBDWnKLPEHX1mqQ+QMy/yYy9rxqBfm
	SSEOg1IwLdA0NBQMUArPMkqGiRzHUd8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-457-ZRjRG7UgMkmn0F-CJzDRtg-1; Tue,
 17 Nov 2026 03:40:13 -0500
X-MC-Unique: ZRjRG7UgMkmn0F-CJzDRtg-1
X-Mimecast-MFC-AGG-ID: ZRjRG7UgMkmn0F-CJzDRtg_1794904809
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41301800547;
	Tue, 17 Nov 2026 08:40:08 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78DCC195604C;
	Tue, 17 Nov 2026 08:39:59 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:19 +0100
Subject: [PATCH v5 4/8] lsm: Add memcg_charge_task LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-4-1ce975f2a9ad@redhat.com>
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
In-Reply-To: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
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
 Philipp Stanner <phasta@kernel.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: airlied@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>, 
 echanude@redhat.com, mripard@kernel.org
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=5136;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=606ikDq7N2a9kgQEC6+17vuKAgE3M4wERjTpnW/4vLo=;
 b=2Fup8Kz7V8rFrNeityvDdbwhzI1IfABG5aDmq79tiClm6kMZyyU9E3RsDlCnq8md4Rc4i80hy
 H45Z6eYkyo6BA6QQV1/fkHtUmZZh74Xwv0qi1RxDlYS52e4ybZqqrQg
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: tNxA1vl_DKmfVV7cviwnHvTexRFb23gv80ZPMxQalrQ_1794904809
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2CE320007
X-Stat-Signature: c55yqs84mm4sde63b1w5dtqjxhukm7i9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794904815-136469
X-HE-Meta: U2FsdGVkX1+Ht/MaOeCf/Ge8dcDBseJ2ZVcrkOz80wco7mXXZyqgwWMk6Hk+ziijEE6ydp2CP6NVfo7A5iOc8fYpREgOMHy5MKvE8pRBpweqIC5oZKZ4284z5pq6fv+jKAsT1U9b7Ozw3CpmUrqu7Vk75AV28jP6UGrcIBxigVjQFm1FAmSnL6/SmkN/+ku+Lres6sbGpi42sZd+oePuzDvzwbs/YGa2Oy9NjMYFm8Y7SgOiBCyMbnzKLtdLbT3TKfe3fNp+DLy4PLsgP8fdtmYoMFnSLeNeTOI33ya1Kqjn/q5Lc+npuo1C3cRdr7syGhmdQgk32Os3r/hqCD5nNkSqGCPleW33c8ttFlrqTK8hLcZlpw9bi6itfWk/QkC0p1Bmq8j0+s61auaP7m9RLG5oDn+vpcl50yy580fwBHgChlZOmU1dj6OBJngugiLelWqvKjhNauIsdMArTSwA+JX8nq5gC3tzusi0o/pbzWXd9xYkkHEKiX4yfumtRFQ7g9DtEjL/UnlR0nkemEvECFHugZH0QgcIwtZ1UpnNiXkKAo10Gmi4IgR0uokDrlKoqkFaTL8VyUwfU5SEGYM6Q0SeaXBke2SWxw8HzGMi8NLzN4/o56m9c4FlChXFK0tijWWkbgU3sGcmoynpM+Rh5NPibTE1BVpAarNYUMuk7lFOSz6IXGdPsru9rtZpvtKk/U6ghPPMwunAVbNSZP9p+o4j3ZSYH775GTt6PgWl0RxYq2dpPwZz6PJKv29hqFcW9Fj7MsgnZLLGbSwfZ72YlnfpF+cpz5D8cJrCIDHHIxDLZmT9+RSIO8mfhqKddZCc+bw7nPKjyVVzWuEwn9yfsGmdLGKlCtZuOBjHfmP/Z9tKv12uAPkJf1cHvwEn8iElBovmGCow1ABEdv9mpevCb5CKY9nTEr4chkXEKOMJ2vlRaV1o/7pt/XA7zkWcH4TaSA1GN+gzJ0mGJDw+w4r
 +OwQTcwd
 TU3S7EKXM8jSXryvfhoslDUKBGahKAxX+Hf0XOpeUvbT8SzDppHftAavYdM4YP8btM7oReiAIL60S5J1Sg8NEA2dZ71XBqwoK2DK1gJ5EQlH8TqVwV83ot1RvZFcGdoyH/5DFp8wdnzm7qI+fNBAeBTfkZrbFW/D3Tn4nYaWu/8P7ccAcG8ITea0HovMm52O15errJZUHgLc8ACSWwf6TPvqUv2JfrWcddWdL4xZHQ9WP2xsU7ngRrgk2QB4jOKbT5z8ORdjgmzzzZVxUpvj+3MjrdC2jnwzp5xvpE9cnU2zkRq04AgT6OyfzCwSx+uLW7VblbQhE9oSRmBJ/D81NrwkdNdAoGCdyuKBuJTrK8OvethM4CxYaYr22eFPEJyt178p80mg2BU/a+ZmE5OF5A2WXBGz/00mx1p4hWgPs6e94QXXYUy+v8lGhcawK6DzgyVTI/hMFN8wu0PPid7fVimOiFQoIjV0UTZlsqGELXpviOLnggpTXA/DNnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both DMA_HEAP_IOCTL_ALLOC and the new DMA_BUF_IOCTL_XFER_CHARGE ioctl
accept a charge_fd field that, when set, causes the allocation to be
charged to an arbitrary process's cgroup rather than the caller's.

Charging is currently limited to the caller's own memcg subtree unless
the caller holds CAP_SYS_RESOURCE. But the capability is all-or-nothing.
A process holding it, along with a dma-heap device node or a dma-buf
fd can charge unlimited memory to any other process's cgroup, potentially
exhausting that cgroup's limit and triggering OOM kills independent of
the victim's own activity or privileges.

Add security_memcg_charge_task(), called in get_obj_cgroup_from_fd()
when charge_fd refers to another process. The hook receives
the credentials of the allocating process (from) and the credentials
of the process whose cgroup will be charged (to), giving security
modules a controlled enforcement point for cross-cgroup objcg
attribution policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 mm/memcontrol.c               | 11 +++++++++++
 security/security.c           | 15 +++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..93c8bb5642f5 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -43,6 +43,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 	 const kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
+LSM_HOOK(int, 0, memcg_charge_task, const struct cred *from, const struct cred *to)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..b21823225ed0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -352,6 +352,7 @@ int security_capable(const struct cred *cred,
 		       struct user_namespace *ns,
 		       int cap,
 		       unsigned int opts);
+int security_memcg_charge_task(const struct cred *from, const struct cred *to);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -710,6 +711,12 @@ static inline int security_capable(const struct cred *cred,
 	return cap_capable(cred, ns, cap, opts);
 }
 
+static inline int security_memcg_charge_task(const struct cred *from,
+					     const struct cred *to)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 03cd90d5e623..2e6fcbe14d43 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -60,6 +60,7 @@
 #include <linux/lockdep.h>
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
+#include <linux/security.h>
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
@@ -3198,10 +3199,12 @@ static bool mem_cgroup_may_charge(struct mem_cgroup *memcg)
 struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 {
 	struct cgroup_subsys_state *css;
+	const struct cred *tcred;
 	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	struct task_struct *task;
 	unsigned int pidfd_flags;
+	int ret;
 
 	if (mem_cgroup_disabled())
 		return ERR_PTR(-EOPNOTSUPP);
@@ -3226,6 +3229,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 		if (IS_ERR(task))
 			return ERR_CAST(task);
 
+		tcred = get_task_cred(task);
+		ret = security_memcg_charge_task(current_cred(), tcred);
+		put_cred(tcred);
+		if (ret) {
+			put_task_struct(task);
+			return ERR_PTR(ret);
+		}
+
 		rcu_read_lock();
 		css = task_css(task, memory_cgrp_id);
 		put_task_struct(task);
diff --git a/security/security.c b/security/security.c
index f6583d507395..e198e00b6a40 100644
--- a/security/security.c
+++ b/security/security.c
@@ -674,6 +674,21 @@ int security_capable(const struct cred *cred,
 	return call_int_hook(capable, cred, ns, cap, opts);
 }
 
+/**
+ * security_memcg_charge_task() - Check if cross-cgroup memory charging is allowed
+ * @from: credentials of the process requesting the charge
+ * @to: credentials of the process to charge
+ *
+ * Check whether the process with credentials @from is allowed to charge
+ * memory to the cgroup of the process with credentials @to.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_memcg_charge_task(const struct cred *from, const struct cred *to)
+{
+	return call_int_hook(memcg_charge_task, from, to);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


