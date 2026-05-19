Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34ECECD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639E86B0005; Tue, 19 May 2026 05:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA716B0088; Tue, 19 May 2026 05:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500496B008C; Tue, 19 May 2026 05:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3356B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:16:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDEEA8B8AA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:16:33 +0000 (UTC)
X-FDA: 84783613866.03.AFB75FD
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F07614000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:16:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779182191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dse3HKRF1AZ11x6uVdUDv1Pzn1wFvOg4dBKPJW52bS4=;
	b=pqhA4TtUTyPyHEcdR5RdbZS6MxBAbDR5zgBLlCUNNfBQJx6eldv1/RdfAWJPf70iqywLTK
	FqdFQ2Xrqeo6UgCucd58UZbSHN1aPNkRVmDn0li3lqOg3oen+Ihch29HtRCO66ez1/+sz2
	OO+jwy4UuGQw07Hnfap89eAFPG2PWVg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779182191; a=rsa-sha256;
	cv=none;
	b=1UXoaNPVAQ6PHGKH1KA9mEh7PWfhgi0wkGVKGNeCZftUeebZgV7w9EGQ/6yTOq7XAibnLs
	YBXiG6Rbw2oipVu93HEzW0ChDeXsln3DTr64G8jBV3aE3bjUu7Z+OcBcVxInH9xoshDv71
	W5ZAM/fbKRpFMc2AwADXD8McRbuYxi8=
X-UUID: 657c10b4536311f1aa26b74ffac11d73-20260519
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4252f72c-b1ac-4e28-b87e-78c2d2341d81,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:4252f72c-b1ac-4e28-b87e-78c2d2341d81,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:4dc14c1a2be4675df48136712318458a,BulkI
	D:2605181845419VVZWHTH,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,F
	ile:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 657c10b4536311f1aa26b74ffac11d73-20260519
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1493652913; Tue, 19 May 2026 17:16:19 +0800
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
Subject: Re: [PATCH] selftests/mm: add missing mmap() return checks in pkey tests
Date: Tue, 19 May 2026 17:16:26 +0800
Message-Id: <20260519091626.371028-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <agrrp5fRWWuMSoYB@lucifer>
References: <agrrp5fRWWuMSoYB@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qygz6fhuoddby1ozmc1tphcs1568ugrn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1F07614000D
X-Rspam-User: 
X-HE-Tag: 1779182188-268982
X-HE-Meta: U2FsdGVkX184dXRojRW75i4eDViYa2/9NcA6Qv+xcf+tWNt9nUgiaOUkng+iTbl4w/KAysyPbr3uXafv0+X9+0+2d0CgPEgjMCLIu+FeSUYhJi2QgzJ5T5IrJiAFktmkl2LYCqHslfJAHPz55aCKDV8RsAvQ04pxUUPHAsQvCT+S6850StS7iaG75NQFIWKQTWDVmUEuzwuCKO9B8UfMgLSQr3L5RWV6lvcsTgFmmb+H+HxwgcghSbjR+PXU1FWa1QmiqFtzJ47aCKoQD0VKfnlOkVvwRQGg1don6ogWW1GnKkhbaT7crNsFOphhU3pHPyDyPm5xINvlKjRixhVLDRoXfQfo95H7W87S4D2kWGLGfkuuxISQT6jzvL9dCjH/GwndltUVCN/pxCVPeEoo7MROTKGgnbrywvyDt9JRHnp5Q7KhPlHUIjBdoAmtEFQo734ZJb3Sgl4kF674p457O4XXUazJCu4WsEBmREQOBhJLT0gjWU2toRYsYJuSSYoW1jvRHFOiDMKCBCGptP/hoGpAvGk8blTKVdyw9PPUrz+KIJFnQ4sPTlqCl+14oyMqZ7bK6fmphTYd15GiXjTzhthly/qGGK3HJui7S8AFbbWJCgEdPjS2vsrxzy9ApFrQFRGi9uZdXxzuVUYK4Hjr4Hj7Z8SgLV4CZG4FOo2bjsgn+mj1KWBVM1kgaorwd9QEb/ArKip3wk6iGrw8v2X7EOYhZYBn09cbjK6ewKxmrQAaP45UNPh9XIB9WcVTr3dnoNljSyOD/EvUFjin/6ZoacLqdVxd7gvCdoq/EgJe0hWxsgqLoalS774mCr0cKT9lxQgdVZxViEjhZ51MhHIVQnUVrNpcAdfpDoAA3LDY0F9tuYiiOJ3f36mDeto6wvflDr31+kl3pDrFuDCnEFjBGkZMJ9ZAsal2AT2IkD0situj1CslSMdWat7y8oBoW3C981VQ157d23JQUpdbcCJ
 Paw5PcaO
 T7NEMu45woPcbQs+QEH4BUCEQMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo, 
Thanks for the review comments.

> Hmm you're sending this separete from the other MAP_FAILED checks, and not
> referencing that in any way? (original patch at [0]).
> 
> Please just send this as a 2 patch series _with a cover letter_ and both patches
> in-reply-to the cover letter.
> 
> Also make sure to propagate tags correctly.
> 
> [0]:https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/

The first patch has already been merged into the mm-new branch:
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=ffe64def0071989cff47b5525d38f5e558c637c3

For this reason, I split this one out separately to avoid confusion.

> On Mon, May 18, 2026 at 04:21:20PM +0800, Hongfu Li wrote:
> > Several mmap() calls lack error checks and would crash on failure.
> > Add the missing checks. Also replace bare (void *)-1 with the
> 
> Well you're assert()'ing so you're causing a crash on failure anyway?
> 
> I'd just say that you are adding missing checks against the mmap() return value,
> as well as improving readability and consistency by replacing (void *)-1 with
> MAP_FAILED in instances where that was used rather than MAP_FAILED.

Thanks for pointing this out, I will correct it in v2.

> > diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > index 302fef54049c..4637809192f9 100644
> > --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
> >  	/* Set up alternate signal stack that will use the default MPK */
> >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > +	assert(sigstack.ss_sp != MAP_FAILED);
> 
> Why not pkey_assert()?
> 
> >  	sigstack.ss_flags = 0;
> >  	sigstack.ss_size = STACK_SIZE;
> >
> > @@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
> >  	/* Set up alternate signal stack that will use the default MPK */
> >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > +	assert(sigstack.ss_sp != MAP_FAILED);
> 
> Why not pkey_assert()?

protection_keys.c executes numerous tests in loops across multiple iterations, 
so the test_nr and iteration_nr printed by pkey_assert help easily locate the 
exact failed test case and iteration.
In contrast, pkey_sighandler_tests.c consists of only a few standalone test 
functions invoked once each, so plain assert providing file and line information
should suffice to locate failures.

> > @@ -1775,7 +1776,7 @@ int main(void)
> >  		printf("running PKEY tests for unsupported CPU/OS\n");
> >
> >  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > -		assert(ptr != (void *)-1);
> > +		assert(ptr != MAP_FAILED);
> 
> Probably best to convert to pkey_assert() at the same time?

This is a pre-test initialization path that runs before the test
loop, so test_nr and iteration_nr (used in pkey_assert for diagnostic
output) are not yet set up at this point.  
Would using plain assert() here be more appropriate?

Best regards,
Hongfu

