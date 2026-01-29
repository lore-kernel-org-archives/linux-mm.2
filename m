Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A495DD6100C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 12:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860CC6B0088; Thu, 29 Jan 2026 07:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838836B0089; Thu, 29 Jan 2026 07:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744446B008A; Thu, 29 Jan 2026 07:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6680F6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:22:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0752E1A0220
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:22:12 +0000 (UTC)
X-FDA: 84384913704.14.6C373E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 59584C0003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:22:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XztRNY84;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769689330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh1cp5MZd9weWPg43KyYIt/vK0mobwQtnuR43/F/UM8=;
	b=rdSOBvpyJNtxXUfcpE4uArRiFcNN6cOxf9/dGhHaxhKBfytlfAnW2DXTACoRN4hlz3uRFR
	kLRtvLblGjvdNdClpa4vanPcxM9i3erGFl/edyRwcFvTJvNVKebX0LJrtoZ9G8Rd4XudNk
	PKXykL7iHlnNBPW+Ju0GG1Nj2G6qlQk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XztRNY84;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769689330; a=rsa-sha256;
	cv=none;
	b=SJe1b/xlKXDjqRURLYGE2kpb1F61MepbiUxBsg38vyrvBY26AG1OlZFgDgJuPEwzJByTqO
	TDWywz/duyOO/t64BhCq2m8ZFA6QKzP0bkAuAR+7d7GOIub2K70IrZ3fOMWu9bxADI7Vlh
	c+sH7uh5fBEmjMomGPyRuyDJr74gWo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BBDB36001A;
	Thu, 29 Jan 2026 12:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C4EC116D0;
	Thu, 29 Jan 2026 12:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769689329;
	bh=u0mH2caXTtzlMetoMGj0YZL3OyKWg4rqxepJQNCPAH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XztRNY842nKIzlwsrZ2zmz2O2SC5CuFYr0PFbxneGq54Q9YEkUGZqhjUouXUqn7WY
	 gu1u0BgbBqV0y/KKINI7F5mpGY23/Z1wyz0AX6gqB3PYmrqkLLFGGS4EnkK8LzItWL
	 11f6uCX/vWjK70v646N607UAo/vVw126ju602qaPhWROGFWFzHGliwwbe0bGkyN8bU
	 Acd+AAyS3ayDZvQUmfewqIGTfM3AH37KGvXYDyYWxYbz2g9I/rDMZC0+UWoqpqCDFw
	 Lxxyi+CZsOVT6AaieoFJ0pwzNkpS0FTPF5Y/yE+6lVAbtyKypL1z5/miAPJQBjjHOe
	 sMX7/pXFwwB7Q==
Date: Thu, 29 Jan 2026 14:22:02 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <20260129122202.GF10992@unreal>
References: <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128111346.GD12149@unreal>
 <20260128124404.GA96868@j66a10360.sqa.eu95>
 <20260128134934.GD40916@unreal>
 <20260129110323.GA80118@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129110323.GA80118@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 59584C0003
