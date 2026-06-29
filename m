Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C21C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D346B008A; Mon, 29 Jun 2026 07:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CCD6B0092; Mon, 29 Jun 2026 07:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFB46B0093; Mon, 29 Jun 2026 07:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82D6C6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:48:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF6DDC2B23
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:48:36 +0000 (UTC)
X-FDA: 84932777832.01.83A6364
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 647C3A000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:48:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H65gbf2i;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782733715;
	b=uLCqtEiF3J0zC1ZWTek0R8plpH1C22YFzs8Cwx2X6UlLy3RF9wX7nIweYeX0j0ao8Ylwrs
	2Ma1w8fIfkbxNGVV89yONAhBq5HXb5lpqUUyMdlKSxEvJvRs1gvyZ6O+sV8s44mAIJ7O0D
	UH7AVQ8dnxAAXPQn1OOYAJ5knsFBzmw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782733715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdJjBapnWqK/5wc19D0+FvXlEWJ7CMzxx57KUogxdVo=;
	b=B4BJR+21Ow0Th5jrNVFdiAymxIKCb7sMbPsgtAK3c2kgtg/cvTFtiPPrj4XOpxZHYzNWRE
	Psalldz8yQPydWP/2+VDNQJwhQ22El/WTdkMqyTppxHvQ2dUNo9G/IiXtDWkvzGNl9T9cZ
	fA39sEIst+EpQqS2VQxOlkHHo0cGwFs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H65gbf2i;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A34D5600DA;
	Mon, 29 Jun 2026 11:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2E21F000E9;
	Mon, 29 Jun 2026 11:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733714;
	bh=WdJjBapnWqK/5wc19D0+FvXlEWJ7CMzxx57KUogxdVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H65gbf2iEGv2XZKo4se061BH3bpHpe3VUjVrcnH1e+nvvMAQO8XAvhKSS1QlzRZj/
	 Xuf1p9OvYpjwTNrVOHuRn76V/YYYj7Ma7qMir7f49NfjE/PsXgWBuBnPntta+oizSu
	 IJQtP0EFsaHz8PDDj3NYWZ4e09Ec2QXBZbsnRvDSm3knw6q/ZaB4s6547BwB2e/p+Y
	 BsqkzdIscaS0Sef0dyM67Pv66p53nbpBoqUhBVJk23R8kRQjAfWRoEqS8jrHGFt0Dt
	 ya3hvDQVXDeh3pkiuW6MyJqSxzt0hN6M3/lEuWBIE1avqqnJAW9wOLw7FET6ICk+jb
	 3laaHp7g0kQNA==
Date: Mon, 29 Jun 2026 14:48:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Yuan Liu <yuan1.liu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
Message-ID: <akJbjA-_ZeGGJKHC@kernel.org>
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-3-rppt@kernel.org>
 <20260625095846.4e2tl3fbduc24erg@master>
 <aj4s8DvCQ0jE2H_y@kernel.org>
 <20260626092952.qoihjgphv43ezw6v@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626092952.qoihjgphv43ezw6v@master>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 647C3A000A
