Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC05606A323
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E0F6B0509; Tue, 20 Oct 2026 11:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405DA6B050A; Tue, 20 Oct 2026 11:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346A76B050B; Tue, 20 Oct 2026 11:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A75B6B0509
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:53:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82FD91201B5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:53:13 +0000 (UTC)
X-FDA: 85343448666.14.96F6386
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C0378140003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:53:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792511591;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2nsL+h72dFtAmnqxpAN7MT7M07SNoqgHR7SjbStemIY=;
	b=vfTuSnmBNm/AExeLue1W+shMxaGRZ5APqX2RC0zTsVt/BJZV1YYbBWUP7+uEm6qzJEmS7d
	IrVQrhda4oK7HeotdusV6yGYEMMH9MDz0LI1/vxjEk/pRoBl4MnCz2ny/CInGtA/Nb5kO/
	u1nehDm8WhHV/iOGZs3hUNNJh+9Otbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792511591;
	b=W13NC+/mfdEJNH+65VyOc9MGHotcJrvKAS/BFbpsEnGPMKj5lIj4rdEGy3BIBNbfya6v/G
	2XAhiMrvG03GUwdEKLc8Q6s2WGK+fCsVC1JgomtYnJOLNkqVlz6y+3Z0kN5TfTzfNB7AGH
	kojzafJNPndqTNve48/x6iXx9cTCDX0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3FF743F98;
	Tue, 20 Oct 2026 15:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B48B1F000C4;
	Tue, 20 Oct 2026 15:53:07 +0000 (UTC)
Message-ID: <sashiko-outbox-179306@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 08/18] mm/memory-failure: handle folios with
 PG_rcu_free
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R . Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E . McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Harry
 Yoo" <harry@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>, "Ilya
 Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261019154913.1765974-9-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
 <20261019154913.1765974-9-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 15:52:37 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0378140003
X-Stat-Signature: xt5pkg46fhqn9qnpe818bpbptd7mz57s
X-Rspam-User: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792511591-537377
X-HE-Meta: U2FsdGVkX1/QkJvco4eKrEy3Kqt/a6tnqgbzxjfSR8rkqIw3/46lw2p/QQOmmrBvOHja0JZfC0npvBzf5RIKH4ePzD67eofVrbWs9n5NqKXLekYAEgO8TlMlxOOoq+nV7YibHViQ+fq2fQx983b3BTX2CfFg7zNj9zbfyfDYVZgNovxyG256QSNqkZo4gERnz45GYfqsEXbaCQkdYHKiB4ErUZNoJ4shos7y6s7GarOzgn+TqDnOgKQIBkjS12+vrSL/ZiD/hOJEpRRWET1UKqFNePqWzhdW3H+nenmsITjQMjEZQZKG3EYqdYvQ5S0tawi1lo5odl+H62SPiHH8Zq6igPYyVRcJGLf8e9EcVfYoYCEMmAU7n8FJLmS2pr/czHaM0pgQd73UrhzLCX/s6B35sR93VTF9JWgZNlc1yL5xxQgESmRh4kbBC/fp607fMqxAzIDIio+Z1nP2buRhW63I3XrWjaOVCL3DHZLDHoTGg3+BUaz30Zg1q7wXhaFNFW4kJ7xCP7Oit3e8hxJ/js1z6BWBEIYYPduE4q6iBmez1q+aEjNDxOzU+mOtn99G+a7VhDFuSKzy03rpeKmTA01rYQ7SOEor5nb5BonSR9HAfksIcIRelBl6aQtT46m8FcH3Gvik/v4EyDDfW+oNc3+ZM9+dmqiS5PLpk04JRx01MKwo3GZpY0n4A/XbzA/qa56MvapSKgvmJM1NLDmzrCa0v0ZyIvXk7lSQYbM6F/TXDDxgpyTi/SyWkUD/6QhzJ6pHZ9uQArdj6NLXbeFFDJz3gTlt/T+TXnRBzFdnGJrP7V/XoFA9VJ4BIqUJpFl8aeWHFIreFtuWxFxhyo096Zp2f7gFJMbskuXwX2zPFwroh5+Wg3AcJmBlMQw2jxjhZNa/SucCvAUNQqa1mMtKXsB3x+s/g+uwhsyfyO4aHTSJLmx9k5GiBlho87Z67eU9rhtr4gZ7IUzVDuTMjfW
 qknPdLRM
 uRxu2SxLl2YZwQ25MpMFlpIWq8R5gTSV2Ln2kPyBENcJIupooAMaO65bNX8LgXxgTa0cH9Y9uoByGJxpyZ90+VYTIyNJN+AzW3nwySfJRSAtWCjAWwuYe3AGCg9sMHm8++0bVDMZXvaYUV6sY2CKxys5GTk1Zol5D+wRXG/pBdeaAAmlwJxGEL76XYV8X8w8jlojoAvZoeWRxOtuF9cKAKc5fBO0sezJkkoFPZJBzWQvrq24i1nISbdt6q6zb3GENl2TFDATWpbdW576aKdSXqjBDnbPrj9fep309u5EUwF+VzNAk2AV2mA9pbAWeVby4ES5SqaFc2excGmB8P2PfCZQ+0HNYM7VKEZGk/0Y7dtIrpMqvRx2hl9wRZWluF/6bTZAV5YXXN/viskTjtICcqkaYL52HRmUuc6H70RY3O6js76ISJmVfRHCSvrS19e8GWVvQuh2ygFLNCqRj2ImyWsVaUj8g8jKBN26gJt4BX8D6IlecA1WeENlheYv31/WIefZUCF8UyNAmwme3qQQ5v8Ek5GuZrDdxkDY3A5ZDg0vyPu3bS/ku7xvNgc1CK+hAorVURFcq5cVkCcTM84UdNrcXE1eTmuuVdZK82rksstoOz5DAJWmY9r0NZW/3yYXI5VWGVDR8dC92uj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: PG_rcu_free folios freed in get_any_page() are not drained on =
