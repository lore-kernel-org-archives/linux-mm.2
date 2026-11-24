Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D0E606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ugOr/v4c
Received: by kanga.kvack.org (Postfix)
	id 5E4CF6B0872; Tue, 24 Nov 2026 17:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595906B0873; Tue, 24 Nov 2026 17:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484BA6B0874; Tue, 24 Nov 2026 17:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7F06B0872
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:27:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF64980D14
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:27:09 +0000 (UTC)
X-FDA: 85471449378.10.8F07D74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF506A000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:27:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ugOr/v4c";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795559228;
	b=L3iISyY8UOjpk/b2xxdmFsMUGsckjLta0wNKtGc3yoRLk18vp96cnceJE0oM/0J8ND2iMj
	9RzwJgOYOWgh1PWB8kvomLAGLAaiqQDmz/D5kLkpl6LW3fDLI5B8HOi0AdHjeM63k4fPkT
	zvGT4cQFPbCWUTDmJ5kjm46OsKESCWQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795559228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtMZbHm3lkM6o/yW+HmQOChZENqEt7jGlIYiYyXmUrc=;
	b=rIIhS75PhtWrS9Wv38vSL5RSn0smChfZy+vGlZqCxjyIGK3hMSUzKksd9BsjbCkQt8bT6h
	CUVeCRn/HVuibBFmW+ul9Pqe0BameyRw6P9UHHkFb+284cLv7OkiECc49VAzWapE/cOBvR
	BjC53YtIhrlNitHbFLzpC41C9Wjf6pQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ugOr/v4c";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 910B540E04;
	Tue, 24 Nov 2026 22:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5741F000ED;
	Tue, 24 Nov 2026 22:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795559226;
	bh=dtMZbHm3lkM6o/yW+HmQOChZENqEt7jGlIYiYyXmUrc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ugOr/v4ceQqckoPQJ/g4UCaTyO+koHIT2A4RUIfXBsU1JVNTjLPiYJiVbIG3PBhXs
	 cQ9UXFCWsh7ke9FpqJnH2bUu4Jume8Vz7EZPuKtb9E8g8EMBIGl7EyVWY/I16PMPbn
	 B5BPEJXFGwvq3OGEHbKmuOIcSyHevi31Sq/46n4I=
Date: Tue, 24 Nov 2026 14:27:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, James Houghton
 <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Suren
 Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, Andrei
 Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, Zi
 Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, =?UTF-8?Q?Miko=C5=82aj?= Lenczewski
 <miko.lenczewski@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>, Thomas
 =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>, Lyude Paul
 <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
Message-Id: <20261124142703.8b6e07eabcd510e9b99b03a4@linux-foundation.org>
In-Reply-To: <3ebb01ea-fe77-4467-a1de-7f30a91593f3@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
	<4f23b0bc-b89a-46c1-b8cd-853e7815b7ac@kernel.org>
	<3ebb01ea-fe77-4467-a1de-7f30a91593f3@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CF506A000D
