Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B8DDC79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CF86B009E; Sun,  6 Sep 2026 23:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CDF86B009F; Sun,  6 Sep 2026 23:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD516B00A0; Sun,  6 Sep 2026 23:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C916B009E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:27:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E401140603
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:27:10 +0000 (UTC)
X-FDA: 85185530220.04.29C77DB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3BB631C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:27:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dIG2kUiU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788751628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K26RqE9msRMaYisynjOqHw8QIY6pFVDP0+pz+DXoGQ4=;
	b=rhmslpYhZWlPruYXRYc9zuaMddSsuH9YNWKOGJtDOv4GIRni5oOc0dlHi3Fo90yXo+gS0i
	Tg/7ieZV2p96SuyoHZBu31m4nSz6MosDHfTY0u6LfG8RQsNVNrO4jEWFG8pdkooQ1xSE0q
	HRlzxReUGtLMiaZZzwBht4o7Hv0UfSs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dIG2kUiU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=yizhang089@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788751628;
	b=fHNtHWDNEznTLRE7FaglweT0h8FlASzyc1vb6zpzc3qjmDzDlD4IAd3EMj4o8tJ02deei+
	BJ4fwxM1Y+l255yHlLx65bqUefxbrkCZiIvWFSKsB9VP5qFK6Pj4baqpAb1+MGe7nct1WK
	PgT77GlOPZ26celIT8MW9/vgMdJscUg=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-86265451beeso1213488b3a.0
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 20:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788751627; x=1789356427; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K26RqE9msRMaYisynjOqHw8QIY6pFVDP0+pz+DXoGQ4=;
        b=dIG2kUiUdI2z1ifzteTKwuOUGtkO5EdCL4VzTWOvCChJFwlSAR/EIXoaBzqvLY6dXm
         G3HLyJL/VXVtGYahwqTw2hPDipDDo+JmLadwEfaxPnvEClo3UQMCmszI7Er98QOrgJGH
         jL83rGSFtC3lf4oGarXQDqKxZ1EtgnM1FWUd46zqkvtvnZGoSjkdk2SErR1EFHINL8Qq
         RAQ9IlODdjMq93HZvUw7QfMYYS8DnAcAX6xb7Vn6GgVMUrGvVugMKc+ZuD2Pu90riWlb
         Z3fMYA5es178bAX0BG7xEDutJzR5WFB2UlRKlaN4IFLjDlVWTf4MFDy4GqDmTfWPv8vE
         cmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788751627; x=1789356427;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K26RqE9msRMaYisynjOqHw8QIY6pFVDP0+pz+DXoGQ4=;
        b=jn4l/8cS2Zf/3HpKO/r77D9EWGw91tDkhwYxQSjcD/r4Jdm30ASsAx0NQ03fxRaXxn
         CCXRk9q+zLifHOGyrkrw4Mu/lA9Q5bpZ5x4EUw8De6kp12ETwR3bSvmlH4d7Gg8KoR+S
         ju8m8wPrnhvqXcWVw+iVlPrcE/KaKupBMIjpWN1Hd2XJzZWRgSYcxG1qO0nDC2Fgroa2
         My7ekkHS8Q7rUDoeL9ZywNbW8nfQLYFu81pPvhgTJjzAXs7aquZsX6r3+wtdMtU/GeeN
         jN2+mB7c7E/bhnIdKWJyIeLeNuxhwX3xu5GflbECVRgmgJaZnbY8jtqnTdj9ZD3MR4zh
         vC1A==
X-Forwarded-Encrypted: i=1; AKwUvBxTsH1IIa1B5ayc6kaK0aYocd/dsp8Y3q5hCsTR83ZG130vsnL+5JpOw6KSn3QrK+IjyTgRihly2Q==@kvack.org
X-Gm-Message-State: AFuF++m/jK9dQnihpWQa+uYNA3F60VIkl92HYhjVIU+uUwmwsFMYK4Hk
	Pld+ZrlMPabmXytwZ3vPEsrUoQjJ7jtKBQPLIILdp5J6/goapGqyHuE7
