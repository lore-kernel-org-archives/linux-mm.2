Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E62606D27E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dA0CDzK7
Received: by kanga.kvack.org (Postfix)
	id BACCD6B00EF; Mon,  2 Nov 2026 07:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DB56B05B9; Mon,  2 Nov 2026 07:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A738E6B05BA; Mon,  2 Nov 2026 07:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87FF36B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:21:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2715B1A0A7B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:21:56 +0000 (UTC)
X-FDA: 85390090632.23.3C2E07E
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	by imf24.hostedemail.com (Postfix) with ESMTP id 912D0180006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:21:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dA0CDzK7;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJSyYvwSTzmhS0c4ngcLjWN7ivwDuselzLolPFvY7As=;
	b=NfA8jrEvjhmzZe3m5FzAamYH0hZyTh3inHBAV5d1/R7J1k7gPmr29GgAQXi+zopTM2JL4c
	c1rLeaRZUaB6pj6/UBTUNy6u4R98x911K3UvqW5q++0l4soe76MxtDA5yJzxHRxOTP47oA
	NENhJtLOb5rWWr3IdkM5v0kQYD6GRog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622114;
	b=T5TF4ZUfyo7DenzqPIA2/NB3w9/NfhyMOuVIahtOabbRxWakPRDRxCnatv5tdAezLsytiJ
	lhjGqaPHyQyg4TwNFTbnMNdWUeaE/aTXRs+hNMDysZ+Yv8kfrC2tefuWbLKQVGOg2PcS44
	s93W4GA6NC1v3N/JWsxMqCnxo40nRLI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dA0CDzK7;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lJSyYvwSTzmhS0c4ngcLjWN7ivwDuselzLolPFvY7As=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793622109; v=1; x=1794226909;
 b=dA0CDzK71lJ71M/sITtbRlzp+Kf/xpD+E2K26L7YrV902jr3Fl55n1PA+Lh5DTJKExQSKV7K
 Omhv7xt5lDdanGpaDl380/dvsJaL46wIPHruxXFpWBvHYdeR95CyPWqCIP8okGbaC7247lr8A5U
 3mEHCfLOuA204SJqx8uusq3I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 98fd0dfb40fe473a;
	Mon, 02 Nov 2026 12:21:49 +0000
X-Mizu-Trace-ID: 98fd0dfb40fe473a
X-Migadu-Flow: FLOW_OUT
Message-ID: <0368f299-52e5-451f-b1f9-19524af0e931@linux.dev>
Date: Mon, 2 Nov 2026 20:21:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
To: Yosry Ahmed <yosry@kernel.org>, Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev>
 <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
 <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
 <auUZPZfxNNBCH5uf@google.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <auUZPZfxNNBCH5uf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 912D0180006
