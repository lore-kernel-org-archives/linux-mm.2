Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93617CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 08:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BABA6B0092; Fri, 26 Jun 2026 04:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CCF6B0093; Fri, 26 Jun 2026 04:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABD56B0098; Fri, 26 Jun 2026 04:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 303586B0092
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:11:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A145414039D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:11:33 +0000 (UTC)
X-FDA: 84921344466.10.06E785E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1788E1A0008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:11:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxEf6Xy8;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782461492;
	b=N52glYxHVi4yQCZ7/2/tGQ/2Dttjx1VLfgEfGR5MQDyul2LCPrq7gH6MRkaIXfcKso8RnQ
	PW5SDtrzHDiJD6eiWYgBL2YveS43EHnU3uqUqgx1A96diou9vrHLX8V4U2fSzU5NY1invf
	Vxw4hMfSZ1ZpB8OMkMxb+NGTvSrSCJs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782461492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZsGL5XGjVfU5amNbdHBHIndRq0ycPIRGgXVzWkw2/4=;
	b=QTkdstmYPlXOTXwK4/r3OC3rSCi9xEWn8Plz2W9BWaqXk3H+5isVa7r/4aCnDW8OzY/FGF
	uRLmLmYudlWIfPthWrQ8FaxQjxPPwjNiavPZYV7IzQZQKQxE8P2vx5CA+u82kP77h6B5xC
	xrDvgJl2XyxFMQ2sEqm5TOvrrXz4dvA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZxEf6Xy8;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF4A42D53;
	Fri, 26 Jun 2026 08:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE66C1F000E9;
	Fri, 26 Jun 2026 08:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782461490;
	bh=vZsGL5XGjVfU5amNbdHBHIndRq0ycPIRGgXVzWkw2/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZxEf6Xy85wqk8srzqv+FaXnJhwcx3zT7DBeCZpvh22wboTBdcTicgAeGIraEI5Vhv
	 UkVW71kPqeFNVXo+SVpKQGYhYvkhqj4fOASikGw6Iwu0dR+Or5FQgQh8pZu6gmCMGc
	 oGZMVsAfdCoXM0RjJSmnWl3XrwJE99qkBZKTCkJ/mCeAJZ6SiXR9l7fg1InuGqdrCJ
	 RNUEYpVMfw0LUrB25a7YK1y6qUZ10rJ+H8PKp//6tMkX8g19g1Bm0JlqRpiPcpJoi8
	 jbY2dknNxiL6HMMO758sj0lYmLdmywIMaqvK94wCcwxTXp1zMKY1AwEGAiTTFn+7iQ
	 +7+9/1ILSysbA==
Date: Fri, 26 Jun 2026 11:11:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/mm_init: don't overlap zones with
 kernelcore=mirror
Message-ID: <aj40LRV2Rvw0Upw3@kernel.org>
References: <20260625073941.145014-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625073941.145014-1-rppt@kernel.org>
X-Rspamd-Queue-Id: 1788E1A0008
X-Stat-Signature: g9mdkx9omh3ogdj11qqw61nbdp85pekf
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782461491-403844
X-HE-Meta: U2FsdGVkX1+TQvh3zvL1tBkNPu4tBBFDYWaD57Y+wXiLGfLY7ElTQWKSjOCub50azbOxEccK06Uf0qMUfblHkPYTQc4bWIS2ZXVLo+lmNP7RTx8MatOWTGsnN3oeg/dRoYX+c+wgjE0iZK/KLA0yBbHzysouDWCXCrnu3aWZxGdGJk8q26nWiSQDbt2mYbwFAdaWNZVz37wvbWyFY1H0I5j6eRqpPwxHcVb3iRpXmMpsRSSmXFL+aUij0cWUHol9vQ0Sy3igsge1TYsx/iOHgZw7nSliRDDn9feMpJ9rFGjd0LuWBUaIgbNovhRDxnn7p9Ml4jUsUOCHaJNP4GVimbo1PvY2OSVi1g70CNTqCNhbpIJoq3NaTqlaTSwYA+391ea9qVSLpN6yQjsiX4hET2HHgU0/jNjUdroUUR8gU2bt4HYTnzu494BDihWneq5ZG/DvqnvYnEqKFF/+6XVr8W3n5YqR6R89YzjkUy2fjTsQrcfsvp5c+Z4dlX0j4JfUMHQczTR0KPMko7PRoODLhb+dt5cCobGGMkLRYUKQ6v7N3V4r23x1EsjbPz75H+nyh9nsyOh873GTUyxsmqNjCOB+DPZtFI8GvdkDpa/m9jn4hQrhef+rJIBfwoaryNoR4sXtrWaS6YxRDT6kME466ktRxpkBo+5Ps1L85qrBk//jRFE9ClKX7VNZEovHNkujS0Sm9ukEHeA160jdvPdD8g2tXbn/ykUR5FJZxYLetsjn4kcqlZYKX5UpIncDNJN0GiRxZmCWbQz8H0K2NwILHQfVZgVTbYtc+qz2dEeHfM1Qn3a1zcYB0HWMTimE13qRXW1EVvoWNT19iGDXJz6bkHs0PZSINuhXTRao6mDsDSLqX1+2FcFkgZsChEJwlvolGr2ztiQxYD1H7VuE3oEGIqSWZN8iI7p23MalLBLEyVK2Mc9yE0ou0Pyiexw1UgEHL6Jp+OKXSG61KEVwvwf
 jvaqOF+W
 HP7gg8MmKRIhB5Auj1QfqJVl3x6/2unM3Kb9GH1ICNbqdmS3LYGK6hFaNKWUfB9DTmBDQIXlx3AbK1qCvfZEUaPw59yumITPrVFsS4tR/ENQJ4ebqF4wOO8qwpNUMs82QL9TCWvIiiKfUOsulGX+NmgPSrd43lDTDZDDrU5nzn6qMcuARms+yyl4LNqQxDzbpE/t6DHkH06Yx0y1Q7VRNCJL3tIfBc4F/byR3PZiZETCdbHTn0ttComYEFR11UDqbMrP9v40e5Hg0YWojuxmu36hPLCxxLc9XmjhszOC5eCVkb3nNbql5js8IsBYYURdEYfdzTvgwQhpM1ektVKYXES0w+elHeK5+DvhPdUNQvE5m/x+nlwxedDWKvOfLyhRsKXj1FCHJ+YmIhslEH8zzFFY/vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 10:39:38AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches make the behaviour of kernelcore= parameter uniform and
> treat mirror just as another way to size the zones and cleanup a weird
> part of the memory map initialization.

I'm queueing it for now in the memblock tree, will properly push after
merge window is closed.
    
> Mike Rapoport (Microsoft) (2):
>   mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
>   mm/mm_init: drop overlap_memmap_init()
> 
>  mm/mm_init.c | 60 +++-------------------------------------------------
>  1 file changed, 3 insertions(+), 57 deletions(-)
> 
> 
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