X-Gm-Gg: AYBFou060fnuAidSg4Q5xn45Yls1BMwRUeRHCOOk1xkp4w0Hi1lZ91vvkxfM2U+nRwE
	jM/Jvm4xwCFK9McZ8mgAS/+K9LypHcWI+kdMG7A2REXw6OvRGBpR+ANDpWU4YSbe+BhWlMt86Tv
	8rsYSmUzlarX8AHm4i5hKf7Efd2bsfgBJfdiyeH4vhCWjgzFI42VoYXpzpa5Gs3tnbBfUMiSQQ7
	ww2PH2N/LHT6LSEV13diLQaIkYNQcQXyh/VurJp0YA6h6zOuWIh98unL1wIpKPDtMdJXBEm/AC2
	UKwtB0tiN3lFZX3xJUMK7O0t52/Ro/ngIFEl8hlUHfHiU6GTGodMFsTPtTOfVeVQYLFM64/tIb5
	dU7DaDD/F2jMtl5Z5vEYSc5PwHUZL022a7WJrQ2I9cWRYA0XQf1u5lbhsYNv/eGQKEWUY8UQRqW
	tPWZ7SsYhIWNC/IdYfzoJ/LUNo5bv+mrUDeG1neVmvCtobo7OkcwxzFUpyNlpXtvmHoUeBPOlvR
	hOCNzY8GCUGd2RuLyo=
X-Received: by 2002:a05:6a00:1151:b0:85d:84a5:b7bb with SMTP id d2e1a72fcca58-86168d8c2fdmr27300269b3a.18.1788751626985;
        Sun, 06 Sep 2026 20:27:06 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-861527382f0sm3732954b3a.24.2026.09.06.20.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Sep 2026 20:27:06 -0700 (PDT)
Message-ID: <9974bf2a-606b-432d-95ac-2f05f3fa9953@gmail.com>
Date: Mon, 7 Sep 2026 11:26:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 bfoster@redhat.com, djwong@kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com, Joanne Koong <joannelkoong@gmail.com>,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
 <4e166a3d-9012-45ab-a011-0e0ad54143d5@gmail.com>
 <DL7E27LHUEXZ.3B86XR1QN6PP5@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <DL7E27LHUEXZ.3B86XR1QN6PP5@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: g8fakk9stj17npicyk51ansy4rshz36r
