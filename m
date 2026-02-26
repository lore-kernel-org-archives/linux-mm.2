Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C434DFCE084
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79BD6B00A2; Thu, 26 Feb 2026 08:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E271C6B00A3; Thu, 26 Feb 2026 08:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53CE6B00A4; Thu, 26 Feb 2026 08:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C23E46B00A2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:45:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7EB6A16016E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:45:56 +0000 (UTC)
X-FDA: 84486731112.15.9934BA0
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id B6DFC1C0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:45:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vajud8Gg;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772113554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkIMrpYm1KdU3cU9ItJMZ6NttQZCM67l72DH8n80OYE=;
	b=tqooaxF0D98s3jUlzKct1NyS6cAs3TxQfIpot4IXN0yUlVZHuOALuNTTV6AYrHvNTdrzL+
	9MD3PSIQmAu0tipp0pMb+RRD/26y9f8QSSOxt7M9AGiNMONm+LE77IkAJExN/kkIsu17Ey
	4mTgZafQBPbtlzWq9VCAFtqihjGiT9o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vajud8Gg;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772113554; a=rsa-sha256;
	cv=none;
	b=fQOXi3e5iTNzMpvc8yfH/4gTG+EK7jvQXBlDHFGQg8evaDO8LCGx/xU+Bumcps8NcuG4OB
	La7e/3asyH+tnjRKEwN0/pX1n0g1VQMH1klUTo/FqX5yndMnyaSSvIcD45XH0Sl7pTEnqP
	wZy8I8uMWun0IWCfrh42Gb14FoWUsU0=
Date: Thu, 26 Feb 2026 05:45:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772113550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dkIMrpYm1KdU3cU9ItJMZ6NttQZCM67l72DH8n80OYE=;
	b=vajud8GgT9YD52qua+5kbAsn1oe1msd/UJT+JLadvyyKmV6nd6QrfsG3Ptke+6XOJCq0UQ
	FF67owIaltxgRWsC03zZafdS9jeMvQ0c96JpnSdzKqkaP8upii2KeCA7cZDWHY1cpzJEtS
	Hw0OGY+MjxwUrFqDy3UK5cIfcO1+ayo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@gmail.com>, Maxime Ripard <mripard@redhat.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Eric Chanudet <echanude@redhat.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
Message-ID: <aaBNYqv2xJ4QEyh4@linux.dev>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
 <20260224-solemn-spider-of-serendipity-0d8b94@houat>
 <56400505-8a13-4cb2-864c-cb785e4b38d4@amd.com>
 <CAPM=9ty5mbMAVHPO4mRy1jKGnpChr7gK6uMtco2=j7MMJGpZdg@mail.gmail.com>
 <d1b287c9-46ff-4345-a410-7e1cfefb5c66@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1b287c9-46ff-4345-a410-7e1cfefb5c66@amd.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B6DFC1C0005
X-Stat-Signature: hkspyr3h5hu68z9j9ittadoa69ho66b4
X-HE-Tag: 1772113554-114500
X-HE-Meta: U2FsdGVkX1/egJCtQunvihpLXBZ7yQaZ13isFInZi02aMigzQpueClAYEyQHE7WJVoVsx1JE5aBFxebJ+/sz+v2NuvLJmYFe0FyGG//eDfkQNj657KazA/1+/doSGhEMEpdTk63aQiVswZ5FxEpwuBxloFwQpSp8Hx1DLKzmfh8pAoz5C3OUQbREFlmNh3RI9uq+J4CC+Biv+hWAdtoDaCtRrSN/kyR6jKJz+cRjEe8+fHpyD2KTK+m6afSTq3UAet6dGkmBu2FkmlnGyigPllTFsBzAD5/OkYFhCTsSLkn2R9wZXFH8agEmOVR95clPM35Ea9XZ6K/9TdRNrPWmHopoYTlrdbg6Wo+JBIlvZIjTU7ciTK+oxh04hL8B4z0Ue3n7uXafu9pDPAH7TO0DUDvOc2z+nN/CPHr0GVg1olAdt54+lLwjJ2DZvQFwv6HNklFk5zGqlEhl7jbtAN+s4ptZU9WlgBKWYaPRL2Ik7NIxoZO6FYr6LGwXJyrdvF7hV4jIhDdmtmkBl3Q3+taqCtfoI37eTs4A5QBHcxPUrQQyBDp7sRH06eNjMabAjlpqvnGkPyhg6kB4TTgKRr/lSLLirJmGIkgqtiMJJAN/+8odRtGQKH7rC7cgexsvqO6eFHFRnxlzCqRtETZHMF3zCnXlArmkCByiO4xTC0Y0NjvpTi6KmPUMtTS1W0cV6Vf54V12YCBlwgawvVicjFcRjSstxjh8U/PX/li7qvk+dVb+Pb8oyHDDnyMHN96irl/8IJTLjr0aT4e+r2F0h4Edc2Qw8F5L1WKGrfAx2WL+CQjnYa3q5t/uWyymIOKVS95IndQwgjcSjR4ng1jH5w1w/fPM/KQEVM5JofSi9IWYdy7iTs5H16GjLPvD5SJveb4kQNR6wZu5nb/02P1C8Q8oOGIOSJbC3r2o6RvPYoeID/J/xQNkdFJ0QrBj88uVxBd8x09NqEfxWr1HinqH3+t
 GmgeNHaV
 wnkH4vqQRORGCr7cFTC78GVxr80bYqYbh8qtHHUK6UIpI7VTv46H1scLNjklOyzCTjTMnhOOWG3IegHSQq6+igMc6TZc5KNZCPRo9j0t1nBapL33qBaNc17XZLfhCyXrPZNo8uWCziTaXIXsg4r3g8x2j0p2dmLn/3laR74jqWZ8uOS74pqQ0dLHGvjE0QowUNVooMyuylAMm3Buy9VTfGOOBY3Cuc6UzyqOF0Q/4Z7523pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 12:32:42PM +0100, Christian König wrote:
> On 2/26/26 00:43, Dave Airlie wrote:
> >>>>
> 
> > If something is in the main memory pool, it should be accounted for
> > using memcg. You cannot remove memory from the main memory pool
> > without accounting for it.
> 
> That's what I'm strongly disagreeing on. See the page cache is not accounted to memcg either, so when you open a file and the kernel caches the backing pages that doesn't reduce the amount you can allocate through malloc, doesn't it?

Page cache is accounted/charged to memcg and usually it is reclaimable meaning
it most probably doesn't reduce the amount of anon memory you can allocate.

> 
> For dGPUs GTT is basically just the fallback when you over allocate local memory (plus a few things for uploads).
> 
> In other words system memory becomes the swap of device local memory. Just think about why memcg doesn't limits swap but only how much is swapped out.

What does "memcg doesn't limits swap" mean?


