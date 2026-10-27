Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08DE606A327
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YgSp1vpe
Received: by kanga.kvack.org (Postfix)
	id 454766B05C0; Tue, 27 Oct 2026 00:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4056D6B05C1; Tue, 27 Oct 2026 00:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A89F6B05C2; Tue, 27 Oct 2026 00:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE5726B05C0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:32:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 353AEA85A3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:32:35 +0000 (UTC)
X-FDA: 85367135070.12.F501DED
Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B6B5A0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:32:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgSp1vpe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793075553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2ND1QfRhZdF2pJbYoRVTOMDw2ymU46dc6kpoYJ7tzKI=;
	b=BUL/1Kyn+FxwT2TZax1ysQKfWYoRyO4XsHIXmgY6YLLRJNOUBqOOlps6BEYcV4CP4JnY3F
	s/lj4vNPLa8qRBOn00g7YgPkL0bTCRXALcGEBbo1XdsEj08oKbyGj8Q74CmbKyxQnMWt1H
	k+gAayZYbH6LAw7mW3vBiV44r/CcImk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YgSp1vpe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793075553;
	b=Ilx5SSrtZ0ACOM4+NijI5FcapgQG6ojXk/oEGKYkLMIv7AIY1qzIXaVVGk/71cRGXgaHmq
	2cwdst7k6t5yMxWectjSWy+n94v0EGDrQ0LhhyuBkFlyT88kpd4JjQlahV3HtS8AEOor6L
	1lFFCS9eGpwBghYxsAWWQXv0rp610a8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wNnZLpM737A1LQh3vzOkr5Ug8cYkUYuQ4aBQwWDDyhI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793075551; v=1; x=1793680351;
 b=YgSp1vpeZSpbihhKZuDfRAd0siFBwwfzMHG4036HqsfxcmaXXMANdlZvaSFIPGbVdjFjLq0y
 YDQuWLLWDSENb5//B8qCJ8aYtml7A2zrmRoSbU4rwVUe9zjmSW4Hz8qHYes4YGXww+VN9qPrza/
 T8hVoojbMllFBBHZD7JiREDI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f40ffff1fc2cc39b;
	Tue, 27 Oct 2026 04:32:31 +0000
X-Mizu-Trace-ID: f40ffff1fc2cc39b
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Boris Burkov <boris@bur.io>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shivank Garg <shivankg@amd.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH mm-new] mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration
Date: Tue, 27 Oct 2026 12:32:14 +0800
Message-Id: <20261027043214.2248986-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B6B5A0005
X-Stat-Signature: 1wm3wyhksnr51mp17qfdc7zqjt3biids
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793075552-813763
X-HE-Meta: U2FsdGVkX18ccXRlOR9TxNrCwfeJRx3ioZ/c4alshA84noBGD7QpsZN+AqLp5pBg199Bj/BxmFyiOcrsNjLCzNoe9j4VXsH511DqI5XFUPsf2DWP6rF+3ud4IufkfeAmovNABjMbFf9+aMOaRC+k8Kq/vaaNJEevdE9xxgU+uMlLxhf/2CBKYU3m8VI9WetAKwkzqKLVDDqpkFIvcchkq9fcRqopj64snyzZLK/xl8E/kS69ng1sSae8SxtM2ZrHekHoB2DpHf8veIZ56fY7N5ZGconq1MV6VRo1lNcffPzW6OiXZIp9nFJAowlTsCsRPhc1Pi18JT3GxhLuKoKskOs82JG5F9x8HIY7tD4q0N+oc3b3MBAP6sPrqSpoKW/Hx1tkrm8cRrxCzf58tLDsr79ONL8PMWa17pdcATOCQaNp4qxs3Ky8xdH2vWY8E6tiKz2f1LCv5UFH0gWfa+yhJINGYwy0p7S4BtUn3j8DMsCdRfjoNkRCoboMVBgYyvkUDO0x/ROjnVXgkYw5VsDUXZxDy4bp1ggRjhP3gMtBncYs84v4QJD7QdfBfPKwVFVxIGWAdSDn6oVI5yE2yQBon3rHw1/uUoESpSqOLwwDjp8O3UyH6rsO+D9llVmsHDFnQ5K7GPfTBV/vewZXrE1tnNgE6IHA3tZqHpocU5xR5Rx66ayUE+XnNoqE6qkL2T29dqxRuvkJAgQMfbTbkDZ8TLG1qMtZfaLhgA3kUsY8B723fUopM/Gj8avwlSLlRWjN3N3TW9FvekDKS837KZA1GVbuycPjyHIQlS8UxWrLbjYedG3BRoHTyv7pol/Odo/3ydiF/+zns7BMz8SyqemACMwq75nwTPV7RyySLO9TTzgD+vgGM0x+smrCpJt5xXLg/pGGGgrLhs2jVVJxRAA+esYoXD/GYMVnne1603InLxRY8YXFroi7z8gnayUfwG73INIkswJX8ZwSPkJulTU
 hAt6vNi2
 Ll6xBeHnnU4e9NfDkzdo8b7CWUZqjLWjX9sTvpf6wtT9/Rx1ieeY7Rtp6mS0sSfhjwWKyasJqxzp4jNn/sQAIXS2sVabAD7E03SMChOZnG6NaCa8XNBiv/QscVpziNMoL5rDojk1Gt+F9PGISxrmglV5VAiZfkp89RnJMyekWtVSDHnPaVuL6u1QOjgYMNqXRQ+Y40SozL4j7j0Mk6c0CST+fdoD3zoNADsi1zztCQhym3uNjv+H1z8iubpKOX1Os92KSVFCxjssj2uZlqzfTCNU8nxY35i25SEojmQMW/KBZzKCdC57pf6XULoihnB9S+3Eq60ND7pOKt/31O2gK2uvLOo2qecgIfk8WCfdsM6dvWVRm9LZPovnaTLY4kXZz//t8jUA2fdwI6Ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

