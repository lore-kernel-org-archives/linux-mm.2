Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA2BFF885A
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 10:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28826B0005; Sun,  3 May 2026 06:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD90C6B008A; Sun,  3 May 2026 06:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7E26B008C; Sun,  3 May 2026 06:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 870B76B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:57:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E53201409BE
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:57:32 +0000 (UTC)
X-FDA: 84725807544.23.0E1DFBD
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E6A7C0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:57:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dL5p5HXE;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777805851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ys4F9jLZCUagMJPlUlEDYoYDPgQdni61LpfAhjLSMOE=;
	b=Ur/WkGdVqxdXnBCpz8362d7JH7BNPZTOYrPsvyujPPgput1ZCzHuB51dyTLoTR2KoCKAGu
	hLXgkFW0Qw3b8NpzTDUqRznoFjQc/J7PqHnZB3Fz6Ymzm6MbMQOOR+2kbuII/n1zL0Fsa7
	KdlGb6SclhpkTXBagNCOjbniOVrAhiI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dL5p5HXE;
	spf=pass (imf22.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777805851; a=rsa-sha256;
	cv=none;
	b=PIazlLgL07FLwrvbdqzGHuqAnBwMvCDRKvSrOQCSBazv4gngqAIHzJMK4hGU/LFz/fupiH
	dm+NwFFH4g71F/3c+LtiYTnnh/yr4ceXL2UlxOJCBp4u9tMAgzT1hM9pjCP/VeHPeYZa8j
	dcQt6/4EAiuWuh98LUtHfS15D9WoTRA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b788a98557so27426665ad.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777805850; x=1778410650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ys4F9jLZCUagMJPlUlEDYoYDPgQdni61LpfAhjLSMOE=;
        b=dL5p5HXEiPEAxPOYjbw9ZTQOKsb6AK8CVdQKksoLH5z7Bj1/U4qaKnncRFwsBbq43L
         rayM2qf6JEwdfd3jQlAH+9skJxhwTjD3EKt5yt16NFwnZe2uvlqJGUOLAtJ20sgf9Ixs
         X7CuIbas49eeq1diCQOrPxznllIV6pIkqkhFcJn2WQkoA5IzzPEZGDZzhHrGVYt7DcU8
         kUeDMBZenCJgq/t+CvwBLv+UY3fP+PEyNy55y8ZYe7gvuMy27LQW8NOlnd++332UEwJn
         rn/NIsHsWOVsmi3+Zl3c40C/NEPbIb/k5N2rHp/SW4pyM5Bn2c3lhBtuDsKAV2CcI3A6
         5Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777805850; x=1778410650;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ys4F9jLZCUagMJPlUlEDYoYDPgQdni61LpfAhjLSMOE=;
        b=Agk2PhWx0vrHNva3x7f10AHttl7o1M5NnSjG4so4MdEe44zDYpMq/z/r4qfgioEthK
         RInPQtqNEkGwhdLTdh95o/VzZI+97j4uTXTVcdfzQa4EZ04J4FTjhhz0MmDYJiLt0Elu
         Mrlaj0pyhoNg/CMFTzA7FABYKbUKpYdgA5UzHFI5YZKHBhiWW/DnstrbtSqLBd7xDySA
         x+YQ0MYZInauvCuisltlgsnAMYafL5FQ6Sx7eOueohdKMhIrWVgCjHgjCZy3sG67LVub
         LgL9pcXEkWULIRz2lhtNayMYIGAdwHiszLztOugKUbMfV5c91uQEMOh9yc+FXtHOBi/A
         a0jA==
X-Forwarded-Encrypted: i=1; AFNElJ+2W4JX+fLbD2hxOtwKi8VFuKppoU2JCT4mvzc6o4GAidyY22oEHksaEyP052fDvdUrU+sReH7n2w==@kvack.org
X-Gm-Message-State: AOJu0Yy6tFgjR0lf/ZPTwRInOHvHz8/rRd9e3hcPEDFeSsWSC7cmH8cm
	KuXBP7dyPD+gR7ZrzQ38Xnd70e3FRhUkWnQQ/0Bzyco9nIE4RzTQNtYj
X-Gm-Gg: AeBDieslKjujSeTVOBIgAxezoIwML+l3WwH9mNUz0Di2jqdltYse0MOKfivyR0Otmyh
	vV9Fehx6bJgHsE7FGU3LJ2Xaj+YZ9TXd8RezRAn3LddLYPU7JdnB7AqpJ57kARJ//5t4ENyIlgD
	vwUDuwJXImQMtpRH9+QJhb4ABIUfOsHcUeEgha+iwA8bKL5k5zAAZxVrhI12YUwdfJeLRCp7b1Y
	FSjAGiMEh0P/mWdhxB+b5uejdMBVyAI3/r5zS/LRGOYNzVQyRN6VXd2eTa7/Ouggoz2Gth/fwen
	e4NNJOE18IrJy1NGyf/XFBY5nObtNeFAUBsVJjC15tnAp1vUFKs9tU3FyGyLLLK8YXnF/SmwbXI
	64MH7Qeawmt7on9quL2bFja9cQ18ACb2eg9vit+zJbXumMq7jTRQhAwB9sdj91IRT1fVqsQR9Ge
	B9NjJwccgleLHClIgzdBX2aXbTwuUiLr/t
X-Received: by 2002:a17:902:708c:b0:2b2:b117:1d5d with SMTP id d9443c01a7336-2b9f282befdmr38615915ad.33.1777805849735;
        Sun, 03 May 2026 03:57:29 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae4a127sm94009995ad.67.2026.05.03.03.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 03:57:28 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Salvatore Dipietro <dipiets@amazon.it>, Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.com>
Cc: abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com, brauner@kernel.org, dipietro.salvatore@gmail.com, dipiets@amazon.it, djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH 1/1] iomap: avoid compaction for costly folio order allocation
In-Reply-To: <20260428150240.3009-1-dipiets@amazon.it>
Date: Sun, 03 May 2026 11:22:10 +0530
Message-ID: <a4uhrqet.ritesh.list@gmail.com>
References: <cxztt8nw.ritesh.list@gmail.com> <20260428150240.3009-1-dipiets@amazon.it>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E6A7C0005
X-Stat-Signature: cazq3cc3cbupo3gbxwg7wyk9wtf6an54
X-HE-Tag: 1777805850-303757
X-HE-Meta: U2FsdGVkX19VsMc2HoJVbEvEKgCleCwiAPEnzxI7VMY1uWuTq/1E/wl7lCDvoYjSssmkaoEbuiuwPz1nOdIgm0G8SGiY/ZAUVwd3u7ZdzW/xaJ8nVmxNsWhE0ZtyeqrsIok7+saOOm8CCXAs7GzWiZMrcMlpCkNiwUxTzpqwNTN4jC38XWFqXMRcVcotbdbYKG/OQ+sxF9dTbVUcfPaeeiiRpZB+NsPGsm6ZkW4k9F6sL3/cMt/xyY7XbEfrrr5AsSlR7VHI1Igypn8Jfi7sRTYVRjHPFOYNyZfa+p+OpEeFH3NNKTuS5zG08TgIrsMK99iX4dgOmjds5O6rvnsjI/NT8t73ayvcilO14hwzxuTgfi5qQjZYr2HvgSIrDUQefXMDpGFj1etNGsWBdp7lJcpQ0RbvFe4djgJAMyTiakVgZew/GPSt8vpY662F0d2r4N/zlEpVhuqmkm/I3kYvxJrWWjYePwHhc8lL26Rm52cX3UU2CaY/vW/yXyCQPSBQ0Fgvs2r6S1ZJQMqPRqDa4eM+k/ToLpR7HLr3jECZy97DRaXguPYnI9KbKOY2nacs80yL3xlew6gDNQANsVqiX4tKJapATNMy9tzMQQfQAuDuJbLljc7TsNrJvmD0f3Y0x7j7KDMf9BlLUfKI/BXZv/VaxEiqyDPfIMhHUrgeCCYJf1o+cbSIsHU9vT3p7js4SfnvmkK8B01BkhK792iRER9QRGT7zeA+c4FQntB3TK+LPGrC2+0RS0MxoB+t2giLpakdLImnKKhjBkQ6qlFt3lxkJkEPizDYKzAVYZwtoddqnoyZkpD6bKtjc52xAvedZIT2CV/c8gLfdRpdGh+dbgwnN2z71JYzgZgOZuhzQxB+lelFvqrXELedf9zzD2udKfv5AYYKnEu55pOCGvlhry8OO+h69RN4m4FTZl3KBdsa+IzyLcM0pwxYRwO4FyP4z/g8nTV2ro2NNQRdHfR
 d4VFjK++
 azpdnoPWnV+jbw5snOWP0RTWwWjsDeey21eDBqMITDbkh/W5vSlpP2OF4x5RakbGbl4dpYZSzZxW6litGmQ4m0C9Pt2kVjARyj5NWMC/RLcaHfKPA2PueSyvtBKt+oOHZP3V+Z5iKftmbc6II1dfqJF0GuuqWpYBm1U0bDe5otxOQKvS466Haw7eWarNhRN/eSEfa8YrN9/uPuKLGz0iDeYFd+Ka3/WPiNsj9wCh0YRvn+9OUZBtASohW/AsUAwZZfmbDHaSJCjWWk5hYPjZO/9Hc/RFfUflVAeQj1K4Pxx8NU6n4XcycrIiOBN5aEhXwIUe6e8b2IBRLxhoXr2yeczwNAKDW7EOX1DQShdpRSmmmBaN9t5o8KXAt+g00QKMRrJEomXbSzyuQ7+ZTnBO8MT8QzzioSOQDoEfsoISdc7+pNqCb2RHpffhKdeXj6ZMU9F/EP9GBEKK6hrrwwly35BlU7Lcmx4BMS2ahL+pxxaAtWuPRZc0LjGu2MxkjZEvUYJ98lwQe0NNUU3YoEFtzoVAUtUpfaSE3LSFZvcT9aEC1JPuplxz5C9sWZLywbDHUDQ6tF+8EMegsBol7eAiT5/Cut/3Wr9QwMWgB6WSxdzgDgWuzKUf9wVemcG6/JYjtkjUkr0dEpj76vao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Sorry about the delayed response, got caught up in some other work.

