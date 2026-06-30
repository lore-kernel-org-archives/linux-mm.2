Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7496EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB7D6B010D; Tue, 30 Jun 2026 08:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3626B010F; Tue, 30 Jun 2026 08:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492A96B0110; Tue, 30 Jun 2026 08:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21E366B010D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9171FC260E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:33 +0000 (UTC)
X-FDA: 84936552666.27.F1B7672
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA92F40004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OcbgsPKN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823591;
	b=oi8hjyoxS0aJ0VFzlE0wht4frpYhI+akCsMAER8lOpqGHuJDoPkIZVnvLNq1bA/TZrrojp
	SRFDQjN81lVNdpYUQvfX3kgs/5da+0v20sQdfIkmpKBSOK35hw6Rk/+mwyyKW+CLFvc1/r
	4MHOvcbxd+EDpYB0Jg6tRp1K1rFod+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMWcMWjKS0wqXvKb/A7eCIYAkyOK+4MAXhS1U8rn/KI=;
	b=XB1egkWkWkl40Ipl74ak/H2XofBf9r/ilSC+Ywsi/lCiN3uANP3Nq+Bg6btXeZBw1My1Ye
	LYDx3sD45RJqE/WZOmsMHizwGNxXpEjgRJe+ggmSfJ4lQnjaedJhdvYZBD3bJvywhxOQb1
	4fnFlSpAfLJsPgBC/Eg/W/jCgY6z2fo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=OcbgsPKN;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e4fd65b2bso171527685a.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782823591; x=1783428391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMWcMWjKS0wqXvKb/A7eCIYAkyOK+4MAXhS1U8rn/KI=;
        b=OcbgsPKN8OmwJq28+JkxAFMYG34JLSp8ArSpaMw8YRihmCjHRcdn1uaqcsRSDQE/3y
         hYAjKS6A20cnRquP2a66jCS+Erx4XlKVJZJ+8oxzzRhe2+qYuocJO2OtdCvBsEAgKwj0
         H0n8h7/0ttBXCbVZvF2CbB4e0ta4b5npLjhTElEGp8C3hZcKCXRm1zFF+UCmQSmxJAVR
         TWGvYDTFJuAQfw8oh34yMt/2F6XLAHBwQvOHp18G3g/wCTOkzxY/olNA7gaoi6grxQXG
         C7NG+NQYokXVS7pHDMlfQmaRwSAcpMejVTVtzoSdoh8VXIfgD7iYQS955LR3kwwZOu4o
         klXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782823591; x=1783428391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IMWcMWjKS0wqXvKb/A7eCIYAkyOK+4MAXhS1U8rn/KI=;
        b=XFFvMR75avRj6kZNlB4X3NtM0JYeM0pUNz7n73rJ634NKRVVEcabDVzVNUztgLZcRM
         7u5OzPzlaq23LItlNDhmxUZV0bRvw0ZtPtL4BNF/iKCnLFzuZIHxVNVBC1BjwDExBOeM
         /Kb4/oj1FSUrE+DvOH8kZU6N6RFPgigBNvBJJdkkcRhWSo4L35aTqJbmaxUHebfWmV/v
         rkFp5QNHNr0tFnb8dKdwkKSLBYs8GUI7eigA5Q2MhG2Aoz54LgiBEt4TjlaFQ1/hogfv
         sNGqQ0gBRxeVVz/NI4mJ1T3sqMTlYjFqO5SQQDYk9YO9QMZuUhbNeVq4b4NwAWoDGvIK
         3vTw==
X-Forwarded-Encrypted: i=1; AFNElJ+0JbqOZuTNVcRfSQI/JbIZ2U2xRcsOeX7Ipm9T4QXHCi6t9pHLSWAHj52eIfYKBa+7m+Va8ALKpg==@kvack.org
X-Gm-Message-State: AOJu0Yx1+TTDx7O6l9tpz+Jb7WjWzli87TFNtLcgU2Elgj5Ml0MTL70w
	We7sHxwkpCEQbVhKzdKE895InDNgWfYOG41Rx3+V17hCj7cV/ZETaowE+V+B9yt3FDs=
X-Gm-Gg: AfdE7cnHb39IU4PgWQCOnbl07Y2FTdTUufhQ//nLKQQSDSoLJADbwe2JvI7Go4fN3F+
	oWcD63Ld8nVsjrMOSDQXbiqbou8Z/Useo8TNUzWUAlhoK4eDlZNgg57ZxVi4S2kWSC/ggI+Qg1y
	zNNtFXmAkvhQtskQxmtNEaFRHkafFotX1RegOu/aNOxgj8RCfDFxSb+IDDbHaKsfM44H65d6QMo
	O0SOmhUS/T6ct0l0pGU3HY+y+ZeAX+XgSl8o9Wl6mlsYJodphsiyypDSMgeAQRCHrpSEWOAh6nX
	L4w341b+O2nQItyPPIOvMUdGFDiLDbwnDqkWau+P2k/5c4L1toFV3AiVXoQGBXVZBNvKYNJVDvX
	mFjCezqDMcg8YHHUllQ7LBWssA3HRgzyHczQ3KWvDPIsz5dcifOAKE34yRwesJmIKXzyYhozGRh
	Hkwq/CeHkHvutEGIHJRNxDjDBXJ6FtOZPRzS9acTekWnItCaIVYV0H7hWgLKzyq7BGN/E=
