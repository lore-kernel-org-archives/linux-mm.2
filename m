Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1419606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drswFaK1
Received: by kanga.kvack.org (Postfix)
	id EF3A56B071D; Tue, 27 Oct 2026 09:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC396B071F; Tue, 27 Oct 2026 09:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1A16B0720; Tue, 27 Oct 2026 09:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA7946B071D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:04:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E5C31A09AC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:06 +0000 (UTC)
X-FDA: 85368424092.19.635942B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86375C000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:04:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drswFaK1;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wwGXqxRc5YvwerZOSnrubg9QNwrCXY3rCABuj1vruU=;
	b=JZXptlqVZIwCzHsmlmDSHLRnouadOV9hjHdLm9JLS+i5chQ52GTQ6SnTz8lDj6nI7iuXK/
	jnCVqEpMSm5F2s3APuGHgWWSylJptv/RzTfaGBCJixoYMzFs7tOY9VrQeX712ECbg3XDHc
	eRV07zbw+5zE33xxZ5dBoh7nNDvt6ro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106244;
	b=SDqT0i7DG8cQm8eDifMV/j/PmdTfXxI9Pa0UoF9zOeNPyup5XZan7S03fGoZATCON9YNoD
	tLTZQL2far654yf8uITopJYb9P6QanEazOCrJByLI+nH7mD3QnJJ8gp89muZSPfQ6qzPYm
	O2TZQhfv0w7F4D/gbPa32aWfKmidzdg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drswFaK1;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D0D412A5;
	Tue, 27 Oct 2026 13:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209301F01825;
	Tue, 27 Oct 2026 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106243;
	bh=/wwGXqxRc5YvwerZOSnrubg9QNwrCXY3rCABuj1vruU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=drswFaK1ZVzCJ1irJvFYIsaU4ismpcQekcE0Z8MKJh1B4DRmMJDs39Pa0nAYrFC7G
	 UMBRfFrGSO1JDe32pi+uAm6MHftdlYcnFZ2WCCR77sIBS17hJUb4M+hQRdgYg2Akv2
	 sfs06vlX7NTuaZCxZ1RJiBzloKNdxNeRX8inZcYW9GnQiZYEsgyKjbt49kb0uUkcjP
	 jmtdYPbwAxatCFIMWJBz/WHjoiRhBRkzhvLnEOmkvH7D28q3RnM0Qi77sDkHullbom
	 PUiqTu72Zjws1z4jPr5Lg+DMz0F/fukgG03TKQ9wC6b2sxraGeGf86bS9d7E8hXl/m
	 8DdSEQwH8Hnsw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:10 +0100
Subject: [PATCH v2 05/14] hugetlbfs: enforce F_SEAL_EXEC in setattr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_shmem-v2-5-86a00952acb9@kernel.org>
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
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1810; i=david@kernel.org;
 h=from:subject:message-id; bh=kN0V+ffVNdzTEb4f73Jhvx435CzQjTpPxsBtdWyTB48=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBQ8yHgyKLi9WZ9/7ZFvJ8TePtXK+CCaxb46eMKLb
 yqLd3+u6ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiO3UYGWacUdZ5rrbJwuGG
 xP7OBfNuKU4qZQx6Ha1fHeGykOnmXHlGhtZTJ+Ujs58mPU60ifwdZZa4+t71dWXSU5awHy7d/8z
 fjxkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 86375C000B
