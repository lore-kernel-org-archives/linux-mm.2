Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F9E5606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UB/ACdDr
Received: by kanga.kvack.org (Postfix)
	id 4F9E86B05CC; Sat, 14 Nov 2026 02:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482836B05CD; Sat, 14 Nov 2026 02:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C366B05CE; Sat, 14 Nov 2026 02:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3996B05CC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89276801E5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:45 +0000 (UTC)
X-FDA: 85432852050.10.B410358
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2B181C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="UB/ACdDr";
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgwyyRUkaLESkoMsTNOOlPxwzMonfztNgfKNstfbYo8=;
	b=eh0gWLkERjX8WNfejjDJP/R7DHT1vpdoz0T5bAj16XuhF6tua5lM40kIVqZfSVR6KjTHev
	eZEJ4+84zIaWynqK5lhjn9jCS1TRF9qL0QRecQFxNbzIsQuiSwNB35ajGcsXNkWohxlVsZ
	uHRMD9hTrhTytN3QH6Xjnn2DnfuZ3Qo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640243;
	b=yAOiK56h4MDgkOAJRgh0vzdEz0YLSr2hjHTyIhSDievCLUKL0Le+ypcXNyOBHLSu48E6eQ
	Evqo3iw9Tma16Pzl40pQmDMx5wHPbgNWBTS2J9Y9AxulaJWJrEj+U7OvdXcKwkCXi/mqcC
	K3OVnRPc9t0uHo/xRSg8Rat0yyuFvFk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="UB/ACdDr";
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91ec2d42231so30643636d6.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640243; x=1795245043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QgwyyRUkaLESkoMsTNOOlPxwzMonfztNgfKNstfbYo8=;
        b=UB/ACdDrhkNfGJaVr1Bhsy+icJcQiJIcZaAcBgsImzXb/isSgrX+r7rJB+6UnJQZXR
         Om37NzZFaV/+jhchDF24WKhBkaPBYBUuIPiMkooop91AdEzTyCyHrQbhjI9j8Iq9IKKz
         xfS4xdXKlRrkruSDvP32g76QMLr8pTXXpQiyiraCpU1J4eDWjS5SRHT9Qgl1Apgnc1Fx
         xVJMa5r3h4gayL3UFl8/CQwAKNb0j5mTZpaAwMSXSveanAkwy8pY9Ed5jyYsowqKaC7z
         0uKaEzbCJkgfzGoeZ8lJT3jbNVkt9Y732LQik6reVbt1nbTN8vqPhDiJVFrNjdUEsags
         Piug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640243; x=1795245043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QgwyyRUkaLESkoMsTNOOlPxwzMonfztNgfKNstfbYo8=;
        b=Naf2bPw7tKovUsBLbYzLRAtcLINr6I1LW6gTJhfXbVQGNMdGf/sXVX+oX/+nYxYyMh
         uxqDBZMH9UHR843bv/cLGuu0n4CvFxuoLzDhv0HCEnHT/14y3YFe8lLDtEJNXVHvL2at
         GUfMabT3G/eGShoTv/8xvC/AXfJ/ZIUY5FQOeKNTM73jqokBOPyzGQ6AUrgA8SQXaOa/
         9MdygYtVtORaSz95Tz3GOKxaElE9W18ytp1HpuBK1AMPcC2I14KMcv4FsfHl50kUO3yZ
         bPXgAjyZ22achVbuVyxIKzFt6PNzOUacUOE2vGMfEVtJbwXL1wxt+dLj4UbzT+wHorny
         sKbw==
X-Gm-Message-State: APuU4Z8W9bqn/77PNYhFFs47NdbA73YQpITPEiyslrB1dBnLjVeZ3xMf
	cizUCDyyXCr2tST6/ltc/5Ghu9zZfNkqazq7BHVoNqynaSfaCNmFhzL6JxA/+5dpDpMpneKVFVt
	GYqBk
