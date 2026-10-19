Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC904CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAD46B00ED; Mon, 19 Oct 2026 10:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744446B028A; Mon, 19 Oct 2026 10:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A256B028B; Mon, 19 Oct 2026 10:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D38F6B00ED
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:40:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E553FA8386
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:40:30 +0000 (UTC)
X-FDA: 85339636620.06.DC5593E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 48E0B14000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:40:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeVZuzya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grbMMayDZ7AfUlhp6lU9LvTmW/PhQ8Ok6Mqphz7bbx4=;
	b=W/X5P0LUNj9D8mHW19HrRMGc5ied5Z6oMRuwW534g7nXHMUYJCBwCE2ZtBRGGAfsgd9y6L
	iHY41CbMQCfptAEYy0nvKD4OUjLT+pJtkDPoPPfnleEcHM84oL6DJM3uws/jS/Wwi4Ab2J
	1akAeKcy2DMHpz4e5u5Lch6DhRVEeAg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeVZuzya;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420829;
	b=pI8rO6mBrxOPiprNh4LwgCbylMr74ODTlw3LhfH2H+t6GJZso3QUOvO+xkoRb/tvjiU0vD
	FHlG6VllADqz0Lp69C/GDFRhQQFE5jil9mDInRV33OrzwbLp8MeQF1PVmGRYiwhfygaHV/
	HDEtuCDkym3DTHs8C1d5a1lOsLIiRyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AAB7842A83;
	Mon, 19 Oct 2026 14:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE69B1F000C4;
	Mon, 19 Oct 2026 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420827;
	bh=grbMMayDZ7AfUlhp6lU9LvTmW/PhQ8Ok6Mqphz7bbx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MeVZuzyaJB9brvMUdTtBCNfWn8pmzehSBGLdpXeBYLYBiQZ+eSLGCrFPU1gbCNdOz
	 eEdBaOCNJgTESHwT7bBNHU1F4fXhVcZWYp6SVWh3oucgTTIqfhEBgDXo4zvDk2fhfV
	 1Lwk0Nz0uCrEmCJtYMrTUgoqRaBcl63bXnr7Fnv4JvYaxP2xoR5L8avgGxk1/YcOMf
	 kI0p4gdb1hsJAkZd/pf0qzLaM9p9KkLPE9+f+ClGePBgi5XqRQGcZTuTekSmbvX9+Y
	 NziN1Xn9N5PIsvAHbydyXRNehbRxeVxxT8TmF27eirOvfGrYDy0gQyEmWTfcyLRXxT
	 PffbUDy7ppa0g==
Date: Mon, 19 Oct 2026 15:40:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <atYrwiHPc0GU3rGn@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
 <atYJA7nIu_RwpoCC@gremlin>
 <20261019073201.aee381fbbdf2edfdd0a68754@linux-foundation.org>
 <atYqIrlyW1tgZJIx@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYqIrlyW1tgZJIx@gremlin>
X-Rspamd-Queue-Id: 48E0B14000B
X-Stat-Signature: nfm9ps9tbymzuki1racd14o4cmbbffpn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792420829-936357
X-HE-Meta: U2FsdGVkX1/PRWUPc6dPC6y6+48OSW7OxFGUb1eMTQ+E0cnBHTA5wcVvEgcXdFRuBUOwPVx4nRsGPkUbMrNwuZnIEJD6ERjNar95wAO9MJZot8WNx0HVxOidhO5otanVJ2ssk47EXqcvQGEfK5QZ2MErXRqM9BPRHSxwco0WtvAe2RWmiuKKdj+HnHWX4X5q2cuhS2bU/gkWc00aRRmD3Jsbl8kNo9ZZn/2dEUvEVTjt3TyL1sisyXlOTDtLZVMcllzVoq2z4+iZXHiwB3ALs4KpLkGKDt2GfX3jWUQmshuaW6riFfTQdqd4rQ2eIDaOfu2De+57t8mNWcxzrQ1b+d/9K/rv8yOWzkDGu381nNE30jXAwCWc/h42MqLy1i/Y9SyqD+U9XxTz/PXFIGJKMsEAyFdmtUnR6PuQFlZImABQhOlg1KSlZxxCs5BMRl8EpMIYtEsIReWFzPA8py63024BYBy8k3j0/RnJnUofLbdpX9ovNuwKKLtch1amrByWp5vvHdqWL2IRDMDrbP00eK0amwS5CO9recEn/ABKmMZkKsqHSyZj97G/bWGMKOz9P19m/6lEIbQ5OkdnIIMaOttpLzHA6X8/nUkPwUiac5uGt91pFTghNjtSTr6bLFyVvkIeLbgDCJ3zdpb7knxGdeT4dtArwcOwrQ28CnPheFat7e3b8lKtwswEVfpdeyTPAo/hr+MquAffQ9UZAFEDdrhwHdrJXZHPosX33imh3C+u0oekdnv6SDG9Xk8BDvIALhvc4CIgExqSFqisgkxVDKM6MGuiEoyIdau7hS8rhGVztxr51RqOYD7jsvgEAVPA3o4flepkDxETpC+Nvx1MyNrGUbkYzy11GvMVYxkflcI9fiShkaddDFADPX+xbj4A3YNujkNmym5FxXv0ZAI2PvCbSWVMqNQ6PTiuiW1od27cpT8VnfWokQQbH5IHxG16YY/a9VbiT4O7XT/LVdZ
 wFT8NuZk
 tTQMPLcu5430ppDC1NydnSWqxR4WpH3G8Rt7+YcpBO/Og+HKZXdElL9iZzy4Z9IHVIbe8MT6C84fx1iFmCZY5bLPVy1c2hBNEThyj6mxKQo/uf4fLG0+2c9q3camCLOWoTnGujLaTmZVyT+B598d7PZb6z4b3wh+qRuWBPlyTjZtQxrVNjYKYASliEZ8bIZqsG6D7Ru/xIZ3G4SyGG0OkkaCghhN4S/Jys174NW6C/FB2iqQmreNEBtTnXoyZ2EAwlzrrQnbbcOU45uje4T+xYhO2rcezyjNPYc2oY31T8apIbQ8UDwJbM/V6iFid/Gq4TCDPRoEcPcVCr8BQJavGJiu5n4w6dnfn4nsE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 03:39:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> Could you update it to:
>
> Cc: <stable@vger.kernel.org> # v7.3.x

Sorry... no 'v'. So:

Cc: <stable@vger.kernel.org> # 7.3.x

--
Cheers, Lorenzo