Salvatore Dipietro <dipiets@amazon.it> writes:

> On 4/21/26 00:43, Ritesh Harjani wrote:
>> Also, given the Maintainers (willy, Christoph, Dave) shown their
>> dis-interest in taking the patch in it's current form, the right way is
>> to get back with performance data with both the approaches (which we
>> were discussing) and first get the consensus from everyone, before
>> proposing this as a patch :).
>
> Thank you for the follow-up and the additional context, Ritesh.
> I might have misunderstood the previous request and will make sure to 
> link back to previous patch versions in the future.
> Here are the performance results that we have collected on our end with
> the proposed patches:
>
>
> | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |

> | PG huge_pages + pre-alloc mem | THP     |   Run 1 |   Run 2 |   Run 3 | Average |
> |-------------------------------|---------|--------:|--------:|--------:|--------:|
> | on                            | never   | 189,418 | 187,764 | 188,207 | 188,463 |
>

First of all thanks for sharing the detailed performance numbers.

Ok, so here is what I understood from the data you shared.
This performance problem is mostly seen with PostgreSQL huge_pages=off
[1][2] i.e.

baseline-no-patches                 ~104K
v/s
baseline-no-patches+huge_pages=on   ~188K

Also the observation with huge_pages=off is - we have 40% of memory as page
table memory (as you pointed below)

