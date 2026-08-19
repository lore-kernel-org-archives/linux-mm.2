Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 113ADC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D2F6B008C; Wed, 19 Aug 2026 03:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375386B009D; Wed, 19 Aug 2026 03:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1C96B00A3; Wed, 19 Aug 2026 03:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0760F6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:01:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 807F8C0490
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:01:43 +0000 (UTC)
X-FDA: 85117123686.26.24518C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9BBE120002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:01:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W218OjmE;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aMKxJGzD04KmpYdtuo6wR1wjBXa3j2PKTFpPFdjXzYU=;
	b=2GWCtEqKAksbPpXzQMXa3DQiiDe0ES2VaJKflxtK2dY+wv/+xYRubd9+x5xkgO3/BcQALD
	6SxOHc5V+YbXmj/VlzuvJDYrsCRaAqq+3w12P88EySjl9RoBCXmBaJ9RNcTispDxInJryI
	po8T64D8lZrW7zaBVcpX8MXaLdLs0bk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W218OjmE;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122901;
	b=YeNB9K7Ek/Pe2FRpPqLXUNBGaWpfxJFbBlCiqg0YC1g7C7W6yJTJ+AuoHXnMhyCiRVWIz+
	ss5rK1Q4YDM5M7IvNBBA3fQQaFcdIkyCyOYzUwp2lL8apI9lWJVr45TWdPEFo3J3mL8p0g
	sc5+wMUSB2n3WfJB1u27MSTyEJymRm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E558B40E0B;
	Wed, 19 Aug 2026 07:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E0F1F000E9;
	Wed, 19 Aug 2026 07:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787122900;
	bh=aMKxJGzD04KmpYdtuo6wR1wjBXa3j2PKTFpPFdjXzYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W218OjmEyHpxk8/viVdeC99qw0slMQEIeb88kkfoCArZxB5b+ptrrTJCAevq6VxDC
	 vMLWsCTCZofQBaxR8oOPqWS3kHD49USp31sbZl8DRPCFt4KACVCCQrNyM/PgNyaQHR
	 VkV0HOObXqdXGCJvNJhTxaqj9fmO35W5uT1jdRtJNLUOb/HjegZxblTMNGIV/GVRRM
	 flhucOwsPBVMpfnwxRKIG1ToXGaPjBMWqxwbx+olsHHxa7QcV4g0KWxIkN0N9mv8Xz
	 L8AUvX3FOqiw4smqbYXS27a0Eeumx4rnsMmynElmR0J9GQkX0rxY+csbE6hJYTSs4X
	 O/LT5KmkF12xg==
Date: Wed, 19 Aug 2026 10:01:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP
 friendly
Message-ID: <aoVUxU8NJuxP21tk@kernel.org>
References: <20260816-execmem-set-vm-perms-v0-2-v1-0-90944a3ad43f@kernel.org>
 <20260816-execmem-set-vm-perms-v0-2-v1-4-90944a3ad43f@kernel.org>
 <DKR7R0BECQXX.2FCNF36EFETS8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKR7R0BECQXX.2FCNF36EFETS8@linux.dev>
