Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CADCD343F
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 02:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653F96B0088; Fri, 15 May 2026 22:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604616B008A; Fri, 15 May 2026 22:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B816B008C; Fri, 15 May 2026 22:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4078E6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:30:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B51E1C0820
	for <linux-mm@kvack.org>; Sat, 16 May 2026 02:30:32 +0000 (UTC)
X-FDA: 84771704304.18.DFBE12A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2902A0002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 02:30:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778898630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PbRRS/nXIzO9UtvMru49Vz51ZLuQM3EW1c/4mZLQJsc=;
	b=jeQ5dvXekuCLgGD3LJM5Ty0nr7B3/v/ky3ixUPwPk0ipgBvIpQ3S1vmbpDcQ1TYD7GayOp
	4V9U4xqLUKS65E30Lpzny+JAtF/fcPkj0oL4B/LJzgd2umwrdg3SG+XR5GwEBILJtyHYXq
	YS3TTXY2nUIEyDsULfIJMTu88cp3xk8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf15.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778898630; a=rsa-sha256;
	cv=none;
	b=ScNoCOGLGDXekzpbyEZ7gToDgoAT2Wtl/Fc6x6rY2FvlBVCMu6qGbGIdaOKovNTqZmen3S
	gj3K2odFUa+vqGP7GZoC4k/PRTLyibMP3T7+4n7bfIs70uMhTs6uzt9Brz4l2OuPXuQUa4
	xdObXPy96ZHI6Rxfk+5JiXtA2KU/c5k=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gHShx6cjVz8Xrr9;
	Sat, 16 May 2026 10:30:25 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64G2UIIn088323;
	Sat, 16 May 2026 10:30:19 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 16 May 2026 10:30:20 +0800 (CST)
X-Zmail-TransId: 2afa6a07d6bca43-50354
X-Mailer: Zmail v1.0
Message-ID: <202605161030201132-29L7DohlwP7mqnZJRgt@zte.com.cn>
In-Reply-To: <962c2a3d-0502-44b9-a115-863b513bafe2@kernel.org>
References: 20260503205153715oK1yza2bba5lfAl3QwiPx@zte.com.cn,962c2a3d-0502-44b9-a115-863b513bafe2@kernel.org
Date: Sat, 16 May 2026 10:30:20 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <ljs@kernel.org>, <akpm@linux-foundation.org>, <hughd@google.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NCA1LzVdIGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64G2UIIn088323
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sat, 16 May 2026 10:30:25 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A07D6C1.000/4gHShx6cjVz8Xrr9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2902A0002
X-Stat-Signature: r6aixbp6qyqocknmojk4dbqox4jjipgc
X-HE-Tag: 1778898629-213958
X-HE-Meta: U2FsdGVkX1/Ej45Ws5bTW+k5Hu8Tfmt3qyxhfiyf0+e5Ceqt//AciN2nPlytEU4DWoqEuhQoahcVMkTWwxsuYAcWgpDo8H0T4cW95RwqHQtfkDDjf7ImXLrYPH9RIQ26w7nZsNyax8ZOFhW9TldLrnPIBjv12zLy3qjpiIvVqNFgnIH9JthfZjOkpLph59x/9d68z7/60AOUSTSYwob3nHpep0mUn6sF0Fq7MRGFDgnHtWcVSx8KzbCqDp7AakPDf38/7rDq5OhxasDqajS35BYuGTmRy93eDLOFw+0iwXzntRPKpOpXHIZZAULlG+dXF3MZq5kUQKQRq/7miDrFyCRClPaettohuYx/yvUhtcsH3KJCwdymdHQJPHy50dbGpi642pMb5E4uf2IwA/9MdCi8o20baRKrcvqn3w1E6Rx/DuEQ8MKa70gJAmuaPI+gOdPhSAlaCvsPG3D/868ZZlU7H23vReSe0hvg5sotYi/AN5mSXdNoHrmBqPJo3ys6BTE9Tqg9hczV7e4KcY87JPdzt/fWH/x2EwzbPiRICUJnXj0PVgErUhHtUDE3BNJnOyqqrA3Kg8oFEKTncYyPC6O+Ll8uGRdtGs8PjKEN96mrFGCuwFJcymllEWp5d0FyummmDp1uH8NIojDLtpPZ7kpT32PBNldBa4A6eyYLGZOo8K8l9kUE9kjEplL+bK2zDzfnRWEkE6oz1ersM7riINSgZpxjMZeiR3M4olUE6UMihr9AGQB1bEhM3F6r9wmbN0pzSYGh+DxwHP8bNovJ8Gg7gPLktDFTG3wVE4ER3Z2uw30332ZHl7DDGKdOTo1xHDOlr8s22ETppP0HfCPJ3hrufbP75wANzv9DpYk1Xlzeq/cyI9n9vl1jicAU7yCvJ0ec7xA76bISXAF090M/90e+gzO1V3CP72eIou7E/1vkBA75rEY603zvaLP4eIg1h+iySlpjCXZc6xRdCqa
 9uqiAQcc
 ARFg9mr0V1+oeS+qpscENia81cCv2IHQ9CkQ7M7h9T4M7z8XaQ0dknORwjKPb5LXvTnf0PrsdsUhK6sttMMSk70BaKCAyacN6WU8Eqs+uesZL+em1TGwZwdOzsn9Zjo+O2OMQrBqFWaPUgI3q3E0t6E7jARFnLxRCtI8DQKtNjV1LM9EhzJaC840L9viORM9ca2lLIAJwUBY4hnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > --- a/tools/testing/selftests/mm/rmap.c
> > +++ b/tools/testing/selftests/mm/rmap.c
> > @@ -430,4 +430,83 @@ TEST_F(migrate, ksm)
> >  	propagate_children(_metadata, data);
> >  }
> > 
> > +static void prepare_two_pages(struct global_data *data)
> > +{
> > +	/* Allocate exactly 2 pages for the test */
> > +	data->mapsize = 2 * getpagesize();
> > +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
> > +			    MAP_PRIVATE | MAP_ANON, -1, 0);
> > +	if (data->region == MAP_FAILED)
> > +		ksft_exit_fail_perror("mmap failed");
> > +
> > +	/* Fill both pages with identical content to encourage KSM merging */
> > +	memset(data->region, 0x77, data->mapsize);
> > +}
> > +
> > +static int mremap_merge_and_migrate(struct global_data *data)
> > +{
> > +	int ret, pagemap_fd;
> > +	void *old_region = data->region;
> > +	unsigned long page_sz = getpagesize();
> > +
> > +	/*
> > +	 * Mremap the second page to the first page's location (FIXED).
> > +	 * This effectively overwrites the first page, leaving the second page
> > +	 * unmapped. The physical page originally at the second page is now
> > +	 * mapped at the first page's virtual address.
> > +	 */
> 
> 
> But if there is only a single page, why should it get merged by KSM?

This test runs in multi-threads, So there are not only one page from this thread but
also many other pages which are mergeable in all other threads.

