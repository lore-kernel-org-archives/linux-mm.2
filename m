Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48893C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434556B0088; Thu, 24 Sep 2026 10:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B936B0092; Thu, 24 Sep 2026 10:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321E26B0093; Thu, 24 Sep 2026 10:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF4036B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:56:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F9E9A03F7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:56:14 +0000 (UTC)
X-FDA: 85248956268.14.A6B7CA8
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35E931A0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:56:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y o5jOJr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=aMPccB4L;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790261772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Zf7UhNhsq+m5MHp88ue4Z8T5ykpaIrCSq+h+GNOPCQ=;
	b=tM+kkF3LCmgLPy1kLqdPHYFIGFsdN+1uHezXs/kOjcwnVklB6bbUW366dyrTrFsnVNa/mp
	qYA2w64wmQYD1uCYCjCp6ftZeM7iq4s+nBP5vuZUnOoo+VpZfL2rt+6v0Qn/oonYZNsVa+
	ED3AFbjlp129Ngd6gItUGa+3uatHCFU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y o5jOJr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=aMPccB4L;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790261772;
	b=YLKZMh/CuSv1OluBpIe6+y7e+l8s7LKElkGUMrvSys4Fn98qAvNadBWx2xn3te38/qwQiD
	XI/zqGHRWPkDV+EzYfTPXDEtLJNPbmnxAIPMA5f9xQypoAOLWvwe4Siqvu16n82uJEsnSL
	SLCK+9+7QLQu1UPxaidni8x2ZxET7RY=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 915F97A00A2;
	Thu, 24 Sep 2026 10:56:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Thu, 24 Sep 2026 10:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790261770; x=
	1790348170; bh=7Zf7UhNhsq+m5MHp88ue4Z8T5ykpaIrCSq+h+GNOPCQ=; b=Y
	o5jOJr7HkYESWPD7VL4ga0L6PQnqODZFH3M8I1Ye3sZzOh+w6QkHYTKsrtvgeQ+M
	TG2CadFM0R9nnSStChhahL7OsnnSlsAHTVNXUzMT7/gLNzbfvqCIZM77aTeHiE3b
	YnmSLiuiQF16RT5c6WT8IPxT3XqfPP/nZiWSOfI/X0zS4zwcgFOQqPktNpGy1WrZ
	O0qiOR/EoM9uScVdvTmsfhlZMCC1TsdeWAasv422xLoC4IjILYLknPSYjx5ml7kt
	ay/4/M9rP0DG2o3A9qy8hnLPQc913Ae37rp+lMtk9JgLCjokHhTRlCrKfi1pQIol
	Z9MVRL+8O+Taks4nnMFog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1790261770; x=1790348170; bh=7Zf7UhNhsq+m5MHp88ue4Z8T5ykpaIrCSq+
	h+GNOPCQ=; b=aMPccB4LzKgv2Xl1CNxzJ73UiN5MKUgG/oEdnwiKYnX5zpJF2TG
	mn4D4KVJDD4I0oKD0ssm5mVkC7rOg9JFJ0Xb9GNja2S6SSFhLDGCF5MOG2Rg7j4b
	/cvXnk2SKsemTcRb0L4nKDAVoodVT0i5tz65LSx/dB7KPhD88Okej/7aCmY2B5YZ
	y1xzAcD0X5aTTJPL1EAEQbLLHY0vL/jJTIjqJFZ+eoWRMFBkquJEz6Op4/pVHG6P
	hXvI6mSgArLS7oThmhiS5Gwc7QjyYY21QBTjwqBltKyz/G1iWlpiJYAPm30fBdpK
	Up4qJNtYm6aH7OKvuzAxSCNscxFg+O5+ryQ==
X-ME-Sender: <xms:CTq1aqMj3BEof6H8wXpOcmnU5RgIQXLHncxJ-c8HBUg3x-xtZDGAWw>
    <xme:CTq1amlZo-SECRR8BthPpV5zmDwOG8Tw_yHo9DrpDQ03elrnbSedxlhGSGp2f_hic
    -Jgbz4G0XO8OhoE2wn9-MeQO1HFIT1dl2W2J0_bLfuXoE0nDUZBxxJ9RA>
