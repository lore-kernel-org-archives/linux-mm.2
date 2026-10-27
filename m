Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBE6606A326
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n7yoXSGq
Received: by kanga.kvack.org (Postfix)
	id 1AD7D6B071B; Tue, 27 Oct 2026 09:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1855F6B071D; Tue, 27 Oct 2026 09:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BC36B071E; Tue, 27 Oct 2026 09:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8D686B071B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 675111409DC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:58 +0000 (UTC)
X-FDA: 85368423756.14.B6FFB36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6EB1020014
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7yoXSGq;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106236;
	b=Niwd4mo6hk9H4UlxhDPZNs8vybLDo8PiK50YBOlW7NMegYwzfr7vCAEaSSoR0Nngi3YWH/
	tbt4WPTYPdsv8PRSCmq9cT7Ktavv+Euc7Cj/g6gYbpFGOSN6aKZBePImbM+i2RvtFS3dJ5
	eyho9Bdsc+3qP8VzIp2Nkb+p63Fi/mg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n7yoXSGq;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hC55Qi4eXuQIoCZ99pSQo79BaI1KHhCtzc4eGRsCBL0=;
	b=PXHOSLz6aMovwUXXN2jEo/0OqrEnAiAxaWqLpIuuwyTRH8gjQgFIVT8+GEhvGtMhGEdSkU
	D5pEyYz1oY1azTrRncJvauCr6iIzq0gzO1xJyvtN84IiCMORkII3wnRhKJfQ+CHB3XnN0N
	BPpZAzhJEasue55ykK+8agl93fyZ85Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA09E40855;
	Tue, 27 Oct 2026 13:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4A01F031E2;
	Tue, 27 Oct 2026 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106235;
	bh=hC55Qi4eXuQIoCZ99pSQo79BaI1KHhCtzc4eGRsCBL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n7yoXSGqMdjXayonbQf+7G66wu69moojGkJmCrjbkYB0pO+QxUBvF57OvURz5rv3p
	 nHTiU93jJ1BnhgCYUkly6l9+tlIM+PLAP8dDeR9ZqCoVNsL84QvUoxYTMsDszHlJwH
	 dUMkAfzX/DTqL1b/xY1Kv3f9kKdT8fRUlq32w8pbVVNZ24mbcqRy6CeB2GlZ3twejy
	 OLFEzynVlJHijihZ3jr52JMWgRC1Lvb3vp/Dicn+U68YTVGBE9ZttSpq5i8PoUAhTp
	 X+vdsK6OKw0KlwgnLE9nHuvZswe7C6JlO2S7+Kbporx9/q24oK273oNnXpmiZutPKm
	 oL5dsN8eezsfg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:09 +0100
Subject: [PATCH v2 04/14] mm/shmem: honour F_SEAL_EXEC when an ACL is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-4-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3836; i=david@kernel.org;
 h=from:subject:message-id; bh=Un47mrAj2u61w09m+y/7O22VTuewKSP6t/UBvELblto=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBR4dGjF0q1Tr8z/fH3Lq5BkqVo5G+6J6+S2hzxT+
 y0Y9rhTqaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJeJ5j+O9kL5Sikbv6oQ3D
 /evTs5LepuTUm7zfKpQZ92VXzfns83cYGe6a77jqsuKCsnul+SvRNkWerJNczRF8S+K9fCa9jqg
 T5AQA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 1hx1dyxr4rbq4do5q76q6gx8qfkstiw1
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EB1020014
X-Rspam-User: 
X-HE-Tag: 1793106236-61879
X-HE-Meta: U2FsdGVkX19U5EZPDYlKbT85tkFVInCTqjTlmHzIW1pQV6vNVn7hd9kkACvDPvlKS9+dPpz18frCm3Zg9eKWhOrf3Cldx4JjzFMNs8Fhk2LXmnxMG9OnOVXnjVbgJc8hysVrcddiLCGO5WQW5lBr4d+r86az221Dq1sIjtP3SLY3lw0+F6Y8eVHTIOhWraOeIkomxsn8fR8JordUaQWEdfKES2Dgpn4H+K0TMigKZ/uK5Kz6Q6S52RQClr2x0dSOpfPP9r1JHTP+clLExjInXK4A7heZre+/AX/RsSiowEcXMkqGQmOn4SSgkcEm5raDS5G7d4rUZl4oFOGMeBg/33FrKUGGkUbCj5r3YWUXEHebPLseyDiJyytEJeSsgHIGlaoo1ATX3WGGzbd0BRLbfGekhujPUKuiJgi26zarIjc8Op4pUimA0n9stan1YrobP/7VfxUap3bvSXnRYzi3EET81QNIHEeAdQjn87N0ZDmjWrAmGBZ/FQaSGhKaCBBPLMgoV9itG7v1fTA1kMlHidkS3Ko3mLqlDJIjGS55S2w8aCNsYUto8SijcRDVGeED5oPDFQYt0XVg/L81wvLxV/W4bqm8fNfYSxEL3ZHlhU2DPVUyQqJjT9qrdrixwf3S6SiLzvyP/Ioyfi50cAaf61xXUSFCh2LTYsqgqdvr6hqeDVRPDmF8JHxtMyWNvLsVQ2LsvHCmxqdGHtMMZUoA9aWgwCM8S5TxaIXb9uIGGoAWNO+gGLGcz1MSd5BZmvV6YeMcRoyN5teWd02bF3ZUbikr2lAB1U2VmyfulC8MIdu2xydvmgD4mEgEV9RS2ar2rW4bfuRnJTB0bIoMW3RumV7kpl6KlQ5wiBxXGa1Y1VD3EDQaBidX3fjr+nnQii6qGmosFZTpldS8mBvjrNAdE/7/MAEFBjWVq4YzUoVrgAE4hOXi2etwagD81G3nJCiXgaVa0OKMT6Bj5URzAv8
 zX/lat8d
 1un2FznFXjIzfDmEeQ9xCbhVjEm7/O/fv0eyPXz9lDnE+34p79tGFsAkaJw+ur45ia4r0y0x+YC8wjRrbtOZjTea+L5esprZA9KsmWxFwF0qvtDv124DgWmjgKxC+k+JGahhTv01k0WTuYry28hIYMGoFISbExgnULVuvGQrgMxkkQWh4bJnVeU6xSFuogXxAuOmPt5wlvjIkTPai6ce32Yn/06tjmVBecrKk+Lnxqv8A+bBZRtOLQ6izK32wVHMiQXoX+y2G1JO8IRMB5a3AvmIwSl3nd6VpQTQ29I8VTpEMaUdkFjqA+xgt/LOrzXx3HQLOWr9rPhK98wSxcXw6dntxpjSAOJ+DlK+PTGew1t3OYN3hjmcgUHOVHyeUyMdNHruA9qRh5bWI+kCYtI0MHUDQFV2FGeg8qtbB5gSXmsMF1moHwK+ykB0hd+qJt5Wh8ydpW/swl+J1Hbg/pWw1zx6t7SXEGtuiqG+H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

