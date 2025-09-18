Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFB0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121688E0098; Wed, 17 Sep 2025 22:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9AE8E006B; Wed, 17 Sep 2025 22:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F6E8E0098; Wed, 17 Sep 2025 22:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20DD8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:04:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D96E1A073E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:04:41 +0000 (UTC)
X-FDA: 83900727162.01.ECE49D4
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id A22B8160004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:04:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IwtW9n0Z;
	spf=pass (imf08.hostedemail.com: domain of 3tmjLaAUKCAMwzhhnjrrjoh.frpolqx0-ppnydfn.ruj@flex--tweek.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3tmjLaAUKCAMwzhhnjrrjoh.frpolqx0-ppnydfn.ruj@flex--tweek.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758161079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Pyki2P4YAjRDRPrSasQw3ooIaydaujpJ4Vt5rSyTrok=;
	b=1dTvKN/g09u12xJ9idMegCyGd6Gu18AhKcfvmYQUEBvd/ktYTsoi3XTd0LJ+uKqa0lcI9E
	yDTzvOKx/JiwGH89UVCGHZAcQgpR3ndnv6leetHf8aRYwvzUttItqj8pKZwmHNrqGbzDkH
	1uJaYXDio7AKcC6VuoJGggN8xlKJ1Wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758161079; a=rsa-sha256;
	cv=none;
	b=8IlCJh4xkqiO013BNToXbupui8ZiAH752E9KBSvQcD9ERIEQ+Z45LL066o8VLoC5FHeUEd
	HzHnNx1mV+RQKEjOHjZZPcDeRww1Jjtam19sxn88ZVFEF6WeII7Qs8Wt81iWSr29eMVVqH
	lOvFSKIjgIBTMy6IdW7nlY+blZ/VK8Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IwtW9n0Z;
	spf=pass (imf08.hostedemail.com: domain of 3tmjLaAUKCAMwzhhnjrrjoh.frpolqx0-ppnydfn.ruj@flex--tweek.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3tmjLaAUKCAMwzhhnjrrjoh.frpolqx0-ppnydfn.ruj@flex--tweek.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b549a25ade1so498051a12.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758161078; x=1758765878; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pyki2P4YAjRDRPrSasQw3ooIaydaujpJ4Vt5rSyTrok=;
        b=IwtW9n0ZuFej8cavlycxORx72sZuqsodterQYsLHXYqq1/IP9oXUPDyNJKY+RWE+Sm
         8RMfRIcnzSRWUaxc7am5hxrWGKCh+CxECIl6pa00oaPoLFP9V9WQhCUmuyjDxlXZEvS9
         O0xnA0knZbPv43e35BwxGStBPYxJSHuFkzVdajIZhYktrxZAQVD+NK39h4yTtTQHKxjK
         9Aw3/2I02D3YQKsF0Qxg4q/9TENR/DgacYdhpa1qn5yTu1eqxYSIW7APKbO27rb6e+lV
         XSUoMAqABApxEXCi4R5wW9bPHvOHacG7buELqsDVGnXbhAX/1NyfkMJYXAI+A2Aw7+qK
         ArYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758161078; x=1758765878;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pyki2P4YAjRDRPrSasQw3ooIaydaujpJ4Vt5rSyTrok=;
        b=dyNFWxQ5G8dt8X/oJjPfI0GvgyZ7b1q5kOIjtblZRiuzq9a50HK117kzvvz3jbFqx5
         YMeh3vFVozi78tocWBf5z/bWODwSZKajx81YASnfz5eWcBGXiceJ0Jc6crBqGJesRCTc
         5K1DWA/UmNinSUTsfWBAT/uaOSyTl4eN5GRaIunu6cFp+NbM5ZvYqmOoWbCNJ75DL5Gh
         coKSEqtj3j/ROwQIThqtZNpb1znGdacFSzF0i/u16o/NnQW339msSohXLoALIt/Qz17C
         D8dw2x/CQ7L88a1x+Mc2lSytqpjwaThMqtGZBCbrTY8CfvGg08UgNBmJ2ABoDBxQn2Oh
         /4HA==
X-Forwarded-Encrypted: i=1; AJvYcCUR+AtqRnbWJjhDEZzooG4tqvEcMeWlVIuJNbvK5T43UhV65VRMQvOXCUxzlnWwKFvas7Ef5/m6Sw==@kvack.org
X-Gm-Message-State: AOJu0YzCCOmMVC/NThO1Eh5TRfHc30PhLI7oYY/FF1LUQInvoK+uXU4q
	54n34ttNrBV35h86G0Ah5i5e2INBz9+x2TOCFKGnV38TYtFT0YPyWKvoKU3W83FgiPKB8MXM+hq
	Kog==
X-Google-Smtp-Source: AGHT+IHxV2URVmDihcD64Mgho9pAFtZ0ZIdyPKpVqKKXetRCviLw6jUHqPxALm75Usf2v2582qjAQpR26Q==
X-Received: from pfbho3.prod.google.com ([2002:a05:6a00:8803:b0:776:169f:8da6])
 (user=tweek job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a06:b0:24d:d206:699b
 with SMTP id adf61e73a8af0-27ab34e85femr6141261637.41.1758161078245; Wed, 17
 Sep 2025 19:04:38 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:04:34 +1000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918020434.1612137-1-tweek@google.com>
Subject: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
From: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Hugh Dickins <hughd@google.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>
Cc: "=?UTF-8?q?Thi=C3=A9baud=20Weksteen?=" <tweek@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A22B8160004
X-Stat-Signature: xk68ikdp4zwjdrnepmt8y6hjd5szcfzi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758161079-42218
X-HE-Meta: U2FsdGVkX180KexUlm1Y+JW2KaIiuICnsJ/A2TWLcoLtqv24LUirLypuzowuKfRnR8vUSoxz6sxXimVRykRltPCkgqbu7UekVnEar8IvHI9vTt7hB+4n2wayIJ90JFKdAVpVKty1dKHG3SFoHWsyWmdRmVslJwyyZqaXd3HYzkSiSkYhfszGUBoGgUHg8DxI5GfFBf9Cyjcb5pgOJwI3bl8XEy5p/H2L/0rMOhXRHNInElHFxuyILQXDIeG3fDZ4ETs0B/Vsls8ZNxwihBMuDmmXokkP5mYSliAbq6msNNh3rVvFUHd6OM6hqbhIdhRCKTi8B/WT/vi0Ahg++grlls3QrWnLaK09+FE7c6gJBgSFIkXMhVPi8pMLqUIlOSzly6XkALheP8goWeKy05PLT7HdW6nuaZgdfNfgEfPFaXbrqNSZ0VL1PFFcjeqqj5+sUSvwj/KaEIWi5BzghiphzRk8Nr7X0QzbtLWzaOT5AiEEHPzKtmgpgvB0sSfaqDPHzDI0NU3BLD04ysrcZPt5P72n/jj4jdzm/QspJYgnxHf8WJxFipD2rZiqzAfHt3+Em1h2Y5mF3KhvNFOO99RvKaBqZaZIbZRIb+AlnKsBA/JVL8kfPKgfjbER+wUVw5h0A5/mF2vSy+saUH+aNWxgMTi67QZKjdu54K2uPTfRemnEorybBEWi08z2d8cWFlv/dFNNRnOgknPC00pxcEYHbpVRbhJLcEn7G0bu8G9JWFHksZT3zoq0DXE5QIWX6GKD7hicTkS5Mja6ZyAJc9z8BhhPemYM9+omXyrIyj69A2/Vw5AWxuyJYY5DVi7vTYsywHsemfjco7HPrjUes2PekypC/aVf6ekWRhLEf1uj3DEquLiCcOqo/cVMSPBJh1YKYhoa+mLKeVrA/Kuf27h2ZiG7CLtsuUWZUBqmUWDwDdE7ZXKMY4F/3DJJ1sDJYY3GeB5v06esPTnsjqKIJq+
 Lgh5bTmg
 +V/OraN7fbX+tOfx+nUCktiH+Slj5r/BQGpFAfhGB0fKT+oty4TAUe/Dv+FzeSerDlRiBn++4vgjJk5cj6vL6bsFhSBMY0isOMK78ynLjs4M4VOztEqwCvIARY7vQ06Dt4WkwnFT/1qua0sLZtU/eEvVSGK9YXmblak/b+csEywsyHqMiqykE/dL/isRjqidIIAgLyVz2r2/vJe6SOwNKSX0H8BCM2zQ9rSNk0OE36NGbzmE7ivIxGosKuCJELXODchg2i+24BB8o0zdaiH6pnbU0oUQJMC9LcwYZTOjlQ3/JbXEtGIrQt6nKwHooCRtNxDN44nY7rywaHZgsEenm79OP8f9UeFYxbM5msqcCh2xvHOlxQ8t1OU39AVIq6KSqZS41XTuS3n1ygUnltXH2LOSV/KSq8HV49hNJwh2yS3WcxXFc5+GBL4+YieCERZrNzbLcaV4Jajz+wSuXcCM/9B5znZwjvS/Kf0OlRGiWhdongFWqtgvzaoJB6Qotqj/AptZpOPnUmftwvgNvXIQfVi/e2RzJr6bk9W43W3d4htNj3INtMRG5wEUPuoy93VLtGZYxVJHalAu3DHDieaR2Ty5+SYleQ2QM1YlkVvVmD4RcHrcxjky0zEFTovXwC2NEQUnQs8IT6R3+uyCQqKfVDpLRFA0k8dvIc48MfQTpKNd+7NdA7Sga1ClFn8YNAubcqKtYdcBoRbK2kg73gTXWX4w7/aZzm2GdahDwSfavvJuwoYW09FWHqWa6TwHXcpsvQSzP45CscDwGGa70jP20sw+SgZ6/ZkxeTH+POchSW8iRqD8hL48dumfYhbqpiqO3peU+SLtogEvfBYSxc6Obg6kMEA==
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
Changes since v2:
- Add WARN_ON when using unexpected class. Return -EACCES instead=20
  of -EPERM
- Remove extra new line
- Rebase on selinux/dev

Changes since v1:
- Move test of class earlier in selinux_bprm_creds_for_exec
- Remove duplicate call to security_transition_sid

Changes since RFC:
- Remove enum argument, simply compare the anon inode name
- Introduce a policy capability for compatility
- Add validation of class in selinux_bprm_creds_for_exec
 include/linux/memfd.h                      |  2 ++
 mm/memfd.c                                 | 14 ++++++++++--
 security/selinux/hooks.c                   | 26 +++++++++++++++++-----
 security/selinux/include/classmap.h        |  2 ++
 security/selinux/include/policycap.h       |  1 +
 security/selinux/include/policycap_names.h |  1 +
 security/selinux/include/security.h        |  5 +++++
 7 files changed, 44 insertions(+), 7 deletions(-)

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
index 0e47b4bb8d40..2b685f9dd61d 100644
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
@@ -2319,6 +2320,10 @@ static int selinux_bprm_creds_for_exec(struct linux_=
binprm *bprm)
 	new_tsec =3D selinux_cred(bprm->cred);
 	isec =3D inode_security(inode);
=20
+	if (WARN_ON(isec->sclass !=3D SECCLASS_FILE &&
+		    isec->sclass !=3D SECCLASS_MEMFD_FILE))
+		return -EACCES;
+
 	/* Default to the current task SID. */
 	new_tsec->sid =3D old_tsec->sid;
 	new_tsec->osid =3D old_tsec->sid;
@@ -2371,8 +2376,8 @@ static int selinux_bprm_creds_for_exec(struct linux_b=
inprm *bprm)
 	ad.u.file =3D bprm->file;
=20
 	if (new_tsec->sid =3D=3D old_tsec->sid) {
-		rc =3D avc_has_perm(old_tsec->sid, isec->sid,
-				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
+		rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->sclass,
+				  FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
 	} else {
@@ -2382,8 +2387,8 @@ static int selinux_bprm_creds_for_exec(struct linux_b=
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
@@ -2978,10 +2983,18 @@ static int selinux_inode_init_security_anon(struct =
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
@@ -3001,7 +3014,10 @@ static int selinux_inode_init_security_anon(struct i=
node *inode,
 		isec->sclass =3D context_isec->sclass;
 		isec->sid =3D context_isec->sid;
 	} else {
-		isec->sclass =3D SECCLASS_ANON_INODE;
+		if (is_memfd)
+			isec->sclass =3D SECCLASS_MEMFD_FILE;
+		else
+			isec->sclass =3D SECCLASS_ANON_INODE;
 		rc =3D security_transition_sid(
 			sid, sid,
 			isec->sclass, name, &isec->sid);
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
index 135a969f873c..231d02227e59 100644
--- a/security/selinux/include/policycap.h
+++ b/security/selinux/include/policycap.h
@@ -18,6 +18,7 @@ enum {
 	POLICYDB_CAP_NETIF_WILDCARD,
 	POLICYDB_CAP_GENFS_SECLABEL_WILDCARD,
 	POLICYDB_CAP_FUNCTIONFS_SECLABEL,
+	POLICYDB_CAP_MEMFD_CLASS,
 	__POLICYDB_CAP_MAX
 };
 #define POLICYDB_CAP_MAX (__POLICYDB_CAP_MAX - 1)
diff --git a/security/selinux/include/policycap_names.h b/security/selinux/=
include/policycap_names.h
index ff8882887651..454dab37bda3 100644
--- a/security/selinux/include/policycap_names.h
+++ b/security/selinux/include/policycap_names.h
@@ -21,6 +21,7 @@ const char *const selinux_policycap_names[__POLICYDB_CAP_=
MAX] =3D {
 	"netif_wildcard",
 	"genfs_seclabel_wildcard",
 	"functionfs_seclabel",
+	"memfd_class",
 };
 /* clang-format on */
=20
diff --git a/security/selinux/include/security.h b/security/selinux/include=
/security.h
index 0f954a40d3fc..5d1dad8058b1 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -209,6 +209,11 @@ static inline bool selinux_policycap_functionfs_seclab=
el(void)
 		selinux_state.policycap[POLICYDB_CAP_FUNCTIONFS_SECLABEL]);
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
2.51.0.384.g4c02a37b29-goog


