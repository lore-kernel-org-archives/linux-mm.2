Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4154EFCBD4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5006B00B9; Mon, 16 Mar 2026 03:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A29B6B00BC; Mon, 16 Mar 2026 03:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A50A6B014A; Mon, 16 Mar 2026 03:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19E1A6B00B9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:10:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C01D5D6A8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:10:42 +0000 (UTC)
X-FDA: 84551053524.01.6D4DB44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C6D37C0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:10:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdmUk3Xv;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773645040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SgBybuAS2ZGbqanWRQGV+RzQL2nrXWkZqYNpKD4FYQ=;
	b=P7cutxQzKMSQFrB+MmSx2+xrivM73Q/k33StzBQ9TFXL6YEhF8QlIPzF7JFpLh2eluQf1X
	+/PwdVmBus/6lDLCCqz9uXiPdEv6+pb3V/kNIhvJ5osxmq3ZKiiGhA8AmrjQpJbxNpI3HV
	tJIgU67Gzevg11kQlG/3/9hYkSZNLh8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tdmUk3Xv;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773645040; a=rsa-sha256;
	cv=none;
	b=eSyiWVC/wOY4A//GwIlYpOq2uDhtjzDjbuvItzLXY4jtgjhb3ZiINg2uvoiH+QT97Mbak5
	mHdC3J/+A41+lWoJlr9WkffNgI9UESha8DcrfMKBAdL9330UhW7YtH/pwEr1PfYcgb7FwQ
	enzk6aDDsYOXAjLK8ZS0w9M+M8cLhUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C3F8600AC;
	Mon, 16 Mar 2026 07:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6546DC19421;
	Mon, 16 Mar 2026 07:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773645039;
	bh=pnmC2GhPjFLjInhxncVX3Y5WnpxGERvRNgnd++x2L8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tdmUk3XvVJgXTVxu27ZbtHylwsBERi4a33TYpHhszEpyP7sNV7I6VaxOZtCpg42MS
	 ntfxTuW9gPt37XOXU58sZ0iMvszs50HRAjPoLuwWG7kxL+rVjMMgalz0GyOPElMn0y
	 xTdxomGkTsuJroFCyOhTDFNzCPFu41vy9WZhx9DCjeDKjG4uu9jtwJl3vDkx9fl2U1
	 EFppQzodUXaHNYWKda1u9CkoV5wKGPIkQKvFWCzvSP3ksRnRnOvWiN2vcCbUMh8U6G
	 bWGCf7dsuW6l2l8c/v9BiNTqkgf3H4o6ArynAJDoEKZyDvcJhLmszGYyxhcIZqVb0N
	 dr4RK4TwABoMQ==
