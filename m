Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED41C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4FB6B008C; Fri, 24 Jul 2026 11:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6106B0092; Fri, 24 Jul 2026 11:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBC86B0095; Fri, 24 Jul 2026 11:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6B96B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:03:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 129E1403EE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:03:45 +0000 (UTC)
X-FDA: 85023989610.25.779063F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 11FC0120012
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:03:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gc8TcsBO;
	spf=pass (imf29.hostedemail.com: domain of rrobaina@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=rrobaina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784905423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c0ViCeYIvDvbmJchKqAuBa754g93eEZt4PnUI1bl52Q=;
	b=mfcvgQWHhRGtsXRm3Xhxb+7tzx+j/2kJ3Y3Z0wqFx5b4zRx3Coptnjh0Lhb7SqIPpHELua
	R33ppeTimN4KgG4OeAqQchIZgoo9KE7G9i5uDtuJdXfGOdpbo66/X4pT/0Rfx/pIZWOusV
	OPhzQEqxFECrlifvbNhNfyLJskIXgLw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gc8TcsBO;
	spf=pass (imf29.hostedemail.com: domain of rrobaina@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=rrobaina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784905423;
	b=RyVu8Cih2U5Ku7K/mbs4sheydLo2jvsPZMTa3CyvVLQJQa60Xg2ZYHifWxeyxFa/xicDFu
	PrrF04N2mis2omDOYX/RDLkMTK35+Cvd26gFNQgkWOqSPpQFbl29bphGN7cTUcdwuuTOVd
	OzH3stMP/OBSd5Jl6WbCnaFzUvjwSUY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784905422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=c0ViCeYIvDvbmJchKqAuBa754g93eEZt4PnUI1bl52Q=;
	b=gc8TcsBO4TqrgwoDZD0MWWeZ/IeR/br2lJcJAJ/btu+lJNZIpNqlWNSR3g9fZAEn3LUacX
	c+fKVMziUsXzIF9urWWUtORAsiX9ZTm11/IZvO/7Fm/fvid/5hHPW8cCI/pxA0iR44Ttr1
	Mn3JuWZipsP2L/mMSA6IwjK0D2t8sm0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-P1r0y-izPyOZOjBHnfPl1Q-1; Fri,
 24 Jul 2026 11:03:39 -0400
X-MC-Unique: P1r0y-izPyOZOjBHnfPl1Q-1
X-Mimecast-MFC-AGG-ID: P1r0y-izPyOZOjBHnfPl1Q_1784905417
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1050A19775FC;
	Fri, 24 Jul 2026 15:03:37 +0000 (UTC)
Received: from wsxc.redhat.com (unknown [10.96.134.40])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C82F330002D5;
	Fri, 24 Jul 2026 15:03:31 +0000 (UTC)
From: Ricardo Robaina <rrobaina@redhat.com>
To: audit@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: paul@paul-moore.com,
	eparis@redhat.com,
	sgrubb@redhat.com,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	brauner@kernel.org,
	Ricardo Robaina <rrobaina@redhat.com>
Subject: [PATCH] audit: add CLONE3 auxiliary record to log process cloning
Date: Fri, 24 Jul 2026 12:02:59 -0300
Message-ID: <20260724150258.560396-2-rrobaina@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Of3Xby2RZJcxmKg2y8Xf7-jzGuTJVut2j9pHaSSAIXk_1784905417
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11FC0120012
X-Stat-Signature: spsof33hb1bpwbxwasmnhdd7a9j9bqdn
X-HE-Tag: 1784905422-640034
X-HE-Meta: U2FsdGVkX1/aUNpHpfytle9LOQCa6vTTChrfRG+GP/6X3cA2Z5WfCFsykVoPayQEfBKcDyjdnJTY1G05EpdGzNm/onxgRYXhNZf9U5ZhjssR+bbs6EeZfa/awUg5fgx5CoXrqQisMoH1x9s1JfG8TI/VPO0cpggrAngZi+tLeJadAYl/TtnY3HCGoor26qV3hmqCFHJ2Mkn9fjwT+7UpZQKf2UZ9nufl8gPZm3ro7BugXVvRXb3w+BPPXxO8EFVPOhXPNn3AcRaOOLXRactsZfCwzPdPOqmgEsAelqxAWdbT/EdPg6LMgk017xyZ5YgL66aH9b53UFj9T5ee1BwA83LWfmwx9cGxONwnJuVeQUNAvK7WHXfsdXyD8qJiiM2G+5CCBlOX3ZeGE8EPmKhmaKB56kn+iCflkUdVD8DVa1UxaSFWh6kUH83VvaHUIretFK3K+4Z7Xuva29qt3ZWFBCpAvlcnC2VwUnL1gf26QoJj7j9lWj+YBqc6h7+V8rc1D6TZXXoFlO0+1lJ5zzBWudBwy1sCKIjLHc9dCjac9UQOo6tgxr3MxA9RGpjbb0OkggtVacN9Ldud/5ats+U55iPy//G3EgBNa8aFKWuCyaKvqFRvKpmXfD1pwuUKxM3GgFL+pCBbGaqp7sj1s12T3I+3Sf6gMg8fMPd3xTZAYtCGmOSIUKeqWaRqKe7iY913lyZucBDlmfSQHH1ZjcIpgz5RGr0uGqD51Y51IHKm89bCZJniF0/XEfqTkR/C8R34qOYxvDNwqFIzVVQ4u5SEyZBVees5oNkVmIYa2KMvD40DvgOZIyz56I/lpQr6v77x2YsTM/sUpup/FkNrgybD5+00lpQ7WQgcbgDTMay1OYUA3j0kx1wAQpLCYN9skGmSa6cbc3n/4UDb42z8w6iKk24LHC2Oh8A76UTeJ1InwMr/i7DCORQqxRutPoyNUO0haBvWaQiVTw7hQ+5h+4m
 30IAj5hM
 pO2q67L5nM4eLY991orjgbrrKScqLhP8r9bEsZkxVxc6MhcoUAmXzBpOZHylb292C0LwBToDPSKjjTjnH7PuMOGNo/DxwMpqaRq6+UHKtdJioZDaxtWICXDcIpOu9ejgQuwchgGnPW0Yk740IIVFVRFtGueLtcHXR3toNmmKEqBz5Jj2y1NfLNnaY/ByHZ8hdpk4IZJugmaRreI4yC7UyR/tcL/zMGbvT8drRNXEG9TMhQ3BeU1tvTjdL1HaZ885SYsEOgi1uc+rE3uCva81fVFr2YhFIp3zxL7uPQL7l+kVU0UYTtCk2sa+6bOah1WsMo9mOV9/Dm7HyuWm2SkNVGtNxMkoHBbhso3gQ0gFXEzIOvdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The clone3(2) syscall moves most parameters to struct clone_args.
For this reason, the generic SYSCALL audit record does not capture
the structured arguments.

Add a CLONE3 auxiliary record that logs: flags, exit_signal, cgroup,
and pidfd fields from struct clone_args. When CLONE_PIDFD is set and
the syscall succeeds, the resolved pidfd is logged; otherwise
pidfd=(null).

 ----
 type=SYSCALL : syscall=clone3 a0=0x7ffe7f1ec640 a1=0x58 a2=0x0 ...
 type=CLONE3 : cl3_flags=0x1000 exit_signal=17 cgroup=0 pidfd=3

Link: https://github.com/linux-audit/audit-kernel/issues/151
Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
---
 include/linux/audit.h      | 10 ++++++++++
 include/uapi/linux/audit.h |  1 +
 kernel/auditsc.c           | 20 ++++++++++++++++++++
 kernel/fork.c              |  4 +++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 45abb3722d30..833f349bf415 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -449,6 +449,7 @@ extern void __audit_tk_injoffset(struct timespec64 offset);
 extern void __audit_ntp_log(const struct audit_ntp_data *ad);
 extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 			      enum audit_nfcfgop op, gfp_t gfp);
+extern void __audit_log_clone3(struct kernel_clone_args *kargs, int ret);
 
 static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
@@ -598,6 +599,12 @@ static inline void audit_log_nfcfg(const char *name, u8 af,
 		__audit_log_nfcfg(name, af, nentries, op, gfp);
 }
 
+static inline void audit_log_clone3(struct kernel_clone_args *kargs, int ret)
+{
+	if (!audit_dummy_context())
+		__audit_log_clone3(kargs, ret);
+}
+
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
@@ -730,6 +737,9 @@ static inline void audit_log_nfcfg(const char *name, u8 af,
 				   enum audit_nfcfgop op, gfp_t gfp)
 { }
 
+static inline void audit_log_clone3(struct kernel_clone_args *kargs, int ret)
+{ }
+
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index e8f5ce677df7..37357e17adbf 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -122,6 +122,7 @@
 #define AUDIT_OPENAT2		1337	/* Record showing openat2 how args */
 #define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
 #define AUDIT_DM_EVENT		1339	/* Device Mapper events */
+#define AUDIT_CLONE3		1343	/* Record showing clone3 args */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6610e667c728..c0106bb71c19 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2882,6 +2882,26 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
 
+void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)
+{
+	struct audit_buffer *ab;
+	int pidfd;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL,
+			     AUDIT_CLONE3);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "cl3_flags=0x%llx exit_signal=%d cgroup=%d",
+			 kargs->flags, kargs->exit_signal, kargs->cgroup);
+	if ((kargs->flags & CLONE_PIDFD) && ret >= 0 &&
+	    !get_user(pidfd, kargs->pidfd))
+		audit_log_format(ab, " pidfd=%d", pidfd);
+	else
+		audit_log_format(ab, " pidfd=(null)");
+	audit_log_end(ab);
+}
+
 static void audit_log_task(struct audit_buffer *ab)
 {
 	kuid_t auid, uid;
diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5..0f52e8c0e900 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3047,7 +3047,9 @@ SYSCALL_DEFINE2(clone3, struct clone_args __user *, uargs, size_t, size)
 	if (!clone3_args_valid(&kargs))
 		return -EINVAL;
 
-	return kernel_clone(&kargs);
+	err = kernel_clone(&kargs);
+	audit_log_clone3(&kargs, err);
+	return err;
 }
 
 void walk_process_tree(struct task_struct *top, proc_visitor visitor, void *data)
-- 
2.53.0


