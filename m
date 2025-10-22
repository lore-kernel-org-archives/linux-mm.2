Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAC2CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F4D8E000E; Wed, 22 Oct 2025 01:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806C98E0002; Wed, 22 Oct 2025 01:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743828E000E; Wed, 22 Oct 2025 01:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 640BC8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:52:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A2DE48AB4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:52:11 +0000 (UTC)
X-FDA: 84024679662.14.6D87192
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13BC2100004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:52:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EiZaeGwM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761112329; a=rsa-sha256;
	cv=none;
	b=V7RXGBZf6VWJ4H2+OuiWr7QBIAMWCVoZNZS5yxy5mivWMh2+RUAoRnAjSwStORinKADo1b
	S0ixMN88cLcQeDZBBZUqkMRuqNKtxf12Xf5hd8G2Tdi2FA0t9vgKJ6mEeCCRoV6z8/o1kN
	Z3vOoyoqwnV62jOGxp3txO8ExDuUUJU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EiZaeGwM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761112329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/qxx1k5IYLmQZumkvBGkcglkCRUo8y4lQwXOlsBbvoQ=;
	b=leI+hlDTQRLeT5n55otKH6pG3tJ7RujrJGsr8N5Fsp7aco3xu1TL2z9r0pudnM6xTaPr8k
	fKY1+dw0umUTQyFHmv28lCmqAqOG1t1yM2JmszuXY/hu5aySL6ULxduJZGQU94rfWDWXOM
	WWzJAFavdnPxUVNtJDgzxERJb+aBugc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761112325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/qxx1k5IYLmQZumkvBGkcglkCRUo8y4lQwXOlsBbvoQ=;
	b=EiZaeGwM0IaQbYj3RL0f+9OQnELa6Cz8Qt3JwAgQs/8//eTvERyrPNoPhMUfo3MIssIRs2
	SJ057rN9lPNxmnqwGbeG8+5T4HlW5meSdvXrJiDqOS7t7eodyPjHfBk7s2bdt8yzlFRtSp
	Etvfrkd3MKIst4K5QgeCwdTa4TKULG0=
From: Leon Hwang <leon.hwang@linux.dev>
To: stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to vm_util.c
Date: Wed, 22 Oct 2025 13:51:38 +0800
Message-ID: <20251022055138.375042-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13BC2100004
X-Stat-Signature: 6uzcewi9eyjtwz48wy3q8tffea8jb6y3
X-HE-Tag: 1761112328-869462
X-HE-Meta: U2FsdGVkX18xWOnL0/kwR6TNc0EUCqoGe3mNdry3jf6RuQTH5qdVMWwFFUrX77ciIXYhPYKb7fWN7ecEIaNEABmZi93CBKsXPLJpV3j7tiehaNP1z1Epu45qrzBaBzyX+DmAiUdtK2thxmp/aFKXzpr8XJ+DKnSFpxJHvJ5lKCMdfc+VXMaANY/keid1INKXl3Vc/SIBOBBxrs3fA5peyEqqsxqgeTL0p9h+DudsuRji+cynG7P9ukJCq5sU9nWzciGjOUGfivSQvS15lBuRoC6k/4uzrK2muzTDwe2z9P0WY+7VTpBJ9A+/Hm6AprNBNK5XxwTZWPj77UKB8lFM1pbnFWehS6lA3k9P4HvAdELBNLpPeIMVEkazOhxQWtMuBojhikUuiqN9LOaG84pAEFFB9On0XEshwjUL5VI20k+uREKrVd0hf4w3NTirNGbi62w/BoxJ7C08xJWuKbI3zVJxhfpzIe7k9GxSGqaCx2wi8jLdtyLTlxA5phm/KEZMQfwXf7e1mNmtMjnJJNgWKRoc5TLPVQfWjVGaUGQCBZfhGcWUP/FhTK9fM+b8m9Q3CwuF7SKCca6TSHyLKsVqfgmGl6zPT+57OtbY9K87m3W76FI+Hs4rFLrgxaSsF8NxGOH+9tuORB1QMWmtti1v49DlK5ngMA+D4nXraaLh8fWxtM1zklbJc1be9QrSQQlbuDtIeiEjDUnzwQ+hVF5ABkZTVOxRk4Lq3BlPHDSlEAosugWGeBBqt1Kn1k/Rw6GsZLPbBcWM1ldhmFN9vDPVKfQ4VCIf0YaXK5u7/VH74SbfVdwKXXmK9nr1CofqfXTUXx9sYWEyNI3WrgmVWDCeaDQyT4KXNz3RUYIxEnqxk6g2zvFXDLjDcW287yRZqBE0IEIs4TPKe2pbfam79aDr7i1BAutdCB4MOXs1le3JhiBYlkNG2O4HzrXmOT1DJ1HlqD6IZIBbWFpzuVaesRh
 GBH821AK
 Qhus4I8dwKTanUWo2rRUgUECjpf4gT8YI5iYbDUHPgzEHYGQYZn9pNzUqa3aZwa0gtLKXUBdfZmjMis+g93IKFhuxxSiAGvwjJKw5L/3PYE5ltROFiGM9SwR5EqVNzuqmeC/Y4Ty5BsxdjpjM07GMF0Hu2Npsa37Dy9LNczUyCYDH8XdVIGMTNL2ZJi2jpcZGjnPyxmnsW80M+jWURX60oMFbJZZ+r7wSUrtAy7lQr6jhgwZTPp1t1gwsJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the build error:

