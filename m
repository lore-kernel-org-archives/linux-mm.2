Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2AF606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7X4kCMI
Received: by kanga.kvack.org (Postfix)
	id 359656B05B4; Mon, 23 Nov 2026 08:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330E76B05B5; Mon, 23 Nov 2026 08:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15D796B05B6; Mon, 23 Nov 2026 08:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB9D06B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:05:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 829891A0877
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:23 +0000 (UTC)
X-FDA: 85466404926.19.217C047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B674118000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7X4kCMI;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795439121;
	b=uckwULURXVW5brkvsPfmjqpckxBuxgRpElWz/7onEyKSPI4XzGL6Dwji8Xdn7EozMEHCSI
	cnG4jHUkm8eakZf6WBSLKTLDkDvpdYD5/5T1B5eDN9qX+pKY9AzyruhtaNOlPUYA6L34Uh
	CL5Jcltkq2cms4qy3XI8sdYfikjaOQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795439121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeSfkpPotB0b3T8E68yPEMk5QMSnlYS1worBwyaplbM=;
	b=S6gcZLWJi10MFD0gq83aRsxsyoOJxSHkTiiqpHXL8z/ldLNhNjcWQq6Ru4r+taw2HwGj5D
	gQFYRcSejsAIwSwlRhkDGZvzxDTdEJMN2Ndl7ivOzGU9+rS9deiRcErlItgk5p75reX/if
	7CdhNmMuqRjGPuxpTY3O3tJgumqdcTM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7X4kCMI;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B48408A6;
	Mon, 23 Nov 2026 13:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091001F000EC;
	Mon, 23 Nov 2026 13:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795439120;
	bh=KeSfkpPotB0b3T8E68yPEMk5QMSnlYS1worBwyaplbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7X4kCMIFWea4nTmS18Jpy0qF37h3Ec4OkKJXJSHHDBxfkGLCqYFwblSTqzyJqqn0
	 sHd51x7iPAbrfOfwpfzkpB1LDIgqSb5RgkW4eppxKi2dkNVG2/eAfaOUjyyJEjJusd
	 O3TxVMzdsVvetClPO5nkDJ7Xhw7VPt3p9zKzoEmRvG+uxQoqlAfNpcAN7fTGbzLcsf
	 0gp9g13gdE9UxJXxC6LeIul1VQk5adUnnmL1oAiCRGp8Dd7a7M123cf7LVtYhaC76w
	 sPCcbFuE2Hbt2lvOZdUcG5NTxl1VLyequa56esvgffFvKVWIc/QVoJ4497D9HS4Pk5
	 rmZsOhtta9A/A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Chris Down <chris@chrisdown.name>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] mm/memfd_luo: keep memfd frozen until finish
