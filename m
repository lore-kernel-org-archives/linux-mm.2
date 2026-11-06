Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319E3606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=YUusIjqO
Received: by kanga.kvack.org (Postfix)
	id 4FE796B05B0; Fri,  6 Nov 2026 13:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF396B05B1; Fri,  6 Nov 2026 13:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379746B05B2; Fri,  6 Nov 2026 13:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0036B6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:07:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8664540197
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:07:19 +0000 (UTC)
X-FDA: 85405476198.19.DDA8AF8
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 666FA100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:07:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YUusIjqO;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793988437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xsa9e6MH9/SVm3In7oNjUcANbgdM5Ae2hGRi/O5LwW0=;
	b=lwdanRdfxIeiRJvEXZlKQ+wgLs2SyataCrbzsQrDcqjlVzINLwtZy1siTN/QKCVJ5Yd4uL
	/tcckXEqVqV8gYGM1nfBtsAwruwmrFjS5/7v9cd7m6/0nO8OXMWZIQ+myQzhiTG/eC4hUb
	iJ2TqsU/xr54YxO5q6HaICsuP6bTyk4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=YUusIjqO;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793988437;
	b=uX4wSPnTtuva6cQceP5YNaJysVYNQhn9D9kdwE6LpoX4aKpBF8wkQolSJp9Pbg2JZ5eTJw
	LO1iS1ZYumkVH5S4l+KowvtcbR0DcilAVBk03LoL0HebLPMhi4T465OecwwwNofBXKu+gf
	HPYuoApYrn4XK6dPg5NvQ+1V5DX8uXA=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-533797e72e8so5619681cf.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793988436; x=1794593236; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xsa9e6MH9/SVm3In7oNjUcANbgdM5Ae2hGRi/O5LwW0=;
        b=YUusIjqOzT2bfxQe5++0nFOWjLQhPIc/xKbPFz6cHpqKZDGK1c3EF4Lz7yLQbkCYk/
         DkUVxrE+xV06CGMaOCpxced9IbE1quAMg6vfQY83lKSp1tNbdCXZee6g6mM0iTDxaH9j
         dKd7oWAF1vo4WtUBV4DctnCBcnxZRFKJ3hmdswxmYVf40r3OjezG7qyEnloOLb4ec6c7
         hOptHRTDbr/3sEJcVbvJBardkK/zosERjd/Vk8+BdrWpX86sZVsV1YQNvH8gfYLIVBJH
         b5fIREInUGMt7Vo+A+zBTaTX/UO35ceGeXdGLIMl1iUxd6+BMQU6uB5MNQZalrOyEsiG
         rUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793988436; x=1794593236;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xsa9e6MH9/SVm3In7oNjUcANbgdM5Ae2hGRi/O5LwW0=;
        b=YVxQZDioDwBKl+VzBbQEUG9Ttt+mYP4+e+JvsT03zXl7vSO1Td+1+N+wA0zpx7SqkR
         drIKqETMrIubPejC3t7St9aFz1JUX+qcVaT+pf6zlOcSnKcYvW1MjlibAh3Sno2o9+i7
         MyMsmoAL+XxLIrruiO2Q/X9nek71tc7MhaZ9E94PHbPOmrPlR3j5MF6hg0LyL9rhvL4V
         /mAtDT8FmtLDAJCIreAZ5JSzvvHaERboHa6SMG2K5A4dC6j4bhFo96HuGnB1tqJ2i8xz
         s2BRcN3Ego6B215YR+yMzgtmbqgAEjy541+bNhapoYh3KM1BOgiiIKV3J28wnx7RJEMS
         cLHA==
X-Forwarded-Encrypted: i=1; AKwUvBw04AHgzCoHkSvdxJM/XNl8r2015+jkKjofy53gzxDhuMdcRA3nSvM048VkaqJFc6vtX74DyMRsaA==@kvack.org
X-Gm-Message-State: APuU4Z/kVMcJMfrCSEgqnai+Mqc1aTX4jRR/yPk22Rdi/BFSCA9BGUE/
	jJXy5mcbdeiZYYQVG8o1U/WXoho3HBWVbTJnORW+wTAixXnreKvoCFQAu5fFa3Lf0u4=