X-Stat-Signature: 6ur7b4yopb49k3ssh56if5rpnartmd6d
X-Rspam-User: 
X-HE-Tag: 1769689330-656099
X-HE-Meta: U2FsdGVkX19VwGAhXL+HjgGPb9QYg5HOEAL/FPt9prxuv+BWrFjlNmaMw87pxsxsJrUHbvO+boXhDWDADzIp0j2i57KYP+SQnVWq5kI5Umm8pUqJhqx3ICccAXe1Ri/pAO6G9vkscUD8EapVkLJ9Oqaqv9dvoPnSoEy+UuJWtih1UiUBO8afRvhO3MkADYuWPtN6pZP9aTupT3qnRK/NqlTFABqJM32iRg9qUkvYWdUJmBYeHqQ1pLJnQlzc7AHGxJHbu86FKGSWlwiPX8MXQEbh2KvLrVUg1lpxuKtSdX97VYt7EwNFrjtt5esvcWjRxfNnHHojb7JlmI1VoncD6HyLTmCOka5RTdxKm+HW943ANpwXzdCoDda1MNAeryVNKQCqj/JDo4j5ipK94p4C4N/IIsXk8IPVUw8cFfoANjtgR4J21p7t4m4YUWA3JfjW8iA53fxbhKbTeRNDsq/FPyhAUWe8Km9BB1YCj1HLWPDj1miVVebUs1Xnqi2EVSn3bF8ALRzP1ZBwKFyJlms5zDNqmtWUG3LFnB7oCPBnazgN/lQlWkJXoK6GTzmZAkcWSwrW//EcS9j13qMbJOeyoVlRC9mmesVJKeG/SXXWtrYtCRlX+gAJ/hyaYnwzflnKxfQ0QVefs0NXrgTHnadCfHQteOWoClQFvVHZrCrqslUlSHZ7dtnmd4wDQZEp6xSTl/k4vnD/+7gmm4JwFF5deMWlqeb0UHMGjSatTxn5NOfpZ4ZlaDnVp7RrMdl0Of9876ednIqYgSvVsv7b0zFcbxhJaUVODrbO36biuUmSC/pJL5jxgc8ejXg9vO+lNDtvUeVhxsX5fWJn+bXhJdfrxiZ+sTi+V1mkVkKTF71GUTco7rAAMrASJ+fBCuepK0z/JbSwEVIsIjiNKyxf8q9k5E2YHN1OOLay/QsNxTcr6CLpPW/G6npvgQrmt8StFWqdunlScFqoRVy0zQKfQ1n
 SXzlJ8Bn
 lDmDjaZnRC+U7Ja70k4SZYwaxcXGeqOdIyCxjTRSwO8vA6dlpVznwm1QQzkuLwYSPhN5mGMnyDDtvzYDbQTF7PMF5KdydpusLG6oo3V1B3CpFp76AoZBelKoXOD3AIsDutah6OWBiNy0HnSCyATgWm//84sminhdVV58kFZdAMD6ncoaaD0Lin58PWE8DLDLNkDi/rBx4k069lVejOAkDX8/ZhZqLllETojvU+qsYykOuY4I47RaEPugdihfjGWHsERTOYPBAJ9J1A2gMef2/37BEiaw3SSWPXHQNuQYW++LgepPf1gPgUBv2KiPpXVEPYJFFXJeHX4u77qjpv91yWPDki1RXJHO9gt9MfrAjSAs9siZKSPQjGQThKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 07:03:23PM +0800, D. Wythe wrote:
