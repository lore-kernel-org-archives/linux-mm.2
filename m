Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23F3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AB16B0096; Fri, 10 Jul 2026 07:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1B836B009B; Fri, 10 Jul 2026 07:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58036B009D; Fri, 10 Jul 2026 07:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEDF96B0096
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:09:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 369B9120422
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:09:32 +0000 (UTC)
X-FDA: 84972596184.30.F09F3D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D969C000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:09:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHd61WTE;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783681770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHILUlDZoX4t/qKzqQQOpbCYe7EYjBu+NwQXW5zJMg0=;
	b=xPJlc74dV8evZp2+J5PDuixTwwbdfPwcBOloNJ+06fe953/emi9l1PCUxfAf/nUA4denZG
	axUqNgn9HM+X8EIhd9obgt6eD20UAbnrMAE7a6rJstU3Q8101eLUVIOf2j8naMH7IaaEGE
	E1tojqp7VO9rNzHl+lk37oL/g/Iikhk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHd61WTE;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783681770;
	b=5duXUvS3QIlwjLmJvBuNgZ83RgcqWfA6Y82/02ZAuccf8mtucbKzglM3eej0rGgRoOtBYN
	r0mbYQ4VDhhulR6avu9CO/zPvHuFc3nCnc/XLhi6CfJ51ppDRAxxRfSoMx8r2VjRpLqEm/
	M8RartCxOC3VzEbcPodBFsMS3/WuYFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1B4C601D9;
	Fri, 10 Jul 2026 11:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7621F000E9;
	Fri, 10 Jul 2026 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783681769;
	bh=bHILUlDZoX4t/qKzqQQOpbCYe7EYjBu+NwQXW5zJMg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dHd61WTE6dRX1ADsW3LCgIwlPfeL0FFPcX6IVgMBjkg87WUmnMA2AKWQONqkOFjCM
	 QmcY0kJZFuTDQNozdTeg242zEBBWSnFBBm+qxhjeoIi9+NoCLzv4JEcKGzMIBLkRl6
	 +GxihKeNl8O6Pcb8o/03hOJVJ/E5FRAcdp36w89UNNeElv9WWcbminYAI+Al4yx9Ye
	 nlzNXI2uH0pGHO5lAWyOL++lpA3ms27JIPi9+/ZhaJH5JIvvAxER0T0HPEVyF6KH9B
	 9JKUpbD4ljOoN57Nd64AJh9lP8AuxZncvck6Axz+741g28FbfozTQRfPLInCHxHLa4
	 TXcWyFaWP1I9A==
Date: Fri, 10 Jul 2026 12:09:18 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, geert@linux-m68k.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: nommu: free unused resources when mremap shrinks
 the vma
Message-ID: <alDSyWM5SM_EjrFL@lucifer>
References: <20260710054648.924005-1-thehajime@gmail.com>
 <m2cxwvti7z.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2cxwvti7z.wl-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D969C000D
X-Stat-Signature: w3srnx3gpirk9uyf8t3seoucjmodj8w4
X-HE-Tag: 1783681770-64788
X-HE-Meta: U2FsdGVkX1/rHoRAyWI+C19Vu1Qf91eFUaShWgKrQZ18M139AWfMluUjwwrvRarWVw6k4QdO36Dx8HkQ3uJ9g5X6cNmKfshyY+3RaKHF2s68NlsclfuHbDvXi9Bp96YfSa/ALkUOLUYeA7Rrwg0ZD0EgMXtLrBq4NsBTfm8itWbUwSoKZWFgYZ9Etl+UGxnn20MjSi8eziBXeKm91EGISzNFzqxg4GrGUA6KN32DeqB3IVWkT9xU3WMU9DP+GX+makfA9dzuZ1v+0URClAu4U6dxW0FUnSawv1Fo6ZxXsTIVgkoV+EpunKt2O9uNRlCNMvId/b3N2BBkhPuv6vWnIWHmpwrhHp8ZoW3rohviuCh2KdVhj6gtm3KQuiQC3pCthFq0pY4mts76y/oUE7TMB//u0XZkhMbNLRgD4phsBUxFvJDBo2DNK81jNn6ZonQ67CPBOyyI2X2SdZ42OCUgjDFxdreSPYllLtzOvRU8nGBp2xPMXSFiCWJQe+cUMbKdvK4HAoiHdywO2jhRVmHv7h7TLTydjBEZFY/A6ulXkT3FuNk+196yIuPEUKaXWDV5ORB/FfPYpmDsLN1BWiUB+0u4nALqwchrGLMeY627MhFINkwhUmmmGUJcFZWffRyzPY0WyiGK7K+4uVowQ7v1VBfEWxMp9PzDqvbOdgTXw3utJiAjxZiN/wAYad6h3bNE72ixTx+S65TSyVBHCgaUvjPV+CxcHgLkmJQHG9NlXlAlI5bbeBvaT3CDFO2Eg3gMDBnFZom8Mg5dVkylsP7NRPDHQbvESfZMaBXqjRXK74Wy+Aa/M13a9rXpbPBSsWOZu/l86x1yYUbjJCDax27FCyEBVrIxrDguozWkn+lx655ySiJEJqYERA+mkAcZl1ctdsXKiRMHpKAsjUrCejJaCoDPZkTmResvFHFri26qQYsdN+8q9loaQQjO3+LIupB8iGF3BqXWYrPpsHrleXj
 gHX2QXn2
 pyvmfq2ddQORWr/jhv4AKA3bwdOJ8HwWbk1KWo6uoL6j/3UUoFGK6E/7ifUxAUDsvRs4DSAessKwqfZ3ICl2YETRuUGzgf45nfnaQHZ7yFuhh+ASODhA1ZfcwfEaRu983U/KAweE1XQZXHYb6eKss7dHuD/k0bXpEfFWiOWFqtGFb+vYg08N6dpP+feP3I/h0UWRB68XrRD5ydxkixk45/v3oNgQXTvpBaIy01VtZKZjzaWWqz60tNwlvf9dZTKeEh8mBi29g0Z4bSEanQDppwL5XMsB2OZxs1K/+cmGu6WatMMvruA3dabcrKav6g8PczRyZuz/Bc8AXtdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 04:30:08PM +0900, Hajime Tazaki wrote:
>
> On Fri, 10 Jul 2026 14:46:48 +0900,
> Hajime Tazaki wrote:
> >
> > When shrinking a VMA via mremap, the bounds are modified directly:
> > mm/nommu.c:do_mremap() {
> >     ...
> >     vma->vm_end = vma->vm_start + new_len;
> >     ...
> > }
> > This shrink the VMA without updating its bounds in the maple tree.
> > If the maple tree (mm->mm_mt) still contains the old bounds, a user
> > process could access the freed portion. The stale maple tree would
> > incorrectly return the shrunk VMA for an address past its new vm_end.
> >
> > This commit fixes this issue by calling vmi_shrink_vma() when shrink
> > happens.  Additionally, if a file-backed map is to be shrunk, it reports
> > -EINVAL like do_munmap() does.
> >
> > The issue is reported by Sashiko review, linked below.
> >
> > Link: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
> > Link: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
> > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
>
> I think the original issue reported by Sashiko is addressed, but found
> another existing issue, which might take a bit to look into detail
> (e.g., currently under nommu we cannot map (actually kernel_read())
> /dev/zero, vma_set_anonymous() isn't called for /dev/zero on nommu,
> etc).
>
> So I will address this in a different patch, not in this one.

OK thanks sorry for not getting to these quicker, between jobs atm and my inbox
is an ongoing disaster :)

>
> -- Hajime

Thanks, Lorenzo

