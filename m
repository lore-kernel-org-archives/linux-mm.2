Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A26606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijpSbvht
Received: by kanga.kvack.org (Postfix)
	id 99A3A6B05BB; Thu,  5 Nov 2026 08:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972916B05BC; Thu,  5 Nov 2026 08:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839F46B05BD; Thu,  5 Nov 2026 08:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EDFA6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:03:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F01BBA0510
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:46 +0000 (UTC)
X-FDA: 85401082452.26.4BCCFF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D6CC40010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:03:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijpSbvht;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793883825;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9/4G4rHqVIXx3LY1K8j+CTZrQBydD0mJpcfFmB3SXg=;
	b=Ju9KPyqxefh3QPpWWUicncbbFk/46jtsb6AWQ79Q/67QUEz0REvSvjVx1owQV5nc0CcL9m
	/JvF62bwKkhbQB2WhrHA6xCByQFW/0oSmKekifHYyeYw45SEMHRAqaGjkgiJmJSklwA28d
	yVzFznBvPNvjbyzUxz6xR5wwK5cpBrE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ijpSbvht;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793883825;
	b=l40/Qaln977dIE/zr4EohvYtZIiuml7Q0WdpJfX+d8l/TCRPTLqg48U6wLUAapLJjDx5Nk
	pxSvNZTHkthPeAQlm4+999Wa1HqGiqxnquvvcxPGzsgOi53OHq4ADvfFdtWer/Z8o6XSRV
	kumTKHwrIR1pSl67xhIgDDA0+mv4JWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 841EA40442;
	Thu,  5 Nov 2026 13:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529AF1F00A02;
	Thu,  5 Nov 2026 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883824;
	bh=H9/4G4rHqVIXx3LY1K8j+CTZrQBydD0mJpcfFmB3SXg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ijpSbvhtMrTIIAUjSq3N1kmfxVXBMYQfJbo+6ajUrtbkioV/NBbtXNFqnDZeN+1+C
	 lQ0NSF0Vwa6o9SP7rx5Tlub5RVDzTdNNCya6th5+XwIHYI9JkvKj1R+3wdYD9LN8T3
	 XBqUudZq+iorbC+JehpqSZBqD7JAmhWQs6idU3jEMAObgaM+aCGP6B5e5qu34Fa4/R
	 7x/kkCZbiag2pBfGd0kzRd0Ln9dWE8DI7lvvAJYfdsB12t/OJgjNVVHWiq4USCJ3aa
	 Ebz97AcDuys988wJvAUz9S4mRH6mX7s2s1CuXMWfGHTxZ2MGsSASx540RgJjlwQZ1q
	 v5u/C1tb5duhQ==
Message-ID: <sashiko-outbox-199102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 09/18] mm/memory-failure: handle folios with
 PG_rcu_free
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Matthew Wilcox" <willy@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jan Kara" <jack@suse.cz>, "Hugh
 Dickins" <hughd@google.com>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Harry Yoo" <harry@kernel.org>
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kairui Song" <kasong@tencent.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Paul
 E. McKenney" <paulmck@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Ilya Gladyshev" <ilya.gladyshev@linux.dev>, "Jaegeuk
 Kim" <jaegeuk@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261104130118.2507513-10-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
 <20261104130118.2507513-10-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:03:41 +0000
