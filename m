Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236C7C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25C86B0088; Fri, 10 Jul 2026 04:28:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDA66B008A; Fri, 10 Jul 2026 04:28:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDB96B008C; Fri, 10 Jul 2026 04:28:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13046B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:28:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24A771C892B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:28:56 +0000 (UTC)
X-FDA: 84972191472.14.0AD6B60
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14D81C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:28:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783672134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=iLuw7JQ43IEIgGxxgYxKVar+PYkP9ayNFoOKHtxv8RE=;
	b=HKEJhKNHs7RAiWFYNetD9CqB9sB/2xMrokcn/Ku+AeCmxEkdq8eKqydRhkNuIN5BrWPo+s
	MTRV7n8xagMhICxcPVqu20tQLAvuaIeVcouzWg05gwM1qz3fsA36hwbDZwNxzduRvIGtvc
	2xnHdhIaVzKVRMX6xwPiWFa31XLl+0s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783672134;
	b=cIiQyabFw86niKFaj3CooNDv5sVz+BoFa+xntaL9atVC7SSwi1kHkrrsLrrHSwxB2v3WvO
	CpggU2p1+aGxC88Ui4WtJRSjY3o6cspw1xg8fr/YB+kHrBLDAagL6Go/nhs8VX8B6glZkI
	ft9I3k7VzY/DpWK9baoVEE3aUcBzkYo=
X-UUID: 5cb2f1887c3911f1aa26b74ffac11d73-20260710
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6e982667-8bbb-49db-85fb-e5b91f8e77af,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.12,REQID:6e982667-8bbb-49db-85fb-e5b91f8e77af,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:e7bac3a,CLOUDID:47ed8060824e5aaeacefd11062448ea5,BulkI
	D:260710162846BCIR0X1Z,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5cb2f1887c3911f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2021237231; Fri, 10 Jul 2026 16:28:43 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH] mm/zswap: flush dcache in the compressed decompression path
Date: Fri, 10 Jul 2026 16:28:22 +0800
Message-ID: <20260710082822.583930-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14D81C0004
X-Stat-Signature: mba561no335qfp6kuhju5sskeduo7uoi
X-HE-Tag: 1783672131-593579
X-HE-Meta: U2FsdGVkX1/ZgpoudMAPt/0kcGV8bkZkk18PT6Koz913dNUpX1WTUdnI0XiGmkFieSU6kr/9My5QTIWvDCQQWVYgu+p36fyhHiA5mp3h97x9cMRvTS5KfZN2UN7Dx3sVDgeLEkZMgdMQJvwVSUesA9haF5jzaKqFTDM06Q2I50sNRp+4dHFyLPkQLKmpbUMqabAVOQwX3j1iJ10ziIeVDPmHnWvwPhOHPGgzBkjLENdpslGxmsFaYdlm8+0I0DO5Z+Wya6qFFg2GPh/ZeOO+UpJdF25haiOjfhzZoZPFI6fEoO+KcQq8OQuaxn8EoQ7QwNb9rfkEXMzQokFYJ5zGKr9nG5v7LQNXZ17QzpkijSFo19XNg5AE1X+D0XLrszRa9PShD/jreMvd902QWtGyRnaOgvWFnAF8r37DDnnVuHOHice6Q4l3+kzRRRANrMsja1U2Xoo9osUhTvkUv3S2ofH42UCZKFV0FTkHWX7hh4QcoFa51Km8CT6mELHNlHGfrxxJCgvi3ejATAkK5buoKRUso1RygfYirz/TaumTXRaF3iiPp0WP3q5lxi2YVRsjPtXY0EscFFbOTzUDMRB97vxJRKrHwm/GUAR4kYe8/atJdEKguZAfY3s8JKenn97O1exb4r5h/f+i5/WnVGVSB8/r8C+6ZkALPECdFGEyTt/9DNfkPFYTBFEc6EstT9lClNCZGVUYN28Y+cnZBZp0gJNVheb3K2MCIDulDJaHJdNpoWl9vFwESvuhokTi0sMIVWp+yO2QVkMJ21J3f02ppyQTidfTFJHk0zHgpHQYTe669wtAATJ+9AcJprtfzbF7cl6LMdMPRcalU4/dFM2qLT0xRlWL3BSybCdoE7PB6GDU/Jg81BAuJ4eRnLSGat9beKgcJ9YvNd1VThOEiv08/0sUfDfdFu26BIMX0ZXwAGaSJOJgbuT+mZJjkzyZaaNzAH1T9+Gi10UcXEpLJoK
 kbaZ0VaV
 Xfk0H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both branches of zswap_decompress() write the destination folio through a
kernel mapping: the incompressible branch via kmap_local_folio() and the
compressed branch via the crypto scatterwalk. Yet only the incompressible
branch calls flush_dcache_folio(); the compressed branch was missed. On
aliasing D-cache architectures this can leave stale cache lines visible to
userland after a zswap load.

zram flushes in the same situation (zram_bio_read()). Hoist a single
flush_dcache_folio() out of the incompressible branch so both paths are
covered.

Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 mm/zswap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..bb0c16d102d5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -943,7 +943,6 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
 		kunmap_local(dst);
-		flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
@@ -954,6 +953,9 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		dlen = acomp_ctx->req->dlen;
 	}
 
+	/* Both branches write the folio through a kernel alias. */
+	flush_dcache_folio(folio);
+
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
 	mutex_unlock(&acomp_ctx->mutex);
 
-- 
2.43.0


