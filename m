Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84E5CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1B16B0088; Fri, 16 Oct 2026 10:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9E56B008A; Fri, 16 Oct 2026 10:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0C26B008C; Fri, 16 Oct 2026 10:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80B036B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:35:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F668160510
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:07 +0000 (UTC)
X-FDA: 85328736654.29.708794A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 33DBB40002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nrPNjHrN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mMNOoK6G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nrPNjHrN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mMNOoK6G;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=GWavVKZTawvlWAj4P9iGUAfrIj3nV3Rkkxz0aXpQHZI4axkHfQ+Jg3InrLorlVEjzrZHiJ
	1ab15TVn5f8/rHXCccGBDqvjKHKKo2IMnqR9CNm3ukJR6T81x4WJerz0yRnigbNdxy6+dg
	AIHjdhlcnXhU1HHOpPYuUXRO/YHFw08=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nrPNjHrN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mMNOoK6G;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nrPNjHrN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mMNOoK6G;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf17.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161305;
	b=2bHsMaOEgaYkR8DIAPswozrsWFvdiXt6vsdHgo3GCWfXL30vNaWQTaf3jLxoAFYs4f9w1L
	lfi7emvKa9yULzbhgbYiJ2XluuJd+4xjc+akK4I3IByK/oUxY9pdJJnENTfgzRZGufsJfu
	+TdHQ6jnMSle++EvjKV3KDGL3xUIXN0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF34B1F445;
	Fri, 16 Oct 2026 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792161303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=nrPNjHrNIwZqSdnT+S2HVu9fYo8T+GCugireiC7KlLuJP4f+ehAQRuLl6pePQ6dJaIC1q2
	GNSYj3MEl4wuGijoCWZjAUn/twscjJOIeaosYj9t/XVS7rCZs/weJfF1y23VfbBljJx1oh
	5Z14GJ8axXI09jlYiKHygstCBYqeAVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792161303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=mMNOoK6G6Ocet99MnO8c8h594dYsTr4U2fP4oNNKJ3SNRHni99cmls3pXJoxSDUf/SaCBm
	NOQl+0z/7m2KJnDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792161303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=nrPNjHrNIwZqSdnT+S2HVu9fYo8T+GCugireiC7KlLuJP4f+ehAQRuLl6pePQ6dJaIC1q2
	GNSYj3MEl4wuGijoCWZjAUn/twscjJOIeaosYj9t/XVS7rCZs/weJfF1y23VfbBljJx1oh
	5Z14GJ8axXI09jlYiKHygstCBYqeAVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792161303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvevIo56gnD9RKfRjHMCZAoapMkclUhhZLXxXNOsKFw=;
	b=mMNOoK6G6Ocet99MnO8c8h594dYsTr4U2fP4oNNKJ3SNRHni99cmls3pXJoxSDUf/SaCBm
	NOQl+0z/7m2KJnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD7C61378C;
	Fri, 16 Oct 2026 14:35:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNLIJBY20mr7JAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 16 Oct 2026 14:35:02 +0000
Date: Fri, 16 Oct 2026 15:35:01 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/2] ipc, msg: Account msg_msg allocations with
 GFP_KERNEL_ACCOUNT again
Message-ID: <atI1-HjSgPkLCNQT@pedro-suse.tail5790ac.ts.net>
References: <20261014052338.nothing.279-kees@kernel.org>
 <20261014052344.384723-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014052344.384723-2-kees@kernel.org>
X-Rspamd-Queue-Id: 33DBB40002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 8k4wyftkbxh83gi7rbuwdwg3wkj3gogr
X-HE-Tag: 1792161305-712488
X-HE-Meta: U2FsdGVkX1+3DN5kPMouzEPlh4Jps9lX8DPGH5LV8+wXdKw096xqJ8M+n9dzP25Nc13dJfhi/YIJI03D1qzZCn8GnybPcvnpklxrcSgo1n5wKcQ66SyPwYa4PVLQL5FEbDxslDKJYJHoGcIpZA8KtPQhHM/8K5YIoC73EFjbBHHxbThY1GW5XvHDaSPgVnhsdMxX6SLfJcGgljlTaj4lEot+KFooQ/FUMmpGeu2463z8gkrv3EtwFpemYA8jZ2m2P/No/GTWxz5o5VNqZrpkIWkgI6V8J8PtOUHNeRqQTLjxq8qLVY7z2vyg3WEGpmt6Kuy03B3JK/Mmv6seFZUsApX1V7o2y6COSb0BHOyPRLXdzyrC+8mN/n2qi8SEl04gDRH0wOcmG/NaV1VLQKZxepuW8psf48WBrnc3g0alhs0J6PtjcI1DEU75LZGOTHZ1Zx4vEG+LkKIFYfpm2rbwDmYD2MA1ZNRM0NWt+/o7zKZGl776QPy6FwvpDrWm7TBWSdThWZVcD/cnrbvXp370SRl0W6DT2xCs842WyTq56lU8YOM6yChGKBfUcHZGGOaX/c83Dv/AwUCrsKUp2dLGJtqfGTpWDWmWxJTY1Rpf176A2kJdKWENsqKQ6ODodKYlDQWTf/pBkByAT+jCvwqoTTFLFEkZ+TqDejTmnRJNNKsChMCXgyByKXnaQCQFeI0o69SgSr+lPmzZiFZAmT9r5jZmdxJzkOVRLGt7LGnMoWWAVy16xyZ75PawdF4GdAT/MQ3BGH/JAK1Ay0I/HM/Ot7FHW114jLRwXauAsx655pAb3xjB4c6Inik37u0f745TO+XcDfC5SM9IbfHMPxuSdwTBdL61uKeyKl3m0hN8KTYGAxbnX+p3OHjspxwotutceCENS4BmBCsu1YEUo/l3wHt+GEiDzlPuZgmeravqOILteif0PbG2bF6rQ7yfGtXJuQFb4WMjapgR1D36Bzl
 Jrmw3Zi0
 k7Bc/M/lfz2ER822ralW1DCbuACUNObSBxas5q1xGd6RCnvQQlwP235xhCjnIwTz0IdNw4ybcxcORB15qLq9rWc+HyW7Pa3n0INVd9/88bVviRRaCXmgd18d0C/mVUn+fvK03q223CnQWjs86uTJ4e6cLgsY/et3lrLP4SFyjrxtfqHQOpPMgi8Zr1gfwzCVJKWIVOveYXt0LVejGaL38Ww5gzUvE1Kf1/nqNCf91zQdarM/JC38vUTEIkKC/pzlbGZx6e7/CXxvVQ95u7/aN2J+BDW6rLLfbUta+HIlNUAa/jb+l5ZlVX8bkFzFAaC2slTkbmGSLjKS2Uvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:23:43PM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches. With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.
> 
> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit, so the
> allocation is charged whichever cache serves it.
> 
> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
 

-- 
Pedro

