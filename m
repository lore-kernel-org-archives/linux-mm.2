Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B91D0D16D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42F76B0088; Wed,  7 Jan 2026 15:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFF16B0093; Wed,  7 Jan 2026 15:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFA26B0095; Wed,  7 Jan 2026 15:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFEB6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:24:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516361AAFCB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:24:28 +0000 (UTC)
X-FDA: 84306295416.05.3726AD6
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B1F240015
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:24:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AGDZNWPw;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.193 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/u8/mdCRbNm8MvpUWRoGYHAWAojzapM2ntHzieeqBkA=;
	b=0/DKXkyuksniD0QUUJk9MB04O2qJxX6LB2jPdCsGtlA0ItQClYtZtgcf7wNWU3Dpc26YJd
	S5Fjokd7EyuJCWPSAGKS0ywq7JbwEkOMbDJ/289zQ7SLVZY/aOUnxVotHoXaGHdofk/eLR
	WeD0/aZNpddqkh4WBlcSKsoktljeKfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AGDZNWPw;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.193 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817466; a=rsa-sha256;
	cv=none;
	b=3a8wCjErDw9Mz3k9mdmrwmZHBNrhotoqMhAcjUn5sI58xSf7gc+GflYs+tne4GjsCMFNn3
	fyUqPBNF/NDaVUx+BLQzV+oZvn0Bo0Z1+bUOOG/uaJqNu/9fcQtg7Lo84IepRHT2DYhsoU
	iUSNljg/CQ/dhS0OPe4AbZurSuPPV5Q=
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-8b2ea2b9631so274900785a.3
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 12:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767817465; x=1768422265; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/u8/mdCRbNm8MvpUWRoGYHAWAojzapM2ntHzieeqBkA=;
        b=AGDZNWPwvYEfczc3FWPAJY8tMUbkyeOUN3suj6x5C693hgE2zLoAT96tB0EvSRHkBq
         hUCnBIrYdW+op2f9Ruw7Ksx8yXzMd5g2jV1MLH77WIJt4OGFDh341/40f5mtZJ4soKBy
         dvwLFJIQFipIsHVYbbR15m6HirWHat0IiLoLVp/yKiR2G5fnNn7GNtUox61ecdG7Z4eD
         M9+oBdwqtnfVbv6ZWXgMkqoRqx2LMGe3NIx+sP0EBLspWFfWaCa16Mjw1Wky9OQbbG1D
         n87yXrQ6Ig8RzUbSJ4bjQ1MF0YxdP++aC6QO6uXWeyenmnsf3hL5yb/P1p9iDhBHP8ax
         kR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817465; x=1768422265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/u8/mdCRbNm8MvpUWRoGYHAWAojzapM2ntHzieeqBkA=;
        b=LCrlQ3KyaiXrt5wd4OI3B+ikwgfbDLiZZbniOaKc+NvoS7kTW8ap4bZtKQWnRuQ1ot
         IENLkzyz0+cJ5uTJ+bQkMl7aH6K/E2iFgEnP4d5M2V8ufsxE17HDjkLnDe7BsKztW7St
         QFDKY03YB3ONigTpIcn2L4UHDgeD2Riz5Oio4Az2zdxiBcWR02yIbNz15IfRpeneIGo/
         ertHpDfoF4OfA/Bwm4VsB+v8584L3r6E9BIyCLvzy0BkTUIGDULSEaTjzyQag2l6M65W
         kaQWaYnrBhAyYdieKUbyQ0SflNaV0bjd+S1eXxpZ0S2Fsifxg1X8amH8+09ZNZn+4nYQ
         vRSw==
X-Forwarded-Encrypted: i=1; AJvYcCVDArgUYeA6qGvMfBckVBQPPA8Uv2nyzmJbnztdwlD2/qb/MITMfk8Vlcir776WMPAfleuBjdoCCw==@kvack.org
X-Gm-Message-State: AOJu0YyE0Iv8PNUxvZcii5HiLjHSEfuADj6Op0mycOUQ8bW2lYSZDIC1
	U+yGExYvRboMvtYpHARMtHzhEO+81dcX9Skt1YC4xXkDclW0s27EMRHPfQB7yudPK+w=
