Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 881DCC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204E86B0100; Wed, 12 Aug 2026 08:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E616B0102; Wed, 12 Aug 2026 08:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E016B0103; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C61446B0100
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2761AC036A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:55 +0000 (UTC)
X-FDA: 85092501270.28.EB9D5F7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf01.hostedemail.com (Postfix) with ESMTP id 406BE40008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=znjDINWFk0njiUYSc5qIjgudGg/s4yzAiSoZ5S1Rr6Y=;
	b=F8e6IBIU7HoDMbmKoLEG5zVudMiNqW7VRBEdDOQnq88Lr3D9ydD75BLke6fNyajPpzFzMg
	b+Wrb+6jn2eEd3I2ZTNVA/X4eZyISd6K0C49zYVc/j/vK/eSdlSRyTVEXm+JznZq/82gkK
	ZUdxhlZoSls2Ud6qsypeXHgDxug+D/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536649;
	b=d6qufUrL31HNWh2VIM9KBt0YAp3qUZeLmJi71C16GhOeMxZHRVdAtgNTmC/nuK1u/Rb1xL
	znsBIp70ot6wMeuQmkr22I6+wfG2i8lmN1stUXWZGi/6hAXUqyWLN9fc1uNppXNcSVpeBX
	1VP6KKLpeJnIhtVl1aDIU6y6YMS/Ovg=
X-UUID: d5ca62be964611f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5f18212b-4594-4e66-8a75-b2f9d1eca859,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:5f18212b-4594-4e66-8a75-b2f9d1eca859,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:17eb1e6f7dc378d4279cce800244c2cd,BulkI
	D:260812201044GFCQ6AU5,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d5ca62be964611f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 810789663; Wed, 12 Aug 2026 20:10:40 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Date: Wed, 12 Aug 2026 20:08:19 +0800
Message-ID: <20260812120821.523860-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812120821.523860-1-husong@kylinos.cn>
References: <20260812120821.523860-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 406BE40008
X-Stat-Signature: o5y16q9s1meuj5ecx3eiy5knukrr4wyt
X-Rspam-User: 
X-HE-Tag: 1786536647-823628
X-HE-Meta: U2FsdGVkX1+h3rLud4mqkzDQT9q7wki9W8dS8j8QlaTtldVpMrwG5+yu1iYzujHOLA+22lph2jt1IC3qG0wj/BtQVKd/PA3r/QWPKLTHRBer6BRhuNcNeTtxp6W5wft2bf4u8722RRwuUNG9C4Kvx5SOfM0u+pS1ptJ5mZ6RovNHTMsqNaNtNJC5OC6hgERG0nIME40kxMOtUyrI0kScTbAvoEUFe+qLX2iFDR3mdYJ0wX5QSvNbtFxDv7SkKdv/SNgv+pSHKiF3kICRi8F/SvByeC1KLDKf1ZDJIrdeciRxGfklFZYmpwaO2Xsa8wbNqCEjH6Ary5Y3u07OYfgfYaMBUiY4ov1w0W3qdk08oPzwQJPoDPW4hp/XhZh6chSKEaawFcuwGOBs6/3CWFcmdhJwA/fnBP2QdY7oIV0GT4QzHKDP5D3PcCJy5RFEqgJQ5Jip/DVKjFGnO2zzFUi+hsD/6GaCP9nSUjcF7hEIiRn9DSYBdySEEeoV+oN7574lmptmjFSUaU6qb3dNqbiuKMqao0nQiYgyPMcs0VdWEBeRtSTIiMdHsOimuJu2VCCu6hQoZ/UXNhHqd8d3iTNUAW6G0JBhcJ6V4bAz5Ylak0goIuYKiv1Xa94HUL5yL76VYNTXafJQAFt1Z8yzjQb1dynd48iulVnVYlGqj/SQSIaMO5ZjCwsnsMdnfA/7+lenleSvLFWIbqMxo/93jIr+SrJzwUdSYlzzF4mVgGyYvLcsp662yLFV4e8n5cVib7JR57kyY5bJ2FXhKdtbO77HT19aWN/C3d2wCLTIXnqplf6SYX4uJY90DrwZjAzQjbQtoO43BZhWGkT6VIlpCHEeWgDNGSHReV74ZWUbnxKn1p+oFC8EkXCd9mEmsXLFUQk47O31qV29udnln5ASNV4unALkPMqKa3ynl6bDdvIW1igETszXD0aCVesR+qhRaNnO5YDtm8hLgvC61bebwhR
 Qo9UIHHq
 jSJuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap calls ksft_set_plan() with no preceding ksft_print_header(),
so the "TAP version 13" line is never emitted and the output is not valid
KTAP.  The sibling uffd tests (uffd-stress, uffd-unit-tests) print the
header first; do the same.

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


