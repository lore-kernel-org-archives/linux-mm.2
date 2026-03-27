Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE6910BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2936B00B3; Thu, 26 Mar 2026 23:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73BD6B00B4; Thu, 26 Mar 2026 23:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C892A6B00B5; Thu, 26 Mar 2026 23:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B43B46B00B3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:39:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FF6B5DBBD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:39:52 +0000 (UTC)
X-FDA: 84590439024.07.1328F30
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA75E1C000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:39:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=urLNBjsO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbUMGNxtcsptfKyJ8umnsG3FmP2qeReOaBThJBj9pik=;
	b=lXvD+uwuk50acX4qCvmNuPY4J252yAvaXgPIgVioRRGxUZL1czfqiGRip4SFJDPuh+AkJH
	MY/eGrrzJgCWD0gfMxG8Iuxq0EyTUK5yU36yVWgfbod52n/W7Qi4OsUiD/FqN9vFjax4i6
	vanJ7PnUfgqwI4dYhwt4CvrCnhZ0n2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582790; a=rsa-sha256;
	cv=none;
	b=IRWhj4cPPg+RHvnrbeKFCliXyVNq/zkVM1YKxV247MEHP3NNl38RZ3MM+Yy3/KTd04DbHk
	5VdPx07xPnwE6pSlOFFEgflnZvUAfpSmNd2kS1x6idIAdLLne818QVtmxx0Qs8l+EyJ0H2
	d8cxOE8eBLrSKAQIqU5xlcaL0eflPNY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=urLNBjsO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LbUMGNxtcsptfKyJ8umnsG3FmP2qeReOaBThJBj9pik=; b=urLNBjsOOGK5zZBA/me+vklaWl
	Ks87y4XHQnFlURVzrmqqb/zuZPPFcRxCgnpynTYQGmbFPPMTUEaora81MZwlt6uHkqE/OeFcWK2Wz
	lMm7cVCoE3/q6xgVAh+zMRXBi6nSmY0OZcNGUCB5kNHyCz7GfRA0DU18yiy1xkfeB1wac4/M/j2qP
	sz8I8rdmCedNO9FOYblol8R65gCMOj5LZ7nmdd2aTeeklqG5RUqJ3dTGND1A1qhzcqN53bF/1+Hic
	5Uqn27PH9zH09vQf0c09czBrzNnxnqIiwm0Me0eLtIX6fRA6oMKA8RNittQsb8u9X/AlOIx1v6BW5
	eaUm72SQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5y2y-00000001CKR-2T3H;
	Fri, 27 Mar 2026 03:39:44 +0000
Date: Fri, 27 Mar 2026 03:39:44 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Josh Don <joshdon@google.com>, Greg Thelen <gthelen@google.com>,
	david@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Upstreaming cache_ext: Custom Page Cache
 Eviction with eBPF
Message-ID: <acX8AL_aQlHtrVEe@casper.infradead.org>
References: <0b1293ca-7a1f-4358-bc20-15784452238d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b1293ca-7a1f-4358-bc20-15784452238d@columbia.edu>
X-Rspamd-Queue-Id: AA75E1C000F
X-Stat-Signature: rq5uf7mo1mw9yen6zearpzb77x85ywgz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774582789-485492
X-HE-Meta: U2FsdGVkX1/9toNbrMH9vvdwljyrXPT7CzJv4mLcBtsKt2FL4xH03Ubik+y86AX42rtzJk71/SGDakdfZ32bFQhxfO3sKgl+yclBnQrD/jlLIqEcQk6s4rMJRqKMJHLUkroa45EZrAO0FCfC14u6TFBeFGbQeAoyCkQWpbytlmw7ZGyhFGDWr/ch7hNUgqsKvCjTkQJhttko2ilNAapS4TDQeBwI1jbf9TQPlS/RJiYUql5SgL2oQq/lKjD8EzaOI8dzqiDx+4xqIcsXAGtGM3DB6sTU1B3aVn0Z7mDwByxtNJykGd59V1mzDUYUIYq+8Ug0C0yIw0h0fs/xRJlWZGuMT0JuKqw5NO6JwZOsdRTYuZy94mPLCb0lJB+Zucsylo3bcFdkcgN6ab/iKfWTXw8x/wAaY8RdD9ceXdziGw0+fA/1jt8GVE+0qO5RLVF+6gI7J0DAt/t9L9I5hsPyGkdp16Xup4FPcbaYswUoklBHS2FLYwNZAo0RRfcLUoMLevRdCMuHojpqBPYYmdbAhAA586iThFiWniy3GpnXnBBccioPDStlNAHupxIlHZvw/bJbWQHXoqxi2RMpACYfQ2iLImsajYKbb8yvkE1HZNIHuIEtJ8HPHwRj1sd/EF7B3aAuauJVi+rmYdX88xcFTkkuHFttg+Qr9La78yXSwtlCKeSD1Q3XNQoKAx1uz0pfBu/9pB1wsoSrwzIqrCU1dx9e08CSvOuWozQAwYvwDiWUHK2nHDs+j+i7jB7ZuoXnw6ucgWzTZTyx0C1tDyoYZIt6yb4om9sCl2I7hUh5XN9xdz+JxSaiSflbIzegtCiNZgrrR+fEUW5lITyZlDgpM0RhCqIEchmlLaiyTY/mmsG20hS6/mu51NbcKvRheqUXArRLas7QZ2GE2YFhCp4rfumkMbengzSy//wvn04mgXhyWw7uQAtoHJ4XFAm6Y3IdRjzNSg7QdRSgaetaM70
 dxBbTu4b
 OM6w2widH4IOVyjjuRFZPW1S8tx/5Y1acnTVLShUV6FV2kDkOlfvFo+wxb1O4CaS1qasWcDRe9+Eym4DhRAunpEpzcfCj62PYMCBFmyLgcr6YjVHRIppifh0yJ4B45vQFqZ+rYlnTIYCTmdjDlL+fsq/9LaoTVEfAE3ubmCVxzI8bjeiB2+j+05mWNTP0H8J2PoumVqPz9aEeQxjGlZOQNCn5F3TsrSjupL5gPCWA1as4zfYHchcjqvK/2yH56//qoYq2KU9o8QY4GH//naA+GRVHXgVI7SaYSrXAmaUZlXFXabg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:15:37PM -0400, Tal Zussman wrote:
> Hi all,
> 
> This proposal is late, but I've been encouraged by a few people to submit
> it, so hopefully it's not *too* late...

Hi Tal,

I'd have strongly argued for an invite for you based on our discussion
at Plumbers.  Unfortunately, some people needed 60 days to apply for
a visa to visit Croatia, which meant we had to decide on our list of
attendees in early March.  We really don't have any extra invites left,
which sucks because I think you'd have been an invaluable contributor
to the discussion about reclaim we will inevitably have at LSFMM.

If anyone does drop out, I'll advocate for you to get an invite, but
I think that's unlikely to happen.


