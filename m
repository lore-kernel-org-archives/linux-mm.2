Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5860FC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550566B008C; Thu, 24 Sep 2026 10:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500F66B0092; Thu, 24 Sep 2026 10:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F09D6B0093; Thu, 24 Sep 2026 10:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 121366B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:19:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DEC41402E0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:19:36 +0000 (UTC)
X-FDA: 85248863952.10.5F6C054
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F0991A000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:19:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M EHybno";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pJYL5aAD;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790259574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=McYcr38jGkYoq6hJYVs/3wa8SJ7PvSHzvJ4tlA7QJEU=;
	b=aLlfeOQnz6Uf21Qj2PJlcma2sXZUo4WIRD5jT9g5zsRz2Y6AcIARExvU6wU3rWkwk7z/X/
	MHW8eSbARxGE8oGuP/y3BR2rXWJKoE2A/YU3sh8bes6hO6nLpu/sv524EnsNtY+gsW/so8
	udR0tmUrEp+ahaKtyhSKLqoZdyc6QPc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790259574;
	b=zR3OYmRU1aSmWB7YGer/NjtLvViaFRkLML0Z56SDKeQEYqaOJ3jdyuF3wjRvLwCgLvcKQ3
	mijWMOR1vmTdKLutJsWJ/gRFKCt70QV+qusbN0MxQckRHO+smOEyBmAEQ6lhPpAEu4ZwcJ
	VFiXUZGUZH0b9qrf7Tks6Tk4c9ktiDc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M EHybno";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=pJYL5aAD;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 005ED7A00CA;
	Thu, 24 Sep 2026 10:19:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 24 Sep 2026 10:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790259572; x=
	1790345972; bh=McYcr38jGkYoq6hJYVs/3wa8SJ7PvSHzvJ4tlA7QJEU=; b=M
	EHybnodPAi0vyHE4w1u+WjjsefaBd5sAenXno6pdWVaFhV+DidxRXQauuafeNv89
	xdg7bimN1AygAFhhu1GpzojLVPbQrcGID0Al5GDakS/iriSXM5hrnjuKUDg4vx6H
	hSMOI5pXbXx8Xl14WKFAd4ge4M2GC/IbHr6XqYtzWV2oB85fNYMVtkmXjQiV6gTG
	SdF9SJNSXYHTey+6GExEWAL/dXz+YwpJhtKxhXSu871GXntOJVdiZ6MdqL9p/Q6g
	9Rg4gXPQLsnxZ74g6JXDoITXKQnkKnxcbSw77zhy1/2JQwhEcBzoEsn6LfRb//bH
	wgcxa/YIiqSTzUPYpIlQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790259572; x=1790345972; bh=McYcr38jGkYoq6hJYVs/3wa8SJ7PvSHzvJ4
	tlA7QJEU=; b=pJYL5aADr7ST8ElOgPGfLyuRO+xqRDha5E1QkCuycDE/h4URjj8
	W3EmkWuUyMmo5EvoaTTTmqR8BZ6DYaDFljEq2Qf058iHMT6v/uJEfhRYSPOdp2Qy
	NdrybLoGL8ehBLDzLKF9NDJIzNjcQCmB6D+5c8p2UJ72ieFxoJWvIJc10SFxTKBp
	4DyUBNdQLaUDj0NMazSrpVa/pHNnBpW5BxfQPftWX46QfvVPc4rfOT1k+APihSCg
	eJRaSc8jzTy/EMzM0+zN/Qcucrr4aQKgVWAsALAQ70NXJxLDDwPCubGA6PdqOa+T
	xu+zOlUn9N9vQQYPNQT8O/ysajbpyB5dRHg==
X-ME-Sender: <xms:czG1auR58td8xtILAxWYdDiCaqKMel9Ik7cxovJ8dnAaQIM2MHRQTQ>
    <xme:czG1ahZ5kC94CPb_syoHqMNYcw5FG27mTD1SD-8_xs9d1r7xARKphYPV1qmP1pYNk
    FrE1WF_UDQBOXYRibI2OJIabXMjtUrCd0SbI_m9CV2qE4-deAPlad2gSg>
