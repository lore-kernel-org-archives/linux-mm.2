Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3731606C95B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dtE9zkhe
Received: by kanga.kvack.org (Postfix)
	id 67A946B05E0; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603BE6B05E3; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47E856B05E4; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC056B05E0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A453B1A0153
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:49 +0000 (UTC)
X-FDA: 85456288218.19.BB68142
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A46F1C0009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtE9zkhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198247;
	b=cXypdX67KG7XV2IwteliUsG0ww0qvzdvkbhHP8HBkQVbcaMQeAVPvrStWHPQKQdAGEJD/1
	PbjTAaCUJppnnEvG0PFZal+6T5tfDrrTKGyt7kchM79g1jAwZEh1dD9A8qhqsPuXqc3F7J
	B0dVNvBP0T5Yac4SBaOonzFZApAK/4g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198247;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	b=Knf29NiDLngZPh6YQ9b4r4cGezVn2U3n3bWHYiH5ab6hdCi5u3sXjzCQc8Jozb8L7tB2Be
	WmzfNybsRQzxyVV/3F1kanJuIYiqqFi/bOXn4qIIuh61LPNSf8p+w+E5VXOHUrCwC9H2JF
	gnYPbTtnVsuMcpaXCK32jIeEYnheIMQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtE9zkhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E2A846C80;
	Fri, 20 Nov 2026 18:10:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198246;
	b=cpcBQPGPR81w89GHeV/KEw53qyfbCV5FFKBEgaANlG+UQTJBymOKNQD+MVZ3oEMrcJKR
	 O0hWfE4/UHpSkonLWspCO0WMX2EAsq1K0FMpP1qQUcxHO5sTZx3sZT6sLzvcOLMzjsUaX
	 wnShijSduk6F/GZf35fWyG7J3bg21GtsbQeDH5CGQ3gUQI0Xd+qDMjAUCyr7vADzNLMDw
	 0fB2HnUnuj2kko7EMIEjul1fg06BW7DF3rpzoTAOlf0w5jr5814A9xJurJzj0WNroyXVP
	 5hd/X/U1AlXJ7jw1KJKE2tRlPPNCHEaQcSOUHaTErRkiLDTlGD1Mmf1UxvFe3RT6SxA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198246;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	b=2X6jNyS7T/anlFj8o89ChzCv6Z7uMSqxPMxNc4wZ27XsfcynA9LEchiEH9qnrcGsQ0K1
	 Vpv1Fn5kCZJ7RztimOwsZwHRufAml/7aJlfJo38X+5Z1l6YhTSxiq+fdRI+b8w00i0df+
	 ArxUXl4Njh4V7FNSWorc1o2VUp7CxZH30C36S0WDK7JK/9nLTXmEKB2leW0EMf05ta5f5
	 LYcO0VtoA/UcdLdutIatE0KsyYHmJal7H7mHkhfU7YXBXtOBeiu71oAv3Air/euDCaio6
	 iU/GzuQLhAdEj7NslF3SazDBzTVotT06XsK0JmkHRTyFZ5XKGUg37aumrw/0n6mD42w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 66C811F0180D;
	Fri, 20 Nov 2026 18:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198246;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dtE9zkheGAzgkhkpBI82k20rQwrqqzvpK44pfR9aoM2F/W3ZZB+z3Gril9T5+HqVp
	 t4Er+YoxdyQw++oa7nSZu78jzbQZRjH+22Rph+iGpSQY4Ij+79F8v49tCuWGHUt12v
	 N4HapL1afOYAIYI79+bA2gZBSqpeX4KIK9YACNM+UWGICIXxSC1LHXYZBzfimGhaCR
	 vbnBuqY4nVZs/75aNd1/kHFVgNQg8Jpj5NoyziZtwPIM4JBqbY5KqOxCwAWaAVsgI7
	 AIHK5JgNKRg/gQ/oNuywpODbMJQ2H9UE+eHgOWsjy6+D+5dOgcysL46BlkPkO6c1lY
	 mbHaXqv4I6oeA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B84654B95D;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:30 -0500
