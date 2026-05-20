Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D575CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A7A6B0005; Wed, 20 May 2026 00:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBBE6B0088; Wed, 20 May 2026 00:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3014A6B008A; Wed, 20 May 2026 00:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201856B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:16:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A725E1A0126
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:16:54 +0000 (UTC)
X-FDA: 84786487548.27.33E2EC4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82B4C180005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:16:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779250611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2UnUIxnE/+j0P+JbQyO5Qsr/1EUJ+OrbLl/H7kfagzY=;
	b=AxkHS9FoPEWHQN1IP15JoEcsSeGsA+Nf/Fx/qsrtiDce9AvZiXoJRP3D/QJsvMb/yhPPye
	NmJR8qyuwMFK3sMrgDAPR8xfWW8WKAtnoaQGFCiw/5Lodgj3x7YunL3WTTHcLeh5gs0wim
	OyEkr1GtEmNc4FPO1TKakA1JM1x6U7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779250611; a=rsa-sha256;
	cv=none;
	b=jrcJIBhuulhe24z94Y5DFRYIuMuomxxmnD+GWrDg0qS4tpzYEegqk1koVctBEg0dKyyHzw
	duFi5FkwM7u9Fn1ihfbzO0KqvcfSdiKxOApS1FVBmh9Ve3l8crjMn0ksbnelrd9aDpRPb6
	biUK90IzacIWYftyunrIlpGdATrLYXI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: b2d68494540211f1aa26b74ffac11d73-20260520
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
X-CID-O-INFO: VERSION:1.3.12,REQID:80552c14-c673-486f-b9f5-1666631c09a2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:80552c14-c673-486f-b9f5-1666631c09a2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:10efe0c6901569e13e43ff5ec646dd9f,BulkI
	D:2605181845419VVZWHTH,BulkQuantity:6,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,F
	ile:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
	DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b2d68494540211f1aa26b74ffac11d73-20260520
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1743845547; Wed, 20 May 2026 12:16:39 +0800
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
Date: Wed, 20 May 2026 12:16:27 +0800
Message-Id: <20260520041627.912766-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <agwvkyXSlZ-Suz7j@lucifer>
References: <agwvkyXSlZ-Suz7j@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 82B4C180005
X-Stat-Signature: xfiq1r5gqnzfqspupyrpush5cja1j8r7
X-Rspam-User: 
X-HE-Tag: 1779250609-988009
X-HE-Meta: U2FsdGVkX1+NSzjqKHr7SCxUhRyj+VERYnHUzea3NmxvGyR/iawjmnP8I1D8Rks+OixKVYui34fHCOi83vyOkXzGAeixA80DYHDWKwwqTEMz3ly+yTmMyB/G4GOKF/qF3/TfO74vrKh7QqWwRhlL59fMy1P1kFlB3hOj7jkafiA+VnCbNWSIYnTU5zI92GXmpmnD7c3vtll2jR33JDivhfJhLO8OkIH02bV6EBX+kWRiDPH1eeh2HSfuy5zgPtY9OqqllqTmkppt5y/dpE56MzQQrvKsqMgmAbM37ZQMBhs7kdA5hGFH6W/FcuXHwa0vggTDa27hNf3khrYMWX6Ds6VBmdYGeHxztVjO6nVRYiGNqpRnFGi4NNsW+mlFC+n2Vh9pU3ndpOmOGnvDohYZ2W6DAav8nBolA4+cBvWMA1l6mw3eIy5oKQKRIRSM7hzrXYZV+wOa2Q1KNK63Opk0iliYAoqNYuO4+pNjTd2lb97PStke9cTzGqV/ei3plhCtPICeHg6SyVo2Hvs9I5eWZQi8n4xlbdQzmh9aTf6c0rFX5K7QoWwu5jzf7MhudLLRNz9oySjb8O0m+VuL7PNmQNZnEf0cTAphBJPtBayqbd8/mDIFkSRq61jkqyQKukqQNTuu39H60zpS4AH4iWZUA3ozQY76dDv5aXGVmuUzm3cGeQRGuR4QAgWUowpfjMww7RbtCs90vrxNw3883+ThWl+EVDB9yQ5gV2dSg8ypfZzB8LdHxGZ13KKuimi+3yPV5cqxrrMNjeiqU7LjnLU0ogkHju78JfhK0KG9SC1UQPFmF2iETaHAn12A/whcPCNOgh0hizUMIKO0T2uScvxSRlQR+nhTzkRjRuDqMJiWCUCLmEQl6t5QqpDiLCbvQ9Zsx5fpu9utyxQf0EQ1LvWGLKJzaKRQs83uBjTOqbWgjlOhyiUBSZufWFSr4TVJx9WCVm/xRZ5wbPqaAVxLJAR
 Yogil1U1
 Nv31QoFlewr4YjilLlgwVX2oVKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,
