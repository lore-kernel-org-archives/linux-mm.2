Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E23606A8AF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=XiIA02YZ
Received: by kanga.kvack.org (Postfix)
	id 209896B05BA; Wed, 11 Nov 2026 18:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFFD6B05BB; Wed, 11 Nov 2026 18:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1736B05BC; Wed, 11 Nov 2026 18:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA04C6B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:02:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27E6CA7E09
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:02:43 +0000 (UTC)
X-FDA: 85424364606.18.1AA59D3
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEE2A140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:02:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XiIA02YZ;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OflFe87HS9c4Visn4tWAD9fow5lKeWMqr06iOG1/oQ=;
	b=w/ybf6e9KPv3GaEUQ2Y7ehmnkQ7ZKcq/AyWPlSnd7Sn2aIBj6lDIdE6PivmTz0a/KOEL7E
	te1nI1SuqeIpaB5E019i2gt22FnV4tA54UFsbBuv9vgjDrUOEYzioiOHwkh4fH8dVzfREu
	SKtz6w3JeihHo91/WMIINx05rZ6GAK4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438161;
	b=RrRpHik1txBD46Ii8YNQTF5wcaqvA6tgowSVCfWPKGQ6HP9a9KjSDz9XniNcw49Za1K2fX
	9AmSdoxMBvXB/ZWVl8xra08uXEJIvkAJJPKjU6xuBVJYoEcYcQULS2BqH2YSrn8C990vn+
	IfgReJmdAKys+vOXS1+DQ4Vlbxi/FvU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XiIA02YZ;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438160; x=1825974160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5OflFe87HS9c4Visn4tWAD9fow5lKeWMqr06iOG1/oQ=;
  b=XiIA02YZMbW/Jz1fQTUAUnuZOmBCAwd4V3DrfwH8Cu9moWFuA+0sRYnf
   lDSFRzlA87FYfgNEbeX4lDHa99Xy9h4FPDIJZ1NTcH4JEc6IvBwcu1WR1
   A6xRR2o2a5UXVuXCEL6WaGMkfTrSxcy6RNRrhsrIvi8BPogDJM628r4ww
   47k9McuK92MjFZxC/q2bH2JoSp//nvXg6AbZ+PV7GucEINl/Bhqjya85V
   omo5Yj9ufzLow/b/A7VvZ7EOwGTMSqplI/YyEE24FYwhxnBzSL1cNf5lr
   wZ0ks6/NuW3CO+5rodS9XSoGHjxM0YInCwh8pN3gW0CjC26qh+qm6a0bD
   A==;
X-CSE-ConnectionGUID: gLBmUY0lTqq3/jumr5BsSA==
X-CSE-MsgGUID: yW61QaJ5Ti+MCkeC0I9UdQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33629711"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:02:39 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:12163]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 6e9a6bae-c78c-4e8d-bc27-44e7fbe529b6; Wed, 11 Nov 2026 23:02:39 +0000 (UTC)
X-Farcaster-Flow-ID: 6e9a6bae-c78c-4e8d-bc27-44e7fbe529b6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:02:39 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:02:36 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 20/40] nitro_enclaves: Add a helper to grow the slot pool
Date: Wed, 11 Nov 2026 22:59:24 +0000
Message-ID: <9b8b4376502f409760cd38f04201ff3b373e54a6.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: iatkr64wbhty5qtk1gw4s6js3fe44jkg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEE2A140003
X-HE-Tag: 1794438160-419922
X-HE-Meta: U2FsdGVkX189Qc9IdK2xyh6eNQp51GpPcHZuGQzxnb4mLbpgrxpPM3l44cggMdy5RxcdysuWXjKPr/uZEX1LT3cwXeEWp0yL66kvjrluO5N/SM8x6Wjmj4ExkRXngvtAhhxDPA7zMaB6uY3qu4deEnLaVC8XonGJKpkjx9WjifmWNMNmU7yELZacSq94djtKO3Gi4pUIm/IMd+VGlyOrKov7FioDuiymMKYORJdog18g6qnFw8R6winPiClP/jCDAsAB/DwvC9VwXdFzaP1N8tlmKfXfhfnTRRrUJCfFiU0KPs0O87KKcOTIkdjl2B3IgIk1Ijac0xuee4xigIVP9wtupEKjrDZRStK5zE0PejIc4GHnbaduGTgfV4ZWCprHDtyrExtaYSuiZTu63QG8F/R1JfcbQe7QPWH1qZxud3YB66AfA97/wLcni4M6y0Va1YL0fdbKZ75b4pXO/2l7sxJPBPoXip/NUCL/5Yj+z/NV/1S4AC7PgJBvi6OlpCPGpNo7fOTPT7jxtKSznqhu1peE6XYmhq3a3N4WksUvEB641mYaJUV5WRDwGbNmpJTRU18NR33eItk0gL9HMwqhmJsGHyYtoFNpKyZcddSLjE9AZQTt9sf93RrKC5HHrnDXUxlmvjAZYsSLg7g4rYG9xxSgXmi263dmHTAiq3tISSohJaCeWHqFMlClk9p+v+5f9sD35qx/tyMWpUlj1HtOSn7cNrZVWZILQQ3SD7XtX+Nz10VX8b1b5O87OB6nlXIpD69bdJvT/u9q6xetqyQh+EksCopAmaiICYWvN20MqC0hxl+GuucToTfk6DjMNKykkPX+tNndL52YfqgohCcP13F76LvnJPBplzHrlQUlSyfla7D9SjziRLoENTsZojx655Zqb9aNPkpO1pge/1DAsDvtbJ8ptUJnANkSE/FwxOtm4/EY73gAZ9dLb56oXINWJc4rlCUTqs/EsF1UGy/
 e/+hlpdL
 rGWXzye6s1tI9DJTxDAK0E+/cL0oah3NwS4UghGSfYnGw/C1xxotFDmvmz8Wby1DpRFlkdr52utYBxe1B/6Pao6c1SXCkPGNI+W555whPsWdzYWhUxUFGsZlpKiV9i2wMecOwJXQLFJgUryOZJbOYuyoVir0zoU2VcGJ31iF0TwazZHXsBTLnDPoMLAvRgWV00sQmZSblfyMPk2/OC29PH44eBCLEAycFypWVqJ6xBRohPXmulqfmeeoOflT9o7spbFIGapLwz8rtcQHAUXZu/AFbb49ht0/68Cku6nq6hBpZC1+j0rVwJvIHvPYnu5ivdoNkDqoYJ6nmrVUZS6l9L5aUMILOoHB0jvpdC3+EB2ItfBEMB9kUYMwauLB2F+piq9nf6ElSebEwYJfs2Eyeb7A3EfGbBK825uAeQx2ZwO4pQ/NfUw59ErzoRJ5M8wWlqO279QUWhcJ/hRkmpAbiMH+EWU27Q0+q1kPiv1zdOzYUqpG6GMOVKutRDGuYloprViGdfo28qzRr/INNIQbaAT7aVpOBNhVcbvAu2RtkdvVczxDeu+eB8RQP3CJLJDZamJPB5oAvtamf7nzXnReWt3JLlsVF4QF87GRjzfU8mIzvNI3RImRDWbzmfa3mALJ9wiG8niewCe3W41AoRvoEmwWpeGf+ZqKg+nVWn68NyBz/UdGEhGUE36ufZduFeg4ySohDVnZRz3wJemwCWMFz346AASQzCijafIVhHviOlzcWt2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In addition to the early boot pool allocations, users want to be able to
grow their pool at runtime. To the user, we only present a single maximum
slot count. Under the hood, there are 2 slot counters and the MIN() of
defines how many slots there really are. When growing, grow both of the
limits to satisfy the desired customer set maximum.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_pci_dev.c | 466 +++++++++++++++++++++--
 drivers/virt/nitro_enclaves/ne_pci_dev.h |  35 +-
 2 files changed, 474 insertions(+), 27 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index e42be1742a39c..9e304ffc2bd13 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -18,8 +18,10 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/nitro_enclaves.h>
+#include <linux/nodemask.h>
 #include <linux/pci.h>
 #include <linux/sizes.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/wait.h>
@@ -692,6 +694,61 @@ static void ne_slot_pool_read_geometry(struct pci_dev *pdev)
 	ne_pci_dev->slot_pool_gran = size;
 }
 