X-ME-Received: <xmr:czG1ajPkzZB5us_Gl0maUdvtMVGux_5uprOkfjffDZx0Khn4ZXRmJjR3Xh8>
X-ME-Proxy-Cause: dmFkZTFUWZumAd0xpsnSEp5napptMkaBEDQBlJcKnhY8V8OVhpHPmRT+v7DP9/F5PdmAr7
    TYY47q7uxRPI74Vh0dDckmkyW74thi5bYOR8UXGK5D9E8A/wZ6IJqTCMFvp0pDqVVI9IF1
    ids8NGZob+fMMzrhBfCbZrbgvSuiwl4z9Gi6qZz8M54k5J/4XvizD9rLBT4sy7crZ6W9Ct
    0uXzn5tb6N7qM2T+oS8sku9r/Ms+Gf9lT8JNHd3aiMZFRcqGcVhNrV3QMcBtrWfSObbddQ
    wW4CNC0DRtMIUgDKYVjm6GxRbbUhDiLdMsdGfOindIzRWwsu1vvIHG3+6CDnWvFfBB9KtO
    U9DP603j56jfQ2Bzx8bxndqlejYd+2JxadDm+BfELtpOKt3iDs8g3Z+eptGPxZlwnYm6m/
    xRmWHLBi39KTpxH3W8OKIXZGb37ej9hrelkaPbSHnRUeLTtMVi63brE9WlxHUCZsW0oviY
    19cCSfwVzDKaPcg403dlKebUm9iQbFmJlo2vPeZAaHCmy3Rdhc8VUqFe9m+ZBzWwCBL83T
    OYLpaldJQ5TcUO1dM2IK+hhqTY4Rweqj6hA/qSFd77KnSzTqlVmTw3/7Ca6ls61P/6OPxO
    g8OpfG4Hgt7s1A62dPLlHfw3rdTkWz6D4ov+bDzZb8UmBl3aaLe83cwoeZJg
X-ME-Proxy: <xmx:czG1aiPI2w2IQJkwaLEFhA5biMsjXi1VWOtqS6xrczCwaGAiYnSzgw>
    <xmx:czG1avNgj0CeVDoHH46feo0sumKo05KNvYFl47VbB3oWe7YWh6neRg>
    <xmx:czG1amYaukv4x-KQTuyPXuxMXhAWggXU91-y3cJwwAlJfWGU47khOw>
    <xmx:czG1algs20Y-L23Bxs0NY7TYfVEnAxthVckdAT27O_nBpavnPZYwfA>
    <xmx:dDG1apXiRxco3WCoKuBJ-I2kLSVSWCWtAXV63EL5RKyC1PHCnF5bOq42>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 10:19:31 -0400 (EDT)
Date: Thu, 24 Sep 2026 15:19:30 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v3 08/12] mm/collapse: separate scanning a PTE table from
 collapsing it