X-Stat-Signature: uinuoeoxwmk6qiuzojnc6tf9iqcwg961
X-Rspam-User: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793622112-776568
X-HE-Meta: U2FsdGVkX1+isHlhhW0zLHjgyICnSe0NBjD+LXv34+JUHJgbZkLmRAOEdy1k3jzumS3mHhIlolimef/wyFBXio6AewE1Dt0C/4MeQiNnTwsbT4zGQFpLYRhTV0mO+qSDcBYR4F3iELPKPD6Wsql4viX+L5S3OV8LfpcLvGcxqwZgGhQLjhZrMnOX5WDgah9SD6dURL5ef+pNWts1MXvMDOxj0DMs4Yd2ZmQafFaoUKpSSheCbHNhBeF8BQ0Kp4UzUmzkYKDvUkFJ34xbNf/y8E62orxHdXS1fHkSOgCFT5c4TlJcACHedfbNQr+YiqRQrS01BNa9fzwoEQt/r8iLHDVQY5CV8qHhrqhuVQQl6tTotkECvlGhFDspfc1ftB6lgXFeGbq1fRVOpFQJt4ljYwgxUpMp2qgb61644ZJ6PcTpDVJH93r4za+MTksq2IdqRNF6cFYlboAFm/vgDx9P4du2aFKA/6xoHgJ/+ZdybT49Q5MDTsY6scGjB8V8jB26ULNd5KJAJFZPn1qJfP8iFAMQyx+B/eImR2svZH5dSk9mVSk3fqG/s1Cw6fuWNHq39ifuhTRfLJQB4lcvdUP0Ui7StvhIbGkD7Tm+QrAXelR5Pvf8v6gg6EaPuL+RjOvyMteZ2QT7C+naEN6TzoZkijtzAx0jTlcD2tM8bbAsxFM1M9EFKcccbPddENm8D5puiOC9QhCW96R/53q9AsBWi+9qpRZZb9NbGuCZReBtmqqFC4wm7Q+G4wO9aIHagjDJ0m9HmPPOZXodUzB7U92F+y0NpWglHFJYtnHVnoukwyFa4oBArouahw3PsN2Btgcmeq7mdxYX9rRXLqAptR8jBMyP4NR3W9Ubfo0E3uf7cujMDRZUeie5hmvmH7QVTJNij2xwijYlNsWgYfjQeER/1s1lYxpbT763r10M869W8BLUFzcg9O7gBrx6XmGwdWLMdzYHw1D4vNPOc4oMlSL
 Fm/LYUS2
 bMrbj4eKNNS4OEkngjSeADCFwjjQOAy19WCI6y0hqkBLWvLXKwAA3HkW4cwr1ccu28uMbeozQreky4cpk4h0VEYvSI1Qpwn+5TsSpO9NWZgxSHx/Q81eR93MMxOS+6gQrrdC0p2I3Uv/DB6+xEBccu4naMH5McrARKw6iKmqomhu0id67T5jc3lo+Q+VpFqxTwKKZ83r6S3F9VY/PNk22y23STGilbyAhir4a0uVwSUDhNAxdZgYUVcLO4w1uxSgQoss8fx2ghn3jE5uQ5CwX6A5M/gw95zsOC77mRiMNhJOV7SXRMwPetKpUsnWshS5QWJcHMhF8J7sSalAzZAqeMNU0qGHNR3AET63A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 10/31/26 6:32 AM, Yosry Ahmed wrote:
> On Sat, Oct 31, 2026 at 03:03:26AM +0800, Barry Song wrote:
>> On Sat, Oct 31, 2026 at 1:52 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>> On Fri, Oct 30, 2026 at 2:53 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>> A memcg with memory.zswap.writeback=0 can only swap into zswap. Once
>>>> zswap stops taking its pages, because the pool is at its limit or the
>>>> memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
>>>> dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
>>>>
>>>> shrink_folio_list() only learns that at the very end. Every folio it
>>>> picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
>>>> back to the active list, to be aged and tried again. Each round costs
>>>> a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
>>>> frees nothing. The folio also stays in the swap cache holding its slot.
>>>>
>>>> The obvious place for a zswap check is can_reclaim_anon_pages(), but
>>>> it cannot go there. Zero-filled folios never reach zswap:
>>>> swap_writeout() marks them in the swap table and returns before
>>>> zswap_store() is called. They need no pool space, they are common, and
>>>> a memcg-wide "no anon" decision would keep them in memory for as long
>>>> as zswap is full. With zswap full they must still be reclaimable.
>>> I really wonder if we should revisit not swapping zero-filled pages at
>>> all, and instead mapping them to the zero page read-only (and whatever
>>> the equivalent for shmem could be), because yes, the right place is
>>> can_reclaim_anon_pages(). I don't remember what happened to that
>>> proposal, Usama do you remember?
>> Hi Yosry,
>>
>> FYI, I recalled that we discussed something similar in this
>> thread too:
>> https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/
>>
>> It would be nice to see an implementation that maps
>> zero-filled pages to the shared zero page.
> Yeah I also found Usama's attempt and the complication that were found,
> unfortunately it's not simple:
>
> https://lore.kernel.org/linux-mm/20240604105950.1134192-1-usamaarif642@gmail.com/.



Exactly, it is complicated.
Taking zero-filled pages out of the swap path doesn't look like an
easy thing to do.