retry
- [High] mm: mf_free_rcu_pages() skips rcu_free_sync() during rcu_free_page=
s()
- [High] mm/memory-failure: missing synchronize_rcu() when kill_accessing_p=
rocess() returns 0
--

commit 0752670541e1c89c99d63ab6b10ada844735c05b
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/memory-failure: handle folios with PG_rcu_free

This commit updates memory_failure() and soft_offline_page() to handle
folios with PG_rcu_free by draining pages waiting for an RCU grace period
before attempting to grab the page, and waiting for a grace period before
returning success from memory_failure().

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 7dde7c3c9a0c5..dc66cac05b1f5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1565,6 +1565,21 @@ static int get_hwpoison_page(struct page *p, unsig=
ned long flags)
>  	return ret;
>  }
> =20
> +/* A page waiting for a grace period is not in the buddy yet: free it */
> +static void mf_free_rcu_pages(struct page *p)
> +{
> +	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
> +		return;
> +	if (page_count(p))
> +		return;
> +	if (!zone_page_state_snapshot(page_zone(p), NR_FREE_RCU_PAGES))
> +		return;

[Severity: High]
Can checking NR_FREE_RCU_PAGES here cause mf_free_rcu_pages() to skip
rcu_free_sync() while a target folio is still in the middle of being
freed?

In mm/page_alloc.c:rcu_free_pages(), NR_FREE_RCU_PAGES is decremented
before free_unref_folios() runs __free_pages_prepare() and returns the
folios to the buddy allocator:

mm/page_alloc.c:rcu_free_pages() {
	list_for_each_entry_safe(folio, next, list, lru) {
		nr +=3D folio_nr_pages(folio);
		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
				    -folio_nr_pages(folio));
		if (!folio_batch_add(&fbatch, folio)) {
			free_unref_folios(&fbatch);
			cond_resched_tasks_rcu_qs();
		}
	}
	if (folio_batch_count(&fbatch))
		free_unref_folios(&fbatch);
}

Similarly, in folios_put_refs(), folio->_refcount is decremented to 0
before __page_cache_release() and mem_cgroup_uncharge_folios() run, prior
to rcu_free_defer() incrementing NR_FREE_RCU_PAGES.

If the last RCU-freed folios in the zone are in either window when
mf_free_rcu_pages() runs on another CPU, page_count(p) is 0,
is_free_buddy_page(p) is false, and NR_FREE_RCU_PAGES is 0. That causes
mf_free_rcu_pages() to return early without calling rcu_free_sync() (which
otherwise waits on rcu_free_drain() and flushes r->rwork.work and
r->expedite).

In memory_failure(), TestSetPageHWPoison(p) then sets PG_hwpoison before
free_unref_folios() runs __free_pages_prepare(). For an order-0 folio,
__free_pages_prepare() sees PageHWPoison(page) && !order and drops the
page instead of placing it in the buddy allocator, causing
get_hwpoison_page() to see !is_free_buddy_page(p) and ignore the error
(MF_IGNORED). For a large folio entering rcu_free_defer() after
page_count(p) became 0, it is queued on rcu_free_pcpu with PG_hwpoison set
and later freed back to the buddy allocator.

