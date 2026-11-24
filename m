Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1999F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RAOOMKhm
Received: by kanga.kvack.org (Postfix)
	id 341496B06C1; Tue, 24 Nov 2026 08:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319086B06C3; Tue, 24 Nov 2026 08:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FA26B06C4; Tue, 24 Nov 2026 08:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEECA6B06C1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:05:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C48D160B34
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:05:07 +0000 (UTC)
X-FDA: 85470033054.24.C424704
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F7E720010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:05:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAOOMKhm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525505;
	b=Oa4LKuI5siqi2273ozqP2uEQC4l9j4YlBaiyD3lOe5ECpRJ65miGsrL/7aUSlBFWHocwXB
	rwfB9VcsxfR+keANyQ+WPXfW19xSsLjdq623OJn3CkI4w9h7d5bA1FhRZ/tAuA5l79h4Ws
	yaNf/uJrFdGMiUvLHdoqac9k2TTirq4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHqrrJBOJPwHyma5saYtPMd/5tcAtG5XUpif2stsI6c=;
	b=gUmIVol3vQA4/yO1sWNtGotNL0JIELmD3JPBSfkOsOBt569MLUE0dC9rtlP0iLbrqaDCwp
	tLYD2z9FZxUA4PieWU+26Ofp2WfHm5Owsb4Z0rNi+RcWetYOT+/xrMP1I7CbiE8oga1wfQ
	L/XAVT8em2ssb0fInmEY2xoz/r8LDVs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RAOOMKhm;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHqrrJBOJPwHyma5saYtPMd/5tcAtG5XUpif2stsI6c=;
	b=RAOOMKhmHQlCgQrrZhYgQQ0Rr3SxXUEYkPgHVOmuh58ejWjQr3N36ihAcZCVVtXxk2wWyy
	v5qoFpV5mgTOWfktqqHT1fmYZYiyHoSvjx3qbex+X/ajHxG0kju3nCvOW9BoF730krdH2W
	+Hy0qPwNR8+OaJbU97+Nm5fU6sxezhY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-BuLl_dL3PCyUJAUnKT7uEg-1; Tue,
 24 Nov 2026 13:04:58 +0000
X-MC-Unique: BuLl_dL3PCyUJAUnKT7uEg-1
X-Mimecast-MFC-AGG-ID: BuLl_dL3PCyUJAUnKT7uEg_1795525492
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 757D51955D95;
	Tue, 24 Nov 2026 13:04:52 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 813331956087;
	Tue, 24 Nov 2026 13:04:43 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:40 +0100
