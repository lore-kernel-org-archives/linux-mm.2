Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86035C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAAF6B0099; Tue, 25 Aug 2026 04:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0F36B009B; Tue, 25 Aug 2026 04:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1892D6B009D; Tue, 25 Aug 2026 04:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1E336B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:59:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BB391203AC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:59:12 +0000 (UTC)
X-FDA: 85139192544.17.1BAB428
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE8BB40006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:59:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bGauQNMhLp6g1k7M5O7gIqjRxqEHKwyV5dSFW1E4Fxw=;
	b=yy6bDPCu8KJXUwLhKD6nAsXZKmfQrzjSbG4hhZkEzqtRJ6Gd8MLqaln2XKEnZyJX1+i21i
	MM131H3HZzsaZCfv4Fqc/xt03LOKGxYUWJnrLRQvqnzKufxdT1tQe4madyraFWDIXEWOYj
	FjPOraxOjvFBFEZ6or8ziITQu0vHZtQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648350;
	b=AQQfmLFDn1PgDYbByugwQqv/neiaPXPkhUGiTNiX/7fGeFulrbTOtFaoY02AkRMLMeRwsi
	7iJB4U6LX+4USBzP9ENyHdS/Nm1X4OQ8N8f7DVOmo6sr0H7xgfsh8OHhuA8Hf43cg+zSFs
	AR47kJ6PHViouWwR9YvuWcQ0gtmh9OY=
X-UUID: 3638108aa06311f19a56ed5b684f684d-20260825
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
X-CID-O-INFO: VERSION:1.3.19,REQID:82749ddd-5abf-47df-87ac-e335f40255ec,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:82749ddd-5abf-47df-87ac-e335f40255ec,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:9f4af4901fe8095e1c04f2e2c1a67177,BulkI
	D:260825165903ABRGIBZD,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3638108aa06311f19a56ed5b684f684d-20260825
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 727345008; Tue, 25 Aug 2026 16:58:59 +0800
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
Subject: [PATCH v4 3/3] selftests/mm: restore enable_soft_offline in hugetlb-soft-offline
Date: Tue, 25 Aug 2026 16:57:56 +0800
Message-ID: <20260825085756.63030-4-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825085756.63030-1-husong@kylinos.cn>
References: <20260825085756.63030-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE8BB40006
X-Stat-Signature: pauns7dq65inudd1tz3podkzqb9j655b
X-Rspam-User: 
X-HE-Tag: 1787648348-503382
X-HE-Meta: U2FsdGVkX18UJvV3t94iedqTtSsjQ4KIbFag8ey5zVl6lyCB3nGi/OhXl9R0LkYV/tmZE0xCLbOY117j1xCJ6xxzVqsguSA2KEyJyrQLt6pK4R8dtdoHt76NheMKKck6ZWxPqEJZhISKvAGd8QGVvH4PfTGcNp3kB30iuHmS8DvteJjzgKmluXlNwlDlreDcKeNN1/xQR1Fr38j3r9FH5yKHxzvpTwgVHvHkXCbnyiHsO4nTQYLJmPbfM1plR1eJyCSlVEjV9yaaooDMw1LDkkaBwMQo64epGIB5FQzcaCBdQpfWZ1BGqdqBbb9s3Kh+SIoR1I1jp1exp8iz9NSKw635kKWevzvBQOTX5LEQwKEJKZGiILDJgPbDpxRNVPlWbj3VvnayF63Ir+3L7nHhNmTUy6FE41p1vYG/Y7kA4MZw4zPvWWpypZ/PV2prvmWIhLbRqe1g3ONTyXuEfZL6NiqGdWfdPrbw12Vh5CvzQfTnRunBHVHHkyUTSbtKel/0oKa4ueTR7CVa6EFWck9YPOQOK27GMjTnd8Ea+IkhIsjG75DKrFVSFaPYBaEk0tQ1OC5YcOB77dbJ24K7Quwvy1F6vodL95pzWwk+uTqYiSOaqMIKkpbVMlgWAnexhau4vLWqemhF43JbvDZYscIPl26u78agd70+mxJ3FvkRpUsn50AdkW93KRw7eDk9QixQraMxE7yYZrmsD0dDJpfT0HlU5f9zr/PDBkV3286uIO4ytA3E9e8nzpWJpai0QjuSDHlUabVBAD6XkDd7YksHMrQRCXJK/gZeH4JFnCIKbtVF+QQknYKTsaGNm3VQ01CsGsFTxL+0E7o7dL0OIBHtHsYXtgpMeXB1J0QL6wdiOEX2djWJz3JXGnRCuItmPcWhYfhfOPoKdY/J7bExsul6M/8+5GeLZ5WQFAKvCW4p+dHFkdkdvMXePj4Pb/GYYSEXYiSNVmQzVDD/ilAwrRz
 nzLYMtwH
 B69Y3Qcv/3Mj3qf3nbLLAebUtFV9Kz9A80lDmQ88HOqKjuSwfZfqf4+r+zQ==
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

