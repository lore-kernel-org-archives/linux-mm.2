Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 452EDCA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0CE6B0095; Mon,  5 Oct 2026 06:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2924F6B0096; Mon,  5 Oct 2026 06:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1814C6B0098; Mon,  5 Oct 2026 06:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEE506B0095
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:48:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68BB11601EB
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:48:10 +0000 (UTC)
X-FDA: 85288247940.03.FEEC705
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9AC5620004
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:48:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XBax9bhC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of vdonnefort@google.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791197288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0E0kZNEEosSgGH99aMOAH+blyCZGVgX/b9FbaeaxoPo=;
	b=juWMM2vse8Xsdn0tMhzBMuwtoSZ+vV2sIVo72uwl/ez27NsUhTgnlVvTRvDTfMrFVpHMJN
	aheso2iGI//KJpoFbANRjXY/kdYyn+f4RTDQCak0X87oqw55MbIW58l9+0Cl4bTNqLoPXC
	evCnAteJV6IhsdjGxhC0vnGcovykrp8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XBax9bhC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of vdonnefort@google.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=vdonnefort@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791197288;
	b=zBAHf85U9aM6WJrBOvVND8sG6GdcwVKZvYkFGD80L9h/f/PzhG9H/1WDJjlnekiRBZZWo9
	39iYAmL8tNVAzMs9N03/XPbShKDn9fPyqE1rnMgnrgDVV/37wVYJtjSUZTijBdoCEKCkra
	lIOMk0Ub+oIIhZPGFkAibGHmj6AcIWc=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a169d33ef6so8983565e9.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791197287; x=1791802087; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0E0kZNEEosSgGH99aMOAH+blyCZGVgX/b9FbaeaxoPo=;
        b=XBax9bhCULhjYM3yPyIwdpCCqGkzy1k2PW324IlxKg5O8JWKOTxEYRjW+Y56yKpUwf
         ud6z0gioGeaj1JdDozqRrHDPs/AvnxzsKNf3hIdZ9Q1r14vw081LoJ0HEF/LV9ZzIXeT
         opelYnPLdD6bRrfVQww/uNNFxvgTYBGJVTR0r0KPp7hWG2aem10H6S8fu2Zsh30Ceirm
         KD3v4L4aPs3UqLzV2w8gxubH3eYnZYdostZCjrytXG5UoLlPKc2daPmQM+ZtcxPPE0VU
         EGhzKJ2LzA+/GYgVhWh5hvBZ3TMyyrLZy/t9kGLDv4nXGIeZfTRh4yXLzt2lws/OUaAy
         n+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791197287; x=1791802087;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0E0kZNEEosSgGH99aMOAH+blyCZGVgX/b9FbaeaxoPo=;
        b=WpbVaAmv54gMmTbbcQtTkR1MkdaEiYnQ7hvSXoMZ3YAGLjJDd+Qi2+CxhMmzKZPYP/
         2AYI/p/e0mLBU9MT+Qw+Ob0EDrP8BhU6ZJ0UzcALahgb3m1m0cHDtZ4l8iROXstlwCyH
         FEtTkl6ULkxnTLbOPMANUIBE7IRBIyoHguY0L2AYpb0R18QXdKOApYSs+gfEpU7UqID3
         3Kw0HNKCTLkSKJpTWhSq+EIlG3CdGx3pvGuLlQl0d7axVcmeqEQfCC1nNt0WkQ18JDoo
         gW0gyB2a/BlNT9FD5TdP6M//Z1bg/pK0fKmIOJHwKEFhn7WWnGXYO3XeXv+Zfe8oZ8Fd
         aAfQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCssF5d01a1pgpSNI4KGS5GTOUI/oNw7uk8drJly7jAszCT5CoIQ3K2tNneUj052P+nSOqRu3Jxg==@kvack.org
X-Gm-Message-State: AFuF++niU/5fN0q4dpf7yKVd3jXmtAF3NE1f9RI900umJMGhfYHs7pp0
	V49o4BMJT8ux6PE05nE3RXq5p316v5gowuvWmzG+Kx9NgT1+7Mtswqc+6lf3rqCX1Q==
