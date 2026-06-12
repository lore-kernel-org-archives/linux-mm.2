Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C740ACD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D41D6B008C; Fri, 12 Jun 2026 03:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085BA6B0092; Fri, 12 Jun 2026 03:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09956B0093; Fri, 12 Jun 2026 03:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44EF6B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:18:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E33B1C2BEC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:18:05 +0000 (UTC)
X-FDA: 84870406530.18.B41D299
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90FDC1C0002;
	Fri, 12 Jun 2026 07:18:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6MPI5gE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781248683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRlI91H90jnEd6QVhakYzPZr1kG+YnVR7+LXyLJH35o=;
	b=Ow31zqJve3v2Brto3YybxjjWhjujd2V0qsjTO7dGnH5m3vvNrrqXenOHPwAFRkYLR1CiWE
	VT0nld/NCD0HGhmFW34NPrVMEMXdomgKNwp+pIRNB5ulNJbF4RvMVv2FwCQ69AFQURWcKl
	Sv03fFuIdSQQSuw/OoRaFHb/bHJ/7f8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L6MPI5gE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781248683;
	b=LtBHPhtNg90gNT1c8o6UwJx79aozCLDY/k9whAH0+aMMSllRowRbVfMJjmJ7vMIKldA90I
	Xccaq4uMsVMhhPC4CjshthnqmVa9kDVKPk7qrRcaZkLm5nrSQvAFRbtYPtiTS2RdLfAdVm
	z+mTH3Zssf3awBcVFfyO2wgssCH//v8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ABF5429E4;
	Fri, 12 Jun 2026 07:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC341F000E9;
	Fri, 12 Jun 2026 07:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781248682;
	bh=HRlI91H90jnEd6QVhakYzPZr1kG+YnVR7+LXyLJH35o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L6MPI5gE1EdULfuqHX9FeI9o0O6WUcgtuZPpWMq+YYQz4NIsNDinQEUyjqduDtf8k
	 l8gWpChVZWxKZ9IMjrvPCyDVpfk/zIqoonwcdK/KvKB29G9P9G+Ph0rCNIgppcmtbT
	 tSZB3ZTQO2faTEcLNza0Ezw0v8mFkL7pakAFNDwxpgSbRIjwf3SDics+Oj8JVgm8OD
	 ni90NHejNjBOTa51A+reb7rCNyc/4Lx5cgSbSeps9eNeHYj/8IMOVwZ6t1VqbCFYeU
	 c/cKA30WUS016DLWHkU1ctyI28rhef6zPLtNPETvTY/tuZClh+qbft/3ltRMCc1ccj
	 ti/5o46qveQ7A==
Date: Fri, 12 Jun 2026 10:17:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <aiuyoy8Kmr9yU4GM@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
X-Rspamd-Queue-Id: 90FDC1C0002
X-Rspam-User: 
X-Stat-Signature: 6w1auegyyfxh9da5un4e47btyys8c1gi
X-Rspamd-Server: rspam09
X-HE-Tag: 1781248683-970649
X-HE-Meta: U2FsdGVkX198yLq4rtO0Az3hV2zUgULnlSJEyoZvNBF+qqzBA06IWS7NUMgnCFNLawMOqT3cQfu2W6w2VBRq7e2w7gHgUjD5q2xsX7x6WnILKOOWPUx99tJNqVXmUiqd454z9t2XuGZPRoNTqBy4NnIaWtE1JImhbRkhhWvQohGJR6MLrVuS8GdtdfTdnhMsvchVfQjYu93X6hw9bzBzi6IMNBSSOoxD1bUZ8cKwCI7EY7INozGQI3wnAiiKHK5s4aC7WaqRs1bSq1ibUrJHz97MA0x73FUtbUxCRISGdbriU6u1JiV1a6zxgUXthDam/EhqHvqmyGP7qbgrsqmPKi/lDQJoFeEcEAJLiAc3OX/MzMqUgQLdCSsk0s60eiloGLK4rL+/iJL/n9CHq1tlYxdcxCYR6PXVSA2iNL6v45gqhg2B8LN73fQD3PqXR/I/7UmN74jeanAk1iRVIm99nwoVjBsHuoUGkZJADyz9TafmcXrD2iAmWEvTlD9Kw8MJ+70cWJO9p+URnOAkNu/upXogstGrM1JZ3ujCYIBSUjImnKgTUQ49yGM8TwICX1kfG8biSFDd3a1AuVM0zxPOUvOgQHdeZCEXSVTktgFWEwKNbqI+HZ+h+JBlTioRWQTwc0YfEFBkcaVIZ2PKRgsAd4NmRfdT7z6+1HLI/HSGCdZ95yrg7B5hBRtohewrQqvEGSheuSPkiTHJlzcoBB/wWIxOVel7uLCtGBKQMlczsmpljiFloJXgtjUxffdnlDOgjg4D3ZeXI/e9MVpSPpDSehp3RWuDfu+o5qgyhaTMJuRMa7QO4rwJHuiCEfShNnl64vOIm/EpJJ7rbDCR4bZaNhU0QMRdvfHezEfBdcx2y152QtqK+M4LyngrgiaoImjXWPBx7gBo/PVu373a5NsN2AYkinH5OWPDkT6jzwwJwvbn/VsNaE6XmQBuAEPZgBg/sjUQuMklwWt3Z5UkrUK
 NPH0ARXf
 JzOqYbC85uK6xK9YQ+tJFKvQT+XLhJrxomagOUTPtyYnsuXVRUuUUMt9O8RykinxbXMeioOAqGMFfbrjXTYEZZMd5ZRnaoUhmmnNxVLcsH//CW0lJzcBIsWYqamWXQcFPcDM2khvrL+eC1irOt9kZEFN+k01hR24o+IEWL3QNiKnJo7ZMVpnuL/SOVA+RsmYQ3cVgcqQg4jIYqdFV6i4Cf0xXSJGwN/Em5UoMzVD1+E7FarzLAWq+0kimmBJRZO+58hRjP0NtIwJSIchB/mT9HoRQF5NXAD5zl0T8Huf9EmmDKPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 01:54:13PM +0000, Brendan Jackman wrote:
