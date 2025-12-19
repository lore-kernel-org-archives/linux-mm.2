Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154B2D711CD
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515B36B0088; Thu, 18 Dec 2025 19:03:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C36E6B0089; Thu, 18 Dec 2025 19:03:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A55A6B008A; Thu, 18 Dec 2025 19:03:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2955C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:03:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD2B716039B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:03:35 +0000 (UTC)
X-FDA: 84234271590.25.9602A22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 362FE140013
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:03:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ou37KOyy;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102614; a=rsa-sha256;
	cv=none;
	b=GVjliEACamw1MZvgbJ6WaxIAK8NUV3P5hrRS+bNI/F/wsmyteuwh7u6ArE7K1KmoiySjUV
	wRRR5ib3zLX43G+aA//NYNRPG06KrGCJoBnJqqp+tna1f9VwKCaWRsSSA5YV7Zn31KzPKU
	aO7A/xuqBUetYQRh4HHIRAIP/1UjUUs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ou37KOyy;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSSgpL1/vw4VTgMFRjX4bgzcZxuipkW5LfQUnvFNq+8=;
	b=F7qXZtlaZjqBkBtmM6k5NL0Xvp8yzHC47NtTnlfPt6LF548cNmbWbDssu/hoaJKQWE/kmr
	52p8II4++3CU42nHyo2b7fagDvuG2DDztDcbZK2mBdejG5P+swku83fHFR3tTJ0iY+4Pk8
	eLMZ0ze0MUaFDlVHFtKJrosdNcXNAZQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A2A4060008;
	Fri, 19 Dec 2025 00:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3873C4CEFB;
	Fri, 19 Dec 2025 00:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766102613;
	bh=8E6NAIDxQMdp/s3lyLs23U2jDp0pVydVmLy6lig72oo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ou37KOyy/qUsRdv+f7A/vXWmM6at3ULcpPNQp4K3dWHw6+WdeucY7orgVLPhNsZWW
	 z5E7EXHQ8MKf/c3U7xANZL0sk27brGRGj1lwDM7M3KRLTsbn9jfywK9s41Uh1wFcBL
	 FVb6B/ynS7thy421b3HjKo0OufktoQsfbOqYJbdA=
Date: Thu, 18 Dec 2025 16:03:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: John Groves <John@groves.net>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, John Groves <jgroves@micron.com>,
 "Darrick J . Wong" <djwong@kernel.org>, Dan Williams
 <dan.j.williams@intel.com>, Gregory Price <gourry@gourry.net>, Balbir Singh
 <bsingharora@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aravind Ramesh
 <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [PATCH] mm/memremap: fix spurious large folio warning for
 FS-DAX
Message-Id: <20251218160332.ee5b1c9b2ac7aebabbabfa45@linux-foundation.org>
In-Reply-To: <74npmrpzagba2bbye7kmwwoguafbpvnkxarprp3txy4wmu6gxp@japia7ysaisi>
References: <20251217211310.98772-1-john@groves.net>
	<74npmrpzagba2bbye7kmwwoguafbpvnkxarprp3txy4wmu6gxp@japia7ysaisi>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 362FE140013
