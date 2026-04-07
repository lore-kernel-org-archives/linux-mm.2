Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80D3FB519B
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A356B0088; Tue,  7 Apr 2026 02:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A296B0089; Tue,  7 Apr 2026 02:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30616B008A; Tue,  7 Apr 2026 02:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 927AA6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:22:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23E611B87BC
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:22:04 +0000 (UTC)
X-FDA: 84630764568.11.9A1F211
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf21.hostedemail.com (Postfix) with ESMTP id 09AA31C000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:21:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775542921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rABD0GS3BNK3X4qenYax0svM1fZzwj7W8ANWvQcfbDM=;
	b=6RmovGuUAqBOtpK6lzSqnu64dsGPSq+Q8JN4sK18dEEgMGsEddtwskp75fQJlWzflCBURl
	dZblu1TKElszSroHZdhzlTODAhj3AO0Lqa1D32IjKEzpMQLzxzHoNdqru+wvQswAX47n9d
	7lBlR0WLz4r2u2yNbOZ6Sw+/VJAtJww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775542921; a=rsa-sha256;
	cv=none;
	b=B/mx7ivb1hkKi7XUoydjg3q5rgLQOnknRRIz96KvCFOWlP3XnAh9oyxWgtNmg5+Q9Oxdx8
	Hug6wPdWtHwUM/U9iizEVR64fwGzZHPC6MkD51h/6HQEpeortMgNHzPrZYLoszy+mPYVgK
	rb30JWagEya8oq8YWcJ0oAeTuKDxU1I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4fqbh06Dn0z501bV;
	Tue, 07 Apr 2026 14:21:52 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6376Ldbd067277;
	Tue, 7 Apr 2026 14:21:39 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Apr 2026 14:21:41 +0800 (CST)
X-Zmail-TransId: 2afc69d4a275a93-0830b
X-Mailer: Zmail v1.0
Message-ID: <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
In-Reply-To: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
References: 20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn,20260406095804589iRP1BCGrNX3DviT29nv2O@zte.com.cn,9950c6c1-f960-58c0-4312-e4f5ac122043@google.com
Date: Tue, 7 Apr 2026 14:21:41 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <hughd@google.com>
Cc: <hughd@google.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <michel@lespinasse.org>, <ljs@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MyAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6376Ldbd067277
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Tue, 07 Apr 2026 14:21:52 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D4A280.003/4fqbh06Dn0z501bV
X-Rspamd-Server: rspam12
X-Stat-Signature: qhn49mh36ze7mroyfsohbecc7ndu9cey
X-Rspamd-Queue-Id: 09AA31C000F
X-Rspam-User: 
X-HE-Tag: 1775542919-324909
X-HE-Meta: U2FsdGVkX19zHpNNFJp6M+tMGumfOr2GKXnJNnamC4YCqgjpsSOQpUYzK8eCh2EBlEnmW6qpW+1PX/+Bvax3FIqgA2H93eONQPlLMubfDqFHedLK8emgDKFJdquDBN1CW0w0EOWaXu5xzTAdNs1n+Av4ZSmg1+uMRYK0hSFSiqkHYs6p4ygGaAfVthg2Kp4f+AfZYc7o/U3qc/Y2D5pYJ7J0Yrsh5jlmKDgxhDmyYSPJjINflMHgf/Z1tveCl7eFAHB76Gumc8zMpB6a4HJBH/HdNGFixQJ4hvuJExOwa/KGTeX1oKY8g5BwA1sI9G1fz95Xktidfzgb+NQk+6Zj/2y4tQ7aLryX5SI5Xfntd89eIbBk4rXxxR6pz1RHPhUsIR9gr/9KdNPaw3KavlKKGfI8s8I1ymJ6BASxoG0blf31XaWpnOhjoYhbs3gFYjrP7UilOwZhgLBAw2/torzgkEyDpUdyZ2ukUOiXE2YClwwfJ9uZo9Y2GKzgrn20eQ19FV85vYkdHAolARdY2FaRIEfj5DahvUq/lkaf8ycEXq58GolycL7YcJALXNsfXk44QWr08Yi50Q4dhso4yjnUwTClf1vq88wQH/BylqcpL+9RLe3Fcxvm+VfuO5yXovBnbEOIPVQP9pu41Yq/+iyJqVB7AsecTLcNz03vdhjQks0NCWpia+p8vEuBi0x2D8OFWqazSmRvGTD+wh4+BQI63STpmIfNbdoCglsVYjqvdyEJTD/VipmV2L+sQo/oTAiqN5dS6aDV5vHWqcirK1lq2WeLbByraMGDwdIiPCCKThGG7bf2astv8ALApZCNBlfP9pYoTPNqnyvtVmaBAHK8GxHT+NCHRkDWJPqwp4H7qB2X/iI5BZuqD2lsM/oeva9hDN7E9/s9f8U3IUiSqGqhtybflzNRLp3ovlwiBlHNglTj7wEJYrccvzw8256jxy9YXIu0upCKlXXO35NvG7w
 iWTBTOMq
 YCzH6uxAU3qiytpvJjr/90qhwffypx9BHVJRsZCTh9mFR1RgxVYPP220Bgfil7CrYe2erhxKf2Zs46LorhbvK2p1XX3BUfifggdDHTFzhrAyDqYIVPTJk9lErpxcgxaK3OgS4rfxpDuTF7oGLPOImPKPyhW7n4ocZHp8Ba2/PSs+/w6Bh3LfHLY3IMXqs80BKu1qIAm4T4UecW+wAyBUv7L9PUc1FEmu4/0RYJyEYD/WLbk5AgU+TDJtFeRpOv4GfvEZbr0OJZeUUpOVwr9o/V47Cn10f5ZX5uCqw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > From the current implementation of mremap, before it succeeds, it always calls
