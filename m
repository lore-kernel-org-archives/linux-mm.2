Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E143C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EE16B008C; Thu,  9 Jul 2026 23:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFCD6B0092; Thu,  9 Jul 2026 23:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705456B0093; Thu,  9 Jul 2026 23:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBAB6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:49:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA8A1140338
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:48:59 +0000 (UTC)
X-FDA: 84971485998.07.057A8A2
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C64940007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:48:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ENIdlXh4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783655338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8AK1eIZIM4gwAkDFaNwngBUDojHeaE9xY2rmvZIuvwQ=;
	b=uieYeGWmwV3fSdpFyogbBXtPpxFUnmZFD42lOrQ56I+mvqt42FjslwmU7e8xZhSDDNTTLG
	CsxlWNKQKcEL1bX6suaV8YO2/66N/CmEcW4TC4cmmEwTPNgQ0oKmIAySDMNl1x0gH2YVqt
	pnuULFfcOA5+CWE6MM5u1jmti+yLmKQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ENIdlXh4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783655338;
	b=4EhHLbZ7R6Si6O6OlYycnGjrlvj7azmTzQEbBBxljMcDzQ2EAyDicTPFsP5b4o4983/f79
	bsn3kdEa2wAoQFRHjczjyywyfwEpWZKFprjF0qOt83LcAI7S1GoqYMmy1+otsQOXgICXt4
	RhpTD0U710C3ZMU5G+qTmb4+CW5VH5c=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783655333; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8AK1eIZIM4gwAkDFaNwngBUDojHeaE9xY2rmvZIuvwQ=;
	b=ENIdlXh4rMtaGpjzvwruTMxSyBQJg+1p7tLZhTqRYegcwbK0U2zjZUF7I457J7yFsw65fLfBdb0wf38Zu8zHr/wJlaOppHPkTYrwoMdr4+stvLuy6KzTi8inSAsV4Namx1tfylCOcpd81IhA9L1cJOJ1orE2MBH9OpmU5yiThno=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X6mK60X_1783655330;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6mK60X_1783655330 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 10 Jul 2026 11:48:50 +0800
Message-ID: <c820fc9c-8e5a-4708-a773-3b005bcdb541@linux.alibaba.com>
Date: Fri, 10 Jul 2026 11:48:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable v2] mm/khugepaged: write all dirty file folios when
 collapsing
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Matthew Wilcox <willy@infradead.org>, Song Liu <song@kernel.org>,
 Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>,
 Gregg Leventhal <gleventhal@janestreet.com>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260708151357.353173-1-pfalcato@suse.de>
 <ak556WxAZCyqQqbf@pedro-suse.lan>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ak556WxAZCyqQqbf@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4C64940007
