Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA641C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0A66B0095; Wed, 16 Sep 2026 07:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93956B0096; Wed, 16 Sep 2026 07:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6836B0098; Wed, 16 Sep 2026 07:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67A156B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:24:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2AAC406A3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:24:41 +0000 (UTC)
X-FDA: 85219392762.28.0EA71CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC31D40008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:24:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSY66ISb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789557879;
	b=c0J9rrYbwVh3hrHR6J21WLoLKbJxRjkoBshHxGYXmEZPeSR9zLBYzXRqHrGzA4gyUxULDG
	reGyFhJss1AlWWNlsedcR4SsQ/fEzTxkulGf6aezV6FLGEXu3j9WkmwGSbqnp18fpXjEdl
	0w6/UaJIPkmG32bFsUQghJnqG7LPj0Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lSY66ISb;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789557879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yMRewUVdtk5FTKiyrOjdk+WbBNSVZ/plHkzP6P2SuQ=;
	b=Z9S2+Edd5jbS1oTVOvK2fXe76xQVDADIZZRXf7ea89Y5asSKgCg8n0ACBbezZ0ZyPtReuQ
	8hrUCAi6pVXihZsS6ADgdZFkYlF6kOV2WHZOmG/4VawHNzWbBg4nOgNMXoLCuDX/QNAMfu
	wR9+hSBdgnJKlY4mFABE8ZCbvkOTtBs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCF0D6053B;
	Wed, 16 Sep 2026 11:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880781F00899;
	Wed, 16 Sep 2026 11:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557878;
	bh=9yMRewUVdtk5FTKiyrOjdk+WbBNSVZ/plHkzP6P2SuQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lSY66ISb3m9U6walw2ED+kaCgM2gABW2AgoPJjdeVg7dafwfXiiS2VY9yNMLoovS0
	 /HCNS6C7dbRdwLV1mezft/EYCTQWtw6Xi2W0ZCbP26gE+1GrfcGaLMTA4/DJvg/n38
	 X/L2iOHwfiwTNOWhnDMCMyh1rNq2RpYqDKDcErBTvZki/edYI8yFEwlyKCn31B4x/k
	 j6xN5+ZIjaHBC0ob6CJz6pWn0+FlGblBUjDWi3ulUKl7e5lIjuwWR2baLBBAH/99MV
	 CbshddnS3zF9W6QG8Nps7bkVMotFH0RLER0n6+Xxw/54ngx0wKejp3dXy08deTuSYr
	 gN0Oz+amFoBEQ==
Message-ID: <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
Date: Wed, 16 Sep 2026 13:24:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Salvatore Dipietro <dipiets@amazon.it>
Cc: akpm@linux-foundation.org, abuehaze@amazon.com, alisaidi@amazon.com,
 blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
 david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
 djwong@kernel.org, hch@infradead.org, hch@lst.de,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, mhocko@suse.com,
 ritesh.list@gmail.com, rvvandan@amazon.com, stable@vger.kernel.org,
 surenb@google.com, willy@infradead.org, ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <aqQlUr-1h07G8JWM@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC31D40008
