Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0F2CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7666B008C; Fri, 16 Oct 2026 03:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF6A6B0092; Fri, 16 Oct 2026 03:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D53D6B0095; Fri, 16 Oct 2026 03:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF4CD6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:17:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4F42A7CEE
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:17:20 +0000 (UTC)
X-FDA: 85327633440.13.E05A38D
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	by imf09.hostedemail.com (Postfix) with ESMTP id 46592140005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:17:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDmM0CGp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792135039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8upW1tRfvAox06fThrU8ca8rWxA0cOvzPAcdpCrqFk=;
	b=n56Os410RtoEniU5wXqGJ484wyAXQmxrf2UpirJRYM4V+U+vsfFYREwN39I/028wevbzAx
	1JnFM7Fzsy5taDcuK+pujcGpmU3z4QQ/uIBkW8RamAmnLl+ciILTkShrkDw+cpB/c45q6X
	9b1BcgYTbgJmP/Mbtogh0N0TBFaMRBU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDmM0CGp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792135039;
	b=Vk/HG57L/9+nR7gt7unq/PadLxMQ+VWq3b0DfLBdrH0sbi5KfMy1WRy1+5JXlfVtAol53G
	ZuxZwUIIRv7T8fqZANPbAtbYAJ36uWm/RVN4fn+nB3EH6XP0FYqe3Z1tn8cKouP6P0loNW
	kB9ZkyShbv1Kiln17U3bVyHGhTNOzbo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fGHOWXbRTwGx7Yxv23lsiLlvnmkHusi5Yy0Lxv5YfdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792135032; v=1; x=1792739832;
 b=uDmM0CGpVpoUfiHpJnARnrntdDQdeGzhLbYbIe+gvvE7Nj0TqOkNOe9fk9AjsZl+09VXbc3e
 VIUFeVkqHNFMxOY/1NginI4otivraK4Ox3AVpkWeeFs0ng5vREno/QlMxJ7bxfI94yiJRblTyDq
 /lYlwN2s5O7Vyaic3HDQczcA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id b663a7f23a3f7381;
	Fri, 16 Oct 2026 07:17:11 +0000
