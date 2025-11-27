Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66868CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948806B0008; Thu, 27 Nov 2025 00:05:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8DE6B0010; Thu, 27 Nov 2025 00:05:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8366E6B0012; Thu, 27 Nov 2025 00:05:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7149D6B0008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:05:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10E43507EC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:05:15 +0000 (UTC)
X-FDA: 84155198190.27.6006879
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D74DC0009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:05:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6gjVPPd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764219913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATAQNKgd02/puUJA2TapCe5ElrKis8cm8GiXMlRXz8w=;
	b=uC2uc6K71GXq5qguPnnQfwSRre37aaAnOT/q8ezphrsr5F8jsmZ8aa8ANDE0s5UjkuFr3/
	9o48j0THS9NLAdQoFOD4uXqI4Vp5+VsHMlHD6QF7O6ABRu99Q84RaikZQyGU0PAQlpYFzP
	zZg6BgJck1CORjgRljGW+h7+u4Iz35Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764219913; a=rsa-sha256;
	cv=none;
	b=iIM7Nfpr3QEYFEKEkD33mBIhQgj4ZPXJ1DDL00W624IZudgFvgpaX0W4PCES9jhefNIN4W
	9RXwUSUPEPSRxHlMuHSJlKX/YtJO5/T0QTALURO1URkLp0BxaRrT4Ubwv+MEk4j/DUY8ay
	AnP32SyJJNcqkYpH4HLVOS8Y44Q9so4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C6gjVPPd;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B4D8760178;
	Thu, 27 Nov 2025 05:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98277C4CEF8;
	Thu, 27 Nov 2025 05:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764219912;
	bh=0JRSyQXSjczKq5XdXn3CWvx8+zdnsFfxK+TfDYlXczY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C6gjVPPdP/VVRhfNC+VDHXi2GkriaQ59zF9dvrRLavOayKedKO5VbJRufDpzaSKcT
	 18Yctoq4Bqz+A3ymRbCPtfV0a8OX0gaSH+Bm6w4VQzsKXgtFzCgKm5ydaL5PtJQ29h
	 tAfGWpMBVJbutynfBiW2hC33t3Pjdnc9gI26HN9BHIfQdB+IRyFb8YI4OTAELjHoms
	 YU3d6pfUEf5aVjmhCea6buNTMXzYuBplHMU86HuFKkimf1lNCq9yQdgXLx+zpo27ue
	 WRk7CmXmcxExayuBj/MLwXSztWFz37wHyVxg1s6TYpUsgDjvdYx+b1Swxhj+lI21p7
	 Al/h8msq0yXNQ==
Date: Thu, 27 Nov 2025 07:05:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>, changyuanl@google.com,
	graf@amazon.com, leitao@debian.org, thevlad@meta.com,
	pratyush@kernel.org, dave.hansen@linux.intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memblock: only mark/clear KHO scratch memory when
 needed
Message-ID: <aSfcAOiTzCba2LC0@kernel.org>
References: <20251126072051.546700-1-usamaarif642@gmail.com>
 <md65ppfkqim2kepsx6igvezpcnr4hx3g2dxfdojsgx4rligwfg@u5dejfzmirfc>
 <fcf022e3-1d5e-4f66-9f95-49faefda04a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcf022e3-1d5e-4f66-9f95-49faefda04a6@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D74DC0009