Message-ID: <arUrhkCjop-htTZh@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-9-kirill@shutemov.name>
 <ebf8972a-0c92-41c4-9f42-22ffb820d07a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebf8972a-0c92-41c4-9f42-22ffb820d07a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ajd5sbwrf6ub4iz89u73hy8358da66rh
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F0991A000D
X-HE-Tag: 1790259574-915663
X-HE-Meta: U2FsdGVkX1+VF/c7NOuWksRx0avyTWSOCkq5ShRWTAkDkgHHG+GRUtVKM9KrshHQE9F+HOf448KVhSgjOWjf0WqoV+e7rzz5fXrpUjxQ2iAD6BGwK7x15VaQ+rCGJrQAV30+cusUmxub0o4fnkBnPGZApL9HAZTQwVktq4hXc/RoVWzspmVEhSEqp9us/ItpH/FARs9XJCtAsz3Gp8bXYLe7AOsIOMjpLzL9waIEySpkd6fM+akDEipjyktjulgkMorEnrchHVEXxFwIA+HBR/jAFGDEKS03x/naPrVQiPg2z44i2LQvN5MQy3RYGrd4gTS/IrIcuWgZfoY8AbN8bg/xQUR7VGnWL88CSMH913H9dUNl2ymae/ob+i266uKjbhX2yrcaFh0YNlzKcm4WaYDp+3y5kO5zIW4GhnbZ7YzbT2pnE+7xbWezrudCFWbHk/QBg9ToCXNX0CA8GBJRrVT+o3SqBQqzobVF1bvzmnImY2+OgwqjtGHTFsGyl2EWPdA+jL0QrfqF7PwznNA8UjSzqXmxkXjr2RsKUKKZiNKZfvceudWHskHfjh449FZB4WoIICp7+/XsyTDAQD4CK7ScznNbuhuHGyViuF87M5+dSrYC5uQzszWE3aM96bbB2GiMUlIjsNdHMmm7lw5vb1Vp4yw5mIkfJanPJcXvai1rDTKY0iqjwA6wBe9XzMkOxIXq8Vl2fV4SlkLhAP3IlLT7lZF7sYxELqya77DeeOiiltmcpEz5fKF4bnzE4Xo8dXbL4wJvdDyYWVTTfwCzCCDXmnHuUKsmNxS+gOv9mWYS+ziM+PrajRDGfg2oasPnHNcGZI7Qds+d/9B6eVs9oz7l0ldY9JSpIjpfgF3I/vDweNR/hCmb3jDu7DTvBfIM0668qdVPyRtm0Qva7IpSnGUdFWzY69ua1Q1Z5T0VKnVMAoHw87g1I45A05VPF9nX1CoEZrRcs0M2QUaQdWf
 2SAKO0z3
 qTdF0Ux3ap3MiLSEXLKvFIN/XndGFejvCKFDRMSzWAi26pEAOsVcTnRMBJoQ0MTbHKkPfQDYNJH5uivBm+wEnS3mMmdCHbcWUAASjUfRuBIuKGV6M1qlZUwnArroUgn6z222xr2EvwuzQnw9gnC4LcusVVZSVkINGUGYyvaRjgxxYoTt+GXa2Xp3iwMldN3GRMzKaPeuqwxRqjqbtbmSS82f5mK3kIUOv/a+0MYeoVSSsGnLn6yK6psETc8QBTF1p094u2WiYg9EGhJxb86G2PPhAOZKgaddntSUz2E8DJsoCCXKIfsG8dBMlVDiqnY3eBzubkjpx+AQlbqCNNnff1cKdCTaGSrcpP5YZo2p1nsHaM4s4DzWPj05ZwCNsWbzwqTdzPiwf0QzD7JR0828C8qZ8oOA1tQ5uslzA3iHkLKG4XrdT3tuwXNn6QNSuHK5DaI6y8gYf991Rz1q77IOHqPNNjjQDMQ6Qp+zu1OdaPNuPqaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:04:05PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 11:31, Kiryl Shutsemau wrote:
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
> >   - collapse_run_pmd() does the collapse the scan asked for, and is
> >     handed what the scan returned.  SCAN_SUCCEED means there is
> >     something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page
> >     cache already holds the PMD folio and only the PTE table is left to
> >     retract.  Both are work for the run; anything else is why there is
> >     nothing to do.
> 
> Makes sense.
> 
> The naming is a bit suboptimal and inconsistent.
> 
> collapse_single_pmd
> -> collapse_scan_pmd()
> -> collapse_run_pmd()
> 
> Maybe it would be clearer:
> 
> collapse_pmd() ["single" is rather useless]
> -> collapse_scan_pmd()
> -> collapse_scanned_pmd()

Yes, the naming is awkward.

The problem is that collapse_ is the prefix of everything in the
interface, so it cannot double as the verb: collapse_pmd() says what the
function is about, not what it does, and collapse_scanned_pmd() has no
verb at all.

Each name needs one after the prefix, hence scan and run. I don't
particularly like it, but it seems better than scan and scanned, no?

collapse_single_pmd() itself goes away in the next patch. You asked
there why; I will answer there.

> > What the scan found and the run needs travels in collapse_control.  For
> > an anonymous table that is the orders and the referenced and swapped-out
> > counts, which mthp_collapse() and collapse_huge_page() now read from
> > there instead of taking as arguments.  For a file it is the file itself
> > and the offset in it.
> > 
> > The file side moves with the anonymous one.  collapse_scan_file() used to
> > run with mmap_lock already given up, and called collapse_file() itself
> > when the page cache looked worth it.  It now runs under the lock like the
> > anonymous scan and only reads; the run does the collapse.
> 
> So we add more locking to the file path to merge both paths cleanly? Or did I
> misunderstand that paragraph?

