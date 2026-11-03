Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E12B606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ERyLxh3c
Received: by kanga.kvack.org (Postfix)
	id 135BA6B05B1; Tue,  3 Nov 2026 04:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7926B05B5; Tue,  3 Nov 2026 04:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF04C6B05B6; Tue,  3 Nov 2026 04:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0E036B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:14:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 464091A034C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:14:36 +0000 (UTC)
X-FDA: 85393247352.18.C46A4AF
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5BA5A180009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:14:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ERyLxh3c;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793697274;
	b=CAA0ftBfp8pxSg+qz055UwSVBXRz0+z0K9iAFzNmhQ+z75CHA65r9w14GWsJQwTyONqlpk
	vbL+dhdF1HHBIIGlYKqxADy9urM+EBzQKrRUkIa/+YKaRCeSdwg+hDTCTk0TQ+WcVdDI/7
	tjB0v4wZMUiAMBSsSu0O7f06AdkO5JA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793697274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i14dmH5BR+9SimyzQMrEk5iidp8zGrGHl7mp1tLTg74=;
	b=TFLwe4kvD1xftMMO7zO4mIPUIHfT9vyy7KhZSDmmEo7xNMLu4WEp5din6lNoKJU64wvxI6
	BFIFvUMhumuV5i6wJeb5yGPCVPehSpTfn8IzHmRpy/UKSJ9tOGMAdmax7oImXjSdyHx9ag
	mRzKMCF3Tax40X05moSvCqh8almwjTA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ERyLxh3c;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5383c97c8cfso140071cf.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:14:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793697273; cv=none;
        d=google.com; s=arc-20260327;
        b=me0uEPfZD8b8LYgr9vJACb2HYyzv8PriTFBgSdx9Ki2vgWv3mI94qmcmiSuGFGHj1O
         Xidxf1u5oWMatvxMCsmkNIsJ8Cbsv0KU4oczuzsoImBcZLSCS0BOznfNFXKKqZvwJ+GQ
         aiezFZZLaeAzZYlGysakm/Wej66z/RaGTdgYrSbdjWKNYBNM9mGUR3MMsXGdh9GpqWnD
         Gwnt0YCJujNgpqHh+092Ied8xIALpVC14ChuWGyCwiRo0cwEiQeaguATbo6BBULd9vVg
         x++gn3aSK3H2TLhJtCq/Di14GjhXbT4FSu1Rwngcg23QJr7YsoEqwA9SNwYJ52gcc2h8
         4rJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i14dmH5BR+9SimyzQMrEk5iidp8zGrGHl7mp1tLTg74=;
        fh=mjQmbYpRPnKeTnrtyOGrvCFnAcO5soruzafwwICwoME=;
        b=R6SR9qLTIXRJWVM7bGcHwJFmYUMCtZeVRcnsJLmvsH5KI3umhbLByUI9Dc0PBaaXup
         TNS0vEEJrwJu6DUDZpiZtTRl/5zI2LCiuGKISmhiaImmAzG06gESgmr8CCwy/0wd/bL8
         id1SvTWNOC9J/HdvLSuEWNLX1ew9FoGyB/CxMZDLRx9zluqqYYghIlDhyyfUwC/3WJIM
         WV++DA0QZ+6lLx7+oTeMKPBlz7gzOCUtXwAoVCRlXMChFisOnew6cXmLo3hdzCPFm3y/
         R7IGmVztJGb4tmZ/Lk9AX0IrnIVroSaNO4F8SqtovaqJiovjnwFVWRCsIjvu+4gyFMEm
         AYSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793697273; x=1794302073; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i14dmH5BR+9SimyzQMrEk5iidp8zGrGHl7mp1tLTg74=;
        b=ERyLxh3cqtorlRCgLIbssz3UXLqqG/w2vOWoiRnccn7B1tpobDxmWRYQDLwDHTkiWq
         WFYoeaOPRJ5y3Ne233mzL8Y29C3gV90a/BKuMgAt7dXJoOuqCKyQ8diE4vywmRVSR1M/
         z2bouX/+oJ4IJOtfoMcAM42zT7E/wMm0sE3qYX1AhC5c28utaM32a/8ttPLtcB3Ox4Be
         fcy1Oho3tDvULtjGYWhx5IkCJe+2LCZx7OrURf8wytpcDy2gmeCy4URXKqTmbip/+31g
         Hg8KxNxurfSifaVRX9mdtOIBvGBQLLJYMBlNDkIGjz142cWIynO6SlcKTec5d4TDAXI6
         8+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793697273; x=1794302073;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i14dmH5BR+9SimyzQMrEk5iidp8zGrGHl7mp1tLTg74=;
        b=oecKGVjse/d1SySVwtbRzXLhhuWSV6In3l9d08N/QRmVa/NJN75rRSunWpQxIzp7nH
         8AGKrUfn6Do3++KmLc5YTghjFGhj0U8lqK6mZgUfRk1POIyDQQI4h96BIxfmFBGnWS0c
         GzNTXEjLrVtbJm7G41AC8TOoeJFlDBJ48nwRHCEMMHIUCvoDM3o6sOXogPiPN5D0/hG1
         FtyohLTOThltgOr4G1lfidy2RD+2QmOUZrOE3rvzEHMo8vKHImb/5CZe5SdtR23W/nuX
         6i5m+75IXym7g/c6GEJBsg47D4FA6wbbTk9wF73kJVz2xZvdzm48r0fCrgCJRTqa7z7x
         zfsg==