X-Gm-Gg: AY/fxX7y05pHiv47W1daM7E7hvSTmMH1/33FeZJkI+s0JD2IhrFXl1EvoyI1M5nPoCT
	nAa59i2/PVTwhd6hB1tPpvmF6oozQ6RMUS4XdIillswYsrm+5RPxgeLm9HXNewqGUc8Rdr2QhwN
	aBIaVuIwF/oE51MRtr2LOs24Ki4PYQ97zqQ5Fh/gXXG9xIAcA1k+tqAkUv+ySueNOVLaCnRNpsw
	Zcz/763T+vcwpbqRBVbmyjuQsBUUbSfu3OJynlUJJwbKkVYadDMzhhd3U3IE/X/ZWCm7++OG2JY
	KpdfloWaLYJKpMiUQsPvxEzO+4fCPon7WSM5PHtT+OE8AnlAJnk4qQsSgZ0tfsg99BYUyH6c59b
	Esd2rrn2+I9cE6w3ImuDO7+qds2M7/NCndoJCQEpZkOKQkqgZ3QyGHq6YJTLkL6bqiuTuzgkGvT
	tI4Q6BccQjPaXqW9IqtzuzoFg0+uTw/SK71t4ZP2PT8yFZr7JCpE5gnakBIY1rUftBNfc=
X-Google-Smtp-Source: AGHT+IFkPMUDNbhV7qApG1EaAD4bH67XKeWGZyq9t6Oa6ftUcT4ea6J2MjhLCsI7jETaTx/wz1BYtw==
X-Received: by 2002:a05:620a:2681:b0:8b2:e669:987e with SMTP id af79cd13be357-8c3893dcc02mr421767485a.46.1767817465357;
        Wed, 07 Jan 2026 12:24:25 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51ceb5sm470433485a.35.2026.01.07.12.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 12:24:24 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vda4u-00000002F6i-0YUA;
	Wed, 07 Jan 2026 16:24:24 -0400
Date: Wed, 7 Jan 2026 16:24:24 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 10/13] PCI/P2PDMA: support compound page in
 p2pmem_alloc_mmap()
Message-ID: <20260107202424.GC340082@ziepe.ca>
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-11-houtao@huaweicloud.com>
 <07a785e5-5d2e-4c81-a834-1237c79fdd51@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07a785e5-5d2e-4c81-a834-1237c79fdd51@deltatee.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B1F240015
