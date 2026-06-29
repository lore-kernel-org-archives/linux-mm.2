Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54C2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09186B0117; Mon, 29 Jun 2026 11:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2656B011A; Mon, 29 Jun 2026 11:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8376B011C; Mon, 29 Jun 2026 11:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5F56B0117
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:44:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD7D41401B8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:43:59 +0000 (UTC)
X-FDA: 84933370998.25.A7E8F84
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05A78A000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:43:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdPYxR5K;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782747838;
	b=1PcHX13huUvIC41e3XlPeuWWVzv9j3Y+cVsPiqezb1dnfqrp7LY7aCXXJL+Sx5AZ9mDEzP
	BYukpekEYZ7BIyLeRV38iHkoMjdn9hHQEiBoRXdEm8R0yqa2KCXpd6vZ25/1jkFDbFpMJI
	7TH81KWifq+Tr201E7Cc9umOOK2vd64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782747838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kqyBkissqm61SxYgWJgAGVBgaWZdVQaWG9FdCDYB1o=;
	b=OLjg1ROKB4NrjnqiJHBLPctEzQymAQcHIvsbGiCqUVBxaknlaRsnK6gsqWM8f5KuxefbCh
	15ZFgW6tAc5SnG2xSm9EYuv976aBlfitBzu+BaqWMRPzkHScWq8e6T/yoTppLq3iZCXh7P
	e/GhF9d9wHC7A2wx2QLo4GPwQSWhHCs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rdPYxR5K;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 29 Jun 2026 08:43:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782747835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9kqyBkissqm61SxYgWJgAGVBgaWZdVQaWG9FdCDYB1o=;
	b=rdPYxR5KAi6jd6uLloXxh2yrSkwe2NgJH0C7Jt/8qiMYcDJt/kiZ3TOku4hY8tVQNSwwg4
	Ir3K0lphfJfpAbkJNRTg/RTZLupVneuPwDbfLXBTqiKHtlTkefiQYu2f2aifW5rSL8Qlgq
	fM6VgMPEFOpelTaFrNkOk6x6//zqapU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: remove the redundant FOLIOREF_RECLAIM_CLEAN
 logic
Message-ID: <akKSl2Azyx-pGOjH@linux.dev>
References: <def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def70a713e10bcbdf3b9fccc2139ecc07b64f2cb.1782715791.git.baolin.wang@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g1xeaubo1ypfeeu4uhdk5chusbuem946
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05A78A000C
X-HE-Tag: 1782747837-46186
X-HE-Meta: U2FsdGVkX18g6EvYCEZZk6qPsTWPBWLSoF/y8ZYSsH3sXDvJqQfC6HHMs0mLqu22g9WSmZ3Uicp5S3DwHfA30QjME+J8p/SBHTQUQM23du+RLWO2eibBn2F8K+bUbutXjey7jmP805ZwLULp9Cjgb5wRUMy3dXnbHrYr6SPRXray8iynCcS9XLXEbteUJ8fHdS/DxuoxddKovUZBeeM44WZTl4qjnknnDhWuvH5DI4hvjqIR20T1csxQIiN57O91rS/BsfuBKlctP2dMd/cUYVsPtB9fBO2CKIeaRLYEbX++KrejGNwkjtb7ceGzv6OW+YaJU2QPnuhiq8caxSomrvqvbeFTviqthteRzkFd2+GPEvGZgmpu2RF5P2u/dQuK2AvROcLb24Z8wjyOTa1z1Ca1PEPCtmwnDfuAvBjir4vRkiXZDUrzBVer+hn0rvxuAtYthe8dMedcFX6uENgXFZFdBtdyEFxjXJKzv2z3eA8yzDCK651O1JsOWfBgU2jSWz7iUupOp3hezgxUPQYrA8dC6/RbMlBYvJp+mX5HHQxL7S9R7bjPtWe+jWjExahF74E6WaBHj/dCD0Lkfj/RO6/yTe4I+k584WKV+BQ4Nuzvu/X92jKhB/tKzraH8fyA6y3Tqc04Ro8bwO8i8adHbv0XkRNrQ9iVYRkfagugtf1hDeSq7mtwbTZZyZYzA60l71WGzgB/onk39zVohY3sR6pFA2PfIxFS+vqCDLQtJa4gpu0U2r3vUZOfGocmXPBl1qxzNAaHuqYV/wnJvFFmUPEV98wuwqxyqEGDfD0l6PsqXknuHkpz2GFEgdWR9QuI491ylbgqCl/9uLnrUB7u8eahvH/B5s6GhyQrseVmWQbWnXPvPiujXRngcC2J2wzZujuIZ14Y3KpgboRnhmRwY3zl2dq56hrZXzqs97x2Okg5nrCMZxh2eYj5DQvgWAPW0GKf25ftl9pZkBhBrSQ
 AWKRD8qe
 39E91WT++mM0H7HLOUQKfhBkWV9kFt71YIGaVsMzJ3ojbE2jeXOcxbViCzXcvYU6x2KmA85Arf/BljpkIleiKqRysKZRqmwf2D2mFeEdrZDdnvhsnsESj7pYXsTB1YCwH7LroudPz12dnJdLSmlN2kW/i4HUb4pG5lCiCbl9tXnFljVkUkf5UkmqX9KcbH/v5LHHyYlzpHG6SQpy55lYxN72cXjZ2CeqLvmIdPq+lQUzNzSymTBf4Qg2NdJ6sA42P0mRcpSU3HtaP6wBEwQ6gvgyJwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 04:04:06PM +0800, Baolin Wang wrote:
> folio_check_references() will return FOLIOREF_RECLAIM_CLEAN for referenced
> file folios, indicating that we can proceed to reclaim clean file folios
> or keep them if they are dirty file folios. However, after commit 6b0dfabb3555
> ("fs: Remove aops->writepage"), we no longer attempt to write back filesystem
> folios through reclaim. Instead, we always activate dirty file folios and wakeup
> the flush workers to write them back. As a result, the FOLIOREF_RECLAIM_CLEAN
> logic is now redundant: for dirty file folios, we will no longer reach the
> 'references == FOLIOREF_RECLAIM_CLEAN' branch in shrink_folio_list().
> 
> Additionally, lazyfree folios are also placed on the file LRU list, but if a
> lazyfree folio becomes dirty, try_to_unmap() will fail and thus prevent reclaim
> of the re-dirtied lazyfree folios.
> 
> Therefore, we can drop the FOLIOREF_RECLAIM_CLEAN-related logic.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