+/**
+ * ne_slot_pool_alloc_run() - Allocate one run for the slot pool.
+ * @nr_pages:	Number of pages in the run.
+ * @pref_nid:	NUMA node to try first.
+ * @out_cma:	Set to the CMA area the run came from.
+ *
+ * ne_alloc_contig() confines a run to the node it is given, which is what an
+ * enclave needs. A run in the slot pool is read and written by the device
+ * alone, so it can sit on any node that has memory, and a pool that stops
+ * growing because one node ran out is worth less than a pool spread over
+ * several. So walk the nodes that have memory, starting at @pref_nid, and take
+ * the first run any of them serves.
+ *
+ * A caller runs on a node that need not have memory of its own, and there is no
+ * run to be had from such a node, so a @pref_nid outside the set of nodes that
+ * have memory starts the walk at the first node that does. The walk then covers
+ * every node that can serve it.
+ *
+ * Context: Process context.
+ * Return: the first page of the run, NULL when no node served one, or the
+ *	   ERR_PTR() ne_alloc_contig() returned.
+ */
+static struct page *ne_slot_pool_alloc_run(unsigned long nr_pages,
+					   int pref_nid, struct cma **out_cma)
+{
+	int nid = pref_nid;
+	struct page *page;
+	int nr_nodes;
+	int i;
+
+	nr_nodes = num_node_state(N_MEMORY);
+	if (nr_nodes < 1)
+		return NULL;
+
+	if (pref_nid < 0 || pref_nid >= MAX_NUMNODES ||
+	    !node_state(pref_nid, N_MEMORY))
+		nid = first_node(node_states[N_MEMORY]);
+
+	for (i = 0; i < nr_nodes; i++) {
+		page = ne_alloc_contig(nr_pages, nid, out_cma);
+
+		/*
+		 * An error ends the walk along with a run: only a node that had
+		 * no run to give leaves NULL behind, and only then does the next
+		 * node get asked.
+		 */
+		if (page)
+			return page;
+
+		nid = next_node_in(nid, node_states[N_MEMORY]);
+	}
+
+	return NULL;
+}
+
 /**
  * ne_slot_pool_donate_base() - Donate the base run of the slot pool.
  * @pdev:	PCI device to donate to.
@@ -708,6 +765,7 @@ static void ne_slot_pool_read_geometry(struct pci_dev *pdev)
  *	    mutex held.
  * Return:
  * * 0 on success or if the base run has already been donated.
+ * * -EINTR if a fatal signal arrived while a run was being zeroed.
  * * Negative return value on failure.
  * * -ETIMEDOUT, or any other code ne_request_unanswered() names, if the
  *   request went unanswered, in which case the run stays recorded as donated
@@ -737,13 +795,13 @@ static int ne_slot_pool_donate_base(struct pci_dev *pdev)
 
 	nr_pages = size >> PAGE_SHIFT;
 
-	page = ne_alloc_contig(nr_pages, numa_node_id(), &cma);
+	page = ne_slot_pool_alloc_run(nr_pages, numa_node_id(), &cma);
 	if (IS_ERR_OR_NULL(page)) {
 		rc = page ? PTR_ERR(page) : -ENOMEM;
 
 		dev_warn(&pdev->dev,
-			 "Slot pool base size=%u not allocated on node %d [rc=%d]\n",
-			 size, numa_node_id(), rc);
+			 "Slot pool base size=%u not allocated [rc=%d]\n",
+			 size, rc);
 
 		return rc;
 	}
@@ -798,6 +856,7 @@ static int ne_slot_pool_donate_base(struct pci_dev *pdev)
  * Return:
  * * 0 on success.
  * * -ENOSPC if the pool has reached the ceiling the device reports.
+ * * -EINTR if a fatal signal arrived while a run was being zeroed.
  * * Negative return value on failure.
  * * -ETIMEDOUT, or any other code ne_request_unanswered() names, if the
  *   request went unanswered, in which case the run stays recorded as donated
@@ -809,14 +868,12 @@ static int ne_slot_pool_donate(struct pci_dev *pdev)
 	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	struct slot_pool_donate_req donate_req = {};
+	struct ne_slot_pool_run *run;
 	struct cma *cma = NULL;
 	unsigned long nr_pages;
 	struct page *page;
 	int rc;
 
-	if (ne_pci_dev->slot_pool_page)
-		return 0;
-
 	if (!ne_pci_dev->slot_pool_gran)
 		return -EOPNOTSUPP;
 
@@ -826,17 +883,27 @@ static int ne_slot_pool_donate(struct pci_dev *pdev)
 
 	nr_pages = ne_pci_dev->slot_pool_gran >> PAGE_SHIFT;
 
-	page = ne_alloc_contig(nr_pages, numa_node_id(), &cma);
+	run = kzalloc_obj(*run);
+	if (!run)
+		return -ENOMEM;
+
+	page = ne_slot_pool_alloc_run(nr_pages, numa_node_id(), &cma);
 	if (IS_ERR_OR_NULL(page)) {
 		rc = page ? PTR_ERR(page) : -ENOMEM;
 
 		dev_warn(&pdev->dev,
-			 "Slot pool granularity size=%u not allocated on node %d [rc=%d]\n",
-			 ne_pci_dev->slot_pool_gran, numa_node_id(), rc);
+			 "Slot pool granularity size=%u not allocated [rc=%d]\n",
+			 ne_pci_dev->slot_pool_gran, rc);
+
+		kfree(run);
 
 		return rc;
 	}
 
+	run->page = page;
+	run->cma = cma;
+	run->nr_pages = nr_pages;
+
 	donate_req.paddr = page_to_phys(page);
 
 	rc = ne_do_request(pdev, SLOT_POOL_DONATE,
@@ -851,21 +918,362 @@ static int ne_slot_pool_donate(struct pci_dev *pdev)
 		 * does and for the same reason.
 		 */
 		if (ne_request_unanswered(rc)) {
-			ne_pci_dev->slot_pool_page = page;
-			ne_pci_dev->slot_pool_cma = cma;
+			list_add(&run->node, &ne_pci_dev->slot_pool_meta_runs);
+			ne_pci_dev->slot_pool_meta_nr++;
 		} else {
 			ne_contig_free_run(cma, page, nr_pages);
+			kfree(run);
 		}
 
 		return rc;
 	}
 
