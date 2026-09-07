Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B582EC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5DA6B00A0; Mon,  7 Sep 2026 12:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6286B00A1; Mon,  7 Sep 2026 12:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796206B00A2; Mon,  7 Sep 2026 12:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 372C56B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:20:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 946EB1201CC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:20:14 +0000 (UTC)
X-FDA: 85187478348.28.C15DF01
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf17.hostedemail.com (Postfix) with ESMTP id E808E40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:20:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lhdX6I+w;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gnFlqb7FNpx1IekqWGvNIYSqHIOkMZFYqW/qRrsd9Oc=;
	b=A/080Gv3H3nVASrh5z1TBNxfGNyzQ2LYksF3ADVvD9ZwOeUc5vQRXivcbUKRUbsUFgfVJf
	0wo4Qat87zxEo8SG6i9ZyChh4KXSnhIxWMD3njT6NiposinP7jTcPLHUMq/lOrTZBtOXg2
	hTdgJGi/eac8rUHxhHOVY3AqhgQqum4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lhdX6I+w;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798012;
	b=FYCnCMrlCnLXfy1MHQE6J+IQ5eERQC0SWjwLefwabWcX/uO6jPnvsG2M+vp4v/hp7GUHUU
	nsYN3xXME+37/5qBgT8X5hqqQE/uqLVMFDP+dV6Mepy6eNv3Z8tczncuUx1OJSKRh79ItB
	xX+ZCIy6pr4qnBah9p1/pC8KgDpiMdE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1XGBWTFhM0L2uu8mbsMWE7IDB6a9pxtBEz2fzhyTJss=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788798009; v=1; x=1789402809;
 b=lhdX6I+wPMJisjE7w4iyu9YJs0DGZ3CASufr7Nf9f4PdMWCxbM8VSertyIvEpNUPuF9UK001
 6IGcJ/1TFFMwYjV0E9PK3fqsmqA6JZy4fpSAcXPHeS+m6gNrBVcNFf0xu+GZq6wu7GxXhwHnffe
 79j+2iLddWI+PR+hBX6YbV0U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5b486cf219189843;
	Mon, 07 Sep 2026 16:19:59 +0000
X-Mizu-Trace-ID: 5b486cf219189843
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: yosry@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com
Cc: kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm: zswap: don't fail a large-folio swapin whose range is not in zswap
Date: Mon,  7 Sep 2026 09:19:38 -0700
Message-ID: <20260907161938.1932355-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o99k7yjc5kwuwaxfcdzn1t841xeqf3pw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E808E40002
X-Rspam-User: 
X-HE-Tag: 1788798010-345137
X-HE-Meta: U2FsdGVkX1+3apdX+UYKsx8POU8+/lE32GP+NciOQGqI+WHZ82kIvBvjP3tOGQOzMDFN7umle1buYyOy0RyX9NLPyn5JBJriRPfG789oNpfzx/vFXoTjUcriO774jY7Pwl9FD1988/hdM9w+n+Aqcvpj1etsCjgUn6tALsvSwH3N+Q4PAal6oDJpftRAMy+kJTF7JpxGSinwZ1ApDgWAT/jviAMQBFT0JD0WELXIQKK8fmHqhMgFzXiZHujZ5njWPNU5B15Z3aKUbHqGnLt1YYV0QajX5YevTIaq2Rc4803Z3NlK7wEkfW0YO8lxuojN3TxcZ1kFbKUMR3abAgFbMjcSv2RWN28l7DOgIOvuRZQGn4Cki09SbVHBAs1CnF6siypRfJBbz2fNL/mV+0GQzZoCV+wqTga+Cy2FVWNx5h8Rm40HGKZo4uU723iq65eh8SJrxR5AzZCm6kY5o6R8d4Vh7s3UqcWGcrtvQe3+MP5bV8KuwYANHBS+2nw0+32D9NrUkSk7/tuABxXfNHS7D1Bd0Kx94MjDOLfspaSETogCARkdn6IXHEH5t67tzSecPMPLHuhSnDugy7uTebwSWaDIr8BkeO08xfAxSYYRS1VHhgxxSeJ/7sttKStx2JZzRyboOmXUkANS8rV4fs96UGwmfhWbUDHATBQ0CYf9pa+fdt66Dl1wyYROzkk6NciTtuZxzjt1pFsK9qNg3LfvBlxBZPCnsAxJp66JobNodHt/eQbihPDaxWnNr/qk6z0XuZDlKhudkc5XtHJlGnOsAEqO4/9AKv8AK0RgWpoJUrl2J49x7D3kuR4dvGUOYfXw6Qve/JIb6z1mXI7BNy7TiO/NM6j3Xgcr/LMMUeIMa5pNntlePnJFOXcibDoefaqQfe44tmH5LJ+sUvM4awugKzCu8ZDHzsRv/MXSF4i6RREP3wEA6vgny3wOu9R1nrCTpOrwaQ49J/nFGeKNKFZ
 kwwe6Z3l
 PYme+1Xj1OB+mGPV8f25g7xEwqHWGHr4k5gGMAmpQAP3Qm9S0zUaMS2BAOE0QoJgvBR/HtWAgy9t59EEVl+CPBw5cqjwG9gWyz+fTW+zH6RB6NSdJ11oBNQt0r5saGDO+CZywts6gN8Ucy+9JLtRPMwTVJJmYDy/tqgx/jAJL4YgvXC2Rh7bp+rQ2ByPBtFk9tK0xEb1llTQ3BItKiN82KVhDFz/kkq81ehwerxk+cyjOozVbwaViK11MN2VtDLuVmHUU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
