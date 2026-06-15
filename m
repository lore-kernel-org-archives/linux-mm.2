Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F3BCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99D66B008A; Mon, 15 Jun 2026 06:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C712E6B008C; Mon, 15 Jun 2026 06:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B605E6B0092; Mon, 15 Jun 2026 06:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7DE36B008A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:54:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6493A1C2F70
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:54:54 +0000 (UTC)
X-FDA: 84881839308.04.07A6FB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8C5A8180005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:54:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNRUmekz;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781520892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q6LuyfOsMS4a8EdXR/KT8Uh3LN8s86rxTJxrDIWwxk=;
	b=7XqcOvNPvwfIeEGX8jx5+9fP/7L99rmxdHRZYBP8xB5Odi+Cf9feIfgoZA+QUCzPaZC9Xh
	ELCXc+RQaqZ8BxqAt8QnDjF6daKhQ0RWiAlHqSJq+HIiBlBbXdPwptzjnHT+nlODrPDt4N
	fw72DxJPngDpDP0Thf0u5xail5gYUXw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BNRUmekz;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781520892;
	b=ZG4ArTcIS9YevwaPFVLz6TF4ED8wVC7yc3pMhE70n4oBOtC+Iztnh0MWNsvWgTfIrMiE/c
	JQth4CMIRhDsX1hqMNFddVpJMaLhKz2w6OKKEROB5R9YHYJw86GPB4nMosq7lh2tW+pUuk
	TrOQojiviBTenvfJk0KD9jONFQ+sA58=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3DB340AE4;
	Mon, 15 Jun 2026 10:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930001F000E9;
	Mon, 15 Jun 2026 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781520891;
	bh=0q6LuyfOsMS4a8EdXR/KT8Uh3LN8s86rxTJxrDIWwxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BNRUmekzCtO6iJgCCGcr7et0XnHvffh8tTUcaQ5/xz3kWR8yOejh3+ghoLMtk1jdo
	 W+Wx0ayFfAcqVw+esnhucDIFCC8Y6RY+Q5CeQVAOxygv1cx4256Vu8xLVuB/jMyWwe
	 m/L/wZ9fddxRRe6UYZSd88zAp4BwJpRK+Zu6BWGb02us5eRcHSqMkHLNN9+cL/nN5H
	 pOSPnqe7B8f9zixGq9/t7H0o2Ge31zATPc2yYNLquTg4lz99HS15zGXT1eryOiHLaZ
	 c8Zk/DS9enr4MnC/C7PyXrcnsKv6m+mcIsFWDUdrQN9cLhfz9T9ybpLRVLUyVYjUfI
	 f4RwtTqnsD/KA==
Message-ID: <be1b20ed-5b75-46b8-b7be-3c9b029f016b@kernel.org>
Date: Mon, 15 Jun 2026 12:54:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: Miaohe Lin <linmiaohe@huawei.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
 <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
 <cbffabdc-42bf-4e67-9d2b-ace9a1e09f29@kernel.org>
 <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <984d9775-e17c-0231-b021-126b13a9aa42@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C5A8180005