NR_KERNEL_FILE_PAGES counts page cache folios of mappings flagged
AS_KERNEL_FILE (currently the btrfs btree inode).  It is a per-node
counter: filemap_add_folio() adds to folio_pgdat() of the new folio and
filemap_unaccount_folio() subtracts from folio_pgdat() of the folio
being removed.

__folio_migrate_mapping() does not move it when such a folio is
migrated to another node, so the source node keeps the count forever
and the destination node underflows once the folio is freed.  btree
folios are migratable through btree_migrate_folio(), so demotion,
DAMON-based migration (DAMOS_MIGRATE_{HOT,COLD}) or memory offlining
all hit this.

Reproducer, on a QEMU guest with two memory tiers (node0 is DRAM with
all CPUs, node1 is a CPU-less slower node described via HMAT) and
/sys/kernel/mm/numa/demotion_enabled set:

  1. mount a btrfs and create 20000 empty files, so that btree folios
     are cached on node0;
  2. echo 2G > /sys/devices/system/node/node0/reclaim, which demotes
     them to node1;
  3. umount and drop caches.

nr_kernel_file_pages in /sys/devices/system/node/nodeN/vmstat after
each step:

                  without this patch     with this patch
                   node0     node1       node0     node1
  1. cached         1868         0        1868         0
  2. demoted        1868         0          36      1832
  3. dropped        1832         0 (*)       0         0

  (*) the counter has underflowed to -1832; negative values read as 0.

The global value in /proc/vmstat is 0 after step 3 in both cases.

Move it together with the other node-keyed page cache counters.  It is
a node-only counter, so use the node accessor, matching how it is
accounted elsewhere.  Interrupts are disabled here, as for the zone
counters below.

This was pointed out by Shivank while reviewing the NR_FILE_THPS fix
for the same function.

Fixes: e3a9ac4e866e ("mm: add vmstat for kernel_file pages")
Suggested-by: Shivank Garg <shivankg@amd.com>
Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/migrate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 99e3026e3126..f829c5017c96 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -705,6 +705,12 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(old_lruvec, NR_FILE_THPS, -nr);
 			mod_lruvec_state(new_lruvec, NR_FILE_THPS, nr);
 		}
+		if (test_bit(AS_KERNEL_FILE, &mapping->flags)) {
+			__mod_node_page_state(oldzone->zone_pgdat,
+					      NR_KERNEL_FILE_PAGES, -nr);
+			__mod_node_page_state(newzone->zone_pgdat,
+					      NR_KERNEL_FILE_PAGES, nr);
+		}
 #ifdef CONFIG_SWAP
 		if (folio_test_swapcache(folio)) {
 			mod_lruvec_state(old_lruvec, NR_SWAPCACHE, -nr);
-- 
2.34.1


