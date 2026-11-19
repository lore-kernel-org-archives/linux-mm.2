Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 643C2606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=rItD+Bs3
Received: by kanga.kvack.org (Postfix)
	id 785786B0665; Wed, 18 Nov 2026 21:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A216B0667; Wed, 18 Nov 2026 21:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D166B066C; Wed, 18 Nov 2026 21:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4ED6B0665
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:57:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91666C0911
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:57:26 +0000 (UTC)
X-FDA: 85450357692.17.417B7B6
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE828100006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:57:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=rItD+Bs3;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf14.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795057044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4NdHmfe8yI77qDKx7cyN5pAzKdZzXmgNff3sue1UTXU=;
	b=O8YcGmU376Dr6azss9mqCKZlTRI5VTQmWNXqsIwU6dDO7NEDWYiTc+MA6CscdVYYI0M1k6
	TVUH/ggq5U96cP+IhddNYF7lF5BU3BbRbBdqlIAD8RuUeI3YexuckF/rYPNT9s4D9svAVW
	DEOpvmVChBt8+fLToC3X9lHBKJ2c5d8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=rItD+Bs3;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf14.hostedemail.com: domain of xujiahao@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=xujiahao@cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795057044;
	b=8rwrVabVfYsTa+8X9PTk3Dx0nIjUpGyfX+BkS30vmX2A6OQ5iWBlr+0TbDsNoH7VTjh4gS
	gj7rOLcxUo3EDhAEHnfdB/q/BK5Qwypog5miMQGsmNTb2aRxxXXrVFc4uMz9b0IKqtn10p
	zQXhqdbrgvewjRYiibLk8vMfnE6Zlsk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=rItD+Bs3Ba485YEI+up8kA+1rzBWyGIGyh7av54OD1yf4np/gZgO8lHGsArvngO1h/9auzoXJRdbi
	 Iu1JWt2xFX/JfKKKmlibolX65qaTWfE4PWXAaXSj/eHoddKssemRmiC4tG8Jna3HvkSKL30v6jlTGP
	 lhQs/8LJIBZKwnPQ=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26afe6443614-54b8e;
	Thu, 19 Nov 2026 10:51:47 +0800 (CST)