X-Rspam-User: 
X-Stat-Signature: 5xpbs3w3s68wn1mwjqoc5amdkhgd3exz
X-HE-Tag: 1789557879-121011
X-HE-Meta: U2FsdGVkX1/NwEvCSqhlUQhE/9vqJkumqRRYTjM3n5TeqLNOumurTYP2G8rc2OBe5fsOFjkqo5NTICtK0shs1DSmu465VMt/te49rYXt/COcCp2HODsohlG9dbTKRYcZ2WjpN55P4IvHrJJxFoqpIVUtHkWdQ3hnyRL3NTM6+XoqJoAruibr2gQTJEhJxYhA4/Bq4XBlPLEujHeeID5G2ZRBNiOdUzYfOcoWQNCKicHKJRWn0crzpuIYMeiE0+pidXQrjWaUWIhtN8kZDs5qjEmXBz81WtLkXjLcCreK8QA80ToXTybS2rlp55i6GcEYZLMjkG8opYA+IFUXt70SbCCKR3nz8pjEszN074JpE4e6kWpwi7LUgg/5bSGz53XOZAHq9cqOkJ+tg0QSck42MAfnyFBkqlcya6uLqNYGNpNYSA7vxdV3d1ACYGy375tyIoqBwVlsXNUH4BPA+/LUFPG5bvVFWOu1VbxKVIRAFK5mA4i5FakhQjKB9sFStCvjUMyohn+ByWkhMMTEhcjoVY/MDh8amooqAKvTvNLtOEntjQdh92KcCahHcFt7Jj41VWDHF5xjXpAQ+KIj6JVdCm3vNFtyp9gUhGhV/En7+9usnpHnpi1Sm46DH5TSpgmKSNNYrFLQqoEuMeBuRJMJKGxXnuA1A2W9dxohBbNk4KgCePT6htNUTEKKmhGZ6hg1nDfOSHi0emyDaufnZjpnG2Uj0sX/OFbYFC3FNWKjfVgIzoj361tVAagHPFtl6EWUFh5TNo8vA98Kbx8vz71IdY3cgkIP/9Q8phO97V+RhY1Q5rQp1279xwYpHj7LZpQwl0CvOL/QF2wXp2Wge0he4WRHpL7RYM0mml/1D8e8KnY0qAWFwcqSQjEq/QLqt9aKlbI+TP7z/e6AcVXqrgQlo9NWQuWsvrWV5PoxD6lub7u3TrNAMAaTFebmUzFNxYIyrfg2OBRdVc8rDJM/a/0
 BUhOgS19
 AVE3sApzO8NCV6BJVYlVGfl11oROoFOcSWaqn3yfE5rdfAiE+aDnF2EWuPz/DL4ZzzHIqs/lzPKIcAZL5Rx0W6LpOpf6iKVcTGutcYDdx/PKxoeIgXf4IjAznxjcvOzzgw/iY8OYkzYWbg2B9551TNmVCH824P4H/DWcJo5iyE5EGvvqJm3v67mYt7iB4gFLQlSTTImHmRY+XapxfCTV2K7KF1YvVhbFnfwBp/UXcbNBUjd8GDi8fW0GIWmPKeTcrpTnOg3KdIISR0a7CcdNt7Mf7f4dp0kWjU9FMWUEWfeNn3Dz4N9ffm117BZuMVa+0JPGcz2B8wTQc2KPcouCHD4bqsAFsut8QusjE10I37yorqhn1vq5Xs8WtIEjlRuCUK/B3mbUazWlnIMFvmHFUfp6jSR30ulYWre26M7bx+7For2kJxkp3Tz/tLwr1m9bP5u4m6m+RTnmB8ltJpMefKDe3P5tz3En7AVO50ylT5yeatUjFv3b8Fp//Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 17:59, Johannes Weiner wrote:
> On Thu, Sep 10, 2026 at 11:46:02AM +0000, Salvatore Dipietro wrote:
>> 
>> On Sat, 05 Sep 2026 17:42:39 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>> 
>> > Is there anything particularly unusual about this test case?
>> 
>> It is a stock pgbench simple-update PostgreSQL workload on a large
>> instance (96 vCPUs), using standard PostgreSQL settings and with no huge
>> pages assigned to the database. We deliberately overprovision the
>> pgbench clients: 1024 clients over 96 threads. That keeps enough writers
>> in the buffered write path concurrently to hit the costly-order
>> allocation failure path continuously. The memory fragmentation comes from 
>> page tables: PostgreSQL spawns a new process per client, and those page
>> tables consume ~40% of memory, which significantly limits the page cache
>> and the free memory available.
>> 
>> 
>> > > Results (average of 3 runs, TPS):
>> > >
>> > >   Config                   Avg TPS      % vs Baseline
>> > >   baseline (no patch)       59,408       -
>> > >   With this patch          155,409      +161.6%
>> >
>> > Is this back to pre-5d8edfb900d5 performance?
>> 
>> Yes - fully recovered. Here is the summary, same host and workload
>> throughout, average of 3 runs:
>> 
>>   Config                                        Avg TPS   % vs baseline
>>   AL2023 stock 6.1 kernel                       136,942            n/a
>>   v7.3-rc1 baseline (no patch)                   59,408             -
>>   v7.3-rc1, 5d8edfb900d5 behaviour reverted     151,184        +154.5%
>>   v7.3-rc1 + v4                                 155,409        +161.6%
>> 
>> The 6.1 row predates 5d8edfb900d5 entirely. A different kernel version,
>> so not directly comparable, but it shows the performance this workload
>> used to get on this host.
>> 
>> A literal "git revert 5d8edfb900d5" does not apply to v7.3-rc1 -
>> iomap_write_iter() has been rewritten since - so the reverted row is a
>> one-line behavioural revert, forcing the write loop back to copying at
>> most PAGE_SIZE per iteration:
>> 
>>   -	size_t chunk = mapping_max_folio_size(mapping);
>>   +	size_t chunk = PAGE_SIZE;
>> 
>> which is what the pre-5d8edfb900d5 loop computed. That makes
>> iomap_get_folio() pass no order hint, so the path issues only order-0
>> allocations.
>> 
>> 
>> > AI review asked a few serious-looking questions:
>> > 	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it
>> 
>> Thanks for pointing that out. To address them, we can have something
>> like the patch below. Performance results are still similar to v4. Happy
>> to submit a formal v5 patch with it if you would like.
> 
> The feedback looks misleading to me.

Agreed.

> ALLOC_NON_BLOCKING itself is fine, it usually only means something in
> conjunction with other flags, like __GFP_HIGH.

+1

> The access to
> MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
> seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
> into the highatomic reserves as well, for example.

I don't follow this part. For ALLOC_HIGHATOMIC you need __GFP_HIGH in
alloc_flags_nonblocking(). So GFP_TRANSHUGE_LIGHT won't get the access, no?

> The rt issue seems made up too. We're talking about costly_order &&
> __GFP_NORETRY allocations. Why would they need access to reserves?

Yep.

And the concern about warning is also moot as __GFP_NORETRY is still needed
and its users virtually always add __GFP_NOWARN as well.

>>   Config                                        Avg TPS   % vs baseline
>>   v7.3-rc1 baseline (no patch)                   59,408             -
>>   v7.3-rc1 + v4                                 155,409        +161.6%
>>   v7.3-rc1 + proposed patch                     161,994        +172.7%
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 12fac9084c48..be8b0d72a2db 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4784,10 +4784,22 @@ static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  						struct alloc_context *ac)
>>  {
>> -	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>> +	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>> +	/*
>> +	 * Costly __GFP_NORETRY callers have a cheap fallback to a lower order,
>> +	 * so don't stall them in direct reclaim or direct compaction.  Exempt
>> +	 * __GFP_THISNODE (the THP attempt from alloc_pages_mpol() needs direct
>> +	 * compaction) and __GFP_NOFAIL (must not be made to fail).  Don't
>> +	 * clear __GFP_DIRECT_RECLAIM from gfp_mask instead: that would also
>> +	 * change the alloc_flags derived by alloc_flags_slowpath().
>> +	 */
>> +	const bool costly_noretry = costly_order &&
>> +		(gfp_mask & __GFP_NORETRY) &&
>> +		!(gfp_mask & (__GFP_THISNODE | __GFP_NOFAIL));
>> +	bool can_direct_reclaim = !costly_noretry &&
>> +		(gfp_mask & __GFP_DIRECT_RECLAIM);
> 
> IMO this is worse because now there is a disconnect between these
> flags and the gfp mask again. This sets us up for subtle bugs.
> 
> I much preferred v4.

Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
concerns can be dismissed and then indeed v4 is the better version.


