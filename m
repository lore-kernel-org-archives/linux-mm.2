Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80942606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SiPiuBw/
Received: by kanga.kvack.org (Postfix)
	id 85BB56B093C; Tue, 27 Oct 2026 21:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833A06B093D; Tue, 27 Oct 2026 21:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770E36B093E; Tue, 27 Oct 2026 21:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54E7A6B093C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:31:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8EE980B8B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:31:08 +0000 (UTC)
X-FDA: 85370306616.14.4B1230C
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8B17A0007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:31:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SiPiuBw/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793151067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+s8dDKZ4dMb+kRwqacBsw98RYGi6uf2pwBAWjpaxZWo=;
	b=M+H3SSqHvhs8ZjGfzxsDPik1arkQ/pJ+e91OQ12uNdEjlF3jGFgH7YMAl3mntIiqWgLd8I
	dkIbPoAooX9dvgV/5cwTTsy39l8aaxkuTpAMgON1UioFR2rxCLZ2IOta7YuIa9SLO8OQKN
	Kv6m3sRIYLZA4ieE/pLy0aiiufkQrps=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="SiPiuBw/";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793151067;
	b=HWgUE7f3Li+CGd1udT46hHrV5uZHO34VMb9Tksp0slmHlAUkl0vD8skcWyi902H/qyiX1A
	SwLsAIuauDLIPlI4e02h27HtZm+rlmCn9ivRPt44PCgZANghLaw27tr+g76fKWfaMxkx7Q
	55bkazuEPO6y+Yasff4mzhmVCyZ88b4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793151062; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+s8dDKZ4dMb+kRwqacBsw98RYGi6uf2pwBAWjpaxZWo=;
	b=SiPiuBw/2qIU8k5giiQNgYR62e+bBw8qP6kvHWnu7ynoCtoIvfJlAHbIqKH17tf6YjBhxQ+4M6HV6NLAmsPilpI9ncUEy4FCUc/EpZ4MrCeVGC2NfNSn9DSg2PAO/oODN+Yo4rOQc1lc+BUXVAC2+h5JhXKUM75gzplYfdwiGH0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0XDfHy5f_1793151060;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDfHy5f_1793151060 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 09:31:01 +0800