X-Stat-Signature: 5nxnfx8rxdwnnehi987gyxkykqmycgto
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3D6CC40010
X-HE-Tag: 1793883825-13266
X-HE-Meta: U2FsdGVkX19xzOI7/J2wgFY1K7b0BdsseY8r9uRtvrD6gnk+s7erbRWkoJpOfR1+xoYsEF5TrCPB4GhkB39MYK4w1n41uQVQy9jMx8snXTaNfulLMdvUPIuGvsoCpxy1fFnD1EcwK2djXWdlBOCWDvrO41ZdID0yO+ZNxMJYNXzvaOdnwi/vq5BsgBTTqsd0VhZqDitKLHLuiLsre0zCmA30b/hBvLsgCPa9h8m3ZeEktX0dnXbBGk1OQE7UUvoGi5qzg7xpsI70KWw4dZLsnX4lkCQL9PEcdKPjhx8rPYGrzGv/SDb6/EM/Cu+O4QV6Q0E0iCFGLrrpzR+pt1yFVtt0YQQU7tfXQ+LTdDV0b2O8s9D1zXsqHWA4jHCaIs0kceCS0DKxm5eDZIczxtv4blZH59HDPOXAH3cztYMH3ZJ0iKTAvoNEdbxRAQzKF5pQ/Q77El9kz4oMHrLbOW07QxAS71ZGL4xXleDKVXe6wWwCTxXitZSzPk436lozPOIs67FfatxOGD+i3LuHb3NJvxPMx/+ZYIdvbXeVYR3vY0A+uQOTGYZf+a4QhYrkRP80VtNtMFDtNsZ3Lh9UClSfXHDJrVBTBWZ5Jrj/bMJ2BnLu1jhPBx3mceuqmgtjJ+h2sV3j/x2AGAe+meElHW2TnB5+a26RSz/vWcZ2NOBkLbL0aUuO0Ag1KXmH64QvqUjqFnXTeXbPtVlU58dHiQ89X/X3nGGn92FZtSyS6cyUWLRs7rkTkX+VStz1tP0koRGI4g9Jbpj4saJsXFOW0IPd/2X3ppM1wS/xwJyDYR0d2AT+Cie7b94wyiSWNckiHauBX0ku2w9iIlI7AsYo9RprJsax00OqOyNVakFbUh+WZAsdOOwF2PjC9MPFEvVwQB797hKThmPZD6uOGfgjsMuCwuhqW43Om5fKKqFqO3B93fq46/dzzGhgW6ZoUqE1p77E9vWSw0N4ZNXc/uTniIf
 afTc7ZZj
 XA7sY6i/g922wBPhPhNeafHOaiT04xaQ9EgA7YDrdsZ70XmXanoCeaqeT1+MTxcjhNMLR2OdSiChBgom3GNZDhMnpbdMueodh7ThtN8uzZNQ1uQPEuWwskD+vgRMFadIJPAhE2Vxq6aLsiU0v/OdDU0hJKuaCNLpX12Ox2WOvq5WPmewxEQAOnECbqJDjJsUCWDNbOIXViiJhB8cJcZTSOkZuuNy9FNR+sG6njmC6baf1hkUTcTx2F1LFNJv2j3Ib96Gj5n8+Bfjix0JRZE7F1HTZhRurcGE1Vt+qs9LzUirJRnLGyx5NsTjD286NajUcPpt6C+bTwwuZFvxydos+hgC/Ac6VK8OISLXN4cn/aDQomL5yWNI9EgpVX1qV1oeAnThOQ/hr2HiEOmrl/cvD+mqgRhQ6chYS35+wlcSxgxmioLKO+wYX35D96V3TZquUO3/S48e0zujD2cLK3YIDcUAVttTR7ZmiIYbAkGIKLumdE91G4276C3CH8NTKqMldqvLFaKdYpbxqsjbtouijK1/950kwb4AHTNqgrRuQ8QziL3p32d8kVNiWiLfAGBpVPJm7fcxHbGQ0D2IoyWCroODXAmRc2Y693eKNuoyIsZ4TPhFQIe8Jj/xtdnPudbNAPqqh3rKfZT9Yznfp4KecjMUdlgol/sYvE+BOK2P8MdoHzjATOBEh+DaIbsmDGPe8skU83Q+Y9f8TXcnuHwupFLuc7Ankzwxb2Q/GvDJywGzsi9sYADx02leUqA==
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
- [High] mm/memory-failure: unsafe RCU wait in memory_failure() already-poi=
soned path
- [High] mm/memory-failure: mf_free_rcu_pages() skips sync while rcu_free_p=
ages() runs
- [Medium] mm/memory-failure: order-0 PG_rcu_free page dropped after settin=
g PG_hwpoison
--

commit 3d8069abfad786882a48d6ce85e757674239a9ca
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/memory-failure: handle folios with PG_rcu_free

This commit updates memory_failure() and get_any_page() to drain pages
waiting for an RCU grace period via rcu_free_sync() and waits for a
grace period via synchronize_rcu() before returning success on a
PG_rcu_free folio.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 7dde7c3c9a0c5..398463b2e82d5 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1419,6 +1419,19 @@ static int __get_hwpoison_page(struct page *page, =
unsigned long flags)
>  	return 0;
>  }
> =20
> +/* A page waiting for a grace period is not in the buddy yet: free it */
> +static void mf_free_rcu_pages(struct page *p)
> +{
> +	if (!zone_rcu_free_waiting(page_zone(p)))
> +		return;
> +	if (page_count(p))
> +		return;
> +	if (is_free_buddy_page(p))
> +		return;
> +
> +	rcu_free_sync();
> +}

