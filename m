Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1889C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975E56B0088; Wed,  8 Jul 2026 22:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DBB6B008A; Wed,  8 Jul 2026 22:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865DE6B008C; Wed,  8 Jul 2026 22:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58F036B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:03:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E047A1C3707
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:03:21 +0000 (UTC)
X-FDA: 84967591002.13.6894CFE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id 20E371C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:03:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783562600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc18g3PJkB+BTiY8TLzXWI/raVtXDNCErXw/A8kS4nU=;
	b=w9Y96ggAq2T726Tqm12B5HcZdfjVBuCvHWx2kfAmWLorSvfwH8X9kq3YcIT3BHnoJ6Rr/x
	UhG/P6zP8Wgp6VZVpMhC7zYDLUBM0MQeRyibI5SoHDvJAVryuYOerfV3wTfM5jjLz8lvbU
	Qlnpr8AUVV1TkB1nPF/hInPWJByNjeY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783562600;
	b=lp/1iBoUVHl938whRypjN3EeM7/eYjHGfsoovWs8Z5Yqab8Fj2XYLbeBCz3hC1dNDXiA53
	OjY9HhJkcF7S1jvPJNN1UFRrrt37jRncUb7bL4LG9u4/5GUbKPoH6C/3yCdFCsho1jzxM7
	dVkIlRKUxfjYpo7oxVYVCcNP9jMXTWk=
X-UUID: 554f81727b3a11f1aa26b74ffac11d73-20260709
X-CID-CACHE: Type:Local,Time:202607090955+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:554efa85-6dea-4037-98b1-8a24f18eb564,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:fc6c9494758eabc419db5f7bb6b48182,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|850|865|898,TC:nil,Conte
	nt:-10|0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 554f81727b3a11f1aa26b74ffac11d73-20260709
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1842798811; Thu, 09 Jul 2026 10:03:09 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	hongfu.li@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org,
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
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
Date: Thu,  9 Jul 2026 10:02:14 +0800
Message-Id: <20260709020214.1271413-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260709010905.128451-1-sj@kernel.org>
References: <20260709010905.128451-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20E371C0003
X-Stat-Signature: fe3mdbkdqhatq7mqghiuhgnq6uwsnbxk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783562597-600020
X-HE-Meta: U2FsdGVkX1/C9DFyof8A9QO+46WySXEZ5xXsTBrw/cn5sE8BOnrAQMFHf65YDKA5xaxAnhLkKa0HCeglWa1abMitWUoi6OrnG91+WcFbSoCy3AqSVbwq3Pete559qQmvhzPfLLy8vQa5wy6tLj3BkM+ULd5fY3jFetE0cfC3PZfFAuqQj/cvwURdRWsevTKRxSMKvu3shyUSB5evTp4l0lHx7RMmGKqZ2MteZe4wYg0KaDILVIZ1TFR48iH9YBbVUWCjyKFz6J0rMOn670DXh5ltZDcDmIiDw8ETr392gmklHJJb4Y+r8d/w/kmnI5w0ond4kGCy2TYXiH1gLaa9FaGTsuMtjKM+652MyN+O6ukRe6sHPzjyv3KDGBUSf/2EEH6AMsoHNHULXpecbhuGWoMY1kPBb2jHioJOMpLGEcFzcvoriMJisxq9egUvcVkNbfu4yJL4eTrk8sHE8b9Yps2qiwThCA2LcOlAvf1JuNpud+YxOR6SzAI9rrSu4sbtNLlcKP3Ag1nVHOnR8c4tjjjjHnlbaX8jqkcr6NyihAasIFFJt4NLEgX5M7wXX5ORq1z3jlW4o2TByUvjSSXVvnZvgLKKzo7vByGsfd4YfTJTtcLLGyOFhMOTf8Ap3P/H3/juXKZv+kZVKL+hnCUqPKBOAEBmjcGk0n89mJc3l1uCVUx1LbOWi2p81oWGBLX7+1mrP2RmbtIi/DC3L+dwFzuf2bXFLNGAbtIFLZmlbgxqN3qqq3kCLSr8ZP4OF7FNucFRNRvQQ1qtCAdfvsKPjY1kAdGTsAEkf7O+Vk/AlAslXgxSOAhmLMpWKbOU5cYzajEXMdKt9WroI4rwtNC9zzEVuBPtrXEyeklPom8ieHPBRS2C+oPinjHEJtjHmpAFKjqMt3/YUjjiPGWyPV4eMQFZXwdyAWBB+rxo1XqmAyv6ihQONeL4THF+XNGQ2V6lM9sC9HmUpDIUj/0CvLN
 j/5+ik4c
 PtyYOMhpGmJbAQIDYTwrk0mBZEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > Several early return paths in run_migration_benchmark() skip
> > hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> > label.
> 
> Looks good to me.
> 
> > 
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> As David suggested, having Fixes: would be nice.  Seems 271a7b2e3c13
> ("selftests/mm/hmm-tests: new throughput tests including THP") could be the
> one?
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> [...]
> >  
> >  	/* Cleanup */
> > +cleanup:
> >  	hmm_buffer_free(buffer);
> > -	return 0;
> > +	return ret;
> 
> A trivial nit.  I think '/* Cleanup */' doesn't really need to be stayed there,
> as the 'cleanup:' label self-explains what it is doing here.

Thanks a lot for your review and suggestions.

I'll add the Fixes tag referencing commit 271a7b2e3c13 and drop the
redundant comment in the next version.

Best regards,
Hongfu

