Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E206A60A260A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=KGAW2nu9
Received: by kanga.kvack.org (Postfix)
	id 04FB96B05BD; Tue, 10 Nov 2026 06:25:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027146B05BE; Tue, 10 Nov 2026 06:25:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FCB6B05BF; Tue, 10 Nov 2026 06:25:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE41F6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62A951604B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:14 +0000 (UTC)
X-FDA: 85418978148.25.622B855
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF16C140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KGAW2nu9;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=olyA0GkCFOlLCJET/iZgvs7pvm9Jf8w/7sECMvsdEs0=;
	b=2m99TFB++RN5b15Bd+pO7ks5/QanX83eOdp9ShUIbcoa2bkhekaTCGjEre6J3bCxV1FG3e
	jg8gYJBrGwDFWUwnv+PlpVAu4AFpVYBgdMBu3YPA+O4EzqmvAqyhlJ/FBF6pNRoeKMeCgs
	LHuL9UNIqYeLJqG3y1tdxY915FUSUtI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309912;
	b=xCsAJi9Wk7s0dJmgmR/3pH26hgBRE98YghfgTJDH4/40aOp49z6WTkl9GDx2ICM4bd33Qh
	EIVrBTEizUnvzuCzAPMwIJXqL9H6RFMMsnptBCuQR4pNSIhxsHUMgVxAo5itorITgnzkNP
	NNuzRLw0on8CezhRK9S8TmNsjSiUDNw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KGAW2nu9;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso3837759eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794309910; x=1794914710; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=olyA0GkCFOlLCJET/iZgvs7pvm9Jf8w/7sECMvsdEs0=;
        b=KGAW2nu9d+or44jSmqVLnwljuQguRB8e/x8JiJXBHjI9z/TpEsuvFBGyDur2Ma6jOJ
         OpCgCm8mJPBfAMoQteAbfSnP8Rhg78s2irHrmB2ZLboNPqXKLPoaxTMmJjuAOuI5mIAn
         mb8x00vwJigYu2HNrRr8IrsdrRzzN3lp1N0YP5LMCkwZcG5aCoJ9Dr/wsGyy5mQ0G6EB
         6T/xpbBZTVuv50xh9cvw1UGqwk6Hheeft22yiov1NVjZHV80P1jJRB1xcM9lUOvOLxFB
         dyNQJvJB1uvWu6vYm8fD0M9cFKRbWKnxasQy2BCWqPeL1XPsitT8YP/EwtJHO8uWYoP3
         yhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794309910; x=1794914710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=olyA0GkCFOlLCJET/iZgvs7pvm9Jf8w/7sECMvsdEs0=;
        b=JVA4iOi/tTXv98mrhtofkRDdazX7RHK0nLKCz4Ukwml6EU3+v/OejDWWgPnj7aBBew
         ZmiuIzqhZdx2nv1FRw78hsP8GOwSth0eJtUg5HwPA5UOdowMnFxV/PN5IWx8usJXXiNt
         9ZVpwd3KJA4GDCKVTFTf5CzRAD0PT/wfPI/UBnFacah4rmUZR8gh7goHXTs2U25YmQZ6
         g2jbGJ5dFh0Df+oTxiN1FKQtQpIhfYoBzN54uEB9Aupu1rcOzfF7rxWmGvCRYsFmXeOH
         SGLyVqWpm9FidfNh99wGAOUn2pisrq5/oRWqBeY02w+w0aevNnRxGX8tchwkrLmiYuSk
         RAag==
X-Forwarded-Encrypted: i=1; AL+hErFDs6CZeH7j2X2pQvl/AcK0qdMSrcw3zy0a+4cv0/pfstE/49j9/JdfQvPdj5McbQOflkw236hlbA==@kvack.org
X-Gm-Message-State: APuU4Z9oXupnByuGe7ek2JmQz1jeZ3au8rzzqmUDNyf3MO2ZNpBYEhfr
	OxMqwQC8YHhfKd3hxSX8cVO+3iQnpvLO8EVSqHDlUFiNCPALroGrsDXwZ7qOEBwqAKc=
