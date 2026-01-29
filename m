Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D26D358F6
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E36F6B0088; Thu, 29 Jan 2026 06:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791C36B0089; Thu, 29 Jan 2026 06:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6728E6B008A; Thu, 29 Jan 2026 06:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55BDB6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:03:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B2E68C8E0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:03:32 +0000 (UTC)
X-FDA: 84384715464.05.A8F2B40
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8B1E1100008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:03:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ry+BXsuH;
	spf=pass (imf14.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769684610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DelJ78oXDrf5D0hOyeRyjgDAeKvn8heincO0PqIPRF8=;
	b=FWSurT3mVKhj4e1LpDUcCWMGmZwSKghhuinIj7GZVUDc0HUv8cdW5nKKCEl5reNmoXoS/h
	2dEBGgnhLmUKu6SP6junvZZT5PFMbGRkSDGCUq/zsnwlRU+2ze93pTuoXf6Ele+Z0/ezW0
	NljhfHzxoEk6It9B0qzwqYBHTr4SpZs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ry+BXsuH;
	spf=pass (imf14.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769684610; a=rsa-sha256;
	cv=none;
	b=wHpYS0lPfCPQpKEC+LJrYGNykUcR0B/uiN68l5jgzxzekLzb+0fiYluuKd8IDqmoGTH4Sd
	wWHsb78MKIfqeXj4402YeY7vA0sVZg8DAhfi9/I/dPNiRtWprkE2KT97RXgTG8/C0x9tiv
	5KVSkgUhXNT1iwGPoM1VVGhpovezhB0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769684605; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DelJ78oXDrf5D0hOyeRyjgDAeKvn8heincO0PqIPRF8=;
	b=Ry+BXsuHmYRB2FRSIlwCb/KEQZ5onX4ShMmYm+cWvHGXosr2LNGpMChwCaaLZNpDuqerqxhJxgDcEjz3+XeQfR0eVjX5GNzqViE5oh/br4XosjNqyrV3/YFcm6d4IjU1XyUbBIW7ku7HifyNN3vfeUXVcY/nusAZhzPRcvQLbi4=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wy7BXL7_1769684603 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 19:03:23 +0800
Date: Thu, 29 Jan 2026 19:03:23 +0800
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
Message-ID: <20260129110323.GA80118@j66a10360.sqa.eu95>
References: <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128111346.GD12149@unreal>
 <20260128124404.GA96868@j66a10360.sqa.eu95>
 <20260128134934.GD40916@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260128134934.GD40916@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B1E1100008
X-Stat-Signature: zjii5cpnqgqm4wge3yjttgi4sy7ocfje
X-Rspam-User: 
X-HE-Tag: 1769684608-900913
X-HE-Meta: U2FsdGVkX18xkNvw4x51Flm3gNIiJwogHGpH+/kwoFrG/5p50wYp/Q80msd3KEL8rgMcVsD9EAuhI5pTJSpUKRLZDTTFmaW8FZPou1FmphbU4N5+pFFr/xDaXL8jk0DYmqePzDPlduJMZEhcZBSzD2Wi7c8PUQZL6Xp24npgPhSqxGzkScX6hMiOkbevG2m10AsvJ2LfbCse5tIv7C142zy8/OI4w1asA8mUDThO59Dpppo0GyUTxPP+PcjgyTM7+qdrOno6o+Yawd5FoGcpCgfiCLWmX8lEMfvman/nXe1mvAe6EuzMcuAMtuwWnR3g/LvHHKLHzOyV6u0JfQhGYR2VjKJwPqHldXvBe8TMJEoNtQuarIskiWMRJSjBhmMeBbQvtvPDILVifrimdtPqhDtO2xBLGYuU6FVnfl7WvhrJnmyeyLD2YO7o5o7/i6qA8emoCcQxu1QvdIQ6jOmpsnUgROH3KghUdEphhgW/Wfa79wonmyor4B9eicW7/mWLGSzwZYyKzBrOQiUdVoOl0RKCYXrQGkTWpS3MZusbszv2pT0BT2wvQ7BJ+WMsCtyWA5ZJIznnhSQXvy/p9qbFMe1Hao4I3osU2H9iuX7GcA5Io4WjdjIeOl8zC5rRPs2wM8JlwQUPiRFxqapHRB3zo2PyNXwpc36t59bp7jbPCpbcHjdbenWHOsfJUR+7xQ1Rnl3QN2VVgigYv+Ql2YJ4C/N+SqQ1aiFnUdMT3qEl0iG6YD0HjZleV7AnhrXkk4CFPWVhitOuSzoYVgB4e3QQat5NPARgtdqTmR3ZkjtJB6f/a6sQjO73VlzEVjCY9zhrxhfc1iDzC9855YscxlQKI32fkm5EFytGMv67RvhkFi64TzcEPegyFfArG4ChrHqhTAq4H1cz1NNA4MsqsaNFUkMk+++1KXJ0lLyCD2JX/emYwFmdKH1e53Jh9wp4CCFIbyDnEk5NOd6HzSkC2PE
 oNiEOGOc
 MouQn5S/atglOac4BajoSA2Rhv/ujwE8y40pwMvKsEWYmQrJAcxv6Zzi82GCcZDW10ET0N/HVGnVg8CbKlqNA13GQwc4T1w87cdtIplzY3cFALKqEVSNCGa1TJs1iuRmk2tWzoGsHWjsmVzpG+JcKiP2wQ3Bbj3+QP9/7kdVTun3yHtajL2ZJ6af43aXPfQmX1oYCx/8Dpb5RtgLPQlWMotBinJoD8F1Z2zGz8EzZguEzbPNd2ttrqMx3xu1DMwX0Tcb2gT3guI+gBF93rtY84AoVWFwhrDu2p5AIedhF3CtYV/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 03:49:34PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 28, 2026 at 08:44:04PM +0800, D. Wythe wrote:
> > On Wed, Jan 28, 2026 at 01:13:46PM +0200, Leon Romanovsky wrote:
> > > On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> > > > On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > > > > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > > > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > > > > Hello, D. Wythe!
> > > > > > > 
> > > > > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > > > > ---
> > > > > > > > > >  mm/vmalloc.c | 1 +
> > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > > > > --- a/mm/vmalloc.c
> > > > > > > > > > +++ b/mm/vmalloc.c
> > > > > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > > > > >  
> > > > > > > > > >  	return va->vm;
> > > > > > > > > >  }
> > > > > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > > > > >  
> > > > > > > > > This is internal. We can not just export it.
> > > > > > > > > 
> > > > > > > > > --
> > > > > > > > > Uladzislau Rezki
> > > > > > > > 
> > > > > > > > Hi Uladzislau,
> > > > > > > > 
> > > > > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > > > > internal implementation details like struct vm_struct to external
> > > > > > > > subsystems.
> > > > > > > > 
> > > > > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > > > > order lookup into a minimal helper instead:
> > > > > > > > 
> > > > > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > > > > 	struct vm_struct *vm;
> > > > > > > >  	vm = find_vm_area(addr);
> > > > > > > > 	return vm ? vm->page_order : 0;
> > > > > > > > }
> > > > > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > > > > 
> > > > > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > > > > layout private while satisfying the optimization needs of SMC.
> > > > > > > > 
> > > > > > > Could you please clarify why you need info about page_order? I have not
> > > > > > > looked at your second patch.
> > > > > > > 
> > > > > > > Thanks!
> > > > > > > 
> > > > > > > --
> > > > > > > Uladzislau Rezki
> > > > > > 
> > > > > > Hi Uladzislau,
> > > > > > 
> > > > > > This stems from optimizing memory registration in SMC-R. To provide the
> > > > > > RDMA hardware with direct access to memory buffers, we must register
> > > > > > them with the NIC. During this process, the hardware generates one MTT
> > > > > > entry for each physically contiguous block. Since these hardware entries
> > > > > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > > > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > > > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > > > > resources and becomes a major bottleneck for system scalability.
> > > > > 
> > > > > I believe this complexity can be avoided by using the RDMA MR pool API,
> > > > > as other ULPs do, for example NVMe.
> > > > > 
> > > > > Thanks
> > > > > 
> > > > 
> > > > Hi Leon,
> > > > 
> > > > Am I correct in assuming you are suggesting mr_pool to limit the number
> > > > of MRs as a way to cap MTTE consumption?
> > > 
> > > I don't see this a limit, but something that is considered standard
> > > practice to reduce MTT consumption.
> > > 
> > > > 
> > > > However, our goal is to maximize the total registered memory within
> > > > the MTTE limits rather than to cap it. In SMC-R, each connection
> > > > occupies a configurable, fixed-size registered buffer; consequently,
> > > > the more memory we can register, the more concurrent connections
> > > > we can support.
> > > 
> > > It is not cap, but more efficient use of existing resources.
> > 
> > Got it. While MRs pool might be more standard practice, but it doesn't
> > address our specific bottleneck. In fact, smc already has its own internal
> > MR reuse; our core issue remains reducing MTTE consumption by increasing the
> > registration granularity to maximize the memory size mapped per MTT entry.
> 
> And this is something MR pools can handle as well. We are going in circles,
> so let's summarize.

