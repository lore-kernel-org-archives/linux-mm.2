Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A5DC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B390D6B008A; Fri, 11 Sep 2026 09:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B105B6B008C; Fri, 11 Sep 2026 09:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9696B009B; Fri, 11 Sep 2026 09:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71FE36B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:37:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5F4DA4307
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:37:26 +0000 (UTC)
X-FDA: 85201583292.29.636B4EE
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf18.hostedemail.com (Postfix) with ESMTP id C72C71C0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:37:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j cnyyqA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=sx6bioQk;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133845;
	b=0/Onu0q+FyTXW4c4B004d1o1cHJWQPxseCM5wytyE0Tk9WWSeN0u2/0Hz4nTYXCDEg3abT
	FmBFVH95qsB+pUfGZvkPEZo4rWZn3TJlNybZAtKeJS+2QcnaWVRmhHRDNUzqdad8potedk
	PAt5dxQQRF5yKS3uUhQdHVY7SX6LQ8I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="j cnyyqA";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=sx6bioQk;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUWzMrE2fH9LXIQGLIziweUqtGBoGNfxi6Eez8lfaUQ=;
	b=SOkNmbBHm5XnvJGFP1qXVlF+61WsC7gGg7O6S56EIxw/FrLzVhhRF/anZgmSq2lUNED7sN
	R7znbQWIo5Lr8B5hS9gDapYOVX/hVmGXiGfsu2AskgRBBJjwD9LeK0flnPQfqdheRUl/ER
	M7uPEyiM9PYikIeqPMGpHNvIvrbAw7w=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 1EB19EC0122;
	Fri, 11 Sep 2026 09:37:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 11 Sep 2026 09:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789133844; x=
	1789220244; bh=aUWzMrE2fH9LXIQGLIziweUqtGBoGNfxi6Eez8lfaUQ=; b=j
	cnyyqAm5z5hYcS9EF5wPFJ91ryMRF1o0pBnsP1g9oDZ9RhK/XNksIG0q3aCMFsTl
	GTwytC36pB1+nEtJ4VbSVnojglqNbHbelFs5Uy0uuogLlL8i348HN/DNbd/cxM4c
	viqx/pXNn4unC9MfWQyvwEOZaMolWqnyu4knMHOcAGv06xI5IuporlnoDywGUshq
	wWl7o3cX6EKKfiTfHLOo05aWuHcjOxmsdUZtnBZmLfeSd+SL/XL9jpqhNykzes7o
	wKAhsXhmcZJQnZk5C6RA6GitekMg7AyyLO5bYIdXUf1tyAUk97mHzGX79YHIHqvu
	7WcWwzspFiDPhahH/RCVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789133844; x=1789220244; bh=aUWzMrE2fH9LXIQGLIziweUqtGBoGNfxi6E
	ez8lfaUQ=; b=sx6bioQkfUcTv0/wGsHO2Hl+nm3vXaVrJGcN47yEFzB8aagBrww
	oSCoaL+sSr0f5ZXTN2sWO6zR2I+My08NW4sJ+RjpuJuRFygQ1PRJXZjgju20PgyZ
	/R8aL70MiQwKGs37FsRrTSRPappBXw86aKZD7jDXow6pPlbQDSyR+avIMWD3YUMt
	k2FXTUSuLkyzV4bXJY0CQJuABUP23ouy4fYYMqSuB/zJ+a/lNzOsNGqN6BorTlKa
	yFCue/rUtYtmofdR2OqZky6DCTprquCgb5vx/F+o4uWqKiPGPFWh2+jX2uUAfLDa
	xNVsHu8zWedas+mt2Ukrro835XyvPrVUMwg==
X-ME-Sender: <xms:EgSkalB4yY7PYkVPpMQb2RbsqkUs3NeviPYfa3devhcgSbnvj_dZUw>
    <xme:EgSkahLVP2VCf-elNXk-vWvDYModNj6_OQx__TbJCIfAZV7I5mWpIdPEQYK6SdFwS
    0MElHEFuBRSXtW7D1P0bSwnAE6mg61NjXiZ-ZwSLEnnzInTxKSSwtE>
