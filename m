Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83D6C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE306B009D; Mon,  7 Sep 2026 08:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EEB6B009E; Mon,  7 Sep 2026 08:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F1C6B009F; Mon,  7 Sep 2026 08:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830C76B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:20:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 073D480143
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:20:02 +0000 (UTC)
X-FDA: 85186873044.29.51E0AD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 344351C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:20:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzGaNfxs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788783600;
	b=Z0/s175ZJp3J2r/KqJyfgDxxhEf/ZNctogax/KIpmcJ9L0GdtNMpXWQzdact8ozHgsbbIP
	xreqfcMPEwsDdGStfezZX3m04Al3/xPgukebNDRIivQdhFO1lZxDZHy9uqnLROTqdgMBWY
	HcP3ppd+eAfHbteSPX+G4VDtgZcPOac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzGaNfxs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788783600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jr+dzi/Mk6Ixf7g3doALXDqMGBZVD3wiiGgYyYVlQhs=;
	b=smo8L1LOIH3dF54kK7ABruOo3Mq8EQw2hmQXexUQHji0VgEyQlykEx2FGSUTvxKiPDqxuz
	MUCM7YxTZhXDTgoBgWlZSs+Efuf5N6HVDaSRTy1rP0L5xQ6QhDhJ0p2+ntyJsO2sBj5ABk
	eMaN+8FeqUGQ+1/j+VongIXp3G0r1/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92DBE41797;
	Mon,  7 Sep 2026 12:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55671F00A3A;
	Mon,  7 Sep 2026 12:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788783598;
	bh=jr+dzi/Mk6Ixf7g3doALXDqMGBZVD3wiiGgYyYVlQhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dzGaNfxsAxTySxrFOKLq3KLOX855facEk1kcwfbMpf+V/sJkyLwP3Z5PcJ+qjFkDG
	 4KpDJm1g1C1Hg7DqWxt11xh5vtL/dwrTSPQvvlvn4iGmeYb0pcZ8bJItEWYtlQXB7A
	 6mp917Ys4NJUcuQZYBMfO+LAj45mqOimfsNeFVVzU64IN3NwpalluEEdNj2KKIKD1G
	 z75JjldTUhnZO9hTQ7HkP8rrYlBJyCMasaoUHUAb9uYP5WD4IJa7CMpIa8g6MRvL6b
	 l6AEzSUJTBmPBrL/Kj/ZovBKna0TsgRWD8wEhbdD6xedpfMWc9dQW+LiI1MqYViE/6
	 EmW/xJzWjnxwA==
Message-ID: <fffc191c-37d5-4f00-b73b-91b8d1b45046@kernel.org>
Date: Mon, 7 Sep 2026 14:19:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm: gup: cleanup gup_fast call chain
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260828015542.125576330@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260828015542.125576330@ruivo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fk7mc1zestiezbtd9tkr7uwwaobore9y
X-Rspamd-Queue-Id: 344351C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788783600-381236
X-HE-Meta: U2FsdGVkX195YKLOs+a9C3TDS43971BTM8jU6gacH0e64TAa4TOijS0V9mB5wdip7KPRq9ATP+8RRLWl7jPrg/23MNJrSe8TUGB1mI4FDgRbBxDgM7VQVNkOw5OKqCiFL3JHdcP89Edcg5Np9qV89QCnOezXj0j+3TskMFAjd3RsptPT6r3BhbGz16EdJ5/bALwXlSnS1jClVh0Csql2iROY0Tu/UNB5kGCY2zHmB3ux+Eab4CoXEfAATk5RkONrCh2U2FVaGAaPVUsOBE9+DvzEyNmxtso+kMzKG3S/aW/pLZPacpLf4sf+J+7kVn81sMHfnckJ3oUVbjMblKHWTseWSp6jsTgxl6+L0TXr5iI7aAxecW+EHR0ehENtrSzyxkKIOzkuQ7E9EPzc9gISGl0p6ner7ZI2hV1dITzTz4+YGPuPb/A91fkgzocTnzP9EbnVC+7dRc9/ef8QrZ1Rpnmj00vGoTDC20WXhiH1zhW8SGfFeTZFnPtRYTxXZYm934HSxycPcEVwMS/JYGmgLfEYdFkTS1Ug7lVe2tK1ftt1+mIr8WodN1lVOCYHzzQ1a8Pey7fKhsXeHFwCeHkZUSiWp1jxmATAR6yME6mR6MSuX+4k7dKcYtnUc4rtUy3lQ1ccPA5RHNbPdbCPtJv5Ult7yJHWodTaaJc77YpFeFGCIaoQiqUCZ5x4GiIWbgWtH7RjZUoTuFP7Ka++W6uFSS8eaCviMuGkf9TxMWatVJZ5id0QMhC9qjl7ItCuCroIfc1ZTEokF5jbAMPiBw/zZM+G+39IxAr5Y5WkDrdNiyArWaX2CA7xeQ+vBHLhEFV4/JYJl02kd+cNsYMgLRTM40fP5peuDQZCCu1xGhHRSKxK4UF8PY6c9rcPA2BhkXf8shO3ij/40TSWV+yTqkUvD1aNP/DxEoZHyXoRcY00u6dDvbU5kjldsc8J+aeBb5F+hGAbL+0KAflmbM2u29P
 X7ZHBuhD
 CbyV5g231EyJyGUyjNmqOE34kGWXCRvsN50dEhDpMW6gkyebZ8q5KGancOjxxPUQBEa+1D0is5StZZ8Gxf/ZqB84/1HSoO9EQi7tSNByFFG93izUCS2JHrEru/cPS7v5BQpIZupXjXtv5NdzOaOB4iYvgN5wovyLwQ0/yc+pHBmyf/NpkiJ3icZo3R0KCAQ2wj4X8Ho/5yj4x1q+AulNuiThmaFhbA+0hLlAa1dPs23yLAQdp+0TZY6fEr0tKsCeYXPW1F9X0SM10+sn5Qc+caf/bVnb5Ps1quNEUsffQ96QsMd7wAoawhNbqYfvLSjFEwf5a6ZmC7PxQiCdM+ntXGy9MfEc0xPlp/9f0JycJfU6PAm1y0Q9Xo2Owi6Csck0IdUOF6Dvyhn7MBMklJ6MCEiCqbJn9V9XIR3HF1h6bkSezIk/N40aJ14VWHYtih38JruTFpSljbidCeJzSOulfwojV64IAhQfF/v/m96frA+MQ2rRlwK/rbhS1AP1mA25X8evI9KkVnLrDzOmqGwGxjPWvuovVaZ1oYqrFqkTtOVaIO/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 03:55, Aristeu Rozanski wrote:
> These two patches implement the refactor in gup_fast call chain David
> Hildenbrand mentioned in
> 
> 	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> 
> v2: removed unneeded initializations on the second patch as pointed by David
> v3: fixed gup_fast_pmd_range() nr_pages initialization as pointed by David
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Andrew, can you queue this? If I manage to set up the new component flow on my
side fairly quickly, I might still pick this my self.

(have to dig through tons of mail first before getting started on that)

-- 
Cheers,

David

