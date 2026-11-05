Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B70606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e+FQOIfN
Received: by kanga.kvack.org (Postfix)
	id B6D966B05B7; Thu,  5 Nov 2026 11:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43AB6B05B8; Thu,  5 Nov 2026 11:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81BE6B05B9; Thu,  5 Nov 2026 11:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832426B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13A2F80B61
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:56 +0000 (UTC)
X-FDA: 85401659952.10.C295C8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 778A1120008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+FQOIfN;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/YTY8Qo0Zgoo2NfvapWx8uwEG48gJ3/0t1KofHUSvY=;
	b=W6AR7dE+IuGoWs+LWTA2y0ekt5UN7oV57qpvhhFJnB2jFh+dXWBVWg5FuDEAuQb7IR3h1J
	+sN8lOm6wTAIrVvtbDDOiToboDM5PiJNoYdJyum6I/MeBq82mpPrLBsFoFUPUJLKYvIZjb
	d9TsLXj3aQXr3pj6z+y1RiAjjeZnCAg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+FQOIfN;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897574;
	b=8FCtZvZslVVWkNQm5+JUVmRcHtcRqvSnUKIgvixjVblRxror9l8FaJudw0WZfSUwJhbvLl
	Iq1ajBkUdhBwMNSeqlNJXm+hSirhlOufjNqQK6XSY5rUFrdAKc2Wmg7/mCpToPqFpBzA+Z
	KJnqvPnivNuaBre/LiBr/9e+zon0DSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC905609F5;
	Thu,  5 Nov 2026 16:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78131F000C1;
	Thu,  5 Nov 2026 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897573;
	bh=w/YTY8Qo0Zgoo2NfvapWx8uwEG48gJ3/0t1KofHUSvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+FQOIfNYc9wA2g3UCHvH9NgrcOuRcaEGDzbgAv1EgOtmrRJPSTLBvFWZ4/FpJD9W
	 15AaYXrjwrrIpdWszwLaHSgP0IXU4dOJPmQRRLugdqcsOFH2GeRuDWFj4MjhUnBoFp
	 4Rzs/MfQKLEVOfF4GjK9p5j1nvikqWdTzXny56BY2WP5ZbDBEjhwGWJKh1x+rGL6ds
	 KziVI0OEAA3uFY2MyCXCxryvNf3Xye1hcZiGd3E6GHX/hxDJr6irTkKG3bcd3HJMf/
	 asEvxYDhlE469H/oqIzFUy8r+vtIfVfmwvIbI2SxLRDvqAkwSW/6x23nYBVWbcgDlf
	 sFVJw80vCBp+w==
Message-ID: <sashiko-outbox-199546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/14] swiotlb: Align shared IO TLB pools to the
 shared granule size
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>, "Marc Zyngier" <maz@kernel.org>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Robin Murphy" <robin.murphy@arm.com>, "Steven
 Price" <steven.price@arm.com>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Russell King" <linux@armlinux.org.uk>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "John
 Stultz" <jstultz@google.com>, "Mark Rutland" <mark.rutland@arm.com>, "Radu
 Rendec" <radu@rendec.net>, "T.J. Mercier" <tjmercier@google.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H
 . Peter Anvin" <hpa@zytor.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Long Li" <longli@microsoft.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Vitaly Kuznetsov" <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, media-ci@linuxtv.org
