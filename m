Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE4F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E396B05B2; Tue,  3 Nov 2026 03:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55C16B05B3; Tue,  3 Nov 2026 03:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9935C6B05DB; Tue,  3 Nov 2026 03:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 778806B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01BF0140302
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:42 +0000 (UTC)
X-FDA: 85393083846.05.864C9C6
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A0EB180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2on3ft6XH1eubxEl0nHP4ZK9AQjcmYaJw++Tp033neA=;
	b=vWhy/vllmOuufumnF22+U9qomPZR1VCWcPpluhpSacYNskCU7p+6GudlOVNZ+bfmZq9lfS
	sqkF8OIN8sdFFZox1QknTBvaMXKAyw2UDajTVpeoghbvHjtYAB2RGpXkWg/m6MxM+sCBT4
	VnXqMd6cZvOwSxuWdIdUeRXdu7maGDg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693381;
	b=NqCeWRwYZyOFer/xeqim9PnUSLhUMH27X8DMSQJKwCwt67nl02ZrJjSzKOb9EvkIlgJciT
	NKbK5hcH2PSq5gdiA0zYlX1x2txc754VZx8U0M3K6yIg9CBweCCUeG//Xwrlg3x8q1QxmT
	I7MS4fUqpgSpS8CafC8wtkVp/Re93Qw=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1E82268B05; Tue,  3 Nov 2026 09:09:34 +0100 (CET)
Date: Tue, 3 Nov 2026 09:09:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Luigi Rizzo <lrizzo@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
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
Message-ID: <20261103080933.GA4213@lst.de>
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org> <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com> <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com> <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com> <20261023140107.GC3977851@ziepe.ca> <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com> <20261023145023.GH3977851@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023145023.GH3977851@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: ntmes494x1yqxnxfatad43xwyw33y3rk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 4A0EB180002
X-HE-Tag: 1793693381-518977
X-HE-Meta: U2FsdGVkX1+raHmxpJ2OW24jnm13/El4U0T38prlAO8NkGXt/h+NObCWYHsz4frFubWwbWSiaqx8Ap3DTvFSg6HU4Z3YfF783crp4kjzMK2/uLtv7WOu8EI802hy4B7F4d3xXvrt1OuEtygeHHk02v+AhDbesZPToqackDMdcxub11vxkFC51AZA+JSxdULKmhd9Lq0kzOJIItHSISutNcYOONkPwoqZlRAXKq02HPRF91SnBRpMre99Tl9+AqFHlKa+0JbNLABKxsvqsIllmIlgjmhvZX1dZ8ucSgC1DprL/EJuIXbG++enbthW3hWEpjVAsOwS/eqpTKSkY3wrepcFJPqJNKFVSTbe73DDFUltrgSx8BLVBKccFRKjUW2NMErKf8wAP2xSMOx6j8cnfiZpEbjGwZ8kUAd5lWikGNAAt+6QVM+WmcIuo94rX3ecimD4q9fQUKwHP42vyJ0I+dUxyovYAJaFQv09TrXObA9X/XKklKvhQJQ92AgAPSMtW4aCOAIR3v4vNyuiRym+ysS5l8ou41AnMGQJlmrsUJQdh89OcTq7R2vmXNX/i2E5fn0U0gH0uoV8bb9xBYj5CO7V6lnGQ2iOnXvohB4VNzQmAekbZPiWxil3QKpOOajMjF0mdz4elYXU66oOYTNPOSLehddUPW0SlVduJtfXwgD+TFPfU0koMnHd31OrvYBA6L5dFzSk5Hny1Is5Y/1Ou7PlB7kXIpHIRjzl4e2ATV6G6e/pGZW6TpVcQzKLFTBVEuZuxKRIFTl+/Bwrpp6wm2TRM5e5eBsF+EVBsdNC2VWg6jzFZCmBvho++fZNupJpZcZElb7/oJvV2JlTjBT5r7erSzYr2/7pSdi0Q3BemdL47NDXuw56Y8Otdh9J6k/11PXrciZ7YiihF8sAbIcdj4U9K6ox0SFvmjMslETeeNdMXlsnbYtGgHIRgRtW8/jAo5Rw8E4eCwD7litftxZ
 NUO0IMPR
 KPyLYj7bup1Cb6TqLV4nf6TWp45dgmqzn73+EmHNQZd2wE+NETZ17g5aVjAnkZsdMusPEmUGGwIAIft8oWGTujdztJWHWg5Zs3icwRo90wkkMEBrHvnF0QeDW3erfwO+dbPSZvFIOWV9wrjGGoHRH7lj8/fnI1UXlKLP3nJxYRjkG1Ymtxjj9RhFqexWQsPRS/Dpr8ZfQTt+Ia706r6v9srBjrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 11:50:23AM -0300, Jason Gunthorpe wrote:
> > Disk I/O is still potentially affected by the same problems
> > (cost if io mapping/unmapping, iotlb thrashing, bounce buffers
> > in confidential computing...)
> 
> The disk folks already have a proposal to address all of this using
> io_uring and preallocated buffers. I really doubt yet another version
> is going to be interesting there.

Huh?  If you mean the dma-buf I/O it doesn't really have anything
to do with disks, except that this is the first user.  The dma-buf
iovec can work for every ->read_iter/->write_iter consumer, and
should be adopted more broadly.  Including by networking instead of
their own totally weird different world.


