Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AD6606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c5uSrUhY
Received: by kanga.kvack.org (Postfix)
	id 8B8516B069F; Tue, 27 Oct 2026 06:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868236B06A1; Tue, 27 Oct 2026 06:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E806B06A2; Tue, 27 Oct 2026 06:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABEA6B069F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:44:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D35BD409BF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:59 +0000 (UTC)
X-FDA: 85368070998.02.A51FBE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3070B100008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:43:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5uSrUhY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUGcoGJ3mRnt/Z7GBxa2RJO4TTMxywHgVzZ1aSTOpqE=;
	b=ju7uVmrQSUb+DvVLGyXXj6CRwmH17S/snt6HjSIlb4B18lkEP09nYJAI1ME6PHDkAaTMRl
	E+YOYcfd6vUjpkJhwFgixNvakj+3o5u3b/5qAHmGHi8WzGhJhe2DaKZktf5F3w9gUN02c3
	pbYiq2ejduUXK05OTmGhKrKnI7rSg9o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c5uSrUhY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097838;
	b=nYKqUGZwOgHFB9ed8kgubodHIQIge0hIkDJphNOjnjulxvxWS8kowkY/Mi5rRLjIvdQPsG
	BnzbVKfF0g4YaQcaMzp2jEPXOfCLAJLY03hH10FaMotK46JQFK8eXpRiw+ZehT6UImfgfr
	IJqRnLAvDVY0+tdb7rNbzHacqwPHsAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C83B3602BE;
	Tue, 27 Oct 2026 10:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1C11F031E0;
	Tue, 27 Oct 2026 10:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097837;
	bh=RUGcoGJ3mRnt/Z7GBxa2RJO4TTMxywHgVzZ1aSTOpqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c5uSrUhYlCsGKMO8Vp8lcJXtrvW1Yd9wQv6SBFXz1V0+3wtAnO8fPiQP0N44b5Caw
	 JEfPDn2OgjccvQPVnX9M/V4VDQdTor9tUu92/PRDa9si9aYVzDcMuUTkZ63f/xl+MY
	 wZIC3SiiuburrWWPpelVf2/XqjSKfYfDyW5QyoJ6TzsM0fdTaa/1gMoPCO+kaODY6M
	 gteuPkd5rNdSnaN5sCYooq12TpUeft37PUUaXuIyhur4BrRBlfcjiRhAucIDo0OU2g
	 F4JJK0ITfJexW69BQBa2a8huNvhSK4zOzUugogaUwEtLU2KWCRkeE52k0Z4b/7BDQX
	 yLto4UgWV6vUQ==
Message-ID: <1748ab4b-c219-4eb2-9f0b-cc540c7986f4@kernel.org>
Date: Tue, 27 Oct 2026 11:14:09 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] mm/shmem: fix truncate hang in large swap entry
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
 <152d698f-d7bd-4e1a-9736-412d52e2370c@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <152d698f-d7bd-4e1a-9736-412d52e2370c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3070B100008