X-Stat-Signature: p6j7zfi7tpa5fb7ei5asqju4qebj8nnf
X-HE-Tag: 1782733715-367120
X-HE-Meta: U2FsdGVkX1917z65K1vYvIszjQK2Xnw+G8fCDK8CY/Fz6Ga5TIR5sg/nGAMhXeDX9LMXpX4C/NTkNdLvTuHsHwms2hmPRAeiK/ejGYBuRn6Hq9A3LEPAadR8rUXUZegqlsf+azYoOJKiis6MzgxARzwK1bAYAlfhBd2vPiZFR9gGYoKmMf3uyRxhXy85DsSbtL2XGCSrVJerD4NMDsB/qMngiL6z+x/FUhBwr22YDoYrpr1GWzv1hh5wF/mN2FCTkUsEN0nigRrLemWylBlFE2BR+vuXYcmliSO+zbTv0PhT0PsQZrQEwcVtf3CUdWsqbI2mx2b/9xJkf+y+o6hXG/LtUcRnhAsfbLxmbCvXu6SzZqHT7ujE78ClKPKgAMrj0hn/eWeNEyv2kCkfTUag7cULs9ZckFJ5lcuWec9OidaHoq6Ryx7AsOEhrMyMxaczO8UNKfA7ipiEiplop8p0xKdj2gIXw2x2cAhem48x0GdALNQuz4Pzp0eYREMmJXPh1K+/djZ6yv5zXAjEEw56oIGgNxF6wZbbasqo42FYAEp3iRbe++M1+/jP7XriRbbVtJOj3n2TB1/7w4H1dOow4enMrnQu0QjrF+K6WOfves2DazvYbQqljVr2MxYHCM+XiMQ58GNJ+325f1YepKlSjVD3u67+mby/V4k6XcV/9QH+9fTRJVv40NJUWLY51gej+e9dPkz1v7hI8eB4A4YIwgsQRZRRQ+o83VJOyjTkAkM3Qk2dj5R7aZNijUFjoGRY06iDy+kz/nCqDnrFDVTj8PU2ql4dwK2ugv8bt8nqfXrZDb8L6nGxO/eeT4jEn4RlD9Q4shWx8iif9GtPdPeX0DMQhvaHYU7ovPhhSOdKE3tE0JaQDTx+9nsfVCzjVwtsfv2cZCvw3IvY8TBOxbIi4Hfa9boiI3Rc738F8AyZQH3Z71zbIHeRcdUmSUVRgix44OMKhbP4a1lavty6Gu5
 alYONbaM
 ALswyI58J8/CZHoEe9DkVivuH+DgU7WAUjQdzFhbuR6bAG4sZCUpaOQCJyig+nrMGXiW2/WyvbDrY1F6UDr5VyhOp7RbsLfu5e1m/Jsbxn5UgYGy5qo7yFt0Wo/zIoDxbm3kUu7iWZYNE0ZQUP6xTbe+v04rUTbbZC1KSql5szd5R5ivzg4nnsXebMzvXzJ2FhVIQF0QkMnXRFqxp8V8h4iLPZhQuXpjyNb02h48h5KiFhwTS7ikdakiN7/jwdT1O+rKSDIwc1UKdMYsrhfv8nMANEbeOYa6kqqLB0boXlzPV0qCGHxJEBveu3r4pq+OaDiFJKR0EuiJoqLzfsC4Qn6X7dqS5uoHQydW0Ylpyd/OOCXDxYgIe9p2IJpx4J0DwZffKaPkCk1XIT9Z3EeZ/wxbJhg0HJAEU1EZeg9Cc9HyA1WQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 09:29:52AM +0000, Wei Yang wrote:
> On Fri, Jun 26, 2026 at 10:40:32AM +0300, Mike Rapoport wrote:
> >Hi Wei,
> >
> >On Thu, Jun 25, 2026 at 09:58:47AM +0000, Wei Yang wrote:
> >> On Thu, Jun 25, 2026 at 10:39:40AM +0300, Mike Rapoport wrote:
> >> >From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >> >
> >> >When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
> >> >didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
> >> >to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
> >> >double initialization of the same struct pages.
> >> >
> >> >Since kernelcore=mirror works now the same way as other variants of
> >> >kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
> >> >be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
> >> >
> >> >Remove overlap_memmap_init().
> >> >
> >> 
> >> Do you think this is valuable to mention the double init for the overlapped
> >> range?
> >
> >Not sure I follow.
> >We had this weird overlap_memmap_init() exactly to avoid double init.
> > 
> 
> Yes, this is really weird.
> 
> As I described the detail in [1], before this change kernel would have
> overlapped zone range like:
> 
>   Normal  [100000, 1c0000]
>   Movable [140000, 1c0000]
> 
> Which means [140000, 1c0000] belongs to both Normal and Movable.
> And memmap_init_range() would be called on this range twice for Normal and
> Movable respectively. And we want overlap_memmap_init() could skip init this
> to Normal. Because actually, the memory in this range belongs to Movable Zone.
> 
> But overlap_memmap_init() only would skip for Zone Movable. This means when
> init to Zone Normal, it doesn't skip as we want. And when init to Zone
> Movable, we don't expect it to skip.

I'll add something along these lines into the cover letter and will merge
it as a merge commit.

Will send v2 soon.
 
> [1]: https://lore.kernel.org/linux-mm/20260623092351.13031-3-richard.weiyang@gmail.com/
> 
> -- 
> Wei Yang
> Help you, Help me

-- 
Sincerely yours,
Mike.

