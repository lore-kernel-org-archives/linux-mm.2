Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFB7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B707B6B0095; Mon, 13 Jul 2026 22:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B215D6B00A3; Mon, 13 Jul 2026 22:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A375C6B00A4; Mon, 13 Jul 2026 22:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 719AC6B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:15:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3735A01E5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:15:47 +0000 (UTC)
X-FDA: 84985766334.08.37F3D71
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6052C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:15:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Tiz3sGtDu05e3D6RHLvd61lfs8hSAGA389x4mhhmXVE=;
	b=jwL/JeB7OOf1C9N/pW0+NxC1uGKyzmQM5IMVcA45HUWofby48ngtekbmIwz3vkWuPMSZxY
	3PkifW78nuKA3cI/nKl75qDa7CI/8SycMYRN0eQEM/xNwm/mJQTGaU1venbD+Pbzk7SdLa
	D5WmNorr1+gRjlFxFX9Y2Z9ZT2LbLOo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783995345;
	b=tHtcByEPaU0Xj+mN7ixNnrnyWvSAH6LSWGZA7/grNLLH0IQxLK+ymD6Nv5TXVQ72EdCYmm
	1FBdKuPIP61nZqz6JSSKL68vKyaWwvznAx+8S93wUp56u5VL8Y0Z+i+YtzhyzJ7AdoRCwm
	ZfW9Ia3/7O/gpLcodJQlA+KrNFdI1M8=
X-UUID: e76a86d67f2911f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6a112b9f-3c77-4d5b-83d3-c1d74f8425f0,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.12,REQID:6a112b9f-3c77-4d5b-83d3-c1d74f8425f0,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:e7bac3a,CLOUDID:dd181884e857344a438163946bfe7c5f,BulkI
	D:260714101538M9HF7TXP,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e76a86d67f2911f1aa26b74ffac11d73-20260714
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1422662319; Tue, 14 Jul 2026 10:15:37 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 1/2] selftests/cgroup: fix missing TAP output in test_hugetlb_memcg
Date: Tue, 14 Jul 2026 10:15:11 +0800
Message-ID: <20260714021511.1063700-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ha3c87sztfxbesg6fbpthzuzebx3zi6
X-Rspamd-Queue-Id: C6052C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783995344-151460
X-HE-Meta: U2FsdGVkX1/aa3dcv7e6i1zwAn9uvN92ZF2wbk9EsL0BvpQsSBsLZUhlweZQzGKflfZmZF4v1IKH2UjrkTtdBoJejvReQL7YKv+KdwkzxAQMDeWturtEwIlF5tzZiZj+aFJaIcwNZHzYra4f+jeKovaAU3xR/jggpYa4Afy15LFOtr0a9qVDRn/QFfKwMG9etizjn6MvfOk23StAMizYpVqtTNShDUVJKw4+vZu4s4wddrnavvlS6p8xFpzh/uZkWm1GQ2Qcn2HGNDIRsgx592850GWGRJM8Fcp4iHq9Es0NHh8u8KhsBfGmktx7jA59tZxLT46KyfUZQK/+yPpWsDAR141zE5b2tZ9pwV60g1qzrSC0PLPrrDIkk5fJVvcvpDRUCtHYB6ihCUr1eiSNPSIxtEM/OxioeGzY/C5btVjRNcdDaEzxoTdg+un2koUiOOpA0RhLdD/zCV4gc1au9nMvtscB0SBQSNBvsSpO/fHUBf6Sz2ISEI9Ak2dzWgK0hAflXTQmjggg/DjHpk9UC2MswLVTEKcs8J4rf+yqWHwviVt48h/LWnA+JRQm6XwoHLlBidgmTNN9G0M4VFMwiU04EKW4mIgWYh3d26/V1nrXYP0WisT8unzIM/kHBHphgeJzLhes8sPAUfcDAaY0+OsZi5qOOJRoSMfeHqWk0M47QowQ5W/5eU1Hmv3/rCv4+XYpvMpIk/TdkCghz2o+ELS5XQ5spSwI99xq7LAa2GWRKtLkfJZIa9FjAcdqRQIare0kq5eEQ3RTG5nuFegpPA5Sr+d0+ViBuS8TMwoeim8ZoCrGbSWGGth8v5sMjBrq+zQ4f2MZpDTVhAGMnI6bqd+0zOR6bveXIGN9o/EhbRDGinCdzynbjHJGziC8zGo8hycfu7xl/8ONw6CfAG64zoxqmJ5MfJukn0zZdu2WXRlDn/ppxMiISWFPpztoeTwEDEFvCOH+mHP+/W1cX4E
 h0fL5RGN
 yXF3a1qRTKsJCXte7dnxoMrsed2ApdIZmZ8IxAyPy9E1o83mz0hb+Chonfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

main() in test_hugetlb_memcg never calls ksft_print_header(),
ksft_set_plan(), or ksft_finished(), so its output has no TAP plan and is
not valid TAP, unlike the sibling test_memcontrol and test_kmem tests.
Add the header/plan/finished calls following the same pattern.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index b627d84358b1..8c5aced813b6 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -199,7 +199,10 @@ static int test_hugetlb_memcg(char *root)
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int ret = EXIT_SUCCESS, has_memory_hugetlb_acc;
+	int has_memory_hugetlb_acc;
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	has_memory_hugetlb_acc = proc_mount_contains("memory_hugetlb_accounting");
 	if (has_memory_hugetlb_acc < 0)
@@ -211,7 +214,7 @@ int main(int argc, char **argv)
 	if (get_hugepage_size() != 2048) {
 		ksft_print_msg("test_hugetlb_memcg requires 2MB hugepages\n");
 		ksft_test_result_skip("test_hugetlb_memcg\n");
-		return ret;
+		ksft_finished();
 	}
 
 	if (cg_find_unified_root(root, sizeof(root), NULL))
@@ -233,10 +236,9 @@ int main(int argc, char **argv)
 		ksft_test_result_skip("test_hugetlb_memcg\n");
 		break;
 	default:
-		ret = EXIT_FAILURE;
 		ksft_test_result_fail("test_hugetlb_memcg\n");
 		break;
 	}
 
-	return ret;
+	ksft_finished();
 }
-- 
2.43.0


