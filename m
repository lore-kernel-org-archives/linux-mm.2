Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86255C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825756B009B; Wed,  2 Sep 2026 06:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D57D6B009F; Wed,  2 Sep 2026 06:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4226B00A0; Wed,  2 Sep 2026 06:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4485E6B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:09:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B610C16015B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:09:07 +0000 (UTC)
X-FDA: 85168399134.01.29682CD
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99C54A0009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:09:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D 7k5zw+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=AloGDmX+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788343745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4eyoVhARyY8c3ayX2oU65ovPrzRBc+wnZNVAdNtoY/k=;
	b=EC8K5BMGn+VWUVOVILAe7s6dk7F00bY4mtir7xR9QJnG9OXPTJ0OR8dYNhhS5GPf6bJiEb
	x8Q6eTHhbrYz4yB+reRkP+1fH/4r1ScPNLCVGBRM/ozemzDPI1ruh4EEPejvjcv3dde9Ry
	VlHYKxZEgUF5a6Yxb636Jj0lbwxut9E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="D 7k5zw+";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=AloGDmX+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788343745;
	b=wELYfOqaX7Oo/bx993SG/Ju3jnQ7jVebE2M5qUQscVuyy0gSmJobgh3rx6GKvk88L46uwR
	MXijJUAtiCMhkspJfD2KgJ7VHTelTRz032yPukTOL+Cc+qFNGIBpU3FfgwK5F9FUipPHY/
	7G8zpdVcntJjiv6Yzlyl5c1/ru2CkNQ=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id E27927A00A4;
	Wed,  2 Sep 2026 06:09:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 02 Sep 2026 06:09:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788343742; x=
	1788430142; bh=4eyoVhARyY8c3ayX2oU65ovPrzRBc+wnZNVAdNtoY/k=; b=D
	7k5zw+fM+2d7gTzK+knYjEyKFgO+t4i3nbQB1NkKrqhA3ShTf9d0JTvbbcKgDPp0
	EqGjR1TD16LYwOXjpzwu3LWzZXSV+FwDXEMD9w6xnjXUVSdASkTivh0v8aowNKgx
	M2oo0XwGPwMDsfKXl8N2XPpQCMENc9xBr5MGX1PNV4FSF/UybxhFTvsy1dtDp6R2
	w3xdc9Gs4C/2/RKhreXpLMm23E6ckKGf/u6vWsMnV4th1CWUTqhegQ03QtWge9p9
	H2n58GQVCbIc+bc6ludWIr/elkD77NXHSmkwuRb6tWjhkXtYFhfWUbtzuNL9snYL
	HeKSEnl7MKUR6PFNGRAaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788343742; x=1788430142; bh=4eyoVhARyY8c3ayX2oU65ovPrzRBc+wnZNV
	AdNtoY/k=; b=AloGDmX+5scehhG/OaJSz9eOQV6ApCNfPYb2xbKPoi7qCeebhh7
	ploKYWcPRMZK6H+jDvOGltUwL0nE7xpbMxn21xQOXDJeKUB2T654v0hPGNIxtaqt
	aIx9ERdgZBFD9BRu1WRYICsMTcr1UzFlO0V/HY/CGUR7FlYHASvzajEJdD7ryAFz
	ZEjal+y0BcOcGA7mnR4FpmJ/FGovSANdiTmpbZbUC6n3/n2mtZC0OPhxuEIh43LF
	VuJNgRoaAtylzwrcFpoTlqsGQ/rL5dihRYkNmfEWhqMFO+HzfF9Pl6ivHgSxQbHt
	ubEK/F4+276TUN7/dlcCPAdPfZXpc45jylw==
X-ME-Sender: <xms:vfWXavnvofDXd6N3zNSIndXutDcTMaf074qX6qMT5u1Epf-z9z5q3Q>
    <xme:vfWXaqnWnsmlJS2gnif68Qc9V-8k4G09T7ysF8Kd374DODY9fauT6Kp41p1DRtFCA
    uch6mnff0KLYxWqZIb-ABkeL13MSFHYnEX8XiJOLUcLAfuiwR-TLBw>
