Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075E5C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 839446B0341; Sat, 15 Aug 2026 04:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8112C6B0343; Sat, 15 Aug 2026 04:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFC76B0344; Sat, 15 Aug 2026 04:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5228C6B0341
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:08:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D13FD140321
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:08 +0000 (UTC)
X-FDA: 85102775856.13.86008C0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf08.hostedemail.com (Postfix) with ESMTP id D780F160006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786781286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NOESMuCRooVC4iczNiA0wcrFKWUXpQNEe7ijSb7ZFFk=;
	b=sYqDRBGYjJhKwMrhwTKESR5/G/SCkoGqgipvC6S4y17NethYfvDBUF8kmTrjn8msCt32Y0
	IEYaQNb2GrCD2gFRlszm2aLrlFxlFvYMMAyqigq/G6O9IfYtDgogoiZfEC4pJlMZDzmbOp
	Bu85w9XiIJ8Rumrn8wZFmxzvKAGPgfI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786781286;
	b=wRr4+GhmZR1i7sFuu/sk+G5OpIhFU1d+FvQMHTi+I7f2kzk7z/++qj82ow2IaS1fvhteR5
	rxATCpYsfpt6d+MwZ+9tNZuLeKrX52D+jr4j+cZGIDZYp7J+L6ulxzSP01qRtmcQ+U7366
	VkZN+AJoFrSXiYrp/pzkZB3cEaSJ7JQ=
X-UUID: 6b9018d0988011f19a56ed5b684f684d-20260815
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
X-CID-O-INFO: VERSION:1.3.19,REQID:ddb5f0d2-0a7d-4394-bcbd-49de45807dca,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.19,REQID:ddb5f0d2-0a7d-4394-bcbd-49de45807dca,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:7db8b62,CLOUDID:10c0d73c66badb71245b2174fba588c3,BulkI
	D:260815160800X5W5ZYME,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:1|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6b9018d0988011f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2070273122; Sat, 15 Aug 2026 16:07:55 +0800
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
Subject: [PATCH v2 3/3] selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Sat, 15 Aug 2026 16:07:16 +0800
Message-ID: <20260815080716.3596514-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260815080716.3596514-1-husong@kylinos.cn>
References: <20260815080716.3596514-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D780F160006
X-Stat-Signature: jqehkzztn6i6ryk5ww9dbgas8xw6sewp
X-Rspam-User: 
X-HE-Tag: 1786781285-735050
X-HE-Meta: U2FsdGVkX19Aiov+ktGigDbCgS6SE26wQcrj32fblgrxsZuO+Y+M1mUTcqfwQ/1A4fC0G8OML2QGmvCvvgZ9OB1+dIrl9kkfbldRAn5X6TMOusL9GJOeLK4YdewACmoxL/6gRaOK/7wfv/A51gwDEV0n1+AV8ENpCKmPj4WrqX0TL6+vTzDFEB7Sa/jWjnXdzuaLeTOvJyM4eDOz1IeEBZ1XV98RjE10Wgbu5n3L+mvLKecsr3Rzo4Ohy0BOfVrDupHyTWhxc9gtFRfPsiS4h4HqAtrVfjKX3ByrWHqIaxq56Al0U9Ca61UErzHLzuA/vqSAYPq6VKHrzzneS+vAfdGdooyjdrSUbY+QbczDE1R5nHN6VAKDtYPuIr1MiJ7TLW7Im6uEXzzhjrrMlkC+LRa8ZZMNK3yX0u6XAka11NlWwMNWZ3TeNC2ApgdRe2zUyQXJOm61oz4WgyzFm4y0W7Zq1nts/tM9YVj/8N0klg7tOBVHhlac5fBkWMyPsWqPuYCYjCg2DGw4EcJS2/rvEvfZWL2vTB/7a8yigb4dfhdfnbJjDi53iyjBUe8sTQ7cOtFNkUMqx7J4QoZhwoprNZQ/KIkTQXgGZtqLjYtkK3tuX0yXsNNI3magEG630qIQG1oBAjzj/HNnNCTN1ZndtAG+RRH0Ccf/QEpmu7Kv4JUZSL3QX0PgqibZ9EHilMou4THz7TNakJKUiqa9N5HcXe5qm1Q3ctqpfiCHWAKeEqYV32Ymn6ia0lgmZH2ZNJpeqyJ2F52V1aASzJt0Vhi+vhSQ/RFUUV1znPDSs6IrQUD8gcpz8uZqvtGW4mxxcJb1/OZGy0Q7oUudEs4bLrnJHnB36xgfXtd83bg21VnJ8YMzYDXtlY4Lvnp0ZTYNbTC0Fo7p6AGozCYWd2G4tohDw6RjoRio8RqckF4hElBKrShFQQpodKfk5Kw/Xyvwx1ajSlz7JNMsKj+3aC5Cmic
 fcNuMOdT
 2OUh7uUS50QFXeYwj8ppRA6vzykkPema8+wwx69HXRQY0L+sVacoZeu/3QA==
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


