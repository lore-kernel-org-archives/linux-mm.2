Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD108CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125138E0018; Mon, 17 Nov 2025 12:16:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5418E0002; Mon, 17 Nov 2025 12:16:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06A48E0018; Mon, 17 Nov 2025 12:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE5118E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:16:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 844181401C7
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:16:23 +0000 (UTC)
X-FDA: 84120752646.07.0951C9A
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77EA64000E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:16:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=g2kUsRwU;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763399781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1EKuTl21MaZwOVAnrWkECo68IZFcqZRr/UNlppTPmo=;
	b=gDn595CbGzrCZaVknkqBj7GFiU1PcALGrzlX3IDmeubIoW4gpom6suo3OX3bl+TRNN0NAT
	WeT3820KzchLQVmv0UQ4KE17zVrFQVc8arFb6aa47hUbyRoEacRvyT9TZNFo0AV7LNPtn6
	vqmW15OTxhC1E+EmhRT+I5MhAvlY0G4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763399781; a=rsa-sha256;
	cv=none;
	b=NG03ktFVKxvbhluwNePjgWh4DjwBuDx5BvigP0JaBYmh3q+Y/qwdVWCYGPt+ZdgZLnO9p7
	ki5J6rD/OJ/DM3k8CfnfsHif7imHVYgwBhgCgQ2gBT7SRDf5WiQnbb/tVb9/GopTKDyFj5
	8UgoupWzwSxUVYtRWS7Pfh0nwjkpBVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=g2kUsRwU;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.174 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee18a21886so8188751cf.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763399780; x=1764004580; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P1EKuTl21MaZwOVAnrWkECo68IZFcqZRr/UNlppTPmo=;
        b=g2kUsRwU/soYKylS1KCbjwML5Rm99sWPUpEfJsT/PVqfJmmhdRVUUbkfe1lVYu9XP5
         B4ckp1I9RbZjfWzvHg9AMOLS5XhDWZLrydvB6JYEb6AZhGAgvb9F+NxeOKZRoek9Ylr0
         7ASEx6MkHfr0U+nkaMq4CTtEG+wB6nMuMhGoLAhNOcJ1SwJZEv6KDOv5FgD1iFRkLZqA
         2aEXJFyOISb8FF/1QnwGOdrIoVNNJg9LJ11NCh5FGLp523mRiXXFGN2aAtTEZ+tCAuIB
         9R3n0UQ+Gg6DqS0wMb1dfJNmyrw0b2nrbQ5SMfOrTZ6qayEYc0rG6b/vRiYj2v8kyVsP
         1FLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763399780; x=1764004580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1EKuTl21MaZwOVAnrWkECo68IZFcqZRr/UNlppTPmo=;
        b=nxCZj9cEWW2fvlJNiKZt9VtXv0xQFST8B2M/YI95zQXr9TpHKdgVz4qU2lxGHE6+WE
         zFhpW+dUsU8ae5NFGpr+dzuKABJN0UMbiEpJ21lpBAQeJZSXyQg6OUjmD8BeOM1zTS81
         RHDVD8CTdzmhuWd8mK6j7xXC7paihZ424v5K5O49pOvFSYw7qqn7T8g4ezBk3BSoYW8n
         QnPEnGOnxwDpl5iawwC7fm+H2mBnk5nCIh9b5p9I21HyVxiiPaWSdsVVALrxWU9oAd/7
         JiIl3KVqY0+VZ6lZPaNcl/IG96A7SJXzu5yCZvHqho9suk698e8ZbAYcE7sm962ZJqrG
         D90Q==
X-Forwarded-Encrypted: i=1; AJvYcCW15oqQORucmfHJYndmgbh7uoBJfIeYNhS0l4OpNaZAduNy8/gJkd8zPFDh/cjeYvVkNorCvbpoWQ==@kvack.org
X-Gm-Message-State: AOJu0YxRYAFbIifqc9vsZjRvCOA4hRMCF86Tz6Fud291hk9Kij/cJRIw
	hx8+Y8AZl5csFRN8lvegarBDNwSmLU6yTMg8gZKbpufLgpNyZH8eEZICLl9G6GKq0yvCP4NT2ut
	0mKOiE6Ew3A==
