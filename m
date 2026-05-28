Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD31CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E760E6B0088; Thu, 28 May 2026 04:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26E06B008A; Thu, 28 May 2026 04:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CDF6B008C; Thu, 28 May 2026 04:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4CE06B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:29:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F4671C0651
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:29:54 +0000 (UTC)
X-FDA: 84816155508.07.0D184AB
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA0131C000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:29:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQ0hPAwLiHEquoPIEbOhIE0ywkCqAsflPdtiIZLQlIg=;
	b=NCXEMv98Newg8ma4+fYjnYmc1M3OKobX0QhGpm2Et3TJomffs+iarp/K0cEsItLblqzXZU
	kC3kdAilVcAvQjiHh203JvrWbPqfqGl5WbzxJPL3PLyf2g/MvdZD2HrmE2/wpGUbJe7TjY
	u7nWnNk3zCTar/jbtl2y9EQoK1gvQOc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956992; a=rsa-sha256;
	cv=none;
	b=bOhDpAa15wb79s7D4Gq73dgco09Plurqc4l9eK1X0O0EGHB55RsQIX52Lw2dpc5d2XGwDC
	fcUF73yIeE0qUHD4is2FrFokDVv1tlypIG9EOHQTydNVnlVJ13iFSuwqJs9wWMiD7Ofc0z
	Xnn41PDn7kBWpL2AEKhgpxY7ST+32Og=
X-UUID: 5f56d2d85a6f11f1aa26b74ffac11d73-20260528
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
X-CID-O-INFO: VERSION:1.3.12,REQID:e6b2ad58-eef1-4f5f-9207-726362c184e8,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:e6b2ad58-eef1-4f5f-9207-726362c184e8,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:0b48ced4fbb6c8167dbe113e56e41c41,BulkI
	D:260526040209ZS2AJ5N5,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|865|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-
	2,URL:94|82|11|99|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5f56d2d85a6f11f1aa26b74ffac11d73-20260528
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 232205519; Thu, 28 May 2026 16:29:41 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Thu, 28 May 2026 16:29:50 +0800
Message-Id: <20260528082950.2065901-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ahcatXuo1pI9Z59G@lucifer>
References: <ahcatXuo1pI9Z59G@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3p5c7wnzzehd7xfpdcyeb1wpsww6b7rm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA0131C000A
X-HE-Tag: 1779956990-619219
X-HE-Meta: U2FsdGVkX1+5I7QmSq2v82PJl9wwCfTKSYGf+ixZok7XM8+fp7XslnyNc4Vio3Ukgi/HRs+Vb8l2UDysGG6KjPDSP7y3sJRY+C7zGX3KUn16EZtJe3pHR+RNfkieh26E0N70WrcTh+vIJ1RbeBbCQIGh6pMTmteVq5hJal+FVXhHJ4V2RzF6ugpxkmsQ6qLZxMqJjk+pvZCvet9k6O/UEURCZSueXYlB/1M6WQeLHDZUvrqlGJX7yBONCcFF6J3qvLz0H0hkzeowYOewk4EQX++vVQd4/B0ceqwOxlT/wdLyKlbroczLy5OQD5yhSYFY3+9JX2H89UxEGwNwElVB1kgb57QP/5wcVv2DnZ3/PJ+Y5grkIDrMU5oc38NL/63qQvc6yN2h7/unHOs29Z9562vfwSxpa9eaKmGJQFoz377R1dLbmaA3f6S65Ynv7t1mfFwnax/JQa4M5E91kznh0S09ZDWi08zDHzUMWcZFa/txvfUPn9Y2VB/TG6xgJsXwH1DpfW3oR/cMeumg1FKbrW1j8Y0xytRpzaAXjzWbEGeHly+sG3nd1BrVOq86MmptIN4oKbkhqb02aA+u5vA4/a0o6eui3Ql2PuDd304BILkse0mjZ+4Wdwmf0YGK8Uycpl8m4fm6xq/Gb0Sgtm6VGEAmTFyGOOc2OhLz4dwmYgAAoAt5UCTf45Z+hNPErQk5iCSEkhdAsHZoZwc5l9Z0QVx0oSaEQ233cZCh70PZOG10EQ6K8Q9XVzAEbC1Ykm8pRqgBv+mDtAXCuzour74n6/417Kp4rMCsISghM79/NNZBRDUlJlB1HS8BhFJAdhmZARkSA3DJ0W0OLiBJDegYluP6UFPargfefu4Z5mPKwgazJH469PVwgC8rvHkfsYa/lSuKP/SFdl50Y5lrHKxQ6/fKYoYxzi3Ji0YdK3iUrRrCyqBTbN2wepQKBQF2t7GZMM/znMOZgkFlL97ZLGA
 Ze4sX4qa
 40b862uRdpY9dDc/T/pulztAJCB41w8y8oFL77+bwc99+BV6ropE7pG9LAYA3EY2FZ6KlUWPBX7yxN6vDPxqyRSGARg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > This series is version 2 of the previous patch [0].  In v2, the changes are
> > > > split into two patches for easier review.
> > > > [0] https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
> > > >
> > > > The main changes in this series are to refactor shared tracing and assertion
> > > > helpers into a common file, unify both pkey selftests on pkey_assert() and
> > > > per-test tracing for consistent diagnostics, and add missing mmap() return
> > > > checks with MAP_FAILED used throughout for readability and consistency.
> > >
> > > Thanks.  AI review seems to have found a legitimate problem:
> > > 	https://sashiko.dev/#/patchset/20260525073026.27594-1-lihongfu@kylinos.cn
> >
> > Thanks. I'll go through the problem reported by the AI review and make
> > corresponding fixes in v2.
> 
> You mean v3? :P

Oh sorry, my mistake. It should be v3, and I've already sent it out.
Here is the link:
https://lore.kernel.org/all/20260527013825.1134225-1-lihongfu@kylinos.cn/

Best regards,
Hongfu

