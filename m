Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848B5C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 19:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAE46B0088; Wed, 23 Sep 2026 15:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C406B008A; Wed, 23 Sep 2026 15:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AB56B008C; Wed, 23 Sep 2026 15:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5528D6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:11:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60E401408BF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:11:01 +0000 (UTC)
X-FDA: 85245969522.02.C1FB4A2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1AB1440004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 19:10:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hz+vBi8v;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790190659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdbvxD7XvosJv9AaBZwu35ekz1HVTVwCDc31aTv9+jk=;
	b=YRg1IzBLixU0hoNfCzkUzawNiywJOTYBBr+41YM5yfgRlbk8wvHFfBRINiz6z2eZqeMuJJ
	C+Va18A4bLvG1T6gfsh/cjmK+aPNZmktOfvWDDcr0x8fPGHvJVFt/qouHuYU5dDU2I1j+q
	OHbNnpY5Jh279FSLj5AY/B+OfHVTBTE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790190659;
	b=3qdiLMLdS8f62CYaOen9MgJGnHi0HsDz410tHbiezu8Pq0gTKw+9zbva6tKuWanPA7tTdO
	oa1TEArU3I075bKL7o0G1bXAO9Egacmbw4o9BnVYLzCoQ+GSU/rG+CZdlZdBH7ittWYZN1
	09jW8kyPP4Z9oy90f4oGloUy2Jw5cUs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Hz+vBi8v;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IdbvxD7XvosJv9AaBZwu35ekz1HVTVwCDc31aTv9+jk=; b=Hz+vBi8vLWbTXjXGcIU8xWLl2K
	TSfQU8Xcj1UQuDAB35cjiUwhEN10TXGaylwmqGeVjRSM/fQfyYZfLBtIDnXYVw4qh16APiCezp/RC
	BBZNVGgjX4MHaf/+oyDfJU5E+Y9cAZB+SFme7xvFHvoAgX4ij+Z2WmzNH8pDgI5nxCBbvH0NoMP0t
	/i+8K93VymoNJ7EVsVqL0MoDGIpGxK91ej5S63t1N3VmRo2Qntg0LVsY2F/wUddRmUAvrNEnE31+J
	Xf8FLVUCgYr6xerl1fGjRqPY780p5dRNiMxWmYpFsitQdNUHzUeEKtMMbp6Id5+29nHV2ZT95Uu71
	goELFdyg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9SMp-0000000ECUY-2y5n;
	Wed, 23 Sep 2026 19:10:56 +0000
Date: Wed, 23 Sep 2026 20:10:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <arQkP2uEzog8ChN0@casper.infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
 <an3uN4TAAZ2miXhe@casper.infradead.org>
 <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
 <arGidwZQrrWVPAoj@casper.infradead.org>
 <7a23511f-365f-436f-b934-6a520510409c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a23511f-365f-436f-b934-6a520510409c@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 797m1bwcy1dw6qa633fipj1pkhmeisi7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1AB1440004
X-HE-Tag: 1790190658-317977
X-HE-Meta: U2FsdGVkX1/o/HhF/MRAnULg8I7+jcBzAVb6+r5HGUZTehCqsq7eadXdgkDCPyHNlohe09fCUDdsBs1fQT2dygvYSGLISNh0oV1101/T6X/dPpHJGjpArdnZ2srXkURbimIxqsI4lKH69UdJWQr23qqgIX2DDr3L2lsS2K0rm/9OXha4NGYx4lGCpMuAJbWiJS1p7BHt6QoSqK/rLqchdJlp2wiW4A7jqVf0dc4Diu4O+EmcV4vZOjZejODmbsjTe9ZRhESaku9Jv474cUHGsYkP3Dm/9eAMYt/M3cMB3QkkF7qEX0vNcM/0vfLgbXQG7NxIsZNiBCwbLlJsVRu7V2ZvFfMLqzYtQPqv89lcR7swqEevu7pWwRScRTllrSB1s+xRLmpj6fEG8zPJG6G/YhmcnHOMc3QRU5+VO0X7N+gZqF9aLYFh0SzhHJIHJSoqezdAuhMCq4DA330WxHctcRGx5xREG7oEBdpAJrlWw+MMm6dYEU2izlqwBoZPO5cSQ2Ml/eCTChAhw+F4xxjuG1j1nwPh2Y6Go6JzdM3ZeH1tKpZCVrbBpvXPLPiEsOks+S0eZJBbJCC+/EQuacZbbBaYb5tYN+HjGy/xI9LZtXmzthcn38HSL2md47y9nzxCBC+I0Y7M0I0eRXfxfANdPe9vrVfuQL51IjdL6ortQmHfTaayqqLWxHHtZQ5BpGDdi0O+Ps7kJCXef+hQRcyX1FN+z/LYbYI6M2/xSqw4IUboJQT8LIVvudI0kad/ubxDUQqTn8NdgKAMB6Yp5vSkwEZSnZB0jf1g/jE+mdlrNKbBisB5Vii2IBGCi3db8krxUyHqskq+C7QEknw9QbbvW1eN6F3PU7yxtirWkWFnuiId/i0vFvcfrN8kDJQDRNFowfm7QjMPqTVJ5xSd2R9dYegsiNkDdM+euQUuhYje32OnYbeOrQNhm2l/FfR6Da8iqTmQ96GzOv2F/J0mTkW
 oscqE/Bk
 U98KNL0+V3DUoZdKx2JDMWKbhbdfmpJSNQBqhckvi6ChY7/2kne21isBts7V5v/E1O+uLJQSAsW3ArA5dtM9s528u/+DQkehUCiIctL9bBZZBWS5MlJ3lqLZEbs4dukcJPDOD3ddcUBk7EEoR/FcOv8xA5R09D/6kydlfVSU4b58+wAtuYaVatHASEevWhaHPnyYRM2adSUUgMd4cF0PCWS5I0Mo9SLfS3aBLzfzCG+ug1a+1wjn8257FJhnKW8t3YdOG785S0IYUyR+zDw0fTgvkPDF7XeogSyv7Nm13Bkm8MQYZh4t7uljM2iJUqrEqI4JRHcONONg07dVEYjijPDTynON1Lyvvibi4IIKTLiu/VIsoedxYZHL0EhUSFBpoCC0hBRIoMlE6w6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 01:40:24PM +0200, David Hildenbrand (Arm) wrote:
> On 9/21/26 23:32, Matthew Wilcox wrote:
> > On Fri, Sep 18, 2026 at 03:44:12PM +0200, David Hildenbrand (Arm) wrote:
> >> I'm a terrible person and it took me way too long to get back to this :(
> >>
> >>>
> >>> You make it sound so easy ;-)
> >>
> >> Heh, as long as you hold a folio reference it really is :)
> >>
> >>>
> >>> If we don't hold a reference on the folio, then the folio (whether it's
> >>> hugetlb or not) can be split.  And then folio_test_hwpoison() can hit
> >>> the assertion that it's now a tail page.
> >>
> >> Right. I am/was missing the connection to "generic_file_read_iter() in hugetlbfs".
> > 
> > We might be able to split this into two series at this point.  
> 
> That would be good, because I suspect the "generic_file_read_iter() in
> hugetlbfs" part is less controversial than the hugetlb cleanup and we can just
> merge that easily without touching too much other code.

Oh, no, it's awful and complicated.  We could strip out the two bugfixes
which are at the start of the series, but why would we want to do that?

It has to do with hugetlb not using the has_hwpoisoned() flag today,
and to do that we need to do all the other cleanup first.  You don't
need to read + understand those earlier patches; they have enough 
review from people familiar with this area.  And sashiko ...