X-Gm-Gg: AYBFou2ATvtf1bCaiPa1+kdEOIpesjU9szHeEjDVpLITGhzFH2IeztnvOxBrRzNI9f8
	x8HQ2xbJIVdGIZqwWKLE6NPIO1VZpxs5J/zP/9ex51IqHyN3fZjXRBMPz2qXQSvnLJg0AGUS04y
	Cd/aTCb+vKpfS2Zf4AnIWs4NoMMkk/E7beKL+Alzwdz8/YvjciLY74aL2Ws+4yivixK2/U5Ok2N
	piA+kn8PVb1cuM+vi15roN5DMJnkV0bEs1kkjz4rtBNez1FMmS+eR6b+WVZtVKRxEtVPjIhsiJD
	nABVhm2bZ9QnOrmq8O3vkUAxZDqw1i9TgC5CaLHNfuSRsHD+enqpSjZtvfwSZag0IBz2SCeT2c3
	dZPrPZB/pm58Pn1w2/Y98x8RXbjslJPwtrP03XDfePBskbR5YaoSB4c7sOx663j/ykvWmtA2dsF
	Mjlb767flC4sD1vf2ak3QWLLSwYinFKJlvCHW1cz2rqVspoHn9XIjeyBv1Pl229oE7ftnqxdwHk
	+ltE8qcWIZdx/s3/Jc6iQVBNFoTaGB3fZgHo6WYrYvY9QdXALfEPQrB+JJRcQiFFCI1SJYE8/tJ
	KGIX4ghUZjXNf30e79798vX5pgbeP55bTnmkp4/Buby/P0ZKHcqqGA6/ukMa/Lub9g==
X-Received: by 2002:a05:7301:1522:b0:36a:1089:9836 with SMTP id 5a478bee46e88-3751ee747dfmr2528761eec.15.1794309910199;
        Tue, 10 Nov 2026 03:25:10 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37520cfdfadsm7608755eec.19.2026.11.10.03.25.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 03:25:09 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/hugetlb_vmemmap: fix PMD split TLB flush race
Date: Tue, 10 Nov 2026 19:24:56 +0800
Message-ID: <20261110112456.62827-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5zodicn4rx5trgosfcmdxe5qmpddg854
X-Rspamd-Queue-Id: CF16C140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309911-960881
X-HE-Meta: U2FsdGVkX1+jX/v7rwCVoWAv/nL6rW1ZiW0svZH+XsZ+RF4YoJ6rwImbkSmk7Sb/jPBw7xsHSsD20GY+oVikcIN8pNsFUt1BkWOnwJOU0Qt20ABVl6uvi657xJmrwBXrO9fTmkUQsmYyObx0wx6DPrE3s/lE4WMwGOwOfw0G5pOKhIYh2sqqmljWIT4OSAeYwAD8yRvdvVNze2gxQuPBNe2VdBvqgij4yeKuhkhlSbH1049SE6bpTSpzgPv194IyXRusgBjBjdE0ZqRDf+j64NhtViBOEptT9B7CozbGkAOx+gdsAaRowSIoAiZOuD+Br9j9L7TKhDZWKRfAdUmSQfRw3ofVMNHullaPtOvbyTXqKrnRwKFl2B1VIa8d2ZK9ipXsYFgcCsd79WZz9swx0YmyLXFliIpPmNPyCpfe/lemZzqBzkfepbZJZ/vPylO5QxLkR0OTZgqWNZ/oPepn0zIfV9pPncLMn7cu8m2R/g5SolkT+OG7NbvxcJwaP7UXgsz7vfq7DB1KF1JuzWXYN4Q8140IZQF4MNvg69aH73wtIEkugqyh6kWb/mKfB09j3V5PyE9pxB9CgQa0rdw9FRy9VIaXf0Vk5rYAtHFNN8szqhaSsrzVBCGdVY1KzaKIFES7bjTtPK4UjXw5hwyw8EmsIgJdZz+pL82ddnifpU9a0caboAAb2Pq+nBjbwSSUpu8MTrPK5eUkzkQhDvyX8qARl03Kth15L42CdC+9QrxEr9Za5/bmrhCkMk2LBEhHuVRSaFIHUDDYkpY92IMl1CTtYTwJuI5cqq6Xnx8l6D3pQ9PbAETxkxGmoI3bUpgTzMJdRbd5qht6ycH8rEhx3Z2bB+BveY6lN1Ht0arNr1Z8Xs89uYFrGOSwvmoVRItwm8slty8JjvIqnvX31wbRCLnetdZcXdErl2gegVD4VCrmXZta2dakH9+jlqS2JOD8oBUEC59xxar5Aq4jEzI
 a5tWLFLO
 pAY/s2nERhxReavD5nCmcXu++nI4JFa6kbB/ccS2XXutzad/pXDNRnLWkRInZPD79jPwWWP5cTE+pXbQeGpQP/I6GVHwiDAVzMZMTVd47DVqz6NNQhzmLnN/8E5BAspfEbi7+RO6GmfcQZpgDNwh+5ZBbllljOZf+NUMEcE5gmoaG5QQ+P6xeGZMc35poLtAN5g3UMl9DmfBNEYeLtnrnm8Xw2+sXNmqGgOHT0tEo5ZWEtqwXFf/OyJw4b5+xiQzusjGMHHWo7uZ0yMxwOs2dWJXv5d6qxJHVn+QC9356h0g3PV8IzgS/CirpVGUIMksXb2lZwB/IyEimBHei6QgGUBr3RScpzbAMJNjFDBMHnCVkHuuqAeRTwXrp0Sj/AV1uVqp2CLGXF3BizDewmgdbAheDVM8A+EQ+YfIDIh1tAFe963LLeXbFXnoLhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Bulk HVO optimization converts vmemmap PMDs for a list of folios into
