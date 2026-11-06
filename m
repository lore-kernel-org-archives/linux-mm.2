Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65909606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBlYtI71
Received: by kanga.kvack.org (Postfix)
	id 5CF416B05BC; Fri,  6 Nov 2026 07:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7E36B05BD; Fri,  6 Nov 2026 07:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3FD6B05BE; Fri,  6 Nov 2026 07:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16B466B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:36:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29C51120D1D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:41 +0000 (UTC)
X-FDA: 85404643002.12.2E91030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DABD40012
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBlYtI71;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968599;
	b=KoPjYeoNabOcLwcJNfH7EnRdg7CRdbYLDtLzsbicycN3VpdZroCltfDbHX6qQmEzQlCfA9
	fuj9I4wc7b6kPJQrUz8oO4G6Yq+kxDuuh/MMRPJ/FMVvMFkbv73TIdIDdTjZ4j8VMoKxSd
	IaPdD9Y1LarC9fKXVp3FiTQanTUlgzY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBlYtI71;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPaaf/nAUIxU/MujCzQxnBmdoAj91DZqtwr0DLfU74g=;
	b=KjDSTICKEwcoyZ8aF/UNuVBdEqV0vmmSo2Zku1lQrua5T1KAzdzGQ9eHvhSiHVL1WY//H7
	/ye6UwLatSny0tiEjhgfX/zA1tuSmYn0q3EwtbEkUnees4fsy5YZdCOnomk+SfVQTN7QAb
	83E9QSU1EvXLv2l0PjPhe2p6BH4TJrM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1C386020F;
	Fri,  6 Nov 2026 12:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA691F008A1;
	Fri,  6 Nov 2026 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968598;
	bh=WPaaf/nAUIxU/MujCzQxnBmdoAj91DZqtwr0DLfU74g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oBlYtI71uLsKhVv7lyV38yeBfN5N672YIfMRZFQzXth03EH1SfECRBI77Maw2IXFN
	 gegEJLZn7Ty8f51PP2PrEP3G2x1lPCkrWVoN+qYicRwkgL8c+6mg+fh7TD9TsB+feO
	 oJ5F+vpo04+73w6/VmoJfcQQS+XHoQEEy3YBVKQhCaKO3K7smd12C+8VeeG/6CULZD
	 MmE8Ce+eZl7asicy/G8DKDEzw51+uNSIx1/l1PL9XFqckxK1r1ZRLucENVqb1qTjY7
	 2kftkySzx0oWIzYpC7obWNbLlMeV5T0unQ4lMm+VaZZ3WcO1VQhxoAspnrvctVbF7G
	 HHrlbfEDZW67A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 06 Nov 2026 13:36:12 +0100
Subject: [PATCH v2 1/2] mm: free unused page table allocated by
 do_set_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-khugepaged_set_pmd-v2-1-d2457b5e377a@kernel.org>
References: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
In-Reply-To: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2341; i=david@kernel.org;
 h=from:subject:message-id; bh=OS/dNIms28mbW/vsOf9xV2Ck+BtJzYDFrVVoI/C2V7I=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLenjz3WX+qichp2en9C24Vffqzf5G3zNy2vJdzuAL7l
 X7P7+Lp6ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiE3cxMhz1zy7UiVeftfl/
 5FdTx9jqCwv8WKoVWx69TvbstoxmiWVk+NSk7nKaa4WczmmfDPt+Hi8GYZ3X76asT8u4ENroFFv
 PDQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: oejfoaf6bxwa4ocjc5qrfs8zp3xn9ikw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DABD40012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793968599-892973
