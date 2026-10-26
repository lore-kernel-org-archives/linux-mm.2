Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE434606A334
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F916B05B1; Mon, 26 Oct 2026 04:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12936B05BF; Mon, 26 Oct 2026 04:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01DE6B05C0; Mon, 26 Oct 2026 04:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAA166B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:09:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38A49C0672
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:09:53 +0000 (UTC)
X-FDA: 85364053866.30.4F73911
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id A51F240007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:09:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793002191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=kaXgUnQxIrgvPK4dCGjQGvShDGNk1RfsioOGgqsxil0=;
	b=AoI098I0Zwj++aOITFEAjI7LA1whK7WKs+yyKmmZI00fLNlJo1lfxiWvjSbEXI5kpx0LB4
	I95Pp0fFhLRQhi5ZrBOZGOdljup1UAplW+e7X/EpCTSebt7nFVogy4l1E53B8cVUuUuvuz
	qDWG3eFKPU+WODo8Z69onlJcdwiuelU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793002191;
	b=6PY+faU3TXm2dUpAuuniJuUDle5bYhyGX0uIFo0sBDHeZYx6FK4X/m+6X1G/kn07UCW3Yn
	eLjCoyeODxhPN9UVss1k8JecStbeoCN4lsN9+k0II+R+c5dWRy/INwZ83TEQfWDcMlADtl
	DH64izWKXC6VBghd4VzHB+NrwQR7mrA=
X-UUID: 9643bdb2d11411f19a56ed5b684f684d-20261026
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e3ce8c80-15f6-4922-b9a6-3123de19c510,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:e3ce8c80-15f6-4922-b9a6-3123de19c510,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:005ba305c1385bacd18b1f73694b1e49,BulkI
	D:2610261609416N1QUB3E,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9643bdb2d11411f19a56ed5b684f684d-20261026
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 648359560; Mon, 26 Oct 2026 16:09:37 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	danielmaraboo@gmail.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH v2] docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst
Date: Mon, 26 Oct 2026 16:08:56 +0800
Message-ID: <20261026080856.76175-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A51F240007
X-Stat-Signature: iozpirfwthfe1k8iepfctzy1yygub5np
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793002188-197510
X-HE-Meta: U2FsdGVkX190LftZKKtYXve9xOuFwhoYSGW9h8npMfoex2kliUs3TqwWHdbhfT2SkgncBp1ZueLDibA4a14TzxM6xt0faLr5+PTSI0YJEK9aWyV7XskWntlrhDRdH5sNZsbsyWS74SDmmKFT088od+IlUdLmLa+9X/8ORfyMap6hUYSuWOzONTPIQJcnqt0k507FAouF+IOwwFZYsUr+ARUlg/3AJXyWeZWigAUMTBQFJvvf2EJMlkdwbN50Z06YRrf3p4I4Y5A8NxXgSuZlCMVQhVClIVsfI7G7zn08lB3J3Xeohd0J1mOoCZuNhDLfWBhyTIjQlnrLYQg7ZeYlu+zWPjX/zlllWoJKFZHHInb8Va7+cPn9avcW14Eck3dszeO+vGPBT0R5rODJbT4OUGtHqJUqUEBbEjLCCsbwwvz1BpVXGSg9fLVn2mz1SADBjGUZ3lKjqkL8m2Icknzf3jLlHSe2c54jT8LbRTwN5ahregNBhQ/tqm4hoLJI7PkFo8LUT46Rs/TdCGg6n+n3rU1Dfl2Q7wY3fd3tjNvn85tAkMlNgrnQ4NO6Hup9UXl0pSaGfDMEFS83wgW1lYJRT0ydyARu/2tMPBCqo+w+OnHaZCUeFO5MxcLbZpna7xAm6bSp2eNRj0BdEHAvOKdojxTyZBXO99ODjTWeCaX0RvYpy/rW+A2h7d55Soxl6TjdVCDDFyZxVMzs2jMDF+BJgMtJSb5XSSPi+SeGnYjVJcR1bYBaAp5HJk0ngTDTMsXU/l/P02qVzZvy7R587e3Uf/wZtd7AU2eH8vy1uVWraV7BQajS4FLOaMiwR2QeOBb4h+eljZNY5ZOwyqalqU4rX+JgJt32LKKm++hPVCIxYZf/y+5D55r4D9jBNqx6O3Utm5kNMVfHT8dyvb4mv16yYvmRjtP0h9N2YLVcWG8BAwrith60dPgoSTqAca+KuEsOfl9v5iJ8ENrENGINeUY
 370pjoVR
 LshK4c8HxRHYWEQyiWRKkihaJnAXJDQns199s0astGRXxRWjIWiHOUhZULtbyxeQWj0aO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"the size of the pool of huge pages" confused me, since it sounds like
a size in bytes.  It's actually the number of huge pages of the default
size in the pool, surplus pages included.  Reword it and point to
/sys/kernel/mm/hugepages for the other huge page sizes.

Suggested-by: Daniel Pereira <danielmaraboo@gmail.com>
Signed-off-by: Enze Li <lienze@kylinos.cn>
---
Changes in v2:
- Drop "persistent" from the description
- Reward the note on other sizes.

 Documentation/admin-guide/mm/hugetlbpage.rst | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 2075f1f14a42..282bc420d97b 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -43,7 +43,10 @@ The output of ``cat /proc/meminfo`` will include lines like::
 where:
 
 HugePages_Total
-	is the size of the pool of huge pages.
+	is the number of huge pages of the default size in the pool,
+	both persistent and surplus.  Counts for the other huge page
+	sizes are available in ``/sys/kernel/mm/hugepages`` (described
+	below).
 HugePages_Free
 	is the number of huge pages in the pool that are not yet
         allocated.

base-commit: 3fdcce698abd9193752ee89fb1a440cdceb1b74a
-- 
2.56.0