X-Gm-Gg: AYBFou0+y7GyiYi2ELxeDVsQt1qx3/0j5b1+BcNmDgZeDAX7esrGAVqiabopO2gGUc+
	0H3sIsuPOgbifmNT6cd1BK0iFzPz0QQ3eLT3lQmXkD+8gZA0ahbhTjV+UavQ1csyuKm0FXxE6F2
	sfNleYaVxQXQQNydg48NCVaFqcqwjiL3M5X6FTwriau+aNiNS651jx567zg0iDQfk0qxyxLxMES
	aAFewqzcxbtlJ52pgVx+lFS8p0B+/4tVeaUJ1G4aXB7TRfZfthiU9n+DrIrNF1lwl/8n6L+kWxS
	EYfnHT+a/MnwE+EyVI+jRXP3ODZNrP86LNjbaWsyd/HIzwmfzvOQcb10bAKtopr7pSwNh/hIDhB
	LKHwJ2sViNAx58D+aKyFg1HgcwckhZWszOFsqhEk899sqZ8ndSfn7RhBDwLsVGI2kNSwFfgqUs3
	Y6Nof4tyKtPZl6aNvud+ghR2Z/LrqLpB0QzLdv9P1bYJBDZspDLD/hmCQNygG7J1jcqglbjZbjy
	IZWsq19Kag6QFDa5d75rW5wD6Z/bsu2WHQywmxYKkoCGN+XZ0WZUuG+j+JjYVbK//91zvOXbKT/
	7wj8auNdiJ0abE9BZkUxDjN44SdexA2cY/Hp4kJDOslTftie+wQ/dPBQOYEZ8HTSW9Vk8MdGZFY
	KvlBpkM8lZg==
X-Received: by 2002:a05:622a:480c:b0:535:a5fa:edff with SMTP id d75a77b69052e-54e15b63c63mr47814391cf.63.1793988436090;
        Fri, 06 Nov 2026 10:07:16 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e231d0710sm26555871cf.2.2026.11.06.10.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 10:07:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xPOLK-00000007CW0-3s9S;
	Fri, 06 Nov 2026 14:07:14 -0400
Date: Fri, 6 Nov 2026 14:07:14 -0400
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
Message-ID: <20261106180714.GI663069@ziepe.ca>
References: <20261022201229.GH3381610@ziepe.ca>
 <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca>
 <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca>
 <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca>
 <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca>
 <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 666FA100005