[Severity: High]
As reported by Sashiko on RFC [1], can mf_free_rcu_pages() return early
without calling rcu_free_sync() while rcu_free_pages() is still freeing
the target folio?

In mm/page_alloc.c:rcu_free_pages(), NR_FREE_RCU_PAGES is decremented
before the folios are actually freed to the buddy allocator:

mm/page_alloc.c:rcu_free_pages() {
	list_for_each_entry_safe(folio, next, list, lru) {
		nr +=3D folio_nr_pages(folio);
		mod_zone_page_state(folio_zone(folio), NR_FREE_RCU_PAGES,
				    -folio_nr_pages(folio));
		if (direct) {
			__free_pages_ok(&folio->page, folio_order(folio),
					FPI_NONE);
			cond_resched();
		} else if (!folio_batch_add(&fbatch, folio)) {
			free_unref_folios(&fbatch);
			cond_resched_tasks_rcu_qs();
		}
	}
	if (folio_batch_count(&fbatch))
		free_unref_folios(&fbatch);
}

Similarly, during folio release, folio_put_testzero() drops _refcount to
0 before __free_pages_prepare() -> rcu_free_defer() increments
NR_FREE_RCU_PAGES.

When the last waiting folios in a zone are in either window,
page_count(p) is 0, is_free_buddy_page(p) is false, and
zone_rcu_free_waiting(page_zone(p)) evaluates to false.

If memory_failure() calls mf_free_rcu_pages(p) during this window, it
skips rcu_free_sync() and proceeds to TestSetPageHWPoison(p) before
__free_pages_prepare() runs. For an order-0 page, __free_pages_prepare()
then sees PageHWPoison(page) && !order and drops the page instead of
placing it in the buddy allocator, causing get_hwpoison_page() to fail
with -EIO and leaving the hardware error ignored as MF_IGNORED.

In addition, because memory_failure() calls mf_free_rcu_pages(p) before
get_hwpoison_page() calls zone_pcp_disable(), if rcu_free_workfn() or
rcu_free_expedite_workfn() already spliced p off the per-CPU list,
rcu_free_pages(..., false) -> free_unref_folios() will free p onto a
per-CPU pageset (PCP) list rather than the buddy allocator before
TestSetPageHWPoison(p) runs.

