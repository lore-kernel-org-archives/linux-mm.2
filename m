Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4EF10ED66E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A446B0092; Fri, 27 Mar 2026 08:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB1B6B0096; Fri, 27 Mar 2026 08:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18506B0098; Fri, 27 Mar 2026 08:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B05026B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:44:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 521541A1069
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:44:47 +0000 (UTC)
X-FDA: 84591812214.14.7356972
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70F1516000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:44:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kclo86X3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774615485; a=rsa-sha256;
	cv=none;
	b=yCWTKWpU8nvD3zv4FhNA84Vk4TZqH2doYSvd4NfV8LLWtVzOlt+6vqqjPMTfNi9ueJD5lP
	DNZi55lgxrW5hSAtjUSPB5RcXOqS2l15LdxACjZc73YQy967qfqSRbYUMgTodw3yXIeXJT
	cvgfMBvM5BlhlxLGWnG9/yyJD2nxyMc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kclo86X3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774615485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KbK7ntUxSzrFQGj/27aTab0fONy8ZoPaESF8ksut9hU=;
	b=6M2v3AF8RD6FlkG+vvzc4fabjXULdNmf57HrSU0fS41Yy+yIYILu7Lf0c3/gDpWFPS9Qko
	ebojs5QRGG2Q4EZ92FyiQo1fZmVI5DI3A4JpQJmD+gLOLmsyjtVRBL+iZ6dmWI5ChBnbKr
	BeEqmktybX16AOIHZ5GQb3R9CrJ9mmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774615483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KbK7ntUxSzrFQGj/27aTab0fONy8ZoPaESF8ksut9hU=;
	b=Kclo86X3wPXq0hyPYxYklKXZMxUuwSaF1OL1vIZqmGsI5pKDM4aLkX0oUC0noIhMgE/kwR
	gMs9v4lQILgCEDUxRMnWZghAtynZPpEVyiEEHT05DSihJOipWiJn6alDMisXQcl+142F4s
	pCwNA8SKVWSvut/OywWAEYdqU4FtlR4=
From: Hao Li <hao.li@linux.dev>
To: david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Fri, 27 Mar 2026 20:42:47 +0800
Message-ID: <20260327124412.469833-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 70F1516000A
X-Stat-Signature: etn315swtb6hjjpxfcg1699n69sikd1i
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774615485-723512
X-HE-Meta: U2FsdGVkX19D9Le/bpX3wbdEpDeki1n/pAiruDzF4ihjgI5aNe5Ensiiao6XRsoKoovOtnMAMSql//8neIK1OVMb1ibavepBZsWHwkWYzs8ebKiGA/GD5Od2LGxPRY54+t49oJo49XWlG4q0b6DL/5fQef8ujg07sq1X0d3qKuRbL66vGjKKuIKIgyqFlDaqV/b65oX3o5ufFrcXLmj2f3sTB4UY1KNVvmNqYlpNnG1PRIFA5tMmguf5nXUj/QpHYK04BuT2eTe4UfaLf3AsWjYf5HrZYhySCPLePS4L5Hadd1OrrGcrT0HA28nPr38sILrrVde+yLbrxExPfk8BmCNx3DCLMhwEeBdLSOoTwfmCBZyLL0ySlQRZg6cvxqBiZwyFkbgBcGMQkxChUrie3fdbIMEYFXvDSTN2yHeRPHpK+ksNuID8xwy3H1chtWotUmCUy6PG4OkaepyU469lL/pwFDfkY7J4bo1l8hS7UGXsltUeL9t19wU5LTtlCF/jIG55uGkQM1N2aH77OEqucCxikXVrUsJMfw2yicW8C+ZIHBJjP4xppK1mA6KdykwrUzUAqQ7sEDnc5g4CdvCmAEt5UzwCX0stqXULfmfRl91cRCkVYYV2fUCfNFI7A/1wy3S7+Upm+8A62hBr++APwFmmQmjEGL6OXviamB6l4zJ5cy/3Soz8El2B7i1ofMAfiPjFzzYLKm34Fknz4qNJkiOqzZeSjJiJqioWytL7bgekaZkLqcyBVWJHRpU8DcrS2do6ZNdzSXs+5+4ZRv/U9NK3Q7h3txXi8DroR6fJXLlCk8wUZJ6g+idj/QhDPfaEY1Bt0drHrYludHLqI7dKwGjpIK+jJyqTu4FGy0FcYpnuuoy8qeFh8wc+HG6zv9m0rGiJm4MP0oLcyeKRDGpiGg7NJuH5mN0G6j4zenHm60FMoUCaZeVt0d06mjf7i4sMQ6My5U5YO+4TssREBEa
 JS+61KOQ
 82GLFx2LoY8zfZk1h7ca66Ieu5Y0+zve0c7kz/FhBM9ZIt0+Y9T+cFHeMO7CxZvUHh4SVD7Ng+hTauD8Ue5f0VhGT4MGdwnN4JaqxkW/sO+Ak+s7gKu2WicfErbkrPR6ZqzjXtkfn02hzPJtyzMNmpVnmCZl7IObv2+9MgXGN/8DxiXPXeIzS2Jvh2USaVvQIRQzsdSBElPP5dqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_NORMAL_MEMORY is initialized from zone population at boot, but memory
