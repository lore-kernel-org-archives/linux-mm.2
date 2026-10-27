Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A0060A3820
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YBHtGSru
Received: by kanga.kvack.org (Postfix)
	id E03E96B07B5; Tue, 27 Oct 2026 11:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4356B07B7; Tue, 27 Oct 2026 11:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA58D6B07B8; Tue, 27 Oct 2026 11:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A51F6B07B5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:04:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABC68A0A7C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:19 +0000 (UTC)
X-FDA: 85368727038.05.BDFF575
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6EBB180002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YBHtGSru;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELwETE9puCDkWaMizckqbNhj0IuGl0YqFp+CU1fqLCk=;
	b=W1RBGJsAGzlNbW2HwrOmHABAB8ixJhTANIMjqGqQT/NzMk2zOBsnS4uabetfGUo+/5B4Hv
	PHQCJC3+Z9sVPBox4yT/P7XJKbW0Uxzy1XAEy6PNN/JYhgZQ3/HOXa1mAY8V6oM//xw8rG
	Ei89eXZpdeQxoSWm4Xlju4bpik0lcGI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YBHtGSru;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113457;
	b=bn/sSDYeu3w9taYbmO19Gq2gVnKX62V8EsgMx5qDUvwWrz6Z/r01gzhtzT5c9bebcD0qrS
	/Wf2+9/HhIqrvj9E6IlPjaNSqFs0tHYFB6pvSfoIwMPXJ04tpLi9lcl/bQ4KA8Pcu14eag
	sYF/Iw/Lmt4VJ5XjAleF1oNroGZwrlU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELwETE9puCDkWaMizckqbNhj0IuGl0YqFp+CU1fqLCk=;
	b=YBHtGSruxrREQBa7WVAHxIIC/CfusuUMQFsXMp8fe4AYrTQFXF2w8e6RrhPlnrxiIUHphL
	g5H0VjRkytY2cgc+Gw+X7cDESefQTSW0xbWmXU/WIXnjUKTYlGDDjUyuNhJJRvuRRktRGM
	UBE0bAxNLO6lPk9T/wzOHuIjQnjlP5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-396-5IXUjqf5Mh2LG2GcL9QwLw-1; Tue,
 27 Oct 2026 11:04:07 -0400
X-MC-Unique: 5IXUjqf5Mh2LG2GcL9QwLw-1
X-Mimecast-MFC-AGG-ID: 5IXUjqf5Mh2LG2GcL9QwLw_1793113441
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82C2218011F7;
	Tue, 27 Oct 2026 15:04:01 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4D9318005B2;
	Tue, 27 Oct 2026 15:03:53 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:49 +0100
