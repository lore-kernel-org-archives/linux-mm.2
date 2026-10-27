Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BE4060A3804
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XoFt7gV8
Received: by kanga.kvack.org (Postfix)
	id 2913D6B07B2; Tue, 27 Oct 2026 11:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2422B6B07B3; Tue, 27 Oct 2026 11:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131686B07B4; Tue, 27 Oct 2026 11:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05F86B07B2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:04:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A8C680A40
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:04 +0000 (UTC)
X-FDA: 85368726408.24.93353B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3E8AE80025
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:04:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoFt7gV8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=p3JuxSBTX/Wiqva9ED5M4Ra6f5VspExZRPF3mUOrSjEMoKHmwvp+SyY+maXeOrEWgZF52k
	ZD1spaIoHKkLvW9My23E8/ZXOX+hEVDXvnWSMucSahXnZ+Ewqo13cb7XMUXXjx/mWzVycV
	9o+qjl7GMOVe6Qk5OOVzsol/uzRPcCY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XoFt7gV8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113442;
	b=Pivr3IkujNnC6YDxHTesp1cjQl33FHUbmcQbdAOVCSMNumTN4WZAquKzxBryiEn6k5gtEj
	n8BCvHx73crHetVfyCdMSJGwNjdgqGWmxADWFNrfFMitt1S4KZRRRd1DRwiLd+1h0YeCEz
	btnupReCArBN2E364xNImHtcPF43kpo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=XoFt7gV821uj8VkGqEsQOD8r+skjKZKkZHqG9h9jOL8To3TzWIp5P3h/7gv7iwKjn/F728
	uEn9BiM5SpO5P6rpozh5LQfEyA4kwTIG+Tu98DJo9EuuOhBw1PACfCYFWnIVQHB8fsXsdS
	/jUD7hDXKbRMhIE9kAZ32DAZMd2ckIc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139---3CqV9OM5-ycIx5F2o9BA-1; Tue,
 27 Oct 2026 11:03:58 -0400
X-MC-Unique: --3CqV9OM5-ycIx5F2o9BA-1
X-Mimecast-MFC-AGG-ID: --3CqV9OM5-ycIx5F2o9BA_1793113434
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A82C18007FA;
	Tue, 27 Oct 2026 15:03:53 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2502F18002B1;
	Tue, 27 Oct 2026 15:03:44 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 27 Oct 2026 16:02:48 +0100
