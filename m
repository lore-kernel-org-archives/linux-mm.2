Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C278BCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 19:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E2D9000CB; Wed, 13 Aug 2025 15:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BED6900088; Wed, 13 Aug 2025 15:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADEB9000CB; Wed, 13 Aug 2025 15:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7A97900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:42:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9446DC048C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 19:42:43 +0000 (UTC)
X-FDA: 83772756606.10.E89F603
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 735EE120016
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 19:42:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eRlFm3R1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755114161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Z/eePXC2A5sEVuC0Nhf78dOfoyN48EYXcyjIyPQBt0=;
	b=Plct5xGryqx+zpPH3uqT0p1/f0HgYj19l49akhWy1dXjJ7YKv257yPMSU0Y1wHe8vu7KM5
	7NT7fl2pCHUfk4DUgQNxWXQKDo9RugRcyNkU9fi7erlf6zkBZVxtsh22/NujH4b2hPqYgi
	wwEXO+rWuJzrp02YRDyoUb5/HO7kKLA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eRlFm3R1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755114161; a=rsa-sha256;
	cv=none;
	b=1IiRfs4E1lGH+yQwJYzlkEzDB++UH+rkIl700NYkWmKhkeAmz2b2GOJag/woUvjl5z2HW8
	qSOXioJDwXUDu+D6lpd8IbU8PHjhBSjYfqlTnqL+IuLVRhCdjoNq7FcMczEZ1KI68c11HS
	0bHWgDHwzMz1yuwB4PVg7wK8gI4NMNo=
Date: Wed, 13 Aug 2025 12:42:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755114159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Z/eePXC2A5sEVuC0Nhf78dOfoyN48EYXcyjIyPQBt0=;
	b=eRlFm3R1unVIbzm+JsRV1NWkTEIXwIeM0Zc3P05QaNBPq2PVN7sYzS7L+exAbXrcYE1WZ8
	tbIzMGYajQrZ5tybXZXGtDKXqDNKdBLb2GOzPw/foPtP0LZeRuP1TLDswwWut+dyvw/tvE
	Ck9wdne5LqpkOPHDz6ydt1dRWAGZw9Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <uo6vtumoy4txklyqy4njitf5ex4eanudncicbbzknmuowopd7v@jm4ao4qapiza>
References: <20250812170046.56468-1-sj@kernel.org>
 <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 735EE120016
X-Stat-Signature: uy6s8fuzzdy6bp7xpopxzmh1jsu5tex9
X-Rspam-User: 
X-HE-Tag: 1755114161-20954
X-HE-Meta: U2FsdGVkX18DHUVtQHON+8pqVuu9NoId2U9fN5/XR7Js16QURjnYy0nxJgBKntWEEZZQvST70zUN5+bWyE4HvbEKUc9fWQ1AN2qdUt1Xh1WDKg1sMZQMWPqYOw9Uzoinsjr/MYFRHZN8WZpU3sqDzUlfwlhdct4e0yI6buMyqoCT3NAfVD+PMKzsU78nvTNj7NiFuo7dWS77rhbw38sS0V5PgrQ2sWsQbfHs/2d/CfL+61OpG/T+aRViVz2CeIrJ0LlbJEYtaFtZxAotIeaUpOLPtyXLz4FRAdJqypV3TjTAM9lToNA+ZBd6XAHSMhR5opTG1rIjSm7PtNlSqcFC2grkGjaeCPaeRyBIf8HZJf1mVS9zMfHhwqphJpfRIaftujL3OZ+yljxopQjARuKQRVZEUBijkLQ/QqOXxc3I7ubw+rDl46c0mJsyCv6wjzLakFdmRSJTLiWzCSS4BxziSDqNd7lIG57457P1oIcdju/eH5+ZF11M3+p/+EbMJT68qIUHaTe1Z+V/mOStdKpxuamhbFP6iObK2DuNkdhQgPMgY3+UeOywoo/rcseBGonkctOll5sPHY9ttLn0lO7kCGkacRwsVj8EfOhLJisGHCEbbFJY8qVcfKc4byOe4uC/5RqSLJ535wbmcoosd8WQqAbOzWv7j26OEMVrsWpufAf1BmAZw8RnUVKBUBirhi3P2DLg6kr19Effj8kS6heyNTSo9egm2ZgvqRpOgj3SgiH9nQoGkMq5/8h6Y5qhF1uah0Nt5NOBVlKWJEK62KZsRV3NwZ9ipYCReL8bmA8k482ZzfvF9eboXBUKYLUmuw/c5Og0Q/nb+utlpgJJwiwAPdRBpH0a/DW/+4qOx09WFN24lbKnd4Pjxf90pJP26GRfGEXvfl3IgfGvN+3DZKYrjRNgXsLJbI9bbsnApXe1wkDJ69Mdj2RImSdsQJ2nc2cPdA/KhZqv/h0lgBiaiFG
 aDkuf5J2
 K1pdqryzdbUh15B+ilg0upWIhl/9X3KR995bFViWKlbJfhmV4tR3k53pU7fsmmXvApun0O2yrXs69q7MxFYxWrfHFhgbjccLASZLW9RHDnaf4kIzWZ2+zYGKxbqvF+ytGv/Nmh3Re/NmqL3y2Gyp2GRFdFoe286SztmYo7A8tYQLAEjsDuU9c+8X+opK+rM+xHDBjwRm1m2KTGVRzGgjUEi7bRSnoLCBu3d91urAa34J/pBR/7i6LsKg6ndbyQmMzfbgH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 10:07:18AM -0700, Chris Li wrote:
> 
> If you store uncompressed data in the zpool, zpool has metadata
> overhead, e.g. allocating the entry->handle for uncompressed pages.
> If the page is not compressed, another idea is just skip the zpool,
> store it as a page in the zswap entry as page. We can make a union of
> entry->handle and entry->incompressble_page. If entry->length ==
> PAGE_SIZE, use entry->incompressable_page as a page.

The main problem being solved here is to avoid the scenario where the
incompressible pages are being rotated in LRUs and zswapped multiple
times and wasting CPU on compressing incompressible pages. SJ's approach
solves the issue but with some memory overhead (zswap entry). With your
suggestion and to solve the mentioned issue, we will need to change some
core parts of reclaim (__remove_mapping()), LRU handling (swap cache
pages not in LRUs) and refault (putting such pages back in LRU and
should it handle read and write faults differently). So, the cons of
that approach is more complex code.

Personally I would prefer a simple solution with some overhead over a
more complicated and error prone solution without overhead. Or maybe you
have a more simplied approach instead?