Subject: [PATCH 39/60] mm/page_alloc: add a private-node zonelist
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-39-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3134;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=OqpMdBUt5im1cMgZFE5X+fZAbGJWYU6WcOHKkFwuS9o=;
 b=o/dYXsRSD+kDIMnUJjWNiDdysIiPZ9AEs4oJxtAad9XJMPtLlNyz+nTDlkBw/SrIIzFQ8NEmg
 Q5LoNu0vSTqCQh8ZHl/nPuFBHXZVGMqF4GQxX08YQa6pADhhTLCJq4v
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7A46F1C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3otwd9pqtyzdcphsz38335ojg87jiw37
X-HE-Tag: 1795198247-105371
X-HE-Meta: U2FsdGVkX18nPwGkt4ywq4NXoni72q+zigWabFs9ReLRLHTraHr9BVvzZ5+E3vuMrT45UuIBzQVDPLkn5ju5y8GXypGHolPuK6LF1b84RV+zns82YseIHU05IeDYI0sXvNCwy6QneVAAQc0fWLSWlmktuXW2EwwJMz5kg+CvQTyqvnPgjIGMU3B+7BeEH8hd8u0A+FpWtXPNzOsm4VsjUAwZ7pl4oK9eHdgYKaLVPG31nMd+eC31DI9qkAeOZrDVESvfu6D5iBoxak2FwAWMbFWCmgDhRp1u7Sj9UFAlmIAPksXZeARrsGc5jFSUkSTuHjIsMjH+3tRcihxqUeY0WfCqk6f0aI02v/iC0hhw+Tm28KR3Ldad6Mw4p1vNXYYUvHbb738XPQsbd1u+n6ded21QAkQBkKPRT+/VcuijmKmSELnwwS6ceyF6Vhu7ZfmaKzLwvMsDZMh225egPqhQWEsefhUblz/Dfb2kbJaarQG9a9qdKvPNk2Pt5M4mENv6tl2/AqxdMgFQIkuu98N4Iq8RTYZepnoOcp38VOt8ViNVycSvNcOwLs2qF0NZ6eA9XqLRydFiyQnAN82hsm3d+BQ9XlSR8N7g1PDpH5NBt24QRxcl6sDgwMEhQ33NNmlcytb3ZZKZqZ/naHPRQjA6qctQLdXrwysSkmEHeTggK66EsUJin5/nEEJwDO4EBbIh6iFKi04iEPi9cT2UxToO1uE5Lfbp3JzoYHOq3RE3F2CFAkWwNIYhaYAgYW7VFNDz829veAIXzIuZnkL9BFwA4tAMglXlYCO5eJyBhclPvIaoBpXmaVZF4NTGKviskgaFvI3m+Kx35zvUEYXk+bOfXqE3w9fZOYfcUO9bdP+4xop5gLBU5KCg2yYCQF0hMc7ttY16N/Ez53NIN/1TuVqTlnUKx59qc5jQwM8j0l8GgvqrP9J2NIncaKIj7zUoSzg/v7/envXNvlEGE/bwpza
 dYEKzq93
 J21xTPR2nys0MRNFplfWfaPedTdJGqB76LlFp0Y7MzlErg43jEqEXdfK4zIr4EKCNf2V7acDTCO+yx37JFGWH6uYBLHEJ+3GtFsBxB0wOphJuZCsb1jmXdDetX0lzb1h0t3onJaGVpgxc65TamkYWeFDQ2hv9UIvhkQ0MIA+WvtxMxj0yj5cWaSRzxLKToBaoSlew0h0PwS58q47z02s86OTa9k477O9FoPb1fFtMqa0+k8BGAAD7oGtXQUiW/wMHJbG/CJ9SJaTeKSVT3ShQnTZO2SvvKoaWkSAyNTfVOy52w1PdayDzd9loqFw1HjHagSFXZ+s+BTDrbWkF+4WYUkIgQ7m+AyzBbMggvBCEqds4xq+BbFfiV8cBQJcP3Bw87BNx70wyHRvVz4kdFuBYZE3wTD26LYE0maRv0ttsKUQF1xtAWkqwk2l2dEwwt374qo6U13XyPCzNWujxiXKv2QcdthDLobv70vvHFzFd67Lb7LbzPbzFaOss3ZtEtOXSCIsEWTXYZ+kj726MfYMTyC08R3mvE4EZNU/DdWG8tIYUkp2ZnRgVTEDaFK+wE8mXOkR2QYlIA8wLQTBFtl6rQesjZb6+HRGDmaNsCcYSEw7jahKsC+KEQEQwcKtRtJg2Yo2VUV/xRQ6JJ38G7Ue10e4TDMICoGTdnm36DvJYJ7NyqEkzQZDkRlov3WwCbY7OWLQEjDk6yMd2ujVtT64T2yoSIgqjbFqt9BezOWMmrx+7rlel4JLQEK/sjm0RnTOyQq1T6lELLHoK/F7ivQ6M2b8n+YJUIoHBRkUAy67VSLT/TA6Fb2Lk6+HValArGLLJiLmm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

