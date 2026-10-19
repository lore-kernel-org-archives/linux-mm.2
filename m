Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885B1606A329
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZO1g0dwR
Received: by kanga.kvack.org (Postfix)
	id 728456B0101; Mon, 19 Oct 2026 17:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFB86B0105; Mon, 19 Oct 2026 17:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6152A6B0107; Mon, 19 Oct 2026 17:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 383AA6B0101
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:21:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FAD3A0878
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:20:58 +0000 (UTC)
X-FDA: 85340645796.13.658EEFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 655942000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:20:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZO1g0dwR;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792444855;
	b=dGlAd1V2/oXB7fhronP/flOqGtwrUD13ysE5ZHYPGH9eutE8g6RM2YLp+X6C7tkzQq1FkN
	Br97ytggtDrMywnW6kFZ2wYGc8OZQjTjJ8djWy5+2LQyfzdJkfxauMXeb+znUBfFpj9Q42
	XYoVDauKL10o8gbc8/J9gU35eSpxL94=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZO1g0dwR;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792444855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptUqxl+FSgqXww7qutPBzfxssS1laHZAufEmAd4CAbg=;
	b=p936w0FpJcy7ubcgOHpgZhVBTuPhZedy7g9Y/TOkXVCtT+yv2+KLxQa4iYfFnQghiNa7c1
	kB7qNX4wHJb46AcRtIoJ5OGCLiYaoegOCVdsely8i+4xfDbbWoyCpHoofgZhUVYCmRx9cQ
	EWD5nvieiAB7zGgjaXWIyN4GCMcIQ+4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33E7D40A66;
	Mon, 19 Oct 2026 21:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5FC1F000C4;
	Mon, 19 Oct 2026 21:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792444854;
	bh=ptUqxl+FSgqXww7qutPBzfxssS1laHZAufEmAd4CAbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZO1g0dwR2An6DWTYT1MnRSMy0VDM3lT2LPQ4okidvUTthZv9inrUnniecU775G5v/
	 IwLDeAYpkFiHXGIcKPYk+00oVgSlARzg/q3CRw/dtv/UQpMJ/CuvQkD9RLKURTc1ts
	 0Mo2k0XFL8Db7+9a7nN7ptrIDTBUtHafTOMp5f2222OHcFxmcMHkSShXVldqgwjS2t
	 6ofKlh6RWERZAUhWbI+YcbuIDpkSKgMCXyxVc35VBndwRXW3whm/Q0c2suU1n1LSL7
	 JcQJj0Lve42/9/rgOTFsFnIetEg27twNWpp7hgoYhxXqU3HA0TE/cB4MyORyZ+iuM1
	 z4JDvU6goV5wQ==
Date: Mon, 19 Oct 2026 22:20:52 +0100
From: Harry Yoo <harry@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, kernel-team@meta.com
Subject: Re: [RFC PATCH 00/18] mm: read the page cache without folio
 references
