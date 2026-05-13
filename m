Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C338CD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413346B0005; Wed, 13 May 2026 07:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4406B008A; Wed, 13 May 2026 07:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C3C6B008C; Wed, 13 May 2026 07:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 151C86B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:16:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C00971C0712
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:16:15 +0000 (UTC)
X-FDA: 84762142710.18.FB57AC0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0EC8E1C0010
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:16:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778670973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIWAHgdiQBOL8l3SRCedZ4681V6W3ZrX1aD8W8g/d+U=;
	b=X7K+V37MdbGc9Ty1CJVowybVLwe6oh24xSdi85hr73JcmPlUp4IA294z12LaqajB+NIO9K
	3i3Mi+rBeSSIBbNLj6KfJkJXzorDoBsHNYSRfueXOdelwA/A8fmJEXiwJXlQg7apSBBQNV
	QXVUotLXI0GfR4UhaPSJlJQw+/9fn00=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778670973; a=rsa-sha256;
	cv=none;
	b=7/+foHROl5LW3V/QUYCZjddVzAC5COyeeDuvLMpnTTz8hbzucDooGQnFfX9O0BnMeJMZ10
	oihboYCC5iEpyUHfd4QGvxmqH3VD+N2QH3K8LRmE9OrfRzJoXCj6EQZ4UyRmkShKA8hTVh
	WNuzPIEPdIY7RQC2wuGxM+YEXGR+RT8=
X-UUID: 21e5a3104ebd11f1aa26b74ffac11d73-20260513
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
X-CID-O-INFO: VERSION:1.3.12,REQID:77ded235-1e1c-407b-a79e-b5cc4d0b8cd5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:77ded235-1e1c-407b-a79e-b5cc4d0b8cd5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8fbb76106d7c896d451a9b9b4f497a04,BulkI
	D:260513180600PLGD15QJ,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 21e5a3104ebd11f1aa26b74ffac11d73-20260513
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 194317941; Wed, 13 May 2026 19:16:04 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	dev.jain@arm.com,
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
Subject: Re: [PATCH v2] selftests/mm: Fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 19:15:22 +0800
Message-Id: <20260513111522.824074-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9e302879-d218-4257-9e2b-e468564b89ea@kernel.org>
References: <9e302879-d218-4257-9e2b-e468564b89ea@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EC8E1C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: m6jyz4iskf8js75ud9wyfnpe6fy8eykw
X-HE-Tag: 1778670971-844876
X-HE-Meta: U2FsdGVkX1+Mz30dxaxl0AwNC4cWQEi2GdYCCoY6SDtAiZgrBcDd0w9vvORZGgvZ7Fu8PkleV3mQ0s3CNI9nXI/jrJYdr5hUAovmXZTndSTn+MaDsElDUF2iRW+2+yrEear8zLF69juSuWNWpdXDa2YFUcxm+4pUU7hUjdXK+lR6yKJmT7wCzGxa2cAdYzWbzRMMSddz2bwR036xwgnsdp8EMmnWQQMETTi9PoasDvdxjhtF+7tbe0O1NgSBTKuiiGXnic56Tpiaddu9ivpnR4xmggHNRhiWEPSnbVNG3q0xdh2lJay8BKljcYN/zsmG3TkLxn0t7IQ9h6E8wxlEUlIsDZGbzYeuSJwjBgpf18bZpKzi2sYvt8emY0rXg7wnbqvQw0N6pbh6uvVmS89DUgMhDoV6ZV8DZppxZspeQl7UCuRMuYBuNCgaUBH43A9v1y6Ss5CZXtv0modmgbo44O3cTWsIG3pkiiXbbm98wVqPndEI+4w/SFL6wHewcYJfMyY7c1bakVFlTQh6Y+TnYP3K/T8awEVNtgvXxLzIafv0cJVyJ99Tdogcp+KdM5hxgD7nKfmaospkH0dXZaQ5RErEkyi4KhMPM1yexBTwmA5dOR77Sjzw5tHtlPd6Lt1NftU22fLzz9XqT/EuaquYDfqfC6rSFxhb9Xmb2XU9g4XZbhny9zNOgZfckpJjUWTyXwhYrfq1lxl2TjjMMAIMGwjkGVtNN0VmiVqwEtLp/7jUv/UsHTCL6DFFEiGQy0SEHI51Sc2Zqfa/Hu4N+X8Lb0Ru0m2SyGMkcCMWwS0eyaxXoRmVwUgpabSOHkhv2BE54+ZS1oNWEUum4cRvqlEymKH46fmoP4o3ma0RtP5PO0nKuLnM6KthfXslNYHgKT5eaRljhz2tGbWzsywdbrzm2Ss2jsyk1EHgvid70EHGYLQAamqs3AqCKZAQsRmQSSuUbs2D/qTN2AMtEt8DlKK
 Y5F8D0VJ
 XZRBrDW5wRYGUuyPqCL6x7UUfb2qmiv3t+kxW0m3ZWsa6n74HQvxIFkQ8ZXVSo0dBBzmFwIJNI5dJOH0HOzVXvF+r4d/v9hdPWSlss5pZzW6NtcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,
Thanks for your review.

> > mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> > not NULL.  Several selftests incorrectly check the return value of
> > mmap() using !ptr or ptr == NULL, which would erroneously treat
> > MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> > non-NULL.  This can lead to segfaults when mmap() actually fails
> > under memory pressure.
> 
> Well, your patch also adds more checks where we previously didn't have any checks?

Yes, I added a few checks for the mmap return value, as they were not
handled previously. Perhaps I should also adjust the commit message to
match this change.

> > 
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> > v2:
> > - Add missing mmap() return value checks in pkey_sighandler_tests.c
> >   and protection_keys.c
> > ---
> 
> [...]
> 
> > diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> > index 2085982dba69..580bf1668c71 100644
> > --- a/tools/testing/selftests/mm/protection_keys.c
> > +++ b/tools/testing/selftests/mm/protection_keys.c
> > @@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
> >  	 * doing the XSAVE size enumeration dance.
> >  	 */
> >  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > +	pkey_assert(buf != (void *)-1);
> 
> What's the reason for not using MAP_FAILED?

I tried to keep consistency with the existing mmap handling pattern in protection_keys.c.
That said, using MAP_FAILED would indeed be more appropriate.
I'll adjust this and send out a v3 shortly.

Best regards,
Hongfu

