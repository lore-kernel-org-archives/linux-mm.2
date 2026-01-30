Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C58E6BF11
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B856B0005; Fri, 30 Jan 2026 10:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9756B008C; Fri, 30 Jan 2026 10:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB2D6B0092; Fri, 30 Jan 2026 10:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3FC6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:16:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3568C24E0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:16:41 +0000 (UTC)
X-FDA: 84388982202.11.E08FB1F
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6767A000F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:16:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=eV8qRC1G;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769786199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9si664lpAABtSRH5NCDTNiWW5Zo1E2FOdd2kZn8cRsw=;
	b=lRfVW0lvwF6MKIHUybB3UaCso88RXhjbT0juy1IWDbj6xLy15LCxnWyg/UM95Ce3sZIZ/Z
	em43WdA0qydI2OjUg1pwyX7cjpEPouMn9qHVnx0xk94+H1r7jn5v9PXyk8JO6umL4M9Q0j
	jNRwogVxQr5wSargPckKpyqq1xEpB9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=eV8qRC1G;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769786199; a=rsa-sha256;
	cv=none;
	b=fFh7+vRq+z0eT/p+bTdoM6s/yZP6H9pvvkGcxIUyq6yBXgYCGhmJ/gCY/h2fWVBkdP9USs
	fNYBgHeZ0tOTlM6FAutPC9usAYDK6qpPMTFwnAcmrsCvQ22HioyXnPrdAOHJEV+qm0aDeQ
	IDbSaBUHAL8qr0zPv95YGQpkpflga8Q=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a2e3bd3cdso26809376d6.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769786199; x=1770390999; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9si664lpAABtSRH5NCDTNiWW5Zo1E2FOdd2kZn8cRsw=;
        b=eV8qRC1G9Sc08PrsiJELUbqU1p5QcViBW7S6Rop037pkA0L6QE1JzbOHEuGN5lBaus
         fz5ATZIQmKIKBVWFDlkq0jjejeu6o2C+kAcbzPgnC6VqTWxeMt90I8cIPBI4b3fw7jPn
         dU3f8/4qsTfJ7eFK+2aLcuPadNFyA5N/lhlrBNRVCmDnS3H1G8zxXlhn1ecF6FA6AewX
         82atkSIm+BrIxSOtMmyLxrwKhmO2iADX20yLQz4wbZ4113m5Ad4mAKh/jTVRbSqogYLG
         cQ/KjNj2SuVLskJZ7tl/asHXb8oXMY018HqkaNtmeptQ/NsXVhDcEoWcT3IQnTBOFDDP
         1Xgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769786199; x=1770390999;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9si664lpAABtSRH5NCDTNiWW5Zo1E2FOdd2kZn8cRsw=;
        b=Q1iTmwu2tA2GC5rRxXpb6gx3RulGBSKDxTvzM8CIze6R5tsQJAZkByE9SfVMF0ZMt6
         295H7Oxo9MnJLRh28OVmCQgzuzQwT9scjz3GA5Hp/f04M8UQChzvCWOHyWJ8dwZYsigU
         CugyJLw+RY95ExhxMs730DGqIY7YK47hlZBkvPJHLaua/m9ZoIlwUSxy8jwFfqW94nWw
         Z4WXQMnDq2030nmDM0kNJ1xJB6YQrPJ0FrH7T0YrXt5T1XZ943uHTYz1U5y450isVfHt
         cXvqqN+l43LlIGt1IglWlsSS30OvYmG4kdIrro+v6imkdQRVSVtQtbyUC+j4SH2MPt24
         FVfg==
X-Forwarded-Encrypted: i=1; AJvYcCXPHwRYJwS9qe1B8WX0zmcdoFm1aq32vJW+NA0/EpAJi4pb6xxBG34lQb4ZYO4uqD3aesTFP3LbjA==@kvack.org
X-Gm-Message-State: AOJu0YwoOzXoKAOp5npvlPMwe11WkJM+xPUrHxywBQE/1NvKVdn1uJg7
	0rzgzolvk7MokoU331HQBu7h+8zLZpwWWI+NpCt9a+jHtOPNqq6b0rCarzkHEUq86tk=
