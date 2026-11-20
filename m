Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB26606B458
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dIM7EgcY
Received: by kanga.kvack.org (Postfix)
	id 7B4E26B05F5; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764B56B05F6; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6F06B05F8; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 238056B05F7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 546A41A0155
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:24 +0000 (UTC)
X-FDA: 85456289688.09.55DFAEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17F9740006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dIM7EgcY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198282;
	b=SQAwOY3pPao5nvbL2kDGz+3XnfeQjKUCakOuH6/C8N20zGZubknqbYgZRbTtTLbwEZmI9j
	oo63n+TU72J/qdYyoXaV7uSVWlIes1wc5b2zecpn/5pD8jwOuSZUJhn2p7WngRLPVg4zem
	TfmNggh7NQz/NjYcgHa7qxwYs2OGAqI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198282;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rthxdo4zZLRdMrG9hzCU++aKsWt/EVLHx0ntdyOkT/A=;
	b=XBCCpX9xMLKfla1xvOTindlpbTpv9hzBabQiiU1BEgRmFW+YBkEUMDXs3vf8PIeLYX+YuJ
	8CgDTpxAtRI/7mKyxoRUEZiI8ilPVM2/pc0xTBDsK5a4EWuel0MvYH3cFIjDZ4/dbdA2eD
	KBMR7NtYDnsrT3aVze6jzc87wRQn6J8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dIM7EgcY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6742141570;
	Fri, 20 Nov 2026 18:11:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198281;
	b=hkXL/hDvbaKnzBBpH8INsEnublg3SJPZugEsXCkNXhAjZHpKwkvelJYVZpAWhJ6MUA8I
	 Ocio82VVYX1QVweb2xVPe14J/lQ7vmNXHbV2hWO0w16BMfIMV5y7oSOQtsazvmVsQAJDj
	 bKBfB58jh6eSXNhgXFvRL5cXhgZDWbzLiuAyx796rjBluLdPvojGXqk6YZaGMUY/45wcK
	 pSBcWNWQCpNKzEtkqxTiu5oGTSAFH8oQsRq0LzATvXwkroDNnRU0XcUGSyZ4YaorMq/Tu
	 wVoJi8ge3BNI/OmjnxDl3AuBwujQZIbRGwpNTptz6Gi9HbcSGlFFVxKJgudT1DexcOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198281;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rthxdo4zZLRdMrG9hzCU++aKsWt/EVLHx0ntdyOkT/A=;
	b=NWRF9JlHvWuq58EisCNxzK9c1Jshx1YA1fWki6o/VUXj4wfckU2gaAH/B51+5LBfvQYh
	 hctdfBbop2PmkLp3uyUrniylLc5ejHm7er1xKkrajK87QehbKj9Ekz++bPuwqeQoP1Ud4
	 VmqMfI67N6AN/YmL0mT5u3p1aVYNjywYfgf8lu2z6Rr1hdVJiD+55AQ0Fnu8tsFIxc84w
	 EZsGHtWEB7Pi5eYa3zfwjluXOle7Cli/ffIE1aiXUKipxwAuKAOWctLGe79bTijVY6EVo
	 cPuYGV3KWfHcsXEjfa3M6c3zZs1pvTxeEwqlfDjkydtXyr/VpfK2CHrbfpvettc9KIw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DE5361F01564;
	Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198281;
	bh=rthxdo4zZLRdMrG9hzCU++aKsWt/EVLHx0ntdyOkT/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dIM7EgcYckLvHR9IusQ07q3XIR7rWeAcf1VirvJguvCG5KFeT4jmkznaLsu72OK9h
	 KSh0KW+Lfj1VGdAgjhAD93kJfcXLGL4bg3shpvXZg1Ws2MNsPGHmI8uuRiWHd3rnlP
	 2RZd48Ebh/iY+I447aN0o5pGlfQXWdmUig8y6NapRxEYW/TjPh2hv4XJ3Hyt8M5KxS
	 eLO7IN2vWKgHNsZWv6cZkxywg6XLn1DJP9qyGYEMhDAtzcEU0QtwkWzphYjx9vrL+F
	 u9JLfBHzalYZ0fqnAMHr06F3LKVW8yL5MXG74n07Kv4/SI/5tlxDGGedOZaoadRpAP
	 NNsmFOM7RBOHQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5C51E4B990;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:43 -0500
