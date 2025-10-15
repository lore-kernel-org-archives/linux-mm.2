Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D547BCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 02:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6AEB8E0007; Tue, 14 Oct 2025 22:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C318E0005; Tue, 14 Oct 2025 22:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38978E0007; Tue, 14 Oct 2025 22:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4C598E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:47:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE1F911B294
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:47:00 +0000 (UTC)
X-FDA: 83998811400.04.39A8A47
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 049A84000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:46:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760496419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DUfInmfjCXWXWHNUvAFju1n8/AD74+ozx/b8R+rN4E=;
	b=pp2ayrBKjQwH+rF0QlWnDxXJ5QKxwfLnIBOrNm+I+09nfqMxrYTpaK/fJL4tTy0At5AKKx
	UtaQkzk75BlaXZSg5rvdaUB+jg8kH8WxmNPoKMpcl2DHG/98Y3+6SBV3aVCHB6XihBiP+h
	9DwuFFa3XgLz+oNxLniRebSYAYvgYNk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760496419; a=rsa-sha256;
	cv=none;
	b=rSKLJrefhpGwk3cyXN1SRFWVxx5zqNYh4xSXobF4LHpo085IhKA49Fld5Uk1I+2DP0wjz8
	KDhKRAPWL98tVLpElILsVHp56YER+Hap8bDCyGwzig92J71X80Ivp69CsMrPaAUpHFq2m7
	ZpQ73/5k5mxak+kG0Q7swzRppuvc48o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: 33614046a97111f0a38c85956e01ac42-20251015
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9de399e0-e403-4388-8d89-3a9026aa03b2,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-5
X-CID-INFO: VERSION:1.3.6,REQID:9de399e0-e403-4388-8d89-3a9026aa03b2,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:f7674e290a18d7778a8da14655b245f1,BulkI
	D:25101510465334PBUK1N,BulkQuantity:0,Recheck:0,SF:17|19|24|44|64|66|78|80
	|81|82|83|102|841|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:n
	il,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 33614046a97111f0a38c85956e01ac42-20251015
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1506227250; Wed, 15 Oct 2025 10:46:50 +0800
From: Enze Li <lienze@kylinos.cn>
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org,  damon@lists.linux.dev,  linux-mm@kvack.org,
  enze.li@gmx.com, lienze@kylinos.cn
Subject: Re: [PATCH] mm/damon/core: fix potential memory leak by cleaning
 ops_filter in damon_destroy_scheme
In-Reply-To: <20251014182539.50115-1-sj@kernel.org> (SeongJae Park's message
	of "Tue, 14 Oct 2025 11:25:38 -0700")
References: <20251014182539.50115-1-sj@kernel.org>
Date: Wed, 15 Oct 2025 10:46:47 +0800
Message-ID: <87jz0wg9uw.fsf@>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Stat-Signature: amdxe7369s9k3ey4ywfao8empgd1qzqu
X-Rspam-User: 
X-Rspamd-Queue-Id: 049A84000A
X-HE-Tag: 1760496417-855300
X-HE-Meta: U2FsdGVkX1+q0fQdorEPwi8Au3MgHjynHjx+OWPsoWquTs6aH/RQ1CvldqyVo7IqGsVM0NW1xzg3b8LearNmNc2Qyh3tm+DjhbuA75oUJlnDYsWw7v71gIUh128jssXgvRVCpn5Tk7Kx8dV6a2D7gIJkniHCCli5NId22psaROWySDiyBvWuaL1aGrJrM1bgGO3Hjfi10VjoSeZiPMydbK0tpeURbcVSgNAj71mLEPgzbrp/VuHEpA061v6BAloFzstVTy1izJI7uFKHemCefMXZi0FekS4lpXm7u+/3zkATYGJnLWo7NZoTbd2RHimcPtudYhsL75zrjw/T7WviLtFLvbGND0mM9fefRVrOirqQk4CD6U0eG2IMI262CBp3mebUurgau1+TZoYa2BWEvIcMaS3KUV4VZL590EpZ1CrsRb058A5BNmtpYF5qL/yOuuDyZ0l455SNGr6cRxQ8c8h4+NL96KaPXyW/3JITgBpJ+drJUIitOQofIduyKpDWOy1/aB+dNtoo1QOvtIbjdTnsBefHvlvijChfAsQhuO8i9w1dwZaerQjovm0wDuqFe/QrnZ9kVupNS+8gqaZtmGe4Fvs8i6iMZvRcDgAxvnxF075mL3T3yklp8mnzACFxYFWZZ0bh2MGyKXjUZopytx+Yqq5Zba/K9u0vIWXvegy4yHc+vMO/ugHWUqgxTjH+cu8KeZVXzCmm3TUAB5VNmugaBsThaXg7Rlrixe8a1dITL9iQeAd5k2BpN/0TeDN2/fMB8K47QwD3nm/if88gLC/dLjjdGtqIDPmi4bIk5gQS0WHengasC1MJaLMbGUyKwKBXbgSaRIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Tue, Oct 14 2025 at 11:25:38 AM -0700, SeongJae Park wrote:

> On Tue, 14 Oct 2025 16:42:25 +0800 Enze Li <lienze@kylinos.cn> wrote:
>
>> Currently, damon_destroy_scheme() only cleans up the filter list but
>> leaves ops_filter untouched, which could lead to memory leaks when
>> a scheme is destroyed.
>> 
>> This patch ensures both filter and ops_filter are properly freed in
>> damon_destroy_scheme(), preventing potential memory leaks.
>
> Thank you for fixing this!
>
> FYI the leak is not only potential but can easily be reproduced using the ops
> damos filters.  For example, I was able to reproduce it using DAMON user-space
> tool (damo), like below.
>
>     $ sudo ./damo start
>     $ sudo ./damo report access --snapshot_damos_filter allow anon
>
> After the above steps I confirmed it leaks the memory using kmemleak.

Thank you for the review.

Considering that similar memory leak issues might occur elsewhere in the
future, should we consider exploring the introduction of Rust for
certain modules as a proactive measure?

My search through the mailing list archives didn't reveal similar
discussions, though I might have missed them.  Would you be open to
sharing your insights on this matter?

Best Regards,
Enze

<...>

