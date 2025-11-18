Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250AFCEE34D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 19:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D306B0029; Tue, 18 Nov 2025 14:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D786B002B; Tue, 18 Nov 2025 14:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263C56B00A5; Tue, 18 Nov 2025 14:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13F146B0029
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:57:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC9C6139322
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:57:36 +0000 (UTC)
X-FDA: 84124787712.13.6F7C94D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35B0D180018
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 19:57:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lbaXHhds;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763495855; a=rsa-sha256;
	cv=none;
	b=h4P1QNM37c9MrT/CMELLcyWk9rtx4vpmwU9RCV+XavNxTg56utU8pjNno+Rp9L7ynUFQg4
	xSdL/8pEF+7Co9f0SACnLzWuaFy8e9l/KpW1mnAZ1wc4ss+J8CB9BKhFj8i9lrTlapqHjM
	SZdmhBVzCsa9aKBMRvB5PHldUN0P5V8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lbaXHhds;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763495855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1Y1wX4hmQMJFdqAY8ThVoyxh2X0uPU7pKbMV844lBw=;
	b=P1atvkfWDeVHX1P5iNCiPg8zmDzKxUqz2J0vk8bBypimg9sOClGikYkWuHKtwud9yAd3Xu
	/9RMMb46c6aaCPIQMI6YcG7d1fhG3ldmrSk+uODaTgjvnmHPoM05IWThAt6oU/DRfMbGTZ
	2r2eAD7RAHZUaeyth5ia8DyfvWFpe/0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W1Y1wX4hmQMJFdqAY8ThVoyxh2X0uPU7pKbMV844lBw=; b=lbaXHhdsH2npNGMQXpllRKoSUy
	0MCDp1l9wu37uJ7l0yMpcAoaRkm3t9gz/LH/7JtA0nAAu7WkplrxFe0X3nPyaJO3rOzqshSYjtUoQ
	W1PM/N3t0EcXeLb82mhVGZ4l9B/YbdbTrBun+X+ooGzcOVIzArNua9tTCVv2yDIn0t9kgTXguLmnS
	1lZoFgeYaLodhgLjGbttW+S4OABTA6xXB2HRXO9gLb/dd/s3/VPwKKIW7E8e/Qrmn5CwKRY2BkXvs
	/g729uocHjpGQWKMvqwNmErPVAIFSQKXP6y52R9/w6Uux06eX+QIFlFAOCOH1gwxcA2YKSNg889sS
	osHx2fAw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLRpS-0000000Fz8x-0Vhn;
	Tue, 18 Nov 2025 19:57:30 +0000
Date: Tue, 18 Nov 2025 19:57:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Biju Das <biju.das.jz@bp.renesas.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"urezki@gmail.com" <urezki@gmail.com>
Subject: Re: [PATCH v3 0/4] make vmalloc gfp flags usage more apparent
Message-ID: <aRzPqYfXc6mtR1U9@casper.infradead.org>
References: <TY3PR01MB11346E8536B69E11A9A9DAB0886D6A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <aRyn7Ibaqa5rlHHx@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRyn7Ibaqa5rlHHx@fedora>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 35B0D180018
X-Stat-Signature: 39kfijdsbh7uwsuyhugz77qd3ze5z1t4
X-Rspam-User: 
X-HE-Tag: 1763495853-933329
X-HE-Meta: U2FsdGVkX19hPdyLC9F+DbG5tGKFuwYLaYjQMTMvYPmsPKfGXBjAUORciLxL5pgMoRwkXprfREWkamEp/cDl9m5HXbqq410ZBKNsXFuLl2JzpkE//gTfFDc/TLg9tEsD5tGeyGiLMcm1mYqWn/8CeMhdxJ0R2daXc0r9wlSK8OLr+RAI3ZHSjvjyPCC9vbBG5d2QhOfuaf3M4Kdh572EqiuHYh35BEmtTt3q6zHCsG/5CVizhqsREUPert7Dh//+RYUx1SGh1SKq/uJwqemLW/Vj21mvi3qZUaDD3Uk4Zowfyab9TFt36LELrn8Y8FilC958CbPpQzeSiL7InxHZ+GC7X1vAjm0rs9nhQD8eYYGMsAFsd55cGBtNm34CtMaz2WNklmK8lWwf6CxGdTDeh27rfdKS/NpFHZbD6fXu+3Yn8XNTxHTx4S+jaZ0H8+4uFyXGT2vXPasvT15vGA6CjVtmQ7TRVlTrfE7JbxPTb8hMe8Cjxd3oArJehER+td3gTEPxjhnFvcyGZjlAcOEiwiTlAneDjJokfowAQsyCBDnyTveCw/4UYdwnRZJhi2LiT3pte1kPSLw7ZO9q8K8KORcQm+opJSrzkwwFZiUIIaLLijZVC7HRMIAGkxhk58YI7hkJZHN+WvwzuEt7xA8sIR0s438r8zfYCbbMNTk8zJZkHJrNWeLrUnVdGERfYOvfiE84LmCIWq34IPR+0Ro1e1sc+jwZCl8U7PM2x+20wJwmX4yu+jz8+S7EA4pf164/dmKfoXo2Jg2foiK2cPvZlTLNS5dB0Prg72Bs/BpSZS8/45gwa2kB1djgj4gBvA8x3bJrEK1EdF2vg+hiYsG+AHu1/jjAYweoKeA9D243nSVV62ZSoy6+py5jZ/3FJAZDJMmRiSlwrzWH6yVySRianXMMfQFi2P8VM2wUBgCvyBAlvjPNImmcVvszfyU2EHKvCDi50ocC0yhEiFXExsh
 c4ur5l9p
 w3CU+XwQyTzCBFvMJa8q74niAbC7IM7+h3z/8AeV2et0RMoJrso9kCjF7P/Sc/qwg7NslINAbtmxtaRMAl+wKn4JOB74svscM4SGl/NNVHm4c7aCw9nEOFXmsnWtk56WplTz3fuMxS7ldN4YutYG5w8GwAB46xZrnfOKoH8PrP+9oFF5MO0l0+P0NULErRbHcQSUuE4G22obFKcfEchwd2RfFoYAmBcx/fyXIcc/T5Z60ZelTFj/WOrHCvb0XTrwx1RQ2ztYibjgxCcNyRw3dVpKSkCR5DXKZk6wOhdvkebU0fgRujFIla3k2ZJBQr9+C0zgurxFwpfArhVFMSEyuo5JMn1ls7H1LmDJCv8XHJoUmm4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 09:07:56AM -0800, Vishal Moola (Oracle) wrote:
> On Tue, Nov 18, 2025 at 04:14:01PM +0000, Biju Das wrote:
> > Hi All,
> > 
> > I get below warning with today's next. Can you please suggest how to fix this warning?
> 
> Thanks Biju. This has been fixed and will be in whenever Andrews tree
> gets merged again.

I see:

Unexpected gfp: 0x1000000 (__GFP_NOLOCKDEP). Fixing up to gfp: 0x2dc0 (GFP_KERNEL|__GFP_ZERO|__GFP_NOWARN). Fix your code!

I suspect __GFP_NOLOCKDEP should also be permitted by vmalloc.