The owner of a memfd sealed with F_SEAL_EXEC can still change its
execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
this lets an unprivileged owner make a non-executable memfd executable,
bypassing vm.memfd_noexec=2.

simple_set_acl() updates i_mode directly, bypassing the seal check in
shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
in include/linux/memfd.h.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: use common helper; simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memfd.h |  9 +++++++++
 mm/shmem.c            | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index c159e40e3f34a..272479317cf10 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -2,10 +2,19 @@
 #ifndef __LINUX_MEMFD_H
 #define __LINUX_MEMFD_H
 
+#include <linux/fcntl.h>
 #include <linux/file.h>
 
 #define MEMFD_ANON_NAME "[memfd]"
 
+static inline int memfd_check_seals_mode(unsigned int seals, umode_t old_mode,
+		umode_t new_mode)
+{
+	if ((seals & F_SEAL_EXEC) && ((old_mode ^ new_mode) & 0111))
+		return -EPERM;
+	return 0;
+}
+
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
 struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
diff --git a/mm/shmem.c b/mm/shmem.c
index fadf23f9e21ed..ad644a268c0d2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -77,6 +77,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/magic.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
+#include <linux/memfd.h>
 #include <uapi/linux/memfd.h>
 #include <linux/rmap.h>
 #include <linux/uuid.h>
@@ -1546,10 +1547,11 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
-	if ((info->seals & F_SEAL_EXEC) && (attr->ia_valid & ATTR_MODE)) {
-		if ((inode->i_mode ^ attr->ia_mode) & 0111) {
-			return -EPERM;
-		}
+	if (attr->ia_valid & ATTR_MODE) {
+		error = memfd_check_seals_mode(info->seals, inode->i_mode,
+					       attr->ia_mode);
+		if (error)
+			return error;
 	}
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
@@ -5397,12 +5399,35 @@ static const struct file_operations shmem_file_operations = {
 #endif
 };
 
+#ifdef CONFIG_TMPFS_POSIX_ACL
+static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+		struct posix_acl *acl, int type)
+{
+	struct inode *inode = d_inode(dentry);
+	umode_t mode = inode->i_mode;
+	int error;
+
+	if (type == ACL_TYPE_ACCESS) {
+		error = posix_acl_equiv_mode(acl, &mode);
+		if (error < 0)
+			return error;
+		error = memfd_check_seals_mode(SHMEM_I(inode)->seals,
+					       inode->i_mode, mode);
+		if (error)
+			return error;
+	}
+	return simple_set_acl(idmap, dentry, acl, type);
+}
+#else
+#define shmem_set_acl NULL
+#endif
+
 static const struct inode_operations shmem_inode_operations = {
 	.getattr	= shmem_getattr,
 	.setattr	= shmem_setattr,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
-	.set_acl	= simple_set_acl,
+	.set_acl	= shmem_set_acl,
 	.fileattr_get	= shmem_fileattr_get,
 	.fileattr_set	= shmem_fileattr_set,
 #endif

-- 
2.43.0


