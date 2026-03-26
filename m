Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2438C106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC2B6B008C; Thu, 26 Mar 2026 04:48:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D34B6B0092; Thu, 26 Mar 2026 04:48:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810766B0093; Thu, 26 Mar 2026 04:48:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 729946B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:48:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F72CBCFF0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:07 +0000 (UTC)
X-FDA: 84587587014.18.42965FF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5BDCC0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9n0F7QjTMCW9jVkTXOq71/m0RIbtYl2H6KxOO9UqMNk=;
	b=nFCtdrK5TMdeNV/JNNhbWDYAX0iJlf/ahhUSzDHTZIltiuLZnKoIMHn4Q98oWVuuEDtBkT
	6pXGyo+cqRl2XqhoQuRxqj64yMeQIduOZ8V0YDwtG8i5i1YxLQn6NXd/zP6cHIUGd+MiBD
	DAsGeBiwfPwn9lu7CGNjgYyrGDVzUdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514885; a=rsa-sha256;
	cv=none;
	b=REarnFS4YpaWnophQSGEGg5OfrBB4Bscv8THqCh5Xb1CxfoWMUAITvl2Spbax5lMBI83+U
	Bycp1qUrkyitILeChokxfizY4xTg5tKQa4adQi0ct9nA8JmJ74BFabU0ihy4C3xnkgzT/m
	wu4NwMZf3plhYwBA9MkHd+jY+Fs/eSQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
X-UUID: 7d47c9f628f011f1a21c59e7364eecb8-20260326
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
X-CID-O-INFO: VERSION:1.3.11,REQID:4392c13f-415b-47c0-81fe-5a43f47d2d7e,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:4392c13f-415b-47c0-81fe-5a43f47d2d7e,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:d37ff2454fe42428a695af3dfa1f3ae1,BulkI
	D:260323190759QJ8F4FG9,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7d47c9f628f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1020245059; Thu, 26 Mar 2026 16:47:58 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 4/7] mm/memfd_luo: use i_size_write() to set inode size during retrieve
Date: Thu, 26 Mar 2026 16:47:24 +0800
Message-Id: <20260326084727.118437-5-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5BDCC0002
X-Stat-Signature: 9ip463z5kfj61ruw81e5bu3hb1fcaiix
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774514883-472172
X-HE-Meta: U2FsdGVkX1/4wf47kmz4x4TxRSy5/U0VMi+daTbEag9lVWyajDS8LMg/OlLXvda56rur/UaXo49ucLcCdPHD4KAfX0hAI+Hr9q4JCeEtPo/zd6Oyqtqvqs1IuRG9KN98QvOfxfCkdTm3WfKgrj3qJxbdtHn+3TqQAiJGfLX/2p6RNA2cpYgI1XgRJTJSyeEopDECoxjTjj4un/28misdmsMj72sciriegmUaFMM0tEBijCtEfAJiIesVfcs5FBlY3fe90XJh8A//+V2nk4inc0aF2e8Jwb6ZHvGLQiWUqcqUjgBP40k1cGGzb3/aFPOFtndBBJ4H3zGD6rP0VyHt8cLYBw4UfqldxZwEwknvm7P7LC/WUsNjWvcW04xy+nacetiDcjz7Y6wlEKTe+lU3KdJ9iv7TajTcQhp+Z9+AYJ4JrquF0Q9iBLlFy/aTxLybLRfxxUDqsaoXr9LU75uQhuUoVWbOvo9aUpX09i/pC9hXpHMIOgXYSHendSVhRe7EBGUrTHhdFI8pNkEnGleD+AccZB/ENJkWAWLeUX1cJbCXkORlPe1LyMXAC0LA0TKoF0/pbewf6scTJGS/hj12U8Ase14fYyVEMDIK7el09NbQNmoHFkoSPOTdydtESv/zqe2eFYIVGJuwciDq9panJdfB45tEDXCswzZFY4eJfjMIpYoE6z94qgi7aIHlqMe+r02a8756tTZ08Ckf0uPBp/fX9WwRvJuZGNVKNQb5DmovU2Za8ZztJc+QXEdDQArZ4n/HEmO6bkDQMorBNqpMMfSJIHNGpLEOheDM+igLKPG3HH+8XXgFgU2Hk8XYBFtohtmk2yJBPh91QaFAoSqVGo+Aqt2zjGS/04GF02BVF8NwXhu2odSpENC/j84sE7f2wKEyTaVRw2M9i4fJjPLG66K3mDbVQS9Du8rGWWDbHvUNbXYRhXki5GZ1tAyDnv3Qtwk7yJivvongPe8RaYw
 tnmOEkPm
 UOk/O/XHI2VTSToP4yxkY0z9UuBEM80eS8Jf7fHkr4x7ypvya1zxqFg21DBsTwXh4zJ7w0am5LpSmYa/HjRMOCVHN0PNt9hqdO8gSgqmeE0G/ATY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use i_size_write() instead of directly assigning to inode->i_size
when restoring the memfd size in memfd_luo_retrieve(), to keep code
consistency.

No functional change intended.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index bf827e574bec..76edf9a3f5b5 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -499,7 +499,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
-- 
2.25.1