X-Stat-Signature: r97ychiqhgoqjm9b7kkdpnd9wnqkjqwe
X-Rspam-User: 
X-HE-Tag: 1781520892-700981
X-HE-Meta: U2FsdGVkX19BqPvB7aDWkQNEw48qhQ6/qzsRGFR1Ta09cBMYG2+pYoRUWYNmGN5fxB8eeKY/HqN/4btH/bVC+qMY6HbthR18NQIoFCrMTRJuzLsnQIMyF9d+HFfkvmfJO855ZKTlZRavhCbh1cMxFCBOWdNh6zGXydJuoVQBom7Duv9cRgUAJh6Dk7VcsZGV5A4kbkiD+YMDF3BuslMeDeZ8V0OTBfopI2lyEBPJaKyO+xvS1tOIyQsdWR2GxJERXhkWw8xUi707KF16EOI5+Sgdpa1C8utaDwQwmd3vDwaW024GORMKbTpaPo4+BSEW5HjVRqgN9WK5MhXm+pX+9DIoqXaUb+S39S7hb32GjU4XIWFoG/3cp/dvhAyn6CrsPr3qWdIIht3eIub0dAyAMv20eb8fDakzQ+F0cLG7Rh21nM0P81Iqt9uncTvneSdIh503xjWvLXjlqZhkbChM5tophWE3SBnqBkBt3VHlZPeSyQXn1UPfRFkWlqVOmL9jnhs0i9C15fRSNbtpUWzQG6qMXlndMjB8pcWpOY9jFOLw8jt3qwO78L82iJHa9huRf4s+NjRTq3jMw4SJ19x4H6YtQIEqOxY5csrgDCG1HXkbkRrLE9KzQoalHbDsn29B3cBQkk3OUJvAmEQ7K3xmmMu8gdzeXYrE443WG/DpHPCS1M2cmggBEYeakw7KjB61m9drLpQSBW87OYC0JlF7FNGB7yve4xo63N08vBCuEJNHeUg/C+hqqPqCjeE+xk+106L0bj8EUAwrNe6sb81gNfkyBz7P2876TslPdJTvMFrFKmXjbYKFTESZaBBZHEXRspSAkJ5z54w2hSwc1EPNp0+jPOo0yMPDjCUeKrwBbyznm6LtR/4W0xdWTDnk4aYmO2ZJNFsBzlQc6mcc8DfQ3i01yyQMDQxlJUqNfDgR7n8SnzUiLaNq+jpc4Xu8WqbqxybJmaP1ofMRJ7dQ7M5
 2EvRgUaX
 +tZWSKXTj3VO/3mvHFG9N+NV4ufVh5rzK4LhhGLTTgdn7QYLTEwlLUBk15ZIwE5cHaNpC06GhXTh5RVU1D3VmE7ftqjziG2YZHCbLHjayHfZRZYNDuLSaqvQQPVbuG/NsR90v5TsWhFVskYdGHJVhllMzDxR254RyqDjOXOUDD1Wx2fbRT5ZP0ghctDl9JDqi2EclR5P5OAg9MG9E7AvvrnarTyYmQcEtofvkxdr2fZu0wr+5+58vcG2u+oJLPHQx4FB5i/GId7dvKeYwz9yHtIXvEJ/h8ZE2r0EHwtwq1lUw/YcrxJANk9cwV3ugOC1ogRJB7QG8qKJ8XNNW05Oufct1CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 05:29, Miaohe Lin wrote:
> On 2026/6/11 21:20, David Hildenbrand (Arm) wrote:
>> On 6/11/26 09:36, Miaohe Lin wrote:
>>>
>>> Agree, it's not worth to do so.
>>>
>>>
>>> Since memory_failure might be the only place, this change would be unacceptable.
>>> We should come up with a better solution. Maybe we can try repeating SetPageHWPoison
>>> and ClearPageHWPoison at a first attempt though it looks somewhat weird to me and makes
>>> code more complicated.
>>
>> And I am fairly sure we could still have some remaining races ... it's shaky.
> 
> I have to agree it's shaky.

Right, just let writing task reschedule after reading the flags,
but before writing the flags.

> Any suggestion for next step?

We have various code that assumes that no concurrent writes are
possible, and consequently, we use no atomics.

__free_pages_prepare() is just one user.

Then we have __folio_set_locked(), __folio_clear_active()
and __folio_clear_unevictable().

But also __folio_mark_uptodate(), which is called rather frequently.

page_cpupid_reset_last() is also a thing, but it mostly falls
under __free_pages_prepare() handling.

... and __split_folio_to_order() also messes with flags directly without atomics.


Many of these are only possible for frozen pages (refcount == 0). I think
only  __folio_set_locked() and __folio_mark_uptodate() are called on
non-frozen pages, when there is the expectation that nobody will concurrently
use atomics that would be bad (e.g., don't trylock if not an lru page).


We don't want to use atomics at these places just to please memory failure code.

Would it be sufficient to know in memory-failure code that concurrent
handling succeeded?


Assume that we enlighten all non-atomics to grab the rcu read lock, such as

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..3c3852b60bbd 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -803,10 +803,30 @@ static inline bool PageUptodate(const struct page *page)
        return folio_test_uptodate(page_folio(page));
 }
 
+#ifdef CONFIG_MEMORY_FAILURE
+static inline void page_flags_modify_nonatomic_begin(void)
+{
+       rcu_read_lock();
+}
+static inline void page_flags_modify_nonatomic_end(void)
+{
+       rcu_read_unlock();
+}
+#else
+static inline void page_flags_modify_nonatomic_begin(void)
+{
+}
+static inline void page_flags_modify_nonatomic_end(void)
+{
+}
+#endif
+
 static __always_inline void __folio_mark_uptodate(struct folio *folio)
 {
        smp_wmb();
+       page_flags_modify_nonatomic_begin();
        __set_bit(PG_uptodate, folio_flags(folio, 0));
+       page_flags_modify_nonatomic_end();
 }
 

