Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DA2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72E506B00A5; Mon, 13 Jul 2026 22:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704EE6B00A9; Mon, 13 Jul 2026 22:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643416B00AA; Mon, 13 Jul 2026 22:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35D746B00A5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:16:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A63F8160237
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:16:53 +0000 (UTC)
X-FDA: 84985769106.19.494334F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8900120005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:16:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783995411;
	b=oqD4O0vcJnfFH6V06ytqG9Nr3/cB4XyB5IEfCv/4EIM+va40J5CEhCVjS944hw6avQBCuj
	asNGVxOiICTCWVSVNhNd+wCHMrHegxcz6GOdMV0t6nQi21qo8gHzbLW5jgtr/CqaYYisF9
	gBYrZ5WEhteVRZsavUk4d/6uX+Wwrdk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783995411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+WXuxNXu2YiQPlyTnBYb8jREO6PNL9KSv7+f9mDUShE=;
	b=KrCxEA1G5zXFOojnLt+cIaxdv+IUfmWcY7BPrcy9XaGRSBInzwg24v2GBlGDMhkF6YmEKy
	Gxhz1hKdq12RcuC+A39MF3P0udrQQ1wqw+LSvAKOwKGI/XnYl+OQYiNjPFwBygYAmAoYU3
	rn4n8/Q+2THnmBUuhi/u165K2VbOQPY=
X-UUID: 0ea52a127f2a11f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6061745b-ef00-428d-9615-cefe2838cb4f,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:6061745b-ef00-428d-9615-cefe2838cb4f,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:9782d20a55bd8e8c50539e24beaf55c2,BulkI
	D:260714101644V8QQ3DJG,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102|127|136
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ea52a127f2a11f1aa26b74ffac11d73-20260714
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 165745200; Tue, 14 Jul 2026 10:16:43 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation scenarios
Date: Tue, 14 Jul 2026 10:16:30 +0800
Message-ID: <20260714021630.1063823-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8900120005
X-Stat-Signature: t6wjh85spxogiuokwag468u9pjroxg77
X-HE-Tag: 1783995410-331333
X-HE-Meta: U2FsdGVkX1+ZCrlAenDYDO7oUumSYzyVx05OqeSHFV3ZCCLue24UOv/LHnWzmLU/BRnHcXKaAjX1qrP2CszCc9qZNMwXm+0bEzarnihp5d7k/wSxvpw82Cdpm1q9JTkdQDQdJMvD/NcUPwPx47PKhvzy2giOy4GE791g8qT7XgGRPeNyMGBiG2yrGx8E7es1qBp+ftZpy6FzU52PAqP92Vrxc7S/02fIcY/8t1u6homvD0eYi6AAk2k/Pg1F2YRuE3p1ck3lZZ0NvlQzwczbJBXeXVBqxFLubN5wfypFojE+Wi/40p/UHhEPsIdSWiROpJb0CLMqEteBzZD9h/3m6kiAU6EOiDCJk4rEygwadTmCAzdcTOAxvc15j+rCfvAeM4F9XPkqSZwtgYYKzPst1Kv1TnaEGbKO0AoSy6s/2wfVzdZ2C6S8MXrHOwT5wQ8VvINVgq0k7WDUwVcDiHgoBBMiSgSjOBxhssEjXsAY8QoY3a9MLJ1mjXLapFpsmD4O9qZKscMZKIvotSzFJzx7+AgQxMNwqbuObRcUBXIOaYqivegdlgNFm2sdxkapJeT8FVpLt5l9ra8KGuA6za31npHfeZUxMabEY9M5ecSJ2Lwibskzl+NEF8NfT8S82OYLHpXAWkRfalRajn55cMAHyMDJMZ+nqsd9O6nCsFSF0Qap3Hcgcjc2kuod+LEUxWrYNY6YDXWJ/U30kyzmpUrPJ3/TjT0KXr5WHk0glE6r6WxfixUwVEO/QClfGQy7NOuavy6B3D8porvugXKB4lEgpzA39/JE1Wau/0n1Jr++AvBG6QL01HCpkDrHVGYMJLb4iH1p591KFM1vmYGN/wvvE6GwsXiHZ6xQySAzBZGy4HmPYTnRJXq3BXa0q0kO4WZp5nR9JuTTxuGy/WJFgFxFqHvFaGrswpoITmkTi7iYHlBnhmC0zzQQWCmW72+66cy2PDf/qrwgAyP90yMhK5T
 QaHljXog
 ZrTUl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made
the "more than reservation", "more than cgroup limit", and "multiple
cgroups" scenarios unreachable, so they never ran.

Remove it so the first two run again. The third,
run_multiple_cgroup_test(), is separately broken -- a backslash
line-continuation breaks its local declarations and its hugetlb
reservation accounting does not charge as expected -- and has never run
in CI; skip it explicitly with a comment until fixed. Also correct two
`[[ "$method" == 2"" ]]` typos (harmless empty-string concatenation)
to plain `2`.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 .../selftests/mm/charge_reserved_hugetlb.sh        | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index a1cfd3a349db..18b2f2060c61 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -439,11 +439,11 @@ for populate in "" "-o"; do
         fi
 
         # Skip populated shmem tests. Doesn't seem to be supported.
-        if [[ "$method" == 2"" ]] && [[ "$populate" == "-o" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$populate" == "-o" ]]; then
           continue
         fi
 
-        if [[ "$method" == 2"" ]] && [[ "$reserve" == "-n" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$reserve" == "-n" ]]; then
           continue
         fi
 
@@ -496,7 +496,6 @@ for populate in "" "-o"; do
         echo 'PASS'
 
         cleanup
-        continue
         echo
         echo
         echo
@@ -530,6 +529,15 @@ for populate in "" "-o"; do
 
         cleanup
 
+        # The "multiple cgroups" scenario (run_multiple_cgroup_test) is
+        # multiply broken and has never run in CI: a backslash
+        # line-continuation breaks its local declarations, it passes
+        # reservation sizes in bytes rather than pages (unlike
+        # run_test), and its assertions compare page counts to byte
+        # values. Skip it until properly rewritten; the two scenarios
+        # above are restored by this change.
+        continue
+
         echo
         echo
         echo
-- 
2.43.0