map_hugetlb.c: In function 'main':
map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
   79 |         hugepage_size = default_huge_page_size();
      |                         ^~~~~~~~~~~~~~~~~~~~~~
/usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'

According to the latest selftests, 'default_huge_page_size' has been
moved to 'vm_util.c'. So fix the error by the same way.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
 tools/testing/selftests/vm/Makefile      |  1 +
 tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
 tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
 tools/testing/selftests/vm/vm_util.h     |  1 +
 4 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 192ea3725c5c..ed90deebef0d 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -100,6 +100,7 @@ $(OUTPUT)/madv_populate: vm_util.c
 $(OUTPUT)/soft-dirty: vm_util.c
 $(OUTPUT)/split_huge_page_test: vm_util.c
 $(OUTPUT)/userfaultfd: vm_util.c
+$(OUTPUT)/map_hugetlb: vm_util.c
 
 ifeq ($(MACHINE),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
diff --git a/tools/testing/selftests/vm/userfaultfd.c b/tools/testing/selftests/vm/userfaultfd.c
index 297f250c1d95..4751b28eba18 100644
--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -1674,30 +1674,6 @@ static int userfaultfd_stress(void)
 		|| userfaultfd_events_test() || userfaultfd_minor_test();
 }
 
-/*
- * Copied from mlock2-tests.c
- */
-unsigned long default_huge_page_size(void)
-{
-	unsigned long hps = 0;
-	char *line = NULL;
-	size_t linelen = 0;
-	FILE *f = fopen("/proc/meminfo", "r");
-
-	if (!f)
-		return 0;
-	while (getline(&line, &linelen, f) > 0) {
-		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
-			hps <<= 10;
-			break;
-		}
-	}
-
-	free(line);
-	fclose(f);
-	return hps;
-}
-
 static void set_test_type(const char *type)
 {
 	if (!strcmp(type, "anon")) {
diff --git a/tools/testing/selftests/vm/vm_util.c b/tools/testing/selftests/vm/vm_util.c
index fc5743bc1283..613cc61602c9 100644
--- a/tools/testing/selftests/vm/vm_util.c
+++ b/tools/testing/selftests/vm/vm_util.c
@@ -161,6 +161,27 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
 	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
 }
 
+unsigned long default_huge_page_size(void)
+{
+	unsigned long hps = 0;
+	char *line = NULL;
+	size_t linelen = 0;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
 static bool check_vmflag(void *addr, const char *flag)
 {
 	char buffer[MAX_LINE_LENGTH];
diff --git a/tools/testing/selftests/vm/vm_util.h b/tools/testing/selftests/vm/vm_util.h
index 470f85fe9594..a4439db0d6f8 100644
--- a/tools/testing/selftests/vm/vm_util.h
+++ b/tools/testing/selftests/vm/vm_util.h
@@ -11,4 +11,5 @@ uint64_t read_pmd_pagesize(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
+unsigned long default_huge_page_size(void);
 bool softdirty_supported(void);
-- 
2.43.0


