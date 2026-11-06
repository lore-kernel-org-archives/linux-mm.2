Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C69606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=ZlyyzHdF
Received: by kanga.kvack.org (Postfix)
	id 2BF806B05B2; Fri,  6 Nov 2026 12:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2976B6B05B3; Fri,  6 Nov 2026 12:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADEC6B05B4; Fri,  6 Nov 2026 12:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3D156B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:30:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72BB3A75B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:30:59 +0000 (UTC)
X-FDA: 85405384638.02.C5B85B0
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 774D11C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:30:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZlyyzHdF;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793986257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XofOEQXNLqFn+X/AdUrRbjVcp2Tpjks1Mv/4b0yulcU=;
	b=DHkxlU9ob/zXTX0bpb1OaSA2JJvoAN7AVEqC4Isl41YSWreDPCQkruiQfsfQku8b0IovX2
	GK2AyvchiwiDwxu8XiJFAmO1XcykSUyxy/2rT9XVlWGCKo1yt0NvU0r3PNGEYB9+72JzIo
	/WR2H4MOl7KOeC+kSaE+FC+6jNVw4GU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ZlyyzHdF;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793986257;
	b=K7QuXLm2fNviu7/gm2ZJ5VgG8djqbeiRW4ET9a8bPFMBqc7iZKYumtB9sdDmpkfDszPYQX
	76T8mTHcmCIhHZNYLCoXK6V8XUbenXcLXN/MDn3d7ZNSM/sDA8rKAl7KsO8659eZfbDxxC
	lE+oiwQ3dhVT81AtlT2ylVRSt7vEEyc=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91e7af9a67fso6210676d6.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793986256; x=1794591056; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XofOEQXNLqFn+X/AdUrRbjVcp2Tpjks1Mv/4b0yulcU=;
        b=ZlyyzHdFSn16uV3pJqz9mNIcyYGE/7GvElx4/9NETe5MKKAEILrCGwVaD1W6g6bLc5
         Owtw8paCTwHTCxfmFU82/e4R+qlLjyQeyaXvqGQzhlACafib1vxXbghgmwQ2V1RMgoG0
         QQQ9xP030DQZx7X9lm0bxYpU1dPo/dblV3p9/ZrPiRCebS5saGtRrFqZjesBIC/26hcg
         dD4NbuFBpzvEB8yxL58suLTQjm1GbyGyv+OqHcT28V0pZAFJWZQz8r4EBFP67LCSqfaO
         yCRE1JmOJ9HdPkcz0qFQ9NH+cYpCTN5riWMYGpTvfNU/6p9PXWYC5vv1Cu6DarWKKfco
         cSOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793986256; x=1794591056;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XofOEQXNLqFn+X/AdUrRbjVcp2Tpjks1Mv/4b0yulcU=;
        b=MD4VmsgdXqtC6BVWuD2goTUH8I5QeJKrL6+HkN84zJ33odGySi6jYu3bGuu6QgQyty
         1BUS5C+l6bMq5AMfes4Cu/8tZWa6p75yUT6tlESu2V4TeydCvwkJLkyD6yzUpNXNdxQV
         YlVAV1i8R1zp1UI3se05BD8D7CWlygvPKg/5cc+Yw6UvFdYtJ4CZSw2DwziKNHzu1uGB
         tP9H16jPyiEttWzTYe/b/3nhnF/KxUv4wvfL6otmemRuBuJSSKtuzkYWrgpWUGLHucXq
         zR3HIddVVFsaWINf3NRdyKBG3NDdaaW+gRiu8ieIzUleMBp3LcVJKCGgeImAH6a5zEMZ
         Stcg==
