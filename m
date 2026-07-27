Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6D2C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F426B00A7; Mon, 27 Jul 2026 14:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F396B00A9; Mon, 27 Jul 2026 14:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E386B00AD; Mon, 27 Jul 2026 14:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 130156B00A7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:21:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A263A017B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:21:08 +0000 (UTC)
X-FDA: 85035373416.12.282A011
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 059B1180005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:21:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sFCBoWUU;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQ4rvhkya2fSTiIGocjlzq+705xNxIlgjGPvKqk8WCE=;
	b=C8dIYaB1NqZn569QXMKlTQi86psfM9jmBcfMoZTvsU6B+D4fZYMv26czTm/sIRmFTx9ly2
	5aJWoWJd0IAFdX/DfXZ5q8SDKPwwOPWYj4lD7xNkSmQsbqgBhTZ0wcyfhDXwBjBqMqUNL/
	59fTWnvrE96caUezPsavRQBL2JjEDw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176467;
	b=OSzPwBnZ1636f1Yu+flfDjX78Qy0BxfAW7X4Dv7M5A2Ce04NBg4chCHwKo3CZ9il3Enx5I
	G5FKp1l/0LAlkjB83fb6Oa45zpCZqbqN9wr3D9xh98WCSW46yuxHQ8yq0drHtDSwWBRcaM
	FvrbiTwwnYaaQknwUsWggEw1ea5mgzU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sFCBoWUU;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bQ4rvhkya2fSTiIGocjlzq+705xNxIlgjGPvKqk8WCE=; b=sFCBoWUUjmQrn9tNM8L/Mt9RbL
	ErJLZbBhPPBL1oOZoxwgY8VXtJxOqD+XgRxB6FiP5wQgyo4aRZToporXWy7WDzWQ3zd+IkoW7ufiD
	Wcz5oPsLv6jD2DecxMLS/eqwv4D/Fok2KEDa7+LBIhOkTcwzckx7rck3ZO59PrZy6I89x5Kuz2Acu
	ExrN7adRmfscEVOu+CKiFdPZgFg62uY2sVb2zGZtHdi8s1ovWuP7HxjQBXjyKQAlPomqvdsywgY8k
	gni1QFD40YBqOLOZzpFqvubGDtDmy3AEOwOH8cX0jdqIvtYHiedEbAlnAk4Qy16sKpyLLExY/oDj3
	QFQl8Dlw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPwY-0000000BDxl-3gF9;
	Mon, 27 Jul 2026 18:20:50 +0000
Date: Mon, 27 Jul 2026 19:20:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	William Roche <william.roche@oracle.com>,
	Jiaqi Yan <jiaqiyan@google.com>, linmiaohe@huawei.com,
	ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org,
	harry.yoo@oracle.com, osalvador@suse.de, jackmanb@google.com,
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, tony.luck@intel.com,
	wangkefeng.wang@huawei.com, jane.chu@oracle.com,
	akpm@linux-foundation.org, muchun.song@linux.dev,
	liam@infradead.org, rientjes@google.com, duenwen@google.com,
	jthoughton@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
Message-ID: <amehgk7iUTL3Cow6@casper.infradead.org>
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
 <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 059B1180005