X-Rspam-User: 
X-Stat-Signature: mhjww4fg3h98f6kaahcizoya63hy5fjk
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793097838-709283
X-HE-Meta: U2FsdGVkX18Olrnau8sC9Tq9tqk4TwEAxrBk32zOLx3MxTju/he++ZevOxS0kaYwmnLPTKS4BrDopNhT0J++Qa9yQNFooz8p1RqWeq9Oo2ZCLCriHJXRbqoieCVqKdNKosCpSXXdZPxCueKKjH3EcomT15uek+ZBC3AxwDl95lqRVClQJ2m4JQsggbG2/D9StGpSYTIiFvjeXUQCs49LWSFvfLvujyczNpA7H1Hn6/kOMGBNsRlVxsTNprIxPueZeQRsgQLJa3wDUbqLTQN5B8QEnHKlk/8Dm8rKfCPgQsC+Po1XYF7F8qTkRBS4sZKyky9Shhq0NhlmQKzLcScqPOo3UmQJjWp6DY5aq2nYMS0+r9RtDc2dCI/ra3XCxK+GYNcl4h4MAB3w9TG8uTdKBTdENS/QAPQcrUrd0+c7Vb/psxcUKEzJfMHIG46ezUrY1HhKo85msMe5+5X3czq9RYUYJ5Z+HYRz2TGEWEiEACGgUUyIAuls0YNnIlnvwTaGSEpHWpHJp8MGvNISKjKjVujbM3XZHssFzKkrEHUUVObazwbKWH/fNtWFtY6wZNdDJ/PIX0hKpZPMD7m90ZO/5KYiKeCnkoCEWyuu0fU2402/Hqxe3+mTXlPZzrUQV4EmUrfMVDc5jmTLe3lrG9a8jTVCnKCgKFS1BJ6x+GiW9JiC4jenZC/YMsu9nuqhCn1KTliewN4gQNAvg2/gvBq4EbDM22qQ8HoJOdNB6lhjikgXTMjhVnS6/6q7J1nHuh+JqFaJJRPsOIk1Dgjr3y0UdWhPN12xJ8uaiYtM4rVb/lpzktzNQ4O60ShpsbrQosV/BXxZKhbeTQn4wGzVhuJ9pG+xnbc7gXbOMwl1XuU0STnTtAACQniemW8WqEaJhwXNKZL2bDkSV96TbJxJj2URJTHun2KoAB6Yf3z6ZM4+Rw3YS66/fjT9z9ZZYa84elenqbMrgUUyXl7xD3k3j+x
 KNe6ZiCH
 fr1IOxt98xfjJdeY9lX/5uzwRaZgBxYX2Q2W2g0NlwoG0e/njDzdTuTNCacNBWWi15jkJHQY+xzWTPmreWIi8HRyI+GiUIO73MtCYJ/E3JsSrNU6vugYtI6ctiKpOKWUew16/l4HZpPnoC5+hW7CRXBu2X+QSjapxUbungN1VjE/nF4U4b1N9whqEB9JVFK9Y23cHZjexwd1PSGa2MvOnhrG+0LBooCL6rPfNZGgADRg3S3Iv/MAFgFo+z/X5/ssz9/Nxd6mb+cNJpmaTABcp9TBJjrAUKObDj3cG9ioMJujOGfW3QLxioGQnaZuvDlL8BxaRDTVffTmYAWMsrpGQYVUDATqKtYRoxDpSeqpdcEQj3QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 09:59, Baolin Wang wrote:
> 
> 
> On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
>> Truncating a tmpfs file or memfd to a page-aligned size inside a large
>> swap entry can loop indefinitely in shmem_undo_range(). The task holds
>> the inode lock and cannot be killed.
>>
>> A large swap entry represents a whole swapped-out folio. For example,
>> truncate a file whose pages 0-7 share one swap entry to four pages:
>>
>>      [ 0  1  2  3 | 4  5  6  7 ]
>>           keep    |   discard
>>                   ^
>>              new EOF, start = 4
>>
>> i_size has already been updated when boundary handling asks
>> shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
>> calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
>> because its starting offset equals i_size. Nothing is read back.
>>
>> The final scan cannot free the entry without losing pages 0-3. It skips
>> it, restarts from start = 4, and finds it again indefinitely. An unaligned
>> truncate avoids this particular failure because the requested page starts
>> below i_size. Folios already in the page-cache cannot trigger it as the
>> direct lookup will return them beyond EOF.
>>
>> Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
>> directly for swap entries. This bypasses the read path's i_size check,
>> allowing the existing boundary handling to zero and split the folio. If
>> swap-in returns a smaller folio, it also splits the swap entry so the final
>> scan can free the entries beyond EOF. Retry the lookup if the entry
>> changes during swap-in.
> 
> Make sense to me.
> 
>> Handling swap-in allocation failures remains broken and is unchanged by
>> this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
>> instead of -EEXIST, shmem_get_partial_folio() returns NULL and
>> shmem_undo_range() skips boundary handling. If the large swap entry
>> remains intact, truncation can still loop in the final scan, while hole
>> punching can return without zeroing the boundary.
>>
>> This may read an entire large folio back from swap while holding
>> i_rwsem, only to discard part of it. Avoiding that I/O would require
>> splitting both the swap entry and any large folio still in the swap
>> cache. That, however, is much bigger work.
> 
> But I think this case is extremely rare, where every attempt to call
> shmem_split_large_entry() to split the large swap entry in the loop fails. At
> that point, the system is already in serious trouble, where even OOM kill cannot
> free up memory for the xarray allocation. Hard to believe this can actually
> happen in practice:).

So, it's fairly easy to reproduce with memcgs. But yeah, I assume this is a
corner case. (hopefully :D )

-- 
Cheers,

David