Subject: [PATCH 52/60] mm: count memory with userspace placement as general
 purpose
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-52-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198154; l=4692;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=6RX//QZ0SKZV5TxlzdYhe/tOzKC4XmRnHwcFufstJ18=;
 b=NCTptt6/uCAZdwhyVmM2rpriQlBmZN9AxKQqG79yZ5rxdXd8RGciTmhOiPZUUECoSDy16oEFb
 Kbu7zu/nGUdCEINR6uXZJsSM2Z1tPpxQx5CroIpLspzccWRfbqKkHRl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17F9740006
X-Stat-Signature: e33ye6uhr5wx1ibzrf6xn66zpjcxqbpt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198281-387888
X-HE-Meta: U2FsdGVkX1/iyX1+H5ibP7RFheUErkaFPj2IUR3wXeg0bikASeqe8R2bvfa7oeeIfN1y1Bp+u07HRsj2l0TNuNXEy4I6mjKnySxBu5H4PE4QVscIOzLvQb9aVcrhPtXZ1RWOQPflWv4sCDnOzjJZ3J9HowdzGOVN0rULBatW+ECToqlfA6ucmS/QFl9i7x5KQZFW/LcQIZWRdzM1vG8txGQkoAddHDbMTpsxHqy0T30REUZlSJq6O/6K2o0vr6x0MA56KXTDu+7gEKtzyi+tdCk1JR84iWW6QPRFhT7sbvGGm10ymh+tLDUw6yKuxttR1GcyKPPKjMMNwvGZlEOOiqkzQVBZHSkEA/Q6VGxYxd2OsdQHhvT7QMqwc6S3YHBOMytKiJDj9CF9ldoHWK07/6Hger67JwgU+Eu3YsB7W3Ujchw42ChdJXQns+WM5zKIfEByLQDBswPPbUtUE5QTbCFmFM0BdGEtN09+GKSNQPujIkEeLM7Rx87zBN4/ryBPKls8XL11OmG5uDU/RG4zhGbW0VCYgvRBoPNl498gaclGfl3+n8MiPv3pELmmqEHJ2ySex4oQ3jnXtLNkhynhO2VMSTH4x1mWOeAnQCOz5pJa53reQwqhJa3WoU0bLtS1KEtBBw3rZXjrNb20eq9SOcfngXJc2qqcjR99/HfyEmxwk+NWAmDJ8H3NURARrY+fqLF4texdqLfe90s2FBHZcjcd7UfcblU9jmf48bBhxu1HH61oAMwwDdRTY92lvr1r+zygfvtluHECXxY3KaxJFCW+6ms3oK+YbBCtEMUjsuCyhr2tXdB7/IGBLWx8ckxY+cE9PevKjD8/33yy84Rs1JzhtyRL5Hml/j/OKRoaaLG9nkEzi+ZIHaz3hekffqaXsmkxQT1AcPETHQmheguP5dDEHMVEeRcVx8hOFWOkq1pYokkPWa10jxlybDdr36tvf/bhH0WySwadKaJa0iY
 aHOIANkI
 zOBB9wQ/Pd/XW/KwGvDiM7gekcZWhbUXqmZKOINYt5qkEzC0lWxRQheVlYZBwirEzK2qaHiI4LYR/ibMuoCcJAFC/NT6+MN18U3wZkrKayX1sCO3fI8mUV+dHN4GcnjPLBh4u1sFayknros6o8G12JXsROfmumTXVKNLjAVDK9cZcFWhyGFb7QHUoHpdMslvznDmgpCh03kz9K+Mphl+wmIfl0GZdIi5L34MwfhXGeCvLeuHSiYyHYJtR2r8tkcQZri3AchpvAMQs5GjrcEFk/Q1ws55YhEe1u3vsSipbTU2ShFNQKQmt82ko0JAsWvgMu0xgP+dX8TwwHC3csWaWaNq0xRoJmeuEIyvZ0Y8blT+5Y6aceFSk7lwz+F2W+xJ+nIELJhBTWcAQEpH1RP3BDRbW0Td8zNZiOn1DtkzrTpuXZVD00KRVoLmKIodkUiYz3U542xHzfEX8nHSFzNDVjPw0EnCP+M0pOPZGZPbCQzz4stkP97cdzbSvz4n8VpE+eUsqlGe6HyeH1NySizUm5z4WrvZiB8BO2aoMcLm0ZzZGtVJLe0OQFxVHJodeEh5gWzHpznS8lsDVyGwtDkOC4kzq5Ttl0EhjjXBAuSM7JSWJEa2fsXZMRMpB8gqp8haTVf9mFkbjXsRTnT46IokOGrfsERnHNyTlsALjcBMJtLu0DDdKrAdFH7JfJm941vGvatyZVep0MqJthFFpd9BadVRT8hGm9nLhKHWQgkHvxD+4BtqJz8vtEXDFru8xVawq24odLygARhFQ3W8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Userspace places ordinary data on N_MEMORY_MEMPOLICY nodes, and neither
