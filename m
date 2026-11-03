Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F8E606BA28
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=oQ0xgV+j
Received: by kanga.kvack.org (Postfix)
	id E22D06B05B1; Tue,  3 Nov 2026 10:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC5E6B05B4; Tue,  3 Nov 2026 10:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75766B05B7; Tue,  3 Nov 2026 10:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 936136B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:10:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A85016047D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:27 +0000 (UTC)
X-FDA: 85394144094.09.EF8158F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B89840007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:10:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=oQ0xgV+j;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vt7h2p23Imler/JHYQ9qmz6AHyS0w7TaI6hUPIpmc2U=;
	b=bc777+jd//Y2aSHux0lr+XrrvxOivJA5g11h+5Jua1v2GedEdbpCyj8sXVQ5T9OWLWML/7
	97mGpCads+ZztzGrhZer80LWZ2yJKwW+gLMU5deQeVtxgfupCjTKOmQq5Hg0AhVPF0DF5r
	eA+S3qZbDWrz9oGUeAK+ngTgpI6N05w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718625;
	b=NCjX71IG4UlBJC/uAvqh3mZ641BxNwQmixdqThVuoAgrkDERjh26ybRtrwyHPrn2dLH72F
	e0CA9rgD3fCuLQf7eyBk984rgA2aVy7BwtT1at6IZdbsXprvTBkDwJGzOMYUC//MWknqm3
	HTQcyUvDNwlCOuVViWB/SDjZSvxv8TQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=oQ0xgV+j;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-53c4b82919fso66374761cf.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793718624; x=1794323424; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vt7h2p23Imler/JHYQ9qmz6AHyS0w7TaI6hUPIpmc2U=;
        b=oQ0xgV+jP3cR0jSYEWgwlrgSVE9j6sVtedtpkIr8PSZxSDrYp9TrD4UI2+53SvHFI+
         9FIcc30sObWr3bBZX5C4NFLPaUVG2cyYGu2+WWrYw9dkNLTHO9DkCRVQhPJMgzlWt1Lj
         vwizHP/veHuGl6ob0TEPgS+v0CNu/fnTh6n/4hdbP/sruyXl/gdu2brTPZcQ/fzeND4V
         Jsl6EBNVyDum7Qbf0QRg/Xq0vWUZEF3Q2Phn0DIf6jpESnLophaGndDAr8qpwZZeB+AK
         Y8E7ktqxGX+cGcg16WZVL5nweRgpAdsxPd9KZTM58lJh1zz8Bi94ehQemB1Ao3ZqqXNX
         RnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718624; x=1794323424;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vt7h2p23Imler/JHYQ9qmz6AHyS0w7TaI6hUPIpmc2U=;
        b=LobDWioOPeUX00A4BPzhSL+owHGwlsfYV3xZ7PTkYDe0nD7A6NI6J8qdN0a1cLGUvl
         8IJt7FtX04FZBDBv39p7gczHMIwsErrpCChGRpjorGpiMEgWNIIsCeyRA70ub36GJoXu
         9egq36SZmbDewRreq9YpQallKhwDEiE0cHs/aH4QXlaCuioS/TCCWZnqx7fFssJaGU0d
         fwL2m4VXhhMFFuTid8Uv7dxHOuZDqYlPAYl8t9tPVrCcJhQ8DAm9oaPtmo2tZeiH1c1w
         v6vGyGjZ7U3fZIU54x4GmMPT2OqhTy9Su/Vz5KAcTXz0e99kjvV5mRSRhN6BCkgUEDLy
         9Qqg==
X-Forwarded-Encrypted: i=1; AKwUvBxvNR8Qa05uyFjeCnoaDFY004CwINhMKIKJe3g9t/d84oCalWNWWOD6euy8URNnOU1/Mqn26enHWQ==@kvack.org
X-Gm-Message-State: APuU4Z883BwQ5zOTnyISJ1rd4wkMgROhTocpFhlc4jAdtAQue/wH02PM
	mHB0KPFg8LKW2Mu4uIsGzvraVAh4B7ym499awGWpnOXQEwbhHKww/kpde6lWHAMTblQ=
X-Gm-Gg: AYBFou3LJHwABGqmDn60jXlbzcColfd9bKi7bMDi0t10AMg0Y2iHuq567FV2YCyJwiN
	Ve1CwaAhPbXyU2s6ZZ700Bh74gO2W+ASFL98XPh+ETshDQt3jVq/nBCExdqR085BbIdXJiuunVQ
	dxiGrKlC+jcGiMWajugrS9bjambIltpx8FOhqBmr7ghbU4LcT0crlQPL4soWYJg3Scnft1cDfPa
	hYsVz0S5oFd/JgAEnB4mt/TOB51J4iAw3AyPhqZ6XAnN5uoMutXuuy1y/hPzhywiYCOjAt9Rby1
	ZMDYqXYlwHEru8xtC2C1N6n3fMq59mFm8/bkHIFSoqaxRXmZqoijSzISVi3UXkZVoYEc8DWTNfw
	FsKeMbP3By3L+jX7UpoxlIJHFMgftd3Zw93OvzdBBZJ9mfj7NZYHXc3VjhMfOQm1JTIP+7kDkg2
	knegnZ4pXugHn0M2j+E1Eg4hwm2VgAN/smvVEdyBueOlM5Bx4HpYSLu3RKqAxdEI3WqFAaqGSWD
	ILTkjLlSX2XQsLq3rjyKuqps3DHCRILNt4BzjYFgrt2a6TD5NFkauAvLUZVpWNHAgwlcP3VPJFP
	7/O39bolwLubqczmSjF8NVXFCAQfGg88v2MCMtysokA1ia5iWYwx0BE02CMOuBI4NPm2KUkel5q
	guCucgEbI4w==
