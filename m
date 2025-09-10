Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11F9CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1DC88E0009; Wed, 10 Sep 2025 07:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7408E0002; Wed, 10 Sep 2025 07:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95D08E0009; Wed, 10 Sep 2025 07:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C29758E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:42:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DEC916082D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:42:53 +0000 (UTC)
X-FDA: 83873153826.14.FC0095B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3BD6160004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:42:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ndRBVOTl
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757504571; a=rsa-sha256;
	cv=none;
	b=P5UkOkzmXE1M8QQKoJnaPtkLg1uYOoAgvbaNDHuhMrn3YWIXEqIvFViWQWkWUz7Y4uYXOg
	4WgsfuA5yc4LIMYev8qvfmGfQ8p3HkCziMwxUGQ73hJWiH7eCzltlB21xJ/dHoIwUvXsdU
	j5m1/bg2CeYAWHTXHetnBVeCGO4pisw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ndRBVOTl;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757504571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJCi3KYlKbMP3NqToamK25wFCulBqxD4fJnna9d4tU0=;
	b=dLK1yKEoA21KBxwBY7YoFSsIKMu9HigoOm6nGh0sXGfGyU4XG6U2OetBTReTFTx/OwvpNa
	kt1u9GAq6CqR+LuTss2HrlQ2DkxMOUzt5DpbTuxo7IGPdW8THKNMKXNdf24dgct7gQgu8E
	ddmT5pqs5QAnC47nzsMh7Dsiub5yBEI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OJCi3KYlKbMP3NqToamK25wFCulBqxD4fJnna9d4tU0=; b=ndRBVOTlYboaUtw2tbnO2LT3Rs
	P825aoLYDZJqO6QhaGbFdpv7mDYB/BiO5xep0MsU6xQjMFcGQ3cWVaMBBdHaghhw4mO0IUDLh83cd
	UL+0ixO2zgWJ7AymJSlomAkdcsREN3evyXtsRyQFOOf5VJj8b+v0WP5yvBnMhkgHeEoaa2PX/+wmr
	YfIGK3E7Czj0SiqW3aspeJy2s9KSsuxeuwSnxLNGoYjPwwNPjDP3FsmjnZgPOZ1m3gV6KYGjMorCd
	RP62keKXjf1WUFE1jrquQEppmip7DOt0vN1Ls+M5zmZNacsmki2V03ouZNOEE/WuhdQhOcSluTfjv
	A6f3cxow==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJDs-00000008CL6-234G;
	Wed, 10 Sep 2025 11:42:48 +0000
Date: Wed, 10 Sep 2025 12:42:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH 07/22] slab: Remove folio references from __ksize()
Message-ID: <aMFkOMq6jS6YEQfq@casper.infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-8-willy@infradead.org>
 <aLfQ3UdoiZc9HKyS@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLfQ3UdoiZc9HKyS@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3BD6160004
X-Stat-Signature: xo6izqabax613ixc1oyr167naq6k5mjs
X-Rspam-User: 
X-HE-Tag: 1757504571-354158
X-HE-Meta: U2FsdGVkX18hv20mVTY+1N6+pZME+Cu4Z0B56I4+d6obGEHUn8ndd/b4BHdiM7O+03ucWRg46vKgb2nmrC76JF/xoczhecrc2qqy54tUv6yRkF5RA3uUrMvCucKhZddtE4kPi5yhoYh1DTpIfSUy9SzKXSLXfr/uiFOZ8h/SModPG7WfvO+RgN5N5aZX42kDkISoWz3GoC39Mcyi23HJKuyecbw2NCu8bGOuEjrkuZ9xPkXudXSf45uZKtaKVQDTQ9XAT7ss79H4gwCLUjX+x+v9TktW+R8FYN5h6uIsHWkHpNYSOMyYMQCRTy3mSseqZJgUzKgNro3pEjun0dCzHEsDHZg066Mb3pwv2ygPEp6UBsN2DE+UUPF4l3OsbkZ8ScsVqThRApGwbgFM3aik51bYA7LmnF7lNpAu1S/bMSXQ95gNVxdKI78XepKrF7N5+wRGaK/Thobbt/XnyfjPMF+GNVWatKgYAaN0ZlFKO4i2KGlOCE4GNZBGc1B7/YsI0f2p8Spu9r1o+Uzz52sU4ur7PBoO2KsMB5x4MyZuA9hJHKNDCT0/fhCa6I90ROosvsXjJiqKSZxZxzkzuibEQBqiWCTOnNpaE0W1Pop8chRtWDuO1rGeuJ07i6WwaQTFeCo11+CKsAuvuniAxhvd6z0HP1kpZhGha+31IIcfH7QKuIVTa3P+wAGsXaO/hRAtOVnZFgsft+FU4k0YqMoE9n0eM9w+EMsV6p9W+WVggDQpvlqFMcvhVMIqlUkFK0APLHh48ZCU3WsqWrk6wevVDYlx5sUa91ME3vl0J64lCe6otI+i64at2EP472yRutMkMImYllnmqTsiMvINlQUuYat4CrNvNIOXRy9JGk+fAQV7pSc5ydbhAYxFi7VMOtq2UgfPYfqhnIhQMiCMEA1Xy9j+UKjY6Y3al2LDCrVc8S9/c0qY2CtiGKnrMaY00ttVcBnUlH73Jc84exCmoy6
 1cGZ3uF6
 o6oTzH8CG/vmrc9/+ZrncfpQFMA9jhH7fZ1XaIaRMTPLqw7NObmTEM1g073fNPKhkh+PqtnVtM6ELn9geWgUaItlkWR4kYr7JR4uG7wd4q8Tx610Gm1C2NFZpvFVp+pp7hp8zpc5Mut/mKD/2JSBseFPmM7PZCbGjJgXTnN5zWSEI/ge2sf1YOfL+awnd9/JB9fXg+OtXcnsCl9rVVlqHepepYHBeJ1EZ4F4zQBN4x6UmudA/uQHJ5TB2Lwj4v+Uh0RmuPld/X35alBYPPVrlqu97UUmX/xa4tDHGqSkJrIMCVp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 06:23:41AM +0100, Matthew Wilcox wrote:
> On Fri, Aug 29, 2025 at 04:47:11PM +0100, Matthew Wilcox (Oracle) wrote:
> > This deprecates calling ksize() on memory allocated by alloc_pages().
> > Today it becomes a warning and support will be removed entirely in
> > the future.
> 
> We can't do this.  At least not without fixing x509:
> 
> https://lore.kernel.org/all/202509022248.dbe9cc08-lkp@intel.com/

My analysis of this bug was faulty.  I was checking PageSlab() which
is only true on the head page, so calling ksize() on any object on
a tail page would produce this dump.  New version coming imminently.