The lock is held over the scan now, but it is taken fewer times. The
current code drops mmap_lock before the file scan, before it knows if
there is anything to collapse. Most scans find nothing, and each of them
pays the cost of unlock and relock for nothing.

Dropping the lock only after a scan found work mirrors the anonymous
side, with the same batching shape.

> What do you mean with "and only reads"?

That it no longer calls collapse_file(). The scan looks at the page
cache and says whether there is work; collapse_file() is the run's job.

I will drop the wording. It does not help.

> >  A file
> > collapse works on the page cache and never sees a VMA, so the scan takes
> > the file reference while it still has one and the run gives it back.
> > 
> > That changes what a refused file table costs khugepaged.  Every file
> > table it scanned used to end its pass over that mm, because the lock had
> > been dropped to scan it; now only a table it goes on to collapse does.
> 
> The last sentence makes no sense. At least to me :)

It is also wrong, so I will rewrite it.

Before this patch collapse_single_pmd() set lock_dropped for every file
table, refused or not, and collapse_scan_mm_slot() bailed out on it.

The mm slot stays, so the next call comes back to the same mm at the
saved address, but every file table cost an unlock, a trip through
khugepaged_do_scan(), a relock and a VMA lookup.

Now only a table that gets collapsed pays that.

> > Two things on the file side stop being rescanned.  When the page cache
> > already holds the PMD folio, the scan says so and the run goes straight
> > to retracting the PTE table.  A run that refuses dirty pages and may
> > write them back retries collapse_file() alone.  The checks the scan makes
> > ahead of it are ones collapse_file() repeats under the page cache lock.
> 
> Is there any way we could move these changes into separate patches? These
> changes are bit squeezed into the last part of this description. And having to
> much happening at once makes this rather hard to grasp.

Ack.

> > Tracing changes with it.  mm_khugepaged_scan_pmd and
> > mm_khugepaged_scan_file used to fire after the collapse, so for an
> > accepted table their status field carried what the collapse made of it.
> > They now fire before it and read SCAN_SUCCEED for an accepted table.  What
> > the collapse then made of it is for mm_collapse_huge_page and
> > mm_khugepaged_collapse_file to report.
> > 
> > Assisted-by: LLM
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/collapse.h   |  14 ++++
> >  mm/khugepaged.c | 166 +++++++++++++++++++++++++++++++++---------------
> >  2 files changed, 130 insertions(+), 50 deletions(-)
> 
> [...]
> 
> > -/*
> > - * Try to collapse a single PMD starting at a PMD aligned addr, and return
> > - * the results.
> > - */
> > -static enum scan_result collapse_single_pmd(unsigned long addr,
> > -		struct vm_area_struct *vma, bool *lock_dropped,
> > -		struct collapse_control *cc)
> > +static void collapse_control_init(struct collapse_control *cc)
> > +{
> > +	cc->progress = 0;
> > +	cc->scan_file = NULL;
> > +}
> > +
> > +/* A scan that took a file reference should have been run */
> > +static void collapse_put_scan_file(struct collapse_control *cc)
> > +{
> > +	if (WARN_ON_ONCE(cc->scan_file)) {
> > +		fput(cc->scan_file);
> > +		cc->scan_file = NULL;
> > +	}
> 
> See below regarding _release: having _put functions that are not supposed to put
> anything except with BUG is akward.
> 
> > +}
> > +
> > +static void collapse_control_release(struct collapse_control *cc)
> > +{
> > +	collapse_put_scan_file(cc);
> > +}
> 
> Do we really have to introduce collapse_control_release() just to perform some
> safety checks for BUGs? I'd rather keep the collapse interface minimal and not
> introduce _release semantics when there is actually nothing to be released?
> 
> Or will you add more into _release in later patches in this series?

Not in this series.

The engine I have on top of it gives both a job.

I will drop it from this series and add it with the engine. The shape
might change by the time the engine is posted.

The check at the top of collapse_scan_pmd() stays, open-coded: a scan
that found work on a file table holds a reference, and the next scan is
where one that was never run gets caught.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

