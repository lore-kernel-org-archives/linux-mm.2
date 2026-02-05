Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982F4EC1E84
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4B76B00AD; Thu,  5 Feb 2026 04:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B576B00AE; Thu,  5 Feb 2026 04:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88296B00AF; Thu,  5 Feb 2026 04:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A48276B00AD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:39:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5452A1B26E9
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:39:59 +0000 (UTC)
X-FDA: 84409906518.27.7DE2BCB
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 140294000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:39:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=FPC+Ibwa;
	spf=pass (imf07.hostedemail.com: domain of "prvs=48905c591=epetron@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=48905c591=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770284397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwoH02zUpW5B4/exjaevJu1OcPGS6ZQCVZlCuGn50SI=;
	b=q9rcPfxmMZxkJY/1PU/nlnRS0w6VfRTIBcbbS8Z9tIr58W0BGrmBeQy4oOA3cou0W/5Lip
	z42uXnHRqPStwFKrCdA8sJaFqmLICFV5ibyvj3AXX6ymHu4l2hipb0L5yxNtqeRs2Bfq0/
	CEVHDdxavD5Eiw80LXM7LBJvJgSr00c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=FPC+Ibwa;
	spf=pass (imf07.hostedemail.com: domain of "prvs=48905c591=epetron@amazon.de" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=48905c591=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770284397; a=rsa-sha256;
	cv=none;
	b=GF9C0DUhYzgAANdinBlnqJk2QR0o9iMjjlWLtapL5E6MM+BwSYIwBTCNcQp+4Vl7VIX2cL
	We1A4SlQiL/+f6pP44mBVBZD1I+FN7HIwqBMdXZTyNQD0gcv1AP14hYmmcXIAXaMBPeRTA
	Jgv9tERGNo61AjUs9XB5Kn18mS0ACTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1770284397; x=1801820397;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UwoH02zUpW5B4/exjaevJu1OcPGS6ZQCVZlCuGn50SI=;
  b=FPC+IbwaVumCB47cJnkWlEdRMbKf7eDOtp5J9sk4AEqx+wteMvSj4Xss
   sUqE2HJWvmEW1/cQDuJ/8QVHoafihfR34+0c113fSGRiGpU53lgkh0VaJ
   X+PR/PNygpgtwLd3gLNdpat2AwOTV9EguRnijS2Viwe+Yf7x3JaJeI8U/
   u1gc5avWCvWbJee1FxATj7MS80/ONTFZOmjChYVYdXigOd/HE0+b1rWQs
   l0bTC6dLOqT4bNOmriI3nqfC7FJhtWkv1X8007I41mE3Glh1r45wusPPS
   WRCoHSmvfn1g/8vXjAZoeZn7W0LRSLQ9zRLOLgUDSPSD5pFZg5jRXqDWl
   w==;
X-CSE-ConnectionGUID: +hwAB8vUR/iKlm+X9BTFLA==
X-CSE-MsgGUID: l9LCIWImQFyuo0Sm5j9zog==
X-IronPort-AV: E=Sophos;i="6.21,274,1763424000"; 
   d="scan'208";a="12411311"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 09:39:53 +0000
X-Delivered-To: linux-mm@kvack.org
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:9044]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.59.190:2525] with esmtp (Farcaster)
 id d0163fd9-f5d7-438c-b978-de77516db7d8; Thu, 5 Feb 2026 09:39:53 +0000 (UTC)
X-Farcaster-Flow-ID: d0163fd9-f5d7-438c-b978-de77516db7d8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 5 Feb 2026 09:39:53 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Thu, 5 Feb 2026
 09:39:51 +0000
Date: Thu, 5 Feb 2026 09:39:48 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav
	<pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>,
	<linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <nh-open-source@amazon.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <20260205093948.GA96044@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
References: <20251216084913.86342-1-epetron@amazon.de>
 <aYOToJvAUU0dmW94@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYOToJvAUU0dmW94@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D042UWB002.ant.amazon.com (10.13.139.175) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: fhrig98rpctsycb11toa8qpb914njnm4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 140294000A
