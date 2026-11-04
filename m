Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793DD606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=dIMeGDVA
Received: by kanga.kvack.org (Postfix)
	id 7DD0E6B05C4; Wed,  4 Nov 2026 06:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D886B05C5; Wed,  4 Nov 2026 06:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656AC6B05C6; Wed,  4 Nov 2026 06:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31DE96B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:10:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C14B01A068B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:19 +0000 (UTC)
X-FDA: 85397167758.18.EBFC9B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id AAA7740003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIMeGDVA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DU48/ISwE6r+xagkghxQRRBnqZ11v07G3uahgQ4weqc=;
	b=GSYo71/4PGDZGCsmFUYiFytoMRefY/Z67OwFpLacpi17g2ZSw2tiJjMIdedr/KcfpicEb+
	q38Pu76G48WO0HviJYHdk4xZFQkxJFbdELJ3Idor/n4gdRxQ84X2pTJRA2BKSW5FrPp0m+
	Vf/tPq1uJPt1PQ/UjAPlecfhIeKrVuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790617;
	b=Fsk1xK9lX57tUxp60oKf1Yx8mFVgsArHEXxRcuPSD04usdS/3RwLGtCDIBMvM6+fKsWsg4
	hV1Ud1NRX15ry98KMHZDcupNpalnJac30J1QR9+HrPvGSj5CuVIxE+8WZztBFoX74Gr000
	GaOiIY9sIGeS+GE+AZUXPbCUUvnyKU4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dIMeGDVA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DU48/ISwE6r+xagkghxQRRBnqZ11v07G3uahgQ4weqc=;
	b=dIMeGDVAmFNV3fz7/XAnyN0pjkPbTbt6n/0AgooTOuX6qEkgCiOS2J4eOhZxDIq6Tw1Pop
	+ORXzDpru5qATVn9diT4Owh/bZ8M3+5ZW2yXnErwVrrHm7J6PZkz/sR51pabepSRt57rMr
	P2Ph87rAsEdXmgdbWW+NW0SbFPpg9XY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-bafTYMDaMr--5_kfeMuadw-1; Wed,
 04 Nov 2026 06:10:13 -0500
X-MC-Unique: bafTYMDaMr--5_kfeMuadw-1
X-Mimecast-MFC-AGG-ID: bafTYMDaMr--5_kfeMuadw_1793790608
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCFDC18002C3;
	Wed,  4 Nov 2026 11:10:07 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84FA81956088;
	Wed,  4 Nov 2026 11:09:59 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:14 +0100