zswap_never_enabled() to decide whether a swapin may use a large folio.
zswap_load() samples the same one-way static key again once the read
reaches it.  Nothing serialises the two reads, and in between the task
allocates and pins a high-order folio, which can sleep.

If zswap is enabled for the first time in that window, a large folio that
was correctly permitted reaches zswap_load(), which rejects every large
folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
as "zswap handled it" and skips the backing-device read, so the folio
comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
for shmem.  The data is intact on the swap device - it was written there
before zswap was ever enabled - and the not-uptodate folio stays in the
swap cache, so every retry of the fault fails the same way.  With
panic_on_warn the WARN takes the machine down rather than the task.

Scan the range instead of rejecting the folio.  The caller has pinned
every slot before issuing the read, so zswap cannot start a store or a
writeback into the range and the scan is stable.  If nothing in the range
is in zswap it is all on the backing device: return -ENOENT and let
swap_read_folio() read it.

A range that does have a slot in zswap is still refused, because zswap
stores large folios as order-0 entries and cannot reconstruct one.  That
stays reachable - a slot shared with another task can be stored inside
the same window - and refusing is correct, since the alternative is
returning the stale device copy.  Report it as -EIO rather than -EINVAL:
the request is valid, zswap just cannot serve it.  The only caller
distinguishes -ENOENT from everything else, so that part is a
documentation fix.

Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Cc: stable@vger.kernel.org
Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 58 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..fd36ac38e9a1e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1571,6 +1571,32 @@ bool zswap_store(struct folio *folio)
 	return ret;
 }
 
+/**
+ * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check
+ *
+ * Context: The caller must keep the range pinned, otherwise the answer can
+ * change under it.
+ * Return: true if at least one slot in the range is in zswap.
+ */
+static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	struct xarray *tree = swap_zswap_tree(entry);
+	unsigned long index = offset;
+
+	/*
+	 * A pinned range is at most SWAPFILE_CLUSTER slots and is aligned to
+	 * its own size, so one tree covers all of it and a single lookup is
+	 * enough. Scanning only part of the range would report a false
+	 * "absent" and let the caller read a stale copy from the device.
+	 */
+	BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
+
+	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
+}
+
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
@@ -1578,15 +1604,12 @@ bool zswap_store(struct folio *folio)
  * Return: 0 on success, with the folio unlocked and marked up-to-date, or one
  * of the following error codes:
  *
- *  -EIO: if the swapped out content was in zswap, but could not be loaded
- *  into the page due to a decompression failure. The folio is unlocked, but
- *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
- *  will SIGBUS).
- *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EIO: if the swapped out content was in zswap but could not be handed
+ *  back, either because decompression failed or because a slot in a
+ *  large-folio range is still in zswap and zswap cannot reconstruct a large
+ *  folio from per-page entries. The folio is unlocked, but NOT marked
+ *  up-to-date, so that an IO error is emitted (e.g. do_swap_page() will
+ *  SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1605,13 +1628,18 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * A large folio can legitimately reach zswap_load() with its whole
+	 * range on the backing device, so scan the range rather than rejecting
+	 * it outright. The caller has pinned every slot, so zswap cannot start
+	 * a store or a writeback into the range while we look.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (WARN_ON_ONCE(zswap_is_present(swp,
+						  folio_nr_pages(folio)))) {
+			folio_unlock(folio);
+			return -EIO;
+		}
+		return -ENOENT;
 	}
 
 	entry = xa_load(tree, offset);
-- 
2.53.0-Meta