> On Wed, Jan 28, 2026 at 03:49:34PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 28, 2026 at 08:44:04PM +0800, D. Wythe wrote:
> > > On Wed, Jan 28, 2026 at 01:13:46PM +0200, Leon Romanovsky wrote:
> > > > On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> > > > > On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > > > > > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > > > > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > > > > > Hello, D. Wythe!
> > > > > > > > 
> > > > > > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > > > > > 
> > > > > > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > > > > > ---
> > > > > > > > > > >  mm/vmalloc.c | 1 +
> > > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > > 
> > > > > > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > > > > > --- a/mm/vmalloc.c
> > > > > > > > > > > +++ b/mm/vmalloc.c
> > > > > > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > > > > > >  
> > > > > > > > > > >  	return va->vm;
> > > > > > > > > > >  }
> > > > > > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > > > > > >  
> > > > > > > > > > This is internal. We can not just export it.
> > > > > > > > > > 
> > > > > > > > > > --
> > > > > > > > > > Uladzislau Rezki
> > > > > > > > > 
> > > > > > > > > Hi Uladzislau,
> > > > > > > > > 
> > > > > > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > > > > > internal implementation details like struct vm_struct to external
> > > > > > > > > subsystems.
> > > > > > > > > 
> > > > > > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > > > > > order lookup into a minimal helper instead:
> > > > > > > > > 
> > > > > > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > > > > > 	struct vm_struct *vm;
> > > > > > > > >  	vm = find_vm_area(addr);
> > > > > > > > > 	return vm ? vm->page_order : 0;
> > > > > > > > > }
> > > > > > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > > > > > 
> > > > > > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > > > > > layout private while satisfying the optimization needs of SMC.
> > > > > > > > > 
> > > > > > > > Could you please clarify why you need info about page_order? I have not
> > > > > > > > looked at your second patch.
> > > > > > > > 
> > > > > > > > Thanks!
> > > > > > > > 
> > > > > > > > --
> > > > > > > > Uladzislau Rezki
> > > > > > > 
> > > > > > > Hi Uladzislau,
> > > > > > > 
> > > > > > > This stems from optimizing memory registration in SMC-R. To provide the
> > > > > > > RDMA hardware with direct access to memory buffers, we must register
> > > > > > > them with the NIC. During this process, the hardware generates one MTT
> > > > > > > entry for each physically contiguous block. Since these hardware entries
> > > > > > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > > > > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > > > > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > > > > > resources and becomes a major bottleneck for system scalability.
> > > > > > 
> > > > > > I believe this complexity can be avoided by using the RDMA MR pool API,
> > > > > > as other ULPs do, for example NVMe.
> > > > > > 
> > > > > > Thanks
> > > > > > 
> > > > > 
> > > > > Hi Leon,
> > > > > 
> > > > > Am I correct in assuming you are suggesting mr_pool to limit the number
> > > > > of MRs as a way to cap MTTE consumption?
> > > > 
> > > > I don't see this a limit, but something that is considered standard
> > > > practice to reduce MTT consumption.
> > > > 
> > > > > 
> > > > > However, our goal is to maximize the total registered memory within
> > > > > the MTTE limits rather than to cap it. In SMC-R, each connection
> > > > > occupies a configurable, fixed-size registered buffer; consequently,
> > > > > the more memory we can register, the more concurrent connections
> > > > > we can support.
> > > > 
> > > > It is not cap, but more efficient use of existing resources.
> > > 
> > > Got it. While MRs pool might be more standard practice, but it doesn't
> > > address our specific bottleneck. In fact, smc already has its own internal
> > > MR reuse; our core issue remains reducing MTTE consumption by increasing the
> > > registration granularity to maximize the memory size mapped per MTT entry.
> > 
> > And this is something MR pools can handle as well. We are going in circles,
> > so let's summarize.
> 
> I believe some points need to be thoroughly clarified here:
> 
> > 
> > I see SMC‑R as one of the RDMA ULPs, and it should ideally rely on the
> > existing ULP API used by NVMe, NFS, and others, rather than maintaining its
> > own internal logic.
> 
> SMC is not opposed to adopting newer RDMA interfaces; in fact, I have
> already planned a gradual migration to the updated RDMA APIs. We are
> currently in the process of adapting to ib_cqe, for instance. As long as
> functionality remains intact, there is no reason to oppose changes that
> reduce maintenance overhead or provide additional gains, but such a
> transition takes time.
> 
> > 
> > I also do not know whether vmalloc_page_order() is an appropriate solution;
> > I only want to show that we can probably achieve the same result without
> > introducing a new function.
> 
> Regarding the specific issue under discussion, I believe the newer RDMA
> APIs you mentioned do not solve my problem, at least for now. My
> understanding is that regardless of how MRs are pooled, the core
> requirement is to increase the page_size parameter in ib_map_mr_sg to
> maximize the physical size mapped per MTTE. From the code I have
> examined, I see no evidence of these new APIs utilizing values other
> than 4KB.
> 
> Of course, I believe that regardless of whether this issue
> currently exists, it is something the RDMA community can resolve.
> However, as I mentioned, adapting to new API takes time. Before a
> complete transition is achieved, we need to allow for some necessary
> updates to SMC.

I disagree with that statement.

SMC‑R has a long history of re‑implementing existing RDMA ULP APIs, and
not always correctly.

https://lore.kernel.org/netdev/20170510072627.12060-1-hch@lst.de/
https://lore.kernel.org/netdev/20241105112313.GE311159@unreal/#t

Thanks

> 
> Thanks
> 

