Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31074C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422766B0095; Tue, 25 Aug 2026 04:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC026B0098; Tue, 25 Aug 2026 04:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8AB6B0099; Tue, 25 Aug 2026 04:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12A436B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:59:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28C1BA017D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:59:07 +0000 (UTC)
X-FDA: 85139192334.22.BAFA31B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6CBD40005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:59:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648343;
	b=gXTAld1ImeQbabymQU6i/mNx//Ymiu3BMiLjLk5hWM12G/CoM7ABII7kcPPH7ikWDGQpFp
	vWusrckhb8c+YT8LUDaTjCdk7Bg0BBNm/EIUqwZ9FhGAdpZ/JIIZrzRRqo0laHtHo5ZTSH
	irhkstRGFXMqRE36b/m57iVuLFNTM04=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=96NTti9PVCHIkul1Gb1Ocp4p8fsVJSgQyO35/15T/UY=;
	b=xQqVURuDDI7n+sLvLbd1zP/0qoW/8v4Atqj2JjhMiKYq6AGKQ/0UH6qytH4Sof+huaP6DP
	QQzE5eeo+jIAYQrBOyadYUHiDx9ERpUMEKsmCkjvJv8mYZj1X+Z8/li6MuPLJdgZO4j+ZD
	2CYrn4a5fT04X46q8+shcOJE7NhCg2c=
X-UUID: 31e259c8a06311f19a56ed5b684f684d-20260825
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:c80b6f39-c982-4c30-b324-adf35004c805,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:c80b6f39-c982-4c30-b324-adf35004c805,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:e2087ae7da2c6fd8314fb0e0e8f1a487,BulkI
	D:260825165857GUSL112D,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 31e259c8a06311f19a56ed5b684f684d-20260825
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1638996277; Tue, 25 Aug 2026 16:58:52 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	usama.anjum@arm.com
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	sarthak.sharma@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v4 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Date: Tue, 25 Aug 2026 16:57:54 +0800
Message-ID: <20260825085756.63030-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825085756.63030-1-husong@kylinos.cn>
References: <20260825085756.63030-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6CBD40005
X-Rspam-User: 
X-Stat-Signature: xyytkoin3saqcd7zqqy57i83cehj1d3x
X-Rspamd-Server: rspam06
X-HE-Tag: 1787648342-946499
X-HE-Meta: U2FsdGVkX186I4g80YTBu4cb+chS3Si9GbQAGoXfAyaOdRYssn8bBZgMmAXeKiA598mOvnpkt4xFFgeB0O9TUW5Bn9Ir8DWTyVlNnBTAkdlj5l6F+fyR3BFaXU4lcvfH/jsTKHBhBPhNrKXxIlJ77k1O8XL1gDNSNfuG19IinjnFF4TLMwb2MMWPyb70JyjfIri+NrJgZmHYjnaq0yGHxscpQBI5rFdGta0YO0cnt6IVQI4/uJBczM4T3CyUVf02RmEAjetnhE5U3thQ9+YH/uSwpvSgabe1DIl9G1zDoSobmNyktyZoMcBEJchaUwGR3smZyfblzYrDGRC3KgEaRlzemtnCiPBm8kHchG616kZ838p3Nnk+MElNeEC6akDuIh9G08hIuLJGjgZUefKTfhGiLZqpFiwnQet/5jzGCyHWHAdkFbt8jbSWvc08RD5C2/pr4bzDlISX/2eKHl+JwclyTmBGgHkhm1U8nuP6VCraWqcJEZsIVw3/a154Lnj5etaY8Ya/Gjr82w6GaD7E40VSEjt7HaqQuE+8phMVLQXpptvZF/7m5nMlls1kolH+jbFyebY79NkvdKRBdN7i7Wd3z/GNfG103HWf1IrTMlO0ouN0DCN6X+YtcNMDkLUDuD8XDIjnAV0czcVgG5IA6clFZ9ApgxySd9YRDy01zOZTtMaFPEO/RRkfqXCx9wGyDdrLuKSY/K1jiK0iXekjLYrTS8WKLV+CYtQgHKuK6I8SJ82yeMHuzZ9OjWMKNT2FfhAl8g5DMX2ju1BcTOGRvtAYLpaLZdw0wQv6WkQzPX3j1KCguDJQJ7+BbxuGxhyX+q+ftvx+kHRPp3rMm0XACMmSo9hQLew1RKPYVm+yNYLp15kVF7uKkG6IqUTao+LI2YFnqzL3WmeML8CPI1KtyVLMU8H2Q2YSJUJpP87Ktf4AtCZajAB3Vws78QBt6z2Qkpyr0qMyKgJNo81l8aI
 95/mrvUt
 DXfRyGzsWClXwcFvWKb+zEqnnTgW/EGi+9BoUv8hsnrDOcxLX+RqXSCimwcvUcJs8Y2yBb//FBltigEA1d3ElMwe5PQ==
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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


