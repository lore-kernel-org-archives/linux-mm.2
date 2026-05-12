Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2501CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116ED6B0088; Tue, 12 May 2026 07:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8C76B0096; Tue, 12 May 2026 07:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF88A6B0098; Tue, 12 May 2026 07:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC13D6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:07:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75F9B140485
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:07:25 +0000 (UTC)
X-FDA: 84758491650.05.DCF95C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6787180011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:07:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pErSm8eU;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778584043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooQS+ZDu3wuKZihkijOFtaMI34Mu10F93W7eAqsEcPk=;
	b=LKhUvTsrtkYqZFb8djrRUnOtu+pQ9xffcDuYI4+aG8X/RvZJ5/VKlnCVz3VUNLeyPua7/p
	wVgqUt1GQOqiad7TbtQhB3G3XUqaNmg+7gJKZES8u4lkNyOBwBtFkhdIL+/VJ6vcpeo72N
	YYtJzrif84hsflHFAu9es1EGjwTUV5A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pErSm8eU;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778584043; a=rsa-sha256;
	cv=none;
	b=i6u/p97hW4/F5cLnqBymJpMUdM3THLmX6iQrCcXWoF+u8vk+Mm5Y1FNcPNqUVk5I5VmVgl
	li6EdxlwXEnBwk0xKG3gb8PKenUjjRWp8CdOBF19EtmwtCYLHcTJLJBX4EXT+yqC9Hr1Zf
	HX/SA0BZocMiob8/5Jlu+7DCv/kkFtU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F78C6001A;
	Tue, 12 May 2026 11:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33080C2BCF5;
	Tue, 12 May 2026 11:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778584042;
	bh=57ogFlXCXaF1a1TezDYO8b80gCjSnt1NZ3GTKLJt/JE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pErSm8eUzMBKLoiqQ3o+ZC2Y1VLqi3F3ko7yg46V+XNADbrN3N1rBhGHzpOVxdbLu
	 g2ivbpVppCIXQrje70P/jD5NlL978DxORCWNzYJBTW5v1fY2XACE1c2DdS1w7vWuCN
	 yxP/YrCIC302cn1uccn/GnFQUs8DdLnpZUcprBFRyUJt+ikOHSwQqyemjFgmFYZJXz
	 oDoNl6rRLJvwwnYO0oAQFvoHtSp95vQPaM3UlhtrM3oSTWFcH8XRMufPuCC4NiWXZW
	 O0n0LyS4Ok8iTJcJ83nj+91ZmF5qQBmgC7npf9Xh1zBhhG6MBLX5wlrM5zteLuMySS
	 oYo3Ojon4WUmA==
