Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F82606A896
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipfbuUt6
Received: by kanga.kvack.org (Postfix)
	id 4183C6B05E2; Tue, 17 Nov 2026 08:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C76F6B05E3; Tue, 17 Nov 2026 08:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7146B05E4; Tue, 17 Nov 2026 08:08:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 049866B05E2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:08:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8753B120426
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:08:54 +0000 (UTC)
X-FDA: 85444640988.25.C9E61E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED39C140005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:08:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipfbuUt6;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794920933;
	b=JATfcG0Lv7tTNjhhMKOtP5KYmxEsAKtFjz0Uo1FFbV7KQp4z81KmuB52hFnGlAI0M7pXmY
	wmWkz8aLFfYNWJLjE4dfjXhiLd4FdjKDtID/HWpZTyHA8vA0CGfG5A8HMUYoygE/yAMQ9z
	lZnAAC58IEojDw7Xo38EXeMzJVGxgUs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ipfbuUt6;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794920933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqr3O4xFJCd//nDRyguxXGm2AzeSTGRjfBy3lG9BNl0=;
	b=FH4tFokz9Ul6VOe96/FKcGAK79CTIN7LL1WVhLZpjLXSe49xslcbKbPnrnF+6F9WCd7nWT
	sR2klKSOF73cibG05BRh2a3ixLccM4DyhQ/9wymalGfk1QBGjW6GVZGlH05BxcROjCcevL
	ttvKZHn8gvUOR2Py5xWaw2Sy1o4c+gg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A205618DC;
	Tue, 17 Nov 2026 13:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612531F000C4;
	Tue, 17 Nov 2026 13:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920931;
	bh=uqr3O4xFJCd//nDRyguxXGm2AzeSTGRjfBy3lG9BNl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ipfbuUt6iDNEvOEcW3itwqtyZzyCe8HrMhOaBXpKKWm20mDPL+NLsT0N38Chk95Yt
	 h0xp4BybsS1jpB8bMG6cLoYjojA3Cn+nJDRdtdgESdiuC5C3aafZj0dIeChoxOO5Jr
	 qHywk3g6C+YAPUfwUjPwNEHo/Md77D5e5bOk45MQHwjpwHk+BUz8aJzWKyK4jJ/sQI
	 fth/+iTBhR/UhlXnACdWApYiwK8FcMuNf4lVM8XzL8SQ4OYK1oxnYZBVFtjIL9R3XY
	 YS92hpKXgR3cYXUhH//A1zw6ZrrMXLcfQ9eCCCakebmlWAfAbtdrmDQjwlQuUkLTvl
	 /5+m6pC7wTZ6A==
Date: Tue, 17 Nov 2026 15:08:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
Message-ID: <avxR3PtPa4Zh4pxr@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
 <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
 <20261116152216.165348Aa5-hca@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116152216.165348Aa5-hca@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED39C140005
