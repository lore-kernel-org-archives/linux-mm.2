Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635D2C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 01:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5684B6B0088; Wed, 19 Aug 2026 21:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E966B0092; Wed, 19 Aug 2026 21:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EAE6B0095; Wed, 19 Aug 2026 21:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4E96B0088
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:02:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0743A06BC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:02:44 +0000 (UTC)
X-FDA: 85119847848.19.B24FD2C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83698140009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 01:02:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BN5/LT3t";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787187763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUw7pNGt/Yy5cHbPNU1onyvXNSn7k4oj0Wg482Px5y0=;
	b=xTS5zwCOYLy3zHJLm04bZWYGYL2mJYKRimQUxc61BFjCzsfUnzVIJJS/1LHtGunmdJa5NA
	tZGOPUFcK3vp9aMZgsd/AtT7ViND3Y6p8j/jeAXEuFqU49HLlSdvyqtxoNbCFtKmnpEFVw
	S1pkqbObvXP3ErrOIn7pai3wbrZGtTU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BN5/LT3t";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787187763;
	b=CbxrJsBs1mxpYDhiyw/Gg69j8JXiSuAP75YuxiZhOysPl/7r1SRkJ1E5fOIbysWfnQ4G/7
	tvWIn46OR2vw9bykMCUmGHJY85wRvcN0Ykb4JEtOpCOO6XTCZHGfnlcz31FQmV67jR6aMb
	xLWb75FbRusWYCKV/s7fTlWQZMrdJTs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787187758; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tUw7pNGt/Yy5cHbPNU1onyvXNSn7k4oj0Wg482Px5y0=;
	b=BN5/LT3tCvepRYCX2cCWUIHbdHlsVwWnJrGnGklHxl0uAtX0Chv4h0PUXS6uEd8mc/Pygb2t0Ai6qNoSaxU+bwEFxcvwrRODNOxBqPhKg6skgG2cPv0lmMakyGZqQ+QADlPwZcGV/sFx+wrJ8/CVJWhKHIiZFulxncE3uViFLhA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9Hn7GZ_1787187756;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9Hn7GZ_1787187756 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 09:02:36 +0800
Message-ID: <144f8a6c-8f1e-4793-9ed7-78f06b0e93c4@linux.alibaba.com>
Date: Thu, 20 Aug 2026 09:02:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm/mglru: improve code readability and harden
 folio_inc_gen
To: Baoquan He <baoquan.he@linux.dev>, kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-7-8dbbdac0d28c@tencent.com>
 <aoZQD3b6q8s-pXU0@MiWiFi-R3L-srv> <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aoZQ7oUMupCen5H0@MiWiFi-R3L-srv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83698140009
