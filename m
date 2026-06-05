Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D49CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB516B008A; Fri,  5 Jun 2026 03:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C216B008C; Fri,  5 Jun 2026 03:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B7B6B0092; Fri,  5 Jun 2026 03:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5334E6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:32:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01C651403C6
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:32:26 +0000 (UTC)
X-FDA: 84845041134.15.FC9492C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC46E1A0006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:32:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780644744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5HAbQRGNJW8PSm0gEz+FvNo7xMhMsCG7O0pRCtM5xg=;
	b=Wyeve1aQQPSMbiH7PMTQO7GGFViCUY35kVcEhiLWHpuCRtRZocPPJ+eZT1MCgrHKjbUDV9
	p2nMQNN8oPSp61X2M9wCEjxHoscYH4fMxO1m7FQfGCfoBGMxFr1XfZ3wLy35SZAMlBJx+I
	yNKaX9l3rWJhzSmTQn3WmYF6W1yhV4U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780644744;
	b=PoEQ6zFBTMXPpN5gzypYD+qa3EgSbTgXgiDbcaXQJ1XFCL/gC+PT3vlmzwH35SmhmLiREG
	HSXFXQCbsIWXbLafbtx0uJLP1U9HYpqANoztt72jURqniaE2JvHGBKIvXUFe18jDI5BsFn
	MzWhxSg3/ZtJriDJcR3DBp1ENzvmZHA=
X-UUID: ad37f3be60b011f1aa26b74ffac11d73-20260605
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d34d469a-b484-462c-80f9-b86681936b6b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:d34d469a-b484-462c-80f9-b86681936b6b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:5923cc7bdcd84bba77df77d5a2ef169b,BulkI
	D:260605141901UOKBUKVR,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|136|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,UR
	L:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ad37f3be60b011f1aa26b74ffac11d73-20260605
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2054823437; Fri, 05 Jun 2026 15:32:16 +0800
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
Subject: Re: [PATCH v6 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Fri,  5 Jun 2026 15:32:19 +0800
Message-Id: <20260605073219.55795-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aiJqRNerYkMIo8kV@kernel.org>
References: <aiJqRNerYkMIo8kV@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC46E1A0006
X-Stat-Signature: nf5ocq7pjcf9yfp65ojgazzdxpdsz6fu
X-Rspam-User: 
X-HE-Tag: 1780644743-401461
X-HE-Meta: U2FsdGVkX1/ZxDNJc2ISv5p270GtgJeys1Bc+1v5BFAJBxIc5NdTkvqi08yopKNTSLJ7hZRKyMnpxLgg8ULMKh7dKMBAOT8u0zO3cgKG9BBhS55+v9dinvvNZkI1DMxNVASug3gdtLCJqMFhwDnydW97mgU62ZwkmiXRlNNU36pPurudsNuVfEt0luRGZcmlenpWzY3Gl8/7abJvDT1jWtbdueGrRQmJRiMpayRODeZj9Fs2l3n1uVtxk62xM5P/7SfGg6LM26Yl8PwnOu6LEwFqVZuatkvCOx1GjPAbaIbfvsWFNxHBfSDo8sGm348pRmlDhy+HBBtFdnbHZNjTiL7Iuz7L5kcUeg1Ssxzi2o0UlzJsqco2lypLGQT/Zw0joV6v3QezbLYFOu5JzhxhaVWsP1JgTlbeI+0D7rIcaNOk0eJM5qlmpz+UOBTJFha5HtUnoZcu8oIuJQkwNHhrbsJg3GFq2HvAcSk/iatL25rQ7hPOGlGfPiQFJN/cA/vJmtH2el6umB3YnKTSXqrqF1+X6AAijtwaeEdM38A/D5cHa0ol7OcA8k00H0+rGIy5RkYR1pMhsIhyRYkrNH/nYZ+UR5/enysI3K+qomuxhtofJyTcmpA5LzVJQbQiQCgPZVRJaaTOuqCtyi3VJvbSsr+JBWzs4XUafoMSe5Nd0mUm+0VpGzSPhRv+IO3AUar12Iv8QYvYxXwh25yJ95cEnHSyQSzEPauPFKnM+FNufqa+yucSOphoHCjwka8vRI0xL2oGRyyLCKC0itGGRx6GC+qqQK4RlVsIqzx+7WqZogCjYWNzBQPILc6RRxToHx0bN9b/+qVqabxJz0figwf8yeuzMHiPWYeulvrNMR0sUSCUjaFuQTiU9USG/LB6K7ohjFsmsy3nEC3HetXWB4W1ng7WueEXXhJNnQAffmkcqKDbp/LD3whp4Yq3YQ4o4ui3MEQVs+oh3d0bJVgtGzV
 URlu16UN
 g5i0A
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
> 
> We are too close to the merge window and this is not an urgent fix.
> Please wait until -rc1 and then rebase and resend you patches.

Got it. Will rebase and resend after -rc1. Thanks.

Best regards,
Hongfu

