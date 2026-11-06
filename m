Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958B8606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=LHaqBEGm
Received: by kanga.kvack.org (Postfix)
	id B056D6B05B2; Fri,  6 Nov 2026 13:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6BB6B05B3; Fri,  6 Nov 2026 13:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4C96B05B4; Fri,  6 Nov 2026 13:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709BB6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:17:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BF548018F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:17:56 +0000 (UTC)
X-FDA: 85405502952.05.96D7716
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6EF4A180005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:17:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LHaqBEGm;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of namangulati@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=namangulati@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793989073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvW3kJ042sHlnHfK0H238m7dXO47goeCrBgoSLkn/eI=;
	b=yxUtlqyMZemvUKP+tfTi/vGW6+v6Hr77FlbJDSCVIH9TMCR/Tl+OzJl7KMNzNOsY7jlhCt
	OzLAt9hbRrJQ0icMjqKebUxgJIRTiKBLuwrN+8AcSzm5VxsqkGgWuPNWpE/SZf5aLZzWgZ
	owTVLb8kUVN/8lgd+n8yWQozsNIQdhs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=LHaqBEGm;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of namangulati@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=namangulati@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793989073;
	b=ZY0AIilNOp1VTNgg4Mc6PuDOmzgwljuTE1z8+SuhJSDy+2GSkdAeniKwCRalW/JIfcBGY6
	OsaAtXDwVNNOAPzySEMiHbSMq9oDO0d9cTHEcJXHYa1O95ldD2mjRAGessERbh/1Cty4Yr
	jPhpQq8gF+5RUvuwnRiQKztbSjyLSOQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4b6266b5bc4so4245e9.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:17:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793989072; cv=none;
        d=google.com; s=arc-20260327;
        b=eZTLvDJmud2u305XB3lFx5zKQJYmOBHxInMGu4mfMNafwQjhM4sayovLd/QpmwYESk
         IQDxr+hM5mK+kIu7tILle7MD1kVjLXIJrE1yBTMe0Jdpo42I2fIfpTWzEtkOYa9Y/u5i
         mN5dzHDPkjACLGW/ANalLRQPx4Br52H8sz+hUeahEEypJMetorNSwQoH8vylcfnbJVap
         vEOyV3ADGGamXTO9MMZWW7aCvL+Rq4bYrrUsfYqNyKayJu3o5Qh11pG+6duFCl67cjVz
         7t7wpbWluJrcv9fsnrYBRxOraHmuSCQrdGnUbObYn3EfJV655Df/2DUSeJR1cqkgGzIw
         NiWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BvW3kJ042sHlnHfK0H238m7dXO47goeCrBgoSLkn/eI=;
        fh=ipFwM4uZwaf88gVV1dK1520AeceysRhOn73P0URdf8A=;
        b=iw5m6lxMXKnX6xiRm05BmkUS656q8P+bYFtua7im1O7s4sj8LAIv3TjLRAc+d5eHfl
         otHR0KJW+QxxiPbf7JIC+2shG4DsvTJqufq9UpOfr3I1NgSs7e6H7G+ySwMvYpLr2+XV
         E5l89uMn+ZsU4yxOIlgbWDlP9FWLDtX2clHEW0PXiujg46+uJ8i3nb00iCxzdj98MTPj
         UJD75SRIKSq3M5Ypr1bGJNSEHSlPasmC/4oRBIBZSCCg/tvrZMSnZ06tjuzQYjrqZwi9
         bXhLZbdl43xCAoJqrLK0Sqyl9uwwrOKdYW5AnbFCALdB9iPzXQKrwUwgB4IY0snEHMWi
         W3Jw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793989072; x=1794593872; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BvW3kJ042sHlnHfK0H238m7dXO47goeCrBgoSLkn/eI=;
        b=LHaqBEGmotkuP+T8qL3dwxm7jvyDwjsrDJzHDdGcBxNlrzlPsb+IgBlrM3hmU416qR
         UI/cYfCG9wOkKjkDofXen2TS5cACX4t6l3WCDMk5jgFqDrFynObdjpxVab/KysMcpIEH
         LCk5o6McqrevDS5WBscfIGmthJGIWDZNLL1TThU9X5N7OxKKfBMfMHgbt8X3i3/aahFk
         n/h9Uw92p/Zq3g1PB7nhxu+Uhxr4Se+vyniOi5iKKZiUvIOCf7Wg/mJ0E8q9iGV2/pAy
         eZIz7Dt9Dt7lJz/KOlGJ/AtRTnUBx0FdokL4aziSxN5/KAhkBZpXY6K4CoSq6ZP4QWe+
         cugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793989072; x=1794593872;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BvW3kJ042sHlnHfK0H238m7dXO47goeCrBgoSLkn/eI=;
        b=wcOxmxLCz7ukKeAUI/aE4adQxQ+PaN9A5R6xz1a+2WEuzLDpC4KCBz7hiFtZ6ucxUN
         xreTDh/kHF0kcNtVHP6Y02vH8842C+3grf9uFlXx+9V6setsrURx2NEsdfVlAtrrnyvs
         keZXWeD6sxHLqP6yTbuMy3l6hRE9EvsQI4n4V5vGt1GFVJByjnjQUe0UTc6sqccia9Dd
         tD80wD3KRzBb2YddhhtGTVTocGoFMOWSzlDJftXPi4TsgI0/s0fawwUP2yybJkzNp+wz
         Kxdd6paOzwZOvsBlyE1fIYXiUJqNZ9MmleO0m0txq/Af360X/MJerbf0Db2dByEZREB2
         HrZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzE1Wz3YReY3PDcpjYOuwILOZZ/Gs0xWp5NI2CULEoRH4nrwE3GJCOSs55mEFGygTseW8SzuGLnmQ==@kvack.org