X-Rspamd-Server: rspam07
X-Stat-Signature: 8my9jb7qzxtsjw6ywqbh5ydp85nu46ee
X-HE-Tag: 1787187761-943296
X-HE-Meta: U2FsdGVkX1/VJL3dTv5XMDnKjpdPE+Mc1998Ow3ZV8kuFVdmUXHK7FQWiLL1wx7MAx3nqQh4Xo0DUqc5j2rRtnBfGTebqrKh8nBGM3hTUTuMjBz/PoWeZ9Ga+ncZlW1ZS8TwmbliOyEa9Rnl3y4sDAYlzfmqDmq59Qt7OdfD2WgyIhPP0GbQEg9Dz78/sc9VwDLsetPxXxZEz3nV3xTXcRnm697L1yVuMcsmaDjyFb6nMyrB2JKApCZZCl8eQgL4JJhF7IYJpN/OeoxGDXP3wvCvfH/HA6FUtn9hhTO47xayOBWdytr+V4NeoALPJvkW6/po9lxNayr91s8/hhnP1Nek4pEQV+m1i3SoQkl052P7QI2MJGb7ksN2tuQgDdrj7al+hxIWWD16vCiR+Wdwx6j6e2Y92PLkR80iZLh0jcKCGHS48ZqH6jtMHweKC+62id+cj8e78mwNNFrSQuuWsMSKht09nPKYyguFO2tG4CgCFPdCOfuLhOtt5KIkD8hrkY4Po2DK4CcMmlqgiea6Z1LzDOr/kAWprtadGxZBe56bLen3oIqgiG23UjqRZ+O05W6ICYwu2iIQoT3mLmef2meDhb3Yi9mwKJTxF5hxWIVNWK7GxEdEccZVxZGknL6Z6MiaL744Y93KFd/5MiNoL3ikfu93c/BWNhfQAlcZnSWwPHm3uVSuLartIheAx25+s4/xmzjsJ8RZ7U7LYbj/Kv4CclMyrENUu1CvP1sRxu/DBkEHgFOyJVTpE5Zguum+nc159xmzpmIuHGx+clrxyKcN+2WI+HBysCCqvQe8+TqDAxaQ4sBW5KRsOj+QRJD5Zd/PStN8zQQ0V7JhpQwRCipSArF0uLf5QUGaW3boughJuudeaB7SpdkO1lFrTHKSGm7sjt/FSjy+u+/3SjIEhFrAjH4bJKcDjQ+mAWQbgQ8cJ3l+iafdR28ktgUv8j3+huUsXFZ2bKDnG4XykwC
 COsuFBOw
 TUVmhsuYDqL3DuoACazF37aYUB1It7ISXV0D7cqktY2/S1We7A1qNGjgqVxIpsXpQqh45hLzOGLW2fE+FgwTbJ1NPEws7OLI1WebVNzwnYwn80EInF2dRM3DmjiuzzXYGwl8pcsckMxkdrVxNhuhFV4oZn15nl3MuZb5a0PZ22cBVkLnMcJKAoNtZi258RNfsxmWgIGA6PDHl1BGjXGi8GOWXgadpGKTCHNesviofNWbehyTFCQVSgr4n9fi6tskqy50G72jS+Lx0MngiUfRZ+DrV4PzWh3POTDE9UoDkyGoBlwsKSYrHtQJG3uycHJO1UqFmwiIYN8Y7teyPVwTh+QgWo6KUvSEEMy29XSIlZsHe2kiVsnmMxTgLl7KRIg/RET5Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 8:57 AM, Baoquan He wrote:
> On 08/20/26 at 08:53am, Baoquan He wrote:
>> On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> The helper should never be called for an off-list folio, and it always
>>> expects the folio to be in the oldest generation before doing any
>>> cmpxchg. Add a sanity check for the off-list case: if it is ever
>>> violated, bail out and keep the folio flags untouched to minimize the
>>> damage, instead of silently treating the folio as if it were in the
>>> oldest generation and promoting it updating the flags to an unexpected
>>> status.
>>>
>>> Also rename the variables to clearly distinguish the folio's current
>>> gen from the oldest gen.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>   mm/vmscan.c | 14 +++++++++-----
>>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 7169cac60869..7e3ae0c6cba3 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -3308,18 +3308,22 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>>>   {
>>>   	int type = folio_is_file_lru(folio);
>>>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>> -	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>>> +	int new_gen, old_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>>>   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>>>   
>>>   	do {
>>> -		new_gen = lru_gen_from_flags(old_flags);
>>> +		old_gen = lru_gen_from_flags(old_flags);
>>> +		/* This helper should never be called for off-list folios */
>>> +		VM_WARN_ON_ONCE(old_gen < 0);
>>> +		if (old_gen < 0)
>>> +			return min_gen;
>>
>> As Barry doubted, I think this change is wrong. old_gen < 0 in folio_inc_gen()
>> could only happen inc_min_seq() call it. While inc_min_seq() call it
>> because inc_max_seq() need increase max_gen to max_gen + 1 and found
>> get_nr_gens(lruvec, type) == MAX_NR_GENS, it has to move the oldest gen to
>                                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> 2nd old oldest gen. Here returning min_gen for old_gen < 0 means it will
>    ~~~~~~~~~~~~~~~~
> Here, I mean it has to move folios from the oldest gen (min_gen) to the 2nd
> oldest gen (min_gen + 1). The empty min_gen will become the new max_gen.
> 
>> be put in the lastest max_gen. It may not be expected.

But how does old_gen < 0 actually happen? folio_inc_gen() is called 
under the lru lock, so how can a folio listed in MGLRU have a gen 
counter < 0? If this can happen in any case, we should fix this bug first.