the commit charge nor a task's RSS can tell nodes apart. Treat their
memory as general purpose: totalram_pages() and MemFree count it, and so
do the limits sized from them (overcommit, OOM capacity).

Other defaults sized from totalram_pages(), such as the zswap pool and
tmpfs sizes, also see the larger total, as they already do for memory
the kernel cannot allocate from in ZONE_MOVABLE.

Free memory on these nodes serves only private bindings and migration,
so counting it in MemAvailable or the global dirtyable memory would
overstate both. Add common_free_pages() and use it there.

MemAvailable also assumes about half of the file LRU can be reclaimed.
Reclaiming file pages on these nodes frees only private memory, so
count only the file LRU on common nodes, via common_file_pages().

File pages that reach a private node through migration stay covered
by the dirty limits' file LRU term.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h       | 26 ++++++++++++++++++++++++--
 mm/page-writeback.c |  7 ++++++-
 mm/show_mem.c       | 24 ++++++++++++++++++++----
 3 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 4bac570bb29f..c83c100a5253 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -793,11 +793,33 @@ void set_recommended_min_free_kbytes(void);
 
 extern char * const zone_names[MAX_NR_ZONES];
 
-/* true if the node is capable of servicing general system allocations */
+/*
+ * true if the node is capable of servicing general system allocations or
+ * userspace directed allocations (mempolicy, migration)
+ */
 static inline bool node_memory_is_general_purpose(int nid)
 {
 	return READ_ONCE(NODE_DATA(nid)->memory_features) &
-	       NODE_MEMORY_FEAT_COMMON;
+	       NODE_MEMORY_FEAT_MEMPOLICY;
+}
+
+unsigned long common_free_pages(void);
+
+/* File LRU pages on common nodes, whose reclaim frees common memory. */
+static inline unsigned long common_file_pages(void)
+{
+	unsigned long nr = global_node_page_state(NR_ACTIVE_FILE) +
+			   global_node_page_state(NR_INACTIVE_FILE);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		return nr;
+
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		nr -= min(nr, node_page_state(NODE_DATA(nid), NR_ACTIVE_FILE) +
+			      node_page_state(NODE_DATA(nid), NR_INACTIVE_FILE));
+	}
+	return nr;
 }
 
 extern int min_free_kbytes;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 00293a64fcea..6181266bf159 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -317,7 +317,12 @@ static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
-	x = nr_free_pages();
+	/*
+	 * Free private memory serves only private bindings and migration.
+	 * File pages that reach private memory are counted with the file
+	 * LRU below.
+	 */
+	x = common_free_pages();
 	/*
 	 * Pages reserved for the kernel should not be considered
 	 * dirtyable, to prevent a situation where reclaim has to
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 24dd33ba783b..de4769e06a53 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -46,17 +46,18 @@ long si_mem_available(void)
 
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
-	 * without causing swapping or OOM.
+	 * without causing swapping or OOM. Only free common memory serves
+	 * ordinary allocations.
 	 */
-	available = nr_free_pages() - totalreserve_pages;
+	available = common_free_pages() - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
 	 * start swapping or thrashing. Assume at least half of the page
 	 * cache, or the low watermark worth of cache, needs to stay.
 	 */
-	pagecache = global_node_page_state(NR_ACTIVE_FILE) +
-		global_node_page_state(NR_INACTIVE_FILE);
+	/* Reclaiming file pages on private nodes frees only private memory. */
+	pagecache = common_file_pages();
 	pagecache -= min(pagecache / 2, wmark_low);
 	available += pagecache;
 
@@ -92,6 +93,21 @@ unsigned long nr_free_pages(void)
 	return nr;
 }
 
+/* Free pages on common nodes, the free memory ordinary allocations can use. */
+unsigned long common_free_pages(void)
+{
+	unsigned long nr = global_zone_page_state(NR_FREE_PAGES);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		return nr;
+
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		nr -= min(nr, sum_zone_node_page_state(nid, NR_FREE_PAGES));
+	}
+	return nr;
+}
+
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages();

-- 
2.56.1