X-Gm-Gg: AYBFou2tAkKqCwKyJvbzAbgu/Ll5RQzZw/vP+b89xFRnD4SQskP0f6A9gHGEkDfpDmu
	Eu3ZwkHlqu7kXe6u+E7J1mSCoFxzG9yvtHYcTNsMPKgFi/I6op0Vq7as0hXAcwv0e1egX9uy7aZ
	e4ePh/f/joIRBcFIJIRiFx0J3cCMoFTfjGBbZI+dXCzUlFNdR3i7p9NH8tOa8UYhbSFlH4Gc2iu
	PLbj1iyh9xjaZcSyn2tKT/8flYM1rxLYGOqwgk0SyYud8c/+L3bBgX3vXQnBZfmgOluUWI8FtFB
	9/i9u8zFjEQKft+QgbaLjv6HCBnRvEuormacvtatDlKjCsDpyOuDcAxCa/UN/bOIxNsEIEDyjOe
	R5FoLaRO3Mnl1M/AW2hsIcB8p4oiQ3avvR1ZwiSVqedwbMp5JW3lrWOmaLUsV8qKXKElkPCzSbe
	8Op0hWmJq4gcOjL1l21gwonHHYQWbCgUcoIxV+333TOL+FqZZ1qMzv4OaOLXYw+vlQpTBfjHhYE
	s5jb/FSgR0OCwRuFUrJ1qvRU2XxMB1m69Q210T/I2g=
X-Received: by 2002:a05:600c:a112:b0:4a1:7690:d878 with SMTP id 5b1f17b1804b1-4a17690d93emr7713595e9.17.1791197286488;
        Mon, 05 Oct 2026 03:48:06 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0e1afbc44sm329471285e9.4.2026.10.05.03.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 03:48:04 -0700 (PDT)
Date: Mon, 5 Oct 2026 11:48:00 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>, brendan.jackman@linux.dev,
	catalin.marinas@arm.com, rppt@kernel.org, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, jenswi@kernel.org, robh@kernel.org,
	mark.rutland@arm.com, ardb@kernel.org, thierry.reding@kernel.org,
	david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
Message-ID: <asOAYODGZa-7EIV1@google.com>
References: <20260921110050.3977591-1-vdonnefort@google.com>
 <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar5TPvANFUoosxGW@sumit-xelite>
X-Rspam-User: 
X-Stat-Signature: trxbron7z8cuq18rypr8sfeywu3w7ssq
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9AC5620004
X-HE-Tag: 1791197288-990593
X-HE-Meta: U2FsdGVkX1/GOzBIaAyID8KJjpdia5uIZ4nvdlicgu5Bi2Ki+dzsQOUhvqwpJWx+d4iEC1fUXNGH9611vpqbMAqZYsNLcnuX3o52gVkQZNbbcL3NUWf9agAIp0nPTEBwmquM3puxPm3wS6knwIV5+wQe2bFuUw0s+vOUi5anLkGwWZKRbOt56+7vCCM4Rk8SZ05YdwpCiMm4RmhP4IZyyLPdIG7Mulrqda9uukafgEdLLbxIn6rCq2Uu1tbLm31KUqJCBZ4AEVnywO5v+ZEwUUoKaoYinPWU26DZqHcKDh0QHYzXXsFGIS0uLBkCRyzzKuuzJCtPGTMo43OxPMVi2PkUlBsJwVpnkd9Pp+nmtrT6YSvPT9aTpTFj5GCF2f8rQyDiieW9VmQ/4TFKmQH7jPkJXA1vegLFKwFTqEeAXVBwXjjyUUdHYcLkyDzVVHktn58m3887CcDrvtRemIRSv6Dc2/w/sehAVjC7Bdyk2LQKp3NSzieT0HoPEZ4TxRc3Rpl+Y+g3SBlKBglsMN3AvFzdr5lZrF3eGpcuTXJ5zpJLh4RSUlehYVD0uTTECl3KebzJyxPR+JfDGbLWMnzyN5k0Ly6Aly/UXem/5clWpnff8Fb/rWp10MWS6HwI18nQEk0NzS8aTZF62aaWiAcmHhvcg8fwHmmrgp/r109+UVpOKVu3aKPfhJWn7tFnc1OrUS/3FRwATVhOf8ML5NKEAsrHi1G/o/HLVMFBO8E8D7jwWPpRz70jACOCOs3Vnl1tFaNl4NWuMM9woBuItSQxJozUKMILClYHu+tHq5aVA1qkEmwQDscmWWziP4hdiC6Iw62j0eoByeW9sJV9mK/Az8imY0VQeKfFWTty/VK+TYU9ogtjFSHf+l/CbTOy5zlKVHRRWGElgIUDaCXSS8TGH5JsbZJq9YIxJGl5FCjA7zbGXIA6hUjPPJB2SCdxb0AC/khplTpA8+OOcXxGZx2
 SxU4F2eE
 CtuWeksArfDqZ1BOjo4q9+JjJ8Gpe5Am0+nrONodX1g9USSBD1yw4aT4Yejz2raiIJ2yIN13PC5DYXO9itc5dCi0u9HMm68zuIM5aAY4T47GkrPu9fkks4eeOeLpEI6P+WSfBgVSIfjP8g3xz52+liW/N2oj7gEpx8CQ3b/SdUHLPUBDTHB0OBhcZpbn7aOjnJkOmMgVNgjhQ9CLyi/zZuo95nP28JjukXKiWSikyWSqnZkbkR7HuwnmqS4k8MVaYPkstv9ohEGaViqV9YyHi3HQVt8p3jZAjfTOk2nzWDRB0KRajl4RSNO2mGzeT4cwYKmKV+jN3GQW4wCZ9NQdsVDcW/8FDUw7rkC4QcsdMnqXOhBR/iZMq/VgCKX3mLjhfnp+G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