X-Mizu-Trace-ID: b663a7f23a3f7381
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 02/10] mm/hugetlb: fix use-after-free of a new anon folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-2-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 15:16:54 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <370ADC80-F15F-40FA-A71E-8D641D060138@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-2-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 46592140005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: b1x1wpaqo4dmd7hgxnqqq9mfpcptur9h
X-HE-Tag: 1792135036-460971
X-HE-Meta: U2FsdGVkX18D3h/eViMb6qYWdu4MDR3CFOtyKmVzY6gYcLZEhNmxjdCpTExLhAxXeYbCyEcoTTBd5yTyz8ZSgdEo4geAyUZljOzVv9rAfsZGiPw50g+c8HhAKaQAs5QBx8EJHSrkkjbMLkA+p+y5VNjprAhgXDVljlcFhBWlGvdlzg4Rgkp9u2s68oXWIsnoY+JgL6ZdZ0siK2rMwj8EwmuaVWRY4EqMKH5Lzm7ZnegWrkdsof68T1lz/tOLXbjFpGpSd4lkKh3AX5l0cnHwGIqG/gdh1/P1beWOWo9y7Dv/TeIireZV6vzM4fXlQIFq0wSPM0kbZaVP9K7fpli4LaEjrNln443Dp1MtmfWZvxoffonVKHHE0oOyPjEZCK7C3mAF2z1GX6Fb7QJdJygXnC/+amntuQH76WdeEiL/hx2gz5SQpW+WCnhOhKvSdfO39I0lcVDCiZMa/2sJtfMBHjRkHwcGDAdlLifcB29ibyzrqz+zz9WO/GgGKogXN5v3njmOkE/OgFt6KN1zL09r42MJHX0Mgiwhyp0Ef3nqFDi8AbuTTyfQlV9emzhocz6naxslnZpsjb0np2c/xq9U1mmETd596fgtaeQdDHmd/Xz//wy3WqesGZKk0k0Fnmj2RFOuPZqTiLMbUdwD3Umg67DNo5sHx1OX5PD95l5ls93cSms1rdOHcqOPduaJio3FaSIdg9Xgg5zbzoYo27zY9clfVf4U7fq0c1xaj37N4/6HgO5OzGdBQJLFqSDvGSwajcWhbYZPhn0e38Gow0lLrtdxLILRoAo7atTPQeKqPHR6iebwxD88ipNGQ6XrhZ6iAnN+d06MzoFB9Yt26Crndji7bp0TXtkJSdAFuMarqqAYUfzWLb/8L80xC9cNj3WlXogtoz5Zi1HI7elLQl5iT0yHGVAor5iy6BDK/m1RmLG9u6gYS1jQbYHM7+EPLQdPheO+EUZ60XdR/pF3w/4
 uFqoOvLn
 ua7P6gFwmxQV4lfZqK8LKLxdiKYWN5RSpPTmItH0cO0NUiQnmJSwo5+sW3l4PruggOPqryw0UwlSjWws4iH2TJxpbkMxzyHJC80ZNLi3nQoVqUisHiYvTp4UJF44dF7aGPbXcKmfUyrB7lS+26pUQmAWHm733QoX8DfLJTpWZUCUhlajjdCfRSBJ0HKjCtuisYvUK2CmYnOR7PgbiNVuFq+fHpAQgiYWPVoXKz84I6vinmmI1kgfmiD5hWmCvo3gpIBbWcJKduoEwlbMOikrBp5l5of1c+qIIf3Ak/Of74f7NwBgnXK/MSwTE91bPM3dCSlpKqmEfECiuPRImGHph0mVvQ9IjDYSBAAlmjNRGuKfvH6naWtUAB6n90mE0bfAzwp2IKqzzZnoU0CDEIjLBag0sluPCq/Ho+eyD60X5iN6U0Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> For a fault in a private mapping with nothing in the page cache,
> hugetlb_no_page() allocates a folio, locks it and maps it.  The folio =
has
> one reference, which belongs to the page table entry from then on.  =
After
> dropping the page table lock the function still sets the migratable =
flag
> of the folio and unlocks it.
>=20
> Whoever zaps the entry in between frees the folio.  The fault holds =
the
> fault mutex and the lock of the vma.  MADV_DONTNEED and the first =
unmap of
> a hole punch, hugetlb_vmdelete_list(), do not take the fault mutex, =
and a
> private vma only has a lock if it owns a reservation map: not with
> MAP_NORESERVE, and not in the child after fork().
>=20
> Then the flag is set in, and folio_unlock() is called on, a folio that =
is
> free or has a new owner.  A surplus page goes back to the page =
allocator
> while it is locked:
>=20
>  BUG: Bad page state in process init  pfn:108e00
>  flags: 0x200000000000059(locked|uptodate|dirty|head|node=3D0|zone=3D2)
>  page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
>=20
> A page of the pool can be given to the next user, of any file, who =
locks
> it and loses the lock to the late folio_unlock():
>=20
>  kernel BUG at mm/filemap.c:1532!
>   hugetlb_no_page+0x111b/0x23e0
>   hugetlb_fault+0x3a9/0x14a0
>=20
> An unprivileged process is enough: threads that write to a MAP_PRIVATE =
|
> MAP_NORESERVE hugetlb mapping, threads that call MADV_DONTNEED on it, =
and
> one that takes the freed pages for another file.
>=20
> Until commit 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for =
more
> pmd sharing synchronization") the fault held i_mmap_rwsem for reading,
> which everybody who zaps takes for writing.  The lock that commit
> bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs") =
gave
> to private vmas closed the window again, but only for those with a
> reservation map.
>=20
> Be done with the folio before the page table lock is dropped, as
> hugetlb_wp() is with its copy.  The function already unlocks page =
cache
> folios under that lock.
>=20
> Original fix generated by an LLM and sent in private by Josef.
>=20
> Fixes: 3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd =
sharing synchronization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> [ david: simplify+move comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