X-ME-Received: <xmr:EgSkan92bE1cG5Bb9BqiEFeb8CVQ3NKndJAJm9u0aeW6wH7PGbaxjaW07Bc>
X-ME-Proxy-Cause: dmFkZTGtvDHsb+qUAX7tZtZeNaOt2S42aKxlWnOf8rlaoToQxTORQxeghJ5FOVDYBzmBE1
    wTQ2aW/jirFdR2RPvngs4WABQCuuwtU81nrBld4BPNEVYqIvuqw2yZCHJnaDzhQEXabWgU
    285/5Ct4ATd95wIfxynF/cOhribMHqfUFdSqY9IALX14wfQ22sWr/mBUr03ef1wsciRQ7n
    yGmPKwXKXKqgZ3Nu/k4GLxqEjg2QS6C/3Ve98h8e08R9NsAqklrhQUZzVohRTTy07Izfj8
    t4gfD6LzUGzNFHtN4grJ6EWwzvD6Znq/Orv5v4rnIf4X5dl0JBistOS9KP1bkYJj2AsijW
    VycF2xemCLmigDZiRVPsRjrQZRbvDl0IK2AaBLz5sP7frPxKxfpwDD874h2V0bAV5r7KYy
    UjgtJUWOvA/uKw4bou0GJNsHf9+oKVjd/ScRUCo0qHa7FVH8cdpjURmJLX+GGJQFN1d9Nh
    MNwI7hD70YpEjaUNTKjlgMuK/yLvjOAzhrAYwTnlgynPd03OdfbrXm5Xdii7n9HBE6zdCZ
    ocxNhXR/vr9oAYzchV9+NqPtxQDIHN3sQSIKarMP2aN8ycqzEVQl86ZQvQT0DnAFcPXhBr
    DGbbr9AkMj7R4MsVb+z0prqoIwusVMseCO0pNmOIicFfFyFp0Rk58i2MQpyQ
X-ME-Proxy: <xmx:EgSkan9a4JpKi75iOw12dwqxjhJJ4IgJfrpC03yRhy9pNEuehpyi0A>
    <xmx:EwSkah9a0BttA8UBU55S6lRSEmUDxbmW6wWNdRxKbUpB7vTUpgqzEg>
    <xmx:EwSkaiK60eLFfJgq5My86GXMA9HKRZWjydMTFngTkRV7Xl0NK1FqiQ>
    <xmx:EwSkamQXvR4dkBbbs5iYbe2btMFOxz29ILK6f48NQgl8cIfdxMrewQ>
    <xmx:FASkaiEiIg2AQ_3jOgO4gs9zb3WngTuQcxMiq-ztas96HEmDuRM84WuB>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Sep 2026 09:37:22 -0400 (EDT)
Date: Fri, 11 Sep 2026 14:37:20 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
Message-ID: <aqQDKTzLLvj-_Iw9@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-9-kirill@shutemov.name>
 <DLC4ZVU8JXFG.3SS0W4STZKWBA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLC4ZVU8JXFG.3SS0W4STZKWBA@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C72C71C0002
