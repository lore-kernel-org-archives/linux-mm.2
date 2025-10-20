Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DB0CCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8178E002B; Mon, 20 Oct 2025 10:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAFF68E0002; Mon, 20 Oct 2025 10:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED068E002B; Mon, 20 Oct 2025 10:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBE908E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:22:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A39A16019F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:22:19 +0000 (UTC)
X-FDA: 84018707598.10.A1A5438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id BAE952000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:22:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qOEYPKlV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970137; a=rsa-sha256;
	cv=none;
	b=tphxIttHxGGQOIXM1IoCbUzlOYGfOXKa/Of2s9dOavdi74Bvy/DyrzJMYGTOt4bMB3MJdA
	YOrjTzQ/wmWnG1sRkhUEdRHVflbn9Xy0FsNJc8SldQFqYHvVnVpDZv4E1Tc5SLkTtC6nkK
	t14cSCOnjtm2iWfLXhVRHnNOlungdXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qOEYPKlV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTbmtPL+GVMZ/XjYby1vk0CgMz0x1kZ84Qk5nn4LOxY=;
	b=J0M4Ldf0xALzayIOisHyxGutD8SuakWN6jMQkxbyBg/nre6uPbTRzAIKkkyVZR2jLqdysS
	TdUmBxI3E+6XXmiee55cuhxlSLVACbeTigIWny6xo3vJwq/J32GXyLitReLX7R4WuEMSk+
	DnV1NAeubl7uat5yb5ei2biM8Hep1pY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA0A448AE5;
	Mon, 20 Oct 2025 14:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75648C4CEFB;
	Mon, 20 Oct 2025 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760970136;
	bh=qOGvrUyWMkbXW0aor7OjBhhMhyhG7u6zXAhr6PWEmxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qOEYPKlVD5b7dQS9Cd5Trxa17EZFodO847m+AxPxJKxANdROjH5zHfY5C99rf18Ki
	 7WA+SgU1bPaP7uutTLwkYyMFsYs9IZOoCLpfvcy1HhKjHUtNDzwUMOrlxF8OWqrodG
	 t1w93pRnhvXM1pcIk+6fZoOZAm5OB3qjwZwm/TN2X4dCOKaxilutRcU4u8tShTKQh+
	 ayllpWcmmZ/0FRaZDM4JfFjqRoD657Qj+Qfm3TtAn5zVBebRMdmGmW8Wgw+BLmYB90
	 ONYxlGJSfXtHZzWCfKlGhOIqRSfZBW3cUjt9DAu7VJpP3mkrtPCt9Pn5JUO6Wtp4Jw
	 sTromTdhvGnDA==
Date: Mon, 20 Oct 2025 17:22:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
Message-ID: <aPZFkFOvJ-hKfC3J@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <aPT0zNMZqt89cIXH@kernel.org>
 <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
 <700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAE952000B
X-Stat-Signature: x6wbt3j6d63zo8e5wtqugz8pfzfafzni
X-HE-Tag: 1760970137-208224
X-HE-Meta: U2FsdGVkX18r19YBfIKQ+BMKTJcxaKfO+jTdHeOAxx59c4ASZf6S7wHWQ3YotOsAw4TL16YnWsSEOCLp7LDrzRNHHJ3/lUWnk2AV0HpgCno4oszHb+xQcqwx5rxWjwbSsGQuiPU0GOH0kvxCrnm05Lo+GqyQq95tGIiRRNdVNhNKVYVWGowt2he9k4iokd2i9pZzvPRsoRRZM9mqHx9NYB76xX8xuU3hbQ+KUOlya+lQMxuf19yHItBbXPdC0sb5PdAMXczuwbrz+abSnvUAb0+Ri1vvAIM+1jyfMSEsuLwokbnt1AKw5oBAMiE62C3BdiN9dCssW+smxYatU2rYAG1UNlUN27ptecHYUwdIDDbOyhSTUZskva3R9SdjL13OhcJkKntgEi3ub1VPHjpQqgpvIQUlrB4/3NNqlbDL9TnbwcjCr8cEn6SCp4i6uwL+3UDGWhxBFm/KeAe4XDwyLd06kea/7EaVzjKz2wJV1HD4PKfpSUUmArMZfRwhckR9vdBgrxxL/uh6l/NC+vJyamS/GmA3INzTMlxJSUbkE0iU5gVTK08ZbBq8JQkzYVHKurNkcFSDYCLeHDA0cnPt1WwQLpovl/a6z9eobb5R62S5zmHlNmGwOG7Ndrpqc71I0QImI+BRN2PlEGzug44efa8a7MdasXJKW+sULDfx5wMr8+E6MfueKI3ZgFwXLr8xJ2zdmmnj8/Xai4AXXO41rn2l2YoccAtoqYmB5CD0JRNy2cd7goKKOU48gQcI94Kc54qjafZB9AmZq7B9xc24o5P79f4aMm3BzUCMaSvT1CvxFsYo4KS+mthTdIpGLObJTgnPA7McPe2MBpX+CaykG1v80Uf3W0pD22VGv5XTFU0rTwUZs3TvahSQQaulTOmme83dcTJmJT3ssTltaj7DbVox5iJnAY1GhjU0t3cYaXdQw2FOh1cmF5pNwWberOQ/yc1EqPad5kc/ski2ZOI
 Bjk3RvcP
 onDdKgWYu1+nzqM03AFxY5835ALs5cPjemUb9jm0dlk3nxkAsVDue4XNwtsKoQsfeKCpdthUvdhGbKI/VcIg/AaHRWq5FUABGv8h4Ohiy3iqvbji77pAaXjw3Wrp07W61RnmpofHeK5nTdAhqmK6n8bLpgYGpMSLUoVLtsYkpfCMEigeq62USr62IA8y0mVg0ueydMmrrEOexTjrSC2QEWKyDBm/fckezwcboJ37hVtFDuVr8Q/5fFfxI2R8NQUbelFvddwa1TSu7bRU1TIYRb/bwNGGAKfW02ts4s9/5k3uFe7Wk44jzHyc5NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 11:04:26AM +0200, Jiri Slaby wrote:
> On 20. 10. 25, 10:54, Vlastimil Babka wrote:
> > > > Most of them shouldn't be using get_free_pages() at all, they should be
> > > > using kmalloc().
> > 
> > Changing to kmalloc() would have to be careful, what if the callers rely on
> > doing e.g. get_page() later. It would however be useful to dintinguish "I
> > want a page-sized buffer" (note that it's guaranteed to be aligned by
> > kmalloc() these days, which it wasn't in 2015) from "I really want a page".
> > But many of the latter cases maybe want a struct page then and are using
> > alloc_pages()?
> 
> FTR, tty appears NOT to need any of the specialties, so k*alloc() conversion
> looks sensible to me... OK, I can re-revisit that and do the work, but give
> me some time :). (Which means 1/3 from this series won't be needed.)

I'll just send 1/3 as standalone patch, having DEFINE_FREE(free_page) is
useful regardless of the conversion.
 
> thanks,
> -- 
> js
> suse labs

-- 
Sincerely yours,
Mike.

