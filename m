Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C3A0606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AymbEKu/
Received: by kanga.kvack.org (Postfix)
	id 7914C6B05BD; Thu, 29 Oct 2026 06:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769ED6B05BE; Thu, 29 Oct 2026 06:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EA66B05BF; Thu, 29 Oct 2026 06:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3743C6B05BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A15FB160367
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:36 +0000 (UTC)
X-FDA: 85375330152.03.6FA02B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E55BCC0004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AymbEKu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIildARgeqLV5Iv54/CNVDjST3eNjwaUwngHh+RJ76o=;
	b=SQ9Zlmn6GJtLYMkAz9bVLhuu7/pMxFMv3Q5GKk9PFuJAj4eb0BpBorQ+WBW+hddpvp0PgD
	gd7khz48xxd1DmWiZoxLCMtjcDTeNdp4Rig8tDCgq9gEO031xFpFsRxXH2M1m/1rK8hx+C
	UlNaNWKxS3+w0mwHNBvOYypmYToFloY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AymbEKu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270674;
	b=vwAzRTOwK40HHoyPb0Yd03rBjB+Vkq3K311N/pHciDeCd769B8W6I42CAmoLBa4woPrDxE
	/GXfa+b1XmzDT4wD4+YKAAI0MtrA4RsW6nfEleVK7qT3Yby5IxT0fZY0T+WNJDFj7kroTM
	CitBx1L04XmoguQ4KD7jCkVonHJvbP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B4CE6022E;
	Thu, 29 Oct 2026 10:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389FA1F01829;
	Thu, 29 Oct 2026 10:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270674;
	bh=CIildARgeqLV5Iv54/CNVDjST3eNjwaUwngHh+RJ76o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AymbEKu/+O141aUXpFJESQYbVO4wuogMwXREBpJyzaJheRuB65aNLVGtrzRJi/VzO
	 bE12Z6UlB10PYRTAOQsztIYgWy1igjPI8jnJkQUFqkhfNjcGkRLc/D4M0E/19WjV6n
	 tVVXtBWvT4dkmpHXwnASIfsL00nzHR4ibLjuHCsaVNf0altwI4qCEsWJiI/JQKl33B
	 RAsvjWT5rIZbdLkRtMRjQjxHfpsffbTpfSX3msFksDMdn73OqZU5ASa81krExVd19G
	 e8OOgox3sShxjxE5XSQ/H+Cm6KVp3M8+YK+FkxzAFtIfzRe9oPkJ2d6wTM9ftD0mY2
	 rr2XyAwxhd6Fw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:26 +0100
Subject: [PATCH v4 05/15] hugetlbfs: enforce F_SEAL_EXEC in setattr
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-5-392fc715d8f6@kernel.org>
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
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1864; i=david@kernel.org;
 h=from:subject:message-id; bh=VibnqfVc/i5QlUy5RzJlhfYS1+yzH9kwQCXwNrw3dIY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4d5XZxZu/ixY/Xmvrs8OkxhqziUz4at10y7P+Xxy
 n+LpjSd6ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAit9gZ/mdfrP6WfvHudJHq
 LZmZi3s3NnV+WfV3wd3MQ5IXF17O+KfA8E836l/mJq3fSrmVGa+ay46uFNuunXbjprXDt0f5JVv
 /L2MHAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: E55BCC0004
X-Stat-Signature: d7jw75jxxqh36qcasaiu7m7gasb78nxb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793270674-593030
X-HE-Meta: U2FsdGVkX1/iDchcuoaeIRY1rBCsc8b/lybc3GyZB/G5pAprrcG48L7okWxbYxA5xSzJCkCHRvUiLvsGiB9UwIVp0zSXihH9hzBPgbhQxYElsFWrMrX98ADWxFBBLB59BPOCG40WwKe1FDBA0FZZgEHoBnbQj6BVlBbIvCBouqkoV/4wAS8GRE/h4WKOhv1WEIAryTOlnPc6aMJyxIRedO3KsL5mHgI+a3IqBe2d5WyLDc92MTl+SOE75oBE85+fTtdo+dIjiM2iTIg38EZZUjrpkEnBx3XgUx5yxwNZL81+4216dN9dbMJr3X5i6VfBEsVECXD3ylkV5N05dOFE/CqFaJf+VT86XoC7TVOI2S2pkE+YYHt4b+7RrMRrMH6o9knzSFQMsH7g3o3axnqy1QBO1Ddo2cmJ9rsrwZpDvd1co2AsaOli+S9PscWOzcc3ubhMmi8hrNxT1/oMoeTnG9AjOVIBWMFOLd5HQILG8YoZZ3GxTgbhStlSeburWFcePCkmUny4KfcFWs5mZ6TDAkSNq6KjVOHQlw9W10SYgWlYuNmJJL8iji6Ht5K+2P53R/rW9NcfryqaNg3+lqrooqAMsczRJwcBB/PI86prU0olZMPGHDGsycZ4lJz5af9cFtqcznPjb6CK+mijRfdCzEQAol4dLBog1WNzBFbDOQD/x80usYvtmFigBeZgFRkOyqH9nThWyG72PK36Dy0Lcv4iOGHRqj3zJa86qcmXMHRoFNPunAFIYVBroMfzQaNuNSBNlS3LXCK6HPkKmTiADWamoO/UqC40uW3o0y4h5Er+ZPOwKLt+7q2KvEmPMx4ty8EcMW9o/lHJMdAs/2yPufzxz/mcyKJPAvjemNtnSBi/BK4VPkD2f6jnaidyD/NU6D25Y2XWj8kVWR4cLCiFULa+4F6BLXRS5B0KAU0UMRr+HH9LbLiISRoxTaD980K0IvvWkuREbSpeF2eTOWm
 Ikl056Ef
 iDKQLEOyXdVKHdUsaDrF6bsjzbgO4oYzood0n/Ty/ohpPwt0GpjjW++dd5P1FCbH6Vju6eN3gjScmfekhUHSvAsmpA7O1UDuqTyiVEXr54EBHES8F4hkGhOhft80TzYEeAek/54Fd7LKP/tQopjiSPRN5/ZdZvx5Nkrf8zi5OJUnJ6mld79QTYda83/uNFre9gpNLZDdjoHc0h2IxVou2mgO1iaQPhD4lkDc3gCw0IBJY6xzPMtDYvzNG/DnRK1vLH3mjqNER6WZ4g6EMZ0Kh6uCBRoVkHEtw073lgY61zxr7UEPektzQwh2j4cdhkzMrb/bb0E2CSuxG19Yc0luNaGgqa1hgcCPZsugTxYWnQzmrXdazhL1oTX2Idfp56HXmjsAzatOqaLBfuu8/Zcbg6rv+GWcjyGR/+LWiZrmRtBsTYBzcuk6Wjy9OBcUwFGc2bYqM1BY7CzSK51uloLLvIPBBc5JY2yFg+xGZzaI7bufNNZp9YicF7X5etGt3Q24qVn4PfiWNr9kEupDLDChKzMbKOiPz1M3UGJXvz1ilPX3cQCUhR7fYgXzTxb+AXUR0BzqQXlzn/cVxsXUJvnTNJp5iPA==
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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
[ david: use common helper; fixup Fixes:; check only regular files ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/hugetlbfs/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44ebe..02e0a65d596d 100644
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
@@ -840,6 +841,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
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


