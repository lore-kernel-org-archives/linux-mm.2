Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B4BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4A86B00DF; Tue,  4 Aug 2026 15:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3626B00E3; Tue,  4 Aug 2026 15:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0200B6B00E4; Tue,  4 Aug 2026 15:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDE376B00DF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:25:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DAEE160232
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:28 +0000 (UTC)
X-FDA: 85064565936.13.1929447
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 410A1180011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:25:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awDxkqdu;
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785871526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2Y29p3URliQDUpYncV/mdRh8V65BxFsBFAIBDDNY58=;
	b=mwj2iodEvn1vgK0UAhQZWWg6Tmr9Vjv+/VCz9kSdBG/NtVcaz71OUsT4tKKb5t5JdMbsuC
	K1UiZJRt7VFWIVn7r9RRIvqupr/SL+mglIPDs4+3vKlxyPTZINZY2KyA+R8dds8tgXh3lC
	fxTQAiTur3rJ/E7/odac+u9bkaxDERU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awDxkqdu;
	spf=pass (imf06.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785871526;
	b=5bK2QYO2wd48vC6Yi95TZwO4AE/XVP9REZCIdHn0ZbOOzHtmSlMQDSoYle0W6jiLRK0dbO
	nwV33jKASsYiU03BLcnm6CT7MFT39H9wMNXaLabJDVaZn0KWGQ+dxxyou3mVjgvnbn4I8q
	/bZc26kmU5CDuZqOCzZwBrQmDUYqN/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785871524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2Y29p3URliQDUpYncV/mdRh8V65BxFsBFAIBDDNY58=;
	b=awDxkqdu5R6fcf5fkrzPVOv3NNyv9oz+s/2aDdbyyk+ha0Az7QdGFv/GF5VXWWxYDsBZ+9
	a/+8g2BFIcDxs6KW+yiG0leDOmIkQTPbUX1vYsi8k/IusaCIwyeMfvuX8SP6c1io5BVYYu
	HId11vcK73YmAyWGK0qMndxgdqI1YAQ=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Tue, 04 Aug 2026 13:24:59 -0600
Subject: [PATCH v3 1/7] mm/khugepaged: refactor per-scan state clearing
 into collapse_control_init_scan()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-khugepaged_pte_refactor-v3-1-0364cad642a0@linux.dev>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 410A1180011
X-Stat-Signature: kbmz77nn1b1t89ktrtcac9989iunbfgs
X-HE-Tag: 1785871526-940761
X-HE-Meta: U2FsdGVkX1/HBCrOVHDRXEQKupy0+8lMjl9Pdwtd4WtayPDQfQQoJBKkoIle5M36j7bGoxC4rcDcX3P0EHvC9xaQi3nwnr7w7yTF7vRlREkhLoJzVe71a1SylSnKB7VqJZzJxMBHRRaps1KeUE7rTIIO7WdQZADn+eTG2Lk1ev0hT3VIMuq459N62C7qCrSpCvApFArUiWDYOCQ+QIt/aWPhz04jgdz2dniZFpkhveMVcesOeGsFuicbmlT3nflklIy4ayFPdxfASk97chtWUifu8XPVUjASGGvnFNWuVInLMip0e5+e9dAiHiDPECxB3bd573PoyZnCRZDLkTlKmPoINsqJPjATz5MaQpMRU+sS96GZlzw1X9xbI36ZbCoa4ZQibpGFawLnbSxFjb/twSL/VOh76W4GPZmEnTwiQm3Lnqrq2Fiomdd1eZ2m4z0dFTunvtNxHYGQPQvvkL8ZUmBx9SVVLL9Epgn4nmjb/hfeeGrmtDXoMXZN1Uzmy3KypqPPVUFxO03jdc5AISCcdWi36T+r3f9t2cJOD8lqQa3nlmKaAeBL9BZgqhDaCnLvxg+2Q7A3bz8jASms+UGwLWkzM4UqoTIyRTNld/mmbd4umEWx9jblEORrmTwBHXqnU3RiBYI6qdTvBnCZGPXerRaHB8h1t8u+jzzijKL7Wvk6tMkwsInB/I4bIY4tLwycsCG722thc3R4l0OEbPV2PffQVSPVZekYfQ+mw8aLkz764ypNtgwYGWg3gcEeQg7B4l8JEb3Qap7HI9LqiRLhElkooBIsp1pECZVTa02SXuj6fmszZy0N7vwI5bWA5qxMWM//2UlwCpV3gx44Q0pO/1f/hw5A8dcF0GN92PMY0CEAYnLC420SX9ECdnx06C2lt/qRBeonQR4Zkh8uACrE3bHwNkX7nirGC9U6+hidFu4S/kxqYXRFcazOYaHWrJ+GdjFpSwI6VMxwizwFtJv
 BtLDSx7H
 Lxt6Vgsy6+tmuPtpx1ciI9EMVrb232fxEZ+Qs4MSqdDWOUjW8lEWY4h9U4+zucGC0MHKocKbNVB+g+ar6JH5BRG7RMKTbMqeJyOnw6akMFDu7e8H0H0KgeI3p+D33+qmMfLHKmCsIbYio53cObGKkq3Yg1iHRbBhOYK2fFA77vxCVQCP1ik07B6wmJm/rI1qnUWuI48QfdrG9bME6+2iCcijoSNIv19Yb4cpXogHntNFyDPsXxb57WlmJkAMiZjfxXCPslqlo4UQMC30AuYeg82Dzh1V21t7pbDDxFL9fFl2Q27SurItIkzwlIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the repeated clearing of node_load, alloc_nmask, and
mthp_present_ptes into a helper to reduce duplication in
collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
current use the bitmap, they will in the future, and clearing it now is
harmless.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
 mm/khugepaged.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..1e26ea97381a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -629,6 +629,13 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
+static void collapse_control_init_scan(struct collapse_control *cc)
+{
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
+}
+
 static void release_pte_folio(struct folio *folio)
 {
 	node_stat_mod_folio(folio,
@@ -1617,9 +1624,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2691,8 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
+	collapse_control_init_scan(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))

-- 
2.55.0