X-Stat-Signature: e8hdrqpg1z3an3zj5ftcx9n876hcihfj
X-Rspam-User:
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795559227-936604
X-HE-Meta: U2FsdGVkX1/eHAtl5Q2UID+/c7Z+I7Hd0eveVxhCEh9Zxda7CQSZcmzR/jLgNYrVpFgGao2gnRMBTZ+Ta9rFWbUr6u4oLwuwHWVdBoCMgdlWBTTe73WDB/1BAhJU6/WZt7/Y7ryL2wEeFncBAFvx7BFwffOaJDxv3tptTGp9f76zWPf2aVCpyUqppVg1st6IekgPcGpALKI5K6iV6JSh8maAUrcvNLlRzKJLyHkxrOhglqlBP5wyErNC/4Hv8fH7ivosuCU/GKxTb9Uz+iUb0rBM69q8n2LQSeBKlH5Z8cJVPIYzErU5bEL8dHy2OqO8ygfg7oZbGFRHd/Zul4bmdnDpdK3goGw4QIVIdGDcEfi+7oPur87AGAjyZqsDsWR67ENX1ewgCwdNQ6vMJQ7x6KyyQpXz2pB0DvMdL2T6Pf9cxHXIwWJ3m7ysLMciMsNLQ5IIuCeQRj4jQRLmfuLNIAwShJQn10ihXCjLcLg00uH+JJcDzi42e0BW7ReOz3gmUQvNbu21X3c+IFZ3aShZNT+VDmQmmNCpr6Y+JfUVvG5i56/eAnUhzreub9U09a5rThqGDcnaPxPkJB/bZdpV+lgHM9pwe/ZisFEbZVHCaKNamyeJ6ZPl4K0wxZRPGoea4YFStbkeYH6P/8QRk5FA41gVs/ZbtV5OlFxh3CZoaZ4ZsTvOaWp5ODrlsmlDp0rt28q6IqaOma4HXjvhpGbQZphwQYYLF0dcKm5a3MybhAeYuqBNXSYLONyaNvyTfpSiFTaamJBi3hrtcADAohPDKO23QZmzulEdrA7xYwvn8ukGZZ8MZk+ZzNGRCzeB+GUQiCGNYYy5OcrxwsxOfaxQtxc2D1Cn4Sw5LXa6v2gs8/YKjVYOmHxgahkz//pN/GDY+9veclGvxbigj7ZnX5C2KjFgiTwxXYIZI39Qq924d85OKLC2BLQ1t9JeN9xBLmm/hAA4hM1odqcEpJ2Y7+U
 4foOZ4za
 eyt5rpsBLI+u463xRDu1jPx6YOIlfobm4FER+8du0p5igglGx6ho4UmNo2MoHD4yX0rNX32XOAmgt1X+c8uMtgR2u8fgBGkPzf+Gns7Xui4AL8NGuipoPnmw+A2r8rhiBHGEWl6FRHYc3i5R9vWLXf7P0WsBTb3YDR03vVolSxASCynkBJfZzILzksIsh0Iz1rSF/90HS+qKmCo8P0iF4kyOQcD0/Wl71oGV7jZTRcQ/Q6jkjTlJ7JAy6CF9LGunxG5rR1hsVGh+OPX/po3ACc9EaTulRQej0VK7URUhkGXKzMSHTIoT7n16iY1NYGRBLVGSRhMypQ/wEsKoj63TJnMcB0WIL5xfpud+STmHn7iXWNr0IXYp7eXrqJ1qULgrFZmXC4ouCG64vv5yW6ht6Vol5ZRV2KN3oFdlmIoKjcah11+FLAOFluPNSplqvo11jADk+Hz9E2kgsYh0q81mjXDsAuBesmqQVrf84qG0IoPAmgCg71xo4MdDR0zuLuySVuD3I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 14:37:11 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> 
> 
> On 11/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
> ...
> > 
> > So, I would be picking up ...
> > 
> >> Tal Zussman (9):
> >>       userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
> >>       userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
> >>       fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
> >>       mm/migrate: warn on a writable migration entry with the uffd bit set
> > 
> > This

1

> >>       fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
> >>       mm/huge_memory: build the moved huge zero PMD from the destination VMA
> > 
> > This

2

> >>       mm/mremap: resolve uffd state when the context is dropped, not during the move
> >>       mm/migrate_device: do not migrate a uffd-protected zero page
> > 
> > This

3

> >>       mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan
> > 
> > 
> > After waiting a bit longer for more review. Andrew can take the rest.
> > 
> > 
> 
> @Andrew, could you pick up the rest of these (everything but 4 and 8)?

9-3 != 9-2

np, I grabbed 1,2,3,5,6,7,9 (whatever isn't in other-peoples-trees) and
massaged the cover letter a bit.


