Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17755C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 18:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B9C6B008C; Sat, 29 Aug 2026 14:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053946B0092; Sat, 29 Aug 2026 14:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC006B0095; Sat, 29 Aug 2026 14:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD5A56B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:16:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58EFE80142
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:16:26 +0000 (UTC)
X-FDA: 85155111972.16.A90D468
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 807AAC0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 18:16:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8FkMU0e;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788027384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANn3dkxv4l6tBre7EfHFtYBd4s+4pMK21CPn4TKtlP0=;
	b=8fXBwxxm0ZOSak2eyRSybq3YMIK8wwaFpxcn854Uxi5LXei+LTjIQVWgYglXeDMItwX+C1
	50XInpdqBdjfnVAMLfmcY2pZXnxkU0TVIu4J9P+KfjtLh13ROBXqPIM1+IdUpbwNvgrN8J
	5KBGYT9rVNKMJZ7UEqve5JHHklubzNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788027384;
	b=xka49Uq7oqkIaLQZbGfuOcwU/iwY5z0bbdukfLXFJoby5ZnnUfT0vaQGzrMxOZGOPO0IVo
	XaR/ZRpbF59gRqFp7ZYQLUxFJe+oh63le15HMHUYVVGGwAKy5hwJjcFFV+lsNpRtc7gj73
	U3HU0+uL68bgmkhJQiNEOO4Nse53xhA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8FkMU0e;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B44DE443E1;
	Sat, 29 Aug 2026 18:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477AE1F000E9;
	Sat, 29 Aug 2026 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788027382;
	bh=ANn3dkxv4l6tBre7EfHFtYBd4s+4pMK21CPn4TKtlP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=s8FkMU0eJdSVnxI8pv8KuXVh74oqlbwsnk0swYPtcopCFCTbk2lXUb4VJJZpx0pwB
	 bEej4Qq0i3wF5woKSp6muVsHDepUyvumzR2Z06v5GkGb5ZNz5UaARYj78Y8ORXPvGk
	 KMFH4Nhj/BptQJMt/ZH5RoQVpFUKV4ewlqV1ZKhI=
Date: Sat, 29 Aug 2026 11:16:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
 axboe@kernel.dk, trond.myklebust@hammerspace.com, tz2294@columbia.edu,
 qiwenjie@xiaomi.com
Subject: Re: [PATCH v3] mm: filemap: retain mapped dropbehind folios
Message-Id: <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
In-Reply-To: <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
	<3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
	<4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 807AAC0006
X-Stat-Signature: 9gnw1dm7w5auws358rwoymy8dbx41uq3
X-HE-Tag: 1788027384-319901
X-HE-Meta: U2FsdGVkX1/EDcG23swWq3B5meKsh7V2btgfQGHIzgNrGpnmuVjtcF0Gsk8e3KSy5I7Sxhe8jv42k1qRQnVHldU/00DC/cVLjVU1XUcM3DQCVFcFLFfZzsx8LXnT/BMuVw3xrZuh5s2KyRnGwK5przk9x9XY3c4k2GfrWVtvB+n+Gye6+nI/tMnN0at/IdErFe7spmxP/EG6W8BZ095dd2FURQFyqT/Ecm/Lv+jCg7AtratmBu0vm0Pbq1qEVWdRHMNaYuKgYlJ6m8j1gYP7DCxgkZe7PHYG2G9yDXrW2cECEpiT/CGh+k/1PCb19dBMb7KKRVvGZFzQZLJ4IqhczpayLDcGK7QscM/AeF7kGuOW3/1FjPIJ6dTj4O3LiI6SwAJ4HM6E8uDDUNYF2sXa9F+4fRrbYsauWVoKFGHaPx/xPXiV1Pb3/mNm6D3Nez12fhxVfLclK+BXDKAZMppGhZXILBO3ELCzJZNIYTr1XDLhn3ULV5z75Lf0LOah8E+eQR2X4te1JUA2loxiBz6He9+YJ+ALZt2pQnlC3KGxCJ1h6ZFi9ZID3xQ/0iy5QC8pGK2EL3VOwp/pbHU2ULpWDBZVRcxg1XmMN/YC7ew3ekVQSzsdskAHo5RDvkOiKAdeOxj4wsCHhJYnZwID8AS0yOdZot7BD5ahhLxkfVuZqStIQKRvayghGuWcu03xkK4or1omdwn6uGmcBr187Ypn+Ver2vaj5+VjKqbo6o6Ai/x43bnlQne9m3EA8FoJsjJ0j1M3ItJ4RSHYEzZ4feqPsxobuOqYFK824x9uHAVYQwj0o8dY0ZpM1Tc8dSuQ9nwZlXEoxWMPm/Q6/m28TnsiFYTk/HGfBi/gIqbHo2/8RZKsPvd6fq53vGpKJR0OrVQvUeDzysP04v0MdB0GYP0VoY2P4iv6gJjxFUEMrCAyp/xWdRu5P7kxXun6zFAsVb1FfVGkje7MY7An8nXM2EY
 hnULq5pQ
 kE6MZ+A/IY8mLbBX3QsghtmWaAdDj4FLvTp1EdWp79e8oVzTV7XKD2xxAQ9YwwW7uKtoegHZNsicDUDpKwXIHnuD4uSlX+/QdPIp+z6s99NEBqtvj6NP4tYR9Gl/HDa/XZqkR4s9l+oJtNDAmu8qrQ/3iTAMZaTD3HR3nzXOjz3h279xCmMQwqegxNzwMJ7mxmR0puzo6NxK5g9MGJ5GUYqp3/6jqWOSA8LzVH3wzWPqW+6GkD/14BYLxDhKzyJ9S/tNMY2i/9a4ai/miRRltqo9wy6XQyI9u4SHTOp9V3plXuqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026 01:36:12 +0800 Wenjie Qi <qwjhust@gmail.com> wrote:

> From: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> Fault-around can map ready dropbehind folios without going through the
> normal page-cache lookup that clears dropbehind. A mapping represents a
> competing cached user, so retain the folio instead of forcibly unmapping it
> when writeback completes.
> 
> For a mapped folio, folio_unmap_invalidate() can call
> unmap_mapping_folio(), which takes i_mmap_rwsem and may sleep. Retaining
> mapped folios avoids this path when folio_end_dropbehind() runs in
> non-preemptible task context.
> 
> Unmapped dropbehind folios continue through the existing invalidation path.

Thanks.

When fixing a bug, please always provide a very clear description of the
userspace-visible runtime effects of that bug.

From the above it appears that the current code can trigger a
sleeping-in-atomic warning?  Has this been observed in any situation? 
Is there a report?

chatgpt easily prepared a reproducer for me, which I haven't run.

If I'm correct in the above, we should backport this fix with a
cc:stable tag, do you agree?


