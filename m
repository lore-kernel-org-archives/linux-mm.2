Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E27FCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD9D8E008C; Mon, 25 Aug 2025 23:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94C78E0038; Mon, 25 Aug 2025 23:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB188E008C; Mon, 25 Aug 2025 23:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B57988E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:18:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A4DF139814
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:18:35 +0000 (UTC)
X-FDA: 83817450990.08.B9434B0
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC642140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:18:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=foSadxmq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3iCetaAUKCNcMP77D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tweek.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3iCetaAUKCNcMP77D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tweek.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756178313; a=rsa-sha256;
	cv=none;
	b=kqdD1AMNadzsu21QFqP+KTG+TFmcpK7DWPafByGmiyAYjGu2s8AFIKSC6Emwgk5NlwM7dm
	bHFp2OnwbYkHBNdeqPyJILF2MhVLWkKKFCPsWSxnbO5VuBzqRhezx7WSsPIc5ZcV7eX4SU
	Auda3PHP+riY1G8V29rUfYDXU5f/lMg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=foSadxmq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3iCetaAUKCNcMP77D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tweek.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3iCetaAUKCNcMP77D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tweek.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756178313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ia25Jaa7IaL0nffY5Ufyltoj6WxAaukUAWgd3CDsn9w=;
	b=lgaXqCYSAfv9lzMoKT5HAI46pY2WbjGhCFqt/hsf1MTiKg4lnTFRx4kq1CFY/Eyofox1GS
	88ZSCbSa84XKYXh1kKQd9dX6Rhd8AiMBXHs13Zebd9t2ArZ5yrtDjyPpuIezckpTB4sAi6
	v22mblLeqajZ8TatiV3KvewbfodXpoE=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e8ae86ab3so4863022b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756178312; x=1756783112; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ia25Jaa7IaL0nffY5Ufyltoj6WxAaukUAWgd3CDsn9w=;
        b=foSadxmq0kO+/BnQRug55NL998VcVvnidZDwhqS04dKvYWNM9XnABi6bTL6UVLkwaV
         Q7Ja4m6A5qi4ScIGUkRkBb5Om1lgi8pVPD9E8DVEJ4jULsWSz94Z9C/SnXCnkvwj9I6X
         1hee5BUXof44UcpxNtiWCgYZzLfMXnZAQk8TfWgYCgK9mddPsqYNsU2K/aygKs+3DGID
         6qaQvOwINM3GShWuG7PbZ/W4wb7LpyNx8mhU4+/GDRGDhBk//PS5VAnQncNioG7iy5tP
         +uieiGvq7hOI2kNJMlmN1wZMMFL+flZ9oZTQRrOX9dx96TgxfKnlXdgflX087mI90t/I
         eC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756178312; x=1756783112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ia25Jaa7IaL0nffY5Ufyltoj6WxAaukUAWgd3CDsn9w=;
        b=QEqk3+TQFGgMvQ9gOVvCMjAtlIXEz0IynX488ipGu1zWiYRQsezorcnEkZfcULHIXM
         1rqdSHMu1MvLuk24xWcPRL3/NyBfUW94/B9IrmbuWCBZxIEchUL1nHfhd0k15xAjXvtA
         gKhiLRDAeH2tH8Fexa/slsnS8ZdMUhoQT0Jt6UOmLkpiI7xGvRn36768QNxDF5NKDLZw
         Ufjuz5ijy7o0rC+IOBezXj4vZTdQA6s5KxXm9batnLH0ckqVewPhMaSD/9WJ7BQZbp1Y
         2qvtAZgmhHUglA2n0ESmCP5MnqES+2mEYdMMFAiA+sSLCUMUGRaWpTCVesIvGCzn8lPI
         IxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxkCxttWuL6J6MyYfrlzBP7F9gOSP3YxZsEYEy/lUftVQVcouzY6KjlDHv4GSH0Rrz2FsppqB5Ig==@kvack.org
X-Gm-Message-State: AOJu0YyCmsbhMtsWgbAZz6hbKYm1ETnCkjMeIUbdmrH6ZBKfSOLqX5fe
	sqCJEoYGIJs7bA0S5uBj+dWZOGENs1PWELrV9R00wM4l3fn+zYvaMdDM8YPVDUW+9muX1m3oKk/
	NKA==