X-Forwarded-Encrypted: i=1; AKwUvBw5K+C4fdILRqmcpkTP+TuDpn7EZh3dAPZzHzIPfpsXuR7f6VaF4vt+KqGA1TOO5elxvmsnv3YQrQ==@kvack.org
X-Gm-Message-State: APuU4Z9P50zj637jZS0IJUdkRxBAL+E5kk2Wt/gI114QHKPRo2rDWvc2
	EHbw8Zx9fEWDmaFzE9hfZoyU1+5MlitnCQzTIaGFyxF+2ivJk8+OgwBMZM9tcwjhfY4Wk1sNHbo
	Vl14Vuo7GHAnTLRWUwCdIomg7VBlxx/Tb/dRtXxI2
X-Gm-Gg: AYBFou3UOT0jts1eoiVdV96E0yIyOtS4BaJLU45R13xqq6PNDpfVMoP5fEBnyAgt1wR
	gUcXnjtGlM66mmrdMFMjnUA+DhPXwzUAC3jk/cZ0Hx8mZkz2TDg7JBizDzgKiTujShLKey1Z5Q2
	rY0ugLZLeticL0NnL0nay5rK6k2k4VEFwhYHc5amm7yPbIYaYwwQrvA4o9hU3M0XunV9+aNP4vQ
	xnDGtUZeb5NM2sUGbWzxpIsz4Xunq9WREEYPiLpNHrC+lgBq8wUTRAEqI4q50XJLmnwAW/f16Ka
	OEA9r1FiYWjBmIWmURGJPlxX3CZVjy0s/y7t5iarKl4pWJdNsXvpz8rxzCdtDWPsSqMaFHB/6YL
	yna9+PdnbDFNlgUDmiCYubP79LSYjAWWTw856EUj73eHzqe7sD1C3mz4hAog=
X-Received: by 2002:a05:622a:598b:b0:535:84ef:2e26 with SMTP id
 d75a77b69052e-549dfce05fdmr11810771cf.7.1793697272817; Tue, 03 Nov 2026
 01:14:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de>
