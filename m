Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017C4C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66AEC6B0092; Fri,  1 Aug 2025 12:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642726B0093; Fri,  1 Aug 2025 12:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5310B6B0095; Fri,  1 Aug 2025 12:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 419266B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:46:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD04B13430F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:46:41 +0000 (UTC)
X-FDA: 83728767402.25.D779D74
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D93DA1C000E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:46:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=daISxZrV;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754066799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5oUm5wK6G92WfMPCbUZUcR35sqkaEU8gvzPmgYYYTFg=;
	b=uh7gpvXcu6C+7wjZ+9PgNm85js1I1ZTHe4eti2Ye75RZGS2GI5VcJwmU5RIZjhpZ6aTFqe
	GsUAPs2uqXuLR1BRi1MvGs+1LR8WGPhJHluMM0pYZFN8TGupCZsW81hEEZ+yDClL9tJYLq
	lyZaBPnfIWnjH0kKtyIDLndpNVekEuQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=daISxZrV;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754066799; a=rsa-sha256;
	cv=none;
	b=PPh1iwSs3NzuzWLAl53rcZqQ4qi5xBMvm932urKRO9eOwDlobkljakeztxF04eUDSMfeu5
	96xWLU+iAnbRBfAHFExaeBJuTCDg1bPcZOysZsfQUumFdWVf7TNhBDbi7PzWjmLLRv11Gg
	qzCnxe9EELFyWl0pzUm+BZUF9P2f720=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4aeea691687so11983721cf.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754066799; x=1754671599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5oUm5wK6G92WfMPCbUZUcR35sqkaEU8gvzPmgYYYTFg=;
        b=daISxZrVzOSgwxgln6eQDP0ECKknkB/EfpH2br2jlGUm9UbyG24JN0q022bEdMnVxd
         Q00PPd/eTBtasMf5IHMfKanfuUxSOeyTs0fX7UQYzYLz6SR/ic91LMk0ZRXDo/RHSr03
         HjnqeM0myQKBk+bekjN0dYlkYIVGu2mHPRvDrDv+PV4Kt/IG5iB+n6CTYn48bZFAhHjr
         R9OZzs6KWpvC/iBzfdSfkcVdoO807z1m41KHTa5vnkV5XDuDUKapztVPx1JbTlglB9aA
         VJbr9FwiSdP0nl7/jvaTjCkbLjEOX7dy8ooeaXI7hGGzRkRKrJJ/4Oq/OQeRfnaK2j8G
         UkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754066799; x=1754671599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oUm5wK6G92WfMPCbUZUcR35sqkaEU8gvzPmgYYYTFg=;
        b=dYQOWT+p9OV17g9v1gzTB8CXPtxiZug5Otsja9U5OgZX7QvoWOKIR6x/Epte9xd0nk
         tVHrWcuzFra66Q4x7v9L+0Zr44e+dzUEcTJzNrezu5Wh36A3aV9Llrr2DtBbPvbga+wA
         MXB3t4HzdZhEMXAt9vLLBWt719sxrMyd1fKSXeZtoPoGXKy++1CQN1+j9ussE9j/DWku
         ePgu3T1UBJpnF+SzlVPbfPP34B49t/OtQAOVk+G/tiQUycT86Kii/ZRPiSnKaPfSL1fV
         MLpryc/Zp1B4pno4QSYNEK4vbmVK9Gnk7kp41zDjjfVxt+sRVFfpEOlubG2X+OBW0RZy
         M23w==
X-Forwarded-Encrypted: i=1; AJvYcCUUdMzlPwnjpTYPgwps9RNRcrWcTikqYELiZS+tPX/cSETi8MCKsup+fKhQD3YRzlXKwC9fA3MviQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7ouG1FVruUV1KCcf7zteaxTK5yVFVOrm/Ko6Fdc0pQsrfp+pr
	SnLwfK3ygcaTnWLkH2LAURB1IQ7LXIYv3Ba4ZCnfL55xXhDsvLsBgkHYcdyfVTlO8pE=
X-Gm-Gg: ASbGncsFLfx4epMlf1tJ1d7Yx1YHJiE6kHbNSWKBM7ezz+xCz6aNKQHch/bKQ2c62ZD
	1xiNjkWo/ovHdeVAUOZnKK/mwdqZMc50UdRmCMTa47CXjFGq1JdRKB2VqRrtXbbgEyN7J2i7KYT
	BTescgpjmDNPsFZA0jUKlWp4JkucLKSByh/jsIyWz13Jye6xO49cVesbXqjokIJk0jeDvAPn/I+
	LA53PvNpv7ghtmFyeVCymwjnXUlS8EK0nZHB7PXhkF7cAXJR9kdGkrgC6yCxTPsy5WWqQMNLzG9
	FNugNG0rGMZRWdGwdCZL1qBVjoKpsC5KyfnAKECrHgxnV48njfP+0RkIBMYDZtnEWz02DgflT6z
	TcUgQHJBlZ2gBy9TO/59f5CZnigXkAadwU8DgYnojqvzQoyq/mNX64TkB3SiVD3NzRtdf/VME0T
	+1soU=
X-Google-Smtp-Source: AGHT+IGVVOWQB4/1iDofT+YAUuJwKo0n0CGvBCRj9fO4gfCwpoC+KN12czXAx1xbZXDfGO7Jsn2RQw==
X-Received: by 2002:ad4:5aaf:0:b0:707:43cb:d9ef with SMTP id 6a1803df08f44-70935fb0820mr5596516d6.21.1754066798378;
        Fri, 01 Aug 2025 09:46:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9d6db9sm23142096d6.14.2025.08.01.09.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 09:46:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhstx-000000013A0-19T8;
	Fri, 01 Aug 2025 13:46:37 -0300