X-Gm-Gg: AYBFou39dMGhfpvnPYzsl39pa45RSjjOC3jUMtUjPGLKmjXqSWOIqLI5dsKACuL68mx
	zW1GI7ayd6IONQw0U0mrIxvOxoVYjbJEFCNp6BJBFPU6zS7E0mhLzlZx96RVSiroLMRS2VmrwSY
	BeiqM+1BdrXJaecVjBOhRT4qYFoFgC3DCovCG+hWXuXnKMUVYD+98cggEVyas+DigGYtJS6muB7
	0M/OQ+hhGzLuqQUxN8a86b1/WR0CHzMG+mEWwkxq4kyLXJn4V2301EAhKQjK6G7hSopeoCbpPQc
	wUZ6SCb3obXV/nEmRPOx166MmwOzXgBYYNsDPuzmVDfEJIcvGPf+mLlGsJD5kRydWGeZ0YtwNvD
	UJpucJbbC5/k+kVK1IVi3cT6clukaP07vNWKjnt4icdCnYmGRksQRhrmOiAh5l9s4buNr6NSdhB
	5IzpVWQZj83yTS0kzFWDkvpCCgxSxcW7anP3NkKXcRqUMt80oyHF0BGPyVRMh67tUiNdo++xaAv
	x52LcK6mtdWdTV0F64+ZRATFt7Idy9iv9PWIJxmLXXbXPNS875DTaF+eRv4Z45CCG/yzT0Zinnz
	7ZMDXxksXCX7JSQl/DjDJRk9bDjEadEk1lqD1cjOFPujcc4eXQZKaifkZzFKOYvyh3Gugy0gWnD
	0Kr0CVGordfxdVJw=
X-Received: by 2002:a05:6214:8503:20b0:91f:1498:4e2b with SMTP id 6a1803df08f44-91f24194a18mr55953066d6.9.1794640242842;
        Fri, 13 Nov 2026 23:10:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:42 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 18/22] mm/compaction: restrict compaction to common memory
Date: Sat, 14 Nov 2026 02:09:55 -0500
Message-ID: <20261114070959.3490008-19-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: seet8ewgu5synbmddfc3t1rh7rmetcpi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2B181C0004
X-Rspam-User: 
X-HE-Tag: 1794640243-751761
X-HE-Meta: U2FsdGVkX1+P1MAYOJ8fYC9CUyVXsXOigsWuAAfPnaR5+kEgsQHxVfDe2XTP5enm5GAcj841ZME96MDtiALpAsJYO2RBcWM2W/EIADFVB8YLjd/DDKr+rHdkMommEh8hZqQGNS25H/bOPO1qWL+PWLLsGbdfsOlcu1oUHSLGCsAtJVLr8iF/gQm1puvE3jvdCTLm2/MbyQdIl09eIKmG6/jyO6JZchOTs7YxhJatSpFWBsKuuh6D2ixTQ2vyrGr9eIQtYAo1+1uidMaQcazwTVi+D1MpTOEgYn0hfF5sI6T2YGREqJBS8WjdhYsDHm0Hm/3OJvzsQpOonBT1ewYci8/uTKY2GDuepHle92ymkf2bqFP/LMP83aTj/oQiQb87l5AKZ630Y6xJRq/mK3LxV/Phds1MU9nZxZlTX5tKOvMarSDIslT1loacbEMMvlk1Fh2gOFlJcGC7JqKa2mw4FNUsY82+YkQmRbZuA/ZWTsSNNd71znW/QWNgD7ARE+79AtoUEmoXgQc2rGZKPoP92TsiZA4G9AOqU8VNOBAocddiy5u/ih/iQBjoDf2+rxM8qqBKUoh3HblWzNor/r0GDPr55Od89B3Tvf/BblzxmpkI89Qm1srpg6rfab3JHymIigtTtQvETHrTt16dPLj4Ujbv3KrRyw0MYRCFMuSfk8MdilZ+lXflZVSUMNVaeX6MBYaDjtqjzJNMwL9t6aPaJAUGizciwbHK88FNutwPi3Z6voO3G3sf8lLLlRJK83Y0Y6cMacjW1eaUPRcW3gXQI3MuhwL0lZLmboqpE2d7y77bP7qR70yT74JRzaKAp3raxqaPR+6Bvu1ts5YUNvxa8xc4TZ/KNCvo2+gtNBs7HCIMvgGYZbCU9/Df9mP+c5lmnd6KIQORM6mGtQ4xNgzMmHmqfHzP55A44xVKv+okL/hdsT2DP3YNa4vr3lb73EFb9qZ4fDsX/m34Ya1DRmy
 iUALq1yz
 DJ5Owv6/yVL+oceS9aoYSdrdY6m8WLY2N5spzhSiToNAA0fdx2hBaY8oPCMAh/2KnQhga+UQGkAd+a6v6LSjN4bBi6B75RaHKovpzMc/Ja5gba2qMJiwammBDqvqf1PGacpfkkxd7u8vYRhgjAJBVq+nXr7BcfGjOljhxZN7/V3an96bJadjqJ8Gc3AhclyIu9Dtg4QLuq9irUfcMhTTwNJe0dSMt+J+S1x4PNyx+mvWOhEQxZVgT1L0ESPo5kdfKrqvaxYjL6Ax4UoHNTTQswpXga1vAAm+dnLjvTaFERXggxeJGkgh1Nq7YGX7fcUyz/9Pz0fDfDtN5LpCpt68Z0/fhUfuv0DYXI34RVQ5kHHP9iL3VTpArTEkuuGuaECzau9pN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Compaction serves the ordinary allocation domain.

