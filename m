Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04055C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0091E6B00F7; Wed, 12 Aug 2026 08:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22A66B00F9; Wed, 12 Aug 2026 08:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38C56B00FC; Wed, 12 Aug 2026 08:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C282F6B00F7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:10:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5F58A035D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:54 +0000 (UTC)
X-FDA: 85092501228.22.7F8FCC0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 87B1A1C000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:10:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786536652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AHZGkcF6vmq6DfT7dxaFxVsRQXD0k0tgxtewWNuMhVg=;
	b=M4GTH9fUEihAf0cR4ZWyx+fSN3Bq37YtgY+c6oaPY8O+e1NCgKFgnx3iLKY7iEb5LH6S92
	JJ6RA/MxaBvJOcJO0vDcjhv0nBKA6hECls8rfSEdqTi/0u+yftzbRsxcq0Q1hSNDRII5ko
	D2tvhUJ++rkkRJREmfZv6GSXhMFLX4o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786536652;
	b=tvo9/zZaecPiT35RI+XEaUIn0xTgWbFVAqCGE6cPRiHOlNqUxUOCeELWpRH22NfFMdcmdW
	9Ccg/MZyQ/EUlY9RazN5ySquV4C3EVoFoH+wgMioJdhaDUnRc6Bi/o6V0F2nZqG/d5X73C
	bEeMNF094G7XqZgm62I8pXCtYcr15Ac=
X-UUID: d787a3be964611f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:693dc26a-14a0-4723-a38e-e2be535dcc80,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:693dc26a-14a0-4723-a38e-e2be535dcc80,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:48f78fda794771af4f5c76461b928d39,BulkI
	D:260812201047HWGODJE7,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d787a3be964611f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 500118119; Wed, 12 Aug 2026 20:10:43 +0800
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
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/3] selftests/mm: emit TAP header and use TAP skip in mremap_test
Date: Wed, 12 Aug 2026 20:08:20 +0800
Message-ID: <20260812120821.523860-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812120821.523860-1-husong@kylinos.cn>
References: <20260812120821.523860-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dre8ntiqo6khnudoqmkm1ib69wsdqs94
X-Rspamd-Queue-Id: 87B1A1C000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786536651-457774
X-HE-Meta: U2FsdGVkX1/qBH+pf26T2sL3oLURstZpyI7XNUeCmf5KOQovlvJQyxMqKGha2osPuYA2mEvbU6uMQwFulpIRnET7UB3GaJQjp+zltlCZHNYFbfJLQa3WyI937HkmiohaEkaxZ0Q8c74Rb3sI61dEw2boQuS286ZScOhdC19ii8GFDhqNmu7B3PgNfOxManXjxqyH81l9XeH2kCQoVp8UISxZ83JTygsWND+r1epIk5RpS/S4NaU8+EsmSBGgqpziYLqtl1jakdvFqJCDFSL+UYL6DhAQ1sMBaTz4mxCWrLqE15WaEDxrMkEQwYcPptV1JR3xPMU0/edq0jlyP2IT43KI6k97heGeiIoMzdYj0Km2feuiGGed2AJs/ETdhnBdO1dldzNrDA456B9PuwcQGqkQ9ztaMXof1GupOaz2Ahsdzt5qXYiLf5Mn7FXig3YnKIhVqSMvbalZgulvAwaDqUrdQUwaIysZkYZUDGjH+tSCRZI8B3rkceSshdOVduKpS8E+ePLCNFBvbegcN96ZutYRCDZ8qdmP6tYIKtaKP+Z1XN70gDwmt3m0EEDjSxjnGu20rRKbjEC9birhzJrB4equXJM2lg/cm6MTOoJz40YuSLaSrgqxEu0tqv71iVkYJ1PYIpOp4ejrivi8AMEPKndZx0P19/zngIz5kiRg5kR/D9k9quYwSZ9E78pX5Fb6egvyQlv59teu3kpU8b2LQy8KIqLorncevz5BVIdCWu+ZMbPr5doQ4FA6EMsrVZuK0ly026qIIUOEy7jqu5PGBcF3lbyASsTaryUhtsB0aTsjOfcLVsohUAg8F6q8ZQgXjND2P+SUh4qEalM33KaMjHJNxtG/2RtzB1CcUCsIFJ9hoRHM2lSvzY2pRcuvprygZQAfOTdaz/VHN72Y0zQ/j3OgC33fT3Cw3YR0ROzLbLymGKzIGVE6Y4MchomUJ1ecT/f6EpuVwDyIhSN6Zk4
 Jo4Q3/fj
 lP1ars39bVSrRHZu1dx0k6R72slIjqcJnUiNMQ2zGY5sWetU+CBM7gsKV4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mremap_test calls ksft_set_plan() without ksft_print_header(), and its
get_mmap_min_addr() skip path uses a bare exit(KSFT_SKIP) that prints no
TAP line, so its output is not valid KTAP.  Add the header and switch the
skip to ksft_exit_skip().

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/mm/mremap_test.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db867..d055a4b3b024 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -111,18 +111,15 @@ static unsigned long long get_mmap_min_addr(void)
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
 		fclose(fp);
-		exit(KSFT_SKIP);
+		ksft_exit_skip("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
+			       strerror(errno));
 	}
 
 	fclose(fp);
@@ -1250,6 +1247,8 @@ int main(int argc, char **argv)
 	time_t t;
 	FILE *maps_fp;
 
+	ksft_print_header();
+
 	pattern_seed = (unsigned int) time(&t);
 
 	if (parse_args(argc, argv, &threshold_mb, &pattern_seed) < 0)
-- 
2.43.0


