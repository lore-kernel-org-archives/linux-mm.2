Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3700AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 20:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC656B00B6; Fri, 10 Jul 2026 16:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D536B00B8; Fri, 10 Jul 2026 16:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 124EB6B00C1; Fri, 10 Jul 2026 16:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF7906B00B6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:29:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E14E404F0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:58 +0000 (UTC)
X-FDA: 84974008476.15.EF5981A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC80B140007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:29:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CRblMYXf;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783715396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uceh3gpjLST7XLAIXuAF2LqD5TvR9k+/w5GQWdiEcT8=;
	b=nI+sgyXWHz54ShB4LE958zCttZEyhi9+R0K/xIW4OIRtOG5Y4/OibejaUQHCkhpOBTNq7c
	7HlqlBHQfVktNKg+3rbMgRVt5Ht1Cf2uZfTQYbxQxyPxkC4Lka6x6jb3LsHjrdboHW7Zyh
	xkgqcQQ+UT5Iv3Rznb0A/k/rMIs/s4s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CRblMYXf;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783715396;
	b=QdF1eS8b1t6EDiVGarn0SXtKgG5k/o4hcPginyF60GRXjFgM1crzmG8C5wR4F/c4QIQheL
	LrDulauoQCQUI1xxNhx2cRjDlmKclHx6LmoYs8J5E+v0wwfJx+/UZA4JMTud8zkHF+CeTj
	aOThinY7IobuommVRgsi1bch/HVQWq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74FA86136C;
	Fri, 10 Jul 2026 20:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96BF1F00A3D;
	Fri, 10 Jul 2026 20:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783715395;
	bh=Uceh3gpjLST7XLAIXuAF2LqD5TvR9k+/w5GQWdiEcT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CRblMYXffQi+FIsxfpogDWIha2S8idYY7hlFe/hupRbmmEGTpi6BJ4HWTDByp44h8
	 /3KRTjFlIkQUy1k+KZfduunfVgWR6YZ2blivarDsUJXjaKDGjX+VaUowKSvDe3Q17Q
	 2r5q2LUoryHQT1HEWXwjVr9G90Mg+9z9Z6tAEqas=
Date: Fri, 10 Jul 2026 13:29:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Toshi Kani <toshi.kani@hpe.com>, Catalin Marinas
 <catalin.marinas@arm.com>, David Carlier <devnexen@gmail.com>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Will Deacon <will@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/ptdump: always stabilise against page table freeing
 using init_mm
Message-Id: <20260710132954.49c85be140500c59c1fcb773@linux-foundation.org>
In-Reply-To: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
References: <20260710-b4-fix-non-init_mm-ptdump-v1-1-2d40982c98ec@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC80B140007
X-Stat-Signature: diip1k9wbug8jica94e5ei48mbikc4t5
X-HE-Tag: 1783715395-654442
X-HE-Meta: U2FsdGVkX1+i41FdzYapYLIvmXsbh+Ou7GU3DitpXh79THrZ1fpvR4qezbD5NDjGfDxR5qSEYFBI28gOdIUTJfAvA6MB0ae7EG6haqOTzER617VE8DQeCbBsL5I/Msh94kJ5SlKBMKfpmPBRKfUo7SO4LwhOZaazSEbbffuCgFniMFuf6ewvKOMN51siHpOOSlHByKT+qA4foHYW9ULJoZg14F7urFW5pv+r6HPFFmIp1hK9MbCVTQ571AUJuYwPoadOuSWlQPQFQ2Ip+jVcpEIOfeFDthnZ3ZzwRFMacHgLcH9ppypg9N8aOMcVhZvHoL/JaK6Lj3C9yWtGC5k/xBo0HsMWaFmmwyl+jYnRLsc9W0YVoK5ZlMDdq7saXkp4V+9m4YH0iqHwLWiBBV8Ie5lNKylVlNF1UM0jDdvSJItEhsIvJsiXCTEpHFxnKSabdu23m2EGHt6XlFqunv+vM1USZuoT5pwQVOhWhGZpFW///PLG7yYcCaz4Ay7r3ONMZWPn9KgHgRYjhrBNXI8172aaCIRSGyJYotFBOsB5TF8W56P75XIlvsCFrPE/GDxNdVSQ3p9hmi2zF3GWmOhsnO2aFP8lAptpGiW6eY4orv18goq1tYWXzO+mmicjxrCB+ZIfSSdhzCT0m+WtVJ15XPng28iRzMndCE+bgXxFQL34vVL8/v8zNN4YDUlTbTcZDoqJr8H11cQLxn7aJGOPe28MoFHqtqhkGIMCQ4DZBUfXuhgY0EN3Y9Xhe3ALcLl+eb3qVsC2xKrHFmDMoZuqBBJ7Sm5in2zg2JnOOcBl/dLUmG7MJY4/Nbpm/p7CwB4cBWESZgHFwAnSuy5B29jTAEYdxMZjyTDT+aXfpvEGs9WyXIVx0Qjdv2RQNZmATCw8MXBV53wKEtEHzRwWHrqQYqxRlIr7ID2bcVI1AKIzXmwNtqQQ1oPCJ0o2MzJZZ2qBcTIeBPkh3JrDa+WtNrc
 6HSEWH6h
 XB5e3/bhm4URl36yUgWFokw3ZFZhQWsVLmde83ePxUU+jBHG1qdhCB2K8kcz/XbnE/3zgATUJREupGaskuG7HUF3738FeyuRgstfq0MIhZHwtFJW8WFp2TY9AztXmBOXWye5koSNjrLcGjmWa1t2a7EVCXcInSKb1YB4PAWJCH0G6fMxwDQyhsBsdZKcEodvflrMIv/9LAdy7X/3G/K6kFBzLHcIJTCpwfcoF2zm0lpT0eNsB8oko06D21rVECnxEv9AuidzRenhY6CZPIItxxLKYrvKa2HuA8+nY2blxYyNmViC8HfdXse+4ipvLz+CWiG8W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 14:29:21 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> x86 and arm64 invokes ptdump_walk_pgd() with non-init_mm mm whilst still
> walking kernel page table ranges.
> 
> For x86 this is done in ptdump_curknl_show() and ptdump_efi_show(), the
> first passing current->mm, and the second passing efi_mm (we reach kernel
> mappings that init_mm protects for current->mm due to x86 cloning shared
> kernel page tables for arbitrary mm's).
> 
> arm64 does so via ptdump_debugfs_register(), configured by efi_ptdump_info
> for efi ranges against efi_mm.
> 
> The init_mm mmap lock is used to stabilise page table freeing against
> ptdump, so take a nested lock on init_mm to ensure that we are correctly
> stabilised.
> 
> We take this after mmap write locking the non-init_mm mm. Nothing acquires
> the init_mm lock first before locking an arbitrary mm, so no deadlock is
> possible.
> 
> Other fixes have been sent which update the two cases which can cause races
> with ptdump in init_mm ranges to acquire the init_mm mmap write lock - vmap
> and x86 CPA huge page promotion.
> 
> For arm64, commit fa93b45fd397 ("arm64: Enable vmalloc-huge with ptdump")
> already provides exclusion against init_mm for the vmap case, which this
> patch also pairs with.
> 
> The first point at which ptdump can race kernel page table freeing is
> commit b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page
> table"), so we target this in the Fixes tag.

Does this have any known userspace impact?

> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")

Since 2018, so I won't make this a hotfix, OK?