Restrict it to N_MEMORY_COMMON:
  - start kcompactd only on common nodes, at boot and hotplug.
  - walk only common zones in direct compaction and when deciding
    whether more reclaim could let compaction succeed.
  - compact only common nodes for /proc/sys/vm/compact_memory,
    and trigger proactive compaction only on common nodes.

The fallback zonelists hold only common memory, and all memory is common
at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/compaction.c     | 14 +++++++-------
 mm/memory_hotplug.c |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 426563acf7acf..6a40e1a9ba78c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2496,8 +2496,8 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 	 * Make sure at least one zone would pass __compaction_suitable if we continue
 	 * retrying the reclaim.
 	 */
-	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
-				ac->highest_zoneidx, ac->nodemask) {
+	for_each_zone_node_state(zone, z, ac->zonelist, ac->highest_zoneidx,
+				 ac->nodemask, N_MEMORY_COMMON) {
 		unsigned long available;
 
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
@@ -2855,8 +2855,8 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 	trace_mm_compaction_try_to_compact_pages(order, gfp_mask, prio);
 
 	/* Compact each zone in the list */
-	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
-					ac->highest_zoneidx, ac->nodemask) {
+	for_each_zone_node_state(zone, z, ac->zonelist, ac->highest_zoneidx,
+				 ac->nodemask, N_MEMORY_COMMON) {
 		enum compact_result status;
 
 		if (cpusets_enabled() &&
@@ -2973,7 +2973,7 @@ static int compact_nodes(void)
 	/* Flush pending updates to the LRU lists */
 	lru_add_drain_all();
 
-	for_each_online_node(nid) {
+	for_each_node_state(nid, N_MEMORY_COMMON) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
 			return ret;
@@ -2992,7 +2992,7 @@ static int compaction_proactiveness_sysctl_handler(const struct ctl_table *table
 		return rc;
 
 	if (write && sysctl_compaction_proactiveness) {
-		for_each_online_node(nid) {
+		for_each_node_state(nid, N_MEMORY_COMMON) {
 			pg_data_t *pgdat = NODE_DATA(nid);
 
 			if (pgdat->proactive_compact_trigger)
@@ -3366,7 +3366,7 @@ static int __init kcompactd_init(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_MEMORY)
+	for_each_node_state(nid, N_MEMORY_COMMON)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
 	return 0;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 410a29732bae7..c8ff60e6417ba 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1209,7 +1209,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_state(nid, N_MEMORY_COMMON))
 		kswapd_run(nid);
-	kcompactd_run(nid);
+	if (node_state(nid, N_MEMORY_COMMON))
+		kcompactd_run(nid);
 
 	if (node_arg.nid >= 0)
 		/* First memory added successfully. Notify consumers. */
-- 
2.53.1-Meta


