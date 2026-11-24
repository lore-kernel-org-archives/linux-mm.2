Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBCB606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=kjgDuUMB
Received: by kanga.kvack.org (Postfix)
	id C96A56B06C5; Tue, 24 Nov 2026 08:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C470E6B06C7; Tue, 24 Nov 2026 08:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35E06B06C8; Tue, 24 Nov 2026 08:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7CE6B06C5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:07:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0540C80B71
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:07:57 +0000 (UTC)
X-FDA: 85470040236.24.83BEB5F
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FE6D1C0013
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:07:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kjgDuUMB;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525676;
	b=JPM39KdgW6sqeGmz5ypggknE1gfjfFCv1Bt+bnTAvBli0cDkptouvye1LBSto4WUtWU+xt
	k/9DStjlSiBj/qseZSyzeJWcjkiPg3GAVWFb0BVdFZsjhu+42hT8Up3E9PlOXlCbiidTmA
	5xB0hGVyloyodl1iTUNtWtibBu9pv9E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
	b=CQh60vDjwaIhYhw6bOyOnNKnMUsDcLK8IE6x7UJ4oGPL3uic9jlCiPoxUZDJVI8Nfkj4kj
	2jolJDzbtN572V5xtAE+Qyy0MqGin1AFviHxPcousiw/F0ilbwhjkRKgeMV5BzyuBdYZ+4
	rBhlamcpw2r98vdbINhJyB85IrV8y4U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=kjgDuUMB;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9497a167a6aso659104785a.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795525675; x=1796130475; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=kjgDuUMBe/rij+96ctbdbmq8reuPhcaKj0/cO+QxAUzAT0vEiQC9nij3mQmdsSoYCR
         tFAAqs2a8kEMU7MD+lFhOqohstHkGBdt8PpevdExWcKrGhyn2McfgiUQ+a26FLuMWJ5r
         PpD+4srIrd7x88SL32pVqYBc1yabMMDG8kYCByZzixJlqBThU1j6SyS1iCyWIua8eE7h
         HVyoQ9tWOpvq5fiwUlVhLyRwJCPB12mpkgnAMzRU/TbCnzoPKu227Kq0nq6E7xPNGwml
         rkqCHnICF6ceCsLUXr6bMKqbkE9YDeOQ+gZSG7FTAOoGzW74Tt7st9jNDg15LUFujaMY
         f89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795525675; x=1796130475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=jI6oB7OQMERJ3qU5m/SUixzNNTLXRWx3KlXlPc2euWcplA095uuzJvIAY4iY1QUgxd
         MjQyhQ3MWDcek6/2XWH2SOACGFstDO7Qj1VD8t5jIU5+jedQbd+LM8pmEyE+SK7Am7r1
         pBunLj1eQ3nGp0yI0Yq4cgtEoYxYtA3OV9f4+qLKF+Pc9zv4JyIWI/h2iYotcVAiBSbI
         9k2cC10imslOrMwPTX+SrA310pUihMODLbhftAEiOwtZHyG2cIpkrIoJCgJ4LHKK0Cfz
         rdv4ZDQAtPME+nNktReQpQe+fPMkEDNLymJdp6smdwBvMzIIZlT1IrzxFtAdXO+zE6cs
         6HTQ==
X-Forwarded-Encrypted: i=1; AL+hErEhDL1CdLmonzKACMYDiA7ukx708XalScpzZ8mKRh+ULAtr2YSIIigjDInLXZjOFokaBtiX46CWag==@kvack.org
X-Gm-Message-State: APuU4Z8Br+oj/Swdb8/dbRWXycxL9urI+b28tY5KrtGVenJM0I99ashm
	Vp0KwHpn4/Lu9C5FS6GI3ZeRawyc3ton7Ig6K8PHh5RLcgQmpWiamqRJ+gc7lTjsdj4=
X-Gm-Gg: AZFdTZcLvN8X4qTkvZtyEaRbRD7GMPg7i8Qwu0NhNpkZNUBZ87canHFfmL2W8SA24Lj
	8Dr3B1u288ZIGRMYzWYkw1i2RPM9ZNf7Pq2uesxmaUF1r+yTuzizq7r8LpyVGo984et17zM62pR
	srbh2H3D/Q4IKWxgyt64Av3w4mFxy8Y8PxkAYIo+2Gw0N35ja5+qL7nF9vDe2mAkXqDavMJPA/l
	QD02RcwFmsQBHXof/N0PD6rSu0PyjVEoiS2zRoPG7HV7C8UAsXS8XsUH7qLgW2H8rkvH+wyKCH/
	Kj415maS902p52v/O/H5vt4McCS+bvuPVG3GfwcJhH6GJATyhE8fxiO2ussNp4rd3j+z9cuIRn5
	79I+SPWIwK2UVYE4pNJ9TlYXv3zpqLXFnMqyx3idI9kB3pEbWdzaWNgdmHXZhul0hT0DR0u0jCF
	CgzsX9dh42GfPW/1IxWmooih8lN3JQAimh+AyZYQkl3lI1uaIZ9waHWWbRetH4g1UOZyahuwRQf
	9+GNDaCVIFtQ/kSKhqwPH1BA8tv+RSueldRIsk1nwWGv/yZDPjCfNlZHu0lBjoojTL9S0d3ENfB
	N1Namg==
