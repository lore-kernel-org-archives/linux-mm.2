Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41D8606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B9WafEDn
Received: by kanga.kvack.org (Postfix)
	id 0AEF66B05B0; Wed, 28 Oct 2026 10:50:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087216B05B4; Wed, 28 Oct 2026 10:50:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEAE6B05B6; Wed, 28 Oct 2026 10:50:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C47426B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:50:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13BDA80109
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:45 +0000 (UTC)
X-FDA: 85372321650.24.9DDA9AA
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42FC2A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:50:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=B9WafEDn;
	spf=pass (imf15.hostedemail.com: domain of vdonnefort@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HF1altOhSOliHgMv/AZ/rbBGnqwe/0k0dVHlSjsTcys=;
	b=n4Wkn+P+2jipUmXBnBOuuHyNF9WCJoF/5fAMbmapaPZ5G8TC4JYj6Mx6SR8ZxDWysIQjnH
	JK23ryO/WmA7wPwSNeB2Vi6kCzJrbrn1/7DUTKiEjtNc4VHf2POYYb8PeE4uzNPIC+Yl5Z
	gyvkA5kp4Qrsue9mmBQhN1cnxlkzeiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199043;
	b=8WpqmKOoICUJITB8NddbCBf9YEVhQHYCCqBVbeuEY8ZxkmVdyGsnv2wDS8UP+bZsL4T9s1
	zdHfFL9RXyNkIEvXH+du6oRWMJUL10s8+yb+ErHZW+7y1Z0ojIrq6SAskwR+gWnFReHJFw
	UCFt6RhLF3S4wKI38coEPGBhQErz2PE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=B9WafEDn;
	spf=pass (imf15.hostedemail.com: domain of vdonnefort@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c46bd7a7345so192836166b.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793199042; x=1793803842; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HF1altOhSOliHgMv/AZ/rbBGnqwe/0k0dVHlSjsTcys=;
        b=B9WafEDnMZS1gFTQ6HfeRuTdqaE3vgPlF5T9YFSSUNIrmYjfvrjtmnQZ1ELo3h8zqW
         hG85iA88iT3pbJzJGbCUU4o+Lnzzr8L5STeQb+qiy4x7+ImrfTbesGsBBceSpn7vT2s9
         AkOoJBz6RKLfmbftOVd2Pz8AyZN1qm9QnQMeo7RuXcK2wrDVhW+xEBL/Lm8zk/25csgQ
         RoGU5lIxRkh99/kxM1e3n89x2Qi0FtVJjLfUIl5UKKRX/obpbyUmn1Og++k8vCfmixVA
         9l7ImsFNcMKVKHwtCsbjMo/VpxvFiQ4F9/BTgmckiavLyuaGGn0C8eAyfPPKqwSzXVxE
         UQsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793199042; x=1793803842;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HF1altOhSOliHgMv/AZ/rbBGnqwe/0k0dVHlSjsTcys=;
        b=WIQQ++S9zME7OzAKOt9zOLg3E5ZM0Yo0tuWFPx2tPOp+fRSLCJOQ8NsFFzuJlslj5r
         fe9oFkN83NX/8zvsl2vhPg3NeeLQgzP3f3X9U6V8SmKu/ejKVxB6LpRZcWM3dSY5VKS3
         Xiek3SBpSnmoIyvaAqydA1iRNcZFlci99JAQwbyeTM3WVfnhLtiExTppkQVJAUWADXG7
         has1gUBm3uX0xQCrKy4Mdney4x0Wre3laDBPZHnWQr9ft5PszoNp2VJgf6C6ypqTcIyA
         EiWlrUlW5DcEKZrzksVZgduiAxgk1P+/qAEN1bL1iGcEzLm/jLh44Ao6nvaggzUq4ENQ
         RD1g==
X-Forwarded-Encrypted: i=1; AKwUvBzA+ST/OiJ8SBEV1GMeXt0E+HB2M0K9QBTtNlMBf8iQy7JgQIhWUm16PAYyorJSr4ilFIlZzDuGhA==@kvack.org
X-Gm-Message-State: AFq9FYKMr1/zqrkNUh7nbwsVQzPxx94tgaBAGb+eZHyo446JQHpACvhk
	NrC/RNBw/e5a51mm505Z8DC0Tg39GsD+B1a19FZAHUSBmG/PwlUeMFusOKF77Xc0oA==
X-Gm-Gg: AYBFou2o0eQG/ssWGOD9GUSB7ZhFmjH+jvNEpTatzYK+MD+3rA22DOEjVCpt/ofV/u0
	2dnyjnWvpniR8+LgHoi3IgDalAsU1aIe41sdvQzhw3j32SvYu36sOjWK/chehIIWk7AxzS5ufy6
	VWeJX2YmoYIdHBTThfamWM8c8bdM7Omc4xfuLFaXxfSlmugb4efVM7g6PiJCztL7z30ZL38DVjq
	7eqkXsvGEqwbzqny3v5YjRY0A9HNTUfvz3ohSPm8ye1Un4pdgrt1oZO+1u6QG1gGXEl/hCCLAsn
	MJG53wD+F29VXbOOcqBVi+7eSVeBun9sKSCkq4jDbtEZvvxNe3WA1ccuKLmpTR0DBj/Un7gsqLh
	SowQMpFbM3rCg/1w8ghSZVPnF0Gz1bJGLSvOCVn1sVZpppMiCqappgUolDFO2HnfR6vZBScbpop
	JyQTVlnpbT4jiwG1yunaTAVLlvvUHZ8Y9hQuKKAaJ02Ebl05BPRDXtdGktJX2czA9XiyY+5D9pU
	i8lAI7+1XwlkFjeJYPbdmjEwUb5d9Y/BDOBs/imEHkOGIWtHWV3aZOVc18KkSmN70KmA96VT78+
	yi3GGoo+b7++6sxuFkDNuIu8QDS2V1uq1r5UOEc4lSPkXdypFDLVq04MOZGBSLVKmjIiBmU5fe1
	e+MlgX4HZL1E=
X-Received: by 2002:a17:906:99c9:b0:c29:4b57:503e with SMTP id a640c23a62f3a-c49c620c08emr153260566b.1.1793199040959;
        Wed, 28 Oct 2026 07:50:40 -0700 (PDT)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd35004asm607338466b.4.2026.10.28.07.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 07:50:40 -0700 (PDT)
Date: Wed, 28 Oct 2026 14:50:36 +0000
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
Message-ID: <auILvMVSXk9pZh6M@google.com>
References: <arIYtjmSKCs14SqO@sumit-xelite>
 <arKW_91EeKA-w96m@willie-the-truck>
 <are21BjeS1O3RYE3@sumit-xelite>
 <aruh86rd5FMv2i9G@willie-the-truck>
 <ar5TPvANFUoosxGW@sumit-xelite>
 <asOAYODGZa-7EIV1@google.com>
 <asOD31rTX6dNfD1o@google.com>
 <aszdnInyJxLhSQRp@sumit-xelite>
 <as3798SFCfKFirag@google.com>
 <as4ATqhp0bPI03PA@sumit-xelite>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as4ATqhp0bPI03PA@sumit-xelite>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42FC2A0002
X-Stat-Signature: 15rbkscknmhjqcqbwyqouo7m5hooi868
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793199043-531422
X-HE-Meta: U2FsdGVkX1/TxYT2NZb+eE0iYQTARb2RQsJAFjjt4nWgcOePSMTBt7g9ZKoEKWC3oSOuMc0nYxC+yYxIQpBi2uurpGTIlhoQEOH6WTANK9HEqef83hAm+pftCgEEg9oYWb2lK2AgFAQOJqwaKrvrJ5JvBmfdLks+IPLyOmIK6pJBAUyP2XRx5IwQ8TSgLcGF9pe+M7difkVnOqqlImDDBBPvZIoh9E9LZA+v3AHdCzRGdz4iI8vg+afC/puzEKEkkWiK4sj6XiBnRHjPzNBcxOV98N+WMA1iBpUXgd2WU3NqTaGpIPCQPRoIRMb5VaZhdSRBLrA4fsg5eXt3bTBA/B7OS5TZsFI9lLINhF8/5ewTTpxpBPD5sc1dUBfZqZEP8uUN6kYmZ1Pc01jUHzwLvThr5ruQt40Poivmucw7LncsTUnTmn0v+crezPmhHH+AeqeiTYQotXUwJxxnD4l6Rzmp+/+DNV9godqou66Ukz56E+HOaLIWx1kxsDKFF+dzapupsQu+gKRoySAnTkMqRCv+ek/gzSXF58k60YGPTX/+hvyZSYX7H8uObp67M8XPmG2mHsh1GmJUVnEJf+WIuzAsPZ6I42RnxKHY6Qqbl6NIxfOirIjYPFProsMu21520j8tLBVhPdHasiFzALD7kg7o1gT7GbF0kELG5eCwYViWCJgKiDAIIu7Y5VtoDKiKn6NBXMkPP3ENMRwwERZ2ZVVCfATJBb/fSzj5yyTrMpkVls+MQRHPbZ8e6dQt4r0NUfPZOSJRdE1+vA+J/UIHiWvJ92PnYESSXwKqqsLum50m2PUkNo5Ghblwp9VjoR7ZdEQGsn3lq2XMM2JKu1fBVLIJ62M1gfCUY9jmjmlX/SW+HAAeE0Iw0+PiR4JiON4+nXgALbBBzbhrzeBhi0D95fwTiUtMvHILOID5GiT54Vm4KvZEoVJb+LtGFneM+J9q0spAn/MVkZTV22QrzyY
 4bvD3G4I
 3NabMjZK+kWrI1o7G1rREbEDYZIVujSBbWLkEAFKoeaWCjYZIhNaDrUCibCIzQoLJs1vUm/KgLgeJRozsLJMRcIcUXcqOEiMdtVsoGdGQCpVa11SwMvua6pkUP3UJTv9H4dyHAzXjpcrdCC2lOi8Py0ek6GTydwSfCpCAzB+lMo0dq3+Ufcgplky3EWFaZsNSNsa8HP6sXCPDl97pBwt4n95grMvfl2rCWHvD5jRS8+Un0LgWv33XpOThL0v48YVka1L5XfxRqploDQwcubd2B9vvW/cZ/JPyDy+zG+qdQn5APIdZ1CW1TYiEoVKrIFyLVuMAUdR04PZD2Mdi1IJc1Fw8TX2ySb0md0qcowRs+9uOCncP82TrHtN/RqKTUq6tZV9m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 03:26:30PM +0530, Sumit Garg wrote:
> On Tue, 13 Oct 2026 at 10:37:59 +0100, Vincent Donnefort wrote:
> > On Mon, Oct 12, 2026 at 06:46:12PM +0530, Sumit Garg wrote:
> > > On Mon, 05 Oct 2026 at 12:02:55 +0100, Vincent Donnefort wrote:
> > > > Sorry, not sure why Sumit's email was dropped...
> > > 
> > > The problem was with my mutt config, it should be fixed now.
> > > 
> > > >
> > > > On Mon, Oct 05, 2026 at 11:48:00AM +0100, Vincent Donnefort wrote:
> > > > > On Thu, Oct 01, 2026 at 06:04:06PM +0530, Sumit Garg wrote:
> > > > > > On Tue, 29 Sep 2026 at 12:33:07 +0100, Will Deacon wrote:
> > > > > > > On Sat, Sep 26, 2026 at 05:43:08PM +0530, Sumit Garg wrote:
> > > > > > > > Looks like you dropped me from your reply.
> > > > > > >
> > > > > > > Huh, that's weird. If I hit reply-all ('g') in mutt, it moves the entire
> > > > > > > CC list to To: and drops you. I suspect the same thing happened to Thierry
> > > > > > > when he replied here:
> > > > > > >
> > > > > > > https://lore.kernel.org/all/arJcN60nagFKXj2Q@orome/
> > > > > > >
> > > > > > > I can't figure out why that's happening :/
> > > > > > > I manually tried to fix the To: and Cc: lines in this message.
> > > > > >
> > > > > > Thanks.
> > > > > >
> > > > > > >
> > > > > > > > On Tue, 22 Sep 2026 at 15:55:59 +0100, Will Deacon wrote:
> > > > > > > > > I spoke to Brendan at LPC (?) last year but this doesn't really work
> > > > > > > > > for arm64 because it relies on being able to unmap arbitrary parts of
> > > > > > > > > the linear map, which isn't generally possible unless you force pte-level
> > > > > > > > > mappings for everything, which is prohibitive for perf/power.
> > > > > > > >
> > > > > > > > As per the cover letter it's about allocating pages that are not present
> > > > > > > > in the direct map. This essentially fits the protected DMABufs use-case
> > > > > > > > where we don't want any kernel mapping to exist at any time. Bufers
> > > > > > > > allocated from protected DMABufs are only meant to be accessed by the
> > > > > > > > TEE implementation or HW accelerators like in the secure media pipeline.
> > > > > > >
> > > > > > > That sounds like it should probably build on top of this series, then.
> > > > > >
> > > > > > The main problem I see with this series is it tries to move from the generic
> > > > > > CMA allocator to a reserved FF-A CMA pool which again comes from the
> > > > > > DT. We already support reserved pool allocations via "no-map" which are
> > > > > > discovered dynamically from OP-TEE.
> > > > >
> > > > > I can't think of a way around a DT declaration. We need to know what region is
> > > > > PTE-level before the direct map is installed and of_reserved_mem is very handy
> > > > > for that purpose. And as this PTE-level mapping is costly we certainly only want
> > > > > to enable it for platforms that absolutely need it.
> > > > >
> > > 
> > > I am rather thinking of a way to turn the default CMA allocator to be
> > > PTE-level mapped. Since the overall idea for this dynamic protected
> > > buffers was to reuse memory efficiently, otherwise the reserved buffer
> > > approach is already there to use as "no-map" via DT.
> > 
> > When the default CMA allocator is setup, it is already too late
> > (dma_contiguous_reserve() is called after map_mem()). I am not sure this can be
> > reordered easily due to the dependency on dma_limits_init().
> 
> Yeah I saw that constraint too, let's leave it for future extension
> then although having this reordering dependency fixed will be ideal.
> 
> > 
> > So the only case it would work would be when a reserved memory has set
> > "linux,cma-default".
> > 
> 
> Let's rather just turn DT based default CMA pool to support PTE-level
> mapping and keep it configurable via Kconfig or cmdline or DT.

If we need a DT declaration anyway, a Kconfig and a cmdline option aren't really
necessary.

Also, Rob wasn't very keen on having a DT option for the reserved memory and
suggested to have a compatible string instead [1]. So perhaps we could have a
a separate driver that handles the unmapping.

	linux,cma {
		compatible = "shared-dma-pool", "unmap-on-alloc";
		reusable;
		linux,cma-default;
		...
 	}

That "unmap-on-alloc" driver sets the memblock flags and register some cma hooks
(to be defined) for cma_alloc/cma_free where it unmaps/re-maps into the linear
map.

The nice property is optee won't need to be modified anymore. The downside is
the entire pool is now mapped at PTE-level.

[1] http://lore.kernel.org/all/20260902172436.GB1440252-robh@kernel.org/

-- 
Vincent

> 
> -Sumit
> 
> > > 
> > > If we can have "cma_unmap" cmdline option alongside "cma" then it can
> > > turn the existing default CMA allocator to support unmapping buffers.
> > > Not requiring a DT change at all, although we can have the DT property
> > > for the default pool too if platforms want to opt for.
> > > 
> > > > > >
> > > > > > If we can rather support a generic CMA like allocator for arm64 which
> > > > > > can support unmapped allocations then I am all for it. These platform
> > > > > > specific reserved pools isn't a scalable solution.
> > > > >
> > > > > What do you mean by generic CMA allocator here? An extension to
> > > > > shared-dma-pool? Or having the CMA automatically doing the unmap/map on
> > > > > cma_alloc() cma_release()?
> > > > >
> > > > > Right now I have created an API for the unmapping/remapping part. It adds a
> > > > > burden on the caller, but the alternative solution is introducing post-alloc
> > > > > pre-dealloc callbacks in the CMA, which looked a bit overkilled to me when
> > > > > the users of that "ffa-pool" are only optee and the nvidia video dma-buf heap.
> > > > >
> > > 
> > > I am not too worried about where the actual implementation lives but
> > > looks like CMA driver to be the better place. I think use-cases like
> > > guest_memfd proposed as a user for __GFP_UNMAPPED on arm64 will also be
> > > looking for this feature.
> > > 
> > > -Sumit
> > > 
> > > > >
> > > > > >
> > > > > > > You could allocate the DMABufs from a CMA region that has no linear alias.
> > > > > >
> > > > > > Allocation from generic CMA pool is already the case here:
> > > > > >
> > > > > > tee_shm_alloc_dma_mem() ->
> > > > > >   dma_alloc_pages()
> > > > > >
> > > > > > Do you mean it's just fine to unmap buffers allocated from generic CMA
> > > > > > region since it doesn't have any linear alias?
> > > > > >
> > > > > > >
> > > > > > > > > Vincent's series tackles that by using a pool so that only that part of
> > > > > > > > > memory requires the pte-level mappings in the linear map. That's the
> > > > > > > > > whole point of it, so I don't think it makes sense to drop it in favour
> > > > > > > > > of Brendan's approach (which doesn't work).
> > > > > > > > >
> > > > > > > >
> > > > > > > > For protected DMABufs, we even don't require any pte-level mappings in
> > > > > > > > linear map. The whole idea of mapping and unmapping is just a bottleneck
> > > > > > > > for performance sensitive secure media pipeline use-cases. That's why if
> > > > > > > > we can support __GFP_UNMAPPED with the memory allocator on arm64 would
> > > > > > > > be the best fit for this use-case.
> > > > > > >
> > > > > > > The point is that you will require pte-level mappings for the linear map
> > > > > > > if you want to unmap from it at runtime on arm64. If you don't, then you
> > > > > > > can end up needing to split a block mapping (e.g. pmd-level) when you
> > > > > > > decide to unmap only part of it and there isn't a safe way to do that on
> > > > > > > arm64 without transiently unmapping the entire block, which can lead to
> > > > > > > fatal translation faults during that window.
> > > > > >
> > > > > > I agree with you here, what I am rather trying to find if on arm64 there
> > > > > > is any possibilty to have a generic allocator for unmapped pages. That's
> > > > > > the use-case here as well as what Brendan't patch-set was trying to address.
> > > > > >
> > > > > > >
> > > > > > > > Now the question is why arm64 can't support __GFP_UNMAPPED similar to
> > > > > > > > how Brendan is doing it for x86?
> > > > > > >
> > > > > > > Because arm64 != x86? Presumably x86 doesn't have the strict
> > > > > > > break-before-make requirements we have on arm64.
> > > > > > >
> > > > > >
> > > > > > Sure, sounds like you are eluding to that the generic MM flag
> > > > > > __GFP_UNMAPPED being proposed can't be supported on arm64, right?
> > > > > >
> > > > > > -Sumit
> > > >
> > > > --
> > > > Vincent
> > 