X-RM-TRANSID:2ee26afe6443614-54b8e
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from [25.255.2.225] (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36afe6441bb2-05c83;
	Thu, 19 Nov 2026 10:51:47 +0800 (CST)
X-RM-TRANSID:2ee36afe6441bb2-05c83
From: Jiahao Xu <xujiahao@cmss.chinamobile.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>,
	syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com, Jiahao Xu <xujiahao@cmss.chinamobile.com>
Subject: [PATCH 2/2] iommufd: only hold references to files memfd_pin_folios() can pin
Date: Thu, 19 Nov 2026 10:44:17 +0800
Message-ID: <20261119104417.459962-1-xujiahao@cmss.chinamobile.com>
In-Reply-To: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com>
References: <20261119104417.312237-1-xujiahao@cmss.chinamobile.com> <20261119104417.312237-1-xujiahao@cmss.chinamobile.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pyrqxprfd9a18oqpjyt14awtoqszx7cz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE828100006
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795057039-190341
X-HE-Meta: U2FsdGVkX18Y6E8hla7ibwk1EGzV+z2RVJEj9K1ft56zz8mHOnTY6VCNi0ey7s+ZSsQjbaMM/X4T6bJzGtX49Y4NO0YVIwa79AOPbbCDdFqJ/pwDJ5miK+zOqlwK+JbcrIjYKj0rKp6WojpL8LvyeethA6kzdUb9VAW6glPR48mOQDgseD0hzaCmQhgE3bHpyZ1DBQNbsz1ssyiG1V0wKS1bgJzOz8Mskmyltm7/mSfa+ejcC4zqo6J/O+5tLxNBdoVtM6nFk2ojISttDLff3WncxxAFvATs6sWxjJdbnnWBUi5c5aVCM8hn04NCThQd5J9Pk8bQHtek9SMPEam/asJxVT+3KvR9ggpaHm+/EGdQ4dNPuWv3b5G+WHNaEYJ2fcGytNeaajGsA3XprTmpUCefT2QRGQRfJI6nKSoureZ1UUiInOMf5tnDFuzKmf//8fW16tUiRPPEtRzE8f3viP5MS7hMfZiNsI2Tn3H8P18Fn4O01nF9Y2wxqCroWtj0hY33ZlkmREOhVAGuntPOALqs3Ky73ALThfTPkxr1wv+UXav8sCIr+iTj2AKRk/v6RC1+qLDz9UoEv4OqtPgG5VcjDqZWEGV1U/BPGC+SAWlmWXGG3UQUtD3q82Uc/8ztBmDddrGlad6FJfmUzpIFsQXYGm0SjmwhCZ/5zhEf+ZcJhBrsJ/+gQWFY+PAd7saQax7TpAdRxEOx3lxYmj1KdzcSQOjxzhCKV/1L06JqqiYYWWs032MeLExSpE3eX9n4i/T2JS0Qx2gzst6lRwLyCATMS0sD3tf59zfggOgd9U6jrtQTsQ6NMIaJkMxa2RGiSjK56bqo9ZUd8L6RheO3TcwsZbrpLxUDTcrIurAdkerdpYgF4r/nSI9cyNxjMFbwCauAN0YeIeZyE9oHHIRZK8RvwMQCpgTqRX9IBQ1tNFElUKPoBVXci1EjkazAq8Dn4RSnlkS34rll+w0sIfY
 DGqNQuZk
 HevfgiLGV7l2niCWgOmq30JDuz9e3iCv+CtBmEPFypOixZgVOVzjmjeM0kzF4UuE/XV5lM2r2jZyLGknjf9MlwGoTp1K58RKp9RDsUKyuyBeJ7CPfIigcoSxKJF3HC5O5uK3LQZD5Hp3w6IMbLCHfYP32HX2xALzHr+qXIsf6DP131vxMsMjAc1zEPzMF1I5NS5pxp7+p25l/JSAM++70Gy5dHyDIIl6FdOWxu2yby5gx6eEDy/2T2fjjqUgjshrDC91BWp+JsjElYvuyCPf4ZtSdUBjf8UnCeWOcBzW3imHb6uVQRAxafwYvT4HOrnBKIKzmEWnGdVbU68OIZToP1KR91ZC7JfUwq1Qkx+LhqMm+Ni6TnxTggsxOmVzdekdSXCO6ZlqZ/8CkXqPZu/3YuZGNKXt3AFcj7K3CQT25Cq1X9DE6RJT3KAdN9W2oLIPTCWeYoCpXhQB1jWVZmG3lU5HXU4beHCMd3yKeQ2nOIy9W7XjhZcfsDO0X61zYIQHCVdOm6TadMMy3aPB9bi89/xd7CW000BykI/19UAdFujhBlYTRD9JzSYm7/i4BGYn5aH/BGw3p80uhaf8I26/KQqywh6gyAcHwflEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

iopt_map_file_pages() stores a reference to the file passed to
IOMMU_IOAS_MAP_FILE in the iopt_pages of the new mapping:

	iopt_map_file_pages()
	  iopt_alloc_file_pages()
	    pages->file = get_file(file)

iopt_release_pages() drops that reference only when the iopt_pages is
destroyed, which for a file mapping happens while the iommufd file is
being torn down.  Nothing restricts which file can be passed, so
userspace can map the iommufd file itself, or a vfio device fd bound to
the same iommufd, both of which own an iommufd_ctx reference.  The
reference graph then contains a cycle and the file, the iopt_pages, the
IOAS and the iommufd_ctx are all leaked; kmemleak reports it as
"memory leak in path_openat" with the holder taken through
iopt_map_file_pages().

Reverse the test instead of trying to enumerate the files that own an
iommufd_ctx: accept only the files that memfd_pin_folios() is able to
pin, which is exactly the set of files the mapping can be built from.
memfd_pin_folios_supported() reports that set, so the same test can run
here before the reference is handed to iopt_pages.  dma-bufs are
unaffected: they are taken by the dma_buf_get() branch above and never
reach the file branch, and iopt_pages holds the dma_buf there, not a
struct file.

Fixes: f4986a72d6e4 ("iommufd: Add IOMMU_IOAS_MAP_FILE")
Reported-by: syzbot+7666ed2c3d42196bf7e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7666ed2c3d42196bf7e3
Signed-off-by: Jiahao Xu <xujiahao@cmss.chinamobile.com>
---
v3:
 - Call the new memfd_pin_folios_supported() helper instead of shmem_file().
   shmem_file() became an out-of-line function in mm/shmem.c that is not
   exported, so calling it from iommufd.ko failed at modpost with
   "symbol 'shmem_file' undefined!".  Reported by Jason Gunthorpe.
v2: https://lore.kernel.org/all/20261117093244.652569-1-xujiahao@cmss.chinamobile.com/
v1: https://lore.kernel.org/all/20261112105945.285526-1-xujiahao@cmss.chinamobile.com/
---
 drivers/iommu/iommufd/io_pagetable.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 5ac736cf5..ab43e656d 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -515,6 +515,18 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		if (!file)
 			return -EBADF;
 
+		/*
+		 * iopt_pages keeps a reference to the file until the mapping is
+		 * destroyed, so only accept the files memfd_pin_folios() is able
+		 * to pin.  Any other fd, in particular one that itself owns an
+		 * iommufd_ctx (iommufd, vfio, ...), would put the file into a
+		 * reference cycle with this iommufd and never be released.
+		 */
+		if (!memfd_pin_folios_supported(file)) {
+			fput(file);
+			return -EINVAL;
+		}
+
 		pages = iopt_alloc_file_pages(file, start_byte, start, length,
 					      iommu_prot & IOMMU_WRITE);
 		fput(file);
-- 
2.43.0



