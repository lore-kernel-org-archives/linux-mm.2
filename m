Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E903C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511496B00F9; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2146B0100; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8126B0101; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8956B00F9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:10:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C70412035F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:57 +0000 (UTC)
X-FDA: 85092501354.07.0569A07
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id E42C48000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTQihTeY/ovliGutBkn9bHrjlC0qtEgw7nmEK5xgxUA=;
	b=F/MZw2+xAIfcWU+okDFwsFPV3Nlnnq0csl3/HFZnLqTM0/lD4pnSRhuzI425qYrrJqQkj2
	91DHM6U8EFgWeE+8yPxvIS3M0aN9+XHEfvl3KcqhgiaKbvoof4sYJQQkbnfzFBfqlN5RzS
	jHIBH6/u6I0/KBDno2Js1Mm1q1DosIE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536655;
	b=aJ25++TW1rEOJOT5FAf268C4x35BRXtviD0Cbdo+OtY+Nb4JPe7TlPYnvsjneaIHPtyedJ
	mkzma8SVWEIX6vr9lrF4rpojGyXA728htQ4e3RplFJdP1jBUYVCXkLUZ1mb54oi8sSn4DE
	6FWHxOO5yI5vbaI99KGldEJ75sdfaig=
X-UUID: d9458464964611f1aa26b74ffac11d73-20260812
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
X-CID-O-INFO: VERSION:1.3.12,REQID:cea930ac-079f-40df-8e01-cb07d4516171,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:cea930ac-079f-40df-8e01-cb07d4516171,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:c1b14ee53eeb8edb92911d479d49e75e,BulkI
	D:260812201050MG02R5FB,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d9458464964611f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1067541705; Wed, 12 Aug 2026 20:10:46 +0800
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
Subject: [PATCH 3/3] selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Wed, 12 Aug 2026 20:08:21 +0800
Message-ID: <20260812120821.523860-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812120821.523860-1-husong@kylinos.cn>
References: <20260812120821.523860-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wqzgzhuzqpygjj6g1f3gdtte1xdjiq9u
X-Rspamd-Queue-Id: E42C48000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786536654-873072
X-HE-Meta: U2FsdGVkX19VLUWEaqJ2lFW7M4y/10eKUjNg8FRg7UbjhaljmfUy3Ju4/h3eCILKOFkafv8/QPgms/F242TyC2gVRYsMNYWfMp/ZVibQtH+HSe8nwlmVxwisV3Kf3H0/8l2ErYEP75CqaQYAeYVxyzTztXbUunw00o/QKzBUv2QJZjJau52nacCymY9qCwRzEhJFn44pJRNKTvxqaszSkFEZ07OcAvrqSPVRmaVAGSqTHG0OzyedFUgGRpM+8/CjzKUyLm1feOKv+YrAOM+NmzRO8Ub5MBVOa+adI+RLglK9RlLLBTahBdfwkBSRULquGZDCwHmkOI2WeRS0CXSLFyEFEZ7vajxLceKLRddxFirVMlfvksYPnYOZlNbDHv62ZCoq9qkMVJVo4pZSvLJ1YosOpvdZ5lMIE9oH7fXM7bg+HTSbU0CSVNUptZHmFZfPfC+CmfonZmnotyoCBiWmftVOVDazMB8mFe6dulXRN+hWdEprdDtyvwfeujAOejbE+V+9CnEksBFVxByp74xp5Msjz89+CpssiWHNp+/Mg982Qr/a8RHhRH5YwHboKnBIpFb0fPW06eSGpCJ/wEalzOvBF0fd8js7MWvoF4swMfWK15UmOKYoUy9mSfiNH3wBDnqa8Gd/Nkx+QxvTERGnWSHY8ISHZiNUfiyURcUlHQHM3QYzxvH2WJS8I1Ouq5e/UwdoqCGsOb6yLTv+8z46AO2KScAwvDBsKkZO1INcIegEUbogFfHEYcMj6KygAOxf3q/Yhj+tLcXzU5vTR/gnn8gTKPxgw/osynl0JftFDec9t9XYWjDtDKRHbjs1JztyAN848tDMMFViTrsdytb5S6Lcl8mCNfTBBY2car8i9YLZpxkn4YcOAZsMjWyySAooaZELLYMkvKH/cz3JMhMjUJ6nvD2AHTp/n6kTIC6Hf4wiS4L5+h/ZK5uU6DGKwlIHbtd37Qalt8wrHf0Q58F
 vWNbvsBx
 SGzumPi/5UAG3YaXj8w2EngjPCJYmlfWDI7/9R0yUSDdKOOWnYqIq4XQ+0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1 and
0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
finishes, silently disabling soft offlining for the whole system after the
run.  Read the original value before the test and restore it before
ksft_finished().

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 .../selftests/mm/hugetlb-soft-offline.c       | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index bc202e4ed2bd..35dcf661b091 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -99,6 +99,23 @@ static int set_enable_soft_offline(int value)
 	return 0;
 }
 
+static int get_enable_soft_offline(void)
+{
+	FILE *fp = fopen("/proc/sys/vm/enable_soft_offline", "r");
+	int value = -1;
+
+	if (!fp) {
+		ksft_perror(EPREFIX "failed to read enable_soft_offline");
+		return -1;
+	}
+	if (fscanf(fp, "%d", &value) != 1) {
+		ksft_perror(EPREFIX "failed to parse enable_soft_offline");
+		value = -1;
+	}
+	fclose(fp);
+	return value;
+}
+
 static int create_hugetlbfs_file(struct statfs *file_stat)
 {
 	int fd;
@@ -185,6 +202,8 @@ static void test_soft_offline_common(int enable_soft_offline)
 
 int main(int argc, char **argv)
 {
+	int orig;
+
 	ksft_print_header();
 
 	if (!hugetlb_setup_default(8))
@@ -192,8 +211,13 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
+	orig = get_enable_soft_offline();
+
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
+	if (orig >= 0)
+		set_enable_soft_offline(orig);
+
 	ksft_finished();
 }
-- 
2.43.0