X-Gm-Gg: ASbGnctZLdQPpvl7it0NM48c57mTS4Y3MIcXLaQGh37z6fuAbFgwcBC32rTLQ6ZHvhY
	Kqt+5P4gKuHdokQMjVP9bfceEjhshsbNYYTS8ev1BGKdKFpWXNELKQg8B7CG2P2Vwj5dWJP7bBv
	hZ52e0aWo+s6KxxvP7uF0TGI1qa7yezKlA5ks9lD/Iix/akm+8AKEHqPn1MbQDqtjY6oJz2ztS6
	vonVn9xe3ZToyArOl6YH/UT5ibxBPi9/IQ0OtKla/tX4pci982okPiRA9ZnRXY9RRKmmzuuWNHO
	ECqLJwsXX1uMqF4s+NNQBOvsDZp5DYkECZR3iufmADc3CNbdPiDVdCvGN5R/op99QlqgkkwYxv7
	dJhxuCMQJgxEezQtqyobrbWwqPgUCcvPNpye19vydRFTjjYJbvh2cfujjCNj3YOmKH6zA4TzvMJ
	okSMk9YWAOKtnUCwAWJdkq5hPv6WeLf4Fhx0cxI1HLz3yGKIEwKMQRLGa+
X-Google-Smtp-Source: AGHT+IHdomOA3fXFLRj5Qifi24Z8ILoy1R2tZQWL9HXByV1pnhKykseLX/aaxM1vhUTUzCoPwrvJjg==
X-Received: by 2002:a05:622a:22aa:b0:4ec:ef20:ac52 with SMTP id d75a77b69052e-4edfc87511cmr159168241cf.79.1763399780286;
        Mon, 17 Nov 2025 09:16:20 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ee1c21ea34sm32656311cf.30.2025.11.17.09.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 09:16:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vL2pv-000000005PX-0G4a;
	Mon, 17 Nov 2025 13:16:19 -0400
Date: Mon, 17 Nov 2025 13:16:19 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex@shazbot.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v7 00/11] vfio/pci: Allow MMIO regions to be exported
 through dma-buf
Message-ID: <20251117171619.GB17968@ziepe.ca>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251110134218.5e399b0f.alex@shazbot.org>
 <da399efa-ad5b-4bdc-964d-b6cc4a4fc55d@amd.com>
 <20251117083620.4660081a.alex@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251117083620.4660081a.alex@shazbot.org>