-	ne_pci_dev->slot_pool_page = page;
-	ne_pci_dev->slot_pool_cma = cma;
+	list_add(&run->node, &ne_pci_dev->slot_pool_meta_runs);
+	ne_pci_dev->slot_pool_meta_nr++;
 
 	return 0;
 }
 
+/*
+ * Size of one run of memory the slot pool takes, and of the span the driver
+ * offers so that the device can place such a run inside it. A run begins on a
+ * boundary of its own size in the device's address space, and an address the
+ * parent aligns does not stay aligned once the device has mapped it, so the
+ * parent cannot place the run itself. A span of twice the size holds a run the
+ * device can place wherever the span begins.
+ */
+#define NE_SLOT_POOL_MEM_SIZE	SZ_128M
+#define NE_SLOT_POOL_MEM_SPAN	(2 * NE_SLOT_POOL_MEM_SIZE)
+
+/**
+ * ne_slot_pool_donate_nid() - Pick the node the next memory donation comes from.
+ * @nr_donated:	Number of runs of memory the slot pool already holds.
+ *
+ * The device turns a run of donated memory into memory it gives to enclaves, and
+ * the host grows the zone it takes that memory from on the node the run sits on.
+ * Every donation coming from one node grows that node's zone alone, so the
+ * enclaves the host places on any other node run on memory out of a zone that
+ * never grew, and the host runs that zone out and takes every enclave on the
+ * machine down with it. So spread the donations instead: step through the nodes
+ * that have memory in time with the runs already held, and successive donations
+ * come from successive nodes.
+ *
+ * A node that has no run to give costs a donation nothing, because
+ * ne_slot_pool_alloc_run() carries on from the node named here to the rest.
+ *
+ * Context: Process context.
+ * Return: the node the donation is to come from first.
+ */
+static int ne_slot_pool_donate_nid(unsigned int nr_donated)
+{
+	int nr_nodes = num_node_state(N_MEMORY);
+	unsigned int steps;
+	unsigned int i;
+	int nid;
+
+	if (nr_nodes < 1)
+		return numa_node_id();
+
+	steps = nr_donated % (unsigned int)nr_nodes;
+	nid = first_node(node_states[N_MEMORY]);
+
+	for (i = 0; i < steps; i++)
+		nid = next_node_in(nid, node_states[N_MEMORY]);
+
+	return nid;
+}
+
+/**
+ * ne_slot_pool_mem_donate() - Donate a run of memory to the slot pool.
+ * @pdev:	PCI device to donate to.
+ *
+ * The device counts the slots the pool's records support and the slots its
+ * memory supports separately, and hands out the smaller of the two counts.
+ * This donation raises the second count.
+ *
+ * The driver offers a span and the device answers with the run it took out of
+ * it, so the pages before and after that run go back to the allocator and the
+ * run alone stays recorded. A device that answers without naming a run inside
+ * the span leaves the whole span recorded, because which of the span's pages
+ * the device is using is then not established.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ * Return:
+ * * 0 on success.
+ * * -EINTR if a fatal signal arrived while the span was being zeroed.
+ * * Negative return value on failure.
+ * * -ETIMEDOUT, or any other code ne_request_unanswered() names, if the
+ *   request went unanswered, in which case the span stays recorded as donated
+ *   because the driver cannot establish that the device refused it. A device
+ *   that answers such a code itself lands here too and costs one held span.
+ */
+static int ne_slot_pool_mem_donate(struct pci_dev *pdev)
+{
+	const unsigned long span_pages = NE_SLOT_POOL_MEM_SPAN >> PAGE_SHIFT;
+	const unsigned long run_pages = NE_SLOT_POOL_MEM_SIZE >> PAGE_SHIFT;
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct slot_pool_mem_donate_req donate_req = {};
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	u64 span_paddr, taken_paddr, taken_size;
+	unsigned long head_pages, tail_pages;
+	struct ne_slot_pool_run *run;
+	struct cma *cma = NULL;
+	struct page *page;
+	int rc;
+
+	run = kzalloc_obj(*run);
+	if (!run)
+		return -ENOMEM;
+
+	page = ne_slot_pool_alloc_run(span_pages,
+				      ne_slot_pool_donate_nid(ne_pci_dev->slot_pool_mem_nr),
+				      &cma);
+	if (IS_ERR_OR_NULL(page)) {
+		rc = page ? PTR_ERR(page) : -ENOMEM;
+
+		dev_warn(&pdev->dev,
+			 "Slot pool memory span size=%u not allocated [rc=%d]\n",
+			 NE_SLOT_POOL_MEM_SPAN, rc);
+
+		kfree(run);
+
+		return rc;
+	}
+
+	span_paddr = page_to_phys(page);
+
+	run->page = page;
+	run->cma = cma;
+	run->nr_pages = span_pages;
+
+	donate_req.paddr = span_paddr;
+	donate_req.size = NE_SLOT_POOL_MEM_SPAN;
+
+	rc = ne_do_request(pdev, SLOT_POOL_MEM_DONATE,
+			   &donate_req, sizeof(donate_req),
+			   &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(&pdev->dev,
+				    "Error in slot pool memory donate [rc=%d]\n",
+				    rc);
+
+		/*
+		 * Record a span whose donation went unanswered as donated
+		 * instead of giving it back, as ne_slot_pool_donate_base() does
+		 * and for the same reason. The whole span is recorded, because
+		 * the run the device took out of it is what the answer that
+		 * never came would have named.
+		 */
+		if (ne_request_unanswered(rc)) {
+			list_add(&run->node, &ne_pci_dev->slot_pool_mem_runs);
+			ne_pci_dev->slot_pool_mem_nr++;
+		} else {
+			ne_contig_free_run(cma, page, span_pages);
+			kfree(run);
+		}
+
+		return rc;
+	}
+
+	taken_paddr = cmd_reply.mem_donate.consumed_paddr;
+	taken_size = cmd_reply.mem_donate.consumed_size;
+
+	/*
+	 * The run the device names has to be one run's worth, inside the span
+	 * it was offered, and to begin on a page boundary of the span, since
+	 * the pages given back are counted from where it begins. The device
+	 * places the run on a boundary of its own address space, which the
+	 * span's physical address says nothing about, so where in the span it
+	 * begins is only bounded, not fixed.
+	 */
+	if (taken_size == NE_SLOT_POOL_MEM_SIZE &&
+	    taken_paddr >= span_paddr &&
+	    taken_paddr - span_paddr <=
+		    NE_SLOT_POOL_MEM_SPAN - NE_SLOT_POOL_MEM_SIZE &&
+	    IS_ALIGNED(taken_paddr - span_paddr, PAGE_SIZE)) {
+		head_pages = (taken_paddr - span_paddr) >> PAGE_SHIFT;
+		tail_pages = span_pages - head_pages - run_pages;
+
+		run->page = page + head_pages;
+		run->nr_pages = run_pages;
+
+		if (head_pages)
+			ne_contig_free_run(cma, page, head_pages);
+
+		if (tail_pages)
+			ne_contig_free_run(cma, run->page + run_pages,
+					   tail_pages);
+	} else {
+		dev_warn(&pdev->dev,
+			 "Slot pool memory span kept, the device took paddr=0x%llx size=0x%llx\n",
+			 taken_paddr, taken_size);
+	}
+
+	list_add(&run->node, &ne_pci_dev->slot_pool_mem_runs);
+	ne_pci_dev->slot_pool_mem_nr++;
+
+	return 0;
+}
+
+/**
+ * ne_slot_pool_limits() - Read how many slots each half of the slot pool has
+ *			   room for.
+ * @pdev:	PCI device to read the slot pool limits of.
+ * @cmd_reply:	Reply the limits are read out of, valid on success.
+ *
+ * The reply is a snapshot. A caller that donates on the strength of it and then
+ * reads it again holds the enclaves list mutex across both.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_slot_pool_limits(struct pci_dev *pdev,
+			       struct ne_pci_dev_cmd_reply *cmd_reply)
+{
+	u8 unused = 0;
+
+	return ne_do_request(pdev, SLOT_POOL_GET_LIMITS,
+			     &unused, sizeof(unused),
+			     cmd_reply, sizeof(*cmd_reply));
+}
+
+/**
+ * ne_slot_pool_effective_limit() - Read how many slots the parent can use out
+ *				    of a reply the device filled.
+ * @cmd_reply:	Reply a SLOT_POOL_GET_LIMITS filled.
+ *
+ * A slot needs room in both halves of the pool, so the number of slots the
+ * parent can use is the smaller of the two the device reports.
+ *
+ * Context: Process context.
+ * Return: the number of slots the parent can use.
+ */
+static u16 ne_slot_pool_effective_limit(const struct ne_pci_dev_cmd_reply *cmd_reply)
+{
+	return min(cmd_reply->limits.meta_limit, cmd_reply->limits.mem_limit);
+}
+
+/**
+ * ne_slot_pool_grow() - Grow the slot pool until it holds @target slots.
+ * @pdev:	PCI device to donate to.
+ * @target:	Number of slots the pool is to hold.
+ *
+ * The device hands out the smaller of the slots its records support and the
+ * slots its memory supports, so each round donates to whichever of the two is
+ * behind and then asks the device for both counts again. Neither is behind
+ * when the two are level, and a round donates to both then, because a
+ * donation to one half of a level pair leaves the smaller count where it was.
+ *
+ * A round that leaves both counts where they were ends the growth: the device
+ * took every donation the round offered and got no further with any of them,
+ * and another round would allocate again for the same answer.
+ *
+ * The pool only grows. A run the device accepted cannot be taken back on its
+ * own, so growth that stops short leaves the pool at the size it reached.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ * Return:
+ * * 0 once the pool holds @target slots or more.
+ * * -EOPNOTSUPP on a device that takes no donation.
+ * * -EINVAL where @target is above the number of slots the device allows.
+ * * -ENOSPC where a round raised neither count and the pool is below @target.
+ * * -EINTR if a fatal signal arrived while a run was being zeroed.
+ * * Negative return value on failure.
+ */
+int ne_slot_pool_grow(struct pci_dev *pdev, u16 target)
+{
+	struct ne_pci_dev *ne_pci_dev = pci_get_drvdata(pdev);
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	u16 effective;
+	int rc;
+
+	if (!ne_pci_dev->slot_pool_max)
+		return -EOPNOTSUPP;
+
+	if (target > ne_pci_dev->slot_pool_max)
+		return -EINVAL;
+
+	rc = ne_slot_pool_donate_base(pdev);
+	if (rc < 0)
+		return rc;
+
+	rc = ne_slot_pool_limits(pdev, &cmd_reply);
+	if (rc < 0)
+		return rc;
+
+	effective = ne_slot_pool_effective_limit(&cmd_reply);
+
+	while (effective < target) {
+		u16 meta_before = cmd_reply.limits.meta_limit;
+		u16 mem_before = cmd_reply.limits.mem_limit;
+
+		if (cmd_reply.limits.mem_limit <= cmd_reply.limits.meta_limit) {
+			rc = ne_slot_pool_mem_donate(pdev);
+			if (rc < 0)
+				return rc;
+		}
+
+		if (cmd_reply.limits.meta_limit <= cmd_reply.limits.mem_limit) {
+			rc = ne_slot_pool_donate(pdev);
+			if (rc < 0)
+				return rc;
+		}
+
+		rc = ne_slot_pool_limits(pdev, &cmd_reply);
+		if (rc < 0)
+			return rc;
+
+		if (cmd_reply.limits.meta_limit <= meta_before &&
+		    cmd_reply.limits.mem_limit <= mem_before)
+			return -ENOSPC;
+
+		effective = ne_slot_pool_effective_limit(&cmd_reply);
+	}
+
+	return 0;
+}
+
+/**
+ * enum ne_slot_pool_runs_owner - Who keeps the runs of a drained list.
+ * @NE_RUNS_TO_ALLOCATOR:	The device handed the runs back, so they go back
+ *				to the allocator.
+ * @NE_RUNS_STAY_WITH_DEVICE:	The device may still use the runs, so only the
+ *				records of them go away.
+ */
+enum ne_slot_pool_runs_owner {
+	NE_RUNS_TO_ALLOCATOR,
+	NE_RUNS_STAY_WITH_DEVICE,
+};
+
+/**
+ * ne_slot_pool_runs_drain() - Empty a list of donated runs.
+ * @runs:	List of runs to empty.
+ * @nr:		Count of runs on @runs, set to zero.
+ * @owner:	Who keeps the runs.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ */
+static void ne_slot_pool_runs_drain(struct list_head *runs, unsigned int *nr,
+				    enum ne_slot_pool_runs_owner owner)
+{
+	struct ne_slot_pool_run *run, *next;
+
+	list_for_each_entry_safe(run, next, runs, node) {
+		if (owner == NE_RUNS_TO_ALLOCATOR)
+			ne_contig_free_run(run->cma, run->page, run->nr_pages);
+
+		list_del(&run->node);
+		kfree(run);
+	}
+
+	*nr = 0;
+}
+
 /**
  * ne_slot_pool_release() - Take the whole slot pool back from the device.
  * @pdev:	PCI device to take the pool back from.
@@ -904,17 +1312,15 @@ static void ne_slot_pool_release(struct pci_dev *pdev)
 	if (rc < 0) {
 		dev_err(&pdev->dev, "Error in slot pool shutdown [rc=%d]\n", rc);
 
-		goto unlock_mutex;
+		goto forget_runs;
 	}
 
-	if (ne_pci_dev->slot_pool_page) {
-		ne_contig_free_run(ne_pci_dev->slot_pool_cma,
-				   ne_pci_dev->slot_pool_page,
-				   ne_pci_dev->slot_pool_gran >> PAGE_SHIFT);
-
-		ne_pci_dev->slot_pool_page = NULL;
-		ne_pci_dev->slot_pool_cma = NULL;
-	}
+	ne_slot_pool_runs_drain(&ne_pci_dev->slot_pool_meta_runs,
+				&ne_pci_dev->slot_pool_meta_nr,
+				NE_RUNS_TO_ALLOCATOR);
+	ne_slot_pool_runs_drain(&ne_pci_dev->slot_pool_mem_runs,
+				&ne_pci_dev->slot_pool_mem_nr,
+				NE_RUNS_TO_ALLOCATOR);
 
 	ne_contig_free_run(ne_pci_dev->slot_pool_base_cma,
 			   ne_pci_dev->slot_pool_base_page,
@@ -923,6 +1329,20 @@ static void ne_slot_pool_release(struct pci_dev *pdev)
 	ne_pci_dev->slot_pool_base_page = NULL;
 	ne_pci_dev->slot_pool_base_cma = NULL;
 
+	goto unlock_mutex;
+
+forget_runs:
+	/*
+	 * The device keeps these runs, so only the records of them go, and the
+	 * pages they name stay the device's for as long as it is bound.
+	 */
+	ne_slot_pool_runs_drain(&ne_pci_dev->slot_pool_meta_runs,
+				&ne_pci_dev->slot_pool_meta_nr,
+				NE_RUNS_STAY_WITH_DEVICE);
+	ne_slot_pool_runs_drain(&ne_pci_dev->slot_pool_mem_runs,
+				&ne_pci_dev->slot_pool_mem_nr,
+				NE_RUNS_STAY_WITH_DEVICE);
+
 unlock_mutex:
 	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
 }
