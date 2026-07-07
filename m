Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5001C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C50D6B00AF; Tue,  7 Jul 2026 16:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B946B00B0; Tue,  7 Jul 2026 16:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1CE6B00B1; Tue,  7 Jul 2026 16:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 505B56B00AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:21:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90604A0582
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:21:41 +0000 (UTC)
X-FDA: 84963101202.26.4DA7AA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D56F320009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:21:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FbaSNUxB;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783455700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nh0WAl84rc5RiNO/PWO6pIH/7oEsYwzwMSqG4cyv2M0=;
	b=XKsKhekQYp6BfEvptP1k2mCo/IuXrnFpILcrt2Gt17ItlBHRgbcN/EhxpEnl3DEDYMr0/p
	X9O2Aw3IXuwJUL8ViQjW+OGVxIStMm3Q8HQfYh8h9TBeNCarIwfT9574I9ax3oWWvfukGT
	KsAzOJDUJfjTis80DRWwhhGYMMNzYas=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FbaSNUxB;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783455700;
	b=xaS0a0QnVO1/rTYorEHA63CrWrxwaq8+7sUkto+ckuId1JNd6MONgvPfQJTEJq/zyUnk4o
	mIv4B0w1QZed/V6cwGr03cTP2kjqGCgIAEBO+muciE7qzxruWnkS7DOHWN+PNT1CYhWa1i
	4J1/q4E2HzdR7LzlwGabeZulDsX68W4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FEBC438D1;
	Tue,  7 Jul 2026 20:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77DA1F000E9;
	Tue,  7 Jul 2026 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783455698;
	bh=Nh0WAl84rc5RiNO/PWO6pIH/7oEsYwzwMSqG4cyv2M0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FbaSNUxBzw0hzAhsaB7oAM8R9ROlE84dlL1SDFC8ZZEtmxO5+TRhp7Is1cdfzApsq
	 lHQP6Iiz2tAd8J2aRU12IZMLHuwWnCft3Ddd0sPObJk7DENYXqZMaUNd3INMC53dFU
	 HVUhXOdhXgw0MqF8dhJDW565Yuu4NW/fvxCHGx0k=
Date: Tue, 7 Jul 2026 13:21:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wupeng Ma <mawupeng1@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: fix missing migratable flag on same-node
 hugetlb migration
Message-Id: <20260707132138.d11a3a759bac55ea5f0f8c22@linux-foundation.org>
In-Reply-To: <20260707110254.3147686-1-mawupeng1@huawei.com>
References: <20260707110254.3147686-1-mawupeng1@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D56F320009
X-Stat-Signature: 9uxk951usb7cysnhu8kdu4sd7jxzzky1
X-HE-Tag: 1783455699-184688
X-HE-Meta: U2FsdGVkX1/LcYVoGCoqykoY0PWaMOWTbAXASO+pJGcLODvfMU8duA+opAamkF2hVbNeCDHsl5ksU4pow58zd2b6ALJ1YZVFvvnbH/6uQoQAefaqryngzFb8YD+whZr/sBIQd6yRkjF4iikdkH7lEL/R8FwRHpcyBpKf1sOQ/jHaQAFUkyz3t2DqqTyBK8vjDNArREiiyXF7/AB2y+6LwfhCBtmGQni/AM0myft/y9z+fMXClDUWvbeC1zWDBSujKu77RITi4GrwqrWbTpx2S1NzwLEFsnuwyvQQr1Z1UcZIscvUI/5uSWFCJMdNHfC2+ilVMsqL2Zof+VjQoS2TT0pXmDVjGej3slTRAN7wp+AgnsWMdB6Y39LP00geWluwJaMNudQDjaK4p3RPB6HsYyaNgonbdqV5x9PQZHF+J5ANlEUmr/terc5pbOgx8exvG03uaqtPhePiKqzdic5JWpA7V4xy9FO0vrgzCFrvavUIsKCks+g3PElpymV/UbtIpRd+JFEoBc7jVcKh286DkIcPRUVLA16F55ZHxLDwR0u+Pf5oWa9HW3W/hJK/naXCjWKsUVleEvqQt/IaHv0YROSPUlYpA/xfflftGeTmhXWbJwr/llc4sgX3lVmzGgL+O15X8mVM5hlMI3ALmzd+cTlUVJirz2TsCa9cBVJkRDiPbRjJtvGRSkFkVoTM9oaGvnulNAdpFTeYpdztk4Ra4GES/KXbrxvRsXKKTy2P2dc9AGeWQEtSRy6V/DDchqs1ECD/48MKodsMwNg86gE8VsZn15mJlqXZ94JW5O1fc6pgzbFIyyACG6xD1/q00lyP6jKwpCAzlbnhGbE9iT+x4ktLiKahdyhICioMX28s56GznElpL0UH2tGKj10skb+dbDk0T09R8vjXjOSJF4vzZW8yvoNnXeQRqJgqEpB6GojBJcMpON5TyMg6Yy5snQxoqDbWbiciMzVvGB+Ct7/
 KCo/tl2r
 pPAj+b6wwa74meKQEAppxDvRGnjr0ytB78aPEdisRqmnfR4pj433uSgJH/Anpm5R6bpwI87BKDPTEAD1ukSUoj01JSm0dEOWhgTDNqzlJRN/0wpwcUOjOKwUeFBhmLjOhhvrhB40qsCa90zGDJm+ElgnVy8XwIYAQP5oRfHMP6ddq2axEpnTeSBdf0OceEIvETImsJsDXnyFUq4eTmyl+t9GGQat0BrJwNetVSq1U7isrFPMFhvdrVZm2jjwXTUSgIudzcapvm9MLap8ggTH9MjtvNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Jul 2026 19:02:54 +0800 Wupeng Ma <mawupeng1@huawei.com> wrote:

> Commit ba23f58de896 ("mm/migrate: don't call
> folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
> the migratable flag and active-list placement from
> folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
> the freshly allocated destination folio is handled where allocation is
> known to have succeeded.
> 
> Unfortunately, the new code was appended after the existing
> temporary-folio block in move_hugetlb_state(), which contains an early
> return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
> the surplus state transfer code in move_hugetlb_state()"):
> 
>   if (folio_test_hugetlb_temporary(new_folio)) {
>       ...
>       if (new_nid == old_nid)
>           return;                       <-- skips the new code
>       ...
>   }
> 
>   /* added by ba23f58 */
>   folio_set_hugetlb_migratable(new_folio);
>   list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);
> 
> When the destination folio is temporary (i.e. the hugetlb pool was
> exhausted and the migration callback fell back to
> alloc_migrate_hugetlb_folio()) and the migration does not cross a
> node -- the common case, and always true on a single-NUMA system --
> move_hugetlb_state() returns before setting the migratable flag or
> adding the new folio to the active list. The destination folio is
> then installed in the page table but cannot be isolated afterwards,
> since folio_isolate_hugetlb() rejects folios without the migratable
> flag; a subsequent soft-offline, hard-offline or memory-hotplug
> offline of that folio fails with -EBUSY.
> 
> This was reproduced on a single-NUMA arm64 VM: a second
> MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
> and logged "hugepage isolation failed".
> 
> Keep the surplus adjustment, which is the only part that depends on
> the node crossing, guarded by `if (new_nid != old_nid)', while making
> the migratable flag and active-list placement unconditional. This
> preserves the cleanup intent of ba23f58 and closes the early-return
> hole.

Thanks, I'll queue this for test and review.

> Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")

It sounds like we should backport this into -stable kernels?



