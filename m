Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA92AE8306D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053C86B0005; Tue,  3 Feb 2026 04:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0021E6B0088; Tue,  3 Feb 2026 04:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25A96B0089; Tue,  3 Feb 2026 04:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11676B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:15:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38B7B58CCC
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:15:25 +0000 (UTC)
X-FDA: 84402587010.07.0CA4823
Received: from out199-6.us.a.mail.aliyun.com (out199-6.us.a.mail.aliyun.com [47.90.199.6])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3483C1C0013
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:15:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EGKXN1zx;
	spf=pass (imf20.hostedemail.com: domain of alibuda@linux.alibaba.com designates 47.90.199.6 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770110123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV7iB2cX0YsCo/vw3xU3Pyo02q+0048t1T+E30Gigtg=;
	b=fx1QW4Uyq1vIQUEWv7x244GwPVoQ1OK9iir5zHYzIEDyj2PsYsyc4/jnV+5xz6glXiwDr2
	IygqY/0VCg5kwBuZ1ahN8qD/VmPpLtKjcwACyYN+lSYtcgNm/tZlz6l/qHQDrsOL2BHMbm
	5CojmsqiwHYiNTrZG66mivzTx75vHV4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EGKXN1zx;
	spf=pass (imf20.hostedemail.com: domain of alibuda@linux.alibaba.com designates 47.90.199.6 as permitted sender) smtp.mailfrom=alibuda@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770110123; a=rsa-sha256;
	cv=none;
	b=GvsU6Q6+Ef3c4JeMsqcUn0BjTrQWfGGjzClfN/5lTqh6GYmklcB9FK7ohX/J1h5Gd17c13
	TtGWzp4Nv256/pQ9VAg/l31vR0BD+kdgDo1BkTuoHh6XMv4W75r58J9FBsSlPMMrjWsZvd
	mB4He2qgtPkWQxmv6ZvYrQhYnLQ43xw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770110107; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=KV7iB2cX0YsCo/vw3xU3Pyo02q+0048t1T+E30Gigtg=;
	b=EGKXN1zxysqWWE+aK0jA/CYb8lxZQdxu+C14WlbPiVx56TPlb4UjQAnXoQGlI8nftIWC21cWZ0jHkha0rAXHfYQ3sreS8eYNVi8ZUL3joOnQ6pFJRkj8151LT/IYVOztfFpMIROJ9T2+dkKLxIEA12grEn0zJIMnaqnaMFHKg+c=
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WySViK7_1770110098 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Feb 2026 17:14:59 +0800
Date: Tue, 3 Feb 2026 17:14:58 +0800
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
Message-ID: <20260203091458.GA89766@j66a10360.sqa.eu95>
References: <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128180629.GT1641016@ziepe.ca>
 <20260129113609.GA37734@j66a10360.sqa.eu95>
 <20260129132058.GC2307128@ziepe.ca>
 <20260130085131.GA122673@j66a10360.sqa.eu95>
 <20260130151636.GF2328995@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260130151636.GF2328995@ziepe.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Stat-Signature: 7ouhwwhb8ncm5y8cnei9jh1symzb78z6
X-Rspamd-Queue-Id: 3483C1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770110121-427007
X-HE-Meta: U2FsdGVkX1+nq8QdGhLI7ep7AZSgMWoO1t05oNbkbO5MZuZbIMwgSsLIA91pBH2etA2LGE7ioqbu3afiuuHCaNf387jdXTQMC6zOkSflJtF/ZuOzqt1OBownxyJIl0V6Xgu3chgtafzdU4MLuDzZEKeYtRxbZToDdjWwsEG9BB0cqYlLti9qVFulowpH7xYszQx6M6ekkijzLn2VydzEHMc/xhAd7fD8wHT4PgP6PnccxUmruIE7QbrN0D19oyOq7vZnW3P6luUo3eGy+3ziNsZVdV5qq1nbkYAOfy9Huma597SjLSE+n25Y+gfBbw4RJrX52BGxFP5Krq1UhQUoD0i2x3keo4+grjdWhevJZVMjpH5dkZYaNyPIn2CgXPHe0dfIzr7npxqF5uU0UDkOPPBG4To07csVXlSPoTwE/88/6nhBcaEHpOVxpKROQzw1dH8LggTseL5gccSKF2STsWkykIPyRd9I7JQ2/82clzKDvqFRcCoDqIxTdS0CAIh+bY/Dup3ey92frdsOahJgS11EE4Ee6LbdjiGjvn7S2n7hJfn2PpUNOQus+3UDfA0RI/TXglfUKLNTcPteL2IpuriU5aqt5yrE/T10LqpxAJozn2rthOMcmgpnigdoAKbzqU42SErIpfr/PtPjaJ4E3lv52uE2i/hodOWX99WNfojIfK7PIIGrRbN3nxJqXVfl2XLO6Uyf4TI0COifA4vNKoXPZOkeksvPb06CYT6JytOuTpibr9u57dxr64zDOg2MxOFLPS1KJXyF0RWBUM6de3DHCJzKRvRJrTk/5l2uUQQbx9EP+/jLYcmurI8UxyGnjjHhTrSGABApM5DzgwQsJWH+nONdog/Z7ApkN4uPYuTpQ01p//1GFs87yGpGt+8wv5jbtNamyKdddHx4hG8pXzSgOG6rxZWP5dd2bYrtXxefRlkRYQjgLdazi3nyxxnBe+RmZMu7g9FD+vBxwUI
 zOx3VpWT
 Bdddg4R9PzaYcEPM7WLcrcIRj+T2HHoLoC+yxtQNfkGT+JnUi6LPHrq9ijI+xKWdeyUkKxEMDypMykiWFo3/oXEMgLocRHMNmd3Ai51jJYsehG4eryCC3DRZZ0szMd60qRcT0HHkGDfpAiYCSWBBLyG0j0k2oQwgSITj3IUlEd1iYxaLtnuUdeNMTtlCwWEfzTt9ULzbxbMFeOMKtBb2k7/pT99wEZ/t7vaeG4MWBFgikBPrPLJSCulTEws92Uyi4Cgc9BuKgJxOllc9xcvGFz2W+YgeNYKfQ3RQZwcSihzT63+NMTdQL+Avt3ejbmfBOcxCoE9YCZFfA1/DlEFp8y/frX1kjQdPAxelOuCZzTIrHcK3OGkau2wSgg4fTbyd+XcJRQH4UneFA9qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 11:16:36AM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 30, 2026 at 04:51:31PM +0800, D. Wythe wrote:
> > On Thu, Jan 29, 2026 at 09:20:58AM -0400, Jason Gunthorpe wrote:
> > > On Thu, Jan 29, 2026 at 07:36:09PM +0800, D. Wythe wrote:
> > > 
> > > > > From there you can check the resulting scatterlist and compute the
> > > > > page_size to pass to ib_map_mr_sg().
> > > 
> > > I should clarify this is done after DMA mapping the scatterlist. dma
> > > mapping can improve the page size.
> > > 
> > > And maybe the core code should be helping compute the MR's target page
> > > size for a scatterlist.. We already have code to do this in umem, and
> > > it is a pretty bit tricky considering the IOVA related rules.
> > >
> > 
> > Hi Jason,
> > 
> > After a deep dive into ib_umem_find_best_pgsz(), I have to say it is
> > much more subtle than it first appears. The IOVA-to-PA relative offset
> > rules, in particular, make it quite easy to get wrong.
> > 
> > While SMC could duplicate this logic, it is certainly not ideal for
> > maintenance. Are there any plans to refactor this into a generic RDMA
> > core helper—for instance, one that can determine the best page size
> > directly from an sg_table or scatterlist?
> 
> I have not heard of anyone touching this.
> 
> It looks like there are only two users in the kernel that pass
> something other than PAGE_SIZE, so it seems nobody has cared about
> this till now.
> 
> With high order folios being more common it seems like something
> missing.
> 
> However, I wonder what the drivers do with the input page size, 
> segmenting a scatterlist is a bit hard and we have helpers for that
> already too.
> 
> It is a bigger project but probably the right thing is to remove the
> page size input, wrap the scatterlist in a umem and fixup the drivers
> to use the existing umem support for building mtts, splitting
> scatterlists into blocks and so on.
> 
> The kernel side here has been left alone for a long time..

I am also curious about the original design intent behind requiring the 
caller to explicitly pass `page_size`. From what I can see, its primary 
role is to define the memory size per MTTE, but calculating the optimal 
value is surprisingly complex.

I completely agree that providing an automatic way to optimize or 
calculate the best page size should be the responsibility of the drivers
or the RDMA core themselves. Handling such low-level hardware-related 
details in a ULP like SMC feels misplaced.

Since it appears this isn't a high-priority issue for the community at
the moment, and a proper fix requires a much larger architectural effort 
in the RDMA core, I will withdraw this patch series. 

I'll keep an eye on the RDMA subsystem's progress and see if a more 
generic solution emerges in the future.

Thanks,
D. Wythe



