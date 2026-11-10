Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB42606A323
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lbgs/yar
Received: by kanga.kvack.org (Postfix)
	id 52D676B05B5; Tue, 10 Nov 2026 12:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDE26B05B6; Tue, 10 Nov 2026 12:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3886B05B7; Tue, 10 Nov 2026 12:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 196096B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DFCE120A3D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:10 +0000 (UTC)
X-FDA: 85419970860.04.951E7F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 068C120003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lbgs/yar";
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzj+m2zx9cLSChoVXv7HfacxXNo3CyS+OFptqcCaQh4=;
	b=LuERP/cYf/bzySk7eIPNQDl9t/s8Wzm7taDU01WqppCDRiTG9rxBtQoLH/DSU/fQXtOGJl
	ljNiFoTNzAPSMRAxaQBxgLPoUwJIHipGc3GmD/SakVvxiBih23dxXXfqkA/DsNIQv3HMWQ
	iftFx9qk5PpvfXIRotBOqpRTfUke5mU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333549;
	b=2lXejt77Og9lhf0OWqDr4l3RSvB91sr26FtbHGRAxvTgilw4rqp74ABJthLj6pR1cH0nXk
	u46kU3QXcse0Kn3JM9izKo08o5O3+WbDnra+qFo5QT7Y4CobgOBwRTMadAaynptu4tJ+Fz
	8o296gY/JZ0KqgYiOcSDb4B5spqtXis=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lbgs/yar";
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5044D41E6E;
	Tue, 10 Nov 2026 17:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F801F008A1;
	Tue, 10 Nov 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333548;
	bh=xzj+m2zx9cLSChoVXv7HfacxXNo3CyS+OFptqcCaQh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lbgs/yare/CCf7+Zqw6RNxf3VwmYHd1Jo3R2x7UcNonyOoUMTK9cT+XCjUpNLCFzY
	 HTUVoLANeBAew9qEtYlst28H/vY2rim7qBbujGKxlAG6pMG+L3u2RHryhuLTalN/W3
	 CgsxXiQfh7NKQQ9lXqvtlTQW7MraRjsZewAtxPxzQA6ZuOQ5hqxTELKR1oG/AKHA00
	 xuNeeIpHU3IozEZwVIcMuWeprY2W9dF02AGZBJmnu7rjgC2nzQcS99GAUaKo+Kn2K2
	 uvswAgUeOa1kgfz+B4IRMXnTtMdPsXVpu8tEcXvDpaoSS/+pmESkmiwRegVBo/uVvU
	 nAc/xnr7OXBug==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] mm/memfd_luo: keep memfd frozen until finish
Date: Tue, 10 Nov 2026 18:58:53 +0100
Message-ID: <20261110175855.2437084-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261110175855.2437084-1-pratyush@kernel.org>
References: <20261110175855.2437084-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: difxe9zj9c8anzdxuhs3htcaux5hi7gi
X-Rspamd-Queue-Id: 068C120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794333548-694449
X-HE-Meta: U2FsdGVkX18HDm0yWMBcS6nDRZDjM7714am+E0fsrUWwtecG5I+dqYlT3FiE5zT2Lx9s4PpiqBm4cZIcg2Fra/QBMLT8sN0ZOrzBlCdl6t6uVwTchqcL9ZtOmqUAXfyuCuRtqNXqDfNLz60882AUS65Q9IHIXh0w4fR64KYAkz5ux1yNEINOYmTv9R//6D6+blMYETlp2GPdAI8hDmaGXBBf7m5MLRZAMHPBNVPdAWYfKymfnNKefdreHjulp/OHKC6P0pASOE7frEAKo6wz7ytnK71rzSIozzyMQx5v0TtL9m5OgjEJykWFxj/V0WsBUajoAw7d504NCiPrJBRWgPOgIaUqH6xEoyx7KCFscKNPppT3r0wNK1zBktMLCVEjgL465UZW92nf1IxzvpmCVsgahTJITyhwMr169HgPsMpLZskAghVBZwXUE1xzY1wO81iyoA/T325AT2o8OyIPG9JkTOAvobifESP0MfTRXYCwDBZ/+3++heSPEcHa8ISblSFULmxXpNe4YVz/7wm8taOBRCKLVRQgKnjUm2hsI48FY75yqOO7D/r/GJOY6YJQXkJEXECmCwiuv04wJkf24fjmW2S0j5RQlZgsp3389gLyCvVUcjvS/a0NM0DwHGOCf7nQVyS2uXpzztMsR9nU/zJTGP0AVkAg+LZVbmQIC6tXj0crShwqq0ZQWNkmSQaTbmnZPsIUIrOBhnCe/XVJzWNu7v2GzQHM+9y51yh4Z0gWwEv1YW9glEHvKAfqNVQ5PG89qSnKB2LUw/fGBECdFt+ssILWhM4vj5508dCG9e7v3rv88y/vFbIbqjQikBw8mUnc8qVbiEvwtSXGMhBGnC5+nZCNxK04FYMw4EUhaQdso+u0K6dw8jtrNOiC9LayyMhwbSwDW8EQ6m/aY6RKu66uQGCViD2aNROAKq/Q/9DoetIsE3lCTAOjzvwKv+B8Snvdg1d8b/yx3sXHjxi
 Huxvsdnx
 e+C9HZAR4q/GiKx4z8oSHAGie2w9JQrYBwr+dQ9gT2pSSq8hb8KHDcOrqmVB+AQR1m/shtSK8hv3Tg6XUdAmQiTOQE8k6wfzPK2AELljm0TsQbr9QCEyuBa0BZG4cFkOLvuF7MgjFU4wZAL+Mnmh8+KAI0e1hHCxtRRHTWisnothj4vWg9AHxVhPAVNgu1Yb//DwGVtOEmuC8Vllnmt7FYS0bm9yR42JqdtUdvCFJqpszcOjPpdhb9979ch02qrXGvSQ224eUv39PS0Mq4ccGUe/ddj0NRRr8Qcy4EMq9kHHeLAwf8LTUBBamMoPnoN+H+SQnDQzLHbjxyoIFCA/6yOVcig==
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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
2.56.0.542.g3ef89b7020-goog