> > prep_move_vma() -> madvise(MADV_UNMERGEABLE) -> break_ksm(), which splits KSM pages
> > into regular anonymous pages, which appears to be based on a patch you introduced
> > over a decade ago, 1ff829957316(ksm: prevent mremap move poisoning). Given this,
> > KSM pages should already be broken prior to the move, so they wouldn't remain as
> > mergeable pages after mremap. Could there be a scenario where this breaking mechanism
> > is bypassed, or am I missing a subtlety in the sequence of operations?
> 
> I'd completely forgotten that patch by now!  But it's dealing with a
> different issue; and note how it's intentionally leaving MADV_MERGEABLE
> on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
> interface to CoW the KSM pages at that time, letting them be remerged after.
> 
> The sequence in my testcase was:
> 
> boot with mem=1G
> echo 1 >/sys/kernel/mm/ksm/run
> base = mmap(NULL, 3*PAGE_SIZE, PROT_READ|PROT_WRITE,
> 		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> madvise(base, 3*PAGE_SIZE, MADV_MERGEABLE);
> madvise(base, 3*PAGE_SIZE, MADV_DONTFORK); /* in case system() used */
> memset(base, 0x77, 2*PAGE_SIZE);
> sleep(1); /* I think not required */
> mremap(base + PAGE_SIZE, PAGE_SIZE, PAGE_SIZE,
> 	MREMAP_MAYMOVE|MREMAP_FIXED, base + 2*PAGE_SIZE);
> base2 = mmap(NULL, 512K, PROT_READ|PROT_WRITE,
> 		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> madvise(base2, 512K, MADV_DONTFORK); /* in case system() used */
> memset(base2, 0x77, 512K);
> print pages_shared pages_sharing /* 1 1 expected, 1 1 seen */
> run something to mmap 1G anon, touch all, touch again, exit 
> print pages_shared pages_sharing /* 0 0 expected, 1 1 seen */
> exit
> 
> Those base2 lines were a late addition, to get the test without mremap
> showing 0 0 instead of 1 1 at the end; just as I had to apply that
> pte_mkold-without-folio_mark_accessed patch to the kernel's mm/ksm.c.
> 
> Originally I was checking the testcase's /proc/pid/smaps manually
> before exit; then found printing pages_shared pages_sharing easier.
> 
> Hugh

Following the idea from your test case, I wrote a similar test program,
using migration instead of swap to trigger reverse mapping. The results
show that pages after mremap can still be successfully migrated.

See my testcase:
https://lore.kernel.org/all/20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn/

Therefore, I suspect that the reason your test program did not swap out
the pages might lie elsewhere, rather than being caused by this optimization.

Thanks.