X-Stat-Signature: tnn17w3x5kgwzmd7c8wc1euiewhh554y
X-Rspam-User: 
X-HE-Tag: 1783655335-155632
X-HE-Meta: U2FsdGVkX18JRKo8GNiBDpKR+SVTNSZ0Nc3mtBlvvNfayeLnVBYUndf03ZGT7y284uUtYNc34I9ljij62asqDURoD/jM3d9USLs8rP/dQHFB4aicMmPQ7t7U4AH+a1sll3ut3HbB5fx42R6eI5SQNkuCzLSDM+4DOKqrBmdlWEP6AFLiLIElRiuqzmDfezjemNmurJ/aG7kFQYXQOSDUVGfB2ZIlEGCv6dUJHirAouwRSBBvS3IUkNlFHUwCPdZawJ+zJ3ovzGy3YZt7H3Qo563Y7H7Bhd6xPfjMBgo2GuNPkm517LazCLKVA7+4R8K1wmzNcToyj+uKxZGrt0BVAb0nxmCgXMWbTDOqUKoEUMYUXIW6UVOun0jKa6oR/QC7i73+zlWTKcg565F1EM0oTdp+bmQJhQp4Bj8NlmKDv4MzDmqOxPkZS9rceCbjwtYue77DOu5fcr1F6IJvMaYU9y9fo9kIOPWonq8ass1uO/4hchdqNg703D7ABEAL/wD8F0JqV8VWlszBkwK9J4hxsa0OFCXlgywuJA7svbPcgSOEz1opK3Nn672QWScTRKrCy0C486vDPfjHjydOU+UmGiOKsr+4eEc76FeP1sgXoL85+PTsLwepnr2pbHuJ2ImoJaKse2wFBBXqznHqFKW+cFVqaHH/Kvsrps1P9qFedRyABRLvpVhe5/NAbY2jSrl6XXjDmWjKMRn7LsuOUE16q51zrMSma3KiUMWbqFAYsV6HySqbAR20u2Gi1duEk1zved9VjRZpGlDK9wM8KwBzbX9bF7H43GYqHZq67wlVC5otNZel0KBP5Lxa4Xwpafn7suYLtBCqBtCMhZUeiTkAs8nWijUCy+WGc0/PksPQH+lEO7VQtVOajdzyA4vdyPOMpF4Qmt1TQsrcblS3PWmv3XgiH4POuuE97Kf/wztxRrZtc4+gU6p8GtR1A3WSnqoib2yvAcL9CBaqds3ltI7
 eJRHKZqd
 XMr7jnvtYox6QAdtHzlyCbZYtYkodnNoqUEYlEEIpq0wdyKykyFdPtvqY5ct4S6BLWyyCyXyDYbBDSheobnZAGMO8zc3HYHGB2xIqh2zWz19p/iiTEwBitRXz0AVZknHSuOwmg7fYNZ8PHCmPeZ9jne3EcMbP4QfefWJ0+Z5TxpFtsxFQEesWHYNRN10zfR3WW+5R5owvlLCiRcHhSmYFewLnQOV/QCFJEuNe2lK7n+Gv/xXs5JESk485FRGWTCmH3YnOPBm35KZJYbD4S16PsWyCjL8a5MLttdiJUDD6juqnvY5SBpErp4aKY8j3rtC+OClkwD3B0mXz9UgfNIdqN+6XNK6OMntnlU/BAQCR4T8+rZ70pgkKugHei78t1uoqfdhaSFi+Tj/Ab9+grqXcEzo0Rx4CH9QG5X3Pgy67IIkYCwNGYcYWnbqQp9GQlhs+Y3B4aY0+Ks4/KUjW28KCDF8neXsuRjrza/P3eWlsRlHAv/i+YfCSYlQETMvsP0m2mM22ffJzV9y1Xg47geryyoXB9jho1lqEPiRSKCNwFXb44f4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/26 12:28 AM, Pedro Falcato wrote:
> Seems that I accidentally dropped linked list Cc's here, see
> https://lore.kernel.org/stable/20260708151357.353173-1-pfalcato@suse.de/
> 
> On Wed, Jul 08, 2026 at 04:13:57PM +0100, Pedro Falcato wrote:
>> [There is no upstream commit, as this code was removed by upstream
>>   commit 044925f9b565 ("mm: fs: remove filemap_nr_thps*() functions and their users")]
>>
>> As-is, khugepaged and writable-file opening exclude each other. A file
>> cannot be open writeable and have THPs (because the filesystem is not aware
>> of them). khugepaged will never collapse file pages for files that are
>> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>> particular file is dropped. This is fine because nothing could've been
>> dirtied.
>>
>> However, there is an edge-case: collapse_file() might not be able to
>> coexist with concurrent writers, but it can coexist with dirty folios
>> (from previous writers). Therefore, the following can happen:
>>
>> open(file, O_RDWR)
>> write(file)
>> close(file)
>> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>> open(file, O_RDWR)
>>   nr_thps > 0
>>    truncate_inode_pages()
>>      /* THPs are cleared out, but so are the dirty folios */
>>
>> When this edge-case happens, there is data loss, as the dirty folios are
>> fully discarded.
>>
>> Fix it by fully writing back the page cache (and waiting) when collapsing
>> file THPs. Doing so provides the guarantee that no dirty folio will be
>> observed while there are active THPs. To fully ensure this is safe, the
>> invalidate_lock needs to be held while doing the writeout, so that
>> do_dentry_open()'s page cache truncation excludes this write-and-wait.
>>
>> As a side effect, move the nr_thps counter bumping outside the i_pages
>> lock. This is correct since the counter itself is an atomic_t and the
>> producer <-> consumer correctness is provided by a full memory barrier:
>> smp_mb() in collapse_file()/memory barrier implied by full ordering in
>> get_write_access() -> atomic_inc_unless_negative().
>>
>> Cc: stable@vger.kernel.org
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Song Liu <song@kernel.org>
>> Cc: Eric Hagberg <ehagberg@janestreet.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
>> Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
>> Tested-by: Zi Yan <ziy@nvidia.com>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

