Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C56C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707E46B00A1; Thu, 30 Jul 2026 09:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B79B6B00A2; Thu, 30 Jul 2026 09:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5D86B00A3; Thu, 30 Jul 2026 09:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C3E6B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:53:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFD7C40168
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:53:05 +0000 (UTC)
X-FDA: 85045584330.24.C1490D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F3148100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:53:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANqaDDhT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785419584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sn/68y3lNlYo5E39E/akPn0wUZSlktIU6u2iFnuacCI=;
	b=Ef3TtgBMen4w3LoBaKKPNMWNQnvB7//jttVSsJDcLwBnb+U4ts0ykQTqhQMSJV0FZTyFqI
	qhr6Ka3aYj9JgYPVOpIU5n+5t9TTCxheG5lakVz+rIBvfh1WVefejQnmL7IBMQaWuJeYsl
	8l7v1j5uObNzKfC36qo0VX/7DjXB8ns=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANqaDDhT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785419584;
	b=fSQLdIOLa8Q2AbAs3lnKVEfBxsMgJPQa0kywLMcrF1kDVRAcGmvz4BMkSboFf6107ksFo6
	L5koqktCAyjGtudERR1E5ZARPzdKb6Yd+m/LBLMPMy65Vhe+WpAFz4fIclTDTJ6EIo5ch0
	UslfBTa+8FXLmgRAXMyLOzmbU+nmmic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DAE3600C8;
	Thu, 30 Jul 2026 13:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995D01F000E9;
	Thu, 30 Jul 2026 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785419582;
	bh=sn/68y3lNlYo5E39E/akPn0wUZSlktIU6u2iFnuacCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ANqaDDhTxt5eWSOobGKcDjDuf4s785H2G6Kppo14Vbj6bJo9LneBkYdIHB4x1Bszz
	 3GoIkEox+T21GdAnzCyqTc8Cdn2mHAWLN227GRdLMJ52D5j1EoZxstdkPeNmiGQRVj
	 SFnCp1BfldoAVhgDtHzFyntXotL/RKuM6VGI5mPQVtqgB1o8bZ566lzo+7rxAX01Na
	 mpnGX91L/iGO3UhRZuJnVdXj4Ha+/z/1LFxyTVbSKdg4O7cBfmmV2SSGvSsRkx3xgL
	 rksn+3k6hpkCFKSeRak7UC0yiHOd8lDVoOOTttRb91mRG1iRU9At4aoOyzT8ko/3B9
	 h3kLyS+LiqM5A==
Message-ID: <411318eb-3156-4e5d-9e11-4c319bb9e755@kernel.org>
Date: Thu, 30 Jul 2026 15:52:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <ad31d36d-ac84-4053-a5d9-e18c346f3908@kernel.org>
 <CAJnrk1Y-4-_0udtGKeva=f5=xYRCWcyCnBA_1aVQ8oUZRKGkAg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1Y-4-_0udtGKeva=f5=xYRCWcyCnBA_1aVQ8oUZRKGkAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3148100006