> +
>  #define GET_PAGE_MAX_RETRY_NUM 3
> =20
>  static int get_any_page(struct page *p, unsigned long flags)
> @@ -1443,6 +1456,7 @@ static int get_any_page(struct page *p, unsigned lo=
ng flags)
>  	}
> =20
>  try_again:
> +	mf_free_rcu_pages(p);
>  	if (!count_increased) {

[Severity: Medium]
As reported by Sashiko on RFC [2], what happens in memory_failure() if an
in-use order-0 folio with PG_rcu_free is freed on another CPU after the
initial mf_free_rcu_pages(p) call?

In memory_failure(), the initial mf_free_rcu_pages(p) call returns
immediately when page_count(p) > 0:

mm/memory-failure.c:memory_failure() {
	mf_free_rcu_pages(p);
	if (TestSetPageHWPoison(p)) {
		...
	}
	res =3D get_hwpoison_page(p, flags);
}

If another CPU drops the last reference on that order-0 folio just before
TestSetPageHWPoison(p), __free_pages_prepare() queues the folio via
rcu_free_defer(folio), and TestSetPageHWPoison(p) then sets PG_hwpoison on
p while it is on the RCU free list. When get_hwpoison_page() ->
get_any_page() then calls mf_free_rcu_pages(p) at try_again,
rcu_free_sync() drains p through __free_pages_ok() ->
__free_pages_prepare():

mm/page_alloc.c:__free_pages_prepare() {
	if (unlikely(folio_test_rcu_free(folio)) &&
	    !(PageHWPoison(page) && !order)) {
		...
		rcu_free_defer(folio);
		return false;
	}
	...
	if (unlikely(PageHWPoison(page)) && !order) {
		/* Do not let hwpoison pages hit pcplists/buddy */
		...
		return false;
	}
}

Because PageHWPoison(p) is already set and order is 0,
__free_pages_prepare() drops the page instead of placing it in the buddy
allocator. And if the last reference is dropped after
TestSetPageHWPoison(p) while get_any_page() is retrying,
__free_pages_prepare() sees PageHWPoison(page) && !order, skips
rcu_free_defer(folio) without waiting for an RCU grace period, and also
drops the page.

In both cases, is_free_buddy_page(p) remains false, get_any_page() fails
with -EIO after retrying, and memory_failure() reports MF_IGNORED without
waiting for lockless RCU readers or accounting the page as recovered.

[ ... ]

> @@ -2440,6 +2454,7 @@ int memory_failure(unsigned long pfn, int flags)
>  	if (res !=3D -ENOENT)
>  		goto unlock_mutex;
> =20
> +	mf_free_rcu_pages(p);
>  	if (TestSetPageHWPoison(p)) {
>  		res =3D -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
> @@ -2447,6 +2462,13 @@ int memory_failure(unsigned long pfn, int flags)
>  		if (flags & MF_COUNT_INCREASED)
>  			put_page(p);
>  		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> +		/*
> +		 * The memory_failure() that set PG_hwpoison may have failed
> +		 * without waiting for lockless readers, and the caller may
> +		 * unmap the page once this returns 0.
> +		 */
> +		if (!res && folio_test_rcu_free(page_folio(p)))
> +			synchronize_rcu();
>  		goto unlock_mutex;
>  	}

[Severity: High]
As reported by Sashiko on RFC [3], can this already-poisoned path in
memory_failure() return 0 and allow the caller (such as kill_me_maybe() ->
set_mce_nospec()) to unmap pfn from the kernel direct map while lockless
RCU page-cache readers can still access p?

There appear to be two issues when a previous memory_failure() call set
PG_hwpoison on p and then failed before isolating the page (for example,
in get_hwpoison_page() or try_to_split_thp_page()), and a second
memory_failure(pfn, MF_ACTION_REQUIRED) call enters the
TestSetPageHWPoison(p) branch with kill_accessing_process() returning 0:

1. In the TestSetPageHWPoison(p) branch, put_page(p) drops the
MF_COUNT_INCREASED reference before folio_test_rcu_free(page_folio(p)) is
checked, and no reference is held on p during kill_accessing_process() if
MF_COUNT_INCREASED was not set. If the folio's last reference is dropped
after mf_free_rcu_pages(p) (either by put_page(p) or concurrently on
another CPU), __free_pages_prepare() immediately clears PG_rcu_free before
deferring the free:

mm/page_alloc.c:__free_pages_prepare() {
	if (unlikely(folio_test_rcu_free(folio)) &&
	    !(PageHWPoison(page) && !order)) {
		VM_WARN_ON_ONCE(fpi_flags & FPI_NOLOCK);
		__folio_clear_rcu_free(folio);
		count_vm_events(PGFREE_RCU, 1 << order);
		rcu_free_defer(folio);
		return false;
	}
}

When that happens, folio_test_rcu_free(page_folio(p)) evaluates to false
and skips synchronize_rcu() while the folio is still waiting for its RCU
grace period and lockless readers that looked up the folio before it was
freed are still copying from p.

2. If p is part of a large folio and the first memory_failure() failed in
get_hwpoison_page() (before folio_set_has_hwpoisoned(folio)) or in
try_to_split_thp_page():

mm/memory-failure.c:memory_failure() {
		if (err || new_order) {
			/* get folio again in case the original one is split */
			folio =3D page_folio(p);
			res =3D -EHWPOISON;
			kill_procs_now(p, pfn, flags, folio);
			put_page(p);
			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
			goto unlock_mutex;
		}
}

the unsplit large folio remains in the page cache with PG_hwpoison only
set on subpage p. Even after synchronize_rcu() completes, new lockless
page-cache readers can still copy the poisoned subpage as part of the
large folio while the caller unmaps p from the direct map.

[1] https://lore.kernel.org/r/20261019154913.1765974-9-kas@kernel.org
[2] https://lore.kernel.org/r/20261019154913.1765974-9-kas@kernel.org
[3] https://lore.kernel.org/r/20261019154913.1765974-9-kas@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104130118.2507=
513-1-kas@kernel.org?part=3D9

