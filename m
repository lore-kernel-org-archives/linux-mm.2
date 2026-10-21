Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E46F606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XALpk1cJ
Received: by kanga.kvack.org (Postfix)
	id 9C1F16B0732; Wed, 21 Oct 2026 11:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999796B0733; Wed, 21 Oct 2026 11:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF6B6B0734; Wed, 21 Oct 2026 11:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFA16B0732
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36B65C059B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:35 +0000 (UTC)
X-FDA: 85347053190.27.5452F6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3315A140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XALpk1cJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZFeAMYs79I5sWokt5+NC87pvbsB/zjt4WLbaNq6EN4=;
	b=qnxR7mVCAzv1VDzhJgd3tYjjLeLSPLyu7hPmuiclBKeZYGk4PLoGp4bFxUo8pt79q/FJCD
	4ZqHMwkbBNVUC0UiYgQFFBzR0mhCvquxq07lSMkkHCpuE6WGN1H84dBY/bj8zaYNCwFXno
	IHpumNHHbOpX+RQuZfFnItWfgOKcldg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XALpk1cJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597413;
	b=3X4W0wNe6icoShy0zDcCNMbtmhOZUpKp9+dlqBfYiMj8oBf48uGbrzCjOwxPHVbbAHfV+w
	w/ZSJ25IAOUFgvNPyg1CFysP0CqU5zSbCQIrYPCgiD37SA1c2jGNKKMhnEbo58i/femd9S
	NuJaUoOWmQiKnmVKTcbvSX1NAYXyPp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KZFeAMYs79I5sWokt5+NC87pvbsB/zjt4WLbaNq6EN4=;
	b=XALpk1cJ7RsRqamgPM7wAMlCdSS9/ok7vHylR79lvxEB60OZrIqV7V7r7unEtEkPva+o2s
	Q9+s7SN3M406GfqQuyhtOITyhnWJ9j5TiV/F6oizr6bbZPWgyYEMso5u8jgyF0inJpeaWP
	7qQGfy23rBC7mOOPYE/28fH1XtUKxNQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-GDMDWi0YNvSHU5ZJ4qe9SQ-1; Wed,
 21 Oct 2026 11:43:27 -0400
X-MC-Unique: GDMDWi0YNvSHU5ZJ4qe9SQ-1
X-Mimecast-MFC-AGG-ID: GDMDWi0YNvSHU5ZJ4qe9SQ_1792597403
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0BBF918007F7;
	Wed, 21 Oct 2026 15:43:23 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B4EF18005B4;
	Wed, 21 Oct 2026 15:43:15 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:25 +0200
Subject: [PATCH RFC v2 4/8] security: dma-buf: Add dma_buf_charge_cgroup
 LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-4-ef6ee2dd8c5c@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=4349;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=znl1hbhvPkHiP1XBBo9O+z3sZFSbbBVomu0oqewjCLc=;
 b=LFnf31vV5uLvKeRyfLinIkjKbpF70zfdQJTZp/XdKtbMNiEnLPxU8E8whDfi1i53NSqRWshmM
 adRPRDyo8FuCo2yRgHVhOceyMgvDyscgpmI8um/Ur8g9+6hCkceRwFf
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: y_4INXg8oGSU_e-xj1xhck_bQ8LF1tzNOBhDtlcr4BM_1792597403
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3315A140006
X-Stat-Signature: 1ppxf9dxrhkp3inw7adaw5tzdtc91ypj
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792597413-809388
X-HE-Meta: U2FsdGVkX1+fQdkm9ljYPckJMgRMOFtcw8AjuUkTujIHxwdTvHj/4753Xs/Cc/LoBf+fJDUoXKqcDO/wLg3EuZzP730Yy8OLcPzZt+1NaSA3YOb5XHxfKlFW0zTMMLTOudbfYarAPgOwhsJ/FnO3FGswHUiL/D3mK98mKM2yen4w0DElPyLqZCYfbUexgRH5qfofNuX7lBA9SgschWfqTd8pac6ozDImSaCs5Lmp7luzHkgSGuw8L7j4RfHn1a7MOMMIFOOwzoznxvQ5Yb0JHyeA9D8uMUTvRarJlcPtaNd4d4VLgaaeIJfJbfPfQhthFk0KF8noExeCPGwcs+xTfTojTsUEVo6GXiA1wGU/FkNkNljdnQIK+aLx4suZpGgH2t879Dzqj+aU2QTCaWX2ebyKBdX7uVyd16+NEZA/0JI0cL7yrb4r4NiGbWiFZHx96xxkPdYwjI2wT4BL28gPJwOOn5avSxUPtpcPWRgBT+zBgs5iJ2mKipGc4jpfR1xhFNI4BtB7mJNNqmeeTEaeXxzzhmU1YYYPYU4JBaYL5AyNvZs6LjExpO6eKZ71Qb5ry5f98J3s1jvYsIZPuhSW+hfafFkNBRK9IlGrDHgHAdZOuyRNt7hzDaI/XuviECEt6orfW2u8wfC95lsgdN5Dk/FleaJ1cHMxduHiOMdvFm8TmSmwp3odPnLAxkDKOxaY31DU1qgpeF+cYgeG+CNsOm8o9awTnV+zSnTX0H5tFkD01jeq2GLUfQ5iDV1Lr0dM5aSW2R2Liqtw0+NAlCphs3597ui5PooZV2P9GYgmfMUDBTlApqqDQnL9zEjJWhmxcO/dRI9LMPUastUz2cQ1xnj+tfBEJZM03ZlKL6vxhaA7utsuzBrCSbnOD7uGNNpI4JtUbwRnGuAcvKxfjbAYjbXg8e5B+Rc09LcYRylOMBlPKEtYdZf/NN4jAGtOcrBQWMbipcGNRv1KmM2y6bP
 WXLIpOgL
 BJPMqTcCTbcFlQmY9eLqA/HXjR4jQeFN6Ua40Tjg50tp6QUcGKp0f30LHX9sIrrOYVqPiGThTXinZs1Jzh46okFlt8wphbim7jORlduoJDX8yBGVrtcAQ0yOtvmrGi5i+VZgFg9hoPuKqEIC0i/+M1w0POy0W+UadcrJ36guQPj1JImScgr5KFtYJa+VbMfO/8AUhfe4yo4P9fZTnUYDH0xpEZIQIvatbfQvo1V7MwiOPZPcpV+O+7O0ajfvOp8bMIJvUwYzsQqFkJeeCs1kgbbKkr0Mjh4JuHmkLAMWhs3j9UTHDKUCyyGsD0NJHGms5YA8PlaRezJ3f2VlkutQncGC37M3uSGp8vkhlCXyhcR7mBjInZYkEIAba9+J65QgqieshviTlvB8okA3w8qC55is8br6mT+x9OBDmPJwWMoFyEP5xSMcSbMxswQEWUHVo7xK8yq6q7YoQe1jmssJgH2g/xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to how security_dma_buf_charge_task adds an