X-Google-Smtp-Source: AGHT+IGXhlqnNu6ddaR+RH2PXtP+vJbdu5PRDLMQSy9xdeU5Lb5NRpAcP1D/ThqTrLRg2ieo22vV8cyK/A==
X-Received: from pfbcw11.prod.google.com ([2002:a05:6a00:450b:b0:770:58e0:741f])
 (user=tweek job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a8e:b0:76c:1eae:fd30
 with SMTP id d2e1a72fcca58-7702fa02d0fmr18741407b3a.12.1756178312469; Mon, 25
 Aug 2025 20:18:32 -0700 (PDT)
Date: Tue, 26 Aug 2025 13:18:24 +1000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250826031824.1227551-1-tweek@google.com>
Subject: [PATCH] memfd,selinux: call security_inode_init_security_anon
From: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Hugh Dickins <hughd@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>
Cc: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AC642140003
X-Stat-Signature: yonwgq46eqo9x4bsatsp81opyzzas9d6
X-HE-Tag: 1756178313-555487
X-HE-Meta: U2FsdGVkX1+W4ET34Msau6Ix0u3OenVg48TdyXUgOXvnr9BB9+QhuIS6LD1zhcUe+kNo1+rbne1JxrvE5YhS+96peYuIY34l+0c1dV7amR31cwogQCJVTSp9DewYyMO5s83ULQrjNznQT5dzx/YLsguevs9iHgJreMAYGsuor2LaSjxj0wKYRkQnQamXf+f+mtoyTdeFKLewAd+M1WEh5UXppt/3zISei8XK2Ju0T8KG9YpMYhLS2+bWtfPk+G0SjNHUr6uPPJjrrLlI2FgVfew0rmdp7yF8l2+ShQgk0LauGbHMNXoVS2+i04mEVFJyig45TcnLNXqPfoxnuW26GxewegDDGZtSCcTo2d1TdMX5o6vnk/qUfp1gS5AdrfVMWDAPnAHF8RTTn58YsK4+7iP9MFStdWLXS0gFvvRbCvDzkcvLXN3Vg1NmKokaHmOQtUZq3qV+mt/t9Jj8OwIX29wlxzTO43+/KJPpDr3Y07F6mmKdNq4S85yMJeVuwrKs2v4nff8k/g/qjo7m7eQAPkHZ4JSHouVBcVSf+1ljCUKdW2Y8y8fVvv/sON0fGVwm5gVOsP56VE7426Uf1Jj7tozWK8lSaLv7fX27pkmSLBFUWYu6PtRJ7SYC2tKksQ0S5QTTVGeh4jJ+5F6OSeYmQKmE2/jc2DbbJFvZSk4caufbkA3m8DMm0gm5sbmV8Q5Vnct0BdjZzYlC5TZUBT40EcdzFd/XLwaf/MmyYrGR1V5E4hA/DHzKmf6B1v9eoQSDYICYl5Yhs47UE4VsO2PHFRloGmGfVE4vGREWektPzSzzHuEAPFaLptjlgiprolLunQJBJxRbNRw5piWJbxHI59HmlFO2ilGEwejsRrbTfHwiZM7RdokuE3OO/z4GL9lhaEDFP4K+wNrIIHPYRLN5sDDnayXTcixNzTNxKKsJSPiEns8kOLYyVP5vqNEvFAkrbjVXtPhSOP+mOfqVims
 DUnRJE41
 49nDAdONu3CFWB9Sq49YWNkOxsWtE1RNiCp3QBssjNBjVKgSpEovOgPrs8iUktErkeQ+bNLdveYK2AJVkhpnGUyQ5SIN+qBXvKwZWHjtGosDUO3BChUOjFBHp+TjNxjIHkg8RUyU0a5Q4WPuBeU66ekeKayVISNrnngXmzotvk3CcAO5Yz0zmhnRMfHZuyVJFc5WCUh+yfE3bT3ho2PG5kpaqZffyV6hGyKH1AwSWGrNYBrqH474oEIV7NWzhpWAVbE15zZMQEQeYuILR/Jwauzn/m06CjzZgLntBZ2cO7tARPYeDO4g2VzJ7VDs8mw6vdNA39e/D1gxNEaZoLID+pIy7AJo1fuSKQH3Sjm/O3nCwjGKhYRg+Tc0J06IIdKxNl2nDV2GKarag9hL3KQLghv4Uqve7r/Aiif5gvWmBBV+p+51FZYg7/l/cBlsFHH4valTmeY3fSG4O0gFwy57kjF88ZzVE732fcvHD1YguzA8U3X1sYJLppyzepxT3abhIKURTxx87hx3Cy1WPDmFdH5rUD9mmjsShQCj4T08mfjYcrDrQMK5zeEYPxY0Zf/dugkEfrblAm3wSfSE8ZXhTAsMJVgQgrajp3A1GucUnwanE3KWXAPuT+39gDECrpcRLCt1PFyVMvGcojn0e7rOUdR4KN4YhInHUkiKf6p1KkhGr3y9e2usSMIWC06a9MoSdlDpayJ6cFN6fFmw/YflXCPAoA694++e5DT+Exwg8VX98P4EWVZBOHR4Zg8hbtveXo/Ibh3VjeIKr96SQnPlThcevcWOnr2gHuWHjXXWYnpYZmhc5s9I1rUZP0BSeVdzXPhnX+mxcUaZ6qFde1LFLo3s20A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prior to this change, no security hooks were called at the creation of a
memfd file. It means that, for SELinux as an example, it will receive
the default type of the filesystem that backs the in-memory inode. In
most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
be hugetlbfs. Both can be considered implementation details of memfd.

It also means that it is not possible to differentiate between a file
coming from memfd_create and a file coming from a standard tmpfs mount
point.

Additionally, no permission is validated at creation, which differs from
the similar memfd_secret syscall.

Call security_inode_init_security_anon during creation. This ensures
that the file is setup similarly to other anonymous inodes. On SELinux,
it means that the file will receive the security context of its task.

The ability to limit fexecve on memfd has been of interest to avoid
potential pitfalls where /proc/self/exe or similar would be executed
[1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
similarly to the file class. These access vectors may not make sense for
the existing "anon_inode" class. Therefore, define and assign a new
class "memfd_file" to support such access vectors.

Guard these changes behind a new policy capability named "memfd_class".

[1] https://crbug.com/1305267
[2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.com/

Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
---
Changes since RFC:
- Remove enum argument, simply compare the anon inode name
- Introduce a policy capability for compatility
- Add validation of class in selinux_bprm_creds_for_exec

 include/linux/memfd.h                      |  2 ++
 mm/memfd.c                                 | 14 +++++++++--
 security/selinux/hooks.c                   | 27 ++++++++++++++++++----
 security/selinux/include/classmap.h        |  2 ++
 security/selinux/include/policycap.h       |  1 +
 security/selinux/include/policycap_names.h |  1 +
 security/selinux/include/security.h        |  5 ++++
 7 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index 6f606d9573c3..cc74de3dbcfe 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -4,6 +4,8 @@
=20
 #include <linux/file.h>
=20
+#define MEMFD_ANON_NAME "[memfd]"
+
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int =
arg);
 struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
diff --git a/mm/memfd.c b/mm/memfd.c
index bbe679895ef6..63b439eb402a 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -433,6 +433,8 @@ static struct file *alloc_file(const char *name, unsign=
ed int flags)
 {
 	unsigned int *file_seals;
 	struct file *file;
+	struct inode *inode;
+	int err =3D 0;
=20
 	if (flags & MFD_HUGETLB) {
 		file =3D hugetlb_file_setup(name, 0, VM_NORESERVE,
@@ -444,12 +446,20 @@ static struct file *alloc_file(const char *name, unsi=
gned int flags)
 	}
 	if (IS_ERR(file))
 		return file;
+
+	inode =3D file_inode(file);
+	err =3D security_inode_init_security_anon(inode,
+			&QSTR(MEMFD_ANON_NAME), NULL);
+	if (err) {
+		fput(file);
+		file =3D ERR_PTR(err);
+		return file;
+	}
+
 	file->f_mode |=3D FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 	file->f_flags |=3D O_LARGEFILE;
=20
 	if (flags & MFD_NOEXEC_SEAL) {
-		struct inode *inode =3D file_inode(file);
-
 		inode->i_mode &=3D ~0111;
 		file_seals =3D memfd_file_seals_ptr(file);
 		if (file_seals) {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index c95a5874bf7d..429b2269b35a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -93,6 +93,7 @@
 #include <linux/fanotify.h>
 #include <linux/io_uring/cmd.h>
 #include <uapi/linux/lsm.h>
+#include <linux/memfd.h>
=20
 #include "avc.h"
 #include "objsec.h"
@@ -2366,9 +2367,12 @@ static int selinux_bprm_creds_for_exec(struct linux_=
binprm *bprm)
 	ad.type =3D LSM_AUDIT_DATA_FILE;
 	ad.u.file =3D bprm->file;
=20
+	if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS_MEMFD_F=
ILE)
+		return -EPERM;
+
 	if (new_tsec->sid =3D=3D old_tsec->sid) {
-		rc =3D avc_has_perm(old_tsec->sid, isec->sid,
-				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
+		rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->sclass,
+				  FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
 	} else {
@@ -2378,8 +2382,8 @@ static int selinux_bprm_creds_for_exec(struct linux_b=
inprm *bprm)
 		if (rc)
 			return rc;
=20
-		rc =3D avc_has_perm(new_tsec->sid, isec->sid,
-				  SECCLASS_FILE, FILE__ENTRYPOINT, &ad);
+		rc =3D avc_has_perm(new_tsec->sid, isec->sid, isec->sclass,
+				  FILE__ENTRYPOINT, &ad);
 		if (rc)
 			return rc;
=20
@@ -2974,10 +2978,18 @@ static int selinux_inode_init_security_anon(struct =
inode *inode,
 	struct common_audit_data ad;
 	struct inode_security_struct *isec;
 	int rc;
+	bool is_memfd =3D false;
=20
 	if (unlikely(!selinux_initialized()))
 		return 0;
=20
+	if (name !=3D NULL && name->name !=3D NULL &&
+	    !strcmp(name->name, MEMFD_ANON_NAME)) {
+		if (!selinux_policycap_memfd_class())
+			return 0;
+		is_memfd =3D true;
+	}
+
 	isec =3D selinux_inode(inode);
=20
 	/*
@@ -2996,6 +3008,13 @@ static int selinux_inode_init_security_anon(struct i=
node *inode,
=20
 		isec->sclass =3D context_isec->sclass;
 		isec->sid =3D context_isec->sid;
+	} else if (is_memfd) {
+		isec->sclass =3D SECCLASS_MEMFD_FILE;
+		rc =3D security_transition_sid(
+			sid, sid,
+			isec->sclass, name, &isec->sid);
+		if (rc)
+			return rc;
 	} else {
 		isec->sclass =3D SECCLASS_ANON_INODE;
 		rc =3D security_transition_sid(
diff --git a/security/selinux/include/classmap.h b/security/selinux/include=
/classmap.h
index 5665aa5e7853..3ec85142771f 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -179,6 +179,8 @@ const struct security_class_mapping secclass_map[] =3D =
{
 	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring", { "override_creds", "sqpoll", "cmd", "allowed", NULL } },
 	{ "user_namespace", { "create", NULL } },
+	{ "memfd_file",
+	  { COMMON_FILE_PERMS, "execute_no_trans", "entrypoint", NULL } },
 	/* last one */ { NULL, {} }
 };
=20
diff --git a/security/selinux/include/policycap.h b/security/selinux/includ=
e/policycap.h
index 7405154e6c42..dabcc9f14dde 100644
--- a/security/selinux/include/policycap.h
+++ b/security/selinux/include/policycap.h
@@ -17,6 +17,7 @@ enum {
 	POLICYDB_CAP_NETLINK_XPERM,
 	POLICYDB_CAP_NETIF_WILDCARD,
 	POLICYDB_CAP_GENFS_SECLABEL_WILDCARD,
+	POLICYDB_CAP_MEMFD_CLASS,
 	__POLICYDB_CAP_MAX
 };
 #define POLICYDB_CAP_MAX (__POLICYDB_CAP_MAX - 1)
diff --git a/security/selinux/include/policycap_names.h b/security/selinux/=
include/policycap_names.h
index d8962fcf2ff9..8e96f2a816b6 100644
--- a/security/selinux/include/policycap_names.h
+++ b/security/selinux/include/policycap_names.h
@@ -20,6 +20,7 @@ const char *const selinux_policycap_names[__POLICYDB_CAP_=
MAX] =3D {
 	"netlink_xperm",
 	"netif_wildcard",
 	"genfs_seclabel_wildcard",
+	"memfd_class",
 };
 /* clang-format on */
=20
diff --git a/security/selinux/include/security.h b/security/selinux/include=
/security.h
index 8201e6a3ac0f..72c963f54148 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -209,6 +209,11 @@ static inline bool selinux_policycap_netif_wildcard(vo=
id)
 		selinux_state.policycap[POLICYDB_CAP_NETIF_WILDCARD]);
 }
=20
+static inline bool selinux_policycap_memfd_class(void)
+{
+	return READ_ONCE(selinux_state.policycap[POLICYDB_CAP_MEMFD_CLASS]);
+}
+
 struct selinux_policy_convert_data;
=20
 struct selinux_load_state {
--=20
2.51.0.261.g7ce5a0a67e-goog