Date: Mon, 16 Mar 2026 07:10:36 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs: mmap_prepare: don't italicize structs
Message-ID: <2ae64217-ae32-4a4e-9c23-6809582ca7bc@lucifer.local>
References: <20260315224506.1973566-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260315224506.1973566-1-rdunlap@infradead.org>
X-Stat-Signature: q3o971z41fjfr5q9mosfykxd4gdwnceu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C6D37C0005
X-HE-Tag: 1773645040-956952
X-HE-Meta: U2FsdGVkX1+k2dfz5nGhgOvtMD2ID1MK4xvzNpkEh4S933SC3QKZEzRKrRUn1Uen1tECOLuks7Dy+AQDa6qKltAWDqkI4udRchkFJedmoOot9DmHNrzf60BtuNbO4SuzspD1ZqtpZsvTX9nEbeWsjvwQxYBBr+8fmaUjVJJKSd+Cw0MDQ8SINAF0W7aeMC6y+2ipFFLk6vvkpBUpGcxM/oP/6fBvdE6o5UFB/8OcZe2n9e7GYz2/KU+XEjGiyABKYghp6f4Iihygo0zBcWwps4XVRnQc7tmgWPFIyJFhMSmBLh+yvnQSuhVtIUKPTUZK1IteFTOfZKiQCHs3TqDJAsRtJ+HF5xRPRtwbZWGX/vt8VAY/ptT4liHR84y61BODx/t4tA0nXR056JViVdqRh/U7mAUKXQigP7CZhh4SWDYkjOMTTB3st8Q7u/Wd8gXo0SJja6Y2eelOhHSF2aY/qnkRipCFgEoV0UO1CbnrfRdGVXJ0QAHgxj+YZ0nPk5da2ISer/+ox/Po5vxVHo2w9N9gUe9vlDnBGpi4VJKoKEDw4NGVLS82sgphLyx/L7R+QdayX0DhHHGx94f+b/N6T3JaZoRam3nBxEfFPxcYZrYr4fTtG+9fkFtlSBXNS5cGyASQE/sh10/IiwEqcHlD/lUhYQJRRFwGROWf2ezxRvzNGYz2chSNxJActKLVD5NzzST5W4yBcnVB5uwgTCG5adRX7XUMMRmMpJO+jOnDrJg1EQrBmoc/V2f6JMDiqbn9cDYVlHq5fzhgC/cSiZwIWWYiUzSkpREUHD2AtVEB80Xx3wJYzg1E5Il+uoPLvoKZNroTcfBkoMN3gM4hD3LdlFLDyp6zWC5vCXVypTNZym51MwWlZVZwuvEBzhCPUkcXFh6gOXJKPkArHh3tkXeVBURKBErq1+WVASY+bYUtfb2ZtSDW5tfnxlYxwbIUSJ39BoIziTa0NPo2ithGp1F
 LBeo6zUv
 3dq5as5M8sUiciq1BvutPgHnLgG+u3HifBKBWBBkZZjbqR/BoYUnkrqfjLd/vZUp1lOJAYP3sAWyhr6Hmiw2pr8AEG2C06mYYFTaWQ/fxTBwGgYkvep9AG2fHbRmaDgleFUMiWNdIAizB3Ioe14/137ZHnbHT/qgEHI32ilcdi3mUXZxN6k+Hr8oHEnuO+yLfA+IJlmyXCbZh0JgEPuJRZ89OO2CB6hw3/khtZdRSHp8Kdszig35dfgFgtgd8jWpi5NTqJ5GgBta7yS/p7WqlcRVbbpGMJuW0T0UNl0QbOrmk/02G7PRQfwh5dtts+SF7xP35Gz9PVU5xONDUCNtvacKMANxesbIsnCfRRU4/xFZMHBJpANRKy+MjByah2rDxO8DDHohlrijWaak8qF7WrDLXxidSzcf8dCV2AhrEaEiMV1uMtgkNM7q/riPhCJi3fKF/rpx6IxThJas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 15, 2026 at 03:45:06PM -0700, Randy Dunlap wrote:
> Using a single quote mark `struct xyz` causes the html output to be
> produced as italic. Omit the quote marks so that kernel-doc's automarkup
> can make the "struct xyz" bold monospace ("code" style") in the
> generated html.
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

This is fine, though given this series is still in-flight we should just
fold this in no?

Anyway, LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
>
>  Documentation/filesystems/mmap_prepare.rst |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- linux-next.orig/Documentation/filesystems/mmap_prepare.rst
> +++ linux-next/Documentation/filesystems/mmap_prepare.rst
> @@ -129,11 +129,11 @@ pointer. These are:
>  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>    physical address and over a specified length.
>
> -* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
> +* mmap_action_map_kernel_pages() - Maps a specified array of struct page
>    pointers in the VMA from a specific offset.
>
> -* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
> -  page` pointers over the entire VMA. The caller must ensure there are
> +* mmap_action_map_kernel_pages_full() - Maps a specified array of struct
> +  page pointers over the entire VMA. The caller must ensure there are
>    sufficient entries in the page array to cover the entire range of the
>    described VMA.
>

Cheers, Lorenzo