X-Received: by 2002:a05:620a:3198:b0:92b:6805:919d with SMTP id af79cd13be357-92e6280f798mr528748785a.69.1782823590757;
        Tue, 30 Jun 2026 05:46:30 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e622eb9d2sm233423485a.29.2026.06.30.05.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 05:46:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weXrB-00000001r2J-2EhA;
	Tue, 30 Jun 2026 09:46:29 -0300
Date: Tue, 30 Jun 2026 09:46:29 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260630124629.GE7525@ziepe.ca>
References: <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org>
 <20260618153049.GG231643@ziepe.ca>
 <ajQRY7tHShCEz8vg@lucifer>
 <20260619131658.GA1068655@ziepe.ca>
 <ajlnTdkbmEzy_uhe@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajlnTdkbmEzy_uhe@lucifer>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA92F40004
X-Rspam-User: 
X-Stat-Signature: koxs9ed5zztf4ti8if4fhz1451jm7f59
X-HE-Tag: 1782823591-886447
X-HE-Meta: U2FsdGVkX18v6GH+ZsOThM3SvEYs4fwq9oBYAcy1rDCtPYW0pI4LjUAGJMJCcq3B2ESZkWGe7LViRemzoOgNCH93BCXe5ukQ2OfXt8z37BIgdnlLuZ4TK0lDqts5W1L/yT4crzb8tzZRdt6DiT9VnryrqLmLyBsTVZMXTWt/rSHjEhfsMcT3bI4jB6FcK6n50voEDm7f2al29LuS+3C2DT0e+njls3hY8ZhP6rJx3WUn325rQ4E4M48hqn9Cj2VTz/KM9ICWC4y65yz2741iknrFWNi/rMxetvaXIWRYDE/r+shE9wMyrgIqSiZwPql+lfvLV7YCB/j6RGkCqrhKs8e970SqlTfD7P175qWv40b11E3MzT5kXrvppPp7XNPZPsuBI5/vSft2jvCTHwh16e6XELIBdk5L/eixH8RRKL6lSmJh1fDPa1AeT0EXxu2aDfO+Z0g3E41uXZ6ncW7x39ofzUT/DB4aDOEUX9AABnoI2KiPXl+Pmpi2rD2GSy9iqUVE8Om5HqiLmpF+RXy6yE/w+kmosByz28ULsxp/1JUJbPt3yTtWcgGXfEuHlpQ7HtloXOG7C6DKFm4bthhoIpsTvRcAP3Hy7/Dbzka6Fzho7HbP3YAJ1OHzeanvEd/aAzFiTF7qrer7UluIAmUy1g8Kn57tAYfENcHLc/sYzAXaZDriObCOTIVYVeVsDuMhsjnru98WbWkniAkaKSnd2VPeFNJz50NsAyO/QEjOc7GWpdfGVyMCA3RmWbgkNR4U/+hKtPFYkW4HwctAWoMBe171rQDSWVTdzZyzkczOtcH700ywIAUPhgQGH+jQsX/3eWmqQa6vGcJ2Xq3VZSSUx0vrL1EQORZIUUxjHzXxS+U7qZkoyTxzbFkvEi0Wh32hFic17BzrurO8RaMwCMr8chCvBJETKo2IFfL9XA5xEutb/x3ZYm7d/7KcQ+nhpan4dcNlTbA/zd++XhjJXzV
 0J5mnCl7
 zSKClgPx0Cc8r2p4XsTQRZxPm+2jqeFWwrvyC0bMS62zYqZVcFpejA/zbNLwzQlmEwHQtO4QwJBjTD8j9S24WgPn8j4ttYGocwMKcqRV6DoIPzzmBr4RL2o1WcmAYc4CV5X1lrilV+4PvVHhPHi8MzgwRxenITICfBeveFb2QgGgn5E5iua17DLzI8GCz5tB1ZnAhMv1CE3zsNlxL4e41FSzhoGzvIO0c7Ly0NQb0wJHw3/Am1hpcaVpGDK2xfKqZ8fpBAOdepmbqmINyFrd13nCUYsQ95SyH0CBrUZ113qPvoaDGoi+yf3hN6ACJo8xP6uadueybThCgYCZ23bYWRlXK6kcLg7cD9SjPRqPUU8NaZPxUqOeX+T1PTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:54:10PM +0100, Lorenzo Stoakes wrote:
> On Fri, Jun 19, 2026 at 10:16:58AM -0300, Jason Gunthorpe wrote:
> > On Thu, Jun 18, 2026 at 04:56:06PM +0100, Lorenzo Stoakes wrote:
> > > > > What you're saying is that offset 0 of the opened file might correspond
> > > > > to a PFN that is not aligned in any way?  I had assumed that when trying
> > > > > to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> > > > > mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> > > > > case would be 0 and someone needs to know that it corresponds to a PFN
> > > > > that is misaligned?
> > > >
> > > > I do expect that the pgoff space is usually aligned to the pfn space,
> > > > most drivers do that or could be improved to do that. There will be
> > > > some off cases, but maybe we don't care, and VFIO should be fine.
> > >
> > > Some stuff has weird assumptions about pfn=0 at start of the range (DMA for
> > > instance).
> >
> > Do you have a pointer? I'm drawing a blank what "dma" is?
> 
> (I am obliged to link https://xkcd.com/138/... :)
> 
> dmabuf as in [0], where vma->vm_pgoff must be the page offset
> into the DMA buffer.
> 
> [0]:https://elixir.bootlin.com/linux/v7.1/source/kernel/dma/direct.c#L550

That's not "dmabuf" that is the DMA API's dma_mmap() interface, very
different thing. This could probably be reworked if it is some issue..

Jason

