Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12812606A338
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drQoINnV
Received: by kanga.kvack.org (Postfix)
	id E46C66B0893; Tue, 24 Nov 2026 18:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCED36B0896; Tue, 24 Nov 2026 18:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC53E6B0893; Tue, 24 Nov 2026 18:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2EBF6B0893
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:00:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A880A8C12
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:26 +0000 (UTC)
X-FDA: 85471533252.07.A8A0F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31BD614000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:00:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drQoINnV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561224;
	b=olS4QvucwQiX6GaXdgnB9i0107963g7CZ2THv3D6rjNzj65nUcVK5lsFz4BxHE3/4IRXHW
	5+Lq714ZR1NgqxWhFYL2sQvqk6Krdeh9xvW6idr7jj6XxgJhDyqwMxWulnL3e6Z2DFfsQG
	Mnb7stHjgRd6nv2OJKs6CKqRkXjt3cQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wcVGG20arn5AtILXYsS1QLVQzh9zzWUG/JVb/Qxc/E=;
	b=SM+bvHDXeFOgYCCGgYEUhlIIFdSfYhw8IPY3qM5TUGL1okWoVlKvmioTWpBDbx2OuxS2CQ
	tDUj+R6Uzo+NtpdhL45C1xtKYhJfbsV8mXPlBM+fojf58wuuDr/mzHEIO/g31C2lgGYcpf
	1PEvmhdQ2jQmVD2kl8UQEWmyW1re188=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drQoINnV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92985625D0;
	Tue, 24 Nov 2026 23:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E861F01566;
	Tue, 24 Nov 2026 23:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561222;
	bh=5wcVGG20arn5AtILXYsS1QLVQzh9zzWUG/JVb/Qxc/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=drQoINnVOrBqHfexqbEvYA54mjyKAoEib0sv0wCWzg9cPAvIlkExX4lM5E1KU+9aq
	 M1AzvH+frea1crPg9+BkhsXbcfSqtdfSloQ5tC1Eehb2nRGZt2hCnKWbtgSo6T67qK
	 8TdqUvBVFpLZwGUDWZZBYXsc6FxFN06J+vaBCCJayEHtDub5XbRQ6JcBFmRZOAQSeg
	 WF1rGIqF0xfM/ZUTJPATESch5gxdicfwjVz7sd0RCtFhNNhsBNQUG1qnLwcFzgXUBS
	 kR7+Z1Dp1AfpjXNXa8EQzR4x4Mcv6VS8pfFYYj1NhGglz6CapdjxBOrSqkhrOXGnTM
	 TOh4E+95DiKTg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:37 +0100
Subject: [PATCH RFC 14/19] exec: switch time namespace after dropping
 exec_update_lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-14-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=1623; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6xDuRr9GOZ8Vkh8V9ig2bxnMakSdmbVhjN6OQ6k3qL8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSziR0t47uSNEV/4vY3n17blxnJV5slJVYWTC5IWcrBZ
 PLqXmhKRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES0tRj+Sh+PS/DKebHpq55C
 mPFXZn7jk1of7TJnqB4zbcgKzrTawfDfvfHbukx2Wds58mU3Ar/fKLh16brBrXdqRxcl3bpw43A
 tFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 31BD614000F