X-Stat-Signature: 3osmf8s1khie5y175xz7cfrptiu5wsto
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794920932-368774
X-HE-Meta: U2FsdGVkX18p4NCfIY8CNDmmc+KR8x2m4Tj/SJloZKa1WNKN/UsvV45omAHG3WeLqpPnJcXF/VzWaXRuKqIMoM5ER6cxSo83MDDf3SHSn4rFAAzjGU3YmaifVrBFt6I8qCb6+eFBLLdmer4JrTueMPseaq5N1DrLoYaABudcsfi8iLK/448hHO1mtkHfc84Mwss7gCQHAYi6JnufHVzfU1mrZvY6XNlSCQpkjjZYPyoBzJoW2cobLPmjc8vGJ4DMHRSi+UhI00VC9JrMancfZ7W4JsUrg03braVxBNIUDltp5LkbpyoPeofndzVaZ5R818IFuCdhnR4+dC6z13B+H0X8M9oG/yrO3R4RsuZXGVQIKlfWv/zQ6LM2uz1+kLqzkv3uEZPOXozl2L20JItizU2dUBFVn9hTaopTtlvjtwF0iAhujZTJ2sc9QbvoyiwSz1NrEDbXY+J1rOCEXn2KyzJgKWGUE2Roy4dhVuAT8SbstKw+TQUjswxa7E77qE7muNAkp4nuS/7qCqgWUEnu6mQl1ssGgxShX7wJABlmk7ItdFYyEoMcA8UlvTd1WYQ5TDF/ubcV2QatzTcXMHUNhPZ9nFEY9aTzMBtEORJQdDuxdYTuL71NYpsADGOdbJWjXTCinweLk1Tb9QRHBjAX/Bj+PZvlONcRJdFR71cNzAGKpLv+JZOsAoRH3Y5euHN8S+CAZKCZglVwMoipN/M6urJ3cwYYNtbyXQ8ooT3yagNuutnAqBNaBUvjnREA+WBcCzrTTQ3JIaO/PNe0DrS83qnj0syrA6t6DAQ/lLRqtBu3+LkAAWDz/H8ZMa67HgDuh9oaV5AHrXPAJG+eiR5dKhffyLYu0sY5eS1oeMX88LKRzDEtzPlAz7E3SIwU9JUcEFxCpzYdL+Px6GxnafaQgylvnFYHa693LdczeVE7f9pG/5aycHs0U8liwDWH7RMuxCNRKpgMFHwsu6hcBvc
 pNd3nDdU
 Uj8eOi/rRx8p07RxXjKnN2975lcKun6tJ6qIDYO98E+Mrln6Yml6c/1UEtbDZcMkHWdA5gP2pIFmWwkbiN54qCb4qlBkCwCLAqsDEM4QQERylCuaiHKS6ZkjTBp869mpxzdep8zxBstY9NZnhrFUBCO8nkIE8kN3+KqxdpN2oJJxDK75A4ioy4l8pCL0QHfpkGAZ+5gdLxn1lDJfZ7mIn8AbZbQmDNU/t7Gz21MS24ihuH9gBm1yd+U0DgISCY9aR6AGPdBXa2GvtjTMmGJDJ/VYpVNF7Z4mgMJql+QXmVHSIHPtFpVcpWR0JeAq229mK91QW1kCMiqNxYt2mMfXgosDvZbxfzTC8xcio
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:22:16PM +0100, Heiko Carstens wrote:
> On Sun, Nov 08, 2026 at 10:58:41AM +0200, Mike Rapoport (Microsoft) wrote:
> > _sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
> > allocate the SCCBs used to read the CPU information, to configure a
> > channel path and to read the channel path information.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> > 
> > kmalloc() provides a better API that does not require ugly casts and
> > kfree() does not need to know the size of the freed object.
> > 
> > Performance difference between kmalloc() and __get_free_pages() is not
> > measurable as both allocators take an object/page from a per-CPU list for
> > fast path allocations.
> > 
> > For the slow path the performance is anyway determined by the amount of
> > reclaim involved rather than by what allocator is used.
> > 
> > While on it, allocate only the amount of memory the SCCB actually
> > requires in _sclp_get_core_info() rather than rounding it up to the next
> > power of two. An SCCB must be page aligned and kmalloc() guarantees that
> > the alignment of an allocation is at least its largest power of two
> > divisor, so the extended SCCB is still page aligned.
> > 
> > Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
> > and free_page[s]() with kfree().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  drivers/s390/char/sclp_cmd.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
> > index 1dc93d945be6f..6aaf1f6a3633f 100644
> > --- a/drivers/s390/char/sclp_cmd.c
> > +++ b/drivers/s390/char/sclp_cmd.c
> > @@ -102,7 +102,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
> >  		return -EOPNOTSUPP;
> >  
> >  	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
> > -	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
> > +	sccb = kzalloc(length, GFP_KERNEL | GFP_DMA);
> 
> It is a bit subtle that this really works. EXT_SCCB_READ_CPU is 3 * PAGE_SIZE,
> so we end up with a guaranteed 4k alignment from the slab cache, which is
> indeed sufficient here. But this is really not obvious, and not as stable as
> before, IMHO.
> 
> I'd prefer to have this changed to:
> 
> 	sccb = kzalloc(PAGE_SIZE << get_order(length), GFP_KERNEL | GFP_DMA);
> 
> which comes with the same alignment guarantees as before.

Ack

-- 
Sincerely yours,
Mike.

