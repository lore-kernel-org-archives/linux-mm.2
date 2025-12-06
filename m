Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDD6D3B7E7
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3186B0029; Sat,  6 Dec 2025 18:04:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA926B002A; Sat,  6 Dec 2025 18:04:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A956B002B; Sat,  6 Dec 2025 18:04:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94C366B0029
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:04:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E671140696
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:04:16 +0000 (UTC)
X-FDA: 84190576512.12.A912AEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD56810000A
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:04:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTVmtdkf;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpoZyP+1SG9BKyQwUOnCTZSlFvru+q/ODzEUbF+jE24=;
	b=vIkX1W7XmbMCDZgD4kW8mQQhiXxjGhwGO94JV3bN+GkFBkA83Cz7S3gFQ4Vj33Njbrbg2D
	KH8wBsBPdif31sdOAZ10OuB1hO8yW7olBSwk6zS6+8jlx06SaXbjIWx1JbacRXztg4Gbe9
	rpoDbGZoLkLWkvosKlOKvMf1lJpfWqY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BTVmtdkf;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062254; a=rsa-sha256;
	cv=none;
	b=OpuwRPp7wolTCD+wWzRAMHttTSWHTEPJGHiK5/z0Y7D3g9W/NNLlsDvpCDJntziYLoNQif
	mfJaBAHrUw57SsKMh2IdT0fgOu8MFZhXn5NZr3u4mF+q/KcY/wzLBue7j/SNmk+2Onue81
	okKBUDG9yRtSGVG4z1IfDnVWjjBkZnQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43BA56014A;
	Sat,  6 Dec 2025 23:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93EA2C4CEF5;
	Sat,  6 Dec 2025 23:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062254;
	bh=NDHeVCuUjDMmNIZKthIG4Frfufso0cF/L4lCH7VKr1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTVmtdkfJVFbk7of3/cAI+SikpIYzLre/FrKdmQ2NO9INoXAkvWyQTSnrhDFUDc6/
	 p36RX5mTEsLT7bDlnJ7mwsSDiT/CYvDIlcFifYNATmHMtWANZfviBDmdV3MlJtWqsf
	 OavD/RgTRzloFRGqbmR5TntM5Othq+rh77uoyL8lsERmn/+ENPBK/b+LthU4XzUjB+
	 8oQotyYmx8QlAw+RDZ9yeHpl/kjLbBDIAcMrQuIGyTmQi77Q9vzbd5wXkh7+taJBed
	 cAXd75mqGcnh544HhAONsBeU6fvkYLeID7Kq5MkTVggbfkrZGLq9VtRBuAZiGPovoR
	 U/4fotMm/m4Ww==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 10/10] liveupdate: allow preserving hugetlb-backed memfd
