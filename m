Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F6F606A8AB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JCSNIjXg
Received: by kanga.kvack.org (Postfix)
	id F3C6A6B05B4; Tue, 17 Nov 2026 03:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC866B05BE; Tue, 17 Nov 2026 03:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03066B05C0; Tue, 17 Nov 2026 03:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAAE56B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D5BC80394
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:48 +0000 (UTC)
X-FDA: 85443965376.15.71C944E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D5E040004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JCSNIjXg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8T2YTuRyEX/0VfWO4yPqqkiG+xS9fKoxRnvGyNVhaM=;
	b=kyHECNZvk9IVd6s6bAOPJRzP4nYgxgIOkXHKt9BVnXcVwcA4rAb03mpudoX76zNnwiq5AS
	YE5aS+HrKTi2NOByPlomALQK12PTNP48Xa8+DYxYU8kB7J1tYsq4gkzYhmHxfTJnVbIJkW
	f5tp+Ajk8OwXzwXHzBDIBw4WXsAE4a0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JCSNIjXg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904846;
	b=h7DrC0S1CoqmvfljwFZU6ACrw/pY8zvwosz2zMvApUHdEMNcM6fOQ0BoyXyzSXDA9WKnew
	2T5XNju2RI2mlSJYet36EdkHKMD0urpx5QKN0N1WfpgfM07LcLGA511dU/YPBblous6S+q
	qjJtFFv8RPaktOXleJbwSyI7bC4dNTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8T2YTuRyEX/0VfWO4yPqqkiG+xS9fKoxRnvGyNVhaM=;
	b=JCSNIjXgf7y8nqpWx5Kxrm6dxMTCjImyjbMdnCtdzKA+YGDv90toAHM+z04mDzAMntwDDE
	sjTGiDH+8CvrQXnCZB+g9ln0H6AoWvaX55ek+Y2lXINDX2/S4K26n5VCLmOZB3/ZR6Boum
	JJ7ID2mS/Ji0GLdEIAyB4b7FUffAFos=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-Q2FCIl06NGaUlQ43OLoltw-1; Tue,
 17 Nov 2026 03:40:40 -0500
X-MC-Unique: Q2FCIl06NGaUlQ43OLoltw-1
X-Mimecast-MFC-AGG-ID: Q2FCIl06NGaUlQ43OLoltw_1794904835
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F0051956044;
	Tue, 17 Nov 2026 08:40:35 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E90CB1956047;
	Tue, 17 Nov 2026 08:40:26 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:22 +0100