> We do not use any tool to fragment the memory in advance. Collecting 
> memory metric of this system, we noticed that ~40% of memory is used by
> PageTables since PostgreSQL spawns a new process for each client limiting
> significantly the available caching and free memory.
>

So there must be 2 things going on with huge_pages=on option here:

1. Huge pages use PMD-size mapping, which eliminates the need of PTE
tables entirely. This then reduces the amount of memory consumed by page
tables. W/O huges pages, the page table overhead become significant
(~40% of DRAM), because on fork, each child process gets it's own copy
of the PTE tables (even though the underlying shared memory pages
remains the same)

2. The second savings might come from the fact that Linux supports
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING with hugetlb. With this, the
PMD table pages themselves are shared among proceses.

[1]:
https://www.postgresql.org/docs/current/runtime-config-resource.html
[2]:
https://www.postgresql.org/docs/current/kernel-resources.html#LINUX-HUGE-PAGES

So the above explain the 40% of memory used up in Page tables.


Now this is what I believe could be the reason for memory fragmentation
with this workload - 
In Linux, each PTE page table uses 4KB size (assuming you are using 4KB
system PAGE_SIZE). When your workload forks a
child process for each new connection, child gets its own copy of the
page tables which maps the shared buffer.
Since each PTE table is a single 4KB page, hundreds of connections
spawning means hundreds of thousands of single-page allocations for page
tables. So it looks like, the major source of your memory fragmentation
problem must be these several order-0 allocations for PTE page table
pages.

