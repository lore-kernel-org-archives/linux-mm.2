Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3C1606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r2ZgFIxE
Received: by kanga.kvack.org (Postfix)
	id 3CCBE6B00EF; Wed, 28 Oct 2026 20:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355AB6B05B1; Wed, 28 Oct 2026 20:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 245B36B05B2; Wed, 28 Oct 2026 20:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F31D06B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:48:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1019480292
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:48:37 +0000 (UTC)
X-FDA: 85373828274.20.54A8CBA
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1089340005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:48:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2ZgFIxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793234915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBKUF6AXFgaSWUb7Kj83+bMmMJKcRCg8xBUXyTLPZYg=;
	b=i62SFOq2rTxUPLpkY7ggfK/WBSiQa7BLZ3AaFAb9lxmeR7tBuv/jl6olAQOYPltYZoLUsp
	EJZdN4a4dxs9xh+TQw3kPbGcw4pceMHAsv2O1Mp1Kg/Fg9uyCnsvKtun0Cq+T0NqwgqH+g
	Bg7Fd9uta2ok80f2vygXMsbSHgPhlTc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2ZgFIxE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.39 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793234915;
	b=fUCMBvZCCJMOyWHqOFU/bXBItJy8466Wi3nu6kIHRQZ3dg3hluvHeaNIMmYPkKkTjb/IU8
	KVQ2G28htcwIF+3gfriUz/AVvupkIvCUeo/qDotbYwvTggGU1SYWZQFtlamMJiOF7cmF0+
	mNddrwKuD/7t71Ydmut1Se+bmuyuJts=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YzQ2Pc3WwUtKoWDSH3+5WqZrrR/yZR7jr8YByoE6Vi8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793234912; v=1; x=1793839712;
 b=r2ZgFIxEQRb9AtUouSFKV6VSKOIXUP2YOx2IHFPt/8gnhloT9z5A1CloHOOkRVYqgWUftXaN
 D/WK8Liiw/xy6PZddQDq0PeZqi+mx7Va9e9xD73gwJp0cB31fVpk1zehpE/3/yW+3sJIpY72n2B
 K1S22oh0jnVfwnjpLsTMZEfs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 469ed800a9d69200;
	Thu, 29 Oct 2026 00:48:32 +0000
X-Mizu-Trace-ID: 469ed800a9d69200
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:48:26 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under
 memcg_stock.lock.
Message-ID: <auKW_UkDicyxx6fQ@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-2-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028185034.3607746-2-kuniyu@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1089340005
X-Stat-Signature: i87rcn7grxs4pjt71ja6gp8j8mmsxzj6
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793234914-107920
X-HE-Meta: U2FsdGVkX19ujSDQGxyOhCQCtv3F7BiUM9N2LD6N1DXmyGBjecaQTbZJqZ5Wp/QcazqJvHcFZzdAbiHImi1OgHdcIxXpmKdvMfOw1QZQ+5lWU7JWYLs1bjkO03ThsClvFlVCDiLu1lidpTPDPhiDC/kny/Z0sHpwoarbEnRiczsgrWQfnXYq+ii5PLOjECBgbwCscyWYVJVkxnUXUXCga92++HpmvNwm0h3IBB0eqPlN0sO2lMGld8xSTi28Lw+utkatzhWrX11XPkpaC52de9g1usU6Fh//LMsVjlibwPKLvvEzbzNmEb92m0bJa3TFu6rTWvbd8hMLHtc+iKOGh0rr2XDUNonS2lBZsDLXcbF/W9UJji9OE9ua6dyz44j34TWM7y6k3y3ff2ghIRfL/xSL9EgrqZGL8G09iPeop9DqDB2YxU82eu5cKdCT6raHuWjpOCRQfBL6tRmHsREhuhs34KTQpLZz2XXto7WYNrXMsSNWwDabe7lJUSHisCPFDhuhEresyCMrN3ni/otUiQ+SinYqvN6jw7scUmKfvXcstQbPAo3lKb7CDe7lEP3Kro/1B/kdR5zKMzreVtnZWp61VRciInJ45lMVKGWXew6UHFBw/nJNbyybKaUTyco6A4QBmXRSQsUnO15qvEAYgZjASWyimbDfEvh6KlKrYVJGK7EjnNLhckrSCbMyPDIrqx7FvtszQngnxV01er3HEyo8YEpCM082E62NR7bv8tQRd/Kk8vOkA8NUuP5cwv3SXbm6RqRt821iDDfA4RkSgHC3D1lJSQy4sgBh5CCC6Sd1aoI3PLwBRs7eqClhI17j0/0Tj4ns33/tsPbu0bwdelPQPiJMS0pWuy3ExGHPwJY6/9g1B3CS9sklj/OYhedTLl1dn/QXwSasr0EfuXp1hgBoH5z90AepvbwiQSkE/T1x87BKVOOJFfbKgAqqkA2mSrcWYRnSNjI9JthEvgQ
 T228Gt+9
 myIqZxHKTg8UVD+Xrl/zsCTXsJbrQ8Y5XFZCK0JmZY9NpPhXypv7mg7fRaedaIVwya9OZkHaephlPRbHGXTMA0+4jtK3xzfeEXVZIT9ubiJxpD1CwPTIjmwwBc6TaH63+9ylp8ily5q8HO8s4WiXoC6bB6tWbsJoLzoSl9JOC0auPUctkxZd5Udlzsy99DPeSgHAolFZ9AW7FEiYKtMFCMzDnh6Zxdc5TXyGeRiPDtPuErI0jIhn8EIO2JL65nkf7mIFQ80V8YNL1o/m64W27MNbLBJ10xofebXnHIDqnVwb7hlJPhKeE2MKO+EAuYjiMejRi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 06:50:13PM +0000, Kuniyuki Iwashima wrote:
> this_cpu_ptr(&memcg_stock) is always modified under
> local_lock(&memcg_stock.lock).

You need to be more precise here. Mainly the cached[] and nr_pages[] are only
modified under the local lock. There is flags field which is being modified
without it.

> 
> Unlike is_memcg_drain_needed() under RCU, consume_stock(),
> drain_stock(), and refill_stock() do not need READ_ONCE().
> 
> Especially, in refill_stock(), READ_ONCE() is used twice for
> stock->cached[i], which forces the compiler to emit two volatile
> loads from stock->cached[i].
> 
> Let's remove the unnecessary READ_ONCE() and eliminate the
> redundant loads in refill_stock():

What are we gaining with that? Is this measurable? With READ_ONCE() at least we
are very explicit that this field can read and modified concurrently by
different CPUs i.e. better readability.


