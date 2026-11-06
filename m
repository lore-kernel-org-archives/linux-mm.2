Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BBE606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B/mbpzSL
Received: by kanga.kvack.org (Postfix)
	id E35796B05B5; Fri,  6 Nov 2026 09:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4AF6B05B6; Fri,  6 Nov 2026 09:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD32F6B05B7; Fri,  6 Nov 2026 09:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADA066B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:42:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 301AD80D13
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:42:10 +0000 (UTC)
X-FDA: 85404959220.18.D58C3E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0DCDD14000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:42:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="B/mbpzSL";
	spf=pass (imf23.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793976128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPrT1d3tfAdRZHoFdKvhwwCCJALbTuZcl0ma0HWZQHQ=;
	b=mqxKphSCG6lOu7dcMKss2iGbF6RDH+r0zui1WxWU/ubT/u4ivUOYmkkUqtgv/p5FGGew/4
	otdU0c2AXX3uRAH/UXEXMiYk3jGfs2WcJP/B5s5XFoyuwZY4U//kx1rct/NW4Yu9dRG/BB
	46unR9Gd8bWC67kp2qkDL33LJ3epwDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793976128;
	b=D1946Dtolg07Gw2VVRhdZqB/tLk2ZgMWjI5e2G3VmAHga9KWTtVw4OX0RiaKLcQZ/K4M1I
	ioR176qQ+okILOcgV/y7cNAzHNlX74+dAeDc2duVHX4j1cYvw/sDv9sDHpuhHVhc2O99Y6
	pB19qC4t73wSwVxbpxnpdPrm1pV2MSI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="B/mbpzSL";
	spf=pass (imf23.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFBD31682;
	Fri,  6 Nov 2026 06:42:03 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C297A3F673;
	Fri,  6 Nov 2026 06:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793976126; bh=RROBsGVNy+Oakstf6DXz+xH01uQZXz9GOkcgQ0meiw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B/mbpzSLUIxkLsvdYEgUGs2NsLPfEoaHIS2u4uoKA+TM6l8BAPmmaFFiWCiMC/+zG
	 RnZu7A5UIYQ7u/AWqfgGaXvhX9c5DxYbnRdfhdakUjLrptQLm8mu5OPAnNzPX6lE/G
	 B3q1sAgPLmHroCXLRJ29Lu6hp0qwTMoNkNoh4n1Q=
Message-ID: <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
Date: Fri, 6 Nov 2026 14:41:57 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
 "T.J. Mercier" <tjmercier@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 patches@lists.linux.dev
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261104164555.3555725-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qn5j6kcju51jhgexhhbxugw7br8wu4rp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0DCDD14000A
X-Rspam-User: 
X-HE-Tag: 1793976127-39460
X-HE-Meta: U2FsdGVkX1+3Kgq4BeoGQnSMJDfIC9ISj2ym3YoPfASasermBLAEv0zqLD7QbBka+EiMxgaT96lv3t1ujZScAXcwHcAF+HGD+mulIJ3tPIVmWgfbLBP58K60+WZixAFdbvOTgJ2/kpemqtZwwwMEbkgtira33Obp8fJGSH87whKPVlKpW0jiFWFmOKZkjRW7Zel7jaGprI2KGpZT2sMnGyXwPNYujnYW2UJPJ3ARcRO5NVfe3mIYKC8oB2mtgrEzCUEODHyVeg0/rv2yvT2zY5wuDXhMYUA+AIi6hPiaEffJxLKIrwiUwNuzFbD7re2D+nCB/5auWn8buEicdPA1UcgAPLWkA/NDRmntuwtw2LOkWn1zVQ3p32OaxzZ5xed/WdkG2c/tfOx9Z6hvBeqSTWKhgAUFn88IRzh1bCBQQi7yt6M/wFfhTZPV7RmeyRmeSdidsQjh4w3tqAwAaxjQV+4wq2FFUie4V4W9EPEMkw3Bwimra8eZfgzSuT7EZlV0qbCL0nDiHq6MXQ6zsLvJj9Y3xRVriU/3+5Mm3EAOxXpMQAAzd9kA5GyngRO/hajVbC76antS/Tra2mnEsAIGMfzjxnrEjn7S8DWzqz/d8BU+CEg/AnMoRwceYomFQJ8ATDIQSDG6fnu87/8uNVj6cw1XAzqXXsHuYbKOn2lvxQmthE+dlRJWwBrpMcevM9n9F0TuwnLg4OLvm2mk0DL/+8K9nKIgxzfb6kZcF6v3sJV0+pZiFl/LmbNz53CtiWaOVZGrqwDLs/J69Ky8ocYnI4KTIVpHvKocUc8JEbTOuQFCndxkRP61dbOeqfLJ0bDJFnxAmujjjz3WDnSfPveThkuDbWZphK8AhdBAKp0VgYaKkRTe/5AiyweegKnaCqks7hW1pQ7TRmgf0+Y7/N0YzLsA3kRvtpoUuseThlFL6EPVEn95hhBKFW5iAkw6qNNtXfWf6V/VZCBCBjmfO+/
 Mrvg75p7
 wM/SV6afGwOW8DonnU2C4/n3VV6mcOt8NrmJsFy36Un8hjXqKP5NIPOZS/Ix6tLpqWgaAN2g3pC17U6sJ+Y/okfzOrfMGrk9trleeOotlC9JXc5fU58rjftIsx002mnqokzjQtvp7HNeH1LLqXHaF4ffiPh38OU25hoBBAcss/6XL+X2OclJaul8O1s6eadJkhLKO80+K/SgWFFfdt+GC8I2MWowCquHKIQ3ukN2sqECA1Yh0q9FkGdt9/vq9i4W1qi+JxOlAcgnVN/dtaeQsuuGD2QgQz8DNRsLWEkKUuHnENH5FUhbZuoMS8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 04/11/2026 16:45, Aneesh Kumar K.V (Arm) wrote:
> Confidential-computing guests may require memory shared with the host to
> be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
> users need struct page-backed allocations satisfying these requirements.
> Provide a common allocator instead of requiring each user to open-code
> this sequence.
> 
> Add alloc_cc_shared_pages() and its node-aware variant. The allocator
> rounds the requested size to the architecture's shared granule,
> allocates suitably aligned contiguous pages and transitions the
> complete range to shared state. It also preserves the caller's GFP
> policy.
> 
> A private-to-shared transition may alter memory contents. Mask
> __GFP_ZERO from the underlying allocation and when requested, clear the
> complete transitioned range after cc_make_shared() succeeds.

This is not true for pKVM though. It is the other way around. i.e,
pages must be cleared before transition (e.g., from private to shared)
to make sure the contents don't leak into the host.

Do we need to handle such cases with a pre_conversion and 
post_conversion hook ?

Cheers
Suzuki


