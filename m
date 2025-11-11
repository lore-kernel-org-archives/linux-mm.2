Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38072CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0BF8E0021; Tue, 11 Nov 2025 04:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8378E0002; Tue, 11 Nov 2025 04:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5548E0021; Tue, 11 Nov 2025 04:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D47E8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:59:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0755C1404DE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:59:53 +0000 (UTC)
X-FDA: 84097879866.23.E736F02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70C5C20008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:59:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQEDW3Fl;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FyGQez7pvyrljUgUtsWdyef129PSJdGth4p3IkPJoI=;
	b=uNKs8b0bKPNB8DVhF+fOOrDxPv23OJZxyLjwXBn29l3Y9bFKaXjXGybxlSHZxyHhm/WO7B
	7oMHJ5MZQBUkQ1zvOTuK32yZt3c26NmoTKzNvgVHYhkzGVXjXMAaeOh9nQJrt7SNY+H7h1
	UG9GHbEDGmjuO0Y36LHKZEL4HPlWh0Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQEDW3Fl;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855191; a=rsa-sha256;
	cv=none;
	b=f+u7g6ypTakMEcuTs+fOSXIDCvWvNzQM6qPadlFJUT8mWOPK3naImbrqOihpxix1qW+c0P
	L4XpCIN43x9gDeHn/MVdAxqyV5KLYZJjm9pGETaZlY27SmttZlhd6CPOcrjBImu6v5mZbF
	pDuWXxXG2J1ZH0YtK6iv5T1Ar9jJGJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D29BC6190D;
	Tue, 11 Nov 2025 09:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05460C19422;
	Tue, 11 Nov 2025 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762855190;
	bh=8N8GqKjKVmCcW3FPmEMuf6YYiwxcbop3EKSwjq5wsII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vQEDW3Fl5K0Dvr5C3P/+Eri/nAbohVDuKI4XtVOkvLaGSgP/SbgOWEsbGFspy5nQu
	 nFSoIgCeKhZ8/np8jueh2RXyHgwigbhdfUHpUnrBccm5ghZqyZs/wLCKTMgp0+U0CU
	 UPKoeJ2L54ClBnB/Rj1h93V3TjtFJZw8KljZ0eIEGh+5dWcujLT8jdVHCWGOleCi6z
	 GNs67YgdA6V5htKQOI+51a5LLw3fXAW8w8KEgYkck12568Nm42KYxcDgcTA6wDqp5e
	 8LAJFtg1p55l16dKnc2Umtnzf4Ozu7FTOrIv9JwSGA1EJ5rJFAOmtJMYh7ssZ40DCV
	 k3xHyxAhkViyQ==
Date: Tue, 11 Nov 2025 10:59:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] mm: Use folio_next_pos()
Message-ID: <20251111-droht-oasen-449486f7248f@brauner>
References: <20251024170822.1427218-1-willy@infradead.org>
 <20251024170822.1427218-11-willy@infradead.org>
 <aQ7ObHvd8FXb8Taz@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQ7ObHvd8FXb8Taz@casper.infradead.org>
