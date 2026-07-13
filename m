Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E7DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72BD6B0005; Mon, 13 Jul 2026 02:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49CF6B0088; Mon, 13 Jul 2026 02:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62566B008A; Mon, 13 Jul 2026 02:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F156B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:33:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6DA81C965B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:33:50 +0000 (UTC)
X-FDA: 84982787820.12.4D6BF5E
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 76CFB1C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:33:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kU9MgPsy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783924429;
	b=wY7TqV00gJr/+T9E36wTJHp9NhrRPMozvJCYXCS0zJuhbIzpHcVUsg/iwh2pLW4AmAnRjH
	7cViA0qB8n1CbmgDOL3kGZfzDRqJE5TPCnMHd6/KbOBsi+kurhSTlPxKPpx/dfG/q4Y75q
	3PlBMXnbDJhZfx5fV63kXwTt2ngdyOE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kU9MgPsy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783924429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5B4GwQlb1UCHxXqUPHn4E4HBJOLkT7O9MFp4rT7+++w=;
	b=fDhoXCsILztgibCccguPa2OBN4LHXIMO8vQDVOGpEiiOAqi7wmfy0ILHDsu/EkXJtsWiP/
	YlHiG2mhYIJNwjwUckIMqM0nuMz1UJMPhqdLTxTvQQWJp5V/I9enQokb6XW0UXJDRv896b
	LlcL9Wt6rryuc9RQdYql0FZzUMXWc/0=
Date: Mon, 13 Jul 2026 14:33:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783924425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5B4GwQlb1UCHxXqUPHn4E4HBJOLkT7O9MFp4rT7+++w=;
	b=kU9MgPsyCLXTUKDnaa/fcQ9ypy/vnLOLjyPj2u90dFeAKLeZzNwVtz5xJVoI12owhHuy5v
	eXew6Q9WS7iJFGGKBXXio1OnFlnqlPYqcHQUPWAH1p7YZExStXbU1Qt7n6gRLxMwDtpAEI
	rOt5LaLAPNnecLZcMlPnY4EAxPL8z/Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH slab/for-next] mm/slab: simplify freeing remote objects
 in free_to_pcs_bulk()
Message-ID: <alSGbJulu_pHk9dz@fedora>
References: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 76CFB1C0002
X-Rspam-User: 
X-Stat-Signature: 7aphu5kqtmxz56eh4pnufsf8uzqni81a
X-Rspamd-Server: rspam03
X-HE-Tag: 1783924428-460437
X-HE-Meta: U2FsdGVkX18pmh+ZiUVnKrNZQhzWRrW5oNbrF9i5PE2u649ichMl/UdVu01DfwsJ+UHRwLkdrlRg8C/Wv5taMIyiIpDx6lKAAIJUmkyqdMqwBSJVmSCGr3djL1vmfD+MoCdBM6YS3YKSv+DvjYQ5IVgDL4cdmo8HM0TdY7Tp+L4AMP2TWDkh8x3gycOypHY5SF9w6TyoMd1aKxBNqXnphrGrupUJyMfW8KMK6SKio8HsVe0y+GKLr/y8LitpUAo/0x7J9iypsXmRqa589tPs1g+4I3ZEzZm6z6LKzAYj7V46xVvKiWjhbc7ed0UnrG5F4yLogjCFcROegV3aflvOCB9N4/hUJH0lF6t5Ob5o/nJFiWhstOIhd2sAxBwjb6Sfsjz8FBaOb8sVGvWXkUqyNqHhS2y4kCJqJwxZ/iIJjcEfTYAV2A2Uq+C1aKM/TYpTQtOlD9f4StRVt2k763Y6+4GFzthYZTsUixTVYSGQz9OXFhvUOr0f1S6N7k4LanL/iar0mo88zRzzLsh7G1RE6PMGxErLV9kEsvqCcnz5z/u+O6X85YCl3PYQaB0cwTMrHDOjl52ptUDzKf9Y0b3VGu1omyrwIpPiBzKzV12oRDMIGOSgSU4ldTaP7VdiWySNWyyJcYWL1JMy7ahcdkEIfvkXIeUYyANseakHU7h/IOfuJSCWyk3jTrBmgkUVGO7zxUH8m/tn6fxOcEWQy8eSEydoRiWp5G6m6NAi1GlX2XHoHGugLAPTfFiYyMomkvMhS9f4CGBllV2NRkDKkPK5aO6m1df0/ph1QTsbuGg35qxFt9aqlSNh+LRJTUtU6nCJfEEhWgy570XeZLmJKcIJ1J8oRhufHtD7PCjGx0zCNrQp7a/+UoDIF5BmKbRjH23IXiNnj/9Ywe6FwPcI9y25ID0kB5MnrXF7G3e1QdxRbT6qJ97rlxTnMFFGw+OUQCeckTpYLe3IzpVj4CrV9RJ
 ZPzmgO7r
 2jMEiIMtEkkRNPY9O//gHZ+bhYbwd+29cNqpAl87GaMmrPZIq/6tRrZZxX2xn+duM0HYR9dHhKQdhs0xQgcOCjFQnFFb7T5QB4wc7nfVeAmYTr+rlxkQte0RnpPysmb0W5agKTWFjAwvLpzehhZFKC415RU/joCZHjMrwo1hechVbjWCKivzQtNIzHczR2fs3cMEEEep5iFkgdAEwArsn5eKKdDHIr4f1i0izGQi8+WG4kmaSFr/pxw3zKI11vsyqW6dexP5FYrdJ3ItMw5f3oald/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 02:04:58PM +0200, Vlastimil Babka (SUSE) wrote:
> We have been moving remote objects to an on-stack array and flushing it
> when full. Instead, we can swap them towards the beginning of the
> supplied array and bulk-free it just once.
> 
> Also add a comment to explain the rationale of freeing remote objects
> last, because now it would appear to be simpler to free them first.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> One more cleanup I realized it's possible when processing feedback to
> the previous one [1]
> 
> [1] https://lore.kernel.org/all/20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org/
> ---
>  mm/slub.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

Nice idea!
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

