Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC27606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=So+WdnWi
Received: by kanga.kvack.org (Postfix)
	id 2C8C26B05B2; Thu, 26 Nov 2026 10:52:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279D56B05B3; Thu, 26 Nov 2026 10:52:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F8D6B05B5; Thu, 26 Nov 2026 10:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A55F76B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 10:52:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C635EA051F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:52:21 +0000 (UTC)
X-FDA: 85477712082.18.12114BC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 348AB4001D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:52:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E995E1BA8;
	Thu, 26 Nov 2026 07:52:07 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D9373F632;
	Thu, 26 Nov 2026 07:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795708330; bh=t/iAXo76mNWOYi6NXRXLm9HYRbfENwEmeSuVZl+vjQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=So+WdnWiITxUEA+zPA0qZrHfIgEWB8UDt3yn4IEO5THcFQuUupbSyZ38WSbYLlzZO
	 Rdd4TpDOmHWWTHsRW+t1aSXOFu6+xeusbEXx8t6R4TR3fxZ+3I/eAfWH7BVYVPd6hg
	 fcIkARwHaaJVtuaYyOlwbtgwfzyTh/vzHdKQd+qA=
Date: Thu, 26 Nov 2026 15:52:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
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
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <awhVoDXluqpncgcd@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
 <20261124134621.GI9566@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124134621.GI9566@ziepe.ca>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 348AB4001D
X-Stat-Signature: peqm7h5r749azuwsrr31tjyuo613a48t
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795708332-981086
X-HE-Meta: U2FsdGVkX1/wYDex54wNPTn9mDk9PMXgRBXQPdn7RShz0a8fAu+tIOxfDd2RvLC9/50JBcl1RabGSJGQs2XUTyYSYAAmcXFa3xvC5kpixkozBemahDCsr6CCHjmgqFjWnR1eGPWkb1oRdV504MaC9t1zqtL2RKq07L7HIAM8ru+n1WlbwZG0kPkmIR/nMEMBjLrhJ0ueFND+lw4MsseROEJNVSo5AvS/bApO1lRurEb93rJ/mtlOfAway/AK2wBQiVwSOXtiKc9Zl0vavYpzc8cZeTSCkHVnpdz0ZSnbUgna85R7xyn9UX+xXLq0ubmcnp0rUfFIQmccUchEoiu3at1WIF2pQtTPz0XyyDDroOLe3TV+lSYaFS5ICRaLt4BZii0XAAwB5JBTSPKiCqQ1eLmmtUhEQlEBIHo4w3AMTlvTnkDJ1LTyOiRYVKqfAH0hOpBvUTTobmIaHXicEZ8YJc7tpO+I8YDRNefybvxt1+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:46:21AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:
> 
> > Taking Jason's feedback into account, we could have the allocator
> > request compound pages and recover the actual allocation order with
> > compound_order(). That would avoid passing an order to free:
> > 
> > void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> > void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> > void free_cc_shared(void *addr);
> 
> It probably shouldn't be order here, that is hard to use. Just size_t
> len
> 
> And round up internally

Minor point in favour of keeping the '_pages' naming and order is that
it makes it more obvious what alignment is returned for code that needs
it like the ITS. Otherwise we can just document it, I don't have a
strong opinion either way (only that it's simpler than what was proposed
earlier).

-- 
Catalin

