Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6601BC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1386B00B6; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3880B6B00B7; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D686B00BA; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9A7F6B00B6
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC213140161
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:22:18 +0000 (UTC)
X-FDA: 84994552356.28.2DFB373
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 472F910000F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:22:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g35KrwmO;
	spf=pass (imf14.hostedemail.com: domain of pedrodemargomes@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784204537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rpGdWJFpIUEvAvYjxewkkqgZyu1hAM+6SDZkgbpU9xg=;
	b=YLGDU/peYuCiCX53y5q3xLLS9zWCuWSQgMzgAcvhf6Nup1C9R7uAM8bqX6ZQOlFb6EF6Ki
	V97ZacxU+Cof6tAXtE1GBIPA+l5nHr2r5HDzSBBVHbSZgiO0ECbM3vPXlhvjNxhqhi3VMb
	sUHS6BKsXbHNMK0Qak98pts/HKfQO7E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g35KrwmO;
	spf=pass (imf14.hostedemail.com: domain of pedrodemargomes@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784204537;
	b=NEvdr+zC52JeKbb8sSXf2dh2RNwIk1IUBYSPEIivbHjEpY4pVIaKwcW3TqXLgKA+ZkKq4r
	6q0qfxUTfoNlxj3H0ums4FX5cKVuQe9Ek4lDhO/Ia+Law9M/o1lbUAyNnS4u2NjUlcKJAs
	a58v2793gAGxTV7uZZbJeNkOkCDQBtQ=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-668296d0ff3so731432d50.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784204536; x=1784809336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rpGdWJFpIUEvAvYjxewkkqgZyu1hAM+6SDZkgbpU9xg=;
        b=g35KrwmO7Cx4W52RAbnI3IbRJIWo9o+S8TfvdD1h+BhN0nS3og/k0g46LaugoL5TE6
         mNjnjqW3RTsqC43+76IynFp2pXJ4kCndMJTTg4krvzUkmmU/0CYBblNWKFIuJHMPEXfa
         sumTAlugA2rISauq2jycsJ3257eA+rBp3T8/GgwhP1QuJFzSiYvCdZ3wK79Z3nVFOm/n
         TcqSvoAMyoY61jx+eE0WJVElqWtP7wTyd2n9vi003gQTcgM5EmPpGVUY6enpo25Y6mOW
         3LY0GhQm3JDvlADSHCzboMWWrr1NBb0noa1f0yZa2NPgA4kXZtzWK08lkhXSJ4RNunAp
         JjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784204536; x=1784809336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rpGdWJFpIUEvAvYjxewkkqgZyu1hAM+6SDZkgbpU9xg=;
        b=JcT2hAiMa7MNTIzB+csS0PndhDfK5vjB3s+QRoAuILAU2dOsURvg2qMk8W5J1JO+C5
         Xs/RUa7hH9Baqr8PHyaBer94IKdWNpcoQga/NieMcKIMCbTGXhxpSP4AhfgUrrohedMB
         +E/lUzyGCyUdKOaUN3Z2qDun+T9IwDINMDGQXzqq215bmcibGjd5yDs6h85gI9A/0lT5
         z7vJ/MFnFUFTv5Z5EQu11tHbVJxJXOLDmC40imbn4yA8aDMhE8JW/bi5jziLwLyUWLAg
         LJN+fQXNY9IzR6IPsrtudY5eTHNRQaNwQrhEKIYIbppHkObslh5KtjYeumvhNIAJC1HS
         LKJA==
X-Gm-Message-State: AOJu0YyI/5hz8xdClbm74aFnnQ6s/rdphFebqF4dj7lcUqsIOZdJYTTK
	jHdUB4WZZVvdUXnqeoIbI9uioIe+5OFYBh0W0NN2TljiN7aXu7/po6S4
X-Gm-Gg: AfdE7cmPucuri02zyeoMDCeGe2ZFhZOgNzKDZtJrAYqradeHBm42Emq3MvBdMaCiCDj
	I+wlynYk2WQo3LLjcjBWWI1oBmvCEBe59jhMjlrWZCq6qR9FxjWYSp48okozN6P/91RRNZLoczn
	d74UOeIxikgfot3gCMTTudUMewqKe2yWLAk38+uHZmfndc35xdHsoo6gfl8yhiQUnemGfxQcWSz
	4HLZxGm1WunXafa/y0olgANcwIPXn+Jmmry4SfLMftd+xM8sKTHnVlmZihZ4yugiJBZ8VSqN9OW
	TZfNru8fYKbU4Ixixcm5xfe8MOG0w+WgPrzd4efjUids0YnX2NJd8C76+aiqLgEs485Lb0WwZQ+
	ktVDjFhE20QY8lhwyyRRlztlcZIWj92jWKPBn/5FvZJyZNNJArbz8FceggUT3mZVcMmYBQUGyIG
	cJKlrs59+al/0ewmuuTp4zVMog8NOUlrMEeDr+1g==
X-Received: by 2002:a05:690e:4312:b0:664:ef34:4b with SMTP id 956f58d0204a3-6681347ed35mr4069141d50.76.1784204535115;
        Thu, 16 Jul 2026 05:22:15 -0700 (PDT)
Received: from fedora ([2804:30c:1f53:aa00:1495:7d0a:c9fe:c63a])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6681fc49cf2sm3165524d50.9.2026.07.16.05.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 05:22:14 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [RFC PATCH] mm/ksm: use checksum to speed up page comparison
Date: Thu, 16 Jul 2026 09:20:39 -0300
Message-ID: <20260716122039.679173-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 472F910000F
X-Stat-Signature: ec7966pk5x68heabgzir6qcmggfi9gmn
X-HE-Tag: 1784204537-413207
X-HE-Meta: U2FsdGVkX1+t9ulnjX79PTY7mbvp8xGeb44LVKKLLat0np3pDiOwXVqS8tSDIhmnrhEe+MLp8RtTrl0DKMXFh09RGxbjlWX1KdQcbF1Hsxfcv8ZwrhTIu2lTXK6hzXAGk9NT9iGSew54lRsWJUn/49kGqOonvpL6MnjkBIR/pNib0TVN4uo9q1kWkdP7ab38M3qOuObL5olPGo1KpIWteyf8W8m7/UE8m6ibnZMUaFooKZ6DW3ng6bTw2on4i0owumj39c5t/mqA0EuI5D0AfbKA8SUKLJ67mUzQr2moX5Z/YQpHgy8cJvOd9XGyZ1+E1aiFHllOuII6OAix8TcTicGdbhVaH2SuDlSZaDAfXT39sODSLSbo1RQ1GlBMCU3K5WMfO1fiMb+RxWwsfOburOim82rC08K1wyu5bN6dTtWsf7nXOOQU352kcNLxQVrWNzajQ+KJejgKAwTo5WqwPkT2tSSgctAVy93GWdZQQn7Z1dYWWGL+K6rofXa25mJPAZNitlQCPftrzO1disgZAomJ4X65FbHelTdotDBYLIscJeCj/An31kxFmiis70UfMIP4JBqF5WC+RiYuz5IfHJJyShLEyw7r0IQ6V93M6diJYBMp6Dj86recFsvqznql16GBpXEvz/s1LOM03oSsp1Ykj5lPHhJnl8f6VpCS4je9Quhnu2jEmCrXJgsCtO+tp3oFU8oIF3hlLjnRk7sL6K0qhY6V3pvZC+43EAwt4aNMzN7w3krh+CxG4FoOAUHUcZCVStbSzWSihTNGFfX++XI9NRpGgISp2sFyhdACHnysSiMeVvD4kp+zXfKwRIQR1gRcpJQV0C7nDn2MFh0w1Tu5Id0nmBJ2W6/UHDAiytYBSmq92kipQ3TzkWHz9Fek/xiMoabTBuRCX/HTaXR4lPDvoPge/Q/F3Ww4PLePVI8UYM9OGO6YfUiUB+9j4ejgKHbVzxxyjxQxNk8eXy0
 Nzvyyq6d
 PWIblhjnhfyEbcgIMXq9KJ/PPYuAzNROyObDN8+8OCwciZVa9cnQSHvYeMBCb292UDd0lTJGpRHMMb8nv3yQuNMQtLuS1ohsXDWxBF3p7IGhk1lWaFkTvcQbL5gvffpAVJr1Kl91nuffMT8ScyrPcZoRMOf9mq1laYvAqZwnvbxQ+Cu0XGs0cl6TJUS3kdpjSvoCDmMtSsX02bbfwwaS3gq97x/afGwwU+cL5QHMgPpCKm6FE3ZWqAmBNTSJGH5ER5IQhjTYIc+hHAhPiA4cl4B5nA/FG1dW2r3qFkWIwf9N0aYETdyjHiFtxqMSaRpVRDmwCPkZXWBRiHoeR2v1SmIR/0yuHCdddR+hMEmPixcrDqkRoPO1a9CRXz7cCSwSQ70Sgu+p02AS9xXXmlJpyAwmaWTetdbSwmTyt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use page checksums as the primary ordering key when traversing the stable
and unstable trees and fall back to memcmp_pages() only when checksums
match.
Since struct ksm_stable_node does not have a checksum field, create one
in a union with migration list fields, so when we encounter a migration
page while scanning an address space we have to recalculate the page
checksum. This avoids increasing the size of struct ksm_stable_node,
which is maintained at 64 bytes, as show below.

pedro@fedora:~/tmp/linux$ pahole -C ksm_stable_node ./vmlinux
struct ksm_stable_node {
	union {
		struct {
			struct rb_node node __attribute__((__aligned__(8))); /*     0    24 */
			unsigned int checksum;           /*    24     4 */
		} __attribute__((__aligned__(8))) __attribute__((__aligned__(8)));       /*     0    32 */
		struct {
			struct list_head * head;         /*     0     8 */
			struct {
				struct hlist_node hlist_dup; /*     8    16 */
				struct list_head list;   /*    24    16 */
			};                               /*     8    32 */
		};                                       /*     0    40 */
	} __attribute__((__aligned__(8)));               /*     0    40 */
	struct hlist_head          hlist;                /*    40     8 */
	union {
		long unsigned int  kpfn;                 /*    48     8 */
		long unsigned int  chain_prune_time;     /*    48     8 */
	};                                               /*    48     8 */
	int                        rmap_hlist_len;       /*    56     4 */
	int                        nid;                  /*    60     4 */

	/* size: 64, cachelines: 1, members: 5 */
	/* forced alignments: 1 */
} __attribute__((__aligned__(8)));

To evaluate this change it was used two benchmarks, bench1.c and
bench2.c. The first one allocates 8G of pages with different content,
and the second one allocates 8G of pages where the first 4G are the same
as the last 4G. The two benchmarks and the system ksm configuration are
presented below.

bench1.c:

int main() {
	size_t size = 8ULL * 1024*1024*1024;
	unsigned long long int numpages = size/PAGESZ;
	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	// Generate #numpages pages with different contents
	for (unsigned long long i = 0; i < numpages; i++) {
		*((unsigned long long *) &pages[i*PAGESZ]) = i;
	}

	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
        	perror("madvise MADV_MERGEABLE failed");
        	return 1;
    	}
	printf("Wait...\n");
	getchar();
	return 0;
}

bench2.c:

int main() {
	size_t size = 8ULL * 1024*1024*1024;
	unsigned long long int numpages = size/PAGESZ;
	char *pages = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

	// Generate #numpages pages with different contents
	for (unsigned long long i = 0; i < numpages/2; i++) {
		*((unsigned long long *) &pages[i*PAGESZ]) = i;
		*((unsigned long long *) &pages[(numpages-i-1)*PAGESZ]) = i;
	}

	if (madvise(pages, size, MADV_MERGEABLE) != 0) {
        	perror("madvise MADV_MERGEABLE failed");
        	return 1;
    	}
	printf("Wait...\n");
	getchar();
	return 0;
}

Configuration:

echo never >  /sys/kernel/mm/transparent_hugepage/enabled
echo 1 >  /sys/kernel/mm/ksm/sleep_millisecs
echo 100000 >  /sys/kernel/mm/ksm/pages_to_scan
echo 0 >  /sys/kernel/mm/ksm/use_zero_pages
echo 1 > /sys/kernel/mm/ksm/smart_scan
echo 1 >  /sys/kernel/mm/ksm/run

It was used the following bpftrace command to measure the scan time and
compare the numbers of the vanilla and patched version of the two
benchmarks:

bpftrace -e 'tracepoint:ksm:ksm_start_scan { @start_ns = nsecs; }
tracepoint:ksm:ksm_stop_scan {
    $elapsed = nsecs - @start_ns;
    printf("KSM scan finished in %llu ns\n", $elapsed);
    delete(@start_ns);
}'

The number of scans and the sum of the scan times of bench1:

bench1: 58 scans
	PATCHED		121847114611 ns
	VANILLA		416445370473 ns
	SPEED UP	3.4177

In bench2 ksm takes two scans to merge all 4G of memory. So comparing the scan
times of the first two scans:

bench2: 2 scans
	PATCHED		58344341937 ns
	VANILLA		84007052386 ns
	SPEED UP	1.4398

This patch is based on commit
'd9031030ac19defb229537d22ad53e9bb4303ccc'.

Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 112 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 78 insertions(+), 34 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..c79b0328d5ca 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -147,6 +147,7 @@ struct ksm_scan {
 /**
  * struct ksm_stable_node - node of the stable rbtree
  * @node: rb node of this ksm page in the stable tree
+ * @checksum: checksum of this ksm page
  * @head: (overlaying parent) &migrate_nodes indicates temporarily on that list
  * @hlist_dup: linked into the stable_node->hlist with a stable_node chain
  * @list: linked into migrate_nodes, pending placement in the proper node tree
@@ -158,7 +159,10 @@ struct ksm_scan {
  */
 struct ksm_stable_node {
 	union {
-		struct rb_node node;	/* when node of stable tree */
+		struct {
+			struct rb_node node;	/* when node of stable tree */
+			unsigned int checksum;
+		};
 		struct {		/* when listed for migration */
 			struct list_head *head;
 			struct {
@@ -847,6 +851,7 @@ static struct ksm_stable_node *alloc_stable_node_chain(struct ksm_stable_node *d
 		INIT_HLIST_HEAD(&chain->hlist);
 		chain->chain_prune_time = jiffies;
 		chain->rmap_hlist_len = STABLE_NODE_CHAIN;
+		chain->checksum = dup->checksum;
 #if defined (CONFIG_DEBUG_VM) && defined(CONFIG_NUMA)
 		chain->nid = NUMA_NO_NODE; /* debug */
 #endif
@@ -1816,6 +1821,18 @@ static __always_inline struct folio *chain(struct ksm_stable_node **s_n_d,
 	return __stable_node_chain(s_n_d, s_n, root, false);
 }
 
+static __always_inline int ksm_memcmp_pages(struct page *page1,
+					    unsigned int checksum1,
+					    struct page *page2,
+					    unsigned int checksum2)
+{
+	if (checksum1 < checksum2)
+		return -1;
+	if (checksum1 > checksum2)
+		return 1;
+	return memcmp_pages(page1, page2);
+}
+
 /*
  * stable_tree_search - search for page inside the stable tree
  *
@@ -1825,7 +1842,7 @@ static __always_inline struct folio *chain(struct ksm_stable_node **s_n_d,
  * This function returns the stable tree node of identical content if found,
  * -EBUSY if the stable node's page is being migrated, NULL otherwise.
  */
-static struct folio *stable_tree_search(struct page *page)
+static struct folio *stable_tree_search(struct page *page, unsigned int checksum)
 {
 	int nid;
 	struct rb_root *root;
@@ -1869,7 +1886,8 @@ static struct folio *stable_tree_search(struct page *page)
 			goto again;
 		}
 
-		ret = memcmp_pages(page, &tree_folio->page);
+		ret = ksm_memcmp_pages(page, checksum, &tree_folio->page,
+				       stable_node->checksum);
 		folio_put(tree_folio);
 
 		parent = *new;
@@ -1946,6 +1964,7 @@ static struct folio *stable_tree_search(struct page *page)
 	DO_NUMA(page_node->nid = nid);
 	rb_link_node(&page_node->node, parent, new);
 	rb_insert_color(&page_node->node, root);
+	page_node->checksum = checksum;
 out:
 	if (is_page_sharing_candidate(page_node)) {
 		folio_get(folio);
@@ -1973,6 +1992,7 @@ static struct folio *stable_tree_search(struct page *page)
 			rb_replace_node(&stable_node_dup->node,
 					&page_node->node,
 					root);
+			page_node->checksum = checksum;
 			if (is_page_sharing_candidate(page_node))
 				folio_get(folio);
 			else
@@ -1989,6 +2009,7 @@ static struct folio *stable_tree_search(struct page *page)
 			list_del(&page_node->list);
 			DO_NUMA(page_node->nid = nid);
 			stable_node_chain_add_dup(page_node, stable_node);
+			page_node->checksum = checksum;
 			if (is_page_sharing_candidate(page_node))
 				folio_get(folio);
 			else
@@ -2027,6 +2048,7 @@ static struct folio *stable_tree_search(struct page *page)
 	VM_BUG_ON(!is_stable_node_dup(stable_node_dup));
 	VM_BUG_ON(page_node->head != &migrate_nodes);
 	list_del(&page_node->list);
+	page_node->checksum = checksum;
 	DO_NUMA(page_node->nid = nid);
 	stable_node_chain_add_dup(page_node, stable_node);
 	goto out;
@@ -2048,10 +2070,12 @@ static struct ksm_stable_node *stable_tree_insert(struct folio *kfolio)
 	struct rb_node *parent;
 	struct ksm_stable_node *stable_node, *stable_node_dup;
 	bool need_chain = false;
+	unsigned int checksum;
 
 	kpfn = folio_pfn(kfolio);
 	nid = get_kpfn_nid(kpfn);
 	root = root_stable_tree + nid;
+	checksum = calc_checksum(&kfolio->page);
 again:
 	parent = NULL;
 	new = &root->rb_node;
@@ -2076,7 +2100,9 @@ static struct ksm_stable_node *stable_tree_insert(struct folio *kfolio)
 			goto again;
 		}
 
-		ret = memcmp_pages(&kfolio->page, &tree_folio->page);
+		ret = ksm_memcmp_pages(&kfolio->page, checksum,
+				       &tree_folio->page,
+				       stable_node->checksum);
 		folio_put(tree_folio);
 
 		parent = *new;
@@ -2116,6 +2142,7 @@ static struct ksm_stable_node *stable_tree_insert(struct folio *kfolio)
 
 	folio_set_stable_node(kfolio, stable_node_dup);
 
+	stable_node_dup->checksum = checksum;
 	return stable_node_dup;
 }
 
@@ -2150,43 +2177,52 @@ struct ksm_rmap_item *unstable_tree_search_insert(struct ksm_rmap_item *rmap_ite
 	while (*new) {
 		struct ksm_rmap_item *tree_rmap_item;
 		struct page *tree_page;
-		int ret;
 
 		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct ksm_rmap_item, node);
-		tree_page = get_mergeable_page(tree_rmap_item);
-		if (!tree_page)
-			return NULL;
-
-		/*
-		 * Don't substitute a ksm page for a forked page.
-		 */
-		if (page == tree_page) {
-			put_page(tree_page);
-			return NULL;
-		}
-
-		ret = memcmp_pages(page, tree_page);
 
 		parent = *new;
-		if (ret < 0) {
-			put_page(tree_page);
+		if (rmap_item->oldchecksum < tree_rmap_item->oldchecksum) {
 			new = &parent->rb_left;
-		} else if (ret > 0) {
-			put_page(tree_page);
+		} else if (rmap_item->oldchecksum >
+				tree_rmap_item->oldchecksum) {
 			new = &parent->rb_right;
-		} else if (!ksm_merge_across_nodes &&
-			   page_to_nid(tree_page) != nid) {
+		} else {
+			int ret;
+
+			tree_page = get_mergeable_page(tree_rmap_item);
+			if (!tree_page)
+				return NULL;
+
 			/*
-			 * If tree_page has been migrated to another NUMA node,
-			 * it will be flushed out and put in the right unstable
-			 * tree next time: only merge with it when across_nodes.
+			 * Don't substitute a ksm page for a forked page.
 			 */
-			put_page(tree_page);
-			return NULL;
-		} else {
-			*tree_pagep = tree_page;
-			return tree_rmap_item;
+			if (page == tree_page) {
+				put_page(tree_page);
+				return NULL;
+			}
+
+			ret = memcmp_pages(page, tree_page);
+
+			if (ret < 0) {
+				put_page(tree_page);
+				new = &parent->rb_left;
+			} else if (ret > 0) {
+				put_page(tree_page);
+				new = &parent->rb_right;
+			} else if (!ksm_merge_across_nodes &&
+				page_to_nid(tree_page) != nid) {
+				/*
+				 * If tree_page has been migrated to another NUMA node,
+				 * it will be flushed out and put in the right unstable
+				 * tree next time: only merge with it when across_nodes.
+				 */
+				put_page(tree_page);
+				return NULL;
+			} else {
+				*tree_pagep = tree_page;
+				return tree_rmap_item;
+			}
 		}
 	}
 
@@ -2271,6 +2307,14 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		if (stable_node->head != &migrate_nodes &&
 		    rmap_item->head == stable_node)
 			return;
+		/*
+		 * If stable_node is in migrate_nodes list its checksum field
+		 * is not valid, so calculate it here
+		 */
+		if (stable_node->head == &migrate_nodes)
+			checksum = calc_checksum(page);
+		else
+			checksum = stable_node->checksum;
 		/*
 		 * If it's a KSM fork, allow it to go over the sharing limit
 		 * without warnings.
@@ -2295,15 +2339,15 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		if (!try_to_merge_with_zero_page(rmap_item, page))
 			return;
 	}
-
 	/* Start by searching for the folio in the stable tree */
-	kfolio = stable_tree_search(page);
+	kfolio = stable_tree_search(page, checksum);
 	if (kfolio == folio && rmap_item->head == stable_node) {
 		folio_put(kfolio);
 		return;
 	}
 
 	remove_rmap_item_from_tree(rmap_item);
+	rmap_item->oldchecksum = checksum;
 
 	if (kfolio) {
 		if (kfolio == ERR_PTR(-EBUSY))
-- 
2.54.0


