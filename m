Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 363F560A2617
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ctrB0LRC
Received: by kanga.kvack.org (Postfix)
	id 0A5C06B05B6; Thu, 29 Oct 2026 09:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D756B05B7; Thu, 29 Oct 2026 09:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5B06B05B8; Thu, 29 Oct 2026 09:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4F416B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:25:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2446D120283
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:25:55 +0000 (UTC)
X-FDA: 85375736670.13.8B4F793
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F7841C0006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:25:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ctrB0LRC;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793280353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4Ote2oNGmkpBbwqGPlhb6Bmy2+vfC8nA+hvmMRa0W0=;
	b=uB3lB5Lve1+h5wX7pm4L0P6vWbC668A1XNv0WqL5rPMt1dKDhK+2JDlfq+LBAleTIJQRWu
	2s4juISrLpzlR1loxv9IyEPT601XGD6QFFcdihUxqcm6iP8hEF9Ui3UaJLGT+QmZfKIeNI
	tO6s01pVSX9nU/h/6oplIm0tmajU5YA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ctrB0LRC;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793280353;
	b=q40P04qPdjIZZG2npGaEeRsLkzz+Cbf8Py0OoqRgH8CJlC4u2jx89JBs0qm3bUg0vfMuoh
	vVdFfKmgXNmt+0XTWHCG2jK9vEI7CMnZHlys0CloyBk0ZC9DulOvcrweKQzzHllfqeVEek
	3ITQkWlduvpNEDnZlQArAuQVpaNHuj4=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c9cfd8b1bso2418246d6.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793280352; cv=none;
        d=google.com; s=arc-20260327;
        b=XqGsQzdO16z7QXhwUn6yXL+IWue6ZYE5DT1ErKmNLIvAvJ/kDXOHT6NMHI6fffPt9s
         ERaCCHbTyC/G11NNz6YpeusSYrhwePnmjL+5lsugfTHk+9eo50OSRGuaTqDRqqlewTVV
         e8z14Wk0WrDTm32wX0dRHaI9MKUX3MUJcQMQCf1h/0ODlDDgnb1Kwk/GxK9z1PmB4CIz
         AHVLCIY5NIcIJbWP7MdLPqWpA82oWxdf2foDiMQFRkngfnf0uzorTGw/UQOcycHqaJF3
         /p2ZE/7e92NfNg8yp1sztuAocQ5Utfo3Af1/H8iOrLxg2pJWoa+5bOv28b283gnzuuqz
         LizA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=B4Ote2oNGmkpBbwqGPlhb6Bmy2+vfC8nA+hvmMRa0W0=;
        fh=gFqvkjBe1e+GEbYMZpTdfB6QKjbhVJ7Az/kZsvy8bj0=;
        b=kDvj1Z2EktFOPzhjc0e0hjoshEw07kzeQukkBEY3NoWH+xaUgo4pzl8mFy9NPhLxTP
         cQohhIdrd6Cr6eDgoBt09PYfxHVAanPpGI9m5u3ACgl65hpa9cGoLlHts+el0pKSkkYi
         7RpcyH3DJbMD830p3gdXJ+hBxJmarruhm+oC7FKEHKHzEfy1lbDkGyX0H+rbR5zxQa71
         2yeOcmjDkKY2oAzj2K5kcBqyKTpkBAdAA8TvkQhOwrKQcwqJFDDtBmcIMFszAUQ0eVWj
         sbdcbPvEYbqyIFKySheL73LkZxHLdkxLkT7OutUx0lB8vMMBYqq16gMENXsQE3Asa0Iy
         TCtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793280352; x=1793885152; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B4Ote2oNGmkpBbwqGPlhb6Bmy2+vfC8nA+hvmMRa0W0=;
        b=ctrB0LRCbZHRT4/byZfMfJAgmsGfkfrc3rSPulLzx0+gokxiwC4AxpjR7QMdFZmBT1
         p5rc14bXfwKKILc3H8XefLjxDsAfi2bm5LaokuGu8ahnisr//54sumlKFJ5bQDPm60U5
         c6paa+2cx1QQL0qG7Xm2oxlF6mdKOSyp+1oBeqCMAW4t/kdSN/t3Qjp4dOWxvvmLL7BI
         BPg+rog/YKD9RXxmunLXjcf1T+aV/hlM2fAFRC6lGNUlFH3tVuFGAp6/2wC87/cp26pv
         dRvUfl8L+G72/epFq3Kk4N8PNgMZgS9c72VYJ60zoeUoT46WZYphdcXu+Nl3ElINru/n
         //kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793280352; x=1793885152;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B4Ote2oNGmkpBbwqGPlhb6Bmy2+vfC8nA+hvmMRa0W0=;
        b=c/UhaTz5MfX5QVFCg7VqP7oO37Mq+0D0z5HPswGhArySnKFuTxdK5NH7ZkWiZzX1Rk
         sbzXF9zM0PQwsPxUzf9foUVcDoMDHj5tYgEBQwTKXXukt8XDNua7E7QN+cc5wQjF+qWI
         6uYonvVi8zZEfgBGZFYU5YPHhRgrWse7w/il2n/tqSmPt2K5CwGB9DPwzmb4w74Xq0Lh
         RdeIjjyai0c0vUptUi2l5nXZfuYH7DREXnmzd9pSNx3CnqJM7TytWTVoefdj16fqIBzA
         scsyR2jDmglVGmzBgFnN1WkwYEyWg1r7uMfo7zcWAnjRDZ5GgpdGrNTbJi7qHJ39TyYZ
         pfmw==