X-Received: by 2002:a05:620a:2705:b0:949:8ee5:6faa with SMTP id af79cd13be357-949ba818db4mr2224332285a.4.1795525675010;
        Tue, 24 Nov 2026 05:07:55 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb4219c4sm1034879485a.41.2026.11.24.05.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:07:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqFV-00000000OKe-3ac5;
	Tue, 24 Nov 2026 09:07:53 -0400
Date: Tue, 24 Nov 2026 09:07:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124130753.GD9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <20261123150041.GB179082@ziepe.ca>
 <awSGBdS1AiFhJzZV@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awSGBdS1AiFhJzZV@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0FE6D1C0013
X-Stat-Signature: d4stmhahqbqsuido4a63buxtatk3yaxy
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795525675-390710
X-HE-Meta: U2FsdGVkX194DX7pOKxX293w+m4cRoLZBCccKaEFC99gVtoVEVOjhPWjuRZEaE0/XPxZPla74Lj1PFnmrEBzEfmwzNtAGZ0oxMkAhh1wAFyHZtiRUR+LMj76UDxqyjOGr0yUpqCEDqZH8zQS10TBEVkmRixbrxCM4lk4RI6kTrs5hUfDDZjZd+YJhoRya2qEiFm7pTsyD9QWgx0T/q9tQ4ndTLS/bliVMhcFaMEmIgKpaE9kGofVREVAGTZofzPbOBpHLVc0cKP1GixgbW6LiBXhaBH5uiKC/cCelpDiG32l4AV5gFDxLwy/suPHr0QqlglBfYAqp0oK8kqVghvP/6KR0oXL7u8QaJ7XQN31pzhZIosd5ANL/DT3o9L2A3GMhHuSR2Xd0JMNYxEm3BfiUm+R7U2n40MnNOwinW1Nt227zNh3NsF6CnPUP4WtkE7RNHezCDPByUgZLosxypgGJucw4XwTF3XKBJ8oamMHL1vhcDW6sy5Y68f9VhiNIm2zjyUDB8fOGOO7KokzwjOYR2mE6IgA1NDvS7yObiHInxrDrEVSrPKyP6rIiufz7M9OLdDg760DZH1x8fCdTzmdpxZZNWJaylQeNrwtqD0o2ngB0E3JhqSifkp4OgG+hWKCod/rYOPzIqtYW2M4Xel9ACf9wz6tqdD0GNKGRZlOXrVDiz3xNh2sf+1lE3fijMPlrdWgU2tzX+te0SWW/rqJFzww9gaQlyn8cQoxOlyM5FUNyZ4e43j3C7laCKZYsCBBUMAU8cdS3TguGjenS3EbxQbspBGTN5C4MxoiGOcSSianKqN7crSytZUQ2F/0G6SZVaDtzlpzhzLCm5ZgC8EhRI/9kynTzGJsUiEy15ZmRW+oV45sJquEACVt0KUW3P6WWHgw3AmW/a6DznvORYY9kKQ1xyWLVTvRUDnapLnGgLk5BjkhrNVttyQOQo37I+AiO5VvczQl8iXLzLjZXsl
 pYCEf6iy
 TIQP0y5uj8HNDzqjV4sUQAkZyN3SeUvYS+ur/MJG2GBUVIXCLktt4brGypjEi8CCvHQK04QyBZdFwFGK1NcgnW4Uq34gLsv+bhIb+wo7r9YYjQJxKbN4S1Rml+RjfLRPaBGQJnPOtc1xtnjRYrVqr7R8HK+bJ4M1GbdV0XGWLKWlnHspAC2IH6AKlnj+eXJrBxmpXLMMVKy2C0GlZqER9rwPZsvBKGzbAUr8pIBxAf5m7+g6bKtvTN0u/uXzwzz8yRaMifw9iYkIwawKNM3pPc2osVXKYtlll/QxfGwlrL6phgBIdOnN88xZditVkI1SEvb3Sgd0hTnv0ZUsIVqjklnVBymARYkfccVyJg2LtTY0A8R9zmvDskBWwfClGtUFONXlVfIsaVHZDLz4O1YQDgOl0y592q+sUH+mkHdI+vZI/8yLvSJeLQwaf1vGwup5vdrEN7MKodP+ocMh68ENCXFpu/ETVrcEKMNop0BZoe/Nvy8/vkzgTdU/to9vEcnZBTkZRda1ZZ8/5djhSKDnNXySu4/1LwU35nEzufHKFQfzem2Cc5dRY8UKF0Azr6Xk0RHRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 06:29:25PM +0000, Catalin Marinas wrote:

> > Exposing struct page to places that just want a kernel addr means they
> > have to call page_address and we are back to the highmem weirdness.
> 
> dma-buf system heap needs struct page for scatterlist, so we need the
> virt_to_page() conversion if we return a VA.

Yeah, but if that is a one off I'd give it is own API..

> > > Was there a caller you had in mind that needs the common allocator to
> > > share less than the whole buddy block?
> > 
> > If we want this it definitely needs to be a void * based API not
> > struct page one though..
> 
> For whole-block sharing, either a VA or a folio works for me. If the
> allocator takes an order, the requested size and the sharing granule are
> both powers of two. Rounding up to the granule already gives a valid
> buddy block size, so there’s no need for a separate shared_size.

But you still will need the allocator to use the struct page metadata
for its own tracking information, so it shouldn't be exposed to the
caller..

Jason

