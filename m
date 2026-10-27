Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE3D60A3806
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=X8tLHo1m
Received: by kanga.kvack.org (Postfix)
	id 180BF6B07B3; Tue, 27 Oct 2026 11:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131F96B07B5; Tue, 27 Oct 2026 11:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B286B07B6; Tue, 27 Oct 2026 11:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7FE36B07B3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:04:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 343D780A34
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:06 +0000 (UTC)
X-FDA: 85368726492.19.820BE6C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id DEAEB4001A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8tLHo1m;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clnQKjfEFK8X0M8lNuv/8A2TRN2gQT1W2JIxTZ4DDyg=;
	b=MNprYpNcuRem4DoBGS8NpmYECvC+kV16yau9au+yX4ybA2pkQjkoSZPpqKHgTx3LkOxVDw
	ZtoU6MCO8dtG49aXzuhB3AHSZHVxC7NBJDkMj3qAHxm3L0hqr/wP9kDVWGubxg8DTKXXMR
	om8GdlJMXqIj5NhPAZP6Qw6SY1VKe5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113444;
	b=CG0qLyqcFK/XD2PEeBIAzcq3sRfE35BRBbIYrbAorEGr1BH0s6rJO7VI9ehLOfW2p/7w/f
	DSx+iqMsZUa8QklSZuck4EUHuLz+LJA4G43iMuO8C0bjNp4jmqKwcb50IEG6UAePNENEl+
	ftIF5SoJ1yD/9hu9zlRNgp11f3D/XEw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8tLHo1m;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=clnQKjfEFK8X0M8lNuv/8A2TRN2gQT1W2JIxTZ4DDyg=;
	b=X8tLHo1mEwaUKoNKkr05ogO6mcxTis2GcYAuH+9LeJTcGQLKJXVMTYBnz5bx4gl1kKC2Zv
	nARcigZaXmaunmBBT8bdK7bwew1BQOJSOkJmi2z3P3Stm1d8WeGLCwm7lM9y6tAXofYGsL
	UeeVwswq0Oee8ZhvUvDMRJS5AimDQIM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-q4zdyQBDPLCJagLwazmDeg-1; Tue,
 27 Oct 2026 11:03:51 -0400
X-MC-Unique: q4zdyQBDPLCJagLwazmDeg-1
X-Mimecast-MFC-AGG-ID: q4zdyQBDPLCJagLwazmDeg_1793113425
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C67861955EBC;
	Tue, 27 Oct 2026 15:03:44 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B8BD18005AD;
	Tue, 27 Oct 2026 15:03:36 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:47 +0100
Subject: [PATCH v3 4/8] security: dma-buf: Add dma_buf_charge_cgroup LSM
 hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-4-78d2c4cb8647@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=4320;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=MCo2RbL8I0M5WB6IU93EJrB52id6wvFQktm0k3kDL+w=;
 b=EHWKF191VROUEjPP42Zho1fkTWoo+RLPsb16zXQjVBFCxoXVX+z86+vi+FzaYzl4KsL+td9Wn
 jtLAuMBbHUvCQTuyoEtMD8r6HoyOJ4NEp8mQh8CPzx8QtQmjriveSDf
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: vQvOHMUtExX86Q15F5fveNSDC0JZ7PRgk_B1-OLdT1U_1793113425
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DEAEB4001A
X-Stat-Signature: ofimrki1rbhzooeuzsdqmbdgctdnycnz
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793113443-311264
X-HE-Meta: U2FsdGVkX1+Byj4bnRZzG0z3asKDIIr5eXDn6jngX7sdBubVkec8TfjC5fkmkfj648qDx1nLq/FJFVcNpTRoQ8fbl+EDb4VBTOB5NrRh1yX4N/j3jzoKd846fFVF6Nf5HNSg/C3JRDMUqjRgtbJongrWnU1c2dk8sv38vcddu0Y0eGJycPTEiDyKX+LqSLI0GdmQS17tiI14We8QgFidgwH2NdJgxcUgz79xJjelfgtCiyv+sokm7PAdwfOO5zOgRhE/R2wZJnrvQnSk6syUMKOHCyCRqtyvJmwGNwiYLkj+hhGeqryU7SAMP81BB81f6V0zdU6uGb9lMnZtgo65k4NaQuL8tN62zBJoqC00f/R9czhgS2m3lwCl2c4VHQyGtAA9iMdj+sEZeHUgTEalyrljd4bXmgzeg59Ga5gDw41c5rwS+YI8v2/vIMcz32xYHFPA4uDHFWB99qtoZD+y1gUULc3SedI+MdK6+5hBsjZLq45aX8EReVe5B0hIJSKfTX2PQ61Ly7VvsBMaw6RCMY6OgbvIyZgZ4Mbr9hJWfK4m6p9UgyiCzcaKXFrEQaTU2rxJSBrA9qy1v2zHnPr7OjB2aU/Ei3gvJvAG+KrXRGsLdfPkFZ+FiILleKg/niqk32lbdSHwYuHm5oJBVvd5LxlTdbx8sD9ihsHwltTA1ScOO9UxVTlR6OhdDZbbwYsSBGdDl73S9p0uIqpxRicX7DXFXgMjcjaihzeum6S6SFaaOl/uNBCSxndJhEaHA3A55e0kaJnlUetIXJtj4uBSXuLAqOc5XPkDeMUMTaQidvw/krtEEZz+BrsF544NUAoDJyUTUMesGzAKVNgnAITEoDGINZfLmKAMEMDp9dJWO4P9DcQlJTPQPTbi4CcBKPRpFdttoNE41/N0pPalpjphrjcV44AAHfCuTijXO1L/ryOq4YTpduZtuf+EV9yIsWcOHy5FLyzkOnRoXUoHI8B
 5nvXpoSg
 7E2T3lknbYLF0lZ15P0z+d9NoFphOKjZSkYBi/aflhGFjapKfHEuEDNksxrqMhrgv1fU93mfW2jjK/sCAXsmCfzzf2z7yeNteJmpRy00BYsxQD4M32q9sU9if/XpAJwabQBxkUzxcijOfQiYxFuu5tRjiLlitGgcJeSLOyJE+Tm2hsn0+SG6JWH4tiP08qcRM1kBTzn2uWBXPSc8h844JrRH7bb1ocKo57+7NZWY065fwqqfRwU/CGKuPsHGzUonvWm27M3zmB61qQdiERKuUueM3mWVue3clWQewuDJ3HNubEMJEtIJidhIQj17jO5tWQHiIdzJk5oPuBC1YcVKngCxJ1mEEo5uijc/YVbOIu3Z+rdKPBnDCMNMhOW87fL5WYaOpbJiJMUMB5SvWhOlbfZ6XNAKDvJMWiUBrYzrapDimyUEKdVVoNNSvoeaLLA1Kmyuv7tnXxfn1oG+A+DHMgizshg==
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
index ad195cfd1b5f..7b841b905759 100644
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


