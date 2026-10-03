Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB2ECA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED90F6B008A; Sat,  3 Oct 2026 12:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A076B008C; Sat,  3 Oct 2026 12:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78826B0092; Sat,  3 Oct 2026 12:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B02CD6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:12:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82E441A09ED
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:12:10 +0000 (UTC)
X-FDA: 85281806820.03.977F19C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5CF4100006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:12:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791043927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=OI0+fRFIw3ijgBrChoUFFfvqPlB92sMXLs4JNkIMiTo=;
	b=8cMvIHwLODtfOtoNjgmDLuJtcmpOp+1OqEytWOzYlg8XQH2jQZ6qeYYa2hozUgLdV5RE3F
	v3G7p32FpDzm1KUAYTL55vTTXJgiu0ftV/2PUQgOfjwKqTsyZry04HTmNMrIy/cAY5doZJ
	9eFwE/1CUd98lMoYv3IwI8YKHG6Z/z8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791043927;
	b=mDKZrEr8liH7iNZJNXEEZAfryL7ySvxehWFs4lCJvfD1B7dpn+egD6k5/AHfmGTkbk17tc
	aIjpYzw4cyPptAWSKNCSk6kRYsgmTfJBtVBagreyhZhu8lMJTBb9AivjIFILtcA2TPCarP
	IlmEwSnkbPrLBs6Yj9gwwyvlok2g+Ks=
X-UUID: 2635b57ebf4511f19a56ed5b684f684d-20261004
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c0850011-acab-4d49-82a6-41f594baa385,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:c0850011-acab-4d49-82a6-41f594baa385,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:48e50d00358a2b9b54db0b4daa3d3f58,BulkI
	D:26100400115821J6TXFL,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2635b57ebf4511f19a56ed5b684f684d-20261004
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(175.169.70.242)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 366136427; Sun, 04 Oct 2026 00:11:53 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] docs: hugetlbpage.rst: fix typo in per-node attribute description
Date: Sun,  4 Oct 2026 00:11:25 +0800
Message-Id: <20261003161125.40485-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5CF4100006
X-Stat-Signature: j3bqy1ih4gynwihyo3yeb3st98owax1t
X-HE-Tag: 1791043926-410852
X-HE-Meta: U2FsdGVkX1+g2m8Mhpxn1WojczTQ5C3MKmxchumKtSr5vZl9b1C8nLvIEuRQk4iAvE1Vpi9y8+364VwKGgPVwuiZ7fnrLfTlJFsZalQ5tpwGVmpbjeT33P1JJmHjLu0Uk/OWY1CMsG4DhJQFyaPHXb8x+IqSOM6o2nG0HA/uNooiR477vNikfb7kU8sNZ7y/arYTam1U/A87S35DxtlTgFLt+1c6+dMuoiMHR1B3dW3//lh59++7sBMfXowXw4/oO1bvVqnPpBrUztKvRr8nrPAPuevMFBOYhnreTahKb8SKkCLJyxYWmbBv2vT8TVDGRW4OFPC+SUvFdFHF4+4uQzS+0cbCgDgksxAd/fmbOoD3xrCRey7rQcV0P6+slA/B33Zm3pBBD2KkxIP3AZFrEd+zh5AVfYfodpem8bDNwjzSYiCbNKBkgonv0TY1GRNCrHXNXq5b2M+2hO8nFapReh9aGwR/oVMGoZ4f10+IpCmoYr7dRtoI9oL0IOduGpAhugEKNpQFGFQDlCcuZwVMlqpKQGS4X02LnEp/f08hrmqhV6cNB/+akrtRibybOJlPuxJarbJ8qQpn+VS5rO9qVaQuDZv06/AN30tqrSsYZ3ZdG7M2mm/e1iNf8QN4iIGmZ3m0kAQNQO4rvr8JFqx5c3xC5cRwAsXR5o/nSmkP+3Vy1f3l58ILdUGsq0t4AyjWIogVmwcjQ38fK2pAa76HMv9xj9Awo7BDMTTS7XP87EIVliu7DWEMhL9gyoSZdtd1WMxTkoVECvBwtjdmjY500bWfHjTPJseE50WxCC+ME8nmw9ce+WBkg5pePQoYmlRcIhpDU+8veJPibl5bKdy13owPiCSnk4oxvBI53K8k61fAaQUZIa7wSugcef8m+r2l+FCdsGNBkDv+4DqVXYIDDmfDZx9XWyfNmmPACuYQ/yOKrXfxtr8xyIOTvwjULig5QT/qCzlKxn5ybOWhjbH
 ytE9I3nD
 vbee8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-node hugepages section writes the free_hugepages and
surplus_hugepages file names with stray trailing quotes.  Quote the real
names as inline literals instead.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 Documentation/admin-guide/mm/hugetlbpage.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 3cc15d800be1..2075f1f14a42 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -373,9 +373,9 @@ contains the following attribute files::
 	free_hugepages
 	surplus_hugepages
 
-The free\_' and surplus\_' attribute files are read-only.  They return the number
-of free and surplus [overcommitted] huge pages, respectively, on the parent
-node.
+The ``free_hugepages`` and ``surplus_hugepages`` attribute files are read-only.
+They return the number of free and surplus [overcommitted] huge pages,
+respectively, on the parent node.
 
 The ``nr_hugepages`` attribute returns the total number of huge pages on the
 specified node.  When this attribute is written, the number of persistent huge

base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4
-- 
2.25.1


