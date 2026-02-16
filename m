Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E33E83823
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 19:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38406B008A; Mon, 16 Feb 2026 14:00:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5C86B0092; Mon, 16 Feb 2026 14:00:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01A76B008A; Mon, 16 Feb 2026 14:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC5746B008A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:00:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83C13140F26
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:00:06 +0000 (UTC)
X-FDA: 84451234812.27.1F240F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA532140004
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:00:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WB0rrATC;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771268404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnvj/HkYJBtIyNZW9YmFC2m8Xgq/jLT4NAZgHs+lqUw=;
	b=UdAeuJJ7RDQWx5kVW7QFWUQDrPGSPkW1DZJSFWbozlaSd8AMb/RtXxMMlh9DEZPscBBCh5
	VpDx2xC5IeTFHjjCyXfFxDKPs4X+hx33l9cT/4wioyuUQA3frtdQdX3jZEKgwVtTGA32ia
	SmqkwCqRYPmH+kb88JOd0RpcfHFjwLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WB0rrATC;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771268404; a=rsa-sha256;
	cv=none;
	b=sERIJ/F378YH5ST5dj0ygQBsuBVp+BxjwlqmB07ZK410RrHeP8JeRiA0x5jm8K4TSYPW3G
	E9tHNkyW5Ag6MotZTUaA5Sjn1SNTmLFxzZJmiAG895gEbFnPrcQ1kjrMujEZnDFPkrWYfG
	3SUxP7hVywdLcYG5SqNnbeylBMIS+Co=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78B7E60145;
	Mon, 16 Feb 2026 19:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C246C2BC86;
	Mon, 16 Feb 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771268404;
	bh=rDOaaAXfsrj1RbVbSoaAqlUcovoTYZIHYJI6Tev+jiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WB0rrATCc8Fbi5vyGG8WQkNokaNW1LgErS/3q32Ighfuf0ahEGDeJY9f6O/Se2cuo
	 CTXwAVY4Vkd/yhyQ2LEo6iz/dKeafOBFuVBLApOwWRxwHSl33QfG4qtG4p5X8Lnddp
	 FAUbjSrRxJYtpGjrWOqXZY4PgvloHvg2jOJi7QmIDacsAbydDVEzAnXxchRaIKA+ic
	 AcU+782hhuzKCsU8YUzWUFxtx+nhsTeRVpsk02QNYKk824asOqIshbCZzjqs453VAg
	 QzObg1aBpfVZZ5ma2OyOlf0j1dj+bJXM07jn1t/05mbhcQBsJlcOwK/jen7HfOkUgk
	 w0Az9nnUvBxmQ==
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
Subject: [PATCH v2 2/2] mm: memfd_luo: preserve file seals
Date: Mon, 16 Feb 2026 19:59:33 +0100
Message-ID: <20260216185946.1215770-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
In-Reply-To: <20260216185946.1215770-1-pratyush@kernel.org>
References: <20260216185946.1215770-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: acjpor7wkm4tugkfrjidtd47dpr7bh11
X-Rspamd-Queue-Id: EA532140004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771268404-729410
X-HE-Meta: U2FsdGVkX19hNlYiQ+IZv2kjOt1TDzefAtvzQ8Eevmv+v9TSHlHkiW22EsfQvgNvNwFiRsi38KmPmuM+IpbCbzF6W3M4Xe6EFDCwRB3MCzFNEFHBmnlAgBKnmb2TMo16uzCoWWZGIkPM/6a9dkrd2Q1kkjTbgRe0QvjojvSnfpDBHvb12eqYyYN0kEfNiem5HzHAliVHqTxOuVxn5XXQ8lVeGQJBs81noIhnmzZybelK1PzofQ+wSkpU7sB7Q6kHaAjcvphEe474nizgPDlcbzu6eOSfinoeWOvaTuM9RPjw5VKgRHdxHWkurzB1Rx5lG9pHJxoJgIeMweptyGpQ3NwOl/li5CNKkRxH/Qlc+LCNJsZqSDl6PM8MIP8zV817FszqHJSATNcd1587hAvdWY8Rqf2RCfQszqAwBkkIFhOK1XOqUZ1BSPHjDe2R1iI8xJfXrJJ+tvH5J5ae4pTNtbQvCysLcjAwy+OCgFFOc2TJzCfG1OXDHmvDPo8C5lzApxu28Pwo0k5SH7RVdr4yYW4UUXSqXfZR+te2iagoI5kvomgcSZJzrqO39HhES/MOCeaYl3K4RSpzpdaV/IXJ0FyfYoxAtCRf9Q7KvEK7NSfrA0MPySsrrmz6vb+REWEvW+JfvRWS5yxj3I9vzirmVrAuOq7991GIWZN4O4VPnYxuwr6+5wkHweklc83UVDgqExQqTLe3Vu4wVe/tFOH1a9IifDHfI9OVTgEXyt6dryqdFo+tvLYDN7h6i9GWqpRsH+Cq1c30PUzROoxhnrkWkbR5Xgfw5YMb9b/S7cnyebxXFdqs8o6jf4wjfCelZxtwGAwGuV+Oe0WKQsCbCQxC2vmgpvECUKdOIVjBcmtN6FDgKz2uglcQ/0X4WCYFmYy1xKzTGoigS0Omp1AN23TfchRqARPMVQp/b8NZuGHLZgmS16uZ5aAItUjoPio1CBJbsKjgEKxxkT8SljbjXU6
 P3CnwxQi
 /CVaC3Cdv2SWGZ8ijATH5I6ggtE1SdKM7sgqvMowyDoi0KQ6xnhGcfk+6GYozg9lXXE1CkUS8tDsWDuPDlX3PKMpcpCBALuUNgsIXal6Pqea/5Bc/AeSKZJWUJY3D4nNK5//GF0bhcQER6lBlz9ZHgJ8fvfLZrKjV4eJxRzWE7FHYuqeDCQLgnKtY4Saa2f27iZ+gvUd43tUXBcaKM61tjY22itpwgXisylmfki4Udu2s+IhI+246Gsas1lithk28D9V/8L9zWYxk6zrkuV83CdALAw==
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

