Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF5F606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=QWLb352j
Received: by kanga.kvack.org (Postfix)
	id C6A5F6B06BF; Tue, 24 Nov 2026 08:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF3286B06C1; Tue, 24 Nov 2026 08:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B095A6B06C2; Tue, 24 Nov 2026 08:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3C16B06BF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58A7C120B3C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:54 +0000 (UTC)
X-FDA: 85470032508.17.33876E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4FAB4100014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QWLb352j;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525492;
	b=XWnoe7xONV9Hz/TazWwoD8IbZMdzfo0RoegKX+TDtKpWpjPj4N9NtNyehj1u8dS4oL3y2K
	4sMQ5OXbm11XHAsMsszpGtYxundD70xmTTJwMCD0IT0J3I3dbxi8CbFANV4z0/QOeB274C
	zy6xg7CKCgluJ3RaTuwpbSOsDbFm6Qg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ray3NrLqzkhmnwJRomna+zujwV+SFq0gT4yl/osPB34=;
	b=f9Qv/FRTYzG5sU640BTqnDo78TxZVENSX8T+UePVzwT3qBwXkKNBkZr5KFMXPYSUaVdjQt
	9FJRQdVZNmxM83TOWjR6Xom00BRznlrh3XbAYPWjA3ixNMv+02Ex5cLROhu1wQ3m2uQpL3
	WGxlRwB1pKtpDV8Ac0W6kIfQgvffp9Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QWLb352j;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795525491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ray3NrLqzkhmnwJRomna+zujwV+SFq0gT4yl/osPB34=;
	b=QWLb352j8JbSuLUikPk/6OeVejj+fuzreYYw46alxBvSyjxM9gFJgYQI9yBnpWV3LxL6gC
	PsoFR6RnJSAg0JMer4Xe0g+eX1QndBg/svT0fMqtNGAovy6FVI3WrHFNVoqc84NTYezpg7
	mX/MPlBkR/E54oLY0cxPXN8/9lEBgYM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-W_6pPIz5PB2zzCcRCZbmfw-1; Tue,
 24 Nov 2026 13:04:48 +0000
X-MC-Unique: W_6pPIz5PB2zzCcRCZbmfw-1
X-Mimecast-MFC-AGG-ID: W_6pPIz5PB2zzCcRCZbmfw_1795525483
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0157195607A;
	Tue, 24 Nov 2026 13:04:42 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 806FD195B3C0;
	Tue, 24 Nov 2026 13:04:34 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 24 Nov 2026 14:03:39 +0100
Subject: [PATCH v6 5/7] lsm: Add memcg_charge_cgroup LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261124-v2_20230123_tjmercier_google_com-v6-5-dce12fa03ad6@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795525424; l=4540;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=wAbH4N9zRa57tbMNTWC7U/31ALptD+bCYR9IXI1onlM=;
 b=wT8RQTPb+Wx1Kzz+k4N6hc+R0jaP1q2GCdM7dfviV5I7mT0dDpxEZtKSRGAjIxJ9BvRVG5IEZ
 MWDH9f90Z21DlZ26uiD6RLSmRmjIhdDtZ0LuUkrqZzlfdzv7CByHf6A
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 6is49i3TrHtINDQm6RKPnRcRu6yUGyVph2hbu7MsJkU_1795525483
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4FAB4100014
X-Stat-Signature: 44kchwqfinm3up9ufrn4y9pmw6tozude
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795525492-424922
X-HE-Meta: U2FsdGVkX1881jVuZG1Bsdcot2Zd2aQaFLVxlvcRxeJ/fAePPOlByLSP2GqN6rIT55xCDVFr2D7AXdRezyrvlwt6tIlTiCagqJ9umM+gvEIfN25zVFsWLJ/6JQUnVKbhAxTdILOYq5LrL6he1F+XpWLLceHt1aRmB0QrMjhmNo31dczc8ue0VKNqcfxicoI3Vh/1mPDWw89cT5mjmgj387d63DTYbKmLmDoF8HBkXavshhzzqioynHXacjpvqsrWLNpHAHZzhZL0lzjoNKhtlxOAYgijRxhxFe2MIoyr5/CJFgnit682HSpiDkzkMtJu3ufvpoVNzsFPzJ3iHDyW6qt1QxOy9d4nav+n5+BBDg3u+WqMsWKlZItJ5N93JWxiiaFsLvJ8ONkmerx2/nQ+CnBTCsFWk8QAhrKrOur2MA6aY1IYF9F1pdmt7nrJ0JcLlaemayyBpIv6of1CRzRVPpFrT+KIRekkqp2jqpEY+Im6kpu2kZgI5p0tTyhV1tkCOfa6d6cS572Ojra92C+ornW1mP8DJKj6IP64RdU0q2IScgifd8+7YS2FlFWLf1H5lP5zUpp6zuAVmY+a3I3JtvNDLk/yiR7f1fKzOoEdH4bLV/MR4lEsDxbvg0gPIfNHR3kU9LlLP16NHnTL9pNnRP3hGSbsS7XziyToGtzjSTtXrfnMW6nlYuRxN84RKcNqDLqLvwFm6cPuFtdUmbVGTeyzvCgyNih13Y3WkbN3A9+GSmmQYQsp9k/60d2VocHPFBErIXzq7zQ6aBTEjfIM7416ytqKZkk+J1s0gUrJyZSMT+x13zLWgqLqvx8KUpdGygSeq4vu5Wbf5gKmiK6uwYdnqO72DNeSxF8pdkWRPqlTWdjGTxqRRaetigyu79W11fGEu+khvvAQIG+6V0uTxnJoxra24GEbIAQeUHxYMUIu8PADse+2eCoaXDFtDX/M9YXdVlRCfb92Odcr3TG
 tNrKGvfT
 xA/am7X8MZJ6TbctTsmPQGSRRIe2hzaZ/aRQVxS7j1ckrEh3seVG03g6qPoffQTI1qkJrGqGmFTDg3k1m1MDjGDQeT8uizktSIPzSbSTuHUba6FA+HQ8rc6mIj7xKhfHK06IFTCG3Eg6P2kJVLtZ/dmlW1kRj4OSIPXaiW1ElDY6EEbY5u0OMhm8updeRpBRIPmQtabCB+Q1lFMK0E8tu96jLPSEBBSAdmmHGFQiQa4CfrefLC2DtVnVMdoMXtn6sYhiqQDi8VE0XWiBmUgjrReExQMSm5zxSP6fapFj2/FL0gy7ljTADZQLmrfgZayrmpfU/qipOjLOoi9lSkFd9oC90Xhsp0P/YhB3DhAc+BEm0FF3q9j8eKJRvq3FtMiND0+MZeNwqLXjYYf3NUdLyT+j+jlziH0dp/Ui2LnYLp8JeytLXj3TaH45HqLha0Bpv36WwohXLEKOBq9uN5y9RouLKNtMCXgH69bbvQtYGod0SkRH+x8w0/MNTzpJHcPd++cLfqqgppoGuArNUrAQtzMuDuaYYXEMa9hhwfYk17DMT/WZBM37qYU3MFwhRLkb6C/wMiMd4Ki3xEpYNryK0Z9PMovxqUd7x1rybMF9Q3FWS//mfIQNPOEM8xxeT8Voz177xgtXiiSYktqTXYxCTFzQUBoeCsdow+rugS/SkyupRjVBMe34Zt7zf/OKUE22YTzbc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to how security_current_memcg_charge_task adds an access-control
