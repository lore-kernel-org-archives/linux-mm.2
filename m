Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD7DC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E263D6B008C; Thu, 30 Jul 2026 10:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFDDD6B00A0; Thu, 30 Jul 2026 10:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14CE6B00A3; Thu, 30 Jul 2026 10:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFED86B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:28:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5424B1C00EF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:28:05 +0000 (UTC)
X-FDA: 85045672530.12.FC8AA92
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 610B54000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:28:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of yijiangshan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yijiangshan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VEJHgPkcjCeU2vwKWA41QWNkffAhMg+Inc5vCE6Y7s4=;
	b=zOXOmfzb5AnjxRsgofO2/EuorvQJsWOwLFpetjOC/E3teWsbmsv07U19rRLeJU//PTia0O
	4r0NiZZKVpNjVouBTiTE5UsQX/4qqzJhOxElXP1IddcFCtmsvXwD3PWsKEjS8qSQcHmXcD
	cScUqbDmnV2CwQG1lOCLKDFx88pkp9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of yijiangshan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yijiangshan@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421683;
	b=RYOsroyqXrMK1teQQ5S5tYDwbvCnxzG/4kyNdaWEbzfoffohdD48SgG2odfK0JpdpJD9DM
	B9GvZKA2Gc7VU/jq9Zya2w2VIhAxxqTtVGQtpk2kTn+cD94+WXrEHxpplWDXwsj1E7rU2j
	MiW32eM9RwwHamRwbfbhuV06pFSxle8=
X-UUID: d781e4528c2211f1aa26b74ffac11d73-20260730
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:516c430b-7fe1-49d7-9a66-939a5b14d875,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:516c430b-7fe1-49d7-9a66-939a5b14d875,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:da6d92cb45a1abfbac2444a16ceb26d2,BulkI
	D:26073022275497LA2ENX,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d781e4528c2211f1aa26b74ffac11d73-20260730
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1917665023; Thu, 30 Jul 2026 22:27:49 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	13667453960@163.com,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] selftests/mm: make libnuma-dependent tests optional
Date: Thu, 30 Jul 2026 22:27:22 +0800
Message-Id: <20260730142722.874189-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 610B54000C
X-Stat-Signature: wras1rea8c7spmfiggi79jzizfkz4mge
X-HE-Tag: 1785421681-460465
X-HE-Meta: U2FsdGVkX18znMxUxSoj9jrKtCs400tmUBA9upak/+NBlnMoDy0ACfD+gShuZDa984MZzV2qQRboOCTyQPrzJTb8uFFXxgLpAO3Un/aJzQrGq9kfJp6g8d8JX20yM7b7cspV6Lx6iTCrOudOWI+ayXIM5OfCF15YOd+7B7fE1XTHVnSrKJ/jppKF95xvWYJxB8Uui0j0BNgzZiR7mgK2i1Ujle22ryNarBFmTzkNeBitL74Y2508GkudXLFpng9yJJW/ZYuPoxoNDy41+W/bVTPQtmeQquyG10Oimh5rRo/durKN8nuWteLcNd68FaKSAUkP8VRuRMV+Plk26s8o5AuQBdDuj/OrKdBRY8lhL/rfTKbmAVyozR5XfKIylE6cEheAffBpflCK6OA3U+vYX4IK6V4IZuHaI01ebhEk7CshRIqxhzcuxQguMmix5tJSlGmedccPI8Z+y/jW9mss4sbQCYy9f7x4mlC7rIbQj7xPuYIimPLv+vwXPoi+UcxocI4xi5ahUpMQZBJ0r+k2wCtLWzBv+pcEm5gZ6Q2SSS3ZA0TAuaDW/GA8l2r27YsPnIail7tUOTDHXJq3DWIhzsuHoiaMIy6sEBUeeR8lTWwIq9uUkF9QofQzm38rzNtGwkYyUBjOg2yUAJ7xVKBW7Y1jek7EOlMwpAzPdYv/H0sjsBLQIMjG4e2erVEzQ1xKN+nyY0BZ0c4pv2CZwL0nqbBPAsq4WDECOJnziTA8WiG2GykoYzcMjWkAOjTJcJ6BR8WN5xqQcTxI9jYVct7h0VJnUDDRxgfHBchnBAUpgZDtmifUkpdGq2ybWxVIB5pTfDIeKfquTLg8suKQ5sp2hf4yqUQSAyaxqzcFvNWhki0mMQxPEZovaTzpyZfU5nhJonG+SBPF6ZqpIlIylHdWsLr8dK3AUhjbjFlmAh5kZ7BmFx9acaDdG8KBbo1umag9wHgN7I72XSQGCiyw0a9
 w3qSUzAd
 Gniy9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm selftests Makefile unconditionally builds three test binaries