> +	if (is_free_buddy_page(p))
> +		return;
> +
> +	rcu_free_sync();
> +}
> +
>  /*
>   * The caller must guarantee the folio isn't large folio, except hugetlb.
>   * try_to_unmap() can't handle it.
> @@ -2440,6 +2455,7 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (res !=3D -ENOENT)
>  		goto unlock_mutex;
> =20
> +	mf_free_rcu_pages(p);
>  	if (TestSetPageHWPoison(p)) {

[Severity: High]
What happens if a folio with PG_rcu_free still has a reference when
mf_free_rcu_pages() runs (so page_count(p) > 0 returns early), and its
last reference is dropped inside get_hwpoison_page() -> get_any_page()?

Inside get_any_page(), the last reference on a PG_rcu_free folio can drop
to 0 in a few ways:
1. When MF_COUNT_INCREASED is set (for example via madvise_inject_error()),
   page_count(p) >=3D 1 during mf_free_rcu_pages(). If the page is not
   immediately HWPoisonHandlable() (such as !PageLRU(p) because it was
   truncated while in a per-CPU lru_add batch), get_any_page() calls
   put_page(p) and shake_page(p) and jumps to try_again.
2. Without MF_COUNT_INCREASED, if a truncated PG_rcu_free folio is still in
   a per-CPU folio_batch, __get_hwpoison_page() returns -EBUSY and
   get_any_page() calls shake_page(p) -> lru_add_drain_all(), which frees
   the folio.
3. A concurrent task drops the last reference on the folio after
   mf_free_rcu_pages() checked page_count(p), causing __get_hwpoison_page()
   to return 0 and get_any_page() to retry:

mm/memory-failure.c:get_any_page() {
			} else if (!PageHuge(p) && !is_free_buddy_page(p)) {
				/* We raced with put_page, retry. */
				if (pass++ < GET_PAGE_MAX_RETRY_NUM)
					goto try_again;
				ret =3D -EIO;
			}
}

When the folio is freed during any of those paths, __free_pages_prepare()
checks:

mm/page_alloc.c:__free_pages_prepare() {
	if (unlikely(folio_test_rcu_free(folio)) &&
	    !(PageHWPoison(page) && !order)) {
		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
		__folio_clear_rcu_free(folio);
		count_vm_events(PGFREE_RCU, 1 << order);\n		rcu_free_defer(folio);
		return false;
	}
}

Because neither get_any_page() nor shake_page() drains RCU-freed pages on
retry, a large folio in memory_failure() (or any PG_rcu_free folio in
soft_offline_page()) is deferred via rcu_free_defer(), causing all retries
in get_any_page() to see page_count(p) =3D=3D 0 and !is_free_buddy_page(p) =
and
fail with -EIO. In memory_failure(), PG_hwpoison is already set on p, so
when the RCU grace period later expires, the large folio is freed into the
buddy allocator with the poisoned subpage still inside it. And for an
order-0 folio in memory_failure() freed after TestSetPageHWPoison(p),
__free_pages_prepare() skips rcu_free_defer() and drops the page without
putting it in the buddy allocator, so get_any_page() also fails with -EIO
(MF_IGNORED).

>  		res =3D -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
> @@ -2612,6 +2628,13 @@ int memory_failure(unsigned long pfn, int flags)
> =20
>  identify_page_state:
>  	res =3D identify_page_state(pfn, p, page_flags);
> +	/*
> +	 * The caller may unmap the page once this returns 0.  Lockless
> +	 * readers that started before the page got PG_hwpoison, or before a
> +	 * split left it in a folio of its own, may still be copying it.
> +	 */
> +	if (!res && folio_test_rcu_free(folio))
> +		synchronize_rcu();
>  	mutex_unlock(&mf_mutex);
>  	return res;

[Severity: High]
Can memory_failure() return 0 without calling synchronize_rcu() when a
second memory_failure() call hits the TestSetPageHWPoison(p) path?

Consider a lockless RCU reader in filemap_read_rcu_batch() that checks
folio_contain_hwpoisoned_page(folio) before PG_hwpoison is set and begins
copying from the page via the direct map in filemap_read_rcu_copy().

1. A first memory_failure() call (for instance from a background scrubber
   or UCNA) sets PG_hwpoison via TestSetPageHWPoison(p). In
   hwpoison_user_mappings() -> unmap_poisoned_folio(), because the
   page-cache folio is clean, TTU_HWPOISON is cleared and user PTEs are
   unmapped to pte_none without installing hwpoison swap entries. If
   me_pagecache_clean() then returns MF_FAILED (e.g. due to a transient
   extra refcount in has_extra_refcount() or truncate_error_folio()
   failing), identify_page_state() returns -EBUSY, so !res is false and
   memory_failure() unlocks mf_mutex without calling synchronize_rcu().
2. A racing Action Required MCE on the same PFN calls memory_failure(pfn,
   MF_ACTION_REQUIRED). TestSetPageHWPoison(p) returns true and calls:

mm/memory-failure.c:memory_failure() {
	if (TestSetPageHWPoison(p)) {
		res =3D -EHWPOISON;
		if (flags & MF_ACTION_REQUIRED)
			res =3D kill_accessing_process(current, pfn, flags);
		if (flags & MF_COUNT_INCREASED)
			put_page(p);
		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
		goto unlock_mutex;
	}
}

Because the clean user PTEs were already unmapped without hwpoison swap
entries, walk_page_range() in kill_accessing_process() finds no matching
PTE in current->mm and returns 0. memory_failure() then jumps to
unlock_mutex and returns 0 without waiting for an RCU grace period,
allowing the caller (such as kill_me_maybe() -> set_mce_nospec(pfn)) to
unmap the page from the kernel direct map while the lockless RCU reader is
still copying from it.

[ ... ]

>
> --=20
> 2.51.2
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019154913.1765=
974-1-kas@kernel.org?part=3D8

