Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F132FEC01CD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED7D6B008C; Mon, 23 Mar 2026 07:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5176F6B0092; Mon, 23 Mar 2026 07:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451B76B0093; Mon, 23 Mar 2026 07:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3917E6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EECDC1EC76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:05 +0000 (UTC)
X-FDA: 84577053330.21.66C4803
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B6F210001A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aNvaoDn7/bfLErU406QGGVp2m4GCteBL58V1RtULhsg=;
	b=d70GCSEBxOFdTJqK9dRsDoc6wwVm/aED3eAT7lQHUygnF0BovHLNnxgk/AoKp1X9OcSxuW
	1DQuHjqVAJ03DBE92boorFQbxm7wCcuru/SOHBAB3F/we/+75Azn+Ovy0LTzS1aJs6gwfd
	oPAmr9K2kP1ps8pK6UzntNS8sdULk8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264083; a=rsa-sha256;
	cv=none;
	b=mx/VtCbh4yFoXucWSRX0eP5zg+q1FirY8Pu8N5JCppodcxyx1t4iBO7b/JrqMcen9NnpkW
	szwdHrVRpWHRJXruBJCdg8g5Xwvj1n9SUNIimUIrEUXDOzgFN9/tY/Jc3pfRuqQDINUfil
	Dckh3T7fFyIJvqFy5m7CIXCnvZfMKWE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 8a5868e826a811f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_BLACK, ABX_EXPLOIT, ABX_HEURISTIC, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:b68932ab-a3ba-4ce3-a071-2aeac6e876f9,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.11,REQID:b68932ab-a3ba-4ce3-a071-2aeac6e876f9,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:89c9d04,CLOUDID:93544d1a49f7971dbc6d07885681169c,BulkI
	D:2603231907563I1Z8ACW,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8a5868e826a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1141883640; Mon, 23 Mar 2026 19:07:54 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 2/4] mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
Date: Mon, 23 Mar 2026 19:07:45 +0800
Message-Id: <20260323110747.193569-3-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260323110747.193569-1-duanchenghao@kylinos.cn>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B6F210001A
X-Stat-Signature: 7xbw6r64waabshyt4r1ccjmptnkwidhn
X-HE-Tag: 1774264082-603173
X-HE-Meta: U2FsdGVkX1/izUxrnkiS82MGPl3lmFr2PdDV4N32leOindY4btv8SWFwIXvs5qYO5V0npEJNw6dj6sHjtZieFspsvAObrsaj4oBQfCZs7cwbMR7zh6PO0Zj8sLdfPZeo3oU+Zs1JPMcjy9zwDOhLUXidCOJ58IvwaR0SYJ7zA9VXljEjw1JcA4LjmEYcTieEWaxGlEyV4OCWTH+jTHPtq293EaPcI+dih56bS8qAPPTwUoyYlDZ4TO6HS/X/RtzsvqHkhdJexcwktumT5BlUXjcBBIKEeHK+v+BGjyJ1ivDWkCoQE3PefZhGro3XEwhtnMyuM1UW5kZbGpMpG65OB8KaMw6Z5YGoM0yMI5zM/rW/ZZs+cIl5lAjGsRAuXxJZ0w4AH29UC0wKZNgaT7+02nUFj+niZc2vNXBkrh9szCwozes6BkD5fl8KbQkMnN7x10d8SNskxF1tB997T0jZr0werqKqT2rf1NnDki+cv+AFLi3MnqD3PQEACLPBiEPHDeHK5kOViNauzHtu2dY7N151w3QOBi2wC+rRrMNGzsovpkGn7+ErfzuZOmaOufhyVXzgg0wmvMVmQMsw6iERPwRhqDQt62WgFWWzzwa/YpbaN5f9RFdYcsR/dxTc0qjxnfAqBluCauC4UEjOK7b8KXZTm/cQRZUwRxIfiEYO3w/Hlt+gsbbT4FrKbp2YYHLsvDhlUgP2cksQDMvDVW3NLBogafp+ffxz3Ng2mBgZL9H3tp9E7+hfrSbKTp1gemHBAL+6Eo0zqzwSeLBYKSeyD/laLUwE4K8xO5yfMXAxRPpRGPk0Xef9VcP2TWLsEH+H6upQ3u4VnZTL3n6aQduZO0w7FhjSern8S3TEQJJJ6uZKH5jIYkks56F5TkjJ3ylPB/2QYzeIgf2AEXUqS3+EoGUq4Q4yPm4gedDhBTdoQdIrvFWjAu2WdAvtk3OiDr9Da+tdpQD7WRTYcK8Kx7Y
 aM+dqwOP
 jdV6BoKchslS68Iw452XckU1Ev1BXFewa0DVqgmBTlsOQJ0cyW5yyNU8Ve7IxnAuoF4vHTJOMRs+1YatRDMA5d6sjhq3sJ7AN9BOg4M1onWXD/g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
to improve performance when restoring large memfds.

Currently, shmem_recalc_inode() is called for each folio during restore,
which is O(n) expensive operations. This patch collects the number of
successfully added folios and calls shmem_recalc_inode() once after the
loop completes, reducing complexity to O(1).

Additionally, fix the error path to also call shmem_recalc_inode() for
the folios that were successfully added before the error occurred.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 953440994ad2..2a01eaff03c2 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -395,7 +395,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
-	long npages;
+	long npages, nr_added_pages = 0;
 	int err = -EIO;
 	long i;
 
@@ -450,12 +450,14 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, npages, 0);
+		nr_added_pages += npages;
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
+	shmem_recalc_inode(inode, nr_added_pages, 0);
+
 	return 0;
 
 unlock_folio:
@@ -474,6 +476,8 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			folio_put(folio);
 	}
 
+	shmem_recalc_inode(inode, nr_added_pages, 0);
+
 	return err;
 }
 
-- 
2.25.1