that depend on libnuma (migration, ksm_tests, rmap). When libnuma-dev
is not installed, the build fails with a hard error, inconsistent with
how the optional liburing dependency is already handled via
check_config.sh.

These three tests hard-depend on libnuma at both compile time
(#include <numa.h>) and link time (-lnuma), confirmed by grepping all
.c files under tools/testing/selftests/mm/ for numa.h/numaif.h, which
matches exactly ksm_tests.c, migration.c, and rmap.c.

Extend check_config.sh to probe for libnuma via a compile-plus-link
check (the link check needs a main() symbol), gate the three tests in
TEST_GEN_FILES behind NUMA_EXTRA_LIBS, and print a warning when
libnuma is missing. The liburing section is switched from ">" to ">>"
writes and both output files are truncated once at the top, so the new
libnuma section can append without overwriting the liburing section.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 tools/testing/selftests/mm/Makefile        | 21 +++++++++--
 tools/testing/selftests/mm/check_config.sh | 44 +++++++++++++++++++---
 2 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..235c8ec788a7 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -75,7 +75,9 @@ ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64)
 TEST_GEN_FILES += memfd_secret
 endif
 TEST_GEN_FILES += memory-failure
+ifneq ($(NUMA_EXTRA_LIBS),)
 TEST_GEN_FILES += migration
+endif
 TEST_GEN_FILES += mkdirty
 TEST_GEN_FILES += mlock-random-test
 TEST_GEN_FILES += mlock2-tests
@@ -94,7 +96,9 @@ TEST_GEN_FILES += uffd-stress
 TEST_GEN_FILES += uffd-unit-tests
 TEST_GEN_FILES += uffd-wp-mremap
 TEST_GEN_FILES += split_huge_page_test
+ifneq ($(NUMA_EXTRA_LIBS),)
 TEST_GEN_FILES += ksm_tests
+endif
 TEST_GEN_FILES += ksm_functional_tests
 TEST_GEN_FILES += mdwe_test
 TEST_GEN_FILES += hugetlb_fault_after_madv
@@ -103,7 +107,9 @@ TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
+ifneq ($(NUMA_EXTRA_LIBS),)
 TEST_GEN_FILES += rmap
+endif
 TEST_GEN_FILES += folio_split_race_test
 
 ifneq ($(ARCH),arm64)
@@ -256,11 +262,11 @@ $(OUTPUT)/gup_longterm: LDLIBS += $(IOURING_EXTRA_LIBS)
 
 $(OUTPUT)/mlock-random-test $(OUTPUT)/memfd_secret: LDLIBS += -lcap
 
-$(OUTPUT)/ksm_tests: LDLIBS += -lnuma
+$(OUTPUT)/ksm_tests: LDLIBS += $(NUMA_EXTRA_LIBS)
 
-$(OUTPUT)/migration: LDLIBS += -lnuma
+$(OUTPUT)/migration: LDLIBS += $(NUMA_EXTRA_LIBS)
 
