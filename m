Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29466C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03346B009B; Wed, 12 Aug 2026 03:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3E76B00A0; Wed, 12 Aug 2026 03:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2766B00A1; Wed, 12 Aug 2026 03:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A54C06B009B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:58:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E893A033E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:58:22 +0000 (UTC)
X-FDA: 85091864844.16.0C234B6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id ACF6C40003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:58:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=24YW1ZfVmi/vz7AXS5RLZIdCqVNVbRagA5XBU0A3WUE=;
	b=u3MrYyIPHkr7AeXD2F6Tmmt4sLhOSQ+KfiY2QtpxQVMrBh+MFlyDKz9+iV7kKlf28qocPE
	wLj7zCSPaTeLx6tpcnsPfnnMfu50UC4OpeRsFAroSWYPKtqPYZL1jXqtpHZibU5sS41k9g
	j9WV5YJ/aExkbObXedC9HD3MR6OUi64=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521500;
	b=W1x65GVY70eyFNPiLI12PhlCOPslKsX0869uoCMug6OPTQfd6Wmw3B7+sJbml8HWRGbIVm
	ahl6klS9AJYTDcOZzuoSH4LD8yRSQBoaSHSqgmL5boQgq1MWd3qoNenXGhOq5ZO6XhUxmy
	16weqY/7ygsOpVLWQx6PCukN0eYmXU4=
X-UUID: 8cb4bc1e962311f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:98550444-a8cf-41c7-9a51-41e1804f628e,IP:10,
	URL:0,TC:0,Content:79,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:114
X-CID-INFO: VERSION:1.3.12,REQID:98550444-a8cf-41c7-9a51-41e1804f628e,IP:10,UR
	L:0,TC:0,Content:79,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:114
X-CID-META: VersionHash:e7bac3a,CLOUDID:5ea0803e3a002edfdd0c980c06caa678,BulkI
	D:260812155809WZRDJEWO,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|127|865|
	898,TC:nil,Content:3|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_ASC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8cb4bc1e962311f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1497932409; Wed, 12 Aug 2026 15:58:05 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] Docs/mm: fix outdated "radix tree" in page_migration
Date: Wed, 12 Aug 2026 15:57:39 +0800
Message-ID: <20260812075739.325441-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACF6C40003
X-Stat-Signature: ga6kyx4gicetnwhdbgty7hciwgq9p7tg
X-Rspam-User: 
X-HE-Tag: 1786521497-982886
X-HE-Meta: U2FsdGVkX1+ui7MkiOYqWiDJ4qv1fMQHB2d72Iv3a/t5ye4LP/UxpjGeNzteeH4KeaWNDhklzKtehRpHbxyNVNnOf5GLK5JytEXdBM9wR/ra07fGLKQU5W89qG7zm0UkCs70sf9+ebM7X8w82keNZ0z1P7LM3WPXBiN/MP8d9AfWtblw2Gd/MXfewi0+fIAPfjY/t2MxBD5mht5myG62bSpRskXQV8VZf4SNipGw0XjFa3DPwtqY8ouACl1zywrucx0kuFvLMADochK2tPrNqv7w0jDwANeTsON1/wqVxiAXxErqkj95d/aS3tky4b2M8cvdJhHQoirZWB6fN//gblvgtVVCfH0ZcSRIxtbH87ptKqSBMyLh17Ka0j7iJgqC3CJSBOjSwQz25S9CsLoBs7ljDgPSTIW3P1x0WZj0WoTbusKEUzJMqbi2qkDAVk9weky/W8a3Xb+67I/+dDzr8CGID7bctZ+JF0Xu0mDBXVkN1MyYK87Hl+8Ev7oPbVfQ9fW4n8lA9qkiPF9X4d8nsUCLGDhYyxxwxl/sXeXyJTPHFTQpux0XJUhJNnTiC4/ysyVgHS28DRqCYzS9AoHMNO7CollQDnjibRT9i6T1l+KnOD83CxvOJMo/uDJuYTeKSLaA7MqnwPPgVSYDPoiHQIcDAK3BGVfD/zCUuR50pS4EIe0PvLBWQd0hutmQXOIkgQt870uPsogMg7kWlNIIT8qSHATjyPLv8lZJPe2tzvd36k98zrqNlgDptNrQdpd0JmZWbV/eiUuuHgqBT87aQHeDUzn3DFSBRtZQRchLm8Sz2X5/4sWokSrxyT/6gJQ/EozOS4q7InF46oBFvBDQt93Boe+h1xa1f/TxZTyHYFgijhJcHGUV4iR/3GQ77qijq3dbEzSqnhw+2+JpkiW/tNHcjpjQDZXcQfLJhjZ5x5uOCZLQlyZOsiY+8vkLLEdp+Sfpy3N9qxns2sEtMdd
 ckqkxUDV
 XG2OGJ9e/bKRejR22nbVOT3EYkU2NoIrJIhHQ2ZJUWosmvMFv+309bBFIWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Steps 7 and 9 of the migration description still say "radix tree",
unlike steps 5 and 11 which already use "i_pages lock".  The page cache
moved to the XArray at mapping->i_pages long ago.  Use "page cache tree"
for the two remaining references.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/mm/page_migration.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/mm/page_migration.rst b/Documentation/mm/page_migration.rst
index 34602b254aa6..5b8d50308db1 100644
--- a/Documentation/mm/page_migration.rst
+++ b/Documentation/mm/page_migration.rst
@@ -110,13 +110,13 @@ Steps:
 6. The refcount of the page is examined and we back out if references remain.
    Otherwise, we know that we are the only one referencing this page.
 
-7. The radix tree is checked and if it does not contain the pointer to this
-   page then we back out because someone else modified the radix tree.
+7. The page cache tree is checked and if it does not contain the pointer to this
+   page then we back out because someone else modified the page cache tree.
 
 8. The new page is prepped with some settings from the old page so that
    accesses to the new page will discover a page with the correct settings.
 
-9. The radix tree is changed to point to the new page.
+9. The page cache tree is changed to point to the new page.
 
 10. The reference count of the old page is dropped because the address space
     reference is gone. A reference to the new page is established because
-- 
2.43.0


