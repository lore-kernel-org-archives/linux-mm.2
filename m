Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D1A106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D8A6B0093; Thu, 26 Mar 2026 04:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDDF6B0096; Thu, 26 Mar 2026 04:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5936B0098; Thu, 26 Mar 2026 04:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7686B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:48:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 050141A0A2F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:08 +0000 (UTC)
X-FDA: 84587587098.17.04CF0CB
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8F228C0007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aNvaoDn7/bfLErU406QGGVp2m4GCteBL58V1RtULhsg=;
	b=dBtcD5tpRut5mofbLdUXjemGDvoeP2avf88N7PSb674Ww/ImsQMDr9ygDoXTTzGOTHj8py
	zgdDJ3wJT4slciBJtEzeUd+d5kGb8WOt3zrHAfrbVnhTk3OCq+tfR2XCA2pf9+rfiZOqJv
	8qAUR/O/oxCPlscqUDNDPOxfc1fc+Xk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514887; a=rsa-sha256;
	cv=none;
	b=bSd6zOBIbbsuin8CdzJsxi8VAqybrZ+VqMPu90qa4SL8nDOMs5lNfnVf3tP6n3fCErRYWy
	FbSF87/wDTQCFUpKV5kKkNxanxmrtZVpoKZekpiAqtW93T+fk2Dg+ikcxUb/RbRWr7SRCI
	8+FKDtK8iTMRLHKu3qWweRHi45kC9Bs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 7c231ae428f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:d2a5afa2-594d-4a74-a9d6-e43c1f7f3b83,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:d2a5afa2-594d-4a74-a9d6-e43c1f7f3b83,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:aaf90a360412ac72c3f6a39c578d0c34,BulkI
	D:2603231907563I1Z8ACW,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7c231ae428f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1214504479; Thu, 26 Mar 2026 16:47:56 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 2/7] mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
Date: Thu, 26 Mar 2026 16:47:22 +0800
Message-Id: <20260326084727.118437-3-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F228C0007
X-Stat-Signature: 6xerswx5iuu484s665oac4qmsrhiwyqf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774514885-936786
X-HE-Meta: U2FsdGVkX1+ZQefwnkNgCRNzR0kYyOqfGY72ekSPecbc3LkkOAEpOeKG6Zs70S5kwg/fFr75MgKCaw1lwAMSDaeZcfpXkau6P0Tu7USQy7eJZVjWgI62gJ9llR+9C7dhN/f+SnCeanX0EnQSQILX36x0ATqSKJ2p2P9YyQmo9EzCyqzO9xLe29pzN6ER4dy7b9VLryZ1t+gZdH13SmoV6L8RnOetXq+Nt4l3KfH4IpxeXMYDEQ8kmfiTz5dKiLAmWxsfYiKmpaJYmQGA7Zm/qX+nzspmmErX0yRLciGrRM5LKEftG646ekdumyFCXsZ3t84nm3E2xUlG4o1yEW0Rw1SXtTuBWEzpdTL2UNdwSN2VbX0T5ZHm9iiTEQ9C7Hu6WWPMJzP4JAd4eDX/KEcD/xSRz25pwNY1sZvgt6hYdzNNC8El5b7qwnTkpLbd7E8fmViNJecAAC+U4U04QQhiFaZDOyiySB9OJwG3R9DRDXeHyfT86RD47Juy4FphN2pwbbnbQ5OR+ev8f5YiGHAohcW+Kkz6cS80yVZTWI9XgnjUfZQ7tFfR7tAogSr17fp+BwIiy5xrC4CHiNOp2bVaQ4wJ8mbQKi8xnLl/NixXscRNmuxIu18YgJIPNJf6+IxmK4jirf5B/vlM0zrLuzyrtYZ7OEMcvHVvDItynSUHgDkUJ9b2eXYkpP2OPhmLYgEP5fSWgcnYB3QS2gBTCM+INHR5d1+RQR86aBRXR1ZGfgNQTWg3LVKyz6Us+iYfnKXcvk120h4Q97TSgc1OXARJ+UXdzcaViULPdbK03qlhhL/Hw/33L46WdnFDmkepJ+yJJ4+lNzdZJDow+yeU4+/wlnK8FpV6UGdSmQ8JX9xFzogAkwYzu9/4P7/FFT+neYc2oPjjNbdYGJdEbkP2avUNmjqaBGcbL7uC8grSTjQeYMj8U0//A+o+YzeX1kMWB8P+4dnf5o4L0IsLBX5PiLk
 QNPWMRkk
 TRbhPmmuIuHpZzvTlx6cD5WF2XEpd26mkowSBXEbl/0TdczOJq7Zgp6wt7yECo+dvyQjKyLYBax5A9iusr3ox8Hz7YD4eJoErmdPezdvv+thohlQ=
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


