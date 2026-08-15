Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAA2C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AAF6B0340; Sat, 15 Aug 2026 04:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB206B0341; Sat, 15 Aug 2026 04:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA0B6B0343; Sat, 15 Aug 2026 04:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD546B0340
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:08:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DAE31C0E06
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:07 +0000 (UTC)
X-FDA: 85102775814.03.B6C2575
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id D00D6100007
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786781285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3hOpn6Y2/n/pM8TG9b4slJneC0kTGlOhS7oprMhSKqk=;
	b=eWT2MyycmULpc5FOZNfrTO1vnmmHCFsfTpl68xHm4OpIwBHmchd6f6BPpqhXHvLYpseVvi
	tv33EnsajtkFKJ/a6eDBsleYj0TgTvkMf8C6+9rLdiBg0hXisBT5edJD3i1c6kF9HHlPjG
	C2V1CjS9u34aAn/i7vELQaQg4ffXrhU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786781285;
	b=VV4dPBIl7VndjykR6rOJgl6BD0uqQNgpNiNBgriF45UxPmL2tOynhtZA1FzDKs09Yc3UnC
	v8XPQWqLvJaQsuC8KwVGk74PfhoU5tzoaplyGJHmYBY7ZWuCRUphGl8k6LZIbJfDNM892h
	BFOoi9uhFiesOf3PejqXR2RTdaUhO/c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
X-UUID: 69a7392c988011f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a5d96d70-7fe1-4011-a016-b67bdbebf0ba,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:a5d96d70-7fe1-4011-a016-b67bdbebf0ba,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:24bc5c46d6504473acb36b29fdce81f1,BulkI
	D:2608151607574OR9VXI4,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 69a7392c988011f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 953653928; Sat, 15 Aug 2026 16:07:52 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	sarthak.sharma@arm.com
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Date: Sat, 15 Aug 2026 16:07:14 +0800
Message-ID: <20260815080716.3596514-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260815080716.3596514-1-husong@kylinos.cn>
References: <20260815080716.3596514-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xg948cwe3daomui7btkhk3qoubgmus8i
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D00D6100007
X-HE-Tag: 1786781282-944405
X-HE-Meta: U2FsdGVkX1/3Ov7wMXPvjFIY3NVr0R4c5y2FRUb1QeXmggxpBaUUtrjf7ol8R1sh3SyJhOIITgNd7WkpLsT+nHauoXjFOqvEv5MwUTtzKGyCZN590pyx7pqXXCHwu9EZRn0pgJPwWmdVrDJCnU5qA5y+vZ75olKic62zex3cg71AfjKXXyWkgZgpahDzpqScNh7udRpNFHYvl3XzYRII+60yko1s6AbSCM4bdWW3rXO2aZ7JgNF2HxUQ9g80QNhLBtl0waziUZNtyoQIjco9Nav01cmOd/3EBxrj2pvwdxXxH6iGgJm+Uw1RrJMU3//pfjgQUt1Odzdwlb+7CJKegnyCj/sZXVHsHJd8oysFI0HpeBB38KqUnoLcir4BgjJS/zb0NKbm1tw+MxRQks5G6521SBdZ//rySLQVol+RTMdYFLBA/aFWA/cl9M4EdUV65JJDeGG6D1u1T2RtVQHIa0ORXkeXULwgd7zPbivnJJkp5UCJmbwWvwiI406utuHuLip32PSZCvEq7yNRh9fX3h5MaBE0Ipu6rEz5fVh9jXQ09HAR2YDuLy6ZWgTx5DHhoV/MryjRJc5fxWUtyPOs61CnwDTkvMAMMKDJ7ux3l/cXwAfmBEBcRWQtp+2Q4VvKyBRI9REP3Xc/qdcJqy/yqnV0tWaoQC88HdmCs8IX9b/fk+/4QnLm6IUMpDmAtUsvjoTBt4TeAgVuYHCGSb6RQQsinM43n1CibXreADihagkB9C00wl2iVzOjdQV3zlicwRte8adolFMtSXiXKz3bL3lvJRQ8lQ5I+/pyyvhwlnE9dayDDk2HBDPV8jGv1ojTL1dlzUwuUgHIUGR5AWn2/7p7dpRZ5lOYxZ+LcUz/WUe4znYJt+X9z/oFzev9dix1YTRQjUtzpQKIUAxdfJUAP+7wsMMetyIihFPUr9Ej159VCHxyTpUEfQUqSxTqivoArPZ216i/Qtc8+nXCKYw
 C/ESnccw
 XV6Nl9OIOBr+2VvWFlhdTCxO/2sQ5j+pUiTXpVvZP2FuWPfV6LVd2WO7EVp7kUo21QmHoiPHpK0D31ikpJR8nvWEG6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
output is not valid KTAP.  Add the header, like the sibling uffd tests
(uffd-stress, uffd-unit-tests).

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c973d6722720..572c2516e874 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -347,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	ksft_print_header();
+
 	hugepage_save_settings(true, true);
 
 	check_uffd_wp_feature_supported();
-- 
2.43.0


