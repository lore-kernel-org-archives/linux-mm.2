Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D94D8606D832
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZFml5LKF
Received: by kanga.kvack.org (Postfix)
	id E1ED56B05C6; Wed,  4 Nov 2026 06:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF686B05C7; Wed,  4 Nov 2026 06:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE176B05C8; Wed,  4 Nov 2026 06:10:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0926B05C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:10:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12C48C06B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:25 +0000 (UTC)
X-FDA: 85397168010.08.CF7E214
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D601120004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:10:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZFml5LKF;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=aD/qsAr0mdlaMer4FOp6lPv31c/wskwssbRB1qCRgLPGYLJToaqP8tpawB8Xlzegv4iHI1
	e45MlFIybsrKsVc3DgxF2eBh8Q9L4UbO+zNXi97SK2/XC5kMfoQ61ojEnxkXNM9cJDydtI
	DJU1Q7R2rEwtgQpOIhEd2v/msTNRebg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZFml5LKF;
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790623;
	b=zycxogZsy73sxhB0z6s2xfTHvrZF2G/0+AEnN92c5CzQlj7xlPwlow7zP3QTY9j5BVCroz
	uvpuNj0umnBWnevkglgxmXd+EEGSryvUhUmK3CAfgUKFpVQdBK4l6JNDO/UHjCempUS4WO
	OztXwhhB/MOqxrNt0EmUGIkfFgXwSec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793790622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=ZFml5LKFA7gL6WTZntaXcHBoP6fBGDhAVaAJtDT/sY1Xftr1012dFyIQDh348x9YowbWU3
	/CBvozNxETROyP59S2Hic9Zmc/jQp4ag3A+xQxDfpety1oBmXkIFFzf5zw8D9fSMZFZTYr
	utA0+dhF6S9v1G6EU870qrqBZccXdyE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-360-9S7ZHpiTMa6gjO6GBpoBsA-1; Wed,
 04 Nov 2026 06:10:19 -0500
X-MC-Unique: 9S7ZHpiTMa6gjO6GBpoBsA-1
X-Mimecast-MFC-AGG-ID: 9S7ZHpiTMa6gjO6GBpoBsA_1793790615
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DB79195605E;
	Wed,  4 Nov 2026 11:10:15 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A7851956041;
	Wed,  4 Nov 2026 11:10:07 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 04 Nov 2026 12:09:15 +0100
Subject: [PATCH v4 6/8] selinux: Restrict cross-cgroup dma-buf charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261104-v2_20230123_tjmercier_google_com-v4-6-1819a017000b@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793790554; l=2546;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Q4MDTyTx8BDPwFzxJa2XHViMR1+R79st6XMgJZaOlIY=;
 b=REHM6F3Ku6uuvIdOxBXhrumnTAmUHEsxlCmUVbJB/ZvhOPELqWlxs0TEKjvh1a2rXfDxv9T1v
 E2O5apaN0Z8CytDrQW6kkXw69Ocb+i48IvcsvH64xCPhTw9c4BZmhSg
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: GvDA3yS-JVxWRGFSUoF1o2y8BQ1ELXQeTSDHB30LwyU_1793790615
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aho51nkg7nd9d86w99sbr9oqh5gyfyzk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1D601120004
X-HE-Tag: 1793790622-384056
X-HE-Meta: U2FsdGVkX18cK0Yu+9C6oIyArIjQNy+BK5PaT4pXLFr48ClRhZ02PEpU23HyTv7rkKwRU5skw0cE3+XY0fbuI8RyRUwwAPw1ajbU/q/mCdVUiffTJ163Ozi58mwSN8NbqKLKVZ8DKGvJV7Qa/eYQMSzqH+wv1D0lhhW6DtMvhCsfUKR7OiVQFUt1jtqdWMi4wVZH0YLplYC7AmllrmQ2gJI2Ism7oIYYP7J+qCqv+UiumW6or2bIg7e9K6j8xajXc1IEN853uQ25nUhSdGXBNUXqqIHz2/LdYtcuHaP8pHMd5Dp0bt5/KmvUgDqz/9LASSlbgEONyAmbqxIzPZjNiq1ZPpc+aoUmeYs48nVD/pjAQQBHM8esBoVw+XNgmNsP2u2Tm9fWI16kbzjcTToYRut7/jcFRd2aqz/qhF8wR3JsWoTiMycF0M4MppBioWi+pPw+vdpZTG6SnBepX9P6K7RGomqG0sBirhkhzqqZHhF19TGdZ31LKjCkwgrBQmOM3n71JIHNWgck6Qec+dumTk430rSemy+jLKcXRnmSvw3Io0dyM/v9tc2rVPMRfbaMfvcw3CTJFvyH43ZXhBOHBMSl6yYjWnSUBlQIN/orcNgek2LlvJPdDtY5ad9U4S7efW5geO1U5AiL0SQRoKLPZ1z9+qqRSKBVgQfgYvZNMHLolRi+vP7zm5jT4Hkkdhn4FBDXz732SipPTIwLATaZPM3OQqg0LZYuvGxXli+9NuG8a3ti+qmblX0bcECUtIvSfQfxjjq3k9KrhTmwQ+XWPVisfQtH1sELf5cq246SjXMUeiD0mHu7Soy+JN/6w7zJuIguZCmZUX/zpR7i2Mf3UnSg7n+II6R2KsvD0DMSYNFhAZV3MsGITn9HaO2gkYVxPp0kbJEQqnxeYQ18+M2NLFWXcEl1YllSafyF69EFDCO/IduGA3NtDz2lJc0d0zaT/coEUau0xQ7AkQwp6r9
 ODpIF0r8
 mbl3avGtHUpEMPew/Q5pLLOq1ovVtWDxqHABp8Gxls722nb+4trL0z2Usi4jgHldo+qgKDIjj3UnZCSHmFvV9CpKgP6GgIU/V4+aWFc9NKkTmWvHYnRHDYPSKs86Q4oPLfNaJzjvx4n1dyPK6ytXy7si1GJpxF5qz78tZL3qlCpD2So6WKDgjWEhrGx1YEZ8Yr3U7NYfUeBtOvuaS0HkQLnKcB/1kuby+hTC2FrxLe2Z3AT9F0OAh+PJxJwpJLbtw+4ZEh1zUXfvIqm/4ih8Y4Ya3jYQ3ADMbp/GYW9baYBYxFeXpUibIME8ZNwg4JEWhn97rYcUfbhGDFX8SCGKtQqlSNt8Mt5GP6ngLu+W6IF3Ln8qY5PFrqZUNSOaO8YO9C6JrEMKM80dPIFzLjVlpzCeI64da8pnYzoOObtGAHPISUSGf+hqYlM4tOUMpjZQKIfvEeSRYKMCoL3N4EEzKoThB+TM5UmFIhu+jF7z0Fhw1Pkz+7MpV86e0kcEOE+ebpYrY9VPsVxIPZSfmHpQh9ZT2kLGuv8cHL919
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


