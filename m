Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7547CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965C96B008C; Mon,  5 Oct 2026 07:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916CE6B0092; Mon,  5 Oct 2026 07:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8065E6B0093; Mon,  5 Oct 2026 07:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4599C6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:03:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3D7E40219
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:03:05 +0000 (UTC)
X-FDA: 85288285530.29.5C6700D
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id 012A0140012
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:03:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AevPwHXa;
	spf=pass (imf23.hostedemail.com: domain of vdonnefort@google.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791198184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpVjroXVisHfj83brLQUbqEhnPiyl/yiKfc5znuepio=;
	b=Hi35qY2APqb98rb3mqZ/8R6kjLxsRh4TPpUjQA4vKzgwZ1z/w8Z59KU5dzAJaR4eSq4hKs
	dcYHrVl/KC4DUvrxSSRy213TnK/zp+52i8yIv4NJ069qwjV1eZcqb0a0ce9hstCeYzchvB
	6Yqmp39QS4/8KgSml0Rf8WwDHNf09hM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791198184;
	b=mH9c/4yIal0gjBUFg0ByAR0iG+dSM8T1D1CzgCRWsGd8tjf4o0FLVwcUPvLV5VlqDCMiVJ
	72xT1J4ChSbkZeE8gwZ9z7YbZcfGBBD+kZtMbizUvJ2WDlGA2Fw3qZx8qelgGkIr5xy1UJ
	IvEtXlVFE5KpRt2/cZ3WASCf34uPpQs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AevPwHXa;
	spf=pass (imf23.hostedemail.com: domain of vdonnefort@google.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af9f88c95so544431f8f.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 04:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791198182; x=1791802982; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wpVjroXVisHfj83brLQUbqEhnPiyl/yiKfc5znuepio=;
        b=AevPwHXajshSx/hV90GxsMTcAXlegkM6iioLGNyRk4Y1YPsYyLQoTq9FWQiLhHJ27/
         iCCxwUlV89BjqWwQ3hiCaXq3Obmlt2KTwhS9GLx1eKf6cIvO4xD+gOu2csA3E2In2WAt
         jmkEv1+mQPP8FasMdBlbadZNBkewutN+C1vYDQGBU2Rhh1uW6IK15rByT/+yUHbhtg9i
         AXIuLJgNFi3KZFJ9x4FPOquTIevWJniEc/ZmVZB2G+jYizVdW89cxGv7pO8ClnNmRCYY
         hPVeobw9PPuH1MSRlAV+8o48dusr7PVtcg4FyvlYUNsPvOp0hEkGTHNNVjLLu1qDfNA7
         uXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791198182; x=1791802982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wpVjroXVisHfj83brLQUbqEhnPiyl/yiKfc5znuepio=;
        b=ihw/74lCc1ZoXcGHjBXLPQ4ZVzYwY1XSekNAvAB8mu5gDC556ZlRM+Y8dNHq25wKKi
         aX4cHla8IvwVFgOmfCCJtmbU/CQAaztQ+VS9ghKvVLSO1C1jOTXHdzb1j4KOFIXAO/Lo
         ++7SZlWmt4+gDXDrw/DGy1Thho3WBxj+k9++uv6SCDQ3tHh7k1jg1Zr+A2CeDCuayyeA
         9m/D3B9L1C9szLa2Qefqu8dlfWuZc0HBi11hMHaytj6oi2UE43OhfEonrryR+jZVyxDa
         lx1Fqi3JwAB9nB0wZdHRN8aOb+RSXIeqUWJGJbbpPtB4kS7bv2G0jSXlvsRHOmKa79sg
         jiIA==
X-Forwarded-Encrypted: i=1; AKwUvByVZJdG6ymqHf5P41Jm8MOBRolkSrKpSBTz4zO8ioGLJF0FmZGRZ+xiFZBDrQ/O74vJ6OP5rTJE8Q==@kvack.org
X-Gm-Message-State: AFq9FYIuM2bnfj324CE3N4KzdKqwc08r3fGxAK+64ZkI+wsjAAc0Ahjv
	uZjxDW/TxNfJXYtnlGx+vHOMy4jKB/HXr8DIiJxyfiv3iTgrv1myJX4DqIN5+CLTjg==
X-Gm-Gg: AYBFou1rHMBTwRzC23FbYAgzkl5zaJ/jTSwutaTlMgB8IUart3aVaarn5FxSyI21Ii2
	4hkrxrWe594jnuxLBe2zixkt99KQ68BsL3nKDh/lfmAZn7LzvfBPeiuGrJM06LOv0Hmiodl2U7i
	upllVZgAezlQpBC6h0fo6Iq2TG9vx0jHuB9/+35pjz9EnpyjPP2ljeG74FYS0US74q4M2Qxo6Jo
	h7XPVgFU4jGXkbu1LIvX/p+56TeHICqf3obErDkbJiRQMiqx/CNY+6+ZtKAxC1NMwZEpvqV62Qv
	YHNqpBuCUOdkhjcRJjRHyl2t69kCLHcV9r/YBPM7NemYQw2PuI2a/05lnSi2MPqUFcKVw6dywl9
	kz34b/JpD9Gr8cg4PC409yXFKOfq3GeSTtHX1uSiMRrWTvyza2u7VWUlHWxbt4PyKfymz4L6iAK
	aWZbmv2AYKqJO5dok6+1GQ5GIWK+PJXcaCCfH8VlSR/0E/ykYctAxL5n98zVvhq8+rHKNNQYfNP
	VkolBwM+fBFomiqY/GtFLY05n1x1rjEHo3NTWVJ0AY=
X-Received: by 2002:a05:6000:2906:b0:487:13a9:80d with SMTP id ffacd0b85a97d-48b12733c50mr18086704f8f.10.1791198180653;
        Mon, 05 Oct 2026 04:03:00 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6227fa65sm2880630f8f.16.2026.10.05.04.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 04:02:58 -0700 (PDT)
Date: Mon, 5 Oct 2026 12:02:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sumit.garg@kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <asOD31rTX6dNfD1o@google.com>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asOAYODGZa-7EIV1@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 012A0140012
X-Stat-Signature: a4oydbb63qqhuqoypcpfiwsjcyp9cqeg
X-HE-Tag: 1791198183-920883
X-HE-Meta: U2FsdGVkX1+wZVfIWhmZ7y6o9FK/amI6z/hnshzYgAGPNNh9yMmBTY658CBFKHiEooJCe92kMf4mvnx9dAIK89Ql3Bnv05AW95DbTl+4BXwHBBs4U2NUGZyNcxpt0RbyIgb8HNt9SNqh0qSh1ws4r5ICIj4fbgvV4VxkTPHG+na2HFkh5aJcrA8xX9n398eOq244JX+o4TxQhbggQaXZG8Q9QwIYXhdAXnu8b+SxE+lAVYPzCizULhmkCGgLyawbx0iGDIXj18JdkqMqen127iDB47n7f//3x5kicZIrnazMF8oa7366D1zKcnDEd56Sk1ibtb2PumRRL+EOzHleu1yH3zivGx8FM34rKa0mfrTtqG5Nwo5Lodl2YWyxYPeEh0429WT4E2E/Xk/22gpd5FUM9+vsfttMDoPDn7dtuoh+3JdwzVq4zBkozq0tdsi8WDLrZStcU/vQKMXkihtTwFfc3N0KX1L6PpgSVloin8MsNnvTIJYYduOlao06kscR2xnDpx75tpJ+DPcDxhGZPTZ7RXX4a8kcied4f/7M1BDQMG4/ahTTcATSJsOCchuesendG61AGubtLEke1+IueAP1cJ0udc9t64SdUU47dTjQZ4LWh6xOr17GBUGheFwNXxe8J94BoKsvolN/8qSWYK61d6mp45lkJ38FqMQSir93eDVoCaQA276rUVicX4C5WHHgOGUWFJhXw1DtzgFz+YnIgnUNmiKtVxrTWQ59oNzH+x8XMP3RGfMa5EAyNYP5f6ySfdJ7Gkva80pT2ctVtiJ8SV5sK7CdRua/OlQgPaMCdKuwGsViHmqwWqyJuGX9g9lBMGqK1+UEUlyKeTadNu1cCYw6wYDSUc7GRYEZMMEWWsit4LjJHbCQ3t4ayR/SJRS85eHCI726UwP4tzKHHkCyEULjHootW6VPzJTuazPLFZ1jMtk4I+aencx7F5D65E+2J3D3SU9iqv9/Euc
 8c+kwp1x
 tie++v1AaLFtbLetC796E3rL/edcmnRQGE3qXfXAYv2RJN1tPZ0ZfZ37hDgx43oztdeSJ4maxVqwj4dIzX3CFL2lgKTn9QusmnnfUuzTBpSMeDAeCRF5jqwRGwn0wwOhfQ+0lXTotK9x+QFpV0baHXGvYsAabsvsUa17qYC9GyDHbRIeHAngl/CPl5XPrnCkJuOIH9TXK/t9Z3RBar+HOpu70UTt011dIO0RZa3znquLLtyzkV2XSiFLst9VnXvLPn7sQoZDyJQF5Q7jmY8lxReFTN+xD2RU/NL3LJBfKCuBusmM4V2Xy2u+wcl8ca1+/6aB3qQporfLj3b9v+D2t2C5yRdF8LT+Kyt2FQV/SKmVu4Nnm3MIK4XcjSPvLvU9lMM7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry, not sure why Sumit's email was dropped...

On Mon, Oct 05, 2026 at 11:48:00AM +0100, Vincent Donnefort wrote:
> On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
> > On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
> > > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
> > > > Looks like you dropped me from your reply.
> > > 
> > > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
> > > CC list to To: and drops you. I suspect the same thing happened to Thierry
> > > when he replied here:
> > > 
> > > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
> > > 
> > > I can't figure out why that's happening :/
> > > I manually tried to fix the To: and Cc: lines in this message.
> > 
> > Thanks.
> > 
> > > 
> > > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
> > > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
> > > > > for arm64 because it relies on being able to unmap arbitrary parts of
> > > > > the linear map, which isn't generally possible unless you force pte-level
> > > > > mappings for everything, which is prohibitive for perf/power.
> > > > 
> > > > As per the cover letter it's about allocating pages that are not present
> > > > in the direct map. This essentially fits the protected DMABufs use-case
> > > > where we don't want any kernel mapping to exist at any time. Bufers
> > > > allocated from protected DMABufs are only meant to be accessed by the
> > > > TEE implementation or HW accelerators like in the secure media pipeline.
> > > 
> > > That sounds like it should probably build on top of this series, then.
> > 
> > The main problem I see with this series is it tries to move from the generic
> > CMA allocator to a reserved FF-A CMA pool which again comes from the
> > DT. We already support reserved pool allocations via "no-map" which are
> > discovered dynamically from OP-TEE.
> 
> I can't think of a way around a DT declaration. We need to know what region is
> PTE-level before the direct map is installed and of_reserved_mem is very handy
> for that purpose. And as this PTE-level mapping is costly we certainly only want
> to enable it for platforms that absolutely need it.
> 
> > 
> > If we can rather support a generic CMA like allocator for arm64 which
> > can support unmapped allocations then I am all for it. These platform
> > specific reserved pools isn't a scalable solution.
> 
> What do you mean by generic CMA allocator here? An extension to
> shared-dma-pool? Or having the CMA automatically doing the unmap/map on
> cma_alloc() cma_release()?
> 
> Right now I have created an API for the unmapping/remapping part. It adds a
> burden on the caller, but the alternative solution is introducing post-alloc
> pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
> the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.
> 
> -- 
> Vincent
> 
> > 
> > > You could allocate the DMABufs from a CMA region that has no linear alias.
> > 
> > Allocation from generic CMA pool is already the case here:
> > 
> > tee_shm_alloc_dma_mem() ->
> >   dma_alloc_pages()
> > 
> > Do you mean it's just fine to unmap buffers allocated from generic CMA
> > region since it doesn't have any linear alias?
> > 
> > > 
> > > > > Vincent's series tackles that by using a pool so that only that part of
> > > > > memory requires the pte-level mappings in the linear map. That's the
> > > > > whole point of it, so I don't think it makes sense to drop it in favour
> > > > > of Brendan's approach (which doesn't work).
> > > > >
> > > > 
> > > > For protected DMABufs, we even don't require any pte-level mappings in
> > > > linear map. The whole idea of mapping and unmapping is just a bottleneck
> > > > for performance sensitive secure media pipeline use-cases. That's why if
> > > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
> > > > be the best fit for this use-case.
> > > 
> > > The point is that you will require pte-level mappings for the linear map
> > > if you want to unmap from it at runtime on arm64. If you don't, then you
> > > can end up needing to split a block mapping (e.g. pmd-level) when you
> > > decide to unmap only part of it and there isn't a safe way to do that on
> > > arm64 without transiently unmapping the entire block, which can lead to
> > > fatal translation faults during that window.
> > 
> > I agree with you here, what I am rather trying to find if on arm64 there
> > is any possibilty to have a generic allocator for unmapped pages. That's
> > the use-case here as well as what Brendan't patch-set was trying to address.
> > 
> > > 
> > > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
> > > > how Brendan is doing it for x86?
> > > 
> > > Because arm64 != x86? Presumably x86 doesn't have the strict
> > > break-before-make requirements we have on arm64.
> > > 
> > 
> > Sure, sounds like you are eluding to that the generic MM flag
> > __GFP_UNMAPPED being proposed can't be supported on arm64, right?
> > 
> > -Sumit

-- 
Vincent

