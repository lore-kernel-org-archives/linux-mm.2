Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D7A1094464
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34D56B0093; Sat, 21 Mar 2026 10:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AA36B0095; Sat, 21 Mar 2026 10:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9480C6B0099; Sat, 21 Mar 2026 10:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 841AC6B0093
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:42:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23CC714038C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:42:41 +0000 (UTC)
X-FDA: 84570336522.13.32AC3CA
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf22.hostedemail.com (Postfix) with ESMTP id 240EBC0009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:42:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=WDFSH3r7;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf22.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774104159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szBi7BFtRR1MgN8hkMm2WcIeDIhwZTQNOTIlX5ONwr4=;
	b=ILc8sqLcvTRubbmkuxxFDPBFccHZ2nctPQzvHDN56obhAqZCW3xTsUXon6O2W7omB/KMqu
	JDxGVOJ1iJSuJ5nzkOz79PEvsJcv+j30gFdU0h1taWkRFy+Qsb/e+00S8obNXbSK+mHzg4
	rQP55rzc5aFD5lwKeW28dmbEJsgkaKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774104159; a=rsa-sha256;
	cv=none;
	b=8GItbGjeXiru/b2hbFOjmJ2p5/5XyhBWmQJuxIP/395Ffb+xyS/vnYs+HCOrPQpQAFhxFG
	NxxjZ5Gxy3U//KiwMPWSSSULrY2aMz3vGKDigatW2t9lXUJNeb7Yi4eil6MRRsjHdzQkJ5
	WWrwnCMTnUsWC9xwXWXJJ5xPf+SwEkE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=WDFSH3r7;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf22.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 0E1984162F;
	Sat, 21 Mar 2026 10:42:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774104144;
	bh=M16vWRuu6EJkpwXaqhKmqlJhWbpvl6ngwctG70jXS/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDFSH3r7vCzPpVucnTR94PZi863BPmtaFpe0ISW2ggCWJqC8NFfqCbdYsv6HUcTmy
	 mkX7wUb9/+ghf7hrs93FxFRmmjsk9EZb2i7U0iQReplJRGQipVhfs9CLCIGkntyMSF
	 67QrCnU6StQgl5O5hcQrmdCTl3eCoJrXAF6eGK8Q=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id B0C1D41627;
	Sat, 21 Mar 2026 10:40:55 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH v3 4/5] liveupdate: validate handover metadata before using it
Date: Sat, 21 Mar 2026 15:36:41 +0100
Message-ID: <20260321143642.166313-4-oskar@gerlicz.space>
In-Reply-To: <20260321143642.166313-3-oskar@gerlicz.space>
References: <20260321143642.166313-1-oskar@gerlicz.space>
 <20260321143642.166313-2-oskar@gerlicz.space>
 <20260321143642.166313-3-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 240EBC0009
X-Stat-Signature: 1sg768ibeihmtubg53ktke6zie7bqb3a
X-Rspam-User: 
X-HE-Tag: 1774104158-251395
X-HE-Meta: U2FsdGVkX184jx6thwL9qiI9wrQIej3wVrBn2I9FpMFhiYyf5T0/0cavX4pHOLB9dKnlgEX071Zzy6kq4H3/BmjmVeYfJlOq7n6yJCosJnNKwxqla8run7QMnvFcMqvyxnfiECSyGKhBAvnmgX82hrhhqKzXsIQeKd36zH7n/bP8hFv84b0hfd8uvth5qlJ9HnDCu2be14KkmODHKZhmTMVE9ulNnHSGMz/L4pZKXH2eY7oLF1SZPOdbhi0B6qp2lFdaw+ZQ+YqQ1CIfmkbMg1+4P4/MDeBuMF9JO00sJGtczfi379xVePhNujYr2yZmNSCvWs185TcO7a5fsR25WkRwNpBnIHEusXhe862KzShRU20TvPeGjLEywj2KKJ/xMkrSwNZ07Sg8La3aJaFVh2P53ti9wG8iG4+Tq96YKi1s60cAqAi0L6RoHG6G/QtPKWJq//PxSay54gkdOE/q3TwNrkk4FHEqnfsgQvuNZ+CO8W52dVqznacG/ElHf5BbnyiteRLlvQjR+xSfER9YYcuj5EHOUiCEqv8nrg63czvHiJnNnI8z/ft3H0m9TGURlorcHn8znYDsSbT78QHNjn4z/Z6pal8Y2qyU0jC8Y/gRHi+1b57+BplKsFkOE6BJ2yWzm7zpBOu1pyYUa3tRsQ7OldNWkbBi4Mmu1IuIx54xdxa12WgV0FDxt0xpRa/+dENkh6F/l5kLiAWbccd0jC6vh0zW0flMqpReSNXDYhJwahCjFr6lONRBktyhCMH+b2iRYW1lnH43jG4SwobFo7XjLHg4kn6W9LFewk7sNdmqW8CKUhQQOrUj19iI+HNqGNk6UMHdBFr7NZYeL+nxz4AxVEZoIz5OCJOpGRWCh2PAa3lfoD9B7RKhEuknR4KfHZbqIe1iP/tCf0dWa1R+jy/amponFsVpGrGjHVNdjoW2k4m7d7eFrpNAcdmPhZ6dAkRuTBqAY0o/Yqt+yiM
 cuENYsrV
 hQ4TJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The incoming handover path was still trusting counts and preserved
