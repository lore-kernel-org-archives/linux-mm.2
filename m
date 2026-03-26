Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E092D106F304
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422AE6B0095; Thu, 26 Mar 2026 04:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D2C6B0096; Thu, 26 Mar 2026 04:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CD06B0098; Thu, 26 Mar 2026 04:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 154926B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:53:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCB9913C0E9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:14 +0000 (UTC)
X-FDA: 84587599908.07.28F7451
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1A7F714000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774515192; a=rsa-sha256;
	cv=none;
	b=ROdw39a5goFAU63xvEUbJgd1NXTrWITOajfFVriCluEVmZaCR6XBosNvwzC4q2mkBR0G5w
	koQH05Nf39156iINBAsjPZSqAcz4t4/n2JFUM3v5OBoi82rJCQ1OwCXJzUaapZ00QqFKUP
	pnZV47buUfq6c3etFFNRt8iB2Jzynm0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774515192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UIiHsIcbpjyDheztVKvGHtvn+my64foPD1EzkJOw9G4=;
	b=eTJvzRkeg6Mr2EYhcckNScvpW6tYDrb5Y7L3h9EfbeR5+9hVaYZpNu13JB3RpCm6mpAoNR
	vBPCeeM6IVyXUaL5Spuk6bK+bXFRfJ1H2gb3Qjwvh2W+6pE1wR6fc3cyDqjXgJEyxqbGwV
	7FxuHXMKk8e9JD1HI4+NsWbztyJF4I8=
X-UUID: 7ea6c0d628f011f1a21c59e7364eecb8-20260326
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
X-CID-O-INFO: VERSION:1.3.11,REQID:6b50342a-0cc7-47fd-9245-b3f147493809,IP:10,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.11,REQID:6b50342a-0cc7-47fd-9245-b3f147493809,IP:10,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:89c9d04,CLOUDID:2cd171e89e0fadf2b4fed362de1d77e9,BulkI
	D:260326164801ANQC1H1A,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7ea6c0d628f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 967957855; Thu, 26 Mar 2026 16:48:00 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 6/7] mm/memfd_luo: remove folio from page cache when accounting fails
Date: Thu, 26 Mar 2026 16:47:26 +0800
Message-Id: <20260326084727.118437-7-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A7F714000A
X-Stat-Signature: agfynm5jsr6jf6fbdctfposippqgj61u
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774515191-847388
X-HE-Meta: U2FsdGVkX19VaFi8wo4o32Ik+hnSAq3rA2N9LtqQpnejmBpNXfuhpLlCKU2c0Yfh1X3E1tclVVUinCtfHlW2W/fR01gMqWVUwpzbJ6elT2i3C4h1C0f9ynMfLEHVxMp0QGrlpDo/PgZ+ax2YoIdyv5+vmVQINfANbYtUOIaGS+VW/5mrE2vnTxqmCNuJ1tqHIMvx927euLkaQYZmn/Lj0lbgvfT/YVUCnxCkpwJO0IUSvnjfAI/xwsgWPVOCf7jpmnweQIeGTOgGdaU8JU9Sd5LnKhESt9guOgY3wrnGQgD8NCv25ETn/roqXTVaX53P0x4vYo3wIks4RZFV/usztoCF8Jwe5DmfNtodSqOYLoft2McGT9uk5kLi+1rYGBntLfmvaxGUPsDXWUIG43YMNiI83kfSpkKpKLnQTTA7cfkbXbpu3xrfTq4H2qeAz49d3E7v3XhXwLESpedBb6mQwQhRyV8Mnx8RC/MUOiY8dgFMA4SP+QYXIHPw6Dp8ekC4LidSSkZauJJuaow1K0SouhehNd6xe31EUPuB6LXCzS3y9QqBucSWWlqtuV5P1NMyVrSpdUjEDEuoXhjgIk1/ODu5Umnk6ftU3NA+KIijbSbr8OUwWA+yTYY/V9AeVDEnEBf0LLRxVu2TjpCZlPYeNCfj8Dp/ECeJl5ajiLGVWHwgqBBrQ1KUUb5jAl5uKlvo3Y75kG6tSnQtYa9QPKzUyFUdCKqG4sBClQj19I4OrUU/aLxxMYUoGRzVWsZKccXh7HEAMuP/2ZUHc4zoAl/X0TbmwdQ0+TCLG/DpqKyBYem2Fd2QYEEIrNcz4BKI2FiCOLXUTD5b84CQtJOCmuSxCHfDQveL0IvdnyEQzCFEcng+MMNyc+qN3bi1WpYlot9IcibzBuQTvd/mvZiR7C5KsWuBHF+F+WgtOTUc+DTlxSINwQtB8chMkvceHpuCw7Az0SYMCWRVjxlGnwI9fHW
 HGw2gBBj
 eMjgUi+Lq/rHGD53GOJHgI5zj6YYuYLs86Av88GcnyXiHLZUsX1Dj0sSaifGIg3XD0OlmF/h5ylKoF6oIjOxpQfR2+MHapm053SaDCAgbROp1KdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_retrieve_folios(), when shmem_inode_acct_blocks() fails
after successfully adding the folio to the page cache, the code jumps
to unlock_folio without removing the folio from the page cache.

This leaves the folio permanently abandoned in the page cache:
- The folio was added via shmem_add_to_page_cache() which set up
  mapping, index, and incremented nrpages/shmem stats.
- folio_unlock() and folio_put() do not remove it from the cache.
- folio_add_lru() was never called, so it cannot be reclaimed.

Fix by adding a remove_from_cache label that calls filemap_remove_folio()
before unlocking, matching the error handling pattern in
shmem_alloc_and_add_folio().

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b4cea3670689..f8e8f99b1848 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -446,7 +446,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (err) {
 			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
 			       i, npages, err);
-			goto unlock_folio;
+			goto remove_from_cache;
 		}
 
 		nr_added_pages += npages;
@@ -459,6 +459,8 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 	return 0;
 
+remove_from_cache:
+	filemap_remove_folio(folio);
 unlock_folio:
 	folio_unlock(folio);
 	folio_put(folio);
-- 
2.25.1


