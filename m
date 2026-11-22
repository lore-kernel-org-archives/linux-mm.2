Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F75F606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T28tb/dn
Received: by kanga.kvack.org (Postfix)
	id 5643E6B05B7; Sun, 22 Nov 2026 14:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D376B05B8; Sun, 22 Nov 2026 14:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE306B05B9; Sun, 22 Nov 2026 14:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA616B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 912391C3FF7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:20 +0000 (UTC)
X-FDA: 85463761320.27.516E3A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 018C912000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T28tb/dn";
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376179;
	b=PpHyJ1AZ8wOofZ+OPKOHQUYdufiRl0++gwKjceJZPIx177TmYs96IufA/ktphYhDPcaHv0
	Deki2Q+IwZA508+KwsUcER8x9WCvvTkylg21lEYukTjL0nMbcMjWoRTso0Ny6P4TfwNCK5
	QajCAwNh+FZ/QV/Zi26RfhzgirvVzYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3BxF7eKc8H9WX2SeKI00rPkbSvVT1UJBee/DhqmTQQ=;
	b=xIiiugMt/P+U30fVlYJm9ZALbPth+yara+24bdoHO6Jzkz9lQlirGPwzPRGYEO+2XzUqhV
	ebvu3Q944hCXcHrjP3+pKTjPP0Ipvb2BZIjVBaC8jWN5CxP6WFzJ0uzqBEJ7ezxnCOXiUC
	4TxlGT/FXeBFjEqWiY+sCXJHIJeVVKc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T28tb/dn";
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E83E043FB2;
	Sun, 22 Nov 2026 19:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09FC71F000EB;
	Sun, 22 Nov 2026 19:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376177;
	bh=l3BxF7eKc8H9WX2SeKI00rPkbSvVT1UJBee/DhqmTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T28tb/dnYShrqpGI2ZILYjzh72RVEHrrezyrm54oR6Obd86v3PTs376d9kZmGiJB+
	 MUaqau3YQxX+z/GWr+9RG0JDb6bK1vqUMm9l/H8m/RqGDXDxO5ShNJ6WPrcOKQFN72
	 Lp2v8MzuVi6Nq52IkFkGidmWcugTYAZverSueVjAgR2lsfg4eHz5f+C9qJscWQmP91
	 UvSv7pZiNTWpbNmSdj6YKT2dG8l982i7je4+oLgBuBdSEu85qs20Ob4lOnj9/OCG2z
	 aSfS6cai0B+r+urHqmyerKvW0s6us7upbOBQhpzjuP6094eRFGxT0XybG4NqwQpfnw
	 74hvHOnQ9kYMw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 05/26] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sun, 22 Nov 2026 21:35:18 +0200