X-Stat-Signature: 777epzjbe3rxh9efrk51hpsxazgbecfs
X-HE-Tag: 1789133844-723073
X-HE-Meta: U2FsdGVkX1/wVo/QV8NWi483Eeu9oxMm4gcYEtd5pMeG2BYSs5cCN46WJfbOfXyiKT03fKTpguypvcbCIHOlsNOP6Z50iQWYhDapoiFoYhbXw+LF6mdwjESYOH3/0cR6pbVIo7GwYvUUxbtV736JnIAusJdWnhyTQEir6b8mFEnbyReBUAVXKOKUloWG5Sn9i43KmeZEnd4ILeQ3/ZuxjE13T3AuGenV0cQoEwy2rHOUh1GG0umejhHieTd3u4b4dMh/jApjCBV1m7pdp10MnvTbwL1xh8bsw+/Efy9KCNPh4Y8i0iREctQHS2mEwKSr51CKaGoRVOv8dSTbrfGStJ/cbIMuUw0ww5yn8RItQ7xW3fVR8lwcKpOiq71z6Q7gQonqm/ZgFqr3xfzm0mnQpNuaTEkZlLTGV9+YZMGxLX63T5UhC1snMllp7yaNgFE0bS+McnPJDWtYvqVVqNlaFdD+rG2/q/zTRRtIDM+hWJFgYiyVzElxyEViqxcXIl+39oMdwGswX9e51CRn+eUJYhDzz6lqmPMdLB4mAxXzFw91pYiEFDI1lA7jgaZonU+oe5rcJgHsP+OBciLfeotakljeqWfYIeB1nEekTuIjycoU0C94GaMr02DRYx18N1u3UPMf+cvUZbIEX/m5IIdZHSfiI57LPG7cFDnTbTcxqrMQe0PEPI12Y2B165kYcFYfO9BKhJDQ1y/+VKEskmLSlp1RZB4FwW2qXsaNGBaiexudG4mt4GHsJ8d5CdYzld94A4jfX7zqel3CVlpL++IcXVHvqqYGy88JtBVf8gQ+s/Ff35lv6LeKFDjagQnyHBTBRws3d+f8EEV9tsss9SVwL2+O4vSlPSA+dODWyp2vRtkq5fJxfo8jHLjK9SbBW6O78tdDEAbnAC8UdthX5Z3qthYm2orZZUSobyT71t7tSsnz0tg9K3TnaRlGGlMWg85haqUuC4flA4AEKQylVmv
 9Pz+CQcQ
 JRnhkF4xry8sIxUiK01PGbnMn2t7zuUh6THvtVNudY2L25HIvYQw0jB2bCmV8ewyTMQerVLrSrt4q2K1bCyg7A01ULrtvFMNPy/aKJ10TyTyB7dbrrzA3cYcVhQ5UM+77ABbqRPV/KadDxdrXqg5rQ4tfCfz/y9wqTIpsfKZpl+d2Z7m0V61UWwqivAxE0Vi0raGAiwaJWR/E0oh+pNX7tCtRFxKy+lOnvMlzue5c9aDYs4FzfiNKAdIFItg/uoGSQ0whJdB6i8tca2TPCwK4raJI1bWkoEmfXbgSzSas/z5E+XgmfTkUMlaTTTAhupY1Y3IwEDHwBZ6IIAKKT+N5KbKEPBdgeq32GVIV1X9mC6t/gxlZn2+uO3NB0ZjZMqD9KsuqIxnHNxPDrz3kWsIKsNtnm2xVXXEKkPATrqdnsQbiywk+c37O0B8Zuf9jkC3Iy4GbcIt20T149+glx6vvl9oDPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 10:38:13PM -0400, Zi Yan wrote:
> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > A collapse is two jobs.  One reads a PTE table under mmap_lock and decides
> > whether the range is worth collapsing.  The other allocates, isolates,
> > copies and flushes, and wants the lock given up first.
> >
> > collapse_single_pmd() did both, so the boundary between them was somewhere
> > in the middle of a function.
> >
> > Give each half its own function:
> >
> >   - collapse_scan_pmd() scans one table and only reads.  The anonymous
> >     scan that used to carry that name keeps its body as
> >     collapse_scan_anon_pmd(), and collapse_scan_pmd() is now the entry
> >     that picks the anonymous or the file side.
> >
> >   - collapse_run_pmd() does the collapse the scan asked for.
> >     SCAN_SUCCEED from the scan means there is something to run; anything
> >     else is why there is not.
> >
> > collapse_single_pmd() is now the two of them with the mmap_lock drop in
> > between, so its callers see what they saw before.
> >
> > What the scan found and the run needs travels in collapse_control.  For
> > an anonymous table that is the orders and the referenced and swapped-out
> > counts.  For a file it is the file itself, the offset in it, and whether
> > the PMD folio is already in the page cache.
> >
> > The file side moves with the anonymous one.  collapse_scan_file() used to
> > run with mmap_lock already given up, and called collapse_file() itself
> > when the page cache looked worth it.  It now runs under the lock like the
> > anonymous scan and only judges; the run does the collapse.  A file
> > collapse works on the page cache and never sees a VMA, so the scan takes
> > the file reference while it still has one and the run gives it back.
> >
> > That changes what a refused file table costs khugepaged.  Every file
> > table it scanned used to end its pass over that mm, because the lock had
> > been dropped to scan it; now only a table it goes on to collapse does.
> >
> > Two things on the file side stop being rescanned.  When the page cache
> > already holds the PMD folio, the scan says so and the run goes straight
> > to retracting the PTE table.  A run that refuses dirty pages and may
> > write them back retries collapse_file() alone.  The checks the scan makes
> > ahead of it are ones collapse_file() repeats under the page cache lock.
> >
> > Tracing changes with it.  mm_khugepaged_scan_pmd and
> > mm_khugepaged_scan_file used to fire after the collapse, so for an
> > accepted table their status field carried what the collapse made of it.
> > They now fire before it and read SCAN_SUCCEED for an accepted table.  What
> > the collapse then made of it is for mm_collapse_huge_page and
> > mm_khugepaged_collapse_file to report.
> >
> > Assisted-by: LLM
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/collapse.h   |  16 ++++++
> >  mm/khugepaged.c | 147 ++++++++++++++++++++++++++++++++++++------------
> >  2 files changed, 128 insertions(+), 35 deletions(-)
> >
> > diff --git a/mm/collapse.h b/mm/collapse.h
> > index 7044dc71c7c2..346859a2184f 100644
> > --- a/mm/collapse.h
> > +++ b/mm/collapse.h
> > @@ -88,6 +88,22 @@ struct collapse_control {
> >  
> >  	/* Each bit marks a PTE the scan accepted as a collapse source */
> >  	DECLARE_BITMAP(eligible_ptes, MAX_PTRS_PER_PTE);
> > +
> > +	/*
> > +	 * What a scan found and the run after it needs.  Live only between the
> > +	 * two, and read by nobody else.
> > +	 *
> > +	 * The file side takes a reference while it still has the VMA, since a
> > +	 * file collapse works on the page cache and never sees one; the run is
> > +	 * what gives it back.  A scan that found the PMD folio already in the
> > +	 * cache leaves only the PTE table to retract.
> > +	 */
> > +	unsigned long scan_orders;
> > +	int scan_referenced;
> > +	int scan_unmapped;
> > +	struct file *scan_file;
> > +	pgoff_t scan_pgoff;
> > +	bool scan_retract_only;
> 
> scan_retract_pte_only ?

It is the PTE table that gets retracted, not a PTE, and
scan_retract_pte_table_only is too long for a field read in one place.

But with your suggestion below the field goes away, so the name does
too.

> > -	mmap_assert_locked(mm);
> > +	mmap_assert_locked(vma->vm_mm);
> > +	/* Whatever the last scan found has to have been run by now */
> > +	if (WARN_ON_ONCE(cc->scan_file)) {
> > +		fput(cc->scan_file);
> > +		cc->scan_file = NULL;
> > +	}
> 
> scan_file should be set to NULL by collapse_control_init(). Anyway, the
> code is duplicated here and in collapse_control_release(), maybe add a
> helper.


collapse_control_init() does set it to NULL. This check is for a scan
that found work and was never run, which no caller does today but the
engine on top of this will scan many tables before it runs any.

Both copies become one helper in the diff below.

> > +retract:
> >  	fput(file);
> >  
> > +	/*
> > +	 * A PMD folio is in the page cache, whether the collapse just put it
> > +	 * there or found it: retract the PTE table, and map the PMD if asked.
> > +	 */
> >  	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
> >  		mmap_read_lock(mm);
> >  		if (collapse_test_exit_or_disable(mm))
> 
> result is changed from SCAN_PTE_MAPPED_HUGEPAGE to SCAN_SUCCEED to
> SCAN_PTE_MAPPED_HUGEPAGE to get here. Is there a way of avoiding this
> result churn?
> 
> 
> > @@ -2805,6 +2857,28 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
> >  	return result;
> >  }
> >  
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +		struct vm_area_struct *vma, bool *lock_dropped,
> > +		struct collapse_control *cc)
> > +{
> > +	struct mm_struct *mm = vma->vm_mm;
> > +	enum scan_result result;
> > +
> > +	result = collapse_scan_pmd(vma, addr, cc);
> > +	if (result != SCAN_SUCCEED)
> > +		return result;
> 
> Can it be changed to?
> 
> if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
> 	return result;

Yes. The scan returns SCAN_PTE_MAPPED_HUGEPAGE as it is, both callers
treat it as work for the run, and collapse_run_pmd() takes the scan's
result as an argument and goes straight to the retract when it sees it.
That removes the flag and the round trip in one go.

The diff below is against the whole series; for v3 it gets folded into
the patches that introduced each piece.

Looks good?

diff --git a/mm/collapse.h b/mm/collapse.h
index 1ebbbf63fb25..69bbd1f30e68 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -95,15 +95,13 @@ struct collapse_control {
 	 *
 	 * The file side takes a reference while it still has the VMA, since a
 	 * file collapse works on the page cache and never sees one; the run is
-	 * what gives it back.  A scan that found the PMD folio already in the
-	 * cache leaves only the PTE table to retract.
+	 * what gives it back.
 	 */
 	unsigned long scan_orders;
 	int scan_referenced;
 	int scan_unmapped;
 	struct file *scan_file;
 	pgoff_t scan_pgoff;
-	bool scan_retract_only;
 };
 
 /* Which orders a VMA may collapse to, zero when it may not collapse at all */
@@ -114,10 +112,10 @@ unsigned long collapse_possible_orders(struct vm_area_struct *vma,
  * A caller states what it allows in cc->policy and then hands over one PTE
  * table's worth of a VMA at a time:
  *
- *     collapse_control_init(cc)         once, before the first table
- *     collapse_scan_pmd(vma, addr, ...) per table
- *     collapse_run_pmd(mm, addr, cc)    when a scan found work
- *     collapse_control_release(cc)      once, when done with the control
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *     collapse_control_release(cc)           once, when done with the control
  *
  * The caller holds mmap_lock for reading over the scan and passes an address
  * within @vma, aligned to the PTE table the scan is to judge.
@@ -125,7 +123,10 @@ unsigned long collapse_possible_orders(struct vm_area_struct *vma,
  * The scan returns with that lock still held.  It only reads, and almost every
  * table it is offered has nothing to collapse, so a caller walks a whole VMA
  * under the one lock it took to get there.  SCAN_SUCCEED means there is
- * something to collapse; anything else is why there is not.
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
  *
  * The run is called without the lock and returns without it, taking what it
  * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
@@ -144,7 +145,7 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders);
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
-		struct collapse_control *cc);
+		enum scan_result result, struct collapse_control *cc);
 enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
 		unsigned long address, bool expect_anon,
 		struct vm_area_struct **vmap, struct collapse_control *cc,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1deb74cf28af..e257faee0717 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2734,15 +2734,20 @@ void collapse_control_init(struct collapse_control *cc)
 	cc->scan_file = NULL;
 }
 
