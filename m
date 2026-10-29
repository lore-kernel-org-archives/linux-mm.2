Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B954606A334
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Woa2OEJW
Received: by kanga.kvack.org (Postfix)
	id 807016B05BC; Thu, 29 Oct 2026 06:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7903B6B05BD; Thu, 29 Oct 2026 06:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F346B05BE; Thu, 29 Oct 2026 06:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3796B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19CFCC033D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:28 +0000 (UTC)
X-FDA: 85375329816.29.D193012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 543F7160003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Woa2OEJW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOPqNjFIyNMjGQIVaFLnlrMyaON98XJ7uGf9Dl7Z5m8=;
	b=sa/FVHM1qHBph5Nr4p3aaOjGKOAjw4nnmjf8VJ7WNDpJDpKN1LnVfVi2G7KkzH4R0BXMlO
	6G+gxGLr6pgU2FAlGGnXxwIeviD6OHOZHzJ4JTuNnQflx1JHB48x7rq11Re28PVhQqfKfh
	KfyK3aKwMcUM2ntrCmQ4doeaJWVaWHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270666;
	b=WsFXfTMEhUmCJHnFJbHduqbXTRrQ92aw1JArNvvH0oQj0ld2IGm3Y0UC48KF/iMd9gqvqA
	IXOq5jV1EJK3PTVajkwT1HODhFJCwtT25UgUS8HFaD19iQWxMGeORUzTzrQaVsnmVtbCMd
	C1rvC1yXzQ8dSg6IK2XQeBW5Kt3voM4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Woa2OEJW;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB50C60219;
	Thu, 29 Oct 2026 10:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE52D1F031E2;
	Thu, 29 Oct 2026 10:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270665;
	bh=VOPqNjFIyNMjGQIVaFLnlrMyaON98XJ7uGf9Dl7Z5m8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Woa2OEJWUIPj/92KA5rqxXr9SGac0Zt5MiPs89BmEf5bQ+4UXzu9ad1/4l5qTW6Bt
	 45qhW6DRWDlZx12I4KR+YUVabee3R54XORAoZkdgDCO3YCuFyBXQSWED8bZv9Q47uj
	 zqXjMYExLeGPXqm3iJeKhYSrLCTaXmgR7uyZ1jFWqcjTnD30shJy819wtM0tsuyBGi
	 XbsX2I0yFQHnrvPvBrUjUkwa/WrGkoEjfBzFFiUyTHl5Hu4POWMiH4mISZS+o7acpr
	 RCF3n8cJetkg0HYUIyyGu5prUbjUdDae2laimJX1w+VbfJ6kt7qEVIjSyrGwVx562n
	 SHCmJv7qpQDuA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:25 +0100
Subject: [PATCH v4 04/15] mm/shmem: honour F_SEAL_EXEC when an ACL is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-4-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3914; i=david@kernel.org;
 h=from:subject:message-id; bh=UUa1z/yS1KDRKZLH0HFcy68dBr6sHCzKQLNyG+9aTfg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4c5eU05eGOz4elDa27Mbdz0jLfg5YULz547ObGka
 6w59Xr7g45SFgYxDgZZMUWWoOD7Bi9frqutduNjhpnDygQyhIGLUwAmYl7ByHBE42TAlZo7R0o+
 rllrG1/t1O3z6M3OyZ91pJn1jqvX71FlZDgtNataqFDoUq6M4RbjKw1KD+Zmhs61VAlZPjlaR+P
 lBEYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 543F7160003
X-Stat-Signature: ij3qnxd81y3qmth9f1trixdk1twgjjuy
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793270666-620441
X-HE-Meta: U2FsdGVkX1+N2Q6Sa6raZmYPMdb/btJZ4NtnGwM5LFG33MzrLjWI17oEoNDQXDEcez9VyGQ0QgpKuO14j2DpRTjqIchdDQxYW2g/nfLepONPkWb/qQ2qqAwo5O5iTu8Afp3JtcG48YFenWNNe2pO7LzsLxJxAuPEz3ghdkgy8J7vPXOD2vmX49U3YtnH9D0gClgI4zLCuaVJIzpJo5T2ThHd9cIRYYS3aS2Gz3sBYJWdGu+Gev83DclH/wbRECTwQ67moZR+/WwYs+Yxv1ewc7SFgSltpF7VYCp4efyhI20PyW2NK9g3j7ljowdoaJLx+DYmv3wji2EICVOhJZmkDKDOXRTgAgJvROt+54P8NB3M2jpZHy6g10YTtFQzjE4tn6RAdbTrjE1rpo91Omb26p5UY7sdrABi7fDATqEFX4PkK1Erc9EEN+YQNJtOzMvti3+O1FWJJkdXJOvxxcYViR8ykAUktx0ROg+VPMoZjw1dJa6UNi5Jfz6d9tvrz7gX3G0RVJBzBd+qW8aSFv6nzxoznlFlJLkSK2x9oHoJv4NT9+8VXgTDKJ1No5xBMlsjgUTj0P78n0hX6VwXaXXSTVAJ3vXbQ4rQfv3RTOD33S9LA7tcF4GjFvAAROip7aqTJaHo2Cr8S+nyyv5qcgjp3cB4KNC/PCvkVSdR/ndQtskBkNeqdUlqnkYHt4ovyuGK8zJ5FlKFRm2b/f7Cxx3zuSjhwWo6jmktgZq4Kixtl/JpBpCjo18ltxVg2c1SLD1a6T948s1DgUBt6aTADko22k18dwWJuOJBTMV6THCYGdq+5Wmac1+HteDHEw4ei1gv1N/1ET6WgBeGpHOiYE3Ky/uHDQIYr+ZfnLHPdqNtNxX8faj2tRUb/B7wdVAgYXP2u6f0J7zmOtsn1heWIusffcSxqfYXk/JUcJw+uSYbqgTG+pwI+flBogFuw65Gd1krvnGD2I9+OqnwNgsAqSZ
 D1t24jBt
 cX5/cMuGzSbiCcmEA9FCLbfE0RsggsZWXy+xSv965xK32vkoQG4w7PZSZWeiu5WmpffMVLSM5L5nD5zBcG/ChI8aQg5/eN1zgT9B9c24FC20S20PCsVLPUhjpOBdKSLuLiFEO0l5op+WICmN90dIJjDD0lAH6ZuLlF2CpzYven2IFUIRdRpNT6fHhSdn5AjuFtZFhICQarABVGWOGr24lkktVMrNJLqFrRyP93KQVvP+34ezMPEvU22tuKcsYlf3TtKoQRUnVrvHCTOJFlMYRNz9qKVJo2ZyH5M2lXzY22g2HVSsEhBsBVVJ835OFk9H6Qt9I+Q5f7NYgRGpxUeQicA+NAWkRxYlH3WeSFmoYwHF28ym3nIq7Vo91vddqfvFKF+hRrdAOpZXc0S68TKTL2zWifiLnJAXHQkIGalRNEuerE+libDoHIaNJj3ksf4IipZo8l4lfaV+W1wL4zxDCjVmg2g==
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
index af21a89abb0f..6df0237832c0 100644
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
+#define shmem_set_acl simple_set_acl
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


