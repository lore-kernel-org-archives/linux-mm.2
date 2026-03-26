Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FDA106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3E06B0088; Thu, 26 Mar 2026 04:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA40E6B008C; Thu, 26 Mar 2026 04:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1E36B0092; Thu, 26 Mar 2026 04:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D1F6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:47:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77C3FC3300
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:47:58 +0000 (UTC)
X-FDA: 84587586636.26.03C10F4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf13.hostedemail.com (Postfix) with ESMTP id CEBBF2000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:47:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t29zZ0+CFWVTDPzh6ZkgOv2fn8EC/x6SV4CYAbQDX1g=;
	b=Y17ILGM1iovzp4Kl1X6ypniqRkas22+YjFg2J0UN7VV2Q8XPCIsJpIxMCse/Xvv6FBG8G6
	T/i+K/SXGhE3rBdDdkEsaBaopcPo/x4rM2duMxZqmDxGHaEq5Fc5LcOQ+CtLgA8pSr9E41
	g0GuEXpamkmNcZiSO7CralWHu+Isnr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514876; a=rsa-sha256;
	cv=none;
	b=koSbKAxN3T8mFyHTh6iY6S88BRRybzZmIO2dAGBdUCifYF01wbSK9er1C01LRBMXwjTeUx
	mKyBhYFmB9Lt/gVrdT7ff16TeWvF1u5UQA0uFG05f3VPEDU1bl6NDWD+G5m8kF+TcUq1/A
	9CWCG3p8aFmhAZmEfOFNLlBlL7bRLiI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 76984d7428f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:ac3d01b6-d467-41da-9f74-c97c3814fbc7,IP:10,
	URL:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:ac3d01b6-d467-41da-9f74-c97c3814fbc7,IP:10,UR
	L:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:b6e80ca71f32462317a8f56fd2a8ad87,BulkI
	D:260323190756G9L0BELF,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1,File:nil,
	RT:nil,Bulk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DK
	P:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 76984d7428f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 467466726; Thu, 26 Mar 2026 16:47:47 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 1/7] mm/memfd: use folio_nr_pages() for shmem inode accounting
Date: Thu, 26 Mar 2026 16:47:21 +0800
Message-Id: <20260326084727.118437-2-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CEBBF2000D
X-Stat-Signature: 5y97mipirmw7q3488oh44cb9nktcwp35
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774514875-487219
X-HE-Meta: U2FsdGVkX1+371ZeuZTMAKKJgUEED9eQN4QXOZ97KIZN+daD2EFEWeCggft7hV3ik/fTRr7EWvrXJhjvrHHi+49nslhGsOljyf034a/AbSAnCbnuUz3bzsuOccaK6ImbTOwHVpGApfRkXB3ZAbsGU7C7DQds1aSxVqsAl98f9N3fk6c3kZkMIItKlYgFTNiAlq79GRn7BoIE0OgZaL8RjDXBXSz9rGBZpBTN+4ZFEaZhJW25Y7OGc71/t7O0tR6sBSaAQAFT4hnWyq/iJQda3/YXxr0wNgnrjxjez7jMMBj0/Yflj/C1KqXMQX6mlS9iPH2dgKyyheImIkwYQDgJlHuBP+I1PaOX5aOPXu/swCaWi03sercd3uzYyxF0Oa0pk6c/obvPq0oQ4rRs1dXxmrmekWzB0pUL/1Dpq0fbPpu7g8Vpj8KDgGI3CT/MbATVb0iK3DSWlZatmn6cr3uuqI/VEvYfm9IsDw/Dj9HQBZe4+uXN1wdVFT5WV6x6LDxLOLF52rKy+egxx9HoFXXmRVLyYK1he3PJJFtS+CJDKmaCkzw/6ms6vT4a2l7r595tn3zUJblF82tc0VyRdjatV16QsRzHDG5sVe0kY+i0jgjW5h1xHh/yrsdq+X0helETlzMeZ1uyUR9ChwjFqgfpiEDedfk6IiwvkBGRLXKd5sus1La+fpIQKzMqqEcJDQWb6OWLhOIEgsuhzWbg7loS2+6R9JDQLvEnXYxhTudUDX/YjUpfAI1VPg81UU4X72bBoeeRzQf77E3BzQcDtS5vbQSpPVCFYYZkGWxIaj10TCwAokszECaVKXjmPFgBrV17jknQ8VicRLL3RhaApi2ZLja/QnsDs4wB/y4PyEoPx+e1QVhCtn7uBnkAHCajjKWkBssvLXq24ag4xQ+bwIJKvxH8hN67vL6xVjb4mNNPojR1TV1oFjSlEjnwV7jlVFjcqxS92t6dSVrqFYFCff8
 RkdwHNyS
 wXmIXxVlmEeCRkO+pi+cRk/w9prsmTXgkXWwYMlWLLgCrlp6Nfg754TMyYCKl1QBnBZPVwfva1mQSc6sLK7GR0NfA+zQyLBhONwNx2s4ucvrun0JL9j+mBmaqXoUy4e9jipZe8I/OmaoFg3BXiV23ZnGVMylCeQD/IpYpQF/Ay4J+2BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
shmem_recalc_inode() with hardcoded 1 instead of the actual folio
page count.  memfd may use large folios (THP/hugepages), causing
quota/limit under-accounting and incorrect stat output.

Fix by using folio_nr_pages(folio) for both functions.

Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..953440994ad2 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -395,6 +395,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
+	long npages;
 	int err = -EIO;
 	long i;
 
@@ -441,14 +442,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (flags & MEMFD_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
-		err = shmem_inode_acct_blocks(inode, 1);
+		npages = folio_nr_pages(folio);
+		err = shmem_inode_acct_blocks(inode, npages);
 		if (err) {
-			pr_err("shmem: failed to account folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
+			       i, npages, err);
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		shmem_recalc_inode(inode, npages, 0);
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.25.1


