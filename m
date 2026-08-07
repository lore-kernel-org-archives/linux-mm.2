Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55261C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E4A6B0092; Fri,  7 Aug 2026 03:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDD56B0093; Fri,  7 Aug 2026 03:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BA86B0095; Fri,  7 Aug 2026 03:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4464C6B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:51:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B179BC014F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:50 +0000 (UTC)
X-FDA: 85073704380.12.F0B5AE8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDDDE100002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:51:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786089107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ju9jVDtUROVT4vprabE7GarFhrUjpoWcikAa8ZbwGRo=;
	b=0MHEZt5naHUNXysrQxYQ+XCTPdJcuG928TBUZgYPvwktvYw/j/LRz2cXN9XKmId2qiFym7
	rQKW2vJHlZ8d+9s7oGYk0WbKxFgFm2Rk5/dl0agOPTc/IqKSGYBwYGrmp7VQ+LGPAc9gJg
	9bnJtGscBI70WVmlPQeWV4KBA3cEDWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786089107;
	b=qzMxSOEKz1AvE4Ee+nx5JogoTtVvSQ6Lyti2JNHF1o9ad/4ZTeHEfIzCgqDAU4F89mdSMy
	g1xBcsjcjVTsaEeye1VRz27RZMEk9m0Cbx1vJDiajvFi/dbVrhxul6iBQ8hIHoDVqQ7igV
	bzdpgc6C2rGM+qqFL4k85f6fGDRtZpA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: d0fce1aa923411f1aa26b74ffac11d73-20260807
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9cbef195-252b-4aa5-8b05-af006c4c3798,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:9cbef195-252b-4aa5-8b05-af006c4c3798,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:c8296ac799a20adaa64dd19fac0165fc,BulkI
	D:260807155139A72UEW7B,BulkQuantity:0,Recheck:0,SF:10|38|66|78|81|82|102|1
	27|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,
	DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d0fce1aa923411f1aa26b74ffac11d73-20260807
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.104.44.99)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 303652395; Fri, 07 Aug 2026 15:51:36 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v1 2/2] kho: unwind restored pages on kho_restore_vmalloc error
Date: Fri,  7 Aug 2026 15:51:28 +0800
Message-Id: <20260807075128.542806-3-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260807075128.542806-1-duanchenghao@kylinos.cn>
References: <20260807075128.542806-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDDDE100002
X-Rspam-User: 
X-Stat-Signature: 9rsz931qxu58woxq4yjfd3aucrhaorur
X-HE-Tag: 1786089106-219849
X-HE-Meta: U2FsdGVkX1/cwfXdlCXSuVRVPMdkXbWlFUye+6Bg4Z8gbfZeUPDSFwebNea83dPwOdF6R8cguDyoSIjqZxwdJDv6dJprJ2sxA3t5h5ZGg34IL2WZCAoU/7tD397JLV8isGxv6Y6H0UehkL76es7hikx7i3Hrh1Z+WmvICOew18QC0abyWMeTQna4C6HFOfKi5mIndPojN4dKxSZ6QzrGwMazPs64k7SAPJRmYXO1+m4Jw9fSiXcwl6fDBOnx8g4FDjB++2nEvlVwvKGk6OZiwbPQpgRZNUHs3WBUEF1lHUrGjfyqCjr0ZrU+43zgBwWdT9odc2zxShpoCu8ccj32Ic2UbAIxkEMmKuAPFkWlG2CnI0SMO1vgF1PGd7+Zbwm5dRFdsyz1DOWjbbjzkyGa1/su2j0yzeBOhbx7XcUL8WfJVcm5KxketSBOihVSTCuCDquQnEKGZvb1C9AAye2/vLah8AphbN/X++ZrggzsSmxpmI4rvNSDSDIyN1AZBRWeCor0pjecfpCU28o5wr/GjzvzyXzwSrteHPh6Q6YYby7hKaOo7qXlNgrq0X38Zhkw9Pq+vUgeWbdEwnCDh1JKvNqD13C+6IyXT6ticN+jGjFcjN24EQ3GZ9ePxZ3DcVmJvylQuQqS7s47077McVWSnCc/GCsutY4p9c7F6xw9g3lUopft25du+8i2NzV+QnTTsfGrXHgyzXFTwRRnW4IHAmjBkrqUU4ZK+9ZHCLcltQi3FojDTgdBsB7eBQ1q1Ja9QmsC50JDbPocxGKH6bk2mAUiO/aJcjwL6EgkfoYo4MYsJr6exVjBVYErrAIbkb2McnJZppMV2njYFEU87py2U/v786VZ9UBWyyCA6iQl+E/87cAtsxSZi7Jb1dCiBHqXdbYmIegivxWK0f8Yh61lfBG1nEflxZDSWDWfy1eJkjRJo6mbyyjKE+PiOaVYz/JChOUgHfMVH6OB0utZR4K
 UCxYtBKa
 qVuA97L/mHYWdkCp5MGXUzncxMz60kDzCNRaCorCW6XVjjQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In kho_restore_vmalloc(), when kho_restore_pages() succeeds, the