-$(OUTPUT)/rmap: LDLIBS += -lnuma
+$(OUTPUT)/rmap: LDLIBS += $(NUMA_EXTRA_LIBS)
 
 local_config.mk local_config.h: check_config.sh
 	$(call msg,CHK,config,$@)
@@ -277,6 +283,15 @@ warn_missing_liburing:
 	echo
 endif
 
+ifeq ($(NUMA_EXTRA_LIBS),)
+all: warn_missing_libnuma
+
+warn_missing_libnuma:
+	@echo ; \
+	echo "Warning: missing libnuma support. Some tests (migration, ksm_tests, rmap) will be skipped." ; \
+	echo
+endif
+
 ifneq ($(PAGE_FRAG_WARNING),)
 all: warn_missing_page_frag
 
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index 32beaefe279e..8e6d1616561b 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -7,10 +7,17 @@
 OUTPUT_H_FILE=local_config.h
 OUTPUT_MKFILE=local_config.mk
 
+# Truncate output files so that re-running this script does not
+# accumulate duplicate content (all writes below use append ">>").
+: > $OUTPUT_H_FILE
+: > $OUTPUT_MKFILE
+
 tmpname=$(mktemp)
 tmpfile_c=${tmpname}.c
 tmpfile_o=${tmpname}.o
 
+trap 'rm -f ${tmpname} ${tmpname}.*' EXIT
+
 # liburing
 echo "#include <sys/types.h>"        > $tmpfile_c
 echo "#include <liburing.h>"        >> $tmpfile_c
@@ -19,12 +26,39 @@ echo "int func(void) { return 0; }" >> $tmpfile_c
 $CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
 
 if [ -f $tmpfile_o ]; then
-    echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-    echo "IOURING_EXTRA_LIBS = -luring"          > $OUTPUT_MKFILE
+    echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  >> $OUTPUT_H_FILE
+    echo "IOURING_EXTRA_LIBS = -luring"          >> $OUTPUT_MKFILE
 else
-    echo "// No liburing support found"          > $OUTPUT_H_FILE
-    echo "# No liburing support found, so:"      > $OUTPUT_MKFILE
+    echo "// No liburing support found"          >> $OUTPUT_H_FILE
+    echo "# No liburing support found, so:"      >> $OUTPUT_MKFILE
     echo "IOURING_EXTRA_LIBS = "                >> $OUTPUT_MKFILE
 fi
 
-rm ${tmpname}.*
+rm -f $tmpfile_o
+
+# libnuma
+echo "#include <numa.h>"            > $tmpfile_c
+echo "#include <numaif.h>"         >> $tmpfile_c
+echo "int func(void) { return 0; }" >> $tmpfile_c
+echo "int main(void) { return 0; }" >> $tmpfile_c
+
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
+
+if [ -f $tmpfile_o ]; then
+    tmplink=${tmpname}.bin
+    # Also check linking, not just compilation, because <numa.h> may be
+    # available without the shared library (libnuma-dev vs libnuma)
+    if $CC $CFLAGS $tmpfile_c -o $tmplink -lnuma >/dev/null 2>&1; then
+        echo "#define LOCAL_CONFIG_HAVE_LIBNUMA 1"  >> $OUTPUT_H_FILE
+        echo "NUMA_EXTRA_LIBS = -lnuma"             >> $OUTPUT_MKFILE
+    else
+        echo "// No libnuma support found"          >> $OUTPUT_H_FILE
+        echo "# No libnuma support found, so:"      >> $OUTPUT_MKFILE
+        echo "NUMA_EXTRA_LIBS = "                   >> $OUTPUT_MKFILE
+    fi
+else
+    echo "// No libnuma support found"              >> $OUTPUT_H_FILE
+    echo "# No libnuma support found, so:"          >> $OUTPUT_MKFILE
+    echo "NUMA_EXTRA_LIBS = "                       >> $OUTPUT_MKFILE
+fi
+
-- 
2.25.1