X-Stat-Signature: c14gtt6rbt6t7r9inweesd5nq5xqwq4o
X-Rspamd-Queue-Id: C9BBE120002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787122901-378900
X-HE-Meta: U2FsdGVkX19pUyFfViJuwoJoJOu16CXomAkbL7CKCFks9oSRQOQHZD6if8m/pogaq0Uc4ohxeWUq9QBEX+DqlFRBixOC9IqkTe+LQ8iw53jWWkDvKztXPW2VpshcFAysgH8eH3umA+WC9etuA4/p3bmvXuKHHLVGg/8AZsYuCV1bpD+ikxWVIEDTqLawx33MXepri1slnPue0vFjPM7UqTs43PDClKLlRucOLkeMD/vMXFU/Sl1n9bNVWu8iCpEE+mAbfoRNV65ycMgNwNTxdz+0KYMnOeHT1hRqyA9vGD8H5ToTKAhjdDuBAbBYwI8BaGUpz71QMtxkyKxPDtUfJKPpcUAOYVYjIIWso+SCFQVDhemLVV/YSnEk2s7v/RXRjopj+0KUZ8VqQ0Mz0LtX9gPxQa6ayQGJz5aHl20nHf+vikrQs03TTWOJUumaX3Y9MUYpNyxaRXsYLYObgBiLKrYN6+I4mAtKHeWXwsiHKw8gOY8CsaNbfAaRNuuaQFcnccmYycC7xkBfhSfUSNcX6sg8jYeK9lwTViDRO1bTt3YVO7IU5K9dI8+dZTOvGttWd1AksNTVWnr/e38V9HMiQ4ZMALi/0qrB6Fjv4iZ6H6tiU1tJnDtjDiNsOBgW7KLjCKfJ1E1j6Bu8gTiBybxEBLYPgGCUtn37VsETwpHzim66m2gKbjrSW987j58baBo70LFDVhF6XRWxcYRR5bI7ssl7w2sSZn9yRSlO+mIW2Aqm0pIoKZntvCGan1/A0Qnsgh6t9IsfCD0j4U1hjCEvNFOjUWYRqJ1pVd8lrNn4EGQKa5K/R/BFjfRi47qeywiI9zCM0B17WI5F/qejz9E2W1kOpLevA8OWEvEkogyQs7yL3p816Ni7R4Bxl0seI21MnUI5iblswhrVNwPhX5CpNivBLPRg1aq5Q/Bc19BNcpgSsP2klke6YFdyw070vmArc9Cip7hvbgwogLLdpRt
 62PNWNI6
 J1Lnur/uIQnIn3RCrg3PPck1gjz16wXOIdqjcIcH52lsXPVAPuZn+OjQOWMHa2n0shWNS0nhxFK6WBnV9Tp3AninGaQh3MdTYUFdDSJR71fOhH2PlCucfFc6cFiECT85SMpPNsEIpxmA0E4QzWrEnrK70jzPfyjCUlhmtYYxC2qhrNSNpDvF8otcFnhQKC9V9k3PPteg90PAS2AuO7w8rqT76FY6KTibGrBjbQXCHWSl/7bgKkDAKSM++EBkpYJttzKzt1FnytxG8SwzlXqR+O2gbAmQIKVbxb2lsumb006q8IwIQt4pzVKfyV452d69jVZTZhbEoONyD99E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:21:41PM +0200, Brendan Jackman wrote:
> On Sun Aug 16, 2026 at 12:59 PM CEST, Mike Rapoport (Microsoft) wrote:
> > set_area_direct_map() always updates direct map alias permissions in
> > single page increments.
> >
> > For HUGE_VMAP areas it's suboptimal. Not only the loop in
> > set_area_direct_map() needlessly has more iterations (e.g times 512 on
> > x86), but it also causes fragmentation of the direct map that could be
> > avoided for the HUGE_VMAP areas populated with large pages.
> >
> > All pages in an area are always of the same order: either same-order
> > large pages when VM_ALLOW_HUGE_VMAP is set and all huge pages were
> > successfully allocated, or order-0 page when VM_ALLOW_HUGE_VMAP is
> > cleared or when huge pages allocation fails and fallback path is taken.
> >
> > Instead of updating the direct map permissions for every order-0 page in
> > an area, use the area's page_order as the loop increment and update the
> > large pages in one call to set_direct_map_{invalid,default}_noflush().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/vmalloc.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index fc7993db4152..11170d1ee5be 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3361,12 +3361,15 @@ static inline void set_area_direct_map(const struct vm_struct *area,
> >  				       int (*set_direct_map)(struct page *page,
> >  							     unsigned int nr))
> >  {
> > -	unsigned long i;
> > +	unsigned int nr = (1U << vm_area_page_order(area));
> > +
> > +	for (unsigned long i = 0; i < area->nr_pages; i += nr) {
> > +		if (page_address(area->pages[i])) {
> > +			int err = set_direct_map(area->pages[i], nr);
> >  
> > -	/* HUGE_VMALLOC passes small pages to set_direct_map */
> > -	for (i = 0; i < area->nr_pages; i++)
> > -		if (page_address(area->pages[i]))
> > -			set_direct_map(area->pages[i], 1);
> > +			WARN_ON_ONCE(err);
> 
> Nit: Maybe worth a comment on why this is expected to always succeed?
> I.e. I think we are assuming the only failure mode is allocation but 
> because we know vm_area_page_order() there shouldn't be any allocation?

The assumption we relying on is more involved, but yeah, I can add a
comment. 

-- 
Sincerely yours,
Mike.