X-Forwarded-Encrypted: i=1; AL+hErFsaiVIyqyXn2VhLkPjrCcmeJLFbN2NUR0p9mtYK3VqvQQXm2u2D3WtaoMbNIxUmFD5UW1uUtpfWw==@kvack.org
X-Gm-Message-State: APuU4Z/Zvh65etcbWKaC6yToxQpuoFMx1KEal/3EhRVwhqQwvfkG6Sqf
	xQKZt6/FFPcdiAyMslWSfVY2ACYadhIzbVCFWYeLbAhZqFWAn8tRZzrKAXr9J9ksw1g=
X-Gm-Gg: AYBFou3NVGZwL4wpg7Yz3LyYXOlg9Dwz/1l7NH+/nNeWcOXgE0zGHkAlUO5bQo3hD+C
	4g1h6cI7z+2S17I4GT1zlnHXTl1g83+8Gk6ggZ6jgfzt97X7vHmHFrb8jFjhZGfDZIYp02eZYE3
	y20mUKk0DJ9og3J4wXb26hqz7Us97R+9cbUnhS1ZAHdVIqSNPsLW8dFgmrLXYbnwKJrJXiqPsDk
	ARtCcK07Tf9IPcUy94swSWRiWW4fXo6EtTwh7qf/r1Opzol1crYpE5xchZpBmQTdvSS2KMQfJLs
	vIQe4wP5Z0D9dxM8vPI+mWA3C8x+TEGm4M9UE9UV8DuRnTHYgOVoGGnbCCO06HQ/0iM+Bcyt2dP
	FLIDz2kAlkSBG87YGcZuNt7xAUPGBI9Ayy12yHRUjabcQMkLI67hLWghXxuwHsjk4a5zwgvxOjj
	TSwSQNya1ChNKKW+msqiz4z0NOz1Ggi7yMIXFc5DSODsYp1y0FdBl8O1S2iWxwZT0ILTeuTu2I4
	y08G3jNtd0Q9TDauAiH7/yMTAftr3HmIa1jcZPFPfpwNVNqzKl++OaOtIxsTsk42xNflOOjuUJ8
	p9oHuHfTxInINN2RUidsascGsWrHA/1nGTe++jqcnETakCo3qAiMBsfxK6CugO8VS3p9aJuB0Iz
	BDyeFLa/YTQMw2j+2nNSTVSm2MT1WHEU=
X-Received: by 2002:a05:6214:c69:b0:91c:73fc:a5a8 with SMTP id 6a1803df08f44-91ea9742db4mr40471196d6.9.1793986256339;
        Fri, 06 Nov 2026 09:30:56 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ea6acceacsm25406486d6.43.2026.11.06.09.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 09:30:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xPNmA-000000076Mk-3tnC;
	Fri, 06 Nov 2026 13:30:54 -0400
Date: Fri, 6 Nov 2026 13:30:54 -0400
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
Message-ID: <20261106173054.GH663069@ziepe.ca>
References: <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca>
 <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca>
 <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca>
 <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca>
 <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
