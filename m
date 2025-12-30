Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB8FEE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916D06B0088; Tue, 30 Dec 2025 16:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C45B6B0089; Tue, 30 Dec 2025 16:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0ED6B008A; Tue, 30 Dec 2025 16:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7AE6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:35:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D71981AE80
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:35:25 +0000 (UTC)
X-FDA: 84277443810.24.CCB6F41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24ABAC000B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:35:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j+EKvvDe;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767130524; a=rsa-sha256;
	cv=none;
	b=2fy4KufKCtpsbRpYkdqI7IhGhLb9IMH3COIWt3D2l96xLJhbbhxbWEOS0UFZCgQo4Hm5gh
	Ex1zbptpTYQmUGvAoATDN4/2thJi2tLfbsVfSnXROsP2PKr+qnz2/6MjF9h0mAQ4BAlmv0
	ZnGXHmTLPpvpIoQ/8MQ4/HphxpV2w+g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j+EKvvDe;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWf1IC4Nj4zdgRawq4E0v6+GwxqbEd/T1wyrzGFB96E=;
	b=ID8HhK6K4zTNVUcyd4MB8yCne2wKuKTqVCZ+dBy7l3d3Cqjywn+smU/+2NdG44Hq/LxD1P
	dux34Sgy8ECdktqBheuA6MK4K0jInYy6SXGWu+FwEY0RgHnAP5hwLRKyc0mzOVYlyGDhY+
	XVxGEjNtudVD/NlAl4uK260QvcbLHt4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29990409E2;
	Tue, 30 Dec 2025 21:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA395C4CEFB;
	Tue, 30 Dec 2025 21:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767130523;
	bh=shiEpaQwRae9DsyfW9au1TJgLhz/UKe1CIW2dkA29WE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j+EKvvDe36Ovgd0cm2WGImRVqYOpoNmSz1Zg9LELcrGwr7X48ZZO+cc3rREGRc/3p
	 DPOfOtgFBpK3vqxiUHyIgTKBr/1qXPE+VlF57T1V2WJ21PwNXYl354rjQotN54UzbW
	 iBeDHJfFH3wUdD/qrPc4Thzkw/1jma3WwoZJHtyE=
Date: Tue, 30 Dec 2025 13:35:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <21cnbao@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Wale Zhang
 <wale.zhang.ftd@gmail.com>, chrisl@kernel.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, matthew.brost@intel.com, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled
 codes.
Message-Id: <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
In-Reply-To: <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
	<cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
	<CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 24ABAC000B
X-Rspamd-Server: rspam10
X-Stat-Signature: yrr1tcgyk338gfns9th3wercb6poxoyt
X-HE-Tag: 1767130523-960296
X-HE-Meta: U2FsdGVkX1857D4+z+4KZhoA6vSMo+UxitPrPdfnFTVpRuWIqdxFBINUwID5MYhHw98pWHAal13Ues2NMcT2Wb9U29grzpDJh37SESQEsa6d0W/8ayBfZUO0bwDNFvvz1sK4k5lOgNYGlLaoTd0ZTBGVlO+xKdH+FY9m/TzoIYZfxLCd/efrraszHlzjSh9F8rmdlK7jAqOx6QM4CYtzEOCgIjjT4Rl0bsKHpe9Vddy7hQzDiSZBzmWR1nMAD/ywYSR7PyHcZ6grGUHMJ1VR8HsPVo4qnuvqGMF3OYkFWpjbjBdBJOXDejHKVED/BiDnCPR145+LnHMHeZ93OjzfCPHUYhnTErdyA1vTGxrWocC+8vcJIQr4gOiw2flYhXtThQkvdGohju7zMtjMbemwFOKQiBLpVk0zR/F5kGwguPFXVXb1BVEURNJ9LxUH/+Yz53DkZ26HukBYTUauRJiZi6itBPKC1I/togbCHwP4xArbouPhm2a39IRCHepJhqm0M4Ns/MKAZrKOpj3tQsAc4HGiyNr1S/WxlU5GtaSyhNjuTDGTvTrq5b4yVuX/QolUnQKK/xJSNrjgvCHRjtQSKo3h894vMciMvXCaTSWiqo6vCciiKU36wlggasZfDhmxGEGTfv2UJCv4I6uFi/9DRVXnPNd/Uj0ZfMWFQDnvHKzJm5xeamecf+xGqFRAhaB/c0dwywiGbEfvTsdS+GGWmZNWHOV3NC93Su6sIbyNmXRSuQMxRwJX/jULHlJKZZoHS4RGJHcrxrBguepHWfKPR68UwkgcDXeNCwrZUzmFeBnkzSPM6ymXYX0KaP+Qwz9v3w+Ef5X2QSOZGUXkM/4Z/ZZ9nZdD7kEDB6t1wtKG4rbLfECEra/+vGL4ScpWvc3bRL9VIUE94ZUv50/d/q6Gil4/OL3PBQz7S4eT92lF5lqaIsTW2hWh4Gk/i0kqxnyo8NSnv/G1N9PqzVg/r6P
 WYZ2ryDP
 pEb3zt4EyX0xnsSxGLI2nlIqTsOn0m+HoQom0yD5AN4HAZg6girMOaFAXwnFieTTo3620ynNwm3ZAMFlKG8x+X5+alTY5VbFneeh/j2BnihQzyZebsEIXXRVpDaB+0wzFwAQPNhrWMJUT0yeP4L+0KDUQGx9ABD4ydRcP8p1uSBlf8ARlzGTqvwIMvzpMwZCFRknPbK/UtLIVJWOUXwVDNf22B7jfyl+wVYkTEinLeL+BL4ayUzzhQCscrmU4fH5sia/tDIQOwQ2GX90yrgcJJg+/yio8nxuiyJdJg2zfBtD0E95dPO7IlEPkPrEGov6CBGLc/HFTTtCEjB86wTt/cb2t5mEpjux4Y9dz8dikCil7FQIkm6bozoOIXRBzeTQgaKw3bQ8pGOoZpSI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 10:28:25 +1300 Barry Song <21cnbao@gmail.com> wrote:

> On Wed, Dec 31, 2025 at 8:50 AM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
> >
> >
> > > -                     break;
> > > +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> > > +             last = atomic_add_negative(-1, &folio->_entire_mapcount);
> > > +             if (level == PGTABLE_LEVEL_PMD && last)
> > > +                     nr_pmdmapped = folio_large_nr_pages(folio);
> > > +             nr = folio_dec_return_large_mapcount(folio, vma);
> > > +             if (!nr) {
> > > +                     /* Now completely unmapped. */
> > > +                     nr = folio_large_nr_pages(folio);
> > > +             } else {
> > > +                     partially_mapped = last &&
> > > +                             nr < folio_large_nr_pages(folio);
> > > +                     nr = 0;
> >
> > The whole code was written to avoid ifdefs.
> 
> The #ifdefs are only for -O0 builds, which are never a
> mainline requirement. However, dropping functions that
> contain nothing but a BUILD_BUG() seems reasonable?

Let's not make -O0 an objective, please.  We often make assumptions
about dead code elimination in order to keep kernel code more pleasing
to read and to maintain.

> If those functions were actually required, the compiler
> would fail anyway. In that case, there doesn’t seem to be
> much value in keeping wrapper functions whose sole purpose
> is to contain a single BUILD_BUG().

I agree with that part of the patch - if the thing only does a
BUILD_BUG() then let's simply remove it.  If somehow the compiler tries
to reference the now-not-present function then we'll get an error message
anyway.


