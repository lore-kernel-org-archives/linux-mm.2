Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065D9CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904516B0088; Wed, 24 Jun 2026 21:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4F96B008A; Wed, 24 Jun 2026 21:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D1C6B0092; Wed, 24 Jun 2026 21:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 494126B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:10:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89FD11A04FC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:10:09 +0000 (UTC)
X-FDA: 84916653738.23.B5003CC
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4114AC0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:10:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cNz23Aaz;
	spf=pass (imf22.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782349807;
	b=ZHJs7QHUvtgnbHWPu3/23zeVhHo14XgdnRUTmfunE6WyLn2KllF6hVAYdApuVfsh5WXh5x
	hYSLd2c4QzQk1+AGR4Ln/Z7czwAp/nTFdEhWnGORM6fjqMHkJs2bMUTDP6xJHRJYL3Kz3x
	lbWi7bBpgP9lSBfY/19+kVAeapHfkLs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782349807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdL5ky5QslHZZ1UUPV0liQfja1fdH+v7qo0MRXJymE8=;
	b=aCXkpDjfKqhbJM/S4MeNL/1FAknZN4K7wPfHoTTmufr0Adqr5H7iGPzjXd2nZUyI9D0B4H
	Xzx5CvxmeF9tu+gJx2S5Eswioo7a/EORdu7pcSB5K6/765+Z9+4NRV/f9fi/rZYdsPs79G
	cuYQJma9xunw3xW28x5Ykn1oiBPAuko=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=cNz23Aaz;
	spf=pass (imf22.hostedemail.com: domain of shyamsaini@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=shyamsaini@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1152)
	id C240020B7166; Wed, 24 Jun 2026 18:09:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C240020B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1782349799;
	bh=fdL5ky5QslHZZ1UUPV0liQfja1fdH+v7qo0MRXJymE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cNz23AazWeTVcCK/VsdMTXHj0/vMhFYqvCWcM2jNt78aW2J9c7lXuC4YIhd8tytmN
	 OCTt1p2w9BxaENZCnC8EfPoLQXJvTbemLU9Tl1t2Ouxg+4RS9z/gvOIkhvHSQUqOD1
	 ECeQ2FiSD9Pe1XWZXxMT9Co+YIM6HeizhfW7BIlA=
Date: Wed, 24 Jun 2026 18:09:59 -0700
From: Shyam Saini <shyamsaini@linux.microsoft.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, tgopinath@linux.microsoft.com,
	bboscaccy@linux.microsoft.com, kees@kernel.org, tony.luck@intel.com,
	gpiccoli@igalia.com, bp@alien8.de, peterz@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, enelsonmoore@gmail.com, kuba@kernel.org,
	lirongqing@baidu.com, ebiggers@kernel.org
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <ajx/51eB91fX3e3n@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260619062331.348789-1-shyamsaini@linux.microsoft.com>
 <3e206be0-3ef4-468f-b7e7-7bc03848b0d0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e206be0-3ef4-468f-b7e7-7bc03848b0d0@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4114AC0009
X-Stat-Signature: 6trunjg74rnq7iuimghssxopsq93yhoj
X-HE-Tag: 1782349805-893873
X-HE-Meta: U2FsdGVkX19uIJzIWi92P1y7mQ0Dj6ouyVOKa55DFVWMzbloFVvhpt056DJZMCO/a2ZajwD1F4fTcn4X0e3Lec/OuoeR0zA+vj5wU4i5Mvv2SlR49Eh2mwss26pBtaLXmBofez6YOUB3yFX8vCF6flA64X8ixAJ6XxEumqHQdLz8EYYTdrFLWRt7QoQ+z5m5H8SRqSsKi/d5IQY7NvwdFCQXNPgtIGoAauAk7ETa64BkxIrF6eRKhXulr/c7PdBAK6u8At7Eg47fhps+OPw8rV5CE42FpZS4kdprD8UT3GKEglFNcpkNAhAyTzoo0hMtIg3Uk4GXS/uEyzR3idSkwTfApjuClVGy3Z6u4tR/F679oiBaEyyGYZ0OqiE+/jLSqvv0fd9NED7/cbxWSIfFpiVXVFgMm8bUsu2j1pXADydAB77JkVlX/d/g6Hmc3CKHkKZub3xJ1LjawBGUxCIWi0I0Q77A18/NkuRneekRn0dYFhbfbwUpXIWFStxAM6o9PzgGZFdKC8HkaCqWKi0FvrSQB3XEdPKlvzqaEhgFcsRMI6bMWpYSAhYCGI96mFlWyAK610JV8FEJJEq8KBvySb2uHT9+KsyW+VaV6VXyvkDHFO3QnRBQ5VXFPlSVdQzW9vWEkcUraQ/dx1EzD21CCnxnusLBMH5TXFDCJfAw2mV22Vl6W85zbROBMfvE6d1kyGrl5QWWo9FkRnHdSy7JZUfxp0l16VKNixB/4/8Y+150x0MYEFXbpt8BXX/PQIueGOlklN5gbY+64QhY6vTzNBIKwymsfuO/XVlWbVjo3xuXkaiPC1LSEC9ubhsQ+1DbtiPAbN6H2vhguxbbM3xQ8qyl9xXVufIJcPIgim0KKhpLmCmC32yLtW+j7l4mMOszveKuguEnxUzcAfWU0zxjnSEa37M1r6LdxW9vKqmDyx5Dzk2QB/DwMKwxLf6taIKWcdQw1C3dqrfbHEFbu5C
 wi6nAEhd
 pJKFsgYfXvkvEbEvGg0T/0hta1XfSSKWqkCpKz1YBYbhrg5j3PkPiZMeoIwmcZhoOOmJG8RjFxfE9mx39kZOdz+em+1RD4+caFT0wWqfcI9ZPpKH1aqA09YftFEPMKAuSfnFtznZZvbaVngB9+aSXohm+3sTVNJZvBmV4PbS4fRSdG1jE3ECI2Flqs5r5rabB0Kuq+B726ZWZnQF9jU7axkRSPIC/8ZzhE4whOW98phOCDba04BR8saKfaQgBRe7T9mWTdofQMbgY/Rejkwt2gT3tgYdooOgLnWn3/YpthHZ0icZOAYYPawq3QosMB8PcQl0TRHx/KYHWAEsD0jbVHzbQo0z57aAVhmsYODJJtDv/Uziemtv9fnW7wgN+KKFuXPJL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,


On 19 Jun 2026 11:35, Randy Dunlap wrote:
> Hi,
> 
> On 6/18/26 11:23 PM, Shyam Saini wrote:
> > reserve_mem relies on dynamic memory allocation, this limits the
> > usecase where memory is required to be preserved across the boots.
> > Eg: ramoops memory reservation on ACPI platforms
> > 
> > So add support to pass a pre-determined static address and reserve
> > memory at a specified location. This enables use case like ramoops
> > on ACPI platforms to reliably access ramoops region with previous
> > boot logs.
> > 
> > Also skip the parsing of <align> when static address is passed.
> > 
> > Example syntax for static address
> >  reserve_mem=4M@0x1E0000000:oops
> > 
> > Signed-off-by: Shyam Saini <shyamsaini@linux.microsoft.com>
> > ---
> > v1: https://lore.kernel.org/lkml/0eaf3be2-5121-48b7-aeed-196405c0a480@infradead.org/
> > v2: Fix code logic and incorporate Randy's suggestion
> 
> OK, you fixed a few typos.
> There are some bigger things that you seem to have ignored.

Thanks for calling this out. You are right that I did not address all
comments in v2.
My goal for v2 was to quickly fix the core logic issue and keep
discussion focused on the reserve_mem static address direction in this
RFC cycle. I should have stated that clearly.
 
> > ---
> >  .../admin-guide/kernel-parameters.txt         | 15 ++++++
> >  mm/memblock.c                                 | 47 +++++++++++++------
> >  2 files changed, 47 insertions(+), 15 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index b5493a7f8f228..7e0baca564b97 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -6563,6 +6563,21 @@ Kernel parameters
> >  
> >  			reserve_mem=12M:4096:oops ramoops.mem_name=oops
> >  
> > +	reserve_mem=	[RAM]
> 
> [RAM] means "RAM disk support is enabled."
> Is that the case here?  Is "reserve_mem=" only for use in case
> RAM disk support is enabled?
> 
> ISTM that you need a new designator instead of RAM...
> or overload the use of RAM by adding more info near the top of
> Documentation/admin-guide/kernel-parameters.txt.

will address them in future iterations
> 
> > +			Format: nn[KMG]:<@offset>:<label>
> > +			Reserve physical memory at predetermined location and label it with
> > +			a name that other subsystems can use to access it. This is typically
> > +			used for systems that do not wipe the RAM, and this command
> > +			line will try to reserve the same physical memory on
> > +			soft reboots. Note, it is guaranteed to be the same
> > +			location unless some other early allocation, e.g.: crashkernel=256M
> > +                        (without static address) is reserved or overlaps this region.
> > +
> > +			The format is size:offset:label for example, to request
> > +			4 megabytes for ramoops at 0x1E0000000:
> > +
> > +			reserve_mem=4M@0x1E0000000:oops ramoops.mem_name=oops
> > +
> >  	reservetop=	[X86-32,EARLY]
> >  			Format: nn[KMG]
> >  			Reserves a hole at the top of the kernel virtual
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 6349c48154f4b..c76cefa0a8a83 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2721,6 +2721,7 @@ static int __init reserve_mem(char *p)
> >  	char *name;
> >  	char *oldp;
> >  	int len;
> > +	bool addr_is_static = false;
> >  
> >  	if (!p)
> >  		goto err_param;
> > @@ -2736,19 +2737,27 @@ static int __init reserve_mem(char *p)
> >  	if (!size || p == oldp)
> >  		goto err_param;
> >  
> > -	if (*p != ':')
> > -		goto err_param;
> > +	/* parse the static memory address */
> > +	if (*p == '@') {
> > +		start = memparse(p+1, &p);
> > +		addr_is_static = true;
> > +	}
> >  
> > -	align = memparse(p+1, &p);
> >  	if (*p != ':')
> >  		goto err_param;
> >  
> > -	/*
> > -	 * memblock_phys_alloc() doesn't like a zero size align,
> > -	 * but it is OK for this command to have it.
> > -	 */
> > -	if (align < SMP_CACHE_BYTES)
> > -		align = SMP_CACHE_BYTES;
> > +	if (!addr_is_static) {
> > +		align = memparse(p+1, &p);
> > +		if (*p != ':')
> > +			goto err_param;
> > +
> > +		/*
> > +		 * memblock_phys_alloc() doesn't like a zero size align,
> > +		 * but it is OK for this command to have it.
> > +		 */
> > +		if (align < SMP_CACHE_BYTES)
> > +			align = SMP_CACHE_BYTES;
> > +	}
> >  
> >  	name = p + 1;
> >  	len = strlen(name);
> > @@ -2772,14 +2781,22 @@ static int __init reserve_mem(char *p)
> >  	}
> >  
> >  	/* Pick previous allocations up from KHO if available */
> > -	if (reserve_mem_kho_revive(name, size, align))
> > +	if (!addr_is_static && reserve_mem_kho_revive(name, size, align))
> >  		return 1;
> >  
> > -	/* TODO: Allocation must be outside of scratch region */
> > -	start = memblock_phys_alloc(size, align);
> > -	if (!start) {
> > -		pr_err("reserve_mem: memblock allocation failed\n");
> > -		return -ENOMEM;
> 
> 		return 1;
> 
> > +	if (addr_is_static) {
> > +		if (memblock_reserve(start, size)) {
> > +			pr_err("reserve_mem: memblock reservation failed\n");
> > +			return -ENOMEM;
> 
> 			return 1;
> 
> > +		}
> > +
> > +	} else {
> > +		/* TODO: Allocation must be outside of scratch region */
> > +		start = memblock_phys_alloc(size, align);
> > +		if (!start) {
> > +			pr_err("reserve_mem: memblock allocation failed\n");
> > +			return -ENOMEM;
> 
> 			return 1;
> 
> > +		}
> >  	}
> >  
> >  	reserved_mem_add(start, size, name);
> 
> 
> __setup() functions return 1 for "yes, I recognized this string/option
> and attempted to handle it" or 0 for "This string/option is meaningless."
> There is no "return -Eerror".
> If you need that, you could consider using early_param() [see
> <linux/init.h>].
> 
same for this concern, will address them in next iteration.

Thanks,
Shyam

