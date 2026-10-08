Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DCDCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 06:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CF36B008A; Thu,  8 Oct 2026 02:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED846B008C; Thu,  8 Oct 2026 02:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2039A6B0092; Thu,  8 Oct 2026 02:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F056F6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:38:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78B011C3648
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:38:47 +0000 (UTC)
X-FDA: 85298505894.25.590A69D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id DF6ADA0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:38:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j38/YTG9";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791441525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RsqwdaewrKioDzHveOJKZewBC7grld6bvE/46a8ao4=;
	b=g+I77yKrKgqXqjBRl91VXFfzPJH/6vmWMZMQBpqjgX1VKzMSY/Qn90TpawquCk/TZ/DD3O
	ShgPFTm4478Yo9PP0R3eEq+ZMM4BKqLyw4PzVpWzJxn53iy+WCjzLSt5Lc+XyWKopv5qME
	YbWV7zuhFDHZITue2/6LxPI8UpVws1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791441525;
	b=IgugLshA7f1cHfckvV4j6TdLBOLfZ0gpFQqOQ154Rt2+MwDb9Zyu+k1mmm7wYDawSo0C1E
	WpxR72N8xn6oCdDT3zh1Wnc1SrCMMfqlG3xcHwG48ZrPVmoWmnsLgdIJqjx8bwqmt0nygC
	FCwyvpiOw7oioqBfkr8SpfqsE899k+4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j38/YTG9";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4823601DB;
	Thu,  8 Oct 2026 06:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100691F000FF;
	Thu,  8 Oct 2026 06:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791441524;
	bh=/RsqwdaewrKioDzHveOJKZewBC7grld6bvE/46a8ao4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j38/YTG9lX9S2OLVXDrkb9B+8qcyyKaQeMspUhzgHXZ8OBa+qZnuSMP76709ZUhs+
	 a2No4Xym2pRTE25zOa0YSWg1zIR0kv5unhOKYSL/1ewwvfOgo4NJsFKdKsz8awTWX4
	 /6DtOBH0rcPuvqE9YaHNUMuGvM6gi5M72z4YFQzK+hsEcgkXstEWOdF23UpXTvDC1e
	 rcXu6NMXbPo8akDEKg13ENAmZ4oJ4LGXJ/exQ0zvvwBHued3rbZO1rBc8wWJ/EeQCD
	 ahpWpWePxF5W8jZpuc4bs15phLuYmjwyc3dTZ6oM5VUf+2nbrrXsgQSnnY9wHAOIMN
	 OuVHTEGQbZ1dQ==
Date: Thu, 8 Oct 2026 08:38:38 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Wandun <chenwandun1@gmail.com>, robh@kernel.org, saravanak@kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/5] of: reserved_mem: several fixes about reserved
 memory
Message-ID: <asc6brs_g0ky0wOM@kernel.org>
References: <20260920092852.614973-1-chenwandun1@gmail.com>
 <arJA6fOMetzoBhDH@kernel.org>
 <060fb694-ba1d-40e7-8a18-f32d5a4039ab@gmail.com>
 <CGME20261003080438eucas1p2bdb68c248ecad088559285a4f736bfe5@eucas1p2.samsung.com>
 <asC3DBvtlcO5AVsz@kernel.org>
 <5dccea9b-a9e1-44f5-84d9-bc9efe04edee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dccea9b-a9e1-44f5-84d9-bc9efe04edee@samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF6ADA0006
