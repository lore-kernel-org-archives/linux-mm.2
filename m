Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A71CDE004
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 05:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64698E0003; Fri, 14 Nov 2025 00:04:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEE48E0002; Fri, 14 Nov 2025 00:04:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC888E0003; Fri, 14 Nov 2025 00:04:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87F428E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:04:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4317387883
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:04:18 +0000 (UTC)
X-FDA: 84108021396.12.9ACF7FB
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf25.hostedemail.com (Postfix) with ESMTP id 30B79A000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 05:04:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763096656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aPakiQw7smfdNtjwf69MCsSp/ExpxKvUw0MSZjdXZYc=;
	b=7DV5zS3An+WyEO2r6oymhxMOlyyJO4nAlCTyZUZC0ddGx3/gQwOIuen5rs6f/GgKH7lXru
	Q4HygS/T8nuCYlYgvguuyoXtWmPwOvVCZYtn1UUb62ItpnxoHfKRPwCC/6QJTsB3eCsk28
	rICEnx4n6n+FGACfpxpYJ8B1s0+BbvM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763096656; a=rsa-sha256;
	cv=none;
	b=nW1fPdzIO/bT1mbXJIc3jUvcpq+zprhZP2r+lHhSKzatQ+TFWFo7BLuHqVOaaTMBX+eX3e
	7/NDo+BTu9GB/jwY6iQg5Ib3iGYotH+9lIG6zDAjKVmb5rTqzV8ugphTOxU6Ef/Tn5fFLv
	CXTPO7rS89RF4C/a10R1Ria0qH2I4lI=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37A73227A88; Fri, 14 Nov 2025 06:04:10 +0100 (CET)
Date: Fri, 14 Nov 2025 06:04:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mm/mempool: fix poisoning order>0 pages with HIGHMEM
Message-ID: <20251114050410.GA26404@lst.de>
References: <20251113-mempool-poison-v1-1-233b3ef984c3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113-mempool-poison-v1-1-233b3ef984c3@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 30B79A000E
X-Stat-Signature: xeq7e9en9o9zefzfa17mzrpaj6wtx57i
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763096655-606507
X-HE-Meta: U2FsdGVkX18kguYvZ3lW0N6ymejk24Zhw72tJdFu3UJQW+NZnwkZBiYbpzdH8tQiZisCwNfyqEwWXqltYGsBPejncbsduD+/XsexGJu3x1XrDK1jE8wfpi8kHUXxvDG1Ol7/bY+1j8/hvdr7r2gPKcxUCyWfU0sjF/oexlNErvtyOWwMVLnxGf78Il/AAdLkypurWqr0jM3gcmOTnykhx+ZJwu1Yqv5Rg3fgmyaZ9I+Ziv5e7u4uoKOjjLZuByyu1bpifa8fj8i041pZV58hG4AmgGgdziDxqtZiZ9vV71P/k5oFJZYRfZ1/YDkCjEY96aHocP6g5mRVqM7Fs3t7FDkE15QXwf2N8Luid2dIxhAXTpIdtyn0+7xjoUcfJley5VKLOIwDZy6UkLKsPFiEqeTmEuFtgs0yjHtiZ2SAVkWfcEQBQkQrsf+5KjRHkHq8YLJduTLNs+nnKWFlkkYzyQ4Kdivz4daNUGG8v5Cgejf6fk37Uec4DZoZFeVngp90BH6DtKeP1e4wtXkCUSHl+a1J/XeKSXTz/UDSN2X7hyaoHA6DsOCYNEz+R6JW1HblKEjiDyuzURK4Y3R2pp8SMFH3xsKxp4Gvpb2j2ZLzaolA9K9kFA5RYWbvHpOBuZQdFhiHZ+SK5OzEWUKQe7OrQTjkk9BCe3LOURFqsE5w1TQwJ7MT9bscjEdks098qIfs1ULTeo7ztuBBAEFSG7DwqD5wkNvojqrRLYFOo/f95gJPy3Df0bH7ynmTa4iufOAzSuJzBE2DkpDYlu601YKHkhPHQGZSTHKi22akYBdq2sKdVioWGpWQv6EQev0oVX6OXYPOE8aQeuGyuDEXVo6qaQaMSrqNGqPybNaoi71sm/V39zAqoCRAE9UFb6Da2y3DAwkM50mYYE3v0staZl1+osaeQbsQMpQv/7J1vHIg6p99H4PgfM6Ul0pSRtaX0gEtfYllKBqExQq8lpycNMX
 DZcao9+u
 dIQTL+HUKetVzxe/L9k/cmKIWOW8FhM9KKpD1uKUdalq81vywCDbJdhZyTB8B+dSyzQ9r87JkOBtPLz2AEJxpFC5OwhU6UhNqO3Tu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 07:54:35PM +0100, Vlastimil Babka wrote:
> Christoph found out this is due to the poisoning code not dealing
> properly with CONFIG_HIGHMEM because only the first page is mapped but
> then the whole potentially high-order page is accessed.
> 
> This went unnoticed for years probably because nobody has yet used a
> mempool for order>0 pages before the new block code in -next.

I did a quick audit: and bcache, dm-integrity (config dependent) and the
KASAN unit tests create page based mempools with order > 0.  It looks
like none of those ever got much testing on highmem systems.

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

