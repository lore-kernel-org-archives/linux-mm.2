Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76066C624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2086B0088; Mon, 31 Aug 2026 20:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193486B008A; Mon, 31 Aug 2026 20:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC5C6B008C; Mon, 31 Aug 2026 20:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF2C86B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:32:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 651DB1C1BF3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:32:23 +0000 (UTC)
X-FDA: 85163316966.03.B6CB721
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8C441C000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:32:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2qXrlVs2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788222741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ej1c6AoFPjQMIw+5zOfshNKpOua/gygGA7jm7nCkot8=;
	b=d9/xUrJSWW8/Obs1sfT6fFShUQxbvrClWdWAilgL2pLOfngKknQUVp81VXMeZ/xFwGk+mJ
	dThR2euu8X4WYTfFp1x8OXdm2xAaCiFvf0EYgn/kPdB3DTDpIxdPzYB7OpMccspCXimKxb
	Gp9xF0mTRWPPFttqTYPo5RPEVm8KF0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788222741;
	b=vJ2WshUg2W6GySHmmJjEDXgLUqVqrDvZYHXb5XJHKr3FvG/ClqBGSWN6EMPLurShPQ9FV1
	36NeVSgxBZXT8A5cP6LmmZJOFvvfaKb54Y7LbYwqraRa92+7og8sDototUX9TU3lwqWkvu
	F85cC+WuxurlH7+GJhahsVLxgjcrAGw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2qXrlVs2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3393A602C3;
	Tue,  1 Sep 2026 00:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A224F1F000E9;
	Tue,  1 Sep 2026 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788222740;
	bh=ej1c6AoFPjQMIw+5zOfshNKpOua/gygGA7jm7nCkot8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2qXrlVs2fhXNgTqd2sR9uZkQ5O2Yslv+EERU+0QsDYkAkoy7UNb0+3ytgseHd6ILX
	 44/UC9k6O+U3nqBRr6VZhckZ8RHhPe4TCj42a/qgTFp/FKx5JrkNRA2SzydOoXaiI5
	 /ItHu84ouETd4nzWh/GoQHdYJEgkAMXUqrMIo/es=
Date: Mon, 31 Aug 2026 17:32:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <aiqi.i7@bytedance.com>
Subject: Re: [PATCH] mm/hugetlb: fix overbroad MMU notifiers for unshared
 PMDs
Message-Id: <20260831173220.72ab28190a44a305dacf4d04@linux-foundation.org>
In-Reply-To: <20260831091023.66581-1-lizhe.67@bytedance.com>
References: <20260831091023.66581-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8C441C000A
X-Stat-Signature: rxubi8sgzet85jbjdwx1uw5fxx7brb48
X-Rspam-User: 
X-HE-Tag: 1788222741-414688
X-HE-Meta: U2FsdGVkX19U6KQ4QtDD4Om7bN8NVRGRtRq6KD5yl7fqYPZbuKrNiKbdWUrzCwVpwptdMWpcG+KJOj00MLf9ZOttUrBFxgxlUXjFi6tR0v1xQST1HMHsaNI9koCz8kMLUuE/IejkzV6OhQq8dBgLtco1yWoJGsn6BhEvNEgwHfEI/TLF8tQAvp9KGNELm2XY/ODs+ySvAk+P/uNMC0HMrRNvIWsyFGyUHy2VsL6kXHFMOptykslNY+o1bZ7H6DnKGFT135RT32IL7xLGhOrp8GQNRODjWYZuM4cEu844cw4sDhk9J0PdAX/THhnP1wFn4z8YXXTDdMP2nllfmy4KIJdp8SD8q2sgoDjM2I3F85MwNVT1UiGL4rCGiXKf6xhL07D3zYJunn4pZtDtoxAlH45DxEjVLpbX4603OBcsfuscwexTQWXRFmTCe81Ldej8XpltwMfo45nQcw4nGILJyj8/xFnjimm2huXcdrmgOlsQ+EFoXUDVjnllrYRl9dKIWVAyi9oW6hlAK2wlDSwYamp9mi5kWHMQpsvSxDJ59LcxjeIloK8Z9bLvVjvMYq8u3fHCeVjb6eUxabyw/8il13WIF/Mw59id9YMgVryJhn1EydtUV+JdtfOBSANPSbFgRfQZw8tgGGkUWieE7g60GnONB8sm6Qok8uErBHtVxN7+GMawoRLa/W73n7WR4iRkac9nprGYaBUrDC7pvh6YqZn6zm7ozWQECH73Om70oK14QKzJ2ImVi1iGvqT9errZztXoGFEMSNApYkbbwBvVhqRpkw1l1FggN5SMERTrjOpaOOpXnvnXi85G2P5ETZFExlU80kbhPGKtAyAljT+tVWEHg6jQlnhJqi8U4ZFHysHzTi6mte3b1+g3HPXqS8KQESkah5BWU4xyJQqD2gRoLgotrTgM6LAA8eN7XHbdh14Z+XA5yxudzT7HYLoMO/VBKiz+wFGwNuWKKhYb7Up
 hGSQ0HMT
 6el3ICaWAFXtRtYmxlhQ+4YJfDzxF3BsYQSB5kjK39SboyYxX6FJaB/1zZF2rKqTNzf+kCINVSHHbN9viT25iIUpH7Y1d8gxnG7jFVI+iCbg1C8VieIzRWKzi/7vhhTrYibl2Qg9EINBKL5IyNCuqs1VRIFRdHwCHGBee4upK7aYUm1mDlO8Bnnfvbotoza9BLXNRvnPeurm1v7Gb/xrkXnlzeoPAIkgyO5sTPAbrQhmocOocQU9O4kwuu7A2AJTFiNcK0XGDb2JKYMXZBb38Jh79HLaQqZAtC9BedJ8GTTyhq2Xk/2JOPXQ2t2dLinKe3oPtd5qSEOBriOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 17:10:23 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
> PMD sharing is possible. That is only needed when huge_pmd_unshare()
> actually detaches a shared PMD page table, because clearing the PUD
> invalidates the whole PUD-sized virtual address range.
> 
> For hugetlbfs hole punch and MADV_DONTNEED, a shared mapping can pass
> the "PMD sharing is possible" range test in function
> adjust_range_if_pmd_sharing_possible() even when the PMD table covering
> the target 2M page is not shared. KVM then receives a 1G invalidation for
> a 2M operation and zaps unrelated secondary mappings, so the guest has to
> fault them back in.
> 
> Fix this by using the existing cheap "sharing possible" test only as a
> gate, then inspect the candidate PMD tables under the locks held by the
> hugetlb unmap paths. The notifier is expanded only for PUDs whose PMD
> table is actually shared, while the other callers keep the existing
> conservative expansion.

Thanks.

> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this
> patch improves P99 QPS stability while punching pages, reducing the QPS
> degradation ratio from 7.09% to 1.45%.

So a modest performance improvement?

This led Sashiko to perhaps discover what it considers a "critical"
pre-existing bug.

	https://sashiko.dev/#/patchset/20260831091023.66581-1-lizhe.67@bytedance.com