X-Stat-Signature: msbsr7eqkbcjkek81zu5qp97rank7yuo
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795561223-113740
X-HE-Meta: U2FsdGVkX1/heBpI0/7FNH6Mi83pgOv1k7HgNfl8nm7IdBgZibswCEqNLSw2nHen+PwRThBy601Nj7cJYlM/ujOPDeErOvG75YbucH2HbgpyFBDMRrDNG/bSSd683ejmNLVxLo1JQaJXU/CZ9Gn7+8+XPMx7wNhYLapbIHVXC0eThr8kCvfbek9X7/Az/Q5Fg0ldezo+KqkFYIuhOPv978bANgXIturHNpIt73B0/F65qDPli4wKGpSq/5c/ftsR4BGXCei5bMRI125R3pOmUqhIsQa/XZ5AIWCP4CHi7QuAVLifXbOzS9n0RskpzKhg+TYUWdxqteOp734/epM2Tw5xacI+gYvCoaGiCOr4hlqeoKXdkv3GVE17WJTJ1ibXqfPgHwMGKsFV9nnnoMjj/pXj8EHEnQLtba5ixjUaTqU57Tl2U5ZEmKUlmAK0oVTl7lTZtoXtC8GoN5m1TiqP+riZIFimeRdlhf0M6FeBIBjK3FOKH5iyB605I0AEwZ9b2bko0c/8e5dczCDW8wjI39tec5BmE/v1NzpRHi0tnGivmQA6NurrF4rzyh0xJI+HX3gLATTkf+1nSci6MOKHVMhpwoNh1RH41rq6rKgGM+EXYMV0OsKKD+ZmvL7OFKGVZiSrHttPr6rBM7AQfR1R4rxrhesoFCi0iFYdrXUpYiC6rlAYxJ5MQrOiMAYXWzOoeT/QiYXu63TzFWXCAiyJiWQxx7ZDKLqw5uXfaRlXW3xAXkNIK9FbK6wLNB5FPmE7o3uPNEhs4TThe9mu3TcgoWRubvvBdG0k+8tncUuFxDHdY7tZtcDlgrMUyoXc1RLU+FpsPlAw26ffnPkYZxZvGXUhxqC0QSNCbeernof4ecwIIst51qYlWG3vjpJLCV25qUBXcan7rROjEVCdfr1V3HOjhi63kq9z3bJV4qpgmQcJMa6lXGnAC3ZwSQXt95+4PuPiOu3vgk7N3iprsRq
 y/8ad16L
 v8mrbTtPh/l8ELKuJcHelNDR/P3ZaycBJkqDis+Xpk5/Zhwcp3+E0gxI9BVr+5FMzuLwrUAaP9gJvN0C19yCSa9S64qrIvDoD2nvtJOBS4OTYsodxjsQVQmR9c6SKeQnK6bLxxRWWgkukWhKfthPAr2Du5gwP+tFGLJrokB8lrD5uGBR2qUcg0YjLWkj4CjNs6PYB6M9NF70esBA0fd81WXBbJY081VTfNg83F4S4tBRfYYq8ub0NqOXb2DWGUmViOkTTutu+VAd06TkNuRDH6ffbJPKLG3/Vrd1Gbp/7ArlN8Sp0rxcQ2773VopTK27oj3OgHn/StT7upy2JaeuhQq1LWLV6p53GXLfajvS7jWNe8Jz2frtetAtW25c0tHi09RwDVzoUurM60reS4WgYn3gQRgswKaXI419WpN+2MG6DdkooK3t+/OMVx8wUDLRCLhuJgLSjluF8NTGkdWLc6R1u3VawSr/hweoevTnqrjDbaro1L/zKquJPTi6TYbm59wxRObBJlP2L3oOB8yN0fcXAw1s1M9cdbxrw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the task has unshared its time namespace then exec moves it into the
new time namespace as it's getting a new mm. That allocates a new
nsproxy, may take the timens offset mutex and the mmap lock of the new
mm to switch the vdso data and may drop the last reference to the old
nsproxy. Currently, all of that happens with exec_update_lock held.

The time namespace switch isn't tied to the credentials changing. So do
it after exec_update_lock has been dropped. It still happens before the
vdso is mapped. Call it after security_bprm_committed_creds() so there's
no failure between committing the credentials and telling the LSMs about
it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7b261b0a5f33c..6120310f3fbab 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1232,10 +1232,6 @@ int begin_new_exec(struct linux_binprm * bprm)
 
 	bprm->mm = NULL;
 
-	retval = exec_task_namespaces();
-	if (retval)
-		goto out_unlock_exec_update;
-
 	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
@@ -1334,6 +1330,11 @@ int begin_new_exec(struct linux_binprm * bprm)
 	 */
 	security_bprm_committed_creds(bprm);
 
+	/* Switch time namespace now that the task has a new mm. */
+	retval = exec_task_namespaces();
+	if (retval)
+		goto out_unlock_cred_guard;
+
 	/* Pass the opened binary to the interpreter. */
 	if (bprm->have_execfd) {
 		struct file *executable = bprm->executable;

-- 
2.53.0


