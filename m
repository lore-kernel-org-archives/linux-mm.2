Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80786606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 06:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6134F6B05D6; Tue, 27 Oct 2026 02:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4676B05D7; Tue, 27 Oct 2026 02:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5FB6B05D8; Tue, 27 Oct 2026 02:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27D156B05D6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:05:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97E0AA85B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:05:30 +0000 (UTC)
X-FDA: 85367369220.20.7B20AA3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84B6680005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:05:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793081128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=UgYeLH0QBdOF09Bok4Ce5TDxHt55dEGUJRjpMS7x1+w=;
	b=lNW1syfYYJ4C0DzH8vJmlt8EkfF13COj3RCYZKtflVs8Jj2JoQBFlJtrF91q2JIlCQXjWg
	KGPe2JdDO6Z4bKgQVSGTtGveRs584NMBPRkgaddsQuzvsY6bEhzRwtIAl6mflQ96rz0jIz
	sECL1+ZtKSe93DMGDfsKDyOXgpWVvP0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793081128;
	b=FYJ908w8cCcJSW120ZoinKyJhAiYsJEUcZk04UpmlFcDF3R6fHygFoCNllcx+7sUJJfA2J
	P/+aGX8HQXLTdjM5yH2VEnBQcm/TGHhyiJfWCbTXWL4oMqalK8MhbVd32y70Tsv9fcN8No
	tWec/3nWwfOpMzLiQj7qVIN/EhfzRjc=
X-UUID: 6210895ed1cc11f19a56ed5b684f684d-20261027
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
X-CID-O-INFO: VERSION:1.3.19,REQID:330c8d0a-8d89-422a-9d1b-84cd22bc297b,IP:10,
	URL:0,TC:0,Content:-5,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:330c8d0a-8d89-422a-9d1b-84cd22bc297b,IP:10,UR
	L:0,TC:0,Content:-5,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:NOTI_GNA5D1EA,ACT
	ION:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:9a8b725d88a0b6e4b2eb710e43fcab38,BulkI
	D:2610271405205EOIUPH3,BulkQuantity:0,SF:17|19|38|66|78|102|127|136|850|86
	5|898,TC:nil,Content:0|15|50|99|100|101|112|11211,EDM:44|-19|2|-100,IP:-2,
	URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1
	,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_EDM_RNO
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6210895ed1cc11f19a56ed5b684f684d-20261027
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1495173860; Tue, 27 Oct 2026 14:05:17 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb: use account_new_hugetlb_folio() in add_hugetlb_folio()
Date: Tue, 27 Oct 2026 14:04:46 +0800
Message-ID: <20261027060446.289404-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84B6680005
X-Stat-Signature: tomw466ugz5giaqfdtmo3zt6n3h1aakt
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793081127-580372
X-HE-Meta: U2FsdGVkX186cbw5b0G8YV9B3pdJ64aT7Sd9zAwnnpQi535d7sqiFdUNIZ+9N2T5xBblZyadG21jiVfSvQCd3NC9FHCnEf8jlVyNOwwnQ4WcPmO63AdN9iFYBJjf7VELrgvfaWAhKt1WDVJh/qG8VRf0/P0ISrE7Zma8aESwMKpdbhyHCG2rU2jZZsmOP2tVivuoJWuMQ7S3MJulHtbwam7YCM9orUKQP8PJAh8FMSsm0oWh+S0vw4imhjKsOf8fwu7e5CW86ZhEYJSuF7eaSrz5ebrhwiD4PrBwbGMbysGKTdCus9NivFtE14CIKY3QeS8iDdWZMG1weGDL3iPI4DWO3gwwnermB598fECTG5EalVlXSesDtjFrYjWokT/GgnJxGO+0AVQSy7OVJaQ2OHuBabnY9fTIZFilkKpdYGLbYuefyB0quAg14z7M57Z630D3CnaOMaUvGEZZe3hRR50iR+gld0PqzXEAO1fLR/cJoHOWBmPFLMoo/dbcoBmUpsH16/gWARYeUNAeOV/zJwI87MZPPoCefdnRWBH7YA8ya9q1J1zmBjYxEwMY/oAsvgoEejlW1CQJn9GqkjKh65SlrTVuINvDiv4PDFXurx+RYszm71zb4N/oG9TyPieGN5SgMaTGkL82b+gtEUF/GjAEKuKHyUxp6sbTM4QUc8IZOlLV0KkXX3bqwi8R7vNFaF59LH6IQsE83abCuAjohaeu4fr0K5EpRAM0T6f9GWo3uN9mvVRvyH2GUwULaJLBz2JwQa8qpgM1XkAvnKEEX35EuOSm7S4VudWLmCZ7hk/USxGwFtjtcK73BNeM3+JeDkqhTqmW78WfH56r7gqeXiZoDwL31xRm28bvollG06PiCT10cZc2kuhn6AXKdFxeF3+ndFzVlOzE+RyLiFEkLENL3UBdYPhPwE62J9J9VhhWrUTSKi97QLci2u0L8TTQ3Yig7zPAElkXAuBVd7G
 E59MNSzA
 dn2D8mSaQwNMWa332V7tppwMqce7XMZJaasrgnu0JyhOF2+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every other place that accounts a new huge page already calls
account_new_hugetlb_folio(), and add_hugetlb_folio() was the odd one
out, still open-coding the same two increments.  Swap it over.

The helper is defined further down the file, so add a forward
declaration for it.

No functional change intended.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a008afaedf9..a8d162449daa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -142,6 +142,7 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 				unsigned long end, struct folio *folio,
 				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
+static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -1444,8 +1445,7 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	lockdep_assert_held(&hugetlb_lock);
 
 	INIT_LIST_HEAD(&folio->lru);
-	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	account_new_hugetlb_folio(h, folio);
 
 	if (adjust_surplus) {
 		h->surplus_huge_pages++;

base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041
-- 
2.56.0


