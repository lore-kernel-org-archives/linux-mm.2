Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BBED6101A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E73F6B0088; Thu, 29 Jan 2026 09:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693CF6B0089; Thu, 29 Jan 2026 09:04:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA8A6B008A; Thu, 29 Jan 2026 09:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0176B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:04:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B72F540FC
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:04:39 +0000 (UTC)
X-FDA: 84385171878.20.9158D23
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE06F180017
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:04:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UFwZ6FdH;
	spf=pass (imf24.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769695477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB/cu5YkkLF/4qU6I+B0lmWM8syID5t0JTbxMcIST2s=;
	b=D792daCcHlXc+zftdQxfYJseF51/BKi+VWnZbGwZyYlhHRz2zpsAJumTbmBkF4HumXYzUe
	FGtifzZbasdQKk/aCu4FDb22swJIN9aUpRTpOymIs3S1l/c/fK/wgY8iKtE2rHMlL5x58j
	bwldUSSq1zAXrePZF6f3tyZNeuYKgog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769695477; a=rsa-sha256;
	cv=none;
	b=K5PvMj1lwsUl9X0PmzW9xRvVU7+Gy7IEXZY0i8P7REnNz1sFU0dqartipnBvXrZguQS2Jl
	yAF1O8tleP+lcGJY9YpWpqP2QGmdKVvxAXiS0Vw9IN+gIe2LJ0aikWUWp+rBLbtoP0wzL+
	NhrSbOw0g2P9QvSabvmX2E//5D9G0ms=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UFwZ6FdH;
	spf=pass (imf24.hostedemail.com: domain of alibuda@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769695469; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=PB/cu5YkkLF/4qU6I+B0lmWM8syID5t0JTbxMcIST2s=;
	b=UFwZ6FdHuurJh2O3L0/dx6OcfJraLwb0kWd5bTjjLjPNgNx5AW6HfxAYm2qTvMhw5Sj00PGtMQioiAQEHtksXhAHwhrPDd/HLOz5UgqAt8oE6J5oz6pLLvqaBr9f7MsKtMZ99FKS/XhWWNHR7kiLYwiyxxFPhyoM7J2rKV0Y3BQ=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wy7dC-l_1769695466 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 22:04:27 +0800
Date: Thu, 29 Jan 2026 22:04:26 +0800
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
Message-ID: <20260129140426.GA39958@j66a10360.sqa.eu95>
References: <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128111346.GD12149@unreal>
 <20260128124404.GA96868@j66a10360.sqa.eu95>
 <20260128134934.GD40916@unreal>
 <20260129110323.GA80118@j66a10360.sqa.eu95>
 <20260129122202.GF10992@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129122202.GF10992@unreal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Rspamd-Queue-Id: EE06F180017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hk9h1wwhmpygn5zgea6xeir6aihb1zay
X-HE-Tag: 1769695474-775686
X-HE-Meta: U2FsdGVkX1/77BJstPwaV0LGb2PColhYKNgC6eY/iEB6sv7ayyyrM7RyzvFXCJNosB6498TSbyQxiOWS8uj5+S3+dkkSUaamIGRW7WxO1PzIFaMUWmIHCEA8mqHjeOBkz/LXf0PGSTf9mNed4t6TEGmwC6IcfmNI0YIGbFTgd6/c5GS893/CddO2NNIR04KREpAuSzVH1jzRd3ccdEzr4c76i8BLk+LZLhdHPUDAz8OTtGcuO3g4oeDarci6SWf3lKslhma1o7p1RUEDeKW09jn43EQeQstyMSIL413HeP93/deugB9JlCj6lRfVXEMxzo6cKnMxarbf/f+9zaUqVymiyN7wVcj3JjQIabcU30gK3aWIz5/EHTItRIDd8LepQC+d9eohIE2nbEFJvVDdjDEYeQSa08/dbF+WAnDbXJJB/3ptBKwtZbOwimLGAVTyI3bOl4sqHAPHSQNdOS8Qu2F/LDpSWIUvLqvmextC5Wb+vHukZ3tEMKgxjU2GffB+fsgCbUgnC6uxTu81Tc/jIyyQJAPdmnzG7WLdmFyY6cKtitY2Zg7JXDk/fuOjyEIYOybcy8eLfyKb2LryGmAdepqiG7ad1O1nmg6MN7xajUfAklA4VviqkFdGNCtcUbWWeRZPYRT5Ficulky9zZjOdMItJF9ohbUy+toz560Kp8jCxB54Q+QGW/e9DUb7Y1YCsz2cvFJ1FMwauATZ8nn5CIqeC6VRx57Sau7VEYO8xITSNjcPQUdzr7f1yzl3u1fCzcN1rAZidRobWosJ/L9douXvwqKbEAwFuQcfJKTaxi23dTCa5JprF7RcBxzTOEm8iZa2VVLVc4ALwlK9MWLOCk9JFpONQgM9m/xyHBcek0Ki/i9qyI7S933lbjxLnlpo9U/x/IjwAPf7zkyF1u4/alg30zhmxC8dceKCfIMb4ZNei1yONWuucWMOGQkZNcMxgReDnbKG50w3AUtAPNc
 FwHbJ55q
 fq7YvaSmxb3jynISy/XCi+TfDQOjIv24AKXKZFfq3w6rfPLcUUENOZ2cdrvJDMg6cvagmlYjZm3H51qHPAUnZvL2h2DY7IBzpu2NNj75xTww16YR6mydtDkXW30kwGMgEWWkOcVbqQi84m1TUO3fb7G2BVGxM26f0u9c3V7BzwTgjt2Ofvl9d8M8Go0+Jj6Q/uv3vVtoYnNMoVqpIZ6AUyeFpXK0Ka6tQoT7ohd5tugPpaKvc/H90VHMYrSs10ZuskcInjIXMGapALSani8lrp9iANnQMNHFRX2Tv+/gpCjYV5qu7N9c1keXK9NbGpKzgJKeh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 02:22:02PM +0200, Leon Romanovsky wrote:
> On Thu, Jan 29, 2026 at 07:03:23PM +0800, D. Wythe wrote:
> > On Wed, Jan 28, 2026 at 03:49:34PM +0200, Leon Romanovsky wrote:
> > > On Wed, Jan 28, 2026 at 08:44:04PM +0800, D. Wythe wrote:
> > > > On Wed, Jan 28, 2026 at 01:13:46PM +0200, Leon Romanovsky wrote:
> > > > > On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> > > > > > On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > > > > > > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > > > > > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > > > > > > Hello, D. Wythe!
> > > > > > > > > 
> > > > > > > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > > > > > > 
> > > > > > > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  mm/vmalloc.c | 1 +
> > > > > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > > > > 
> > > > > > > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > > > > > > --- a/mm/vmalloc.c
> > > > > > > > > > > > +++ b/mm/vmalloc.c
> > > > > > > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > > > > > > >  
> > > > > > > > > > > >  	return va->vm;
> > > > > > > > > > > >  }
> > > > > > > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > > > > > > >  
> > > > > > > > > > > This is internal. We can not just export it.
> > > > > > > > > > > 
> > > > > > > > > > > --
> > > > > > > > > > > Uladzislau Rezki
> > > > > > > > > > 
> > > > > > > > > > Hi Uladzislau,
> > > > > > > > > > 
> > > > > > > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > > > > > > internal implementation details like struct vm_struct to external
> > > > > > > > > > subsystems.
> > > > > > > > > > 
> > > > > > > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > > > > > > order lookup into a minimal helper instead:
> > > > > > > > > > 
> > > > > > > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > > > > > > 	struct vm_struct *vm;
> > > > > > > > > >  	vm = find_vm_area(addr);
> > > > > > > > > > 	return vm ? vm->page_order : 0;
> > > > > > > > > > }
> > > > > > > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > > > > > > 
> > > > > > > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > > > > > > layout private while satisfying the optimization needs of SMC.
> > > > > > > > > > 
> > > > > > > > > Could you please clarify why you need info about page_order? I have not
> > > > > > > > > looked at your second patch.
> > > > > > > > > 
> > > > > > > > > Thanks!
> > > > > > > > > 
> > > > > > > > > --
> > > > > > > > > Uladzislau Rezki
> > > > > > > > 
> > > > > > > > Hi Uladzislau,
> > > > > > > > 
> > > > > > > > This stems from optimizing memory registration in SMC-R. To provide the
> > > > > > > > RDMA hardware with direct access to memory buffers, we must register
> > > > > > > > them with the NIC. During this process, the hardware generates one MTT
> > > > > > > > entry for each physically contiguous block. Since these hardware entries
> > > > > > > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > > > > > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > > > > > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > > > > > > resources and becomes a major bottleneck for system scalability.
> > > > > > > 
> > > > > > > I believe this complexity can be avoided by using the RDMA MR pool API,
> > > > > > > as other ULPs do, for example NVMe.
> > > > > > > 
> > > > > > > Thanks
> > > > > > > 
> > > > > > 
> > > > > > Hi Leon,
> > > > > > 
> > > > > > Am I correct in assuming you are suggesting mr_pool to limit the number
> > > > > > of MRs as a way to cap MTTE consumption?
> > > > > 
> > > > > I don't see this a limit, but something that is considered standard
> > > > > practice to reduce MTT consumption.
> > > > > 
> > > > > > 
> > > > > > However, our goal is to maximize the total registered memory within
> > > > > > the MTTE limits rather than to cap it. In SMC-R, each connection
> > > > > > occupies a configurable, fixed-size registered buffer; consequently,
> > > > > > the more memory we can register, the more concurrent connections
> > > > > > we can support.
> > > > > 
> > > > > It is not cap, but more efficient use of existing resources.
> > > > 
> > > > Got it. While MRs pool might be more standard practice, but it doesn't
> > > > address our specific bottleneck. In fact, smc already has its own internal
> > > > MR reuse; our core issue remains reducing MTTE consumption by increasing the
> > > > registration granularity to maximize the memory size mapped per MTT entry.
> > > 
> > > And this is something MR pools can handle as well. We are going in circles,
> > > so let's summarize.
> > 
> > I believe some points need to be thoroughly clarified here:
> > 
> > > 
> > > I see SMC‑R as one of the RDMA ULPs, and it should ideally rely on the
> > > existing ULP API used by NVMe, NFS, and others, rather than maintaining its
> > > own internal logic.
> > 
> > SMC is not opposed to adopting newer RDMA interfaces; in fact, I have
> > already planned a gradual migration to the updated RDMA APIs. We are
> > currently in the process of adapting to ib_cqe, for instance. As long as
> > functionality remains intact, there is no reason to oppose changes that
> > reduce maintenance overhead or provide additional gains, but such a
> > transition takes time.
> > 
> > > 
> > > I also do not know whether vmalloc_page_order() is an appropriate solution;
> > > I only want to show that we can probably achieve the same result without
> > > introducing a new function.
> > 
> > Regarding the specific issue under discussion, I believe the newer RDMA
> > APIs you mentioned do not solve my problem, at least for now. My
> > understanding is that regardless of how MRs are pooled, the core
> > requirement is to increase the page_size parameter in ib_map_mr_sg to
> > maximize the physical size mapped per MTTE. From the code I have
> > examined, I see no evidence of these new APIs utilizing values other
> > than 4KB.
> > 
> > Of course, I believe that regardless of whether this issue
> > currently exists, it is something the RDMA community can resolve.
> > However, as I mentioned, adapting to new API takes time. Before a
> > complete transition is achieved, we need to allow for some necessary
> > updates to SMC.
> 
> I disagree with that statement.
> 
> SMC‑R has a long history of re‑implementing existing RDMA ULP APIs, and
> not always correctly.
> 
> https://lore.kernel.org/netdev/20170510072627.12060-1-hch@lst.de/
> https://lore.kernel.org/netdev/20241105112313.GE311159@unreal/#t
>

I see that this discussion has moved beyond the technical scope of the
patch into historical design critiques. I do not wish to engage in a
debate over SMC's history, nor am I responsible for those past
decisions.

I will discontinue the conversation here.

Thanks.

