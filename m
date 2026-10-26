Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F6560A2604
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LLWJfIRf
Received: by kanga.kvack.org (Postfix)
	id 7AEDF6B05BD; Mon, 26 Oct 2026 05:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785E06B05BE; Mon, 26 Oct 2026 05:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EFE6B05BF; Mon, 26 Oct 2026 05:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 239616B05BD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 981C8120743
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:21 +0000 (UTC)
X-FDA: 85364284362.07.1EEA344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6A03C0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLWJfIRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxRlcgnZgnkhi6+O0aTsbz1x8Tq983dT+cO3SyC2Rpk=;
	b=FbFaIqxk7P+W0X4H9CBDAocmdJTAAklnrS+bA2JKqehT+t6FEhyAz3bTBSjAljk8Yu5+8i
	BjwuGFwceIA+m2WHrUBd3oe528A71CVekU8l9/2FaTSLL8QB7CBuqXGzTnrzSFBXetwo3R
	cP5Fv0g9BFzTVGElUjXCv8HN6f34KAU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LLWJfIRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007679;
	b=3vUmpVck7B2jphiTGIsWbU1ATaF9tUknFEbRBg/aDqCWX8pN7kJ1qU0i7qQHiGPAA2yPd3
	DLOqoSsGYbrIm7ELUmvSYQsVQUoM65DwCSNWRonQPg6qtSS2yfqTrQWVLoDPLQOtu2n5xh
	eHnbgewGJceA0SEJOr09KChP4zdeOKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6B7B43F0F;
	Mon, 26 Oct 2026 09:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B28E1F01828;
	Mon, 26 Oct 2026 09:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007678;
	bh=BxRlcgnZgnkhi6+O0aTsbz1x8Tq983dT+cO3SyC2Rpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LLWJfIRfqQ9yw9zN8w+tiThnDWMyYGvn4LuqFmaS/+sKhD0RYXGM6ekuLbp5pwye0
	 GlAFStgMZ4bpa74f1YXxkncoHCET/UQGIsZMpznOcVE3Xmzy+UQDI+uXyspDicU48a
	 RwH9olooA8JB2RwulISypqfyfEg2BuWxr9jC0KFeW6gkQcEvmtEnultg/qf45+imgv
	 xOP2nH//hSvDA7H4Rya9klWucPxS630yCdhbc/J0QCPYiQ7ztrPc2vWIote2d2lKzq
	 n28H/ZOeHflhVLZO1TbpQ0jpRnv49HxVS6FYn+bLcMj+oniKTOECFaDwVDwQK06mDn
	 Q3tzYXHhxZhCg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:37 +0100
Subject: [PATCH 04/16] mm/shmem: honour F_SEAL_EXEC when an ACL is set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-4-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3607; i=david@kernel.org;
 h=from:subject:message-id; bh=MTJYg0b2CsxJrcKABZR2LY1h7dDRQY+5hOZR0M8LIUo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jVT3O8UbFoGtvb8E/hKj+m79twwzyz9KL69Zhz0
 XPUIrbu6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAih3MY/ocumabo41Zs8b81
 98X2SZ2fZJuSGX7/ZC5IXXy4c8ncH/oM/11F0stiO/pbry90a6pbmJ955bLoRzPhPf7JQsqlB4v
 6uAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B6A03C0003
X-Stat-Signature: ri5tztn7oo5dow1d4ssndmbxi4mn8374
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007679-743235
X-HE-Meta: U2FsdGVkX18t2uMX9uudjCNiUP5souT/xeBupAT7VwJFUIQ/4vNQV5nG/TAuDdlHaBKLmqA6e0Ln+jID7yld4Jfst4+M+UJCFr/N27g5MMfk2OVq/LbsmBKqLohMVl4WTxRWqhWlABRclEVBdSaI/DiM5wNB1M5XjrA5ucaNp6714VcE7QGCtIxGLqTAzgG6UvBIkpCzlWPUBQlRyjFjNOIZLpzMmxF4VCmRFPtAxW4yw8gnNtiQ6ktb2AIfydS2S6b3W1/StY0E2UFCsQQFUWY/vkU9+PddEK36b7ORIHKFDah8BYgxomiEcHmO2I03Wym2wbmBxXkMJS2P9Kng+QA7BgXCKcYv2H7pH99GlDWWlw+4WzNsyMi0BaoFbt1Myg/c1PHbgaQlfBOy6R8f9uNZewjLBXIcGj5HhqX+RWTbkko/KsXybbNMtQdMO2aCGHEuZ4+KWFgAzt/S2BlK4tBhCAPIjwQohEtf+79Qk7w3Vj7tEohZYFbmytqPWLlrgPvK9rAYyQGcpiZl+Ulb/vtOlenH+uC9nQEddriBgvMrnxOnzpitXu41kjIMQUHAzgNGkX5p2J+ylQ/CLmBtIDT+REeX6kG02BN+JVmt4QIDMe0rTy2SdkDLqnRfxsaI4z32lIUFqAvnciChj7mQ81DwSHiaD+wTNRlmAj+zEZjpdhXFlPLN322jTrG9YWOylyzo9o+YUZyL/v9E3VE3aOm6VXhW3VXoxHX6OSU7RFzj1MFJrzl6mWxeDmOtm9igPy2ufrd1VT03z6wK3Z8r2jC6RiUbAWH6skn9CW3YCgTvUeMTcMZRzgHTqmVx+QezPkyFcYoennKlInlZxpNKm6L2DtLR5pVFqDDBf9s7tboSBqsOmN6cJP7PDiEvbgoH9cV1BvsOX2B/ofpHFgCMasKToqNyDuwtgBQxMpKS0ft64tHba3yIhQOwXw6K1N0qD91VC/6bHNC4PU6ZF+J
 MA32GHKA
 pVzyda76NaRq+1YqVYb2CQfIsSFiepq1I47l0hDsrr+CE8VT59Gnd3qF+Jj0G8uTGyltVLc62MzoY50B6TwNl5wZbxx2ByWcmyoMOwtllQ4Y3QQZLmqpz45wDhNUIn7gxiIN8s2NnzAvcuemhBhJWCXA1FmTwv5COuACCyyUFpUwPSanKW/wmemEZRTXyWJxIeP716Gk2gMwlo1SRlDFQ5PqtPnSO0RoicANAK1tsxTQC1yG5Akji7mEar3EgQ1i8D5LK1CLMVPYpxHXnNAf0y39JyB2r14EzI+BhGTLBTCHxNpBxhu79VEq45GA9dffJNt5CaLoFk1rsWy+lx1XnzbU/OHCSLDmddZb6lMzkoXW7yq7NgBRbr3KhTg==
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
index d97fc32e7c942..86b9d19f26c7e 100644
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
@@ -1549,10 +1550,11 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
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
@@ -5400,12 +5402,35 @@ static const struct file_operations shmem_file_operations = {
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


