Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19532C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300866B00A2; Mon, 24 Aug 2026 05:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6BC6B00A3; Mon, 24 Aug 2026 05:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0446B00A4; Mon, 24 Aug 2026 05:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9F576B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:36:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 826DB1C1856
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:36:47 +0000 (UTC)
X-FDA: 85135658454.19.679421B
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C9D7180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:36:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D XMCZjB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=f1TPtFlX;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787564205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Nx+Hb1cJLavCtqS/5dokCLvUqZ5zLYRMFKnI3FyAaE=;
	b=SPOQJwXxWZXHwXXYeHwRi941ZBE66IhJ4X0GMQwqE3zk4MoSZhohFVwC0nLrt59KaxVG/c
	y6tlzZQcNSKDvMNeycor5fvtxsWqVLxvVQsIG+C6/aRDL0qcLbnkiCPoGDR2rGQWNLslhl
	CQLkVUpydNC+nWcqZnlSTPEqj8voRrM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D XMCZjB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=f1TPtFlX;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787564205;
	b=RtxhmqigQgaSy19AK8gijecKkTntDhefEN8BWptF4lNP8pjovYxjBk+Ajbrz9RqUO+3G68
	CoJsn9/fT+jOiKDx4WCJkY2EtPv3pIcMjBQaFo8Ch309K9ZhIrTUbCpu5LDvozSP6ibspf
	mcq6WrCx8PQJg7x/2hTbEQCR/5m8CWc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 4CE1413000ED;
	Mon, 24 Aug 2026 05:36:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 24 Aug 2026 05:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787564203; x=
	1787571403; bh=2Nx+Hb1cJLavCtqS/5dokCLvUqZ5zLYRMFKnI3FyAaE=; b=D
	XMCZjBEjE2WRkjfTT/l93Z2ppMDuTmy6M2b+tGmG6Pe6cgYWS/QJpmFE/CdNMMMT
	jzMhjfIQIdszw2DOjRSpI/586aBchUC9AT1qPbo8v3wdZKKhlZ5Kpg+cZgqqUQgF
	gx7csWp8hNW5v/+deheOnROg29BxPD0V9iNRJxd9KyDU+ajWO8FmgvraUvhjkmU9
	nE8CBMmUuQp7QkiVnIvqLf4eFzFGwXF/QTKtHaInl9ugaw3FHuIf+k3brfeI4rkQ
	GEAZdY9YVG+OmfStuuPDvLZ6fFGA/SWqw0aC6ZhSkUzmr3i8bXXEm0jN58JYzEyh
	J9GVFE3cd/eATkRKkJTlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787564203; x=1787571403; bh=2Nx+Hb1cJLavCtqS/5dokCLvUqZ5zLYRMFK
	nI3FyAaE=; b=f1TPtFlXInsC6zBZ9Ay4DThFOjrt39+tJOW0YUNfX2yYr4B85lB
	Bt/uNkxNF4rGsOIZa+P2Z4FXHMJCAfDQZ8uA9f0UtGwADmpzc1xLwbzWXTWFDCv7
	F4+e0UQ2+c6UYlR0sBTlmeEsR1pvpwAFAVljawi0eYq++jb71XpKtmMd7DLPVpki
	MXmFqLpbXUkaCTajElC1DEfRCWBbdyz5byyxowa18y+IWeLgtbDWKFWvnDhSpZ0Y
	lRLc07UlSeXN+WPOOC4Ue+Md1z1dNrHzeCMiGAW/w0gIE6amxPurKPMGCrhwFV00
	HRsNqN/EMEJexTQGhwnniSQSF5ICVbXXUkg==
X-ME-Sender: <xms:qhCMamQ37TdeqI-8c0wyxwX4KjaL5V_FFqpYU-lK0Fg0WLjMOwJ2-g>
    <xme:qhCMasPlBtdhrDLj96UANI2IB47ABZAfi5OyMuylgubxKxnWIIWWgICNr0A2G4Ai3
    0ciF0ryd7KZcPJOWfSMgC9_fQmMtwgBb40-k7clB_HaOTmh1EtNV5w>
