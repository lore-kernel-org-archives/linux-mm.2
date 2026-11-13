Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C916606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832BD6B0657; Thu, 12 Nov 2026 21:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809ED6B0659; Thu, 12 Nov 2026 21:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721016B065A; Thu, 12 Nov 2026 21:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C426B0657
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:53:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AF541601E1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:53:18 +0000 (UTC)
X-FDA: 85428574476.06.342C512
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCE18C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:53:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794538396;
	b=emuVjP+BwMANKCI31fNl8VQTsTqZNVO91WgzVC0CwcJAk7ayMYiLlPuicyDsoVT+ZVVzcG
	4nTvPjKQIrju59JqS7qY3GYP8rOk7O6XhO6yoSK3ZvFpqQT7kV4qBj22WW9NCPQrtucqDq
	ZDWByVqGhqGWCr8ZywYntT5ltF8x/iE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794538396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=qKeJBKYSKrXzA2DdXk+Uv7PAsSWBeJIQUutMePGjhzg=;
	b=CDtJGt6zTYbKaoh5RSHpCqo0Eg2QcB5/tOL6ShYAJACfdkCWLuaJwXpTuoSHT9okE/n1b+
	+WOeRSo/Oix9iydxBcUxL3N6P43WTJA+C/PR78aa3zULrJe0BBWUOgIOvm88Ntsd57JXMu
	I2Es8zlGBQ1y09R9rlhebqysTwxqgu0=
X-UUID: 56b8724edf0d11f19a56ed5b684f684d-20261113
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_7B
	HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:4f9bbadd-e78c-4769-a1dd-5c2cd0e23a33,IP:10,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:4f9bbadd-e78c-4769-a1dd-5c2cd0e23a33,IP:10,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:4af21d31961f732c8794b7d6542fc9f3,BulkI
	D:261113104019IM9075YM,BulkQuantity:2,SF:10|38|66|78|102|127|153|841|865|8
	98,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:41,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 56b8724edf0d11f19a56ed5b684f684d-20261113