X-ME-Received: <xmr:CTq1aor55WVV1F4xbvZ5FDEsTqHWnovtamqVKzkfhdp690ho1iVkSDkFUJQ>
X-ME-Proxy-Cause: dmFkZTEm121JmsM5WFX6TDLqpqwjAt7B+uos9puGugA7o1qqmXn88fL/H1ePvop0i/LXov
    tPO5Pnpg8ogWRE+0d8EpdKh/RBdx0uQvC0VQz8189EvnP/wykjNIOc1B0SJFOlQ1PaU+I1
    gjE9nHMd1cSXU6xngE0kLMDSZyBacVjLV82trwEaG/PnuK6kMM/do1fIDzvJmA5fw9nPfQ
    AaUhBhZ3MAIwIcipCOw7vmFKav9t/s9TlH3hq/mfjrI6JK6lMVc3JbTHXQs6p6y3q6h338
    U+OOVetaNL6J1uwACNrE1BxVgbkDqcdhOioMAQW7Aihn5Ovbn8Ozoekz6wRpUq1Halt6mt
    q5lcgBomB966B7loBHPC1FVIe4WdBPkf71raIa94xKztjMOiDEkgVQT5/E7itPP+V7vR75
    Mk9wbVCBUWhT0aJSy3N30xSkYyyMlXm1n6J8w+gS9Sgue2CEtlvvSNwCp1PdLOXHLA0EkB
    uitFyJnSXrhX1GU082B5DMQ7WNc+NPiXn5+MqOgrZNUFEf09NwvlkNU2ryUHila/NRUYly
    +qwSoNb5gEFgzPqLpq2WNiwhopg93ssgd0VkKBrq4fCguyD5JxNeIyrkCNocCxs407vLxH
    USrxOFH31bvN6HfunPc0guB6RELJytiKi9n9Skre+6hY7J7EK0yAwV953B2g
X-ME-Proxy: <xmx:CTq1ai4IfYpnICN3DRz00cedHKLxWpYDCdpZ0GUbR4VjFOrXfbAXcw>
    <xmx:CTq1aqKH5cRSwQSmG4--GspL7Av_fuelDj1Gqedz6AQX4PdjEIXEEg>
    <xmx:CTq1aunMfXY0yTA1O7moWbdamrt2Ipa65I4lFcldxIS26jxnwdUF9g>
    <xmx:CTq1ah_gU3l04Crgfzd-keoASyegxIuNES11KRezM2No5GQIEGrebA>
    <xmx:Cjq1avwcFPhORVd0Fvlf4EKrzNy-iiimWmbTJPDwhURH52l6Q7bh-Fx_>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 10:56:08 -0400 (EDT)