X-ME-Received: <xmr:vfWXakNiu-LorlGAwXak0MeyDfK1i6EtPq75uSmqZHMd5gw3_I33XMUTjtU>
X-ME-Proxy-Cause: dmFkZTGiBOszArCTT2ozfuuyGlET3SfJvgjhWow2cvI0CQD7KlUc0CYYimZ+3biXlQ4u+o
    KkvVrtlzvvlmfVoFFsV65PGXjIqzFf5nke9m9kK3RXhiZtYJtCz0PCNVQfnvyPFa4Qer5D
    YtOVw8gzpti7+qerlsizop8o3vQXpE5UNY/3VRMnBUu8CSJdFqzDYjU+YNTfCavzDXYJmN
    2kFQi3rPCwyuxUv9fsTbXOcTsjKWuvfL2j9q5TEzRYefKOwHSZtijnINSdJB6vzZShbVcP
    5LwryAPF+g8abOVvLOba5+BQCt/u88dABujx1bIRJu519slcLGDrH3N8+P62ffTsPbTIQK
    LH2SO/+8pDrkXdVNo022U8jR7SkEIiSOaP0mmJXkI+18LxRAVFjGncD4hz8porf+ug4bgg
    1+24bEBdG/q3ggOtHO8Gze0FsouKTN0t7nwwF1gMuvv1YwOcjewYMYhuRzI4CkEICzEnBv
    6CYybZDUQr2MjRbnSOBWcXnCyJl3MyK5Hg+gLOd5sWvV6m4PQiEv3SLIs53PSLyQWzBdZo
    AKm6kktafDiFyG2aFFBuJrQDd46UAWzAOE1whPy+lvxwzB1dAV3KZCwmM9DHxZ3R2HEpdY
    F4bNAwQ2EAKlf1vhC3de9bpF5uHcA56ejrsMbeK5M5fEMO9ULcamcRJIHf2Q
X-ME-Proxy: <xmx:vfWXah4KaI0LNBlT92aNSPwDyRf2sJI3YMizd-k586F8yamPlUsSSw>
    <xmx:vfWXahvuy5FWv7vcHXuIiYQP1XR_RpTaQYSX8NxidJPeURV2E0idDw>
    <xmx:vfWXarOsF3j5jEs0pXyUvPeYn0SFMacE2B_hlsaTBr1BHhz42raYog>
    <xmx:vfWXatqJBgS9Yc0-jhe1XH_BgEOSI3C-MtDDDoAbYVb5NOBV5aM2eg>
    <xmx:vvWXaqGerQgwiEPUXIcctFF336lajwgi2xTi0kelKEa1HcADuPppzQoO>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 06:09:00 -0400 (EDT)
Date: Wed, 2 Sep 2026 11:08:59 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-stable] mm/khugepaged: avoid unnecessary checking for
 swap entries when collapsing a mTHP
Message-ID: <apf1iWLgwMUxnHp5@thinkstation>
References: <d02405a5-1d0d-49d5-9056-1a34ccdeef10@kernel.org>
 <20260827121151.7837-1-lance.yang@linux.dev>
 <apBB01VBbmV28gWP@thinkstation>
 <apXHC7uYXE99ZgPp@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apXHC7uYXE99ZgPp@fedora>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f5pc6dnb6iyfp3sum86z6jkk66dtdht6
