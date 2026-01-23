Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23952D72369
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7340D6B049E; Fri, 23 Jan 2026 04:59:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D58F6B04A0; Fri, 23 Jan 2026 04:59:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DAA46B04A1; Fri, 23 Jan 2026 04:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 499F76B049E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:59:14 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05324B9404
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:13 +0000 (UTC)
X-FDA: 84362780628.20.5CC33FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A35B40007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADfhbIZT;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769162352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hw+/r3HAiYrTGWwcntrPr2cywMCf4Arlv4MVexb0BQ=;
	b=IrEpOj+Yj4xkrR43ZWhEE4kPB9wxb3oMzqB7tbwPIt6YN5ikfoUzrZl97tWdYzcpQNnePy
	vnUcHRdo+eNFEDbAsUcLOrHUDa1N9yMA2aUzvWquCZKcVqQlIdJhD6OP4ASUsfVqYOxT5Y
	JA9CCzMAQF/CfxPi5urhcOUSTkQBZ/c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ADfhbIZT;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769162352; a=rsa-sha256;
	cv=none;
	b=LC9LoO/lDUX/MgVCfvyqcNrVaga+GWgbiXNtvFiV5X0SueoPm94d0BEqlZrNnyij7gvVhi
	53Md1Gy3WBwGgU+RQYGRF1gqWhRyj/Rt9H7ydEPqmcaS0VQ1QnEBO5JPasPwew/CaGJOCj
	u22Rt369FZ4F5x+khP0LJwc3sITHKHs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DCA2442A2;
	Fri, 23 Jan 2026 09:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E86C4CEF1;
	Fri, 23 Jan 2026 09:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769162351;
	bh=1YfoW2OKTDLDdQexCVzUsywJpWB4iHKtpLSFlvpGsVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADfhbIZTSW/JeHR3m/hz+tmXTOVNIVfm+MKoDbN+kLAceLLgcSgGVmiFUwx+c+zcY
	 FC5L7IfKDwsbAqBAksQ6Yk4y6gVTtG7esgGKTU3o4wPt/TCtdh7fXxpDmSXhFJi3Bw
	 Kl/hP7XfTv20AtEEn1vfEgbgmh0TP1GMTkIYJCyc2fj8xglrmb7uH0HSgWlIvPW1hs
	 0JVk6V2QLP11QJAhxWozOh2KbEDeTmrhvjmD9vr3tN+BuEVLNBd4z2R4eRiUzgspV2
	 JMLAk7RMMJROoinzwI+5QqxR8KTz4imQSg2wN1KdiSdw/s9IKfGV5i9pH0tdES+VH2
	 yz/w/e4tN1+PA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: memfd_luo: preserve file seals
Date: Fri, 23 Jan 2026 10:58:51 +0100
Message-ID: <20260123095854.535058-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260123095854.535058-1-pratyush@kernel.org>
References: <20260123095854.535058-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pei9aewdr49chao1jb4ye1eidscshefr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A35B40007
X-HE-Tag: 1769162352-856484
X-HE-Meta: U2FsdGVkX1/aZwRT3u6x7ZHdVAUgtJoPL2FTo5GDPVcInqdc1pz0BH9Le++5xor4k8QUqthyvAuYdLu14RcnE9/Fe5uNL/cBT63ogzMtZx/iuTESTRONigdEQ34BxZUV/Eofg32HzSzYugx3rMrLcG9bWd03pk0tR4jamv9ytDSxUf63oDNtWtX57xvgiGDOLOWvABcxNIybTD/PO1/GnfAQr5UAupHSZUMZuBtgBuRoL/BpYkMwtzVQ/WklntEwR8hlzSHDp0/U4Cn3FrM/LCJa8wMKT0HD6tNMP8ZigEVA9lV2eT+xIH3FnJ89uPZOnBhd8Kfl736XQx0+bM6hhxzV5nt8R0TKX5+5ApNc9z3Zd2JfxAcwthoxa54bvpQtvfw2f56kLpOT7z+UoReqKBjpfHd9oru566bsPxJiSVX8TbFI/uBr7DTOfaNZ3hnEAhRRnKLaY4ssIX1MIJ4Wrp0mfkXR5pHuQ8Kfp5/Vy0l0WNZESmuD420wtDeR2zif7E91++blTY6wDdpqLHLmYeVJPx86qc0v6YhfCvrbVuq2VX4bP9FkYzewWScFrMYoo8utYzDKH6ybnRc5arwQ1beDbZ7mkAv4rNFUZApK/Qxx7GI/+fJdoFjfIQFcQ8jB8Edcc5bpRLheeVwz4QSF/1XgDfzFYb4KohtES7vkzKWcS4Qa5fHwPIRfIEx0vIGdDAK5oC6UNPdecnPMX/YLTFu1WgBKyz+ompPnn1QEsKFuWRiZSKg8fIMHIqvwCNsAWo3RjlA71b24nRpGCutwt+utOG9WI4MxZF1w3/VL+XeZ5NvzgwYH0UJ38il5wUrvMxEWQiOAsgIDSuQ4kSe2c/FplwWtHDxdEmuhizqJ8Yv/Kx2n3Iz46DRDPm+oiR9a11dlAEF/MZ/JGOyl1g98WNwakTBANRf7DJ4Y9c2mFCDyQeCci0Cpw0f19P4GCKuk3/SysBTa7vkg/dMJwa+
 7C3dL64l
 HYz+FngibiyzIJPhCdGNYiNhwhRDisDGpVw2dAzOOgdX2dufajyWoqbS65k+uVdeTeL6w+PEccvKrsyzzVRy7uoPL6b3CbcHe53K+ZFVztCu7Kvcgs3cU9vDI2DL0O4RL7/NCyI2Mxk4fGU/vdnfb3i3Rqef4ExFwIY2hlQXJ/15ibMBkjHQ63l4bYVwhlMyC+7HUNzeCI9uYDIBoXNtW0zABCNSCRis786+tNKGbc1isH/m+J+XISyuVxXwvwK2t5Xo90a2Vg5oyM9DDJBfEB4qa7403sS483FH+X+Zli29EZNNGlJw0IQjAw8GxnToBEt0r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

