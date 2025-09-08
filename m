Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0C1FCA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 01:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5148E0005; Sun,  7 Sep 2025 21:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75FE8E0001; Sun,  7 Sep 2025 21:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C648C8E0005; Sun,  7 Sep 2025 21:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A772D8E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 21:34:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E87C1408CC
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:34:37 +0000 (UTC)
X-FDA: 83864363394.27.CC90E5F
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 775CF180003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:34:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3LrofLGz;
	spf=pass (imf24.hostedemail.com: domain of 3qjK-aAUKCFUGJ1173BB381.zB985AHK-997Ixz7.BE3@flex--tweek.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3qjK-aAUKCFUGJ1173BB381.zB985AHK-997Ixz7.BE3@flex--tweek.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757295275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3JlhVnol+judhUzzwOogW+HmLUCIc8LS+J6IJKltRJA=;
	b=ndfTHq1xR5TxiJW4PKWZrleNyAz1cDMQtGX3ucYRCXpLAXa/kMj1WmavlaB5lleGnANyB0
	oJunF2982QjhHG5Kf5f//LAWqHOOD+udPPhakGVFlxwiOgohjqP0ywP9YKNaBCG4FStPGw
	FYN9o2RRM2Kwz8tXiTKV3tVeE1cBT1o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3LrofLGz;
	spf=pass (imf24.hostedemail.com: domain of 3qjK-aAUKCFUGJ1173BB381.zB985AHK-997Ixz7.BE3@flex--tweek.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3qjK-aAUKCFUGJ1173BB381.zB985AHK-997Ixz7.BE3@flex--tweek.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757295275; a=rsa-sha256;
	cv=none;
	b=56bVeRUxa4Xx6VWJG53xmdxHQ8tFfFadMwkzST6rqhK4TZOr4CaJWhzwjJdvveRVHE/220
	EbbYBFAkySeQSHzmPSPVsY1etn5ZPlvf3Ibe56A2nWwPIlHbU8j5as2pX84p0YHxaWZRBu
	ezPsdTreAMvQEy9oX40VC5/xsHJdBk0=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32bc286bc1eso4928313a91.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 18:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757295274; x=1757900074; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JlhVnol+judhUzzwOogW+HmLUCIc8LS+J6IJKltRJA=;
        b=3LrofLGz6sskKwhJTcu6ISFftHtNqVlJ6v3PQXip88+QS54zpHtDffmh/N7Yrt2Blf
         NdLhbtycV0KWZx/4qCJLUkciOU7RqfbWRxGW22bLgs18bLdu6/1W13uaKBZTbHfNDHzx
         NWIxe2rX7yCkwjbWJBPNbFGdxf5dl6jpLW7+glXounv9ZyXfnWKMaXtbeJf+ZcitDOqf
         o1EeIaIFf98cgJ07AfrlEDSyhxZm1eQbsUtLS6s5zVKr2XDCNJgUf/bnOJbUdL6P/0aD
         IylngDTPC+BRle7SpDxh3WzV9rMXYXfN0ZTQOKYph3ecIQyQPWJydWyGIVNouU2UhaK5
         Px8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757295274; x=1757900074;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JlhVnol+judhUzzwOogW+HmLUCIc8LS+J6IJKltRJA=;
        b=XMlhk/bpU/qT7mT5mmhVMsvHpjHMuEK7Z6Jq5nqbXqx7CtflhWpOEAUCGxHcaLSN9u
         EqYN884yT48it2ZgIX2MQYfMoTZ9KGP0a5yygzXUUxezVyVRXUTbK5viVeE5ZAsdzM0U
         k2kfEi6ABWs2seH7whUy+oMWNPep2/c8x/sDISq89N/VWvq5J7+CWw+ml2E+rvSwc2JC
         h6FryQkKRdEMnSn5wU5XzU5RAiyGSpZ8nRHuma9MKMp1f3z1qCnMjslvMKruwoo8yYW4
         Oyz1QPsLxdoVbcUznsmx5biqPKScPEbhbxq0e0vYqtP12X2iAQ1TmaQ3UKmJa8tg8oPd
         ohhw==
X-Forwarded-Encrypted: i=1; AJvYcCVt8vAvL4TOCjWStLhqqpl9mUeUalGnbH5lzjsJtBAYoDnFKBuUwMjN6XDcMFhD3MJpoO+Dp73sdA==@kvack.org
X-Gm-Message-State: AOJu0Yz58Op8SYpTY+EHB/s0eypUHh5vCjkj+94hBFxT9tCV2aj77mbB
	AVDJsK4cf5rkl4iMADUbfSDyGSxZwgusFbB9ZDLdcH1LyVdqyBe6RhzliIUoJHwfEiMsNW2+Xj7
	1kA==
X-Google-Smtp-Source: AGHT+IErnV8Y/Sanjw9YO0m3nEGzcg/9CpvlG17Upovdj3N1XyUdkWC1vRs0c4mbxBDPi5LS5Z2j0ehPGw==
X-Received: from pjtd14.prod.google.com ([2002:a17:90b:4e:b0:327:50fa:eff9])
 (user=tweek job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:530b:b0:32b:d502:6ff2
 with SMTP id 98e67ed59e1d1-32d440d9ef6mr7330684a91.34.1757295274251; Sun, 07
 Sep 2025 18:34:34 -0700 (PDT)
Date: Mon,  8 Sep 2025 11:34:19 +1000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250908013419.4186627-1-tweek@google.com>
Subject: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 775CF180003
X-Stat-Signature: ndinkk8sjenwbxrm3rh1ggdqxbzxpkk4
X-Rspam-User: 
X-HE-Tag: 1757295275-452517
X-HE-Meta: U2FsdGVkX19fGtIu4mIJTF/F5aHqD/9B1zSnCDjKWKqctwqibGdvCgxkIE/pse4M8F6oFpacB2nC+cO2t0uArlU03FNHbbiOCvLNI/EqiYu7m/UbHdR6UytJMdhC5eSi4lvO8n4vmlCKEY2D1cJHwb8CMD0mEtGX6pHgGN1whjdTk3PZjewDRxpKt5JlQ41O15yx9WeJJhqsbzijHCzdTT85x5wza9JMvVbhIcv6Nsc+pX/VJsiCGHbynFBr/5ID9YIXdNrB7840ExzqPWDnPvKTbaEffqw81U4opTypIRj1zq9kINbNjBFa6p1E3lcV5BUU4lHZY6Jfw0gvn4iXUoPDFO3kJUYRFNnXRSbTRjF03Q0Aqw+r/k8+V0ZHF24dhpOCyqslebB+C9Q6Sp+zaLA4cqx0NEN6K0cftN9j+3vTqNCMC/E+IhyF2ZWjhfkzoniF5HLQBwz++ZrKpq8HYI9K/73wRGENtsTBDJVXlJu+Au6veKU366D+++ye6SbhEPgNAM7zI5n/YXJ8QJ89jZvD0v3dPFiZOQCF9t2+SKnfNkZ7OGkXdWAFkReRfQ0mjb8G7jOqAyiKn4fmkPmplRxqeTfKy8chGNVnKcNBbET7JfH0IPy1OKKMiPJg1Q/51kPDcTDhiE6eagcR4JfJGQ9LiC2rOETKbMwZPInr9Bun+tokLwvKbHYxvm77aevAR0MLr6N5xG9ytuIabkilJo3ML8X4XQz6NWW8D7YNuHAmekG7fIN1O6xR40DAFI7Bi0u049JXsUrC1jhX7Vg5szT23jM4Xi5oopy71wn+XjhL8+twfTj4jFB6tqPYudz1zMMmsKJvg2eVUg6TGzRL0pP7QqJrCzxT51lxu3JVsIfYPaJ1Krj+fnceJXpBFMvg+kU49nDDPG9rv6k/46sowb10OubVaWW4CY5/fToxq9nPNPVDnfMrhTqqlV9RhcpIOxWbhBTPOyzf647i/ek
 NjYI0pZq
 MyLdtK2JHFJB8ptqWl/JdQYTVngCs7DvNv+ClUvpVd/fFwHWGKyEk5XBqYnUPSL8KijzwpuEwLImr6yDyztt9rPoEexvnHI/Xwre4XOHADAwsw6+eCb2U6fpmk6qNA8QP+vh3eXVj0Xzzy1G5m0BxzP//c1G8JASwvU4pe51/EZmDY1SDdQW5nYtsfq++1jEf7CQY9kIWcWsosj0ADsq3CPs/8HQzoqcJtg1VtK6N6GUkOM5KHE2crcm2Vii4va961CaOIhcQ90nUt2HnbXU3Zy1quvUniwmMpLCzTZrazRWRcNNo+hV0KUvMAOyGop4N7EXhOdbDWJZXuWyX0iUWrV1yAMjr56GokbJmqUwkyxs0qITWsxhsXsn1K6uBsPagyKP+DXdTQ2h1acxyq8NTyh6azRsIMFEVD6bfmBzMdRZdAi2Pmaikvd6slg6kMHFDkHgjNl3CSAsH2CxbXxRuDwXrWodaCPM80ZeSjD4pwzIULtOIZqzwz48W5eqkWtm3NhbCt2AAV8gGn0MOqNu1y2q+jXbleJc0FGOuyV0B3iwOa9w1KsGXJOjnVpQM10o8A8vFNRk6oYFO/CXobL20h3W4EPVgWiH9dJef7alGGyPj8oUwTg72+xGGOL0fPTOBMHlpjLv4Bvc4oVMDVZ6cEHLFAB49rHnnypHIh163Kbpf16hJg0FyFJaGcqrU3o4LhS6BLb+bfhkXjqqW9LvmbzSe5jL4+G32B1Atefj+qecrIAoG/QyNCcnj/YxNjEzYnPZnlgNPKNx03endD/2jdklcu64wmoVB4I1O8Z7wHSiHZ4j6dkBoe404GW6VN3KVjQx1QBHO7fZDIvbL6+WUsxtNPLAeywY6O9t9iEtjf1m92nc=
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
Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
---
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
index c95a5874bf7d..6adf2f393ed9 100644
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
@@ -2315,6 +2316,9 @@ static int selinux_bprm_creds_for_exec(struct linux_b=
inprm *bprm)
 	new_tsec =3D selinux_cred(bprm->cred);
 	isec =3D inode_security(inode);
=20
+	if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS_MEMFD_F=
ILE)
+		return -EPERM;
+
 	/* Default to the current task SID. */
 	new_tsec->sid =3D old_tsec->sid;
 	new_tsec->osid =3D old_tsec->sid;
@@ -2366,9 +2370,10 @@ static int selinux_bprm_creds_for_exec(struct linux_=
binprm *bprm)
 	ad.type =3D LSM_AUDIT_DATA_FILE;
 	ad.u.file =3D bprm->file;
=20
+
 	if (new_tsec->sid =3D=3D old_tsec->sid) {
-		rc =3D avc_has_perm(old_tsec->sid, isec->sid,
-				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
+		rc =3D avc_has_perm(old_tsec->sid, isec->sid, isec->sclass,
+				  FILE__EXECUTE_NO_TRANS, &ad);
 		if (rc)
 			return rc;
 	} else {
@@ -2378,8 +2383,8 @@ static int selinux_bprm_creds_for_exec(struct linux_b=
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
@@ -2974,10 +2979,18 @@ static int selinux_inode_init_security_anon(struct =
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
@@ -2997,7 +3010,10 @@ static int selinux_inode_init_security_anon(struct i=
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
2.51.0.384.g4c02a37b29-goog