X-HE-Tag: 1770284396-10844
X-HE-Meta: U2FsdGVkX1+h/aytv3AURGbsjifdfasp/09wHDiCadHXrVjz1sIeHbYSF7UC86PPKsUFsCjQ16Dqzid5ZvrCrtF0XVlL+b0qg5Nf/deZLngjgphnmb6lWjwIY5TAg0T3b0VgqBIGAENw7x8CKspAJ30QRGm0Voc7x3DEzo4mvBuehJOH0FDRw/H/5rdDj8arY9ByQ2n3T7KoLfP2RQ4W9XebMVG0zNB4bFcGV1XeqqbsRmh/tkXfLANmtz9+1V0D61jD0Z9rgA7P1yl5renMEUrnJZ7B4udEinr730Mq/N6uaLtZfJSA4HL5AzKDVylgFeFOjcxAzug/XbRC4/zyxEsgtOiajzpcJ/oGPD8IbJA4J0O8sGZRzzbPxd3GgXSnXXdVMrPWWrAG7souxe879o6ASBPf2cgX7Srvw1H9hhI7fyGU/KLM8fSNFmMZScNVzkRqHT+jegWi9+/bNemzHDabYmiw4s5AjrkGzaIQwRMDfbUCJ4scWcgvkLMmtA4tgOxwztPDjikjvjPo2eNdgwj0TtPJVgNkkhh3VB8Rn/krr9gaT/xKq+3oCLzMWyQbQY0Sj5SkAI0ytQWkn3QnVakMf2I/rbUz7NUvQ8hFa83u3o/KRNkVbAf69siIqItqk093gZeyQCjsVzCCfNPKCMuF6YxkubOs96xSWLyByqxtXmshW0Z0IUG4Ylt/IsmsSqzv8Mf7Pxdf6bLdblPM0uhwFYbQfq0RJF7cDgD0q0qhqqxKmp/+DrxKMspUSICIzdC55VcPQ+yuh7pINMh2vNwcQjlg44CEvaZJDTMpTULKIQ+NjMd3qC7jUFkkB4mefO8NmPjLofvAAU2Om/ADIFxuXEnBITptY3aYA4svfa1V3LWvzDEJBO6R1lYNZnglYIo1fIvSAYvCC5zpLiNVVxghgkCIFNl1WUlD5fYcH4xbeWYjN7+fLEEzy89rVScgLNdAwr6Dczy8heoS/Ra
 Az46b6T8
 ID1c9qaYPPjFMAtrFcpTgZOPg3EEIOK1LAAZhuKV/3fg+48ppyGNOuWyWPKhGWehwIHdrU6X+ozu2D4axg06Kj1uGoMuVSLfD1Qk9JAB0lzXRA+3bd7MFVlMfT6bmOF+Nqu+sVWxDQicg5X3oduhKfWW1JbFy2nDMUAgU+xJxlya8t77VrvtKEWtENrYyqAVzT1a1Z3N2Qu/Y2Ku1SgM/x4ql13MTvbIbvmqpccyzu5ZpZtXIuPs7zkiAD4IAp/HU8ayfdKDIqVEnAL9oNwsdnk5d5oJSaFBOIZVmaQmLqkZQKQtI1OkQfE0uZfp2PvksImk9rT4zGzwfdXzjvyULRVOg1QvXqqyAJiH7hPUgNhcdEFc5iiOb/SkpS0y+BmQUZoMvN5KylLeGHCzOXHtx0w7WN3GvZigD8nvtcwyF+RlPMprTkJtVPBZEk1n0hARc+WuXSt5qvCpiPFGuxDPdq06ouKuBjmm0D61j11/X4o6Ue4bRwnVIdl0Imh1khoaeC+hUOTUAtQBXbnBYxWE4O0kkwGbW7zhWrqiMkOtzoTInkHgyjyGQqvRVFTW6FPyliwaN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 08:44:48PM +0200 Mike Rapoport wrote:
> Hi Evangelos,
> 
> Are you planning to send a v2?
> 
> On Tue, Dec 16, 2025 at 08:49:12AM +0000, Evangelos Petrongonas wrote:

Hi Mike,
I am leaving soon for some AFK time, therefore I don't believe I will
post a v2 anytime before the beginning of March. Feel free (you or
anyone else) to send a patch. If a patch is sent until then I am happy,
to test it when I am back.

