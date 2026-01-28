Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4343DD25B7D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AAB6B0005; Wed, 28 Jan 2026 08:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE4C6B0089; Wed, 28 Jan 2026 08:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA246B008A; Wed, 28 Jan 2026 08:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4776B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:49:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5591B58C36
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:49:40 +0000 (UTC)
X-FDA: 84381505320.23.6EE3869
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5585100007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:49:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxnzsa9S;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C2IAEvzQM+S6c5YNR4pKgwHAg3zob5spK1daWs1GBI=;
	b=Mnzgav6Rz1Rk0SVdjZJE6ka5o0yQnjVbtJihwxVtTTwbb/6g4k5FyQiJpYJIpIWxNQlLMm
	flXIUTlsB+8us1guspswvyTznBzSqZQJiEkinDf7CKDS/K11VD7knWD1joHGUv67wz+61V
	XsaJypCKE8ixO7tc5KuoEehSe1Xeg/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608178; a=rsa-sha256;
	cv=none;
	b=soZxPsUnAbH38g9Q5vQB/w9mlgOxDQmeoSFOuIwppnRIWUOewlPhHzxwhJQ5IGu07SxmVH
	ay0QpQdX0abC/apCoi4KlStSHHyJ+9r+bciL0OeTopM5ii/YpHQI3UMu4M2iLng9syBFW+
	Mk8T5GjfHfG4IdJ2OSD4Nny7w8QNlJI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxnzsa9S;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CEF4260097;
	Wed, 28 Jan 2026 13:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ECFDC4CEF1;
	Wed, 28 Jan 2026 13:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608177;
	bh=/bMLpYYhrg2xoMlUik6YRGll+7ObCydAAbWlBqc3cqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hxnzsa9SymJfwM0JDsvFVTzLKPBPnWxmxKo4dYTtl/xhZ7P4Lt+TYqOcxLhG2wQBv
	 o6pp6Pf2UnwuiCcOZHiXk6jVeNFVux8z+4XdE30H0gZH5TIfMdROXDP3Asbg37gWm/
	 YGH/3Q5sq2hrdv/QMRDT69RsSR1OkbXe0Gk5jgDkomgNEycYnK6KEvrrniJXiXCAeP
	 qEH1opxERlbo4FXPs5dVBBNI+Fle4IgiTSjm/XmEWohnBvSwXH0OR0hf1GA4KKXyb+
	 k2X50QA2iAb41y3uEuPk2YaLQ9g/yrBxGGztyb9w5PIQ5s8ai04J+lvzDZyU138oV3
	 KWYDotS335PvQ==
Date: Wed, 28 Jan 2026 15:49:34 +0200
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
Message-ID: <20260128134934.GD40916@unreal>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128111346.GD12149@unreal>
 <20260128124404.GA96868@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260128124404.GA96868@j66a10360.sqa.eu95>
X-Rspamd-Queue-Id: A5585100007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7xy4c4g1ohd9rfmopp9pz1wxkfkytcpw
X-HE-Tag: 1769608178-15846
X-HE-Meta: U2FsdGVkX19oyZK/GDlS8M322k1gscjDXzTg2sI+sGP80vag67GV2Fx54mgjGOb3+4Rn+UcLNkjDzk3RI7ShfCxLC0z5muAPD8YdKQJYyxvAHIf4ru91w/TTuc7Vty2kcCZ3oT/TBXqNuqaKld0GHlG/OzJOW7pIjCE5r8m5SbtMb0+PyIfqSotYggx0NIEE9Fw13W/5+K9r31tfWgRnLcLKA9KE+FZdKYM4Fi84/W1kCzqWI1c9ne9UfgRIThjbf/iM1w//ZubYnUWtg4SdAIDAmfgqdES92YdwaOuBthPvzR5w/FQdydQzNOPyxtnxme8SWkvUwTHwz4CMhVnBs8jCrLtbyVuglneS/4S4/wQgEQfuRV/tq2U/YRkXPJZjH+2BuH0B3zvS7QEEDrHlWB5Rmq+B4iszBIWVdmK7SUclZJ408mb1Yi4BPtddg7LMwRyP/j43e4I6X/alFCMcYfvVzESU4Dgsj9xT30i4jDcH8hmgEiGhqmnV3I2eUZAl06v6d7J2DPsK/SWjG5aen4Jshy6Kp7lO1BFsupHeeCvRdU6pVrHGbsEQh8FSJ+GAEHryzshwg39vjSzQS0e8D8e6PLBv1Gw5m7O552Sck1AD9impFJigNBtotBbEaWrs2CkK37EShjEp79PuMLKCCR9nzobRRYHaNdadO4joXuIuXvr9FDoGe/lGoJ9BDosJn3Ccmrnv4yI0SWaqtLgbYFp4w0joJEHXfLlKv/r+yzpR6F48ayk22PWgPj6L7/RfFCE+TqIdeKG2P6ZP3MgqecPIBKear+HKh41HyTeEa32rWYb7S3MJvb8uQFpB/NFbLdX0kBF43/0CHG9dsW1gRvRY4CV/7+W6egfTiYsvTk7Pw+erUOybvvpiBXlBV3EydzjdU5PNBmvxEiKHiLqS6dA2WKL6ptcS4ZNqEFFElRuda5ZVwsVrV7eHuqFw82rt2JJg8wP3yK44CasSaZk
 nrSyDUGv
 9cP+OTRVdWX4IihxMAQYMLOt18M1IEAgsktvzFA/T1rQvLTR4llwdbodBTkduhQxB1X+shLxryYq8NN/2wu9+JZS4ZZLTEiBshRuxePP/D9asFP76YFpeSbAsnmj/TSCzgHdLdK2HFOg3lPoShTLsYHM4emTKgeQvqa7XyxXNV9nofuJ2/Roc+IWy76QlEe2VNx5qICCAai+xHaWqm6VRjf01kEMG7ahUpT2KaxwvXdCwS0+gWT/O6nG73FVRv+XTtn+LvCfjEe/1uQNJWkYyrUq5ZP9MQxCl9w/KjS+Ue1eu69KldijS9JhXmuhgBk6ER3QS48dHfIe6m45Vf9/iOAGqxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 08:44:04PM +0800, D. Wythe wrote:
> On Wed, Jan 28, 2026 at 01:13:46PM +0200, Leon Romanovsky wrote:
> > On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> > > On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > > > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > > > Hello, D. Wythe!
> > > > > > 
> > > > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > > > ---
> > > > > > > > >  mm/vmalloc.c | 1 +
> > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > > > --- a/mm/vmalloc.c
> > > > > > > > > +++ b/mm/vmalloc.c
> > > > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > > > >  
> > > > > > > > >  	return va->vm;
> > > > > > > > >  }
> > > > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > > > >  
> > > > > > > > This is internal. We can not just export it.
> > > > > > > > 
> > > > > > > > --
> > > > > > > > Uladzislau Rezki
> > > > > > > 
> > > > > > > Hi Uladzislau,
> > > > > > > 
> > > > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > > > internal implementation details like struct vm_struct to external
> > > > > > > subsystems.
> > > > > > > 
> > > > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > > > order lookup into a minimal helper instead:
> > > > > > > 
> > > > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > > > 	struct vm_struct *vm;
> > > > > > >  	vm = find_vm_area(addr);
> > > > > > > 	return vm ? vm->page_order : 0;
> > > > > > > }
> > > > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > > > 
> > > > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > > > layout private while satisfying the optimization needs of SMC.
> > > > > > > 
> > > > > > Could you please clarify why you need info about page_order? I have not
> > > > > > looked at your second patch.
> > > > > > 
> > > > > > Thanks!
> > > > > > 
> > > > > > --
> > > > > > Uladzislau Rezki
> > > > > 
> > > > > Hi Uladzislau,
> > > > > 
> > > > > This stems from optimizing memory registration in SMC-R. To provide the
> > > > > RDMA hardware with direct access to memory buffers, we must register
> > > > > them with the NIC. During this process, the hardware generates one MTT
> > > > > entry for each physically contiguous block. Since these hardware entries
> > > > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > > > resources and becomes a major bottleneck for system scalability.
> > > > 
> > > > I believe this complexity can be avoided by using the RDMA MR pool API,
> > > > as other ULPs do, for example NVMe.
> > > > 
> > > > Thanks
> > > > 
> > > 
> > > Hi Leon,
> > > 
> > > Am I correct in assuming you are suggesting mr_pool to limit the number
> > > of MRs as a way to cap MTTE consumption?
> > 
> > I don't see this a limit, but something that is considered standard
> > practice to reduce MTT consumption.
> > 
> > > 
> > > However, our goal is to maximize the total registered memory within
> > > the MTTE limits rather than to cap it. In SMC-R, each connection
> > > occupies a configurable, fixed-size registered buffer; consequently,
> > > the more memory we can register, the more concurrent connections
> > > we can support.
> > 
> > It is not cap, but more efficient use of existing resources.
> 
> Got it. While MRs pool might be more standard practice, but it doesn't
> address our specific bottleneck. In fact, smc already has its own internal
> MR reuse; our core issue remains reducing MTTE consumption by increasing the
> registration granularity to maximize the memory size mapped per MTT entry.

And this is something MR pools can handle as well. We are going in circles,
so let's summarize.

I see SMC‑R as one of the RDMA ULPs, and it should ideally rely on the
existing ULP API used by NVMe, NFS, and others, rather than maintaining its
own internal logic.

I also do not know whether vmalloc_page_order() is an appropriate solution;
I only want to show that we can probably achieve the same result without
introducing a new function.

Thanks