Date: Sun,  7 Dec 2025 00:02:20 +0100
Message-ID: <20251206230222.853493-11-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k3hjq9jikteu3n9icc834adj5h1rxj3w
X-Rspamd-Queue-Id: CD56810000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765062254-341071
X-HE-Meta: U2FsdGVkX18Yk7gaH09Il0Zuyb4oPq90WOzfapDJ2pj8nhtkbOHZ0fC9m19yj3WHoegaLAjPqP8jAWk+8plpJoO7YtOaUxzoAiShqN2ddJMSuo/Z3uBwLA7y7d4jNTX3WAy6JfPhHH7eE8WGFeTsF1SA6yXfJbQR3s68WQUmQA33LB6UVor2oLc3yzTTxpIzj7w/hcNj18tpDOB2kjS8HjY2Mie5K1QEG0Qjq59QyG7n/Z+cOswcjcvM6h+SsFPnNHYfiv+U9/odI+fpVRsJF7DAHSjoOXmyaHfTdxt6Ut/38czv/dkhQb+zlhBAmwcfzo2l6ReECsfIMj0L8bzTkEGx1hPPOVSaHCsv5rN4iYHJh2WjZRBIntK+4NWAt26nenjLyZrmiWZtafo3L4KaIR7SeQsEma/JKVDccuXrfEG+sL6Ht8AQHx9l3tsa2oRfu7mOKb/Uw5hRc3i6QBtzxHzwA0o+zKMnHhj6Ki8OX8CPqS/RSx/4iamIKBBSeS1ljcxy/cY7O6xylrX6v2HoaJNIu0km0A9mxfpEmeUWQrx4eGM43Q6K4+4WR1/or1WtQkPjsyxD56HHuno87GA3KRhVbRR5BG+9dOOOFk5//vyny6RTcd0QSrH6KJ9oYl/BedvFDGStZK1mQ8NitRzTERC3iYA7+laA8+0NGGMTMpuJZlBT8nd6gExs/fdJYi64PpjHYV2dz6htMEl+GFYddrt4q4L+sdkKwww0FsnrHe3HIthL7+xEWL7/IEANb1ASEc/ovdA4+qzqLEtThcvWpyD0rNFXe3wnJAXWeQpWZrjkCZLZsUlXDGSL6jzHwQuzYiOYCorBYFUukox3T7G7DkVnHPfviOetna5apgoIoIkal/sIwSBeJIexgo4n3EdOrNvPeCf+VJN+JkIaJuSpLO97vTtEOpOZkYK0oqvB+9QvM1Nptb3v8LLx3GTVtwDxG4Iy2ueH02DDD3K0JIO
 gSbq0uOO
 VWKIYY50pX7yrqiTCqE2YZxMopgkOZoXOceA9P2E5sVyw0V8uU+9lBRNjs/OKXXVnrrI3ewvSzRsKC/vHrPxuitn+Pg06aqQofFZhumabBrLpUINMcwEh93HWAaTbAwPjGsoqCRyqUkl31jOsr9+uVA0tZUKOMeb17cS3NWtCYmtX5LbN5RhCMF+TWkoDkqgqH1gtSffQnORE5unyZa9H2WPLyNl3pSK6gy+eSnzUVM+CXShP3sILZC4d7kDux563AzoC216eu51B0Jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hugetlb-backed memfds can be used to improve performance by reducing TLB
pressure, page faults, and save memory when using HVO. They are also
commonly used to back VM memory, which is one of the primary users of
live update.

Add support for preserving a hugetlb-backed memfd across a live update.
The serialized data takes similar form to shmem-backed memfds. See
include/linux/kho/abi/memfd.h for more details. There is an additional
field for the file order to identify its hstate.

The behaviour of the file is also similar to shmem-backed memfds. The
file cannot grow or shrink once preserved, and all its pages are pinned
to avoid migration.

In addition, the preservation logic reports preserved hugepages to the
FLB so the right number of huge pages can be allocated on the next boot.

On file retrieve, the reservations are set up, the folios are first
prepped and added to the hstate, and then the folios are added to the
page cache.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 include/linux/kho/abi/hugetlb.h |  32 ++
 mm/hugetlb_luo.c                | 520 ++++++++++++++++++++++++++++++++
 mm/memfd_luo.c                  |   4 -
 3 files changed, 552 insertions(+), 4 deletions(-)

diff --git a/include/linux/kho/abi/hugetlb.h b/include/linux/kho/abi/hugetlb.h
index 55e833569c48..dad4358da062 100644
--- a/include/linux/kho/abi/hugetlb.h
+++ b/include/linux/kho/abi/hugetlb.h
@@ -9,6 +9,7 @@
 #define _LINUX_KHO_ABI_HUGETLB_H
 
 #include <linux/hugetlb.h>