-void collapse_control_release(struct collapse_control *cc)
+/* A scan that took a file reference should have been run */
+static void collapse_put_scan_file(struct collapse_control *cc)
 {
-	/* A scan that took a file reference should have been run */
 	if (WARN_ON_ONCE(cc->scan_file)) {
 		fput(cc->scan_file);
 		cc->scan_file = NULL;
 	}
 }
 
+void collapse_control_release(struct collapse_control *cc)
+{
+	collapse_put_scan_file(cc);
+}
+
 enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
@@ -2752,31 +2757,19 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 
 	mmap_assert_locked(vma->vm_mm);
 	/* Whatever the last scan found has to have been run by now */
-	if (WARN_ON_ONCE(cc->scan_file)) {
-		fput(cc->scan_file);
-		cc->scan_file = NULL;
-	}
+	collapse_put_scan_file(cc);
 
 	if (vma_is_anonymous(vma))
 		return collapse_scan_anon_pmd(vma, addr, cc, orders);
 
 	pgoff = linear_page_index(vma, addr);
 	result = collapse_scan_file(vma->vm_mm, addr, vma->vm_file, pgoff, cc);
-	switch (result) {
-	case SCAN_SUCCEED:
-		cc->scan_retract_only = false;
-		break;
-	case SCAN_PTE_MAPPED_HUGEPAGE:
-		/*
-		 * The page cache already holds the PMD folio; what is left is
-		 * to retract the PTE table, which is the run's job.
-		 */
-		cc->scan_retract_only = true;
-		result = SCAN_SUCCEED;
-		break;
-	default:
+	/*
+	 * SCAN_PTE_MAPPED_HUGEPAGE is work too: the page cache already holds
+	 * the PMD folio, and retracting the PTE table is the run's job.
+	 */
+	if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 		return result;
-	}
 
 	/*
 	 * A file collapse works on the page cache and never sees a VMA, so take
@@ -2788,11 +2781,10 @@ enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 }
 
 enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
-		struct collapse_control *cc)
+		enum scan_result result, struct collapse_control *cc)
 {
 	struct file *file = cc->scan_file;
 	bool triggered_wb = false;
-	enum scan_result result;
 	pgoff_t pgoff;
 
 	if (!file)
@@ -2802,10 +2794,9 @@ enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
 	cc->scan_file = NULL;
 	pgoff = cc->scan_pgoff;
 
-	if (cc->scan_retract_only) {
-		result = SCAN_PTE_MAPPED_HUGEPAGE;
+	/* The scan found the PMD folio in place: nothing to collapse */
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		goto retract;
-	}
 retry:
 	result = collapse_file(mm, addr, file, pgoff, cc);
 