Thanks for the review comments.

> > > Hmm you're sending this separete from the other MAP_FAILED checks, and not
> > > referencing that in any way? (original patch at [0]).
> > >
> > > Please just send this as a 2 patch series _with a cover letter_ and both patches
> > > in-reply-to the cover letter.
> > >
> > > Also make sure to propagate tags correctly.
> > >
> > > [0]:https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/
> >
> > The first patch has already been merged into the mm-new branch:
> > https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=ffe64def0071989cff47b5525d38f5e558c637c3
> >
> > For this reason, I split this one out separately to avoid confusion.
> 
> Hmm ok so you sent a v2 that was rejected [1], you were given feedback for a
> respin but the v1 has been taken + not updated?... That's really not how the
> process is supposed to work :/
> 
> Bit of a mess, Andrew - maybe best to keep the v1 then, and Hongfu - you can
> respin this as requested?
> 
> [1]: https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/

Sorry for the messy patch arrangement before, I'll respin this patch strictly
following your requirements.

> >
> > > On Mon, May 18, 2026 at 04:21:20PM +0800, Hongfu Li wrote:
> > > > Several mmap() calls lack error checks and would crash on failure.
> > > > Add the missing checks. Also replace bare (void *)-1 with the
> > >
> > > Well you're assert()'ing so you're causing a crash on failure anyway?
> > >
> > > I'd just say that you are adding missing checks against the mmap() return value,
> > > as well as improving readability and consistency by replacing (void *)-1 with
> > > MAP_FAILED in instances where that was used rather than MAP_FAILED.
> >
> > Thanks for pointing this out, I will correct it in v2.
> >
> > > > diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > > index 302fef54049c..4637809192f9 100644
> > > > --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > > +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > > @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
> > > >  	/* Set up alternate signal stack that will use the default MPK */
> > > >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> > > >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > > +	assert(sigstack.ss_sp != MAP_FAILED);
> > >
> > > Why not pkey_assert()?
> > >
> > > >  	sigstack.ss_flags = 0;
> > > >  	sigstack.ss_size = STACK_SIZE;
> > > >
> > > > @@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
> > > >  	/* Set up alternate signal stack that will use the default MPK */
> > > >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> > > >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > > +	assert(sigstack.ss_sp != MAP_FAILED);
> > >
> > > Why not pkey_assert()?
> >
> > protection_keys.c executes numerous tests in loops across multiple iterations,
> > so the test_nr and iteration_nr printed by pkey_assert help easily locate the
> > exact failed test case and iteration.
> > In contrast, pkey_sighandler_tests.c consists of only a few standalone test
> > functions invoked once each, so plain assert providing file and line information
> > should suffice to locate failures.
> 
> Why would we not want more information here? This argument doesn't hold any
> water, please use pkey_assert().

Sure, I will use pkey_assert() and adjust it in the next revision.

> > (BTW This reads like an AI generated sentence. We're fine with you using AI to
> > assist with English for instance, but please make sure it's your own thoughts!)
 
 Sorry for that! I only use AI to polish my English expressions, and all the ideas
 are totally my own.
 
> >
> > > > @@ -1775,7 +1776,7 @@ int main(void)
> > > >  		printf("running PKEY tests for unsupported CPU/OS\n");
> > > >
> > > >  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > > > -		assert(ptr != (void *)-1);
> > > > +		assert(ptr != MAP_FAILED);
> > >
> > > Probably best to convert to pkey_assert() at the same time?
> >
> > This is a pre-test initialization path that runs before the test
> > loop, so test_nr and iteration_nr (used in pkey_assert for diagnostic
> > output) are not yet set up at this point.
> > Would using plain assert() here be more appropriate?
> 
> OK that's gross, please just replace it with a test failure kmsg_xxx() whatever
> it is, and a return EXIT_FAILURE; or something since you're in main().

Got it. I will remove the assert here completely, add standard error reporting
and return EXIT_FAILURE directly on failure.

Thanks again for your patient guidance and rigorous review!

Best regards,
Hongfu

