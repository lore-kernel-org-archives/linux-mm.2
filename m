Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED28CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7216B00A1; Tue, 12 May 2026 05:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7A76B00A2; Tue, 12 May 2026 05:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796E36B00A3; Tue, 12 May 2026 05:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6313F6B00A1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:12:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25F58120402
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:12 +0000 (UTC)
X-FDA: 84758201304.03.2F62500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F6AF40006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:12:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PjAD+XWy;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVfUeYXGpNmZ1twceB5woBKhF/qG1sQRttmYc6xeMV0=;
	b=EwR/vVhGNSHwqlREVzQ1W7cYYB3xO322pQcdQMUol5mM687D7LKLisN8Xq/YhFan+jb3Lw
	ijPCPv7Q1xDcS+r4Z4m371h5tKxJWNigVpQFIBme41OqD8O4IvAmUYUwiKqSxUTD2SiNM1
	3/9XLnPFXL8u5nVQSuoHm3jk9W47Z3M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PjAD+XWy;
	spf=pass (imf27.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577130; a=rsa-sha256;
	cv=none;
	b=rsvbvYMBbqTuzYpyjD/XhfqVkhvTdLG177Y/uSs+SAvha6w69P4SJ2hCKNZkCQnWgdvJHN
	AGcbHFA47dy4imft9FEcviOBWFN+G5t6wlSdDF2bXTu9qk0NwFvE01iSHbUDTCBErqMme9
	RmsvRNd0S+B1vBV/FyNCqy24vNMHSag=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778577129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SVfUeYXGpNmZ1twceB5woBKhF/qG1sQRttmYc6xeMV0=;
	b=PjAD+XWyDd8AFdKiMnFpyxhQRdIRoj/GKXKIXMs/OqfDoryNJNWNRcKT9SFRa5wQuh0QuU
	WUQ0Yc2istR694hYId9r8GD9HGyD8UOT1bInHuQrNEijX65Id0V90gNvvjjgYJs2xW9Kwz
	lPaQ+CgBmBV6Wlw14937FW7OFKwmobs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-SICwtheoO2uek4nzuZ0TuQ-1; Tue,
 12 May 2026 05:12:05 -0400
X-MC-Unique: SICwtheoO2uek4nzuZ0TuQ-1
X-Mimecast-MFC-AGG-ID: SICwtheoO2uek4nzuZ0TuQ_1778577122
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 886961800578;
	Tue, 12 May 2026 09:12:01 +0000 (UTC)
Received: from [192.168.1.153] (headnet01.pony-001.prod.iad2.dc.redhat.com [10.2.32.101])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0243930001BE;
	Tue, 12 May 2026 09:11:52 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 12 May 2026 11:10:46 +0200
Subject: [PATCH RFC 4/5] selinux: Restrict cross-cgroup dma-heap charging
MIME-Version: 1.0
Message-Id: <20260512-v2_20230123_tjmercier_google_com-v1-4-6326701c3691@redhat.com>
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
In-Reply-To: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
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
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778577077; l=2526;
 i=aesteve@redhat.com; s=20260303; h=from:subject:message-id;
 bh=tUWRK8NTStGQ1jZHgkmRKZapXQ36MvVDWM78JA0pHKc=;
 b=e6N+YtFKOhQ//Vp4D6U2ohSadH2QnhXcc1X/ddAVP+E3Zk+mSsnQfSYy2rug6ryMvRQbso/pF
 vqSXsycAnyXBDbHh7hAx/7LmIeQWrEfnkUsINWjS+8HNK/1pzGLA2ng
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=YSFz6sOHd2L45+Fr8DIvHTi6lSIjhLZ5T+rkxspJt1s=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: nEifHVFL2BZ1_LLE0kEu1JukzHAMDOWRem3iZckx3uI_1778577122
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c3n8xzudkohe99e9a1pz1ne73chty1n5
X-Rspamd-Queue-Id: 2F6AF40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778577130-596814
X-HE-Meta: U2FsdGVkX1+OlNkd7V365RnOGa+inmWVNl+aUnIXSDnFdbvZlGtidalCGBuvMoI6VOTOJ2tJ3MHsJauwH8IMU4+Yb7c5NRTWt6vKRbNtpSqmb+TMYhTBRDk7zVup3N2/YT2O47aGhwzbRyWiD57PSDzlgO9FvIbAcn3mxgPDMNkVbMITwO+nuDrdpr9ApgqhJBunokXvVJ/Tb4CJCwdk5jU0qEgbwaEI34h6d20RiHfVpBL4szqbbM4YTyXcIaGn2j7/XL3FgdDCNsRlJAxphOxkTA0IQUSItNpMJ4FxVHYcYRePQxmqcqwg00rk71SOxYVcUW8AcERBsqhW9wv/yh4iQP59j5WYQi8SmzwXJWmiEFEAQv1OSP7W/ICD7cmy4cEhhYZgz1zfEzX92QMO4nxsVJSwp8Y7anRWK6Q4R6bKS46i4Bmkot5BkSS+7GgkneilGMV1ISM8UuJiVe3ZGO88Pb7z697dmeDioL+AAAXwz7aWRwKuG4KOSi30xtR7kTMo5u++YFGj2oQpBRGF3a+DqgbH7pVjVQZeGIfV85vXJBZAWmUYj/Y+m36xUXB4/JJMllTE8G6obGcHE6iumg40Fozb/1ES3lbfYblRf9kqRsT9UYYb4EDasEaxEpN6TSY2lboiv0FdOn86eYBCenCF027XPSyOhZGVLY8PR6r1gKJa0l7JMedzcp/LC7H1nxISeV8DkWKwKW6RFl2ldy6i3Flajjp/ZWkGjaH8qoy+hWWT1HBio97sBpa/hcupuE4B3c3F+kTPlVPVdu249+iK/xJm32dTYKHKI4Rv8Gg5d035/sZ5EkQrTuza7TEsNnQwQi99um6PL2qRvj5rDf9/q/ejQpu6+mwWKXodPhPdPemFArxcC7TzVcURFInkhEEBn0JDmLkbWQnKJtYZ3I8Nl/fbXZh0qSSu2G6pwlTo/Epp+Su1ME3A2+CtQAGTeCseSwXyPAucNUffo+o
 z6qgL7yX
 MOasQ8EwOSanJdAhI2GOi6hDwWFDPhAPLDseS9DmkaNVoiWyLyuAa1F+QqIt7jNmQ22Zciyjods2lLyNfid4qHaj2ZZVTp80rFrPFWzdbMIxv+tkXkoWUumqJlkBkGlOTXnAw1+XveQh66T1aDH9xGA4nKS8CUE8YrcDNeJvSSag0Nzeheahvfkt8GoF2wz8Gtr6jME7y6VnQlAhqvYEhX/JtjarJrM/QXS4EWb3DTyQgoPPL30fsRDhF1znnldfWdx8HopnkAZfMKAxLwjdF+ab50tTi80cnAlmumUr4hVcEki9k8bWRXSATlKo7iQc3I6MBWnJzD91rSgNs27moN2bBeSg6GQjHOTuLmfBSQ9ePjz0AybO+31MboU45DutreD4DT4RKHWBX39X2oV590clysDha2KEeQqDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The security_dma_heap_alloc() hook allows security modules
to control which processes may charge dma-buf allocations
to another process's cgroup via the charge_pid_fd field of
DMA_HEAP_IOCTL_ALLOC. Without a policy implementation, the
hook is a no-op and the restriction is not enforced.

On SELinux-managed systems any domain with access to a
dma-heap device node can therefore exhaust another cgroup's
memory budget without restriction.

Implement selinux_dma_heap_alloc() using avc_has_perm() with
a new dma_heap object class and a charge_to permission. Policy
authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t client_app_t:dma_heap charge_to;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 7 +++++++
 security/selinux/include/classmap.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0f704380a8c81..ea1f410b9f619 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2189,6 +2189,12 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
 }
 
+static int selinux_dma_heap_alloc(const struct cred *from, const struct cred *to)
+{
+	return avc_has_perm(cred_sid(from), cred_sid(to),
+			    SECCLASS_DMA_HEAP, DMA_HEAP__CHARGE_TO, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7541,6 +7547,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
+	LSM_HOOK_INIT(dma_heap_alloc, selinux_dma_heap_alloc),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b164256..d232f7808f6b8 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
+	{ "dma_heap", { "charge_to", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.53.0