X-Gm-Gg: AZuq6aJcjLAM+4GWnGp3bnINmiDw8qQhYafnJ7aJcl0+nZLcc20pRiidgHeJ15pwLQj
	OYDQYTrc/bEFmTKgn5tDliaIJoPoq28DhynaP5qeTz6CLjAPP9U7PhDu4/L0YHOHfWf8BFB4GOY
	mDvQx4gVAPMEcr7yVYzfSHBUaSzymZ1NZ0B0C5pMM5zKjAOkYNUQkxTwTfNVq/0/sQOeyVZg9U1
	n8M1n1ozR+bSldtBmc6T59wr5ONdY+s9ZJ4RJJFQ+6p7WjNZzlvfIcl4U3m92iAOEGb/19Ns4Wr
	pgs7ZJDZqMrHOAONoMN3Myvly6r9OI1kMDNb65HpHtRaW69VtuWYN0BhSiM5b7rSxGm45AccudG
	wsxBbMgaJ2U4sNSgLXLYib8az2/ngvDhrGmbrJ0CwQMW8c3z+mkEJ/Aav0On0J5wrsrbNRSxTih
	JGctRDUygQgdFHhwfWH4XPzrM8ssBroWSr1q5KyU4AdwjCEV8HlevkZM1z4OOTrfJXUF4=
X-Received: by 2002:a05:6214:501d:b0:88a:4c50:3be0 with SMTP id 6a1803df08f44-894df970109mr86470926d6.6.1769786198441;
        Fri, 30 Jan 2026 07:16:38 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033745c5d4sm58414081cf.3.2026.01.30.07.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 07:16:37 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vlqEe-0000000BAef-38VG;
	Fri, 30 Jan 2026 11:16:36 -0400
Date: Fri, 30 Jan 2026 11:16:36 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Leon Romanovsky <leon@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <20260130151636.GF2328995@ziepe.ca>
References: <aXPEFdEdtSmd6AzF@milan>
 <20260124093505.GA98529@j66a10360.sqa.eu95>
 <aXSjm1DXm6yP62tD@pc636>
 <20260124145754.GA57116@j66a10360.sqa.eu95>
 <20260127133417.GU13967@unreal>
 <20260128034558.GA126415@j66a10360.sqa.eu95>
 <20260128180629.GT1641016@ziepe.ca>
 <20260129113609.GA37734@j66a10360.sqa.eu95>
 <20260129132058.GC2307128@ziepe.ca>
 <20260130085131.GA122673@j66a10360.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260130085131.GA122673@j66a10360.sqa.eu95>
