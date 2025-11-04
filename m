Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEADCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 22:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CCD8E0003; Tue,  4 Nov 2025 17:11:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544BB8E0002; Tue,  4 Nov 2025 17:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480668E0003; Tue,  4 Nov 2025 17:11:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 344CC8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:11:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85A794B176
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:11:21 +0000 (UTC)
X-FDA: 84074321562.04.48C6EC3
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA8C1A0006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 22:11:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=HL8+OWMk;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762294280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BlojT3ZNpb08cgBE5OnkdRei3sKYEo3Zbg5wHQuBX4=;
	b=MsBmoIVGHK9jsBbiN/quGcu70S9i0wTmNH8QhcPhN68EPqA9tgQB20Sr4Mf2odabWgY7WF
	jcz8Wx9Kxu1dbChDZuvIpIon4you8v9RL4Zi27Txs1g45yPpkaczvdOtsFTrqe9itHldha
	qieoqFCuX5AW6X5V069IN20V0lT2m94=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=HL8+OWMk;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762294280; a=rsa-sha256;
	cv=none;
	b=mQs/OvniiP5ZzWTzipd7flahBljJ9i4VmPKqDMxaBfeoWjpd4yOC7PcRzKd+MQWrML23k4
	DOXvvaM++JxJ8mh0h+x8yhfikt9zZOxGLhEWykIxXxN8H+KlL/du+oFl7D8P9aV45GeTPi
	+W3i6sOYhQ4S1E/Wwqb2mCrUevZatE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1762294278;
	bh=/BlojT3ZNpb08cgBE5OnkdRei3sKYEo3Zbg5wHQuBX4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=HL8+OWMki6jvFLVTzvijjMKsacdQgaB8EP0E9FXTOv8VtzXVmj8iaskuVHjHDwXU1
	 F/X3reeJs0CiPIfv+15OHdZv0PNQvrryiBq7UlG6XL57DZ/v217i5hup1kftWnIjMm
	 7cJ4cOMPCI62TYmS62eD8VNQgOa6x7knQBKSkdAc=
Received: by gentwo.org (Postfix, from userid 1003)
	id 822DC4015D; Tue, 04 Nov 2025 14:11:18 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 7E34A4014B;
	Tue, 04 Nov 2025 14:11:18 -0800 (PST)
Date: Tue, 4 Nov 2025 14:11:18 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
    bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
    Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
    Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH RFC 00/19] slab: replace cpu (partial) slabs with
 sheaves
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
Message-ID: <f7c33974-e520-387e-9e2f-1e523bfe1545@gentwo.org>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA8C1A0006
X-Stat-Signature: 3hs8s1f33gm98tz4h4yys8q3q9mpw5q1
X-Rspam-User: 
X-HE-Tag: 1762294279-548898
X-HE-Meta: U2FsdGVkX1/+uJrj9VsQHGhhNLsB3XDMGvk2umRGkYXiO5JhIe3fOgUR7XQqH1ytIagCG0G+ytMUFvlZOsXaQRreLBLVDqtUUk8pDOKcH2lLdOtzvxHPewZa80qI5NeB9JzytL/q+NsKS/LO5z0/DNIarGANlnzW6NGtVoGxX15JC8cpyUBCQ4pTylmZNNTrx1fQoSdavcrVhhIPVlFuwFqDAhXOOsHdBG4eeuK+igNlLfG75LBJIdJXWzdwtd4xWqHA5j/rJJmJ+gQweUPPLIZUVIHr02hdY3/6DnLWAhxkVp9RMd3qKE406nWPamPHYpK1WDFi6LQykZwE7i3zAEczTNXm0WCOSCcy+/SyK1+mW+SEvXhAVncEFkRKPBtjh2SwvuOW0t69lU7F3pfYxqKm02aKdIiRyPTqvjPgcgSzxPBnvR5C08QzeBJpbQff2Y5WoC+JwfUWXTChIlU6X2LmDBPSYlkT3qTuxoe8jpL8drnNCrJwAPm1PT03XK1qsT27jAXA51ezoMX1iFaFXGMPTyMLyLBVqURysECHrPxLS1b4olxXv+OBWHsYV6YTBsQM3We1BL05SDJV7Yj6xvcwJkAYfKd68l1XDeV35OK5QNPvwwRn0y91ImhaL4FdvdvNzDnFaajXfwf2+bGSqjiQ5CUlixlFKJeBANgFHJoDV4T22BBWjp3QELGM4+zfsuG40UmCYPf+WOBVxfz1xBQjfkXon/vTGu2278Obci/nMEGrkFuT5AempnHWoxXhHGCX9XYVNXcq7nP8/j2f4wqUsMfPaN4d+a63beujMIFnUC+ftkIHPgznv9b5AAXSegi9ZPaFFz63Tni2OJvBRDKYln2Zrsk21C6NmtMITfWE4cadP5PNPsvCLkdfLeR6xUa8H23nJENXTF0Yw/RqKEoafGkhxI8wJjU2e2alwtnkTVYH762LH7H+bHnRfqVuQCF9IO28/gj1wTjF1tZ
 LPFy/X+A
 06pm3jHDjCNJoiIiIZpVtPg6d936nyZgKGJVGgnqIVWo6FC5R3N80mAdmuyxfHYIUPCw25oJRN0VGLYniAn0nykhNdpZJBbmwznuw0sLFkaWfzZ0YnHbP5muKgQoQyF4Bolb6dWHnzcSgkL1HKlmsIwrVvfdKxgnZRV9Fh0mOMQcwVvVg7HZ14qSXXL7Tx8Ac0BsVOAcZR8tHubjZLUYzgMbb1r+D/b3uA7P8kXrpxdgjXzHWxi5o434JjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Vlastimil Babka wrote:

> Besides (hopefully) improved performance, this removes the rather
> complicated code related to the lockless fastpaths (using
> this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
> kmalloc_nolock().

Going back to a strict LIFO scheme for alloc/free removes the following
performance features:

1. Objects are served randomly from a variety of slab pages instead of
serving all available objects from a single slab page and then from the
next. This means that the objects require a larger set of TLB entries to
cover. TLB pressure will increase.

2. The number of partial slabs will increase since the free objects in a
partial page are not used up before moving onto the next. Instead free
objects from random slab pages are used.

Spatial object locality is reduced. Temporal object hotness increases.

> The lockless slab freelist+counters update operation using
> try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
> without repeating the "alien" array flushing of SLUB, and to allow
> flushing objects from sheaves to slabs mostly without the node
> list_lock.

Hmm... So potential cache hot objects are lost that way and reused on
another node next. The role of the alien caches in SLAB was to cover that
case and we saw performance regressions without these caches.

The method of freeing still reduces the amount of remote partial slabs
that have to be managed and increases the locality of the objects.

