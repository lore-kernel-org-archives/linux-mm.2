Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB42CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28666B0088; Tue, 13 Oct 2026 05:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1A06B008A; Tue, 13 Oct 2026 05:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B6F6B009D; Tue, 13 Oct 2026 05:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 675FF6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:38:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCAAE120402
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:38:08 +0000 (UTC)
X-FDA: 85317101856.06.8B7B61A
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1013D40002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:38:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kjUFfoFG;
	spf=pass (imf04.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTxQfKp3tqhTG4A8e3eA1UWYq0qoe3PSOMQA99g87ls=;
	b=I7VYygeKy4GRm2FSZx0vo04YizfkQadB7ln9Ow6CizpiE3kP5Nq3rV5RJli1a/21by0CMA
	HuKwrIJK4mG2YKZm1pw6nHR5ozfh/WQhVqpsrKMGD5gfHOwatKWmJiBUybiDrb6M3+ytb5
	ipHYWu7d1WyI7fuBoYHTzPkWUUrd2i0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884287;
	b=BsnshoAjmaWndKkweLL3QKRK/HKPyOl1pA1VUVAmERkUSQZO2akebUmsXKqP7N7J7aYf8N
	mow/fonqpKREii4gxyGguksNFPIt2yI7TCAr4TA2ckkg34cNcrS4le3ugfh2xJnVE5cRSB
	u3lh54pSkJkR/xJ4JhhLCohzCyMF4Mw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kjUFfoFG;
	spf=pass (imf04.hostedemail.com: domain of vdonnefort@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so32878965e9.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791884285; x=1792489085; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oTxQfKp3tqhTG4A8e3eA1UWYq0qoe3PSOMQA99g87ls=;
        b=kjUFfoFGS/aGXuYxSCK4xQI3e+Q7tge+OwAXqd2kR79J7O/KVM6g1ADMZTjNXVk3dF
         c/vk/p7kNajqJh3XlIxmpDdbGxppGbEhkJHZ5daqW6FjnuWXa9fi4xUP0HdL7HtMN4/n
         lf/SHpPQ+ebknID+UuumneXsIYf/g5rOxlo8RoWlQsrmjitJWw+fp1FSdV5CeGI4+jgo
         QiMfWCRUEgGP+XSzWfGpS7JpFBezjbfLsQSxUmhEBi327WXCnlopzG8bOVYs2ciFh/ud
         7q/tcY8pQ1ibC7sDezvZc4gcxpx7ie05xJwoOTCwioz+ZMqQ1h7Z/JtTnGaW4kieloVO
         YEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791884285; x=1792489085;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oTxQfKp3tqhTG4A8e3eA1UWYq0qoe3PSOMQA99g87ls=;
        b=bd65FsZe06uxCUM43TtJMhMXZHiIfj634Vle82uqQTXW0dLym9WCoQtcU/bvk126WR
         PMI4PXiZMYrroFt8qGEIRMRF/oQh4l1dhrJBtmyrViakwsCWtRFSJrbtPU9uWB3xJ6wW
         DlGNbHVNwoRXNcvVjlaeR0meK4DpUmeDoDmODmvXU5eTHTmOwlm2YFPVoMyAWz4JOOXP
         xndSUiuJHG6VqspxjcXYQvn+lQTESe+wL9LxbI7tnF+LXx/Il5yhI1jg8wDrfSe9bYDe
         4W4ub+ko0CFgiIvFsgx0EQhLvqXpImRZCnX21S3+HoxdbD/a1tquNiKbNE9aKAHFi0Ng
         kKhg==
X-Forwarded-Encrypted: i=1; AKwUvBzYWiJyEI/jI+1dlU47P1YY96pJdl3LthtQnSYy4+jSlpJgNCbA80M1MOzS+GOMpJe5ASSV1XLs8g==@kvack.org
X-Gm-Message-State: AFq9FYIPEDx0QZcI6+DNvlG093g/k42K1k0R4xsu8Ga/XYX+Vm34zJMC
	Ej9pxbTtpy3Xoatc+1bF+j+d5MuuisUUYwr1iWEjPqQpy4pw8IiU9HFyW+yK4vo8KQ==
X-Gm-Gg: AYBFou3E+grQC3XC5i/3Dw+4Tmu3eclznl/1XTmo1KZhUwlTLlf/NVW9Qrh2aIvhQNO
	cV5Zq+vqrI4dgFAMc1emgp/K0GYxK9MsaITyFuwmKQ7W1yAkfxOxC7UhapUIZsl6e1CWSZXpgkr
	JaQjpowMqAHmAAAC/Uc/I2CO/kMbf30X1+StHVM8FcR8UTmh6HjU0/9eQvM3Q18+BWqKT7pFPXl
	K33Z4G5iiZhjUgirOnCxufgjZPhYGpST5Yt8LP0AsUBv9dzeCZObFeqdJQHE8z+8oc5SAvwjCFF
	xtyvoHBZAY+sBf013XV9He5XNCKHEjcs+yD9jTk50nzbcaREctqw/VFb4Rg+P94CoceFYz4Qu0H
	cCqbvdqJWbZNng9pCNnes5WBbl4KkHqgPyutLJNp9vJZj06ctCVDLWDBFyn5b9jyU0p0soMUf1K
	HQ2aniBzZUNDHydfDWtFxzMDLG5x2oJaDX5rzGM/CuZ5i0u8DZKQR+KsKhYMOAV2NOx/LAB6eYc
	WDO7pfSYfGl6GfRwKT3N1mkwiVMS2HgrFjzfTRVi78=
X-Received: by 2002:a05:600c:c049:b0:4a1:9a97:c88 with SMTP id 5b1f17b1804b1-4a19a971118mr97040485e9.5.1791884284684;
        Tue, 13 Oct 2026 02:38:04 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaabb8sm4646155f8f.15.2026.10.13.02.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 02:38:04 -0700 (PDT)
Date: Tue, 13 Oct 2026 10:37:59 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sumit Garg <sumit.garg@kernel.org>
Cc: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <as3798SFCfKFirag@google.com>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
 <aszdnInyJxLhSQRp@sumit-xelite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszdnInyJxLhSQRp@sumit-xelite>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1013D40002
X-Stat-Signature: 7srusuoww7ssjg847egrnwaxxqt6kzkc
X-HE-Tag: 1791884286-883254
X-HE-Meta: U2FsdGVkX1/c6VjkmYVUhb0i0Yq21phtHlhqYHVfPGVUQ7I4Nq9n/w4W9lKEiPgNuml5Uemb7TeqqPkZ5oZ66j4ocG1nF/wpu6AsnpqrX0YRDv8W1N/loTdpHKq/quYNEs9DpiHwO1lOf9/fVR+MBlvdQsLHGDGfvm1nQJasDHIg5BscC3b76Ivzu8pluIdCNUi1PLIOyVY3IHlO97FZwGJWZ4w1I34N3tk6K1DbJPgDG1IE9PVjpAqudzpKcL7KIrKHCbnSAczOZZSAbqU+/KJWIOZ3DAGhVxe9KmxEeffeEIocP7Ekjk+zXc3e2NNldOE719CuqJHbrp56ioabHLXMqE7ewvzMM9ctLj1WWfn2SkPq/1W8HK5wKQky6EIw1UwP7Rfdl22Dt3qJlYV4iRtPXO5ae+69n32K1MURw8zEiO15mZRuv5zDGs+MXIM5V8j6ViLiHDUqjVDsuaYJhPYuWiXyIqqQ7vWkrf6ZJmHIIsximGhVRuzzQhptGLwhu6OShuMBzC6+zqA0tZ09+qu4dNJ7gNIqjdqTWAZXvKqJElez46KEX4OwzO1R3rKsAWF33CgtSJgn8dQZ9yf2zqrtpsKBU+K5ZNwiRIDPo6G5wRbBVmMFfvaaocMlkBA1ao2bI8xRyE8HyAKq0aDFFmudHwlY8nDDkM8qeq2rFSjwX+QcjiTWARfCHNYWA/cg5YD6xJMWfswMyQUHfC5fa6Wc7nOUzuxfAyH92YwH/CLk9FW11SI/6ydUAGWJNlNsa+6l44DByyhbHPludp50tjldJetOf7A6vfmpoWBwS8w39oeMmsmOit58ECbUyXkXxqFvbas0vKa5tzD1VjUPQuBhI+3EYGbrmbvI8yTDcknF4fzCnRa/7/G5iko7oAldMOX3hjw0766gvGRpTVjBOOcOw86tblVMJxpMYHcMKyz3WhSCacFKNtA20BsZ9e4UUA/aZwItJfO35sy48v2
 glUUB6zJ
 Om0VHGPtfDxvKRBjjiIF+HDQqWY6Q+Ix2DynMthyyP8YEY2NAsthOORew4S9owxThZY5KHMhpxrULvJ+J9X/I+tb9MM2YWR/96wNd/dYC1hBlSh7NRd/OeerOTw8bZ2TJcYZxvjDcQhy740yFSNkd70q400VUJyVtwYITdtUSTFjeRnl+fSZmSIFWFX2rVUMS/8+0pmILYQCOXYT0RKa5SUm8lDQARMLvrgPh9PWssxRjBF2yuq71heIUEABbqpMZnOcdMHaPCW5uwF3QhjJ82X4Ftg+vp3o0Z0YFvHTaf/fmV1FuEl0kgFT2QZCre9vO2UIEglOf/s0AIGOEPPvuFTlCd+8F7zjfV48keIuwSDAYZAlsgiK4WBtKjrS9L3w77RW/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 06:46:12PM +0530, Sumit Garg wrote:
> On Mon, 05 Oct 2026 at 12:02:55 +0100, Vincent Donnefort wrote:
> > Sorry, not sure why Sumit's email was dropped...
> 
> The problem was with my mutt config, it should be fixed now.
> 
> > 
> > On Mon, Oct 05, 2026 at 11:48:00AM +0100, Vincent Donnefort wrote:
> > > On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
> > > > On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
> > > > > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
> > > > > > Looks like you dropped me from your reply.
> > > > >
> > > > > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
> > > > > CC list to To: and drops you. I suspect the same thing happened to Thierry
> > > > > when he replied here:
> > > > >
> > > > > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
> > > > >
> > > > > I can't figure out why that's happening :/
> > > > > I manually tried to fix the To: and Cc: lines in this message.
> > > >
> > > > Thanks.
> > > >
> > > > >
> > > > > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
> > > > > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
> > > > > > > for arm64 because it relies on being able to unmap arbitrary parts of
> > > > > > > the linear map, which isn't generally possible unless you force pte-level
> > > > > > > mappings for everything, which is prohibitive for perf/power.
> > > > > >
> > > > > > As per the cover letter it's about allocating pages that are not present
> > > > > > in the direct map. This essentially fits the protected DMABufs use-case
> > > > > > where we don't want any kernel mapping to exist at any time. Bufers
> > > > > > allocated from protected DMABufs are only meant to be accessed by the
> > > > > > TEE implementation or HW accelerators like in the secure media pipeline.
> > > > >
> > > > > That sounds like it should probably build on top of this series, then.
> > > >
> > > > The main problem I see with this series is it tries to move from the generic
> > > > CMA allocator to a reserved FF-A CMA pool which again comes from the
> > > > DT. We already support reserved pool allocations via "no-map" which are
> > > > discovered dynamically from OP-TEE.
> > > 
> > > I can't think of a way around a DT declaration. We need to know what region is
> > > PTE-level before the direct map is installed and of_reserved_mem is very handy
> > > for that purpose. And as this PTE-level mapping is costly we certainly only want
> > > to enable it for platforms that absolutely need it.
> > > 
> 
> I am rather thinking of a way to turn the default CMA allocator to be
> PTE-level mapped. Since the overall idea for this dynamic protected
> buffers was to reuse memory efficiently, otherwise the reserved buffer
> approach is already there to use as "no-map" via DT.

When the default CMA allocator is setup, it is already too late
(dma_contiguous_reserve() is called after map_mem()). I am not sure this can be
reordered easily due to the dependency on dma_limits_init().

So the only case it would work would be when a reserved memory has set
"linux,cma-default". 

-- 
Vincent

> 
> If we can have "cma_unmap" cmdline option alongside "cma" then it can
> turn the existing default CMA allocator to support unmapping buffers.
> Not requiring a DT change at all, although we can have the DT property
> for the default pool too if platforms want to opt for.
> 
> > > >
> > > > If we can rather support a generic CMA like allocator for arm64 which
> > > > can support unmapped allocations then I am all for it. These platform
> > > > specific reserved pools isn't a scalable solution.
> > > 
> > > What do you mean by generic CMA allocator here? An extension to
> > > shared-dma-pool? Or having the CMA automatically doing the unmap/map on
> > > cma_alloc() cma_release()?
> > > 
> > > Right now I have created an API for the unmapping/remapping part. It adds a
> > > burden on the caller, but the alternative solution is introducing post-alloc
> > > pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
> > > the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.
> > > 
> 
> I am not too worried about where the actual implementation lives but
> looks like CMA driver to be the better place. I think use-cases like
> guest_memfd proposed as a user for __GFP_UNMAPPED on arm64 will also be
> looking for this feature.
> 
> -Sumit
> 
> > > 
> > > >
> > > > > You could allocate the DMABufs from a CMA region that has no linear alias.
> > > >
> > > > Allocation from generic CMA pool is already the case here:
> > > >
> > > > tee_shm_alloc_dma_mem() ->
> > > >   dma_alloc_pages()
> > > >
> > > > Do you mean it's just fine to unmap buffers allocated from generic CMA
> > > > region since it doesn't have any linear alias?
> > > >
> > > > >
> > > > > > > Vincent's series tackles that by using a pool so that only that part of
> > > > > > > memory requires the pte-level mappings in the linear map. That's the
> > > > > > > whole point of it, so I don't think it makes sense to drop it in favour
> > > > > > > of Brendan's approach (which doesn't work).
> > > > > > >
> > > > > >
> > > > > > For protected DMABufs, we even don't require any pte-level mappings in
> > > > > > linear map. The whole idea of mapping and unmapping is just a bottleneck
> > > > > > for performance sensitive secure media pipeline use-cases. That's why if
> > > > > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
> > > > > > be the best fit for this use-case.
> > > > >
> > > > > The point is that you will require pte-level mappings for the linear map
> > > > > if you want to unmap from it at runtime on arm64. If you don't, then you
> > > > > can end up needing to split a block mapping (e.g. pmd-level) when you
> > > > > decide to unmap only part of it and there isn't a safe way to do that on
> > > > > arm64 without transiently unmapping the entire block, which can lead to
> > > > > fatal translation faults during that window.
> > > >
> > > > I agree with you here, what I am rather trying to find if on arm64 there
> > > > is any possibilty to have a generic allocator for unmapped pages. That's
> > > > the use-case here as well as what Brendan't patch-set was trying to address.
> > > >
> > > > >
> > > > > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
> > > > > > how Brendan is doing it for x86?
> > > > >
> > > > > Because arm64 != x86? Presumably x86 doesn't have the strict
> > > > > break-before-make requirements we have on arm64.
> > > > >
> > > >
> > > > Sure, sounds like you are eluding to that the generic MM flag
> > > > __GFP_UNMAPPED being proposed can't be supported on arm64, right?
> > > >
> > > > -Sumit
> > 
> > -- 
> > Vincent