Subject: [PATCH v3 6/8] selinux: Restrict dma-buf direct cgroup charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-6-78d2c4cb8647@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=3440;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=wN5MetiOIXBEZQC/HDlRJrMQSnkYl46Q+UcUWMTZ3cg=;
 b=Q4GmTIe9NYB/opKZPIGgb1l9Vz3CAgDxTYSN9JTAtPCTrV3mdRnv1TsODGNuYpi5pugIrMVT9
 NyXpu/8zRMPCV9OKiHBHRsHuA6x7vW3nPZla8t2Jv2SPWc6vcnBt60L
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: g40LIDgjr75IaykAc4D9M2Vlu2UKduXj2GkSK3LxoMs_1793113441
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A6EBB180002
X-Rspam-User: 
X-Stat-Signature: fig8mntj5shd7wfib3ssee9h9rp9gz6m
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793113457-780074
X-HE-Meta: U2FsdGVkX19KGHH1EgyMQToZgVd37jlL9t4hIAZU+ZtrwR/lZabIF4XxD8a13ZFmSmHCBbCyrTZK3Il3VZlaA1qjr1AikR5gIwjWFtetccliTvnQnGi+1I/OkWCgFlc3u1Yh/mX/n5uXRG+YRkL07HCfHk2Rn04+dW4mme4BJzgjfEvXrYCS1NLumum6qsbJ+jmXoO3+pvINMFZ1admes+Dn+WYDa0EfVog7kMSBLqDMG6eji9xP+M7ZNrIZvlBDmqqvp2cuBYg3STUtR/Ed6ZO16lo+O66bRTJmx849D8NOOGeVgJim36fYJdCWQHH0TGCaY8/48SY8nJr/QD931xvE7UfTa9/wZ98bE21muqgeNBpncCteFUg2Lrf1aVMc5Tw2urhqzfyXCW1WtRSl2PFZ8La1bqU7S0ETeI7X0P9ufdLpAbGVVLAdlE+8qSjbe6iGnu6egkxow/9bqfRUWaDd4BLYu7fmFu4EUDuxZjDssdvhkSQrFNnfkfeP/zTQZnnakI7NKiaQblqXNVZSnQ/CUzrfFteaSPshUy1uLl0ykelOX1agx+EoKvOKZxEel3WCw+dtUYBl6hJJRs+qjUlw5m9/gT5E5JFd+/6YpLNrIEsnjkmMMiU7xppEauqSFqMFipCoblRzf7yfHwqdCOUGxnoxwuRrIi4YzXJ6BaIdByoHqUb9pWQfqeXxqi3ujMsya5ctGzGj5hZI8U+23RTMJ2njznmNZ6DkThSoQcZoHK1LCMsew1LRDauwB3CzVyRbARUTptKtvuPD2OgbJgERkhxDos3YSkeTyPv4GSQJK9k4+hY2dNFyLeSjjRvorUG/3eDmNs3PhEQpLYP8uK+Tg7GlqovgWM6Z7no70HKfLIpXkvSYBgj7Ou3+Fys0tBqkHtPyHYpilAHpikGPQMJiTVoJ+qzfN4Nbg4Z9YaDgaUyqLqkcK/PwD5Y42bxFyD/7h8gRi2yfDhwlJcc
 raqggnGg
 3MTOXNhUS1WdnMDeK6EtkpN8mWhbDLsDrt1rn9exUBXHTkdvqKkPnlmj8QHvtSPgCcJgLtb6SJ/Jq6/NrxGEquGxFx/EFPORtDEEKrmSCRRmayRkaCU+bIMeWqjGPyxrjwy17vmtoTmtQpoFdUcaOAZtcUDf7osoC7jLFD1PbAO/e/JzekRyiLEMPa5htgchieE4Xg3p3YKPt/q24NM1yf4tSN8lMFl0n8AOdpuoQCSqlIlLOV1zNKxMygPcp5sHssyt8euWRkvP/woHUmigbxOYCqKAPlX0NLTUpdqphRyU194ZFFArhoTu69QN6SGX8c9ibCEXbEmOz++0kHXPSb14+dP37SHWVyoVI+WQ9Pp4foGGf1gMqwSAWY3zESA+cVo5gkvpkpbudAI+LdBDfmgcr4lQeCOlp0t9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The security_dma_buf_charge_cgroup() hook allows security modules
to control which processes may charge dma-buf to an arbitrary
cgroup via cgroupfd passed in charge_fd. Without a policy
implementation, the hook is a no-op and any process that can open a
cgroup directory (effectively any process) can charge memory to it.

Implement selinux_dma_buf_charge_cgroup() using avc_has_perm() with
the dma_buf object class and a charge_cgroup permission. The target
SID is derived from the SELinux label on the cgroup's kernfs
directory, so access control follows the cgroup filesystem labeling.
Policy authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t cgroup_t:dma_buf charge_cgroup;

The hook matches the fail-open semantics of
selinux_kernfs_init_security(). This means unlabeled cgroups are
unrestricted by default.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 37 +++++++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8f39d91eabc9..2f99eaa910af 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2210,6 +2210,40 @@ static int selinux_dma_buf_charge_task(const struct cred *from, const struct cre
 			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
 }
 
+#ifdef CONFIG_CGROUPS
+static int selinux_dma_buf_charge_cgroup(const struct cred *cred, struct cgroup *cgrp)
+{
+	u32 cgrp_sid, clen;
+	int rc;
+	char *context;
+
+	rc = kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, NULL, 0);
+	if (rc == -ENODATA)
+		return 0;
+	else if (rc < 0)
+		return rc;
+
+	clen = (u32)rc;
+	context = kmalloc(clen, GFP_KERNEL);
+	if (!context)
+		return -ENOMEM;
+
+	rc = kernfs_xattr_get(cgrp->kn, XATTR_NAME_SELINUX, context, clen);
+	if (rc < 0) {
+		kfree(context);
+		return rc;
+	}
+
+	rc = security_context_to_sid(context, rc, &cgrp_sid, GFP_KERNEL);
+	kfree(context);
+	if (rc)
+		return rc;
+
+	return avc_has_perm(cred_sid(cred), cgrp_sid,
+			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_CGROUP, NULL);
+}
+#endif
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7681,6 +7715,9 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
 	LSM_HOOK_INIT(dma_buf_charge_task, selinux_dma_buf_charge_task),
+#ifdef CONFIG_CGROUPS
+	LSM_HOOK_INIT(dma_buf_charge_cgroup, selinux_dma_buf_charge_cgroup),
+#endif
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index b4ebedc6e424..90d1e04c3d27 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,7 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
-	{ "dma_buf", { "charge_task", NULL } },
+	{ "dma_buf", { "charge_task", "charge_cgroup", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.55.0


