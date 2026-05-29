Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19192CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675A76B0088; Fri, 29 May 2026 04:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626E16B008A; Fri, 29 May 2026 04:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CB16B008C; Fri, 29 May 2026 04:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459066B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:12:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7C5A40F8D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:12:29 +0000 (UTC)
X-FDA: 84819740418.11.8B1815A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf31.hostedemail.com (Postfix) with ESMTP id EE7332000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:12:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780042347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=irfks99Yehv974Ibc5aC1EDHeNBGOG4JXLQbyDCW5WI=;
	b=0QprO8QsdlEVvXL+DvI4f7AtaRko7HSra42eiKCmv3vlMEGTdMoKmJ3yTvuTLN8kreWzcf
	vm7/gM8QTnNGJc+n8AaNg4e6NhgNpwXe16ojlejY/neQSpJZ45jR5kFBRo8PMCS1kSPe+Q
	+uFMD1kwlWCB8ei+thatv7xP+kP92/U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780042347; a=rsa-sha256;
	cv=none;
	b=sK69XN2imAgNzNOn/0uXlnJU8Y1cGTnO6UT7yW21gRIbS/ymC2rk632yo9XE/2ogdIFjFq
	1Re1ufeuVZn88s0t9l7aZ95JKw6UFR7bb6e2vJSLcVpqAT/+kTyPvIqa3F/tQvXn1X+d9l
	ZEFSffsY6vUbAM0Qz5FyRJ7joDqp9HQ=
X-UUID: 1c7cb8de5b3611f1aa26b74ffac11d73-20260529
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_AS_FROM, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:37cd39e0-22c4-42c6-9d62-d1353e358d8b,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:37cd39e0-22c4-42c6-9d62-d1353e358d8b,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:c93644fa71fee3f4c383b2cb6f1dd880,BulkI
	D:260529161219XE6V6BAX,BulkQuantity:0,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|865|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-
	2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1c7cb8de5b3611f1aa26b74ffac11d73-20260529
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1288081750; Fri, 29 May 2026 16:12:18 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: lihongfu@kylinos.cn
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v4 1/4] selftests/mm: move pkey selftest helpers to pkey_util.c
Date: Fri, 29 May 2026 16:12:24 +0800
Message-Id: <20260529081224.2839473-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260529071633.2807814-2-lihongfu@kylinos.cn>
References: <20260529071633.2807814-2-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ptjowjq7sr1na6yispiy9fs9n7a6cu3e
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EE7332000C
X-Rspam-User: 
X-HE-Tag: 1780042346-455657
X-HE-Meta: U2FsdGVkX195qZED4G69ecWVm3pIAIWZPHrYqSVgu9RrIBqze2Wpoo8WIZwmHXpkBGXJ331hGkA+LJaVWzM4DNXgpuUeO6ua3YEKSAQJbPBc88SJTfYC33y3mN7oNQZIFjZ9g2TSe+YkQ+ibgTzJCw04tjVbFLkJqmwU697BvVCxrDNOztNkpmbJYGTJE80IlIBTIYW7SEM9VtffTnz1UHXjhQbogWgBi3MsnB/LdCBmz7w9k6KpsmP+wlm1hYoTTis9BxJjxCaFIA8rAEDdWm0V1hV+KHiW9Enfv/032hfhkHxzv/bsRQC/PNQF1xASRRzPf3/XGHsyL6bY0yK3MKXzHU65P61rec+abzPutTtE8e89aGHk5J7VHQ7cm9ppf5zTSdokYmp4IPwtFwgqSg3auLEqIrvCLGWOg881zhhVkhsuKBFt8Mea6vszl4/rkKTaF78vm6jym0QtUmuDkrVcDjrIpb84f+pyni0w8Vo9nxubJYc03uRy0+i6PuCAE1RUCDWKbCPK7qHDm9ens2JG1qYiiqcj6uunfUydm20iDmqhOfnzDGnA1bigi2Ce46H/lSpR4urHb7CL2zuLPsINfxao25CAQ7dwgt+6+sA6qAR0cP2Vv2Q+X4e9OH3h3UqEsm74btjywD/dcLl3CHJhiZZexRdv/YtSJ4q04kbkcQFqqmh4U43mWoRrKGh989mMKMb201gzX5y9KMkp2pnSROaKD3Srs/kvxiyQ7K7kt3NFHDNxGU9BzNyFPvHn9b7ucumHmPoYgsfcKbUPuurgbGqxfGraf6DnWtrAoyoYk3+CVd3BOcwgbooZUl68FUPfTbYcyTtiu6FfUpu/0yHGzIS/exaz7VCTu/p93vWktAgfbaFAn1eQGbo8qADR3QTmp/OTSozcVDcNtFaZNsKvtlkRZUZ8iPCZ26e7/wYfeEDBk+f8s2OI3Q4p+HyL++UtshTja+7+lA0Ag8N
 z9taUHQn
 zMWel1aLHnY0Q43SrvAm+H7BA8FP2SuNRHo4BZjP8musdKF3ecd8z1dnmScaATuxUy01inw+xcvNt7PTwrO5+iOdHYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  #include <sys/syscall.h>
>  #include <unistd.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <string.h>
>  
>  #include "pkey-helpers.h"
>  
> +#if CONTROL_TRACING > 0
> +static void cat_into_file(char *str, char *file)

Sorry, I sent the wrong patch file by mistake.

There are three issues in the current patch: the three new functions
in pkey_util.c (cat_into_file, tracing_on and tracing_off) should be
 defined as non-static. I will fix all of them in a later version.

Please ignore these three issues during review.