X-Received: by 2002:ac8:5a06:0:b0:536:26db:d4e2 with SMTP id d75a77b69052e-542b639bb42mr236124421cf.15.1793718623983;
        Tue, 03 Nov 2026 07:10:23 -0800 (PST)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498b49dcbasm27980831cf.6.2026.11.03.07.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:10:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xOG9V-0000000DAq9-0szH;
	Tue, 03 Nov 2026 11:10:21 -0400
Date: Tue, 3 Nov 2026 11:10:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Luigi Rizzo <lrizzo@google.com>,
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
Message-ID: <20261103151021.GK3889730@ziepe.ca>
References: <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca>
 <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca>
 <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
 <20261023145023.GH3977851@ziepe.ca>
 <20261103080933.GA4213@lst.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103080933.GA4213@lst.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B89840007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 61u3c8aucrpoc5uw6do4uickckap67p6
X-Rspam-User: 
X-HE-Tag: 1793718625-558622
X-HE-Meta: U2FsdGVkX1/z5M6GO+7Yuu4Uz6aE8rOuTu6o/iu/LDEPBvtBIcMdeY6P+3wPyuwVAYj6oKkIYoh0/zpgoL67Y1id6v5wDCAzQAHYqSKdUGvU/8JvP/ZQiqKXcgik8iTQC4lRJlUjqMm+AkF9GqK7HCwP6fZ4qsMlS4Paxx2cNUd2+FYlokB6p6KLXm+d6bkw6IbrE49MbaiXBwAvUsQMfp95fklpgvbMcnSE7nEEynvrEtwYdkSuMnkEuwpM7A3rPfyhXYn64ZEkZx8iMpZnqKK2n9F1LcWv+UY5Ej+y4+HumNOtEgwwJY0W6HoToO1CdjU7Mv+c7gu/fHttGEirA+6nkAsiNXMH5nz0CgIKdYXJ9sDiFYrYXAE9RHQES+2nqOwJJVgxTvKPRy9UgqIcjRfAnhEhasg/4LftWLJbc0P7GVWhu/UNp8HVTn0f2h7ptgoCdqZm0FISowkAQnSIjo90AXmD+L54g2TjvDiRkeBGJHxStFQSYBAS9JyNeqaxA/2oc4bDsg5nXMMjVulDJKn9nKrQJ73qdnF8bpGFBPyGwFxCNZw8GUkFWCDXJfH9/XmZHLM+b54yww9rpYUGuhSx4PlLO4ZEYdjrmoVXYxebyqGIqIbvBEjkJrQ9Y0G/vl2hGVAgxQihGbXhz6+BT/y8s0c/gYIK0O8Qb10qGepvBYMAZ5hfWMUi6fmX4wveHt0oQO9C9XICFEKPcuX7INicelItXEWIQ3ZufxLSzXnnJTXy7St5glGm/JvXuofpM/iQpVpmwJIjsS8RAruoMaK2JI1sBQ+h3c9KLS3RzssHW1gUyj8tZSbOPUi1MGaCMlDUp6gK/Z0iXxj3DbII5WJxgan2NDDRNVwWx+LYa/FZhdOCzRN6Q3HiWppWJWcYrj8Yy6Gw9k6aKL2uOqLxR/TaxLQah3XN4htkzcohySBSxr4srF7co/9+MCgXO9ne4h/qEmzsBBawKNVcdX3
 mOka3xeM
 UZZyGABnYuw1HktLxKAckFSZ8daTgozdTKkczFuHPQ1NucboyzG6S1KVNhfO6q/TH/sO7zyoE1xxxI9lYA1rc/W0RUYglcgOV83fLrK50HwyyfQ3nh0674Cv5GiYztkfTAskOYpLLLrhvND3chqSANnS4dDDUhwHRBsgTlCZYBlZhEdACfs9i5SY8xYmYjHsoAG+PjVRLT2JzhWDD/ulaH4HonrthwxIr9XDDeH+S8FciQTdPJ5+44t+E8zVwFeUmIm1TNlt4YOs9L/tWUBvnPTnJGhji8kVajQ92T+upEDRUHsb2UEpYVQfKtIQrA21enXWSPK8kD80gWrB2Xoxoouk+gfSUaj3at65K0TpOPkHbBA6Vg44CKr1B/pIntIFdx8UsuYut9R0xyb9TmSf8t4eWnz1DD0ULsXMr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:09:33AM +0100, Christoph Hellwig wrote:
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
> to do with disks, except that this is the first user.  

Yeah

> The dma-buf iovec can work for every ->read_iter/->write_iter
> consumer, and should be adopted more broadly.  Including by
> networking instead of their own totally weird different world.

I'm not holding my breath on that one..

Jason

