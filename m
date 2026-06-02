Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2958CCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:32:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE006B03CE; Tue,  2 Jun 2026 07:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6616B03D5; Tue,  2 Jun 2026 07:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBB56B03D8; Tue,  2 Jun 2026 07:32:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2AD6B03CE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:32:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED6A01408DA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:32:50 +0000 (UTC)
X-FDA: 84834760500.17.544969E
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C1BE4000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:32:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llXoF477;
	spf=pass (imf27.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWu0sre5Jwby9OB3KDM9noNXPSopPTpmyBRZ89OmKZ8=;
	b=VErVjmzn2wX3v+xWgXq21CGj/cQllsyUDIRkdLovoCVtNrBV+tF+nD8wbcOz49gO/0ZO5F
	9Ouu0V47PfWoVk1bVzePXQJKkRYXD7ZthEUZugp5KVGv8bWehb3eVDlIfDCSUbe1IQIAcq
	4x+fxCWlEEvJJ0DUYTAjs+sl6WDGVOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399969;
	b=DUkvFBes+K1+HzaLE0mRUvabWekkoyMs/A9ERdR/NrwR1jGNJWEfBmzpuRcIilGThL9gtz
	q1cIiMy+UEmETTTo/ZGLe40+f9clwSUkzahtERZ0SZzeqARmzLS3XamSDkRvIWNaULzU0S
	70t5HIVUpsn/WehJYwZI2iUQn3gBZWg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llXoF477;
	spf=pass (imf27.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-841882f8f4bso3918527b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 04:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780399968; x=1781004768; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWu0sre5Jwby9OB3KDM9noNXPSopPTpmyBRZ89OmKZ8=;
        b=llXoF477E4gr+RNJyVwrXEOtx4kddzTuu9aYTaTIRx2gKyktE9M8BdbMZ/2Uz7mQXY
         48W3/5zT7i/N8xrxAAXEo5LzhrTb6dIpoe9EN4KQ8rQyKgbdFwDGoP3FZm4gb1E34UR3
         DMIkoTWykhJI9hv5rYdEciU5dGQWNoQTlaLNY54UHE+JAmFN5NxY1cen7trdmjqTuJpy
         IjLjE6r8kVp2oydI6GjqPCqw2KtgYyJzTjOogseDriGMetIXWBepsLv1oRTOBSC+SRWQ
         uWCis6/DVOFKabJizau7GaYKGlLuuy9HlVltjCGqIGumHVWIKNnOLFtts7g3u4iZQ6CD
         UMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780399968; x=1781004768;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWu0sre5Jwby9OB3KDM9noNXPSopPTpmyBRZ89OmKZ8=;
        b=C+MAuzHPZqjkefaOy/PyM4F13aV9SiXANaafggimoqB5Azjdo2n465J/u8SGuwV9ov
         A7NTbThlg29tC/AyBLbbsCQNDkWN7ixFeoNfuZufxSrSOrW14xuTMFT3OV/3i4+F3zy1
         F6yBQm30UiDaG7cqdq+9r7FelqxvsEfCtHMllw1QWBxBn/FOY8ZK8OgpV+wzqiVYxu1q
         Fr4o3dGcyNqT4XB9hFLn2gTMw4dYihIvc9f+pkK5JzfydNxL8EWMKT3Bx2mPSiame1vQ
         zQrz74MdypaiCpN53iJAcM/erdmjnGoOulAtXCPqaU1MOqr0Wspsc4/P1D8VvEc5Y5P+
         oepA==
X-Forwarded-Encrypted: i=1; AFNElJ+J2+tG/vyPyBFPQrV1ouVV2FTEO9jOIIgQnQFeKAaDsYCawgJAZzmBeflFi2dET4+rpw2iVwHzBw==@kvack.org
X-Gm-Message-State: AOJu0YxHRUbh0NxrEJTDAzdoOqlP155tmGVTjcMDnJv4Ku2FghQyNe0k
	ZFMkErinLYvV+g2KtcHYGfY2tCY22YftvQKzPOylwQZrHyqax6zmDDmT
X-Gm-Gg: Acq92OFwxJuwNegRZmLiz3X6dd7dEPM6xp4BuH1Bi+5GFbu/79umTfGiQeaziPr38ct
	tnA91ESCCnzLGllzcc2D6H4OUPsz1KjwLfj90BDcSXps8gnoebxPbQk/Hpap3OmX975bjO9/wnW
	KGMYFLP+flyqSPDXYwELW9+XtwXA3PFlrB+Eh7FDm3YiSPmH0jd0mMCDB2KhnwHEjnbMnUBggsZ
	Y3hCW3ObyWG/J7fzxHOuQyWl8ICAEdpKvE+A3MpVwDRv/Du3WIlnth38Z1AXyW7O/3uXk2u1Zne
	xFRFuhTkNmp2XzKkvMLomVR1t1aUChB82WSOvuOaIUsSG9Sh7m+c3GOnsNa1hQacxSMKkFRqg/D
	HVZCtprJxIsRm5klRjWYZdSXoWbY5QcRI72muYTVmSCEKeAPZk1TTILhhMCb27oA3cUaBwP2xq3
	lT/HNGQDbPMklWr18NjFtF3+krh8CON3ItI9mJXjkNy605Yc4L8tBp8Q==
X-Received: by 2002:a05:6a00:2389:b0:842:37d3:de21 with SMTP id d2e1a72fcca58-84237d3de5amr11841016b3a.40.1780399967742;
        Tue, 02 Jun 2026 04:32:47 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8423dc9f361sm8310801b3a.24.2026.06.02.04.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 04:32:47 -0700 (PDT)
Message-ID: <22473c1e-8448-fc18-e454-7bfb38e89561@gmail.com>
Date: Tue, 2 Jun 2026 19:32:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <CAKEwX=NoQNXOMDD0uTSOPWHQX-CMNU1dw=zEuFj=eLcS3fB-ow@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=NoQNXOMDD0uTSOPWHQX-CMNU1dw=zEuFj=eLcS3fB-ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C1BE4000F
X-Stat-Signature: gygqir9x8qwirdtt3bt3pnx8uw53fnys
X-HE-Tag: 1780399968-325531
X-HE-Meta: U2FsdGVkX1+DmMEXkK2pzke0YHDmkUW+s+CMR44UKfXaZt/VxdYIhZkF8nBPRlJPVuAapY5hWPgVjB6SnRrV8VVxr1rVY7yWB0NdtUaTZNm2rcnE+Km0ESD/gCgv/hcKMFrqf24J7q0xsQaaevKgEEKTzYwMry8JtnxzHlpWz+P6DhARpxwWWHXoHaA4P/tANDvMBtYX7mILVeyyYfn/ZKzt2rGPlogk5uJQLoHDqG+k1bBdgmtRFdQ4P3MRJOFviLPR+rKFug0wVNcufrbg4QAwDQbV4pc8krh+YdkTCETROul064oItICGEtEeBdayXBIxseHwXfQnVyJrNNxe1y0cqItDvWwj0u5ZyUwv1RdpBMw8NjVs2seu2a+M8k/v+f94nZTHCFtFs3tcWUP9s6tSA9hQXOaMF6a9w39S1nOF0gnzDf2jX8hAhJGgPCsjY8+u1TYCXdTQ5ATs4WLXbCFa+6qxIy+ihhqMrgyw24xy/6OHkdzVJfp/amUJALInMPW3DVUEcc/wyb4/Xx9UXOE4oUNjg/1ertK0HcMRBqWSqnPhh/ryFn0SWA2iJe+YNRg3qXkX8r9jy7Z1mevjULgInQ0bZv+aXo/WiQuiVs7FxzgGCvxDsqwL1cusUp+YSxaUoFCt5r9U/R+haYTg3QbILGkbZRY6VGB6+XREiVT211ozSg+1Ier2mTFuwjN7UjLwF2jMb0GMDP9C7t1RIAuq72PYGjpZFjTKRj/ycIfqc60CQBCQuvx6Y2qzGkZHzq4HYH9oCMxZ0+jlk8dNhv8q8EUkeEWnQTp0jyOTHQ+wuekGePO4YDkDIA9n43EdlMQso02muOCenkCfZnXzpn5PU0YpH/HzeDZbBbti95RncLns9E6Pk2tpL/QKUb1+otursSuDTIJgFuNItC51ePPnNIG1wxtvqc2ystHPYIBBZZoYPPca5IJI2vrShdCSTaNR3kMH63PfxVrfUKp
 T0RZPe+p
 l4JnfLWI9fsxOCQsL5NbAu1kteUYk5cWIXQUXBFSyRLFaZh+2BlCmyhXCYftNxFvFMQnChU1ra4FBVWjqFIDViqzp6woovkWkKG2LodUNCBm8HeYslMCT/Fca4TrsHG5VmKQlRBHT7WurXHGlG5UW2aIpmievPj7Ht2GxeDoztxexAO4tAtJG51EULhhIVkz9YZTUJQxxdLhPJ4fzlRvdMNkRzonfHpMRLFhav2KtvGWsBAdqOPhKvr+zQKQQt2KB+cfvff12a2fInemws/UlybMhNKElqbcBVlUhWRFe2gtHGNhhqcQJAhRyVuaYC7BThmlZ2Hw27OjT6B8B8ZazlvK1pfTYjqTuIlbbqog8MFsrPYw1w6dENRLFkA3pW613npAh2p2pHNpDOjyuRn5oluwa5xPk2bkINWoBVB5HTwlUlZ2OPxPwe2FuW4BXFjYykeILRuGu4syUgY/H2tuJCHOX2TTPgqRRDcifz1icq6LHuGui0Pbzvlt2eNLB0b+8htxQfYz7Wnh9ojuIS78V3kI23aBn/vfhCoos5Pm6AQJCKC/nkSJAfsWc5QLzks8mpGivroUVGGaCvT2QXWh39mhCxLnICCpAqA4m3tBgRJYF5Ijj6A33oXm/j2DVh/rCX2I+lgmyt+Kmvu0aNth5I2olMI5GqZJIpwo0DOEN4jqTbwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/2 01:08, Nhat Pham wrote:
> On Mon, Jun 1, 2026 at 4:07 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/5/30 09:24, Yosry Ahmed wrote:
>>> On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
>>>> From: Hao Jia <jiahao1@lixiang.com>
>>>>
>>>> The zswap background writeback worker shrink_worker() uses a global
>>>> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
>>>> across the online memcgs under root_mem_cgroup.
>>>>
>>>> Proactive writeback also wants a similar per-memcg cursor that is
>>>> scoped to the specified memcg, so that repeated invocations against
>>>> the same memcg make forward progress across its descendant memcgs
>>>> instead of restarting from the first child memcg each time.
>>>
>>> Is this a problem in practice?
>>>
>>> Is the concern the overhead of scanning memcgs repeatedly, or lack of
>>> fairness? I wonder if we should just do writeback in batches from all
>>> memcgs, similar to how reclaim does it, then evaluate at the end if we
>>> need to start over?
>>>
>>
>> Not using a per-cgroup cursor will cause issues for "repeated
>> small-budget calls" cases. For example, repeatedly triggering a 2MB
>> writeback might result in only writing back pages from the first few
>> child memcgs every time. In the worst-case scenario (where the writeback
>> amount is less than WB_BATCH), it might only ever write back from the
>> first child memcg.
>>
>> Similar to how memory reclaim uses mem_cgroup_iter() (via struct
>> mem_cgroup_reclaim_iter) and the old shrink_worker() used
>> zswap_next_shrink, we need a shared cursor here.
> 
> I think each proactive reclaim invocation just walk the entire subtree
> for page reclaim right (see shrink_node_memcgs())? Would that be
> acceptable for you?

Our current approach is very similar to how proactive memory reclaim 
works in shrink_node_memcgs().
shrink_node_memcgs() first calls memcg = mem_cgroup_iter(target_memcg, 
NULL, partial);. By doing this, it uses 
target_memcg->nodeinfo[nid]->iter->position to retrieve the child memcg 
where the last reclaim left off, and then resumes the iteration.

The catch is that zswap can't just reuse 
memcg->nodeinfo[nid]->iter->position, as that would mess up the cursor 
used by the memory reclaim.


> 
> I also wonder if we can at least make this structure dynamically
> allocated... In a system, you only really invoke proactive reclaim
> against a few target cgroups, no?

It is possible to allocate it dynamically, but I am concerned that it 
might introduce a slight performance overhead. We would need to add a 
**check** like if (READ_ONCE(memcg->zswap_wb_iter)) every time 
zswap_mem_cgroup_iter() is called. Furthermore, to handle concurrent 
allocations, we might also need to introduce cmpxchg() to resolve race 
conditions.

The additional code would look something like this:

static struct zswap_wb_iter *get_zswap_wb_iter(struct mem_cgroup *memcg)
{
     struct zswap_wb_iter *iter, *new_iter;

     iter = READ_ONCE(memcg->zswap_wb_iter);
     if (likely(iter))
         return iter;

     new_iter = kzalloc(sizeof(*new_iter), GFP_KERNEL);
     if (!new_iter)
         return NULL;
     spin_lock_init(&new_iter->lock);

     if (cmpxchg(&memcg->zswap_wb_iter, NULL, new_iter) != NULL) {
         /* Lost the race, someone else installed first. */
         kfree(new_iter);
     }
     return READ_ONCE(memcg->zswap_wb_iter);
}

Thanks,
Hao