@@ -976,6 +1396,8 @@ static int ne_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	atomic_set(&ne_pci_dev->cmd_reply_avail, 0);
 	init_waitqueue_head(&ne_pci_dev->cmd_reply_wait_q);
 	INIT_LIST_HEAD(&ne_pci_dev->enclaves_list);
+	INIT_LIST_HEAD(&ne_pci_dev->slot_pool_meta_runs);
+	INIT_LIST_HEAD(&ne_pci_dev->slot_pool_mem_runs);
 	mutex_init(&ne_pci_dev->enclaves_list_mutex);
 	mutex_init(&ne_pci_dev->pci_dev_mutex);
 	ne_pci_dev->pdev = pdev;
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 3718f893e4f65..cab5434fc3e0d 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -468,6 +468,24 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply,
 		       limits.slots_per_donation) == 12);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, limits.reserved14) == 14);
 
+/**
+ * struct ne_slot_pool_run - One run of pages the driver gave the slot pool.
+ * @node:	Entry on the list of runs donated to one of the pools.
+ * @page:	First page of the run.
+ * @cma:	CMA area the run came from.
+ * @nr_pages:	Number of pages in the run.
+ *
+ * A record is allocated before the run it describes, and the run is recorded
+ * before the request carrying its address goes out, so a run the device
+ * accepted is a run ne_slot_pool_release() finds.
+ */
+struct ne_slot_pool_run {
+	struct list_head	node;
+	struct page		*page;
+	struct cma		*cma;
+	unsigned long		nr_pages;
+};
+
 /**
  * struct ne_pci_dev - Nitro Enclaves (NE) PCI device.
  * @cmd_reply_avail:		Variable set if a reply has been sent by the
@@ -501,9 +519,11 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply, limits.reserved14) == 14);
  *				has been made.
  * @slot_pool_base_cma:		CMA area the base donation came from.
  * @slot_pool_base_nr_pages:	Number of pages in the base donation.
- * @slot_pool_page:		First page of the donation to the slot pool, NULL
- *				until it has been made.
- * @slot_pool_cma:		CMA area the donation came from.
+ * @slot_pool_meta_runs:	Runs donated to hold the pool's slot descriptors.
+ * @slot_pool_meta_nr:		Number of runs on @slot_pool_meta_runs.
+ * @slot_pool_mem_runs:		Runs donated for the enclaves in the pool's
+ *				slots to run in.
+ * @slot_pool_mem_nr:		Number of runs on @slot_pool_mem_runs.
  */
 struct ne_pci_dev {
 	atomic_t		cmd_reply_avail;
@@ -522,13 +542,18 @@ struct ne_pci_dev {
 	struct page		*slot_pool_base_page;
 	struct cma		*slot_pool_base_cma;
 	unsigned long		slot_pool_base_nr_pages;
-	struct page		*slot_pool_page;
-	struct cma		*slot_pool_cma;
+	struct list_head	slot_pool_meta_runs;
+	unsigned int		slot_pool_meta_nr;
+	struct list_head	slot_pool_mem_runs;
+	unsigned int		slot_pool_mem_nr;
 };
 
 /* Whether a failure left a submitted request in flight. */
 bool ne_request_unanswered(int rc);
 
+/* Grow the slot pool until it holds a given number of slots. */
+int ne_slot_pool_grow(struct pci_dev *pdev, u16 target);
+
 /**
  * ne_do_request() - Submit command request to the PCI device based on the command
  *		     type and retrieve the associated reply.
-- 
2.47.1


