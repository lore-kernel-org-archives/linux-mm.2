Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A13A0C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0796B00D8; Mon, 29 Jun 2026 21:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7DD6B00D9; Mon, 29 Jun 2026 21:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F67D6B00DA; Mon, 29 Jun 2026 21:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE876B00D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:48:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7E9E1C275E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:48:44 +0000 (UTC)
X-FDA: 84934894968.03.E42D293
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8095A40003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:48:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784122;
	b=lNf5E5ICv9PfkXmdooLRc1+CMyqglXXIb/ggYPQjqnYapkkxqfnSZeEbaZnjWqlHeoVFG/
	ssvw9zrcYbcMKqh82UcKCAGfxPHmu+I+K6lat18zxydG2Hm6ln8PhPNuQ1ZVIDPJNkD/QB
	JYK6XPzVVMmDy2xBoOS+cpznGrYhVf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXy6NViOkfdL+ZPC4pJrEiLG+vaYJWrcn3Y/bPQmzDc=;
	b=3ZbgxwPztLnLuNfHZ5nrR1d7Xu1fS8CC6P7/Y82M8BiHShw8ASZrY9cv/n/MbvlVG+NVa7
	eDq6fhvtB1wMSIqG2v96cArmqlFr7pESV2P/I0Dn82DfGM4enIzs4sQuaiRGM5nOXfxipa
	vVFMU1uwaIahTeR8XnP6zZH3aIkPEXM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: cc8d4f7e742511f1aa26b74ffac11d73-20260630
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
X-CID-O-INFO: VERSION:1.3.12,REQID:27841b02-81fa-46ad-b2d1-45888c62a8a8,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:27841b02-81fa-46ad-b2d1-45888c62a8a8,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:73d97e2976b0796ddf58f3bcb3c88721,BulkI
	D:260630074233XC71B67L,BulkQuantity:1,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|136|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0
	,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cc8d4f7e742511f1aa26b74ffac11d73-20260630
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 169727272; Tue, 30 Jun 2026 09:48:31 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	hongfu.li@linux.dev,
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
Subject: Re: [PATCH v7 0/5] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue, 30 Jun 2026 09:47:40 +0800
Message-Id: <20260630014740.3651158-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629164224.ba45dc18cdef2848950631e4@linux-foundation.org>
References: <20260629164224.ba45dc18cdef2848950631e4@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8095A40003
X-Stat-Signature: 7ec5dkn9cybkph6tnxxcseimn6dmp8h5
X-HE-Tag: 1782784121-544289
X-HE-Meta: U2FsdGVkX1+/PvyQ0TJqZ58vXQpq9XeqhDrm/afzXxQY0kyp/LfON5XHsJyglsgUNGfXOdI4rqg6sCU6oIrGBnqGy81C9nhE4BN4+NhCOwl8NI4fuSxVgawgA8IIAjRYgRJgV+zZP3QX5bjv9c/aSNipMb3jtgIEPlbUoGQCLfpN3hVmq1jHr2XEMyZ7jnCbTggUghOVuR4jL6e7JjpEQDEbMF6Kg5YICSnPBy8HJPuR+hCGpvtLisK4FALKpc00GF2Dn6Ih4ei/5EoysKpBxVjX0IYBYeb4GtFJ+wI7oVGH6f7hilKccMV4yxWXZ5FQRDolix7iC3Keu9ar/mi87AT8y5cQAiuo+PKwBu/xlY966W07OvgtpQlhcL/iENbPZUbC9pVgyngnoVFMJADZaP+axs2oqorpbTh4hsH0aMKuF0ljVtNjvyuc4RIRbYWTjEVm8xXOZt1m31Ia22duGsImqcriT+CA/yn6YUILQhuV5Txa/JU+brjZBMbkzO7+cnmt6tYQuUcpF7imoTLBg4V1cgN7g0k+Olz2pJXxShYo1SZaXWSyPv2j0D/UgUSQFF5binaVyYYT3WVkLcgpvHEyR0EK45GO9jy727uX2LphdqPO1xH3rkXrdXmOxUpXjwaOjXJaiDgSa1cr/EeXPva4gVeIcQKmcZPRw3BnvRtDUC/yBMgu35ScjUGcr2Qw+DVa/6Y30uS7RXBV+TBuUgVMIgrK17X5CsdkaZbVZZoCjhzjulq0qQLoK4I+8/6Qc4xxUc1Nv/Kdm+s8F2RoPLjD7Q/39mr6i8ADDjTLIsAgK9H1OwXT4vwFbKPwsUVDhi6P0RVp5XHX9x233N98CAuDl+wwZS5OmLtczXavHhd1UGnQkpCJvaqGoU2Es4IaxW9PRN3DOHP3cH2nVOFkOQoayQ8j34s/ycIETMKEsRS8oZ8lYDvKhE/53sxipoKqt4hKd2pIyeV2g8H/RXZ
 yUM0qJw0
 lTw4X
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
> Thanks.
> 
> >
> > ...
> > 
> >  tools/testing/selftests/mm/pkey-helpers.h     |  4 +-
> >  tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
> >  .../selftests/mm/pkey_sighandler_tests.c      | 81 ++++++++--------
> >  tools/testing/selftests/mm/pkey_util.c        | 86 +++++++++++++++++
> >  tools/testing/selftests/mm/protection_keys.c  | 95 ++-----------------
> >  5 files changed, 141 insertions(+), 127 deletions(-)
> 
> Unfortunately MAINTAINERS and get_maintainer are often useless in
> selftests.  In this case, I expect the people who wrote and work on the
> pkey tests don't know that this patchset exists!
> 
> Poking around with git-blame or git-log
> tools/testing/selftests/mm/pkey* will show who should be cc'ed.
> 
> So can I ask that you figure that out and send out a v8?

Thank you for the reminder and for taking the time to review.

I will use git blame and git log on tools/testing/selftests/mm/pkey* to
identify the relevant developers and CC them in v8.

Best regards,
Hongfu


