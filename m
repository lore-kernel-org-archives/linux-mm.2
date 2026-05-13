Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0CD4CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D384B6B0005; Wed, 13 May 2026 05:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE99A6B008A; Wed, 13 May 2026 05:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEDD6B0092; Wed, 13 May 2026 05:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADE246B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:56:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38C161207B8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:56:03 +0000 (UTC)
X-FDA: 84761940606.14.892E793
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F13440008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:55:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778666161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=NEf9fo6UPfIWaGftszUHEiD/mC1NdCU/Hq0xwg05n74=;
	b=Z/LiBOn8ChHl11y0QoR6t/RTQVaag+1LZrSIgCesJd0OOK3qlUoz6rFZ+zRyqWgW4rzZ5/
	ANWOh4+lOVZVbjNN39O/xxvoy1TQKBbogn4ALpHDveMT+O9unjnOWrTv+RG5TGNmsAm11P
	5FFX92MPWrewy34XBp63mShbuR/MKGQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778666161; a=rsa-sha256;
	cv=none;
	b=yeeNCpX92zqzgx6z4zb6fCUCChRfpUGpo10fxFTOWloqpURtizxIRi7Z6IfIFad5hKNvsm
	K3nh4bBvaDG/p31BMyXwpdZsjUqFW2pjNY26UzmVArhl5mbCsSOw32oWqlW3kfX0hAZxo2
	WtFEOuDhzFBTgm/kYvJ4bGCBiGZVwus=
X-UUID: ed78ad764eb111f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ba50d5f9-2f04-4cad-8789-fb21824c9da1,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-INFO: VERSION:1.3.12,REQID:ba50d5f9-2f04-4cad-8789-fb21824c9da1,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:381afc9b0b0b2ed385ed99c719338255,BulkI
	D:260513175554GO8UB3XL,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ed78ad764eb111f1aa26b74ffac11d73-20260513
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 928600640; Wed, 13 May 2026 17:55:52 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2] selftests/mm: Fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 17:56:09 +0800
Message-Id: <20260513095609.789935-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F13440008
X-Rspam-User: 
X-Stat-Signature: onq6opohm1i4h43azjy868453yaajyt3
X-HE-Tag: 1778666159-609585
X-HE-Meta: U2FsdGVkX1/Hscn8z+vR9WWp1L7Y7teClkK+m3REmBhIKe1vfRlJdRRFaJ82wCR6OsY2jxcNqtDcAqFae05sgle0ID0GW4SXPZnMmIMZkWHTDsLzGJFlfWMmk+TXGhcVR95QYU/s+sa95c9OxiFEpXOZcddWZajEENfuzJ7XUHoAqaWPy4dq+bboI9vas/ykxXNHrny6bNNXeC9ahoJf50tJaR1x5vpOS6TAUm68sM8S2xR0zcrX+uIUiU1TlB+71aMToq2JGkQiaLvpis42z4TVxBq8Ev8qIMOxqr8W8Y1NdzbSqn7WJPOCN+q1qUzllVLqTABrIj811PtsqA8pq1TcN+B75FzFVt1digcxextmrY6o+xxj9iZ8ZDVGJsFbVVOCG48FLw1c1i0/zT74HQniPkjdfBn9HiHV6h4VP00t3Vde8fiF7grR1lR3I66QtWLzVYNU1FIgUH1oeJ08Ghn1ttg7C/Gx+L6Av5grKuP3gIoC9sak38ZVDBlebxD6WxQ7k5Ol1Y7He/d8vCNsrl5Jrc87U3B3Xj2o2prNw2ONcye2vHa9dVKZ5F+QZAxmyQyXGZiLxTLW0iweTGiBwtLBMbYhMbzQl+AhfUdoNu/JMwAZZe1y9asEKr5lfRexIVYhkYceR9glnTx/fKZkPa3dkTyntP/paH7eP69n4nVNyJ1CyDewEGlONuO5GSqys/dxVDpRmGlbCWj+C/yiZw+L8Euoi3Nsls9rTtO7S8N1+Nbe8Q69mz0g0KIlxcIVhDDBvoVJyMIhoH/+MU2AhI2frKX8F/ChCEvx6n9bmJhknJFUmIeNjDa8iuEo+PD7zuhv/XLyL4AQZL3juq90HOSlCvll4ZfqBTCqsbf9YyWCKkzNHD9cm8ldObXQBqHXmbyKRCMK/OCaQMlhRHlguAreZTksxunmKJSQXRrFcqNJoC7aF51TjOyOtLz1jk/E0V5w/BvjZBKqRH/jzAo
 xgIOtRdF
 Ubn1VBId1511TH87aGl/jO79/AWUv3PZM23YX5hCiqOo9DKBOcvTDSuz6RnIfnDlpJfismwsEYKyJMAiUjWyFK5ApT1cDRNegzBee0ZWfUdZelss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
not NULL.  Several selftests incorrectly check the return value of
mmap() using !ptr or ptr == NULL, which would erroneously treat
MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
non-NULL.  This can lead to segfaults when mmap() actually fails
under memory pressure.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
v2:
- Add missing mmap() return value checks in pkey_sighandler_tests.c
  and protection_keys.c
---
 tools/testing/selftests/mm/ksm_tests.c             | 2 +-
 tools/testing/selftests/mm/madv_populate.c         | 2 +-
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 ++
 tools/testing/selftests/mm/protection_keys.c       | 1 +
 tools/testing/selftests/mm/soft-dirty.c            | 4 ++--
 tools/testing/selftests/mm/vm_util.c               | 2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a0b48b839d54..ed481f817282 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -174,7 +174,7 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
 {
 	void *map_ptr = mmap(ptr, map_size, PROT_WRITE, mapping, -1, 0);
 
-	if (!map_ptr) {
+	if (map_ptr == MAP_FAILED) {
 		perror("mmap");
 		return NULL;
 	}
diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 88050e0f829a..7fce5d0b622b 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -34,7 +34,7 @@ static void sense_support(void)
 
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	ret = madvise(addr, pagesize, MADV_POPULATE_READ);
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 302fef54049c..4637809192f9 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
@@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
 	/* Set up alternate signal stack that will use the default MPK */
 	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
 			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	assert(sigstack.ss_sp != MAP_FAILED);
 	sigstack.ss_flags = 0;
 	sigstack.ss_size = STACK_SIZE;
 
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 2085982dba69..580bf1668c71 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
 	 * doing the XSAVE size enumeration dance.
 	 */
 	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	pkey_assert(buf != (void *)-1);
 
 	/* These __builtins require compiling with -mxsave */
 
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index bcfcac99b436..67c26c265880 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -143,7 +143,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 	if (anon) {
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("anon mmap failed\n");
 	} else {
 		test_fd = open(fname, O_RDWR | O_CREAT, 0664);
@@ -155,7 +155,7 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
 		ftruncate(test_fd, pagesize);
 		map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE,
 			   MAP_SHARED, test_fd, 0);
-		if (!map)
+		if (map == MAP_FAILED)
 			ksft_exit_fail_msg("file mmap failed\n");
 	}
 
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index db94564f4431..63aaa2d9ec0b 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -463,7 +463,7 @@ bool softdirty_supported(void)
 	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
 	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
 		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
-	if (!addr)
+	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
 	supported = check_vmflag(addr, "sd");
-- 
2.25.1


