Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E70FD25B42
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA506B0088; Wed, 28 Jan 2026 06:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E1B6B0089; Wed, 28 Jan 2026 06:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589EB6B008A; Wed, 28 Jan 2026 06:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 453FB6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:13:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D912913B38C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:13:52 +0000 (UTC)
X-FDA: 84381112704.17.DDA616F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4680C140002
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:13:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsOIO6cV;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769598831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SB/orbORrUD/LKlhEJL4mNvBMIQ+FtXe6SdtI0LUr9k=;
	b=jWeGfWQDCa23V5hdv9W/4Glui6XmqfNjjGFs63WJ70gpuYGP6OM49EnL3sW6sadwCCTexp
	fIgaNJXSanvf4s0oBZcR1Io3D6mMOCgQAiAUHqec2CxdlGMmwLHSpMCHRTPOfWqF7IhTuf
	TverAs4wKrd8DKKpkywS4ua50OATQcM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QsOIO6cV;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769598831; a=rsa-sha256;
	cv=none;
	b=VbDYxvn9Byv5y6BCeRA4enEfxGWdiUVSIlrGHOTZx6gNSyJgi/I9Pu98cmakuY54BbsGo/
	l3OyzboI7GFFDgJzgSapeGRiNspTgeSeV81mXyn2LoRvN4L0xGYVZAhEpU6pSjyRc+in2N
	AxnGeAe2hNUPSwC3aBV6ki4GQzwf+e8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A200A60097;
	Wed, 28 Jan 2026 11:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E815DC4CEF1;
	Wed, 28 Jan 2026 11:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598830;
	bh=XhAa/knyZ6haG7FHsLWt0DcbM4mnkccj/WzXt56VTpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QsOIO6cV70uo0MZSW5kkJyDzI6RcSrMOzS5q7b7ULZKvuvWOx/IEA15z5DVAGIIJB
	 coB0IBdwYPmvjySgO+Q5k0Jh7yt3uJdRV7gfvJoAN354mNNBcRN0nPgfT+cNOutquJ
	 ZpegGQAj4wSMSonkLxC7IwKMy3Ey977CuGMoGbkKTiCHGIQ0NLz5TwtRb/TERR82EW
	 gi+yJN3vH9nFSz8UetoM6ON9giYtcaD2dAs7OBryHfj7ofCebLLX0mZMO5KXNUbTV6
	 tJEsoktIRK3o+24kAK4i4HfY3V6Kp+kTlsfAFbeP/LXceIkOsVtbdbiUnMiqvrXZhI
	 Zl1Y90LMpECMQ==
Date: Wed, 28 Jan 2026 13:13:46 +0200
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
Message-ID: <20260128111346.GD12149@unreal>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128034558.GA126415@j66a10360.sqa.eu95>
X-Stat-Signature: 8eu3u58ea3qkhs111rrx4b7bhtbwrdpu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4680C140002
X-HE-Tag: 1769598831-812453
X-HE-Meta: U2FsdGVkX19uVSi+Eu6JtA4N30mlJTe4QU2ORZejJl1naudit+/xX4JPor563jS+FviIMHSSDH+2zUa/JsJJ0N+3lvhvvZSDZZDUnt+qoFywtxir/J072XYNTBr6gG2SZr4AqUInGN+wwKnF/4yteIOXX9LhrIFQn41DAO4UFCAtNFWXZ5n7ScoIlt0MhnHGzySn2kXQvURAYDRqJg0dR4FR1lCpbzh6tbNNpjJzLnjaF3rxgTdwwkTsjmuP8PxQvorzEV61qNhvilQkjllaKHDLAAEKIUXur4blWpcdAs8db2ruZP1NfvNwszYZbIziF5L1C1uUuubGplKZiLVQGpmPmiqJXEpzuNbJt0mORch5BjPLcttB4QCFjaVZgC+nadXQITpe6iHryuO/CrrOsq9UetUweLChGsme/8FUry2prbvCbeTY1WzDy7vB+fTiT4w1TD17QPnEc5N11THTiZ3mC/Jn0Cm7QB8yFLgN3Tse67NtarFfLHsrbAmfF1KCTOFy7rtXxikJsrDakk2OzwtvMUtQX+SAFbl6SZWLpXw8tSFMt5bfLyzrTvAnoBHW8RkScZvdLUO7CNXvMUIOwVwjR8vmc+JbgD9oQZUvXeK9bCJGwLsPgoKPKQzKspTI6FS0OrKTQEEzvdrSPHNo8FMRb4zAxQHHZCg3TmGFbVJSa6lTuBGz8DWhLfxqoqrhDgyLjSIeOS6NyGTbPIWsGvG085yZCcXRdPcAe2pNhgtXLAEFyJQ56Q/VHkVPHFayz+MNpUN1RCKkctzqU+l7+dDlCq0uFsO286E/VVeDZp4dJAsWi0MAmNiw30xz7aE8HKPByrZopMfmMobbR0PVMiRBkjJv90cMGBNMoFuQ380uZOCUnCebaNJiH+GsVFz1a6jIEhMNSiWHfg/sD/ZV4d+Jx605KmOkg6CezyXVtbIKs5pKoc1qKg14QBXJUIuzXF8tU5TQmtAMr8TAmiY
 ovi6BY5w
 YTO+5CybMYeWLP9h3q8RPMQJ/TrDGpD6+qLzcY2EM3981bLQJRoZfaWZ3ytUbidyGVjLiwyRP8WI3y44hGGNhqGnUKv1WOT9zdznN0OOZebvv0tFHCz9fzdPklU5AxqaMHzMCQO5GmO7IKCkhIy9sNoknwsbe8fpEMxPDK4RAzmAU/ZzYoVzDYxit1nBbuqKdLPm0UhEKHVppS6ikdxx/ttseIYCPZennnqOYVwMC0yWYyRw9ITPWnm4BXhc2UjwEnv5cPSYnVfi65NOZUdAiNE7Ronz8ri/2dLlMnC1Rf5a8fKDvY8EUz2BV/MBLb+MkY2fY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 11:45:58AM +0800, D. Wythe wrote:
> On Tue, Jan 27, 2026 at 03:34:17PM +0200, Leon Romanovsky wrote:
> > On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> > > On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > > > Hello, D. Wythe!
> > > > 
> > > > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > > > virtual address. Export this symbol to modules so that modularized
> > > > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > > > 
> > > > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > > > ---
> > > > > > >  mm/vmalloc.c | 1 +
> > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > 
> > > > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > > > --- a/mm/vmalloc.c
> > > > > > > +++ b/mm/vmalloc.c
> > > > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > > > >  
> > > > > > >  	return va->vm;
> > > > > > >  }
> > > > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > > > >  
> > > > > > This is internal. We can not just export it.
> > > > > > 
> > > > > > --
> > > > > > Uladzislau Rezki
> > > > > 
> > > > > Hi Uladzislau,
> > > > > 
> > > > > Thank you for the feedback. I agree that we should avoid exposing
> > > > > internal implementation details like struct vm_struct to external
> > > > > subsystems.
> > > > > 
> > > > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > > > order lookup into a minimal helper instead:
> > > > > 
> > > > > unsigned int vmalloc_page_order(const void *addr){
> > > > > 	struct vm_struct *vm;
> > > > >  	vm = find_vm_area(addr);
> > > > > 	return vm ? vm->page_order : 0;
> > > > > }
> > > > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > > > 
> > > > > Does this approach look reasonable to you? It would keep the vm_struct
> > > > > layout private while satisfying the optimization needs of SMC.
> > > > > 
> > > > Could you please clarify why you need info about page_order? I have not
> > > > looked at your second patch.
> > > > 
> > > > Thanks!
> > > > 
> > > > --
> > > > Uladzislau Rezki
> > > 
> > > Hi Uladzislau,
> > > 
> > > This stems from optimizing memory registration in SMC-R. To provide the
> > > RDMA hardware with direct access to memory buffers, we must register
> > > them with the NIC. During this process, the hardware generates one MTT
> > > entry for each physically contiguous block. Since these hardware entries
> > > are a finite and scarce resource, and SMC currently defaults to a 4KB
> > > registration granularity, a single 2MB buffer consumes 512 entries. In
> > > high-concurrency scenarios, this inefficiency quickly exhausts NIC
> > > resources and becomes a major bottleneck for system scalability.
> > 
> > I believe this complexity can be avoided by using the RDMA MR pool API,
> > as other ULPs do, for example NVMe.
> > 
> > Thanks
> > 
> 
> Hi Leon,
> 
> Am I correct in assuming you are suggesting mr_pool to limit the number
> of MRs as a way to cap MTTE consumption?

I don't see this a limit, but something that is considered standard
practice to reduce MTT consumption.

> 
> However, our goal is to maximize the total registered memory within
> the MTTE limits rather than to cap it. In SMC-R, each connection
> occupies a configurable, fixed-size registered buffer; consequently,
> the more memory we can register, the more concurrent connections
> we can support.

It is not cap, but more efficient use of existing resources.

> 
> By leveraging vmalloc_huge() and the proposed helper to increase the
> page_size in ib_map_mr_sg(), each MTTE covers a much larger contiguous
> physical block. This significantly reduces the total number of entries
> required to map the same amount of memory, allowing us to serve more
> connections under the same hardware constraints
> 
> D. Wythe