X-Rspam-User: 
X-Stat-Signature: t9h7bng5dzsz33ijjqpzk5o4gqmpptgx
X-HE-Tag: 1785419583-802505
X-HE-Meta: U2FsdGVkX1+DCUwCq6QR4qGeRoctjneqfwxzfvoPRlftV7ZnSRk2RTEnRvR9g5LzG3xiarMvVfvGp1ESV2t+bGFeK4xaD2aB8tZYgpWAtK/qx3vLC98O7iNqRSGvJJTqRB4steJvrejbqhjp1L682n7llhs/xCTPQJ8Tpno5mfFekDX5/S2dHTEDppSdfqUFUjHm6yMEtIWKQ3DE4dJ3RnKkUs9/l85WLKt3jww36AXgVBp6XUPeMZb6W5rT2+3+s2kc0QhkQoJtvSPA+Z5lO6F1D330a+PhIzVGbAxa/mQNRsETetoEovaT4+2h5p+1pGfzCZ2ITRZm86xmKJaXehz0aDb1CU1FeMAy07DzaWZvuRBiXcB2K7PeFlLkH6/rTFjmxnVTih7HUDakRHGpisL1/lH8bO+gcXnkqAuQussLID1Q2nIre9W7vpdEy+N2Ax5VjdtoNmGvNc9rRbXkKt+1etllDApn9TWY9mfKQm7cle+U+Z2D3MOQ63nq+fvhmj64Mg6/6lK7kdhrjCwIA5SWQXauOwq4hN1iCXL/GQCw1Lh1USmCDvFDuTMxXDYyG2x2bJU/TW/Mj/ZkY8SfnKltmtmpms+xRzJ68zm9MUVPVmeu2eyl6ZvJ3KVP2aaY5jkvuwuPbVO3h7e1l7PZGX+RTblb5iTrWT23Z8QgueiZjo8edTBHHUsi0wEOGoDWv6Vh/yFaBuB370d1Tmyu2789hmmFL0MEJNB+oPSCZbCazUV6GclP/o7Gb2G5Btld2jvRCJqr4Sqxm9L3t3yJkZsqous8xn8qy6lZJsCt89GpE0BZ+ZLgAekvbKtTVAUawgrJDmrjDXWomLBGXDwqQAo6fettJE46VH0jnTc9YF2bYmn3sJXGiyNhznx4or1AIhPoOISXl7mLFHxF6xngbGW80vG4mwmqihZWY6lYol1hDjSqbjZjtr5swezShS2FfrJy5wPT+ZPoH4xerki
 uCI3rUPK
 Z6uUCXjyviGtoTksFElJTuOHWeEfuF6uAOhRafHx5xckwxYWcAYon0zAJ7FoPaORYXyCM/RV6GIHJ9JPD1772UtXQ8dQ0sNgMcmcX8gKbRUqMfgRo4KnqDwKE3LHXsyBSmdnVLFWFLesUSVzz3mYQPXgpQEeYRIV7GjDlVqMsPPeFUGys/pKWfohCDpBH3fpAV88L8BR97dPuQCf170eGE5787OhFhIVliuOvo01gDGMT7NhgL7YYbWQxXN4dc8kbAhQfxENZD/s/kLvaQkik42NPP4u8+pGWYJRztoDUAWVAV3UV5FwYU3nutA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 20:19, Joanne Koong wrote:
> On Wed, Jul 8, 2026 at 12:47 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/7/26 22:17, Joanne Koong wrote:
>>> PMD-sized THPs that are mostly zero-filled are reclaimed under memory pressure
>>> by the deferred split shrinker, but this is not done for mTHP folios. At Meta,
>>> we would like to deploy 2M THP=always on ARM (with 64k base pages), as 2M
>>> provides contpte benefits and 512M is too big. However, 2M THP=always will
>>> result in a memory regression unless the extra unused portions of THPs can be
>>> broken down and reclaimed.
>>>
>>> This series has two patches:
>>> Patch 1 - makes thp_underused() work for non-PMD-sized folios by scaling
>>> khugepaged_max_ptes_none proportionally to the folio size and using that
>>> as the threshold for how many zero-filled pages a folio can contain before
>>> it's considered underused.
>> Did you look at the khugepaged side, and how we handle it there?
> 
> I'm not sure if I'm interpreting your suggestion correctly - is your
> suggestion about using the khugepaged mTHP collapse threshold in
> collapse_max_ptes_none()? I had looked at Nico's patchset in [1] and
> my understanding of it was that the mTHP collapse threshold currently
> only supports values of 0 and HPAGE_PMD_NR - 1. The patch 1 changes
> use khugepaged_max_ptes_none's value as a proportional per-order
> threshold for mTHP because 0 and HPAGE_PMD_NR - 1 are too extreme for
> our use case where we're trying to find a middle ground that keeps
> mostly-populated 2M folios whole but splits mostly zero-filled ones.
> 
> Is that what you had in mind or were you pointing at something else on
> the khugepaged side?

Yes, essentially that khugepaged does not apply the scaling because we discussed
it back and forth and it either results slowly consuming more memory than
intended (creep), or ends up being completely confusing for users.

So khugepaged will currently only collapse mTHP if it can either not waste any
memory, or is told to waste as much memory as it wants.

Adding scaling here when we explicitly rejected it in the collapse path looked
odd at first.

I assume your point would be that just mTHP over-allocation (not due to
khugepaged) could make scaling here a good choice, correct?

-- 
Cheers,

David

