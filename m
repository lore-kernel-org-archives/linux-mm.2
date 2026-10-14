Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1B1CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008B26B008C; Wed, 14 Oct 2026 10:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBAA6B0092; Wed, 14 Oct 2026 10:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12696B0095; Wed, 14 Oct 2026 10:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 995CC6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:43:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE90F1C3AF6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:43:11 +0000 (UTC)
X-FDA: 85321499382.03.8FAF364
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4F17516000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:43:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=hKxNDQ+M;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791988990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcluCPw1guoo6eTwrCk1DCm8wcF/REa2+vS/gGt+sB4=;
	b=dQjyoVqgrv0opo3HRmtgWmVoXkLqP0TSjVUwsRUTEZ/RnZeIwAYQ58B7h9Kw+S7Rw/+sKP
	kshxM0mjzfqb6MaTdkPeR0r0MFZ54cV6SA9VRijEUM5/RFq88oeH9WVVCOLHpOWSeQsjO9
	B/XamlmL834v0XNmMm62BMNsZ6RpZpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791988990;
	b=jaIRqX2qpSzuOtnvD6PNa+sVNSarfzSpy3xiI92R4Pp4RlgY0PV81rfqVAFTHBamC/buTX
	KAX9ImG6lexd4jHHfdsvqxadJkyFA8se4trsrFdsi+cu5dyeZZGS8xk8S/YvNIkDLXnlIr
	LzXdynkYAmIFPaGXeN2wdbBeKUCd48M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=hKxNDQ+M;
	spf=pass (imf08.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=hcluCPw1guoo6eTwrCk1DCm8wcF/REa2+vS/gGt+sB4=; b=hKxNDQ+Mxr8X0fXgQst
	/YjlCa98braEHiObqAQKG+I7vG6ASme9WEz7OHdIuQoBQ7mS/yKw92c7UfFjYRlkM/SX9Elk64WQl
	0/ybId+BHOwJm25kPFfLmOrrxG/DAnuIgXvag/SiF22z4RCcS2pTdRWnYq3fKXh5qr2aAf8E1RRKh
	B3xoVHiWYuUjjdZsAy0kefl7DJ2lLt//dRyehTGyoUNkkCb4WrnreGcmv0xP+X+sbEbsyOSrm92UC
	i4P4L6LPwv0RU40qqChiewDx25NGPpTnyEQGqizEOU6mKIY2CsMbmvnbWr/R1VTz7P7o7d7DXsQ1a
	meV6BVNBgwjMF2g==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH08B-005A8J-1T;
	Wed, 14 Oct 2026 16:42:31 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 16:42:22 +0200
Subject: [PATCH v2 2/2] mm/huge_memory: deposit a page table for a special
 PMD copied by fork
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-2-e1548488fa68@virtuozzo.com>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Sashiko <sashiko-bot@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2320;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=slTLN+HTnyPRDcPUmB57Ei1RxAqdQ9VfazOYgqTzQcY=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqz5TVF9flfaIoTBYEiUAWlbx9oilAi3NU4+UWI
 atXUxHOcduJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas+U1QAKCRBRlgpH+WFc
 KjwfD/9U0aEkzB3l6KdM/Gq9P4U7CV+cgd/WlsK1UMK9FIbgJK5laBYK4Ck5WwwgRBu9UZ3HtKf
 dD7edkPu8wofgeRbl1WdoRIqbuXUG0I25ZocjDd/bU92I4JWUTAgDBVT3MfWlF8qzL9k1dB2v/x
 2jUSNletnpdxeWXf3f2Pfs3ir7L0eWLWKyzIb6FjMSLYyuWUkyGc3UoxTgezkHBDEfrsmB3MDHP
 Mzml9YdTYFrhlm5uLMDQIRz7tw1/tyXwaKXB5Hspr53+rZX2exiKHT7YSXiIQplnc4hSGYGt7bD
 5OdsSBg/x8Em5EoTBZyXjEBZ2E9e6FQfIeFs/8TFGdsZs9bABelVioMTVAw8k6qtI3Pvs8hkF+u
 +lgubCv6nAg80h7jbyf73ScVaQ/q8A7eoDKvlwq0AWIjpCr+qUExs7+xoYiWDiEn6xwKnBu8MVh
 fKyARguMKFEU5frQbxbblhR5ZEZiTj4lCfHourTERhuUCcLcZhsYpoHjJvlUJUi+Z5ca2jkmtQv
 f0qsdex4TvgJzEF2NEaHT4FGMDkywzg6MTIzEFOTVmB+/LVcA77yPvXH7IlaNSM+rI5k5Cs/Ed7
 /hkF7GUMKFLVY+hCE6Owk4FqZF5P1H5FQOWL1zOyU/h6clHjiV+CZAuv5Hva7D33XDc/5Vi5FkJ
 yiWyJbgY4OozYGA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F17516000A
X-Stat-Signature: tw6h3u5bb71fpueb464rg664916c9mry
X-HE-Tag: 1791988990-631448
X-HE-Meta: U2FsdGVkX19UsivcnP9MGnwadBqfmE4TiiwfEuzfL4TYnAOvbkcfhi4OOGyjR+rEyAWYN8nRh7k7Y+3pdvA3HC56phAeOvGCP6QJtF0EwG1iuM1AHBRFY1rm8ekKyA0fU2R1A8fDqWzli6iXROT86uXqeGMHyHImQqP3sKxvsb66tsAmXnAW0HXu6SwWB1Q2soouFZMrmOlidQRZlq69FN1jjV3mnAtXSAIT4MG8kABVvCtm3+oy7javG8D8x1pq0OtVYeyDS5rQPt3LzsUIngquotWipnpnlw1sC7eoaUDYMSi+ok/CjGkscu1eFIHC94ofF3Uaq3vkOcjJrE9qOkal2ABm741kYlZn8ONcXjjyxYJuZ7CMQU8gcG0hJJuHe4VkxAJFURvnVXpnhE+JFCNoLAH1WfsV0a2oVcGqG4C0NtHsc+un8vQmFgkVF83vyLwcpAGNc9wPL2+7mb0dvmjL1DcTAlloNkqwEHiIRnd4yCQPxN/IPfDAMf1EprIn4LdLNmQmrI92AUwfz7/+MakD+v3cp0TyOCFf4ltbNr2jP1bD+bai7qbG51sWjElRpMbWYRvObi2ZkeyPtXwUW7/q+pQCBCvWj3KfOnSbpUmXHiVVeCbRkV7z/rH0uvhltoiVIT9H6c/66dAYLcOPwrGF3qbnJb5XPHd3vRpocXGvkqBCRBz1lrqx0+v9bdgPJtWjzmdUy6l0cFzxj6cXNbZdKPD9UBKw4MrnBaa3L2/D9qv0wc30IEsZ/00JqAOGaRVxukV12unbbZrhTe9PE0XEYD6/pkN9CNzfMmUivxU3ZD8c74UFbI5Lw+ckjnBSPej6C8a6c8eltBKXO3xwGTpCN1OTZXJGqpIrMxiycd4nQVIFFcU+wTt3skuzwGLsW/GlDIRl/XJTz71crJUuNO/4XMF6ogfhjZ/frPqBVzz4pfstfwaAuqXUiWoIj/cSah/UJwebwYxUO82s4Ns
 Zpxvt4Ye
 Dv4iUwiKWcuASuNvwFtlA8Lo3JKHor8YBOo9/kB2Z2we3g/fCteHBmW1ILj2vWx7UMUjy926lTL9OOXS9wLJLdvViArn6xGw4AcB6rTw45m8kjscT2RiX8WAbrscS0PFq2gaUsUAXsESzBnRf8nutGrrNkOJhMQVKQO1oR7ntl2T+KVgyxhhoumqkHsEu4QNG1zU+og30O8gGEiTqE61xuxj3Rur8lLyBvbwnFoS1OkdJlBPIOFBAlEupKK6tbekVBjgYUC4uFdUbBTyYNJlz7m7Jst4E59sGGeXnkWMrJF23sKW8rKmdB5CCpuROIf/xksBZRo1EFMFHYiklrcIjNxQV/qqJ4wEdIa7xX6+v4fS92RtPpVsPdmsiI0nrCanY2r749HZTyw930zoTWoyE3E8SJVdtpavaE7/1qsvtuiqjYXuWTlTytAew5oQjg768acjPUVSxiBKDIACkN9dkzJsaa6m1ANXBzAKUuBGF+VFwmns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Where arch_needs_pgtable_deposit() is true, every huge PMD needs a
deposited page table. ppc64 in hash mode keeps the hash slot array of
the huge page in it, so vmf_insert_pfn_pmd() deposits one for each
special PMD it maps.

copy_huge_pmd() copies a special PMD into the child without a table.
The child then dereferences a NULL table:

- on the first hash fault on the PMD, in __hash_page_thp();
- on the zap at munmap() or exit, in hash__pmdp_huge_get_and_clear().

Allocate a table before taking the page table locks and deposit it
with the copy, as insert_pmd() does.

Fixes: d1503aa9ab805 ("powerpc/64s: Add support for huge pfnmaps")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fcea98f0d8865..d53db73f52676 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1961,6 +1961,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	pmd = pmdp_get_lockless(src_pmd);
 	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
 		     !is_huge_zero_pmd(pmd))) {
+		if (arch_needs_pgtable_deposit()) {
+			pgtable = pte_alloc_one(dst_mm);
+			if (unlikely(!pgtable))
+				goto out;
+		}
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
@@ -1974,6 +1979,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		if (unlikely(!pmd_present(pmd) || !pmd_special(pmd))) {
 			spin_unlock(src_ptl);
 			spin_unlock(dst_ptl);
+			if (pgtable)
+				pte_free(dst_mm, pgtable);
 			return -EAGAIN;
 		}
 		/*
@@ -1983,6 +1990,10 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		 * wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
+		if (pgtable) {
+			mm_inc_nr_ptes(dst_mm);
+			pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
+		}
 		goto set_pmd;
 	}
 

-- 
2.43.0


