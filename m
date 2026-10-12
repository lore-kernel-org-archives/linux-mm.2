Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8A6CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AECC86B0092; Mon, 12 Oct 2026 06:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D0F6B0098; Mon, 12 Oct 2026 06:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FCE6B0099; Mon, 12 Oct 2026 06:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71A7A6B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:25:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BBDBA8937
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:25:54 +0000 (UTC)
X-FDA: 85313593428.04.D8A85C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50EF3C0007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:25:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9I6TvOc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800752;
	b=Ekh3wDcSDyj537If2b7gYk9akzJhY5ETIEyrcQvZojCg2mxtiJ8uwhrD/bzbirXZ3zRLW6
	rI9YQLbQ57dpGR4+TcOy2hqWCaiFb/uPkmuQnWQedl7jfL8z1t8l826f3Q5lMXiLgen4T4
	H/VU2tmT06pruD2yJMpe9CtWHnzxSZU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9I6TvOc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5thwpExwUGKYHn9rMgaK5ega9ItTIpyU+Gtff5fYX0=;
	b=RjLX/vHE+5qfFgGNGyCeyHG1TBh1cfmmfh3RmpaOSL0ezCbNPgMItWITPftMty/NiN/BBD
	XLbVY9BKoUe52wvwhf6twS4fH98LnAbHcQAgCjoqosboAUWk3r899JWmXF3rUgTVrvFtWY
	9ebWR1y/ZwESTWipCMy06sQZxI1Ad3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB157600C8;
	Mon, 12 Oct 2026 10:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400A31F0089B;
	Mon, 12 Oct 2026 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800751;
	bh=g5thwpExwUGKYHn9rMgaK5ega9ItTIpyU+Gtff5fYX0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j9I6TvOc1UlhSbnVdygAok/F2Wjst0yn1KD0oM2QlyHRs8CjNYAnTklUzSV3ho/E/
	 63Qz1DG7t0onX/sBWeARuP4eF/Qk9y135BIwm+UWdi5r13b5kZgSi/pEkdtVFwnXKP
	 NXRU/baX4hutwUEYqPvxoATF/KtOZqCTJjtPbd2qbpm26+c5ySgfH/HzgDIdxDpsT0
	 6PE/ojZPFAI8DH7xavGa3AVPJatgGgw2aSRzEWfOBFXfnXT6VCU90wwVOhUwB3TGC6
	 D12jkV65kVIcXaL3uS5y0IrmILJ3xOl6XTj3mkt+e06FpOy9P3/A8sdgIbo2aUCOy9
	 HPEpVrttUXEmQ==
Message-ID: <342aa9c4-e100-4650-bb3a-89bd9d4b0eb0@kernel.org>
Date: Mon, 12 Oct 2026 12:25:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, Kyle Zeng <kylebot@openai.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 50EF3C0007
X-Stat-Signature: 4s1kbjiep3wdp3eihwx8wkczzqenpb8f
X-HE-Tag: 1791800752-760755
X-HE-Meta: U2FsdGVkX19VLEn8RY4yiuqqd8Mze1BFvJX1FAD2RhED2Tvi/52ibZb4+wPHBryVX3wqTjFHJNMNYzKMKpL7b15ZzqxBDh6aGm/D/nrw1HzbpSeHuXP7DVmEcVRiFPAyBs2u36N6t0T1pGWsA00lSGdUZiqnmTaR++WHWGa+A2nwXO2t6fPwpdo0gctRTpKdo9MInveuhSulf2aUtY4Fmh0K9c7SV4dsJoyPn0JIqev1CO9A7WYHbcxY3uGMjWCLDrxS4DhYFFPisW+DrvoKRlsGAR0IP6aUS/9ywrL3ew1mCyvFUohC9tn4u/ZfNhHqsYRjxnVYhuyNw4R55y9N73wOwGgLr2G0FUn6yfewOD6Gr6tqgGRTblZOh6yX93bSQ0LgTbBFGuNUpoj3s4v/yeuKTWhKcG6UOk+l/4A63AgjiLyiKm/vYIHxiG2KtHgNkAvPsDJh7eanqQWID+kBnkIWnjaX+E4Rb68jvUN/oTXZfkLDExqXxres/Dv4ERaekBOPkyaf7GzIMx4XPh2ERFpZkDjSqxj1cSni2r+J8YSSyIP1OKt5WzzpbnlLq3gBjzYNxOqEbisZR9HJPJKTUwQDLFnfVXKkucg9w1roU71wQ3PAQn3goWjkkt+ThfjoC/caRCfxZkImWrPfXQQbki3d0PS34oC3kvLKYEuX3dm+Cy28Wb1we43pwk0kFAcCXUXATsNlc9bKEgsQP/M3/H0PWLuCrLZ+tZE89EM637dA1n7wU5FynPGPtSelqaRuKkJXGaQk4Qpa0BuEwoW31HUc2vJEM1byJ2/2JAjlNr2hi3saV4hysS/Lq1wJjze8z//yT8DMFxdkxwP8zuuqedi/gCVeI/7+rQrCJb988irgI8xYJ8Mk2riQRt+ngeXCU5ACSw/h5xUVw/zdnVtFeemDi4AKH3Oax7GxrZhHzonVWrrze8+h3jcCQDVrzNByEW43P7YmGjtyjelztaa
 T5+bz+Un
 pGDaA5EI6bmOWH4CIRL7i3GDEqhEI0fJbyanmao1OQdi7kf9aLAPxtSk7uMR0AiwXB8TGZ3CjN+xt9ch68ynfc4PKFYnUK89P0rL4E1K/OQ+LX8TijdGp4aWDeGtVx+OqIWovA5jVM5Ua6R3TraebmeGu+V78L2n1025mysGOSdadWNy+JnNt6OF97cfuHVMT8kdxKoDpJRCuSdJChYdETfQj3n8qqZ4DOTIsRomcSjkm7QtIP1SAIw8uh5EYxha09YwNIGsDNv7iYEUzARu/4xGhFC34RagBtGHv5jvDhLVEq3IVAsE7pQhHlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 04:08, Zi Yan wrote:
> __discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it knows
> whether the folio can be discarded, and restores it if the folio was
> redirtied or has extra references. A concurrent munmap() or
> MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
> anon_vma, so the folio stays mapped after the anon_vma is freed and a later
> rmap walk uses the freed anon_vma.
> 
> Using an invalidated PMD instead of a cleared one requires additional arch
> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
> shrink_folio_list()").
> 

Maybe mention here that we leave the infrastructure around to re-enable it once
fixes?

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