X-Stat-Signature: zumzzit36o599acrnqehp55rsw4ds41k
X-HE-Tag: 1791441525-486333
X-HE-Meta: U2FsdGVkX1/fcXKDb86FhKm+Q5ekN4rfGpDTybq+9H9v+oN0BBiMQY7GOwNW0amdC0xKlC+QAig+OV7uQexKpicvDAIFNLEnCGkYiq1C2emqGo5ecPdZ5+2DRkYEGBm63cEZR+2HJ2jJDPDggYkimbGWM0fyCKByKY1g4cD1kd9WCd6kqaSuK29Hs24keIXmjOyTDN0DobecAJmntfO7V2LcIx8kmzvXyPSaR5Xd6PKzwPfXQmOSBU4D1DqlJQ8PUc9/pFa12Ex7u+c/hGQL6GotlAlvIMJ/MsIpr6ComgfZGwcDOTISf1NCq4Ky2ge8Jh7/4UwRbveNoDGZA/nFsvzRTOGMD+ClIlmwBqzZfqBeUdgr/YTetK3XZOtAKn/bAd0PXEcUHsVVWskeK5ScNh6rHq+A5cbxE/QyYlvar6namdgD94qmpdkML7tVck+hgcXhEMLZUGXT7InrS1PAAdnHOCWA86L48g+JHVeG3q1HAADsf2Gtq7+AjhWxCZ4hmjl8Ke5IFyvprBml/XohdfOEKmyg7qVSC42X45PNKoKlzb5sQrSNPUcqI4vWFVfb3od7vjuGlOcP4W1bbyl3mXMhbpAyjPcJKpLT0L3luQ96L6B3goaI0tSlMqs9ux58EfjYHmXYP0y7eYOaUmkbANihQl9CKWFeAXNXDh11RGfwrRbP3r1zp84odXxmwZSAuqKulDQPUlYaqRpmqGxC6z6JMcnDGi94EALf449KaAjibHuTtxR6I/KGLBSLKsp7pGuUpMdkNIokkmYgoxOAJUY7Yqv0yTHdlYAO/4Mo4v1U3FB0qzhJ+zvFL3t2OwNvDG7y00Nu9tRkcFqR63Jy5+pfpxzlia3i7Jr4q/L1/MDQrSRfFNmWTyEjGyUeyEI0c8yKlhzSDD9ahojzNfNkhN48hXgda6DRMBuvwphmSIowNQuKkITO2geJR0izMUP74nYKu08gaiiQ1+ecGm2
 3FIV6UnB
 km7EbN+LmD42kR5SZiPibPdJV4AN1Mg/RhVix6iMrHhxj1I4CNHExP3IxOzgOJnBC0yXqocR241dU9dmI65+LyfladiAegKve5xJp7+BdcqSUXB7A+QPZzWzoQm0J03YqqXnBsmPBZpwDbH9/10vcUxPmoRVlU6jFc9Tk7DGbhb3SrbPQOc0vrb59JSDCazaSckyW+H/dHmpQTboeSukpzIbXhLb4YGT2dFppFXBHOL3IOZJeUvqbCJH8lL1UjBO7pLLQG95GEzFQ22ukw4s1YzGeqcHl5uxfMiQWu02yl1OoADNVsjiT38rPtteAZTeRxUhPcWWskZaCx0ON5kjjzGMjsXObm1hL8uAmHghBjp1YEP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 03:26:21PM +0200, Marek Szyprowski wrote:
> On 03.10.2026 10:04, Mike Rapoport wrote:
> > On Tue, Sep 22, 2026 at 05:24:32PM +0800, Wandun wrote:
> >>>> From: Wandun Chen <chenwandun@lixiang.com>
> >>>>
> >>>> This series fixes several error-handling issues in the reserved-memory
> >>>> initialization paths.
> >>>>
> >>>> v2 --> v3:
> >>>> 1. Rework the mechanism that checks in the late scan whether the early
> >>>>    reservation succeeded (patches 3-5, suggested by Marek, thanks).
> >>>>
> >>>>    Patch 3 adds a new memblock flag MEMBLOCK_RSRV_RMEM, which is set when
> >>>>    the early reservation of a static region succeeds and checked in the
> >>>>    late scan.
> >>> Can we keep this local to of_reserved_mem please?
> >> Probably not. I do not see a way to keep this entirely local to
> >> of_reserved_mem while handling the issue robustly.
> >>
> >> I previously implemented an approach in of_reserved_mem that records
> >> static reserved-memory nodes whose early reservation failed in a local
> >> array [1]. However, the early scan runs before paging_init(), so the array
> >> cannot be dynamically expanded. If the number of failed nodes exceeds
> >> the array size, some failures cannot be recorded and the issue remains,
> >> and that is why Marek said "partial solution", although in practice
> >> having that many failed nodes is unlikely.
> > Even before paging_init() there is memblock_alloc().
> 
> One can call it, but such memory cannot be dereferenced/accessed for example
> on ARM64, because it is not yet mapped in the linear map.

Can't we use early_memremap() for it?

If there are many regions that need MEMBLOCK_RSRV_RMEM set, memblock will
need to allocate memory. If that memory is still not mapped we'll end up
with a crash in memblock.
 
> >> To handle this robustly, the late scan needs a way to determine whether
> >> the corresponding early reservation actually succeeded. Current approach
> >> uses memblock to retain that state.
> > I can't say I like the idea of keeping this state in memblock.
> > This add flags and code to memblock to deal with corner cases of bad
> > firmware that reports weird memory layouts, and once there is a flag in
> > the common infrastructure, people tend to abuse it.
> 
> So far I found no better place to store the information about successful
> region reservation.

We can have reserve_failed_nodes larger than MAX_RESERVED_REGIONS, it's
__initdata and anyway discarded after boot.

But even a DT with more than 64 bad regions seems broken enough to WARN()
and ignore remaining errors.

> Best regards
> -- 
> Marek Szyprowski, PhD

-- 
Sincerely yours,
Mike.

