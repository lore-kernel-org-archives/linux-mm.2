Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D104606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t7Zex76s
Received: by kanga.kvack.org (Postfix)
	id 47BCE6B0949; Tue, 27 Oct 2026 22:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C176B094B; Tue, 27 Oct 2026 22:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3429D6B094C; Tue, 27 Oct 2026 22:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 151716B0949
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:24:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8835780B9D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:24:18 +0000 (UTC)
X-FDA: 85370440596.14.2524788
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CE676140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:24:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t7Zex76s;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793154257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kW6mzNv9d6yhsfaYr7C1SS1O9TnPTANE1C6w87x8UOI=;
	b=eIOHufTm7SOZQnGPNDMfyWq+OlpqAEPYbuz/qOFzNnVn3UJgEDQE2ZNL5ppZg/Ozoj9D9P
	lYEFcA5hS3H1sruTI28m9E1xay9HrqW3VKpx/ovrnHelhdzsjPIrShvCssTKRe4ESRaKDi
	iviS+OZLsV9NDwe/YkHHWWK+Zq96Ehg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t7Zex76s;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793154257;
	b=AgTXkeAFTQooScsPmN606vlYllYdxEp5BF88hna/H78n0dB/xUnu18YgSSyPetKKauUw/s
	jk1+SDWN4wZVxZGxd+ra/vS7k5oKXD69txaaIYsdcrLlQTPWv1qLEtQnvswNlE6vueyFaR
	Q7vazbcJk3SsQ6WmsgblTWgqNKIE4VM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFA8F43CAB;
	Wed, 28 Oct 2026 02:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1F51F01825;
	Wed, 28 Oct 2026 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793154255;
	bh=kW6mzNv9d6yhsfaYr7C1SS1O9TnPTANE1C6w87x8UOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t7Zex76sZygL34C3bGAE/bdKfCXA/NQNhzNyXl5a34bLDu8qnEAUmyJW3fxNhw08C
	 tbzAmjUEM+gttOp+naQ4mxx1OuMWy2NNsfLeeotgwWGP1gKVbMKuceyohlZcWvq/Bc
	 fthpJqRPvByozPwnLn76K5SqpPFTRbAOt0lo2jro=
Date: Tue, 27 Oct 2026 19:24:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec
 stat
Message-Id: <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
In-Reply-To: <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
	<20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
	<CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE676140006
X-Stat-Signature: 5ib6atmoqkrntmexzaiib4reu4678wdc
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793154256-864900
X-HE-Meta: U2FsdGVkX19TgnNmJ4nOunw7o/EyKsPdlep+SEsgkkHo+owLs2oZ5szal/Z2bGm9kddaGtg8uT2RQjg/2HmhuMzQdq9hWLieC5uS/c4GIZfF1UB+VNV76loj+NmtDr1tg7yiKKp/D0Y6rDj4wy5tEjxnoh6+NQvEzm8T5v+q+b/cTNIj6WNFY+7ktLEx6tgW+qDaebREkMddFG9CoRT0deYqqvtMs5JPnXdj1NLFgLWneEzORAKCKhRu8ybhpvcMj3faMrch9F5BPhAHG4aVKanqUQqKYQgSZc0BRQruQ2rc6OcNlXRPih+PSeVvRf3/so2wy7K2Qj+pWgaiVitvzqCU5KYQl9lGE5Yhq9y1Q45/xu02l5BUAvzScNReu1acviVowkrvppKqQvEi6AIN+fxxFRFhSZqrwkRZZx0Flk8ATMQroO5cPyBvo5qmYMmuu+QNpWoF1OXX0XJUtxi1AwUOlrIj/Bu2EtF1kiJrBkBqmocVqaGKiPnRg/IAjZbk02jHrw6a/RNFeZ0RwT290D2Ljj9kZLt2x/BtXiRV+iq0WtCczKRIKXwfDQPnuE/vd5S7cSXalgj4DkcV0db12MUCJS4vcZkzkYUKuo5TD3Xw12V+bCKEvNrC36JWShq1dHnAy2P1E82DGQNRyWjXA3aH2pBV6K0aypkIH4membcxkMejHqg9onRkL6PrJJE1WiGIfdDZxlhyucdBYX3/MUGTiQi3MGlR2kkkyuAAR/8IlDhnsvdmzm14OTQBFm2MjyDzcyPDVrFN7uwQ4VMNw2m6F9JQmh+NRvtymdoqcAflR7XbGrr1qCrmcjTJZsuBuaNhDRBRF6MRaD/OqC/QXaJyOFfYepxpAHg9fOOeQDqJ6IRG+fHswYojUYAtBvDkkci3bJmNwEm+j6s8GHd4vtXOq5l2UrZ2Na115L5DV5b7NpB/ZCwIkj9LxaTng/3Xx3UfxYEEZo1sqYmMVAz
 EPzKgAgr
 2pW724n9lzF+0U2xwfLEYs75PKXQDgfdCdyGMN6hmVAMNbewN38ozcCwgf0J3S7LmpdXn6F7BiSd4DbHHM8oK5eAO6GVJwJMNwTf7coL1KJO3rwvzyY516GjeEUIgSTT3gEEao0nt8KmL5feV9flRZc3Zz7iu0GSgt5NMq9Co9GHVFJyC68E7OtnCV5zgzGjbqoIKxE2f9IeBpwYV/KUR33Q6mGgTQ4FwDUPsCy1r44I6fSsIPJaAJdN28tueez8ZXqITaZut/v0xdDFyTmtyAoxO5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 15:57:43 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> Here's an updated version of the "Fix this by moving the memcg_pn_cold
> group..." paragraph in patch 1 that mentions this:
> 
> Fix this by moving the memcg_pn_cold group, which is only touched when
> the memcg is reparented or freed, right after memcg_pn_read_mostly.
> SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
> is 576 bytes, so depending on where an object lands, its read-mostly
> cacheline is now paired either with its cold cacheline or with the last
> cacheline of the preceding object, which holds the end of
> lru_zone_size[] and the reclaim iterator. Both are rarely written
> outside of reclaim, so either way the read-mostly cacheline is no
> longer paired with the LRU list heads.
> 
> Would you be able to swap it in or would you prefer that I send a v4?

Thanks.  I'll take care of this when I process the patchset.  Which
will be quite soon now we're all merged up.

