Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B674C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F98E6B008A; Wed, 23 Sep 2026 04:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1636B0092; Wed, 23 Sep 2026 04:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7C46B0095; Wed, 23 Sep 2026 04:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 478B66B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:44:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8854D406DB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:44:56 +0000 (UTC)
X-FDA: 85244391792.01.7EC28CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id D094140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:44:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsDbq499;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790153094;
	b=of1HYKMJ0egz4TCQYPlwtY1ztTNQTJvp/1Lbe5LGaRT6xwZL6SsbYOMQMbx80HxLKiEifU
	om+oW8QiaRlR+K9KEGD6gEKxkTec6fFPhdmr4XD/9NvBCMag3YgwPRgm6YX8G/9FTtWPkh
	0axonUTLn13A5KRXksgG3EfNBXvu0Fw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PsDbq499;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY70oSqWd3wnF9uaYoNddYkhSPpCt+PYpUwK3owu2yk=;
	b=O43xHqdQTAlgjvphpiLIcoyS9JAnMgJ8KjkHWAuuZiOMoel39AgPfImaWU+vuJ42V8NyUl
	7J3ojra3PnlM4sZ8Pe4shrDTJAKjRQvs1L4dyOXexV+cbBG6CoGcyKnHzWBIT3VH+X8R2u
	RHk7jvVNZXlxX4tkmmDMLi3wC9ntIu0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 679176020A;
	Wed, 23 Sep 2026 08:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA611F000FF;
	Wed, 23 Sep 2026 08:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153092;
	bh=dY70oSqWd3wnF9uaYoNddYkhSPpCt+PYpUwK3owu2yk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PsDbq499xXwI7h+xbBrfr8RDigs6n45INpRpjLXHhwjVVCVAZc7kW1YcfYUx/PhE2
	 fjri4U1aP9Y22xgAwgdg2fh3N2162ZyeGfV3J+x4l19s/SCcDU0W5SoRQot7F2NTyU
	 ufj9byPIii6EmaACI4mzR1lZXMUI/b9iGqZWrDZQCwX3vOn+AH8uH2qNJm2uXvpXMB
	 y7uVL4tgUslMzJOdrW4Svd2fTpX+L2preZqCCrLohyDKQJIhAQ5lkoQQZZcqH6JqGX
	 VtPF+5v+O8pmekMtv+EHpHAAKRIddhjG5TluWAqMIEhOr+k/e4nrYBXk2Vj0pfiZYx
	 GQsaYnTFyujnw==
Message-ID: <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org>
Date: Wed, 23 Sep 2026 10:44:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
 willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
 chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
 hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921152449.629486-1-alex@ghiti.fr>
 <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
 <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org>
 <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 7c13gszmzxwbyzo9gbnyxdm7csog5xgd
