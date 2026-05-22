Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81DFCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9F06B0093; Fri, 22 May 2026 09:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263DF6B0095; Fri, 22 May 2026 09:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151966B0096; Fri, 22 May 2026 09:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05A716B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:05:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96D6F120710
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:05:40 +0000 (UTC)
X-FDA: 84795077640.28.B327F20
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf10.hostedemail.com (Postfix) with ESMTP id B18ACC0014
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:05:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sKHXenDQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0AoB6rD6l2HyYJa0SvFBEFRIJ8h5+fvRSDiihzR1Fk=;
	b=t3/rPqnoEA7nVbQkL8sbWWSmHzUfr+IKcrA0XnwK4HuyLdp+4z5ZFdznAzIq4LIOB1RIEw
	wbERBz4KQBt7blrxF2NIhCJ+3qOO/HTIPJ6+6Y6tTDXsG5rTWa6OpXlYKVttkXBaapl2pJ
	LthXDgqH9JhwaguLdvZSHpkk4aZ/qYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455139; a=rsa-sha256;
	cv=none;
	b=5VpLD6lXog+cO+FUGpHOa5XY+2+WPzZLkJvc36xUcjjoFgQuCrx1ojjnpADBcbjncfM+0Y
	DnaDSFk6wSDBrXTu8eINgbIbAbRV/3bWZCa522BrkXzZDPK0QC2Byk7oqSLfCZTkjM9OKl
	Bihd3vuy+Ne9gfvfeRqniU+CMPbD1SQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sKHXenDQ;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf10.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 31E60D0A1A;
	Fri, 22 May 2026 13:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779455137;
	bh=B0AoB6rD6l2HyYJa0SvFBEFRIJ8h5+fvRSDiihzR1Fk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sKHXenDQWr15XRUPNQRrB4ihRSeB6uZTbwIWwfN7vy8LbCu2k1a6jRboQFL2ujjMi
	 n3fQFioeEypYhS5BxkfjLTXQHVyZSRsJwfhVV1p63dgkpvTE/eJrcvMr3gkNc6HsdA
	 RYUiZQbnLfGxZqPbs+scBFptKX9pX6kvhxhXz7xc=
Date: Fri, 22 May 2026 13:05:36 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
References: <20260520122228.201550-1-d@ilvokhin.com>
 <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B18ACC0014
X-Stat-Signature: bknsnwkpp5zzfygdpedbixp8gsmawmzt
X-Rspam-User: 
X-HE-Tag: 1779455138-641976
X-HE-Meta: U2FsdGVkX19/VKXMvduGaBxqdl2ID1O7l5apLwEErQLOxuQpNrqAuKO5J1r/Nb26yyqkGY8gR44WGXfgUySIps4Avh7TBItSbfLHY4SKh/D2VPKmsuGdUIDZn8444z6WDIlEYBex8iBLyz2E3ICh52uaiWnk3LqvlaxoCYIaoCeRuFb+Z7YLbDHwbHUcUqatfjS9kDhhGv57x5Yu92OrazrLmNO4Ca7qbh4eouMsZQjJrLYs2wTXgRrpRbRALw9gsUV9CUUhNOOPumMmMYQD17lIWUz5OFCOvm4Vpj7ihZooNjxKQ6o1pKppH8CPKFft3XohiBzdv9+FXxu8ooDMIBiK8c2Mj/G4/apaeIUKkBGcKL3T5459/w8f1HCwQSItfZRIWpca8wzAzMWM7a0pdkr2jGpQIELEKORLdK9JLnpxwZO2c2fEj6Zj0WUMRUgKjJpdwrR5wYUkvg9EkOTkbnSDATFFbWJV9depZrcEkdyAGS3kHrB0TsptidtOLDtFeAnFYzTNO2862bv75x/AZFORHT5iJgqes6CpMvNvfowYcvbB90++ce4/aqSuVxYBiRf4WGnPJK3vEP2MBOimcCW8V20gZccRxn9gwTLrEqDfnS/KBtzFjK3X3g6VVzX7m4i27vyK0AYy0fJjDVmyKnUx6Y4Hbu8d8CATF/w4ZjwPMuHO7hyme5iFQ+K2qk+D0DEbAXKaw06mljJq7rDPVGB6J3U/SMDcnz2mdWk8HbMoy99t6mXk8zruRiOzhsEtXUb2R5pmYd52CNsWf1rLplPeB2gty30yZ+6GV2RVkWHm5PM9LMyvJnmaOeMVfCpnGzeJ0Fc4oJb5oLZPkch08Icza4ZPYeHcU/KoJM21hPcd74cUdM590LLIo+Sf1JWg6x0ELl90gNBLw/XApS/i562GLoLsxvI8Iz3jkKzPr2WvKiT7AhWks0jqwLWBzJZt4+OcvLMLcoCpdkdtO6a
 zUZXeDyM
 QwDCylPbVEsIdIJeuR/8vbV17GtiZFz52AaAek9NldVWSBuYF3LBtQLgZUoZjWCPQmpwLSWWwySvvlG4FfzhiqEpABx/rrL2Jxc+jUJntmicGx5VTjneKpHk69zGForFW7vZSD3E5bWuHUlFXMnbIo3mU2gdI1Hk+chmt596B4jJPdDuf1YwNoHrWtazOh/894dhpfQR/V64qVUGEA3rfZLumtJliEejRhsiJRW8zYGrSt6eO32qHXL5z7hwUfuCvcKW4raG8Ti7vMYPy0oqhO/M5cNa8YWA2wdG7ZLWaqYPmvR8etT5KmC4/lPekTgqR6yYs+y28gvLzOhyqv9Sgwn4GDyW7iNtTDAlSfseUK8U5x1fb6MaYs0v38RsDRuaGd3Bh2S9GArQzv73ryBFedXJE+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 04:59:10PM -0700, Andrew Morton wrote:
> On Wed, 20 May 2026 12:22:28 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> > migratetype fallbacks and keep pageblocks clean. The allocator relies on
> > reclaim and compaction to free pages of the correct type before allowing
> > fallback as a last resort.
> > 
> > However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> > direct reclaim or compaction. With defrag_mode=1, these allocations hit
> > the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> > ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> > 
> > This causes a large number of SLUB allocation failures for
> > skbuff_head_cache under network-heavy workloads, despite free memory
> > being available in other migratetype freelists.
> 
> That sounds painful.
> 
> > Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
> > reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
> > speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
> > __GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
> > fallbacks and should not cause fragmentation.
> 
> How serious is this to our users when running real-world workloads?

We observed it on a few of the Meta workloads that adopted
defrag_mode=1.

For the service under load there were 85509 SLUB allocation failures
messages in dmesg within 2 hours. All of them are GFP_ATOMIC allocations
for skbuff_head_cache, despite free pages being available in other
migratetype freelists (~13 GB free).

Since it is networking path from the practical point of view, this means
dropped packets, failed RPC requests, tail latency spikes and overall
service degradation.

> 
> > Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 

