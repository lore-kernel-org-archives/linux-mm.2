Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CB5A606D801
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ezhiPsxu
Received: by kanga.kvack.org (Postfix)
	id 280FF6B05B3; Fri,  6 Nov 2026 13:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232336B05B4; Fri,  6 Nov 2026 13:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA3D6B05B5; Fri,  6 Nov 2026 13:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3F926B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:00:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 428BE8018E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:00:53 +0000 (UTC)
X-FDA: 85405459986.10.45DBC24
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 497122000E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:00:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ezhiPsxu;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of namangulati@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=namangulati@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793988051;
	b=4ymzR0utYKJYcH9X0kbXFT0NqONutXiD+7jgqf0cBFtzY10IfP1lg7z+lGD1IsF1HXaNdH
	qvf1yTEJg5OZ4FR17h8CGkC/t06JPhL1GJPwcpaVnwSCN+6os8Pf5Dz8JZQXTIg+wVNuFl
	bW0GpSeJI4dgESs8awRNlz2ItyLUwoo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793988051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnPe9jMocBvynbA9CNTJ1Pl6eniz/8su5Gj2vJyxmpg=;
	b=Wu439Y8uwQGBowmOERYnBTtEoUEhiThS/6Pwojt03cTPE1Mlj/H0w3XGNf1GRvFOEhZjqd
	8ssJVGffyDwg6F1RT54uCOYJfYs9uRU6E5SeokMf0J1KbBMixKRZzZm8OlA4vwkQVUQcEe
	wBHKCHsrHJSrI0lJoLpahizcpJ4vePU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ezhiPsxu;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of namangulati@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=namangulati@google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a018493d57so13245e9.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:00:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793988050; cv=none;
        d=google.com; s=arc-20260327;
        b=NEpXpeBn2ZxuQkA4vFPt3vbslBBObX8/YuGAeeZtQhB1ivFF3GUZ/2UKvQSEsxOyS/
         n+1Q6+5BN3RhZiFPm/zP7uG6CDXo09i+b6FInvYNBmQQCtXgWRkCPamxCsbzUu01weEp
         NG8BQUNK1OYohsDhy/XlvYPW9XY2Xo3SgjSPR0cYM1C6UWHMGHTtvXbVFNjZIqzDn1fI
         jtGC7J1mZ2U2EIxraocE2HzZgOguCM4QtGpT3vgV8YHpJXEbCb9QzKSNojxOsvESU3fO
         yejlN2lu6400mFSspo+u+Dlqh7CKXkyNPjsZUmVN+cwGBSzv7+HMkds6fj8SDch5l/mV
         Vsnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YnPe9jMocBvynbA9CNTJ1Pl6eniz/8su5Gj2vJyxmpg=;
        fh=yQS9em8ZLEC4AB5rP0tpiiXLhFQCIqAp87FQ8noMDt4=;
        b=clkLIm4ff7h3wGdnBlhHZF7jWjBXfyrdKzgJSXGoATnYhUMjoTgOysXR2dbeZSRbLR
         XjURhjVxP+l/3GprJNbM1FoPvvinThANRkX61DJuXk2klSceFMRUkJEHnnNRGFJwN39s
         nIsoSPD3l0j56KudPaVO184ddqJ0Cx+CDJVXCESj5A0I9sSGwpdIfuMiJR6jlAMJwz/z
         H7pGhd/+G2+GWm5A9wSJL5Yd36I3DIBOCTaFmrq3txRDcTD+q7GxMK9U+/VeczGFri6j
         AerDLMmh/GjOsV+mBkhlt37iiNEfgrJHHpGdB4G7uAxMYOgljBw2/ASO5/HoAeLM8SWT
         WIhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793988050; x=1794592850; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YnPe9jMocBvynbA9CNTJ1Pl6eniz/8su5Gj2vJyxmpg=;
        b=ezhiPsxuotpYVFKlkPTg4f8QG9ktd3Le8T876Hb3NxthDdeHvx9pnqI+l3vi5MMgPZ
         MKiJafVtdEJbtanbi7ZJzJWYnboEcwqJI1d8fQxV9dsAiGiqNa/Fj+a6l+9GxeBrWntu
         mpbEpl6VXm6LnEuTKQxxdWwOENLN2xDP5XqUuPjqTcBeCc4k3WK2T7ixB7UiR84kdZkR
         4GkcEJ2NV2+to5i2y804du03Kjgu2Fsha00pAi6FY6j8oCaU9tbi101aBPw1GXo0RnrB
         DaCLngZG/sgzaO7fcmpAQjK8x9QzmrNlHSCXiNvjO6Ng6Pdd5eqIQfTV2ZvggrGhuwb4
         GCxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793988050; x=1794592850;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YnPe9jMocBvynbA9CNTJ1Pl6eniz/8su5Gj2vJyxmpg=;
        b=cIiajFW0n/hKmu0gbSdLc+1M8rUFhsUTKXmurB2GzaY0El6HfXAfxr9HyHE16Xa9Uh
         0KCuSxqlkvkMN9LEv1UuEmWS0G6SiLo2S9Xdfi9cpZV9pRwygda43b2YjJ3rxiqEMB6c
         XRVajJDUoNqsKacj2QaMLIh1bjgqRrYV+XjgON7yLrmfhju1ALeQNaTVzSbAZcVYfD3v
         ge7zTQAYY76+Bb4VTiULN8YuGOOyEAjCngTpxgKWTHOxc/OeC1VgEpB0ZmCZm2rxENFu
         hWFg7sBfpLHzajMgV+EtqyNU3BJkBoJKDrcH0+bnRj8cH/5kbWH7rwQ/E+mTSW8fv2u5
         p4oQ==