> > When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> > initialization is deferred to parallel kthreads that run later
> > in the boot process.
> > 
> > During KHO restoration, `deserialize_bitmap()` writes metadata for
> > each preserved memory region. However, if the struct page has not been
> > initialized, this write targets uninitialized memory, potentially
> > leading to errors like:
> > ```
> > BUG: unable to handle page fault for address: ...
> > ```
> > 
> > Fix this by introducing `kho_get_preserved_page()`,  which ensures
> > all struct pages in a preserved region are initialized by calling
> > `init_deferred_page()` which is a no-op when deferred init is disabled
> > or when the struct page is already initialized.
> > 
> > Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO")
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > ---
> > ### Notes
> > @Jason, this patch should act as a temporary fix to make KHO play nice
> > with deferred struct page init until you post your ideas about splitting
> > "Physical Reservation" from "Metadata Restoration".
> > 
> > ### Testing
> > In order to test the fix, I modified the KHO selftest, to allocate more
> > memory and do so from higher memory to trigger the incompatibility. The
> > branch with those changes can be found in:
> > https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> > 
> > In future patches, we might want to enhance the selftest to cover
> > this case as well. However, properly adopting the test for this
> > is much more work than the actual fix, therefore it can be deferred to a
> > follow-up series.
> > 
> > In addition attempting to run the selftest for arm (without my changes)
> > fails with:
> > ```
> > ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
> > Bail out! ERROR:target/arm/internals.h:767:regime_is_user: code should not be reached
> > ./tools/testing/selftests/kho/vmtest.sh: line 113: 61609 Aborted
> > ```
> > I have not looked it up further, but can also do so as part of a
> > selftest follow-up.
> > 
> >  kernel/liveupdate/Kconfig          |  2 --
> >  kernel/liveupdate/kexec_handover.c | 19 ++++++++++++++++++-
> >  2 files changed, 18 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index d2aeaf13c3ac..9394a608f939 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -1,12 +1,10 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  
> >  menu "Live Update and Kexec HandOver"
> > -	depends on !DEFERRED_STRUCT_PAGE_INIT
> >  
> >  config KEXEC_HANDOVER
> >  	bool "kexec handover"
> >  	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
> > -	depends on !DEFERRED_STRUCT_PAGE_INIT
> >  	select MEMBLOCK_KHO_SCRATCH
> >  	select KEXEC_FILE
> >  	select LIBFDT
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 9dc51fab604f..78cfe71e6107 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -439,6 +439,23 @@ static int kho_mem_serialize(struct kho_out *kho_out)
> >  	return err;
> >  }
> >  
> > +/*
> > + * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory
> > + * regions may not be initialized yet at the time KHO deserializes preserved
> > + * memory. This function ensures all struct pages in the region are initialized.
> > + */
> > +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> > +						  unsigned int order)
> > +{
> > +	unsigned long pfn = PHYS_PFN(phys);
> > +	int nid = early_pfn_to_nid(pfn);
> > +
> > +	for (int i = 0; i < (1 << order); i++)
> > +		init_deferred_page(pfn + i, nid);
> > +
> > +	return pfn_to_page(pfn);
> > +}
> > +
> >  static void __init deserialize_bitmap(unsigned int order,
> >  				      struct khoser_mem_bitmap_ptr *elm)
> >  {
> > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
> >  		int sz = 1 << (order + PAGE_SHIFT);
> >  		phys_addr_t phys =
> >  			elm->phys_start + (bit << (order + PAGE_SHIFT));
> > -		struct page *page = phys_to_page(phys);
> > +		struct page *page = kho_get_preserved_page(phys, order);
> >  		union kho_page_info info;
> >  
> >  		memblock_reserve(phys, sz);
> > -- 
> > 2.43.0
> > 
> > 
> > 
> > 
> > Amazon Web Services Development Center Germany GmbH
> > Tamara-Danz-Str. 13
> > 10243 Berlin
> > Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> > Sitz: Berlin
> > Ust-ID: DE 365 538 597
> > 
> 
> -- 
> Sincerely yours,
> Mike.

--
Kind Regards,
Evangelos




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


