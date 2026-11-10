Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F417606D4D2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=HNCe1CRu
Received: by kanga.kvack.org (Postfix)
	id 22D4D6B05D7; Tue, 10 Nov 2026 06:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205136B05D8; Tue, 10 Nov 2026 06:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3E06B05D9; Tue, 10 Nov 2026 06:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8DA6B05D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:50:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C348140662
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:50:20 +0000 (UTC)
X-FDA: 85419041400.10.B7B9D0F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 826B012000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:50:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HNCe1CRu;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311419;
	b=TPzzP6hsvd+YnwH6wtp24OFlH3VBFwBiD+M2XkW2E5x3mNLBbfz3OddK97BpFiRvbpd+64
	dWpd6YtXJ7mAlvclb0fHso9wtnCKKKeyWvzQt4VkiqIi90cAnmkmMkpa9HBYMgzBx68IkR
	R6iLcStJ9aM8uHVZ5U3yDWLiqko+4q8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HNCe1CRu;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7PTjUyc3KTKqk0pH/vhoZcDfD8UpwLbbvm2vjkTKH8=;
	b=KoKbkv6gbSCvVCho3kxDTuGBqS4STSuQ4FKc1JIkM0/FZN+fD0q/04fgJDVXsKY02sf2pm
	EfaChIZISaV/nRcDCc7khHQh2+HlDWTjxPmbYn+Dsx4lZ8OkvRz7mtAfWZvLhurvUtv9rF
	s5zgQ7hrmSown3dONO1awBFd3rKhvF0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794311412; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=O7PTjUyc3KTKqk0pH/vhoZcDfD8UpwLbbvm2vjkTKH8=;
 b=HNCe1CRuEG9MNc5tpC4kvFCMx9JA7+Q26Y9Yz0jVqsnbaROSFCaEKy0MLrArFqepGZLM57
 w/j4DWZncgJrNvCDkF/bijYaTPO/cDTg6T2fupHBdw8Hm92Ci1kbaqEXKgJb9rgBFjshdF
 JE2AFivEnCTGYL9i0E0xFbX1dZPsJO69yeBKpdl5c4n7Hwi77RX6vUHMBhK8aZNdo6Pxef
 tJqEjZC2bQDt7DTuXvRwXDv92zx1/mKi6f+36HOStwNwGbY/ifoWwRP43gFM+5sruS4aFZ
 ScUTdnE0kOxAWo3+MoNDvdpWQ/BkvkFd9VggU/skt/zcIQUj85+RnTI270wvfQ==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20261110114859.76343-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
