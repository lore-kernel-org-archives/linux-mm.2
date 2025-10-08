Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C470CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D89F58E0027; Wed,  8 Oct 2025 10:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39D78E0002; Wed,  8 Oct 2025 10:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F998E0027; Wed,  8 Oct 2025 10:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B352D8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:54:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 610A714061F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:54:11 +0000 (UTC)
X-FDA: 83975242302.22.FA7778B
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6D285120009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:54:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q +HbRt8";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="ps8/ZbSd";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759935249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxjXQzbYHa9gdrvaIHZq0mlCekuWfVqLUGcO7cpYi3U=;
	b=Ry2kFL+0cLFiFO8GQx800h/OL63wx7jWkXXAjIjS7JFpOA2+klRlNv1bHqoY/xfCetrAMZ
	HmlsoGASCoYY5LZOLGr4uOTxMgU/Ne+FaZkGQNdrdq9r7+EebDIXp8m3AtInZeiiGkCfd7
	/nvz+n1luOdMoX2xj/ajUMkQEnaLrUU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Q +HbRt8";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="ps8/ZbSd";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759935249; a=rsa-sha256;
	cv=none;
	b=GeLvQHiZpVAThmFAUQZ2shiy2ZrmxA0nLJr60EtmkLNP65Q4ACPfjuqs5teS6ufBYYihD3
	WWo5IOABbTe6jgTlfw7I+73q5u3j0Wf4bo8O3YFCli5leraMA9E2egXePtT3V9IEEuEfZx
	hq+giYG98Cce+DMar3sHvlmQP4RD6cA=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 4C5551D00055;
	Wed,  8 Oct 2025 10:54:08 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Wed, 08 Oct 2025 10:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759935248; x=
	1760021648; bh=cxjXQzbYHa9gdrvaIHZq0mlCekuWfVqLUGcO7cpYi3U=; b=Q
	+HbRt8n4WWT5Fk6U7SJJvBGgyVjay+Ch3Pnr4JwSiHGIrpFTUvwKJ4DKvpmQYJ3u
	9StJV4XcgJaPYQRVRNbAr6Y9xpTB1ahmPInLXGI37gRLnaZ9YwugmDMPZ42mCoOG
	joeHDepYVSf7q5KYfRPSyi3C8f3I6yjKN0AtMH7H1WKGr7k8lvip1IyYXYkGAtIT
	cGZuNfVpArA2nqowdr1DaXvg8xwvLaKVuRPJNEj1x0yxAmbe/lisRenEv7cyjwTf
	vnQIVRbf7JUFOdeFef2hXiZ4W1vdAPDfn9N1CHo2c2Oi+rODi0tQZI5sa4i6OGnM
	2wVjfX0w4XYzIgwyJ6jaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759935248; x=1760021648; bh=cxjXQzbYHa9gdrvaIHZq0mlCekuWfVqLUGc
	O7cpYi3U=; b=ps8/ZbSdxARwBXdeCKHuJgVwjInbM2/ItY0ahzgp+3NsbHND4am
	1q8oxD9RJS3sssbZjMZRuB2+Jf1KbXcD0Z2PCoL4JMG4KI2Vlef4+TbCChe9GmEB
	EQGM0iEtvrjuslO622idvbLETF6lnItWyZJapYAg7JhBpqyh2pkPFtzuVvWzCEmh
	Lo+4z3qf6mRGYoYxgVT/OhHfetdWC/uTQlkmVkJhnoR6PuBgMu55gJbu1KPXjINN
	3Hxq1UuYIy0srz4zv4LlBv06BxPk4iTA122Xlz5bxJ9iWn6XGrgub3PBnCHNhK4W
	AAhlLlG6e5MWxHaE9Y9nu6MtWuBmif4mKIA==
X-ME-Sender: <xms:D3vmaPkXz-0p-LqJ53si7ifLxQnlRLRatVBcBI_11ctHYmKPFqpMaw>
    <xme:D3vmaF7st4hBKtzOihNXaUY5agPEZRUdQdzN-LLYy3hXonlHUHN5dcpO7SRyERVV1
    xWRTe7nBKvhG_xMmPszPbfYvdeoEHX6K6f7acV7PHNZCNW0kfBszOY>
X-ME-Received: <xmr:D3vmaATwcTvRsJoJH8TVLA-Umga8yui94ZIwajmtSY4tza_p4-L8m8QrU9Be6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddutdefheelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrghlughssehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgr
    uggvrggurdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:D3vmaDxB2UES1dtMqkK3RIlF6QYxUODmoefxum_9xjhXquPr0yKIig>
    <xmx:D3vmaIoXLflSPLcHVl_6yOnUQls4R3zAMuoOULjyttPrvkEgv4UZYA>
    <xmx:D3vmaG0SA70G5S13n9--vCA8EsxzmixMUwNQ5eoJOMLfNoexKp2W7Q>
    <xmx:D3vmaIyI00jkSyFKEYGX-ud23kYOkogdbyC1HHusVy4-LvdnxnL_xQ>
    <xmx:EHvmaK6oUWl1iRaqYzM3yV4euRPrYpM1kBQsE3eHFFNe4Tdu4EliPIMP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Oct 2025 10:54:07 -0400 (EDT)
