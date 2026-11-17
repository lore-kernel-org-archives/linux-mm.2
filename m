Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E7D606A8AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PptqSAkv
Received: by kanga.kvack.org (Postfix)
	id 6D73A6B05B9; Tue, 17 Nov 2026 03:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687D66B05BB; Tue, 17 Nov 2026 03:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DE16B05BF; Tue, 17 Nov 2026 03:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29B706B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEE4C1C39CB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:29 +0000 (UTC)
X-FDA: 85443964578.18.2EB6987
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id AA8B2180003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PptqSAkv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7W5OA0Pfbz4DWlJkfLR5cfYObFa/4T5Fl7aOVgxV27Y=;
	b=6EsQqhyIFvw4vEQfQ4U1Lq+W8d5fIdR5l3wLZ6b7DLkHiMhPpAwDKfmuhp/5cqZrnR6CvA
	234AkZXrAWglXgW0R34Sc8wpJPAUdzPyqGBm8i1RI3cLGsoQRcxN66qmxYH+9JE02ibMWk
	tejopIWD66qFbJ6xxi35LTnklBa7VQE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PptqSAkv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904827;
	b=P6joHKi+LeU9NckP21lOBjaatm4xo7ubgmjh+4/ylB6hYAeja08y/I520mFsDsp+y+BLyF
	X6JG63uodZTcz5LxVeaKpKeK4JFBWt2di5IgiJSNA6hlMb7evBQvufp6cuWz4WMbNOyp25
	sR6IXNm1Lxg2kFD5oygS3fEbhm7gy/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7W5OA0Pfbz4DWlJkfLR5cfYObFa/4T5Fl7aOVgxV27Y=;
	b=PptqSAkvTI+VoAH09OtRSM3DcBXaZSpnvzFrYClOC8aDHACJLwWZ+qxOm/Z+klrMpjWCQA
	EpUWiG5zKIq2tKhJA9w7nbABsnHGjtG0bF4w8g/s+842qUViCCImelQMK7Ko+2eroG98AX
	5SFMIfgsy0JneZxiUbRo4gQOWXGCDv4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-MmJI-5eQP4ytDa1v37736Q-1; Tue,
 17 Nov 2026 03:40:23 -0500
X-MC-Unique: MmJI-5eQP4ytDa1v37736Q-1
X-Mimecast-MFC-AGG-ID: MmJI-5eQP4ytDa1v37736Q_1794904818
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41F481956069;
	Tue, 17 Nov 2026 08:40:18 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52BF31956047;
	Tue, 17 Nov 2026 08:40:09 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:20 +0100
Subject: [PATCH v5 5/8] lsm: Add memcg_charge_cgroup LSM hook
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-5-1ce975f2a9ad@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=4811;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=YRGBhFlRTNQesmC+53+mQbdidsg9pxvs3IaHY8atbxE=;
 b=fR/PjTXILA5LyYPNu/ieXF3ZRz0p6iADYUtxuVFqK1tRqToEfnvX2KwPchBPH5m+5SN0ZyaDG
 9BKFzARlj9EAUEPaiTvCvkWTrbM5E9dAbj9bDBZOT7GuinwCoc1oqZF
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: uYEzG1fZXN3G1jvRBwTbs3tfgj7mk-q0XYg2ctdo084_1794904818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA8B2180003
X-Stat-Signature: 59y91zpdud3jwwsonorjz6oa8t5yo6mj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794904827-667884
X-HE-Meta: U2FsdGVkX197EcKw8g6rmQUG1ojtlt7gGwbfdHtnaAb1gVGJ1uNBYLhPiQx+qCZAsOwlzzvlI2GLvcX0EdHoakVYTngOpzWVCeygdaWVfe2drs/5/s8NHs/K/KgvGoeR5k20StknFnW/87ybzezh/3mBeZ+QJsVPQIrJGKtqiJuA9SnM4wzp7B+Twzg/gNrflmpPC8iYDEMtE43uE5dLI1hRAS54iZrCt0WHEJcu/h166YFAy0xiwFef8/uDBi1QwajVCxlOzqb5Fr/zv92mmOH8vjcc/Q2XaJ97p2y6p93gfqHPoy+nZgFcAZ53kbm+Zhlcx36oX+2Z17xQfhleB70pAwsfmrxCtAFjip0fGvjfIoBDWxRD26R75Uet/VPxD79JR8mXLcxtBrKn50uDMZrf+YXHMBvngWmi49AWjPqzxnf3F1KNp9ofC19t3U6ywW3t7nX0Idg9frIRtPmCDIAsl93ntmfu45FJ3fQTR4GKcoMtkAsyPqaKGykQFyZjeE/LbLWzLP6sQZzrYwJzpl+VogNUQaCkpyVqef7h69y3LeJ2optS7Ez9VYpKNDndwBgPAb2mIAEimGTKkOx8XyjsHRyta0+urJQqMHEafEIVn6x8lEEtc2hBc9Ps6rI/AFUpbCqt3C+5dOT2+hp08Gi6/ioVgay4iOA2OaNEDaPr+QkGT1RmuonLqcdISFkM+Qs0hEoFrK/XfesTKKg1U/WeiLIBQcqbMJpVDbbeWWTLgBJ6IJgjv0HbqYVIw477g1kF6JdZ7xXbH6U0c6heN342tkno1y+9rPerPHV73zt/WXAIOpaeF/x7tLRliq+jyYYXWgNGnRB3eI62YTkju2tKv0DgWslfpDDdrOHKSWiSxxaIkWjDk6n7KoxddshtcyZUaLckBi5YdSKTt2UK9hi417hxLBbzKWYSwUA979+EhBSdyDeRsXO1sAyC1X4dhuGNxFnE6IGnwZwxg0l
 WoKTmICD
 Ym5EB0rD8ddqzO7Y9FMRuWd9HdR9vL3YoxFdN3Dx+TzgG+XJJGUgXfeLj4NP3Drrh1eOaoIZdeOTmIcK7gt5O4JjDdXMnxb1dzNM2weNjDYD9BTpxviIZ60LsCLkuwmeGml7AMLnCCvD9W7hY53D2bNKXTt+x1GtXxyDq81S4VJWsKqz8O0lQsnwd/gHs/7ypecysK6fd5eCHz+SDzHKFlfBF+CAwcjZFGt77n9et2uXXr54xUN0rOhScCg195ZgojxfEV9CUM9aRi/twLWSLvUONT5WLjeye62ymughbsGnd8E0iIfTIlZ+9vj1nXDhu/mejjoo01NqlQtCSaQvZDGe3yo2W6ndguDsA83t68rQAZJoK/7SQ5SVxeoqTm3FALeWQpNxKu+rUmFQ5dgHOGgNiiiAdqbos9VTp6X1PaCMiTtP7zg4zuo1hvK53NCxvyAVUYPiFr/dJcB1V0JCFrVWa1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Similar to how security_memcg_charge_task adds an access-control