X-Forwarded-Encrypted: i=1; AKwUvByGK3qWcPk66yU4GUKL38HMnjkCpa6324pQkUPwdBHburnt1pknG7EdeqOiCYZtJIp24bNJ6OLz/A==@kvack.org
X-Gm-Message-State: APuU4Z/U1YfWUsywJP6TC697nwgExRi3YoMPJxRGW3weDhicz3NyDckx
	1j/YqDhyXqoyUyUiFDJXEfF4mVtNWDou0MXXpwoESup3q0hFX6gUkMrs3ipA7dVx5bsy6oD4bZU
	siLSAawkrS7fh7RDg5gx7jSeBc+EIccp2da043scO
X-Gm-Gg: AYBFou3jMb05PguSujEiApHf6QI+Lys33XGtfMC/9L2cXTZHpZFxFG9YXBLONAPp1sx
	ZYPjYow9AHBgUvVEFov4u+qm5qQfied6E7DawNJaBoivxLndF5EorGH9gQX4HPBKaF+o9RENvxn
	WeftP9e9kT/oMxqGF47hy83GGfmzxRCyJlOCkOf003MxIOKQsc4iMtauiyIxG+iajTkbZXEkMWG
	W2lATkqYFhDY+8XAtZqbA+4dn+U+u8eXRg1lmgE7kH/42I8c6T/TE7c5aJBLVaX59LxpKBWhtGo
	uOJGWXH8tDT+2T+qzgukxPicBBC31pl0elF19MH3Hdqa/1BypgrfeETP4SArcMhyOGVbAJjjdLp
	y35PUf9W8de8UY2BHGGQOrMhEX0qxz7OFoLQtDaFrNkGjnaWyGSEa07/RAxrKLmPHIklEww==
X-Received: by 2002:a05:600c:c3db:20b0:4a1:fb0b:1c9c with SMTP id
 5b1f17b1804b1-4b78a30d10emr50205e9.10.1793988049366; Fri, 06 Nov 2026
 10:00:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de>
 <20261103151021.GK3889730@ziepe.ca> <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
 <20261106173054.GH663069@ziepe.ca>