In-Reply-To: <20261103080933.GA4213@lst.de>
From: Luigi Rizzo <lrizzo@google.com>
Date: Tue, 3 Nov 2026 10:13:56 +0100
X-Gm-Features: AclHuK_l2TEIEs7qqznKn-9_c2yONWQ9t4tXrp8CyyoGHrPwnIyHLaBfgdlxlp4
Message-ID: <CAMOZA0+Fhq0_Pm02xGWpex06vb2y5pVzuFxOk=URZB7aq0xJ5A@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, "David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
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
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: nc15q9sw48twefmj6ji8quam4cs9rit3
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5BA5A180009
X-HE-Tag: 1793697274-749732
X-HE-Meta: U2FsdGVkX1/6y8+Ghjl/J3NF1LYGAzGwVFjy7qH/dX19C8/57yQix/lqXeVGc4nbMCet19qWRoVfR96I8eYSHGL1VHsBJ/sOffB2IaHLDgAZl+g4VNqjvRUpN1aHS21WpXTy94dgHdrNQUuQhA8ym0FLaooBhVMCFz94UNIDVdZXgOYz/ofmd50ylu7uUA/0S8Bz21j2gbyiqfq1k+Lmz2oSkFnGefJ3ZGpC0Bjfcly7CVjxVmwoAf5gydJV6uhd3g+q0By1vmmIbMAW0HGn3oMqf89V+j4kj5Pwp3zGwfIU7gJBMj1HGSpphsdi+UDJ1OAb5qqiEW2shykiZEiVr72fT3hpIVamyXZubUttbXL/aA5DC45qeiIA5i+Ubr+57Qr9uIVk0shV+RsQ6dHoD8NN9JUPt6FYHzLmtBTV+0ArW9v0sbOeEnygfv75ONfpqVglHq/+DY5IyjTrot4keCJGdrfda0ONmZ7MdF46DR+KuZTnsDK3hn8yQoNaIa0Pruik6XoIYD/2AMYSBDllmgTFG97g/lA6egCDJ+J+ceH2mLvWm6KzMayDPUyWU+Q02xg9QIlHESTzqm1PUSQme+4ROwTfN1cxQwp1+0DhfdgXKUXhXWoRXBiF6FX/P9yVXpwWALGRWkkFUfoEJ9sgpm/VpJQTRSqkx3n2inoIKh52WIb9wey2K149SyxVZcHNLm4S6SQn0CiXpRyBBYgsKLDjjY04AY2aGBgziqDg0JKocYrOEhspImyN8drsJGsSZRN0svXdt21p3nOkpP/TuMvQF6XGYEtWc3/hYN+7EHpe7HaQld5P4FY4Bi3cRisJ0r/Bu52h9l42i8NqSpVYYpC4I2tnOmeBvnePP6Q86GrEvEHZiIi5n9O2skVrFiGThGHS5RxMBSOVK04IxPTWxDe/00pqxOqvQ8bzOQbQmUyZV9B6jAFGysVAeKJm+yvo/Qk8O/jupT13GMJNWxa
 BWCG0T2b
 Ae/+82Fgg6Jz7+fKe2cAX1ZwL/XsyTRFTi9TV2XneZZepc3HNCrSEH7nzy3tsQF/Hmss8rxJ2eCPkq1JXNUcKiA+Ps2WFlobMrR3Lhw1XjeFC9vAm3FsiVUz6hyS7kUblM+0xdpHWT0+lwW8oIecwj44zmGJ4I6ACCiAUoyepu5zL5eyyZr6R/S++ijFOm1DD4NowLEIBCOcVowaYPajAFBfUDszX88i9rz2h7rxrlUORPEGPYpzDCNBKXbd1BhSsyCalwMf5g0G7l+GmH9gtQt67C1FSf72dA0TJ8DKnogD6kbl5NWIBitixMCEcxbMMsZ5bW15Fx9aaVq3T9q8EK5wthv/cz7VO1Hog0New/MrFXn/Q05apVzv4LMrR5Yal2USV+C8xwiS1473Lzab+vFJp2L8x/KrSJjLuaRBlqqvdQbzf1953zyqpmVvAVHFzOnMCpHz7rMQYEhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 9:09=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> On Fri, Oct 23, 2026 at 11:50:23AM -0300, Jason Gunthorpe wrote:
> > > Disk I/O is still potentially affected by the same problems
> > > (cost if io mapping/unmapping, iotlb thrashing, bounce buffers
> > > in confidential computing...)
> >
> > The disk folks already have a proposal to address all of this using
> > io_uring and preallocated buffers. I really doubt yet another version
> > is going to be interesting there.
>
> Huh?  If you mean the dma-buf I/O it doesn't really have anything
> to do with disks, except that this is the first user.  The dma-buf
> iovec can work for every ->read_iter/->write_iter consumer, and
> should be adopted more broadly.  Including by networking instead of
> their own totally weird different world.

Christoph, is this the dma-buf series you are referring to ?
https://lore.kernel.org/all/cover.1791975048.git.asml.silence@gmail.com/

I am not claiming that my proposal is a good fit for disk or accelerator I/=
O,
but every subsystem has different constraints, so it is not unreasonable
that a proposal for (N)etwork and a proposal for (D)isk focus on the
different bottlenecks (still there can be learning from looking at the
other solution).

As an example, in networking we have to deal with the following:
- typically at least two buffers per packet (header+payload)
- often, very small fragments (1400-ish MTU plus crumbles from
  data in different buffers
- extremely high I/O rate with almost no spatial locality, which is an IOTL=
B
  killer and the main reason behind my proposal and some of its complexity.
- on tx no good way for the application to pre-reserve buffers
  (buffers are sliced from a 32K per-task block,
  going to possibly different destinations)

cheers
luigi