X-Stat-Signature: oa6ywszo1yun46prboqfmht5oe531hoc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793988437-60722
X-HE-Meta: U2FsdGVkX1++pUUiAHdFqyIRGqw8GpVdCzqMA9GB56sD6akhesa174MK/zgPu73KIeg02GbYCNBDWkhKIi3xEIWAn1vD/BLYyTieY0LDRL5ZhwapJ4E06A6wnj0wfGygw1SWw7nyDNBF0R6g1Ham91OVZr962eohKnN+9TgMTwH2X1MmjHS2OQ5Y+m8+b/JRVAZ84wuALn6f+dEtoOyWpB4y3YNpLuo4gDOjDIz8+tieL+9bBmiQo4aMTPvlvQbyPtlCcvOBmv5RwH9CJORr5UxS7KBpZpbNOPD10hulj5tbz7zWm4Ui3ena9IO2zTCoQAyTe67jimZR3BFGHsTREpctfYndPmYzunk1a2z6aczONdZgoIl99cp7mgO9b/yYtMQJ1j6UifnDDt53YiQrvSlliSC7lPW34c2rUtgKs8tYthkv7yeI4L/v2ylQv+8kC2o1jpemrYcBM88ABaOQQOdsRyqvrF62hL4otd49zjD5htWILut2ObLwYtLRMffvbxfrOVEeDHuRnBq1AeJLeTv4psWEZipIOWCD76pxq0rxAsgZejzuo7U6yZf8Zzi07fkzEjjPBf4SF2QC4JNBIO2F0Qg5ySaRdbqeB6Qj+szjd0uYoZjK+zJ7ZzOU/ix4Vrs3++21Ly11eSzExI7eLbUD9upXLmnr+at3mWI/+NT9lLJGUL/V897EPgtfa3EFd2fLZ3llMLp6Qi6kNmKOtgjLZ8rAPLknph7iPgFl22v3fL4o6Z30pSZi+sOFHbEZXgAUVmSpc/1e27M7gnx8xYkqfoviTM8SnDi7zeMZtTUPzCAlX9gpljrH271gSszErMuDHbTQzuSWYFfo3860GkF0JkSU7IuNz25toF7Pw6ke6GLcCNJKKxsnGlk/QttNJR4H5lTSEdzmrqt8bq2uK0Tg7fitxxJS581zgtmzsti70lrH7Upp0oJmt8Ad9KDquVVAEWbI45By0u1Hcjx
 GrFmD62d
 v6YCiqNS+VTJt7RXNfT2mqF6vXR6C9sgB+VfaXBQOhIGr06ZJ6pzDvjERsP2nbGiQJSwUPgUbr2Vi+UMtytC+o1jsaCAws+DAu6Dp1RCVSZnNi0xWAzvsFUN9TkO3l1d5c6RaGk34UC8xSNVd2NpcN2r8Rp3NwL/blYYsSgoTI07yMaqX7AcFOpHi4OqrOK7IQ9B2t0VvO1IKdFCpVbaXmAORRhVDKUJXBaGpSO0Y1LPMTSpHwd4eB2HBOW/fPMcBhDtx3VB9umbJgQIWbgzsrltgwVdSnIHWjIs/Um1igjVBX2RGL0vabV1lPCXDqxwciFC6lKFM/hF+Kq8x/gv5uBv/dqbbjoxI57Ju36AWjXHphL0z1eM4JkTrDMqh292YadmzIq2npxI13ox20uoB0ldfBHtSo/zjpmXOoG8dRN+rtaaTdXcttRZPlKVXzmYIvQo7Pdd822z29QKsAfC5bwHVLSPLJdwnTo9MJafSyg9Gg34R6z6qRU5DxbazJZx8ZHff3bStkD1ZdOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:00:35AM -0800, Naman Gulati wrote:
> On Fri, Nov 6, 2026 at 9:31 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> > > I drafted an implementation [1] for premapped TX and RX buffers on top
> > > of the existing networking page_pool. It is implemented entirely in
> > > the networking layer and extends page_pool as the default RX
> > > allocator, to the TX path. There are no hooks in the IOMMU, DMA or
> > > page allocator code. I wanted to understand if this implementation
> > > correctly captured the feedback on this thread. Key components of this
> > > design:
> > >
> > > - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but each
> > > chunk is mapped once per opted-in device through the DMA API and
> > > records its IOVA for each device, rather than using a shared IOVA
> > > window.
> > >
> > > - TX: page_pool accepts a memory provider for pools that are not bound
> > > to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunks
> > > of their NUMA node; TCP copies sendmsg() data into them through the
> > > task page_frag and allocates its skb heads from them.
> > >
> > > - RX: an instance of the same memory provider, sharing the chunk code,
> > > backs RX queue page_pools. RX chunks of order-0 pages belong to one
> > > device and NUMA node, and are shared by that device's queues on the
> > > node.
> > >
> > > [1] https://github.com/torvalds/linux/compare/master...NamanGulati:linux:netdev_dma_pool
> >
> > IMHO the netstack should never read from shared/decrypted memory. If
> > you put it in a SKB you have to be sure the only touch after that
> > point will be a DMA read from an untrusted device on the TX side
> > (sending it to a trusted device would be a fail) and the final copy to
> > userspace on the RX side.
> 
> That's likely a fair callout. TBH I'm not very familiar with CoCo and
> will spend some time understanding the constraints. I kept CoCo out of
> my implementation as I approached this solution from the overcommitted
> VM problem where we are trying to overcommit memory in VMs and use
> these pre-mapped pages to avoid using bounce buffers.

Why does overcomitted VM use bounce buffers? Do you mean this is
about getting better memory clustering in page pool since the VM
paging granule is 2M?

Jason

