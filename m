Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04323C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 07:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13826B00DA; Mon,  6 Jul 2026 03:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB1A6B00DB; Mon,  6 Jul 2026 03:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D031F6B00E6; Mon,  6 Jul 2026 03:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A7A076B00DA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:46:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 220EAC1A25
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:46:02 +0000 (UTC)
X-FDA: 84957568164.02.B41DA9B
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B463180004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:45:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dTdvR0Ty;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783323960;
	b=vN0ooZ/r442yqimxsREEDzwzeOZyvkZQxN4gH9dFlseHlRszH1rYQUQtyT17oNr4XhCOeZ
	MKsIompi8FGVHB84bLFzYoCmwL6Y/3V2T94Ap+tDyt3ri/5kzht/3qPsHxnUYLAFMBXUs8
	6ZwJH3qee/S1HJn1ouHHBs/9x0AlYc0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dTdvR0Ty;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783323960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z6wV3oJTOVm+St0XwYa3g9dR2I+dcMz7cR6ea5u0LE=;
	b=qWMxQQhX2A9CL7s8hPvJd9AQhzhWXyT6VX+ytSl/euEH4wMJg4rkmGCYm9uaNGTXaLe1dD
	PYsi7vsRK+5BoETKNXbsWRQxn5uSkSJRaVC8pl5V8nGtmsfZUJgO/MrJ+vpKU9q7xWJ21T
	XOBrYoc8KqMLYlHeBuorhZzsGWrTHAQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783323951; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/z6wV3oJTOVm+St0XwYa3g9dR2I+dcMz7cR6ea5u0LE=;
 b=dTdvR0TyV0l782HOvbS5Rxs5l31ff73b+/mteCRsgiZLLBmDc1UwDTDHhLg7TF37RmFFbT
 A3p7OXLNnuPBVMfiytFMH0hv1Hg+9cDUl8Xjf3J5SLIDyQYU6TV5Brsl/VyGwRpWZz5d7V
 a5GO4buKYG6P2lwBOY0/HEs14IenDMx4VQjkBEkFuESxN4Tl09wwz9vLCFGeSfAWwZk2Yw
 0rDtGl2+eaCkgVF1uJmJla0D9avSWrdAE7aZ8MBuOjss6cwjN+W16t4RVM5GiS6Q/R6KkF
 ournOd4jO7u8YaUq/H/y/FYZaXYkFL0d9lbSOHgLx6ZZElI0WBfp7WYHx//xZg==
Subject: Re: [PATCH v5 4/8] mm: add a template-based fast path for zone-device page init
Date: Mon,  6 Jul 2026 15:45:27 +0800
To: <rppt@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
In-Reply-To: <akfB6Qe-jKDEMUxz@kernel.org>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a4b5d2d+23b819+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260706074527.23978-1-lizhe.67@bytedance.com>
References: <akfB6Qe-jKDEMUxz@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B463180004
X-Stat-Signature: 7ik64u6gyw3zmd8ig3qcuhkrbr3y3sg6
X-HE-Tag: 1783323957-638167
X-HE-Meta: U2FsdGVkX1+y+YWp7t+E7WCLKlx/4D9bNyZuy2aKvrmM3EhRzngj4aTihluljhmgyuk9aJSBgevV06zH/kk5Dmxlam5ntWo38jxkXbyhgtjbn+MtpKFmsb2A5ScDAeB7hdN/EOZqN8sWsrKG0rvtzjSjN25n1UQ3yP9rfwZWklfciY6Eq9Ixn7S24osjzqmdrEmL4PPCSoqS9RJIvvRRkbHe6aykhwW0+ioDYZQIVzgjYhoys3xiFzAb1BMq2dMnPLbmoJwsbL2qyhEP7bRpraIF56KGgu4xg8YnVjC6o7jMDdy+pmTj2DuSWZuGbeH9QQ3UnlYuzm0Cuz1FavwFOnI+7fA1k6S4ycDRV8Xo0Gt6oIr/LzYQOJfO4Q9i7mJysTo0Z8TIG0Ts377vNsoYlrMr1NtFVCry/aGjFOHgZpEjjZW1S9+Ix6KhTfOFV+DTQDmpWnCBdSnI48rg+QqJ6W+1X7GM2oQVl0u76R5og3ngbFWB0/PY90EETopgSurb/aH+S9L7CRCoQgSGz2hv2pq0mrAaIVq1rAEXS5lPXgx9yXy2tT9h3xCp5f6HGZ/rdOmyNkjIKbpVVnIN0LGDFwVnIM5023NhnfgtvdmfhlbgnystJspXNhJiEYCHJ55l1sfaGEco2OvsAoC6xrHDizRHNsUUz0MpDvhGGym95gNtxv6zvMLewDuXwLvQe+S2nQvK02LC0M2A0aH+51itvbd5l9ew/cYpoHMV2ACAw2K6bEh+ShzCVet4yfM/jkq/tObobkmBJnE2ipPZ4HSk+EgDq1wyg9cI9vVmjY5fmYDjaymqEo04GU7p7ezu0FePDL/1Atv1N/QegBtg5XIRlTzNvon84BcJ0jk6pH5BO5Fs5g4kIwJfUEf/kEyslyq93jVCvtz7dzdVYCvchECyYdbFBVATq9DDGSvh0FvvtEHw3f2IUayU1JrbDfW8mLBtDD/nD6AeccrnfNISwjv
 Ivv4i4Aa
 Rfgm1o7dPhr4vX1FR3ZcmMAypQeTXQjqUSG4K9oy8uFf4AQ6bSVbJOk/D80f1SaxtZKn++T0zc+CAQjff6f2eff//UHTPElS+VX48ACbxWR0psRR4jKsm8MKO6zVHE5PKC4ml/n4+S7AFa2y7FfUmeQ+xsUb/VvARneINURqIUU+0srCExmI/u/B0bz2VR3x16vJD3qxG3Z8dv0jFMbvRC2lHYEZzJla8ykcGwpiSjYfCbd2Ni8VgTMuWxlbfYZs6k4j8YKHrnWQqXOTuPmIjbrzdPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 17:06:33 +0300, rppt@kernel.org wrote:

> On Wed, Jul 01, 2026 at 05:05:49PM +0800, Li Zhe wrote:
> > memmap_init_zone_device() repeats nearly identical head-page
> > initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
> > template through the existing slow path, refresh the PFN-dependent
> > fields in that template before each copy, and memcpy it into each
> > destination page.
> >
> > This reduces the average rebind time from 244.28 ms to 217.19 ms, or
> > about 11%.
> >
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  mm/mm_init.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 74 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 4c7fad440c2a..cc8417951467 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1066,6 +1066,50 @@ static void __ref zone_device_page_init_slow(struct page *page,
> >  		set_page_count(page, 0);
> >  }
> >
> > +static inline bool zone_device_page_init_optimization_enabled(void)
> > +{
> > +	/*
> > +	 * The template fast path copies a preinitialized struct page image.
> > +	 * Skip it when the page_ref_set tracepoint is enabled.
> > +	 */
> > +	return !page_ref_tracepoint_active(page_ref_set);
> > +}
> > +
> > +static inline void zone_device_template_page_init(struct page *template,
> > +						  struct page *src)
> > +{
> > +	memcpy(template, src, sizeof(*template));
> > +}
> > +
> > +/*
> > + * 'template' is a reusable page prototype rather than a strictly immutable
> > + * object. Most ZONE_DEVICE fields stay constant across the pages covered by
> > + * the current template, but section bits and page->virtual may still depend
> > + * on the PFN. Refresh those PFN-dependent fields in the template before
> > + * copying it into @page.
> > + */
> > +static inline void zone_device_page_update_template(struct page *template,
> > +		unsigned long pfn)
> > +{
> > +	set_page_section_from_pfn(template, pfn);
> > +#ifdef WANT_PAGE_VIRTUAL
> > +	if (!is_highmem_idx(ZONE_DEVICE))
> > +		set_page_address(template, __va(pfn << PAGE_SHIFT));
> > +#endif
> > +}
> > +
> > +static void zone_device_page_init_from_template(struct page *page,
> > +		unsigned long pfn, struct page *template)
> > +{
> > +	/*
> > +	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
> > +	 * page. Update the PFN-dependent fields in place before copying it
> > +	 * to the destination page.
> > +	 */
> > +	zone_device_page_update_template(template, pfn);
> > +	memcpy(page, template, sizeof(*page));
> > +}
> > +
> 
> The whole bunch of template functions look like it could be useful for
> initialization of the non-zone-device struct pages as well.
> 
> As I mentioned previously, it's interesting to see if this approach speeds
> up normal memory map initialization as well. If if does could have a single
> set of the template functions.

Thanks for the suggestion. I agree this is worth exploring.

For this series, I would prefer to keep the scope limited to the
ZONE_DEVICE initialization path and get that part settled first.

After this series is settled, I plan to look into whether a similar
template-based approach can also help normal page initialization. If it
shows a real benefit there as well, I can follow up with a separate
series.

Thanks,
Zhe