+#include <linux/kexec_handover.h>
 
 /**
  * DOC: hugetlb-backed memfd live update ABI
@@ -63,4 +64,35 @@ static_assert(sizeof(struct hugetlb_ser) <= PAGE_SIZE);
 
 #define HUGETLB_FLB_COMPATIBLE "hugetlb-v1"
 
+/**
+ * struct hugemfd_folio_ser - Serialized state of a single folio.
+ * @pfn:          The page frame number of the folio.
+ * @reserved:     Reserved bits. Might be used for flags later.
+ * @index:        The page offset of the folio in the original file.
+ */
+struct hugemfd_folio_ser {
+	u64 pfn:52;
+	u64 reserved:12;
+	u64 index;
+} __packed;
+
+/**
+ * struct hugemfd_ser - Main serialization structure of a HugeTLB-backed memfd.
+ * @pos:          The file's current position (f_pos).
+ * @size:         The total size of the file in bytes (i_size).
+ * @nr_folios:    Number of folios in the folios array.
+ * @folios:       KHO vmalloc descriptor pointing to the array of
+ *                struct hugemfd_folio_ser.
+ * @order:        Order of the hugepages that back this file.
+ */
+struct hugemfd_ser {
+	u64 size;
+	u64 pos;
+	u64 nr_folios;
+	struct kho_vmalloc folios;
+	u8 order;
+} __packed;
+
+#define HUGE_MEMFD_COMPATIBLE "huge-memfd-v1"
+
 #endif /* _LINUX_KHO_ABI_HUGETLB_H */
diff --git a/mm/hugetlb_luo.c b/mm/hugetlb_luo.c
index 80e3e015eca5..6454f8955d18 100644
--- a/mm/hugetlb_luo.c
+++ b/mm/hugetlb_luo.c
@@ -8,13 +8,17 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/file.h>
 #include <linux/liveupdate.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/hugetlb_cgroup.h>
+#include <linux/vmalloc.h>
 #include <linux/kho/abi/hugetlb.h>
 #include <linux/spinlock.h>
 
 #include "hugetlb_internal.h"
+#include "hugetlb_vmemmap.h"
 
 struct hugetlb_flb_obj {
 	/* Serializes access to ser and its hstates. */
@@ -22,6 +26,11 @@ struct hugetlb_flb_obj {
 	struct hugetlb_ser *ser;
 };
 
+struct hugemfd_private {
+	struct hugemfd_folio_ser *folios_ser;
+	unsigned long nr_folios;
+};
+
 static int hugetlb_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct hugetlb_ser *hugetlb_ser;
@@ -172,8 +181,519 @@ unsigned long __init hstate_liveupdate_pages(struct hstate *h)
 	return hser ? hser->nr_pages : 0;
 }
 