X-Rspamd-Queue-Id: 99C54A0009
X-HE-Tag: 1788343745-575496
X-HE-Meta: U2FsdGVkX1/otM7sFiaBC1akO5LgnJuMdEVbK+s4u9iynW6vzA3dcilMnxQcP6/mgIP4k5y38t+TR5c3QcVOYLSOX7bHiVsyzaXubT9ZWoosE5UV8BVe3TvW96l1oeDn4xgxVxB84YA2TIAnur674ZR5I1tuZrlQoUDv9n+Z/59WMzu+/2aOhOBErzXjTzr5yAiw+YFoP4TPggfkZTTZpJRsxbDpjQz5pqIfR1tLEx2B9wdJK3v8dL0/iLLb6YSP32ufyBIkjtxerPCZ6bFi1ky+KXNhieePS5tDLnCq5L2k6VsTvYD+T6zC5X6hUWxGbqwlhi/oQ7PEECVKqxGqQAUZs7St3uvzKFDUaoDFUSzG5V62gr3Ekk/78+Jx0KV08YbG7XHeMtHvjT93EM2GzCqGdSS8lxBQ7rI4lEuhJJniR3VZ43XuLZT8lw5u+1n8S/W9Q/xlNrxn1YBDLy4EUa3kTlj8lVq+PUBp3D5b5ahcQW9MGoA1mihtYkoRkM7N3RtcnX1hXVGP6NSP7qlXsc01O41fDp0lmFuxKAGS+umFOd+IBHpSdlBT0DEC/7BpU59BrFS2DcQCms5Z2+epZMgGGkFrcTye9zdVuLsmaGgp6aZMZXnnQ8H3lmR1AkyDWkdpnd9CEi8ZRpmrfj3x8UfwMjMGaYqrKVzaTnwORPdkI+RSre1YFTYw6J0UHHEv8yKFaZP47rvOWY+dMG4JaEiRMBwLueZh9WmEdYGqgWuGxjbpcaqUeKDM+6XBQxmMrErnlAR0iesk4Bnbt1OyySpgYDDAlGmE1IDrWAaw9dOSwaZHF9v1ZKOuuPOAHdLzZQXHJYu/hP27Pf46xTVzDzchZRcYU4jOpFdAJwgXGN4JUnIFPIOmoW7i1FL/iC2fMTT/1N3xBSjzC3cUQ+V5I7L+Oo7Lcrn3+DMFvS76OO2H20FMhuF97q953KPVWTKdkRV9asHAlZEKTS7AYcV
 sjynYXXO
 cVMJUzHMFxoz3MH07vlch+PUq7MpAHEXLNDjoeUBkPK4dWT9pC2VTuVhdry9+lDkZEsL/eyKN/qUUd8yL7FkjbrQrGU6kwIzyoeErrgEtKSzU3RW6Ne/aDaSYyWcG4XnYCJi8Rjr1bFuD2pfO0aU6lz7en1Ba0l0VwtwVhcsafSGTK867FrJx83gb8Qeuij8gVN9UsO2gbhE6ehZ53k0xzNeOER9zCwiXg1nLf1VL4jlQmRi7Olk6Y7jwswXNRsTRoaeCh8uQUYhwHKLY+l6GZzcp90RcJmONSvfqVQMJTrYk+oQXmXASwH+NaKhZm/s6rqwRD9Hdgi6+SOT25arOSfjPJ5WtXo5wzZ58E3XBzfiQztXPkuYVOdTXYSWQ4nkcVOd2PoolWcIFeRAyH+pmVkbC43naFqPo4gbg3T0VzFq3TyMvvIVMSoKmY+TCkJgj3nW3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:53:34PM -0300, Pedro Demarchi Gomes wrote:
> On Thu, Aug 27, 2026 at 03:07:10PM +0100, Kiryl Shutsemau wrote:
> > On Thu, Aug 27, 2026 at 08:11:51PM +0800, Lance Yang wrote:
> > > For the candidate above, the loop only reads its PTEs and returns
> > > SCAN_SUCCEED. Pedro's bitmap lets mthp_collapse() determine that upfront
> > > and skip the walk.
> > > 
> > > Emm ... as I asked before[1], any numbers showing how much the extra scan
> > > costs?
> > 
> > With the win being only some scan cost, I don't think it is going to be
> > measurable.
> > 
> > It can open a path to future work. For example, we could find fully
> > populated mTHP windows in a PMD that is not eligible for collapse
> > because unmapped > max_ptes_swap. Right now we just give up on the whole
> > PMD in such cases.
> > 
> > But there are more wins to gain there. Just saying :P
> 
> Hi Kiryl,
> 
> I devised a patch based on your proposed future work idea. If you think it
> makes sense, I can send it to the mailing list with a Suggested-by: tag.

I am not sure it is worth as the moment. There's lower handing fruits in
khugepaged that has to be addressed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

