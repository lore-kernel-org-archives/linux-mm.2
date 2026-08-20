Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C91C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69A56B009F; Thu, 20 Aug 2026 02:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45EA6B00A0; Thu, 20 Aug 2026 02:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D276B00A1; Thu, 20 Aug 2026 02:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87A166B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:17:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12384140427
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:17:16 +0000 (UTC)
X-FDA: 85120640472.29.50E1240
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 90F60C0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:17:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOCVH37HhWFbMC/CfqAxSYNPrq47eLe9BtMDFYGpeU0=;
	b=ObtDRlBrE8moMn6IsXcUFlNLtFCi/sXatZMAwFNqG4s8f9Ra4+DNN2+UJp+n/YR0APoTBg
	erd7kk1r+ROjs8uCigK3d0mKyocqUtrORkkcSkQt9KRMP+DgE+jtR1DZJ1WGc7lEBREpfK
	FwiD6+i3Dp2KB3d3aJcnN1y9LgGIhiM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206634;
	b=Hrk9HAa/QJ8r/A6CefHCiPB7jJEg51iWA61zf0p32BoVuJAfOOEI+AOhH1d6x3wHx8nGNk
	u1RDJLhh/oUVsoC8qA7bwoZ3/PC2RyVdGb6IZuqHio8cqXmZVp1PDGVignlIousAd+lytE
	AHmMpVpp07Zs/Bw+UL517Px9dpRnEUo=
X-UUID: c3c1e7c29c5e11f19a56ed5b684f684d-20260820
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
X-CID-O-INFO: VERSION:1.3.19,REQID:b274253b-08a4-4604-ac07-d8be0af3a645,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:b274253b-08a4-4604-ac07-d8be0af3a645,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:4b1da2dd0a1d0a7719b55cecba60d3b5,BulkI
	D:260820141707XEDMW458,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c3c1e7c29c5e11f19a56ed5b684f684d-20260820
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 831980419; Thu, 20 Aug 2026 14:17:05 +0800
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
	sarthak.sharma@arm.com,
	usama.anjum@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v3 3/3] selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Thu, 20 Aug 2026 14:14:26 +0800
Message-ID: <20260820061426.356869-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820061426.356869-1-husong@kylinos.cn>
References: <20260820061426.356869-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 90F60C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: o67cdubshohbe19ssx5wcr8c3xk8qahf
X-HE-Tag: 1787206632-747586
X-HE-Meta: U2FsdGVkX1/Ousabf9BX5UfRKdfFktrLr1PkROzLDTSqqPsUbkPQUIiYT3Kke6StSVryvteXMpo3pZO6B8Dx3Kr3RgW5RGp8j6gU0W5R10megRxDcMMj1UrdUCLYekuU7VJmd5KPLS1mysytISRmJzsJwgBOeIAWNR0FiILuLF8QwJS6GVVfzCUkqoa3bu41leveUvfBN1oPwJs61tcUL3IwZJyeUNABazTshl9xVsdEzZFbIgowyfiLoqBnIgQaBFh3yy2GtXeA8TjPZC6p0oJsj/WV2o2vVEIW83FYnhPstka8sWu64oNcxoUdx2XipirvSykzWTh5xAQhvF3+ZVYtakSnDjSZJaVqAiWjxA9cgU+ehsEtk7laiIKvuN1gs/HMNHxKoefKfeTaeyl5NgTeBNjTLWN4d/yn2yXkCkERpNKEPXqg6TGN/4ZZNUTerBs5Ns+hiRGjR6lRBu5XeuDOA/F6NHU773z4ifSWY80Sq6+TVE90/A9XhzT8hWj0DOF0fqblwGAA+RiAgBWatEO9g6fRZ7eaYQCO+OUM5fs/pfocEEcTVATR7rQtq8crQPT400Hq1ffXMKK+7WGw4NSdLBeSeJa1AiDj6qKHMG8XDhZvsaRKoV49TRqeEWwot3T0u0jaOr8R58LP8wCnXM4gqEQBUJUxcXGQPqI4yJglMzqu7JcpOGirMp3xVi3JRCEuQkYxBgoZA6PMF51Vdf9l0mK1LdLCE4uSYRlFyZgQHwhl36H6s3i4/JVYW5UhzIZIQKpQoSpp/iDfWqa7W6YTaIhXmVM5ECSYr3fh2yK42gRHHp/0E1HKd0iMoasj/PCKzxhfJYmNrsBNtSHzWPSqcyUOinWY8Ql2mDDmw3V1xBREPF02nFmdyAO10xwQAWXYKLv+B6wPDFYXcODe7f0OzNHo2u/09iW5T4k1XgKimOiWyPu4XeoTaYoO0vzWAj+rQ/JyCAgYMWfNNPB
 XFiB8BHa
 N7cU6ks0b9D+1KQd7jRrCMZSLV8mHLr+hsQOUXxeADGRgnWxHqL7CqaRUGGwKKmSKMvP4/L3coa/WeQBdUoRzln9f9s/L/2zn1jUwczGYt47zXZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
finishes, silently disabling soft offlining for the whole system after
the run.

Save the original value before the test and restore it from an atexit()
handler, so the sysctl is also restored when the test exits early via
ksft_exit_fail_msg(), as hugepage_restore_settings_atexit() in
hugepage_settings.c already does.  Use read_num()/write_num() from
vm_util instead of the hand-rolled popen()/fopen() helpers.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 .../selftests/mm/hugetlb-soft-offline.c       | 35 +++++++------------
 1 file changed, 12 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index bc202e4ed2bd..86259921d54c 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -23,6 +23,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 #include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
@@ -31,6 +32,8 @@
 
 #define EPREFIX " !!! "
 
+#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -77,26 +80,12 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
 	return ret;
 }
 
-static int set_enable_soft_offline(int value)
-{
-	char cmd[256] = {0};
-	FILE *cmdfile = NULL;
-
-	if (value != 0 && value != 1)
-		return -EINVAL;
-
-	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
-	cmdfile = popen(cmd, "r");
-
-	if (cmdfile)
-		ksft_print_msg("enable_soft_offline => %d\n", value);
-	else {
-		ksft_perror(EPREFIX "failed to set enable_soft_offline");
-		return errno;
-	}
+static unsigned long orig_enable_soft_offline = -1UL;
 
-	pclose(cmdfile);
-	return 0;
+static void restore_enable_soft_offline(void)
+{
+	if (orig_enable_soft_offline != -1UL)
+		write_num(ENABLE_SOFT_OFFLINE_PATH, orig_enable_soft_offline);
 }
 
 static int create_hugetlbfs_file(struct statfs *file_stat)
@@ -145,10 +134,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
-	}
+	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
 
 	nr_hugepages_before = hugetlb_nr_default_pages();
 
@@ -192,6 +178,9 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
+	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
+	atexit(restore_enable_soft_offline);
+
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
-- 
2.43.0


