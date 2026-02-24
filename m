Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189D0EA4FD7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360796B0088; Tue, 24 Feb 2026 04:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D516B0089; Tue, 24 Feb 2026 04:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219B96B008A; Tue, 24 Feb 2026 04:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2646B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:29:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA6D8C1DC5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:29:07 +0000 (UTC)
X-FDA: 84478826334.22.18E2608
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2BE68C0003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:29:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YkzACdBF;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771925346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZwhSa617uEjMFtW+q7BiW4thUUL3CEQayS0Qmvpakg=;
	b=lz/FY4JHCB2xYwmH4Du1uVTLo0lPQlShY2BMNKWrBeL8Fn49IOcKL7ld/RdGBHJRjd+PIy
	2Hu4mvEQ5TSFXhb3qaWM9oHyIDBFgBDGmGcq7qphl6UTwungA5sm10qIvLoVfyUkYvRc1i
	7exvHODW41NQXIVxh1qRObrQkZvbRBk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YkzACdBF;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771925346; a=rsa-sha256;
	cv=none;
	b=6SZ/uQho3EA/HcYBFWm7iLBjvUBcxvzRPEYRheQAvUm79lvtwIWyS35NaBQTPIu33w2JUk
	2I1gHypan/S78YTeiSRuao2EPR+0keo/HtiEq5litK07bQL99mCa3T5pUWG74du7AM87Zb
	MkPaiQU8v/dzx0p/AuaQ7lkQo5eXX/s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03C7B44039;
	Tue, 24 Feb 2026 09:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF73C116D0;
	Tue, 24 Feb 2026 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771925344;
	bh=MhPzZ6IPkSbMVpSdEXmyDg4879I8IIzPI0L+1oFc8Dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkzACdBFp7Gi1bnBPNqe9LdepLVyLwAAcTSbPhiPpUZYejSmpDirUB1dyQyFN7v1R
	 VtxoXczDGrNDIuMJzgkg4eiFkmxh+KKy4arwOP4JJyYEK26D7pIP8oa1xZKM/p6flD
	 htHhB/tY8naYuXrFPIzmvCAKyZQsv3RwrdGLjWwhqaVvIzdQotM2XZeMTJctTkYtL6
	 G3zngKA/5wIYmxRW4pRcUWe/l6tW3FC2yFd3jzmgWqoTEybQ7WeV+0euuGYRWDwn2t
	 gBiCvKLfTKhOipiCn5L/znakrpHser+tjPWF4dYmH1C8KwRESW/XMWtEHKXgYBQKIX
	 n2QkFK9Y0dFLw==
Date: Tue, 24 Feb 2026 11:28:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Message-ID: <aZ1vWEgJNwc2nrrA@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
 <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BE68C0003
X-Stat-Signature: ahdfa6drf1ttusx9xna4g7iu13tjgzsa
X-HE-Tag: 1771925345-526095
X-HE-Meta: U2FsdGVkX180HYdsyudlUpD58kCKcPm8dmUlnRioR6SY/2+AR2TqM1GZpobn0D6ZU9ysPavjwWsaAqUtgkBZ82ghocSVS4e/WT6PEm9Dctk1m4ERNIgwTH0JsxV2lXsBDAlocxKBsRQ86SztpxziAaoIY2ORhhHBI1frZYwnK1RgfbQlpq9OJTuYJ1eb/lcE2DWtItyOw4uSOfq7HrMu0UOu+PLlWYcyIrTMwc5w/ndFk12UFxMat8hQcp1vGx9EbaIkFZo19Afbb7IhVfINEi/8xXAXSTYCl8uGQbPrFCExq6/5NhtQ3tWTbrMpTjxKW1AqD/ohPbMym1cvArDGCus66TmtkE4VaQCfwI3loWbzVm0bEWuMNThi6nv6uAQ+iJ26Q/z4iYOOMPe1c3zT/XrhRTu2Is7sGRwH8CBHxBwNOs5+TqMRTn6Y01uf75zQFWkp+BaTB18PXNyZgikJNNhacuNj4R8gWgAz/78CQxAQPUkZAZvhP0WgnQxhv9Lhjt2bEBad7juKR8sDlmjRf3x9BVQ3OVX/hrVKjku5u4fR09ONpjiu9VDsyNoK6ubNNtfNh1mJQd/L/JYicHC5grUQD13bxFEZzpKNCexlOrTiRFuZxnubdd8n3wWP0TqfEjExhkjZonf/OyhGb1+oZUL/fdu9Go7IhLq7IrYQdUNwNN1IMbITjglLWoNYXqbe3kIg8CynHxDtw8c4mFXKzjRLP6wchoNOaFN49o/kNFjWb6PocIKVWE7VyL2uqMog2mOOvgLS7MIN6qgcUPXmoXqDbE400uUxkwM2AD1Mg1wlc2L/ztnCukfLs9eAv49V0b7n5kDJl7W6uiJvcD0+bUGrBEvOT9DpVru7C8ic+MSNaW9giSwZf7Uy67Lm+rku4vIcbFXN10s0EGsQ/EiO36Wqn2U9TuqX0kxSPoM0azqqfWUE5ClOUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 01:18:41PM +0100, Ard Biesheuvel wrote:
> On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
> > On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
> >>
> >> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> >> > why I didn't use the existing EFI memory map.
> >> >
> >> > Now thinking about it, if the unmapping can happen later, maybe we'll just
> >> > move the entire efi_free_boot_services() to an initcall?
> >> 
> >> As long as it is pre-SMP, as that code also contains a quirk to allocate
> >> the real mode trampoline if all memory below 1 MB is used for boot
> >> services.
> >
> > initcall is long after SMP. It the real mode trampoline allocation is the
> > only thing that should happen pre-SMP?
> 
> early_initcall() should be early enough, those run before SMP init.

I don't think so. All initcalls run quite late in boot, early ones just run
before the others.
 
> >> But actually, that should be a separate quirk to begin with, rather than
> >> being integrated into an unrelated function that happens to iterate over
> >> the boot services regions. The only problem, I guess, is that
> >> memblock_reserve()'ing that sub-1MB region in the old location in the
> >> ordinary way would cause it to be freed again in the initcall?
> >
> > Right now we anyway don't free anything below 1M, I don't see why it should
> > change. 
> >
> >> But yes, in general I think it is fine to unmap those regions from the
> >> EFI page tables during an initcall.
> >
> > Thanks for confirming. I'll look into extracting the allocation of the real
> > mode trampoline to a separate quirk and then making the entire
> > efi_free_boot_services() an initcall.

There's another issue with making the entire efi_free_boot_services() an
initcall. It updates efi.memmap without any synchronization and if it'll
run after SMP init, there might be a concurrent access to the efi.memmap.

It seems to me that to be on the safe side the simplest and easiest for
backporting is to stick with my original version. 
 
> Thanks!

-- 
Sincerely yours,
Mike.

