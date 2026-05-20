Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C62CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B51A6B0005; Wed, 20 May 2026 05:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266356B0088; Wed, 20 May 2026 05:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C346B008A; Wed, 20 May 2026 05:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0704C6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:32:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 643ADC116A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:32:03 +0000 (UTC)
X-FDA: 84787281726.03.C692236
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id D23F840007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:31:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779269521; a=rsa-sha256;
	cv=none;
	b=pjJ3RzMVW3yCr0gc/3tziHtL/HZh2mSd4b2Xy49aBEv00u4F7WvUmezjiTOt2bmvowjYKr
	GYMwdbqfbDYfzsPiucjDWzT+/Tnffnnk4ZUxbdWT0WfjVa9DIBypcrgS6wmWHknKaL+AP3
	P+z73945RQ6C+EQFFFWvv1jxqiFRBm4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of zhangguopeng@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangguopeng@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779269521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IMiQ1+NN0oFyvWexYUw9rnyUuLwdqV3XNtE4X3Ne6XQ=;
	b=1Mp1dBnCmQu3BuuUkz1FKphkGSoh7CUBqElFYC2u6xoWU5bs7FxnJWD7T2frWOEGGBP/+R
	o5YB4dIEoepxS4C/KhoVD1xiE+p7rjiFxfY8+hrirJDRddUmp4UB8/p4UWUaldAFbpqhf+
	vFM4Lm9YwihpzYfgppLC1rN7dqotoHQ=
X-UUID: bcdc7526542e11f1aa26b74ffac11d73-20260520
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_CHARSET
	HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:8ea1c0e1-8084-4f84-8587-b02fe67b2cdc,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:8ea1c0e1-8084-4f84-8587-b02fe67b2cdc,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:a38dba02c14bbe1690276f6c3af2da88,BulkI
	D:260520173155BISL4B5P,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bcdc7526542e11f1aa26b74ffac11d73-20260520
X-User: zhangguopeng@kylinos.cn
Received: from yan.. [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <zhangguopeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1577218; Wed, 20 May 2026 17:31:53 +0800
From: Guopeng Zhang <zhangguopeng@kylinos.cn>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] selftests/cgroup: enable memory controller in hugetlb memcg test
Date: Wed, 20 May 2026 17:31:30 +0800
Message-ID: <20260520093130.490020-1-zhangguopeng@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ihift1c7oec46uzskkg7nq6az7tmkf1
X-Rspam-User: 
X-Rspamd-Queue-Id: D23F840007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779269519-120644
X-HE-Meta: U2FsdGVkX18a5oApUh/0oiwzPTMMRfP/m0cd7Owze4ZODFwAdj+1aXv47oSjxg7PH7nIeQEYw+ZQNd0eBQY5/9sWbN1Fasr5mvARAk3uOVep/eXNuXGXE6/Sc7hamJedLAK6P6hdYYDdv5FriWh1tPXacnmXpuP9x1H0YJXlhhvv8ySCMk4SVsw6LiBVICKq+OX6cr3zaq47PYf/6T8MMChn/WYBfnVVmjCoCmTGRuaSqkyhqYfMulkvu7885HorXXR5rqRWEmcKwP2I1kJ8HRZjMAOgEZVuRQTvEoIK/eTQtPsDr/piDyF3xwllJn2CQboY0wtpOmEFNRLJ+CtESanpZPB4ZnCkJ6eW27WaaVorjdKFnA1WvGTQToyCzjAruJEE+6OchJfeq1lDZ2CQwjgAaty/xLDmzfhLCZu12eg0/8SHOjD1N2d/Hf8uW12Qy7XX2DHZT38//Wu+wznRx6Nv3nbBRFWYtI9NnbAEj519xGaRK+8OWYY9/FODElh2xXv8XOraLMd5r0clVXu7zyQiepWbqqveMNTK1S/vIr/tC1SoMjP/nGmKvzPv99xbkKPY0EmD5oxH6EsEzMNS0Yv/oJ1JowzReRClR7LNT9zNnu0OsQM0Bn0HZPpbwOOVBe7MXGddPZJOZ0xt3rwEHlxhlsaHm/ptw1mvCEttzfuMAT/8f53kbYd0oMgtNmzURx4IPoGHGHNuFBCcl17GFm5EVzYY/55QkBHDdSxACn56o2dIQaQp55ASXsVYq07ncLHAYOTU3wGof8jhrHiJ+qa+cfIi1WporNj9KU+nvapaoNjKbLv+UqO4tFeC5q/FSm47kgmEDM4zaD6sU0EIVgbQa0bWNz9c3ybkWx21SJmyZEhVWnYm5Rzt56uKj400u7MraDUMb0lCSnEluycNuCFGqF6VBHk6a3cQ4k6fpArR+cpJzx7Ify/8CvRZaA/UCcQLIAAZ0qGf5tvxAGI
 qfPyH0wO
 1w9Is
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_hugetlb_memcg creates a child cgroup and then writes memory.max and
memory.swap.max. When the test is run standalone, the memory controller
may not be enabled in the test root cgroup's subtree_control.

In that case, the child cgroup is created without the memory control
files, and the test fails during setup before reaching the hugetlb memcg
accounting checks.

Skip the test when the memory controller is unavailable. Otherwise, enable
it in subtree_control before creating the test cgroup.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Tested with a cgroup namespace where memory is available in
cgroup.controllers but not enabled in cgroup.subtree_control:

  before: test_hugetlb_memcg failed with "fail to set cgroup memory limit"
  after:  test_hugetlb_memcg passed and cgroup.subtree_control contained memory

 tools/testing/selftests/cgroup/test_hugetlb_memcg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
index f451aa449be6..b627d84358b1 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -217,6 +217,14 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller isn't available\n");
+
+	if (cg_read_strstr(root, "cgroup.subtree_control", "memory")) {
+		if (cg_write(root, "cgroup.subtree_control", "+memory"))
+			ksft_exit_skip("Failed to set memory controller\n");
+	}
+
 	switch (test_hugetlb_memcg(root)) {
 	case KSFT_PASS:
 		ksft_test_result_pass("test_hugetlb_memcg\n");
-- 
2.43.0