X-Forwarded-Encrypted: i=1; AKwUvBxXIZv0jl1/Kq6rdQl3/8TMk9XZq14mjVOO4T3CfhmhG0l0K49klDVpU1nUsfQzBTLv0Ruq575ZIw==@kvack.org
X-Gm-Message-State: AFq9FYLrrwrLL2wkE8/ELqjxMWtDEbOldtK3k3GPdd9nsNRQCh3nIRIa
	3OC96q+anC5CW88toCGwEnytZB25xSp3f684zp/q0ytl8vxyBqI+vSTVr+4BK9OZ1fWyBvxSUzQ
	WzmW9cFXotLKJYCERWuiDyZn5CN0wn30oS+MNiFZx
X-Gm-Gg: AYBFou0qAcSaQZNmNJbCGrosUrZQmN4XAPV4HGwOLbt3CjeLpk1fpTeBDuSrZHM7aGb
	FoUzj3rQGMHQ5oKmjoaWGeW3joV9a2yzOnLvFLLHe8I10uXYLOSre8Vcto2OKgyiTqWUSP+UIXv
	3KCabvhLJNfN+CyIlusHDljLZghqcrD47kr7Wa9FnI2A0fFYjKEZcPQM4bzmL6Y2HUdaxhqv+hw
	AkpzLyKv9HfyfIdFk4Nsp7eFxwF0SC5ZvrU/HQwNGUeGVlyQL7bY2qp7doePlwXXHsyKC/GyEZF
	MJie52RQi+1INSiED4g4ZlfnvHz3Z5zlLzYecD4ZOJfCvvN4kVieFORJMCxs0SdxgMYLNF4Ai6H
	SyfI0/386LTRGl9nM4AOSdLLgClVZgmgJVH2ESTirPKiBhghQAwqH/5H3vxnIKXwJIHC96zCCD1
	qIGdMemwP81XA=
X-Received: by 2002:a05:6214:19ee:b0:912:488d:33ac with SMTP id
 6a1803df08f44-91c7cf7470emr79151836d6.17.1793280350607; Thu, 29 Oct 2026
 06:25:50 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 06:25:49 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261027154649.91571-2-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com> <20261027154649.91571-2-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 06:25:49 -0700
X-Gm-Features: AclHuK-Bz4CQfeSbgKQ2yKQJOYhFvS_qYgj0QmmyZ6llJw96csH-9wohWKdAPuU
Message-ID: <CAEvNRgGvxtgT=x3sLcasLZzCrtX+qEkHjPgs2yFRY0HRJvodag@mail.gmail.com>
Subject: Re: [RFC PATCH 01/14] KVM: guest_memfd: Clamp the order of PFN mode
 blocks to what KVM can map
To: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Kardashevskiy <aik@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Ashish Kalra <ashish.kalra@amd.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christian Brauner <brauner@kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Connor Williamson <connordw@amazon.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
	Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
	Gregory Price <gourry@gourry.net>, "H . Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, Jianxiong Gao <jxgao@google.com>, 
	Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
	John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Justin Stitt <justinstitt@google.com>, Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <shuah@kernel.org>, Steffen Eiden <seiden@linux.ibm.com>, 
	Steven Price <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3F7841C0006