Subject: [PATCH v6 6/7] selinux: Restrict cross-cgroup memcg charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-6-dce12fa03ad6@redhat.com>
References: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
In-Reply-To: <20261124-v2_20230123_tjmercier_google_com-v6-0-dce12fa03ad6@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=3935;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=YotIlLIQVfYmQv+JgAWzs3C/IOGV77S7HbDgbIH2No8=;
 b=A8ZhZL+LOltwrvn/pwh8qPMWB3/tqr5B+k52OMOYOOPUTvlBfStesFciDdy/y5QlDSbMqekrk
 BA9isnKzIXNDSV2bMjiKaCybQwGp4+Ojvq+S9lSmMQ7HkEnb7VZacH2
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: QCZCe37RaTg_Nzq3xSzdwGLVXqixgn_5bExDPKeRMto_1795525492
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F7E720010
X-Stat-Signature: 6wqnsbjebaydps3udhrk459smce9q58u
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795525505-678835
X-HE-Meta: U2FsdGVkX1+ldQyrXMANtRsxStbJQqvBmeAM8ZKglzDGIqGCtLSYIsIusUa0vHgJjsRR8tofCWonf1NtRAqE3ocqWJg8Bpdw1Q/0Z5ZkQZptoF8Up5MMyFjCS4VEGU16ih8yMwUmi4+SM6We/durF1IAKGse3UP5Tnp4vHYsBty9JYkHYJJfFNijxizdb6nNEtCIdwndUFRCIJniTK1r5i6HLEtlFtSCB7VUCI4PPYRaNVyBxdUD/ctYMfD8qYaXqb1SVkc2atT9pKEN6OQQNUR7ecVo5ho2JJ14I7Ut70W4BjSR5T6ML5jZUb++A156OLBuUmdG4mSC5xZWU+lEadQmmOYbe/kPZr/OwGt5d7FFMqB8PFn6HFCeDlAoPP5wRz2ZEyHiKRlMm1Nh8wgRc8yy7JSxMwmNQCm2vzyHIj7glmTc/V9V842QvkuMIDdFoyRQNguO6u0BlWnuDLReNSyMXh8WdCaAGGuIEQT5Hz4Pv+BE2IO3JZ9TKK+YqyJ+KUvaOWrFhA7ssJTugQiOaP2+p2K7TVPUprIJIO1Gm9rL8zby8T/hr9UKFI8S2N6lta0xdCPrnHYJHOSouRdO2b9oHh2aCLaQNwIXmDmc8nIDgHfpRVMDN15LyQzyiWa1vS1Q26peEsqOvczwBpFf8zytzWU7qUdkXNPzAINc9xeSn37aBOpUaGCvgMVZm7KH5KWX7JLbJ3jK8r7/v5AYxQwQPypiHNRIq0gIJP6LajsglFw+WGbgTkaN/cemGGVEhxFKAFplLNuACz23pFAnPyuzdgmfDIg4Cjp9aB+I4ay9zMTlFgVMzDap4Cv0iwGOHz0T9Erngeg3YDe5coxtVqVhdDVDaiTW7ef/u21Ip8AoCJqi8LXHq3FN8YWvtJlmnZ/gc126XUlRIv1JKLdo45SPBO/Rk2YBzzLhwBlWU38xENagEpI/dsssgSGX0jYbnZE74ZYGmungs1rioT2
 gE7LkQvN
 xjkNksnCCVO/7YLsXenE+wpUMYy3yIsy9WMYVp2rckltNaJcQ4pCn+AWQul3xSODOlO2JbgHRzmpGtQSeeoeZkLgaN2T+FB5dE1Cf4WNuYwPjdlLk61GEt6a0D3Ah7HXvvwYozCxj46HhMij0phyzWiqU4ha++0nFgLTeZkCAyImtF4XwSIz8YQB1UMNH2FyBgfKqFg+chEalZfExJruetS1mbNL7e7HCHgKsYbLtDvL+Ue5WkLWuWrUp9g/kn79Mt8mevQYAERYfgQr+YFHGQz/5KzP37RMaqrXzDBV7IxvV1fJPgyDZVIz29OyC1S78rsB4NSmsjo3T46rAhijAerhG630p7/J+9b0r9Nv8VupihMlhbr0wc/7unA4DaekVl42yxFYkQSoACgLEDm1Phsfg6sUSC1ujXJWPBDkqQ6uGtMwCTJtjpIgt1R2bqONu08uwX9ICA7udQ5IWUJxrY3G/dRf7SPkTNxVmho0rjo8bbSH9yDlee6Q81+vi30tJw6FXY4KiOLwtXuWUvlID/dyYYTKXPWrHwPnB4HR6X8XTictu9UaIzenx6g+JLe5qgSt93f/EJSP+3+ZOFH/QjlGgczclmLY461If0ZMitbuGlOtJgy3aPERaZXQ1vUWhN85c46Xu/QFPQpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The security_current_memcg_charge_task() and
security_current_memcg_charge_cgroup() hooks allow security modules to
control which processes may charge or transfer memcg memory to another
process's cgroup, named by a pidfd, or to an arbitrary cgroup named by
a cgroupfd, both passed in charge_fd. Without a policy implementation,
either hook is a no-op and the restriction is not enforced.

On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
domain that holds both dma-heap access (today's only exporter that
opts-in) and that capability, can charge memory to any cgroup outside
its own subtree. Since the capability is all-or-nothing, SELinux
policy cannot express which targets such a domain may charge to.

Implement both selinux_memcg_charge_task() and
selinux_memcg_charge_cgroup() using avc_has_perm() with a new cgroup
object class and a new charge_to permission. Both charge_fd flavours
ultimately charge a cgroup, so one permission covers them and the
target type keeps the distinction: for the pidfd path the target is
the referred task's SID, as there is no cgroup object to take a label
from; for the cgroupfd path it is the cgroup directory's inode SID,
which comes from the genfscon entry for cgroupfs unless the directory
is relabeled.

The checks run when the charge target is resolved, before the
CAP_SYS_RESOURCE baseline is evaluated, and apply to every explicit
charge_fd target, including the caller's own subtree, so policy needs
a rule even for self-charging. Policy authors can then grant
cross-cgroup charging selectively, for example:

  allow allocator_app_t client_app_t:cgroup charge_to;
  allow allocator_app_t cgroup_t:cgroup charge_to;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 19 +++++++++++++++++++
 security/selinux/include/classmap.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6c4c64d6e904..76a714107ae4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2204,6 +2204,23 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
 }
 
+static int selinux_memcg_charge_task(const struct cred *to)
+{
+	const struct cred *cred = current_cred();
+
+	return avc_has_perm(cred_sid(cred), cred_sid(to),
+			    SECCLASS_CGROUP, CGROUP__CHARGE_TO, NULL);
+}
+
+static int selinux_memcg_charge_cgroup(const struct file *file)
+{
+	const struct cred *cred = current_cred();
+	struct inode_security_struct *isec = inode_security(file_inode(file));
+
+	return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
+			    CGROUP__CHARGE_TO, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7683,6 +7700,8 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
+	LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
+	LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b16425..1f1f2fc4d35d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
+	{ "cgroup", { "charge_to", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.55.0