I believe some points need to be thoroughly clarified here:

> 
> I see SMC‑R as one of the RDMA ULPs, and it should ideally rely on the
> existing ULP API used by NVMe, NFS, and others, rather than maintaining its
> own internal logic.

SMC is not opposed to adopting newer RDMA interfaces; in fact, I have
already planned a gradual migration to the updated RDMA APIs. We are
currently in the process of adapting to ib_cqe, for instance. As long as
functionality remains intact, there is no reason to oppose changes that
reduce maintenance overhead or provide additional gains, but such a
transition takes time.

> 
> I also do not know whether vmalloc_page_order() is an appropriate solution;
> I only want to show that we can probably achieve the same result without
> introducing a new function.

Regarding the specific issue under discussion, I believe the newer RDMA
APIs you mentioned do not solve my problem, at least for now. My
understanding is that regardless of how MRs are pooled, the core
requirement is to increase the page_size parameter in ib_map_mr_sg to
maximize the physical size mapped per MTTE. From the code I have
examined, I see no evidence of these new APIs utilizing values other
than 4KB.

Of course, I believe that regardless of whether this issue
currently exists, it is something the RDMA community can resolve.
However, as I mentioned, adapting to new API takes time. Before a
complete transition is achieved, we need to allow for some necessary
updates to SMC.

Thanks

