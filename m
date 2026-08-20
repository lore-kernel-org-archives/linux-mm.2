Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 645DBC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D51A6B009E; Thu, 20 Aug 2026 02:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC096B009F; Thu, 20 Aug 2026 02:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2606B00A0; Thu, 20 Aug 2026 02:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D06A6B009E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:17:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3E7016061E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:17:10 +0000 (UTC)
X-FDA: 85120640220.20.B76B6BC
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5AEE2140006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:17:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+GjXEGv/DM0km5OSaqtTVO0wI7IN5E4keAmWxkxr6yA=;
	b=sseps/lwKO+bikRaRxlq+XQH0HKqqGQ588OrvXAYeXE2XQwmD35y1AWZGEWXgKZvs0W/Y3
	bVhKUpHwIDZYBjiSFnnZJ6F7ORf2PpZTiHxzXLcdm8SNoxfdcUUPbKyAUnUll7vWCa5UbG
	mVYkUUsiPpWCuV7XHPodQF8QKdEK9mo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206627;
	b=ICFWclbmhgdptP31Hdm3Td6rmi0TehV+579X+my7aXzoMUh/pSIpYRYZS/ln9b7RhKjF94
	2iemiCEeqFiEwa5kagURc0Ya0r+Uoso6aLBQucnxR/eXO9eeBD8LLZZdLhvf4VOXOgMg34
	CeZwB1fHhHdrI/rOZe5ymJXY/r8e3pU=
X-UUID: c0588e4c9c5e11f19a56ed5b684f684d-20260820
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
X-CID-O-INFO: VERSION:1.3.19,REQID:0747c7bd-5ee5-4da1-8772-b715910e2afb,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:0747c7bd-5ee5-4da1-8772-b715910e2afb,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:0310c0754b42a1697eb70929951a9fe9,BulkI
	D:260820141701D6W9G3VA,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c0588e4c9c5e11f19a56ed5b684f684d-20260820
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1751691878; Thu, 20 Aug 2026 14:16:59 +0800
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
Subject: [PATCH v3 2/3] selftests/mm: emit TAP header and use TAP skip in mremap_test
Date: Thu, 20 Aug 2026 14:14:25 +0800
Message-ID: <20260820061426.356869-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820061426.356869-1-husong@kylinos.cn>
References: <20260820061426.356869-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5AEE2140006
X-Stat-Signature: ba9d8b1z1rq6z9nun7mnng9gakhszibk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787206626-284642
X-HE-Meta: U2FsdGVkX1/twRLsmHLct0dyGTz13ie5/b+nPUZa2zlUrqeb187VDamHKEL4KZeAoj2Fj12k6j+1aDEdExlYJ87en5zumkzwmw1XO1GyN/BVf65SPq3WCZH+jHGM3e3nzfTdO9AW9UXPspJ4M7wJPKjTnBprv5jFFHB5nWbwpMu6CpXd1kdQBjk8Y2LTWao+rMyGrR6uH4HI5D19QW0vgAvva6h0ZMvSkgdXnbLL5sirxKCUkqYp0oeBFcPark+xP4ihGmc5rfqgvyZ83VBPB94+u5nXwK9HOar9R/HbLh4JDwVQSUNwzheNuheL/IsVzj94Xti0HACwu82FVgORXCemo25Pfl0v8qzN/dVbHAuCFMT2IegLdW3zMsLyJbrJA//XFXVYh92SXJnBa+ZA3SQwmxAgz5OsZRHB8dD+apk6cHg6a3hJX3ypZlJ8Go0Om/oNvQoYFEh7RuCq4tLRd3bbt0bkXP7K6IjsrCWNeoNTBf9PNIsEhejiaVwFOv45DAAi92DjCS5LZunwfIDlmPPY+SLsHGR+g9GF9mkDVtlpv19Pm5KjF3vlJmxcxf/NMxXUwuX9zjB8KfmFjknICGvfYWlL6wHXh7dgMiJEMsc8eixDqJ/a7dDaKi2//bqpjDF0nRI1F/9R2eyd/ou7dTC61kAgJmoCqXzLA1THECtMBcTnJPeqyH0KTgGYZ8i4OAxeZAdjkYcvgzaprFCy+/dfgcBeeAG2OZ+82/uUPqGMB83qPJe5a53KJxJXl+Db8o9cA1/ToBzNdzfnXajC+1636/CLg4AtKYza9WwGL4xqHgMfwlCkB8GvNEjGXwBGhxLadEcha9abF4iwxwBszaT+3Zg8VTu8CvElZtj806BLIUE8KeG/L2YwBKHSYqr9K0kNZs1SNqDa+wIFO+DfpopwOpmd+FPzBUZ8O0jLwDtYPfRyiGcs3H+JMBvBVBozhhiewunPJAbTieJBlBb
 YeQIAprt
 3G2/RfYF2KmMXniCy2VidDaPwrjFjdHRfca/eZOMsZ2tqNepFoj96RrnpFw33CRIeWipmUan0EIJyjtjmxJ2S4/BuEARv/XRJYl2MIQn8oRhcFa6kC2fTJEH9TPQl1yztcxuo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test calls ksft_set_plan() without ksft_print_header(), and its
get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
TAP line, so its output is not valid KTAP.  Add the header and switch
the skip to ksft_exit_skip().

Also fix two more KTAP compliance issues spotted in review:

- get_mmap_min_addr() calls strerror(errno) after fclose(), which may
  clobber errno; save errno before fclose() instead.

- Some ksft_*() messages embed "\n\t", so the text after each embedded
  newline is printed without the "# " prefix.  Split those into separate
  messages.

And cache mmap_min_addr in main() before ksft_set_plan(), so that the
skip paths in get_mmap_min_addr() are taken before the plan is set; a
skip after the plan leaves the run with fewer tests than planned.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/mm/mremap_test.c | 43 ++++++++++++++----------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db867..ab5420f2e875 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -111,18 +111,17 @@ static unsigned long long get_mmap_min_addr(void)
 		return addr;
 
 	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
-	if (fp == NULL) {
-		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		exit(KSFT_SKIP);
-	}
+	if (!fp)
+		ksft_exit_skip("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
+			       strerror(errno));
 
 	n_matched = fscanf(fp, "%llu", &addr);
 	if (n_matched != 1) {
-		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
+		int err = errno;
+
 		fclose(fp);
-		exit(KSFT_SKIP);
+		ksft_exit_skip("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			       strerror(err));
 	}
 
 	fclose(fp);
@@ -1164,10 +1163,11 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 					    rand_addr);
 
 	if (remap_time < 0) {
-		if (test_case.expect_failure)
-			ksft_test_result_xfail("%s\n\tExpected mremap failure\n",
-					      test_case.name);
-		else {
+		if (test_case.expect_failure) {
+			ksft_print_msg("%s: expected mremap failure\n",
+				       test_case.name);
+			ksft_test_result_xfail("%s\n", test_case.name);
+		} else {
 			ksft_test_result_fail("%s\n", test_case.name);
 			*failures += 1;
 		}
@@ -1177,11 +1177,13 @@ static void run_mremap_test_case(struct test test_case, int *failures,
 		 * was faulted in.
 		 */
 		if (threshold_mb == VALIDATION_NO_THRESHOLD ||
-		    test_case.config.region_size <= threshold_mb * _1MB)
-			ksft_test_result_pass("%s\n\tmremap time: %12lldns\n",
-					      test_case.name, remap_time);
-		else
+		    test_case.config.region_size <= threshold_mb * _1MB) {
+			ksft_print_msg("%s: mremap time: %12lldns\n",
+				       test_case.name, remap_time);
 			ksft_test_result_pass("%s\n", test_case.name);
+		} else {
+			ksft_test_result_pass("%s\n", test_case.name);
+		}
 	}
 }
 
@@ -1250,13 +1252,18 @@ int main(int argc, char **argv)
 	time_t t;
 	FILE *maps_fp;
 
+	ksft_print_header();
+
+	get_mmap_min_addr();
+
 	pattern_seed = (unsigned int) time(&t);
 
 	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
 		exit(EXIT_FAILURE);
 
-	ksft_print_msg("Test configs:\n\tthreshold_mb=%u\n\tpattern_seed=%u\n\n",
-		       threshold_mb, pattern_seed);
+	ksft_print_msg("Test configs:\n");
+	ksft_print_msg("threshold_mb=%u\n", threshold_mb);
+	ksft_print_msg("pattern_seed=%u\n", pattern_seed);
 
 	/*
 	 * set preallocated random array according to test configs; see the
-- 
2.43.0