In-Reply-To: <20261106173054.GH663069@ziepe.ca>
From: Naman Gulati <namangulati@google.com>
Date: Fri, 6 Nov 2026 10:00:35 -0800
X-Gm-Features: AclHuK8x57W7AnFw360PBbTWaHMwGgtNX68cpPd5ipqmMu4tcyLJQyWTDt3UxIA
Message-ID: <CAMP57yU-VhZWXijvwAXcN9=zZ+eWXZ6J1bkHuCJw3ocRaFaV=Q@mail.gmail.com>
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
X-Rspamd-Queue-Id: 497122000E
X-Stat-Signature: zqb54tk4s7kwrqs4ipeqftcyqg1orybp
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793988051-160589
X-HE-Meta: U2FsdGVkX19tEasAP2dI0SNSVbr5QhmuopsF02jrzZuYi4g1sSK6TbU83pRkz7VBnizbKhyakn4HjuAQJC/2841zrgkIURt9nO4UYrRMdN7TDSGOfXyHpDBbrD7FPuwKVgEuM8My2ZkzwK9SQQd/TXijP4iQvVVvJq2KngLpwp+5boQpE0XVrfhzsiyOvKPmi5o93wAxHoHlIuOzJ58TwfpEfKP6sH+zsrjCN6Kdig6DlDKLzmQCo0dgp7ets3PXEgeGna50i8FXw4ELh7gWN6BV0/f0m81f3aTG2+GDyPYjyeJKHUjEFrUK+bfzaWMTVRlidVS+LMexATjAlnxjxe5YVGfrzBhzQBq4y0S8ehrDao+lHqP1B8kDqcTdwCCckOsD+qPjM/Agdoqi7oK0b7XzJFqxI8Z6BAtp7/g6HtHFO+I0uQXyJTk1P9nmTkbb/sVE7r91VHLEQNJ2e9bATpCpeHrfRxkas+qQfTD7Mz+F0siSgyKSugw4D5pVbQwT9C9vjwODWEoc97dAh4QbpwHb2bXwCTFdVoFCnzES5FCxGr4QT7nEwjcRhMygJb4Lg7/SUs+sX8gXkeEYUAeL8NAIdRHXcJgu9HD4qrmoazjGDBDtnFwXH0QHr5BLnPAi4DGhuXaO9xE6mRiamZtzilaYB5TmTADnr6XpJqGs1FscX+4NMHODWc4lhdZqpBrCmgNGiHpoAl7b0Y0C2OSqL/4MIYX2prryetHEV5aO4bjnmf8fhb0aHmGG24MDQkrloqzeXa87b1hbvlZpWDhFVWKmSTgZhRXzTtFonkveX/j7Piz1x3ChEEg4hrtCawgQbzjTcwM8Euboc+iiEB7jthLDDiXThYw7LCfDP0hpgarwrVIFy/Ns3nr4uImtaeOqJ/qFEZL3PcLKP+useMSHXuxFecfebh8TeWOAC1U/d12N0At2iqBuMqw1oP9qQqsMEUuS35/gp5yUnC34S60
 /Gm72aU2
 i1U+UG7Hze8oPotcEh2wuz1PEVKWjJrfKrQ53KBjYjCEtG5Il5A+otQmasAPQi9RKpsKLMmz9Rl4mI0/cCMG8A/NKI6Fyjo/R5EkNYE5oRbieIECn9yr5yQqlUg+m5P4nEwEbTdtu9JsURg23NDiF3iIYavrnx0Ee6Bve5t32fXlboeumEgFEDmQyImzqInTv7P6J56pY/ZhuJTOsC/7Eeefe371+ZEo/m7pzZy2+2Mh1bBitSthahrryM/zZFJkbD5ElrfPuVkDFSHhm1/mLS0C9xGMb/8EgHqtxOdzDSmiMpjSVmHNQ2O9rK9pw+2wBeKeD74xX+vBadZypK9hoI3onoRPAtBjKpDSR5FS68NT4Sh04waehS3bKj6FvVOMmsKI8UYZewYA7YmpLIAFBIMdnloQ5VsZ23zRf3PreGKLLKfTW0sESpXI+1Diavfe0EOYyIrEcB1Ree+HAPPu5++kO3cZA9lRvDKuYHj0A/F/FeXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 9:31=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
>
> On Fri, Nov 06, 2026 at 09:21:08AM -0800, Naman Gulati wrote:
> > I drafted an implementation [1] for premapped TX and RX buffers on top
> > of the existing networking page_pool. It is implemented entirely in
> > the networking layer and extends page_pool as the default RX
> > allocator, to the TX path. There are no hooks in the IOMMU, DMA or
> > page allocator code. I wanted to understand if this implementation
> > correctly captured the feedback on this thread. Key components of this
> > design:
> >
> > - Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but each
> > chunk is mapped once per opted-in device through the DMA API and
> > records its IOVA for each device, rather than using a shared IOVA
> > window.
> >
> > - TX: page_pool accepts a memory provider for pools that are not bound
> > to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunks
> > of their NUMA node; TCP copies sendmsg() data into them through the
> > task page_frag and allocates its skb heads from them.
> >
> > - RX: an instance of the same memory provider, sharing the chunk code,
> > backs RX queue page_pools. RX chunks of order-0 pages belong to one
> > device and NUMA node, and are shared by that device's queues on the
> > node.
> >
> > [1] https://github.com/torvalds/linux/compare/master...NamanGulati:linu=
x:netdev_dma_pool
>
> IMHO the netstack should never read from shared/decrypted memory. If
> you put it in a SKB you have to be sure the only touch after that
> point will be a DMA read from an untrusted device on the TX side
> (sending it to a trusted device would be a fail) and the final copy to
> userspace on the RX side.

That's likely a fair callout. TBH I'm not very familiar with CoCo and
will spend some time understanding the constraints. I kept CoCo out of
my implementation as I approached this solution from the overcommitted
VM problem where we are trying to overcommit memory in VMs and use
these pre-mapped pages to avoid using bounce buffers.

>
> Everything else is very security questionable.
>
> It is unclear to me how any of these page pool proposals meet that
> requirement since page pool typically provides memory that ends up
> widely used in the netstack.
>
> Jason