In-Reply-To: <20261104164555.3555725-9-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:48 +0000
X-Stat-Signature: bqz7ts3f3mdca4bwuehhpn1oauxrpraw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 778A1120008
X-HE-Tag: 1793897574-281833
X-HE-Meta: U2FsdGVkX1/C93dJOormtTLQVg645qEl/d8agqfmcBhLxFWNrX9tSqS7XYgV9uyU7AI9Gjpk5ctOcKJD6Bsz11/QStY0mR7Hz9LOaL9RKWNH+XubIkgn8+O0Sy7Kusj+Uh/o+Tj0HMkDrEe5yZf9KP/34SGVJezVv7NKTLjTCoIM4aLdYu7TCwQpJ2TMinFt0/uaAEw8lIyADRvwyvJFORkZr7kIBcMDWQna2DhbqOpV2X0z9tnh/oitC342sKuC7LHHxCEZpYb44zhVRoPWbES2oD4Hb5JprZU1a4d+v1FeZuEVeYqHH9m2LzWo3S2Q90or7FrdR0eoL7YfWh+6NwImE+KWRtWEgTJfDRthUyKip21BgUwep9jX57C8oNWK9HpTJRg8ycs4lBqm+MGFEywpwYbd0+9zZZJMHoWVBC1P89URmNDcv3iI+dTii14p4f5KAtAFNMOV0tgUuOZZQC/Jnl/KEIibJ4TxJLSWT3fFAtt8S2z/blDfGSlHLIhUQzH8TsRt0oJk/v0C3TVmOazd4/nOCyBvYuOgzU2/USr6OfIwwQyQRAvc8ykKvCJRvmPkdJJ9+hiaxSpWCXXwUHhds05xoOqfxQtXjMhtcMVs/I1X82FDJZd+6CI7ZUqhBV8G/AOXvW9UKYgZq5ffzvfdIgdw6rH8IHBTWxjzTTXe1DIR6kd9k6cDAz4ZDaY1mYv0MFJ67w9bBQypOzYcE+IfOX/9G8u/PxxYX5TIjDrxe1OZC9wZP9RrE8QkglbaPWK/zptfU+5F0NAm2+q+gOHxQaV8fJ0GIRfd1DvwqFIpNg3+LNpLA4h8NGqgNe056pcVD6+J1kLzN/E4xxSlYAGpLxB3CAaIcBWzFc198bXTAJHXXLIJVZBAbAIOQQKS1QFuw+qRqcDAdHNkAoiJNacqriPJYhx9woBXIPuFyRVGoyv1JXC/ttPbfRMrgHYkrECHzAPZt7DjR/Uw0E6
 L2i7UAa9
 mwWsg4HDffaaHXYzTlY8yIgXn5PObCnpYUqjDwQZGbx77dyKHwUIf4Xe5F2m1riIYpgQYAVZG4pfHPmUqtoh21A64wy35bP/2lIjozdaALACajATuUQ7VQjxC2uw5QRhpRjPq3N1JacwacUO6GoqNazOwUUGoe+Q70/XsZuzeJ9ACzU5/ftVIOP0V8aY1ZVGVCXCgZIjNb+bKWcgUBbavK2/8ovepGenjQ0rWioWIfiDl2nSqDr6iVsvVTMbhV/PtjrQVqYiH//MMpzvT22cnYGA6JwoGDmVkx4zk6/Yupx3i5u9C6Lx7Il6PpSe2GLc2zZEg61AsLagIg1Lj/EwtZ+XMRWhw88cBWDcJrHDlP+FVWo6Q3lqCZQSCbpP53CK/d9pfeTVVA8f4aDnOjz+zy+yl5Ubz0JTDr8ANYwYCB2fJyMcmNQo3Tp1CICrhavMBSLBETX2zGCvM0q6H5NIrrL3lCbadl03eV/NlqVKaOvQxDBtohTk05d13aPhcl9fFe/hp308hu5Sam4qe1jYXYex5UQXwZgB9HfSpxA81qXaP6X9wT6j1uZOUh8sSB/xpELOFBTa1dvpT9j1SmOJjrjB60gHBq7LJtXcK+wKh1MVWQ04z7igROJGfQXJhd/IXqzImPTlIrcbhTgS585SoccqLSz32xzRur3i8ifXJ7/7LvfC7gHJIjaZsDS8+Uq8lZ9kKbbI4qOri9Wg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] swiotlb: premature linux/set_memory.h removal breaks restricted poo=
l build
--

commit 604798053e9de98cc147fbbd212cc3b2c9896b0e
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

swiotlb: Align shared IO TLB pools to the shared granule size

This commit aligns and sizes the SWIOTLB pool allocations to the common CoCo
shared granule size and replaces the default and dynamic pool set_memory_*()
calls with cc_make_shared() and cc_make_private().

> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 2c57b49ac7c06..36fbec2241e4d 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -22,6 +22,7 @@
> =20
>  #include <linux/cache.h>
>  #include <linux/cc_platform.h>
> +#include <linux/cc_shared.h>
>  #include <linux/ctype.h>
>  #include <linux/debugfs.h>
>  #include <linux/dma-direct.h>
> @@ -38,7 +39,6 @@
>  #include <linux/pfn.h>
>  #include <linux/rculist.h>
>  #include <linux/scatterlist.h>
> -#include <linux/set_memory.h>

[Severity: Low]
Does removing linux/set_memory.h in this commit break the build when
CONFIG_DMA_RESTRICTED_POOL is enabled?

At this commit, rmem_swiotlb_device_init() in kernel/dma/swiotlb.c still
calls set_memory_decrypted() directly:

kernel/dma/swiotlb.c:rmem_swiotlb_device_init() {
	...
		if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
			int ret;

			mem->cc_shared =3D true;
			ret =3D set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
						   rmem->size >> PAGE_SHIFT);
	...
}

That caller is not converted to cc_make_shared() until the subsequent commit
("swiotlb: Reject misaligned restricted DMA pools for CoCo guests").

Because none of the remaining headers included in kernel/dma/swiotlb.c pull=
 in
linux/set_memory.h, architectures without CONFIG_ARCH_HAS_MEM_ENCRYPT lose =
the
static inline stub for set_memory_decrypted() from include/linux/set_memory=
.h,
and x86 with CONFIG_ARCH_HAS_MEM_ENCRYPT=3Dy loses its declaration from
arch/x86/include/asm/set_memory.h, resulting in an implicit function
declaration error during git bisect.

Should the removal of linux/set_memory.h be deferred to the next patch where
rmem_swiotlb_device_init() is converted to cc_make_shared()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D8

