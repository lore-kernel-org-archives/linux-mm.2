Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259D8CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39EFC6B0088; Tue, 26 May 2026 03:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3769B6B008A; Tue, 26 May 2026 03:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3346B0096; Tue, 26 May 2026 03:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2356B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:05:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6E0D1C01DA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:05:02 +0000 (UTC)
X-FDA: 84808684044.29.751239D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A0984000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:04:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779779100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Is0sUNpSb0YrugYQVnNN+gS/Bino7bSOBkAs8EHFLKo=;
	b=EyAxibDIs0S8wFfr4DdUgGoTmP1khhlFCU56+LNNQMlgtuOyG8rykNLrV6eCF0Ah73+T88
	fyMqqTmpWOkeY86rsaaejVlPahK0459kVgQt2ziRM8s1L9yJKqeZyY2yNIiFJlr/OpoHPE
	V40a7/lksQ81aWywqsGYkertrO001go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779779100; a=rsa-sha256;
	cv=none;
	b=Zr9F0MjfyBUylkn6I/StbdfnpliWJvARmQxGR5pOicmpQSWwiu5iyOCWx16lvxFvPQDYwl
	cGzmikNBF7qz2AkUkBGlnFzpXzKKeca3SCKlfG1n0++wZLCzbFk15lyi8K/1j6R6hrIkiT
	HoDtyOD6yeiE7KyxXtNR3JvEG9BweVY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 30e0f0b858d111f1aa26b74ffac11d73-20260526
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:42662379-1126-475a-a33e-126b52d8613b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:42662379-1126-475a-a33e-126b52d8613b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:58d5b093b27578273e84c3fac36e86a8,BulkI
	D:260526040209ZS2AJ5N5,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|865|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-
	2,URL:11|95|82|99|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 30e0f0b858d111f1aa26b74ffac11d73-20260526
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2029404424; Tue, 26 May 2026 15:04:51 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue, 26 May 2026 15:05:18 +0800
Message-Id: <20260526070518.630740-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260525130200.fa26a0456979d8f1045dc930@linux-foundation.org>
References: <20260525130200.fa26a0456979d8f1045dc930@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A0984000A
X-Stat-Signature: 3nd6qjmhntu9y9umaubk5pjrs3our9ws
X-Rspamd-Server: rspam06
X-HE-Tag: 1779779099-752888
X-HE-Meta: U2FsdGVkX19edCKJ+8hefrorjSyl7CjoRRt/Fb19i5JY/eI+UsMIrKq1ZYfMu3PbrltRJERXYEp5fB0DOeJYSz91Nje4iPjWcfkx+93JoqHyrAitNQE85N5UJDi8v10FqeoGQKXMWIpk2GwSJqPzjdLPCeMB5wXYQHY7hc9gMoTVSb8skX83FKuOvO/QG4s2aFEhQn95obpeTulZOqChC+f4t5fRV2RiqfnF8tPLYA6idVkUDWEtt24iHat0bId2KOlnEAolT/6dcM0XxrxUvha1hg5Va4KejGoMgvBiC8c5LWEyT74v/9kWsKkC9/cFctZd5PtaKXfnRSe1HO2UlDzoYl8gl81/63WtcpEApQ+ACtaHXFpB/qu/X5o0JY9aYFH215cPNxNPCtKv6XDc3JkcbOp6xfQZ31UdGim36jpiRKCrsPNIjNNDwODUEMBSKGC7K7k8rc6MTYQDX4hagXKFNkC/7dFUbEhniS6EJ5+E3agW1ZbDrYPODfevJRL9H8ky+MtQ1CacjGu9kREp6BoN4Z7j+vzzMBAakrtT272f70pFAkFDgzwh/AhdJpQrQEhFfNUdoPkEnOkDLMF4fKwhQYSts8VIzySNKrWeDfbNi081ANfIAq+qU+kZiKP7dI4mqE2yw3LqsJnEP69vDFUK7zBRwcyrX12sikUZ7QsDaXiD2DA5d2B70jmt76A01UnrXlFuFhelWviaqwvgLyTOZfvaCf2MbDWqx69kiaXoRvySjFJ55jRZJjQxaILXqJQjb9KYNji6uT0tDJFPO5pmEV4tgliOaet7spL1AueF6Q/6GQEBMBhJu9ayQjpAiH8vuZS0hcKXxqXprzHXrmlnja/CC2VYVGj76N1h+u67tgYdkUwgm8KLe5qvccE8u7cioeWqbKTQL7qXytegOZChLyzC+E4fyhg5Lz1wq7Umf+jFzcxFxXEtQqCgkPKyFUu5muCpFMqLTIRrhEM
 aeiPYABR
 Vs4BfIY+e3gfYCviyd807FJFP33/PRIZotgwf9HnIAjpPVZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > This series is version 2 of the previous patch [0].  In v2, the changes are
> > split into two patches for easier review.
> > [0] https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
> > 
> > The main changes in this series are to refactor shared tracing and assertion
> > helpers into a common file, unify both pkey selftests on pkey_assert() and 
> > per-test tracing for consistent diagnostics, and add missing mmap() return 
> > checks with MAP_FAILED used throughout for readability and consistency.
> 
> Thanks.  AI review seems to have found a legitimate problem:
> 	https://sashiko.dev/#/patchset/20260525073026.27594-1-lihongfu@kylinos.cn

Thanks. I'll go through the problem reported by the AI review and make
corresponding fixes in v2.

Best regards,
Hongfu


