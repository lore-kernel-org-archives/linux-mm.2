Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC06CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D42E6B0088; Sun, 10 May 2026 22:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784746B008A; Sun, 10 May 2026 22:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6734D6B008C; Sun, 10 May 2026 22:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 538716B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:15:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9BC440576
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:15:53 +0000 (UTC)
X-FDA: 84753523386.16.7EC4A66
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id E163C40006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:15:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778465751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=veTS+VMGg9ylnkd7Bf5TqHVDPdSnNSZYa8LJgLXkTOk=;
	b=ifF9fFt4/ul1GIbJolrTBNiJK0hmE7OxAIeU2NABXcSiEAG1GhbuMsG2OKFJu2Dc5cm6Qn
	p0hZMoX829UwamotanA7o0dSwKRWMdIjLYSWq+qpoO4cJyouPm4I/cEUzawAPlmTX675sN
	pMHiDMC4VsTb0+3pXHibD1ZYB0OSJnM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778465751; a=rsa-sha256;
	cv=none;
	b=qWP3HUzMrjXX2o0iKDWtl6By1jtKEBJTHREOY8EFTa46tJpLsWv0MNMTKwVWEbn314N2ux
	BxLf+5boyGBudFrpWgqubej5mbGhPUtgE5CcBq2EdzWvZJNE/IkKcSjrDCg2ih0BfbK6wt
	lG1p310e7zCXCBXbi2ciuvRuE676TO0=
X-UUID: 4f8027d04cdf11f1aa26b74ffac11d73-20260511
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:42d4a2d6-9824-400e-aa51-21302500bbab,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:42d4a2d6-9824-400e-aa51-21302500bbab,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:c0f1bc505a59e0244e4d02c0d05f47b1,BulkI
	D:260511101544MUQHD3MK,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4f8027d04cdf11f1aa26b74ffac11d73-20260511
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 485543758; Mon, 11 May 2026 10:15:42 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/cgroup: check malloc return value in alloc_anon functions
Date: Mon, 11 May 2026 10:16:15 +0800
Message-Id: <20260511021615.1768623-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E163C40006
X-Rspam-User: 
X-Stat-Signature: fn7m1o5ff5j9y4awp8mufcmsnwze6muh
X-HE-Tag: 1778465749-820037
X-HE-Meta: U2FsdGVkX1/81cz3bwOX/f8mqXEGS4kkQIA3g8fo9SUP12NOrCqu2v+yANBEN7TVQQqdBzWxYEcRv2SjL6UOOBNFpWGOSPHnC+TP1uYf0miAZk8gA0cF0OH2YHiTjMdJIiD8IF7sn6BXOKSQXPGlff2746Rcnk1YtR+5m/Ms0Zm5cL1wGIlQVRjQNmIu/tniwUqTs/casKJz09KDRIjbM4azIrOUcbMA7IGt+At/nDvlz9sUtCUY00nJToF/WJv+4vKnYWO8yAWOnZgdM99047h3vkOKnodGYZT5ICg1i/daGO57sevcuES7tTSJPLVQGzMhqdMzLse5Gt8P5BqxH4A22R9FHRBbtvF+WJoILEjFO7bMjmRjauGCv/aIT0p6PGSSi2MOLfn6mdpbucU3uzbQqYsmaUbjp8zA3MJcsv/yVxcoaHjzT/SiSH/gY/ABtF3i2GgHQnbYSNG3fUrRRaEjoT3OWqbBm0f3mS9cEVqoxQx6qh34Kp3Qw6gIGyoE5RFWS3D34ndrQd8gDzfynncJ+/nFrGULwM2TDRJZyhiLMCkI/1xf7idAgjXmA/9UHGdJynEv4OYFBC9wgwWfo+0BJydZZSYZ2eMsfW17nSllrvtWiI69ASgL6VXiueHrkcUvN80LmGBzmc3cawXEPmBQX+Fv6H05cnsNc304OLKnmuQS6a0Pn5lMluHsYc3Q7h/xAXDEDHukCvMZlErV1vKRTmQHgD24eJ87yYh+c0/qrqRUlKUCqW+5dQKpxZ98btCnesk/l27vhPPZg3tBTLBqyrg0OKZv5w9KwQj8njxGi+Qpq9u69/Ei8KPjyfjkjx7o8eDuzBe29leraQTBgmMQHtIFGJNxB8gOlLxgOesz6uYzfi5P6MvwkRjiVqRfCPe1IObT9eGHbtDeZye7kjygTcjixqM5jqt8s/6c/2lEVj+oH4rPeMDzaiR5iFMeSFllHifxRKnaA1S84Yq
 vSmL+wgi
 iY2r4yH0Og7JzOUIO3c6NAiaku7R4PGi4mTNWuSbWPCUKws4NlnkCIEfOxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_anon() function calls malloc() without checking for a NULL
return. If memory allocation fails, a NULL pointer dereference will
occur when accessing the buffer.

Add proper error handling to return -1 when malloc() fails in all
four alloc_anon variants:
- alloc_anon()
- alloc_anon_50M_check()
- alloc_anon_noexit()
- alloc_anon_50M_check_swap()

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index b43da9bc20c4..8ef9c99a82eb 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -61,6 +61,11 @@ int alloc_anon(const char *cgroup, void *arg)
 	char *buf, *ptr;
 
 	buf = malloc(size);
+	if (buf == NULL) {
+		fprintf(stderr, "malloc() failed\n");
+		return -1;
+	}
+
 	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
 		*ptr = 0;
 
-- 
2.25.1


