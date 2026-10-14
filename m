Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDFECC6B1C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7356B008C; Tue, 13 Oct 2026 23:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FF06B0092; Tue, 13 Oct 2026 23:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207F56B0095; Tue, 13 Oct 2026 23:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAA4A6B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:12:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EB8FC03FD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:12:31 +0000 (UTC)
X-FDA: 85319758902.13.396F4B6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7096A0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:12:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947549;
	b=vmP+XNYwNWJClCpdnxAlWVr84TWFpGZ0JlAAMqDaD3OwwLJIEfqBWwafkY28BVNbicoHr5
	XlTDU2dcxEVJCcSnhdjJR+5rz9tbQqig7GlJUf9bLSlvZ24WItErs0VeY0/w6cAYi4bEB9
	UT7Mp8xDGocwCVjRv6nAk4avDzwhrO8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=UXfIfgcfrOF95OnC9feeSyzHKDnKy9tN27UxCf4ShJ8=;
	b=vRRq6mjnZuN3dCdqBod1UE7z+nVI0BFJisfss/yTkL0OiHu86kUY7bwoENV8m9AslDkOxr
	kVXLxO7mshz5Z9pf2u6tEhFw3sB/CtliSpcLa7vtpixngXK/cxsOPInRjT+4lH4jqvUU5C
	Do2f2hYtsp7F2vp0hWhrrDdEoZ9dwaI=
X-UUID: 0fba4eb4c77d11f19a56ed5b684f684d-20261014
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:97ab1839-384d-411b-9dc0-cbbdd7caf0d0,IP:20,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-INFO: VERSION:1.3.19,REQID:97ab1839-384d-411b-9dc0-cbbdd7caf0d0,IP:20,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:028dd0a8dfa5bfd4bf76735ad2391b0a,BulkI
	D:261014111220RQQ3BE1K,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:1|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0fba4eb4c77d11f19a56ed5b684f684d-20261014
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1476125836; Wed, 14 Oct 2026 11:12:17 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb: use sizeof(buf) in string_get_size() calls
Date: Wed, 14 Oct 2026 11:11:47 +0800
Message-ID: <20261014031147.444733-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7096A0005
X-Stat-Signature: i4coaqahsspedquae39fgn8fzjgxebn4
X-HE-Tag: 1791947547-696741
X-HE-Meta: U2FsdGVkX1/8DvJR5mVFbyUd1RfHuQ/YQNN3RuwL8UzGeBbytTzR5RqGlEPMy3nyRmebONaGMHQHVDlpoMeR36n/2oVrcMv0Dzp16bqUa3slllEImfopQmIZ+hYGfF77UdKAFdnAA7BWx0RBIhwxXrVbBbVRfDw0AoEOEAJoJygO9l7QXNWd6JLdx9BQZapL++QmfHgVe7IFS2oZeJUgS7oGpkr7nzabKOcMFHh1Vs7KaSIh00fdY3bUrN3iYkFSEXuEYP702gU4uBAZEkaqmkurXLry0iHDyKBYa1+Tt9Xz05aOIP8v6fXc6f/XxSpW2ahEXRZYhakzDTLHGzdHTn7vAn1TcRpmlDVVfoooR4phhcZncGUlwmLP3QsWCH9wsUUQ6Wr7sikiK8Bbv5v0GPRM6LcJ00y0xDeMeOJ6Sf1LlgN3N9Aaas42ap+EEMUfev4Cy1BRplywAvQTEdfz2ESGwN+CsTz9Q4qSn/jHTggF2OnKhbTOB5+hKZjKyrPGtpY8F68cln6tAgACGcGlERKR3lWlgCpoCBsJ9uatbdkkgGQ3nIAEX+SqzyV1ef7tAiANGBv69i4ZsEm/8my0j6ErQ4QZNPhn7Bgfju2s2O1SritRil6jFcPFaNgFpgnDlWVXkU8GgNW3jLg4PIDxIRuuZOjoC1VFEXV6/tigQKncB/ChbROjXwkC24ArPrD5DIG9b8EedMsL+QZtruGF/65ddKN3GUsjRWNrUXOJg5Si/8O0x02mGcO2YqZqw1RtAc40l5hrFl0cvD4YEpUeXCheUhJ4nVIBrfbAioI4IHl5FGLwF7qvcSKFaHQouoDXSX6O9MydaY++dam5vRD1z/TlgU5szDIaAlFTm2IwvcIYYc5KZ4Kij9+vP7q8z8+8vUiaosDYN7/N1s383JWd5xKt7nRjv/o4m/+ctGFHTToU1hs5v9zRylzBjVDTWhqh0kcGTd5ePw+GvXT80zJ
 9jNt3Oyv
 +uJMet5rZdET0PjhivgIs+4LmULS6dRmDq27cOXpNqH8iyiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the hardcoded 32 with sizeof(buf) at the remaining four call sites,
for consistency with the rest of the file.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 63dc836061c9..1e79dc5b9587 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3466,7 +3466,7 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 	if (i == h->max_huge_pages_node[nid])
 		return;
 
-	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+	string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 	pr_warn("allocating %u of page size %s failed node%d.  Only allocated %lu hugepages.\n",
 		h->max_huge_pages_node[nid], buf, nid, i);
 	h->max_huge_pages -= (h->max_huge_pages_node[nid] - i);
@@ -3493,7 +3493,7 @@ static void __init hugetlb_hstate_alloc_pages_errcheck(unsigned long allocated,
 	if (allocated < h->max_huge_pages) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_warn("allocating %lu of page size %s failed.  Only allocated %lu hugepages.\n",
 			h->max_huge_pages, buf, allocated);
 		h->max_huge_pages = allocated;
@@ -3704,7 +3704,7 @@ static void __init report_hugepages(void)
 	for_each_hstate(h) {
 		char buf[32];
 
-		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, 32);
+		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
 		pr_info("%d KiB vmemmap can be freed for a %s page\n",
@@ -4216,7 +4216,7 @@ static int __init hugetlb_init(void)
 				char buf[32];
 
 				string_get_size(huge_page_size(&default_hstate),
-					1, STRING_UNITS_2, buf, 32);
+					1, STRING_UNITS_2, buf, sizeof(buf));
 				pr_warn("Ignoring hugepages=%lu associated with %s page size\n",
 					default_hstate.max_huge_pages, buf);
 				pr_warn("Using hugepages=%lu for number of default huge pages\n",

base-commit: ad9f2d463666c64e94b04be5263c9bf8f9f96fb7
-- 
2.56.0