Message-ID: <atZurH8mp-yW3Upg@thinkstation>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 655942000C
X-Stat-Signature: 5cdfkggf6x55re34ngoj6ruhbd3xihu1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792444855-457575
X-HE-Meta: U2FsdGVkX196I+dOJj2jTLc6vFzpkMcGbRKXl+OXEsIXQHNDzcM/w+KSHHhCNEl51rbcb+3iI5KxUoSb75c9dCUmiA2Isk6H50N33FDucdW/rNs1OPbz+6KJlSmLOcuYX8Z3DR1NmINtrhDdP/tTEK7Hhlu69qKg5gTqB3ekKYXIGmS3V2OCssXD3x/b7n6qNO19Qkh8UjhsMFovlM0j2jNoUvrloyAxe9U+CP2wMnKLuFHij9USra6JiMjHxWo/8LoYYqyF6e1XLUJSrb6D5ZuEG5EH7CfFXxjH6rm5exKnlTxgFo+j15dcF6BLe4bzmoinV5/0JVDYjAc2a1IeMlEwwDYaXRebFx5haw88LRNnWRHIQqxi464ZJlEjUe4ZcdQsv3nSRNjHgNfSbZvhUmnSmoY/UcooVFSPNkrJXEhvTAA3wPcACLk4VglckTBeXAm6gbyWJZQoPtYMZ3o/Kx3DllF91uS4/eExM8tw7F/t6q9bMx3ihhZtpDnkp16w6o+kkhxJObLZ4Ep7tZUAkhDP3qnwi64b2O+iqquVfXKYQXsBRCcfm3J3BbXml4DPAq4aplhhmU6IF7J5yZSPX2abQbYhIugpZDxm7fw2icOEbbUaRKpoGyFlhFx2Gc0SaBnZqt9QI6MPKzr8hI2SgZje9C/xTFZ2k9v67iYKZ0T67J8X5q+5buh6EwLaw0P8Zz5hjjl8kHmrK4WUAuJ9EgcR5ghuLTnOt+J5c6OmmtUZpEV3KVx5RoU8ULdsubsT8Xrw5GVCRSZIveSUO910ttCTJAWS2SVcQv/sETeElCSwm/qmNlh/wb/wYx6k5MGtqX7iP5d5RDZi4oI5UA08MTNKxSDgClJZeS/kLFEkINxhl+yH8cA7TYjpp0/AEReYbaycENyRX6u5nZxUwhf+FgBnnJc3K0IlhjqubIGcRrKgpmvBwvD13q41YA2DmMKE5cY4zXRiJKJs0xF7bRx
 cwoI5nRL
 rznuqxmV4Rh0/rQmX5LRiKqr8fNytB7R/Jicyz0yaB3PNceJz+rOShw0b7VEgzlmrGVBLsIb9g/CTTcKCfaGuTQVOYjZjy6beVNhjatGEk9H1kzDdvwz3aO7WQ3noQF5L6Sut/LBHYIIDutAbNpKGRnGn3+j+kDrG07iiJdEx9kbL6SdRKifWwFPi6bwBG0oVQCM7DqLlDH8UWrGyi2ym3rTmHjciLchiFqkeqzpdlprL7ZetZGny8dclDH9/xbetMn9mZfIF8l9BNmMzhWRQlYAjWXHXrTFRGQUPhLLJN6x1hdG7awCpjKpqY3Ue3By+EcHdT7ANzp8XciGBMgVf3xHp0HjbQdvUbqBbxGG+illF+8z66kSAdtdzv7oaXwxLAsNMEHQlWR5yxf4kU3lEtjg/oZWI8dYpxGm9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 04:48:53PM +0100, Kiryl Shutsemau (Meta) wrote:
> Small reads of one file from many CPUs all take and drop a reference on
> the same folio, and its refcount bounces between the CPUs.  This series
> lets filemap_read() and shmem copy from the page cache without taking a
> reference.  It is Linus' RFC [1], reworked: a folio that such a reader
> may copy from is freed only after an RCU grace period.
>
> Only the folios that reads keep coming back to get the flag,
> PG_rcu_free: those that folio_mark_accessed() finds as accessed as the
> LRU records.  Streaming reads and data that never gets hot are not
> deferred, so the memory held back stays small and most frees are not
> touched.

By applying this to hot folios only, small reads would benefit only when
they contend on the refcount. That further narrows down the scope of
workload that would benefit from this. Random or sequential small reads
still perform the atomics on the refcount.

Looking at what Linus mentioned as "Willy reported real users having
scalability issues in that area a couple of years ago in a discussion
about buffereed IO scalability limits:

  https://lore.kernel.org/all/Zds8T9O4AYAmdS9d@casper.infradead.org/
"

On that thread, from Willy:
> Not artificial; this was a real customer with a real workload.  I don't
> know how much about it I can discuss publically, but my memory of it was a
> system writing a log with 64 byte entries, millions of entries per second.
> Occasionally the system would have to go back and look at an entry in the
> last few seconds worth of data (so it would still be in the page cache).
> 
> This customer was quite savvy, so they actually implemented and tested
> the lookup-copy-lookup-again algorithm in their custom kernel, and saw
> a speedup from it.

https://lore.kernel.org/all/Zdz9p_Kn0puI1KEL@casper.infradead.org

Again from willy, from the same thread:
> On Mon, Feb 26, 2024 at 09:17:33AM -0800, Linus Torvalds wrote:
> > Willy - tangential side note: I looked closer at the issue that you
> > reported (indirectly) with the small reads during heavy write
> > activity.
> > 
> > Our _reading_ side is very optimized and has none of the write-side
> > oddities that I can see, and we just have
> > 
> >   filemap_read ->
> >     filemap_get_pages ->
> >         filemap_get_read_batch ->
> >           folio_try_get_rcu()
> > 
> > and there is no page locking or other locking involved (assuming the
> > page is cached and marked uptodate etc, of course).
> > 
> > So afaik, it really is just that *one* atomic access (and the matching
> > page ref decrement afterwards).
>  
> Yep, that was what the customer reported on their ancient kernel, and
> we at least didn't make that worse ...

https://lore.kernel.org/all/Zduto30LUEqIHg4h@casper.infradead.org

From the discussion I'm not sure if the scenario above would benefit
from this.

Maybe we should try to either 1) find a better heuristic to mark
which folios should have PG_rcu_free to make it beneficial for wider
range of workloads or 2) identify workload that heavly contends on the
refcount of a small set of folios...

-- 
Cheers,
Harry / Hyeonggon