And then we have some retry logic such as:

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..1123c40aaf43 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -162,6 +162,62 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 
 static DEFINE_MUTEX(pfn_space_lock);
 
+static bool page_test_set_hwpoison(struct page *page)
+{
+	lockdep_assert_held(&mf_mutex);
+
+	while (true) {
+		/* Already set -> not our problem. */
+		if (TestSetPageHWPoison(page))
+			return true;
+		/* Make sure concurrent non-atomic writers completed. */
+		synchronize_rcu();
+		/* Setting the flag was sticky. */
+		if (PageHWPoison(page))
+			return false;
+	}
+}
+
+static bool page_test_clear_hwpoison(struct page *page)
+{
+	lockdep_assert_held(&mf_mutex);
+
+	while (true) {
+		/* Already clear -> not our problem. */
+		if (!TestClearPageHWPoison(page))
+			return false;
+		/* Make sure concurrent non-atomic writers completed. */
+		synchronize_rcu();
+		/* Clearing the flag was sticky. */
+		if (!PageHWPoison(page))
+			return true;
+	}
+}
+
+static void page_set_hwpoison(struct page *page)
+{
+	lockdep_assert_held(&mf_mutex);
+
+	while (!PageHWPoison(page)) {
+		SetPageHWPoison(page);
+
+		/* Make sure concurrent non-atomic writers completed. */
+		synchronize_rcu();
+	}
+}
+
+static void page_clear_hwpoison(struct page *page)
+{
+	lockdep_assert_held(&mf_mutex);
+
+	while (PageHWPoison(page)) {
+		ClearPageHWPoison(page);
+
+		/* Make sure concurrent non-atomic writers completed. */
+		synchronize_rcu();
+	}
+}
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
@@ -199,7 +255,7 @@ static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, boo
 			return false;
 	}
 
-	SetPageHWPoison(page);
+	page_set_hwpoison(page);
 	if (release)
 		put_page(page);
 	page_ref_inc(page);
@@ -1744,7 +1800,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(&folio->page);
+	page_set_hwpoison(&folio->page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1789,7 +1845,7 @@ int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 			goto unlock;
 
 		if (!pre_remove)
-			SetPageHWPoison(page);
+			page_set_hwpoison(page);
 
 		/*
 		 * The pre_remove case is revoking access, the memory is still
@@ -1866,7 +1922,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	head = llist_del_all(raw_hwp_list_head(folio));
 	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
-			SetPageHWPoison(p->page);
+			page_set_hwpoison(p->page);
 		else
 			num_poisoned_pages_sub(page_to_pfn(p->page), 1);
 		kfree(p);
@@ -2380,7 +2436,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (res != -ENOENT)
 		goto unlock_mutex;
 
-	if (TestSetPageHWPoison(p)) {
+	if (page_test_set_hwpoison(p)) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2410,7 +2466,7 @@ int memory_failure(unsigned long pfn, int flags)
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
-					ClearPageHWPoison(p);
+					page_clear_hwpoison(p);
 					retry = false;
 					goto try_again;
 				}
@@ -2431,7 +2487,7 @@ int memory_failure(unsigned long pfn, int flags)
 	/* filter pages that are protected from hwpoison test by users */
 	folio_lock(folio);
 	if (hwpoison_filter(p)) {
-		ClearPageHWPoison(p);
+		page_clear_hwpoison(p);
 		folio_unlock(folio);
 		folio_put(folio);
 		res = -EOPNOTSUPP;
@@ -2751,7 +2807,7 @@ int unpoison_memory(unsigned long pfn)
 		}
 
 		folio_put(folio);
-		if (TestClearPageHWPoison(p)) {
+		if (page_test_clear_hwpoison(p)) {
 			folio_put(folio);
 			ret = 0;
 		}


Maybe that would work. There would still be issues to solve

(a) We don't hold the mf_mutex on all call paths, but we really need it so a
page_test_set_hwpoison() cannot race in weird ways with the other primitives I think.

(b) There are some leftover SetPageHWPoison etc. instances. The ones in
arch/x86/kernel/cpu/mce/core.c likely cannot grab the mutex, but maybe they are
corner cases either way and we can document the situation.


Further, while I assume the synchronize_rcu() on the MCE path should be fine
(who cares about performance there?), I don't know if the added RCU read lock
on some paths could be noticable.

So one idea worth discussing, but I am sure there are more problems.

-- 
Cheers,

David

