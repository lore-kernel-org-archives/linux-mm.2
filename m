Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3162CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBA56B008A; Tue, 12 May 2026 06:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C886B008C; Tue, 12 May 2026 06:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AFC6B0092; Tue, 12 May 2026 06:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E156B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:12:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79F23A042D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:12:55 +0000 (UTC)
X-FDA: 84758354310.28.F6F1C47
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6813A140002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:12:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778580773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=UCkAwW8L5QtyzWBOaVFYV7IxrULkkpyIcxwwXoobR/8=;
	b=vVZTPSkCGqcCQt/dWWEXtcR7IJCaEvOrXtiDJqW+vqmwSXVyX17JS5xxCX5naR5NQCzF6a
	b+R0F2DxiGKFUn5l6c3xhQkcHlASvuCOQXzPfW2eguveAc05++wpaWbt4uDw4kKdy1CKA1
	Vm3/DF6oXfddMs8rYupKBIy7HPfOM0A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778580773; a=rsa-sha256;
	cv=none;
	b=drPbrVuGHEaQ2WZ8jgUgD9KKO8kuLZAzrpdc3a+Fax1MeSmS4XSZHOl6YAnafJULnHrKUV
	WEnjSpysIKWSGSJCdUHDYFmlwlMv6vsr8iykcA8BRUSpnxepeWeISnRlMGV4aSzE0bAu3T
	ySQfDiwePs4JtMAtUKAKjLHnAVPn3L0=
X-UUID: 1c7cb5ee4deb11f1aa26b74ffac11d73-20260512
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e511f9d0-06d7-4983-a25e-d0086108c149,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:e511f9d0-06d7-4983-a25e-d0086108c149,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:59f88e905d8dfcaf5c0b5915116a76db,BulkI
	D:260512181244RW6IEBAK,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1c7cb5ee4deb11f1aa26b74ffac11d73-20260512
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1415767180; Tue, 12 May 2026 18:12:41 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Fix mmap() return value check in run_migration_benchmark
Date: Tue, 12 May 2026 18:13:05 +0800
Message-Id: <20260512101305.139509-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6813A140002
X-Stat-Signature: zuhes73jotn5szbmyprsd3yj6p1114kw
X-HE-Tag: 1778580772-901599
X-HE-Meta: U2FsdGVkX18/mwBjELBYJEee4z+ZAn0Juo0WMktMA75t9wbGwChCR1oGcldg1BuGkev1sgd+/EbuMOX2vZxP4reTQ+GT0ANu2QEK3BU7Tfm5/7yX5rGko/gmW6GGV5EIsBrU3NK1ahpvje+csSc+jlolPkrKMdY83L0aGctcRYH1b4JUsfkRNkWJr8PMyjaDaqAn4/RA/wgf1HRadfmHy+MdjVrHVNsYN6tVw0mbIRbkDlaFft6t7x5hjaiN5WarheCJxCDgfeCGZuGqyDMVugd0eLiVYezKM/fdZx3yH1XMYCiAKBEDdoyBJYvfQBmQzT2Yj61++3gWeLmCVDM5Bpcb4mW+jiFnpqufEdU/UAj4AERGFHFtuY59KHCJoBJ/BbjDhG01NokcqqNhn9CWix556YsA0LbyCItXQFEP9/VON6UPbAyFSqhY7/eHSu8osHlGglqjFw6Vl2jQwA3iaGnHim26AOvZTpl63G5DHLIwSt/PGqtYDzk4CF70Itv95U0hko2LQjCsVDedaRLtE+JMc/BkScijSRvMaVR9UgX2V/U2Jssz6icsj/SBqkeNFdw1CqLg/NFlJl2lQOxGa7jwSRB43n7zECSVJsIKixqcwWhmO9e1TYgPBSRwx5uE94Mf8OfkOfvn+ldm5IUmQfDiboh5PTrTRB8KydssfwQ5NVgdWaEVVtPr6gKo4LUo6pMMvaM6oh8b6ShbmDNUYBMyI35xKR5v24g+EAjNA+sZMFpGVaZbUZqNvkrMa2dbFu3WFMjYhd+x4HL3uhZYTsOc/T7SBXGe54s7ZkoKULh3ZuOzDK3b0cORpI1XnIx0mlap7ML/4B+zPDFe3IvGQmSiPF7cKaI0GAMT+TLkED09tCAs/WVE3OwC6JAnSzNPhXO94thMxLL5d0soMBmuXUg7fUtY5xy4lWy+z/FHCfKCYgGEqqhJy11dFRQU/ISKdtufkE6G3BN0CSVPZlT
 EJXhJXgN
 A6WjCo7fakTTTTggpBHL646L4YV9gjXUXHra4VwVfC6E3JyHd4EMBpO0E32+J/7+qedLlwwg8Evm1d3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap() returns MAP_FAILED on error, not NULL.  The current check uses
!buffer->ptr, which evaluates to false when mmap() fails (since
MAP_FAILED is (void *)-1, not 0), so the error path is never taken.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/hmm-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 788689497e92..d72adba5c74e 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2688,7 +2688,7 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
 			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
-	if (!buffer->ptr)
+	if (buffer->ptr == MAP_FAILED)
 		return -1;
 
 	/* Apply THP hint if requested */
-- 
2.25.1