@@ -2919,8 +2910,9 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 
 			*result = collapse_scan_pmd(vma, addr, cc, orders);
-			/* Nothing to collapse here, and the lock is still ours */
-			if (*result != SCAN_SUCCEED) {
+			/* Nothing to do here, and the lock is still ours */
+			if (*result != SCAN_SUCCEED &&
+			    *result != SCAN_PTE_MAPPED_HUGEPAGE) {
 				if (cc->progress >= progress_max)
 					goto breakouterloop;
 				continue;
@@ -2933,7 +2925,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			 * whatever the collapse leaves them.
 			 */
 			mmap_read_unlock(mm);
-			*result = collapse_run_pmd(mm, addr, cc);
+			*result = collapse_run_pmd(mm, addr, *result, cc);
 			if (*result == SCAN_SUCCEED)
 				khugepaged_pages_collapsed++;
 			goto breakouterloop_mmap_lock;
diff --git a/mm/madvise.c b/mm/madvise.c
index f75a9d139980..33bcd390ce43 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1014,8 +1014,8 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 		}
 
 		result = collapse_scan_pmd(vma, addr, cc, orders);
-		/* Nothing to collapse here, and the lock is still ours */
-		if (result != SCAN_SUCCEED)
+		/* Nothing to do here, and the lock is still ours */
+		if (result != SCAN_SUCCEED && result != SCAN_PTE_MAPPED_HUGEPAGE)
 			goto tally;
 
 		/* The collapse takes its own locks, so give this up */
@@ -1023,7 +1023,7 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 		mark_mmap_lock_dropped(madv_behavior);
 		vma = NULL;
 
-		result = collapse_run_pmd(mm, addr, cc);
+		result = collapse_run_pmd(mm, addr, result, cc);
 tally:
 		switch (result) {
 		case SCAN_SUCCEED:
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