+static bool hugemfd_can_preserve(struct liveupdate_file_handler *handler,
+				 struct file *file)
+{
+	struct inode *inode = file_inode(file);
+
+	return is_file_hugepages(file) && !inode->i_nlink;
+}
+
+static void hugemfd_unpreserve_folio(struct hstate *h, struct folio *folio)
+{
+	hugetlb_flb_del_folio(h);
+	kho_unpreserve_folio(folio);
+}
+
+static int hugemfd_preserve_folio(struct hstate *h, struct folio *folio,
+				  struct hugemfd_folio_ser *folio_ser)
+{
+	int err;
+
+	err = kho_preserve_folio(folio);
+	if (err)
+		return err;
+
+	err = hugetlb_flb_add_folio(h);
+	if (err)
+		goto err_unpreserve;
+
+	folio_ser->pfn = folio_pfn(folio);
+	folio_ser->index = folio->index;
+	return 0;
+
+err_unpreserve:
+	kho_unpreserve_folio(folio);
+	return err;
+}
+
+static int
+hugemfd_preserve_folios(struct hugemfd_ser *memfd_ser, struct file *file,
+			unsigned long *nr_foliosp,
+			struct hugemfd_folio_ser **out_folios_ser)
+{
+	struct hugemfd_folio_ser *folios_ser;
+	struct inode *inode = file_inode(file);
+	struct hstate *h = hstate_inode(inode);
+	unsigned int max_folios;
+	long i, nr_folios, size;
+	struct folio **folios;
+	pgoff_t offset;
+	int err;
+
+	size = i_size_read(inode);
+
+	if (!size) {
+		*nr_foliosp = 0;
+		*out_folios_ser = NULL;
+		memset(&memfd_ser->folios, 0, sizeof(memfd_ser->folios));
+		return 0;
+	}
+
+	/* Calculate number of folios in the file based on its size. */
+	max_folios = size / huge_page_size(h);
+	folios = kvmalloc_array(max_folios, sizeof(*folios), GFP_KERNEL);
+	if (!folios)
+		return -ENOMEM;
+
+	/*
+	 * Pin the folios so they don't move around behind our back. This also
+	 * ensures none of the folios are in CMA -- which ensures they don't
+	 * fall in KHO scratch memory. It also moves swapped out folios back to
+	 * memory.
+	 *
+	 * A side effect of doing this is that it allocates a folio for all
+	 * indices in the file. This might waste memory on sparse memfds. If
+	 * that is really a problem in the future, we can have a
+	 * memfd_pin_folios() variant that does not allocate a page on empty
+	 * slots.
+	 */
+	nr_folios = memfd_pin_folios(file, 0, size - 1, folios, max_folios, &offset);
+	if (nr_folios < 0) {
+		err = nr_folios;
+		goto err_free_folios;
+	}
+
+	folios_ser = vcalloc(nr_folios, sizeof(*folios_ser));
+	if (!folios_ser) {
+		err = -ENOMEM;
+		goto err_unpin;
+	}
+
+	for (i = 0; i < nr_folios; i++) {
+		err = hugemfd_preserve_folio(h, folios[i], &folios_ser[i]);
+		if (err)
+			goto err_unpreserve;
+	}
+
+	err = kho_preserve_vmalloc(folios_ser, &memfd_ser->folios);
+	if (err)
+		goto err_unpreserve;
+
+	kvfree(folios);
+
+	memfd_ser->nr_folios = nr_folios;
+	*nr_foliosp = nr_folios;
+	*out_folios_ser = folios_ser;
+	return 0;
+
+err_unpreserve:
+	for (i = i - 1; i >= 0; i--)
+		hugemfd_unpreserve_folio(h, folios[i]);
+	vfree(folios_ser);
+err_unpin:
+	unpin_folios(folios, nr_folios);
+err_free_folios:
+	kvfree(folios);
+	return err;
+}
+
+static int hugemfd_preserve(struct liveupdate_file_op_args *args)
+{
+	struct file *file = args->file;
+	struct inode *inode = file_inode(file);
+	struct hstate *h = hstate_inode(inode);
+	struct hugemfd_folio_ser *folios_ser;
+	struct hugemfd_private *private;
+	struct hugemfd_ser *memfd_ser;
+	unsigned long nr_folios;
+	int err;
+
+	private = kmalloc(sizeof(*private), GFP_KERNEL);
+	if (!private)
+		return -ENOMEM;
+
+	memfd_ser = kho_alloc_preserve(sizeof(*memfd_ser));
+	if (!memfd_ser) {
+		err = -ENOMEM;
+		goto err_free_private;
+	}
+
+	inode_lock(inode);
+
+	hugetlb_i_freeze(inode, true);
+
+	memfd_ser->size = i_size_read(inode);
+	memfd_ser->pos = file->f_pos;
+	memfd_ser->order = h->order;
+
+	err = hugemfd_preserve_folios(memfd_ser, file, &nr_folios, &folios_ser);
+	if (err)
+		goto err_unlock;
+
+	inode_unlock(inode);
+
+	private->folios_ser = folios_ser;
+	private->nr_folios = nr_folios;
+	args->private_data = private;
+	args->serialized_data = virt_to_phys(memfd_ser);
+
+	return 0;
+
+err_unlock:
+	hugetlb_i_freeze(inode, false);
+	inode_unlock(inode);
+	kho_unpreserve_free(memfd_ser);
+err_free_private:
+	kfree(private);
+	return err;
+}
+
+static void hugemfd_unpreserve_folios(struct hugemfd_ser *memfd_ser,
+				      struct hugemfd_folio_ser *folios_ser,
+				      unsigned long nr_folios,
+				      struct hstate *h)
+{
+	if (!nr_folios)
+		return;
+
+	kho_unpreserve_vmalloc(&memfd_ser->folios);
+
+	for (long i = 0; i < nr_folios; i++) {
+		struct folio *folio = pfn_folio(folios_ser[i].pfn);
+
+		hugemfd_unpreserve_folio(h, folio);
+		unpin_folio(folio);
+	}
+
+	vfree(folios_ser);
+}
+
+static void hugemfd_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct hugemfd_ser *memfd_ser = phys_to_virt(args->serialized_data);
+	struct hugemfd_private *private = args->private_data;
+	struct inode *inode = file_inode(args->file);
+	struct hstate *h = hstate_inode(inode);
+
+	inode_lock(inode);
+	hugemfd_unpreserve_folios(memfd_ser, private->folios_ser,
+				  private->nr_folios, h);
+	hugetlb_i_freeze(inode, false);
+	kho_unpreserve_free(memfd_ser);
+	kfree(private);
+	inode_unlock(inode);
+}
+
+static int hugemfd_freeze(struct liveupdate_file_op_args *args)
+{
+	struct hugemfd_ser *memfd_ser = phys_to_virt(args->serialized_data);
+
+	/*
+	 * The pos might have changed since prepare. Everything else stays the
+	 * same.
+	 */
+	memfd_ser->pos = args->file->f_pos;
+	return 0;
+}
+
+static void hugemfd_finish(struct liveupdate_file_op_args *args)
+{
+	struct hugemfd_ser *memfd_ser = phys_to_virt(args->serialized_data);
+	struct hugemfd_folio_ser *folios_ser;
+	LIST_HEAD(folio_list);
+	struct hstate *h;
+
+	if (args->retrieved)
+		return;
+
+	folios_ser = kho_restore_vmalloc(&memfd_ser->folios);
+	if (WARN_ON_ONCE(!folios_ser))
+		return;
+
+	h = size_to_hstate(PAGE_SIZE << memfd_ser->order);
+	if (!h) {
+		pr_warn("no hstate found for order %u\n", memfd_ser->order);
+		goto err_free_all;
+	}
+
+	/* Return the folios back to the hstate. */
+	for (u64 i = 0; i < memfd_ser->nr_folios; i++) {
+		struct folio *folio;
+
+		folio = kho_restore_folio(PFN_PHYS(folios_ser[i].pfn));
+		if (!folio)
+			continue;
+
+		if (!folio_ref_freeze(folio, 1)) {
+			pr_warn("unexpected refcount on PFN 0x%lx\n",
+				folio_pfn(folio));
+			continue;
+		}
+
+		init_new_hugetlb_folio(folio);
+		list_add(&folio->lru, &folio_list);
+	}
+
+	prep_and_add_allocated_folios(h, &folio_list);
+	vfree(folios_ser);
+	return;
+
+err_free_all:
+	for (u64 i = 0; i < memfd_ser->nr_folios; i++) {
+		struct folio *folio;
+
+		folio = kho_restore_folio(PFN_PHYS(folios_ser[i].pfn));
+		if (folio)
+			folio_put(folio);
+	}
+	vfree(folios_ser);
+}
+
+static int hugemfd_setup_rsrv(struct inode *inode)
+{
+	struct hstate *h = hstate_inode(inode);
+	long chg, regions_needed, add = -1;
+	/*
+	 * NOTE: Setting up the reservations for the whole file works right now
+	 * because during preserve all the folios are filled in when pinning.
+	 * Whenever that changes, this needs to be updated as well.
+	 */
+	long from = 0, to = inode->i_size >> huge_page_shift(h);
+	struct resv_map *resv_map;
+	struct hugetlb_cgroup *h_cg = NULL;
+	int err;
+
+	resv_map = inode_resv_map(inode);
+	chg = region_chg(resv_map, from, to, &regions_needed);
+	if (chg < 0)
+		return chg;
+
+	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
+					      chg * pages_per_huge_page(h),
+					      &h_cg) < 0) {
+		err = -ENOMEM;
+		goto err_region_abort;
+	}
+
+	/*
+	 * No need for hugetlb_acct_memory() to update h->resv_huge_pages since
+	 * the reserved pages we added here will get used immediately after in
+	 * hugemfd_retrieve_folios().
+	 *
+	 * No need for subpool reservations as well since the memfds come from
+	 * the internal mounts of hugetlbfs and that doesn't have subpools.
+	 */
+	add = region_add(resv_map, from, to, regions_needed, h, h_cg);
+	if (add < 0) {
+		err = add;
+		goto err_uncharge_cgroup;
+	}
+
+	hugetlb_cgroup_put_rsvd_cgroup(h_cg);
+
+	return 0;
+
+err_uncharge_cgroup:
+	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
+					    chg * pages_per_huge_page(h), h_cg);
+err_region_abort:
+	region_abort(resv_map, from, to, regions_needed);
+	return err;
+}
+
+static struct folio *hugemfd_retrieve_folio(struct hugemfd_folio_ser *folio_ser)
+{
+	struct folio *folio;
+
+	folio = kho_restore_folio(PFN_PHYS(folio_ser->pfn));
+	if (!folio)
+		return NULL;
+
+	init_new_hugetlb_folio(folio);
+	__folio_mark_uptodate(folio);
+	folio_ref_freeze(folio, 1);
+
+	return folio;
+}
+
+static void hugemfd_add_folios(struct hstate *h, struct list_head *folio_list)
+{
+	unsigned long flags;
+	struct folio *folio, *tmp_f;
+
+	/* Send list for bulk vmemmap optimization processing */
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
+
+	spin_lock_irqsave(&hugetlb_lock, flags);
+	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
+		account_new_hugetlb_folio(h, folio);
+		folio_clear_hugetlb_freed(folio);
+		list_move(&folio->lru, &h->hugepage_activelist);
+	}
+	spin_unlock_irqrestore(&hugetlb_lock, flags);
+}
+
+static int hugemfd_retrieve_folios(struct file *file,
+				   struct hugemfd_ser *memfd_ser)
+{
+	struct hugemfd_folio_ser *folios_ser;
+	struct inode *inode = file_inode(file);
+	struct hstate *h = hstate_inode(inode);
+	int err, hidx = hstate_index(h);
+	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	struct address_space *mapping;
+	struct hugetlb_cgroup *h_cg;
+	struct folio *folio;
+	LIST_HEAD(list);
+	u64 nr_folios;
+
+	if (!memfd_ser->size)
+		return 0;
+
+	folios_ser = kho_restore_vmalloc(&memfd_ser->folios);
+	if (!folios_ser)
+		return -ENOMEM;
+
+	nr_folios = memfd_ser->nr_folios;
+	mapping = inode->i_mapping;
+
+	/* First prepare the folios and add them to the hstate. */
+	for (u64 i = 0; i < nr_folios; i++) {
+		struct hugemfd_folio_ser *folio_ser = &folios_ser[i];
+
+		folio = hugemfd_retrieve_folio(folio_ser);
+		if (!folio) {
+			err = -EINVAL;
+			goto err_free_folios_ser;
+		}
+
+		list_add(&folio->lru, &list);
+	}
+
+	hugemfd_add_folios(h, &list);
+
+	/* Now that all the folios are prepared, add them to the file. */
+	for (u64 i = 0; i < nr_folios; i++) {
+		folio = pfn_folio(folios_ser[i].pfn);
+		folio_ref_unfreeze(folio, 1);
+
+		err = hugetlb_add_to_page_cache(folio, mapping,
+						folios_ser[i].index >> memfd_ser->order);
+		if (err) {
+			pr_err("failed to add to page cache: %pe\n", ERR_PTR(err));
+			goto err_free_folios_ser;
+		}
+
+		spin_lock_irq(&hugetlb_lock);
+		err = hugetlb_cgroup_charge_cgroup(hidx, pages_per_huge_page(h),
+						   &h_cg);
+		if (err) {
+			spin_unlock_irq(&hugetlb_lock);
+			folio_unlock(folio);
+			goto err_free_folios_ser;
+		}
+		hugetlb_cgroup_commit_charge(hidx, pages_per_huge_page(h), h_cg, folio);
+		spin_unlock_irq(&hugetlb_lock);
+
+		err = mem_cgroup_charge_hugetlb(folio, gfp);
+		if (err) {
+			folio_unlock(folio);
+			goto err_free_folios_ser;
+		}
+
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	vfree(folios_ser);
+	return 0;
+
+err_free_folios_ser:
+	/*
+	 * NOTE: The folios of the file might be in use for DMA or other
+	 * things. It is unsafe to free them. Leak them, and let userspace get
+	 * the error code and decide what to do.
+	 */
+	vfree(folios_ser);
+	return err;
+}
+
+/*
+ * NOTE: Leaking the file in the error paths is intentional here. The memory
+ * might be in use by devices, and it is unsafe to release it. Return the error
+ * to userspace and let it decide how to recover, usually by rebooting the
+ * system.
+ */
+static int hugemfd_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct hugemfd_ser *memfd_ser;
+	struct file *file;
+	int err;
+
+	memfd_ser = phys_to_virt(args->serialized_data);
+
+	file = hugetlb_file_setup("", 0, VM_NORESERVE, HUGETLB_ANONHUGE_INODE,
+				  memfd_ser->order + PAGE_SHIFT);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_memfd_ser;
+	}
+
+	vfs_setpos(file, memfd_ser->pos, MAX_LFS_FILESIZE);
+	file->f_inode->i_size = memfd_ser->size;
+
+	err = hugemfd_setup_rsrv(file_inode(file));
+	if (err)
+		goto err_free_memfd_ser;
+
+	if (memfd_ser->nr_folios) {
+		err = hugemfd_retrieve_folios(file, memfd_ser);
+		if (err)
+			goto err_free_memfd_ser;
+	}
+
+	args->file = file;
+	kho_restore_free(memfd_ser);
+	return 0;
+
+err_free_memfd_ser:
+	kho_restore_free(memfd_ser);
+	return err;
+}
+
+static const struct liveupdate_file_ops hugemfd_luo_ops = {
+	.can_preserve = hugemfd_can_preserve,
+	.preserve = hugemfd_preserve,
+	.unpreserve = hugemfd_unpreserve,
+	.freeze = hugemfd_freeze,
+	.finish = hugemfd_finish,
+	.retrieve = hugemfd_retrieve,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler hugemfd_handler = {
+	.ops = &hugemfd_luo_ops,
+	.compatible = HUGE_MEMFD_COMPATIBLE,
+};
+
 void __init hugetlb_luo_init(void)
 {
+	int err;
+
 	if (!liveupdate_enabled())
 		return;
+
+	err = liveupdate_register_file_handler(&hugemfd_handler);
+	if (err) {
+		pr_err("could not register file handler: %pe\n", ERR_PTR(err));
+		return;
+	}
+
+	err = liveupdate_register_flb(&hugemfd_handler, &hugetlb_luo_flb);
+	if (err) {
+		pr_err("could not register hugetlb FLB handler: %pe\n", ERR_PTR(err));
+		liveupdate_unregister_file_handler(&hugemfd_handler);
+		return;
+	}
 }
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 4f6ba63b4310..de715d67d543 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -26,10 +26,6 @@
  *    The LUO API is not stabilized yet, so the preserved properties of a memfd
  *    are also not stable and are subject to backwards incompatible changes.
  *
- * .. note::
- *    Currently a memfd backed by Hugetlb is not supported. Memfds created
- *    with ``MFD_HUGETLB`` will be rejected.
- *
  * Preserved Properties
  * ====================
  *
-- 
2.43.0


