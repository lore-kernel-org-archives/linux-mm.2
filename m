Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4345D606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=f6S9tySr
Received: by kanga.kvack.org (Postfix)
	id 6051F6B05BF; Fri,  6 Nov 2026 13:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5836B05C0; Fri,  6 Nov 2026 13:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CEF6B05C1; Fri,  6 Nov 2026 13:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9B36B05BF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:43:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FBCA401B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:50 +0000 (UTC)
X-FDA: 85405568220.18.8ABA92C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 951991C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:43:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=f6S9tySr;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7Y85ZMNTmnO5vyHoGmhNUdpyQ1xa3t2s3wZRjsJimY=;
	b=KMxMxmN5Qu62cDMwiCg7+KTV8sXiEWUeU2NZE41NLMheyuKYUP+EN3921rshxrDqiMLUib
	ZwdxB4NcwHV67sFIY6ggw79sJvmz/W1heA2AoR1vyojub9fCBhHB62UNPIBG4htkPkUyj9
	oSKa5OQseFcBAFtE7WyWJxXkGF5awWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793990628;
	b=JbLWYIHPF/EyMhx/mfbgKtI4Q8Rh87qSQCMo0w7fTejkbC2y7cUiWY6mKYr8Irk6ndyC1O
	Ze7USyPXcxb8ekiw9a4N9yKSkTa77XYAvdkosfZFdc/LbTq1fSZ+9BaZNuY+zBdpHs3nVR
	IMbkZTYm/apKqSdshKOtmBX9Hw97abo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=f6S9tySr;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5363c8de563so9472491cf.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793990628; x=1794595428; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b7Y85ZMNTmnO5vyHoGmhNUdpyQ1xa3t2s3wZRjsJimY=;
        b=f6S9tySr94+jMZhRlTX0KCKTdVR17uB6Qov+DFTzTLJ+D4Z211dBUNoS+0sjhJRmTz
         YNQS6U1qioDGQ/W/y8A/hBRjW0NIwYIVAA6rU8HNTbDXi/XU9AWtimzMpRjCVYhOwLtc
         lx75xg1V0jIRgAtOLozVfuty2I4h3syV4JykNqLiQaVty0NiscaNzg/VyY35Y1gvCJxE
         fV+J5G0i49uMd9CDIpp/uOL9QT6cqPxK2+1UMiY1JRgVlNioetQxXro2Joc0uUGgWA4+
         Nw/UOAFGrzUbZd58NKeccn/rr34uwc2Y/vRXZSfK3M8A7gY7xoHu4XIXsXReWFF3Y4w3
         lvGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990628; x=1794595428;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=b7Y85ZMNTmnO5vyHoGmhNUdpyQ1xa3t2s3wZRjsJimY=;
        b=hdfqqdIl1EXUJrbWVsbmtFbVvfeYsUwLCvO7soUh3kz9LPIJpO7o4vHty13CIHDzca
         pWgPACjl3UFQn/kUtzANl1RZcobwenN9MhH3NGQVtdorem09YYlzfJhg0HEK468ASj3E
         +Le7Oy6GOXjMamfmCF4sqlFZ5jZxFTzUvzzTlvlj3Lpyluovd2FZcQgK6TMNfltyBygB
         wbTxsvSwYlf+DY8RdLYt3EHP/Wrwfkt6sUwsTKfhJkVUbyKqBGPouYDZ5F8S24+aB4MA
         P7UpXw/eog+EerdiIaxpgBUNtYFyhhipiRdavBukbzO8RMO0yMa2Oqk6aB65pI18pOR3
         pK2A==
X-Forwarded-Encrypted: i=1; AKwUvBz+sVKmnrp/dQ1+oynVWmx8u0wgrxXhfxsDK/7fPQUFvpr/x8pJ2mbcHt24l6FaatpeJI46T03RsQ==@kvack.org
X-Gm-Message-State: APuU4Z8WDkZhQkxn6zaTEiS1b/YqoI+xtlt/nwOTcP93et9B0DSDUYcC
	LIJQlmuqH36as9BffJXQilWCSQ/ddI8dKpPyuhXXyPblrAkWN+ixnLPYogjGwrZ+PAE=
X-Gm-Gg: AYBFou22FUYVMW28ISOoiZPE83g8UYoAYzfr5ZgS/rone+i3rdgY7GkhYfKe021fxxr
	E2+syNRK8KnFxZMqOYwD6+jAGKbnhCQf+PkfRXAXA7qSSBNovnNVQ739uOB763C9EJ1eWnK7xk8
	kbjYzfK47lGzI+IV+Y0z0+yt3kiqW83VeWjUnHcO5iA3hnj8AC/i8MZFiZd18pJbfqQ1u5+4ZTt
	dkYSRn03BLTmW+8lJU18LJ4o1qHN4Pz5YsAwZsX//Ls6qxCVH1UkSmWF72qX9Hqdw4yOv/iYlQJ
	zbkvjliu/JbsrivlvrZHOQ0din59rxAR52r/dun0CndyxiHChm6LoH1fr/DuU8zjdYoWTMAUSae
	q/bsmn6qhzKKSlngbiLRdbXG4hWqlKhFBRjIqQZ2tc7Qd2Vd1iiWdRk7+7X/S7GM1B8x2xhxSS3
	5ifqGdtAVjvanXtWTeoh2M2TAJ6pyGD5SYIF6+6oLxXn/FOCoumU+XOLKq7QlvCbEsqD1EYiA+2
	aSoVqDdDtyAc6dxXG9/Pv98KUuGWm+TBPRIeH04q6L5GXFy9U9NfFmYusAvtI7V2OUtQgd65XET
	XKmUlnuW+y2Pt07/UPfNTyfxfl8sxYuEroh4i6dIkv1x6/IVIEb+j/MOExMoR5rAy1/W0/ysyrT
	9Wy3TzKhbGg==
X-Received: by 2002:a05:622a:47cd:b0:536:764e:1527 with SMTP id d75a77b69052e-54e14a6c486mr53004081cf.44.1793990627606;
        Fri, 06 Nov 2026 10:43:47 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e25785f14sm26823821cf.5.2026.11.06.10.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:43:47 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xPOug-00000007JdL-0xGY;
	Fri, 06 Nov 2026 14:43:46 -0400
Date: Fri, 6 Nov 2026 14:43:46 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Naman Gulati <namangulati@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Luigi Rizzo <lrizzo@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
Message-ID: <20261106184346.GJ663069@ziepe.ca>
References: <20261023140107.GC3977851@ziepe.ca>
 <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca>
 <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca>
 <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca>
 <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
 <20261106180714.GI663069@ziepe.ca>
 <CAMP57yW6Y4g-xM9YTB+MpgxPN7RFeEWhAPWvqrfOoMDEuL8HZA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP57yW6Y4g-xM9YTB+MpgxPN7RFeEWhAPWvqrfOoMDEuL8HZA@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: jxgezt4ogmptjdgc3sai8gjsqd778f6m
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 951991C0002
X-Rspam-User: 
X-HE-Tag: 1793990628-673297
X-HE-Meta: U2FsdGVkX1/rveGD3TUUsil1n8F6sXKcW2Pt+ShbK7JOSblp/CKkNRYBdsiKRW1JHXiBYD2e0wvZ7IA+qjGxj5qnDe1a1j6iK+b+JQByNVb7aNcBOdsbYNrsiM76rMLHrl/OVDqGtzxXlM6vncReRQchtnk6C7Yti+KkrYhtWCVKO9PBUH2h2zvIIUYop8RyWY8JmRjibvLX1JsT7qHCjoruBC8AskmT3iPMlnFQyEHl0B+PIvkbRxZUVZNrwv7H4OMWiwIMfhW28krGBjWVvMxqmn6RyWIf+cI6qcXdiqXijg6JLPjojtbmhcBbARJT+mjjCCimMPv7XPIAgkQvG2/KxcpADQv6TgqMq2ZP1t5F50GMVk/8pV63fSrzRyFS5OLoCTDuEv2neQHFjYi6ZpOZZqtcjemAzvlJlg8lC4WXyMXtf3sK5LaA46RyhPKrF2QqIWw53gp75AlWZ7KhtlGobcjg7HSndx6GLO4PAchRrPmgB0m3kNs5/Sp/1SI3Kc9wq2EkSkbPAxrApIbcAjuTIa0i88rh7E9R3L5eQBYG2PwVoS3KZTTn9esZjNWPRFoFPIVqcFh1Vki9zFfV9V9E4TgUKsA0TqXr430axfmfP/Rcotb7d0qvTYjT/7DjVyGSxID7n5Dwwwgv4Jb+/kNy3GUBxILvmQZR6x33W60wGDGPXJukQFThlbySPSfiOlPEXnVgZTsh3VDR4YWYfDltOsCS4TMnVLxakuIrLPNDhLG3u93GojAgICwXOp7ex3mUoStyTj6KncvpG7L1m+UXmPiCOsnF5jx2B9j3V2e0VrsRAwtnxqW+G7G9Z5cIVUEG1dHWlrmu05sCMItzuZNVn32XigfnmtuvLGV7V/NCBvl2YTdJ0OLXuCcUUeli/z4LJhG1APNze5fUmchlmpj6WbSMES67xYHqzTC/HKRdv7keo5WaWzv9G3fRu7inf66/PCwwdFOFAOQfgLo
 Tl5mLPGf
 xBrOWhwCn1YjuAH+NNcPb/cycb3rKlBwCV8fmG9N2qrd4uU5L9WAHidJKtOqCyVTtboeybiC4l/Ru8GHbzxEAQ/wqCofnrbLD0TErV2RQ8Isc9BlVfZQ16PLq+ciZe0yzcbYaw4jw9GwzIkLQJsX8Lv6zvwQws5Iyyv7DHHm5GbvNImpSB2uS45kMTg2dRgLa9ikPs9JqRp3xL/IxvaV0X8+P2rxSKukbP7M3otUjCAlDNC8nnMi+VdofW4mMPTFAoc40jHgrwuyayHWxQpzFK146bRVVlc8JCIqoqPwExLtdNi26BvP8xz48NGszl44yNqqHj6BsyxQY2jm31pa1DVBULDoEen+HInDh3XoDd/UemKljbV/rU4VQ815tBisFhZhOXP3wUxEiLOq/3IqhLgyY4BnYK6gqytOoKlFB2XULQfZ4ek4o6hcwT6WVkTG7BcsuFmybFPStKovCUby4kxg2gw3Rb2jMW98EWaMhg8kPyCyAGA0uMwdKxp1Oe28OMxL1Bg1LiGoVSOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:17:38AM -0800, Naman Gulati wrote:
