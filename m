Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1019FCD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A9C6B0096; Tue,  9 Jun 2026 07:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612136B0098; Tue,  9 Jun 2026 07:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F116B0099; Tue,  9 Jun 2026 07:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 461BF6B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:46:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F4088F0AA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:05 +0000 (UTC)
X-FDA: 84860195490.02.65092D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 085D9140004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dzB0fk+o;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005563;
	b=OyfyPBXyKie7AzOVkANV42vQNW0/urnPhy5VrCyhRmFAcufNkzYgtmrrLMdsi6dlgumUpu
	1ipltmHymlKv6wRR8CTbrEcmrIV2PvUEc9ceU4VXJD4QpOvYy53k4WPP5u8dbPswN8Obfl
	xUYVIkzQWjkj+OTl0GKC6C9g+JkYDJQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dzB0fk+o;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSdj657fa4gXpzsbJKokHpr6K4JuaFM31TDRG7+aFWU=;
	b=sjLeM6tmdASIt/bZK3FXVmrniBLtEkfcFhXtwBIsGQyt8UoUvkoGUMRWunp+plOFsx0EJV
	EtQtdac1syc/Hqo3XBKMIpAEVqZUOp4aclWZvtAWF6RlRSOCA7GrmK8WEfbC2Q9PpXtyfL
	YS575Bbz4SoIkWy2bfEPwv1ce76v4BM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781005562;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WSdj657fa4gXpzsbJKokHpr6K4JuaFM31TDRG7+aFWU=;
	b=dzB0fk+oHyVaDZ3CLiPFK4efKJ+B1zez2llocfFhZ/ZyzYKrqa8Bzdx/iPFLuBcAB+os2L
	mgg6RPN7RrYkjVzHM4t50s3MP6M1pmRNP0KIgKhvAiukSK8oybuzOR7WS2vArISJLm6UW7
	L3KIToJv5rzbfNr4OSv8DhQWujyk/iY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-JFUwVjzMOx6eHBee42jbWA-1; Tue,
 09 Jun 2026 07:46:01 -0400
X-MC-Unique: JFUwVjzMOx6eHBee42jbWA-1
X-Mimecast-MFC-AGG-ID: JFUwVjzMOx6eHBee42jbWA_1781005558
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93CDA19560BB;
	Tue,  9 Jun 2026 11:45:57 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8124A1955DC9;
	Tue,  9 Jun 2026 11:45:48 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>
Cc: aarcange@redhat.com,
	Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH mm-unstable v1 1/3] mm/ksm: export ksm_is_running() to check KSM merge state
Date: Tue,  9 Jun 2026 05:46:13 -0600
Message-ID: <20260609114619.144416-2-npache@redhat.com>
In-Reply-To: <20260609114619.144416-1-npache@redhat.com>
References: <20260609114619.144416-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: kFsPI0qdN5Tw_wR-wZnWo-soqJs876qBCkFIkQzAQGc_1781005558
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 085D9140004
X-Stat-Signature: gzxyin3y3rrwwqaqndjgjhfdedkfzfzb
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781005562-260723
X-HE-Meta: U2FsdGVkX1/wM0IJqq8PE55REGoOZh0XhxgPSqz6v/c4HBv9910v9GLV14OhvdELn2yYVcOI2zlHFxw5NZWTDZhHLsAO9CL7TEkVS0QfbM2evktXPcUO8/2lhWFaiTiZiPEay88DWGxtWpLVtxZCTrcsOBY9BZIE/Z1ZnRNkMbbv5JXYInhc+ytBqAAQ+1FEptEO0iLTUZuBjvyDmw72rvmnYUyGLaExyXzZ4yv+yJH++LJZAcsJ6XIHd+NoFD+i5GiBugaxFAuw4xY37aDXcaUcchnH968eUFoXBSulP40N2JLitfWz2U6aAl5bYAS+ZHSAuq0HLvU5fVxYTkewudmZMf2RXWU4ds6f/dYfmIJcfV4BasjgEIdaCFiYYFQVkk4+XiI6JFWhmrqRLnD8M5va/lC++vqu71QBmtrHReiDLTWqHcSVgTdM4L5HpCAgWaxmfTu6tAoECoeTN3NIvofo7xi/gd1MGtzTP6v1oE2GPXU3piDzM7PqBESqpeoPCmMUf7mbDbuxVxFhIiic9juteWHAGc19F3fzs7H1qSDzFrpCs3uMOnGYLaCf2ssLDVz7KSJA/pgZCO++MVNNMk3OmB699qAOS+2lQlmlIX6IZbimE7zDZThkQrMn27zbFGVjsiiRy9GrUn7wCneuqG6VEbhbdkV8oKtFawr0dyitu1jg5/GgJx/EFEKN85eNsfpiSBHCXlQntp6jq/G2TB0rCotYC055atpa1V9FnM9DqW9rd0URg3gOd+OtCkgNQc8tFf9cQn+HQTwzCpm5qD0YBVIjzuJ5FOsze3ORA3TpHwqUcd9kyTe2TlTs6BRGzRQsVscK/b/nTR6QRCbuZ6em+WD739iN3o1gQKXE2fBGx8yBfnAbSaAyU7Rg2qw37cohiCyBG798Z99kZ0J7fX91VItAT/MP9/4E1vKWg0l+48JZ7iIRsUuftbc3SaxyKengG05Ci/elb6QNWI/
 DMGc5H59
 0q+bfuqgKxK/00d3Px53J8L54c1OtT8c45OS8t9B7rKg+IcTv+2tIJxCRAPGP9lW/Tn1z9eUizLiCnXz2Q12qncpoGEBGEVj/9OU20KMUbM7TREYL3xjDirvUayvotFj/5FBFSKSimzcv7Z6/FWWGx/KlUNhFlR+u8CYvYjweacsH2MSZz2MdleogatFHCm4sHJlSnCDPk2RUbnb5VYYhACxXmps5B7oWDxfWDFbVgXZI4y5xavnw67cCVbzBFXhX+PehWA1oR9avDtMHmertNMjdfqkRDYE4Dnfia41s5pbTtOYtKYKYmo8er3d2OUNzQjvQmosgaOnkuFcWiYgK8hFzBNXzThp1mhtTFhv6wkokvN45wIHtR9o3Kqkx6we3LzWAu5Ctxq1njKns47IFUn9GrOjFSxYxPznuPIqPLA5KC3vF9dnXcw4uxBj5OsEXrcO4BgPoQ+4Cqyb5etwezN2Gyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ksm_is_running() which returns true when KSM is actively merging
(ksm_run & KSM_RUN_MERGE).

This will be used by try_to_map_unused_to_zeropage() to skip zero-page
remapping in VM_MERGEABLE VMAs when KSM is active.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/ksm.h | 6 ++++++
 mm/ksm.c            | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index d39d0d5483a2..c1048b690a92 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -17,6 +17,7 @@
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, vm_flags_t *vm_flags);
+bool ksm_is_running(void);
 vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			  vma_flags_t vma_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
@@ -144,6 +145,11 @@ static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 	return 0;
 }
 
+static inline bool ksm_is_running(void)
+{
+	return false;
+}
+
 static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..edc2b961ff59 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3015,6 +3015,12 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 }
 EXPORT_SYMBOL_GPL(ksm_madvise);
 
+bool ksm_is_running(void)
+{
+	return ksm_run & KSM_RUN_MERGE;
+}
+EXPORT_SYMBOL_GPL(ksm_is_running);
+
 int __ksm_enter(struct mm_struct *mm)
 {
 	struct ksm_mm_slot *mm_slot;
-- 
2.54.0