Subject: [PATCH v5 7/8] selinux: Restrict memcg charging to a cgroupfd
 target
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-7-1ce975f2a9ad@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=2824;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=VU9JS/7b9umA1xjNeFGAy8OTH728tWaENZrEvIFi380=;
 b=WJ/NRNZ0clCcqHsM69AZm5u6JI3Y1CpT9xAoxbUi4Z1g/LGgIZp79SXZD78+omqrrsZ92LR8e
 GURUikdfxDfCUtfZAbNOXe28JR0RIasrR2E881uGmm1NTY4kx3qh5Ta
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: PnhI__WWi7ZhXKPBBgZrEB5e6sERx80Et3bxmUrOuZo_1794904835
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D5E040004
X-Rspam-User: 
X-Stat-Signature: po5i8bi9yhwem3qh485uc3ebcodjzw1i
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794904846-154402
X-HE-Meta: U2FsdGVkX19HHZRKQaOCvmuXVYf3nGykqqtPJyEslM0rfVAW7vUKCDKjVoGhz7MTyWQ5dyzL7KPh3b3RCXDkdRTDHJFqoNjGzqufdttDUPBkFQgZvnpFTv7yAAnWOD4e9isYFpcNCKrrbyjlUwzHRRRhQ3JO3zQ9jdy+3j0lwj/PfL332e6lVYi0uhmSidejX8bHjfGj4Lh7tWB1x4aRih/v6OIhjCkJT3ECpnjV2KUkYX5v+Pz/Y1u9wltJ5lwhjDMtjZvjYli6eOD4u/tYJLgvjrlU2YutmkJ2LcZ8cT3/CAda5FSnpOD9hcoC49m+Oz5/uF0VRrCt+2d9GxhZ6r73lARzCQIDuhhdNYI20K4V05ug2C2s1J5Mzt7EP12Vt4yky3DxkGWUg/aiw4gXUdBR5OgggSl44aKF/XJWTKcBfO5PQlIdTxzPWOBO0LDOihtyQnlaYc7CLXfKp6HvMjiBRjIyGFNvkIktnmSUuhPq6rEh9luiZMHuNDfLHW1I0vhUlnvVBiJ0cae//k2ILSCOQxTVdBjxP7zcgntpnaNrjGSGTONAIjcFOduKegCjcaX2iw+0OJ7F9wf8bP6AbonhF5DA9FUNYZeWvputnXrb8MjiDwUdccxgvbSgtrJyT0+Q+YwcQIdpmNcJSVCFE/2QhTLkeAA1+gWTMFriTEeTV1AV6Qjn49i7wDoNqt13q2hbRnPZQB187nPYqeOTBprJ9N/xmGvqqQ0wxxa/bNVQgFOTED46rnNj769+yYPsXGmGRsJbH3seHmAJdD7l0G8Ogn/44rjuMSDffF4Co33vU/M8LmmVnpcE4a68jvyRYPWXI2FsrrEFOVT7NmI7dFSwnAj2iOU2c6ZJUioNIrsc4fuIjY7234cWcPRqK9neEmRDqibmsB5hqAHKt1n/RIec7GoUOMD/si/WTGTHIRvJ2vSC9RkGD9xQ/GQx8EXP6g6TMQoNMB8zPFcU5kQ
 e7tWg5Lv
 UIrx+i9PPyIi+klb+KcCwuwLTpABSxA5r2cIcrydJtqvfNikNQekVWBt4MYusuMdqaGE/It7QORPGUq8siZbH29w7RtHYojs1iXjd942T/MCGhgW/W+wWCf/+zLkRuwdXUG/5V1s+2E/+SmdMcWiSmzbc7GQX/ZeY+9VbtfUQEsJtVQw5yxw5g8UlroVKtZnnj9BVUgFaMhi9W82aSDggOSnmviaa0TjbC0FVVEPX+z88E9jwElqUW0yij7fuu1Tafy3On+tJou1poAVTl0gPOs/P23vnfBDuwehR6AYR5CpT66gkHl8wfaZAYsU7YRM6oSU0288Mry072l9ET7ZxeMqjG8kuIzipSDv/J2VTobPl+rNn46nNYWQLvYZpVMtGcVOG5IJ06B1lmmundq/ekjdfoKgThAO8lxML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The security_memcg_charge_cgroup() hook allows security modules to
control which processes may charge memcg memory to an arbitrary cgroup
named by a cgroupfd passed in charge_fd. Without a policy
implementation, the hook is a no-op, so a domain that has both
dma-heap access and CAP_SYS_RESOURCE can charge any cgroup outside
its own subtree, and SELinux cannot say which targets are acceptable.

Implement selinux_memcg_charge_cgroup() using avc_has_perm() with a
new cgroup object class and a charge_to permission. This is the
counterpart of the process2 charge_to permission used for the pidfd
path.

The target SID is the SID of the inode of the cgroup directory the
cgroupfd refers to, so access control follows the cgroup filesystem
labeling. Policy authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t cgroup_t:cgroup charge_to;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 10 ++++++++++
 security/selinux/include/classmap.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 70de6094b2b4..fcf0b03a588d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2210,6 +2210,15 @@ static int selinux_memcg_charge_task(const struct cred *from, const struct cred
 			    SECCLASS_PROCESS2, PROCESS2__CHARGE_TO, NULL);
 }
 
+static int selinux_memcg_charge_cgroup(const struct cred *cred,
+				       const struct file *file)
+{
+	struct inode_security_struct *isec = inode_security(file_inode(file));
+
+	return avc_has_perm(cred_sid(cred), isec->sid, SECCLASS_CGROUP,
+			    CGROUP__CHARGE_TO, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7688,6 +7697,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
 	LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
+	LSM_HOOK_INIT(memcg_charge_cgroup, selinux_memcg_charge_cgroup),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 4004c05aae5b..32dd95de509a 100644
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