X-Stat-Signature: ztt1158wnmatnnbuqxeauqc1ytgondf1
X-HE-Tag: 1764219913-57387
X-HE-Meta: U2FsdGVkX1/qEBPPMAdZaAmtQXDx5+qmtz1Zo5WhxdhJUtE1dw+Dt8Hn3VaXAqrk4nM8pTf1if6v7m+KWY5erECzuwtgJPYQnJA8CO2X+nObqQ8fB3iZl9GNbPIKaKQi1Z2F2cD2THVsjmIw1llA3d+KBBG5bVIbXJmB/tcgwhyV1lOI2/CsWALlI6DNGyRd59caYfUZak9iODIcyawF0Qy9qwQffU2CsTQvT/4mpxhzbEPOio/x2C1Z37ayfYrIOm7bXa5GeF5R0tOW7kPgfcES2e0m+opidVwm8Ae5176aaGFRXMpbDZ7q/2bxwysDVU4AJxCTUvFfXuhe86LAu+wnjlgdH6xbdpjm0Zusx0FokCAAiLBWP2hmEFekpJ6QFooanxP3uX4sZWnrYFO/9Wiq5g7Lo5Qe998zhVnpWlRV/bQTYZ7WPD64YT1vFoGN8auZL4EMwGH18IczH8p9Pzt8myPbcVoj3yUEDQGKH2N3JE67pXCVSvpO+JnrMWI8JVVEreyo20EyHe2800YkrX/+XT+pXNPkhcZOVGss0q6tuj5o54vxlE6ufsAhG6CxTcpaeg0x72yem/1CwmRz0ayyGBheo8J0F/Hd124U3x0WdxkVOe4f0Uv5Cfh4reXYAo39h3fvj2DSUrZe0cN2gBvNGybpSj1r/oO6NYcE+qtRvJtxcIgDTYDWdRQXIyZeAMmxIARMVHESsH87002gREvlR/TJD5vivUhbvqnBIBZgH4zlEY9+NQnAFqKuRxHcORuDBcX8FI8X7gIrnxEgBDVqaaaeso4U7A6LZ1Xw82eUur+BCYW6Ln7ZXNxLCH+mOsfZEM5YqPfZIWlboq9hH9b1f1gbxDzGxz1s0uDP6D7kygoG+XzSv+jB5dOnPyVMUnGu1GbSuYh38J+PflnNLw1ALtisCOoNencrC7QJvtfPmUw6Kl4sOnC5V1YY9E9lUiHiA1O8sTpu7xpmVGk
 mgxqkSUq
 Ut5sjij+QEybtPX/aLDpYlopqil8Yb5TosMhI2Th55Ud9TyVEXE91qTESRVTI6XMACKvpULA90NkHWaFU9LixOIFJpYOZZ+Xi/n1aXSkXX0exrFMWOIzhcpsaoK/O/tq0tzHXAIqufMAf6X1AsZVV36B5C6Jibc/jG893TsI4W628wZgMKxmsiuv0Se/JSHZ18AF1DPFIzNsk21g3/TR3QSRUdXC9Whk3MWDc4riyP/+en/vV1jVtq6zoguhK7r6POY9x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:43:21AM +0000, Usama Arif wrote:
> 
> On 26/11/2025 10:40, Kiryl Shutsemau wrote:
> > On Wed, Nov 26, 2025 at 07:20:51AM +0000, Usama Arif wrote:
> >> @@ -1126,8 +1126,11 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
> >>   */
> >>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
> >>  {
> >> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> >> -				    MEMBLOCK_KHO_SCRATCH);
> >> +	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())
> > 
> > It makes me wounder why CONFIG_MEMBLOCK_KHO_SCRATCH exists? It seems to
> > be a proxy for CONFIG_KEXEC_HANDOVER which is the only option that
> > selects it and does it always.
> > 
> > Can we make s/CONFIG_MEMBLOCK_KHO_SCRATCH/CONFIG_KEXEC_HANDOVER/ and
> > remove IS_ENABLED() from this check? Just is_kho_boot() is enough.
> > 
> > 
> 
> Thats a very good point! I imagine it might have been for maybe debug purposes?
> 
> Looking at the code, CONFIG_MEMBLOCK_KHO_SCRATCH shouldnt be needed. I guess
> this might be a good time to clean it up. If Mike is happy for it to be replaced
> with CONFIG_KEXEC_HANDOVER (and removed where needed), happy to send that
> for review instead of this.

Yeah, let's kill CONFIG_MEMBLOCK_KHO_SCRATCH and use CONFIG_KEXEC_HANDOVER
where needed.
IS_ENABLED() is not needed in the check because with
CONFIG_MEMBLOCK_KHO_SCRATCH=n both mark_kho_scratch() and
clear_kho_scratch() are empty stubs, so it's enough to check is_kho_boot().

> Thanks
> Usama

-- 
Sincerely yours,
Mike.

