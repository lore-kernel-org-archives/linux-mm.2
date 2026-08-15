Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8016EC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330646B0339; Sat, 15 Aug 2026 04:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0F36B0340; Sat, 15 Aug 2026 04:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFF46B0341; Sat, 15 Aug 2026 04:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E59546B0339
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:08:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70FC714031F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:06 +0000 (UTC)
X-FDA: 85102775772.06.3A3C8C8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C908120002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786781284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5CL8GP++uGUiV7DNMNiGOanXyfWsAqMW26GmBnq2c2Y=;
	b=DZ7T1YB2rMCa8sWXZaTZTMfDciab/GVQEpaswWq5sl9EskKvd3bS6D/w3dWtZ7xIZWzhgH
	isniLe6O3QYpI65YviHtbrewWxL5BxInMYIveuYMAkwq9qIW2BrDAxajNfj1pfgzUhiC51
	we5PqeFxkwdL7NOaF6rb08NFZRUIG5w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786781284;
	b=pFrREgN6XTxhyXIebKCKLYYUiSNUdCdr8y31gDorUOpw0vc+J28Cjw/jBRQoeOAyrrCv4o
	JoramtZT4Z6MAMNnCXWbJQVKR/JHIce0CaeC7Wy26m/lKNYJOavweVLZ8MTvrLLBx7RCTT
	pccD8AqFPePtdUfdGFD5F30MtVoDKgs=
X-UUID: 6aa25730988011f19a56ed5b684f684d-20260815
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
X-CID-O-INFO: VERSION:1.3.19,REQID:d19931cf-85b6-48ad-a805-7c5ad5406e08,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:d19931cf-85b6-48ad-a805-7c5ad5406e08,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:6ddafd9b30580e56c19e832e4de2a2d7,BulkI
	D:260815160757TYUWJR19,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6aa25730988011f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 5729612; Sat, 15 Aug 2026 16:07:53 +0800
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
Subject: [PATCH v2 2/3] selftests/mm: emit TAP header and use TAP skip in mremap_test
Date: Sat, 15 Aug 2026 16:07:15 +0800
Message-ID: <20260815080716.3596514-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260815080716.3596514-1-husong@kylinos.cn>
References: <20260815080716.3596514-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nhcs3r1shyr7gynrqa3b5637natt1euz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1C908120002
X-HE-Tag: 1786781282-584215
X-HE-Meta: U2FsdGVkX18rZ8gKvWzFdVSMZTTnshx5NDbu33U1v3Tey6zUEtGdUSEWwOJHEQwqBLJl7KXMssY5J6T+kb3gcbeBQZRJ5to8dHI0LZVmKsLehe4xjYw9hhaZwI+8R7PwJPLAiPyLeKJyxzk4pg0DVKwmcOcgv+4DoUG1J8P6D/5nsGK+8h0u92cnJlV7+Q9SpT9hkYi0oCFZRX7QN/+9Ve+YjjO12wbG7Rz/bSTWT/7MId29sJ7miTZoYWf4SS4f7muIevpp4gXrzeT+VfOeJ5vXnqxGvMdTRncljyfqPmqKg++vTeyIvFo9zDyF3AsuRaJ1hV0/vsLRQEOnPNaABhH1HejPOZ9Rp8mGjgyzz29XSflAXkZ484aw9b6vv4nmeSU38Q2a5pE0kB+gCENDLgfgzNa6s1CJIndHE8b4B7vghNS0MIgxlnnao5dYDQ0R1E5YCDEdFAa54x8p58p3RniRtr+xffSpL5cTqUWwzn8+liXzRE6rmTicIQn4zaaLzmlB8sn0EpLIDQB1/LEp3/2CtL4kqAATnNjGCrQ83qFi6xCe/44ReF6+RIOTDv3MDEYkONijPWyvj63fOaKllEJlZOEw4XUHyUyZxts8ZxW+d9J8n/IU9jxLjI6vIS9rZUljhHT6NwsCkY57RRacSPn2WG40fJ2arH9SS8RR2S9mOPfTi9JmUkoABAnXLYryIcsCN4BXzHTjKY3hSejQx8XfMz6ljkPHnWuzHUvUR7RzlNWvngpj/wtqjETl9ZSmQ+OP0qkpvhnT1MY4MJ1IPv2K/xbUCvBa4a4GO79z4yQ/poTEGXMowtmOvxxJ1hs4bGisFAyX8TLXFngth2hQms/WmW9ERDrw6/yf7Za+KSba9H44NUVLsdOvkKzYINuFjd/+rKkygfnxBTv0qDsaLVzZ7ichGwiW0UXRXY4qI92x/VGKCe76IKwXKogXPVyfjqDY9suqctYampli4QI
 UzwmMmmY
 nwCEOyv81lLgB2y1vMbCsU4esr7fmSUI8N5lDhb5CUi3/PHbq6VMKqCjDcYV3yFIQSeqWmahW5nET7UZe8WWKyL6YD9Gw7OsY74pgjUqtYLn1A5JemY1lbzSzE1VRZQRi/qn+R2MEtPD4OdM=
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/mm/mremap_test.c | 41 +++++++++++++-----------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db867..28f151daabe4 100644
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
 
@@ -1250,13 +1252,16 @@ int main(int argc, char **argv)
 	time_t t;
 	FILE *maps_fp;
 
+	ksft_print_header();
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