X-Rspam-User: 
X-Rspamd-Queue-Id: D094140007
X-HE-Tag: 1790153094-877509
X-HE-Meta: U2FsdGVkX19uGXTgVOEk3F/rnCJ6pPL3T2GOXaaHZOx9KpRd9Yq4UAFFyuejT29s30DO8A9Wxgg6AD8mno8ikw/pqW0/f2ePeoCMEF1Njav3LbAIsa8kiHpypbNJVz5PbiG1Ekv8zwxhkIO/CEdGHNUi7e3EItXqD0uOwGfb4aAZZQee3WmIzsd7VqJSCxvkW0O/UvoX4qgjF1JBvVbHPYbOWVX7/HEjCGPdXF0oe2IXutv7YaUzCZf8olJQx5K1cpWDPaLMFsKm5o3ocCxHGvqPH7/boU+Zp2/QSGE5GZGp8gZbeM3KUD+NOhFl5t0CtAmdMx88116Fqq/D97UTVbZqBE5OTjRoQ7RW6dtOV6/1oEe6aldBmAe+oWwyknLcD8F68XZ5G0QtlAJVJX0KMTj9BFdUTQZ4I4/QJd+TtK00S4tXNOAsQWxVVxP75uL6LJuZFZIG6HNpVyypcmIlHYVaz4xo8JHfyLoZeoW8mqJTmfjNnaET2zkrhK+YNcHunlXB9iEJKUTCbpZ9D2E7EHqM9e6nARDxvnssHdPlvijXRYqfMMuv6gXAObg1XTuy5cuLsysxgoFAduK7vEezlQTZF74GkHRlGFMZW4SN35n1YPSl7mWZ9FBDHcLd17gvjJHzTeSuGAceXQo7dDMvGckWVAGyoAPugwHVMowyc2Nmts2MUoT+PWeqkm/QErYgcjB88fTKdYyh3vtwJmxIVJkSkHVWajpNBI6bm8aSjsVXEMM7QVXWlVdSjxwNskrBX/4xojFGaesMODdcX8xWCtx6YvIQdBnEzYQAwyHJESWu43zpwhertq5tE37AqdPe7+zedBBL1JfAU3uLd9mlU9qVbmBnDRXbW5M4O1DrObbwM/naqQkfqqWh5v6idGki2JnRzhtxTRbXeZyceAPwgYHA70oSxjKFN8wsZxk0TQWVQZ6t3iR/oIKx4ndXeu/j0VT4Fm/iiPiKNqVDf34
 Mm3CBr7e
 6+etYRGRL7/ky+XLUjFEDOHQXSj6shVD2SUfgltLmmMLW01fyaD/r9dT+W6n87YZQa/FKASEYNJ9xvjhC17sa8pJrP5romkqU6hM03Nat2+6CeW9Kl4GZIUDOhWkoQ9C+L9fk6uw+peMarWv3dCb3iY+Zvk5qgV+xWDhx8r2Fs9NxbBmPCzMpua/wdYzryjCnO7jAIxNGpaKAV5ZOJRNaIAWqhYdxGGzrI5ejsaqXTJq0BoRevbvrGiOjddx1b1mpAr1MAld9trhPRml386yUu22KqvF/+CCwIUFGsakKVCAZINc08jxePMXeHD3YwkKZsc2S8CaKI3uluAkDFFoqLKJ0X5ZABwXxhwj5/7C+7DQcQ67NYc2TIorERfFCRMWNeYN/MyoQi003fyMqAmckkIt0zyCehtx3q81VUoHcqKarNGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 22:55, Barry Song wrote:
> On Tue, Sep 22, 2026 at 7:26 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/22/26 12:37, Barry Song wrote:
>>> On Tue, Sep 22, 2026 at 6:20 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> I suggested this to Alexandre, and he found that it could regress some
>>> workloads [1]. That is why Alexandre is only making the folios
>>> immediately reclaimable for `MADV_PAGEOUT`.
>>
>> I really hate to add special sauce for MADV_PAGEOUT. Also, I don't quite like
>> that we do something fundamentally different for sync vs. async.
>>
>> I assume, though, that async writeback that is very fast might just find the
>> !folio_test_writeback() scenario just like the sync case. ... or if we
>> reschedule after pageout()?
>>
>> I am wondering: if we can show that letting async swapped out pages stay in
>> memory a bit longer improves performance, aren't we swapping out the wrong pages
>> in the first place, and not swapping them out would help the sync case as well?
> 
> I guess that's because the LRU is not always accurate. There are cases
> where our prediction of future access patterns may be wrong, resulting
> in refaults?

Right. But these would happen in both the SYNC and the ASYNC case. Which seems
to indicate that making the SYNC case behave like the ASYNC case (keep in
swapcache before evicting) could actually improve performance?

Or is the SYNC case in general so fast that it is not a problem and the
swapcache is just not a good use?

> 
> Even on Android, which uses zram with very fast synchronous swap-out,
> I can still hit the swapcache from time to time. So perhaps with a
> slower device, such as an HDD, keeping the swapcache around for longer
> could allow applications to hit it more often?

Why is that specific for HDD? It's the exact same app behavior independent of
the underlying swap technology.

> 
>>
>>>
>>> See Alexandre's description:
>>>
>>> "Future work
>>> -----------
>>> Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
>>> prototyped dropbehind for all reclaimed swap folios and it regressed
>>> sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
>>> immediately turns cheap in-cache refaults into disk reads and collapses
>>> swap readahead clustering.
>>
>> Thanks, does this represent a workload pattern we care about?
> 
> I don't know. Maybe Alexandre can share more details about this
> benchmark. I'm also a little surprised by the 15% regression in
> Sysbench OLTP. My initial feeling was the same as yours: we should
> release the memory immediately after writeback completes, for both
> synchronous and asynchronous I/O.

Right. And see if we can identify why we are swapping out the wrong things :)

> 
> Kairui also mentioned to me that he once tried releasing memory
> immediately after folios were written back to HDD, and saw some
> serious performance regressions as well. Maybe Kairui can also share
> some thoughts on this.

Would be good to find the root cause for this: why are we swapping out these
pages that are immediately needed again such that it affects performance that
drastically.

-- 
Cheers,

David