Message-ID: <20261122193539.3334213-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 018C912000A
X-Stat-Signature: 8t8m16oramnjbom8tuyh8cxgegdzodjw
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795376178-121550
X-HE-Meta: U2FsdGVkX1/5nmj5ZYQoijej3fmiSRqqJBJFdd0+KkYhSMY4sgHpo2cMY7SXewe1YQib4pANuH6z9oTVH8GtG6DN+pAc16MbhJXyhu4s6yJRpGvh+JYVohWkwaNNbgioqkyQr/C891/NFFmwNa51GtU88oLGniHaYIVUQF/KWwTKo7R++oCZi1+mgyUuDauyGEy6wAvzOIo5VdtZpIPa0D0NaJBs0f+B2oSmbmZYZ5GjLVFBmWlnQnrxgiPZv3gDDHXZci2MRIUbkQ4zYg/IkXzz+htQeiatZzyns8ezXzxZRhRrAOvpwHHVR/K36G0J53L/2aIxxwODzthuZeheRvw+zeeRVxOnVoLyZFLxvEw7xXN77ZnConn4s8UXpIbWgDbCMtiB5CF4z/Mz/t2ytURbvZ4sGYFBd1F2owjkT/nlrizzyXz2NsPH9GKW1JB/VxgGkI/CxvTZcqkkIGyrhPrcVofwjioZaqS4x1YFK8KCR/nGTQ48blS5C77+VRS+HhsnAlskVMLQu3+35lDaX3qzpfjA/SByyoHogEx3vtFH/ZEP7+dSqvAP2BDmNz4EMDfxyzMQOv3DvNp0eVNUm7mIDwSoNEvhD011ZgoK8y0Uqv46YwbBIgdIveWPHWaEOXr4vvyBMYIzQwEMkuXnSSIaazdxIwoHaEhrjiRaSTwXFzomkQv60yQSfADWn+upNKJwXn88r7m5nbEwb50OABij9VVw1MRXFV5r5PApEP5JdAtZH6OwuQOj0LywYARt3TeX5IhkyXoM4jr4KHKEoYq4mZGoRgVTrQ3xC8yCCHcynJ5xlit4o8MiDvNoVO3CnB5JC94giy/wrJRnAcD1dPpCr+R2G7G4hOJnIIcnBBmd3VfjldDsVZwR7xxr3fA2ITRfX8UrcXV3IgLnCV+RzO+dm0x7fPF4kiBWMStbpUtHpF03pwCfAZgP+HUUvoVOojQ7c3JDiwe6A5R8tzO
 BOoF3xx0
 mG1jPPGMe6zzTlc5wsJOn2KSQlIyiXNE/dL1R6wuSioUVQb9LZAWQJts+oQfBZrc9PHnW3OrX0eU2K3q2VYEP22Vg4+jdFRH44V+APJVRopX4YREwPUVCWV9gBbokDDhWy7HbiW27GSumzPcjsrGf/GK0GmG54t2aDBA3r0Un8ywxHckrGIlqqbecNKelCw7gk5fFZcHLlbjOSIYT4Ykgq+G79cwGMGn3zlvdzY/M+zmCf+9viBzW1Ig+iIp5ertNO/CaWKsX8oTyCrhBophgLJXyhNL9aANoRsXB2ZKNoj7Iwobq78uZ8QRyqZyn9GD8I7MOow2CvsLQ5VL8IjpgDKymQ0DtR65bj67BBr4S8Vkr9TyUoeImuIwCgAduR6sEugryts2KL/QLGh//29bw0+JKapauJAOzb4VIt0bfAgEJ6+52WMCOFe6RAk/oPjZURps1Ru2EULRy7oZs6aaaM005MpJone9eZhc0zNZWAWgbYlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mount_too_revealing() skips visibility checks whenever
current->nsproxy->mnt_ns belongs to init_user_ns, assuming the caller
holds CAP_SYS_ADMIN in its current mount namespace. That assumption does
not hold when an unprivileged caller creates mounts for a child user
namespace while running in init_mnt_ns or another foreign mount
namespace.

Require CAP_SYS_ADMIN in init_user_ns before bypassing
mount_too_revealing() for init_mnt_ns, reject chrooted callers lacking
CAP_SYS_ADMIN in their current mount namespace, and treat existing
mounts and child overmounts in a foreign mount namespace as locked
during mnt_already_visible() checks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 781380945d78..1bb9f90a6523 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6580,7 +6580,7 @@ bool current_chrooted(void)
 
 static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
-				int *new_mnt_flags)
+				int *new_mnt_flags, bool foreign_ns)
 {
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
@@ -6606,11 +6606,16 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 			continue;
 
 		/* A local view of the mount flags */
-		mnt_flags = mnt->mnt.mnt_flags;
+		mnt_flags = READ_ONCE(mnt->mnt.mnt_flags);
 
 		/* Don't miss readonly hidden in the superblock flags */
 		if (sb_rdonly(mnt->mnt.mnt_sb))
 			mnt_flags |= MNT_LOCK_READONLY;
+		if (foreign_ns) {
+			if (mnt_flags & MNT_READONLY)
+				mnt_flags |= MNT_LOCK_READONLY;
+			mnt_flags |= MNT_LOCK_ATIME;
+		}
 
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
@@ -6629,7 +6634,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(READ_ONCE(child->mnt.mnt_flags) & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6649,14 +6654,19 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	const unsigned long required_iflags = SB_I_NOEXEC | SB_I_NODEV;
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
-
-	if (ns->user_ns == &init_user_ns)
-		return false;
+	bool foreign_ns;
 
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
+	if (ns->user_ns == &init_user_ns && !foreign_ns)
+		return false;
+
+	if (foreign_ns && current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
@@ -6671,7 +6681,7 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	if (s_iflags & SB_I_RESTRICTED_VARIANT)
 		return false;
 
-	return !mnt_already_visible(ns, sb, new_mnt_flags);
+	return !mnt_already_visible(ns, sb, new_mnt_flags, foreign_ns);
 }
 
 bool mnt_may_suid(struct vfsmount *mnt)
-- 
2.47.3


