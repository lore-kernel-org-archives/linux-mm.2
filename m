Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4003D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d1vONByq
Received: by kanga.kvack.org (Postfix)
	id 5A1726B05B1; Tue, 17 Nov 2026 14:31:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551F26B05B2; Tue, 17 Nov 2026 14:31:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419D66B05B3; Tue, 17 Nov 2026 14:31:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222C66B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:31:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF78A160579
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:31:33 +0000 (UTC)
X-FDA: 85445605266.27.2040DE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 20E9A4000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:31:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1vONByq;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794943892;
	b=vshyZ+cDS+qwAcEH/G0gdty8DswZcOAfA6gGGXTRl2ZmD8SGfOOYqQ2V0dtr4G2W5tnuNm
	Cgauz5tevJKXzdNpzIK5/kbrK1WxKpqZZQlAubtsv9TTkyWIjCN2I8GZlI0taLtlGBAgwG
	hNQ9leXO7CEeFkmiaCEgBrIDjnAEZKE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1vONByq;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794943892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCo75ty0Aujy0KouEOqop0m/uhiJYaP585U75o493OY=;
	b=7PCkyX9oO6WBwa9q6qvdf7lep+j2FfdOHsGNE42Dv9sLhyG5/Fu6+uPrP/o90W/0VKCD95
	t0ygA2LFDyp7bPpK+VUb0b6tAAKTg0iaWa5odXWv4Nq5k/62Z83fW7X0ymIQl7rO2Pi8Ox
	R/5oHNTkUrGOPCEbuIb3ev4ouRH4iss=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C67541349;
	Tue, 17 Nov 2026 19:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038431F000C4;
	Tue, 17 Nov 2026 19:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794943891;
	bh=nCo75ty0Aujy0KouEOqop0m/uhiJYaP585U75o493OY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1vONByq+DDyy6hoJWEKC68lOH75ploQoY1NLx+0O5oC94nqHsUDXPalbkANcNki6
	 ++gQfJgcvQNpWgizWI1PgBa+fCWPvowl9hqQr6QanrmNsEUacbVHokluhHkK+XJPlb
	 Sr7iAfbN684agAd4VT2T/gQv95c2KbCwBgq0WAeovaHc5SNxGdHxXDUlet8x5Lgx2r
	 fZ5U7rruCNi1DEt0M0d8Gb82ZTOBYeLYUO9X7KcFh1feo/sW7kZ/VHTRbPLlYvDxeE
	 gdWkQcIvOHAE3/GUJNQ+QVtVpvwuVAblhZglWCkd+vkKd3kO/kcAAFgwTI3MkWFWyl
	 QdSFrLqWqfj9w==
