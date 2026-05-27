Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9E9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65866B00B0; Wed, 27 May 2026 11:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16126B00B2; Wed, 27 May 2026 11:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05866B00B4; Wed, 27 May 2026 11:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9099F6B00B0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:54:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 378E74060C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:54:09 +0000 (UTC)
X-FDA: 84813646218.11.65D54BC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A8401A0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:54:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mvzMjij3;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3kGopIcRkfvszZsA1EUPYixmwDaQOtICWsDPOe8I0o=;
	b=APG0gXAYuEnNF3iVCft4Cj3Ip6vPNdrzGQoxSb54tKl5Wuph2QxHgqRGKLZsT7P1LxGM0L
	YRnwTANQBRrPSKg/WdsY3Xz2hy3ZEF6Ve7iFs5i6YIOrNZLZWiLOepV8NhMOVhCNeLipRw
	meCe7V6AsugjD/FZzPYXBWrbBrbK6C4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mvzMjij3;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779897247; a=rsa-sha256;
	cv=none;
	b=zDR4N0HHCwUwvWqrgcm2gp315LLLX/78lyVglQNRkk5GmtznqoDJZrRHf03rot/6vn0ikx
	E3kALA4fsTF8JEagLthoS4EX5qJ2/pbkILHYhR67sVKG2vV0B0dLhQmHKrgwlZtdWZTZGd
	BqHJNTTwqwxR0le/CSo6+F6sQcGqQZI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r3kGopIcRkfvszZsA1EUPYixmwDaQOtICWsDPOe8I0o=; b=mvzMjij3hvAena8FUDu7i/An8i
	Hu1eU+qPGpk+KN69un2RqCY6ynnqD/2F6M9QVhjezGyAMrJx/wdlz8wt54HdgxPSSAkfBwB14FY3s
	qTZHOtLeakW785KrN4qJn6cvwr03hSqJvOkbHTML6+WLBbBNx5dZ3gH3lNF4aSz2qSwBp0Qg/nPFL
	Bu4tx9SBGf17DPG2SToycs773UlYDBv2wbjjUo4dX30QS8y/nawiK+iqloWG8nB+Ia/SdGHPjg+M3
	7+iHzYuRReuZ1peI4KDzTOMOmRXwWNkL5zGBmX1Nndy06qsRfeRrL1f5eOsKifn6NSQIn5a/0DR70
	njE9hAcQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSGa5-00000002unM-1n4L;
	Wed, 27 May 2026 15:54:05 +0000
Date: Wed, 27 May 2026 16:54:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahcTnfk_SjbN7J9e@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
 <ahXcsrxUFfzoVCOr@casper.infradead.org>
 <ahaNpbG15d6StT9d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahaNpbG15d6StT9d@infradead.org>
X-Stat-Signature: fnk8h6q1ht65esmemorkfqkmn8iuiqak
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A8401A0007
X-HE-Tag: 1779897246-961444
X-HE-Meta: U2FsdGVkX19e4dakbQXPCvs0/hyfgJ9vud9XMIHFKzo7P9PxXyh3TqQ7QV2Yuz9+f7cfd2NcsBERy76zteMzsIfc6ACvaSkd/GZmiyaLHQ+SqnoPNGpOgiIioGhxDs6RGOfh3UMffvJnPnzWP8j5gcNCJAckSeZOV/n/WSqElWRjs2t4AXGS4a8Ukdb2XS/pdhjty5VCXu9ibnuUAYj7lt2Ou4SR+ao0BGePGJ+brARMMfds3Mv+PIR2LaCA7jibG4km13DnPCjGfg9HCaBehDUFu/OBBwC3R/xVsyiLuawmlLpdi4AIPyeV4bG42F1mhylrOITfgKOC2eUP8Un9Uxt6KTflARYqHiJhmCKbRshdUtgCnien+i61OICZahMzBU9q8vlT0dRtnI3KPMwxTg+UT6vJEHtP886od6o1bA2YADDH8MEmUqcH8pol72SswepN5RWLOaT1caSXrfD/GYxG923BsOK1pO5PWkz89n67D+t5QtSMzQ5tvLcfsZYRN+LjCEW7VusoyPc9nAa7ejpHEiDnjjgWsXLeCF3hYQEeyPNwaPWS1YDb8onYYgM0K0l556K51ZYTXhJEXZfYSoRAM/JE2eknLDtkiNkTvRBESh2OZCJPza/6K3o/7My0lFEZC3+HBz134RLD1oXznF9apHxbuOIyVX842Jelv0XmOdngHBs4Isf2o0WoEQ25dbKD+/VWIJduBETEJdXPZaaqxipBu9EdD0w06oy5HeZG9kqn32hn5vrunK0Fomi6NvKSe9hQIq/V4pGjwvtv628U37KgwmlK3cfI9/JWnT90Pbk843j8m0yXgDzX4ciImXAmnxhKwHYSZsw2y08PjzK3M5hUeSwci/TMvXHcb+jJy5VLJyNs99UBTb//otHZi83LhO7EHzZoHHBk7GY9ZzEfT1x03Y5d6NE0dv1jI70Atf3imUaOIouOBOr9s3jFhUrhzayn1YYM9umCK0M
 7ndETba/
 o44r0Yr9k/yZ6TLxlE04w7N4IV1/CuxdWuJECOW2U3928+LsGOHnktckrTI+LdpEYWekWTdd77VLD2OEdgU5Cc9j3jb0Bqa8pjXDeAlqtxcwSg55+3XbjWXOQ1nwEtIEbXCS8DV5IB/MVYtag0iI5L7zudY0anEGTPIPILuw0iPgl7AlQnUk1mgahKK7Iyoa+/Tk24HaRhLuED2izAcXqrzZPOtZpt5KUO7sRusaKTSJiGG+9oHSlxA4tszWevCU2ss/9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:22:29PM -0700, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 06:47:30PM +0100, Matthew Wilcox wrote:
> > How about:
> > 
> > /**
> >  * bvec_folio - Return the first folio referenced by this bvec
> >  * @bv: bvec to access
> >  *
> >  * bvecs can contain non-folio memory, so this should only be called by
> >  * the creator of the bvec; drivers have no business looking at the owner
> >  * of the memory.  It may not even be the right interface for the caller
> >  * to use as bvecs can span multiple folios.  You may be better off using
> >  * something like bio_for_each_folio_all() which iterates over all folios.
> >  */
> 
> Sounds good, although I'd captialize the first word in the sentence.
> (Not that anyone should follow my spelling advice in general)

I don't know how to capitalise bvec.  Is it Bvec?  BVec?

Fortunately my wife is an expert, and many years ago taught me that if
you have a difficult grammar problem, don't fix it, avoid it.

 * A bvec can contain non-folio memory, so this should only be called by