X-Stat-Signature: 3qa4wmm1msotex9khjcb55zd5aejtup9
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793280353-431018
X-HE-Meta: U2FsdGVkX1/rOuw/6y/Ttc/bJpC3C4TaqluUKTDALVFLZG30ZTsTPM1jlwMAUdhAlYUGpoQuWyJMSX4Lwc4up3WOWFnstsNyak/4WexlhvIrC5tZ4/QaDreA05jF01hadYApxnvAg2Li1Lng/xPPNOv8HWeOCmgG+TTUNEYeUPzNGOLLtb1Tdb4vsCqqORgUUjS9e19kGC+jPjnimTVS7fFXW52WJpjpxPJM3FoAJWWfisq6yAkpSuXBB870SV1+deltzzMu+nfkcmd6lPmsjHY8jmhhD42+pB9ktthccf+mOH0bo9yL22AR3Ho+GRY0vfhJ1NFsUywooyw50MdguOAvTI/4LCUsLL/wK3U66qW4XVGu0qvqSespIQI06v91P38ZUSIOl+8CogsI/WeYYNIRHqDBRYRPLAuXB7Kxk2Y3NpKe9+P7Uzd51lHSr005Aj6marMbwrv2lP8gvFciznNdXf75suCTpdylKggk3z+hPgcTck0X6aT8DkuzdkuUlWGEoYbvuz/oI0fB+qTZKlIo86+iDRutN5NJtsY3p+bkvRqLVYU6eIjHF7TXMj52xpNzKogBYKV7lrph4YmB472hQS/Qo4WuO+aSeLNNK9nQbsFitucilWwY5ygQHqtCyDqpEelgy594goJKjkIqKEUURjd2hp4BmQBZlfoT9DFY0VsJtQj9za8UfTtZEZrJ6EyzcSihPy171AdbzwG90k5jg6TUAsLNFFSkqgIc4NILMWgn9yD+QPV6CTTnnINbbyC6jQjJFXTL/Hu1eddmWgROaqe8Eq14czqPGM2pevxn4PbbNhG4tRZsDipSb07SWBXqsxLsFAAHOSC3iVQqzSBzPpVCpeQ0pWSyxQz50DMMrSDC7INxnk5poqR0pXIItzrOpbHQtxWm6A9Y3fw6103OBKuoSjTuoYr9R1lv4hmEjzkT+KPY17xaVhlz7oo02PhnkgK+MKW6RaOD10u
 4qzzABAu
 5Zhs2ygyhcctTHl8w2DNvMDOMnAmQHw7buLErRA3fA6xANw+38m4iICtAKqRT95NZoUHF4ge41aAHnzxq+kTI03/9hJy3MzsW6DgzvHdokwwSS2+FHn4AUBIh7ydX0JKSe+K5Xm5j0rxC9Z8DTDMFIlZoETf6/uuyW29kvnPYegbzxQZ50c2js1DQYzIRHmM0rO+dS0xsOzgQ9X8r0cSjfUluiya6kBgCyCLvRI9W9lHSOWDjsu++4gcjckggTPtcAErm5SBwiJiKswmabe5HvHohjNFyoVyjjkrFJS3y9y+iwmbvz+X9SYInLDoxVfrs82h6jgaTWgaGfLhMVgviXXL8UKiytDynhXSt7dEqdAch35w5iqRr2VUmYcl2kfhUPCdziL7CqFEPiCXK2DHogzjEeFvl+gGP0Xt7iFEBO/ClX5SkvJuWSt9KCRiJerMHqi3z+prkYVVFalfjpqfzl8hZKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>
> KVM maps guest memory in 4K, 2M or 1G blocks, and uses guest_memfd's
> max_order to choose. A folio of order N is physically aligned and never
> mixes shared and private pages, so the order needs no check. A PFN mode
> provider's frames need not be aligned

I'll need to think about max_order > 0 more for PFNs. I put it out of my
mind because my frame of mind is that only order-0 folios are supported
today. Perhaps with PFNs it's actually a lot easier to support order >
0.

> and the provider does not know
> which pages are private, yet kvm_gmem_get_pfn() passes its order to KVM
> unchanged. KVM can then map a block over the wrong frames, or with one
> attribute over shared and private pages.
>

Yes, makes sense that private/shared contiguity needs to be taken into
account. I didn't consider this because order-0 is always safe to
map. Thank you!

