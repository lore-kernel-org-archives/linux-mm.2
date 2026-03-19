Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D331088E62
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76EE16B039C; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747266B039D; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660066B039F; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 46F3D6B039D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE0751602AD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:05 +0000 (UTC)
X-FDA: 84561079050.14.07ADF2E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id F37D81A0011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7KyNp/XbC9YJgZA5kox2vd6jQnlJOuNHAajU2Fn2Pqg=;
	b=hpT6mnI1iLIxdxVOwgGlUYfWrnyAvj+EBjD9Sz28hINeUrSSQfA6D28WQucKRTmeT0eCBi
	k5TnnVSoKY1DdqebxQJcwQcM/bTC2BFnEK3mbqZnIy/xdc6fZDmS+7bz9kNf3yBplpGoK0
	rLefFEGtVXneYejlFwrIbFeGqSUh0Xg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883743; a=rsa-sha256;
	cv=none;
	b=h+pnmjJ8zvLkxyvgrbEaFd/+fwcVL+yvKdNAg9WsUh6SC4+79nQtVW8ylpWIr/EwL4mFBR
	h47qqc4QsZpKGN/MZclMFAeKspoRS8P3YB8cQQ06WiUY1KSAgu3hxrHG0/ukmSfwApSZFF
	zxRDKZxknjBhzgaYqUF6D2iYhry81Vw=
X-UUID: fd09db3e233211f1a21c59e7364eecb8-20260319
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:3fe70b73-3617-40ab-8f12-bfbdd59bc9a7,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-INFO: VERSION:1.3.11,REQID:3fe70b73-3617-40ab-8f12-bfbdd59bc9a7,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:8e9051a4baa071bd9e6ba1e2fd41ff08,BulkI
	D:260319092854E2BZI7TH,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fd09db3e233211f1a21c59e7364eecb8-20260319
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 407130314; Thu, 19 Mar 2026 09:28:52 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: duanchenghao@kylinos.cn,
	jianghaoran@kylinos.cn
Subject: [PATCH v1 1/3] mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
Date: Thu, 19 Mar 2026 09:28:43 +0800
Message-Id: <20260319012845.29570-2-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260319012845.29570-1-duanchenghao@kylinos.cn>
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F37D81A0011
X-Stat-Signature: uo4gh3gpks6uzjqu1n1baiayqficm9pz
X-Rspam-User: 
X-HE-Tag: 1773883742-286319
X-HE-Meta: U2FsdGVkX1/wUWNn7fyM2Is3IUCt3fnteM6XwvDcFd4E3NqvgRgC+1gnXd0atJTorff4e7iyjbGIuYn1eQ38GlEiwiXoYpiQhPYWgalaJvkv6JVC8tt6Ga6ewQMc1xvhSJl8UN88E1i0WaaHEJZNQ4Ofc3VCcbiqn6KQ6RGGcFXxq47fwL9yLKSxDyTVpwX/DpdbsqIYiq38gu3dArbAXylgAXOyLm9oyZnuKnVAdEAKVA/jT8/3L2GTGTuqgnWGCou3q/NyEa9l6eyxak0RXnLe1jq6yLk07AjFiRr8pBEm3R8MDGyk+nTLsdafhXEu3iQZn4xZmoX/uYQ3sT2VbRZDTxbmDBiRMOV7z4cjIbQZKzbWG2yGfJvfs8/hSxQ9puC6/qKOxtOMmi6uzVg+U8X+3/RLb7oONzOrvoAdHXVQLs99UzTJ/sLBNmMEremtT4Y5G+MIG2JYrPd31LvbtbYy95X6bVgd4MOM4J2E2JG0GJQu7QIaUEfo1wpAtjPJYzdhLWE2aulxENXsTjh7xWTs/uc0iL0lFQ0TfD1RXE+/UqhrWsM0uuY2IM65hNQ5JoIzUKFLFg8A9Kjfg1zHhcbQxGyqXR+SxgGaIzZnkDcahrtyv2xdl10fQxdgfFZEgOcGY3CVrt9N8p0NkU1gM7nwR65lKRXAYFxasW3Epd/9Na/vgUxjBJB+DwUaYCRKxZT+6mHgL9rC6gdel8/+8Zw+Jm2HXgO2rgmp+jwsaCRz08UQH0h/VWhiPJt/j14ngyrm4pAMKNXOBSr65Dj7zIGOajGDLrrvnR/fRr0ACxpWDEb34AA+HkkOi4JtdnhfpC6FelmgvJKfVbdrXnwAGFNvNYSvsCCbT2rOLs8qskcp4IhSu2alodU4ERQVT12nYUpH9/vI+AAwx4FQw4+9b8fCp6koJ9WcIz9X72Urq/tyK2ucHxe7ozv9LyjeqQfIcfv3cWWZPUqFSAhewUf
 sM56wSpI
 MvWAdbm1mw9iwAQVPKgFRQsqo8LrEFr1tuGH0IXcDUfLsThE=
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

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..5ddd3657d8be 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -397,6 +397,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	struct folio *folio;
 	int err = -EIO;
 	long i;
+	u64 nr_added = 0;
 
 	for (i = 0; i < nr_folios; i++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
@@ -448,12 +449,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		nr_added++;
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
 
+	if (nr_added)
+		shmem_recalc_inode(inode, nr_added, 0);
+
 	return 0;
 
 unlock_folio:
@@ -472,6 +476,9 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			folio_put(folio);
 	}
 
+	if (nr_added)
+		shmem_recalc_inode(inode, nr_added, 0);
+
 	return err;
 }
 
-- 
2.25.1


