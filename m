Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08CF606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09B66B033C; Fri, 23 Oct 2026 06:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2B66B0341; Fri, 23 Oct 2026 06:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFDF6B0343; Fri, 23 Oct 2026 06:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7822C6B033C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:10:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04EC28034D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:10:02 +0000 (UTC)
X-FDA: 85353470286.28.D6A9F20
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id AE27CA0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:09:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792750201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=P2O1ni6/PtH6SUrA5XShDu4rG4rb28qgUj7QslR1v6U=;
	b=KeMEcMFIBZweYYgUAl1qoobjAiN0o4Pd5gScy/o0g50xtfQ5CzNd+o0hdWNxG1mTH5Ingp
	H/0Je9UQldp7aC3cStKTIThHxANi0dQiyrDWf6wfrtq8AHQawLs81/TiPKLxz09iCH3tjc
	36qoZk7Mph/Z5xZbqoXJ4IUpLN2ZxKw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792750201;
	b=zbH4tkN0hVJ5noIaIIDCToZ90W3ZUWN0ObyVq54KttpdOOqZs6SX1ebr20TETnd9u4sDL3
	oE7DXnQ5DuiHXvtdEndi8uTAVTmJAQAMf7odWHMHoVry2wDEN7CgNyO9RxsPVpW8hJN4mU
	i1ZyKuHMS8KSlsr7C8tkxMkGmmtUPqs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: dfe0c890cec911f19a56ed5b684f684d-20261023
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:68d9af36-cec0-4671-ab20-a6872d0fc5eb,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:68d9af36-cec0-4671-ab20-a6872d0fc5eb,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:3ed9c0dc68d48b3709c4657cbb3dbc5c,BulkI
	D:261023180950EOOPNRBP,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dfe0c890cec911f19a56ed5b684f684d-20261023
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1282895732; Fri, 23 Oct 2026 18:09:46 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst
Date: Fri, 23 Oct 2026 18:08:59 +0800
Message-ID: <20261023100859.70744-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE27CA0003
X-Stat-Signature: 4c6pwq58gu6ykimbh4tbie4hmpjpwyix
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792750198-286439
X-HE-Meta: U2FsdGVkX1977a2wcthff86ZbDDFF3Ifcepn8reCHXUiBdpWeAfnoKE6JyM6ddlYX3nzWj6IJ2rw7RfnRXuXQvhHDbZDzppB+AxlPxk2PSacI8fmSiOtUn5JIOF9VbZYyjtd2SPIGeC3Z8Dyg263shfFoD2X+dsjM5wuPyTYPt0jmEVsqits1UrNcrXGr6NUpNii8XORAcWogQiWAo2kFtw77cgN/GOdq6ejVElBg47D4OMRAcblTDTx49bNfUxIGbOtgXPEI5/eIl0zm/tgaL9SWurOB7dz769/ggCRPwnABuNtiO9Do7enbKPa2RfYiP1nF8hFXXhIg6f8qf+cn/s3bYW4tcF9koRVJkHSX/RGnkTkne3vgZr9QambIz6q+3Me1JLLmLFTI3dz++hAiOkRjHPd8q2CzU3j23/1K1dXzwYBiy8x+ipbyWozefl9cjz4RQpARDyZb7yu9m2utdJliO33C4Q2obHQnJMltKA+Qc/RPNyHQOiM+cAtK/dH3VhutcgOe1Fuujp33OtUJKUuoz9a5A14MXUQHD/mEXk7oW+DXN7OOj5l824fsWNjiu1IB9tOgz3xd+Z3Kmu+QR5IavgexTtZmC6lslc5k7HLZBWaorNrvlYtRt6adSGuCEcLT+FjHWKO/ZTP/3psz9T8yS4bPS9Pp6JeoMl5nfmaS+Flumm40q7KyXc54vFtqluYzbozGTZI6orN1uUMgb2d7q4AYi2Qt/UFgdOdezYVGp8w8Z297p9oqhyar/EpmnWucKI71QNlaZOLrxWsPTF+0+N1xkEIM4lFd/4ja7qtvHHPWyZZ0GWChQb+D4RhFWQbRdwaWxWuMDlNZ+Z/z+HBjxF8R987JtP+KBCvDCd0CI4bC1PZIKKTUvtr4RmInF1mnw5n/KAnLenBWvTCQjgifMGu1YHe4AY1odk76z874M7+G/CB4kQhMiQcEPSeMSypA1Zc2x/nopD7Uv/
 ua+gHwo1
 edLq2S+t7wnWjsnuVIVP5SRnh7008jF9X60uFfPHOb7zYh8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"the size of the pool of huge pages" confused me, since it sounds
like a size in bytes.  It's actually the number of persistent huge
pages of the default size, and pools of other sizes aren't shown
here at all.  Reword it and point to /sys/kernel/mm/hugepages for
those.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 Documentation/admin-guide/mm/hugetlbpage.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 2075f1f14a42..01fa9f61c9a9 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -43,7 +43,9 @@ The output of ``cat /proc/meminfo`` will include lines like::
 where:
 
 HugePages_Total
-	is the size of the pool of huge pages.
+	is the number of persistent huge pages of the default size
+	in the pool.  Pools of other huge page sizes are not shown
+	here; see ``/sys/kernel/mm/hugepages`` described below.
 HugePages_Free
 	is the number of huge pages in the pool that are not yet
         allocated.

base-commit: 3fdcce698abd9193752ee89fb1a440cdceb1b74a
-- 
2.56.0


