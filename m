Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D3ED49C74
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 08:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD17A6B0005; Fri, 30 Jan 2026 03:51:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7ECE6B0089; Fri, 30 Jan 2026 03:51:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AB26B008A; Fri, 30 Jan 2026 03:51:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8A76B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:51:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E12A1A0575
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:51:41 +0000 (UTC)
X-FDA: 84388012002.04.6483AF1
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C8F220007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:51:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ul6c6DoD;
	spf=pass (imf03.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769763099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkUtsb7QwZdL+LDizpsEkBxaLkE/G58Yn4o4w4mhoyg=;
	b=k3GbTCkmCeLbuIfFbn535SvRkxRn5SVVJHw5MAXJSyAO2iryi8yH9AABAM4HlIPYgNS2Rm
	bgXn4dUF5Lhw9yXxt4NG5eGTj96aZeEM+GCup7M1LKUw0ewAML14aiGTZrw7YovDYeNDUq
	IQpV9Ic2MmVSr2r47Gs9zbZ9yXmdiag=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ul6c6DoD;
	spf=pass (imf03.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769763099; a=rsa-sha256;
	cv=none;
	b=kCHEW2PhtGn64xvfndsdg6s66neT191sa1UfOStwb/nrvRFBNTux8s+KpaWKDcU+g+rfJG
	VWAO8fIoyKrJJ2bKWe5nAgl2bU8SOgIFCsZbcMV3WObrRdlDYVzDuEk+ucZ0ynb2jPUQzX
	GQpjAGQiAU9qARagbfrU26gsPenFSN8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769763093; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DkUtsb7QwZdL+LDizpsEkBxaLkE/G58Yn4o4w4mhoyg=;
	b=Ul6c6DoDuXzMooXfYNPtaJhBlLlbpvZ6/7jTSiQSyYEGLv7thskdKquSRQLXNTRtVtEXKIvyyxbOWyJa6EH8Q9R0euJGHj1KZvCNRA4MP4Cm0ugQ+CP66Q2YSKWrt0Ds7s9tL4IC8kygseKotFddSw0UQxP32sdRr6185WjuJus=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WyACWjW_1769763091 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Jan 2026 16:51:32 +0800
Date: Fri, 30 Jan 2026 16:51:31 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org, netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next 2/3] mm: vmalloc: export find_vm_area()
Message-ID: <20260130085131.GA122673@j66a10360.sqa.eu95>
References: <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128180629.GT1641016@ziepe.ca>
 <20260129113609.GA37734@j66a10360.sqa.eu95>
 <20260129132058.GC2307128@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129132058.GC2307128@ziepe.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Stat-Signature: 35hm66yc5x6ioak38etkn1bge7mzjye8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C8F220007
X-HE-Tag: 1769763097-872663
X-HE-Meta: U2FsdGVkX18yd57ecWU3ZcF6iqx/7EgKldSyvUN2z2VwqVsxY8+EcJiVbRmLwhnvGAp/EH93cTs/gUpWY46/umbzapyDkyJEBkZuigAMmvzvKa3UuTyC93QrtnhroNNnoOHptBsJjlPXn+r+uSckxs1/4iOdgWLo122+ChhnTh8HHgppVCo3Ybjt4z85uF4vD1wG5/7Uan+xzCXNkXKdJDitgrjG50uCjBPCOddyxOP5pm4UVIX/9DVdBTH6RPcsCUJ9665nIL3bwlzENfLc3LpBl2DIg4PD7Ilm92GB3MVuDjghA1Zk/I2EkydWraNdwK7sh7TS19v0b6vye6bTYSTTPK2q4A7u8PWMKwvTkM1HCLLsR80nl5dbpk5z+6+8spD7FQja68NIX0MamROuGloN1P+hz1hNdeueS63A1xQ2PayCfTKYpgZWTix6ZbBPjCitLzqPQCtEpBSmvoWM8KeMWHSA/tEWAoCMa9/C3EGyH3+vL4pp2px+moAtTwu8hnSdE6GFg2yyPIkIv+cYC3Sf0RwJ4+efg4gMGrZWK4jzLVpczww5hEZ6+sofPOJ2sLenP39TIYGAFm8H8+AZjytNwaHswba3zJIoIDWIcWhhNrhYfCVieK/E0hkh0NTJSMKaKArp4cTqE70S5ywdBGmdCt0gFQ1KSivHlzCzjUbLBpilbwJtO/ZiB2TCIiYxCEgJTejC+bQCLrrULP0hNFcxkSHi5ng+Khgxz7HVb27u+nMnvbuWEK1on3SU4/9O29QjX22zIei1LMXsKRHTqMnLycN8UiVQexR/dD+41xmP6drO3xZd4b7gWk2k/pPAbvBlrozcgGuIc6unm9ufWfx0ZRJzeBVmcTJRKlVNsBcVhd+sNsrIrJ+0eI+bJFKavphBKQguY6sU9OMvjUlvtC9O5mD7YRuWjPoqUXZq9zsUF3BD1i6JO/0Ed/t5/fMqgk4JOBuURC8p8L43fa/
 68dqgU+D
 vbBv0GzCmXqGL14Cy56vwKIU9clLmid/zEDiiwonC8YinYU0vjz3s2GEuNE//gOq+TqhESKqq6U7NQju01SuiSCDJWmBChQUFLaQhWjkgyBPuSElRySfgE1Y7dFuBWe5dR7fvTy7f3yoaJieq15cfM59NxUSMPNgVFcw3LAMI2sJrQbxuw1Qu6FRFT/HYkY/QyENbM26zZyktgpJCFk2LPKClIJPHoMUJ396QzwlQ6TL5uJ4FmC1brvJFFSisGP6B0VzXXcsN0MANziCOKXWBUivT1yddUKc8v+ZSNTm21CY4SkElJGO3YROKwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:20:58AM -0400, Jason Gunthorpe wrote:
> On Thu, Jan 29, 2026 at 07:36:09PM +0800, D. Wythe wrote:
> 
> > > From there you can check the resulting scatterlist and compute the
> > > page_size to pass to ib_map_mr_sg().
> 
> I should clarify this is done after DMA mapping the scatterlist. dma
> mapping can improve the page size.
> 
> And maybe the core code should be helping compute the MR's target page
> size for a scatterlist.. We already have code to do this in umem, and
> it is a pretty bit tricky considering the IOVA related rules.
>

Hi Jason,

After a deep dive into ib_umem_find_best_pgsz(), I have to say it is
much more subtle than it first appears. The IOVA-to-PA relative offset
rules, in particular, make it quite easy to get wrong.

While SMC could duplicate this logic, it is certainly not ideal for
maintenance. Are there any plans to refactor this into a generic RDMA
core helper—for instance, one that can determine the best page size
directly from an sg_table or scatterlist?

Best regards,
D. Wythe