addresses more than it should. Corrupted metadata could drive
phys_to_virt() or kho_restore_free() with invalid addresses, and memfd
restore could walk beyond the serialized folio array.

That turns malformed handover state into out-of-bounds iteration,
invalid restore frees, or partially restored incoming state.

Validate session, file and FLB metadata before consuming it, reject
non-restorable preserved addresses, and bound memfd folio restore by
both the serialized size and the restored vmalloc backing.

Fixes: 1c18e3e1efcd ("liveupdate: validate handover metadata before using it")
Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 include/linux/kexec_handover.h     |  5 +++
 kernel/liveupdate/kexec_handover.c | 13 +++++++
 kernel/liveupdate/luo_file.c       | 22 +++++++++---
 kernel/liveupdate/luo_flb.c        | 33 ++++++++++++++++--
 kernel/liveupdate/luo_session.c    | 29 ++++++++++++++--
 mm/memfd_luo.c                     | 56 ++++++++++++++++++++++++++++--
 6 files changed, 147 insertions(+), 11 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d741..af8284a440bf 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -29,6 +29,7 @@ void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
+bool kho_is_restorable_phys(phys_addr_t phys);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
@@ -80,6 +81,10 @@ static inline void *kho_alloc_preserve(size_t size)
 
 static inline void kho_unpreserve_free(void *mem) { }
 static inline void kho_restore_free(void *mem) { }
+static inline bool kho_is_restorable_phys(phys_addr_t phys)
+{
+	return false;
+}
 
 static inline struct folio *kho_restore_folio(phys_addr_t phys)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..215b27f5f85f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -291,6 +291,19 @@ struct folio *kho_restore_folio(phys_addr_t phys)
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
 
