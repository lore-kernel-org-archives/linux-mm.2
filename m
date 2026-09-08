Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076FFC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266C16B0092; Tue,  8 Sep 2026 06:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1326B009B; Tue,  8 Sep 2026 06:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9096B009D; Tue,  8 Sep 2026 06:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCFAE6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:18:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6688F1A04FC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:18:02 +0000 (UTC)
X-FDA: 85190194404.05.1FF8FC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAB861C000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:18:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MwavFRK/";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862680;
	b=YXIY4i0BTg2n4oorFn4rzwaZmtJrBjL2++yDNGgz4Iv1I7qioKAnjScR7707izTn9T1Frl
	99K9qDt+WHsxv7oisMOgwoyFVSnfPtlkJlwPqO5f6DjONsyyrQcfD5X4W+SbOyrlDv5idD
	g65STq+4Zn8ihuNplMAkc76w68ePiLA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MwavFRK/";
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BUq9DqNfvFJpJpxO4ESAHte1Bx4yrvo0vCrnSZ9Wno=;
	b=8Bmtu1/oXH9mCWWWQ1mme90Wcp6vsoOQWSL1S+Ql4FnSACJ7zfd1ewWqB9nuh0DpINNskU
	b525W/Icp5iKfz3cjSDcUBRlD1Ydi3Cl9OkH5wIqsFSb/YaIYUEAF8B1Tzzlo62pb7tDvO
	utG9sLk8YtBlUMBlixT7x7bSsIxlYjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C2D5601DB;
	Tue,  8 Sep 2026 10:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798C01F00A3A;
	Tue,  8 Sep 2026 10:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862680;
	bh=1BUq9DqNfvFJpJpxO4ESAHte1Bx4yrvo0vCrnSZ9Wno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MwavFRK/ztSyhXEhkjmbGgqiZw9sxr6mV1TbmhsRFf12TB/TYGglIbkUGeV7tUtxg
	 F148rzwylaMteqXTQlfgqCpYKWA3xLRuiSk/6ZuEdUVkyxHT5HaPDlNP0bbVm6Mp4p
	 FjSWVQUHDyaswMIHtvx1lOd10oe48Ss+ENBMUdnmWGrLP856Z/MdRVE992y9WKpPde
	 +MjO72CMnbl+RMjRI6UWUrE7V/VLv19l77g/zVYAe07/V28dqEfQXF1MRWhBgAn38K
	 WdW1TZooWTeccR2yS/OgrcO2v9FkbaEz0BGcv51hlHvuCPSmslvFgE1NzbkgrltoCJ
	 qqFQ5EJFaso2A==
Date: Tue, 8 Sep 2026 13:17:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org, mark.rutland@arm.com,
	sumit.garg@kernel.org, ardb@kernel.org, david@kernel.org,
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, op-tee@lists.trustedfirmware.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/10] memblock: Introduce MEMBLOCK_LLMAP
Message-ID: <ap_gztTqHQv_GD35@kernel.org>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-2-vdonnefort@google.com>
 <ap2_926WXr7uAYVX@kernel.org>
 <ap6I1FN_2ylRzFXH@google.com>
 <ap-74AkHSGXbFCF_@kernel.org>
 <ap_RRSM7RBONvHaR@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap_RRSM7RBONvHaR@orome>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DAB861C000A