> On Thu Jun 11, 2026 at 1:01 PM UTC, =?UTF-8?q?Adrian=20Barna=C5=9B?= wrote:
> > Strip the read-only attribute from the selected memory range when
> > restoring the linear map after an execmem cache clean.
> >
> > An execmem cache clean is performed when a cache block becomes empty
> > after unloading a module. When making the memory valid again, the linear
> > memory alias must also have its read-only attribute cleared.
> >
> > Without this change, the linear memory alias remains read-only even
> > after the execmem cache block itself is freed, which prevents subsequent
> > allocations from writing to that memory.
> >
> > Signed-off-by: Adrian Barnaś <abarnas@google.com>
> > ---
> >  arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> > index 88720bbba892..eaefdf90b0d5 100644
> > --- a/arch/arm64/mm/pageattr.c
> > +++ b/arch/arm64/mm/pageattr.c
> > @@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
> >  					__pgprot(PTE_PXN));
> >  }
> >  
> > +static int set_memory_default(unsigned long addr, int numpages)
> > +{
> > +	return __change_memory_common(addr, PAGE_SIZE * numpages,
> > +				      __pgprot(PTE_VALID),
> > +				      __pgprot(PTE_RDONLY));
> > +}
> > +
> >  int set_memory_valid(unsigned long addr, int numpages, int enable)
> >  {
> >  	if (enable)
> > @@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
> >  	if (!can_set_direct_map())
> >  		return 0;
> >  
> > -	return set_memory_valid(addr, nr, valid);
> > +	/*
> > +	 * Execmem cache uses this function to reset permissions on linear mapping
> > +	 * when freeing unused cache block. On x86 it makes memory RW which is
> > +	 * desirable. 
> 
> Hm, maybe desirable for execmem but that doesn't really mean the x86
> behaviour is correct. Maybe it makes more sense to change the x86
> to align with the arm64 behaviour here?
> 
> BTW we should probably document this API a little bit, I never thought
> abut what "valid" actually means until now. I had thought of it as "I
> can access this memory" but that's an unclear concept and now I realise
> "valid" is a technical concept in Arm that's confusing. And it's extra
> confusing if the kernel API uses "valid" to mean a _different_ thing.

I've got confused too and that's how set_direct_map_valid() got into x86
with a different semantics than on arm64. 

What execmem really needs is set_direct_map_default() variant that gets
nr_pages.

AFAIR, set_direct_map_default() has a single 'page' parameter because it
was added to reset permissions for the direct map alias for vmalloc()'ed
pages before there was VMALLOC_HUGE and each page had to be reset
independently anyway.

Maybe it's time to add nr_pages to set_direct_map_valid().
 
> Also, shouldn't execmem be using set_memory_default_noflush() before
> freeing anyway? I guess that shoudl even be documented as "if you change
> anything you need to call this before you free the page".

It does on x86 because there set_direct_map_valid() is the same as
set_direct_map_default().
 
> > On ARM64 set_memory_valid() just change valid bit which
> > +	 * leave direct mapping read-only so use set_memory_default instead.
> > +	 */
> > +
> > +	return valid ? set_memory_default(addr, nr) :
> > +		       set_memory_valid(addr, nr, false);
> >  }
> >  
> >  #ifdef CONFIG_DEBUG_PAGEALLOC
> 
> 

-- 
Sincerely yours,
Mike.