> On Fri, Nov 6, 2026 at 10:07 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Nov 06, 2026 at 10:00:35AM -0800, Naman Gulati wrote:
> > > On Fri, Nov 6, 2026 at 9:31 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >
> > > > On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> > > > > I drafted an implementation [1] for premapped TX and RX buffers on top
> > > > > of the existing networking page_pool. It is implemented entirely in
> > > > > the networking layer and extends page_pool as the default RX
> > > > > allocator, to the TX path. There are no hooks in the IOMMU, DMA or
> > > > > page allocator code. I wanted to understand if this implementation
> > > > > correctly captured the feedback on this thread. Key components of this
> > > > > design:
> > > > >
> > > > > - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but each
> > > > > chunk is mapped once per opted-in device through the DMA API and
> > > > > records its IOVA for each device, rather than using a shared IOVA
> > > > > window.
> > > > >
> > > > > - TX: page_pool accepts a memory provider for pools that are not bound
> > > > > to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunks
> > > > > of their NUMA node; TCP copies sendmsg() data into them through the
> > > > > task page_frag and allocates its skb heads from them.
> > > > >
> > > > > - RX: an instance of the same memory provider, sharing the chunk code,
> > > > > backs RX queue page_pools. RX chunks of order-0 pages belong to one
> > > > > device and NUMA node, and are shared by that device's queues on the
> > > > > node.
> > > > >
> > > > > [1] https://github.com/torvalds/linux/compare/master...NamanGulati:linux:netdev_dma_pool
> > > >
> > > > IMHO the netstack should never read from shared/decrypted memory. If
> > > > you put it in a SKB you have to be sure the only touch after that
> > > > point will be a DMA read from an untrusted device on the TX side
> > > > (sending it to a trusted device would be a fail) and the final copy to
> > > > userspace on the RX side.
> > >
> > > That's likely a fair callout. TBH I'm not very familiar with CoCo and
> > > will spend some time understanding the constraints. I kept CoCo out of
> > > my implementation as I approached this solution from the overcommitted
> > > VM problem where we are trying to overcommit memory in VMs and use
> > > these pre-mapped pages to avoid using bounce buffers.
> >
> > Why does overcomitted VM use bounce buffers? Do you mean this is
> > about getting better memory clustering in page pool since the VM
> > paging granule is 2M?
> 
> Not exactly, we are trying to use VFIO passthrough NICs in
> overcommitted VMs. Since the guest memory is overcommitted we can't
> dma-map the entire guest address space (as non-overcommitted VMs do).

?? I understood you could and this was implemented under the
virtio-iommu by pinning the memory under active DMA?

Where in upstream does the DMA API force bounce buffering for this
case?

> So overcommitted VMs can use bounce buffers to have a set of
> pre-mapped buffers to bounce traffic in and out. We're trying to use
> this solution to map pages dynamically with virtio-iommu and recycle
> them via page-pool to avoid traps on each TX/RX and avoid the copy
> cost of bounce buffers.
> 
> This problem extends to generally reducing IOMMU overhead in
> networking - taking the dma map/unmap cost out of the hot-path and
> avoiding IOTLB thrashing.

Sure, that makes sense, but just having a pool of entirely normal
pre-dma-mapped memory is quite a different problem from what launched
this thread...

Jason

