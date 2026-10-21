Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6658360A5BCD
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Vj4DRcID
Received: by kanga.kvack.org (Postfix)
	id 8009B6B0734; Wed, 21 Oct 2026 11:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4F76B0735; Wed, 21 Oct 2026 11:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBC06B0736; Wed, 21 Oct 2026 11:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E82B6B0734
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C47DA1605A5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:41 +0000 (UTC)
X-FDA: 85347053442.25.D79F0CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B02B5100005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vj4DRcID;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597419;
	b=ViRnUUxDaL/ofCvcR5bVie+Yoln2jNGRyn7UFVBTEwq1AUEQ1EjrR6SGRWkxg3iZN5QZ4T
	uiP+AfwDI8dfXC/GpNoZHRjQzI9k79swyIhsGl2Y8DpwXKVBw3bSgQXWM5oqLBqpbuWOiO
	mdQnH+g9FOtSl5O8Kvl4ebV59W4sjgQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vj4DRcID;
	spf=pass (imf05.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=18E/hSDHuIrvF8XOij21AR15AVjOtUcTl5kakpth8jMGxQfLEmuvr4jcvuk0Qyx6VG3ERv
	h6OGK3SkFVTn5inQgpuEQ8qyqeV/6zslFHBRJm/NW3gVyQJ2vVwUpCsqAMuqmrwgzCSYLv
	VBjon5F88aae6S6VabwnKwjqIlIzFFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIN2xmkcrM6GUForywfj0SmUMjhlUpfCv56D4umJYig=;
	b=Vj4DRcIDMfuWYsAXKswbyzIer++tEPp6ae2kehkAAslSozKhWvyWXVN0qa849ws77HuRtG
	4jscxL6ES7yhZInuGMNSzssK0SsWohanTiMNC6S+2rIG/Li6K8IR7tUWti1e0kM+d3mW5z
	kvVL5+iJRij0b1h8wuRtW+ZE+exZ2v8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-wDBZPeUZOxGRl__DCtwUSg-1; Wed,
 21 Oct 2026 15:43:35 +0000
X-MC-Unique: wDBZPeUZOxGRl__DCtwUSg-1
X-Mimecast-MFC-AGG-ID: wDBZPeUZOxGRl__DCtwUSg_1792597410
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58E911800578;
	Wed, 21 Oct 2026 15:43:30 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A5751800480;
	Wed, 21 Oct 2026 15:43:23 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 21 Oct 2026 17:42:26 +0200
Subject: [PATCH RFC v2 5/8] selinux: Restrict cross-cgroup dma-buf charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-5-ef6ee2dd8c5c@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=2546;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=Q4MDTyTx8BDPwFzxJa2XHViMR1+R79st6XMgJZaOlIY=;
 b=tDWPABumh8zVFpLL7LPjmRC9KfpiXTDnEpOD2xwgsiun8v5lOm/DwV86OfI8pRNpG8rfgsfOU
 LBY2q4iwqE5A/ROedWdus7ucF/3eMED6PEZhnoUzFbYMVxCBMAzWaLh
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: IcgtW-CBI5r7FXM5CyaY2x-HdAkqMEraus29Z2xKXxo_1792597410
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B02B5100005
X-Stat-Signature: 8rgafhimpqr6s9wcf1yx64h1o6j97bo7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792597419-483207
X-HE-Meta: U2FsdGVkX1+cvG10Uko7OABkbz9D660RfRPcACBQElASg+UFgPFVscFI58dpAn0umhMlHCuNTZsR88b9TRT2WgjHr4via3toI9x8zHBiNo1n9bu03VMzL1k29aSJKREl7VBy5f0RE7c/FcqcqwJxZUkZ9m1kAlZvpY8X8E5rpKxd8YMi1Nzz6fQS0l8NVrE1+U22XExALJ1t/g51noi4MHGT3PsRqPR9JHok0t97ezQxcq3bsF1U2Sv9gCeetsOE0BfrL6cqEG6Tdg4LX1PkODr8zOsLU/l2KkIGRQmth7V+IBjMxz85p6bJYFIq/RGGDV71M+MwJdJQsfR9fMK5ZLHTR6x7fIC1lwMNIuruKyApBiqJxENjOlaaCIOVBc4EeefFpIBvLbtWMFNCkbQL0wxRDATH1nkSYI/YykVWloQ4qk2R2MABDAh8Xh2aWMsZQQQi3NAey/CxMh70w3eWVJG23Fi66kFGfjfNrVUWNtb0+tgLDRaUK/IrnL8M+lhs/zMhi3rxnJGZ+BYa4iSTXebfV0uMXt/eA31aPNRHyOwL4u74QySJPEOlIdOaa+lKFO9cCxTJa9g3vCy3MwaVkEL+aGuZTl6iCbosFh0ROsZrut8UZz4NMwSf2aI8TKE8bRia+jSEMqEVeBioU39xtJfVtE0DBPqYTLfOVrl5rN6eJh2pFf84kM4WjiTCb+E8/x4xeNz8EfxySqM6X8YPuaICGDQVySxnWCJMwWnbYKFWW7yZkM7TggBlIjKOEVAKHCECNAb0xJTrpxl9Z7ZunGh+7EMQKAKAhitBL3o73Pz+JkOM8AQhfoqYdxT+W99nuP6LNJtHRwz4H885t422Fu9V1P6Y/lsDyUluV7LeVZxtUAp0z1sWQmthTpknUfZUBPufGN9L+1Sr7VPRtVyc3m595gzbj6mghkpy5zzOHkyzlV4QUEDSWqMx1JTbfhM1tazOmvE0Blx1QfA/EXG
 Tm4C8eZr
 AQS3UqYF1Qk1xcG974tt4Rn9Tv17K+7fmRC5GKbVWmjQ5zlzMPPNZq0KBshvhF6tn2+kv9apqRqzkr7JOo24cB6RbEYXbWMGFTzdQcv8vJic4GL9jBs9aVw+vVEfiOsmMtiMkfvv0YGM/wKcWzku1JcrQLE3ln7OoemsiJjQLvViwUiYVIJvmDWa4dGh6zJJvs+NgYDRAucUQui4pKWqfyPwoooaO9z782c4z8EkI4ndtjvw9MNTXdWn6ND5gPtwfF005kqUMbUHXBhYmBn3JWvGpOqs9G1SQPPoWcQhV8PdROmWAy9K7t3F9NoD3PJG/wLdADdLz+b3ni2A0YHKPymmMJOnOD77m0V0xEVQCqbr/n+iKNvse2dyuoTww/RLdPIehJi9nEZg53oOdhlDCnGMnNlQ830H8r7vK
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


