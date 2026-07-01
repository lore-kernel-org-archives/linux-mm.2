Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22D3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C16B6B00A6; Wed,  1 Jul 2026 05:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8720A6B00A8; Wed,  1 Jul 2026 05:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787E56B00A9; Wed,  1 Jul 2026 05:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5121F6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:34:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BD4B4C18C3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:34:45 +0000 (UTC)
X-FDA: 84939698130.10.FE5F963
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4B159180009
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:34:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898483;
	b=bbjlR0u9I2kNs9xiV8PmXk4alngFHf9S1Q3JfBrWXgGEzvZtWx4+DbiYwybzHiR2L8FUdx
	RoWTdAbwAh39K1cWWVg3mnOB9m9LBK/gTyexCAqZwr8wV5BQ9bA1t3Z/SqEdUTCC2Xwhc7
	N7kBa1gnTa0pnPIpdWX//4tP3Cq1gEI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/D06txxDSgTsnBt3y1Eq1cF/Mf/W4O/e30zp+RbcFg=;
	b=6rgkDMiU3CKCFpqgU0SJi0OCTuOlunKABkAVz/o3XzksWuMYFa1+RT+yEqdq76v/BqGpsd
	s93jiSepMlqUYq+dYB8PwKsxkK+C0k6HAqCV8V2Azlkk/pbt7h71mJiIwMxzvMlRCWbJa7
	t03cQRP3jSNjb0i0XvP8sp80KvsE0hI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 1113b10a753011f1aa26b74ffac11d73-20260701
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, UD_TRUSTED, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:970d99d4-8253-4c56-8368-b9c69dd2b073,IP:10,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:5,RULE:Release_Ham,ACTIO
	N:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:970d99d4-8253-4c56-8368-b9c69dd2b073,IP:10,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:5,RULE:Release_Ham,ACTION:
	release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:8b8402ad9c21dcc999cbdb798ff47165,BulkI
	D:260701015715N11G8GYR,BulkQuantity:4,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:1
	1|95|82|1,File:nil,RT:nil,Bulk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
	,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FCD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1113b10a753011f1aa26b74ffac11d73-20260701
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 52202154; Wed, 01 Jul 2026 17:34:33 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	hongfu.li@linux.dev,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	kevin.brodsky@arm.com,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	maddy@linux.ibm.com,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	usama.anjum@collabora.com,
	vbabka@kernel.org,
	yury.khrustalev@arm.com,
	zwisler@google.com
Subject: Re: [PATCH v8 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Wed,  1 Jul 2026 17:33:50 +0800
Message-Id: <20260701093350.324357-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260630222022.60d0951b90af8857971ad10c@linux-foundation.org>
References: <20260630222022.60d0951b90af8857971ad10c@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qeiumhqjoehtce1gym37jqgihygqzcso
X-Rspamd-Queue-Id: 4B159180009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782898481-276026
X-HE-Meta: U2FsdGVkX1+naCf9SUKDN3ETqBEVqZ2GGwNgb4FBR4sPAN8iCj6NWYPIhyxyWvqoDP3rsxX7DerIcFv4KwoacuztvC5ziMNCAFnc+lAgm9Lcur/pHYSCdjMlhQVVdqDgutVhIBL6LH/TGWx+5hi2VGTE6MAfryRD7ElAdKxJZ7tuD6m0g3DQX+rzc1k4rp+9VhuLMrDMXMQKIYhVfNqzoF1ZAb9sKuGzUQbAYT1UD1/0VcuLhAUq1m3tM5K8Mz2jfzRsoIVtCKCcyevgujMPQb6zGShsHSRmfVse+7QHza8ygFCEJG6ryWMz7ZuJzot7JB0vsxJApP3vC8T1joU0e7Tkaop3ApSoms/0rNA16xNbXBEkOh/R2nKdv/9Fq1QJYnoI0gYqyzauTR4ew5WZabgjBau4KduqMHd8vvle9gbmmoK8rYlxHdNlNc6RI6Wx0IiPEWSsIXn0bhtwIx0Ny5sYPZbyF+gKpZ17Vx2aqhGPJW8iva/CoUdDTgzOFBZwADU7dhne+/ibzyVbIfo7PxNh/Pufw1fb35xb+3LZniswGr7OKQ/KDZ9SP2WsFbJ4cdZrUwX+TD+XCCyhemS84s9e+3Ir+5a8cBaJY5wCbuXWz+8B5ZQliEqVhUiaMmoPXxBIH8GfEf+p0ozde8qoKaYUZCe1vLUF3InHnu/IBlDpmPmpNCpc+8AnJMHuFedsymrmIQ10Bhz22w7Ap54XUjTSdXMpuzF1IUcz/Tf7rqO2Npdq6ZzE9FnpnFSfw5XIP4QJgT7Ke6BCUPopzM7XPWzwmyHc3B1CBPPopiCMT3m3J73/YHhigIOnwL33uGzwHNc2i/zSZbko2jJVFSQWOQD3NuQUnzmB8k5UxeukTEvfvV9XquocxoV5FKEPCgSVUFjQ3O/hJULWuXll8BOOo1S6ZoelCUkGh/HKRL0X1d1+k2BdP7ScxQyMJ37Rv2FtZRISBV46SdqzkKBBY6Q
 /aJmnyqu
 Zqpzs+M/Q0ltEsPoktZJ6PX73/ezvLtVl7d2hDa0ZZl18oIOq2Bmn9PCzAwJZMVMGiNa9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > The main changes in this series are to refactor shared tracing and assertion
> > helpers into a common file, unify both pkey selftests on pkey_assert() and 
> > per-test tracing for consistent diagnostics, and add missing mmap() return 
> > checks with MAP_FAILED used throughout for readability and consistency.
> > 
> 
> Thanks, I'll get this into mm.git for testing.
> 
> AI review read the pthread_create() manpage and didn't like
> pkey_assert().  Please take a look?
> 
> 	https://sashiko.dev/#/patchset/20260630073235.3802271-1-lihongfu@kylinos.cn

Thanks for your reply and the plan to queue this into mm.git for testing.

I've gone through the Sashiko feedback regarding pkey_assert().
I agree this part needs adjustment, and I will fix this issue in the next
revision of the patch series.

Best regards,
Hongfu


