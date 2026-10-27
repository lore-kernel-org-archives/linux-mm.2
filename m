Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07F0606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ui8p2Pzn
Received: by kanga.kvack.org (Postfix)
	id E13AC6B05C7; Tue, 27 Oct 2026 04:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB1E6B05CA; Tue, 27 Oct 2026 04:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D272C6B05CC; Tue, 27 Oct 2026 04:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F8F6B05C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:59:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48FB81406AF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:59:51 +0000 (UTC)
X-FDA: 85367808582.16.D7ED636
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6383E40006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:59:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ui8p2Pzn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6D1TMuAeRek2s1DNXoMx/ngM+qIMzVdkNgeKSRi4QI=;
	b=sT4246t2Kjp8VciVBPPwjGQTKdnpNvroLWPRXbhHrGkXtqrXZwGu01IECsQ6aWyzDs87yO
	h6mlf0vC2XCJS4OLyEv0KjdxbxhbXegYcBDtkrp2B82qS1bT+MM5WWHaVfGgzliBfJGTre
	OqLCPubrIwCo8Ijg4/u5e/fggJ4EJ5I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ui8p2Pzn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091589;
	b=gNzPis/+xBkPoZoAmwugUlIROZl2DklI0pb8G5aM9UzcmlzwZtvUJ41lW23I7czV4MtAqk
	yU5tMGb6p38IroDg2kz3FpmZqI4/c2UFvsf7fE4bmPqMglqNW+L8Y15QjdAm3qsDfJAwuT
	2aOkThhT/XYPKDxorUJpem3J1L30Xws=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793091585; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=m6D1TMuAeRek2s1DNXoMx/ngM+qIMzVdkNgeKSRi4QI=;
	b=ui8p2PznbOTfH9zH3kNV7v2idFUQM8pUo7CNErrTc5AO1iKJIDD7Vn9rXiu6nY/9TA2PS22k/C3rgV8Duwa5G+N35nn+rr5aSnI/SJraHpbjtMP1SRWa4Kjm8MXysfozky62Ci9nyMDTaPXB5UFe5O7U1X42cvQnkgCuoiKPaho=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0XDdD1uE_1793091582;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDdD1uE_1793091582 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 16:59:44 +0800
