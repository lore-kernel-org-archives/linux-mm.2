Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2001606D828
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c9sJCu1x
Received: by kanga.kvack.org (Postfix)
	id 74A686B05B4; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDB26B05B5; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610796B05B6; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3507A6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B7D381A0532
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:33 +0000 (UTC)
X-FDA: 85394620626.25.C26CDD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E87A20002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9sJCu1x;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729972;
	b=dmNUya4IjGpFJvOPDrKcTLimRS38n2Wlol1uZ9vNi97OrWoBd9Q+3s0Bz6rQVnx4kxqZJm
	Zz2V1DiGxqHAaz8k8OwPkkn5zGqJ9FbyqccW4tSDq0mVBtu83qwRWvp0ytKIWaz61fC140
	PYZgjp2iD3OD+TKB0XjWXWGyp5+G7UY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c9sJCu1x;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikpjRxzxut3T/KDasjzHggVPTQG5Ge+eGv+OSVemEXk=;
	b=bwrLZF8+o5hFzB8AZJxzSlZddVLTlWkcEwxCVB2PKHqNsYV5PQY3qgsDa2vBlR/QheEm9Y
	4IkHH+XeKKkZAcO4oQJzJi1rzaZkx3H3i1MZXuSFFZF1y7r+6f/N942xYs3pYIlSMIbFav
	VLr7WY9cHymDeYDGaoRXQUHgB2jO8HM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A7DF60A59;
	Tue,  3 Nov 2026 18:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D441F00A25;
	Tue,  3 Nov 2026 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729971;
	bh=ikpjRxzxut3T/KDasjzHggVPTQG5Ge+eGv+OSVemEXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9sJCu1xp74krmFkMVk8mLe2ptw4u+UQIkBrktG1eh45b/H6ID18PQHlk5dcst1r6
	 gv0yMz7OoYa9jmuiZC4P4il5W4zCsYkIGdBmH+hInR68kATNWaQkYJs/QirwAUbgOW
	 ShcB1cIuQOhXJc28DYjRzkZQJrnE4yyaFMdrNNNTeoo1KNKqyLls8xKxvOE5Si7zd3
	 cv/GxpIWQPrALyfNuQTqRKlbKITWsNeGtc86ZCTuulJBqnkS/kvuiBlFcuEtZW2SlA
	 4mhsoIbFCuhL7hyYIjBGvwBuUgSER7Y0n+6fy+dZjsXm4x4DKnHwlRSikzB+wlGYsW
	 O2gdqMVXqF9XA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/memfd_luo: keep memfd frozen until finish
Date: Tue,  3 Nov 2026 19:19:14 +0100
Message-ID: <20261103181916.2462825-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
In-Reply-To: <20261103181916.2462825-1-pratyush@kernel.org>
References: <20261103181916.2462825-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ruybnyiur3bcf5fonmmddebrmuwb5xmi
X-Rspamd-Queue-Id: 3E87A20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793729973-469547
X-HE-Meta: U2FsdGVkX183DcYfskaAdfsSIx6EZqGy1ZwDTxHQ3BhbUkzMjgpujuBGGR2orPZ51/4EyGmPtINOiGfGAhEcEJ/aaR++Br8uqURDJE23w3DXfnWK4qbAr6Qx5FDtoaUXZ3lpmbW/BxUJOm+iwYr3aViicKn7a8E5/LeBm555oNIMi7MYhjhGbExJqFwSTlECU1+GULnyb5SWBGcK0b3lneR9N7Mv1diU3kebBsFaz750H/aVHS35jpvOw+fV4XAyIqK6aEDUmS0ZstDyn9BcaHtWg0jrDrducXPmFPsHF2arPBWMMnGdqq5Fv7QbNqYuZkX9gXZLGiw1oWfifZpIoy+qoPgp8BEzTO1rsPk/qdLAtD4wr9DDtLRK9U3czAuo9ikZZ6y9BBrCNkoLNDo4U9nBE2O9Wb+awMEOb0H5t3PoI0CP3Tv8G3jSHOpluCDttj7JYDHxoH0zD5LZFRnlya0FBBIunXJpTJHJQHEcntE2MG0HxM34R2q43AR9pkDiKMS9pjIONoKRkSYcfD3k/ZoWbCfiApFNIBPO/DGQukGlsji0bTxkUOjSHQnMe+7o8j0x8OBbUXgxsQCZwFfH5Zc2YMVuwdtr9+s3TYHJiBIaKn7fSQ0ZZBcQHNWyEJcuev/OAi+sX/eXtHwvgo1h5TL3xBgsx+WThDAAsXvqaAMuaq8TW2cTdwHaZSXYPDXL3CGBKKod1WBju0E4oguGUkuvDXXJaR5QmbYj4PU1+qvGwu9FpUchXxqqIZQoqULfsWdsXRWL4gQOoTWdpC4lWpidhueOePozLu86PlX+ItdT89pxKxEZNIT8P8p+b75gCik0454gDsEAiwzwiPPfeyBTEkIhnilpOhrbIFDIGb/rXknjpJMA9xLBt1bWIzf7gMNbobThgm4Nr3NhOy15pQ5AbUUGgM4gGindpJDuZTggr7Fj/Bjbo2rJJYHFwEL+NCJ2ucybT10oOktPMbs
 HAbBeFj8
 o3ipp4GD1YsVpv2Yr4+qQSB+Sk+JzGvGs0j73DxtVoGivVMKNSdJTUU451/GspzNWcA4Dnvbh1u53ZpFfX6W2NmRPLARrTFvYoWBfhUUENN7pefkcdnJNIp1vSbRjNBF9K4Sjo9NF8JOaTGqzbGaDrCfFSoZMxpvFwnSaoeAcxlUscoR/YLzMKRXgVwNB/4MUFvGsgvnp8opZh9srAPg2BH+Lu0yOnXaCp7ZUzvnThcuBp0mPlZDt7v9N5C3DBRiNU/TkpTe0+7gYWaDvceU0KPSLKY4d2NZZue5N5PAwG3LrpIacILXEs7px4hzUmdkfO2oSfLNDh2H+q7QCfPrUvH49Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

