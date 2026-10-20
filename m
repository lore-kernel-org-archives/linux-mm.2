Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2406606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l6k6wTjF
Received: by kanga.kvack.org (Postfix)
	id A1B316B03EF; Mon, 19 Oct 2026 22:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A45F6B03F0; Mon, 19 Oct 2026 22:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D186B03F1; Mon, 19 Oct 2026 22:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 572AD6B03EF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:39:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC4EC140801
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:39:48 +0000 (UTC)
X-FDA: 85341449256.27.4521D07
Received: from mta0.migadu.com (out-59.mta0.migadu.com [91.218.175.59])
	by imf19.hostedemail.com (Postfix) with ESMTP id B28B81A0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:39:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l6k6wTjF;
	spf=pass (imf19.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792463987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKyfrtAnBnwO542LTPL2+YmVFhv9HS5+X9M5mbYFXh0=;
	b=wuYEIL+pNS5AMKtbvJIlKJjY+9aGhRcWmKUikWVxKPsdUeWlTuwn3dqMg+QKsHkakH8zFE
	Xem7n+nbi7DEtY/RKOClcZlHezQEt9eVkdKwQoCpJtAcFDWYBA4PArQqOaacDfVCtLhpUT
	pNZn4zQo78s3JRHbqKuSVOcbUJhbqfQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792463987;
	b=2Bi9DfJ9NExeh7ljDdgUFhqvLIyDIrax7mS+NIEsULN0NiR60DCXtfiTQNqjodiDk606YE
	Nw8vQvcKasYsqK/WTBWhHY8r9urZaNh0APTOOSsVCjEGx+vBs2v5kN/L2CxhUzwg5HbI+d
	O1s4xRx9nIV+8PVa4BLrcoNZY+KJ0v0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l6k6wTjF;
	spf=pass (imf19.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.59 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=00+vt9qrllM8ZzXqix0pP9Xez7rpoPwxxNCrb4lFYHE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792463985; v=1; x=1793068785;
 b=l6k6wTjFhgWVj5NF7XU8bFp9FuEwCAtrbVnCT3tmMebERaTA44w4l+bpnScfqxKBzBEhDwZZ
 MXIlpZXW2C2dWJp9tmZkmBUZdb5LbEGguI8gadfkvazqAFR0y49+RZ/se3OOPdibKGpZokBtcv9
 oZ+y1Cl9dIrsosChpIMuvekw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0520e0ef0e1754e3;
	Tue, 20 Oct 2026 02:39:45 +0000
X-Mizu-Trace-ID: 0520e0ef0e1754e3
X-Migadu-Flow: FLOW_OUT
Message-ID: <d4a35334-56e2-4590-8b4c-1c030c36e5bb@linux.dev>
Date: Tue, 20 Oct 2026 10:39:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org,
 Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
 <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev>
 <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
 <CAKEwX=O4sPx5MtGL4-JwLzD4TWm7fNycFMiuOqLk4ADFUUipNg@mail.gmail.com>
 <4f361479-1dbc-4f09-aa26-e1ad6c06cbee@linux.dev>
 <CAKEwX=N4jj3PGXFx6wwh=PG4Vt6hRJ=-kqX24B55zoXyhAa1WQ@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAKEwX=N4jj3PGXFx6wwh=PG4Vt6hRJ=-kqX24B55zoXyhAa1WQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B28B81A0002
X-Stat-Signature: hr1qqniktxxy8zpnbz8q84hfhnum18ir
X-Rspam-User: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792463986-716491
X-HE-Meta: U2FsdGVkX187JJaa5M6wVySTl70NvE7IqqxYpvHwLa5L4Sl2ARvI8A4dIILEorzyKrpusD6MHFJRQqEkpBG3nV2dNJBJ+SMs8WyJEMmi/5ZAKoTQMoRvEXlMGWsgwVJUYefOQeknIpp4fiPuX52jZW0a9It0DHYC02RqQagCepd4h8i3dvi1AmiyIfrhRQcdG3mKcK4fNCh4Ffdrgz5QVGiZTWz0aLtq5sZy1nk2HFjM/t1AagWE/bJ/H8+X9JXhzatly7Ia3643UNBka3krmHI9FVoGCIbDMenmKgsp11qJg1Nn7S6uClnNu3PqCcxY85uSE+0R51RVixdjnReWUfkvLaTIpZGjCRkUIVun7L+xHgVbqG84futyWrrJtr4HxbL6UKGe/FJ/xkD6B8KZwjAI79qJDHfrDo95etMpk6kjG01wDkQlOMEiCOaXZv9srdS171lQJP5b7V9eseJekiyYa4Utr91RCbcZG47TSPgmPNVGL/TVNxkBUaovn5TJhwVNQIEsufHsdLBc3j0JacUT1RTYWWw7fg6M50YwntncSFgxkzQmxuZfNRcUIQE2mVAUO6sfwoKTgW4b2PC3+CGOPJaY5chsjfzo6yLEqrF7X9T/MKzT3UFWx0pluSrNAhkwu6gB7LLknQG5hu0uW4QWzAdvapz14S55Ek1bImMLb1d6DWyizYM5T3i3T+mODraJiv3MoA7K9hwz2CVYx118iBgns/CAbvNWiPkG7pivhNOFUbEqdZInBaJ3rQ2DbYEE0oZUB7fEWT7LX2qINk8JasiT16oRMadZAB7p1yInxV1N+MetBsSw+C6282mPMZ4lAktSInWSAgLp4cK7E0tpLRmLicYw16NVhIfzXTGc/HGYMVp1MhlKOYorgtpnJY7dGrafgaR9RTIsTQjOvuqPqqJfhcB09Qo3XSGH1XHl+XPlTg01PKdAW25taqT0u7hWp4uG0Td0G/mRC0c
 rzBFuXEu
 iiTMV3gHZfcSm9btXVQLJgL4Hnxw1cgqCjdyz58Lc7/0SFhFxgwwonvuoXhd5mgWCTDD2zG7ve352R+4vsSDRoFc8Og22zxwucMLRJhp54zrLT2DxQ0GvNC49Ss0r1++DIg4LTteeNnKrtmPR0vuJ+F+pzM17PmABcw1KPXQVdb595+EKNmtiTllXQR/F/Ak97aqzHsMw/7hXdiL4s5EmU1/xetv4KSBev8HogCgTBcfx/oAdokKMifuDon48e91gc7PCPkEXVpOYKcMAJ1OHOfjDyHgICZS96RHZXXgddPaPGyRtw+mIF78L9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/20/26 2:08 AM, Nhat Pham wrote:
> On Mon, Oct 19, 2026 at 7:37 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
[...]
>>>> Right.. But I think it will be much better to avoid such folios from
>>>> hunging in the swap cache in the first place instead of having a
>>>> worker to reclaim them. I'm not strongly against adding a reclaimer if
>>>> other approaches are too difficult at this point though.
>>> Also, IIRC, dropbehind can only be handled in task context, right?
>>> We'd need to make readahead bios to complete in task context
>>> (BIO_COMPLETE_IN_TASK). I wonder if this has any perf implications.
>>>
>>> Another idea: how about, in swap_read_folio(), where we are guaranteed
>>> to have the folio's lock, we check if folio is mapped. If it's not,
>>> invoke folio_free_swap(), unlock, put, then drop that folio from the
>>> submit batch?
>> At that point the swap count is still 1; the zap comes while the read
>> is in flight. Checking after the read works for the synchronous zswap
>> path, which I tried first, but the bdev read is unlocked in
>> swap_bio_read_end_io(), in interrupt context, where the slot cannot be
>> freed.
> Zap drops swap count first, then try to free swap cache. You're saying
> the read check the swap count before zap dropping it, but still holds
> the lock by the time zap try to free swap cache? :(



Yes, exactly that. With the check in swap_read_folio():

thread A (readahead)                   thread B
swap_cache_alloc_folio(B's entry)
   folio locked, added to cache
   swap count 1 (B's PTE)
swap_read_folio()
   folio_free_swap()
     count is 1, nothing to do
   zswap_load() / submit_bio()
   .                                    MADV_DONTNEED
   .                                      swap count 1 -> 0
   .                                      __try_to_reclaim_swap()
   .                                        folio_trylock() fails
   .                                        gives up
   read completes
folio_unlock()
folio_put()
-> count 0, folio in swap cache, unmapped

The check runs before the zap, so it sees count 1. The zap comes
while A holds the lock for the read.

Checking after the read instead is what I tried first. It works for
the synchronous path and not for the bdev one:

zswap (sync)                           bdev (async)
swap_read_folio()                      swap_read_folio()
   zswap_load()                           submit_bio()
   .        <- zap, count 1 -> 0          return     <- zap, count 1 -> 0
   read done, lock still held           ...
   count is 0: free the slot, fine      swap_bio_read_end_io() (irq)
folio_unlock()                           folio_unlock()
                                          no ci->lock here, slot stays

The write side is the same picture with swap_writeout() and
end_swap_bio_write().


> I was kinda hoping this kind of interleaving would be rare :(


It is rare per event, but it adds up. On production it takes days to
leave a few GiB behind. The DONTNEED there comes from jemalloc, which
issues it on every free the application does, so it never stops. Our
reproducer is the extreme case, built only to verify the problem: it
leaves 480 GB in about an hour. I'll put the numbers in the commit
message.


> And yeah, I think if we want to free the slot after read, readahead
> swap IOs have to be submitted with BIO_COMPLETE_IN_TASK. zswap
> writeback's dropbehind relied on that...


Right, and that would still leave the writeback side. The worker covers 
both in one place.


>
>>
>>> That takes care of the readahead race. Seems safe to me
>>> (I assume if a folio is not mapped and swap count == 0, then it's a
>>> pure readahead artifact, but maybe I'm missing a case).
>>>
>>> The write direction already tries folio_free_swap() before submitting
>>> the writeback, FWIW.
>> Same shape: the zap arrives after that check, while the folio is under
>> writeback. On our box with a swap partition that is where most of the
>> leftover came from.
>>
>> Every check on the holder's side runs while the count is still 1. Only
>> the zap sees it go to 0, and it cannot wait. That is why the patch has
>> the zap hand it over instead (very nasty i know it :( ).
> Yeah I got no smarter ideas :( sweep_work it is...