X-Stat-Signature: g555z5phofwkopy78d87m3xrkjbxnqjg
X-HE-Tag: 1767817466-913989
X-HE-Meta: U2FsdGVkX19QdKsFtNk0CLrKAq4wY0Hf7v/+mFrBMVVwztziBRglePh5uhXg9xmT/1WesmbwreMhEiLWUt5mumNbNbyyxZpAV8X4suTrGakbGKZfPTyH6TFi/IaTvRodZQWH49yMHc4iAu/lnQlC6cYJuaKN/K51ltWYqIDZ13poRFq1u3fqz8XxfyatXLHZqio7kJ33Nat35M0Lqv0qfmKTL3Oe74K5T1lM/N7JrzRTxNjtOseo3ojH6JD3fefWMTSmAXGBB/pUMmvJxVAN8ughf3utyu5aXaZJTpvqBZZyFKfwJs2NowV8LwB2oVWlMD9Ynvn2co9ILIjOn4FGc5QAedWsJi8G1/97tPxQTN+Dy5redqVDgH0+tCah45SGAtLMonLAH+QVugPvbTLELk41oH0MkDjI7XL5hJftE57+cXkzE58d5uKtjRV2Kg7XtACri82ETdsqf/X57OTe+lmNn9KdNRA7qEFpQKuBWmF9DzLN/Sq1PwN6rVPPNlcMAokYTnCBZu0qMy9MHRWgX4mHR4LiEt/jeNSZtie3WGDOLYYlnRemk++G4ueY4hCv5b1mpZyQ3MccpFnJnH1IJrj8Hh5WW32o3oF9B3jB8g8Zj0wkqZE7B6rwRdCBHIhxYnnIdzqEQcLmOELAiq+c/pgS2nUZMoUw/DfWS3eB8ml/emCBYJLMSLRKCGV0U0U2id7qjzKMS2eouqsAEncnxdZTCyn3k98ijRXQ6iVZJyQCG2jSyEMum4q8RJpSjdTqfUM2VIAer+7jtNKjsX2XTXQJfjIGiyyBzY33yWFrqYU14rR3zQxx71rOUw7lYKLYPMq0OHhIfHGurnaC1EU8+Ds5+0v4e6QBC+aY6M1PNvqs4AyE3bFsYguSZ//DtaDEVaYVkxmDLOEHI5L3vvY3e6mypeOccKzfwKcvyDMJtBTMhH3e0he/pewWaI/mLp+aaVmxLNg/mIMyoe6DEQP
 np9oVpLN
 xkqx2k9lPbBWL1z51QuD1e5+ny0MLW7dGRYU5ora9bkQOo22mUQDCfIPSjzOiq1rN/VduJz1Yk3AkQduAKn2hR8Xf/X/wrM6mlPjGuwm2zjlmRRATAVNiqvQUDO/o8Oeu1vT55Da9O+J+2xv7gMW5TxHjZxJ35R2m4QPLL7aTkx+lYBMdlaIrj6dm47tijB0SoYeDv5hhUc0OBaYPUtGrJ8u1JNIF4rGX4jZKGPuZ9BBn0dV2V1aQ2owfnsInyku3yjEx5k66VSI7hUMllXG6KhfAt3oZ248wNQYZ8CWbjKiwQaurN+aisDP/hqeYBT9L1wqFWcbJ0huLx8J0mkTr3rFU8Qin1YwisZSe/bJ/Ji4ClkkMWI9Es/w1JhubFuVYEoj5bZ1MQ+KPLyUqHAyorflX/oRjUZY5axJzs4H6UB0O2gage5VNO6g2INalPsHlb2ThE1JFvUVGJOpGgquJ8jZvZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 10:04:17AM -0700, Logan Gunthorpe wrote:
> I would have expected this code to allocate an appropriately aligned
> block of the p2p memory based on the requirements of the current
> mapping, not based on alignment requirements established when the device
> is probed.

Yeah, I think this is not right too.

I think the flow has become confused by trying to set a static
vmemmap_shift when creating the pgmap. That is not how something like
this should work at all.

Instead the basic idea should be that each mmap systemcall will
determine what folio order it would like to have, it will allocate an
aligned range of physical from the genpool, and then it will alter the
folios in that range into a single high order folio.

Finally the high order folio is installed in one shot with the mm
dealing with placing it optimally in the right page table levels.

You could use a heuristic (ie I'm 2M size aligned or 1G size aligned)
or maybe use the MAP_HUGE_2M/MAP_HUGE_1G flags, or something else
perhaps.

Don't follow what DAX did, this doesn't have the limitations DAX had
to work with.

I also don't think drivers should be open coding the
vm_insert_folio_xx() stuff, the mm should have a helper to accept a
folio of any order, the VA and the phys, then install it optimally. So
don't export vm_insert_folio_pmd()/etc please.

Finally, Peter Xu has been working on the issue of setting the
alignment of VMAs when they will be used to hold large aligned folios,
that would help this be more useful by avoiding the need for MAP_FIXED:

https://lore.kernel.org/kvm/20251204151003.171039-1-peterx@redhat.com/

Assuming the folio size can be determined early enough in the VMA
process, though Lorenzo's recent refactorying here into mmap_prepare
may be helpful.

Jason

