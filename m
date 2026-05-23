Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 801E7CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 02:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935476B0092; Fri, 22 May 2026 22:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5646B0095; Fri, 22 May 2026 22:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBAC6B0096; Fri, 22 May 2026 22:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 670856B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:54:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05A82C1FFA
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:54:30 +0000 (UTC)
X-FDA: 84797166300.15.FB59FD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F663120002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:54:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uyyShzcm;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779504868; a=rsa-sha256;
	cv=none;
	b=09HVLVaq7TcMTdlsRbxBVRV2SpPY4ccIOKMDx9xLO4o7ra/AC4HvjhL81seQx0ID4MZ9Zo
	mp3daGBgfxhrq1aLGNpf58l1fWmsovNc+FZ6aLpR0RvBZlsP4HeOTgsvwS6uvLb+z2gFrk
	rIdCvHWz1Kqq4EDQ7RKr6oyDbjioUO0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uyyShzcm;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779504868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cU3Mcwcb/DEhMKWl9RNUu7ZpFqR9yEGZO+PO2IiIYzQ=;
	b=6tx/PAwsJ7YimXrxVEGp63jZs5b4bgp4jNs1MNJxBeYp4RLJryh8YFNm3YgxcnAiANjZq9
	4rr3GMULXE1E8Avtdm4zAK0gelaGnOZfopC5+xrqJ7dMdX0pDI6KYEMNzDeBUn6NvEVVqw
	dJ37w1Xccf5RQyIt21GWaqJuau0KjOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FD93412F0;
	Sat, 23 May 2026 02:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A4E1F000E9;
	Sat, 23 May 2026 02:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779504867;
	bh=cU3Mcwcb/DEhMKWl9RNUu7ZpFqR9yEGZO+PO2IiIYzQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uyyShzcm1rM/m2X022NRZtJ3nKnAhFQ7m9I4qCu+RG0CmJCakfx7jMJWrknW2qYMZ
	 /g95N2XKrce7JmA3mbkpKkNhs+kt8/FzBDvw4ZMbHSWmVpppk36+fzPppqp3Gdo+eL
	 Po8OK+Bm8F9G75odeOyGs1JP06+d4GYfa1E1hjj8=
Date: Fri, 22 May 2026 19:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-Id: <20260522195426.6e764847f4c4dcbaad388291@linux-foundation.org>
In-Reply-To: <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
References: <20260520122228.201550-1-d@ilvokhin.com>
	<20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
	<ahBUoB15hHbIyZMr@shell.ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F663120002
X-Rspamd-Server: rspam03
X-Stat-Signature: 9rno13xz1ouh48r9rdsw19gezs5carwh
X-HE-Tag: 1779504868-604875
X-HE-Meta: U2FsdGVkX1/j+jZOFDp1T5k48jFm5CJ2rGZVC9KyRoJJSxlt61FcsXV9nfaHmQYJKxPEc38wGdY/yUg2zRXI40X4eRadJ5g9bL5FVpXmLB8DJA5JVX0TmGeQYGCFgZOip3UqBCIDkbOwBIiO3NaNf8zCuBPvCOZ1N+2vpgqQgq+evBw/+/Yph9o6uX7vx/Pz8x7bw6NkYbNtHIoWos/E+KFv5I2mYmyRYMXDss1E6U1nNSu4JJ20Isp6nzGHbvV4hAEv1IyytyOAFXSm4/EeLHDjoln38E6E0q3BWi9B2Zaf7ZSija9gy4qAFYO3ZfLNBhKyElVXMU6MNmqd9K3wl2M0D6oKPRuOkEFlCakOOxN0mEkPCRmZXzd1nCgGXiLWdcNtLEevrE4jmL6KUIIPU0RbA27zPuWZ/Jjepfty0tt9qcWKtprp78QF+O9wCLdHHjllraiFM+7F8mMd/vwy3jIRzdcm3Rnvuj2SbwiZSf4Z4h7w0OfoC4XqIbophScPtob6v4SiZfbtpWpGTDpaf8/MH2f0ojY6g5YHnchS/LhFwMQZiKzvMfk6Vdhm2XbU9C6klG/2BaWfUTmb/IP7AuQMOrk/AsZtScECaNJYTkcr6ani/gESDaB/PaNMdRkMdczFjmlCSFoaaUbS89Xj6Qtixt2c/8Txn3oWEjErfULqu+ftlN0sq43MHHZq29xymvdaZv/PXpqAVjMWUWhdD7P1s9dWAZpES+XQuqFVFoQpVagD/oeKkKRt7yBJ5usANTubvYvuzT5DUr3F7ydkURilnbPhLeaWA4WMjt/M56QUN8cMhvRCuhFLfbQhGl+rf7eCQsZlsO6xVim8lQo7E2hsF803Swe/X/MInoQZzcK0oQbPegQqYOWSTSJbFwnQMVFaDpI7tgGV8bYZ2O9sYjBz3QdRsXOo9vxG+iUJbl3GI6F63/s4ocaxD8mr9NeskLIYDdxicPW5ieFihwT
 irc6xB0o
 kMbJ+xYM4hMOmNhMOHJpp3fCEIT87SA9G8HKjz+uPL4/1+PTFQRLB3afyZFwOcZTq4g+esVMtInBjbwLjAYW89fjuOx1VA/VrijGsBwy3FJt9sk6nANWf63TuxlW5sXa+K/Vg0N1h//+FRhIBoQzR4GCIMddm2GG82LKMu5L8v6qVL3BdtqOiHTzcJjbQ9mv9STtQ5nXS41u1Ur4s+/bckVQfvhrZrdHsqXFWL4BZPwU8fzxLNM1skuYZD+AJ3JKO+wc0nTOjSnzn4TSlwJp2PmN8WNDLSeDYiYJvHZhpYj4uHTythz1RN2+mRqFmo0OTF3eD76oHniv82Rh7lVmZi3ILWtoIQr1TJSN1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 13:05:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> > How serious is this to our users when running real-world workloads?
> 
> We observed it on a few of the Meta workloads that adopted
> defrag_mode=1.
> 
> For the service under load there were 85509 SLUB allocation failures
> messages in dmesg within 2 hours. All of them are GFP_ATOMIC allocations
> for skbuff_head_cache, despite free pages being available in other
> migratetype freelists (~13 GB free).

For a single machine, I assume.

> Since it is networking path from the practical point of view, this means
> dropped packets, failed RPC requests, tail latency spikes and overall
> service degradation.

OK, thanks.   I assume 12 failures per second isn't a disaster, and that
there's no need to fast-track this into 7.1?