X-User: lihongfu@kylinos.cn
Received: from macbook.local [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1341907876; Fri, 13 Nov 2026 10:53:00 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
Date: Fri, 13 Nov 2026 10:52:37 +0800
Subject: [PATCH v2] selftests/mm: mlock2-tests: fix fclose(NULL) in
 is_vmflag_set()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQ6CMBAFf4Xs2RraYIue/A/DAdqtrGBrWmwkh
 H+X4tXjJPPmLRAxEEa4FAsETBTJuw3EoQDdt+6OjMzGIEohOS8rZn1gz9HrQbBWKltL05rqXMM
 2eAW09Nljt+bH8d09UE+5kI2e4uTDvL8lnr2/4cQZZyeF0hhVadGZ6zCP5Hw8agfNuq5f/hNIs
 7cAAAA=
X-Change-ID: 20261104-for-mlock2-a67f86dad498
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Liam R.Howlett" <liam@infradead.org>, Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794538380; l=2033;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=c5NvTkyLv8vVmdu1qrQ3QDkHHLM9VqONXM8ZX64SW3A=;
 b=8msNcvfbPWNkjRBc55Y3yhcUCTKNn80xye5iwBTmLuI+t+agi89Y5Yqv/WWCI0aHBzW2dabOv
 aQpO35FY8oZDjv7tZmhqPAfT/w7reiAigPaMTzGYMqj0xR9lgJG1tGC
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Stat-Signature: x6nei5mnj8g858azcbeg4sm88mdnqdm7
X-Rspamd-Queue-Id: BCE18C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794538393-344042
X-HE-Meta: U2FsdGVkX1+LcKe6a0IzGtX/Ly45A9Jrd9kRivyx0/skJPDMupT3DSLkK8yO4idyUPv+/1R5W5GwC8o9e+LxkxoUgaK6PkQhQP9EG9aGWiILJQO14zHFDz+V1FnfgvG8ji0GpGPFNHLAijsSZA1nlGYbMC/uj0P0INuzMnvvb1huziuxYBYl669eOTSMlCbJJRYhLzZUDKCiqP5hetWaKhyJGY5uY20J5lgLh7FU2VfkbbvoWFDW8HqaqfJ9pC9Xj39qoKv1DqUdtsTNkzs0Qr9rGfkw8QCsisdGMK8KsDwE2Qj3VwzxrRlU1CrnO5F5a/Lo9vcn+/YoT2O8D+VnJZtJag9YzQyj4C/D0NlcKsZwfs89+pJBciPkxtpEXXg/F3x7M3fTvU6M8Lj5/V+BaqA85vkEWPNhAMVDkpzqAYBDUvOx4yza7kxHiPUScEPWjm3j89D5X8UayIiR8o2vIGVH+mHomM8mQ24Zn90ENUxzVljLtyIeJIVuINKFWdmyaRC8Ly/yQ/F4VvR8ATFpsRpt+012jzafchwbcxtgJ0tbhvdo4We0nStSu4GQIz4vpy7JIZQXDzPfoQGs/Pk+15wbEZZm9jwqw3R7hfwabkDaZ/Chsh6dygs82+FpO1vp70p7L47wOvSV65N8pdBtJsO/lIGfYUf1toL61h1gbV0UABRy+tDE+lqwqIMnlge8gJoCHbDrZpaWe12V2aiMTdUFyyiTxxpc/Q63QPtz+qEiojy6WJJlRjenRaV6CU/s+gWSMrUyGfT2I5NQeG9orlsfIKVAYLP5WKClSCchvLOEOq9jaT/+qAw13s/NOxTMqBTHFa+1VZR1r/rH8rbNqPEghx0Ls6Ne8AL3LMVgqni3uy762b5aGZkkve1FLJ7j8LgZpqRwpWHEz/jlmf7LYsfWyiNxGF6Zkwt7Gx7kodCjsohhgw9VNTQFVmwJooPgHG/9a9zc+ev+dQSIlho
 jHbCQFSR
 n8K8ricVsO8ndp7NRDcKBc9gXk/Cuhkt0fM2m8NRBO+FiqgGYQ/XlRqZypmha7amZ5xH0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

is_vmflag_set() jumps to the shared 'out' label when
seek_to_smaps_entry() fails. smaps is NULL on that path, and the
code at the 'out' label calls fclose(smaps) unconditionally.
fclose(NULL) is undefined behaviour, so the test crashes before
it can report a test result.

Return early on that error path instead, so smaps is always valid
at the 'out' label.

get_value_for_name() follows the same pattern. Return early on the
seek_to_smaps_entry() error path there as well, and drop the now
redundant 'if (smaps)' guard on the fclose().

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
Changes in v2:
- Convert get_value_for_name() in the same way, as suggested by Liam R.Howlett.
- Update the commit message.
---
 tools/testing/selftests/mm/mlock2-tests.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/mlock2-tests.c b/tools/testing/selftests/mm/mlock2-tests.c
index 144b550813a6..455f1c841dec 100644
--- a/tools/testing/selftests/mm/mlock2-tests.c
+++ b/tools/testing/selftests/mm/mlock2-tests.c
@@ -66,7 +66,7 @@ static bool is_vmflag_set(unsigned long addr, const char *vmflag)
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
 		ksft_print_msg("Unable to parse /proc/self/smaps\n");
-		goto out;
+		return false;
 	}
 
 	while (getline(&line, &size, smaps) > 0) {
@@ -103,7 +103,7 @@ static unsigned long get_value_for_name(unsigned long addr, const char *name)
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
 		ksft_print_msg("Unable to parse /proc/self/smaps\n");
-		goto out;
+		return value;
 	}
 
 	while (getline(&line, &size, smaps) > 0) {
@@ -123,9 +123,8 @@ static unsigned long get_value_for_name(unsigned long addr, const char *name)
 	}
 
 out:
-	if (smaps)
-		fclose(smaps);
 	free(line);
+	fclose(smaps);
 	return value;
 }
 

---
base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
change-id: 20261104-for-mlock2-a67f86dad498

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


