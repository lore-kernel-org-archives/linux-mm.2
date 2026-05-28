Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D5CCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1972C6B008A; Thu, 28 May 2026 05:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16EE16B008C; Thu, 28 May 2026 05:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084D06B0092; Thu, 28 May 2026 05:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAAD66B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:12:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8992D1C06AD
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:12:48 +0000 (UTC)
X-FDA: 84816263616.03.6954E98
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6484A80009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:12:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779959566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9z0AckncC+BkWQKi810upG7ziUjQvKvyPvDvxtAifuU=;
	b=TaY/AX1zV7MOvmGAQ+PdcC3B+vTt0dkQBR7GQVzS5U7KALDOwvSiqOV3adKYD9U5STijFu
	M75dgKkE/5KQlsUELF55glaXjZY8lgx03J1xInSpTNpPM+6VsCgBlx5J3c03bsAx7ucnMW
	S1w5uNWswVGo//4krB/WEZzhqQXgU2A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779959566; a=rsa-sha256;
	cv=none;
	b=senuSF8p09D7iKF3lv+o9yzMZvPfOVoWS1jZOC3M+PZc8uf5+t8rre7yXi2mul3tIQEOo0
	zifpG3Y4+64YwacOFKnQasIi3l7rJgGR2l9c7MZaMtcVvAaSD/9mHU9QDiu9g0+sqJh2nK
	dkAYCHuoXFBST7gtwjvm9a1btekO25U=
X-UUID: 5e51cb4e5a7511f1aa26b74ffac11d73-20260528
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ff5cde3a-25ed-4618-b324-685c8a149aa1,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:ff5cde3a-25ed-4618-b324-685c8a149aa1,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:380fd8ac2ccc9666c92fdee4fbdf1c0d,BulkI
	D:260527193311ER6VIRO3,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5e51cb4e5a7511f1aa26b74ffac11d73-20260528
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 330964409; Thu, 28 May 2026 17:12:36 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v3 1/2] selftests/mm: refactor pkey test helpers and unify assertions
Date: Thu, 28 May 2026 17:13:00 +0800
Message-Id: <20260528091300.2082967-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ahbWZJ2BbR8mmDd_@kernel.org>
References: <ahbWZJ2BbR8mmDd_@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aigf6j56p4k5gbow7qx4wsg79imx38r7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6484A80009
X-Rspam-User: 
X-HE-Tag: 1779959565-597159
X-HE-Meta: U2FsdGVkX1+FXsDBXBL2VUgOZVRgzaCeml7ivt4oSerla43D6G9Ab7DA5H/Q9tX+JJqKFRcCYjTstPQZNxX6W7a/czWf7G/zFYuh8lUcwGPGViTCoA/zIetlmdz8nkaOj2poimfSeCxHaSDdUfzwoE6kovkJTeVWATCNffYLwNp7mflY0yAG7leaQXRpJWdKSMkrc12nCsW9Uh3gFSZk8E9noBXkNO9lGt9T8yZDaUv5GMHgFCoyusS2SBK5kv0fkE4NLVaaYrGcnpfERtUd5RGYPmHr9HrctDN7OKg5wQZs/wodRj4zy+6ypTpSVWcJKpH8GFxd8xlR7uootW1f9OvDO6JwxYilLZ4Ut9McdBUhfcQjZDsvmy32awvNCtWg4SIjxI82LiGRYD9J2mqQErk7idmJGVdnPuqW+29YZErSKJkzR42d5tJZlvmTiZobbQUPQ79BJAM8fCQMme2660tgrHHTIytxUcyBd+/vq7/yn2B0Ucmnf5Gr6KYxrhM7aq9U6e1KNYFh0FD7beDQ0RtdZf3ix3ULlnr8Yno7D3zVL6zrpjB0GSXmt2wGQ8kUUV2YqcZLlr3NkGZ6srHlmwzIMxUWGYV3CIEao1YW3GdD61Bo6WKhpHt0kXx3NjR3BwXdxlKcSF9Mw/Ku2gBDLhvRXUXs5TljvMrxw2KR2f0eLvINOElIu0eTjHyyCyY2QjwqatSpPgjLKWMc2UgjDpn/NeWGvSnEPDw+buGXOiG/ecUDPr9q04lw1cJ6DWpMO+1X0ioj38PEoATyrGemhQNkRhTUQqYIcndhdRu4d/+9UGz9poZo9TWDaRDgcqeUWg+59Rwt6RsjuXfXhr7bxm9GzN0RXBjHV5I5k1L4RVymue8QiPPNJefbofNRNaQ6YKndaKx/WnDBshZi1xN+7dfd0FPDcUbno6o/XhkCD7ViKGe9etTv1D4jZj74AveeiGUxMrP9lEOXvqCoE4Q
 /iV321B7
 FRAje
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,
Thanks for the review comments.

> > Move shared tracing and assertion helpers to a common file, then
> > convert the sighandler test to use pkey_assert() for consistent
> > diagnostic output, and add per-test tracing around test execution.
> 
> This sounds like three patches to me.

Got it, should I split this into three individual patches?

Best regards,
Hongfu

