Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20A3C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCD66B00A6; Wed,  1 Jul 2026 06:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46AE6B00A8; Wed,  1 Jul 2026 06:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0FC36B00A9; Wed,  1 Jul 2026 06:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 992036B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:34:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1BD7C8D008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:34:02 +0000 (UTC)
X-FDA: 84939847524.07.D652DE0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E98080003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:33:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782902040;
	b=SUMLnCvjLWt5L4MZq87SR5O3OIWC+b561+wnvUgOiOAdgz37bmGRDZwrVSM2MLClXpfPXY
	ZRGLH55jeEnYrlNkG+0orTg+z1U7OCPuxYpslHmAvLIE39d9FIrUWH9kqb9m6q8FaPxn3G
	9Z8Rsng/3V5aZD/H1MiSwCBJ05WsfgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782902040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=adXmeum5XrmeKtBdOzYscwR8LvdD3SxppDxpdDIYcW8=;
	b=hfUYXHck0nt0ScKsJvktOWazAe/fkBt9qQhxutVXYUBVcShQ7yjmz602y1LyufZr49uMN9
	D3dkzK3dCTjZbXAWD28SzRFG7/ZmezvFxCm0u2xHVt247NtHph2T54VaaCmhe+TojlAyP7
	LTPP8CmzBaz0h3OaXwSZMoLfoQexipE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
X-UUID: 59c765ec753811f1aa26b74ffac11d73-20260701
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
X-CID-O-INFO: VERSION:1.3.12,REQID:fec1accb-4499-4070-bc03-1739f843941f,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:fec1accb-4499-4070-bc03-1739f843941f,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:c2b7554a1cb8331f306b33837f8e295f,BulkI
	D:260701164826BQSDSSH8,BulkQuantity:3,Recheck:0,SF:10|64|66|78|80|81|82|83
	|102|127|841|850|865|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0,Fil
	e:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DK
	R:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 59c765ec753811f1aa26b74ffac11d73-20260701
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 900317000; Wed, 01 Jul 2026 18:33:51 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: kevin.brodsky@arm.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	keith.lucas@oracle.com,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	maddy@linux.ibm.com,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	usama.anjum@collabora.com,
	vbabka@kernel.org,
	yury.khrustalev@arm.com,
	zwisler@google.com
Subject: Re: [PATCH v8 2/5] selftests/mm: unify pkey sighandler selftest assertions and tracing
Date: Wed,  1 Jul 2026 18:33:32 +0800
Message-Id: <20260701103332.352021-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d8a1c72d-831e-4880-ac00-5aeac41ceeaa@arm.com>
References: <d8a1c72d-831e-4880-ac00-5aeac41ceeaa@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E98080003
X-Stat-Signature: 3nhsg13itrygobzb7zjukprb8kbrog8s
X-HE-Tag: 1782902038-460093
X-HE-Meta: U2FsdGVkX19bFPerqOFhtFezUoFDGdNMSeQAUlG0ArlIjNiiSb7nM3Td6sxTi2O89sRrODWeP0K2pDX5eTtWMeL/nr8OmPgkz31DSFVgLaYmfDIhrQ5GV0rzvegLSQNmajy/uBbJTBdmuGDgykHlUcpgFl5qGtKalE9Qyr5Cn8ZpOnXc5exd8Lz0EDKihFcdV8RLJCeCd09nEVPkUcT0Ug9LVu8YlEw5m51IfAdh7KRPpRAE5oHQUlS9mKbQ13K4qWlDLcw5McY3ir1/1BSIADC30IMj8JAp8pckpcMtrP0CKbnOAE4wACMVAaw/MYchT+fA3emnaxpI/I6FFvWpYmdrtFyL/peZYmXviatG9DMlUj8NO5U9dvBvhGAbDu38xHRPI6rmlAfxQ0882qLc4HHfRnXJe7qGRnOc5Jsg8puSneM513Y/O5vW43D5/6w5VWsWt+rNUVTu9/dc1sYeMRxz1DZNZYJEQ/HhwfmhV0zP1jY7TFk4u6jqRbQKhQC8p6smqdDymojp9SVKWq7tKPV4nJdCf6VY/zcm17d0ABXUAaTOAbH1f6/50WoxnAZIlxsPB6GT+4ONYru6wEkYjcKKrKbiOXH8BWzRR5rffGISi+2/t5p3L7LsT0MgJbjJU4hU06PH6Fe19feoMkpswOHJiNVEuM8jSr3qC15olqV4BOWtjfXpXxWA9X5ImMGkxtpHBciGzryMK3z/CsNq8JuzOzS5o/NW4a1YRzIsPW/7nl5OFs1XLFwL+yvMBJlNxcioxOtH37j+f9f7BoCVikLxpVGiz7PrlRvE2aAirugm8Y8S3nGnKy8D8jBnnWC3z36yha+elQqxNAHnxmBrc9cUbMtkMLPhr6ZIj2o1s9HZFo4Aaa3HXTmxa6VCSfWeGlCW4NoQLL0yEzprEqxlokDFDV4sn6EtmeAM7wOHOEx/vd9S60xggdXxWxHamMNlFcaL4qFDpfGfnYN/dfJ
 jqcG2FnC
 VFF9a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> >  #include <sys/types.h>
> > @@ -36,6 +35,10 @@ static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
> >  static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
> >  static siginfo_t siginfo = {0};
> >  
> > +int iteration_nr = 1;
> > +int test_nr;
> > +int dprint_in_signal;
> 
> Might as well define those in pkey_util.c as well (move them in patch 1
> too).

Thanks for the suggestion. I'll move test_nr, iteration_nr and
dprint_in_signal into pkey_util.c in patch 1/5 and drop the duplicate
definitions from protection_keys.c and pkey_sighandler_tests.c.

> > [...]
> >  
> >  	/* Use clone to avoid newer glibcs using rseq on new threads */
> > -	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> > +	ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> >  			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
> >  			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
> >  			     CLONE_DETACHED,
> 
> Align these lines to the opening (.

Thanks for catching that. I'll align the clone_raw() argument lines to
the opening '(' in the next version.

Best regards,
Hongfu