X-Stat-Signature: 7q7yhhdqx747ogom8xotr4apz1ziho68
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 774D11C0002
X-HE-Tag: 1793986257-785552
X-HE-Meta: U2FsdGVkX1/md3CjOQ+CLVN9sa9n7MWHQiWuq++T/dX828JVbt3WjNSWcSNkQUNgVz/MCW1Eh5wYH6RdOW/6c0iBu8DK8fvudDPggUB1Vwfr38tIU6QcExkS9LAGJH0GiJg/RoF4tPr2A4Wu9rW73UrIOTG8giUbxQ7xeUsuin0mjUvt1gtP8hy/RLEPLCbvZMffGKYrFPzy5Qr2CEv+q/Rfloa6Dac3guJBYYsZ2wwFoRturqmaTU5QaraSCs3RUxeZ6XYbNxD3NHNc6ICzst/5MTsgqpr4YCpUMMAe5pK9CEf9U+wU0TBUsuUpx/5FNJHobwobamGb/xFBS2+1wIbPu9uhNxAJQUP5g4oiylRviQn8lQuGyeLlTQsZVS8cNcVz1l+r8jlpncmt9fxdHN30Q62azgEflaAWXB6Kq/MGQTavi3apy1ryz2CUpAcyRt5c7aAz3vAFngbtAoYdyZB+PhJIzCOUmvMeEU5AM+1a3zuUa06fiIClGbHb+J5B6f0LCxPrPbK8d+kgVJMt3diYwAmKc6FKQMmob57KSVVBgmD/ry20s1fUED/7L6Ee77KOAhspYeA/nbKI5kzDGjt+i7aPDJBJqLIdHDmpHbD7vw1/XEILi7PxAxQ7+plwaW7IPzFG0gtM/QzeVVuKbU7WSVpQjIg3QKZ8i3sbZSw+oRFERsK3zmgpvaG6Q4kTOXLeDJXPgN2hnO49zNrziocS8A+EJrYrPu8XU7rTwiw/GhpFVP7uYKLfa3HMqjhIXTcexdoEvujz6F4Ev/oLG5K5meT4Q5DUQulwf8a+oZEjI9GefDY9lhAg8axfHeG8akB/JrlNH7ki6rPgi+CalJ336uGvnIvoXg44uV4XCbpfvRIR9Ff4Ynp00Hjy3tpMFmo3EtSvV1mGkxhfwlrxa/vGzLhHKqHtlBPP1St/+glIULSWXdf4c6zrE81Ufsmqm0YMe0dKWM/9izb5M3/
 5G3L29qN
 eG6XcKy0tSQD2vXE+7Wa1Yb5Qvq9eQ3vHUxcmD1lT/Y5tQ9SL9cC1zQvCXbckXczzQV7gNadrD+Q6zy/r36yoEDrDDtLm4Xl/U8b4xMAZO4sFPiu7COxTQ1mANWGT8y0FborHuujYb2dv9LS25OZxcgB1ie+s90RS8F5KSV1mrSfb++6LxAjVZZMljwCNNbfEjuzIhBXHgbkUGazy8vLDhkS2ANYVshtubzNAmbl275iuOgN9l2TGT37dYJ8xMYQWjW5dFOVl8dsr/UXISGznqCA8M3rNLdsGW6p7sJ0JQVRnw5o0y/WvF32EvvXXC2TraJHYKEe+rP5nxED0JzAoJ+j89Zj+WpYGwJGsWpr+hjqcUyaqSket/ew4OxZItUbstcHBJ1aK6e2vffiEBcwSVXBahpP68rvqaQgnOTeuSAoZrdOeJV5DpMYJow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> I drafted an implementation [1] for premapped TX and RX buffers on top
> of the existing networking page_pool. It is implemented entirely in
> the networking layer and extends page_pool as the default RX
> allocator, to the TX path. There are no hooks in the IOMMU, DMA or
> page allocator code. I wanted to understand if this implementation
> correctly captured the feedback on this thread. Key components of this
> design:
> 
> - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but each
> chunk is mapped once per opted-in device through the DMA API and
> records its IOVA for each device, rather than using a shared IOVA
> window.
> 
> - TX: page_pool accepts a memory provider for pools that are not bound
> to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunks
> of their NUMA node; TCP copies sendmsg() data into them through the
> task page_frag and allocates its skb heads from them.
> 
> - RX: an instance of the same memory provider, sharing the chunk code,
> backs RX queue page_pools. RX chunks of order-0 pages belong to one
> device and NUMA node, and are shared by that device's queues on the
> node.
> 
> [1] https://github.com/torvalds/linux/compare/master...NamanGulati:linux:netdev_dma_pool

IMHO the netstack should never read from shared/decrypted memory. If
you put it in a SKB you have to be sure the only touch after that
point will be a DMA read from an untrusted device on the TX side
(sending it to a trusted device would be a fail) and the final copy to
userspace on the RX side.

Everything else is very security questionable.

It is unclear to me how any of these page pool proposals meet that
requirement since page pool typically provides memory that ends up
widely used in the netstack.

Jason

