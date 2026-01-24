Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A3FAD715EE
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 14:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8895D6B05BF; Sat, 24 Jan 2026 09:58:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860856B05C0; Sat, 24 Jan 2026 09:58:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C8C6B05C1; Sat, 24 Jan 2026 09:58:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 662806B05BF
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 09:58:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCCA0140315
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 14:58:04 +0000 (UTC)
X-FDA: 84367162488.12.D6E0A32
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf15.hostedemail.com (Postfix) with ESMTP id 19D5FA0006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qLMQh7xd;
	spf=pass (imf15.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769266681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPWuCV8/90YbisajP7XufYM2YYkYUVDqVYcpinvbKXw=;
	b=HFeQtMWna5xA0RLXazdjl/uLXB6hyiHR4PqEFu93/4r+Pc96jxKJxhBGPjfgfkKue1mcnn
	33DZMqa7hzX96l2kR56YJer89LGbrlkHMQ/B3KciMRI/u5V4qI9D+hTfQXKgVH9nSIc9eJ
	B+qq8vL7WK9NHUd3/7Gn9Cuyet3F3DA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qLMQh7xd;
	spf=pass (imf15.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769266681; a=rsa-sha256;
	cv=none;
	b=m1KKJ0Yl0ihb3IsgNWHmhRbYgVaonjqA7mwfOcgBrICRdFsYLESIRjOxjFFDnktzpOoqA2
	e27u46/L7nCG3mfyrmbuNWn67EGQSgWNfBYlxrkRrgv0STKRnT9fi+sosfkV+w25aZGi4o
	C/Ph2YZ9Ja3q0fZhLQF44qU+nDa2NJE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769266676; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=CPWuCV8/90YbisajP7XufYM2YYkYUVDqVYcpinvbKXw=;
	b=qLMQh7xdIcdmuC4QVLXEsAR6u2W28NZEIu574FJuOTY6WkmSudQvNhw3iIGSyQ5pKjdjE3WFtPZqCszuv1Xd9cPMZc+2tKtlEJlR059mRXx1XzQt/z6vcy1nZoPbLa3jTAeuDKQCKAK09UxvwkYXHvboVDaYDpIKYuhqg+0T4Cs=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WxjCWVN_1769266674 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 24 Jan 2026 22:57:55 +0800
Date: Sat, 24 Jan 2026 22:57:54 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Uladzislau Rezki <urezki@gmail.com>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
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
Message-ID: <20260124145754.GA57116@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXSjm1DXm6yP62tD@pc636>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam12
X-Stat-Signature: i3w6m59hoxkrdqccnh6ejcc13qt8an4o
X-Rspamd-Queue-Id: 19D5FA0006
X-Rspam-User: 
X-HE-Tag: 1769266679-165434
X-HE-Meta: U2FsdGVkX19gLvA5F+gTPoDWn+mVW+MCUSPmdfHORsfg+vSYHi3SHfHMXhNmp5mazpBp8KTu0w0XXW6YonqHS1jSeUfKeBC3eHeV552QkvVAoSPkbyiLA2yiUOR3V1qAA8p4FourldW992ACV9cXez8wQD1lfdfqv9EolJytOXWpQWVXpug6BLa+4jFH/pEsTD1N4Dnc73mrO/DuNhPwlfxFgtLg5YyRleuo6ZiGXVz0OVTy7hUDIED0TKeyVb9/RGgu5ObySe5CKR2mSP0uzgi73ssL9N4lQHdB4GzLeAgXFWdML+Mr46+TVRhVcJYLAb+n3iYZbRbPNCVaR3q+IlOKUOfuoNL4lK/STsMcVsrNeAz6NjNQBb9njUlSd9MZ6VTftShNiD/wgb5I7QlcdDBBtOrPkM7GzVD7KSSI2z2uxmkrixVK5nn1trfcndhVjj1n/E2uHrCaA1i41/szT1LzEZYAqoJ5bPeMgigP8LZAmaOqS0IHz+fYDNJjhrmYWRrdCxETVQTa6bK3GApu7rxDbmSCGao9NcM3vDi5qsPAeTufRLmmPUq7+Y96Iom9OV6mZM8q+jVem3Ia3mPGLp6AzkS9fpLEPqBmTtYhMYoN6Fg4PNZunhZce7iuBsvGwd5epO4S+l/xSHcuEza4lQBM7VIP0H0AfHUDhQd9RUxd1Qxr1R56m3ZqxmPFz86wV9mUCzKSEWe1FkidknKo3yo8F+HQC0fENDNr21ZwaPakBHQCV3Oiytwv6xTXedJThj1TUmWEI4wwOXaY86Xg9CbwdyyDQIugYA2gBXJu14hH76KJ5oo0JjrOtjMF2AhoCkVA3gkEqajqlMt1gKVnCgaOhS2tphWfBDE9owxmx905oHnyWdIgf1QmKcscySZAZDg3yfcGK3C4FRLI/PbEq5WI72TjfyMLxxLLmkFMlOth0N9e+LU5cH2flJYO0fhhzW6rTcciWVhAAjqDKjf
 seXEb7AI
 9x2hse/fTWyEhCUWV2PZoWNRblvZrbpZung1N2K7e22e1kd799Bt9YF0LAWtNsH/aK/PQ06oiQi52d6guDJXX18GNnJ4CyBbCqfLaleKeaw4/UHA2XdlWVEWlOJCoBIrb60LFTOSvlxWnxAiWl6aLHEhUKQ2dgctrv0AIerxOBGzgeXHz9X7mWs8jAwXeXqXY19U8VnkH/usVoEOfPBL64WMnT8kO6E6PHJps3p6gM1dzcD7m6Edvxs8v41oZnfmR4I5Vcp7KNBGn/wQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> Hello, D. Wythe!
> 
> > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > virtual address. Export this symbol to modules so that modularized
> > > > subsystems can perform lookups on vmalloc addresses.
> > > > 
> > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > ---
> > > >  mm/vmalloc.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > >  
> > > >  	return va->vm;
> > > >  }
> > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > >  
> > > This is internal. We can not just export it.
> > > 
> > > --
> > > Uladzislau Rezki
> > 
> > Hi Uladzislau,
> > 
> > Thank you for the feedback. I agree that we should avoid exposing
> > internal implementation details like struct vm_struct to external
> > subsystems.
> > 
> > Following Christoph's suggestion, I'm planning to encapsulate the page
> > order lookup into a minimal helper instead:
> > 
> > unsigned int vmalloc_page_order(const void *addr){
> > 	struct vm_struct *vm;
> >  	vm = find_vm_area(addr);
> > 	return vm ? vm->page_order : 0;
> > }
> > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > 
> > Does this approach look reasonable to you? It would keep the vm_struct
> > layout private while satisfying the optimization needs of SMC.
> > 
> Could you please clarify why you need info about page_order? I have not
> looked at your second patch.
> 
> Thanks!
> 
> --
> Uladzislau Rezki

Hi Uladzislau,

This stems from optimizing memory registration in SMC-R. To provide the
RDMA hardware with direct access to memory buffers, we must register
them with the NIC. During this process, the hardware generates one MTT
entry for each physically contiguous block. Since these hardware entries
are a finite and scarce resource, and SMC currently defaults to a 4KB
registration granularity, a single 2MB buffer consumes 512 entries. In
high-concurrency scenarios, this inefficiency quickly exhausts NIC
resources and becomes a major bottleneck for system scalability.

To address this, we intend to use vmalloc_huge(). When it successfully
allocates high-order pages, the vmalloc area is backed by a sequence of
physically contiguous chunks (e.g., 2MB each). If we know this
page_order, we can register these larger physical blocks instead of
individual 4KB pages, reducing MTT consumption from 512 entries down to
1 for every 2MB of memory (with page_order == 9).

However, the result of vmalloc_huge() is currently opaque to the caller.
We cannot determine whether it successfully allocated huge pages or fell
back to 4KB pages based solely on the returned pointer. Therefore, we
need a helper function to query the actual page order, enabling SMC-R to
adapt its registration logic to the underlying physical layout.

I hope this clarifies our design motivation!

Best regards,
D. Wythe