point for pidfd for the charge_fd of a DMA_HEAP_IOCTL_ALLOC or
DMA_BUF_IOCTL_XFER_CHARGE ioctl, we need a new access-control point
for the case where charge_fd represents a cgroupfd.

Add security_current_memcg_charge_cgroup(), called in
get_obj_cgroup_from_fd() when charge_fd refers to a cgroupfs
directory. The hook receives the open file of the cgroup directory to
charge (file), giving security modules a controlled enforcement point
for cross-cgroup memcg attribution policy.

The file is passed instead of the cgroup so that a module can
label-check the object the cgroupfd actually names.
get_obj_cgroup_from_fd() resolves the memory css from that same file
with css_tryget_online_from_dir(), so the fd cannot be swapped between
the check and the charge.

When CONFIG_SECURITY is not set the hook compiles to an inline
returning 0, adding no overhead to the fast path.

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 mm/memcontrol.c               |  9 ++++++++-
 security/security.c           | 17 +++++++++++++++++
 4 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index beb339663d76..72f474596bf0 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -44,6 +44,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
 LSM_HOOK(int, 0, memcg_charge_task, const struct cred *cred)
+LSM_HOOK(int, 0, memcg_charge_cgroup, const struct file *file)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index 6c6cb08bb1c6..69a309919ea7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -353,6 +353,7 @@ int security_capable(const struct cred *cred,
 		       int cap,
 		       unsigned int opts);
 int security_current_memcg_charge_task(const struct cred *cred);
+int security_current_memcg_charge_cgroup(const struct file *file);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -716,6 +717,11 @@ static inline int security_current_memcg_charge_task(const struct cred *cred)
 	return 0;
 }
 
+static inline int security_current_memcg_charge_cgroup(const struct file *file)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 41c81e492007..725a910d8eb5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3223,7 +3223,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 		css = ERR_PTR(-EBADF);
 	}
 
-	if (IS_ERR(css)) {
+	if (!IS_ERR(css)) {
+		/* fd is a cgroupfd */
+		ret = security_current_memcg_charge_cgroup(fd_file(f));
+		if (ret) {
+			css_put(css);
+			return ERR_PTR(ret);
+		}
+	} else {
 		if (PTR_ERR(css) != -EBADF)
 			return ERR_CAST(css);
 
diff --git a/security/security.c b/security/security.c
index 78b462b0ece5..72cad6b1d3e7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -688,6 +688,23 @@ int security_current_memcg_charge_task(const struct cred *cred)
 	return call_int_hook(memcg_charge_task, cred);
 }
 
+/**
+ * security_current_memcg_charge_cgroup() - Check if charging memory to a cgroup is allowed
+ * @file: open file of the cgroup directory to charge
+ *
+ * Check whether the current process is allowed to charge memory to the
+ * cgroup referenced by @file. Called when userspace passes a cgroupfd to
+ * identify the charge target instead of a pidfd. @file is the file the
+ * cgroup was resolved from, so the check applies to the object that is
+ * actually charged. It must have been already validated by the caller.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_current_memcg_charge_cgroup(const struct file *file)
+{
+	return call_int_hook(memcg_charge_cgroup, file);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


