Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F126ECCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8A26B0088; Fri, 16 Oct 2026 11:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963CC6B008C; Fri, 16 Oct 2026 11:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BE36B0092; Fri, 16 Oct 2026 11:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 582CF6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:41:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B542C804B6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:41:46 +0000 (UTC)
X-FDA: 85328904612.09.741A451
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25BF9C0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:41:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eU+O+S8w;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792165305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxH6DkhqLCrufeYTYEwrZTsGvgraVA141qi17FQA5/M=;
	b=j4qO549O+t7SWOsDyts8JDf5H8VgP/5Zc2BOSVko0SpwMq+mnTLplDFSSLZSPLyNlXHtwW
	U2w/iS5usOGWMan9gQXwd2CyjlX7SO2EUlZbQvvfmDsh62tOxTG4xla6zJDaHgpgzTqpp/
	yB0hUUt9XUlTmLX6B+q5p2fRdq9CK9I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792165305;
	b=SzJFZC0NNUmXPFLXsnc3ZhzJMLlWqWV+LkCzSK6gdi1HgAgk7C1GLCTBaRZTXqO7HtwFDj
	VCbxhK229oWUsPQV05frbYLNYctI9aj8rSRMUOQHuAX4f3qfe99aFjlcLp8nA4IpaSr8iM
	PhkzHnx+QONQo8Mi1+pem/7V1WhH4XA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eU+O+S8w;
	spf=pass (imf10.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDD4243A1C;
	Fri, 16 Oct 2026 15:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DFE1F000C4;
	Fri, 16 Oct 2026 15:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792165303;
	bh=NxH6DkhqLCrufeYTYEwrZTsGvgraVA141qi17FQA5/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eU+O+S8wgpGDtS96N4yUHFCa7f5OCOrTgJsoWlvmwEgFyXteoj0TjQGZIBzuBsEet
	 5+SIRDkZ5wUSpaEO40q8tFjQ0lHT5T8CYYbvT5pLfVjsnyYcSY9o5kFEgr9Yf7WD/y
	 4clKaDRRqpSOOBJgIOPOtP8pRM/1bID1pa6TfZ8rU9TLpGNDKOxKVOLzwXeIQ7g4nP
	 Rq/43UNiOvGAKfBYO0J0w2Fdcw9HTwLQNzVbkl6yvr/J9eud5z3NNu9aACbmEkFSqu
	 d8ymw1M4F/g7BXheoUDFhHda1Dcp9wuIs2DAshof3eW6pFGssek1/aTOf1iEYkPyZ7
	 fSvTuEazNprPA==
Date: Fri, 16 Oct 2026 15:41:41 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <atJFtYbWKpL2qQ-a@google.com>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad>
 <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
 <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
 <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
 <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
 <atA2g8OgpiNOiVL_@google.com>
 <atI30-1q2iEFPEbR@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atI30-1q2iEFPEbR@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25BF9C0007
X-Stat-Signature: 67fcdsb5dd997pdxx6mp4z5crzjuyn7j
X-HE-Tag: 1792165304-590919
X-HE-Meta: U2FsdGVkX196VTgEW22fsi8CSaCm7VbsDgLbPUuewN/KW0N5PZw3T6d1MdDoXc+eQY5js6Jp6HZ93aBza+lLS/4tB7qM3Uftov/eHmGFh9aTt3BNbt2clg9Y6LlKEL+uk/Xqf9sxOYb4lE1JieVE18BLus6Mq/B2wn1L9l7FjWaZQBhfUMiyZ86C3lMW28xDGsH7VoTIUUSEVU2pdM8/lQ6UmRllS6uEe2e2X6TAahLw7hGEtMkKmAS/HIzjACwYBfUr0+8BvlsB8+ULID2MIIOBh4KvnOqtQPv8GXLrr+GYkuZuTVTc02H/YlgnWQRVljzE/SERMkMmmuRkczAIs6FeSC8OpLHAElDIIExV8yCQnnrZnDY4odH9CK7Ue7Z/LNNle+KmFZuNC/bgb3wLtMqFK+gXJilHO8FdWkmCTd1yTGzKTsyNMm9uhwFQ1iPjntI4f9O8k/bmJDy26moiTGY7jQaSOUAYhsapud/lY2sG42Hqy7hSL8DpctmZ2Lfek9nXVBdDnbbWkhiaK+qoBUpIQOBaOHGwA80453DVCjUZSsOpjXDO+qyGCfHh7AQsL8e4uNOwnNEfPRb6xNIEG7gEQmJQJdlGVk5L/CtWh8xSlT+MqBvFL8DkcmGBb8yVM5qsP3MsTfyf04+sy2X5IeYNGyZFIwkUQsQXtmCTzqOqqMN+HRFSD0pXdx9Wz4rN2AWwLPSvayWG8SxYusI090S7QQZKiK/ivUlqKJWs66Tv2uhACZhEbGT9KHcrK5tRcjao/dHgS7eOEchuMCEmYD91KqoVsgDQUefm2iNITHhS3PeQ0z0ThUgsSYE77P9/ASAvEnmV8ZPz+W4Evj3mk7/4HruMgMHMjAZ6Zg4qjjwZleOWaJ3rBQDbFFXYKeoS2keaxMkafiGZNy6VP1cLOujAOTwbZho+vQslw3/hJW8EKjUu00t55a7ASkjpC91MquHf9jAy4NQx7v9r2A5
 eT0Av7Ar
 lGVFFAhuFDwcaeOl6buVv7JlNKfJ+Th6fegVgggL6iNrtBuNY4zY/a4qYIeFxH1pM//B/MWFXFS1rwOR5UvgeSdRKBHlOV/3VuaQcEl3y0yR6QeCJ2kyN7dIwqANXYr52Eg3fwN1gLSdj84rVWuk/OK7d6Ti/WDqBTH7ZA8XJQBfzLPEuwMI6mJYdLy926AEIKWkf5WhM5Nuqgo0aNkV6iVb87FfhUEetmx1CFZmDxBzas7wOkoakHeaFe7K1kdTQceV2bEc7c86l1uWeXd+sPvgHAqk82EEMnffaLdkg3bHkZYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16, Kiryl Shutsemau wrote:
> On Thu, Oct 15, 2026 at 02:12:19AM +0000, Jaegeuk Kim wrote:
> > Indeed, it's a bug that user can see zeros between F2FS_IOC_START_ATOMIC_REPLACE
> > and F2FS_IOC_COMMIT_ATOMIC_WRITE. I think we need to move the truncation path
> > into the commit phase and use truncate_inode_pages() instead.
> 
> What about f2fs_abort_atomic_write(inode, true)?
> 
> It calls truncate_inode_pages_final() as well. As far as I can see, it
> runs on the last writer's close (f2fs_release_file()), on flush when the
> atomic writer exits (f2fs_file_flush()), from
> F2FS_IOC_ABORT_ATOMIC_WRITE and when F2FS_IOC_COMMIT_ATOMIC_WRITE fails.
> 
> Can other processes still have the file open at those points?
> 
> AS_EXITING is never cleared. Does the inode then stay "exiting" until
> it is evicted? If so, reclaim stops leaving shadow entries for the file,
> and with the rcu-free series a hot folio of it could be freed without a
> grace period while a reader still has the file open.
> 
> Would truncate_inode_pages() work for the abort path too?

Yup, we revisited all the cases and the fix is coming.
https://lore.kernel.org/lkml/20261015161714.1586334-1-daeho43@gmail.com/

Regarding the truncated page access during the transaction, we reached out a
conclusion that the user land provides a synchronization method to prevent it.
So, I think we're fine with the above patch only.

> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

