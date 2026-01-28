Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FB7D3566F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 03:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B75F6B0088; Tue, 27 Jan 2026 22:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3658B6B0089; Tue, 27 Jan 2026 22:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247186B008A; Tue, 27 Jan 2026 22:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11EA36B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 22:46:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 950E18B99A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:46:05 +0000 (UTC)
X-FDA: 84379984290.02.E41BE4A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id B985CC000A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:46:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YcqbkRo7;
	spf=pass (imf28.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769571964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmaKvabuMBlglXK1NBRq+El3BuZIg9w3LA15cprF3JU=;
	b=w3Ylnd6FubjrBdEGMByNgb+JAFaWa4B8y/VCxgEa5EIcU1Hgq6i0sEOtrCYmRuWmfGPDhM
	u7jsNOLxFtQGY//tQTlbBeKLxQ+Xn2SxepU9tsVz7b2fmw6wYs9u+NcL3Y2nZY64kLseSv
	vnST8sxvQFD1WnS9bty/FR9k5ZGH2cQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YcqbkRo7;
	spf=pass (imf28.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769571964; a=rsa-sha256;
	cv=none;
	b=MdYDz4wVQZePX7Kb4I2X/yALDe7NtbFTKus97mTPgRQ5eCntXWDuqde8dQPnP8Wdd4MKEo
	oPmZ3sC9wPWVE6kbn4l4Cn00vpHCzS+vcmc+vj7MdZyii5+UYLbG9+K0WmB7/162jl2DNo
	O9vI0F58tHhof0uM0v9Qw6iGWeNALFc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769571960; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=UmaKvabuMBlglXK1NBRq+El3BuZIg9w3LA15cprF3JU=;
	b=YcqbkRo7Yn1jeJLDVC1xz4k54O4tzoZr/UXnsso+glWkMUWUGqPLJd1iCe+K41f5u2Ks8CHfcBIzrZG3JAgIWwCmzb2ZM1UuFt3DQbMKAF4pTlxinVZtdYK5L0pWRflWnDYvMYEzDkby4e4qOvR1AMbpeUhR4pi2srwbe9OJfG4=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wy20ywq_1769571958 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Jan 2026 11:45:58 +0800
Date: Wed, 28 Jan 2026 11:45:58 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Leon Romanovsky <leon@kernel.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>,
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
Message-ID: <20260128034558.GA126415@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127133417.GU13967@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Stat-Signature: 9h5788a41jp98o3qacmo391dowfaui71
X-Rspamd-Queue-Id: B985CC000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769571962-322404
X-HE-Meta: U2FsdGVkX19Fi6/mfZNIY7zLEuVLWWwq/NUlNTjgQby3nOWegGCrF9vkMy2YbCaqNOjCWc8sleX8El3I2dtRsna47R+b+CLZp1savVWPbOIN5I0YXAAdW/DxVWAT0lqgWM6lBfE5/dYr7H3XxE/dUTKg6c1wmxaeJ+Ho4hdt816PdUNVTl1uDBEPQ0jwUP9k0HwVYYxi5cFBXOa43XGzIXRcu+sLC14fEa/2ij6siDOFqs/XupUe9mEvyZXGHSOdyoMiEYLW7LKhn/FPgUS+6OCTGnBLydV3TR7oLQUalle3Qb5aSaE//oMLefR3JEhmSkLWIU6m+JhJZsO6H7Sl4hhQ+Aum2dyuQOBzGK1p6ePldzd+6ZkKqX8pFrZOYrz3fT2V0YiD9hhx+0FMEA8xDgMbPAM9rPVkT4kDZhbUWZs6oW7w3KEWuPPeEN5dCdAYrK0NVdB8lKaAmBsZGdaS4d8yUYTewIGwikyG5PFXpaAud9mfZVFUnELr2rtEGOC1b93GnroP0Hm3iJZpmzHHM5XFmQS2af0faKaNKAg+sXbL0IqJGslMtcxEewmCplVV08mQOQJJmAgHQFkBf/gFsBv0uDpL6OIXYYYINzJbOf2/8myHhPfg9rtvFNkSFhe4RiGd8YSnD6ymAfqz6PgivNJfeyKI+YyPrEQbq0aa3seJpm7Mk3/pjjPtzXHw1dNF03/iPfgS/+YF8Eim7GlS2h1TPNjk/vxtKF/yTl4hkAE1J2ipUzHd/wE0IJsxWoASL4xjbuOXGd6r3E3RZqleYm2L/OWmtvzomZosu+O3h64MIsnSvIABHJwA8WcFYL1eSEEHV78VI1MxoUoKg7w3Nrz/GenHlpdDJcsxGBNOkL7MqMHVaHavBOPIxXBwnL64Yg+/L3iaSkvrXD8nAbDAvc8q87ZSwtSBLtCmeJ2x4LZL8+t/BDOTkYiHA2dEL+aZupQAZDhSQRgzUaICwmk
 NY5an0N1
 L2nU0tomapyjuVt9iD3w767JpFfFD/4wPUyr6An8R7Rn+2IoQPDAJQNfe64YS73noMHiJ+eX6rZrw9lVTUiRXOLcjoCJaryOr7HurN78Jh/7hYox8D2Q87f368AnD2XB3WdgLe5kEchP5IQXJrU+dtUM1hdR7ctCU1WQDZEahUQEAODhne+0CRLl3rWQn5vFYfhMjcsINrq6Ig07bgvBxv5fCLsAQ9Z4gDHAIyfeF7AIuF+x5OKncoz91YOA3B9FAVw7edOJuerL0vPi2+Jc0UI73ViaJY2wkcbFvuHJcan2OfMzA4bkEoAxPmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > Hello, D. Wythe!
> > > 
> > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > 
> > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > ---
> > > > > >  mm/vmalloc.c | 1 +
> > > > > >  1 file changed, 1 insertion(+)
> > > > > > 
> > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > --- a/mm/vmalloc.c
> > > > > > +++ b/mm/vmalloc.c
> > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > >  
> > > > > >  	return va->vm;
> > > > > >  }
> > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > >  
> > > > > This is internal. We can not just export it.
> > > > > 
> > > > > --
> > > > > Uladzislau Rezki
> > > > 
> > > > Hi Uladzislau,
> > > > 
> > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > internal implementation details like struct vm_struct to external
> > > > subsystems.
> > > > 
> > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > order lookup into a minimal helper instead:
> > > > 
> > > > unsigned int vmalloc_page_order(const void *addr){
> > > > 	struct vm_struct *vm;
> > > >  	vm = find_vm_area(addr);
> > > > 	return vm ? vm->page_order : 0;
> > > > }
> > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > 
> > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > layout private while satisfying the optimization needs of SMC.
> > > > 
> > > Could you please clarify why you need info about page_order? I have not
> > > looked at your second patch.
> > > 
> > > Thanks!
> > > 
> > > --
> > > Uladzislau Rezki
> > 
> > Hi Uladzislau,
> > 
> > This stems from optimizing memory registration in SMC-R. To provide the
> > RDMA hardware with direct access to memory buffers, we must register
> > them with the NIC. During this process, the hardware generates one MTT
> > entry for each physically contiguous block. Since these hardware entries
> > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > registration granularity, a single 2MB buffer consumes 512 entries. In
> > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > resources and becomes a major bottleneck for system scalability.
> 
> I believe this complexity can be avoided by using the RDMA MR pool API,
> as other ULPs do, for example NVMe.
> 
> Thanks
> 

Hi Leon,

Am I correct in assuming you are suggesting mr_pool to limit the number
of MRs as a way to cap MTTE consumption?

However, our goal is to maximize the total registered memory within
the MTTE limits rather than to cap it. In SMC-R, each connection
occupies a configurable, fixed-size registered buffer; consequently,
the more memory we can register, the more concurrent connections
we can support.

By leveraging vmalloc_huge() and the proposed helper to increase the
page_size in ib_map_mr_sg(), each MTTE covers a much larger contiguous
physical block. This significantly reduces the total number of entries
required to map the same amount of memory, allowing us to serve more
connections under the same hardware constraints

D. Wythe