Subject: [PATCH v4 5/8] security: dma-buf: Add dma_buf_charge_cgroup LSM
 hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-5-1819a017000b@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=4320;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=M2gzLVfeMYXG5SgIz3z8BJTK8aHnWCZgYqRzq4G9xoM=;
 b=GI8FqhRocym0ire0EwWWf1etkZE9k8lyBemdonWgvlRrZHnRFe420h4eoRVAOZKaKAyvt3yZx
 do8Y0zbDyFkApO24yfqo56x2/Z7dQWKBpTBXrHnpL1qWAvYFa5Zj4bV
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: igDd1GqHB-28MFrQ3B1B_gtQLcipzzvVXBvbXxFO_hM_1793790608
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: by1q7sp1bbstkuoutxgitx498xzeaw6h
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AAA7740003
X-HE-Tag: 1793790617-588224
X-HE-Meta: U2FsdGVkX1/70o4E96YGxfpknUwwK4s7PtpYivJ8echUNt0ep3p66LoRySHoVk5D3zqlnF9zlSjWnG+KWaMPcVjqb2omRQGbPjFaJ8zl6z4HuZ8MQS29sjq3mGO6ZDJg6fffppi/kQRF+EmU4tsinECGPAuMlwUgRdkH+5KsVSKv94ufVtbewxmuyWV32RAQa9JXg7GVAqa5yVAcL8+B0uGZJsQtrkGKWsE3cRHp/9+B8nmoBQtlSMwcbWQg/CMhgXv9OkHLRnK1Rt45KO7rGiAnIiVWmQ7LglEhCcmrwnHcPUoiQ6MYYvANMH5BIUfKGIRnXWDkkMTKQrvoGGhbWghGHsjC7vWsSaR51DNn9jQ3sGUzzs1ig7djnh/N/+5Qq7Txw7hlMoSO0ZyPV6DfoEcPKZTe9j3O0E41iivbNtqJZev67x8SKeMJWeNsYAA4ZvVhZHsKaKMagogSIcOw0I44/UU9pjOdYcv4yu3ZoiNllD3yP154GR4J9H2H/xQO/4t87h8F+0cohZJQfHPEoe+1vceXJvNoAr5qHUKaDMChd7GecGWhj73mI475RHMnbmakY+N8F5jOZ8uLixYdW5fcINnfU81cCwo2LzFhlJmCkUqa+J9tly+Qb+kfnMDjIScB1aafOwUy9+vAmEeP/8v6A4YgHb+Vj6OvKefQrwCORThPA+urFOOimAvtU/dd58FPe/JSp8opUijcocrU+np06EonBWZefvjW1cwmYW1fbuT9aXWOeJIkOPFPiky7I5TT4pHWCl3CY5eCYNHryn+N9QwoMxfyFCWZzJreDm0RY9wwKxFciornrfZauulPfw9SnP1uZdlohqvH8eZOTQN6sX0zl2GcsN9vin0tM+nPJTAVWdmgTRTaVsGxJ7/uAXjNIILADbnnkyOC+eYpp84LFgbrb/OGdg7CKIJY/KLwLqSeGpK+FzZatz05OEePP47c7ZmbgX0GwUg8zXR
 cW5PMPfC
 9ORxqnvTGMclavFZQ6ToWSVh0bVdOQsxKcjGWO02wDfxbUAGipDWXOTlpl0GmE5ti2PItLdjx8T2RAX77Y3mz6gZ4i2DCr8MG10kuP5C4W7Kco+6IV3Pb8O9r6FzLuJfTUpZgsfs6riRSrLtMjOPZ/5Gdv9fpg7gW/A+SrBaGvzrvchhI6gODnIoiyq9YIKvfrV/mTuDjz56yBQC5BaHpmzXIHP16ecVisOGnafddNkPmgBPyTmP+KJaKPl9DYxRPWbJlUxlXawtz3dIjma+guYtLnsLq0vky3wSpUZkixuGdzo3TnB0seuttGm8lXdGvR2MjVvOp3eIyAljbpIl24Rfnud1HbCJFEcd3N1xdAPwrvK6rukiy3kI7/uJKLXUCitETv1I7kf3wy2wPZJJrNIDsvUU0zoAqM6SQhoai+8048b0pSnL0+NIViKM82idmRkNb+SIp3rSgZZ843u9Hfh/CXYHf9DSgZxrbraM5oTO7sRhd74fCIEYkZd2M4Xk92sbwTlaJr5DcW969rI8YZnLF+XiMXNTI39X3CGYGAEL3bQl5V6L+M6wvt8x7f3M6FeYbAgR7m2cUHfU=
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
mem_cgroup_get_from_fd() when charge_fd refers to a cgroup.
The hook receives the credentials of the requesting process (cred)
and the target cgroup to charge (cgrp), giving security modules
a controlled enforcement point for cross-cgroup dma-buf attribution
policy.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  3 +++
 include/linux/security.h      | 11 +++++++++++
 mm/memcontrol.c               |  6 ++++++
 security/security.c           | 18 ++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 0f1138e16dbe..fbf7f17127db 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -44,6 +44,9 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
 LSM_HOOK(int, 0, dma_buf_charge_task, const struct cred *from, const struct cred *to)
+#ifdef CONFIG_CGROUPS
+LSM_HOOK(int, 0, dma_buf_charge_cgroup, const struct cred *cred, struct cgroup *cgrp)
+#endif
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 89a35eb07b8c..8fb1539156b5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -351,6 +351,9 @@ int security_capable(const struct cred *cred,
 		       int cap,
 		       unsigned int opts);
 int security_dma_buf_charge_task(const struct cred *from, const struct cred *to);
+#ifdef CONFIG_CGROUPS
+int security_dma_buf_charge_cgroup(const struct cred *cred, struct cgroup *cgrp);
+#endif
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -708,6 +711,14 @@ static inline int security_dma_buf_charge_task(const struct cred *from,
 	return 0;
 }
 
+#ifdef CONFIG_CGROUPS
+static inline int security_dma_buf_charge_cgroup(const struct cred *cred,
+						 struct cgroup *cgrp)
+{
+	return 0;
+}
+#endif
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dd276e1230cc..4c718c06c122 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5693,7 +5693,13 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
 
 		memcg = mem_cgroup_from_css(css);
 		rcu_read_unlock();
+
+		ret = security_dma_buf_charge_cgroup(current_cred(), cgrp);
 		cgroup_put(cgrp);
+		if (ret) {
+			mem_cgroup_put(memcg);
+			return ERR_PTR(ret);
+		}
 		return memcg;
 	}
 
diff --git a/security/security.c b/security/security.c
index 4a16e4076aab..a5dcf9dc4963 100644
--- a/security/security.c
+++ b/security/security.c
@@ -676,6 +676,24 @@ int security_dma_buf_charge_task(const struct cred *from, const struct cred *to)
 	return call_int_hook(dma_buf_charge_task, from, to);
 }
 
+#ifdef CONFIG_CGROUPS
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
+#endif
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