X-Stat-Signature: m58d19bw7s89cxcbaeff8wgyfiz5mzhd
X-HE-Tag: 1766102614-841409
X-HE-Meta: U2FsdGVkX19WfHJAmc6Yg/JEr2etuS8TzKikegZUHgV3lENLJmVnepxxsWILe1UAPACY7VF2HXOTs7FU1Nsh1/6RiqhEe+ci7qxUT7k/aGFzRc0mC+kqpwpmle0AxnNEIkQXmsOMPebq0lR8FrY1cLs8ZWaDdbc2RIPmL5oREBgwD6fWn61DW6iRgMfwJWaSviVkM+xBAFtr88XVUsYDG6Awa102KuKjSoNZ02dzKS3EXEzbhPP4ohkedSiuvIojPKeswEXBs480R5JL16CnEhPzxY2h0NX5VSOl7nXW5bft4eUcex1fJRUwZunottDrKpNzPzakxizavA5EIb+2+Dd5aHgexYooWWFJuEfI3S/fvy22ooyeBPsk9Y+UM0MvUlqwmr9Shvp9qHULLXbYtAA+dfGTO3K1p1MbTO3bsD1MyQY3TeO8XnNVBzqrStqj4Kd3OOUgv/7zOtQnxLs05OdtRwZftBpvVUabMqdS5lTlUsg31NBDtxdSE4FKSH6x2TpabLVeE8DRBZbiGwcT4LBgtWTXwsRMYSxER9GkPvDv4QkCjaxTmES3eqfPJ7X9JBDcST/7nG9DzvVG1u4lxSYLuhyxDXPEl5OKOxp30LdeTo8p6QUjasY/PxLYzE9094Sql63pAJFKsZHERjhtqhpWBGC4SsJnANofvJmBO+q2YwPrt3TH2amy1ijhM6zJ3myKtkicSIzGTRfmYlBrBh0UTcnC7K8l7NROUAVEqRDbSTqQmIL7WSMoX9CabL4yC7N05KDaiMPLhQstqL6GeDp9hdh6tY7OGpZtOKBp2dq+/ad/RPh/9XpmkUv6oW9bbmhWHO7TzVO6VWNfUp2lsSoQ6XQKRh55ItBjSN51Hq60zcLd/gg18dXHaqfcjmWauEFkeUv6x6j94nwIWEJWjxQpJTh+g6rWMk/GvjsGm+kvVB+dvhzYQmHrsfJIsqybdEiNqC1TDNzvohagtS9
 ucVsGMTS
 rk4sDblihQfR2HeEtP6EAKi6SDVHS7vEK2DxfwFn7R2PPdHyoyhwwnqvsrHBOHiq6oQBiv4XxyaB2ieutyGu0zuB+EHcRAcozxN35whB6nFnBOKdmVv8mP7kOGTyIVnaoEUrIEcOSz1IBUJOvtF5NcZO44wZIU2chdIA/Mhubso/GHHEuwFsdjhnTbDXYch+4y04O0DOjbBE7cQ+08xzWEYpqS98aWRGXu1NZEbBiQ9M4JC1T60reAmznweOVW5uEycUtTRICH4hrqzx4d8ldPmKKETjpj9YnGqR+vwKkuserFOf4VtZWHHgRmUFRFqUvHwQNrpoCpWX62k8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 09:58:02 +1100 Alistair Popple <apopple@nvidia.com> wrote:

> On 2025-12-18 at 08:13 +1100, John Groves <John@Groves.net> wrote...
> > From: John Groves <John@Groves.net>
> > 
> > This patch addresses a warning that I discovered while working on famfs,
> > which is an fs-dax file system that virtually always does PMD faults
> > (next famfs patch series coming after the holidays).
> > 
> > However, XFS also does PMD faults in fs-dax mode, and it also triggers
> > the warning. It takes some effort to get XFS to do a PMD fault, but
> > instructions to reproduce it are below.
> > 
> > The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
> > free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
> > when PMD (2MB) mappings are used.
> > 
> > FS-DAX legitimately creates large file-backed folios when handling PMD
> > faults. This is a core feature of FS-DAX that provides significant
> > performance benefits by mapping 2MB regions directly to persistent
> > memory. When these mappings are unmapped, the large folios are freed
> > through free_zone_device_folio(), which triggers the spurious warning.
> 
> Yep, and I'm pretty sure devdax can also create large folios so we might need
> a similar fix there. In fact looking at old vs. new code it seems we only ever
> used to have this warning for anon folios, which I think could only ever be true
> for DEVICE_PRIVATE or DEVICE_COHERENT folios.
> 
> So I suspect the proper fix is to just remove the warning entirely now that they
> also support compound sizes.

So I'm assuming we can expect an updated version of this fix.

> > The warning was introduced by commit that added support for large zone
> > device private folios. However, that commit did not account for FS-DAX
> > file-backed folios, which have always supported large (PMD-sized)
> > mappings.
> 
> Right, one of the nice side-effects (other than delaying fam-fs, sorry! :-/) of
> fixing the refcounting was that these started looking like normal large folios.
> 
> > The check distinguishes between anonymous folios (which clear
> > AnonExclusive flags for each sub-page) and file-backed folios. For
> > file-backed folios, it assumes large folios are unexpected - but this
> > assumption is incorrect for FS-DAX.
> > 
> > The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
> > allowing FS-DAX to continue using PMD mappings without triggering false
> > warnings.
> 
> As this is a fix you will want a "Fixes:" tag.

Someone (possibly me) already added

Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")