> On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
> > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
> > > Looks like you dropped me from your reply.
> > 
> > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
> > CC list to To: and drops you. I suspect the same thing happened to Thierry
> > when he replied here:
> > 
> > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
> > 
> > I can't figure out why that's happening :/
> > I manually tried to fix the To: and Cc: lines in this message.
> 
> Thanks.
> 
> > 
> > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
> > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
> > > > for arm64 because it relies on being able to unmap arbitrary parts of
> > > > the linear map, which isn't generally possible unless you force pte-level
> > > > mappings for everything, which is prohibitive for perf/power.
> > > 
> > > As per the cover letter it's about allocating pages that are not present
> > > in the direct map. This essentially fits the protected DMABufs use-case
> > > where we don't want any kernel mapping to exist at any time. Bufers
> > > allocated from protected DMABufs are only meant to be accessed by the
> > > TEE implementation or HW accelerators like in the secure media pipeline.
> > 
> > That sounds like it should probably build on top of this series, then.
> 
> The main problem I see with this series is it tries to move from the generic
> CMA allocator to a reserved FF-A CMA pool which again comes from the
> DT. We already support reserved pool allocations via "no-map" which are
> discovered dynamically from OP-TEE.

I can't think of a way around a DT declaration. We need to know what region is
PTE-level before the direct map is installed and of_reserved_mem is very handy
for that purpose. And as this PTE-level mapping is costly we certainly only want
to enable it for platforms that absolutely need it.

> 
> If we can rather support a generic CMA like allocator for arm64 which
> can support unmapped allocations then I am all for it. These platform
> specific reserved pools isn't a scalable solution.

What do you mean by generic CMA allocator here? An extension to
shared-dma-pool? Or having the CMA automatically doing the unmap/map on
cma_alloc() cma_release()?

Right now I have created an API for the unmapping/remapping part. It adds a
burden on the caller, but the alternative solution is introducing post-alloc
pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.

-- 
Vincent

> 
> > You could allocate the DMABufs from a CMA region that has no linear alias.
> 
> Allocation from generic CMA pool is already the case here:
> 
> tee_shm_alloc_dma_mem() ->
>   dma_alloc_pages()
> 
> Do you mean it's just fine to unmap buffers allocated from generic CMA
> region since it doesn't have any linear alias?
> 
> > 
> > > > Vincent's series tackles that by using a pool so that only that part of
> > > > memory requires the pte-level mappings in the linear map. That's the
> > > > whole point of it, so I don't think it makes sense to drop it in favour
> > > > of Brendan's approach (which doesn't work).
> > > >
> > > 
> > > For protected DMABufs, we even don't require any pte-level mappings in
> > > linear map. The whole idea of mapping and unmapping is just a bottleneck
> > > for performance sensitive secure media pipeline use-cases. That's why if
> > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
> > > be the best fit for this use-case.
> > 
> > The point is that you will require pte-level mappings for the linear map
> > if you want to unmap from it at runtime on arm64. If you don't, then you
> > can end up needing to split a block mapping (e.g. pmd-level) when you
> > decide to unmap only part of it and there isn't a safe way to do that on
> > arm64 without transiently unmapping the entire block, which can lead to
> > fatal translation faults during that window.
> 
> I agree with you here, what I am rather trying to find if on arm64 there
> is any possibilty to have a generic allocator for unmapped pages. That's
> the use-case here as well as what Brendan't patch-set was trying to address.
> 
> > 
> > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
> > > how Brendan is doing it for x86?
> > 
> > Because arm64 != x86? Presumably x86 doesn't have the strict
> > break-before-make requirements we have on arm64.
> > 
> 
> Sure, sounds like you are eluding to that the generic MM flag
> __GFP_UNMAPPED being proposed can't be supported on arm64, right?
> 
> -Sumit