Since the uABI defines seals as an int, preserve them by introducing a
new u32 field. There are currently only 6 possible seals, so the extra
bits are unused and provide room for future expansion. Since the seals
are uABI, it is safe to use them directly in the ABI. While at it, also
add a u32 flags field. It makes sure the struct is nicely aligned, and
can be used later to support things like MFD_CLOEXEC.

Since the serialization structure is changed, bump the version number to
"memfd-v2".

It is important to note that the memfd-v2 version only supports seals
that existed when this version was defined. This set is defined by
MEMFD_LUO_ALL_SEALS. Any new seal might bring a completely different
semantic with it and the parser for memfd-v2 cannot be expected to deal
with that. If there are any future seals added, they will need another
version bump.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kho/abi/memfd.h | 18 +++++++++++++++++-
 mm/memfd_luo.c                | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 68cb6303b846..08b10fea2afc 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -56,10 +56,24 @@ struct memfd_luo_folio_ser {
 	u64 index;
 } __packed;
 
+/*
+ * The set of seals this version supports preserving. If support for any new
+ * seals is needed, add it here and bump version.
+ */
+#define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
+			     F_SEAL_SHRINK | \
+			     F_SEAL_GROW | \
+			     F_SEAL_WRITE | \
+			     F_SEAL_FUTURE_WRITE | \
+			     F_SEAL_EXEC)
+
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
+ * @seals:     The seals present on the memfd. The seals are uABI so it is safe
+ *             to directly use them in the ABI.
+ * @flags:     Flags for the file. Unused flag bits must be set to 0.
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct memfd_luo_folio_ser.
@@ -67,11 +81,13 @@ struct memfd_luo_folio_ser {
 struct memfd_luo_ser {
 	u64 pos;
 	u64 size;
+	u32 seals;
+	u32 flags;
 	u64 nr_folios;
 	struct kho_vmalloc folios;
 } __packed;
 
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index a34fccc23b6a..1089dbcf5ca6 100644
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
@@ -234,8 +236,21 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_unlock;
 	}
 
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		err = seals;
+		goto err_free_ser;
+	}
+
+	/* Make sure the file only has the seals supported by this version. */
+	if (seals & ~MEMFD_LUO_ALL_SEALS) {
+		err = -EOPNOTSUPP;
+		goto err_free_ser;
+	}
+
 	ser->pos = args->file->f_pos;
 	ser->size = i_size_read(inode);
+	ser->seals = seals;
 
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
@@ -444,13 +459,29 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
-	file = memfd_alloc_file("", 0);
+	/* Make sure the file only has seals supported by this version. */
+	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+		err = -EOPNOTSUPP;
+		goto free_ser;
+	}
+
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
2.53.0.335.g19a08e0c02-goog


