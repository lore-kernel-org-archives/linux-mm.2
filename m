Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FA3E81BA4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 12:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF416B0005; Mon,  9 Feb 2026 07:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FCA6B0088; Mon,  9 Feb 2026 07:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD226B0089; Mon,  9 Feb 2026 07:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC95F6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:02:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62FB51B330E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:02:37 +0000 (UTC)
X-FDA: 84424781154.02.F8D59D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 84C782001B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:02:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbZ3rNX3;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770638555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WfBFjVA09j4luMmRorBm/nSBpM5ERPntrmJhOsTzJk=;
	b=jU+OfFyqxRAy2LFrz0+NZQOfVTpV50tReXb4Y7NSxeTs2BqQ7t+tZjFd629og5lKi71HiN
	r5RlA4FF/1zGwLw6GVUx3uDu0985ISQ0GFnCYARsfDAh4PG7Eh4VrAwCC7h6ajIo4KbXZu
	B67bXgRC+TnCskdtJBoy8Uq3wk+rtIc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BbZ3rNX3;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770638555; a=rsa-sha256;
	cv=none;
	b=Ith1QXs8WmTQfD0tGU13T44sF4eYuJ1YVl2dz7uYQB+qgpMi5SlqP37z9KDuRC/5O7Dky5
	oMuRTxMx3sl4VL48Rfmxq8o8UbT8NZIULISdcLb+lzUDop88D2fYnuoTaKH7Qo4Egm0NF6
	mD3vB6U8kjKvHhhIb+x1JZoiLZwmWCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3263C44382;
	Mon,  9 Feb 2026 12:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FACC116C6;
	Mon,  9 Feb 2026 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770638554;
	bh=GxBpqi2qXXbPzWl7ejHnIMQoFh9rAVUsvwOwbYG0E1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BbZ3rNX3aA8++I13QCqbGeTnbz5fH0D7y8SozLNMmlauEZy2itXUAJLgU23vsXVQx
	 3VuLwHkWF0qpOqgUcy3YpN3lQicG2IVF0J2fPEwCJjine9RdT4lUSkI+HLnFTnWykm
	 E4gQLkkp3sgchOD89mi2GGLsstXHRo5Cn4XYM+M0WbymOzGpnw839OYR7ABTW20KNY
	 Ww/gFxdLl68Q+B+28hnk+pjIMCk/dYTR7OmvOitacgLpFz9EWIw9fWP8RL6ZoiYBVX
	 PUPRVGHxpK5dbv3dEYkMKODjP+a6rVJCRdwJsMdWRw59dB3qgkmUpIUEOcHT5FI2+b
	 w2KQaTpWeFGGg==
Date: Mon, 9 Feb 2026 12:02:28 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, zengheng4@huawei.com, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] arm64: mm: fix pass user prot to ioremap_prot in
 generic_access_phys
Message-ID: <aYnM1A-9VZaOZoC_@willie-the-truck>
References: <20260130073807.99474-1-tujinjiang@huawei.com>
 <aYC6_lSm_eJeKIcn@willie-the-truck>
 <73396cda-e12c-484f-ab84-b09e7aab8bb0@huawei.com>
 <aYG-dGzR6MuPSQBK@willie-the-truck>
 <a4ee7faa-5b0d-4ffa-bc06-939d95ef7680@huawei.com>
 <aYSp0--x_QgyiUWL@arm.com>
 <aYTVAeMm5cFnuAL7@willie-the-truck>
 <aYTgoFQjEs_5WyC-@arm.com>
 <aYXZsRpmQIb7q83D@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aYXZsRpmQIb7q83D@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 84C782001B
X-Rspamd-Server: rspam07
X-Stat-Signature: fnx7ikcqxuzjh8gq5c8miritxc1xf3ny
X-HE-Tag: 1770638555-471473
X-HE-Meta: U2FsdGVkX18Hsl0qZEkg6cclQrIfU41q3dFvwe0+Lg5Gs63V9FmVQv4tyKrgL1n4dNvoxQ9i7wXYwTy8kS0Q64rU6WHzakKOKC9LFCe4FnBKw3Q4UzRoZXdTgj8EyasdpYfqAPcte4BjblRQVKE5PALSm8vI2OuIorKDefLXplrMPEwtwd0dEnOq0vs8IGHPc8d4crxWFAz7xVDa3wbtoQd9tYg4oukjAryo07IIzf04XXLUXvTH3SO8qrlTK9q64svc/+vZ0Il/TbDpjNScc75mBNOx52jpzRrGZIwkqYRWlZXuhJD2JqgjWT35az9s2skkYOXhELduOBVCtiTnSZ0fLucmkQe3TAXWqPxsVGwnix8BN0TU/FCEQ7mCi1+kfwe4kmUvgKzYjJwIUdCdIXwiMkCqTjvKBuHHg22E8EtwDZU8IpeLO0M3dANEYeJFMpRDNbIx7mE9MbjEaIZpNVuYVmv3BCoyCGm7Wg8kJZE3TAWi6/avn4WAg0sFE7yogS1cR56YEyy3UVHmsZg0v//cG/EAwItV57pA/uW2ikZz+hHhA6II4UpHp673PXsh2EvoijFJfGF+ubQh71o0S3qNpofjJe7E67umtcwEZ9YbChjbbDaX1JUxyfoxC98YmiNF+ZYUMIaoQAjjNX/gFxX8F7vDhVAHL8sIDuuElT53Is0CSMM6LVV3z9wmycxCERqVXzqngBqG3cPtAh+ZgJ4GoL768TOY3UE5mLmlLdwQSoUCq2AZKtnYmGx2y8gL/kmCE101uGhoGd6g8MsJ7/K+ilji77cbV/dsMhEUOErv12nd7Tm67zDqXucxB/YpyKfDlfzhwuifGN/AhWt6XO3CIrlMTCXCMVq5Q3lWyv532nRLfH8pwlIQ4SrI4bBW8sv/Sw6xu5b3SBlM2SEUsTkYKwQ+98wWBXRWGGPIS4jtLgpmwl6oj/UgFWzCNXWoBrvpoHm9Rd0arXF7P8X
 2kvu0oHk
 eru/UeYSHNGMjNh6ixWVnzxZdrPyscgU2wLB+Vh0yCS4ODaRzRFwmh4t5K+hHfMlfrIaCLjoW1ni+58Dn0Qq8ssCI8nf14k+2nW4tFLrEFhACKWHlHYW0mWFXmQdZMKtXP+cXZRMl9x48pUa5+eMUb+eDlobVeHuudOYH5RFe+hBBQem7xvNWyT8Teez198TzCnYod4D1CeIsRL7i1Ne/iGs6sa7WuhEIs9xzXLF91AgjHx7MQyZXmcBykuCck5ZXWrmc4mQ/bHyM9zKDlnIA6oSITEziY+3CJFJzuonMLhqlvAW9utKyESp+uZDt+WfbYFkE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 12:08:17PM +0000, Catalin Marinas wrote:
> On Thu, Feb 05, 2026 at 06:25:36PM +0000, Catalin Marinas wrote:
> > On Thu, Feb 05, 2026 at 05:36:01PM +0000, Will Deacon wrote:
> > > On Thu, Feb 05, 2026 at 02:31:47PM +0000, Catalin Marinas wrote:
> > > > On Thu, Feb 05, 2026 at 03:23:27PM +0800, Jinjiang Tu wrote:
> > > > > 在 2026/2/3 17:23, Will Deacon 写道:
> > > > > > On Tue, Feb 03, 2026 at 11:38:15AM +0800, Jinjiang Tu wrote:
> > > > > > > 在 2026/2/2 22:55, Will Deacon 写道:
> > > > > > > > On Fri, Jan 30, 2026 at 03:38:07PM +0800, Jinjiang Tu wrote:
> > > > > > > > > +#define arch_mk_kernel_prot arch_mk_kernel_prot
> > > > > > > > > +static inline pgprot_t arch_mk_kernel_prot(pgprot_t user_prot)
> > > > > > > > > +{
> > > > > > > > > +	ptdesc_t mem_type = pgprot_val(user_prot) & PTE_ATTRINDX_MASK;
> > > > > > > > > +
> > > > > > > > > +	return __pgprot_modify(PAGE_KERNEL, PTE_ATTRINDX_MASK, mem_type);
> > > > > > > > > +}
> > > > > > > > 
> > > > > > > > Do we really need another arch helper here?
> > > > [...]
> > > > > > My point is that we already have the helper: ioremap_prot(). Just fix
> > > > > > that for arm64 and cc the other arch maintainers if you're not sure how
> > > > > > to fix it for them. What we don't need to do is add an additional helper.
> > > > > 
> > > > > ioremap_prot() may be called outside of arch/arm64 in the future, and I think
> > > > > most of the cases will not pass a user prot to ioremap_prot().
> > > > > 
> > > > > generic_access_phys() is a special case, so I want to limit the modification to
> > > > > generic_access_phys() only.
> > > > 
> > > > Or we can just have an ioremap_user_prot() (or some more meaningful
> > > > name), defined by default as ioremap_prot(). It's still introducing a
> > > > new macro though, unless we go and rename it on all architectures.
> > > 
> > > ioremap_prot() has exactly one caller outside of arch code and that is
> > > generic_access_phys(). We should just fix the arm64 implementation of
> > > ioremap_prot() and not introduce any new macros. If a new caller comes
> > > along later, we can figure out what to do then. We could shout if the
> > > prot isn't a user prot so we detect the problem.
> > 
> > I was more worried about out of tree drivers using it since it's an
> > EXPORT_SYMBOL(). We should remove the export anyway given that we have
> > only a fixed number of memory types programmed in MAIR and all have
> > corresponding ioremap wrappers already.
> > 
> > So yes, just fixing it in ioremap_prot() works for me if we also remove
> > the export, just in case there are dodgy drivers out there.
> 
> Ah, removing the export would break KMI if backported (unless GKI won't
> merge it) since all the other ioremap_* macros use ioremap_prot(). Well,
> not a problem for stable/LTS in general, just for GKI.

Upstream really shouldn't care about out-of-tree drivers or Android ABI
guarantees.

> I would still introduce a new ioremap_user_prot() to make the intent
> clearer. In its implementation we could skip the ioremap_prot_hook().

I still think this is unnecessary churn. You then end up with
ioremap_prot() having no callers outside of arch/ and if core code just
defines ioremap_user_prot() to ioremap_prot() for everybody apart from
arm64 then the intent isn't clear at all.

> For generic_access_phys(), do we even care about encrypted/decrypted
> pgprot?

Dunno.

Will

