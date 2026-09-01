Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8BDC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3CC6B00E1; Mon, 31 Aug 2026 23:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084526B00E2; Mon, 31 Aug 2026 23:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8166B00E3; Mon, 31 Aug 2026 23:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1FB6B00E1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:39:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 452418022E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:39:45 +0000 (UTC)
X-FDA: 85163789130.26.B15FA42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 77C5440003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:39:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8TuZ3sM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788233983;
	b=bqXuS/aa2r25rXun4jkmUDSC4oynnegOKiZbJ1cVQToF+H1LolkJgHEi9zW68NS5/qeOwg
	4PnDIc+M0K5pBgIfLSszrIhjtdrtmxKfQPJe9RGmvIPaHH+bEDaU4EW1ev60iuxlR3cXQX
	oR8iJbdRG550MUhI/MZmKYRaJRS1UNc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788233983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/VdIQLDigMrM7krqqQaGYUq1ryWMzorWYseQH/iXOM=;
	b=oo+CcV5QmCJKMpcoPVoPH6TTHQ0aucK0C4S4zGk6AD7mDJAL56iisvbeqAj0h/o96YE7k1
	Eb1m+FwZXwPYogsRfz9mWLO+C5IkYIG/1o2pwNkgraiFIjRnIh6D7DJ2oFk3u6X0mWQuRP
	OLHGL2R/XbD8Q6yt/uF9nU1Fdi+JDm0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=s8TuZ3sM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48FD2401EE;
	Tue,  1 Sep 2026 03:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF6A1F000E9;
	Tue,  1 Sep 2026 03:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788233982;
	bh=a/VdIQLDigMrM7krqqQaGYUq1ryWMzorWYseQH/iXOM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=s8TuZ3sMsrRpghZI9kxLPKwAUVdjRcqEKdGL2Di6vTOV1OvhiapGGrrfBi7LF42Jr
	 VEDNeu9y9aekgIegPW2vy9W1t+RxkKnLWDLTZlWctGjQ66pDWJgSaddgva8snMpyON
	 PWM3/ZNw8hXIBbY+WXSYx4ovLvoq2GZgPWEEI/i4=
Date: Mon, 31 Aug 2026 20:39:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
 hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Subject: Re: [PATCH v7 0/4] mm: avoid large folio splits when swap is
 unavailable
Message-Id: <20260831203941.0ba48ca2d794d6903d232e5f@linux-foundation.org>
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77C5440003
X-Stat-Signature: 5hzdgxbcztp1qxbdyx9eae7bymjz3qeh
X-HE-Tag: 1788233983-815939
X-HE-Meta: U2FsdGVkX183qEZaBbzBYVGQovHi308SlNImpseLEcfze1/U6esUhfew7HEdoW1xGQWkKVpnHZYUmm8CgTYxHw5Xr8WSWTaV0hfEun2o5jekIjHyy9kblNHUQLZG7wpmxW1/ko27+2lNi/os2QYM4EkpFEIFzWCxsF2X8qbZyBMAB/hAMBujK27xl5t1Q+xzo0BLBATAJVzLiw1UdZRJ268MtL4QUL+XKsJGTH3Amfo9WmfOPBHRn9/LHjko2iHGONDmkF0rMuF1OExxBfOrvozaDDcg6cDW1/HMr455cplsAbhdelILGrTf3SowYosHUzxAth8C01Adbh5/7myD2MXgF2sflZwgrd8a8ruXoRf5Z920JtrlO+AdY/M1jW1HdwMSziBQxSzadPSnTkHVxoguSKgUfX3PYoBtp+K7MLSXS77RLyOMu2z3zHaH0ZqMZ9UgiH6CgBK5B3JzM79r8LA1o26l1TejXYNfDaciIPIT81e0JFvpQPuCw+D7QJEqT4XHs9+DOqkfxK8kDobNTHUmnntqp6HXCrU18CZrwSxkihklDk+xC1y2tiFKTAHc1k1eTIhfq2R+Qt3OEZUm1ujpk8Jgqh3AuOxkMT1bCoF2l8kKSOuMVJtHZ8WFqw00NIS7qLyFDTpDsPXrqAEHK50L7D9qmVOOCL6yxWJxLBuhjEIBk5Oqo+rmfsvKwvAroUnQIb0Ue/6bvMCpQYRl7JqU3dcqt5wwGV7n/LDFbDVF5BF/4w6oAZhiu607JSXZupKKHOgfV0pyK23CuS8VCMjY+Qt6K0d0oLTwaN1tmxoeIcX7Uyjb9pzENHF9pyB6xO0Ev1GBNpQyd8UgXUTT0iyU3XRyTs11L+3fHKcr9Szyjg7pTYszf5bz8WIcEJqcOxAkaL5uJpcBHhTM5PsVLsJzl0SM0PoRTv00XsvNCBRY8jIhBryumKMk/tengOg3GQ6fl1Zg2d7t6py0Xe0
 5rvbIXo2
 r0L2nwt1sIBEAZ82OFX7yXB29Zflg8jZBLLPHDpyrZDk1I9WAFQ47AeAYfHsNWOxL1NJiajnErIYbSsGZJfV2Xhtlhm+rw6Azbazmb16VXm8yMWDjAHqAjC6aMKzB3vgNxeA5w80AVVxVOYMuwr52j4Y78zgjze30lBBZxSQb/SnkRannhFsGZT3TA+JwBXMRVKXjlMON0q/5ccf5STx5/khhQTc0E10mGImoJmXIjfWwrXfZFyiZAodt2RlgAmvZkejze1SXpZVVGnpIqxRLdhDcEu6Oq6eF58Lh4Uvzvw/p/9auAtiM9itdJBpQIwVJ2kPQKOFuyd4l420h3rFqUM0qJuKO1vv3zCJUY7m3TaA4rqMu8lcc3BnC1GqUPjStHYxd9fszDtH6Fa/8pLvm9LTDcLOcYLAX6U2LdWPCMKk3S9mQFprsDT8uvc97dzcoWvzg6z49uK0PcvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026 12:29:16 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> This is v7 of Barry's original RFC patch, "mm: Avoiding split large
> folios if swap has no space":
> 
> https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org
> 
> Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
> large-folio split counter increased by 1024 even though no swapout
> progress was possible. Skipping the split in that case kept the counter
> at 0.
> 
> This series makes folio_alloc_swap() classify failures according to
> whether splitting a large folio might allow swapout to make progress.
> Callers can then avoid destroying the large folio when neither global
> swap availability nor the folio's memcg swap hierarchy has capacity for
> even a smaller folio.

Thanks.  Sashiko had a question which didn't occur against v6:

	https://sashiko.dev/#/patchset/20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu

