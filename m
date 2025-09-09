Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AEE0CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 14:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BC26B0010; Tue,  9 Sep 2025 10:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5733E6B0011; Tue,  9 Sep 2025 10:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D75C6B0022; Tue,  9 Sep 2025 10:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0706B0010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 10:29:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE3ECC0549
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:29:15 +0000 (UTC)
X-FDA: 83869944270.04.03CCDF7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8479DC000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 14:29:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cglac5SI
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757428154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSVI0c2MPcfCxfTbX663WL44nUGjRe9XBH0DR/kkG60=;
	b=wJRvBUZt3JNIVgB2DyVPGi/cW5pgSHWwky1ywaUaHP8c+oTSaNfKyDdhI1tUXaQQTi9IVc
	aI31uytKuNEAVoIi6ObKLApar8KG3BBmOFcezVC7h3q88OmhLIHjQayXqDsUVwUfH0jfRU
	3eae6d5U0ABcxXTbLYG3F0ChOk/uTZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757428154; a=rsa-sha256;
	cv=none;
	b=21vHxDHkDJfbS2POlA2/5WO1yVsihI3AZrXck6X9wmN3HzxeC+kVRZTzBsGwv4kAW3/VQm
	B2rhPUmIBvMNnLugRn3OpN2fEi6GvSUA82VCGx5Pf1YAoG0WJDbTXkJo4aFIg1Xue9uQ6u
	SjFvK3Og4FC20hf/Q78cR7Dp0i1zrew=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Cglac5SI;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HSVI0c2MPcfCxfTbX663WL44nUGjRe9XBH0DR/kkG60=; b=Cglac5SIFR5CjvspnMxpLy1ye8
	tEKEQ8ttpuZpCBFn+6Lmi8GVjaUOM7oDnrcPldtmZ1qaFUqTK5P7obZzYfPD0ykfi7GECexhqSoYU
	sNEZArLKw8OFDwl74/Jd5DmrF2850dKOD8Msv1ksESrOoWsNw84tVsITTWsE+PD9i2wVxF+oJM0Tv
	4iOTlrosfIoPJgrpoiYwMIRdKdb/V563ab4UivgNT1QjAz/2kXipkay2hpXcyR+v6FZDIKXThQwoz
	B4S/bCPhIgFuZDWEJf/H9B+1qmE2N7B5nE7S/nrycOEVvGPH3KnxChx1aFvDDbNsDsnc8954z6sOI
	dnAUBDmw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvzLH-00000009Efg-0Dh6;
	Tue, 09 Sep 2025 14:29:07 +0000
Date: Tue, 9 Sep 2025 15:29:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hu Song <husong@kylinos.cn>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
Message-ID: <aMA5soNyvsEcWvlz@casper.infradead.org>
References: <20250909074812.599030-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909074812.599030-1-husong@kylinos.cn>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8479DC000B
X-Stat-Signature: u49w6bpxj945f79p3ocpff7neo9x7srd
X-Rspam-User: 
X-HE-Tag: 1757428153-915068
X-HE-Meta: U2FsdGVkX18E6iI9MlA/Pt7W3gQ99vlo4Jcw8jJYFi+4GvNKcKSm8n9FVpUL/mu127ms6v2QuG/wz5liI+caxjz48HfGR0pN3ST2Bph8kG1De8k3/qo14mAi+Y3wUlgO9H6hYcfWlcLaed2We1Fs+uMhX0K1AQO5wSbGq25eU09wzYfJkzlV6SO0w95BEtqFYZlEdEQmxnvBf3cPrMYRF5x499All8jUnF9z965r7apn6cFS1ADbHmVopAVgKBPwAYZEoZ+vvMntfKKBzWMezRsb3oXjWHxOq3bhftNw0Vj/eaoy84hglNi3S6iIXJZYwBm15SYRaIWOgzn9dcG3FNYifuXXdBtL+PecNP2q2XkcRAifoLb6nOYeTC/Yv/NuL8sGOIDL3etg+hd2pQw0qIL+qy+xSv91cUTyXif//dA6v3DbCSmA0JBpZQsA3duLG4j97BHRCflOk4fgLyzjISe332L6o8YL43zLU8VN944zghPW6HhxWDTcfhyqR4OokITwsa/2nfSjzgRY8KBD98FFnSr0i/MpLJRyaIbtSoTZD2fGRVnQpceOl+U+O8BUzj93ZX/PFG4+22lqww3h1SvFe8fD6G0DPERm2QwEU5H+uZzS+nwRnZwmr7jDycSf/nSrZnrZr5+GakeFb+4LoMx7kS0OJUyccw0CE3OPzHTHmZ7fcnWTSWoV5HOu6FlqgTBvJlpZYsycc9j53bciQxlWHrnfH/zs3MG6iz992W1Z+toX4er4f+F8/cPXs8t1MMscue9MdUP8v/3k01HrA838IYpR/c5wvttZ7OVu0mZg9SIKh99zz9bApcEtkvhl8R7E6hVHKIlZ1pSIpRe6jzfPtoAK+7OVyFuQzw5Ya2tgvD7/N8guYPUQQykH5S4t1Lm30Yns0SWOdd2szgMqn5JR49VtPkqn6N1FomjK7A3rlcxcHpM9PY5AQ1LLUtn0q9HfM/9wVzB6hxMLGrG
 J1gLSbAC
 sojda4CuAdRuvikf2p5jlVZad/SAqbyxaeUuHj1cqbe8bUOC7tupoBZ8C3/J2xvaA9vL9gv8eQ32CTUbWAqSp/VtWfNikkiQKaIolnPPpITqLGgZpSTGO5wHRr9Uil+2n2sWWhfVELvsY9/YI0F9QXt6djPacaQOVUaP6HiDj1WfUkMXlVnybjgsPk2MlI8G3LwNJitJg4s2GAl2BZM7EDFeEErXkx0luls03IWpWWAgqF6UQO9qQ4ULnZEkwGRPJsnGa9IgoFDcFYC7e688mHc6QG5soxXNElvTkwopoclQitEXSI6p/fzkGBVmwjrAbEanVJGR2BGLWKSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:48:11PM +0800, Hu Song wrote:
> Use folio_nr_pages() helper instead of manual calculation (1 << order)
> for better code readability and maintainability.

https://lore.kernel.org/linux-mm/20250829154728.3397606-10-willy@infradead.org/