Date: Mon, 23 Nov 2026 13:05:08 +0000
Message-ID: <20261123130509.4032642-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123130509.4032642-1-pratyush@kernel.org>
References: <20261123130509.4032642-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: B674118000C
X-Stat-Signature: cck497u9xqwasuhnx38iyw64x9z6jiai
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795439121-258211
X-HE-Meta: U2FsdGVkX1+6PirdZQ9+0cVML9xpFufFZqLBtbk4frpsvAL0IFnQRH8eEdX9FFrCyUECovkSvh0SFUMg9MN7YoPE6xR5vSmJGuxnzp5ogq5IEppg+eZzJe3xcN0JMI+YpkVMbY5UV0+GasayT2/sC21MOtUohHWSLBJTsFWgvTmlpUGf/Dg3oC3r6ZBGC2MkeMx0KSuxICSDgYG/Er1ZDxPWFxRT2L4up1Aq0URLsTdJ0DvhIjhzETxaBZVAJkqfCLmjymoD8YHtg4zxVjs6X3s/TMp/rlaudemJVsP7uc7B5+TuOl/JyMLkPbNONP3AQ3Yug3sGS7TzbvJ5m8zDMQKSv14vXofgZNDORrMaVc+il4K+wDHya1CYU00+x+YsjCVhXq4aFr9XNcdKA3ALaz6Pm6REPnAEfPYlp0FFB3k6OP4pAZ0tWi6m1Eg8QhxhZB22QPdrpdHNomJRK+MYrbRAB/+vds0jMgwNY7G1c0kGkq59Ov4MKUgTInt1Fv50rVO7AotbV8T3i41UENLw8gVP5uLqw5lcybjPnrYWvSqdMTSG0zw+bZt7k42V0o42HhkMEIAZGej/xp7TFXZGaKk9N+q2pKm2KOHEHHITppNgqOuX0rg0xcKdYwulFXIKY5hGdBjz+O9wSdo8yHPpwDcLbaTvsCp9nOilfoK1gcjxmN6SR8XoeGoh+CI1dEDPev0zn8xGtq46ggobb8hLwLgRQFBHAfkbSkxS1QCT8T5mkRpAFHGzx+UuW9XHDi/AUL7W/ccPTA7nF0fdeM7UlSTVoJdy14j/mAWb00FoM8dNPUcPv3544ECxoZZFfK/PiaV/NpEe/OUvtP73odu/2G/NWlSSbLx10YnVXJhn04hMfmCgvo3AKZfvq6RC5a6EH08mQlTUcnvGsP9M1RCRYhuIBtIm9ntFyx6A2tdTckGfi8pD41NoERdqQ3Unyqfms9Wg0z6tcJzQwWy2Ixi
 6y58pazQ
 O656H7Ruf7tkV0mL0kBs9aYWXL6j+myRxVXKFu+nBMAq5seQm73o+UXMwwXw37Vk4ZYB5vfL5c5BYXsPIqb8HzZpzA7HvA8AXAVSRJkF7XRtyjcVSWfxcSHbEQ5tzwTwfRof6/gILd5fp64WJxQljmUMEhkPHEK+GnP4ZXx6GW4BduFQfZay/VlC9SgNdtm3k5rmCRFQ0PTSxM9laUpKtSQz5IPznaRu5Kr2yUWBXKg9ePQUdHh6JFVnG6hro/QgEr1OpvoxGSqC3DZ0nt2ecMgNf2hq6j5yqxkHxSyAr7yKXAj/SlXkCsav76FDIXx+u2Mntsr5RnnlWEcVlstB/Nfum2J9Hx9jg1C7LUwdr25RI2tb6Lv4uIJ5Z/NMNpNiM1zDSPm4995OHhCB+gWin1xX3W7GTkkFGUlf07uK34mr5+7ulVkhx5aX0EMPWDTIKe8DB0C04wG45tLxUDAzdHl8zickXeMk+9aX7cM2GF8jSWed2VDFfnHalW7du6D+Zola7C9171b77V3pqVTbxM+v49mozEdLsyXvxv9HGUNouQq7MKfru9Q0PjH/9oP3gMdQf0iTn7BgU3y0=
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
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memfd_luo.c | 91 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index c963bc3522e6..64635d03d7d6 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -55,6 +55,18 @@
  *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
  *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
  *
+ * Restrictions
+ * ============
+ *
+ * While a memfd is preserved, and after it is retrieved until the session is
+ * finished, its size can't be changed and holes can't be punched in it.
+ * ``ftruncate()`` and writes past the end of the file fail. ``fallocate()``
+ * fails in all modes.
+ *
+ * Adding ``F_SEAL_WRITE`` also fails with ``-EBUSY`` while the memfd is
+ * preserved. memfd_luo holds an extra reference on the memfd's folios, which
+ * the seal treats as outstanding pins.
+ *
  * Non-Preserved Properties
  * ========================
  *
@@ -457,33 +469,56 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
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
 
@@ -553,7 +588,10 @@ static int memfd_luo_retrieve_folios(struct file *file,
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
@@ -567,9 +605,12 @@ static int memfd_luo_retrieve_folios(struct file *file,
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
@@ -590,7 +631,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_folio_ser *folios_ser = NULL;
 	struct memfd_luo_ser *ser;
 	struct file *file;
 	int err;
@@ -625,6 +666,17 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
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
@@ -633,16 +685,17 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
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
2.56.1.750.gf70dc682cf-goog