access-control point for pidfd for the charge_fd of a
DMA_HEAP_IOCTL_ALLOC ioctl, we need a new access-control
point for the case where charge_fd represents a cgroupfd.

Add security_dma_buf_charge_cgroup(), called in
dma_heap_ioctl_allocate() when charge_fd refers to a cgroup.
The hook receives the credentials of the requesting process (cred)
and the target cgroup to charge (cgrp), giving security modules
a controlled enforcement point for cross-cgroup dma-buf attribution
policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 drivers/dma-buf/dma-heap.c    |  6 ++++++
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 security/security.c           | 16 ++++++++++++++++
 4 files changed, 30 insertions(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index c31573917886..e06131f4655d 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -115,7 +115,13 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *data)
 
 			memcg = mem_cgroup_from_css(css);
 			rcu_read_unlock();
+
+			ret = security_dma_buf_charge_cgroup(current_cred(), cgrp);
 			cgroup_put(cgrp);
+			if (ret) {
+				mem_cgroup_put(memcg);
+				return ERR_PTR(ret);
+			}
 		} else {
 			/* charge_fd is a pidfd  */
 			task = pidfd_get_task(heap_allocation->charge_fd, &pidfd_flags);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 0f1138e16dbe..9a719e0e9ced 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -44,6 +44,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
 LSM_HOOK(int, 0, dma_buf_charge_task, const struct cred *from, const struct cred *to)
+LSM_HOOK(int, 0, dma_buf_charge_cgroup, const struct cred *cred, struct cgroup *cgrp)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 89a35eb07b8c..4626c047a0c2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -351,6 +351,7 @@ int security_capable(const struct cred *cred,
 		       int cap,
 		       unsigned int opts);
 int security_dma_buf_charge_task(const struct cred *from, const struct cred *to);
+int security_dma_buf_charge_cgroup(const struct cred *cred, struct cgroup *cgrp);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -708,6 +709,12 @@ static inline int security_dma_buf_charge_task(const struct cred *from,
 	return 0;
 }
 
+static inline int security_dma_buf_charge_cgroup(const struct cred *cred,
+						 struct cgroup *cgrp)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/security/security.c b/security/security.c
index 4a16e4076aab..eb83e8bf3dbf 100644
--- a/security/security.c
+++ b/security/security.c
@@ -676,6 +676,22 @@ int security_dma_buf_charge_task(const struct cred *from, const struct cred *to)
 	return call_int_hook(dma_buf_charge_task, from, to);
 }
 
+/**
+ * security_dma_buf_charge_cgroup() - Check if charging dma-buf memory to a cgroup is allowed
+ * @cred: credentials of the process requesting the charge
+ * @cgrp: target cgroup to charge
+ *
+ * Check whether the process with credentials @cred is allowed to charge
+ * dma-buf memory to @cgrp. Called when userspace passes a cgroupfd to
+ * identify the charge target instead of a pidfd.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_dma_buf_charge_cgroup(const struct cred *cred, struct cgroup *cgrp)
+{
+	return call_int_hook(dma_buf_charge_cgroup, cred, cgrp);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


