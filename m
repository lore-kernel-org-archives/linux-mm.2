Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D81CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001896B041F; Mon,  1 Jun 2026 11:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4DB6B0421; Mon,  1 Jun 2026 11:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58726B0422; Mon,  1 Jun 2026 11:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D90CB6B041F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:26:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6EB931A06F1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:05 +0000 (UTC)
X-FDA: 84831719490.06.BB81D28
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7982F14000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780327563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EQwajgBvdnFBi4fkD66jpznaki0ZkChxjqgAPmlMqac=;
	b=Tn1Au36hCwlJlUzK11nWsxDMHQXclY8XA+Ip1musdtTObjAm1qj6USVMlJGL4cPUEpcKEw
	xH6brlQ5KmDwjHxIofcItNapcDvIWc5a+wxJJJugdr15cxexhv76oqTZodrkUhcqVfwXr9
	XhtcuSu4WmGNAEsBi6bCZ62ykdzvJak=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780327563;
	b=ea8PRy+GBIsrTNnqLekKCfYec5UryV3uBNdRAhDNmOxVaoD0ghYKA2M03YtictsU9jFBH2
	jT/AQtdCWgcdbfaQCFepAEXvIIPRAamzydDcvL1SlibFJDoMb2Ja7jeckKNIEvxw/TdLCY
	bNl0L32YtZG0RcWLp8pdW9b0HzpiMUs=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 015AD68BEB; Mon,  1 Jun 2026 17:25:58 +0200 (CEST)
Date: Mon, 1 Jun 2026 17:25:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: better block swap batching and a different take on swap_ops v2
Message-ID: <20260601152558.GA6229@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <ah2JOjCiDqXvPci_@MiWiFi-R3L-srv> <20260601145053.GA5268@lst.de> <ah2iiPueZzAxnk5y@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah2iiPueZzAxnk5y@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7982F14000F
X-Stat-Signature: iw75qcr31z96hasfzi8z6e9xjupna14f
X-Rspam-User: 
X-HE-Tag: 1780327563-554276
X-HE-Meta: U2FsdGVkX1/K2lkPqPAp+VGbhRV3IbCmgcpBtI2RZteIvhJgst8rQ9EdlsP9RfFP0juJWyU1cwreBsBdi6LDw0u0y5QGbWmhzESkk3nglsmystVUKAtkd4oBKPE9ABPQYurTQM1zgQYE19T+1oRdopNwvo5yjWnH3a7yKV+HbznFr97lXOtjMbr6gEbSGGAqmT9vKVMF+2yBy4hUzoTPGf2pvUv5bG6YdrktzyksB+RJ1hZQGLung9WARmkDmO2Dn6KiCGrI23q+oWCYVI3MaIHMgVT4vm31lkH8UlE+iSZNS8QJICnhCeJY3frrPeuF1Hm4URyvxqqeNI8ZKmmuS9famWSasLZdgXuMy3qVE5GpMIV/tSg7ZDptaVNbgR2eLDAeQ81hbR5ka1U0y2nkWzetfE9PP7mxQWOxCoKxj6GKPXpLZSepinkDmchKOse9Oz5wDQjvnlVrh582UZ4LxGZRDKkwmCJ/SKSw7VAH7v/gjLMHFIHbin1WCjX9EO2Q8WLgKovxNyqXbaZmI26wZyXa0H9uwIcpVGV/4IGRzjBXtWQJfoR3hOB1GMqz6GswFzSjgTMyRRuErdEKSdYKht/7EZ42EnXSV8U2F6zsAN3H565Sv1QiM3izJIM0Onl4wjbn+SvvO1K5nWVpZNHmdVAUIZvZe9lgD7XBh6o3UiNEnlYpm0NMcubtt2KsaAULi4yd0YbwXVo+BdPtAX0RXPyrFZuVtNFEn/EoBa86QWt62C1Y4CWGzvWKkz6oG+m2vUJlNJyZbXzBhFsgllyZMbNT6QlyP8797Y7neSd5ifRUa18FwWMb0DLBZ/I3BXcQlYaHZWLT2ngOtGeh0O4gfTFp456dRWxaSooYNxAqyvIgEaFkZO/LUY3VVPA9FsHBDMlBQZDC4otlWKwJl2vAZQ8X7dn6gjHIqN6pDqAKujerqScCaOMn5ybzJr6wX76lNeOhkpU1wqT7tycwjsF
 O9INuDn+
 MAW4YP1UGs1Iwnq+jG+GOTonhmLaOW5IeKYbS+PiZX8Rc1348rRxHBwUawbfrR6SaByfn9L72TQWXme5vXk8Q2Wdx1AC79CkJoadSQ2UYC45ZfEXXLB8Ovnx3B82I0yKs5IfuKxXFKraNPy+/CEeJ6YfVlbVzTnQc84fmH+AQeyU+z0/moC+24CCLHKaaCIed1koox84geFYCZekix9xMeZJyqd7ZmzWHE3fjb7upJSzJZZhy8NlorJG23u6AvJ/w5jif
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 11:17:28PM +0800, Baoquan He wrote:
> On 06/01/26 at 04:50pm, Christoph Hellwig wrote:
> > On Mon, Jun 01, 2026 at 09:29:30PM +0800, Baoquan He wrote:
> > > > this series makes use of the swap_iocb for block as well so that it
> > > > doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> > > > from Baoquan on top of the now very different method structure.
> > > 
> > > What tree is this series based on? I tried the latest mainline,
> > > linux-next main branch and Andrew's mm-unstable, all failed. 
> > 
> > The base is:
> > 
> > commit e1af79f3291a268adf4e149e1faba3052743e898 (akpm/mm-unstable)
> > Author: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Date:   Fri May 29 13:27:54 2026 -0700
> > 
> >     mm/nodemask: correctly describe nodemask operation return types
> 
> Thanks. And seems the patchset pulled back via b4 only contains the
> patch 1~5/8 and patch 8/8, it misses 6~7/8. Just in case if someone else
> also use b4 and meets the similar issue when applying patches. This
> could be related to the email sending tool or its settings.

In case it makes your (or anyone elses) life easier, I also have a git
branch here:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/swap_ops

