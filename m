Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8D9F30938
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA696B008C; Thu,  5 Mar 2026 05:50:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654456B0092; Thu,  5 Mar 2026 05:50:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502016B0093; Thu,  5 Mar 2026 05:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0A96B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:50:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE434BBAFC
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:39 +0000 (UTC)
X-FDA: 84511690998.17.D448F7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4319AA000E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:50:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRuMF0Fp;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KdXn73WYY0c8wrn6A7C95m0k5dXLcIGDqR+Uv+k43Go=;
	b=F11vuZ4Z+cNaYi5DAal9CRkEzvK6/nogyuSuMLpm8pxT1fF6CWZ5MyOxjNXcYN97QxF2eM
	wiwWTQHT523rj5DN/pSzLgEbRGlHa9HOhlN5nknpsVIxigdckYOL+J/i1xFmOkjOxACHRD
	9nn5PHtgoz/UQaEVuAnffNnX9E8gCNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707838; a=rsa-sha256;
	cv=none;
	b=127Il/nZDAKRQphJRqzLlXGWhgKtl4UxrqgJZbWdTYfs6eCHaKNUcLrawIGCPPL9sjLKHV
	ahGx/jhqjXqlHfWUlZadJ6ieyud+5xA2PZ1o7nHzxC27iVzzOaXKME1P5vke2IKNaXCP8s
	KetlAkvx5VcUWTgGNyV7LCUumr3ZyNI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRuMF0Fp;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EAEA4044A;
	Thu,  5 Mar 2026 10:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75396C116C6;
	Thu,  5 Mar 2026 10:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707837;
	bh=u1CeJgjWd7kXPS3ws/muqknCR1bko0+rqrXMss6JWs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRuMF0Fp5RgG+1TfOfSpoEQsuFnGiyxgpQaEJMycqoz5Lu0pxKWRIHueudja3BrrT
	 HS35EjVPfS42luoTz69IPj1Nb3BPZk5SG11K0m9+kjLyufD/DRqBU5HshDtwBR8mSX
	 gsx+fjzYBeNdInitBzNx4UXo7mbPJ8oDsH8QfGV5NU5hx4FQsbO7JCTL4pf05omubz
	 ZQkKT8PDabVcStINMOWLvo5KiCf6qtq8MJr2RPBXSMAbhDCDKCblz0q6XdEGUlEL20
	 81nqJV1Zevw5akClENINw2E3tAsDKSh/e4G3fS5T33Kukft3x9LbCsEoPR4Ck60mdd
	 CS2X0Ksy9gaWw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-mm@kvack.org,
	ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/6] mm: add vma_desc_test_all() and use it
Date: Thu,  5 Mar 2026 10:50:15 +0000
Message-ID: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772704455.git.ljs@kernel.org>
References: <cover.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4319AA000E
X-Stat-Signature: n1kbpckhdw1er98wk7pu41qiqbqnshsp
X-HE-Tag: 1772707838-224608
X-HE-Meta: U2FsdGVkX18lSK1W+QM+LSPNyJthsMopap8Cq7LQM6JP24/Fm6uAAnadFRH+7CQBQRfFYZn1Nc3xLYi8dgztlXy9dDau7mQo8+u9G7PGWoyeUGYuGB8d+cD+E4jd5Vz6gyf7kkcE9/lxERW5VIujwaepGBVpnzTjnUuOlGjAtIxoxK0aLS2hHzGHpQkaV7VkH2SX4WJDG0q/LPnrL2FXyK86fw6oBcySNgpI/h0n6nrUnCxFHAc0tV4Pn0jI92Bzvzb7q+OQWr8aHfb2VAMargs3fPOvuitbDLCJ8p9P7oKz++cG35KrEROsWC56CK1sRwYXriZN/Zf4k3bhbYBQ8sA2rirUBitvtQrpGLkwWiC8OT5g5++GPbuUY/zYnD3f7iiS8eKbCQ7g1TgXowesvGkmbprR8deWs9lvSswrAPFBjcFfIBQghe9x7OR1IsmM50IqqMjLxkJ9xpaJQMy+Ih0pikODIMDglkNN1ZOguvxyXHcWJafpBHziHHSO7rU5pIaWB7G1YokbVrKwiSc5cVIW22tiH3QHD6ad2nSxucFfLdOKWg7H+2TIzprj7PB++g70aWZW+jfkWhp9f4Lbxia1qgY/jL4mmy2fheMV1BljIJB/ahBXAsCcOWecDkiCgdwRBdzhhOLBNIWcMq1/1DTnIjOiHsC7nUqn0MbzMX3vSpW8FcYhcWNHI7EZnUVeIbkPq3FQfatX+/He+ZqshwfWHO6tyIytHKx318IYLBiJR11Ch3z1HY+axzoLl+kBqwUFKItX/TwfEHwtUxKHzW5cDPMsXi2cK3ieez0owX+Y4eOF9H3KAuznHxRo9rVODIynFMcG2t85ldIK9cKyBZU+Qe597MLvx8fFo3dp7t++1xYoKehgUaGhI9ZT0w28jDva8+QAC96xdoMJF4d+XFdBmO8Gc4z4pqrRXCOcZzDpQdMCqpbeeJpRan/CRJ5BtmH0uQSf3NvcoCvLn0h
 whbGjY+I
 auabHgP6VBlk8ePQhFgpFqXOiz7yOtzerjKeJyd3S7WbUK52+oPG7VTYH+/ylZz3AP+lhujIF2/OCfTmusLheEB65eJ/nY8qPxt8I6n0FeyZnMGRy0rywfmdSEObz/vWeWX4exergYbfz3b2PogS9gtgdklVhWrKB722J+YqqBwx/oHY+5lKib9lvCBmJeNFzlkzyEzhaKKSoH7NCSW6mmKtBpe5gPWfht1j5sEndZtF9JBH2ztvG+Ov1yCFkt1RBesnTsvBKsByHKp+QYq9LD2Qmlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

