Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA3560A6F78
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Gcz9ySeW
Received: by kanga.kvack.org (Postfix)
	id D934D6B0735; Wed, 21 Oct 2026 11:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A236B0736; Wed, 21 Oct 2026 11:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C802F6B0737; Wed, 21 Oct 2026 11:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6B56B0735
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09AF680594
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:50 +0000 (UTC)
X-FDA: 85347053820.18.D1ABD08
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8AD3140006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gcz9ySeW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dk6wwXssduvkysnCFA49Mb0DnkBZNEAPmUUXIY9glP8=;
	b=Lwb45HT4GuVr9/JbjCOBdnlar289rQbEeE4z41O8Hv4uxmv14bUJkjsDZiIDl+QQ2D/MgN
	bSu1YrJWuLuv4cvnFfyzrLS8tcABljqvzVk4MDV03SI9lC8PYF+BOorPdiGcT9nQNIp+Fh
	fdsG0wxQINpn7io/3y8EymGU1/pxQa4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gcz9ySeW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597428;
	b=auc20vpYrIPCEM339vPhP+TNdnSUFqa1UFWqqEBVnJPd8XE5aPeemjYU9MhzhXIRs8lpvD
	AO2agFfuojLi5CU2BWbjtoShlK4w47wiZ8xUmf5WOprol0vDOuMs1RUwYRM5kVhEnaRJ5u
	muBkOusWAruN99CNMzSsZG0vHOQo92Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dk6wwXssduvkysnCFA49Mb0DnkBZNEAPmUUXIY9glP8=;
	b=Gcz9ySeW2hza2XLss+eZcHv8vdev3DdHpcVXINYSuSHtAw9xzm33fMYFeSL96pcgSlNmlP
	6QPkHNvQMoWvlpr2BchTrDhSgWe6/k92UjVp2ddMLEn6fLMwogyyLuNDHnIJdyVyJDZ7N7
	oKJnMoX1Gz3FuzKm7xC9etcOQY6FNi0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-JjkEKVxdN4ykZuUXpUfnjQ-1; Wed,
 21 Oct 2026 11:43:43 -0400
X-MC-Unique: JjkEKVxdN4ykZuUXpUfnjQ-1
X-Mimecast-MFC-AGG-ID: JjkEKVxdN4ykZuUXpUfnjQ_1792597418
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39A0D1956055;
	Wed, 21 Oct 2026 15:43:38 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ADBF918002B1;
	Wed, 21 Oct 2026 15:43:30 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:27 +0200
