Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9947E606D825
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ROeUvOGP
Received: by kanga.kvack.org (Postfix)
	id B60846B05C8; Wed,  4 Nov 2026 06:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10BA6B05C9; Wed,  4 Nov 2026 06:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF976B05CA; Wed,  4 Nov 2026 06:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCC96B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:10:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE33E16044D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:32 +0000 (UTC)
X-FDA: 85397168304.18.5E31EEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF62140003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ROeUvOGP;
	spf=pass (imf12.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790631;
	b=FUt4qnGDWBcq0/3aR3CAiFdlHkfDQsusN8oBZXUCYHQzxr/wgisblNTDtMWsUHHdwRuKD2
	9YUU96EZOjakq6c0P9rribvzvt2GkOb0z3zzZTEhFKtihZmRpJWfyUhnsUke5g2un41wrc
	iSDncQfm5wy2U/ZqTj5OnpwZ+GkQ9uw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ROeUvOGP;
	spf=pass (imf12.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELwETE9puCDkWaMizckqbNhj0IuGl0YqFp+CU1fqLCk=;
	b=WhPOJTrE833C426vhwdY6flMVjklqfu8zGV44mvc4Wq2gRp97gfpxHuPPoOjLK8BWxOcgl
	WL16FRfZiNjVOd3ojISiwuLeIGN4nidWqKYIyg5mKpduEL9k/i+LQxx+SjrnAwwHohe3x4
	UoiP7ArGSlsqZloxCRf9XeqXClwl1UA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELwETE9puCDkWaMizckqbNhj0IuGl0YqFp+CU1fqLCk=;
	b=ROeUvOGPjqlY2Qktvgcwk19XVzGENuMRsRinjsR0R1A5Gf8JlrqfBG6/FKWn8y2/dDVcSY
	mY1tf8lyvfkGkdbNaVepMzkLC/7AGhaB7FdLnJpF9RUCZvMM5h14woMUBsQXCYzWXlMJUS
	dtW83a2WGfmxFpD3n7G23GdMqz04rWI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-1L7OencEMJGdWJH0g_JRyw-1; Wed,
 04 Nov 2026 06:10:26 -0500
X-MC-Unique: 1L7OencEMJGdWJH0g_JRyw-1
X-Mimecast-MFC-AGG-ID: 1L7OencEMJGdWJH0g_JRyw_1793790623
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C617D1955F13;
	Wed,  4 Nov 2026 11:10:22 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EB771956088;
	Wed,  4 Nov 2026 11:10:15 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:16 +0100
Subject: [PATCH v4 7/8] selinux: Restrict dma-buf direct cgroup charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-7-1819a017000b@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=3440;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=wN5MetiOIXBEZQC/HDlRJrMQSnkYl46Q+UcUWMTZ3cg=;
 b=oMMuIFqlOPKJ0KgFiraKa13vuvRxfMVBGKbtx9EmwR54ihzbuFVkHKqf2RGvUP5I/WIbM6ypa
 zz2vFvvhM8PBBddhlC0SdGNiND9slNNYtzoXhAclslaXWFYOvWU46Gx
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: DgfChJ3lBaJcWiBAXRcRs0Fg3fBLPKSYCgukS0edcTw_1793790623
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zm6ssky8mwo7agji9sddcm5kx6udi73d
X-Rspamd-Queue-Id: DF62140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793790630-862261
X-HE-Meta: U2FsdGVkX1+PRYuuAAwXw4oU/T6hVF+ud3Ozb3D5NgnSqAR0CMRJMCWDGUW87VaTMA9i0rqEFmHx8D0fRWLXtrPT4Vsln+wRMdYNiqwUzCiSCdhI7dKpajQ9QsafpL4FRncqW2AuDjoMdclVYvIeH8DgJ+eiE+Ff9lmDTHi4nh4ZJaXvnXZ4ppev8X6a2cDpycc/GPqvN9B3ygrjQUAbUIHqKelnFiGUXT9GF62jjgVFOyL6kIBY9XvweoCSSwon4sL3TcAB2iLcuBP9e+7wwWc+5HEymETjU0NI3jtGuPUaB7ZukuM1qtAtkb92uFzTEM/roJE6pSvGiOOcsrhY3fb2zLF2VVCOlyzHwwRtATmXce/I5MfYPvqLsJU0+l9KTzkUV+OEP5olqHuB91cXngIUFoNlKj+UrF9x4cDdlCnN6mL+tFFpaVNxUuQ0E2wrxaWQxeFoc649QCH5hAw/moSMxk7Ow/fr95K8gE0lAznashglvAXL21P4KJaWyGeHvaObZ3KsqlmqEVIE+9YAQdUwqy8a90zMEwi5voJl3N7W9R77seeO/BhE4BXBuSRkaRajt0fWxJyzgfwWtR2KlQeTvyxKGpXdDuvygz9jR5LqgOR0gi+aUvFzgX792gkqirrOSSvaZ2f/ODgnVsNerw7bTSWxpG3Xv8aH6n4l7LPlDpcug/RvODpe0n2Dyxyq6xzfnFoRWrD/C+cVD2k2Qctgm6maGSdJKA6zG/kltfnRDfB60KqjNE8ACfCXnUq524c54hw3hLFoww3Rjv+VN6AKpHdgbauDAd2dA/alSipCO6RNpyXDT8kyqqoY8FlBmAvwFUNqfTJPQgVXa31OIq+qzn2foKluT2OkgQFWzQGnogVLldWpsQsadiAEsnWKftqYtX03m+tiNJyog2PWjDUeCpEImhfa4R4guO+BVAEZ0tjpXja50jz5csMQb069V+6rF3gkPTG2icy4VcH
 IFkYdesb
 Tux1mpF1vStSiqW9YCD3qCWTyaQZ1IJ/gDjGhOuHjTIjvUBaooYiqJT92btAEr5yxJbiYYC8F0SiPv1d5pD1JEghktZf0UE/fVw+gyz9By/lp9evsNiCHVpHAvI8m1gOTcuFm78Yj/+S7kyekICssitQyeCFf06j6JDchY3sxcOE4qllvFxTLVw/ALAhfbUwhYE2bRVqy9CK5OHfsW+Q5AyoMeTKtydWUigFbPe/jNgOzbmROYu9xr+gkFl2ziLhll0K9dMpVStBWOjvT0QqkY77D0Kya6dpDldqf1Qg1ez3HSt9/CF+3hlq+B7xE4iIAQqUw8dqnrhWi3tj+Y3ng9AU3zf56TrfECU+id8eIHhcuZV+9Ky+UT04s85e1AJaKaSiabWomJOj+cOTQCVnEQFcLNLslWSK0DnxhA5odvUJCyRfVM6fdzU5LOx/u+jjSU625AWgL7QDoB9whQKm7Pm5PzaZa6gz06pqej1PgVvqSDxwsubUyHCxbettYM351DkpEsRE0lpoSVeSFDaR9NtZafQCtGl1DIwWn
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