Date: Fri, 1 Aug 2025 13:46:37 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alistair Popple <apopple@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 4/5] RDMA/mlx5: Enable P2P DMA with fallback mechanism
Message-ID: <20250801164637.GE26511@ziepe.ca>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-5-ymaman@nvidia.com>
 <aH3mTZP7w8KnMLx1@infradead.org>
 <aIBdKhzft4umCGZO@ziepe.ca>
 <aIHhGi3adOiLykJn@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIHhGi3adOiLykJn@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D93DA1C000E
X-Rspamd-Server: rspam06
X-Stat-Signature: tezbicexka3f7oss1j439zj4qyohwgqa
X-HE-Tag: 1754066799-769
X-HE-Meta: U2FsdGVkX1+Fa/LII4RNA4kirpoi2+KAPiyO22xbQ1cqBAxDglo4lZf2CcmBh9vvQl8aDK3fZozQfsgNt+tCZZ0gpNlIqm8K91DZZpy0h/qbi9BiORRclBcr3L4LziDHYTxU+9DTn4RoHb/4Iv0rn/183+NWlY7W2Y3Wlqn0E4dLTJ+BHT/uj/M2PbFXOEbY8MszcCLX7ICw8Y5FBlvOXc32jXFMlsQrVLY+ftUOI6GIes0ZgiVUml/JdUiEFLzfdyyzxadhqqQUQjueqOYzwJWpwPVyTov91yy2NwK0vMpiY+H3mfhsDN0bOY3r2VNsTDTY8YgzQs2ofB4nKzDH7/vAiJOCQDf0314c1HeCoU4brSFXd2igvyDqGCQvqXg1Tqdos3p1HqqkOF9QC03UQwVbOBAsi04TIeQtRvfJlKazUGWCOw2bNB22cuo9784UCuuswVeTl6/1T7O+YxNFlYfmGK3UZSQzSP+Jopqh+7GPrCgFJyPJom9MQbmWZjlXJXZWG2GF4veAM89DF/5OBiuLDKlD9arkGwS+bgLBKkmySPettHxnVGvZwbHuUUXiIypru9HxJYMsoJFt2ZPHrvNdAfhse1xq84oLqnT5WI9OQkZmgAZ9iQiH3ED1dCICdEqm10vQgH8KY+Qh4v4pVAteJ5jMC+cZ9lFPxKpHn4CWR1T8C+TeMSv4gOYNgzdYgtx0igRRkNkDiDh8yGCGSQjkiomKlh6bw53EH7UOe8ae50ZzPEmLoVnNP/BNFIOTyP7YiKEnaS49P+j0ucNdI0RCDYbmgKhwyhKEkIfLo02p8s9WEDW2TH25kgjVv+4zZ8J7g24FQ5ZoQtDo9AW/wqaZkxx9vghkSZE8MgLpCKgisWl9G/oEutDdIcDMqx20ftYuUweH+8s3DH1TxdqBQtHHM2kJx8MY8xCA/d6LO8uOA98hpSJ4Thswedqma9+Rm0WhFtKzRm+fJR4+Q/Q
 kBxGu8Tv
 4zIn6ZY8aSQf3W7CLP2a59PlzIEvJ0ARbWk/l/TYWt/ogqw5QWapH2V6ESILC7CqTwB+tGz9P3B88Wljr+F2NlbbEhMo/o+xMXv4Ss+lbGFsvIW5fgDI99Yy6Y0zcJaFpXYSCdMGixI6yJF90rrSfqN5FOONFTED6svmbvMQ22EepDu11OECTgJ/o0GB/Dj1YZP3+mJ1WTsB7KB7n6BHK85fzREsbfzHd7g05jY+aPh601Q5b6d6Fwxv10dJn87j1x5e8C6Zs46rg0UFDeTtZXLXeekzQN1MUWaaAXB5W8cXc9X1yvBOxZl7IaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 12:30:34AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 23, 2025 at 12:55:22AM -0300, Jason Gunthorpe wrote:
> > On Mon, Jul 21, 2025 at 12:03:41AM -0700, Christoph Hellwig wrote:
> > > On Fri, Jul 18, 2025 at 02:51:11PM +0300, Yonatan Maman wrote:
> > > > From: Yonatan Maman <Ymaman@Nvidia.com>
> > > > 
> > > > Add support for P2P for MLX5 NIC devices with automatic fallback to
> > > > standard DMA when P2P mapping fails.
> > > 
> > > That's now how the P2P API works.  You need to check the P2P availability
> > > higher up.
> > 
> > How do you mean?
> > 
> > This looks OKish to me, for ODP and HMM it has to check the P2P
> > availability on a page by page basis because every single page can be
> > a different origin device.
> > 
> > There isn't really a higher up here...
> 
> The DMA API expects the caller to already check for connectability,
> why can't HMM do that like everyone else?

It does, this doesn't change anything about how the DMA API works.

All this series does, and you stated it perfectly, is to allow HMM to
return the single PCI P2P alias of the device private page.

HMM already blindly returns normal P2P pages in a VMA, it should also
blindly return the P2P alias pages too.

Once the P2P is returned the xisting code in hmm_dma_map_pfn() calls
pci_p2pdma_state() to find out if it is compatible or not.

Lifting the pci_p2pdma_state() from hmm_dma_map_pfn() and into
hmm_range_fault() is perhaps possible and may be reasonable, but not
really related to this series.

Jason