PTE tables before issuing a single global TLB flush. After publishing
a PTE table, a concurrent single-folio optimization can observe it and
remap its PTEs before the deferred flush:

CPU0                             CPU1
hugetlb_vmemmap_optimize_folios()
  hugetlb_vmemmap_pteify_folio()
    vmemmap_split_pmd()
      pmd_populate_kernel()
      /* TLB flush deferred */
                                 hugetlb_vmemmap_optimize_folio()
                                   vmemmap_pmd_entry()
                                   /* sees a PTE table */
                                   vmemmap_optimize_pte()
                                     set_pte_at()
  flush_tlb_all()

This can create overlapping TLB entries at different granularities
that map the same virtual address to different physical pages.

Serialize deferred PMD splitting against PTE remapping with init_mm's
mmap lock. Hold it for write across the entire pteify batch and the
final TLB flush, while optimize and restore remaps hold it for read.
A remapper can then observe a split PMD only after stale PMD
translations have been invalidated.

Fixes: f4b7e3efaddb ("hugetlb: batch PMD split for bulk vmemmap dedup")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba8e11e399b2..ba6559bef742 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -158,10 +158,8 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
-	mmap_read_lock(&init_mm);
 	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
 				    NULL, walk);
-	mmap_read_unlock(&init_mm);
 	if (ret)
 		return ret;
 
@@ -308,6 +306,9 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
  * is skipped, the caller must flush TLBs after all pteify operations are complete
  * before remapping the folio's vmemmap pages.
  *
+ * Note: The caller must hold init_mm's mmap write lock for all pteify operations
+ * and the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
@@ -318,6 +319,8 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 		.flags		= flags,
 	};
 
+	mmap_assert_write_locked(&init_mm);
+
 	return vmemmap_remap_range(start, end, &walk);
 }
 
@@ -358,6 +361,7 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 	if (ret)
 		return ret;
 
+	guard(mmap_read_lock)(&init_mm);
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
 		return ret;
@@ -392,6 +396,8 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	if (ret)
 		return ret;
 
+	guard(mmap_read_lock)(&init_mm);
+
 	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
@@ -559,6 +565,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	if (list_empty(folio_list))
 		return;
 
+	mmap_write_lock(&init_mm);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -583,11 +590,13 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
+	if (nr_to_optimize)
+		flush_tlb_all();
+	mmap_write_unlock(&init_mm);
+
 	if (!nr_to_optimize)
 		return;
 
-	flush_tlb_all();
-
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 

base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.54.0