X-Rspamd-Queue-Id: 3BB631C0002
X-HE-Tag: 1788751628-202117
X-HE-Meta: U2FsdGVkX1+nYJGrt2Eoj9WYt1QpZSDjvcS3B5Pf2RL+Rzg9MVOMrG8yNRRjYDvUVQPTU1Cxsikfu3NxLhQgmJFi4xeP8Gl/EqL5dtTfao6yHfZGuvq22zcRB29CIhjVyYUncZu1F7gcvx5hlZUzRjCPppi5KQQalUyOjMmHFTZUFMTwjwSm216qd4hciyQpc5zucmnVvcJ6H4mQUyy4cHaRzVwjpb4qH+lYNzBTd7GhzjQoVwjaefQaIFVUXp0DsYn5ebb1X0YzGL2UfaoaklogryJiZ6yX5XnginyeyfxBAYVweIyT/PqxnDdcJSFdx85XPYJtqOzynVLfRT5+s+Z/1yKjlGCFJ2L6KQYvaVotfvuRQ9WYV3/OZfNNjze1pleW2hRA30MNSssjie0UZlVmAUwRipf/+5+kGr6clw+w/CRT+c2df6/c9vDtzJrgvwdROLYBAda/SDS5qzXpSGzUfVTt7GLyo/pwNBgjaZmtcGkN6ANSrYROc7khPF/uIJGfvP34TqqiEPvcW3IXGZ4aMsVnfORiPXqO/tCHeYiek4dlqDbwnhtA5GBBIjLUlBx1eNEIaLTgvS4GvXlFMq87NlorQjqCWsBFkzQIgYiaHAHR4o966ZCCrDU4AhMGsV7gtoUim9l6Nt9ZI1U34nHEfRRpSIrbJTohQISL/b4I/7xjd4oHdFWorGhqhDUyv5KmzzsOQMFwtBgwQjGtbnq/93YtR3C+DbpHHJrhrcsvjWMYa3NTbkBJltIg1c71MVJrzPzH41T6rU5f+hyxMKOPR+ey/jEBAS1SVwDnOID7vUADLLUWjXGg0x6wl6Cw5yzmErWOy3+WyDzzb7ZZLcFNvUfWZre5vsDcQoG1lOvLxvnr7A9CPeo2ZXU2V/TaoY4waLfuJfJZ6lrZI82OiWHP2Jr7prkgcbkuM2+fQkYRaJifcxpTrDFdR94jXHcIpaJd0ejNqSyb7xgfi88
 nRkdfOdS
 aUW3ZTuF2ClwaSHNHiRsmmcDztS7kjRqjHY1IzoQDR4PjDPF0RoL+XTZ7awEVy5GX0Sc3Ec6zmVlV2TmXEJ+hvLlWONnD0/JcoiOjEm5UVxoA7Zh96J3XnDRzkEFOuWWWyTPoTv4aqKWXdRO4Fi98yHtF56RS22T2Pi7NABV3Psl2LYI6TTiHUmnMEi0awqPfapnJZqFoffxYi4rLGDHQsyquVpsbL7Ojm2O6jWOCbpy4W7N+S7lOZblVKGkk0L3focFfK3D1sRk8l2LlCatXIXwxuyfnyf0QZqpP0DZBE6ClxTZpQ+MU114tq0WbETTpgKoi66pAes6IqxEFnfjm98v/Fi94LkZT6y4zp8G1PtjusRXFTxvwbvQVS+4NDUlr5MyVGMehNSMXbl5zSa3fJmLj7EIIi137oG9noSVo4Di4+dmB4AL8+lB25zoG3YhbXaB4XrrzyDux36792jb/xBlQOipiR41x/mMVaF6wmAsaaXTHb9zvaVMfTxwZVI7orQ7d+ei6327kWMNRsHNUibDOGMUw53VDU2xnfhLo1hMZDcmHyKCc7cMsR5EMWuBSNahdcyT0889N0V4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/2026 8:41 PM, Zi Yan wrote:
> On Sat Sep 5, 2026 at 5:15 AM EDT, Zhang Yi wrote:
>> On 9/5/2026 3:31 AM, Zi Yan wrote:
>>> On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> truncate_inode_partial_folio() splits a large folio so that the caller's
>>>> truncate loop can drop the in-range sub-folios while keeping the
>>>> out-of-range tail. The first split at the punch start edge is
>>>> non-uniform, which leaves the sub-folio at the truncation end edge as
>>>> large as possible, this means it may still straddle the range, holding
>>>> both zeroed in-range and valid out-of-range data. The function then
>>>> attempts a second split at offset + length to isolate that tail.
>>>>
>>>> If the second split fails the straddling sub-folio stays merged. The
>>>> function returned true unconditionally on all exit paths of the success
>>>> block, telling the caller it was fully handled. The caller kept its
>>>> default end and the truncate loop truncated every sub-folio below it,
>>>> including the merged straddler, discarding the valid out-of-range tail.
>>>>
>>>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>>>> of the last page:
>>>>
>>>>     truncate_inode_pages_range()
>>>>       truncate_inode_partial_folio()      # same_folio == true
>>>>         1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>>>         folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>>>         2nd split of folio2 fails / cannot lock
>>>>         return true                       # BUG: caller keeps default end
>>>>       end = 3
>>>>       loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>>>
>>>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>>>> folio_split() in truncate operation") replaced the atomic split_folio()
>>>> with folio_split(), whose non-uniform split can partially split a folio
>>>> and leave the end edge merged.
>>>>
>>>> It has gone unnoticed because a dirty large folio normally carries the
>>>> filesystem's private data, for example buffer_head, so
>>>> filemap_release_folio() -> iomap_release_folio() returns false on a
>>>> dirty folio and folio_split() aborts with -EBUSY before any split,
>>>> leaving the straddler safely unsplit. The bug is only reachable on paths
>>>> that produce dirty large folios without filesystem private data, and it
>>>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>>>> attached.
>>>
>>> Thank you for the analysis.
>>>
>>>>
>>>> Rework the contract so the caller is told where to stop instead of
>>>> silently truncating the straddler:
>>>>
>>>>     - Return true only when a split occurred, false otherwise. This
>>>>       clarifies the existing confusing return value semantics.
>>>
>>> Should we do "return false" for not split case as a minmal fix first?
>>>
>>> Something like below. A second patch can optimize on top of it. Let me
>>> know if I miss anything.
>>>
>>> BTW, Claude also mentioned that if min_order > 0 and end is not aligned
>>> to 1UL << min_order, there could be some issue. So
>>>
>>> ret = !folio_split_or_unmap(folio2, split_at2, min_order);
>>>
>>> should be
>>>
>>> unsigned long idx2 = PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;
>>>
>>> ret = !folio_split_or_unmap(folio2, split_at2, min_order) &&
>>> IS_ALIGNED(idx2, 1UL << min_order);
>>>
>>> ?
>>>
>>
>> Hi Zi Yan,
>>
>> Thanks for the minimal fix. I agree with the core observation — the
>> tail is only really isolated when the second split and the boundary
>> alignment both cooperate.  However, I'd like to point out a trade-off:
>> the "return false to make the caller skip the folio" mechanism leads
>> to an incorrect 'start' in truncate_inode_pages_range() and over-keeps
>> the in-range sub-folios.
>>
>> The problem is that the false return value was designed for the case
>> where the folio is unsplit.  Look at the caller:
>>
>>           if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>>                   start = folio_next_index(folio);
>>                   if (same_folio)
>>                           end = folio->index;
>>           }
>>
>> start = folio_next_index(folio); end = folio->index only makes sense
>> when folio is still the whole folio.  But after the first split
>> succeeds, the caller's folio reference has already been transferred to
>> the sub-folio containing split_at, so folio is no longer the whole
>> folio.
>>
>> Concretely, take the commit's example: a 4-page order-2 folio
>> [p0 p1 p2 p3], punched from offset 0 into the middle of p3,
>> min_order == 0:
>>
>>           [p0 p1 p2 p3]  --1st split @p0-->  [p0] [p1] [p2-p3]
>>           folio now points to [p0]
>>           folio2 = [p2-p3]              # p2 zeroed, p3 tail valid
>>           2nd split of [p2-p3] fails    # e.g. -EBUSY, or can't lock
>> 		
>> With your fix, ret becomes false, so the caller runs:
>>
>>           start = folio_next_index([p0]) = 1;
>>           end   = folio->index          = 0;
>>
>> The truncate loop then does while (index < end) -> 1 < 0 -> nothing,
>> and [p0] and [p1] are left in the page cache, even though they are
>> fully inside the punched range and should have been dropped.
>>
>> To be fair, this will not lead to any data-corruption problem because
>> p0 and p1 are already zeroed.  So as a minimal fix to stop the data
>> loss, it is acceptable.  But it still leaves the in-range sub-folios
>> behind and wastes memory, which somewhat reduces the benefit of
>> splitting the folio. So I don't think change the return value alone can
>> solve this problem.
>>
>> What do you think?
>>
> 
> Understood.
> 
> Alternatives are changing folio_split() to make sure folio2 is split.
>  From weakest guarantee to strongest guarantee:
> 
> 1. make folio_split() return with folio2 locked: but others can still
> put a ref on folio2 to fail the subsequent folio2 split.
> 
> 2. make folio_split() accept two split_at, folio_split() does both folio
> and folio2 split internally: but if folio2 split require an xa_node and
> the allocation fails, folio2 split can still fail.
> 
> 3. make folio_split() accept two split_at and preallocate two xa_node
> upfront: this should guarantee folio_split() to either split both folio
> and folio2 or split nothing, but it specializes folio_split() for
> truncate.
> 

I'm afraid even guaranteeing a successful folio2 split is not enough
here. As Joanne pointed out [1], when min_order is not 0, even if folio2
is successfully split and returns true, the folio remains a large folio.
In the outer loop, 'end' still cannot point to the head of the split
folio2, so the entire folio is still incorrectly dropped as a whole,
losing the valid data at the tail.

[1] 
https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/

> I guess for now it might be better to make truncate to handle the
> folio2-not-split situation.
> 

Yeah, agree.

Thanks,
Yi.

