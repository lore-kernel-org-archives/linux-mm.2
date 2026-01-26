Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F050CF65E5
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AE06B0089; Mon, 26 Jan 2026 07:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40F16B008A; Mon, 26 Jan 2026 07:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A848A6B008C; Mon, 26 Jan 2026 07:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A27A6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:02:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CBFD59E74
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:02:34 +0000 (UTC)
X-FDA: 84373977828.30.49FBDB9
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3CA07100019
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:02:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TP537WGH;
	spf=pass (imf14.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769428952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hc/TS0tY4HUOfWDij4WQGV+0xonDLwbrony8b89dCv8=;
	b=Nk7cFY94X+Xft9EVuvZow0ix5VWGS9DZTnOmaX/ifh7vV1LcFMPMv+BISmVAgDoTs7zupG
	4OYi6d00h95P+kgPrSdAQOPQneqNRyqsnox3aI7tHBXXz5rkw27b1SMInX8bPsh3VDIbJO
	xl9IAmPSWf3tXkxrIlPMso2aOj/1jWo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TP537WGH;
	spf=pass (imf14.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769428952; a=rsa-sha256;
	cv=none;
	b=FNTcw2BsANXLw9nfzjtma1rMHEpo3VIyjVOV6OY2WOmC/hpA7pHQ4cELvWx/uuvmDn7NLi
	aE6z8tVjdp60pqgj4Op7eujPiBsHHC7YH8ub+8Gaxr2NSLLngc2+h0LCnp6AmFPa7onfaD
	D4ig7v6THGrthEp9OpALRzO19vhKr0s=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769428948; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=Hc/TS0tY4HUOfWDij4WQGV+0xonDLwbrony8b89dCv8=;
	b=TP537WGHKgfiEp4q2LVzSJ7vm3bYbLLMT+arCYhpm28nmkVh//wEVoUgT9vUM6WZ9tsbRrzozET3SCE3+NUQzsKMMd/qtfrZzeTHvJ8VyPZvMqUmfAChi2NBKNIgNDXEVadokvxe5R/FMYOJqdq9Odxuk7rsSlrIu6fYtseg8a8=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxu-mhe_1769428946 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Jan 2026 20:02:26 +0800
Date: Mon, 26 Jan 2026 20:02:26 +0800
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
Message-ID: <20260126120226.GA6424@j66a10360.sqa.eu95>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <aXdB3lsm3w0fJT3Q@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXdB3lsm3w0fJT3Q@milan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam11
X-Stat-Signature: yrprdisfatxpy8kug4t8974ciuot7cmg
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CA07100019
X-HE-Tag: 1769428950-410494
X-HE-Meta: U2FsdGVkX1/BFQZaW3vaCsHHZJhC9ewlIL/OkV3O7IqNdbqF4rvjuxawoTxJIdR3y5cV5bnHvriAo2+oLR0J8vFzsrktk0DmkxlJYgsPb5cGoQRfj0OEi7CBSjEZ/MVGhFEwYajl6nWUVU+Q0OK+C+QVdOx0ug1MRtwlrPpmYQ7PVtGJeIIlmHch8isICd/7TBkSveGluw79cP1p//Xq8zZScsUS43275t1p96+ZnKobNoGgkghD6/oaDI+PdhIX+rAhy2HMwWHDq2xxURctA/AaWAVzUj6lysDu1Z3l3uJGxpec6YJxGUy4jBiioSQKorUewieZxkJ8Pwy2DaU3EX68MvEKuLc/wDgVx859cbR8F7XOY1bnndAFPWJsjE2Bp7LtS1LObMxhsnQC6yi/B0Her2ZnW+iqdHCjU0l2cOXOh/mrKfEu8TYE5TQfbS0kR/QpjepQZvCDskmPGzIikjELF6XreeBNvH2iJD9B7/YIOVmPfMtPz8bi+KOzlGE8aEO4i0UMKZ8Ty9zNvITzBGrsccykNgf33scb4HpDcrECDdZkzWT+sHbx+F84MoNakUbvb0/f9NFCPGNILN7AdI7aPZmG9wmZaoo3gwnfUrzjz4xepo1D4HnPaTGSoYT2lCrbs09bHs7tO61CNke6JadNWOzIa7WISnObWBQS9XNNXOQiGOrfulDWmP9F6cDS5A8ouDeO5lQHX7iiyE0J4GG3kDpiL/5432Kgm+YQ4Qos7+yIVY2BoLh9Hwx12uYoA1lp2oL9LeFjQCJF3yYPU6jGM/M1Z7xu8PsvGa+Swti78ZQDK6QGJ6cYdbO0EaGXhmWRW/IUu+wwP9jjQjv2oKW4hDPzvYBG6Fo6Eio8lI2NhWUs+yafjcSixrkuvsR2IIRE1f3ESIqvllvXydvcGu6H/VGDQX6Jx87Mfgu/9jKDVXZlajG6tuLrWyjEfCdGBbZuTcjCIvsb2HCAok/
 hG3ldNvz
 d03RScwSCoTXruE+iZ3ZQFPXQmXzIiY71nB7w7HvWa6R/6Rk6fFEFGkle4oZmkDYvXSuN9jcP8FWyD6Daze6L63763tnpCuJPJRpK1Cx3sLtgnq6r61kkvq6lAbxWNmcXUspWJgJQ/HIQ3+9hvM5K5MZHxdfolEEjboIm6Ko40woMxfwVNE/6qmLeLeaZmEvWVxVMUolI8WzAbHHUipmvIW0mnRXl02ymSFRqdnZ359oy24bwaFjEoZs0lptMYbSgHenNvGR576L0+Fs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 11:28:46AM +0100, Uladzislau Rezki wrote:
> Hello, D. Wythe!
> 
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
> > 
> > To address this, we intend to use vmalloc_huge(). When it successfully
> > allocates high-order pages, the vmalloc area is backed by a sequence of
> > physically contiguous chunks (e.g., 2MB each). If we know this
> > page_order, we can register these larger physical blocks instead of
> > individual 4KB pages, reducing MTT consumption from 512 entries down to
> > 1 for every 2MB of memory (with page_order == 9).
> > 
> > However, the result of vmalloc_huge() is currently opaque to the caller.
> > We cannot determine whether it successfully allocated huge pages or fell
> > back to 4KB pages based solely on the returned pointer. Therefore, we
> > need a helper function to query the actual page order, enabling SMC-R to
> > adapt its registration logic to the underlying physical layout.
> > 
> > I hope this clarifies our design motivation!
> > 
> Appreciate for the explanation. Yes it clarifies an intention.
> 
> As for proposed patch above:
> 
> - A page_order is available if CONFIG_HAVE_ARCH_HUGE_VMALLOC is defined;
> - It makes sense to get a node, grab a spin-lock and find VM, save
>   page_order and release the lock.
> 
> You can have a look at the vmalloc_dump_obj(void *object) function.
> We try-spinlock there whereas you need just spin-lock. But the idea
> is the same.
> 
> --
> Uladzislau Rezki

Hi Uladzislau,

Thanks very much for the detailed guidance, especially on the correct
locking pattern. This is extremely helpful.I will follow it and send
a v2 patch series with the new helper implemented in mm/vmalloc.c.

Thanks again for your support.

Best regards,
D. Wythe



