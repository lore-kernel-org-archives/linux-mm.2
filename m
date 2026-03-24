Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D1CF532FE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65E16B0005; Tue, 24 Mar 2026 05:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF936B0088; Tue, 24 Mar 2026 05:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7096B0089; Tue, 24 Mar 2026 05:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7666D6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:10:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29FC15FA4B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:10:50 +0000 (UTC)
X-FDA: 84580386660.17.A5F0793
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1DFE214000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:10:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774343448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBYVKUDdLrM3qX3kkWGsUr4PJz86tpiGeFlMn8aHI+o=;
	b=vdBWdCeKXzdaBbCggPCrUX73pXSsKUwsJPLTdMlIErQyYstCQlU+RmX9wQZAQu8CZl8kGn
	D1tWi5KOaBvDa4PdHmUwtyxfA0VbeqHr97TLKT4FwpOcCN/jzLVYUKUw577fBD8QU+Vvzh
	54mNzABxJC1F/MSESMHUrbhJPrMbdVA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774343448; a=rsa-sha256;
	cv=none;
	b=Bd85BjSmrjW22GmCYSjzzd2XA7vjK0OX3NJVcYHa7mdw1RFQvUGEorjm/dxUHm2k8agQCK
	AssOvLDI5hG7J84JTFonFT4Aw/lUrtgG8kFW5LBdLnuoY8nd5Ih4ATakqwb8PJ6r94Y6Eo
	sximzGZh57v7gFyoq/fAfUbbnasPghQ=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fg44V5625zKHMZX
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:10:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 976684056F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:10:39 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgBXp9cOVcJp9ZUrCA--.30839S2;
	Tue, 24 Mar 2026 17:10:39 +0800 (CST)
Message-ID: <ecf00130-ad30-41f1-81bb-cc9e1d360c52@huaweicloud.com>
Date: Tue, 24 Mar 2026 17:10:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
To: Kairui Song <ryncsn@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com>
 <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
 <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com>
 <0427249d-c6c7-477a-aeff-e007198fcf45@huaweicloud.com>
 <CAMgjq7CGhMsf4qWrW5O-s2AP7BwpbpPahEFkd-u3Q9jGFGCeZQ@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CAMgjq7CGhMsf4qWrW5O-s2AP7BwpbpPahEFkd-u3Q9jGFGCeZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXp9cOVcJp9ZUrCA--.30839S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF45AF1xZF4xCr18Aw43Wrg_yoWrXr4kpF
	WDKa1jyFWDJrW5tryvqF4rtryYkr93JrykXFn7Ar1UAF9IqFyfGa17Kw1jkrWUur1rCw10
	va12gry7Wa4YvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AK
	xVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wryl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxUxo
	7KDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DFE214000E
X-Stat-Signature: q991s6eu4c4oozzy7uootgq6nk3et5rs
X-Rspam-User: 
X-HE-Tag: 1774343443-276856
X-HE-Meta: U2FsdGVkX18hAp8WQbMhoO2VaAHZ1BOzuqiLDNmgp5cz3Op2jxBw/SS5RRUiz6tf+vOrfC5+hXf/ILTdmU+P1U5RfVQdQgZ67TPjb3u+KSGTlxAhyIdgFlJawVN3Mb8S/bc48mlcqFoZhF5pwDKPurKEp2Ucp4ZLfqci4TCvgFyKOCGAHdU2NqYvW9GNhBFKwxWt9JjBAZIhzLmoESAZ8vKPd+6VZC7xY7VpsyE88iWumvFs0tgsM5CrjIf8n0PRc6adQGGsYAJKZeEHwsavs3tVqpFKqeHZsYVw7IheDid4bqAkFj8mYCb44vyI4m/Bc3bmBjReqEp727e7rjSSG9it+Ebz/y6MwwY3JQhU20ATQ8pIqHvN0QklZDiXRfZYE2zof1aBzPnCDrLJporS2fyFFBmxNZWJLZYf43SxK1diE2ECwaGD8YtLxlY5MIV+UZWza6HrcajIL9A6W32QuL0cF8yeslNzEHKOBa1nzMPcIJWTPOnXP67kvda94a7CWcrvQPZi2zI22h8pKW9ZNISktX/RBsP1FuE/b+oabD1Puna/GIQTsmMPIXzyvT5Ws+Es8sjeTRzFCh8UZG88uK9x9U9zR1G9IuFowov9crf5cwGx4iDeZkyr3HGaUrZ/iJfCwzd4VjvvMC48mxAn6yM5+TDWPPLVozNId3gLTA6BUCEqhvyssouHBwpbfQOg9VQh4uWj61WwuwH5sdzEd5AAF8GQrjvu9WtoF/KadrCwsBNq1vEpRXYPLa/6dvaNRjmgaybikL8OP4aEfT1SGyiRg9VA6T83zdoeBRMyOBp4oo5sm7Muc1lfjfpRfXD5iva7RaSIkPn7Q/2nA+PLpoi7xIG8iUv46mbtQM21mh1F2EqZpVBA2WAj/0+EeiBrStl9TAeyJncr04Ak6zJccR/+MuVlGsacj509iXJ6Pk7oAE2A414QssPM9chhh4U3maDgNicY2bxNJzMbt+T
 HqdkCK7F
 5fZEgl29OMPLIlJxfGvbTwn8DkSqcg8sXkFt7nTiFdZXSXLk/UueLLlTjoVfikVde6qFzoNKHzS8bzfiH1uhSpK59IByOB8nm88d7nSZEHfGPql7ckd/gPMQhMBP87zTnbxbJDYfQ/HlX4ScoSGiSoAe35jEFEioMY4eu2r98FVlPFmzlA9N/+BwbbANq31NHUpXtdDOwrRwozaBtzD5/XemJUWWAdIGtUG3CT4zstXKQMvLv8rstC4e/It3ZX47wgea710OjnMVKpFDVm/OvnM/ocX/h03be1Rq1WJYsbbQPKWnUlcNuKDdbzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/24 16:05, Kairui Song wrote:
> On Tue, Mar 24, 2026 at 3:22 PM Chen Ridong <chenridong@huaweicloud.com> wrote:
>> On 2026/3/23 0:20, Kairui Song wrote:
>>> On Sat, Mar 21, 2026 at 4:59 AM Axel Rasmussen <axelrasmussen@google.com> wrote:
>>>>
>>>> On Tue, Mar 17, 2026 at 12:11 PM Kairui Song via B4 Relay
>>>> <devnull+kasong.tencent.com@kernel.org> wrote:
>>>>>
>>>>> From: Kairui Song <kasong@tencent.com>
>>>>>
>>>>> Make the scan helpers return the exact number of folios being scanned
>>>>> or isolated. This should make the scan more accurate and easier to
>>>>> follow.
>>>>>
>>>>> Now there is no more need for special handling when there is no
>>>>> progress made. The old livelock prevention `(return isolated ||
>>>>> !remaining ? scanned : 0)` is replaced by the natural scan budget
>>>>> exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
>>>>> folios to newer generations.
>>>>>
>>>>> Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> ...
> 
>>>>>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>> @@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>>         struct reclaim_stat stat;
>>>>>         struct lru_gen_mm_walk *walk;
>>>>>         bool skip_retry = false;
>>>>> -       struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>>>>         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>>>         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>>>
>>>>> @@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>>>
>>>>>         scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
>>>>>
>>>>> -       scanned += try_to_inc_min_seq(lruvec, swappiness);
>>>>> -
>>>>> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
>>>>> -               scanned = 0;
>>>>> +       try_to_inc_min_seq(lruvec, swappiness);
>>>>
>>>> IIUC, this change is what introduces the issue patch 6 is trying to
>>>> resolve. Is it worth squashing patch 6 in to this one, so we don't
>>>> have this non-ideal intermediate state?
>>>
>>> Well it's not, patch 6 is fixing an existing problem, see the cover
>>> letter about the OOM issue.
>>>
>>> This part of changing is just cleanup the loop code. It looks really
>>> strange to me that increasing min_seq is considered as scanning one
>>> folio. Aborting the scan if there is only 2 gen kind of make sense but
>>> this doesn't seems the right place. These strange parts to avoid
>>> livelock can be dropped since we have an exact count of folios being
>>> scanned now. I'll add more words in the commit message.
>>
>> This change confused me too.
>>
>> IIUC, this change looks conceptually tied to patch 3. The following change means
>> that evict_folios should not be invoked if aging is needed. So the judge can be
>> dropped there, right?
>>
>>
>> ```
>>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>  {
>> ...
>> +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
>> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
>> +                               need_rotate = true;
>> +                       break;
>> +               }
>> ```
>>
> 
> Hi Ridong,
> 
> Ahh yes, as you pointed out, the explicit should_run_aging kind of
> guards the evict_folio. That's not everything, besides, previously
> isolate_folios may return 0 if there is no folio isolated. But now it
> always return the number of folios being scanned, unless there are
> only two genes left and hit the force protection, which also makes the
> judge here can be dropped.
> 
> But not invoking evict_folios if aging is needed is an existing
> behavior, that commit (patch 3) didn't change it, just made it cleaner
> so we can see it well.
> 

Thanks for the explanation.

Would it be better to combine this change with patch 3, rather than adding to
the commit message?

-- 
Best regards,
Ridong


