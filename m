Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD84CA5FE2
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D856B009F; Fri,  2 Oct 2026 21:11:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E106B00A0; Fri,  2 Oct 2026 21:11:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723F26B00A1; Fri,  2 Oct 2026 21:11:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1326B009F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:11:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBB5A140850
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:57 +0000 (UTC)
X-FDA: 85279538274.23.BE97C4B
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf08.hostedemail.com (Postfix) with ESMTP id E9F24160005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:11:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989916;
	b=74el53r1kqN1j9Osd0BL+jK9KCrQMtabB4dSjCIjE+3gFwuu1yansgLqspoaGSNFjGFil/
	KSZp/pHPWX8qTeIUiCWY61ADThnmcd80/oTfE9MhOe3NvmzN3YNBz9fzh1X7Sq8frNgVjs
	h04dNRKE2/l9YYosnUssffRxP6r5Y+Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORLbci/dbvSb8tVo3KGyUVk9J50/zfzxUEFqKNe4mus=;
	b=8kZiU7ep7zW3AW0sRYlMYf6W7CSPrArWylarJ7odOBkYRYs0XC1kcn+ied/Pfa/JrhGzUJ
	E9Htt8n3zH0cONTI5vcMwN7GYWTVTzrMTV8JWpTq+YUygVg2EkKRuqiSmHbo3x9G444j3C
	iE3ElqcOoMaDsXd4Qfaps/5pl69GgTA=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 7a2a3e67e205a4ec;
	Sat, 03 Oct 2026 01:11:54 +0000
X-Mizu-Trace-ID: 7a2a3e67e205a4ec
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	tj@kernel.org,
	mkoutny@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 5/6] mm, swap: do not retake the cluster lock when uncharging an xswap slot
Date: Sat,  3 Oct 2026 09:11:10 +0800
Message-ID: <20261003011111.1003090-6-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
References: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ik6ufup9msijc6rccirgs3s1d9bxruni
X-Rspam-User: 
X-Rspamd-Queue-Id: E9F24160005
X-HE-Tag: 1790989915-238131
X-HE-Meta: U2FsdGVkX193Vham7XsABlqS0UhzD6ea0vwcnanrEYpho5Qdd7ER57wwPfMqKDVsgJeR5eruB4vf+bYVlCVdNvKbME9zTDdLQEHrSasM/qd5ychZUBjoNyVk++EPihi+1snfyb4tT6tvcvrYEtiSanvsaaiwlhDblwEBPzkQdS+qmuwdQIsZRT0/taHF7LOdYbArRyDkuyBxBEUnDiyi55VD8MdLTU1x3OOrPXt9Y88m0g+SyL3/gmeg1hfGVZ5yzV+SJ6bnp7rliXKsOFMXvs0bvfmEsRuAPLdroczT3kcyQxYLJDx5f8s96lRYoXhQ7yqEtM60jyWRjon7n5dFUj3L+JMs9O+mo7JfTMICOSLjZfEYzFmd6Ds4iMFSHSb49qzsLD0AG6+A0VtGS9C5kFDcbxFLyJCPhgvV+t6+thB3y6VSGltc7xFhwF+KBoYda/aXVAHMAYY/k1pa90txuDLa0zQKZZ03Ibqh4iAMJ1UZ6xSRRTCQqHFaunOBJktWBrb3CVvcQwtCvBNRFRnfIs5gZsW/3lK45hjry/xvXVdB0y+v/X/joKP2gztnwZDCIXc3upwx4Uv4X+KaMAQ6B7L3ehYcQTr+N3cC0scM77ndCRzNrTB+NC3EFrZOvvwSZSaDTCQvNEmmi7M0F7k/dRE+4WSC2N0KMpLHeTWGRNvt5WFovWe7CpEI7AtKEx3Rr/e6cTM6Y1PLVaPHVse1jSW2zJvRP+VmDmRou2GbKGGI9oLHG5/B8khAZJtCVmJhruTr5aaHyVASDIxOydnmUbwMn8sX6bf0LuOPaHQkj3BPLhuyo0eE6+9EO0gjFDtZPwqY7HHDzMJIGZ/P3/0HONbKMUT97CAD7FDCS6SLnB6zkeymVsL7I6fO1dPytEnnZQ913lAXqfSzMAyXSUTO55gBwsz3EqUZpeNUn+qEx8TQje1yWuBKHxCwvr/LkjZezliZk4ATTjeMnb+vvr3
 DN7X/xFS
 hLZcWm5OUq+FVm1Xl0E8BWsnJOTFL2w4Dr9+a34S1zI14JWtNFYBsGEOQaRYguHFfsvdP+OxQUMfzLuWsfP9KmnbYoFjSlHmyhkKEMzZeQeBjC5nXsROOw1SRevBsbQyleJRXdbhvXxv48CjOFL8IRAxIRvqvWpAlsbQHNbwjbp6q44GM02PL8NMBXzC8bypVkA/wDO3ggZ6E6MRRiAF+pqCgJUPRQb07xkkV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap_release_slot_backend() runs with ci->lock held. Its callers free
the slots of a cluster they have locked. It called
xswap_backend_uncharge() to give the swap charge back, and that takes
the same cluster lock again to read the owner out of the swap table.

A spinlock is not recursive, so it spins forever. The swapin path hangs
on it:

  do_swap_page
    folio_free_swap
      swap_cache_del_folio
        __swap_cluster_free_entries
          xswap_release_slot_backend
            xswap_backend_uncharge      <- spins here

Read the owner from ci directly instead. The lock is already held, and
the cgroup id is still in the swap table at this point: the loop clears
it after this call.

xswap_backend_uncharge() stays for xswap_backend_free(), which runs
without the cluster lock.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a3d4561566eb..419d19f3b98c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3313,6 +3313,7 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 {
 	swp_entry_t entry = swp_entry(si->type, cluster_offset(si, ci) + slot);
 	struct swap_info_struct *psi;
+	unsigned short id = xswap_entry_id(ci, slot);
 	swp_entry_t phys = { .val = ci->xs_table[slot] };
 
 	WRITE_ONCE(ci->xs_table[slot], 0);
@@ -3321,7 +3322,13 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 	if (psi)
 		xswap_free_phys_slot(psi, entry, phys);
 
-	xswap_backend_uncharge(entry, 1);
+	/*
+	 * ci->lock is held here, so read the owner out of the swap table
+	 * directly. xswap_backend_uncharge() would take the same lock
+	 * again, and a spinlock is not recursive.
+	 */
+	if (id)
+		mem_cgroup_swap_uncharge(id, 1);
 }
 
 /*
-- 
2.54.0


