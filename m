Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6FED2F02A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52ECE6B008A; Tue, 27 Jan 2026 08:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B23E6B0093; Tue, 27 Jan 2026 08:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE796B0096; Tue, 27 Jan 2026 08:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2CB6B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:34:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B03A3160112
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:34:25 +0000 (UTC)
X-FDA: 84377838090.11.BFC8E47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E680F140005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:34:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1tKzPHO;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769520864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lizg5l+ptdCuqVMGK2vpvS1YXeFZId8xAyD7dqHUJaE=;
	b=o6km38HnJeRAGN3TSW1Y+esD7ouBAjFit1fzeIciu+N4zArncpt4HmuYyVpuCBmDyuVrAY
	KPKBHk4GenhFREyiNcujykXGVi6AsJ+k3sgJNcCaIXfcyRmjidleuVynObzl+cYS/oN2d7
	9Lvl8IRotzZJz/N9Hk9aOPKGcHxYxuM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1tKzPHO;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769520864; a=rsa-sha256;
	cv=none;
	b=SHALolSEdDbrkMl/KsA3AlFSVZUcA4DoLZCIdNN37piaq7HeDyTV9Gt72HP9VaTkYm7icJ
	UmSVwTwuM9rTLd/qtNNLUDrCyofXbF6dNq7UrWnn+LaD42NugpVCsp/q6/aVrNYngditJJ
	u3gx9tt9KnvEziIz26Iv5G1hNcxpozM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF3AE40735;
	Tue, 27 Jan 2026 13:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D4FC116C6;
	Tue, 27 Jan 2026 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769520862;
	bh=xM07q8aW4efWcWvz4c8IbKTY17sRaIR8OIvcte7xxIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C1tKzPHO+Xd9T9Sns/qz07JJiCpwBYzGLGyYKigc3cYDYN9ptNQVAmsibRisal4S0
	 36gbvdB5BEwQ73XwT1CaHOCJVGTKJ6qdbGoqyxSA4rwbnQnFgtT3NlRpuL2qN4hRap
	 PwySs7bTSJ6MWfsUrWXfL4TbqVpPuZdIpTklBHyZT/Wkhj5Tm5OmdvhA10z+mtCAEa
	 h3m42WpedulW1BCszBT3xLdGFEUHN6F6WZjh+o8sO/FMutTD1s3FArDWHIvqit6K3V
	 fflfyHLe9MrqIbzUrr+gtkya8m9G3zJMFo/dVTqG6xiJyF3g5wJ8U0+UIFxd1pgZv2
	 qa+l7MFvZc8vA==
Date: Tue, 27 Jan 2026 15:34:17 +0200
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
Message-ID: <20260127133417.GU13967@unreal>
References: <20260123082349.42663-1-alibuda@linux.alibaba.com>
 <20260123082349.42663-3-alibuda@linux.alibaba.com>
 <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124145754.GA57116@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E680F140005
X-Stat-Signature: 5aiykkcowi9f7s1iwqrpc5smw8bzxono
X-Rspam-User: 
X-HE-Tag: 1769520863-551327
X-HE-Meta: U2FsdGVkX183ZrCuUhpb5PrF6DSOCcAcenDet1LsiQ4ukH+WC9hWQX6zN5y7qCLUwPnbSkcMgwoSm021HzJpVvn1Q5Q59k4tMyLOqWVzkHCoh/ues3Af5At+pFF0cfpVFKGW6ZrWRWVBUNmf9IleuF0L3fdpO/3xhFpZ5rpupiiCOUEXmvCiAvb8wnq08hPZCykVErfO7/S78GAQMtQpYw1skKQRKvkQp1F1YDCfA2KINazj4I6GYuiAan5F2/KAXi2ATSIA1qM+6a8vRTfO4YwsJ903C9uCTsyhrhRDh8cCWzBBc8ssfWZqkivkDd5Jgo8ZxTm7mvm4TVt4zxCVCRZKMuDJRXDwxTaLb6md9+NWnW5pIygTUgVGVbMvQbH15N2XgWMOA1+D6+mv4O7YT/PD9TvpOKgavGJuc/0yt10KXrf3KJtPNCl3IQQ8if2VB1aLdMNEOEEnLSlZRrjOXODlfR2wc/i3Z+sUA1VnwMuPJPZrx86WaVeaYE+M7jLTvxEATm4YXwxDd/e8oXs+8oGDUsvYymLQFfi36EnMIa1q8F03ZiQOVBjRjoTMG0fvy+/l1lt4XqddjkFWATLCXPf/ArJM3PwOWGgHHAjJXPWoI2E91CCWWFAv0sTNLRcnP9RmK777bBiGdUCimyd6aNSBa57i0y4Ccap7/MGfbhBgCqlbb8gUNgoqx3BbKR9VHtJ2Ytn/SVfkigMq7QyGn8ZRANR1M8nGeDziEmH+UvgI5acEwXIEkvOboGE069pqN3ugS5B1CMX/EdD/j3ob0X7cGYcRXLaw7vzAnZiFiIqhJr4zCjSLXOGITRhGKzJ0asW0T7IueHL10Qmu3S0z2hxyF2ghJbzsXY3DHVykjUZC0V4roFfuN3sYJeGHwyFVvL7wZGX9e+B1UTUBlIBJzk2qZ8EsU+/J8CmMfJEyy8sI6bwWLBOLrmVqu+a1gIj45UPIyPLwY37irWMsh9H
 tmA6iz19
 0ur6iHi4mHzDww9mybSzs1ghbg+mfavg3fCShsNAY4nBHVffnGO3PuWJ/5WOY4PnG2YxvAQgpcBE1O7WB3UzPanVCuR3Syq0TUt41Zqv0dzB9LKx9eZH/DEFkwrfAZCn9P666MoATDeulrqbHsAuTLY5qxxLyBPqmXe0r4r2MfFDIpa7joz/Mu8l0iA1f8rSVE/cndloPrdEOSYMYwKMSFWOcniccPFJz2yfo4TK8fWOxLCFn9s21X2eP1gLfFjDms0Tleae6NDGKXwGJa4f408C777SDMa6482JqOGxj7hLOLL5c6+clg9XPOu7Yb/cHNCwZQ2mJl5rFLgHF2yYtYwlJiSJ1jKk13rqgwtQ4cXoGgBo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 10:57:54PM +0800, D. Wythe wrote:
> On Sat, Jan 24, 2026 at 11:48:59AM +0100, Uladzislau Rezki wrote:
> > Hello, D. Wythe!
> > 
> > > On Fri, Jan 23, 2026 at 07:55:17PM +0100, Uladzislau Rezki wrote:
> > > > On Fri, Jan 23, 2026 at 04:23:48PM +0800, D. Wythe wrote:
> > > > > find_vm_area() provides a way to find the vm_struct associated with a
> > > > > virtual address. Export this symbol to modules so that modularized
> > > > > subsystems can perform lookups on vmalloc addresses.
> > > > > 
> > > > > Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> > > > > ---
> > > > >  mm/vmalloc.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > > 
> > > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > > index ecbac900c35f..3eb9fe761c34 100644
> > > > > --- a/mm/vmalloc.c
> > > > > +++ b/mm/vmalloc.c
> > > > > @@ -3292,6 +3292,7 @@ struct vm_struct *find_vm_area(const void *addr)
> > > > >  
> > > > >  	return va->vm;
> > > > >  }
> > > > > +EXPORT_SYMBOL_GPL(find_vm_area);
> > > > >  
> > > > This is internal. We can not just export it.
> > > > 
> > > > --
> > > > Uladzislau Rezki
> > > 
> > > Hi Uladzislau,
> > > 
> > > Thank you for the feedback. I agree that we should avoid exposing
> > > internal implementation details like struct vm_struct to external
> > > subsystems.
> > > 
> > > Following Christoph's suggestion, I'm planning to encapsulate the page
> > > order lookup into a minimal helper instead:
> > > 
> > > unsigned int vmalloc_page_order(const void *addr){
> > > 	struct vm_struct *vm;
> > >  	vm = find_vm_area(addr);
> > > 	return vm ? vm->page_order : 0;
> > > }
> > > EXPORT_SYMBOL_GPL(vmalloc_page_order);
> > > 
> > > Does this approach look reasonable to you? It would keep the vm_struct
> > > layout private while satisfying the optimization needs of SMC.
> > > 
> > Could you please clarify why you need info about page_order? I have not
> > looked at your second patch.
> > 
> > Thanks!
> > 
> > --
> > Uladzislau Rezki
> 
> Hi Uladzislau,
> 
> This stems from optimizing memory registration in SMC-R. To provide the
> RDMA hardware with direct access to memory buffers, we must register
> them with the NIC. During this process, the hardware generates one MTT
> entry for each physically contiguous block. Since these hardware entries
> are a finite and scarce resource, and SMC currently defaults to a 4KB
> registration granularity, a single 2MB buffer consumes 512 entries. In
> high-concurrency scenarios, this inefficiency quickly exhausts NIC
> resources and becomes a major bottleneck for system scalability.

I believe this complexity can be avoided by using the RDMA MR pool API,
as other ULPs do, for example NVMe.

Thanks

> 
> To address this, we intend to use vmalloc_huge(). When it successfully
> allocates high-order pages, the vmalloc area is backed by a sequence of
> physically contiguous chunks (e.g., 2MB each). If we know this
> page_order, we can register these larger physical blocks instead of
> individual 4KB pages, reducing MTT consumption from 512 entries down to
> 1 for every 2MB of memory (with page_order == 9).
> 
> However, the result of vmalloc_huge() is currently opaque to the caller.
> We cannot determine whether it successfully allocated huge pages or fell
> back to 4KB pages based solely on the returned pointer. Therefore, we
> need a helper function to query the actual page order, enabling SMC-R to
> adapt its registration logic to the underlying physical layout.
> 
> I hope this clarifies our design motivation!
> 
> Best regards,
> D. Wythe
> 
> 
> 
> 
> 