X-Rspamd-Queue-Id: 70C5C20008
X-Stat-Signature: cscpj43tz8q1dzjo87m9t1sjw86zwcbh
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762855191-713866
X-HE-Meta: U2FsdGVkX1/Z8S+o6l/9o2EkfwwXQnOO/MSR525UGHtAoYVk/v78kB3fMdpva4ecC3Acq2uIl02LwLWjaEvsovGuLJQVCTBVOg9exk+tEEYr2oL388fF+Yseef25hsMbGAv8ZInHY5M69f+wNNGgqiWToNxi2aD4jycLofc4lWUcOY2Bsw1lO6gfKHuSKqG5hFrRbGtQsMKTouaP+oSUhwi2L2FsOS012i3OLRvrcurTCpkHCrfO+hXFcNXa2QhOr6vnrbGtuKpoeYfIFy8iDhdFj/zQoCB3MFeEscCo3Dx1NmSuRznqgIjhFgi9xNRoEC+ldu48iIVrZ6d4pUlVAAWXF9OgpNVRTd6M1opZxw7QvUjlDuxp3rpkUX8v1Pg2SgN2jWVm19Jbv5QmdpUOGj0VEZAXnDLkyOiaB6mCSCpfmhSyyqUFI39mqBG4mXP4wb7TNeZM35kIUsS6aCQBB9jYjGy598rnXI8RgkZp+vJjg/9HS4ri2C0ejYedSIp9msQU7ai7GeGQzQ1VU3c6lctWj4XGQAv35VhldtRvwakj2i+q4Yan7+Xp4usIx1N6NEpJkRzMU8v/81xVNDv8LAS7I+abJweCiuASYjOCinV9L+SxKt/uvxYr9oY6zLdF4b0RGXRhbSxxgBBjLvgF1XBeWEQ3tTNIeja4pVBemTTmutJJNLTjoKHZ1IBOaPtVIjSnLR2JHGoA3GaDFcdzu0A2AhJjqWjckkGtRt/+R3vDqTaM11fJSEvY3XcAAvKy/6ACg0fcJlW0JQE5AMHOJZ/h69PL1W5OEBCkLS4ISUrkWUbGb8rFrtCuxb0B4knhnuSmODvDbFnK+9LNj/duGLuodkCt8L08hlub2wvwKd5zG9DhxSWCELwVhxpHaR870s6XDYe8vDRSUlDnLmPeklOGHSCScELmp8nVhp1IgO/NZvg/8YsNU7KQMsyuvOAjLR3o5zD5UdYayg6R3lP
 3fO5WioF
 j0zKL4Il+I/qL/cbJxmrg2vFPUtKk/9Ny6eC7kJBbWH/MsVbq2dNJOInZhSC0Xf3tnmccDLcCbxa8JWwUAC380nDU34QW6ZaUlPerPqsF8ExVveCtgLqUt1YEcFDOz+P5LeYjPGPlrsmneYbaVB5duxAn0U/xW4ZFZNQPmsb+pb6mCuRfE2rtiYGZkEtk7S/5Pg/EE9dIrDftLh2eBAnpHD8/NX/4kzlxVYWkAExtYFYOMzyAcNwvi9t2sABOylwbpcTqMG/rnZxpqV4j2T3AUGZI5Cbo/nGsoqjw07lSEdgylAb3EdB747hzxWtayydP3PWtXEDISSLZ/umN6eajeaVrU8IZW3uZ8wIDb09ofYVQjKgj+viOpijvGvbbKar9pk++bOPhVYaewBgBISlNwjPAOZoYx62W6zQvt2BokhwT56I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 08, 2025 at 05:00:28AM +0000, Matthew Wilcox wrote:
> On Fri, Oct 24, 2025 at 06:08:18PM +0100, Matthew Wilcox (Oracle) wrote:
> > +++ b/mm/truncate.c
> > @@ -387,7 +387,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
> >  	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
> >  	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
> >  	if (!IS_ERR(folio)) {
> > -		same_folio = lend < folio_pos(folio) + folio_size(folio);
> > +		same_folio = lend < folio_next_pos(folio);
> 
> This causes an intermittent failure with XFS.  Two reports here:
> https://lore.kernel.org/linux-xfs/aQohjfEFmU8lef6M@casper.infradead.org/
> 
> This is a fun one.  The "fix" I'm running with right now is:
> 
> -               same_folio = lend < folio_next_pos(folio);
> +               same_folio = lend < (u64)folio_next_pos(folio);
> 
> folio_pos() and folio_next_pos() return an loff_t.  folio_size() returns
> a size_t.  So folio_pos() + folio_size() is unsigned (by the usual C
> promotion rules).  Before this patch, this was an unsigned comparison
> against lend, and with the patch it's now a signed comparison.  Since
> lend can be -1 (to mean 'end of file'), same_folio will now be 'true'
> when it used to be 'false'.
> 
> Funnily, on 32-bit systems, size_t is u32 and loff_t is s64, so their
> addition is also s64.  That means this has been wrong on 32-bit systems
> for ... a while.  And nobody noticed, so I guess nobody's testing 32-bit
> all that hard.

death by slow degradation...

> Anyway, what's the *right* way to fix this?  Cast to (unsigned long

Naively, I would think it should be an unsigned comparison for u64.

> long)?  There's an ssize_t, but I really want the opposite, a uloff_t.

Fwiw, I don't think anything is stopping us from defining uloff_t in the
kernel if it's helpful.

> (now i'm going to go back through all the other patches in this series
> and see if I've made the same mistake anywhere else)

