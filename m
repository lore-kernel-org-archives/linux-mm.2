Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8194EC61DBC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9D06B0092; Tue, 25 Aug 2026 03:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B366B0095; Tue, 25 Aug 2026 03:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4696F6B0096; Tue, 25 Aug 2026 03:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 258E16B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:52:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 957A51601B7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:52:41 +0000 (UTC)
X-FDA: 85139024922.12.C6996BE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7BF1E40003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:52:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=memm6yJk;
	spf=none (imf12.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787644359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVaLUtmQZ+lo3k9HI0lk+lS5cr/55GIIaizc2rZZWKY=;
	b=uIzJK0YHqd3/sGKxcv54uFgwP2gN7oPAS6LljDMXw/3jx4f4QE+5DzCG8FhNVDpnY03iFY
	hqRuXqsg//HW1iWxISksAwHgBAnXn0Lka3grMh4tnv8QGVJIK4V1fWta9Czt7Yu+N1Bz5T
	Ma9CBc2PCBnahpuUUUgKQe8tEFgwMJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787644359;
	b=eKd/4E0eKmd/aPawl93esyaDyz8AXcPaFyb2CKMG20nA7uU5avDa1zN03rU/+2hN5POP63
	H2CyyPmC4NQSmenLasIy5BjeqATnz+Kd+M6EBb+WzZQH86bpLfQus1b6T0j/P+Otjv7gPp
	rJbsvs2ndGRQL47UPpZgjiP/Fu2vVPE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=memm6yJk;
	spf=none (imf12.hostedemail.com: domain of BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+b87911c0b4807dbed12c+8402+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CVaLUtmQZ+lo3k9HI0lk+lS5cr/55GIIaizc2rZZWKY=; b=memm6yJkJ4ijgsuHxHuws1dYrr
	+Beq6HH2viHZjubrWi+Tff+e1aq9+Z+4rmfokFIYkKv6i88fkaOPhsWgBpNKHrPXJApgkqJSyYrp1
	yu00hhqvIitnnPtHUQGeHgEDgu6Sk2IBdrBzfKKCjzQUDdxWOlpuN9ECd73zQaJ8rOi0rNjY2UEQF
	MhyVgzjD7/jwgDmGUCwlgP7lPpla5buCo6dQQIFgkISXUcKo4XjMIlduqC+yMiB+3g7hiQqvbEmC6
	Kgtv0m/GIHGB2xsHVWz+3jGKO4XH/4rNRfvHSK4755aL36Aeiu5INcKBOAWSYiyPWdjdllBLzFtOw
	yEF1Bhcw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wylxQ-00000000K5L-36MN;
	Tue, 25 Aug 2026 07:52:32 +0000
Date: Tue, 25 Aug 2026 00:52:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
Message-ID: <ao1JwEAeNcP9OyKR@infradead.org>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: b6q3h7gia77uzefsjaf937r3p8dxb6of
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BF1E40003
X-HE-Tag: 1787644358-371864
X-HE-Meta: U2FsdGVkX1+I90vOQ6UANCI6idoyaDsd/nAPCL1KBhZkcmE1+dAXBYjWeMSTuCyhvoJxH5q/euLuh2UQ6xVG1j7hxr5SHQ2NkTolFWfPv4DoKldxFJSbWYCHsKiw331VsDt1qp6Kx3JyuYmPznd7jerroHorC2Q+o8qReiJwIsiRI+ar2fOpQPheqB1ymzF4YdwziUsPbQXPnKB79HZd97etz/ezmxYQgJdqw2QL8nHaA4Sx/Vug/a4zgGJh7AlmPtOzYEhcD9JcBylzMj346Ean9hc59rYG9Lb3mO8Ce43nDCctsUeAmyb3glVDS2Ivzp7GUYzaggR69k+DymaYAz4lYiEVdCzAFbjcs0+nnpOyzIyuPLdXtj44C3FLa8oL61VXKz7qCABc9SUIhiZpzqHCsF1Pq5D6OBcSHRH/7sKo24Jhug/gxQwRx2brE27/b2EAP1qPn613SUDnq5ZkABaXKp8xFjTvYChC78OjhGPeDEurG3Dy7IoTb03MS+o9vEwJOsqF4sOe/PvRQoqfC4ePdPxlJwMaqrGLfBYA/HUHbuYQVxuAQd42TMplNWcbApoxtXWHBjcJMYGE6T8Ht5g3VD+51zz2qnaBWR5ZcNdecbZopSVbM8U6Lc8l1fRksyyYQDWvcjyf0/eiLL5h5zgdXcHUhc0v3hlcz8ZBhkQWNqrG9V0RxfNe5Zm9ADrO5WKySQ2pLAAutF3ZmJG5SJKj4oGqDzOBq3blHaa2ROIqyWrtuto64u7eVHKu0Jr+FtWV1RtNFyaNW50hOkHjaWy+r1tL0+FS3gi/HYk4OOZK5tcotAsdJWdWMTBj+9ZCs0NlO09jnD+YFrVKPV8f6Rbgq7Hj8Sg8haszZQe+ndeT5nM9G2F07jGSZxzxeKUaj7SjXOn/64ju9k6KkdzMh18KTRzWt28EBMy1dOgfECz9LGCetRrry0M88neg+YHkcFwbtnzvqPv0YqLxHht
 4axyKM9n
 TOSxGjxZRrodkluq1Btq82tgWDeKANkU24Uxq8+6kBfSfgGrw5taYI8zShNO/oAWq30dLmnlhmlwIiqdmlqoETdxRP72NoSV5MR00fIjJe6bBBxsKhAItMVF9Hnmv9EPaGXFpf6g8cCj9LLbIgTtIHkTYfsmvooyjp8Iu+gQA+T1RqiPcE+cR+P2i4lVodbF1rDsSLOogiXdv2KZsDTnb+NnxdhdJg9cv8LbxnsFB4h1vAX/ccC7yO2U+vpUmhcW0ZO7rk2hXT0OOJiszouWNRZs9FiaTxv6e/1oOD7jF+35F2VShfhhA3B3ypidQq/UhbiAOtJ9+FXcGIp/ltDHg4h4sQYtPlzJ4KzU4BxpoW1K1K03rKxpMTfPCkMrEXFaiu9JClIIZYXSDqdu9Z97hJu/s0hxKijD1REsrNRWdweXaQS/vJwouDn28emATPberDAkd2j971idCVouKPTOaZkAz0x/PJpkcM5xkfl17JcKRqBSYXzpiOE+oaJtEZ4qHcdDJniO0LYE4vNOz/H7rpKehdryjMRPQtpKOCTtnfmHMfDLhmEy5s8nJ9IZ+x7ZJpWrEvwAoGz6LJ1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:51:49PM -0400, Rik van Riel wrote:
> follow_page_mask() walks the page tables one page at a time, even when the
> caller asked for a whole run of contiguous pages. Every page of a large folio
> re-enters the pmd/pud/pte walk and re-takes the page table lock.
> 
> This series changes follow_page_mask() to return a page count and a fill an
> array of pages, instead of a single struct page, so a walker can hand back
> more than one page per call.

And what many including the most performance critical callers want
instead is really a single bio_vec.  Maybe we can go the extra step for
that, as it would reduce the number of calls into gup significantly.