Date: Tue, 17 Nov 2026 21:31:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	Jingyi Sun <1045704958@qq.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Message-ID: <avyri3PoPUriTmxN@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ae17206-829d-4fdb-afd0-cc14c5411b74@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 20E9A4000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: s6479zhrdoeaychzzreijeszkqa84kz8
X-Rspam-User: 
X-HE-Tag: 1794943891-685597
X-HE-Meta: U2FsdGVkX1+LfvWrUp3iYcNoLI8j3GMDaFQgQRh0TyMllmWGBaP1GvwX2zfQb6c9l8d0ixutBu3bv9OMH5qMpwfliRp3agKRVB4dZ7J4GIwbrTFByyowJE/H5aU8wde8/3nh/LQVJ7iJfSK5kWZvzy8DAXsZQ0HRwO5ZrJKu7/AbPNUlPdK+jGhElmOmyZ4rVfaes2L9pCZTKznamVV2EbvWNGIrO1i18sY8hrjyoBZBp8qkMj4ekr/lcDan2izvmMz5mFdpZl8SItAcBExGCBZCYrpi4mEHuQkPIgx3c3C4HOjxrBYUjXNMnfLqJWDpVU6ORFmjdbr3g/Fic7Br7xPLi1aorTkTRw6Y4/BmSTFGK1ib4GgsFPKLRcWHm9vwV19kfI9YJf8SkyK2WpML4ztCTBWJGtKQxsL4Beet/UeGx/NFT/nfTGm235FCchCkvBYUbskVbZQfcxwTAeTw2E8okQ8xd/kvyWhF5bdvox5g/CYptYXjLQtOM6WtY35rCIeb44Adfs/mWZJpRMcmBdm/INw937kmb7MJp8m2hvxasBcO0n90aDGCWjgTctDS1RFOUx23KeAZwMWJI7EvzZnu+7gmTHDUex/SF8gGZyq5pEAjlKRZD0cFOSGx7Fo66dcNRgya3SO7wtBEf58Bx5bcR1bWL9acTNq/fBCAFziknvblSU2IIhpFNIQnBNO7cM6wGhzQVPNPEhQWSVROj3NiVeZhJA9PoX2C14p0YikLev2l6JT1DiLPsT9ZwWmil+4SEhN+Uw+OIBstWhvJ+28j/u/XRMJJRobNoqieUiFVAApSaedciDd+nQz1AwUPk9L50IAeqBZ5OTtau4ZxQKiRrnm39iY+o0vTmCYY4M5TIb7xj1m+etx1xAWT/LGBohIh2AlkooYTn+6VtsJlXm0342XFNXMP348xweP8A4dZLdkUuyFwAgVGj9OnObIm3jsytS6lfB1GKpimqL/
 xWvTEkDE
 fUzhtuXdznJIhco/QPS8HnSYBnX7jJxjMMWo5AJMqahFqE/y+FfBSvfcDJdaCaBuXFSa3jgxLi/2a2+r06aApNlMHhfzfT8GG4x7zjG+NjFc/YS5Zu6Lq/rU7QZB2MvvT3dFm70M+1WxEeJxQIcTzljfDwOn/cBKdynexOHu6PkRgLBRHG+D+G3aplYQOJSM8MFwj6Mbke5jJDu8gF7xrIwuhOaXqqCYfI76ea0Lj/IBqdiYWIafPnGNs0ZBH/GvViCeHvIw1p94F0fcF1qRkcGDpiOPafabdUiqfYDvK2gY82xtnpuzj2GhLoLe8FnMSv4DZsD9kuu0UHoIXHu54x6VOJW/ZUMs4wSxZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 05:22:09PM +0100, David Hildenbrand (Arm) wrote:
> On 11/17/26 16:58, Mike Rapoport (Microsoft) wrote:
> > Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
> > refaults on reads and SIGBUS on writes [1].
> > 
> > The root cause is that insert_page_into_pte_locked() treats every PTE that
> > is not none as a present mapping. Besides uffd-wp markers, this also
> > affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
> > concurrently with a write fault.
> > 
> > The first patch restructures insert_page_into_pte_locked() to make room
> > for the fixes, the second patch fixes the reported issue and the third
> > makes write faults back off on non-present PTEs.
> > 
> > Both issues were reproduced on ext4 with dax=always on emulated pmem, and
> > the fixes were verified with these reproducers.
> > selftests.
> > 
> > [1] https://lore.kernel.org/all/tencent_1874C71D4177A1624528043E008DB1A5EF05@qq.com
> > 
> > ---
> > Mike Rapoport (Microsoft) (3):
> >       mm/memory: install new PTEs first in insert_page_into_pte_locked()
> >       mm/memory: replace uffd-wp markers in insert_page_into_pte_locked()
> >       mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
> > 
> >  mm/memory.c | 68 +++++++++++++++++++++++++++++++------------------------------
> >  1 file changed, 35 insertions(+), 33 deletions(-)
> > ---
> > base-commit: 93d7a816a2df3e907e2719bd12b0073f1285fc5c
> > change-id: 20261117-uffd-dax-async-wp-fix-867acc8dc78f
> > 
> > --
> > Sincerely yours,
> > Mike.
> 
> 
> I have here a fix to disallow uffd on DAX entirely. It's completely broken.
> 
> I was staging it to send with others, but I can send it out separately.
 
Nah, no need.

But patch 3/3 here is for MADV_GUARD_INSTALL on DAX unrelated to uffd.

> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

