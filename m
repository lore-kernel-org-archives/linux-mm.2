Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72136606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Vwskwkuf
Received: by kanga.kvack.org (Postfix)
	id 6A1186B05B0; Mon, 26 Oct 2026 07:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6522D6B05B1; Mon, 26 Oct 2026 07:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568EC6B05B2; Mon, 26 Oct 2026 07:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 327A16B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:11:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2D3C1406D9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:11:13 +0000 (UTC)
X-FDA: 85364510826.28.C4C2811
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf06.hostedemail.com (Postfix) with ESMTP id C78AC180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:11:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vwskwkuf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kv79Ibi9i0yW18VfNZUR7O/kIwfQnu5qszXLeT8x3ok=;
	b=rjm2pRvtfRvvZg8MH3NRKEJ3dRA3EnnSOEMUTfPKUqC+UGUlFHgRddtiPG4BHHczzmDPcN
	lXYOi1NalsRTIIaNl2T4q1f2DzcypX5RrlLQAnEFLHOF9MLe+Fticr9cs0Bp7zBxn/oqLo
	FWI2hh6LpgnqO73/qtIxyFVJ/mqQVpQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vwskwkuf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013072;
	b=0rzBAM/rAVE38iSKOQu5vpqa61zEWBV8Ko8K+f6REkBbpJCpzzliDnKs94CIcxlh5XRuMW
	rmbW+yQTx8Wcnd6N1Isu/F7FpK4cTEpeGFM+VyBlERbQDYswY9ksB4JQxc9G09x5Tb4DZ8
	FPjnh0ByqywyUeAjXl9nCCXTgxaj/pc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793013064; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kv79Ibi9i0yW18VfNZUR7O/kIwfQnu5qszXLeT8x3ok=;
	b=Vwskwkuf757K7C7dbw5Ya5E9Qri68tN6vf5veWv8rXUAenOx2pAmqRAGdNq51vFGOUTOTRiWjCxywqeiKd9y8NG9767fRVIATAxKH/P7IpU4XC6lGTvAirtDvC51I/nLmXPyvEpW3pL7nQdbN3ORDe6mVoBtvzfxo0ka73mzVEA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=33;SR=0;TI=SMTPD_---0XDWn7u2_1793013062;
Received: from 30.74.144.181(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDWn7u2_1793013062 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 19:11:03 +0800
Message-ID: <a8f01101-7d7d-4982-9cf8-04b754ba132a@linux.alibaba.com>
Date: Mon, 26 Oct 2026 19:11:02 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C78AC180003
X-Stat-Signature: 9ancpfgy1zannryqca6ayajomofiqx1r
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793013069-469780
X-HE-Meta: U2FsdGVkX1/TE1O9uZ7tcoPRgVJdzWz4EI4evs5s/q9p/PM+KJe2HayST147SAlb+w2d7HYNFrgUwj3AutJDjKAUqiDH+uNp6m/O4mublWjDobTCKKaf4e9u6Y9Qi/4xRw1BcHkz7MSMZL335zlxM0auxVIUKGUM0tZ1TVzvnZMEgBNMrMolBlrNiJQIRUdZmDWWzKxL9lMmMDxlKVNkpukYN5lSpvvbjAhnE1nyD0tV63y9UQsr9mHJ0Dts8KFMETWQZMy8RbJmFZM+xj0Qx4czUzHM3mAo81WY9qsWfUkse2y0MjDkvMcjanLPp3wW83+hkak2Kxe8os6UIj2daBkjQtWxNq0VQjUvYHEHZeMZvZZ3ABKNGLwMu/uVeTjePLqMnUcqL5jdCac0ABXR9Vl9y8pJALRXUmi0I+SuBPnKJFMUsgA6rHptHVQQqaxFRy3mUB0AKcok22Im+3CSt7CNL0R4yrD5M8kdPY8WYQt11cINBaBpUYCHaKvK56EKD1KwRVIrKYnJNEouOIcoVzNoWT2XzhLB5DY13LoFqxTeSV/IOpI1GePtejR9PtVF1GqcUuK70/75BOQJteFzuiCha5P1XKf6JZLtKv30C3S0qm/dJBQKHWPkaiwQY3gfSXYdRvaJ4vHtlwigKpn7A59lKH0LM/9ZEJMzYgyUlGMs4fmxYfv/eRVyPZhC3zJGyXdipZqi9L0z0TtTVQYYSH5ePWsJSr8Jf/ZWQ2gf2REhYZhnS+rGMC7bhGZUBZo1ygMSD7M1UgWaDSH6e3a5V1ZJ39OwFVcEyinP2StEGUA7apK39KULBbAl99WWBk3ohIYbrRzGAZYLvaBjXHAMCI7j+bQ7Cf6Ld4S5Sv6h75LGxVSTQxgeYCYkfT89THruePxELMoacFs2PjOcQCrHhygBYrIlDZqLoSomsVC1PPVmBDkIK13Rcd59zyr6e09vQno9YR4zl9aX9YK0Hka
 1frE8tVx
 6zQ75ez7EQdMsk3YroDxI+Qml8nclYAKA9Z9IOUIlTczT0/+OBj+jYQN3RKRccpzuzZPh8inEblvZseCrRvKd63A/WU3LJluTt5cAvSwf43/GP6RpBk1jvTActrdNwxxnrEzSdIv9jH7nAFwT+++EnGlUMWmdNsb6tvKUJWnxM1j11evBBkLRROo3WNdWhCpsotYmEKx9bFwAo08T6YpmqSiJgIL4UltXkWKb6XW6AoIx2O+UOPPgsWGBotMZYC7AMlmO+EgfZmvViwvZRoxQzdmPh8GBMIvAqgtrgF6cAIvQNisoIbW+xCShiN+1+pvFjZVer/q9WgG871C+zPX2v1Iaf2OeerP88N+87/uqZtpk+28qXiCy0uyUzfMrggQ7UOCplUV6tUvR/+FN45ESB7yKQup31sJ4z3Dl+TjbPsAfCEunxRt9Ka+Yd6dtban7Ws9qi8/HQEEnpW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> Hi,
> 
> the fixing fun continues.
> 
> This is a handful of fixes for shmem/tmpfs. I sneaked in a related
> hugetlb fix that stalled upstream.

Wow, thanks David!

> Some of the stuff is more urgent (patch #1, F_SEAL_EXEC, truncation
> hangs), others are less urgent but still rather unpleasant.
> 
> The majority are fixes from Anthropic that I cleaned up or reworked.
> While doing that, I found a bunch of other issues and tried to fix them
> somewhat cleanly.
> 
> In general, shmem + swap handling is a nightmare. shmem_undo_range() is
> such utter garbage it makes me want to cry. I mean, really, WTF did we
> end up creating there. Does any expert here have time to clean that up and
> make it *actually* maintainable.

Agree. :) I'll re-read shmem_undo_range() and take a close look at the 
issues you raised, and see if I can make shmem_undo_range() more readable.