Subject: [PATCH v3 5/8] selinux: Restrict cross-cgroup dma-buf charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261027-v2_20230123_tjmercier_google_com-v3-5-78d2c4cb8647@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793113379; l=2546;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Q4MDTyTx8BDPwFzxJa2XHViMR1+R79st6XMgJZaOlIY=;
 b=Hj2WQDI8Urqih6ZPL5cEqTor42R71JjKsO44XcKO8MNBuBKRjaNUQsnFJxYTOtnVbr8eJeoLC
 IsRr14b1DPMB7O2vs8WMUqE4mDZhGt8UXfAVqy/d3w6gvl6URlTYTTF
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 7SadFO2QJmVa378gBGQAyGAS2akh9OKzllV-D7eqNsU_1793113434
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3E8AE80025
X-Stat-Signature: 83u7zpptmmaegp1641pgegbf13wuztha
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113442-896720
X-HE-Meta: U2FsdGVkX1+ANkv6EPpHHShM/bgsFwyxw0WkvtLi6SFrUBf6NvqChGn2UhNaLLWteMX6NLYR+0o65ShoMDqK2PJhRwBTdBrQ0WaAJyrX4ScREpovYmGQqFsslY2kLkxiH93MMgYiL4em7tlCcr8GQhNF8qFlFgTXaN1AqFGCEkeSokqmOWvGSjZ2SoZx5QGAjxVyIC8Kh8JoT8JbAHfZZvDTEREj/5PY3QouQykWS2VmB172vPnNJqbwxj3q7Rpz5x75ine23ilRo8jaVAjXPbv2i90mvg6kdjk8e6XOAwgiryPsB5KbJ4H8gDRLm6KNE3j9j/qb3BkY+cJqHVLqL/W+8peRCQ9DfTHBHqdBIImKHdMGGfjuugkwGNZRa/JkpTeg5MDc+DuaBUg3VRuV8ten3/xDRNHphJSXa7X7Oj9kgdOMgVIG6n4RmX7JDFeDw/lt6Uz+MdKtY3J9ucC+4bkIsx2BnkYJDsnNHIM9elBzIqddQqqgn5QeifiJEuwnKAViUTQT9Wpk0180q5ScjBkHE/YNilwlj4zO4u/95c2p/MxCJwSH2pPb+SGrzIhO9eQR3+490PIsps5lFM8sEJxMc76LpKAR3fRooBUBu6kxicEB/GqNPxQGJtrNnSw7hiUoNClxNL/PppMYuVwwJ8wklgXOjYTnD3Yc67Q/iXX7TpJrnglGINL9PydzxTHnix/MTHM8yOxENIn20ilCFv/9A+WYKinXJOKgahmN9/eEPjj9nDW5MPfOGoKj1eXzv7MFaqGW0m0fy+NoeZxT0MA9FCP3qVuWmBfraTziFHCNettR2tsVoIHD0xlA9rskVx9PTJN+8DBxlswO5v5x5C72gEWsRBnFiniT4+8EtQCZ/wHuans5woeHcFvi4AeoIJX83CbRdt26/z1budQ992/glpVcmGzHAAJWwmWb9W9B+DmLQaNEwUuFH57jSiFnC2tPicL+ogyie7D5O2c
 4tvGIUj9
 sel7DySW5zsi012DOCMMotWzsaK3vFePE5jW5AoJwnnicuHKboZSwmoKD7u7/9Ak8GBToOi3SG7NlKKi3+3JlybamoBbY2p7nfGIu3VFnFJ/LjzWo1VtPuyG45Y49byp5orVPXvQht1zEZuwglkKSsiEpOGbT6A57TCppZF6tFe5d60YQoXoDZoxZpTSursj2olr5SW2SVAWlHhZKiA3OjBsOrpophvc5N2g/fm0DjLp/+q1l/UMEVaG6DkWwT2rB5DSFzHzakKIlgBdlsdwwJVo8JfgV3yWzZ4osdXUUe3AbG8/MZIh3oGQDfPf+FirzzICM5/HGvMjD+HoHqyZD65GR0SliO1d0AeFKDs7SGtGGX+nXzrjp+YtqebRl90cjjbQ5mOitkziRXzosI0UJINwQfB2BtjgsxmI2WOrN0HLzNo8sOyv4eLbQhAkQqEEycit6BCflBPRPnsBsCi72nXVI+pMp1ZRApZLxc0GGEHza5aEe6SFiyND6bHAX4p6LDw3JcoJNRaZmjgnmPmmMIiX06Nc6fjE2y5DB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The security_dma_buf_charge_task() hook allows security modules
to control which processes may charge dma-buf allocations
to another process's cgroup via the charge_fd field of
DMA_HEAP_IOCTL_ALLOC. Without a policy implementation, the
hook is a no-op and the restriction is not enforced.

On SELinux-managed systems any domain with access to a
dma-heap device node can therefore exhaust another cgroup's
memory budget without restriction.

Implement selinux_dma_buf_charge_task() using avc_has_perm() with
a new dma_buf object class and a charge_task permission. Policy
authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t client_app_t:dma_buf charge_task;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 7 +++++++
 security/selinux/include/classmap.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 30776b0107f2..8f39d91eabc9 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2204,6 +2204,12 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
 }
 
+static int selinux_dma_buf_charge_task(const struct cred *from, const struct cred *to)
+{
+	return avc_has_perm(cred_sid(from), cred_sid(to),
+			    SECCLASS_DMA_BUF, DMA_BUF__CHARGE_TASK, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7674,6 +7680,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
+	LSM_HOOK_INIT(dma_buf_charge_task, selinux_dma_buf_charge_task),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b16425..b4ebedc6e424 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -181,6 +181,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "user_namespace", { "create", NULL } },
 	{ "memfd_file",
 	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
+	{ "dma_buf", { "charge_task", NULL } },
 	/* last one */ { NULL, {} }
 };
 

-- 
2.55.0


