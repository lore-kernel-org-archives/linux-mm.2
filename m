Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DFF3606A884
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cEKHEsRJ
Received: by kanga.kvack.org (Postfix)
	id 725BB6B05BF; Tue, 17 Nov 2026 03:40:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDB36B05C0; Tue, 17 Nov 2026 03:40:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613A06B05C1; Tue, 17 Nov 2026 03:40:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A43B6B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:40:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1CCF1C233D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:39 +0000 (UTC)
X-FDA: 85443964998.15.730580C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id C8A0D80007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:40:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cEKHEsRJ;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904838;
	b=nbK/WAT+7bKGQyq6WnigczclvbCXuGqn2E30NOwwTK/8C5YU6F8fOOb9/6jAyz+0BLqzPF
	kN8nHEQvnE9qyx4Ihcba+o1FQix0ae71kWsWli00ghDf/nDzLZlepLCVMDdwo8+NQ8Ji8o
	CjNECGz2/T1e/gpPrden5D7TvyhLi3U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cEKHEsRJ;
	spf=pass (imf30.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXFgoHEW1fISPqx+DguPFuIqzmYDTSmejmjwwKMoL0g=;
	b=oSH9oSAj8E8Mpm+33G1BRA3EHaHv8wNOyHizxJVy83O0wy/ZcT+PSviNrw0OkTQqQbHhUf
	kfHZ7NUcO7HJ4P5bURuJPWOSSpW3tUC+1keUHQ1rbCQ4P0KnOV6SfI77aYJDLB9o4jZBJK
	2deHyltoCggKDeblBM3hYeIvqIrziuI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794904837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yXFgoHEW1fISPqx+DguPFuIqzmYDTSmejmjwwKMoL0g=;
	b=cEKHEsRJQ0HahVglj/NoIP5oib4xURYx+csNP4JYYLoglCQPIkBLSCv3VOUPbsfBZdgUxB
	/JBNfMgsOJfQLeQmFTD7ZHGHRxS5I+u3wt8FHZVrg8EEUXa+r06pAocVAPlXAdAvAlT7X/
	mE/h3iYgnbWLEnSp335dTynWCLR367Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-604-41wtSiStMx6OGywUNbxqmg-1; Tue,
 17 Nov 2026 03:40:31 -0500
X-MC-Unique: 41wtSiStMx6OGywUNbxqmg-1
X-Mimecast-MFC-AGG-ID: 41wtSiStMx6OGywUNbxqmg_1794904827
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 945C01956069;
	Tue, 17 Nov 2026 08:40:26 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95BD1195604C;
	Tue, 17 Nov 2026 08:40:18 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Date: Tue, 17 Nov 2026 09:39:21 +0100
Subject: [PATCH v5 6/8] selinux: Restrict cross-cgroup memcg charging
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <20261117-v2_20230123_tjmercier_google_com-v5-6-1ce975f2a9ad@redhat.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794904759; l=2979;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=RrKe9K1q9fyXy57Glgyl5viYPn+7F5Ts4443s8tf3ss=;
 b=13nAju+X3DpbINGKS1zMwlfDyMxGFVKZdQMxrpe6DbAQnYwMF5gKTQEiYFBetkPCvf2hIXqrG
 69WKbxp/kILA3BT/6ZxC3p0yuzpLYhO4G+cfjD7W57tFWJexlYcPhwW
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: DS7JR0INsEWoYJ1kRO-ccvRXXiXVnsh9AVXaFpipahk_1794904827
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8A0D80007
X-Stat-Signature: hyiy6pbsuushuwtiop8pynzryjzro7g3
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794904837-67097
X-HE-Meta: U2FsdGVkX1/GmU/8rybPgWUVUivmVNDzxvtGc0B5cbDbp7cqQn7HH9to5FwTZDVJRMkdTqTbADiFdsbajQkGNnwRkfcGtG/zoyyv/voXIyCP8zWl1CD2EirXhlmzNbIa21afcgcPL+Of0Ko0n7hLpE4M3wOUZoDWfUX9COyCnHrwzebjRGp/gUGBQq+LZkqfuh3dR01JSYiVCt62elIz3dr3ER1IICdC/m4zwovQV/tssOaCIb9FwPgL7vuY5elZucQzd9r/3JjsMajzxIUyy8xDcz99pdToiPHH2QHJZsJLQHrFNiiyxUY6PP2vevc2tjxj4EAIV6b1Gm/EgddFziDtoyIlRtavMa7bPDqYTlgEF3LwQVeGENqEcgYOwMhqQVumf8d7fFLeCRDVE5BW61X+p35eq43Qy9dAuXKPVpBMzVBe9hXaIXNLUryyl+Wp0tAqFXnQSuNLSGJeb40vQzpidZ9NB22FjwsZ4Y6wS9i94lkGXaUfmoLWb1lMVGqzKgZmB0qsS7FgnjZnpN76wN9mI6DN20tWw/fpNGSzH7eoytpGkFz+gbXQ2Ci9jZM0M+sR5x+5qqcj58BZnH1d8xOK5FFAFIDh1A379nlz4ldjz44j2QHWirpSV0YKBywgx0OXWZr0ihAye5GxGPBrXQrYVB4TEmCE/2eZbthTZIHzAFvsCozboLKzs4g4OzFkc58dhGA0bVCHI2LdWRwaBss69on2jkW481kM4fZn80NTp40UyVmlQyzBpMYYcCeLWF0Qx5SSjL3uFY1XiZYWJ2miVa8+xWsnxQ73jH2+V3hvm8CP0/zHs5FlwbpsJuOe/OwkNetm1PMIyP+jv2uFUiHzOby5HvmgDGoEQyaPHtAvcegHnT9rWA2L5mzIuTNYL2ZBXzTE4ZLibBnYbCNOs0NNzttv+xN2tpJTgf8hWbUGFwMB/wRohLnL9TsjNZSrH81wc+C2/otkbVYvJk3
 rXtK6ygB
 m5OtIdE1ztDc5ccvvuCenn3tkWwH8ZYMBshCRZ/B8TsfJ5ED2jyO6ZKCqXbF9S+uisQrxWc1OtnSf5LqbP+EBhkLQwWwRkxypXjpKtkA3K0eBQoCYREvgrKHSt6/kBMhneGTxVlrtKq6WRHvR/D3U2gjXSACuv6WopNXBtXTmJ1uqrYsgJJDiggKEOO1noEDj69spMg0X0E7MdBNicLZownQP/K3OsvM218IUjs05gGb2mFn0oriFx6CShumniJfX4mZtbz0oQ+LyjaGsmXTCAOlN7mSo6uRF3UR1leTu/VQoqXwZFbtnq3mPkrObqegXIVWSx/hzmgc/7bJca2EqRJEVi6mAl9qqIdb7exGUA3dleympaKjV82pSUBlAsKtlsGuzngvI93ISnFL54goUEX9lLdM6+I9IH7Nq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The security_memcg_charge_task() hook allows security modules
to control which processes may charge/transfer memcg
memory to another process's cgroup outside their tree. Without
a policy implementation, the hook is a no-op and the restriction
is not enforced.

On SELinux-managed systems the only limit is CAP_SYS_RESOURCE. A
domain that holds both dma-heap access (today's only exporter that
opts-in) and that capability, can charge memory to any cgroup outside
its own subtree. Since the capability is all-or-nothing, SELinux
policy cannot express which targets such a domain may charge to.

Implement selinux_memcg_charge_task() using avc_has_perm() from
the process2 object class and a new charge_to permission. Policy
authors can then grant cross-cgroup charging selectively,
for example:

  allow allocator_app_t client_app_t:process2 charge_to;

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
 security/selinux/hooks.c            | 7 +++++++
 security/selinux/include/classmap.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6168dd5f91c2..70de6094b2b4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2204,6 +2204,12 @@ static int selinux_capable(const struct cred *cred, struct user_namespace *ns,
 	return cred_has_capability(cred, cap, opts, ns == &init_user_ns);
 }
 
+static int selinux_memcg_charge_task(const struct cred *from, const struct cred *to)
+{
+	return avc_has_perm(cred_sid(from), cred_sid(to),
+			    SECCLASS_PROCESS2, PROCESS2__CHARGE_TO, NULL);
+}
+
 static int selinux_quotactl(int cmds, int type, int id, const struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -7681,6 +7687,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),
+	LSM_HOOK_INIT(memcg_charge_task, selinux_memcg_charge_task),
 	LSM_HOOK_INIT(quotactl, selinux_quotactl),
 	LSM_HOOK_INIT(quota_on, selinux_quota_on),
 	LSM_HOOK_INIT(syslog, selinux_syslog),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b16425..4004c05aae5b 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -60,7 +60,7 @@ const struct security_class_mapping secclass_map[] = {
 	    "siginh",	    "setrlimit",     "rlimitinh",   "dyntransition",
 	    "setcurrent",   "execmem",	     "execstack",   "execheap",
 	    "setkeycreate", "setsockcreate", "getrlimit",   NULL } },
-	{ "process2", { "nnp_transition", "nosuid_transition", NULL } },
+	{ "process2", { "nnp_transition", "nosuid_transition", "charge_to", NULL } },
 	{ "system",
 	  { "ipc_info", "syslog_read", "syslog_mod", "syslog_console",
 	    "module_request", "module_load", "firmware_load",

-- 
2.55.0