Also as per the documentation [1], huge_pages=try option is the default
setting. So I am assuming in production we at least won't suffer from
this memory fragmentation, correct?

[1]: https://www.postgresql.org/docs/current/runtime-config-resource.html

> PostgreSQL write pattern consists mostly of 8/16 KB data but during 
> the database checkpoints, by default every 5 minutes, it flushes write-ahead
> logs to disk, which uses large folios. At this point, the system attempts to
> satisfy the folio allocation request, triggering the regression and falling
> into the slow path, as shown by the Linux perf profile below:
>
>   `-0.26%-__arm64_sys_pwrite64
>     `-0.26%-vfs_write
>       `-0.26%-xfs_file_write_iter
>         `-0.26%-xfs_file_buffered_write
>           `-0.26%-iomap_file_buffered_write
>             `-0.26%-iomap_write_iter
>               `-0.22%-iomap_write_begin
>                 `-0.22%-iomap_get_folio
>                   `-0.22%-__filemap_get_folio
>                     `-0.21%-filemap_alloc_folio->alloc_pages
>                       `-0.20%-__alloc_pages_slowpath
>                         |-0.12%-__alloc_pages_direct_compact
>                         | `-0.12%-try_to_compact_pages
>                         |   `-0.11%-compact_zone
>                         |     `-0.11%-isolate_migratepages
>                         `-0.07%-__drain_all_pages
>                           `-0.07%-drain_pages_zone
>                             `-0.07%-free_pcppages_bulk
>

However, I agree that it still make sense look into possible solution to
address this performance gap which you pointed out when the system has
memory fragmentation (with huge_pages=off).


> | Patch                |    Run 1   |    Run 2   |    Run 3   |   Average   | % vs Baseline |
> |----------------------|-----------:|-----------:|-----------:|------------:|:-------------:|
> | Baseline             | 107,064.61 |  97,043.86 | 101,830.78 | 101,979.75  |       —       |
> | Proposed patch       | 146,012.23 | 136,392.36 | 141,178.00 | 141,194.20  |    +38.45%    |
> | Ritesh's suggestion  | 147,481.50 | 133,069.03 | 137,051.30 | 139,200.61  |    +36.50%    |
> | Matthew's suggestion | 145,653.91 | 144,169.24 | 141,768.31 | 143,863.82  |    +41.07%    |


The main reason, why I proposed the below patch was because, this only
affects costly order allocation (i.e for order > PAGE_ALLOC_COSTLY_ORDER)
by skipping direct reclaim for those orders, while still keeping the
behaviour same for others.

So, for smaller orders (order > min_order and <=
PAGE_ALLOC_COSTLY_ORDER), the allocator will still attempt for direct
reclaim and compaction (which I guess is required to avoid oom too?) And
also, this looks like a change which could be easily backportable :)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..f2343c26dd63 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2007,8 +2007,13 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order > min_order)
-				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
+			if (order > min_order) {
+				alloc_gfp |= __GFP_NOWARN;
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					alloc_gfp &= ~__GFP_DIRECT_RECLAIM;
+				else
+					alloc_gfp |= __GFP_NORETRY;
+			}


But of course let's hear from others on their suggestions / thoughts.
Maybe the filemap is not the right place to fix this as Matthew, Andrew
and others were pointing. Any other suggestions on how to approach this,
please?

-ritesh