X-Stat-Signature: irhjbio89rrb5ddmuyffn3uht9hpimhe
X-HE-Tag: 1785176466-433256
X-HE-Meta: U2FsdGVkX18Hb5edF33sI7MroLBP+7R95SbSnNPnTTiTGeif/vfC1/VrTVFZ6HBVsf3CtVHW5oY3Vmd7/JOnq0FcLWkkeaq+gYwuiYp6N1OxUsELct62xH1RMzlWYqzXq1jYPlYAntGR5hi8DGhtrhUrSyt1sXyg85chO5Sg4Q4bOKdNlWhoYRrmwrr3NVDjHCgp6CRR59MXqv1xdMLNi3VeKHEc67fjHrwhgqqzTHtn0x29m+E9Tn/EPpBc+xr9o1Fsl2FFcpFtMNivUteBP6BNYX7rOgw9IuZbgFeWOkstXTmtqwT6gJsyeqHo43xQyCZtF8nEo87J7lxVdYCw83jQ9xHJJoir75qtxu2/7Q1sqDPTZ+9lpyE3KarmelScepM10ssX1YZUeF3pDgMENyzAfnmncLvkvLoHfc5cOe8lHhXX0Z+/Ot7oD9i9rl0EeB89x2WpcDGgt/oEiLdG863ReYRmckRl9Ogsjdln9wwBLhB/TgYqmjG5LoReR+8XlldxDohsj8D9BwDeHxFcqnWRxmU2mNgUFI08GHIxSXqcBjJvYu0nlKndG/hIx2+4yVeYpqI8T2P5rUX9kx5r7uUk5OzaiHTeBZzjBWmCC91bsdmpewus/lz/US8f3O/TYylNd8Lc7XR8xJRNpdoM+YXmfp6Wn9TpsDwuJHtPRrLn+ppbXWXQKywZmT0D/dao5HY0x4JkjEiSuRBoMsJ1w7rgy6ASv0/kuWcGb0N8gN8fC3LIsr9tZ7IHbqHJI4XoIvlKUVyagcnEdO+cvIsCzshokwfpdDs2EwlM90HYcFp3yjqsafBWYc54VmKTaDRTm8wDgIuCtZtSOPCuXu4vcKIz6EcenJlBo83dXMsvRgE4XoWHX+K3PBQsO10hxrq+WGVO8wAI4vXZTIwdqIPaiMpNzGFfNub/rOyT79apOSM1zSlefTBZxShn4Z/hWuBVwLZD/Zn4duR1zqTJBWu
 AfnP9H4l
 KxNIL+krJXO1GdBhEt73CIjzNqxqM4kO2xK1nUm/+jtZMTdGyTzeG+1roJRfIYV9Mnlf1wSvMAzu3Zy+u8DoXgNSzjBQzA1H0IpFXMX0MHeJsXOCpYgXh/JPOjHbzOo1kytIMizbKIXJW6ZlrmvjAKXNlJIds/+6QHqWYOa3kwXRpdZ2XzA3mZK5PsxNsEXsPEXnwDd/vrCDW0ijH9tj8p8/GhOD5QOzUhLEv1VDUv/dIdag9WScW4Ya2Xfe0sK1tbkNkNdpJxJoFS477qcYw7sTHEGgXQBF/K9BpJTGSadyegA/UrcDnVuD24XlHkyuD88FY6YP7V3+0eYWf9MhGKuVc/yF+Hq3T8QouQP9bUXbaDoPxS12MB0agD8SWBIaJGblzLS9J/+oy2Gk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 04:20:54PM +0200, David Hildenbrand (Arm) wrote:
> >> Just adding a comment about this aspect:
> >> The check_new_pages() mechanism used by the __rmqueue functions should
> >> filter these pages out, but this has been disabled by default in 2023
> >> with:
> >> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> >> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >>
> >> So it would need to be enabled back, taking some of the performance hit.
> >> (and I personally think that it has to be done)
> > 
> > Would it truly fix the issue, or rather there would still be a race window
> > left where we check that there's no hwpoison flag in the re-enabled check,
> > and only then someone sets it?
> 
> Why are we checking PageHWPoison at all then in check_new_page()?
> 
> I think we created a mess.
> 
> The PageHWPoison check is not just a "nice to have" sanity check for kernel bugs.
> 
> So it should never have been optimized out that way before reworking the bigger
> picture.

There's A Lot Going On (and I don't think I understand it all yet).
We can soft-poison pages while they're in Buddy, for example.
And then soft-unpoison them again.  Is it handled properly?  I doubt
it.  Looks to me like it's full of races.

> > Also, can the hardware actually detect a problem with a page that nobody
> > accesses? I guess if yes, it's only in some corner cases.
> 
> Yes, quite frequently I think.
> 
> > 
> > So I'm wary about penalizing the allocator paths again.
> 
> I get the feeling that we don't have a proper plan on how to handle HWPoisoned
> pages. We should take a step back and discuss how we actually want to handle
> them instead of optimizing here and there and creating more of a mess.

I feel like there's a general lack of understanding of how hwpoison
works amongst those of us who work on the core of memory handling,
and the memory-failure code has not been kept up to date with how we
think about page/folio/memdesc handling.  It might be good to have a
BOF at Plumbers to share our (mis)understandings of how all of this
works yesterday/today/tomorrow.