Date: Wed, 8 Oct 2025 15:54:05 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
References: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
 <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgbQ-aS3U7gCg=qc9mzoZXaS_o+pKVOLs75_aEn9H_scw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D285120009
X-Stat-Signature: men7btrjshnf3b4n8im46h8q694jp33p
X-Rspam-User: 
X-HE-Tag: 1759935249-1988
X-HE-Meta: U2FsdGVkX19YMssjx/Weg6tJe/zJ26uZND19m33VyKWmYImeZHPoWixSe2G+4C65iJuYXofPBKEvMUZ96N0kKtX9//OTnaqID4GWvFyys3I59kQS0v4sXUmjxwvNsAQ0/d7J4Vwvouvn+AC3Lno+m3Lg58tb+GiNsh5Q4PkiLdZs4+Vh9e5Ty/y2WigGEV/PcItbFqjF2L0y191mDK5qnac/K5PGScIcamW0gqsGlqhGWyfI2CLuMYeaUsJvVArumYvm5mYniDGcFQ16oGyYd1DwAtZnf+J1D0vhi1U+jff+6JYWlLl1zebOWWj9nlfYNhVoPw9Cyh1EIxvvxmSlFlgTNiEwvpCV8VgPkbFOiSYnKtaPLgjrSckU1vxOv54OTyIpxXDmNvG2/YuQ1iZNuwNCNfWwaeIz2r0CmMRn6Vm9oaRo2K3M/5XcYK9NNzxR0EGqM5397geYgc6azTgutbbE4GNrP2RkMUZW41UMdnRKibqrfT7ayLi3T4OHfXxsHwtcuPk/VXyBFJKgHkNkzKPsjNvPi9EKwLgw8VtVyVC1FwUInDOuxSDD4+Yrb2I+kuW6zLFjlNcL8zq+/mClzpR4LEMNY9pnHPt04Jkrep9yhyV+oQSAidoIXH/Qi1P9XYN+4Fc3NkbCQbhOxL+wlloUmVBweUM1KUSIa/YYATR4r2MBWvuokjG+laIeKktC/Q9HcrPIjiT7y7bu9sEX8vmcdqhbHMdXdwOjS3sJC3iVCPcXg7WpNPVXgh98bAeTXMDvVngjJRVplRZJCrPb/F2QGuQVEZqU8WBp0zgO5vdkJOJggQ3dWA4eUPQQW46p6nwF2xZE4d32BAfjL+mB22Lc3atu21W1zAnisuW79EpCY9UNst+vK1N9luHRwxmbSfY0N9H/uAdhu/ErrGm1tUjGtklolhgL+/Br9GpFTXPLZtSkay5Edy668k8SO4mhnDeuUwfvK04QdTDwzl5
 ITA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 04:30:20PM -0700, Linus Torvalds wrote:
> On Tue, 7 Oct 2025 at 15:54, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So here's the slightly fixed patch that actually does boot - and that
> > I'm running right now. But I wouldn't call it exactly "tested".
> >
> > Caveat patchor.
> 
> From a quick look at profiles, the major issue is that clac/stac is
> very expensive on the machine I'm testing this on, and that makes the
> looping over smaller copies unnecessarily costly.
> 
> And the iov_iter overhead is quite costly too.
> 
> Both would be fixed by instead of just checking the iov_iter_count(),
> we should likely check just the first iov_iter entry, and make sure
> it's a user space iterator.
> 
> Then we'd be able to use the usual - and *much* cheaper -
> user_access_begin/end() and unsafe_copy_to_user() functions, and do
> the iter update at the end outside the loop.
> 
> Anyway, this all feels fairly easily fixable and not some difficult
> fundamental issue, but it just requires being careful and getting the
> small details right. Not difficult, just "care needed".
> 
> But even without that, and in this simplistic form, this should
> *scale* beautifully, because all the overheads are purely CPU-local.
> So it does avoid the whole atomic page reference stuff etc
> synchronization.

I tried to look at numbers too.

The best case scenario looks great. 16 threads hammering the same 4k
with 256 bytes read:

Baseline:	2892MiB/s
Kiryl:		7751MiB/s
Linus:		7787MiB/s

But when I tried something outside of the best case, it doesn't look
good. 16 threads read from 512k file with 4k:

Baseline:	99.4GiB/s
Kiryl:		40.0GiB/s
Linus:		44.0GiB/s

I have not profiled it yet.

Disabling SMAP (clearcpuid=smap) makes it 45.7GiB/s for mine patch and
50.9GiB/s for yours. So it cannot be fully attributed to SMAP.

Other candidates are iov overhead and multiple xarray lookups.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