X-HE-Meta: U2FsdGVkX18MWXhatBnKrHxC4ZVyq/gZwM72tc9X/1zvF/2gvJZiH0lSfHmuZd48FUHVvvgPSaHUjRY9Fll5Wcm/3oFXVYGtDPqys4pFZ7pegxpL7p0wkPl9h01UFO+LUcixbAb+1BHimhakAQYvOmqxYjofabbS25n5wfGUAqkrS6bb1ofPH8TZJYIntPB54Mbj/3NXqu1+oBFz7JBN3lFVL5cHXkTMjSDYVYlQCUVxXt/jZSFYhlOwjuA5mb+ADNY0HGg10Iwm9uo6e+T5GThXtL2Phulzf0BCSeiQtsLrceZLekYwf4uWadm7Ki+wjeP5CkiObCPZNYHGUkTkis4CODyGlDiVk2+gMZGamyYOTdoqwSGPNHtcIbrexR9eTOcKmRtXwh7cl52D5C6H/rnUh0axv/iNB+iuwsEGDlzjATK4YvfKsmAvGRjFcEasTQQupghB32yGypRoj0Dh+2+9m89n1CrJsbnagRfKu1A5QFdJ54j1i/CUR6+4z4wGGIRpLTlqUWgFyL1FnZ3gfMxoEOWPGv4pfdhmmcRYM0tDemC/cxA4h1DmJ76f3MKaGyjgHffs3gAVakk528dY3Mucx5+RQ6GjkjDjGT2BByKXwDsYysk+A/HYEIoRJBHikcvMqSY2K6xZHCYH78NLIt6pVPEQ098axtKe4vBMUenoSI4amH/nWiaAW5EtO7rpPTUIQkojS+rhH5qQ0/dL122ietKA/ysrgJMr0NG/XwJfZS2/2XwKokgev55j2Smmw/WY5S9WTRZ6vK3K9J2BWF67C3WxGVWWVuuQ0y5ndg+4D/YJ0jLd3qFkNIcvq11/2VWNqsyRDeBfbIobac4SZ3GXeky4WMa6u4hv4h7XVjrEgZ2xj7T0uoWkGwlzhN/pyxkLYlW3U01MJQFV6Bpooj6KNFdWlEQ7kyY+dCTnIHWlbSSTvkeRK6yGab3ckOAxxrqY2IJd92ugt15KYRn
 jJP8lKg8
 Q18XSWNkgefYfFKG4jv48nstMpgMcvDXUsp9KraEu63cHVSW9zEJny+r2nYjLj3evuMKGU8U8qvL0+RdyuyjBddAClvSwWQjE1lNxoYqyndEXMYrWib++pm3gLQVtKZ5ZYMExWj+3SF6VirXI3tqe5EWWh2ARsno4db8e1zyCwbwA+ZEH8+SjFVaeLGbQS89rT+LXPPYDNu59moJzRMXngm+K0dG8Agf6ORsPvVOknjOkoNnDSzXGwE9tjdRlNhm8MSyWuc26tOVY/8G+lNnpQMGEHY/DrWGsIdXp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_set_pmd() can allocate vmf->prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU. If the PMD is
no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock. If that races with set_huge_pmd(), the unused preallocated table
is lost when its local vm_fault goes out of scope.

Track whether do_set_pmd() allocated the table and free it after dropping
the PMD lock if it was not consumed. Preserve any preallocated table
supplied by the caller for PTE fallback. Successful PMD installation
consumes the table and clears the pointer.

Returning without a preallocated table matches the existing behavior on
architectures that do not need a deposited table. All callers
already handle that case.

Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Cc: stable@vger.kernel.org
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index becf53a2a0944..421064aef3cf0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5687,6 +5687,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	bool pgtable_allocated = false;
 	pmd_t entry;
 	vm_fault_t ret = VM_FAULT_FALLBACK;
 
@@ -5725,6 +5726,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
+		pgtable_allocated = true;
 	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -5755,6 +5757,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	count_vm_event(THP_FILE_MAPPED);
 out:
 	spin_unlock(vmf->ptl);
+	if (pgtable_allocated && vmf->prealloc_pte) {
+		pte_free(vma->vm_mm, vmf->prealloc_pte);
+		vmf->prealloc_pte = NULL;
+	}
 	return ret;
 }
 #else

-- 
2.43.0


