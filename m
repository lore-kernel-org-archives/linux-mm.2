Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8FB606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XVDJ4NAa
Received: by kanga.kvack.org (Postfix)
	id 23F666B05B0; Fri,  6 Nov 2026 14:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0706B05B1; Fri,  6 Nov 2026 14:11:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7E96B05B2; Fri,  6 Nov 2026 14:11:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D09066B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:11:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98CD11401C3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:11:49 +0000 (UTC)
X-FDA: 85405638738.16.950CD08
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9DDE6160009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:11:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XVDJ4NAa;
	spf=pass (imf08.hostedemail.com: domain of namangulati@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=namangulati@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793992307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2A6aCl8kyfujglJb3VkwVgvWA7M4CaDd0+96AnNPHA=;
	b=lCI5F7hVACYj9g/0x92AhCFBDaUhQBukbTV5hS6KF4V7pH3W04i1Hbk/8bdsKRfIFHmxZN
	9ruE6neY8SyI5PN4jjSOsvaSHQ5+pNJX0DK+QkBPPsJbj7n9H6ujBWDFCRVJnbnUOfVBop
	xwM0Nqpp8EYooW19GYMLc0xfukoSVJw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793992307;
	b=gLe6vJsB2MxSkJxPteBCjmlwjhqm3Pb6gAyrc6LNmkcHxIfOEdHCokqSaJwhJZ5gKKdJfO
	R8trS7abvzkDdOBnH4EKFkBrNNIXt1iruRePpzJAu1bsJFYpHFEJwbNPAbQK52qAIFx920
	2szMgiQz7EDiuvMHlrJIyuJLtrIudD0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XVDJ4NAa;
	spf=pass (imf08.hostedemail.com: domain of namangulati@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=namangulati@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-54492d8a988so971cf.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:11:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793992307; cv=none;
        d=google.com; s=arc-20260327;
        b=hOQ3eJs9W1yRl5PO+OJhIAWaeKxeaFjuu0kfEauE2GXyBxJKs9f52oClqIciYm3IdJ
         DrYtM1DPQWO7lQDhP0eFLlAAKIaZiWmgqFE/JcmHeMEHXSICPxVhV8vFuZEt451I24Ak
         2K8JD2RcGDVsXifCmkmdyutXWk2yM2ApL+GDNj/M+WN1clfsYw/dIoDvdUFoqBZ1HLV+
         AkjOdCne0E2kjTMnOGf13Rw+aB4m+7opIoY6mstkGmk9wVMdZEiyW3oKGq8DrSPjTC8B
         76gibgaZLhmco3ZQQJn47AvAR1LxIfKGAKxd7JVkPfXhp5udTRkQu9xXgu3nEMcXzQ+H
         5lrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h2A6aCl8kyfujglJb3VkwVgvWA7M4CaDd0+96AnNPHA=;
        fh=489JV2GKSIEYGI5nCfZQPdmA8cAJw6Sa+yQjtRHszZE=;
        b=iKXiL1A0hnPWhQlXmoQ2ECSZZufqLzhzTBjvU8nkcPC4LVWhsWmIjY+rK/H/GGSLOV
         E+CffJhFWGIt4QIDU9Q2UPeF4gUIxLVGnr63i8fUFpZ6QDrEBl/r+mJf5cIWt5+spDuv
         8m0LA7di2XB21BMCkfe0eqgNN6I2U6WuL7OrCVetg24Bi0yNDlZdrwWZNp4nuviZle71
         2ZDIf72QDQVBd/gX8O+edwGF+/6PX0GOb2hW4JKjmYgv6iUzBtGqbvHJOaquATCUi6z1
         krGDqRVcz4V+8uLCD59gx7/cGe4IJFAHWlRrjfIwdn1YgvCqvZimlcaTah6GaqlLVgh1
         otHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793992307; x=1794597107; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h2A6aCl8kyfujglJb3VkwVgvWA7M4CaDd0+96AnNPHA=;
        b=XVDJ4NAar1YiCgQQkJSF7z7+LpC1VYNkVGYxWGk08t0V6imMHZ8IRb7UHKgruJNs7H
         EhzY9ZmOingfeGqC4/XKSaMt9oqUrjhhO2GFxIdNwa0qxd4veAMpBidHHQ+P/Ail4b3Q
         yVjUaZhomVhlEZfXZNX9kKpuyskXOHtdYVsnJkuYLOa64JwRfXszYv4gH+hbYHu4m0H0
         g/vtLOYET4LafMczHAVEi6ZbXpxYz9to0lFkXgj6jZpmFmvrDaVFOSPFn8EjBPtlrmX8
         vs9n3xcHCchWIUhWxLGkTvhL0HbxoCJ4TBwFTD+JxnccZ8/TMq+RCqEUVZlSFcok0f7j
         T0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793992307; x=1794597107;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h2A6aCl8kyfujglJb3VkwVgvWA7M4CaDd0+96AnNPHA=;
        b=VglZjvlBxqGBQj09uNtg3MZvWL+99JKuU7xZDhyMPuKuyVzfxoO3qj+d+pEhEujKiW
         6bMx7MExoQ2nV/MwefU7ZY8QGxhXD7E38ma73qAZbvkR4UKUim310Tz34TruZdxFWcLw
         Q5AbwQ1l/YGs1OPIumADwKLa21w817ZcBfYnee1pNGqa6RDDYcOYO1w9FozWPc2wzJRy
         IP+3mDMqQqlJr4S0rp9Mh6aHnisOw2sNG+tqhFrlmiRkFsKiqw11BnozAWW9geg7v0gs
         YBsz76a2QtkCXUuzLxWqV/t6FA/xPnB0bX4XQVvDT3zdk1SfCvDPvBkErlyS2WmByTUZ
         H4sQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOaWi2NifND53mVK1I01/7DemTrHsBVHGEXrDY7+VzruOUUb2DfMMoz7s83Fu+B/d6HSflN99m1w==@kvack.org
X-Gm-Message-State: APuU4Z8TZuh0NmKNAdoq9Nb+gGmtn2FT48ZNRPztjcm5sjUvmstJw+mb
	SKHL38UUXi14iZJd6tUbJah8iIsGuw2fznmkQ0OzdX4+COoZu2GeKuqocJOqPd18Cuv/fH0KuBF
	hodI6Yc24cRfB3XoRqHd9Z5Ly/PctiEQBHXn1WsMM
X-Gm-Gg: AYBFou28dd3WdHnm8CVTQYUpkRJEdECK9+EjfsYX4HRfpqnNgMtm5sWFraJ8AubZj3x
	7QYGH4N9uk56X1hyXBEFcRiLefAJrxZGvRQ0MgxuiEhOIideoQ0QOgJQOYO1R3xBEAXhWn6zLKA
	CVz2Iz+Qg54yctnSUlXOgyW3stFg7qedf3KR9r9I1UpsMtg+sv7JqaVxYAW3F57p2xc+mRixEfg
	QRjnh9rphn4glElIVkG6D9dyB9M49kUifqhXTcU3PE/Zk8wV0w8WQJi4InWNUfaOvZXr6jsEnMY
	wEy7qc99oenkW4pC2r9UZqApBsJZxNybXEPl2BwExaiQOcHGZS6YtdKSwZn26WAe+/dKiBwtc9M
	JYV/kVBMNWiAjA59NZoLxtZbWRF+FBFxvrRaPwCCgO8tQvYUSb7eyY1KWTnEOsChXrxWuzw==
X-Received: by 2002:a05:622a:2297:b0:532:eff9:ca08 with SMTP id
 d75a77b69052e-54f82d870e1mr1932401cf.12.1793992305834; Fri, 06 Nov 2026
 11:11:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca> <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca> <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
 <20261106180714.GI663069@ziepe.ca> <CAMP57yW6Y4g-xM9YTB+MpgxPN7RFeEWhAPWvqrfOoMDEuL8HZA@mail.gmail.com>
 <20261106184346.GJ663069@ziepe.ca>
In-Reply-To: <20261106184346.GJ663069@ziepe.ca>
From: Naman Gulati <namangulati@google.com>
Date: Fri, 6 Nov 2026 11:11:28 -0800
X-Gm-Features: AclHuK9JPUckmOeUyc8sSIbL-A7oi1CB3RcBM1vHWdycPuPf0ms-UPAYg2zqwxM
Message-ID: <CAMP57yU7RoWXkvOfx3ksX8kaO+0h8WPefpjnY2DH9WR_TYGJog@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, Luigi Rizzo <lrizzo@google.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 7rfmkm8qdfwiw5scyuk1ykso7mn9swfu
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9DDE6160009
X-Rspam-User: 
X-HE-Tag: 1793992307-671740
X-HE-Meta: U2FsdGVkX1/RhzhfBZkvEL1493w66hIZ0G30BpFavj7SN7rpj1w6PKArBENuM6dPZaETQFz8bzsxKPU9d0nscpk7MW4k+kC7aX2CrChrtdzi814+vJCbWWIUOmFeX6xWyEVY4GeVa20LRZAz4ZnbTwfsvHcB4le/f0wZbTpeiT3ANmMr8Mcuh/XDJFDWOOLuHpsbLxCp9VXhHuwy0xI7OHPeZxqcamMSiI9QT0MGPyK1T4QRcUf2FtJwk4nhqNkysiqkpHkcV0VK9yneA/Z18o7AEGOyq3UYIgWBT+8nH1PDiGGpt2WReXeT30zVceT2bZScoKPMMjsoT/JQlPIpinn81lI7C2te6lKRk32zWw39p0lY1MscKtrEWEpnRAMP9n0E2HvsXnkVtlV+FDh+RThOT+l6fNabH6lVYne5REST0B1/iAK1PXEjaD8tSbD+YLV6E+cpsP8zkBAhLqcKKH9a+7IE7gBBQlF305VeEjIQBHN7QtQLlHQtM97bVJ7j3HacpNeqH7ldZAhLG5H9HcGfwrMRGkr2hUjurOpBAZdg6L3qSfDshnGgfUOB/ykdA0oIU7odJSeDYJAD1cVf/sRqZp3YLm2B0ysjNNCDdUn0QLdPWN9QuNQgvAKAhJ7SZ1ANrJ4i3H2NiIxe3jzHSSCHOVNDm7dpacoctrT0pcfGXsqUfB5215lgzpMzO7Uq0oYrRBMjOyI59r5vdvgYmgumvVyXy+I0fb1dDLCR9vA5xqC2qD9Mh6djAy0IOQ393TyULSKEVstOGxyGUy+FzLs1fm6Fe+Ihlm/6SWt6aXhAhxOpcxa5ZrnmXBL7pnn0zCXOZkbIvhxnRyl50uodwDNqY30mizWfU4vj9OxstkJruCx55Ds3ZRtvgnFMTgaWeVM1rPU5px9nYn5H+jVRk2EywTS28HfVtwex4o8+7tGVIeac9OpyheJzo+K/4K5AQaRtQwhMWPkfcl/dx9b
 HMsdONyv
 IRe0gXOJQoSSoBxUjyF2STOoP2jM5cbrr24ItfyisAEDGPCJI/lFNV2dzJDvBYAMr2eqWIt5k+abuKtrCdb0UqibLedOWk43cAax5uDwiqF1Dqv0Lkr62Fsh62qH3PNtvPKIOTVi7Pcm3GW1Ni/AI86PyiycAbcn6ZwiglRoLmEiqCtLORQ9V2f7pYtmkJ6AQNAeSrh0maOyGsywVK2ndMcq76t6/UyLT+mR6Iy6k8FYsEH6s8uyKaNu3j5VzckKH3CkLsqxHUqwXj6DvR4xqesII+urlPd2tIFRalsl8F9un+IHcgL2m/vbYxcHKIxKIG5piNsYOHmqRZGtgPOPE/ySqf9XwOzRbCTobUbxDY5vDFmAhZoxwKMAbFXKtfNcbEmbExCcLuhNC4RrCtYw4CXpcBsKgMM5o0NLmKAcLC1cpIZfrNhdEUTwAkrCbwHOIIMSk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 10:43=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Nov 06, 2026 at 10:17:38AM -0800, Naman Gulati wrote:
> > On Fri, Nov 6, 2026 at 10:07=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> =
wrote:
> > >
> > > On Fri, Nov 06, 2026 at 10:00:35AM -0800, Naman Gulati wrote:
> > > > On Fri, Nov 6, 2026 at 9:31=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.c=
a> wrote:
> > > > >
> > > > > On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> > > > > > I drafted an implementation [1] for premapped TX and RX buffers=
 on top
> > > > > > of the existing networking page_pool. It is implemented entirel=
y in
> > > > > > the networking layer and extends page_pool as the default RX
> > > > > > allocator, to the TX path. There are no hooks in the IOMMU, DMA=
 or
> > > > > > page allocator code. I wanted to understand if this implementat=
ion
> > > > > > correctly captured the feedback on this thread. Key components =
of this
> > > > > > design:
> > > > > >
> > > > > > - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, b=
ut each
> > > > > > chunk is mapped once per opted-in device through the DMA API an=
d
> > > > > > records its IOVA for each device, rather than using a shared IO=
VA
> > > > > > window.
> > > > > >
> > > > > > - TX: page_pool accepts a memory provider for pools that are no=
t bound
> > > > > > to an RX queue. Per-CPU page_pools take 32 KiB pages from the c=
hunks
> > > > > > of their NUMA node; TCP copies sendmsg() data into them through=
 the
> > > > > > task page_frag and allocates its skb heads from them.
> > > > > >
> > > > > > - RX: an instance of the same memory provider, sharing the chun=
k code,
> > > > > > backs RX queue page_pools. RX chunks of order-0 pages belong to=
 one
> > > > > > device and NUMA node, and are shared by that device's queues on=
 the
> > > > > > node.
> > > > > >
> > > > > > [1] https://github.com/torvalds/linux/compare/master...NamanGul=
ati:linux:netdev_dma_pool
> > > > >
> > > > > IMHO the netstack should never read from shared/decrypted memory.=
 If
> > > > > you put it in a SKB you have to be sure the only touch after that
> > > > > point will be a DMA read from an untrusted device on the TX side
> > > > > (sending it to a trusted device would be a fail) and the final co=
py to
> > > > > userspace on the RX side.
> > > >
> > > > That's likely a fair callout. TBH I'm not very familiar with CoCo a=
nd
> > > > will spend some time understanding the constraints. I kept CoCo out=
 of
> > > > my implementation as I approached this solution from the overcommit=
ted
> > > > VM problem where we are trying to overcommit memory in VMs and use
> > > > these pre-mapped pages to avoid using bounce buffers.
> > >
> > > Why does overcomitted VM use bounce buffers? Do you mean this is
> > > about getting better memory clustering in page pool since the VM
> > > paging granule is 2M?
> >
> > Not exactly, we are trying to use VFIO passthrough NICs in
> > overcommitted VMs. Since the guest memory is overcommitted we can't
> > dma-map the entire guest address space (as non-overcommitted VMs do).
>
> ?? I understood you could and this was implemented under the
> virtio-iommu by pinning the memory under active DMA?
>
> Where in upstream does the DMA API force bounce buffering for this
> case?

Sorry, should have been clearer: the DMA API does not enforce this,
bounce buffering is typically implemented by the drivers in this case.
Such as QPL mode in the GVE driver.

>
> > So overcommitted VMs can use bounce buffers to have a set of
> > pre-mapped buffers to bounce traffic in and out. We're trying to use
> > this solution to map pages dynamically with virtio-iommu and recycle
> > them via page-pool to avoid traps on each TX/RX and avoid the copy
> > cost of bounce buffers.
> >
> > This problem extends to generally reducing IOMMU overhead in
> > networking - taking the dma map/unmap cost out of the hot-path and
> > avoiding IOTLB thrashing.
>
> Sure, that makes sense, but just having a pool of entirely normal
> pre-dma-mapped memory is quite a different problem from what launched
> this thread...
>
> Jason

