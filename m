Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84F4CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DA5B8E0028; Thu, 23 Oct 2025 21:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28ADF8E0002; Thu, 23 Oct 2025 21:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF2F8E0028; Thu, 23 Oct 2025 21:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 104958E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:31:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2135BE130
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:31:48 +0000 (UTC)
X-FDA: 84031281096.04.B3A9CA9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8DCC180006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:31:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761269507; a=rsa-sha256;
	cv=none;
	b=1kfQCdlDmnZxR7ocpfipdoVhGjJw0tr3Lob2B+TACG7I7zX4MC9dwtWeNHl/tAZ1Q7U8QP
	4d4w1AkEbyRZVhocuBr6mspCZZQuvakwr5nBZHnqHtsLnlef5rVwPsyepZviES79Mdnojq
	gLbV1UdI20qZaZ1+J3mFabhKpXVZ9wQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761269507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=c0RGYubxa9GGm9GndIrf+6s8j4wrQtJUmM8pUN71RDY=;
	b=QOL8cffiH/o3Vl2wBu6g7H27Pbvzbn6vvL53XTJ+AzPs87WuKXCBZHvFqM5FgBxoHYCPqg
	2vzi4coSmX4b9l+3oRJ7BJI3vlDYjNrCr4VTsPHuKHdelXT28MQTzKWPKw+cOtsupRoEo6
	Y63Kg5mrnGvPaN8cvljFqNS7+ns7nkQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B20EE1CDD;
	Thu, 23 Oct 2025 18:31:37 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A7FD03F66E;
	Thu, 23 Oct 2025 18:31:43 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH V3] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma() tests
Date: Fri, 24 Oct 2025 02:31:37 +0100
Message-Id: <20251024013137.136926-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ebn8wauyuujirk417ufmdgy1mihquw9y
X-Rspamd-Queue-Id: B8DCC180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761269506-148068
X-HE-Meta: U2FsdGVkX1/In9d2ZLqsgGsIEDlt0kaE/TSFUNSeQq62Zlz6TpaReKfxQ0WgxIuxf5gxtg4p6X7HN0aL5LlYRhpDD9g5jWr93CWxhN9VLr/46piT61sxaM5SHyyOD54yS3rzMfGnjsctvZBgGX9e5xXJBPcGwbifjAPJRS0lRGZ+EsOYe1K/T4C/ShXufT8Wjtjl+X8HhQRP7CUO92oy2PoBNP1lpqAUsXWei1G24fhvyCz5NfaGQbAVsn6f5EQRpLJC7P1NhNUPtTQ5SyfLBKPciHmBZWqzKVqp1bZknWNKeE9cXyEF5bVK/y/cBmC8kD0mgpI3Sg/mIjKC/RaZmObnYl7CCig9yCeWVPmBRUBA/5Hzdc3kXBCelMdC6muhZhmldoGepTToUFUc1RsGF1vE9VJDK5KEupA01p/i2kTRv3U7Xiw2pCNN7zyFp0rm4iFbBHsD43srWS0wfvANrwkvao/RZ9ftdWYGa0HjyCo0M2yOO4HDp8MAVNn/oTI1YyNFZw0rDMnA7LPP7QbeguZISQWUfvYncP6taKT0JJwBuNqnDpSoD6Nl8akFDbS53QwB5wp384CIv6JNK5VaYVuJxuOO4xg/9GJyrRVKMP/eRV2cLQuy9TMdc5MaPDAHBEeLfhvK1hyo+LyrQHPloEaFaIPhXb09niX+wA6C4cSYBjQ7IZfXPFrKZnuEiNCg+dxuqjvu/JRK7oOiJzjZRkni5ZleEEhszdFmbA++zoSIaBRVTOFBPFn9A50BNHZKS7XpEl2i8utikuWsIXmFWirXAAlLnn2LwX5IcVrjLQwJya/JdBZjjWBjAHHKZzBlIhp+KrBgRoW+NMOQTGpMeElF15VqZ7HjEPd16J/s/x2LkGX58ojYZAj2C6v7/3tubnQ61tsDXn7cs6eY8u6vfqzc+uY0McEdCOb3Z1eb6BRopmDWQBn+Sa2Le8DkZI5wKTRkI8YeUPgxin2SXym
 Twq2z/zg
 UuBdpT5uIHUUIt8KHh6fMn6jrf03lLASpN1pP+zctK/TNp+6lKonJaRP/EVl5IqXvovE4uwk/3omttAOhygR5pNNG4Oe2Xcfr574l9Fbm00rCO96Y5FVrBHVLoD80Gu8ihozy0fZQneY5cZX3trISqdtfK4CjGiVFeU2pXiNiFt8/YRK2IbSRI+BMviaJc8oGTd7Q6mlC4AOH3Fqo2sghzvX9/bDgMosGNExjLjUZUoWqSv4ydt/dKqmx0EU2uFEH//JQZG3Xh9ukYX/h87cQvWIpqDmnguDs5ZCKLnyz03M6f3N7ntKr4Ox+j8+Lhq+8Y7jHUQ2EunV/aqX8vfsnvCUVyNd/LbZX68ialCZCSc28Tl9Jc9ls27JdIFY4oPIHD/W8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some [pte|pmd]_mkwrite_novma() relevant tests.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
These tests clear on arm64 platform after the following recent patch.

https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/

Changes in V3:

- Added a new test combination per Huang

Changes in V2:

https://lore.kernel.org/all/20251022032951.3498553-1-anshuman.khandual@arm.com/

- Added a new test combination per Huang

Changes in V1:

https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/

 mm/debug_vm_pgtable.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..133543ca2821 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
 	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
 	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
+	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }
 
 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +201,13 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
 	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
 	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+	WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pmd))));
+	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
+	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
+	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
+
 	/*
 	 * A huge page does not point to next level page table
 	 * entry. Hence this must qualify as pmd_bad().
-- 
2.30.2