>
> [...snip...]
>
> -static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
> +static void __kvm_gmem_invalidate_start(struct inode *inode,
> +					struct gmem_file *f, pgoff_t start,
>  					pgoff_t end,
>  					enum kvm_gfn_range_filter attr_filter)
>  {
> +	const gfn_t blk = kvm_gmem_is_pfn_mode(GMEM_I(inode)) ?
> +			  1UL << PUD_ORDER : 1;
>  	bool flush = false, found_memslot = false;
>  	struct kvm_memory_slot *slot;
>  	struct kvm *kvm = f->kvm;
> @@ -355,6 +360,16 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
>
>  		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
>
> +		/*
> +		 * In PFN mode, a fault may map a block of up to PUD_ORDER
> +		 * pages, sized before this invalidation (see
> +		 * kvm_gmem_pfn_map_order()): make faults anywhere in the
> +		 * blocks around the range retry.
> +		 */
> +		kvm_mmu_invalidate_range_add(kvm,
> +					     round_down(gfn_range.start, blk),
> +					     round_up(gfn_range.end, blk));
> +

Yes, we want to make the invalidation range larger, but not the range
being zapped. We can't over-zap for CoCo VMs.

Would it be better to refactor kvm_mmu_unmap_gfn_range() instead of
doing kvm_mmu_invalidate_range_add() twice?

>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  		kvm_arch_gmem_invalidate_range(kvm, &gfn_range);
>  #endif
> @@ -374,7 +389,7 @@ static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
>  	struct gmem_file *f;
>
>  	kvm_gmem_for_each_file(f, inode)
> -		__kvm_gmem_invalidate_start(f, start, end, filter);
> +		__kvm_gmem_invalidate_start(inode, f, start, end, filter);
>  }
>
>  static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
> @@ -670,7 +685,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * Zap all SPTEs pointed at by this file.  Do not free the backing
>  	 * memory, as its lifetime is associated with the inode, not the file.
>  	 */
> -	__kvm_gmem_invalidate_start(f, 0, -1ul,
> +	__kvm_gmem_invalidate_start(inode, f, 0, -1ul,
>  				    kvm_gmem_get_all_gfns_filter(inode));
>  	__kvm_gmem_invalidate_end(f, 0, -1ul);
>
> @@ -1535,6 +1550,44 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	return folio;
>  }
>
> +/*
> + * The order a PFN mode block can be mapped at: the provider's order, no
> + * larger than the alignment of @gfn and @pfn to @index allows, rounded down to
> + * a page-table size, and never over pages that are not all shared or all
> + * private, since KVM maps a block with a single attribute.  Called with the
> + * invalidate lock held; an invalidation of any page of the block makes the
> + * fault retry (see __kvm_gmem_invalidate_start()).
> + */
> +static int kvm_gmem_pfn_map_order(struct inode *inode, pgoff_t index,
> +				  gfn_t gfn, kvm_pfn_t pfn, int order)
> +{
> +	u64 misalign = (gfn ^ index) | (pfn ^ index);
> +	u64 attrs;
> +
> +	if (WARN_ON_ONCE(order < 0))
> +		return 0;
> +
> +	order = min(order, PUD_ORDER);
> +	if (misalign)
> +		order = min_t(int, order, __ffs64(misalign));
> +
> +	if (order >= PUD_ORDER)
> +		order = PUD_ORDER;
> +	else if (order >= PMD_ORDER)
> +		order = PMD_ORDER;
> +	else
> +		return 0;
> +
> +	attrs = kvm_gmem_get_attributes(inode,
> +					mtree_load(&GMEM_I(inode)->attributes, index));
> +	while (order &&
> +	       !kvm_gmem_range_has_attributes(inode,
> +					      ALIGN_DOWN(index, 1UL << order),
> +					      1UL << order, attrs))
> +		order = order == PUD_ORDER ? PMD_ORDER : 0;
> +	return order;
> +}
> +

I'll review this function more closely again. I think the mapping order
should fit into how KVM does it. After taking guest_memfd's input on
max_order, KVM then lets these parties possibly tune the max order down:

1. lpage_info contains information about highest order due to memslot
   alignment and alignment due to VM-level memory attributes
2. CoCo platform can impose a max order
3. Userspace mappings can impose a max order too.

So I think we should follow the same model:

+ The provider reports the max_order based on it's contiguity
  information, which is the actual contiguity of memory and
  read-only attributes
+ guest_memfd further reduces max_order due to shared/private contiguity
+ After handing it to KVM, KVM further reduces the max order based on
  the above.

I think mappings for all other page tables (userspace and IOMMU) should
also follow this approach.

I guess the kvm_gmem_fault_user_mapping() equivalent of this max_order
tuning is missing from this series. :) I think we should defer order > 0
to a later series though. I think read-only-ness should be part of the
first PFN mode series.

>
> [...snip...]
>