Message-ID: <2d111275-e7a8-4ac5-8618-f068e87145f2@linux.alibaba.com>
Date: Wed, 28 Oct 2026 09:30:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] mm/shmem: fix truncate loop after boundary
 swapin failure
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8B17A0007
X-Stat-Signature: whmi3d3k4zryxzr8d61jwqyrhbdfc4in
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793151065-733525
X-HE-Meta: U2FsdGVkX1+p7jV8+qlyPwbkPZ+K9yemzTaHvFj3vQFStSfeDcE3+yYsy8CIYy5LI1wosnoVztPq4wS/+Saa00u576dj5JBbvuvGJQSm0TP2KdR0mzu7Zj1TP4VtNZLsGv0yUFeQqwxrdYJWHqVzVLzQIf3a6no33nMMge2jKf/MnZ/4C0VD4W1PrGPlnVkf9TjtGeIlTm2cxdsVfJQ4h7BIBpZdpSLB37kwepLzOrWd0odwTU2KylUuDLO/RTV0J/lDcw5cczX5ZxKTXf63Iyqt43E2Re1eHaxCthWUO6rzCO1PmrtB8bDuPK/n/4yH1H87f7I574Pw+LV5F/wAxzTOtPqWT6GFyarMeuxCiVkoXZ2ZlR9n/pgzeqIRKhbTm6Vg7vX6VNuCrA7kMTnUbi/tm4KUFfyPxSCDVEWhXGvgvl3aOCwSkmlDvqJ44LYZBQdMOkSOzmeyFYE4R1b+gfcrHd0TPd+ZsKZyrolgn29/HXdF9bpLpytYhkCnYdRhoTy6SbWxM5t10hVYqDhQiS7x6rmg0hTwSoMqfJT6NJeGpzShz0Nm+osLkwdLCR3ITtF7941ZgKz3KNMQgc4t/gQnDOS+l5NsP6I6JSVfTqkucIHp0gr9wue3OtSZOybir43S9nfM7lqUjTWT1fNoc3+wFwo+CzcGAb7Zvfjl50/aO7ZOfa3XkZU5LKdetGrXiO9fh+DoeGGdFX98Zzp6Hg6R8E0XUYU0PiQBNlxfqb/i8veJlzzKqvSDjYMq4+E4o9ebl0l3axPS5YtJDMJ7OE/y6CyD/6Ie0f2bgL6klGq0W4XAucOQcfOXpTzstCoy+b14Wlnms52oGSwdjjk2hzs9SUo1XA0kDqux82JWMjMwRaCG4KTB23T/T67SMWjndnC9KsF8qbpf00t8FiBMwBQCE1KMn+sJtNdmtAHWsNIc+MJNlbhPMfJ4xciHowpK8w0MZMUEYBkvpYbw8pU
 acoBu8p+
 SR8mHQ70B0Px24R2V6AvEJtURGjm9oqDLKb4oqoMNy1T82SB6NELo1pW2/xNpnBSflKUeVAh+XP4WZ7S/zILMuLY0xUW1ha++5Znait8nuRwnSnPF5X1rD3tItNb6Xh3O17EhnDDtuN/9Rz1G1+rpPJMCqYERwjbpW8Ohr3CDX4nVQUtyNqv5JmWeffjXUSMp/YsgeeZ1iYXqi4evBeK1cIjSryLzDPgdKw7rYP4lqweD0MREcXF5xshHdsrtEYKglJ4TNW4RU3iDqLf0IfMRAWmsUnZa8Few8JMjQjKzC2xn/xH7o1rJvT9Ja/jmEEBGqrXAi9UJxJomAYxQK5NKFpDwuvaBDc5eOe0YYZz36tXj2qFGA1JSx40eN2YUHOVY4IJfAoczb11koBrxdFNB0klTiw7HV+YbPSMgVEH9qOvt/rE0KYKYI4nO7aG262VBzGdUY43NBtJk9bO0fHI7qBd+hXPU2Or8f+X8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 9:03 PM, David Hildenbrand (Arm) wrote:
> If swapping in a large entry at the new EOF fails, shmem_undo_range()
> leaves the entry in place. Its final scan skips the entry, then restarts
> from the same start index and finds it again. Truncation can loop forever
> while holding i_rwsem.

Right. But ...

> Advance start past the skipped entry so that a restarted scan can finish,
> as we already do for folios that cannot be split.

IIRC, we originally avoided advancing start because a concurrent swapin 
fault could split the boundary large swap entry via 
shmem_split_large_entry(), leaving small swap entries below the new start.

Sigh.

There doesn't seem to be a simple fix. We may need to swap in the large 
entry as shmem_get_partial_folio() does, and then split the large folio. 
I'll work on this as a follow-up.

> Note that this does not fix the missing zeroing when boundary swapin fails,
> it merely prevents the endless loop.
> 
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
> Cc: stable@vger.kernel.org
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   mm/shmem.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9a11de010ed7b..4ece296a1ccf1 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1434,14 +1434,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>   					order = shmem_confirm_swap(mapping, indices[i],
>   								   radix_to_swp_entry(folio));
>   					/*
> -					 * If found a large swap entry cross the end or start
> -					 * border, skip it as the truncate_inode_partial_folio
> -					 * above should have at least zerod its content once.
> +					 * Skip boundary entries when restarting
> +					 * the scan to avoid endless loops after
> +					 * swapin failure.
>   					 */
>   					if (order > 0) {
>   						base = round_down(base, 1 << order);
> -						if (base < start || base + (1 << order) > end)
> +						if (base < start || base + (1 << order) > end) {
> +							start = max(start, base + (1 << order));
>   							continue;
> +						}
>   					}
>   					/* Swap was replaced by page or extended, retry */
>   					index = base;
> 


