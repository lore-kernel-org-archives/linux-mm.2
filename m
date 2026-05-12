Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166F9CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4373B6B0088; Mon, 11 May 2026 23:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1A06B008A; Mon, 11 May 2026 23:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2893A6B008C; Mon, 11 May 2026 23:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13BFC6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:05:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A90640351
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:05:54 +0000 (UTC)
X-FDA: 84757278228.27.86272AD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F92040007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:05:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778555152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqitgNh9ydeUseJyQNHk4+Tc4CttECDVj6VAjgBBv1w=;
	b=bR9ryR2zkdIJi3c8pNvZzr1uSoTC6X+neBbJq4P14bTuws5I4Bmxg37YgfryDMb9oDcANp
	8ATNYhhEOalbEtivGjDbddXg5+rG/dS7ZaGFkEOnC9v+RR0s0fNPzL17pLKAE6AbmFmXuK
	5q3nb7gZGRjLj32o2O+tqnKRjzKFjs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778555152; a=rsa-sha256;
	cv=none;
	b=wIdK9dJ4IEA4k7q6zLRQBH+alKYxttqkNKD+i3lHUNayldugcPQ3D3LIMgnwHjHnnN3G27
	JI8k8+mEx7uexSQ70Cl12eHa/vs416aE5BDSIFBUlBOD8Cd/KaQA0m0pnBolUnSEjy5/nw
	L83tU9OfseBNIvVch+z9P8vVib3Sufw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 77da728c4daf11f1aa26b74ffac11d73-20260512
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:36e1e69e-1b14-460a-9a29-b149158999a8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:36e1e69e-1b14-460a-9a29-b149158999a8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:9664b41425725c4b0711df2f1f0134f6,BulkI
	D:260511104727UACKCMR1,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77da728c4daf11f1aa26b74ffac11d73-20260512
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1377102052; Tue, 12 May 2026 11:05:45 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: vishal.moola@gmail.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	shuah@kernel.org,
	tj@kernel.org
Subject: Re: [PATCH] selftests/cgroup: check malloc return value in alloc_anon functions
Date: Tue, 12 May 2026 11:06:04 +0800
Message-Id: <20260512030604.2392932-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <agHEjG7_fHMAnQrw@fedora>
References: <agHEjG7_fHMAnQrw@fedora>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F92040007
X-Stat-Signature: hksc3f4cjyjwnzjcz1qnh35at33f8npy
X-Rspam-User: 
X-HE-Tag: 1778555151-808746
X-HE-Meta: U2FsdGVkX1+T3gM87BtK2+L1kYCqVE2fsr+FpSch20umCXS6WhrO4vR2OEXOOVbjvWDmK+WDexBT+S3SrBzIJsgp7fteLqaxivOp6XpFq6VMfxya2jaan8fghFbQCeOb3RgUT0KuQP7SCCfYiwPuqFkWxo8H2ur5uHlLp8+jTspGR4t4STOE+nJ3vYK34+VfIVYOFieWNFBjAaBuCHo/xd0Vz+9V3LHtptKWrPCEp/sT3XvKRXhI0e9gEOqPM+BN5yzjCQT4xH/C8YPaMUtjolXR6Ue4DBlnmn8wvWwmstocxd7gegllNFmjbOErOUAo4R51JX7pJs3YrH0kGwSL0i5coQY3pt6L7enjD5gjSMuCT22RYgUyYVH7illNnaytch0ORDWkgPN0kOor3D+u5yplsHv4CSELjh06dTCh88PomNURbHrz5YXyDc28RRcpJoj5sI00aTFMZ1WmdLY5ScIHEPrX0TvtEj0sO3i1vRH3DkKSBd4ZCdpP58GN9Te/pa1qLEESWrga7KCDShmTY+o3cQL9xl1cWiS1aKmfLKuiBz3f+vl9lV86xyvK+3Khf0Bdi9suO7HZs5cOBBoeNv6DL2mN6rLYfC88/cT+A6OUmkmslHO7vV+DlCFyFP4T3wEN+1Uuap/VpuDqmxw4jebZRFwI/OyvbZ8PW/1f9EZ9LHZTaBlCA3gR5ayVTFmweq2M/IsNI2dJqU/HxH8zhCw2Ls78bE+Ve++58WsxtULCfWdO/hpqKin9yg8+eASDJLOvXKFnxF3y8B6lwW/ELn/76Eo4OLkJvWrfcwxTEqdckYk7QJmHqdOWVYZN/Y/sMUUV/2xiM0nTbSSoZPqzkoLbLp69KIupbjVly1I0/Ckws/z4RAs3a09uBq3FyF/sPruT1M0ZNU6BwRpAJUq+2NCXnDonZoKvysiovVVSV1BLrDdvGs/l7DYWNXug5fmS369opZNvjAT1LxHoyZt
 dE1GZLm7
 5ssAS/q/nPzQf704f1iA+rnAhsbyxzLChLfdMT0HljQxhUc6IlflCKh2K8kPiq+ODL8HMs+Bl04haegFyP91IuRG/qtv/3eEwHyA7IB7KZ3WKVgMLd6NoGfgtYSGVtDe1f/Uoaj6jYIVZhpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> > index b43da9bc20c4..8ef9c99a82eb 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -61,6 +61,11 @@ int alloc_anon(const char *cgroup, void *arg)
> >  	char *buf, *ptr;
> >  
> >  	buf = malloc(size);
> > +	if (buf == NULL) {
> > +		fprintf(stderr, "malloc() failed\n");
> > +		return -1;
> > +	}
> > +
> >  	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
> >  		*ptr = 0;
> 
> Every malloc() call in this file has this same pattern. Maybe we'd be
> better off making it a helper function?
> 
> Either way:
> Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

Thanks for your review and valuable suggestion.
I agree with you, will refactor all malloc() checks into a common helper
function, and send out a v2 patch soon.

Best regards,
Hongfu Li