+bool kho_is_restorable_phys(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
+	union kho_page_info info;
+
+	if (!page || !PAGE_ALIGNED(phys))
+		return false;
+
+	info.page_private = READ_ONCE(page->private);
+	return info.magic == KHO_PAGE_MAGIC && info.order <= MAX_PAGE_ORDER;
+}
+EXPORT_SYMBOL_GPL(kho_is_restorable_phys);
+
 /**
  * kho_restore_pages - restore list of contiguous order 0 pages.
  * @phys: physical address of the first page.
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 939ef8d762ce..3eb9aeee6524 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -785,10 +785,17 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	u64 i;
 	int err;
 
-	if (!file_set_ser->files) {
-		WARN_ON(file_set_ser->count);
-		return 0;
-	}
+	if (!file_set_ser->count)
+		return file_set_ser->files ? -EINVAL : 0;
+
+	if (!file_set_ser->files)
+		return -EINVAL;
+
+	if (file_set_ser->count > LUO_FILE_MAX)
+		return -EINVAL;
+
+	if (!kho_is_restorable_phys(file_set_ser->files))
+		return -EINVAL;
 
 	file_set->count = file_set_ser->count;
 	file_set->files = phys_to_virt(file_set_ser->files);
@@ -799,6 +806,13 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
+		if (strnlen(file_ser[i].compatible,
+			    sizeof(file_ser[i].compatible)) ==
+		    sizeof(file_ser[i].compatible)) {
+			err = -EINVAL;
+			goto err_discard;
+		}
+
 		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index f52e8114837e..cdd293408138 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -165,7 +165,14 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 		return -ENODATA;
 
 	for (int i = 0; i < fh->header_ser->count; i++) {
+		if (strnlen(fh->ser[i].name, sizeof(fh->ser[i].name)) ==
+		    sizeof(fh->ser[i].name))
+			return -EINVAL;
+
 		if (!strcmp(fh->ser[i].name, flb->compatible)) {
+			if (!fh->ser[i].count)
+				return -EINVAL;
+
 			private->incoming.data = fh->ser[i].data;
 			private->incoming.count = fh->ser[i].count;
 			found = true;
@@ -578,6 +585,7 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
 
 int __init luo_flb_setup_incoming(void *fdt_in)
 {
+	struct luo_flb_header_ser *header_copy;
 	struct luo_flb_header_ser *header_ser;
 	int err, header_size, offset;
 	const void *ptr;
@@ -609,10 +617,31 @@ int __init luo_flb_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!header_ser_pa) {
+		pr_err("FLB header address is missing\n");
+		return -EINVAL;
+	}
+
+	if (!kho_is_restorable_phys(header_ser_pa))
+		return -EINVAL;
+
 	header_ser = phys_to_virt(header_ser_pa);
+	if (header_ser->pgcnt != LUO_FLB_PGCNT || header_ser->count > LUO_FLB_MAX) {
+		kho_restore_free(header_ser);
+		return -EINVAL;
+	}
+
+	header_copy = kmemdup(header_ser,
+			      sizeof(*header_copy) +
+			      header_ser->count *
+			      sizeof(*luo_flb_global.incoming.ser),
+			      GFP_KERNEL);
+	kho_restore_free(header_ser);
+	if (!header_copy)
+		return -ENOMEM;
 
-	luo_flb_global.incoming.header_ser = header_ser;
-	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
+	luo_flb_global.incoming.header_ser = header_copy;
+	luo_flb_global.incoming.ser = (void *)(header_copy + 1);
 	luo_flb_global.incoming.active = true;
 
 	return 0;
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 602001327f58..f7f62f11d17c 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -673,6 +673,14 @@ int __init luo_session_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
+	if (!header_ser_pa) {
+		pr_err("Session header address is missing\n");
+		return -EINVAL;
+	}
+
+	if (!kho_is_restorable_phys(header_ser_pa))
+		return -EINVAL;
+
 	header_ser = phys_to_virt(header_ser_pa);
 
 	luo_session_global.incoming.header_ser = header_ser;
@@ -697,9 +705,22 @@ int luo_session_deserialize(void)
 	if (!sh->active)
 		return err;
 
+	if (sh->header_ser->count > LUO_SESSION_MAX) {
+		pr_warn("Invalid session count %llu\n", sh->header_ser->count);
+		err = -EINVAL;
+		goto out_free_header;
+	}
+
 	for (int i = 0; i < sh->header_ser->count; i++) {
 		struct luo_session *session;
 
+		if (strnlen(sh->ser[i].name, sizeof(sh->ser[i].name)) ==
+		    sizeof(sh->ser[i].name)) {
+			pr_warn("Session name is not NUL-terminated\n");
+			err = -EINVAL;
+			goto out_discard;
+		}
+
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
 			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
@@ -728,9 +749,11 @@ int luo_session_deserialize(void)
 	}
 
 out_free_header:
-	kho_restore_free(sh->header_ser);
-	sh->header_ser = NULL;
-	sh->ser = NULL;
+	if (sh->header_ser) {
+		kho_restore_free(sh->header_ser);
+		sh->header_ser = NULL;
+		sh->ser = NULL;
+	}
 
 	return err;
 
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 8a453c8bfdf5..b7f996176ad8 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -363,6 +363,10 @@ static void memfd_luo_abort(struct liveupdate_file_op_args *args)
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
+	if (!args->serialized_data ||
+	    !kho_is_restorable_phys(args->serialized_data))
+		return;
+
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return;
@@ -399,10 +403,16 @@ static int memfd_luo_retrieve_folios(struct file *file,
 {
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	u64 max_index = i_size_read(inode);
+	u64 prev_index = 0;
 	struct folio *folio;
+	long put_from = 0;
 	int err = -EIO;
 	long i;
 
+	if (max_index)
+		max_index = (max_index - 1) >> PAGE_SHIFT;
+
 	for (i = 0; i < nr_folios; i++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
 		phys_addr_t phys;
@@ -412,6 +422,19 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (!pfolio->pfn)
 			continue;
 
+		put_from = i;
+		if (pfolio->flags &
+		    ~(MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE)) {
+			err = -EINVAL;
+			goto put_folios;
+		}
+
+		if (pfolio->index > max_index ||
+		    (i && pfolio->index <= prev_index)) {
+			err = -EINVAL;
+			goto put_folios;
+		}
+
 		phys = PFN_PHYS(pfolio->pfn);
 		folio = kho_restore_folio(phys);
 		if (!folio) {
@@ -419,7 +442,9 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			       phys);
 			goto put_folios;
 		}
+		put_from = i + 1;
 		index = pfolio->index;
+		prev_index = index;
 		flags = pfolio->flags;
 
 		/* Set up the folio for insertion. */
@@ -469,10 +494,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	 * Note: don't free the folios already added to the file. They will be
 	 * freed when the file is freed. Free the ones not added yet here.
 	 */
-	for (long j = i + 1; j < nr_folios; j++) {
+	for (long j = put_from; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+		phys_addr_t phys;
+
+		if (!pfolio->pfn)
+			continue;
 
-		folio = kho_restore_folio(pfolio->pfn);
+		phys = PFN_PHYS(pfolio->pfn);
+		folio = kho_restore_folio(phys);
 		if (folio)
 			folio_put(folio);
 	}
@@ -487,10 +517,32 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
+	if (!kho_is_restorable_phys(args->serialized_data))
+		return -EINVAL;
+
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return -EINVAL;
 
+	if (!!ser->nr_folios != !!ser->folios.first.phys) {
+		err = -EINVAL;
+		goto free_ser;
+	}
+
+	if (ser->nr_folios >
+	    (((u64)ser->folios.total_pages << PAGE_SHIFT) /
+	     sizeof(*folios_ser))) {
+		err = -EINVAL;
+		goto free_ser;
+	}
+
+	if (ser->nr_folios &&
+	    (!ser->size ||
+	     ser->nr_folios > ((ser->size - 1) >> PAGE_SHIFT) + 1)) {
+		err = -EINVAL;
+		goto free_ser;
+	}
+
 	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-- 
2.53.0