recovered pages are handed to the buddy allocator (via
adjust_managed_page_count()). If any later step (e.g.
__get_vm_area_node() or vmap_pages_range()) fails, the original error
path only called kvfree(pages), leaking those folio pages.

Fix by tracking how many folio groups have been restored with
restored_idx. On any failure, use err_unwind_restored to walk
restored_idx backwards and return each folio group to the buddy via
__free_pages() before freeing the pages array.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ba03ff5baa9e..ed35405f59ab 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1161,6 +1161,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	struct vm_struct *area;
 	struct page **pages;
 	unsigned int idx = 0;
+	unsigned int restored_idx = 0;
 	int err;
 
 	vm_flags = kho_flags_to_vmalloc(preservation->flags);
@@ -1183,11 +1184,11 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 			phys_addr_t phys = chunk->phys[i];
 
 			if (idx + contig_pages > total_pages)
-				goto err_free_pages_array;
+				goto err_unwind_restored;
 
 			page = kho_restore_pages(phys, contig_pages);
 			if (!page)
-				goto err_free_pages_array;
+				goto err_unwind_restored;
 
 			for (int j = 0; j < contig_pages; j++)
 				pages[idx++] = page + j;
@@ -1195,13 +1196,14 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 
 		page = kho_restore_pages(virt_to_phys(chunk), 1);
 		if (!page)
-			goto err_free_pages_array;
+			goto err_unwind_restored;
+		restored_idx = idx;
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		__free_page(page);
 	}
 
 	if (idx != total_pages)
-		goto err_free_pages_array;
+		goto err_unwind_restored;
 
 	area = __get_vm_area_node(total_pages * PAGE_SIZE, align, shift,
 				  vm_flags | VM_UNINITIALIZED,
@@ -1209,7 +1211,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 				  NUMA_NO_NODE, GFP_KERNEL,
 				  __builtin_return_address(0));
 	if (!area)
-		goto err_free_pages_array;
+		goto err_unwind_restored;
 
 	addr = (unsigned long)area->addr;
 	size = get_vm_area_size(area);
@@ -1231,7 +1233,16 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 
 err_free_vm_area:
 	free_vm_area(area);
-err_free_pages_array:
+err_unwind_restored:
+	/*
+	 * Pages already restored via kho_restore_pages() have been given to
+	 * the buddy allocator (via adjust_managed_page_count()). Return them
+	 * to the buddy so that failure leaves the system in a clean state.
+	 */
+	while (restored_idx > 0) {
+		restored_idx -= contig_pages;
+		__free_pages(pages[restored_idx], order);
+	}
 	kvfree(pages);
 	return NULL;
 }
-- 
2.25.1