Save the original value before the test and restore it from an
atexit() handler, as hugepage_restore_settings_atexit() in
hugepage_settings.c already does.  Use read_num()/write_num() from
vm_util instead of hand-rolled popen()/fopen() helpers.

The restore handler must not call write_num(): on failure it
re-enters exit() through ksft_exit_fail_msg(), which is undefined
behavior from inside an atexit handler.  A non-root run hits it
directly - the restore write fails the same way the write that
triggered the exit did.  Restore with plain open()/write(), best
effort.

Signed-off-by: Song Hu <husong@kylinos.cn>

---

Changes since v3: the restore handler no longer uses write_num(),
whose failure path calls exit() from inside an atexit handler -
undefined behavior on a non-root run.  Restore with plain
open()/write(), best effort.

 .../selftests/mm/hugetlb-soft-offline.c       | 49 +++++++++++--------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
index bc202e4ed2bd..4af9d3db7b5b 100644
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
+++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -11,6 +11,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <fcntl.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -23,6 +24,7 @@
 #include <sys/types.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 #include "hugepage_settings.h"
 
 #ifndef MADV_SOFT_OFFLINE
@@ -31,6 +33,8 @@
 
 #define EPREFIX " !!! "
 
+#define ENABLE_SOFT_OFFLINE_PATH "/proc/sys/vm/enable_soft_offline"
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -77,26 +81,29 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
 	return ret;
 }
 
-static int set_enable_soft_offline(int value)
-{
-	char cmd[256] = {0};
-	FILE *cmdfile = NULL;
-
-	if (value != 0 && value != 1)
-		return -EINVAL;
+static unsigned long orig_enable_soft_offline = -1UL;
 
-	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
-	cmdfile = popen(cmd, "r");
+/*
+ * Runs from an atexit handler, so it must not call anything that
+ * exits on failure: write_num() would re-enter exit() through
+ * ksft_exit_fail_msg().
+ */
+static void restore_enable_soft_offline(void)
+{
+	char buf[24];
+	int fd, len;
 
-	if (cmdfile)
-		ksft_print_msg("enable_soft_offline => %d\n", value);
-	else {
-		ksft_perror(EPREFIX "failed to set enable_soft_offline");
-		return errno;
-	}
+	if (orig_enable_soft_offline == -1UL)
+		return;
 
-	pclose(cmdfile);
-	return 0;
+	len = snprintf(buf, sizeof(buf), "%lu", orig_enable_soft_offline);
+	fd = open(ENABLE_SOFT_OFFLINE_PATH, O_WRONLY);
+	if (fd < 0)
+		return;
+	if (write(fd, buf, len) != len)
+		ksft_print_msg("failed to restore enable_soft_offline: %s\n",
+			       strerror(errno));
+	close(fd);
 }
 
 static int create_hugetlbfs_file(struct statfs *file_stat)
@@ -145,10 +152,7 @@ static void test_soft_offline_common(int enable_soft_offline)
 	hugepagesize_kb = file_stat.f_bsize / 1024;
 	ksft_print_msg("Hugepagesize is %ldkB\n", hugepagesize_kb);
 
-	if (set_enable_soft_offline(enable_soft_offline) != 0) {
-		close(fd);
-		ksft_exit_fail_msg("Failed to set enable_soft_offline\n");
-	}
+	write_num(ENABLE_SOFT_OFFLINE_PATH, enable_soft_offline);
 
 	nr_hugepages_before = hugetlb_nr_default_pages();
 
@@ -192,6 +196,9 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(2);
 
+	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
+	atexit(restore_enable_soft_offline);
+
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
-- 
2.43.0


