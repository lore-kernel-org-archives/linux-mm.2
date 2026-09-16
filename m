Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848A6C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628846B00AB; Wed, 16 Sep 2026 06:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF9C6B00AC; Wed, 16 Sep 2026 06:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515B16B00AD; Wed, 16 Sep 2026 06:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 255F06B00AB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:23:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9918C16063E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:23:33 +0000 (UTC)
X-FDA: 85219238706.05.5C43814
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 009D0180002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:23:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iu/2+DYz";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLztN3PKEKqZc0fzcEuGAJpCX3EDSgFfQXKxXcN7Y+E=;
	b=U6EcdN3IzAgb3JNWRLZTN82CH5n9bVV0JchdChLXw5yoTUBtPZFQhPRVtshmG1dsIj4oZ4
	U0qobITMksD1q/jKFJFnu3fkfNGLBYsqG8gbz1TPlLjAbhDz++w4IoW+I6/tJl9tnAefyV
	QTtgh4hmzjrxXPf/be/G+4p2C6uBfII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554212;
	b=HuMnw/OeluimX7P2DfKUWe9JdkVt/pF2KNAKpNihZFtkoIO6qp0RxQjWB+prN2QoQpT1Uo
	vteT89VjZxkdTszmJmgo5gp6B5sQL+Nv1DYNUXYMPEU8OX871QKaUL9i0rQw5E6i+sLOBY
	svTmSzAB/HiUu/jObqFQMxzJ/v0m3iA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iu/2+DYz";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA32E40060;
	Wed, 16 Sep 2026 10:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D43D1F000FF;
	Wed, 16 Sep 2026 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789554210;
	bh=xLztN3PKEKqZc0fzcEuGAJpCX3EDSgFfQXKxXcN7Y+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iu/2+DYzeYlpKqLCzxyVavNx1R/QW+QBBQWo8pZzIvyMGgoXK+D7j9MAyKwOUgQty
	 X38d1Bu8FWFUgc8+xQldM5PVAZqazK9tmC6t0v9vhcwCX1VV0xoGlM4Xc3Lm2wnQ99
	 NlbclkJLPajt55PXlAchwdyA/t1lszYRMXJEumBWXbjZfa9Vo51tjeXX8MkE8W3FgZ
	 poWB5he0cPqPHUAwvk4Pcc5TQ+JgroS20H7qDI+eB8O9dOg9GcLFqiUyvxVjSaVlQ4
	 c2BYcI/weoC+otqhw5SuWdDb5qtxxzhLIze1y7lsmHsmfk7tdvdRmEQJNNmiNXhRfu
	 JdquqTt4RyB1A==
Date: Wed, 16 Sep 2026 13:23:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 11/13] s390/qdio_setup: Use kzalloc() for the storage
 list
Message-ID: <aqpuG_QJdsMj6_so@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-11-e931086fdde1@kernel.org>
 <20260916092720.15587B52-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916092720.15587B52-hca@linux.ibm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 009D0180002
X-Stat-Signature: bo4mjnakwt8q6b1w5wemtoi5ebo4tz3w
X-Rspam-User: 
X-HE-Tag: 1789554211-814320
X-HE-Meta: U2FsdGVkX18jeyloOzoNfrvbtTs21BYohohy8YhUoG/me5Zp61SoCmBcFQ/UNMHr7YJuTuvEsvAZBzPpo7vuk2n+36xN5x5+h6FF9lKYqocG1ZJmQqgxmxKWw8PE4/yr8L1fPr314fIv0cDUT2PCjF9thlUaCV9FRdbVH9SZF8FWFbHaI+q2mGwWsxd9mQLAtRimrVkv2urWM4Rn8019Gj17FNS9ivenU5oPAcYOVxe28apOmJPd/arFW7ZUVu6E2AnjbP2EzYjSgfcIq/GyFCiUfX5sWvR/33TP/dMz3cZMZlVu9ASuNQ0B68yAEWKDeTU7kd0aKm9DscQ9oRfoIXGMKFOIAEo8CnhptVwRAxkwmUDJhSkmuykHmMBUWzxhugaFQAtCIQbaczAfyMyU12AG8K932Dvz12Fag8Aco4OWjS95WbKrIEB07qxcyqznarztkgr06zEFZBB0f3mOjaj1KHZZrv8DvetKUPNVIYPrMyQ87JTZ4scHkWfCuzDPUrt1jDI/VxzTpErfxFqlwKe4/ZPP7S0ptzLH251qX6aa1qihQfDDBvqisJRqSMKfLUlSBxQfrpiPwtMZyZRjYzCvShZpqOaSiR//rjniP9Jb6zVZkSRw+syylawaH6uVT63KzZtQXTInBZj3PV46miiK6up6/hYaff0Gb2YFMOMWhgVoWJGfWsi4KQvxYIQanPabiD8UuFyHZHZPDov9RTTMB/qjLvIUDv34tmUX+5wN5SmKP9af0LNq1NZ8DQVA/lQEoAjX3beLcU7AkkuOv/zE86Bh3xt7EGok1pfcrAGwGVBZ8KXvgtsdq1WunBTlCOCwSmuoQXISMo/YwRthtJ0yRwfer+j/inN3281NfL/Zb8Wx2X/PALJE2Wr4BOwyxvpOJeZADPwhwF3Tq/GtZgFDidcN/kspYPtJVErfMKRtYF+h34iw33+l3vw4CI4zfJJ25+zt1+ezju8BHkJ
 lEo2yEEj
 7ARbAsNDYWlTmJOQZOlBorZCiOTzzu8R02yH+WYCZVjBKPGX/NwB/29FkKYxPcQfut2AeRCnUGSgT8Hv97Nhk7Wklnu1TPHXdL4eQ7OPlirix92R9iLkjqwBC9okTYxvnJTAQi3q2qtYlv2OwQJw5lGtEJ7Hi6hotx6t4Z56Z3uHRpRTmqFPK7rrk35mB5p3+eHFgoNfcmylFgPTmPXfC7c/rv9e0m/R32XhCoXDfrOS8qCvCMEN1zTkzhsr6c43QTlIrgfegyUaDf39/NS06prUVWC3/Hf6i8S+mOaxsm8cyjdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:27:20AM +0200, Heiko Carstens wrote:
> On Thu, Sep 10, 2026 at 02:00:13PM +0300, Mike Rapoport (Microsoft) wrote:
> > __qdio_allocate_qs() allocates the storage list information block of a
> > queue.
> > 
> > This memory can be allocated with kmalloc() as there's nothing special
> > about it to go directly to the page allocator.
> ...
> > @@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
> >  			return -ENOMEM;
> >  		}
> >  
> > -		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
> > +		q->sl_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >  		if (!q->sl_page) {
> 
> Speaking about unnecessary changes: why is this a conversion to
> kzalloc() instead of kmalloc()?

An LLM went wild and I missed it in my review :)
Same in another patch.

-- 
Sincerely yours,
Mike.

