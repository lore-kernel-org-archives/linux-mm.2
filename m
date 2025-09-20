Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA38CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E2F8E0002; Sat, 20 Sep 2025 03:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE388E0001; Sat, 20 Sep 2025 03:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3D18E0002; Sat, 20 Sep 2025 03:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3899F8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:37:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC51413BEE6
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:37:57 +0000 (UTC)
X-FDA: 83908824594.19.895C159
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5978140007
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:37:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mXWMmdl5
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758353876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHaax7Rz00c9vFQT/JhxqHrgqD3fFm2wFC0viZSdl4I=;
	b=VKuF9wOWVYmBnJx8S4A57Dgm+eXU/jMkYKpPtf2H74aIjjgUx+bwAz+YvT8CUKXxWq2kun
	GNwn8fAqHWPl8p4Quefj/djHY0qgJ3IobQd5JVVULE0IG05Ozol9j4BmWTIiaGyh+3qIlV
	XveJyvHHuUbijAFgSaH51pvSWOEBv1E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mXWMmdl5;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758353876; a=rsa-sha256;
	cv=none;
	b=zMg1AE1g8739Sj9nqNWbvDcPu2FacBzThCUYu8dXC3KmPR6Ik6D9xVBM3SQYAF3tT6Xw5U
	I49bB9RPo7ZEtmID91T07AiLHPEnUtHUJfpSExpRMVIdWNuv+5CZlBb5Gfx711AfUU6FYv
	QxZWdvXOZN1BlZBTIhxuziwA66Jjv8M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pHaax7Rz00c9vFQT/JhxqHrgqD3fFm2wFC0viZSdl4I=; b=mXWMmdl5kLEm4+UDhOr/AgwpY7
	lRvpWRyETigZpmL7CIaPctuPDiqpNCC88ttDDzEfptvO0DBTMWhGn9+/V9vqVFCSUgsaYLnZoiH5U
	P1wufcF5Lztop0vjDD1VfsfBudfNqBX8DIyeoL8Mg9cbh3joLrnaFn581Ox+Uy6KcFtNGUXNkGEKt
	H23Wctaf5ZibDgMfH66AOBzBaOVnDrAkbG2fDPuOP0GChK7zG0IZBc7c/xco5ykcLqJyGfVV5kF/b
	rG1+a+ebXBSoWfdXv2+/OYp5Este81iuNxsZPQd68sS6qPi5jVdTjt/a3glV9ZYXLsV81xizTaP6Q
	sAadRipA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsA5-00000009RaC-0nLC;
	Sat, 20 Sep 2025 07:37:37 +0000
Date: Sat, 20 Sep 2025 08:37:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 4/5] mm/fault: Try to map the entire file folio in
 finish_fault()
Message-ID: <aM5ZwWiFDOuSl6C5@casper.infradead.org>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919124036.455709-5-kirill@shutemov.name>
X-Rspamd-Queue-Id: A5978140007
X-Rspamd-Server: rspam05
X-Stat-Signature: ubz4et6ar14xqxmpr1dy531ed333xs4w
X-Rspam-User: 
X-HE-Tag: 1758353875-799633
X-HE-Meta: U2FsdGVkX1+FXHvww4QEQqZsYULDxPHBJVaUxcw+8F50QQWsHAXMAnbl9JQzjHKmbQBDsZu83Xyi/KP8pi2ybh/D9amo/Buewg/NdcBSCu0sJbOTd6z5+tjPq6AALPKg39B/YqQn5CDItmdSESUH3Qtx2K9m5x1V9Hu3ObRrPgbJPPNcrxkvKKBsQRd18+10FxlOPF467pJOUKb+b/UdIbWnKaUNI7EY9ErTbj8x/lo43GB3wscHaJxuBuv2mB5NOg+ljhaM8E714M34Ik1nispxb+TW8P//aF0ZRTNxtWVf6RRPnZ51w6uGR63HCVi2YprphOZmr7+hrwiGhZvE3/Xn3ZR09JRlndyizgyRylNS4DnO9GyqK9hThpS37FmiPWzQyA7CEgsdSrOH7PJq+1qxIVWxyr32z+8ZaaNIaTjmTNyoqNnGOUdw6xP3Mwh7T4dxfesSfDCZUD8qT0/9f1IzkhE7imLeMDZUJ/vY88KsE3hCzDATju7tES1z2PqCm0SsMw0l5B97mOrnaWRSu4Q3G4thHw6wH8bxKqu58TIgLAnuOYS2NiINZb0wzshVdCnG1X5XlBcrMM7V1dsMSCTNNDinCxSoKpXbpR2cOcNDhZY03SpE61ALcqigJd73bug7o+XxIXHjb/7xod6hJpn8NmLh0h75FRHHiDyHdyZg4Z8tCfi4Emi1BNin2042FooD2vYv5pIsWTMWTqqkT4Se23YX5SWogvpLRC/egsMoD6EKWWoAyOt9mUQcn8xPo39WOsW0DbhDJZKmvhTPYH6TVub6bS0Wb0xHWwsBKvaHmHRrS5zqhvNtGgEBhdFk1aJXwRwTpyrOiq+uuVGx0P2j0VZe7rmHn86TOymMtZ7YBN6FE0FVidHa74vabdpZb7iwysKXUzqMU53sgFphWwFDYNXOug2xoJ1juJHiOUZ8fPDWvSkSG33zdCqM1PYCT8h1kXEfTjYN7xkwTnV
 28gw+vBE
 l9AZR5FRBxJ2rUcnWblu9Y8SXdTQBR9f5gfkLhd6f4rWVxZmFTsRjCBoEB8SdNBrCrojK61YyZRHEi4NyC0FK/sRyNgFCfDMXYbBz+CVYohjPz+Czg+Wt0fN8GVS4xJzMHLskPZSOhlTIzgxoxhz/tGecQ61gWUWfVDerhIeAsztTgGfhBSehpzSl5Px0dd0YBD8OmATEU0DOcc1zygqeFdUVkhj3OlAdjTnz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:35PM +0100, Kiryl Shutsemau wrote:
> The finish_fault() function uses per-page fault for file folios. This
> only occurs for file folios smaller than PMD_SIZE.
> 
> The comment suggests that this approach prevents RSS inflation.
> However, it only prevents RSS accounting. The folio is still mapped to
> the process, and the fact that it is mapped by a single PTE does not
> affect memory pressure. Additionally, the kernel's ability to map
> large folios as PMD if they are large enough does not support this
> argument.
> 
> When possible, map large folios in one shot. This reduces the number of
> minor page faults and allows for TLB coalescing.
> 
> Mapping large folios at once will allow the rmap code to mlock it on
> add, as it will recognize that it is fully mapped and mlocking is safe.

Does this patch have any measurable effect?  Almost all folios are
mapped through do_fault_around().  I'm not objecting to the patch,
but the commit message maybe makes this sound more important than it is.