Message-ID: <152d698f-d7bd-4e1a-9736-412d52e2370c@linux.alibaba.com>
Date: Tue, 27 Oct 2026 16:59:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/16] mm/shmem: fix truncate hang in large swap entry
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026-fixes_shmem-v1-12-703206d5fa0c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6383E40006
X-Stat-Signature: nqg8tiu6xbu7taug4b6rfpzw9g8kiw3p
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793091588-83007
X-HE-Meta: U2FsdGVkX1/X33IaYzlO5b4bxIjA8dPl8r9DPZ1Lz/MuERm/tcAwn3mqKMzh1vKSRkDjYfkQUOF5Km0ndb+qfrbEnn0PG01ZuudtT3WG5uqoGXR3lOvGi5b9peovtHH4kZary5WQ/FKKIJciMUz+WeU6zlfW0dHVFzLb18fXVrVWnPg4lbTvHR/gXqzuAj02PckOt7XryULjDQjlm/Rm7k24tnpZxKkzgzXYVGaRPIQrd0pP/6b0PI+r694FxzTfFhgcP9lg/GrsgYl9DHEotcLYHoNxKo8IjaaxBdJMYgX2ML92zwaSAX4XwPLzcGLiD9w0k6WlwfzxPz2izg1NOAzUbSzdGPOoOJCBlMLmKnMNocyihUELjitLVzr1wq6XGfP8bYGGQHUKoYxjvQrrUr49Xk/Phzk00wfR9FS4uwra04mGIflEiDunUP9Xf5xVwsNRZxiicKD8bXFWYmTYrgUfNjZtA3re+z2gohLWAaU8IauLic6XGu0J2PoROq+odlZAXwxSbOR7mxgc/THX1FOMnorob1jYj/n+mbt/MJhgYUrAj+QcKV4irRSzBRsed2EY6Me6ILwq81nwFHkhGIfkn1nAk/lS3vWvQA7TfSK8InSGg9oWRffO58cYWzMfUnz+gU+fYBnSrBJZCORha4/lonEBKG6V2ZnkRml0xhrEogJzOL9y48V5qpC5m4SF5ZaMMIQWA2zHdJMJoNeHu7nZxTR0D9Q9ECAthUW96NJlyfIH507HzSemkFHP4xJLQ+PcWP4OHPNJlBym0kZEkR/dLljUBUu/cDTSf9wrQFmNhklrlAG7Kymbhj5YNFDHo1tIxPbie/idaZM1SD75iGHDo9smOjv7Z9xw58whodafqkH4c8mnH7mFi5MnJlOINFXZqiOjsvepvWAq3OoBj/a+PuzO+Cg9OyIn++YjtFhB73L97N4K0+3fpvJnMe52ZdU2DcpQN58wR+xoJWt
 9e0FHo5r
 ynUIgiPEVaTv+B332HCJ4N9Fj8wQ4OFxkRXELdkOxD76ABM8618aFXa+ZAKjSPlGBFqLtSGek7oqpZ7ILgG90c/qP3tEYLcudsfoiodfMxuz7ZaR2jzqenO1dMF4UfqLJSrJIMcEyGTuzmy6SyyY9lJb+77gwqVD78+56/1p7Sf8sG0v4GJqV9YnE9cZv76rceEpyUrJ1ejlUYlmCmRnsVWuMDXjaIghq53xKxxhujrMbGODXllW72y70EWQKrr/u4xMouZwttl74ZESiW8AgXR//jL7lvJo2413ght3/6Dwtu6BEZSkh4w+xMgKAqpC797c6FwRpS8k4xdaijJKosWxF1yXFul/R2Qx/w/0Sryng9ZTgG6TiqsszDcLSL+U70izpJUtd0aDvK9kdess7Djtz7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 5:40 PM, David Hildenbrand (Arm) wrote:
> Truncating a tmpfs file or memfd to a page-aligned size inside a large
> swap entry can loop indefinitely in shmem_undo_range(). The task holds
> the inode lock and cannot be killed.
> 
> A large swap entry represents a whole swapped-out folio. For example,
> truncate a file whose pages 0-7 share one swap entry to four pages:
> 
>      [ 0  1  2  3 | 4  5  6  7 ]
>           keep    |   discard
>                   ^
>              new EOF, start = 4
> 
> i_size has already been updated when boundary handling asks
> shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
> calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
> because its starting offset equals i_size. Nothing is read back.
> 
> The final scan cannot free the entry without losing pages 0-3. It skips
> it, restarts from start = 4, and finds it again indefinitely. An unaligned
> truncate avoids this particular failure because the requested page starts
> below i_size. Folios already in the page-cache cannot trigger it as the
> direct lookup will return them beyond EOF.
> 
> Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
> directly for swap entries. This bypasses the read path's i_size check,
> allowing the existing boundary handling to zero and split the folio. If
> swap-in returns a smaller folio, it also splits the swap entry so the final
> scan can free the entries beyond EOF. Retry the lookup if the entry
> changes during swap-in.

Make sense to me.

> Handling swap-in allocation failures remains broken and is unchanged by
> this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
> instead of -EEXIST, shmem_get_partial_folio() returns NULL and
> shmem_undo_range() skips boundary handling. If the large swap entry
> remains intact, truncation can still loop in the final scan, while hole
> punching can return without zeroing the boundary.
> 
> This may read an entire large folio back from swap while holding
> i_rwsem, only to discard part of it. Avoiding that I/O would require
> splitting both the swap entry and any large folio still in the swap
> cache. That, however, is much bigger work.

But I think this case is extremely rare, where every attempt to call 
shmem_split_large_entry() to split the large swap entry in the loop 
fails. At that point, the system is already in serious trouble, where 
even OOM kill cannot free up memory for the xarray allocation. Hard to 
believe this can actually happen in practice:).

> Original fix generated by LLM and sent by Chris Mason in private.
> 
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Changes look good to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