Date: Thu, 24 Sep 2026 15:56:07 +0100
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
Subject: Re: [PATCH v3 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <arU2L6CDg0FlC4yI@thinkstation>
References: <20260916093145.4022188-1-kirill@shutemov.name>
 <20260916093145.4022188-10-kirill@shutemov.name>
 <0b421935-d83f-473b-a21a-e7f29f8585e3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b421935-d83f-473b-a21a-e7f29f8585e3@kernel.org>
X-Stat-Signature: q38srixsexuxjopr5k5muyo8ushfq9ra
X-Rspamd-Queue-Id: 35E931A0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790261772-544796
X-HE-Meta: U2FsdGVkX1/DlA6wJiFTZIf57IkUi0mePQlQRJtMjG3C8VQRvQOaUIvJvOUXzaDQhGlDAkgmApzE8WQ6ohz0xUquHVxIwLdjEhYTGcddUQmTUZJF0q0Mx1c+kTUxdaYHczVEUgVV1jX3KnPNJ7Svg+L/scRacbegHoGT0UuEn/5b9WGe7QHMMDIZW7MwyiphNhrH9Yumtze36emeTrx3G4j+HhDyyR/s0dLd90o+AIXwqQ4jeA5/Bb5zrtKQjQtR+0egd5YpFENbpjbWsHD+znGDigWtEqUckoNm54H+pfUQOzw7jBSvv8e/ZgBAyIdMe+RiCmTbTmuZvTTjoP60Or0YuwoymWssrdQQLGVrsoTstySGvVkFeIrzlA+njEkcxOoEc6484YXwhGZsPCtNUiylEfDwlXDxUX0YcJCVEf5zYSbGBCbS9frscqA4GEBrnsHqeMXKms0I2ZumUp0LC5ewbovoIxzcBUN50bPmXVT6hDNApFu1inkSBD2rGmHR3NHwsCujRAk3Zx6dR5WZBVDeGw75xsJ2trv17Ce89CXaVX7xPAMEQO3qLCLkpFoXzlmCkh68ZDFBB7A6hNoLAJwWOPga2MdKxi8R3GsCu2mGSE+XhN5Gg68o0CLdST91dOkcCvRTOjIVEOnWCqyuQW/8+wxbzMBqOLOB6sWg7Yqil/IB9B2+i/z70C9bHfaJU1/ZMCInj2Qg1fWogMgnVAOLvOTXMkNqgn9EalxTpO0UIsoeAb1NdDtVAWH72/62x/lGaigw9PFne30/EktHyujuiH2OxFHTRJdSme5wHcTGjK2Q02lCuwbKW6M/fmc4t3/5ZAzm02DMi8jgO8+ouC2Ms55zft9D1ecZntV0H2aEi5/aaHUg1GH0is4P/G7DX1ok6g6PUyXwYADW0ZuSRHEzevFYJ7AhXaZxK68DlN/LgNgYiRUh8XmYzsSrymganXsI4IBvHoTzOeyzyN8
 bvX+UUMa
 0hQHzlApk1FU0TWoby89jcHkxs0wV/0HZaZhtu3ndPR05jjOLsqrSFjm7ldmeBf+p9ejgu6Xyj3UNSHkcv5hOROBVzR5q1Ku5kikRLV+gGrrRmWb9njsVkAkoZwoDFiduov2nhy5HZz9Kgvtr9VJioy7tVbuGvSV9VhE1BIoAC69wYxq1Tv/FqTgCGVcfVsxBTXer5J6a5u+90EUoVzhzI5UgYkjBhFvcF8AERQcjGedE9j6STFLqvksLhEJfvXUUI9at4SImPC+NwdQj8IwsGf6CByayXGZ6GCysMni1ESKgjdbQk1csTXhPR/XxPqYWnJgUETHDh1QTxGPSh+fmdE7xYJL55vPOP8kPFVBi0JS1I9Xqf2YQlenhFr/HCp0jLPNTn8y9Vbdafgb608WUaHkSZXgEz8+fJxjIOgAUsy3LktN8SGunnapB9qsZwdRUgadATvMDj62vfidZ/vmw+oTn/8vDFK+Nl6kAQeSkQHJLWmaBKm2bJq//Y6MgTTRDRvo8f7LNaP1+HQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 03:08:55PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 11:31, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> > contract.  The scan is called with mmap_lock held for reading and returns
> > with it still held.  The collapse is called without it.
> > 
> > collapse_single_pmd() kept that boundary inside itself.  It dropped the
> > lock on some paths and not others, and reported which by way of a bool its
> > callers had to carry along and then act on.
> > 
> > Open-code it in the two callers.  Each scans under the lock it already
> > holds and, when the scan found work, gives the lock up before running the
> > collapse.
> > khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> > the code dropping the lock is now the code that wanted to know.
> > 
> > khugepaged's walk carries on to the next table while the scan keeps
> > refusing, and ends once a collapse has taken the lock from under it.
> > madvise_collapse() re-finds its VMA after a collapse, which it did before,
> > and now uses a NULL vma to say that it has to.  It still reports the drop
> > to its own caller, from the line that does it.
> > 
> > The lock is given up and taken again at the same points as before.  No
> > functional change.
> > 
> 
> I'm not sure I see the benefit. The code in the previous collapse_single_pmd()
> callers certainly gets more messy?
> 
> Is there some other patches in this series that depend on it or what's the
> motivation?

The locking. Scan and run have different locking expectations.

I tried to explain it multiple times. Probably not well enough.
Let me reiterate.

The scan reads a PTE table under mmap_lock, fails often, and does not
drop the lock to move on to the next table.

The collapse allocates, may sleep in writeback and takes mmap_lock for
write itself, so the lock inherited from the scan is no good to it.

collapse_single_pmd() hid that boundary inside one call. It dropped the
lock somewhere in the middle, on some paths and not others, and
lock_dropped was the only way for the caller to find out.

With the two calls each has one rule: the scan runs in the caller's
locking context and never touches the lock, the run is called unlocked
and takes what it needs.

There is nothing left to report, so lock_dropped and mmap_unlocked go.
It is the same move as Nico's da98790891a4 ("require collapse_huge_page
to enter/exit with the lock dropped"), one level up.

It also makes moving the scan to per-VMA locking trivial: the caller
owns the lock and the engine never sees it. I said as much in reply to
your note on v2:

  https://lore.kernel.org/all/aqQf9hSy0iNjnL6t@thinkstation/

Patch 12 depends on it, since madvise.c gets the two calls and their
lock rules rather than a bool.

On messier: what the callers gained is an mmap_read_unlock() where they
decide to run, and what they lost is a bool telling them whether
somebody else had dropped their lock. Each caller now takes and drops
its own lock and knows it, and the engine never touches a lock it did
not take.

That is more lines at the call site and a simpler locking rules.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

