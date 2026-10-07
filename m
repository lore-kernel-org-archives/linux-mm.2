Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75176CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820CC6B0092; Wed,  7 Oct 2026 06:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB426B0093; Wed,  7 Oct 2026 06:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691BE6B0095; Wed,  7 Oct 2026 06:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44A4E6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:58:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCBD61A01B3
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:58:35 +0000 (UTC)
X-FDA: 85295531790.14.A268F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E71AC20002
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:58:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClavKX2Y;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791370714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QsH2WQ9SDQqQQ5HhyQhB+EQpXO/5OEUEiipsXMuuiTg=;
	b=q6epRFJJ6Z2NPDoBZe4HkuqkphI9DlHRCJWrzttirCuAlMLnZrWMgCUuxseclHTFAncRKr
	ob020rjfQNVwruZAJhM2tnYKOA4M4vbfM7H+hgD56+Seon78X6FOcZzgcWdRvRW6J7i+0f
	gRL3yN0JnlG2gbU48S5FYzpgR00dmDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791370714;
	b=aj/SfkGE5t2jGpqWyi8tZWlsF91Q1fD0pF1P95E+dKVTw0Gp1dJXN45rbVr9ZtpAOFEqzy
	aKqcS0ap+llqlWkH/tgFJpXSZIsrczPVUxH7mAwH0HzUshfaeYsQaA1MAFiiwtVKj5EYDU
	AmcmJRep9Yk8tQbZBBUrzVykf42lZ14=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ClavKX2Y;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFCC6438C4;
	Wed,  7 Oct 2026 10:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5744B1F0089C;
	Wed,  7 Oct 2026 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791370712;
	bh=QsH2WQ9SDQqQQ5HhyQhB+EQpXO/5OEUEiipsXMuuiTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ClavKX2Yh5C1NgfFlXnAGS9n2b7ylvpH2CPkf+F7/BcQWTKgLxoCWVWDgOL5edYb5
	 60xjfocL0vskCdqhPyyZLRLTjkELQ+RSaP83s06muJYb5CX6PFh1Qr2qr8l5rHgdC0
	 9wrx3/cmczbtxRoI5n4rOU/OMLNadMngtO9Mn6OyfCTsVeSPOFU7ADNnN9oCvCzeB+
	 rzhu9aJKSVVkaEVX8Z2CGUAGFGGmup2j9BjGWBGmoirsKCrysLpnTaXRcINJKtGf13
	 0F/5nDU00m2YnBy+oq+oH945efjM9sTQzQrkP7PaoAWzOKnfvV/Q/89hvr1YS6kT0D
	 UMiCPFHhm7yrA==
Message-ID: <f0af8a33-fb19-45ec-9a52-4bb8579867e9@kernel.org>
Date: Wed, 7 Oct 2026 12:58:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: document unlocked invariant in
 fixup_user_fault
To: =?UTF-8?B?Tmjhuq10IEFuaCBOZ3V54buFbiBEdXk=?= <neganhat@gmail.com>
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
 <20261005093756.22709-1-neganhat@gmail.com>
 <645204ff-6c50-4ef3-9070-78ac602560b1@kernel.org>
 <CAFJkwZx9zmz2sxMyByFbYgfCi9zMN+iLxKrypKBCZY9NsLQz1g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAFJkwZx9zmz2sxMyByFbYgfCi9zMN+iLxKrypKBCZY9NsLQz1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E71AC20002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mzhjf6rykw14m9dp71gu4rca3cz796d1
X-HE-Tag: 1791370713-228055
X-HE-Meta: U2FsdGVkX1+3rxJZmaqw/q/TU6p/0k9J8Jr3sC9kDgWKr2ay4Cl8fs27DXoMf6WO04Qeb9zewRmrFwFBJtjCur88rvUKES6iJ80a8eTm7o/GfP4lQiJErhyhvNZXnuEaZ6RtbisM3s1Lw1NjIrNy7/n4De6P1BF9O3pT2yBzshV8q3MR56J0AhxH34MI0i5vqDIwmBzOiPzqdqYzyOQM/LpGlkS6ZGfm8niei8uInUZrM6TwiH4jieNSnB8Hg6ABb742N69P38PGVxTaFSU50iiz86EF4CZz9LrJ0mdPhKkXg/KrZ8VG9smdT/+a/dAuGm8+2GE4zvUQ7TnKfcuZZPj89nzWPptv17YlngoqHID9+TxsTVjaDfA4p+RgEda1ldJHUQ3LMYBb/hOUI4AhXT1NVfwCv3JcOmB5ZyE6Jjxtr2YWRk/ZehN0j1YI+YDDQudknIoHOHrA0G2wJY/JfmLaGgulN+euO9wGGCVW5iHGcjxLJrqZleLTqn2NGwuWL8Qw1+Quvh68wzxvgQNeSICgBDJuGvm9Y3GPCl9HHOYJD0KCoS54QLqa+XGKf5XwTSL7Nty3W1hi8B9628HmrBASPULTokKsBMk6gKD6bibu8oiR1Xr1YNSJvUjohCYXvT9rKg0JNuCU9WwLiZdAmfklron76tVqXQqlCJ3MIw0ipUxgsPpwkGucydigOBPvvQfDTZMs0HVTSshXs3hP0EYIr0Rgpa0ojvDqFL65fFCJeOiS0zHlxQiyj1Aok7XFMvV6YVxTS6zGGxPX12atQMSrT1CcK0marVOUIz4R6GNu4BaBHrZaOhlwqPoDZZf4TtCeYYs+R4NSEZba9fkfqpJNUx1FieNdEX99Cq+o4Yxo938LRxR52iCNuDtvGkOfWl37ON78uNi2MI/6VBcefMkjbpqw2SmiGXWDaMgvpAnQG53QoCdB2/Uu72J+I4HvYwKFTsjVFYGYiiCatBO
 UjMr3YV8
 qiRsWP657GIAE1UL3E0zte+12mAIvtSIONwTIoIUVKnC49eY8PIcBNUAXJxjQ9KjSqvBZfEksUWaIvbo0prTkpF/+02TRFUVD5ilGTe9BpkP1N4R0De7/ImkgDCmEskAff3ejZNZFooPE2aaFNib7+tCsK063whmwbN7JJzXP5fstrwKDhXMp8zv75h4EK/UZRywGnk+fa0oXHB0i/SeDZHh+A3HJLfZmXmnCJVRaDaO19OA+Q5vPEWISjZsWR7RvQsLg7Vm3yOCF/uPJrKlSkCT7dqP07S7VTTFb35+yCscsD2J/mPGRTcL+H6uwZOrCSCftH/4xl68uvDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/5/26 13:22, Nhật Anh Nguyễn Duy wrote:
> Hi David,
> 

Hi,

> Thanks for taking the time to review.
> 
> My motivation came from running Smatch over fixup_user_fault(), which flagged

just like the (at least) 2 previous reports. One from them from 2021 IIRC where
Linus even rejected a code change.

> the dereference as a potential NULL pointer issue. Because the relationship
> between FAULT_FLAG_ALLOW_RETRY and the unlocked pointer is subtle when
> first reading through the path, I initially misread it as an unguarded
> dereference in v1.
> 
> When Andrew pointed out the invariant, I thought documenting it might help
> future readers or newer contributors who hit the same static analysis warning.
> 
> If adding a comment isn't the right approach here, would you prefer leaving
> the implicit contract as-is, or is an explicit runtime check (such as
> VM_WARN_ON_ONCE) something more fitting?
We want to silence smatch. Either fix smatch or find a reasonable way to stop it
from reporting things that are simply not true.

-- 
Cheers,

David