Subject: [PATCH v2 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Lms-Return-Path: <lba+26af304f3+524854+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20261110114859.76343-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Tue, 10 Nov 2026 19:48:59 +0800
Message-Id: <20261110114859.76343-3-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
X-Stat-Signature: f5g4zdrgdmqf6ebmrt1t76gxxw8tx4sr
X-Rspamd-Queue-Id: 826B012000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794311417-843362
X-HE-Meta: U2FsdGVkX18Qz0DkIKTGTtSd0XhaTanlAMZYcMqGgYYUpWIG758k48LcculadrkjmD0A9Llw9Uomr1T813soGfgKbwHsiaveOoci8WBkbHGQAqMY9UgMoMgadOJKj0sBYB7H4dc5Zqern+yzxriGFSwJ1aM6TLhVGtqoODM2QYQSRvzT3QF6aDw8/TDF9XcYjBtCeeBqyQe8TfqiiUXMSaXKMotllJrYFpLeKPDAwcId02J0B1J5gLIKik2m8Y5/zGl7O3x9U4V9cbDsAiDZ3j7PKDZTiEViOz3u45hPknJmt7RnBX2NLxmfA+CAxEn9fUPq8X0+Hus+16TikxfrsQfV0Lpoe9A528RR3way0f5H8O5TpG/SKroL6Kn42npSl7HTN10CD6rEM/WhTmpKtF9gYq/WQgmSYrpInh7rVdBKzHpnS/a9C3QSR4h8Z2IdWmT1jvJRSm7/piF83MGYY0CMeIyNRpo270jBpjAlCil4qA9W1zeuGEIP4rz+gKU5Zvd5Bq5c1HQjhTTRJtDrG4a4EAdx+Hsewrvh1XwBFBZB3cK1Hl3F+CIss4kYikhpnDSTXOGSVm3uzkWJVuamS2FfHBmc9KTe4U4Tpv6VXTPmJS/E9mGTT/088vAIfHvh06YLxYfQAIjiQteC1/jD9aDJ3Jm7aMASU4Jyc7wQe4U2sdjlq4KQtLqy+cP8KuQaDkI/rFQEyA7zGqFJ9mZ7AABlgN1etJEbaYNM3u7HGbP7pC3TZEfCoUmaDL5Whqn3jI81Z7Mv5ERIjKT1H9S60FwKPcMB45K3+KX77h8CVhstDxYgeXCMpnsM/Io2mP7sRQx/N4nAp3Em7c5EqrLhel3IaeHD52T+e+r3CgttaslGz6qj6dJIE7kWpcBgueN5krEHGfVfHnux9E+mdfxg3FAte/KBqcANY+vrYhF14ApJoLBCfpVJ02vF4tEfTstwlaAcWFA2BgRAmlRMdh8
 eTptdw2k
 ZEN/Z7wHNE9m43LAF8LfTHgODFJawO4tE/PqCB6ud8gSdMb6orj1lVm0AwCXxS/ddt1DuXKpmiaKyov72x5vdCHrcBEfuZZ55DxP3iqSq9pYf+RCrsziYkj4r1FjE9iiGInVreOsow4qfmmJxKC4oAkz99XjQJz16E/0Dectk52sQJdZjksk8JKiCTQeJLqem2pAyHUfn1tOVzX+bCJOEfzgITKBOgaWezpglR7PmJZ+DUWQT4ClRXadkryp320rdoEVQtIeUCtBFTyuQmlMyEYXb8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Boot-time HugeTLB allocation has to initialize tail struct pages itself
when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
gigantic pages, this can cover a large number of tail pages.  Most state
installed by __init_single_page() and prep_compound_tail() is identical
for every tail page in the same huge page; only PFN-dependent fields need
refreshing.

Initialize the first tail page normally, copy it into a local template,
then initialize the remaining tails from that template with
memmap_init_page_from_template().  This avoids repeatedly doing the full
__init_single_page() and prep_compound_tail() sequence for state that is
identical across tail pages in the same huge page.

On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
(HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
initialization time improved by 36.43%, measured with a temporary
jiffies-based printk modeled after the existing timing in
memmap_init_zone_device():

  base (v7.4-rc1):  318.4 ms
  with this patch:  202.4 ms

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/hugetlb.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 630c96cd1e88..3f6731161d77 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3223,6 +3223,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	enum zone_type zone = folio_zonenum(folio);
 	int nid = folio_nid(folio);
 	struct page *page = folio_page(folio, start_page_number);
+	struct page template;
 	unsigned long head_pfn = folio_pfn(folio);
 	unsigned long pfn, end_pfn = head_pfn + end_page_number;
 	unsigned int order = huge_page_order(h);
@@ -3231,11 +3232,20 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
 	 * we must initialize them ourselves here.
 	 */
-	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
-		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
-		set_page_count(page, 0);
-	}
+	pfn = head_pfn + start_page_number;
+
+	/*
+	 * Seed a template from the first real tail page and refresh only
+	 * PFN-dependent fields before copying it.
+	 */
+	__init_single_page(page, pfn, zone, nid);
+	prep_compound_tail(page, &folio->page, order);
+	set_page_count(page, 0);
+	memcpy(&template, page, sizeof(template));
+
+	for (pfn++; pfn < end_pfn; pfn++)
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
+					       &template);
 }
 
 static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
-- 
2.20.1

