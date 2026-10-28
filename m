Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C47606A338
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eXXJKrHl
Received: by kanga.kvack.org (Postfix)
	id 2C8B16B05C3; Wed, 28 Oct 2026 05:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0546B05C4; Wed, 28 Oct 2026 05:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD7D6B05C5; Wed, 28 Oct 2026 05:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0065F6B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E58040C05
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:57 +0000 (UTC)
X-FDA: 85371578754.29.9D22858
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD47440008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXXJKrHl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LytyofYNhXIrkgDpuu8tsdZMh9q/66Muy0JGRU9/q5g=;
	b=ncxlctnT7kLMiyibC4cGC0Wcn9PrdpQpmkGg0VaKl7qjoUoE7vSTejd2GFu1vRMx2w+tBY
	KTXG8mwqXcyi3JK2QNW9BQuGpOUDNF7sybqCHfF2WqASfZwPjYKmoFMK0ViLvwCrsCbur+
	zBmfaZfdJjXj/S7dDe61mT5vbxVRnR0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXXJKrHl;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181355;
	b=az0qMFsMk+8HZSz0zMWW5QYZt5Khse1VlvtfuiiDQ5RdREWmOo4bPynrClL1oEvftvG9gG
	ysSZ/eOUyBFvjxG9qRr962KI43rTCUYztMKx1fxTkGiXbMmAz9RB1MpxKP8O/73q9/CrIG
	JGNgnt5Po4ChDAdmo0Qso/OSZNaEAdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A057600C8;
	Wed, 28 Oct 2026 09:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF4E1F01825;
	Wed, 28 Oct 2026 09:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181355;
	bh=LytyofYNhXIrkgDpuu8tsdZMh9q/66Muy0JGRU9/q5g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eXXJKrHlfKOnCoUmQEb5dhXKVJl8fGP/nZMYgqqCLwLhBYDlXfVSqSPvNZUMrJ8Hd
	 IsGSOtTUrRWhjqFlVQjwUvm2m21jhZ2n6FOTy1IDEjiUHJTC0jpzq/QnjE4um14A4w
	 0breH3BvgoX7jO7b/SOKuj1JsinoiC2Km/xiaEUeRUugfSzqaZDcEAEaKl2M2IUvuM
	 3iYudVdLTUqe8pZtAEjIYj0UPSrlgZ5UCLZDqwRKp1jy+Jgv9AOo3NU+m2aFGEwNWj
	 E8oIoaJV+ixqGnRjOOhBzLjvZbeTPLED57Nwey4Iy9PjoTBcv1Y69Qwlebk9LiUC4J
	 t7zayUKQziegw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:02 +0100
Subject: [PATCH v3 04/15] mm/shmem: honour F_SEAL_EXEC when an ACL is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_shmem-v3-4-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Pratyush Yadav (Google)" <pratyush@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3904; i=david@kernel.org;
 h=from:subject:message-id; bh=CFNC+JPqed7vXaXG6PNtLhwhDnB9KggNxDs0QNHpGlE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmucu66t9pe9xq19S5Pa9jPwdUm+0FQV949zzRaNe
 pMXln64o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIl0qTD8dxb96vz2Yd4jGdES
 s9K58x+YCnkJ6HQdPfG75p+TW//3U4wMOzfyK0w78CLl5MXVGbJKqctXHJCatd3GXZr5h/+M97E
 6TAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD47440008
X-Stat-Signature: y89t7779uxknqh34swo98w1t9xompxwe
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793181355-628166
X-HE-Meta: U2FsdGVkX19MdU8mhE3/O3+/KELWrhI2DCjOHY7aE/Yds4vJffGQMn+dquvcKVHULQnbAeroBV6Jlek0GywIqfUqU+oOZEiThKAG8jD88tJFy+8uI9WwODVINwzDjvd+2cLqaW8CsrD82/PVcsU5/lHo2q1nkWwkCBNHP985MPe0bPFgIlJNBISr+vWCCOgTHRv7dspRAgNr9L/3gWWbsbD/OyaPPNL2/pVnGCf10ncm5POPeTfOYAieM2E0GUVT/i1l8b9y7CGvj+llJJZCx9unQIjG0+YZUi/eWwlSFD2IZn+T203U0GCh8vQQJEXv0D4i3Dlp8w2dlsuoGGNwk/2JtN1RFRkVcGbPh3xRGUzENthS/xk18cIZB+jcHacVU4WE/NC+eE7wOgRk3ytFDo7ODK5PCAvHMFd5QuzeNZPpih/TlR7BnB0Z4BBSds4eVq78+P/og7y43293l5+e8mcie0F73iRETNSzgKaMs1XhXboQURZvn+EMc6FVCXhYC/yhdppCebbCzRNEHTeFM3M3YcfrpjWYV9xcOsE2ONULNXAGz72ne2RhvXi0bQGxVUAk5Z/D1uqszkS8O/ls1+Dbk15UQgCFBEd30ifL0I6mQkWZ9lfi9zL6WHNFrjzdWW9vNFdmoY1gEjY1nMX5JDeVsFDKFIKg9JeqsLPkFMiCzREMoVzBguG2nELJ4Orp7TK8HAitlPINDLCQs/+FzjxwhCXIWkDHbSo9lV5BDGcTNtTecCSvi3lrW/qGGU7ZC0cy29jEhrHO+7a3qS40Pgw4B11wAcrM1dyhgCD6DaEgb9wGt69ZtDfdsSvtv+BxNmFVjs1+FN+cWcl1UYiJWyS32vR+de+2p3AKrnVmeV48W2X0GYOBcvnrriP+jrKkRqx1uTtvJIJsxCwZHTu5vxLWn4PYL/7mAWSCqmFfIwNpnWXjilfcYx4m/giHovybwoVr+Fc3Lhe56Hycrf7
 LBgT9fXk
 1QxQQhR9Och6/wT6xzdZwpuw+HSNXhVK7dZMKNmd4dofl+c6a2dhLQ+6GD/4x5G6q//9/LJfQeQEQ5TUDjn9DHmI/fbNLNRRjtkV3HxIAs4z+IvCcAJOb/HyfhvdASUo5SPPyG/SL+fFBJn3eSw33q+N8aAR/htP/zJVKIreSyu5Pjx7b1VBS1AQeGzYmIesAbr0UaTQhIh/OmHId6snY7lXWX8o40GZBoudRSzn05X8+RoSm9kJk/yBSxBmsMj73fSR5YkL/fovyWOkT7qA4GW3QClJbrPXRjuxgJ7A8wyrjQ7Tbqtw3B5VFHLeB37pyiW1Js0CrXbb286HpNJO8dfwtmEkw0nhCtleoh3we3ep3ITDX8rayy3lS2r/YQ+zya1uNP90tLXWsENDOcg8l7rEAsvZCQIvjTZL5KhdAXgRzlIenHUgCoA5kdzuAkVObZr6irWR0sbO+1gq+8aptmwHVhg==
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
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: use common helper; simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memfd.h |  9 +++++++++
 mm/shmem.c            | 35 ++++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index c159e40e3f34..272479317cf1 100644
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
index af21a89abb0f..e3e4bbbe1d80 100644
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
@@ -1546,10 +1547,11 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
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
@@ -5404,12 +5406,35 @@ static const struct file_operations shmem_file_operations = {
 #endif
 };
 
+#ifdef CONFIG_TMPFS_POSIX_ACL
+static int shmem_set_acl(const struct mnt_idmap *idmap, struct dentry *dentry,
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