erofs and zonefs are using vma_desc_test_any() twice to check whether all
of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
vma_desc_test_all() to test all flags and update erofs and zonefs to use
it.

While we're here, update the helper function comments to be more
consistent.

Also add the same to the VMA test headers.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/erofs/data.c                 |  3 +--
 fs/zonefs/file.c                |  3 +--
 include/linux/mm.h              | 24 ++++++++++++++++++++----
 tools/testing/vma/include/dup.h |  9 +++++++++
 4 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 6774d9b5ee82..b33dd4d8710e 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -473,8 +473,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
 	if (!IS_DAX(file_inode(desc->file)))
 		return generic_file_readonly_mmap_prepare(desc);
 
-	if (vma_desc_test_any(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
+	if (vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	desc->vm_ops = &erofs_dax_vm_ops;
diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 9f9273ecf71a..5ada33f70bb4 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -333,8 +333,7 @@ static int zonefs_file_mmap_prepare(struct vm_area_desc *desc)
 	 * ordering between msync() and page cache writeback.
 	 */
 	if (zonefs_inode_is_seq(file_inode(file)) &&
-	    vma_desc_test_any(desc, VMA_SHARED_BIT) &&
-	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
+	    vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
 		return -EINVAL;
 
 	file_accessed(file);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index db738a567637..9a052eedcdf4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1178,7 +1178,7 @@ static inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
-/* Helper to test all VMA flags in a VMA descriptor. */
+/* Helper to test any VMA flags in a VMA descriptor. */
 static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 		vma_flags_t flags)
 {
@@ -1186,8 +1186,8 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 }
 
 /*
- * Helper macro for testing VMA flags for an input pointer to a struct
- * vm_area_desc object describing a proposed VMA, e.g.:
+ * Helper macro for testing whether any VMA flags are set in a VMA descriptor,
+ * e.g.:
  *
  * if (vma_desc_test_any(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
  *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
@@ -1195,6 +1195,22 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
+/* Helper to test all VMA flags in a VMA descriptor. */
+static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(&desc->vma_flags, flags);
+}
+
+/*
+ * Helper macro for testing whether ALL VMA flags are set in a VMA descriptor,
+ * e.g.:
+ *
+ * if (vma_desc_test_all(desc, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
+ */
+#define vma_desc_test_all(desc, ...) \
+	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 /* Helper to set all VMA flags in a VMA descriptor. */
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 		vma_flags_t flags)
@@ -1207,7 +1223,7 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
  * vm_area_desc object describing a proposed VMA, e.g.:
  *
  * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
- * 		VMA_DONTDUMP_BIT);
+ *		VMA_DONTDUMP_BIT);
  */
 #define vma_desc_set_flags(desc, ...) \
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index c46b523e428d..59788bc14d75 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -922,6 +922,15 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
 #define vma_desc_test_any(desc, ...) \
 	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
 
+static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
+		vma_flags_t flags)
+{
+	return vma_flags_test_all_mask(&desc->vma_flags, flags);
+}
+
+#define vma_desc_test_all(desc, ...) \
+	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
+
 static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
 					   vma_flags_t flags)
 {
-- 
2.53.0


