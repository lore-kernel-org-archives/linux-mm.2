Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDE260A2608
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbURHUqC
Received: by kanga.kvack.org (Postfix)
	id CCF896B0449; Tue, 20 Oct 2026 04:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA67A6B044A; Tue, 20 Oct 2026 04:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD026B044B; Tue, 20 Oct 2026 04:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC476B0449
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:27:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 256D6C08CD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:27:14 +0000 (UTC)
X-FDA: 85342324788.06.11B22F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 545D540007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:27:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbURHUqC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792484832;
	b=LlhGXvxUPiGxYuwDN5u7xzp/pFwBV4AUhf1MNU7SfH23Dz1KFTAW/BsPmrDmeFXntQtodT
	N96UTfqeBw4UxXWjMhQx/VoG7c5s/rfQQw6uMb/NmfAyTx//tyzQrN2oewQQ9IEH3TbdZV
	3ofUDQO9ny/JY8RKy4ZXiqX0pV7gRmQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbURHUqC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hD3QL3zhfQaS6wp7jLt510z1yjbpvqOBC7skF7FHaiI=;
	b=Eg5tavxD/cT4C1qkaNelgnwWZ1VWjc/u3gNZSBTu77bq6aAVF7uFImIf9cpwWs8yE8E13+
	o4R5lmtSqjvYitwE+kIqK819/fvQEPGLglaRfMJe5cssJWccS9E9oGDYtaIhAKAeDenxis
	qsgITaScWhrKER1q9ZKsGH67208cwDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 827A2438BB;
	Tue, 20 Oct 2026 08:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AB21F000CD;
	Tue, 20 Oct 2026 08:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484831;
	bh=hD3QL3zhfQaS6wp7jLt510z1yjbpvqOBC7skF7FHaiI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lbURHUqCrjNtQgm+44XHMvS7UGgRz+SSQQZJJLmZuwjLS97fVgLwmQWtDCVavLsmH
	 JPaxgW/Tpul+eM7S4xmoAFTri7OYweN7ymjGQZ7jaUiJnr0gRJnJqPNWpUFrRbr5mv
	 +tGxmN9wRb/xhBtz2aeD2fBjPYX/7x6BPgGPIF3eEZDIQQxNxs+VHzowVHiiCkzCVo
	 gSzGfeD1Gyhr0OoTiNp6YB10sl9vS9aiXNchWAayP+qgKQJGkQcR+HbrLTaNeQJwXe
	 91islngKr8L+2HJJELjTBFsB5TqTIQ9HEULpZhuJlm/5DaJxmYJHEu+zWsS8pKZYdS
	 ivwBIsBrrUpQw==
Message-ID: <3a034d40-e01d-42cf-9325-8c1e4a6db1b9@kernel.org>
Date: Tue, 20 Oct 2026 10:27:07 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after
 concurrent resizes
Content-Language: en-US
To: Vitaly Wool <vitaly.wool@konsulko.se>, Harry Yoo <harry@kernel.org>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, hch@lst.de,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickolai@csail.mit.edu,
 rientjes@google.com, roman.gushchin@linux.dev, vitaly.vul@partner.samsung.com
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
 <atTv1tg9q9n92kZv@thinkstation>
 <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 545D540007
X-Stat-Signature: 1pzgmk93h8k4ruufpmcipkcwaa8z1ihw
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792484832-923015
X-HE-Meta: U2FsdGVkX18xLPMZtnERM7aQsWiK15k3k1svYnJcvnmWah8+Ozllgf42HRSmj/6dMAn4wpwQH3T+62BrdovPpiqreObKaehyza8uYTfHl0RblE5bzfTUi2ef3+LzHSbFBiB6RfUBA1oI5Wg0XIX4tYzBt+yji/HmptpbTp/nqzg65/O09AhHk1YnjaW8QHMwGthVN2n7TI3nNylBDQEGgmr0s/TShlQw6ntoykeHunjCk+bE6rQaNigFQFJZnKrTEpldZVkz75vgULRiEZHrbFidtmc6ajb9xCq88PfNQVDQd/ycBn9J/pSkZWMGHurl0XGs/G/GQ4S4iAI7xtfK8x6QsIsRtPJsrxrM09KqbPlehAs+vBF/RbXMYjxDZPSUKojqKDxwAvE10mloYznonRL1N+iRHPOW6oarG0UzIHp6GOaHVOpIRwGUmDPxRWLWwXo6MtGsbXI76arzC+0x8WemC3LAs6iUY1QhHy9CXsatQk3+1FFMTsnMDmot73QOxYdcrngmWdRZ4bYp4itNqD1ZepImjYz4dOW9Sx61+Rd3japBoVZU23ZkDqH9ga9OBx27nTlUaxU2LkLQkyFKZ9EuJiihj2MJYCblDj5TtsMCDEiGQjePLsgahjF156Yt3FUYX2jwOKop3DI/i4/Z5PiFh5tzxzeHh3q0z7LEtAgXEmeBNKd15INQsUQUmXioMC2Y+tOFvAcapkAjgAsOZ6KmfSCidkR4/7mFpr4Kjx1OR6+WAt8buKDCXhayza1ajyEdyxirGJqAbIhWlalRkEW0TLj1HobA3ivCpUzUmLTWajebPlj7k6VyuVvb1E0TzKqhy2xHi2m7g9Q4GUrNhzWTnLAjWp5LdZfmqY0xu3N/uRGMvwydKGR/yyDpTZBfKVjnBVQaKPK4f3PSgH4jK066aT7mbQmPm3AFBifcrkD/eP9zHbAJo8kxhR/YNlkIjh4oOqYGCIQoNbsfJ5z
 DbMf0j3e
 L7zMn48iAfYo9e/38RFp/7wN0gZo2BsHdofHZUXzfrEYGgZJn/CYEjy6ehiRhXJRwcVi5WjKzY4d/nFhYefHIxIsP5zGIFJm8OhBE5mrJqldWEQaYpcVoX8zmhgy+P6dZEpveGEfd1ZrP8IkPM8v4dYakRGagCTW8lFnS1l3N0OW//u3UsR45a+CkTgQPjLhjKo7lzrOVOqZN71LQVupIo1xp0dIoRrEVqe6H/WO9MYWum0inwGy63LOu1+Wxhkj4YGAXrWsocRtfzSo2asrfINC2KeuUR4UnWsWfV4PZuIv54DWSfx7lcEQaSr21dx1rystldp2e8aGlF/7kpdb/aEDeLAUZl9VDkHYs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 08:45, Vitaly Wool wrote:
> 
> 
>> On Oct 18, 2026, at 6:15 PM, Harry Yoo <harry@kernel.org> wrote:
>> 
>> On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
>>>>> How about we take my patch [1] instead since
>>>>> it isn't prone to this bug and is a nice optimization to the existing
>>>>> mempool_resize() at the same time?
>>>> 
>>>> It is not a good idea to squeeze a bug fix and an optimization
>>>> into one patch.
>>> 
>>> Generally speaking, yes. But that patch had been submitted before the fix
>>> popped up, so there was no sqeezing per se.
>> 
>> I mean the patch you've submitted does two things (wihch is not good).
>> 
>> It should be split into two patches that 1) fixes the bug and 2)
>> optimizes it.
> 
> I don’t think this is a fair statement. I would say that the patch I’ve
> submitted improves mempool_resize() to be rid of unnecessary
> reallocations and data copying, and that (improved) implementation is
> *not* prone to the race found in the previous version of this function.

But it makes the code more complex:

 2 files changed, 28 insertions(+), 16 deletions(-)

without an in-tree use case.

> ~Vitaly