A private node carries N_MEMORY without N_MEMORY_COMMON, so the FALLBACK
and NOFALLBACK zonelists already exclude it. That leaves no zonelist
that can reach it.

Add ZONELIST_PRIVATE, which holds a node's local zones only if the node
is private. Common nodes have an empty private zonelist.

Like the existing zonelists, it is sized for every zone of every node.
That adds a zoneref (16 bytes on 64-bit) per possible zone, MAX_NUMNODES
* MAX_NR_ZONES, to each pgdat. A smaller local-only zonelist type can be
a follow-up if this matters.

When the zonelist becomes selectable, __GFP_THISNODE will still suppress
OOM, while the page allocator selects the private zonelist instead of
NOFALLBACK.

If a user grows requiring fallback behavior to COMMON nodes when the
private node is out of memory, we can consider adding a fallback
variant - but for now private node allocations use a local-only
zonelist to limit complexity.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h | 5 +++--
 mm/mm_init.c           | 5 +++--
 mm/page_alloc.c        | 2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d6c1a43c0bc8..05f212b56c9d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1402,10 +1402,11 @@ enum {
 	ZONELIST_FALLBACK,	/* zonelist with fallback */
 #ifdef CONFIG_NUMA
 	/*
-	 * The NUMA zonelists are doubled because we need zonelists that
-	 * restrict the allocations to a single node for __GFP_THISNODE.
+	 * NUMA nodes also have local-only zonelists that restrict allocations
+	 * to a single node, for __GFP_THISNODE and for private-node access.
 	 */
 	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
+	ZONELIST_PRIVATE,	/* local private-node access, no fallback */
 #endif
 	MAX_ZONELISTS
 };
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 99a45fd04ac5..a6ff49043b5c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -99,7 +99,8 @@ void __init mminit_verify_zonelist(void)
 
 			/* Print information about the zonelist */
 			printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
-				listid > 0 ? "thisnode" : "general", nid,
+				listid == 0 ? "general" :
+				listid == 1 ? "thisnode" : "private", nid,
 				zone->name);
 
 			/* Iterate the zonelist */
@@ -2706,7 +2707,7 @@ void __init mm_core_init(void)
 	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
-	BUILD_BUG_ON(MAX_ZONELISTS > 2);
+	BUILD_BUG_ON(MAX_ZONELISTS > 3);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 08e57f809a03..0bd21916cea1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6010,6 +6010,8 @@ static void build_zonelists(pg_data_t *pgdat)
 			    ZONELIST_FALLBACK);
 	build_local_zonelist(pgdat, ZONELIST_NOFALLBACK,
 			     node_state(nid, N_MEMORY_COMMON));
+	build_local_zonelist(pgdat, ZONELIST_PRIVATE,
+			     node_state(nid, N_MEMORY_PRIVATE));
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES

-- 
2.56.1



