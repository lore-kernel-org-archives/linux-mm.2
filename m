Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61FB606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VRNOxv+1
Received: by kanga.kvack.org (Postfix)
	id D50986B0BB1; Fri, 23 Oct 2026 13:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29E56B0BB2; Fri, 23 Oct 2026 13:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65A96B0BB3; Fri, 23 Oct 2026 13:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1F7E6B0BB1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:28:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B17EC0197
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:28:01 +0000 (UTC)
X-FDA: 85354573962.21.973BC85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7234D40005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:27:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRNOxv+1;
	spf=pass (imf17.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJXUDdGOUlnprTLNQ3mpD2znb8kn6x0W43UYG81DLJE=;
	b=2rPU9NroIZfCNQHyDgopszgpaMDKBUJHhJUhkICFpMRiWYiDJN+kxKkn1xgDQUwg/cR7hi
	fLtUy2kgLE6lpjiwXmU5oGn1O+Mo8FIGn1TuxaH3b8Pdp0SwiU+MSSib65BOTUcQEMzssC
	Lpigldx1IKFAR2egN1hHjh7vP4KYysE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VRNOxv+1;
	spf=pass (imf17.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776479;
	b=2ISal26llY7gxi1n/SE5A6/+H7bkTqZTvGIPRfxhJhZUKToR2oLyRBeDI4jB0qz38wJC6/
	PUy307zur7fIKhUvVIdQqlbzEEiDbSHsiho8HgLBg8J2W2SvmP71ev9V6vlUsXY4fq99Yg
	GSEwavnFEiV4eDwzO0n8+wCId6BTUBE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BC06429E9;
	Fri, 23 Oct 2026 17:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DAF1F01825;
	Fri, 23 Oct 2026 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792776478;
	bh=jJXUDdGOUlnprTLNQ3mpD2znb8kn6x0W43UYG81DLJE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VRNOxv+1Pksyrz5HnFhBkcnpuxCnSmnXdeyB52HziAZ0BKiZZtXPxAuj93PuJc5xI
	 1pTqs+75q+CJrl3PdpXqmb75U0b0ztZJPlKfMeA3oNQiv6FTGN0ztfopW9p+8p+T7P
	 ui7Qx8f3vVvVIwafvbWaB9RjhsPkzk6toCmg6ljNO/fs5AQqJlScIW/CdQo43D6NRP
	 tJo7uzYkrsViniHWvZsVkJCO1YIV9hAIclTxvK4nIj4FUgUlALsK4u9HNWRALjqoHb
	 Ctem5QTw0r4Gw3aGxKfIafMxkmpl9sspL0EJ5FfAFmnB/0QSTga0iibcftCdkkp4By
	 uoxDdS6wkAlbA==
Date: Fri, 23 Oct 2026 10:27:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Luigi Rizzo <lrizzo@google.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel
 <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski
 <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem
 de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy
 <hramamurthy@google.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
Message-ID: <20261023102756.201315d7@kernel.org>
In-Reply-To: <20261023145023.GH3977851@ziepe.ca>
References: <20261003212241.3432303-1-lrizzo@google.com>
	<0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
	<CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
	<b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
	<CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
	<20261022201229.GH3381610@ziepe.ca>
	<CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
	<20261023140107.GC3977851@ziepe.ca>
	<CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
	<20261023145023.GH3977851@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7234D40005
X-Stat-Signature: 5s4uhia11tjm6pwzwuug9c787xcwxtef
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792776479-741929
X-HE-Meta: U2FsdGVkX1+j/WO0Q9uyfNe3FwzBrhWC0c+WTmOAObko7Ruz2iYLzT6kJv4W0yrvl4nPloG5IiKZ2nFATCFeMkknP4yXXJzM/v9V532xBcgcchx1eLWgkp5h9zu5HqIGWM00lFEhrqVBIumFILS1G9+a5QE/jLdrfjRvpymV/UWwDABZ9sxweXnbCgmROox3P3m4NtlTHf3yTX+Bz2/xMVKsKUpb3c8kYNXF7jGl/b+3Mx7QHoR6kweikLPLAtc/Y4ZzHj/3qFkLZ1nEJ3u3VSuxMt9FVa12p0G3vZPvXEzS7vRTwBFbGSjTdZd4VVqxrCfXBvSUrJYlv4cyq/y0NCnxo51SPz8t7gpmbxruDw34jupv01lkrHEFWybpOFC5Dt+uJ8C5v0D8lIrpJEYcs9clWhAnGd1GMBJjikJKuDx/6K3JFaOTAKYCEH26WJRi9yhmteM8ppfYXMR9ErmnuIxlqxcvZ+PEup8EO2fxuXdp/6JR5aMgJQL3DrUhUR2w4Pnd8JKVBuW8uYaS5g3elVnpCuWoEla5LW1xO33X0cHIVWpgGLBKC2gcLrSyPLUzfw3TB/yb2Fou/oB76JBaLWdZjnvMm4F5waje9Zzbniy4gPDRcGMv6ENz+XfNkJyatmg3yLjB1ERCz/k2F0oMPJY5mkMgUEf/qcs0aHBRbeAz7njxbVf3rRijba9V3TTdfQqsx7wx7wfdcvO82X4drFLosMpqSZgwIUrSwLJfs5Wa2RujRUnWTnA+Kc3SN7ynboOBZTWGTMD0wvQohBZcpiT5Wd8FbJ2dwzUlI4mXAAsZBIzQHZ4F3fj2DcGCg9OCoidVORQ9rmILwrSM+QHzHcfyZqVhqL7IbuazXAh+uCviSGAbjFglniyqzGKANfh5VG0Ix1BOotiPtVwOQHcOSNVAgMn7ETKGVg3hYoQv13+Ct6IFGaslxx3CvN5RMLNJe3jHf7GoryJRH+iXRaU
 ToEfycVF
 Uv0BPsC7SVY4/G9NVaXwVJZufHXnWUfLFQfxl9/Buuo99G4EsAk9xwRjuNJ8h+5lglGWp5+EjPwh/TssRM9/6J5S45ncxGwg6kc5C2nFOVzeEe/INcDBszA0McMVxKAEDYwXZ/eg1fsMcVZ4xLS8XDMGwvhKXpi2b0D/BALqrlc/xNly6xrRtKlvBvfgTg/cvWKxUY3qp2CMrRX3NDwv6PzmH/mVf6RycO9I9ErSv6x74wqvbcIUuha6zkTBTm0KIA9rnh8haB4/LotOPF+DhbbuIS7NiLirWohew+8eLctfzLtwSHeaqrlGr5W8bgYhxStJWIWNWc5PyMOEa5wLd7TE6DFoApUGFeNCPL20cU0PfyWNPYmmaOb7EVwb5EeuePcAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 11:50:23 -0300 Jason Gunthorpe wrote:
> > Anyways, reading your next comments, are you suggesting that all
> > these functionalities should be implemented as pagepool extensions?
> > (2MB mappings and iommu backing, proper allocator of fragments out of larger
> > pages, device-less pagepools, multi-domain mappings, pagepool
> > as memory provider for skb heads, pagepool as memory provider for descriptor
> > rings ?)  
> 
> netdev shouldn't be touching iommu, it can get a 2M page and map it
> using the normal DMA API. AFAIK there is not such a big reason to need
> any of these layering violations. They just make it easier on page
> pool..

FWIW we're entirely happy on the netdev side to add this to page pool.
In fact the initial RFC I posted for "page pool memory providers"
was addressing this exact use case. I didn't push it forward due
to low time and suspicion that IOMMU folks would prefer a more generic
solution. Since then memory providers were pushed forward and merged
for dmabuf, and we have netlink APIs to configure things. So adding
large mappings should be SMOC.