point for pidfd for the charge_fd of a DMA_HEAP_IOCTL_ALLOC or
DMA_BUF_IOCTL_XFER_CHARGE ioctl, we need a new access-control point
for the case where charge_fd represents a cgroupfd.

Add security_memcg_charge_cgroup(), called in get_obj_cgroup_from_fd()
when charge_fd refers to a cgroup2. The hook receives the credentials
of the requesting process (cred) and the open file of the cgroup
directory to charge (file), giving security modules a controlled
enforcement point for cross-cgroup memcg attribution policy.

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
 include/linux/security.h      |  8 ++++++++
 mm/memcontrol.c               |  9 ++++++++-
 security/security.c           | 20 ++++++++++++++++++++
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 93c8bb5642f5..3b254b4e60ec 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -44,6 +44,7 @@ LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
 LSM_HOOK(int, 0, capable, const struct cred *cred, struct user_namespace *ns,
 	 int cap, unsigned int opts)
 LSM_HOOK(int, 0, memcg_charge_task, const struct cred *from, const struct cred *to)
+LSM_HOOK(int, 0, memcg_charge_cgroup, const struct cred *cred, const struct file *file)
 LSM_HOOK(int, 0, quotactl, int cmds, int type, int id, const struct super_block *sb)
 LSM_HOOK(int, 0, quota_on, struct dentry *dentry)
 LSM_HOOK(int, 0, syslog, int type)
diff --git a/include/linux/security.h b/include/linux/security.h
index b21823225ed0..d1cd6c324ffd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -353,6 +353,8 @@ int security_capable(const struct cred *cred,
 		       int cap,
 		       unsigned int opts);
 int security_memcg_charge_task(const struct cred *from, const struct cred *to);
+int security_memcg_charge_cgroup(const struct cred *cred,
+				 const struct file *file);
 int security_quotactl(int cmds, int type, int id, const struct super_block *sb);
 int security_quota_on(struct dentry *dentry);
 int security_syslog(int type);
@@ -717,6 +719,12 @@ static inline int security_memcg_charge_task(const struct cred *from,
 	return 0;
 }
 
+static inline int security_memcg_charge_cgroup(const struct cred *cred,
+					       const struct file *file)
+{
+	return 0;
+}
+
 static inline int security_quotactl(int cmds, int type, int id,
 				     const struct super_block *sb)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e6fcbe14d43..693f0b2877bf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3220,7 +3220,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
 		css = ERR_PTR(-EBADF);
 	}
 
-	if (IS_ERR(css)) {
+	if (!IS_ERR(css)) {
+		/* fd is a cgroupfd */
+		ret = security_memcg_charge_cgroup(current_cred(), fd_file(f));
+		if (ret) {
+			css_put(css);
+			return ERR_PTR(ret);
+		}
+	} else {
 		if (PTR_ERR(css) != -EBADF)
 			return ERR_CAST(css);
 
diff --git a/security/security.c b/security/security.c
index e198e00b6a40..925b6c003059 100644
--- a/security/security.c
+++ b/security/security.c
@@ -689,6 +689,26 @@ int security_memcg_charge_task(const struct cred *from, const struct cred *to)
 	return call_int_hook(memcg_charge_task, from, to);
 }
 
+/**
+ * security_memcg_charge_cgroup() - Check if charging memory to a cgroup is allowed
+ * @cred: credentials of the process requesting the charge
+ * @file: open file of the cgroup directory to charge
+ *
+ * Check whether the process with credentials @cred is allowed to charge
+ * memory to the cgroup referenced by @file. Called when userspace passes a
+ * cgroupfd to identify the charge target instead of a pidfd. @file is the
+ * file the cgroup was resolved from, so the check applies to the object
+ * that is actually charged. It must have been already validated by the
+ * caller.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_memcg_charge_cgroup(const struct cred *cred,
+				 const struct file *file)
+{
+	return call_int_hook(memcg_charge_cgroup, cred, file);
+}
+
 /**
  * security_quotactl() - Check if a quotactl() syscall is allowed for this fs
  * @cmds: commands

-- 
2.55.0


