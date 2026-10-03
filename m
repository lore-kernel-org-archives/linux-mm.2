Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F7ECA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 01:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D63F6B00A1; Fri,  2 Oct 2026 21:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADB86B00A2; Fri,  2 Oct 2026 21:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3AA6B00A4; Fri,  2 Oct 2026 21:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 373146B00A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:12:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAA521208D9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:12:02 +0000 (UTC)
X-FDA: 85279538484.29.46C720B
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf24.hostedemail.com (Postfix) with ESMTP id D7439180002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 01:12:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790989921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xX4+ARMrOziQ/1hS9yPr4jFm9SdRT/pYEaPWAdNf6ho=;
	b=xmZViAFOuGk8FimxCT8njHLRXH1Ac5o8FEIP2AlwRM9Ou3XcvsWA2U3sLUYIQ2glQXk7nM
	BTVCxTdSYbG+hwerWd6wvSuqbzwe4jDBEGJf2PjKuzhumfoTj5LoSQXvOtpf/s9RlqFDnH
	wPYFYPjYsJ/ibS9hYOmrql0mAkeSFc8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790989921;
	b=3aJTdST2G0NB/soi9vClcjsbUYPg6nIRMMHO9dV9Pzv4tadRuPrhtRkB0Ew4bBol4VrIVc
	q8z3JT9XxKOPIhkpwxIKluAABpoE84sQknYAad5GMfkDTQrPZt0lsJwugQ1r9TFOEmwOrP
	sm1J7kZo27RFpgBwA8PokDSo4Fy/FuY=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id c080e56c016d6bad;
	Sat, 03 Oct 2026 01:11:59 +0000
X-Mizu-Trace-ID: c080e56c016d6bad
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
Subject: [PATCH 6/6] mm, swap: drop a refused xswap backend run directly
Date: Sat,  3 Oct 2026 09:11:11 +0800
Message-ID: <20261003011111.1003090-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
References: <20261003011111.1003090-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7439180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: d4mr8ykacahw6hcxww93itp14y1gmpae
X-HE-Tag: 1790989920-485505
X-HE-Meta: U2FsdGVkX1+/zjf6BYrLzGMRkdSHES4TE8K2/edWMa09zSrSY7KMAa3kr4MYA3MALQwiOPnqS6BYp2Dff0jDBBE1twTiFLhEvyfCrzR9Hv+oOg1KYW/pE4eXh2almfzZ64bFzQGS20NR79N/2oWMQmFdy50Zq4yL4/egbzqZA3EenCNLFCoNdTkEGAl2QKMKbv5EkO11/w+PuHoKKbBBDTveVYDAfv26Uj1jxV9zRQdzay1vQEPUETsvRVzXZrRhAv3V1roR+mUdep5/jnR1uWKZhN2RsAUrOTPYnO7pg1uFavz9CO3SX+zUle6BTT+iv0QNmQfO0KSIXC/HhSoJo6QIkZ4I6+q7ox2AQyMif6pKmNE7G/e3Rv+VI+ESYhetKk128s/SPhZL0gOuftZ0t5pbwsuLIv1a7uYb+lpP6d86FdlHfQkE67P31CVZVeKB3L3JCWybcWKHio67yLhAYsoSniLTeTAzodI1i8Q5c0GMtFP29XeogZNVMIss6ZcpXnJ06uygfH9ISNnriwb9tyaIcpab3YHyRstDkzPYBNtmsaDXlyoTKQ7DRBPYRrJt67fGnbz+CxKMqW1/zx/4ta2T1HskxtbOLP6kUEPLZ/MhKtlSi6D0PA+ssMrbNxl+kLPQLxj6n7dM9XqRw2vwlPuOZRi7fq/FxL4p4tCtHkjElc7xAzveYNY7CYJjL/wDH6c6KIDmPg3ey6cDXEWbT3G/3Eq3RjFjfz5LVPqrKqrGMd6855tNwsRQLHruyXnC4xZO76/AyQlvDkiI7wkN5hV/fNAhOm3mtw3RE5jqssn5gdKY9iGpE3ewGlzi80E8HDUvYBG781kI/fwtkzIjpxfVZs9xxKEb5TKWxEtjyVNkdO+7CF/jEgiS8ESdJAjfRjMUMGUy7J1UPDeVtXuixWBAgV/e4v2bUApXEbS46CdieR822KGSqWLbmrmWs9vLY+9CoWzQvDusOaLBWGL
 29PeewJS
 jJzCX1xPB4CnXwH+isUBknCZziAhi+O145PhgDwg2FH4IbqRz40YdZPkonEqQBn3sHkIZR+teCv+7tnc4IUVNbgBolAnTwL8I9GDZjBjAGMuOq5znytF6XB+VleZvbtm8e/5jowb539DZG8dqM43Ef9p6eMcQ2/RynEp4GanM2/SE4HI0KWb8SCyfdqTfjkVnhhbsgbu1kZaFLnRpYJxTr6HMUhGKEbJaqKTE
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
index 419d19f3b98c..0f841616d27e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3302,6 +3302,39 @@ static void xswap_free_phys_slot(struct swap_info_struct *si,
 	swap_cluster_unlock(ci);
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
@@ -4697,7 +4730,7 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order,
 		swap_cluster_unlock(ci);
 	}
 	if (mem_cgroup_swap_charge(id, nr)) {
-		__xswap_backend_unlink(entry, phys, order);
+		xswap_drop_phys_slots(phys, nr);
 		return (swp_entry_t){};
 	}
 
-- 
2.54.0