X-Stat-Signature: ra458wsf83jds74kswq5r3moxseaww51
X-Rspam-User: 
X-Rspamd-Queue-Id: 77EA64000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763399781-124163
X-HE-Meta: U2FsdGVkX19+1gR0iUoqp99HthOiP+AWDYNGAQvCKL813ZUSZhkZV0Goxgyplh2oN0Hm864PZHULupIMtKn0uRT0x7HbG60y8P+86C6cbL4vLptGGpJjcElmAVUJHao6P6KXNoGs0C/ANC6BJBYBALsJeoiCoNMZo6W1n/1wfWToYXEektUUkAvOrRELKhsxLVO1qTlR8JddCm9yOcZ5WGWLQrdtuRuMI9kXQKhzqFYMkmzaQcrFJcwIVNLqyaGDn07HJApZV8z6E7PM1IVbwpmPZWnqJDwT+v8aCNDdGT4GblleBCZX5nvGvVCOvpKNcXuCwDQQC/CBxTw2/YKHAMNA9loYus1a8QIPPtZG9wfeTKbF2we6/+GhRr0rm7lRT096w2dJMZIbIckzbZR7z9w1utSdILGK2pmJVPxv5vPUkdidmEY2pcmU8eYf8ltaRQgiSQfAX6c2MzBbnGYHtxqcog0qUTUoFnbZ8ak92BXWEb1LZw3GT3I2kHQFrH5nv8UhNhyKNj54b1voqK131vQdb4bFkPeoevbhXN+rercaZd+U5ptRg4c/aytrGGxOlMrlg2nZZjcPET2qVLMF5fL0BJVQN440boidJ5QoLtpfDtR9lu4B64jMaCDwLFxcGFse85e2sMbNp7koRkBRr0iSXBd7DI27bskXjt0KYPmQiranMSK1lnU9tgTeuve9sVVyiwy60th7yWu8Xs+WFg2cVF5XUgrQQMvI8TXJ/qRC8dXgOgr8ka1ehunY7Q1gDTAOoe9QTTigoRBxq1+tE9hYKhYi7/0I80H4vwwxCs7n/2s43EjlZk5/OF604aBxVZk2CpAI1zO+OscEg0awsJbqlcFT594o3FWOeZkiqLl4Ax8PgHWLj/sEq30NxaEIYPccuxTTnhGK6bX3BqUuVqAbB2gkq2rpI33Qif2C8pYthha0LEATyMuVPTi1AOXCpa377tU/HfvIGcyM0ow
 SKDTA327
 4OUPfdv8jua3AYfGoOLx66hz04Fe6DH8hYhLFk24kyldtK5ZKRE0ExWQxP7drffydSh/mEfPbQ6YnjNaWdvufEDPgdT691T0+q/2JbdviQ2Qi2h+YLFwV6vLknmlW4odyRXgeD4j7P+JS2L2ND7KvOhySWdMVFvvscWGnIFzO1t041CYUD6iYosBIkb7hSIy8/kApnptkJHj712AMpxwN2Yyf/xKZrl/2+ZxS2kYzZ2KGgN6PklGJdOG0+O1IsClQHy/IgUyPaZ4cZUmfwCYW9m2vQOgVMG+ysyliebGt85tt5TrdNYMcaQfRAyyyn/FEcRCz2ORP4zf4A5STEi4So1mrS/ydbM6BjTakQleOEw+ikQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 08:36:20AM -0700, Alex Williamson wrote:
> On Tue, 11 Nov 2025 09:54:22 +0100
> Christian König <christian.koenig@amd.com> wrote:
> 
> > On 11/10/25 21:42, Alex Williamson wrote:
> > > On Thu,  6 Nov 2025 16:16:45 +0200
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > >   
> > >> Changelog:
> > >> v7:
> > >>  * Dropped restore_revoke flag and added vfio_pci_dma_buf_move
> > >>    to reverse loop.
> > >>  * Fixed spelling errors in documentation patch.
> > >>  * Rebased on top of v6.18-rc3.
> > >>  * Added include to stddef.h to vfio.h, to keep uapi header file independent.  
> > > 
> > > I think we're winding down on review comments.  It'd be great to get
> > > p2pdma and dma-buf acks on this series.  Otherwise it's been posted
> > > enough that we'll assume no objections.  Thanks,  
> > 
> > Already have it on my TODO list to take a closer look, but no idea when that will be.
> > 
> > This patch set is on place 4 or 5 on a rather long list of stuff to review/finish.
> 
> Hi Christian,
> 
> Gentle nudge.  Leon posted v8[1] last week, which is not drawing any
> new comments.  Do you foresee having time for review that I should
> still hold off merging for v6.19 a bit longer?  Thanks,

I really want this merged this cycle, along with the iommufd part,
which means it needs to go into your tree by very early next week on a
shared branch so I can do the iommufd part on top.

It is the last blocking kernel piece to conclude the viommu support
roll out into qemu for iommufd which quite a lot of people have been
working on for years now.

IMHO there is nothing profound in the dmabuf patch, it was written by
the expert in the new DMA API operation, and doesn't form any
troublesome API contracts. It is also the same basic code as from the
v1 in July just moved into dmabuf .c files instead of vfio .c files at
Christoph's request.

My hope is DRM folks will pick up the baton and continue to improve
this to move other drivers away from dma_map_resource(). Simona told
me people have wanted DMA API improvements for ages, now we have them,
now is the time!

Any remarks after the fact can be addressed incrementally.

If there are no concrete technical remarks please take it. 6 months is
long enough to wait for feedback.

Thanks,
Jason

