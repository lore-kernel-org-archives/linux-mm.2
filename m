Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9CAB606A333
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DCl+uSuz
Received: by kanga.kvack.org (Postfix)
	id B869E6B05C2; Wed,  4 Nov 2026 06:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36E46B05C3; Wed,  4 Nov 2026 06:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A257F6B05C4; Wed,  4 Nov 2026 06:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72EAC6B05C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:10:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0815A140679
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:13 +0000 (UTC)
X-FDA: 85397167506.23.73BE8AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 17E562000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCl+uSuz;
	spf=pass (imf31.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790611;
	b=RKKjTprRszCvE/A88U945cH7km4DtcxA0awfySUI2FM+DW0sTDjqNdVFr71EoWhasQJxg9
	C4N918XJOAJ5NmRctwLeKRMJ8zXKeyx1VLKmI32Wd+vFQ7J3A+hhTTeS5Vy4E7UtWo7EVV
	ke0yAZmSplH/BGnZvozhNy+R2xAqG10=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DCl+uSuz;
	spf=pass (imf31.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7n4fmWUky+vs4idCDlxPFi6+bwonkuAntrLXf3wBF2s=;
	b=V8ixR8LqfmKfdg6Y/Rl9GwSD2wxuDb3PyTFHz1kS70DsXebO57GseKFtjnt4VFg4+MGVAM
	rGM1laLMJ6AloyqwiS1QcRwZ++zksL5n+SWXSW65xhTJD3wEABdH9yBBwKttC8gnWvueES
	Xgpy/G1kfGu20IkpXoTP7mSkfBgJ0+g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7n4fmWUky+vs4idCDlxPFi6+bwonkuAntrLXf3wBF2s=;
	b=DCl+uSuzgZk+/NcR3X0c7CITCiWK63RzqvakH3PYKaBHbnY379YPnXGOV8b8sroAlcXNH9
	8pkvs/awY5nwsWjbVu4iuahs5cUcY61QY7MT+zc9ZGFjxsvpuQCTZDy/kyFEPjqrK3y4jS
	CmuM2Hur9delHrJIg3cEGMaCUPMQtYI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-_JEk64hCPe6_t6DOQDy98A-1; Wed,
 04 Nov 2026 06:10:05 -0500
X-MC-Unique: _JEk64hCPe6_t6DOQDy98A-1
X-Mimecast-MFC-AGG-ID: _JEk64hCPe6_t6DOQDy98A_1793790599
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 339DE1955F75;
	Wed,  4 Nov 2026 11:09:59 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8F3D195608D;
	Wed,  4 Nov 2026 11:09:51 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:13 +0100
Subject: [PATCH v4 4/8] security: dma-buf: Add dma_buf_charge_task LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-4-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
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
 op-tee@lists.trustedfirmware.org, Albert Esteve <aesteve@redhat.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=4963;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=tLPI2RsSKhsOZqNWFIvgktu7E/VbWAcyepTlyll79Zs=;
 b=OpfXZ5pArGbvxwctGkok63VwznmiQv3Kga5Ax0dbd07KXxBEYL59v+Q7plTvYbWPAprFy1Jjt
 2+uSIAOQQLUA5Np7R+aTopHWrrcSAkcmUos6/IvZSsViDc0BmpW5/X0
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 2FDA_duzsF3ljnjdX2UQ2__5icYxvGGMOHTMW_ba2no_1793790599
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: juyke336g1e6czjkyfrpso67oriu6p3o
X-Rspamd-Queue-Id: 17E562000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793790611-895315
X-HE-Meta: U2FsdGVkX18CwrWbazARwMMkY5g8x1cq0DA4AoHCn4d0SiUE9nZlrXhmwwdXSfQUgplUSUEK59wgi3HqphaMFUSdu/VFAexl/bYRVLlXFP6bzx4pidBM+GEwykkQRzLKW5bo98ITbwrY9Hh1mHst7iEFVIuijkPiUVrWByu82isJ4s4V/Q/kiDp0mzsiLTCBivV1rA3bQQZou0ALnl6BYN5c6ScxinLr38Ke1QJ0y80MZQEt94BXewlKrnJGVSw2F4ofx01sh9YItCogTRLrh4rgKU+wDLCzVOTGSulZjNS1TgmMVA+KOV+Osyfo6JTDi/EScxJVLIjAxehXc5TdvXBqvOVdg0OC/Fve51BacLRXgY0d10Pv6KtqMvRzU3twUe3zXWGUlj4Aw2DZFK+4nCyq7uFspqzz540EQYwxnheUSTUVHbOVX4M/G6Som9cCENI4B6u+gLR2HrsqfQCsrRwgEcCu7EYIPwpgNI6+2A4UBpbG4tYYdP6DtmGzhHXZHzcvkaCc4Gp0ulrVcJYUw7mm88VcUzSve/ep9NNlLvOWfAF/V1gwOcjZw7i21qnmbq48y0flvhDUyGj2BHgupEkisHjIUCuBqEd6tGvTU0foqstUt1SFoc6uFDbmvN+FAJGr2qMQ0jFDsqq0uikcDMn1SmyJfLCJTVuV4d2e8KC/6AM1/9XPrWVP9L86V/dJLl6ZdzK5B0+FmePVOhA0zNrTmHctfQHPf7GgPEmHdetQmD2EylX6BSkpzPs8s+q7rx9I/VXWAkQ1Ar5VTfVAK5MYQGj53mb/HaCIHUxmoce6DjtPM0UQuWTsFxmN+9jY5Dfwtu2SNCDORmbglWwWdQC5WUL7WnOOt24BHJkQIaKiyXYXn5TbqQl95iM/1nUsfwRrruFabQzvSoxjbVH7jw/YPfZ4G00wxhRq+rMmD78zI7UfWUHxolgH5vStG1uHQnmH5wv0KemO2jpb4Yg
 kb11QyAx
 r2T9L/zWekVd0Yfl6IRLOouvT9kc3Rw/FtmugHwVe9VqjQyRsGMZA8J8liBHI2L92JTNFBFD2sgRKSpp8x1wfcZQ9OWDfvdaSNEp+KTRnQJrf9cRIwAFgODf+JCxSkfbeBAl/AI5oYYnaMRW+C95OWzfe0+UuvInXIJGGqLClAlD/Yh856fXAsDQ+KnCdcdl5vVQuWYCLstTdo0oTJqiB6kQitazmRTbTHzN+6NiJCRV5etdbLUXxmUEsYYnFBVZ/u59FdLVLx6ZzSsL5jqk3+0g+YG9OGfxpU98W0HW8hPK9Wg9MiAP0WNQxzQPkiuu5Qtyf8N/NQt0SxEZZwEwSPdbCkAkZzwcOrydQ5ZYaHxj5da/5RuZfh6ZNc2WGfh9/7Jc/M+e/D351ALTlHDKlpx2cfu80mUDJZy8t2MEwjIIBUi0cLoDuWtn0luZzAJfttu8B5KNA0aAKOIFD6Ip8rYq9p5b4Wy35EL5rafsAtVvG+0QaCpVZZCzs526l/bgY3/TOWUJUJAA4p9KfgyLJ3il49BbjkH32bxn19DI52AVEHvvooYSd7nmLFhgrifLaNoiz+FWAFczmo5nboKE10hcg8auMCFYS/L7AYY1jdfTWZLw=
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
index 3e717b5663c8..dd276e1230cc 100644
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