Subject: [PATCH RFC v2 6/8] selinux: Restrict dma-buf direct cgroup
 charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-6-ef6ee2dd8c5c@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=3371;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=WhNF22wskvchWhAOLXz5tK1hE/8N9oZT6SVHpLAxSMQ=;
 b=varrJblz1GmvQzfke0vE+VKqGOZD7frOjl2u1GrLrmjgsm5CEcK9ExzBs5iyDAiQiA2o3+Vtv
 HP7IXuHUoouDUYcFR/lpCtvrCnDI873UHcD6SIkoRdCsHZeG/oUcSe6
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: i7CFeJU12wX1uLequgIvU3HmADY__yGrmq87ZknTco0_1792597418
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E8AD3140006
X-Stat-Signature: w7nye7hc1w4xggzknkyrdk8hwz8drr1a
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792597427-205467
X-HE-Meta: U2FsdGVkX18yMVhtktgPmOEWw8f7ipFkappMrUfeXfxkkkoiJX5KdxGXDWYdPJtPDYyLidvOcWhJM9+uKPMld/M9PcXwLbP32IEFqBUVVuicVHcrv67QNERRBXdnAN7WP4GVgVV3OAZkBMDpxpmjvfRmxpRr3dYWl4A9hbAulaplAc29qOgZvAGhbTITPD3oIWSk9FwdjCzNntZVTxQC6zVo9Jhtfr7jQ5lMnoYVeekHbS+Q5cf2NqfHJcjoHJnptk8FHZjnKTnU8Qlr34AG/2Ga132FX7WktrUbl4Z6dsgm/y80M+IZ0OCUFy9xNBBCzYvTlMYoG0ummMe1/hSHJh6eQd9huCr0DNw1VBObMIuuR3aSsIesuCbj1vYe3XBQyiD8oi3zEJ2MvcX8vV+WE72ltoC2IhkdYyEZmZvjpZrzzPEkXkUSZc5j+xhXpmaICNTETToOrm41ca9NHYSE7Fdw4qRDdQQ4eXJl7Vjlx5g9kh4YdvFK1Vi4pVs0ObPdwmYhfvHqiTdhg39oe4bmfiJtUOfyx7x1bRNTVHRu99/e4ZAKJgZyTDrLoL9N0cbj9YwCGI/lbYZz7ZJPNJc9AJA8Zx4eVrjuPvQ7TekZjneVlLL038SdGNZmY3ELPSpKuaxnYf+/oG9AWZA3GFLcMHxu3Gi/wg9z8EROD6VUle9C+o2jd+D/YjxoDORbSvlSCRn2bfFLliyHGm7anKnh1pX9rWymCCCa32uyfKoHMBeo5tBQAYEpOLKfSlRdIxVt+XmeIE6WZj7Y5p4nH0C0gquC2oM4pGRCNmF7VBI4iwppxRlajYiQi6nZWBn2MstgJM9tVnhz/oqRSoaN8BiM1tMJxGohiKMpCS8mta+mqAvmBdf+raR6DB0fYuGrDUciKZgxf/bNidEhZiTn6+Z1iLy55eVscMjQZGtmEX0aHABKyrpNXQeqbu4oanNF8lrvBYSrzLI6Y9i02Aea4rk
 kb9UaMwK
 8FZrP/+qZ2/0Ty6vXojTze7sXhRDjzquuM2dnwMl2drMn7s00xJ6aEAQp3ES2dzCCrvuNPw/nTtgwGWRsKKlr2a5RIKgrNHOmOPGKGzySaiZvs0wJUqTBrK1Geyi4atfRHMwHHXUPMHoJ6E+Qgv2JXDj4NREmYTMmFW5mqyRYMS9JD2rpLT7j6Ok00xs9lrpTFuJhJBe3cQt8jl+bWj6ZQpJVAptLFXbsF57iNEStWxq5CkZaSjMr512uQ/DBhynas+WWU+BW2VPkijvMmCxSoBLFMNm7Gx7KcMBit9j706Xkv2qdqgO/cXAm/6eKe4f1DGvAOUSeD0ah8fVd0AYGObvbcoAeKDyGeGTYF2o9QdTFyJRgj9rUV4k56IcjxakFFy+sYOtqny1LCXBR5dGU4rIAe85lDMX5ujYT
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
directory, so access control follow the cgroup filesystem labeling.
Policy authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t cgroup_t:dma_buf charge_cgroup;

The hook matches the fail-open semantics of
selinux_kernfs_init_security(). This means unlabeled cgroups are
unrestricted by default.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 33 +++++++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8f39d91eabc9..8de5e16951de 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2210,6 +2210,38 @@ static int selinux_dma_buf_charge_task(const struct cred *from, const struct cre
 			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
 }
 
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
+	rc = security_context_to_sid(context, clen, &cgrp_sid, GFP_KERNEL);
+	kfree(context);
+	if (rc)
+		return rc;
+
+	return avc_has_perm(cred_sid(cred), cgrp_sid,
+			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_CGROUP, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7681,6 +7713,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
 	LSM_HOOK_INIT(dma_buf_charge_task, selinux_dma_buf_charge_task),
+	LSM_HOOK_INIT(dma_buf_charge_cgroup, selinux_dma_buf_charge_cgroup),
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