File seals are used on memfd for making shared memory communication with
untrusted peers safer and simpler. Seals provide a guarantee that
certain operations won't be allowed on the file such as writes or
truncations. Maintaining these guarantees across a live update will help
keeping such use cases secure.

These guarantees will also be needed for IOMMUFD preservation with LUO.
Normally when IOMMUFD maps a memfd, it pins all its pages to make sure
any truncation operations on the memfd don't lead to IOMMUFD using freed
memory. This doesn't work with LUO since the preserved memfd might have
completely different pages after a live update, and mapping them back to
the IOMMUFD will cause all sorts of problems. Using and preserving the
seals allows IOMMUFD preservation logic to trust the memfd.

Preserve the seals by introducing a new 8-bit-wide bitfield. There are
currently only 6 possible seals but 2 extra bits are used to provide
room for future expansion. Since the seals are UAPI, it is safe to use
them directly in the ABI.

Back the 8-bit field with a u64, leaving 56 unused bits. This is done to
keep the struct nice and aligned. The unused bits can be used to add new
flags later, potentially without even needing to bump the version
number.

Since the serialization structure is changed, bump the version number to
"memfd-v2".

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho/abi/memfd.h |  9 ++++++++-
 mm/memfd_luo.c                | 23 +++++++++++++++++++++--
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 68cb6303b846..bd549c81f1d2 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -60,6 +60,11 @@ struct memfd_luo_folio_ser {
  * struct memfd_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
+ * @seals:     The seals present on the memfd. The seals are UAPI so it is safe
+ *             to directly use them in the ABI. Note: currently there are 6
+ *             seals possible but this field is 8 bits to leave room for future
+ *             expansion.
+ * @__reserved: Reserved bits. May be used later to add more flags.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct memfd_luo_folio_ser.
@@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
 struct memfd_luo_ser {
 	u64 pos;
 	u64 size;
+	u64 seals:8;
+	u64 __reserved:56;
 	u64 nr_folios;
 	struct kho_vmalloc folios;
 } __packed;
 
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index a34fccc23b6a..eb68e0b5457f 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -79,6 +79,8 @@
 #include <linux/shmem_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/memfd.h>
+#include <uapi/linux/memfd.h>
+
 #include "internal.h"
 
 static int memfd_luo_preserve_folios(struct file *file,
@@ -222,7 +224,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 	u64 nr_folios;
-	int err = 0;
+	int err = 0, seals;
 
 	inode_lock(inode);
 	shmem_freeze(inode, true);
@@ -234,8 +236,15 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_unlock;
 	}
 
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		err = seals;
+		goto err_free_ser;
+	}
+
 	ser->pos = args->file->f_pos;
 	ser->size = i_size_read(inode);
+	ser->seals = seals;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
-	file = memfd_alloc_file("", 0);
+	/*
+	 * The seals are preserved. Allow sealing here so they can be added
+	 * later.
+	 */
+	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
 		err = PTR_ERR(file);
 		goto free_ser;
 	}
 
+	err = memfd_add_seals(file, ser->seals);
+	if (err) {
+		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
+		goto put_file;
+	}
+
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	file->f_inode->i_size = ser->size;
 
-- 
2.52.0.457.g6b5491de43-goog