X-Rspamd-Server: rspam12
X-Stat-Signature: q79th16u4p1s6bifdxaf8p1qghddpe6b
X-Rspamd-Queue-Id: C6767A000F
X-Rspam-User: 
X-HE-Tag: 1769786199-428242
X-HE-Meta: U2FsdGVkX1+3KGMqEGZgyVVvW4bpqL5qy2W2zYEu2S/bnlIgq/c+1JlqsIotHfnGG9J3qlZ44AfdoQ/PWvT7dwZ8GXl4AsXIgjXdbXyTBSQpTEw7Gx1Bb175DqNHrwQo1WwZIN3K9Zghgo9kgimaKzsxHADGzkHQL+PjWlsX103Vww0XXtoArkXyJ9r4LdaMyom2Xcbr7wycJnyQyanSt9SUOFhkkEOoAr2qnoilsTLZ5wlB2qigC8o76SnYXwFXwiMC9l4HuvlWTrsu7I6BfgJoXhk6l4lFlDomeZnPWglLub2rTO1rk8OUuXmSym/1XxvgK7zcOHl6CUpm4/1b2gkheQ1YfDeFk7JZs+dWYfymt91R9VJrKBRyvLozjfB3CLr1Cl7gT4KW4gMLneR47xTGIpYh4t7G5rIUqHgLk0rry9DEvQENBAgIjCm6htanQYC1blTmE1kCd36v+ZSbD7MDMblh0eVoR3/TyCFjVdwJ9Dp6Hh9jL1u3n+fFEYchC5HGzKoqLZKBo0eXObSwyd24pEcappBCMjnLTOhkbbXAHH/yxXWgOKhOqVE66Vays7qA1WKfy9qMwAWxqV3VXtKd1fgozrhov63GJi2oF8b82EF4//xbT8rv4lRZq8s2bjrw3CCJrNJQgdi1OgQv/lzXi+ZXGUGxrEwbU7pTleGFM7rwrp08Xuo5jobwqEbwsANKFW2gNgpyHsqOnZCv2jNR7DLkeXU7/FBtcFZsVmE+rZFv8K1qcefW2NGAAaQgwq01W6F8HrS6EYY/qkTqY8hHL79IZXVfs97RUwGDyI0AnwLH+BTH3BU7styX+tCSyO6NViQmS0PUx/zVJ0ji5LfCkB3wqIyOAxrzROXdsQRW+GusI5qQG8RIJSbzobAWZgaeN+Q+DAE45xqbfrx8NocGI/S7hlP3XotHDxKl7zbpW03Ip+5UvxdFr62gKF/Sjj6WkJpH4MKAETmY6gR
 kA1vcmk/
 lpS3iKy/dVZT1+QOMUDJLsCUPmxHzf3hOUCGLQG1BPX6Q3rvMlA8b8GD1tcNMNGJoRta7wJ0CTuOGnOTVyDHuKn9NOcK2S7vOIwYmBpx41Kyo1Ow/QPmwuymVdFKuCIGN/8yQmjD3Fo2KBo0s/eqkOqvgfcGqAu49X5/1APkFr1O/mYU7rZk0MQoE8zkRahJkhgxrxOfppO1lXMUvVVHkl3MiGPdP9hyv11BO2N40WFne13Z6mP6Ywj+UbAgH5UJiEZAapLjZbm88NzqL6x6/k0/n8wbC0OwMJtcUuf59hdLp8WIYuBL2MHX6eiswU9/E6JB5Dy7+KuGttmOfKffyKnkJ+027Q0hggzMqcw1dxwN4qq2nz3/Pc9nBllz6u7UyR4qWv75F/H9pLkwlVQBykj6jlAbt5BKUiNH/qar4sdiD3Wl47eFFBBDHdi7AY7LcRg+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 04:51:31PM +0800, D. Wythe wrote:
> On Thu, Jan 29, 2026 at 09:20:58AM -0400, Jason Gunthorpe wrote:
> > On Thu, Jan 29, 2026 at 07:36:09PM +0800, D. Wythe wrote:
> > 
> > > > From there you can check the resulting scatterlist and compute the
> > > > page_size to pass to ib_map_mr_sg().
> > 
> > I should clarify this is done after DMA mapping the scatterlist. dma
> > mapping can improve the page size.
> > 
> > And maybe the core code should be helping compute the MR's target page
> > size for a scatterlist.. We already have code to do this in umem, and
> > it is a pretty bit tricky considering the IOVA related rules.
> >
> 
> Hi Jason,
> 
> After a deep dive into ib_umem_find_best_pgsz(), I have to say it is
> much more subtle than it first appears. The IOVA-to-PA relative offset
> rules, in particular, make it quite easy to get wrong.
> 
> While SMC could duplicate this logic, it is certainly not ideal for
> maintenance. Are there any plans to refactor this into a generic RDMA
> core helper—for instance, one that can determine the best page size
> directly from an sg_table or scatterlist?

I have not heard of anyone touching this.

It looks like there are only two users in the kernel that pass
something other than PAGE_SIZE, so it seems nobody has cared about
this till now.

With high order folios being more common it seems like something
missing.

However, I wonder what the drivers do with the input page size, 
segmenting a scatterlist is a bit hard and we have helpers for that
already too.

It is a bigger project but probably the right thing is to remove the
page size input, wrap the scatterlist in a umem and fixup the drivers
to use the existing umem support for building mtts, splitting
scatterlists into blocks and so on.

The kernel side here has been left alone for a long time..

Jason