X-Stat-Signature: kmgnz4do7hh8g5eg47po3udydeoqji4g
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793106244-185464
X-HE-Meta: U2FsdGVkX19nT6ooB+RZewlNsWy5AbkP+fOIOuK1UvAV8soQuXswEoHrmZkZCBLb2+pcZ5pD6uz38j4F3slvkF2sZc7EFbf+IyCBonTUDVzRKH0+r3yJfbYJPkjVzfoIR+Jw6Y8WB+9xks0S+LiFNrw8Or8n8todEiwx7gWZ2CyUdl0U2aAQEb2Ecy2qrk4MyRR1Ivf5sbQ8r04Q60NE22NsDNIEXrr/0NhHS5S4xFG45rxf+M6DdMHzgTCYwhJGEu1edA5ZJ7YDc+8s9kcx3zcj8QUDWRLIOVJ7XnkWdVnFm+bZ7B0peimqtKrQkBZh5MgQieoTAn9UYPZsPD/PSVghmXZy5SySg15gzlEyK71qRELH7Syxh65Gh2g3BOwH7An9P7aDwF61K+kQc00oahrOdIeUEnluQRq2+qHiAnDoc+micF+asx4nx8ds5/EnDeJ6LoBtCTB5z10rn3Cufs+xW/Tl3muLxoyeoeq7nwOUEcEeO4YTePGx/WkQKGuTfe5H3Hc9bZ2XLmgpuFGE3qsBqmqi+FsBKhDOkDS5+6czwBp5PlB8nF+qWoTth5nRHWYJSBxI60GOZbyJ/GOPwiD0VLDRPIiCcXKTfal6neGqOc1YS/52ZOn/LXASOzQNYLrP2hpF11Fpr4WGONuYTXa9GL44q4QZ5gauZVJoNITEgoQQWG01zRSaiVvEO6yJMDx2bii7GuGLiySWNQiS8DyT3GgJOeASAnIw06qg76sHsErx9NdXhBVor6/Jkrn8o8bbz1tcAT3ewPALlRlaU2+JX7wCBEymYMc9KG/vrpSzTKRtzSyFocZyH2rcBcHMN+DqMgyWRLmZpwdugNi8PP/XvRTs9OKMxmLLBVoABOrfawufyf8xHpyqPSHpRdyasuA5cO73cnwD3duGOH8g7n2byh9v5AYbS405dxLixS+Zw1WSOjhWRgBiNNzix8Zr2R614Jc/JB7IS3uCjlB
 wshJdIaf
 Zyils6+uL1MfQNqASov/ED1e+dm95WNkNLFbiZ2BtLWm7PQLNWFVsrXt2hePMrc2QsWsZJBOM4FKnTMWnRnaugvcm9g9A1l+yxBOLxSVLEPs3Qp7hi6kVZa3d/2J7V5k26tHwa1ps23SDmHhmm3XUQsvVe9Oj/GoMle+WETwesnA894Y4LSgl406Bcsa9nB0fOGj+7xnkJ0+drEbTHGNMCMc9Q53EVxXAVQgl26Yo9iI8XQeGLaT5iHVEkXz4LrBEVDb//qw2s2uj0MDoZ+i5gG2nAzKhM5BdwQAdUwYoWt954nYoVeTI0qn6PfMiDdsfZkYCcRqrNvFMKZfeUGvqNAUEYTdvXut1Pv36ecEsCuN3mImScEfbgfwYUHBQAqxJgkFEh63hKRg/TN+Fzzo5cJpS6sAFBzr7DmSqgViagSTeU9BZ6+f8Ki2VQS0aAxfeIYpdBPiS7Dxss7sLpypydGZRvn2X0JJEKtYOOIvCAE0TP2LKvARVm63PCQFfPkZjN4omOjFp5zMa7+AuafeH70NjY+BNjPYljPBXwtXl3hiKNz21tFAtja/AUKsDtnwomfHkgmWnMcTugVX4FyZqArcDfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

F_SEAL_EXEC is enforced by shmem_setattr(), but hugetlbfs_setattr() does
not check it. As a result, fchmod() can change the execute bits of a
sealed hugetlbfs memfd.

Use memfd_check_seals_mode() in hugetlbfs_setattr() to reject changes
to execute bits when F_SEAL_EXEC is set.

This also fixes the memfd_test hugetlbfs SEAL-EXEC subtest, where
fchmod() incorrectly succeeded after applying F_SEAL_EXEC.

Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
Cc: stable@vger.kernel.org
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: use common helper; fixup Fixes:; check only regular files ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ab1e4dec3f77b..1fa05b4d26531 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -28,6 +28,7 @@
 #include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
+#include <linux/memfd.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
 #include <linux/statfs.h>
@@ -840,6 +841,13 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
+		error = memfd_check_seals_mode(info->seals, inode->i_mode,
+					       attr->ia_mode);
+		if (error)
+			return error;
+	}
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {

-- 
2.43.0


