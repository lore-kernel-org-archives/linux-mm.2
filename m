Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7407C982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D7C6B00AE; Sun, 20 Sep 2026 03:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E546B00AF; Sun, 20 Sep 2026 03:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CF16B00B0; Sun, 20 Sep 2026 03:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 620436B00AE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 909A7C03DD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:47 +0000 (UTC)
X-FDA: 85233298374.07.EA5044D
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF24D80003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EK2Hus5UDsJuJSh7AQ0PAr8NM4eaFuJoCcXTUNzvFxc=;
	b=m/+M5qphXURnuY4cUWbREeX8UymA2SkLc68+DnONxoodTs0dweHVcfBZucd0MWU1Utc6Sn
	i6nAnYUSCOuJc6QONBUOdLY56RBIx66PPtFr1Y3ZM6WMZqlZc8P22R1ykHgryzpRy9OrMn
	0hxO3IoEMdrcYzLKwqLOYrDDgMWZgoc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888965;
	b=BMTEdFf2fjJeFJrlat93S4hvhC5c02QFfVbFUc/y2GOWlXNeRIyTpAoY65KtdmyQGkE7cu
	PRXa0dsjMBi+y2U4kJMjoKPJx5UvrCI35S2aNiUImlCyFKoRdNOjDAecA3X8+mn6UbML9l
	GRIvcRzXMk+W5G/yI8sOiPnoZZybWWQ=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6412035817f6327f;
	Sun, 20 Sep 2026 07:22:44 +0000
X-Mizu-Trace-ID: 6412035817f6327f
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 17/17] mm, swap: drop a refused xswap backend run directly
Date: Sun, 20 Sep 2026 15:20:43 +0800
Message-ID: <20260920072043.430390-18-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF24D80003
X-Stat-Signature: rgins8ofpdyetzkrrtw6mijphzre8nbj
X-Rspam-User: 
X-HE-Tag: 1789888965-762433
X-HE-Meta: U2FsdGVkX18NmOycwjWVABcZR1sH5aiPPR3jSqLmKHwWe2ATOOGitsnUfPBDBXY6EG2dF/O6eoVLliJB4ByHT5XGWJbS/b6d7G7LnGCZbMX7spy/aHlHiuiQpnZg/4OnMwiVAwO096taFLXTBkWZj4hOwWvtgDaMO4idxIzmCJC3NRNvyJw4q8i6PQSVLFo6O/3mNkcTri/roX4jOEaD2HV1bReu2het5bJjEDAkXLGe1suA0FvFkiqQkmWwP+GinVkFykMfjXEv5e0P5kIvcdSPEoMFXsFJfV6hfMD4L6CE7doWw22yPK4GX7X+sBDSj1jnN6zR/BTgYVozN/DS+V1FffKZlNPvcvHNPsX+RTe+VrAR+S+okyxITVr1sY7C4L1WhJFG2sZZQ7TmyZHnCPZhroZxWaiUujLEXr67UGXX0CWAWhBcVg8F9E/DVuiKK0A+/UR1oy++rzRH0sIHKHve2Yyd4PHute87jKLoUPB8Ag7R7/5qR6YlRuOeIvQ7GLXFFVqSX90BLS1cCeveUN7zxT0H41Guw0d+BUXbnGd2cRji0e8Ruf98WIDo+fTpU/vmJX1JtOt2hlKKg7bDAEboSK7RbxqE9E5TjYvkG+anMfXygMMB4+huXHsLQdaAxAKQm6EBNOrBJRWJHqmEISzNTZj2OWl6QMrLPVdEyuZf5JV3uoo0NTKz7Wpc8uitJkJlpm+koQsiQdYPwN/Z9AsccxR5NLtlMrn3OErpOQE3anf6vi0Kzv/gvOHVQYXoWXTJTstT0X5WMorBJbOXlLKr/1FWypYpsG1p/UeUhCyvH2Gc636JFZ+EURpt2d9mPiQXGj6MDNnG3mYzQf87eE6EOSVvTVOfQuISn9azSqe+rQklzGaQ46ibo+gNU3v/Y6QgiBpysWB7025iyXsiek6dkvhyRno2NKvCopRe5zRn76IRYZpvVvv4uNDGM4WPevbGNhItxmLsK8toM4h
 OyuFdcy7
 jZ/2T1qYrCr+vl7vuMIqeapsN579z8bjXMFLHhlEVS+pSf5RYL7CI7DRyL8O2ci0sPQ1eRsSWxFzTdpZxf8y9udJtWYPFK6DYPHPDGRj4Up8fjzZIqmnOGIYZrbYXlKOXpfEnglVAblXRBEOLQVrz51RlTEJZE2d2pCio/2IOvnQXR5A/KT7KoFTBLpoWdUNaZixfvq6PooHewZlAymzHrojhSA4+/FeBzeg8w2MsNFXLpDICjn5Q/qYB/n7BsOgCqJfLHNNjKNW30uQ2wU2H4l7EDwhgG+LU1Q8zUKhgnvVOF5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On a refused charge, xswap_backend_alloc() gave the physical run back
with __xswap_backend_unlink(), which finds the run through the reverse
mapping. That mapping is not installed yet at this point, so it
recognised nothing and freed nothing: every refused charge leaked the
run and tripped a VM_WARN_ON_ONCE().

Drop the run directly instead; the caller holds it and nothing points
at it yet.

Seen with a cgroup at memory.swap.max: the backend held 48663 pages
while memory.swap.current was 0.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7a67c2ff4e89..2308d99b5e7c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3161,6 +3161,39 @@ static void xswap_free_phys_slot(struct swap_info_struct *si,
 	swap_range_free(si, offset, 1);
 }
 
+/*
+ * Give a run of backend slots back. Nothing points at them yet, so there is
+ * no reverse mapping to look up and no record to clear.
+ */
+static void xswap_drop_phys_slots(swp_entry_t phys, unsigned int nr)
+{
+	struct swap_info_struct *psi = swap_type_to_info(swp_type(phys));
+	unsigned long poff = swp_offset(phys);
+	struct swap_cluster_info *pci;
+	unsigned int i;
+
+	if (!psi)
+		return;
+
+	pci = swap_cluster_lock(psi, poff);
+	if (!pci)
+		return;
+
+	VM_WARN_ON(pci->count < nr);
+	pci->count -= nr;
+	for (i = 0; i < nr; i++)
+		__swap_table_set(pci, (poff + i) % SWAPFILE_CLUSTER,
+				 null_to_swp_tb());
+
+	if (!pci->count)
+		free_cluster(psi, pci);
+	else
+		partial_free_cluster(psi, pci);
+	swap_cluster_unlock(pci);
+
+	swap_range_free(psi, poff, nr);
+}
+
 /*
  * An xswap slot being freed may still own a physical slot. Drop it, or the
  * physical space and its reverse mapping leak. Caller holds the xswap
@@ -4401,7 +4434,7 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 		swap_cluster_unlock(ci);
 	}
 	if (mem_cgroup_swap_charge(memcg, nr)) {
-		__xswap_backend_unlink(entry, phys, order);
+		xswap_drop_phys_slots(phys, nr);
 		return (swp_entry_t){};
 	}
 
-- 
2.54.0


