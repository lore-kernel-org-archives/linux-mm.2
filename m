Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713C3606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Fl64Nf4M
Received: by kanga.kvack.org (Postfix)
	id 87B3C6B05B2; Fri,  6 Nov 2026 12:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8050A6B05B3; Fri,  6 Nov 2026 12:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5166B05B4; Fri,  6 Nov 2026 12:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3366D6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:21:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B693B1A010E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:21:27 +0000 (UTC)
X-FDA: 85405360614.05.4422664
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id C1D521A0007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:21:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Fl64Nf4M;
	spf=pass (imf19.hostedemail.com: domain of namangulati@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=namangulati@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793985685;
	b=dSQ/Ax8m374C5ZAKsINQRjBfi8ARpZUsgJRrfyoS0Wo6M6/p/MefIakgVABlOIMP6WUEoz
	lwpYXh84ZhkzS/2A0b5oXng2M7WuJkO1CXONGiuMUcf3Y4jKF5vjYBjG/RV3L8HNsstlFv
	tXUI0XdKRvvfrnDA8sSd0NwgJqobDtQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Fl64Nf4M;
	spf=pass (imf19.hostedemail.com: domain of namangulati@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=namangulati@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793985685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RKt6UkQZGhVMeIsFX1m9xEh639vUr0Dxv9GzpFuH2Y=;
	b=pddRXyMwN6/9uKx03mAxsmTBn5kv+dXQp73lCwhPC4P24+37MlyyCkPn6BckQ90WtmAlSg
	95P7LqjktdpkUB+lsmlNsRhc6aaYZATSrPfPCl3qVyDg0cb7liKfWUAerawUo1TUTOJfqf
	eSc8FDpmCF1h//60cAflMoK59oVGsyk=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso14025e9.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793985684; cv=none;
        d=google.com; s=arc-20260327;
        b=mo1WqbrVygRbQVvP6nk/Mqi3yO6MSDol5vMwmlR9ncT39p8t/5ImfgrzGf0y4oc8F2
         GfeK0ajAVpAfrhpFsOIHV6nrfceKAfZe+xgdGDXT4/3vJAW117wmfGBT7CEYBb8Tt+ez
         ft3a6xlJhkZnGbImTZg4ilvlwGJBR4cBbsuRHlWTmRaJ7GmKhtmFC67TSX9Mcd+4Z176
         a8DWe/3qRSzkGicA59OfDAt+8Ymy+ZRZejUn64Zfehr01ZALoZwyrA8LFn0BCx02RIT9
         bNZzSKjQ657t79NUnU9RUo4NMknWp7Kp18N9laGP+wap5v9XL1Xi7Eh0e2sJwWChNEs3
         aV3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3RKt6UkQZGhVMeIsFX1m9xEh639vUr0Dxv9GzpFuH2Y=;
        fh=2mQFVEa8MonEAXrS3lEyEYaBNa1KtvBMwB2ksiZ3W/8=;
        b=o9T4opAwDSZcXmRloTaa0IcvBClZmn+XP5sKoUAbIIpfbp6K8sAV0xohnPWVyGnGO0
         uEnJC0OOKyRY+3CVQYOuCI3rr2y26dB+bB27WeHw8EZy5jJqAfnCGvjVUMlXZZPIg4PJ
         /OlN5aBaYgc2J/9ygRFVCLx8RHSAoRLaRP0DUcPAU6XBs5gxMuUvYYeffpRDK5BopC/X
         ew2ijXkw9oPcbMUtVVAPeO88C7tKodaJGuxpVZEN+/wEsNaNee3t7ej+0itN2maLbwEm
         jh19XoCEafySJ9w0pKN6DNj2XvJnIz6v6p0qdY8uQSXc7QElbm4OovptJXSf7yewNJiy
         4+5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793985684; x=1794590484; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3RKt6UkQZGhVMeIsFX1m9xEh639vUr0Dxv9GzpFuH2Y=;
        b=Fl64Nf4MBjM/mySorCoarPJWS6zl9HhmYFVQpkWiAufUWENuGs0/zFCEvDfPU0n6sK
         BWSbJv71qE1IZrUou1U5ZDUSNcXF4eo1ZXU7JEUq0HoBS9KyjTsWnB0ALwyhG1JXbLEu
         2EHlfV9CxLWxDMkg3IE6XQhMPQlAS1NhZgUmX5MzLA1jcZtnDy4gtUa1PfZiqLs63H6L
         I469MXQQSNiLsU+OukP4VfJcPR9ayp33e43UdSswxuDI6AcFi8sZfiQH2/bDwjem/JW0
         gDI+Ybd+LEspYtnTBGTKQqIGavy3cXu1oXCiON0k1UBfZ+e4TZpvE/RVuq5ylSPr8DII
         WdVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793985684; x=1794590484;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3RKt6UkQZGhVMeIsFX1m9xEh639vUr0Dxv9GzpFuH2Y=;
        b=eX0D8xobeg9xM4qnriq88DrxqLT1I+L37/mmorJG1NZiHf4Qj5ublIo8AjaYi6BV9X
         sFhCzETqGOUHy0Fk472c2Zt8kYLb1+l6L25uVXb7dIJMCPu1hXCgPkV8lXT8uGX/6cxj
         iV5D1s+Xgiujwu6wSY9KnoRUgSsb84aUodGm3mGwqMleMvcq46NRvScBJk5qmKxRU4Qk
         +L7JVWpgiuK6aNIvCsuoi95CWmRlHXSo9yUqK16+qupwSIsg8pSB0dhrj2xJ1wcXOIOS
         KfEoi+AN2RCHsbFyVwO4j0SRnclcAsIFv13xbhQji0qKA4pIxBf1mZpdsTwkOqehBc4x
         gcWg==
X-Forwarded-Encrypted: i=1; AKwUvBwFhRtnAsoQOTrb3tIQIBx0sNmCUejK9F2mD/n97KXjlTw+L2doJKyisUKmV233R6fMRAG+at7+Iw==@kvack.org
X-Gm-Message-State: APuU4Z+pUeIdWIMCIhLTXzxsyBvxjOm9Izzvxw2jhU2Ve1xyBmItz/GA
	MeplyMGoB7iylT57/rmX5q3H9vh96NTSojZBzcCrdKevMbw1hLiApgtztv/EtTCs6P3Pv4Jcg0u
	BeB+G5W/Eu5zidIqjIz607FxN7YuQxBlxYFZc5BCf
X-Gm-Gg: AYBFou3Ce1BbUaav8J3trcJLPSadbEfK5iJUdyk73MduUXdaHaOBz/OACZQQhlYgKw6
	KzccSakiRGlLwpjmy/5PDFq21+YvftRZq9IRJwnczT8go0pdN8LrgBebF9wh4yivuCM2S3bD82T
	WIabX1xPWTTRE/AACwavWozCeAWFguc8tnwLj8KvY47y9yuN+Yzmjbhx9G36uMtKLpJ8XNiWZQT
	arKg8vvhr9UB2lqDVegBZtLsgEtqAJIIIPgb0cQ4mRkbQjeuksRw9jm7TvpEE9yRUVJiOw70gcP
	iZNhrfS11EAoDyG4YbNWT6RRtpxOhvn897YTLSlv1Fz3nbesouVs3RWJjEW2APA8SEOQRr28Fr/
	rLl4gpfH/6mns29tGDi0FZUV0vPfTCWSTQ6sZers+88iaJb7gehRx5e47Nlx0SwokA8vUYA==
X-Received: by 2002:a7b:c8d7:0:b0:4a1:eb02:37c with SMTP id
 5b1f17b1804b1-4b76cdf14e3mr150235e9.6.1793985683858; Fri, 06 Nov 2026
 09:21:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca> <20261103080933.GA4213@lst.de> <20261103151021.GK3889730@ziepe.ca>
In-Reply-To: <20261103151021.GK3889730@ziepe.ca>
From: Naman Gulati <namangulati@google.com>
Date: Fri, 6 Nov 2026 09:21:08 -0800
X-Gm-Features: AclHuK9QrDyTYpPe0hyDJDnSB0d1jRnWKMXKMwxckIvbaQIWb85nKJEtPirUyxs
Message-ID: <CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69trmw+BJRVYf3JB1g@mail.gmail.com>
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
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1D521A0007
X-Stat-Signature: 7roq8qqdj543q59kr1r16x4edafjef4g
X-Rspam-User: 
X-HE-Tag: 1793985685-969884
X-HE-Meta: U2FsdGVkX1/C3qEnGmYUwZyCtPbeR9HVewdpdjPq7IKMdUlo7COMS5U3j9m2lmfjyht0yj8t3sS/lWqe1m7moc52ZuGUp5vFtjsKmhyqN/VUqdYEnQBjHzr8+otZX4Ni4jVjyEOM4FUlTwdp0LAGujboNgRNpZzb/tfNUiwPkfjytg8lLftZelrRlKUZKGqpKJYBst5em71D0ZsOunfcT6qVP9C4+adC4Z3rGeH3IjzbWQa/aowrpoLVmzWq227H6DMhNPVezQULc4UUWYR1slW6tu32PqtI+mwDxjknU5uLP2BF8KM4KsiucUktddAr1hix2Of8jC0XUhPYuwhXK3BuJoAfdD73RCGd6JKN30blzxrX6eWTQ3B0FsC0uDenW6I6utXrIyRxe6Np1ifQJs9xaarrgZZLVt3axOOKxuuVZCdPx3hC3gmbccUsFJvVMW6ofnUbNhC+5uY0c0veutF6N9B5j6bsHNjTse36jyW6Do18fO1ZvaO+GNtoQZsCDm5EHWTjMUViDP/zivpMs6NNTDy94G0baEw9+HmChFHbWwjk6JgwovOoTYLSiNHt+zxiFtwn/RD1ZV0yA/8njkJvuz9RO+BHxAyvp+v5tzTXVM1kiIErcTPVO7GnMCeLXN7HppLR68Vti38GRwqPCa3gaI/d+l7/vQNMkI3sZqBvDZZgaEo4JID3b7oxfGgJ9VxTU1W1fQtKrZANiVCIxSjT9Jy94jmTvAbOLfz2hALhuiCFRfLgvarvpil8hh6UiiEY1FqpJENVcLxO1ipS4Svh0Uyr0p7/ZDYSslgDJIFL2skiAuacKMg7Qug4Tck3YSGMHwn6uvyqR8MIi+auUsQVKULqns5f3hOVPoToEFhkoXSDoWRHnFcNewRJaG3NDl4U92+YuVccgHmm9pGTF1M2l7UH7RZgZ19iIuEw/m2Yo+oGBc/OllOsEpTnsQ42Q/P6GwlX763NhJCC+qy
 HBrsGB0k
 8SXgHjMKf+ybI7YnYVw5plgNXP72nC/2sKZ1hwyJLL/PjBtHQK1yK/xRDjADKdGC0p4LHx8Y/AWj90tOdU3VbSGvNTma53POodCUYZt1uTE3vkGL/OpT4CVLRl7oeF3d/bSmwT167UbLu6mF8JRXAo0pJe8KIybffpLYzOBI7pO5O+oruOjzxpx197fpmbw8ld3Pv9PG8QQGohNjPVoOUHWr2BJGpbTtP2QUZEiXsn0LbtTNfIVXg4lTcVMDR+OiigUPYemH5/tUuz42PGTR75MB4ie86qOH3WGsEPFx2NxpwSOGvwkrez9heMenMtSoqs0nsHs3kPN4hx/B8BbyXlxt2H3K1hIY76/OTuYqU8NSUzWygJO038eV2La19npaNYN/ysRZ9ydpoLzIfwMcVf2NsvMg7Sp/0bHV31PPJTS2kg2mpd+lYok8c28zcFySQ8J9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I drafted an implementation [1] for premapped TX and RX buffers on top
of the existing networking page_pool. It is implemented entirely in
the networking layer and extends page_pool as the default RX
allocator, to the TX path. There are no hooks in the IOMMU, DMA or
page allocator code. I wanted to understand if this implementation
correctly captured the feedback on this thread. Key components of this
design:

- Chunks: as in Luigi's series, memory comes in 2 MiB chunks, but each
chunk is mapped once per opted-in device through the DMA API and
records its IOVA for each device, rather than using a shared IOVA
window.

- TX: page_pool accepts a memory provider for pools that are not bound
to an RX queue. Per-CPU page_pools take 32 KiB pages from the chunks
of their NUMA node; TCP copies sendmsg() data into them through the
task page_frag and allocates its skb heads from them.

- RX: an instance of the same memory provider, sharing the chunk code,
backs RX queue page_pools. RX chunks of order-0 pages belong to one
device and NUMA node, and are shared by that device's queues on the
node.

[1] https://github.com/torvalds/linux/compare/master...NamanGulati:linux:ne=
tdev_dma_pool



On Tue, Nov 3, 2026 at 8:24=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
>
> On Tue, Nov 03, 2026 at 09:09:33AM +0100, Christoph Hellwig wrote:
> > On Fri, Oct 23, 2026 at 11:50:23AM -0300, Jason Gunthorpe wrote:
> > > > Disk I/O is still potentially affected by the same problems
> > > > (cost if io mapping/unmapping, iotlb thrashing, bounce buffers
> > > > in confidential computing...)
> > >
> > > The disk folks already have a proposal to address all of this using
> > > io_uring and preallocated buffers. I really doubt yet another version
> > > is going to be interesting there.
> >
> > Huh?  If you mean the dma-buf I/O it doesn't really have anything
> > to do with disks, except that this is the first user.
>
> Yeah
>
> > The dma-buf iovec can work for every ->read_iter/->write_iter
> > consumer, and should be adopted more broadly.  Including by
> > networking instead of their own totally weird different world.
>
> I'm not holding my breath on that one..
>
> Jason
>