X-ME-Received: <xmr:qhCMalScg1ZkjSdwXXhg2VS7paIFLyzeiHzwF5yFy9mEQ1AXSu6liZ_nOoU>
X-ME-Proxy-Cause: dmFkZTGz2jKxdMw4ERsyN6C8iQmqO+8xUhsL9pZAKxT69wFsIBys6xB5LktOPJ4MI0l3D4
    YlQadQlnEULRi3wFdFmH6J6Q8kOxZQ66f3Y59fqSOl3sUuOKJyBZVkwP5F6bCwor0D4c1j
    gWQvh+36ctO8XdjR32mGCjZTL7fyCcLpjQDQ1iGjdJj/+SYA83G6of8uS0pWlA7axesh8u
    HWEBAcFTwYyhzVS1HsUvRPl3jc+FFnGEDM7Z5rwtBPS5sXCOn2wLUJWaRCE/5l8OQTIyl5
    aQorjdmPeS4asVy6AP0atTHEfHFq/SWWHDzBowQEToeLuoCh8aVSMWmCd2dHb4AdJVptru
    M3jBUrNeIY2YnduC523fa8mPAYP2Wp62CxBO6cl25BResJENTq0fvto5ryW7GDnZnJUODj
    FAY4dqLp4Bd68fBeVKpNNRd+lQ3DkUTzCJye397QJoqDU4vwpPjJ2SAKEFhCGMYZTeShgn
    hfnINvkBcagzM4zgrpkWQYc2Eypj5LSuP0FLfgxSk2U/TjQIQYJ23knpwjHSd6HW7BwMfW
    J2sfFufBDoqKYso8TIWw4eZTHWZd46+UWkANzrimpT4M1+Q3Edr3yRcV4DDUE1eciOEeMt
    u4ynfdRZwB0yiRDbuR7W1cGkJZ9oxpCZzcLqutIZYpPJQbf25PnbcoUi2WrQ
X-ME-Proxy: <xmx:qhCMaiAvmDZ9d8WATh6CVccjjdVgDgZD-ATr803hgjx-jCFJvptaIw>
    <xmx:qhCMau48MjRLWCDIWbpjXuTa7IN_1WC1HaeNAjU1YLXIUY_Q9vhUMQ>
    <xmx:qhCManAAFbQJAxNCN_lgbOpTJZlqNmj8vZcOVOmLVIEBA_50xeMQPg>
    <xmx:qhCMaifiEw2UntNmGOI3F20xqaC7E_YuxmmtQLe81ruQZXh9Oz1HvA>
    <xmx:qxCMamsgyLPF5we723-a0VKd-R3Khai29a0-_8ma3PHL_N9lh8Mdh97r>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 05:36:41 -0400 (EDT)
Date: Mon, 24 Aug 2026 10:36:40 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 08/57] mm/collapse: scan a table for what a collapse
 could use
Message-ID: <aowPqZU0aj2gSEjW@thinkstation>
References: <20260816224609.308019-9-kirill@shutemov.name>
 <20260824083903.52962-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824083903.52962-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 8C9D7180005