After a memfd is retrieved, it immediately goes back into "normal"
operation. The file comes back unfrozen, and its pages can migrate, it
can be truncated, and so on. If the memfd is depended on by something,
like iommufd, that can open a window for folios to move around before
the consumer can re-establish its references.

Finish is the conceptual point when a retrieved file can start to behave
as "normal". So take an extra reference on the folios and freeze the
memfd on retrieve until finish.

Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 87 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 68 insertions(+), 19 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 9fd9abf9fedf6..50dbbda47ad3c 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -55,6 +55,14 @@
  *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
  *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
  *
+ * Restrictions
+ * ============
+ *
+ * While a memfd is preserved, and after it is retrieved until the session is
+ * finished, its size can't be changed and holes can't be punched in it.
+ * Operations that would do so (``ftruncate()``, ``fallocate()``, writes past
+ * the end of the file) fail.
+ *
  * Non-Preserved Properties
  * ========================
  *
@@ -456,33 +464,56 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 	}
 }
 
+/* Drop the references retrieve() holds on the folios added to the file. */
+static void
+memfd_luo_put_retrieved_folios(const struct memfd_luo_folio_ser *folios_ser,
+			       u64 nr_folios)
+{
+	for (u64 i = 0; i < nr_folios; i++) {
+		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+
+		if (pfolio->pfn)
+			folio_put(pfn_folio(pfolio->pfn));
+	}
+}
+
 static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 {
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
-	/*
-	 * If retrieve was successful, nothing to do. If it failed, retrieve()
-	 * already cleaned up everything it could. So nothing to do there
-	 * either. Only need to clean up when retrieve was not called.
-	 */
-	if (args->retrieve_status)
+	/* If retrieve failed, it already cleaned up everything it could. */
+	if (args->retrieve_status < 0)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return;
 
-	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
-		if (!folios_ser)
-			goto out;
+	if (args->retrieve_status > 0) {
+		/*
+		 * Retrieve was successful, release the folios and unfreeze the
+		 * file so it can be used normally.
+		 */
+		struct inode *inode = file_inode(args->file);
+
+		folios_ser = args->private_data;
+
+		inode_lock(inode);
+		memfd_luo_put_retrieved_folios(folios_ser, ser->nr_folios);
+		shmem_freeze(inode, false);
+		inode_unlock(inode);
 
-		memfd_luo_discard_folios(folios_ser, ser->nr_folios);
 		vfree(folios_ser);
+	} else if (args->retrieve_status == 0 && ser->nr_folios) {
+		/* Retrieve was not called, discard the preserved folios. */
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+			vfree(folios_ser);
+		}
 	}
 
-out:
 	kho_restore_free(ser);
 }
 
@@ -552,7 +583,10 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		nr_added_pages += npages;
 		folio_add_lru(folio);
 		folio_unlock(folio);
-		folio_put(folio);
+		/*
+		 * Keep the reference from kho_restore_folio(). It is dropped
+		 * in finish().
+		 */
 	}
 
 	shmem_recalc_inode(inode, nr_added_pages, 0);
@@ -566,9 +600,12 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	folio_put(folio);
 put_folios:
 	/*
-	 * Note: don't free the folios already added to the file. They will be
-	 * freed when the file is freed. Free the ones not added yet here.
+	 * Drop the references held on the folios already added to the file.
+	 * The folios themselves will be freed when the file is freed.
 	 */
+	memfd_luo_put_retrieved_folios(folios_ser, i);
+
+	/* Free the ones not added yet here. */
 	for (long j = i + 1; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
 		phys_addr_t phys;
@@ -589,7 +626,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_folio_ser *folios_ser = NULL;
 	struct memfd_luo_ser *ser;
 	struct file *file;
 	int err;
@@ -624,6 +661,17 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
+	/*
+	 * Keep the file frozen until finish(). Other preserved objects might
+	 * depend on it.
+	 *
+	 * The file isn't visible to anyone yet, but take the lock anyway since
+	 * shmem_freeze() requires it.
+	 */
+	inode_lock(file_inode(file));
+	shmem_freeze(file_inode(file), true);
+	inode_unlock(file_inode(file));
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
@@ -632,16 +680,17 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 		}
 
 		err = memfd_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
-		vfree(folios_ser);
 		if (err)
-			goto put_file;
+			goto free_folios_ser;
 	}
 
 	args->file = file;
-	kho_restore_free(ser);
+	args->private_data = folios_ser;
 
 	return 0;
 
+free_folios_ser:
+	vfree(folios_ser);
 put_file:
 	fput(file);
 free_ser:
-- 
2.56.0.385.gac671c819a-goog