X-Gm-Message-State: APuU4Z9+SHXoNRDhs1xGJtOGE0spqyi88UBerQPsynkakMTJm7Teuei8
	hDuF9i2gHOkpgAgSzICicr52H3QsxVnO53xqfLcAW+1rFEdOx4AEoY3e1EM5KSihUXia1/rmrVj
	IK1LL6Car6BLlKHAJtFEXV8/oUOHFRurU+V9m6mrP
X-Gm-Gg: AYBFou3y/YSnI3abwLE6xNRMQYbhYUKUGRa/OIYtxt8q5Sy0s8nxqaxYtGDJCzKlmC+
	MzYnrnXk4fH1wGRbDmMx2liaZamSAirmi+Dwc1JomQKJqj++L8hZw/w/hpPKAbaAhppEzxOHGmB
	fD9a/gAEhDagXzZvSIZLuumhk4FBaRlg3rXfr8J8Nbl9tvAU9wTXgIMxcXLoTkfb/Z5vzIrMvCy
	j4AesMya8mcVuTMl164bbNUJe+gbk6D/mOLGQnLkCpzp115rQmY683aaBmHJMztHnTCFllspW4O
	ZfqU5ZJDcFt3OOJQ4U8WbttDAcChcnHkyCSvOKdoojFFiCgTY3c9hMYXLfoARm9u/8oCsRhFYnE
	Rr0iTpriNF9/IuYovm/d15ZKYGy/zpTxjGTUIFtjE/moJpQ4yiYh99lVHsnne4iAZt1qiXQ==
X-Received: by 2002:a05:600c:8b12:b0:4b6:24ca:8848 with SMTP id
 5b1f17b1804b1-4b78a30d377mr98115e9.11.1793989071681; Fri, 06 Nov 2026
 10:17:51 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca> <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca> <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
 <20261106180714.GI663069@ziepe.ca>
In-Reply-To: <20261106180714.GI663069@ziepe.ca>
From: Naman Gulati <namangulati@google.com>
Date: Fri, 6 Nov 2026 10:17:38 -0800
X-Gm-Features: AclHuK-83DU2Twv76ErkJhEGQxs5tivwJ4EGd2AJl7A0D8r5G3Ha6ydUc43L3ns
Message-ID: <CAMP57yW6Y4g-xM9YTB+MpgxPN7RFeEWhAPWvqrfOoMDEuL8HZA@mail.gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EF4A180005
X-Stat-Signature: 36hga8ycd7a6zynp5xbdwqkmda1o76wr
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793989073-682700
X-HE-Meta: U2FsdGVkX1+Jg9MjAY02oYY3+FYzZOVSuWCmVWGZbGOH/FF73nqpLxsYZg2DUeZUNb9+ovecFz8qLMmDYqAD2MB0P3SwR10/R9GAw7nt547mbLzN0r75GbmEj4IrzWtavCsZBX2z9Ev9Uk15vdQepuk3juyJ02KmS3M3YIRWCK5EdPdtc9PVC6ntbbxmxBQkFF0XnyJaklWnYZJygDDx9EB5+g78JadCSsk1ZW1gnz1yjwnvPRiLUHFbnfMSBzHYd/rivWMTJbLyfmPv3ceNGd5Qk7I8m2/6MKIkg5m/6nuN24n2Ol/TSZJrtHRh1cGzAFeFOaGQsPSZNy73eUddChUhuXo0iD5OWStjyaIBAWIdK1wGs38OD67JIbjl8CfI4iKtbbtKqWjLRhvrqPdKHfrrl4txwFhlL8GqxA3Hb2jMT8CTfDZ8zY1EdQ+FddMbdzFRUPYnEo3eL1JlwsZ2ZMh5W0swPT2r0dAJste5SgQWNnmAh2EHIm+y8ug91betEf1xo4UEqyu4KFKgqfNogX+2VO6WBP4OOtnzaJfHkDLjG07y3U1MRORPSatajrtf4iOSgLCfvp1gBDjod2/SvG+dV2UbysQZe3CZj9rngWCcgSZ+VDBscpPMYmahQjaiycV764YvYakI86ldd3qLrcPK1fzyPO0Z/uaer7pXcBunJNHZKrHmWc3m+NBwZWr9bI/7vUWkv4iY9io1kyMFZBz1/OBMVQI6Hd8/D8XgpnF8Cck/QGIXnYKwP5tlH4KypS0Kw8ImLHj8EZD0A6AiecmxzfhTnlipDhXuvcDLorqkfumWUZ0nPFOclrW64G+9rYNXmjOTpDFcwyoaG3cX1E8Fp6Ot3caDyLY91ZsMmk4n/CLw5ikqmDe0u/3uM2Wjo4ciLs6Eh7+bjFWubRlo63JZTCo/oQoIZv+QgXke1fLSGCcTLRlcIQ+Mtczkz6UsK9BiGBNlNPgkzlbWWFt
 8HTsQcjB
 fYgh3kU0I1IkeOijLtA0LrsLVXD4nUHE1y6ZgP/IoTptc2bZ7Yo2N6G36AaDXd/yx1FCQj1GEnfzlSyEdJa6Sz9LE1GVv+b8oRbQBDn1U6/SxnLf4byto8cbUETDQ0r8awy3izrq5Laa9uOMh5gFUDPqUP/Q0Ef2Hx+WiXNrkL9zFrT1NXgu4i87BEe/t9LuYC1RwGl1UPq32Zglj3A709kEaEazrOFO8dUuks9xrOHoqLMUaXGXi+f/8PvmSOAP3Ugz0YUr/LmluZolCkJ7XUnpVtqSGUlym2xuTM32jjixCrqFVhjM43yqpu3ShV5X2VZn20a9s4TbOWD2VJnGTekW2XFziRpZwH18CWgJvSNhA37qPWGxGCdz+xDRWtHGutGkZZqeReItQPjUWmzhkctiq7+rv+sb89+e/acmRk0F03m5Sk+nC4XQhMtISF337NFSv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 10:07=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Nov 06, 2026 at 10:00:35AM -0800, Naman Gulati wrote:
> > On Fri, Nov 6, 2026 at 9:31=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> w=
rote:
> > >
> > > On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> > > > I drafted an implementation [1] for premapped TX and RX buffers on =
top
> > > > of the existing networking page_pool. It is implemented entirely in
> > > > the networking layer and extends page_pool as the default RX
> > > > allocator, to the TX path. There are no hooks in the IOMMU, DMA or
> > > > page allocator code. I wanted to understand if this implementation
> > > > correctly captured the feedback on this thread. Key components of t=
his
> > > > design:
> > > >
> > > > - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but e=
ach
> > > > chunk is mapped once per opted-in device through the DMA API and
> > > > records its IOVA for each device, rather than using a shared IOVA
> > > > window.
> > > >
> > > > - TX: page_pool accepts a memory provider for pools that are not bo=
und
> > > > to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunk=
s
> > > > of their NUMA node; TCP copies sendmsg() data into them through the
> > > > task page_frag and allocates its skb heads from them.
> > > >
> > > > - RX: an instance of the same memory provider, sharing the chunk co=
de,
> > > > backs RX queue page_pools. RX chunks of order-0 pages belong to one
> > > > device and NUMA node, and are shared by that device's queues on the
> > > > node.
> > > >
> > > > [1] https://github.com/torvalds/linux/compare/master...NamanGulati:=
linux:netdev_dma_pool
> > >
> > > IMHO the netstack should never read from shared/decrypted memory. If
> > > you put it in a SKB you have to be sure the only touch after that
> > > point will be a DMA read from an untrusted device on the TX side
> > > (sending it to a trusted device would be a fail) and the final copy t=
o
> > > userspace on the RX side.
> >
> > That's likely a fair callout. TBH I'm not very familiar with CoCo and
> > will spend some time understanding the constraints. I kept CoCo out of
> > my implementation as I approached this solution from the overcommitted
> > VM problem where we are trying to overcommit memory in VMs and use
> > these pre-mapped pages to avoid using bounce buffers.
>
> Why does overcomitted VM use bounce buffers? Do you mean this is
> about getting better memory clustering in page pool since the VM
> paging granule is 2M?

Not exactly, we are trying to use VFIO passthrough NICs in
overcommitted VMs. Since the guest memory is overcommitted we can't
dma-map the entire guest address space (as non-overcommitted VMs do).
So overcommitted VMs can use bounce buffers to have a set of
pre-mapped buffers to bounce traffic in and out. We're trying to use
this solution to map pages dynamically with virtio-iommu and recycle
them via page-pool to avoid traps on each TX/RX and avoid the copy
cost of bounce buffers.

This problem extends to generally reducing IOMMU overhead in
networking - taking the dma map/unmap cost out of the hot-path and
avoiding IOTLB thrashing.

>
> Jason