X-Stat-Signature: bbrxqkxgrtedyshp6tby8sjqm9jb4th7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787564205-748163
X-HE-Meta: U2FsdGVkX19kVBLWlAceuj39jQMFwhrQmHukpIre3VAcLTILhc/lo54kMenhtdtrQzW3HwbFvX0UgAa0ZRTaCV+MSdfd9zy4OZAOn1tL8nFXIdYtLfUWwS0Vy6PCddchtr/lcv2aA3UZ0RvL84fDCf+kcxXHOZdr4C32m+w1fVvvc8ZNooW/miJpg2m4NyL5wkYY8TyaGkydCmF4q7rc4RXlvJuIM537LP4vJHyOkEdHBhKSni3w5pdONyGg2Anp5IgYl2Tqgf+bX88UU7wtQ6mmIxtKgJQI8wLSEMot7ACdBOr9X39A0tziQtpUVmbGJ15RkOXjoFzv0lVFXZ1oCeeDNKN3+ci2oAMOX35zTGN0VnJtS3At0ZaJXipLRLrMSGjRn3D+B1G6o5es9AKjeGSJoJfPWqHm1uBM7h0uHUFnJNBD0ccabCOC9Q8tsyW7BNEHy5EVxGkNAV7Qh4UVOv4lpkjlBdT7IV9zCkoGn60ufEe1uzwnhBopEISsF2lCAv25wXy5VerHJ5tu5bMVvX57FCU0SoFyW/zg8RjVsDD9wsYLSogr318D3Ucn7YJVQJmgIm6P33LUW/uACKnIA316S0kZGSrw0I0XYv1Sjclu2f3YymZh5kWpaE5WtTPDjYjQ1ymYlMFgZfLw+mw+krj6NOn9g1ed3i0y8r2gp2jPwC8MUYRDA1IS3vwiIpdKSOB4AjMczOpoJNCJSjFsOD4zeO1MlPoeuNde7vncPLTDGuknfO9tY8e0+hKegXobQHHLwGmNa342gS/gc6NaV6RAVF1tE6zh92gXYA6412dJJcfxLfMD3e2pdPuIYUmZxKWkBEpMoGf37xe6xJyxNlwtEYizj4PNx8sUZuW85S7XNuX92mlT512gBNblg7wTdp6Lg9adJMdH0vceU8+2EgJ795HJWLGLSPM3hjx3hqgR8iAmN/5aM1b0xPJA73KH0U+hGeHgShElZP+WWpH
 7lrpLO2p
 mcGH7M8nxPZpYR8OvBt+EnIWkB8tShf69ULLbXMF0B8Qjnzb6mufbic/4vTvcu+fVDuA87rAmkutb+TRxqHwVaJM552WF1exCvMXtOZcYb/+NZfx4/wDM9LR0Xui76/ZFToweKCVbs5XkMbAFTG6tYSAP+cn3Cz7EJY5zSnj+07Lu29NZ+e5r5NVoX0HtmYFeyqPHc79pbwR5f4zphF+OXfNElDuqGK+Jj/8osxlKFvjNSXNRwVemcD5GcfWPWFCDtBbmY1YOGSgT0ROZ6A2iiLUxI43B5RURqLteWS5kPLUXzt/QJonv5mI5KqtEzLOnEFlfWmPxzvid+0TL48GXJM9FedUKrISDxADVp8XH3v1r3lt/bi7OfgXB1hQYHiBd1ZaPnmJCs3zN4TGrdNPGjnPVH7Et9LET4rZERillMd67BnGtLUB91TOYRpXELpAAUaAd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:39:03PM +0800, Lance Yang wrote:
> >+	/*
> >+	 * The bitmap and the selection offsets stay relative to the table:
> >+	 * natural-alignment math needs the table-absolute position, not the
> >+	 * position within an arbitrarily placed VMA.
> >+	 */
> >+	first_offset = (start - pmd_addr) >> PAGE_SHIFT;
> >+	for (i = first_offset, addr = start; addr < end;
> >+	     i++, addr += PAGE_SIZE) {
> >+		pte_t pteval = ptep_get(pte + (i - first_offset));
> 
> Hmm, ptep_get() does not look right for a lockless scan ...
> 
> On arm64, a contiguous PTE sends ptep_get() to contpte_ptep_get():

...

> The later freeze can reject a stale candidate, but the earlier PTE read
> is still lockless. Should the read use ptep_get_lockless() so arm64 can
> retry if it finds an inconsistent PTE in the contpte range?

Good catch, thanks -- switched to ptep_get_lockless() for v2.

I don't think it would lead to any correctness issues: both variants
take the pfn and the protection bits from one __ptep_get() of the target
entry, so all contpte_ptep_get() can get wrong here is the young and
dirty bits it gathers from the neighbours.  The scan reads dirty only
for the lazyfree skip, which the freeze re-tests under the page table
lock, and young only as a hint.

But it is still the wrong accessor for a walk that holds no lock.

collapse_faultin_addr() already reads its entry with ptep_get_lockless().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

