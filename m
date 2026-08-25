Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB4BC5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6961D6B00A1; Mon, 24 Aug 2026 22:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FF26B00A2; Mon, 24 Aug 2026 22:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5355D6B00A3; Mon, 24 Aug 2026 22:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 279DB6B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:27:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A53F81C171A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:27 +0000 (UTC)
X-FDA: 85138205334.02.C9C64C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 74C9940007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:27:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l98Y5shB;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624845;
	b=ZUyMIRQs92IlKmsx522is7g2YywV0T9xr0taDE835Cb4Y2pHFo+VK5dxOTJlSDuYx5KuDT
	zdxXBHXT9pL3Ni7i9oJRbxTukuniXubeDgaylBkWi1rSdyguNno0qy/FgfIcWW1kDqzdu+
	XX8efLowrS+OYSLRbugP7GLEzcpFero=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l98Y5shB;
	spf=pass (imf17.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEdJik5d7Qt4RJJH8YjwskAz6j1p5QH/xqQKb6YvaA0=;
	b=BjwCTFR8Tl2lbMlV2nqbzBTp+UsJeXOvVfyanO/gy6zlMziIp4hb/G1iIJGQvWAYsIEaHu
	DFU3rLx1CCZ6VRl4dTvbe0KHGaW44O6zlOU0ywo1duQNwrYe3MVbDFX9VX2NUKA07R1qVY
	mvPJVzhgq7qGnAznrYAkYck/tdtdmmk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624845; x=1819160845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mlXvc2rRoY2YlNiSOc7Za57w/VMQm4ZP5P9P9htgZBo=;
  b=l98Y5shBGGVXYa4ZqJICVe6ALizPiauM1O0B2jc4UzlT3t81oIC3CxSO
   5PS6jp4SRloaIHVdI0xEQNyyPXj2YJXPMJU8H1WLZ6AHe+OkrkUhNKijG
   cxLiZ4GyuHf0422WeU5GDPKp/h9LbvuYzv106y3C668EeSJLWsVh/h7be
   EGuyqXTs/8JzOXt8xPDDcoOB7TEOL/pSmNdr3RlbquaH48IO0aoV79Sud
   J9hB8ymMYosb5FQuA1buKgZf3Okkwq12dXtzmHTsjDwjKLrOb5BNdRpvZ
   fq25hYQ2EoeJ92v5BkEvQYUbtXioYwBhp3hCsS8jxUCOo4YuRn06NTygi
   A==;
X-CSE-ConnectionGUID: c0m7ghhGRMygWDOdXaaB0A==
X-CSE-MsgGUID: vYh0/Dc7TOSMxYuuLEBkDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761096"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761096"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:25 -0700
X-CSE-ConnectionGUID: dBw0ZWZbTCKZ3Pil1roFLw==
X-CSE-MsgGUID: kbHXBOSMRlutXt3xqVFERg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390092"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:27:18 -0700
From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
To: linux-cxl@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [PATCH v2 06/13] drivers/base/memory: Add cxl_offline_memory() to offline a physical range
Date: Tue, 25 Aug 2026 04:26:21 +0200
Message-ID: <20260825022628.3651434-7-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74C9940007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gyfwe15ficcd14g8wx7u5acmc3jzezb6
X-HE-Tag: 1787624845-935690
X-HE-Meta: U2FsdGVkX1+cu+Wista52trObw2p+qHjhCUV5G+PreMApFY2JX8TpivKsj4B23UDbbcvKFt2aeeAXu/Ffsb6dtCfSzym2hsG6st5hNmXnAcERjhID/E5hHSmRjtUdtutDtOC7UmgOHtBGeNNs/QfCUcOfrlVvMBMqKOA3SoxqkWvcMMT5EZuO5X/WfZfL7tOvQG91Im/ZU+4uLaH+8UrRlF26bm/cXLnqjnKdqV9xl2zWb8a4wfsUaIhmadBLhiSA2G96/Hx0FhcQbsGqHtybIuQwAmU9IwBawqOzEeKoX/vlUVwF9Pw5eoPOJqoli1MjbAmUSRJE5PLNOOweKTI2MsAUNPo7HR9e0XxH5Aep/HxOS8XnxgYArrnouDByiP2irnJlz5ksPT7kDkFNwenMbUoxiKZeSZJ/iHcU6LkU8cKE5Wu85UqoDJvOhNykOVGQ/itNzSPPDnf636E8rKuh/6yiDUQb52SstYbK0AHT5OGcBa1ZskFynw8iPe1wYbauFedKyMmZBPWqTFKqRj5HJyyaA8RwiKVvJgEkIY7DrTLhGqrjM+CxYjvCDLyG8bIP2Xq0DpdcGAPNx92+p5A7kuzCGbF8yjPzeskTzYofEtkyidKoyuiwgW6/FDBT2vUP+TpeLqrFlkCLHiiqirVYMVNIjtLORDUh1ShWxxBFyLvgYfgs7+72K3skM6ivXXf0yH+S7Oo5vnH+XWGZ4/PQ/v+y+0ASXbUQ7oTL7pkt1ki8xtzj1SvpIX6oUaXKRNR1XPLqqgZOMnAFSZXMxXjqsvJIu4GjayMMuxjof5sGCG+cHiJ7bUa7KSP1kF0qrMw+knGeiORrgXdJU1vIGueW7ODP1M3AXHsgihvjTjcKRltIwtBRu3SFZdmb1BNi9UE1heDQCJmFmd90b64gJukrxrD9iZ3uR85ifuQkpUU6OiZwYP67cKCnwIrm9d+jZcNcEPULq046S5yFkmFPnN
 ZvEY0lPL
 XbT5BM55aeGkrCLEfkUoXMF78Zz3FPY4eDskCmOdJvU22IJ2UC0jA8ut5Fcq+bEMMbf+QCaRAokzEJCS4aiPxPi5ICdTgSmyTuJ+4l+xJGxaiKjjwB91G4vLOvHrEFM5Ith14vp3VuuIRxinbfaYHuAtGPGrydnY8Liv0IvqylPNlcNhZ12TdDgDzEMzw92ohwokBi9+TLJVEQ0L4RL5bqL80ulGkY1QwM56065cdIPbCkU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A CXL region whose capacity is online as System RAM must be taken
offline before a Secondary Bus Reset of the CXL Downstream Port it is
reached through.

Add cxl_offline_memory() to offline the memory blocks spanning a
physical range, exported in the CXL_MHP namespace since the CXL core is
its only caller.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 drivers/base/memory.c  | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/memory.h |  5 +++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bcfe2d9f4adb..ce89b251d34a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -1018,6 +1018,42 @@ int walk_memory_blocks(unsigned long start, unsigned long size,
 	return ret;
 }
 
+static int cxl_offline_memory_block(struct memory_block *mem, void *arg)
+{
+	int rc = device_offline(&mem->dev);
+
+	/* device_offline() returns a positive value when already offline. */
+	if (rc > 0)
+		return 0;
+
+	return rc;
+}
+
+/**
+ * cxl_offline_memory - offline the memory blocks spanning a physical range
+ * @start: start of the range, memory-block aligned
+ * @size: size of the range, a multiple of the memory block size
+ *
+ * Offline every memory block in [start, start + size). The blocks are offlined
+ * but not removed, so the range can be brought back online afterward. The
+ * caller owns the range and this performs no validation on it.
+ *
+ * Return: 0 on success, negative errno if a block cannot be offlined.
+ *
+ * Context: process context. Sleeps and takes the memory hotplug lock.
+ */
+int cxl_offline_memory(u64 start, u64 size)
+{
+	int rc;
+
+	lock_device_hotplug();
+	rc = walk_memory_blocks(start, size, NULL, cxl_offline_memory_block);
+	unlock_device_hotplug();
+
+	return rc;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_offline_memory, "CXL_MHP");
+
 struct for_each_memory_block_cb_data {
 	walk_memory_blocks_func_t func;
 	void *arg;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..5dc0b96fb004 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -149,6 +149,10 @@ static inline unsigned long memory_block_advised_max_size(void)
 {
 	return 0;
 }
+static inline int cxl_offline_memory(u64 start, u64 size)
+{
+	return 0;
+}
 #else /* CONFIG_MEMORY_HOTPLUG */
 extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
@@ -167,6 +171,7 @@ typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
 extern int walk_memory_blocks(unsigned long start, unsigned long size,
 			      void *arg, walk_memory_blocks_func_t func);
 extern int for_each_memory_block(void *arg, walk_memory_blocks_func_t func);
+int cxl_offline_memory(u64 start, u64 size);
 
 extern int memory_group_register_static(int nid, unsigned long max_pages);
 extern int memory_group_register_dynamic(int nid, unsigned long unit_pages);
-- 
2.55.0