X-Stat-Signature: fatpadcn6pfbpsd4qy9icmwkk8hu1bb5
X-HE-Tag: 1788862680-506031
X-HE-Meta: U2FsdGVkX1/lRI1hxBiszlorGufkDpSK26h1Jw+omsIr7kh0npeZbIQbHIBVh2K6j88M4xLkRuPLDjZjl6h7gLGtAUz747zgWeUGHu5Hz61pzucSToySR7msS0iUg7z1JBOBEXgrg8USxRWOUOHLx/PvvzTuDk6/Yisoi0o1Y3bD2BakJL9MhXor2LYWo9WS+cwGYQCDyd0jppZqC4SFsBWuPLioCT75W3OuxK3L/a0R7oZsvJfpfaw6HTu+QGBkypJKdcSXTXox4VLE8srbvl2uwrNlWcoBc0dyEeP6GeAqsA520NNwNV/tk0Y9Nlb3+fRbC1wiItBa+yMUtoXzjJpRDwMGN6oPAy9ATXzhoonVIebpGuqjnrGySweAtvpuUbZKBJQ2Xm4NoosC2wlNz2VKH2FDVdDWxtVnai1Py3u6R0X2OPtAibYjnkscJVGfgq6R0iwnPNL+eSorUpohzvwlRFwUkIxkz0mHaM3rfj77qYrOsqPQ5/Jg9DRvTvGLrVR4fLhM3Wm40rYRSkAcavEMwET9xH9AfNp3l8DdRg61FdPo1KsRTR4U1ATIvyg4uTX0/8UOfeiGeWlP2sMcsNbP86zOeZnb9/xWgcdwbrwrNuVQX1uxKC/zKDbY1KqT8nuaeyCeMbhKwYhxlAIyToEhJ3JUMv5RD8TVoXfRFEP+NcTnZ+9w1ktDcUqANncAb0nOzfMKi062l4eScz2a2RCc6jMiPMJfE3mlt1860awaMLvFkALbiD6hrGHGsaqj0lHOKHe828TzC69JtPAC720FWOUVLaADu0HHuxw317c4UvWA37tZpED0QTzuUyN4ZXw537JnmCodRuIaR/OEKvWeG+fAWROPxxSiPzoihqQOj7i3ErHjAuDd/lpjVN6MhEcL4nFHrzYKRAE06mkfIFloGGBtpPKQk7hf/zu3z6dc2ALasF6WvdwsDGIbqyO64gmlXSer/v2NItkZgHF
 jhi6peHW
 4GcIh2A57DF6lFPi+KD098CX2RbGR0jFnHFhU7VnYo0dd5C7XqnIz+BBgwJDIRiqqetXxXEX5rMlLROQFWpF69VpSipRcsVWb4lf2Jp9ZiG2ROMkESgZvSKR+qtorwJ2V/DepzO6mcjqMTNa/h6ngMGIsvUbCjIebOQbPm6N637g2z90efZkkprfhxQFMh1zlHviLw+bGtYbzrbYTES9aig60PfoGbF+y9so5YH5jPwnKBGXFxurzoeAimfhv8CPh+ANBKy7njucvGpbRHAH5Rg1zApT/rxDLLoE+KO00Q8hvlmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 11:18:53AM +0200, Thierry Reding wrote:
> On Tue, Sep 08, 2026 at 10:40:16AM +0300, Mike Rapoport wrote:
> > On Mon, Sep 07, 2026 at 10:50:12AM +0100, Vincent Donnefort wrote:
> > > On Sun, Sep 06, 2026 at 10:33:11PM +0300, Mike Rapoport wrote:
> > > > On Wed, Sep 02, 2026 at 11:47:03AM +0100, Vincent Donnefort wrote:
> > > > > Keeping last-level mappings is interesting on some architectures as it
> > > > > allows mapping/unmapping pages from the kernel direct map without the
> > > > > risk of splitting blocks which, under the break-before-make rule, may
> > > > > trigger page-faults the kernel can't handle.
> > > > > 
> > > > > However, mapping the entire direct map at PTE-level is costly. So
> > > > > instead, create a new memblock flag MEMBLOCK_LLMAP to enable the system
> > > > 
> > > > I believe MEMBLOCK_PTE_MAP sounds more descriptive.
> > > 
> > > The idea was to have something close from NOMAP, to emphasis it is one or the
> > > other. But PTE_MAP sounds good too.
> > 
> > Could be PTEMAP if you prefer.
> > My point was that unlike PTE, "LL" is not perceived as last-level, it
> > should be looked up.
> 
> We were discussing the concept of enabling entire block mappings to be
> removed at once from the linear map, so at that point "PTE"MAP may no
> longer be accurate.
> 
> I imagine that in some scenarios we might be able to go to PUD mappings
> for something like VPR (say systems with a fair amount of system memory
> and we want to carve out 4 GiB for VPR, split into four 1 GiB chunks).

_LEAFMAP then? ;-)
 
> Thierry



-- 
Sincerely yours,
Mike.