hotplug currently only updates N_MEMORY. As a result, a node that gains
normal memory via hotplug can remain invisible to users iterating over
N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
incorrectly marked as such.

Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
offline_pages(). Set the bit when a node that currently lacks normal
memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
offlining removes the last present pages from zones <= ZONE_NORMAL.

This restores the intended semantics without bringing back the old
status_change_nid_normal notifier plumbing which was removed in
8d2882a8edb8.

Current users that benefit include list_lru, zswap, nfsd filecache,
hugetlb_cgroup, and has_normal_memory sysfs reporting.

Signed-off-by: Hao Li <hao.li@linux.dev>
---

This patch also prepares for a subsequent SLUB change that makes
can_free_to_pcs() rely on N_NORMAL_MEMORY to decide whether an object can be
freed to the sheaf.

---
 mm/memory_hotplug.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..5498744aa1f1 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1155,6 +1155,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	int need_zonelists_rebuild = 0;
 	unsigned long flags;
 	int ret;
+	bool need_set_normal_memory = false;
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
@@ -1180,6 +1181,9 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 		if (ret)
 			goto failed_addition;
 	}
+	/* Adding normal memory to the node for the first time */
+	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
+		need_set_normal_memory = true;
 
 	ret = memory_notify(MEM_GOING_ONLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
@@ -1209,6 +1213,8 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_arg.nid >= 0)
 		node_set_state(nid, N_MEMORY);
+	if (need_set_normal_memory)
+		node_set_state(nid, N_NORMAL_MEMORY);
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
 
@@ -1908,6 +1914,9 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	unsigned long flags;
 	char *reason;
 	int ret;
+	bool need_clear_normal_memory = false;
+	unsigned long node_normal_pages = 0;
+	enum zone_type zt;
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
@@ -1977,6 +1986,13 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 			goto failed_removal_isolated;
 		}
 	}
+	/*
+	 * Check whether this operation removes the node's last normal memory.
+	 */
+	for (zt = 0; zt <= ZONE_NORMAL; zt++)
+		node_normal_pages += pgdat->node_zones[zt].present_pages;
+	if (nr_pages >= node_normal_pages && zone_idx(zone) <= ZONE_NORMAL)
+		need_clear_normal_memory = true;
 
 	ret = memory_notify(MEM_GOING_OFFLINE, &mem_arg);
 	ret = notifier_to_errno(ret);
@@ -2055,6 +2071,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
+	/*
+	 * Clear N_NORMAL_MEMORY first to avoid the transient state
+	 * "!N_MEMORY && N_NORMAL_MEMORY".
+	 */
+	if (need_clear_normal_memory)
+		node_clear_state(node, N_NORMAL_MEMORY);
 	/*
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
-- 
2.50.1