> The following things are still broken in shmem_undo_range():
> 
> (1) Truncate/punch of a single page of a large swap-error marker
> 
> We don't split. Consequently, read access afterwards will still fail
> instead of returning 0s.
> 
> I have a fix to try to split (which can fail), but I don't consider it
> that urgent, really. So I'm not including it. Might send it later
> separately.
> 
> Truncate/punch of a partial page can obviously never do the right thing,
> as we cannot poison parts of pages ...
> 
> (2) Truncate/punch whole pages within part of a large swap entry
> 
> We try to read the entry, but if we are out of memory that might fail.
> Consequently, we will not free up swap space and a re-read will not give
> us 0s but the previous content.
> 
> AI proposed a nasty NOFAIL patch which has too many nasty side effects
> IMHO (allowing users to force-read pages and retain them afterwards even
> though memory.max would disallow it). This needs a proper thought. Likely,
> support for splitting large swap entries (and large folios in the
> swapcache, which I recall is under development  by Kairui). But splitting
> can fail ...
> 
> (3) Truncate/punch of a part of a base-page swap entry
> 
> We obviously have to read the page in, in order to 0-out the parts to
> discard. That might obviously fail.
> 
> Maybe we should install swapin-error markers if swapping during
> truncate/punchhole fails, to at least tell user space on later access
> that something went wrong? We might affect unrelated data, outside the
> requested range, though. Anyhow, these are long standing issues and
> I don't consider them urgent.
> 
> They need a proper solution.
> 
> I did my best trying to test these fixes. I was able to reproduce some
> of the things (including unkillable truncation hangs), and the fixes seemed
> to help.
> 
> But again, shmem_undo_range() is just an absolute mess.
> 
> Please prioritize review of these fixes, I want to get fixes for the
> issues in a timely manner upstream.

OK. Will review and test this serires this week.

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Chris Mason (5):
>        mm/mempolicy: charge shared policy nodes
>        mm/shmem: honour F_SEAL_EXEC when an ACL is set
>        mm/shmem: avoid moving the truncation start backwards
>        mm/shmem: stop retrying folios that cannot be split
>        mm/shmem: preserve data in clean folios when splitting fails
> 
> David Hildenbrand (Arm) (7):
>        mm/shmem: discard whole new large folios on fallocate rollback
>        mm/shmem: rescan after nonuniform folio splitting
>        mm/shmem: fix truncate hang in large swap entry
>        mm/shmem: preserve allocation errors when swapping in large entries
>        mm/shmem: fix truncate loop after boundary swapin failure
>        mm/shmem: fix accounting of swapin-error markers
>        mm/shmem: fix truncation of files containing only swapin-error markers
> 
> Eva Kurchatova (1):
>        hugetlbfs: enforce F_SEAL_EXEC in setattr
> 
> Josef Bacik (3):
>        tmpfs: keep the quota soft limits of an unused id
>        tmpfs: preserve explicitly disabled quota limits
>        mm/shmem: hold off eviction in shmem_writeout()
> 
>   fs/hugetlbfs/inode.c  |   8 +++
>   include/linux/memfd.h |   9 +++
>   mm/mempolicy.c        |   4 +-
>   mm/shmem.c            | 170 +++++++++++++++++++++++++++++++++++---------------
>   mm/shmem_quota.c      |  28 +++++----
>   5 files changed, 154 insertions(+), 65 deletions(-)
> 
> ---
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
> 
> change-id: 20261025-fixes_shmem-2782719b130e
> 
> --
> 
> Cheers,
> 
> David