Message-ID: <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
Date: Tue, 12 May 2026 13:07:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6787180011
X-Stat-Signature: iqrtd4pd4ykty19o8i3ypjbcsybhrr69
X-HE-Tag: 1778584043-86665
X-HE-Meta: U2FsdGVkX1/7MKQfSSfKuYTWHfkThKIu+REQK7keDHQWdSQQrN3qjpjxPpgrbNKw7kdu7r/xS2GwKxqTK4RV4ANrK4OXodPJ8e3cd4HRfPzwLlfZuiCM6X+AfwZ1x1lt36S3b12mvNcX5VkMNsgnukjRFLGzh5HoE5per8d7fUuS3l/9Nc83SMJMAI3W0j6T9RRZrGk6H9USTGk9gVPuoC8aQTC+A0MxG37bsgNHGfCc64HiyXQzHqMQiqg+O+PIVberaiaVrlgcsWase5lL4qJ+QYlnddHN49KmmvSrzYizJ9qoExwygwjHzgTyRE8tkcZ7nLFtB/7esv95GvxfGnggsdA4R1kiv0Oo+r+FWcDBvrjK74gSBNKVxLZ+P8lb+baimJE714lKxSJb1Er76bl/sKYfbHId+RyXIvifjqvb0TF0eUYWOljKOmCiJCOjbg4SKglo4BpOfHDDoCKRTM3RmPTsgoZD7d+O5DUvVAuh9ex7FJNW+wTw5Jgy5tVIUTl6MSBB4P44iWBKMitj0mCqeNHGzopC8LlDiXa3z+Tdgao+3DgoFjyWEpm+hkze1YoyBGgRxFF5nNOZmPmKxzNrpFrvmDxCWj5el9g/84me9N1ECXQ2uLzEW+Zbw1DlJKKrhoMzzO06ddI6KpWviTR0tlKMUC/59/Gf5wQp4YCqoj8awLoyaTUAdRsydnYZFYUKx7lfjuCybSmPaorSfb92CRanKfairpNacuTDbnJIok+rXnH/I+gOx2h3prLrErfLEfB33rLOO7PgF1UWDEs++JA/Qt5QvJd/6C2I/XK4iUVCN+xcO6/5SW/z3kg1QAS8BHQ6x2eP3LTmoFzDx45dP0KImPWphImgLuNVGQs4guvYmv8PqdJ3tUTo5lKggC4Jn1kj5sras5rpZSlLyKnB2l3tz8zod0VDbAFYprE4EXlLNfKpDk42pDHbaO+j4lTF2WTtaw0zTCycsMY
 +nJiFP3I
 ty+cgF5ecSO1YXKlKxLL88AbvTUle4HEOBgk/GvPD2IDWVkpISokUqF9rMi4UnfQHoIoB+jLjI/Dv6lwuP3bzOnu3ORerBiXLDj0EmL8PWXpUZu/TNPPUc4vgT/DPWW742HcNK1Nkka0wrIkYe1cBxfLhhCg9dVNDy0t7XyUnvGBvTM9ae48TRi8XxOXQzAI5lYsy4uU/JlGa1t1peOYDELPDSRi+2u+f229R6gxbC+yJzZ/xQU0DUtNI5P/ZESwFtD8PpZA2VcVL/86BRQaf7b1pBuubl8ZCwSyGQE7w996JVeBOTDB5z350SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> +/**
> + * undo_compound_page() - Reverse the effect of prep_compound_page().
> + * @page: The head page of a compound page to demote.
> + *
> + * Returns the pages to non-compound state as if prep_compound_page()
> + * had never been called.  split_page() must NOT have been called on
> + * the compound page; tail refcounts must be 0.  The caller must ensure
> + * no other users hold references to the compound page.
> + */
> +void undo_compound_page(struct page *page)
> +{
> +	unsigned int i, nr = 1U << compound_order(page);
> +
> +	page[1].flags.f &= ~PAGE_FLAGS_SECOND;
> +	for (i = 1; i < nr; i++) {
> +		page[i].mapping = NULL;
> +		clear_compound_head(&page[i]);
> +	}
> +	ClearPageHead(page);
> +}
> +
>  static inline void set_buddy_order(struct page *page, unsigned int order)
>  {
>  	set_page_private(page, order);
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..45e80a74f77c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -937,6 +937,111 @@ int shmem_add_to_page_cache(struct folio *folio,
>  	return 0;
>  }
>  
> +/**
> + * shmem_insert_folio() - Insert an isolated folio into a shmem file.
> + * @file: The shmem file created with shmem_file_setup().
> + * @folio: The folio to insert. Must be isolated (not on LRU), unlocked,
> + *         have exactly one reference (the caller's), have no page-table
> + *         mappings, and have folio->mapping == NULL.
> + * @order: The allocation order of @folio.  If @order > 0 and @folio is
> + *         not already a large (compound) folio, it will be promoted to a
> + *         compound folio of this order inside this function.  This requires
> + *         the standard post-alloc state: head refcount == 1, tail
> + *         refcounts == 0 (i.e. split_page() must NOT have been called).
> + *         On failure the promotion is reversed and the folio is returned
> + *         to its original non-compound state.
> + * @index: Page-cache index at which to insert. Must be aligned to
> + *         (1 << @order) and within the file's size.
> + * @writeback: If true, attempt immediate writeback to swap after insertion.
> + *             Best-effort; failure is silently ignored.
> + * @folio_gfp: The GFP flags to use for memory-cgroup charging.
> + *
> + * The folio is inserted zero-copy into the shmem page cache and placed on
> + * the anon LRU, where it participates in normal kernel reclaim (written to
> + * swap under memory pressure).  Any previous content at @index is discarded.
> + * On success the caller should release their reference with folio_put() and
> + * track the (@file, @index) pair for later recovery via shmem_read_folio()
> + * and release via shmem_truncate_range().
> + *
> + * Return: 0 on success.  On failure the folio is returned to its original
> + * state and the caller retains ownership.
> + */
> +int shmem_insert_folio(struct file *file, struct folio *folio, unsigned int order,
> +		       pgoff_t index, bool writeback, gfp_t folio_gfp)
> +{
> +	struct address_space *mapping = file->f_mapping;
> +	struct inode *inode = mapping->host;
> +	bool promoted;
> +	long nr_pages;
> +	int ret;
> +
> +	promoted = order > 0 && !folio_test_large(folio);
> +	if (promoted)
> +		prep_compound_page(&folio->page, order);
> +	nr_pages = folio_nr_pages(folio);
> +
> +	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
> +	VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
> +	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
> +	VM_BUG_ON_FOLIO(folio->mapping, folio);
> +	VM_BUG_ON(index != round_down(index, nr_pages));

No new VM_BUG_ON_FOLIO etc.

But in general, pushing in random allocated pages into shmem, converting them to
folios is not something I particularly enjoy seeing.

-- 
Cheers,

David

