Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203A4C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 19:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21C36B009E; Sun,  5 Jul 2026 15:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF97B6B00A0; Sun,  5 Jul 2026 15:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36AD6B00A1; Sun,  5 Jul 2026 15:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60356B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:21:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29C811201A4
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:21:41 +0000 (UTC)
X-FDA: 84955692402.14.F59ECD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FF1740007
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 19:21:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IlLB9aXa;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783279299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA58sFWd3zYRKQmQfWY0b2tw8eB6raZO+QUDUb8S1aM=;
	b=rHybo5C1LhUHJH+ct2qDiT1aswcpeRqrhotzQ6hqxBw90dbkW82eu4kB0Ql4jsrXNmlN/i
	cK/kWo7cSjcOI66aJovtkjibVi00x5zK2T3KJu0EU1b0wmNgdl7+36PLzqe4GOhBcg7PCV
	hJSBG87dSIe74wQr4ZOfr9SUAmajoXE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IlLB9aXa;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783279299;
	b=8aj313B8/l31luGlAtI6sWw8SQAe/OCIZmZc8gIp1FaMW4ZK0s8MwOrcNm+NFgalm8650g
	+bGwc/SbbiuEJglfBC/O0d5gHIT6Av3SPV+OEUkleuxdMpIF+YdK/7qTzG3nchwntQ6wg2
	bbyV0H3jP+kiniYn8tNNyvu2PCeImuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DFEF41A12;
	Sun,  5 Jul 2026 19:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAC41F000E9;
	Sun,  5 Jul 2026 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783279298;
	bh=dA58sFWd3zYRKQmQfWY0b2tw8eB6raZO+QUDUb8S1aM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IlLB9aXaB+hSdrkbY80lXftCXWZyiM8Ry4Yrllf8b0wCWHHGc66eum6PCQd8ZYFas
	 R9jFwzOGfriy8BkzvNpVZoi/WlrwNqmma7EK1NmHD7RQekLw0TQmKJda2GY56Q8ABb
	 CZrhY8S15nBugF9wZI1aPXITrRrRNTpRy8I0tYGU=
Date: Sun, 5 Jul 2026 12:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh
 Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v7 0/3] mm: clean up folio LRU and swap declarations
Message-Id: <20260705122136.0ad3b1f7132610134786afbf@linux-foundation.org>
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FF1740007
X-Stat-Signature: 76w97ieed5arsis6ccdu1tk1y7tj5z7o
X-HE-Tag: 1783279299-979470
X-HE-Meta: U2FsdGVkX1/TkH0n6vLfPrp7Q98LBTOTxmb+Oux6yB3YRihKdxGF6eyz1CDSGuMNNgrtEE4kB791YqxbrrQ2TrwrCHRUBX0frArxLI5l4EdrPqawr3nAM0LIht5laivOdkuy266wFR1EBQ11KxIX//xJNRLTXmeahV47a8d81SOL9CANo15CCft7qezvDLZYgOCXVf6iXy/ftIAvST52WCVNi+VGYI813Qj8dsATaTGLpmkQAUeKgeUKp/aSiUStEW0+GyBaUvKyVe0LnA109RsEKIYw+ueWYM43X5rINhWxKYMCf8MgSfrx78t5XUE5XEUrdFCJ/WFQ28YcWSsCwtCM96G/dtWC8SzNSBX67h1qA/U3m6jjNqlBuOJc2ozMz4pi4xubn1Lsh2uWG4/Xq/Nker/YomCIll61fBLm/RSCUt1sWvjez0drY3obF06I6o6I/qvNR/4t7fnDtOMqhJRiBMYD76sYq5NMg8IZ2r5XiURgKrLGTGHTSaXMVODquIZJmypG5fhzaNlpypv5zt3KQNNspP7kdgzhnZ7ClCqCGsIMU1G4xTre6y2HCrXtDcA0Vu5iKEKSKxmaNMFvJnfSoMqOtkZ5ycBwB9NdD+DGNM0VHsH76Us6UFWgc/sVKYsIkqkKwULukMhL4fpixyMYQm/ItTNsdgkAG5aU8hPhHpNCM1oK+8ZudhM/6MTw93v25xU/FPTUFo/qgWpR8vBojWaxf6cyFevnhdIPSTqGIoCu0N7C0/oVNp2K51UGUpJCQxXN+MCGO1ulfh9Ls4YJ95SxPlvxb7MQa7eYmiB50KaAXkIi+v/AGF2XnvWIWVBimx8ixEwIoc+73TmrABTDZ22H19GdMXFeZ2cYj3NhSaDN8xuK6bPXGHF2sYy5LbSFymsI3UcekplSTl5TjF9PxdACbLZmm8s4qTAhhMoHtHkfc1jyqleGWJfKDAT/Li56qcIOaFb3xvP5Oj/
 z+B+sjdy
 bH8tSPJRpAgBxrZYCC2itf32Z/3d5rG5D5uzQFEhXai8TaLZQZkyRhR49F6TUxedPa8xK5qUvHrW2AsJCkNIdrTT4IrD7D4uGoEcgq084z9JdnjJUljYxa51aSzfnG6IG07lsArb2jRR5lBOfjziuf1tPHHP0ZRkaN6phK5ccFdg8gqHfBsyEK4+wHpyIx0jtPFYHXp5jyNhtfj2AQ+AVYW90OZXMAmsFwgT1WH9AtcSurbcf9OmgHI6msqDuAtohRpwNLBmlPN8jfQiqQliADHM3AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 05 Jul 2026 22:12:30 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:

> This series splits folio LRU and swap cleanup into three steps:
> 
>   - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
>   - rename mm/swap.c to mm/folio.c after the swap-specific bits move out
>   - move MM-internal reclaim declarations out of include/linux/swap.h
> 
> After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
> folio LRU helpers live in mm/folio.c, and MM-internal reclaim/workingset
> declarations move from include/linux/swap.h to mm/internal.h (public LRU
> helpers used outside mm/ remain in swap.h).

Thanks, I've added this to mm.git's mm-new branch - in a few days I'll
move it into mm-unstable for linux-next inclusion.  After -rc4 (approx)
I'll move it into mm.git's non-rebasing mm-stable branch for
upstreaming during the 7.3-rc1 merge window.


