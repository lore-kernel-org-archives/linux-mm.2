Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C32D358E4
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887556B0089; Thu, 29 Jan 2026 03:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A976B008A; Thu, 29 Jan 2026 03:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7163E6B008C; Thu, 29 Jan 2026 03:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4046B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:36:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CD90BBDF8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:36:05 +0000 (UTC)
X-FDA: 84384343890.09.2292F86
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id E5D8E1C0004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:36:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769675763; a=rsa-sha256;
	cv=none;
	b=6dH3vd96A4CKDoqbJlWi6uI01/5AojARj/1WOislvYoZpNN141M1Ylo9NBrlWLJaf0ervQ
	zUMf38LK6hOfOPeWkXQP1PVigy+cK2LY3W5xOajNoWlIvxNeiucafo2/G91/mLKcT54Wir
	4ZftLUCSYxK/zj0owVwjGCs6vTP49l8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769675763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GOQIMFRlXp3/E5hmGLLeLeoekJ+woe7NKwo+ZZJ/4UA=;
	b=PLIMmTZEbjUingkBzLA5q9FZ6kRmU9SUwoJimMlV+XyNEF1bfC/uh0yGNnvpEoFfb2J1xH
	RVfd6Kqv2UsXZDhcM25AIUkOdOPzXYLaXK5NapPZXebW+UOjvTPxYAFZ/2v8miftl7ja5f
	fQIn4ckD3Kg+MJPKFznQWE6SUO+tqFI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Jan 2026 17:35:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 29 Jan 2026 17:35:58 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 02/12] mm, swap: clean up swapon process and locking
Message-ID: <aXsb7tBiG8mZ57NJ@yjaykim-PowerEdge-T330>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-2-fe0b67ef0215@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-swap-table-p3-v2-2-fe0b67ef0215@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5D8E1C0004
X-Stat-Signature: trpubz6cgsriexb84tx56njjrfczodsb
X-HE-Tag: 1769675761-918725
X-HE-Meta: U2FsdGVkX18Uam8D7DWSvQtDv4N04gM+q+uGSUGdtKm7xqUjHCKeHpiUUO3Ypt3j1Ly7lJqOQtxw557V70aDJ8egXm1YhR6WAmJozYhVw5uMgzdXRN+IyekP6BbUl7+RlL9PG26j9iD+Ry72g5atBe1p4eY84EMkJlk2kbdL2ohBbLBn1zmSKqgHhT9DSc2qbBk8xUlPEhtrCN9VrxgxvK8Xvk7HaRrFOJC2+6XDTBcTxc6f7JyQijYCdMwSRT/EWj7bMdE0x4CL/JF2kiVFN5domuD/Y2OlctIpMfbC05sNy04HlD7zR5l1BilY5u1hee2S0STMTbHnhSmIQqQ8aJmxQO+UajTjSmtLC7lBA/XQkAJmdPTcPZYcNB4jbs5Kmt3kKKDE1hAT3EOqfI2fpxcCDchqHs3zPnuZpNd+hby/jnsFvek6wBzOkBrVWxlPqetv9xVwW2CYMAZkZyjybh2JukzjXa8rq+mudj1hdjUOV3UK8zx/7l0chwgNQ0uFfiyl+68ohMjTSeXv/S8EXjeQp5debehbTbfB+0wj+zIBbXKSCbpUdC91NkVmKlaYYw2Ze41Fo1qBd3gpiwximX2xshGw6XWR/ybjMjvT8rnXtuYYtnv8BJ2tuTgx5mf9omm3HC2clT2SJcrpoN/UjnB8t6QNQnWfohVhFtSB+U0U/DwQxr0AscdmdpmI0lMioUbvVWqSg8SPX4JEdvCHXO3JkRqx5ZV2RC0rBlTlpgoRtIfJOlWPaVvFIdFRly2dUPA8wklhV3vfG0oyUZLVV7YZR85YfcL5n2XZhktmVV2gzvoD/nXy4QJEKnZEJD/v5UPgZ5bi/nVcMs+0tKeR87ZIi0bDxAsOPiI9rBO523iVwu8IvnXG5N0iqaxod/i1WrwkOZ1IkKtygFr0rYDy5sSzp6MWmUgdfmKK40zXOxAZwU6bpCTNvM9gl+ycuPUJPRd05f8R01SVzfsGBJc
 Tkd4WuXx
 k5K3H4zJ942tLYVacB2pHq2Iam5m9QM7xcWYXWjEb8R19XDa4XTO3CqlpgWOYq1kxO9h5QJkqpMVxc8ZjAqHMdFm+UBk4MF898lZV/yUdBBNgVa/BH/zLCnqt6snXyy3dyMaRqWbdzHH9A7u9UnG+o0KvLKRQjGiBSNFc6ACkU7ojj/Pu8WhoOQy1/Ox2gExlqHMLmJ15FdnH8IGivL/06apaWTsM2JQj2+LonXPzzL2gmXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:28:26PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Slightly clean up the swapon process. Add comments about what swap_lock
> protects, introduce and rename helpers that wrap swap_map and
> cluster_info setup, and do it outside of the swap_lock lock.
> 
> This lock protection is not needed for swap_map and cluster_info setup
> because all swap users must either hold the percpu ref or hold a stable
> allocated swap entry (e.g., locking a folio in the swap cache) before
> accessing. So before the swap device is exposed by enable_swap_info,
> nothing would use the swap device's map or cluster.
> 
> So we are safe to allocate and set up swap data freely first, then
> expose the swap device and set the SWP_WRITEOK flag.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 87 ++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 48 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 521f7713a7c3..53ce222c3aba 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -65,6 +65,13 @@ static void move_cluster(struct swap_info_struct *si,
>  			 struct swap_cluster_info *ci, struct list_head *list,
>  			 enum swap_cluster_flags new_flags);
>  
> +/*
> + * Protects the swap_info array, and the SWP_USED flag. swap_info contains
> + * lazily allocated & freed swap device info struts, and SWP_USED indicates

Nit.

Typo: 'struts' -> 'struct'.
Also, using 'swap_info_struct' instead of "swap device info" would be
better??

Thanks 
Youngjun Park

