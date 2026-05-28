Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C624CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B6E6B0088; Thu, 28 May 2026 04:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC336B0096; Thu, 28 May 2026 04:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9586B0098; Thu, 28 May 2026 04:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 815366B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:57:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DB0F161BDC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:57:29 +0000 (UTC)
X-FDA: 84816225018.28.29233FF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51C27140002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:57:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HWD3uBI7ncQJbkwTcVRf7FlW6IOT5jnCxD6R7TO10Y4=;
	b=Pk0WodMna19eqsmIfusZRnDL6s8Ulu1StoOmKBhEgOLJV2/AaAu8mOoh5421+I2wfzFePT
	GlGnek1fiR/CIPEfsGVdh3ZjRXtc/FFNOkQxPomTsmV+/FI/7/zrYWy6aBKPRPAabIjEGE
	jqCfdMI5dXu9qaTCHi+N7pkR4qUbqL8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958647; a=rsa-sha256;
	cv=none;
	b=wkkVPgyY30HKFtQndONQ1z1ktlF44LKhookl/W/frEATSiBM48LeKUaZ2nwwK6iQMGh0et
	Du/N9FRKUnSJcfBAyDDHih6pi2wzDycpTqiOHnU+v2sXKPrgkR9hZQwv072YTm7p6gSXCX
	przJdwWXZPxEn1E70CzFA9hKzSgfDgQ=
X-UUID: 3bdfc95a5a7311f1aa26b74ffac11d73-20260528
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
X-CID-O-INFO: VERSION:1.3.12,REQID:df20b873-9c04-479a-a4a1-04fc1ba33759,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:df20b873-9c04-479a-a4a1-04fc1ba33759,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:57a1a66449976c9d5c924b021e3adc41,BulkI
	D:260527193702VLU0MBA7,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|865|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-
	2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3bdfc95a5a7311f1aa26b74ffac11d73-20260528
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 742640666; Thu, 28 May 2026 16:57:19 +0800
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
Subject: Re: [PATCH v3 2/2] selftests/mm: add missing mmap() return checks in pkey tests
Date: Thu, 28 May 2026 16:57:46 +0800
Message-Id: <20260528085746.2076957-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ahbXTqLLLcYmeTp2@kernel.org>
References: <ahbXTqLLLcYmeTp2@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdiodnmoioo6qxu67am1bzecoqr17ukz
X-Rspamd-Queue-Id: 51C27140002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779958645-342667
X-HE-Meta: U2FsdGVkX18kvLwGzLGm9GIvgma42B9IxeXjI6nhQmVc0vEAkTcxl+aNI5IUY9KSTKNsGtlNRwPy9gxTmrWNfTcsiYv7Igwby9yHnS9kpnZcvFw2f4oaIFboKDM71FySu2phmlNxS94DrcGS98Xwpioous3LJ5/kYk0HpX9idHVlAVyUMiFhHkiwJVt0iSpE2Qt5iw/iEZFtRWnLQ4ICz1W4gaNwMAzxDF4afRB87+ebuRROOo07SPofRnBxTsc5W6ni/NELncz5QkPCENvD6mJHVCeEORL9tImBUBTLEeVqp3ToVr6kdo/MjxmwSfh6kSRxI6ZqT78/jkzb5kbJvZTbLnf7v4I0rkO51g07kM0adX3/IFClhsH0aM/TFNGqnsuCKZ0mYvYhg/lxVP0Bg8GNUkEWeGqdYTjUBHqRoM4ObiRI7qzxgoeFe5ctQ8EQ2sPCCQCYCi60QkoIkR3hoF1MZqb+MBiBCWcK+cLILLOffvRXYuAztodZ2KQht23cLyAXxta54AyYHLyCbODxFDL5X5t17NbiqaiDJhjhu/kzZuRrmIriG12Lli2LlJHYQSKiuxqns9O1P2eRkc+cQTdwZbZWUe1in7HqYQGac5C5CUYoC/s7OcTaQa9CtdYXJm6EQuQvYDzpJEG6UWmibWGrkGCOoSSWSLWsxvUtsHDQSNzP5fBadvjlFLuceRSzRgqGlh3JmBBaC1x3qUnyLbiVS5xxSqTJ9UJB9hQ2N90COYkQxa6gmI5Sjuhj/CSC+gS1JOnxvJg05hEoBohF+jQEaLCapx1jxzIzMqClsapHwnpXIaLcDQxQFjssEYZeOau6zNSgiRKkVUONEi/vNcQzJtA4lV29ad9pxJRptDeN9F+QVSdZU/H7TnW+V0BIe9S13B9LG0FDbybY7MbiitvDRm9B6mTLlT5gGm+xMrwKDPE3C2IeM+qHwkYuWPTNPYKjEZsuEIb98KsHj2D
 JWQv0Aah
 iOTMr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > @@ -1693,7 +1694,10 @@ int main(void)
> >  		printf("running PKEY tests for unsupported CPU/OS\n");
> >  
> >  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > -		assert(ptr != (void *)-1);
> > +		if (ptr == MAP_FAILED) {
> > +			perror("mmap");
> > +			return EXIT_FAILURE;
> > +		}
> 
> Just stick to pkey_assert() everywhere, it already prints errno and exits.

This is a pre-test initialization path that runs before the test loop,
so test_nr and iteration_nr are not yet set up for pkey_assert().

Should we just use their initial values here directly?
 
> >  		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
> >  		exit(0);
> >  	}
> > @@ -1706,5 +1710,5 @@ int main(void)
> >  		run_tests_once();
> >  
> >  	printf("done (all tests OK)\n");
> > -	return 0;
> > +	return EXIT_SUCCESS;
> 
> Completely unrelated and not needed.
> 
> And you may want to base your work on mm-unstable to get up to date version
> of protection_keys tests.

Sure, I will base my changes on top of the latest mm-unstable branch.

Best regards,
Hongfu

