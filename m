Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81838C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 07:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40F4B6B00D0; Mon,  6 Jul 2026 03:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0AF6B00D2; Mon,  6 Jul 2026 03:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF3C6B00E6; Mon,  6 Jul 2026 03:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E55926B00D0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:33:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5635D8D25E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:33:26 +0000 (UTC)
X-FDA: 84957536412.28.01ED04B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6D576A0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:33:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783323203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WQePi4wLyPUD0fjZ64FT2cofbuvtEoaT9obmuAOMw38=;
	b=0iAU+GrfCC/zNzXOwI7UBW7QsKqcsrB0AOHDUO4e/Qq9t07pYKyGi2QxK2tAmxfy5gl17P
	JL5x8L5W0P8+9x93FvKPB1YdBOjjiBmaR+XK6eZ3CpBVTCxGn2Esk4B7yWpxPZ9K8kvdwi
	L9X0wNIhpuhG+7IIqrzxKiTV/QI+3SI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783323203;
	b=5YjUPgBbBwfy+RLPC7oVtvDX/cxcJCK9CWu4K5dE2NN+xnCu9ct8S/Ee67G/HzFoDtSqAf
	SpQha2uQDncs9ZAkl3/snaOeQ9L/wHTIVql5wF2KxUELU8PIATnTeOLrD5lp83AZXEfqN+
	h16a6XzPCWv8aeOura9CG+UA3ULHFi0=
X-UUID: f116c1c2790c11f1aa26b74ffac11d73-20260706
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
X-CID-O-INFO: VERSION:1.3.12,REQID:13ffb0a9-9efd-496b-8cb1-518579bd22a4,IP:20,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.12,REQID:13ffb0a9-9efd-496b-8cb1-518579bd22a4,IP:20,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:e7bac3a,CLOUDID:79b2e9dab16b6ff39e1d3deb1ceed7b9,BulkI
	D:260706044829SL9NPCNX,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:1
	1|94|82|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f116c1c2790c11f1aa26b74ffac11d73-20260706
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2134534148; Mon, 06 Jul 2026 15:33:11 +0800
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
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	usama.anjum@collabora.com,
	vbabka@kernel.org,
	yury.khrustalev@arm.com,
	zwisler@google.com
Subject: Re: [PATCH v9 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Mon,  6 Jul 2026 15:32:56 +0800
Message-Id: <20260706073256.3547055-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260705134819.871dbf41d2b06681f0facf12@linux-foundation.org>
References: <20260705134819.871dbf41d2b06681f0facf12@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D576A0005
X-Stat-Signature: f185gzb35x7zmsma6bhxbop3mozfewkc
X-HE-Tag: 1783323202-411659
X-HE-Meta: U2FsdGVkX18srBImiA0FRrhZ1WxyLqQDzv/IFKw94Xp/fMyt+Abt9KO50WEPbEuYGy90X5D4Q8DxZrWf3sM6IfqMksSQvSZG0i60pQHhotGfpztWa6p+uVNLmn/s/+8Vj0AeL/hdfz7GtQTsgxVoiSk71dTclkY7XxtiWLx+hvDPwAV+piRmZ2/bLOrzrTCfajxcCN5U7yuF5laiQDwEDVk7L0eSMZSo0555Llu4Zmt19h6YAgR5tJ5boYU0mGLh4wffqZ9hO7RkJfzd9VY/wPl3CKZNBVQ41We6HIpVa84glht3DFoCrDgpmcdLg7snlXsXwc1qsxlN3s+XwpyVO2YT6q1i8hkpCzdzKubjXk3vReSFVhA7XhFz878Twm4UrN3mytrTBwfODwEIJsvehgd/ebopT4Y6drFPeq3lPCrp3UCbeeNhfVtjsr0+Avi140jb4LaO5DHZ8ZSYZIIsUNn2qx4vXqPk0d8673IODD7Hpno/Wpv9if0ugyY2e1oy4jPNt3cX0lAP3qlG9bosjzUrIHZeOPoy0chuBeFs6a5XS+nXSbomm/5/mdJt88nHeV2m2XctmkCHTeGfoeE2P1qFhEnSLqBOX0OL+ysT6ugsNc5amFOGN3a8V4gHsEABZuvOF53r/ASW3iiFA5lHi3C2tuHPlLfG9AipbUFDa22PMyC6vBzl1qRSxbIaHKS+L0nMl+qPHbuqyLO7r1+zBEuIBp6XogilElREPPcB8y6ywdphqhc42S7YHUKgredJQMNneK2efWLjdXW56uW1kRdSEidGXTo6z2aKteiUVKUOozk19S7u8K6zrL+Gpz5saBrHlMAOU8Ca6cjTVXZbOsIlQGbxtmQmFy8e670bdCZbn3h0buUh1YBWL2Km4HzDhX58Mq8s2cY4CMb1MitmdQOWrAkGz3oT302P6iNwJpk28rVl0XvwXy+UK0Avv1svGymKh3+7G0Of6I6XGiS
 PHYdAaLC
 /3zy10nVqGELVNtfhl/rqHvs8Q/2/FPA0oVCxRzOT113JJYKRSD/sM3bt8i6mDdVPgmdA
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
> Updated, thanks.
> 
> AI review might have found a pre-existing thing:
> 	https://sashiko.dev/#/patchset/20260702062332.911786-1-lihongfu@kylinos.cn

Thanks for the review and the Sashiko link.
I will fix the pre-existing issue pointed out by AI review in the next revision.

Best regards,
Hongfu


